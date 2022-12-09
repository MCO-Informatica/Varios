#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFINE008  �Autor  �Edson Nogueira      � Data �  28/06/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Somente os usu�rios indicados no Par�metro "MV_SA1BL"      ���
���          � poder�o alterar os campos de 'RISCO' e 'BLOQUEADO' do      ���   
���          � cadastro de Cliente. Par�metro Customizado                 ��� 
�������������������������������������������������������������������������͹��
���Uso       � Protheus 12                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function RFINE008()
   
Local _aSavArea := GetArea()
Local _cBloqueio:= M->A1_MSBLQL

If !Empty(M->A1_RISCO) .And. !Empty(M->A1_LC).And. !Empty(M->A1_VENCLC) .And. !Empty(M->A1_MOEDALC)
	_cBloqueio:= "2" //Quando os campos citados estiverem preenchidos, a campo 'Bloquado/Status' ficar� 'Ativo'
EndIf
                                                 
RestArea(_aSavArea)

Return(_cBloqueio)