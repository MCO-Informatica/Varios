#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±

±±ºPrograma  ³ MTA455SLDº Autor ³   Daniel   Gondran º Data ³  16/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para validar liberacao de estoque com     º±±
±±º          ³ lotes diferentes de um mesmo produto conforme campo        º±±
±±º          ³ A1_LOTEUNI                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / liberacao estoque manual               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA455SLD()
	Local aArea  	:= GetArea()
	Local lRet		:= .T.
	Local aArray	:= aClone(ParamIxb[2])
	Local nI		:= 1
	Local cLote		:= ""

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA455SLD" , __cUserID )
	IF !(SC5->C5_TIPO $ 'B|C')
		If ParamIxb[1] == 2   					// Usuario teclou OK
			If SA1->A1_LOTEUNI == "2"         	// Cliente exige lote unico
				If Rastro(SC9->C9_PRODUTO)		// Produto controla lote
					If Len(ParamIxb[2]) = 0
						Alert("Atenção! Não exite lote disponivel para analise. Cancelando liberação.")
						lRet := .F.
					Else
						cLote := aArray[1,1]
						For nI := 2 to Len(aArray)
							If aArray[nI,1] <> cLote
								lRet := .F.
							Endif
						Next
					Endif
				Endif

				If !lRet .and. Len(ParamIxb[2]) > 0
					MSGSTOP("Atenção! Cliente " + AllTrim(SA1->A1_NOME);
						+CRLF+"Não permite lotes diferentes para o mesmo produto!",;
						"Cancelando liberação.")
				Endif
			Endif

			IF cEmpAnt == '04'
				IF EMPTY(SC6->C6_FCICOD)
					cFCI := ALLTRIM(SB8->B8_XOBS)

					IF "FCI" $ cFCI
						cFCI := SUBSTR(cFCI,AT("FCI",cFCI)+3)
						nPosFim := AT(" ",cFCI)-1
						nPosFim := iif(nPosFim>0, nPosFim, Len(cFCI))
						cFCI := SUBSTR(cFCI,1,nPosFim)
					Else
						cFCI := " "
					ENDIF

					IF !EMPTY(cFCI)
						reclock("SC6",.f.)
						SC6->C6_FCICOD	:= cFCI
						msUnlock()
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	RestArea(aArea)

Return({lRet,aArray})
