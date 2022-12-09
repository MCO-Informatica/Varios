#include "Protheus.ch"
#INCLUDE "Rwmake.CH"
#INCLUDE "JPEG.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCIRAP   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Tela de Consulta Rapida          						   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCIRAP(cCodOrig,cCliOrig,cTipo)
  Local aAreaAtu	:= GetArea()
  STATIC oCheckBo1
  STATIC lCheckBo1 := .T.
  STATIC oCheckBo2
  STATIC lCheckBo2 := .F.
  STATIC oDlg,oList866,oSBtn0977,oSBtnT99,oSBtn194,oSBtn159,oSBtnS99,oGrp2,oCombo3,oSBtn559,oSBtn562,oSBtn560,oSBtn561,oSBtn4,oSBtn144,oSBtn095,oSBtn096,oSBtn097,oSBtn098,oSBtn099,cCod1,cCli00,cCli01,cCli02,cCli03,oSay6,oSay306,oSay9,oGrp10,oCombo11,oSBtn12,oSBtn15,oGrp16,oGrp18,oSay20,oCombo21,oGet22,oGeta22,oGet223,oGet23,oSay24,oSay25,oGrp27,oSay28,oGet29,oSay30,oSay254,oGet254,oSay255,oGet255,oSay256,oGet256,oGet31,oGet32,oSay33,oSay34,oSay35,oGet36,oGet37,oGet38,oGet39,oGet40,oSBtn41,oSay42,oSay43,oSay44,oSay45,oGet46,oSay47,oGet48,oSay49,oGet50,oGet51,oGet52,oSay53,oSay54,oGrp57,oGrp58,oCombo59,oSay60,oSBtn61,oCombo63,oSay64,oChk65,oCombo66,oCombo67,oSay68,oSay69,oChk70,oGrp71,oSay72,oGet73,oCombo74,oSay75,oSay85,oGet85,oSay985,oGet985,oSay86,oGet86,oGet386,oSay386,oGet387,oSay387,oGet388,oSay388,oCombo76,oSay77,oGet777,oCombo78,oSay79,oGrp81,oGrp82,oGrp83,oGrp84,oSBtn85,oList86,oList87,oList88,oSBtn89,oGet90,oSay100,oSay102,oSay103,oSay104,oSay105,oSay106,oSay107,oSay108,oSay109,oSay110,oSay111,oSay112,oGet115,oGet114,oGet132,oGet116,oGet117,oGet118,oGet119,oGet120,oGet121,oGet122,oGet123,oGet127,oGet128,oGet129,oGet130,oGet131,oGet148,oGet133,oGet134,oGet135,oGet136,oGet137,oGet138,oGet139,oSay200,oGet200,oSBtn91,oSBtn92,oSBtn93,oGet216,oSay216,oGet217,oSay217,oSay297,oGet297, oSayi04, oGetI000, oGetI041, oGetI042, oGetI043,oGetZ38
  STATIC aAlterna:={}
  Static aFornQual:={}
  Static aTbPr:={}
  sTATIC aAvancada:={}
  sTATIC aVdaPend:={}
  sTATIC aCpaPend:={}
  Static aOsPend:={}
  Static aVdaEntr:={}
  Static aAlmox:={}
  Static aHistEnt:={}
  Static aHistOrc:={}
  STATIC aLimpa  :={}
  Static aOrc:={}
  STATIC aOS:={}
  STATIC aStackTMP:= {}
  STATIC cboAvanc
  STATIC cCodigo:=SPACE(15)
  STATIC cboOutros:=SPACE(50)
  Static cCli:=Space(6)
  Static cNumOrc:=Space(6)
  Static cLoja:=Space(2)
  Static cNomered
  STATIC cTabela
  Static cVdMn
  Static cVdNor
  Static cQtdVd:=1
  Static cQtdV2:=0
  Static cMedio
  Static cVend1
  Static cVend5
  Static cMensagem
  Static cIcms
  Static cCofins
  Static cPis
  Static cCod
  Static cPP
  Static cLj
  Static cDescr
  Static cPolVenda
  Static cAlmox
  Static nPeso
  Static cUnid
  Static cEstmin
  Static cLtime
  Static cboPoc
  Static cboPos
  Static cboPvend
  Static cboVentr
  Static nSdep
  Static nEstfis
  Static nOrcPen
  Static nEstVir
  Static nCasada
  Static nOsVir
  Static nPoder3
  Static nDe3
  Static cboEsAl
  Static cboPreNF
  Static cboEster
  Static lstFqual
  Static lstTbPr
  Static lstEntr
  Static lstOrc
  Static cTecn
  Static chkCompleta
  Static cCusto
  Static cMed2
  Static nScompra
  Static cDtInv
  Static cGuarda
  Static cValorOrc
  Static cBaseOrc
  Static cTipov
  Static nTravado
  Static cTiEs
  Static cRastro
  Static aColOcPv := {}
// margem padrao do produto
  Static cMC1
  Static cMC2
  Static cMC3
// comissao variavel direto (1) / direto+comprador(2) /representante+comprador(3)
  Static cComis1
  Static cComis2
  Static cComis3
// pis padrao do produto
  Static cPis1
  Static cPis2
  Static cPis3
// cofins padrao do produto
  Static cCof1
  Static cCof2
  Static cCof3
// venda com icms 0
  Static cIc001
  Static cIc002
  Static cIc003
// venda com icms 7
  Static cIc071
  Static cIc072
  Static cIc073
// venda com icms 12
  Static cIc121
  Static cIc122
  Static cIc123
// venda com icms 18
  Static cIc181
  Static cIc182
  Static cIc183
// venda com icms 04
  Static cIc041
  Static cIc042
  Static cIc043
  Static cIcmg
  Static oGet947

  cRastro:=""
  cValorOrc:=0
  nTravado:=0
  IF cCodOrig!=nil
    cCodigo:=cCodOrig
    cTipov:=cTipo
  endif
  Private aRotina	:=	{{"Pesquisar", "AxPesqui" , 0 , 1},; //"Pesquisar"
  {"Visualizar", "AxVisual" , 0 , 2}}  //"Visualizar"

  DEFINE FONT oFontB NAME "Arial" 		  SIZE 7,20 BOLD	// Bordero
  DEFINE FONT oFontT NAME "Arial"         SIZE 5,12		// Filtro da quebra (Titulo)
  DEFINE FONT oFontP NAME "Courier New"	  SIZE 7,20 BOLD	// Processando...
  DEFINE FONT oFontE NAME "Arial"		  SIZE 9,20 BOLD	// PROCESSADO!
  DEFINE FONT oFontK NAME "Arial"         SIZE 5,9		// Filtro da quebra (Titulo)
  DEFINE FONT oFontQ NAME "Arial" 		  SIZE 6,14 BOLD	// Bordero

/*
AAdd( aColors,  CLR_BLACK     )
AAdd( aColors,  CLR_BLUE      )
AAdd( aColors,  CLR_GREEN     )
AAdd( aColors,  CLR_CYAN      )
AAdd( aColors,  CLR_RED       )
AAdd( aColors,  CLR_MAGENTA   )
AAdd( aColors,  CLR_BROWN     )
AAdd( aColors,  CLR_HGRAY     )
AAdd( aColors,  CLR_LIGHTGRAY )
AAdd( aColors,  CLR_GRAY      )
AAdd( aColors,  CLR_HBLUE     )
AAdd( aColors,  CLR_HGREEN    )
AAdd( aColors,  CLR_HCYAN     )
AAdd( aColors,  CLR_HRED      )
AAdd( aColors,  CLR_HMAGENTA  )
AAdd( aColors,  CLR_YELLOW    )
AAdd( aColors,  CLR_WHITE     )






*/ 



  oDlg := MSDIALOG():Create()
  oDlg:cName := "oDlg"
  oDlg:cCaption := "Consulta Rapida de Produtos"
  oDlg:nLeft := 54
  oDlg:nTop := 91
  oDlg:nWidth := 952
  oDlg:nHeight := 590
  oDlg:lShowHint := .F.
  oDlg:lCentered := .F.


//oGrp2 := TGROUP():New(,,,,,oDlg,,CLR_BLACK,,)
  oGrp2 := TGROUP():Create(oDlg)
  oGrp2:cName := "oGrp2"
  oGrp2:cCaption := "Consulta de Produtos"
  oGrp2:nLeft := 1
  oGrp2:nTop := 2
  oGrp2:nWidth := 651
  oGrp2:nHeight := 66
  oGrp2:lShowHint := .T.
  oGrp2:lReadOnly := .F.
  oGrp2:Align := 0
  oGrp2:lVisibleControl := .T.

  @ 022, 330 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "I.Inativos" SIZE 088, 008 OF oDlg
  @ 022, 380 CHECKBOX oCheckBo2 VAR lCheckBo2 PROMPT "I.Filiais" SIZE 088, 008 OF oDlg

  oSBtn194 := TBUTTON():Create(oDlg)
  oSBtn194:cName := "oSBtn194"
  oSBtn194:cCaption := "PC"
  oSBtn194:cMsg := "Mudar Politica Comercial"
  oSBtn194:nLeft := 820
  oSBtn194:nTop := 40
  oSBtn194:nWidth := 20
  oSBtn194:nHeight := 22
  oSBtn194:lShowHint := .F.
  oSBtn194:lReadOnly := .F.
  oSBtn194:Align := 0
  oSBtn194:lVisibleControl := .T.
//oSBtn4:nType := 1
  oSBtn194:bAction:={|| U_HCPOL()}

  oSay6 := TSAY():Create(oDlg)
  oSay6:cName := "oSay6"
  oSay6:cCaption := "Codigo"
  oSay6:nLeft := 10
  oSay6:nTop := 18
  oSay6:nWidth := 47
  oSay6:nHeight := 17
  oSay6:lShowHint := .F.
  oSay6:lReadOnly := .F.
  oSay6:Align := 0
  oSay6:lVisibleControl := .T.
  oSay6:lWordWrap := .F.
  oSay6:lTransparent := .t.


//cCod1 := TGET():Create(oDlg)
  cCod1 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(229,225,143),,,,,,,,,,,,,,,,,,)
  cCod1:cF3 := "SB1"
  cCod1:cName := "cCod1"
  cCod1:nLeft := 77
  cCod1:nTop := 15
  cCod1:nWidth := 105
  cCod1:nHeight := 21
  cCod1:lShowHint := .F.
  cCod1:lReadOnly := .F.
  cCod1:Align := 0
  cCod1:cVariable := "cCodigo"
  cCod1:bSetGet := {|u| If(PCount()>0,cCodigo:=u,upper(cCodigo))}
  cCod1:lVisibleControl := .T.
  cCod1:lPassword := .F.
  cCod1:lHasButton := .F.
  cCod1:bVALID := {|| U_PCODPR(cCodOrig,cCliOrig) }
  cCod1:setCSS("QLineEdit{color:#B22222; background-color:#FFEBCD}")

// FILTRO POR CLIENTE
  oSay306 := TSAY():Create(oDlg)
  oSay306:cName := "oSay306"
  oSay306:cCaption := "|Qtd       |Cliente              |Lj   |Num. Orc.  |Nomered        "
  oSay306:nLeft := 200
  oSay306:nTop := 2
  oSay306:nWidth := 400
  oSay306:nHeight := 17
  oSay306:lShowHint := .F.
  oSay306:lReadOnly := .F.
  oSay306:Align := 0
  oSay306:lVisibleControl := .T.
  oSay306:lWordWrap := .F.
  oSay306:lTransparent := .t.

  cCli00:= TGET():New(,,,oDlg,,,"@E 99999",,CLR_RED,RGB(229,225,143),,,,,,,,,,,,,,,,,,)
  cCli00:cName := "cCli00"
  cCli00:nLeft := 200
  cCli00:nTop := 15
  cCli00:nWidth := 40
  cCli00:nHeight := 21
  cCli00:lShowHint := .F.
  cCli00:lReadOnly := .F.
  cCli00:Align := 0
  cCli00:cVariable := "cQtdVd"
  cCli00:bSetGet := {|u| If(PCount()>0,cQtdVd:=u,cQtdVd)}
  cCli00:lVisibleControl := .T.
  cCli00:lPassword := .F.
  cCli00:lHasButton := .F.
  cCLI00:bVALID := {|| U_PCODQT() }
//cCli00:bVALID := {|| U_PCODPR(cCodOrig,cCliOrig) }
  cCLI00:setCSS("QLineEdit{color:#B22222; background-color:#FFEBCD}")


//cCod1 := TGET():Create(oDlg)
  cCli01:= TGET():New(,,,oDlg,,,,,CLR_RED,RGB(229,225,143),,,,,,,,,,,,,,,,,,)
  cCli01:cF3 := "SA1"
  cCli01:cName := "cCli01"
  cCli01:nLeft := 240
  cCli01:nTop := 15
  cCli01:nWidth := 60
  cCli01:nHeight := 21
  cCli01:lShowHint := .F.
  cCli01:lReadOnly := .F.
  cCli01:Align := 0
  cCli01:cVariable := "cCli"
  cCli01:bSetGet := {|u| If(PCount()>0,cCli:=u,cCli)}
  cCli01:lVisibleControl := .T.
  cCli01:lPassword := .F.
  cCli01:lHasButton := .F.
  cCLI01:bVALID := {|| U_PCODCL() }
  cCLI01:setCSS("QLineEdit{color:#B22222; background-color:#FFEBCD}")

  cCli02:= TGET():New(,,,oDlg,,,,,CLR_RED,RGB(229,225,143),,,,,,,,,,,,,,,,,,)
  cCli02:cName := "cCli02"
  cCli02:nLeft := 314
  cCli02:nTop := 15
  cCli02:nWidth := 20
  cCli02:nHeight := 21
  cCli02:lShowHint := .F.
  cCli02:lReadOnly := .F.
  cCli02:Align := 0
  cCli02:cVariable := "cLoja"
  cCli02:bSetGet := {|u| If(PCount()>0,cLoja:=u,cLoja)}
  cCli02:lVisibleControl := .T.
  cCli02:lPassword := .F.
  cCli02:lHasButton := .F.
  cCli02:setCSS("QLineEdit{color:#B22222; background-color:#FFEBCD}")

  cCli03:= TGET():New(,,,oDlg,,,,,CLR_RED,RGB(229,225,143),,,,,,,,,,,,,,,,,,)
  cCli03:cName := "cCli03"
  cCli03:nLeft := 334
  cCli03:nTop := 15
  cCli03:nWidth := 56
  cCli03:nHeight := 21
  cCli03:lShowHint := .F.
  cCli03:lReadOnly := .F.
  cCli03:Align := 0
  cCli03:cVariable := "cNumOrc"
  cCli03:bSetGet := {|u| If(PCount()>0,cNumOrc:=u,cNumOrc)}
  cCli03:lVisibleControl := .T.
  cCli03:lPassword := .F.
  cCli03:lHasButton := .F.
  cCli03:setCSS("QLineEdit{color:#B22222; background-color:#FFEBCD}")

  oGet223 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet223:cName := "oGet223"
  oGet223:nLeft := 390
  oGet223:nTop := 15
  oGet223:nWidth := 135
  oGet223:nHeight := 21
  oGet223:lShowHint := .F.
  oGet223:lReadOnly := .F.
  oGet223:Align := 0
  oGet223:cVariable := "cNomered"
  oGet223:bSetGet := {|u| If(PCount()>0,cNomered:=u,cNomered) }
  oGet223:lVisibleControl := .T.
  oGet223:lPassword := .F.
  oGet223:lHasButton := .F.
  oGet223:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oSBtn4 := TBUTTON():Create(oDlg)
  oSBtn4:cName := "oSBtn4"
  oSBtn4:cCaption := "B. Avancada"
  oSBtn4:cMsg := "Consultar"
  oSBtn4:nLeft := 529
  oSBtn4:nTop := 14
  oSBtn4:nWidth := 72
  oSBtn4:nHeight := 22
  oSBtn4:lShowHint := .F.
  oSBtn4:lReadOnly := .F.
  oSBtn4:Align := 0
  oSBtn4:lVisibleControl := .T.
//oSBtn4:nType := 1
  oSBtn4:bAction:={|| U_HCAVANC()}

  oSBtn15 := TBUTTON():Create(oDlg)
  oSBtn15:cName := "oSBtn15"
  oSBtn15:cCaption := "<<<"
  oSBtn15:nLeft := 598
  oSBtn15:nTop := 14
  oSBtn15:nWidth := 25
  oSBtn15:nHeight := 22
  oSBtn15:lShowHint := .F.
  oSBtn15:lReadOnly := .F.
  oSBtn15:Align := 0
  oSBtn15:lVisibleControl := .T.
//oSBtn15:nType := 1
  oSBtn15:bAction:={|| U_DOUTRB()}

  oSBtn159 := TBUTTON():Create(oDlg)
  oSBtn159:cName := "oSBtn15"
  oSBtn159:cCaption := "PP"
  oSBtn159:nLeft := 623
  oSBtn159:nTop := 14
  oSBtn159:nWidth := 20
  oSBtn159:nHeight := 22
  oSBtn159:lShowHint := .F.
  oSBtn159:lReadOnly := .F.
  oSBtn159:Align := 0
  oSBtn159:lVisibleControl := .T.
//oSBtn15:nType := 1
  oSBtn159:bAction:={|| U_HCAVPP()}



//oSay9:= tSay():New(,,,oDlg,,,,,,,CLR_RED,CLR_WHITE,,)
  oSay9:= TSAY():Create(oDlg)
  oSay9:cName := "oSay9"
  oSay9:cCaption := "C. Avancada"
  oSay9:nLeft := 10
  oSay9:nTop := 45
  oSay9:nWidth := 67
  oSay9:nHeight := 17
  oSay9:lShowHint := .F.
  oSay9:lReadOnly := .F.
  oSay9:Align := 0
  oSay9:lVisibleControl := .T.
  oSay9:lWordWrap := .F.
  oSay9:lTransparent := .t.



  oCombo3 := TCOMBOBOX():Create(oDlg)
  oCombo3:cName := "oCombo3"
  oCombo3:nLeft := 77
  oCombo3:nTop := 40
  oCombo3:nWidth := 565
  oCombo3:nHeight := 21
  oCombo3:lShowHint := .F.
  oCombo3:lReadOnly := .F.
  oCombo3:Align := 0
  oCombo3:cVariable := "cboAvanc"
  oCombo3:bSetGet := {|u| If(PCount()>0,cboAvanc:=u,cboAvanc) }
  oCombo3:lVisibleControl := .T.
  oCombo3:aItems := aAvancada
  oCombo3:nAt := 1



  oGrp10 := TGROUP():Create(oDlg)
  oGrp10:cName := "oGrp10"
  oGrp10:cCaption := "Codigos Alternativos"
  oGrp10:nLeft := 653
  oGrp10:nTop := 2
  oGrp10:nWidth := 290
  oGrp10:nHeight := 66
  oGrp10:lShowHint := .F.
  oGrp10:lReadOnly := .F.
  oGrp10:Align := 0
  oGrp10:lVisibleControl := .T.

  oCombo11 := TCOMBOBOX():Create(oDlg)
  oCombo11:cName := "oCombo11"
  oCombo11:nLeft := 660
  oCombo11:nTop := 18
  oCombo11:nWidth := 277
  oCombo11:nHeight := 21
  oCombo11:lShowHint := .F.
  oCombo11:lReadOnly := .F.
  oCombo11:Align := 0
  oCombo11:cVariable := "cboOutros"
  oCombo11:bSetGet := {|u| If(PCount()>0,cboOutros:=u,cboOutros) }
  oCombo11:lVisibleControl := .T.
  oCombo11:aItems := aAlterna
  oCombo11:nAt := 1
//oCombo11:bChange := {|| U_DOUTRA() } 


  oSBtn12 := TBUTTON():Create(oDlg)
  oSBtn12:cName := "oSBtn12"
  oSBtn12:cCaption := "Migrar"
  oSBtn12:nLeft := 879
  oSBtn12:nTop := 41
  oSBtn12:nWidth := 52
  oSBtn12:nHeight := 22
  oSBtn12:lShowHint := .F.
  oSBtn12:lReadOnly := .F.
  oSBtn12:Align := 0
  oSBtn12:lVisibleControl := .T.
//oSBtn12:nType := 1
  oSBtn12:bAction:={|| U_DOUTRA()}


  oSBtn144 := TBUTTON():Create(oDlg)
  oSBtn144:cName := "oSBtn144"
  oSBtn144:cCaption := "Estrutura Produto"
  oSBtn144:cMsg := "Consultar"
  oSBtn144:nLeft := 350
  oSBtn144:nTop := 14
  oSBtn144:nWidth := 92
  oSBtn144:nHeight := 22
  oSBtn144:lShowHint := .F.
  oSBtn144:lReadOnly := .F.
  oSBtn144:Align := 0
  oSBtn144:lVisibleControl := .F.
//oSBtn144:nType := 1
  oSBtn144:bAction:={|| A093Prod(.F.)}


  oGrp16 := TGROUP():Create(oDlg)
  oGrp16:cName := "oGrp16"
  oGrp16:cCaption := "Dados do Produto Consultado"
  oGrp16:nLeft := 2
  oGrp16:nTop := 66
  oGrp16:nWidth := 650
  oGrp16:nHeight := 110
  oGrp16:lShowHint := .F.
  oGrp16:lReadOnly := .F.
  oGrp16:Align := 0
  oGrp16:lVisibleControl := .T.


// FRAME ANTIGA DESABILITADA
  oGrp18 := TGROUP():Create(oDlg)
  oGrp18:cName := "oGrp18"
  oGrp18:cCaption := "Tabelas de Preco"
  oGrp18:nLeft := 655
  oGrp18:nTop := 66
  oGrp18:nWidth := 288
  oGrp18:nHeight := 130
  oGrp18:lShowHint := .F.
  oGrp18:lReadOnly := .F.
  oGrp18:Align := 0
  oGrp18:lVisibleControl := .T.

