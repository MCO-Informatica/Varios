#define Confirma 1
#define Redigita 2
#define Abandona 3
#include "FONT.CH"
#INCLUDE "COLORS.CH"
#Include "FIVEWIN.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Ap5Mail.ch"
#include "Protheus.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ GPPRIC01 ณ Autor ณ PrimaInfo             ณ Data ณ 12/09/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cadastro de Pendencias por Funcionario                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Menu                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function GPPRIC01()

LOCAL aIndexSRA		:= {}		//Variavel Para Filtro

Private bFiltraBrw 	:= {|| Nil}//Variavel para Filtro

PRIVATE aRotina := {	{ "Pesquisar"  , "PesqBrw", 0 , 1},;  //"Pesquisar"
{ "Visualizar" , "U_FZXCATU", 0 , 2},;  //"Visualizar"
{ "Incluir"    , "U_FZXCATU", 0 , 4},;  //"Incluir"
{ "Alterar"      , "U_FZXCATU", 0 , 4},;  //"Alterar"
{ "Baixa em Lote","U_GPPRIAVPEN", 0 , 4},;  //"Alterar"
{ "Imprime Avisos","U_GPPRIAV02()", 0 , 4},;  //"Alterar"
{ "Excluir"      , "U_FZXCATU", 0 , 5} }  //"Excluir"

cCadastro := OemToAnsi("Pendencias por Funcionario")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se o Arquivo Esta Vazio                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !ChkVazio("SRA")
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa o filtro utilizando a funcao FilBrowse                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFiltraRh 	:=	""
bFiltraBrw 	:= 	{|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH) }
Eval(bFiltraBrw)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Endereca a funcao de BROWSE                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SRA")
mBrowse( 6, 1,22,75,"SRA",,,,,,fcriacor() )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Deleta o filtro utilizando a funcao FilBrowse                     	   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
EndFilBrw("SRA",aIndexSRA)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณZXCAtu    ณ Autor ณ IDE                   ณ Data ณ 01/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa de (Vis.,Inc.,Alt. e Exc.                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ ZXCAtu(ExpC1,ExpN1,ExpN2)                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Alias do arquivo                                   ณฑฑ
ฑฑณ          ณ ExpN1 = Numero do registro                                 ณฑฑ
ฑฑณ          ณ ExpN2 = Numero da opcao selecionada                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ ZXC                                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FZXCAtu(cAlias,nReg,nOpcx)

Local cSaveMenuh
Local nCnt
Local GetList	:=	{}
Local aXXXField :=	{"ZXC_FILIAL","ZXC_MAT"}
Local nStt      :=	2
Local nLenght	:=	Len(aXXXField)-1
Local cMat      := 	SRA->RA_MAT
Local c_FilFun	:=  SRA->RA_FILIAL
Local nSavRec   := 	RecNo()
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local oFont
Local oGroup

Private aColsRec := {}   //--Array que contem o Recno() dos registros da aCols

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega Array de Campos Alteraveis                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cAlias := "ZXC"

While .T.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se existe algum dado no arquivo                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea( cAlias )
	dbSeek( c_FilFun + cMat )
	nCnt := 0
	(cAlias)->(dbEval({||nCnt++},,{||ZXC_FILIAL + ZXC_MAT  == xFilial(cAlias) + cMat }))

	If nCnt > 0  .And. nOpcx = 3    //--Quando Inclusao e existir Registro
		Aviso("Atencao","Ja existe movimento. Utilize a opcao Alterar.",{'OK'})
		Exit
	Elseif nCnt = 0 .And. nOpcx # 3  //--Quando Nao for Inclusao e nao existir Registro
		Aviso("Atencao","Nao existe movimento. Utilize a opcao incluir.",{'OK'})
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a entrada de dados do arquivo                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta o cabecalho                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PLXXXaHead(aXXXField)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona ponteiro do arquivo cabeca e inicializa variaveis  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nOpcA := 0

	//--Quando for Inclusao criar com 1 elemento
	nCnt := If (nOpcx = 3,1,nCnt)
	PRIVATE aCOLS[nCnt][nUsado+If(nOpcx=2 .Or. nOpcx=5,0,1)]

	nCnt   :=0
	nUsado :=0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gerar o array aCols
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PLXXXAcols(aXXXField,nOpcx)

	nOpca := 0

	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ Monta as Dimensoes dos Objetos         					   ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	aAdvSize		:= MsAdvSize()
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Pendencias por Funcionario") From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL
	@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] - 3 ),( ( aObjSize[1,4]/100*10 - 2 ) )				LABEL OemToAnsi("Matricula") OF oDlg PIXEL
	oGroup:oFont:= oFont
	@ aObjSize[1,1] , ( ( aObjSize[1,4]/100*10 ) ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),( aObjSize[1,4]/100*60 - 2 )	LABEL OemToAnsi("Nome") OF oDlg PIXEL
	oGroup:oFont:= oFont
	@ aObjSize[1,1] , ( aObjSize[1,4]/100*60 ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),aObjSize[1,4]						LABEL OemToAnsi("Admissao") OF oDlg PIXEL
	oGroup:oFont:= oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 )+10 ) , ( aObjSize[1,2] + 5 )				SAY SRA->RA_MAT	SIZE 050,10 OF oDlg PIXEL FONT oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 )+10 ) , ( ( aObjSize[1,4]/100*10 ) + 5 )	SAY OemToAnsi(SRA->RA_NOME) SIZE 146,10 OF oDlg PIXEL FONT oFont
	@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 )+10 ) , ( ( aObjSize[1,4]/100*60 ) + 5 )	SAY DTOC(SRA->RA_ADMISSA) SIZE 080,10 OF oDlg PIXEL FONT oFont

	oGet := MSGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],nOpcx,"U_ZXCLinOk","U_ZXCTudOk","",If(nOpcx=2.Or.nOpcx=5,Nil,.T.),,1)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca:=If(nOpcx=5,2,1),If(oGet:TudoOk(),oDlg:End(),nOpca:=0)},{||oDlg:End()})

	//--Se nao for Exclusao
	If nOpcx # 5
		IF nOpcA == Redigita
			LOOP
		ELSEIF nOpcA == Confirma .And. nOpcx # 2
			Begin Transaction
			//--Gravacao
			PLXXXGrava(cAlias,nOpcx)
			//--Processa Gatilhos
			EvalTrigger()
			End Transaction
		Endif
		//--Se for Exclusao
	Elseif nOpca = 2 .And. nOpcx = 5
		Begin Transaction
		PLXXXDele()
		End Transaction
	Endif

	Exit
