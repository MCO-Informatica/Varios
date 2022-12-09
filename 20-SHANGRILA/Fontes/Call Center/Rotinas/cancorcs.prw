#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 13/10/11 - Rotina para bloquear automaticamente orçamentos

User Function CANCORCS()

//Alert("Chamo função CANCORCS")
//========================
//Salvando o posicionamento atual
_cAlias_  := Alias()
_nRec_    := Recno()
_cIndex_  := IndexOrd()

//========================
//Testa para cancelar atendimentos vencidos
DbSelectArea("SUA")
DbSetOrder(1)
DbGoTop()
While !Eof()
	
	//========================
	//Variaveis
	xDataVal	:=SUA->UA_EMISSAO
	xData		:=SUA->UA_EMISSAO
	
	//========================
	//Monta Data
	For Y:=1 to 10
		xDataVal:=DATAVALIDA(xData+1)
		xData	:=xData+1
		If xDataVal>xData
			Y:=Y-1
		EndIf
	Next

	//========================
	//Cancela orçamento
	If SUA->UA_1OPER=="2" .And. xData<DDATABASE .And. Empty(SUA->UA_CANC)

		RecLock("SUA",.F.)
		SUA->UA_CANC:="S"
		MsUnlock()                   
	EndIf
	DbSkip()
EndDo()

DbCloseArea("SUA")

dbSelectArea(_cAlias_)
dbSetOrder(_cIndex_)
dbGoto(_nRec_)

Return()