// inserindo lista de tabela de precos 

  oList866:= TLISTBOX():Create(oDlg)
  oList866:cName := "oList866"
  oList866:cCaption := "oList866"
  oList866:nLeft := 658
  oList866:nTop := 78
  oList866:nWidth := 280
  oList866:nHeight := 90
  oList866:lShowHint := .F.
  oList866:lReadOnly := .F.
  oList866:Align := 0
  oList866:oFont:="oFontT"
  oList866:cVariable := "lstTbPr"
  oList866:bSetGet := {|u| If(PCount()>0,lstTbPr:=u,lstTbPr) }
  oList866:lVisibleControl := .T.
  oList866:bChange := {|| U_RAPTBPR("") }
  oList866:aItems := aTbPr
  oList866:nAt := 0
  oList866:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oSBtn0977 := TBUTTON():Create(oDlg)
  oSBtn0977 :cName := "oSBtn0977"
  oSBtn0977 :cCaption := "$"
  oSBtn0977 :nLeft := 925
  oSBtn0977 :nTop := 170
  oSBtn0977 :nWidth := 16
  oSBtn0977 :nHeight := 21
  oSBtn0977 :lShowHint := .F.
  oSBtn0977 :lReadOnly := .F.
  oSBtn0977 :Align := 0
  oSBtn0977 :lVisibleControl := .T.
  oSBtn0977 :bAction:={|| U_RAPENT(3)}

  oGetZ38   := TGET():New(,,,oDlg,,,,,CLR_WHITE,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGetZ38   :cName := "oGetZ38"
  oGetZ38   :nLeft := 660
  oGetZ38   :nTop := 170
  oGetZ38   :nWidth := 265
  oGetZ38   :nHeight := 21
  oGetZ38   :lShowHint := .F.
  oGetZ38   :lReadOnly := .T.
  oGetZ38   :Align := 0
  oGetZ38   :cVariable := "cMensagem"
  oGetZ38   :bSetGet := {|u| If(PCount()>0,cCod:=u,cMensagem) }
  oGetZ38   :lVisibleControl := .F.
  oGetZ38   :lPassword := .F.
  oGetZ38   :lHasButton := .F.
  oGetZ38   :setCSS("QLineEdit{color:#000000; background-color:#FF0000}")

  oSay24 := TSAY():Create(oDlg)
  oSay24:cName := "oSay24"
  oSay24:cCaption := "Venda Normal"
  oSay24:nLeft := 660
  oSay24:nTop := 116
  oSay24:nWidth := 73
  oSay24:nHeight := 17
  oSay24:lShowHint := .F.
  oSay24:lReadOnly := .F.
  oSay24:Align := 0
  oSay24:lVisibleControl := .F.
  oSay24:lWordWrap := .F.
  oSay24:lTransparent := .t.

  oGet23 := TGET():New(,,,oDlg,,,"@E 999,999,999.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet23:cName := "oGet23"
  oGet23:nLeft := 735
  oGet23:nTop := 106
  oGet23:nWidth := 121
  oGet23:nHeight := 21
  oGet23:lShowHint := .F.
  oGet23:lReadOnly := .F.
  oGet23:Align := 0
//oGet23:cVariable := "cVdNor"
//oGet23:bSetGet := {|u| If(PCount()>0,cVdNor:=u,cVdNor) }
  oGet23:lVisibleControl := .F.
  oGet23:lPassword := .F.
  oGet23:lHasButton := .F.
  oGet23:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")


  oSay25 := TSAY():Create(oDlg)
  oSay25:cName := "oSay25"
  oSay25:cCaption := "Venda Mínima"
  oSay25:nLeft := 660
  oSay25:nTop := 138
  oSay25:nWidth := 70
  oSay25:nHeight := 17
  oSay25:lShowHint := .F.
  oSay25:lReadOnly := .F.
  oSay25:Align := 0
  oSay25:lVisibleControl := .F.
  oSay25:lWordWrap := .F.
  oSay25:lTransparent := .t.


  oGet22 := TGET():New(,,,oDlg,,,"@E 999,999,999.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet22:cName := "oGet22"
  oGet22:nLeft := 735
  oGet22:nTop := 131
  oGet22:nWidth := 121
  oGet22:nHeight := 21
  oGet22:lShowHint := .F.
  oGet22:lReadOnly := .F.
  oGet22:Align := 0
//oGet22:cVariable := "cVdMn"
//oGet22:bSetGet := {|u| If(PCount()>0,cVdMn:=u,cVdMn) }
  oGet22:lVisibleControl := .F.
  oGet22:lPassword := .F.
  oGet22:lHasButton := .F.
  oGet22:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")


  oSay20 := TSAY():Create(oDlg)
  oSay20:cName := "oSay20"
  oSay20:cCaption := "Tabela"
  oSay20:nLeft := 658
  oSay20:nTop := 87
  oSay20:nWidth := 55
  oSay20:nHeight := 17
  oSay20:lShowHint := .F.
  oSay20:lReadOnly := .F.
  oSay20:Align := 0
  oSay20:lVisibleControl := .F.
  oSay20:lWordWrap := .F.
  oSay20:lTransparent := .t.


  oGetA22 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGetA22:cName := "oGet22"
  oGetA22:nLeft := 735
  oGetA22:nTop := 81
  oGetA22:nWidth := 201
  oGetA22:nHeight := 21
  oGetA22:lShowHint := .F.
  oGetA22:lReadOnly := .F.
  oGetA22:Align := 0
  oGetA22:cVariable := "cTabela"
  oGetA22:bSetGet := {|u| If(PCount()>0,cTabela:=u,cTabela) }
  oGetA22:lVisibleControl := .F.
  oGetA22:lPassword := .F.
  oGetA22:lHasButton := .F.
  oGetA22:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

// FIM DA FRAME ANTIGA DE PRECOS

  oGrp27 := TGROUP():Create(oDlg)
  oGrp27:cName := "oGrp27"
  oGrp27:cCaption := "Encargos Incidentes"
  oGrp27:nLeft := 655
  oGrp27:nTop := 166
  oGrp27:nWidth := 287
  oGrp27:nHeight := 55
  oGrp27:lShowHint := .F.
  oGrp27:lReadOnly := .F.
  oGrp27:Align := 0
  oGrp27:lVisibleControl := .F.

  oSay28 := TSAY():Create(oDlg)
  oSay28:cName := "oSay28"
  oSay28:cCaption := "Vend.1"
  oSay28:nLeft := 658
  oSay28:nTop := 180
  oSay28:nWidth := 48
  oSay28:nHeight := 15
  oSay28:lShowHint := .F.
  oSay28:lReadOnly := .F.
  oSay28:Align := 0
  oSay28:lVisibleControl := .F.
  oSay28:lWordWrap := .F.
  oSay28:lTransparent := .t.

  oGet29 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet29:cName := "oGet29"
  oGet29:nLeft := 658
  oGet29:nTop := 196
  oGet29:nWidth := 50
  oGet29:nHeight := 18
  oGet29:lShowHint := .F.
  oGet29:lReadOnly := .F.
  oGet29:Align := 0
  oGet29:cVariable := "cVend1"
  oGet29:bSetGet := {|u| If(PCount()>0,cVend1:=u,cVend1) }
  oGet29:lVisibleControl := .F.
  oGet29:lPassword := .F.
  oGet29:lHasButton := .F.
  oGet29:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oSay30 := TSAY():Create(oDlg)
  oSay30:cName := "oSay30"
  oSay30:cCaption := "Vend.5"
  oSay30:nLeft := 709
  oSay30:nTop := 181
  oSay30:nWidth := 51
  oSay30:nHeight := 15
  oSay30:lShowHint := .F.
  oSay30:lReadOnly := .F.
  oSay30:Align := 0
  oSay30:lVisibleControl := .F.
  oSay30:lWordWrap := .F.
  oSay30:lTransparent := .t.

  oGet31 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet31:cName := "oGet31"
  oGet31:nLeft := 709
  oGet31:nTop := 196
  oGet31:nWidth := 51
  oGet31:nHeight := 18
  oGet31:lShowHint := .F.
  oGet31:lReadOnly := .F.
  oGet31:Align := 0
  oGet31:cVariable := "cVend5"
  oGet31:bSetGet := {|u| If(PCount()>0,cVend5:=u,cVend5) }
  oGet31:lVisibleControl := .F.
  oGet31:lPassword := .F.
  oGet31:lHasButton := .F.
  oGet31:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")


  oGet32 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet32:cName := "oGet32"
  oGet32:nLeft := 761
  oGet32:nTop := 196
  oGet32:nWidth := 48
  oGet32:nHeight := 18
  oGet32:lShowHint := .F.
  oGet32:lReadOnly := .F.
  oGet32:Align := 0
  oGet32:cVariable := "cIcms"
  oGet32:bSetGet := {|u| If(PCount()>0,cIcms:=u,cIcms) }
  oGet32:lVisibleControl := .F.
  oGet32:lPassword := .F.
  oGet32:lHasButton := .F.
  oGet32:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oSay33 := TSAY():Create(oDlg)
  oSay33:cName := "oSay33"
  oSay33:cCaption := "PIS"
  oSay33:nLeft := 810
  oSay33:nTop := 182
  oSay33:nWidth := 46
  oSay33:nHeight := 12
  oSay33:lShowHint := .F.
  oSay33:lReadOnly := .F.
  oSay33:Align := 0
  oSay33:lVisibleControl := .F.
  oSay33:lWordWrap := .F.
  oSay33:lTransparent := .t.

  oSay34 := TSAY():Create(oDlg)
  oSay34:cName := "oSay34"
  oSay34:cCaption := "ICMS"
  oSay34:nLeft := 764
  oSay34:nTop := 182
  oSay34:nWidth := 46
  oSay34:nHeight := 12
  oSay34:lShowHint := .F.
  oSay34:lReadOnly := .F.
  oSay34:Align := 0
  oSay34:lVisibleControl := .F.
  oSay34:lWordWrap := .F.
  oSay34:lTransparent := .t.

  oSay35 := TSAY():Create(oDlg)
  oSay35:cName := "oSay35"
  oSay35:cCaption := "COFINS"
  oSay35:nLeft := 858
  oSay35:nTop := 182
  oSay35:nWidth := 44
  oSay35:nHeight := 13
  oSay35:lShowHint := .F.
  oSay35:lReadOnly := .F.
  oSay35:Align := 0
  oSay35:lVisibleControl := .F.
  oSay35:lWordWrap := .F.
  oSay35:lTransparent := .t.

  oGet36 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet36:cName := "oGet36"
  oGet36:nLeft := 858
  oGet36:nTop := 196
  oGet36:nWidth := 47
  oGet36:nHeight := 18
  oGet36:lShowHint := .F.
  oGet36:lReadOnly := .F.
  oGet36:Align := 0
  oGet36:cVariable := "cCofins"
  oGet36:bSetGet := {|u| If(PCount()>0,cCofins:=u,cCofins) }
  oGet36:lVisibleControl := .F.
  oGet36:lPassword := .F.
  oGet36:lHasButton := .F.
  oGet36:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet37 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet37:cName := "oGet37"
  oGet37:nLeft := 809
  oGet37:nTop := 196
  oGet37:nWidth := 49
  oGet37:nHeight := 18
  oGet37:lShowHint := .F.
  oGet37:lReadOnly := .F.
  oGet37:Align := 0
  oGet37:cVariable := "cPis"
  oGet37:bSetGet := {|u| If(PCount()>0,cPis:=u,cPis) }
  oGet37:lVisibleControl := .F.
  oGet37:lPassword := .F.
  oGet37:lHasButton := .F.
  oGet37:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

// DADOS DOS PRODUTOS


  oGet38 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet38:cName := "oGet38"
  oGet38:nLeft := 78
  oGet38:nTop := 78
  oGet38:nWidth := 147
  oGet38:nHeight := 21
  oGet38:lShowHint := .F.
  oGet38:lReadOnly := .T.
  oGet38:Align := 0
  oGet38:cVariable := "cCod"
  oGet38:bSetGet := {|u| If(PCount()>0,cCod:=u,cCod) }
  oGet38:lVisibleControl := .T.
  oGet38:lPassword := .F.
  oGet38:lHasButton := .F.
  oGet38:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet39 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet39:cName := "oGet39"
  oGet39:nLeft := 78
  oGet39:nTop := 101
  oGet39:nWidth := 380
  oGet39:nHeight := 21
  oGet39:lShowHint := .F.
  oGet39:lReadOnly := .T.
  oGet39:Align := 0
  oGet39:cVariable := "cDescr"
  oGet39:bSetGet := {|u| If(PCount()>0,cDescr:=u,cDescr) }
  oGet39:lVisibleControl := .T.
  oGet39:lPassword := .F.
  oGet39:lHasButton := .F.
  oGet39:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")
  oGet40:= TMULTIGET():New(,,,oDlg,,,oFontT,,,,,,,,,,,,,,,,,,,,,)
                     //New(1 [ nRow ],
                     //    2 [ nCol ],
                     //    3 [ bSetGet ],
                     //    4 [ oWnd ], 
                     //    5 [ nWidth ],
                     //    6 [ nHeight ],
                     //    7 [ oFont ], 
                     //    8 [ uParam8 ],
                     //    9 [ uParam9 ],
                     //   10 [ uParam10 ],
                     //   11 [ uParam11 ], 
                     //   12 [ lPixel ],
                     //   13 [ uParam13 ],
                     //   14 [ uParam14 ], 
                     //   15 [ bWhen ],
                     //   16 [ uParam16 ],
                     //   17 [ uParam17 ],
                     //   18 [ lReadOnly ],
                     //   19 [ bValid ],
                     //   20 [ uParam20 ],
                     //   21 [ uParam21 ],
                     //   22 [ lNoBorder ],
                     //   23 [ lVScroll ],
                     //   24 [ cLabelText ],
                     //   25 [ nLabelPos ],
                     //   26 [ oLabelFont ],
                     //   27 [ nLabelColor ] )

  oGet40:cName := "oGet40"
  oGet40:nLeft := 78
  oGet40:nTop := 122
  oGet40:nWidth := 566
  oGet40:nHeight := 31
  oGet40:lShowHint := .F.
  oGet40:lReadOnly := .T.
  oGet40:Align := 0
  oGet40:cVariable := "cTecn"
  oGet40:bSetGet := {|u| If(PCount()>0,cTecn:=u,cTecn) }
  oGet40:lVisibleControl := .T.
  oGet40:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oSBtn41 := TBUTTON():Create(oDlg)
  oSBtn41:cName := "oSBtn41"
  oSBtn41:cCaption := "Atualizar"
  oSBtn41:nLeft := 878
  oSBtn41:nTop := 134
  oSBtn41:nWidth := 52
  oSBtn41:nHeight := 22
  oSBtn41:lShowHint := .F.
  oSBtn41:lReadOnly := .F.
  oSBtn41:Align := 0
  oSBtn41:lVisibleControl := .F.
//oSBtn41:nType := 1
  oSBtn41:bAction:={|| U_HCPVDA()}

  oSay42 := TSAY():Create(oDlg)
  oSay42:cName := "oSay42"
  oSay42:cCaption := "Código"
  oSay42:nLeft := 13
  oSay42:nTop := 81
  oSay42:nWidth := 65
  oSay42:nHeight := 17
  oSay42:lShowHint := .F.
  oSay42:lReadOnly := .F.
  oSay42:Align := 0
  oSay42:lVisibleControl := .T.
  oSay42:lWordWrap := .F.
  oSay42:lTransparent := .t.


  oSay200:= TSAY():Create(oDlg)
  oSay200:cName := "oSay200"
  oSay200:cCaption := "Custo P/Form do PV"
  oSay200:nLeft := 420
  oSay200:nTop := 81
  oSay200:nWidth := 120
  oSay200:nHeight := 17
  oSay200:lShowHint := .F.
  oSay200:lReadOnly := .F.
  oSay200:Align := 0
  oSay200:lVisibleControl := .T.
  oSay200:lWordWrap := .F.
  oSay200:lTransparent := .t.

  oGet200 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet200:cName := "oGet200"
  oGet200:nLeft := 523
  oGet200:nTop := 78
  oGet200:nWidth := 120
  oGet200:nHeight := 21
  oGet200:lShowHint := .F.
  oGet200:lReadOnly := .F.
  oGet200:Align := 0
  oGet200:cVariable := "cCusto"
  oGet200:bSetGet := {|u| If(PCount()>0,cCusto:=u,cCusto) }
  oGet200:lVisibleControl := .T.
  oGet200:lPassword := .F.
  oGet200:lHasButton := .F.
  oGet200:bChange := {|| U_HCMAR2() }
  oGet200:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oSay217:= TSAY():Create(oDlg)
  oSay217:cName := "oSay216"
  oSay217:cCaption := "Tipo Estoque"
  oSay217:nLeft := 325
  oSay217:nTop := 81
  oSay217:nWidth := 90
  oSay217:nHeight := 17
  oSay217:lShowHint := .F.
  oSay217:lReadOnly := .F.
  oSay217:Align := 0
  oSay217:lVisibleControl := .T.
  oSay217:lWordWrap := .F.
  oSay217:lTransparent := .t.

  oGet217 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet217:cName := "oGet217"
  oGet217:nLeft := 387
  oGet217:nTop := 79
  oGet217:nWidth := 30
  oGet217:nHeight := 21
  oGet217:lShowHint := .F.
  oGet217:lReadOnly := .F.
  oGet217:Align := 0
  oGet217:cVariable := "cTiEs"
  oGet217:bSetGet := {|u| If(PCount()>0,cTiEs:=u,cTiEs) }
  oGet217:lVisibleControl := .T.
  oGet217:lPassword := .F.
  oGet217:lHasButton := .F.
  oGet217:bChange := {|| U_HCMAR9() }
  oGet217:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oSay297:= TSAY():Create(oDlg)
  oSay297:cName := "oSay297"
  oSay297:cCaption := "Pol Venda"
  oSay297:nLeft := 228
  oSay297:nTop := 81
  oSay297:nWidth := 90
  oSay297:nHeight := 17
  oSay297:lShowHint := .F.
  oSay297:lReadOnly := .F.
  oSay297:Align := 0
  oSay297:lVisibleControl := .T.
  oSay297:lWordWrap := .F.
  oSay297:lTransparent := .t.

  oGet297 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet297:cName := "oGet297"
  oGet297:nLeft := 280
  oGet297:nTop := 79
  oGet297:nWidth := 40
  oGet297:nHeight := 21
  oGet297:lShowHint := .F.
  oGet297:lReadOnly := .F.
  oGet297:Align := 0
  oGet297:cVariable := "cPolVenda"
  oGet297:bSetGet := {|u| If(PCount()>0,cPolVenda:=u,cPolVenda) }
  oGet297:lVisibleControl := .T.
  oGet297:lPassword := .F.
  oGet297:lHasButton := .F.
  oGet297:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oSay216:= TSAY():Create(oDlg)
  oSay216:cName := "oSay216"
  oSay216:cCaption := "R$ Medio"
  oSay216:nLeft := 475
  oSay216:nTop := 101
  oSay216:nWidth := 120
  oSay216:nHeight := 17
  oSay216:lShowHint := .F.
  oSay216:lReadOnly := .F.
  oSay216:Align := 0
  oSay216:lVisibleControl := .T.
  oSay216:lWordWrap := .F.
  oSay216:lTransparent := .t.

  oGet216 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet216:cName := "oGet216"
  oGet216:nLeft := 523
  oGet216:nTop := 100
  oGet216:nWidth := 120
  oGet216:nHeight := 21
  oGet216:lShowHint := .F.
  oGet216:lReadOnly := .F.
  oGet216:Align := 0
  oGet216:cVariable := "cMed2"
  oGet216:bSetGet := {|u| If(PCount()>0,cMed2:=u,cMed2) }
  oGet216:lVisibleControl := .T.
  oGet216:lPassword := .F.
  oGet216:lHasButton := .F.
//oGet216:bChange := {|| U_HCMAR2() }
  oGet216:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")



  oSay43 := TSAY():Create(oDlg)
  oSay43:cName := "oSay43"
  oSay43:cCaption := "Descrição"
  oSay43:nLeft := 12
  oSay43:nTop := 104
  oSay43:nWidth := 65
  oSay43:nHeight := 17
  oSay43:lShowHint := .F.
  oSay43:lReadOnly := .F.
  oSay43:Align := 0
  oSay43:lVisibleControl := .T.
  oSay43:lWordWrap := .F.
  oSay43:lTransparent := .t.

  oSay44 := TSAY():Create(oDlg)
  oSay44:cName := "oSay44"
  oSay44:cCaption := "Técnico"
  oSay44:nLeft := 12
  oSay44:nTop := 126
  oSay44:nWidth := 65
  oSay44:nHeight := 17
  oSay44:lShowHint := .F.
  oSay44:lReadOnly := .F.
  oSay44:Align := 0
  oSay44:lVisibleControl := .T.
  oSay44:lWordWrap := .F.
  oSay44:lTransparent := .t.

  oSay45 := TSAY():Create(oDlg)
  oSay45:cName := "oSay45"
  oSay45:cCaption := "Almox P."
  oSay45:nLeft := 14
  oSay45:nTop := 154
  oSay45:nWidth := 65
  oSay45:nHeight := 17
  oSay45:lShowHint := .F.
  oSay45:lReadOnly := .F.
  oSay45:Align := 0
  oSay45:lVisibleControl := .T.
  oSay45:lWordWrap := .F.
  oSay45:lTransparent:=.T.

  oGet46 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet46:cName := "oGet46"
  oGet46:nLeft := 78
  oGet46:nTop := 153
  oGet46:nWidth := 33
  oGet46:nHeight := 21
  oGet46:lShowHint := .F.
  oGet46:lReadOnly := .T.
  oGet46:Align := 0
  oGet46:cVariable := "cAlmox"
  oGet46:bSetGet := {|u| If(PCount()>0,cAlmox:=u,cAlmox) }
  oGet46:lVisibleControl := .T.
  oGet46:lPassword := .F.
  oGet46:lHasButton := .F.
  oGet46:setCSS("QLineEdit{color:#000000; background-color:#FFFFFF}")

  oSay47 := TSAY():Create(oDlg)
  oSay47:cName := "oSay47"
  oSay47:cCaption := "Peso"
  oSay47:nLeft := 114
  oSay47:nTop := 154
  oSay47:nWidth := 37
  oSay47:nHeight := 17
  oSay47:lShowHint := .F.
  oSay47:lReadOnly := .F.
  oSay47:Align := 0
  oSay47:lVisibleControl := .T.
  oSay47:lWordWrap := .F.
  oSay47:lTransparent:=.T.

  oGet48 := TGET():New(,,,oDlg,,,"@E 99999.99",,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet48:cName := "oGet48"
  oGet48:nLeft := 144
  oGet48:nTop := 153
  oGet48:nWidth := 45
  oGet48:nHeight := 21
  oGet48:lShowHint := .F.
  oGet48:lReadOnly := .F.
  oGet48:Align := 0
  oGet48:cVariable := "nPeso"
  oGet48:bSetGet := {|u| If(PCount()>0,nPeso:=u,nPeso) }
  oGet48:lVisibleControl := .T.
  oGet48:lPassword := .F.
  oGet48:lHasButton := .F.
  oGet48:bChange := {|| U_HCPESO() }
  oGet48:setCSS("QLineEdit{color:#000000; background-color:#FFFFFF}")

  oSay49 := TSAY():Create(oDlg)
  oSay49:cName := "oSay49"
  oSay49:cCaption := "Unid"
  oSay49:nLeft := 228
  oSay49:nTop := 154
  oSay49:nWidth := 51
  oSay49:nHeight := 17
  oSay49:lShowHint := .F.
  oSay49:lReadOnly := .F.
  oSay49:Align := 0
  oSay49:lVisibleControl := .T.
  oSay49:lWordWrap := .F.
  oSay49:lTransparent:=.T.

  oGet50 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet50:cName := "oGet50"
  oGet50:nLeft := 250
  oGet50:nTop := 153
  oGet50:nWidth := 30
  oGet50:nHeight := 21
  oGet50:lShowHint := .F.
  oGet50:lReadOnly := .T.
  oGet50:Align := 0
  oGet50:cVariable := "cUnid"
  oGet50:bSetGet := {|u| If(PCount()>0,cUnid:=u,cUnid) }
  oGet50:lVisibleControl := .T.
  oGet50:lPassword := .F.
  oGet50:lHasButton := .F.
  oGet50:setCSS("QLineEdit{color:#000000; background-color:#FFFFFF}")

  oSay54 := TSAY():Create(oDlg)
  oSay54:cName := "oSay54"
  oSay54:cCaption := "E. Min."
  oSay54:nLeft := 280
  oSay54:nTop := 154
  oSay54:nWidth := 46
  oSay54:nHeight := 17
  oSay54:lShowHint := .F.
  oSay54:lReadOnly := .F.
  oSay54:Align := 0
  oSay54:lVisibleControl := .T.
  oSay54:lWordWrap := .F.
  oSay54:lTransparent:=.T.

  oGet51 := TGET():New(,,,oDlg,,,"@E 999999",,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet51:cName := "oGet51"
  oGet51:nLeft := 315
  oGet51:nTop := 153
  oGet51:nWidth := 46
  oGet51:nHeight := 21
  oGet51:lShowHint := .F.
  oGet51:lReadOnly := .f.
  oGet51:Align := 0
  oGet51:cVariable := "cEstmin"
  oGet51:bSetGet := {|u| If(PCount()>0,cEstmin:=u,cEstmin) }
  oGet51:lVisibleControl := .T.
  oGet51:lPassword := .F.
  oGet51:lHasButton := .F.
  oGet51:bChange := {|| U_HCMIN() }
  oGet51:setCSS("QLineEdit{color:#000000; background-color:#FFFFFF}")

  oSay254 := TSAY():Create(oDlg)
  oSay254:cName := "oSay254"
  oSay254:cCaption := "C. Medio"
  oSay254:nLeft := 366
  oSay254:nTop := 154
  oSay254:nWidth := 60
  oSay254:nHeight := 17
  oSay254:lShowHint := .F.
  oSay254:lReadOnly := .F.
  oSay254:Align := 0
  oSay254:lVisibleControl := .T.
  oSay254:lWordWrap := .F.
  oSay254:lTransparent:=.T.

  oGet254 := TGET():New(,,,oDlg,,,,,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet254:cName := "oGet254"
  oGet254:nLeft := 412
  oGet254:nTop := 153
  oGet254:nWidth := 46
  oGet254:nHeight := 21
  oGet254:lShowHint := .F.
  oGet254:lReadOnly := .T.
  oGet254:Align := 0
  oGet254:cVariable := "cMedio"
  oGet254:bSetGet := {|u| If(PCount()>0,cMedio:=u,cMedio) }
  oGet254:lVisibleControl := .T.
  oGet254:lPassword := .F.
  oGet254:lHasButton := .F.
  oGet254:setCSS("QLineEdit{color:#000000; background-color:#FFFFFF}")



  oSay255 := TSAY():Create(oDlg)
  oSay255:cName := "oSay255"
  oSay255:cCaption := "P. Pedido"
  oSay255:nLeft := 460
  oSay255:nTop := 154
  oSay255:nWidth := 60
  oSay255:nHeight := 17
  oSay255:lShowHint := .F.
  oSay255:lReadOnly := .F.
  oSay255:Align := 0
  oSay255:lVisibleControl := .T.
  oSay255:lWordWrap := .F.
  oSay255:lTransparent:=.T.

  oGet255 := TGET():New(,,,oDlg,,,"@E 999999",,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet255:cName := "oGet255"
  oGet255:nLeft := 505
  oGet255:nTop  := 153
  oGet255:nWidth := 46
  oGet255:nHeight := 21
  oGet255:lShowHint := .F.
  oGet255:lReadOnly := .T.
  oGet255:Align := 0
  oGet255:cVariable := "cPP"
  oGet255:bSetGet := {|u| If(PCount()>0,cPP:=u,cPP) }
  oGet254:lVisibleControl := .T.
  oGet254:lPassword := .F.
  oGet254:lHasButton := .F.
  oGet255:setCSS("QLineEdit{color:#000000; background-color:#FFFFFF}")

  oSBtn255:= TBUTTON():Create(oDlg)
  oSBtn255:cName := "oSBtn255"
  oSBtn255:cCaption := "Solic.Compra"
  oSBtn255:nLeft := 812
  oSBtn255:nTop := 321
  oSBtn255:nWidth := 69
  oSBtn255:nHeight := 26
  oSBtn255:lShowHint := .T.
  oSBtn255:lReadOnly := .F.
  oSBtn255:Align := 0
  oSBtn255:lVisibleControl := .T.
//oSBtn255:nType := 1
  oSBtn255:bAction := {|| U_HCSOLCOM()}

  oSay256 := TSAY():Create(oDlg)
  oSay256:cName := "oSay256"
  oSay256:cCaption := "Sg.Cpa/Qt.Orc."
  oSay256:nLeft := 743
  oSay256:nTop := 311
  oSay256:nWidth := 68
  oSay256:nHeight := 17
  oSay256:lShowHint := .F.
  oSay256:lReadOnly := .F.
  oSay256:Align := 0
  oSay256:lVisibleControl := .T.
  oSay256:lWordWrap := .F.
  oSay256:lTransparent:=.T.

  oGet256 := TGET():New(,,,oDlg,,,"@E 999999",,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet256 :cName := "oGet256"
  oGet256:nLeft :=742
  oGet256:nTop := 326
  oGet256:nWidth := 60
  oGet256:nHeight := 21
  oGet256:lShowHint := .F.
  oGet256:lReadOnly := .F.
  oGet256:Align := 0
  oGet256:cVariable := "nSCompra"
  oGet256:bSetGet := {|u| If(PCount()>0,nScompra:=u,nScompra) }
  oGet256:lVisibleControl := .T.
  oGet256:lPassword := .F.
  oGet256:lHasButton := .F.
  oGet256:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oSay53 := TSAY():Create(oDlg)
  oSay53:cName := "oSay53"
  oSay53:cCaption := "L. Time"
  oSay53:nLeft := 556
  oSay53:nTop := 154
  oSay53:nWidth := 53
  oSay53:nHeight := 17
  oSay53:lShowHint := .F.
  oSay53:lReadOnly := .F.
  oSay53:Align := 0
  oSay53:lVisibleControl := .T.
  oSay53:lWordWrap := .F.
  oSay53:lTransparent:=.T.

  oGet52 := TGET():New(,,,oDlg,,,"@E 9999",,CLR_BLACK,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet52:cName := "oGet52"
  oGet52:nLeft := 593
  oGet52:nTop := 153
  oGet52:nWidth := 51
  oGet52:nHeight := 21
  oGet52:lShowHint := .F.
  oGet52:lReadOnly := .f.
  oGet52:Align := 0
  oGet52:cVariable := "cLtime"
  oGet52:bSetGet := {|u| If(PCount()>0,cLtime:=u,cLtime) }
  oGet52:lVisibleControl := .T.
  oGet52:lPassword := .F.
  oGet52:lHasButton := .F.
  oGet52:setCSS("QLineEdit{color:#000000; background-color:#FFFFFF}")


  oGrp57 := TGROUP():Create(oDlg)
  oGrp57:cName := "oGrp57"
  oGrp57:cCaption := "Pendencias de Entrada"
  oGrp57:nLeft := 2
  oGrp57:nTop := 236
  oGrp57:nWidth := 650
  oGrp57:nHeight := 64
  oGrp57:lShowHint := .F.
  oGrp57:lReadOnly := .F.
  oGrp57:Align := 0
  oGrp57:lVisibleControl := .T.

  oGrp58 := TGROUP():Create(oDlg)
  oGrp58:cName := "oGrp58"
  oGrp58:cCaption := "Historico de Vendas"
  oGrp58:nLeft := 2
  oGrp58:nTop := 174
  oGrp58:nWidth := 650
  oGrp58:nHeight := 64
  oGrp58:lShowHint := .F.
  oGrp58:lReadOnly := .F.
  oGrp58:Align := 0
  oGrp58:lVisibleControl := .T.

  oCombo59 := TCOMBOBOX():New(,,,,,,oDlg,,,,,,,oFontT,,,,,,,,)
  oCombo59:cName := "oCombo59"
  oCombo59:nLeft := 25
  oCombo59:nTop := 250
  oCombo59:nWidth := 570
  oCombo59:nHeight := 21
  oCombo59:lShowHint := .F.
  oCombo59:lReadOnly := .F.
  oCombo59:Align := 0
  oCombo59:cVariable := "cboPoc"
  oCombo59:bSetGet := {|u| If(PCount()>0,cboPoc:=u,cboPoc) }
  oCombo59:lVisibleControl := .T.
  oCombo59:aItems := aCpaPend
  oCombo59:nAt := 0
//oCombo59:bChange := {|| U_RAPOC() }
//oCombo59:bLostFocus := {|| U_RAPOC() }
//oCombo59:bGotFocus := {|| U_RAPTR("OC") }
//oCombo59:bVALID := {|| U_RAPOC() } 

  oSBtn559 := TBUTTON():Create(oDlg)
  oSBtn559 :cName := "oSBtn559"
  oSBtn559 :cCaption := "+"
  oSBtn559 :nLeft := 595
  oSBtn559 :nTop := 250
  oSBtn559 :nWidth := 14
  oSBtn559 :nHeight := 21
  oSBtn559 :lShowHint := .F.
  oSBtn559 :lReadOnly := .F.
  oSBtn559 :Align := 0
  oSBtn559 :lVisibleControl := .T.
//oSBtn559 :nType := 1
  oSBtn559 :bAction:={|| U_RAPOC(0)}

  oSBtn959 := TBUTTON():Create(oDlg)
  oSBtn959 :cName := "oSBtn959"
  oSBtn959 :cCaption := "$"
  oSBtn959 :nLeft := 609
  oSBtn959 :nTop := 250
  oSBtn959 :nWidth := 14
  oSBtn959 :nHeight := 21
  oSBtn959 :lShowHint := .F.
  oSBtn959 :lReadOnly := .F.
  oSBtn959 :Align := 0
  oSBtn959 :lVisibleControl := .T.
//oSBtn959 :nType := 1
  oSBtn959 :bAction:={|| U_RAPOC(1)}

  oSBtn095 := TBUTTON():Create(oDlg)
  oSBtn095 :cName := "oSBtn095"
  oSBtn095 :cCaption := "F"
  oSBtn095 :nLeft := 623
  oSBtn095 :nTop := 250
  oSBtn095 :nWidth := 14
  oSBtn095 :nHeight := 21
  oSBtn095 :lShowHint := .F.
  oSBtn095 :lReadOnly := .F.
  oSBtn095 :Align := 0
  oSBtn095 :lVisibleControl := .T.
//oSBtn959 :nType := 1
  oSBtn095 :bAction:={|| U_RAPFWOC()}

  oSBtn099 := TBUTTON():Create(oDlg)
  oSBtn099 :cName := "oSBtn099"
  oSBtn099 :cCaption := "A"
  oSBtn099 :nLeft := 637
  oSBtn099 :nTop := 250
  oSBtn099 :nWidth := 14
  oSBtn099 :nHeight := 21
  oSBtn099 :lShowHint := .F.
  oSBtn099 :lReadOnly := .F.
  oSBtn099 :Align := 0
  oSBtn099 :lVisibleControl := .T.
  oSBtn099 :bAction:={|| U_RAPOCPV()}

  oSBtnS99 := TBUTTON():Create(oDlg)
  oSBtnS99 :cName := "oSBtnS99"
  oSBtnS99 :cCaption := "A"
  oSBtnS99 :nLeft := 637
  oSBtnS99 :nTop := 272
  oSBtnS99 :nWidth := 14
  oSBtnS99 :nHeight := 21
  oSBtnS99 :lShowHint := .F.
  oSBtnS99 :lReadOnly := .F.
  oSBtnS99 :Align := 0
  oSBtnS99 :lVisibleControl := .T.
  oSBtnS99 :bAction:={|| U_RAPOSPV()}

  oSBtnT99 := TBUTTON():Create(oDlg)
  oSBtnT99 :cName := "oSBtnT99"
  oSBtnT99 :cCaption := "V"
  oSBtnT99 :nLeft := 635
  oSBtnT99 :nTop := 188
  oSBtnT99 :nWidth := 14
  oSBtnT99 :nHeight := 21
  oSBtnT99 :lShowHint := .F.
  oSBtnT99 :lReadOnly := .F.
  oSBtnT99 :Align := 0
  oSBtnT99 :lVisibleControl := .T.
  oSBtnT99 :bAction:={|| U_RAPVIN()}

  oSay60 := TSAY():Create(oDlg)
  oSay60:cName := "oSay60"
  oSay60:cCaption := "OC"
  oSay60:nLeft := 5
  oSay60:nTop := 252
  oSay60:nWidth := 15
  oSay60:nHeight := 17
  oSay60:lShowHint := .F.
  oSay60:lReadOnly := .F.
  oSay60:Align := 0
  oSay60:lVisibleControl := .T.
  oSay60:lWordWrap := .F.
  oSay60:lTransparent:=.T.

  oSBtn61 := TBUTTON():Create(oDlg)
  oSBtn61:cName := "oSBtn61"
  oSBtn61:cCaption := "Historico"
  oSBtn61:nLeft := 885
  oSBtn61:nTop := 321
  oSBtn61:nWidth := 52
  oSBtn61:nHeight := 26
  oSBtn61:lShowHint := .F.
  oSBtn61:lReadOnly := .F.
  oSBtn61:Align := 0
  oSBtn61:lVisibleControl := .T.
//oSBtn61:nType := 1

  oCombo63 := TCOMBOBOX():New(,,,,,,oDlg,,,,,,,oFontT,,,,,,,,)
  oCombo63:cName := "oCombo63"
  oCombo63:nLeft := 25
  oCombo63:nTop := 272
  oCombo63:nWidth := 570
  oCombo63:nHeight := 21
  oCombo63:lShowHint := .F.
  oCombo63:lReadOnly := .F.
  oCombo63:Align := 0
  oCombo63:cVariable := "cboPos"
  oCombo63:bSetGet := {|u| If(PCount()>0,cboPos:=u,cboPos) }
  oCombo63:lVisibleControl := .T.
  oCombo63:aItems := aOsPend
  oCombo63:nAt := 0
//oCombo63:bLostFocus := {|| U_RAPOS() }
//oCombo63:bGotFocus := {|| U_RAPTR("OS") }
//oCombo63:bVALID := {|| U_RAPOS() }

  oSBtn560 := TBUTTON():Create(oDlg)
  oSBtn560 :cName := "oSBtn560"
  oSBtn560 :cCaption := "+"
  oSBtn560 :nLeft := 595
  oSBtn560 :nTop := 272
  oSBtn560 :nWidth := 14
  oSBtn560 :nHeight := 21
  oSBtn560 :lShowHint := .F.
  oSBtn560 :lReadOnly := .F.
  oSBtn560 :Align := 0
  oSBtn560 :lVisibleControl := .T.
//oSBtn560 :nType := 1
  oSBtn560 :bAction:={|| U_RAPOS()}




  oSay64 := TSAY():Create(oDlg)
  oSay64:cName := "oSay64"
  oSay64:cCaption := "OS"
  oSay64:nLeft := 5
  oSay64:nTop := 273
  oSay64:nWidth := 15
  oSay64:nHeight := 17
  oSay64:lShowHint := .F.
  oSay64:lReadOnly := .F.
  oSay64:Align := 0
  oSay64:lVisibleControl := .T.
  oSay64:lWordWrap := .F.
  oSay64:lTransparent:=.T.

  oChk65 := TCHECKBOX():Create(oDlg)
  oChk65:cName := "oChk65"
  oChk65:cCaption := "Consultar"
  oChk65:nLeft := 132
  oChk65:nTop := 220
  oChk65:nWidth := 74
  oChk65:nHeight := 16
  oChk65:lShowHint := .F.
  oChk65:lReadOnly := .F.
  oChk65:Align := 0
  oChk65:lVisibleControl := .F.


//oCombo66 := TCOMBOBOX():Create(oDlg)
  oCombo66 := TCOMBOBOX():New(,,,,,,oDlg,,,,,,,oFontT,,,,,,,,)
  oCombo66:cName := "oCombo66"
  oCombo66:nLeft := 25
  oCombo66:nTop := 187
  oCombo66:nWidth := 590
  oCombo66:nHeight := 21
  oCombo66:lShowHint := .F.
  oCombo66:lReadOnly := .F.
  oCombo66:Align := 0
  oCombo66:cVariable := "cboPvend"
  oCombo66:bSetGet := {|u| If(PCount()>0,cboPvend:=u,cboPvend) }
  oCombo66:lVisibleControl := .T.
  oCombo66:aItems := aVdaPend
  oCombo66:nAt := 1
//oCombo66:bLostFocus := {|| U_RAPPV1("") }
//oCombo66:bGotFocus := {|| U_RAPTR("VN") }
//oCombo66:bChange := {|| U_RAPPV1("") }
//oCombo66:bVALID := {|| U_RAPPV1("") }

  oSBtn561 := TBUTTON():Create(oDlg)
  oSBtn561 :cName := "oSBtn561"
  oSBtn561 :cCaption := "+"
  oSBtn561 :nLeft := 616
  oSBtn561 :nTop := 187
  oSBtn561 :nWidth := 16
  oSBtn561 :nHeight := 21
  oSBtn561 :lShowHint := .F.
  oSBtn561 :lReadOnly := .F.
  oSBtn561 :Align := 0
  oSBtn561 :lVisibleControl := .T.
//oSBtn561 :nType := 1
  oSBtn561 :bAction:={|| U_RAPPV1("")}

//oCombo67 := TCOMBOBOX():Create(oDlg)
  oCombo67 := TCOMBOBOX():New(,,,,,,oDlg,,,,,,,oFontT,,,,,,,,)
  oCombo67:cName := "oCombo67"
  oCombo67:nLeft := 25
  oCombo67:nTop := 210
  oCombo67:nWidth := 590
  oCombo67:nHeight := 21
  oCombo67:lShowHint := .F.
  oCombo67:lReadOnly := .F.
  oCombo67:Align := 0
  oCombo67:cVariable := "cboVentr"
  oCombo67:bSetGet := {|u| If(PCount()>0,cboVentr:=u,cboVentr) }
  oCombo67:lVisibleControl := .T.
  oCombo67:aItems := aVdaEntr
  oCombo67:nAt := 1
//oCombo67:bChange := {|| U_RAPPV() }
//oCombo67:bLostFocus := {|| U_RAPPV() }
//oCombo67:bGotFocus := {|| U_RAPTR("VE") }
//oCombo67:bVALID := {|| U_RAPPV("") }

  oSBtn562 := TBUTTON():Create(oDlg)
  oSBtn562 :cName := "oSBtn562"
  oSBtn562 :cCaption := "+"
  oSBtn562 :nLeft := 616
  oSBtn562 :nTop := 210
  oSBtn562 :nWidth := 16
  oSBtn562 :nHeight := 21
  oSBtn562 :lShowHint := .F.
  oSBtn562 :lReadOnly := .F.
  oSBtn562 :Align := 0
  oSBtn562 :lVisibleControl := .T.
//oSBtn562 :nType := 1
  oSBtn562 :bAction:={|| U_RAPPV("")}

  oSay68 := TSAY():Create(oDlg)
  oSay68:cName := "oSay68"
  oSay68:cCaption := "VNE"
  oSay68:nLeft := 5
  oSay68:nTop := 189
  oSay68:nWidth := 26
  oSay68:nHeight := 17
  oSay68:lShowHint := .F.
  oSay68:lReadOnly := .F.
  oSay68:Align := 0
  oSay68:lVisibleControl := .T.
  oSay68:lWordWrap := .F.
  oSay68:lTransparent:=.T.

  oSay69 := TSAY():Create(oDlg)
  oSay69:cName := "oSay69"
  oSay69:cCaption := "V E"
  oSay69:nLeft := 5
  oSay69:nTop := 213
  oSay69:nWidth := 26
  oSay69:nHeight := 17
  oSay69:lShowHint := .F.
  oSay69:lReadOnly := .F.
  oSay69:Align := 0
  oSay69:lVisibleControl := .T.
  oSay69:lWordWrap := .F.
  oSay69:lTransparent:=.T.

  oChk70 := TCHECKBOX():Create(oDlg)
  oChk70:cName := "oChk70"
  oChk70:cCaption := "Consulta Completa"
  oChk70:nLeft := 377
  oChk70:nTop := 20
  oChk70:nWidth := 129
  oChk70:nHeight := 15
  oChk70:lShowHint := .F.
  oChk70:lReadOnly := .F.
  oChk70:Align := 0
  oChk70:cVariable := "chkCompleta"
  oChk70:bSetGet := {|u| If(PCount()>0,chkCompleta:=u,chkCompleta) }
  oChk70:lVisibleControl := .f.

  oGrp71 := TGROUP():Create(oDlg)
  oGrp71:cName := "oGrp71"
  oGrp71:cCaption := "Resumo de Estoque"
  oGrp71:nLeft := 4
  oGrp71:nTop :=300
  oGrp71:nWidth := 940
  oGrp71:nHeight := 53
  oGrp71:lShowHint := .F.
  oGrp71:lReadOnly := .F.
  oGrp71:Align := 0
  oGrp71:lVisibleControl := .T.

  oSay72 := TSAY():Create(oDlg)
  oSay72:cName := "oSay72"
  oSay72:cCaption := "Qt.Disp.Vda."
  oSay72:nLeft := 7
  oSay72:nTop := 311
  oSay72:nWidth := 93
  oSay72:nHeight := 17
  oSay72:lShowHint := .F.
  oSay72:lReadOnly := .F.
  oSay72:Align := 0
  oSay72:lVisibleControl := .T.
  oSay72:lWordWrap := .F.
  oSay72:lTransparent:=.T.

  oGet73 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet73:cName := "oGet73"
  oGet73:nLeft := 7
  oGet73:nTop := 326
  oGet73:nWidth := 62
  oGet73:nHeight := 21
  oGet73:lShowHint := .F.
  oGet73:lReadOnly := .F.
  oGet73:Align := 0
  oGet73:cVariable := "nEstfis"
  oGet73:bSetGet := {|u| If(PCount()>0,nEstfis:=u,nEstfis) }
  oGet73:lVisibleControl := .T.
  oGet73:lPassword := .F.
  oGet73:lHasButton := .F.
  oGet73:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oSay985 := TSAY():Create(oDlg)
  oSay985:cName := "oSay985"
  oSay985:cCaption := "OrcPendente"
  oSay985:nLeft := 74
  oSay985:nTop := 311
  oSay985:nWidth := 93
  oSay985:nHeight := 17
  oSay985:lShowHint := .F.
  oSay985:lReadOnly := .F.
  oSay985:Align := 0
  oSay985:lVisibleControl := .T.
  oSay985:lWordWrap := .F.
  oSay985:lTransparent:=.T.

  oGet985 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet985:cName := "oGet985"
  oGet985:nLeft := 74
  oGet985:nTop := 326
  oGet985:nWidth := 60
  oGet985:nHeight := 21
  oGet985:lShowHint := .F.
  oGet985:lReadOnly := .F.
  oGet985:Align := 0
  oGet985:cVariable := "nOrcPen"
  oGet985:bSetGet := {|u| If(PCount()>0,nOrcPen:=u,nOrcPen) }
  oGet985:lVisibleControl := .T.
  oGet985:lPassword := .F.
  oGet985:lHasButton := .F.
  oGet985:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oSay85 := TSAY():Create(oDlg)
  oSay85:cName := "oSay85"
  oSay85:cCaption := "Virt.OC Est."
  oSay85:nLeft := 140
  oSay85:nTop := 311
  oSay85:nWidth := 93
  oSay85:nHeight := 17
  oSay85:lShowHint := .F.
  oSay85:lReadOnly := .F.
  oSay85:Align := 0
  oSay85:lVisibleControl := .T.
  oSay85:lWordWrap := .F.
  oSay85:lTransparent:=.T.

  oGet85 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet85:cName := "oGet85"
  oGet85:nLeft := 140
  oGet85:nTop := 326
  oGet85:nWidth := 60
  oGet85:nHeight := 21
  oGet85:lShowHint := .F.
  oGet85:lReadOnly := .F.
  oGet85:Align := 0
  oGet85:cVariable := "nEstVir"
  oGet85:bSetGet := {|u| If(PCount()>0,nEstVir:=u,nEstVir) }
  oGet85:lVisibleControl := .T.
  oGet85:lPassword := .F.
  oGet85:lHasButton := .F.
  oGet85:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oSay388 := TSAY():Create(oDlg)
  oSay388:cName := "oSay388"
  oSay388:cCaption := "Virt.OC Cas."
  oSay388:nLeft := 206
  oSay388:nTop := 311
  oSay388:nWidth := 93
  oSay388:nHeight := 17
  oSay388:lShowHint := .F.
  oSay388:lReadOnly := .F.
  oSay388:Align := 0
  oSay388:lVisibleControl := .T.
  oSay388:lWordWrap := .F.
  oSay388:lTransparent:=.T.

  oGet388:= TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet388:cName := "oGet388"
  oGet388:nLeft := 206
  oGet388:nTop := 326
  oGet388:nWidth := 60
  oGet388:nHeight := 21
  oGet388:lShowHint := .F.
  oGet388:lReadOnly := .F.
  oGet388:Align := 0
  oGet388:cVariable := "nCasada"
  oGet388:bSetGet := {|u| If(PCount()>0,nCasada:=u,nCasada) }
  oGet388:lVisibleControl := .T.
  oGet388:lPassword := .F.
  oGet388:lHasButton := .F.
  oGet388:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oSay86 := TSAY():Create(oDlg)
  oSay86:cName := "oSay86"
  oSay86:cCaption := "Virtual OS"
  oSay86:nLeft := 272
  oSay86:nTop := 311
  oSay86:nWidth := 93
  oSay86:nHeight := 17
  oSay86:lShowHint := .F.
  oSay86:lReadOnly := .F.
  oSay86:Align := 0
  oSay86:lVisibleControl := .T.
  oSay86:lWordWrap := .F.
  oSay86:lTransparent:=.T.

  oGet86 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet86:cName := "oGet86"
  oGet86:nLeft := 272
  oGet86:nTop := 326
  oGet86:nWidth := 60
  oGet86:nHeight := 21
  oGet86:lShowHint := .F.
  oGet86:lReadOnly := .F.
  oGet86:Align := 0
  oGet86:cVariable := "nOsVir"
  oGet86:bSetGet := {|u| If(PCount()>0,nOsVir:=u,nOsVir) }
  oGet86:lVisibleControl := .T.
  oGet86:lPassword := .F.
  oGet86:lHasButton := .F.
  oGet86:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oSay386 := TSAY():Create(oDlg)
  oSay386:cName := "oSay386"
  oSay386:cCaption := "Poder 3o"
  oSay386:nLeft := 337
  oSay386:nTop := 311
  oSay386:nWidth := 93
  oSay386:nHeight := 17
  oSay386:lShowHint := .F.
  oSay386:lReadOnly := .F.
  oSay386:Align := 0
  oSay386:lVisibleControl := .T.
  oSay386:lWordWrap := .F.
  oSay386:lTransparent:=.T.

  oGet386 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet386:cName := "oGet386"
  oGet386:nLeft := 337
  oGet386:nTop := 326
  oGet386:nWidth := 60
  oGet386:nHeight := 21
  oGet386:lShowHint := .F.
  oGet386:lReadOnly := .F.
  oGet386:Align := 0
  oGet386:cVariable := "nPoder3"
  oGet386:bSetGet := {|u| If(PCount()>0,nPoder3:=u,nPoder3) }
  oGet386:lVisibleControl := .T.
  oGet386:lPassword := .F.
  oGet386:lHasButton := .F.
  oGet386:bVALID := {|| U_RAPNP3(1) }
  oGet386:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oSay387 := TSAY():Create(oDlg)
  oSay387:cName := "oSay387"
  oSay387:cCaption := "De 3o "
  oSay387:nLeft := 403
  oSay387:nTop := 311
  oSay387:nWidth := 93
  oSay387:nHeight := 17
  oSay387:lShowHint := .F.
  oSay387:lReadOnly := .F.
  oSay387:Align := 0
  oSay387:lVisibleControl := .T.
  oSay387:lWordWrap := .F.
  oSay387:lTransparent:=.T.

  oGet387:= TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet387:cName := "oGet387"
  oGet387:nLeft := 403
  oGet387:nTop := 326
  oGet387:nWidth := 60
  oGet387:nHeight := 21
  oGet387:lShowHint := .F.
  oGet387:lReadOnly := .F.
  oGet387:Align := 0
  oGet387:cVariable := "nDe3"
  oGet387:bSetGet := {|u| If(PCount()>0,nDe3:=u,nDe3) }
  oGet387:lVisibleControl := .T.
  oGet387:lPassword := .F.
  oGet387:lHasButton := .F.
  oGet387:bVALID := {|| U_RAPNP3(2) }
  oGet387:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")



  oSay75 := TSAY():Create(oDlg)
  oSay75:cName := "oSay75"
  oSay75:cCaption := "Estoque por Almox"
  oSay75:nLeft := 469
  oSay75:nTop := 311
  oSay75:nWidth := 105
  oSay75:nHeight := 13
  oSay75:lShowHint := .F.
  oSay75:lReadOnly := .F.
  oSay75:Align := 0
  oSay75:lVisibleControl := .T.
  oSay75:lWordWrap := .F.
  oSay75:lTransparent:=.T.


  oCombo74 := TCOMBOBOX():New(,,,,,,oDlg,,,,,,,oFontT,,,,,,,,)
  oCombo74:cName := "oCombo74"
  oCombo74:nLeft := 469
  oCombo74:nTop := 326
  oCombo74:nWidth := 160
  oCombo74:nHeight := 21
  oCombo74:lShowHint := .F.
  oCombo74:lReadOnly := .F.
  oCombo74:Align := 0
  oCombo74:cVariable := "cboEsAl"
  oCombo74:bSetGet := {|u| If(PCount()>0,cboEsAl:=u,cboEsAl) }
  oCombo74:lVisibleControl := .T.
  oCombo74:aItems :=aAlmox
  oCombo74:nAt := 1

  oSay77 := TSAY():Create(oDlg)
  oSay77:cName := "oSay77"
  oSay77:cCaption := "Status Inventario/Data UI"
  oSay77:nLeft := 628
  oSay77:nTop := 300
  oSay77:nWidth := 110
  oSay77:nHeight := 13
  oSay77:lShowHint := .F.
  oSay77:lReadOnly := .F.
  oSay77:Align := 0
  oSay77:lVisibleControl := .T.
  oSay77:lWordWrap := .F.
  oSay77:lTransparent:=.T.

  oGet777 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),,,,,,,,,,,,,,,,,,)
  oGet777:cName := "oGet777"
  oGet777:nLeft := 675
  oGet777:nTop := 326
  oGet777:nWidth := 62
  oGet777:nHeight := 21
  oGet777:lShowHint := .F.
  oGet777:lReadOnly := .F.
  oGet777:Align := 0
  oGet777:cVariable := "cDtInv"
  oGet777:bSetGet := {|u| If(PCount()>0,cDtInv:=u,cDtInv) }
  oGet777:lVisibleControl := .T.
  oGet777:lPassword := .F.
  oGet777:lHasButton := .F.
  oGet777:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oCombo76 := TCOMBOBOX():Create(oDlg)
  oCombo76:cName := "oCombo76"
  oCombo76:nLeft := 595
  oCombo76:nTop := 318
  oCombo76:nWidth := 247
  oCombo76:nHeight := 21
  oCombo76:lShowHint := .F.
  oCombo76:lReadOnly := .F.
  oCombo76:Align := 0
  oCombo76:cVariable := "cboPreNF"
  oCombo76:bSetGet := {|u| If(PCount()>0,cboPreNF:=u,cboPreNf) }
  oCombo76:lVisibleControl := .f.
  oCombo76:nAt := 0

  oBmp1 := TBITMAP():Create(oDlg)
  oBmp1:cName := "oBmp1"
  oBmp1:cCaption := "oBmp1"
  oBmp1:nLeft := 640
  oBmp1:nTop := 320
  oBmp1:nWidth := 42
  oBmp1:nHeight := 46
  oBmp1:lShowHint := .F.
  oBmp1:lReadOnly := .F.
  oBmp1:Align := 0
  oBmp1:lVisibleControl := .F.
  oBmp1:cBmpFile := "\Imagens\ico-bien.bmp"
  oBmp1:lStretch := .F.
  oBmp1:lAutoSize := .F.

/*
oCombo78 := TCOMBOBOX():Create(oDlg)
oCombo78:cName := "oCombo78"
oCombo78:nLeft := 595
oCombo78:nTop := 318
oCombo78:nWidth := 262
oCombo78:nHeight := 21
oCombo78:lShowHint := .F.
oCombo78:lReadOnly := .F.
oCombo78:Align := 0
oCombo78:cVariable := "cboEster"
oCombo78:bSetGet := {|u| If(PCount()>0,cboEster:=u,cboEster) }
oCombo78:lVisibleControl := .T.
oCombo78:nAt := 0

oSay79 := TSAY():Create(oDlg)
oSay79:cName := "oSay79"
oSay79:cCaption := "Em Posse de Terceiros"
oSay79:nLeft := 597
oSay79:nTop := 303
oSay79:nWidth := 136
oSay79:nHeight := 13
oSay79:lShowHint := .F.
oSay79:lReadOnly := .F.
oSay79:Align := 0
oSay79:lVisibleControl := .T.
oSay79:lWordWrap := .F.
oSay79:lTransparent:=.T.
*/

  oGrp82 := TGROUP():Create(oDlg)
  oGrp82:cName := "oGrp82"
  oGrp82:cCaption := "Formacao de Precos de Venda"
  oGrp82:nLeft := 6
  oGrp82:nTop := 465
  oGrp82:nWidth := 831
  oGrp82:nHeight := 100
  oGrp82:lShowHint := .F.
  oGrp82:lReadOnly := .F.
  oGrp82:Align := 0
  oGrp82:lVisibleControl := .T.

  oGrp83 := TGROUP():Create(oDlg)
  oGrp83:cName := "oGrp83"
  oGrp83:cCaption := ">Produtos Qualificados<"
  oGrp83:nLeft := 655
  oGrp83:nTop := 194
  oGrp83:nWidth := 288
  oGrp83:nHeight := 106
  oGrp83:lShowHint := .F.
  oGrp83:lReadOnly := .F.
  oGrp83:Align := 0
  oGrp83:lVisibleControl := .T.

  oList86 := TLISTBOX():Create(oDlg)
  oList86:cName := "oList86"
  oList86:cCaption := "oList86"
  oList86:nLeft := 658
  oList86:nTop := 205
  oList86:nWidth := 280
  oList86:nHeight := 87
  oList86:lShowHint := .F.
  oList86:lReadOnly := .F.
  oList86:Align := 0
  oList86:oFont:="oFontT"
  oList86:cVariable := "lstFqual"
  oList86:bSetGet := {|u| If(PCount()>0,lstFqual:=u,lstFqual) }
  oList86:bChange := {|| U_RAPLOTE("") }
  oList86:lVisibleControl := .T.
  oList86:aItems := aFornQual
  oList86:nAt := 0
  oList86:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")


  oGrp81 := TGROUP():Create(oDlg)
  oGrp81:cName := "oGrp81"
  oGrp81:cCaption := "Historico de Consultas"
  oGrp81:nLeft := 2
  oGrp81:nTop := 352
  oGrp81:nWidth := 385
  oGrp81:nHeight := 115
  oGrp81:lShowHint := .F.
  oGrp81:lReadOnly := .F.
  oGrp81:Align := 0
  oGrp81:lVisibleControl := .T.


  oList88:= TLISTBOX():Create(oDlg)
  oList88:cName := "oList88"
  oList88:cCaption := "oList88"
  oList88:nLeft := 7
  oList88:nTop := 365
  oList88:nWidth := 376
  oList88:nHeight := 97
  oList88:lShowHint := .F.
  oList88:lReadOnly := .F.
  oList88:Align := 0
  oList88:cVariable := "lstOrc"
  oList88:bSetGet := {|u| If(PCount()>0,lstOrc:=u,lstOrc) }
  oList88:lVisibleControl := .T.
  oList88:aItems := aHistOrc
  oList88:nAt := 0
  oList88:bChange := {|| U_RAPORC("") }
  oList88:oFont:=oFontT
  oList88:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGrp84 := TGROUP():Create(oDlg)
  oGrp84:cName := "oGrp84"
  oGrp84:cCaption := "Historico de Entradas"
  oGrp84:nLeft := 390
  oGrp84:nTop := 352
  oGrp84:nWidth := 553
  oGrp84:nHeight := 115
  oGrp84:lShowHint := .F.
  oGrp84:lReadOnly := .F.
  oGrp84:Align := 0
  oGrp84:lVisibleControl := .T.

  oSBtn096 := TBUTTON():Create(oDlg)
  oSBtn096 :cName := "oSBtn096"
  oSBtn096 :cCaption := "H"
  oSBtn096 :nLeft := 925
  oSBtn096 :nTop := 365
  oSBtn096 :nWidth := 16
  oSBtn096 :nHeight := 21
  oSBtn096 :lShowHint := .F.
  oSBtn096 :lReadOnly := .F.
  oSBtn096 :Align := 0
  oSBtn096 :lVisibleControl := .T.
//oSBtn959 :nType := 1
  oSBtn096 :bAction:={|| U_RAPFEN()}


  oSBtn097 := TBUTTON():Create(oDlg)
  oSBtn097 :cName := "oSBtn097"
  oSBtn097 :cCaption := "$"
  oSBtn097 :nLeft := 925
  oSBtn097 :nTop := 385
  oSBtn097 :nWidth := 16
  oSBtn097 :nHeight := 21
  oSBtn097 :lShowHint := .F.
  oSBtn097 :lReadOnly := .F.
  oSBtn097 :Align := 0
  oSBtn097 :lVisibleControl := .T.
//oSBtn959 :nType := 1
  oSBtn097 :bAction:={|| U_RAPENT(1)}


  oSBtn098 := TBUTTON():Create(oDlg)
  oSBtn098 :cName := "oSBtn098"
  oSBtn098 :cCaption := "+"
  oSBtn098 :nLeft := 925
  oSBtn098 :nTop := 405
  oSBtn098 :nWidth := 16
  oSBtn098 :nHeight := 21
  oSBtn098 :lShowHint := .F.
  oSBtn098 :lReadOnly := .F.
  oSBtn098 :Align := 0
  oSBtn098 :lVisibleControl := .T.
//oSBtn959 :nType := 1
  oSBtn098 :bAction:={|| U_RAPENT(2)}

//oGet85 := TGET():New(,,,oDlg,,,,,CLR_RED,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
//New(,,,,,,, [aoWnd],,,,,,, [aoFont],,,,,,,,)
  oList87 := TLISTBOX():Create(oDlg)
  oList87:cName := "oList87"
  oList87:cCaption := "oList87"
  oList87:nLeft := 395
  oList87:nTop := 365
  oList87:nWidth := 527
  oList87:nHeight := 97
  oList87:lShowHint := .F.
  oList87:lReadOnly := .F.
  oList87:Align := 0
  oList87:cVariable := "lstEntr"
  oList87:bSetGet := {|u| If(PCount()>0,lstEntr:=u,lstEntr) }
  oList87:lVisibleControl := .T.
  oList87:aItems := aHistEnt
  oList87:nAt := 0
//oList87:bChange := {|| U_RAPENT("") }
  oList87:oFont:=oFontT
  oLIst87:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")


  oSBtn85 := TBUTTON():Create(oDlg)
  oSBtn85:cName := "oSBtn85"
  oSBtn85:cCaption := "Incluir na Cesta"
  oSBtn85:nLeft := 840
  oSBtn85:nTop := 468
  oSBtn85:nWidth := 105
  oSBtn85:nHeight := 18
  oSBtn85:lShowHint := .F.
  oSBtn85:lReadOnly := .F.
  oSBtn85:Align := 0
  oSBtn85:lVisibleControl := .T.
//oSBtn85:nType := 1
  oSBtn85:bAction := {|| U_HCENVORC() }

  oSBtn93 := TBUTTON():Create(oDlg)
  oSBtn93:cName := "oSBtn93"
  oSBtn93:cCaption := "Alterar Cesta"
  oSBtn93:nLeft := 840
  oSBtn93:nTop := 486
  oSBtn93:nWidth := 105
  oSBtn93:nHeight := 18
  oSBtn93:lShowHint := .F.
  oSBtn93:lReadOnly := .F.
  oSBtn93:Align := 0
  oSBtn93:lVisibleControl := .T.
//oSBtn93:nType := 1
  oSBtn93:bAction := {|| U_RAPOR8() }

  oSBtn91 := TBUTTON():Create(oDlg)
  oSBtn91:cName := "oSBtn91"
  oSBtn91:cCaption := "Gerar Orcamento"
  oSBtn91:nLeft := 840
  oSBtn91:nTop := 504
  oSBtn91:nWidth := 105
  oSBtn91:nHeight := 18
  oSBtn91:lShowHint := .F.
  oSBtn91:lReadOnly := .F.
  oSBtn91:Align := 0
  oSBtn91:lVisibleControl := .T.
//oSBtn91:nType := 1
  oSBtn91:bAction := {|| U_HCINCORC() }

  oSBtn92 := TBUTTON():Create(oDlg)
  oSBtn92:cName := "oSBtn92"
  oSBtn92:cCaption := "Limpar Cesta"
  oSBtn92:nLeft := 840
  oSBtn92:nTop := 522
  oSBtn92:nWidth := 105
  oSBtn92:nHeight := 19
  oSBtn92:lShowHint := .F.
  oSBtn92:lReadOnly := .F.
  oSBtn92:Align := 0
  oSBtn92:lVisibleControl := .T.
//oSBtn92:nType := 1
  oSBtn92:bAction := {|| U_HCLIMPOR() }

  oSBtn90 := TBUTTON():Create(oDlg)
  oSBtn90:cName := "oSBtn90"
  oSBtn90:cCaption := "Sair"
  oSBtn90:nLeft := 840
  oSBtn90:nTop := 541
  oSBtn90:nWidth := 105
  oSBtn90:nHeight := 18
  oSBtn90:lShowHint := .F.
  oSBtn90:lReadOnly := .F.
  oSBtn90:Align := 0
  oSBtn90:lVisibleControl := .T.
//oSBtn90:nType := 1
  oSBtn90:bAction := {|| oDlg:End() }

  oGet90 := TGET():Create(oDlg)
  oGet90:cName := "oGet90"
  oGet90:cCaption := "oGet90"
  oGet90:nLeft := 13
  oGet90:nTop := 506
  oGet90:nWidth := 139
  oGet90:nHeight := 21
  oGet90:lShowHint := .F.
  oGet90:lReadOnly := .F.
  oGet90:Align := 0
  oGet90:lVisibleControl := .F.
  oGet90:lPassword := .F.
  oGet90:lHasButton := .F.



// INFORMACOES PARA FORMACAO DE PRECOS DE VENDA


  oSay87:= TSAY():Create(oDlg)
  oSay87:cName := "oSay87"
  oSay87:cCaption := "Valores de Venda"
  oSay87:nLeft := 350
  oSay87:nTop := 465
  oSay87:nWidth := 90
  oSay87:nHeight := 17
  oSay87:lShowHint := .F.
  oSay87:lReadOnly := .F.
  oSay87:Align := 0
  oSay87:lVisibleControl := .T.
  oSay87:lWordWrap := .F.
  oSay87:lTransparent:=.T.


  oSay100 := TSAY():Create(oDlg)
  oSay100:cName := "oSay100"
  oSay100:cCaption := "Modalidades"
  oSay100:nLeft := 14
  oSay100:nTop := 479
  oSay100:nWidth := 65
  oSay100:nHeight := 17
  oSay100:lShowHint := .F.
  oSay100:lReadOnly := .F.
  oSay100:Align := 0
  oSay100:lVisibleControl := .T.
  oSay100:lWordWrap := .F.
  oSay100:lTransparent:=.T.

  oSay102 := TSAY():Create(oDlg)
  oSay102:cName := "oSay102"
  oSay102:cCaption := "Direto"
  oSay102:nLeft := 14
  oSay102:nTop := 498
  oSay102:nWidth := 65
  oSay102:nHeight := 17
  oSay102:lShowHint := .F.
  oSay102:lReadOnly := .F.
  oSay102:Align := 0
  oSay102:lVisibleControl := .T.
  oSay102:lWordWrap := .F.
  oSay102:lTransparent:=.T.

  oSay103 := TSAY():Create(oDlg)
  oSay103:cName := "oSay103"
  oSay103:cCaption := "Direto+Repr2"
  oSay103:nLeft := 14
  oSay103:nTop := 518
  oSay103:nWidth := 64
  oSay103:nHeight := 17
  oSay103:lShowHint := .F.
  oSay103:lReadOnly := .F.
  oSay103:Align := 0
  oSay103:lVisibleControl := .T.
  oSay103:lWordWrap := .F.
  oSay103:lTransparent:=.T.

  oSay104 := TSAY():Create(oDlg)
  oSay104:cName := "oSay104"
  oSay104:cCaption := "Repr1+Repr2"
  oSay104:nLeft := 14
  oSay104:nTop := 539
  oSay104:nWidth := 65
  oSay104:nHeight := 17
  oSay104:lShowHint := .F.
  oSay104:lReadOnly := .F.
  oSay104:Align := 0
  oSay104:lVisibleControl := .T.
  oSay104:lWordWrap := .F.
  oSay104:lTransparent:=.T.

  oSay105 := TSAY():Create(oDlg)
  oSay105:cName := "oSay105"
  oSay105:cCaption := "% MC"
  oSay105:nLeft := 80
  oSay105:nTop := 479
  oSay105:nWidth := 65
  oSay105:nHeight := 17
  oSay105:lShowHint := .F.
  oSay105:lReadOnly := .F.
  oSay105:Align := 0
  oSay105:lVisibleControl := .T.
  oSay105:lWordWrap := .F.
  oSay105:lTransparent:=.T.

  oSay106 := TSAY():Create(oDlg)
  oSay106:cName := "oSay106"
  oSay106:cCaption := "%Despesas"
  oSay106:nLeft := 145
  oSay106:nTop := 479
  oSay106:nWidth := 65
  oSay106:nHeight := 17
  oSay106:lShowHint := .F.
  oSay106:lReadOnly := .F.
  oSay106:Align := 0
  oSay106:lVisibleControl := .T.
  oSay106:lWordWrap := .F.
  oSay106:lTransparent:=.T.

  oSay107 := TSAY():Create(oDlg)
  oSay107:cName := "oSay107"
  oSay107:cCaption := "%Pis"
  oSay107:nLeft := 209
  oSay107:nTop := 479
  oSay107:nWidth := 65
  oSay107:nHeight := 17
  oSay107:lShowHint := .F.
  oSay107:lReadOnly := .F.
  oSay107:Align := 0
  oSay107:lVisibleControl := .T.
  oSay107:lWordWrap := .F.
  oSay107:lTransparent:=.T.

  oSay108 := TSAY():Create(oDlg)
  oSay108:cName := "oSay108"
  oSay108:cCaption := "%Cofins"
  oSay108:nLeft := 273
  oSay108:nTop := 479
  oSay108:nWidth := 65
  oSay108:nHeight := 17
  oSay108:lShowHint := .F.
  oSay108:lReadOnly := .F.
  oSay108:Align := 0
  oSay108:lVisibleControl := .T.
  oSay108:lWordWrap := .F.
  oSay108:lTransparent:=.T.

  oSay109 := TSAY():Create(oDlg)
  oSay109:cName := "oSay109"
  oSay109:cCaption := "ICMS 0%"
  oSay109:nLeft := 340
  oSay109:nTop := 479
  oSay109:nWidth := 65
  oSay109:nHeight := 17
  oSay109:lShowHint := .F.
  oSay109:lReadOnly := .F.
  oSay109:Align := 0
  oSay109:lVisibleControl := .T.
  oSay109:lWordWrap := .F.
  oSay109:lTransparent:=.T.

  oSay110 := TSAY():Create(oDlg)
  oSay110:cName := "oSay110"
  oSay110:cCaption := "ICMS 7%"
  oSay110:nLeft := 540
  oSay110:nTop := 479
  oSay110:nWidth := 65
  oSay110:nHeight := 16
  oSay110:lShowHint := .F.
  oSay110:lReadOnly := .F.
  oSay110:Align := 0
  oSay110:lVisibleControl := .T.
  oSay110:lWordWrap := .F.
  oSay110:lTransparent:=.T.

  oSay111 := TSAY():Create(oDlg)
  oSay111:cName := "oSay111"
  oSay111:cCaption := "ICMS 12%"
  oSay111:nLeft := 640
  oSay111:nTop := 479
  oSay111:nWidth := 65
  oSay111:nHeight := 17
  oSay111:lShowHint := .F.
  oSay111:lReadOnly := .F.
  oSay111:Align := 0
  oSay111:lVisibleControl := .T.
  oSay111:lWordWrap := .F.
  oSay111:lTransparent:=.T.

  oSay112 := TSAY():Create(oDlg)
  oSay112:cName := "oSay112"
  oSay112:cCaption := "ICMS 18%"
  oSay112:nLeft := 740
  oSay112:nTop := 479
  oSay112:nWidth := 65
  oSay112:nHeight := 17
  oSay112:lShowHint := .F.
  oSay112:lReadOnly := .F.
  oSay112:Align := 0
  oSay112:lVisibleControl := .T.
  oSay112:lWordWrap := .F.
  oSay112:lTransparent:=.T.

  oSayI04 := TSAY():Create(oDlg)
  oSayI04:cName := "oSayI04"
  oSayI04:cCaption := "ICMS"
  oSayI04:nLeft := 440
  oSayI04:nTop := 479
  oSayI04:nWidth := 65
  oSayI04:nHeight := 17
  oSayI04:lShowHint := .F.
  oSayI04:lReadOnly := .F.
  oSayI04:Align := 0
  oSayI04:lVisibleControl := .T.
  oSayI04:lWordWrap := .F.
  oSayI04:lTransparent:=.T.

  oGetI000 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontT,,,,,,,,,,,,,,,,,)
  oGetI000:cName := "oGetI000"
  oGetI000:nLeft := 465
  oGetI000:nTop := 479
  oGetI000:nWidth := 65
  oGetI000:nHeight := 17
  oGetI000:lShowHint := .F.
  oGetI000:lReadOnly := .F.
  oGetI000:Align := 0
  oGetI000:cVariable := "cIcmg"
  oGetI000:bSetGet := {|u| If(PCount()>0,cIcmg:=u,cIcmg) }
  oGetI000:lVisibleControl := .T.
  oGetI000:lPassword := .F.
  oGetI000:lHasButton := .F.
  oGetI000:bVALID := {|| U_HCMARGEM() }
  oGetI000:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGet115 := TGET():New(,,,oDlg,,,"@E 999.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet115:cName := "oGet115"
  oGet115:nLeft := 80
  oGet115:nTop := 496
  oGet115:nWidth := 63
  oGet115:nHeight := 21
  oGet115:lShowHint := .F.
  oGet115:lReadOnly := .F.
  oGet115:Align := 0
  oGet115:cVariable := "cMC1"
  oGet115:bSetGet := {|u| If(PCount()>0,cMC1:=u,cMC1) }
  oGet115:lVisibleControl := .T.
  oGet115:lPassword := .F.
  oGet115:lHasButton := .F.
  oGet115:bChange := {|| U_HCMARGEM() }
  oGet115:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet114 := TGET():New(,,,oDlg,,,"@E 999.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet114:cName := "oGet114"
  oGet114:nLeft := 80
  oGet114:nTop := 517
  oGet114:nWidth := 63
  oGet114:nHeight := 21
  oGet114:lShowHint := .F.
  oGet114:lReadOnly := .F.
  oGet114:Align := 0
  oGet114:cVariable := "cMC2"
  oGet114:bSetGet := {|u| If(PCount()>0,cMC2:=u,cMC2) }
  oGet114:lVisibleControl := .T.
  oGet114:lPassword := .F.
  oGet114:lHasButton := .F.
  oGet114:bChange := {|| U_HCMARGEM() }
  oGet114:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet132 := TGET():New(,,,oDlg,,,"@E 999.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet132:cName := "oGet132"
  oGet132:nLeft := 80
  oGet132:nTop := 539
  oGet132:nWidth := 63
  oGet132:nHeight := 21
  oGet132:lShowHint := .F.
  oGet132:lReadOnly := .F.
  oGet132:Align := 0
  oGet132:cVariable := "cMC3"
  oGet132:bSetGet := {|u| If(PCount()>0,cMC3:=u,cMC3) }
  oGet132:lVisibleControl := .T.
  oGet132:lPassword := .F.
  oGet132:lHasButton := .F.
  oGet132:bChange := {|| U_HCMARGEM() }
  oGet132:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet116 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet116:cName := "oGet116"
  oGet116:nLeft := 143
  oGet116:nTop := 496
  oGet116:nWidth := 63
  oGet116:nHeight := 21
  oGet116:lShowHint := .F.
  oGet116:lReadOnly := .F.
  oGet116:Align := 0
  oGet116:cVariable := "cComis1"
  oGet116:bSetGet := {|u| If(PCount()>0,cComis1:=u,cComis1) }
  oGet116:lVisibleControl := .T.
  oGet116:lPassword := .F.
  oGet116:lHasButton := .F.
  oGet116:bChange := {|| U_HCMARGEM() }
  oGet116:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet117 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet117:cName := "oGet117"
  oGet117:nLeft := 205
  oGet117:nTop := 496
  oGet117:nWidth := 63
  oGet117:nHeight := 21
  oGet117:lShowHint := .F.
  oGet117:lReadOnly := .F.
  oGet117:Align := 0
  oGet117:cVariable := "cPis1"
  oGet117:bSetGet := {|u| If(PCount()>0,cPis1:=u,cPis1) }
  oGet117:lVisibleControl := .T.
  oGet117:lPassword := .F.
  oGet117:lHasButton := .F.
  oGet117:bChange := {|| U_HCMARGEM() }
  oGet117:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet118 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet118:cName := "oGet118"
  oGet118:nLeft := 268
  oGet118:nTop := 496
  oGet118:nWidth := 63
  oGet118:nHeight := 21
  oGet118:lShowHint := .F.
  oGet118:lReadOnly := .F.
  oGet118:Align := 0
  oGet118:cVariable := "cCof1"
  oGet118:bSetGet := {|u| If(PCount()>0,cCof1:=u,cCof1) }
  oGet118:lVisibleControl := .T.
  oGet118:lPassword := .F.
  oGet118:lHasButton := .F.
  oGet118:bChange := {|| U_HCMARGEM() }
  oGet118:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet119 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet119:cName := "oGet119"
  oGet119:nLeft := 340
  oGet119:nTop := 496
  oGet119:nWidth := 95
  oGet119:nHeight := 21
  oGet119:lShowHint := .F.
  oGet119:lReadOnly := .F.
  oGet119:Align := 0
  oGet119:cVariable := "cIc001"
  oGet119:bSetGet := {|u| If(PCount()>0,cIc001:=u,cIc001) }
  oGet119:lVisibleControl := .T.
  oGet119:lPassword := .F.
  oGet119:lHasButton := .F.
  oGet119:bVALID := {|| U_HCVER001("001") }
  oGet119:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oGet120 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet120:cName := "oGet120"
  oGet120:nLeft := 540
  oGet120:nTop := 496
  oGet120:nWidth := 95
  oGet120:nHeight := 21
  oGet120:lShowHint := .F.
  oGet120:lReadOnly := .F.
  oGet120:Align := 0
  oGet120:cVariable := "cIc071"
  oGet120:bSetGet := {|u| If(PCount()>0,cIc071:=u,cIc071) }
  oGet120:lVisibleControl := .T.
  oGet120:lPassword := .F.
  oGet120:lHasButton := .F.
  oGet120:bVALID := {|| U_HCVER001("071") }
  oGet120:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oGet121 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet121:cName := "oGet121"
  oGet121:nLeft := 640
  oGet121:nTop := 496
  oGet121:nWidth := 95
  oGet121:nHeight := 21
  oGet121:lShowHint := .F.
  oGet121:lReadOnly := .F.
  oGet121:Align := 0
  oGet121:cVariable := "cIc121"
  oGet121:bSetGet := {|u| If(PCount()>0,cIc121:=u,cIc121) }
  oGet121:lVisibleControl := .T.
  oGet121:lPassword := .F.
  oGet121:lHasButton := .F.
  oGet121:bVALID := {|| U_HCVER001("121") }
  oGet121:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oGet122 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet122:cName := "oGet122"
  oGet122:nLeft := 740
  oGet122:nTop := 496
  oGet122:nWidth := 95
  oGet122:nHeight := 21
  oGet122:lShowHint := .F.
  oGet122:lReadOnly := .F.
  oGet122:Align := 0
  oGet122:cVariable := "cIc181"
  oGet122:bSetGet := {|u| If(PCount()>0,cIc181:=u,cIc181) }
  oGet122:lVisibleControl := .T.
  oGet122:lPassword := .F.
  oGet122:lHasButton := .F.
  oGet122:bVALID := {|| U_HCVER001("181") }
  oGet122:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGetI041 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGetI041:cName := "oGetI041"
  oGetI041:nLeft := 440
  oGetI041:nTop := 496
  oGetI041:nWidth := 95
  oGetI041:nHeight := 21
  oGetI041:lShowHint := .F.
  oGetI041:lReadOnly := .F.
  oGetI041:Align := 0
  oGetI041:cVariable := "cIc041"
  oGetI041:bSetGet := {|u| If(PCount()>0,cIc041:=u,cIc041) }
  oGetI041:lVisibleControl := .T.
  oGetI041:lPassword := .F.
  oGetI041:lHasButton := .F.
  oGetI041:bVALID := {|| U_HCVER001("041") }
  oGetI041:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oGet123 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet123:cName := "oGet123"
  oGet123:nLeft := 143
  oGet123:nTop := 517
  oGet123:nWidth := 63
  oGet123:nHeight := 21
  oGet123:lShowHint := .F.
  oGet123:lReadOnly := .F.
  oGet123:Align := 0
  oGet123:cVariable := "cComis2"
  oGet123:bSetGet := {|u| If(PCount()>0,cComis2:=u,cComis2) }
  oGet123:lVisibleControl := .T.
  oGet123:lPassword := .F.
  oGet123:lHasButton := .F.
  oGet123:bChange := {|| U_HCMARGEM() }
  oGet123:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet127 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet127:cName := "oGet127"
  oGet127:nLeft := 205
  oGet127:nTop := 517
  oGet127:nWidth := 63
  oGet127:nHeight := 21
  oGet127:lShowHint := .F.
  oGet127:lReadOnly := .F.
  oGet127:Align := 0
  oGet127:cVariable := "cPis2"
  oGet127:bSetGet := {|u| If(PCount()>0,cPis2:=u,cPis2) }
  oGet127:lVisibleControl := .T.
  oGet127:lPassword := .F.
  oGet127:lHasButton := .F.
  oGet127:bChange := {|| U_HCMARGEM() }
  oGet127:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet128 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet128:cName := "oGet128"
  oGet128:nLeft := 268
  oGet128:nTop := 517
  oGet128:nWidth := 63
  oGet128:nHeight := 21
  oGet128:lShowHint := .F.
  oGet128:lReadOnly := .F.
  oGet128:Align := 0
  oGet128:cVariable := "cCof2"
  oGet128:bSetGet := {|u| If(PCount()>0,cCof2:=u,cCof2) }
  oGet128:lVisibleControl := .T.
  oGet128:lPassword := .F.
  oGet128:lHasButton := .F.
  oGet128:bChange := {|| U_HCMARGEM() }
  oGet128:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet129 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet129:cName := "oGet129"
  oGet129:nLeft := 340
  oGet129:nTop := 517
  oGet129:nWidth := 95
  oGet129:nHeight := 21
  oGet129:lShowHint := .F.
  oGet129:lReadOnly := .F.
  oGet129:Align := 0
  oGet129:cVariable := "cIc002"
  oGet129:bSetGet := {|u| If(PCount()>0,cIc002:=u,cIc002) }
  oGet129:lVisibleControl := .T.
  oGet129:lPassword := .F.
  oGet129:lHasButton := .F.
  oGet129:bVALID := {|| U_HCVER001("002") }
  oGet129:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oGet130 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet130:cName := "oGet130"
  oGet130:nLeft := 540
  oGet130:nTop := 517
  oGet130:nWidth := 95
  oGet130:nHeight := 21
  oGet130:lShowHint := .F.
  oGet130:lReadOnly := .F.
  oGet130:Align := 0
  oGet130:cVariable := "cIc072"
  oGet130:bSetGet := {|u| If(PCount()>0,cIc072:=u,cIc072) }
  oGet130:lVisibleControl := .T.
  oGet130:lPassword := .F.
  oGet130:lHasButton := .F.
  oGet130:bVALID := {|| U_HCVER001("072") }
  oGet130:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oGet131:= TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet131:cName := "oGet131"
  oGet131:nLeft := 640
  oGet131:nTop := 517
  oGet131:nWidth := 95
  oGet131:nHeight := 21
  oGet131:lShowHint := .F.
  oGet131:lReadOnly := .F.
  oGet131:Align := 0
  oGet131:cVariable := "cIc122"
  oGet131:bSetGet := {|u| If(PCount()>0,cIc122:=u,cIc122) }
  oGet131:lVisibleControl := .T.
  oGet131:lPassword := .F.
  oGet131:lHasButton := .F.
  oGet131:bVALID := {|| U_HCVER001("122") }
  oGet131:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGet148 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet148:cName := "oGet148"
  oGet148:nLeft := 740
  oGet148:nTop := 517
  oGet148:nWidth := 95
  oGet148:nHeight := 21
  oGet148:lShowHint := .F.
  oGet148:lReadOnly := .F.
  oGet148:Align := 0
  oGet148:cVariable := "cIc182"
  oGet148:bSetGet := {|u| If(PCount()>0,cIc182:=u,cIc182) }
  oGet148:lVisibleControl := .T.
  oGet148:lPassword := .F.
  oGet148:lHasButton := .F.
  oGet148:bVALID := {|| U_HCVER001("182") }
  oGet148:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGetI042 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGetI042:cName := "oGetI042"
  oGetI042:nLeft := 440
  oGetI042:nTop := 517
  oGetI042:nWidth := 95
  oGetI042:nHeight := 21
  oGetI042:lShowHint := .F.
  oGetI042:lReadOnly := .F.
  oGetI042:Align := 0
  oGetI042:cVariable := "cIc042"
  oGetI042:bSetGet := {|u| If(PCount()>0,cIc042:=u,cIc042) }
  oGetI042:lVisibleControl := .T.
  oGetI042:lPassword := .F.
  oGetI042:lHasButton := .F.
  oGetI042:bVALID := {|| U_HCVER001("042") }
  oGetI042:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")


  oGet133 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet133:cName := "oGet133"
  oGet133:nLeft := 143
  oGet133:nTop := 539
  oGet133:nWidth := 63
  oGet133:nHeight := 21
  oGet133:lShowHint := .F.
  oGet133:lReadOnly := .F.
  oGet133:Align := 0
  oGet133:cVariable := "cComis3"
  oGet133:bSetGet := {|u| If(PCount()>0,cComis3:=u,cComis3) }
  oGet133:lVisibleControl := .T.
  oGet133:lPassword := .F.
  oGet133:lHasButton := .F.
  oGet133:bChange := {|| U_HCMARGEM() }
  oGet133:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet134 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet134:cName := "oGet134"
  oGet134:nLeft := 205
  oGet134:nTop := 539
  oGet134:nWidth := 63
  oGet134:nHeight := 21
  oGet134:lShowHint := .F.
  oGet134:lReadOnly := .F.
  oGet134:Align := 0
  oGet134:cVariable := "cPis3"
  oGet134:bSetGet := {|u| If(PCount()>0,cPis3:=u,cPis3) }
  oGet134:lVisibleControl := .T.
  oGet134:lPassword := .F.
  oGet134:lHasButton := .F.
  oGet134:bChange := {|| U_HCMARGEM() }
  oGet134:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet135 := TGET():New(,,,oDlg,,,"@E 99.99",,CLR_BLACK,RGB(230,230,230),oFontB,,,,,,,,,,,,,,,,,)
  oGet135:cName := "oGet135"
  oGet135:nLeft := 268
  oGet135:nTop := 539
  oGet135:nWidth := 63
  oGet135:nHeight := 21
  oGet135:lShowHint := .F.
  oGet135:lReadOnly := .F.
  oGet135:Align := 0
  oGet135:cVariable := "cCof3"
  oGet135:bSetGet := {|u| If(PCount()>0,cCof3:=u,cCof3) }
  oGet135:lVisibleControl := .T.
  oGet135:lPassword := .F.
  oGet135:lHasButton := .F.
  oGet135:bChange := {|| U_HCMARGEM() }
  oGet135:setCSS("QLineEdit{color:#000000; background-color:#F0FFFF}")

  oGet136 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet136:cName := "oGet136"
  oGet136:nLeft := 340
  oGet136:nTop := 539
  oGet136:nWidth := 95
  oGet136:nHeight := 21
  oGet136:lShowHint := .F.
  oGet136:lReadOnly := .F.
  oGet136:Align := 0
  oGet136:cVariable := "cIc003"
  oGet136:bSetGet := {|u| If(PCount()>0,cIc003:=u,cIc003) }
  oGet136:lVisibleControl := .T.
  oGet136:lPassword := .F.
  oGet136:lHasButton := .F.
  oGet136:bVALID := {|| U_HCVER001("003") }
  oGet136:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGet137 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet137:cName := "oGet137"
  oGet137:nLeft := 540
  oGet137:nTop := 539
  oGet137:nWidth := 95
  oGet137:nHeight := 21
  oGet137:lShowHint := .F.
  oGet137:lReadOnly := .F.
  oGet137:Align := 0
  oGet137:cVariable := "cIc073"
  oGet137:bSetGet := {|u| If(PCount()>0,cIc073:=u,cIc073) }
  oGet137:lVisibleControl := .T.
  oGet137:lPassword := .F.
  oGet137:lHasButton := .F.
  oGet137:bVALID := {|| U_HCVER001("073") }
  oGet137:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGet138 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet138:cName := "oGet138"
  oGet138:nLeft := 640
  oGet138:nTop := 539
  oGet138:nWidth := 95
  oGet138:nHeight := 21
  oGet138:lShowHint := .F.
  oGet138:lReadOnly := .F.
  oGet138:Align := 0
  oGet138:cVariable := "cIc123"
  oGet138:bSetGet := {|u| If(PCount()>0,cIc123:=u,cIc123) }
  oGet138:lVisibleControl := .T.
  oGet138:lPassword := .F.
  oGet138:lHasButton := .F.
  oGet138:bVALID := {|| U_HCVER001("123") }
  oGet138:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGet139 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGet139:cName := "oGet139"
  oGet139:nLeft := 740
  oGet139:nTop := 539
  oGet139:nWidth := 95
  oGet139:nHeight := 21
  oGet139:lShowHint := .F.
  oGet139:lReadOnly := .F.
  oGet139:Align := 0
  oGet139:cVariable := "cIc183"
  oGet139:bSetGet := {|u| If(PCount()>0,cIc183:=u,cIc183) }
  oGet139:lVisibleControl := .T.
  oGet139:lPassword := .F.
  oGet139:lHasButton := .F.
  oGet139:bVALID := {|| U_HCVER001("183") }
  oGet139:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  oGetI043 := TGET():New(,,,oDlg,,,"@E 999,999.99",,CLR_RED,,oFontB,,,,,,,,,,,,,,,,,)
  oGetI043:cName := "oGetI043"
  oGetI043:nLeft := 440
  oGetI043:nTop := 539
  oGetI043:nWidth := 95
  oGetI043:nHeight := 21
  oGetI043:lShowHint := .F.
  oGetI043:lReadOnly := .F.
  oGetI043:Align := 0
  oGetI043:cVariable := "cIc043"
  oGetI043:bSetGet := {|u| If(PCount()>0,cIc043:=u,cIc043) }
  oGetI043:lVisibleControl := .T.
  oGetI043:lPassword := .F.
  oGetI043:lHasButton := .F.
  oGetI043:bVALID := {|| U_HCVER001("043") }
  oGetI043:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")

  IF cCodOrig!=nil
    U_PCODPR(cCodOrig,cCliOrig,cTipo)
    cCodOrig:=Nil
  endif

  oDlg:Activate()

  RestArea(aAreaAtu)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PCOdou   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados do produto e listas auxiliares				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOUTRA()
  Local cCodZ
  lOCAL nEspacos
  IF LEN(CBOOUTROS)>0
    cCodZ:=SUBSTR(cboOutros,5,15)
    nEspacos:=15-len(cCodZ)
    cCodigo:=cCodZ+space(nEspacos)
    oDlg:REFRESH()
    U_PCODPR()
    cCli00:setfocus()

  ENDIF
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PCOdou   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados do produto e listas auxiliares				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOUTRB()
  Local cCodA
  IF LEN(CBOAVANC)>0
    cCodA:=SUBSTR(cboAvanc,6,15)
    cCodigo:=cCodA
    oDlg:REFRESH()
    U_PCODPR()
    cCli00:setfocus()
  ENDIF
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PCORPR   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados do produto e listas auxiliares				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PCODPR(cCodOrig,cCliOrig,cTipo)
// carregando produto se encontrado
  Local aAreaAtu	:= GetArea()
  LOCAL cEstcl
  Local cForna
  Local cFornece
  Local cCliente
  Local cTpOrc22
  Local cTpOrc23
  Local cEstoque
  Local cMoeda
  Local nMoeda
  Local nValFob
  Local nCodMoeda
  LOCAL lBlock:=.F.
  Local lEstrut:=.F.
  lOCAL nPonto:=0
  Local cAm1
  Local cAm2
  Local cAm3
  Local cAm4
  lOCAL cAm5
  Local cAm6
  Local cAm7
  Local nSdoCas
  Local nSdoPV
  Local nSdoOc
  Local cIndice
  Local cPedRef
  Local cValcom
  Local cQuerySC6
  Local cQuerySCK
  Local cQuerySd1
  Local cQuerySC7
  Local cQueryAIB
  Local cAliasSd1:="SD1"
  Local cAliasSCK:="SCK"
  Local NContador:=0
  Local cLtForn:=""
  Local cLtQuant:=0
  Local cLtCusto:=0
  Local nFatSc:=0
  Local cHoraIni:=StrTran(Time(),":")

  oGet200:SetColor(RGB(149,0,0),RGB(230,230,230))
  oGet200:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")
  cCodigo:=upper(cCodigo)
  IF cCodOrig!=nil
    cCodigo:=upper(cCodOrig)

  endif
  IF cCliOrig!=nil
    cCli:=cCliOrig
  endif
  IF CCODIGO="               " .OR. LEN(cCodigo)=0
    RETURN
  ENDIF
  IF cCli!="      "
    cNomered:=Posicione("SA1",1,xFilial("SA1")+cCli,"A1_NREDUZ")
  endif
  for x=1 to len(trim(cCodigo))
    if substr(cCodigo,x,1)="+"
      lEstrut:=.T.
      nPonto:=x
      cCodigo:=substr(cCodigo,1,nPonto-1)+SPACE(15-LEN(substr(cCodigo,1,nPonto-1)))
    endif
  next
  If lEstrut=.t.
    aAreaAtu	:= GetArea()
    U_HC093Pr(.F.,"cCodigo",cCodigo)
    if len(trim(cCodigo))>0
      A093VldCod(cCodigo,.T.)
    endif
    RestArea(aAreaAtu)
  endif
  IF CCODIGO="               " .OR. LEN(cCodigo)=0
    RETURN
  ENDIF
  DbSelectArea("SB1")
  dbSetOrder(1)
  If MsSeek(xfilial("SB1")+cCodigo)
    IF SB1->B1_MSBLQL='1'
      lBlock:=.T.
      MsgInfo("O codigo do produto digitado esta bloqueado (inexistente ou em duplicidade)...", "Inconsistencia")
      RETURN
    ENDIF
    if cQtdVd=0 .and. cCodOrig=nil
      RETURN
    ELSE
      cQtdV2:=cQtdVd
    ENDIF
    nDe3:=0
    nCasada:=0
    nSdoCas:=0
    cMensagem:=""
    oGetZ38  :lVisibleControl := .F.
    cCod   :=SB1->B1_COD
    cTiEs  :=SB1->B1_XSTATUS
    CdESCR :=SB1->B1_DESC
    cAlmox :=SB1->B1_LOCPAD
    nPeso  :=sb1->b1_peso
    cUnid  :=SB1->B1_UM
    cEstmin:=SB1->B1_ESTSEG
    cLtime :=SB1->B1_PE
    cMedio:=SB1->B1_LE
    cVdMn :=SB1->B1_VDAMIN
    cVdNor:=SB1->B1_VDANOR
    cTabela:= SB1->B1_TABELA
    cPolVenda:=SB1->B1_GRPVAR
    IF SB1->B1_XSTATUS="EN"
      IF SB1->B1_ESTSEG<0
        cPP:= SB1->B1_ESTSEG+(SB1->B1_LE*SB1->B1_PE/30)
      ELSE
        cPP:= SB1->B1_ESTSEG+(SB1->B1_LE*SB1->B1_PE/30)
      ENDIF
    ELSE
      cPP:=0
    ENDIF
    cTecn  :=U_MATATEC(cCod)
    cComis1:=0.00
    cComis2:=SB1->B1_COMIS
    cComis3:=SB1->B1_COMIS * 2
    cPis1:=1.65
    cPis2:=1.65
    cPis3:=1.65
    cCof1:=7.60
    cCof2:=7.60
    cCof3:=7.60
    cIcmg:=4.00
    DbSelectArea("PAA")
    dbSetOrder(1)
    if MsSeek(xfilial("PAA")+cCod)
      if PAA->PAA_LOGIN='10%' .OR. PAA->PAA_LOGIN='00%'
        oGetZ38   :lVisibleControl := .T.
        if PAA->PAA_LOGIN='10%'
          oGetZ38   :SetColor(RGB(149,0,0),RGB(206,255,206))
          oGetZ38   :setCSS("QLineEdit{color:#000000; background-color:#FFFF00}")
          cMensagem :="Oferta (Margem 10% (estoque)"
        else
          oGetZ38   :SetColor(RGB(149,0,0),RGB(206,255,206))
          oGetZ38   :setCSS("QLineEdit{color:#FFFFFF; background-color:#FF0000}")
          cMensagem :="Oferta (Margem  0% (estoque)"
        endif
        oGet200:SetColor(RGB(149,0,0),RGB(230,230,230))
        oGet200:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")
        ccusto:=PAA->PAA_UNIT
        cMed2:=PAA->PAA_UNIT
      endif
      IF PAA->PAA_UNIT2<>0 .AND. PAA->PAA_UNIT3=0
        oGet200:SetColor(RGB(149,0,0),RGB(206,255,206))
        oGet200:setCSS("QLineEdit{color:#B22222; background-color:#7FFFD4}")
        ccusto:=PAA->PAA_UNIT2
        cMed2:=PAA->PAA_UNIT
      ELSEIF PAA->PAA_UNIT3<>0
        oGet200:SetColor(RGB(149,0,0),RGB(206,255,206))
        oGet200:setCSS("QLineEdit{color:#B22222; background-color:#00BFFF}")
        ccusto:=PAA->PAA_UNIT3
        cMed2:=PAA->PAA_UNIT
      ELSE
        oGet200:SetColor(RGB(149,0,0),RGB(230,230,230))
        oGet200:setCSS("QLineEdit{color:#B22222; background-color:#F0FFFF}")
        ccusto:=PAA->PAA_UNIT
        cMed2:=PAA->PAA_UNIT
      ENDIF

    ELSE
      CCUSTO:=0.00
      cMed2:=0.00
    ENDIF
    // verifica se o material for tupy carrega uma tabela auxiliar para aplicar fator custo
    if trim(SM0->M0_CODFIL)<>"01"
      IF Posicione("SX5",1, xFilial("SX5")+"TP"+SB1->B1_GRPVAR, "X5_DESCENG")<> "                                                       "
        CCUSTO:=CCUSTO*val(Posicione("SX5",1,xFilial("SX5")+"TP"+SB1->B1_GRPVAR, "X5_DESCENG"))
      endif
    else
      IF Posicione("SX5",1, xFilial("SX5")+"TP"+SB1->B1_GRPVAR, "X5_DESCRI")<> "                                                        "
        CCUSTO:=CCUSTO*val(Posicione("SX5",1,xFilial("SX5")+"TP"+SB1->B1_GRPVAR, "X5_DESCRI"))
      endif
    endif
    cMc1:=Posicione("PA7",1,xFilial("PA7")+SB1->B1_GRPVAR,"PA7_MRG")
    cMc2:=cMc1
    cMc3:=cMc1
    cIcm001:=0
    cIcm002:=0
    cIcm003:=0
    cIcm071:=0
    cIcm072:=0
    cIcm073:=0
    cIcm121:=0
    cIcm122:=0
    cIcm123:=0
    cIcm181:=0
    cIcm182:=0
    cIcm183:=0
    //cCusto:=""
    nScompra:=""
    cDtInv:=""
    cValcom:=0
    cValorOrc:=0
    nOrcPen:=0
    cRastro:=""
    cLtQuant:=0
    cLtCusto:=0
    nFatSc:=0
  eLSE
    nQtdVd:=0
    nDe3:=0
    nCasada:=0
    nSdoCas:=0
    cCod  :=""
    cTiEs  :=""
    CdESCR:=""
    cAlmox:=""
    nPeso :=""
    cUnid :=""
    cEstmin:=0
    cLtime :=0
    cMedio:=""
    cTecn:=""
    cPP:=0
    nOsvir:=0
    nOrcPen:=0
    nPoder3:=0
    nDe3:=0
    nCasada:=0
    cMc1:=""
    cMc2:=""
    cMc3:=""
    cComis1:=""
    cComis2:=""
    cComis3:=""
    cPis1:=""
    cPis2:=""
    cPis3:=""
    cCof1:=""
    cCof2:=""
    cCof3:=""
    cIcm001:=0
    cIcm002:=0
    cIcm003:=0
    cIcm071:=0
    cIcm072:=0
    cIcm073:=0
    cIcm121:=0
    cIcm122:=0
    cIcm123:=0
    cIcm181:=0
    cIcm182:=0
    cIcm183:=0
    cCusto:=0.00
    cMed2:=0.00
    nScompra:=""
    cVdNor:=""
    cVdMn:=""
    cTabela:=""
    cDtInv:=""
    cValcom:=0
    nSdoPV:=0
    nSdoOc:=0
    cValorOrc:=0
    cPolVenda:=""
    cRastro:=""
    cLtQuant:=0
    cLtCusto:=0
    nFatSc:=0
    oBmp1:lVisibleControl := .f.
  ENDIF
  oDlg:REFRESH()
  nEstfis:=0
//carregando saldo real do produto
  nPoder3:=0
  nDe3:=0
  aAlmox:={}
  DbSelectArea("SB2")
  dbSetOrder(1)
  MsSeek(xfilial("SB2")+cCodigo)
  While ( !Eof() .And. SB2->B2_COD == cCodigo )
    IF SB2->B2_STATUS<>"2"
      nEstfis:=nEstfis+SB2->B2_QATU+SB2->B2_QNPT
    ENDIF
    dbSkip()
  EndDo
  aVdaPend:={}
  cQuerySC6 := "SELECT SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_LOCAL,"
  cQuerySC6 += "SC6.C6_PRCVEN,SC6.C6_ENTREG,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_DATFAT FROM " + RetSqlName("SC6")+ " SC6 "
  cQuerySC6 += "WHERE "
  cQuerySC6 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
  cQuerySC6 += "SC6.C6_PRODUTO = '"+cCodigo+"' AND "
  cQuerySc6 += "SC6.C6_QTDVEN-SC6.C6_QTDENT>0 AND "
  cQuerySC6 += "SC6.D_E_L_E_T_=' '"
//cQuery := ChangeQuery(cQuery)
  If ( Select ("QSC6") <> 0 )
    dbSelectArea ("QSC6")
    dbCloseArea ()
  Endif
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC6),"QSC6",.F.,.T.)
  dbSelectArea("QSC6")
/*
DbSelectArea("SC6")
dbSetOrder(11)
MsSeek(xfilial("SC6")+cCodigo)
*/
  nEntra15:=0
  cEntra15:=""
  nEntra01:=0
  cEntra01:=""
  nContador:=0
  aVdaEntr:={}
  aVdaPend:={}
  nSdoPv:=0
  nSdoOc:=0
  While ( !Eof() .And. QSC6->C6_PRODUTO == cCodigo )
    // precisa verificar empenhO pela tes
    if Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_DUPLIC")="S" .OR. SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D" .OR. SUBSTR(QSC6->C6_NUM,1,1)="T" .OR. SUBSTR(QSC6->C6_NUM,1,1)="R" .OR. SUBSTR(QSC6->C6_NUM,1,1)="A" .OR. QSC6->C6_TES="514" .OR. QSC6->C6_TES="999" .OR. QSC6->C6_TES="693" .OR. QSC6->C6_TES="553" .OR. QSC6->C6_TES="555" .OR. QSC6->C6_TES="592" .OR. QSC6->C6_TES="556" .OR. QSC6->C6_TES="591" .OR. Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_RAPIDA")="S"
      nEstfis:=nEstfis-(QSC6->C6_QTDVEN-QSC6->C6_QTDENT)
      IF SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D"
        cCliente:=Posicione("SA2",1,xFilial("SA2")+QSC6->C6_CLI+QSC6->C6_LOJA,"A2_NREDUZ")
        cCliente:=" -Fn:" + RTRIM(cCliente)
      ELSE
        cCliente:=Posicione("SA1",1,xFilial("SA1")+QSC6->C6_CLI+QSC6->C6_LOJA,"A1_NREDUZ")
        cCliente:=" -Cl:" + RTRIM(cCliente)
      ENDIF
      IF SUBSTR(QSC6->C6_NUM,1,1)="B"
        cIndice:="OS"
        cPedRef:="0"+SUBSTR(QSC6->C6_NUM,2,5)
      ELSE
        cIndice:="PV"
        cPedRef:=QSC6->C6_NUM
      ENDIF
      if nContador<=GETMV("MV_RAP001")
        IF QSC6->C6_QTDVEN-QSC6->C6_QTDENT>0
          nSdoPV:=QSC6->C6_QTDVEN-QSC6->C6_QTDENT
          DbSelectArea("SZK")
          dbSetOrder(1)
          //if Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_OC")<>"      "
          IF MsSeek(xfilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM)
            While ( !Eof() .And. cIndice=SZK->ZK_TIPO .AND.  cPedRef=SZK->ZK_REF .AND. SZK->ZK_REFITEM=QSC6->C6_ITEM)
              cAm1:=SZK->ZK_OC
              cAm2:=SZK->ZK_ITEM
              cAm3:=SZK->ZK_FORN
              cAm4:=SZK->ZK_TIPO2
              cAm5:=SZK->ZK_STATUS
              cAm6:=SZK->ZK_QTS
              cAm7:=SZK->ZK_QTC
              nSdoOc:=nSdoOc+cAm6
              //dbSelectArea("QSC6")
              IF cAm5<>"4" .AND. cAm4="OC"
                nSdoCas:=nSdoCas + cAm6
              ENDIF
              IF cAm5<>"4" .AND. cAm4="OS"
                IF cAm6>0 .AND. cAm6>QSC6->C6_QTDVEN-QSC6->C6_QTDENT
                  nEstfis:=nEstfis+QSC6->C6_QTDVEN-QSC6->C6_QTDENT
                else
                  nEstfis:=nEstfis+cAm6
                endif
              endif
              if QSC6->C6_LOCAL='15'
                cEntra15:=QSC6->C6_LOCAL
                nEntra15:=nEntra15+cAm6
              else
                cEntra01:=QSC6->C6_LOCAL
                nEntra01:=nEntra01+cAm6
              endif
              nSdoPv:=nSdoPv-cAm7
              if nSdoPv<0
                aAdd( aVdaPend,{"Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " -SDO: " + transform(0,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") + " - Pzo: " + SUBSTRING(QSC6->C6_ENTREG,7,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,5,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,3,2) + " - Sts: " + cAm4 + "/" + cAm1 + "/" + cAm2+ "/" + rtrim(cAm3)+"/sd:"+transform(cAm6,"@R 9999"), SUBSTRING(QSC6->C6_ENTREG,1,8)})
                if nSdoOc>QSC6->C6_QTDVEN-QSC6->C6_QTDENT
                  nEstfis:=nEstfis-cAm7
                endif
              else
                aAdd( aVdaPend,{"Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " -SDO: " + transform(cAm7,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") + " - Pzo: " + SUBSTRING(QSC6->C6_ENTREG,7,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,5,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,3,2) + " - Sts: " + cAm4 + "/" + cAm1 + "/" + cAm2+ "/" + rtrim(cAm3)+"/sd:"+transform(cAm6,"@R 9999"), SUBSTRING(QSC6->C6_ENTREG,1,8)})
              endif
              DbSelectArea("SZK")
              dbSkip()
            EndDo
            if nSdoPv>0
              aAdd( aVdaPend,{"Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " -SDO: " + transform(nSdoPv,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") + " - Pzo: " + SUBSTRING(QSC6->C6_ENTREG,7,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,5,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,3,2) + " - Sts: Estoque", SUBSTRING(QSC6->C6_ENTREG,1,8)})
            endif
            dbSelectArea("QSC6")

          else
            dbSelectArea("QSC6")
            aAdd( aVdaPend,{"Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " -SDO: " + transform(QSC6->C6_QTDVEN-QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") + " - Pzo: " + SUBSTRING(QSC6->C6_ENTREG,7,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,5,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,3,2) + " - Sts: Estoque", SUBSTRING(QSC6->C6_ENTREG,1,8)})
          endif
          IF QSC6->C6_QTDENT>0
            aAdd( aVdaEntr,"Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " - QEnt: " + transform(QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(Posicione("SD2",8,xfilial("SD2")+QSC6->C6_NUM+QSC6->C6_ITEM,"D2_PRCVEN"),"@e 9,999,999.99") +  " - NF: " + QSC6->C6_NOTA + " - Data: " + SUBSTRING(QSC6->C6_DATFAT,7,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,5,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,3,2))
            nContador:=nContador+1
          ENDIF
        else
          if cCli="      "
            aAdd( aVdaEntr, "Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " - QEnt: " + transform(QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") +  " - NF: " + QSC6->C6_NOTA + " - Data: " + SUBSTRING(QSC6->C6_DATFAT,7,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,5,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,3,2))
            nContador:=nContador+1
          else
            if cCli=QSC6->C6_CLI
              aAdd( aVdaEntr, "Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " - QEnt: " + transform(QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(Posicione("SD2",8,xfilial("SD2")+QSC6->C6_NUM+QSC6->C6_ITEM,"D2_PRCVEN"),"@e 9,999,999.99") +  " - NF: " + QSC6->C6_NOTA + " - Data: " + SUBSTRING(QSC6->C6_DATFAT,7,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,5,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,3,2))
              nContador:=nContador+1
            ENDIF
          ENDIF
        ENDIF
      Endif
    ENDIF
    dbSkip()
  EndDo
  dbSelectArea("QSC6")
  QSC6->(DbCloseArea())
//aVdaEntr:={}
  cQuerySC6 := "SELECT SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_LOCAL,"
  cQuerySC6 += "SC6.C6_PRCVEN,SC6.C6_ENTREG,SC6.C6_NOTA,SC6.C6_SERIE,SC6.C6_DATFAT FROM " + RetSqlName("SC6")+ " SC6 "
  cQuerySC6 += "WHERE "
  cQuerySC6 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
  cQuerySC6 += "SC6.C6_PRODUTO = '"+cCodigo+"' AND SC6.C6_QTDVEN-SC6.C6_QTDENT=0 AND "
  cQuerySC6 += "SC6.D_E_L_E_T_=' ' ORDER BY SC6.C6_DATFAT DESC FETCH FIRST " + substring(STRZERO(GETMV("MV_RAP001")),25,6) +" ROWS ONLY"
//cQuery := ChangeQuery(cQuery)
  If ( Select ("QSC6") <> 0 )
    dbSelectArea ("QSC6")
    dbCloseArea ()
  Endif
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC6),"QSC6",.F.,.T.)
  dbSelectArea("QSC6")
  nContador:=0
  While ( !Eof() .And. QSC6->C6_PRODUTO == cCodigo .AND. nContador<=GETMV("MV_RAP001"))
    // precisa verificar empenhO pela tes
    if Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_DUPLIC")="S" .OR. SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D" .OR. SUBSTR(QSC6->C6_NUM,1,1)="T" .OR. SUBSTR(QSC6->C6_NUM,1,1)="R" .OR. SUBSTR(QSC6->C6_NUM,1,1)="A" .OR. QSC6->C6_TES="514" .OR. QSC6->C6_TES="999" .OR. QSC6->C6_TES="693" .OR. QSC6->C6_TES="553" .OR. QSC6->C6_TES="592" .OR. QSC6->C6_TES="555" .OR. QSC6->C6_TES="556" .OR. QSC6->C6_TES="591" .OR. Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_RAPIDA")="S"
      nEstfis:=nEstfis-(QSC6->C6_QTDVEN-QSC6->C6_QTDENT)
      IF SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D"
        cCliente:=Posicione("SA2",1,xFilial("SA2")+QSC6->C6_CLI+QSC6->C6_LOJA,"A2_NREDUZ")
        cCliente:=" -Fn:" + RTRIM(cCliente)
      ELSE
        cCliente:=Posicione("SA1",1,xFilial("SA1")+QSC6->C6_CLI+QSC6->C6_LOJA,"A1_NREDUZ")
        cCliente:=" -Cl:" + RTRIM(cCliente)
      ENDIF
      IF SUBSTR(QSC6->C6_NUM,1,1)="B"
        cIndice:="OS"
        cPedRef:="0"+SUBSTR(QSC6->C6_NUM,2,5)
      ELSE
        cIndice:="PV"
        cPedRef:=QSC6->C6_NUM
      ENDIF
      if nContador<=GETMV("MV_RAP001")
        IF QSC6->C6_QTDVEN-QSC6->C6_QTDENT>0
          DbSelectArea("SZK")
          dbSetOrder(1)
          //if Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_OC")<>"      "
          IF MsSeek(xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM)
            cAm1:=SZK->ZK_OC
            cAm2:=SZK->ZK_ITEM
            cAm3:=SZK->ZK_FORN
            cAm4:=SZK->ZK_TIPO2
            cAm5:=SZK->ZK_STATUS
            cAm6:=SZK->ZK_QTS
            cAm7:=SZK->ZK_QTC
            dbSelectArea("QSC6")
            IF cAm5<>"4" .AND. cAm4="OC"
              nSdoCas:=nSdoCas + cAm6
            ENDIF
            IF cAm5<>"4" .AND. cAm4="OS"
              IF cAm6>0 .AND. cAm6>QSC6->C6_QTDVEN-QSC6->C6_QTDENT
                nEstfis:=nEstfis+QSC6->C6_QTDVEN-QSC6->C6_QTDENT
              else
                nEstfis:=nEstfis+cAm6
              endif
            endif
            if QSC6->C6_LOCAL='15'
              cEntra15:=QSC6->C6_LOCAL
              nEntra15:=nEntra15+cAm6
            else
              cEntra01:=QSC6->C6_LOCAL
              nEntra01:=nEntra01+cAm6
            endif
            aAdd( aVdaPend,{"Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " -SDO: " + transform(QSC6->C6_QTDVEN-QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") + " - Pzo: " + SUBSTRING(QSC6->C6_ENTREG,7,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,5,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,3,2) + " - Sts: " + cAm4 + "/" + cAm1 + "/" + cAm2+ "/" + rtrim(cAm3)+"/sd:"+transform(cAm6,"@R 9999"), SUBSTRING(QSC6->C6_ENTREG,1,8)})
          else
            dbSelectArea("QSC6")
            aAdd( aVdaPend,{"Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " -SDO: " + transform(QSC6->C6_QTDVEN-QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") + " - Pzo: " + SUBSTRING(QSC6->C6_ENTREG,7,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,5,2)+'/'+SUBSTRING(QSC6->C6_ENTREG,3,2) + " - Sts: Estoque", SUBSTRING(QSC6->C6_ENTREG,1,8)})
          endif
          IF QSC6->C6_QTDENT>0
            aAdd( aVdaEntr, "Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " - QEnt: " + transform(QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(Posicione("SD2",8,xfilial("SD2")+QSC6->C6_NUM+QSC6->C6_ITEM,"D2_PRCVEN"),"@e 9,999,999.99") +  " - NF: " + QSC6->C6_NOTA + " - Data: " + SUBSTRING(QSC6->C6_DATFAT,7,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,5,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,3,2))
            nContador:=nContador+1
          ENDIF
        else
          if cCli="      "
            aAdd( aVdaEntr, "Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " - QEnt: " + transform(QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(Posicione("SD2",8,xfilial("SD2")+QSC6->C6_NUM+QSC6->C6_ITEM,"D2_PRCVEN"),"@e 9,999,999.99") +  " - NF: " + QSC6->C6_NOTA + " - Data: " + SUBSTRING(QSC6->C6_DATFAT,7,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,5,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,3,2))
            nContador:=nContador+1
          else
            if cCli=QSC6->C6_CLI
              aAdd( aVdaEntr, "Pd/It:" + QSC6->C6_NUM + "/" + QSC6->C6_ITEM + SUBSTRING(cCliente,1,18) + " -Alm: " + QSC6->C6_LOCAL + " - QEnt: " + transform(QSC6->C6_QTDENT,"@e 9999") + " -R$ " + transform(QSC6->C6_PRCVEN,"@e 9,999,999.99") +  " - NF: " + QSC6->C6_NOTA + " - Data: " + SUBSTRING(QSC6->C6_DATFAT,7,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,5,2)+'/'+SUBSTRING(QSC6->C6_DATFAT,3,2))
              nContador:=nContador+1
            ENDIF
          ENDIF
        ENDIF
      Endif
    ENDIF
    dbSkip()
  EndDo
  dbSelectArea("QSC6")
  QSC6->(DbCloseArea())
//CARREGA SALDOS POR ALMOXARIFADO SUBTRAINDO SALDOS DOS PEDIDOS SE ESTOQUE
  DbSelectArea("SB2")
  dbSetOrder(1)
  MsSeek(xfilial("SB2")+cCodigo)
  nEncontrei:=0
  While ( !Eof() .And. SB2->B2_COD == cCodigo )
    if SB2->B2_LOCAL=cEntra01 .AND. (SB2->B2_STATUS<>"2" .OR. SB2->B2_LOCAL="TR")
      if SB2->B2_QATU-SB2->B2_QPEDVEN-SB2->B2_RESERVA+SB2->B2_QNPT-SB2->B2_QTNP+nEntra01<>0
        aAdd( aAlmox, "Almox:" + SB2->B2_LOCAL + " - Saldo:" + transform(SB2->B2_QATU-SB2->B2_QPEDVEN-SB2->B2_RESERVA+SB2->B2_QNPT-SB2->B2_QTNP+nEntra01,"@R 999999"))
        nEncontrei:=1
      ENDIF
    ENDIF
    if SB2->B2_LOCAL=cEntra15 .AND. (SB2->B2_STATUS<>"2" .OR. SB2->B2_LOCAL="TR")
      if SB2->B2_QATU-SB2->B2_QPEDVEN-SB2->B2_RESERVA+SB2->B2_QNPT-SB2->B2_QTNP+nEntra15<>0
        aAdd( aAlmox, "Almox:" + SB2->B2_LOCAL + " - Saldo:" + transform(SB2->B2_QATU-SB2->B2_QPEDVEN-SB2->B2_RESERVA+SB2->B2_QNPT-SB2->B2_QTNP+nEntra15,"@R 999999"))
        nEncontrei:=1
      ENDIF
    ENDIF
    if SB2->B2_LOCAL<>'15' .and. SB2->B2_LOCAL<>'01' .and. nEncontrei=0 .AND. (SB2->B2_STATUS<>"2" .OR. SB2->B2_LOCAL="TR")
      if SB2->B2_QATU-SB2->B2_QPEDVEN-SB2->B2_RESERVA+SB2->B2_QNPT-SB2->B2_QTNP<>0
        aAdd( aAlmox, "Almox:" + SB2->B2_LOCAL + " - Saldo:" + transform(SB2->B2_QATU-SB2->B2_QPEDVEN-SB2->B2_RESERVA+SB2->B2_QNPT-SB2->B2_QTNP,"@R 999999"))
      ENDIF
    ENDIF
    dbSkip()
    nEncontrei:=0
  EndDo
// deduzindo posse de terceiros nao disponivel
  DBSELECTAREA("SB6")
  DBSETORDER(1)
  If SB6->(DbSeek(xFilial("SB6")+cCodigo))
    While xFilial("SB6") == SB6->B6_FILIAL .and. ! SZB->(Eof()) .and. SB6->B6_PRODUTO == cCodigo
      If SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="E"
        // ACERTANDO A SITUACAO DE DEPOSITO FECHADO CARMAR (NAO SUBTRAI ESTOQUE)
        IF (SB6->B6_CLIFOR='000090' .OR. SB6->B6_CLIFOR='000669'.OR. SB6->B6_CLIFOR='000001') .AND. SB6->B6_tpcf='C'
          IF SB6->B6_PODER3='R'
            nPoder3:=nPoder3+SB6->B6_SALDO
          ENDIF
        ELSE
          // DEMAIS SITUACOES DA ANALISE
          // SITUACOES EM QUE MANDO PARA BENEFICIAR FORA (SUBTRAI ESTOQUE)
          IF SB6->B6_tpcf='F' .AND. SB6->B6_PODER3='R'
            nEstfis:=nEstfis-SB6->B6_SALDO
            nPoder3:=nPoder3+SB6->B6_SALDO
          ENDIF
          // SITUACOES EM QUE EXISTE REMESSA EM CONSIGNACAO INDUSTRIAL (SUBTRAI ESTOQUE)
          IF SB6->B6_tpcf='C' .AND. SB6->B6_PODER3='R'
            nEstfis:=nEstfis-SB6->B6_SALDO
            nPoder3:=nPoder3+SB6->B6_SALDO
          ENDIF
        ENDIF
      ENDIF
      IF SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="D" .AND. SB6->B6_tpcf='C'
        nEstfis:=nEstfis-SB6->B6_SALDO
        nDe3:=nDe3+SB6->B6_SALDO
      ELSE
        IF SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="D"
          nDe3:=nDe3+SB6->B6_SALDO
        ENDIF
      ENDIF
      SB6->(DbSkip())
    EndDo
  ENDIF
// carregando codigos alternativos e seus saldos
// 	aAdd( aCombo, JAH->JAH_CODIGO)
  DbSelectArea("PA1")
  dbSetOrder(1)
  aAlterna:={}
  MsSeek(xfilial("PA1")+cCodigo)
  While ( !Eof() .And. PA1->PA1_PROD == cCodigo )
    nEstCl:=0
    //carregando saldo real do produto
    /*    
    DbSelectArea("SB2")
    dbSetOrder(1)
    MsSeek(xfilial("SB2")+PA1->PA1_ALTERN)
    While ( !Eof() .And. SB2->B2_COD == PA1->PA1_ALTERN )
      nEstCl:=nEstCl+SB2->B2_QATU
      dbSkip()
    EndDo
    DbSelectArea("SC6")
    dbSetOrder(11)
    MsSeek(xfilial("SC6")+PA1->PA1_ALTERN)
    While ( !Eof() .And. SC6->C6_PRODUTO == PA1->PA1_ALTERN)
      if Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_ESTOQUE")="S"
        nEstCl:=nEstCl-(SC6->C6_QTDVEN-SC6->C6_QTDENT)
      ENDIF
	  dbSkip()
    EndDo
    cEstcl:=transform(nEstCl,"@e 99999.99")
    */
    aAdd( aAlterna, "COD:" + PA1->PA1_ALTERN )
    DbSelectArea("PA1")
    dbSkip()
  EndDo
  if empty( aAlterna )
    aAdd( aAlterna, "" )
  endif
  if empty( aVdaPend )
    aAdd( aVdaPend,{"",""})
  endif
  if empty( aVdaEntr )
    aAdd( aVdaEntr, "" )
  endif
  if empty( aAlmox )
    aAdd( aAlmox, "" )
  endif

  oCombo11:aItems := aAlterna

// ordenando a data
  ASORT(aVdaPend, , , { | x,y | x[2] < y[2] } )
  aVdaPend2:={}
  for s=1 to Len(aVdaPend)
    if Len(aVdaPend) = 1 .and. aVdaPend[1,1] =""
      aAdd(aVdaPend2 ,"")
    else
      aAdd(aVdaPend2 ,"" + aVdaPend[s,1])
    endif
  next
  oCombo66:aItems := aVdaPend2
  oCombo67:aItems := aVdaEntr
  oCombo74:aItems := aAlmox
// carregando Fornecedores Qualificados
/*
DbSelectArea("SA5")
dbSetOrder(2)
aFornQual:={}
MsSeek(xfilial("SA5")+cCodigo)
  While ( !Eof() .And. SA5->A5_PRODUTO == cCodigo )
    if cForna<>SA5->A5_FORNECE
      DbSelectArea("SA2")
      dbSetOrder(1)
      MsSeek(xfilial("SA2")+SA5->A5_FORNECE)
      aAdd( aFornQual, "COD:" + SA5->A5_FORNECE + " - " + SA2->A2_NREDUZ)
      cForna:=SA5->A5_FORNECE
	  DbSelectArea("SA5")
    endif
	dbSkip()
  EndDo
  if empty( aFornQual )
	aAdd( aFornQual, "" )
  endif
oList86:aItems := aFornQual
*/
  nEstVir:=0
// carregando Saldo de Oc Pendentes
  IF lCheckBo2 = .T.
    cQuerySC7 := "SELECT SC7.C7_NUM,SC7.C7_ITEM,SC7.C7_PRODUTO,SC7.C7_QUANT,SC7.C7_QUJE,SC7.C7_LOCAL,SC7->C7_FOB_MO,SC7->C7_FOB_VL,SC7->C7_FOB_FOR,SC7.C7_FORNECE,SC7.C7_LOJA,SC7.C7_MOEDA,SC7.C7_DESIMPO,"
    cQuerySC7 += "SC7.C7_PRECO,SC7.C7_VALICM,SC7.C7_EMISSAO,SC7.C7_DIAS,SC7.C7_IPI,SC7.C7_DATPRF,SC7.C7_TES,SC7.C7_TXMOEDA "
    cQuerySC7 += "FROM " + RetSqlName("SC7")+ " SC7 WHERE "
    IF lCheckBo2 = .F.
      cQuerySC7 += "SC7.C7_FILIAL = '"+xFilial("SC7")+"' AND "
    ENDIF
    cQuerySC7 += "SC7.C7_PRODUTO = '"+cCodigo+"' AND "
    cQuerySC7 += "SC7.C7_QUANT-SC7.C7_QUJE>0 AND "
    cQuerySC7 += "SC7.D_E_L_E_T_=' ' ORDER BY SC7.C7_DATPRF DESC"
    //cQuery := ChangeQuery(cQuery)
    If ( Select ("SC7") <> 0 )
      dbSelectArea ("SC7")
      dbCloseArea ()
    Endif
    dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC7),"SC7",.T.,.T.)
    dbSelectArea("SC7")
  endif
  IF lCheckBo2 = .F.
    If ( Select ("SC7") <> 0 )
      dbSelectArea ("SC7")
      dbCloseArea ()
    Endif
    DbSelectArea("SC7")
    dbSetOrder(7)
    MsSeek(xfilial("SC7")+cCodigo)
  endif
  aCpaPend:={}
  While ( !Eof() .And. SC7->C7_PRODUTO == cCodigo)
    //      dOcEmissao:=
    //      dOcVencimento:=
    cMoeda:=""
    nCodMoeda:=SC7->C7_FOB_MO
    nValFob:=C7_FOB_VL
    nMoeda:=0
    cCliente:=SC7->C7_FOB_FOR
    if SC7->C7_TES<>'49Z'
      nEstVir:=nEstVir+(SC7->C7_QUANT-SC7->C7_QUJE)
    ENDIF
    if nCodMoeda=0
      nCodMoeda:=SC7->C7_MOEDA
      nValFob:=SC7->C7_PRECO
    endif
    IF nCodMoeda=1
      IF SC7->C7_QUANT-SC7->C7_QUJE>0
        cCliente:=SC7->C7_FOB_FOR
        IF LEN(TRIM(cCliente))=0
          cCliente:=Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ")
        endif
        cCliente:=" - Fn: " + RTRIM(cCliente)
        if SC7->C7_TES<>'49Z'
          IF SC7->C7_TES='101'
            aAdd( aCpaPend, "Oc/Item:" + SC7->C7_NUM + "/" + SC7->C7_ITEM + cCliente + " -Alm: " + SC7->C7_LOCAL + " - SDO: " + transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 9999") + " -R$ " + transform(nValFob-(SC7->C7_VALICM/SC7->C7_QUANT)-(nValFob*0.0925),"@e 9999999.99") + " - VcOr-Real: " + dtoc(SC7->C7_emisSAO+SC7->C7_DIAS)+"-"+dtoc(SC7->C7_DATPRF))
          ELSE
            if SC7->C7_TES='106'
              aAdd( aCpaPend, "Oc/Item:" + SC7->C7_NUM + "/" + SC7->C7_ITEM + cCliente + " -Alm: " + SC7->C7_LOCAL + " - SDO: " + transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 9999") + " -R$ " + transform(nValFob*1.114989,"@e 9999999.99") + " - VcOr-Real: " + dtoc(SC7->C7_emisSAO+SC7->C7_DIAS)+"-"+dtoc(SC7->C7_DATPRF))
            else
              IF SC7->C7_TES = "172"
                IF SC7->C7_EMISSAO>=CTOD("20/08/13")
                  aAdd( aCpaPend, "Oc/Item:" + SC7->C7_NUM + "/" + SC7->C7_ITEM + cCliente + " -Alm: " + SC7->C7_LOCAL + " - SDO: " + transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 9999") + " -R$ " + transform(nValFob-(SC7->C7_VALICM/SC7->C7_QUANT),"@e 9999999.99") + " - VcOr-Real: " + dtoc(SC7->C7_emisSAO+SC7->C7_DIAS)+"-"+dtoc(SC7->C7_DATPRF))
                ELSE
                  aAdd( aCpaPend, "Oc/Item:" + SC7->C7_NUM + "/" + SC7->C7_ITEM + cCliente + " -Alm: " + SC7->C7_LOCAL + " - SDO: " + transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 9999") + " -R$ " + transform(nValFob-(SC7->C7_VALICM/SC7->C7_QUANT)-(nValFob*0.0925),"@e 9999999.99") + " - VcOr-Real: " + dtoc(SC7->C7_emisSAO+SC7->C7_DIAS)+"-"+dtoc(SC7->C7_DATPRF))
                ENDIF
              ELSE
                aAdd( aCpaPend, "Oc/Item:" + SC7->C7_NUM + "/" + SC7->C7_ITEM + cCliente + " -Alm: " + SC7->C7_LOCAL + " - SDO: " + transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 9999") + " -R$ " + transform(nValFob-(SC7->C7_VALICM/SC7->C7_QUANT)-(nValFob*0.0925)+(nValFob*SC7->C7_IPI/100),"@e 9999999.99") + " - VcOr-Real: " + dtoc(SC7->C7_emisSAO+SC7->C7_DIAS)+"-"+dtoc(SC7->C7_DATPRF))
              ENDIF
            endif
          ENDIF
        ENDIF
      ENDIF
    ELSE
      IF SC7->C7_QUANT-SC7->C7_QUJE>0
        cCliente:=SC7->C7_FOB_FOR
        IF LEN(TRIM(cCliente))=0
          cCliente:=Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ")
        endif
        cCliente:=" - Fn: " + RTRIM(cCliente)
        IF nCodMoeda=2
          cMoeda:="US$"
          DbSelectArea( "SM2" )
          dbSetOrder(1)
          DbSeek(DATE(), .T.)
          nMoeda:=SM2->M2_MOEDA2
          DBSELECTAREA("SC7")
        ENDIF
        IF nCodMoeda=4
          cMoeda:="EU$"
          DbSelectArea( "SM2" )
          dbSetOrder(1)
          DbSeek(DATE(), .T.)
          nMoeda:=SM2->M2_MOEDA4
          DBSELECTAREA("SC7")
        ENDIF
        //if nMoeda=0
        //  nMoeda:=SC7->C7_TXMOEDA
        //ENDIF
        if SC7->C7_TES<>'49Z'
          if sc7->c7_desimpo=0
            aAdd( aCpaPend, "Oc/Item:" + SC7->C7_NUM + "/" + SC7->C7_ITEM + cCliente + " -Alm: " + SC7->C7_LOCAL + " - SDO: " + transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 9999") + " -R$(F) " + transform(nValFob*nMoeda,"@e 999999.99") + " -" + cMoeda + transform(nValFob,"@e 99999.99")+ " - VcOr-Real: " + dtoc(SC7->C7_emisSAO+SC7->C7_DIAS)+"-"+dtoc(SC7->C7_DATPRF))
          else
            aAdd( aCpaPend, "Oc/Item:" + SC7->C7_NUM + "/" + SC7->C7_ITEM + cCliente + " -Alm: " + SC7->C7_LOCAL + " - SDO: " + transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 9999") + " -R$(P) " + transform(nValFob*nMoeda*SC7->C7_DESIMPO,"@e 999999.99") + " -" + cMoeda + transform(nValFob,"@e 99999.99")+ " - VcOr-Real: " + dtoc(SC7->C7_emisSAO+SC7->C7_DIAS)+"-"+dtoc(SC7->C7_DATPRF))
          endif
        ENDIF
      ENDIF
    ENDIF
    dbSkip()
  EndDo
  if empty( aCpaPend )
    aAdd( aCpaPend , "" )
  endif
  oCombo59:aItems := aCpaPend
  nOsVir:=0
// CARREGANDO SALDOS DE OS PENDENTES

  DbSelectArea("AB7")
  dbSetOrder(10)
  aOsPend:={}
  aOs:={}
  MsSeek(xfilial("AB7")+cCodigo)
  While ( !Eof() .And. AB7->AB7_CODPRE == cCodigo)
    IF AB7->AB7_TIPO="1"
      nOSVir:=nOSVir+AB7->AB7_QTENT
      cCabec:=Posicione("AB6",1,xFilial("AB6")+AB7->AB7_NUMOS,"AB6_NREDUZ")
      cVencOs:=Posicione("AB6",1,xFilial("AB6")+AB7->AB7_NUMOS,"AB6_VENCTO")
      cCabec:=" - Fn: " + RTRIM(cCabec)
      aAdd( aOsPend, "OS/Item:" + AB7->AB7_NUMOS + "/" + AB7->AB7_ITEM + cCabec + " -Alm: " + AB7->AB7_ALMOX +" - SDO: " + transform(AB7->AB7_QTENT,"@e 9999") +  " - Pzo: " + dtoc(cVencOs)+ " -R$ " + transform(AB7->AB7_CUSTOS+AB7->AB7_CUSUNI,"@e 999999.99")+" - C.Srv.R$" + transform(AB7->AB7_CUSUNI,"@e 999999.99"))
    ELSE
      cCabec:=Posicione("AB6",1,xFilial("AB6")+AB7->AB7_NUMOS,"AB6_NREDUZ")
      cVencOs:=Posicione("AB6",1,xFilial("AB6")+AB7->AB7_NUMOS,"AB6_VENCTO")
      cCabec:="Fn:" + RTRIM(cCabec)
      aAdd( aOs, cCabec   + " -QTD: " + transform(AB7->AB7_QTENT,"@e 9999") + " -R$ " + transform(AB7->AB7_CUSTOS+AB7->AB7_CUSUNI,"@e 999999.99") + " -OS/Item:" + AB7->AB7_NUMOS + "/" + AB7->AB7_ITEM +  " -Alm:" + AB7->AB7_ALMOX +  " -Pzo:" + dtoc(cVencOs)+" -C.Srv.R$" + transform(AB7->AB7_CUSUNI,"@e 999999.99"))
      //aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform(SD1->D1_TOTAL/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC + "/" + transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
    ENDIF
    dbSkip()
  EndDo
  if empty( aOsPend )
    aAdd( aOsPend , "" )
  endif
  oCombo63:aItems := aOsPend
//CARREGANDO ENTRADAS EFETUADAS
//cQuery	:= "SELECT PA1_FILIAL, PA1_ALTERN, B2_QPEDVEN, B2_SALPEDI, B2_RESERVA, B2_QATU, B2_QACLASS, B8_LOTECTL, B8_NUMLOTE, B8_SALDO, B8_CLIFOR, B8_LOTEFOR"
//cQuery	+= " FROM "+RetSqlName("PA1")+" PA1"
//cQuery	+= " INNER JOIN "+RetSqlName("SB2")+" SB2 ON B2_COD = PA1_ALTERN "
//cQuery	+= " INNER JOIN "+RetSqlName("SB8")+" SB8 ON B2_FILIAL = B8_FILIAL AND B8_PRODUTO = B2_COD AND B2_LOCAL =  B8_LOCAL"
//cQuery    += " LEFT OUTER JOIN " + RetSqlName("SF2") + " SF2 ON "
//Verifica todas as filiais
//cQuery	+= " WHERE PA1_PROD = '"+ALLTRIM(cProduto)+"'"
//cQuery	+= " AND PA1.D_E_L_E_T_ <> '*'"
//cQuery	+= " AND SB2.D_E_L_E_T_ <> '*'"
//cQuery	+= " AND SB8.D_E_L_E_T_ <> '*'"
//cQuery	+= "GROUP BY PA1_FILIAL, PA1_ALTERN, B2_QPEDVEN, B2_SALPEDI, B2_RESERVA, B2_QATU, B2_QACLASS, B8_LOTECTL, B8_NUMLOTE, B8_SALDO, B8_CLIFOR, B8_LOTEFOR"
  DbSelectArea("SF4")
  dbSetOrder(1)
// VERIFICA SE O CAMPO F4_RAPIDA TEM NO BANCO DE DADOS ATUAL
  If (FieldPos("F4_RAPIDA") > 0 )
    aHistent:={}
    cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET,SD1.D1_LOCAL,"
    cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_TIPO,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO,SF4.F4_RAPIDA,SF4.F4_CODIGO, SF4.F4_AGREG "
    cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 "+" INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_CODIGO = SD1.D1_TES WHERE "
    cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
    cQuerySD1 += "SD1.D1_LOCAL <> 'C1' AND "
    cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "
    cQuerySD1 += "SF4.F4_RAPIDA ='S' AND "
    cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_EMISSAO DESC FETCH FIRST " + substring(STRZERO(GETMV("MV_RAP002")),25,6) +" ROWS ONLY"
    //cQuery := ChangeQuery(cQuery)

  ELSE
    aHistent:={}
    cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_CUSTO,SD1.D1_TOTAL,SD1.D1_ICMSRET,SD1.D1_LOCAL,"
    cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_TIPO,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO "
    cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
    cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
    cQuerySD1 += "SD1.D1_LOCAL <> 'C1' AND "
    cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND "
    cQuerySD1 += "SD1.D1_TES IN ('006','101','10B','108','18H','18G','102','156','186','106','109','172','174','49Z','301','305','310','312','311','315','317','314','316' ) AND "
    cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_EMISSAO DESC FETCH FIRST " + substring(STRZERO(GETMV("MV_RAP002")),25,6) +" ROWS ONLY"
    //cQuery := ChangeQuery(cQuery)
  ENDIF

  If ( Select ("SD1") <> 0 )
    dbSelectArea ("SD1")
    dbCloseArea ()
  Endif
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.F.,.T.)
  dbSelectArea("SD1")

  nContador:=0
  While ( !Eof() .And. SD1->D1_COD == cCodigo .and. nContador<=GETMV("MV_RAP002") )
    If (FieldPos("F4_RAPIDA") > 0 )
      IF SD1->F4_AGREG='B'
      else
        IF trim(Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI"))=""
          IF SD1->D1_TIPO="D" .OR. SD1->D1_TIPO="R"
            cCliente:=Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_NREDUZ") + " -(DEV)- "
          ELSE
            cCliente:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NREDUZ")
          ENDIF
        ELSE
          cCliente:=Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI")
        ENDIF
        cCliente:="Fn:" + RTRIM(cCliente)
        cValCom:=if(Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_FOB_VL")>0,Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_FOB_VL"),Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_PRECO"))
        IF SD1->D1_TES $ "101"
          aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
          nContador:=nContador+1
        ELSE
          IF SD1->D1_TES = "106"
            aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
          ELSE
            IF SD1->D1_TES = "172"
              IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13")
                IF Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_VALFAB")=0
                  aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
                ELSE
                  nFatSc:=Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_VALFAB")/10000
                  aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)*nFatSc/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
                ENDIF

              ELSE
                IF Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_VALFAB")=0
                  aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100))/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
                ELSE
                  nFatSc:=Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_VALFAB")/10000
                  aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100))*nFatSc/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
                ENDIF
              ENDIF
            ELSE
              aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
            ENDIF
          ENDIF
          nContador:=nContador+1
        ENDIF
      ENDIF
      IF SD1->F4_AGREG='B'
        IF trim(Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI"))=""
          IF SD1->D1_TIPO="D" .OR. SD1->D1_TIPO="R"
            cCliente:=Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_NREDUZ")+  " -(DEV)- "
          ELSE
            cCliente:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NREDUZ")
          ENDIF
        ELSE
          cCliente:=Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI")
        ENDIF
        cCliente:="Fn:" + RTRIM(cCliente)
        cValCom:=Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_PRECO")
        aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform(SD1->D1_TOTAL/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC + "/" + transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
        nContador:=nContador+1
      ENDIF
    ELSE
      IF SD1->D1_TES $ "10B/301/305/310/312/311/315/317/314/316/318"
      else
        IF trim(Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI"))=""
          IF SD1->D1_TIPO="D" .OR. SD1->D1_TIPO="R"
            cCliente:=Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_NREDUZ") + " -(DEV)- "
          ELSE
            cCliente:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NREDUZ")
          ENDIF
        ELSE
          cCliente:=Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI")
        ENDIF
        cCliente:="Fn:" + RTRIM(cCliente)
        cValCom:=Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_PRECO")
        IF SD1->D1_TES $ "101"
          aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
          nContador:=nContador+1
        ELSE
          IF SD1->D1_TES = "106"
            aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_ICMSRET-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
          ELSE
            IF SD1->D1_TES = "172"
              IF CTOD(SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2))>=CTOD("20/08/13")
                aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
              ELSE
                aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL-SD1->D1_VALICM-(SD1->D1_TOTAL*9.25/100))/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
              ENDIF
            ELSE
              aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform((SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC+"/"+ transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
            ENDIF
          ENDIF
          nContador:=nContador+1
        ENDIF
      ENDIF
      IF SD1->D1_TES $ "10B/301/305/310/312/311/315/317/314/316/318"
        IF trim(Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI"))=""
          IF SD1->D1_TIPO="D" .OR. SD1->D1_TIPO="R"
            cCliente:=Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_NREDUZ")+  " -(DEV)- "
          ELSE
            cCliente:=Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NREDUZ")
          ENDIF
        ELSE
          cCliente:=Posicione("SF1",2,xFilial("SF1")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC,"F1_FORNORI")
        ENDIF
        cCliente:="Fn:" + RTRIM(cCliente)
        cValCom:=Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_PRECO")
        aAdd( aHistent, cCliente + " - QTD: " + transform(SD1->D1_QUANT,"@e 9999") + " -R$ " + transform(SD1->D1_TOTAL/SD1->D1_QUANT,"@e 999999.99") + "-Dt:" + SUBSTRING(SD1->D1_EMISSAO,7,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,5,2)+'/'+SUBSTRING(SD1->D1_EMISSAO,3,2) + "-OC/ITEM/VL: " + SD1->D1_PEDIDO + "/" + SD1->D1_ITEMPC + "/" + transform(cValcom,"@e 99999.99")+"-NF:"+SD1->D1_DOC+"/"+SD1->D1_ITEM)
        nContador:=nContador+1
      ENDIF
    ENDIF
    dbSkip()
  EndDo
  FOR K=1 TO LEN(aOs)
    aAdd( aHistent , aOs[K] )
  next
  if empty( aHistent )
    aAdd( aHistent , "" )
  endif

  oList87:aItems := aHistent
// CARREGANDO ORCAMENTO EFETUADOS
  aHistOrc:={}
  nContador:=0
  cQuerySCK := "SELECT SCK.CK_NUM,SCK.CK_ITEM,SCK.CK_PRODUTO,SCK.CK_QTDVEN,SCK.CK_CLIENTE,SCK.CK_LOJA,"
  cQuerySCK += "SCK.CK_PRCVEN,SCK.CK_NUMPV,SCK.CK_DTVALID FROM " + RetSqlName("SCK")+ " SCK "
  cQuerySCK += "WHERE "
  cQuerySCK += "SCK.CK_FILIAL = '"+xFilial("SCK")+"' AND "
  cQuerySCK += "SCK.CK_PRODUTO = '"+cCodigo+"' AND "
  cQuerySCK += "SCK.D_E_L_E_T_=' ' AND SCK.CK_NUMPV='      ' AND SCK.CK_NUM>='000001' AND SCK.CK_NUM<='999999'  ORDER BY SCK.CK_NUM DESC FETCH FIRST " + substring(STRZERO(GETMV("MV_RAP003")),25,6) +" ROWS ONLY"
//cQuery := ChangeQuery(cQuery)
  If ( Select ( cAliasSck ) <> 0 )
    dbSelectArea ( cAliasSck )
    dbCloseArea ()
  Endif
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySCK),cAliasSCK,.F.,.T.)
  dbSelectArea(cAliasSCK)
/*
DbSelectArea("SCK")
dbSetOrder(3)
MsSeek(xfilial("SCK")+cCodigo)
*/
  While ( !Eof() .And. SCK->CK_PRODUTO == cCodigo .and. nContador<=GETMV("MV_RAP003") )
    if cCli="      "
      cCliente:=Posicione("SA1",1,xFilial("SA1")+SCK->CK_CLIENTE+SCK->CK_LOJA,"A1_NREDUZ")
      cTpOrc22:=Posicione("SCJ",1,xFilial("SCJ")+SCK->CK_NUM,"CJ_CLASSI")
      If ctporc22="1"
        cTpOrc23:="Ct-"
      else
        if cTpOrc22="2"
          cTpOrc23:="Pj-"
        else
          cTpOrc23:="Cp-"
          if Posicione("SCJ",1,xFilial("SCJ")+SCK->CK_NUM,"CJ_VALIDA")>=DATE()
            nOrcPen:=nOrcPen+SCK->CK_QTDVEN
          endif
        endif
      ENDIF
      cCliente:=" - Cl: " + RTRIM(cCliente)
      aAdd( aHistOrc, cTpOrc23+  "Orc/It:" + SCK->CK_NUM + "/" + SCK->CK_ITEM + cCliente + " - QTD: " + transform(SCK->CK_QTDVEN,"@e 9999") + " -R$ " + transform(SCK->CK_PRCVEN,"@e 9,999,999.99"))
      IF cTpOrc23="Cp-"
      else
        nContador:=nContador+1
      endif
    else
      if cCli=SCK->CK_CLIENTE
        cCliente:=Posicione("SA1",1,xFilial("SA1")+SCK->CK_CLIENTE+SCK->CK_LOJA,"A1_NREDUZ")
        cTpOrc22:=Posicione("SCJ",1,xFilial("SCJ")+SCK->CK_NUM,"CJ_CLASSI")
        If ctporc22="1"
          cTpOrc23:="Ct-"
        else
          if cTpOrc22="2"
            cTpOrc23:="Pj-"
          else
            cTpOrc23:="Cp-"
            if Posicione("SCJ",1,xFilial("SCJ")+SCK->CK_NUM,"CJ_VALIDA")>=DATE()
              nOrcPen:=nOrcPen+SCK->CK_QTDVEN
            endif
          endif
        ENDIF
        cCliente:=" - Cl: " + RTRIM(cCliente)
        aAdd( aHistOrc,cTpOrc23+ "Orc/It:" + SCK->CK_NUM + "/" + SCK->CK_ITEM + cCliente + " - QTD: " + transform(SCK->CK_QTDVEN,"@e 9999") + " -R$ " + transform(SCK->CK_PRCVEN,"@e 9,999,999.99"))
        IF cTpOrc23="Cp-"
        else
          nContador:=nContador+1
        endif
      ENDIF
    ENDIF
    dbSkip()
  EndDo
  if empty( aHistOrc )
    aAdd( aHistOrc , "" )
  endif

// CARREGAMDO LOTES VALIDADOS
  DbSelectArea("SZI")
  dbSetOrder(4)
  aFornQual:={}
  MsSeek(xfilial("SZI")+cCodigo)
  While ( !Eof() .And. SZI->ZI_COD = cCodigo)
    IF SZI->ZI_FORNECE='VALIDA'
      // Identificando o fornecedor origem do Lote Validado
      //cLtForn:=Posicione("SA2",1,xFilial("SA2")+SZI->ZI_FABRIC+SZI->ZI_LOFAB,"A2_NREDUZ")
      // Buscando o Saldo do Lote Validado
      cLtQuant:=0
      cLtCusto:=0
      DbSelectArea("SB8")
      dbSetOrder(1)
      MsSeek(xfilial("SB8")+SZI->ZI_COD)
      While ( !Eof() .And. SB8->B8_PRODUTO = cCodigo)
        IF SZI->ZI_ALMOX=SB8->B8_LOCAL .AND. SZI->ZI_RIDENT=SB8->B8_LOTECTL
          cLtQuant:=SB8->B8_SALDO
        ENDIF
        DBSKIP()
      ENDDO
      // carregando custos do lote selecionado
      cLtCusto:=cLtCusto+Posicione("AB7",1,xFilial("AB7")+SZI->ZI_COMPRA+SUBSTR(SZI->ZI_ITEM,1,2),"AB7_CUSTOS")
      if SZI->ZI_CUSTO>0
        cLtCusto:=cLtCusto+(SZI->ZI_CUSTO/SZI->ZI_QTD)
      ENDIF
      IF cCli<>'000503'
        aAdd( aFornQual, SZI->ZI_RI + " -SD:" + trim(transform(cLtQuant,"@e 9999"))+ "-Fn:" + trim(SZI->ZI_FBREDUZ) + "-("+SZI->ZI_QUALIF+") CT:R$"+ transform(cLtCusto,"@e 99,999.99"))
        nEstFis:=nEstFis-cLtQuant
      else
        // Carregando na lista o Lote Validado
        aAdd( aFornQual, SZI->ZI_RI + " -SD:" + trim(transform(cLtQuant,"@e 9999"))+ "-Fn:" + trim(SZI->ZI_FBREDUZ) + "-("+SZI->ZI_QUALIF+") CT:R$"+ transform(cLtCusto,"@e 99,999.99"))
        ccusto:=cLtCusto
      endif
    ENDIF
    DbSelectArea("SZI")
    dbSkip()
  EndDo
  if empty( aFornQual)
    aAdd( aFornQual , "" )
  endif
  oList86:aItems := aFornQual
// FIM DA LISTA DE LOTES VALIDOS





// ABATENDO DAS COMPRRAS PENDENTES AS COMPRAS CASADAS E ATUALIZANDO SALDOS EM ESTOQUE
  if nSdoCas>0
    nEstVir:=nEstVir-nSdoCas
    nCasada:=nSdoCas
    // CUIDADO COM ESTA OPERACAO, O INVENTARIO PODE FICAR DOIDO
    nEstFis:=nEstFis+nSdoCas
  endif
  oList88:aItems := aHistOrc
  DbSelectArea("SB7")
  IF cPaisLoc="BRA"
    dbSetOrder(5)
  ELSE
    dbSetOrder(4)
  ENDIF
  MsSeek(xfilial("SB7")+cCodigo)
  DO WHILE SB7->B7_COD == cCodigo  .AND. !EOF()
    DBSKIP()
  ENDDO
  DBSKIP(-1)
  IF ( !Eof() .And. SB7->B7_COD == cCodigo .AND. SB7->B7_DATA>= CTOD("01/02/2017"))
    oBmp1:lVisibleControl := .t.
    oBmp1:cBmpFile := "\Imagens\ico-bien.bmp"
    cDtInv:= RTRIM(dtoc(SB7->B7_DATA))
  ELSE
    oBmp1:lVisibleControl := .t.
    oBmp1:cBmpFile := "\Imagens\mal.bmp"
    cDtInv:=RTRIM("")
  ENDIF
  nScompra:=cPP-nEstfis-nEstvir
  if nScompra<0
    nScompra:=0
  endif
// CARREGANDO TABELAS DE PRECO
  aTbPr:={}
  cQueryAIB := "SELECT AIB.AIB_CODFOR,AIB.AIB_LOJFOR,AIB.AIB_CODTAB,AIB.AIB_ITEM,AIB.AIB_CODPRO,AIB.AIB_PRCCOM,"
  cQueryAIB += "AIB.AIB_XCHEIO,AIB.AIB_QTDLOT,AIB.AIB_DATVIG FROM " + RetSqlName("AIB")+ " AIB "
  cQueryAIB += "WHERE "
  cQueryAIB += "AIB.AIB_FILIAL = '"+xFilial("AIB")+"' AND "
  cQueryAIB += "AIB.AIB_CODPRO = '"+cCodigo+"'  AND "
  cQueryAIB += "AIB.D_E_L_E_T_=' '"
//cQuery := ChangeQuery(cQuery)
  If ( Select ("QAIB") <> 0 )
    dbSelectArea ("QAIB")
    dbCloseArea ()
  Endif
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryAIB),"QAIB",.F.,.T.)
  dbSelectArea("QAIB")
  While ( !Eof() .And. QAIB->AIB_CODPRO == cCodigo)
    // CARREGANDO VIGENCIA E FATORES
    DbSelectArea("AIA")
    dbSetOrder(1)
    If AIA->(DbSeek(xFilial("AIA")+QAIB->AIB_CODFOR+QAIB->AIB_LOJFOR+QAIB->AIB_CODTAB))
      if AIA->AIA_DATATE>=DATE()
        cFornece:=Posicione("SA2",1,xFilial("SA2")+QAIB->AIB_CODFOR+QAIB->AIB_LOJFOR,"A2_NREDUZ")
        aAdd(aTbPr,trim(AIA->AIA_DESCRI)+":"+"R$ " + transform(QAIB->AIB_PRCCOM*AIA->AIA_XCUSTO,"@E 99999.99") + "-Ct:"+ transform(QAIB->AIB_PRCCOM,"@E 99999.99"))
      ENDIF
    ENDIF
    dbSelectArea("QAIB")
    dbSkip()
  EndDo
  if empty( aTbPr )
    aAdd( aTbPr , "" )
  endif
  oList866:aItems := aTbPr
// CARREGANDO LOTES DO SISTEMA




// LIMPANDO MEMORIA DO SISTEMA
  If ( Select ("SD1") <> 0 )
    dbSelectArea ("SD1")
    dbCloseArea ()
  Endif
  If ( Select ("SB1") <> 0 )
    dbSelectArea ("SB1")
    dbCloseArea ()
  Endif
  If ( Select ("SB2") <> 0 )
    dbSelectArea ("SB2")
    dbCloseArea ()
  Endif
  If ( Select ("SC6") <> 0 )
    dbSelectArea ("SC6")
    dbCloseArea ()
  Endif
  If ( Select ("SCK") <> 0 )
    dbSelectArea ("SCK")
    dbCloseArea ()
  Endif
  If ( Select ("SB7") <> 0 )
    dbSelectArea ("SB7")
    dbCloseArea ()
  Endif
  If ( Select ("SC7") <> 0 )
    dbSelectArea ("SC7")
    dbCloseArea ()
  Endif
  If ( Select ("SM2") <> 0 )
    dbSelectArea ("SM2")
    dbCloseArea ()
  Endif
  If ( Select ("AB7") <> 0 )
    dbSelectArea ("AB7")
    dbCloseArea ()
  Endif
  If ( Select ("QSC6") <> 0 )
    dbSelectArea ("QSC6")
    dbCloseArea ()
  Endif
  If ( Select ("SB6") <> 0 )
    dbSelectArea ("SB6")
    dbCloseArea ()
  Endif
  If ( Select ("PA1") <> 0 )
    dbSelectArea ("PA1")
    dbCloseArea ()
  Endif
  If ( Select ("SA5") <> 0 )
    dbSelectArea ("SA5")
    dbCloseArea ()
  Endif
  If ( Select ("SA2") <> 0 )
    dbSelectArea ("SA2")
    dbCloseArea ()
  Endif
//atualizando a tela

  IF cCodOrig!=nil
    oSBtn90:setfocus()
    cCodOrig:=nil
  else
//   cCli00:setfocus()
  endif
  nEstFis:= round(nEstFis,2)
  U_HCMARGEM()
  oDlg:REFRESH()
  IF lblock=.t.
    MsgInfo("O codigo do produto digitado esta bloqueado (inexistente ou em duplicidade). Os dados fornecidos nao subsidiam transacoes...", "Inconsistencia")
  else
    // gerando o registro de eventos da consulta rapida
    IF cPaisLoc="BRA"
      DbSelectArea("PR1")
      dbSetOrder(01)
      Begin Transaction
        RecLock("PR1",.T.)
        PR1->PR1_FILIAL := xFilial("PR1")
        PR1->PR1_RASTRO := SUBSTR(STRZERO(PR1->(RECCOUNT())+1),21,10)
        cRastro:=SUBSTR(STRZERO(PR1->(RECCOUNT())+1),21,10)
        PR1->PR1_DATA   := dDataBase
        PR1->PR1_HORA   := StrTran(Time(),":")
        PR1->PR1_HORAI  := cHoraIni
        PR1->PR1_CODIGO := cCodigo
        PR1->PR1_DESCRI := cDescr
        PR1->PR1_CLIENT := cCli
        PR1->PR1_LOJA   := cLoja
        PR1->PR1_CUSTO  := cCusto
        PR1->PR1_CUSTO2 := cMed2
        PR1->PR1_CUSTO3 := 0
        PR1->PR1_EST    := nEstfis
        PR1->PR1_QTD    := cQtdVd
        PR1->PR1_AGENTE := Substr(UsrRetName(__cUserId),1,15)
        PR1->PR1_CAGENT := __cUserId
        // PR1->PR1_ORIGEM := cTipov
        MsUnlock("PR1")
      End Transaction
      If ( Select ("PR1") <> 0 )
        dbSelectArea ("PR1")
        dbCloseArea ()
      Endif
    endif
    cQtdVd:=1
  endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCAvanc  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Avancada                       				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HCAVANC()
  Local aAreaAtu	:= GetArea()
  Local cQuery    := ""
  Local lQuery    := .F.
  Local CCodigoz  :=cCodigo
  Local aPtc      :={}
  Local aPtf      :={}
  Local nSaltos   :=0
  Local nPosi     :=1
  Local cEstAv
  Local cEstCom
  Local cFinal
  Local nRegSb1   :=0
  Static nCasados:=0
//oSBtn4:lVisibleControl := .f. 
//oDlg:REFRESH()
  if cCodigo<>"              "
    CursorWait()
    IF cPaisLoc="BRA"
      DbSelectArea("PR1")
      dbSetOrder(01)
      IF MsSeek(xFilial("PR1")+cRastro)
        Begin Transaction
          RecLock("PR1",.F.)
          PR1->PR1_HORAI  := StrTran(Time(),":")
          MsUnlock("PR1")
        End Transaction
        If ( Select ("PR1") <> 0 )
          dbSelectArea ("PR1")
          dbCloseArea ()
        Endif
      ENDIF
    ENDIF
    //ACRESCENTANDO OS DESVIOS NA CONSULTA
    nFinal:=0
    cFinal:=substr(cCodigoz,len(trim(cCodigoz))-2,3)
    cFinal:=cFinal+"            "
    DbSelectArea("PA1")
    dbSetOrder(1)
    aAlterna:={}
    MsSeek(xfilial("PA1")+cFinal)
    if (!Eof() .And. PA1->PA1_PROD == cFinal )
      aAdd(aPtf,PA1->PA1_PROD)
      nFinal:=nFinal+1
      While ( !Eof() .And. PA1->PA1_PROD == cFinal )
        aAdd(aPtf,PA1->PA1_ALTERN)
        nFinal:=nFinal+1
        DbSkip()
      enddo
    endif
    if nFinal<>0
      cCodigoz:=substr(cCodigoz,1,len(trim(cCodigoz))-3)
    endif  
    aAvancada:={}
    for x=1 to len(trim(cCodigoz))
      if substr(cCodigo,x,1)="*"
        aAdd(aPtc, substr(cCodigoz,nPosi,x-nposi))
        nPosi:=x+1
      endif
    next
    aAdd(aPtc, substr(cCodigoz,nPosi,x-NPOSI))
    cQuery := "SELECT SB1.B1_COD,SB1.B1_DESC FROM "
    cQuery += "" + RetSqlName("SB1")+ " SB1  "
    cQuery += "WHERE "
    cQuery += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
    //cQuery += "SB1.B1_TIPO = 'PA' AND "
    cQuery += "SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL<>'1'"
    IF lCheckBo1=.T.
      cQuery += "AND SB1.B1_CONINI<>'       '"
    endif
    for x=1 to len(aPtc)
      if x=1
        cQuery += " AND SB1.B1_COD LIKE '%" + aPtc[x] + "%"
      else
        cQuery += aPtc[x] + "%"
      endif
    next
      IF X=1
      cQuery += " AND SB1.B1_COD='" + cCodigoz + "'"
    ELSE
      cQuery += "'"
    ENDIF
    for Y=1 to len(aPtf)
      if y=1
        cQuery += " AND (SB1.B1_COD LIKE '%" + trim(aPtf[y]) + "%'"
      else
        cQuery += " OR SB1.B1_COD LIKE '%" + trim(aPtf[y]) + "%'"
      endif
    next
    if len(aPtf)<>0
      cQuery +=")"
    endif
    //cQuery := ChangeQuery(cQuery)
    if ( Select ("QYSB1") <> 0 )
      dbSelectArea ("QYSB1")
      dbCloseArea ()
    ENDIF
    dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QYSB1",.F.,.T.)
    dbSelectArea("QYSB1")
    nRegSb1:=0
    While !Eof()
      DbSkip()
      nRegSb1:=nRegSb1+1
    enddo
    QYSB1->(dbGoTop())
    if nRegSb1>100
      If MsgYesNo("Atencao, Pesquisa muito longa, sao ("+ strzero(nRegSb1,6) + ") registros. Deseja prosseguir ?","Sobrecarga")
        CursorWait()
        While !Eof()
          nCasados:=0
          cEstAv:=transform(U_SALRAP(QYSB1->B1_COD),"@e 99999.99")
          cEstCom:=transform(U_SALRA2(QYSB1->B1_COD),"@e 99999.99")
          dbSelectArea("QYSB1")
          nspaco1:=20-len("COD: " + QYSB1->B1_COD)
          nspaco2:=20-len("Desc: " + QYSB1->B1_DESC)
          IF lCheckBo1=.T.
            IF VAL(cEstAv)<>0 .or. VAL(cEstCom)<>0
              aAdd( aAvancada, "COD: " + QYSB1->B1_COD + /*SPACE(NSPACO1) +*/ "  DESCR: " + TRIM(QYSB1->B1_DESC) +/* SPACE(NSPACO2)+*/ " - ED.:" + cEstAV + " - SCE.:"+cEstcom)
            ENDIF
          ELSE
            aAdd( aAvancada, "COD: " + QYSB1->B1_COD + /*SPACE(NSPACO1) +*/ "  DESCR: " + TRIM(QYSB1->B1_DESC) +/* SPACE(NSPACO2)+*/ " - ED.:" + cEstAV + " - SCE.:"+cEstcom)
          ENDIF
          DbSkip()
        enddo
        dbSelectArea("QYSB1")
        dbCloseArea()
        if empty( aAvancada )
          aAdd( aAvancada, "" )
        endif
        oCombo3:aItems := aAvancada
      endif
    else
      While !Eof()
        nCasados:=0
        cEstAv:=transform(U_SALRAP(QYSB1->B1_COD),"@e 99999.99")
        cEstCom:=transform(U_SALRA2(QYSB1->B1_COD),"@e 99999.99")
        dbSelectArea("QYSB1")
        nspaco1:=20-len("COD: " + QYSB1->B1_COD)
        nspaco2:=20-len("Desc: " + QYSB1->B1_DESC)
        IF lCheckBo1=.T.
          IF VAL(cEstAv)<>0 .or. VAL(cEstCom)<>0
            aAdd( aAvancada, "COD: " + QYSB1->B1_COD + /*SPACE(NSPACO1) +*/ "  DESCR: " + TRIM(QYSB1->B1_DESC) +/* SPACE(NSPACO2)+*/ " - ED.:" + cEstAV + " - SCE.:"+cEstcom)
          ENDIF
        ELSE
          aAdd( aAvancada, "COD: " + QYSB1->B1_COD + /*SPACE(NSPACO1) +*/ "  DESCR: " + TRIM(QYSB1->B1_DESC) +/* SPACE(NSPACO2)+*/ " - ED.:" + cEstAV + " - SCE.:"+cEstcom)
        ENDIF
        DbSkip()
      enddo
      dbSelectArea("QYSB1")
      dbCloseArea()
      if empty( aAvancada )
        aAdd( aAvancada, "" )
      endif
      oCombo3:aItems := aAvancada
    endif
    if ( Select ("QYSB1") <> 0 )
      dbSelectArea ("QYSB1")
      dbCloseArea ()
    ENDIF
    IF cPaisLoc="BRA"
      DbSelectArea("PR1")
      dbSetOrder(01)
      IF MsSeek(xFilial("PR1")+cRastro)
        Begin Transaction
          RecLock("PR1",.F.)
          PR1->PR1_HORA  := StrTran(Time(),":")
          MsUnlock("PR1")
        End Transaction
        If ( Select ("PR1") <> 0 )
          dbSelectArea ("PR1")
          dbCloseArea ()
        Endif
      ENDIF
    ENDIF
    CursorArrow()
    //oSBtn4:lVisibleControl := .t.
    //oDlg:REFRESH()
  endif
  RestArea(aAreaAtu)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ salrap() ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SALRAP(cProd)

  Local aAreaAtu	:= GetArea()
  Local nSaldo:=0
  Local cQueSC6
  Local cAm1
  Local cAm2
  Local cAm3
  Local cAm4
  lOCAL cAm5
  Local cAm6
  Local cIndice
  Local cPedRef
  nCasados:=0
//carregando saldo real do produto
  DbSelectArea("SB2")
  dbSetOrder(1)
  MsSeek(xfilial("SB2")+cProd)
  While ( !Eof() .And. SB2->B2_COD == cProd )
    IF SB2->B2_STATUS<>"2"
      nSaldo:=nSaldo+SB2->B2_QATU+SB2->B2_QNPT
    ENDIF
    dbSkip()
  EndDo

//
//DbSelectArea("SC6")
//dbSetOrder(11)
//MsSeek(xfilial("SC6")+cProd)

//cQueSC6 := "SELECT SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_CLI,SC6.C6_LOJA,SC6.C6_LOCAL," 
//cQueSC6 += "SC6.C6_PRCVEN,SC6.C6_ENTREG,SC6.C6_NOTA,SC6.C6_DATFAT FROM " + RetSqlName("SC6")+ " SC6 " 
//cQueSC6 += "WHERE "
//cQueSC6 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
//cQueSC6 += "SC6.C6_PRODUTO = '"+cProd+"' AND "
//cQueSc6 += "SC6.C6_QTDVEN-SC6.C6_QTDENT>0 AND "
//cQueSC6 += "SC6.D_E_L_E_T_=' ' ORDER BY SC6.C6_ENTREG DESC"

  cQueSC6 := "SELECT SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_QTDVEN,SC6.C6_QTDENT FROM " + RetSqlName("SC6")+ " SC6 "
  cQueSC6 += "WHERE "
  cQueSC6 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
  cQueSC6 += "SC6.C6_PRODUTO = '"+cProd+"' AND "
  cQueSc6 += "SC6.C6_QTDVEN-SC6.C6_QTDENT>0 AND "
  cQueSC6 += "SC6.D_E_L_E_T_=' '"

//cQueSC6:= "SELECT SC6.C6_PRODUTO, SC6.C6_SALDO FROM SC6TCOD2 SC6 "
//cQueSC6 += "WHERE "
//cQueSC6 += "SC6.C6_PRODUTO = '"+cProd+"' AND "
//cQueSc6 += "SC6.C6_SALDO>0"

  If ( Select ("QSC6") <> 0 )
    dbSelectArea ("QSC6")
    dbCloseArea ()
  Endif
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueSC6),"QSC6",.F.,.T.)
  dbSelectArea("QSC6")
  While ( !Eof() .And. QSC6->C6_PRODUTO == cProd )
    if Posicione("SF4",1,xFilial("SF4")+QSC6->C6_TES,"F4_DUPLIC")="S".OR. SUBSTR(QSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QSC6->C6_NUM,1,1)="D" .OR. SUBSTR(QSC6->C6_NUM,1,1)="T" .OR. SUBSTR(QSC6->C6_NUM,1,1)="R" .OR. SUBSTR(QSC6->C6_NUM,1,1)="A" .OR. QSC6->C6_TES="514" .OR. QSC6->C6_TES="999" .OR. QSC6->C6_TES="693" .OR. QSC6->C6_TES="553" .OR. QSC6->C6_TES="592" .OR. QSC6->C6_TES="556" .OR. QSC6->C6_TES="591"
      nsaldo:=nSaldo-(QSC6->C6_QTDVEN-QSC6->C6_QTDENT)
      // rotina nova
      IF SUBSTR(QSC6->C6_NUM,1,1)="B"
        cIndice:="OS"
        cPedRef:="0"+SUBSTR(QSC6->C6_NUM,2,5)
      ELSE
        cIndice:="PV"
        cPedRef:=QSC6->C6_NUM
      ENDIF
      IF QSC6->C6_QTDVEN-QSC6->C6_QTDENT>0
        DbSelectArea("SZK")
        dbSetOrder(1)
        //if Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM,"ZK_OC")<>"      "
        IF MsSeek(xfilial("SZK")+cIndice+cPedRef+QSC6->C6_ITEM)
          cAm1:=SZK->ZK_OC
          cAm2:=SZK->ZK_ITEM
          cAm3:=SZK->ZK_FORN
          cAm4:=SZK->ZK_TIPO2
          cAm5:=SZK->ZK_STATUS
          cAm6:=SZK->ZK_QTS
          dbSelectArea("QSC6")
          IF cAm5<>"4" .AND. cAm4="OC"
            nCasados:=nCasados + cAm6
            nSaldo:=nSaldo+cAm6
          ENDIF
          IF cAm5<>"4" .AND. cAm4="OS"
            IF cAm6>0 .AND. cAm6>QSC6->C6_QTDVEN-QSC6->C6_QTDENT
              nSaldo:=nSaldo+QSC6->C6_QTDVEN-QSC6->C6_QTDENT
            else
              nSaldo:=nSaldo+cAm6
            endif
          endif
        endif
      endif
    ENDIF
    dbSelectArea("QSC6")
    dbSkip()
  EndDo
  DBSELECTAREA("SB6")
  DBSETORDER(1)
  If SB6->(DbSeek(xFilial("SB6")+cProd))
    While xFilial("SB6") == SB6->B6_FILIAL .and. ! SZB->(Eof()) .and. SB6->B6_PRODUTO == cProd
      if SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="E" .and. SB6->B6_CLIFOR<>'000090' .AND. SB6->B6_CLIFOR<>'000001'
        nSALDO:=nSALDO-SB6->B6_SALDO
      ENDIF
      SB6->(DbSkip())
    EndDo
  ENDIF
