#Include "Protheus.ch"
#Include "rwmake.ch"

// Programa.: mt103can
// Autor....: Alexandre Dalpiaz
// Data.....: 11/07/2011
// Descrição: no cancelamento de notas fiscais de entrada - apaga tabela temporária
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function mt103can()
////////////////////////
                              
If l103Class .and. SF1->F1_FILIAL == cFilAnt .and. SF1->F1_DOC == cNFiscal .and. SF1->F1_SERIE == cSerie .and. SF1->F1_FORNECE == cA100For .and. SF1->F1_LOJA == cLoja .and. empty(SF1->F1_STATUS)
	_cQuery := "UPDATE " + RetSqlName('SD1')
	_cQuery += _cEnter + "SET D1_TES = '', D1_CF = ''" 
	_cQuery += _cEnter + "WHERE D1_FILIAL = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + "AND D1_DOC = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + "AND D1_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + "AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + "AND D1_LOJA = '" + SF1->F1_LOJA + "'"
	_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)     
	
	_cPedCom := Posicione('SC5',5,SF1->F1_LOJA+SF1->F1_DOC + SF1->F1_SERIE,'C5_COTACAO')
	


	EndIf

 If  ca100for < '000009'
			_cQuery := "UPDATE " + RetSqlName('SB2') 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
//		_cQuery += _cEnter + " SET B2_SALPEDI = B2_SALPEDI - D1_QUANT"
		_cQuery += _cEnter + " SET B2_XTRANSI = CASE WHEN B2_XTRANSI < 0 THEN 0 ELSE B2_XTRANSI END  - D1_QUANT"
		
		_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
		
		_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK)"
		_cQuery += _cEnter + " ON SD2.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND D2_FILIAL = D1_LOJA"
		_cQuery += _cEnter + " AND D2_CLIENTE = '" + SF1->F1_FORNECE + "'"
		_cQuery += _cEnter + " AND D2_DOC = D1_DOC"
		_cQuery += _cEnter + " AND D2_SERIE   = D1_SERIE"
		_cQuery += _cEnter + " AND D2_COD = D1_COD"
		_cQuery += _cEnter + " AND CONVERT(INT,D2_ITEM) = CONVERT(INT,D1_ITEM)"
		
		_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
		_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND F4_FILIAL = ''"
		_cQuery += _cEnter + " AND F4_CODIGO = D2_TES"
		_cQuery += _cEnter + " AND F4_ESTOQUE = 'S'"
	
		_cQuery += _cEnter + " WHERE SD1.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
		_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
		_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
		_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
		_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
		_cQuery += _cEnter + " AND D1_TES <> ''"
		_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND B2_FILIAL = D1_FILIAL"
		_cQuery += _cEnter + " AND B2_COD = D1_COD"
		_cQuery += _cEnter + " AND B2_LOCAL = D1_LOCAL"
		TcSqlExec(_cQuery)       	
EndIf

Return(.t.)