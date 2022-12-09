#include "rwmake.ch"

User Function NFCODAY2()

SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,CSTRING,NLININI,XTRANS_INS")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT,XPESO_PROB")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,XPESO_BRU")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED,XPESO_BRUTO")
SetPrvt("XP_LIQ_PED,xP_BRU_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI,XREC_MUN")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF,XREC_EST")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL,XREC_CGC,XREC_INS")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,XCOD_REF")
SetPrvt("xBASCALICM")//Claudio
SetPrvt("xCLASFIS") //Amedeo
Private _cMenSA1 := ""


/*/
+-------------------------------------------------------------------------+
+ Programa : Nfcoday   Autora :  Rosane Rodrigues   Data :  21/08/02      +
+-------------------------------------------------------------------------+
+ Descricao : Nota Fiscal de Entrada/Saida - Empresa Coday                +
+-------------------------------------------------------------------------+
/*/
//+-------------------------------------------------------------+
//+ Define Variaveis Ambientais                                 +
//+-------------------------------------------------------------+
//+-------------------------------------------------------------+
//+ Variaveis utilizadas para parametros                        +
//+ mv_par01             // Da Nota Fiscal                      +
//+ mv_par02             // Ate a Nota Fiscal                   +
//+ mv_par03             // Da Serie                            +
//+ mv_par04             // Nota Fiscal de Entrada/Saida        +
//+-------------------------------------------------------------+

tamanho   := "G"
limite    := 220
titulo    := PADC("Nota Fiscal - Nfcoday2",74)
cDesc1    := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2    := PADC("para a Empresa Coday",74)
cDesc3    := ""
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "nfcoday2"
cPerg     := "NFSIGW    "
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "nfcoday"

//+-------------------------------------------------------------------------+
//+ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           +
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString := "SF2"

//+--------------------------------------------------------------+
//+ Envia controle para a funcao SETPRINT                        +
//+--------------------------------------------------------------+

wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//+ Verifica Posicao do Formulario na Impressora                 +
//+--------------------------------------------------------------+

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

//+--------------------------------------------------------------+
//+ Inicio do Processamento da Nota Fiscal                       +
//+--------------------------------------------------------------+


RptStatus({|| RptDetail()})
Return

Static Function RptDetail()

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial("SF2")+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+mv_par01+mv_par03)
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

//+-----------------------------------------------------------+
//+ Inicializa  regua de impressao                            +
//+-----------------------------------------------------------+

