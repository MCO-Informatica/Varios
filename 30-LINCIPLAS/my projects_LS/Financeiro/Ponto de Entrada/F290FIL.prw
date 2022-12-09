#include "rwmake.ch"

// 	Programa:	f290fil
//	Autor:		Alexandre Dalpiaz
//	Data:		15/08/2012
//	Uso:		LASELVA
//	Funcao:		PE na geracão de faturas de contas a pagar para filtrar títulos

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F290FIL()
///////////////////////
_cFil     := '.t.'
/*
U_LS_MATRIZ()
_dVencDe  := ctod('')
_dVencAte := ctod('')
_lOK      := .f.
_cFil     := '.t.'
_cRefat   := ' '

@ 96,42 TO 323,505 DIALOG oDlg1 TITLE "Filtro para geração de faturas"
@ 030,005 Say 'Vencimento Real de'
@ 045,005 Say 'Vencimento Real até'
@ 060,005 Say 'Refaturamento (S/N)'
@ 030,060 get _dVencDe  size 50,10 valid Vazio() .or. _dVencDe <= _dVencAte .or. Vazio(_dVencAte)
@ 045,060 get _dVencAte size 50,10 valid Vazio() .or. _dVencDe <= _dVencAte .or. Vazio(_dVencDe)
@ 060,060 get _cRefat   size 10,10 valid Vazio() .or. Pertence('SN') Picture '!'

@ 090,050 BMPBUTTON TYPE 01 ACTION (_lOk := .t., oDlg1:End())
@ 090,100 BMPBUTTON TYPE 02 ACTION (_lOk := .f., oDlg1:End())

Activate Dialog oDlg1 Centered

If _lOk
	_cFil := "dtos(E2_VENCREA) >= '" + dtos(_dVencDe) + "' .and. dtos(E2_VENCREA) <= '" + dtos(_dVencAte) + "'"
	If _cRefat == 'S'
		_cQuery := "UPDATE " + RetSqlName('SE2')
		_cQuery += _cEnter + " SET E2_FATURA = ''"
		_cQuery += _cEnter + " WHERE E2_FATURA 	= 'NOTFAT'"
		_cQuery += _cEnter + " AND E2_FORNECE 	= '" + cForn + "'"
		_cQuery += _cEnter + " AND E2_EMISSAO 	BETWEEN '" + dtos(dDataDe) + "' AND '" + dtos(dDataAte) + "'"
		_cQuery += _cEnter + " AND E2_SALDO 	> 0"
		_cQuery += _cEnter + " AND E2_MOEDA 	= '" + AllTrim(Str( nMoeda,2 )) + "'"
		_cQuery += _cEnter + " AND E2_NUMBOR 	= '" + Space( Len( se2->E2_NUMBOR ) ) + "'"
		_cQuery += _cEnter + " AND E2_TIPO 		NOT IN ('" + MVPAGANT + "','" + MVPROVIS + "','" + MVABATIM + "')"
		_cQuery += _cEnter + " AND E2_VENCREA 	BETWEEN '" + dtos(_dVencDe) + "' AND  '" + dtos(_dVencAte) + "'"
		_cQuery += _cEnter + " AND D_E_L_E_T_ 	= ''"
		_cQuery += _cEnter + " AND E2_MATRIZ 	= '" + cFilAnt + "'"
		
		IF mv_par01 == 1
			_cQuery += _cEnter + " AND E2_LOJA = '" + cLoja + "'"
		EndIF
		
		TcSqlExec(_cQuery)
	EndIf
	
EndIf
*/
Return(_cFil)
