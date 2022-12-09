#INCLUDE "XMLXFUN.CH"
#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#define CRLF	CHR(13)+CHR(10)

#Include "PROTHEUS.Ch"
#Include "TOPCONN.Ch"
#Include "VKEY.ch"
#include "rwmake.ch"

#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATC002  º Autor ³ Danilo             º Data ³  12/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Projetos                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fix System                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RGUAX001


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local	aCores := {}
	Private cCadastro := "Monitor Guarani"
	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString := "ZB5"
	Private aRotina := {}
	AADD(aRotina,{"Pesquisar"	,"AxPesqui"			,0,1})
	AADD(aRotina,{"Visualizar"	,"AxVisual"			,0,2})
	AADD(aRotina,{"Legenda" 	,"U_RGUAXL01" 		,0,0})
	AADD(aRotina,{"Importar" 	,"U_RGUAXI01" 		,0,0})
	AADD(aRotina,{"Sincronizar" ,"U_RGUASX01" 		,0,3})
	AADD(aRotina,{"Alterar"		,"AxAltera"			,0,4})
	AADD(aRotina,{"Remover Pedido" ,"U_RGUAXX01"  	,0,4})
//	AADD(aRotina,{"Incluir","AxInclui",0,3} )
//	AADD(aRotina,{"Excluir","AxDeleta",0,6})

	AADD(aCores,	{'ZB5->ZB5_IMPORT=="0" ','BR_AMARELO' })
	AADD(aCores,	{'ZB5->ZB5_IMPORT=="1" ','BR_VERDE' })
	AADD(aCores,	{'ZB5->ZB5_IMPORT=="2" ','BR_CANCEL' })

/*	cFiltro := ""
	If MsgYesNo("Lista somente pedidos pendentes?")
		cFiltro 	:= 'ZB5_IMPORT=="0" '
	EndIf
*/	Processa({||Sincronizar(),"Sincronizando..."})

	DbSelectArea("ZB5")
	SetFunname("RGUAX001")

	dbSelectArea("ZB5")
	dbSetOrder(1)
	dbSelectArea(cString)
	MBrowse( 6 , 1 , 22 , 75 , "ZB5",,,,,,aCores,,,,,,,,/*cFiltro*/)
	SetFunname("MATA410")



Return

User Function RGUAXL01

	BrwLegenda(cCadastro, "Legenda", {	{"BR_VERDE"    , "1 - Importado" } ,;
		{"BR_AMARELO" , "0 - Pendente"} ,;
		{"BR_CANCEL"  , "2 - Cancelado"}} )
Return

Static FuncTion old2()

	Local	aCores := {	{'Empty(ZB5->ZB5_NUM) .And. ZB5->ZB5_IMPORT=="0" ','ENABLE' }}	//Pedido de Venda liberado
	PRIVATE CCADASTRO := "Peidos AFV"
	PRIVATE aRotina := {}
	AADD(aRotina,{ "Importar" ,"U_RGUAXI01" , 0 , 0})//}//,; //"Ordem"
	AADD(aRotina,{ "Sincronizar" ,"U_RGUASX01"  , 0 , 3}) //"Prep. Doc's"
	AADD(aRotina,{ "Remover Pedido" ,"U_RGUAXX01"  , 0 , 4}) //"Prep. Doc's"
	AADD(aRotina,{"Visualizar","AxVisual",0,2,0,.F.}) //"Prep. Doc's"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que preenche o array AACHO                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cFiltro   := 'ZB5_FILIAL=="'+xFilial("ZB5")+'"'
	If MsgYesNo("Lista somente pedidos pendentes?")
		cFiltro 	+= ' .And. ZB5_IMPORT=="0" '
	EndIf
	Processa({||Sincronizar(),"Sincronizando..."})

	DbSelectArea("ZB5")
	mBrowse( 6, 1,22,75,"ZB5",,,,,,aCores,,,,,,,, IF(!Empty(cFiltro),cFiltro, NIL))

Return

Static Function MenuDef()
	Private aRotina := {	{OemToAnsi("Pesquisar"),"AxPesqui"		, 0 , 1,0,.F.},;
		{OemToAnsi("Visualizar"),"A240Visual"	, 0 , 2,0,Nil},;
		{OemToAnsi("Incluir"),"U_SHMOVINC()"	, 0 , 3,0,Nil},;
		{OemToAnsi("Legenda"),"A240Legenda"	    , 0 , 2,0,.F.} }

RETURN (aRotina)


