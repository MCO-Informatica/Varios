#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 14/09/11 - Ponto de entrada que antecede o atendimento
//========================================================================================================================================================

#INCLUDE "protheus.ch"

User Function TK271ABR()             







If FUNNAME()<>"TMKA380"
	If Altera .And. SUA->UA_OPER=="1"
	Alert("Pedido de venda n�o pode ser alterado.")
	Return(.F.)
	EndIf
EndIf

//tmka380
If SUA->UA_IMP<>"N" .And. SUA->UA_1OPER=="2" .And. SUA->UA_FLAG=="3"
	RecLock("SUA",.F.)
	SUA->UA_IMP	:="N"
	SUA->UA_FLAG:="1"
	MsUnLock()
	Alert("A permiss�o de impress�o desse or�amento foi bloqueada em raz�o do mesmo ter sido aberto para altera��o.Dever� ser liberado novamente")
EndIf


Return(.T.)

