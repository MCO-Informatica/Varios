#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
// Funcao      	LS_Z15
// Autor 		Alexandre Dalpiaz
// Data 		20/11/2012
// Descricao    NOTAS SILVERADO
// Uso         	Especifico para laselva
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	PE na validação do produto do pedido de vendas - verifica quantidade x transito (destino) x saldo do produto (origem)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_C6QTD(_nQuant, _cC6_PRODUTO, _cC6_TES, _cC6_ITEM, _nC6_QTDVEN,_nQtAcumulada, _cC6Local)
////////////////////////////////////////////////////////////////////////////////////////////////////////

Local _nQtOri  		:= 0
 Local _lRet   		:= .t.
Local _lRet2  		:= .t.
 Local _cMsg   		:= ''
  Local _aArea, _nSAtu, _nEMax, _nEmin, _nTrans
 Local _cFilEstFree 	:= GetMv('LS_FLESTFR')
Local  QTVEN
Local cMovEst		:= Posicione('SF4',1,xFilial('SF4') + _cC6_TES,'F4_ESTOQUE')
DEFAULT _cC6Local 	:= '01'

If cFilAnt == 'C0'
	If empty(M->C5_TES)
		MsgBox('Informe o TES padrão no cabeçalho do pedido','ATENÇÃO!!!','ALERT')
		Return(.f.)
	Else
		Return(.t.)
	EndIf
EndIf

SB1->(DbSetOrder(1))
If SB1->(Dbseek(xFilial("SB1")+_cC6_PRODUTO,.f.))
	_cC6_PRODUTO := SB1->B1_COD
Else
	SB1->(DbSetOrder(5))
	If SB1->(Dbseek(xFilial("SB1")+_cC6_PRODUTO))
		_cC6_PRODUTO := SB1->B1_COD
	Else
		MsgStop("Produto não cadastrado!")
		Return(.F.)
	EndIf
EndIf

If !(xFilial('SC5') $ _cFilEstFree)

	_nEstoq := Posicione('SB2',1, xFilial('SB2') + _cC6_PRODUTO + _cC6Local ,'B2_QATU')			// estoque atual na centralizadora
	///////////////-Atualiza transito na filial destino-///////////////
	//RECLOCK('SB2', .F.)
	//SB2->B2_SALPEDI := Posicione('SB2',1, xFilial('SB2') + _cC6_PRODUTO + _cC6Local ,'B2_QATU')
	//MSUNLOCK()     // Destrava o registro
	///////////////////////////////////////////////////////////////////
	_cQuery := "SELECT C6_NUM, (C6_QTDVEN) - (C6_QTDENT) QTDLIB"
	_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"

	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery += _cEnter + " 										ON F4_CODIGO 		= C6_TES "
	_cQuery += _cEnter + " 										AND SF4.D_E_L_E_T_ 	= '' "
	_cQuery += _cEnter + " 										AND F4_ESTOQUE 		= 'S' "
	_cQuery += _cEnter + " WHERE C6_FILIAL 				= '" + cFilAnt + "' "
	_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ 			= '' "
	_cQuery += _cEnter + " AND C6_PRODUTO 				= '" + _cC6_PRODUTO + "' "
	_cQuery += _cEnter + " AND C6_QTDVEN - C6_QTDENT	> 0 "
	_cQuery += _cEnter + " AND C6_NOTA 					= ''"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'LIB', .F., .T.)         
	_nRes   := 0                                                              	// reserva atual 
	_cPVs	:= ''																// pedidos de venda com saldo
	Do While !eof()
		_cPVs += LIB->C6_NUM + ' / '
		_nRes += LIB->QTDLIB                                                      // reserva atual 
		DbSkip()
	EndDo
	DbCloseArea()

	If !SB2->(eof()) // PROVAVELMENTE NA FILIAL CORRENTE /ORIGEM
		RecLock("SB2",.F.)
		SB2->B2_RESERVA := _nRes // RESERVA
		MsUnLock()
	EndIf           
//	 alterado sidney
//	_nTranProp := SB2->B2_SALPEDI     														// transito próprio
//	 alterado sidney

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//	_nTrans := Posicione("SB2",1, M->C5_LOJACLI + _cC6_PRODUTO + '01','B2_SALPEDI') 		// transito para a loja // ATUALIZA NO DESTINO

	_nTrans := Posicione("SB2",1, M->C5_LOJACLI + _cC6_PRODUTO + '01','B2_XTRANSI') 		// transito para a loja // ATUALIZA NO DESTINO
if _nTrans<0
_nTrans:=0
endif	

	_nSAtu  := SB2->B2_QATU                                                                 // saldo atual na loja
	_nEMax  := Posicione('SBZ',1, M->C5_LOJACLI + _cC6_PRODUTO ,  'BZ_EMAX') 				// estoque máximo na loja // ATUALIZA NO DESTINO
	_nEmin  := SBZ->BZ_EMIN                                                                 // estoque mínimo na loja



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira comentou abaixo para melhorar.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*	
	If 'SACOLA' $ Posicione('SB1',1,xFilial('SB1') + _cC6_PRODUTO,'B1_DESC') .and. _nC6_QTDVEN > _nQuant
		If !l410Auto
			MsgBox('Quantidade de sacolas maior que máximo permitido.','ATENÇÃO!!!','ALERT')
		EndIF
		_lRet := .f.
		
	ElseIf M->C5_CLIENTE > '000009' .and. M->C5_TIPO == 'N'
		If _cC6_TES == 'xxx' .or. (!empty(_cC6_TES) .and. cMovEst == 'S')
			
			If _nC6_QTDVEN > Posicione('SB2',1,xFilial('SB2') + _cC6_PRODUTO + '01','B2_QATU') - SB2->B2_RESERVA
				_lRet := .f.
				If !l410Auto
					MsgBox('Quantidade solicitada é maior que estoque atual (menos reserva).','ATENÇÃO!!!','ALERT')
				EndIf
			EndIf
		EndIf
	EndIf
