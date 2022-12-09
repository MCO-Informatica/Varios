#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REST009 บ Autor ณJunior Carvalho     บ Data ณ  31/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio Notas de despesas de Importa็ใo que   nใo         บฑฑ
ฑฑบ          ณ agregaram custos                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function REST009()

	Local aPergs := {}
	Private lRet := .F.
	Private aRet := {}
	PRIVATE cTitulo := "NOTAS FISCAIS - CUSTOS DE IMPORTAวรO"

	Aadd( aPergs ,{1,"Emissao De      " ,FirstDate(dDatabase) ,"@E 99/99/9999","","","",100,.F.})
	Aadd( aPergs ,{1,"Emissใo Ate     " ,LastDate(dDatabase)  ,"@E 99/99/9999","","","",100,.T.})

	If ParamBox(aPergs ," Parametros - "+cTitulo,aRet)

		MsgRun("Favor Aguardar.....", "Selecionando os Registros... "+cTitulo,{|| GeraItens()})
		if !lRet
			Aviso( cTitulo,"Nenhum dado gerado! Verifique os parametros utilizados.",{"OK"},3)
		Endif

	EndIf

Return()

Static Function GeraItens( )

	Local cAlias := GetNextAlias()
	Local cQuery := ""
	Local cArq := ""
	Local cDir := GetSrvProfString("Startpath","")
	Local cPlanilha := "NOTAS"
	Local cDirTmp := GetTempPath()
	Local oExcel := FWMSEXCEL():New()
	Local ESDESPEIC := SuperGetMv("ES_DESPEIC",,'244')+',  '

	cQuery := " SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_ITEM, D1_TES, D1_COD, SUBSTR(B1_DESC,1,40) DESCR, D1_CUSTO, D1_EMISSAO, D1_DTDIGIT,D1_CONHEC,  "
	cQuery += " NVL( ( SELECT DISTINCT F1_DOC FROM "+RETSQLNAME("SF1")+" SF1 "
	cQuery += " WHERE "
	cQuery += " F1_FILIAL = D1_FILIAL "
	cQuery += " AND F1_HAWB =  D1_CONHEC "
	cQuery += " AND SF1.D_E_L_E_T_ <> '*' AND ROWNUM <= 1 ),' ') NF_IMPORT  "
	cQuery += " FROM "+RETSQLNAME("SD1")+" SD1, "+RETSQLNAME("SB1")+" SB1 "
	cQuery += " WHERE  B1_COD = D1_COD AND SB1.B1_FILIAL = '"+XFILIAL("SB1")+" '  AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += " AND D1_CONHEC <> ' '   and D1_XINTSD3 = ' ' "
	cQuery += " AND D1_TES NOT IN " + FormatIn(ESDESPEIC,',')
	//cQuery += " AND D1_TES NOT IN ('   ','244')  "
	cQuery += " AND B1_TIPO NOT IN ('MR','MA')  "
	cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(aRet[1])+"' AND '"+DTOS(aRet[2])+"' "
	cQuery += " AND D1_FILIAL = '"+XFILIAL("SD1")+"' "
	cQuery += " AND SD1.D_E_L_E_T_ <> '*' "

	cQuery += " ORDER BY D1_FILIAL, D1_DOC, D1_SERIE, D1_ITEM  "

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	ProcRegua(RecCount())

	oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)

	oExcel:AddColumn(cPlanilha,cTitulo,"FILIAL",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"DOCUMENTO",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"SERIE",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"ITEM",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"TES",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"PRODUTO",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"DESCRIวรO",1,1)
	oExcel:AddColumn(cPlanilha,cTitulo,"CUSTO",3,2)
	oExcel:AddColumn(cPlanilha,cTitulo,"DT_EMISSAO",2,4)
	oExcel:AddColumn(cPlanilha,cTitulo,"DT_DIGITACAO",2,4)
	oExcel:AddColumn(cPlanilha,cTitulo,"COD_IMPORTACAO",2,4)
	oExcel:AddColumn(cPlanilha,cTitulo,"NF_IMPORTACAO",1,1)

	While !(cAlias)->(EOF())

		IncProc("Aguarde o Processamento...")
		oExcel:AddRow(cPlanilha,cTitulo, { (cAlias)->D1_FILIAL, (cAlias)->D1_DOC, (cAlias)->D1_SERIE,	(cAlias)->D1_ITEM, (cAlias)->D1_TES,;
		(cAlias)->D1_COD, (cAlias)->DESCR, (cAlias)->D1_CUSTO, (cAlias)->D1_EMISSAO, (cAlias)->D1_DTDIGIT,(cAlias)->D1_CONHEC, (cAlias)->NF_IMPORT } )

		(cAlias)->(DbSkip())
		lRet := .T.

	EndDo

	(cAlias)->(DbCloseArea())
	MsErase(cAlias)

	IF lRet

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

	Endif

Return()
