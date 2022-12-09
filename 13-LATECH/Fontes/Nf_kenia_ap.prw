#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Nf_kenia()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NVALBENEF,NTAMNF,_APERGUNTAS,_NLACO")
SetPrvt("CSTRING,CPEDANT,NLININI,XLETRA,XNUM_NF,XSERIE")
SetPrvt("XEMISSAO,XTOT_FAT,LFLAGBENEF,XLOJA,XFRETE,XSEGURO")
SetPrvt("XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XDESPESAS,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XCOD_TRIB,XCHAVE")
SetPrvt("XQTD_PRO,XPRE_UNI,XPRE_TAB,XIPI,XVAL_IPI,XDESC")
SetPrvt("XVAL_DESC,XVAL_MERC,XTES,XCF,XICMSOL,XICM_PROD")
SetPrvt("_NPOS,XPESO_PRO,XPESO_UNIT,XDESCRICAO,XUNID_PRO,XMEN_TRIB")
SetPrvt("XCOD_FIS,XCLAS_FIS,XMEN_POS,XISS,XTIPO_PRO,XLUCRO")
SetPrvt("XCLFISCAL,XPESO_LIQ,I,NPELEM,_CLASFIS,NPTESTE")
SetPrvt("XPESO_LIQUID,XPED,XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI")
SetPrvt("XCOD_MENS,XMENSAGEM,XTPFRETE,XCONDPAG,XPAPELETA,XDESCONT")
SetPrvt("XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI,XDESC_PRO,J")
SetPrvt("XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO,XCEP_CLI,XCOB_CLI")
SetPrvt("XREC_CLI,XREC_MUN,XREC_EST,XREC_CEP,XREC_BAIR,XMUN_CLI")
SetPrvt("XEST_CLI,XCGC_CLI,XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI")
SetPrvt("XSUFRAMA,XCALCSUF,ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP")
SetPrvt("XEND_TRANSP,XMUN_TRANSP,XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP")
SetPrvt("XINS_TRANSP,XPARC_DUP,XVENC_DUP,XVALOR_DUP,XDUPLICATAS,XNATUREZA")
SetPrvt("XFORNECE,XNFORI,XPEDIDO,XPESOPROD,XFAX,XINI")
SetPrvt("XFIM,CARQSQL,CARQDBF,CINDSQL,NOPC,CCOR")
SetPrvt("NTAMDET,XB_ICMS_SOL,XV_ICMS_SOL,NPRE_UNI,NCONT,NCOL")
SetPrvt("NTAMOBS,NAJUSTE,BB,_CDIR,_CFILE,_CINDICE")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Nfiscal ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Entrada/Saida                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga  - kENIA                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³
//³ mv_par03             // Da Serie                             ³
//³ mv_par04             // Nota Fiscal de Entrada/Saida         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G"
limite:=220
titulo :=PADC("Nota Fiscal - Nfiscal",74)
cDesc1 :=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 :=""
cDesc3 :=PADC("da Nfiscal",74)
cNatureza:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="NFISCAL"
cPerg:="NFSIGW    "
nLastKey:= 0
lContinua := .T.
nLin:=0
wnrel     := "SIGANF"

nValBenef := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerguntas:= {}

AADD(_aPerguntas,{cPerg,"01","Da Nota            ? " ,"mv_ch1","C",06,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"02","Ate a Nota         ? " ,"mv_ch2","C",06,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"03","Da Serie           ? " ,"mv_ch3","C",03,0,0,"G"," ","mv_par03","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"04","Tipo de Operacao   ? " ,"mv_ch4","N",01,0,0,"C"," ","mv_par04","Sim      ","","","Nao      ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"05","Aglutina Produtos  ? " ,"mv_ch5","N",01,0,0,"C"," ","mv_par05","Sim      ","","","Nao      ","","","","","","","","","","","",})

DbSelectArea("SX1")
For _nLaco:=1 to Len(_aPerguntas)
	If !DbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
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
Next

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    __Return()
	Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
	// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     __Return()
	Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
Endif

VerImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento da Nota Fiscal                       ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(RptDetail)})
	// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     __Return()
	Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
	// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	Function RptDetail
	Static Function RptDetail()
