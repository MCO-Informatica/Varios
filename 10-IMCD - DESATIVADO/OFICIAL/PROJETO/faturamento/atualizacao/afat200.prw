#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#define _LIDLG		aSize[ 7 ]
#define _CIDLG		0
#define _LFDLG		aSize[ 6 ]
#define _CFDLG		aSize[ 5 ]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFAT200   ºAutor  ³Ivan Morelatto Tore ³Data  ³ 29/12/09    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para Amostras                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                            MANUTENCAO                                 º±±
±±ÌÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º SEQ  ³ DATA       | DESCRICAO                                         º±±
±±ÌÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 001  ³ 02/12/2015 | JUNIOR CARVALHO - Validar linha a linha se os     º±±
±±º      ³            | produtos são compativeis                          º±±
±±ÈÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AFAT200

	Local aCores := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "AFAT200" , __cUserID )

	Private cTitulo := "Controle de Amostras"
	Private cCadastro := "Controle de Amostras"
	Private aRotina := MenuDef()

	aCores := { {'ZX3_STATUS=="1"' , 'ENABLE'  },;
	{'ZX3_STATUS=="2" .And. !Posicione("SD2",8,xFilial("SD2")+ZX3->ZX3_PEDIDO,"FOUND()")' , 'DISABLE' },;
	{'Posicione("SD2",8,xFilial("SD2")+ZX3->ZX3_PEDIDO,"FOUND()") .And. ZX3->ZX3_PEDIDO <> "      "' , 'BR_AZUL' },;
	{'ZX3_STATUS=="2" .And. EMPTY(ZX3->ZX3_PEDIDO) ' , 'BR_PRETO' }	 }

	Private aSize := MsAdvSize( .T., SetMDIChild() )

	MBrowse(,,,,"ZX3" ,,,,,, aCores)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Fun‡…o    ³AFT20Man  ?Autor ?Ivan Morelatto Tore   ?Data ?30/07/09 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ³Manutencao no Cadastro de Amostras                          ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Sintaxe e ³AFT20Naan()                                                 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?Uso      ?AFAT200                                                    ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
