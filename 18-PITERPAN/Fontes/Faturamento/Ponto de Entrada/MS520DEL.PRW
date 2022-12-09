USER FUNCTION MS520DEL()
Local _aArea := GetArea()
		
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO,.F.)


dbSelectArea("SC9")
dbSetOrder(1)
If dbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO,.F.)
    
	While Eof() == .f. .And. SC9->(C9_FILIAL+C9_PEDIDO) == SD2->(D2_FILIAL+D2_PEDIDO)
		//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		RecLock("SC9",.f.)
		SC9->C9_X_PRIOR		:=	SC5->C5_X_PRIOR
		MsUnLock()
		//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
		dbSkip()
	EndDo
EndIf
			
RestArea(_aArea)
RETURN()