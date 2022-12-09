#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MITA001   ³ Autor ³ Ewerton F Brasiliano  ³ Data ³25/03/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Fabr.Mcinfotech  ³Contato ³ ewe.brasiliano@gmail.com       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MITAx()


//Local _aArea    := GetArea()
// Variaveis Locais Pedidos
/*
Local kit:= M->C6_KIT
Local _aArea    := GetArea()
Local _cQry     := ""
Local _nPosIni  := Len(aCols)
//Local _nItens   := Len(aCols)
//Local _nItens   := Val(GdFieldGet("C6_ITEM",_nPosIni))
Local _nItens :=0
LocAL _nLinAcol := Len(aCols)
Local k,j       := 1
Local _nQuant   := 0
//Local _cTES     := GdFieldGet("C6_TES",_nPosIni)//if(!GdDeleted(1),GdFieldGet("C6_TES",_nPosIni),"")
//Local _nTotal   := GdFieldGet("C6_QTDVEN",_nPosIni)

*/

//////////////////////////////
// Variaveis Locais da Funcao
//////////////////////////////

//Local cEdit1	 := Space(60)
//Local cEdit0	 := Space(10)
//local _oDlg
//local _oDlg1
Local cEdit14	 := Space(25)
Local cEdit15	 := Space(25)
Local cEdit16	 := Space(25)
Local cEdit17	 := Space(25)
Local cEdit18	 := Space(25)
Local cEdit19	 := Space(25)
Local cEdit20	 := Space(25)
Local cEdit21	 := Space(25)
Local cEdit22	 := Space(25)
Local cEdit23	 := Space(25)
Local cEdit24	 := Space(25)
Local cEdit26	 := Space(25)
Local oEdit1
Local oEdit13
Local oEdit14
Local oEdit15
Local oEdit16
Local oEdit17
Local oEdit18
Local oEdit19
Local oEdit20
Local oEdit21
Local oEdit22
Local oEdit23
Local oEdit24
Local oEdit26
/*
Local cEdit2	 := Space(25)
Local cEdit31	 := Space(60)
Local cEdit32	 := Space(25)
Local cEdit33	 := Space(25)*/
Local oEdit1
Local oEdit13
Local oEdit2
Local oEdit29
Local oEdit30
Local oEdit31
Local oEdit32
Local oEdit33
Local oEdit35
Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE

Private aHoBrw1 := {}
Private noBrw1  := 0
Public oBrw1
Public oBrw2
public cEdit1	 := Space(60)
public cEdit0	 := Space(06)
Public cEdit27
Public cEdit2:=SPACE(25)
Public cEdit3:=SPACE(30)
Public cEdit28
Public cEdit29 :=SPACE(2)
Public cEdit30 :=SPACE(2)
Public cEdit31	 := Space(30)
Public cEdit32	 := Space(25)
Public cEdit33	 := Space(25)
Public cEdit35	 := Space(25)
PUBLIC _cCliente := M->C5_CLIENTE
PUBLIC  _cLoja    := M->C5_LOJACLI
PUBLIC  _cPedido  := M->C5_NUM
PUBLIC cimg
PUBLIC PRD
PUBLIC DPR
PUBLIC grd
PUBLIC lnh
PUBLIC PRD1
PUBLIC DPR1
PUBLIC grd1
PUBLIC lnh1
PUBLIC _aArea    := GetArea()
PUBLIC _oDlg
PUBLIC _oDlg1
// Variaveis Private da Funcao

// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
// Privates das NewGetDados
Private oGetDados1
Private oGetDados2


DEFINE MSDIALOG _oDlg1 TITLE "Cadastro Display Max Love" FROM C(272),C(199) TO C(719),C(918) COLOR CLR_WHITE PIXEL

dbselectarea('ZK1')
DBGoBottom ( )
cEdit0:=val(ZK1->ZK1_CODIGO)
cEdit0=cEdit0
cEdit0++
cEdit0=cvaltochar(cEdit0)
cEdit0=PadL(AllTrim(cEdit0), 6, "0")
DBCloseArea()

@ C(005),C(015) Say "Codigo:"   Size C(020),C(006) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(005),C(055) Say "Descrição" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(010),C(300) Jpeg FILE "figura.jpg" Size C(095),C(062) PIXEL OF _oDlg

