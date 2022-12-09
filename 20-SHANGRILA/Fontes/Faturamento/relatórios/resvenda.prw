#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESVENDA º Autor ³ Rodrigo Maciel	 º Data ³  17/06/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Vendas por Grupo de Produtos                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Shangrilla                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ResVenda()

Local cArqTR1
Local cArqTR2
Local cIndTR1, cIndTR2
Local cString := "SB1"
Local aStruTR1 := {}
Local aStruTR2 := {}
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Quantidade de Matéria-Prima por Venda"
Local cPict          := ""
Local titulo       := "Quantidade Vendida / Grupo"
Local nLin         := 80

Local Cabec1       := ""//                     Quantidade                   Valor           Valor MO         Valor Total"
Local Cabec2       := ""//  Grupo                 Vendida                 Unit.MO       X Quantidade            Faturado"
//					   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RESVEN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PadR("TRB001",Len(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RESVEN" // Coloque aqui o nome do arquivo usado para impressao em disco

aAdd(aStruTR1,{"TR1_GRUPO","C",04,00})
aAdd(aStruTR1,{"TR1_PRODUT","C",15,00})
aAdd(aStruTR1,{"TR1_QTDVEN","N",11,02})
aAdd(aStruTR1,{"TR1_TOTAL","N",12,02})

cArqTR1 := CriaTrab(aStruTR1,.T.)
dbUseArea(.T.,,cArqTR1,"TR1",.T.)
cIndTR1 := CriaTrab(NIL,.F.)
IndRegua("TR1",cIndTR1,"TR1_GRUPO+TR1_PRODUT",,,"Selecionando Registros...")

aAdd(aStruTR2,{"TR2_COD","C",15,00})
aAdd(aStruTR2,{"TR2_DESC","C",30,00})
aAdd(aStruTR2,{"TR2_QUANT","N",12,02})
aAdd(aStruTR2,{"TR2_UNID","C",2,00})
aAdd(aStruTR2,{"TR2_VLRUNI","N",12,02})
aAdd(aStruTR2,{"TR2_VLRTOT","N",12,02})
aAdd(aStruTR2,{"TR2_QTDEST","N",12,02})
aAdd(aStruTR2,{"TR2_TOTEST","N",12,02})

cArqTR2 := CriaTrab(aStruTR2,.T.)
dbUseArea(.T.,,cArqTR2,"TR2",.T.)
cIndTR2 := CriaTrab(NIL,.F.)
IndRegua("TR2",cIndTR2,"TR2_COD",,,"Selecionando Registros...")

AjustSX1()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

zwnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	dbSelectArea("TR1")
	cExt := OrdBagExt()
	dbCloseArea()
	If File(cArqTR1+GetDBExtension())
		FErase(cArqTR1+GetDBExtension())    //arquivo de trabalho
	Endif
	If File(cIndTR1 + cExt)
		FErase(cIndTR1+cExt)	 //indice gerado
	Endif

	dbSelectArea("TR2")
	cExt := OrdBagExt()
	dbCloseArea()
	If File(cArqTR2+GetDBExtension())
		FErase(cArqTR2+GetDBExtension())    //arquivo de trabalho
	Endif
	If File(cIndTR2 + cExt)
		FErase(cIndTR2+cExt)	 //indice gerado
	Endif

	Return
Endif

SetDefault(aReturn,cString)

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


dbSelectArea("TR1")
cExt := OrdBagExt()
dbCloseArea()
If File(cArqTR1+GetDBExtension())
	FErase(cArqTR1+GetDBExtension())    //arquivo de trabalho
Endif
If File(cIndTR1 + cExt)
	FErase(cIndTR1+cExt)	 //indice gerado
Endif

dbSelectArea("TR2")
cExt := OrdBagExt()
dbCloseArea()
If File(cArqTR2+GetDBExtension())
	FErase(cArqTR2+GetDBExtension())    //arquivo de trabalho
