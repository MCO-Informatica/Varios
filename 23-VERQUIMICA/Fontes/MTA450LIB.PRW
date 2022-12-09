#INCLUDE 'PROTHEUS.CH'

//==================================================================================
// Programa.....: MTA450LIB
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Ponto de entrada para verificar quais usuarios podem liberar credito
// Uso..........: Verquimica
//==================================================================================

User Function MTA450LIB()

//==================================
// Variaveis da Rotina
//==================================
Local lRet      := .T.
Local cUsrLib   := __cUserID

dbSelectArea("SX6")
SX6->(dbSetOrder(1))
SX6->(dbSeek(xFilial("SC5")+"MV_VQLIBF" ))

If !(cUsrLib $ SX6->X6_CONTEUD)
    msgStop("Usuário sem autorização para liberar crédito","MV_VQLIBF - MTA450LIB")
    lRet := .F.
Else
    dbSelectArea("SC5")
    SC5->(dbSetOrder(1))
    If SC5->(dbSeek(xFilial("SC5")+ParamIXB[1] ))
        RecLock("SC5",.F.)
        SC5->C5_VQ_LIBF	:= 'S'
        SC5->(msUnlock())
    EndIf
EndIf

Return(lRet)

