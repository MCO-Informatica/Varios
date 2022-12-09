#Include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR530  ³ Autor ³ Wagner Xavier         ³ Data ³ 04.01.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Resumo Bancario - Movimento Financeiro Di rio              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR530(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINR30()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cString:="SA6"
LOCAL cDesc1 :=OemToAnsi("Este programa ir  emitir o resumo da Movimenta‡„o")  //"Este programa ir  emitir o resumo da Movimenta‡„o"
LOCAL cDesc2 :=OemToAnsi("Bancaria de um determinado dia.")  //"Bancaria de um determinado dia."
LOCAL cDesc3 :=""
LOCAL titulo :=OemToAnsi("Movimento Diario Bancos")  //"Movimento Financeiro Diario"
LOCAL Tamanho := "M"

PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="RFINR30"
PRIVATE nLastKey := 0
PRIVATE cPerg   :="FINR30    "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If pergunte("FIN530",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // A partir de                          ³
//³ mv_par02            // Qual moeda                           ³
//³ mv_par03            // Considera Limite de Credito          ³ 
//³ mv_par04            // Outras Moedas                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	MsgRun( OemToAnsi( "Aguarde a geracao do relatório..." ),, { || Fa530Imp(titulo)} )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA530Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 04.01.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Resumo Bancario                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA530Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA530Imp(titulo)
LOCAL CbCont,CbTxt
LOCAL tamanho:="M"
LOCAL limite := 132
LOCAL nSaldoIni,cBanco,cAgencia,cConta,nRecBco:=0,nPagBco:=0
LOCAL nTotPag  := 0
LOCAL nTotRec  := 0
LOCAL nTotDisp := 0
LOCAL nTotIni  := 0
LOCAL nTotAplic:= 0
LOCAL nTotLimCred := 0
LOCAL nDisponiv:=0
LOCAL cFil    :=""
LOCAL nOrdSE5 :=SE5->(IndexOrd())
LOCAL cChave
LOCAL cIndex
Local nTxMoeda:=0
Local nValor := 0
Local cFilterUser := aReturn[7]
Local nMoedaBco	:=	1                                   
Local nCasas	:= GetMv("MV_CENT"+(IIF(mv_par02 > 1 , STR(mv_par02,1),""))) 
Local nMoeda    := mv_par02
Local bCondWhile
Local nTxMoedBc	:= 0
Local aCampos	:= {}
Local nCtBco := 0
Local nSaldoBco := 0
Local nTotSaldo := 0
Local aBancos   := {}
Local nA		:= 0
Local nCt		:= 0
Local lFirst := .T.
Local cNome     := ""
Local nCtCC  := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lAllFil :=.F.

dbSelectArea("SA6")
dbSeek(xFilial())

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Cria o arquivo de trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E5_FILIAL")
AADD(aCampos,{"TB_FILIAL"  ,"C",5,0})
aTam:=TamSX3("E5_DATA")
AADD(aCampos,{"TB_DATA"    ,"D",aTam[1],aTam[2]})
aTam := TamSX3("A6_SALATU")
AADD(aCampos,{"TB_SLDINI"    ,"C",aTam[1],aTam[2]})

While !Eof() .and. A6_FILIAL == xFilial()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	cBanco    := A6_COD
    nCtBco++
	nCtCC := 1
	While !Eof() .And. SA6->A6_COD == cBanco
		AADD(aCampos,{"TB_BCO"+StrZero(nCtBco,2)+StrZero(nCtCC,2),"C",aTam[1],aTam[2]})
	    nCtCC++
		SA6->(dbSkip())
    Enddo

Enddo

AADD(aCampos,{"TB_SLDFIM" ,"C",aTam[1],aTam[2]})

/*
	aTam:=TamSX3("E5_AGENCIA")
	AADD(aCampos,{"TB_AGENCIA" ,"C",aTam[1],aTam[2]})
	aTam:=TamSX3("E5_CONTA")
	AADD(aCampos,{"TB_CONTA" ,"C",aTam[1],aTam[2]})
	aTam:=TamSX3("A6_NOME")
	AADD(aCampos,{"TB_NOME" ,"C",aTam[1],aTam[2]})

	aTam:=TamSX3("A6_SALATU")
	AADD(aCampos,{"TB_ENTRADA" ,"N",aTam[1],aTam[2]})
	aTam:=TamSX3("A6_SALATU")
	AADD(aCampos,{"TB_SAIDA" ,"N",aTam[1],aTam[2]})
	aTam:=TamSX3("A6_SALATU")
	AADD(aCampos,{"TB_LIMITE" ,"N",aTam[1],aTam[2]})
	aTam:=TamSX3("A6_SALATU")

*/

cTrabalho := CriaTrab(aCampos)
Use &cTrabalho Alias TRB New

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo += OemToAnsi(" de ")  +DtoC(mv_par01)  //" de "
cabec1 := OemToAnsi("Cod Agencia Conta      Nome                   Saldo Inicial         Entradas           Saidas         Limite        Saldo Disponivel")  //"Cod Agencia Conta      Nome                   Saldo Inicial         Entradas           Saidas         Aplicacoes    Saldo Disponivel"
cabec2 := ""
nCtBco := 4

If Empty(xFilial( "SA6")) .and. !Empty(xFilial("SE5"))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo por tipo e vencimento                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	dbSetOrder(nOrdSE5)
	cIndex  := CriaTrab(nil,.f.)
	cChave  	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
	IndRegua("SE5",cIndex,cChave,,fr530Check(),OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."	
	nIndex   := RetIndex("SE5")
	dbSelectArea("SE5")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGoTop()
	lAllFil:= .T.
	dbSeek(cFil+DtoS(mv_par01),.T.)
Else
	dbSelectArea("SE5")
	cIndex  := CriaTrab(nil,.f.)
	cChave  	:= "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
	indRegua("SE5",cIndex,cChave,,fr530Check(),OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	nIndex   := RetIndex("SE5")	
	dbSelectArea("SE5")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGoTop()
	dbSeek(cFil+DtoS(mv_par01),.T.)
Endif

cFil:= Iif(lAllFil,"",xFilial("SE5"))

dbSelectArea("SA6")
dbSeek(xFilial())

aBancos := array(3,Len(aCampos))

aBancos[1,1] := "TAXAS"
aBancos[1,2] := CtoD(" / / ")

aBancos[2,1] := " "
aBancos[2,2] := CtoD(" / / ")

aBancos[3,1] := xFilial("SA6")
aBancos[3,2] := MV_PAR01

For nCt := 3 To Len(aCampos)
	aBancos[1,nCt] := " "
	aBancos[2,nCt] := " "
	aBancos[3,nCt] := " "
Next

While !Eof() .and. A6_FILIAL == xFilial()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa saldo anterior                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aBancos[1,nCtBco] := SA6->A6_NREDUZ
	aBancos[2,nCtBco] := SA6->A6_NUMCON
	
	cBanco    := A6_COD
	cAgencia  := A6_AGENCIA
	cConta    := A6_NUMCON
	cNome     := A6_NREDUZ
	If mv_par03 == 1
		nLimCred  := A6_LIMCRED //+ A6_LIMCRE2 + A6_LIMCRE3
	Else
		nLimCred  := 0
	EndIf
	If cPaisLoc	#	"BRA"
		nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	Endif
	dbSelectArea("SE8")
	dbSeek( xFilial()+cBanco+cAgencia+cConta+DtoS(mv_par01), .T. )
	dbSkip( -1 )
	If E8_BANCO!=cBanco .or. E8_AGENCIA!=cAgencia .or. E8_CONTA!=cConta ;
		.or. Bof()
		nSaldoIni := 0
	Else
		nSaldoIni := SE8->E8_SALATUA
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso considere limite de credito, soma limite ao saldo Inicial ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par03 == 1
//		nSaldoIni+=xMoeda(nLimCred,nMoedaBco,mv_par02,mv_par01,nCasas+1)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localizar movimentacao bancaria do banco                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	dbSetOrder(nIndex + 1 )
	dbSeek(cFil+dToS(mv_par01)+cBanco+cAgencia+cConta,.T.)
	
	If (lAllFil)
		bCondWhile := { || !Eof() .And. E5_DTDISPO == mv_par01 .and. E5_BANCO+E5_AGENCIA+E5_CONTA == cBanco+cAgencia+cConta }
	Else
		bCondWhile := { || !Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO == mv_par01 .and. E5_BANCO+E5_AGENCIA+E5_CONTA == cBanco+cAgencia+cConta }
	EndIf
	
	While Eval(bCondWhile)
		
		
		If !Fr530Skip(cBanco,cAgencia,cConta)
			dbSkip()
			Loop
		EndIf

		IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Na transferencia somente considera nestes numerarios 		  ³
		//³ No Fina100 ‚ tratado desta forma.                    		  ³
		//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
		//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
      //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
      //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
      //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
         If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
				dbSkip()
				Loop
			Endif
		Endif

		If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
			.or. Substr(E5_DOCUMEN,1,1) == "*" )
			dbSkip()
			Loop
		Endif

		If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		//Sangria
			dbSkip()
			Loop
		Endif

		If SubStr(E5_NUMCHEQ,1,1)=="*"  .AND. E5_RECPAG=="P"    //cheque para juntar (PA)
			dbSkip()
			Loop
		Endif

		If !Empty( E5_MOTBX )
			If !MovBcoBx( E5_MOTBX )
				dbSkip( )
				Loop
			EndIf
		EndIf

        If mv_par04 == 2
           If nMoedaBco <> nMoeda
              SE5->(DbSkip())
              Loop
           EndIf
        EndIf    

		dbSelectArea("SE5")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE5->(FieldPos('E5_TXMOEDA')) > 0
			nTxMoedBc := SE5->E5_TXMOEDA	
		Else  	
			nTxMoedBc := 0
		Endif
		If mv_par02 > 1 .and. !Empty(E5_VLMOED2)
			nTxMoeda := RecMoeda(E5_DTDISPO,mv_par02)
			nTxMoeda :=if(nTxMoeda=0,1,nTxMoeda)
			nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par02,,nCasas+1,nTxMoedBc,nTxMoeda),nCasas)
		Else
			nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par02,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas) 
		Endif

		IF !(SE5->E5_RECPAG $ "PR" .and. SE5->E5_TIPODOC == "AP")
			IF E5_RECPAG="R"
				nRecBco+=nValor
			Else
				nPagBco+=nValor
			EndIF
		Endif

		dbSkip()
	Enddo
	
	dbSelectArea("SA6")
	dbSkip()

	aBancos[3,3] := Str(Val(aBancos[2,3])+nSaldoIni)
	aBancos[3,nCtBco] := Str(nSaldoIni+(nRecBco-nPagBco)+nLimCred)

    nTotSaldo += (nSaldoIni+(nRecBco-nPagBco)+nLimCred)
    
    nCtBco++

	
