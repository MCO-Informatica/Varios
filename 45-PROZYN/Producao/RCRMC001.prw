#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RCRMC001 � Autor � Adriano Leonardo    � Data � 11/10/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de taxas para proje��o do forecast em outras moedas ���
���          � diferentes de real.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RCRMC001()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private _cString := "SZC"

dbSelectArea(_cString)
dbSetOrder(1) //Filial + C�digo

AxCadastro(_cString,"Taxas Forecast",_cVldExc,_cVldAlt)

Return()