#ENDIF

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Val(mv_par02)-Val(mv_par01))
If mv_par04 == 2
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua
		
		If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
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
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		// * Cabecalho da Nota Fiscal
		
		xLETRA := "A"
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		lFlagBenef    := .f.
		if xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
			lFlagBenef  :=  Iif(mv_par04 == 2 ,.t.,.f.)
		endif
		xCLIENTE    :=SF2->F2_CLIENTE            // Codigo do Cliente
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xDESPESAS   :=SF2->F2_DESPESA         // Valor Despesas Acessorias
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		
		xPED_VEND:={}                         // Numero do Pedido de Venda
		xITEM_PED:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xCOD_TRIB:={}                         // Codigo de Tributacao
		xChave   :={}                         // Chave para busca do pedido+item
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Venda
		xPRE_TAB :={}                         // Preco Unitario de Tabela
		xIPI     :={}                         // Porcentagem do IPI
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xMEN_TEC :={}
		
		while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03                    // Se a Serie do Arquivo for Diferente
				DbSkip()                                                   // do Parametro Informado !!!
				Loop
			Endif
			
			If mv_par06 == 2 .and. Subs(Alltrim(SD2->D2_COD),4,3) $ "000"
				dbSkip()
				Loop
			EndIf
			
			*--------------------------------------------------------*
			* Alteracao deste bloco em 17/10/2000 por Ricardo Correa *
			*                                                        *
			* Aglutinacao dos produtos iguais devido ao controle de  *
			* lotes, conforme solicitacao do usuario. No momento da  *
			* impressao o programa aglutina dados do mesmo produto.  *
			*--------------------------------------------------------*
			
			_nPos := ASCAN(xChave,SD2->D2_PEDIDO+SD2->D2_COD)
			
			If _nPos<>0 .and. MV_PAR05 == 1 .and. !Alltrim(SD2->D2_COD) $"2207"
				xQTD_PRO[_nPos]  :=  xQTD_PRO[_nPos]  + SD2->D2_QUANT
				xVAL_IPI [_nPos] :=  xVAL_IPI [_nPos] + SD2->D2_VALIPI
				xVAL_MERC[_nPos] :=  xVAL_MERC[_nPos] + SD2->D2_TOTAL
			Else
				*--------------------------------------------------------*
				* Final do bloco - Alterado por Ricardo Correa           *
				*--------------------------------------------------------*
				
				AADD(xChave ,SD2->D2_PEDIDO+SD2->D2_COD)
				AADD(xPED_VEND ,SD2->D2_PEDIDO)
				AADD(xITEM_PED ,SD2->D2_ITEMPV)
				AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
				AADD(xPREF_DV  ,SD2->D2_SERIORI)
				AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
				AADD(xCOD_PRO  ,SD2->D2_COD)
				AADD(xCOD_TRIB ,SD2->D2_CLASFIS)
				AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
				AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
				AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
				AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
				AADD(xVAL_IPI  ,SD2->D2_VALIPI)
				AADD(xDESC     ,SD2->D2_DESC)
				AADD(xVAL_MERC ,SD2->D2_TOTAL)
				AADD(xTES      ,SD2->D2_TES)
				AADD(xCF       ,SD2->D2_CF)
				AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
				
				If SUBS(SD2->D2_COD,1,3) $"235/D24/D33/D35/D36/D38/D39/D42/D43/K01/K02/K10/K11/K25/K28/K43/K44/K45"
					AADD(xMEN_TEC,SD2->D2_COD)
				EndIf
				
			EndIf
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO:={}                           // Peso Liquido
		xPESO_UNIT :={}                         // Peso Unitario do Produto
		xDESCRICAO :={}                         // Descricao do Produto
		xUNID_PRO:={}                           // Unidade do Produto
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xPESO_LIQ := 0
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB , SB1->B1_ORIGEM)
			Endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			if npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			DO CASE
				CASE npElem == 1
					_CLASFIS := "A"
					
				CASE npElem == 2
					_CLASFIS := "B"
					
				CASE npElem == 3
					_CLASFIS := "C"
					
				CASE npElem == 4
					_CLASFIS := "D"
					
				CASE npElem == 5
					_CLASFIS := "E"
					
				CASE npElem == 6
					_CLASFIS := "F"
					
			ENDCASE
			
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			
			//_CLASFIS := SB1->B1_POSIPI
			AADD(xCOD_FIS ,_CLASFIS)
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			Endif
			
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
		Next
		
		xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
		For I:=1 to Len(xPESO_PRO)
			xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[I]
		Next
		
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
		
		xPED        := {}
		xPESO_BRUTO := 0
		xP_LIQ_PED  := 0
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial()+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
				If SC5->C5_PESOL > 0
					xPESO_LIQUID:=SC5->C5_PESOL
				EndIf
				xPAPELETA   :=SC5->C5_PAPELET            // Politica de Vendas
				xDESCONT    :=SC5->C5_DESCPON            // Desconto de pontualidade S/N
				xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
				xCOD_VEND:= {SC5->C5_VEND1,;             // Codigo do Vendedor 1
				SC5->C5_VEND2,;             // Codigo do Vendedor 2
				SC5->C5_VEND3,;             // Codigo do Vendedor 3
				SC5->C5_VEND4,;             // Codigo do Vendedor 4
				SC5->C5_VEND5}              // Codigo do Vendedor 5
				xDESC_NF := {SC5->C5_DESC1,;             // Desconto Global 1
				SC5->C5_DESC2,;             // Desconto Global 2
				SC5->C5_DESC3,;             // Desconto Global 3
				SC5->C5_DESC4}              // Desconto Global 4
				AADD(xPED,xPED_VEND[I])
			Endif
			
			If xP_LIQ_PED >0
				xPESO_LIQ := xP_LIQ_PED
			Endif
			
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa da Condicao de Pagto               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		xPED_CLI :={}                          // Numero de Pedido
		xDESC_PRO:={}                          // Descricao aux do produto
		J:=Len(xPED_VEND)
		
		For I:=1 to J
			dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,SC6->C6_DESCRI)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
		Next
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' 
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xREC_MUN :=SA1->A1_MUNR            // Municipio de Entrega
			xREC_EST :=SA1->A1_ESTR            // Estado de Entrega
			xREC_CEP :=SA1->A1_CEPR            // CEP de Entrega
			xREC_BAIR:=SA1->A1_BAIRREC         // Bairro de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
			
			// Alteracao p/ Calculo de Suframa
			if !empty(xSUFRAMA) .and. xCALCSUF =="S"
				IF XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				else
					zFranca := .T.
				endif
			Else
				zfranca:= .F.
			endif
			
		Else
			lFlagBenef := .f.
			zFranca:=.F.
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+xCLIENTE+xLOJA)
			
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_MUN :=""                      // Municipio de Entrega
			xREC_EST :=""                      // Estado de Entrega
			xREC_CLI :=""                      // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN             // Municipio
			xEST_CLI :=SA2->A2_EST             // Estado
			xCGC_CLI :=SA2->A2_CGC             // CGC
			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
		Endif
		
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found()
				xBSICMRET:=F3_VALOBSE
			Else
				xBSICMRET:=0
			Endif
		Else
			xBSICMRET:=0
		Endif
		
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_TRANSP)
		
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		xINS_TRANSP  :=SA4->A4_INSEST         // Inscr Estadual
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		While !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao
		
		If Alltrim(xCOD_MENS) == ""
			xCOD_MENS :=	SF4->F4_FORMULA
		EndIf
		
		Imprime()
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
	EndDo