// LIMPANDO MEMORIA DO SISTEMA
  If ( Select ("SD1") <> 0 )
    dbSelectArea ("SD1")
    dbCloseArea ()
  Endif
  If ( Select ("SB1") <> 0 )
    dbSelectArea ("SB1")
    dbCloseArea ()
  Endif
  If ( Select ("SB2") <> 0 )
    dbSelectArea ("SB2")
    dbCloseArea ()
  Endif
  If ( Select ("SC6") <> 0 )
    dbSelectArea ("SC6")
    dbCloseArea ()
  Endif
  If ( Select ("SCK") <> 0 )
    dbSelectArea ("SCK")
    dbCloseArea ()
  Endif
  If ( Select ("SB7") <> 0 )
    dbSelectArea ("SB7")
    dbCloseArea ()
  Endif
  If ( Select ("SC7") <> 0 )
    dbSelectArea ("SC7")
    dbCloseArea ()
  Endif
  If ( Select ("SM2") <> 0 )
    dbSelectArea ("SM2")
    dbCloseArea ()
  Endif
  If ( Select ("AB7") <> 0 )
    dbSelectArea ("AB7")
    dbCloseArea ()
  Endif
  If ( Select ("QSC6") <> 0 )
    dbSelectArea ("QSC6")
    dbCloseArea ()
  Endif
  If ( Select ("SB6") <> 0 )
    dbSelectArea ("SB6")
    dbCloseArea ()
  Endif
  If ( Select ("PA1") <> 0 )
    dbSelectArea ("PA1")
    dbCloseArea ()
  Endif
  If ( Select ("SA5") <> 0 )
    dbSelectArea ("SA5")
    dbCloseArea ()
  Endif
  If ( Select ("SA2") <> 0 )
    dbSelectArea ("SA2")
    dbCloseArea ()
  endif
  RestArea(aAreaAtu)
