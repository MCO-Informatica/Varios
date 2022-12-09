#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao	 � CTBGRV   � Autor � Joao Goncalves de Oliveira � Data � 02/08/16 ���
������������������������������������������������������������������������������Ĵ��
���Descri??o � Ponto de Entrada na Grava��o do Lan�amento Cont�bil 	 	       ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe	 � U_CTBGRV() 	                 				          		   ���
������������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum 														   ���
������������������������������������������������������������������������������Ĵ��
�� Retorno   � Nenhum												   		   ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/

User Function CTBGRV()

Local nNumeRegi := CT2->(Recno())
Local cNomeArqu := "CSPCO010_" + StrZero(Year(CT2->CT2_DATA),4)
Local cQuryUpda := ""

If ParamIxb[1] == 4
	If TcCanOpen(cNomeArqu)
		cQuryUpda += " UPDATE " + cNomeArqu + " SET FLAG_CONTA = '04'"
		cQuryUpda += " WHERE REC = '" + AllTrim(Str(nNumeRegi)) + "'"
		MemoWrite("cQuryUpda.SQL",cQuryUpda)
		TcSqlExec(cQuryUpda)
	EndIf
EndIf
Return