Else  // NOTA FISCAL DE ENTRADA
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		If !SF1->F1_TIPO $"D"
			dbSkip()
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa  regua de impressao                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
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
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		xNFORI      :=SF1->F1_NFORI           // NF Original
		xPREF_DV    :=SF1->F1_SERIORI         // Serie Original
		xDESPESAS   :=SF1->F1_DESPESA         // Despesas Acessorias
		xNOME_TRANSP :=POSICIONE("SA4",1,XFILIAL("SA4")+SF1->F1_X_TRANS,"A4_NOME")
		xEND_TRANSP  :=POSICIONE("SA4",1,XFILIAL("SA4")+SF1->F1_X_TRANS,"A4_END")
		xMUN_TRANSP  :=POSICIONE("SA4",1,XFILIAL("SA4")+SF1->F1_X_TRANS,"A4_MUN")
		xEST_TRANSP  :=POSICIONE("SA4",1,XFILIAL("SA4")+SF1->F1_X_TRANS,"A4_EST")
		xVIA_TRANSP  :=" "           // Via de Transporte
		xCGC_TRANSP  :=POSICIONE("SA4",1,XFILIAL("SA4")+SF1->F1_X_TRANS,"A4_CGC")
		xINS_TRANSP  :=POSICIONE("SA4",1,XFILIAL("SA4")+SF1->F1_X_TRANS,"A4_INSEST")
		xTEL_TRANSP  :=POSICIONE("SA4",1,XFILIAL("SA4")+SF1->F1_X_TRANS,"A4_TEL")
		xTPFRETE     :=" "           // Tipo de Frete
		xVOLUME      := SF1->F1_X_VOLUM
		xESPECIE     :=" "           // Especie
		xPESO_LIQ    := SF1->F1_X_PESOB
		xPESO_BRUTO  := SF1->F1_X_PESOB
		xMENSAGEM    := ALLTRIM(SF1->F1_OBSDEV1)+" "+ALLTRIM(SF1->F1_OBSDEV2)
		xPESO_LIQUID :=" "
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xChave   :={}
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xCOD_TRIB:={}                         // Codigo de Tributacao
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Compra
		xPRE_TAB :={}                         // Preco Unitario de Compra
		xIPI     :={}                         // Porcentagem do IPI
		xPESOPROD:={}                         // Peso do Produto
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xMEN_TEC :={}
		
		while !eof() .and. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == (xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
			If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			If !SD1->D1_TIPO $"B/D"
				dbSkip()
				Loop
			EndIf
			
			_nPos := ASCAN(xChave,SD1->D1_COD)
			If _nPos<>0 .and. MV_PAR05 == 1
				xQTD_PRO[_nPos]  :=  xQTD_PRO[_nPos]  + SD1->D1_QUANT
				xVAL_IPI [_nPos] :=  xVAL_IPI [_nPos] + SD1->D1_VALIPI
				xVAL_MERC[_nPos] :=  xVAL_MERC[_nPos] + SD1->D1_TOTAL
			Else
				AADD(xCHAVE  ,  SD1->D1_COD )
				AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
				AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
				AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
				AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
				AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
				AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
				AADD(xCOD_TRIB ,SD1->D1_CLASFIS)
				AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
				AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
				AADD(xPRE_TAB  ,SD1->D1_VUNIT)          // Valor Unitario
				AADD(xIPI      ,SD1->D1_IPI)            // % IPI
				AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
				AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
				AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
				AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
				AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
				AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
				AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			EndIf
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO:={}                           // Unidade do Produto
		xDESC_PRO:={}                           // Descricao do Produto
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xDESCRICAO :={}                         // Descricao do Produto
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xSUFRAMA :=""
		xCALCSUF :=""
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(xUNID_PRO ,SB1->B1_UM)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xMEN_POS  ,SB1->B1_POSIPI)
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS,SB1->B1_ALIQISS)
			Endif
			
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			if npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			DO CASE
				CASE npElem == 1
					_CLASFIS := "A"
					
				CASE npElem == 2
					_CLASFIS := "B"
					
				CASE npElem == 3
					_CLASFIS := "C"
					
				CASE npElem == 4
					_CLASFIS := "D"
					
				CASE npElem == 5
					_CLASFIS := "E"
					
				CASE npElem == 6
					_CLASFIS := "F"
					
			ENDCASE
			
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			
			//_CLASFIS := SB1->B1_POSIPI
			AADD(xCOD_FIS ,_CLASFIS)
			
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa da Condicao de Pagto               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO $ "B/D"
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			
			DbSelectArea("SD2")
			DbSetOrder(3)
			DbSeek(xFilial("SD2")+xNUM_NFDV[1])
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
			
			xPAPELETA := SC5->C5_PAPELET
			
		Else
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			xEND_CLI :=SA2->A2_END                // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
			xCEP_CLI :=SA2->A2_CEP                // CEP
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			
		EndIf
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		xNATUREZA	 :=SF4->F4_TEXTO              // Natureza da Operacao
		xCOD_MENS    :=SF4->F4_FORMULA           // Codigo da Mensagem
		
		Imprime()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Termino da Impressao da Nota Fiscal                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                      FIM DA IMPRESSAO                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa da Nota Fiscal                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//----> bloco implementado em 05/07/01 por Ricardo Correa - Filial Leste
