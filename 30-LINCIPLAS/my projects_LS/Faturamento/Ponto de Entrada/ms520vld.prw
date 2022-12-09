#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MS520VLD
// Autor 		Alexandre Dalpiaz
// Data 		02/03/11
// Descricao  	Ponto de entrada na validação da exclusão da nota fiscal de saida. Verifica se já foi dado entrada na nota fiscal de entrada em filiais ou coligadas
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MS520VLD()
////////////////////////

Local _lRet := .T.
Local _aAlias := GetArea()
                                
If empty(SF2->F2_DAUTNFE)
	RecLock('SF2',.f.)
	SF2->F2_DAUTNFE := DATE()
	SF2->F2_HAUTNFE := TIME()
	MsUnLock()
EndIf

If SF2->F2_TIPO == 'B'
	// tratamento para exclusão de notas fiscais de devolução simbólica e devolução física em acerto de consignação.

	_cQuery := "SELECT DISTINCT C7_NUM, C7_CONTRA D1_DOC"
	_cQuery += _cEnter + "FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"	
	_cQuery += _cEnter + "WHERE C7_FILIAL = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + "AND C7_FORNECE = '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + "AND C7_LOJA = '" + SF2->F2_LOJA + "'"
	_cQuery += _cEnter + "AND SC7.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND C7_OBS = 'DEV SIMB " + SF2->F2_DOC + SF2->F2_SERIE + "'"
 	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SC7', .F., .T.)
	_cPedido := _SC7->C7_NUM
	_cNota   := alltrim(_SC7->D1_DOC)
	DbCloseArea()
	
	If !empty(_cNota)	// já existe o pedido de compras e a nota fiscal já foi faturada 
		MsgBox ("Pedido de compras já faturado! Excluir manualmente a nota fiscal nro " + left(_cNota,9) + " série " + right(_cNota,3),"ATENÇÃO!!!","ALERT!!!")
		RestArea(_aAlias)
		Return(.f.)            
		                                               
	ElseIf !empty(_cPedido)	// se não estiver faturado, a o pC será excluido 
		_cQuery := "UPDATE " + RetSqlName('SC7')
		_cQuery += _cEnter + "SET D_E_L_E_T_ = '*',R_E_C_D_E_L_ = R_E_C_N_O_"
		_cQuery += _cEnter + "WHERE C7_FILIAL = '" + SF2->F2_FILIAL + "'"
		_cQuery += _cEnter + "AND C7_FORNECE = '" + SF2->F2_CLIENTE + "'"
		_cQuery += _cEnter + "AND C7_LOJA = '" + SF2->F2_LOJA + "'"
		_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
		_cQuery += _cEnter + "AND C7_QUJE = 0"
		_cQuery += _cEnter + "AND C7_OBS = 'DEV SIMB " + SF2->F2_DOC + SF2->F2_SERIE + "'"
		TcSqlExec(_cQuery)
		RestArea(_aAlias)
		Return(.t.)
							
	ElseIf empty(_cPedido)  	// ainda não existe o pedido de compras, então procuro o pedido de vendas de devolução simbólica.

		_cQuery := "SELECT C5_NUM, C5_NOTA, C5_SERIE"
		_cQuery += _cEnter + "FROM " + RetSqlName('SC5') + " (NOLOCK)"
		_cQuery += _cEnter + "WHERE C5_FILIAL = '" + SF2->F2_FILIAL + "'"
		_cQuery += _cEnter + "AND C5_CLIENTE = '" + SF2->F2_CLIENTE + "'"
		_cQuery += _cEnter + "AND C5_LOJACLI = '" + SF2->F2_LOJA + "'"
		_cQuery += _cEnter + "AND C5_EMISSAO = '" + dtos(SF2->F2_EMISSAO) + "'"
		_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
		_cQuery += _cEnter + "AND C5_USERCAL = 'NF " + SF2->F2_DOC + SF2->F2_SERIE + "'"
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SC5', .F., .T.)
		_cPedido := _SC5->C5_NUM
		_cNota   := _SC5->C5_NOTA + _SC5->C5_SERIE
		DbCloseArea()
		RestArea(_aAlias)
		If !empty(_cNota)	// já existe o pedido de vendas de devolução simbólica  a nota fiscal já foi faturada
			MsgBox ("Pedido de devolução si mbólica já faturado! Excluir manualmente a nota fiscal nro " + left(_cNota,9) + " série " + right(_cNota,3),"ATENÇÃO!!!","ALERT!!!")
			Return(.f.)                                                           

		ElseIf !empty(_cPedido)	//	se não estiver faturado, a o PV de devolução simbólica será excluido 
						
				_aCabPv	:= {}
				aAdd(_aCabPv, {"C5_FILIAL"	, SF2->F2_FILIAL	, Nil})
				aAdd(_aCabPv, {"C5_NUM" 	, _cPedido	, Nil})
				
				_aItensPv := {}
				
				Begin Transaction
				
				lMsErroAuto := .f.
				IncProc()
				MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItensPv,5)
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
				EndIf
				End Transaction
				
		EndIf
	EndIf
