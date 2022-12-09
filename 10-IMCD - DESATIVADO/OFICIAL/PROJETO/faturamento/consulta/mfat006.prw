/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFAT006   ºAutor  ³Marcos J.           º Data ³  12/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para leitura dos numeros de serie dos container's,  º±±
±±º          ³usados nas notas de saida.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#include "COLORS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
User Function MFAT006()
	Local aCores := {}

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MFAT006" , __cUserID )

	Private aRotina := {{"Pesquisar" , "AxPesqui"    , 0, 1, 0, .F.},;	// Pesquisar
	{"Visualizar", "U_MFAT006V()", 0, 2, 0, NIL},;	// Visualizar
	{"Leitura"   , "U_MFAT006A()", 0, 3, 0, NIL},;	// Leitura dos Numeros de Serie
	{"Legenda"   , "U_MFAT006L()", 0, 5, 0, NIL} }	// Legenda

	Private cCadastro := "Consulta Nota Fiscal de Saida"

	aCores := { {'F2_TIPO=="N"'	 , 'DISABLE'   },;	// NF Normal
	{'F2_TIPO=="P"'	 , 'BR_AZUL'   },;	// NF de Compl. IPI
	{'F2_TIPO=="I"'	 , 'BR_MARRON' },;	// NF de Compl. ICMS
	{'F2_TIPO=="C"'	 , 'BR_PINK'   },;	// NF de Compl. Preco/Frete
	{'F2_TIPO=="B"'	 , 'BR_CINZA'  },;	// NF de Beneficiamento
	{'F2_TIPO=="D"'  , 'BR_AMARELO'}}	// NF de Devolucao

	mBrowse( 6, 1, 22, 75, "SF2", , , , , , aCores )
Return( .T. )

User Function MFAT006V(cAlias,nReg,nOpc)
	Local aArea      := GetArea()
	Local aAreaSA1   := SA1->(GetArea())
	Local aAreaSA2   := SA2->(GetArea())
	Local aAreaSD2   := SD2->(GetArea())
	Local lQuery     := .F.
	Local cAliasSD2  := "SD2"
	Local cQuery     := ""

	MaFisSave()
	MaFisEnd()

	dbSelectArea("SD2")
	dbSetOrder(3)
	cAliasSD2 := CriaTrab(,.F.)
	lQuery := .T.
	cQuery := "SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_TIPO,R_E_C_N_O_ SD2RECNO "
	cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
	cQuery += "SD2.D2_DOC='"+SF2->F2_DOC+"' AND "
	cQuery += "SD2.D2_SERIE='"+SF2->F2_SERIE+"' AND "
	cQuery += "SD2.D2_CLIENTE='"+SF2->F2_CLIENTE+"' AND "
	cQuery += "SD2.D2_LOJA='"+SF2->F2_LOJA+"' AND "
	cQuery += "SD2.D2_TIPO='"+SF2->F2_TIPO+"' AND "
	cQuery += "SD2.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey()))
	cQuery := ChangeQuery(cQuery)		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

	While !Eof() .And. xFilial("SD2")  == (cAliasSD2)->D2_FILIAL .And.;
	SF2->F2_DOC     == (cAliasSD2)->D2_DOC .And.;
	SF2->F2_SERIE   == (cAliasSD2)->D2_SERIE .And.;
	SF2->F2_CLIENTE == (cAliasSD2)->D2_CLIENTE .And.;
	SF2->F2_LOJA    == (cAliasSD2)->D2_LOJA

		If SF2->F2_TIPO == (cAliasSD2)->D2_TIPO
			If lQuery
				SD2->(MsGoto((cAliasSD2)->SD2RECNO))
			EndIf
			A920NFSAI("SD2",SD2->(RecNo()),0)
			Exit
		EndIf
		dbSelectArea(cAliasSD2)
		dbSkip()
	EndDo

	If lQuery
		dbSelectArea(cAliasSD2)
		dbCloseArea()
		dbSelectArea("SD2")
	EndIf
	MaFisRestore()
	RestArea(aAreaSD2)
	RestArea(aAreaSA2)
	RestArea(aAreaSA1)
	RestArea(aArea)
Return (.T.)

