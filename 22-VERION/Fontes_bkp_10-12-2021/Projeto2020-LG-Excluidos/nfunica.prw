#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 26/09/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function nfunica()        // incluido pelo assistente de conversao do AP6 IDE em 26/09/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,XDESCONTO,XBSICMRET,_NDESCCOML,_NTOTBRUTO")
SetPrvt("CALC1,CALC2,CALC3,CALC4,CALC5,CPEDATU")
SetPrvt("CITEMATU,XLOTE_CTL,XPED_VEND,XITEM_PED,XNUM_NFDV,XPREF_DV")
SetPrvt("XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI,XDESCITEM,XPRE_TAB")
SetPrvt("XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC,XTES")
SetPrvt("XCF,XICMSOL,XICM_PROD,XDESC_ZFR,_NREPASSE,_NDESC_C6")
SetPrvt("CFO2,FLAG_ICMS,XPESO_PRO,XPESO_UNIT,XDESCRICAO,XUNID_PRO")
SetPrvt("XCOD_TRIB,XMEN_TRIB,XCOD_FIS1,XCOD_FIS2,XCLAS_FIS,XMEN_POS")
SetPrvt("XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,_NPESO")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XCOD_MENS2")
SetPrvt("XCOD_MENS3,XCOD_MENS4,XMENSAGEM,XMENSAGEM2,XMENSAGEM3,XTPFRETE")
SetPrvt("XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI,XDESC_PRO")
SetPrvt("J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO,XCEP_CLI")
SetPrvt("XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI,XINSC_CLI")
SetPrvt("XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF,XFLAGBAS")
SetPrvt("XCIP153,XNCONTR,ZFRANCA,XVENDEDOR,XNOME_TRANSP,XEND_TRANSP")
SetPrvt("XMUN_TRANSP,XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP")
SetPrvt("XVENC_DUP,XVALOR_DUP,XDUPLICATAS,XNATUREZA,XDUPLIC_GERA,XFORNECE")
SetPrvt("XNFORI,XPEDIDO,XPESOPROD,XCOD_FIS,XFAX,NOPC")
SetPrvt("CCOR,NTAMDET,XB_ICMS_SOL,XV_ICMS_SOL,VLIN,NCONT")
SetPrvt("NCOL,XTOTMERC,NTAMOBS,NAJUSTE,CC,BB,XDESPESAS")
SetPrvt("C1,B1,VAR,_VERMENS,_CENT,XCLASFIS,XSITTRI")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Nfiscal ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Entrada/Saida                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
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
cDesc3 :=""
cNatureza:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="NFUNICA"
cPerg:="NFSIGW    "
nLastKey:= 0
lContinua := .T.
nLin:=0
wnrel    := "NFUNICA"
//nTipo := 15

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetDefault(aReturn,cString)

VerImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento da Nota Fiscal                       ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> 	RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> 	Function RptDetail
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
Endif

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
		
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		if xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		endif
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
		///      xDESCONTO   :=SF2->F2_DESCONT         // Valor do desconto Zona Franca....
		xBSICMRET   :=SF2->F2_BRICMS          // Base calculo ICMS Solid rio...
		_nDescCOML  :=0                       // Valor do desconto comercial.....
		_nTotBRUTO  :=0                       // Total bruto (a ser calculado)...
		CALC1       :=0                       // CALCULO TOTAL BRUTO NF
		CALC2       :=0
		CALC3       :=0
		CALC4       :=0
		CALC5       :=0
		xDESPESAS   :=SF2->F2_DESPESA         // OUTRAS DESPESAS
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		
		xLOTE_CTL:={}
		
		xPED_VEND:={}                         // Numero do Pedido de Venda
		xITEM_PED:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Venda
		xDESCITEM:={}                         // Desconto Unitario
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
		xDesc_zfr:={}
