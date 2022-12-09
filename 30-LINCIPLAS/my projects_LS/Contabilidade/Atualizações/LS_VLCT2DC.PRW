#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

// Programa.: LS_VLCT2DC
// Autor....: Alexandre Dalpiaz
// Data.....: 27/01/2012
// Descrição: VALIDAÇAO DO CAMPO CT2_DC - QUANDO FOR 7, DELETA TODAS AS LINHAS DO LANÇAMENTO E DESMARCA O CAMPO F1_DTLANC / F2_DTLANC  / L5_LA

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function ls_vlct2dc()
//////////////////////////

If M->CT2_DC == '7'
	DbSelectArea('TMP')
	_nRecno := Recno()
	DbGoTop()
	Do While !eof()
		RecLock('TMP',.f.)
		TMP->CT2_FLAG    := .t.
		MsUnLock()
		DbSkip()
	EndDo
	DbGoTo(_nRecno)
	
	If FunName() == 'CTBANFS'
		RecLock('SF2',.f.)
		SF2->F2_DTLANC := ctod('')
		MsUnLock()
	ElseIf FunName() == 'CTBANFE'
		RecLock('SF1',.f.)
		SF1->F1_DTLANC := ctod('')
		MsUnLock()
	ElseIf FunName() == 'FINA370'
		RecLock('SE5',.f.)
		SE5->E5_LA := ''
		MsUnLock()
	EndIf
	
Else
	
	DbSelectArea('TMP')
	_nRecno := Recno()
	DbGoTop()
	Do While !eof()
		RecLock('TMP',.f.)
		TMP->CT2_FLAG    := .f.
		MsUnLock()
		DbSkip()
	EndDo
	DbGoTo(_nRecno)
	
	If FunName() == 'CTBANFS'
		RecLock('SF2',.f.)
		SF2->F2_DTLANC := SF2->F2_EMISSAO
		MsUnLock()
	ElseIf FunName() == 'CTBANFE'
		RecLock('SF1',.f.)
		SF1->F1_DTLANC := SF1->F1_DTDIGIT
		MsUnLock()
	ElseIf FunName() == 'FINA370'
		RecLock('SE5',.f.)
		SE5->E5_LA := 'S'
		MsUnLock()
	EndIf
	
EndIf
DbSelectArea('TMP')

Return(.t.)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PONTO DE ENTRADA QPARA DESMARCAR UMA NOTA QUE NÃO QUEREMOS CONTABILIZAR.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function DEPCTBGRV()
/////////////////////////

DbSelectArea('CT2')
DbSetOrder(1)
If !DbSeek(cFilAnt + dtos(dDataLanc) + cLote + cSubLote + cDoc,.F.)
	If FunName() == 'CTBANFS'
		RecLock('SF2',.f.)
		SF2->F2_DTLANC := ctod('')
		MsUnLock()
	ElseIf FunName() == 'CTBANFE'
		RecLock('SF1',.f.)
		SF1->F1_DTLANC := ctod('')
		MsUnLock()
	ElseIf FunName() == 'FINA370'
		RecLock('SE5',.f.)
		SE5->E5_LA := ''
		MsUnLock()
	EndIf
EndIf
Return()


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GATILHOS DA CT2 PARA ALTERAR CT2_OIRIGEM,
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function GatCT2(_cCampo,_nPosic)
///////////////////////////////////////
_lRet := .t.
If Type('_aTMP') == 'A'
	If val(TMP->CT2_LINHA) <= len(_aTMP)
		If _aTMP[val(TMP->CT2_LINHA),_nPosic] == _cCampo
			_lRet := .f.
		EndIf    
	Else
		_lRet := .f.
	EndIf
Else
	/*
	DbSelectArea('CT2')
	DbSetOrder(1)
	_cvar := substr(READVAR(),4)
	DbSeek(cFilant + dtos(dDataLanc) + cLote + cSubLote + cDoc + TMP->CT2_LINHA,_cVar)
	*/
	_xVar := Posicione('CT2',1,cFilant + dtos(dDataLanc) + cLote + cSubLote + cDoc + TMP->CT2_LINHA,substr(READVAR(),4)) 
	If _xVar == _cCampo .or. empty(_xVar)
		_lRet := .f.
	EndIf
EndIf

Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ponto de entrada para criar o vetor Publico _aTMP para usar com o gatilho GATCT2
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CTBPRXDOC()
/////////////////////////

cQuery := "SELECT Max(CTF_DOC) MAXDOC "
cQuery += "FROM " + RetSqlName("CTF") + " CTF (NOLOCK)"
cQuery += "WHERE CTF_FILIAL = '" + xFilial("CTF") + "' AND "
cQuery += "CTF_DATA = '" + DTOS(dDataLanc) + "' AND "
cQuery += "CTF_LOTE = '" + cLote + "' AND "
cQuery += "CTF_SBLOTE = '" + cSubLote + "' AND "
cQuery += "D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPPRXDOC")
cDoc := TMPPRXDOC->MAXDOC
DbCloseArea()

Public _aTMP := {}
If Select('TMP') > 0
	DbSelectArea('TMP')
	DbGoTop()
	
	Do While !eof()
		aAdd(_aTMP,{TMP->CT2_DEBITO, TMP->CT2_CREDIT, TMP->CT2_VALOR, CT2_HIST})
		DbSkip()
	EndDo
EndIf

dbSelectArea("CTF")

If Empty(cDoc)
	cDoc := "000001"
Else
	cDoc := StrZero(Val(cDoc)+1,6)
EndIf

Return(cDoc)
