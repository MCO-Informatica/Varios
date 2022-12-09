#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QE215LL   ºAutor  ³Cayo Souza          º Data ³  01/18/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada que sugere o laudo do laboratorio.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI Conexoes Industriais Ltda.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function QE215LL()

Local _cEnsaioC	:=	GetMv("MV_HCIQIE1")
Local _cEnsaioMn:= 	GetMv("MV_HCIQIE2")
Local _cEnsaioCu:=	GetMv("MV_HCIQIE3")
Local _cEnsaioNi:= 	GetMv("MV_HCIQIE4")
Local _cEnsaioCr:= 	GetMv("MV_HCIQIE5")
Local _cEnsaioMo:= 	GetMv("MV_HCIQIE6")
Local _cEnsaioCE:= 	GetMv("MV_HCIQIE7")
Local _cEnsaioV	:=	GetMv("MV_HCIQIE8")
Local _cEnsaioNo:= 	GetMv("MV_HCIQIE9")
Local _cEnsaioSi:=	GetMv("MV_HCIQIEA")
Local _cEnsaioAl:=	GetMv("MV_HCIQIEB")
Local _cRegra01	:= 	QE6->QE6_XREG01
Local _cRegra02	:= 	QE6->QE6_XREG02
Local _cRegra03	:= 	QE6->QE6_XREG03
Local _cRegra04	:= 	QE6->QE6_XREG04
Local _cRegra05	:= 	QE6->QE6_XREG05
Local _cRegra06	:= 	QE6->QE6_XREG06
Local _cRegra07	:= 	QE6->QE6_XREG07
Local _cRegra08	:= 	QE6->QE6_XREG08
Local _cRegra09	:= 	QE6->QE6_XREG09
Local _cRegra10	:=	QE6->QE6_XREG10
Local _cRegra11	:=	QE6->QE6_XREG11
Local _cRegra12	:= 	QE6->QE6_XREG12
Local _aEnsaios	:=	aClone(aResultado[nFldLab][2])
Local _aMedicao	:=	aClone(aResultado[nFldLab][4])
Local _nTotal	:=	0
Local _lret		:=	.F.

DbSelectArea("QE7")
DbSetOrder(1)	//QE7_FILIAL+QE7_PRODUT+QE7_REVI+QE7_ENSAIO

//Analisa Regra01
If _cRegra01 = "S"
	_nTotal:=0
	_lRetMn	:= .F.
	_lRetC	:= .F.
	For i:=1 to Len(_aEnsaios)
		If (AllTrim(_aEnsaios[i][2]) == _cEnsaioC)
			If QE7->(DbSeek(xFilial("QE7")+QE6->QE6_PRODUT+QE6->QE6_REVI+_cEnsaioC))
				iF SuperVal(_aMedicao[i][1][7]) < SuperVal(QE7->QE7_LSE)
					_cDifC	:= SuperVal(QE7->QE7_LSE) - SuperVal(_aMedicao[i][1][7])
					If QE7->(DbSeek(xFilial("QE7")+QE6->QE6_PRODUT+QE6->QE6_REVI+_cEnsaioMn))
						_cMn	:= (_cDifC*0.06*100)+SuperVal(QE7->QE7_LSE)
						_lRetC:= .T.
					EndIf
				EndIf
			EndIf
		EndIF
		If (AllTrim(_aEnsaios[i][2]) == _cEnsaioMn) 
			_cValorMn	:= SuperVal(_aMedicao[i][1][7])
			_lRetMn:= .T.
		EndIf
	Next
	If _lRetMn .and. _lRetC
		If (_cValorMn > _cMn) .or. (_cMn > QE6->QE6_XVLR01)
			MsgAlert("Os limites de Mn% e C% estão divirgentes da Regra01")
			M->QEL_LAUDO :=  "F"
			_lRet:=.T.
		EndIf
	EndIf
EndIf
		
//Analisa Regra02
If _cRegra02 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	For i:=1 to Len(_aEnsaios)
		If ((AllTrim(_aEnsaios[i][2]) == _cEnsaioCu) .or. (AllTrim(_aEnsaios[i][2]) == _cEnsaioNi) .or. ;
		(AllTrim(_aEnsaios[i][2]) == _cEnsaioCr) .or. (AllTrim(_aEnsaios[i][2]) == _cEnsaioMo))
			_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
			_lRegra := .T.
		EndIf
	Next
	If _nTotal > 1 .and. _lRegra
		MsgAlert("A soma de Cu% + Ni% + Cr% + Mo% NÃO pode ultrapassar 1%...Regra02")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra03
If _cRegra03 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	For i:=1 to Len(_aEnsaios)
		If (AllTrim(_aEnsaios[i][2]) == _cEnsaioCr) .or. (AllTrim(_aEnsaios[i][2]) == _cEnsaioMo)
			_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
			_lRegra	:= .T.
		EndIf
	Next
	If _nTotal > 1 .and. _lRegra
		MsgAlert("A soma de Cr% + Mo% NÃO pode ultrapassar 0,32%...Regra03")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf                
EndIf

