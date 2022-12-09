#Include "rwmake.ch"
#Include "Protheus.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function EmissaoFatura()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NORDEM,TAM,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CNATUREZA,CSTRING,LCONTINUA,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,WNREL,DEMISSAO,CNUMNF,CPREFIXO")
SetPrvt("CCODCLI,CLOJA,NVALDUP,CPARCELA,DVENCTO,CTIPODOC")
SetPrvt("NDESCPONT,CCF,CPEDIDO,CPEDCLI,CTIPONF,CCODTRANS")
SetPrvt("CTRANSP,CCODVEND,CNOMEVEND,CNOMECLI,CENDCLI,CBAIRRO")
SetPrvt("CCEP,CMUNCLI,CESTCLI,CCGCCLI,CINSCCLI,CCOBCLI")
SetPrvt("CCEPCOB,CBAIRROCOB,CMUNCOB,CESTCOB,CEXTENSO,NLIN")
SetPrvt("AEXTENSO,J,I,NLININI,NOPC,CCOR")
SetPrvt("_APERGUNTAS,_NLACO,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Dupli	³ Autor ³ Luiz Carlos Vieira	³ Data ³ 30/09/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Duplicata                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Exclusivo para Clientes Microsiga                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Duplicata                         ³
//³ mv_par02             // Ate Duplicata                        ³
//³ mv_par03             // Prefixo                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem     := 0
tam        := "P"
limite     := 80
titulo     := PADC("DUPLICATA",71)
cDesc1     := PADC("Este programa ira emitir Duplicatas. ",71)
cDesc2     := ""
cDesc3     := ""
cNatureza  := ""
cString    := "SE1"
lContinua  :=  .T.
aReturn    :=  { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "DUP"
nLastKey   :=  0
cPerg      := "MTR750"
wnrel      := "DUP"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//perguntas()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,tam)

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerImp()


#IFDEF WINDOWS
	RptStatus({|| Duplicata()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	RptStatus({|| Execute(Duplicata)})
	Return()
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	Function Duplicata
Static Function Duplicata()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento da Duplicata                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE1")                // * Contas a Receber
dbSetOrder(1)
dbSeek(xFilial()+mv_par05+mv_par01,.T.)

SetRegua(Val(mv_par02) - Val(mv_par01))

While !Eof() .and. SE1->E1_FILIAL == xFilial() ;
		.and. SE1->E1_PREFIXO == mv_par05 ;
		.and. SE1->E1_NUM    <= mv_par02 ;
		.and. lContinua      == .T.
	
	#IFNDEF WINDOWS
		IF LastKey()==286
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ELSE
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tip de do titulo         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !("NF"$SE1->E1_TIPO) .And. !("DP"$SE1->E1_TIPO) .And. !("DA"$SE1->E1_TIPO)
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a Parcela                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If SE1->E1_PARCELA < mv_par03 .or. SE1->E1_PARCELA > mv_par04
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Levantamento dos Dados da Duplicata                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dEmissao   :=SE1->E1_EMISSAO         // Data de Emissao da Duplicata
	cNumNF     :=SE1->E1_NUM             // Numero da Fatura/Duplicata
	cPrefixo   :=SE1->E1_PREFIXO         // Prefixo da Duplicata
	cCodCli    :=SE1->E1_CLIENTE         // Numero do Cliente
	cLoja      :=SE1->E1_LOJA            // Loja do Cliente
	nValDup    :=SE1->E1_VALOR           // Valor Da Duplicata
	nVlrAbat   :=SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	cParcela   :=SE1->E1_PARCELA         // Numero da Parcela
	dVencto    :=SE1->E1_VENCTO          // Vencimento da Duplicata
	cTipoDoc   :=SE1->E1_TIPO            // Tipo da Duplicata
	nDescPont  :=SE1->E1_DESCFIN         // Desconto de pontualidade
 
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+cNumNF+cPrefixo,.T.)
	cCF       := " "
	cNatureza := " "
	cPEDIDO   := SD2->D2_PEDIDO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona arquivo SC6               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+cPEDIDO,.T.)
	cPEDCLI := SC6->C6_PEDCLI
	
	dbSelectArea("SD2")
	
	While xFilial("SD2")+cNumNF+cPrefixo==SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE .AND. !EOF()
		
		If !SD2->D2_CF$cCF
			cCF := cCF + IIF(EMPTY(cCF),SD2->D2_CF,"/"+SD2->D2_CF)
		Endif

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek( xFilial("SF4") + SD2->D2_TES )

		If !Alltrim(SF4->F4_TEXTO)$cNatureza
			cNatureza := cNatureza + IIF(EMPTY(cNatureza),alltrim(SF4->F4_TEXTO),"/"+alltrim(SF4->F4_TEXTO))
		Endif
		dbSelectArea("SD2")
		dbSkip()

	Enddo
	
	cTipoNF:=""

	dbSelectArea("SF2")                   // * Cabecalho da Nota Fiscal
	dbSetOrder(1)
	dbSeek(xFilial()+cNumNF+cPrefixo)

	cTipoNF:=IIF(FOUND(),SF2->F2_TIPO,"U")
	cCodTrans := SF2->F2_TRANSP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se Titulo eh anterior a dt de importacao    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If SE1->E1_EMISSAO > Ctod("12/31/99")
	   cTipoNF := "N"
	EndIf
	cTRANSP := " "
	
	If !Empty(cCodTrans)
		dbSelectArea("SA4")
		dbSetOrder(1)
		dbSeek(xFilial("SA4")+cCodTrans)
		cTRANSP := SA4->A4_VIA
	Endif
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cPEDIDO,.T.)
	cCodVend      := SC5->C5_VEND1
	
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek(xFilial()+cCodVend)
	cNomeVend := SA3->A3_NREDUZ
	
	If cTipoNF $ "NCIP"                          // Normal,Compl.Preco,Icms ou IPI
		dbSelectArea("SA1")                   // * Cadastro de Clientes
		dbSetOrder(1)
		dbSeek(xFilial()+cCodCli+cLoja)
		cNomeCli   := SA1->A1_NOME               // Nome do Cliente
		cEndCli    := SA1->A1_END                // Endereco do Cliente
        cBairro    := Subs(SA1->A1_BAIRRO,1,17)  // Bairro
		cCEP       := SA1->A1_CEP                // CEP do Cliente
		cMunCli    := SA1->A1_MUN                // Municipio do Cliente
		cEstCli    := SA1->A1_EST                // Estado do Cliente
		cCGCCli    := SA1->A1_CGC                // CGC do Cliente
		cInscCli   := SA1->A1_INSCR              // Inscricao estadual do Cliente
		cCobCli    := SA1->A1_ENDCOB             // Endereco de Cobranca do Cliente
		cCepCob    := SA1->A1_CEPC               // Cep de Cobranca
        cBairroCob := Subs(SA1->A1_BAIRROC,1,17) // Bairro de cobranca
		cMunCob    := SA1->A1_MUNC               // Municipio de cobranca
		cEstCob    := SA1->A1_ESTC               // Estado de cobranca
	
	ElseIF cTipoNF=="D"
		dbSelectArea("SA2")                   // * Cadastro de Fornecedores
		dbSetOrder(1)
		dbSeek(xFilial()+cCodCli+cLoja)
		cNomeCli:=SA2->A2_NOME               // Nome do Fornecedor
		cEndCli :=SA2->A2_END                // Endereco do Fornecedor
        cBairro :=Subs(SA2->A2_BAIRRO,1,17)  // Bairro
        cCEP    :=SA2->A2_CEP                // CEP
		cCobCli :=""                         // Endereco de Cobranca do Fornecedor
		cMunCLI :=SA2->A2_MUN                // Municipio do Fornecedor
		cEstCli :=SA2->A2_EST                // Estado do Fornecedor
		cCGCCli :=SA2->A2_CGC                // CGC do Fornecedor
		cInscCli:=SA2->A2_INSCR              // Inscricao estadual do Fornecedor
	Else                                         // Cliente Nao Localizado
		cNomeCli:="Cliente NÆo Cadastrado"
		cEndCli :=""                          // Endereco do Fornecedor
		cBairro  :=""                          // Bairro
		cCEP     :=""                          // CEP
		cCobCli :=""                         // Endereco de Cobranca do Fornecedor
		cMunCLI := ""                         // Municipio do cliente
		cEstCli :=""                          // Estado do Fornecedor
		cCGCCli :=""                          // CGC do Fornecedor
		cInscCli:=""                          // Inscricao estadual do Fornecedor
	Endif
	
	cEXTENSO:=Extenso(nVAlDup-nVlrAbat,.F.,1)
	cEXTENSO:=cEXTENSO+REPLICATE('*',IIF(Len(cEXTENSO)<180,180-Len(cEXTENSO),0))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                         IMPRESSAO                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	@ 000, 000 PSAY Chr(18)
/*/
	@ 004, 095 PSAY cCF + " - " + cNatureza 
	@ 005, 095 PSAY cTRANSP
*/
	@ 006, 065 PSAY dEmissao
	
	@ 009, 005 PSAY CHR(27)+CHR(69)+cNumNF        
	@ 009, 020 PSAY nValDup-nVlrAbat                 PICTURE "@E 999,999,999.99"
	@ 009, 038 PSAY cNumNF+IIF(cParcela<>" ",'-'+cParcela,"")
	@ 009, 055 PSAY DTOC(dVencto)+CHR(27)+CHR(70)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desconto de Pontualidade            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   
	   If !Empty( nDescPont )
	       @ 012, 020 PSAY nDescPont
	       @ 012, 033 PSAY nValDup-nVlrAbat                 PICTURE "@E 999,999,999.99" 
	       @ 012, 053 PSAY DTOC(dVencto)
	   EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Dados do Cliente      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	@ 014, 020 PSAY cNomeCli
	@ 014, 070 PSAY cCodCli
	@ 015, 020 PSAY Subs(cEndCli,1,59)
    //@ 015, 062 PSAY cBairro
	@ 016, 020 PSAY cMunCli
    @ 016, 052 PSAY cEstCli
    @ 016, 065 PSAY TRANSFORM(cCEP,"@R 99999-999")
    @ 017, 020 PSAY cMunCli
	@ 018, 020 PSAY cCGCCli  PICTURE "@R 99.999.999/9999-99"
    @ 018, 055 PSAY cInscCli // PICTURE "@R 999.999.999.999"
	@ 021, 020 PSAY Subs(cCobCli,1,59)
    //@ 021, 062 PSAY cBairroCob
	@ 022, 020 PSAY cMunCob 
    @ 022, 052 PSAY cEstCob 
	@ 022, 065 PSAY TRANSFORM(cCepCob,"@R 99999-999")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Extenso                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nLin:=22
	aExtenso:={"","",""}
	J:=1
	For I:=1 to 3
		aExtenso[I]:=SUBSTR(cEXTENSO,J,60)
		@ nLin+I, 019 PSAY aExtenso[I]
		J:=J+60
	NEXT
	@ 36, 000 PSAY ""
	SETPRC (0,0)
    nLin:=0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino da Impressao da Duplicata              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SE1")
	dbSetOrder(1)           // Reestabelece Area Principal de Pesquisa
	dbSkip()                    // e passa para a proxima Duplicata
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Avan‡o da R‚gua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncRegua()
	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa da Duplicata                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE1")
dbSetOrder(1)

Set Device To Screen

dbCommitAll()

If aReturn[5] == 1
	Set Printer TO
	ourspool(wnrel)
Endif

MS_FLUSH()

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³ Luiz Carlos Vieira    ³ Data ³ 30/09/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica posicionamento de papel na Impressora             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Lincoln                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,003 PSAY "*"
		
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 PSAY "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device To Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return()
		EndCase
	End
Endif

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Pergunta ³ Autor ³ Marcos Gomes          ³ Data ³ 01/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria grupo de Perguntas caso nao exista no SX1             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP - especifico Kenia                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Pergunta
Static Function Pergunta()
		  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Duplicata                         ³
//³ mv_par02             // Ate Duplicata                        ³
//³ mv_par03             // Da Parcela                           ³
//³ mv_par04             // Ate a Parcela                        ³
//³ mv_par05             // Prefixo                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerguntas := {}             
		  // 01     02       03                  04     05  06 7 8  9      10                               11           12        13 14        15        16 17    18     19 20     21        22 23 24 25  26 
AADD(_aPerguntas,{"MTR750","01","Da Duplicata       ?","mv_ch1","C",06,0,0,"G","                               ","mv_par01","            ","","","              ","","","       ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"MTR750","02","Ate a Duplicata    ?","mv_ch2","C",06,0,0,"G","                               ","mv_par02","            ","","","              ","","","       ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"MTR750","03","Da Parcela         ?","mv_ch3","C",02,0,0,"G","                               ","mv_par03","            ","","","              ","","","       ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"MTR750","04","Ate a Parcela      ?","mv_ch4","C",02,0,0,"G","                               ","mv_par04","            ","","","              ","","","       ","","","           ","","","","","   ",})
AADD(_aPerguntas,{"MTR750","05","Prefixo            ?","mv_ch4","C",03,0,0,"G","                               ","mv_par05","            ","","","              ","","","       ","","","           ","","","","","   ",})

If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      return
Endif

DbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
   If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
     RecLock("SX1",.T.)
     SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
     SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
     SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
     SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
     SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
     SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
     SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
     SX1->X1_Presel    := _aPerguntas[_nLaco,08]
     SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
     SX1->X1_Valid     := _aPerguntas[_nLaco,10]
     SX1->X1_Var01     := _aPerguntas[_nLaco,11]
     SX1->X1_Def01     := _aPerguntas[_nLaco,12]
     SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
     SX1->X1_Var02     := _aPerguntas[_nLaco,14]
     SX1->X1_Def02     := _aPerguntas[_nLaco,15]
     SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
     SX1->X1_Var03     := _aPerguntas[_nLaco,17]
     SX1->X1_Def03     := _aPerguntas[_nLaco,18]
     SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
     SX1->X1_Var04     := _aPerguntas[_nLaco,20]
     SX1->X1_Def04     := _aPerguntas[_nLaco,21]
     SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
     SX1->X1_Var05     := _aPerguntas[_nLaco,23]
     SX1->X1_Def05     := _aPerguntas[_nLaco,24]
     SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
     SX1->X1_F3        := _aPerguntas[_nLaco,26]
     MsUnLock()
   EndIf
NEXT


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