//----> este bloco servira para integrar o arquivo etiqueta para Word.
/*
xIni := "Z7"
xFim := "Z7"

@ 0,0 TO 060,320 DIALOG oDlg1 TITLE "Confirma a Exportacao  "
@ 10,20 GET xIni PICTURE "@!"
@ 20,20 GET xFim PICTURE "@!"
@ 09,105 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 09,105 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 09,070 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function OkProc
Static Function OkProc()
Close(oDlg1)
Processa( {|| Run() }, "FAZENDO EXPORTACAO" ,OemToAnsi("Copiando os Registros..."),.F.) // Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(Run) }, "FAZENDO EXPORTACAO" ,OemToAnsi("Copiando os Registros..."),.F.)
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Run
Static Function Run()

DbSelectArea("SX2")
DbClearFilter()
DbSetOrder(1)
DbGotop()

ProcRegua(RECCOUNT())
DbSeek(xIni,.T.)
While !Eof() .And. X2_CHAVE <= xFim
IncProc("Processando..."+SUBSTR(X2_ARQUIVO,1,3))

//---> inicia variaveis
cArqSQL := AllTrim(SX2->X2_ARQUIVO)
cArqDBF := AllTrim(SX2->X2_PATH) + cArqSQL
cIndSQL := cArqSQL + "1"

//---> testa existencia do arquivo no SQL
If TCCANOPEN(cArqSQL)
Use &(cArqSQL) Alias SQL New Shared Via "TOPCONN"

//---> verifica existencia no SQL. Veja instrucoes abaixo
If TCCANOPEN(cArqSQL,cIndSQL)
DbSetIndex(cIndSQL)
End
DbSetOrder(1)
DbGoTop()

//---> Copia para DBF
Copy to &(cArqDBF)

DbSelectArea("SQL")
DbCloseArea()
End

DbSelectArea("SX2")
DbSkip()
End
*/
//----> fim do bloco

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Programa                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                   FUNCOES ESPECIFICAS                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica posicionamento de papel na Impressora             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 Say "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device to Print
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
				// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>         __Return()
				Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
		EndCase
	End
