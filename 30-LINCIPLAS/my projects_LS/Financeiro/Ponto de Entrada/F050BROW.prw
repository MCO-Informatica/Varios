#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F050BROW º Autor ³Antonio Carlos          º Data ³  24/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Filtro do Browse no Contas a Pagar    	              		   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva S/A                     				      		   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F050BROW()

Local aInd		:= {}
U_LS_MATRIZ()

Public _cFilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'" // ALTERADO POR alexandre em 29/7/2011
ALERT(_cFilBrow)
If FunName() $ 'FINA750/FINA050'
//	aAdd( aRotina,	{ 'Desdobramento' , 'U_LS_DESDOB()'	, 0 , 2})
	//aAdd( aRotina,	{ 'Filtro'        , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})
	
	DbSelectArea('SE2')
	Set Filter to &_cFilBrow
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Baixas Rec manual
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F070BROW()
////////////////////////           
U_LS_MATRIZ()
Public _cFilBrow := "E1_MATRIZ == '" + cFilAnt + "'" // ALTERADO POR alexandre em 29/7/2011

DbSelectArea('SE1')
set filter to &_cFilBrow

//aAdd( aRotina,	{ 'Filtro' , 'U_LS_FILTRO("SE1",_cFilBrow)'	, 0 , 2})

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Baixas Rec Automatica
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F110BROW()
////////////////////////
U_LS_MATRIZ()
Public _cFilBrow := "E1_MATRIZ == '" + cFilAnt + "'" // ALTERADO POR alexandre em 29/7/2011

DbSelectArea('SE1')
set filter to &_cFilBrow

//aAdd( aRotina,	{ 'Filtro' , 'U_LS_FILTRO("SE1",_cFilBrow)'	, 0 , 2})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Manutencao Bordero
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F590REC()
////////////////////////
U_LS_MATRIZ()
Public _cFilBrow := "E1_MATRIZ == '" + cFilAnt + "'" // ALTERADO POR alexandre em 29/7/2011

DbSelectArea('SE1')
set filter to &_cFilBrow

//aAdd( aRotina,	{ 'Filtro' , 'U_LS_FILTRO("SE1",_cFilBrow)'	, 0 , 2})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Compensacao Contas a receber
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F330FLT()
////////////////////////
U_LS_MATRIZ()
Public _cFilBrow := "E1_MATRIZ == '" + cFilAnt + "'" // ALTERADO POR alexandre em 29/7/2011

DbSelectArea('SE1')
set filter to &_cFilBrow

//aAdd( aRotina,	{ 'Filtro' , 'U_LS_FILTRO("SE1",_cFilBrow)'	, 0 , 2})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Desdobramento de títulos
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_DESDOB()
//////////////////////////
_aArea := GetArea()  
If 'MAT' $ FunName()
	DbSelectArea('SE2')  
	DbSetOrder(6)
	If !DbSeek(xFilial('SE2') + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC,.f.)
		MsgBox('Título não localizado','ATENÇÃO!!!','ALERT')
		RestArea(_aArea)
		Return()
	EndIf
EndIf
	
If SE2->E2_SALDO == 0
	MsgBox('Título totalmente baixado. Não pode ser desdobrado.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

DbSelectArea('SE2')
_aCols :={}
aAdd(_aCols,{SE2->E2_VALOR, SE2->E2_VENCTO})
aAdd(_aCols,{0, ctod('')})
_cChave := SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM
DbSkip()
If _cChave == SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM
	_aCols[2,1] := SE2->E2_VALOR
	_aCols[2,2] := SE2->E2_VENCTO
EndIf
DbSkip(-1)

_cNatur   := SE2->E2_NATUREZ

_oDlg:=MsDialog():New(0,0,260,420,'Desdobramento de contas a pagar - Silverado',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

@ 005,005 say 'Parcela'
@ 005,055 say 'Valor'
@ 005,105 say 'Vencimento'
@ 005,155 say 'Natureza'

@ 025,005 say '1'
@ 025,035 get _aCols[1,1] size 50,10 pict '@E 999,999,999.99' size 50,10
@ 025,105 get _aCols[1,2] size 50,10 valid empty(_aCols[1,2]) .or. _aCols[1,2] >= date()
@ 025,155 get _cNatur     size 25,10  F3 'SED'

@ 045,005 say '2'
@ 045,035 get _aCols[2,1] size 50,10 pict '@E 999,999,999.99'
@ 045,105 get _aCols[2,2] size 50,10 valid empty(_aCols[2,2]) .or. _aCols[2,2] >= date()

@ 110,010 BmpButton Type 01 Action(GravaTit(),_oDlg:End())
@ 110,060 BmpButton Type 02 Action(_oDlg:End())
_oDlg:Activate(,,,.T.,/*{||msgstop('validou!'),.T.}*/,,/*{||msgstop('iniciando…')}*/,,,, )

RestArea(_aArea)

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaTit()
//////////////////////////
_aNovo := {}
For _nI := 1 to FCount()
	_cCampo := 'SE2->' + FieldName(_nI)
	aAdd(_aNovo,&_cCampo)
Next
RecLock('SE2', .f.)
SE2->E2_VALOR   := _aCols[1,1]
SE2->E2_VLCRUZ  := _aCols[1,1]
SE2->E2_SALDO   := _aCols[1,1]
SE2->E2_VENCTO  := _aCols[1,2]
SE2->E2_VENCREA := DataValida(_aCols[1,2])
If _aCols[2,1] > 0 .and. !empty(_aCols[2,2])
	SE2->E2_PARCELA := '001'
EndIf
SE2->E2_NATUREZ := _cNatur
MsUnLock()

If _aCols[2,1] > 0 .and. !empty(_aCols[2,2])
	
	DbSkip()
	RecLock('SE2', _cChave + '002' <> SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM + SE2->E2_PARCELA)

	For _nJ := 1 to len(_aNovo)
		FieldPut(_nJ, _aNovo[_nJ])
	Next
	
	SE2->E2_VALOR   := _aCols[2,1]
	SE2->E2_VLCRUZ  := _aCols[2,1]
	SE2->E2_SALDO   := _aCols[2,1]
	SE2->E2_VENCTO  := _aCols[2,2]
	SE2->E2_VENCREA := DataValida(_aCols[2,2])
	SE2->E2_PARCELA := '002'
	SE2->E2_NATUREZ := _cNatur
	MsUnLock()
	
EndIf

MsgBox('Desdobramento OK','OK','INFO')
Return()
