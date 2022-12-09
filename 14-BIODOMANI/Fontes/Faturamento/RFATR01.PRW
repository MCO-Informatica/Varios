#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  Pedido  º Autor ³ Cristiano Figueiroaº Data ³  12/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o Pedido de Vendas de acordo com o lay-out definidoº±±
±±º          ³ pela Prolife                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Prolife Imp  e  Exp Ltda                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// 12/03/2020 = Alterada impressão de vendedor se Cosmo (Vend1) ou Samana (Vend2) 
// 09/04/2020 = Alterado layout adicionando linha de valor a cobrar considerando
//              somente os itens que geram financeiro e adição do ICMS-ST

User Function RFATR01

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aOrd := {}
	Local titulo       := "P E D I D O "
	Local nLin         := 80
	Local Cabec1       := ""
	Local Cabec2       := ""
	Local cDesc1       := "Este programa tem como objetivo imprimir os Pedidos"
	Local cDesc2       := "de venda de acordo com os parametros informados."
	Local cDesc3       := "P E D I D O  DE  V E N D A S"
	Local cPict        := ""
	Local imprime      := .T.
	Local _nValGeral   := 0
	Local _nValCobrar  := 0
	Local _nICMSRET    := 0
	Local _nPrazo      := 0

	Private cString
	Private CbTxt        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 80
	Private tamanho      := "P"
	Private nomeprog     := "RFATR01"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg       := "RFATR01"
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "RFATR01"
	Private _aGrupo	   := UsrRetGrp(,RetCodUsr())
	Private _cGrupo    := Iif(__cUserID$"000000","000003",_aGrupo[1])

	_cVia                :="( Via do Cliente )"

	_nInd 			   := 1
	_cNumAtd		   :=""
	_cCodObs	       :=""
	_cObs			   :=""	
	_cTes              :=""
	_cLocal			   :="" 	
	_cNomTes           :=""   
	_lLib 			   := .T.
	_cOrigem    	   := ""
	_cCodCli 		   := ""
	_cNomCli  		   := ""
	_cFanCli  		   := ""
	_cTelCli  		   := ""
	_cConCli  		   := ""
	_cCGCCli  		   := ""
	_cEndCli  		   := ""
	_cBaiCli  		   := ""
	_cCepCli  		   := ""
	_cMunCli  		   := ""
	_cEstCli  		   := ""
	_cEndCliE  		   := ""
	_cBaiCliE  		   := ""
	_cCepCliE  		   := ""
	_cMunCliE  		   := ""
	_cEstCliE  		   := ""
	_cEntrega          := ""
	_cHora			   := ""
	_cHora1			   := ""
	_cHora2  		   := ""
	_cOpFatur 		   := ""
	_nRodape           := 0
	_cObsPed1		   := ""
	_cObsPed2          := ""
	_cObsPed3          := ""
	_cNota			   := ""
	_cNotaS			   := ""

	Private cString := "SC5"

	dbSelectArea("SC5")
	dbSetOrder(1)

	//ValidPerg()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                        ³
	//³ mv_par01              Do Pedido                             ³
	//³ mv_par02              Ate o Pedido                          ³
	//³ MV_PAR05              Quantidade de Copias                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP5 IDE            º Data ³  13/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem

	dbSelectArea("SD2")
	dbSetOrder(8)  // D2_FILIAL + D2_PEDIDO + D2_ITEM

	dbSelectArea("SA3")  // Cadastro de Vendedores
	dbSetOrder(1)

	dbSelectArea("SUA")  // Cadastro de Chamados ( Televendas ) 
	dbSetOrder(8)        // UA_FILIAL + UA_NUMSC5

	dbSelectArea("SYP")  // Campos Memo
	dbSetOrder(1)

	dbSelectArea("SA4")  // Cadastro de Transportadoras
	dbSetOrder(1)

	dbSelectArea("SE4")  // Condicoes de Pagamento
	dbSetOrder(1)

	dbSelectArea("SA1")  // Cadastro de Clientes
	dbSetOrder(1)

	dbSelectArea("SF4")  // Tipos de Entrada e Saida
	dbSetOrder(1)

	dbSelectArea("SC6")  // Itens do Pedido de Vendas
	dbSetOrder(1)

	dbSelectArea("SC9")  // Itens Liberados
	dbSetOrder(1)

	dbSelectArea("SC5")  // Cabecalho do Pedido de Vendas
	dbSetOrder(1)
	SetRegua(RecCount())
	_nPrazo    := 0
	_nValGeral := 0
	_nValCobrar:= 0
	_nICMSRET  := 0
	_nVezes    := 0
	_nPar05	   := MV_PAR05
	_cXimpre   := ""
	dbSeek(xFilial()+mv_par01,.T.)

	While !EOF() .And. xFilial() == SC5->C5_FILIAL .And. SC5->C5_NUM <= mv_par02

		// Nao Existem Item de alguma Nota Fiscal - Ja efetua o bloqueio da impressao		
		// Antes dessa implementacao a impressao nao era efetuada sempre que algum
		// Item do Pedido estivesse com bloqueio. Na verdade agora o Pedido so e
		// impresso se ja possui NF Gerada. As checagens abaixo deixam de ser necessarias
		// ( Referente ao Bloqueio do Item )

		/*
		If SC5->C5_TRANSP == "000000"
			dbSelectArea("SC5")
			dbSkip()
			Loop
		EndIf
		*/
		If SC5->C5_X_EMPFA < MV_PAR03 .OR. SC5->C5_X_EMPFA > MV_PAR04
			dbSelectArea("SC5")
			dbSkip()
			Loop
		EndIf

		If DTOS(SC5->C5_EMISSAO) < DTOS(MV_PAR06) .OR. DTOS(SC5->C5_EMISSAO) > DTOS(MV_PAR07)
			dbSelectArea("SC5")
			dbSkip()
			Loop
		EndIf

		If DTOS(SC5->C5_X_DATFA) < DTOS(MV_PAR10) .OR. DTOS(SC5->C5_X_DATFA) > DTOS(MV_PAR11)
			dbSelectArea("SC5")
			dbSkip()
			Loop
		EndIf

		If SC5->C5_X_ARMAZ < MV_PAR08 .OR. SC5->C5_X_ARMAZ > MV_PAR09
			dbSelectArea("SC5")
			dbSkip()
			Loop
		EndIf

		If SC5->C5_X_NUMSE < MV_PAR12 .OR. SC5->C5_X_NUMSE > MV_PAR13
			dbSelectArea("SC5")
			dbSkip()
			Loop
		EndIf
		
		If SC5->C5_X_IMPRE$"S" //.and. _cGrupo$"000003"
			If !MsgYesNo("O pedido "+SC5->C5_NUM+" já foi impresso. Deseja imprimir novamente?","Reimpressão Pedido")
				dbSelectArea("SC5")
				dbSkip()
				Loop
			//Else
			//	_cXimpre := SC5->C5_X_IMPRE
			EndIf
		EndIf

		dbSelectArea("SD2")
		If !DbSeek(xFilial()+SC5->C5_NUM)
			_lLib := .f. 
		Else
			_cNota  := Alltrim(SD2->D2_DOC)
			_cNotaS := Alltrim(SD2->D2_SERIE)
		Endif


		// Contador para Repetir a Impressao por Tres Vezes

		dbSelectArea("SC5")

		/*
		If ALLTRIM(SC5->C5_TRANSP) $ "000006.000090"
			_nPar05 := 3
		Else
			_nPar05 := 1
		EndIf
		*/
		
		Do While _nVezes < SC5->C5_X_VIASP //.and. _lLib == .t. 

			If _nVezes     == 0
				_cVia := "( Via do Cliente )"
			ElseIf _nVezes == 1
				_cVia := "( Via da Expedicao )"
			ElseIf _nVezes == 2
				_cVia := "( Protocolo de Recebimento )"
			Endif

			_nVezes := _nVezes + 1

			//		Cabec(ALLTRIM(Titulo)+ALLTRIM(_cVia),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			_nValGeral := 0
			_nValCobrar:= 0
			_nICMSRET  := 0
			_nPrazo    := 0	
			_nFrete    := 0

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If nLin > 55
				//			Cabec(Titulo+_cVia,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz o Posicionamento dos Arquivos Envolvidos                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			_cPedido := SC5->C5_NUM
			_cNumSep := SC5->C5_X_NUMSE
			_cForma  := "  "
			_cTransp := SC5->C5_TRANSP
			_cCondPg := SC5->C5_CONDPAG
			_cVend1  := SC5->C5_VEND1
			_cVend2  := SC5->C5_VEND2
			_cVend3  := SC5->C5_VEND3
			_cVend4  := SC5->C5_VEND4
			_cVend   := ""
			_dData   := SC5->C5_EMISSAO
			_cobs    := SC5->C5_OBS1
			_cHora   := "  "
			_cHora1  := "  "
			_cHora2  := "  "
			_dEntrega:= date()
			_cObsPed1:= "  "
			_cObsPed2:= "  "
			_cObsPed3:= "  "

			dbSelectArea("SUA")
			If dbSeek(xFilial()+SC5->C5_NUM)
				_cNumAtd := SUA->UA_NUM 
				_cCodObs := SUA->UA_CODOBS
			Endif

			dbSelectArea("SC6")
			dbSeek(xFilial()+SC5->C5_NUM)
			_cTes   := SC6->C6_TES   
			_cLocal := SC6->C6_LOCAL


			dbSelectArea("SC9")
			dbSeek(xFilial()+SC5->C5_NUM)


			dbSelectArea("SF4")
			dbSeek(xFilial()+_cTes)
			_cNomTes := SF4->F4_TEXTO

            // (12/03/2020 - Luiz - Usar o vendedor conforme a Linha de Venda no Pedido)
			if SC5->C5_VENDE = "1"
			   _cVend := SC5->C5_VEND1
			else
			   if SC5->C5_VENDE = "2" 
			      _cVend := SC5->C5_VEND2
			   else
			      _cVend := ""
			   endif
			endif
			if !Empty(AllTrim(_cVend))
    			dbSelectArea("SA3")
    			dbSeek(xFilial()+_cVend)
			    _cNVend := SA3->A3_NREDUZ
			else
			    _cNVend := ""
			endif

			dbSelectArea("SA4")
			dbSeek(xFilial()+SC5->C5_TRANSP)
			_cNTrans := SA4->A4_NREDUZ

			dbSelectArea("SE4")
			dbSeek(xFilial()+SC5->C5_CONDPAG)

			dbSelectArea("SA1")
			If dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
				_cCodCli := SA1->A1_COD + "/" + SA1->A1_LOJA
				_cNomCli := SA1->A1_NOME
				_cFanCli := SA1->A1_NREDUZ
				_cTelCli := SA1->A1_TEL
				_cConCli := SA1->A1_CONTATO
				_cCGCCli := SA1->A1_CGC
				_cEndCli := SA1->A1_END
				_cBaiCli := SA1->A1_BAIRRO
				_cCepCli := SA1->A1_CEP
				_cMunCli := SA1->A1_MUN
				_cEstCli := SA1->A1_EST

				_cEndCliE := SA1->A1_ENDent
				_cBaiCliE := SA1->A1_BAIRROe
				_cCepCliE := SA1->A1_CEPe
				_cMunCliE := SA1->A1_MUNe
				_cEstCliE := SA1->A1_ESTe

			Endif

			if SC5->C5_FORMAPG == 'TR'
				_cOpFatur := " ( Troca )"              
				_cNomTes  := " ( Troca )" 
			Endif

			@ 05,000 PSAY "ORDEM SEPARACAO:" + _cNumSep
			If SC5->C5_X_IMPRE$"S"	
				@ 05,055 PSAY "**** R E I M P R E S S A O"
			EndIf
			@ 06,000 PSAY "PEDIDO NUMERO..:" + _cPedido
			@ 06,055 PSAY "DATA DE EMISSAO:" + Dtoc(_dData)
			@ 07,000 PSAY "TIPO           :" + _cNomTes 
			@ 08,000 PSAY "ARMAZEM        :" + _cLocal
			@ 09,000 PSAY "PEDIDO IMPRESSO POR: " + SUBSTR(CUSUARIO,7,15)
            @ 10,000 PSAY "DATA DA IMPRESSAO:" + Dtoc(Date())		
            @ 10,055 PSAY "HORA DA IMPRESSAO:" + Time() 

			@ 11,000 PSAY Replicate("=",80)
			@ 12,020 PSAY "D A D O S   D O   C L I E N T E" + _cOrigem
			@ 13,000 PSAY Replicate("=",80)

			@ 14,000 PSAY "Razao   : "+ _cCodCli + " - " + _cNomCli
			@ 15,000 PSAY "Fantasia: "+ _cFanCli
			@ 16,000 PSAY "Endereco: "+ _cEndCli 
			@ 17,000 PSAY "CEP     : "+ _cCepCli + " -  Bairro  :" + _cBaiCli
			@ 18,000 PSAY "Cidade  : "+ Alltrim(_cMunCli) + " - Estado  :" + _cEstCli
			@ 19,000 PSAY "Fone    : "+ Alltrim(_cTelCli) + " - Contato :" + _cConCli
			@ 20,000 PSAY Replicate("=",80)

			_cPedido := SC5->C5_NUM
			_cForma  := SC5->C5_FORMAPG
			_cTransp := SC5->C5_TRANSP
			_cCondPg := SC5->C5_CONDPAG  
			//_cVend1  := SC5->C5_VEND1
			//_cVend2  := SC5->C5_VEND2
			//_cVend3  := SC5->C5_VEND3
			//_cVend4  := SC5->C5_VEND4
			//_cVend   := ""			
			_dData   := SC5->C5_EMISSAO
			_nFrete  := SC5->C5_FRETE
			//		_dEntrega:= SC5->C5_ENTREGA   

			If SC5->C5_FORMAPG == 'CH'
				_cOpFatur := " ( Cobranca Atraves de Cheques )"
			ElseIf SC5->C5_FORMAPG == 'BO'
				_cOpFatur := " ( Cobranca Atraves de Boleto Bancario )"
			ElseIf SC5->C5_FORMAPG == 'FI'
				_cOpFatur := " ( Cobranca Atraves de Boleto Bancario )"
			Elseif SC5->C5_FORMAPG == 'DC'
				_cOpFatur := " ( Cobranca Atraves de Deposito Bancario )"
			Elseif SC5->C5_FORMAPG == 'DA'
				_cOpFatur := " ( Cobranca Atraves de Deposito Bancario )"
			Elseif SC5->C5_FORMAPG == 'R$'
				_cOpFatur := " ( Cobranca Atraves de Dinheiro )"
			Elseif SC5->C5_FORMAPG == 'CC'
				_cOpFatur := " ( Cobranca Atraves de Cartao de Credito )"
			Elseif SC5->C5_FORMAPG == 'TR'
				_cOpFatur := " ( Troca )"              
				_cNomTes  := " ( Troca )" 
			Endif

			RecLock("SC5",.f.)
			SC5->C5_X_IMPRE	:=	'S'
			SC5->C5_X_DTIMP	:=	dDataBase
			MsUnLock()

			dbSelectArea("SC6")
			dbSeek(xFilial()+SC5->C5_NUM)

			@ 21,020 PSAY " D A D O S   D O   P E D I D O " + " ( " + _cNota + "-"+ _cNotas  + " ) "
			@ 22,000 PSAY Replicate("=",80)
			@ 23,000 PSAY "Forma de Entrega   : " + _cTransp + "-" + _cNTrans
			@ 24,000 PSAY "Forma de Pagamento : " + _cForma + " - " +  _cOpFatur
			@ 25,000 PSAY "Atendente          : " + _cVend + "-" + _cNVend
			@ 26,000 PSAY "Prazo de Pagamento : "+Se4->e4_descri//+"Dias"

			// Calcula o Valor Total do Pedido
			While !Eof() .And. SC6->C6_NUM == SC5->C5_NUM
				_nPrazo := _nPrazo + SC6->C6_VALOR
				DbSkip()
				Loop
			Enddo

			_nPrazo := _nPrazo + SC5->C5_FRETE
			// Soma o Valor do Frete

			// Calcula as Condicoes de Pagamento
			_aCondicoes := Condicao(_nPrazo, SC5->C5_CONDPAG,,SC5->C5_EMISSAO)
			_nY := 27
			_nX := 00
			/*
			For _nC := 1 to len(_aCondicoes)
				@ _nY  , _nx PSAY "R$ "+Alltrim(Transform(_aCondicoes[_nC][2],"@E 999,999.99"))+" ("+DTOC(_aCondicoes[_nC][1])+")"
				_nx := _nx + 3
			Next*/

			//Customização feita por Lucas Baía - UPDUO.
			DbSelectArea("SE1")
			SE1->(DbSetOrder(31)) //E1_FILIAL+E1_PEDIDO
			
			IF SE1->(DbSeek(xFilial("SE1")+SC5->C5_NUM))
				WHILE SE1->(!EOF()) .AND. SE1->E1_PEDIDO == SC5->C5_NUM
					@ _nY  , _nx PSAY "Parcela "+Iif(!EmptY(SE1->E1_PARCELA),SE1->E1_PARCELA,"Única ")+" -> R$ "+Alltrim(Transform(SE1->E1_VALOR,"@E 999,999.99"))+" ("+DTOC(SE1->E1_VENCREA)+") "+ " - " + SE1->E1_FORMAPG + Chr(13) + Chr(10)
					SE1->(DBSKIP())
				ENDDO
			ENDIF
			//Finalização da Customização feita pelo Lucas Baía - UPDUO.

			
			If subs(_cEndCliE,1,3) != "   " 
				@ 28,000 PSAY Replicate("=",80)
				@ 29,000 PSAY "Entrega : "+ _cEndCliE + "    Cidade  : "+ _cMunCliE 
				@ 30,000 PSAY "CEP     : "+ _cCepCliE + " -  Bairro  :" + _cBaiCliE  +" UF:" + _cEstCliE
			Endif    

			// Volta a Reposicionar o SC6

			dbSelectArea("SC6")
			dbSeek(xFilial()+SC5->C5_NUM)

			@ 31,000 PSAY Replicate("=",80)

			_nLi := 37

			@ 32,032 PSAY " P R O D U T O S  "
			@ 33,000 PSAY Replicate("=",80)
			@ 34,000 PSAY "It  Codigo          Descricao                      Peso Qtdade   Preco    Total  "
			@ 35,000 PSAY Replicate("=",80)

			_WPESO_TOTAL := 0

			While !Eof() .And. SC6->C6_NUM == SC5->C5_NUM

				If _nLi > 51
					@ 60,000 PSAY Replicate("*",80)
					@ 61,012 PSAY " * C o n t i n u a   n a   P r o x i m a   P a g i n a * "
					@ 62,000 PSAY Replicate("*",80)

					//  		      Cabec(Titulo+_cVia,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

					@ 05,000 PSAY "ORDEM SEPARACAO:" + _cNumSep
					If SC5->C5_X_IMPRE$"S"	
						@ 05,055 PSAY "**** R E I M P R E S S A O"
					EndIf

					@ 06,000 PSAY "PEDIDO NUMERO..:" + _cPedido
					@ 06,055 PSAY "DATA DE EMISSAO:" + Dtoc(_dData)
					@ 07,000 PSAY "TIPO           :" + _cNomTes 
					@ 08,000 PSAY "ARMAZEM        :" + _cLocal
					@ 09,000 PSAY "PEDIDO IMPRESSO POR: " + SUBSTR(CUSUARIO,7,15)
                    @ 10,000 PSAY "DATA DA IMPRESSAO:" + Dtoc(Date())		
					@ 10,055 PSAY "HORA DA IMPRESSAO:" + Time() 
					                             
					@ 11,000 PSAY Replicate("=",80)
					@ 12,025 PSAY " P R O D U T O S  - ( Continuacao ) "
					@ 13,000 PSAY Replicate("=",80)
					@ 14,000 PSAY "It  Codigo          Descricao                      Peso Qtdade   Preco    Total  "
					@ 15,000 PSAY Replicate("=",80)
					_nLi := 16
				Endif  

				_cItem := SC6->C6_ITEM
				_cProd := SC6->C6_PRODUTO
				_cDesc := SC6->C6_DESCRI
				_cUn   := SC6->C6_UM
				_nQtdV := SC6->C6_QTDVEN
				_nPreco:= SC6->C6_PRCVEN
				_nTotal:= SC6->C6_VALOR
				_cTES  := SC6->C6_TES                     
				_cPESO := 0                   

				dbSelectArea("SC9")
				dbsetorder(1)                                     		
				dbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)			
				dbSelectArea("SD2")
				dbSelectArea("SB1")
				dbsetorder(1)                                     		
				dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
				If !found()
					alert("nao achei produto  "+xFilial("SB1")+SC6->C6_PRODUTO)
				Endif   
				_cPESO := (SC6->C6_QTDVEN * SB1->B1_PESO)
				_WPESO_TOTAL := _WPESO_TOTAL + _CPESO
				
				dbSelectArea("SD2")
				dbsetorder(8)                                
				dbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)     		
				//IF dbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)

				@_nLi,000 PSAY _cItem
				@_nLi,004 PSAY SUBS(_cProd,1,12)
				@_nLi,017 PSAY subs(_cDesc,1,26)
				@_nLi,049 PSAY TRANSFORM(_CPESO,"@E 9999.99")
				@_nLi,057 PSAY TRANSFORM(_nQtdV,"9999")
				@_nLi,062 PSAY TRANSFORM(_nPreco,"@E 9,999.99")
				@_nLi,071 PSAY TRANSFORM(_nTotal,"@E 99,999.99")
				_nLi := _nLi + 1
         
		        if !Empty(SD2->D2_LOTECTL)
				   @_nLi,017 PSAY "Lote: " + SD2->D2_LOTECTL + " Validade: "+DTOC(SD2->D2_DTVALID)+ "    Qtde: "+AllTrim(Str(SD2->D2_QUANT))
				   _nLi := _nLi + 1

                   __cItemAtual := SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV
                   while .T.
                      dbSkip()
                      if SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV == __cItemAtual
                         @_nLi,017 PSAY "Lote: " + SD2->D2_LOTECTL + " Validade: "+DTOC(SD2->D2_DTVALID)+ "    Qtde: "+AllTrim(Str(SD2->D2_QUANT))
                         _nLi := _nLi + 1
                      else
                         exit
                      endif                    
                   enddo
                endif

			    _nLi := _nLi + 1
 
				_nValGeral := _nValGeral + _nTotal
				if POSICIONE("SF4",1,XFILIAL("SF4")+SC6->C6_TES,"F4_DUPLIC") = "S"
				   _nValCobrar := _nValCobrar + _nTotal
				endif

			    dbSelectArea("SC6")
			    dbSkip()


			Enddo

			nLin := nLin + 1


			@ 53,000 PSAY Replicate("=",80)
