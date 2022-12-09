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
User Function MXKIT02(acx,xcp)

	//////////////////////////////
	// Variaveis Locais da Funcao
	//////////////////////////////
	Local xCpr       :=xcp
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
Local cEdit31	 := Space(60)
Local cEdit32	 := Space(25)
Local cEdit33	 := Space(25)
	*/

	Local oEdit1
	Local oEdit13
	Local oEdit2
	Local oEdit29
	Local oEdit99
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
	Public cEdit27   :=SPACE(3)
	Public cEdit2    :=SPACE(25)
	Public cEdit3    :=SPACE(30)
	Public cEdit28   :=SPACE(3)
	Public cEdit29   :=SPACE(3)
	Public cEdit99   :=SPACE(3)
	Public cEdit30   :=SPACE(3)
	Public cEdit31	 := Space(3)
	Public cEdit32	 := Space(25)
	Public cEdit33	 := Space(25)
	Public cEdit35	 := Space(25)
	PUBLIC _cCliente := M->C5_CLIENTE
	PUBLIC  _cLoja   := M->C5_LOJACLI
	PUBLIC  _cPedido := cPedido
	//PUBLIC _cQuant := M->ZK6_QUANT
	PUBLIC _cITEM := oBrw1:oBrowse:nAt
	PUBLIC oFont		:= TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	PUBLIC cimg
	PUBLIC PRD
	PUBLIC DPR
	PUBLIC grd
	PUBLIC lnh
	PUBLIC PRD1
	PUBLIC DPR1
	PUBLIC grd1
	PUBLIC lnh1
	PUBLIC ITM :=0
	PUBLIC ITMX :=0
	PUBLIC oDlg,oListBox,oBtn1,oBtn2
	PUBLIC oDlg1,oListBox1,oBtn11,oBtn21

	PUTMV("MV_XSEQPED",_cPedido)

	If acx="N"
		Return("")
	EndIF

	PUBLIC _aArea    := GetArea()
	PUBLIC _oDlgx
	PUBLIC _oDlgx1
	PUBLIC nAct  :=0

	// Variaveis Private da Funcao

	// Variaveis que definem a Acao do Formulario
	Private VISUAL := .F.
	Private INCLUI := .F.
	Private ALTERA := .F.
	Private DELETA := .F.
	// Privates das NewGetDados
	Private oGetDados1
	Private oGetDados2
	PUBLIC aHoBrw6 := {}

	//ALERT("MXKIT02")

	DEFINE MSDIALOG _oDlgx TITLE "Display Max Love" FROM C(272),C(199) TO C(719),C(918) PIXEL  style 128

	cEdit0:=xCpr
	cEdit1:=ZK1->ZK1_DESC
	cEdit2:=ZK1->ZK1_BASE
	cEdit29 :=ZK1->ZK1_COLUNA
	cEdit99 :=ZK1->ZK1_COLUNA
	cEdit30 :=ZK1->ZK1_LINHA
	cEdit31 :=ZK1->ZK1_AMOSTR
	cEdit32 :=ALLTRIM(ZK1->ZK1_GRADE)
	cEdit33 :=ALLTRIM(ZK1->ZK1_PROV)
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

	@ C(001),C(014) Say "Codigo:" Size C(020),C(006) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(001),C(056) Say "Descrição" Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(001),C(155) Say "Vaccun Form " Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(010),C(222) Jpeg FILE "figura.jpg" Size C(095),C(062) PIXEL OF _oDlgx
	@ C(008),C(011) MsGet oEdit0 Var cEdit0 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.
	@ C(008),C(048) MsGet oEdit1 Var cEdit1 Size C(083),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.
	@ C(008),C(138) MsGet oEdit2 Var cEdit2 F3 "SB1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.
	@ C(020),C(013) Say "Coluna" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(020),C(056) Say "Linhas" Size C(017) ,C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(020),C(97) Say "Col.Provador" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(029),C(011) MsGet oEdit99 Var cEdit99 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.
	@ C(029),C(053) MsGet oEdit30 Var cEdit30 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.
	@ C(029),C(097) MsGet oEdit31 Var cEdit31 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.

	@ C(045),C(013) Say "Grade de Produto" Size C(044),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(045),C(075) Say "Provador de Produto" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(045),C(158) Say "Preço" Size C(016),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(053),C(012) MsGet oEdit32 Var cEdit32  Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.
	@ C(053),C(075) MsGet oEdit33 Var cEdit33  Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.
	@ C(053),C(137) MsGet oEdit35 Var cEdit35  Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.

	@ C(070),C(032) Say "GRADE" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(070),C(236) Say "PROVADORES" Size C(039),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx

	@ C(210),C(015) Say "TOTAL DE ITENS:" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(210),C(055) MsGet oEdit28 Var cEdit28 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.

	@ C(210),C(090) Say "TOTAL DE PROV :" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(210),C(135) MsGet oEdit29 Var cEdit29 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .F.

	_oDlgx:lEscClose     := .F. //Nao permite sair ao se pressionar a tecla ESC.

	u_MAXx1()

	ACTIVATE MSDIALOG _oDlgx CENTERED

	XFIM=""

	If  nAct = 1
		fAtuzkx(aDados)
		aDados	:= {}
		aDados1	:= {}
		aItens  := {}
		XFIM="S"
		//ZK1->(DbCloseArea())
	ElseIf nAct = 2
		aDados	:= {}
		aDados1	:= {}
		aItens  := {}
		XFIM=""
	endif
	//DbCloseAll()
	ZK1->(DbCloseArea())
	Restarea(_aArea)
	//	oBrw1:oBrowse:nAt
	//	oBrw1:oBrowse:Refresh()
	//	oBrw1:oBrowse:SetFocus()
