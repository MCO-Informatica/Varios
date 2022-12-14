&&=GAT_014.PRW
&&=Narques - Dez.2015 - Totvs MC.
User Function GAT_014(cCHA_PSQ)

&&=Tratar primeira condi??o - Produto.
If cCHA_PSQ == 'PRODUTO'
	&&=Gravar C?digo do Produto
	&&=Gravar n.do Pedido de Vendas e trecho de descr. selecionada no arq. Tab.Usuarios.
	cCHAVE01 := cCodUser
	cCHAVE02 := "/PV" + space( 30 - (6+3) )
	dbSelectArea("ZPR")
	dbSetOrder(1)
	DbSeek(xFilial("ZPR") + cCHAVE01 + cCHAVE02)
	cFLAZPR := 'VAZIO'
	If ZPR->(FOUND()) && Existe.
		cFLAZPR := 'CHEIO'
	Else
		cFLAZPR := 'VAZIO'
	Endif
	&&=Inclusao.
	If cFLAZPR == 'VAZIO'
		If RecLock("ZPR",.T.)  && T=Inc.
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_COD   :=  cCodUser + '/PV'
			ZPR->ZPR_DESC   :=  'PEDIDOS DE VENDAS'
			ZPR->ZPR_PAR03 :=  M->C6_PRODUTO                    && C?digo do Produto.
			&&=Destravar o Registro.
			MsUnLock()  &&   unlock
		else
			MsgAlert("Registro nao pode ser alterado")
		Endif
	Endif
	&&=Altera??o
	If cFLAZPR == 'CHEIO'
		If RecLock("ZPR",.F.)  && F=Alt.
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_COD   :=  cCodUser + '/PV'
			ZPR->ZPR_DESC   :=  'PEDIDOS DE VENDAS'
			&&
			ZPR->ZPR_PAR03 :=  M->C6_PRODUTO              && C?digo do Produto.
			&&=Destravar o Registro.
			MsUnLock()  &&   unlock
		else
			MsgAlert("Registro nao pode ser alterado")
		Endif
	Endif
	
	&&=Acessar Tabela Produtos.
	cCHA_PSQ01 := M->C6_PRODUTO
	cCHA_PSQ02 := ""
	cB1_UM    :=   ''
	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1") + cCHA_PSQ01 + cCHA_PSQ02)
	If SB1->(FOUND()) && Existe.
		M->C6_UM           :=  SB1->B1_UM
		M->C6_XDESC     :=  SB1->B1_DESC
	Else
		cDADOX := 'PRODUTO NAO ENCONTRADO ' + cCHA_PSQ01 + '/'  + cCHA_PSQ02
		MsgALERT( cDADOX )
	Endif
	dbSelectArea("SC6")
	&&
Endif

&&=Tratar primeira condi??o - Quantidade de Displays
If cCHA_PSQ == 'XQTDIS'
	&&=Gravar Quantidade de Displays
	cCHAVE01 := cCodUser
	cCHAVE02 := "/PV" + space( 30 - (6+3) )
	dbSelectArea("ZPR")
	dbSetOrder(1)
	DbSeek(xFilial("ZPR") + cCHAVE01 + cCHAVE02)
	cFLAZPR := 'VAZIO'
	If ZPR->(FOUND()) && Existe.
		cFLAZPR := 'CHEIO'
	Else
		cFLAZPR := 'VAZIO'
	Endif
	&&=Inclusao.
	If cFLAZPR == 'VAZIO'
		If RecLock("ZPR",.T.)  && T=Inc.
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_COD   :=  cCodUser + '/PV'
			ZPR->ZPR_DESC   :=  'PEDIDOS DE VENDAS'
			ZPR->ZPR_PAR02 :=    Str(  M->C6_XQTDIS, 12,2)                   && Quantidade de Displays
			&&=Destravar o Registro.
			MsUnLock()  &&   unlock
		else
			MsgAlert("Registro nao pode ser alterado")
		Endif
	Endif
	&&=Altera??o
	If cFLAZPR == 'CHEIO'
		cDADO  :=    Str(  M->C6_XQTDIS, 12,2)                   && Quantidade de Displays
		&& MsgALERT( cDADO )
		If RecLock("ZPR",.F.)  && F=Alt.
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_COD   :=  cCodUser + '/PV'
			ZPR->ZPR_DESC   :=  'PEDIDOS DE VENDAS'
			&&
			ZPR->ZPR_PAR02 :=    Str(  M->C6_XQTDIS, 12,2)                   && Quantidade de Displays
			&&=Destravar o Registro.
			MsUnLock()  &&   unlock
		else
			MsgAlert("Registro nao pode ser alterado")
		Endif
	Endif
	&&