User Function AFT20Man( cAlias, nReg, nOpc )

	Local nOpca		:= 0
	Local nSaveSx8 	:= GetSx8Len()
	Local nAux1		:= 0
	Local nAux2		:= 0
	Local nLoop		:= 0
	Local nCntFor	:= 0

	Local oDlgZX3

	Local oFolder
	Local aPages    := { "HEADER" }
	Local aTitles	:= { "Itens da Amostra" }

	Local aHeadZX4 := {}
	Local aColsZX4 := {}
	Local aRecsZX4 := {}
	Local nGetCnt  := 0

	Local nTipoGD	:= If( nOpc != 2 .and. nOpc != 5, GD_INSERT + GD_DELETE + GD_UPDATE, 0 )
	Local bBloco	:= { || .T. }

	Local nPosCod	:= 0
	Local nPosDes	:= 0
	Local nPosUM	:= 0
	Local i := 0

	Private aTela 	:= {}
	Private aGets	:= {}
	Private aMemoGRv:= {}
	Private nM		:= 0
	Private nN		:= 0
	Private nI		:= 0
	Private nP		:= 0

	RegToMemory( "ZX3", nOpc == 3 )

	FillGetDados( nOpc, 'ZX4', 1, xFilial("ZX4") + ZX3->ZX3_NUM, { || ZX4->ZX4_FILIAL + ZX4->ZX4_NUM }, Nil, { "ZX4_NUM" }, Nil, Nil, Nil, Nil, nOpc == 3, aHeadZX4, aColsZX4 )

	If nOpc == 3
		If ( nAux1 := GDFieldPos( 'ZX4_ITEM', aHeadZX4) ) > 0 .And. Len(aColsZX4) > 0
			aColsZX4[1,nAux1] := StrZero( 1, TamSX3( 'ZX4_ITEM' )[1] )
		Endif

	ElseIf ( nAux1 := GDFieldPos( 'ZX4_REC_WT', aHeadZX4 ) ) > 0
		aEval( aColsZX4, { | _aCol | aAdd( aRecsZX4, _aCol[nAux1] ) } )
	Endif
	nH := ascan(aHeadZX4,{|x| alltrim(x[2]) =='ZX4_HISTOR'})
	nM := ascan(aHeadZX4,{|x| alltrim(x[2]) =='ZX4_OBS'})
	nI := ascan(aHeadZX4,{|x| alltrim(x[2]) =='ZX4_ITEM'})
	nP := ascan(aHeadZX4,{|x| alltrim(x[2]) =='ZX4_PRODUT'})

	DEFINE MSDIALOG oDlgZX3 TITLE "teste de local" FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL
	oEncZX3 := MsMget():New( "ZX3" , nReg, nOpc,,,,,,,,,, oDlgZX3 )

	nGetCnt := aScan(oEncZX3:aGets, {|x| "ZX3_CODCNT" $ x})
	oEncZX3:aEntryCtrls[nGetCnt]:bF3 := {|| oEncZX3:aEntryCtrls[nGetCnt]:cText := PESQCNT("SA1", M->ZX3_CLIENT, M->ZX3_LOJA)}


	oFolder := TFolder():New( 0, 0, aTitles,aPages, oDlgZX3,,,, .T., .F., 0, 0)
	oGetZX4 := MsNewGetDados():New( 1, 1, 1, 316, nTipoGD,,, '+ZX4_ITEM',,, 9999,,,, oFolder:aDialogs[1], aHeadZX4, aColsZX4)

	oGetZX4:bLinhaOk := { || AFT200LOK( oGetZX4 ) }
	oGetZX4:bTudoOk := { || AFT200TOk( oGetZX4 ) }

	AlignObject( oDlgZX3, { oEncZX3:oBox, oFolder }, 1, 1, { 70, 320 } )
	AlignObject( oFolder:aDialogs[1], { oGetZX4:oBrowse }, 1, , { 100 } )

	ACTIVATE MSDIALOG oDlgZX3 ON INIT (	oGetZX4:Refresh(),; //Refresh para que possam aparecer todas as linhas, que não estavam vindo na abertura
	EnchoiceBar( oDlgZX3, { || If( oGetZX4:TudoOk(),;
	( U_ADVOrdGD( oGetZX4, aHeadZX4, oGetZX4:aCols, 'ZX4_ITEM'),;
	aColsZX4 := oGetZX4:aCols,;
	nOpcA := 1,;
	oDlgZX3:End() ),;
	Nil ) },;
	{ || nOpcA := 0, oDlgZX3:End() } ) )

	If nOpc != 2 .And. nOpca == 1

		Begin Transaction

			If nOpc != 5
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³RODA A REGRA DE ATRIBUICAO DAS INFORMACAO DO CAMPO ZX4_OBS?
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				for i:= 1 to len(aColsZX4)
					cMemo := 'Data: '+dtoc(date())+' Usuario: '+substr(cUSUARIO,7,14)+CHR(10)+'================================='+CHR(10)+aColsZX4[I][NM]
					IF !EMPTY(aColsZX4[I][NM])
						aColsZX4[I][NH] := aColsZX4[I][NH]+CHR(10)+cMemo
						aColsZX4[I][NM] := ""
					ENDIF
				next i
				U_GavGrvEnc( "ZX3", nOpc )
				bBloco := { || ZX4->ZX4_NUM := ZX3->ZX3_NUM }
				U_GavGaCols( aColsZX4, aHeadZX4, aRecsZX4, "ZX4", bBloco, Nil, nOpc )

			Else
				U_GavGaCols( aColsZX4, aHeadZX4, aRecsZX4, "ZX4", bBloco, Nil, nOpc )
				U_GavGrvEnc( "ZX3", nOpc )

			Endif

			While GetSX8Len() > nSaveSx8
				ConfirmSX8()
			End

		End Transaction

	Else

		While GetSX8Len() > nSaveSx8
			RollBackSx8()
		End

	EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ?PESQCNT  ºAutor  ³Fabricio E. da Costa?Data ? 21/03/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Exibe tela com as parcelas a serem dadas manutenção.        º±?
