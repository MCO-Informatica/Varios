#include "rwmake.ch"

// 	Programa:	ls_profile
//	Autor:		Alexandre Dalpiaz
//	Data:		28/11/04
//	Uso:		Laselva
//	Funcao:		preenche o grupo de perguntas do usuario

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Profile(_cProg, _aMv_par)
//////////////////////////////////////////
local _nI, _aAlias, _aPergs, _cMemo

_aAlias := GetArea()

If FindProfDef (cUserName, _cProg, "PERGUNTE", "MV_PAR")
	
	_cMemo := RetProfDef(cUserName, _cProg, "PERGUNTE", "MV_PAR")
	_aLinhas := {}
	For _nI := 1 to mlcount(_cMemo)
		aadd (_aLinhas, alltrim (MemoLine (_cMemo,, _nI)))
	Next
	
	_aPergs := {}
	
	DbSelectArea('SX1')
	DbSeek(_cProg)
	For _nI := 1 to len(_aMv_par)
		aAdd(_aPergs, iif(_aMv_par[_nI] == '!@!',_aLinhas[_nI] , SX1->X1_TIPO + '#' + SX1->X1_GSC + '#' + _aMv_par[_nI]))
		DbSkip()
	Next
	
	_cMemo := ''
	For _nI := 1 to len(_aPergs) -1
		_cMemo += _aPergs[_nI] + chr(13) + chr(10)
	Next
	_cMemo += _aPergs[_nI]
	
	WriteProfDef(cUserName, _cProg, "PERGUNTE", "MV_PAR", ;  // Chave antiga
	cUserName, _cProg, "PERGUNTE", "MV_PAR", ;  // Chave nova
	_cMemo)  // Novo conteudo do memo.
	
ElseIf .f.
	
	DbSelectArea('SX1')
	
	_aPergs := {}
	
	For _nI := 1 to len(_aMv_par)
		If DbSeek(cPerg + strzero(_nI,2),.f.)
			RecLock('SX1',.f.)
			SX1->X1_CNT01 := tran(_aMv_par[_nI],'')
			MsUnLock()
			aAdd(_aPergs, iif(_aMv_par[_nI] == '!@!',_aLinhas[_nI] , SX1->X1_TIPO + '#' + SX1->X1_GSC + '#' + _aMv_par[_nI]))
		EndIf
	Next
	
	_cMemo := ''
	For _nI := 1 to len(_aPergs) -1
		_cMemo += _aPergs[_nI] + chr(13) + chr(10)
	Next
	_cMemo += _aPergs[_nI]

	WriteProfDef(cUserName, _cProg, "PERGUNTE", "MV_PAR", ;  // Chave antiga
	cUserName, _cProg, "PERGUNTE", "MV_PAR", ;  // Chave nova
	_cMemo)  // Novo conteudo do memo.

EndIf

RestArea(_aAlias)
Return()


