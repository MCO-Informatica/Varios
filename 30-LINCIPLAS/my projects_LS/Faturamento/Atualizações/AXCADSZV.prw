#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � AXCADSZV � Autor � Ilidio Abreu           � Data � 03-02-15 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Tabela SZV - usada no controle de saldos da SuperPedidos.   ���
���          � 															   ���
���          �                                                             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso Espec�fico � Laselva                                                ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/             

User function AXCADSZV

Private cString
cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZV"

dbSelectArea("SZV")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Saldos Superpedido",cVldAlt,cVldExc)

Return