Return (nSaldo)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ salra2() ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SALRA2(cProd)
  Local aAreaAtu	:= GetArea()
  Local nEntradas:=0
  Local cQueSC7
//carregando saldo real do produto
  DbSelectArea("SC7")
  dbSetOrder(7)
  MsSeek(xfilial("SC7")+cProd)
  While ( !Eof() .And. SC7->C7_PRODUTO == cProd)
    if SC7->C7_TES<>'49Z'
      nEntradas:=nEntradas+(SC7->C7_QUANT-SC7->C7_QUJE)
    ENDIF
    dbSkip()
  EndDo
  RestArea(aAreaAtu)
Return (nEntradas-nCasados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPPV()  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPPV()
  Local cConPed:=SUBSTR(cboVentr,7,6)
  if cTipov<>"SC5"
    If MsgYesNo("Deseja realmente abrir Processo de Venda n. "+ cConPed + " ?","Automacao de Processo")
      dbSelectArea("SC5")
      dbSetOrder(1)
      MsSeek(xFilial("SC5")+cConPed)
      A410Visual("SC5",RECNO(),2)
    endif
  ENDIF
  oGet38:SETFOCUS()
  oDlg:REFRESH()
  oCombo66:lReadOnly:=.F.
  oCombo63:lReadOnly:=.F.
  oCombo59:lReadOnly:=.F.

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPVIN() ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RAPVIN()
  Local cVdPed:=""
  Local cVdIt :=""
  Local cOcPed:=""
  Local cOcIt :=""
  Local lPode :=.t.
  // primeiro passo ver se a Combo Oc Pendente tem informacao
  if len(cboPoc)=0 .or. len(cboPvend)=0
    MsgInfo("Nao ha selecoes para que se torne possivel a amarracao do PV x Oc ...", "Processo finalizado")
  else
    cOcPed  :=SUBSTR(cboPoc,9,6)
    cOcIt   :=SUBSTR(cboPoc,17,3)
    cVdPed  :=SUBSTR(cboPvend,7,6)
    cVdIt   :=SUBSTR(cboPvend,14,2)
    // 2o passo - verificar se a compra tem saldo a vincular 
      // a extrair a quantidade da compra 

      // somar as quantidades vinculadas a oc para verificar se e possivel ter saldo a empenhar na venda 

    // 3o passo - verificar se a venda ja nao esta vinculada 
    // 4o passo - varificar se e parcial ou total da venda
    // 5o passo - verificar se e parcial ou total da oc
    // 6o passo - vincular o PV com a OC
    If lPode  // PARADA DE ROTINA .... NAO VALIDA DE JEITO NENHUM
      FOR nLin:=1 to len(ACOLOCPV)
        IF ACOLOCPV[nLin,10]="MAN" .OR. ACOLOCPV[nLin,7]>0
          dbSelectArea("SZK")
          DbSetOrder(4)
          IF MsSeek(xFilial("SZK")+"OC"+cC7num+substr(cC7Item,2,3)+"PV"+ACOLOCPV[nLin,2]+ACOLOCPV[nLin,3])
            Reclock("SZK",.F.)
          ELSE
            Reclock("SZK",.T.)
            SZK->ZK_DT_VINC:=date()          		   		// DATA DA VINCULACAO
          ENDIF
          SZK->ZK_FILIAL :=xfilial("SZK")
          SZK->ZK_TIPO   :="PV"                       	// TIPO
          SZK->ZK_REF    :=ACOLOCPV[nLin,2]           	// PEDIDO
          SZK->ZK_REFITEM:=ACOLOCPV[nLin,3]           	// ITEM PEDIDO
          SZK->ZK_NOME   :=ACOLOCPV[nLin,4]           	// CLIENTE
          SZK->ZK_COD    :=ACOLOCPV[nLin,9]            // CODIGO PRODUTO
          SZK->ZK_DESCRI :=ACOLOCPV[nLin,10]          	// DESCRICAO
          SZK->ZK_QTD    :=ACOLOCPV[nLin,5]           	// QUANTIDADE VENDA
          SZK->ZK_PRAZO  :=ACOLOCPV[nLin,6] 	         	// PRAZO VENDA
          SZK->ZK_TIPO2  :="OC"            	         	// TIPO2
          SZK->ZK_OC     :=cC7num			              	// NUMERO OS
          SZK->ZK_ITEM   :=substr(cC7Item,2,3)        	// ITEM OS
          SZK->ZK_FORN   :=cC7Nfor   			          	// FORNECEDOR
          SZK->ZK_QTC    :=ACOLOCPV[nLin,7]  	       	// QUANTIDADE CASADA
          SZK->ZK_PRAZOC :=dC7Prz			              	// PRAZO ENTRADA
          IF ACOLOCPV[nLin,8]=0
            SZK->ZK_QTS    :=0                     	   // QUANTIDADE PENDENTE
            SZK->ZK_DT_BX  :=DATE()
            SZK->ZK_STATUS :="4"							          // STATUS DA OS
          ELSE
            SZK->ZK_QTS    :=ACOLOCPV[nLin,8]         	// QUANTIDADE PENDENTE
            SZK->ZK_STATUS :="1"
          ENDIF
          SZK->ZK_CONTROL:="RAP"							// METODO
          MsUnLock()
        ENDIF
        dbSelectArea("SZK")
      next
    ENDIF
    
    
    // 7o Passo - Recarregar a Consulta Rapida



  endif


return .t.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPPV()  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPPV1(cPedV)
  Local cAvalia:=cPedV
  Local cConPed:=SUBSTR(cboPvend,7,6)
  if cTipov<>"SC5"
    if cAvalia<>""
      dbSelectArea("SC5")
      dbSetOrder(1)
      MsSeek(xFilial("SC5")+cAvalia)
      A410Visual("SC5",RECNO(),2)
    else
      If MsgYesNo("Deseja realmente abrir Processo de Venda n. "+ cConPed + " ?","Automacao de Processo")
        dbSelectArea("SC5")
        dbSetOrder(1)
        MsSeek(xFilial("SC5")+cConPed)
        A410Visual("SC5",RECNO(),2)
      endif
    endif
  ENDIF

  oGet38:SETFOCUS()
  oDlg:REFRESH()
  oCombo67:lReadOnly:=.F.
  oCombo63:lReadOnly:=.F.
  oCombo59:lReadOnly:=.F.

return .T.

User Function RAPTR(cOrigem)
  if cOrigem="VN"
    oCombo67:lReadOnly:=.T.
    oCombo63:lReadOnly:=.T.
    oCombo59:lReadOnly:=.T.
  ELSE
    IF cOrigem="VE"
      oCombo66:lReadOnly:=.T.
      oCombo63:lReadOnly:=.T.
      oCombo59:lReadOnly:=.T.
    ELSE
      IF cOrigem="OC"
        oCombo66:lReadOnly:=.T.
        oCombo63:lReadOnly:=.T.
        oCombo67:lReadOnly:=.T.
      ELSE
        oCombo66:lReadOnly:=.T.
        oCombo59:lReadOnly:=.T.
        oCombo67:lReadOnly:=.T.
      ENDIF
    ENDIF
  ENDIF
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPPV()  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPOC(nOpcao)

  Local cConPed:=SUBSTR(cboPoc,9,6)
  Local cCodIt:=SUBSTR(cboPoc,16,4)
  DbSelectArea("SC7")
  dbSetOrder(1)
  MsSeek(xfilial("SC7")+cConped+cCodIt)
  if nOpcao==1
    IF ( !Eof() .And. SC7->C7_NUM == cCONPED .AND. SC7->C7_item=cCodIt)
      cCusto:=0
      cMed2:=0
      cIc001:=0
      cIc002:=0
      cIc003:=0
      cIc071:=0
      cIc072:=0
      cIc073:=0
      cIc121:=0
      cIc122:=0
      cIc123:=0
      cIc181:=0
      cIc182:=0
      cIc183:=0
      cIc041:=0
      cIc042:=0
      cIc043:=0

      IF SC7->C7_TES $ "101/102/156/108"
        IF SC7->C7_TES = "101"
          cCusto:=SC7->C7_PRECO-(SC7->C7_VALICM/SC7->C7_QUANT)-(SC7->C7_PRECO*0.0925)
        ELSE
          cCusto:=SC7->C7_PRECO-(SC7->C7_VALICM/SC7->C7_QUANT)-(SC7->C7_PRECO*0.0925)+(SC7->C7_PRECO*SC7->C7_IPI/100)
        ENDIF
      ENDIF
      IF SC7->C7_MOEDA <> 1
        cCusto:=SC7->C7_PRECO*SC7->C7_TXMOEDA*SC7->C7_DESIMPO
      ENDIF
      //cCusto:=SC7->C7_PRECO-(SC7->C7_VALICM/SC7->C7_QUANT)-(SC7->C7_PRECO*0.0925)+(SC7->C7_PRECO*SC7->C7_IPI/100)
       	/*
    	cIc001:=ROUND(VAL(cCusto1)/(1-(cMc1/100))/(1-(cComis1/100))/(1-(cPis1/100))/(1-(cCof1/100))/(1-(0/100)),2)
    	cIc002:=ROUND(VAL(cCusto1)/(1-(cMc2/100))/(1-(cComis2/100))/(1-(cPis2/100))/(1-(cCof2/100))/(1-(0/100)),2)
    	cIc003:=ROUND(VAL(cCusto1)/(1-(cMc3/100))/(1-(cComis3/100))/(1-(cPis3/100))/(1-(cCof3/100))/(1-(0/100)),2)
    	cIc071:=ROUND(VAL(cCusto1)/(1-(cMc1/100))/(1-(cComis1/100))/(1-(cPis1/100))/(1-(cCof1/100))/(1-(07/100)),2)
    	cIc072:=ROUND(VAL(cCusto1)/(1-(cMc2/100))/(1-(cComis2/100))/(1-(cPis2/100))/(1-(cCof2/100))/(1-(07/100)),2)
    	cIc073:=ROUND(VAL(cCusto1)/(1-(cMc3/100))/(1-(cComis3/100))/(1-(cPis3/100))/(1-(cCof3/100))/(1-(07/100)),2)
    	cIc121:=ROUND(VAL(cCusto1)/(1-(cMc1/100))/(1-(cComis1/100))/(1-(cPis1/100))/(1-(cCof1/100))/(1-(12/100)),2)
    	cIc122:=ROUND(VAL(cCusto1)/(1-(cMc2/100))/(1-(cComis2/100))/(1-(cPis2/100))/(1-(cCof2/100))/(1-(12/100)),2)
    	cIc123:=ROUND(VAL(cCusto1)/(1-(cMc3/100))/(1-(cComis3/100))/(1-(cPis3/100))/(1-(cCof3/100))/(1-(12/100)),2)
    	cIc181:=ROUND(VAL(cCusto1)/(1-(cMc1/100))/(1-(cComis1/100))/(1-(cPis1/100))/(1-(cCof1/100))/(1-(18/100)),2)
    	cIc182:=ROUND(VAL(cCusto1)/(1-(cMc2/100))/(1-(cComis2/100))/(1-(cPis2/100))/(1-(cCof2/100))/(1-(18/100)),2)
    	cIc183:=ROUND(VAL(cCusto1)/(1-(cMc3/100))/(1-(cComis3/100))/(1-(cPis3/100))/(1-(cCof3/100))/(1-(18/100)),2)  
    	*/
      //             custo  +  margem contr   +                        comissoes        +      tratamento de impostos

      //              100     100    20            100     100    20         100            100     100    20          100       100   20          1                  1,65  7,60

      //=(A3/(1-((G3+H3)*(1+K3)))*(1+K3))/(1-(C3+D3+E3))
      //       1       2  34           4  4  5        5432  2  3        321  1  23              3    21
      cIc001:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+00)/100))
      cIc002:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+00)/100))
      cIc003:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+00)/100))
      cIc071:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+07)/100))
      cIc072:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+07)/100))
      cIc073:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+07)/100))
      cIc121:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+12)/100))
      cIc122:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+12)/100))
      cIc123:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+12)/100))
      cIc181:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+18)/100))
      cIc182:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+18)/100))
      cIc183:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+18)/100))
      cIc041:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+cIcmg)/100))
      cIc042:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+cIcmg)/100))
      cIc043:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+cIcmg)/100))
    	/*
    	cIc001:=ROUND(cCusto/(1-((cMc1+cComis1)/100))/(1-((cPis1+cCof1+00)/100)),2)
    	cIc002:=ROUND(cCusto/(1-((cMc2+cComis2)/100))/(1-((cPis2+cCof2+00)/100)),2)
    	cIc003:=ROUND(cCusto/(1-((cMc3+cComis3)/100))/(1-((cPis3+cCof3+00)/100)),2)
    	cIc071:=ROUND(cCusto/(1-((cMc1+cComis1)/100))/(1-((cPis1+cCof1+07)/100)),2)
    	cIc072:=ROUND(cCusto/(1-((cMc2+cComis2)/100))/(1-((cPis2+cCof2+07)/100)),2)
        cIc073:=ROUND(cCusto/(1-((cMc3+cComis3)/100))/(1-((cPis3+cCof3+07)/100)),2)
        cIc121:=ROUND(cCusto/(1-((cMc1+cComis1)/100))/(1-((cPis1+cCof1+12)/100)),2)
        cIc122:=ROUND(cCusto/(1-((cMc2+cComis2)/100))/(1-((cPis2+cCof2+12)/100)),2)
        cIc123:=ROUND(cCusto/(1-((cMc3+cComis3)/100))/(1-((cPis3+cCof3+12)/100)),2)
        cIc181:=ROUND(cCusto/(1-((cMc1+cComis1)/100))/(1-((cPis1+cCof1+18)/100)),2)
        cIc182:=ROUND(cCusto/(1-((cMc2+cComis2)/100))/(1-((cPis2+cCof2+18)/100)),2)
        cIc183:=ROUND(cCusto/(1-((cMc3+cComis3)/100))/(1-((cPis3+cCof3+18)/100)),2)
        */
      oGet200:REFRESH()
      oGet119:REFRESH()
      oGet120:REFRESH()
      oGet121:REFRESH()
      oGet122:REFRESH()
      oGet129:REFRESH()
      oGet130:REFRESH()
      oGet131:REFRESH()
      oGet148:REFRESH()
      oGet136:REFRESH()
      oGet137:REFRESH()
      oGet138:REFRESH()
      oGet139:REFRESH()
      oGetI041:refresh()
      oGetI042:refresh()
      oGetI043:refresh()
    endif
  endif
  if nOpcao==0
    if MsgYesNo("Deseja realmente abrir Processo de Compra n. "+ cConPed + " ?","Automacao de Processo")
      MaViewPC(cConPed)
    endif
  endif

  oGet38:SETFOCUS()
  oDlg:REFRESH()
  oCombo67:lReadOnly:=.F.
  oCombo63:lReadOnly:=.F.
  oCombo66:lReadOnly:=.F.

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPOS()  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Ordens de Servico              				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPOS()
  Local cConPed:=SUBSTR(cboPoS,9,6)
  DbSelectArea("AB6")
  dbSetOrder(1)
  IF cConPed="      "
  else
    cCadastro:=cConped
    IF MsSeek(xfilial("AB6")+cConped)
      If MsgYesNo("Deseja realmente abrir OS n. "+ cConPed + " ?","Automacao de Processo")
        AT450Visua("AB6",RECNO(),1)
      endif
    endif
  endif
  oGet38:SETFOCUS()
  oDlg:REFRESH()
  oCombo67:lReadOnly:=.F.
  oCombo66:lReadOnly:=.F.
  oCombo59:lReadOnly:=.F.

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPPV()  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPORC(cOrc)
  Local cAvalia:=cOrc
  Local cConPed:=SUBSTR(lstOrc,11,6)
  if cTipov<>"SCJ"
    if cAvalia<>""
      dbSelectArea("SCJ")
      dbSetOrder(1)
      MsSeek(xFilial("SCJ")+cAvalia)
      cCadastro:=SCJ->CJ_CLIENTE
      A415Visual("SCJ",RECNO(),2)
    else
      IF lstOrc<>""
        If MsgYesNo("Deseja realmente abrir Orcamento n. "+ cConPed + " ?","Automacao de Processo")
          dbSelectArea("SCJ")
          dbSetOrder(1)
          MsSeek(xFilial("SCJ")+cConPed)
          cCadastro:=SCJ->CJ_CLIENTE
          A415Visual("SCJ",SCJ->(RECNO()),2)
        endif
      endif
    endif
  ELSE
    if cAvalia<>""
    else
      IF lstOrc<>""
        MsgInfo("Nao e permitido abrir orcamento partindo desta rotina...", "Processo finalizado")
      endif
    endif
  ENDIF
  oDlg:REFRESH()
  oGet38:SETFOCUS()