//		xDESPESAS :={}
		_nREPASSE:= 0                         // Valor do repasse total do item
		_nDESC_C6:= 0                         // Valor do desconto no SC6.
		CFO2     := ""
		
		while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xLOTE_CTL ,LEFT(SD2->D2_LOTECTL,5))
			
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV)
			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xPREF_DV  ,SD2->D2_SERIORI)
			AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			FLAG_ICMS   :=  IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM)     // FLAG DE ICMS
			AADD(xCOD_PRO  ,SD2->D2_COD)
			AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
			AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(xDescItem ,SD2->D2_DESCON)    /////  DESCONTO DO ITEM
			AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			AADD(xVAL_IPI  ,SD2->D2_VALIPI)
			//////////         AADD(xDESC     ,SD2->D2_DESC)
			AADD(xVAL_MERC ,SD2->D2_TOTAL)
			AADD(xTES      ,SD2->D2_TES)
			AADD(xCF       ,SD2->D2_CF)
/*			
			IF SD2->D2_TES == "503" .AND.  SD2->D2_CF == "513"
				CFO2 := "5.13/5.94"
			ENDIF
			
			IF SD2->D2_TES == "503" .AND.  SD2->D2_CF == "613"
				CFO2 :=  "6.13/6.94"
			ENDIF
*/			
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xDESC_ZFR ,SD2->D2_DESCZFR)
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO:={}                           // Peso Liquido
		xPESO_UNIT :={}                         // Peso Unitario do Produto
		xDESCRICAO :={}                         // Descricao do Produto
		xUNID_PRO:={}                           // Unidade do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS1:={}                           // ORIGEM DO PRODUTO
		xCOD_FIS2:={}                           // Situacao Tibutaria da Operacao
		xCLAS_FIS:={}                           // Classificacao Fiscal 
		xCLASFIS :={}
		xSITTRI :={}
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xCOD_FIS := {}
		xPESO_LIQ := 0
		_nPESO := SB1->B1_PESO
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
   			xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
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
            AADD(xCOD_FIS ,_CLASFIS)
            AADD(XCLASFIS,SB1->B1_CLASFIS)
			AADD(XCLFISCAL,SB1->B1_POSIPI)
			AADD(xCOD_FIS1,SB1->B1_ORIGEM)
			AADD(xSITTRI,SB1->B1_SITTRI)
/*
			DO CASE
				CASE SD2->D2_TES == "513"
		             AADD(xCOD_FIS2 ,"5")
			    CASE  SD2->D2_TES == "507"
			         AADD(xCOD_FIS2 ,"5")
				CASE  SD2->D2_TES == "503"
				     AADD(xCOD_FIS2 ,"5")
				CASE  SD2->D2_TES == "508"
				     AADD(xCOD_FIS2 ,"5")
				CASE FLAG_ICMS    == 0
				     AADD(xCOD_FIS2 ,"4")
				CASE xICMS_RET    #0
				     AADD(xCOD_FIS2 ,"1")
				CASE xICMS_RET    == 0
				     AADD(xCOD_FIS2 ,"0")
			EndCase
*/			
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			//
			// Calculo do Peso Liquido da Nota Fiscal
			//
			
			xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
			For I:=1 to Len(xPESO_PRO)
				xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[I]
			Next
			
		Next
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xPESO_BRUTO := 0
		xP_LIQ_PED  := 0
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial()+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				/////            xCOD_MENS2  :=SC5->C5_MENPAD2            // Codigo da Mensagem Padrao
				/////            xCOD_MENS3  :=SC5->C5_MENPAD3            // Codigo da Mensagem Padrao
				/////            xCOD_MENS4  :=SC5->C5_MENPAD4            // Codigo da Mensagem Padrao
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xMENSAGEM2  :=SC5->C5_MENNOT1            // Mensagem para a Nota Fiscal
				//            xMENSAGEM3  :=SC5->C5_MENNOT3            // Mensagem para a Nota Fiscal
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
				xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
				xCOD_VEND:=  {SC5->C5_VEND1,;               // Codigo do Vendedor 1
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
		dbSeek(xFilial("SE4")+xCONDPAG)
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
			AADD(xDESC    ,SC6->C6_DESCONT)
			_nREPASSE := _nREPASSE + (SC6->C6_DESCBEN * xQTD_PRO [I])
			_nDESC_C6 := _nDESC_C6 + SC6->C6_VALDESC
		Next
		_nREPASSE := ROUND(_nREPASSE,2)
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
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
			xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
//			xFlagbas :=SA1->A1_FLAGBAS            //  IMPRIME MENSAGEM DE REDUCAO DE BASE
//			xcip153  :=SA1->A1_CIP153            //  IMPRIME MENSAGEM DE REDUCAO DE BASE
//			xNCONTR  :=SA1->A1_NCONTR            //  IMPRIME MENSAGEM DE REDUCAO DE BASE
//			xCOD_MENS2:= SA1->A1_MENPAD2         // 2 MENSAGEM DO CLIENTE
			
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
			zFranca:=.F.
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
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
		//dbSeek(xFilial()+xCOD_VEND)
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		//If xICMS_RET >0                          // Apenas se ICMS Retido > 0
		//   dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
		//   dbSetOrder(4)
		//   dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
		//   If Found()
		//      xBSICMRET:=F3_VALOBSE
		//   Else
		//      xBSICMRET:=0
		//   Endif
		//Else
		//   xBSICMRET:=0
		//Endif
		
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
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
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
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		xDUPLIC_GERA := SF4->F4_DUPLIC        // GERA DUPLICATA ?
		
		Imprime()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Termino da Impressao da Nota Fiscal                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
Else
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
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
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Compra
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
		
		while !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
			AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      ,SD1->D1_IPI)            // % IPI
			AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
			AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
			AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			**         AADD(xICM_PROD ,SD1->D1_PICM)
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO:={}                           // Unidade do Produto
		xDESC_PRO:={}                           // Descricao do Produto
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xDESCRICAO :={}                         // Descricao do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL:={}
		xSITTRI  :={}
		xSUFRAMA :=""
		xCALCSUF :=""
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
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
			EndCase
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0
			   AADD(xCLFISCAL,_CLASFIS)
			Endif
			
			AADD(xCLASFIS,SB1->B1_CLASFIS)
			AADD(XCLFISCAL,SB1->B1_POSIPI)
			AADD(xCOD_FIS1 ,SB1->B1_ORIGEM)
			AADD(xSITTRI,SB1->B1_SITTRI)