EndDo
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura a integridade da janela                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cAlias := "SRA"
dbSelectArea(cAlias)
Go nSavRec

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณgpXXXDele ณ Autor ณ IDE                   ณ Data ณ 01/06/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Deleta os RegistroS                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PLXXXDele                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function PLXXXDele()

Local cAlias := "ZXC"
Local nx

nCnt := 0
For nx = 1 to Len(aCols)
	dbSeek(SRA->RA_FILIAL + SRA->RA_MAT )
	RecLock(cAlias,.F.,.T.)
	dbDelete( )
	MsUnlock()
	nCnt++
Next nx
WRITESX2(cAlias,nCnt)
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณgpXXXaHeadณ Autor ณ IDE                   ณ Data ณ 01/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Criar os Arrays Aheader e aCols                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PLeaXXX                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function PLXXXaHead(aXXXField)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva a integridade dos campos de Bancos de Dados            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SX2->(dbSeek("ZXC"))

SX3->(dbSetOrder(1))
SX3->(dbSeek("ZXC"))

While SX3->(!EOF()) .And. (SX3->X3_ARQUIVO == "ZXC")
	IF x3uso(SX3->X3_USADO) .AND. cNivel >= SX3->x3_NIVEL .and. ! ASCAN(aXXXField,Trim(SX3->X3_CAMPO)) > 0 .And. !Alltrim(SX3->X3_CAMPO) $ "ZXC_FILIAL-ZXC_MAT   "
		nUsado++
		AADD(aHeader,{ TRIM(x3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE,;
		SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID,;
		SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO } )
	Endif
	SX3->(dbSkip())
EndDo

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณgXXXaCols ณ Autor ณ IDE                   ณ Data ณ 01/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Criar os Arrays Aheader e aCols                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PLeaXXX                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function PLXXXaCols(aXXXField,nOpcx)

Local cAlias := "ZXC"
Local nCampo
Local nCnt

nCnt := 0
dbSelectArea(cAlias)
If 	dbSeek(SRA->RA_FILIAL + SRA->RA_MAT )
	While !EOF() .And. ZXC_FILIAL + ZXC_MAT == SRA->RA_FILIAL + SRA->RA_MAT
		nCnt++
		nUsado:=0
		SX3->(dbSetOrder(1))
		SX3->(dbSeek( cAlias ))
		While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cAlias
			If x3uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .and. ASCAN(aXXXField,Trim(SX3->X3_CAMPO)) = 0  .And. !Alltrim(SX3->X3_CAMPO) $ "ZXC_FILIAL-ZXC_MAT   "
				nUsado++
				If SX3->X3_CONTEXT == "V"
					aCOLS[nCnt][nUsado] := &(SX3->X3_INIBRW)
				Else
					aCOLS[nCnt][nUsado] := &(cAlias+"->"+SX3->X3_CAMPO)
				Endif
			Endif
			SX3->(dbSkip())
		EndDo
		If nOpcx # 2 .And. nOpcx # 5
			aCOLS[nCnt][nUsado+1] := .F.
		Endif
		dbSelectArea( cAlias )
		Aadd(aColsRec,Recno())
		dbSkip()
	EndDo
Else
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	dbseek(cAlias)
	nUsado:=0
	While !EOF() .And. (SX3->X3_ARQUIVO == cAlias)
		IF x3uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .and. ASCAN(aXXXField,Trim(SX3->X3_CAMPO)) = 0  .And. !Alltrim(SX3->X3_CAMPO) $ "ZXC_FILIAL-ZXC_MAT   "
			nUsado++
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Monta Array do 1ง Elemento Vazio. Se Inclusao                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF SX3->X3_TIPO == "C"
				aCOLS[1][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
			ELSEIF SX3->X3_TIPO == "N"
				aCOLS[1][nUsado] := 0
			ELSEIF SX3->X3_TIPO == "D"
				aCOLS[1][nUsado] := dDataBase
			ELSE
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
		dbSkip()
	EndDo
	aCOLS[1][nUsado+1] := .F.
Endif

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ                   ROTINAS DE CRITICA DE CAMPOS                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณgpXXXGravaณ Autor ณ IDE                   ณ Data ณ 01/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Grava no arquivo                                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PLXXXGrava                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function PLXXXGrava(cAlias)

Local n
Local ny		:=	0
Local nMaxArray	:=	Len(aHeader)

dbSelectArea(cAlias)

For n:=1 TO Len(aCols)

	If n <= Len(aColsRec)
		dbGoto(aColsRec[n])
		RecLock(cAlias,.F.,.T.)
		//--Verifica se esta deletado
		If aCols[n,nUsado+1]  # .F.
			dbDelete()
			Loop
		Endif
	Else
		//--Verifica se Nao esta Deletado no aCols
		If aCols[n,nUsado+1]  = .F.
			RecLock(cAlias,.T.,.T.)
			ZXC->ZXC_FILIAL	:=	SRA->RA_FILIAL
			ZXC->ZXC_MAT 	:=	SRA->RA_MAT
		Else
			Loop
		Endif
	Endif
	For ny := 1 To nMaxArray
		cCampo    := Trim(aHeader[ny][2])
		xConteudo := aCols[n,ny]
		Replace &cCampo With xConteudo
	Next ny
	MsUnlock()
Next n

MsUnlock()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณgpXXXLinOkณ Autor ณ IDE                   ณ Data ณ 01/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCritica linha digitada                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PLEAXXX                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function ZXCLinOk()

Local lRet		:= .T.

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณgpXXXTudOkณ Autor ณ IDE                   ณ Data ณ 01/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PLEAXXX                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function ZXCTudOk(o)

Local lRetorna	:= .T.

Return lRetorna

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ZXCVLDTP ณ Autor ณ IDE                   ณ Data ณ 01/06/05 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ vALIDa O zxc_tipo                                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ PLEAXXX                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function ZXCVDLTP(n_Tipo)

Local lRetorna	:= .F.
Local c_Descri	:= ""
Local n_prazo	:= 0
Local a_area	:= GetArea()

dbSelectArea("RCC")
dbSetOrder(4)
If dbSeek(xFilial("RCC")+"U00D")
	While !RCC->(Eof()) .And. RCC->RCC_CODIGO = "U00D"
		If Subs(RCC->RCC_CONTEU,1,2) == M->ZXC_TIPO
			c_Descri	:= SUBS(RCC->RCC_CONTEU,3,20)
			lRetorna	:= .t.
			n_prazo		:= Val(SUBS(RCC->RCC_CONTEU,23,2))
		Endif
		RCC->(dbSkip())
	Enddo
Endif

RestArea(a_area)

//Validacao
If n_Tipo = 1
	Return lRetorna
Elseif n_Tipo = 2
	//Gatilho Descricao
	Return c_Descri
Elseif n_Tipo = 3
	//Gatilho Prazo
	Return n_Prazo
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPPRIAVPENบAutor  ณMarco Antonio Silva บ Data ณ  19/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe pendencias dos funcionarios - Tabela ZXC             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPPRIAVPEN()

Private oDlg
Private a_Dados := {}
Private aHeader1:= 'Status'
Private aHeader2:= {}
Private cTitulo := "Pendecias dos Funcionarios"
Private nContador := 0
Private cCor := ''
Private l_Vazia	:= .f.
Private c_UserAvis	:= AllTrim(Posicione("RCA",1,xFilial("RCA")+"M_USERAVIS","RCA_CONTEU"))

//Verifica se a tabela ZXC esta vazia - Se estiver e implantacao
dbSelectArea("ZXC")
If ZXC->(Eof())
	l_Vazia := .T.
Endif

//Mostra os avisos via rotina ou para usuarios definidos no parametro (ao entrar no SIGAGPE a 1a vez)
If FUNNAME() == "GPPRIC01" .Or. __CUSERID $ c_UserAvis
	//Gera Pendencias Experiencia
	GERAEXP()

	//Gera Termino de Contrato Determinado
	GERATCD()

	//Gera Ferias em Dobro
	GERAFERD()

	Processa({ || PProcAviso() }, "Espere Processando!!")
EndIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ProcavisoบAutor  ณMarco Antonio Silva บ Data ณ  19/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe pendencias dos funcionarios - Tabela ZXC             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PProcAviso()

Local cQuery := ''
Local aCampos	:= {}

Private aRotina := { 	{ "Baixar Selecionados",'U_GPPRIAV01()',0,6}}//,;	//"Efetivar Selecionados"
//{ "Imprime os Avisos",'U_GPPRIAV02()()',0,7} }	//"Impressao
Private cCadastro := "Pendencias Funcionarios"
Private cLog		:= ""
Private bMark    := {|| Mark()}
Private cMarca   := getMark()

aCampos:={}
AADD(aCampos,{"OK"	    	,"C",02,0})
AADD(aCampos,{"RA_FILIAL"	,"C",TamSX3("RA_FILIAL")[1],0})
AADD(aCampos,{"RA_MAT"		,"C",TamSX3("RA_MAT")[1],0})
AADD(aCampos,{"RA_NOME"		,"C",TamSX3("RA_NOME")[1],0})
AADD(aCampos,{"ZXC_DPREV"	,"D",8,0})
AADD(aCampos,{"ZXC_TIPO" 	,"C",TamSX3("ZXC_TIPO")[1],0})
AADD(aCampos,{"ZXC_TDESC" 	,"C",TamSX3("ZXC_TDESC")[1],0})
AADD(aCampos,{"RA_ADMISSA"	,"D",8,0})
AADD(aCampos,{"RA_SITFOLH"	,"C",1,0})
AADD(aCampos,{"RA_CATFUNC"	,"C",1,0})
AADD(aCampos,{"RA_CC" 	,"C",TamSX3("RA_CC")[1],0})
AADD(aCampos,{"CTT_DESC01" 	,"C",TamSX3("CTT_DESC01")[1],0})
AADD(aCampos,{"RA_CODFUNC" 	,"C",TamSX3("RA_CODFUNC")[1],0})
AADD(aCampos,{"RJ_DESC" 	,"C",TamSX3("RJ_DESC")[1],0})
cNomeArq  := CriaTrab(aCampos)

cQuery := "SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,ZXC_DPREV,ZXC_TIPO,ZXC_TDESC,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RA_SITFOLH,RA_CATFUNC,ZXC_DIASAV
cQuery += " FROM "+RetSqlName("SRA") + " A, "+RetSqlName("CTT") + " B, "+RetSqlName("SRJ") + " C, "+RetSqlName("ZXC") + " D
cQuery += " WHERE A.D_E_L_E_T_ = ' '
cQuery += " AND B.D_E_L_E_T_ = ' '
cQuery += " AND C.D_E_L_E_T_ = ' '
cQuery += " AND D.D_E_L_E_T_ = ' '
cQuery += " AND RA_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR CTT_FILIAL = RA_FILIAL)
cQuery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RJ_FILIAL = RA_FILIAL)
cQuery += " AND RA_SITFOLH <> 'D'
cQuery += " AND ZXC_FILIAL = RA_FILIAL AND ZXC_MAT = RA_MAT
cQuery += " AND ZXC_STATUS <> 'B'
cQuery += " ORDER BY ZXC_DPREV,RA_FILIAL,RA_MAT,ZXC_TIPO

cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "TRB"
TcSetField("TRB","RA_ADMISSA" ,"D",8,0)
TcSetField("TRB","ZXC_DPREV"  ,"D",8,0)

dbSelectArea( "TRB" )
dbgotop()
_carq:="T_"+Criatrab(,.F.)
MsCreate(_carq,aCampos,"DBFCDX")
dbUseArea(.T.,"DBFCDX",_cARq,"WZXC",.T.,.F.)
Dbselectarea("TRB")
DBGOTOP()
While !Eof()
	If TRB->ZXC_DPREV <= (DATE() + TRB->ZXC_DIASAV)
		DbSelectArea("WZXC")
		Reclock("WZXC",.T.)
		RA_FILIAL	:=	TRB->RA_FILIAL
		RA_MAT		:=	TRB->RA_MAT
		RA_NOME		:=	TRB->RA_NOME
		ZXC_DPREV	:=	TRB->ZXC_DPREV
		ZXC_TIPO	:=	TRB->ZXC_TIPO
		ZXC_TDESC	:=	TRB->ZXC_TDESC
		RA_ADMISSA	:=	TRB->RA_ADMISSA
		RA_SITFOLH  :=	TRB->RA_SITFOLH
		RA_CATFUNC  :=	TRB->RA_CATFUNC
		RA_CC		:=	TRB->RA_CC
		CTT_DESC01	:=	TRB->CTT_DESC01
		RA_CODFUNC	:=	TRB->RA_CODFUNC
		RJ_DESC		:=	TRB->RJ_DESC
		MsUnLock()
	Endif
	DbSelectArea("TRB")
	DbSkip()
EndDo
dbSelectArea("TRB")
dbCloseArea()

aCampos := {}
AADD(aCampos,{"OK"        	,"","  "})
AADD(aCampos,{"RA_FILIAL"	,"",NomeCampo("RA_FILIAL")})
AADD(aCampos,{"RA_MAT" 		,"",NomeCampo("RA_MAT")})
AADD(aCampos,{"RA_NOME" 	,"",NomeCampo("RA_NOME")})
AADD(aCampos,{"ZXC_DPREV" 	,"",NomeCampo("ZXC_DPREV")})
AADD(aCampos,{"ZXC_TIPO" 	,"",NomeCampo("ZXC_TIPO")})
AADD(aCampos,{"ZXC_TDESC" 	,"",NomeCampo("ZXC_TDESC")})
AADD(aCampos,{"RA_ADMISSA" 	,"",NomeCampo("RA_ADMISSA")})
AADD(aCampos,{"RA_SITFOLH" 	,"",NomeCampo("RA_SITFOLH")})
AADD(aCampos,{"RA_CATFUNC" 	,"",NomeCampo("RA_CATFUNC")})
AADD(aCampos,{"RA_CC"  		,"",NomeCampo("RA_CC")})
AADD(aCampos,{"CTT_DESC01" 	,"",NomeCampo("CTT_DESC01")})
AADD(aCampos,{"RA_CODFUNC" 	,"",NomeCampo("RA_CODFUNC")})
AADD(aCampos,{"RJ_DESC" 	,"",NomeCampo("RJ_DESC")})

dbSelectArea("WZXC")
MarkBrow("WZXC","OK",,aCampos,,cMarca) //,,,,,"eval(bMark)")
dbSelectArea("WZXC")
dbCloseArea()
If File(_cArq+GetDBExtension())
	Ferase(_cArq+GetDBExtension())
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPPRIC01  บAutor  ณMicrosiga           บ Data ณ  04/14/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPPRIAV01()

Local aArea 	:= GetArea()
Local cMarca	:= ThisMark()
Local lInverte	:= ThisInv()
Local nDif		:= 0
If !MsgNoYes( "Confirma a baixa dos itens marcados?", "Baixa Avisos" )
	Return
Endif

WZXC->( dbGoTop() )
Begin Transaction
While !WZXC->( EOF() )
	If IsMark("OK", cMarca) //, lInverte)
		DbSelectArea( 'ZXC' )
		DbSetOrder(1)
		If DbSeek( WZXC->( RA_FILIAL + RA_MAT + dtos(ZXC_DPREV) + ZXC_TIPO ), .F. )
			//-- Ajustar as horas
			RecLock( "ZXC", .F. )
			ZXC->ZXC_STATUS := "B"
			ZXC->ZXC_DBAIXA := MsDate()
			ZXC->ZXC_USERBX := substr(CUSUARIO,7,15)
			ZXC->( MsUnLock() )
		EndIf
	EndIf
	DbSelectArea( "WZXC" )
	WZXC->( dbSkip() )
EndDo
End Transaction

RestArea( aArea )

CloseBrowse()

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPONA002  บAutor  ณMicrosiga           บ Data ณ  10/17/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NomeCampo( cCampo)

Local cTitulo := ""

dbSelectArea('SX3')
dbSetOrder(2)
If dbSeek( cCampo )
	cTitulo := Alltrim(X3Titulo())
EndIf

Return cTitulo
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPPRIC01  บAutor  ณMicrosiga           บ Data ณ  04/14/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Mark()

Local nRecno := WZXC->(Recno())
Local lDesmarc := IsMark("WZXC->OK", ThisMark(), .t.)
if !Eof()
	If !lDesmarc
		DbSelectArea("WZXC")
		dbgoto(nRecno)
		RecLock("WZXC",.F.)
		Replace OK With Space(2)
		MsUnlock()
	Else
		DbSelectArea("WZXC")
		dbgoto(nRecno)
		RecLock("WZXC",.F.)
		Replace OK With cMarca
		MsUnlock()
	EndIf
endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPPRIC01  บAutor  ณMicrosiga           บ Data ณ  04/14/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPPRIAV02()

Local oExcel		:= FWMSEXCEL():New()
Local nI			:= 0
Local _aStruct	:= {}
Local _aRow		:= {}
Local _aAlias		:= {GetNextAlias()}
Local aWSheet		:= {{"Pendencias Funcionarios"}}				//05

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())

	For xz := 1 to Len(_aStruct)
		If Alltrim(_aStruct[xz,1]) $ "RA_ADMISSA/ZXC_DPREV"
			TCSetField(_aAlias[nI],_aStruct[xz,1], "D", 08, 0 )
		Endif
	Next xz

	aEval(_aStruct,{|x| oExcel:AddColumn(aWSheet[nI][1],aWSheet[nI][1],If(Empty(cTitulo:=Posicione("SX3",2,x[1],"X3_TITULO")),x[1],cTitulo),2,1)})
	//oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col1",2,1)
	(_aAlias[nI])->(DbGoTop())
	While (_aAlias[nI])->(!Eof())
		If (_aAlias[nI])->&("ZXC_DPREV") <= (DATE() + (_aAlias[nI])->&("ZXC_DIASAV"))
			_aRow := Array(Len(_aStruct))
			nX := 0
			aEval(_aStruct,{|x| nX++,_aRow[nX] := (_aAlias[nI])->&(x[1])})
			oExcel:AddRow(aWSheet[nI][1],aWSheet[nI][1],_aRow)
		Endif
		(_aAlias[nI])->(DbSkip())
	EndDo
