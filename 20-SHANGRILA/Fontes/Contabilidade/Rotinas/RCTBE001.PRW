#Include "Totvs.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

User Function RCTBE001()

//	RPCSetType( 3 )						// Não consome licensa de uso
//	Prepare Environment Empresa "01" Filial "01"
//	dDataBase := Date()
	If Alltrim(CTS->CTS_CONTAG) >= "05" .and. Alltrim(CTS->CTS_CONTAG) <= "29"
		_nValProd := MovConta("511010001",FirstDay(FirstDate(mv_par01,1)),LastDay(LastDate(mv_par02,1)),"01","1",3,0,1,MV_PAR02)
		_nValServ := MovConta("511010003",FirstDay(FirstDate(mv_par01,1)),LastDay(LastDate(mv_par02,1)),"01","1",3,0,1,MV_PAR02)
		_nTotal := _nValProd + _nValServ
		Return _nValProd/_nTotal
	ElseIf Alltrim(CTS->CTS_CONTAG) >= "40" .and. Alltrim(CTS->CTS_CONTAG) <= "64"
		_nValProd := MovConta("511010001",FirstDay(FirstDate(mv_par01,1)),LastDay(LastDate(mv_par02,1)),"01","1",3,0,1,MV_PAR02)
		_nValServ := MovConta("511010003",FirstDay(FirstDate(mv_par01,1)),LastDay(LastDate(mv_par02,1)),"01","1",3,0,1,MV_PAR02)
		_nTotal := _nValProd + _nValServ
		Return _nValServ/_nTotal
	EndIf
Return 1
