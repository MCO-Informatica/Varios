#INCLUDE 'PROTHEUS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ HCIA010  บAutor  ณ Bianca Massarotto  บ Data ณ  02/01/07	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Produtos Alternativos                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HCIA010()

  Private cCadastro := 'Produtos Alterantivos'
  Private cDelFunc  := '.T.'
  Private aRotina   := {}

  aAdd( aRotina, { 'Pesquisar'  , 'AxPesqui', 0, 1 } )
  aAdd( aRotina, { 'Visualizar' , 'U_HCI010A', 0, 2 } )
  aAdd( aRotina, { 'Incluir'    , 'U_HCI010A', 0, 3 } )
  aAdd( aRotina, { 'Alterar'    , 'U_HCI010A', 0, 4 } )
  aAdd( aRotina, { 'Excluir'    , 'U_HCI010A', 0, 5 } )
  dbSelectArea('PA1')
  dbSetOrder(1)
  mBrowse( ,,,,'PA1')


Return NIL

/*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ HCI010A  บAutor  ณ Bianca Massarotto  บ Data ณ  02/01/07	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela de Manutencao do Cadastro de Produtos Alternativos    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function HCI010A( cAlias, nReg, nOpc )

Local aArea := PA1->( GetArea() )
Local   nX			   := 0
Local   nSuperior    := 040
Local   nEsquerda    := 008
Local   nInferior    := 130
Local   nDireita     := 386
Local   nOpcGet      := GD_INSERT+GD_DELETE+GD_UPDATE
Local   cLinOk       := "U_VldGetD(oGetD:aCols[oGetD:nAt][1],oGetD:aCols[oGetD:nAt][3])"
Local   cTudoOk      := "AllwaysTrue"
Local   cIniCpos     := ""
Local   nFreeze      := 000
Local   nMax         := 999
Local   cFieldOk     := "AllwaysTrue"
Local   cSuperDel    := ""
Local   cDelOk       := "AllwaysTrue"
Local   aButtons     := {}
Private aCpoCab      := {"PA1_PROD","PA1_DESC","PA1_ALTERN", "PA1_DSCALT"}
Private aAlter       := {"PA1_PROD","PA1_DESC","PA1_ALTERN", "PA1_DSCALT"}
Private aHead        := {}
Private aCols        := {}
Private oDlg
Private cGet1	      := Criavar("B1_COD")
Private cGet2	      := Criavar("B1_DESC")
Private cGet3	      := Criavar("B1_COD")
Private cGet4	      := Criavar("B1_DESC")
Private oGet1
Private oGet2
Private oGet3
Private oGet4
Private oGetD

// Carrega aHead
DbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
For nX := 1 to Len(aCpoCab)
	If SX3->(DbSeek(aCpoCab[nX]))
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


dbSelectArea( "PA1" )
dbsetorder(1)

If INCLUI
	Private M->PA1_PROD   := Criavar( 'PA1_PROD' )
	Private M->PA1_DESC   := Criavar( 'PA1_DESC' )
	Private M->PA1_ALTERN := Criavar( 'PA1_ALTERN' )
	Private M->PA1_DSCALT := Criavar( 'PA1_DSCALT' )
	CriaCols( nOpc, cGet1 )
	
Else
	
	cGet1 := PA1->PA1_PROD
	cGet2 := PA1->PA1_DESC
	cGet3 := PA1->PA1_ALTERN
	cGet4 := PA1->PA1_DSCALT
	If (cAlias)->( RecCount() ) == 0
		Return NIL
	EndIf
	Private M->PA1_PROD := PA1->PA1_PROD
	Private M->PA1_DESC := PA1->PA1_DESC
	Private M->PA1_ALTERN := PA1->PA1_ALTERN
	Private M->PA1_DSCALT := PA1->PA1_DSCALT
	
	CriaCols( nOpc, cGet1)
	
EndIf


DEFINE MSDIALOG oDlg TITLE "Produtos Alternativos" FROM 178,181 TO 665,967 PIXEL

@ 020,007 Say "Codigo" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 018,028 MsGet oGet1 Var cGet1 Size 050,009 COLOR CLR_BLACK Picture "@!" F3 "SB1" VALID VldGet1(cGet1,cGet3) WHEN If(Empty(cGet1),.T.,.F.) PIXEL OF oDlg

@ 020,104 Say "Descricao " Size 025,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 018,133 MsGet oGet2 Var cGet2 Size 100,009 COLOR CLR_BLACK WHEN .F. PIXEL OF oDlg

oGetD:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpcGet,cLinOk,cTudoOk,cIniCpos,aAlter,;
nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDlg,aHead,aCols)
oGetD:oBrowse:bEditCol:={ ||oGetD:oBrowse:GoRight(),oGetD:LinhaOk()}

ACTIVATE MSDIALOG oDlg CENTERED  ON INIT EnchoiceBar( oDlg,;
{ ||If( .T., GravaPA1( nOpc ),.F. ) },;
{ ||oDlg:End() },,aButtons )

RestArea( aArea )
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldGet1  บAutor  ณBianca Massarotto   บ Data ณ  03/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de validacao da MSGet                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

Static Function VldGet1(cProd,cProd2)
Local lRet  := .T.

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbGoTop())

If DbSeek( xFilial("SB1") + ALLTRIM(cProd) )
	cGet2:= U_A010Desc(ALLTRIM(cProd))
	cGet4:= U_A010Desc(ALLTRIM(cProd2))
Else
	MsgAlert("Produto inexistente!")
	lRet := .F.
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldGetD  บAutor  ณBianca Massarotto   บ Data ณ  03/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de validacao da Getdados                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldGetD(cProd,cProd2)
Local lRet := .T.
Local nC   := 1

If oGetD:aCols[oGetD:nAt][5]  //Se item deletado, nao precisa validar
	Return lRet
EndIf

DbSelectArea("SB1")
SB1->( DbSetOrder(1) )
SB1->( DbGoTop() )

If !DbSeek(xFilial("SB1") + ALLTRIM(oGetD:aCols[oGetD:nAt][1]))
	MsgAlert("Produto inexistente!")
	lRet := .F.
EndIf

If ALLTRIM(oGetD:aCols[oGetD:nAt][1]) ==  ALLTRIM(oGetD:aCols[oGetD:nAt][3])
	MsgAlert( "O produto alternativo nใo pode ser igual ao produto principal" )
	lRet := .F.
EndIf


While nC < oGetD:nAt
	
	If ALLTRIM(oGetD:aCols[nC][3]) == ALLTRIM(oGetD:aCols[oGetD:nAt][3])
		MsgAlert( "Nใo pode haver produtos iguais" )
		lRet := .F.
	EndIf
	
	nC += 1
	
EndDo

If lRet .AND. INCLUI .OR. ALTERA
	oGetD:aCols[oGetD:nAt][2]:= U_A010Desc(ALLTRIM(cProd))
	oGetD:aCols[oGetD:nAt][4]:= U_A010Desc(ALLTRIM(cProd2))
EndIf

oGetD:oBrowse:Refresh()

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A010Desc บAutor  ณBianca Massarotto   บ Data ณ  03/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de preenchimento do campo descricao                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function A010Desc(cProd)
Local cRet  := ""
Local aArea := SB1->( GetArea() )

dbselectarea("SB1")
DbSetOrder(1)
If ( DbSeek( xFilial("SB1") + cProd ) )
	cRet := SB1->B1_DESC
EndIf

RestArea( aArea )

Return cRet

/*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GravaPA1 บAutor  ณBianca Massarotto   บ Data ณ  03/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de gravacao da tabela PA1                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaPA1( nOpc )
Local aArea		:= GetArea()
Local nC     	:= 1
Local lRet      := .F.

If INCLUI .OR. ALTERA
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValidacao no Botao OK   ณRafael Marin - 22/03
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If Len(oGetD:aCols) <= 0  //Controle de Planilha Vazia
		Return NIL
	EndIf
	
	While Len(oGetD:aCols) >= nC
		lRet := U_VldGetD(oGetD:aCols[nC][1],oGetD:aCols[nC][3])
		If !lRet
			Return NIL
		EndIf
		nC += 1
	Enddo
	
	nC := 1
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualizacao do Cabecalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea( "PA1" )
	dbSetOrder(1)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDescarga dos campos na tabelaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While Len(oGetD:aCols) >= nC
		PA1->(dbGoTop())
			If DbSeek( xFilial( "PA1" ) + ALLTRIM(oGetD:aCols[nC][1]) + ALLTRIM(oGetD:aCols[nC][3]) ).And. oGetD:aCols[nC][5]
				RecLock( "PA1",.F. )
				DbDelete()
				MsUnLock()
			EndIf
		nC += 1
	EndDo
	nC := 1
	While Len(oGetD:aCols) >= nC
		PA1->(dbGoTop())
		If !DbSeek( xFilial( "PA1" ) +ALLTRIM(oGetD:aCols[nC][1]) + ALLTRIM(oGetD:aCols[nC][3]) ) .And. !oGetD:aCols[nC][5]
			RecLock( "PA1",.T. )
			PA1->PA1_FILIAL := xFilial( "PA1" )
			PA1->PA1_PROD   := ALLTRIM(oGetD:aCols[nC][1])
			PA1->PA1_DESC   := ALLTRIM(oGetD:aCols[nC][2])
			PA1->PA1_ALTERN := ALLTRIM(oGetD:aCols[nC][3])
			PA1->PA1_DSCALT := ALLTRIM(oGetD:aCols[nC][4])
			MsUnLock()
		ELSE
            RecLock( "PA1",.F. )
			PA1->PA1_FILIAL := xFilial( "PA1" )
			PA1->PA1_PROD   := ALLTRIM(oGetD:aCols[nC][1])
			PA1->PA1_DESC   := ALLTRIM(oGetD:aCols[nC][2])
			PA1->PA1_ALTERN := ALLTRIM(oGetD:aCols[nC][3])
			PA1->PA1_DSCALT := ALLTRIM(oGetD:aCols[nC][4])
			MsUnLock()
        ENDIF
		nC += 1
	Enddo
	If Inclui
		DbSelectArea( "PA1" )
		RecLock( "PA1",.T. )
		PA1->PA1_PROD  := ALLTRIM(cGet3)
		PA1->PA1_DESC  := ALLTRIM(cGet4)
		MsUnLock()
	EndIf
	
ElseIf aRotina[nOpc][4] == 5 //Exclusao
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณApaga registro do PA1ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea( "PA1" )
	DbSetOrder(1)
	
	While DbSeek( xFilial( "PA1" ) + PA1->PA1_PROD )
		RecLock( "PA1",.F. )
		DbDelete()
		MsUnLock()
	EndDo
	/*
	DbSelectArea( "TRB" )
	RecLock( "TRB",.F. )
	DbDelete()
	MsUnLock()
	*/