Next

oExcel:Activate()

cFolder := cGetFile("XML | *.XML", OemToAnsi("Informe o diretorio.",1,7),,,,nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE))
cFile := cFolder+".XML"

oExcel:GetXMLFile(cFile)

MsgInfo("Arquivo gerado com sucesso, sera aberto apos o fechamento dessa mensagem." + CRLF + cFile)

If ApOleClient("MsExcel")
	oExcelApp:=MsExcel():New()
	oExcelApp:WorkBooks:Open(cFile)
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo("Excel nao instaldo!"+chr(13)+chr(10)+"Relatorio gerado com sucesso, arquivo gerado no diretorio abaixo: "+chr(13)+cFile)
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPPRIC01  บAutor  ณMicrosiga           บ Data ณ  04/14/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetTable(_cAlias,nTipo)

Local cQuery := ""
Local cTipoDB := UPPER(Alltrim(TCGetDB()))

cQuery := ""
cquery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,ZXC_DPREV,ZXC_TIPO,ZXC_TDESC,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RA_SITFOLH,RA_CATFUNC,ZXC_DIASAV
cquery += " FROM "+RetSqlName("SRA") + " A, "+RetSqlName("CTT") + " B, "+RetSqlName("SRJ") + " C, "+RetSqlName("ZXC") + " D
cquery += " WHERE A.D_E_L_E_T_ = ' '
cquery += " AND B.D_E_L_E_T_ = ' '
cquery += " AND C.D_E_L_E_T_ = ' '
cquery += " AND D.D_E_L_E_T_ = ' '
cquery += " AND RA_CC = CTT_CUSTO AND (CTT_FILIAL = ' ' OR CTT_FILIAL = RA_FILIAL)
cquery += " AND RA_CODFUNC = RJ_FUNCAO AND (RJ_FILIAL = ' ' OR RJ_FILIAL = RA_FILIAL)
cquery += " AND RA_SITFOLH <> 'D'
cquery += " AND ZXC_FILIAL = RA_FILIAL AND ZXC_MAT = RA_MAT
cquery += " AND ZXC_STATUS <> 'B'
cquery += " ORDER BY ZXC_DPREV,RA_FILIAL,RA_MAT

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .F.)
(_cAlias)->(DBGOTOP())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GERAEXP  บAutor  ณMarco Antonio Silva บ Data ณ  21/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Pendencias Proximas Admissoes                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GERAEXP()

