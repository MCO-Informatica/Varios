&&=GAT_014.PRW
&&=Narques - Dez.2015 - Totvs MC.
User Function GAT_014(cCHA_PSQ)

&&=Tratar primeira condição - Produto.
If cCHA_PSQ == 'PRODUTO'
	&&=Gravar Código do Produto
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
			ZPR->ZPR_PAR03 :=  M->C6_PRODUTO                    && Código do Produto.
			&&=Destravar o Registro.
			MsUnLock()  &&   unlock
		else
			MsgAlert("Registro nao pode ser alterado")
		Endif
	Endif
	&&=Alteração
	If cFLAZPR == 'CHEIO'
		If RecLock("ZPR",.F.)  && F=Alt.
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_FILIAL :=  xFILIAL("ZPR")
			ZPR->ZPR_COD   :=  cCodUser + '/PV'
			ZPR->ZPR_DESC   :=  'PEDIDOS DE VENDAS'
			&&
			ZPR->ZPR_PAR03 :=  M->C6_PRODUTO              && Código do Produto.
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

&&=Tratar primeira condição - Quantidade de Displays
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
	&&=Alteração
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

&&=Tratar Condição  Descrição.
If cCHA_PSQ == 'DESCRICAO''
	
	&&=Par.Usuários - Ped. Vendas.
	cCHAVE01 := cCodUser
	cCHAVE02 := "/PV"   + space(30 - (6+3) )
	dbSelectArea("ZPR")
	dbSetOrder(1)
	DbSeek(xFilial("ZPR") + cCHAVE01 + cCHAVE02)
	If ZPR->(FOUND()) && Existe.
		cCOD_PROD   := Substr( ZPR->ZPR_PAR03,01,30)
		&& MsgALERT( cCOD_PROD, ' Tabela ZPR - Código Produto ')
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


&&=Tratar Condição  Quantidade.
If cCHA_PSQ == 'QTDVEN''
	
	&&=Par.Usuários - Ped. Vendas.
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
				M->C6_QTDVEN  := 01 * Val(ZPR->ZPR_PAR02)    && Quantidade de produtos para a área de Provadores (Exemplo: 1) multiplicado pela qtde. de Displays.
			Endif
		Endif
		&&=Total de Produtos no Display
		nBM_XTOTPR  :=  SBM->BM_XTOTPR        && Total de Produtos no Display.
	Else
		cDADOX := 'GRUPO NAO ENCONTRADO '  + cCHA_PSQ01 + '/'  + cCHA_PSQ02
		MsgALERT( cDADOX )
	Endif
	
Endif

&&=Tratar Condição  Preço de Venda.
If cCHA_PSQ == 'PRCVEN'
	
	&&=Par.Usuários - Ped. Vendas.
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
		&&=Incluir Preço Zerado.
		If nB1_PRV1    < 0.01
			cDADO := "O preço de venda no cadastro de produtos está ZERADO. Informe um preço válido. (O mesmo será gravado na tabela de Produtos, SB1). Muito obrigado."
			MsgALERT( cDADO )
			If RecLock("SB1",.F.)  && F=Alt.
				SB1->B1_PRV1    :=   M->C6_PRCVEN
				&&=Destravar o Registro.
				MsUnLock()  &&   unlock
			else
				MsgAlert("Registro nao pode ser alterado")
			Endif
		Endif
		&&=Incluir Preço Atualizado
		cRESP := 'S'
		If nB1_PRV1    > 0.01   && Preço já foi alterado anteriormente
			If SB1->B1_PRV1 <> M->C6_PRCVEN
				If MsgYesNo("Altera tabela de preços do Produto?", "ATUALIZAÇÃO DE PREÇO DE PRODUTO")
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

