#Include "Protheus.ch"


User Function F240Fil()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cFiltro := ""
Local cBarraMesmoBanco := ' ( Substr( E2_CODBAR, 1, 3) == "' + cPort240 + '" ) '
Local cSemCodigoBarras := ' ( Empty(E2_CODBAR)) '
Local nValorMinTED     :=   Val(GetNewPar("MV_X_TETO", "1000"))
Local cValorMinTED     := ' ( E2_SALDO >= ' + Alltrim(Str(nValorMinTED)) + ' ) '
Local cConcessionarias := ' (Substr(E2_CODBAR, 1, 1) == "8" ) '
Local cFornUniao       := ' (E2_FORNECE = "' + Pad("UNIAO", Len(SE2->E2_FORNECE)) + '" ) '
Local cFornINPS        := ' (E2_FORNECE = "' + Pad("INPS" , Len(SE2->E2_FORNECE)) + '" ) '
Local cFornMesmoBco    := ' '
Local cFiltroForn      := ' '

Local lManterPadrao    := ! DlgChkBox("Deseja usar filtro customizado (automatico)", "Usar Filtro Automatico", .T., "Prosseguir")

If lManterPadrao
	Return("")
Endif

If cModPgto $ "01;03;41"
	cFornMesmoBco := FornBanco(cPort240, cModPgto == "01")
	If ! Empty(cFornMesmoBco)
		cFiltroForn := ' (E2_FORNECE + E2_LOJA $ "' + cFornMesmoBco + '") '
		cFiltroForn += " .And. "
	Endif
Endif

If     cModPgto == "01" // (Crédito em conta banco - mesmo banco que o bordero e sem código de barras)
	//	cFiltro := " cSemCodigoBarras + " .And. " +         cForneMesmoBanco  + " .And. " + Toggle(cFornUniao) + " .And. " + Toggle(cFornINPS)
	//	cFiltro := ' E2_FORNECE = "' + Pad("000021", Len(SE2->E2_FORNECE))  + '" '
	cFiltro := cFiltroForn + cSemCodigoBarras + " .And. " + Toggle(cFornUniao) + " .And. " + Toggle(cFornINPS)
ElseIf cModPgto == "03" // (Doc - valor abaixo que o parametro - banco diferente do bordero e sem código de barras)
	cFiltro := cSemCodigoBarras + " .And. " +  Toggle(cValorMinTED) + ' .And. ' + cFiltroForn + Toggle(cFornUniao) + " .And. " + Toggle(cFornINPS)
ElseIf cModPgto == "13" // (Concessionarias - primeiro digito do código de barras igual a 8)
	//	cFiltro := ' E2_FORNECE = "000021" '
	//	cFiltro := ' E2_FORNECE = "' + Pad("000021", Len(SE2->E2_FORNECE))  + '" '
	cFiltro := Toggle(cSemCodigoBarras) + " .And. " + cConcessionarias
ElseIf cModPgto == "16" // (DARF - Fornecedor UNIAO e Tipo TX)
	cFiltro := cFornUniao + ' .And. E2_TIPO == "' + Pad("TX", Len(SE2->E2_TIPO)) + '" '
ElseIf cModPgto == "17" // (INPS/GPS - Fornecedor INPS  e Tipo INS)
	cFiltro := cFornINPS  + ' .And. E2_TIPO == "' + Pad("INS", Len(SE2->E2_TIPO)) + '" '
ElseIf cModPgto == "30" // (Boleto com banco igual ao usado no borderô - 3 primeiros digitos do código de barras)
	cFiltro :=        cBarraMesmoBanco  + " .And. " + Toggle(cFornUniao) + " .And. " + Toggle(cFornINPS)
ElseIf cModPgto == "31" // (Boleto com banco diferente do usado no borderô - 3 primeiros digitos do código de barras)
	cFiltro := Toggle(cBarraMesmoBanco) + " .And. " + Toggle(cSemCodigoBarras) + " .And. " + Toggle(cFornUniao) + " .And. " + Toggle(cFornINPS)
ElseIf cModPgto == "41" // (TED - valor maior ou igual ao parametro)
	cFiltro := cSemCodigoBarras + " .And. " +         cValorMinTED  + " .And. " + cFiltroForn + Toggle(cFornUniao) + " .And. " + Toggle(cFornINPS)
Endif

/*
If ! Empty(cFiltro)
	cFiltro += " .And. "
Endif
cFiltro += " Empty(E2_PORTADO) "
 */ 
 
/*
ElseIf cModPgto == "19" // (ISS - E2_TIPO = ISS)
cFiltro := ' E2_TIPO == "' + Pad("ISS", Len(SE2->E2_TIPO)) + '" '
*/

Return(cFiltro)

Static Function Toggle(cExpr)
Return(" (! " + cExpr + ") ")

Static Function FornBanco(cBanco, lMesmoBanco)
Local aSavAre   := GetArea()
Local cQuery
Local cAliasTop := "TRB_A2E2"
Local cForn     := ""

cQuery := " SELECT E2_FORNECE, E2_LOJA, A2_BANCO " + ;
" FROM " + RetSqlName("SE2") + " SE2, " + RetSqlName("SA2") + " SA2 " + ;
" WHERE SE2.E2_SALDO > 0 AND SE2.E2_NUMBOR = ' '  AND " + ;
" SA2.A2_COD = SE2.E2_FORNECE AND SA2.A2_LOJA = SE2.E2_LOJA AND " + ;
" SA2.A2_BANCO " + If(lMesmoBanco, "=", "<>") +  " '" + cBanco + "' AND " + ;
" SA2.A2_BANCO <> ' ' AND " + ;
" SE2.E2_FILIAL = '" + xFilial("SE2") + "' AND SE2.D_E_L_E_T_ = ' ' AND " + ;
" SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.D_E_L_E_T_ = ' ' "     + ;
" GROUP BY E2_FORNECE, E2_LOJA, A2_BANCO "

If Select(cAliasTop) > 0
	(cAliasTop)->(dbCloseArea())
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTop, .F., .T.)

Do While ! Eof()
	cForn += ";" + (cAliasTop)->E2_FORNECE + (cAliasTop)->E2_LOJA
	dbSkip()
Enddo
(cAliasTop)->(dbCloseArea())

RestArea(aSavAre)

If ! Empty(cForn)
	cForn := Substr(cForn, 2)
Endif

Return(cForn)


Static Function DlgChkBox(cTitulo, cCheckBox, lCheckBox, cTextoBotao)
Local oDlg           := Nil
Local nLineButton    := Nil
Local nColButton     := Nil
Local nSpaceButton   := 2

Local nWidthButton   :=  42
Local nDlgWidth      := 380
Local nDlgHeight     := 120

Local oChkBox        := Nil

Default lCheckBox    := .F.
Default cTextoBotao  := "Fecha"

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to nDlgHeight, nDlgWidth  PIXEL

nLineButton := __DlgHeight(oDlg) - 24
nColButton  := __DlgWidth( oDlg) -  4

@ nLineButton - 25, 10 CheckBox oChkBox Var  lCheckBox Prompt cCheckBox Message cCheckBox Size 80, 007 Pixel Of oDlg

TButton():New(nLineButton    , nColButton - (1 * (nWidthButton + nSpaceButton)), cTextoBotao, oDlg,{|| oDlg:End()}                                                                                  ,nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED

Return(lCheckBox)

