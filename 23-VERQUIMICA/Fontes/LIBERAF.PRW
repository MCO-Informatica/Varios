#include "rwmake.ch"
#include "Protheus.ch"


User Function LIBERAF()

Local _cUsuario	 := Upper(Alltrim(__cUserID))
Local _cQuemLibF := ""


DbSelectArea("SX6")
DbSetorder(1)
DbgoTop()
If !Dbseek(xFilial("SC5")+"MV_VQLIBF")
	Reclock("SX6",.T.)
	SX6->X6_FIL:=xFilial("SC5")
	SX6->X6_VAR:="MV_VQLIBF"
	SX6->X6_TIPO:="C"
	SX6->X6_DESCRIC :="Usuarios que irao liberar financeiro"
	SX6->X6_CONTEUD :="000000/"
	MsUnlock()
EndIf

_cQuemLibF := Alltrim(Upper(GETMV("MV_VQLIBF")))

If _cUsuario $ _cQuemLibF 
    dbSelectArea("SC5")
    dbSetOrder(1)
    If dbSeek(xFilial("SC5")+SC9->C9_PEDIDO,.F.)
	    RecLock("SC5",.f.)
	    SC5->C5_VQ_LIBF	:= 'S'   //----> FORCA A LIBERACAO FINANCEIRA MESMO COM PROBLEMAS DE CREDITO E/OU ATRASO
		SC5->C5_VQ_USL2  := cUserName
		SC5->C5_VQ_DTL2  := Date()
		SC5->C5_VQ_HRL2  := Time()

	    MsUnLock()
		MsgAlert("O pedido "+SC5->C5_NUM+" foi liberado mesmo com pendências financeiras.")
	EndIf
Else
	MsgAlert("Usuário não tem permissão para liberar as pendências financeiras.")
EndIf

Return()
