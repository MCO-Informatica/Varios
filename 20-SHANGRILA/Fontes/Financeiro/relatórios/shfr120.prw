#include "rwmake.ch"
# Define ANALITICO   ( nNivel == 1 )
# Define SINTETICO   ( nNivel == 2 )
# Define PAGAMENTO   ( nOperacao == 1 .or. nOperacao == 3 )
# Define RECEBIMENTO ( nOperacao == 2 .or. nOperacao == 3 )
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun�...o    � FINR120  � Autor � Lu�s C. Cunha       � Data � 05/11/93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri�...o � Movimenta�"o di ria do caixa                             ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   � FINR120 ()                                                 ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������Ĵ��
��� Arquivos  � SA6 ( cadastro de bancos )                                 ���
���           � SE5 ( movimenta�"o banc ria )                              ���
���           � SED ( cadastro de naturezas )                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function ShFr120

// ��������������������������������������Ŀ
// � Par"metros para a fun�"o SetPrint () �
// ����������������������������������������
Private cArea      := ""
Private cDesc1     := ""
Private cDesc2     := ""
Private cDesc3     := ""
Private nTamanho   := 0

Private wnrel
Private cString:="SE5"

// �����������������������������������Ŀ
// � Par"metros para a fun�"o Cabec () �
// �������������������������������������
Private cCabecalho := ""
Private cPerg      := ""
Private cRelatorio := ""
Private cTitulo    := ""

// �����������������������������������������������������������Ŀ
// � Vari veis utilizadas para impressao do cabe�alho e rodap� �
// �������������������������������������������������������������
Private Li     := 0
Private M_Pag  := 1

// ������������������������������������������������Ŀ
// � Vari veis utilizadas pela fun�"o SetDefault () �
// ��������������������������������������������������
Private aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nLastKey := 0

// �����������������������������������������������������Ŀ
// � Vari veis p�blicas utilizadas em macro-substitui�"o �
// �������������������������������������������������������
Private cIndice := ""
Private cMoeda  := ""
Private cQuebra := ""

// �������������������������������������������Ŀ
// � Verifica os par"metros selecionados e en- �
// � via o controle para a fun�"o SetPrint ()  �
// ���������������������������������������������
Private aOrdem := {"Por Data","Por Numerario","Por Banco","Por Natureza"}

cArea      := "SE5"
cDesc1     := "Movimentacao diaria do caixa, de forma analitica ( detalhada ) ou sin-"
cDesc2     := "tetica  ( apenas os totais ). Informa os valores pagos e/ou  recebidos"
cDesc3     := "no intervalo definido."
cPerg      := PADR("FIN120",LEN(SX1->X1_GRUPO))  // Nome do grupo de perguntas
cRelatorio := "SHFR120" // Nome do relat�rio em disco
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
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun�...o    � FA120Imp � Autor � Lu�s C. Cunha       � Data � 05/11/93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri�...o � Movimenta�"o di ria do caixa                             ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   � FA120Imp(lEnd,wnRel,cString                                ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������Ĵ��
���Parametros � lEnd    - A��o do Codeblock                                ���
���           � wnRel   - T�tulo do relat�rio                              ���
���           � cString - Mensagem                                         ���
��������������������������������������������������������������������������Ĵ��
��� Arquivos  � SA6 ( cadastro de bancos )                                 ���
���           � SE5 ( movimenta�"o banc ria )                              ���
���           � SED ( cadastro de naturezas )                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function FA120Imp(lEnd,wnRel,cString)

// ��������������������������������������Ŀ
// � Par"metros para emiss"o do relat�rio �
// ����������������������������������������
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

// �����������������������Ŀ
// � Vari veis de controle �
// �������������������������
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
// �������������������������������������������������������������������������Ŀ
// � Par"metros para emiss"o do relat�rio :                                  �
// � Mv_Par01 => Numer rio inicial                                           �
// � Mv_Par02 => Numer rio final                                             �
// � Mv_Par03 => Data inicial                                                �
// � Mv_Par04 => Data final                                                  �
// � Mv_Par05 => Banco inicial                                               �
// � Mv_Par06 => Banco final                                                 �
// � Mv_Par07 => Natureza inicial                                            �
// � Mv_Par08 => Natureza final                                              �
// � Mv_Par09 => Moeda utilizada ( 1...5 )                                   �
// � Mv_Par10 => N�vel anal�tico ( 1 ) ou sint�tico ( 2 )                    �
// � Mv_Par11 => Pagamentos ( 1 ), recebimentos ( 2 ) ou ambos ( 3 )         � 
// � Mv_Par12 => Outras moedas(Converter/Nao imprimir)                       �
// ���������������������������������������������������������������������������
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

// ���������������������������������Ŀ
// � Ajusta as vari veis de controle �
// �����������������������������������
cOperacao += iIf ( PAGAMENTO, "P", "" )
cOperacao += iIf ( RECEBIMENTO, "R", "" )

// �����������������������������������Ŀ
// � Par"metros para a fun�"o Cabec () �
// �������������������������������������
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

// ������������������������������Ŀ
// � Obt�m a tabela de numer rios �
// ��������������������������������
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

// ����������������������������Ŀ
// � Cria o arquivo de trabalho �
// ������������������������������
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

// �����������������������������Ŀ
// � Define a ordem de impress"o �
// �������������������������������
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

	// ��������������������������������������Ŀ
	// � N"o processa t�tulos sem numer rio   �
	// � ou que n"o satisfa�am aos par"metros �
	// ����������������������������������������
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

	// ������������������������������������������������������������������������Ŀ
	// � Carrega os saldos iniciais de cada Banco escolhido.                    �
	// ��������������������������������������������������������������������������
	For nD:=	1	To	Len(aBancos)
		SE8->(DbSeek(xFilial()+aBancos[nD][1]+aBancos[nD][2]+aBancos[nD][3]+DTOS(dDataInicial),.T.))
		DbSkip(-1)
		If SE8->(E8_FILIAL+E8_BANCO+E8_AGENCIA+E8_CONTA) == xFilial("SE8")+aBancos[nD][1]+aBancos[nD][2]+aBancos[nD][3]
			aBancos[nD][4]	:=	xMoeda(SE8->E8_SALATUA,aBancos[nD][5],mv_par09,SE8->E8_DTSALAT,nCasas+1)
		Endif
	Next				
Endif		
// ������������������������������������������������������������������������Ŀ
// � Inicializa a barra indicativa de processamento para o arquivo Trabalho �
// ��������������������������������������������������������������������������
Trabalho -> ( dbGoTop () )

SetRegua(RecCount())

While ( Trabalho -> ( ! Eof () ) )

	 IF lEnd
		  @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	 End

	 IncRegua()

	 __LogPages()

	// ���������Ŀ
	// � Detalhe �
	// �����������
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

	// ������������������������������������������������������Ŀ
	// � Atualiza os totais e vari veis de controle de quebra �
	// ��������������������������������������������������������
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

	// �������������������Ŀ
	// � Imprime os totais �
	// ���������������������
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

// �����������������������Ŀ
// � Imprime o total geral �
// �������������������������
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

// �����������������������������Ŀ
// � Restaura o ambiente inicial �
// �������������������������������
Set Device to Screen
If aReturn [ 5 ] = 1
	 Set Printer to
	 dbCommitAll ()
	 OurSpool ( cRelatorio )
End
MS_FLUSH ()

// ���������������������������������Ŀ
// � Elimina os arquivos de trabalho �
// �����������������������������������
dbSelectArea ( "Trabalho" )
dbCloseArea ()
fErase ( cTrabalho + GetDBExtension() )
fErase ( cTrabalho + OrdBagExt() )

// ���������������������������������Ŀ
// � Restaura as ordens dos arquivos �
// �����������������������������������
SE5 -> ( dbSetOrder ( 1 ) )
dbSelectArea ( "SE5" )

Return ( NIL )

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun�"o    � PulaLinha ( nLinhas )                                      ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Lu�s C. Cunha                            � Data � 13.10.93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri�"o � Incrementa  a linha atual e verifica se h  necessidade  de ���
���           � salto de p gina.                                           ���
��������������������������������������������������������������������������Ĵ��
��� Par"metros� nLinhas � N�mero de linhas a incrementar.                  ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � FinR120                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function PulaLinha ( nLinhas )

nLinhas := iIf ( nLinhas == NIL, 1, nLinhas )

Li += nLinhas

// �����������Ŀ
// � Cabe�alho �
// �������������
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
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun�"o    � Banco ( cBanco )                                           ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Lu�s C. Cunha                            � Data � 13.10.93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri�"o � Obt�m a descri�"o de um agente de cobran�a ( banco ) no ar-���
���           � quivo SA6.                                                 ���
��������������������������������������������������������������������������Ĵ��
��� Par"metros� cBcoAgen � C�digo do banco+agencia                         ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � FinR120                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
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
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun�"o    � Natureza ( cNatureza )                                     ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Lu�s C. Cunha                            � Data � 13.10.93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri�"o � Obt�m a descri�"o de uma natureza no arquivo SED.          ���
��������������������������������������������������������������������������Ĵ��
��� Par"metros� cNatureza � C�digo da natureza.                            ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � FinR120                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
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