SetRegua(Val(mv_par01)-Val(mv_par02))
If mv_par04 == 2
	
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC >= mv_par01 .and. SF2->F2_DOC <= mv_par02;
		.and. lContinua
		
		If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		
		nLinIni := nLin                         // Linha Inicial da Impressao
		
		//+--------------------------------------------------------------+
		//+ Inicio de Levantamento dos Dados da Nota Fiscal              +
		//+--------------------------------------------------------------+
		
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
		xBASCALICM	:=SF2->F2_BRICMS	      // Base Calculo ICMS substituicao// Criada por claudio 230709 
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
		
		cPedAtu := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		
		xPED_VEND:={}                         // Numero do Pedido de Venda
		xITEM_PED:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xCOD_REF :={}                         // Codigo  de Referencia
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
		xSITTRIB :={}                         // Situacao Tributaria //Amedeo
		
		while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV)
			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xPREF_DV  ,SD2->D2_SERIORI)
			AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xCOD_PRO  ,SD2->D2_COD)
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
			
			_cTes := Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"SF4->F4_SITTRIB") //Amedeo
			AADD(xSITTRIB  ,_cTes) //Amedeo (Pego Situacao da NF)
			
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO:={}                           // Peso Liquido
		xPESO_PROB:={}                          // Peso Bruto
		xPESO_UNIT :={}                         // Peso Unitario do Produto
		xDESCRICAO :={}                         // Descricao do Produto
		xUNID_PRO:={}                           // Unidade do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		//xPESO_LIQ := 0
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
			//AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			//AADD(xPESO_PROB,SB1->B1_PESBRU * xQTD_PRO[I])
			//xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			AADD(xCOD_REF ,SB1->B1_REFEREN)
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			//			if npElem == 0
			AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			//			endif
			
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
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			
			//
			// Calculo do Peso Liquido da Nota Fiscal
			//
			/*
			xPESO_BRUTO := 0
			xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
			For j:=1 to Len(xPESO_PRO)
			xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
			Next
			
			For j:=1 to Len(xPESO_PROB)
			xPESO_BRUTO :=xPESO_BRUTO+xPESO_PROB[j]      // Peso Bruto
			Next
			*/
			
		Next
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xP_LIQ_PED  := 0
		xP_BRU_PED	:= 0
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial("SC5")+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial("SC5")+xPED_VEND[I])
				xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xP_LIQ_PED  := xP_LIQ_PED + SC5->C5_PESOL 	// Peso Liquido
				xP_BRU_PED	:= xP_BRU_PED + SC5->C5_PBRUTO	// PESO BRUTO
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
			
			If xP_LIQ_PED > 0
				xPESO_LIQ := xP_LIQ_PED
			Endif
			
			If xP_BRU_PED > 0
				xPESO_BRU := xP_BRU_PED
			Endif
			
		Next
		
		//+---------------------------------------------+
		//+ Pesquisa da Condicao de Pagto               +
		//+---------------------------------------------+
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		xPED_CLI :={}                          // Numero de Pedido
		xDESC_PRO:={}
		J:=Len(xPED_VEND)
		For I:=1 to J
			dbSeek(xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I])
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,SC6->C6_DESCRI)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
		Next
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
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
			xREC_MUN :=SA1->A1_MUNE            // Municipio de Entrega
			xREC_EST :=SA1->A1_ESTE            // Estado de Entrega
			xREC_CGC :=SA1->A1_CGCENT          // CGC de Entrega
			xREC_INS :=SA1->A1_INSCENT         // Inscricao de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
			_cMenSA1 :=SA1->A1_MENSAGE   // Mensagem padrao do cliente
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
			dbSeek(xFilial("SA2")+xCLIENTE+xLOJA)
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_CLI :=""                      // Endereco de Entrega
			xREC_MUN :=""                      // Municipio de Entrega
			xREC_EST :=""                      // Estado de Entrega
			xREC_CGC :=""                      // CGC de Entrega
			xREC_INS :=""                      // Inscricao de Entrega
			xMUN_CLI :=SA2->A2_MUN             // Municipio
			xEST_CLI :=SA2->A2_EST             // Estado
			xCGC_CLI :=SA2->A2_CGC             // CGC
			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
			_cMenSA1 :=""
			
		Endif
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial("SA3")+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial("SF4")+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
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
		dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		xTRANS_INS   :=SA4->A4_INSEST         // Inscricao Estadual
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
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
		dbSeek(xFilial("SF4")+xTES[1])
		xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao
	
		Imprime()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
Else
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC >= mv_par01 .and. SF1->F1_DOC <= MV_PAR02;
		.and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		//+-----------------------------------------------------------+
		//¦ Inicializa  regua de impressao                            ¦
		//+-----------------------------------------------------------+
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
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
		xNFORI      :=SF1->F1_NFORIG           // NF Original
		xPREF_DV    := SF1->F1_SERORIG
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xCOD_REF :={}
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
		xCLFISCAL   :={}
		xSUFRAMA :=""
		xCALCSUF :=""
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
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
			AADD(xCOD_REF  ,SB1->B1_REFEREN)
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			//	if npElem == 0
			AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			//	endif
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
			AADD(xCOD_FIS ,_CLASFIS)
			
		Next
		
		//+---------------------------------------------+
		//¦ Pesquisa da Condicao de Pagto               ¦
		//+---------------------------------------------+
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO == "D"
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+xFORNECE)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xREC_CGC :=SA1->A1_CGCENT          // CGC de Entrega
			xREC_INS :=SA1->A1_INSCENT         // Inscricao de Entrega
			xREC_MUN :=SA1->A1_MUNE            // Municipio de Entrega
			xREC_EST :=SA1->A1_ESTE            // Estado de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			_cMenSA1 :=SA1->A1_MENSAGE   // Mensagem padrao do cliente
			
			
		Else
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+xFORNECE+xLOJA)
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			xEND_CLI :=SA2->A2_END                // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
			xCEP_CLI :=SA2->A2_CEP                // CEP
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xREC_MUN :=""                         // Municipio de Entrega
			xREC_EST :=""                         // Estado de Entrega
			xREC_CGC :=""                         // CGC de Entrega
			xREC_INS :=""                         // Inscricao de Entrega
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			_cMenSA1 :=""
			
		EndIf
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+SD1->D1_TES)
		xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao
		
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
		//xPESO_LIQ    := 0            // Peso Liquido
		xCOD_MENS    :=" "           // Codigo da Mensagem
		xMENSAGEM    :=" "           // Mensagem da Nota
		xPESO_LIQUID := 0
		//xPESO_BRUTO  := 0            // Peso Bruto
		
		Imprime()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

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
//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+

