#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CDAPLGRP  ºAutor  ³ Luiz Alberto       º Data ³  01/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Amarracao Aplicacao x Grupo de Produtos                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CDAPLGRP()
Private aRotina   := {}
Private cCadastro := "Amarração Aplicação x Grupo Produtos"
Private lRETmenu  := .F.

AADD(aRotina,{ OemToAnsi("Pesquisar")      ,"AxPesqui"        ,0,1})   //"Pesquisar"
AADD(aRotina,{ OemToAnsi("Visualizar")     ,"U_FATA16('1')"  ,0,2})   //"Visualizar"
AADD(aRotina,{ OemToAnsi("Manutenção")        ,"U_FATA16('2')"  ,0,4})   //"Alterar"

DBSELECTAREA("SZ6")

mBrowse(,,,,'SZ6',,,,,,)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |FATA16()  ºAutor  ³Juliana Taveira     º Data ³  03/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta tela                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATA16(cTipo)

Local aAreaPR        := GetArea()
Local aPosGet	     := {}
Local aSizeAut       := MsAdvSize(.t.)
Local aObjects	     := {}
Local aTitles	     := {OemToAnsi(""),;
OemToAnsi(""),;
OemToAnsi(""),;
OemToAnsi(""),;
OemToAnsi("")}

local aDialogs       := {"","","","",""}
Local cAlias         := "SZ0"
Local aBotoes        := {}               	// Botoes especificos da Enchoice
Private aCols        := {}
Private aHeader  	 := {}
private nopca

cCadastro:="Amarração Aplicação x Grupo Produtos"
cAlias := "SZ0"
nUsado := 0

IF cTipo='1'
	AADD(aHeader,{"Codigo ",   "Z0_GRUPO"   ,"@!"  ,03,0,"EXISTCPO('SBM') .AND.  U_FAT16VAL()","","C","SBM","","","",".F."})//1
ELSE
	AADD(aHeader,{"Codigo ",   "Z0_GRUPO"   ,"@!"  ,03,0,"EXISTCPO('SBM') .AND.  U_FAT16VAL()","","C","SBM","","","",".T."})//1
ENDIF

AADD(aHeader,{"Descricao", "Z0_DESG" ,"@!"  ,20,0,""                                  ,"","C",""   ,"","","",".F."})//3

cQUERY :=''

cQUERY :=" SELECT *                             "
cQUERY +=" FROM "+RetSqlName('SZ0')+" Z0        "
cQUERY +=" WHERE Z0_COD='"+SZ6->Z6_COD+"'      "
cQUERY +=" AND Z0.D_E_L_E_T_ <>'*'                                                "
cQUERY +=" ORDER BY Z0_COD,Z0_GRUPO    "

cQuery:=ChangeQuery(cQuery)
TcQuery cQuery ALIAS TR1 NEW

TR1->(DBSELECTAREA('TR1'))
TR1->(DBGOTOP())

DO WHILE !TR1->(EOF())
	cDesc   := POSICIONE('SBM',1,xFILIAL('SBM')+TR1->Z0_GRUPO,'BM_DESC')
	AADD(aCols,{TR1->Z0_GRUPO,cDesc,.F.})//.f. POSICAO 8Flag de Delecao
	TR1->(DBSKIP())
ENDDO

cCli  :=SZ6->Z6_COD
cNome :=SZ6->Z6_DESCR

aObjects := {}

AAdd( aObjects, { 0,    41, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    75, .T., .F. } )

aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
{{3,40,95,165,217,234,268},;
{10,40,111,145,223,268,60},;
{5,70,160,205,295},;
{6,34,200,215},;
{6,34,80,113,160,185},;
{6,34,245,268,260},;
{10,50,150,190},;
{273,130,190},;
{8,45,80,103,139,173,200,235,270},;
{133,190,144,190,289,293},;
{142,293,140},;
{9,47,188,148,9,146} } )

