#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA450LIB� Autor � Paulo - ADV Brasil � Data �  06/10/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para a efetiva��o das 1as. e 2as. libera- ���
���          � ��es de Cr�dito para Faturamento                           ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI  MATA450                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA450LIB()

	Local _aArea 	:= GetArea()
	Local cPedido 	:= Paramixb[1]
	Local cItem 	:= Paramixb[2]
	Local nOpcao 		:= Paramixb[3]
	Local lRet	    := .T.// .F.
	Local nReg		:= SC9->(Recno())
	Private cEmpresa := Alltrim(SM0->M0_CODIGO)+"/"+Alltrim(SM0->M0_CODFIL)+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )

/*
	Private _cObs     := ""

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido+cItem)
	lRet := .T.
	cEvento := "Liber��o de credito MTA450LIB" //"2.Liberacao Faturar"
	//gravar o Log do pedido na tabela SZ4
	//U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,cEvento, ,SC9->C9_ITEM)

	If nOpcao == 1 .or. nOpcao == 4
		lExibMsg := .T.
		U_VALIDCONDPAG(SC5->C5_NUM,SC5->C5_CONDPAG, SA1->A1_COND, lExibMsg)

		IF MsgYesNo("Liberar o Pedido com diverg�ncia de Condi��o de Pagamento","MTA450LIB")
			U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"Cond Pagto.","", ' ' ,"liberado ap�s diverg�ncia")

		else
			lRet := .f.
		ENDIF

	EndIf

	if lRet
		//Muda para o campo C5_LIBCRED para X para possibilitar a legenda
		SC5->( dbSetOrder(1) ) //C5_FILIAL+C5_NUM
		if SC5->( dbSeek( xFilial("SC5")+SC9->C9_PEDIDO ) )
			recLock("SC5", .F.)
			SC5->C5_LIBCRED := "X"
			SC5->( msUnlock() )
		endif

	ENDIF
*/
	RestArea(_aArea)
	SC9->(DbGoto(nReg))

Return (lRet)
