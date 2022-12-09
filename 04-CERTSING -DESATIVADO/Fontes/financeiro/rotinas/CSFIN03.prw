#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"

user function CSFIN03()

Private cCadastro := "Liberação de Compensação Manual"
Private aRotina := 	{ {"Pesquisar","AxPesqui",0,1} ,;
             		{"Visualizar","AxVisual",0,2} ,;
             		{"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T."
Private cString := "FIE"

dbSelectArea("FIE")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return .T.

