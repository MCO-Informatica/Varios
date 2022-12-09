#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	CHKEXEC
// Autor 		Alexandre Dalpiaz
// Data 		08/06/2011
// Descricao  	PONTO DE ENTRADA AO CLICAR QUALQUER OPÇÃO DE MENU. VALIDA ENTRADA NA ROTINA.
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CHKEXEC()
///////////////////////

Local _cSecao 	:= "TCP"
Local _cChave 	:= "Port"
Local _nPadrao 	:= 0
Local _cServerIni, _cClientIni, _cPorta
Public _cEnter 	:= chr(13) + chr(10)
                                      
_aSons 			:= GetMv('LS_QTDBEEP')
_aSons 			:= &_aSons

For _nI := 2 to len(_aSons)
	If !File(__RelDir + _aSons[_nI])
		_cOrigem := 'G:\SONS\' + _aSons[_nI]
		_cDestino := __RelDir + _aSons[_nI]
		COPY FILE &_cOrigem to &_cDestino
	EndIf
Next

DbSelectArea('SM2')
_dData := date()+5
Do While !DbSeek(_dData)
	RecLock('SM2',.t.)
	SM2->M2_DATA := _dData--
	MsUnlock()
EndDo

DbSelectArea('Z10')
If !DbSeek(xFilial('Z10') + __cUserId,.f.)
	_aAllUsers := AllUsers()
	_nI := aScan(_aAllUsers, {|_1| Upper(AllTrim(_1[1,1])) == __cUserId })
	RecLock('Z10',.t.)
	Z10->Z10_CODUSR := __cUserId
	Z10->Z10_LOGIN  := cUserName
	Z10->Z10_NOME   := _aAllUsers[_nI,1,4]
	Z10->Z10_EMAIL  := lower(_aAllUsers[_nI,1,14])
	Z10->Z10_INCLU  := _aAllUsers[_nI,1,16]
	If empty(Z10->Z10_PRIMEI)
		Z10->Z10_PRIMEI := date()
	EndIf
	Z10->Z10_DEPTO  := _aAllUsers[_nI,1,12]
	Z10->Z10_CARGO  := _aAllUsers[_nI,1,13]
	Z10->Z10_ULTIMO := date()
	Z10->Z10_BLOQ   := iif(_aAllUsers[_nI,1,17],'S','N')
	For _nX := 1 to len(_aAllUsers[_nI,1,10])
		Z10->Z10_GRUPOS := alltrim(Z10->Z10_GRUPOS) + ', ' + _aAllUsers[_nI,1,10,_nX]
	Next
	
	If _aAllUsers[_nI,2,6,1] == '@@@@'
		_cLojas := '@@@@'
	Else
		_cLojas := ''
		_cEmp   := ''
		For _nJ := 1 to len(_aAllUsers[_nI,2,6])
			If left(_aAllUsers[_nI,2,6,_nJ],2) == _cEmp
				_cLojas += '.' + right(_aAllUsers[_nI,2,6,_nJ],2)
			Else
				_cLojas += ' /' + left(_aAllUsers[_nI,2,6,_nJ],2) + '-' + right(_aAllUsers[_nI,2,6,_nJ],2)
				_cEmp   := left(_aAllUsers[_nI,2,6,_nJ],2)
			EndIf
		Next
		_cLojas := substr(_cLojas,3)
	EndIf
	
	Z10->Z10_LOJAS  := _cLojas
	Z10->Z10_ACESSO := _aAllUsers[_nI,2,5]
	Z10->Z10_SPOOL  := __RelDir
	MsUnLock()
EndIf

_cServerIni := GetAdv97()
_cClientIni := GetRemoteIniName()

_cPorta := NToC(GetPvProfileInt(_cSecao, _cChave, _nPadrao, _cServerIni), 10)
_lRet   := .t.                        
/*
If (_cPorta $ '7990/7905')
	_lRet := .t.
Else
	_lRet := .t.
	If 'LS_MATA177' $ paramixb
		If !(_cPorta $ GetMv('LS_PORTACC')) .and. !__cUserId $ GetMv('LA_PODER')
			MsgBox('Utilizar rotina de Central de Compras somente na comunição do cliente CENTRAL (parâmetro SX6 LS_PORTACC)','ATENÇÃO!!!!','ALERT')
			_lRet := .f.
		EndIf
	Else
		If (_cPorta $ GetMv('LS_PORTACC')) .and. !__cUserId $ GetMv('LA_PODER')
			MsgBox('Utilizar esta rotina em comunição do cliente diferente de CENTRAL (parâmetro SX6 LS_PORTACC)','ATENÇÃO!!!!','ALERT')
			_lRet := .f.
		EndIf
	EndIf
EndIf
*/

