#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF1100I   บAutor  ณAlexandre Dalpiaz   บ Data ณ23/02/2011   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณponto de entrada na inclusใo/classifica็ใo de Documentos de บฑฑ
ฑฑบ          ณEntrada                                                     บฑฑ
ฑฑบ          ณGrava data informada no PE MT103NFE ou no PE MT103TOK       บฑฑ
ฑฑบ          ณGrava usuแrio e data da inclusใo ou classifica็ใo da NFE	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SF1100I()
///////////////////////
Local aAlias	:= GetArea()

RestArea(aAlias)

RecLock('SF1',.f.)
SF1->F1_USUACLA := upper(cUserName)
SF1->F1_DATACLA := date()
MsUnLock()

If SF1->F1_TIPO $ 'DB'
	
	_cQuery := "UPDATE " + RetSqlName('SE1')
	_cQuery += _cEnter + " SET E1_FILORIG = '" + cFilAnt + "', E1_CLASS = '" + SA1->A1_CLASS + "'"
	_cQuery += _cEnter + " WHERE E1_PREFIXO = '" + SF1->F1_PREFIXO + "'"
	_cQuery += _cEnter + " AND E1_NUM = '" + SF1->F1_DUPL + "'"
	_cQuery += _cEnter + " AND E1_CLIENTE = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND E1_LOJA = '" + SF1->F1_LOJA + "'"
	TcSqlExec(_cQuery)
	
	if  ca100for < '000010'
		_cQuery := "UPDATE " + RetSqlName('SB2')
		_cQuery += _cEnter + " SET B2_XTRANSI  = CASE WHEN B2_XTRANSI < 0 THEN 0 ELSE B2_XTRANSI END  - D1_QUANT"
		
		_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
		
		_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
		_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND F4_FILIAL = ''"
		_cQuery += _cEnter + " AND F4_CODIGO = D1_TES"
		_cQuery += _cEnter + " AND F4_ESTOQUE = 'S'"
		
		_cQuery += _cEnter + " WHERE SD1.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
		_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
		_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
		_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
		_cQuery += _cEnter + " AND D1_FORNECE <'000009'"
		_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
		_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ = ''"
		_cQuery += _cEnter + " AND B2_FILIAL = D1_FILIAL"
		_cQuery += _cEnter + " AND B2_COD = D1_COD"
		_cQuery += _cEnter + " AND B2_LOCAL = D1_LOCAL"
		TcSqlExec(_cQuery)
		
	endif
	
ElseIf ca100for < '000010'
	
	_cPedCom := Posicione('SC5',5,SF1->F1_LOJA+SF1->F1_DOC + SF1->F1_SERIE,'C5_COTACAO')
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณALTERADO SIDNEY - STCH PARA TRATAR O TRANSITO NA EMISSAO DA NOTA FISCAL DE ENTRADA 	ณ
	//ณajusta o transito (B2_SALPEDI) na filial de destino do romaneio                      ณ
	//ณ	                                                                                    ณ
	//ณAlterado pela Tatiane de Oliveira 04/02/2016                                         ณ
	//ณpara dar baixa no transito                                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	
	_cQuery := "UPDATE " + RetSqlName('SB2')
	_cQuery += _cEnter + " SET B2_XTRANSI  = CASE WHEN B2_XTRANSI < 0 THEN 0 ELSE B2_XTRANSI END  - D1_QUANT"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F4_FILIAL = ''"
	_cQuery += _cEnter + " AND F4_CODIGO = D1_TES"
	_cQuery += _cEnter + " AND F4_ESTOQUE = 'S'"
	
	_cQuery += _cEnter + " WHERE SD1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND D1_FORNECE <'000009'"
	_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
	_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND B2_FILIAL = D1_FILIAL"
	_cQuery += _cEnter + " AND B2_COD = D1_COD"
	_cQuery += _cEnter + " AND B2_LOCAL = D1_LOCAL"
	TcSqlExec(_cQuery)
	
	
	//----------------------------------------- FIM --------------------------------------------------//
	
	_cQuery := "UPDATE " + RetSqlName('PA6')
	_cQuery += _cEnter + " SET PA6_NFE = PA6_NFS, PA6_STATUS = '06'"
	_cQuery += _cEnter + " WHERE PA6_NFS = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND PA6_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND PA6_FILDES = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND PA6_FILORI = '" + SF1->F1_LOJA + "'"
	TcSqlExec(_cQuery)
	