return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCPESO() ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCPESO()
  dbSelectArea("PAZ")
  dbSetOrder(1)
  IF MsSeek(xFilial("PAZ")+"APE"+UPPER(SUBSTR(cUsuario,7,15)))
    if nPeso>0
      dbSelectArea("SB1")
      dbSetOrder(1)
      MsSeek(xFilial("SB1")+cCodigo)
      IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
          SB1->B1_COD	== cCodigo)
        RecLock("SB1",.F.)
        SB1->B1_PESO:=NPeso
        MsUnLock()
      endif
    endif
    IF MsgYesNo("Deseja Alterar Pesos da Lista da Consulta Avancada?","Automacao de Processo")
      Processa({||U_HCPCD2()},"Pesos","Atualizando dados, aguarde...")
    endif
  endif
return .T.

User function HCPCD2()
  Local nItens
  Local cCodA
  dbSelectArea("SB1")
  dbSetOrder(1)
  ProcRegua(LEN(aAvancada))
  for nItens:=1 to len(aAvancada)
    cCodA:=SUBSTR(aAvancada[nItens],6,15)
    MsSeek(xFilial("SB1")+cCodA)
    IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
        SB1->B1_COD	== cCodA)
      RecLock("SB1",.F.)
      SB1->B1_PESO:=NPeso
      MsUnLock()
    endif
    IncProc("ALT. Peso Prod:" + cCodA)
  next
  MsgInfo("Pesos alterados com sucesso...", "Processo finalizado")
