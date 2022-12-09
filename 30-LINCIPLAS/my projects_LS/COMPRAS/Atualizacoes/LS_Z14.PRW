#INCLUDE "rwmake.ch"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Z14()
//////////////////////

Private cString := "Z14"

dbSelectArea("Z14")
dbSetOrder(1)

AxCadastro(cString,"Relacionamento Cod Barras Boletos x Notas Fiscais de Entrada")

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Z14_DIGITA -> Z14_CODBAR
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z14GAT01(_cPar)
/////////////////////////////
_cRet := substr(_cPar,1,4) + substr(_cPar,33,15) + substr(_cPar,5,5) + substr(_cPar,11,10) + substr(_cPar,22,10)
Return(_cRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
// Z14_CODBAR -> Z14_DIGITA
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z14GAT02(_cPar)
/////////////////////////////
_cRet := substr(_cPar,1,4) + substr(_cPar,20,5) + Dv_10_21(substr(_cPar,1,4) + substr(_cPar,20,5))
_cRet += substr(_cPar,25,10) + Dv_10_21(substr(_cPar,25,10))
_cRet += substr(_cPar,35,10) + Dv_10_21(substr(_cPar,35,10))
_cRet += substr(_cPar,5,15)
Return(_cRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
// validação da linha digitavel
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z14VlDig(_cPar)
/////////////////////////////
Local _lRet := .t.
Local _aFator := {left(_cPar,9),substr(_cPar,11,10),substr(_cPar,22,10)}
Local _aDVs   := {substr(_cPar,10,1),substr(_cPar,21,1),substr(_cPar,32,1)}
Local _cDv    := substr(_cPar,33,1)
Local _nI, _cTexto
Local _nMult := 2
Local _nSum  := 0

For _nI := 1 to 3       
	_xxx := Dv_10_21(_aDvs[_nI])
	If _aDVs[_nI] <> _xxx
		MsgBox('Dígito verificador do campo' + str(_nI,1) + ' (' + _aFator[_nI] + ' - ' + _aDvs[_nI] + ') inválido. Verifique a digitação','ATENÇÃO!!!','ALERT')
		_lRet := .f.
		Exit
	EndIf
Next

If _lRet
	
	_cPar := left(_cPar,32) + right(_cPar,14)
	For _nI := len(_cPar) to 1 step -1
		_nSum += val(substr(_cPar,_nI,1)) * _nMult
		If _nMult >= 9
			_nMult := 2
		Else
			_nMult += 1
		EndIf 
	Next	
	_nSum := mod(_nSum,10)
	
	If _nSum > 9
		_nSum := 1
	EndIf

	If val(_cDv) <> _nSum
		MsgBox('Dígito verificador geral do código de barras inválido. Verifique a digitação','ATENÇÃO!!!','ALERT')
		_lRet := .f.
	EndIf
		
EndIf

Return(_lRet)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// módulo 10, de 2 a 1, da direita prá esquerda                        
// calculo DV linha digitável
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Dv_10_21(_cFator)
//////////////////////////////
Local _nI, _nDv    
Local _nSoma  := 0    
Local _nFator := 1

For _nI := len(alltrim(_cFator)) to 1 step -1

	_nFator := iif(_nFator == 1,2,1)
                     
    _xFator := val(substr(_cFator,_nI,1)) * _nFator
    If _xFator > 9
    	_xFator := str(_xFator,2)
    	_xFator := val(left(_xFator,1)) + val(right(_xFator,1))
    EndIf
	_nSoma += _xFator

Next                                               
         
If mod(_nSoma,10) == 0
	_nDv := '0'
ElseIf _nSoma < 10
	_nDv := str(10 - _nSoma,1)
Else              
	_nDv := str(10 - mod(_nSoma,10),1)
EndIf
        
Return(_nDv)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// inicializadors dos campos - Z14_DOC, Z14_SERIE, Z14_PARCEL, Z14_FORNEC, Z14_LOJA
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z14Relacao(_xTipo)
///////////////////////////////
Local _aAlias := GetArea()

If _xTipo == 1
	_cQuery := "SELECT MAX(R_E_C_N_O_) NRECNO"
	_cQuery += _cEnter + " FROM " + RetSqlName('Z14') + " Z14 (NOLOCK)"
	_cQuery += _cEnter + " WHERE Z14_FILIAL = '" + xFilial('Z14') + "'"
	_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), '_Z14', .F., .T.)
	Z14->(DbGoTo(_Z14->NRECNO))         
	DbCloseArea()
	_cRet := space(9)
	RestArea(_aAlias)

ElseIf _xTipo == 2
	_cRet := space(3)
ElseIf _xTipo == 3
	_cRet := space(6)
ElseIf _xTipo == 4
	_cRet := space(2)
ElseIf _xTipo == 5
	_cRet := space(3)
EndIf

If _xTipo == 1 .and. !empty(Z14->Z14_PARCEL)
	_cRet := Z14->Z14_DOC
ElseIf _xTipo == 2 .and. !empty(Z14->Z14_PARCEL)
	_cRet := Z14->Z14_SERIE
ElseIf _xTipo == 3 .and. !empty(Z14->Z14_PARCEL)
	_cRet := Z14->Z14_FORNEC
ElseIf _xTipo == 4 .and. !empty(Z14->Z14_PARCEL)
	_cRet := Z14->Z14_LOJA
ElseIf _xTipo == 5 .and. !empty(Z14->Z14_PARCEL)
	_cRet := strzero(val(Z14->Z14_PARCEL)+1,3)
EndIf

Return(_cRet)

