#include "rwmake.ch"

//****************************************************************
// Programa : Mota fiscal de entrada e saida Certisign             *
// Data     : 29/01/05
// Autor    : Fábio Mendes                                       *
//****************************************************************

User Function NF_CERTI

SetPrc(0,0)                              // (Zera o Formulario)

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M,xCod_txt")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,XINS_INSEST,DESCRICAO")
SetPrvt("XNUM_NF,XSERIE,xSerieSE1,XEMISSAO,XTOT_FAT,XLOJA,XFRETE,XDESPESAS")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XITEM_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,xTS,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPED,XCLAS_PRO,XZONA_FRANCA")
SetPrvt("XPESO_BRUTO,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XLOJA_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI,XINSSAUX,XIRRFAUX")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF,xPIS,xCOFINS,xISS,xCSLL")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XDESC1,XDESC2,XDESC3,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XINS_TRANSP,XPRO_CLI,XSOMA_CFO")
SetPrvt("NCONT,NCOL,NTAMOBS,NAJUSTE,BB,XBASE_ISS,XVAL_ISS,xVALIRRF,_lReten,xFlag1,xCOFPIS,_var,XCOF")
SetPrvt("XMENOTA,xfab,NTOT_DEV,NNOT_DEV,NSER_DEV,NDAT_DEV,XPEDCLI,XOBSITEM")
SetPrvt("_nIrrf,_nCofins,_nPis,_nCsll,_nVliq ")

//****************************************************************
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³
//³ mv_par03             // Da Serie                             ³
//³ mv_par04             // Nota Fiscal de Entrada/Saida         ³
//****************************************************************


CbTxt    := cDesc2 := cDesc3 := cNatureza:= ""
CbCont   := xDesc1 := xDesc2 := xDesc3   := xDesc4 := " "
nOrdem   := Alfa   := Z      := M        := 0
tamanho  := "G"
limite   := 220
titulo   := PADC("Nota Fiscal de vendas ou devolucao",90)
cDesc1   := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",90)
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog := "NF_CERTI"
cPerg    := "NFSIGW"
nLastKey := nLin := xFlag1  := 0
lContinua:= .T.
wnrel    := "NF_CERTI"
nTamNf   := 90

//****************************************************************
// Verifica as perguntas selecionadas, busca o padrao da Nfiscal ³
//****************************************************************

Pergunte(cPerg,.F.)
cString:= "SF2"

//****************************************************************
//           Envia controle para a funcao SETPRINT               ³
//****************************************************************

wnrel:= SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//****************************************************************
//      Verifica Posicao do Formulario na Impressora             ³
//****************************************************************

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

//****************************************************************
//             Inicio do Processamento da Nota Fiscal            ³
//****************************************************************

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})
	Return
	Static Function RptDetail()
#ENDIF

If mv_par04 == 2
	dbSelectArea("SF2")                     // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                     // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant:= SD2->D2_PEDIDO
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	DbSeek(xFilial("SE1")+mv_par01+mv_par03,.t.)       //arauto
Else
	dbSelectArea("SF1")                      // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                      // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

SetRegua(Val(mv_par02)-Val(mv_par01))

// Nota fiscal de saida

