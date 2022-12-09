
#include "Protheus.ch"
#include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SACI008   �Autor  �Fernando Macieira   � Data � 16/Mar/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para impressao do cheque gerado pela      ���
���          � baixa do titulo e atualizacao do Limite de Credito.        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Verion.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SACI008()

ChamaRec()
AtuLC()

//������������������������
Static Function AtuLC()
//������������������������

Local cCliLj, nValLiq, nLC, aAreaAtu

aAreaAtu := GetArea()
cCliLj   := SE1->(E1_CLIENTE+E1_LOJA)
nValLiq  := SE1->E1_VALLIQ
nLC      := Posicione("SA1",1,xFilial("SA1")+cCliLj,"A1_LC")

If (nLC < nValLiq)
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If msSeek(xFilial("SA1")+cCliLj)
		RecLock("SA1",.f.)
		A1_LC := nValLiq
		SA1->(msUnLock())
	EndIf
EndIf

RestArea(aAreaAtu)

Return

//������������������������
Static Function ChamaRec()
//������������������������

Local cPrefixo,cNumero,cParcela,cTipo,cCliente,cLoja,cQry

cPrefixo := SE1->E1_PREFIXO
cNumero  := SE1->E1_NUM
cParcela := SE1->E1_PARCELA
cTipo    := SE1->E1_TIPO
cCliente := SE1->E1_CLIENTE
cLoja    := SE1->E1_LOJA

If Select("Work") > 0
	Work->(dbCloseArea())
EndIf

cQry	:= " SELECT COUNT(1) REGS "
cQry	+= " FROM "+RetSqlName("SEF")+" SEF (NOLOCK)"
cQry	+= " WHERE SEF.EF_FILIAL = '"+xFilial("SEF")+"'"
cQry	+= " AND SEF.EF_CART = 'R'"
cQry	+= " AND SEF.EF_PREFIXO = '"+cPrefixo+"'"
cQry	+= " AND SEF.EF_TITULO = '"+cNumero+"'"
cQry	+= " AND SEF.EF_PARCELA = '"+cParcela+"'"
cQry	+= " AND SEF.EF_TIPO = '"+cTipo+"'"
cQry	+= " AND SEF.EF_CLIENTE = '"+cCliente+"'"
cQry	+= " AND SEF.EF_LOJACLI = '"+cLoja+"'"
cQry	+= " AND SEF.D_E_L_E_T_ = ' '"
tcQuery cQry New Alias "Work"

If Work->REGS > 0 // .or. SE5->E5_MOTBX = 'DIN'   // add para pagamentos em din
	Work->(dbCloseArea())
	u_RFINR01(cPrefixo,cNumero,cParcela,cTipo,cCliente,cLoja)
EndIf

Return
