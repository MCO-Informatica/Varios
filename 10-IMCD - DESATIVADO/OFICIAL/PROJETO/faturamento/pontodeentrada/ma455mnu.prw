#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SET.CH"
#Include "FILEIO.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA455MNU  � Autor �  Daniel   Gondran  � Data �  06/02/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Desbloqueio Manual de WMS                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Botao na rotina de libera��o de estoque                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA455MNU()

	if !(cEmpAnt == '02')
		aadd( aRotina, {"Desbl.WMS","U_A455DES",0,2,0,NIL} )
	Endif

Return( .T. )


User Function A455DES()
	Local cEvento := 'Liberacao Estoque'
	Local cMotivo := "Desbloqueio manual do Pedido"

	If MsgYesNo( cMotivo + SC9->C9_PEDIDO + " Item " + SC9->C9_ITEM)
		RecLock("SC9",.F.)
		SC9->C9_BLWMS := " "
		msUnlock()

		cMotivo += " - Bot�o Desbl.WMS - MA455MNU"

		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,cEvento, cMotivo ,SC9->C9_ITEM)

	Endif

Return nil
