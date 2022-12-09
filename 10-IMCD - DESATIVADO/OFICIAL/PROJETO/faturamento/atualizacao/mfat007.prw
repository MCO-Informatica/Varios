/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFAT007   บAutor  ณMarcos J.           บ Data ณ  12/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para leitura dos numeros de serie dos container's,  บฑฑ
ฑฑบ          ณusados nas notas de saida.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
#include "COLORS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
User Function MFAT007()
	Local aCores := {}

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MFAT007" , __cUserID )

	Private aRotina := {{"Pesquisar" , "AxPesqui"    , 0, 1, 0, .F.},;	// Pesquisar
	{"Visualizar", "A103NFiscal" , 0, 2, 0, NIL},;	// Visualizar
	{"Leitura"   , "U_MFAT007A()", 0, 3, 0, NIL},;	// Leitura dos Numeros de Serie
	{"Legenda"   , "U_MFAT007L()", 0, 5, 0, NIL} }	// Legenda

	Private cCadastro := "Retorno de container"

	aCores := {{'Empty(F1_STATUS)'	,'ENABLE'		},;	// NF Nao Classificada
	{'F1_STATUS=="B"'	,'BR_LARANJA'	},;	// NF Bloqueada
	{'F1_TIPO=="N"'		,'DISABLE'   	},;	// NF Normal
	{'F1_TIPO=="P"'		,'BR_AZUL'   	},;	// NF de Compl. IPI
	{'F1_TIPO=="I"'		,'BR_MARROM' 	},;	// NF de Compl. ICMS
	{'F1_TIPO=="C"'		,'BR_PINK'   	},;	// NF de Compl. Preco/Frete
	{'F1_TIPO=="B"'		,'BR_CINZA'  	},;	// NF de Beneficiamento
	{'F1_TIPO=="D"'		,'BR_AMARELO'	} }	// NF de Devolucao

	mBrowse( 6, 1, 22, 75, "SF1", , , , , , aCores )
Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFAT007   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MFAT007L()
	BrwLegenda(cCadastro,"Legenda",{{"ENABLE"    , "Docto nao classificado"   },;
	{"BR_LARANJA", "Docto bloqueado"          },;
	{"DISABLE"   , "Docto normal"             },;
	{"BR_AZUL"   , "Docto de compl. IPI"      },;
	{"BR_MARROM" , "Docto de compl. ICMS"     },;
	{"BR_PINK"   , "Docto de compl. Preco"    },;
	{"BR_CINZA"  , "Docto de beneficiamento"  },;
	{"BR_AMARELO", "Docto de devolucao"       }})
Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFAT007   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MFAT007A()
	Local aArea  := GetArea()
	Local cChvNF := SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )
	Local cQuery := ""
	Local nOpc   := 1
	Local cNome  := ""

	Private cNumSer:= Space(15)
	Private cCodPro:= Space(15)
	Private oDlg
	Private VISUAL := .F.
	Private INCLUI := .F.
	Private ALTERA := .F.
	Private DELETA := .F.

	If Alltrim(SF1->F1_TIPO) $ "B|D"
		cNome := Posicione("SA1", 1, xFilial("SA1") + SF1->( F1_FORNECE + F1_LOJA ), "A1_NOME" )
	Else
		cNome := Posicione("SA2", 1, xFilial("SA2") + SF1->( F1_FORNECE + F1_LOJA ), "A2_NOME" )
	EndIf

	oPequeno := TFont():New("Courier New",08,18)
	oMedio   := TFont():New("Courier New",10,25)
	oGrande  := TFont():New("Courier New",14,25)
	oEnorme  := TFont():New("Courier New",16,25)
	oTitulo  := TFont():New("Times New Roman",18,25)
	While .T.
		DEFINE MSDIALOG oDlg TITLE "Scanner Nota Fiscal de Entrada" FROM C(178),C(081) TO C(548),C(817) PIXEL

		@ C(005),C(020) Say "Leitura do Numero de Serie dos Container's" COLOR CLR_BLUE Object oCabec Size 500,25
		oCabec:oFont := oTitulo
		oCabec:lTransparent := .F.

		@ C(020),C(002) Say "Nota : " + SF1->F1_DOC + " / " + SF1->F1_SERIE COLOR CLR_BLACK Object oNota
		oNota:oFont := oMedio
		oNota:lTransparent := .F.

		@ C(040),C(002) Say "Cliente : " + SF1->F1_FORNECE + "-" + SF1->F1_LOJA + " " + cNome COLOR CLR_BLACK Object oCliente
		oCliente:oFont := oMedio
		oCliente:lTransparent := .F.

		@ C(060),C(007) Say "Produto : " COLOR CLR_BLACK

		@ C(080),C(007) Say "Qtd. Vendida : " COLOR CLR_BLACK

		@ C(080),C(080) Say "Qtd. Lida : " COLOR CLR_BLACK

		@ C(100),C(007) Say "Codigo     : " COLOR CLR_BLACK
		@ C(100),C(040) Get cCodPro F3 "SB1" Valid MFAT007PROD(M->cCodPro) Size 100,25 Object oCodPro

		@ C(120),C(007) Say "Num. Serie : " COLOR CLR_BLACK
		@ C(120),C(040) Get cNumSer Valid MFAT007ITEM(M->cNumSer, M->cCodPro) Size 100,25 Object oNumSer
		oNumSer:oFont := oPequeno

		DEFINE SBUTTON FROM C(120), C(170) TYPE 1  ENABLE OF oDlg Action ( nOpc:=1 )
		DEFINE SBUTTON FROM C(120), C(220) TYPE 22 ENABLE OF oDlg Action ( nOpc:=2, oDlg:End() )
		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpc == 2
			RestArea( aArea )
			Return
		EndIf
	EndDo

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFAT007   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MFAT007PROD( cProduto )
	Local cAlias := Alias()

	SB1->(DbSetOrder(1))
	SB1->(DbGoTop() )

	SD1->(DbSetOrder(1))
	SD1->(DbGoTop())

	If SB1->(DbSeek(xFilial("SB1") + cProduto, .F. ))

		SD1->(DbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) + SB1->B1_COD, .F. ))
		nReg := SD1->(RecNo())
		lReg := .T.

		While SD1->(!Eof()) .and. SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) + SB1->B1_COD == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) + SB1->B1_COD
			If SD1->D1_EMBLID < SD1->D1_QUANT
				lReg := .F.
				Exit
			Else
				SD1->(DbSkip())
				Loop
			EndIf
		EndDo

		If lReg
			SD1->(DbGoTo(nReg))
		EndIf

		@ C(060),C(030) Say SB1->B1_COD + " " + SB1->B1_DESC Size 500,10 Object oDescr
		oDescr:oFont := oMedio
		oDescr:lTransparent := .F.

		@ C(080),C(030) Say TransForm( SD1->D1_QUANT, "@E 9,999" ) Size 30,10 Object oQuant
		oQuant:oFont := oMedio
		oQuant:lTransparent := .F.

		@ C(080),C(100) Say TransForm( SD1->D1_EMBLID, "@E 9,999" ) Size 30,10 Object oNLido
		oNLido:oFont := oMedio
		oNLido:lTransparent := .F.
		oDlg:Refresh()

		DbSelectArea( cAlias )
		Return( .T. )
	Else
		MsgBox( "Nใo existe este c๓digo na tabela SB1", "Nใo Localizado", "STOP" )
		DbSelectArea( cAlias )
		Return( .F. )
	EndIf

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFAT007   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MFAT007ITEM( cNumero, cProduto )
	Local cArea := Alias()
	Local lOk   := .F.

	If Empty(cNumero)
		Return .T.
	EndIf

	SZ8->(DbSetOrder(1))
	If SZ8->(DbSeek(xFilial("SZ8") + cProduto + cNumero, .F.))
		If SZ8->Z8_USADO == "1"
			SD1->(DbSetOrder(1))
			SD1->(DbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) + SB1->B1_COD, .F.))
			While SD1->(!Eof()) .and. SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) + SB1->B1_COD == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) + SB1->B1_COD
				If SD1->D1_EMBLID < SD1->D1_QUANT
					lOk := .T.
					Exit
				Else
					SD1->(DbSkip())
					Loop
				EndIf
			EndDo

			If lOk
				SZ8->(RecLock("SZ8", .F.))
				SZ8->Z8_USADO := "2"
				SZ8->(MsUnLock())

				SZ9->(RecLock("SZ9", .T.))
				SZ9->Z9_FILIAL  := xFilial("SZ9")
				SZ9->Z9_PRODUTO := SZ8->Z8_PRODUTO
				SZ9->Z9_NUMSER  := SZ8->Z8_NUMSER
				SZ9->Z9_DTRET   := SF1->F1_EMISSAO
				SZ9->Z9_NFRET   := SF1->F1_DOC
				SZ9->Z9_SERRET  := SF1->F1_SERIE
				SZ9->Z9_ITRET   := SD1->D1_ITEM
				SZ9->Z9_CLIRET  := SF1->F1_FORNECE
				SZ9->Z9_LJRET   := SF1->F1_LOJA
				SZ9->(MsUnLock())

				SD1->(RecLock( "SD1", .F.))
				SD1->D1_EMBLID += 1
				SD1->(MsUnLock())

				@ C(080),C(030) Say TransForm( SD1->D1_QUANT, "@E 9,999" ) Size 30,10 Object oQuant
				oQuant:oFont := oMedio
				oQuant:lTransparent := .F.

				@ C(080),C(100) Say TransForm(SD1->D1_EMBLID, "@E 9,999") Size 30,10 Object oNLido
				oNLido:oFont := oMedio
				oNLido:lTransparent := .F.

				cNumSer := Space(15)
				oNumSer:SetFocus()
				oDlg:Refresh()
				Return
			Else
				MsgBox( "Este item jแ foi lido completamente.", "Encerrado", "STOP" )
				cNumSer := Space(15)
				oNumSer:SetFocus()
				DbSelectArea( cArea )
				oDlg:Refresh()
				Return
			EndIf
		Else
			MsgBox("Item nใo estแ disponํvel para uso.", "Nใo lierado", "STOP" )
			cNumSer := Space(15)
			oNumSer:SetFocus()
			DbSelectArea( cArea )
			oDlg:Refresh()
			Return
		EndIf
	Else
		MsgBox( "Nใo existe o item : " + cProduto + " N/S " + cNumero + " no cadastro de container's.", "Sem cadastro", "STOP" )
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFAT007   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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