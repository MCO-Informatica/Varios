#include "rwmake.ch"

User Function Nflinci2()

/*/             //NOTA FISCAL OFICIAL E ESTA.......RODRIGO 18/08/06
___________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Programa  & Nfiscal2 &Autor & Vanderlei A Ferreira     &Data& 16/02/06 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Nota Fiscal de Entrada/Saida  - novo Formulario Continuo.  &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Especifico para Linciplas   Alt. Vanderlei   16/03/06      &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

//ZDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD?
//3 Declaracao de variaveis utilizadas no programa atraves da funcao    3
//3 SetPrvt, que criara somente as variaveis definidas pelo usuario,    3
//3 identificando as variaveis publicas do sistema utilizadas no codigo 3
//3 Incluido pelo assistente de conversao do AP5 IDE                    3
//@DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDY

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XDESP,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,xDESCR_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,_cMsgNfDev")

_xTes := ""
_xCF  := ""

//+--------------------------------------------------------------+
//& Define Variaveis Ambientais                                  &
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//& Variaveis utilizadas para parametros                         &
//& mv_par01             // Da Nota Fiscal                       &
//& mv_par02             // Ate a Nota Fiscal                    &
//& mv_par03             // Da Serie                             &
//& mv_par04             // Nota Fiscal de Entrada/Saida         &
//+--------------------------------------------------------------+
CbTxt	  :=""
CbCont	  :=""
nOrdem 	  :=0
Alfa 	  :=0
Z		  :=0
M		  :=0
tamanho	  :="G"
limite	  :=220
titulo 	  :=PADC("Nota Fiscal - Nfiscal",74)
cDesc1 	  :=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 	  :=PADC("Linciplas Ind.",74)
cDesc3 	  :=PADC("da Nfiscal, formulario contmnuo.",74)
cNatureza :=""
aReturn   :={ "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  :="nflinci2"
cPerg     :="NFSIGW"
nLastKey  :=0
lContinua :=.T.
nLin      :=0
wnrel     :="NFLINCI2"
_cMsgNfDev := ""
//+-----------------------------------------------------------+
//& Tamanho do Formulario de Nota Fiscal (em Linhas)          &
//+-----------------------------------------------------------+

nTamNf :=72     // Apenas Informativo

//+-------------------------------------------------------------------------+
//& Verifica as perguntas selecionadas, busca o padrao da Nfiscal           &
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//+--------------------------------------------------------------+
//& Envia controle para a funcao SETPRINT                        &
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//& Verifica Posicao do Formulario na Impressora                 &
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

//+--------------------------------------------------------------+
//&                                                              &
//& Inicio do Processamento da Nota Fiscal                       &
//&                                                              &
//+--------------------------------------------------------------+
RptStatus({|| RptDetail()})
Return

Static Function RptDetail()

Local J
Local I

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
//& Inicializa  regua de impressao                            &
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))

If mv_par04 == 2 //================================================= INICIO NF SAIDA =========
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC <= mv_par02 .and. lContinua .AND. SF2->F2_SERIE == mv_par03
		
		If SF2->F2_SERIE # mv_par03
			DbSkip()
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
		
		
		//+--------------------------------------------------------------+
		//& Inicio de Levantamento dos Dados da Nota Fiscal              &
		//+--------------------------------------------------------------+
		
		// * Cabecalho da Nota Fiscal
		
		xNUM_NF     := SF2->F2_DOC             // Numero
		xSERIE      := SF2->F2_SERIE           // Serie
		xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    := SF2->F2_VALFAT          // Valor Total da Fatura
		
		If xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		Endif
		
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xDESP       :=SF2->F2_DESPESA         // Desp.Acessoria // Vanderlei 16/03/06
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
        xBSICMRET   :=SF2->F2_BRICMS          // BASE DO ICMS SOLIDARIO
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido SOLIDARIO
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
	
		DbSelectArea("SD2")                   // * Itens de Venda da N.F.
		DbSetOrder(8)
		DbSeek(xFilial() + xNUM_NF + xSERIE)
		
		CPEDATU  := SD2->D2_PEDIDO
		CITEMATU := SD2->D2_ITEMPV
		
		xPED_VEND:={}                         // Numero do Pedido de Venda
		xITEM_PED:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV:={}						  // NUMERO QUANDO HOUVER DEVOLUCAO
		xITE_NFDV:={}                         // ITEM DA NOTA FISCAL DEVOLUCAO
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
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xNat     :={}
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xDESCCFO :={}                         // DESCRICAO CFOP  // RODRIGO 31/08/07 - PARA PEGAR A DESCRICAO DA CFOP COM BASE NO TES
		xCOD_TRIB:={}                         // Codigo de Tributacao // Vanderlei 06/12/05
		xVALDEZF :={}                        // Valor Desconto Zona Franca
        _nZfr := 0
        _nQuant := 0
        
		while !eof() .and. SD2->D2_DOC == xNUM_NF .and. SD2->D2_SERIE == xSERIE

			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV)
			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xITE_NFDV ,IIF(Empty(SD2->D2_ITEMORI),"",SD2->D2_ITEMORI))
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
			AADD(xVALDEZF  ,SD2->D2_DESCZFR)

			AADD(xTES      ,SD2->D2_TES)
			AADD(xCOD_TRIB ,SD2->D2_CLASFIS)  // Vanderlei 06/12/05
			
			_xTes := sd2->d2_tes // Vanderlei 01/12/05
			
			If Ascan(xCF, SD2->D2_CF)==0
				AADD(xCF, SD2->D2_CF)
			Endif
			
			If Ascan(xDESCCFO, SD2->D2_TES)==0
				AADD(xDESCCFO, SD2->D2_TES)
			Endif
			
			
			//	AADD(xCF       ,SD2->D2_CF)
			
			_xCF     := SD2->D2_CF // Vanderlei 01/12/05
			
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			
			_nZfr += SD2->D2_DESCZFR   // DESCONTO DA ZONA FRANCA DE MANAUS
            _nQuant += SD2->D2_QUANT
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO :={}                           // Peso Liquido
		xPESOBRU_PRO := {}                       // PESO BRUTO - RODRIGO 17/11/06
		xPESO_UNIT:={}                           // Peso Unitario do Produto
		xPESOBRU_UNIT := {}                         // PESO BRUTO UNITARIO DO PRODUTO RODRIGO 17/11/06
		xDESCRICAO:={}                           // Descricao do Produto
		xUNID_PRO :={}                           // Unidade do Produto
		
		xMEN_TRIB :={}                           // Mensagens de Tributacao
		xCOD_FIS  :={}                           // Cogigo Fiscal
		xCLAS_FIS :={}                           // Classificacao Fiscal
		xMEN_POS  :={}                           // Mensagem da Posicao IPI
		xISS      :={}                           // Aliquota de ISS
		xTIPO_PRO :={}                           // Tipo do Produto
		xLUCRO    :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL :={}
		xPESO_LIQ := 0
		xPESO_BRU := 0
		vCod_pro  :={} // Vanderlei 03/11/05 p/imprimir cod. do cliente
		
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			xPESO_LIQ := xPESO_LIQ + xPESO_PRO[I]
			AADD(xPESO_UNIT , SB1->B1_PESO)
			
			AADD(xPESOBRU_PRO ,SB1->B1_PESBRU * xQTD_PRO[I])
			xPESO_BRU := xPESO_BRU + xPESOBRU_PRO[I]
			AADD(xPESOBRU_UNIT , SB1->B1_PESBRU)
			
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			
			AADD(vCod_pro ,SB1->B1_lcodcli) // Vanderlei 03/11/05
			
			//AADD(xCOD_TRIB ,SB1->B1_ORIGEM) // Vanderlei 06/12/05
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
		   	//npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			npElem := 0        
			
			IF npElem == 0	.AND.  !(xTES[I] $ "505/524")  
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			ENDIF
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			_CLASFIS := ""               
			
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
					
/*				CASE npElem == 0
					_CLASFIS := "0" */
					
			ENDCASE                        
			
			if _CLASFIS$"ABCDEF"     
				nPteste := Ascan(xCLFISCAL,_CLASFIS)
				If nPteste == 0
					AADD(xCLFISCAL,_CLASFIS)
				Endif
				
				AADD(xCOD_FIS ,_CLASFIS)
			Endif
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			//
			// Calculo do Peso Liquido da Nota Fiscal
			//
			
			xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
			For j:=1 to Len(xPESO_PRO)
				xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
			Next j
			
			xPESO_BRUTO:=0                                 // Peso Liquido da Nota Fiscal
			For j:=1 to Len(xPESOBRU_PRO)
				xPESO_BRUTO:=xPESO_BRUTO+xPESOBRU_PRO[j]
			Next j
			
			
		Next I
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xP_BRU_PED  := 0
		xP_LIQ_PED  := 0
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial()+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xP_BRU_PED  :=xP_BRU_PED + SC5->C5_PBRUTO             // Peso Bruto
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
			
			If xP_LIQ_PED > 0
				xPESO_LIQ := xP_LIQ_PED
			Endif
			
			If xP_BRU_PED > 0
				xPESO_BRU := xP_BRU_PED
			Endif
			
		Next I
		
		//+---------------------------------------------+
		//& Pesquisa da Condicao de Pagto               &
		//+---------------------------------------------+
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4") + xCONDPAG)
		
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
		Next j
		
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
			xSIMPLES :=SA1->A1_SIMPLES         // Optante pelo simples 1 = sim 2 = nao 
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
			xSIMPLES :=""            
		Endif
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next j
		
		If xICMS_RET > 0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found()
				xBSICMRET:=F3_BASERET
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
		xINS_TRANS   :=SA4->A4_INSEST         //Inscricao Estadual
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_PREFIXO==xSERIE .AND. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		IF Len(xDESCCFO) > 1
			dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
			DbSetOrder(1)
			dbSeek(xFilial("SF4")+xDESCCFO[1]) // Rodrigo 31/08/07 - PEGAR O TEXTO DE DOIS TES
			//dbSeek(xFilial("SF4")+_xTES) // Vanderlei 01/12/05
			xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
			
			dbSeek(xFilial("SF4")+xDESCCFO[2]) // Rodrigo 31/08/07 - PEGAR O TEXTO DE DOIS TES
			xNATUREZA1:=SF4->F4_TEXTO              // Natureza da Operacao
		ELSE
			dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
			DbSetOrder(1)
			dbSeek(xFilial("SF4")+xDESCCFO[1]) // Rodrigo 31/08/07 - PEGAR O TEXTO DE DOIS TES
			//dbSeek(xFilial("SF4")+_xTES) // Vanderlei 01/12/05
			xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		ENDIF
		Imprime()
		
		//+--------------------------------------------------------------+
		//& Termino da Impressao da Nota Fiscal                          &
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	End
	//=======================================================INICIO NF ENTRADA====================