// VERIMP

Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc       := 1
	
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		IF MsgYesNo("Fomulario esta posicionado ? ")
			nOpc := 1
		ElseIF MsgYesNo("Tenta Novamente ? ")
			nOpc := 2
		Else
			nOpc := 3
		Endif
		
		
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

//
Static Function IMPDET()

nTamDet := 30           // Tamanho da Area de Detalhe

I:=1
J:=1

xB_ICMS_SOL := 0          // Base  do ICMS Solidario
xV_ICMS_SOL := 0          // Valor do ICMS Solidario

For I:=1 to nTamDet
	
	If I<= Len(xCOD_PRO)
		@ nLin, 000  PSAY Substr(xCOD_PRO[I],1,6)+"/"+xCOD_REF[I]
		@ nLin, 022  PSAY xDESCRICAO[I]
		@ nLin, 099  PSAY xCLAS_FIS[I]
		@ nLin, 114  PSAY xCOD_TRIB[I]+xSITTRIB[I] //Amedeo Origem + SitTrib
		@ nLin, 119  PSAY xUNID_PRO[I]
		@ nLin, 125  PSAY xQTD_PRO[I]               Picture "@E 99,999.99"
		@ nLin, 142  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99"
		@ nLin, 172  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
		@ nLin, 194  PSAY xICM_PROD[I]              Picture  "99"
		@ nLin, 203  PSAY xIPI[I]                   Picture "99"
		@ nLin, 213  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
		J:=J+1
	Endif
	nLin :=nLin+1
	
Next

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ CLASFIS  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 16/11/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Array com as Classificacoes Fiscais           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function CLASFIS()

Local nLen := Len(xCLFISCAL)

@ nLin,006 PSAY "Classificacao Fiscal"
nLin := nLin + 1

If nLen > 12
	nLen := 12
Endif

For nCont := 1 to nLen
	nCol := If(Mod(nCont,2) != 0, 06, 33)
	@ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
	@ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
	nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return


/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPMENP  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem Padrao da Nota Fiscal                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

Static Function IMPMENP()

nCol:= 05

If !Empty(xCOD_MENS)
	
	@ nLin, NCol PSAY FORMULA(xCOD_MENS)
	
Endif

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MENSOBS  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem no Campo Observacao                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

Static Function MENSOBS()

nTamObs:=150
nCol:=05
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,151,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,301,nTamObs))
Return


// FUNCAO DUPLIC()
Static Function DUPLIC()
nCol := 42
nAjuste := 0

For BB:= 1 to Len(xVALOR_DUP)
	If BB > 3
		Exit
	EndIF
	If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
		@ nLin, 045 PSAY xNUM_DUPLIC
		If XCONDPAG="002"
			@ nLin, 057 PSAY "C. APRES."
		Else
			@ nLin, 057 PSAY xVENC_DUP[BB]
		Endif
		@ nLin, 069 PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
		If (BB + 3) <= Len(xVALOR_DUP)
			@ nLin, 092 PSAY xNUM_DUPLIC
			If xCONDPAG ="002"
				@ nLin, 106 PSAY  "C. APRES."
			Else
				@ nLin, 106 PSAY xVENC_DUP[BB + 3]
			Endif
			@ nLin, 120 PSAY xVALOR_DUP[BB + 3] Picture("@E 9,999,999.99")
		EndIF
		nLin++
	Endif
Next

Return

//IMPRIME
Static Function Imprime()
//+--------------------------------------------------------------+
//¦              IMPRESSAO DA N.F. DA Nfiscal                    ¦
//+--------------------------------------------------------------+

//+-------------------------------------+
//¦ Impressao do Cabecalho da N.F.      ¦
//+-------------------------------------+

@ 01, 000 PSAY Chr(18)                // Descompressao de Impressao

If mv_par04 == 1
	@ 01, 112 PSAY "X"	// col 114
Else
	@ 01, 102 PSAY "X"	// col 104
Endif

@ 02, 126 PSAY xNUM_NF               // Numero da Nota Fiscal

@ 05, 000 PSAY Chr(15)                // Compressao de Impressao

