#include "rwmake.ch" 

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function NfVERTST()

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")

SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XESP,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI,XNDI,XNADIC")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED,XMENSAGEM2")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XCOD_MENST,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI,XMSGCOLETA")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO,XPPISE,XPCOFE,XPII")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO,XGRP")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL,xXMENS1,xXMENS2,xXMENS3,xXMENS4,xXMENS5")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,XCF1,XDESPESAS,xValorISS")
SetPrvt("CALCPISE,CALCCOFE,CALCIMPI,CALCIPII,CALCVLM,CALCBICM,CALCC12,CALCIC18,TOTCALC,WSNDI,WSNADIC,WSALIC")

Private xPLACA :=" "
Private xCODM  :=""
Private xMensa1:=""
Private xMensa2:=""
Private xMensa3:=""
Private xMensa4:=""
Private xMensa5:=""
Private xMensa6:=""
Private xMensa7:=""
Private xMensa8:=""
Private xMensa9:=""
Private xMensa10:=""
xValorISS := 0  // estava  dando erro em 06.01.2010 - feixas


/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  Nfiscal ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Nota Fiscal de Entrada/Saida  IMPRESSORA 80 COL            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Alteracao ¦ 27/12/02 - Daniel Vaz - Incluir a mensagem cadastrada no   ¦¦¦
¦¦¦          ¦ SM4, quando for uma nota de entrada. Para isso o codigo da ¦¦¦
¦¦¦          ¦ da mensagem eh cadastrado no campo F4_FORMULA.             ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦
//+--------------------------------------------------------------+
CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
tamanho   := "G"
limite    := 220
titulo    := PADC("Nota Fiscal - Nfiscal",74)
cDesc1    := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2    := ""
cDesc3    := PADC("da Nfiscal",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 1, 1,"",1 }
nomeprog  := "nfiscal"
cPerg     := "NFSIGW    "
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "siganf"

CALCPISE := 0
CALCCOFE := 0
CALCIMPI := 0
CALCIPII := 0
CALCVLM  := 0
CALCBICM := 0
CALCIC12 := 0
CALCIC18 := 0 
WSNDI    := SPACE(1)
WSNADIC  := SPACE(1)
                                         
//+-----------------------------------------------------------+
//¦ Tamanho do Formulario de Nota Fiscal (em Linhas)          ¦
//+-----------------------------------------------------------+

