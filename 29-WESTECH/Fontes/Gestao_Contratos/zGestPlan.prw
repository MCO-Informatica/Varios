#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                        Low Intensity colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                      High Intensity Colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo de Gestao de Contratos                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico 		                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function zGestPlan()

Local nTotalGRS := 0
private cPerg 	:= 	"GPIN01"
private _cArq	:= 	"GPIN01.XLS"


private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cNProp		:= ""
private _cItemConta := CTD->CTD_ITEM
private _nPComiss 	:= 0
private _nXSISFV 	:= 0
private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
Private _aGrpSint:= {}

	//_cNProp 	:= SZ9->Z9_NPROP
    _cItemConta := CTD->CTD_ITEM

	//pergunte(cPerg,.F.)

	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif

	//MSAguarde({||zCustPlan()},"Processando Detalhamento Custo Planejado")

	//MSAguarde({||zDetProp()},"Processando Detalhamento Custo Vendido")
	
	MontaTela()

	TRB1->(dbclosearea())
	TRB2->(dbclosearea())

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a tela de visualizacao do Fluxo Sintetico            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function MontaTela()


private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbCUST

private _nOpc

Private oGet1, oGet2, oGet3, oGet4, oGet5, oGet6, oGet7, oGet8, oGet9, oGet10, oGet11, oGet12, oGet13, oGet14, oGet15, oGet16, oGet17, oGet18, oGet19, oGet20
Private oGet21, oGet22, oGet23, oGet24, oGet25, oGet26, oGet27, oGet28, oGet29, oGet30, oGet31, oGet132, oGet33, oGet34, oGet35, oGet36, oGet37, oGet38, oGet39, oGet40
Private oGet41, oGet42, oGet43, oGet44, oGet45, oGet46, oGet47, oGet48, oGet49, oGet50, oGet51, oGet152, oGet53, oGet54, oGet55, oGet56, oGet57, oGet59, oGet60
Private cGet1, cGet2, cGet3, cGet4, cGet5, cGet6, cGet7, cGet8, cGet9, cGet10, cGet11, cGet12, cGet13, cGet14, cGet15, cGet16, cGet17, cGet18, cGet19, cGet20
Private cGet21, cGet22, cGet23, cGet24, cGet25, cGet26, cGet27, cGet28, cGet29, cGet30, cGet31, cGet32, cGet33, cGet34, cGet35, cGet36, cGet37, cGet38,cGet39, cGet40
Private cGet41, cGet42, cGet43, cGet44, cGet45, cGet46, cGet47, cGet48, cGet49, cGet50, cGet51, cGet52, cGet53, cGet54, cGet55, cGet56, cGet57, cGet59, cGet60
Private oComboBx1, oComboBx2, oComboBx3
Private oFolder1

static _oDlgSint

cCadastro :=  "Gestao de Custos - Proposta - " + _cNProp

DEFINE MSDIALOG _oDlgSint ;
TITLE "Gestao de Propostas - Custos.... - " + _cNProp ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

 @ aPosObj[1,1]+2,aPosObj[1,2] FOLDER oFolder1 SIZE  aPosObj[1,4],aPosObj[1,3]-10 OF _oDlgSint ;
	  	ITEMS "Detalhamento", "Custos" COLORS 0, 16777215 PIXEL
	  	
/////////zCabecGC()
/////////zTelaCustos()

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
SZ9->(DbGoTop())

SZ9->(DbSeek(xFilial('SZ9')+_cNProp))
//zTelaCustos()

//aadd(aButton , { "BMPTABLE" , { || zExpExcGC01()}, "Export. Custos Excel " } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
//aadd(aButton , { "BMPTABLE" , { || PRNGCRes()}, "Imprimir " } )


ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| zSalvar(),_oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return


