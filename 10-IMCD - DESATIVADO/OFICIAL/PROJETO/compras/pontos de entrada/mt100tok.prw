#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100TOK  ºAutor  ³Junior Carvalho     º Data ³  29/07/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para transformar o Valor em Quantidade                  º±±
±±º          ³ Ja entregue no Pedido de Compra                            º±±
±±º09/06/15  ³ VALIDA O CAMPO TRANSPORTADORA PARA PRODUTOS CONTROLADOS    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100TOK()
	LOCAL aArea 	:= GetArea()
	Local lRet	 	:= PARAMIXB[1]
	Local cProdServ := SuperGetMV("ES_PRDSERV", ,"SV9910010000003")
	Local cPrdFrt	:= AllTrim( GetMv( "ES_PRDFRTV" ) )
	Local cNFRSAI	:= ""
	Local cSERSAI	:= ""
	Local lPolicia	:= .F.	
	Local nX := 0			

	if !(IsInCallStack("SpedNFeInut") .or. IsInCallStack("SPEDNFe")  .or. IsInCallStack("MATA920") )

		For nX := 1 To Len(aCols)

			cProd	:= Alltrim(aCols[nX,GDFIELDPOS("D1_COD")])

			If cProd $ cProdServ

				cPedido	:= Alltrim(aCols[nX,GDFIELDPOS("D1_PEDIDO")])
				cItemPC	:= Alltrim(aCols[nX,GDFIELDPOS("D1_ITEMPC")])
				nVlrTot	:= aCols[nX,GDFIELDPOS("D1_TOTAL")]
				nQuant	:= aCols[nX,GDFIELDPOS("D1_QUANT")]
				cNFRSAI	:= Alltrim(aCols[nX,GDFIELDPOS("D1_NFRSAI")])
				cSERSAI	:= Alltrim(aCols[nX,GDFIELDPOS("D1_SERSAI")])

				dbSelectArea("SC7")
				dbSetOrder(1)
				if MsSeek(xFilial("SC7")+cPedido+cItemPC)
					If SC7->C7_PRODUTO == cProd
						If INCLUI
							if (SC7->C7_QUJE - nQuant + nVlrTot) <= SC7->C7_QUANT
								RecLock("SC7",.F.)
								SC7->C7_QUJE := SC7->C7_QUJE - nQuant + nVlrTot
								msunlock()
							Else
								Alert("Entrada ultrapassa o Limite do Pedido em R$ "+ Transform((SC7->C7_QUJE - nQuant + nVlrTot) - SC7->C7_QUANT,"@E 9,999,999.99") )
								lRet := .F.
							EndIf

						EndIf

					EndIf
				EndIf
			EndIf

			If cTipo == 'N' .and. Alltrim(CESPECIE) $ 'CTE|CTR|NFS' .and. cProd $ cPrdFrt
				If !Empty(cNFRSAI) .AND.  !Empty(cSERSAI)
					dbSelectArea("SF2")
					dbSetOrder(1)
					IF MsSeek(xFilial("SF2")+cNFRSAI+cSERSAI)
						cItemCC := Posicione("SA1",1,xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA, "A1_XITEMCC")
						If !Empty(cItemCC)
							aCols[nX,GDFIELDPOS("D1_ITEMCTA")]  := cItemCC
						Endif
					Endif
				Else
					Aviso("MT100LOK - Atencao!","Para Frete sobre vendas, obrigatorio prencher os campos";
					+CRLF+" Nf Ret Sai(D1_NFRSAI) e Seri Ret Sai (D1_SERSAI ) .";
					+CRLF+" item ."+str(nX),;					
					{"Voltar"},1)

					lRet := .F.
				Endif
			Endif

		Next

		If Empty(aNFEDanfe[1])
			If !(Alltrim(CESPECIE) $ "REC|NFE|CTE")
				If cTipo $ "N|D|B"
					For nX := 1 To Len(aCols)
						cProd	:= Alltrim(aCols[nX,GDFIELDPOS("D1_COD")])

						dbselectarea("SB1")
						DbSetOrder(1)
						MsSeek(xFilial("SB1")+cProd)

						IF SB1->B1_POLFED == 'S'
							lPolicia := .T.
						EndIf

						IF SB1->B1_POLCIV == 'S'
							lPolicia := .T.
						EndIf
					Next

					If lPolicia
						Aviso("Atencao!","Há produto controlado."+ CRLF + "Obrigatório Preencher o Campo Transportadora."+ CRLF + "ABA - Informações DANFE.", {"Voltar"}, 1)
						lRet := .F.
					Endif
				Endif
			EndIf
		EndIf

	Endif
	RestArea(aArea)

Return(lRet)