Endif

&&=Tratar Condi??o  Descri??o.
If cCHA_PSQ == 'DESCRICAO''
	
	&&=Par.Usu?rios - Ped. Vendas.
	cCHAVE01 := cCodUser
	cCHAVE02 := "/PV"   + space(30 - (6+3) )
	dbSelectArea("ZPR")
	dbSetOrder(1)
	DbSeek(xFilial("ZPR") + cCHAVE01 + cCHAVE02)
	If ZPR->(FOUND()) && Existe.
		cCOD_PROD   := Substr( ZPR->ZPR_PAR03,01,30)
		&& MsgALERT( cCOD_PROD, ' Tabela ZPR - C?digo Produto ')
	Else
		cDADOX := 'PARAM. NAO ENCONTRADO '  + cCHAVE01 + '/'  + cCHAVE02
		&& MsgALERT( cDADOX )
	Endif
	
	&&=Acessar Tabela Produtos.
	cCHA_PSQ01 := cCOD_PROD
	cCHA_PSQ02 := ""
	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1") + cCHA_PSQ01 + cCHA_PSQ02)
	If SB1->(FOUND()) && Existe.
		M->C6_XDESC   :=   SB1->B1_DESC
	Else
		cDADOX := 'PRODUTO NAO ENCONTRADO ' + cCHA_PSQ01 + '/'  + cCHA_PSQ02
		MsgALERT( cDADOX )
	Endif
	dbSelectArea("SC6")
	&&
Endif


&&=Tratar Condi??o  Quantidade.
If cCHA_PSQ == 'QTDVEN''
	
	&&=Par.Usu?rios - Ped. Vendas.
	cCHAVE01 := cCodUser
	cCHAVE02 := "/PV"   + space(30 - (6+3) )
	dbSelectArea("ZPR")
	dbSetOrder(1)
	DbSeek(xFilial("ZPR") + cCHAVE01 + cCHAVE02)
	If ZPR->(FOUND()) && Existe.
		cCOD_PROD   := Substr( ZPR->ZPR_PAR03,01,30)    && Cod. Produto
	Else
		cDADOX := 'PARAM. NAO ENCONTRADO '  + cCHAVE01 + '/'  + cCHAVE02
		MsgALERT( cDADOX )
	Endif
	
	&&=Acessar Tabela Produtos.
	cCHA_PSQ01 := cCOD_PROD    && Exemplo:  12013036181
	cCHA_PSQ02 := ""
	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1") + cCHA_PSQ01 + cCHA_PSQ02)
	If SB1->(FOUND()) && Existe.
		cB1_GRUPO   :=  SB1->B1_GRUPO   && Ex. 0002
		cB1_DESC      :=  SB1->B1_DESC
		&& MsgALERT( SB1->B1_COD  +   SB1->B1_DESC)
	Else
		cDADOX := 'PRODUTO NAO ENCONTRADO ' + cCHA_PSQ01 + '/'  + cCHA_PSQ02
		MsgALERT( cDADOX )
	Endif
	
	&&=Acessar Tabela GRUPO a partir da tabela de Produtos.
	cCHA_PSQ01 := cB1_GRUPO
	cCHA_PSQ02 := ""
	dbSelectArea("SBM")
	dbSetOrder(1)
	DbSeek(xFilial("SBM") + cCHA_PSQ01 + cCHA_PSQ02)
	If SBM->(FOUND()) && Existe.
		&&=Produtos do bojo do display
		M->C6_QTDVEN  := SBM->BM_XNCOLV     && Quantidade de produtos na Fileira Vertical, exemplo: 6
		If Val( ZPR->ZPR_PAR02) > 0
			M->C6_QTDVEN  := SBM->BM_XNCOLV * Val(ZPR->ZPR_PAR02)    && Quantidade de produtos na Fileira Vertical  (Exemplo: 6) multiplicado pela qtde. de Displays.
		Endif
		&&=Produtos do Provador
		cDADO := SubStr(cB1_DESC,01,05)
		If Upper(cDADO) == 'PROV.'   && Provador.
			M->C6_QTDVEN  := 01     && Um provador por vez.
			If Val( ZPR->ZPR_PAR02) > 0           && Quantidade de Displays
				M->C6_QTDVEN  := 01 * Val(ZPR->ZPR_PAR02)    && Quantidade de produtos para a ?rea de Provadores (Exemplo: 1) multiplicado pela qtde. de Displays.
			Endif
		Endif
		&&=Total de Produtos no Display
		nBM_XTOTPR  :=  SBM->BM_XTOTPR        && Total de Produtos no Display.
	Else
		cDADOX := 'GRUPO NAO ENCONTRADO '  + cCHA_PSQ01 + '/'  + cCHA_PSQ02
		MsgALERT( cDADOX )
	Endif
	
