#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLOTEMUL � Autor � Giane - ADV Brasil � Data �  19/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � funcao para nao permitir usuario digitar qtdade nos itens  ���
���          � do orcamento/pedido, caso a qtdade nao seja multipla da    ���
���          � embalagem.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / televendas/orcamento e pedido de vendas���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VLOTEMUL(cTipo)
Local _lRet := .t.
Local _nLoteM := 0
Local cProd := ""
Local _nQuant := 0
Local nPProd := 0
Local nPQtde := 0
Local _nResto := 0
Local nPUm  := 0
Local _cUm := ""
Local _cUm2Sb1 := ""
Local _nConv := 0
Local _cTpCo := " "

////oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "VLOTEMUL" , __cUserID )
	
	if cTipo == "O" //se eh um orcamento
		cProd   := TMP1->CK_PRODUTO
		_nQuant := TMP1->CK_QTDVEN
		_cUm    := TMP1->CK_UM
		
		/*
		nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "CK_PRODUTO"})
		nPQtde := Ascan(aHeader,{|x| AllTrim(x[2]) == "CK_QTDVEN"})
		nPUm   := Ascan(aHeader,{|x| AllTrim(x[2]) == "CK_UM" })
		*/
	elseif cTipo == "P" //se eh um pedido de vendas
		nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
		nPQtde := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
		nPUm   := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_UM" })
		
	elseif cTipo == "R"  // se eh uma OP
		cProd   := M->C2_PRODUTO
		_nQuant := M->C2_QUANT
		_cUm    := M->C2_UM
		
	else // se eh uma NF entrada
		nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
		nPQtde := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"})
		nPUm   := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_UM" })
	Endif
	
	if nPProd > 0 .and. !(cTipo == "O")
		cProd   := aCols[N,nPProd]
		_nQuant := aCols[N,nPQtde]
		_cUm    := aCols[N,nPUm]
	endif
	
	_nLoteM := Posicione("SB1",1,xfilial("SB1")+cProd,"B1_LOTEMUL")
	_cUm2Sb1:= Posicione("SB1",1,xfilial("SB1")+cProd,"B1_SEGUM")
	_nConv  := Posicione("SB1",1,xfilial("SB1")+cProd,"B1_CONV")
	_cTpCo  := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPCONV")
	
	if _cUm == _cUm2Sb1 .and. _nConv > 0
		if _cTpCo == "D"
			_nLoteM := Round(_nLoteM / _nConv, 4)
		else
			_nLoteM := Round(_nLoteM * _nConv, 4)
		endif
	endif
	
	if _nLoteM > 0
		_nResto := MOD(_nQuant,_nLoteM)
		
		if _nResto > 0
			Alert("Atencao, quantidade digitada n�o � m�ltipla da Embalagem de " +  transform(_nLoteM, "@E 999.9999") )
			_lRet := .f.
		endif
	endif

Return _lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLTMUL2U � Autor � Eneo  - ADV Brasil � Data �  15/01/10   ���
����������������������2��������������������������������������������������͹��
���Descricao � funcao para nao permitir usuario digitar qtdade nos itens  ���
���          � do orcamento/pedido, caso a qtdade nao seja multipla da    ���
���          � embalagem, na segunda unidade                              ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / televendas/orcamento e pedido de vendas���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VLTMUL2U(cTipo)
Local _lRet := .t.
Local _nLoteM := 0
Local cProd := ""
Local _nQuant := 0
Local nPProd := 0
Local _nResto := 0
Local _nConv := 0
Local _cTpCo := " "

if cTipo == "O" //se eh um orcamento
	//   nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "CK_PRODUTO"})
	//   _nQuant := M->UB_XUNSVEN
elseif cTipo == "P" //se eh um pedido de vendas
	nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	_nQuant := M->C6_UNSVEN
else // se eh uma OP
	cProd  := M->C2_PRODUTO
	_nQuant := M->C2_QTSEGUM
endif

if cTipo == "O"
	cProd   := TMP1->CK_PRODUTO
	_nQuant := TMP1->CK_QTDVEN
	
elseif nPProd > 0
	cProd   := aCols[N,nPProd]
endif

_nLoteM := Posicione("SB1",1,xfilial("SB1")+cProd,"B1_LOTEMUL")
_nConv := Posicione("SB1",1,xfilial("SB1")+cProd,"B1_CONV")
_cTpCo := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPCONV")