/*			DO CASE
				CASE SD2->D2_TES == "513"
					AADD(xCOD_FIS2 ,"5")
					
				CASE  SD2->D2_TES == "507"
					AADD(xCOD_FIS2 ,"5")
					
				CASE  SD2->D2_TES == "503"
					AADD(xCOD_FIS2 ,"5")
					
				CASE  SD2->D2_TES == "508"
					AADD(xCOD_FIS2 ,"5")
					
				CASE FLAG_ICMS    == 0
					AADD(xCOD_FIS2 ,"4")
					
				CASE xICMS_RET    #0
					AADD(xCOD_FIS2 ,"1")
					
				CASE xICMS_RET    == 0
					AADD(xCOD_FIS2 ,"0")
					
			EndCase
*/			
		NEXT
		
		If SB1->B1_ALIQISS > 0
			AADD(xISS ,SB1->B1_ALIQISS)
		Endif
		AADD(xTIPO_PRO ,SB1->B1_TIPO)
		AADD(xLUCRO    ,SB1->B1_PICMRET)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa da Condicao de Pagto               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO == "D"
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE)
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
//			xCOD_MENS2:= SA1->A1_MENPAD2       // 2 MENSAGEM DO CLIENTE
			
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
		dbSeek(xFilial()+SD1->D1_TES)
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		xNOME_TRANSP :=" "           // Nome Transportadora
		xEND_TRANSP  :=" "           // Endereco
		xMUN_TRANSP  :=" "           // Municipio
		xEST_TRANSP  :=" "           // Estado
		xVIA_TRANSP  :=" "           // Via de Transporte
		xCGC_TRANSP  :=" "           // CGC
		xTEL_TRANSP  :=" "           // Fone
		xTPFRETE     :=" "           // Tipo de Frete
		xVOLUME      := 0            // Volume
		xESPECIE     :=" "           // Especie
		xPESO_LIQ    := 0            // Peso Liquido
		xPESO_BRUTO  := 0            // Peso Bruto
		xCOD_MENS    :=" "           // Codigo da Mensagem
		//      xCOD_MENS2   :=" "           // Codigo da Mensagem
		//      xCOD_MENS3   :=" "           // Codigo da Mensagem
		//      xCOD_MENS4   :=" "           // Codigo da Mensagem
		xMENSAGEM    :=" "           // Mensagem da Nota
		xMENSAGEM2   :=" "           // Mensagem da Nota
		///      xMENSAGEM3   :=" "           // Mensagem da Nota
		xPESO_LIQUID :=" "
		
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

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen
dbCommitAll()
If aReturn[5] == 1
	Set Printer TO