Endif
If File(cIndTR2 + cExt)
	FErase(cIndTR2+cExt)	 //indice gerado
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Rodrigo Maciel     º Data ³  17/06/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±± Data Inicial ?		MV_PAR01 ±±
±± Data Final ? 		MV_PAR02 ±±
±± TES ?			MV_PAR03 ±±
±± Grupos 1?			MV_PAR04 ±±
±± Grupos 2?			MV_PAR05 ±±
±± Do Tipo ?			MV_PAR06 ±±
±± Ate Tipo ?			MV_PAR07 ±±
±± Do Vendedor ?		MV_PAR08 ±±
±± Ate o Vendedor ?		MV_PAR09 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cFilSF2 := xFilial("SF2")
Local cGrupo := ""
Local nQtdVen := 0
Local nTotQtd := 0
Local nTotGer := 0
Local nTotal := 0
Local aProdutos := {}
Local nQuantTR1 := 0
Local cCod := ""
Local cComp := ""
Local aTrab := {}
Local lOk := .F.

Private nEstru := 0
Private aEstrutura := {}

cFiltro := "F2_FILIAL == '" + xFilial('SF2') + "' "
cFiltro += ".And. DTOS(F2_EMISSAO) >= '" + dtos(mv_par01) + "' "
cFiltro += ".And. DTOS(F2_EMISSAO) <= '" + dtos(mv_par02) + "' "
cIndice := "F2_FILIAL+DTOS(F2_EMISSAO)"
cArqSF2 := CriaTrab(Nil,.F.)

dbSelectArea("SF2")
IndRegua("SF2",cArqSF2,cIndice,,cFiltro)
nIndice := RetIndex()
nIndice := nIndice + 1

#IFNDEF TOP
	dbSetIndex(cArqSF2+OrdBagExt())
#ENDIF
dbSetOrder(nIndice)

SetRegua(RecCount())

if !dbSeek(cFilSF2+DTOS(mv_par01))
	dbGoTop()
EndIf

//Monta arquivo TR1 com dados da primeira página

