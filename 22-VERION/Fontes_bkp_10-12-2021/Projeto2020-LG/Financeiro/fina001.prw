#include "rwmake.ch"

User Function TABFAQ()

// Declaracao de variaveis utilizadas no programa atraves da funcao
// SetPrvt, que criara somente as variaveis definidas pelo usuario,
// identicando as variaveis publicas do sistema utilizadas no Codigo

SetPrvt("CCADASTRO, AROTINA, CDELFUNC, CVLDALT, CVLDEXC, CSTRING")

// Programa  MBROWSE
// Descricao Exemplo de uso da funcao MB
// Descricao Pesquisa e visualizacao do cadastro de Nota de Credito de
//           Cliente ou Nota de Debito do Fornecedor
//           Especifico da ALKA Diagnosticos

//
// Grava ambiente atual
//
cAlias  := Alias()
nOrd    := Indexord()
nReg    := Recno()

// Variavel com o titulo da janela (deve ser cCadastro, pois a versao
// Windows refere-se a essa variavel).

aRotina   := {}
cCadastro := "Tabela de Amarracao de Parcelas"

// No caso do ambiente DOS, desenha a tela padrao de fundo

#IFNDEF WINDOWS
	@03,00 clear TO 24,79
	@08,00 clear TO 24,79
	
	ScreenDraw("", 3, 0, 0, 0)
	@3,1 Say cCadastro Color "B/W"
	@4,0 Say replicate("-",80)
#ENDIF

// Monta um aRotina proprio


aAdd(aRotina,{"Pesquisar ","AxPesqui",0,1})
aAdd(aRotina,{"Visualizar","AxVisual",0,2})
aAdd(aRotina,{"Incluir   ","AxInclui",0,3})
aAdd(aRotina,{"Alterar   ","AxAltera",0,4})
aAdd(aRotina,{"Excluir   ","AxDeleta",0,5})

/*
aAdd(aRotina,{{"Pesquisar ","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir   ","AxInclui",0,3} ,;
{"Alterar   ","AxAltera",0,4} ,;
{"Excluir   ","AxDeleta",0,5}}
*/

MBrowse(07,00,22,78,"SFQ",,"FQ_ENTORI")

// Retorna condicao original

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoto(nReg)

return