nTamNf := 74     // Apenas Informativo

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString := "SF2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})
	Return
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

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
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
		
		// * Cabecalho da Nota Fiscal
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
//		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		xTOT_FAT    :=SF2->F2_VALBRUT         // Valor Total da Fatura
		If xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		EndIf
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
		xBSICMRET := SF2->F2_BRICMS           //Base do ICMS Retido		
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
		xDESPESAS   :=SF2->F2_DESPESA         // OUTRAS DESPESAS
		xValorISS	:=SF2->F2_BASEISS         // Valor de Servicos Alterado JH, 27/02/2006 15:20
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu  := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		xPED_VEND:={}                         // Numero do Pedido de Venda
		xITEM_PED:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xEMI_NFDV:={}                         // Inserido por Proteam em 27/08/2006
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Venda
		xPRE_TAB :={}                         // Preco Unitario de Tabela
		xIPI     :={}                         // Porcentagem do IPI
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
//		xTES1    :={}                         // TES -> Não Utilizar - Paulo Henrique (Proteam)
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xCF1     :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		
		While !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV) 
			
			// Alterado por Proteam -> 27/08/2006 na virada de DB2 para SQL
			IF !Empty(SD2->D2_NFORI)
				If aScan(xNUM_NFDV,SD2->D2_NFORI) == 0
				   AADD(xNUM_NFDV,SD2->D2_NFORI)
				   AADD(xPREF_DV ,SD2->D2_SERIORI)
					
				   dbSelectArea("SF1")
				   dbSetOrder(1)
				   If dbSeek(xFilial("SF1")+SD2->D2_NFORI+SD2->D2_SERIORI)
				      AADD(xEMI_NFDV,DtoC(SF1->F1_EMISSAO))
				   EndIf   
				   dbSelectArea("SD2")
				EndIf
			EndIf
			
			AADD(xICMS     ,If(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xCOD_PRO  ,subs(SD2->D2_COD,1,15))
			AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
			AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(xIPI      ,If(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			AADD(xVAL_IPI  ,SD2->D2_VALIPI)
			AADD(xDESC     ,SD2->D2_DESC)
			AADD(xVAL_MERC ,SD2->D2_TOTAL)
			AADD(xTES      ,SD2->D2_TES)
			AADD(xCF       ,SD2->D2_CF)
			AADD(xICM_PROD ,If(Empty(SD2->D2_PICM),0,SD2->D2_PICM))

//          Não utilizar - Paulo Henrique (Proteam)			
//			If Ascan(xTES1,SD2->D2_TES)==0
//				AADD(XTES1,SD2->D2_TES)
//			Endif
			
			If Ascan(xcf1, SD2->D2_CF)==0
				AADD(Xcf1, SD2->D2_CF)
			Endif
			
			
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO  :={}                           // Peso Liquido
		xPESO_UNIT :={}                         // Peso Unitario do Produto
		xDESCRICAO :={}                         // Descricao do Produto
		xUNID_PRO  :={}                           // Unidade do Produto
		xCOD_TRIB  :={}                           // Codigo de Tributacao
		xMEN_TRIB  :={}                           // Mensagens de Tributacao
		xCOD_FIS   :={}                           // Cogigo Fiscal
		xCLAS_FIS  :={}                           // Classificacao Fiscal
		aEXNCM     :={}                           // EX - NCM (FWNM - 01/MAR/07)
		xMEN_POS   :={}                           // Mensagem da Posicao IPI
		xISS       :={}                           // Aliquota de ISS
		xTIPO_PRO  :={}                           // Tipo do Produto
		xLUCRO     :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL  :={}
		xNVCLAFIS  :={}
		XTPNVCAMP  :={}
		XMSGPRDNF  :={}
		xnatureza  :={}
		xGRP       :={}
		xCOD_MENST :={}
		xPESO_LIQ  := 0
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO  ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xCOD_TRIB  ,SB1->B1_SITTRI)
			AADD(XTPNVCAMP  ,SB1->B1_CLASFIS)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB, SB1->B1_ORIGEM)
			Endif
			
			If Ascan(XMSGPRDNF, SB1->B1_CODIGO)==0
				If !Empty(SB1->B1_CODIGO)
					AADD(XMSGPRDNF, SB1->B1_CODIGO)
				Endif
			Endif
			
			npElem := ascan(xCLAS_FIS, SB1->B1_POSIPI)
			
			If npElem == 0
				AADD(xCLAS_FIS, SB1->B1_POSIPI)
				AADD(xNVCLAFIS, {SB1->B1_POSIPI,SB1->B1_CLASFIS})
				aAdd(aEXNCM, SB1->B1_EX_NCM) // FWNM - 01/MAR/07
			Endif
			
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
			
			xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
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
				xCLIENTE     := SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI    := SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS    := SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM    := SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xMENSAGEM2   := SC5->C5_MENNOT1            // Mensagem para a Nota Fiscal
				xTPFRETE     := SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG     := SC5->C5_CONDPAG            // Condicao de Pagamento
				xPESO_BRUTO  := SC5->C5_PBRUTO             // Peso Bruto
				xPESO_LIQUID := SC5->C5_PESOL              // Peso Liquido
				xCOD_VEND    := SC5->C5_VEND1
				XMSGCOLETA   := SC5->C5_VRCOLET            // MSG COLETA
				xDESC_NF     := SC5->C5_DESC1
				AADD(xPED,xPED_VEND[I])
			Endif
			
			If xP_LIQ_PED > 0
				xPESO_LIQ := xP_LIQ_PED
			Endif
			
		Next
		
		//+---------------------------------------------+
		//¦ Pesquisa da Condicao de Pagto               ¦
		//+---------------------------------------------+
		
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
			AADD(xDESCRICAO,SC6->C6_DESCRI)
		Next
		
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
			xMUN_ENT :=SA1->A1_MUNENT
			xEST_ENT :=SA1->A1_ESTENT
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
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
			Endif
			
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
			xMUN_ENT :=""
			xEST_ENT :=""
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
		I := 1
		J := Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND)
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found() 
				If SF3->F3_VALOBSE != 0
					xBSICMRET:=F3_VALOBSE
				EndIf	
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
		xIE          :=SA4->A4_INSEST         //INSC ESTADUAL
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=If(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
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

		// Alterado por Paulo Henrique (Proteam), pois, estava sendo preenchido
		// o array errado (o correto é XTES e não XTES1)
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		xCOD_MENST   := SF4->F4_FORMULA   	// Codigo da Mensagem no SM4
	
		for gh := 1 to len(xTES)
			If dbSeek(xFilial("SF4")+xTES[gh])
			   If Ascan(xNATUREZA, SF4->F4_TEXTO)==0
				  AADD(xNATUREZA  ,SF4->F4_TEXTO)
			   Endif
			   If !Empty(SF4->F4_GRP)
			      AADD(xGRP,SF4->F4_GRP)
			   EndIf
			EndIf      
		next 
		
		 xNATUREZA    := SF4->F4_TEXTO         // Natureza da Operacao //ALTERADO LUCIANE EXPERFITE
		// FUNCAO --> CHAMADA DE IMPRESSAO DO SISTEMA !!!
  		Imprime()
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	End
Else
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		     
		If SF1->F1_FORMUL # "S"  
			DbSkip()                
			Loop
		Endif

		//+-----------------------------------------------------------+
		//¦ Inicializa  regua de impressao                            ¦
		//+-----------------------------------------------------------+
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
		xSEGURO     :=SF1->F1_SEGURO         // Despesa
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
		xXMENS1     :=SF1->F1_XMENS1          // Mensagem para o corpo da NF
		xXMENS2     :=SF1->F1_XMENS2          // Mensagem para os Dados Adicionais
		xXMENS3     :=SF1->F1_XMENS3          // Mensagem para os Dados Adicionais
		xXMENS4     :=SF1->F1_XMENS4          // Mensagem para os Dados Adicionais
		xXMENS5     :=SF1->F1_XMENS5          // Mensagem para os Dados Adicionais
		xDESPESAS   :=SF1->F1_DESPESA         // VALOR DAS DEPESAS ACESSÁRIAS
		
		xNFORI      :=SPACE(06)               // SF1->F1_NFORI NF Original (ñ exite este campo)
		xPREF_DV    :=SPACE(03)               // SF1->F1_SERIORI Serie Original (idem)
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu:= SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xEMI_NFDV:={}                         // Inserido por Proteam em 27/08/2006
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		XNDI := {}
		XNADIC := {}
		xPRE_UNI :={}                         // Preco Unitario de Compra
		xIPI     :={}                         // Porcentagem do IPI
		xPESOPROD:={}                         // Peso do Produto
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
//		XTES1    :={}                         // Não Utilizar -> Paulo Henrique (Proteam)
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		XCF1     :={}
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xnatureza:={}
		xGRP     :={}
		//      XCF1 := SPACE(3)
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		
		while !eof() .and. SD1->D1_DOC==xNUM_NF .and. SD1->D1_SERIE==xSERIE .and. SF1->F1_FORNECE == xFORNECE 
			If SD1->D1_SERIE # mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			
			// Alterado por Proteam -> 27/08/2006 na virada de DB2 para SQL
			IF !Empty(SD1->D1_NFORI)
				If aScan(xNUM_NFDV,SD1->D1_NFORI) == 0
					AADD(xNUM_NFDV,SD1->D1_NFORI)
					AADD(xPREF_DV ,SD1->D1_SERIORI)        // Serie Original
					
					dbSelectArea("SF2")
					dbSetOrder(1)
					If dbSeek(xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI)
					   AADD(xEMI_NFDV,DtoC(SF2->F2_EMISSAO))
					EndIf
					dbSelectArea("SD1")   
				EndIf
			EndIf

			AADD(xICMS     ,If(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SUBS(SD1->D1_COD,1,15))            // Produto
			AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xNDI      ,SD1->D1_DI)          // Guarda O NUMERO DA DI
			AADD(xNADIC    ,SD1->D1_ADIC)          // Guarda O NUMERO DA ADICAO
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      ,SD1->D1_IPI)            // % IPI
			
			If mv_par04 == 1 .and. SF1->F1_FORNECE = "000093"
				_AliasAn := Alias()
				dbSelectArea("SB1")                     // * Desc. Generica do Produto
				dbSetOrder(1)
				dbSeek(xFilial()+SUBS(SD1->D1_COD,1,15))
				AADD(xVAL_IPI  ,(((SD1->D1_TOTAL + ((SD1->D1_TOTAL/100) * SB1->B1_IMPIMPO))/100) * SD1->D1_IPI))         // Valor do IPI DE IMPORTAÇÃO
				dbselectarea(_AliasAn)
			ELSE
				AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI						
			ENDIF
			
			//AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
			xPESO_LIQUID := SD1->D1_PESO
			AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,If(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			
//			Não Utilizar - Paulo Henrique (Proteam)
//			If Ascan(xTES1, SD1->D1_TES)==0
//				AADD(XTES1, SD1->D1_TES)
//			Endif
			
			If Ascan(xcf1, SD1->D1_CF)==0
				AADD(Xcf1, SD1->D1_CF)
			Endif
			
			//         XCF1 := SD1->D1_CF
			
			dbskip()
		End
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+xTES[1])