EndIf

RestArea( aArea )

oDlg:End()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCRIACOLS  บAutor  ณ Bianca Massarotto  บ Data ณ  03/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Criacao do aCols                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

Static Function CriaCols( nOpcX, cCodProd)
Local aArea  := GetArea()
Local nLinha := 0

PA1->( dbSetOrder( 1 ) )
PA1->( dbSeek( xFilial( 'PA1' )  +  cCodProd) )

If nOpcX == 3
	cCond :=  'nLinha < 1'
Else
	cCond :=  'PA1->PA1_FILIAL  +  PA1->PA1_PROD == xFilial( "PA1" )  +  "' + cCodProd+ '" '
EndIf


While !PA1->( EOF() ) .AND. &cCond
	
	aAdd( aCols, Array( Len( aHead ) + 1 ) )
	
	nLinha++
	nUsado:=0
	
	SX3->( dbSeek( 'PA1' ) )
	While !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'PA1'
		
		If X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL .AND. ;
				aScan( aCpoCab, Trim( SX3->X3_CAMPO ) ) <> 0
			nUsado++
			
			If     SX3->X3_CONTEXT == "V" .or. nOpcX == 3
				aCols[nLinha][nUsado] := CriaVar( aHead[nUsado][2], .T. )
				
			ElseIf SX3->X3_CONTEXT <> "V"
				aCols[nLinha][nUsado] := FieldGet( FieldPos( aHead[nUsado][2] ) )
				
			EndIf
			
		EndIf
		
		aCols[nLinha][nUsado+1] := .F.
		SX3->( dbSkip() )
	End
	
	If nOpcX <> 3
		aAdd( aAlter, PA1->( Recno() ) )
	EndIf
	
	PA1->( dbSkip() )
