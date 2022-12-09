#Include "Protheus.ch"
#Include "TopConn.ch"


User Function AlStCli()
	Local cSql := ""

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())

	While !(SA1->(EOF()))

		cSql := " SELECT * FROM "+RetSqlName("SE1")
		cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND D_E_L_E_T_<>'*' "
		cSql += " AND E1_CLIENTE = '"+SA1->A1_COD+"' AND E1_LOJA = '"+SA1->A1_LOJA+"' "
		cSql += " AND (E1_SALDO > 0 OR E1_BAIXA < '"+DtoS(DaySub(dDataBase,6))+"' OR E1_BAIXA = ' ') "
		cSql += " AND E1_TIPO NOT IN ('PR','TX','INS','IRF','ISS') "
        cSql += " AND E1_VENCREA < '"+DtoS(dDataBase)+"' "
		

		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf

		TcQuery ChangeQuery(cSql) New Alias "QRY"


		RecLock("SA1",.F.)

		If DateDiffDay(SA1->A1_DTCAD,dDataBase) > 720


		Else


		EndIf

		SA1->(MsUnlock())

		SA1->(DbSkip())

	End

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf


Return Nil
