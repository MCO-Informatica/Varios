#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
 �������������������������������������������������������������������������Ŀ��
���Funcao	 � MTAGRSD4 � Autor � Adriano Leonardo    � Data � 11/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada ap�s a grava��o dos empenhos, utilizado   ���
���          � para gravar dados complementares (tipo de balan�a).        ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MTAGRSD4()

Local _aSavArea := GetArea()
Local _aSavSB1	:= SB1->(GetArea())
Local _cRotina	:= "MTAGRSD4"
Local _cBalanc	:= "N" //Nenhuma

dbSelectArea("SB1")
dbSetOrder(1)
If SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))
	If SB1->B1_UM=="KG"
		If SD4->D4_QUANT < 5
			_cBalanc := "1" //Balan�a 1
		ElseIf SD4->D4_QUANT < 15
			_cBalanc := "2" //Balan�a 2
		Else
			_cBalanc := "S" //Silo
		EndIf
	EndIf
EndIf

RecLock("SD4",.F.)
	SD4->D4_BALANCA := _cBalanc
SD4->(MsUnlock())
     
//----------------- For�a o preenchimento do campo C2_BATCH para n�o excluir a OP quando o empenho for inclu�do manualmente.
//dbSelectArea("SC2")
//dbSetOrder(1)
//If SB1->(dbSeek(xFilial("SC2")+SD4->D4_OP))
//	RecLock("SC2",.F.)
//	SC2->C2_BATCH := "S"
//Endif

RestArea(_aSavSB1)
RestArea(_aSavArea)

Return()