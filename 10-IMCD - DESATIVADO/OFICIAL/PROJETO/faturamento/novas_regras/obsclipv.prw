#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OBSCLIPV º Autor ³ Junior Carvalho    º Data ³  15/06/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Mostrar na tela a observacao do cadastro do cliente, como  º±±
±±º          ³ um alerta.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI - Orcamento / Pedido de Venda            º±±
±±º          ³ Usado no VALID dos campos C5_CLIENTE / CJ_CLIENTE.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function OBSCLIPV(cAlias)
	Local _aArea := GetArea()
	Local cTexto := ""
	local lMsg := .T.

	if  !IsInCallStack("U_IMPQUOTE")
		IF !IsInCallStack("U_SF2460I")
			IF !IsInCallStack("U_M460FIM")

				IF cAlias == "SCJ"
					cChave := M->CJ_CLIENTE + iif(EMPTY(M->CJ_LOJA),'01',M->CJ_LOJA )
				ELSE
					cChave := M->C5_CLIENTE + iif(EMPTY(M->C5_LOJACLI),'01',M->C5_LOJACLI )

					If M->C5_TIPO $ "B|D"

						lMsg := .F.

					Endif
				ENDIF

				if lMsg
					DbSelectArea("SA1")
					DbSetOrder(1)
					if DbSeek(xFilial("SA1")+ cChave )
						cTexto := ALLTRIM(SA1->A1_OBSVEN)
						If !Empty( cTexto )

							Aviso("OBS. CLIENTE",cTexto,{"Ok"},3)

						EndIf

					Endif
				Endif
			Endif
		Endif
	Endif
	RestArea(_aArea)

Return .T.
