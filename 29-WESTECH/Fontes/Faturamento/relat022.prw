#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat022()
	Local oReport := nil
	Local cPerg:= Padr("RELAT022",10)
	
	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando dispon�vel no bot�o a��es relacionadas
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
	oReport := TReport():New(cNome,"Relat�rio Ativo Fixo",cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	oReport:SetLandScape()    
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=8
	//oReport:cFontBody:="Courier New"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	oReport:lParamPage := .F. 	
	
	
	//Monstando a primeira se��o
	//Neste exemplo, a primeira se��o ser� composta por duas colunas, c�digo da NCM e sua descri��o
	//Iremos disponibilizar para esta se��o apenas a tabela SYD, pois quando voc� for em personalizar
	//e entrar na primeira se��o, voc� ter� todos os outros campos dispon�veis, com isso, ser�
	//permitido a inser��o dos outros campos
	//Neste exemplo, tamb�m, j� deixarei definido o nome dos campos, mascara e tamanho, mas voc�
	//ter� toda a liberdade de modific�-los via relatorio. 
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SN3"}, 		, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_AQUIS1",	"TRBATF",	"Aquisi��o"  	,""		,	22)
	TRCell():New(oSection1,"TMP_GRUPO" 	,"TRBATF","Grupo"			,"@!"				,20)
	TRCell():New(oSection1,"TMP_ITEM" 	,"TRBATF","Item"			,"@!"				,10)
	TRCell():New(oSection1,"TMP_DESCRI"	,"TRBATF","Descri��o"		,"@!"				,40)
	TRCell():New(oSection1,"TMP_CONTA"	,"TRBATF","Conta"			,"@!"				,20)
	TRCell():New(oSection1,"TMP_CCUSTO"	,"TRBATF","Centro de Custo"	,"@!"				,16)
	TRCell():New(oSection1,"TMP_QTD"	,"TRBATF","Quantidade"		,"@E 999,999,999.99",14,,,,,"RIGHT")
	
	//A segunda se��o, ser� apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb�m a tabela de NCM, com isso, voc� poderia incluir os campos da tabela
	//SYD.Semelhante a se��o 1, defino o titulo e tamanho das colunas
	TRCell():New(oSection2,"TMP_DTDPR"	,"TRBATF","Deprecia��o"	,"@!"				,16)	
	TRCell():New(oSection2,"TMP_VLDPR2"	,"TRBATF","Valor Atual"		,"@E 999,999,999.99",14,,,,,"RIGHT")
	
	
		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBATF->TMP_AQUIS1) },"Subtotal",.F.)
	TRFunction():New(oSection2:Cell("TMP_VLDPR2")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por se��o
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cNcm      := ""  
	Local cQtd      := ""   
	Local lPrim 	:= .T.	
	oSection2:SetHeaderSection(.T.)
	
		
	cQuery := "SELECT	CONVERT(VARCHAR(4),YEAR(N3_AQUISIC))+'/'+CONVERT(VARCHAR(2),MONTH(N3_AQUISIC)) AS 'TMP_DTENT', CAST(N3_AQUISIC AS DATE) AS 'TMP_AQUISICAO', " 
	cQuery += "		N3_CBASE AS 'TMP_GRUPO', N3_ITEM AS 'TMP_ITEM', N1_DESCRIC AS 'TMP_DESCRI', N3_CCONTAB AS 'TMP_CONTA', N3_CCUSTO AS 'TMP_CCUSTO', "
	cQuery += "		N3_VORIG1 AS 'TMP_VLORIG', N3_VRDACM1 AS 'TMP_VLDPR', N1_QUANTD AS 'TMP_QTD', N4_QUANTD AS 'TMP_QTDDPR', N4_VLROC1 AS 'TMP_VLDPR2', CAST(N3_DINDEPR AS DATE) AS 'TMP_DTDPR' "
	cQuery += "	FROM SN3010 "
	cQuery += "	INNER JOIN SN1010 ON SN3010.N3_CBASE = SN1010.N1_CBASE AND SN3010.N3_ITEM = SN1010.N1_ITEM "
	cQuery += "	INNER JOIN SN4010 ON SN3010.N3_CBASE = SN4010.N4_CBASE AND SN3010.N3_ITEM = SN4010.N4_ITEM "
	cQuery += "	WHERE SN3010.D_E_L_E_T_ <> '*' AND SN1010.D_E_L_E_T_ <> '*' AND SN4010.D_E_L_E_T_ <> '*'  ORDER BY  N3_AQUISIC, N3_CBASE, N3_ITEM, N1_QUANTD DESC "
	
	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO
 	/*
	cQuery += "											 D2_CF BETWEEN '6551' AND '6551') AND "
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' GROUP BY D2_DOC, D2_SERIE, D2_CF, D2_ITEMCC, D2_EMISSAO, D2_CLIENTE, A1_NOME ORDER BY D2_ITEMCC, D2_DOC "
	*/
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
	cQtd 	:= TRBATF->TMP_QTD
		
	//Irei percorrer todos os meus registros
	While !Eof() .AND. cQtd > 0
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira se��o
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBATF->TMP_AQUIS1
		cQtd 	:= TRBATF->TMP_QTD
		IncProc("Imprimindo NFE "+alltrim(TRBATF->TMP_AQUIS1))
		
		//imprimo a primeira se��o				
		oSection1:Cell("TMP_AQUIS1"):SetValue(TRBATF->TMP_AQUIS1)
		oSection1:Cell("TMP_ITEM"):SetValue(TRBATF->TMP_ITEM)
		oSection1:Cell("TMP_DESCRI"):SetValue(TRBATF->TMP_DESCRI)
		oSection1:Cell("TMP_CONTA"):SetValue(TRBATF->TMP_CONTA)
		oSection1:Cell("TMP_CCUSTO"):SetValue(TRBATF->TMP_CCUSTO)
		
		oSection1:Cell("TMP_VLORIG"):SetValue(TRBATF->TMP_VLORIG)
		oSection1:Cell("TMP_VLORIG"):SetAlign("RIGHT")
		
		oSection1:Cell("TMP_VLDPR"):SetValue(TRBATF->TMP_VLDPR)
		oSection1:Cell("TMP_VLDPR"):SetAlign("RIGHT")
			
		oSection1:Cell("TMP_QTD"):SetValue(TRBATF->TMP_QTD)
		oSection1:Cell("TMP_QTD"):SetAlign("RIGHT")
		

						
		oSection1:Printline()
		
		//inicializo a segunda se��o
		oSection2:init()
		
		//verifico se o codigo da NCM � mesmo, se sim, imprimo o produto
		While TRBATF->TMP_AQUIS1 == cNcm .AND. cQtd = 0
			oReport:IncMeter()		
		
			IncProc("Imprimindo NFE "+alltrim(TRBATF->TMP_AQUIS1))
			
			oSection2:Cell("TMP_DTDPR"):SetValue(TRBATF->TMP_DTDPR)
			oSection2:Cell("TMP_VLDPR2"):SetValue(TRBATF->TMP_VLDPR2)

			oSection2:Printline()
			

 			TRBATF->(dbSkip())
 		EndDo		
 		//finalizo a segunda se��o para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira se��o
		oSection1:Finish()
	Enddo
Return

static function ajustaSx1(cPerg)
	//Aqui utilizo a fun��o putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "Grupo de ?"	  , "", "", "mv_ch1", "C", 20, 0, 0, "G", "", "SN1", "", "", "mv_par01")
	putSx1(cPerg, "02", "Grupo at�?"	  , "", "", "mv_ch2", "C", 20, 0, 0, "G", "", "SN1", "", "", "mv_par02")
	putSx1(cPerg, "03", "Aquisi��o de?"	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Aquisi��o at�?"  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")

return

