#Include "Protheus.ch"
#Include "TopConn.ch"

User Function M460FIM()
    Local aArea     := GetArea()
	Local cSql      := ""
	Local cEsp      := ""
    Local lContinua := .F.

	dbSelectArea("SF2")

	cEsp := SF2->F2_ESPECIE

	cSql := "SELECT * FROM "+RetSqlName("CDL")+" CDL WHERE CDL.CDL_FILIAL = '"+SF2->F2_FILIAL+"' AND CDL.CDL_SERIE = '"+SF2->F2_SERIE+"' AND CDL.CDL_DOC = '"+SF2->F2_DOC+"' AND CDL.CDL_CLIENT = '"+SF2->F2_CLIENTE+"' AND CDL.CDL_LOJA = '"+SF2->F2_LOJA+"' AND CDL.D_E_L_E_T_=' ' "
	If Select("QRYCDL") > 0
		QRYCDL->(DbCloseArea())
	EndIf

	TCQuery ChangeQuery(cSql) New Alias "QRYCDL"

	If Empty(QRYCDL->CDL_DOC)
		lContinua := .T.
	EndIf

	If Select("QRYCDL") > 0
		QRYCDL->(DbCloseArea())
	EndIf


	If lContinua

		DbSelectArea("SD2")
		DbSetOrder(3)

		If SD2->(DbSeek(xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))

			While SD2->(!EOF()) .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And. SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA

                If !Substr(AllTrim(SD2->D2_CF),1,1) == "7"
                    Return Nil
                EndIf

				RecLock("CDL",.T.)

				CDL_FILIAL := xFilial("CDL")
				CDL_DOC	   := SD2->D2_DOC
				CDL_SERIE  := SD2->D2_SERIE
				CDL_ESPEC  := cEsp
				CDL_CLIENT := SD2->D2_CLIENTE
				CDL_LOJA   := SD2->D2_LOJA
				CDL_UFEMB  := "SP"
				CDL_LOCEMB := "CAPELA DO ALTO"
				CDL_ITEMNF := SD2->D2_ITEM
				CDL_PRODNF := SD2->D2_COD
				CDL_SDOC   := SD2->D2_SERIE

                //CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_NUMDE+CDL_DOCORI+CDL_SERORI+CDL_FORNEC+CDL_LOJFOR+CDL_NRREG+CDL_ITEMNF+CDL_NRMEMO 

				CDL->(MsUnlock())

				SD2->(DbSkip())

			EndDo

		EndIf

	EndIf

RestArea(aArea)

Return Nil