Local cQuery := ''
Local c_Descri	:= ""
Local n_prazo	:= 0

//Carrega descricao e dias de aviso da Experiencia
dbSelectArea("RCC")
dbSetOrder(4)
If dbSeek(xFilial("RCC")+"U00D")
	While !RCC->(Eof()) .And. RCC->RCC_CODIGO = "U00D"
		If Subs(RCC->RCC_CONTEU,1,2) == "01"
			c_Descri	:= SUBS(RCC->RCC_CONTEU,3,20)
			n_prazo		:= Val(SUBS(RCC->RCC_CONTEU,23,2))
		Endif
		RCC->(dbSkip())
	Enddo
Endif

IF SELECT("WSRA") > 0
	WSRA->(dbClosearea())
Endif

cQuery += "SELECT T.* FROM ("
cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_VCTOEXP"
cQuery += " FROM " + RetSqlName("SRA") + " SRA"
cQuery += " WHERE"
cQuery += "     SRA.D_E_L_E_T_ = ' '"
cQuery += " AND RA_SITFOLH <> 'D'"
cQuery += " AND RA_CATFUNC IN ('M','H')"
cQuery += " AND NOT EXISTS"
cQuery += " (SELECT * FROM " + RetSqlName("ZXC") + " WHERE D_E_L_E_T_ = ' ' AND ZXC_FILIAL = RA_FILIAL AND ZXC_MAT = RA_MAT AND RA_VCTOEXP = ZXC_DPREV AND ZXC_TIPO = '01' )"
cQuery += " UNION ALL"
cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_VCTEXP2 AS RA_VCTOEXP"
cQuery += " FROM " + RetSqlName("SRA") + " SRA"
cQuery += " WHERE"
cQuery += "     SRA.D_E_L_E_T_ = ' '"
cQuery += " AND RA_SITFOLH <> 'D'"
cQuery += " AND RA_CATFUNC IN ('M','H')"
cQuery += " AND NOT EXISTS"
cQuery += " (SELECT * FROM " + RetSqlName("ZXC") + " WHERE D_E_L_E_T_ = ' ' AND ZXC_FILIAL = RA_FILIAL AND ZXC_MAT = RA_MAT AND RA_VCTEXP2 = ZXC_DPREV AND ZXC_TIPO = '01' )"
cQuery += " ) T"
cQuery += " ORDER BY RA_FILIAL,RA_MAT,RA_VCTOEXP"
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRA"
TcSetField( "WSRA", "RA_ADMISSA","D",08, 0 )
TcSetField( "WSRA", "RA_VCTOEXP","D",08, 0 )