*/	     

	If M->C5_CLIENTE > '000009'
		If  !empty(_cC6_TES) .and. cMovEst == 'S'
			
			If _nC6_QTDVEN > Posicione('SB2',1,xFilial('SB2') + _cC6_PRODUTO + '01','B2_QATU') - SB2->B2_XRESERV
				_lRet := .f.
				If !l410Auto
					MsgBox('Quantidade solicitada é maior que estoque atual (menos reserva).','ATENÇÃO!!!','ALERT')
				EndIf
			EndIf
		EndIf
	EndIf
	
	If Altera .and. _lRet
		_aArea := GetArea()
		DbSelectArea('SC6')
		DbSetOrder(1)
		If DbSeek(SC5->C5_FILIAL + SC5->C5_NUM + _cC6_ITEM + _cC6_PRODUTO,.f.)
			_nTrans -= 0 //SC6->C6_QTDVEN       //ALTERADO SIDNEY
			_nRes   -= SC6->C6_QTDVEN
		Else
			DbSetOrder(2)
			DbSeek(SC5->C5_FILIAL + _cC6_PRODUTO + SC5->C5_NUM,.f.)
			_nTrans -= 0//SC6->C6_QTDVEN       //ALTERADO SIDNEY
			_nRes   -= SC6->C6_QTDVEN
		EndIf
		DbSetOrder(1)
		RestArea(_aArea)
	EndIf
	
	//If _lRet .and. !l410Auto .and. M->C5_CLIENTE < '000009' .and. !GdDeleted() //.and. M->C5_TIPO == 'N'
	If _lRet .or. IsInCallStack('U_FATP006')//.and. M->C5_TIPO == 'N'
		If _cC6_TES == 'xxx' .or. (!empty(_cC6_TES) .and. cMovEst == 'S') 
			//If M->C5_TIPO == 'N'
			If M->C5_CLIENTE < '000009' 
				_lRet  := _nEstoq - _nRes >= _nC6_QTDVEN
				_lRet2 := _nC6_QTDVEN + _nSAtu + _nTrans < _nEMin //ALTERADO SIDNEY
				//_lRet2 := _nC6_QTDVEN + _nSAtu < _nEMin//ALTERADO SIDNEY
				If !_lRet .or. !_lRet2
					_cMsg += 'Produto: ' 						+ _cC6_PRODUTO					+ _cEnter + _cEnter
					_cMsg += 'Estoque atual: '              	+ alltrim(str(_nEstoq)) 		+ _cEnter
					_cMsg += 'Reservado em PVs:'         		+ alltrim(str(_nRes)) 			+ _cEnter
					If !empty(_cPVs)
						_cMsg += 'Pedidos de venda pendentes:' 	+ _cPVs							+ _cEnter
					EndIf
					_cMsg += 'Disponível no estoque:'         	+ alltrim(str(_nEstoq - _nRes)) + _cEnter
//					_cMsg += 'Em trânsito (próprio):'         	+ alltrim(str(_nTranProp))      + _cEnter // ALTERADO SIDNEY
					_cMsg += 'Disponível na Loja: ' 			+ alltrim(str(_nSAtu)) 			+ _cEnter
					_cMsg += 'Estoque mínimo na Loja: ' 		+ alltrim(str(_nEMin)) 			+ _cEnter
					_cMsg += 'Estoque máximo na Loja: ' 		+ alltrim(str(_nEMax)) 			+ _cEnter
					_cMsg += 'Trânsito para a Loja: ' 			+ alltrim(str(_nTrans)) //SIDNEY ALTERADO
					
					If !_lRet .or. (_nC6_QTDVEN + _nQtAcumulada) > (_nEstoq - _nRes)
						If !l410Auto
							MsgBox(_cMsg,'ATENÇÃO!!!','ALERT')
						EndIf
						cGetProd := space(19)
						Return(.f.)
					Else
						If !l410Auto
							_lRet := MsgBox(_cMsg + _cEnter + _cEnter + 'Continuar???','ATENÇÃO!!!','YESNO')
							If !_lRet
								cGetProd := space(19)
								Return(_lRet)
							EndIf
						Else
							Return(_lRet)
						EndIf
					EndIf
				EndIf
			Else
				_lRet   := _nEstoq - _nRes >= _nC6_QTDVEN
				If !_lRet    
					If !l410Auto
						_cMsg += 'Produto: ' 						+ _cC6_PRODUTO					+ _cEnter + _cEnter
						_cMsg += 'Estoque atual: '              	+ alltrim(str(_nEstoq)) 		+ _cEnter
						_cMsg += 'Reservado em PVs:'         		+ alltrim(str(_nRes)) 			+ _cEnter
						If !empty(_cPVs)
							_cMsg += 'Pedidos de venda pendentes:' 	+ _cPVs							 + _cEnter
						EndIf
						_cMsg += 'Disponível no estoque:'         	+ alltrim(str(_nEstoq - _nRes)) + _cEnter
						//_cMsg += 'Em trânsito (próprio):'         	+ alltrim(str(_nTranProp))      + _cEnter
						MsgBox(_cMsg,'ATENÇÃO!!!','ALERT')
						cGetProd := space(19)
					EndIf
					Return(_lRet)
				EndIf
			EndIf                                                         // 1009939
			
		EndIf
	EndIf
EndIf

Return(_lRet)

