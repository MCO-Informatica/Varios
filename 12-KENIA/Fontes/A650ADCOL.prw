#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � A650ADCOL� Autor � Paulo Trigo    	    � Data �01/07/2014���
�������������������������������������������������������������������������ĳ��
��� Descri��o� Inclus�o de Campo no aCols e no aHeader                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A650ADCOL
Local cProduto   := PARAMIXB[1]
Local nQuantPai  := PARAMIXB[2]
Local cOpcionais := PARAMIXB[3]
Local cRevisao   := PARAMIXB[4]
//If  'BR120'  $ cProduto    //As vari�veis aCols e nPosQuant s�o vari�veis privite usados no MATA650
//    aCols[Len(aCols),nPosQuant] := 1                       dar
//EndIf
Return Nil    
/*
//User Function MA650EMP
//Fazer aqui a verifica��o desejada
//Return Nil
*/