±±?         ?                                                           º±?
±±?         ³Parametros:                                                 º±?
±±?         ?  nOpcE....: Indica qual a manuntenção:                    º±?
±±?         ?             1-Baixa de parcela                            º±?
±±?         ?             2-Estorno de parcela                          º±?
±±?         ?             3-Restituição ao banco                        º±?
±±?         ?             4-Estorno de restituição                      º±?
±±?         ?                                                           º±?
±±?         ³Retorno:                                                    º±?
±±?         ?  .........:                                               º±?
±±?         ?                                                           º±?
±±?         ³Observacao:                                                 º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function PESQCNT(cEnt, cCliente, cLoja)
	Local cTitulo    := ""
	Local cSql       := ""
	Local cCodSU5    := ""
	Local aCampoSZEN := {}
	Local nPosChk01  := 0
	Local aColsPar   := 0
	Local aHeaderCnt := {}
	Local nGDOpc     := GD_UPDATE
	Local nOpcA      := 0
	Local oDlg1
	Local oGDRep

	cTitulo := "Pesquisa de contatos"

	oDlg1                := tDialog():New()
	oDlg1:cName          := "oDlg1"
	oDlg1:cCaption       := cTitulo
	oDlg1:nLeft          := 001
	oDlg1:nTop           := 001
	oDlg1:nWidth         := 550
	oDlg1:nHeight        := 320
	oDlg1:nClrPane       := 16777215
	oDlg1:nStyle         := -2134376320
	oDlg1:bInit          := {|| EnchoiceBar(oDlg1, {|| nOpcA := 1, aAux := aClone(oGdCnt:aCols), oDlg1:End() }, {|| nOpcA := 0, oDlg1:End()}) }
	oDlg1:lCentered      := .T.

	aCampoSU5N := {}
	aHeaderCnt := CriaHeader("SU5", , , {{" ","_CHK01"}})
	oGDCnt := MsNewGetDados():New(0, 0, 1, 1,/*nGDOpc*/,,,,,,,,,, oDlg1, aHeaderCnt, {})
	oGDCnt:aCols := {}
	oGDCnt:oBrowse:nTop       := 25
	oGDCnt:oBrowse:nLeft      := 02
	oGDCnt:oBrowse:nHeight    := 270
	oGDCnt:oBrowse:nWidth     := 545
	oGDCnt:oBrowse:bLDblClick := {|| }
	oGDCnt:oBrowse:lAdjustColSize := .T.

	nPosChk := GdFieldPos("_CHK01", oGDCnt:aHeader)
	nPosCod := GdFieldPos("U5_CODCONT", oGDCnt:aHeader)

	cSql := "SELECT " + CpoGrid(oGDCnt) + " "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SU5") + " SU5 JOIN " + RetSqlName("AC8") + " AC8 ON "
	cSql += "    SU5.U5_FILIAL  = '" + xFilial("SU5") + "'    AND "
	cSql += "    SU5.D_E_L_E_T_ = ' '    AND "
	cSql += "    AC8.AC8_FILIAL = '" + xFilial("SU5") + "'    AND "
	cSql += "    AC8.D_E_L_E_T_ = ' '    AND "
	cSql += "    SU5.U5_CODCONT = AC8.AC8_CODCON "
	cSql += "WHERE "
	cSql += "	 AC8.AC8_ENTIDA = '" + cEnt + "' "
	cSql += "  AND AC8.AC8_CODENT = '" + cCliente + cLoja + "' "

	Load_Grid(cSql, oGDCnt, {{"_CHK01", "'LBNO'", .F.}})

	oDlg1:Activate()

	If nOpcA == 1
		aEval(oGDCnt:aCols, {|aItem| cCodSU5 := Iif(aItem[nPosChk] == "LBTIK", aItem[nPosCod], cCodSU5)})
	EndIf

Return cCodSU5

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºProcedure ³Load_Grid ºAutor  ³Fabricio E. da Costa?Data ? 11/03/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Carrega o grid passado em oGetDados, com os registros       º±?
±±?         ³retornados pela query passada em cSql.                      º±?
±±?         ?                                                           º±?
±±?         ³Parametros:                                                 º±?
±±?         ? cSql.....: Query que retorna os registros para o grid     º±?
±±?         ? oGetDados: Objeto NewGetDados que ira receber os resgitrosº±?
±±?         ?                                                           º±?
±±?         ³Retorno:                                                    º±?
±±?         ?  Nil                                                      º±?
±±?         ?                                                           º±?
±±?         ³Observacao:                                                 º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?GERAL                                                      º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Procedure Load_Grid(cSql, oGetDados, aCheck, aLegenda)
	Local cAction   := ""
	Local cMultSel  := ""
	Local cSingSel  := ""
	Local cAux      := ""
	Local cCont     := ""
	Local bAddDados := "{|| AAdd(oGetDados:aCols, {"
	Local lCheck    := .F.
	Local nPosChk   := 0
	Local i

	Static cStatTst  := ""

	Default aCheck   := {}
	Default aLegenda := {}

	TCQuery cSql NEW ALIAS "TMP1"
	For i := 1 To Len(oGetDados:aHeader)
		If "_CHK" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aCheck[nPosChk, 2] + ", "
		ElseIf "_LEG" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aLegenda, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aLegenda[nPosChk, 2] + ", "
		Else
			If oGetDados:aHeader[i,8] $ "N/D" //Acerta campos numericos e datas na query
				TCSetField("TMP1", oGetDados:aHeader[i,2], oGetDados:aHeader[i,8], oGetDados:aHeader[i,4],oGetDados:aHeader[i,5])
			EndIf
			bAddDados += oGetDados:aHeader[i,2] + ", "
		EndIf
	Next
	bAddDados += ".F.})}"

	bAddDados := &bAddDados.
	oGetDados:aCols := {}
	TMP1->(DbEval(bAddDados))
	TMP1->(DbCloseArea())
	// Define a ação lDblClick da getdados para marcar e desmarcar os checkboxs

	For i := 1 To Len(aCheck)
		nPosChk  := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
		cMultSel += Iif(aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
		cSingSel += Iif(!aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
	Next
	cMultSel := Iif(Empty(cMultSel), "*", cMultSel)
	cSingSel := Iif(Empty(cSingSel), "*", cSingSel)

	cBloco  := "{|aItem| oGetDados:aCols[nItem,oGetDados:oBrowse:nColPos] := Iif(nItem == oGetDados:nAt, Iif(aItem[oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'), 'LBNO'), nItem++}"
	cInicio := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1)"
	cCont   := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', 1, Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cSingSel + "', Len(oGetDados:aCols), 0))"
	cAction := "nItem := Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1), aEval(oGetDados:aCols, " + cBloco + ", " + cInicio + ", " + cCont + "), oGetDados:oBrowse:Refresh()"

	//cAction := "oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] := Iif('_CHK' $ oGetDados:aHeader[oGetDados:oBrowse:nColPos,2], Iif(oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'),oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos])"
	If Len(aCheck) > 0 .And. Len(oGetDados:aCols) > 0 .And. At(Upper(cAction), GetCbSource(oGetDados:oBrowse:bLDblClick)) == 0
		oGetDados:oBrowse:bLDblClick := &(BAddExp(oGetDados:oBrowse:bLDblClick, cAction))
	EndIf
	oGetDados:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³CpoGrid   ºAutor  ³Fabricio E. da Costa?Data ? 18/03/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Cria a lista de campos de um aHeader.                       º±?
