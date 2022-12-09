#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_PVTRAN
// Autor 		Alexandre Dalpiaz
// Data 		23/12/10
// Descricao  	Pedidos de vendas de transferencia
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_PVTRAN()
//////////////////////////

cPerg := 'LS_PVTRANS'

ValidPerg()

If !Pergunte(cPerg,.t.)
	Return()
EndIf

Processa({|| RunProc()},'Gerando Pedidos')

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

_cPedidos := ''
_lErros   := .f.
_aBloq    := {}	// produtos bloqueados
_cPrNLoc  := ''	// produtos não localizados

If mv_par03 == 2  // origem = pedidos de venda
	
	_cQuery := "SELECT *"
	_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
	_cQuery += _cEnter + " WHERE C6_FILIAL 		='" + mv_par05 + "'"
	_cQuery += _cEnter + " AND C6_NUM 			BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "'"
	_cQuery += _cEnter + " AND C6_LOJA 			= '" + xFilial('SC6') + "'"
	_cQuery += _cEnter + " AND C6_CLI 			< '000009'"
	_cQuery += _cEnter + " AND C6_NOTA 			<> ''"
	_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + " ORDER BY C6_NUM"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
	count to _nLastRec
	
	If _nLastRec == 0
		MsgBox('Pedidos de vendas não encontrados. Verifique os parâmetros.','ATENÇÃO!!!','ALERT')
		DbCloseArea()
		Return()
	EndIf
	
	DbGoTop()
	ProcRegua(_nLastRec)
	Do While !eof()
		
		// PREENCHE O CABEÇALHO DO PEDIDO DE VENDA
		_aCabPv	:= {}
		aAdd(_aCabPv, {"C5_FILIAL"		,	xFilial("SC5")				, Nil})
		If mv_par09 == 1
			aAdd(_aCabPv, {"C5_TIPO"	,   'N'							, Nil})
			aAdd(_aCabPv, {"C5_CLIENTE"	,	mv_par01       				, Nil})
			aAdd(_aCabPv, {"C5_LOJACLI"	,	mv_par02        			, Nil})
			_cCgc := Substr(Posicione('SA1',1,xFilial('SA1') + mv_par01 + mv_par02,'A1_CGC'),1,8)
		Else
			_cCgc := Substr(Posicione('SA2',1,xFilial('SA2') + mv_par01 + mv_par02,'A2_CGC'),1,8)
			aAdd(_aCabPv, {"C5_TIPO"	,   iif(mv_par09 == 2,'D','B')	, Nil})
			aAdd(_aCabPv, {"C5_CLIENTE"	,	mv_par12       				, Nil})
			aAdd(_aCabPv, {"C5_LOJACLI"	,	mv_par13        			, Nil})
		EndIf
		If mv_par02 == '01' .and. cFilAnt == 'C0'
			aAdd(_aCabPv, {"C5_TES"		,	mv_par10       		   		, Nil})
			aAdd(_aCabPv, {"C5_TABELA"	,	'001'        		   		, Nil})
		EndIf
		If !empty(mv_par10)
			aAdd(_aCabPv, {"C5_TES"		,	mv_par10	       			, Nil})
		EndIf
		
		// PREENCHE OS PRODUTOS
		_aItemPv := {}
				
		_cChave := TRB->C6_NUM
		Do While !Eof() .And. _cChave == TRB->C6_NUM
			IncProc()
			_aItem := {}
			aAdd(_aItem, {"C6_ITEM"			,	TRB->C6_ITEM		, Nil})
			aAdd(_aItem, {"C6_PRODUTO"		,	TRB->C6_PRODUTO		, Nil})
			aAdd(_aItem, {"C6_QTDVEN"		,	TRB->C6_QTDVEN		, Nil})
			If mv_par02 == '01' .and. cFilAnt == 'C0'
				_nPrcVen := Posicione('DA1',1,xFilial('DA1') + '001' + TRB->C6_PRODUTO,'DA1_PRCVEN')
				aAdd(_aItem, {"C6_PRUNIT"	,	_nPrcVen 			, Nil})
				aAdd(_aItem, {"C6_PRCVEN"	,	_nPrcVen			, Nil})
			Else
				aAdd(_aItem, {"C6_PRUNIT"	,	TRB->C6_PRUNIT		, Nil})
				aAdd(_aItem, {"C6_PRCVEN"	,	TRB->C6_PRCVEN		, Nil})
			EndIf
			_cTes := Posicione('SBZ',1,mv_par02 + TRB->C6_PRODUTO,'BZ_TS')
			If !empty(mv_par10)
				_cTes := mv_par10
			ElseIf empty(_cTes)
				_cTes := _cTesAnt
			EndIf
			_cTesAnt := _cTes
			
			aAdd(_aItem, {"C6_TES"			,	_cTes				, Nil})
			aAdd(_aItem, {'C6_LOCAL' 		, 	mv_par08       		, NIL})
			
			aAdd(_aItemPv,aClone(_aItem))
			
			DbSelectArea('TRB')
			DbSkip()
			
		EndDo
		
		// EXECUTA A ROTINA PARA GRAVAR O PEDIDO DE VENDA
		lMsErroAuto := .f.
		MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
		Pergunte(cPerg,.f.)

		DbSelectArea('SB1')
		DbSetOrder(1)
		For _nI := 1 to len(_aBloq)
			If DbSeek(xFilial('SB1') + _aBloq[_nI] ,.f.)
				RecLock('SB1',.f.)
				SB1->B1_MSBLQL := '1'
				MsUnLock()
			EndIf
		Next
		_aBloq := {}

		If lMsErroAuto
			_lErros := .t.
			MostraErro()
			exit
		Else
			_cPedidos += SC5->C5_NUM + _cEnter
			
		EndIf
		
		DbSelectArea('TRB')
		DbSkip()
		
	EndDo
	
	DbCloseArea()
	