RETURN .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCPVDA() ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCPVDA()
  Local nItens
  Local cCodA
  Local lPode:=.t.
  dbSelectArea("PAZ")
  dbSetOrder(1)
  IF MsSeek(xFilial("PAZ")+"APV"+UPPER(SUBSTR(cUsuario,7,15)))
    lPode:=.t.
  else
    MsgInfo("Rotina nao permitida a usuarios nao autorizados", "Acesso Indevido")
    lPode:=.f.
  endif
  if lpode=.t.
    dbSelectArea("SB1")
    dbSetOrder(1)
    MsSeek(xFilial("SB1")+cCodigo)
    IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
        SB1->B1_COD	== cCodigo)
      RecLock("SB1",.F.)
      SB1->B1_VDAMIN:=cVdMn
      SB1->B1_VDANOR:=cVdNor
      SB1->B1_TABELA:=cTabela
      MsUnLock()
      MsgInfo("Preco de Venda do Produto:"  + cCodigo + "    Atualizado com sucesso...", "Processo Automatizado")
    endif
    IF MsgYesNo("Deseja Alterar Precos da Lista da Consulta Avancada?","Automacao de Processo")
      Processa({||U_HCPCD1()},"Precos de venda","Atualizando dados, aguarde...")
    endif
  endif
return .T.


User function HCPCD1()
  Local nItens
  Local cCodA
  dbSelectArea("SB1")
  dbSetOrder(1)
  ProcRegua(LEN(aAvancada))
  for nItens:=1 to len(aAvancada)
    cCodA:=SUBSTR(aAvancada[nItens],6,15)
    MsSeek(xFilial("SB1")+cCodA)
    IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
        SB1->B1_COD	== cCodA)
      RecLock("SB1",.F.)
      SB1->B1_VDAMIN:=cVdMn
      SB1->B1_VDANOR:=cVdNor
      SB1->B1_TABELA:=cTabela
      MsUnLock()
    endif
    IncProc("ALT. PV. Prod:" + cCodA)
  next

RETURN .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPENT() ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPENT(nRot)
  Local aAreaAtu	:= GetArea()
  Local cAvalia:=""
  Local cNnfe:=SUBSTR(lstEntr,86,6)
  Local cSnfe:=SUBSTR(lstEntr,18,3)
  Local cInfe:=SUBSTR(lstEntr,93,4)
  Local cIcmEnt:=0
  Local cOcompra:=""
  Local nPosVal:=0
  FOR X=1 TO LEN(lstEntr)
    IF SUBSTR(lstEntr,X,3)="VL:"
      cOcompra:=SUBSTR(lstEntr,X+4,6)
      x:=len(lstEntr)
    endif
  next
  if Len(cOcompra)>0
    If nRot=2
      if MsgYesNo("Deseja realmente abrir Processo de Compra n. "+ cOCompra + " ?","Automacao de Processo")
        MaViewPC(cOCompra)
      endif
    endif
  endif
//  cCusto:=0
  cIc001:=0
  cIc002:=0
  cIc003:=0
  cIc071:=0
  cIc072:=0
  cIc073:=0
  cIc121:=0
  cIc122:=0
  cIc123:=0
  cIc181:=0
  cIc182:=0
  cIc183:=0
  cIc041:=0
  cIc042:=0
  cIc043:=0
  If nRot=1 .or. nRot=2
    IF lstEntr<>""
      FOR X=1 TO LEN(lstEntr)
        IF SUBSTR(lstEntr,X,2)="R$"
          cCusto:=VAL((SUBSTR(lstEntr,X+2,7)+"."+SUBSTR(lstEntr,X+10,2)))
          x:=len(lstEntr)
        endif
      next
    endif
  endif
  If nRot=3
    FOR Y=1 TO LEN(lstTbPr)
      IF SUBSTR(lstTbPr,Y,4)="-Ct:"
        nPosVal:=Y
        Y:=len(lstTbPr)
      endif
    next
    IF lstTbPr<>""
      FOR X=1 TO LEN(lstTbPr)
        IF SUBSTR(lstTbPr,X,2)="R$"
          cCusto:=VAL((SUBSTR(lstTbPr,X+3,nPosVal-X-6)+"."+SUBSTR(lstTbPr,nPosVal-2,2)))
          x:=len(lstTbPr)
        endif
      next
    endif
  endif
  cIc001:=0
  cIc002:=0
  cIc003:=0
  cIc071:=0
  cIc072:=0
  cIc073:=0
  cIc121:=0
  cIc122:=0
  cIc123:=0
  cIc181:=0
  cIc182:=0
  cIc183:=0
  cIc041:=0
  cIc042:=0
  cIc043:=0
  cIc001:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+00)/100))
  cIc002:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+00)/100))
  cIc003:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+00)/100))
  cIc071:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+07)/100))
  cIc072:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+07)/100))
  cIc073:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+07)/100))
  cIc121:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+12)/100))
  cIc122:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+12)/100))
  cIc123:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+12)/100))
  cIc181:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+18)/100))
  cIc182:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+18)/100))
  cIc183:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+18)/100))
  cIc041:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+cIcmg)/100))
  cIc042:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+cIcmg)/100))
  cIc043:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+cIcmg)/100))
  oGet200:REFRESH()
  oGet119:REFRESH()
  oGet120:REFRESH()
  oGet121:REFRESH()
  oGet122:REFRESH()
  oGet129:REFRESH()
  oGet130:REFRESH()
  oGet131:REFRESH()
  oGet148:REFRESH()
  oGet136:REFRESH()
  oGet137:REFRESH()
  oGet138:REFRESH()
  oGet139:REFRESH()
  oGetI041:refresh()
  oGetI042:refresh()
  oGetI043:refresh()

  RestArea(aAreaAtu)
return .T.





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³HCSOLCOM()³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCSOLCOM()

  Local cNumSolic
  Local cItemSc
  Local cConta
  Local cCC
  Local cItemCC
  Local cCLVL
  IF NSCOMPRA>0
    cNumSolic := GetNumSC1(.T.)
    if MsgYesNo("Deseja realmente Gerar Solicitacao de Compra n. "+ cNumsolic + " ?","Automacao de Processo")
      DbSelectArea("SB1")
      dbSetOrder(1)
      If MsSeek(xfilial("SB1")+cCodigo)
        cConta :=SB1->B1_CONTA
        cCC    :=SB1->B1_CC
        cItemCC:=SB1->B1_ITEMCC
        cCLVL  :=SB1->B1_CLVL
      endif
      dbSelectArea("SC1")
      dbSetOrder(1)
      cItemSC   := StrZero(1,Len(SC1->C1_ITEM))
      RecLock("SC1",.T.)
      SC1->C1_FILIAL  := xFilial("SC1")
      SC1->C1_FILENT  := xFilEnt(C1_FILIAL)
      SC1->C1_NUM     := cNumSolic
      SC1->C1_ITEM    := cItemSC
      SC1->C1_EMISSAO := dDataBase
      SC1->C1_PRODUTO := CCod
      SC1->C1_LOCAL   := cAlmox
      SC1->C1_UM      := cUnid
      SC1->C1_DESCRI  := cDescr
      SC1->C1_QUANT   := ROUND(nScompra,0)
      SC1->C1_CONTA   := cConta
      SC1->C1_CC      := cCC
      SC1->C1_ITEMCTA := cItemCC
      SC1->C1_CLVL    := cCLVL
      SC1->C1_SOLICIT := SUBSTR(cUsuario,7,15)
      SC1->C1_NOMAPRO := SUBSTR(cUsuario,7,15)
      SC1->C1_DATPRF  := dDataBase+cLtime
      SC1->C1_OBS     := "PP. Cons. Rapida N.Sol:"+cNumSolic
      SC1->C1_APROV   :="B"
      SC1->C1_QTDORIG :=nScompra
      SC1->C1_IMPORT  :="N"
      SC1->C1_USER    :=__CUSERID
      SC1->C1_UNIDREQ :="019"
      SC1->C1_CODCOMP :="054"
      SC1->C1_CLASS   :="1"
      MsUnLock()
      MsgInfo("Solicitacao de compra n." + cNumSolic + "    Inserida com sucesso...", "Processo Automatizado")
      if MsgYesNo("Deseja notificar as Areas da Solicitacao de Compra n. "+ cNumsolic + " ?","Automacao de Processo")
        U_HCTE006(cNumsolic,cItemSC,CCod,cDescr,nScompra,cTiEs,cEstmin,cMedio,cPP,cLtime,nEstfis,nOrcPen,nEstVir,nOsVir,nPoder3,nDe3)
  //      U_HCTE006(cNumsolic,cItemSC,CCod,cDescr,nScompra,cTiEs,cEstmin,cMedio,cPP,cLtime,cEst,cOrc,cOc,cOs,cEm3,cDe3) 
      ENDIF   
    endif
  ELSE
    MsgInfo("Nao Existe Saldo a Comprar", "Inconsistencia")
  endif
return .T.