@ C(015),C(015) MsGet oEdit0 Var cEdit0 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(015),C(055) MsGet oEdit1 Var cEdit1 Size C(155),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(045),C(015) Say "Colunas" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(045),C(055) Say "Linhas " Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(060),C(015) MsGet oEdit29 Var cEdit29 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(060),C(055) MsGet oEdit30 Var cEdit30 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(090),C(015) Say "Produtos  " Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(090),C(085) Say "Provadores" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(090),C(155) Say "Exposição"  Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(090),C(225) Say "Adesivo"    Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(105),C(015) MsGet oEdit32 Var cEdit32 F3 "SB4" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(105),C(085) MsGet oEdit33 Var cEdit33 F3 "SB4" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(105),C(155) MsGet oEdit2  Var cEdit2  F3 "SB1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(105),C(225) MsGet oEdit35 Var cEdit35 F3 "SB1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(180),C(310) Button "Processa" Size C(037),C(012) PIXEL OF _oDlg1 Action _oDlg1:End()

ACTIVATE MSDIALOG _oDlg1 CENTERED

DEFINE MSDIALOG _oDlg TITLE "Cadastro Display Max Love" FROM C(272),C(199) TO C(719),C(918) COLOR CLR_WHITE PIXEL

cimg :=cEdit31
PRD:=cEdit32
DPR:=Posicione("SB4",1,xFilial("SB4")+PRD,"B4_DESC")
grd:=Posicione("SB4",1,xFilial("SB4")+PRD,"B4_COLUNA")
lnh:=Posicione("SB4",1,xFilial("SB4")+PRD,"B4_LINHA")

cEdit32=PRD
PRD1:=cEdit33
DPR1:=Posicione("SB4",1,xFilial("SB4")+PRD1,"B4_DESC")
grd1:=Posicione("SB4",1,xFilial("SB4")+PRD1,"B4_COLUNA")
lnh1:=Posicione("SB4",1,xFilial("SB4")+PRD1,"B4_LINHA")
cEdit33=PRD1

@ C(005),C(015) Say "Codigo:"   Size C(020),C(006) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(005),C(055) Say "Descrição" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(010),C(300) Jpeg FILE "figura.jpg" Size C(095),C(062) PIXEL OF _oDlg

@ C(015),C(015) MsGet oEdit0 Var cEdit0 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg	WHEN .F.
@ C(015),C(055) MsGet oEdit1 Var cEdit1 Size C(155),C(009) COLOR CLR_BLACK PIXEL OF _oDlg	WHEN .F.

@ C(045),C(015) Say "Colunas" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(045),C(055) Say "Linhas " Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(060),C(015) MsGet oEdit29 Var cEdit29 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg	WHEN .F.
@ C(060),C(055) MsGet oEdit30 Var cEdit30 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlg	WHEN .F.

@ C(090),C(015) Say "Produtos  " Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(090),C(085) Say "Provadores" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(090),C(155) Say "Exposição"  Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(090),C(225) Say "Adesivo"    Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(105),C(015) MsGet oEdit32 Var cEdit32 F3 "SB4" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg WHEN .F.
@ C(105),C(085) MsGet oEdit33 Var cEdit33 F3 "SB4" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg WHEN .F.
@ C(105),C(155) MsGet oEdit2  Var cEdit2  F3 "SB1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg WHEN .F.
@ C(105),C(225) MsGet oEdit35 Var cEdit35 F3 "SB1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg WHEN .F.

U_MAXCORES()

ACTIVATE MSDIALOG _oDlg CENTERED

fAtuSD4(aDados)

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


//+------------------------------------------------------------------------------------+//
//| FUNÇÃO    | MAXCORES        | AUTOR | Ewerton F Brasiliano      | DATA | 18/06/2015 |//
//+------------------------------------------------------------------------------------+//
//| DESCRICAO | Montagem de MAXCORES                                                   |//
//+------------------------------------------------------------------------------------+//
User Function MAXCORES

Local cPerg		:= "MAXCORES_V15"
Local cQuery	:= ""
Local nResult	:= 0
Local TRB1		:= GetNextAlias()

Local oFont		:= TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
Local aHead		:= {"Grade","    ","Cor","Descrição"}
Local oMark		:= LoadBitmap( GetResources(), "LBOK")
Local oDesM		:= LoadBitmap( GetResources(), "LBNO")
Local oDlg,oListBox,oBtn1,oBtn2
Local cQuery1	:= ""
Local nResult1	:= 0
Local TRB2		:= GetNextAlias()

