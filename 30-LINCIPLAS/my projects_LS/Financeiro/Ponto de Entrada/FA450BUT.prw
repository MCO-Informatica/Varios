
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		FA450BUT
// Autor		alexandre dalpiaz
// Data			05/09/2013
// Descricao	Filtro do Browse da rotina de compensação entre carteiras
// Uso			Laselva S/A
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FA450BUT()
////////////////////////

If empty(FunName())
	Return()
EndIf

U_LS_MATRIZ()

Public _cFilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'" 

DbSelectArea('SE2')

Set Filter to &_cFilBrow  

_aRotina := {}
aAdd(_aRotina, { "Pesquisar", 	"AxPesqui"   	, 0 , 1,,.F.})
aAdd(_aRotina, { "Visualizar", 	"AxVisual"   	, 0 , 2})
aAdd(_aRotina, { "Compensar", 	"Fa450CMP"   	, 0 , 3})
aAdd(_aRotina, { "Cancelar", 	"Fa450Can"   	, 0 , 6})
aAdd(_aRotina, { "Estornar", 	"Fa450Can"   	, 0 , 5})
aAdd(_aRotina, { "Legenda",		"Fa450Leg"		, 0	, 7,,.F.})
//aAdd(_aRotina, { "Filtro"     , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})

Return(_aRotina)