Endif

&&=Tratar Condi??o  Pre?o de Venda.
If cCHA_PSQ == 'PRCVEN'
	
	&&=Par.Usu?rios - Ped. Vendas.
	cCHAVE01 := cCodUser
	cCHAVE02 := "/PV"   + space(30 - (6+3) )
	dbSelectArea("ZPR")
	dbSetOrder(1)
	DbSeek(xFilial("ZPR") + cCHAVE01 + cCHAVE02)
	If ZPR->(FOUND()) && Existe.
		cCOD_PROD   := Substr( ZPR->ZPR_PAR03,01,30)    && Cod. Produto
	Else
		cDADOX := 'PARAM. NAO ENCONTRADO '  + cCHAVE01 + '/'  + cCHAVE02
		MsgALERT( cDADOX )
	Endif
	
	&&=Acessar Tabela Produtos.
	cCHA_PSQ01 := cCOD_PROD
	cCHA_PSQ02 := ""
	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1") + cCHA_PSQ01 + cCHA_PSQ02)
	If SB1->(FOUND()) && Existe.
		nB1_PRV1      :=  SB1->B1_PRV1
		&&=Incluir Pre?o Zerado.
		If nB1_PRV1    < 0.01
			cDADO := "O pre?o de venda no cadastro de produtos est? ZERADO. Informe um pre?o v?lido. (O mesmo ser? gravado na tabela de Produtos, SB1). Muito obrigado."
			MsgALERT( cDADO )
			If RecLock("SB1",.F.)  && F=Alt.
				SB1->B1_PRV1    :=   M->C6_PRCVEN
				&&=Destravar o Registro.
				MsUnLock()  &&   unlock
			else
				MsgAlert("Registro nao pode ser alterado")
			Endif
		Endif
		&&=Incluir Pre?o Atualizado
		cRESP := 'S'
		If nB1_PRV1    > 0.01   && Pre?o j? foi alterado anteriormente
			If SB1->B1_PRV1 <> M->C6_PRCVEN
				If MsgYesNo("Altera tabela de pre?os do Produto?", "ATUALIZA??O DE PRE?O DE PRODUTO")
					cRESP := 'S'
				else
					cRESP := 'N'
				endif
				&&
				If cRESP == 'S'
					If RecLock("SB1",.F.)  && F=Alt.
						SB1->B1_PRV1    :=   M->C6_PRCVEN
						&&=Destravar o Registro.
						MsUnLock()  &&   unlock
					else
						MsgAlert("Registro nao pode ser alterado")
					Endif
				Endif
				
				
			Endif
		Endif
	Endif
Endif

&&=Ret.
Return .T.

