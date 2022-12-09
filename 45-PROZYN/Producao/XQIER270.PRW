#INCLUDE "QIER270.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE IMP_PDF 6
#DEFINE IMP_SPOOL 2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ QIER270	³ Autor ³ Antonio Aurelio       ³ Data ³ 30.08.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Etiqueta de Laudo                      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QIER270(cProg)                                			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAQIE  												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ STR		 ³ Ultimo utilizado: 0012                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Vera        ³23/09/99³ÄÄÄÄÄÄ³ Impressao a pertir do vetor - import. ent³±±
±±³Paulo Emidio³18/05/00³------³Retirada da Funcao de ajuste do SX1       ³±±
±±³Paulo Emidio³25/05/01³META  ³ Alterado programa para que possa ser sele³±±
±±³       	   ³		³	   ³ cionado o Tipo da Nota Fiscal de Entrada ³±±
±±³       	   ³		³	   ³ sendo a mesma 1)Normal 2)Beneficiamento  ³±±
±±³       	   ³		³	   ³ 3)Devolucao.							  ³±±
±±³Paulo Emidio³01/06/01³009300³ Alterado programa para que nao seja efe- ³±±
±±³			   ³        ³      ³ tuado o salto de pagina ao termino da im-³±±
±±³			   ³		³	   ³ pressao das etiquetas.					  ³±±
±±³Aldo        ³30/01/02³------³ Incluido na IndRegua ".And." nos ultimos ³±±
±±³            ³        ³      ³ parametros.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XQIER270 (cProg,nMv_par11, nMv_par12,aVetQEK,lImpFic,lEtiqRast)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Se for chamado pelo cadastro Entradas ou pelo menu, nao passa o vetor com ³ 
//³  a chave de cada Entrada												   ³ 
//³  Se for chamado pela importacao, passa o vetor com as Entradas para a im-  ³ 
//³  pressao das etiquetas.													   ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel   := "QIER270"
Local cString := "QEK"
Local cDesc1  := STR0001 //"Ser„o impressas as etiquetas de Laudo.          "
Local cDesc2  := STR0002 //"           "
Local cDesc3  := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Guarda aquivo e indices correntes    ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAlias    := Alias()
Local nOldOrder := IndexOrd()

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo	 := STR0003	// "Etiqueta de Laudo"
Private cTamanho := "P"
Private nPagina	 := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault    ³
//³  e SetPrint                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0004, 1,STR0005,  1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nLastKey := 0
Private cPerg    := "QER270"
Private nRecno   := QEK->(Recno())
Private lEnd     := .F.
Private nLimite  := 80
Private lImpFic  := lImpFic
Private lEtiqRast:= lEtiqRast


Default cProg := "QIER270"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					     ³
//³ mv_par01			  // Fornecedor de					     ³
//³ mv_par02			  // Fornecedor ate		    		   	 ³
//³ mv_par03			  // Loja Fornecedor de	 				 ³
//³ mv_par04			  // Loja Fornecedor ate   				 ³
//³ mv_par05			  // Produto de							 ³
//³ mv_par06			  // Produto ate 						 ³
//³ mv_par07			  // Data Entrada de					 ³
//³ mv_par08           	  // Data Entrada ate                    ³
//³ mv_par09              // Lote de                             ³
//³ mv_par10              // Lote ate                            ³
//³ mv_par11              // Assumir Tam.Lote                    ³
//³ mv_par12              // N§ de Etiquetas se Nao Usar Tam.Lote³
//³ mv_par13              // Considera Entrada 1)Normal			 ³
//³											   2)Beneficiamento  ³
//³ 										   3)Devolucao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

If cProg $ "QIEA200.QIER220"
	mv_par11 := nMv_par11
	mv_par12 := nMv_par12
	cPerg    := ""  // Desabilita a pergunte
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Assume valores caso usu rio nao digite ou digite zero ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF(mv_par11<1,mv_par11:=1,)
IF(mv_par12<1,mv_par12:=1,)
IF(cProg == NIL, cProg := "",)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se apertou o botao cancela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return .F.
EndIf