If mv_par04 == 2
	
	dbSelectArea("SF2")
	
	While !Eof().and. SF2->F2_DOC<= mv_par02 .and. lContinua .and. xFilial() = SF2->F2_Filial
		
		If SF2->F2_SERIE # mv_par03
			DbSkip()
			Loop
		Endif
		
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua:= .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua:= .F.
				Exit
			Endif
		#ENDIF
		
		//****************************************************************
		//       Inicio de Levantamento dos Dados da Nota Fiscal         ³
		//****************************************************************
		
		// Cabecalho da Nota Fiscal
		
		xNUM_NF     := SF2->F2_DOC             // Numero
		xSERIE      := SF2->F2_SERIE           // Serie
		xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    := SF2->F2_VALFAT          // Valor Total da Fatura
		
		If xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+ SF2->F2_VALIPI+ SF2->F2_SEGURO+ SF2->F2_DESPESA+ SF2->F2_FRETE
		endif
		
		xLOJA       := SF2->F2_LOJA            // Loja do Cliente
		xFRETE      := SF2->F2_FRETE           // Frete
		xSEGURO     := SF2->F2_SEGURO          // Seguro
		xDESPESAS   := SF2->F2_DESPESA         // Despesas
		xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS := SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  := SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     := SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     := SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido
		xVAL_ISS    := SF2->F2_VALISS          // Valor do ISS
		xBASE_ISS   := SF2->F2_BASEISS         // Base de calculo para ISS
  //	xPIS        := SF2->F2_VALIMP6         // Valor do PIS
  //	xCOFINS     := SF2->F2_VALIMP5         // Valor do Cofins
		xVALIRRF    := SF2->F2_VALIRRF         // Valor do IRRF
	   xSerieSE1	:= If(!Empty(SF2->F2_DUPL), GetMv("MV_1DUPREF"), SF2->F2_SERIE) 
		
		// Cadastro de itens de vendas
		
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial()+ xNUM_NF+ xSERIE)
		
		cPedAtu    := SD2->D2_PEDIDO
		cItemAtu   := SD2->D2_ITEMPV
		xZONS_FRANC:= 0
		
		XSOMA_CFO  := {}                         // Para notas com mais de um e ate dois CFOP
		xPED_VEND  := {}                         // Numero do Pedido de Venda
		xITEM_PED  := {}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV  := {}                         // Numero da nota de devolucao; quando houver devolucao
		xPREF_DV   := {}                         // Serie  quando houver devolucao
		xITEM_DV   := {}                         // Item do nota de devolucao
		xICMS      := {}                         // Porcentagem do ICMS
		xCOD_PRO   := {}                         // Codigo do Produto
		xPRO_CLI   := {}                         // Codigo do produto no cliente
		xQTD_PRO   := {}                         // Peso/Quantidade do Produto
		xPRE_UNI   := {}                         // Preco Unitario de Venda
		xPRE_TAB   := {}                         // Preco Unitario de Tabela
		xIPI       := {}                         // Porcentagem do IPI
		xVAL_IPI   := {}                         // Valor do IPI
		xDESC      := {}                         // Desconto por Item
		xVAL_DESC  := {}                         // Valor do Desconto
		xVAL_MERC  := {}                         // Valor da Mercadoria
		xTES       := {}                         // TES
		xCF        := {}                         // Classificacao quanto natureza da Operacao
		xICMSOL    := {}                         // Base do ICMS Solidario
		xICM_PROD  := {}                         // ICMS do Produto
		xMeNota    := {}                         // Texto da nota fiscal
		
		// Armazena nos arrays correspondentes os itens da nota fiscal de saida
		
		While !Eof().And.SD2->D2_DOC==xNUM_NF.And.SD2->D2_SERIE==xSERIE
			
			If SD2->D2_SERIE <> mv_par03
				DbSkip()
				Loop
			Endif
			
			AADD(xPED_VEND , SD2->D2_PEDIDO)
			AADD(xITEM_PED , SD2->D2_ITEMPV)
			AADD(xNUM_NFDV , IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xPREF_DV  , SD2->D2_SERIORI)
			AADD(xITEM_DV  , SD2->D2_ITEMORI)
			AADD(xICMS     , IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xCOD_PRO  , Alltrim(SD2->D2_COD))
			AADD(xQTD_PRO  , SD2->D2_QUANT)
			AADD(xPRE_UNI  , SD2->D2_PRCVEN)
			AADD(xPRE_TAB  , SD2->D2_PRUNIT)
			AADD(xIPI      , IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			AADD(xVAL_IPI  , SD2->D2_VALIPI)
			AADD(xDESC     , SD2->D2_DESC)
			AADD(xVAL_MERC , SD2->D2_TOTAL)
			AADD(xTES      , SD2->D2_TES)
			AADD(xCF       , SD2->D2_CF)
			AADD(xICM_PROD , IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			
			xZONS_FRANC+= SD2->D2_DESCZFR
			
			dbskip()
		EndDo
		
		// Cadastro de produtos
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		
		xPESO_PRO   := {}                     // Peso Liquido
		xPESO_UNIT  := {}                     // Peso Unitario do Produto
		xDESCRICAO  := {}                     // Descricao do Produto
		xUNID_PRO   := {}                     // Unidade do Produto
		//xCOD_TRIB   := {}                     // Codigo de Tributacao
		xMEN_TRIB   := {}                     // Mensagens de Tributacao
		xCOD_FIS    := {}                     // Cogigo Fiscal
		xCLAS_FIS   := {}                     // Classificacao Fiscal
		xMEN_POS    := {}                     // Mensagem da Posicao IPI
		xISS        := {}                     // Aliquota de ISS
		xTIPO_PRO   := {}                     // Tipo do Produto
		xCLAS_PRO   := {}                     // Classificacao fiscal do produto
		xLUCRO      := {}                     // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   := {}                     // Classificacao fiscal
		xPESO_LIQ   := 0
		xPESO_BRUTO := 0
		I           := 1
		I1          := 0
		
		// Dados dos itens do produto
		
		For I:=1 to Len(xCOD_PRO)
			dbSeek(xFilial()+xCOD_PRO[I])
			
			AADD(xPESO_PRO , SB1->B1_PESO * xQTD_PRO[I])
			AADD(xPESO_UNIT, SB1->B1_PESO)
			AADD(xUNID_PRO , SB1->B1_UM)
			AADD(xDESCRICAO, SB1->B1_DESC)
			// AADD(xCOD_TRIB , SB1->B1_ORIGEM)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)== 0
				AADD(xMEN_TRIB , SB1->B1_ORIGEM)
			Endif
			
			npElem:= ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			if npElem == 0
				AADD(xCLAS_FIS, SB1->B1_POSIPI)
			endif
			
			npElem:= ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
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
				CASE npElem == 7
					_CLASFIS := "G"
				CASE npElem == 8
					_CLASFIS := "H"
				CASE npElem == 9
					_CLASFIS := "I"
				Otherwise
					_CLASFIS := " "
			ENDCASE
			
			AADD(XCLAS_PRO, _CLASFIS )
			
			nPteste:= Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0.And._CLASFIS <> " "
				AADD(xCLFISCAL,_CLASFIS)
				++I1
			Endif
			
			AADD(xCOD_FIS , _CLASFIS)
			AADD(xISS     , SB1->B1_ALIQISS)
			AADD(xTIPO_PRO, SB1->B1_TIPO)
			AADD(xLUCRO   , SB1->B1_PICMRET)
			
		Next
		
		// Pedidos de Venda
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		xPED     := {}
		xCod_Txt := {}
		xPedCli  := " "  // Para pedido do cliente na observacao da nota fiscal
		
		// Carrega arrays com dados do pedido de venda
		For I:=1 to Len(xPED_VEND)
			dbSeek(xFilial()+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])== 0
				dbSeek(xFilial()+ xPED_VEND[I])
				xCLIENTE    := SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI   := SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   := SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				
				If !Empty(Substr(SC5->C5_MENNOTA,1,50))
					Aadd(xMeNota,Substr(SC5->C5_MENNOTA,1,50))
				EndIf
				If !Empty(Substr(SC5->C5_MENNOTA,51,50))
					Aadd(xMeNota,Substr(SC5->C5_MENNOTA,51,50))
				EndIf
				If !Empty(Substr(SC5->C5_MENNOTA,101,50))
					Aadd(xMeNota,Substr(SC5->C5_MENNOTA,101,50))
				EndIf
				If !Empty(Substr(SC5->C5_MENNOTA,151,50))
					Aadd(xMeNota,Substr(SC5->C5_MENNOTA,151,50))
				Endif
				If !Empty(Substr(SC5->C5_MENNOTA,201,50))
					Aadd(xMeNota,Substr(SC5->C5_MENNOTA,201,50))
				Endif
				If !Empty(Substr(SC5->C5_MENNOTA,251,50))
					Aadd(xMeNota,Substr(SC5->C5_MENNOTA,251,50))
				Endif
				If !Empty(Substr(SC5->C5_MENNOTA,301,50))
					Aadd(xMeNota,Substr(SC5->C5_MENNOTA,301,50))
				EndIf
				
				//xMENSAGEM   := SC5->C5_MENNOTA                  // Mensagem para a Nota Fiscal
				
				xTPFRETE    := SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    := SC5->C5_CONDPAG            // Condicao de Pagamento
				xPESO_BRUTO := SC5->C5_PBRUTO             // Peso Bruto
				xPESO_LIQ   := SC5->C5_PESOL              // Peso Liquido
				xCOD_VEND   := {SC5->C5_VEND1,;           // Codigo do Vendedor 1
				SC5->C5_VEND2,;                           // Codigo do Vendedor 2
				SC5->C5_VEND3,;                           // Codigo do Vendedor 3
				SC5->C5_VEND4,;                           // Codigo do Vendedor 4
				SC5->C5_VEND5}                            // Codigo do Vendedor 5
				xDESC_NF    := {SC5->C5_DESC1,;           // Desconto Global 1
				SC5->C5_DESC2,;                           // Desconto Global 2
				SC5->C5_DESC3,;                           // Desconto Global 3
				SC5->C5_DESC4}                            // Desconto Global 4
				
				// Numero do pedido do cliente
				//If At(AllTrim(SC5->C5_COTCLI),xPedcli)= 0 .And.!Empty(SC5->C5_COTCLI)
				//   xPedCli+= AllTrim(SC5->C5_COTCLI) + " "
				//EndIf
				
				AADD(xPED,xPED_VEND[I])
			Endif
			
		Next
		
		If !Empty(xPedCli)
			Aadd(xMeNota,"PEDIDO DO CLIENTE: " + AllTrim(xPedCli))
		EndIf
		
		// Condicao de Pagamento
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+ xCONDPAG)
		
		xDESC_PAG:= SE4->E4_DESCRI
		
		// Itens de Pedido de Venda
		dbSelectArea("SC6")
		dbSetOrder(1)
		
		xfab     := {}       	 				// Descricao aux do produto
		xPED_CLI := {}                          // Numero de Pedido
		xDESC_PRO:= {}                          // Descricao aux do produto
		xCOD_TRIB:= {}                          // Codigo de Tributacao
		xObsItem := {}                          // Observacao do item do pedido
		
		J:= Len(xPED_VEND)
		
		For I:=1 to J
			dbSeek(xFilial()+ xPED_VEND[I]+ xITEM_PED[I])
			//AADD(xPED_CLI , SC6->C6_PEDCLI)
			AADD(xDESC_PRO, alltrim (SC6->C6_DESCRI))
			//AADD(xfab , alltrim(SC6->C6_DESCRI))
			AADD(xVAL_DESC, SC6->C6_VALDESC)
			AADD(xCOD_TRIB, SC6->C6_CLASFIS)
			//AADD(xOBSITEM , SC6->C6_OBSITEM)
		Next
		
		If xTIPO=='N'.OR.xTIPO=='C'.OR.xTIPO=='P'.OR.xTIPO=='I'.OR.xTIPO=='S'.OR.xTIPO=='T'.OR.xTIPO=='O'
			
			dbSelectArea("SA1")                 // Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+ xCLIENTE+ xLOJA)
			
			xCOD_CLI  := SA1->A1_COD             // Codigo do Cliente
			xLOJA_CLI := SA1->A1_LOJA            // Loja cliente
			xNOME_CLI := SA1->A1_NOME            // Nome
			xEND_CLI  := SA1->A1_END             // Endereco
			xBAIRRO   := SA1->A1_BAIRRO          // Bairro
			xCEP_CLI  := SA1->A1_CEP             // CEP
			xCOB_CLI  := SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI  := SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI  := SA1->A1_MUN             // Municipio
			xEST_CLI  := SA1->A1_EST             // Estado
			xCGC_CLI  := AllTrim(SA1->A1_CGC)    // CGC
			xINSC_CLI := SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI := SA1->A1_TRANSP          // Transportadora
			xTEL_CLI  := SA1->A1_TEL             // Telefone
			xFAX_CLI  := SA1->A1_FAX             // Fax
			xSUFRAMA  := SA1->A1_SUFRAMA         // Codigo Suframa
			xCALCSUF  := SA1->A1_CALCSUF         // Calcula Suframa
			
			// Alteracao p/ Calculo de Suframa
			
			if !Empty(xSUFRAMA).and.xCALCSUF=="S"
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
			
			dbSelectArea("SA2")                  // Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			
			xCOD_CLI  := SA2->A2_COD             // Codigo do Fornecedor
			xLOJA_CLI := SA2->A2_LOJA            // Loja fornecedor
			xNOME_CLI := SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI  := SA2->A2_END             // Endereco
			xBAIRRO   := SA2->A2_BAIRRO          // Bairro
			xCEP_CLI  := SA2->A2_CEP             // CEP
			xCOB_CLI  := ""                      // Endereco de Cobranca
			xREC_CLI  := ""                      // Endereco de Entrega
			xMUN_CLI  := SA2->A2_MUN             // Municipio
			xEST_CLI  := SA2->A2_EST             // Estado
			xCGC_CLI  := AllTrim(SA2->A2_CGC)    // CGC
			xINSC_CLI := SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI := SA2->A2_TRANSP          // Transportadora
			xTEL_CLI  := SA2->A2_TEL             // Telefone
			xFAX_CLI  := SA2->A2_FAX             // Fax
		Endif
		
		dbSelectArea("SA3")                      // Cadastro de Vendedores
		dbSetOrder(1)
		
		xVENDEDOR:= {}                           // Nome do Vendedor
		I        := 1
		J        := Len(xCOD_VEND)
		
		For I:=1 to J
			dbSeek(xFilial()+ xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET > 0                         // Apenas se ICMS Retido > 0
			
			dbSelectArea("SF3")                  // Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			
			If Found()
				xBSICMRET:= F3_VALOBSE
			Else
				xBSICMRET:= 0
			Endif
		Else
			xBSICMRET:= 0
		Endif
		
		dbSelectArea("SA4")		                  // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_TRANSP)
		
		xNOME_TRANSP := SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  := SA4->A4_END            // Endereco
		xMUN_TRANSP  := SA4->A4_MUN            // Municipio
		xEST_TRANSP  := SA4->A4_EST            // Estado
		xVIA_TRANSP  := SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  := SA4->A4_CGC            // CGC
		xINS_TRANSP  := SA4->A4_INSEST         // Inscricao estadual
		xTEL_TRANSP  := SA4->A4_TEL            // Fone
		
		dbSelectArea("SE1")                    // * Contas a Receber
		dbSetOrder(1)
		DbSeek(xFilial("SE1")+xSERIE + xNUM_DUPLIC,.T.)       //arauto
				
		If found()
			xDUPLICATAS := .T.
		Else
			xDUPLICATAS := .F.
		EndIf
		
		xPARC_DUP   := {}                       // Parcela
		xVENC_DUP   := {}                       // Vencimento
		xVALOR_DUP  := {}                       // Valor
   	xInssAux    := 0
		XIrrfAux    := 0
	 	_nCSLL      := 0
	 	_nPIS 		:= 0
	 	_nCOFINS  	:= 0	
	 	_nIrrf   	:= 0   
		//	xDUPLICATAS := IIF(dbSeek(xFilial()+ xSERIE+ xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

		_nIrrf    := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"IR-","E1_VALOR")//	POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC+" "+"IR-","E1_VALOR")
		_nCSLL    := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"CS-","E1_VALOR")
		_nPIS     := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"PI-","E1_VALOR")                                                                                                                        
		_nCOFINS  := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"CF-","E1_VALOR")
   	
		// Carrega arrays com duplicatas
		While !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO) 
			AADD(xVALOR_DUP,SE1->E1_VALOR - (SE1->E1_IRRF + SE1->E1_INSS + SE1->E1_PIS + SE1->E1_COFINS + SE1->E1_CSLL ))//+ SE1 -> E1_ISS))
			xInssAux += SE1->E1_INSS
				    
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")               // Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+ xTES[1])
		
		xNATUREZA:= SF4->F4_TEXTO         // Natureza da Operacao
		
		Imprime()
		
		IncRegua()
		
		dbSelectArea("SF2")
		dbSkip()                          // passa para a proxima Nota Fiscal
		
	EndDo