Endif

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPDET   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe da Nota Fiscal              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function IMPDET
Static Function IMPDET()

nTamDet := 15            // Tamanho da Area de Detalhe

I:=1
J:=1

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

For I:=1 to nTamDet
	
	If I<= Len(xCOD_PRO)
		If ! Alltrim(xCF[I]) $ "5902/6902/5925/6925"
			If xPAPELETA == "O"
				@ nLin, 000  PSAY "1"+xCOD_PRO[I]
				If Subs(xDESCRICAO[I],1,7) == "TECIDO "
					@ nLin, 010  PSAY Subs(xDESCRICAO[I],1,7)+"1"+Subs(xDESCRICAO[I],8)
				Else
					@ nLin, 010  PSAY xDESCRICAO[I]
				EndIf
			Else
				@ nLin, 000  PSAY xCOD_PRO[I]
				If Alltrim(xCOD_PRO[I]) $ "2207/2221"
					@ nLin, 010  PSAY xDESC_PRO[I]
				Else
					@ nLin, 010  PSAY xDESCRICAO[I]
				EndIf
			EndIf
			
			@ nLin, 077         PSAY xCOD_FIS[I]
			@ nLin, 082         PSAY xCOD_TRIB[I]
			@ nLin, 089         PSAY xUNID_PRO[I]
			@ nLin, Pcol()+001  PSAY xQTD_PRO[I]               Picture"@E 999,999.999"
			@ nLin, Pcol()+000  PSAY xDESC[I]                  Picture"@E 99.99"
			
			If xTipo == "C"
				@ nLin, Pcol()+002    PSAY 0                      Picture"@E 9,999.9999"
			Else
				If xDESC[I] > 0
					nPre_Uni := Round((xPRE_TAB[I] / ((xDESC[I] / 100) - 1)*-1),2)
					@ nLin, Pcol()+001    PSAY nPre_Uni            Picture"@E 999.9999"
				Else
					@ nLin, Pcol()+001    PSAY xPRE_UNI[I]         Picture"@E 999.9999"
				EndIf
			EndIf
			
			@ nLin, Pcol()+003    PSAY xVAL_MERC[I]              Picture"@E 999,999.99"
			@ nLin, Pcol()+002    PSAY xICM_PROD[I]              Picture"99"
			@ nLin, Pcol()+002    PSAY xIPI[I]                   Picture"99"
			@ nLin, Pcol()+002    PSAY xVAL_IPI[I]               Picture"@E 9.99"
			
			J:=J+1
			nLin := nLin+1
		Else
			nValBenef := nValBenef + xVAL_MERC[I]
		EndIf
	EndIf
	
Next

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CLASFIS  ³ Autor ³   Marcos Simidu       ³ Data ³ 16/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Array com as Classificacoes Fiscais           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CLASFIS
Static Function CLASFIS()

@ nLin,002 PSAY "CLASSIFICACAO FISCAL"
nLin := nLin + 1
For nCont := 1 to Len(xCLFISCAL)
	nCol := If(Mod(nCont,2) != 0, 02, 30)
	@ nLin, nCol     PSAY xCLFISCAL[nCont] + " -"
	@ nLin, nCol+ 05 PSAY Iif(!Alltrim(xCLAS_FIS[nCont])$".",xCLAS_FIS[nCont],"0000.00.00")
	nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPMENP  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Mensagem Padrao da Nota Fiscal                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function IMPMENP
Static Function IMPMENP()

nCol:= 02

If !Empty(xCOD_MENS)
	
	@ nLin, NCol PSAY Substr( FORMULA(xCOD_MENS),001,065 )
	nLin := nLin + 1
	@ nLin, NCol PSAY Substr( FORMULA(xCOD_MENS),066,065)
	//     nLin := nLin + 1
	//   @ nLin, NCol PSAY Substr( FORMULA(xCOD_MENS),131,065)
	//     nLin := nLin + 1
	//   @ nLin, NCol PSAY Substr( FORMULA(xCOD_MENS),196,065)
	
