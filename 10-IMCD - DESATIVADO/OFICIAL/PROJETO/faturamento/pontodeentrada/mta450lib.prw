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
Local lRet	    := .F.
Local nReg		:= SC9->(Recno())

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA450LIB" , __cUserID )

Private _cObs     := ""

DbSelectArea("SC9")
DbSetOrder(1)
DbSeek(xFilial("SC9")+cPedido+cItem)
lRet := .T.
cEvento := "Liber��o de credito MTA450LIB" //"2.Liberacao Faturar"
//gravar o Log do pedido na tabela SZ4
U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,cEvento, ,SC9->C9_ITEM)

//Muda para o campo C5_LIBCRED para X para possibilitar a legenda
SC5->( dbSetOrder(1) ) //C5_FILIAL+C5_NUM
if SC5->( dbSeek( xFilial("SC5")+SC9->C9_PEDIDO ) )
	recLock("SC5", .F.)
	SC5->C5_LIBCRED := "X"
	SC5->( msUnlock() )
endif

RestArea(_aArea)
SC9->(DbGoto(nReg))

Return (lRet)
