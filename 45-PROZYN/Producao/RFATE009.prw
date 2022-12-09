#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RFATE009 � Autor � Adriano Leonardo    � Data � 11/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de cadastro de faixas de c�digo de barras EAN 13.   ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RFATE009()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private _cString := "SZD"

dbSelectArea(_cString)
dbSetOrder(1) //Filial + C�digo

AxCadastro(_cString,"Faixas de c�digo de barras",_cVldExc,_cVldAlt)

Return()