#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

user function zRelPrevV()
	
	Local oReport := nil
	Local cPerg:= Padr("ZRELPREVV",10)


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
	oReport := TReport():New(cNome,"Previsão de Vendas " ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:ShowParamPage()
	oReport:lParamPage := .T.
	oReport:SetLandScape()
	oReport:SetTotalInLine(.T.)
	oReport:lBold:= .T.
	oReport:nFontBody:=6	
	//oReport:cFontBody:="Arial"
	oReport:SetLeftMargin(2)
	oReport:SetLineHeight(40)
	
	

	//Monstando a primeira seção

	oSection1:= TRSection():New(oReport, 	"NCM"		,{"SZ9"}, 	, .F.	, 	.T.)
	TRCell():New(oSection1,"TMP_NPROP"		,"TRBPP"	,"Proposta"				,"@!"				,13)
	TRCell():New(oSection1,"TMP_CLIFIN"		,"TRBPP"	,"Cliente Final"		,"@!"				,40,,,,.T.)
	TRCell():New(oSection1,"TMP_XEQUIP"		,"TRBPP"	,"Descricao"			,"@!"				,30,,,,.T.)
	TRCell():New(oSection1,"TMP_LOCAL"		,"TRBPP"	,"Local"				,"@!"				,30,,,,.T.)
	TRCell():New(oSection1,"TMP_DTPREV"		,"TRBPP"	,"Prev.Venda"			,""					,15)
	TRCell():New(oSection1,"TMP_REPRE"		,"TRBPP"	,"Representante"		,""					,35,,,,.T.)
	TRCell():New(oSection1,"TMP_RESP"		,"TRBPP"	,"Resp.Venda"			,""					,35,,,,.T.)
	TRCell():New(oSection1,"TMP_TOTCI"		,"TRBPP"	,"Preço C/ Trib."		,"@E 999,999,999.99",13,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_TOTSI"		,"TRBPP"	,"Preço s/ Trib."		,"@E 999,999,999.99",13,,,,,"RIGHT")
	TRCell():New(oSection1,"TMP_MGCONT"		,"TRBPP"	,"% Marg.Contr."		,"@E 999,999,999.99",13,,,,,"RIGHT")
	
	TRFunction():New(oSection1:Cell("TMP_TOTCI")	,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("TMP_TOTSI")	,NIL,"SUM",,,,,.T.,.F.)


	oReport:SetTotalInLine(.F.)

        //Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText("Total Propostas ")

Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.

	Local cQuery2   := ""
	
	
	/************ QUERY STATUS CLASSIFICACAO *******************/
	nRegC      := 0
	cTipoSitC:= MV_PAR01 //recebe o resultado da pegunta
	cSitQueryC := ""
	
	For nRegC:=1 to Len(cTipoSitC)
	     cSitQueryC += "'"+Subs(cTipoSitC,nRegC,1)+"'"
	    
	     If ( nRegC+1 ) <= Len(cTipoSitC)
	          cSitQueryC += "," 
	     Endif
	Next nRegC   
	 
	cSitQueryC := "(" + cSitQueryC + ")"
	/************ QUERY STATUS MERCADO *******************/
	nRegM      := 0
	cTipoSitM:= MV_PAR02 //recebe o resultado da pegunta
	cSitQueryM := ""
	
	For nRegM:=1 to Len(cTipoSitM)
	     cSitQueryM += "'"+Subs(cTipoSitM,nRegM,1)+"'"
	    
	     If ( nRegM+1 ) <= Len(cTipoSitM)
	          cSitQueryM += "," 
	     Endif
	Next nRegM   
	 
	cSitQueryM := "(" + cSitQueryM + ")"
	/************ QUERY STATUS TIPO *******************/
	nRegT      := 0
	cTipoSitT:= MV_PAR03 //recebe o resultado da pegunta
	cSitQueryT := ""
	
	For nRegT:=1 to Len(cTipoSitT)
	     cSitQueryT += "'"+Subs(cTipoSitT,nRegT,1)+"'"
	    
	     If ( nRegT+1 ) <= Len(cTipoSitT)
	          cSitQueryT += "," 
	     Endif
	Next nRegT   
	 
	cSitQueryT := "(" + cSitQueryT + ")"
	/**************************************************/


	cQuery := " SELECT Z9_NPROP AS 'TMP_NPROP', Z9_CLASS AS 'TMP_CLASS', Z9_MERCADO AS 'TMP_MERCADO', Z9_TIPO AS 'TMP_TIPO', Z9_CLIFIN AS 'TMP_CLIFIN', "
	cQuery += "  Z9_PROJETO AS 'TMP_PROJETO', Z9_LOCAL AS 'TMP_LOCAL', Z9_DTEPROP AS 'TMP_DTEPROP', Z9_DTEREAL AS 'TMP_DTEREAL', Z9_XEQUIP AS 'TMP_XEQUIP',  " 
	cQuery += "  Z9_STATUS AS 'TMP_STATUS', Z9_IDELAB AS 'TMP_IDELAB', Z9_RESPELA AS 'TMP_RESPELA', Z9_IDRESP AS 'TMP_IDRESP', Z9_RESP AS 'TMP_RESP',  " 
	cQuery += "  Z9_TOTSI AS 'TMP_TOTSI', Z9_TOTCI AS 'TMP_TOTCI', Z9_DTPREV AS 'TMP_DTPREV', Z9_CODREP AS 'TMP_CODREP', Z9_REPRE AS 'TMP_REPRE', " 
	cQuery += " iif(Z9_TOTSI > 0 , (((Z9_TOTSI - Z9_CUSTOT) / Z9_TOTSI) * 100) , 0) as 'TMP_MGCONT'  " 
	cQuery += " 	FROM SZ9010  " 
	cQuery += "	WHERE "
	cQuery += "	 SZ9010.D_E_L_E_T_ <> '*'   " 
	cQuery += " AND Z9_STATUS   = '1' "
	cQuery += " AND Z9_CLASS IN " + cSitQueryC + " "
	cQuery += " AND Z9_MERCADO IN " + cSitQueryM + " "
	cQuery += " AND Z9_TIPO IN " + cSitQueryC + " "
	cQuery += " AND Z9_DTPREV    >= '" + DTOS(MV_PAR04) + "' "
	cQuery += " AND Z9_DTPREV    <= '" + DTOS(MV_PAR05) + "' "
	cQuery += "	AND Z9_CODREP >= '" + MV_PAR06 + "' AND Z9_CODREP <= '" + MV_PAR07 + "'"
	cQuery += "	AND Z9_IDRESP >= '" + MV_PAR08 + "' AND Z9_IDRESP <= '" + MV_PAR09 + "'"
	cQuery += "	AND Z9_CLIFIN >= '" + MV_PAR10 + "' AND Z9_CLIFIN <= '" + MV_PAR11 + "'"
	cQuery += " ORDER BY Z9_DTPREV, Z9_NPROP, Z9_STATUS, Z9_DTEPROP, Z9_DTEREAL "
	

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBPP") <> 0
		DbSelectArea("TRBPP")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBPP"

	dbSelectArea("TRBPP")
	TRBPP->(dbGoTop())

	oReport:SetMeter(TRBPP->(LastRec()))

	oReport:SkipLine(3)
	oReport:FatLine()
	oReport:PrintText("Proposta")
	oReport:FatLine()

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()

		cNcm 	:= TRBPP->TMP_NPROP
		IncProc("Imprimindo Proposta "+alltrim(TRBPP->TMP_NPROP))

		//imprimo a primeira seção
		oSection1:Cell("TMP_NPROP"):SetValue(TRBPP->TMP_NPROP)
		oSection1:Cell("TMP_CLIFIN"):SetValue(TRBPP->TMP_CLIFIN)
		oSection1:Cell("TMP_XEQUIP"):SetValue(TRBPP->TMP_XEQUIP)
		oSection1:Cell("TMP_LOCAL"):SetValue(TRBPP->TMP_LOCAL)
		
		IF TMP_DTPREV = ""
			oSection1:Cell("TMP_DTPREV"):SetValue("")
		ELSE
			oSection1:Cell("TMP_DTPREV"):SetValue(Substr(TRBPP->TMP_DTPREV,5,2) + "/" + Substr(TRBPP->TMP_DTPREV,1,4))
		ENDIF
		
		oSection1:Cell("TMP_REPRE"):SetValue(TRBPP->TMP_REPRE)
		oSection1:Cell("TMP_RESP"):SetValue(TRBPP->TMP_RESP)
		
		oSection1:Cell("TMP_TOTCI"):SetValue(TRBPP->TMP_TOTCI)
		oSection1:Cell("TMP_TOTCI"):SetAlign("RIGHT")
		
		oSection1:Cell("TMP_TOTSI"):SetValue(TRBPP->TMP_TOTSI)
		oSection1:Cell("TMP_TOTSI"):SetAlign("RIGHT")
		
		oSection1:Cell("TMP_MGCONT"):SetValue(TRBPP->TMP_MGCONT)
		oSection1:Cell("TMP_MGCONT"):SetAlign("RIGHT")
					
		oSection1:Cell("TMP_REPRE"):SetValue(TRBPP->TMP_REPRE)
		
		oSection1:Cell("TMP_RESP"):SetValue(TRBPP->TMP_RESP)

		oReport:ThinLine()
		oSection1:Printline()
		TRBPP->(dbSkip())

	Enddo

	oSection1:Finish()

Return

static function ajustaSx1(cPerg)

	putSx1(cPerg, "01", "Proposta de ?" , "", "", "mv_ch1", "C", 13, 0, 0, "G", "", "SZ9", "", "", "mv_par01")
	putSx1(cPerg, "02", "Proposta até?" , "", "", "mv_ch2", "C", 13, 0, 0, "G", "", "SZ9", "", "", "mv_par02")
return


                 