Local oFont1		:= TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
Local aHead1		:= {"Grade","    ","Cor","Descrição"}
Local oMark1		:= LoadBitmap( GetResources(), "LBOK")
Local oDesM1		:= LoadBitmap( GetResources(), "LBNO")
Local oDlg1,oListBox1,oBtn11,oBtn21

public TI:=0
public TIx:=0
public  aDados	:= {}
public  aDados1	:= {}
////////////////////////////////////////
/////  cQuery 1              //////////
//////////////////////////////////////
BeginSQL Alias TRB1
	%NOPARSER%
	SELECT	B1_FILIAL, B1_COD,B1_DESC
	FROM	%Table:SB1% B1
	WHERE	B1_FILIAL = %xFilial:SB1%
	AND		SUBSTRING(B1_COD,1,5) = %Exp:ALLTRIM(PRD)%
	AND		B1.%NotDel%
EndSQL

If (TRB1)->(Eof())
	MsgStop("Nenhum produto encontrado para esta grade !!")
	Return
EndIf

While (TRB1)->(!Eof())
	(TRB1)->(aAdd(aDados,{	B1_DESC	,;
	.F.		,;
	SUBS(B1_COD,9,3)	,;
	SUBS(B1_COD,9,3)  }))
	
	(TRB1)->(DbSkip())
End

(TRB1)->(DbCloseArea())
//////////////////////////////////////////////////
//////////////////////////////////////////////////
BeginSQL Alias TRB2
	%NOPARSER%
	SELECT	B1_FILIAL, B1_COD,B1_DESC
	FROM	%Table:SB1% B1
	WHERE	B1_FILIAL = %xFilial:SB1%
	AND		SUBSTRING(B1_COD,1,5) = %Exp:ALLTRIM(PRD1)%
	AND		B1.%NotDel%
EndSQL

If (TRB2)->(Eof())
	MsgStop("Nenhum produto encontrado para esta grade !!")
	Return
EndIf

While (TRB2)->(!Eof())
	(TRB2)->(aAdd(aDados1,{	B1_DESC	,;
	.F.		,;
	SUBS(B1_COD,9,3)	,;
	SUBS(B1_COD,9,3)  }))
	
	(TRB2)->(DbSkip())
End

(TRB2)->(DbCloseArea())
//////////////////////////////////////////////////
//////////////////////////////////////////////////

//	oDlg       			:= MSDialog():New( 092,232,670,1160,"Selecione os produtos...",,,.F.,,,,,,.T.,,oFont,.T. )
oListBox 			:= TWBrowse():New(100,005,225,160,,aHead,,_oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aDados)
oListBox:bLine		:= {|| {aDados[oListBox:nAT,01],If(aDados[oListBox:nAT,02],oMark,oDesM),aDados[oListBox:nAT,03],aDados[oListBox:nAT,04]}}

oListBox:cToolTip	:= "Duplo Click para selecionar"
//	oListBox:bLDblClick	:= {|| aDados[oListBox:nAT,02]:=!aDados[oListBox:nAT,02],oListBox:Refresh() }
oListBox:bLDblClick := {|| aDados[oListBox:nAT,02]:=!aDados[oListBox:nAT,02],maxvalida(),oListBox:Refresh() }

oListBox:Refresh()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

