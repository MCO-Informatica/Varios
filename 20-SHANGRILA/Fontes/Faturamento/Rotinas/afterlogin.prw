#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

#Define STR_PULA		Chr(13)+Chr(10)

User Function AfterLogin()
	Local cSql:= ""

	If StoD(GetMV("MV_XDTBASE")) < dDataBase //If Day(Date()) >= 1 .AND. Day(Date()) <= 7

		If Select("QRY") > 0
			QRY->( dbCloseArea() )
		EndIf

		cSql :=  "SELECT " + STR_PULA
		cSql +=  "D2_FILIAL CDG_FILIAL, " + STR_PULA
		cSql +=  "'S' CDG_TPMOV, " + STR_PULA
		cSql +=  "D2_DOC CDG_DOC, " + STR_PULA
		cSql +=  "D2_SERIE CDG_SERIE, " + STR_PULA
		cSql +=  "D2_CLIENTE CDG_CLIFOR, " + STR_PULA
		cSql +=  "D2_LOJA CDG_LOJA, " + STR_PULA
		cSql +=  "'000003' CDG_IFCOMP, " + STR_PULA
		cSql +=  "'50075792820194036110' CDG_PROCES, " + STR_PULA
		cSql +=  "' ' CDG_CANC, " + STR_PULA
		cSql +=  "'1' CDG_TPPROC, " + STR_PULA
		cSql +=  "D2_SERIE CDG_SDOC, " + STR_PULA
		cSql +=  "'00000001' CDG_ITPROC, " + STR_PULA
		cSql +=  "D2_VALICM CDG_VALOR, " + STR_PULA
		cSql +=  "D2_ITEM	CDG_ITEM " + STR_PULA
		cSql +=  "FROM "+RetSqlName("SD2")+" SD2 " + STR_PULA
		cSql +=  "JOIN "+RetSqlName("SF4")+" SF4 ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_=' ' AND F4_DUPLIC = 'S' " + STR_PULA
		cSql +=  "WHERE SUBSTRING(D2_EMISSAO,1,6) >= '"+Substr(DtoS(MonthSub(dDataBase,3)),1,6)+"' AND D2_SERIE = '0' AND SD2.D_E_L_E_T_= ' ' " + STR_PULA
		cSql +=  "AND D2_SERIE+D2_DOC+D2_CLIENTE+D2_LOJA+D2_ITEM NOT IN " + STR_PULA
		cSql +=  "(SELECT CDG_SERIE+CDG_DOC+CDG_CLIFOR+CDG_LOJA+CDG_ITEM FROM "+RetSqlName("CDG")+" CDG WHERE CDG.D_E_L_E_T_=' ') " + STR_PULA

		TCQUERY cSql NEW ALIAS "QRY"
		DbSelectArea("QRY")
		DbGotop()


		While !QRY->(EOF())

			// CRIA O REGISTRO PIS
			RecLock("CDG",.T.)

			CDG_FILIAL  := QRY->CDG_FILIAL
			CDG_TPMOV   := 'S'
			CDG_DOC     := QRY->CDG_DOC
			CDG_SERIE   := QRY->CDG_SERIE
			CDG_CLIFOR  := QRY->CDG_CLIFOR
			CDG_LOJA    := QRY->CDG_LOJA
			CDG_IFCOMP  := '000003'
			CDG_PROCES  := '50075792820194036110'
			CDG_CANC    := ' '
			CDG_TPPROC  := '1'
			CDG_SDOC    := QRY->CDG_SDOC
			CDG_ITPROC  := '00000001'
			CDG_VALOR   := QRY->CDG_VALOR
			CDG_ITEM    := QRY->CDG_ITEM

			CDG->(MsUnlock())


			// CRIA O REGISTRO COFINS
			RecLock("CDG",.T.)

			CDG_FILIAL  := QRY->CDG_FILIAL
			CDG_TPMOV   := 'S'
			CDG_DOC     := QRY->CDG_DOC
			CDG_SERIE   := QRY->CDG_SERIE
			CDG_CLIFOR  := QRY->CDG_CLIFOR
			CDG_LOJA    := QRY->CDG_LOJA
			CDG_IFCOMP  := '000003'
			CDG_PROCES  := '50075792820194036110'
			CDG_CANC    := ' '
			CDG_TPPROC  := '1'
			CDG_SDOC    := QRY->CDG_SDOC
			CDG_ITPROC  := '00000002'
			CDG_VALOR   := QRY->CDG_VALOR
			CDG_ITEM    := QRY->CDG_ITEM

			CDG->(MsUnlock())

			QRY->(DbSkip())

			PutMV("MV_XDTBASE",DtoS(dDataBase))

		End


		If Select("QRY") > 0
			QRY->( dbCloseArea() )
		EndIf

		// Limpa Notas de Entrada que não deveria estar na tabela CDG
		cSql := "UPDATE "+RetSqlName("CDG")+" SET D_E_L_E_T_ ='*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE D_E_L_E_T_ = ' ' AND CDG_SERIE <> '0' AND CDG_TPMOV = 'E' "
		TcSqlExec(cSql)

	EndIf

Return
