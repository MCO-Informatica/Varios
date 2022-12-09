//------------------------------------------------------------------
// Rotina | CSFA170 | Autor | Robson Luiz - Rleg | Data | 15/05/2013
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada MTA410E, onde o 
//        | objetivo e desvincular os registros PA0 e PA1 do pedido 
//        | de venda.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function CSFA170()
	Local cPA0_OS := ''
	//--------------------------------------------
	//Atendimento externo e existe o número da OS.
	//--------------------------------------------
	If SC5->C5_XORIGPV == '5' .And. !Empty(SC5->C5_NUMATEX)
		PA1->(dbSetOrder(1))
		If PA1->(dbSeek(xFilial('PA1')+SC5->C5_NUMATEX))
			cPA0_OS := PA1->PA1_OS
			While !PA1->(EOF()) .And. PA1->(PA1_FILIAL+PA1_OS) == xFilial('PA1')+cPA0_OS
				PA1->(RecLock('PA1',.F.))
				PA1->PA1_FATURA := 'N'
				PA1->PA1_MSPED  := Space(Len(PA1->PA1_MSPED))
				PA1->(MsUnLock())
				PA1->(dbSkip())
			End
			
			PA0->(dbSetOrder(1))
			If PA0->(dbSeek(xFilial('PA0')+cPA0_OS))
				PA0->(RecLock('PA0',.F.))
				PA0->PA0_STATUS := 'C'
				PA0->PA0_SITUAC := 'B'
				PA0->(MsUnLock())
			Endif
		Endif
	Endif
Return