Endif

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MENSOBS  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Mensagem no Campo Observacao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function MENSOBS
Static Function MENSOBS()

If !Empty(xMENSAGEM)
	nTamObs:=65
	nCol:=02
	@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,001,nTamObs))
	nlin:=nlin+1
	@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,066,nTamObs))
	nlin:=nlin+1
	@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,131,nTamObs))
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DUPLIC   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Parcelamento das Duplicacatas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function DUPLIC
Static Function DUPLIC()
nCol := 110
nAjuste := 0
For BB:= 1 to Len(xVALOR_DUP)
	
	If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
		@ nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]
		@ nLin, nCol + 16 + nAjuste PSAY xVENC_DUP[BB]
		@ nLin, nCol + 30 + nAjuste PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
		
		If nAjuste == 0
			nAjuste  := 58
		Else
			nAjuste := 0
			nLin := nLin + 1
		EndIf
	Endif
Next

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LI       ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pula 1 linha                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico RDMAKE                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRIME  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a Nota Fiscal de Entrada e de Saida                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico RDMAKE                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

@ 00, 000 PSAY Chr(15)                  //----> Compressao de Impressao

//----> Verifica se e Nota de Entrada ou Saida
If mv_par04 == 1
	@ 00, 108 PSAY "X"
Else
	@ 00, 094 PSAY "X"
Endif

@ 02, 126 PSAY xNUM_NF                  //----> Numero da Nota Fiscal

@ 07, 002 PSAY xNATUREZA                //----> Texto da Natureza de Operacao
@ 07, 047 PSAY xCF[1] Picture"@R 9.999" //----> Codigo da Natureza de Operacao

//----> Imprime o Segundo Cfop Quanto Trata-se de Beneficiamento
If Alltrim(xCF[1]) $ "5902"
	@ 07, 052 PSAY "/5.124"
ElseIf Alltrim(xCF[1]) $ "6902"
	@ 07, 052 PSAY "/6.124"
ElseIf Alltrim(xCF[1]) $ "5124"
	@ 07, 052 PSAY "/5.902"
ElseIf Alltrim(xCF[1]) $ "6124"
	@ 07, 052 PSAY "/6.902"
ElseIf Alltrim(xCF[1]) $ "5125"
	@ 07, 052 PSAY "/5.925"
ElseIf Alltrim(xCF[1]) $ "6125"
	@ 07, 052 PSAY "/6.925"
ElseIf Alltrim(xCF[1]) $ "5925"
	@ 07, 052 PSAY "/5.125"
ElseIf Alltrim(xCF[1]) $ "6925"
	@ 07, 052 PSAY "/6.125"
EndIf

@ 09, 002 PSAY xNOME_CLI                //----> Nome do Cliente

If !EMPTY(xCGC_CLI)                     //----> CNPJ do Cliente
	@ 09, 092 PSAY xCGC_CLI      Picture "@R 99.999.999/9999-99"
Else
	@ 09, 092 PSAY ""
Endif

@ 09, 126 PSAY xEMISSAO                 //----> Data da Emissao

@ 10, 002 PSAY xEND_CLI                 //----> Endereco
@ 10, 078 PSAY xBAIRRO                  //----> Bairro
@ 10, 107 PSAY xCEP_CLI Picture "@R 99999-999"   //----> Cep
@ 10, 126 PSAY ""                       //----> Data Saida

@ 12, 002 PSAY xMUN_CLI                 //----> Municipio
@ 12, 052 PSAY xTEL_CLI                 //----> Telefone/FAX
@ 12, 084 PSAY xEST_CLI                 //----> U.F.
@ 12, 092 PSAY xINSC_CLI                //----> Insc. Estadual
@ 12, 126 PSAY ""                       //----> Hora Saida

