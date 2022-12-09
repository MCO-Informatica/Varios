#INCLUDE 'RWMAKE.CH'

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa	: FM_Z01
// Autor	: Alexandre Dalpiaz
// Data		: 23/05/08
// Função	: Acesso de usuários a parametros no SX6
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Z01()
//////////////////////

Local cVldAlt := ".T."
Local cVldExc := ".T."

U_LS_SX6()
If !(__cUserId $ GetMv('LA_PODER'))
	Return()
EndIf

Private cString := "Z01"

dbSelectArea("Z01")

_aGrupos := UsrRetGrp(cUserName)

If !(__cUserId $ GetMv('LA_PODER'))
	set filter to __cUserID $ Z01_AUTORI
EndIf

dbSetOrder(1)

AxCadastro(cString,"Cadastro de permissão de usuários x parâmetros (SX6)",cVldExc,cVldAlt)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Z01_User()
/////////////////////////
Local _cNome   := iif(Type('M->Z01_AUTORI') == 'C' .and. !empty(M->Z01_AUTORI), M->Z01_AUTORI, Z01->Z01_AUTORI)
Local _cQuebra := iif(Type('M->Z01_AUTORI') == 'C' .and. !empty(M->Z01_AUTORI), _cEnter,', ')
Local _cNomes  := ''
For _nI := 1 to len(alltrim(_cNome)) step 7
	_cNomes += alltrim(UsrRetName(substr(_cNome,_nI,6))) + _cQuebra
Next
Return(_cNomes)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SX6()
//////////////////////

DbSelectArea('Z01')

_aHeader := {}
aAdd(_aHeader, {"Filial"	,	"X6_FILIAL"	,	""		,	002 ,  0 ,  ".f." , " ",  "C",  "" } )
aAdd(_aHeader, {"Conteudo"	,	"X6_CONTEUD",	"@S50"	,	250 ,  0 ,  ""    , " ",  "C",  "" } )
aAdd(_aHeader, {"Parâmetro"	,	"X6_VAR"	,	"@!"	,	010 ,  0 ,  ".f." , " ",  "C",  "" } )
aAdd(_aHeader, {"Tipo"		,	"X6_TIPO"	,	"!"		,	001 ,  0 ,  ".f." , " ",  "C",  "" } )
aAdd(_aHeader, {"Descrição"	,	"X6_DESCRIC",	""	,	150 ,  0 ,  ".f." , " ",  "C",  "" } )

_cQuery := "SELECT *"
_cQuery += " FROM " + RetSqlName('Z01') + " Z01 (nolock)"
If !(__cUserId $ GetMv('LA_PODER'))
	_cQuery += " WHERE Z01_AUTORI LIKE '%" + __cUserID + "%'"
EndIf	

DbUseArea(.t.,'TOPCONN',TcGenQry(,,_cQuery),'_Z01',.f.,.f.)

DbGoTop()
_aCols := {}
Do While !eof()
	
	DbSelectArea('SX6')
	If DbSeek('  ' + _Z01->Z01_PARAM,.f.)
		aAdd(_aCols,{X6_FIL, SX6->X6_CONTEUD,SX6->X6_VAR, SX6->X6_TIPO, SX6->X6_DESCRIC+SX6->X6_DESC1+SX6->X6_DESC2,.f.})
	EndIf
	
	DbSelectArea('SM0')
	DbSeek(cEmpAnt,.f.)
	Do While !eof()	.and. SM0->M0_CODIGO == cEmpAnt
		DbSelectArea('SX6')
		If DbSeek(SM0->M0_CODFIL + _Z01->Z01_PARAM,.F.)
			aAdd(_aCols,{SX6->X6_FIL, SX6->X6_CONTEUD,SX6->X6_VAR, SX6->X6_TIPO, SX6->X6_DESCRIC+SX6->X6_DESC1+SX6->X6_DESC2,.f.})
		EndIf
		DbSelectArea('SM0')
		DbSkip()
	EndDo
		
	DbSelectArea('_Z01')
	DbSkip()
	
EndDo

__aCols := aClone(_aCols)

DbCloseArea()

maxgetdad 	:= len(_aCols)
_lOk 		:= .f.
_nAltura 	:= oMainWnd:nClientHeight - 200
_nLargura 	:= oMainWnd:nClientWidth - 50

@ 000,000 TO _nAltura   ,_nLargura DIALOG _oDlg2 TITLE "Parâmetros"
_oGetDados := MsNewGetDados():New(010,010,_nAltura/2-050 ,_nLargura/2-10,GD_UPDATE,,,,,,MAXGETDAD,,,,_oDlg2,_aHeader,_aCols)

_cUsuário := '      '
@ int(_nAltura/2)-40,010 say 'Usuários:'
@ int(_nAltura/2)-40,050 get _cUsuário F3 'USR'
@ int(_nAltura/2)-40,(_nLargura/2) - 150 BmpButton Type 01 Action (_PutMv(),_oDlg2:End())
@ int(_nAltura/2)-40,(_nLargura/2) - 100 BmpButton Type 02 Action (_oDlg2:End())
Activate Dialog _oDlg2 Centered

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _PutMv()
////////////////////////

_aCols := aClone(_oGetDados:aCols)

DbSelectArea('SX6')
For _nI := 1 to len(_aCols)
	
	If _aCols[_nI,2] <> __aCols[_nI,2]
		If DbSeek(_aCols[_nI,1] + _aCols[_nI,3],.f.)
			RecLock('SX6',.f.)
			SX6->X6_CONTEUD := _aCols[_nI,2]
			SX6->X6_CONTSPA := _aCols[_nI,2]
			SX6->X6_CONTENG := _aCols[_nI,2]
			MsUnLock()
		EndIf
	EndIf
	
Next

Return()