//	dbcommitAll()
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

// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> Function VerImp
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
		NLIN:= 1
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
				Return
		EndCase
	End
Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ E   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
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

// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> Function IMPDET
Static Function IMPDET()

nTamDet   :=16            // Tamanho da Area de Detalhe
xDESCONTO := 0

I:=1
J:=1

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

For I:=1 to nTamDet
	
	@ nLin, 00 PSAY chr(15)
	
	If I<= Len(xCOD_PRO)
//	    @ nLin, 00 PSAY chr(15)
		@ nLin,  01  PSAY xCOD_PRO[I]
	    @ nLin,  11  PSAY xPESO_PRO[I]              Picture "@E 999.999"
//		@ nLin,  11  PSAY xLOTE_CTL[I]
		@ nLin,  15  PSAY xDESC_PRO[I]
		@ nLin,  63  PSAY xCLASFIS[I]
		@ nLin,  67  PSAY xSITTRI[I]
//		@ nLin,  65  PSAY XCLFISCAL[I]
//		@ nLin, 070  PSAY XCOD_FIS1[I]
//		@ nLin, 071  PSAY XCOD_FIS2[I]
		@ nLin, 071  PSAY xUNID_PRO[I]
		@ nLin, 074  PSAY xQTD_PRO[I] Picture"@E 999999"
		If mv_par04 == 2
			@ nLin, 084  PSAY xPRE_TAB[I]               Picture"@E 99,999,999.99"
			CALC1 := xQTD_PRO[I] * xPRE_TAB[I]
			CALC2 := CALC1 + CALC2
		else
			@ nLin, 084  PSAY xPRE_UNI[I]               Picture"@E 99,999,999.99"
			CALC1 := xQTD_PRO[I] * xPRE_TAB[I]
			CALC2 := CALC1 + CALC2
		EndIf
//		@ nLin, 108  PSAY xDesc[I]                  Picture"@E 99.99"
//		xDESCONTO := xDESCONTO + xDESC_ZFR[I]             ///  ACUMULA TOTAL DESCONTO ZONA FRANCA
		If zFranca
			@ nLin, 100  PSAY xVAL_MERC[I] + xDESC_ZFR[I] Picture"@E 999,999,999.99"  // Valor Tot. Prod.
		Else
			@ nLin, 100  PSAY NOROUND(xVAL_MERC[I],3) Picture"@E 999,999,999.99"  // Valor Tot. Prod.
		EndIf
				
		//    @ nLin, 117  PSAY xVAL_MERC[I]              Picture"@E 99,999,999.99"
		IF !ZFRANCA
			@ nLin, 117 PSAY xICM_PROD[I]              Picture"99"
		ENDIF
		@ nLin, 121  PSAY xIPI[I]                   Picture"99"
		@ nLin, 123  PSAY xVAL_IPI[I]               Picture"@E 9,999,999.99"
		J:=J+1
		
		vLin := nLin
	Endif
	@ nLin, 124 PSAY chr(18)
	nLin :=nLin+1
	
Next I
VLIN := VLIN + 1
Return

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

// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> Function CLASFIS
Static Function CLASFIS()

Local nLen := Len(xCLFISCAL)

If nLen > 16
   nLen := 16
Endif

//@ nLin,006 PSAY "Classificacao Fiscal"
//nLin := nLin + 1 
/*For nCont := 1 to nLen
    if nCont <= nlen .and. xCLAS_FIS[nCont] <> ""
	nCol := If(Mod(nCont,2) != 0, 06, 33)
	@ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
    @ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.999")
	nLin := nLin + If(Mod(nCont,2) != 0, 0, 1) 
	endif                                                        
*/	
	For nCont := 1 to nLen
  	    nCol := If(Mod(nCont,2) != 0, 06, 33)
   	    @ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
   		@ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
   		nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
	Next

	
//Next nCont

Return

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

// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> Function IMPMENP
Static Function IMPMENP()

nCol:= 25

If !Empty(xCOD_MENS)
	
	@ nLin, NCol PSAY  FORMULA(xCOD_MENS)
	