While SF2->(!EOF()) .And. SF2->F2_EMISSAO <= mv_par02

	If SF2->F2_EMISSAO < mv_par01
		SF2->(dbSkip())
		Loop
	EndIf

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE)
	While SD2->(!EOF()) .And. SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE

		cGrupo	:= Alltrim(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_GRUPO"))
		cTipo	:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_TIPO")
		cVend 	:= Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_VEND1")

//		If SD2->D2_TES $ mv_par03 .And. cGrupo >= mv_par04 .And. cGrupo <= mv_par05 .And. ;
//			cTipo >= mv_par06 .And. cTipo <= mv_par07 .And. cVend >= mv_par08 .And. cVend <= mv_par09
		If SD2->D2_TES $ mv_par03 .And. (cGrupo $ mv_par04 .Or. cGrupo $ mv_par05) .And. ;
			cTipo >= mv_par06 .And. cTipo <= mv_par07 .And. cVend >= mv_par08 .And. cVend <= mv_par09

			dbSelectArea("TR1")
			If dbSeek(cGrupo+SD2->D2_COD)
				nQtdVen	:= TR1->TR1_QTDVEN + SD2->D2_QUANT
				nTotal	:= TR1->TR1_TOTAL + SD2->D2_TOTAL
				Reclock("TR1",.F.)
				Replace TR1->TR1_QTDVEN With nQtdVen
				Replace TR1->TR1_TOTAL With nTotal
				MsUnlock()

			Else
				Reclock("TR1",.T.)
				Replace TR1->TR1_GRUPO With cGrupo
				Replace TR1->TR1_PRODUT With SD2->D2_COD
				Replace TR1->TR1_QTDVEN With SD2->D2_QUANT
				Replace TR1->TR1_TOTAL With SD2->D2_TOTAL
				MsUnlock()
			EndIf
		EndIf
		SD2->(dbSkip())
	EndDo

	SF2->(dbSkip())

EndDo

//Estrutura do Produto



dbSelectArea("TR1")
dbSetOrder(1)
dbGoTop()

nCont := 0

While TR1->(!EOF())
	aEstrutura := {}
	aProdutos := {}
	cProdTR1 := TR1->TR1_PRODUT
	nQtdPai := Posicione("SB1",1,xFilial("SB1")+cProdTR1,"B1_QB")
	Aadd(aProdutos, Estrut(cProdTR1,nQtdPai))
	If Len(aProdutos[1]) < 1
		//RecLock("TR1")
		//TR1->(dbDelete())
		//MsUnlock()
		TR1->(dbSkip())
		Loop
	EndIf
	nNivPai := aProdutos[1][1][1]
	nQuantTR1 := 0

	For nCA := 1 to Len(aProdutos[1])

		dbSelectArea("SB1")
		dbSetOrder(1)

		dbSeek(xFilial("SB1")+aProdutos[1][nCA][3])
		If SB1->B1_TIPO == "MP"

			dbSelectArea("TR2")
			dbSetOrder(1)
			If TR2->(dbSeek(SB1->B1_COD))

				nQuantTR2 := (TR1->TR1_QTDVEN * aProdutos[1][nCA][4])/nQtdPai
				nQuantTR2 += TR2->TR2_QUANT
				nVlrTotTR2 := nQuantTR2 * TR2->TR2_VLRUNI

				Reclock("TR2",.F.)
				Replace TR2_QUANT With nQuantTR2
				Replace TR2_VLRTOT With nVlrTotTR2
				MsUnlock()

			Else

				nQuantTR2 := (TR1->TR1_QTDVEN * aProdutos[1][nCA][4])/nQtdPai
				nQuantTR2 += TR2->TR2_QUANT
				nVlrUniTR2 := 0
				nQtdEstTR2 := 0
				_nCont := 0
				dbSelectArea("SB6")
				dbSetOrder(1)
				IF (dbSeek(xFilial("SB6")+SB1->B1_COD))
					While SB6->B6_PRODUTO == SB1->B1_COD
						If SB6->B6_PODER3 == "R"
							IF SB6->B6_SALDO <> 0
								nVlrUniTR2 += SB6->B6_PRUNIT
								nQtdEstTR2 += SB6->B6_SALDO
								_nCont++
							EndIf
						EndIf
						SB6->(dbSkip())
					EndDo
				Else
					nVlrUniTR2 := 0
					nQtdEstTR2 := 0
				EndIf
				nVlrUniTR2 := nVlrUniTR2 / _nCont
				nVlrTotTR2 := nQuantTR2 * nVlrUniTR2
				nTotEstTR2 := nVlrUniTR2 * nQtdEstTR2

				Reclock("TR2",.T.)
				Replace TR2_COD With SB1->B1_COD
				Replace TR2_DESC With SB1->B1_DESC
				Replace TR2_QUANT With nQuantTR2
				Replace TR2_UNID With SB1->B1_UM
				Replace TR2_VLRUNI With nVlrUniTR2
				Replace TR2_VLRTOT With nVlrTotTR2
				Replace TR2_QTDEST With nQtdestTR2
				Replace TR2_TOTEST With nTotEstTR2
				MsUnlock()

			EndIf
		EndIf

	Next nCA

	nCont++

	TR1->(dbSkip())

EndDo

If Len(aProdutos) > 0

	//Imprime primeira página com resumo

	dbSelectArea("TR1")
	dbSetOrder(1)
	dbGoTop()

	nQtdVen := 0
	nTotal := 0
	cGrupo := TR1->TR1_GRUPO

	While TR1->(!EOF())


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
			@nLin, 000 PSAY "                            --------------------------------------------------------------------------"
			nLin++
			@nLin, 000 PSAY "                            |       |  Quantidade |          Valor |       Valor MO |    Valor Total |"
			nLin++
			@nLin, 000 PSAY "                            | Grupo |     Vendida |        Unit.MO |   X Quantidade |       Faturado |"
			nLin++
			@nLin, 000 PSAY "                            |-------|-------------|----------------|----------------|----------------|"
			//				  123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
			nLin++
		Endif

		If cGrupo == TR1->TR1_GRUPO
			nQtdVen += TR1->TR1_QTDVEN
			nTotal += TR1->TR1_TOTAL
		Else
			nVlrUni := Posicione("SB1",1,xFilial("SB1")+"MO"+Substr(cGrupo,2,3),"B1_PRV1")
			nVlrTot := nVlrUni * nQtdVen
			nTotQtd += nVlrTot
			nTotGer += nTotal

			@nLin,028 PSAY "|"
			@nLin,031 PSAY cGrupo
			@nLin,036 PSAY "|"
			@nLin,038 PSAY nQtdVen PICTURE "@E 99999999.99"
			@nLin,050 PSAY "|"
			@nLin,052 PSAY nVlrUni PICTURE "@E 999,999,999.99"
			@nLin,067 PSAY "|"
			@nLin,069 PSAY nVlrTot PICTURE "@E 999,999,999.99"
			@nLin,084 PSAY "|"
			@nLin,086 PSAY nTotal PICTURE "@E 999,999,999.99"
			@nLin,101 PSAY "|"
			nLin++

			nQtdVen := TR1->TR1_QTDVEN
			nTotal := TR1->TR1_TOTAL

		EndIf

		cGrupo := TR1->TR1_GRUPO

		TR1->(dbSkip())
	EndDo

	nVlrUni := Posicione("SB1",1,xFilial("SB1")+"MO"+Substr(cGrupo,2,3),"B1_PRV1")
	nVlrTot := nVlrUni * nQtdVen
	nTotQtd += nVlrTot
	nTotGer += nTotal

	@nLin,028 PSAY "|"
	@nLin,031 PSAY cGrupo
	@nLin,036 PSAY "|"
	@nLin,038 PSAY nQtdVen PICTURE "@E 99999999.99"
	@nLin,050 PSAY "|"
	@nLin,052 PSAY nVlrUni PICTURE "@E 999,999,999.99"
	@nLin,067 PSAY "|"
	@nLin,069 PSAY nVlrTot PICTURE "@E 999,999,999.99"
	@nLin,084 PSAY "|"
	@nLin,086 PSAY nTotal PICTURE "@E 999,999,999.99"
	@nLin,101 PSAY "|"
	nLin++
	@nLin, 000 PSAY "                            ---------------------------------------|----------------|----------------|"
	nLin++
	@nLin,067 PSAY "|"
	@nLin,069 PSAY nTotQtd PICTURE "@E 999,999,999.99"
	@nLin,084 PSAY "|"
	@nLin,086 PSAY nTotGer PICTURE "@E 999,999,999.99"
	@nLin,101 PSAY "|"
	nLin++
	@nLin,067 PSAY "-----------------------------------"

	//Imprime estrutura na segunda página

	titulo := "Quantidade de Matéria-Prima por Venda"
	Cabec1 := "                                                |    Soma das                  Valor           Valor |         S A L D O           "
	Cabec2 := " Código           Descrição                     | Quantidades  Unid.        Unitário           Total | Quantidade  |  Valor Total"
	//		    123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

	nLin := 60

	dbSelectArea("TR2")
	dbSetOrder(1)
	dbGoTop()

	nTotal := 0
	nTotGer := 0

	While TR2->(!EOF())


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		nTotal += TR2->TR2_VLRTOT
		nTotGer += TR2->TR2_TOTEST

		@nLin, 001 PSAY TR2_COD
		@nLin, 018 PSAY	TR2_DESC
		@nLin, 048 PSAY "|"
		@nLin, 050 PSAY TR2_QUANT PICTURE "@E 99999999.99"
		@nLin, 064 PSAY TR2_UNID
		@nLin, 070 PSAY TR2_VLRUNI PICTURE "@E 999,999,999.99"
		@nLin, 086 PSAY TR2_VLRTOT PICTURE "@E 999,999,999.99"
		@nLin, 101 PSAY "|"
		@nLin, 103 PSAY TR2_QTDEST PICTURE "@E 99999999.99"
		@nLin, 118 PSAY TR2_TOTEST PICTURE "@E 999,999,999.99"

		nLin++

		TR2->(dbSkip())

	EndDo
	nLin++
	@nLin, 086 PSAY nTotal PICTURE "@E 999,999,999.99"
	@nLin, 118 PSAY nTotGer PICTURE "@E 999,999,999.99"

EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

////////////////////////
Static Function AjustSX1
////////////////////////

Private _aArea := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)
DbSeek(cPerg)
Do While SX1->X1_GRUPO == cPerg .And. SX1->(!Eof())
	If SX1->X1_ORDEM == "04" .Or. SX1->X1_ORDEM == "05"
		RecLock("SX1",.F.)
		SX1->X1_PERGUNT := If(SX1->X1_ORDEM=="04","Grupos 1?","Grupos 2?")
		SX1->X1_TAMANHO := 30
		SX1->X1_F3      := ""
		SX1->X1_VALID   := ""
		MsUnLock()
	EndIf

	DbSkip()
	
EndDo

RestArea(_aArea)

Return