/*		
		for gh:= 1 to len(xTES1)
			dbSeek(xFilial("SF4")+xTES1[gh])
			If Ascan(xNATUREZA, SF4->F4_TEXTO)==0
				AADD(xNATUREZA , SF4->F4_TEXTO)
			Endif                    
		NEXT
  		AADD(xGRP    , SF4->F4_GRP)
*/
		for gh:= 1 to len(xTES)
			If dbSeek(xFilial("SF4")+xTES[gh])
			   If Ascan(xNATUREZA,SF4->F4_TEXTO)==0
				  AADD(xNATUREZA,SF4->F4_TEXTO)
			   Endif
   			   If !Empty(SF4->F4_GRP)
     		       AADD(xGRP,SF4->F4_GRP)
  			   EndIf
			EndIf   
		NEXT

		      AADD(xNATUREZA  ,SF4->F4_TEXTO) //ALTERADO LUCIANE EXPERFITE
		      xNATUREZA    := SF4->F4_TEXTO              // Natureza da Operacao //ALTERADO LUCIANE EXPERFITE
		xCOD_MENST   := SF4->F4_FORMULA   	// Codigo da Mensagem no SM4
				
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
		aEXNCM   :={}                           // EX - NCM            
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO :={}                           // Tipo do Produto
		xLUCRO    :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL :={}
		xNVCLAFIS :={}
		XMSGPRDNF := {}
		XTPNVCAMP := {}
		XPPISE    := {}                          // PIS DE IMPOTAÇÃO
		XPCOFE    := {}                          // COFINS DE IMPORTAÇÃO
		XPII      := {}                          // IMP. DE IMPORTAÇÃO
		xSUFRAMA :=""
		xCALCSUF :=""
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(XPPISE ,SB1->B1_PPISE)
			AADD(XPCOFE ,SB1->B1_PCOFE)
			AADD(XPII ,SB1->B1_IMPIMPO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,SB1->B1_SITTRI)
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xMEN_POS   ,SB1->B1_POSIPI)
			If SB1->B1_ALIQISS > 0
				AADD(xISS,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			AADD(XTPNVCAMP ,SB1->B1_CLASFIS)
			
			If Ascan(XMSGPRDNF, SB1->B1_CODIGO)==0
				AADD(XMSGPRDNF, SB1->B1_CODIGO)
			Endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			If npElem == 0
				AADD(xCLAS_FIS, SB1->B1_POSIPI)
				AADD(xNVCLAFIS, {SB1->B1_POSIPI,SB1->B1_CLASFIS})
				aAdd(aEXNCM, SB1->B1_EX_NCM) // FWNM - 01/MAR/07
			Endif
			
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
			dbSeek(xFilial()+xFORNECE)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_ENT :=SA1->A1_MUNENT
			xEST_ENT :=SA1->A1_ESTENT
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			
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
			xMUN_ENT :=""
			xEST_ENT :=""
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			
		EndIf
		
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+SA2->A2_TRANSP)
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xIE          := SA4->A4_INSEST        //INSC ESTADUAL
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=If(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		      dbSelectArea("SF4")               // * Tipos de Entrada e Saida //ALTERADO LUCIANE
		      dbSetOrder(1)                                                   //ALTERADO LUCIANE
		      dbSeek(xFilial()+xTES[1])                                       //ALTERADO LUCIANE
		         AADD(xNATUREZA  ,SF4->F4_TEXTO)                              //ALTERADO LUCIANE
		
		      xNATUREZA := SF4->F4_TEXTO        // Natureza da Operacao       //ALTERADO LUCIANE
		
		xNOME_TRANSP :=" "           		// Nome Transportadora
		xEND_TRANSP  :=" "           		// Endereco
		xMUN_TRANSP  :=" "           		// Municipio
		xEST_TRANSP  :=" "           		// Estado
		xVIA_TRANSP  :=" "           		// Via de Transporte
		xCGC_TRANSP  :=" "           		// CGC
		xTEL_TRANSP  :=" "           		// Fone
		xTPFRETE     :=" "           		// Tipo de Frete
		xVOLUME      := 0            		// Volume
		xESPECIE     :=" "           		// Especie
		xPESO_LIQ    := 0            		// Peso Liquido
		xPESO_BRUTO  := 0            		// Peso Bruto
		xCOD_MENST   := SF4->F4_FORMULA     // Codigo da Mensagem no SM4
		xMENSAGEM    :=" "           		// Mensagem da Nota
		xPESO_LIQUID := 0
		
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial()+cPedAtu)
		xCOD_MENS := SC7->C7_MSG
		xMENSAGEM := xMENSAGEM2:=" "           		// Mensagem da Nota
		
		Imprime()
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
	End
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

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMP   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function VerImp
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
				Return
		EndCase
	End