dbSelectArea( "WSRA" )
If Used()
	While !WSRA->(Eof())
		dbSelectArea("ZXC")
		RecLock("ZXC",.T.)
		ZXC->ZXC_FILIAL	:= WSRA->RA_FILIAL
		ZXC->ZXC_MAT		:= WSRA->RA_MAT
		ZXC->ZXC_DINCLU	:= Date()
		ZXC->ZXC_TIPO	:= "01"
		ZXC->ZXC_TDESC	:= c_Descri
		ZXC->ZXC_DPREV	:= WSRA->RA_VCTOEXP
		ZXC->ZXC_DIASAV	:= n_prazo
		If l_Vazia .And. WSRA->RA_VCTOEXP < DATE()
			ZXC->ZXC_STATUS	:= "B"
			ZXC->ZXC_DBAIXA	:= DATE()
			ZXC->ZXC_USERBX	:= "IMPLANTACAO"
		Else
			ZXC->ZXC_STATUS	:= "P"
		Endif
		MsUnLock()
		dbSelectArea( "WSRA" )
		WSRA->(dbSkip())
	Enddo
EndIf

WSRA->(dbClosearea())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GERATCD  บAutor  ณMarco Antonio Silva บ Data ณ  21/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Pendencias Contrato Determinado                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GERATCD()