if _nLoteM > 0 .and. _nConv > 0
	if _cTpCo == "D"
		_nLoteM := Round(_nLoteM / _nConv, 4)
	else
		_nLoteM := Round(_nLoteM * _nConv, 4)
	endif
	_nResto := MOD(_nQuant,_nLoteM)
	
	if _nLoteM == int( _nLoteM )
		if _nResto > 0
			Alert("Atencao, quantidade digitada n�o � m�ltipla da Embalagem!")
			_lRet := .f.
		endif
	else   //Para minimizar problemas com arredondamento
		if _nResto > 1   //se tiver casas decimais no lote, dar uma tolerancia.
			Alert("Atencao, quantidade digitada n�o � m�ltipla da Embalagem!")
			_lRet := .f.
		endif
	endif
	
endif

Return _lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GQTD2UM  � Autor � Eneo  - ADV Brasil � Data �  15/01/10   ���
����������������������2��������������������������������������������������͹��
���Descricao � Gatilho para atualizar a Quantidade da Seguda Unidade de   ���
���          � Medida, UB_XUNSVEN, C6_UNSVEN ou primeira unidade de medida���
���          � cTipo     = O or�amento P pedido							  ���
���          � lInverte  = .T. inverte o tipo de conversao, .F. para      ���
���          � converte da 1a.UM p/ 2a. e .T. da 2a.UM p/ 1a.             ���
���          � nQtdDig	 = Qtde a ser convertida M->ub_quant,             ���
���          � M->ub_xunsven, M->c6_qtdven e M->c6_unsven                 ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / televendas/orcamento e pedido de vendas���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GQTD2UM(cTipo,lInverte,nQtdDig)
Local _nRet := 0
Local cProd := ""
Local _nQuant := nQtdDig
Local nPProd := 0
Local _nConv := 0
Local _cTpCo := " "
Local nPUm  := 0
Local _cUm := ""
Local _cUm2Sb1 := ""

if cTipo == "O" //se eh um orcamento
	//   nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "CK_PRODUTO"})
	//   nPUm   := Ascan(aHeader,{|x| AllTrim(x[2]) == "CK_UM" })
elseif cTipo == "P" //se eh um pedido de vendas
	nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	nPUm   := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_UM" })
else // se eh uma OP
	cProd := M->C2_PRODUTO
	_cUm  := M->C2_UM
endif

if cTipo == "O"
	cProd   := TMP1->CK_PRODUTO
	_cUm    := TMP1->CK_UM
elseif nPProd > 0
	cProd   := aCols[N,nPProd]
	_cUm    := aCols[N,nPUm]
endif

_nConv  := Posicione("SB1",1,xfilial("SB1")+cProd,"B1_CONV")
_cUm2Sb1:= Posicione("SB1",1,xfilial("SB1")+cProd,"B1_SEGUM")
_cTpCo  := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPCONV")

if _cUm == _cUm2Sb1
	_nConv := 1
endif

if _nConv > 0
	if _cTpCo == "D"
		if .not. lInverte
			_nRet := Round(_nQuant / _nConv, 4)
		else
			_nRet := Round(_nQuant * _nConv, 4)
		endif
	else
		if .not. lInverte
			_nRet := Round(_nQuant * _nConv, 4)
		else
			_nRet := Round(_nQuant / _nConv, 4)
		endif
	endif
endif

Return _nRet


/*
Converter o pre�o pela segunda unidade
*/
User Function PrSegUn( cAlias, cUm, nPreco, cCpo )
Local _nRet := 0
Local nPProd
Local nPPreco
Local nPUm := 0
Local _cUm2Sb1 := ""
Local _nConv := 0
Local _cTpCo := " "

if cCpo == NIL
	cCpo := ""
endif
if nPreco == NIL
	nPreco := 0
endif

if cAlias == "SUB"
	nPProd   := Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
elseif cAlias == "SC6"
	nPProd   := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
endif

if .not. Empty( cCpo ) .and. nPreco == 0
	nPPreco := Ascan(aHeader,{|x| AllTrim(x[2]) == cCpo})
	if nPPreco > 0
		nPreco := aCols[N,nPPreco]
	endif
endif

_nRet := nPreco

if nPProd > 0
	cProd   := aCols[N,nPProd]
endif

_cUm2Sb1:= Posicione("SB1",1,xfilial("SB1")+cProd,"B1_SEGUM")
_nConv  := Posicione("SB1",1,xfilial("SB1")+cProd,"B1_CONV")
_cTpCo  := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPCONV")

if cUm == _cUm2Sb1 .and. _nConv > 0
	if _cTpCo == "D" //inverter o pre�o
		_nRet := Round(_nRet * _nConv, 6)
	else
		_nRet := Round(_nRet / _nConv, 6)
	endif
endif

return _nRet