Else
	
	dbSelectArea("SF1")                  // Cabecalho da Nota Fiscal Entrada
	dbSeek(xFilial()+ mv_par01+ mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		If SF1->F1_SERIE # mv_par03
			DbSkip()
			Loop
		Endif
		
		SetRegua(Val(mv_par02)- Val(mv_par01))
		
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
		
		//****************************************************************
		//       Inicio de Levantamento dos Dados da Nota Fiscal         ³
		//****************************************************************
		
		// Cabecalho da Nota Fiscal
		
		xNUM_NF     := SF1->F1_DOC             // Numero
		xSERIE      := SF1->F1_SERIE           // Serie
		xFORNECE    := SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    := SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    := SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       := SF1->F1_LOJA            // Loja do Cliente
		xFRETE      := SF1->F1_FRETE           // Frete
		xSEGURO     := SF1->F1_SEGURO          // Seguro
		xDESPESAS   := SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  := SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   := SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   := SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS := SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   := SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  := SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC := SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC := SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   := SF1->F1_COND            // Condicao de Pagamento
		xTIPO       := SF1->F1_TIPO            // Tipo do Cliente
		//xNFORI    := SF1->F1_NFORI           // NF Original
		//xPREF_DV  := SF1->F1_SERIORI         // Serie Original
		
		
		
		dbSelectArea("SD1")                    // Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+ xNUM_NF+ xSERIE+ xFORNECE+ xLOJA)
		
		cPedAtu   := SD1->D1_PEDIDO
		cItemAtu  := SD1->D1_ITEMPC
		
		xPEDIDO   := {}                         // Numero do Pedido de Compra
		xITEM_PED := {}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV := {}                         // Numero quando houver devolucao
		xPREF_DV  := {}                         // Serie  quando houver devolucao
		xITEM_DV  := {}                         // Item da nota de devolucao
		xICMS     := {}                         // Porcentagem do ICMS
		xCOD_PRO  := {}                         // Codigo  do Produto
		xQTD_PRO  := {}                         // Peso/Quantidade do Produto
		xPRE_UNI  := {}                         // Preco Unitario de Compra
		xIPI      := {}                         // Porcentagem do IPI
		xPESOPROD := {}                         // Peso do Produto
		xVAL_IPI  := {}                         // Valor do IPI
		xDESC     := {}                         // Desconto por Item
		xVAL_DESC := {}                         // Valor do Desconto
		xVAL_MERC := {}                         // Valor da Mercadoria
		xTES      := {}                         // TES
		xCF       := {}                         // Classificacao quanto natureza da Operacao
		xICMSOL   := {}                         // Base do ICMS Solidario
		xICM_PROD := {}                         // ICMS do Produto
		
		// Carrega itens com dados dos itens da nota fiscal de devolucao
		
		While !eof() .and. SD1->D1_DOC== xNUM_NF
			If SD1->D1_SERIE # mv_par03
				DbSkip()
				Loop
			Endif
			
			AADD(xPEDIDO   , SD1->D1_PEDIDO)         // Ordem de Compra
			AADD(xITEM_PED , SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV , IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  , SD1->D1_SERIORI)        // Serie Original
			AADD(xITEM_DV  , SD1->D1_ITEMORI)        // Item Original
			AADD(xICMS     , IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  , SD1->D1_COD)            // Produto
			AADD(xQTD_PRO  , SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xPRE_UNI  , SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      , SD1->D1_IPI)            // % IPI
			AADD(xVAL_IPI  , SD1->D1_VALIPI)         // Valor do IPI
			AADD(xPESOPROD , SD1->D1_PESO)           // Peso do Produto
			AADD(xDESC     , SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC , SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      , SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       , SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD , IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			dbskip()
		End
		
		dbSelectArea("SB1")                     // Desc. Generica do Produto
		dbSetOrder(1)
		
		xUNID_PRO := {}                         // Unidade do Produto
		xDESC_PRO := {}                         // Descricao do Produto
		xMEN_POS  := {}                         // Mensagem da Posicao IPI
		xDESCRICAO:= {}                         // Descricao do Produto
		xTS       := {}                         // TES
		xIR       := {}							// IR
		xCOD_TRIB := {}                         // Codigo de Tributacao
		xMEN_TRIB := {}                         // Mensagens de Tributacao
		xCOD_FIS  := {}                         // Cogigo Fiscal
		xCLAS_FIS := {}                         // Classificacao Fiscal
		xISS      := {}                         // Aliquota de ISS
		xTIPO_PRO := {}                         // Tipo do Produto
		xCOF      := {}                         // Aliquota do COFINS
		xCLAS_PRO := {}                         // Classificacao fiscal produto
		xLUCRO    := {}                         // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL := {}
		xSUFRAMA  := ""
		xCALCSUF  := ""
		I := 1
		I1:= 0
		
		// Carrega arrays com dados do produto
		For I:=1 to Len(xCOD_PRO)
			dbSeek(xFilial()+ xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO, SB1->B1_DESC)
			AADD(xUNID_PRO, SB1->B1_UM)
			AADD(xCOD_TRIB, SB1->B1_ORIGEM)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB, SB1->B1_ORIGEM)
			Endif
			
			AADD(xDESCRICAO, SB1->B1_DESC)
			AADD(xTS, SB1->B1_TS)
			AADD(xMEN_POS  , SB1->B1_POSIPI)
			AADD(xISS, SB1->B1_ALIQISS)
			AADD(xTIPO_PRO, SB1->B1_TIPO)
			AADD(xLUCRO   , SB1->B1_PICMRET)
			AADD(xCOF, SB1->B1_COFINS)
			
			npElem:= ascan(xCLAS_FIS, SB1->B1_POSIPI)
			
			if npElem == 0
				AADD(xCLAS_FIS, SB1->B1_POSIPI)
			endif
			
			npElem:= ascan(xCLAS_FIS, SB1->B1_POSIPI)
			
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
				CASE npElem == 7
					_CLASFIS :="G"
				CASE npElem == 8
					_CLASFIS := "H"
				CASE npElem == 9
					_CLASFIS := "I"
				Otherwise
					_CLASFIS := " "
			EndCase
			
			AADD(XCLAS_PRO, _CLASFIS)
			
			nPteste:= Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0.And. _CLASFIS <> " "
				AADD(xCLFISCAL,_CLASFIS)
				++I1
			Endif
			
			AADD(xCOD_FIS ,_CLASFIS)
		Next
		
		dbSelectArea("SC7")                     // Pedidos de Compra
		dbSetOrder(1)
		
		// Carrega arrays com dados do pedido de venda
		For I:=1 to Len(xPEDIDO)
			Set SoftSeek On
			DbSeek(xFilial("SC7")+xPEDIDO[I]+ xITEM_PED[I])
			Set SoftSeek Off
			
			If !Eof()
				AADD(xDESC_PRO, SC7->C7_DESCRI)
			EndIf
			
		Next
		
		dbSelectArea("SE4")                     // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+ xCOND_PAG)
		
		xDESC_PAG:= SE4->E4_DESCRI
		
		If xTIPO == "D"
			
			dbSelectArea("SA1")                 // Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE)
			
			xCOD_CLI := SA1->A1_COD             // Codigo do Cliente
			xLOJA_CLI:= SA1->A1_LOJA            // Loja do cliente
			xNOME_CLI:= SA1->A1_NOME            // Nome
			xEND_CLI := SA1->A1_END             // Endereco
			xBAIRRO  := SA1->A1_BAIRRO          // Bairro
			xCEP_CLI := SA1->A1_CEP             // CEP
			xCOB_CLI := SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI := SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI := SA1->A1_MUN             // Municipio
			xEST_CLI := SA1->A1_EST             // Estado
			xCGC_CLI := AllTrim(SA1->A1_CGC)   // CGC
			xINSC_CLI:= SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:= SA1->A1_TRANSP          // Transportadora
			xTEL_CLI := SA1->A1_TEL             // Telefone
			xFAX_CLI := SA1->A1_FAX             // Fax
		Else
			
			dbSelectArea("SA2")                 //  Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			
			xCOD_CLI  := SA2->A2_COD             // Codigo do Cliente
			xLOJA_CLI := SA2->A2_LOJA            // Loja do Fornecedor
			xNOME_CLI := SA2->A2_NOME            // Nome
			xEND_CLI  := SA2->A2_END             // Endereco
			xBAIRRO   := SA2->A2_BAIRRO          // Bairro
			xCEP_CLI  := SA2->A2_CEP             // CEP
			xCOB_CLI  := ""                      // Endereco de Cobranca
			xREC_CLI  := ""                      // Endereco de Entrega
			xMUN_CLI  := SA2->A2_MUN             // Municipio
			xEST_CLI  := SA2->A2_EST             // Estado
			xCGC_CLI  := AllTrim(SA2->A2_CGC)    // CGC
			xINSC_CLI := SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI := SA2->A2_TRANSP          // Transportadora
			xTEL_CLI  := SA2->A2_TEL             // Telefone
			xFAX      := SA2->A2_FAX             // Fax
		EndIf
		
		dbSelectArea("SE1")                      // Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  := {}                         // Parcela
		xVENC_DUP  := {}                         // Vencimento
		xVALOR_DUP := {}                         // Valor
		xDUPLICATAS:= IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		// Carrega arrays com duplicatas
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR - (SE1->E1_IRRF + SE1->E1_INSS + SE1->E1_PIS + SE1->E1_COFINS + SE1->E1_CSLL ))
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		xNOME_TRANSP := " "                    // Nome Transportadora
		xEND_TRANSP  := " "                    // Endereco
		xMUN_TRANSP  := " "                    // Municipio
		xEST_TRANSP  := " "                    // Estado
		xVIA_TRANSP  := " "                    // Via de Transporte
		xCGC_TRANSP  := " "                    // CGC
		xINS_INSEST  := " "                    // INSCR.ESTADUAL
		xTEL_TRANSP  := " "                    // Fone
		xTPFRETE     := " "                    // Tipo de Frete
		xVOLUME      := 0                      // Volume
		xESPECIE     := " "                    // Especie
		xPESO_LIQ    := 0                      // Peso Liquido
		xPESO_BRUTO  := 0                      // Peso Bruto
		xCOD_MENS    := " "                    // Codigo da Mensagem
		xCOD_TXT     := " "                    // Codigo texto padrao
		xMENSAGEM    := " "                    // Mensagem da Nota
		
		Imprime()
		
		IncRegua()
		
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")