End

RestArea( aArea )

Return NIL
////////////////////////////////////////////////////////////////////////////

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMa075Pesq ณ Autor ณAlexandre Silva        ณ Data ณ 12.12.02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Funcao para pesquisa                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ Ma075Pesq(ExpC1,ExpN1,ExpN2)                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Alias do arquivo                                   ณฑฑ
ฑฑณ          ณ ExpN1 = Numero do registro                                 ณฑฑ
ฑฑณ          ณ ExpN2 = Numero da opcao selecionada                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Mata075                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/*
User Function 010Pesq(cAlias,nReg,nOpcx)

Local cOrd		:= ""
Local cCampo	:= Space(40)
Local nOpca		:=0
Local nOpt1		:=0
Local nI			:=0
Local aOrd 		:= {"Produto"}
Local bSav12 	:= SetKey(VK_F12)
Local oDlg
Local oCbx

SetKey( VK_F12, {||nil} )

cOrd := aOrd[1]

For ni:=1 to Len(aOrd)
	aOrd[nI] := OemToAnsi(aOrd[nI])
Next

If IndexOrd() >= Len(aOrd)
	cOrd 	:= aOrd[Len(aOrd)]
	nOpt1 := Len(aOrd)
ElseIf IndexOrd() <= 1
	cOrd := aOrd[1]
	nOpt1 := 1
Else
	cOrd := aOrd[1]
	nOpt1 := IndexOrd()
EndIf

DEFINE MSDIALOG oDlg FROM 5, 5 TO 14, 50 TITLE OemToAnsi("Buscar") //"Buscar"
@ 0.6,1.3 COMBOBOX oCBX VAR cOrd ITEMS aOrd  SIZE 165,44  ON CHANGE (nOpt1:=oCbx:nAt)  OF oDlg FONT oDlg:oFont
@ 2.1,1.3	MSGET cCampo SIZE 165,10
DEFINE SBUTTON FROM 055,122	TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 055,149.1 TYPE 2 ACTION (oDlg  :End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	dbSelectArea(cAlias)
	nReg := RecNo()
	dbSetOrder(nOpt1)
	
	MsSeek(Alltrim(cCampo),.T.)
	If ! Found()
		Help(" ",1,"PESQ01")
		MsGoTo(nReg)
	EndIf
Else
	DbSelectArea(cAlias)
EndIf

lRefresh := .T.
SetKey(VK_F12,bSav12)

Return