ElseIf mv_par03 == 3  // Arquivo TXT
	
	_cTexto := 'Para uma correta importação do arquivo, é necessário que esteja no seguinte lay-out:' 							+ _cEnter
	_cTexto += 'Nro da carga - este campo é um nro qualquer. Itens em cargas diferentes serão lançados em pedidos diferentes.' 	+ _cEnter
	_cTexto += 'Produto' 																										+ _cEnter
	_cTexto += 'Quantidade' 																									+ _cEnter
	_cTexto += 'TES' 																											+ _cEnter + _cEnter
	_cTexto += 'Os campos devem ser separados por ponto e vírgula (;)' 															+ _cEnter + _cEnter
	_cTexto += 'Os pedidos de venda serão todos gerados para o cliente/fornecedor informado nos parâmetros'
	
	If !MsgBox(_cTexto,'Confirma geração do(s) pedido(s) de venda????','YESNO')
		Return()
	EndIf
	
	cArqTxt := mv_par14
	FT_FUSE(mv_par14)
	ProcRegua(FT_FLastRec())
	FT_FGotop()                      
	l410Auto := .t.
	altera   := .f.
	inclui   := .t.     
	_aItens  := {}
	
	_nLin := 0        
	Begin Transaction 
	Do While ( !FT_FEof() )
		
		// GRAVA O CABEÇALHO DO PEDIDO DE VENDA
		_aCabPv	:= {}
		aAdd(_aCabPv, {"C5_FILIAL"		,	xFilial("SC5")				, Nil})
		If mv_par09 == 1 // TIPO DE PEDIDO (1 = NORMAL)
			M->C5_CLIENTE := mv_par01
			M->C5_LOJACLI := mv_par02
			aAdd(_aCabPv, {"C5_TIPO"	,   'N'							, Nil})
			aAdd(_aCabPv, {"C5_CLIENTE"	,	mv_par01       				, Nil})
			aAdd(_aCabPv, {"C5_LOJACLI"	,	mv_par02        			, Nil})
			_cCgc := Substr(Posicione('SA1',1,xFilial('SA1') + mv_par01 + mv_par02,'A1_CGC'),1,8)
		Else
			_cCgc := Substr(Posicione('SA2',1,xFilial('SA2') + mv_par01 + mv_par02,'A2_CGC'),1,8)
			aAdd(_aCabPv, {"C5_TIPO"	,   iif(mv_par09 == 2,'D','B')	, Nil})
			aAdd(_aCabPv, {"C5_CLIENTE"	,	mv_par12       				, Nil})
			aAdd(_aCabPv, {"C5_LOJACLI"	,	mv_par13        			, Nil})
			M->C5_CLIENTE := mv_par12
			M->C5_LOJACLI := mv_par13
		EndIf
		
		If !empty(mv_par10)
			aAdd(_aCabPv, {"C5_TES"		,	mv_par10	       			, Nil})
		EndIf
		
		_cLinha 	:= alltrim(FT_FREADLN())
		
		Do While at(';;',_cLinha) > 0 .or. at('; ;',_cLinha) > 0 .or. at(';	;',_cLinha) > 0
			FT_FSkip()
			IncProc(str(++_nLin))
			_cLinha := alltrim(FT_FREADLN())
		EndDo
		
		_nPosic 	:= at(';',_cLinha)
		_cCarga 	:= left(_cLinha,_nPosic-1)
		aAdd(_aCabPv, {"C5_MENNOTA"	,	'Carga nro: ' + _cCarga			, Nil})
		// TERMINA DE PREENCHER O CABEÇALHO
		
		// INICIA O PREENCHIMENTO DOS PRODUTOS DO PEDIDO DE VENDA	
		_aItemPv 	:= {}
		_cItem  	:= '0000' 
		
		Do While  ( !FT_FEof() )  .and. len(_aItemPv) < mv_par11
			
			IncProc(str(++_nLin))
			
			Do While at(';;',_cLinha) > 0 .or. at('; ;',_cLinha) > 0 .or. at(';	;',_cLinha) > 0
				IncProc(str(++_nLin))
				FT_FSkip()
				_cLinha := alltrim(FT_FREADLN())
			EndDo
			
			_aItem		:= {}
			_nPosic 	:= at(';',_cLinha)
			
			_cLinha 	:= substr(_cLinha,_nPosic+1); _nPosic := at(';',_cLinha)
			_cProduto 	:= left(_cLinha,_nPosic-1)

			DbSelectArea('SB1')
			DbSetOrder(1)
			If !DbSeek(xFilial('SB1') + _cProduto,.f.)
				DbSetOrder(5)
				If !DbSeek(xFilial('SB1') + _cProduto,.f.)
					_cPrNLoc += _cProduto + _cEnter
					_cProduto := ''
				Else
					_cProduto := SB1->B1_COD
				EndIf
			EndIf

			If Empty(_cProduto)
				FT_FSkip()
				_cLinha := alltrim(FT_FREADLN())
				loop
			EndIf

			_cItem := Soma1(_cItem)
			aAdd(_aItem, {"C6_ITEM"		, _cItem 												, Nil})
			aAdd(_aItem, {"C6_PRODUTO"	, _cProduto												, Nil})
			
			If _cCgc $ GetMv("MV_LSVCNPJ")
				_nPrcVen 	:= Posicione('SB1',1,xFilial('SB1') + left(_cLinha,_nPosic-1),'B1_UPRC')
			Else
				//_nPrcUni 	:= Posicione('SB1',1,xFilial('SB1') + left(_cLinha,_nPosic-1),'B1_PRV1')
				_nUPRC		:= Posicione('SB1',1,xFilial('SB1') + left(_cLinha,_nPosic-1),'B1_UPRC')
				_nPRCCOM	:= Posicione('SB1',1,xFilial('SB1') + left(_cLinha,_nPosic-1),'B1_PRCCOM')
				_nPrcUni 	:= IIF(_nPRCCOM==0,_nUPRC,_nPRCCOM)
				_nPDec   	:= GETMV("LS_INDTRNF") //If(SB1->B1_GRUPO == "0010",15,20)
				//_nPrcVen	:= noround(_nPrcUni - (SB1->B1_PRV1 * _nPDec) / 100,2)
				_nPrcVen	:= noround(_nPrcUni + (IIF(_nPRCCOM==0,_nUPRC,_nPRCCOM) * _nPDec) / 100,2)
			EndIf
			
			_cLinha 		:= substr(_cLinha,_nPosic+1); _nPosic := at(';',_cLinha)
			
			aAdd(_aItem, {"C6_QTDVEN"	,	val(left(_cLinha,_nPosic-1))						, Nil})
			
            _nQt 			:= val(left(_cLinha,_nPosic-1))
			_nPrcVen 		:= iif(_nPrcVen <= 0, 1, _nPrcVen)
			
			aAdd(_aItem, {'C6_PRUNIT'	, round(_nPrcVen,2)										, NIL})
			aAdd(_aItem, {'C6_PRCVEN'	, round(_nPrcVen,2)			  							, NIL})
			aAdd(_aItem, {'C6_VALOR' 	, val(left(_cLinha,_nPosic-1)) * round(_nPrcVen,2)		, NIL})
			aAdd(_aItem, {'C6_LOCAL' 	, mv_par08												, NIL})
			
			_cLinha 		:= substr(_cLinha,_nPosic+1)
			
			aAdd(_aItem, {"C6_TES"		,	_cLinha												, Nil})
			
			M->C5_TIPO := iif(mv_par09 == 1,'N',iif(mv_par09 == 2,'D','B'))
			M->C5_TES  := _cLinha
			
			If U_LS_C6QTD(100,_cProduto, _cLinha, _cItem, _nQt, 0, mv_par08)    
				aAdd(_aItemPv,aClone(_aItem))
	
				If SB1->B1_MSBLQL == '1'
					aAdd(_aBloq,SB1->B1_COD)
					RecLock('SB1',.f.)
					SB1->B1_MSBLQL := '2'
					MsUnLock()
				EndIf
			Else
				aAdd(_aItens,_cProduto)
			EndIf
				                                                           
			FT_FSkip()
			
			_cLinha		:= alltrim(FT_FREADLN())
			_nPosic		:= at(';',_cLinha)
			
			If _cCarga <> left(_cLinha,_nPosic-1)
				Exit
			EndIF
		EndDo 
		
		// EXECUTA A ROTINA PARA GRAVAR O PEDIDO DE VENDA
		If !empty(_aItemPv)
			lMsErroAuto := .f.
			MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
			Pergunte(cPerg,.f.)

			DbSelectArea('SB1')
			DbSetOrder(1)
			For _nI := 1 to len(_aBloq)
				If DbSeek(xFilial('SB1') + _aBloq[_nI] ,.f.)
					RecLock('SB1',.f.)
					SB1->B1_MSBLQL := '1'
					MsUnLock()
				EndIf
			Next

			_aBloq := {}

			If lMsErroAuto
				_lErros := .t.
				MostraErro()
				DisarmTransaction()  
				_cPedidos := ''
				exit
			Else
				_cPedidos += SC5->C5_NUM + _cEnter
			EndIf
		EndIf
	EndDo         
	End Transaction
	FT_FUse()
	