EndDO

//
//@li,000 PSAY OemToAnsi("TOTAL GERAL ----->")  //"TOTAL GERAL ----->"
//@li,043 PSAY nTotIni  	PicTure tm(nTotIni,16,nCasas)
//@li,060 PSAY nTotRec  	PicTure tm(nTotRec,16,nCasas)
//@li,077 PSAY nTotPag	PicTure tm(nTotPag,16,nCasas)
//@li,096 PSAY nTotLimCred	PicTure tm(nTotLimCred,16,nCasas)
//@li,116 PSAY nTotDisp	PicTure tm(nTotDisp,16,nCasas)

//dbSelectArea("TRB")
//RecLock("TRB",.T.)                          
//TRB->TB_FILIAL := "TAXAS"
//MsUnLock()

For nCt:= 1 to Len(aBancos)
	dbSelectArea("TRB")
	RecLock("TRB",.T.)                          
    For nA:= 1 To Len(aBancos[nCt])
		If nA > 2
			FieldPut( nA, AllTrim(aBancos[nCt,nA]))	
		Else
			FieldPut( nA, aBancos[nCt,nA])	
		Endif
    Next
    If nCt == 3
		TRB->TB_SLDFIM := AllTrim(Str(nTotSaldo))
    Endif
	MsunLock()
