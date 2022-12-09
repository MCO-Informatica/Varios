/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ OPCalcP  | Autor ³ Bruno Abrigo          ³ Data ³ 03/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos           ³±±
±±³de Peso Bruto e Peso Liquido do Pedido de Vendas				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function OPCalcP(cValor)
Local nVolume := 0
Local nPesoBruto := 0
Local nPesoLiqui := 0
Local _cProd	 :=Alltrim(M->C2_PRODUTO)

Posicione("SB1",1,xFilial("SB1")+_cProd,"")

// Posiciona-se no item do pedido atual gravado e efetua o abatimento caso o mesmo já tenha sido atendido parcialmente

lOk := .f.
lAc := .t.

// Posiciona Registro do Conteudo da Embalagem
If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+Alltrim(M->C2_XEMBALA )))
	lAc := .f.
Endif
// Posiciona Registro do Tipo da Embalagem
If !Z05->(dbSetOrder(1), dbSeek(xFilial("Z05")+Z06->Z06_EMBALA))
	lAc := .f.
Endif

If lAc	// Se Encontrou os Registros de Embalagem então Calculo, senão, irá abrir tela para digitação
	
	&&Quantidade de Caixas/Item    &&Oscar
	nxCaixa	:=  M->C2_QUANT /Z06->Z06_QTDMAX
	nInt  := Int(nxCaixa)
	nFrac := (nxCaixa - nInt)
	If !Empty(nFrac)
		nInt++
	Endif
	nxCaixa := nInt
	nxCaixa := Iif(Empty(nxCaixa),1,nxCaixa)
	
	&&Peso Liquido/Item
	nxPliqu:=Z06->Z06_PESOUN* M->C2_QUANT
	&&Peso Bruto/Item
	nxPbrut:=Z06->Z06_PESOUN* M->C2_QUANT +(Z05->Z05_PESOEM*nxCaixa)
	
	// Preenche Vetores aCols Posicionado
	nInt  := Int(nxCaixa)
	nFrac := (nxCaixa - nInt)
	If !Empty(nFrac)
		nInt++
	Endif
	nxCaixa := nInt
	
	M->C2_XVOLITE  := nxCaixa
	M->C2_XPBITEM  := nxPbrut
	M->C2_XPLITEM  := nxPliqu
Endif

//GetDRefresh()
Return cValor
