#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
// Programa...: ls_f1vlcond
// Autor......: Alexandre Dalpiaz
// Data inicio: 08/05/08
// Cliente....: Laselva Bookstroe
// Descricao..: validacao da condicao de pagamento nas notas fiscais de entrada / titulos a pagar
// 				referente à questão de vencimentos "já vencidos"
// Chamada....: validação dos campos F1_COND, F1_EMISSAO, E2_VENCTO, E2_DTFATUR
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_F1VLCOND(_xTipo, _xDtVenc, _xCond, _xEspecie)
//////////////////////////////////////////////////////////////

// tipo da validacao: 1 = valida F1_COND & F1_EMISSAO, 2 = valida (campos de vencimento em geral) E2_VENCTO/E2_DTFATUR
// parâmetros:

Local _xTipo, _cVencto, _lRet, _aParc, _xEspecie, _aCons, _aEspecie
Local _lRet 	:= .t.
Local _aLimites := alltrim(GetMv('LS_LIMVENC'))  
                                                       
Default _xCond    := iif(Type('cCondicao') == 'C',cCondicao,'')
Default _xEspecie := iif(Type('cEspecie') == 'C',cEspecie,'')

If FunName() $ 'LS_LANCA/LS_ROMA'
	Return(.t.)
EndIf

If left(_aLimites,1) <> '{' .or. right(_aLimites,1) <> '}' .or. at(',',_aLimites) == 0
	MsgBox('Problema no parâmetro LS_LIMVENC' + _cEnter + _cEnter + 'Entrar em contato com Depto Financeiro','ATENÇÃO!!!','STOP')
	Return(.f.)
EndIf

_aLimites := &_aLimites

If ValType(_aLimites) <> 'A' .or. ValType(_aLimites[1]) <> 'N' .or. ValType(_aLimites[2]) <> 'N'
	MsgBox('Problema no parâmetro LS_LIMVENC (limites máximo e mínimo)' + _cEnter + _cEnter + 'Entrar em contato com Depto Financeiro','ATENÇÃO!!!','STOP')
	Return(.f.)
EndIf

If ValType(_aLimites[3]) <> 'C'
	MsgBox('Problema no parâmetro LS_LIMVENC (tipos de documento permitidos na exceção)' + _cEnter + _cEnter + 'Entrar em contato com Depto Financeiro','ATENÇÃO!!!','STOP')
	Return(.f.)
EndIf

If ValType(_aLimites[4]) <> 'C'
	MsgBox('Problema no parâmetro LS_LIMVENC (Condições de pagamento permitidas na exceção)' + _cEnter + _cEnter + 'Entrar em contato com Depto Financeiro','ATENÇÃO!!!','STOP')
	Return(.f.)
EndIf

If ValType(_aLimites[5]) <> 'C'
	MsgBox('Problema no parâmetro LS_LIMVENC (Usuários permitidos na exceção)' + _cEnter + _cEnter + 'Entrar em contato com Depto Financeiro','ATENÇÃO!!!','STOP')
	Return(.f.)
EndIf

If at(_xCond,_aLimites[4]) > 0 .or. at(_xEspecie,_aLimites[3]) > 0
	Return(.t.)
EndIf
	
