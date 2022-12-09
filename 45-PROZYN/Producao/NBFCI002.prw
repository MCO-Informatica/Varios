#INCLUDE "PROTHEUS.CH" 

#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � NBFCI002 � Autor � Daniel Paulo        � Data � 18/07/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de visualiza�ao calculo FCI					      ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function NBFCI002()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cVldAlt := ".F." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private _cString := "CFD"

dbSelectArea(_cString)
dbSetOrder(1) //Filial + C�digo

AxCadastro(_cString,"Historico Calculo FCI",_cVldExc,_cVldAlt)

Return()