Return (XFIM)

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
User Function MAXx1

	Local cPerg		:= "MAXCORES_v15"
	Local cQuery	:= ""
	Local nResult	:= 0
	Local TRB1		:= GetNextAlias()

	Local oFont		:= TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	Local aHead		:= {"Grade","    ","Cor","Quantidade"}
	Local oMark		:= LoadBitmap( GetResources(), "LBOK")
	Local oDesM		:= LoadBitmap( GetResources(), "LBNO")
	Local cQuery1	:= ""
	Local nResult1	:= 0
	Local TRB2		:= GetNextAlias()

	Local oFont1		:= TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	Local aHead1		:= {"Grade","    ","Cor","Quantidade"}
	Local oMark1		:= LoadBitmap( GetResources(), "LBOK")
	Local oDesM1		:= LoadBitmap( GetResources(), "LBNO")


	public TI:=0
	public TIx:=0
	public  aDados	:= {}
	public  aDados1	:= {}
	PROVADOR :=1
	////////////////////////////////////////
	/////  cQuery 1              //////////
	//////////////////////////////////////

	/* QUERY ANTIGA 27/09/2017
BeginSQL Alias TRB1
%NOPARSER%
SELECT	BV_DESCTAB, BV_CHAVE,BV_DESCRI
FROM	%Table:SBV% BV
WHERE	BV_FILIAL = %xFilial:SBV%
AND		BV_TABELA    =%Exp:grd%
AND		BV.%NotDel%
EndSQL
	*/

	BeginSQL Alias TRB1
		%NOPARSER%

		SELECT
			B1_FILIAL,
			B1_COD,
			B1_DESC
		FROM
			%Table:SB1% B1
		WHERE
			B1_FILIAL = %xFilial:SB1%
			AND SUBSTRING(B1_COD, 1, 5) = %Exp:PRD%
			AND B1.%NotDel%
	EndSQL


	If (TRB1)->(Eof())
		MsgStop("Nenhum produto encontrado para esta grade !!")
		Return
	EndIf

	xPVX:=cEdit30

	/*
While (TRB1)->(!Eof())
(TRB1)->(aAdd(aDados,{	BV_DESCTAB	,;
.F.		,;
BV_CHAVE	,;
xPVX  }))

(TRB1)->(DbSkip())
End
	*/

	While (TRB1)->(!Eof())
		(TRB1)->(aAdd(aDados,{	B1_DESC	,;
			.F.		,;
			SUBS(B1_COD,9,3)	,;
			xPVX  }))

		(TRB1)->(DbSkip())
	End


	(TRB1)->(DbCloseArea())
	//////////////////////////////////////////////////
	//////////////////////////////////////////////////

	/*
BeginSQL Alias TRB2
%NOPARSER%
SELECT	BV_DESCTAB, BV_CHAVE,BV_DESCRI
FROM	%Table:SBV% BV
WHERE	BV_FILIAL = %xFilial:SBV%
AND		BV_TABELA    =%Exp:grd1%
AND		BV.%NotDel%
EndSQL
	*/

	BeginSQL Alias TRB2
		%NOPARSER%

		SELECT
			B1_FILIAL,
			B1_COD,
			B1_DESC
		FROM
			%Table:SB1% B1
		WHERE
			B1_FILIAL = %xFilial:SB1%
			AND SUBSTRING(B1_COD, 1, 5) = %Exp:PRD1%
			AND B1.%NotDel%
	EndSQL


	If (TRB2)->(Eof())
		//	MsgStop("Nenhum produto encontrado para esta grade !!")
		PROVADOR=0
		Return
	EndIf

	if cEdit31=""
		xPV:=""
	elseif cEdit31='0'
		xPV:=""
	else
		xPV:=cEdit31
	endif

	/*
While (TRB2)->(!Eof())
PROVADOR=1
(TRB2)->(aAdd(aDados1,{	BV_DESCTAB	,;
.F.		,;
BV_CHAVE	,;
xPV  }))
(TRB2)->(DbSkip())
End
	*/

	While (TRB2)->(!Eof())
		PROVADOR=1
		(TRB2)->(aAdd(aDados1,{	B1_DESC	,;
			.F.		,;
			SUBS(B1_COD,9,3)	,;
			xPV  }))
		(TRB2)->(DbSkip())
	End


	(TRB2)->(DbCloseArea())
	//////////////////////////////////////////////////

	COLUNA:=VAL(ZK1->ZK1_COLUNA  )
	LINHA :=VAL(ZK1->ZK1_LINHA)
	AMOSTRA :=VAL(ZK1->ZK1_AMOSTR)

	// MEMORIA DE CALCULO PARA O RATEIO DO KIT


	QTDITM:=COLUNA*LINHA
	QTDPRV:=COLUNA*AMOSTRA  //QUANTIDADE DE ITENS DE UM KIT

	//////////////////////////////////////////////////

	//	oDlg       			:= MSDialog():New( 092,232,670,1160,"Selecione os produtos...",,,.F.,,,,,,.T.,,oFont,.T. )
	oListBox 			:= TWBrowse():New(100,005,225,160,,aHead,,_oDlgx,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLine		:= {|| {aDados[oListBox:nAT,01],If(aDados[oListBox:nAT,02],oMark,oDesM),aDados[oListBox:nAT,03],aDados[oListBox:nAT,04]}}

	oListBox:cToolTip	:= "Duplo Click para selecionar"
	//	oListBox:bLDblClick := {|| aDados[oListBox:nAT,02]:=!aDados[oListBox:nAT,02],maxvld(),oListBox:Refresh() }
	oListBox:bValid     :={|| XMAXV(aDados[oListBox:nAT,02],aDados[oListBox:nAT,04])  }
	oListBox:bLDblClick	:={|| lEditCell(aDados,oListBox,"",4),aDados[oListBox:nAT,02]:=!aDados[oListBox:nAT,02],maxvld(aDados[oListBox:nAT,02],aDados[oListBox:nAT,04]),_oDlgx:Refresh(),oListBox:Refresh() }
	//oListBox:Refresh()

	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


	oListBox1 			:= TWBrowse():New(100,231,227,160,,aHead,,_oDlgx,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox1:SetArray(aDados1)
	oListBox1:bLine		:= {|| {aDados1[oListBox1:nAT,01],If(aDados1[oListBox1:nAT,02],oMark1,oDesM1),aDados1[oListBox1:nAT,03],aDados1[oListBox1:nAT,04]}}

	oListBox1:cToolTip	:= "Duplo Click para selecionar"
	//	oListBox1:bLDblClick := {|| aDados1[oListBox1:nAT,02]:=!aDados1[oListBox1:nAT,02],maxvld1(),oListBox1:Refresh() }
	//  oListBox1:bValid:={|| maxvld1(aDados1[oListBox1:nAT,02],aDados1[oListBox1:nAT,04]),oListBox1:Refresh()}

	oListBox1:bValid     :={|| XMAXP(aDados1[oListBox1:nAT,02],aDados1[oListBox1:nAT,04])  }
	oListBox1:bLDblClick:={|| lEditCell(aDados1,oListBox1,"",4),aDados1[oListBox1:nAT,02]:=!aDados1[oListBox1:nAT,02],maxvld1(aDados1[oListBox1:nAT,02],aDados1[oListBox1:nAT,04]),_oDlgx:Refresh(),oListBox1:Refresh() }
	//    oListBox1:bLDblClick:={|| lEditCell(aDados1,oListBox1,"",4),.F.,aDados1[oListBox1:nAT,02]:=!aDados1[oListBox1:nAT,02],maxvld1(aDados1[oListBox1:nAT,02],aDados1[oListBox1:nAT,04]),_oDlgx:Refresh(),oListBox1:Refresh() }

	oListBox1:Refresh()

	oBtn1      := TButton():New( 270,356,"Confirma",_oDlgx,{||XMAXV(aDados[oListBox:nAT,02],aDados[oListBox:nAT,04]),nAct:=1,_oDlgx:End()},049,012,,oFont,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 270,416,"Sair",_oDlgx,{||nAct:=2,_oDlgx:End()},049,012,,oFont,,.T.,,"",,,,.F. )

	cEdit28:=0
	cEdit29:=0

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
Static Function fAtuzkx(aItens)

	Local lRet := .T.
	local lob :=0
	Local nI := 0
	Local ny := 0
	Local I := 0
	Local y := 0
	Local nTem := Len(aItens)
	PUBLIC KITOK
	fl1=xfilial('ZK1')
	fl2=xfilial('ZK1')
	AMOSTRA :=VAL(ZK1->ZK1_AMOSTR)

	/*
if nTem < val(cEdit29)
	MsgAlert("Não foi informada todas as colunas de cores para compor o display.")
	return
Endif
	*/

	If MsgYesNo("DISPLAY DEFINIDO CORRETAMENTE?")
		Lob=0

		For i:=1 to Len(aItens)
			If aItens[i,2]	// Linha foi marcada para liberação
				Lob++
				RecLock("ZKX",.T.)
				fl1:=XFILIAL("ZKX")
				ZKX->ZKX_FILIAL:=fl1
				ZKX->ZKX_CODIGO:=cEdit0
				ZKX->ZKX_GRADE:=PRD
				ZKX->ZKX_COR:=aItens[i,3]
				ZKX->ZKX_QUANT:=VAL(aItens[i,4])
				ZKX->ZKX_PEDIDO:=_cPedido
				ZKX->ZKX_ITEM:=cvaltochar(_cITEM)
				MSUNLOCK()

			ENDIF
		Next

		IF AMOSTRA > 0

			For y:=1 to Len(aDados1)
				If aDados1[y,2]	// Linha foi marcada para liberação
					RecLock("ZKX",.T.)
					fl1:=XFILIAL("ZKX")
					ZKX->ZKX_FILIAL:=fl1
					ZKX->ZKX_CODIGO:=cEdit0
					ZKX->ZKX_PROV:=PRD1
					ZKX->ZKX_COR:=aDados1[y,3]
					ZKX->ZKX_QUANT:=VAL(aDados1[y,4])
					ZKX->ZKX_PEDIDO:=_cPedido
					ZKX->ZKX_ITEM:=cvaltochar(_cITEM)
					MSUNLOCK()
				Endif
			Next

		ENDIF
	Endif

	aDados	:= {}
	aDados1	:= {}
	aItens  := {}


Return

//////////////////////////////////////////////////////////////////////
////*******************MAXVALIDA()******************************//////
//////////////////////////////////////////////////////////////////////
STATIC FUNCTION maxvld(xTy,CONT)

	DO CASE
		CASE xTy = .T.
			ITM=ITM+VAL(CONT)
			cEdit28:=cvaltochar(ITM)
		CASE xTy = .F.
			IF ITM >=VAL(ZK1->ZK1_LINHA)
				ITM=ITM-VAL(CONT)
				cEdit28:=cvaltochar(ITM)
			ENDIF
		OTHERWISE
	END CASE


	COL=VAL(ZK1->ZK1_COLUNA)
	COLUNA:=VAL(ZK1->ZK1_COLUNA)
	LINHA :=VAL(ZK1->ZK1_LINHA)
	AMOSTRA :=VAL(ZK1->ZK1_AMOSTR)


	IF aDados[oListBox:nAT,04] <> ZK1->ZK1_LINHA
		IF aDados[oListBox:nAT,02]=.T.
			If (VAL(CONT) % LINHA)<>0                                              	// Retorna o resto da divisão do valor _cProd pelo _nMultip
				MsgAlert("A quantidade para esta cor está incorreta.")
				ITM=ITM-VAL(CONT)
				cEdit28:=cvaltochar(ITM)
				aDados[oListBox:nAT,02]:=.F.
				aDados[oListBox:nAT,04]:=ZK1->ZK1_LINHA
			EndIf
		EndIf
	Endif

	QTDITM:=COLUNA*LINHA
	QTDPRV:=COLUNA*AMOSTRA

	IF ITM=QTDITM
		//   ALERT ('Todos os Itens ja Selecionados')

	ELSEIF ITM>QTDITM
		ITM=ITM-VAL(CONT)
		MsgAlert("Não é possível inserir nova cor. Todas as cores já foram selecionadas.")
		cEdit28:=cvaltochar(ITM)
		aDados[oListBox:nAT,02]:=.F.
		aDados[oListBox:nAT,04]:=ZK1->ZK1_LINHA
	ENDIF

	oListBox:Refresh()
	_oDlgx:Refresh()

Return()

//////////////////////////////////////////////////////////////////////
////********************MAXVALIDA1()****************************//////
//////////////////////////////////////////////////////////////////////
STATIC FUNCTION maxvld1(xTyx,CONTx)

	DO CASE
		CASE xTyx = .T.
			ITMx=ITMx+VAL(CONTx)
			cEdit29:=cvaltochar(ITMx)
		CASE xTyx = .F.
			IF ITMx >=VAL(ZK1->ZK1_COLUNA)
				ITMx=ITMx-VAL(CONTx)
				cEdit29:=cvaltochar(ITMx)
			ENDIF
		OTHERWISE
	END CASE


	COL=VAL(ZK1->ZK1_COLUNA)
	COLUNA:=VAL(ZK1->ZK1_COLUNA)
	LINHA :=VAL(ZK1->ZK1_LINHA)
	AMOSTRA :=VAL(ZK1->ZK1_AMOSTR)


	IF aDados1[oListBox1:nAT,04] <> ZK1->ZK1_COLUNA
		IF aDados1[oListBox1:nAT,02]=.T.
			If (VAL(CONTx) % AMOSTRA)<>0                                              	// Retorna o resto da divisão do valor _cProd pelo _nMultip

				MsgAlert("A quantidade para este provador está incorreta.")
				ITMx=ITMx-VAL(CONTx)
				cEdit29:=cvaltochar(ITMx)
				aDados1[oListBox1:nAT,02]:=.F.
				aDados1[oListBox1:nAT,04]:=ZK1->ZK1_AMOSTR
			EndIf
		EndIf
	Endif

	QTDITM:=COLUNA*LINHA
	QTDPRV:=COLUNA*AMOSTRA

	IF ITMx=QTDPRV
		//   ALERT ('Todos os Itens ja Selecionados')

	ELSEIF ITMx>QTDPRV
		ITMx=ITMx-VAL(CONTx)
		MsgAlert("Não é possível inserir novo provador. Todos os provadores já foram selecionados.")
		cEdit29:=cvaltochar(ITMx)
		aDados1[oListBox1:nAT,02]:=.F.
		aDados1[oListBox1:nAT,04]:=ZK1->ZK1_AMOSTR
	ENDIF

	oListBox1:Refresh()
	_oDlgx:Refresh()

Return()



STATIC FUNCTION XMAXV

	COL=VAL(ZK1->ZK1_COLUNA)
	COLUNA:=VAL(ZK1->ZK1_COLUNA)
	LINHA :=VAL(ZK1->ZK1_LINHA)
	AMOSTRA :=VAL(ZK1->ZK1_AMOSTR)

	// MEMORIA DE CALCULO PARA O RATEIO DO KIT
	QTDITM:=COLUNA*LINHA
	QTDPRV:=COLUNA*AMOSTRA

	IF ITM=QTDITM
		// ALERT ('Todos os Itens ja Selecionados')

	ELSEIF ITM>QTDITM
		ITM=ITM-VAL(CONT)
		MsgAlert("Todas as cores do display já foram selecionadas.")
		cEdit28:=cvaltochar(ITM)
		aDados[oListBox:nAT,02]:=.F.
		aDados[oListBox:nAT,04]:=ZK1->ZK1_LINHA
	ELSE
		MsgAlert("Falta selecionar cor para completar o display.")
	ENDIF

Return

STATIC FUNCTION XMAXP

	COL=VAL(ZK1->ZK1_COLUNA)
	COLUNA:=VAL(ZK1->ZK1_COLUNA)
	LINHA :=VAL(ZK1->ZK1_LINHA)
	AMOSTRA :=VAL(ZK1->ZK1_AMOSTR)

	// MEMORIA DE CALCULO PARA O RATEIO DO KIT
	QTDITM:=COLUNA*LINHA
	QTDPRV:=COLUNA*AMOSTRA

	IF ITMx=QTDPRV
		// ALERT ('Todos os Itens ja Selecionados')

	ELSEIF ITMx>QTDPRV
		ITMx=ITMx-VAL(CONTx)
		MsgAlert("Todos os provadores do display já foram selecionados.")
		cEdit29:=cvaltochar(ITMx)
		aDados1[oListBox1:nAT,02]:=.F.
		aDados1[oListBox1:nAT,04]:=ZK1->ZK1_AMOSTR
	ELSE
		MsgAlert("Falta selecionar provador para completar o display.")
	ENDIF

Return


