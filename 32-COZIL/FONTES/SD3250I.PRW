#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD3250I   ºAutor  ³WILLIAM LUIZ ANTUNESº Data ³  01/27/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de Entrada - Ordem de producao				    º±±
±±º          ³                                                            º±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            

User Function SD3250I()  
    
    Local nQuant 		:= 0 	//QUANTIDADE A SER PRODUZIDA  
    Local nQuje		:= 0		//QUANTIDADE JA PRODUZIDA
    Local nSaldo		:= 0		//SALDO PENDENTE PARA PRODUZIR
    Local cPedido		:= ""	//NUMERO DO PEDIDO DE VENDA (USADO PARA FAZER A VALIDACAO: EXISTE PEDIDO DE VENDAS?
    							//CASO NAO O SISTEMA NAO TENTA REALIZAR A BAIXA NO PAINEL.)
    
    nQuant	:= Posicione("SC2",1,xFilial("SC2") + SD3->D3_OP,"C2_QUANT")
    nQuje	:= Posicione("SC2",1,xFilial("SC2") + SD3->D3_OP,"C2_QUJE")
	nSaldo	:= (nQuant - nQuje)                                        
	cPedido	:= Posicione("SC2",1,xFilial("SC2") + SD3->D3_OP,"C2_PEDIDO")    
    
    /*
	If cPedido == "" .OR. cPedido == "      " //6 espacos
		Alert("OP Manual")
		Return()	
	EndIf
		                       
	If nSaldo == 0 .AND. (cPedido != "" .AND. cPedido != "      ")
		Alert("Será dado baixa no pedido: "  + cPedido)
		DbSelectArea("SC6")
		DbSetOrder(7)
		If !DbSeek(xFilial("SC6")+SD3->D3_OP)
			Alert("Não foi possível dar a baixa automática no PAINEL DO PEDIDO")
			Alert("Favor comunique o administrador do sistema! - Informe o ERRO: SD3250I-01-" + cPedido)
		Else  
			If SC6->C6_XSTATUS >= "7"
				Alert(SC6->C6_XSTATUS)
				RecLock("SC6",.F.)
					SC6->C6_XSTATUS := "8"  
				MsUnlock()
			Else
				Alert("Ateção! - A OP nao foi baixada no painel do pedido pois o item não está liberado para expedicao.") 
				Alert("Não esqueça de fazer a liberação manualmente!")            
			EndIf    
		EndIf
	EndIf
	*/
		
Return()