User Function MFAT006L()
	BrwLegenda(cCadastro,"Legenda",{{"DISABLE"   , "NF Normal"                },;
	{"BR_AZUL"   , "NF de Compl. IPI"         },;
	{"BR_MARRON" , "NF de Compl. ICMS"        },;
	{"BR_PINK"   , "NF de Compl. Preco/Frete" },;
	{"BR_CINZA"  , "NF de Beneficiamento"     },;
	{"BR_AMARELO", "NF de Devolucao"          }})
Return .T.

User Function MFAT006A()
	Local aArea  := GetArea()
	Local cChvNF := SF2->( F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA )
	Local cQuery := ""
	Local nOpc   := 1
	Local cNome  := Posicione("SA1", 1, xFilial("SA1") + SF2->( F2_CLIENTE + F2_LOJA ), "A1_NOME" )

	Private cNumSer:= Space(15)
	Private cCodPro:= Space(15)
	Private oDlg
	Private VISUAL := .F.
	Private INCLUI := .F.
	Private ALTERA := .F.
	Private DELETA := .F.

	oPequeno := TFont():New("Courier New",08,18)
	oMedio   := TFont():New("Courier New",10,25)
	oGrande  := TFont():New("Courier New",14,25)
	oEnorme  := TFont():New("Courier New",16,25)
	oTitulo  := TFont():New("Times New Roman",18,25)
	While .T.
		DEFINE MSDIALOG oDlg TITLE "Scanner Nota Fiscal de Saida" FROM C(178),C(081) TO C(548),C(817) PIXEL

		@ C(005),C(020) Say "Leitura do Numero de Serie dos Container's" COLOR CLR_BLUE Object oCabec Size 500,25
		oCabec:oFont := oTitulo
		oCabec:lTransparent := .F.

		@ C(020),C(002) Say "Nota : " + SF2->F2_DOC + " " + SF2->F2_SERIE COLOR CLR_BLACK Object oNota
		oNota:oFont := oMedio
		oNota:lTransparent := .F.

		@ C(040),C(002) Say "Cliente : " + SF2->F2_CLIENTE + "-" + SF2->F2_LOJA + " " + cNome COLOR CLR_BLACK Object oCliente
		oCliente:oFont := oMedio
		oCliente:lTransparent := .F.

		@ C(060),C(007) Say "Produto : " COLOR CLR_BLACK

		@ C(080),C(007) Say "Qtd. Vendida : " COLOR CLR_BLACK

		@ C(080),C(080) Say "Qtd. Lida : " COLOR CLR_BLACK

		@ C(100),C(007) Say "Codigo     : " COLOR CLR_BLACK
		@ C(100),C(040) Get cCodPro F3 "SB1" Valid MFAT006PROD(M->cCodPro) Size 100,25 Object oCodPro

		@ C(120),C(007) Say "Num. Serie : " COLOR CLR_BLACK
		@ C(120),C(040) Get cNumSer Valid MFAT006ITEM(M->cNumSer, M->cCodPro) Size 100,25 Object oNumSer
		oNumSer:oFont := oPequeno

		DEFINE SBUTTON FROM C(120), C(170) TYPE 1  ENABLE OF oDlg Action ( nOpc:=1 )
		DEFINE SBUTTON FROM C(120), C(220) TYPE 22 ENABLE OF oDlg Action ( nOpc:=2, oDlg:End() )
		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpc == 2
			RestArea( aArea )
			Return
		EndIf
	EndDo

Static Function MFAT006PROD( cProduto )
	Local cAlias := Alias()

	SB1->(DbSetOrder(1))
	SB1->(DbGoTop() )

	SD2->(DbSetOrder(3))
	SD2->(DbGoTop())

	If SB1->(DbSeek(xFilial("SB1") + cProduto, .F. ))

		SD2->(DbSeek(xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA ) + SB1->B1_COD, .F. ))
		nReg := SD2->(RecNo())
		lReg := .T.

		While SD2->(!Eof()) .and. SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + SB1->B1_COD == SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) + SB1->B1_COD
			If SD2->D2_EMBLID < SD2->D2_QUANT
				lReg := .F.
				Exit
			Else
				SD2->(DbSkip())
				Loop
			EndIf
		EndDo

		If lReg
			SD2->(DbGoTo(nReg))
		EndIf

		@ C(060),C(030) Say SB1->B1_COD + " " + SB1->B1_DESC Size 500,10 Object oDescr
		oDescr:oFont := oMedio
		oDescr:lTransparent := .F.

		@ C(080),C(030) Say TransForm( SD2->D2_QUANT, "@E 9,999" ) Size 30,10 Object oQuant
		oQuant:oFont := oMedio
		oQuant:lTransparent := .F.

		@ C(080),C(100) Say TransForm( SD2->D2_EMBLID, "@E 9,999" ) Size 30,10 Object oNLido
		oNLido:oFont := oMedio
		oNLido:lTransparent := .F.
		oDlg:Refresh()

		DbSelectArea( cAlias )
		Return( .T. )
	Else
		MsgBox( "Não existe este código na tabela SB1", "Não Localizado", "STOP" )
		DbSelectArea( cAlias )
		Return( .F. )
	EndIf

