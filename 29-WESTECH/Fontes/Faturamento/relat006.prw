#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat006()
	Local oReport := nil
	Local cPerg:= Padr("RELAT006",10)
	
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
	oReport := TReport():New(cNome,"Relatório Documento de Entrada por Contrato",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()    
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SD1"}, 		, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBDC",	"CONTRATO"  	,"@!"	,	13)
	
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Documento de Entrada", {"SD1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_FORNECE","TRBDC","Código"			,"@!"				,10)
	TRCell():New(oSection2,"TMP_NOME"	,"TRBDC","Fornecedor"		,"@!"				,40)
	TRCell():New(oSection2,"TMP_DOC"   	,"TRBDC","Doc.Entr."		,"@!"				,09)
	TRCell():New(oSection2,"TMP_CFOP"  	,"TRBDC","CFOP."			,"@!"				,04)
	TRCell():New(oSection2,"TMP_EMISSAO","TRBDC","Emissão"			,""					,12)
	TRCell():New(oSection2,"TMP_GRUPO"	,"TRBDC","Gr.Produto"		,""					,30)
	TRCell():New(oSection2,"TMP_TOTAL"	,"TRBDC","Total c/ Imp."	,"@R 999,999,999.99",14,,,,,"RIGHT")	
	TRCell():New(oSection2,"TMP_TOTALSI","TRBDC","Total s/ Imp."	,"@R 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_IPI"	,"TRBDC","IPI			"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_ICMS"	,"TRBDC","ICMS"			    ,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_ISS"	,"TRBDC","ISS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_PIS"	,"TRBDC","PIS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_COFINS"	,"TRBDC","COFINS"			,"@E 999,999,999.99",14,,,,,"RIGHT")
		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBDC->TMP_CONTRATO) },"Subtotal:",.F.)
	TRFunction():New(oSection2:Cell("TMP_DOC")		,NIL,"COUNT",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_TOTAL")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_TOTALSI")	,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_IPI")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_ICMS")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
	TRFunction():New(oSection2:Cell("TMP_ISS")		,NIL,"SUM",oBreak1,,,,.F.,.T.)
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
	 cQuery := "SELECT D1_ITEMCTA AS 'TMP_CONTRATO', D1_DOC AS 'TMP_DOC', D1_SERIE AS 'TMP_SERIE', D1_CF AS 'TMP_CFOP',  CAST(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO',  "  
	cQuery += " 		D1_FORNECE AS 'TMP_FORNECE', A2_NOME AS 'TMP_NOME', "   
	cQuery += "		BM_DESC AS 'TMP_GRUPO', "    
	cQuery += "		SUM(D1_TOTAL) AS 'TMP_TOTAL', "  
    cQuery += "    	(SUM(D1_TOTAL)-SUM(D1_VALIPI))-SUM(D1_VALICM)-SUM(D1_VALISS)-SUM(D1_VALIMP6)-SUM(D1_VALIMP5) AS 'TMP_TOTALSI',  "  
    cQuery += "    	SUM(D1_VALIPI) AS 'TMP_IPI', "  
	cQuery += "    	SUM(D1_VALICM) as 'TMP_ICMS', "  
    cQuery += "    	SUM(D1_VALISS) AS 'TMP_ISS',  "  
    cQuery += "    	SUM(D1_VALIMP6) AS 'TMP_PIS', "  
	cQuery += "		SUM(D1_VALIMP5) AS 'TMP_COFINS' "  
	cQuery += "FROM SD1010 "  
	cQuery += "	 	INNER JOIN SA2010 ON D1_FORNECE = SA2010.A2_COD "  
	cQuery += "	 	INNER JOIN SB1010 ON D1_COD = B1_COD "  
	cQuery += "	 	INNER JOIN SBM010 ON B1_GRUPO = BM_GRUPO  "  
	cQuery += "	WHERE REPLACE(D1_DOC+D1_SERIE+A2_COD+A2_LOJA+D1_COD,' ','')  "  
	cQuery += "			NOT IN (SELECT REPLACE(D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA+D2_COD,' ','') FROM SD2010 WHERE D2_TIPO = 'D' AND D_E_L_E_T_ <> '*')  AND "  
  	cQuery += "			SD1010.D_E_L_E_T_ <> '*' AND SA2010.D_E_L_E_T_ <> '*' AND SBM010.D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*' AND " 
  	cQuery += " D1_ITEMCTA    >= '" + MV_PAR01 + "' AND  "
	cQuery += " D1_ITEMCTA    <= '" + MV_PAR02 + "' AND  "
	cQuery += " D1_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D1_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D1_FORNECE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D1_FORNECE    <= '" + MV_PAR06 + "' AND "
	cQuery += " D1_DOC    	  >= '" + MV_PAR07 + "' AND  "
	cQuery += " D1_DOC    	  <= '" + MV_PAR08 + "' " 
  	cQuery += "	GROUP BY D1_DOC, D1_SERIE, D1_CF, D1_ITEMCTA, D1_EMISSAO, D1_FORNECE, A2_NOME, A2_COD, A2_LOJA, BM_DESC  "  
  	cQuery += "	ORDER BY  D1_ITEMCTA, D1_FORNECE, D1_DOC  " 
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBDC") <> 0
		DbSelectArea("TRBDC")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBDC"	
	
	dbSelectArea("TRBDC")
	TRBDC->(dbGoTop())
	
	oReport:SetMeter(TRBDC->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBDC->TMP_CONTRATO
		IncProc("Imprimindo OC "+alltrim(TRBDC->TMP_CONTRATO))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBDC->TMP_CONTRATO)
					
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBDC->TMP_CONTRATO == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo Documento de Entrada "+alltrim(TRBDC->TMP_DOC))
			oSection2:Cell("TMP_FORNECE"):SetValue(TRBDC->TMP_FORNECE)	
			oSection2:Cell("TMP_NOME"):SetValue(TRBDC->TMP_NOME)	
			oSection2:Cell("TMP_DOC"):SetValue(TRBDC->TMP_DOC)
			oSection2:Cell("TMP_CFOP"):SetValue(TRBDC->TMP_CFOP)
			oSection2:Cell("TMP_EMISSAO"):SetValue(TRBDC->TMP_EMISSAO)
			oSection2:Cell("TMP_GRUPO"):SetValue(TRBDC->TMP_GRUPO)
			
			oSection2:Cell("TMP_TOTAL"):SetValue(TRBDC->TMP_TOTAL)
			oSection2:Cell("TMP_TOTAL"):SetAlign("RIGHT")
			
			
			oSection2:Cell("TMP_TOTALSI"):SetValue(TRBDC->TMP_TOTALSI)
			oSection2:Cell("TMP_TOTALSI"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_IPI"):SetValue(TRBDC->TMP_IPI)
			oSection2:Cell("TMP_IPI"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_ICMS"):SetValue(TRBDC->TMP_ICMS)
			oSection2:Cell("TMP_ICMS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_ISS"):SetValue(TRBDC->TMP_ISS)
			oSection2:Cell("TMP_ISS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_PIS"):SetValue(TRBDC->TMP_PIS)
			oSection2:Cell("TMP_PIS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_COFINS"):SetValue(TRBDC->TMP_COFINS)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT") 			
						
			oSection2:Printline()

 			TRBDC->(dbSkip())
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
	putSx1(cPerg, "01", "Item Conta de ?"	  , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par01")
	putSx1(cPerg, "02", "Item Conta até?"	  , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "CTD", "", "", "mv_par02")
	putSx1(cPerg, "03", "Emissão de?"	  	  , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "mv_par03")
	putSx1(cPerg, "04", "Emissão até?"	  	  , "", "", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "mv_par04")
	putSx1(cPerg, "05", "Fornecedor de ?"	  , "", "", "mv_ch5", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par05")
	putSx1(cPerg, "06", "Fornecedor até?"	  , "", "", "mv_ch6", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par06")
	putSx1(cPerg, "07", "Doc. Entrada de ?"	  , "", "", "mv_ch7", "C", 09, 0, 0, "G", "", "SF1", "", "", "mv_par07")
	putSx1(cPerg, "08", "Doc. Entrada até?"	  , "", "", "mv_ch8", "C", 09, 0, 0, "G", "", "SF1", "", "", "mv_par08")
return





