#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		f340brow
// Autor		alexandre dalpiaz
// Data			06/05/2013
// Descricao	Filtro do Browse da rotina de compensa��o de contas a apgar
// Uso			Laselva S/A
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function f340brow()
////////////////////////

U_LS_MATRIZ()

Public _cFilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'"

DbSelectArea('SE2')
Set Filter to &_cFilBrow   
/*
If __cUserId $ GetMv('LA_PODER')
	aRotina[3,2] := 'U_LS340COMP'
EndIf

//aAdd( aRotina,	{ 'Filtro'     , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})
*/
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS340COMP
//////////////////////
_cChave := "F340" + SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) + cEmpAnt
Do While !LockByName(_cChave ,.T., .F., .T. )
	If Aviso("Registro em uso","Este registro est� sendo manipulado por outro usu�rio e se encontra travado. Deseja tentar us�-lo novamente?",{"Sim", "N�o"},2)==1
		UnLockByName( _cChave , .T. , .F., .T. )
	Else
		Exit
	EndIf
EndDo  
DbSelectArea('SE2')
FA340COMP()
Return()