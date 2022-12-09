#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER CHR(13)+CHR(10)

// Programa.: LS_LOGUSER
// Autor....: Alexandre Dalpiaz
// Data.....: 27/09/10
// Descrição: RELATORIO DE LOG DE USUÁRIO
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_LOGUSER()
/////////////////////////

_cPerg         := left("LOGUSER    ",len(SX1->X1_GRUPO))
ValidPerg()
If !Pergunte(_cPerg, .t.)
	Return()
EndIf

_nHdl := fCreate('c:\spool\loguser.csv')
If _nHdl < 0
	MsgBox('Não foi possível criar o arquivo C:\SPOOL\LOGUSER.CSV','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSelectArea('SX3')
DbSetOrder(2)

MV_PAR01 := upper(alltrim(MV_PAR01) + alltrim(MV_PAR02))
MV_PAR02 := upper(MV_PAR03)
MV_PAR03 := upper(MV_PAR04)
MV_PAR04 := upper(MV_PAR05)
MV_PAR05 := upper(MV_PAR06)
MV_PAR06 := upper(MV_PAR07)
MV_PAR07 := upper(MV_PAR08)

_cCampo 	:= If ( left(MV_PAR02, 1) == "S", Subs(MV_PAR02,2,2) + "_USERLGI", left(MV_PAR02,3) + "_USERGI" )

If !DbSeek(_cCampo,.f.)
	MsgBox('Tabela não possui controle de log de usuário','ATENÇÃO','ALERT')
	DbSetOrder(1)
	Return()
EndIf
_cCampos := alltrim(upper(mv_par01))
_cCabec1 := ''
_aDatas  := {}
Do While len(_cCampos) > 0
	_nPosic := at(',',_cCampos)
	If _nPosic == 0
		_cCampo := _cCampos
		_cCampos := ''
	Else
		_cCampo := alltrim(left(_cCampos,_nPosic-1))
		_cCampos := alltrim(substr(_cCampos,_nPosic+1))
	EndIf
	
	If !DbSeek(_cCampo,.f.) .or. SX3->X3_CONTEXT == 'V' .or. !(SX3->X3_ARQUIVO $ MV_PAR02)
		MsgBox('Campo ' + _cCampo + ' não existe nas tabelas selecionadas','ATENÇÃO','ALERT')
		Return()
	Else
		_cCabec1 += SX3->X3_TITULO + ';'
		If SX3->X3_TIPO == 'D'
			aAdd(_aDatas,_cCampo)
		EndIf
	EndIf
EndDo

DbSetOrder(1)

_cTabelas := ''
_aCampos := {}                             
_cControles := ''
For _nI := 1 to len(alltrim(MV_PAR02)) step 4
	                                                                     
	_cCampoI := iif( left(substr(MV_PAR02,_nI,3), 1) == "S", Subs(substr(MV_PAR02,_nI,3),2,2) + "_USERLGI", left(MV_PAR02,3) + "_USERGI" )
	_cCampoA := iif( left(substr(MV_PAR02,_nI,3), 1) == "S", Subs(substr(MV_PAR02,_nI,3),2,2) + "_USERLGA", left(MV_PAR02,3) + "_USERGA" )
	
	aAdd(_aCampos,{substr(MV_PAR02,_nI,3), substr(MV_PAR02,_nI,3) + '_RECNO', _cCampoI, _cCampoA})
	
	_cTabelas += RetSqlName(substr(MV_PAR02,_nI,3)) + ' ' + substr(MV_PAR02,_nI,3) + ' (NOLOCK), '
	_cControles += ', ' + substr(MV_PAR02,_nI,3) + '.R_E_C_N_O_ ' + substr(MV_PAR02,_nI,3) + '_RECNO, ' + substr(MV_PAR02,_nI,3) + '.D_E_L_E_T_ ' + substr(MV_PAR02,_nI,3) + '_DELETE'
	_cCabec1 += substr(MV_PAR02,_nI,3) + '_RECNO; ' + substr(MV_PAR02,_nI,3) + '_DELETE;' + substr(MV_PAR02,_nI,3)+'_UserInc;' + substr(MV_PAR02,_nI,3) + '_DataInc;' + substr(MV_PAR02,_nI,3)+'_UserAlt;' + substr(MV_PAR02,_nI,3) + '_DataAlt;'
Next

*********************************************************
_cCabec1 +=  '(Obs: alteracao tambem pode ser exclusao)' + _cEnter

_cTabelas := left(_cTabelas,len(_cTabelas)-2)

_cQuery := "SELECT " + alltrim(MV_PAR01)+ _cControles
_cQuery += _cEnter + " FROM " + _cTabelas
_cQuery += _cEnter + " WHERE " + alltrim(MV_PAR03)
If !empty(MV_PAR04)
	_cQuery += _cEnter + alltrim(MV_PAR04)
EndIf
If !empty(MV_PAR05)
	_cQuery += _cEnter + alltrim(MV_PAR05)
EndIf
If !empty(MV_PAR06)
	_cQuery += _cEnter + alltrim(MV_PAR06)
EndIf
If !empty(MV_PAR07)
	_cQuery += _cEnter + alltrim(MV_PAR07)
EndIf
If !empty(MV_PAR08)
	_cQuery += _cEnter + alltrim(MV_PAR08)
EndIf
_cQuery += _cEnter + " ORDER BY " + alltrim(MV_PAR01)

_cQuery := strtran(_cQuery,'DBO','dbo')
MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP', .F., .T.)},'Buscando informações')

For _nI := 1 to len(_aDatas)
	TcSetField("TMP",_aDatas[_nI],"D",8,0)
Next

If eof()
	DbCloseArea()
	fClose(_nHdl)
	MsgBox('Arquivo C:\SPOOL\LOGUSER.CSV sem dados para consulta','ATENÇÃO!!!','ALERT')
	Return()
EndIf
fWrite(_nHdl,_cCabec1,Len(_cCabec1))

Processa({|| RunProc()})

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////
Count to _nLastRec
DbGoTop()
ProcRegua(_nLastRec)
Do While !eof()
	
	IncProc()
	_cLinha    := ''
	_nCampos   := fCount()
	For _nI := 1 to _nCampos
		
		If ValType(FieldGet(_nI)) == 'N'
			_cLinha += tran(FieldGet(_nI),'@E 999,999,999.99') + ';'
		ElseIf ValType(FieldGet(_nI)) == 'D'
			_cLinha += dtoc(FieldGet(_nI)) + ';'
		ElseIf 'DELETE' $ FieldName(_nI)
			_cLinha += iif(FieldGet(_nI) == '*','DELETADO','') + ';'
		Else
			_cLinha += FieldGet(_nI) + ';'
		EndIf
	Next                                                                                             

	For _nI := 1 to len(_aCampos)
	    DbSelectArea(_aCampos[_nI,1])
	    DbGoTo(&('TMP->' + _aCampos[_nI,2]))
		_cUsuarioI  := FWLeUserlg(_aCampos[_nI,3],1)
		_cDataI	    := FWLeUserlg(_aCampos[_nI,3],2)
		_cUsuarioA  := FWLeUserlg(_aCampos[_nI,4],1)
		_cDataA	    := FWLeUserlg(_aCampos[_nI,4],2)
		_cLinha += _cUsuarioI + ';' + _cDataI + ';' + _cUsuarioA + ';' + _cDataA
	Next	                                                                    
	
	_cLinha += _cEnter
	
	fWrite(_nHdl,_cLinha,Len(_cLinha))
	DbSelectArea('TMP')
	DbSkip()
	
EndDo
DbCloseArea()

fClose(_nHdl)

MsgBox('Arquivo C:\SPOOL\LOGUSER.CSV criado com sucesso. Utilizar o EXEL para consultar','ATENÇÃO!!!','ALERT')
ShellExecute("open", "EXCEL" , "C:\SPOOL\LOGUSER.CSV" ,"", 1 )

Return()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg ()
////////////////////////////
Private _cAlias := Alias ()
Private _aRegs  := {}

//           GRUPO  ORDEM PERGUNT                 PERSPA                  PERENG                  VARIAVL   TIPO TAM DEC PRESEL GSC  VALID VAR01       DEF01       DEFSPA1     DEFENG1     CNT01 VAR02 DEF02        DEFSPA2      DEFENG2      CNT02 VAR03 DEF03       DEFSPA3     DEFENG3     CNT03 VAR04 DEF04 DEFSPA4 DEFENG4 CNT04 VAR05 DEF05 DEFSPA5 DEFENG5 CNT05 F3     GRPSXG
aAdd(_aRegs,{_cPerg, "01", "Campos a listar 1    ","","","mv_ch1", "C",60,  0,  0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "02", "Campos a listar 2    ","","","mv_ch2", "C",60,  0,  0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "03", "Tabelas              ","","","mv_ch3", "C",60,  0,  0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "04", "Query1               ","","","mv_ch4", "C",60,  0,  0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "05", "Query2               ","","","mv_ch5", "C",60,  0,  0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "06", "Query3               ","","","mv_ch6", "C",60,  0,  0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "07", "Query4               ","","","mv_ch7", "C",60,  0,  0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd(_aRegs,{_cPerg, "08", "Query5               ","","","mv_ch8", "C",60,  0,  0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea ("SX1")
DbSetOrder (1)
For _i := 1 to Len (_aRegs)
	RecLock ("SX1", !DbSeek (_cPerg + _aRegs [_i, 2]))
	For _j := 1 to FCount ()
		If _j <= Len (_aRegs [_i]) .and. !(left (fieldname (_j), 6) $ "X1_CNT/X1_PRESEL")
			FieldPut (_j, _aRegs [_i, _j])
		Endif
	Next
	MsUnlock ()
Next
DbSelectArea (_cAlias)
Return