±±?         ?                                                           º±?
±±?         ³Parametros:                                                 º±?
±±?         ? oGetDados: Objeto NewGetDados que ser?gerada a lista de  º±?
±±?         ? campos.                                                   º±?
±±?         ?                                                           º±?
±±?         ³Retorno:                                                    º±?
±±?         ?  Nil                                                      º±?
±±?         ?                                                           º±?
±±?         ³Observacao:                                                 º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?GERAL                                                      º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function CpoGrid(oGetDados)
	Local cCampos := ""

	aEval(oGetDados:aHeader, {|aItem| cCampos += Iif(Left(aItem[2], 4) $ "_CHK/_LEG", "", aItem[2] + ", ")}, 1, Len(oGetDados:aHeader) - 1) // gera a lista de campos da select
	cCampos += Iif(Left(aTail(oGetDados:aHeader)[2], 4) $ "_CHK/_LEG", "", aTail(oGetDados:aHeader)[2])

Return cCampos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³CriaHeaderºAutor  ³Fabricio E. da Costa?Data ? 12/03/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Cria o aHeader que ser?utilizado pela NewGetDados.         º±?
±±?         ?                                                           º±?
±±?         ³Parametros:                                                 º±?
±±?         ? cAlias...: Alias que sera criado o aHeader                º±?
±±?         ? aCamposS.: Array contendo os campos do Alias a serem      º±?
±±?         ?            exibidos.                                      º±?
±±?         ? aCamposN.: Array contendo os campos do Alias a serem      º±?
±±?         ?            suprimidos do Alias.                           º±?
±±?         ? lCheck...: Indica se o grid ter?checkbox (.T.Sim/.F.Não).º±?
±±?         ? lRecno...: Indica se o grid ter?Recno dos registros      º±?
±±?         ?                                                           º±?
±±?         ³Retorno:                                                    º±?
±±?         ? aHeader..: aHeader contendo os campos do Alias            º±?
±±?         ?            especificado.                                  º±?
±±?         ?                                                           º±?
±±?         ³Observacao:                                                 º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?GERAL                                                      º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function CriaHeader(cAlias, aCamposS, aCamposN, aCheck, lRecno)
	Local aHeader := {}
	Local i
	Local aSX3    := {}
	Local nX      := 0
	Default aCamposS := {}
	Default aCamposN := {}
	Default aCheck   := {}
	Default lRecno   := .F.

	For i := 1 To Len(aCheck)
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader), 01] := AllTrim(aCheck[i,1])
		aHeader[Len(aHeader), 02] := AllTrim(aCheck[i,2])
		aHeader[Len(aHeader), 03] := "@BMP"
		aHeader[Len(aHeader), 04] := 03
		aHeader[Len(aHeader), 05] := 00
		aHeader[Len(aHeader), 08] := "C"
		aHeader[Len(aHeader), 10] := "V"
		aHeader[Len(aHeader), 14] := "V"
	Next
	//SX3->(DbSetOrder(1))
	//SX3->(DbSeek(cAlias))
	
	aSX3 := FWSX3Util():GetAllFields( cAlias , .F. )

	For nX := 1 to len(aSX3)  //While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias
		If X3Uso(GetSx3Cache(aSx3[nX],"X3_USADO")) .And. GetSx3Cache(aSX3[nX],"X3_TIPO") <> "M" .And. GetSx3Cache(aSX3[nX],"X3_CONTEXT") <> "V" .And. cNivel >= GetSx3Cache(aSX3[nX],"X3_NIVEL");
			 .And. (aScan(aCamposS, AllTrim(GetSx3Cache(aSX3[nX],"X3_CAMPO"))) > 0 .Or. Len(aCamposS) == 0) .And. (aScan(aCamposN, AllTrim(GetSx3Cache(aSX3[nX],"X3_CAMPO"))) == 0 .Or. Len(aCamposN) == 0)
			Aadd(aHeader, {})
			Aadd(aHeader[Len(aHeader)], AllTrim(GetSx3Cache(aSX3[nX],"X3_TITULO")))
			Aadd(aHeader[Len(aHeader)], AllTrim(GetSx3Cache(aSX3[nX],"X3_CAMPO")))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_PICTURE"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_TAMANHO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"SX3->X3_DECIMAL"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_VALID"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_USADO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_TIPO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_F3"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_CONTEXT"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_CBOX"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_RELACAO"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_WHEN"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_VISUAL"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_VLDUSER"))
			Aadd(aHeader[Len(aHeader)], GetSx3Cache(aSX3[nX],"X3_PICTVAR"))
			Aadd(aHeader[Len(aHeader)], X3Obrigat(GetSx3Cache(aSX3[nX],"X3_CAMPO")))
		EndIf
		
	next nX
	If lRecno
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader),01] := "RECNO"
		aHeader[Len(aHeader),02] := "R_E_C_N_O_"
		aHeader[Len(aHeader),03] := "99999999999"
		aHeader[Len(aHeader),04] := 10
		aHeader[Len(aHeader),05] := 00
		aHeader[Len(aHeader),08] := "N"
		aHeader[Len(aHeader),10] := "V"
		aHeader[Len(aHeader),14] := "V"
	EndIf

