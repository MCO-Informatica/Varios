#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � COMA001  � Autor � Ricardo Felipelli  � Data �  18/08/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Manutencao do controle de encalhes                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � mp8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LS_Z05()

cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z05"

dbSelectArea("Z05")
dbSetOrder(1)

AxCadastro(cString,"Tabelas e Campos para rastreabilidade",cVldExc,cVldAlt)

Return


User Function LS_Z06()

cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z06"

dbSelectArea("Z06")
dbSetOrder(1)

AxCadastro(cString,"Rastreabilidade de banco de dados",cVldExc,cVldAlt)

Return
