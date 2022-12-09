#Include "PROTHEUS.CH"
# Define ANALITICO   ( nNivel == 1 )
# Define SINTETICO   ( nNivel == 2 )
# Define PAGAMENTO   ( nOperacao == 1 .or. nOperacao == 3 )
# Define RECEBIMENTO ( nOperacao == 2 .or. nOperacao == 3 )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ RFINR20  ³ Autor ³    			         ³ Data ³ 05/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Movimenta‡„o di ria do caixa                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ RFINR20 ()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGAFIN                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos  ³ SA6 ( cadastro de bancos )                                 ³±±
±±³           ³ SE5 ( movimenta‡„o banc ria )                              ³±±
±±³           ³ SED ( cadastro de naturezas )                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFINR20 ()

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cArea      := ""
Local cDesc1     := ""
Local cDesc2     := ""
Local cDesc3     := ""
Local nTamanho   := 0

LOCAL wnrel
LOCAL cString:="SE5"

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCabecalho := ""
Private cPerg      := ""
Private cRelatorio := ""
Private cTitulo    := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis utilizadas para impressao do cabe‡alho e rodap‚ ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Li     := 0
Private M_Pag  := 1

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis utilizadas pela fun‡„o SetDefault () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nLastKey := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis p£blicas utilizadas em macro-substitui‡„o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cIndice := ""
Private cMoeda  := ""
Private cQuebra := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Verifica os par„metros selecionados e en- ³
// ³ via o controle para a fun‡„o SetPrint ()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aOrdem := {OemToAnsi("Por Recibo"),OemToAnsi("Por Data"),OemToAnsi("POr Banco"),OemToAnsi("Por Natureza") }  //"Por Data"###"Por Numerario"###"Por Banco"###"Por Natureza"  

cArea      := "SE5"
cDesc1     := "Movimenta‡„o di ria do caixa, de forma anal¡tica ( detalhada ) ou sin-"
cDesc2     := "t‚tica  ( apenas os totais ). Informa os valores pagos e/ou  recebidos"
cDesc3     := "no intervalo definido."
cPerg      := "FINR20    "  // Nome do grupo de perguntas
cRelatorio := "RFINR20" // Nome do relat¢rio em disco
cTitulo    := OemToAnsi("Movimento Diario Caixa")    //"Movimento diario do caixa"
nTamanho   := "G"

Pergunte ( cPerg, .F. )

cRelatorio := SetPrint (            ;
								cArea,      ;
								cRelatorio, ;
								cPerg,      ;
								@cTitulo,   ;
								cDesc1,     ;
								cDesc2,     ;
								cDesc3,     ;
							  .F.,         ;
								aOrdem,     ;
								NIL,        ;
								nTamanho    ;
							  )
If nLastKey == 27
	Return ( NIL )
End

SetDefault ( aReturn, cArea )

If nLastKey == 27
	Return ( NIL )
End