ElseIf mv_par03 == 4  // Pedido de compras do cliente
	
	cEstado := Posicione("SA1",1,xFilial("SA1")+mv_par01+mv_par02,"A1_EST")

	DbSelectArea('SC7')
	If mv_par01 > '000009'
		MsgBox('Utilizar somente para clientes intercompany'			,'ATENÇÃO!!!!'	,'ALERT')
		Return()
	EndIf
	
	If mv_par09 <> 1
		MsgBox('Utilizar somente para pedidos do tipo normal'			,'ATENÇÃO!!!!'	,'ALERT')
		Return()
	EndIf
	
	SC7->(DbSeek(mv_par02 + mv_par16,.f.))
	If !found()
		MsgBox('Pedido de compras não localizado na filial indicada'	,'ATENÇÃO!!!!'	,'ALERT')
		Return()
	EndIf
	If SC7->C7_ENCER == 'E'
		MsgBox('Pedido de compras já encerrado'							,'ATENÇÃO!!!!'	,'ALERT')
		Return()
	EndIf
	
	If !EMPTY(ALLTRIM(SC7->C7_NFISCAL)) //SC7->C7_QTDACLA != 0 //<> SC7->C7_QUANT
		MsgBox('Pedido de compras já utilizado'							,'ATENÇÃO!!!!'	,'ALERT')
		Return()
	EndIf
	
	// PREENCHE O CABEÇALHO DO PEDIDO DE VENDA
	_aCabPv	:= {}
	aAdd(_aCabPv, {"C5_FILIAL"		,	xFilial("SC5")	   			, Nil})
	aAdd(_aCabPv, {"C5_TIPO"		,   'N'							, Nil})
	aAdd(_aCabPv, {"C5_CLIENTE"		,	mv_par01       				, Nil})
	aAdd(_aCabPv, {"C5_LOJACLI"		,	mv_par02        			, Nil})
	aAdd(_aCabPv, {"C5_COTACAO"		,	mv_par16	       			, Nil})
	If !empty(mv_par10)
		aAdd(_aCabPv, {"C5_TES"		,	mv_par10	       			, Nil})
	EndIf
	_cCgc := Substr(Posicione('SA1',1,xFilial('SA1') + mv_par01 + mv_par02,'A1_CGC'),1,8)
	nOpcao		:= Aviso("Preços","Deseja utilizar o preço do PEDIDO DE COMPRA ou da TABELA DE PRECO como referencia ? ",{"Pedido","Tabela"},2)
	
	// SE APERTOU "ESC" UTILIZA A OPÇÃO PADRÃO DE PEDIDO DE COMPRA
	IIF(nOPCAO==0,1,nOPCAO)
	
	IF nOpcao == 1
		aAdd(_aCabPv, {"C5_DESC1"	,	0	       					, Nil})
	ENDIF
	
	// PREENCHE OS PRODUTOS DO PEDIDO DE VENDA
	_aItemPv 	:= {}
	_cItem 		:= "0001" 
	Do While !eof() .and. mv_par02 + mv_par16 == SC7->C7_FILIAL + SC7->C7_NUM
		
		_aItem	:= {}
		//_cItem 	:= strzero(val(SC7->C7_ITEM),2)
		//_cItem	:= soma1(_cItem)
		aAdd(_aItem, {"C6_ITEM"		, _cItem						, Nil})
		aAdd(_aItem, {"C6_PRODUTO"	,	SC7->C7_PRODUTO				, Nil})
		
		cTes	:= iif(!empty(mv_par10), mv_par10, Posicione("SBZ",1,SA1->A1_LOJA + SC7->C7_PRODUTO,"BZ_TS"))
		cCf		:= Posicione("SF4",1,xFilial("SF4") + cTes,"F4_CF")
	
		If SM0->M0_ESTENT <> cEstado
			cCf := "6"+Substr(cCf,2,3)
			If !empty(SF4->F4_CF_FORA)
				cCf := SF4->F4_CF_FORA
			EndIf
		EndIf
	
		nValUnit	:= SC7->C7_PRECO-(SC7->C7_VLDESC/SC7->C7_QUANT)
		nValTot 	:= nValUnit * SC7->C7_QUANT
		
		aAdd(_aItem, {"C6_QTDVEN"	, SC7->C7_QUANT				, Nil})
		aAdd(_aItem, {"C6_TES"		, cTes 						, Nil})
		aAdd(_aItem, {"C6_CF"		, cCf 						, Nil})
		IF nOpcao == 1
			/*
			aAdd(_aItem, {"C6_PRCVEN"		, nValUnit			, Nil}) // VALOR UNITARIO
			aAdd(_aItem, {"C6_PRUNIT"		, SC7->C7_PRECO 	, Nil}) // PRECO LISTA/TABELA
			aAdd(_aItem, {"C6_DESCONT"		, SC7->C7_DESC	 	, Nil}) // % DESCONTO
			aAdd(_aItem, {"C6_VALDESC"		, SC7->C7_VLDESC 	, Nil}) // VALOR DESCONTO
			aAdd(_aItem, {"C6_VALOR"		, nValTot		 	, Nil}) // VALOR TOTAL = (UNITARIO-DESCONTO)*QUANTIDADE
			*/
			aAdd(_aItem, {"C6_PRCVEN"		, nValUnit			, Nil}) // VALOR UNITARIO
			aAdd(_aItem, {"C6_PRUNIT"		, nValUnit 		 	, Nil}) // PRECO LISTA/TABELA
			aAdd(_aItem, {"C6_DESCONT"		, 0	 				, Nil}) // % DESCONTO
			aAdd(_aItem, {"C6_VALDESC"		, 0				 	, Nil}) // VALOR DESCONTO
			//aAdd(_aItem, {"C6_VALOR"		, nValTot		 	, Nil}) // VALOR TOTAL = (UNITARIO-DESCONTO)*QUANTIDADE
		ENDIF
		_cItem 	:= Soma1(_cItem)
		
		aAdd(_aItemPv,aClone(_aItem))
		
		IF LEN(_aItemPv) >= MV_PAR11 //	val(_cItem) >= MV_PAR11
	
	// EXECUTA A ROTINA PARA GRAVAR O PEDIDO DE VENDA
	lMsErroAuto := .f.
	MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3,.t.)
	Pergunte(cPerg,.f.)
	If lMsErroAuto
		_lErros := .t.
		MostraErro()
	Else
		_cPedidos += SC5->C5_NUM + _cEnter
	EndIf
	
			// ZERO AS VARIAVEIS
			_aItemPv	:= {}
			_cItem		:= "0001" 
			
		ENDIF

		DbSelectArea('SC7')
		DbSkip()
		
	EndDo
	
	IF len(_aItemPv) > 0
		// EXECUTA A ROTINA PARA GRAVAR O PEDIDO DE VENDA
		lMsErroAuto := .f.
		MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3,.t.)
		Pergunte(cPerg,.f.)
		If lMsErroAuto
			_lErros := .t.
			MostraErro()
		Else
			_cPedidos += SC5->C5_NUM + _cEnter
		EndIf
	ENDIF
	
