User Function MT250TOK
Local lRet := ParamIXB //-- Validação do Sistema
Local cProduto	:=	M->D3_COD

If SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))
	lRastro   := Rastro(SB1->B1_COD)
	lRastroS  := Rastro(SB1->B1_COD, 'S')
	lLocaliza := Localiza(SB1->B1_COD)
	If lRastro .Or. lLocaliza
		If Empty(M->D3_LOTECTL)
			MsgStop("Atenção é Obrigatório o Preenchimento do Campo Lote, Para Produtos com Rastreabilidade !")
			Return .f.
		Endif
	Endif
Endif

//-- Customizações do Usuario    
Return lRet  //-- (.T.) Valida apontamento de produção