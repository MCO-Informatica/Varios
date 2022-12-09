#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �JFATG001    �Autor  �Felipe Valenca    � Data �  14/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para pegar o custo m�dio do B2 e jogar no C6_PRCVEN���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "protheus.ch"
#include "rwmake.ch"

User Function JFATG001

    Local _nValor := 0

    If Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_UPRC") <> 0
        _nValor := A410Arred(Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_UPRC"),"C6_PRUNIT")
    Elseif Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_PRV1") <> 0
        _nValor := A410Arred(Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_PRV1"),"C6_PRUNIT")
    Else
        MsgAlert("Verifique as movimenta��es e/ou cadastro do produto "+ALLTRIM(M->C6_PRODUTO)+", pois o mesmo n�o possui hist�rico de pre�o.")
        _nValor := 1
    Endif

Return _nValor