Return aClone(aHeader)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³BAddExp   ºAutor  ³Fabricio E. da Costa?Data ? 17/03/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Adiciona uma expressão a lista de um codeblock.             º±?
±±?         ?                                                           º±?
±±?         ³Parametros:                                                 º±?
±±?         ? bVal.....: Codeblock que ser?inserida a expressao.       º±?
±±?         ? cExp.....: Expressão a ser inserida no codeblock.         º±?
±±?         ? nLocal...: Local em que ser?inserida a expressao         º±?
±±?         ?            0-Inicio 1-Final                               º±?
±±?         ?                                                           º±?
±±?         ³Retorno:                                                    º±?
±±?         ? cRet.....: Indica se a lista de expressões do codeblock   º±?
±±?         ?            esta vazia(.T.) ou não (.F.)                   º±?
±±?         ?                                                           º±?
±±?         ³Observacao:                                                 º±?
±±?         ? O valor retornado ?uma string, pois codeblocks não podem º±?
±±?         ³ser utilizados como retorno de função.                      º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?GERAL                                                      º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function BAddExp(bVal, cExp, nLocal)
	Local cBlock  := ""
	Local bRet    := ""
	Local nPos    := 0

	Default nLocal := 1

	cBlock := GetCbSource(bVal)
	nPos   := Iif(nLocal = 0, Rat("|", cBlock) + 1, Rat("}", cBlock))
	If !BEmpty(bVal)
		cBlock := Stuff(cBlock, nPos, 0, Iif(nLocal = 0, cExpA + ", ", ", " + cExp))
	Else
		cBlock := Stuff(cBlock, nPos, 0, cExp)
	EndIf

Return cBlock

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³BEmpty    ºAutor  ³Fabricio E. da Costa?Data ? 17/03/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Avalia se a lista de expressões de um code block esta vazia º±?
±±?         ³ou não.                                                     º±?
±±?         ?                                                           º±?
±±?         ³Parametros:                                                 º±?
±±?         ? bVal.....: Codeblock a ser avaliado.                      º±?
±±?         ?                                                           º±?
±±?         ³Retorno:                                                    º±?
±±?         ? lRet.....: Indica se a lista de expressões do codeblock   º±?
±±?         ?            esta vazia(.T.) ou não (.F.)                   º±?
±±?         ?                                                           º±?
±±?         ³Observacao:                                                 º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?GERAL                                                      º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function BEmpty(bVal)
	Local cLista  := ""
	Local nInicio := 0
	Local nFinal  := 0

	cLista  := GetCbSource(bVal)
	If !Empty(cLista)
		nInicio := Rat("|", cLista) + 1
		nFinal  := Rat("}", cLista) - 1
		cLista  := SubStr(cLista, nInicio, Len(cLista) - nFinal)
	EndIf