Endif

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPDET   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function IMPDET
Static Function IMPDET()

nLin     := nLin + 2
_lEntr   := 0
_lImport := 0

If !Empty(xREC_CLI)
	If xEND_CLI <> xREC_CLI
		If xEST_ENT == xEST_CLI
			nTamDet := 12
			_lEntr  := 1
		Else
			nTamDet := 12
		EndIf
	Else
		nTamDet := 12
	EndIf
Else
	nTamDet := 12
EndIf

If mv_par04 == 1
	If SA2->A2_COD = "000093"
			_lImport := 1
			nTamDet  := nTamDet // - 1
	EndIf
ENDIF

If !Empty(xMENSAGEM)
	nTamDet := nTamDet - 1
EndIf

If !Empty(XMSGCOLETA)
	nTamDet := nTamDet - 1
EndIf

CALCPISE := 0
CALCCOFE := 0
CALCIMPI := 0
CALCIPII := 0
CALCVLM  := 0
CALCBICM := 0
CALCIC12 := 0
CALCIC18 := 0
WSNDI    := SPACE(1)
WSNADIC  := SPACE(1)
I := 1
J := 1
WSALIC := 1     // VALIDA SE O ICMS É DE 12 OU 18 

xB_ICMS_SOL := 0    // Base  do ICMS Solidario
xV_ICMS_SOL := 0    // Valor do ICMS Solidario

For I:=1 to nTamDet
	
	If I<= Len(xCOD_PRO)
		@ nLin, 001  PSAY xCOD_PRO[I]

		@ nLin, 016  PSAY xDESC_PRO[I]
		@ nLin, 063  PSAY XTPNVCAMP[I]
		@ nLin, 066  PSAY xCOD_TRIB[I]
		@ nLin, 071  PSAY xUNID_PRO[I]
		@ nLin, 075  PSAY xQTD_PRO[I]               Picture "@E 999999"
		
		If mv_par04 == 2
           @ nLin, 085  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99"   		
//		   @ nLin, 085  PSAY xPRE_TAB[I]               Picture "@E 99,999,999.99"   
		//Alterado em 22/08/06 por MHduque
		Elseif mv_par04 == 1 .and. xTipo =="D"	                                  
			@ nLin, 085  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99"
		//Termino	
		else
			@ nLin, 085  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99"

			IF .NOT. EMPTY(XNDI[I])
			   WSNDI   := XNDI[I]
			   WSNADIC := XNADIC[I]
			ENDIF
			
			CALCIMPI := CALCIMPI + (xVAL_MERC[I]/100) * xPII[I] 
			CALCIPII := CALCIPII + xVAL_IPI[I]
			CALCVLM  := CALCVLM  + xVAL_MERC[I]
            IF xICM_PROD[I] = 12
               wCALCBICM := ( xVAL_MERC[I] + (((xVAL_MERC[I] + ((xVAL_MERC[I]/100) * xPII[I]) + xVAL_IPI[I]) / 0.88) /100 ) * 12) / (Abs(SB1->(B1_PPIS+B1_PCOFINS)-100)/100)
               CALCBICM  := CALCBICM + wCALCBICM
              
            ELSEIF xICM_PROD[I] = 18
               wCALCBICM := ( xVAL_MERC[I] + (((xVAL_MERC[I] + ((xVAL_MERC[I]/100) * xPII[I]) + xVAL_IPI[I]) / 0.82) /100 ) * 18) / (Abs(SB1->(B1_PPIS+B1_PCOFINS)-100)/100)
               CALCBICM  := CALCBICM + wCALCBICM
               WSALIC := 2

            ElseIf xICM_PROD[I] = 8.80
               wCALCBICM := ( xVAL_MERC[I] + (((xVAL_MERC[I] + ((xVAL_MERC[I]/100) * xPII[I]) + xVAL_IPI[I]) / 0.9120) /100 ) * 8.80) / (Abs(SB1->(B1_PPIS+B1_PCOFINS)-100)/100)
               CALCBICM  := CALCBICM + wCALCBICM
               WSALIC    := 3

            ELSEIF xICM_PROD[I] = 0
               wCALCBICM := 0
               CALCBICM := 0  
            ENDIF
            wCALCPISE := ((wCALCBICM/100) * xPPISE[I])  
            CALCPISE := CALCPISE + wCALCPISE
            
            wCALCCOFE := ((wCALCBICM/100) * xPCOFE[I])  
            CALCCOFE := CALCCOFE + wCALCCOFE

            IF     xICM_PROD[I] = 12
                   CALCIC12 := CALCIC12 + ( xVAL_MERC[I] + ((xVAL_MERC[I]/100) * xPII[I]) + xVAL_IPI[I] + wCALCPISE + wCALCCOFE )
            ELSEIF xICM_PROD[I] = 18
                   CALCIC18 := CALCIC18 + ( xVAL_MERC[I] + ((xVAL_MERC[I]/100) * xPII[I]) + xVAL_IPI[I] + wCALCPISE + wCALCCOFE )
            ENDIF

		EndIf
		
		If zFranca
			@ nLin, 101  PSAY xVAL_MERC[I] + xDESC_ZFR[I] Picture "@E 999,999,999.99"  // Valor Tot. Prod.
		Else
			@ nLin, 101  PSAY NOROUND(xVAL_MERC[I],3) Picture "@E 999,999,999.99"  // Valor Tot. Prod.
		EndIf
		
		vIss := 0

		IF !ZFRANCA .AND. xGRP[I] <> "004"
			@ nLin, 118 PSAY xICM_PROD[I]           Picture "99.99"    // JH
        //Alterado 22/08/06 por Mhduque - N.Fiscal ISS
		ELSEIF !ZFRANCA .AND. xGRP[I] == "004"  //Grupo Servicos
		    @ nlin, 118 PSAY vIss  	                Picture "99.99"
		ENDIF

		@ nLin, 122  PSAY xIPI[I]                   Picture "99"
		@ nLin, 124  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
		
		J:=J+1
	Endif
	nLin := nLin + 1
	