If mv_par04 == 2
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da Fatura/Duplicata       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nLin:=14
	BB:=1
	nCol := 002            //  duplicatas
	nAjuste := 0
	
	//----> 1¦ linha
	If Len(xVALOR_DUP) >= 1 .and. xDUPLICATAS == .T.
		@ nLin, nCol        PSAY xNUM_DUPLIC + " " + xPARC_DUP[1]
		@ nLin, nCol + 020  PSAY xVENC_DUP[1]
		@ nLin, nCol + 045  PSAY xVALOR_DUP[1] Picture("@E 9,999,999.99")
	EndIf
	
	If Len(xVALOR_DUP) >= 2
		@ nLin, nCol + 070  PSAY xNUM_DUPLIC + " " + xPARC_DUP[2]
		@ nLin, nCol + 095  PSAY xVENC_DUP[2]
		@ nLin, nCol + 120  PSAY xVALOR_DUP[2] Picture("@E 9,999,999.99")
	EndIf
	
	nLin := nLin + 1
	
	//----> 2¦ linha
	If Len(xVALOR_DUP) >= 3
		@ nLin, nCol        PSAY xNUM_DUPLIC + " " + xPARC_DUP[3]
		@ nLin, nCol + 020  PSAY xVENC_DUP[3]
		@ nLin, nCol + 045  PSAY xVALOR_DUP[3] Picture("@E 9,999,999.99")
	EndIf
	
	If Len(xVALOR_DUP) >= 4
		@ nLin, nCol + 070  PSAY xNUM_DUPLIC + " " + xPARC_DUP[4]
		@ nLin, nCol + 095  PSAY xVENC_DUP[4]
		@ nLin, nCol + 120  PSAY xVALOR_DUP[4] Picture("@E 9,999,999.99")
	EndIf
	
	nLin := nLin + 1
	
	//----> 3¦ linha
	If Len(xVALOR_DUP) >= 5
		@ nLin, nCol        PSAY xNUM_DUPLIC + " " + xPARC_DUP[5]
		@ nLin, nCol + 020  PSAY xVENC_DUP[5]
		@ nLin, nCol + 045  PSAY xVALOR_DUP[5] Picture("@E 9,999,999.99")
	EndIf
	
	If Len(xVALOR_DUP) >= 6
		@ nLin, nCol + 070  PSAY xNUM_DUPLIC + " " + xPARC_DUP[6]
		@ nLin, nCol + 095  PSAY xVENC_DUP[6]
		@ nLin, nCol + 120  PSAY xVALOR_DUP[6] Picture("@E 9,999,999.99")
	EndIf
	
	nLin := nLin + 1
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados dos Produtos Vendidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := 20

ImpDet()                                //----> Detalhe da NF

If mv_par04 == 1
	lFlagBenef  :=  .f.
EndIf


//----> NOTA KENIA
If xSERIE$"ONIEMBKEK"
	//----> Calculo dos Impostos
	@ 37, 005  PSAY "NAO GERA DIREITO A CREDITO DE ICMS" 
//	@ 38, 030  PSAY "XXXXXXXXXXXX" // Picture"@E 999,999,999.99"  // Valor do ICMS
//	@ 38, 060  PSAY xBSICMRET   Picture"@E 999,999,999.99"  // Base ICMS Ret.
//	@ 38, 090  PSAY xICMS_RET   Picture"@E 999,999,999.99"  // Valor  ICMS Ret.
Else
	//----> Calculo dos Impostos
	@ 37, 005  PSAY xBASE_ICMS  Picture"@E 999,999,999.99"  // Base do ICMS
	@ 37, 030  PSAY xVALOR_ICMS Picture"@E 999,999,999.99"  // Valor do ICMS
	@ 37, 060  PSAY xBSICMRET   Picture"@E 999,999,999.99"  // Base ICMS Ret.
	@ 37, 090  PSAY xICMS_RET   Picture"@E 999,999,999.99"  // Valor  ICMS Ret.

EndIf


If !lFlagBenef
	@ 37, 120  PSAY xTOT_FAT                Picture"@E 999,999,999.99"  // Valor Tot. Prod.
Else
	@ 37, 120  PSAY xVALOR_MERC - nValBenef Picture"@E 999,999,999.99"  // Valor Tot. Prod.
EndIf
//----> Totais da Nota Fiscal
@ 39, 005  PSAY xFRETE      Picture"@E 999,999,999.99"  // Valor do Frete
@ 39, 030  PSAY xSEGURO     Picture"@E 999,999,999.99"  // Valor Seguro
@ 39, 060  PSAY xDESPESAS   Picture"@E 999,999,999.99"  // Base ICMS Ret.
@ 39, 090  PSAY xVALOR_IPI  Picture"@E 999,999,999.99"  // Valor do IPI
If xDESPESAS > 0
	@ 39, 120  PSAY xVALOR_MERC+xVALOR_IPI+xDESPESAS Picture"@E 999,999,999.99"  // Valor Total NF
ElseIf MV_PAR04 == 2
	@ 39, 120  PSAY xTOT_FAT - Iif(lFlagBenef,nValBenef,0) Picture"@E 999,999,999.99"  // Valor Total NF
Else
	@ 39, 120  PSAY xTOT_FAT                               Picture"@E 999,999,999.99"  // Valor Total NF
EndIf


