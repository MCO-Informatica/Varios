#include "rwmake.ch"
#include "colors.ch"   
#include "PROTHEUS.ch"       
#INCLUDE "TOPCONN.CH"  


/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? PRT0021      ? Autor ?FLAVIA AGUIAR   ? Data ? 16/02/2011  ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Tela que faz a transferencia de almoxarifado dos produtos  ???
??           ? da OP.                                                     ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Elvi                                                       ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/   

User Function Z07()     


Local cAlias := "Z07"           

Private cCadastro := "LOTE x OPs"
Private aRotina	  := {}                

AADD(aRotina , {"Pesquisar"	,"AxPesqui",0,1})
AADD(aRotina , {"Visualizar","AxVisual",0,2})
AADD(aRotina , {"Incluir"	,"AxInclui",0,3})
AADD(aRotina , {"Alterar"	,"AxAltera",0,4})
AADD(aRotina , {"Excluir"	,"AxDeleta",0,5})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias)

Return