//Analisa Regra04
If _cRegra04 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	For i:=1 to Len(_aEnsaios)
		If AllTrim(_aEnsaios[i][2]) == _cEnsaioCE
			_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
			_lRegra	:= .T.
		EndIf
	Next
	If (_nTotal > QE6->QE6_XVLR04) .and. _lRegra
		MsgAlert("O campo CE% é de preenchimento obrigatório. Valor Máx = "+ AllTrim(Str(QE6->QE6_XVLR04))+"%...Regra 04.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf                
EndIf

//Analisa Regra05
If _cRegra05 = "S"
	_nTotal:=0
	_lRegra:=.F.
	For i:=1 to Len(_aEnsaios)
		If ((AllTrim(_aEnsaios[i][2]) == _cEnsaioCu) .or. (AllTrim(_aEnsaios[i][2]) == _cEnsaioNi) .or.;
			(AllTrim(_aEnsaios[i][2]) == _cEnsaioCr) .or. (AllTrim(_aEnsaios[i][2]) == _cEnsaioV) .or. (AllTrim(_aEnsaios[i][2]) == _cEnsaioMo))
			_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
			_lRegra:=.T.
		EndIf
	Next
	If _nTotal > 1 .and. _lRegra
		MsgAlert("A soma de Cu% + Ni% + Cr% + V% + Mo% NÃO pode ultrapassar 1%...Regra05.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra06
If _cRegra06 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	For i:=1 to Len(_aEnsaios)
		If (AllTrim(_aEnsaios[i][2]) == _cEnsaioC)
			_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
			_lRegra	:= .T.
		EndIf
	Next
	If (_nTotal > 0.35 ) .and. (QE6->QE6_XMP02 = "S") .and. _lRegra
		MsgAlert("O campo C% é de preenchimento obrigatório. Valor máx = 0,35%...Regra 06.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra07
If _cRegra07 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	For i:=1 to Len(_aEnsaios)
		If (AllTrim(_aEnsaios[i][2]) == _cEnsaioSi)
			_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
			_lRegra	:= .T.
		EndIf
	Next
	If (_nTotal > 0.35 .and. QE6->QE6_XMP01 = "S") .and. _lRegra
		MsgAlert("O campo Si% é de preenchimento obrigatório. Valor máx = 0,35%...Regra 07.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra08
If _cRegra08 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	For i:=1 to Len(_aEnsaios)
		If (AllTrim(_aEnsaios[i][2]) == _cEnsaioMn)
			_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
			_lRegra	:= .T.
		EndIf
	Next
	If (_nTotal > 1.35 .and. QE6->QE6_XMP01 = "S") .and. _lRegra
		MsgAlert("O campo Mn% é de preenchimento obrigatório. Valor máx = 1,35%...Regra 08.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra09
If _cRegra09 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	If QE6->QE6_XCP01 = "S" .AND. (QE6->QE6_XCP06 = "S" .OR. QE6->QE6_XCP07 = "S")
		For i:=1 to Len(_aEnsaios)
			If (AllTrim(_aEnsaios[i][2]) == _cEnsaioAl)
				_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
				_lRegra	:= .T.
			EndIf
		Next
	EndIf
	If (_nTotal < QE6->QE6_XVLR09 ) .and. _lRegra
		MsgAlert("O campo Along.Mínimo é de preenchimento obrigatório. Valor min = "+ AllTrim(Str(QE6->QE6_XVLR09))+"%...Regra 09.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra10
If _cRegra10 = "S"
	_nTotal:=0
	_lRegra	:= .F.	
	If QE6->QE6_XCP01 = "S" .AND. QE6->QE6_XCP04 = "S"
		For i:=1 to Len(_aEnsaios)
			If (AllTrim(_aEnsaios[i][2]) == _cEnsaioAl)
				_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
				_lRegra	:= .T.
			EndIf
		Next
	EndIf
	If (_nTotal < QE6->QE6_XVLR10 ) .and. _lRegra
		MsgAlert("O campo Along.Mínimo é de preenchimento obrigatório. Valor min = "+ AllTrim(Str(QE6->QE6_XVLR10))+"%...Regra 10.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra11
If _cRegra11 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	If QE6->QE6_XCP02 = "S" .AND. (QE6->QE6_XCP06 = "S" .OR. QE6->QE6_XCP07 = "S")
		For i:=1 to Len(_aEnsaios)
			If (AllTrim(_aEnsaios[i][2]) == _cEnsaioAl)
				_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
				_lRegra	:= .T.
			EndIf
		Next
	EndIf
	If (_nTotal < QE6->QE6_XVLR11 ) .and. _lRegra
		MsgAlert("O campo Along.Mínimo é de preenchimento obrigatório. Valor min = "+ AllTrim(Str(QE6->QE6_XVLR11))+"%...Regra 11.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

//Analisa Regra12
If _cRegra12 = "S"
	_nTotal:=0
	_lRegra	:= .F.
	If QE6->QE6_XCP02 = "S" .AND. QE6->QE6_XCP04 = "S"
		For i:=1 to Len(_aEnsaios)
			If (AllTrim(_aEnsaios[i][2]) == _cEnsaioAl)
				_nTotal	:= (_nTotal+SuperVal(_aMedicao[i][1][7]))
				_lRegra	:= .T.
			EndIf
		Next
	EndIf
	If (_nTotal < QE6->QE6_XVLR12 ) .and. _lRegra
		MsgAlert("O campo Along.Mínimo é de preenchimento obrigatório. Valor min = "+ AllTrim(Str(QE6->QE6_XVLR12))+"%...Regra 12.")
		M->QEL_LAUDO :=  "F"
		_lRet:=.T.
	EndIf
EndIf

If !(_lRet)
	q215CalLab()
EndIf
Return ()