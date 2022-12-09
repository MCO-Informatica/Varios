#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZ2    ณ Autor ณJunior Carvalho     ณ Data ณ  14/04/2015 บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMbrowser para permitir cadastrar                            บฑฑ
ฑฑบ          ณ De/Para TES Logix x Protheus                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Golden Carga                                               บฑฑ 
ฑฑฬออออออออออฯออออัออออออออออออัออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp. |  Data      | Manutencao Efetuada                      บฑฑ 
ฑฑฬอออออออออออออออุออออออออออออุออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               |            |                                          บฑฑ 
ฑฑศอออออออออออออออฯออออออออออออฯออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CADSZ2()

Private cCadastro := "Incluir Armazem - IMCD "

Private aRotina := {{"Pesquisar","AxPesqui",0,1} ,;
					{"Visualizar","AxVisual",0,2} ,;
	             	{"Incluir","AxInclui",0,3} ,;
             		{"Alterar","AxAltera",0,4} } 

Private cString := "SZ2"

dbSelectArea("SZ2")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return Nil 