#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMCDSF01  บAutor  ณJunior Carvalho     บData  ณ 10/09/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para Cadastro de Principal                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                            MANUTENCAO                                 บฑฑ
ฑฑฬออออออัออออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ SEQ  ณ DATA       | DESCRICAO                                         บฑฑ
ฑฑฬออออออุออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ 001  ณ            |                                                   บฑฑ
ฑฑบ      ณ            |                                                   บฑฑ
ฑฑศออออออฯออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function IMCDSZ2()

	Local aCores := {}

	Private cTitulo := "Cadastro de Embalagens"
	Private cCadastro := "Embalagens"
	Private aRotina := MenuDef()

	Private aSize := MsAdvSize( .T., SetMDIChild() )

	MBrowse(,,,,"SZ2" ,,,,,, aCores)

Return

Static Function MenuDef()          

	Local aRotina    := {}

	Aadd(aRotina,{"Pesquisar"	,"AxPesqui"	,0,1 })
	Aadd(aRotina,{"Visualizar"	,"AxVisual"	,0,2 })
	Aadd(aRotina,{"Incluir"		,"AxInclui"	,0,3 })
	Aadd(aRotina,{"Alterar"		,"AxAltera"	,0,4 }) 
//	Aadd(aRotina,{"Excluir"		,"AxDeleta"	,0,5 })   

Return aClone(aRotina)   


