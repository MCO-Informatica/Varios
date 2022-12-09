#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

User Function SW006()

Local nReg    := SC5->( Recno() )

dbSelectArea("SC5")
dbSetOrder(1)

AxAltera("SC5",nReg,3,, /*aCpos*/)

If MsgYesNo("Deseja trocar o vendedor nas comissões já geradas?","Atenção")
	dbSelectArea("SE3")
	dbSetOrder(5)
	If dbSeek(xFilial("SE3")+SC5->C5_NUM,.F.)
		While Eof() == .f. .And. SE3->E3_PEDIDO == SC5->C5_NUM
			RecLock("SE3",.f.)
			SE3->E3_VEND := SC5->C5_VEND1
			MsUnLock()
			dbSelectArea("SE3")
			dbSkip()
		EndDo
	EndIf
EndIf

Return