Endif

nLin:= nLin +1

mensobs()


Return

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

// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> Function MENSOBS
Static Function MENSOBS()

xTotMerc := xVALOR_MERC + xDesconto ///// valor total da mercadoria para zona franca de manaus

nTamObs:=068
nCol:=05

IF ZFRANCA
	@ nLin, nCol PSAY "* mercadorias nao serao REDESPACHADAS * Total Mercadorias : "
	@ nLin, 067  PSAY xTotmerc
	nLin := nLin + 1
	@ nLin, nCol PSAY "* ----------------------------------- * Desc.Ref 7% de ICM: "
	@ nLin, 067  PSAY +xDesconto
else
	@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
	nlin:=nlin+1
	@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,69,nTamObs))
    nlin:=nlin+1 
    @ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,132,nTamObs))
endIf

Return

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

// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> Function DUPLIC
Static Function DUPLIC()
/*
nCol := 7
nAjuste := 0
CC:=-8
IF (LEN(xVALOR_DUP)) > 1
	
	For BB:= 1 to Len(xVALOR_DUP)
		If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
			//      @ nLin, 11  psay xPED_VEND[BB]
			CC:= CC + 12
			@ nLin, CC  PSAY " DUP:   "
			CC:= CC+7
			@ nLin, CC  PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]
			CC:=CC+9
			@ nLin, CC  PSAY xVENC_DUP[BB]
			CC:= CC + 7
			@ NLIN, CC  PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
			CC:=CC+1
			nAjuste := nAjuste + 50
		Endif
	Next
EndIf
*/
For BB:= 1 to Len(xVALOR_DUP)
   
   IF BB > 3
      EXIT
   ENDIF
   
   DO CASE
      CASE BB == 1
           ncol := 04
           ncol1 := 22
      CASE BB == 2
           ncol := 40
           ncol1 := 59

      CASE BB == 3
           ncol := 74
           ncol1 := 94
      OTHERWISE
           ncol := 107
           ncol1 := 124
      
   ENDCASE
   
   If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
   
   //   @ nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]

      @ nLin, ncol  PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
      @ nLin, ncol1 PSAY xVENC_DUP[BB]
        
   Endif
Next

Return

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
// Substituido pelo assistente de conversao do AP6 IDE em 26/09/05 ==> Function Imprime
Static Function Imprime()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³              IMPRESSAO DA N.F. DA Nfiscal                    ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho da N.F.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SetPrc(0,0)
//dbCommitAll()

//@ 01, 000 PSAY Chr(15)                // Compressao de Impressao

@ 01, 118 PSAY xNUM_NF               // Numero da Nota Fiscal

If mv_par04 == 1
	@ 02, 068 PSAY "X"
Else
	@ 02, 083 PSAY "X"
Endif

@ 06, 001 PSAY xNATUREZA               // Texto da Natureza de Operacao

IF LEN(CFO2) == 0
	@ 06, 036 PSAY xCF[1] Picture"@R 9.999" // Codigo da Natureza de Operacao
ENDIF