@ 05, 008 PSAY XREC_CLI             // Endereco de Entrega
@ 05, 060 PSAY XREC_EST             // Estado de Entrega
@ 06, 010 PSAY XREC_MUN             // Municipio de Entrega
@ 07, 015 PSAY XREC_CGC             // CGC de Entrega
@ 08, 015 PSAY XREC_INS             // Inscricao de Entrega

@ 08, 040 PSAY Chr(18)                // Descompressao de Impressao

@ 08, 060 PSAY xNATUREZA               // Texto da Natureza de Operacao
If mv_par04 == 1
	@ 08, 081+5 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else
	@ 08, 081+5 PSAY xCF[1] Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
EndIf

@ 10, 000 PSAY Chr(15)                // Compressao de Impressao

@ 10, 025 PSAY cPedAtu              // Numero do Pedido de venda
@ 10, 046 PSAY XDESC_PAG              // Descricao da Condicao de Pagto

//+-------------------------------------+
//¦ Impressao dos Dados do Cliente      ¦
//+-------------------------------------+

@ 11, 000 PSAY Chr(18)                // Descompressao de Impressao
@ 11, 042 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 11, 101 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"	// col 103
Else
	@ 11, 101 PSAY " "                // Caso seja vazio
Endif

@ 11, 123 PSAY xEMISSAO              // Data da Emissao do Documento
If !Empty(xCOD_MENS)
	_cMens1 :=  Posicione("SM4",1,xFilial("SM4")+xCOD_MENS,"M4_FORMULA")
	@ 12, 000 PSAY Substr(_cMens1,1,37)
	@ 13, 000 PSAY Substr(_cMens1,38,37)
Endif

@ 13, 042 PSAY xEND_CLI                                 // Endereco
@ 13, 090 PSAY xBAIRRO                                  // Bairro
@ 13, 110 PSAY xCEP_CLI Picture "@R 99999-999"           // CEP
@ 13, 123 PSAY " "                                      // Reservado  p/Data Saida/Entrada

If !Empty(xCOD_MENS)
	@ 14, 000 PSAY Substr(_cMens1,75,37)
Endif

@ 15, 042 PSAY xMUN_CLI                               // Municipio
@ 15, 080 PSAY xTEL_CLI                               // Telefone/FAX
@ 15, 098 PSAY xEST_CLI                               // U.F.
@ 15, 104 PSAY xINSC_CLI                              // Insc. Estadual
@ 15, 123 PSAY " "                                    // Reservado p/Hora da Saida

If !Empty(xSuframa)
	@ 17,000 PSAY "SUFRAMA : "+xSuframa
EndIf

If mv_par04 == 2
	
	//+-------------------------------------+
	//¦ Impressao da Fatura/Duplicata       ¦
	//+-------------------------------------+
	
	nLin:=18
	BB:=1
	nCol := 10             //  duplicatas
	DUPLIC()
	
Endif

//+-------------------------------------+
//¦ Dados dos Produtos Vendidos         ¦
//+-------------------------------------+

nLin := 24

@ 24, 000 PSAY Chr(15)                // Descompressao de Impressao

//***********  IMPRIME LINHAS DE ITENS DA NOTA FISCAL   ***************************
ImpDet()                 // Detalhe da NF
//*********************************************************************************

If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
	@ 56, 010 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
Endif

//VICK
//If mv_par04 == 2 .and. Len(xISS) == 0
//	nLin:=44
//	MensObs()             // Imprime Mensagem de Observacao
//	nLin:=47
//	ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal
//Endif

//+-------------------------------------+
//+ Prestacao de Servicos               +
//+-------------------------------------+
/*
If Len(xISS) > 0

nLin := 50
Impmenp()

nLin :=51
MensObs()

@ 45, 142  PSAY xTOT_FAT  Picture"@E@Z 999,999,999.99"   // Valor do Servico
Endif
*/
//+-------------------------------------+
//+ Calculo dos Impostos                +
//+-------------------------------------+

IF mv_par04 == 2
	_cMens2 :=  Posicione("SM4",1,xFilial("SM4")+_cMenSA1,"M4_FORMULA")
	If !Empty(_cMens2)
		@ 56, 000 PSAY "###"+Alltrim(UPPER(_cMens2))+"###"    // mensagem padrao do cliente A1_MENSAGE
	Endif
	If !Empty(xMENSAGEM)
		@ 57, 000 PSAY "###"+Alltrim(UPPER(xMENSAGEM))+"###"  // mensagem padrao do pedido de venda C5_MENNOTA
	Endif