Local cQuery := ''
Local c_Descri	:= ""
Local n_prazo	:= 0

//Carrega descricao e dias de aviso da Experiencia
dbSelectArea("RCC")
dbSetOrder(4)
If dbSeek(xFilial("RCC")+"U00D")
	While !RCC->(Eof()) .And. RCC->RCC_CODIGO = "U00D"
		If Subs(RCC->RCC_CONTEU,1,2) == "02"
			c_Descri	:= SUBS(RCC->RCC_CONTEU,3,20)
			n_prazo		:= Val(SUBS(RCC->RCC_CONTEU,23,2))
		Endif
		RCC->(dbSkip())
	Enddo
Endif

IF SELECT("WSRA") > 0
	WSRA->(dbClosearea())
Endif

cQuery += "SELECT T.* FROM ("
cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DTFIMCT
cQuery += " FROM " + RetSqlName("SRA") + " SRA"
cQuery += " WHERE"
cQuery += "     SRA.D_E_L_E_T_ = ' '"
cQuery += " AND RA_SITFOLH <> 'D'"
cQuery += " AND RA_DTFIMCT <> ' '"
cQuery += " AND NOT EXISTS"
cQuery += " (SELECT * FROM " + RetSqlName("ZXC") + " WHERE D_E_L_E_T_ = ' ' AND ZXC_FILIAL = RA_FILIAL AND ZXC_MAT = RA_MAT AND RA_DTFIMCT = ZXC_DPREV AND ZXC_TIPO = '02' )"
cQuery += " ) T"
cQuery += " ORDER BY RA_FILIAL,RA_MAT,RA_DTFIMCT
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRA"
TcSetField( "WSRA", "RA_ADMISSA","D",08, 0 )
TcSetField( "WSRA", "RA_DTFIMCT","D",08, 0 )

