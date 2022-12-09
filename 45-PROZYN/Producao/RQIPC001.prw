#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RQIPC001 � Autor � Derik SAntos        � Data � 15/08/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de cadastro de Frases do Rotulo.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RQIPC001()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private _cString := "SZ7"

dbSelectArea(_cString)
dbSetOrder(1) //Filial + C�digo

AxCadastro(_cString,"Cadastro de Frases R�tulo",_cVldExc,_cVldAlt)

Return()