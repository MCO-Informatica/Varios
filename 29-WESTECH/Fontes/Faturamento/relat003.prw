#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat003()
	Local oReport := nil
	Local cPerg:= Padr("RELAT003",10)
	
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
	oReport := TReport():New(cNome,"Relatório Pedidos de Compra por Contrato",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SC7"}, 		, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBOC",	"CONTRATO"  	,"@!"	,	13)
	
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Pedidos de Compra", {"SC7"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_FORNECE","TRBOC","Cod.Fornec."		,"@!"				,10)
	TRCell():New(oSection2,"TMP_NREDUZ"   ,"TRBOC","Fornecedor"		,"@!"				,20)
	TRCell():New(oSection2,"TMP_OC"   	,"TRBOC","OC"				,"@!"				,06)
	TRCell():New(oSection2,"TMP_EMISSAO","TRBOC","Emissão"			,""					,12)
	TRCell():New(oSection2,"TMP_ENTREGA","TRBOC","Entrega"			,""					,12)
	TRCell():New(oSection2,"TMP_NGRUPO"	,"TRBOC","Nome Grupo"		,""					,30)
	TRCell():New(oSection2,"TMP_TOTAL"	,"TRBOC","Total c/ Imp."	,"@R 999,999,999.99",14,,,,,"RIGHT")	
	TRCell():New(oSection2,"TMP_TOTALSI","TRBOC","Total s/ Imp."	,"@R 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_IPI"	,"TRBOC","IPI			"	,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_ICMS"	,"TRBOC","ICMS"			    ,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_ISS"	,"TRBOC","ISS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_PIS"	,"TRBOC","PIS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_COFINS"	,"TRBOC","COFINS"			,"@E 999,999,999.99",14,,,,,"RIGHT")
		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBOC->TMP_CONTRATO) },"Subtotal:",.F.)
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
	
	cQuery := "SELECT C7_ITEMCTA AS 'TMP_CONTRATO', C7_NUM as 'TMP_OC', "
	cQuery += "	CAST(C7_EMISSAO as Date) AS 'TMP_EMISSAO', CAST(C7_DATPRF AS DATE) AS 'TMP_ENTREGA', C7_FORNECE AS 'TMP_FORNECE', SA2010.A2_NREDUZ AS 'TMP_NREDUZ', B1_GRUPO AS 'TMP_GRUPO', BM_DESC AS 'TMP_NGRUPO', " 
	cQuery += "	CASE "
	cQuery += "	WHEN C7_MOEDA = '1' "
	cQuery += "		THEN  "
	cQuery += "		Sum(C7_TOTAL) "
    cQuery += "	WHEN C7_MOEDA = '2' 
	cQuery += "		THEN SUM(C7_TOTAL)*M2_MOEDA2 "
	cQuery += "		END AS 'TMP_TOTAL', "
	cQuery += "	CASE  "
    cQuery += "	WHEN C7_MOEDA = '1' "
	cQuery += "		THEN "
	cQuery += "		((SUM(C7_TOTAL)-SUM(C7_VALIPI))-SUM(C7_VALICM)-(SUM(C7_VALISS))-((SUM(C7_TOTAL)-SUM(C7_VALIPI))*0.0760)-((SUM(C7_TOTAL)-SUM(C7_VALIPI))*0.0165)) " 
	cQuery += "	WHEN C7_MOEDA = '2' "
	cQuery += "		THEN "
	cQuery += "		((SUM(C7_TOTAL)-SUM(C7_VALIPI))-SUM(C7_VALICM)-(SUM(C7_VALISS))-((SUM(C7_TOTAL)-SUM(C7_VALIPI))*0.0760)-((SUM(C7_TOTAL)-SUM(C7_VALIPI))*0.0165))*M2_MOEDA2 " 
	cQuery += "		END AS 'TMP_TOTALSI', "
	cQuery += "		SUM(C7_VALIPI) AS 'TMP_IPI', "
	cQuery += "		SUM(C7_VALICM) AS 'TMP_ICMS', "
	cQuery += "		SUM(C7_VALISS) AS 'TMP_ISS', "
	cQuery += "		((SUM(C7_TOTAL)-SUM(C7_VALIPI))*0.0760) AS 'TMP_COFINS', "
	cQuery += "		((SUM(C7_TOTAL)-SUM(C7_VALIPI))*0.0165) AS 'TMP_PIS' "
	cQuery += "	FROM SC7010 "
	cQuery += "	INNER JOIN SA2010 ON C7_FORNECE=SA2010.A2_COD "
    cQuery += "	INNER JOIN SM2010 ON C7_EMISSAO=SM2010.M2_DATA "
	cQuery += "	INNER JOIN SB1010 ON C7_PRODUTO=SB1010.B1_COD "
    cQuery += "	INNER JOIN SBM010 ON B1_GRUPO=SBM010.BM_GRUPO "
    cQuery += "	where SC7010.D_E_L_E_T_ <> '*' AND SM2010.D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*' AND SBM010.D_E_L_E_T_ <> '*' AND SA2010.D_E_L_E_T_ <> '*' AND "
    cQuery += " C7_ITEMCTA     >= '" + MV_PAR01 + "' AND  "
	cQuery += " C7_ITEMCTA     <= '" + MV_PAR02 + "' AND  "
	cQuery += " C7_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " C7_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " C7_FORNECE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " C7_FORNECE    <= '" + MV_PAR06 + "' "
    cQuery += "	GROUP BY C7_NUM, C7_ITEMCTA, C7_FORNECE, A2_NREDUZ, C7_EMISSAO, B1_GRUPO, BM_DESC, C7_ENCER, C7_EMISSAO, C7_DATPRF, C7_MOEDA, M2_MOEDA2 "
    cQuery += "	ORDER BY C7_ITEMCTA, A2_NREDUZ, C7_NUM "
	
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBOC") <> 0
		DbSelectArea("TRBOC")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBOC"	
	
	dbSelectArea("TRBOC")
	TRBOC->(dbGoTop())
	
	oReport:SetMeter(TRBOC->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBOC->TMP_CONTRATO
		IncProc("Imprimindo OC "+alltrim(TRBOC->TMP_CONTRATO))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBOC->TMP_CONTRATO)
					
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBOC->TMP_CONTRATO == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo OC "+alltrim(TRBOC->TMP_OC))
			oSection2:Cell("TMP_FORNECE"):SetValue(TRBOC->TMP_FORNECE)	
			oSection2:Cell("TMP_NREDUZ"):SetValue(TRBOC->TMP_NREDUZ)	
			oSection2:Cell("TMP_OC"):SetValue(TRBOC->TMP_OC)
			
			oSection2:Cell("TMP_EMISSAO"):SetValue(TRBOC->TMP_EMISSAO)
			oSection2:Cell("TMP_ENTREGA"):SetValue(TRBOC->TMP_ENTREGA)
			oSection2:Cell("TMP_NGRUPO"):SetValue(TRBOC->TMP_NGRUPO)
			
			oSection2:Cell("TMP_TOTAL"):SetValue(TRBOC->TMP_TOTAL)
			oSection2:Cell("TMP_TOTAL"):SetAlign("RIGHT")
			
			
			oSection2:Cell("TMP_TOTALSI"):SetValue(TRBOC->TMP_TOTALSI)
			oSection2:Cell("TMP_TOTALSI"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_IPI"):SetValue(TRBOC->TMP_IPI)
			oSection2:Cell("TMP_IPI"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_ICMS"):SetValue(TRBOC->TMP_ICMS)
			oSection2:Cell("TMP_ICMS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_ISS"):SetValue(TRBOC->TMP_ISS)
			oSection2:Cell("TMP_ISS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_PIS"):SetValue(TRBOC->TMP_PIS)
			oSection2:Cell("TMP_PIS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_COFINS"):SetValue(TRBOC->TMP_COFINS)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT") 			
						
			oSection2:Printline()
			

 			TRBOC->(dbSkip())
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
	putSx1(cPerg, "05", "Fornecedor de ?"	  	  , "", "", "mv_ch5", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par05")
	putSx1(cPerg, "06", "Fornecedor até?"	  	  , "", "", "mv_ch6", "C", 10, 0, 0, "G", "", "SA2", "", "", "mv_par06")
return