Else
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		//+-----------------------------------------------------------+
		//& Inicializa  regua de impressao                            &
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
		//& Inicio de Levantamento dos Dados da Nota Fiscal              &
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
		xNFORI      :="" //SF1->F1_NFORI           // NF Original
		xPREF_DV    :="" //SF1->F1_SERIORI         // Serie Original
		_nZfr       := 0
	    _nQuant     := 0
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xITE_NFDV:={}                         // ITEM DA NOTA FISCAL  quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xDESCR_PRO :={}                       // Descicao do Produto
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
		xDESCCFO :={}                         // DESCRICAO CFOP  // RODRIGO 31/08/07 - PARA PEGAR A DESCRICAO DA CFOP COM BASE NO TES
		
		while !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xITE_NFDV ,IIF(Empty(SD1->D1_ITEMORI),"",SD1->D1_ITEMORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
			AADD(xDESCR_PRO,SD1->D1_DESCPRO)        // Descricao do Produto
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
		  
			_xTes := sd1->d1_tes // Vanderlei 01/12/05
			
			If Ascan(xCF, SD1->D1_CF)==0
				AADD(xCF, SD1->D1_CF)
			Endif
			
			If Ascan(xDESCCFO, SD1->D1_TES)==0
				AADD(xDESCCFO, SD1->D1_TES)
			Endif
			
			
			//	AADD(xCF       ,SD2->D2_CF)
			
			_xCF     := SD1->D1_CF // Vanderlei 01/12/05
			
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO  :={}                           // Unidade do Produto
		xDESC_PRO  :={}                           // Descricao do Produto
		xMEN_POS   :={}                           // Mensagem da Posicao IPI
		xDESCRICAO :={}                         // Descricao do Produto
		xCOD_TRIB  :={}                           // Codigo de Tributacao
		xMEN_TRIB  :={}                           // Mensagens de Tributacao
		xCOD_FIS   :={}                           // Cogigo Fiscal
		xCLAS_FIS  :={}                           // Classificacao Fiscal
		xISS       :={}                           // Aliquota de ISS
		xTIPO_PRO  :={}                           // Tipo do Produto
		xLUCRO     :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL  :={}
		xSUFRAMA   :=""
		xCALCSUF   :=""
		
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
			_CLASFIS := ""                   
			
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
			
			if _CLASFIS$"ABCDEF"     

				nPteste := Ascan(xCLFISCAL,_CLASFIS)
				If nPteste == 0
					AADD(xCLFISCAL,_CLASFIS)
				Endif
			Endif

			AADD(xCOD_FIS ,_CLASFIS)
			
		Next I
		
		//+---------------------------------------------+
		//& Pesquisa da Condicao de Pagto               &
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
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSIMPLES :=SA1->A1_SIMPLES         
			
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
			xSIMPLES := ""
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
		xINS_TRANSP  :=" "           // Inscricao estadual
		xTPFRETE     :=" "           // Tipo de Frete
		xVOLUME      := 0            // Volume
		xESPECIE     :=" "           // Especie
		xPESO_LIQ    := 0            // Peso Liquido
		xPESO_BRUTO  := 0            // Peso Bruto
		xCOD_MENS    :=" "           // Codigo da Mensagem
		xMENSAGEM    :=" "           // Mensagem da Nota
		xPESO_LIQUID :=" "
		
		IF Len(xDESCCFO) > 1
			dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
			DbSetOrder(1)
			dbSeek(xFilial("SF4")+xDESCCFO[1]) // Rodrigo 31/08/07 - PEGAR O TEXTO DE DOIS TES
			//dbSeek(xFilial("SF4")+_xTES) // Vanderlei 01/12/05
			xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
			dbSeek(xFilial("SF4")+xDESCCFO[2]) // Rodrigo 31/08/07 - PEGAR O TEXTO DE DOIS TES
			xNATUREZA1:=SF4->F4_TEXTO              // Natureza da Operacao
		ELSE
			dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
			DbSetOrder(1)
			dbSeek(xFilial("SF4")+xDESCCFO[1]) // Rodrigo 31/08/07 - PEGAR O TEXTO DE DOIS TES
			//dbSeek(xFilial("SF4")+_xTES) // Vanderlei 01/12/05
			xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		ENDIF
		
		Imprime()
		
		//+--------------------------------------------------------------+
		//& Termino da Impressao da Nota Fiscal                          &
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	End
Endif
//+--------------------------------------------------------------+
//&                                                              &
//&                      FIM DA IMPRESSAO                        &
//&                                                              &
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//& Fechamento do Programa da Nota Fiscal                        &
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
//& Fim do Programa                                              &
//+--------------------------------------------------------------+

Return

//+--------------------------------------------------------------+
//&                                                              &
//&                   FUNCOES ESPECIFICAS                        &
//&                                                              &
//+--------------------------------------------------------------+

/*/
_____________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Fung`o    & VERIMP   & Autor &                       & Data & 20/12/95 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Verifica posicionamento de papel na Impressora             &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Nfiscal                                                    &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

//+---------------------+
//& Inicio da Funcao    &
//+---------------------+

Static Function VerImp()

nLin   := 0                // Contador de Linhas
nLinIni:= 0

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

//+---------------------+
//& Fim da Funcao       &
//+---------------------+

/*/
_____________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Fung`o    & IMPDET   & Autor &                       & Data & 20/12/95 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Impressao de Linhas de Detalhe da Nota Fiscal              &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Nfiscal                                                    &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

//+---------------------+
//& Inicio da Funcao    &
//+---------------------+

Static Function IMPDET()

Local I:=1
Local J:=1

nTamDet := len(xCOD_PRO)
if nTamDet > 12
	nTamDet :=12          // Tamanho da Area de Detalhe
Endif

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

For I:=1 to nTamDet
	
	If I <= Len(xCOD_PRO) .AND.  !(xTES[I] $ "505/524") // RODRIGO 31/08/07 - PARA RETIRAR DA NOTA FISCAL O TES 505
		
		@ nLin, 000  PSAY Alltrim(xCOD_PRO[I])
		
		If mv_par04 == 2
			@ nLin, 012  PSAY ALLTRIM(xDESCRICAO[I])+" " + Alltrim(vCod_pro[i]) // Vanderlei 03/11/05
		ELSE
			@ nLin, 012  PSAY ALLTRIM(xDESCRICAO[I])
		ENDIF            
		
		if I <= len(xCOD_FIS)
			@ nLin, 054  PSAY xCOD_FIS[I]  // Vanderlei 16/03/06
		Endif	
		@ nLin, 058  PSAY "000"        // Vanderlei 16/03/06
		@ nLin, 063  PSAY xUNID_PRO[I] // Vanderlei 16/03/06
		@ nLin, 067  PSAY xQTD_PRO[I]       Picture "@E 9999,999.999" // Vanderlei 16/03/06
		
		If xPRE_UNI[I] > 99999.99
		   //	@ nLin, 080  PSAY xPRE_UNI[I]       Picture"@E 99,999,999.99999"  // Vanderlei 16/03/06
		   	@ nLin, 080  PSAY xPRE_TAB[I]       Picture "@E 99,999,999.99999"  // Vanderlei 16/03/06
		Else
		   // @ nLin, 080  PSAY xPRE_UNI[I]       Picture"@E 99,999.99999"  // Vanderlei 16/03/06
			@ nLin, 080  PSAY xPRE_TAB[I]       Picture "@E 99,999.99999"  // Vanderlei 16/03/06
		EndIf
		
		//@ nLin, 099  PSAY xVAL_MERC[I]+XVALDEZF[I]      Picture "@E 99,999,999.99" // Vanderlei 16/03/06
		@ nLin, 099  PSAY xVAL_MERC[I]  Picture "@E 99,999,999.99" // Vanderlei 16/03/06

	 //	IF	_nZfr > 0
	 //		@ nLin, 115  PSAY "0"
	 //	ELSE
			@ nLin, 115  PSAY xICM_PROD[I]      Picture "@E 99" // Vanderlei 16/03/06
	 //	ENDIF	
		@ nLin, 120  PSAY xIPI[I]           Picture "@E 99" // Vanderlei 16/03/06
		
		@ nLin, 128  PSAY xVAL_IPI[I]       Picture "@E 9,999.99"
		
		J:=J+1
		
		nLin :=nLin+1
	
	Endif
Next

Return

//+---------------------+
//& Fim da Funcao       &
//+---------------------+


/*/
_____________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Fung`o    & CLASFIS  & Autor &                       & Data & 16/11/95 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Impressao de Array com as Classificacoes Fiscais           &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Nfiscal                                                    &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

//+---------------------+
//& Inicio da Funcao    &
//+---------------------+

Static Function CLASFIS()

Local nLen := Len(xCLFISCAL)
Local nCont

@ nLin,001 PSAY "CLASSIFICACAO FISCAL:"
nLin := nLin + 1

If nLen > 12
	nLen := 12
Endif

For nCont := 1 to nLen
	nCol := If(Mod(nCont,2) != 0, 01, 33)
	@ nLin, nCol   PSAY xCLFISCAL [nCont] + "-"
	@ nLin, nCol+ 04 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
	nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return


/*/
_____________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Fung`o    & IMPMENP  & Autor &                       & Data & 20/12/95 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Impressao Mensagem Padrao da Nota Fiscal                   &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Nfiscal                                                    &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

//+---------------------+
//& Inicio da Funcao    &
//+---------------------+

Static Function IMPMENP()

nCol:= 05
If !Empty(xCOD_MENS)
	@ nLin, NCol PSAY FORMULA(xCOD_MENS)
Endif

Return

//+---------------------+
//& Fim da Funcao       &
//+---------------------+

/*/
_____________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Fung`o    & MENSOBS  & Autor &                       & Data & 20/12/95 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Impressao Mensagem no Campo Observacao                     &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Nfiscal                                                    &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

//+---------------------+
//& Inicio da Funcao    &
//+---------------------+

Static Function MENSOBS()
// Imprime 3 linhas...
nTamObs:=125
nCol   :=05

*---------------------------------------------------------------------------------------
// Rotina para buscar a mensagem em um dos pedidos da nota saida - Vanderlei 16/03/06
If Len(ALLTRIM(xMensagem)) < 1
	
	For I2:=1 to nTamDet
		
		if nTamDet <= len(xPED_VEND)   // incluido por MARCUS FEIXAS pois estava dando erro de ARRAY..... (17/03/2006)
			dbSelectArea("SC5")                            // * Pedidos de Venda
			dbSetOrder(1)
			DbSeek(xFilial()+xPED_VEND[I2])
			If !Eof()
				xMENSAGEM := ALLTRIM(SC5->C5_MENNOTA)            // Mensagem para a Nota Fiscal
			EndIf
		endif     // <--- incluido em 17/03/06 MARCUS FEIXAS
		//
		If Len(ALLTRIM(xMensagem)) > 1
			Exit
		EndIf
		
	Next I2
	
EndIf
*---------------------------------------------------------------------------------------

@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,126,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,251,nTamObs))

//*----------------------------------------------------------------
// Imprime n.pedido do cliente - Vanderlei 16/02/06
//nlin:=nlin+1
//@ nLin, nCol PSAY "Num.Ped.Cliente : "+sc5->c5_pedcli
//*-----------------------------------------------------------------

Return

//+---------------------+
//& Fim da Funcao       &
//+---------------------+

/*/
_____________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Fung`o    & DUPLIC   & Autor &                       & Data & 20/12/95 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Impressao do Parcelamento das Duplicacatas                 &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Nfiscal                                                    &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

//+---------------------+
//& Inicio da Funcao    &
//+---------------------+

Static Function DUPLIC()

Local BB

nCol    := 20
nAjuste := 00

For BB:= 1 to Len(xVALOR_DUP)
	If xDUPLICATAS ==.T. .and. BB<=Len(xVALOR_DUP)
		
		@ nLin, nCol + 00 + NAJUSTE PSAY xNUM_DUPLIC +" "+ ALLTRIM(xPARC_DUP[BB])
		@ nLin, nCol + 20 + NAJUSTE PSAY xVENC_DUP[BB]
		@ nLin, nCol + 45 + NAJUSTE PSAY xVALOR_DUP[BB] Picture("@E 99,999.99")
		// Vanderlei 16/03/06 - ajustes emissao das duplicatas
		If (BB+1) <= Len(xVALOR_DUP)
			nAjuste := 60 // Vanderlei 16/03/06 ultima
			@ nLin, nCol + 00 + NAJUSTE PSAY xNUM_DUPLIC +" "+ ALLTRIM(xPARC_DUP[BB+1])
			@ nLin, nCol + 20 + NAJUSTE PSAY xVENC_DUP[BB+1]
			@ nLin, nCol + 45 + NAJUSTE PSAY xVALOR_DUP[BB+1] Picture("@E 99,999.99")
			BB := BB+1
		EndIf
		
	Endif
	NAJUSTE := 00
	nlin := nlin +1 // Vanderlei 16/03/06
	
Next

Return

//+---------------------+
//& Fim da Funcao       &
//+---------------------+


/*/
_____________________________________________________________________________
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&+-----------------------------------------------------------------------+&&
&&&Fung`o    & IMPRIME  & Autor &                       & Data & 20/12/95 &&&
&&+----------+------------------------------------------------------------&&&
&&&Descrig`o & Imprime a Nota Fiscal de Entrada e de Saida                &&&
&&+----------+------------------------------------------------------------&&&
&&&Uso       & Generico RDMAKE                                            &&&
&&+-----------------------------------------------------------------------+&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/////////////////////////////////////////////////////////////////////////////
/*/

Static Function Imprime()
//+--------------------------------------------------------------+
//&                                                              &
//&              IMPRESSAO DA N.F. DA Nfiscal                    &
//&                                                              &
//+--------------------------------------------------------------+

//+-------------------------------------+
//& Impressao do Cabecalho da N.F.      &------------------------------------INICIO-----------
//+-------------------------------------+

@ 00, 000 PSAY Chr(15)                // Compressao de Impressao

@ 00, 122 PSAY xNUM_NF               // Numero da Nota Fiscal

If mv_par04 == 1
	@ 01, 093 PSAY "X"
Else
	@ 01, 083 PSAY "X"
Endif

IF Len(xDESCCFO) > 1
	@ 05, 001 PSAY xNATUREZA + " / " + xNATUREZA1      // RODRIGO 31/08/07 - ALTERADO PARA COLOCAR DOIS TEXTOS DAS CFOPS       // Texto da Natureza de Operacao
ELSE
	@ 05, 001 PSAY xNATUREZA
ENDIF

If mv_par04 == 1
	@ 05, 040 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else
	IF Len(xCF) > 1
		//	@ 05, 040 PSAY _xCF Picture PESQPICT("SD2","D2_CF") // Vanderlei 01/12/05
		@ 05, 040 PSAY xCF[1] + "/ " + xCF[2] // RODRIGO 31/08/07 - ALTERADO PARA COLOCAR DOIS CFOP
	ELSE
		@ 05, 040 PSAY xCF[1]  // RODRIGO 31/08/07 - ALTERADO PARA COLOCAR DOIS CFOP
	ENDIF
EndIf

@ 08, 001 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 08, 90 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
Else
	@ 08, 90 PSAY " "                // Caso seja vazio
Endif


@ 08, 125 PSAY xEMISSAO              // Data da Emissao do Documento

@ 10, 001 PSAY xEND_CLI                                 // Endereco
@ 10, 070 PSAY xBAIRRO                                  // Bairro
@ 10, 100 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 10, 125 PSAY SC5->C5_DTSAIDA                          // Reservado  p/Data Saida/Entrada

@ 12, 001 PSAY xMUN_CLI                               // Municipio
@ 12, 052 PSAY xTEL_CLI                               // Telefone/FAX
@ 12, 075 PSAY xEST_CLI                               // U.F.
@ 12, 084 PSAY xINSC_CLI                              // Insc. Estadual

If mv_par04 == 2
	
	//+-------------------------------------+
	//& Impressao da Fatura/Duplicata       &
	//+-------------------------------------+
	
	nLin:= 15 //18
	
	BB:=1
	
	DUPLIC()
	
Endif

//+-------------------------------------+
//& Dados dos Produtos Vendidos         &
//+-------------------------------------+

nLin := 20//22

ImpDet()                 // Detalhe da NF

If mv_par04 == 2 .and. Len(xISS) == 0
	
	nLin:=34
	MensObs()             // Imprime Mensagem de Observacao
	
	nLin:=38
	ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal - FORMULA
	
Endif


//+-------------------------------------+
//& Prestacao de Servicos Prestados     &
//+-------------------------------------+

//If Len(xISS) > 0

//	nLin := 41
//	Impmenp()

//	nLin :=42
//	MensObs()
//	@ 44, 142  PSAY xTOT_FAT  Picture"@E@Z 999,999,999.99"   // Valor do Servico
//Endif

//+-------------------------------------+
//& Calculo dos Impostos                &
//+-------------------------------------+


// Imprime mensagem quando ipi igual a zero (industrial)    //RODRIGO 17/11/06
//IF SUBSTR(mv_par03,1,1) == "2"
//@ 42, 005  PSAY "OPTANTE PELO SIMPLES ARTIGO 5 PARAGRAFO V DA LEI 9.317 "
//ENDIF


// Imprime Numero DA NOTA FISCAL DE FATURA    //RODRIGO 17/11/06
//IF !Empty(SC5->C5_TXTFAT)
//@ 44, 005  PSAY "NOTA FISCAL DE INDUSTRIALIZACAO: " + SC5->C5_TXTFAT
//ENDIF



//
// Monta Variavel com as Notas de Devolucao
//
_cMsgNfDev := ""
DbSelectArea("SD1")                   // * Itens da N.F. de Compra
DbSetOrder(1)
_cMsgNfDev := ""

IF SC5->C5_TRIANG == "1"
	_cMsgNfDev := "DEVOLUCAO DE SUA(s) NF(s). "  //DEVOLUCAO DE SUA NOTA FISCAL
ENDIF

IF SC5->C5_TRIANG == "2"
	_cMsgNfDev := "RETORNO DE SUA(s) NF(s). "  //DEVOLUCAO DE SUA NOTA FISCAL
ENDIF

/*	nLin := 040
If mv_par04 == 2
	_lMsgNfDev := .F.
	i:=1
	For _nX := 1 To Len(xNUM_NFDV)
		If !Empty(xNUM_NFDV[i])
			MsSeek(xFilial()+xNUM_NFDV[i]+xPREF_DV[i]+xCLIENTE+xLOJA+xCOD_PRO[i]+xITE_NFDV[i])
			_cMsgNfDev := _cMsgNfDev + "No.: "+ xNUM_NFDV[i] + " EMIS.: " + dtoc(SD1->D1_EMISSAO)+ " VALOR " + TRANSFORM(xVAL_MERC[i],"@E 999,999.99")+ " - " + SD1->D1_DESCPRO + " " + SD1->D1_UM + " " + TRANSFORM(xQTD_PRO[i],"@E 9999999.9999") + "  "
		 	_lMsgNfDev := .T.																																	
		@ nLin, 005 PSAY _cMsgNfDev
		Endif            
		_cMsgNfDev := " "
		i:= i+1
		nLin++
	Next
 */
 If mv_par04 == 2
	_lMsgNfDev := .F.
	nLin := 039
	i:=1
	
	For _nX := 1 To Len(xNUM_NFDV)
		If !Empty(xNUM_NFDV[i])
			MsSeek(xFilial()+xNUM_NFDV[i]+xPREF_DV[i]+xCLIENTE+xLOJA+xCOD_PRO[i]+xITE_NFDV[i])
			_cMsgNfDev :=  "No.: "+ xNUM_NFDV[i] + " EMIS.: " + dtoc(SD1->D1_EMISSAO)+ " VALOR " + TRANSFORM(xVAL_MERC[i],"@E 999,999.99")+ " - " + RTRIM(SD1->D1_DESCPRO) + " " + SD1->D1_UM + " " + TRANSFORM(xQTD_PRO[i],"@E 9999999.9999") + "  "
		   @ nLin, 005 PSAY "RETORNO DE SUA(s) NF(s). " + _cMsgNfDev
		   nLin ++   
		   _cMsgNfDev := ""
			_lMsgNfDev := .T.																																	
		Endif
		i:= i+1
	Next
	
   /*	If _lMsgNfDev
		@ 40, 005 PSAY SubStr(_cMsgNfDev,1,128)
		If !Empty(SubStr(_cMsgNfDev,123,105))
			@ 41,030 psay SubStr(_cMsgNfDev,131,103)
		EndIf
		
		If !Empty(SubStr(_cMsgNfDev,230,105))
			@ 42,030 psay SubStr(_cMsgNfDev,236,103)
		EndIf
		
		If !Empty(SubStr(_cMsgNfDev,335,105))
			@ 43,030 psay SubStr(_cMsgNfDev,341,103)
		EndIf
	EndIf*/
ENDIF




// Imprime n.pedido do cliente - Vanderlei 16/02/06
IF !Empty(SC5->C5_PEDCLI)
	@ 45, 005 PSAY "PEDIDO CLIENTE: "+SC5->C5_PEDCLI
ENDIF

// Imprime Numero Pedido Linciplas - Rodrigo 21/09/06
@ 45, 115 PSAY "P.I.: "+SC5->C5_NUM


// Imprime Enderego de Entrega         //RODRIGO 17/11/06
If !Empty(SA1->A1_ENDENT)
	@ 47,005 PSAY "END. ENTREGA: " + SUBSTR(SA1->A1_ENDENT,1,180) //rafael(06/01/09)
ENDIF
	
IF	_nZfr > 0
	@ 48,005  PSAY " DESCONTO ZONA FRANCA:"
	@ 48,030  PSAY _nZfr Picture "@E 9,999.99"
ENDIF 
    
IF xBASE_ICMS > 0 .AND. xBSICMRET  == 0  //RODRIGO 17/11/06
	@ 51, 001  PSAY xBASE_ICMS  Picture"@E@Z 999,999,999.99"  // Base do ICMS
ELSE
	@ 51, 011  PSAY "0,00"
ENDIF

IF xVALOR_ICMS > 0 .AND. xBSICMRET  == 0
	@ 51, 028  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
ELSE
	@ 51, 038  PSAY "0,00"
ENDIF

IF xBSICMRET > 0
	@ 51, 052  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
ELSE
	@ 51, 062  PSAY "0,00"
ENDIF

IF xICMS_RET > 0
	@ 51, 080  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
ELSE
	@ 51, 090  PSAY "0,00"
ENDIF

IF xVALOR_MERC > 0
	@ 51, 115  PSAY xVALOR_MERC + _nZfr Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
ELSE
	@ 51, 115  PSAY "0,00"
ENDIF

IF xFRETE > 0
	@ 53, 001  PSAY xFRETE      Picture"@E@Z 999,999,999.99"  // Valor do Frete
ELSE
	@ 53, 011  PSAY "0,00"
ENDIF

IF xSEGURO > 0
	@ 53, 028  PSAY xSEGURO     Picture"@E@Z 999,999,999.99"  // Valor Seguro
ELSE
	@ 53, 038  PSAY "0,00"
ENDIF

If mv_par04 == 2
	IF xDESP > 0
		@ 53, 062  PSAY xDESP       Picture"@E@Z 999,999,999.99"  // Valor Desp.acessorias // Vanderlei 16/03/06
	ELSE
		@ 53, 062  PSAY "0,00"
	ENDIF
Else
	@ 53, 062  PSAY "0,00"
Endif

IF xVALOR_IPI > 0
	@ 53, 080  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI
ELSE
	@ 53, 090  PSAY "0,00"
ENDIF

IF xTOT_FAT > 0
	@ 53, 115  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF
ELSE
	@ 53, 115  PSAY "0,00"
ENDIF

//+------------------------------------+
//& Impressao Dados da Transportadora  &
//+------------------------------------+

@ 56, 001  PSAY ALLTRIM(xNOME_TRANSP)            // Nome da Transport. // Vanderlei 16/02/06


If xTPFRETE=='C'                                 // Frete por conta do
	@ 56, 077 PSAY "1"                           // Emitente (1)
Else                                             //     ou
	@ 56, 077 PSAY "2"                           // Destinatario (2)
Endif

@ 56, 085 PSAY SC5->C5_PLACA                     // Res. p/Placa do Veiculo

@ 56, 101 PSAY xEST_TRANSP                       // U.F.

If !EMPTY(xCGC_TRANSP)                           // Se C.G.C. Transportador nao for Vazio
	@ 56, 110 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 56, 110 PSAY " "                               // Caso seja vazio
Endif


@ 58, 001 PSAY xEND_TRANSP                          // Endereco Transp.
@ 58, 065 PSAY xMUN_TRANSP                          // Municipio
@ 58, 101 PSAY xEST_TRANSP                          // U.F.

If !EMPTY(xINS_TRANSP)
	@ 58, 110 PSAY xINS_TRANSP
Else
	@ 58, 110 PSAY " "                                  // Reservado p/Insc. Estad.
EndIF

IF xVOLUME > 0
	@ 60, 005 PSAY xVOLUME  Picture "@E@Z 999,999.99"    // Quant. Volumes
ELSE
	@ 60, 005 PSAY "0,00"
ENDIF

@ 60, 022 PSAY xESPECIE                              // Especie

@ 60, 052 PSAY " "                                  // Res para Marca
@ 60, 075 PSAY " "                                  // Res para Numero


IF mv_par04 == 2
	IF xP_BRU_PED > 0
		@ 60, 098 PSAY xP_BRU_PED      Picture "@E@Z 999,999.99"
	ELSE
		@ 60, 098 PSAY xPESO_BRUTO     Picture "@E@Z 999,999.99"      // Res para Peso Bruto
	ENDIF
ELSE
	@ 60, 098 PSAY xPESO_BRUTO     Picture "@E@Z 999,999.99"      // Res para Peso Bruto
ENDIF

IF mv_par04 == 2
	IF xP_BRU_PED == 0 .AND. xPESO_BRUTO == 0
		@ 60, 098 PSAY "0,00"      // Res para Peso Bruto
	ENDIF
ENDIF

IF mv_par04 == 2
	IF xP_LIQ_PED > 0
		@ 60, 120 PSAY xP_LIQ_PED    Picture "@E@Z 999,999.99"      // Res para Peso Liquido
	ELSE
		@ 60, 120 PSAY xPESO_LIQUID    Picture "@E@Z 999,999.99"      // Res para Peso Liquido
	ENDIF
ELSE
	@ 60, 120 PSAY xPESO_LIQUID    Picture "@E@Z 999,999.99"      // Res para Peso Liquido
ENDIF

IF mv_par04 == 2
	IF xP_LIQ_PED == 0 .AND. xPESO_LIQUID == 0
		@ 60, 120 PSAY "0,00"      // Res para Peso Bruto
	ENDIF
ENDIF

If mv_par04 == 2
	nLin := 62//56
	Clasfis()               // Impressao de Classif. Fiscal
Endif

IF xBSICMRET > 0    //Se a Base ICMS Ret for maior que zero e substituicao tributaria
	@ 65, 001  PSAY "BASE DE CALCULO DO ICMS: R$ "  +  TRANSFORM(xBASE_ICMS, "@E@Z 999,999,999.99") 
	@ 66, 001  PSAY "ICMS DA OPERACAO PROPRIA: R$ " +  TRANSFORM(xVALOR_ICMS, "@E@Z 999,999,999.99") 
ENDIF


@ 71, 005 PSAY xNUM_NF                   // Numero da Nota Fiscal

@ 77, 138 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.