IF cTipo ='1'
		
	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define o cabecalho da rotina                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMeio:=INT( ((oMainWnd:nBottom-60) -(oMainWnd:nTop+125) ) / 4 )-10
	
	nLin:=17
	@ nLin,aPosGet[1,1] SAY OemToAnsi("Código") OF oDlg PIXEL SIZE 045,010
	@ nLin,aPosGet[1,2] MSGET cCli   WHEN(.F.)        OF oDlg PIXEL SIZE 050,006
	
	nLin+=12
	@ nLin,aPosGet[1,1] SAY OemToAnsi("Aplicação") OF oDlg PIXEL SIZE 050,010
	@ nLin,aPosGet[1,2] MSGET cNome  WHEN(.F.)        OF oDlg PIXEL SIZE 200,006
	
	nLin+=12
	
	nLin+=12
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define a area da getdados da rotina                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//	oGetDados  := (MsNewGetDados():New( nLin ,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], GD_INSERT + GD_UPDATE + GD_DELETE ,/*"NfeLOkSE2"*/,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,          ,1000 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	oGetDados  := (MsNewGetDados():New( nLin ,aPosObj[2,2],aPosObj[3,3],aPosObj[2,4],  GD_UPDATE ,/*"NfeLOkSE2"*/,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,          ,1000 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	oGetDados:oBrowse:Refresh()

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(oDlg:End(),nOpcA:=9)},{||(oDlg:End(),nOpcA:=0)},,aBotoes) centered
	TR1->(DBCLOSEAREA())
	RestArea(aAreaPR)
ENDIF

IF cTipo ='2'
	
	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define o cabecalho da rotina                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMeio:=INT( ((oMainWnd:nBottom-60) -(oMainWnd:nTop+125) ) / 4 )-10
	
	nLin:=17
	@ nLin,aPosGet[1,1] SAY OemToAnsi("Código") OF oDlg PIXEL SIZE 045,010
	@ nLin,aPosGet[1,2] MSGET cCli   WHEN(.F.)        OF oDlg PIXEL SIZE 050,006
	
	nLin+=12
	@ nLin,aPosGet[1,1] SAY OemToAnsi("Aplicação") OF oDlg PIXEL SIZE 050,010
	@ nLin,aPosGet[1,2] MSGET cNome  WHEN(.F.)        OF oDlg PIXEL SIZE 200,006
	
	nLin+=12
	
	nLin+=12
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define a area da getdados da rotina                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oGetDados  := (MsNewGetDados():New( nLin ,aPosObj[2,2],aPosObj[3,3],aPosObj[2,4], GD_INSERT + GD_UPDATE + GD_DELETE , "U_FAT16LOK()" ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,          ,1000 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	oGetDados:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(oDlg:End(),nOpcA:=9)},{||(oDlg:End(),nOpcA:=0)},,aBotoes) centered
	IF nOpcA == 9
		TCSQLEXEC( "DELETE FROM "+RetSqlName('SZ0')+"  WHERE Z0_COD='"+SZ6->Z6_COD+"'  ")
		FOR nLIN := 1 TO LEN(oGetDados:aCols)
			IF ! oGetDados:aCols[nLIN][Len(oGetDados:aCols[nLIN])]  .AND. !EMPTY(oGetDados:aCols[nLIN][1]) //verifica se esta deletado
				SZ0->(RECLOCK('SZ0',.T.))
				SZ0->Z0_FILIAL  :=xFILIAL('SZ0')
				SZ0->Z0_COD     :=SZ6->Z6_COD
				SZ0->Z0_DESCR   :=SZ6->Z6_DESCR
				SZ0->Z0_GRUPO   :=oGetDados:aCols[nLIN][1]
				SZ0->Z0_DESG    :=oGetDados:aCols[nLIN][2]
				SZ0->(MSUNLOCK())
			ENDIF
		NEXT
	ENDIF
	
	TR1->(DBCLOSEAREA())
	RestArea(aAreaPR)
ENDIF
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |FAT16VAL()ºAutor  ³Juliana Taveira     º Data ³  03/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se Condicao de pagamento já é cadastrada            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FAT16VAL()

lRet :=.T.
aCols[n][2]:= POSICIONE('SBM',1,xFILIAL('SBM')+M->Z0_GRUPO,'BM_DESC')
aCOLS2:=aCOLS
oGetDados:aCols:=aCOLS2
oGetDados:oBrowse:Refresh()
FOR nLIN :=1 TO LEN(aCOLS)
	IF aCOLS[nLIN][1]==M->Z0_GRUPO
		MSGALERT("Ja cadastrado Grupo "+M->Z0_GRUPO+" para a Aplicao "+SZ6->Z6_COD+"  "+SZ6->Z6_DESCR)
		LRET :=.F.
	ENDIF
NEXT

Return(lRET)

User Function FAT16LOK
Local lRet  :=.T.                  
Local _nMax := 0

/*FOR nLIN :=1 TO LEN(aCOLS)
	If !aCOLS[nLIN,Len(aHeader)+1] .And. !Empty(aCOLS[nLIN,1])
		_nMax++
	Endif
NEXT     
If _nMax > 3 .And. !MsgNoYes("Confirma Inserir Mais de 3 Condições para o Cliente?")
	lRet  :=.F.                  
Endif
  */
Return(lRet)