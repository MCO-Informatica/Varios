#INCLUDE "PROTHEUS.CH"

User Function MT410ALT()
Local _lRet := .T.

// Limpa flag de pedido reprovado
if SC5->C5_X_REP == "R"
	RecLock("SC5")
	SC5->C5_X_REP := " "
	MsUnLock()
endif

// Limpa flag da legenda laranja da Daisy (pedido liberado no credito)
RecLock("SC5")
SC5->C5_LIBCRED := " " // limpa liberação de Credito

// efetua o cancelamento da Coleta se houver
If !Empty( SC5->C5_COLETA)
	//   U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Cancelar Coleta ','Cancelamento de Coleta Nr: '+SC5->C5_COLETA , ,"Alteracao no Pedido")
	U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Estorno coleta PV',"Alteracao no Pedido")
	
	//SC5->(RecLock("SC5",.F.))
	SC5->C5_DTCOLR  := ctod('')
	SC5->C5_HRCOLR  := ''
	SC5->C5_PORTA   := ''
	SC5->C5_PLACA   := ''
	SC5->C5_SOLCOL  := ctod('')
	SC5->C5_REIMP   := 0
	SC5->C5_COLETA  := ''
	SC5->C5_DTCOL   := ctod('')
	SC5->C5_XRCOL := "1"
	//SC5->( MsUnLock() )
Endif

MsUnLock()

Return( _lRet )
