#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410 �Autor  �Opvs (David)           � Data �  16/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para For�ar Estorno de Libera��o de Pedidos���
���          �de venda                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MTA410()

Local _aArea			:= GetArea()
Local _lret:=.t.	
Local nI := 0
	
	//Limpa o campo qtd liberada de forma que for�ar uma libera��o manual 
	//Para atender projeto de venda varejo e hardware avulso os pedidos ser�o registrados com quantidade liberada para faturamento igual a zero.
	//O pedido ser� liberado automaticamente atrav�s das rotinas personalizadas ou manualmente pela rotina de libera��o de pedidos
	IF !Empty(M->C5_XNPSITE)
		For nI:= 1 To Len(aCols)
			IF (aCols[nI, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})])> 0
				aCols[nI, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})] := 0
			Endif
		NEXT
    Endif
    
    //Rotina para alterar o c�digo do vendedor se tipo do Voucher for 'F'
    //Rafael Beghini - Totvs Data: 10/04/2015
    If ! Empty(M->C5_XNUMVOU)
    		U_CSFAT020(M->C5_XNUMVOU)
    EndIf
    
RestArea(_aArea)
	
Return(_lret)