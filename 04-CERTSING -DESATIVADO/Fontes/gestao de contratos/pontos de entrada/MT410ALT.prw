#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | MT410ALT | Autor | Rafael Beghini | Data | 10.08.2016 
//+-------------------------------------------------------------------+
//| Descr. | PE - Rotina de alteração do pedido, A410ALTERA().
//|        | É executado após a gravação das alterações.
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function MT410ALT()
	IF SC5->C5_XORIGPV == '6' //Contratos
		IF Empty( SC5->C5_MDCONTR )
			CND->( dbSetOrder(4) )
			IF CND->( dbSeek( xFilial("CND") + SC5->C5_MDNUMED ) )
				SC5->( RecLock("SC5",.F.) )
					SC5->C5_MDCONTR := CND->CND_CONTRA
				SC5->( MsUnlock() )
			EndIF
		EndIF
	EndIF
Return