Else		// origem = estoque
	
	_cQuery := "SELECT B2_COD, B1_DESC, B1_GRUPO, B2_QATU " + iif(mv_par15 == 1,"- B2_RESERVA B2_QATU","") +", B2_LOCAL, B1_UPRC, B1_PRV1, B1_MSBLQL"
	_cQuery += _cEnter + "FROM " + RetSqlName('SB2') + " SB2 (NOLOCK)"
	
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
	_cQuery += _cEnter + "ON SB1.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "AND B1_COD 			= B2_COD"
	If !empty(mv_par04)
		_cQuery += _cEnter + "AND B1_GRUPO 		= '" + mv_par04 + "'"
	EndIf
	
	_cQuery += _cEnter + "WHERE SB2.D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "AND B2_QATU 			> 0"
	_cQuery += _cEnter + "AND B2_LOCAL 			= '" + mv_par08 + "'"
	_cQuery += _cEnter + "AND B2_FILIAL 		= '" + xFilial('SB2') + "'"
	_cQuery += _cEnter + "ORDER BY B1_GRUPO, B1_COD"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
	
	If eof()
		MsgAlert('Nenhum item com saldo em estoque','ATENÇÃO!!!')
		DbCloseArea()
		Return()
	EndIf
	
	Count to _nLastRec
	DbGoTop()
	ProcRegua(_nLastRec)
	Do While !eof()
		
		// PREENCHE O CABEÇALHO DO PEDIDO DE VENDA
		_aCabPv	:= {}
		aAdd(_aCabPv, {"C5_FILIAL"		,	xFilial("SC5")					, Nil})
		If mv_par09 == 1
			aAdd(_aCabPv, {"C5_TIPO"	,   'N'								, Nil})
			aAdd(_aCabPv, {"C5_CLIENTE"	,	mv_par01	       				, Nil})
			aAdd(_aCabPv, {"C5_LOJACLI"	,	mv_par02        				, Nil})
			_cCgc := Substr(Posicione('SA1',1,xFilial('SA1') + mv_par01 + mv_par02,'A1_CGC'),1,8)
		Else
			_cCgc := Substr(Posicione('SA2',1,xFilial('SA2') + mv_par01 + mv_par02,'A2_CGC'),1,8)
			aAdd(_aCabPv, {"C5_TIPO"	,   iif(mv_par09 == 2,'D','B')		, Nil})
			aAdd(_aCabPv, {"C5_CLIENTE"	,	mv_par12       					, Nil})
			aAdd(_aCabPv, {"C5_LOJACLI"	,	mv_par13        				, Nil})
		EndIf
		If !empty(mv_par10)
			aAdd(_aCabPv, {"C5_TES"		,	mv_par10	       				, Nil})
		EndIf
		
		// PREENCHE OS PRODUTOS DO PEDIDO DE VENDA
		_aItemPv 	:= {}
		_cItem  	:= '0000' 
		_cGrupo 	:= TRB->B1_GRUPO
		_aItemPV  	:= {}
		_aBloq    	:= {}  // itens bloqueados
		_cTesAnt  	:= ''  // tes anterior para compatibilidade

		Do While !Eof() .and. _cGrupo == TRB->B1_GRUPO .and. len(_aItemPv) < mv_par11
			
			IncProc()
			/*
			// LIMITAVA A QUANTIDADE DE PRODUTOS EM ATÉ 300 ITENS
			If len(_aitempv) == 299
				a := 0
			EndIf
			*/
			
			_cItem 			:= Soma1(_cItem)
			_cTes 			:= Posicione('SBZ',1,mv_par02 + TRB->B2_COD,'BZ_TS')
			_aItem  		:= {}
			
			If empty(_cTes)
				_cTes 		:= _cTesAnt
			EndIf
			_cTesAnt 		:= _cTes
			
			If _cCgc $ GetMv("MV_LSVCNPJ")
				_nPrcVen 	:= TRB->B1_UPRC
			Else
			/*
				_nPrcUni 	:= TRB->B1_PRV1
				_nPDec   	:= If(TRB->B1_GRUPO == "0010",15,20)
				_nPrcVen 	:= noround(_nPrcUni - (TRB->B1_PRV1 * _nPDec) / 100,2)
				*/
				_nPrcUni 	:= IIF(TRB->B1_PRCCOM==0,TRB->B1_UPRC,TRB->B1_PRCCOM)
				_nPDec   	:= GETMV("LS_INDTRNF") //If(SB1->B1_GRUPO == "0010",15,20)
				_nPrcVen	:= noround(_nPrcUni + (_nPrcUni * _nPDec) / 100,2)

			EndIf
			
			_nPrcVen 		:= iif(_nPrcVen <= 0, 1, _nPrcVen)
			
			aAdd(_aItem, {"C6_ITEM"		, _cItem          						, Nil})
			aAdd(_aItem, {"C6_PRODUTO"	, TRB->B2_COD							, Nil})
			aAdd(_aItem, {'C6_PRUNIT'	, round(_nPrcVen,2)						, NIL})
			aAdd(_aItem, {"C6_QTDVEN"	, TRB->B2_QATU   						, Nil})
			aAdd(_aItem, {'C6_PRCVEN'	, round(_nPrcVen,2)						, NIL})
			aAdd(_aItem, {'C6_VALOR' 	, TRB->B2_QATU * round(_nPrcVen,2)		, NIL})
			aAdd(_aItem, {'C6_TES'		, iif(empty(mv_par10),_cTes,mv_par10)	, NIL})
			aAdd(_aItem, {'C6_LOCAL' 	, mv_par08                        		, NIL})
			
			aAdd(_aItemPv,aClone(_aItem))
			
			If TRB->B1_MSBLQL == '1'
				aAdd(_aBloq,TRB->B2_COD)
				If SB1->(DbSeek(xFilial('SB1') + TRB->B2_COD,.F.))
					RecLock('SB1',.f.)
					SB1->B1_MSBLQL := '2'
					MsUnLock()
				EndIf
				DbSelectArea('TRB')
			EndIf
			DbSkip()
			
		EndDo
		
		// EXECUTA A ROTINA PARA GRAVAR O PEDIDO DE VENDA
		lMsErroAuto := .f.
		MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
		Pergunte(cPerg,.f.)
		/*
		// VERIFICA O CADASTRO DO PRODUTO E BLOQUEIA O REGISTRO
		For _nI := 1 to len(_aBloq)
			If SB1->(DbSeek(xFilial('SB1') + _aBloq[_nI],.F.))
				RecLock('SB1',.f.)
				SB1->B1_MSBLQL := '1'
				MsUnLock()
			EndIf
		Next
		*/
		
		// VERIFICA O CADASTRO DO PRODUTO E BLOQUEIA O REGISTRO 
		DbSelectArea('SB1')
		DbSetOrder(1)
		For _nI := 1 to len(_aBloq)
			If DbSeek(xFilial('SB1') + _aBloq[_nI] ,.F.)
				RecLock('SB1',.f.)
				SB1->B1_MSBLQL := '1'
				MsUnLock()
			EndIf
		Next
		
		_aBloq := {}

		If lMsErroAuto
			_lErros := .t.
			MostraErro()
			exit
		EndIf
		
		_cPedidos += SC5->C5_NUM + _cEnter
		
		DbSelectArea('TRB')
		DbSkip()
		
	EndDo
	
	DbCloseArea()
	