Set Device To Screen  

Setpgeject (.T.)

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

//****************************************************************
//                   Verificacao da impressao                    ³
//****************************************************************

Static Function VerImp()

nLin   := 0
If aReturn[5]== 2
	nOpc:= 1
	
	#IFNDEF WINDOWS
		cCor:= "B/BG"
	#ENDIF
	
	While .T.
	   	SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY "."
		@ nLin ,004 PSAY "."
		@ nLin ,022 PSAY "."
		
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 PSAY "Formulario esta posicionado?"
			nOpc:= Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc  := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		
		Do Case
			Case nOpc== 1
				lContinua:= .t.
				Exit
			Case nOpc== 2
				Loop
			Case nOpc== 3
				lContinua:= .f.
				Return
		EndCase
	End
Endif

Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CLASFIS  ³ Autor ³   Fabio Mendes       ³ Data ³ 03/11/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Array com as Classificacoes Fiscais           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function IMPOSTO()

xCOFPIS  := _nCOFINS +_nPIS +_nCSLL  
nTamObs  := 150
nCol     := 15
_var     := _nIrrf             


If  Empty (xCOFPIS)

	If  Empty (_nIrrf)
		@ 41, nCol PSAY "IRRF .... R$ 0,00"
	else     
		@ 41, nCol PSAY "IRRF   R$...."
	 	@ 41, nCol PSAY _var Picture "@E 999,999.99"
	endif
	
	 nlin:= nlin + 1 
	             
    If  Empty (xCOFPIS)
	   	@ 42, nCol PSAY  "COFINS  PIS CSLL  .. R$ 0,00"    
	else  
	  	@ 42, nCol PSAY	 "COFINS  PIS CSLL   R$..  "   
   	    @ 42, nCol PSAY  xCOFPIS Picture "@E 999,999.99"
   	    
    endif	
   	