//**************************///***********
/*
private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbCUST

private _nOpc

Private oGet1, oGet2, oGet3, oGet4, oGet5, oGet6, oGet7, oGet8, oGet9, oGet10, oGet11, oGet12, oGet13, oGet14, oGet15, oGet16, oGet17, oGet18, oGet19, oGet20
Private oGet21, oGet22, oGet23, oGet24, oGet25, oGet26, oGet27, oGet28, oGet29, oGet30, oGet31, oGet132, oGet33, oGet34, oGet35, oGet36, oGet37, oGet38, oGet39, oGet40
Private oGet41, oGet42, oGet43, oGet44, oGet45, oGet46, oGet47, oGet48, oGet49, oGet50, oGet51, oGet152, oGet53, oGet54, oGet55, oGet56, oGet57, oGet59, oGet60
Private cGet1, cGet2, cGet3, cGet4, cGet5, cGet6, cGet7, cGet8, cGet9, cGet10, cGet11, cGet12, cGet13, cGet14, cGet15, cGet16, cGet17, cGet18, cGet19, cGet20
Private cGet21, cGet22, cGet23, cGet24, cGet25, cGet26, cGet27, cGet28, cGet29, cGet30, cGet31, cGet32, cGet33, cGet34, cGet35, cGet36, cGet37, cGet38,cGet39, cGet40
Private cGet41, cGet42, cGet43, cGet44, cGet45, cGet46, cGet47, cGet48, cGet49, cGet50, cGet51, cGet52, cGet53, cGet54, cGet55, cGet56, cGet57, cGet59, cGet60
Private oComboBx1, oComboBx2, oComboBx3
Private oFolder1

static _oDlgPln

cCadastro :=  "Gestao de Custo Planejado - Contrato - " + _cItemConta

DEFINE MSDIALOG _oDlgPln ;
TITLE "Gestao de Custo Planejado - Contrato - " + _cItemConta ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

 @ aPosObj[1,1]+2,aPosObj[1,2] FOLDER oFolder1 SIZE  aPosObj[1,4],aPosObj[1,3]-10 OF _oDlgPln ;
	  	ITEMS "Detalhamento", "Custo Planejado", "Custo Vendido" COLORS 0, 16777215 PIXEL
	  	
//zCabecGC()
//zTelaCustos()
//zTelaCV()

DbSelectArea("CTD")
CTD->(DbSetOrder(1)) //B1_FILIAL + B1_COD
CTD->(DbGoTop())

CTD->(DbSeek(xFilial('CTD')+_cItemConta))

ACTIVATE MSDIALOG _oDlgPln ON INIT EnchoiceBar(_oDlgPln,{|| zSalvar(),_oDlgPln:End()}, {||_oDlgPln:End()},, aButton)
*/



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre os arquivos necessarios                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function AbreArq()
local aStru 	:= {}


if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Não foi possível abrir o arquivo GCIN01.XLS pois ele pode estar aberto por outro usuário.")
	return(.F.)
endif

/******** CAMPOS DETALHES CUSTOS PROPOSTA ***************/
aStru := {}
aAdd(aStru,{"GRUPO"		,"C",06,0}) // GRUPO
aAdd(aStru,{"ITEM"		,"C",80,0}) // DESCRICAO ITEM
aAdd(aStru,{"QUANT"		,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VUNIT"		,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"TOTAL"		,"N",15,2}) // TOTAL
aAdd(aStru,{"QUANTLB"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VUNITLB"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"TOTLB"		,"N",15,2}) // TOTAL
aAdd(aStru,{"QUANTEF"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VUNITEF"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"TOTEF"		,"N",15,2}) // TOTAL
aAdd(aStru,{"TOTGR"		,"N",15,2}) // TOTAL
aAdd(aStru,{"NPROP"		,"C",13,0}) // NUMERO PROPOSTA
aAdd(aStru,{"ITEMCTA"	,"C",13,0}) // ITEM CONTA
aAdd(aStru,{"GS"		,"C",01,0}) // GRUPO OU SUBGRUPO
aAdd(aStru,{"PLAN"		,"C",02,0}) // GRUPO OU SUBGRUPO

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.F.,.F.)
index on GRUPO to &(cArqTrb1+"1")
set index to &(cArqTrb1+"1")

aStru := {}
aAdd(aStru,{"VGRUPO"	,"C",06,0}) // GRUPO
aAdd(aStru,{"VITEM"		,"C",80,0}) // DESCRICAO ITEM
aAdd(aStru,{"VQUANT"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VVUNIT"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"VTOTAL"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VQUANTLB"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VVUNITLB"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"VTOTLB"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VQUANTEF"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VVUNITEF"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"VTOTEF"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VTOTGR"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VNPROP"	,"C",13,0}) // NUMERO PROPOSTA
aAdd(aStru,{"VITEMCTA"	,"C",13,0}) // ITEM CONTA
aAdd(aStru,{"VGS"		,"C",01,0}) // GRUPO OU SUBGRUPO
aAdd(aStru,{"VPLAN"		,"C",02,0}) // GRUPO OU SUBGRUPO

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on VGRUPO to &(cArqTrb2+"1")
set index to &(cArqTrb2+"1")

return(.T.)

static function VldParam()

/*
if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
	msgstop("Todas as datas dos parâmetros devem ser informadas.")
	return(.F.)
endif

if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
	msgstop("A data de início do processamento deve ser menor ou igual a data de referência.")
	return(.F.)
endif

if _dDataFim < _dDtRef // Data de fim menor que data de referencia
	msgstop("A data de final do processamento deve ser maior ou igual a data de referência.")
	return(.F.)
endif
*/
return(.T.)