@ 41, 002  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 41, 086 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 41, 086 PSAY "2"                              // Destinatario (2)
Endif

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 41, 113 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 41, 113 PSAY " "                               // Caso seja vazio
Endif

@ 43, 002 PSAY xEND_TRANSP                          // Endereco Transp.
@ 43, 074 PSAY xMUN_TRANSP                          // Municipio
@ 43, 107 PSAY xEST_TRANSP                          // U.F.

If !EMPTY(xINS_TRANSP)                              // Se I.E. do Transportador nao for Vazio
	@ 43, 113 PSAY xINS_TRANSP
Else
	@ 43, 113 PSAY " "
EndIf

@ 44, 002 PSAY xVOLUME  Picture"@E 999,999.99"             // Quant. Volumes
@ 44, 025 PSAY xESPECIE Picture"@!"                          // Especie
@ 44, 040 PSAY " "                                           // Res para Marca
@ 44, 080 PSAY " "                                           // Res para Numero
@ 44, 110 PSAY xPESO_BRUTO      Picture"@E 999,999.99"      // Res para Peso Bruto
@ 44, 134 PSAY xPESO_LIQUID     Picture"@E 999,999.99"      // Res para Peso Liquido

If mv_par04 == 2
	nLin := 47
	@ nLin, 110          PSAY xPED_VEND[1]
	@ nLin, 130			PSAY xCOD_VEND[1]
EndIf

If xSERIE$"ONIEMBKEK"
	If Len(xMEN_TEC) > 0
		@ 48, 002 PSAY  "DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL"
		@ 48, 080 PSAY	"DEIXAR DESCANSAR ENFESTADO POR 24 HORAS ANTES DE CORTAR"
	Else
		@ 48, 002 PSAY  "DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL"
	EndIf
Else
	If Len(xMEN_TEC) > 0
		@ 48, 002 PSAY	"DEIXAR DESCANSAR ENFESTADO POR 24 HORAS ANTES DE CORTAR"
	EndIf
EndIf

 

nLin := 49
ImpMenp()       //----> Imprime Mensagem Padrao da Nota Fiscal

nLin := 51
MensObs()       //----> Imprime Mensagem de Observacao

nLin := 54
ClasFis()       //----> Imprime Classificacao Fiscal

//@ 56, 001 PSAY "ENTREGA" +SA1->A1_ENDCOB


/*
If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
@ 57, 002 PSAY "NOTA FISCAL ORIGINAL No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
Endif

If !Empty(xSuframa)
@ 58, 002 PSAY "SUFRAMA : "+xSuframa
EndIf
*/

@ 62, 126 PSAY xNUM_NF       // Numero da Nota Fiscal

@ 67, 002 PSAY xNOME_TRANSP
@ 67, 065 PSAY xNUM_NF

@ 68, 002 PSAY xNOME_CLI
@ 68, 065 PSAY dDataBase

@ 72, 000 PSAY chr(18)                                  // Descompressao de Impressao
@ 72, 132 PSAY ""

//If mv_par04==2
  //	Etiqueta()  //----> grava dados para etiqueta volumes
//EndIf

SetPrc(0,0)                                                  // (Zera o Formulario)
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
/*// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Etiqueta
Static Function Etiqueta()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cDir     := "\SYSTEM\ETIQUETA\"
_cFile    := "SZ7010.DBF"
_cIndice  := _cDir+"Z7"

DbUseArea(.T.,,_cDir+_cFile,"Z7",.F.,.F.)

DbSelectArea("Z7")
If !File(_cDir+"Z7.NTX")
	Index on Z7_DOC + Z7_SERIE to &_cIndice
EndIf

Set Index to &_cIndice

For i := 1 to xVOLUME
	DbSelectArea("Z7")
	RecLock("Z7",.t.)
	Z7->Z7_NPEDIDO   := xPED_VEND[1]
	Z7->Z7_SPEDIDO   := xPED_CLI[1]
	Z7->Z7_CLIENTE   := xNOME_CLI
	Z7->Z7_ENDCLI    := xEND_CLI
	Z7->Z7_CEP       := xCEP_CLI
	Z7->Z7_MUN       := xMUN_CLI
	Z7->Z7_UF        := xEST_CLI
	Z7->Z7_TRANSP    := xNOME_TRANSP
	Z7->Z7_VOLUME    := i
	Z7->Z7_ESPECIE   := xESPECIE
	Z7->Z7_DOC       := xNUM_NF
	Z7->Z7_SERIE     := xSERIE
	Z7->Z7_TOTVOL    := xVOLUME
	Z7->Z3_COPIAS    := 1
	MsUnLock()
Next

DbSelectArea("Z7")
DbCloseArea("Z7")

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
