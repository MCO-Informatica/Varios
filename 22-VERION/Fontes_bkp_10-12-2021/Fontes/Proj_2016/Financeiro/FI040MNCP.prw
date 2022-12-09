
#include "protheus.ch"
#include "topconn.ch"

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    �FI040MNCP � Ponto de entrada na montagem do arquivo tempor�rio para      ���
���             �          � montar os campos a serem exibidos na tela dos movimentos     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpA1 = Array contendo a Descri��o e o Campo do Arquivo para montagem   ���
���             �         do arquivo tempor�rio.                                          ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Verion                                                                  ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/

User Function FI040MNCP()

Local aBrowse := ParamIXB[1]

aAdd(aBrowse,{"Arquivo Cnab","CP_ARQCNAB"})

Return(aBrowse)