EndIf

If SF2->F2_CLIENTE < '000009' .and. SF2->F2_LOJA <> SF2->F2_FILIAL .and. SF2->F2_TIPO == 'N'
	_cQuery := "SELECT DISTINCT A1_COD, A1_LOJA, ISNULL(C9_PEDIDO,'') C9_PEDIDO, ISNULL(F1_DOC,'') F1_DOC, A2_NREDUZ"
	
	_cQuery += _cEnter + "FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)"
	
	_cQuery += _cEnter + "LEFT JOIN " + RetSqlName('SC9') + " SC9 (NOLOCK)"
	_cQuery += _cEnter + "ON C9_FILIAL = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + "AND C9_NFISCAL = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + "AND C9_SERIENF = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + "AND C9_CLIENTE = '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + "AND C9_LOJA = '" + SF2->F2_LOJA + "'"
	_cQuery += _cEnter + "AND SC9.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + "LEFT JOIN " + RetSqlName('SF1') + " SF1 (NOLOCK)"
	_cQuery += _cEnter + "ON F1_FILIAL = C9_LOJA"
	_cQuery += _cEnter + "AND F1_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + "AND F1_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + "AND F1_FORNECE = A1_COD"
	_cQuery += _cEnter + "AND F1_LOJA = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + "AND SF1.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + "LEFT JOIN " + RetSqlName('SA2') + " SA2 (NOLOCK)"
	_cQuery += _cEnter + "ON A2_LOJA = '" + SF2->F2_LOJA + "'"
	_cQuery += _cEnter + "AND A2_COD = '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + "AND SA2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + "WHERE SA1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND A1_COD < '000009'"
	_cQuery += _cEnter + "AND A1_LOJA = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + "AND A1_MSBLQL <> '1'"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SA1', .F., .T.)
	_cFornece := _SA1->A1_COD
	
	If !empty(_SA1->F1_DOC)
		_cTexto := 'Nota fiscal refere-se a romaneio ' + _SA1->C9_PEDIDO + _SA1->A1_LOJA + '.' + _cEnter
		_cTexto += 'Este romaneio encontra-se encerrado.'+ '.' + _cEnter
		_cTexto += 'Já foi feita a entrada desta nota na unidade de destino (' + SF2->F2_LOJA + ' - ' + alltrim(_SA1->A2_NREDUZ) + ').'
		If __cUserId $ GetMv('LA_PODER') + GetMv('LS_GFISCAL')
			_cTexto += _cEnter + _cEnter + 'Deseja realmente excluir essa nota?'
			If !MsgBox(_cTexto,'ATENÇÃO!!!','YESNO')
				_lret := .f.
			EndIf
		Else
			MsgBox(_cTexto,'ATENÇÃO!!!','ALERT')
			_lret := .f.
		EndIf
	EndIf
	DbCloseArea()
EndIf

Return(_lRet)