#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat021()
	Local oReport := nil
	Local cPerg:= Padr("RELAT021",10)
	
	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.T.)	          
		
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Fixed Asset Report",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=8
	//oReport:cFontBody:="Courier New"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F. 	
	
	
	//Monstando a primeira seção
	//Neste exemplo, a primeira seção será composta por duas colunas, código da NCM e sua descrição
	//Iremos disponibilizar para esta seção apenas a tabela SYD, pois quando você for em personalizar
	//e entrar na primeira seção, você terá todos os outros campos disponíveis, com isso, será
	//permitido a inserção dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas você
	//terá toda a liberdade de modificá-los via relatorio. 
	

		oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SN3"}, 		, .F.	, 	.T.)
		TRCell():New(oSection1,"TMP_GRUPO",	"TRBATF",	"Group"  		,""		,	15)
		TRCell():New(oSection1,"TMP_DESCRI","TRBATF",	"Description"  	,""		,	40)
		TRCell():New(oSection1,"TMP_CONTA"	,"TRBATF","Accounting"		,"@!"	,20)
		
		
		//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
		//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
		//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
		oSection2:= TRSection():New(oReport, "Ativos", {"SN3"}, NIL, .F., .T.)
		//TRCell():New(oSection2,"TMP_GRUPO" 	,"TRBATF","Grupo"			,"@!"				,20)
	
		TRCell():New(oSection2,"TMP_AQUISICAO","TRBATF","Acquisition"		,""					,14)
		TRCell():New(oSection2,"TMP_DESC"	,"TRBATF","Description"		,"@!"					,50)
		TRCell():New(oSection2,"TMP_VLORIG" ,"TRBATF" ,"Original Value"	,"@E 999,999,999.99",14,,,,,"RIGHT")
		TRCell():New(oSection2,"TMP_VLDPR"	,"TRBATF","Current Value"	,"@E 999,999,999.99",14,,,,,"RIGHT")
		TRCell():New(oSection2,"TMP_QTD"	,"TRBATF","Quantity"		,"@E 999,999,999.99",14,,,,,"RIGHT")

		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBATF->TMP_GRUPO) },"Subtotal",.F.)
	TRFunction():New(oSection2:Cell("TMP_VLORIG")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_VLDPR")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local cConta     := ""  
	Local lPrim 	:= .T.	
	oSection2:SetHeaderSection(.T.)
	
	cQuery := "SELECT	N1_GRUPO AS 'TMP_GRUPO', NG_DESCRIC AS 'TMP_DESCRI',N3_HISTOR AS 'TMP_HISTOR',  CAST(N3_AQUISIC AS DATE) AS 'TMP_AQUISICAO', "
	cQuery += "		N3_CBASE+N3_ITEM AS 'TMP_CODBEM', N3_ITEM AS 'TMP_ITEM', N1_DESCRIC AS 'TMP_DESC', N3_CCONTAB AS 'TMP_CONTA', N3_CCUSTO AS 'TMP_CCUSTO', "
	cQuery += "		N3_VORIG1 AS 'TMP_VLORIG', N3_VRDACM1 AS 'TMP_VLDPR', N1_QUANTD AS 'TMP_QTD' "
	cQuery += "	FROM SN3010 "
	cQuery += "	INNER JOIN SN1010 ON SN3010.N3_CBASE = SN1010.N1_CBASE AND SN3010.N3_ITEM = SN1010.N1_ITEM "
	cQuery += "	INNER JOIN SNG010 ON SN1010.N1_GRUPO = SNG010.NG_GRUPO "
	cQuery += "	WHERE SN3010.D_E_L_E_T_ <> '*' AND SN1010.D_E_L_E_T_ <> '*' AND SNG010.D_E_L_E_T_ <> '*' AND N1_BAIXA = '' AND "
	cQuery += " N1_GRUPO     >= '" + MV_PAR01 + "' AND  "
	cQuery += " N1_GRUPO     <= '" + MV_PAR02 + "' AND  "
	cQuery += " N3_AQUISIC    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " N3_AQUISIC    <= '" + DTOS(MV_PAR04) + "' "  
	cQuery += "	ORDER BY  N1_GRUPO, N3_CCONTAB,  N3_AQUISIC, N3_CBASE, N3_ITEM "
	
	
	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBATF") <> 0
		DbSelectArea("TRBATF")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBATF"	
	
	dbSelectArea("TRBATF")
	TRBATF->(dbGoTop())
	
	oReport:SetMeter(TRBATF->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBATF->TMP_GRUPO
		cConta 	:= TRBATF->TMP_CONTA
		
		IncProc("Imprimindo Grupo "+alltrim(TRBATF->TMP_GRUPO))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_GRUPO"):SetValue(TRBATF->TMP_GRUPO)
		oSection1:Cell("TMP_DESCRI"):SetValue(TRBATF->TMP_DESCRI)
		oSection1:Cell("TMP_CONTA"):SetValue(TRBATF->TMP_CONTA)

						
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBATF->TMP_GRUPO == cNcm .AND. TRBATF->TMP_CONTA == cConta
			oReport:IncMeter()		
		
			IncProc("Imprimindo Ativo "+alltrim(TRBATF->TMP_GRUPO))
			//oSection2:Cell("TMP_GRUPO"):SetValue(TRBATF->TMP_GRUPO)
			
			oSection2:Cell("TMP_AQUISICAO"):SetValue(TRBATF->TMP_AQUISICAO)
						
			oSection2:Cell("TMP_DESC"):SetValue(TRBATF->TMP_DESC)
			
			
			oSection2:Cell("TMP_VLORIG"):SetValue(TRBATF->TMP_VLORIG)
			oSection2:Cell("TMP_VLORIG"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_VLDPR"):SetValue(TRBATF->TMP_VLDPR)
			oSection2:Cell("TMP_VLDPR"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_QTD"):SetValue(TRBATF->TMP_QTD)
			oSection2:Cell("TMP_QTD"):SetAlign("RIGHT")
			

			oSection2:Printline()
			

 			TRBATF->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Grupo de ?"	  , "", "", "mv_ch1", "C", 20, 0, 0, "G", "", "SNG"	, ""		, "", "mv_par01")
	putSx1(cPerg, "02", "Grupo até?"	  , "", "", "mv_ch2", "C", 20, 0, 0, "G", "", "SNG"	, ""		, "", "mv_par02")
	putSx1(cPerg, "03", "Aquisição de?"	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", ""	, ""		, "", "mv_par03")
	putSx1(cPerg, "04", "Aquisição até?"  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", ""	, ""		, "", "mv_par04")
	
return
