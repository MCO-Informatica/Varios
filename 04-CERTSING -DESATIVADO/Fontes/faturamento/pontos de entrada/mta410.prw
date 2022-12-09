#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410 ºAutor  ³Opvs (David)           º Data ³  16/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para Forçar Estorno de Liberação de Pedidosº±±
±±º          ³de venda                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MTA410()

Local _aArea			:= GetArea()
Local _lret:=.t.	
Local nI := 0
	
	//Limpa o campo qtd liberada de forma que forçar uma liberação manual 
	//Para atender projeto de venda varejo e hardware avulso os pedidos serão registrados com quantidade liberada para faturamento igual a zero.
	//O pedido será liberado automaticamente através das rotinas personalizadas ou manualmente pela rotina de liberação de pedidos
	IF !Empty(M->C5_XNPSITE)
		For nI:= 1 To Len(aCols)
			IF (aCols[nI, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})])> 0
				aCols[nI, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})] := 0
			Endif
		NEXT
    Endif
    
    //Rotina para alterar o código do vendedor se tipo do Voucher for 'F'
    //Rafael Beghini - Totvs Data: 10/04/2015
    If ! Empty(M->C5_XNUMVOU)
    		U_CSFAT020(M->C5_XNUMVOU)
    EndIf
    
RestArea(_aArea)
	
Return(_lret)