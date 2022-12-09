#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RPCPC005 � Autor � Adriano Leonardo    � Data � 11/08/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de cadastro de frases de manuseio.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RPCPC005()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private _cString := "SZA"

dbSelectArea(_cString)
dbSetOrder(1) //Filial + C�digo

AxCadastro(_cString,"Frases de Manuseio",_cVldExc,_cVldAlt)

Return()