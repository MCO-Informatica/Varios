#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"

User Function CM010TOK()

	Local _lRet := .T.
	Local cSql  := ""
	Local cSql2 := ""

	//SELECIONA TODOS OS ITENS DA TABELA 002 E 003 PARA MARCAR COMO DELETADOS
	cSql2 := "SELECT * FROM "+RetSqlName("DA1")+" DA1 WHERE DA1.D_E_L_E_T_ = ' ' AND DA1.DA1_CODTAB IN ('002','003') "
	If Select("AUX") > 0
		AUX->(dbCloseArea())
	EndIf

	TcQuery ChangeQuery(cSql2) New Alias "AUX"

	While !AUX->(EOF())

		RecLock("DA1",.F.)
		DbDelete()
		DA1->(MsUnlock())

		AUX->(DbSkip())
	End

	If Select("AUX") > 0
		AUX->(dbCloseArea())
	EndIf



	//DEPOIS DA LIMPEZA DE ITENS DA TABELA 002 E 003

	//SELECIONA TODOS OS ITENS DA TABELA 001
	cSql  := "SELECT * FROM "+RetSqlName("DA1")+" DA1 WHERE DA1.D_E_L_E_T_ =' ' AND DA1.DA1_CODTAB = '001' "
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	TcQuery ChangeQuery(cSql) New Alias "QRY"


	While !QRY->(EOF())

		//RECLOCK PARA GRAVAR OS ITENS DA TABELA 002
		RecLock("DA1",.T.)

		DA1_FILIAL  := xFilial("DA1")
		DA1_ITEM    := QRY->DA1_IEM
		DA1_CODTAB  := "002"
		DA1_CODPRO  := QRY->DA1_CODPRO
		DA1_PRCVEN  := QRY->DA1_PRCVEN - (QRY->DA1_PRCVEN * 0.05)
		DA1_VLRDES  := QRY->DA1_VLRDES
		DA1_PERDES  := QRY->DA1_PERDES
		DA1_ATIVO   := QRY->DA1_ATIVO
		DA1_FRETE   := QRY->DA1_FRETE
		DA1_TPOPER  := QRY->DA1_TPOPER
		DA1_QTDLOT  := QRY->DA1_QTDLOT
		DA1_INDLOT  := QRY->DA1_INDLOT
		DA1_DATVIG  := QRY->DA1_DATVIG

		DA1->(MsUnlock())

		QRY->(DbSkip())
	End


    //VOLTA NO PRIMEIOR REGISTRO DA TABELA AUXILIAR
	QRY->(DbGoTop())

	While !QRY->(EOF())

		//RECLOCK PARA GRAVAR OS ITENS DA TABELA 003
		RecLock("DA1",.T.)

		DA1_FILIAL  := xFilial("DA1")
		DA1_ITEM    := QRY->DA1_IEM
		DA1_CODTAB  := "003"
		DA1_CODPRO  := QRY->DA1_CODPRO
		DA1_PRCVEN  := QRY->DA1_PRCVEN - (QRY->DA1_PRCVEN * 0.10)
		DA1_VLRDES  := QRY->DA1_VLRDES
		DA1_PERDES  := QRY->DA1_PERDES
		DA1_ATIVO   := QRY->DA1_ATIVO
		DA1_FRETE   := QRY->DA1_FRETE
		DA1_TPOPER  := QRY->DA1_TPOPER
		DA1_QTDLOT  := QRY->DA1_QTDLOT
		DA1_INDLOT  := QRY->DA1_INDLOT
		DA1_DATVIG  := QRY->DA1_DATVIG

		DA1->(MsUnlock())

		QRY->(DbSkip())
	End

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

    MsgInfo("Alterações replicadas na tabela 002 e 003","Replicado com Sucesso")

Return(_lRet)