If _xTipo == 1	// validacao F1_COND / F1_EMISSAO
	                            
	_nValor := 0
	For _nI := 1 to len(aCols)
		If !GdDeleted() .and. Posicione('SF4',1,xFilial('SF4') + GdFieldGet('D1_TES',_nI),'F4_DUPLIC') == 'S' .and. SF4->F4_AGREG <> 'N'
			_nValor += GdFieldGet('D1_TOTAL',_nI)
		EndIf
	Next
	If _nValor == 0
		Return(.t.)
	EndIf           
	
	Public __aColsSE2 := {}
	_aParc := Condicao(_nValor, _xCond, ,_xDtVenc)
	For _nI := 1 to len(_aParc)
		aAdd(__aColsSE2,{strzero(_nI,3),_aParc[_nI,1]})
		If _aParc[_nI,1] < DataValida(date()+_aLimites[1])
			If at(__cUserId,_aLimites[5]+'/' + GetMv('LA_PODER')) > 0 
				If !MsgBox('Vencimento (' + dtoc(_aParc[_nI,1]) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' + _cEnter + 'Prosseguir com a operação?','ATENÇÃO!!!','YESNO')
					_lRet    := .f.
					Exit
				EndIf
			Else
				MsgBox('Vencimento (' + dtoc(_aParc[_nI,1]) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)','ATENÇÃO!!!','ALERT')
				_lRet    := .f.
			EndIf
		ElseIf _aParc[_nI,1] > DataValida(date()+_aLimites[2])
			If at(__cUserId,_aLimites[5]+'/' + GetMv('LA_PODER')) > 0 
				If !MsgBox('Vencimento (' + dtoc(_aParc[_nI,1]) + ') não é menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' + _cEnter + 'Prosseguir com a operação?','ATENÇÃO!!!','YESNO')
					_lRet    := .f.
					Exit
				EndIf
			Else
				MsgBox('Vencimento (' + dtoc(_aParc[_nI,1]) + ') não é menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)','ATENÇÃO!!!','ALERT')
				_lRet    := .f.
			EndIf
		EndIf
	Next
	
ElseIf _xTipo == 2	// valida E2_VENCTO
	
	If Type('M->E2_TIPO') == 'U'.and. aScan(_aLimites, alltrim(_xEspecie)) > 0
		If at(__cUserId,_aLimites[5]+'/' + GetMv('LA_PODER')) > 0 
			_lRet := MsgBox('Vencimento (' + dtoc(_xDtVenc) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' + _cEnter + 'Prosseguir com a operação?','ATENÇÃO!!!','YESNO')
		Else
			_lRet := .f.
			MsgBox('Vencimento (' + dtoc(_xDtVenc) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)','ATENÇÃO!!!','ALERT')
		EndIf
	ElseIf Type('M->E2_TIPO') <> 'U' .and. alltrim(M->E2_TIPO) == 'PA'
		_lRet := .t.
	ElseIf _xDtVenc < DataValida(date()+_aLimites[1])
		If at(__cUserId,_aLimites[5]+'/' + GetMv('LA_PODER')) > 0 
			If !MsgBox('Vencimento (' + dtoc(_xDtVenc) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' +_cEnter + 'Prosseguir com a operação?','ATENÇÃO!!!','YESNO')
				_lRet    := .f.
			EndIf
		Else
			MsgBox('Vencimento (' + dtoc(_xDtVenc) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)','ATENÇÃO!!!','ALERT')
			_lRet    := .f.
		EndIf
	ElseIf _xDtVenc > DataValida(date()+_aLimites[2])
		If at(__cUserId,_aLimites[5]+'/' + GetMv('LA_PODER')) > 0 
			If !MsgBox('Vencimento (' + dtoc(_xDtVenc) + ') não pode ser maior que ' + dtoc(DataValida(date()+_aLimites[2])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' +_cEnter + _cEnter + 'Prosseguir com a operação?','ATENÇÃO!!!','YESNO')
				_lRet    := .f.
			EndIf
		Else
			MsgBox('Vencimento (' + dtoc(_xDtVenc) + ') não pode ser maior que ' + dtoc(DataValida(date()+_aLimites[2])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)','ATENÇÃO!!!','ALERT')
			_lRet    := .f.
		EndIf
	EndIf
	
	If Type('acols') <> 'U' .and. !empty(aCols)
		__aColsSE2 := aClone(aCols)
		__aColsSE2[n,2] := _xDtVenc
	EndIf
	
ElseIf _xTipo == 3 .and. Type('__aColsSE2') <> 'U' // validação da NFE
	                                 
	If empty(__aColsSE2)
		_nValor := 0
		For _nI := 1 to len(aCols)
			If !GdDeleted() .and. Posicione('SF4',1,xFilial('SF4') + GdFieldGet('D1_TES',_nI),'F4_DUPLIC') == 'S' .and. SF4->F4_AGREG <> 'N'
				_nValor += GdFieldGet('D1_TOTAL',_nI)
			EndIf
		Next
		If _nValor == 0
			Return(.t.)
		EndIf
		_aParc := Condicao(_nValor, _xCond, ,_xDtVenc)
		For _nI := 1 to len(_aParc)
			aAdd(__aColsSE2,{strzero(_nI,3),_aParc[_nI,1]})
		Next
	EndIf

	For _nI := 1 to len(__aColsSE2)
		If !l103Auto .and. __aColsSE2[_nI,2] < DataValida(date()+_aLimites[1])
			If at(__cUserId,_aLimites[5]+'/' + GetMv('LA_PODER')) > 0 
				_lRet := MsgBox('Parcela ' + alltrim(__aColsSE2[_nI,1]) + ' com vencimento (' + dtoc(__aColsSE2[_nI,2]) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' + _cEnter + _cEnter + 'Prosseguir??' ,'ATENÇÃO!!!','YESNO')
			Else
				MsgBox('Parcela ' + alltrim(__aColsSE2[_nI,1]) + ' com vencimento (' + dtoc(__aColsSE2[_nI,2]) + ') não pode ser menor que ' + dtoc(DataValida(date()+_aLimites[1])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' ,'ATENÇÃO!!!','ALERT')
				_lRet := .f.
			EndIF
		EndIf
		If !l103Auto .and. __aColsSE2[_nI,2] > DataValida(date()+_aLimites[2])
			If at(__cUserId,_aLimites[5]+'/' + GetMv('LA_PODER')) > 0 
				_lRet := MsgBox('Parcela ' + alltrim(__aColsSE2[_nI,1]) + ' com vencimento (' + dtoc(__aColsSE2[_nI,2]) + ') não pode ser maior que ' + dtoc(DataValida(date()+_aLimites[2])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)'+_cEnter + _cEnter + 'Prosseguir???','ATENÇÃO!!!','YESNO')
			Else
				_lRet := MsgBox('Parcela ' + alltrim(__aColsSE2[_nI,1]) + ' com vencimento (' + dtoc(__aColsSE2[_nI,2]) + ') não pode ser maior que ' + dtoc(DataValida(date()+_aLimites[2])) + _cEnter + 'Verifique a condição e pagamento e/ou vencimento(s) da(s) parcela(s)' ,'ATENÇÃO!!!','ALERT')
				_lRet := .f.
			EndIf
		EndIf
	Next
	
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ponto de entrada para manipular o array de títulos na entrada de notas (mata103x)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MTCOLSE2()
////////////////////////
Local _nI
Local _aRet := aClone(paramixb[1])
__aColsSE2 := {}
For _nI := 1 to len(_aRet)    
	aAdd(__aColsSE2,{strzero(_nI,3), _aRet[_nI,2]})
Next
Return(_aRet)




User Function ALTDATAL()
_dData := dDataLanc

Return(_dData)
