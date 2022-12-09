#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function zRelProp()
	Local oReport := nil
	Local cPerg:= Padr("ZRELPROP",10)


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
	oReport := TReport():New(cNome,"Relatório de Propostas  " ,cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
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
	TRCell():New(oSection1,"TMP_PROJETO"	,"TRBPP"	,"Projeto"				,"@!"				,30,,,,.T.)
	TRCell():New(oSection1,"TMP_LOCAL"		,"TRBPP"	,"Local"				,"@!"				,30,,,,.T.)
	
	TRCell():New(oSection1,"TMP_STATUS"		,"TRBPP"	,"Status"				,"@!"				,10)
	TRCell():New(oSection1,"TMP_RESP"		,"TRBPP"	,"Resp.Venda"			,""					,35,,,,.T.)
	TRCell():New(oSection1,"TMP_RESPELA"	,"TRBPP"	,"Resp.Elab."			,""					,35,,,,.T.)
	TRCell():New(oSection1,"TMP_DTEPROP"	,"TRBPP"	,"Entr.Prev."			,""					,15)
	TRCell():New(oSection1,"TMP_DTEREAL"	,"TRBPP"	,"Entr.Real"			,""					,15)
	TRCell():New(oSection1,"TMP_TOTSI"		,"TRBPP"	,"Preço s/ Trib."		,"@E 999,999,999.99",13,,,,,"RIGHT")
	
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
	
	/************ QUERY STATUS PROPOSTA *******************/
	nReg      := 0
	cTipoSit:= MV_PAR02 //recebe o resultado da pegunta
	cSitQuery := ""
	
	For nReg:=1 to Len(cTipoSit)
	     cSitQuery += "'"+Subs(cTipoSit,nReg,1)+"'"
	    
	     If ( nReg+1 ) <= Len(cTipoSit)
	          cSitQuery += "," 
	     Endif
	Next nReg   
	 
	cSitQuery := "(" + cSitQuery + ")"
	
	/************ QUERY STATUS CLASSIFICACAO *******************/
	nRegC      := 0
	cTipoSitC:= MV_PAR03 //recebe o resultado da pegunta
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
	cTipoSitM:= MV_PAR04 //recebe o resultado da pegunta
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
	cTipoSitT:= MV_PAR05 //recebe o resultado da pegunta
	cSitQueryT := ""
	
	For nRegT:=1 to Len(cTipoSitT)
	     cSitQueryT += "'"+Subs(cTipoSitT,nRegT,1)+"'"
	    
	     If ( nRegT+1 ) <= Len(cTipoSitT)
	          cSitQueryT += "," 
	     Endif
	Next nRegT   
	 
	cSitQueryT := "(" + cSitQueryT + ")"
	/**************************************************/

	cQuery := " SELECT Z9_NPROP AS 'TMP_NPROP', Z9_CLASS AS 'TMP_CLASS', Z9_MERCADO AS 'TMP_MERCADO', Z9_TIPO AS 'TMP_TIPO',  " 
	cQuery += " Z9_CLIFIN AS 'TMP_CLIFIN', Z9_PROJETO AS 'TMP_PROJETO', Z9_LOCAL AS 'TMP_LOCAL', "
	cQuery += "		Z9_DTEPROP AS 'TMP_DTEPROP',  "
	cQuery += "	    Z9_DTEREAL AS 'TMP_DTEREAL', "
	cQuery += " Z9_STATUS AS 'TMP_STATUS', Z9_IDELAB AS 'TMP_IDELAB', Z9_RESPELA AS 'TMP_RESPELA', Z9_IDRESP AS 'IDRESP', Z9_RESP AS 'TMP_RESP', Z9_CODREP, Z9_REPRE, "
	cQuery += "		Z9_TOTSI AS 'TMP_TOTSI', "
	cQuery += "		CASE  "
	cQuery += "			WHEN LTRIM(RTRIM(Z9_STATUS)) = '1' THEN 'ATIVA' WHEN LTRIM(RTRIM(Z9_STATUS)) = '2' THEN 'CANCELADA' " 
	cQuery += "			WHEN LTRIM(RTRIM(Z9_STATUS)) = '3' THEN 'DECLINADA' WHEN LTRIM(RTRIM(Z9_STATUS)) = '4' THEN 'NAO ENVIADA'  "
	cQuery += "			WHEN LTRIM(RTRIM(Z9_STATUS)) = '5' THEN 'PERDIDA' WHEN LTRIM(RTRIM(Z9_STATUS)) = '6' THEN 'SLC'  "
	cQuery += "			WHEN LTRIM(RTRIM(Z9_STATUS)) = '7' THEN 'VENDIDA' "
	cQuery += "		END AS 'TMP_STATUS'  "
	cQuery += "	FROM SZ9010 "
	cQuery += "	WHERE "
	cQuery += "	 SZ9010.D_E_L_E_T_ <> '*'   " 
	if MV_PAR01 = 2
		cQuery += " AND Z9_STATUS   = '1' AND Z9_DTEREAL = '' AND CAST(Z9_DTEPROP AS DATE) <= CAST(GETDATE() AS DATE)  "
	endif
	if MV_PAR01 = 3
		cQuery += " AND Z9_STATUS   = '1' AND Z9_DTEREAL = ''  "
	endif
	if MV_PAR01 = 1
		cQuery += " AND Z9_STATUS IN " + cSitQuery + " "
	endif
	cQuery += " AND Z9_CLASS IN " + cSitQueryC + " "
	cQuery += " AND Z9_MERCADO IN " + cSitQueryM + " "
	cQuery += " AND Z9_TIPO IN " + cSitQueryC + " "
	if MV_PAR01 = 1
		cQuery += " AND Z9_DTEPROP    >= '" + DTOS(MV_PAR06) + "' "
		cQuery += " AND Z9_DTEPROP    <= '" + DTOS(MV_PAR07) + "' "
		cQuery += " AND Z9_DTEREAL    >= '" + DTOS(MV_PAR08) + "' "
		cQuery += " AND Z9_DTEREAL    <= '" + DTOS(MV_PAR09) + "' "
	endif
	cQuery += "	AND Z9_IDRESP >= '" + MV_PAR10 + "' AND Z9_IDRESP <= '" + MV_PAR11 + "'"
	cQuery += "	AND Z9_IDELAB >= '" + MV_PAR12 + "' AND Z9_IDELAB <= '" + MV_PAR13 + "'"
	cQuery += "	AND Z9_CODREP >= '" + MV_PAR14 + "' AND Z9_CODREP <= '" + MV_PAR15 + "'"
	cQuery += "	AND Z9_CLIFIN >= '" + MV_PAR16 + "' AND Z9_CLIFIN <= '" + MV_PAR17 + "'"
	cQuery += " AND Z9_NPROP    >= '" + MV_PAR18 + "' "
	cQuery += " AND Z9_NPROP    <= '" + MV_PAR19 + "' "
	cQuery += " ORDER BY Z9_NPROP, Z9_STATUS, Z9_DTEPROP, Z9_DTEREAL "
	

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
		oSection1:Cell("TMP_PROJETO"):SetValue(TRBPP->TMP_PROJETO)
		
		oSection1:Cell("TMP_TOTSI"):SetValue(TRBPP->TMP_TOTSI)
		oSection1:Cell("TMP_TOTSI"):SetAlign("RIGHT")
		
		oSection1:Cell("TMP_LOCAL"):SetValue(TRBPP->TMP_LOCAL)
		
		//oSection1:Cell("TMP_DTEPROP"):SetValue(TRBPP->TMP_DTEPROP)
		IF TMP_DTEPROP = ""
			oSection1:Cell("TMP_DTEPROP"):SetValue("")
		ELSE
			oSection1:Cell("TMP_DTEPROP"):SetValue(Substr(TRBPP->TMP_DTEPROP,7,2) + "/" + Substr(TRBPP->TMP_DTEPROP,5,2) + "/" + Substr(TRBPP->TMP_DTEPROP,1,4))
		ENDIF
		
		
		//oSection1:Cell("TMP_DTEREAL"):SetValue(TRBPP->TMP_DTEREAL)
		IF TMP_DTEREAL = ""
			oSection1:Cell("TMP_DTEREAL"):SetValue("")
		ELSE
			oSection1:Cell("TMP_DTEREAL"):SetValue(Substr(TRBPP->TMP_DTEREAL,7,2) + "/" + Substr(TRBPP->TMP_DTEREAL,5,2) + "/" + Substr(TRBPP->TMP_DTEREAL,1,4))
		ENDIF
		
		if TRBPP->TMP_STATUS = '1'
			cStatus := 'Ativa'
		elseif TRBPP->TMP_STATUS = '2'
			cStatus := 'Cancelada'
		elseif TRBPP->TMP_STATUS = '3'
			cStatus := 'Declinada'
		elseif TRBPP->TMP_STATUS = '4'
			cStatus := 'Nao Enviada'
		elseif TRBPP->TMP_STATUS = '5'
			cStatus := 'Perdida'
		elseif TRBPP->TMP_STATUS = '6'
			cStatus := 'SLC'
		elseif TRBPP->TMP_STATUS = '7'
			cStatus := 'Vendida'
		endif
		oSection1:Cell("TMP_STATUS"):SetValue(cStatus)
		
		oSection1:Cell("TMP_RESP"):SetValue(TRBPP->TMP_RESP)
		oSection1:Cell("TMP_RESPELA"):SetValue(TRBPP->TMP_RESPELA)

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


                                                     