Static Function MFAT006ITEM( cNumero, cProduto )
	Local cArea := Alias()
	Local lOk   := .F.

	If Empty(cNumero)
		Return .T.
	EndIf

	SZ8->(DbSetOrder(1))
	If SZ8->(DbSeek(xFilial("SZ8") + cProduto + cNumero, .F.))
		If SZ8->Z8_USADO == "2"
			SD2->(DbSetOrder(3))
			SD2->(DbSeek(xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + SB1->B1_COD, .F.))
			While SD2->(!Eof()) .and. SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + SB1->B1_COD == SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) + SB1->B1_COD
				If SD2->D2_EMBLID < SD2->D2_QUANT
					lOk := .T.
					Exit
				Else
					SD2->(DbSkip())
					Loop
				EndIf
			EndDo

			If lOk
				SZ8->(RecLock("SZ8", .F.))
				SZ8->Z8_USADO := "1"
				SZ8->(MsUnLock())

				SZ9->(RecLock("SZ9", .T.))
				SZ9->Z9_FILIAL  := xFilial("SZ9")
				SZ9->Z9_PRODUTO := SZ8->Z8_PRODUTO
				SZ9->Z9_NUMSER  := SZ8->Z8_NUMSER
				SZ9->Z9_DTSAI   := SF2->F2_EMISSAO
				SZ9->Z9_NFSAI   := SF2->F2_DOC
				SZ9->Z9_SERSAI  := SF2->F2_SERIE
				SZ9->Z9_ITSAI   := SD2->D2_ITEM
				SZ9->Z9_CLISAI  := SF2->F2_CLIENTE
				SZ9->Z9_LJSAI   := SF2->F2_LOJA
				SZ9->(MsUnLock())

				SD2->(RecLock( "SD2", .F.))
				SD2->D2_EMBLID += 1
				SD2->(MsUnLock())

				@ C(080),C(030) Say TransForm( SD2->D2_QUANT, "@E 9,999" ) Size 30,10 Object oQuant
				oQuant:oFont := oMedio
				oQuant:lTransparent := .F.

				@ C(080),C(100) Say TransForm(SD2->D2_EMBLID, "@E 9,999") Size 30,10 Object oNLido
				oNLido:oFont := oMedio
				oNLido:lTransparent := .F.

				cNumSer := Space(15)
				oNumSer:SetFocus()
				oDlg:Refresh()
				Return
			Else
				MsgBox( "Este item já foi lido completamente.", "Encerrado", "STOP" )
				cNumSer := Space(15)
				oNumSer:SetFocus()
				DbSelectArea( cArea )
				oDlg:Refresh()
				Return
			EndIf
		Else
			MsgBox("Item não está disponível para uso.", "Não lierado", "STOP" )
			cNumSer := Space(15)
			oNumSer:SetFocus()
			DbSelectArea( cArea )
			oDlg:Refresh()
			Return
		EndIf
	Else
		MsgBox( "Não existe o item : " + cProduto + " N/S " + cNumero + " no cadastro de container's.", "Sem cadastro", "STOP" )
		cNumSer := Space(15)
		oNumSer:SetFocus()
		DbSelectArea( cArea )
		oDlg:Refresh()
		Return
	EndIf
	DbSelectArea(cArea )
	cNumSer := Space(15)
	oNumSer:SetFocus()
	oDlg:Refresh()
Return

Static Function C(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth
	If nHRes == 640
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)
		nTam *= 1
	Else
		nTam *= 1.28
	EndIf
	nTam *= 0.90
Return Int(nTam)