#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		F190BROW
// Autor		alexandre dalpiaz
// Data			06/05/2013
// Descricao	Filtro do Browse da rotina de geracao de cheques a pagar
// Uso			Laselva S/A
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F190BROW()
////////////////////////

U_LS_MATRIZ()

Public _cSE2FilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'" 

DbSelectArea('SE2')
Set Filter to &_cSE2FilBrow

DbSelectArea('SEF')
If FieldPos('EF_MATRIZ') > 0
	Public _cFilBrow	:= "EF_MATRIZ == '" + cFilAnt + "'" 
Else
	Public _cFilBrow	:= "EF_FILIAL == '" + cFilAnt + "'" 
EndIf

Set Filter to &_cFilBrow  

//aAdd( aRotina,	{ 'Filtro'     , 'U_LS_FILTRO("SEF",_cFilBrow)'	, 0 , 2})

Return()