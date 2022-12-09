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

Local aArea 		:= GetArea()
Local aAreaSC2	:= SC2->(GetArea())

If FUNNAME() = "MATA650"
	If	lApagaOP
	   Tmata650()
	   aDelOP   := {}
	   lApagaOP := .F.
	EndIf
EndIf

RestArea(aArea)
RestArea(aAreaSC2)
Return()

Static Function Tmata650()

Local aVetor := {}
lMsErroAuto := .F.


For i := 1 to len(aDelOP)
	/*
	aVetor:={ {"C2_NUM",nOP,NIL},;
	{"C2_ITEM",nItem,NIL},;
	{"C2_SEQUEN",nSequen,NIL}}
	*/
	
	//Posiciona na SC2 para execAuto
	SC2->(DbSetOrder(1))
	SC2->(dbSeek(xFilial("SC2") + aDelOP[i][1] + aDelOP[i][2] + aDelOP[i][3])) // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD    

	aVetor:={ {"C2_NUM",aDelOP[i][1],NIL},;
	{"C2_ITEM",aDelOP[i][2],NIL},;
	{"C2_SEQUEN",aDelOP[i][3],NIL}}
	
	MSExecAuto({|x,y| mata650(x,y)},aVetor,5) //Exclusao

	If lMsErroAuto
		Alert("Erro ao apagar OP " + aDelOP[i][1] + aDelOP[i][2] + aDelOP[i][3] )
	Else
		MsgAlert("OP " + aDelOP[i][1] + aDelOP[i][2] + aDelOP[i][3] + " apagada com sucesso!")
	Endif

Next
//A650OpenBatch()
A650CloseBatch()
Return()