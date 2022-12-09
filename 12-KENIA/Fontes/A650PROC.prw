#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A650PROC  � Autor � GENILSON LUCAS - MVG	� Data � 27/07/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para apagar a OP se necess�rio.			  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Shangri-la                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A650PROC()
                
Private lApagaOP

If FUNNAME() = "MATA650"
	If	lApagaOP
	   Tmata650()
	   lApagaOP := .F.
	EndIf
EndIf
Return()

Static Function Tmata650()

Local aVetor := {}
lMsErroAuto := .F.

aVetor:={ {"C2_NUM",nOP,NIL},;
{"C2_ITEM",nItem,NIL},;
{"C2_SEQUEN",nSequen,NIL}}

MSExecAuto({|x,y| mata650(x,y)},aVetor,5) //Exclusao

If lMsErroAuto
	Alert("Erro")
Else
	MsgAlert("OP apagada com sucesso!")
Endif
//A650OpenBatch()
A650CloseBatch()
Return()