dbSelectArea( "WSRA" )
If Used()
	While !WSRA->(Eof())
		dbSelectArea("ZXC")
		RecLock("ZXC",.T.)
		ZXC->ZXC_FILIAL	:= WSRA->RA_FILIAL
		ZXC->ZXC_MAT	:= WSRA->RA_MAT
		ZXC->ZXC_DINCLU	:= Date()
		ZXC->ZXC_TIPO	:= "02"
		ZXC->ZXC_TDESC	:= c_Descri
		ZXC->ZXC_DPREV	:= WSRA->RA_DTFIMCT
		ZXC->ZXC_DIASAV	:= n_prazo
		If l_Vazia .And. WSRA->RA_DTFIMCT < DATE()
			ZXC->ZXC_STATUS	:= "B"
			ZXC->ZXC_DBAIXA	:= DATE()
			ZXC->ZXC_USERBX	:= "IMPLANTACAO"
		Else
			ZXC->ZXC_STATUS	:= "P"
		Endif
		MsUnLock()
		dbSelectArea( "WSRA" )
		WSRA->(dbSkip())
	Enddo
EndIf

WSRA->(dbClosearea())

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GERAFERD บAutor  ณMarco Antonio Silva บ Data ณ  21/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Pendencias Ferias Dobro                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GERAFERD()