Next

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Elimina os arquivos de trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea ( "TRB" )          
cArquivo := IIF(!EMPTY(MV_PAR05),MV_PAR05,"MOVDIABCO.XLS")
COPY TO &cArquivo
dbCloseArea ()

dbSelectArea("SA6")
dbSetOrder(1)
Set Filter To

dbSelectArea("SE5")
RetIndex("SE5")
dbSetOrder(1)

If !Empty(cIndex)
	FErase (cIndex+OrdBagExt())
Endif

dbSetOrder(1)
Set Filter To
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr530Skip ³ Autor ³ Pilar S. Albaladejo	  ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR530.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr530Skip(cBanco,cAgencia,cConta)

Local lRet := .T.

IF E5_TIPODOC $ "DC/JR/MT/CM/BA/D2/J2/M2/C2/V2"  //Valores de Baixas
	lRet := .F.
ElseIf E5_BANCO+E5_AGENCIA+E5_CONTA!=cBanco+cAgencia+cConta
	lRet := .F.
ElseIf E5_SITUACA = "C"		//Cancelado
	lRet := .F.
EndIF
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ Banco ( cBanco )                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Lu¡s C. Cunha                            ³ Data ³ 13.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Obt‚m a descri‡„o de um agente de cobran‡a ( banco ) no ar-³±±
±±³           ³ quivo SA6.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par„metros³ cBcoAgen ú C¢digo do banco+agencia                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Banco ( cBcoAgenCt )

Local cDescricao := ""
Local cArquivo   := Alias ()
Local nOrdem     := 0

dbSelectArea ( "SA6" )
nOrdem := IndexOrd ()
SA6 -> ( dbSetOrder ( 1 ) )
If ( SA6 -> ( dbSeek ( cFilial + cBcoAgenCt ) ) )
	cDescricao := SA6 -> A6_NOME
Else
	cDescricao := OemToAnsi("BANCO NAO DEFINIDO ( ") + cBcoAgenCt + " )"  //"BANCO NAO DEFINIDO ( "
End
SA6 -> ( dbSetOrder ( nOrdem ) )
dbSelectArea ( cArquivo )

Return ( cDescricao )
