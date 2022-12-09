/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � OPCalcP  | Autor � Bruno Abrigo          � Data � 03/03/12 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Funcao responsavel pelo preenchimento dos campos           ���
���de Peso Bruto e Peso Liquido do Pedido de Vendas				          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function OPCalcP(cValor)
Local nVolume := 0
Local nPesoBruto := 0
Local nPesoLiqui := 0
Local _cProd	 :=Alltrim(M->C2_PRODUTO)

Posicione("SB1",1,xFilial("SB1")+_cProd,"")

// Posiciona-se no item do pedido atual gravado e efetua o abatimento caso o mesmo j� tenha sido atendido parcialmente

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

If lAc	// Se Encontrou os Registros de Embalagem ent�o Calculo, sen�o, ir� abrir tela para digita��o
	
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