EndIf

If GetMv('LS_ADIANTA') == 'S'
	_cQuery := "UPDATE Z13"
	_cQuery += _cEnter + " SET Z13_DOC = '" + SF1->F1_DOC + "', Z13_DTDOC = '" + dtos(SF1->F1_DTDIGIT) + "', Z13_VLRDOC = '" + str(SF1->F1_VALBRUT,9,2) + "' , Z13_SLDDOC = '" + str(SF1->F1_VALBRUT,9,2) + "'"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SF1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('Z13') + " Z13 (NOLOCK)"
	_cQuery += _cEnter + " ON Z13_PEDIDO = D1_PEDIDO"
	_cQuery += _cEnter + " AND Z13_FILORI = D1_FILIAL"
	_cQuery += _cEnter + " AND Z13->D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D1_FILIAL = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" 	 	+ SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" 	+ SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND D1_FORNECE = '" 	+ SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND D1_LOJA = '" 	+ SF1->F1_LOJA + "'"
	_cQuery += _cEnter + " AND SD1->D_E_L_E_T_ = ''"
	TcSqlExec(_cQuery)
EndIf

_cQuery := "UPDATE " + RetSqlName('SE2')
_cQuery += _cEnter + " SET E2_FILORIG = '" + cFilAnt + "', E2_CLASS = '" + SA2->A2_CLASS + "', E2_USUACAN = '" + SF1->F1_SERIE + "'"
_cQuery += _cEnter + " WHERE E2_PREFIXO = '" + SF1->F1_PREFIXO + "'"
_cQuery += _cEnter + " AND E2_NUM = '" + SF1->F1_DUPL + "'"
_cQuery += _cEnter + " AND E2_FORNECE = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND E2_LOJA = '" + SF1->F1_LOJA + "'"
TcSqlExec(_cQuery)

_cQuery := "UPDATE SE2"
_cQuery += _cEnter + " SET E2_CODBAR = Z14_CODBAR"
_cQuery += _cEnter + " FROM " + RetSqlName('SE2') + " SE2 (NOLOCK)"
_cQuery += _cEnter + " INNER JOIN " + RetSqlName('Z14') + " Z14 (NOLOCK)"
_cQuery += _cEnter + " ON Z14_FILIAL = E2_MSFIL"
_cQuery += _cEnter + " AND Z14_DOC = E2_NUM"
_cQuery += _cEnter + " AND Z14_FORNEC = E2_FORNECE"
_cQuery += _cEnter + " AND Z14_LOJA = E2_LOJA"
_cQuery += _cEnter + " AND Z14.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND Z14_PARCEL = E2_PARCELA"
_cQuery += _cEnter + " AND Z14_SERIE = '" + SF1->F1_SERIE + "'"
_cQuery += _cEnter + " WHERE E2_MSFIL = '" + SF1->F1_FILIAL + "'"
_cQuery += _cEnter + " AND E2_NUM = '" + SF1->F1_DOC + "'"
_cQuery += _cEnter + " AND E2_FORNECE = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND E2_LOJA = '" + SF1->F1_LOJA + "'"
_cQuery += _cEnter + " AND E2_PREFIXO = '" + SF1->F1_PREFIXO + "'"
_cQuery += _cEnter + " AND SE2.D_E_L_E_T_ = ''"
TcSqlExec(_cQuery)

_cQuery := "UPDATE " + RetSqlName('SC7')
_cQuery += _cEnter + " SET C7_NFISCAL = D1_DOC + D1_SERIE, C7_ITEMNF = D1_ITEM"
_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + " WHERE " + RetSqlName('SC7') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
_cQuery += _cEnter + " AND C7_FILENT = D1_FILIAL"
_cQuery += _cEnter + " AND C7_NUM = D1_PEDIDO"
_cQuery += _cEnter + " AND C7_ITEM = D1_ITEMPC"
_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
TcSqlExec(_cQuery)

Return()