//			If _nVezes == 3  // Responsavel pelo controle da impressao para o Protocolo
//				@ 54,000 PSAY "DATA : _____/______/______"
//			Endif	

			@ 54,001 PSAY "Peso Total   : "
			@ 54,020 PSAY TRANSFORM(_wpeso_total,"@E 999,999.99")+" Gramas"
			@ 54,050 PSAY "Subtotal     : "
			@ 54,070 PSAY TRANSFORM(_nValGeral,"@E 999,999.99")
			@ 55,050 PSAY "Vlr Frete   : "
			@ 55,070 PSAY TRANSFORM(_nFrete   ,"@E 999,999.99")
//			If _nVezes == 3 // Responsavel pelo controle da impressao para o Protocolo
  				@ 56,000 PSAY "___________________________"
//			Endif	
			@ 56,050 PSAY "_______________________________"
//			If _nVezes == 3  // Responsavel pelo controle da impressao para o Protocolo
				@ 57,000 PSAY "    DATA / VISTO CLIENTE    "     
//			Endif	
			@ 57,050 PSAY "Total Pedido: "
			@ 57,070 PSAY TRANSFORM(_nValGeral + _nFrete,"@E 999,999.99")
			
			_nICMSRET := POSICIONE("SF2",1,XFILIAL("SF2")+_cNota+_cNotaS,"F2_ICMSRET")
			@ 58,050 PSAY "VL ICMS/RET.: "
			@ 58,070 PSAY TRANSFORM(_nICMSRET,"@E 999,999.99")
			
			@ 59,050 PSAY "VALOR COBRAR: "
			@ 59,070 PSAY TRANSFORM(_nValCobrar + _nFrete + _nICMSRET,"@E 999,999.99")
			@ 60,000 PSAY Replicate("=",80)


			If !Empty(Alltrim(_cHora1))

				@ 61,009 PSAY "********* Horario para entrega..: das  " 
				@ 61,047 PSAY  _cHora1 Picture PesqPict("SC5","C5_HORA1") 
				@ 61,053 PSAY "as "
				@ 61,056 PSAY  _cHora2 Picture PesqPict("SC5","C5_HORA2") + " **********"

			Endif	


			// Observacoes Vindas do Call Center

			//		If !Empty(_cCodObs)

			//			_cObs    := MSMM(_cCodObs,70)
			//			_nInd    := 1 
			//			_nRodape := 0   

			//			Do While .T. .and. _nRodape < 4   // Imprime apenas 3 Linhas de Descricao
			//				_cLinha := Substr(_cObs,_nInd,70)

			//				If ! Empty(_cLinha)
			//					_nRodape := _nRodape + 1
			//					@ 60+_nRodape ,000 PSAY _cLinha
			//				Else
			//					Exit
			//				EndIf

			//		 		_nInd := _nInd + 70
			//		 		
			//		 	Enddo

			//  	    Else


			//	    EndIf

	       @ 62,000 PSAY "Observacoes.:"
	       If subs(_cObs,1,4)!= "    " 
		      @ 62 ,014 PSAY _cObs
	       Endif	


		Enddo

		DbSelectArea("SC5")
		dbSkip()

		_nVezes := 0
		_nFrete := 0
		_nValGeral := 0
		_nValCobrar:= 0
		_nICMSRET  := 0
		_nICMSRET  := 0
		_nPrazo  := 0   
		_lLib    := .t.                   
		_cNumAtd :=""
		_cCodObs :=""
		_cOpFatur:= "  "
		_cNota   := ""


	EndDo

//	@ 60,000 PSAY "Observacoes.:"
//	If subs(_cObs,1,4)!= "    " 
//		@ 60 ,014 PSAY _cObs
//	Endif	

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  13/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,6)

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"1","DO PEDIDO","mv_ch1","C",6,00,0,"G","","mv_par1","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"2","ATE O PEDIDO","mv_ch2","C",6,00,0,"G","","mv_par2","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"3","QTD COPIAS","mv_ch3","C",6,00,0,"G","","mv_par3","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

Return