RptStatus({|lEnd| Fa120Imp(@lEnd,wnRel,cString)},cTitulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ FA120Imp ³ Autor ³    			         ³ Data ³ 05/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Movimenta‡„o di ria do caixa                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ FA120Imp(lEnd,wnRel,cString                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGAFIN                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³           ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos  ³ SA6 ( cadastro de bancos )                                 ³±±
±±³           ³ SE5 ( movimenta‡„o banc ria )                              ³±±
±±³           ³ SED ( cadastro de naturezas )                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA120Imp(lEnd,wnRel,cString)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cBancoFinal    := ""
Local cBancoInicial  := ""
Local cNatFinal      := ""
Local cNatInicial    := ""
Local cNumFinal      := ""
Local cNumInicial    := ""
Local dDataFinal     := CtoD ( Space ( 08 ) )
Local dDataInicial   := CtoD ( Space ( 08 ) )
Local nMoeda         := 0
Local nNivel         := 0
Local nOperacao      := 0 
Local nConvert       := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis de controle ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aChave         := {}
Local aCampos        := {}
Local aTam           := {}
Local aNumerario     := {}
Local bTexto         := { || NIL }
Local cAnterior      := ""

Local cOperacao      := ""
Local cTrabalho      := ""
Local lPrimeiro      := .T.
Local nGeralPago     := 0
Local nGeralDIN      := 0
Local nGeralCHE      := 0
Local nGeralDEP      := 0
Local nOrdem         := 0
Local nTotalPago     := 0
Local nTotalDIN      := 0
Local nTotalCHE      := 0
Local nTotalDEP      := 0
Local nSaldoCX		 :=	SaldoIni()
Local nSaldoCH       := MV_PAR14
Local nValor         := 0
Local nMoedaBco	     :=	1                                   
Local nCasas		 := GetMv("MV_CENT"+(IIF(mv_par09 > 1 , STR(mv_par09,1),""))) 
Local aBancos	     :=	{}
Local nD,lPrim	     :=	.T.
Local aColu			 := {}
Local nTxMoedBc		 := 0
Local lImpSaldo		 := .F.
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ Mv_Par01 => Numer rio inicial                                           ³
// ³ Mv_Par02 => Numer rio final                                             ³
// ³ Mv_Par03 => Data inicial                                                ³
// ³ Mv_Par04 => Data final                                                  ³
// ³ Mv_Par05 => Banco inicial                                               ³
// ³ Mv_Par06 => Banco final                                                 ³
// ³ Mv_Par07 => Natureza inicial                                            ³
// ³ Mv_Par08 => Natureza final                                              ³
// ³ Mv_Par09 => Moeda utilizada ( 1...5 )                                   ³
// ³ Mv_Par10 => N¡vel anal¡tico ( 1 ) ou sint‚tico ( 2 )                    ³
// ³ Mv_Par11 => Pagamentos ( 1 ), recebimentos ( 2 ) ou ambos ( 3 )         ³ 
// ³ Mv_Par12 => Outras moedas(Converter/Nao imprimir)                       ³
// ³ Mv_Par13 => Saldo Anterior Cheques										 ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumInicial    := Mv_Par01
cNumFinal      := Mv_Par02
dDataInicial   := Mv_Par03
dDataFinal     := Mv_Par04
cBancoInicial  := Mv_Par05
cBancoFinal    := Mv_Par06
cNatInicial    := Mv_Par07
cNatFinal      := Mv_Par08
nMoeda         := Mv_Par09
nNivel         := Mv_Par10
nOperacao      := Mv_Par11 
nConvert       := Mv_Par12

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Ajusta as vari veis de controle ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOperacao += iIf ( PAGAMENTO, "P", "" )
cOperacao += iIf ( RECEBIMENTO, "R", "" )

dbSelectArea("SEF")
dbSetOrder(3)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aColu := {046,057,073,093,105,133,27,35}
//cCabecalho := OemToAnsi("Data       Recibo    Natureza   Banco NF/Parc.           Cheque          Documento           Vencimento  Beneficiario                    Pagamentos    Rec.Dinheiro       Rec.Cheque    Rec.Deposito         ")  //
cCabecalho := OemToAnsi("Data       Recibo    Natureza   Banco NF/Parc. Cheque           Documento Favorecido/Sacado               P/R  Historico               Dinheiro    Deposito      Debito    Saldo CX         Cheque    Saldo CH")  //
//Data       Recibo    Natureza   Banco NF/Parc. Cheque           Documento Favorecido/Sacado               P/R  Historico               Dinheiro    Deposito   Pagamento    Saldo CX         Cheque    Saldo CH
//99/99/99  123456/12 1234567890  123  123456/1  123456789012345  123456    123456789012345678901234567890  P    12345678901234567890  999.999.99  999.999.99  999.999.99  999.999.99    999.999.99  999.999.99

cMoeda  := LTrim(Str(nMoeda))
cTitulo += " ( " + iIf ( ANALITICO, OemToAnsi("Analitico"), OemToAnsi("Sintetico") )  + " ) em " + ;  //"Analitico"###"Sintetico"
			  GetMv("MV_MOEDA"+cMoeda)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m a tabela de numer rios ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX5 -> ( dbSeek ( cFilial + "06" ) )
SX5 -> ( dbEval (                                           ;
						{ ||                                      ;
							aAdd ( aNumerario, X5Descri() ), ;
							aAdd ( aChave, SX5 -> X5_CHAVE )       ;
						},                                        ;
						NIL,                                      ;
						{ ||                                      ;
							cFilial == SX5 -> X5_FILIAL .and.      ;
							SX5 -> X5_TABELA == "06"               ;
						}                                         ;
		 ) )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Cria o arquivo de trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E5_FILIAL")
AADD(aCampos,{"TB_FILIAL"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_DATA")
AADD(aCampos,{"TB_DATA"    ,"D",aTam[1],aTam[2]})
aTam:=TamSX3("E1_NUM")
AADD(aCampos,{"TB_RECIBO"   ,"C",aTam[1]+3,aTam[2]})
aTam:=TamSX3("E5_BANCO")
AADD(aCampos,{"TB_BANCO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_NATUREZ")
AADD(aCampos,{"TB_NATUREZ" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_NUMERO")
AADD(aCampos,{"TB_NUMERO" ,"C",aTam[1]+2,aTam[2]})
aTam:=TamSX3("E5_NUMCHEQ")
AADD(aCampos,{"TB_NUMCHEQ" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_DOCUMEN")
AADD(aCampos,{"TB_DOCUMEN" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_RECPAG")
AADD(aCampos,{"TB_RECPAG"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_MOTBX")
AADD(aCampos,{"TB_MOTBX"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_VENCTO")
AADD(aCampos,{"TB_VENCTO"  ,"D",aTam[1],aTam[2]})
aTam:=TamSX3("E5_BENEF")
AADD(aCampos,{"TB_BENEF"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_HISTOR")
AADD(aCampos,{"TB_HISTOR"  ,"C",aTam[1],aTam[2]})
AADD(aCampos,{"TB_VALOR"   ,"N",17,2})
AADD(aCampos,{"TB_PAGO"   ,"N",17,2})
AADD(aCampos,{"TB_RECDIN"   ,"N",17,2})
AADD(aCampos,{"TB_RECCHE"   ,"N",17,2})
AADD(aCampos,{"TB_RECDEP"   ,"N",17,2})
AADD(aCampos,{"TB_PROTES"   ,"N",17,2})

cTrabalho := CriaTrab(aCampos)
Use &cTrabalho Alias Trabalho New

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Define a ordem de impress„o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn [ 8 ]
dbSelectArea ( "SE5" )
SE5 -> ( dbSetOrder ( 1 ) )
SE5 -> ( dbSeek ( xFilial("SE5") + DtoS ( dDataInicial ), .T. ) )
Do Case
	Case ( nOrdem == 1 )
		bTexto  := { || AllTrim ( Trabalho -> TB_RECIBO )  }
		cIndice := "TB_FILIAL + TB_RECIBO + DtoS ( TB_DATA )"
		cQuebra := "Trabalho -> TB_RECIBO"
	Case ( nOrdem == 2 )
		bTexto  := { || DtoC ( Trabalho -> TB_DATA ) }
		cIndice := "TB_FILIAL + DtoS ( TB_DATA )"
		cQuebra := "DtoC ( Trabalho -> TB_DATA )"
	Case ( nOrdem == 3 )
		bTexto  := { || Banco ( Trabalho->TB_BANCO ) }
		cIndice := "TB_FILIAL + TB_BANCO + DtoS ( TB_DATA )"
		cQuebra := "Trabalho ->(TB_BANCO)"
	Case ( nOrdem == 4 )
		bTexto  := { || Natureza ( TB_NATUREZ ) }
		cIndice := "TB_FILIAL + TB_NATUREZ + DtoS ( TB_DATA )"
		cQuebra := "Trabalho -> TB_NATUREZ"
End
cTitulo += " - " + aOrdem [ nOrdem ]
dbSelectArea ( "Trabalho" )
IndRegua("Trabalho",cTrabalho,cIndice,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSelectArea("SE5")

While (SE5 -> ( ! Eof () )  .and. SE5 -> E5_DATA <= dDataFinal ) .And. xFilial("SE5") == SE5->E5_FILIAL

	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
		Exit
	Endif

	IF SE5->E5_TIPODOC $ "MT/CM/DC/JR/CP/M2/C2/D2/J2/V2"  // valores agregados
		SE5->(dbSkip())
		Loop
	Endif
	
	IF SE5->E5_VALOR <= 0
		SE5->(dbSkip())
		Loop
	Endif	
	
	cRecibo := Recibo(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
//	cCheque := Cheque(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)

	If nOrdem == 1 .and. Empty(cRecibo) // por recibo, n„o considera em brancos
		SE5->(dbSkip())
		Loop
	EndIf    

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ N„o processa t¡tulos sem numer rio   ³
	// ³ ou que n„o satisfa‡am aos par„metros ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (                                            ;
			cRecibo   >= cNumInicial    .and. ;
			cRecibo   <= cNumFinal      .and. ;
			SE5 -> E5_DATA    >= dDataInicial   .and. ;
			SE5 -> E5_DATA    <= dDataFinal     .and. ;
			SE5 -> E5_BANCO   >= cBancoInicial  .and. ;
			SE5 -> E5_BANCO   <= cBancoFinal    .and. ;
			SE5 -> E5_NATUREZ >= cNatInicial    .and. ;
			SE5 -> E5_NATUREZ <= cNatFinal      .and. ;
			SE5 -> E5_SITUACA != "C" )

		if MV_PAR11 != 3
			if	cOperacao== SE5->E5_RECPAG .AND. SE5->E5_TIPODOC =="ES" 
				SE5->( dbskip() )
				loop
			Endif

			if cOperacao != SE5->E5_RECPAG .and. SE5->E5_TIPODOC != "ES"
				SE5->(dbskip())
				loop
			Endif	
		EndIf

        If nConvert = 2
           If nMoedaBco <> nMoeda   
              SE5->(dbSkip())
              Loop
           EndIf
        EndIf
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VerIfica se foi utilizada taxa contratada para moeda > 1 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If SE5->(FieldPos('E5_TXMOEDA')) > 0
			nTxMoedBc := SE5->E5_TXMOEDA	
		Else  	
			nTxMoedBc := 0
		Endif
		     
		cCheque := SE5 -> E5_NUMCHEQ
		If SE5->E5_RECPAG != "P"  
		   If SEF->(dbSeek(xFilial("SEF")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
		      cCheque := SEF->EF_NUM
		   EndIf   
		EndIf	

		RecLock ( "Trabalho", .T. )
		Trabalho -> TB_FILIAL   := SE5 -> E5_FILIAL
		Trabalho -> TB_RECIBO   := cRecibo
		Trabalho -> TB_DATA     := SE5 -> E5_DATA
		Trabalho -> TB_BANCO    := SE5 -> E5_BANCO
		Trabalho -> TB_NUMERO   := SE5 -> E5_NUMERO+IIF(!EMPTY(SE5->E5_PARCELA),"/"+SE5->E5_PARCELA,"")
//		Trabalho -> TB_NUMCHEQ  := IIF(!EMPTY(SE5 -> E5_NUMCHEQ),SE5 -> E5_NUMCHEQ,cCheque)
		Trabalho -> TB_NUMCHEQ  := cCheque
		Trabalho -> TB_NATUREZ  := SE5 -> E5_NATUREZ
		Trabalho -> TB_DOCUMEN  := SE5 -> E5_DOCUMEN
		Trabalho -> TB_RECPAG   := SE5 -> E5_RECPAG
		Trabalho -> TB_MOTBX    := SE5 -> E5_MOTBX
		Trabalho -> TB_VENCTO   := SE5 -> E5_VENCTO
		Trabalho -> TB_HISTOR   := SubStr(SE5 -> E5_HISTOR,1,20)
		Trabalho -> TB_BENEF    := SE5 -> E5_BENEF
//		Trabalho -> TB_VALOR    := xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par09,SE5->E5_DATA,nCasas+1,nTxMoedBc,If(cPaisLoc=="BRA",SE5->E5_TXMOEDA,0))
		Trabalho -> TB_VALOR    := SE5->E5_VALOR
		If Trabalho->TB_RECPAG == "P"
		   Trabalho->TB_PAGO  	:= SE5->E5_VALOR
		   Trabalho->TB_RECDIN  := 0
		   Trabalho->TB_RECCHE  := 0
		   Trabalho->TB_RECDEP  := 0
		Else         
		   If Trabalho->TB_MOTBX == "CHE" .Or. " CH" $ Trabalho->TB_NUMCHEQ
			   Trabalho->TB_PAGO  	:= 0
			   Trabalho->TB_RECDIN  := 0
			   Trabalho->TB_RECCHE  := SE5->E5_VALOR
			   Trabalho->TB_RECDEP  := 0		   
		   ElseIf Trabalho->TB_MOTBX == "DIN"
			   Trabalho->TB_PAGO  	:= 0
			   Trabalho->TB_RECDIN  := SE5->E5_VALOR
			   Trabalho->TB_RECCHE  := 0
			   Trabalho->TB_RECDEP  := 0		   
		   Else
			   Trabalho->TB_PAGO  	:= 0
			   Trabalho->TB_RECDIN  := 0
			   Trabalho->TB_RECCHE  := 0
			   Trabalho->TB_RECDEP  := SE5->E5_VALOR		   
		   EndIf
		EndIf                 
		
	EndIf

	SE5 -> ( dbSkip () )

End

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Inicializa a barra indicativa de processamento para o arquivo Trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Trabalho -> ( dbGoTop () )

SetRegua(RecCount())

While ( Trabalho -> ( ! Eof () ) )

	 IF lEnd
		  @PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
		Exit
	 End

	 IncRegua()

	 __LogPages()

	// ÚÄÄÄÄÄÄÄÄÄ¿
	// ³ Detalhe ³
	// ÀÄÄÄÄÄÄÄÄÄÙ
	If nOrdem != 1 .And. ( cAnterior != & ( cQuebra ) .And. ANALITICO )
		PulaLinha ( iIf ( lPrimeiro, 1, 2 ) )
		lPrimeiro := .F.
		@ Li, 000 PSAY AllTrim ( Eval ( bTexto ) ) + " :"
		PulaLinha ()
	EndIf
	
	nValor 		:= Trabalho -> TB_VALOR
	
	If !lImpSaldo   
		PulaLinha ()
		@ Li, 169 		PSAY nSaldoCX			   Picture "@E 999,999.99"
		@ Li, 196 		PSAY nSaldoCH			   Picture "@E 999,999.99"	
		lImpSaldo	:= .T.
	EndIf

	If ( ANALITICO )
		PulaLinha ()
		@ Li, 000 		PSAY Trabalho -> TB_DATA
		@ Li, 011	 	PSAY Trabalho -> TB_RECIBO
		@ Li, 021 		PSAY Trabalho -> TB_NATUREZ
		@ Li, 032	 	PSAY Trabalho -> TB_BANCO
		@ Li, 038		PSAY Trabalho -> TB_NUMERO
		@ Li, 047		PSAY Trabalho -> TB_NUMCHEQ
		@ Li, 064		PSAY Trabalho -> TB_DOCUMEN                  
//		@ Li, aColu[4]	PSAY Trabalho -> TB_VENCTO
		@ Li, 075		PSAY Substr ( Trabalho -> TB_BENEF, 1, 30 ) 
		@ Li, 107		PSAY Trabalho -> TB_RECPAG
		@ Li, 112		PSAY Trabalho -> TB_HISTOR		
		@ Li, 134 		PSAY Trabalho -> TB_RECDIN Picture "@E 999,999.99"				
		@ Li, 146 		PSAY Trabalho -> TB_RECDEP Picture "@E 999,999.99"						
		@ Li, 158 		PSAY Trabalho -> TB_PAGO   Picture "@E 999,999.99"
		
		nSaldoCX	:= nSaldoCX + ((Trabalho->TB_RECDIN+Trabalho->TB_RECDEP)-Trabalho->TB_PAGO)
		@ Li, 170 		PSAY nSaldoCX			   Picture "@E 999,999.99"
                                      
		@ Li, 185 		PSAY Trabalho -> TB_RECCHE Picture "@E 999,999.99"
		
		nSaldoCH	+= Trabalho->TB_RECCHE
		@ Li, 197 		PSAY nSaldoCH			   Picture "@E 999,999.99"
	EndIf


	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Atualiza os totais e vari veis de controle de quebra ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAnterior := &cQuebra.
	cTexto    := Eval ( bTexto )
	If ( Trabalho -> TB_RECPAG == "P" )
		nTotalPago += nValor
		nGeralPago += nValor
	Else            
	   If Trabalho->TB_MOTBX == "CHE" .Or. " CH" $ Trabalho->TB_NUMCHEQ
	      nTotalCHE += nValor	    
		  nGeralCHE += nValor	    	    
	   ElseIf Trabalho->TB_MOTBX == "DIN"
	      nTotalDIN += nValor
		  nGeralDIN += nValor	   
	   Else
	      nTotalDEP += nValor    
		  nGeralDEP += nValor	    	    	   
	   EndIf
	EndIf

	Trabalho -> ( dbSkip () )

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Imprime os totais ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOrdem != 1 .And. ( cAnterior != &cQuebra. )
		If ( ANALITICO )
			PulaLinha ( 2 )
			@ Li, 000 PSAY PadR ( OemToAnsi("Total - ") + cTexto, 160 )  //"Total - "
		Else
			PulaLinha ()
			@ Li, 000 PSAY PadR ( cTexto, 160 )
		End
		If ( "P" $ cOperacao )
			@ Li, 158 PSAY nTotalPago Picture "@E 999,999.99"
			nTotalPago := 0
		End
		If ( "R" $ cOperacao )
			@ Li, 134 PSAY nTotalDIN Picture "@E 999,999.99"
			@ Li, 146 PSAY nTotalDEP Picture "@E 999,999.99"
			@ Li, 185 PSAY nTotalCHE Picture "@E 999,999.99"
			nTotalDIN := 0
			nTotalCHE := 0
			nTotalDEP := 0						
		End
	End
	
End ( Trabalho -> ( ! Eof () ) )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Imprime o total geral ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Trabalho -> ( RecCount () ) > 0 )
	PulaLinha ( 2 )
	@ Li, 000 PSAY PadR ( OemToAnsi("Total geral :"), 160 )  //"Total geral :"
	If ( "P" $ cOperacao )
		@ Li, 158 PSAY nGeralPago Picture "@E 999,999.99"
	End
	If ( "R" $ cOperacao )                                                     
		@ Li, 134 PSAY nGeralDIN Picture "@E 999,999.99"
		@ Li, 146 PSAY nGeralDEP Picture "@E 999,999.99"
		@ Li, 185 PSAY nGeralCHE Picture "@E 999,999.99"
	End
//	 @li, 204 PSAY (nGeralDIN+nGeralCHE+nGeralDEP)-nGeralPago Picture "@E 999,999,999.99"
	 Roda ( 0, "", "G" )
End

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Restaura o ambiente inicial ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device to Screen
If aReturn [ 5 ] = 1
	 Set Printer to
	 dbCommitAll ()
	 OurSpool ( cRelatorio )
End
MS_FLUSH ()

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Elimina os arquivos de trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea ( "Trabalho" )
cArqOrig := "MOVDIACAI.XLS"
cArqDest := Iif(Empty(mv_par13),mv_par13,"c:\movdiacai.xls")
COPY TO &cArqOrig
//CPYS2T(cArqOrig,cArqDest,.F.)

dbCloseArea ()
fErase ( cTrabalho + GetDBExtension() )
fErase ( cTrabalho + OrdBagExt() )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Restaura as ordens dos arquivos ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE5 -> ( dbSetOrder ( 1 ) )
dbSelectArea ( "SE5" )

Return ( NIL )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ PulaLinha ( nLinhas )                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Lu¡s C. Cunha                            ³ Data ³ 13.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Incrementa  a linha atual e verifica se h  necessidade  de ³±±
±±³           ³ salto de p gina.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par„metros³ nLinhas ú N£mero de linhas a incrementar.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PulaLinha ( nLinhas )

nLinhas := iIf ( nLinhas == NIL, 1, nLinhas )

Li += nLinhas

// ÚÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Cabe‡alho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Li > 58 .or. M_Pag == 1 )
	Cabec (                    ;
			 cTitulo,            ;
			 cCabecalho,         ;
			 "",                 ;
			 cRelatorio,         ;
			 "G",                ;
			 GetMv ( "Mv_Comp" ) ;
			)
End

Return ( NIL )

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ Natureza ( cNatureza )                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Lu¡s C. Cunha                            ³ Data ³ 13.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Obt‚m a descri‡„o de uma natureza no arquivo SED.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par„metros³ cNatureza ú C¢digo da natureza.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Natureza ( cNatureza )

Local cDescricao := ""
Local cArquivo   := Alias ()
Local nOrdem     := 0

dbSelectArea ( "SED" )
nOrdem := IndexOrd( )
SED -> ( dbSetOrder ( 1 ) )
If ( SED -> ( dbSeek ( cFilial + cNatureza ) ) )
	cDescricao := SED -> ED_DESCRIC
Else
	cDescricao := OemToAnsi("NATUREZA NAO DEFINIDA ( ") + cNatureza + " )"  //"NATUREZA NAO DEFINIDA ( "
End
SED -> ( dbSetOrder ( nOrdem ) )
dbSelectArea ( cArquivo )
Return ( cDescricao )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ Recibo ( cChave )		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Lu¡s C. Cunha                            ³ Data ³ 13.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Obt‚m a descri‡„o de uma natureza no arquivo SED.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par„metros³ cChave		C¢digo do titulo  .                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Recibo ( cChave )

Local cArquivo   := Alias ()

dbSelectArea ( "SE1" )
nOrdem := IndexOrd( )
SE1 -> ( dbSetOrder ( 1 ) )
If ( SE1 -> ( dbSeek ( cChave ) ) )
	cRecibo := SE1->E1_XRECIBO
Else
	cRecibo := Space(9)
End
SE1 -> ( dbSetOrder ( nOrdem ) )
dbSelectArea ( cArquivo )
Return ( cRecibo )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ Cheque ( cChave )		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ RFINR20                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Cheque ( cChave )

Local cArquivo   := Alias ()

	dbSelectArea ( "SEF" )
	nOrdem := IndexOrd( )
	SE1 -> ( dbSetOrder ( 3 ) )
	If ( SEF -> ( dbSeek ( cChave ) ) )
		cCheque := SEF->EF_NUM
	Else
		cCheque := Space(9)
	End
	SEF -> ( dbSetOrder ( nOrdem ) )
	dbSelectArea ( cArquivo )
	
Return ( cCheque )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ SaldoIni ( cChave )		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ RFINR20                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function SaldoIni()
                        
Local aOldArea	:= GetArea()
Local nMoedaBco	:= Max(SA6->A6_MOEDA,1)
Local nSaldoIni	:= 0
       
	dbSelectArea("SE8")
	dbSetOrder(1)	//E8_FILIAL+E8_BANCO+E8_AGENCIA+E8_CONTA+DTOS(E8_DTSALAT)

	dbSelectArea("SA6")
	dbSetOrder(1)	//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
	dbSeek(xFilial("SA6")+mv_par05)

	While (A6_COD >= mv_par05 .And. A6_COD <= mv_par06) .And. !Eof()
	   cBanco	:= A6_COD
	   cAgencia := A6_AGENCIA
	   cConta   := A6_NUMCON
	   cData	:= DTOS(mv_par03)
  
	   dbSelectArea("SE8")
	   dbSeek(xFilial("SE8")+cBanco+cAgencia+cConta+cData,.T.)
	   dbSkip(-1)

	   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   // ³ Carrega os saldos iniciais de cada Banco escolhido.                    ³
	   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   
	   If E8_BANCO == cBanco .And. E8_AGENCIA == cAgencia .And. E8_CONTA == cConta .And. !Bof() .And. !Eof()
	      nSaldoIni += E8_SALATUA
	   EndIf


	   dbSelectArea("SA6")
	   dbSkip()
	EndDo
	
	RestArea(aOldArea)

Return nSaldoIni