Static Function oldFun
	//Local aSizeAut  := MsAdvSize(,.F.,200)
	//Local nDlgHeight
	//Local nGDHeight
	//Local aSize := {}
	//Local aCordW := {}
	Local _aIndex   := {}
	//PRIVATE bFiltraBrw         // Expressao de Filtro
	Private aIndexADC  := {}
	Private bFiltraBrw 	:= {|| FilBrowse("ZB5",@aIndexADC,@cCondicao) }
	PRIVATE nOrdNFS := 1     // Ordem de Geracao da Nota Fiscal
	PRIVATE _cMarca	:= GetMark(,"ZB5","ZB5_OK")
	PRIVATE aRotina := {}
	AADD(aRotina,{ "Importar" ,"U_RGUAXI01" , 0 , 0})//}//,; //"Ordem"
	AADD(aRotina,{ "Sincronizar" ,"U_RGUASX01"  , 0 , 3}) //"Prep. Doc's"
	AADD(aRotina,{ "Remover Pedido" ,"U_RGUAXX01"  , 0 , 4}) //"Prep. Doc's"
	AADD(aRotina,{ "Visualizar","AxVisual",0,2,0,.F.}) //"Prep. Doc's"
	/*						{ STR0004 ,"Ma461Estor" , 0 , 0},; //"Estor.Doc's"
{ STR0033 ,"Ma461View"  , 0 , 2},; //"Visualiza Doc."
{ STR0042 ,"A461Legend" , 0 , 6},; //"Legenda"
{ STR0041 ,"Ma461Conh"  , 0 , 4} } //"Conhecimento"
			*/
	DbSelectArea("ZZZ")

	SetFunname("RGUAX001")

	Processa({||Sincronizar(),"Sincronizando..."})

	cCondicao   := 'ZB5_FILIAL=="'+xFilial("ZB5")+'"'
	If MsgYesNo("Lista somente pedidos pendentes?")
		cCondicao 	+= ' .And. ZB5_IMPORT=="0" '
	EndIf


	aCores := {	{'Empty(ZB5->ZB5_NUM) .And. ZB5->ZB5_IMPORT=="0" ','ENABLE' }}	//Pedido de Venda liberado

	Eval(bFiltraBrw)
	ZB5->(DbSetOrder(1))
	MarkBrow("ZB5","ZB5_OK",,/*aCampos*/,/*lInverte*/,_cMarca,"U_RFATXMA1()",/**/,/*cexpini*/,/*cexpfin*/,/*"Allwaystrue"*/,/*bparbloco*/,/*cexprfiltop*/,/**/,aCores,/**/)

	//DbUnlockAll()
	//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
	//ï¿½ Limpa Filtro e reabre indices com RetIndex                           ï¿½
	//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
EndFilBrw("ZB5",aIndexADC)

SetFunname("MATA410")

Return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½RFATX001  ï¿½Autor  ï¿½Microsiga           ï¿½ Data ï¿½  04/13/15   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ AP                                                        ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

Static Function RFATXMA1
	Local nRecno := Recno()
	dbSelectArea('ZB5')
	dbGotop()
	While !Eof()
		Reclock("ZB5",.F.)
		If Empty(ZB5->ZB5_OK)
			ZB5->ZB5_OK	:= _cMarca
		Else
			ZB5->ZB5_OK	:= ""
		EndIf
		MsUnlock()
		dbSkip()
	End
	dbGoto( nRecno )
Return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½RFATX001  ï¿½Autor  ï¿½Microsiga           ï¿½ Data ï¿½  04/13/15   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Sincroniza os pedidos do SFA_fortaleza para a tabela ZC5   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ Protheus 11 Fortaleza                                     ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

Static Function Sincronizar()

