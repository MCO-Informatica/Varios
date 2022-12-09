#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function SPPDUP()        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

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
SetPrvt("CCF,CPEDIDO,CPEDCLI,CTIPONF,CCODTRANS,CTRANSP")
SetPrvt("CNUMDOC,CSERIE,DEMISNF,NVALBRUT,CCODVEND,CNOMEVEND")
SetPrvt("CCOD_CLI,CNOMECLI,CENDCLI,CCOMPL,CBAIRRO,CCEP")
SetPrvt("CMUNCLI,CESTCLI,CCGCCLI,CINSCCLI,CTEL,CCOBCLI")
SetPrvt("CCOMPLCOB,CBAIRCOB,CMUNCOB,CCEPCOB,CESTCOB,CTELCOB")
SetPrvt("CEXTENSO,NLIN,AEXTENSO,J,I,NLININI")
SetPrvt("NOPC,CCOR,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/04/03 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funcao    ³ DupPiter ³ Autor ³                       ³ Data ³ 19/02/99 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³ Duplicata                                                  ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³ uso Exclusivo da Piterpan                                  ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
cDesc1     := PADC("Este programa ira emitir Duplicatas da",71)
cDesc2     := PADC("Piter Pan.",71)
cDesc3     := ""
cNatureza  := ""
cString    := "SE1"
lContinua  :=  .T.
aReturn    :=  { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "DUPPITER"
nLastKey   :=  0
cPerg      := "MTR750"
wnrel      := "DUPPITER"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,tam)
#IFNDEF WINDOWS
	If LastKey() == 27 .or. nLastKey == 27
           Return
	Endif
#ENDIF
If nLastKey == 27
   Return
Endif
SetDefault(aReturn,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VerImp()
#IFNDEF WINDOWS
	If LastKey() == 27 .OR. nLastKey == 27
           Return
	Endif
#ENDIF
#IFDEF WINDOWS
	RptStatus({|| Duplicata()})// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> 	RptStatus({|| Execute(Duplicata)})
	Return
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> 	Function Duplicata
Static Function Duplicata()
#ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento da Duplicata                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")                // * Contas a Receber
dbSetOrder(1)
dbSeek(xFilial()+mv_par03+mv_par01,.T.)
SetRegua(Val(mv_par02) - Val(mv_par01))
While !eof() .and. SE1->E1_FILIAL == xFilial() ;
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
	
	If SE1->E1_PREFIXO != mv_par03
       dbSkip()
       Loop
	Endif
    If !("NF"$SE1->E1_TIPO) .AND. !("DP"$SE1->E1_TIPO)
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
	cParcela   :=SE1->E1_PARCELA         // Numero da Parcela
    dVencto    :=SE1->E1_VENCREA         // Vencimento da Duplicata
	cTipoDoc   :=SE1->E1_TIPO            // Tipo da Duplicata
    dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+cNumNF+cPrefixo,.T.)
	cCF       := " "
	cNatureza := " "
	cPEDIDO   := SD2->D2_PEDIDO
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
          dbSeek(xFilial("SF4")+SD2->D2_TES)
          If !Alltrim(SF4->F4_TEXTO)$cNatureza
             cNatureza := cNatureza + IIF(EMPTY(cNatureza),alltrim(SF4->F4_TEXTO),"/"+alltrim(SF4->F4_TEXTO))
          Endif
          dbSelectArea("SD2")
          dbSkip()
    EndDo
	cTipoNF:=""

    dbSelectArea("SF2")       // * Cabecalho da Nota Fiscal
	dbSetOrder(1)
	dbSeek(xFilial()+cNumNF+cPrefixo)

    cTipoNf:=IIF(FOUND(),SF2->F2_TIPO,"U")
    cCodTrans:=SF2->F2_TRANSP
    cTransp := " "
    cNumDoc := SF2->F2_DOC
    cSerie  := SF2->F2_SERIE
    dEmisNf := SF2->F2_EMISSAO
    nValBrut:= SF2->F2_VALBRUT

    If !Empty(cCodTrans)

       dbSelectArea("SA4")
       dbSetOrder(1)
       dbSeek(xFilial("SA4")+cCodTrans)
       cTRANSP := SA4->A4_VIA

    Endif
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cPEDIDO,.T.)

    cCodVend := SC5->C5_VEND1

	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek(xFilial()+cCodVend)

    cNomeVend := SA3->A3_NREDUZ

    If cTipoNF $ "NCIPUE"          // Normal,Compl.Preco,Icms ou IPI ou U
       dbSelectArea("SA1")              // * Cadastro de Clientes
       dbSetOrder(1)
       dbSeek(xFilial()+cCodCli+cLoja)
       cCOD_CLI :=SA1->A1_COD			 // Codigo do Cliente
       cLojaCli	:=SA1->A1_LOJA			 // Loja do Cliente 
       cNomeCli :=SA1->A1_NOME           // Nome do Cliente
       cEndCli  :=SA1->A1_END            // Endereco do Cliente
       cCompl   :=SA1->A1_COMPL          // Complemento do Endereco
       cBairro  :=SA1->A1_BAIRRO         // Bairro
       cCEP     :=SA1->A1_CEP            // CEP do Cliente
       cMunCli  :=SA1->A1_MUN            // Municipio do Cliente
       cEstCli  :=SA1->A1_EST            // Estado do Cliente
       cCGCCli  :=SA1->A1_CGC            // CGC do Cliente
       cInscCli :=SA1->A1_INSCR          // Inscricao estadual do Cliente
       cTel     :=SA1->A1_TEL            // Telefone do Cliente
       cCobCli  :=SA1->A1_ENDCOB         // Endereco de Cobranca do Cliente
       cComplCob:=SA1->A1_COMPCOB        // Complemento de Cobranca
       cBairCob :=SA1->A1_BAIRCOB        // Bairro de Cobranca
       cMunCob  :=SA1->A1_MUNCOB         // Municipio de Cobranca
       cCepCob  :=SA1->A1_CEPCOB         // CEP do Endereco de Cobranca
       cEstCob  :=SA1->A1_ESTCOB         // UF de Cobranca
       cTelCob  :=SA1->A1_TELCOB         // Telefone de Cobranca
       cMailCob	:=SA1->A1_MAILCOB		 // E_mail do Depto de Cobranca
       
    ElseIF cTipoNF=="D"
       dbSelectArea("SA2")              // * Cadastro de Fornecedores
       dbSetOrder(1)
       dbSeek(xFilial()+cCodCli+cLoja)
       cNomeCli:=SA2->A2_NOME           // Nome do Fornecedor
       cEndCli :=SA2->A2_END            // Endereco do Fornecedor
       cBairro  :=SA2->A2_BAIRRO        // Bairro
       cCEP     :=SA2->A2_CEP           // CEP
       cCobCli :=""                     // Endereco de Cobranca do Fornecedor
       cMunCLI :=SA2->A2_MUN            // Municipio do Fornecedor
       cEstCli :=SA2->A2_EST            // Estado do Fornecedor
       cCGCCli :=SA2->A2_CGC            // CGC do Fornecedor
       cInscCli:=SA2->A2_INSCR          // Inscricao estadual do Fornecedor
    Else                                // Cliente Nao Localizado
       cNomeCli:="Cliente//ou//Fornecedor NaO CaDaStRaDo"
       cEndCli :=""                     // Endereco do Fornecedor
       cBairro :=""                     // Bairro
       cCEP    :=""                     // CEP
       cCobCli :=""                     // Endereco de Cobranca do Fornecedor
       cEstCli :=""                     // Estado do Fornecedor
       cCGCCli :=""                     // CGC do Fornecedor
       cInscCli:=""                     // Inscricao estadual do Fornecedor
       cCOD_CLI:="XXXXX"
       cMunCLI := ""
	Endif
	cEXTENSO:=Extenso(nValDup,.F.,1)
	cEXTENSO:=cEXTENSO+REPLICATE('*',IIF(Len(cEXTENSO)<180,180-Len(cEXTENSO),0))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                         IMPRESSAO                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    @ 00,000 PSAY Chr(15)
    //                          @ 04,088 PSAY cNatureza
    @ 03,092 PSAY dEmissao

    @ 07,007 PSAY Month(dEmisNf)
    @ 07,032 PSAY year(dEmisNF)
    @ 07,051 PSAY cNumNF
    @ 07,068 PSAY nValDup       PICTURE "@E 999,999,999.99"
    @ 07,094 PSAY cNumNF+IIF(cParcela<>" ",'-'+cParcela,"")
    @ 07,108 PSAY DTOC(dVencto)

    @ 10,004 PSAY day(dEmisNf)
    @ 10,012 PSAY cNumDoc
    @ 10,024 PSAY nValBrut      PICTURE "@E 999,999,999.99"

	@ 10,060 PSAY cMailCob

    @ 12,060 PSAY cNomeCli
    @ 12,125 PSAY cCod_Cli
    @ 12,131 PSAY cLojaCli

    @ 13,060 PSAY cEndCli
    @ 13,120 PSAY cCEP

    @ 14,060 PSAY cCompl
    @ 14,089 PSAY cBairro
    
    @ 15,060 PSAY cMunCli
    @ 15,105 PSAY cEstCli
    @ 15,120 PSAY alltrim(cTel)

    @ 16,060 PSAY cCobCli
    @ 16,120 PSAY cCepCob

    @ 17,060 PSAY cComplCob
    @ 17,089 PSAY cBairCob

    @ 18,060 PSAY cMunCob
    @ 18,105 PSAY cEstCob
    @ 18,120 PSAY alltrim(cTelCob)

    @ 19,060 PSAY cCGCCli       PICTURE "@R 99.999.999/9999-99"
    @ 19,109 PSAY cInscCli

    //@ zz,yyy PSAY cPEDIDO
    //@ zz,yyy PSAY cCODVEND

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Impressao do Extenso                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    nLin:=21
	aExtenso:={"","",""}
	J:=1
	For I:=1 to 2
        aExtenso[I]:=SUBSTR(cEXTENSO,J,063)
        @ nLin,075 PSAY aExtenso[I]
        J:=J+063
//        nLin := nLIn+1
	NEXT
    @ 40,00 PSAY " "
	SETPRC (0,0)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino da Impressao da Duplicata              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(1)           // Reestabelece Area Principal de Pesquisa
    dbSkip()                    // e passa para a proxima Duplicata
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Avan‡o da R‚gua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()			// Incrementa regua
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa da Duplicata                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbCommitAll()
dbSelectArea("SE1")
dbSetOrder(1)
dbcommitAll()
Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   ourspool(wnrel)
Endif
MS_FLUSH()
Return
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funcao    ³ VERIMP   ³ Autor ³ Tadeu H. Bruscato     ³ Data ³ 19/02/99 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descricao ³ Verifica posicionamento de papel na Impressora             ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function VerImp
Static Function VerImp()
nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==3
   nOpc       := 1
   #IFNDEF WINDOWS
       cCor := "B/BG"
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
				Return
		EndCase
	End
Endif

Return