else
	
	If  Empty (_nIrrf)
		@ 41, nCol PSAY "IRRF .... R$ 0,00"
	else
	    @ 41, nCol PSAY "IRRF   R$...."
	 	@ 41, nCol +10 PSAY _var Picture "@E 999,999.99"
	endif
	
   nlin:= nlin + 1 
	             
   // If  Empty (_nCofins)                      
	 If  Empty  (xCOFPIS)
	   @ 42, nCol PSAY "COFINS  PIS CSLL .. R$ 0,00"    
	else
	  	@ 42, nCol PSAY "COFINS  PIS CSLL   R$..  "   
   	    @ 42, nCol PSAY xCOFPIS Picture "@E 999,999.99"
    Endif     

endif	

Return

Static Function SIMP()

nTamObs:=150
nCol:=17

Return 


//****************************************************************
//                   Impressao da nota fiscal                    ³
//****************************************************************

Static Function Imprime()

Cabecalho()
ImpDet()
Desc()
PrestSer()
IMPOSTO() 
Clasfis()
SIMP()
TotNota()


Return

//****************************************************************
//                   Impressao da nota fiscal                    ³
//****************************************************************

Static Function Cabecalho()

nLin:= 2   
// Deslocamento lateral desde a serrilha do formulario serrilha= 0