// MUDEI A ORDEM PARA LER PRIMEIRO A CARGA DE CLIENTES

	//If MsgYesNo("Importar os clientes??")
	aUF := {}
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})


	cQry := "SELECT CAST(CLI_CODIGOMUNICIPIO AS VARCHAR(7)) CODMUN,CLI_CODIGOCLIENTE,CLI_RAZAOSOCIAL"
	cQry += ",CLI_CGCCPF CGCCPF,CLI_INSCRESTADUAL INSCR,CLI_ENDERECO ENDERECO,CLI_NUMERO NUMERO,CLI_COMPLEMENTO COMPLEMENTO"
	cQry += ",CLI_BAIRRO BAIRRO,CLI_TELEFONE TELEFONE,CLI_FAX,CLI_CEP CEP,CLI_STATUS,CLI_NOMEFANTASIA,CLI_DATACADASTRO"
	cQry += ",CLI_CODREGIAO,CLI_CONDICAOENTREGA TPFRETE,CLI_CODRAMO,CLI_CODTABPRECO,CLI_ULTIMACOMPRA,CLI_ULTIMAVISITA"
	cQry += ",CLI_OBSCREDITO,CLI_OBSGERAL,CLI_EMAIL,CLI_PRAZOMAXIMO,CLI_CODIGOFORMAPGTO,CLI_FORMASPAGAMENTOS"
	cQry += ",CLI_DESCFIDELIDADE,CLI_BLOQUEADO,CLI_ALTTABPRECO,CLI_CODIGOCONDPGTO,CLI_FINANCEIRO,CLI_PRAZOMINIMOENT"
	cQry += ",CLI_PRAZOMAXIMOFAT,CLI_OBRIGARMULTIPLOEMB,CLI_CLIENTEVIP,CLI_MOTIVOBLOQUEIO,CLI_TIPOPESSOA,CLI_TRANSPORTADORA TRANSP"
	cQry += ",CLI_DESCONTO,CLI_TRATARLIMITECRED,CLI_TOLERANCIALIMITECRED,CLI_EMPRESAS,CLI_PRACA,CLI_LATITUDE,CLI_LONGITUDE"
	cQry += ",CLI_PESSOA,CLI_ENDERECOENTREGA,CLI_NUMEROENTREGA,CLI_COMPLEMENTOENTREGA,CLI_BAIRROENTREGA,CLI_CODMUNICIPIOENTREGA"
	cQry += ",CLI_CEPENTREGA,CLI_ENDERECOCOBRANCA,CLI_NUMEROCOBRANCA,CLI_COMPLEMENTOCOBRANCA,CLI_BAIRROCOBRANCA,CLI_CODMUNICIPIOCOBRANCA"
	cQry += ",CLI_CEPCOBRANCA,CLI_EMAILSECUNDARIO,CLI_EMAILNF,CLI_CODIGOGRUPOCLIENTE,CLI_PERCFRETE,CLI_EMPRESAPADRAO,CLI_PEDIDOMINIMO"
	cQry += ",CLI_PARCELAMINIMA,CLI_IMPORTADO,CLI_REPRESENTANTE,CLI_GUA_COD,CLI_FINANCEIROISENTO,CLI_DATAFUNDACAO,CLI_SUFRAMA"
	cQry += ",CLI_NOMEREFERENCIA1,CLI_NOMEREFERENCIA2,CLI_NOMEREFERENCIA3,CLI_FONEREFERENCIA1,CLI_FONEREFERENCIA2,CLI_FONEREFERENCIA3"
	cQry += ",CLI_AREACOMERCIAL,CLI_FAIXAFATURAMENTO,CLI_REFERENCIABANCARIA,CLI_PREDIOPROPRIO,CLI_FINANCEIRO_APLICA_TABELA,CLI_POSSUIREDE"
	cQry += ",CLI_NUMEROLOJAS,CLI_NUMEROCHECKOUTS,CLI_QTDEFUNCIONARIOS,CLI_LIMITECREDBONIF,CLI_REGIMEESPECIAL,CLI_SIVISA_VALIDADE,CLI_CRF_VALIDADE,CLI_SIVISA_REGISTRO,CLI_CRF_REGISTRO "
	cQry += "FROM AND_CLIENTES "
	//cQry += "	INNER JOIN AND_HISTPEDITENS ITEM ON HPC_NUMPEDIDOEMP=HPI_NUMPEDIDOEMP "

	TCQUERY cQry NEW ALIAS 'CLIENTES'


	DbSelectArea("CLIENTES")
	DbGotop()
	ProcRegua(CLIENTES->(Recno()))
	While !CLIENTES->(Eof())
		_cCgcCpf := STRTRAN(STRTRAN(STRTRAN(CLIENTES->CGCCPF,".",""),"-",""),"/","")
		_cCodEst := SUBSTR(CLIENTES->CODMUN,1,2)
		_cEst := aUF[aScan(aUF,{|x| x[2] == _cCodEst}),1]
		_cCodMun := SUBSTR(CLIENTES->CODMUN,3,5)
		DbSelectArea("SA1")
		DbSetOrder(3)
		If !DbSeek(xFilial("SA1")+Padr(_cCgcCpf,14))
			lMsErroAuto := .F.
			aVetor:= {}
			aadd(aVetor,{"A1_NOME"      ,CLIENTES->CLI_RAZAOSOCIAL  ,Nil}) // Nome         C 40
			aadd(aVetor,{"A1_PESSOA"    ,CLIENTES->CLI_PESSOA				    ,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_NREDUZ"    ,IF(EMPTY(CLIENTES->CLI_NOMEFANTASIA),CLIENTES->CLI_RAZAOSOCIAL,CLIENTES->CLI_NOMEFANTASIA)		 ,Nil}) // Nome reduz.  C 20
			aadd(aVetor,{"A1_END"       ,ALLTRIM(CLIENTES->ENDERECO)+", "+cvaltochar(CLIENTES->NUMERO)	 ,Nil}) // Endereco     C 40
			aadd(aVetor,{"A1_TIPO"      ,CLIENTES->CLI_TIPOPESSOA				    ,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_EST"       ,_cEst				    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_COD_MUN"   ,_cCodMun	 ,Nil}) // Cidade       C 15
			aadd(aVetor,{"A1_BAIRRO"    ,ALLTRIM(CLIENTES->BAIRRO)	 ,Nil}) // Endereco     C 40
			aadd(aVetor,{"A1_CEP"       ,STRTRAN(CLIENTES->CEP,"-","")				    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_COMPL"     ,ALLTRIM(CLIENTES->COMPLEMENTO) ,Nil}) // Endereco     C 40
			aadd(aVetor,{"A1_CGC"  	 	,_cCgccpf	,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_INSCR"  	 ,IF(CLIENTES->CLI_PESSOA=='F','ISENTO',UPPER(CLIENTES->INSCR))	,Nil}) // Tipo         C 01 //R Revendedor
			aadd(aVetor,{"A1_EMAIL"     ,ALLTRIM(CLIENTES->CLI_EMAIL)    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_EMAILNF"     ,ALLTRIM(CLIENTES->CLI_EMAILNF)    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_DDD"     	,SUBSTR(ALLTRIM(CLIENTES->TELEFONE),2,2)    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_TEL"     	,STRTRAN(SUBSTR(ALLTRIM(CLIENTES->TELEFONE),5,10),"-","")    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_NATUREZ"   ,"10101"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_VEND"     ,CLIENTES->CLI_REPRESENTANTE    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_SUFRAMA"  ,CLIENTES->CLI_SUFRAMA    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_TPFRET"    ,CLIENTES->TPFRETE    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_TRANSP"    ,CLIENTES->TRANSP    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_CONTA"    ,"112020001"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_NATUREZ"  ,"10101"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_GRPTRIB"  ,"C01"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_CONTRIB"  ,"1"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_SIMPNAC"  ,"2"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_CODPAIS"  ,"01058"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_TABELA"   ,"U"    ,Nil})  // Estado       C 02
			aadd(aVetor,{"A1_XUSER"   ,"AFV"    ,Nil})  // Estado       C 02
			MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //Inclusao
			If lMsErroAuto
				MostraErro()
			Endif
		EndIf
		CLIENTES->(DbSkip())
	EndDo
	CLIENTES->(DbCloseArea())

// MUDEI A ORDEM PARA LER PRIMEIRO A CARGA DE CLIENTES

	cQry := "SELECT "
	cQry += "HPC_SEQUENCIAL,HPC_NUMPEDIDOEMP	,HPC_NUMPEDIDOSFA	,HPC_CODIGOCLIENTE CLIENTE ,HPC_STATUSPEDIDO	,HPC_VALORPEDIDO	,HPC_VALORFATURADO	,HPC_DTPEDIDO	"
	cQry += ",HPC_DTPREVISTAENTREGA	HPC_DTPENT,HPC_ORIGEMPEDIDO	,HPC_CODIGOTIPOPEDIDO	,HPC_FORMAPAGAMENTO	,HPC_PLANOPAGAMENTO	,HPC_DESCRICAOFRETE TPFRETE	,HPC_ORDEMCOMPRA AS HPC_OC	"
	cQry += ",HPC_OBSERVACAOFAT AS HPC_OBS	,HPC_OBS_INTERNA AS HPC_OBSINT	,HPC_CODCONDPGTO CONDPG	,HPC_NOTASFISCAIS	,HPC_DTAFATURAMENTO	,HPC_FIDELIDADE	,HPC_RECUPERAR	,HPC_REPRESENTANTE	,HPC_EMPRESA	"
	cQry += ",HPC_ENVIADO	,HPC_VALORBRUTO	,HPC_VALORST	,HPC_VALORIPI	,HPC_VALORDESCONTO	,HPC_TRANSPORTADORA	,HPC_TABELAPRECO	,HPC_QTDEVOLUMES	"
	cQry += ",HPC_VALORBASECOMISSAO	,HPC_PERCENTUALCOMISSAO	,HPC_VALORCOMISSAO	,HPC_ORCAMENTO	,HPC_CANCELADO	,HPC_DTCANCELAMENTO	,HPC_MOTIVO	"
	cQry += ",HPC_CHAVENFELETRONICA	,HPC_IMPORTADO	,HPC_CNPJCLIENTE CNPJ	,HPC_IECLIENTE	,HPC_PERCDESCONTO	,HPC_DESCONTOFAIXAVALOR	,HPC_DESCONTOFORMAPGTO	"
	cQry += ",HPC_DESCONTOCONDPGTO	,HPC_DESCONTOFIDELIDADE	,HPC_DESCONTOACUMULADO	,HPC_VERBAUTILIZADA	,HPC_VERBAGERADA	,HPC_PREPOSTO	,HPC_CODENDENTREGA "
	cQry += ",HPC_DATASINCRONIZACAO	,HPC_PEDIDOBONIFPROMOCAO	,HPC_CODCONDPGTODIF	,HPC_DIASCONDPGTODIF	,HPC_PERCVBCONDPGTODIF	,HPC_PRZ1	,HPC_PRZ2 "
	cQry += ",HPC_PRZ3	,HPC_PRZ4	,HPC_PRZ5	,HPC_PRZ6	,HPC_PRZ7	,HPC_PRZ8	,HPC_LATITUDE	,HPC_LONGITUDE	,HPC_ENDERECOVENDA	,HPC_VEIODOERP	,HPC_FRETEVALOR	,HPC_RETORNO "
	//cQry += ",HPI_NUMPEDIDOEMP, HPI_SEQUENCIAL, HPI_CODIGOPRODUTO,HPI_DESCRICAOPRODUTO,HPI_QTDEVENDIDA,HPI_VALORVENDA,HPI_VALORTOTAL "
	//cQry += ",HPI_ALIQUOTAIPI,HPI_VALORIPI,HPI_VALORST,HPI_VALORTABELA,HPI_NCM,HPI_DESCONTO,HPI_VALORDESCONTO "

	cQry += "FROM AND_HISTPEDCAB "
	//cQry += "	INNER JOIN AND_HISTPEDITENS ITEM ON HPC_NUMPEDIDOEMP=HPI_NUMPEDIDOEMP "
	cQry += "ORDER BY HPC_NUMPEDIDOEMP "
	TCQUERY cQry NEW ALIAS 'PEDIDO'

	_nDescPC := 0
	DbSelectArea("PEDIDO")
	DbGotop()
	ProcRegua(PEDIDO->(Recno()))
	While !PEDIDO->(Eof())
		IncProc("Pedido: "+PEDIDO->HPC_NUMPEDIDOEMP)
		_cNumPed := Padr(PEDIDO->HPC_NUMPEDIDOEMP,Tamsx3("ZB5_PEDEMP")[1])
		_cCnpj := STRTRAN(STRTRAN(STRTRAN(PEDIDO->CNPJ,".",""),"-",""),"/","")
		DbSelectArea("SA1")
		DbSetOrder(3)

		If DbSeek(xFilial("SA1")+Padr(_cCnpj,TamSX3("A1_CGC")[1]))

			DbSelectArea("ZB5")
			DbSetOrder(1)
			If !DbSeek(xFilial("ZB5")+_cNumPed)
				_aStru := PEDIDO->(DbStruct())
				RecLock("ZB5",.T.)
				ZB5->ZB5_IMPORT	:= '0'
				ZB5->ZB5_FILIAL	:= xFilial("ZB5")
				ZB5->ZB5_PEDEMP	:= _cNumPed
				ZB5->ZB5_PEDSFA	:= PEDIDO->HPC_NUMPEDIDOSFA
			Else
				RecLock("ZB5",.F.)
			EndIf
			ZB5->ZB5_SEQUEN	:= StrZero(PEDIDO->HPC_SEQUENCIAL,6)
			ZB5->ZB5_CLIENT	:= SA1->(A1_COD+A1_LOJA) //Substr(PEDIDO->CLIENTE,1,8)
			ZB5->ZB5_DTPED	:= CTOD(PEDIDO->HPC_DTPEDIDO)
			ZB5->ZB5_ORIGEM	:= PEDIDO->HPC_ORIGEMPEDIDO
			ZB5->ZB5_TPPED	:= 'N'
			ZB5->ZB5_FRMPGT	:= PEDIDO->HPC_FORMAPAGAMENTO
			ZB5->ZB5_PLANO	:= PEDIDO->HPC_PLANOPAGAMENTO
			ZB5->ZB5_COND	:= PEDIDO->CONDPG
			ZB5->ZB5_VEND	:= StrZero(PEDIDO->HPC_REPRESENTANTE,6)
			ZB5->ZB5_TPFRET	:= PEDIDO->TPFRETE
			ZB5->ZB5_TRANSP	:= PEDIDO->HPC_TRANSPORTADORA
			ZB5->ZB5_TABELA	:= PEDIDO->HPC_TABELAPRECO
			ZB5->ZB5_DTSINC	:= PEDIDO->HPC_DATASINCRONIZACAO
			ZB5->ZB5_DTIMP	:= DATE()
			ZB5->ZB5_HRIMP	:= TIME()
			ZB5->ZB5_OBS	:= PEDIDO->HPC_OBS
			ZB5->ZB5_OBSINT	:= PEDIDO->HPC_OBSINT
			ZB5->ZB5_OC		:= PEDIDO->HPC_OC
			ZB5->ZB5_DTPENT	:= CTOD(PEDIDO->HPC_DTPENT)
			ZB5->ZB5_NOME	:= SA1->A1_NOME
			ZB5->ZB5_DESC	:= PEDIDO->HPC_DESCONTOACUMULADO
			ZB5->(MsUnlock())
			_nDescPC := PEDIDO->HPC_DESCONTOACUMULADO

			_cItem := "01"
			cQry := "SELECT HPI_NUMPEDIDOEMP, HPI_SEQUENCIAL, ISNULL(PIS_CODIGOSEGREGACAO,HPI_CODIGOPRODUTO) PRODUTO"
			cQry += ",HPI_DESCRICAOPRODUTO,ISNULL(PIS_QUANTIDADE,HPI_QTDEVENDIDA) HPI_QTDEVENDIDA,HPI_VALORVENDA,HPI_VALORTOTAL "
			cQry += ",HPI_ALIQUOTAIPI,HPI_VALORIPI,HPI_VALORST,HPI_VALORTABELA,HPI_NCM,HPI_DESCONTO,HPI_VALORDESCONTO "
			cQry += "FROM AND_HISTPEDITENS ITENS "
			cQry += "	LEFT JOIN AND_HISTPEDITENSSEGREGACAO ON PIS_NUMPEDIDO=HPI_NUMPEDIDOEMP AND PIS_CODIGOPRODUTO=HPI_CODIGOPRODUTO "
			cQry += "WHERE HPI_NUMPEDIDOEMP='"+_cNumPed+"' "
			TCQUERY cQry NEW ALIAS 'ITENS'
			DbSelectArea("ITENS")
			DbGotop()
			While !ITENS->(Eof())
				DbSelectArea("ZB6")
				DbSetOrder(2)
				If DbSeek(xFilial("ZB6")+_cNumPed+padr(ITENS->PRODUTO,tamsx3("B1_COD")[1]))
					RecLock("ZB6",.F.)
				Else
					RecLock("ZB6",.T.)
					ZB6->ZB6_FILIAL	:= xFilial("ZB6")
					ZB6->ZB6_PEDEMP	:= _cNumPed
					ZB6->ZB6_COD	:= padr(ITENS->PRODUTO,tamsx3("B1_COD")[1])
				EndIf
				ZB6->ZB6_ITEM	:= _cItem
				ZB6->ZB6_COD	:= ITENS->PRODUTO
				ZB6->ZB6_DESCRI	:= ITENS->HPI_DESCRICAOPRODUTO
				ZB6->ZB6_QTDVEN	:= ITENS->HPI_QTDEVENDIDA
				ZB6->ZB6_PRCVEN	:= ITENS->HPI_VALORVENDA
				ZB6->ZB6_PRUNIT	:= ITENS->HPI_VALORTABELA
				ZB6->ZB6_VALOR	:= ITENS->HPI_VALORTOTAL
				ZB6->ZB6_IPI	:= ITENS->HPI_ALIQUOTAIPI
				ZB6->ZB6_VALIPI	:= ITENS->HPI_VALORIPI
				ZB6->ZB6_VALST	:= ITENS->HPI_VALORST
				ZB6->ZB6_NCM	:= ITENS->HPI_NCM
				ZB6->ZB6_DESCON	:= ITENS->HPI_DESCONTO
				ZB6->ZB6_VALDES	:= ITENS->HPI_VALORDESCONTO
				ZB6->(MsUnlock())

				_cItem := Soma1(_cItem)

				ITENS->(DbSkip())
			EndDo
			ITENS->(DbCloseArea())
		ENDIF

		PEDIDO->(DbSkip())
	EndDo
	PEDIDO->(DbCloseArea())
	//SEndIf
Return
/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½RCOMX001  ï¿½Autor  ï¿½Microsiga           ï¿½ Data ï¿½  08/15/14   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ AP                                                        ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
User Function RGUAXI01

/*
	_nRecOri := ZB5->(Recno())
	cQry1 := "SELECT * FROM "+RetSqlName("ZB5")+" ZB5 WHERE ZB5.D_E_L_E_T_<>'*' AND ZB5_OK='"+_cMarca+"' "
	TcQuery cQry1 New Alias "ZB5I"

	DbSelectArea("ZB5I")
	DbGotop()
	While !ZB5I->(Eof())
		DbSelectArea("ZB5")
		DbGoto(ZB5I->R_E_C_N_O_)
		Processa({||Importar(),"Processando pedido: "+ZB5I->ZB5_PEDEMP})
		ZB5I->(DbSkip())
	EndDo
	ZB5I->(DbCloseArea())
	ZB5->(DbGoto(_nRecOri))
*/

	Processa({||Importar(),"Processando pedido: "+ZB5->ZB5_PEDEMP})

Return


/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½RFATX001  ï¿½Autor  ï¿½Microsiga           ï¿½ Data ï¿½  04/13/15   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ AP                                                        ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

Static Function Importar()
	// pedido ok para ser processado
	LOCAL cMsgmm,_ctransp,_totliq
	LOCAL _cLinhaP := Space (01)

	PRIVATE lMsErroAuto := .F.
	BEGIN TRANSACTION
		aCabecalho:={}
		DbSelectar("SA1")
		DbSetorder(1)
		If !DBSEEK(xfilial()+SUBSTR(ZB5->ZB5_CLIENT,1,8))
			DisarmTransaction()
			Return
		EndIf

		// Localizando Linha (Tabela B ou R)

		DbSelectArea("SC5")
		DbOrderNickName("C5XPEDEMP")
		If Dbseek(xFilial("SC5")+Padr(ZB5->ZB5_PEDEMP,TamSx3("C5_XPEDEMP")[1]))
			Alert("Pedido "+Alltrim(ZB5->ZB5_PEDEMP)+" jï¿½ importado no pedido de venda "+SC5->C5_NUM+"!!!")
			DisarmTransaction()
			Return
		EndIf
		DbSelectArea("SA3")
		DbSetOrder(1)
		DbSeek(xFilial("SA3")+ZB5->ZB5_VEND)
		aCabecalho  := {}
		//aadd(aCabecalho, {'C5_FILIAL',xFilial("SC5"),NIL})
		aadd(aCabecalho, {'C5_FILIAL','01',NIL})
		aadd(aCabecalho, 	{'C5_TIPO',"N",NIL})
		aadd(aCabecalho, {'C5_CLIENTE',SA1->A1_COD,NIL})
		aadd(aCabecalho, {'C5_LOJACLI',SA1->A1_LOJA,NIL})
		aadd(aCabecalho, {'C5_LOJAENT',SA1->A1_LOJA,NIL})
		aadd(aCabecalho, {'C5_VEND1',ZB5->ZB5_VEND,NIL})
		If !Empty(SA3->A3_SUPER) //se houver vendedor superior preenche com ele no vendedor 2
			aadd(aCabecalho, {'C5_VEND2'	,SA3->A3_SUPER,NIL})
		EndIf
		aadd(aCabecalho, {'C5_X_CODRE'	,'5100',NIL})
		aadd(aCabecalho, {'C5_EMISSAO',DDATABASE,NIL})
		aadd(aCabecalho, {'C5_CONDPAG',ZB5->ZB5_COND,NIL})
		aadd(aCabecalho, {'C5_TPCARGA',"2",NIL}) // Indica que utiliza carga p/ OMS
		aadd(aCabecalho, {'C5_TABELA',ZB5->ZB5_TABELA,NIL})
		IF ZB5->ZB5_DTPENT > (ddatabase+10)
			aadd(aCabecalho, {'C5_DTENTR',ddatabase+10,NIL})
		Else
			aadd(aCabecalho, {'C5_DTENTR',ZB5->ZB5_DTPENT,NIL})
		EndIf
		aadd(aCabecalho, {'C5_MOEDA',1,NIL})
		aadd(aCabecalho, {'C5_TPFRETE',IIF(ZB5->ZB5_TPFRET = 'S','F',ZB5->ZB5_TPFRET),NIL})
		If ZB5->ZB5_TPFRET == "F" .AND. !ZB5->ZB5_TRANSP $ "000001/000002"
			aadd(aCabecalho, {'C5_XTEMRED','S',NIL})
			aadd(aCabecalho, {'C5_TRANSP','000001',NIL})
			aadd(aCabecalho, {'C5_REDESP',ZB5->ZB5_TRANSP,NIL})
			aadd(aCabecalho, {'C5_TPFREDE','D',NIL})
		ElseIf ZB5->ZB5_TPFRET == "C"
			aadd(aCabecalho, {'C5_XTEMRED','N',NIL})
			aadd(aCabecalho, {'C5_TRANSP',ZB5->ZB5_TRANSP,NIL})
			aadd(aCabecalho, {'C5_TPFREDE','R',NIL})
		EndIf
		aadd(aCabecalho, {'C5_XOBS',ZB5->ZB5_OBS,NIL})
		aadd(aCabecalho, {'C5_XOBSINT',ZB5->ZB5_OBSINT,NIL})
		aadd(aCabecalho, {'C5_XOC',ZB5->ZB5_OC,NIL})
		aadd(aCabecalho, {'C5_XDTPENT',ZB5->ZB5_DTPENT,NIL})
		aadd(aCabecalho, {'C5_XPEDEMP',ZB5->ZB5_PEDEMP,NIL})		// Linha (Tabela B ou R)

//==AREA ONDE ESTAVA
		cQry2 := "SELECT * "
		cQry2 += "FROM "+RetSqlName("ZB6")+" ZB6 "
		cQry2 += "WHERE ZB6.D_E_L_E_T_<>'*' "
		cQry2 += "AND ZB6_PEDEMP='"+ZB5->ZB5_PEDEMP+"' "
		_aZB6 := {}
		TCQUERY CQRY2 NEW ALIAS 'ZB6I'

		DBSELECTAREA('ZB6I')
		DBGOTOP()

		ProcRegua(ZB6I->(RecCount()))
		_nQtdZB62 := 0
		aItens:={}
		_NUMITEM:="00"
		While !ZB6I->(EOF())
			IncProc("Processando item "+ZB6I->ZB6_COD)

			//=====AGLUTINADOR DE VALORES PARA GRADE
			cQry3 := "SELECT ZB6_PEDEMP, SUBSTRING(ZB6_COD,1,6) ZB6_COD, SUM(ZB6_QTDVEN) ZB6_QTDVEN "
			cQry3 += "FROM "+RetSqlName("ZB6")+" ZB6 "
			cQry3 += "WHERE ZB6.D_E_L_E_T_<>'*' "
			cQry3 += "AND ZB6_PEDEMP='"+ZB5->ZB5_PEDEMP+"' "
			cQry3 += "GROUP BY 	ZB6_PEDEMP, SUBSTRING(ZB6_COD,1,6) "
			//_aZB6 := {}
			TCQUERY CQRY3 NEW ALIAS 'ZB6I2'
			
			DBSELECTAREA('ZB6I2')
			DBGOTOP()
			While !ZB6I2->(EOF())

				If SUBSTR(ZB6I2->ZB6_COD,1,6) = SUBSTR(ZB6I->ZB6_COD,1,6)
					_nQtdZB62 := ZB6I2->ZB6_QTDVEN
				Endif
				ZB6I2->(dbskip())
			Enddo
			ZB6I2->(DbCloseArea())
			//=====FIM DOS VALORES DA GRADE

			aLinha:={}
			_NUMITEM:=SOMA1(_NUMITEM,2)
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+PADR(ZB6I->ZB6_COD,TamSX3("B1_COD")[1]))

			dbselectar("SF4")
			dbsetorder(1)
			dbseek(xfilial()+SB1->B1_TS)

			dbselectar("DA0")
			dbsetorder(1)
			dbseek(xfilial("DA0")+ZB5->ZB5_TABELA)
//TRATATIVA PARA A TABELA USH---------------------------------------------------/////--------
			xEstNorte 	:= GETMV("MV_NORTE")
			_TpOper := ''
			If SA1->A1_EST == 'SP'
				_TpOper  := '1'
			Else
				If SA1->A1_EST $ xEstNorte
					_TpOper  := '3'
				Else
					_TpOper  := '2'
				EndIf
			EndIf

		//	Alert(''cValToChar('qtdprod'+ZB6I->ZB6_COD+'--'_nQtdZB62))
			IF SB1->B1_GRADE = 'N' .OR. SB1->B1_GRADE = ' '
				cQry := "SELECT TOP 1 DA1_TIPPRE,DA1_QTDLOT "
				cQry += "FROM DA1010 DA1 "
				cQry += "WHERE DA1.D_E_L_E_T_<>'*' AND DA1_CODTAB='"+ZB5->ZB5_TABELA+"' AND DA1_CODPRO = '"+SB1->B1_COD+"' "
				//	cQry += "AND DA1_TPOPER = '"+_TpOper+"' AND DA1_QTDLOT > '"+cValToChar(ZB6I->ZB6_QTDVEN)+"' "
				cQry += "AND DA1_TPOPER = '"+_TpOper+"' AND DA1_QTDLOT > '"+cValToChar(_nQtdZB62)+"' "

			Elseif SB1->B1_GRADE = 'S'

				cQry := "SELECT TOP 1 DA1_TIPPRE,DA1_QTDLOT "
				cQry += "FROM DA1010 DA1 "
				cQry += "WHERE DA1.D_E_L_E_T_<>'*' AND DA1_CODTAB='"+ZB5->ZB5_TABELA+"' AND DA1_REFGRD = '"+SUBSTR(SB1->B1_COD,1,6)+"' "
				cQry += "AND DA1_TPOPER = '"+_TpOper+"' AND DA1_QTDLOT > '"+cValToChar(_nQtdZB62)+"' "
			Endif
			memowrite("ZB6_da1x.txt",cQry)

			TcQuery cQry New Alias "DA1XX"
			DbSelectArea("DA1XX")
			DBGoTop()

/*			IF SB1->B1_GRADE = 'N'
			dbselectar("DA1")
			dbsetorder(1)
			dbseek(xfilial("DA1")+ZB5->ZB5_TABELA+SB1->B1_COD)
			
		Elseif SB1->B1_GRADE = 'S'
			dbselectar("DA1")
			dbsetorder(5)
			dbseek(xfilial("DA1")+ZB5->ZB5_TABELA+SUBSTR(SB1->B1_COD,1,6)+)
		Endif*/

			//AADD(aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
			AADD(aLinha,{'C6_FILIAL','01',NIL})
			AADD(aLinha,{'C6_ITEM',_numitem,NIL})
			AADD(aLinha,{'C6_PRODUTO',SB1->B1_COD,NIL})
			AADD(aLinha,{'C6_QTDVEN',ZB6I->ZB6_QTDVEN,NIL})
		//	alert('TIPPRE'+DA1XX->DA1_TIPPRE)
			
		If DA1XX->DA1_TIPPRE <> '5'
			_nPrcVen := ZB6I->ZB6_PRCVEN * (1-ZB5->ZB5_DESC/100)
		Else
			_nPrcVen := ZB6I->ZB6_PRCVEN
		Endif
			// Preco de Venda igual ao Preco Unitario para evitar desconto na NF. (tabela de precos).
		If DA1XX->DA1_TIPPRE <> '5'
			_nDesc := ZB5->ZB5_DESC//round((ZB6I->ZB6_PRUNIT-_nPrcVen)/ZB6I->ZB6_PRUNIT*100,2)
			_nDescont := ZB6I->ZB6_PRUNIT*ZB6I->ZB6_QTDVEN-_nPrcVen*ZB6I->ZB6_QTDVEN
		Else
			_nDesc := 0
		Endif
			
			//AADD(aLinha,{'C6_PRUNIT',ZB6I->ZB6_PRUNIT,NIL})
			AADD(aLinha,{'C6_PRCVEN',ZB6I->ZB6_PRUNIT,NIL})
			//AADD(aLinha,{'C6_PRCVEN',ZB6I->ZB6_PRCVEN,NIL})
		If _nDesc > 0
				AADD(aLinha,{'C6_DESCONT',_nDesc,NIL})
				//AADD(aLinha,{'C6_DESCONT',_nDescont,NIL})
				//				AADD(aLinha,{'C6_PRCVEN',ZB6I->ZB6_PRCVEN,NIL})
		Else
				//				AADD(aLinha,{'C6_PRCVEN',ZB6I->ZB6_PRCVEN,NIL})
				//AADD(aLinha,{'C6_DESCONT',_nDesc,NIL})
		EndIf
			DA1XX->(DbCloseArea())
			//			AADD(aLinha,{'C6_PRUNIT',ZB6I->ZB6_PRUNIT,NIL})
			//			AADD(aLinha,{'C6_VALOR',(ZB6I->ZB6_PRCVEN*ZB6I->ZB6_QTDVEN),NIL})
			AADD(aLinha,{'C6_OPER','50',NIL})
		If SA3->A3_TIPO == "I"
				AADD(aLinha,{'C6_COMIS1',SA3->A3_COMIS,NIL})
		Else
				AADD(aLinha,{'C6_COMIS1',SB1->B1_COMIS,NIL})
		EndIf

			//AADD(aLinha,{'C6_PRCVEN',ZB6I->ZB6_PRUNIT,NIL})   // Preco sem Impostos (ZB6_PRUNIT) esta diferente da entrada no Protheus barrando na regra.
			//AADD(aLinha,{'C6_PRUNIT',ZB6I->ZB6_PRUNIT,NIL})

			AADD(aLinha,{'C6_NUMPCOM'	,ZB5->ZB5_OC	,NIL})
			AADD(aLinha,{'C6_ITEMPC'	,_numitem	,NIL})
			//	AADD(aLinha,{'C6_OP','',NIL})
			AADD(aItens,aLinha)
			ZB6I->(dbskip())
	Enddo
		ZB6I->(DbCloseArea())

	If Len(aItens) == 0
			Alert("Sem Itens")
	EndIf
	If Len(aItens) > 0 .and. Len(aCabecalho) > 0
			msExecAuto({|x,y,z|Mata410(x,y,z)},aCabecalho,aItens,3)
		If lmsErroAuto
				lErroimp:=.t.
				MOSTRAERRO()
				LMSERROAUTO:=.F.
		Else
				CONFIRMSX8()
				Reclock("ZB5",.F.)
				ZB5->ZB5_IMPORT := '1' //pedido importado
				ZB5->ZB5_OK 	:= '' //Limpa a marca
				ZB5->ZB5_NUM	:= SC5->C5_NUM
				MsUnlock()
				/*
		cUpd := "UPDATE SFA_FORTALEZA.dbo.ZC5010 "
		cUpd += "SET ZC5_IMPORTADO=1 "
		cUpd += "WHERE ZC5_NUM='"+ZC5I->ZC5_NUM+"' "
			If TcSqlExec(cUpd) <> 0
			Alert(TcSqlError())
			End
				*/
		Endif
	EndIf
END TRANSACTION
Return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½RFATX001  ï¿½Autor  ï¿½Microsiga           ï¿½ Data ï¿½  05/18/15   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ AP                                                        ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
User Function RGUAXX01
	If !MsgYesNo("Tem certeza que deseja remover este pedido da lista???")
		Return
	EndIf

	Reclock("ZB5",.F.)
	ZB5->ZB5_IMPORT	:= "2" //Cancelado
	MsUnlock()
	MsgInfo("Pedido retirado com sucesso!!!")
Return

User Function RGUASX01
	Processa({||Sincronizar(),"Sincronizando..."})
Return
