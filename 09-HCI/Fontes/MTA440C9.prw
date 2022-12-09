User Function MTA440C9()                                   
	IF(!SC5->C5_ANTECIP) //  bloqueia Item no SC9 se Pedido nao permitir antecipação
		IF SC6->C6_ENTREG > Date()
		   SC9->C9_BLOQUEI := StrZero(1, Len(SC9->C9_BLOQUEI))                     
		   SC9->C9_BLINF   := "Bloqueio por Data de Entrega Futura"		   
		EndIF
	EndIF

  	IF(SC5->C5_TIPLIB == "2") // bloqueia Item no SC9 se Pedido nao permitir liberacao parcial por item
  	    IF (!SC5->C5_ENTPARC)
 			IF SC9->C9_QTDLIB <> SC6->C6_QTDVEN
		   		SC9->C9_BLOQUEI := StrZero(1, Len(SC9->C9_BLOQUEI))                     
		   		SC9->C9_BLINF   := "Bloqueio por Liberação parcial do item"
			EndIF
		EndIF
	EndIF
Return .T.