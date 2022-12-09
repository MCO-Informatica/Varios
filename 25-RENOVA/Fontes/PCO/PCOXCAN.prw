#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � UPDFST   � Autor � TOTVS Protheus     � Data �  17/07/14   ���
�������������������������������������������������������������������������͹��
��� Descricao� ponto de entrada PCOXCAN inibe a valida��o                 ���
das tabelas utilizadas no Planejamento.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User Function PCOXCAN()

Local lRet:= .F.

If AliasInDic("AMO") .Or. AliasInDic("AMQ") .Or. AliasInDic("AMR") .Or. AliasInDic("AMH") .Or. AliasInDic("AMI") .Or. AliasInDic("AMG")

Return lRet

EndIf
