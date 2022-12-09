#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REST010  บ Autor ณJunior Carvalho     บ Data ณ  31/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio Movimentacoes internas de despesas de importacao  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function REST010()

	Local aPergs := {}
	Private lRet := .F.
	Private aRet := {}
	PRIVATE cTitulo := "CUSTOS DE IMPORTAวรO - MOV. INTERNA"

	Aadd( aPergs ,{1,"Emissao De      " ,FirstDate(dDatabase) ,"@E 99/99/9999","","","",100,.F.})
	Aadd( aPergs ,{1,"Emissใo Ate     " ,LastDate(dDatabase)  ,"@E 99/99/9999","","","",100,.T.})

	If ParamBox(aPergs ," Parametros - "+cTitulo,aRet)

		MsgRun("Favor Aguardar.....", "Selecionando os Registros... "+cTitulo,{|| GeraItens()})
		if !lRet
			Aviso( cTitulo,"Nenhum dado gerado! Verifique os parametros utilizados.",{"OK"},3)
		Endif

	EndIf

Return()

Static Function GeraItens( aCols )

	Local cAlias := GetNextAlias()
	Local cQuery := ""
	Local cArq := ""
	Local cDir := GetSrvProfString("Startpath","")
	Local cPlanilha := "NOTAS"
	Local cTable := ""
	Local cDirTmp := GetTempPath()
	Local oExcel := FWMSEXCEL():New()

	cQuery := " SELECT D3_FILIAL, D3_COD,D3_EMISSAO, D3_TM, D3_CUSTO1, "
	cQuery += " SUBSTR(D3_XIMPEIC,23,15) COD_SERV,  SUBSTR(B1_DESC,1,40) DESCR, SUBSTR(D3_XIMPEIC,3,9) NF, D3_XIMPEIC "
	cQuery += " FROM "+RETSQLNAME("SD3")+" SD3, "+RETSQLNAME("SB1")+" SB1 "
	cQuery += " WHERE "
	cQuery += " B1_COD = SUBSTR(D3_XIMPEIC,23,15) "
	cQuery += " AND B1_FILIAL = '"+XFILIAL("SB1")+"' AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += " AND D3_XIMPEIC <> ' ' "
	cQuery += " AND D3_TM = '007' "
	cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(aRet[1])+"' AND '"+DTOS(aRet[2])+"' "
	cQuery += " AND D3_FILIAL = '"+XFILIAL("SD3")+"' "
	cQuery += " AND SD3.D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY D3_FILIAL, D3_EMISSAO "

	PLSQuery(cQuery,cAlias)

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	ProcRegua(RecCount())

	oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)

	oExcel:AddColumn(cPlanilha,cTitulo,"FILIAL",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"PRODUTO",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"DT_EMISSAO",2,4)
	oExcel:AddColumn(cPlanilha,cTitulo,"TM",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"CUSTO",3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,"COD_SERV",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"DESCRIวรO",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"D3_XIMPEIC",1,1)

	While !(cAlias)->(EOF())

		IncProc("Aguarde o Processamento...")
		oExcel:AddRow(cPlanilha,cTitulo, { (cAlias)->D3_FILIAL, (cAlias)->D3_COD, (cAlias)->D3_EMISSAO,	(cAlias)->D3_TM,;
		(cAlias)->D3_CUSTO1,(cAlias)->COD_SERV, (cAlias)->DESCR, (cAlias)->D3_XIMPEIC } )

		(cAlias)->(DbSkip())
		lRet := .T.

	EndDo

	(cAlias)->(DbCloseArea())
	MsErase(cAlias)

	oExcel:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"
	LjMsgRun( "Gerando o arquivo, aguarde...", cPlanilha, {|| oExcel:GetXMLFile( cArq ) } )
	If __CopyFile( cArq, cDirTmp + cArq )
		IF (ApOleClient("MsExcel"))
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cArq )
			oExcelApp:SetVisible(.T.)
		Else
			MsgInfo("MsExcel nใo instalado")
		EndIf
		MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diret๓rio " + cDir )
	Else
		MsgInfo( "Arquivo nใo copiado para temporแrio do usuแrio." )
	Endif
	FERASE(cArq)
Return()