Return Empty(cLista)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Fun‡…o    ³AFT200LOK ?Autor ?Ivan Morelatto Tore   ?Data ?30/07/09 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ³Validação das linhas do aCols                               ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Sintaxe e ³AFT200LOK  (oObjGet) - Objeto da da Getdados                ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?Uso      ?Generico                                                   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function AFT200LOK( oGet )
	Local lRet := .T.

	If oGET:OBROWSE:NOPC == 4
		If Empty(M->ZX3_DOC)
			M->ZX3_STATUS := "1"
			M->ZX3_LIBERA := Ctod("  /  /  ")
		EndIf
	EndIf
	IF Len(aCols) > 0
		lRet := VLINCOMP()  //001
	Endif
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Fun‡…o    ³AFT200TOK ?Autor ?Ivan Morelatto Tore   ?Data ?30/07/09 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ³Validacao geral das linhas do acols                         ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Sintaxe e ³AFT200TOK ()                                                ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?Uso      ?Generico                                                   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function AFT200TOk( oGet )

	Local lRet 		:= Obrigatorio( aGets, aTela )
	Local nLoop		:= 0
	Local nTotal	:= 0

	If lRet

		For nLoop := 1 to Len(oGet:aCols)

			If !aTail( oGet:aCols[nLoop] )

				oGet:oBrowse:nAt := nLoop
				If !( lRet := oGet:LinhaOk() )

					oGet:oBrowse:SetFocus()
					Exit

				EndIf

				nTotal++

			EndIf

		Next nLoop

		If lRet .And. nTotal == 0

			MsgAlert( "?obrigatório informar ao menos um produto." )
			lRet := .F.

		EndIf

	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³MenuDef   ºAutor  ³Ivan Morelatto Tore ?Data ?30/07/2008  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Função utilizada para que seja possível                    º±?
±±?         ?identificar o menu funcional                               º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AFAT200                                                    º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function MenuDef()

	Local aRotina := {	{ "Pesquisar"	, "AxPesqui"	,   0,	1,	0 },;
	{ "Visualizar"	, "U_AFT20MAN"	,   0,	2,	0 },;
	{ "Incluir"		, "U_AFT20MAN"	,   0,	3,	0 },;
	{ "Alterar"		, "U_AFT20MAN"	,   0,	4,	0 },;
	{ "Excluir"		, "U_AFT20MAN"	,   0,	5,	0 },;
	{ "Legenda"		, "U_AFT20LEG"	,   0,	2,	0 },;
	{ "Aprovar"     , "U_AFT20APR"	,   0,	4,	0 },;
	{ "Gerar PV"    , "U_AFT20GPV"	,   0,	4,	0 },;
	{ "Contato"     , "U_AFT20Con"	,   0,	4,	0 } }