Next i

If !xTES[1] $ "251|252"
	If _lImport == 1
		@ nLin, 001 PSAY "Imp.Importação:"
		@ nLin, 017 PSAY CALCIMPI                Picture "@E 9,999,999.99"
		@ nLin, 028 PSAY "- PIS: "
		@ nLin, 035 PSAY CALCPISE                Picture "@E 9,999,999.99"
		@ nLin, 046 PSAY "- COFINS: "
		@ nLin, 056 PSAY CALCCOFE                Picture "@E 9,999,999.99"
		nLin := nLin + 1
	    IF WSALIC = 1
	       TOTBICM := CALCVLM  + CALCIMPI + xDESPESAS + CALCIPII  + CALCPISE + CALCCOFE 
	       @ nLin, 001 PSAY "Base ICMS ("
	       @ nLin, 013 PSAY TOTBICM                Picture "@E 9,999,999.99"        
	       @ nLin, 026 PSAY "/ 0,88) * 12% = ICMS ("
		   TOTCALCI := ((TOTBICM / 0.88 )  / 100) * 12
	       @ nLin, 049 PSAY TOTCALCI                Picture "@E 9,999,999.99"        
	       @ nLin, 060 PSAY ")"
	    elseIF WSALIC == 2
	       TOTBICM := CALCVLM  + CALCIMPI + xDESPESAS + CALCIPII  + CALCPISE + CALCCOFE 
	       @ nLin, 001 PSAY "Base ICMS ("
	       @ nLin, 013 PSAY TOTBICM                Picture "@E 9,999,999.99"        
	       @ nLin, 026 PSAY "/ 0,82) * 18% = ICMS ("
	       TOTCALCI := ((TOTBICM / 0.82 )  / 100) * 18
	       @ nLin, 049 PSAY TOTCALCI                Picture "@E 9,999,999.99"        
	       @ nLin, 060 PSAY ")"
	    ElseIf wSalic == 3
    	   TOTBICM := CALCVLM  + CALCIMPI + xDESPESAS + CALCIPII  + CALCPISE + CALCCOFE 
	       @ nLin, 001 PSAY "Base ICMS ("
    	   @ nLin, 013 PSAY TOTBICM                Picture "@E 9,999,999.99"        
	       @ nLin, 026 PSAY "/ 0,9120) * 8.8% = ICMS ("
    	   TOTCALCI := ((TOTBICM / 0.9120 )  / 100) * 8.8
	       @ nLin, 049 PSAY TOTCALCI                Picture "@E 9,999,999.99"        
    	   @ nLin, 060 PSAY ")"
	    ENDIF   
	  	nLin := nLin + 1
		
	    IF !EMPTY(xXMENS1)
			@ nLin, 001 PSAY xXMENS1 
			nLin := nLin + 1
		ENDIF	
	EndIf
EndIf
	
If !Empty(xMENSAGEM)
	@ nLin, 001 PSAY xMENSAGEM
	nLin := nLin + 1
EndIf

If !Empty(XMSGCOLETA)
	@ nLin, 001 PSAY XMSGCOLETA
	nLin := nLin + 1
EndIf

If _lEntr == 1
	@ nLin, 001 PSAY "LOCAL P/ ENTREGA: "+Alltrim(xREC_CLI)+" - "+Alltrim(xMUN_ENT)+" - "+xEST_ENT
	nLin := nLin + 1
EndIf
if mv_par04 == 2
	@ nLin, 001 PSAY "NAO ACEITAMOS DEVOLUCOES SEM PREVIO CONTATO COM DEPTO DE VENDAS"
endif
nLin := nLin + 1
if mv_par04 == 2
	@ nLin, 001 PSAY "SE ATE VENCIMENTO NAO RECEBER BOLETO, LIGAR PARA DEPTO FINANCEIRO."
endif
nLin := nLin + 1
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

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function CLASFIS
Static Function CLASFIS()

_WMENSAG := _WMENSPRD := _WMENSAGT := ""

dbSelectArea("SM4")
dbSetOrder(1)

If !Empty(xCOD_MENS)
	dbSeek(xFilial("SM4")+ xCOD_MENS)
	_WMENSAG := SM4->M4_FORMULA
EndIf

If !Empty(xCOD_MENST)
	dbSeek(xFilial("SM4")+ xCOD_MENST)
	_WMENSAGT := SM4->M4_FORMULA
EndIf

If Len(XMSGPRDNF) > 0
	dbSeek(xFilial("SM4")+XMSGPRDNF[1])
	_WMENSPRD := SM4->M4_FORMULA
EndIf

nLen := nLen1 := Len(xNVCLAFIS)
If     nLen > 16
	nLen := 16
Elseif nLen < 8
	nLen := 8
Endif

