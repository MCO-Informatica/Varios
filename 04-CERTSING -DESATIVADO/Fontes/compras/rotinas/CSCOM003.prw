#Include "Totvs.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100TOK  º Autor ³ Renato Ruy	     º Data ³  22/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validação para inclusão de itens e cond.Pagto no lançamentoº±±
±±º          ³ da nota fiscal de entrada.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSCOM003()
	Local lRet := .T.
	Local aArea:= { GetArea(), SC7->( GetArea() ) }
	Local nPed := Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_PEDIDO" })
	Local nProd:= Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"    })
	Local nItpc:= Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_ITEMPC" })
	Local nQtde:= Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_QUANT"  })
	Local cFilialEnt := ''
	// ----------------------------------------------------------------------------------
	// A instrução abaixo é para compatibilizar quando o pedido possui filial de entrega.
	// ----------------------------------------------------------------------------------
	cFilialEnt := SC7->( xFilEnt( xFilial( 'SC7' ) ) )
	If Len(aCols) > 0 .And. nPed > 0 .And. nProd > 0 .And. nItpc > 0 .And. nQtde > 0
		If !Empty(aCols[1][nPed])
			For nX := 1 To Len(aCols)
				If !Empty(aCols[nX][nPed])
					If Empty( cFilialEnt )
						SC7->( dbSetOrder( 4 ) )
						SC7->( dbSeek( xFilial("SC7") + aCols[nX][nProd] + aCols[nX][nPed] + aCols[nX][nItpc]) )
					Else
						SC7->( dbSetOrder( 14 ) )
						SC7->( dbSeek( cFilialEnt + aCols[nX][nPed] + aCols[nX][nItpc]) )
					Endif
					If SC7->( Found() )
						/* --> Este bloco foi comentado porque a critica está no CSFA780 <--
						If SC7->C7_COND <> cCondicao
		    				MsgInfo("A Condição de pagamento deve ser a mesma informada no Pedido de Compra.")
		    				lRet := .F.
						EndIf
						*/
						If SC7->C7_QUANT < aCols[nX][nQtde]
							MsgInfo("A Quantidade na nota não pode ser superior a do Pedido de Compras.")				
							lRet := .F.
						EndIf
					Else
						MsgInfo("O produto não é o mesmo do pedido e não será possível continuar o processo.")				
						lRet := .F.
					EndIf			
				EndIf
			Next
			
		EndIf
	EndIf	
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return(lRet)