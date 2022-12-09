#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#Include 'rwmake.ch'
#include 'COLORS.CH'
#include 'tbiconn.ch'

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲uncao	 � CTBGRV   � Autor � Joao Goncalves de Oliveira � Data � 02/08/16 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri??o � Ponto de Entrada na Grava玢o do Lan鏰mento Cont醔il 	 	       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe	 � U_CTBGRV() 	                 				          		   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros� Nenhum 														   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
背 Retorno   � Nenhum												   		   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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