//IF LEN(CFO2) #0
//	@ 06, 050 PSAY CFO2       // Codigo da Natureza de Operacao
//ENDIF
/*
IF xEST_CLI == "AP"
	@ 10,60 PSAY "03-016623-9"
ENDIF
IF xEST_CLI == "BA"
	@ 10,60 PSAY "38.063.578EP"
ENDIF
IF xEST_CLI == "CE"
	@ 10,60 PSAY "06.954.795-5"
ENDIF
IF xEST_CLI == "GO"
	@ 10,60 PSAY "10.263896.9"
ENDIF
IF xEST_CLI == "MG"
	@ 10,60 PSAY "503.772.724-0032"
ENDIF
IF xEST_CLI == "PA"
	@ 10,60 PSAY "15.165.876-5"
ENDIF
IF xEST_CLI == "PB"
	@ 10,60 PSAY "16.999.754-5"
ENDIF
IF xEST_CLI == "PE"
	@ 10,60 PSAY "18.8.962.0186591-5"
ENDIF
IF xEST_CLI == "PR"
	@ 10,60 PSAY "099.00433-96"
ENDIF
IF xEST_CLI == "RJ"
	@ 10,60 PSAY "91.001.780"
ENDIF
IF xEST_CLI == "RS"
	@ 10,60 PSAY "096/2370568-RS"
ENDIF
IF xEST_CLI == "SC"
	@ 10,60 PSAY "251.285.081-SC"
ENDIF

//IF xCF[1] == "599" .OR. xCF[1] == "699" .OR. xCF[1] == "513"
//	// NAO IMPRIME NADA
//ELSE
//	@ 11,28 PSAY "ATENDENDO PORTARIA 2814/98 DE 29/05/98 DO M.S. A EMPRESA ABAIXO"
//	@ 11,92 PSAY "ESTA AUTORIZADA A COMERCIALIZAR OS LOTES DOS PRODS. CONSTANTES DESTA."
//ENDIF
//
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao dos Dados do Cliente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 10, 001 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 10, 078 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
Else
	@ 10, 078 PSAY " "                // Caso seja vazio
Endif

@ 10, 115 PSAY xEMISSAO              // Data da Emissao do Documento
@ 12, 001 PSAY xEND_CLI                                 // Endereco
@ 12, 067 PSAY xBAIRRO                                  // Bairro
@ 12, 098 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 12, 115 PSAY " "                                      // Reservado  p/Data Saida/Entrada
@ 14, 001 PSAY xMUN_CLI                               // Municipio
@ 14, 050 PSAY xTEL_CLI                               // Telefone/FAX
@ 14, 068 PSAY xEST_CLI                               // U.F.
IF !EMPTY(xINSC_CLI)
	@ 14, 078 PSAY xINSC_CLI                              // Insc. Estadual
ELSE
	@ 14, 078 PSAY "ISENTO"
ENDIF
@ 14, 112 PSAY " "                                    // Reservado p/Hora da Saida
//@ 21, 001   PSAY XNUM_NF                                 // Numero da Fatura
@ 16, 010  PSAY XTOT_FAT                                 // TOTAL da Fatura
//@ 21, 080  PSAY XNUM_NF

C1 := 05

For B1:= 1 to Len(xVALOR_DUP)
	
	@ 16, C1  PSAY XPARC_DUP[B1]+"/"
	//@ 17, 86  PSAY  "/" + XPARC_DUP[B1]
	//@ 17, 88  PSAY  "/" + XPARC_DUP[B1]
	//@ 17, 90  PSAY  "/" + XPARC_DUP[4]
	C1 := C1+2
	
NEXT

// PARCELAS da Fatura
IF XDUPLIC_GERA == "S" .AND. B1 == 1
	@ 16, 030  PSAY XVENC_DUP[1]
EndIf

IF XDUPLIC_GERA == "S"  .AND.  B1 > 1
	@ 16, 025  PSAY "DESDOBRAMENTO"
EndIf

IF XDUPLIC_GERA == "N"
	@ 16, 025  PSAY "SEM DEBITO"
EndIf
// @ 22,11 PSAY "******"
// @ 23,12 PSAY "LOTE"

//If mv_par04 == 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Fatura/Duplicata       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//   nLin:=19
//   BB:=1
//   nCol := 10             //  duplicatas
//

//Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados dos Produtos Vendidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := 22
ImpDet()                 // Detalhe da NF

nLin := 42

If mv_par04 == 2 .and. Len(xISS) == 0
	
	// Calculo do valor bruto da Nota Fiscal, considerando-se o valor
	// dado como repasse no pedido de vendas, eventual desconto suframa e
	// descontos financeiros e impressÆo de mensagens espec¡ficas...
	
	_nTotBRUTO := xVALOR_MERC + xDESCONTO + _nDesc_C6    // Valor Bruto da NF
	// _nREPASSE == valor total do repasse (pelo pedido)
	//  _nDescCOML := _nTotBRUTO - xDESCONTO - _nREPASSE - xVALOR_MERC
	_nDescCOML := CALC2 - _nREPASSE - xVALOR_MERC - xDESCONTO
	//   @ vLin,21 PSAY "Preco total " + Transform(_nTotBruto,"@E@Z 999,999,999.9999") + ;
	
	//     IF _nDescCOML < 0 .OR. _nDescCOML == 0
/*	
	if _nDescCOML < 1
		If _nREPASSE == 0 .OR. _nREPASSE < 0
			@ vLin, 21 PSAY "PRECO TOTAL "
			@ vLin, 33 PSAY xVALOR_MERC   Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
			
			//           @ vLin,21 PSAY "Preco total " + Transform(CALC3,"@E@Z 999,999,999.99")
		ELSE
			@ vLin,21 PSAY "Preco total " + Transform(CALC2,"@E@Z 999,999,999.99")
			If zFranca
				CALC5 := xVALOR_MER+xDESCONTO
				//             @ 42, 128  PSAY xVALOR_MERC+xDESCONTO Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
			Else
				CALC5 := xVALOR_MERC
				//             @ 42, 128  PSAY xVALOR_MERC Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
			EndIf
			CALC4 := CALC2 - CALC5
			@ vLin,49 PSAY " - Repasse " + Transform(CALC4,"@E@Z 99,999.99")
		ENDIF
	ELSE
		//        if _nDescCOML == 0,01
		//           VAR := _nDescCOML
		//           _nDescCOML := 0
		//        ENDIF
		
		@ vLin,21 PSAY "Preco total " + Transform(CALC2,"@E@Z 999,999,999.99")
		@ vLin,49 PSAY " - Repasse " + Transform(_nREPASSE,"@E@Z 99,999.99")
		@ vLin,70 PSAY " - Desconto " + Transform(_nDescCOML,"@E@Z 99,999.99")
	ENDIF
*/	
	///  nLin:=33
	///  MensObs()             // Imprime Mensagem de Observacao
	
