
// Rotinas na inicializa��o do Sistema PROTHEUS
// Projeto Validacao OK
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SIGAFAT   � Autor �                 � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada ao entrar no Modulo de Faturamento        ���
���          � Utilizado para efetuar filtros quando o grupo represent.   ���
���          � estiverem utilizando o modulo                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SIGAFAT(lLimpa)

Local _cIni			:=	""
Local _cIP			:=	""
Local _cAux			:=	""
Local aTabelas		:= {"SE4","SA3"}
Local nI			:= 0

Default lLimpa 		:= .F.

For nI := 1 to Len(aTabelas)
	DbSelectArea(aTabelas[nI])
	U_DbFiltro(aTabelas[nI], lLimpa)
Next nI

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DbFiltro  � Autor � 		                � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao Auxiliar da SIGAFAT                                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � 		                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DbFiltro(xDB, lLimpa) // Filtros

Local cMvGrp 		:= SuperGetMV("MV_GRPREP",,"")
Local lVld			:= SuperGetMV("MV_VLDGRP",,.F.)
Public IdUsuario		:= ""
Default lLimpa		:= .F.

PswOrder(1)
PSWSeek(__CUSERID, .T.)
aUser      	:= PswRet(1)
IdUsuario  	:= aUser[1][1]  	// codigo do usuario     
GrpUser		:= IIF(LEN(aUser[1][10]) > 0 , aUser[1][10][1], "000000") 	// Grupo Que o usuario Pertence

// Se o Grupo do usuario nao for o dos Representantes, ou o parametro estiver desligado sai da rotina !!!
If !GrpUser $ cMvGrp .or. !lVld 
	Return()
Endif


Do Case
	Case xDB == "SE4"
		If lLimpa
			SE4->(DbClearFilter())
		Else
			SE4->(DbSetFilter({|| E4_X_VEND == 'S'},"E4_X_VEND == 'S'"))
		EndIf
	Case xDB == "SA3"
		If lLimpa
			SA3->(DbClearFilter())
		Else
			SA3->(DbSetFilter({||A3_CODUSR == IdUsuario},"A3_CODUSR == IdUsuario"))
		EndIf
Endcase

Return Nil