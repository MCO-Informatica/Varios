#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � JobFinan   �Autor  � Luiz Alberto   � Data �  Nov/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Job Departamento Financeiro, envio de aviso de titulos a
				a vencer e vencidos
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA685BUT()
Local aButtons := {}

Aadd(aButtons, {'PRODUTO',{||A685Mtela()},OemToAnsi('1o.Nivel'),OemToAnsi("Explos�o do 1� n�vel da estrutura")}) //"Explos�o do 1� n�vel da estrutura",//1� Nivel 

Return aButtons