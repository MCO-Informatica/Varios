#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RCRMC002 � Autor � Derik Santos        � Data � 30/12/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de cadastro da Analise de Conta  .                  ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RCRMC002()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private _cString := "SZM"

dbSelectArea(_cString)
dbSetOrder(1) //Filial + C�digo

AxCadastro(_cString,"Analise de Conta",_cVldExc,_cVldAlt)

Return()