Return aRotina


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³AFT20CON  ºAutor  ?Fernando Salvatori ?Data ? 04/26/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Realiza a amarracao de contato com o cliente               º±?
±±?         ?                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
User Function AFT20Con()

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek( xFilial("SA1") + ZX3->ZX3_CLIENT + ZX3->ZX3_LOJA )
		FtContato( "SA1", SA1->(Recno()), 4 )
	EndIf

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³AFAT200   ºAutor  ³Microsiga           ?Data ? XX/XX/XX   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
User Function AFT20LEG

	BrwLegenda( cCadastro, "Legenda", { {"ENABLE"    , "Amostra em Aberto"           },;
	{"DISABLE"   , "Amostra Aprovada"            },;
	{"BR_AZUL"   , "Amostra Faturada (NF Saida)" },;
	{'BR_PRETO'  , "APROVADO - SEM PEDIDO " } } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³AFAT200   ºAutor  ³Microsiga           ?Data ? XX/XX/XX   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
User Function AFT20APR
	Local aSC5     := {}
	Local aSC6     := {}
	Local cTesPad  := GetNewPar("FS_TESPAMO","501")
	Local cSql     := ""
	Local lGerente := .F.
	Local cAdmVnds := GetMv("MV_TABPR94")

	cSql := "SELECT VEN.A3_GRPVEN "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SA3") + " GER JOIN " + RetSqlName("SA3") + " VEN ON "
	cSql += "    GER.A3_FILIAL = VEN.A3_FILIAL   AND "
	cSql += "    GER.D_E_L_E_T_ = ' '      AND "
	cSql += "    VEN.D_E_L_E_T_ = ' '      AND "
	cSql += "    GER.A3_COD = VEN.A3_GEREN "
	cSql += "WHERE "
	cSql += "  GER.A3_CODUSR = '" + __cUserId + "' "
	cSql += "GROUP BY "
	cSql += "  VEN.A3_GRPVEN "
	TcQuery cSql New Alias "TMP"

	lGerente := (!TMP->(Bof()) .AND. !TMP->(Eof()))
	TMP->(DbCloseArea())

	If !lGerente .And. !__cUserId $ cAdmVnds
		MsgAlert("A opção aprovar pode ser utilizada somente pelos gerentes.", "Controle de amostras")
	Else
		If ZX3->ZX3_STATUS == "2"

			If Aviso( "Amostra", "Amostra j?Aprovada. Deseja Estornar?", { "Sim", "Não" } ) == 1

				If !Empty( ZX3->ZX3_PEDIDO )

					aAdd(aSC5, {"C5_FILIAL"  , ZX3->ZX3_FILIAL												   		,Nil})
					aAdd(aSC5, {"C5_NUM"     , ZX3->ZX3_PEDIDO												   		,Nil})
					aAdd(aSC5, {"C5_TIPO"    , "N"																	,Nil})
					aAdd(aSC5, {"C5_CLIENTE" , ZX3->ZX3_CLIENT														,Nil})
					aAdd(aSC5, {"C5_LOJACLI" , ZX3->ZX3_LOJA														,Nil})
					aAdd(aSC5, {"C5_EMISSAO" , ZX3->ZX3_EMISSA														,Nil})
					aAdd(aSC5, {"C5_CONDPAG" , "100"																,Nil})
					aAdd(aSC5, {"C5_TRANSP"  , ZX3->ZX3_TRANSP														,Nil})
					aAdd(aSC5, {"C5_TPFRETE" , ZX3->ZX3_TPFRET														,Nil})
					aAdd(aSC5, {"C5_NATUREZ" , ZX3->ZX3_NATURE														,Nil})
					aAdd(aSC5, {"C5_XVENDOR" , "N",Nil})

					ZX4->( dbSetOrder( 1 ) )
					ZX4->( dbSeek( xFilial( "ZX4" ) + ZX3->ZX3_NUM ) )
					While ZX4->( !Eof() ) .and. ZX4->( ZX4_FILIAL + ZX4_NUM ) == xFilial( "ZX4" ) + ZX3->ZX3_NUM

						cTesPad := MaTesInt(2,ZX4->ZX4_OPER,ZX3->ZX3_CLIENT,ZX3->ZX3_LOJA,"C",ZX4->ZX4_PRODUT)

						If Empty( cTesPad )
							cTesPad := GetNewPar("FS_TESPAMO","501")
						EndIf

						aLinha := {}
						aAdd( aLinha, {"C6_PRODUTO" , ZX4->ZX4_PRODUT  												,Nil})
						aAdd( aLinha, {"C6_QTDVEN"  , ZX4->ZX4_QTD  												,Nil})
						aAdd( aLinha, {"C6_QTDLIB"  , ZX4->ZX4_QTD  											,Nil})
						aAdd( aLinha, {"C6_PRCVEN"  , ZX4->ZX4_PRCUNI 												,Nil})
						aAdd( aLinha, {"C6_VALOR"   , ZX4->ZX4_VALOR                            					,Nil})
						aAdd( aLinha, {"C6_TES"     , cTesPad														,Nil})

						aAdd( aSC6, aClone( aLinha ) )

						ZX4->( dbSkip() )
					EndDo

					lMSErroAuto := .F.
					lMSHelpAuto := .T.

					MsExecAuto( { |x,y,z| MATA410( x, y, z ) }, aSC5, aSC6, 5 )

					If lMSErroAuto
						MostraErro()
					Else
						MsgInfo( "Pedido " + ZX3->ZX3_PEDIDO + " estornado! " )
						RecLock( "ZX3", .F. )
						ZX3->ZX3_PEDIDO := ""
						ZX3->ZX3_STATUS := "1"
						ZX3->ZX3_LIBERA := Ctod("  /  /  ")
						ZX3->ZX3_USRAPR := Space(Len(ZX3->ZX3_USRAPR))
						ZX3->(MsUnLock())
					Endif
				Endif
			Else
				RecLock( "ZX3", .F. )
				ZX3->ZX3_STATUS := "1"
				ZX3->ZX3_LIBERA := Ctod("  /  /  ")
				ZX3->(MsUnLock())
			Endif
		Else
			If Aviso( "Amostra", "Deseja Aprovar a Amostra?", { "Sim", "Não" } ) == 1
				RecLock( "ZX3", .F. )
				ZX3->ZX3_STATUS := "2"
				ZX3->ZX3_LIBERA := dDataBase
				ZX3->ZX3_USRAPR := Left(cUserName, 25)
				ZX3->(MsUnLock())
			Endif
		Endif
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³AFAT200   ºAutor  ³Microsiga           ?Data ? XX/XX/XX   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
User Function AFT20GPV
	Local aAreaAtu := GetArea()
	Local aSC5     := {}
	Local aSC6     := {}
	Local cTesPad  := ""
	Local cItem    := Replicate("0",TamSX3("C6_ITEM")[1])

	If ZX3->ZX3_STATUS = "1"
		MsgStop( "Amostra não aprovada para geração do Pedido de Venda" )
		Return
	Endif

	If !Empty( ZX3->ZX3_PEDIDO )
		MsgAlert( "Pedido j?gerado para essa amostra" )
		Return
	Endif

	If !MsgYesNo("Confirma a geração do pedido de venda para a amostra "+ZX3->ZX3_NUM+"?")
		Return
	EndIf

	aAdd(aSC5, {"C5_TIPO"    , "N"																	,Nil})
	aAdd(aSC5, {"C5_CLIENTE" , ZX3->ZX3_CLIENT														,Nil})
	aAdd(aSC5, {"C5_LOJACLI" , ZX3->ZX3_LOJA														,Nil})
	aAdd(aSC5, {"C5_EMISSAO" , ZX3->ZX3_EMISSA														,Nil})
	aAdd(aSC5, {"C5_CONDPAG" , "100"																,Nil})
	aAdd(aSC5, {"C5_TRANSP"  , ZX3->ZX3_TRANSP														,Nil})
	aAdd(aSC5, {"C5_TPFRETE" , ZX3->ZX3_TPFRET														,Nil})
	aAdd(aSC5, {"C5_NATUREZ" , ZX3->ZX3_NATURE														,Nil})
	aAdd(aSC5, {"C5_XVENDOR" , "N"	,Nil})

	ZX4->( dbSetOrder( 1 ) )
	ZX4->( dbSeek( xFilial( "ZX4" ) + ZX3->ZX3_NUM ) )
	While ZX4->( !Eof() ) .and. ZX4->( ZX4_FILIAL + ZX4_NUM ) == xFilial( "ZX4" ) + ZX3->ZX3_NUM

		cTesPad := MaTesInt(2,ZX4->ZX4_OPER,ZX3->ZX3_CLIENT,ZX3->ZX3_LOJA,"C",ZX4->ZX4_PRODUT)

		If Empty( cTesPad )
			cTesPad := GetNewPar("FS_TESPAMO","501")
		EndIf

		aLinha := {}

		cItem := Soma1( cItem )

		aAdd( aLinha, {"C6_ITEM"    , cItem			  						,Nil})
		aAdd( aLinha, {"C6_PRODUTO" , ZX4->ZX4_PRODUT  						,Nil})
		aAdd( aLinha, {"C6_XMOEDA"	, 1										,Nil})
		aAdd( aLinha, {"C6_QTDVEN"  , ZX4->ZX4_QTD  						,Nil})
		aAdd( aLinha, {"C6_QTDLIB"  , ZX4->ZX4_QTD  						,Nil})
		aAdd( aLinha, {"C6_PRCVEN"  , ZX4->ZX4_PRCUNI 						,Nil})
		aAdd( aLinha, {"C6_VALOR"   , NOROUND(ZX4->ZX4_VALOR,2)       		,Nil})
		aAdd( aLinha, {"C6_TES"     , cTesPad								,Nil})

		aAdd( aSC6, aClone( aLinha ) )

		ZX4->( dbSkip() )
	End

	lMSErroAuto := .F.
	lMSHelpAuto := .T.

	dbSelectArea("SC5")
	MsExecAuto( { |x,y,z| MATA410( x, y, z ) }, aSC5, aSC6, 3 )

	If lMSErroAuto
		MostraErro()
	Else
		RecLock( "ZX3", .F. )
		ZX3->ZX3_PEDIDO := SC5->C5_NUM
		ZX3->( MsUnLock() )
		MsgInfo( "Gerado o Pedido Numero: " + SC5->C5_NUM )
	Endif

	RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³AFAT200   ºAutor  ³Microsiga           ?Data ? XX/XX/XX   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
User Function AFT20VAL

	Local aAreaAtu := GetArea()
	Local aAreaSB1 := SB1->( GetArea() )

	Local lRetFun := .T.

	SB1->( dbSetOrder( 1 ) )
	SB1->( dbSeek( xFilial( "SB1" ) + M->ZX4_PRODUT ) )
	If !( "AMOSTRA" $ UPPER( SB1->B1_DESC ) )
		MsgStop( "Este produto não ?uma amostra e não poder?ser utilizado" )
		lRetFun := .F.
	Endif

	RestArea( aAreaSB1 )
	RestArea( aAreaAtu )

Return lRetFun


Static Function VLINCOMP()
	Local _lRet := .T.

	Local nMaxArray     := Len(aCols) //luiz
	Local nPos      := 0 //luiz
	Local Vdel :=.F.

	Cont:= nMaxArray
	While Cont > 1

		cProduto1 := aCols[nMaxArray,GDFieldPos("ZX4_PRODUT")]
		cProduto2 := aCols[(Cont-1),GDFieldPos("ZX4_PRODUT")]

		cONU1 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1__CODONU" )
		cLinha1 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1_SEGMENT" )

		cONU2 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1__CODONU" )
		cLinha2 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1_SEGMENT" )

		If cLinha1 $ "000005|000006|000007" .and. !Empty( cONU2 ) .and. cLinha1 <> cLinha2
			Alert (" Produto: " + cProduto1 + " Incompativel Com Produto: " + cProduto2 + CRLF)
			_lRet := .F.
		Endif
		If cLinha2 $ "000005|000006|000007" .and. !Empty( cONU1 ) .and. cLinha1 <> cLinha2
			_lRet := .F.
		Endif

		ZAA->( dbSetOrder( 1 ) )
		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
			_lRet := .F.
		Endif

		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
			_lRet := .F.
		Endif

		ZAA->( dbSetOrder( 2 ) )
		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
			_lRet := .F.
		Endif

		If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
			_lRet := .F.
		Endif
		if !_lRet
			Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + CRLF)
		Endif
		Cont := Cont-1
	Enddo

Return _lRet
