/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACD100EMP �Autor  �NBC                 � Data �  17/05/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada da gera�ao da Ordem de Separacao         ���
���          �  Utilizada para verificar desconsiderar embalagem          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACD100EMP()
Local lRet    := .T.
Local cOp     := PARAMIXB[1]
Local cCod    := PARAMIXB[2]
Local nQuant  := PARAMIXB[3]
Local aArea   := getArea()
Local aAreaSB1:= SB1->(GetArea())

DbSelectArea("SB1") 
DbSetOrder(1) //B1_FILIAL, B1_COD, R_E_C_N_O_, D_E_L_E_T_
If SB1->(DbSeek(xFilial("SB1")+cCod)) 

	lRet := SB1->B1_TIPO <> 'EM'
	
EndIf

Return lRet