#INCLUDE "PROTHEUS.CH"

STATIC _cExpres := ""
STATIC _cArqFil := "P"+__cUserID+".FLT"

/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑ ณPrograma  ณMA410MNU  ณ Autor ณ Eneovaldo Roveri Juni ณ Data ณ16/11/2009ณฑฑ
ฑฑ ณDescricao ณPONTO DE ENTRADA PARA INCLUIR OPวรO CANCELAR                ณฑฑ
*/

User Function MA410MNU() 
	Local _i
	Local _lSubMenu := .f.
	Local _rotina
	Local _aAux:={}

	_aAux := {"Cancelar","U_A410CANC",0,2,0,NIL}

	for _i := 1 to len( aRotina )
		_lSubMenu := .F.
		_rotina := aRotina[_i, 2]
		if ValType( _rotina ) == "A"
			_rotina := aRotina[_i, 2, 1, 2]
			_lSubMenu := .T.
		endif
		if _rotina == "A410Deleta"
			if _lSubMenu
				aRotina[ _i, 1 ] := "Cancelar"
				aRotina[ _i, 2, 1 ] := _aAux
				aRotina[ _i, 2, 2, 1 ] := "Exc." + aRotina[ _i, 2, 2, 1 ]
			else
				aRotina[ _i ] := _aAux
			endif
		endif
	next _i

	aadd( aRotina, {"E-mail de Confirma็ใo","U_ENVPEDVEND",0,2,0,NIL} )   
	aadd( aRotina, {"Imprimir Pedido"	,"U_IMCDR01()"		,0,2,0,NIL} )  
	//if lExcept
	aadd( aRotina, {"Liberar MARGEM"	,"U_A440MARG(1)"	,0,2,0,NIL} )
	//endif
	aadd( aRotina, {"Reprova MARGEM"	,"U_A440MARG(2)"	,0,2,0,NIL} )	
	aadd( aRotina, {"Liberar Risco de Fraude"	,"U_A440MARG(3)"	,0,2,0,NIL} )
	aadd( aRotina, {"Liberar Consignado"	,"U_A440MARG(4)"	,0,2,0,NIL} )
Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410MNU  บAutor  ณMicrosiga           บ Data ณ  04/28/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XFILC5F5
	Local _cFiltro    := ""
	Local nTipo		  := 0

	nTipo := Aviso( "Filtro", "Selecione o Tipo do Filtro", { "Aberto", "Encerrado", "Cancelado", "Rejeitado", "Tudo", "Filtro" } )

	dbSelectArea( "SC5" )

	_cFiltro := dbFilter()

	dbClearFilter()

	If nTipo == 1
		//	_cFiltro := "Empty( C5_LIBEROK ) .And. Empty( C5_NOTA ) .And. Empty( C5_BLQ ) .and. C5_X_REP != 'R' .and. C5_X_CANC != 'C'"
		_cFiltro := "Empty( C5_NOTA ) .And. Empty( C5_BLQ ) .and. C5_X_REP != 'R' .and. C5_X_CANC != 'C'"

	ElseIf nTipo == 2
		_cFiltro := "!Empty( C5_NOTA ) .and. C5_X_REP != 'R' .and. C5_X_CANC != 'C'"

	ElseIf nTipo == 3
		_cFiltro := "C5_X_CANC = 'C' .and. C5_X_REP != 'R'"

	ElseIf nTipo == 4
		_cFiltro := "C5_X_REP = 'R' .and. C5_X_CANC != 'C'"

	ElseIf nTipo == 5
		_cFiltro := ""

	ElseIf nTipo == 6
		_cExpres := BuildExpr("SC5")

	Endif

	If !Empty(_cExpres)
		If !Empty(_cFiltro)
			_cFiltro += ".And. ("+AllTrim(_cExpres)+")"
		Else
			_cFiltro := AllTrim(_cExpres)
		EndIf
	EndIf

	If !Empty( _cFiltro )
		dbClearFilter()
		MsFilter( _cFiltro )   
		SC5->(dbGotop())
		&&	oMbObj := GetObjBrow()
		&&	oMbObj:REFRESH()
		&&	Eval(oMbObj:bGoTop)	// Para corrigir um bug de refresh na MBrowse
	Endif

	oMbObj := GetObjBrow()
//	oMbObj:REFRESH()

	If File(_cArqFil)
		FErase(_cArqFil)
	EndIf

	nHdl := FCreate(_cArqFil)
	fWrite(nHdl,_cExpres,Len(_cExpres))
	FClose(nHdl)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XFILC5F6 บAutor  ณMicrosiga           บ Data ณ  04/28/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpa o Filtro                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XFILC5F6
	Local oMbObj

	dbSelectArea( "SC5" )
	dbClearFilter()

	oMbObj := GetObjBrow()
   //	oMbObj:REFRESH()

	If File(_cArqFil)
		FErase(_cArqFil)
	EndIf

	_cExpres := ""

Return Nil
