/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OM200FIM º Autor ³  Daniel   Gondran  º Data ³ 15/01/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.E. para zerar o frete no pedido após montagem de carga   º±±
±±º          ³ Bloquear o pedido por estoque                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento / Orcamento                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

user function om200FIM

	Local aAreaAtu := GetArea() 
	Local cQuery := ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "om200FIM" , __cUserID )

	dbSelectArea("DAI")
	dbSetOrder(1)
	dbSeek(xFilial("DAI") + DAK->DAK_COD)
	do While !Eof() .and. DAI->DAI_COD == DAK->DAK_COD
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5") + DAI->DAI_PEDIDO)
		RecLock("SC5",.F.)
		SC5->C5_FRETE := 0
		MsUnlock()               

		// Estorna liberação de estoque caso produto seja Granel
		dbSelectArea("SC9")
		dbSetOrder(1)
		dbSeek(xFilial("SC9") + SC5->C5_NUM)
		do WHile !Eof() .and. SC9->C9_FILIAL == SC5->C5_FILIAL .and. SC9->C9_PEDIDO == SC5->C5_NUM
			If 'GRANEL' $ Posicione("SB1",1,xFilial("SB1") + SC9->C9_PRODUTO,"B1_DESC")
				MaAvalSC9("SC9",6)
			Endif
			dbSelectArea("SC9")
			dbSkip()
		Enddo

		dbSelectArea("DAI")
		dbSkip()
	Enddo

	TRBPED->( dbGoTop() )
	While TRBPED->( !Eof() )

		cQuery := "SELECT R_E_C_N_O_ RECDAI "
		cQuery += "  FROM " + RetSQLName( "DAI" )
		cQuery += " WHERE DAI_FILIAL = '" + xFilial( "DAI" ) + "' "
		cQuery += "   AND DAI_PEDIDO = '" + TRBPED->PED_PEDIDO + "' "
		cQuery += "   AND DAI_CLIENT = '" + TRBPED->PED_CODCLI + "' " 
		cQuery += "   AND DAI_LOJA   = '" + TRBPED->PED_LOJA + "' "
		cQuery += "   AND DAI_COMPAR = 0 "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		If Select( "TMP_DAI" ) > 0
			TMP_DAI->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", 	TCGenQry( Nil, Nil, cQuery ), "TMP_DAI", .T., .F. )
		If TMP_DAI->( !Eof() )

			DAI->( dbGoTo( TMP_DAI->RECDAI ) )

			RecLock( "DAI", .F. )
			DAI->DAI_COMPAR := TRBPED->PED_COMP
			DAI->( MsUnLock() )

		Endif
		TMP_DAI->( dbCloseArea() )


		TRBPED->( dbSkip() )
	End

	RestArea( aAreaAtu )

return