@ nLin, 000 PSAY Chr(15)                                // Compacta caracteres

	@ 004, 087 PSAY xEMISSAO                               // Data da Emissao do Documento
   
    nlin+= 2
   
    @ 005, 086 PSAY xNATUREZA                              // Texto da Natureza de Operacao
    
    nlin+= 1
    
    @ nlin, 001 PSAY "PEDIDO : " + AllTrim(SC5 -> C5_NUM)                      // Numero do Pedido

nLin+= 2

	@ nLin, 001 PSAY xNOME_CLI                              // Nome do Cliente
    
If !EMPTY(xCGC_CLI)                                     // Se o C.G.C. do Cli/Forn nao for Vazio
//	@ nLIn, 113 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
	If Len(xCGC_CLI) == 14
		@ 09, 86 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"		
	Else
		@ 09, 86 PSAY xCGC_CLI Picture"@R 999.999.999-99"					
	EndIf	
Else
	@ nLIn, 113 PSAY " "                                // Caso seja vazio
Endif    

    nlin+= 2 
	
	@ nLin, 001 PSAY xEND_CLI                               // Endereco
	@ nLin, 075 PSAY xBAIRRO                                // Bairro
   @ nLin, 113 PSAY xCEP_CLI Picture "@R 99999-999"        // CEP

	nLin+= 2

	@ nLin, 001 PSAY xMUN_CLI                               // Municipio
	@ nLin, 052 PSAY xTEL_CLI                               // Telefone/FAX
	@ nLin, 075 PSAY xEST_CLI                               // U.F.
	@ nLin, 084 PSAY xINSC_CLI                              // Insc. Estadual

//****************************************************************
//         Inicio da Impressao dos Dados da Nota Fiscal          ³
//****************************************************************


Static Function IMPDET()

