#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXCADSZ4  � Autor � Rafael Alencar     � Data �  26/06/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Para uso de inclus�o de Metas/Desafios e Compromisso       ���
���          � Utilizado pelo Planejamento Estrat�gico                    ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXCADSZ4()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ4"

dbSelectArea("SZ4")
dbSetOrder(1)

AxCadastro(cString,"Objetivos Individuais",cVldExc,cVldAlt)

Return