If !('/'+ __cUserId + '/' $ GetMv('LA_PODER'))
	
	DbUseArea(.t.,,'\SYSTEM\MENSAGENS','REC',.T.,.F.);DbGoTop()
	
	DbGoTop()
	Do While !Eof()
		
		_hdatual := Dtos(Date()) + Left(Time(),5)
		
		If _hdatual >= DtoS(REC->DTAVISOFIM) + REC->HRAVISOFIM
			RecLock('REC',.F.)
			DbDelete()
			MsUnLock()
			DbSkip()
			Loop
			
		EndIf
		
		If _hdatual >= DtoS(REC->DTAVISOINI) + REC->HRAVISOINI .And. _hdatual <= DtoS(REC->DTAVISOFIM) + REC->HRAVISOFIM
			
			If REC->EMAIL // .And. !_lRecRH
				EmailAviso()
			Endif
			
			_cRecado := REC->RECADO + _cEnter
			_cRecado += 'HORÁRIO DE BLOQUEIO' + _cEnter
			_cRecado += 'INÍCIO :      '  + PadR(DtoC(REC->DTBLOQINI) + ' - ' + REC->HRBLOQINI, 20,'') + _cEnter
			_cRecado += 'TÉRMINO:  '  + PadR(DtoC(REC->DTBLOQFIM) + ' - ' + REC->HRBLOQFIM, 20,'')
			
			If _hdatual >= DtoS(REC->DTBLOQINI) + REC->HRBLOQINI .And. _hdatual <= DtoS(REC->DTBLOQFIM) + REC->HRBLOQFIM
				If !(AllTrim(cUserName) $ REC->AUTORIZADO)
					MsgInfo(_cRecado,'Mensagem do Administrador - Bloqueio Sistema!!!'+ _cRecado )
					QUIT
				EndIf
			Else
				MsgInfo(_cRecado,'Mensagem do Administrador - Bloqueio Sistema!!!'+ _cRecado)
			EndIf
			
		EndIf
		
		DbSkip()
		
	EndDo
	
	DbCloseArea()
	
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_WHEN(_xGrupos)
///////////////////////////////

Local _lRet    := .f.
Local _aGrupos := PswRet()[1,10]

For _nI := 1 to len(_aGrupos[1,10])
	If _aGrupos[_nI] $ _xGrupos + '/000000'
		_lRet := .t.
		Exit
	EndIf
Next

Return(_lRet)


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Desembaralha(_cUsuario)
/////////////////////////////////////
Local _aArea := GetArea()

_cRet := left(EMBARALHA(_cUsuario,1),15)

_cRet := alltrim(_cRet) + ' - ' + dtoc(iif(!empty(_cUsuario),ctod("01/01/96","DDMMYY") + Load2in4(Substr(_cUsuario,16)),ctod('')))

RestArea(_aArea)

Return(_cRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// determina a empresa a que pertence a filial
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Empresa(_cFil)
///////////////////////////////
Default _cFil := cFilAnt

If _cFil <= '99'
	_cRet := '01'
ElseIf _cFil $ 'BH/BI'
	_cRet := 'BH'
ElseIf _cFil >= 'A0' .and. _cFil <= 'AZ'
	_cRet := 'A0'
ElseIf _cFil >= 'C0' .and. _cFil <= 'EZ'
	_cRet := 'C0'
ElseIf _cFil >= 'G0' .and. _cFil <= 'GZ'
	_cRet := 'G0'
ElseIf _cFil >= 'P0' .and. _cFil <= 'PZ'
	_cRet := 'P0'
ElseIf _cFil >= 'R0' .and. _cFil <= 'RZ'
	_cRet := 'R0'
ElseIf _cFil >= 'T0' .and. _cFil <= 'TZ'
	_cRet := 'T0'
ElseIf _cFil >= 'V0' .and. _cFil <= 'VZ'
	_cRet := 'V0' 
ElseIf _cFil == 'K0'
	_cRet := 'K0'	
//ElseIf _cFil >= 'K0' .and. _cFil <= 'K0'
ElseIf _cFil $ 'K5/K6/K7/K8/K9/KA'
	_cRet := 'K0'
ElseIf _cFil == 'K1'
	_cRet := 'K1'
ElseIf _cFil == 'K2'
	_cRet := 'K2'  
	alert(_cRet)
ElseIf _cFil == 'K3'
	_cRet := 'K3'
ElseIf _cFil == 'K4'
	_cRet := 'K4'
EndIf

Return(_cRet)