nTamDet:= 100           // Tamanho da Area de Detalhe
W      := 1             // Controle de While
J      := 11            // Controla o total de linhas que faltam completas as 16 impressas
Z      := 0             // Controla o numero de continuacao de notas
xDesc1 := xDesc2 := xDesc3 := xDesc4 := " "

While W<=Len(xCOD_PRO)
	// ISS somente no campo de prestacao de servico da nota fiscal
	   //	If xISS[W]== 0 
		If Sb1->B1_TIPO <> "SV"  
			descricao := xDESC_PRO[W]
				
			xDesc1 := subs(descricao,1,60)
			xDesc2 := subs(descricao,61,121)
			xDesc3 := subs(descricao,181,200)
				
			If !Empty(xDesc1)
				@ nLin, 001 PSAY  Alltrim(xDesc1)
			Endif
			If !Empty(xDesc2)
				nLin := nLin + 1
				@ nLin, 001 PSAY  Alltrim(xDesc2)
			EndIf
			If !Empty(xDesc3)
				nLin := nLin + 1
				@ nLin, 001 PSAY  Alltrim(xDesc3)
			EndIf
				
			// Nota fiscal de saida
	   	//	@ ++nLin, 001  PSAY xCOD_PRO[W]
       	// @   016, 001  PSAY xDESC_PRO[W]
	   	//	@   nLin, 064  PSAY xCLAS_PRO[W]
	   	//	@   nLin, 069  PSAY xCOD_TRIB[W]
			@   016, 056  PSAY xUNID_PRO[W]
   		@   016, 068  PSAY xQTD_PRO[W]   Picture "@E 9,999"
	    	@   016, 084  PSAY xPRE_UNI[W]   Picture "@E 99,999,999.99"
	    	@   016, 115  PSAY xVAL_MERC[W]  Picture "@E 99,999,999.99"
	   	//	@   nLin, 118  PSAY xICM_PROD[W]  Picture "99"
			// @   nLin, 121  PSAY xIPI[W]       Picture "99"
	   	//	@   nLin, 125  PSAY xVAL_IPI[W]   Picture "@E 9,999,999.99"
			W:= W+1
			J:= J-1
			Z:= Z+1
	  Else
			W := W+1
	EndIf
	
	If Z > 15
		PrestSer()  // Prestacao de servicos
		RodapeNF()  // Rodape da nota fiscal
		Cabecalho() // Cabecalho da nota fiscal 
	
		J = 16
		Z = 0
	EndIf
EndDo

If xCALCSUF= "S"
	If Z>14
		PrestSer()
		RodapeNF()
		Cabecalho()
	
		
		J= 16
	EndIf
	@ ++nLin, 037 PSAY "Desconto Zona Franca R$ "
	@   nLin, 061 PSAY xZONS_FRANC Picture "@E 9,999.99"
	J=J-1
EndIf

nLin+= J+1

Return
           

Static Function Desc()
  
   nlin:=14

	@   nlin, 074  PSAY "QTD."
    @   nlin, 085  PSAY "VLR.UNIT."       
    
Return    
//****************************************************************
//                    Prestacao de servicos                      ³
//****************************************************************

Static Function PrestSer()

nLin = 16
nLin2 := nLin - 1
I     := 0
J     := 0
xDesc1 := xDesc2 := xDesc3 := xDesc4 := " "

If mv_par04 == 2.And.Len(xISS) > 0
	For I:= 1 To Len(xISS) // 5  // Trocar aqui
		++J
		If I<= Len(xISS)
		   //	If xISS[I]<> 0
			If Sb1->B1_TIPO == "SV"	
				descricao := xDESC_PRO[I]
				
				xDesc1 := subs(descricao,1,60)
				xDesc2 := subs(descricao,61,121)
				xDesc3 := subs(descricao,181,200)
				
				If !Empty(xDesc1)
					@ nLin2, 001 PSAY  Alltrim(xDesc1)
				Endif
				If !Empty(xDesc2)
					nLin2 := nLin2 + 1
					@ nLin2, 001 PSAY  Alltrim(xDesc2)
				EndIf
				If !Empty(xDesc3)
					nLin2 := nLin2 + 1
					@ nLin2, 001 PSAY  Alltrim(xDesc3)
				EndIf
				
			
				@   nLin2, 068 PSAY  xQTD_PRO[I]  Picture "@E 999,999.99"
				@   nLin2, 084 PSAY  xPRE_UNI[I]  Picture "@E 999,999.99"
				@   nLin2, 115 PSAY  xVAL_MERC[I] Picture "@E 99,999,999.99"
				
				nLin2 := nLin2 + 1
				
				
			EndIf
			
			J:=J+1
		EndIf
		/*
		Do Case
		Case J= 3
		@ 034, 124 PSAY xVal_ISS Picture "@E@Z 9,999,999.99"   // Valor do Servico
		Case J= 5
		nLin2 := nLin2 + 4
		@ nlin2, 124 PSAY xBase_ISS Picture "@E@Z 9,999,999.99"   // Base de calculo do Servico
		EndCase
		*/
	Next I
EndIf

//@ 034, 124 PSAY xVal_ISS Picture "@E@Z 9,999,999.99"       // Valor do Servico
//nLin2 := nLin2 + 4
//@ nlin2, 124 PSAY xBase_ISS Picture "@E@Z 9,999,999.99"    // Base de calculo do Servico

//nLin+=2 // alterado 10 para 2

Return

//****************************************************************
//                    Rodape da nota fiscal                      ³
//****************************************************************

Static function RodapeNF()

@ ++nlin, 008  PSAY "***,***,***.**"  // Base do ICMS
@   nlin, 036  PSAY "***,***,***.**"  // Valor do ICMS
@   nlin, 067  PSAY "***,***,***.**"  // Base ICMS Ret.
@   nlin, 095  PSAY "***,***,***.**"  // Valor  ICMS Ret.
//@   nlin, 128  PSAY "***,***,***.**"  // Valor Tot. Prod.
nLin+= 1
@ nLin, 008  PSAY "***,***,***.**"  // Valor do Frete
@ nLin, 036  PSAY "***,***,***.**"  // Valor Seguro
@ nLin, 067  PSAY "***,***,***.**"  // Valor outras despesas
@ nLin, 095  PSAY "***,***,***.**"  // Valor do IPI
@ nLIn, 124  PSAY "***,***,***.**"  // Valor Total NF