//	If mv_par04 == 2
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao da Fatura/Duplicata       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
//		nLin:=42
//		BB:=1
//		nCol := 10             //  duplicatas
//		DUPLIC()
//		
//	Endif
	
//	nLin:=42
//	ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prestacao de Servicos Prestados     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//If Len(xISS) > 0
	
	//   nLin := 40
	//   Impmenp()
	
//	nLin :=42
//	MensObs()
	
//	nLin := nLin + 1
//	NCol := 25
	
	//  @ 44, 142  PSAY xTOT_FAT  Picture"@E@Z 999,999,999.99"   // Valor do Servico
//Endif

_VerMens  := ""
/*
*** If !Empty(xCOD_MENS2)
***	
***	_VerMens  :=  formula(XCOD_MENS2)
***	
***	nLin := nLin +1
***	@ nLin, 025 PSAY  _VerMens
***	
*** Endif
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo dos Impostos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// ESTA ACONTECENDO DIFERENCAS NOS CENTAVOS, DA  BASE DE ICMS
// COM O VALOR DAS MERCADORIAS.

_CENT := xVALOR_MERC - xBASE_ICMS

IF _CENT < 0.50
	@ 45, 002  PSAY xVALOR_MERC  Picture"@E@Z 999,999,999.99"   // Base do ICMS
ELSE
	@ 45, 002  PSAY xBASE_ICMS  Picture"@E@Z 999,999,999.99"   // Base do ICMS
ENDIF
_CENT :=0
///  APENAS NOS CENTAVOS

@ 45, 020  PSAY xVALOR_ICMS Picture"@E@Z 999,999,999.99"  // Valor do ICMS
@ 45, 040  PSAY xBSICMRET   Picture"@E@Z 999,999,999.99"  // Base ICMS Ret.
@ 45, 055  PSAY xICMS_RET   Picture"@E@Z 999,999,999.99"  // Valor  ICMS Ret.
If zFranca
	@ 45, 065  PSAY xVALOR_MERC+xDESCONTO Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
Else
	//     IF VAR == "0,01"
	//        VAR := CALC2 + VAR
	//        @ 42, 128  PSAY VAR Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
	//     ELSE
	@ 45, 100  PSAY xVALOR_MERC Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
	//     ENDIF
EndIf
@ 46, 002  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
@ 46, 020  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
@ 46, 040  PSAY xDESPESAS   Picture "@E@Z 999,999,999.99"  // Outras Despesas Acessorias
@ 46, 060  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI

IF ZFRANCA
	@ 46, 100  PSAY xVALOR_MERC   Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
Else
	//     IF VAR == "0,01"
	//        VAR := CALC2 + VAR
	//        @ 44, 128  PSAY VAR Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
	//     ELSE
	@ 46, 100  PSAY xTOT_FAT      Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
	//     ENDIF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao Dados da Transportadora  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 49, 002  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 49, 071 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 49, 071 PSAY "2"                              // Destinatario (2)
Endif

// @ 47, 078 PSAY " "                                  // Res. p/Placa do Veiculo
// @ 47, 080 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 49, 100 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 49, 100 PSAY " "                               // Caso seja vazio
Endif

@ 51, 002 PSAY xEND_TRANSP                          // Endereco Transp.
@ 51, 065 PSAY xMUN_TRANSP                          // Municipio
@ 51, 090 PSAY xEST_TRANSP                          // U.F.
@ 51, 100 PSAY " "                                  // Reservado p/Insc. Estad.

@ 53, 002 PSAY xVOLUME  Picture"@E@Z 999,999.999"             // Quant. Volumes
@ 53, 026 PSAY xESPECIE Picture"@!"                          // Especie
// @ 51, 052 PSAY " "                                           // Res para Marca
// @ 51, 075 PSAY " "                                           // Res para Numero
@ 53, 059 PSAY xPESO_BRUTO     Picture"@E@Z 99,999.999"      // Res para Peso Bruto
@ 53, 070 PSAY xPESO_LIQUID    Picture"@E@Z 99,999.999"      // Res para Peso Liquido
/*
*** @ 52,025 SAY "(*) PORTARIA No. 27 DE 24 DE OUTUBRO DE 1986"
*** @ 52,075 SAY "(**) PORTARIA No. 28 DE 13 DE NOVEMBRO DE 1986"
*/
@ 57, 025 PSAY "NUM.PED. "+xPED_VEND[1]
@ 57, 042 PSAY "COD.VEN. "+xCOD_VEND
//@ 54, 030 PSAY xCLIENTE
//** @ 54, 098 PSAY "CODIGO DO POSTO FISCAL - PFC 430"
//If mv_par04 == 2
//nLin := 59
//
nLin := 58
//
//Clasfis()               // Impressao de Classif. Fiscal
//
//Endif

ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal

nLin := 60

Clasfis()

nLin:= 62

If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
	@ nLin, 025 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
	nLin:= nLin+1
Endif

If !Empty(xSuframa)  .AND. xDuplic_Gera == "S"
	@ nLin, 025 PSAY "CODIGO DA REP.FISCAL - 010.010.43  ***  SUFRAMA  -  "  + xSuframa
	nLin:= nLin+1
EndIf

/// If  xCip153 #"N" .and. _nrepasse # 0  .and. xNcontr # "N"   ////xICMS_RET == 0

/* If xCip153 #"N" .AND. xDuplic_Gera == "S"
***	@ nLin, 24 PSAY "Valor liquido ja deduzido conf. resol. CIP.NR.153 de 25/02/81"
***	nLin:= nLin+1
*** Endif
/////   00002 - POTIGUARES

//// If Xflagbas #"N"  .and. xEst_Cli # "PA" .and. xICMS_RET # 0 .and. xNcontr # "N" .AND. xDuplic_Gera == "S"
 IF xFLAGBAS #"N" .AND. xDuplic_Gera == "S"
 	@ nLin, 24 PSAY "Reducao da base de calculo-comunicado CAT 32/95"
	nLin:= nLin+1
 Endif
//// If xCod_Cli == "00045" .and. xNcontr #"N"
////    @ 55,24 PSAY "base de calculo da subst.trib.conf.termo acordo-parecer No.192/96"
////    @ 56,24 PSAY "ICMS retido conf.termo de acordo parecer No. 192/96"
////    @ 57,24 PSAY "CT da secretaria de trib. do Rio Grande do Norte"
//// Endif
 If xEst_CLi == "PA" .and. xICMS_RET #0  .and. xNcontr # "N" .AND. xDuplic_Gera == "S"
    @ nLin, 24 PSAY "Reducao da base de calculo da subst.trib.decr.n.1541 de 31/07/96 - PA"
	nLin:= nLin+1
 Endif
*/

@ 66, 075 PSAY xNUM_NF                   // Numero da Nota Fiscal

NLIN := 67

// @ NLIN, 000 PSAY chr(18)                   // Descompressao de Impressao

//dbcommitAll()

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.

