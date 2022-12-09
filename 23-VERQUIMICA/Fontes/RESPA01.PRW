#INCLUDE "rwmake.ch"

//==================================================================================
// Programa.....: RESPA01
// Autor........: Anderson Goncalves
// Data.........: 09/09/21
// Descricao....: Cadastro de codigos ANP
// Uso..........: Verquimica
//==================================================================================

User Function RESPA01()

//=================================================
// Variaveis da Rotina
//=================================================
Local cVldAlt := ".T."
Local cVldExc := ".T."

Private cString := "PA2"

dbSelectArea("PA2")
PA2->(dbSetOrder(1))

AxCadastro(cString,"Cadastro ANP",cVldExc,cVldAlt)

Return Nil
