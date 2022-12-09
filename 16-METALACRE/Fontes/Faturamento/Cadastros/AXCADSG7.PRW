#INCLUDE "rwmake.ch"

User Function AXCADSA7()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg   := "1"
Private cCadastro := "Tabela Produtos & Cliente"
Private aRotina := { {"Pesquisar" ,"AxPesqui",0,1} ,;
		             {"Visualizar","AxVisual",0,2} ,;
        		     {"Incluir"   ,"AxInclui",0,3} ,;
		             {"Alterar"   ,"AxAltera",0,4} ,;
        		     {"Excluir"   ,"AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SA7"

dbSelectArea("SA7")
dbSetOrder(1)

cPerg   := "1"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return