For nCont := 1 to nLen
	nCol := If(Mod(nCont,1) != 0, 06, 01)
	If ncont <= NLEN1
		@ nLin, nCol     PSAY xNVCLAFIS[nCont,2] + "-"
		@ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99")
		// @ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.999") - (FWNM - 01/MAR/07)
		If !Empty(aEXNCM[nCont])
			@ nLin, nCol+16 pSay chr(32) + "EX" + chr(32) + aEXNCM[nCont] // (FWNM - 01/MAR/07)
		EndIf
	Endif
	
	If nCont == 1
		@ nLin, NCol + 25 PSAY Substr(_WMENSAGT,1,56)
	Elseif nCont == 2
		@ nLin, NCol + 25 PSAY Substr(_WMENSAGT,57,56)
	Elseif nCont == 3
		@ nLin, NCol + 25 PSAY Substr(_WMENSAG,1,56)
	Elseif nCont == 4
		@ nLin, NCol + 25 PSAY Substr(_WMENSAG,57,56)
	Elseif nCont == 5
		@ nLin, NCol + 25 PSAY Substr(_WMENSPRD,1,56)
	Elseif nCont == 6
		@ nLin, NCol + 25 PSAY Substr(_WMENSPRD,57,56)
	Elseif nCont == 7
		@ nLin, nCol + 25 PSAY Substr(xMENSAGEM2,1,56)
	Elseif nCont == 8
	    if !empty(xNUM_NFDV) .and. !empty(xPREF_DV) .and. !empty(xEMI_NFDV)
			If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
				For i:=1 to Len(xNUM_NFDV)
					_cNFS := xNUM_NFDV[i] + "  " + xPREF_DV[i] + " Emissão: "  + xEMI_NFDV[i]
				Next
				@ nLin, nCol + 25 PSAY "Nota Fiscal Original No. "+ _cNFS
			Endif
	    endif 	
	Elseif nCont == 9
		IF ZFRANCA
			@ nLin, nCol + 25 PSAY "Merc. n/serao REDESPACHADAS * Tot Merc.: "
			@ nLin, 066  PSAY xTotmerc
		endif
	Elseif nCont == 10
		If ZFRANCA
			@ nLin, nCol + 25 PSAY "*--------------------* Desc.Ref 7% ICMS: "
			@ nLin, 067  PSAY +xDesconto
		Endif
		
	Endif

	nLin := nLin + If(Mod(nCont,1) != 0, 0, 1)
	
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

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function IMPMENP
Static Function IMPMENP()

nCol:= 25

If !Empty(xCOD_MENS)
	dbSelectArea("SM4")
	dbSetOrder(1)
	dbSeek(xFilial("SM4")+ xCOD_MENS)
	
	@ nLin, NCol pSay Substr(M4_FORMULA,001,058)
	nLin := nLin + 1
	@ nLin, NCol PSAY Substr(M4_FORMULA,059,058)
	nLin := nLin + 1
	
Endif

Mensobs()

Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

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

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function MENSOBS
Static Function MENSOBS()

nTamObs:=60
nCol:=25
IF ZFRANCA
	@ nLin, nCol PSAY "* mercadorias nao serao REDESPACHADAS * Total Mercadorias : "
	@ nLin, 067  PSAY xTotmerc
	nLin := nLin + 1
	@ nLin, nCol PSAY "* ----------------------------------- * Desc.Ref 7% de ICM: "
	@ nLin, 067  PSAY +xDesconto
Endif
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM2,1,nTamObs))

Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ DUPLIC   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao do Parcelamento das Duplicacatas                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function DUPLIC
Static Function DUPLIC()

For BB := 1 to Len(xVALOR_DUP)
	
	IF BB > 4
		EXIT
	ENDIF
	
	DO CASE
		CASE BB == 1
			ncol  := 04
			ncol1 := 28
		CASE BB == 2
			ncol  := 51
			ncol1 := 73
		CASE BB == 3
			ncol  := 104
			ncol1 := 124
		OTHERWISE
			nLin  := nLin + 1
			ncol  := 04
			ncol1 := 28
			
	ENDCASE
	
	If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
		@ nLin, ncol  PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
		@ nLin, ncol1 PSAY xVENC_DUP[BB]
	Endif
Next

Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ LI       ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Pula 1 linha                                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+


/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function Imprime

Static Function Imprime()
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦              IMPRESSAO DA N.F. DA Nfiscal                    ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+-------------------------------------+
//¦ Impressao do Cabecalho da N.F.      ¦
//+-------------------------------------+

@ 00, 000 PSAY Chr(15)                // Compressao de Impressao

//@ 03, 118 PSAY xNUM_NF               // Numero da Nota Fiscal
//@ 03, 35 PSAY "NOVO ENDERECO:Rua Pedro de Toledo, 175"
//@ 04, 35 PSAY "              Bairro Jardim Sao Geraldo"
//@ 05, 35 PSAY "              CEP 07140-000 - Guarulhos - SP"
//@ 06, 20 PSAY "				 IE 336.928.920.110"
//@ 07, 35 PSAY "              CCM: 176.949"     
If mv_par04 == 1
	@ 07, 098 PSAY "X"
Else
	@ 07, 081 PSAY "X"
Endif

if len(xNATUREZA) = 1
	@ 12, 001 PSAY xNATUREZA[1]               // Texto da Natureza de Operacao
elseif len(xNATUREZA) = 2                                                                         
	@ 12, 001 PSAY alltrim(xNATUREZA[1])+"/"+alltrim(xNATUREZA[2])  // Texto da Natureza de Operacao
else
	@ 12, 001 PSAY alltrim(xNATUREZA[1])+"/"+alltrim(xNATUREZA[2])  // Texto da Natureza de Operacao
Endif


If mv_par04 == 1
	@ 12, 036 PSAY SUBSTR(xCF[1],1,1)+"."+SUBSTR(xCF[1],2,3) // Codigo da Natureza de Operacao
