#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MXKIT04   ³ Autor ³ Ewerton F Brasiliano  ³ Data ³25/03/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Fabr.Mcinfotech  ³Contato ³ ewe.brasiliano@gmail.com       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MXKIT04()


	//////////////////////////////
	// Variaveis Locais da Funcao
	//////////////////////////////
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
	Local cSvFil := cFilAnt
	/*

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
	Public cEdit2    :=SPACE(25)
	Public cEdit3    :=SPACE(30)
	Public cEdit28
	Public cEdit29   :=SPACE(2)
	Public cEdit30   :=SPACE(2)
	Public cEdit31	 := Space(30)
	Public cEdit32	 := Space(25)
	Public cEdit33	 := Space(25)
	Public cEdit35	 := Space(25)
	PUBLIC _cCliente := M->C5_CLIENTE
	PUBLIC  _cLoja   := M->C5_LOJACLI
	PUBLIC  _cPedido := M->C5_NUM
	PUBLIC _cQuant := M->ZK6_QUANT
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


	DEFINE MSDIALOG _oDlgx TITLE "Kit Promocional" FROM C(272),C(199) TO C(719),C(918) PIXEL

	cEdit0:=ZK1->ZK1_CODIGO
	cEdit1:=ZK1->ZK1_DESC
	cEdit2:=ZK1->ZK1_BASE
	cEdit29 :=ZK1->ZK1_COLUNA
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
	@ C(008),C(011) MsGet oEdit0 Var cEdit0 Size C(025),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.
	@ C(008),C(048) MsGet oEdit1 Var cEdit1 Size C(083),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.
	@ C(008),C(138) MsGet oEdit2 Var cEdit2 F3 "SB1" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.
	@ C(020),C(013) Say "Coluna" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(020),C(056) Say "Linhas" Size C(017) ,C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(020),C(125) Say "Provador" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(029),C(011) MsGet oEdit29 Var cEdit29 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.
	@ C(029),C(053) MsGet oEdit30 Var cEdit30 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.
	@ C(029),C(097) MsGet oEdit31 Var cEdit31 Size C(021),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.

	@ C(045),C(013) Say "Grade de Produto" Size C(044),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(045),C(075) Say "Provador de Produto" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(045),C(158) Say "Preço" Size C(016),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(053),C(012) MsGet oEdit32 Var cEdit32  Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.
	@ C(053),C(075) MsGet oEdit33 Var cEdit33  Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx PIXEL WHEN .T.
	@ C(053),C(137) MsGet oEdit35 Var cEdit35 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlgx

	@ C(070),C(032) Say "GRADE" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx
	@ C(070),C(236) Say "PROVADORES" Size C(039),C(008) COLOR CLR_BLACK PIXEL OF _oDlgx

	u_MAXx3()

	ACTIVATE MSDIALOG _oDlgx CENTERED



	If  nAct = 1
		fAtuSDX(aDados)
	endif

	//	oBrw1:oBrowse:nAt
	//	oBrw1:oBrowse:Refresh()
	//	oBrw1:oBrowse:SetFocus()
Return ('S')

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
User Function MAXx3

	Local cPerg		:= "MAXCORES_v15"
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

	cCodigo:=cvaltochar(ZK1->ZK1_CODIGO)
	////////////////////////////////////////
	/////  cQuery 1              //////////
	//////////////////////////////////////

	cQuery := "SELECT BV_DESCTAB,BV_CHAVE,BV_DESCRI FROM"  + RetSqlName("SBV")
	cQuery += " WHERE BV_TABELA='"+grd+"' AND D_E_L_E_T_ = ''"

	cQuery := ChangeQuery(cQuery)

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'QRY', .F., .T.)

	cQuery1 := "SELECT ZK2_CODIGO,ZK2_GRADE,ZK2_COR  FROM"  + RetSqlName("ZK2")
	cQuery1 += " WHERE ZK2_CODIGO='"+cCodigo+"' AND ZK2_GRADE='"+PRD+"' AND D_E_L_E_T_ = ''"

	cQuery1 := ChangeQuery(cQuery1)

	If Select("QRY1") > 0
		QRY1->(dbCloseArea())
	EndIf
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery1), 'QRY1', .F., .T.)
	DPR:=QRY->BV_DESCTAB
	While QRY1->(!EOF())
		XTV=.T.
		aAdd(aDados,{DPR,XTV,QRY1->ZK2_COR,LNH })
		QRY1->(DbSkip())
	End

	QRY1->(Dbgotop())
	XTV=.F.
	While QRY->(!EOF())
		ch:=alltrim(QRY->BV_CHAVE)
		co:=alltrim(QRY1->ZK2_COR )

		IF ch==co
			QRY->(DbSkip())
			QRY1->(DbSkip())
		ELSE
			aAdd(aDados,{ QRY->BV_DESCTAB,XTV,QRY->BV_CHAVE,QRY->BV_DESCRI })
			QRY->(DbSkip())
			QRY1->(DbSkip())
		ENDIF
	End
	////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////

	cQuery4 := "SELECT BV_DESCTAB,BV_CHAVE,BV_DESCRI FROM"  + RetSqlName("SBV")
	cQuery4 += " WHERE BV_TABELA='"+grd1+"' AND D_E_L_E_T_ = ''"

	cQuery4 := ChangeQuery(cQuery4)

	If Select("QRY4") > 0
		QRY4->(dbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery4), 'QRY4', .F., .T.)





	cQuery2 := "SELECT ZK3_CODIGO,ZK3_PROV,ZK3_COR  FROM"  + RetSqlName("ZK3")
	cQuery2 += " WHERE ZK3_CODIGO='"+cCodigo+"' AND ZK3_PROV='"+PRD1+"' AND D_E_L_E_T_ = ''"

	cQuery2 := ChangeQuery(cQuery2)

	If Select("QRY2") > 0
		QRY2->(dbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery2), 'QRY2', .F., .T.)

	DPR1:=QRY4->BV_DESCTAB

	While QRY2->(!EOF())
		XTV1=.T.
		aAdd(aDados1,{DPR1,XTV1,QRY2->ZK3_COR,LNH1 })
		QRY2->(DbSkip())
	End

	QRY2->(Dbgotop())
	XTV1=.F.


	While QRY4->(!EOF())
		ch1:=alltrim(QRY4->BV_CHAVE)
		co1:=alltrim(QRY2->ZK3_COR )

		IF ch1==co1
			QRY4->(DbSkip())
			QRY2->(DbSkip())
		ELSE
			aAdd(aDados1,{ QRY4->BV_DESCTAB,XTV1,QRY4->BV_CHAVE,QRY4->BV_DESCRI})
			QRY4->(DbSkip())
			QRY2->(DbSkip())
		ENDIF
	End

	QRY->(DbCloseArea())
	QRY1->(DbCloseArea())
	QRY2->(DbCloseArea())
	QRY4->(DbCloseArea())
	//////////////////////////////////////////////////
	//////////////////////////////////////////////////

	//////////////////////////////////////////////////

	//	oDlg       			:= MSDialog():New( 092,232,670,1160,"Selecione os produtos...",,,.F.,,,,,,.T.,,oFont,.T. )
	oListBox 			:= TWBrowse():New(100,005,225,160,,aHead,,_oDlgx,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLine		:= {|| {aDados[oListBox:nAT,01],If(aDados[oListBox:nAT,02],oMark,oDesM),aDados[oListBox:nAT,03],aDados[oListBox:nAT,04]}}

	oListBox:cToolTip	:= "Duplo Click para selecionar"

	oListBox:bLDblClick := {|| aDados[oListBox:nAT,02]:=!aDados[oListBox:nAT,02],maxvld(),oListBox:Refresh() }

	oListBox:Refresh()

	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

	oListBox1 			:= TWBrowse():New(100,231,227,160,,aHead,,_oDlgx,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox1:SetArray(aDados1)
	oListBox1:bLine		:= {|| {aDados1[oListBox1:nAT,01],If(aDados1[oListBox1:nAT,02],oMark1,oDesM1),aDados1[oListBox1:nAT,03],aDados1[oListBox1:nAT,04]}}

	oListBox1:cToolTip	:= "Duplo Click para selecionar"
	oListBox1:bLDblClick := {|| aDados1[oListBox1:nAT,02]:=!aDados1[oListBox1:nAT,02],maxvld1(),oListBox1:Refresh() }

	oListBox1:Refresh()
	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

	oBtn1      := TButton():New( 270,356,"Confirma",_oDlgx,{||nAct:=1,_oDlgx:End() },049,012,,oFont,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 270,416,"Sair",_oDlgx,{|| _oDlgx:End() },049,012,,oFont,,.T.,,"",,,,.F. )
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

Static Function fAtuSDX(aItens1)

	Local lRet := .T.
	Local lPas := .F.

	Local i := 0
	Local y := 0
	Local ny := 0
	Local nTem := Len(aItens1)

	If MsgYesNo("Confirma Gravação do Kit?")

		cAlias2='ZK2'
		dbSelectArea('ZK2')
		dbSetOrder(2)
		dbSeek(XFILIAL('ZK2')+cEdit0+PRD,.F.)
		While !Eof()
			For i:=1 to Len(aItens1)
				If aItens1[i,2]	// Linha foi marcada para liberação
					RecLock('ZK2',.F.)
					ZK2->ZK2_FILIAL:=XFILIAL('ZK2')
					ZK2->ZK2_CODIGO:=cEdit0
					ZK2->ZK2_GRADE:=PRD
					ZK2->ZK2_COR:=aItens1[i,3]
					MsUnLock()
				ENDIF
				ZK2->(Dbskip())
			Next
		End
		ZK2->(DbCloseArea())
		//***********************************************************//

		cAlias3='ZK3'
		dbSelectArea('ZK3')
		dbSetOrder(2)
		dbSeek(XFILIAL()+cEdit0+PRD1,.F.)
		While !Eof()
			For y:=1 to Len(aDados1)
				If aDados1[y,2]	// Linha foi marcada para liberação
					RecLock('ZK3',.F.)
					ZK3->ZK3_FILIAL:=XFILIAL('ZK3')
					ZK3->ZK3_CODIGO:=cEdit0
					ZK3->ZK3_PROV:=PRD1
					ZK3->ZK3_COR:=aDados1[y,3]
					MsUnLock()
				Endif
				ZK3->(Dbskip())
			Next
		End
		ZK3->(DbCloseArea())
		//********************************************************************//
		/*    cAlias4='ZK1'
      dbSelectArea('ZK1')
      dbSetOrder(1)
      dbSeek(XFILIAL()+cEdit0,.F.)

	           	 RecLock("ZK1",.F.)
        		   ZK1->ZK1_FILIAL:=XFILIAL('ZK1')
			       ZK1->ZK1_CODIGO:=cEdit0
			       ZK1->ZK1_DESC:=cEdit1
			       ZK1->ZK1_COLUNA:=cEdit29
			       ZK1->ZK1_LINHA:=cEdit30
			       ZK1->ZK1_AMOSTR:=cEdit29
			       ZK1->ZK1_BASE:=cEdit2
	               ZK1->ZK1_GRADE:=PRD
	               ZK1->ZK1_TB_COL:=GRD
	               ZK1->ZK1_TB_LIN:=LNH
	               ZK1->ZK1_PROV:=PRD1
	               ZK1->ZK1_PV_COL:=GRD1
	               ZK1->ZK1_PV_LIN:=LNH1
	               ZK1->ZK1_IMG:=cEdit31
		          MsUnlock("ZK1")
  ZK1->(DbCloseArea())
		*/
		ALERT('Kit Alterado com Sucesso !!!')

	Endif
Return
//////////////////////////////////////////////////////////////////////
////*******************MAXVALIDA()******************************//////
//////////////////////////////////////////////////////////////////////
STATIC FUNCTION maxvld()

	TI++
	COL=VAL(cEdit29)

	IF TI=COL
		ALERT ('Todos os Itens ja Selecionados')
	ELSEIF  TI=COL-1
		ALERT ('Falta apenas 1 item a selecionar !')
	ELSEIF   TI>COL
		ALERT ('Foram selecionados itens a mais !')
	ENDIF



RETURN

//////////////////////////////////////////////////////////////////////
////********************MAXVALIDA1()****************************//////
//////////////////////////////////////////////////////////////////////
STATIC FUNCTION maxvld1()

	TIx++
	COLx=VAL(cEdit29)

	IF TIx=COLx
		ALERT ('Provadores ja Selecionados')
	ELSEIF  TIx = COLx-1
		ALERT ('Falta apenas 1 Provador a selecionar !')
	ELSEIF   TIx > COLx
		ALERT ('Foram selecionados provadores a mais !')
	ENDIF

RETURN

