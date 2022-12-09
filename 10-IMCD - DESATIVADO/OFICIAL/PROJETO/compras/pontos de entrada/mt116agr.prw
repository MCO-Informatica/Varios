#INCLUDE 'RWMAKE.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT116AGR º Autor ³ Giane - ADV Brasil º Data ³  31/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.e. na rotina de conhecimento de frete                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT116AGR()
	Local _aArea := GetArea()
	Local cChave
	Local nReg := SF8->(Recno())

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT116AGR" , __cUserID )

	If INCLUI
		cChave :=  xFilial("SF8") + SF8->F8_NFDIFRE + SF8->F8_SEDIFRE
		DbSelectarea("SF8")
		DbSetOrder(1)
		DbSeek(cChave)
		Do while !eof() .and. SF8->F8_FILIAL + SF8->F8_NFDIFRE + SF8->F8_SEDIFRE == cChave
			RecLock("SF8",.f.)
			SF8->F8_VEICULO := aParametros[ len(aparametros) ]
			MsUnlock()
			SF8->(DbSkip())
		Enddo

		If Alltrim(CESPECIE) $ 'CTE|CTR' .AND. CTIPO == "C" 
			cChaveSD1 := xFilial("SD1")+cNFiscal+cSerie+cA100For+cLoja
			cChaveSFT := xFilial("SD1")+"E"+cSerie+cNFiscal+cA100For+cLoja
			cCFOPS := '1353|2353'

			dbSelectArea("SD1")
			dBSetOrder(1)
			If SD1->(MsSeek(cChaveSD1))
				While !SD1->(Eof()).and. cChaveSD1 == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
					IF Alltrim(SD1->D1_CF) $ cCFOPS
						RecLock("SD1",.F.)
						SD1->D1_CLASFIS := '000'
						SD1->D1_LOCAL := '01'
						msUnlock()
						SD1->(dbSkip())
					Endif 
				EndDo
			Endif

			DBSELECTAREA("SFT")
			dBSetOrder(1)
			If SFT->(MsSeek(cChaveSFT))
				While !SFT->(Eof()) .and. cChaveSFT == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA
					If Alltrim(SFT->FT_CFOP) $ cCFOPS
						RecLock("SFT",.F.)
						SFT->FT_CLASFIS := '000'
						MsUnLock()
						SFT->(dbSkip())             
					Endif
				EndDo
			Endif
		Endif


	Endif

	RestArea(_aArea)
	SF8->(DbGoto(nReg))
Return