If nLastKey == 27
	Return .F.
EndIf

RptStatus({|lEnd| A270Imp(@lEnd,cString,cProg,aVetQEK,lImpFic,lEtiqRast)},cTitulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o arq anterior             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(nOldOrder)
dbGoTo(nRecNo)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ A270Imp  ³ Autor ³ Antonio Aurelio       ³ Data ³ 30.08.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime as Etiquetas dos Produtos da Entregua              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd  - Verifica se o foi cancelada a impressao            ³±±
±±³			 ³ wnRel - Usada na fun‡Æo OurSpool                           ³±±
±±³			 ³ cProg - Usada na verifica‡Æo do prmg chamador desta fun‡Æo ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ A200Imp(QIER200.PRW) e A210Imp(QIER210.PRW)				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270Imp(lEnd,cString,cProg,aVetQEK,lImpFic,lEtiqRast)
Local lImp	  := .T.
Local nIEnt	  := 0
Local cIndex1 := ""
Local cFiltro := ""
Local cKey	  := ""

Private  cTamLot := ""
Private  nLin := 0

Setprc(00,00)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao a partir do menu de Relatorios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !cProg $ "QIEA200.QIER220"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Indice Condicional nos arquivos utilizados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cIndex1 := CriaTrab( Nil, .F. )

	dbSelectarea("QEK")
	dbSetOrder(1)
	cKey:=IndexKey()
	cFiltro := 'QEK_FILIAL == "'+xFilial("QEK") +'"'
	cFiltro += '.And. QEK_FORNEC >="'+mv_par01+'".And. QEK_FORNEC <="'+mv_par02+'".And.'
	cFiltro += 'QEK_LOJFOR >="'+mv_par03+'".And. QEK_LOJFOR <="'+mv_par04+'".And.'
	cFiltro += 'QEK_PRODUT >="'+mv_par05+'".And. QEK_PRODUT <="'+mv_par06+'".And.'
	cFiltro += 'DTOS(QEK_DTENTR) >="'+DTOS(mv_par07)+'".And.DTOS(QEK_DTENTR) <="'+DTOS(mv_par08)+'".And.'
	cFiltro += 'QEK_LOTE >="'+mv_par09+'".And. QEK_LOTE <="'+mv_par10+'"'

	If mv_par13	== 1
		cFiltro += ' .And. (QEK_TIPONF == "N"'+'.Or. QEK_TIPONF == " ")'
	ElseIf mv_par13 == 2
		cFiltro += ' .And. QEK_TIPONF == "B"'
	ElseIf mv_par13 == 3
		cFiltro += ' .And. QEK_TIPONF == "D"'
	EndIf

	IndRegua("QEK",cIndex1,cKey,,cFiltro,STR0006)	//"Selecionando Registros.."
	nIndex := RetIndex("QEK")

	dbSetOrder(nIndex+1)
	dbSeek( xFilial( "QEK" ) )
	A270ImEt(lEnd,,cString,cProg)

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao a partir do cadastro de Entradas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aVetQEK == NIL

		// Reposiciona o QEK
		QEK->(dbGoTo(nRecNo))
		mv_par01 := QEK->QEK_FORNEC
		mv_par02 := QEK->QEK_FORNEC
		mv_par03 := QEK->QEK_LOJFOR
		mv_par04 := QEK->QEK_LOJFOR
		mv_par05 := QEK->QEK_PRODUT
		mv_par06 := QEK->QEK_PRODUT
		mv_par07 := QEK->QEK_DTENTR
		mv_par08 := QEK->QEK_DTENTR
		mv_par09 := QEK->QEK_LOTE
		mv_par10 := QEK->QEK_LOTE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utiliza o Tam.Lote corrente ou assume   ³
		//³   o informado na pergunte mv_par12      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par11 == 1
			cTamLot := QEK->QEK_TAMLOT
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Troca a virgula por ponto outros        ³
			//³   caracteres sao bloqueados no cadastro ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AT(",",cTamLot) > 0
				cTamLot := StrTran(cTamLot,",",".")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se o Tam.Lote nao for inteiro ‚ adicionado   ³
			//³  uma etiqueta a mais                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Int(SuperVal(cTamLot)) == SuperVal(cTamLot)
				mv_par12 := Int(SuperVal(cTamLot))
			Else
				mv_par12 := Int(SuperVal(cTamLot)) + 1
			EndIf
		EndIf
		lImp := .T.

		A270ImEt(lEnd,,cString,cProg)

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao a partir da importacao de Entradas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbselectArea("QEK")
		Dbsetorder(14)
		For nIEnt := 1 To Len(aVetQEK)
            //If !lImpFic .and. !lEtiqRast
			//	aVetQEK[nIEnt] := xFilial("QEK")+aVetQEK[nIEnt]
            //Endif
			// Posiciona o QEK
			If QEK->(dbSeek(aVetQEK[nIEnt]))
				mv_par01 := QEK->QEK_FORNEC
				mv_par02 := QEK->QEK_FORNEC
				mv_par03 := QEK->QEK_LOJFOR
				mv_par04 := QEK->QEK_LOJFOR
				mv_par05 := QEK->QEK_PRODUT
				mv_par06 := QEK->QEK_PRODUT
				mv_par07 := QEK->QEK_DTENTR
				mv_par08 := QEK->QEK_DTENTR
				mv_par09 := QEK->QEK_LOTE
				mv_par10 := QEK->QEK_LOTE
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Utiliza o Tam.Lote corrente ou assume   ³
				//³   o informado na pergunte mv_par12      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par11 == 1
					cTamLot := QEK->QEK_TAMLOT
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Troca a virgula por ponto outros        ³
					//³   caracteres sao bloqueados no cadastro ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If AT(",",cTamLot) > 0
						cTamLot := StrTran(cTamLot,",",".")
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se o Tam.Lote nao for inteiro ‚ adicionado   ³
					//³  uma etiqueta a mais                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Int(SuperVal(cTamLot)) == SuperVal(cTamLot)
						mv_par12 := Int(SuperVal(cTamLot))
					Else
						mv_par12 := Int(SuperVal(cTamLot))+1
					EndIf
				EndIf
				lImp := .T.
				A270ImEt(lEnd,,cString,cProg)
			EndIf
		Next
	EndIf
EndIf

MS_FLUSH()
Return(.T.)
        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ A270ImEt ³ Autor ³ Antonio Aurelio       ³ Data ³ 04.05.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime as Etiquetas dos Produtos da Entrada               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd  - Verifica se o foi cancelada a impressao            ³±±
±±³			 ³ wnRel - Usada na fun‡Æo OurSpool                           ³±±
±±³			 ³ cProg - Usada na verifica‡Æo do prmg chamador desta fun‡Æo ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³   														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ A270Imp                                         			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A270ImEt(lEnd,cString,cProg)

Local cFor		  := ""
Local cLojFor	  := ""
Local nC          := 0
Local cEtiq       := ""
Local cChaveQEK1  := ""
Local nDias       := 0
Local nOrdQE6	  := QE6->(IndexOrd())
Local nOrdSAH	  := SAH->(IndexOrd())
Local nOrdQEL     := QEL->(IndexOrd())
Local nOrdQED     := QED->(IndexOrd())
Local cDirPrint   := GetTempPath() // Dirétorio Temporário
Local nSaltPag    := 0
Local cSeek       := ""
Local oFont06
Local oPrint
Local lin := 80
Local nEtiqueta  
Local lQReinsp	  := QieReinsp()
Local cSerie
Local cNameFile   := "Etiquetas_Produto_Entrada"
Local cDirectory  := GetSrvProfString( "StartPath" , "" )

oFont06		:= TFont():New("Arial",06,10,,.T.,,,,.T.,.F.)
//oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N§ de Etiquetas a serem impressas 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !cProg $ "QIEA200.QIER220"
	SetRegua( QEK->(RecCount()) )  // Depende da selecao feita na pergunte
Else
	If mv_par11 == 1  // Assume o tamanho do lote
		SetRegua(mv_par12 * QEK->(RecCount()))
	Else
		SetRegua(mv_par12 )  // S¢ o tamanho especificado
	EndIf
EndIf

dbSelectArea("QEK")
oPrint := FWMsPrinter():New(cNameFile,IMP_SPOOL,.T.,cDirectory,.F.,,,"" )
oPrint:cPathPDF := cDirPrint  // Diretório para o arquivo PDF
oPrint:SetPortrait()
oPrint:lServer := .F. 
oPrint:SetMargin(50,50,0,0) // Seta as margens
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:nDevice := IMP_SPOOL // Tipo de impressão
While QEK->(!Eof()) .And. xFilial("QEK") == QEK->QEK_FILIAL .And. ;
		QEK->QEK_FORNEC >= mv_par01 .And. QEK->QEK_FORNEC <= mv_par02 .And.;
		QEK->QEK_LOJFOR >= mv_par03 .And. QEK->QEK_LOJFOR <= mv_par04 .And.;
		QEK->QEK_PRODUT >= mv_par05 .And. QEK->QEK_PRODUT <= mv_par06 .And.;
		QEK->QEK_DTENTR >= mv_par07 .And. QEK->QEK_DTENTR <= mv_par08 .And.;
		QEK->QEK_LOTE   >= mv_par09 .And. QEK->QEK_LOTE   <= mv_par10
		
	cChaveQEK1	:= QEK->QEK_PRODUT+Inverte(QEK->QEK_REVI)
	cLojFor	    := QEK->QEK_LOJFOR
	cFor		:= QEK->QEK_FORNEC

	dbSelectArea("QE6")
	dbSetOrder(1)
	QE6->(dbSeek(xFilial("QE6")+cChaveQEK1))

	If QE6->(!Found())
		// "Produto/Revisao nao cadastrados:
		Set Device to Screen
		Help(" ",1,"QE_NAOPRRV",,AllTrim(QEK->QEK_PRODUT)+" / "+QEK->QEK_REVI,2,1)
		Set Device to Printer
		dbSelectArea("QEK")
		QEK->(dbSkip())
		Loop
	EndIf

	cProduto := QE6->QE6_PRODUT+QE6->QE6_REVI

	If QE6->QE6_UNSHEL == "1"  // Dia
		nDias := QE6->QE6_SHLF
	Else
		If QE6->QE6_UNSHEL == "2" // Mes
			nDias := QE6->QE6_SHLF * 30
		Else
			nDias := QE6->QE6_SHLF * 365
		EndIf
	EndIf


	QEL->(dbSetOrder(3))
	cSeek := QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_ITEMNF+QEK->QEK_TIPONF+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
	Space(TamSX3("QEL_LABOR")[1])
	If lQReinsp
		cSeek += QEK->QEK_NUMSEQ
	Endif

	
	If	QEL->(dbSeek(xFilial("QEL")+cSeek))

		If lQReinsp 
			While QEL->(!Eof()) .And. ;
					QEL->(QEL_FILIAL+QEL_FORNEC+QEL_LOJFOR+QEL_PRODUT+DTOS(QEL_DTENTR)+QEL_LOTE)+Space(TamSX3("QEL_LABOR")[1]) == xFilial("QEL")+cSeek
				
				If QEL->QEL_NUMSEQ == QEK->QEK_NUMSEQ
					Exit
				Endif
				
				QEL->(dbSkip())
			Enddo
		Endif

		If Empty(QEL->(QEL_NUMPER))
			If QED->(dbSeek(xFilial("QED")+QEL->QEL_LAUDO))
				cEtiq := AllTrim(QED->QED_DESCPO)
			Else
				cEtiq := STR0010 // EM INSPECAO
			EndIf
		Else
			QF2->(dbSetOrder(1))
			If QF2->(dbSeek(xFilial("QF2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
					QEK->QEK_PRODUT+Dtos(QEK->QEK_DTENTR)+QEK->QEK_LOTE+;
					QEL->QEL_NUMPER))
				// Se a PU for Aprovada, o laudo a ser impresso e Liberado
				If QF2->QF2_STATUS == "A"
					cEtiq := STR0012	// "LIBERADO"
				Else
					// Permanece o laudo definido pelo usuario
					If QED->(dbSeek(xFilial("QED")+QEL->QEL_LAUDO))
						cEtiq := AllTrim(QED->QED_DESCPO)
					Else
						cEtiq := STR0010 // EM INSPECAO
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		cEtiq := STR0010 // EM INSPECAO
	EndIf


	If !cProg $ "QIEA200.QIER220"
		If mv_par11 == 1  // Assume o Tam. do Lote
			cTamLot := QEK->QEK_TAMLOT
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Troca a virgula por ponto outros        ³
			//³   caracteres sao bloqueados no cadastro ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AT(",",cTamLot) > 0
				cTamLot := StrTran(cTamLot,",",".")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se o Tam.Lote nao for inteiro ‚ adicionado   ³
			//³  uma etiqueta a mais                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Int(SuperVal(cTamLot)) == SuperVal(cTamLot)
				mv_par12 := Int(SuperVal(cTamLot))
			Else
				mv_par12 := Int(SuperVal(cTamLot)) + 1
			EndIf
		EndIf
	EndIf

	If mv_par11 == 1	
		nEtiqueta:= Int(SuperVal(cTamLot))
	Else	
		nEtiqueta:= mv_par12
    Endif


	oPrint:StartPage() 		
	For nC := 1 To mv_par12

		IncRegua()

	   If lEnd
			nLin := nLin + 1
			@ nLin ,001 PSAY STR0007  // "CANCELADO PELO OPERADOR"
			Exit
		EndIf

		nSaltPag:= nSaltPag + 1
		lin += 30

		oPrint:Say(lin,0020,cEtiq,oFont06)        
		lin += 30

		//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		//Produto....: 0123456789012345 - XX
		//              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		//Data Entreg: 99/99/9999 Lote.....: 0123456789012345
		//Validade...: 99/99/9999 Tam.Lote.: 012345678 XXXXXXXXX
		//Nota Fiscal: 0123456789012 012
		// 			1			 2 		  3			4			 5 		  6			7			 8 		  9			10 		 11		  12			13
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

        oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_PRODUT")[1]),11,".")+" : " +AllTrim(QEK->QEK_PRODUT)+" - " +QEK->QEK_REVI,oFont06)        
		lin += 30

		oPrint:Say(lin,0150,QE6->QE6_DESCPO,oFont06)        
		lin += 30

		oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_DTENTR")[1]),11,".")+" : "+dtoc(QEK->QEK_DTENTR)+"  "+Pad(AllTrim(TitSx3("QEK_LOTE")[1]),10,".")+" : "+AllTrim(QEK->QEK_LOTE),oFont06)        
		lin += 30
		
		SAH->(dbSetOrder(1))
		SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
		If !Empty(SAH->AH_UMRES)
			oPrint:Say(lin,0020,STR0011+"    "+dtoc(QEL->QEL_DTVAL)+"  "+Pad(AllTrim(TitSx3("QEK_TAMLOT")[1]),11,".")+" : "+AllTrim(QEK->QEK_TAMLOT)+" "+SAH->AH_UMRES,oFont06) 	// "Validade..: "       
		Else
			oPrint:Say(lin,0020,STR0011+"    "+dtoc(QEL->QEL_DTVAL)+"  "+Pad(AllTrim(TitSx3("QEK_TAMLOT")[1]),11,".")+" : "+AllTrim(QEK->QEK_TAMLOT),oFont06) 	       
		Endif		

		lin += 30
		cSerie:= SerieNfId("QEK",3,"QEK_SERINF")
		If !Empty(QEK->(&cSerie))   		
			oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_NTFISC")[1]),11,".")+" : "+AllTrim(QEK->QEK_NTFISC)+" - "+QEK->(&cSerie),oFont06)        		
		Else
			oPrint:Say(lin,0020,Pad(AllTrim(TitSx3("QEK_NTFISC")[1]),11,".")+" : "+AllTrim(QEK->QEK_NTFISC),oFont06)        		
		EndIf

		//Adicionar Ensaiador - Gustavo Gonzalez - 03/08/2020
		lin += 30
		oPrint:Say(lin,0020,"Ensaiador: " + ALLTRIM(POSICIONE('QAA',1,xFilial('QAA')+QER->QER_ENSR,'QAA_NOME')),oFont06)

		//Adicionar Medições
		cQuery :=   " SELECT * FROM " + RetSqlName("QER") + ;
					" WHERE QER_PRODUT = '" + QEK->QEK_PRODUT + "' AND QER_LOTE = '" + QEK->QEK_LOTE + "' AND QER_NTFISC = '" + QEK->QEK_NTFISC + "' AND QER_SERINF = '" + QEK->QEK_SERINF + "' AND D_E_L_E_T_ = ''"
		
		If select('ENSAIOS') > 0
			('ENSAIOS')->(DbCloseArea())
		EndIf
		TcQuery cQuery New Alias 'ENSAIOS'

    	While ('ENSAIOS')->(!Eof())
			cEnsaio	:= Alltrim(POSICIONE('QE1',1,XFILIAL('QE1')+('ENSAIOS')->QER_ENSAIO,'QE1_DESCPO'))
			If POSICIONE('QE1',1,XFILIAL('QE1')+('ENSAIOS')->QER_ENSAIO,'QE1_CARTA') == 'TXT'
				cMedicao	:= Alltrim(POSICIONE('QEQ',1,XFILIAL('QEQ')+('ENSAIOS')->QER_CHAVE,'QEQ_MEDICA'))
			Else
				cMedicao	:= Alltrim(POSICIONE('QES',1,XFILIAL('QES')+('ENSAIOS')->QER_CHAVE,'QES_MEDICA'))
			EndIf
			cUnMed		:= POSICIONE('QE7',3,XFILIAL('QE7')+('ENSAIOS')->QER_ENSAIO+('ENSAIOS')->QER_PRODUT,'QE7_UNIMED')
			cDescUnMed	:= Alltrim(POSICIONE('SAH',1,XFILIAL('SAH')+cUnMed,'AH_UMRES'))

			lin += 30
			oPrint:Say(lin,0020, cEnsaio + ": " + cMedicao + " " + cDescUnMed ,oFont06)
		
			('ENSAIOS')->(DBSkip())		
		EndDo


		If lin > 2500  
			oPrint:EndPage() 		
			lin := 80
			nSaltPag:= 0
		Else
			If nSaltPag == 	nEtiqueta // Pula de Pagina de acordo com o numero de etiquetas 
				If lin > 2500  
					oPrint:EndPage() 		
					lin := 80
					nSaltPag:= 0
					nSaltPag:= 0           
					oPrint:EndPage() 		
				Endif	
				lin += 100
			Else			
				lin += 100 
			EndIf
	    Endif

	Next

	QEK->(dbSkip())

	If lEnd
		Exit
	EndIf

EndDo

oPrint:EndPage() 
oPrint:Print()  


FreeObj(oPrint)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os ¡ndices dos arq. usados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QE6")
dbSetOrder(nOrdQE6)
dbSelectArea("SAH")
dbSetOrder(nOrdSAH)
dbSelectArea("QED")
dbSetOrder(nOrdQED)
dbSelectArea("QEL")
dbSetOrder(nOrdQEL)

Return(.T.)
