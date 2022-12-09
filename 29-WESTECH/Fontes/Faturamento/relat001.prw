#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function relat001()
	Local oReport := nil
	Local cPerg:= Padr("RELAT001",10)
	
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
	oReport := TReport():New(cNome,"Relatório de Faturamento por Contrato",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetLandScape()    
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
	oSection1:= TRSection():New(oReport, 	"NCM",	 	{"SD2"}, 		, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_CONTRATO",	"TRBNFE",	"CONTRATO"  	,"@!"	,	13)
	TRCell():New(oSection1,"TMP_CLIENTE"  ,	"TRBNFE",	"Código"		,"@!"	,	06)
	TRCell():New(oSection1,"TMP_NOME"  ,	"TRBNFE",	"Cliente"		,"@!"	,	40)
	TRCell():New(oSection1,"TMP_VDCI"  ,	"TRBNFE",	"Valor Venda c/ Imp.","@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VDSI"  ,	"TRBNFE",	"s/ Imp.","@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VDCID"  ,	"TRBNFE",	"c/ Imp.US$.","@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VDSID"  ,	"TRBNFE",	"s/ Imp.US$","@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VDCIR"  ,	"TRBNFE",	"c/ Imp. Rev.","@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_VDSIR"  ,	"TRBNFE",	"s/ Imp. Rev.","@E 999,999,999.99",14,,,,,"RIGHT")
	
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Notas de Saída", {"SD2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TMP_DOC"   	,"TRBNFE","NF"				,"@!"				,06)
	TRCell():New(oSection2,"TMP_SERIE" 	,"TRBNFE","Série"			,"@!"				,05)
	TRCell():New(oSection2,"TMP_CFOP" 	,"TRBNFE","CFOP"			,"@E 999999"		,06)
	TRCell():New(oSection2,"TMP_EMISSAO","TRBNFE","Emissão"			,""					,10)
	TRCell():New(oSection2,"TMP_TOTAL"	,"TRBNFE","Total c/ Imp."	,"@R 999,999,999.99",14,,,,,"RIGHT")	
	TRCell():New(oSection2,"TMP_TOTALSI","TRBNFE","Total s/ Imp."	,"@R 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_IPI"	,"TRBNFE","IPI"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_ICMS"	,"TRBNFE","ICMS"			,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_ISS"	,"TRBNFE","ISS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_PIS"	,"TRBNFE","PIS"				,"@E 999,999,999.99",14,,,,,"RIGHT")
	TRCell():New(oSection2,"TMP_COFINS"	,"TRBNFE","COFINS"			,"@E 999,999,999.99",14,,,,,"RIGHT")
		
	oBreak1 := TRBreak():New(oSection2,{|| (TRBNFE->TMP_CONTRATO) },"Subtotal",.F.)
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
 	cQuery := "SELECT D2_ITEMCC AS 'TMP_CONTRATO', D2_DOC AS 'TMP_DOC', D2_SERIE AS 'TMP_SERIE', D2_CF AS 'TMP_CFOP',  CAST(D2_EMISSAO AS DATE) AS 'TMP_EMISSAO', D2_CLIENTE AS 'TMP_CLIENTE', A1_NOME AS 'TMP_NOME', "  
	cQuery += "		SUM(D2_VALBRUT) AS 'TMP_TOTAL', "
    cQuery += "	    (SUM(D2_VALBRUT)-SUM(D2_VALIPI))-SUM(D2_VALICM)-SUM(D2_VALISS)-SUM(D2_VALIMP6)-SUM(D2_VALIMP5) AS 'TMP_TOTALSI', " 
    cQuery += "	    SUM(D2_VALIPI) AS 'TMP_IPI', "
	cQuery += "	    SUM(D2_VALICM) as 'TMP_ICMS', "
    cQuery += "	    SUM(D2_VALISS) AS 'TMP_ISS', " 
    cQuery += "	    SUM(D2_VALIMP6) AS 'TMP_PIS', " 
    cQuery += "	    SUM(D2_VALIMP5) AS 'TMP_COFINS', " 
    cQuery += "	  	CTD_XVDCI AS 'TMP_VDCI',  "
	cQuery += "	   	CTD_XVDSI AS 'TMP_VDSI',   "
	cQuery += "	  	CTD_XVDCIR AS 'TMP_VDCIR',  "
	cQuery += "	   	CTD_XVDSIR AS 'TMP_VDSIR'   "
    //cQuery += "	(SELECT CTD_XVDCI FROM CTD010 WHERE CTD_ITEM = D2_ITEMCC) AS 'TMP_VDCI', "
	//cQuery += "	(SELECT CTD_XVDSI FROM CTD010 WHERE CTD_ITEM = D2_ITEMCC) AS 'TMP_VDSI', "
   //	cQuery += "	(SELECT CTD_XVDCID FROM CTD010 WHERE CTD_ITEM = D2_ITEMCC) AS 'TMP_VDCID', "
   //	cQuery += "	(SELECT CTD_XVDSID FROM CTD010 WHERE CTD_ITEM = D2_ITEMCC) AS 'TMP_VDSID'  "
    cQuery += "	    FROM SD2010 "
	cQuery += "		INNER JOIN SA1010 ON D2_CLIENTE = SA1010.A1_COD " 
	cQuery += " 	INNER JOIN CTD010 ON D2_ITEMCC = CTD_ITEM "  
	cQuery += "	WHERE D2_DOC NOT IN (SELECT F3_NFISCAL FROM SF3010 WHERE F3_DTCANC <> '') AND D2_DOC NOT IN (SELECT SUBSTRING(F3_OBSERV,16,6) AS NFDEV FROM SF3010 WHERE F3_TIPO = 'D') AND "
	cQuery += "	D2_CF IN (SELECT D2_CF FROM SD2010 WHERE "
	cQuery += "											 D2_CF BETWEEN '5101' AND '5125' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR " 
	cQuery += "											 D2_CF BETWEEN '5551' AND '5551' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR " 
	cQuery += "											 D2_CF BETWEEN '5922' AND '5922' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR "  
	cQuery += "											 D2_CF BETWEEN '5933' AND '5933' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR " 
	cQuery += "											 D2_CF BETWEEN '6101' AND '6106' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR " 
	cQuery += "											 D2_CF BETWEEN '6109' AND '6120' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR " 
	cQuery += "											 D2_CF BETWEEN '6122' AND '6125' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
  	cQuery += " OR "  
  	cQuery += "											 D2_CF BETWEEN '6551' AND '6551') AND "
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR "  
	cQuery += "											 D2_CF BETWEEN '6933' AND '6933' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR "
	cQuery += "											 D2_CF BETWEEN '7101' AND '7933' AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
	cQuery += " OR "   
	cQuery += "											 D2_CF BETWEEN '7949' AND '7949' AND D2_SERIE = 'SER'  AND"
	cQuery += " D2_ITEMCC     >= '" + MV_PAR01 + "' AND  "
	cQuery += " D2_ITEMCC     <= '" + MV_PAR02 + "' AND  "
	cQuery += " D2_EMISSAO    >= '" + DTOS(MV_PAR03) + "' AND  "
	cQuery += " D2_EMISSAO    <= '" + DTOS(MV_PAR04) + "' AND  "
	cQuery += " D2_CLIENTE    >= '" + MV_PAR05 + "' AND  "
	cQuery += " D2_CLIENTE    <= '" + MV_PAR06 + "' AND  "
  	cQuery += "	SD2010.D_E_L_E_T_ <> '*' AND CTD010.D_E_L_E_T_ <> '*' "
  	cQuery += "	GROUP BY D2_DOC, D2_SERIE, D2_CF, D2_ITEMCC, D2_EMISSAO, D2_CLIENTE, A1_NOME,CTD_XVDCI,CTD_XVDSI,CTD_XVDCIR,CTD_XVDSIR ORDER BY D2_ITEMCC, D2_DOC "
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBNFE") <> 0
		DbSelectArea("TRBNFE")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBNFE"	
	
	dbSelectArea("TRBNFE")
	TRBNFE->(dbGoTop())
	
	oReport:SetMeter(TRBNFE->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= TRBNFE->TMP_CONTRATO
		IncProc("Imprimindo NFE "+alltrim(TRBNFE->TMP_CONTRATO))
		
		//imprimo a primeira seção				
		oSection1:Cell("TMP_CONTRATO"):SetValue(TRBNFE->TMP_CONTRATO)
		oSection1:Cell("TMP_CLIENTE"):SetValue(TRBNFE->TMP_CLIENTE)	
		oSection1:Cell("TMP_NOME"):SetValue(TRBNFE->TMP_NOME)
		oSection1:Cell("TMP_VDCI"):SetValue(TRBNFE->TMP_VDCI)
						
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While TRBNFE->TMP_CONTRATO == cNcm
			oReport:IncMeter()		
		
			IncProc("Imprimindo NFE "+alltrim(TRBNFE->TMP_DOC))
			oSection2:Cell("TMP_DOC"):SetValue(TRBNFE->TMP_DOC)
			
			
			oSection2:Cell("TMP_SERIE"):SetValue(TRBNFE->TMP_SERIE)
			oSection2:Cell("TMP_CFOP"):SetValue(TRBNFE->TMP_CFOP)
			oSection2:Cell("TMP_EMISSAO"):SetValue(TRBNFE->TMP_EMISSAO)
			
			oSection2:Cell("TMP_TOTAL"):SetValue(TRBNFE->TMP_TOTAL)
			oSection2:Cell("TMP_TOTAL"):SetAlign("RIGHT")
			
			
			oSection2:Cell("TMP_TOTALSI"):SetValue(TRBNFE->TMP_TOTALSI)
			oSection2:Cell("TMP_TOTALSI"):SetAlign("RIGHT")
			
			oSection2:Cell("TMP_IPI"):SetValue(TRBNFE->TMP_IPI)
			oSection2:Cell("TMP_IPI"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_ICMS"):SetValue(TRBNFE->TMP_ICMS)
			oSection2:Cell("TMP_ICMS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_ISS"):SetValue(TRBNFE->TMP_ISS)
			oSection2:Cell("TMP_ISS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_PIS"):SetValue(TRBNFE->TMP_PIS)
			oSection2:Cell("TMP_PIS"):SetAlign("RIGHT") 
			
			oSection2:Cell("TMP_COFINS"):SetValue(TRBNFE->TMP_COFINS)
			oSection2:Cell("TMP_COFINS"):SetAlign("RIGHT") 			
						
			oSection2:Printline()
			

 			TRBNFE->(dbSkip())
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
	putSx1(cPerg, "05", "Cliente de ?"	  	  , "", "", "mv_ch5", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par05")
	putSx1(cPerg, "06", "Cliente até?"	  	  , "", "", "mv_ch6", "C", 10, 0, 0, "G", "", "SA1", "", "", "mv_par06")
return