/*
cCod   :=SB1->B1_COD
    cTiEs  :=SB1->B1_XSTATUS
    CdESCR :=SB1->B1_DESC
    cAlmox :=SB1->B1_LOCPAD
    nPeso  :=sb1->b1_peso
    cUnid  :=SB1->B1_UM
    cEstmin:=SB1->B1_ESTSEG
    cLtime :=SB1->B1_PE
    cMedio:=SB1->B1_LE
    cVdMn :=SB1->B1_VDAMIN
    cVdNor:=SB1->B1_VDANOR
    cTabela:= SB1->B1_TABELA
    cPolVenda:=SB1->B1_GRPVAR
    IF SB1->B1_XSTATUS="EN"
      IF SB1->B1_ESTSEG<0
        cPP:= SB1->B1_ESTSEG+(SB1->B1_LE*SB1->B1_PE/30)
      ELSE
        cPP:= SB1->B1_ESTSEG+(SB1->B1_LE*SB1->B1_PE/30)
      ENDIF
    ELSE
      cPP:=0
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A093Prod  ºAutor  ³Robson Bueno        º Data ³  13/06/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida Gets com uso de codigo inteligente                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³lGera: Indica se deve ser gerado SB1/SG1                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Hc093Pr(lGera,cReadVar,cContVar)
  Local cBase    := ""
  Local cCodP    := ""
  Local cCodigoP := ""
//Local aSavAre  := SaveArea1({"SB1", "SBP"})
  Local cDesc    := ""
  Local x
  Local lRotAuto := Type("lMsHelpAuto") == "L" .And. lMsHelpAuto // Se for usado em Rotina Automatica (MsExecAuto) nao exibe dialogos
  Local lContinua:= .T.
  Local lRet     := .T.
  Private lAtvGrd:= .F. //Controla se existe configuracao de grade no codigo inteligente.

  DEFAULT cReadVar := ReadVar()
  DEFAULT cContVar := If(Empty(cReadVar), "", &(cReadVar))
  DbSelectArea("SBP")
  cBase :=A093VldBase(cContVar)

  lGera := If(lGera == Nil, .T., lGera)

  If Empty(cReadVar) .Or. Empty(cContVar) .Or. Empty(cBase)
    lContinua := .F.
  Endif

  SB1->(dbSetOrder(1))
  If lContinua .And. SB1->(dbSeek(xFilial("SB1") + Pad(cContVar, Len(SB1->B1_COD))))
    lContinua := .F.
  Endif

  If lContinua .And. !Empty(cBase) .And. "#CONPAD1#" $ "#" + ProcName(1) + "#" + ProcName(2) + "#" + ProcName(3) + "#" + ProcName(4) + "#" + ProcName(5) + "#" + ProcName(6) + "#"
    Help(" ",1,"A093NINC")
    lRet := .F.
  Endif

  If lContinua .And. lRet .And. !A093DispUso(cBase, .T.)
    lRet := .F.
  Endif

  If lContinua .And. lRet
    If lRotAuto
      cCodP := cContVar
    Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Ponto de Entrada para sugerir caracteristicas do produto  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If ExistBlock("MT093CFG")
        cCodP := ExecBlock("MT093CFG",.F.,.F.,{cContVar})
        If ValType(cCodP) == "C"
          cContVar := cCodP
        Endif
      EndIf
      cCodP := A093MontaCod(cContVar)
    Endif
    If ! A093InclOk(cBase)
      lRet := .F.
    Endif
  EndIf

  If lContinua .And. lRet
    lRet  := A093VldCod(cCodP,.F.,@cDesc,,,!lRotAuto,,lAtvGrd)
    If lRet
      // OBRIGAR INFORMAR PESO PARA O ITEM


      &(cReadVar) := cCodP
      If lGera .And. !lAtvGrd
        lRet  := A093VldCod(cCodP,.T.,,,, ! lRotAuto)
      Else
        SBR->(dbSeek(xFilial("SBR") + cBase))
        For x := 1 to SBR->(fCount())
          If SBR->(FieldName(x)) # "BR_FILIAL" .And. (nPos := (SB1->(FieldPos(StrTran(SBR->(FieldName(x)), "BR_", "B1_"))))) > 0
            &("M->" + SB1->(FieldName(nPos))) := SBR->(FieldGet(x))
          Endif
        Next
        M->B1_COD  := cCodP
        M->B1_DESC := Pad(cDesc,Len(SB1->B1_DESC))
        A093Campos(cCodP)
      Endif
    Endif
  EndIf
//RestArea1(aSavAre)
Return(cCodp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PCORPR   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados do produto e listas auxiliares				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PCODCL()
  IF cCli!="      "
    cNomered:=Posicione("SA1",1,xFilial("SA1")+cCli,"A1_NREDUZ")
    cLoja:=Posicione("SA1",1,xFilial("SA1")+cCli,"A1_LOJA")
  endif
RETURN .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PCORPR   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados do produto e listas auxiliares				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PGGORC()

  dbSelectArea("TMP1")
  TMP1->(dbGoBottom())
  IF (Empty(TMP1->CK_PRODUTO)) //Se planilha vazia, edita a primeira linha (em branco)
    RecLock("TMP1", .F.)
  ELSE
    RecLock("TMP1", .T.)
  EndIf
  TMP1->CK_ITEM    := strzero(TMP1->(RecNo()),2)
  TMP1->CK_PRODUTO := aOrc[1]
  TMP1->CK_QTDVEN  := 1
  TMP1->CK_PRCVEN  := val(aOrc[3])
  TMP1->CK_XDIAS   := val(aOrc[4])
  TMP1->CK_DSCTEC  :=aOrc[5]
  TMP1->CK_OBS     := aOrc[6]
  TMP1->CK_NUMREF  := aOrc[7]
  TMP1->CK_PV      := aOrc[8]
  TMP1->CK_ITEMCLI := aOrc[9]
  TMP1->CK_IPI     := val(aOrc[10])
  TMP1->CK_VALOR   := val(aOrc[2])*VAL(aOrc[3])
  TMP1->CK_ENTREG  := DATE() + val(aOrc[4])
  TMP1->CK_TABPRC	 := "INF"
  TMP1->CK_FONTE   := "000000"
  TMP1->CK_DTVALID := DATE()+30
  //PREENCHE DADOS VINDOS DE PRODUTOS (SB1)
  If (FieldPos("CK_UM") > 0 )
    TMP1->CK_UM       := SB1->B1_UM
  EndIf
  If (FieldPos("CK_TES") > 0 )
    If (!Empty(RetFldProd(SB1->B1_COD,"B1_TS")))
      TMP1->CK_TES      := RetFldProd(SB1->B1_COD,"B1_TS")
    Else
      TMP1->CK_TES      := A415TesPad()
    EndIf
  EndIf
  If (FieldPos("CK_LOCAL") > 0 )
    TMP1->CK_LOCAL    := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
  EndIf
  If (FieldPos("CK_COMIS1") > 0 )
    TMP1->CK_COMIS1   := SB1->B1_COMIS
  EndIf
  If (FieldPos("CK_DESCRI") > 0 )
    TMP1->CK_DESCRI   := SB1->B1_DESC
  EndIf
  If (FieldPos("CK_CONTRAT") > 0 )
    TMP1->CK_CONTRAT := ""
  EndIf
  If (FieldPos("CK_ITEMCON") > 0 )
    TMP1->CK_ITEMCON := ""
  EndIf
  MsUnlock("TMP1")

RETURN .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPNP3   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados de Materiais em posse de terceiros			   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RAPNP3(nOp)

  Local aArea		:= GetArea()
  Local lConfirma := .f.
  Private oDlg2
  Private INCLUI := .F.
  Private oGet650
  Private cCodP3 :=""
  IF NPODER3=0 .AND. NOP=1
    RETURN .T.
  ENDIF
  IF NDE3=0 .AND. NOP=2
    RETURN .T.
  ENDIF
  if nOp=1
    DEFINE MSDIALOG oDlg2 TITLE "Materiais Em Terceiros" FROM C(178),C(181) TO C(645),C(763) PIXEL
  else
    DEFINE MSDIALOG oDlg2 TITLE "Materiais de Terceiros" FROM C(178),C(181) TO C(645),C(763) PIXEL
  endif
  @ C(014),C(005) Say "Codigo.: " + cCodigo + " - " + "Descricao --> " + cDescr Size C(284),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
  GetDocs(nOp)
  ACTIVATE MSDIALOG oDlg2 CENTERED  ON INIT EnchoiceBar(oDlg2, {|| If(oGet650:TudoOk(), (lConfirma := .t.,oDlg2:End()), nil) },{||oDlg2:End()},,)

  If lConfirma
  endif

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³GetDocs()   ³ Autor ³ Robson Bueno          ³ Data ³13/02/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados - Observacoes                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetDocs(nOp)
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"HC6_STATUS","B6_CLIFOR","B6_LOJA","A2_NREDUZ","B6_DOC","B6_SERIE","B6_EMISSAO","B6_SALDO"}                                                                                                 
Local aAlter       	:= {"HC6_STATUS","B6_CLIFOR","B6_LOJA","A2_NREDUZ","B6_DOC","B6_SERIE","B6_EMISSAO","B6_SALDO"}                                                                                                 
Local nSuperior    	:= C(025)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(229)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= oDlg2                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aColAR       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
// Carrega aHead                                                                                                                

DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
  For nX := 1 to Len(aCpoGDa)
    If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
    Endif
  Next nX

// Carrega aCol                                                                                         
DBSELECTAREA("SB6")
DBSETORDER(1)                                                                                                          
  If SB6->(DbSeek(xFilial("SB6")+cCodigo))
    While xFilial("SB6") == SB6->B6_FILIAL .and. ! SZB->(Eof()) .and. SB6->B6_PRODUTO == cCodigo
      if nOp=1
        if SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="E"
          if SB6->B6_TPCF="F"
		     aAdd(aColAR,{"Nao",SB6->B6_CLIFOR,SB6->B6_LOJA,Posicione("SA2",1,xFilial("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A2_NREDUZ"),SB6->B6_DOC,SB6->B6_SERIE,SB6->B6_EMISSAO,SB6->B6_SALDO,.F.})
          else
            IF SB6->B6_TPCF="C" .AND. (SB6->B6_CLIFOR<>"000090" .AND. SB6->B6_CLIFOR<>"000669" .AND. SB6->B6_CLIFOR<>"000001")
		       aAdd(aColAR,{"Nao",SB6->B6_CLIFOR,SB6->B6_LOJA,Posicione("SA1",1,xFilial("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A1_NREDUZ"),SB6->B6_DOC,SB6->B6_SERIE,SB6->B6_EMISSAO,SB6->B6_SALDO,.F.})
            else
               aAdd(aColAR,{"Sim",SB6->B6_CLIFOR,SB6->B6_LOJA,Posicione("SA1",1,xFilial("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A1_NREDUZ"),SB6->B6_DOC,SB6->B6_SERIE,SB6->B6_EMISSAO,SB6->B6_SALDO,.F.})
            endif
          endif
        ENDIF
      else
        if SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="D" .AND. SB6->B6_TPCF="C"
		      aAdd(aColAR,{"Sim",SB6->B6_CLIFOR,SB6->B6_LOJA,Posicione("SA1",1,xFilial("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A1_NREDUZ"),SB6->B6_DOC,SB6->B6_SERIE,SB6->B6_EMISSAO,SB6->B6_SALDO,.F.})
        ELSE
          if SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="D"
		        aAdd(aColAR,{"Nao",SB6->B6_CLIFOR,SB6->B6_LOJA,Posicione("SA2",1,xFilial("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A2_NREDUZ"),SB6->B6_DOC,SB6->B6_SERIE,SB6->B6_EMISSAO,SB6->B6_SALDO,.F.})
          ENDIF
        endif
      endif
		SB6->(DbSkip())
    EndDo
                                                                                                
  Else
    aAux := {}
    For nX := 1 to Len(aCpoGDa)
      If DbSeek(aCpoGDa[nX])
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
      Endif
    Next nX
    Aadd(aAux,.F.)
    Aadd(aColAR,aAux)                                                                                                            
  Endif
                                                                    
oGet650 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColAR)                                   
Return Nil                                                                                                                      
     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Robson Bueno          ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
  Do Case
  Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8                                                                
  Case nHRes == 800	//Resolucao 800x600
		nTam *= 1                                                                  
  OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28                                                               
  EndCase
  If "MP8" $ oApp:cVersion
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
  //³Tratamento para tema "Flat"³                                               
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
    If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
       	nTam *= 0.90                                                            
    EndIf
  EndIf
Return Int(nTam) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ULTIMO PCE  ³ Autor ³ ROBSON BUENO DA SILVA ³ Data ³10/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao Responsavel pelo Carregamento do Valor de Entrada     ³±±
±±³           ³ Ultima entrada nacional                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function HCVLENT(cCod)
// carregando produto se encontrado
Local aAreaAtu	:= GetArea()
Local nValorEnt:=0
Local cQuerySd1,cCodigo
Local cAliasSd1:="SD1"
cCodigo:=upper(cCod)
DbSelectArea("PAA")
dbSetOrder(1)
  if MsSeek(xfilial("PAA")+cCodigo)
     nValorEnt:=PAA->PAA_UNIT
  ELSE
     nValorEnt:=0.00
  ENDIF
  if nValorEnt=0
  //IF cCodOrig!=nil 
  //  cCodigo:=upper(cCodOrig)
  //endif
  // CARREGANDO ENTRADAS EFETUADAS
  cQuerySD1 := "SELECT SD1.D1_COD,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_PEDIDO,SD1.D1_ITEMPC,SD1.D1_QUANT,SD1.D1_TOTAL," 
  cQuerySD1 += "SD1.D1_DOC,SD1.D1_ITEM,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6,SD1.D1_DTDIGIT,SD1.D1_TES,SD1.D1_EMISSAO " 
  cQuerySD1 += "FROM " + RetSqlName("SD1")+ " SD1 WHERE "
  cQuerySD1 += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
  cQuerySD1 += "SD1.D1_COD = '"+cCodigo+"' AND " 
  cQuerySD1 += "SD1.D_E_L_E_T_=' ' ORDER BY SD1.D1_EMISSAO DESC"
  //cQuery := ChangeQuery(cQuery)
    If ( Select ("SD1") <> 0 )
			dbSelectArea ("SD1")
			dbCloseArea ()
    Endif
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySD1),"SD1",.T.,.T.)
  dbSelectArea("SD1")
    DO WHILE ( !Eof() .And. SD1->D1_COD == cCodigo )
      IF nValorEnt=0
        IF SD1->D1_TES $ "102/156/108"
          nValorEnt:=(SD1->D1_TOTAL+SD1->D1_VALIPI-SD1->D1_VALICM-SD1->D1_VALIMP5-SD1->D1_VALIMP6)/SD1->D1_QUANT
        ENDIF
        IF SD1->D1_TES $ "301/305"
           nValorEnt:=SD1->D1_TOTAL/SD1->D1_QUANT
        ENDIF
      endif
      dbSkip()
    EndDo
  // LIMPANDO MEMORIA DO SISTEMA
    If ( Select ("SD1") <> 0 )
    			dbSelectArea ("SD1")
    			dbCloseArea ()
    Endif
  endif
RestArea(aAreaAtu)
Return(nValorEnt)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPENT() ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCMARGEM()

  IF cCusto=0 .OR. nEstFis<=0
    IF nEstFis<=0
    ELSE
      cCusto:=0
    ENDIF
    cIc001:=0
    cIc002:=0
    cIc003:=0
    cIc071:=0
    cIc072:=0
    cIc073:=0
    cIc121:=0
    cIc122:=0
    cIc123:=0
    cIc181:=0
    cIc182:=0
    cIc183:=0
    cIc041:=0
    cIc042:=0
    cIc043:=0
  else
    cIc001:=0
    cIc002:=0
    cIc003:=0
    cIc071:=0
    cIc072:=0
    cIc073:=0
    cIc121:=0
    cIc122:=0
    cIc123:=0
    cIc181:=0
    cIc182:=0
    cIc183:=0
    cIc041:=0
    cIc042:=0
    cIc043:=0
    cIc001:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+00)/100))
    cIc002:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+00)/100))
    cIc003:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+00)/100))
    cIc071:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+07)/100))
    cIc072:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+07)/100))
    cIc073:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+07)/100))
    cIc121:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+12)/100))
    cIc122:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+12)/100))
    cIc123:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+12)/100))
    cIc181:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+18)/100))
    cIc182:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+18)/100))
    cIc183:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+18)/100))
    cIc041:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+cIcmg)/100))
    cIc042:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+cIcmg)/100))
    cIc043:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+cIcmg)/100))
    oGet200:REFRESH()
    oGet119:REFRESH()
    oGet120:REFRESH()
    oGet121:REFRESH()
    oGet122:REFRESH()
    oGet129:REFRESH()
    oGet130:REFRESH()
    oGet131:REFRESH()
    oGet148:REFRESH()
    oGet136:REFRESH()
    oGet137:REFRESH()
    oGet138:REFRESH()
    oGet139:REFRESH()
    oGetI041:refresh()
    oGetI042:refresh()
    oGetI043:refresh()
  endif
return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCENVORC ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HCENVORC()
  if cValorOrc=0
    MsgInfo("Nao Existe selecao para adicionarmos a lista", "Inconsistencia")
  else
    AAdd(aOrc,{cCod,cQtdV2,cValorOrc,iif(nEstfis>0,10,120),cTecn,cBaseOrc,"","","",5,cUnid,"521","01",cDescr,cCusto})
    cValorOrc:=0
    cBaseOrc:=""
  endif
return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCENVORC ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HCLIMPOR()
  aOrc:={}
return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A415Inclui³ Autor ³ Robson Bueno          ³ Data ³08.12.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Inclusao de Orcamentos de Venda                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A415Inclui(ExpC1,ExpN1,ExpN2,ExpX1,[ExpC2])           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Opcao selecionada                                  ³±±
±±³          ³ ExpX4 = Sem funcao                                         ³±±
±±³          ³ ExpC5 = Numero do orcamento incluido ( passado por refe-   ³±±
±±³          ³ rencia                                                     ³±±
±±³          ³ ExpC6 = Codigo do cliente                                  ³±±
±±³          ³ ExpC7 = Loja do Cliente                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA415                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCINCORC()

  lOCAL cAvalia:="999999"
  Local cAlias:="SCJ"
  Local cUltimo:="00"
  Local cItem:="00"
  Local aCampos:={}
  Private bCampo		:= { |nField| Field(nField) }

  if len(aOrc)=0
    MsgInfo("Nao Existe produto na Cesta", "Inconsistencia")
    oDlg:REFRESH()
    oGet38:SETFOCUS()
    return .t.
  endif
  IF len(trim(cCli))=0
    MsgInfo("Defina o Cliente para prosseguir", "Inconsistencia")
    oDlg:REFRESH()
    oGet38:SETFOCUS()
    return .t.
  endif
  IF len(trim(cloja))=0
    MsgInfo("Defina a loja do cliente para prosseguir", "Inconsistencia")
    oDlg:REFRESH()
    oGet38:SETFOCUS()
    return .t.
  endif
  IF len(trim(cNumOrc))=0
    MsgInfo("Defina o n. do Orcamento para prosseguir", "Inconsistencia")
    oDlg:REFRESH()
    oGet38:SETFOCUS()
    return .t.
  endif
  dbSelectArea("SCJ")
  dbSetOrder(1)
  IF MsSeek(xFilial("SCJ")+cNumOrc)
    IF len(trim(cNumOrc))>0
      MsgInfo("Orcamento: >"+cNumOrc+"<. Ja existe no banco de dados... ", "Inconsistencia")
      if MsgYesNo("Deseja realmente Incluir itens da Cesta no orcamento n. "+ cNumOrc + " ?","Automacao de Processo")
        dbSelectArea("SCK")
        dbSetOrder(1)
        MsSeek(xFilial("SCK")+cNumOrc)
        DO WHILE ( !Eof() .And. SCK->CK_NUM=cNumOrc)
          cUltimo:=SCK->CK_ITEM
          dbskip()
        enddo
        Begin Transaction
          for nLista:=1 to len(aOrc)
            cUltimo := Soma1(cUltimo)
            dbSelectArea("SCK")
            RecLock("SCK",.T.)
            SCK->CK_FILIAL	:=xFilial("SCK")
            SCK->CK_NUM		:= cNumOrc
            SCK->CK_ITEM    := cUltimo
            SCK->CK_CLIENTE	:= cCli
            SCK->CK_LOJA	:= cLoja
            SCK->CK_PRODUTO := aOrc[nlista][1]
            SCK->CK_QTDVEN  := aOrc[nLista][2]
            SCK->CK_PRCVEN  := ROUND(aOrc[nLista][3],2)
            SCK->CK_XDIAS   := aOrc[nLista][4]
            SCK->CK_DSCTEC  := aOrc[nLista][5]
            SCK->CK_FEELING := aOrc[nLista][6]
            SCK->CK_NUMREF  := aOrc[nLista][7]
            SCK->CK_PV      := aOrc[nLista][8]
            SCK->CK_ITEMCLI := aOrc[nLista][9]
            SCK->CK_IPI     := aOrc[nLista][10]
            SCK->CK_VALOR   := ROUND(aOrc[nLista][3],2)*aOrc[nLista][2]
            SCK->CK_ENTREG  := DATE() + aOrc[nLista][4]
            SCK->CK_TABPRC	 := "INF"
            SCK->CK_FILENT  :="01"
            SCK->CK_FILVEN  :="01"
            SCK->CK_FONTE   := "000000"
            SCK->CK_DTVALID := DATE()+30
            SCK->CK_TES     := aOrc[nLista][12]
            SCK->CK_CLASFIS :="000"
            SCK->CK_CUSUNIT := aOrc[nLIsta][15]
            SCK->CK_FILVEN  := xFilial("SCK")
            SCK->CK_FILENT	 := xFilial("SCK")
            //PREENCHE DADOS VINDOS DE PRODUTOS (SB1)
            If (FieldPos("CK_UM") > 0 )
              SCK->CK_UM       := aOrc[nLIsta][11]
            EndIf
            If (FieldPos("CK_LOCAL") > 0 )
              SCK->CK_LOCAL    := aOrc[nLIsta][13]
            EndIf
            If (FieldPos("CK_DESCRI") > 0 )
              SCK->CK_DESCRI   := aOrc[nLIsta][14]
            EndIf
            If (FieldPos("CK_CONTRAT") > 0 )
              SCK->CK_CONTRAT := ""
            EndIf
            If (FieldPos("CK_ITEMCON") > 0 )
              SCK->CK_ITEMCON := ""
            EndIf
            MsUnlock("SCK")
          next
        End Transaction
        MsgInfo("Orcamento: >"+cNumOrc+"< ATUALIZADO com sucesso...", "Processo Finalizado")
      else
        oDlg:REFRESH()
        oGet38:SETFOCUS()
        return .t.
      endif
    endif
  ELSE
    // GRAVA DADOS DO CABECALHO DO ORCAMENTO
    if MsgYesNo("Deseja realmente Incluir itens da Cesta no orcamento n. "+ cNumOrc + " ?","Automacao de Processo")
      Begin Transaction
        RecLock("SCJ",.T.)
        SCJ->CJ_FILIAL	:=xFilial("SCJ")
        SCJ->CJ_NUM		:=cNumOrc
        SCJ->CJ_CLIENTE	:=cCli
        SCJ->CJ_LOJA	 	:=cLoja
        SCJ->CJ_EMISSAO	:=DATE()
        SCJ->CJ_XNREDUZ	:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_NREDUZ")
        SCJ->CJ_VALIDA	:=DATE()+10
        SCJ->CJ_VEND		:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_VEND")
        SCJ->CJ_XPRREF	:="S"
        SCJ->CJ_CLASSI	:="1"
        SCJ->CJ_DIVISAO	:="2"
        SCJ->CJ_AGINT		:=POSICIONE("SA3",7,xFilial("SA3")+RetCodUsr(),"A3_COD")
        SCJ->CJ_CONDPAG	:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_COND")
        SCJ->CJ_PGTO		:="1"
        SCJ->CJ_CLIENT	:=cCli
        SCJ->CJ_LOJAENT	:=cLoja
        SCJ->CJ_TPFRETE	:=IIF(Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_TPFRET")=" ","F",Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_TPFRET"))
        SCJ->CJ_ENDENT	:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_END")
        SCJ->CJ_BAIRROE	:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_BAIRRO")
        SCJ->CJ_MUNENT	:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_MUN")
        SCJ->CJ_ESTENT	:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_EST")
        SCJ->CJ_CEPE		:=Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_CEP")
        SCJ->CJ_STATUS 	:= "A"
        SCJ->CJ_STSBLQ 	:= "1"
        SCJ->CJ_NOMUSR 	:=Substr(cUsuario,7,15)
        MsUnlock("SCJ")
        //GRAVA DADOS DOS ITENS DO ORCAMENTO
        for nLista:=1 to len(aOrc)
          cItem := Soma1(cItem)
          dbSelectArea("SCK")
          RecLock("SCK",.T.)
          SCK->CK_FILIAL	:=xFilial("SCK")
          SCK->CK_NUM		:= cNumOrc
          SCK->CK_ITEM      := cItem
          SCK->CK_CLIENTE	:= cCli
          SCK->CK_LOJA	:= cLoja
          SCK->CK_PRODUTO := aOrc[nlista][1]
          SCK->CK_QTDVEN  := aOrc[nLista][2]
          SCK->CK_PRCVEN  := ROUND(aOrc[nLista][3],2)
          SCK->CK_XDIAS   := aOrc[nLista][4]
          SCK->CK_DSCTEC  := aOrc[nLista][5]
          SCK->CK_FEELING := aOrc[nLista][6]
          SCK->CK_NUMREF  := aOrc[nLista][7]
          SCK->CK_PV      := aOrc[nLista][8]
          SCK->CK_ITEMCLI := aOrc[nLista][9]
          SCK->CK_IPI     := aOrc[nLista][10]
          SCK->CK_VALOR   := ROUND(aOrc[nLista][3],2)*aOrc[nLista][2]
          SCK->CK_ENTREG  := DATE() + aOrc[nLista][4]
          SCK->CK_TABPRC	 := "INF"
          SCK->CK_FONTE   := "000000"
          SCK->CK_DTVALID := DATE()+30
          SCK->CK_TES     := aOrc[nLista][12]
          SCK->CK_CLASFIS :="000"
          SCK->CK_CUSUNIT := aOrc[nLIsta][15]
          SCK->CK_FILVEN  := xFilial("SCK")
          SCK->CK_FILENT	:= xFilial("SCK")

          //PREENCHE DADOS VINDOS DE PRODUTOS (SB1)
          If (FieldPos("CK_UM") > 0 )
            SCK->CK_UM       := aOrc[nLIsta][11]
          EndIf
          If (FieldPos("CK_LOCAL") > 0 )
            SCK->CK_LOCAL    := aOrc[nLIsta][13]
          EndIf
          If (FieldPos("CK_DESCRI") > 0 )
            SCK->CK_DESCRI   := aOrc[nLIsta][14]
          EndIf
          If (FieldPos("CK_CONTRAT") > 0 )
            SCK->CK_CONTRAT := ""
          EndIf
          If (FieldPos("CK_ITEMCON") > 0 )
            SCK->CK_ITEMCON := ""
          EndIf
          MsUnlock("SCK")
        next
      End Transaction
      MsgInfo("Orcamento: >"+cNumOrc+"< INCLUIDO com sucesso...", "Processo Finalizado")
    endif
  ENDIF
  U_RAPORC(cNumOrc)
  oDlg:REFRESH()
  oGet38:SETFOCUS()
return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A415Inclui³ Autor ³ Eduardo Riera         ³ Data ³08.12.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Inclusao de Orcamentos de Venda                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void A415Inclui(ExpC1,ExpN1,ExpN2,ExpX1,[ExpC2])           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Opcao selecionada                                  ³±±
±±³          ³ ExpX4 = Sem funcao                                         ³±±
±±³          ³ ExpC5 = Numero do orcamento incluido ( passado por refe-   ³±±
±±³          ³ rencia                                                     ³±±
±±³          ³ ExpC6 = Codigo do cliente                                  ³±±
±±³          ³ ExpC7 = Loja do Cliente                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA415                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCVER001(cSelecao)
  cBaseorc:="Prod. Origem: "+cCodigo+"  Custo: "+transform(cCusto,"@e 999999.99")
  if cSelecao= "001"
    cValorOrc:=cIc001
    cBaseOrc:=cBaseorc+" MC "+transform(cMc1,"@e 9999")+"/Icms 0/Rp1 0/Rp2 0"
  endif
  if cSelecao= "002"
    cValorOrc:=cIc002
    cBaseOrc:=cBaseorc+" MC "+transform(cMc2,"@e 9999")+"/Icms 0/Rp1 4/Rp2 0"
  endif
  if cSelecao= "003"
    cValorOrc:=cIc003
    cBaseOrc:=cBaseorc+" MC "+transform(cMc3,"@e 9999")+"/Icms 0/Rp1 4/Rp2 4"
  endif
  if cSelecao= "071"
    cValorOrc:=cIc071
    cBaseOrc:=cBaseorc+" MC "+transform(cMc1,"@e 9999")+"/Icms 7/Rp1 0/Rp2 0"
  endif
  if cSelecao= "072"
    cValorOrc:=cIc072
    cBaseOrc:=cBaseorc+" MC "+transform(cMc2,"@e 9999")+"/Icms 7/Rp1 4/Rp2 0"
  endif
  if cSelecao= "073"
    cValorOrc:=cIc073
    cBaseOrc:=cBaseorc+" MC "+transform(cMc3,"@e 9999")+"/Icms 7/Rp1 4/Rp2 4"
  endif
  if cSelecao= "121"
    cValorOrc:=cIc121
    cBaseOrc:=cBaseorc+" MC "+transform(cMc1,"@e 9999")+"/Icms 12/Rp1 0/Rp2 0"
  endif
  if cSelecao= "122"
    cValorOrc:=cIc122
    cBaseOrc:=cBaseorc+" MC "+transform(cMc2,"@e 9999")+"/Icms 12/Rp1 4/Rp2 0"
  endif
  if cSelecao= "123"
    cValorOrc:=cIc123
    cBaseOrc:=cBaseorc+" MC "+transform(cMc3,"@e 9999")+"/Icms 12/Rp1 4/Rp2 4"
  endif
  if cSelecao= "181"
    cValorOrc:=cIc181
    cBaseOrc:=cBaseorc+" MC "+transform(cMc1,"@e 9999")+"/Icms 18/Rp1 0/Rp2 0"
  endif
  if cSelecao= "182"
    cValorOrc:=cIc182
    cBaseOrc:=cBaseorc+" MC "+transform(cMc2,"@e 9999")+"/Icms 18/Rp1 4/Rp2 0"
  endif
  if cSelecao= "183"
    cValorOrc:=cIc183
    cBaseOrc:=cBaseorc+" MC "+transform(cMc3,"@e 9999")+"/Icms 18/Rp1 4/Rp2 4"
  endif

  if cSelecao= "041"
    cValorOrc:=cIc041
    cBaseOrc:=cBaseorc+" MC "+transform(cMc1,"@e 9999")+"/Icms 4/Rp1 0/Rp2 0"
  endif
  if cSelecao= "042"
    cValorOrc:=cIc042
    cBaseOrc:=cBaseorc+" MC "+transform(cMc2,"@e 9999")+"/Icms 4/Rp1 4/Rp2 0"
  endif
  if cSelecao= "043"
    cValorOrc:=cIc043
    cBaseOrc:=cBaseorc+" MC "+transform(cMc3,"@e 9999")+"/Icms 4/Rp1 4/Rp2 4"
  endif
  if cTipov="SCJ"
    IF TMP1->CK_PRCVEN=0
      TMP1->CK_PRCVEN:=ROUND(cValorOrc,2)
      TMP1->CK_VALOR:=ROUND(cValorOrc,2)*TMP1->CK_QTDVEN
      TMP1->CK_CUSUNIT:=cCusto
      TMP1->CK_FEELING:=cBaseOrc + " Est: "+transform(nEstfis,"@e 99999.99")
      if substring(cSelecao,3,1)="1"
        TMP1->CK_COMIS1:=0
        TMP1->CK_MRG:=cMc1
      endif
      if substring(cSelecao,3,1)="2"
        TMP1->CK_COMIS1:=cComis2
        TMP1->CK_MRG:=cMc2
      endif
      if substring(cSelecao,3,1)="3"
        TMP1->CK_COMIS1:=cComis2
        TMP1->CK_COMIS5:=cComis2
        TMP1->CK_MRG:=cMc3
      endif
      if substring(cSelecao,3,1)="1"
        TMP1->CK_COMIS1:=0
        TMP1->CK_MRG:=cMc1
      endif
      If substring(cSelecao,1,2)="00"
        TMP1->CK_VLICM:=0.00
        TMP1->CK_PIS   :=1.65
        TMP1->CK_COFINS:=7.60
      endif
      if substring(cSelecao,1,2)="04"
        TMP1->CK_VLICM:=4.00
        TMP1->CK_PIS   :=1.65
        TMP1->CK_COFINS:=7.60
      endif
      if substring(cSelecao,1,2)="07"
        TMP1->CK_VLICM :=7.00
        TMP1->CK_PIS   :=1.65
        TMP1->CK_COFINS:=7.60
      endif
      if substring(cSelecao,1,2)="12"
        TMP1->CK_VLICM:=12.00
        TMP1->CK_PIS   :=1.65
        TMP1->CK_COFINS:=7.60
      endif
      if substring(cSelecao,1,2)="18"
        TMP1->CK_VLICM:=18.00
        TMP1->CK_PIS   :=1.65
        TMP1->CK_COFINS:=7.60
      endif
    endif
  endif
  if cTipov="SC5"
    IF ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]=0
      ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})]:=ROUND(cValorOrc,2)
      ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})]:=ROUND(cValorOrc,2)*ACols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})]
    endif
  endif
  if cTipov<>"SC5" .AND. cTipov<>"SCJ"
    // gerando o registro de eventos da consulta rapida
    IF cPaisLoc="BRA"
      DbSelectArea("PR1")
      dbSetOrder(01)
      IF MsSeek(xFilial("PR1")+cRastro)
        Begin Transaction
          RecLock("PR1",.F.)
          PR1->PR1_VLPV := cValorOrc
          PR1->PR1_POL  := substr(cBaseOrc,32,80)
          MsUnlock("PR1")
        End Transaction
        If ( Select ("PR1") <> 0 )
          dbSelectArea ("PR1")
          dbCloseArea ()
        Endif
      ENDIF
    ENDIF
  endif
return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPENT() ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCMAR2()
  Local lPode:=.T.
  IF cCusto=0
    cCusto:=0
    cIc001:=0
    cIc002:=0
    cIc003:=0
    cIc071:=0
    cIc072:=0
    cIc073:=0
    cIc121:=0
    cIc122:=0
    cIc123:=0
    cIc181:=0
    cIc182:=0
    cIc183:=0
  else
    cIc001:=0
    cIc002:=0
    cIc003:=0
    cIc071:=0
    cIc072:=0
    cIc073:=0
    cIc121:=0
    cIc122:=0
    cIc123:=0
    cIc181:=0
    cIc182:=0
    cIc183:=0
    cIc001:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+00)/100))
    cIc002:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+00)/100))
    cIc003:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+00)/100))
    cIc071:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+07)/100))
    cIc072:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+07)/100))
    cIc073:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+07)/100))
    cIc121:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+12)/100))
    cIc122:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+12)/100))
    cIc123:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+12)/100))
    cIc181:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+18)/100))
    cIc182:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+18)/100))
    cIc183:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+18)/100))
    cIc041:=(cCusto/(1-((cComis1/100)*(1+(cMc1/100))))*(1+(cMc1/100)))/(1-((cPis1+cCof1+cIcmg)/100))
    cIc042:=(cCusto/(1-((cComis2/100)*(1+(cMc2/100))))*(1+(cMc2/100)))/(1-((cPis2+cCof2+cIcmg)/100))
    cIc043:=(cCusto/(1-((cComis3/100)*(1+(cMc3/100))))*(1+(cMc3/100)))/(1-((cPis3+cCof3+cIcmg)/100))
    oGet200:REFRESH()
    oGet119:REFRESH()
    oGet120:REFRESH()
    oGet121:REFRESH()
    oGet122:REFRESH()
    oGet129:REFRESH()
    oGet130:REFRESH()
    oGet131:REFRESH()
    oGet148:REFRESH()
    oGet136:REFRESH()
    oGet137:REFRESH()
    oGet138:REFRESH()
    oGet139:REFRESH()
    oGetI041:REFRESH()
    oGetI042:REFRESH()
    oGetI043:REFRESH()
  endif
  dbSelectArea("PAZ")
  dbSetOrder(1)
  IF MsSeek(xFilial("PAZ")+"ACU"+UPPER(SUBSTR(cUsuario,7,15)))
    if MsgYesNo("Deseja A	Atualizar tabela de Custos?","Automacao de Processo")
      dbSelectArea("PAZ")
      dbSetOrder(1)
      IF MsSeek(xFilial("PAZ")+"ACU"+UPPER(SUBSTR(cUsuario,7,15)))
        lPode:=.t.
      else
        MsgInfo("Rotina nao permitida a usuarios nao autorizados", "Acesso Indevido")
        lPode:=.f.
      endif
      if lPode=.t.
        dbSelectArea("PAA")
        dbSetOrder(1)
        If !MsSeek(xFilial("PAA")+cCod)
          RecLock("PAA",.T.)
          PAA->PAA_FILIAL	:=xFilial("PAA")
          PAA->PAA_COD		:=cCod
          PAA->PAA_DESCRI  :=Posicione("SB1",1,xFilial("SB1")+cCod,"B1_DESC")
        else
          RecLock("PAA",.F.)
        endif
        if MsgYesNo("O custo Informado e para campanha?","Automacao de Processo")
          if MsgYesNo("O custo Informado e para SUPER campanha?","Automacao de Processo")
            PAA->PAA_UNIT3:=cCusto
          else
            PAA->PAA_UNIT2:=cCusto
          endif
        else
          PAA->PAA_SALDO	:= 1
          IF cCusto>0
            PAA->PAA_UNIT	:=cCusto
            PAA->PAA_TOTAL	:=cCusto
          endif
          PAA->PAA_DATA	:=DATE()
        endif
        MsUnLock()
      endif
    ENDIF
  endif
return .T.



 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPNP3   ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados de Materiais em posse de terceiros			   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RAPOR8()

  Local aArea		:= GetArea()
  Local lConfirma := .f.
  Private oDlg2
  Private INCLUI := .F.
  Private oGet999
  Private cCodP3 :=""
  PRIVATE aNovo:={}
  IF LEN(trim(cCli))>0 .and. Len(trim(cLoja))>0 .and. Len(trim(cNomered))>0
    DEFINE MSDIALOG oDlg2 TITLE "Alteracao da Cesta de Produtos" FROM C(178),C(181) TO C(645),C(763) PIXEL
    @ C(014),C(005) Say "Cliente.: " + cCli+cLoja + " - Nome --> " + cNomered Size C(284),C(008) COLOR CLR_BLACK PIXEL OF oDlg2
    GetDoc2()
    ACTIVATE MSDIALOG oDlg2 CENTERED  ON INIT EnchoiceBar(oDlg2, {|| If(oGet999:TudoOk(), (lConfirma := .t.,oDlg2:End()), nil) },{||oDlg2:End()},,)

    If lConfirma
      For n:= 1 to Len(aOrc)
        aOrc[n][2]	:=oGet999:aColS[n][4]
        aOrc[n][3]	:=oGet999:aCols[n][5]
        aOrc[n][4]	:=oGet999:aColS[n][6]
        aorc[n][6]	:=oGet999:aColS[n][8]
      Next
      for ni:=1 to len(aOrc)
        if oGet999:aColS[ni][13]=.F.
          aAdd(aNovo,aOrc[ni])
        endif
      Next
      if Len(aNovo)>0
        aOrc:=aClonE(aNovo)
      endif
    Endif

  else
    MsgInfo("Para alterar a Cesta de Produtos e necessario <CLIENTE/LOJA>", "Acesso Indevido")
  ENDIF
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³GetDocs()   ³ Autor ³ Robson Bueno          ³ Data ³13/02/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados - Observacoes                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetDoc2()
Local nX			:= 0                                                                                                              
Local aAlter       	:= {}                                                                                                 
Local nSuperior    	:= C(025)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(335)           
Local nDireita     	:= C(290)           
Local aCpoGDa      	:= {"CK_ITEM","CK_PRODUTO","CK_DESCRI","CK_PRUNIT","CK_PRCVEN","CK_XDIAS","CK_DSCTEC","CK_OBS","CK_UM","CK_NUMREF","CK_PV","CK_ITEMCLI"}                                                                                                 
Local aAlter       	:= {"CK_ITEM","CK_PRODUTO","CK_DESCRI","CK_PRUNIT","CK_PRCVEN","CK_XDIAS","CK_DSCTEC","CK_OBS","CK_UM","CK_NUMREF","CK_PV","CK_ITEMCLI"}                                                                                                 
    
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
Local cItem                             // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= oDlg2                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aColAR       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
// Carrega aHead                                                                                                                

DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
  For nX := 1 to Len(aCpoGDa)
    If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(aHead,{ if(aCpoGDa[nX]="CK_PRUNIT","Qtd",AllTrim(X3Titulo())),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
      if(aCpoGDa[nX]="CK_PRUNIT","@R 9999,99",SX3->X3_PICTURE),;
          if(aCpoGDa[nX]="CK_PRUNIT",10,SX3->X3_TAMANHO),;
            if(aCpoGDa[nX]="CK_PRUNIT",2,SX3->X3_DECIMAL),;
            ".T.",;                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
            Endif
        Next nX

// Carrega aCol                                                                                         
        IF LEN(aOrc)>0
    cItem:="00"
          for nItem:=1 to len(aOrc)
      cItem := Soma1(cItem)
      aAdd(aColAR,{cItem,;   			//"ITEM"
      				aOrc[nitem][1],;   //"CK_PRODUTO"
      				aOrc[nitem][14],;  //"CK_DESCRI"
      				aOrc[nitem][2],;   //"CK_QTDVEN"
      				aOrc[nitem][3],;   //"CK_PRCVEN"
      				aOrc[nitem][4],;   //"CK_XDIAS"
      				aOrc[nitem][5],;   //"CK_DSCTEC"
      				aOrc[nitem][6],;   //"CK_OBS"
      				aOrc[nitem][11],;  //"CK_UNID"
      				aOrc[nitem][7],;   //"CK_RefCli"
      				aOrc[nitem][8],;   //"CK_PV"
      				aOrc[nitem][9],;   //"CK_ItemCli"
      				.F.})              
          next
        else
    aAux := {}
          For nX := 1 to Len(aCpoGDa)
            If DbSeek(aCpoGDa[nX])
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
            Endif
          Next nX
    Aadd(aAux,.F.)
    Aadd(aColAR,aAux)  
        endif
oGet999 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColAR)                                   
Return Nil                                                                                                                      
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPPV()  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCMAR9()
  dbSelectArea("PAZ")
  dbSetOrder(1)
  IF MsSeek(xFilial("PAZ")+"ATI"+UPPER(SUBSTR(cUsuario,7,15)))
    if cTiEs<>"  "
      dbSelectArea("SB1")
      dbSetOrder(1)
      MsSeek(xFilial("SB1")+cCodigo)
      IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
          SB1->B1_COD	== cCodigo)
        RecLock("SB1",.F.)
        SB1->B1_XSTATUS:=cTiEs
        SB1->B1_ESTSEG:=cEstmin
        SB1->B1_PE:=cLtime
        MsUnLock()
        MsgInfo("Tipo de Estoque de produto alterado com sucesso", "Rotina Integrada")
      endif
    endif
  endif
return .T.


 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPFWOC  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados de Materiais em posse de terceiros			   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPFWOC()

  Local aArea		:= GetArea()
  Local lConfirma := .f.
  Local cConPed:=SUBSTR(cboPoc,9,6)
  Local cCodIt:=SUBSTR(cboPoc,16,4)
  Local cForfw:= SPACE(6)
  Local cLojaFW:= SPACE(2)
  Local cNomeFW:= SPACE(15)
  Private oDlg3
  Private INCLUI := .F.
  Private oGet999
  Private cCodP3 :=""
  DbSelectArea("SC7")
  dbSetOrder(1)
  MsSeek(xfilial("SC7")+cConped+cCodIt)
  cNomeFW	:=Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ")
  cForfw	:= SC7->C7_FORNECE
  cLojaFW	:= SC7->C7_LOJA
  PRIVATE aNovo:={}
  IF LEN(trim(cconped))>0 .and. Len(trim(ccodit))>0
    DEFINE MSDIALOG oDlg3 TITLE "Follow-up de OC" FROM C(178),C(181) TO C(545),C(863) PIXEL
    @ C(014),C(005) Say "Fornecedor/Loja.: " + cForFW+"/"+cLojaFW + "-Nome-->" + cNomeFW + "Oc/Item:. "+cConPed+"/"+cCodIT   Size C(284),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
    GetDoc3()
    ACTIVATE MSDIALOG oDlg3 CENTERED  ON INIT EnchoiceBar(oDlg3, {|| oDlg3:End()},{||oDlg3:End()},,)
  endif

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³GetDocs()   ³ Autor ³ Robson Bueno          ³ Data ³13/02/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados - Observacoes                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetDoc3()
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZH_STATUS","ZH_SEQ","ZH_DTPROG","ZH_REG","ZH_CONTATO","ZH_DTREG","ZH_USUARIO","ZH_USUACAO","ZH_ENCERRA"}                                                                                                
Local aAlter       	:= {"ZH_STATUS","ZH_SEQ","ZH_DTPROG","ZH_REG","ZH_CONTATO","ZH_DTREG","ZH_USUARIO","ZH_USUACAO","ZH_ENCERRA"} 
Local nSuperior    	:= C(025)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(180)           
Local nDireita     	:= C(340)             
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE+GD_DELETE                                                                          
//Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.           
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= oDlg3                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aColac       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      


                                                                                                                               
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
  For nX := 1 to Len(aCpoGDa)
    If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
    ENDIF
  Next nX
// Carrega aCol                                                                                         
DbSelectArea("SZH")                                                                                                             
SZH->(DbSetOrder(1)) // Campo                                                                                                   
  if SZH->(DbSeek(xFilial("SZH")+SC7->C7_NUM + SC7->C7_ITEM))
    While xFilial("SZH") == SZH->ZH_FILIAL .and. ! SZH->(Eof()) .and. SZH->ZH_OC == SC7->C7_NUM  .AND. SZH->ZH_ITEM==SC7->C7_ITEM
		aAdd(aColac,{SZH->ZH_STATUS,SZH->ZH_SEQ,SZH->ZH_DTPROG,SZH->ZH_REG,SZH->ZH_CONTATO,SZH->ZH_DTREG,SZH->ZH_USUARIO,ZH_USUACAO,ZH_ENCERRA,.F.})
		SZH->(DbSkip())
    EndDo
                                                                                                
  Else
    aAux := {}
    DbSelectArea("SX3")                                                                                                             
    SX3->(DbSetOrder(2)) // Campo  
    For nX := 1 to Len(aCpoGDa)
      If DbSeek(aCpoGDa[nX])
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
      Endif
    Next nX
    Aadd(aAux,.F.)
    Aadd(aColAc,aAux) 
    // atribui o valor 1 para o campo sequencia
    aCOLAc[1,aScan(aHead,{|x|Trim(x[2])=="ZH_SEQ"})] := "001" 
    aCOLAc[1,aScan(aHead,{|x|Trim(x[2])=="ZH_DTPROG"})] := SC7->C7_DATPRF-3                                                                                                      
  Endif
// cLinhaOk                                                                    
oGet999 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColAc)      
                             
                                                              
Return Nil 


 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPFWOC  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Busca dados de Materiais em posse de terceiros			   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPFEN()
  Local aArea		:= GetArea()
  Local lConfirma := .f.
  Local cOcompra:=""
  Local cItem:=""
  Private oDlg4
  Private INCLUI := .F.
  Private oGet999
  Private cCodP3 :=""
  FOR X=1 TO LEN(lstEntr)
    IF SUBSTR(lstEntr,X,3)="VL:"
      cOcompra:=SUBSTR(lstEntr,X+4,6)
      cItem:=SUBSTR(lstEntr,X+11,4)
      x:=len(lstEntr)
    endif
  next
  DbSelectArea("SZI")
  dbSetOrder(3)
  MsSeek(xfilial("SZI")+cOcompra+cItem)
  PRIVATE aNovo:={}
  IF LEN(trim(cOcompra))>0 .and. Len(trim(cItem))>0
    DEFINE MSDIALOG oDlg4 TITLE "Lotes amarrados a Entrada" FROM C(178),C(181) TO C(545),C(863) PIXEL
    @ C(014),C(005) Say "Fornecedor/Loja.: " + SZI->ZI_FORNECE+"/"+SZI->ZI_LOJA + "-Nome-->" + SZI->ZI_NREDUZ + "Oc/Item:. "+cOcompra+"/"+cItem   Size C(284),C(008) COLOR CLR_BLACK PIXEL OF oDlg4
    GetDoc4(cOcompra,cItem)
    ACTIVATE MSDIALOG oDlg4 CENTERED  ON INIT EnchoiceBar(oDlg4, {|| oDlg4:End()},{||oDlg4:End()},,)
  endif

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³GetDocs()   ³ Autor ³ Robson Bueno          ³ Data ³13/02/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados - Observacoes                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetDoc4(cOcompra,cItem)
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZI_RIDENT","ZI_CORRIDA","ZI_QTD","ZI_DATA","ZI_STATUS","ZI_USUA","ZI_USUC","ZI_USUI"}                                                                                                
Local aAlter       	:= {"ZI_RIDENT","ZI_CORRIDA","ZI_QTD","ZI_DATA","ZI_STATUS","ZI_USUA","ZI_USUC","ZI_USUI"}
Local nSuperior    	:= C(025)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(180)           
Local nDireita     	:= C(340)           
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE+GD_DELETE                                                                          
//Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.           
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= oDlg4                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aColaP       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      


                                                                                                                               
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
  For nX := 1 to Len(aCpoGDa)
    If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
    ENDIF
  Next nX
// Carrega aCol                                                                                         
DbSelectArea("SZI")                                                                                                             
SZI->(DbSetOrder(3)) // Campo                                                                                                   
  if SZI->(DbSeek(xFilial("SZI")+cOcompra + cItem))
    While xFilial("SZI") == SZI->ZI_FILIAL .and. ! SZI->(Eof()) .and. SZI->ZI_COMPRA == cOcompra  .AND. SZI->ZI_ITEM==cItem
		aAdd(aColaP,{ZI_RIDENT,ZI_CORRIDA,ZI_QTD,ZI_DATA,ZI_STATUS,ZI_USUA,ZI_USUC,ZI_USUI,.F.})
		SZI->(DbSkip())
    EndDo
                                                                                                
  Else
    aAux := {}
    DbSelectArea("SX3")                                                                                                             
    SX3->(DbSetOrder(2)) // Campo  
    For nX := 1 to Len(aCpoGDa)
      If DbSeek(aCpoGDa[nX])
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
      Endif
    Next nX
    Aadd(aAux,.F.)
    Aadd(aColAP,aAux) 
    // atribui o valor 1 para o campo sequencia
                                                                                    
  Endif
// cLinhaOk                                                                    
oGet999 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColAP)      
                             
                                                              
Return Nil 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120B3   ºAutor  ³Robson Bueno        º Data ³  13/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Amarrar Oc a PV                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPOCPV()
  Local aArea		:= GetArea()
  Local lConfirma := .f.
  Static cRegistro
  sTATIC oBold
  Static cC7Tpc:="OC"		// TIPO2
  Static cC7Num		    	// NUMERO OC
  Static cC7Item			  // ITEM Oc
  Static cC7Nfor			  // FORNECEDOR
  Static nC7Qtd 			  // QUANTIDADE CASADA
  Static dC7Prz			    // PRAZO ENTRADA
  Static cCodocpv				// Codigo do Produto da OC
  Private INCLUI := .F.
  Private Odlg5
  Private oGet999
  Private cCodForn:=""
  Private cLoja   :=""
  Private cDesForn:=""
  Private cOcpv     :=SUBSTR(cboPoc,9,6)
  PRIvATE cItemOcpv := SUBSTR(cboPoc,16,4)
  nSdep :=0
  DbSelectArea("SC7")
  dbSetOrder(1)
  MsSeek(xfilial("SC7")+cOcPv+cItemOcPv)
  cDesForn:=Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NREDUZ")
  cCodForn:= SC7->C7_FORNECE
  cLoja	:= SC7->C7_LOJA
  DEFINE FONT oBold NAME "MS Sans Serif" SIZE 0, -9 BOLD
  DEFINE MSDIALOG oDlg5 TITLE OemtoAnsi("Processos Amarrados ao Item da Compra") FROM C(178),C(181) TO C(605),C(763) PIXEL
// CARREGANDO DADOS DA OC PARA POSSIVEL GRAVACAO DE AMARRACAO DE OC COM PV
  cC7Num	:=cOcPV
  cC7Item	:=cItemOcPV
  cC7Nfor	:=cDesForn
  nC7Qtd 	:=SC7->C7_QUANT-SC7->C7_QUJE
  dC7Prz	:=SC7->C7_DATPRF
  cCodocpv:=SC7->C7_PRODUTO
/*
DbSelectArea("SC7") aColsAnt1[nElemAnt1,1]
SC7->(DbSetOrder(1))
*/
  @ C(004),C(005) Say "OC.  : " + cOcPV + " - " + "Fornecedor : " + cCodForn + "-" + cLoja + "-" + cDesForn Size C(284),C(008) FONT oBold COLOR CLR_BLACK PIXEL OF oDlg5
  @ C(014),C(005) Say "Item.: " + SC7->C7_ITEM + " - " + "Codigo: " + SC7->C7_PRODUTO + " - Descr: " + SC7->C7_DESCRI + " - SALDO: " + STR(SC7->C7_QUANT-SC7->C7_QUJE) + " - Prazo: "+ SUBSTR(DTOS(SC7->C7_DATPRF),7,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),5,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),1,4) Size C(284),C(008) COLOR CLR_BLUE PIXEL OF oDlg5

  nSdep:=SC7->C7_QUANT-SC7->C7_QUJE

  GetDocOcPv()

  @ C(191),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF oDlg5

//ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {||_oDlg:End()},{||_oDlg:End()},,)
  ACTIVATE MSDIALOG oDlg5 CENTERED  ON INIT EnchoiceBar(oDlg5, {|| (lConfirma := .t.,oDlg5:End())},{||oDlg5:End()},,)
  If lConfirma .AND. 0=1 // PARADA DE ROTINA .... NAO VALIDA DE JEITO NENHUM
    FOR nLin:=1 to len(ACOLOCPV)
      IF ACOLOCPV[nLin,10]="MAN" .OR. ACOLOCPV[nLin,7]>0
        dbSelectArea("SZK")
        DbSetOrder(4)
        IF MsSeek(xFilial("SZK")+"OC"+cC7num+substr(cC7Item,2,3)+"PV"+ACOLOCPV[nLin,2]+ACOLOCPV[nLin,3])
          Reclock("SZK",.F.)
        ELSE
          Reclock("SZK",.T.)
          SZK->ZK_DT_VINC:=date()          		   		// DATA DA VINCULACAO
        ENDIF
        SZK->ZK_FILIAL :=xfilial("SZK")
        SZK->ZK_TIPO   :="PV"                       	// TIPO
        SZK->ZK_REF    :=ACOLOCPV[nLin,2]           	// PEDIDO
        SZK->ZK_REFITEM:=ACOLOCPV[nLin,3]           	// ITEM PEDIDO
        SZK->ZK_NOME   :=ACOLOCPV[nLin,4]           	// CLIENTE
        SZK->ZK_COD    :=ACOLOCPV[nLin,9]            // CODIGO PRODUTO
        SZK->ZK_DESCRI :=ACOLOCPV[nLin,10]          	// DESCRICAO
        SZK->ZK_QTD    :=ACOLOCPV[nLin,5]           	// QUANTIDADE VENDA
        SZK->ZK_PRAZO  :=ACOLOCPV[nLin,6] 	         	// PRAZO VENDA
        SZK->ZK_TIPO2  :="OC"            	         	// TIPO2
        SZK->ZK_OC     :=cC7num			              	// NUMERO OS
        SZK->ZK_ITEM   :=substr(cC7Item,2,3)        	// ITEM OS
        SZK->ZK_FORN   :=cC7Nfor   			          	// FORNECEDOR
        SZK->ZK_QTC    :=ACOLOCPV[nLin,7]  	       	// QUANTIDADE CASADA
        SZK->ZK_PRAZOC :=dC7Prz			              	// PRAZO ENTRADA
        IF ACOLOCPV[nLin,8]=0
          SZK->ZK_QTS    :=0                     	   // QUANTIDADE PENDENTE
          SZK->ZK_DT_BX  :=DATE()
          SZK->ZK_STATUS :="4"							          // STATUS DA OS
        ELSE
          SZK->ZK_QTS    :=ACOLOCPV[nLin,8]         	// QUANTIDADE PENDENTE
          SZK->ZK_STATUS :="1"
        ENDIF
        SZK->ZK_CONTROL:="RAP"							// METODO
        MsUnLock()

      ENDIF
      dbSelectArea("SZK")
    next
  ENDIF
  RestArea(aArea)
Return(.T.)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³GetDocs1()  ³ Autor ³ Robson Bueno          ³ Data ³13/02/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados - Compras Casadas                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetDocOcPv()
Local aArea		:= GetArea()
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZK_TIPO","ZK_REF","ZK_REFITEM","ZK_NOME","ZK_QTD","ZK_PRAZO","ZK_QTC","ZK_QTS", "ZK_COD","ZK_DESCRI","ZK_CONTROL"}                                                                                                
Local aAlter       	:= {"ZK_TIPO","ZK_REF","ZK_REFITEM","ZK_NOME","ZK_QTD","ZK_PRAZO","ZK_QTC","ZK_QTS", "ZK_COD","ZK_DESCRI","ZK_CONTROL"} 
Local nSuperior    	:= C(025)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(191)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE                                                                          
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_TdObsrap()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "U_RPVLOCPV()"   // Funcao executada na validacao do campo   "U_RPVLOCPV()"                                         
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= odlg5                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
aColOcPv 	          := {}              
                                                                                                                                
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
  For nX := 1 to Len(aCpoGDa)
    If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
    ENDIF
  Next nX
// Carrega aCol                                                                                         
DbSelectArea("SZK")                                                                                                             
SZK->(DbSetOrder(4)) // Campo                                                                                                   
  if SZK->(DbSeek(xFilial("SZK")+"OC" + SC7->C7_NUM + SUBSTR(SC7->C7_ITEM,2,3)))
    While xFilial("SZK") == SZK->ZK_FILIAL .and. ! SZK->(Eof()) .and. SZK->ZK_OC == SC7->C7_NUM  .AND. SUBSTR(SC7->C7_ITEM,2,3)==SZK->ZK_ITEM
		aAdd(aColOcPv,{SZK->ZK_TIPO,SZK->ZK_REF,SZK->ZK_REFITEM,SZK->ZK_NOME,SZK->ZK_QTD,SZK->ZK_PRAZO,SZK->ZK_QTC,SZK->ZK_QTS,ZK_COD,ZK_DESCRI,ZK_CONTROL,.F.})
		nSdep:=nSdep-SZK->ZK_QTS
		SZK->(DbSkip())
    EndDo
                                                                               
  Else
    aAux := {}
    DbSelectArea("SX3")                                                                                                             
    SX3->(DbSetOrder(2)) // Campo  
    For nX := 1 to Len(aCpoGDa)
      If DbSeek(aCpoGDa[nX])
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
      Endif
    Next nX
    Aadd(aAux,.F.)
    Aadd(aColOcPv,aAux)                                                                                                            
  Endif
cLinhaOk:="U_RPVLOCPV()"
cCampoOk:= "AllwaysTrue"
                                       
oGet947 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,NOPC,cLinhaOk,{|| U_TdObsrap()},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColOCPV)  
                             
 //        MsGetDados(): New ( < nTop>, < nLeft>, < nBottom>, < nRight>, < nOpc>, [ cLinhaOk], [ cTudoOk], [ cIniCpos],;
 //                          [ lDeleta], [ aAlter], [ nFreeze], [ lEmpty], [ nMax], [ cFieldOk], [ cSuperDel], [ uPar], [ cDelOk], [ oWnd], [ lUseFreeze], [ cTela] )                                 
oGet947.refresh
RestArea(aArea)
Return Nil                                                                                                                      

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCM14A1   ³ Autor ³ ROBSON BUENO          ³ Data ³02.10.07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ALIMENTA CAMPOS CONFORME PARAMETROS INFORMADOS              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhuma                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RPVLOCPV()
  Local aArea     := GetArea()  
  LOCAL lRet:=.T.  
  //Local cVar:="OC"
  IF M->ZK_REF<>"      "
    M->ZK_REF    	:=SC6->C6_NUM
    M->ZK_REFITEM	:=SC6->C6_ITEM
    M->ZK_COD	 	:=SC6->C6_PRODUTO
    IF SUBSTR(SC6->C6_NUM,1,1)="B" .OR. SUBSTR(SC6->C6_NUM,1,1)="D"
      M->ZK_NOME:=Posicione("SA2",1,xFilial("SA2")+SC6->C6_CLI+SC6->C6_LOJA,"A2_NREDUZ")
    ELSE
      M->ZK_NOME:=Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NREDUZ")
    ENDIF
    M->ZK_DESCRI := SC6->C6_DESCRI
    M->ZK_QTD	   := SC6->C6_QTDVEN 
    M->ZK_PRAZO  := SC6->C6_ENTREG
    M->ZK_TIPO2  :="OC"            	           	// TIPO2 
    M->ZK_OC     :=cC7num			                	// NUMERO OS
    M->ZK_ITEM   :=substr(cC7Item,2,3)          // ITEM OS
    M->ZK_FORN   :=cC7Nfor   			         	    // FORNECEDOR
    M->ZK_QTC    :=SC6->C6_QTDVEN 	            // QUANTIDADE CASADA
    M->ZK_QTS    :=SC6->C6_QTDVEN 	            // QUANTIDADE CASADA
    M->ZK_CONTROL:="RAP"
    M->ZK_PRAZOC :=dC7Prz			                	// PRAZO ENTRADA  
    aAdd(aColOcPv,{"PV",M->ZK_REF,M->ZK_REFITEM,M->ZK_NOME,M->ZK_QTD,M->ZK_PRAZO,M->ZK_QTC,M->ZK_QTS,M->ZK_COD,M->ZK_DESCRI,M->ZK_CONTROL,.F.})
    nSdep:=nSdep-M->ZK_QTS
   // @ C(191),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF oDlg5
  EndIf
  IF nSdep<0
    nSdep:=nSdep+M->ZK_QTS              
    MsgInfo("OC/OS N." + M->ZK_OC +"/"+ M->ZK_ITEM + " nao tem saldo, portanto nao e possivel amarrar Processos")
   // @ C(191),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF oDlg5
    lRet:=.F.
  ENDIF
  RestArea(aArea)
  oGet947.refresh
RETURN (lRet)


 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPPV()  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Saldo Real do Produto            				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCPOL()
  Local lPode:=.F.
  IF MsgYesNo("Deseja Alterar Politica de precos para todos os itens da Lista da Consulta Avancada?","Automacao de Processo")
    dbSelectArea("PAZ")
    dbSetOrder(1)
    IF MsSeek(xFilial("PAZ")+"ACU"+UPPER(SUBSTR(cUsuario,7,15)))
      Processa({||U_HCPOL2()},"Alteracao de Politicas","Atualizando dados, aguarde...")
    else
      MsgInfo("Rotina nao permitida a usuarios nao autorizados", "Acesso Indevido")
      lPode:=.f.
    endif
  endif
return .T.

User function HCPOL2()
  Local nItens
  Local cCodA
  dbSelectArea("SB1")
  dbSetOrder(1)
  ProcRegua(LEN(aAvancada))
  for nItens:=1 to len(aAvancada)
    cCodA:=SUBSTR(aAvancada[nItens],6,15)
    MsSeek(xFilial("SB1")+cCodA)
    IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
        SB1->B1_COD	== cCodA)
      RecLock("SB1",.F.)
      SB1->B1_GRPVAR:=cPolVenda
      MsUnLock()
    endif
    IncProc("Alt. Politica do Prod:" + cCodA)
  next
  MsgInfo("Politicas alterados com sucesso...", "Processo finalizado")
RETURN .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TudoObs   ºAutor  ³Robson Bueno        º Data ³  13/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TudoOk de Observacoes                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TdObsrap()

  Local nConta 	:= 1
  Local nConta1	:= 1



Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCAvanc  ³ Autor ³ ROBSON BUENO          ³ Data ³ 07/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ Consulta Avancada                       				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HCAVPP()
  Local aAreaAtu	:= GetArea()
  Local cQuery    := ""
  Local lQuery    := .F.
  Local aPtc      :={}
  Local nSaltos   :=0
  Local nPosi     :=1
  Local cEstAv
  Local cEstCom
  Local cEstSeg
  local cLead
  Local cMedia
  Local nQtdCpa
  Static nCasados:=0
  aAvancada:={}
  for x=1 to len(trim(cCodigo))
    if substr(cCodigo,x,1)="*"
      aAdd(aPtc, substr(cCodigo,nPosi,x-nposi))
      nPosi:=x+1
    endif
  next
  aAdd(aPtc, substr(cCodigo,nPosi,x-NPOSI))
  cQuery := "SELECT SB1.B1_COD,SB1.B1_DESC,SB1.B1_XSTATUS,SB1.B1_ESTSEG,SB1.B1_PE,SB1.B1_LE  FROM "
  cQuery += "" + RetSqlName("SB1")+ " SB1 "
  cQuery += "WHERE "
  cQuery += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
//cQuery += "SB1.B1_TIPO = 'PA' AND "
  cQuery += "SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL<>'1'"
/*
   cTiEs  :=SB1->B1_XSTATUS
   cUnid  :=SB1->B1_UM
   cEstmin:=SB1->B1_ESTSEG
   cLtime :=SB1->B1_PE
   cMedio:=SB1->B1_LE
*/
  for x=1 to len(aPtc)
    if x=1
      cQuery += " AND SB1.B1_COD LIKE '%" + aPtc[x] + "%"
    else
      cQuery += aPtc[x] + "%"
    endif
  next
  IF X=1
    cQuery += " AND SB1.B1_COD='" + cCodigo + "'"
  ELSE
    cQuery += "'"
  ENDIF
//cQuery := ChangeQuery(cQuery)
  dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QYSB1",.F.,.T.)
  dbSelectArea("QYSB1")
  While !Eof()
    nCasados:=0
    cEstAv:=transform(U_SALRAP(QYSB1->B1_COD),"@e")
    cEstCom:=transform(U_SALRA2(QYSB1->B1_COD),"@e")
    cEstSeg:=transform(QYSB1->B1_ESTSEG,"@E")
    clead :=TRANSFORM(QYSB1->B1_PE,"@E")
    cMedia:=transform(QYSB1->B1_LE,"@E")
    nQtdCpa:=TRANSFORM((VAL(cLead)/30*VAL(cMedia))+VAL(cEstSeg)-VAL(cEstAv)-VAL(cEstCom),"@E")
    dbSelectArea("QYSB1")
    nspaco1:=20-len("COD: " + QYSB1->B1_COD)
    nspaco2:=20-len("Desc: " + QYSB1->B1_DESC)
    IF VAL(nQtdCpa)>0
      aAdd( aAvancada, "COD: " + QYSB1->B1_COD + /*SPACE(NSPACO1) +*/ "-Pr: " + TRIM(QYSB1->B1_DESC) + /* SPACE(NSPACO2)+*/ "-Ed: " + TRIM(cEstAV) + " -SCp: "+TRIM(cEstcom)+" -T/C/S: "+TRIM(QYSB1->B1_XSTATUS)+"/"+trim(cMedia)+"/"+TRIM(CEstSeg)+ " -QCp: "+TRIM(nQtdCpa))
    ENDIF
    DbSkip()
  enddo
  dbSelectArea("QYSB1")
  dbCloseArea()
  if empty( aAvancada )
    aAdd( aAvancada, "" )
  endif
  oCombo3:aItems := aAvancada
  oDlg:REFRESH()
  RestArea(aAreaAtu)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPLOTE  ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CARREGA OS LOTES DOS PRODUTOS QUANDO TIVER RASTRO          ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RAPLOTE()


return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ RAPTBPR  ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CARREGA AS TABELAS DE PRECO NA CONSULTA RAPIDA             ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RAPTBPR()

return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PCODQT   ³ Autor ³ ROBSON BUENO          ³ Data ³ 15/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ CARREGA AS TABELAS DE PRECO NA CONSULTA RAPIDA             ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/          
User Function PCODQT()

  cQtdV2:=cQtdVd
  IF cPaisLoc="BRA"
    DbSelectArea("PR1")
    dbSetOrder(01)
    IF MsSeek(xFilial("PR1")+cRastro)
      Begin Transaction
        RecLock("PR1",.F.)
        PR1->PR1_QTD    := cQtdVd
        MsUnlock("PR1")
      End Transaction
      If ( Select ("PR1") <> 0 )
        dbSelectArea ("PR1")
        dbCloseArea ()
      Endif
    ENDIF
  ENDIF
return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ HCMIN () ³ Autor ³ ROBSON BUENO          ³ Data ³ 05032020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o  ³ acerta estoque minimo do produto          				   ³±±	
±±³           ³ demanda hci							                       ³±±
±±³           ³ cProd = Codigo do Produto desejado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USO        ³ REMOTE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCMIN()
  dbSelectArea("PAZ")
  dbSetOrder(1)
  IF MsSeek(xFilial("PAZ")+"AMI"+UPPER(SUBSTR(cUsuario,7,15)))
    if cEstmin>=0
      dbSelectArea("SB1")
      dbSetOrder(1)
      MsSeek(xFilial("SB1")+cCodigo)
      IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
          SB1->B1_COD	== cCodigo)
        RecLock("SB1",.F.)
        SB1->B1_ESTSEG:=cEstmin
        MsUnLock()
      endif
    endif
    IF MsgYesNo("Deseja Alterar Est. Min da Lista da Consulta Avancada?","Automacao de Processo")
      Processa({||U_HCPMN2()},"EMin","Atualizando dados, aguarde...")
    endif
  endif
return .T.

User function HCPMN2()
  Local nItens
  Local cCodA
  dbSelectArea("SB1")
  dbSetOrder(1)
  ProcRegua(LEN(aAvancada))
  for nItens:=1 to len(aAvancada)
    cCodA:=SUBSTR(aAvancada[nItens],6,15)
    MsSeek(xFilial("SB1")+cCodA)
    IF (!Eof() .And. sb1->b1_FILIAL == xFilial("SB1") .And.;
        SB1->B1_COD	== cCodA)
      RecLock("SB1",.F.)
      SB1->B1_ESTSEG:=cEstMin
      MsUnLock()
    endif
    IncProc("Alt. Est Min. Prod:" + cCodA)
  next
  MsgInfo("Estoque Minimo Alterado com Sucesso...", "Processo finalizado")
RETURN .T.
/*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120B3   ºAutor  ³Robson Bueno        º Data ³  13/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Amarrar Oc a PV                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RAPOSPV()
  Local aArea		:= GetArea()
  Local lConfirma := .f.
  Static cRegistro
  sTATIC oBold
  Static cC7Tpc:="OS"		// TIPO2
  Static cC7Num		    	// NUMERO OC
  Static cC7Item			  // ITEM Oc
  Static cC7Nfor			  // FORNECEDOR
  Static nC7Qtd 			  // QUANTIDADE CASADA
  Static dC7Prz			    // PRAZO ENTRADA
  Static cCodocpv				// Codigo do Produto da OC
  Static cDesPrOs
  Private INCLUI := .F.
  Private Odlg5
  Private oGet999
  Private cCodForn:=""
  Private cLoja   :=""
  Private cDesForn:=""
  Private cOcpv     :=SUBSTR(cboPoS,9,6)
  PRIvATE cItemOcpv := SUBSTR(cboPoS,16,2)
  nSdep :=0
  DbSelectArea("AB6")
  dbSetOrder(1)
  MsSeek(xfilial("AB6")+cOcPv)
  cDesForn:=Posicione("SA2",1,xFilial("SA2")+AB6->AB6_CODCLI+AB6->AB6_LOJA,"A2_NREDUZ")
  cCodForn:= AB6->AB6_CODCLI
  cLoja	  := AB6->AB6_LOJA
  DEFINE FONT oBold NAME "MS Sans Serif" SIZE 0, -9 BOLD
  DEFINE MSDIALOG oDlg5 TITLE OemtoAnsi("Processos Amarrados a Ordem de Servico") FROM C(178),C(181) TO C(605),C(763) PIXEL
  DbSelectArea("AB7")
  dbSetOrder(1)
  MsSeek(xfilial("AB7")+cOcPv+cItemOcPV)
// CARREGANDO DADOS DA OC PARA POSSIVEL GRAVACAO DE AMARRACAO DE OC COM PV
  cC7Num	:=cOcPV
  cC7Item	:=cItemOcPV
  cC7Nfor	:=cDesForn
  nC7Qtd 	:=AB7->AB7_QTENT
  dC7Prz	:=AB7->AB7_PRAZOV
  cCodocpv:=AB7->AB7_CODPRE
  cDesPrOs:= Posicione("SB1",1,xFilial("SB1")+cCodocpv,"B1_DESC")
/*
DbSelectArea("SC7") aColsAnt1[nElemAnt1,1]
SC7->(DbSetOrder(1))
*/
  @ C(004),C(005) Say "OC.  : " + cOcPV + " - " + "Fornecedor : " + cCodForn + "-" + cLoja + "-" + cDesForn Size C(284),C(008) FONT oBold COLOR CLR_BLACK PIXEL OF oDlg5
  @ C(014),C(005) Say "Item.: " + cC7Item + " - " + "Codigo: " + cCodocpv + " - Descr: " + cDesPrOs + " - SALDO: " + STR(nC7Qtd) + " - Prazo: "+ SUBSTR(DTOS(dC7Prz),7,2)+"/"+SUBSTR(DTOS(dC7Prz),5,2)+"/"+SUBSTR(DTOS(dC7Prz),1,4) Size C(284),C(008) COLOR CLR_BLUE PIXEL OF oDlg5

  nSdep:=AB7->AB7_QTENT

  GetDocOsPv()

  @ C(191),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF oDlg5

//ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {||_oDlg:End()},{||_oDlg:End()},,)
  ACTIVATE MSDIALOG oDlg5 CENTERED  ON INIT EnchoiceBar(oDlg5, {|| (lConfirma := .t.,oDlg5:End())},{||oDlg5:End()},,)
  If lConfirma .AND. 0=1 // PARADA DE ROTINA .... NAO VALIDA DE JEITO NENHUM
    FOR nLin:=1 to len(ACOLOCPV)
      IF ACOLOCPV[nLin,10]="MAN" .OR. ACOLOCPV[nLin,7]>0
        dbSelectArea("SZK")
        DbSetOrder(4)
        IF MsSeek(xFilial("SZK")+"OS"+cC7num+substr(cC7Item,2,3)+"PV"+ACOLOCPV[nLin,2]+ACOLOCPV[nLin,3])
          Reclock("SZK",.F.)
        ELSE
          Reclock("SZK",.T.)
          SZK->ZK_DT_VINC:=date()          		   		// DATA DA VINCULACAO
        ENDIF
        SZK->ZK_FILIAL :=xfilial("SZK")
        SZK->ZK_TIPO   :="PV"                       	// TIPO
        SZK->ZK_REF    :=ACOLOCPV[nLin,2]           	// PEDIDO
        SZK->ZK_REFITEM:=ACOLOCPV[nLin,3]           	// ITEM PEDIDO
        SZK->ZK_NOME   :=ACOLOCPV[nLin,4]           	// CLIENTE
        SZK->ZK_COD    :=ACOLOCPV[nLin,9]            // CODIGO PRODUTO
        SZK->ZK_DESCRI :=ACOLOCPV[nLin,10]          	// DESCRICAO
        SZK->ZK_QTD    :=ACOLOCPV[nLin,5]           	// QUANTIDADE VENDA
        SZK->ZK_PRAZO  :=ACOLOCPV[nLin,6] 	         	// PRAZO VENDA
        SZK->ZK_TIPO2  :="OC"            	         	// TIPO2
        SZK->ZK_OC     :=cC7num			              	// NUMERO OS
        SZK->ZK_ITEM   :=substr(cC7Item,2,3)        	// ITEM OS
        SZK->ZK_FORN   :=cC7Nfor   			          	// FORNECEDOR
        SZK->ZK_QTC    :=ACOLOCPV[nLin,7]  	       	// QUANTIDADE CASADA
        SZK->ZK_PRAZOC :=dC7Prz			              	// PRAZO ENTRADA
        IF ACOLOCPV[nLin,8]=0
          SZK->ZK_QTS    :=0                     	   // QUANTIDADE PENDENTE
          SZK->ZK_DT_BX  :=DATE()
          SZK->ZK_STATUS :="4"							          // STATUS DA OS
        ELSE
          SZK->ZK_QTS    :=ACOLOCPV[nLin,8]         	// QUANTIDADE PENDENTE
          SZK->ZK_STATUS :="1"
        ENDIF
        SZK->ZK_CONTROL:="RAP"							// METODO
        MsUnLock()

      ENDIF
      dbSelectArea("SZK")
    next
  ENDIF
  RestArea(aArea)
Return(.T.)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³GetDocs1()  ³ Autor ³ Robson Bueno          ³ Data ³13/02/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados - Compras Casadas                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetDocOsPv()
Local aArea		:= GetArea()
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZK_TIPO","ZK_REF","ZK_REFITEM","ZK_NOME","ZK_QTD","ZK_PRAZO","ZK_QTC","ZK_QTS", "ZK_COD","ZK_DESCRI","ZK_CONTROL"}                                                                                                
Local aAlter       	:= {"ZK_TIPO","ZK_REF","ZK_REFITEM","ZK_NOME","ZK_QTD","ZK_PRAZO","ZK_QTC","ZK_QTS", "ZK_COD","ZK_DESCRI","ZK_CONTROL"} 
Local nSuperior    	:= C(025)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(191)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE                                                                          
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_TdObsrap()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "U_RPVLOCPV()"   // Funcao executada na validacao do campo   "U_RPVLOCPV()"                                         
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= odlg5                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
aColOcPv 	          := {}              
                                                                                                                                
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
  For nX := 1 to Len(aCpoGDa)
    If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
    ENDIF
  Next nX
// Carrega aCol                                                                                         
DbSelectArea("SZK")                                                                                                             
SZK->(DbSetOrder(4)) // Campo                                                                                                   
  if SZK->(DbSeek(xFilial("SZK")+"OS" + AB6->AB6_NUMOS + AB7->AB7_ITEM+' '))
    While xFilial("SZK") == SZK->ZK_FILIAL .and. ! SZK->(Eof()) .and. SZK->ZK_OC == AB6->AB6_NUMOS .AND. AB7->AB7_ITEM==substr(SZK->ZK_ITEM,1,2)
		aAdd(aColOcPv,{SZK->ZK_TIPO,SZK->ZK_REF,SZK->ZK_REFITEM,SZK->ZK_NOME,SZK->ZK_QTD,SZK->ZK_PRAZO,SZK->ZK_QTC,SZK->ZK_QTS,ZK_COD,ZK_DESCRI,ZK_CONTROL,.F.})
		nSdep:=nSdep-SZK->ZK_QTS
		SZK->(DbSkip())
    EndDo
                                                                               
  Else
    aAux := {}
    DbSelectArea("SX3")                                                                                                             
    SX3->(DbSetOrder(2)) // Campo  
    For nX := 1 to Len(aCpoGDa)
      If DbSeek(aCpoGDa[nX])
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
      Endif
    Next nX
    Aadd(aAux,.F.)
    Aadd(aColOcPv,aAux)                                                                                                            
  Endif
cLinhaOk:="U_RPVLOCPV()"
cCampoOk:= "AllwaysTrue"
                                       
oGet947 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,NOPC,cLinhaOk,{|| U_TdObsrap()},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColOCPV)  
                             
 //        MsGetDados(): New ( < nTop>, < nLeft>, < nBottom>, < nRight>, < nOpc>, [ cLinhaOk], [ cTudoOk], [ cIniCpos],;
 //                          [ lDeleta], [ aAlter], [ nFreeze], [ lEmpty], [ nMax], [ cFieldOk], [ cSuperDel], [ uPar], [ cDelOk], [ oWnd], [ lUseFreeze], [ cTela] )                                 
oGet947.refresh
RestArea(aArea)
Return Nil                                                                                                                      

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RCM14A1   ³ Autor ³ ROBSON BUENO          ³ Data ³02.10.07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ALIMENTA CAMPOS CONFORME PARAMETROS INFORMADOS              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhuma                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RPVLOSPV()
  Local aArea     := GetArea()  
  LOCAL lRet:=.T.  
  //Local cVar:="OC"
  IF M->ZK_REF<>"      "
    M->ZK_REF    	:=SC6->C6_NUM
    M->ZK_REFITEM	:=SC6->C6_ITEM
    M->ZK_COD	 	:=SC6->C6_PRODUTO
    IF SUBSTR(SC6->C6_NUM,1,1)="B" .OR. SUBSTR(SC6->C6_NUM,1,1)="D"
      M->ZK_NOME:=Posicione("SA2",1,xFilial("SA2")+SC6->C6_CLI+SC6->C6_LOJA,"A2_NREDUZ")
    ELSE
      M->ZK_NOME:=Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NREDUZ")
    ENDIF
    M->ZK_DESCRI := SC6->C6_DESCRI
    M->ZK_QTD	   := SC6->C6_QTDVEN 
    M->ZK_PRAZO  := SC6->C6_ENTREG
    M->ZK_TIPO2  :="OC"            	           	// TIPO2 
    M->ZK_OC     :=cC7num			                	// NUMERO OS
    M->ZK_ITEM   :=substr(cC7Item,2,3)          // ITEM OS
    M->ZK_FORN   :=cC7Nfor   			         	    // FORNECEDOR
    M->ZK_QTC    :=SC6->C6_QTDVEN 	            // QUANTIDADE CASADA
    M->ZK_QTS    :=SC6->C6_QTDVEN 	            // QUANTIDADE CASADA
    M->ZK_CONTROL:="RAP"
    M->ZK_PRAZOC :=dC7Prz			                	// PRAZO ENTRADA  
    aAdd(aColOcPv,{"PV",M->ZK_REF,M->ZK_REFITEM,M->ZK_NOME,M->ZK_QTD,M->ZK_PRAZO,M->ZK_QTC,M->ZK_QTS,M->ZK_COD,M->ZK_DESCRI,M->ZK_CONTROL,.F.})
    nSdep:=nSdep-M->ZK_QTS
   // @ C(191),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF oDlg5
  EndIf
  IF nSdep<0
    nSdep:=nSdep+M->ZK_QTS              
    MsgInfo("OC/OS N." + M->ZK_OC +"/"+ M->ZK_ITEM + " nao tem saldo, portanto nao e possivel amarrar Processos")
   // @ C(191),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF oDlg5
    lRet:=.F.
  ENDIF
  RestArea(aArea)
  oGet947.refresh
RETURN (lRet)


 