EndIf

If !_lErros .and. !empty(mv_par10)
	_cCf    := Posicione('SF4',1, xFIlial('SF4') + mv_par10,'F4_CF')
	If iif(mv_par09 == 1,SA1->A1_EST,SA2->A2_EST) <> SM0->M0_ESTENT
		_cCf := iif(!empty(SF4->F4_CF_FORA),SF4->F4_CF_FORA,'6' + substr(_cCf,2))
	EndIf
	_cQuery := "UPDATE " + RetSqlName('SC6')
	_cQuery += _cEnter + "SET C6_TES 		= '" + mv_par10 + "', C6_CF = '" + _cCf + "'"
	_cQuery += _cEnter + "WHERE D_E_L_E_T_ 	= ''"
	_cQuery += _cEnter + "AND C6_NUM 		IN " + FormatIn(_cPedidos,_cEnter)
	_cQuery += _cEnter + "AND C6_FILIAL 	= '" + xFilial('SC5') + "'"
	
	_nErro := TcSqlExec(_cQuery)
	
EndIf

If !empty(_cPrNLoc)
	_cTexto := 'Códigos do arquivo não localizados no cadastro de produtos:' + _cEnter + _cEnter + _cPrNLoc
	MsgBox(_cTexto,'ATENÇÃO!!!','ALERT')