ENDIF    

@ 60, 000 PSAY Chr(18)                // Descompressao de Impressao

@ 60, 001  PSAY xBASE_ICMS  Picture"@E@Z 999,999,999.99"  // Base do ICMS
@ 60, 017  PSAY xVALOR_ICMS Picture"@E@Z 999,999,999.99"  // Valor do ICMS 
@ 60, 030  PSAY xBASCALICM  Picture"@E@Z 999,999,999.99"  // Base Calculo ICMS SUBSTITUICAO// ALTERADO POR CLAUDIO 230709
@ 60, 031  PSAY xBSICMRET   Picture"@E@Z 999,999,999.99"  // Base ICMS Ret.
@ 60, 051  PSAY xICMS_RET   Picture"@E@Z 999,999,999.99"  // Valor  ICMS Ret.
//@ 60, 068  PSAY xVALOR_MERC Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.

/*Alterado em 14.03.05 
  para nao imprimir o valor total dos produtos qdo. NF COMPLEMENTAR ICMS/IPI */
If xTIPO != 'I' .AND. xTIPO != 'P' 
	@ 60, 068  PSAY xVALOR_MERC Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
EndIf


@ 62, 001  PSAY xFRETE      Picture"@E@Z 999,999,999.99"  // Valor do Frete
@ 62, 017  PSAY xSEGURO     Picture"@E@Z 999,999,999.99"  // Valor Seguro
@ 62, 051  PSAY xVALOR_IPI  Picture"@E@Z 999,999,999.99"  // Valor do IPI
//@ 62, 068  PSAY xTOT_FAT    Picture"@E@Z 999,999,999.99"  // Valor Total NF

/* Alterado em 14.03.05
   para nao imprimir o valor total dos produtos qdo. NF COMPLEMENTAR ICMS/IPI */
If xTIPO != 'I' 
	@ 62, 068  PSAY xTOT_FAT    Picture"@E@Z 999,999,999.99"  // Valor Total NF
EndIf


//+------------------------------------+
//+ Impressao Dados da Transportadora  +
//+------------------------------------+

@ 65, 001  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 65, 049 PSAY "1" 	// Col 050 // Emitente (1)
Else                                               //     ou
	@ 65, 049 PSAY "2"                              // Destinatario (2)
Endif


@ 65, 052 PSAY " "                                  // Res. p/Placa do Veiculo
@ 65, 062 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.


If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 65, 068 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"	// COL 070
Else
	@ 65, 068 PSAY " "                               // Caso seja vazio
Endif


@ 67, 001 PSAY xEND_TRANSP                          // Endereco Transp.
@ 67, 041 PSAY xMUN_TRANSP                          // Municipio
@ 67, 063 PSAY xEST_TRANSP		// Col 65           // U.F.

If !EMPTY(xTRANS_INS)                              // Se C.G.C. Transportador nao for Vazio
	@ 67, 070 PSAY xTRANS_INS  	// Col.070  -  Reservado p/Insc. Estad.
Else
	@ 67, 075 PSAY " "                               // Caso seja vazio
Endif

@ 69, 001 PSAY xVOLUME  Picture"@E@Z 999,999.99"             // Quant. Volumes
@ 69, 018 PSAY xESPECIE Picture"@!"                          // Especie
@ 69, 030 PSAY " "                                           // Res para Marca
@ 69, 040 PSAY " "                                           // Res para Numero
//@ 69, 059 PSAY xPESO_BRUTO     Picture "@E@Z 999,999.99"      // Res para Peso Bruto
//@ 69, 074 PSAY xPESO_LIQUID    Picture "@E@Z 999,999.99"      // Res para Peso Liquido
@ 69, 059 PSAY xPESO_BRU     Picture "@E@Z 999,999.99"      // Res para Peso Bruto
@ 69, 074 PSAY xPESO_LIQ    Picture "@E@Z 999,999.99"      // Res para Peso Liquido

//If mv_par04 == 2
// nLin := 59
//   Clasfis()               // Impressao de Classif. Fiscal
//Endif

//If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
//	@ 69, 088 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
//Endif


//@ 73, 123 PSAY xNUM_NF
@ 72, 123 PSAY xNUM_NF    // Numero da Nota Fiscal

@ 78, 000 PSAY Chr(18)                // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return