Else
	if len(xCF1) = 1
		@ 12, 036 PSAY SUBSTR(xCF1[1],1,1)+"."+SUBSTR(xCF1[1],2,3) // Codigo da Natureza de Operacao
	elseif len(xCF) = 2
		@ 12, 036 PSAY SUBSTR(xCF1[1],1,1)+"."+SUBSTR(xCF1[1],2,3)+"/"+SUBSTR(xCF1[2],1,1)+"."+SUBSTR(xCF1[2],2,3) // Codigo da Natureza de Operacao
	else
		@ 12, 036 PSAY SUBSTR(xCF1[1],1,1)+"."+SUBSTR(xCF1[1],2,3)+"/"+SUBSTR(xCF1[2],1,1)+"."+SUBSTR(xCF1[2],2,3) // Codigo da Natureza de Operacao
	Endif
EndIf
//+-------------------------------------+
//¦ Impressao dos Dados do Cliente      ¦
//+-------------------------------------+

@ 15, 001 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 15, 85 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
Else
	@ 15, 85 PSAY " "                // Caso seja vazio
Endif

@ 15, 118 PSAY xEMISSAO              // Data da Emissao do Documento
@ 17, 001 PSAY xEND_CLI                                 // Endereco
@ 17, 070 PSAY xBAIRRO                                  // Bairro
@ 17, 100 PSAY xCEP_CLI Picture "@R 99999-999"           // CEP

@ 19, 001 PSAY xMUN_CLI                               // Municipio
@ 19, 050 PSAY xTEL_CLI                               // Telefone/FAX
@ 19, 071 PSAY xEST_CLI                               // U.F.
IF !EMPTY(xINSC_CLI)
	@ 19, 080 PSAY xINSC_CLI                              // Insc. Estadual
ELSE
	@ 19, 080 PSAY "ISENTO"
ENDIF
@ 19, 112 PSAY " "

If mv_par04 == 2
	
	//+-------------------------------------+
	//¦ Impressao da Fatura/Duplicata       ¦
	//+-------------------------------------+
	
	nLin:=22
	BB:=1
	nCol := 04             //  duplicatas
	DUPLIC()
	
Endif

//+-----------------------+
//¦ Prestacao de Servicos ¦
//+-----------------------+

nLin := 26
ImpDet()                 // Detalhe da NF
nLin := nLin + 1

If Len(xISS) > 0
	
	@ 47, 002 PSAY SF2->F2_BASEISS Picture "@E@Z 999,999,999.99"  // Valor Tot. servicos
	_WVAL := 5
	@ 47, 020 PSAY _WVAL           Picture "@E@Z 999.99"
	@ 47, 040 PSAY SF2->F2_VALISS  Picture "@E@Z 999,999,999.99"  // Valor ISS
//  @ 47, 118 PSAY SF2->F2_BASEISS Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
	@ 47, 118 PSAY xValorISS       Picture "@E@Z 999,999,999.99"  // Valor dos Servicos Aletrado JH, 27/02/2006 15:20
//  @ 47, 118 PSAY SF2->F2_BASEISS xVALOR_MERC     Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
Endif


//+-------------------------------------+
//¦ Calculo dos Impostos                ¦
//+-------------------------------------+
_CENT := xVALOR_MERC - xBASE_ICMS

	IF MV_PAR04 == 1                                                                         
          If SF1->F1_FORNECE = "000093" .and. !xTES[1] $ "252|253"
             IF WSALIC = 1
                TOTBICM := (CALCVLM  + CALCIMPI + xDESPESAS + CALCIPII  + CALCPISE + CALCCOFE ) / 0.88
             ELSEIF WSALIC == 2
                TOTBICM := (CALCVLM  + CALCIMPI + xDESPESAS + CALCIPII  + CALCPISE + CALCCOFE ) / 0.82
             ELSEIf WSALIC == 3
                TOTBICM := (CALCVLM  + CALCIMPI + xDESPESAS + CALCIPII  + CALCPISE + CALCCOFE ) / 0.9120
             ENDIF   
             
        	 @ 50, 002  PSAY TOTBICM            Picture "@E@Z 999,999,999.99"   // Base do ICMS

/*										
             CALCIC12 := ((((CALCIC12 + xDESPESAS) / 0.88) /100 ) * 12)
             CALCIC18 := ((((CALCIC18 + xDESPESAS) / 0.82) /100 ) * 18)
             TOTCALC := CALCIC12 + CALCIC18
*/          
			 IF WSALIC = 1
			   TOTCALC := (TOTBICM / 100) * 12
             ELSEIF WSALIC == 2
               TOTCALC := (TOTBICM / 100) * 18
			 ELSEIF WSALIC == 3
               TOTCALC := (TOTBICM / 100) * 8.8
             ENDIF
          ELSE	 
          
          	 @ 50, 002  PSAY xBASE_ICMS            Picture "@E@Z 999,999,999.99"   // Base do ICMS
          ENDIF	 
	Else
        	//If xICMS_RET >= 0 .AND. xEST_CLI != "SP"
        	 	 IF _CENT < 0.50
       				  	@ 50, 002  PSAY xBASE_ICMS Picture "@E@Z 999,999,999.99"   // Base do ICMS
        	 	  ELSE
    					@ 50, 002  PSAY xBASE_ICMS+xDESPESAS  Picture "@E@Z 999,999,999.99"   // Base do ICMS
        	 	  EndIF
        	// ElseIf xICMS_RET = 0
        	 //	  IF _CENT < 0.50
       		 //		  	@ 50, 002  PSAY xBASE_ICMS Picture "@E@Z 999,999,999.99"   // Base do ICMS
        	 //	  ELSE
    		   //			@ 50, 002  PSAY xBASE_ICMS+xDESPESAS  Picture "@E@Z 999,999,999.99"   // Base do ICMS
        	 //	   EndIF        	 	  	
        	// EndIf 
	ENDIF
