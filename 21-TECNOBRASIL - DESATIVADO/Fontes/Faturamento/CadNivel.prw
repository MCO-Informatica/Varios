#Include 'Protheus.ch'


/*/{Protheus.doc} ManutSZ1
Tela de cadastro de niveis
@type User_function
@version 1 
@author Fabio
@since 03/05/2021
/*/
User Function CadNivel()

	Private cCadastro := "Cadastro de Niveis"
	Private aRotina   := { ;
    { "Pesquisar" , "AxPesqui"  , 0, 1 },;
	{ "Visualizar", "AxVisual"  , 0, 2 },;
    { "Incluir"   , "AxInclui"  , 0, 3 },;
	{ "Alterar"	  , "AxAltera"  , 0, 4 },;
	{ "Legenda"   , "U_LEGSZ1()", 0, 5 } }

	Private aCores    := {;
    { "Z1_NIVEL == '1'", 'BR_BRANCO'    },;
	{ "Z1_NIVEL == '2'", 'BR_AZUL'      },;
    { "Z1_NIVEL == '3'", 'BR_VERDE'     },;
    { "Z1_NIVEL == '4'", 'BR_AMARELO'   },;
    { "Z1_NIVEL == '5'", 'BR_VERMELHO'  } }

	mBrowse( 6, 1, 22, 75, "SZ1",,,,,, aCores )

Return .T.

User Function LegSZ1()

	aLegenda := {; 
    { "BR_BRANCO"  , "Nivel 1" },;
	{ "BR_AZUL"    , "Nivel 2" },;
    { "BR_VERDE"   , "Nivel 3" },;
    { "BR_AMARELO" , "Nivel 4" },;
    { "BR_VERMELHO", "Nivel 5" } }

	BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return .T.
