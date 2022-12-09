#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FILPEDFT  �Autor  �Opvs (David)        � Data �  26/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se C�digo do Pedido se Refere ao Tipo selecionado  ���
���          �na tela de Faturamento                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FILPEDFT(cPed,nTip)
Local lRet := .F.
Local aArea:= GetArea()

DbSelectArea("SC5")
SC5->(DbSetOrder(1))

// Verifica a Origem do Pedido
If DbSeek(xFilial("SC5")+cPed) 

	Do Case
		Case SC5->C5_XORIGPV ==  Alltrim(Str(nTip)) // Correspondencia direta do Tipo de Pedido 1=Manual;2=Venda Varejo;3=Venda Hardware Avulso;4=Televendas;5=Atendimento Externo
			lRet := .T.
			
		Case nTip == 1 .AND. Empty(SC5->C5_XORIGPV) // Vendas Varejoa
			lRet := .T.		
		
		Otherwise
			lRet := .F.					
	Endcase
	 
Else
	lRet := .F.
	
EndIf

RestArea(aArea)
Return(lRet)