Return .t.

//****************************************************************
//                   Impressao do total da nota                  ³
//****************************************************************

Static Function TotNota()
/*nlin := nlin + 1
@ ++ nlin, 008  PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS
@   nlin, 036   PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
@   nlin, 067   PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
@   nlin, 095   PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.

@   nlin, 122  PSAY  xBASE_ICMS Picture "@E@Z 999,999,999.99"   // Valor Tot. Prod.
nLin+= 1
@ nLin, 008  PSAY xFRETE      Picture "@E@Z 999,999,999.99"     // Valor do Frete
@ nLin, 036  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"     // Valor Seguro
@ nLin, 067  PSAY xDESPESAS   Picture "@E@Z 999,999,999.99"     // Valor outras despesas
@ nLin, 095  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"     // Valor do IPI  */

@ 055, 102 PSAY SB1->B1_ALIQISS                                 // Aliquota do ISS
@ 055, 115  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"     // Valor Total NF


Return .t.                  

//****************************************************************
//                 Impressao da transportadora                   ³
//****************************************************************

Static Function ImTransp()

/*nLin+=3
@ nLin, 001  PSAY xNOME_TRANSP                              // Nome da Transport.

If xTPFRETE=='C'                                            // Frete por conta do
	@ nLin, 078 PSAY "1"                                    // Emitente (1)
Else                                                        //     ou
	@ nLIn, 078 PSAY "2"                                    // Destinatario (2)
Endif

@ nLin, 090 PSAY " "                                        // Res. p/Placa do Veiculo
@ nLin, 106 PSAY xEST_TRANSP                                // U.F.

If !EMPTY(xCGC_TRANSP)                                      // Se C.G.C. Transportador nao for Vazio
	@ nLin, 114 PSAY xCGC_TRANSP Picture "@R 99.999.999/9999-99"
Else
	@ nLin, 114 PSAY " "                                     // Caso seja vazio
Endif

nLin+= 3
@ nLin, 001 PSAY xEND_TRANSP                                // Endereco Transp.
@ nLin, 063 PSAY xMUN_TRANSP                                // Municipio
@ nLin, 104 PSAY xEST_TRANSP                                // U.F.
@ nLin, 110 PSAY xINS_INSEST                                // Reservado p/Insc. Estad.
nLin+= 2
@ nLin, 009 PSAY xVOLUME  Picture "@E@Z 999,999.99"         // Quant. Volumes
@ nLin, 029 PSAY xESPECIE Picture "@!"                      // Especie
@ nLin, 057 PSAY " "                                        // Res para Marca
@ nLin, 083 PSAY " "                                        // Res para Numero
@ nLin, 110 PSAY xPESO_BRUTO Picture "@E@Z 999,999.999"     // Res para Peso Bruto
@ nLin, 140 PSAY xPESO_LIQ   Picture "@E@Z 999,999.999"     // Res para Peso Liquido

nLin+= 1

//  Rotina para buscar a nota fiscal de devolucao

nTot_Dev := 0
nNot_Dev := 0
nSer_Dev := 0
nDat_Dev := 0
I        := 0

For I=1 To Len(xNUM_NFDV)
	If !Empty(xNUM_NFDV[I])
		DbSelectArea("SF1")
		DbSetOrder(1)
		
		Set SoftSeek On
		DbSeek(xFilial("SF1")+xNUM_NFDV[I]+xPREF_DV[I]+xCOD_CLI+xLOJA_CLI+xCOD_PRO[I])
		Set SoftSeek Off
		
		If !Eof()
			nTot_Dev += SF1->F1_VALMERC
			nNot_Dev  = SF1->F1_DOC
			nSer_Dev  = SF1->F1_SERIE
			nDat_Dev  = SF1->F1_EMISSAO
		EndIf
	Endif
Next

If nTot_Dev <> 0
	@ ++nLin, 050 PSAY nNot_Dev + " " + nSer_Dev
	@   nLin, 070 PSAY nDat_Dev
	@   nLin, 090 PSAY xVALOR_MERC Picture "@E 999,999.99"
Else
	++nLin
EndIf

// Rotina para impressao dos dados Suframa

If !Empty(xSuframa)
	@ ++nLin,110 PSAY "SUFRAMA : " + xSuframa
Else
	nLin+= 1
EndIf

Clasfis()*/                                                  // Impressao de Classif. Fiscal

nLin+= 2

@ nLin, 126 PSAY  xNUM_NF + Chr(27) + "2"                  // Numero da Nota Fiscal

nLin+= 8

@ nLin, 000 PSAY Chr(18)                                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

//nLin+= 1

Return .t.

//****************************************************************
//                 Impressao da classificacao fiscal             ³
//****************************************************************

Static Function CLASFIS()
nlin = 44
nCont := 12
nCont1:= " "
nCol  := 1
//if !Empty (SB1->B1_POSIPI)
For nCont:= I1+1 TO 6
	AADD(xCLFISCAL," ")
Next

//nLin+= 1

For nCont:= 1 To 6
	
	nCont1= StrZero(nCont-1,2)
	If nCont<= Len(xCLAS_FIS).And.!Empty(xCLAS_FIS)
		//	@ ++nLin, nCol PSAY XCLAS_PRO[nCont] + " " + Transform(xCLAS_FIS[nCont],"@R 99.")
	Else
		++nLin
	EndIf
	If mv_par04 == 2
		If nCont<= Len(xMeNota)
			@ NLIN, 015 PSAY xMeNota[nCont]
		EndIf
	EndIf
	
Next

Return

//****************************************************************
//                   Mensagem padrao da nota                     ³
//****************************************************************

Static Function IMPMENP()

nCol:= 016
If !Empty(xCOD_MENS)
	@ nLin, NCol PSAY FORMULA(xCOD_MENS)
Endif

Return