EndIf

If _lErros
	MsgInfo('Ocorreu algum erro na geração dos pedidos de venda. Corrija e tente novamente.')
ElseIf !empty(_cPedidos)
	MsgInfo(_cPedidos,'Pedidos gerados com sucesso')
Else
	MsgAlert('Nenhum pedido foi gerado, verifique os parâmetros','Pedidos de Transferência')
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Destino (cliente)             ?","","", "mv_ch1", "C",  6 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1", "", "",""})
aAdd( aPerg , { cPerg, "02", "Loja Destino (cliente)        ?","","", "mv_ch2", "C",  2 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
//aAdd( aPerg , { cPerg, "03", "Origem dos itens PV           ?","","", "mv_ch3", "N",  1 , 0, 0, "C", "", "mv_par03", "Estoque", "", "", "", "", "Pedido Venda", "", "", "", "", "Arquivo Texto", "", "", "", "", "Pedido Compras", "", "", "", "", "Documento Entrada", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "03", "Origem dos itens PV           ?","","", "mv_ch3", "N",  1 , 0, 0, "C", "", "mv_par03", "Estoque", "", "", "", "", "Pedido Venda", "", "", "", "", "Arquivo Texto", "", "", "", "", "Pedido Compras", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Grupo de Produtos             ?","","", "mv_ch4", "C",  4 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", "",""})
aAdd( aPerg , { cPerg, "05", "Loja Origem do Pedido de Venda?","","", "mv_ch5", "C",  2 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "06", "Pedido de Vendas Origem de    ?","","", "mv_ch6", "C",  6 , 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "07", "Pedido de Vendas Origem ate   ?","","", "mv_ch7", "C",  6 , 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "08", "Armazém de Origem             ?","","", "mv_ch8", "C",  2 , 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "09", "Tipo do Pedido                ?","","", "mv_ch9", "N",  1 , 0, 0, "C", "", "mv_par09", "Normal", "", "", "", "", "Devolução", "", "", "", "", "Utiliza Forn (benef)", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "10", "Tipo Saída Padrão (TES)       ?","","", "mv_cha", "C",  3 , 0, 0, "G", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF4", "", "",""})
aAdd( aPerg , { cPerg, "11", "Quant máxima de itens (<=300) ?","","", "mv_chb", "N",  3 , 0, 0, "G", "(mv_par11 < 301)", "mv_par11", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "12", "Destino (fornecedor)          ?","","", "mv_chc", "C",  6 , 0, 0, "G", "", "mv_par12", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2", "", "",""})
aAdd( aPerg , { cPerg, "13", "Loja Destino (fornecedor)     ?","","", "mv_chd", "C",  2 , 0, 0, "G", "", "mv_par13", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "14", "Caminho do arquivo Texto      ?","","", "mv_che", "C",  50, 0, 0, "G", "", "mv_par14", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "15", "Considerar RESERVAS p/ saldo  ?","","", "mv_chf", "N",  1 , 0, 0, "C", "", "mv_par15", "Sim", "", "", "", "", "Não", "", "", "", "o", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "16", "Pedido de Compra              ?","","", "mv_chg", "C",  6 , 0, 0, "G", "", "mv_par16", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
//aAdd( aPerg , { cPerg, "17", "Nro documento de entrada      ?","","", "mv_chh", "C",  9 , 0, 0, "G", "", "mv_par17", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})


DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next

RestArea(_aAlias)

Return


User Function ls_teste()

_nValor := SE5->E5_VALOR

Return(_nValor)