oListBox1 			:= TWBrowse():New(100,231,227,160,,aHead,,_oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox1:SetArray(aDados1)
oListBox1:bLine		:= {|| {aDados1[oListBox1:nAT,01],If(aDados1[oListBox1:nAT,02],oMark1,oDesM1),aDados1[oListBox1:nAT,03],aDados1[oListBox1:nAT,04]}}

oListBox1:cToolTip	:= "Duplo Click para selecionar"
//	oListBox1:bLDblClick	:= {|| aDados[oListBox:nAT,02]:=!aDados[oListBox:nAT,02],oListBox:Refresh() }
oListBox1:bLDblClick := {|| aDados1[oListBox1:nAT,02]:=!aDados1[oListBox1:nAT,02],maxvalida1(),oListBox1:Refresh() }

oListBox1:Refresh()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

oBtn1      := TButton():New( 270,356,"Confirma",_oDlg,{|| _oDlg:End() },049,012,,oFont,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 270,416,"Sair",_oDlg,{|| _oDlg:End() },049,012,,oFont,,.T.,,"",,,,.F. )
//If(fAtuSD4(aDados),
//	oDlg:Activate(,,,.T.)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fAtuSD4    ³ Autor ³                       ³ Data ³01/06/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fAtuSD4(aItens)

Local lRet := .T.

Local nI := 0
Local ny := 0
Local I := 0
Local y := 0
Local nTem := Len(aItens)
fl1=xfilial('ZK1')
fl2=xfilial('ZK1')

/*		If nTem == 0
If !MsgYesNo("É necessário informar todas as posições por Kit, Colunas: "+AllTrim(Str(cEdit29))+". Desejar sair mesmo assim?")
lRet := .F.
Endif

Elseif nTem < val(cEdit29)
Alert('É necessário informar todas as posições para o Kit')
Endif
*/

If MsgYesNo("Confirma Gravação do Kit?")
	
	RecLock("ZK1",.T.)
	ZK1->ZK1_FILIAL:=XFILIAL('ZK1')
	ZK1->ZK1_CODIGO:=cEdit0
	ZK1->ZK1_DESC:=cEdit1
	ZK1->ZK1_COLUNA:=cEdit29
	ZK1->ZK1_LINHA:=cEdit30
	ZK1->ZK1_AMOSTR:='1'
	ZK1->ZK1_BASE:=cEdit2
	ZK1->ZK1_ADESIV:=cEdit35
	ZK1->ZK1_GRADE:=PRD
	ZK1->ZK1_TB_COL:=GRD
	ZK1->ZK1_TB_LIN:=LNH
	ZK1->ZK1_PROV:=PRD1
	ZK1->ZK1_PV_COL:=GRD1
	ZK1->ZK1_PV_LIN:=LNH1
	ZK1->ZK1_IMG:=cEdit31
	//ZK1->ZK1_PRVEND:=VAL(cEdit35)
	MsUnlock("ZK1")
	
	For i:=1 to Len(aItens)
		If aItens[i,2]	// Linha foi marcada para liberação
			RecLock("ZK2",.T.)
			fl1:=XFILIAL('ZK2')
			ZK2->ZK2_FILIAL:=fl1
			ZK2->ZK2_CODIGO:=cEdit0
			ZK2->ZK2_GRADE:=PRD
			ZK2->ZK2_COR:=aItens[i,3]
			ZK2->ZK2_QUANT:=VAL(cEdit30)
			MsUnlock("ZK2")
		ENDIF
	Next
	For y:=1 to Len(aDados1)
		If aDados1[y,2]	// Linha foi marcada para liberação
			RecLock("ZK3",.T.)
			
			ZK3->ZK3_FILIAL:=fl2
			ZK3->ZK3_CODIGO:=cEdit0
			ZK3->ZK3_PROV:=PRD1
			ZK3->ZK3_COR:=aDados1[y,3]
			ZK3->ZK3_QUANT=VAL(cEdit30)
			MsUnlock("ZK3")
		Endif
	Next
	
	
	ALERT('Kit Cadastrado com Sucesso !!!')
	
Endif

Return
//////////////////////////////////////////////////////////////////////
////*******************MAXVALIDA()******************************//////
//////////////////////////////////////////////////////////////////////
STATIC FUNCTION maxvalida()

TI++
COL=VAL(cEdit29)

/*
IF TI=COL
	ALERT ('Todos os Itens ja Selecionados')
ELSEIF  TI=COL-1
	ALERT ('Falta apenas 1 item a selecionar !')
ELSEIF   TI>COL
	ALERT ('Foram selecionados itens a mais !')
ENDIF
*/


RETURN

//////////////////////////////////////////////////////////////////////
////********************MAXVALIDA1()****************************//////
//////////////////////////////////////////////////////////////////////
STATIC FUNCTION maxvalida1()

TIx++
COLx=VAL(cEdit29)

/*
IF TIx=COLx
	ALERT ('Provadores ja Selecionados')
ELSEIF  TIx = COLx-1
	ALERT ('Falta apenas 1 Provador a selecionar !')
ELSEIF   TIx > COLx
	ALERT ('Foram selecionados provadores a mais !')
ENDIF
*/

RETURN

