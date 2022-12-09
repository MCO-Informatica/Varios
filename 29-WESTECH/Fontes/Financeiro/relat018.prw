#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat018()
	Local oReport := nil
	Local cPerg:= Padr("RELAT018",10)
	
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
	oReport := TReport():New(cNome,"Tributos (Créditos - Documentos de Entrada)",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	oReport:lBold:= .T.
	oReport:nFontBody:=7
	//oReport:cFontBody:="Arial"
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SF1"}, 			, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_DTENT",	"TRBFIN",	"Ano/Mês Entrada"  		,"@!"	,	16)
	
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Tributos (Créditos - Documentos de Entrada)", {"SF1"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"TMP_DOC"		,"TRBFIN","Data Entrada"	,"@!"				,12)
	TRCell():New(oSection2,"TMP_DTENTRADA"	,"TRBFIN","Data Entrada"	,"@!"				,12)
	TRCell():New(oSection2,"TMP_ICMS"		,"TRBFIN","ICMS"			,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_IPI"		,"TRBFIN","IPI"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_PIS"		,"TRBFIN","PIS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_COFINS"		,"TRBFIN","COFINS"			,"@E 999,999,999.99",14,,,,,"RIGHT")

	oBreak1 := TRBreak():New(oSection2,{|| (TRBFIN->TMP_DTENT) },"Subtotal:",.F.)
	//TRFunction():New(oSection2:Cell("TMP_DOC")		,NIL,"COUNT",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_ICMS")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_IPI")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_PIS")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_COFINS")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	
	
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
	Local lPrim 	:= .T.	
	oSection2:SetHeaderSection(.T.)
	      

	//Monto minha consulta conforme parametros passado
	// -- SELECT DE NF EMITIDAS REMOVENDO NFS CANCELADAS E DEVOLUCAO
	
	cQuery := "SELECT  CONVERT(VARCHAR(4),YEAR(D1_DTDIGIT))+'/'+CONVERT(VARCHAR(2),MONTH(D1_DTDIGIT)) AS 'TMP_DTENT', CAST(D1_DTDIGIT AS DATE) AS 'TMP_DTENTRADA', "
    cQuery += "	    SUM(D1_VALIPI) AS 'TMP_IPI', "
	cQuery += "	    SUM(D1_VALICM) as 'TMP_ICMS', "
    cQuery += "	    SUM(D1_VALISS) AS 'TMP_ISS',  "
    cQuery += "	    SUM(D1_VALIMP6) AS 'TMP_PIS', "
	cQuery += "		SUM(D1_VALIMP5) AS 'TMP_COFINS' "
    cQuery += "	    FROM SD1010 "
	cQuery += "		INNER JOIN SA2010 ON D1_FORNECE = SA2010.A2_COD "
	cQuery += "	WHERE	REPLACE(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA,' ','') 	NOT IN (SELECT REPLACE(D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA,' ','')  "
	cQuery += "	FROM SD2010 WHERE D2_TIPO = 'D' AND D_E_L_E_T_ <> '*')  AND "
	cQuery += "		SD1010.D_E_L_E_T_ <> '*' AND SA2010.D_E_L_E_T_ <> '*' AND D1_VALICM > 0 OR D1_VALIPI > 0 OR D1_VALISS > 0 OR D1_VALIMP6 > 0 OR D1_VALIMP5 > 0 AND "
	cQuery += " D1_DTDIGIT    >= '" + DTOS(MV_PAR01) + "' AND  " 
	cQuery += " D1_DTDIGIT    <= '" + DTOS(MV_PAR02) + "' "
	cQuery += "	GROUP BY D1_DTDIGIT "
	cQuery += "	ORDER BY D1_DTDIGIT "
	
	

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBFIN") <> 0
		DbSelectArea("TRBFIN")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBFIN"	
	
	dbSelectArea("TRBFIN")
	TRBFIN->(dbGoTop())
	
	oReport:SetMeter(TRBFIN->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBFIN->TMP_DTENT
		IncProc("Tributos"+alltrim(TRBFIN->TMP_DTENT))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_DTENT"):SetValue(TRBFIN->TMP_DTENT)
		

		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBFIN->TMP_DTENT == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo Tributos  "+alltrim(TRBFIN->TMP_DTENT))
			//oSection2:Cell("TMP_DOC"):SetValue(TRBFIN->TMP_DOC)	
			oSection2:Cell("TMP_DTENTRADA"):SetValue(TRBFIN->TMP_DTENTRADA)	
			oSection2:Cell("TMP_IPI"):SetValue(TRBFIN->TMP_IPI)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT")
				
			oSection2:Cell("TMP_PIS"):SetValue(TRBFIN->TMP_PIS)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_PIS"):SetValue(TRBFIN->TMP_PIS)
			oSection2:Cell("TMP_PIS"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_COFINS"):SetValue(TRBFIN->TMP_COFINS)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT")
			
			oSection2:Printline()

 			TRBFIN->(dbSkip())
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
	putSx1(cPerg, "01", "Data Entrada de?"  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Data Entrada até?"  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par02")

return






