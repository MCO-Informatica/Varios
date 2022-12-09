#include "rwmake.ch"
# Define ANALITICO   ( nNivel == 1 )
# Define SINTETICO   ( nNivel == 2 )
# Define PAGAMENTO   ( nOperacao == 1 .or. nOperacao == 3 )
# Define RECEBIMENTO ( nOperacao == 2 .or. nOperacao == 3 )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡...o    ³ FINR120  ³ Autor ³ Lu¡s C. Cunha       ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡...o ³ Movimenta‡"o di ria do caixa                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ FINR120 ()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGAFIN                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos  ³ SA6 ( cadastro de bancos )                                 ³±±
±±³           ³ SE5 ( movimenta‡"o banc ria )                              ³±±
±±³           ³ SED ( cadastro de naturezas )                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ShFr120

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par"metros para a fun‡"o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cArea      := ""
Private cDesc1     := ""
Private cDesc2     := ""
Private cDesc3     := ""
Private nTamanho   := 0

Private wnrel
Private cString:="SE5"

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par"metros para a fun‡"o Cabec () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCabecalho := ""
Private cPerg      := ""
Private cRelatorio := ""
Private cTitulo    := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis utilizadas para impressao do cabe‡alho e rodap‚ ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Li     := 0
Private M_Pag  := 1

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis utilizadas pela fun‡"o SetDefault () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nLastKey := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis p£blicas utilizadas em macro-substitui‡"o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cIndice := ""
Private cMoeda  := ""
Private cQuebra := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Verifica os par"metros selecionados e en- ³
// ³ via o controle para a fun‡"o SetPrint ()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aOrdem := {"Por Data","Por Numerario","Por Banco","Por Natureza"}

cArea      := "SE5"
cDesc1     := "Movimentacao diaria do caixa, de forma analitica ( detalhada ) ou sin-"
cDesc2     := "tetica  ( apenas os totais ). Informa os valores pagos e/ou  recebidos"
cDesc3     := "no intervalo definido."
cPerg      := PADR("FIN120",LEN(SX1->X1_GRUPO))  // Nome do grupo de perguntas
cRelatorio := "SHFR120" // Nome do relat¢rio em disco
cTitulo    := "Movimento diario do caixa"
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
±±³ Fun‡...o    ³ FA120Imp ³ Autor ³ Lu¡s C. Cunha       ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡...o ³ Movimenta‡"o di ria do caixa                             ³±±
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
±±³           ³ SE5 ( movimenta‡"o banc ria )                              ³±±
±±³           ³ SED ( cadastro de naturezas )                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA120Imp(lEnd,wnRel,cString)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par"metros para emiss"o do relat¢rio ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cBancoFinal    := ""
Private cBancoInicial  := ""
Private cNatFinal      := ""
Private cNatInicial    := ""
Private cNumFinal      := ""
Private cNumInicial    := ""
Private dDataFinal     := CtoD ( Space ( 08 ) )
Private dDataInicial   := CtoD ( Space ( 08 ) )
Private nMoeda         := 0
Private nNivel         := 0
Private nOperacao      := 0 
Private nConvert       := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis de controle ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aChave         := {}
Private aCampos        := {}
Private aTam           := {}
Private aNumerario     := {}
Private bTexto         := { || NIL }
Private cAnterior      := ""
Private cLinha         := ""

Private cOperacao      := ""
Private cTrabalho      := ""
Private lPrimeiro      := .T.
Private nGeralPago     := 0
Private nGeralRecebido := 0
Private nLocaliza      := 0
Private nOrdem         := 0
Private nTotalPago     := 0
Private nTotalRecebido := 0
Private nValor         := 0
Private nMoedaBco	     :=	1                                   
Private nCasas		 := GetMv("MV_CENT"+(IIF(mv_par09 > 1 , STR(mv_par09,1),""))) 
Private aBancos	     :=	{}
Private nD,lPrim	     :=	.T.
Private aColu	:= {}
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par"metros para emiss"o do relat¢rio :                                  ³
// ³ Mv_Par01 => Numer rio inicial                                           ³
// ³ Mv_Par02 => Numer rio final                                             ³
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
// ³ Ajusta as vari veis de controle ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOperacao += iIf ( PAGAMENTO, "P", "" )
cOperacao += iIf ( RECEBIMENTO, "R", "" )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par"metros para a fun‡"o Cabec () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "BRA"
	aColu := {046,057,073,093,105,133,27,35}
	cCabecalho := "Data       Numerario Natureza   Banco Agencia Conta      Cheque          Documento           Vencimento  Beneficiario                Historico                                 Pagamentos      Recebimentos"
Else
	aColu := {048,069,085,105,117,140,22,29}
	cCabecalho := "Data       Numerario Natureza   Banco Agencia   Conta                Cheque          Documento           Vencimento  Beneficiario           Historico                          Pagamentos       Recebimentos"
Endif
cMoeda  := LTrim(Str(nMoeda))
cTitulo += " ( " + iIf ( ANALITICO, "Analitico", "Sintetico" )  + " ) em " + ;
			  GetMv("MV_MOEDA"+cMoeda)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m a tabela de numer rios ³
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
aTam:=TamSX3("E5_MOEDA")
AADD(aCampos,{"TB_MOEDA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_DATA")
AADD(aCampos,{"TB_DATA"    ,"D",aTam[1],aTam[2]})
aTam:=TamSX3("E5_BANCO")
AADD(aCampos,{"TB_BANCO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_AGENCIA")
AADD(aCampos,{"TB_AGENCIA" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_CONTA")
AADD(aCampos,{"TB_CONTA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_NUMCHEQ")
AADD(aCampos,{"TB_NUMCHEQ" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_NATUREZ")
AADD(aCampos,{"TB_NATUREZ" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_DOCUMEN")
AADD(aCampos,{"TB_DOCUMEN" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_RECPAG")
AADD(aCampos,{"TB_RECPAG"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_VENCTO")
AADD(aCampos,{"TB_VENCTO"  ,"D",aTam[1],aTam[2]})
aTam:=TamSX3("E5_BENEF")
AADD(aCampos,{"TB_BENEF"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E5_HISTOR")
AADD(aCampos,{"TB_HISTOR"  ,"C",aTam[1],aTam[2]})
AADD(aCampos,{"TB_VALOR"   ,"N",17,2})

cTrabalho := CriaTrab(aCampos)
Use &cTrabalho Alias Trabalho New

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Define a ordem de impress"o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn [ 8 ]
dbSelectArea ( "SE5" )
SE5 -> ( dbSetOrder ( 1 ) )
SE5 -> ( dbSeek ( cFilial + DtoS ( dDataInicial ), .T. ) )
Do Case
	Case ( nOrdem == 1 )
		bTexto  := { || DtoC ( Trabalho -> TB_DATA ) }
		cIndice := "TB_FILIAL + DtoS ( TB_DATA )"
		cQuebra := "DtoC ( Trabalho -> TB_DATA )"
	Case ( nOrdem == 2 )
		bTexto  := { || AllTrim ( aNumerario [ aScan ( aChave, Trabalho -> TB_MOEDA ) ] ) }
		cIndice := "TB_FILIAL + TB_MOEDA + DtoS ( TB_DATA )"
		cQuebra := "Trabalho -> TB_MOEDA"
	Case ( nOrdem == 3 )
		bTexto  := { || Banco ( Trabalho->TB_BANCO+Trabalho->TB_AGENCIA ) }
		cIndice := "TB_FILIAL + TB_BANCO+TB_AGENCIA+TB_CONTA + DtoS ( TB_DATA )"
		cQuebra := "Trabalho ->(TB_BANCO+TB_AGENCIA+TB_CONTA)"
	Case ( nOrdem == 4 )
		bTexto  := { || Natureza ( Trabalho->TB_NATUREZ ) }
		cIndice := "TB_FILIAL + TB_NATUREZ + DtoS ( TB_DATA )"
		cQuebra := "Trabalho -> TB_NATUREZ"
End
cTitulo += " - " + aOrdem [ nOrdem ]
dbSelectArea ( "Trabalho" )
IndRegua("Trabalho",cTrabalho,cIndice,,,"Selecionando Registros...")
dbSelectArea("SE5")

While (SE5 -> ( ! Eof () )  .and. SE5 -> E5_DATA <= dDataFinal )

	IF lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif

	IF SE5->E5_TIPODOC $ "BA/MT/CM/DC/JR/CP/M2/C2/D2/J2/V2"  // valores agregados
		SE5->(dbSkip())
		Loop
	Endif

	If nOrdem == 2 .and. Empty(SE5->E5_MOEDA) // por numer rio, n"o considera em brancos
		SE5->(dbSkip())
		Loop
	Endif    

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ N"o processa t¡tulos sem numer rio   ³
	// ³ ou que n"o satisfa‡am aos par"metros ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (                                            ;
			SE5 -> E5_MOEDA   >= cNumInicial    .and. ;
			SE5 -> E5_MOEDA   <= cNumFinal      .and. ;
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

		If cPaisLoc	# "BRA"
			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
			nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
		Endif

		If nConvert = 2
			If nMoedaBco <> nMoeda   
				SE5->(dbSkip())
				Loop
			EndIf
		EndIf
		
		If SE5->E5_TIPODOC == "CH" .And. !Empty(SE5->E5_NUMCHEQ) .And. Empty(SE5->E5_NATUREZ)
			ShNaturez()
			dbSelectArea("SE5")
			DbSkip()
			Loop
		EndIf

		RecLock ( "Trabalho", .T. )
		Trabalho -> TB_FILIAL   := SE5 -> E5_FILIAL
		Trabalho -> TB_MOEDA    := SE5 -> E5_MOEDA
		Trabalho -> TB_DATA     := SE5 -> E5_DATA
		Trabalho -> TB_BANCO    := SE5 -> E5_BANCO
		Trabalho -> TB_AGENCIA  := SE5 -> E5_AGENCIA
		Trabalho -> TB_CONTA    := SE5 -> E5_CONTA
		Trabalho -> TB_NUMCHEQ  := SE5 -> E5_NUMCHEQ
		Trabalho -> TB_NATUREZ  := SE5 -> E5_NATUREZ
		Trabalho -> TB_DOCUMEN  := SE5 -> E5_DOCUMEN
		Trabalho -> TB_RECPAG   := SE5 -> E5_RECPAG
		Trabalho -> TB_VENCTO   := SE5 -> E5_VENCTO
		Trabalho -> TB_HISTOR   := SE5 -> E5_HISTOR
		Trabalho -> TB_BENEF    := SE5 -> E5_BENEF
		Trabalho -> TB_VALOR    := xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par09,SE5->E5_DATA,nCasas+1)
		If cPaisLoc	#	"BRA"
			//Guardo os bancos num array para Imprimir os saldos Iniciais
			//dos bancos processados. Bruno
			If Ascan(aBancos,{|X| X[1]+X[2]+X[3] == SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA }) == 0
				Aadd(aBancos,{SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,0,nMoedaBco})
			Endif
		Endif
	End

	SE5 -> ( dbSkip () )

End ( SE5 -> ( ! Eof () )  .and. SE5 -> E5_DATA <= dDataFinal .and. )


If cPaisLoc	#	"BRA"

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Carrega os saldos iniciais de cada Banco escolhido.                    ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nD:=	1	To	Len(aBancos)
		SE8->(DbSeek(xFilial()+aBancos[nD][1]+aBancos[nD][2]+aBancos[nD][3]+DTOS(dDataInicial),.T.))
		DbSkip(-1)
		If SE8->(E8_FILIAL+E8_BANCO+E8_AGENCIA+E8_CONTA) == xFilial("SE8")+aBancos[nD][1]+aBancos[nD][2]+aBancos[nD][3]
			aBancos[nD][4]	:=	xMoeda(SE8->E8_SALATUA,aBancos[nD][5],mv_par09,SE8->E8_DTSALAT,nCasas+1)
		Endif
	Next				
Endif		
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Inicializa a barra indicativa de processamento para o arquivo Trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Trabalho -> ( dbGoTop () )

SetRegua(RecCount())

While ( Trabalho -> ( ! Eof () ) )

	 IF lEnd
		  @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	 End

	 IncRegua()

	 __LogPages()

	// ÚÄÄÄÄÄÄÄÄÄ¿
	// ³ Detalhe ³
	// ÀÄÄÄÄÄÄÄÄÄÙ
	If ( cAnterior != & ( cQuebra ) .And. ANALITICO )
		PulaLinha ( iIf ( lPrimeiro, 1, 2 ) )
		lPrimeiro := .F.
		@ Li, 000 PSAY AllTrim ( Eval ( bTexto ) ) + " :"
		PulaLinha ()
	End
	nValor :=  Trabalho -> TB_VALOR

	If cPaisLoc	#	"BRA"
		If lPrim	
			PulaLinha(0)
			@ Li, 000 PSAY "Saldos iniciales :"
			PulaLinha()
			For nD	:=	1	To Len(aBancos)
				@ Li, 032 PSAY aBancos[nD][1]
				@ Li, 038 PSAY aBancos[nD][2]
				@ Li, 046 PSAY aBancos[nD][3]
				@ Li, 187 PSAY aBancos[nD][4] Picture Tm ( nValor, 16 ,nCasas)
				PulaLinha()			
			Next
			lPrim	:=	.F.
		Endif		
	Endif
	If ( ANALITICO )
		PulaLinha ()
		@ Li, 000 	PSAY Trabalho -> TB_DATA
		@ Li, 011	 	PSAY Trabalho -> TB_MOEDA
		@ Li, 021 		PSAY Trabalho -> TB_NATUREZ
		@ Li, 032	 	PSAY Trabalho -> TB_BANCO
		@ Li, 038		PSAY Trabalho -> TB_AGENCIA
		@ Li, aColu[1]	PSAY Trabalho -> TB_CONTA
		@ Li, aColu[2]	PSAY Trabalho -> TB_NUMCHEQ
		@ Li, aColu[3]	PSAY Trabalho -> TB_DOCUMEN
		@ Li, aColu[4]	PSAY Trabalho -> TB_VENCTO
		@ Li, aColu[5]	PSAY Substr ( Trabalho -> TB_BENEF, 1, aColu[7] )
		@ Li, aColu[6]	PSAY Substr ( Trabalho -> TB_HISTOR, 1,aColu[8] )
		If ( Trabalho -> TB_RECPAG == "P" )
			@ Li, 169 PSAY nValor Picture Tm ( nValor, 16 ,nCasas)
		Else
			@ Li, 187 PSAY nValor Picture Tm ( nValor, 16 ,nCasas)
		End
	End

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Atualiza os totais e vari veis de controle de quebra ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAnterior := &cQuebra.
	cTexto    := Eval ( bTexto )
	If ( Trabalho -> TB_RECPAG == "P" )
		nTotalPago += nValor
		nGeralPago += nValor
	Else
		nTotalRecebido += nValor
		nGeralRecebido += nValor
	End

	Trabalho -> ( dbSkip () )

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Imprime os totais ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( cAnterior != &cQuebra. )
		If ( ANALITICO )
			PulaLinha ( 2 )
			@ Li, 000 PSAY PadR ( "Total - " + cTexto, 160 )
		Else
			PulaLinha ()
			@ Li, 000 PSAY PadR ( cTexto, 160 )
		End
		If ( "P" $ cOperacao )
			@ Li, 169 PSAY nTotalPago Picture Tm ( nTotalPago, 16, nCasas)
			nTotalPago := 0
		End
		If ( "R" $ cOperacao )
			@ Li, 187 PSAY nTotalRecebido Picture Tm ( nTotalRecebido, 16, nCasas)
			nTotalRecebido := 0
		End
	End
	
End ( Trabalho -> ( ! Eof () ) )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Imprime o total geral ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Trabalho -> ( RecCount () ) > 0 )
	PulaLinha ( 2 )
	@ Li, 000 PSAY PadR ( "Total geral :", 160 )
	If ( "P" $ cOperacao )
		@ Li, 169 PSAY nGeralPago Picture Tm ( nGeralPago, 16, nCasas )
	End
	If ( "R" $ cOperacao )
		@ Li, 187 PSAY nGeralRecebido Picture Tm ( nGeralRecebido, 16, nCasas )
	End
	 @li, 204 PSAY nGeralRecebido-nGeralPago Picture Tm(nGeralRecebido-nGeralPago,16, nCasas)
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
±±³ Fun‡"o    ³ PulaLinha ( nLinhas )                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Lu¡s C. Cunha                            ³ Data ³ 13.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡"o ³ Incrementa  a linha atual e verifica se h  necessidade  de ³±±
±±³           ³ salto de p gina.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par"metros³ nLinhas ú N£mero de linhas a incrementar.                  ³±±
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
±±³ Fun‡"o    ³ Banco ( cBanco )                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Lu¡s C. Cunha                            ³ Data ³ 13.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡"o ³ Obt‚m a descri‡"o de um agente de cobran‡a ( banco ) no ar-³±±
±±³           ³ quivo SA6.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par"metros³ cBcoAgen ú C¢digo do banco+agencia                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Banco ( cBcoAgen )

Private cDescricao := ""
Private cArquivo   := Alias ()
Private nOrdem     := 0

dbSelectArea ( "SA6" )
nOrdem := IndexOrd ()
SA6 -> ( dbSetOrder ( 1 ) )
If ( SA6 -> ( dbSeek ( cFilial + cBcoAgen ) ) )
	cDescricao := SA6 -> A6_NOME
Else
	cDescricao := "BANCO NAO DEFINIDO ( " + cBcoAgen + " )"
End
SA6 -> ( dbSetOrder ( nOrdem ) )
dbSelectArea ( cArquivo )

Return ( cDescricao )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡"o    ³ Natureza ( cNatureza )                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Lu¡s C. Cunha                            ³ Data ³ 13.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡"o ³ Obt‚m a descri‡"o de uma natureza no arquivo SED.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par"metros³ cNatureza ú C¢digo da natureza.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Natureza ( cNatureza )

Private cDescricao := ""
Private cArquivo   := Alias ()
Private nOrdem     := 0

dbSelectArea ( "SED" )
nOrdem := IndexOrd( )
SED -> ( dbSetOrder ( 1 ) )
If ( SED -> ( dbSeek ( cFilial + cNatureza ) ) )
	cDescricao := SED -> ED_DESCRIC
Else
	cDescricao := "NATUREZA NAO DEFINIDA ( " + cNatureza + " )"
End
SED -> ( dbSetOrder ( nOrdem ) )
dbSelectArea ( cArquivo )
Return ( cDescricao )

/////////////////////////
Static Function ShNaturez
/////////////////////////

Private _aArea    := {Alias(),IndexOrd(),RecNo()}
Private _nValCheq := SE5->E5_VALOR

DbSelectArea("SEF")
DbSetOrder(4)
DbSeek(xFilial("SEF")+SE5->E5_NUMCHEQ,.F.)
If Found()

	Do While SEF->EF_FILIAL+SEF->EF_NUM == xFilial("SEF")+SE5->E5_NUMCHEQ .And.;
			 !Empty(SEF->EF_TITULO) .And. SEF->(!Eof())
	
		RecLock ( "Trabalho", .T. )
		Trabalho -> TB_FILIAL   := SE5 -> E5_FILIAL
		Trabalho -> TB_MOEDA    := SE5 -> E5_MOEDA
		Trabalho -> TB_DATA     := SE5 -> E5_DATA
		Trabalho -> TB_BANCO    := SE5 -> E5_BANCO
		Trabalho -> TB_AGENCIA  := SE5 -> E5_AGENCIA
		Trabalho -> TB_CONTA    := SE5 -> E5_CONTA
		Trabalho -> TB_NUMCHEQ  := SE5 -> E5_NUMCHEQ
		Trabalho -> TB_NATUREZ  := Posicione("SE2",1,xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+;
										     SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA,"E2_NATUREZ")
		Trabalho -> TB_DOCUMEN  := SE5 -> E5_DOCUMEN
		Trabalho -> TB_RECPAG   := SE5 -> E5_RECPAG
		Trabalho -> TB_VENCTO   := SE5 -> E5_VENCTO
		Trabalho -> TB_HISTOR   := SE5 -> E5_HISTOR
		Trabalho -> TB_BENEF    := SE5 -> E5_BENEF
		Trabalho -> TB_VALOR    := xMoeda(SEF->EF_VALOR,nMoedaBco,mv_par09,SE5->E5_DATA,nCasas+1)
		MsUnLock()
		
		_nValCheq -= SEF->EF_VALOR
		
		DbSelectArea("SEF")
		DbSkip()
	
	EndDo
	
	If _nValCheq > 0
		RecLock ( "Trabalho", .T. )
		Trabalho -> TB_FILIAL   := SE5 -> E5_FILIAL
		Trabalho -> TB_MOEDA    := SE5 -> E5_MOEDA
		Trabalho -> TB_DATA     := SE5 -> E5_DATA
		Trabalho -> TB_BANCO    := SE5 -> E5_BANCO
		Trabalho -> TB_AGENCIA  := SE5 -> E5_AGENCIA
		Trabalho -> TB_CONTA    := SE5 -> E5_CONTA
		Trabalho -> TB_NUMCHEQ  := SE5 -> E5_NUMCHEQ
		Trabalho -> TB_NATUREZ  := SE5 -> E5_NATUREZ
		Trabalho -> TB_DOCUMEN  := SE5 -> E5_DOCUMEN
		Trabalho -> TB_RECPAG   := SE5 -> E5_RECPAG
		Trabalho -> TB_VENCTO   := SE5 -> E5_VENCTO
		Trabalho -> TB_HISTOR   := SE5 -> E5_HISTOR
		Trabalho -> TB_BENEF    := SE5 -> E5_BENEF
		Trabalho -> TB_VALOR    := xMoeda(_nValCheq,nMoedaBco,mv_par09,SE5->E5_DATA,nCasas+1)
		MsUnLock()
	EndIf
		
Else

	RecLock ( "Trabalho", .T. )
	Trabalho -> TB_FILIAL   := SE5 -> E5_FILIAL
	Trabalho -> TB_MOEDA    := SE5 -> E5_MOEDA
	Trabalho -> TB_DATA     := SE5 -> E5_DATA
	Trabalho -> TB_BANCO    := SE5 -> E5_BANCO
	Trabalho -> TB_AGENCIA  := SE5 -> E5_AGENCIA
	Trabalho -> TB_CONTA    := SE5 -> E5_CONTA
	Trabalho -> TB_NUMCHEQ  := SE5 -> E5_NUMCHEQ
	Trabalho -> TB_NATUREZ  := SE5 -> E5_NATUREZ
	Trabalho -> TB_DOCUMEN  := SE5 -> E5_DOCUMEN
	Trabalho -> TB_RECPAG   := SE5 -> E5_RECPAG
	Trabalho -> TB_VENCTO   := SE5 -> E5_VENCTO
	Trabalho -> TB_HISTOR   := SE5 -> E5_HISTOR
	Trabalho -> TB_BENEF    := SE5 -> E5_BENEF
	Trabalho -> TB_VALOR    := xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par09,SE5->E5_DATA,nCasas+1)
	MsUnLock()

EndIf

DbSelectArea(_aArea[1])
DbSetOrder(_aArea[2])
DbGoTo(_aArea[3])

Return