Local cQuery := ''
Local c_Descri	:= ""
Local n_prazo	:= 0

//Carrega descricao e dias de aviso da Experiencia
dbSelectArea("RCC")
dbSetOrder(4)
If dbSeek(xFilial("RCC")+"U00D")
	While !RCC->(Eof()) .And. RCC->RCC_CODIGO = "U00D"
		If Subs(RCC->RCC_CONTEU,1,2) == "03"
			c_Descri	:= SUBS(RCC->RCC_CONTEU,3,20)
			n_prazo		:= Val(SUBS(RCC->RCC_CONTEU,23,2))
		Endif
		RCC->(dbSkip())
	Enddo
Endif


IF SELECT("WSRA") > 0
	WSRA->(dbClosearea())
Endif

cQuery += " SELECT * FROM("
cQuery += " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_SITFOLH,RA_CATFUNC,RF_DATABAS,RF_DATAFIM"
cQuery += " ,ISNULL((SELECT SUM(RH_DFERIAS+RH_DABONPE) FROM SRH010 WHERE D_E_L_E_T_ = ' ' AND RH_FILIAL = RA_FILIAL AND RH_MAT = RA_MAT AND RH_DATABAS = RF_DATABAS ),0) DIASCALC "
cQuery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRF")+" B  "
cQuery += " WHERE A.D_E_L_E_T_ = ' ' AND RF_STATUS = '1' AND RF_DATAFIM <= '"+dtos(DATE() - 365 + n_prazo)+"'"
cQuery += " AND B.D_E_L_E_T_ = ' ' AND RA_FILIAL = RF_FILIAL AND RA_MAT = RF_MAT  "
cQuery += " AND RA_SITFOLH <> 'D'  "
cQuery += " AND RA_CATFUNC NOT IN ('P','A', 'E') "
cQuery += " AND NOT EXISTS(SELECT * FROM " + RetSqlName("ZXC") + " WHERE D_E_L_E_T_ = ' ' AND ZXC_FILIAL = RA_FILIAL AND ZXC_MAT = RA_MAT AND RF_DATAFIM = ZXC_DPREV AND ZXC_TIPO = '03' )"
cQuery += " AND NOT EXISTS(SELECT R8_DATAFIM FROM SR8010 WHERE D_E_L_E_T_ = ' ' AND R8_FILIAL = RA_FILIAL AND R8_MAT = RA_MAT AND R8_DATAFIM = ' '))T  "
cQuery += " WHERE DIASCALC < 30  "
cQuery += " ORDER BY 1,2  "
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRA"
TcSetField( "WSRA", "RA_ADMISSA","D",08, 0 )
TcSetField( "WSRA", "RF_DATAFIM","D",08, 0 )

dbSelectArea( "WSRA" )
If Used()
	While !WSRA->(Eof())
		dbSelectArea("ZXC")
		RecLock("ZXC",.T.)
		ZXC->ZXC_FILIAL	:= WSRA->RA_FILIAL
		ZXC->ZXC_MAT	:= WSRA->RA_MAT
		ZXC->ZXC_DINCLU	:= Date()
		ZXC->ZXC_TIPO	:= "03"
		ZXC->ZXC_TDESC	:= c_Descri
		ZXC->ZXC_DPREV	:= WSRA->RF_DATAFIM
		ZXC->ZXC_DIASAV	:= n_prazo
		ZXC->ZXC_STATUS	:= "P"
		MsUnLock()
		dbSelectArea( "WSRA" )
		WSRA->(dbSkip())
	Enddo
EndIf

WSRA->(dbClosearea())

Return()