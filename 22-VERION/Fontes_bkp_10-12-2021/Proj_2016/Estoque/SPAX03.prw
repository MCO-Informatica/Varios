#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SPAX03   � Autor � Ricardo Cavalini   � Data �  03/02/2009 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de auditoria movimentos internos                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Verion                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SPAX03

dbSelectArea("SZ4")
dbSetOrder(1)

AxCadastro("SZ4","Cadastro Auditoria Movimentos Internos",".T.",".T.")

Return