_CENT :=0

	IF MV_PAR04 == 1                                                                         
          If SF1->F1_FORNECE = "000093" .and. !xTES[1] $ "252|253"
             @ 50, 025  PSAY TOTCALC     Picture "@E@Z 999,999,999.99"  // Valor do ICMS
		  ELSE
			 @ 50, 025  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
          ENDIF
    ELSE
      // If xICMS_RET > 0 .AND. xEST_CLI != "SP"
       		@ 50, 025  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
      // ElseIf xICMS_RET = 0
       		//@ 50, 025  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS       			
     //  EndIf	
    ENDIF      

    If xBSICMRET > 0
		@ 50, 055  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret. //ALTERADO PELO RODOLFO VACARI
		@ 50, 085  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.  //ALTERADO PELO RODOLFO VACARI
	EndIf	
//@ 39, 118  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
If zFranca
	@ 50, 118  PSAY xVALOR_MERC+xDESCONTO Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
Else
	If Len(xISS) > 0
		@ 50, 118  PSAY xVALOR_MERC-xValorISS Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
	Else
		IF MV_PAR04 == 1                                                                         
	          If SF1->F1_FORNECE = "000093" .and. !xTES[1] $ "252|253"
	             @ 50, 118  PSAY (CALCVLM  + CALCIMPI) Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
	          ELSE
		         @ 50, 118  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
		      ENDIF   
		ELSE                                                     
			          @ 50, 118  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
		ENDIF       
	EndIf
EndIF
@ 52, 002  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
@ 52, 025  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
@ 52, 048  PSAY xDESPESAS   Picture "@E@Z 999,999,999.99"  // Outras Despesas Acessorias
@ 52, 070  PSAY If(!Empty(CALCIPII),CALCIPII,xVALOR_IPI)  Picture "@E@Z 999,999,999.99"  // Valor do IPI
//@ 52, 070  PSAY CALCIPII    Picture "@E@Z 999,999,999.99"  // Valor do IPI
IF ZFRANCA
	@ 52, 118  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
Else
	IF MV_PAR04 == 1                                                                         
       If SF1->F1_FORNECE = "000093" .and. !xTES[1] $ "252|253"
          @ 52, 118  PSAY TOTBICM     Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
       ELSE
          @ 52, 118  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.      
       ENDIF   
    ELSE
       @ 52, 118  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
    ENDIF   
EndIf

//+------------------------------------+
//¦ Impressao Dados da Transportadora  ¦
//+------------------------------------+

@ 55, 002  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 55, 075 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 55, 075 PSAY "2"                              // Destinatario (2)
Endif

@ 55, 084 PSAY xPLACA                          // Placa do veiculo
@ 55, 099 PSAY xEST_TRANSP                     // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 55, 113 PSAY xCGC_TRANSP Picture "@R 99.999.999/9999-99"
Else
	@ 55, 113 PSAY " "                               // Caso seja vazio
Endif

@ 57, 002 PSAY xEND_TRANSP                          // Endereco Transp.
@ 57, 065 PSAY xMUN_TRANSP                          // Municipio
@ 57, 099 PSAY xEST_TRANSP                          // U.F.
@ 57, 108 PSAY xIE                                  // Reservado p/Insc. Estad.
@ 59, 002 PSAY xVOLUME  Picture "@E@Z 999,999.999"             // Quant. Volumes
@ 59, 026 PSAY xESPECIE Picture "@!"                          // Especie
@ 59, 047 PSAY " "                                           // Res para Marca
@ 59, 056 PSAY " "                                           // Res para Numero
@ 59, 095 PSAY xPESO_BRUTO     Picture "@E@Z 999.999"   // Res para Peso Bruto
@ 59, 118 PSAY xPESO_LIQUID    Picture "@E@Z 999.999"     // Res para Peso Liquido

if mv_par04 == 2
	@ 61, 025 PSAY "NUM.PED. "+xPED_VEND[1]
	@ 61, 042 PSAY "COD.VEN. "+xCOD_VEND
endif

nLin := 62

// ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal
// nLin := 63

//If mv_par04 == 2          // Alterado por Renan Paiva em 27/08/2006 solicitado por Vanderleia 
	Clasfis()               // Impressao de Classif. Fiscal
//Endif

if mv_par04 == 1
    IF WSNDI <> SPACE(1)
       @ nLin, 025 PSAY "Num D.I.:"+WSNDI
	   @ nLin, 045 PSAY "Num Adicao:"+WSNADIC
	   nLin := nLin + 1
	ENDIF   
Endif

IF !EMPTY(xXMENS2)
   @ nLin, 025 PSAY xXMENS2 
   nLin := nLin + 1
ENDIF	
IF !EMPTY(xXMENS3)
   @ nLin, 025 PSAY xXMENS3 
   nLin := nLin + 1
ENDIF	
IF !EMPTY(xXMENS4)
   @ nLin, 025 PSAY xXMENS4 
   nLin := nLin + 1
ENDIF	
IF !EMPTY(xXMENS5)
   @ nLin, 025 PSAY xXMENS5 
   nLin := nLin + 1
ENDIF	          
       /*                                                                                        
       If xICMS_RET > 0 .AND. xEST_CLI = "SP"                         
    	  	@ nLin, 025  PSAY "Base de ICMS : "+xBASE_ICMS Picture "@E@Z 999,999,999.99"   // Base do ICMS
    	  	   nLin := nLin + 1
       		@ nLin, 025  PSAY "Valor ICMS : "+xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
       EndIf
       */
       
/*
nLin := 62
If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
@ nLin, 025 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
nLin:= nLin+1
Endif

If !Empty(xSuframa)  .AND. xDuplic_Gera == "S"
@ nLin, 025 PSAY "CODIGO DA REP.FISCAL - 010.010.43  ***  SUFRAMA  -  "  + xSuframa
nLin:= nLin+1
EndIf

If Len(xISS) == 0 //mv_par04 == 2 .and. - Retirado o filtro para imprimir mensagem na NFE
ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal
Endif
*/

@ 71, 118 PSAY xNUM_NF                   // Numero da Nota Fiscal

//nLin := 72
nLin := nLin + 1
@ nLin, 000 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.
