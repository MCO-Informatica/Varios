#include "rwmake.ch"
#include "topconn.ch"
#Include "TbiCode.ch"
#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR001   ºAutor ³Marcelo Scibartauskasº Data ³  07/07/08   º±±
±±º          ³          º      ³Ricardo Felipelli    º Data ³  02/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina responsavel pela impressao da nota fiscal de entradaº±±
±±º          ³ e saida.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                                                                                                      
// 19.11.08 inclusao de contador de pagina 1/3, 2/3, 3/3
// 19.11.08 ordenacao do intens impressos por ordem alfabetica
// 21.11.08 inclui numero do romaneiro
// 26.11.08 ajuste da impressao da qtd de classifiscação fiscal

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATR001()
///////////////////////                                                       

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M,xCod_txt")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,NCONTAD,WNREL,NTAMNF,CSTRING,CPEDANT,XINS_INSEST")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE,XDESPESAS")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XMARCA,xVOLUME1,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED,xPEDID")
SetPrvt("XNUM_NFDV,XPREF_DV,XITEM_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPED,XCLAS_PRO,XZONA_FRANCA")
SetPrvt("XPESO_BRUTO,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XLOJA_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XCODVEN,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XMENS1,XMENS2,XMENS3,XMENS4,XFORNECE,XNFORI,XPEDIDO,xVLR_NFDV")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XINS_TRANSP,XPRO_CLI,XSOMA_CFO")
SetPrvt("NCONT,NCOL,NTAMOBS,NAJUSTE,BB,XBASE_ISS,XVAL_ISS,xFlag1,xPIS,xCOFINS,xINSS")
SetPrvt("XMENOTA,NTOT_DEV,NNOT_DEV,NSER_DEV,NDAT_DEV,XPEDCLI,XOBSITEM,XTRANS_PED")
SetPrvt("xENDE_CLI,xBAIRROE,xMUNE_CLI,xOBSE_CLI,xVALDESC,xTOTAL,LFIMDET,xFormula,xMenPad")

Private _aClasFis := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","Y","W","Z",'0','1','2','3','4','5','6','7','8','9',"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","x","y","w","z"}
//****************************************************************
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³
//³ mv_par03             // Da Serie                             ³
//³ mv_par04             // Nota Fiscal de Entrada/Saida         ³
//****************************************************************
CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
Z        := 0
M        := 0
tamanho  := "P"
limite   := 80
titulo   := PADC("Nota Fiscal de vendas ou devolucao",74)
cDesc1   := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2   := ""
cDesc3   := ""
cNatureza:= ""
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog := "FATR001"
cPerg    := "NFSIGW"
nLastKey := 0
lContinua:= .T.
nLin     := 0
nContad  := 0
wnrel    := "FATR001"
xFlag1   := 0
nTamNf   := 94
l_Benef  := .F.
lServ    := .F.
_totfolh := 0
_subnota := 0
lFimDet	 := .F.

Pergunte(cPerg,.F.)
cString:= "SF2"

wnrel:= SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
EndIf

fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
EndIf

RptStatus({|| RptDetail()})
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RptDetail()
///////////////////////////

SetPrc(0,0)
nLin := 0
@ nLin, 015 pSay Chr(27) + "0"                       // Espacejamento 1/8"
@ 2,00 pSay chr(15)

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant:= SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
EndIf

SetRegua(Val(mv_par02)-Val(mv_par01) + 1)

//****************************************************************
//             Nota Fiscal de Saída                              ³
//****************************************************************

If mv_par04 == 2  // NOTA DE SAIDA !
	
	dbSelectArea("SF2")
	Do While !Eof().and. xFilial("SF2") == SF2->F2_FILIAL .And. SF2->F2_DOC<= mv_par02 .and. lContinua .and. SF2->F2_SERIE == mv_par03
		
		If SF2->F2_SERIE # mv_par03
			DbSkip()
			Loop
		EndIf
	
		If lAbortPrint
			@ 00,01 pSay "** CANCELADO PELO OPERADOR **"
			lContinua:= .F.
			Exit
		EndIf
		//****************************************************************
		//       Inicio de Levantamento dos Dados da Nota Fiscal         ³
		//****************************************************************
		
		// Cabecalho da Nota Fiscal
		xFILNOTA    := SF2->F2_FILIAL
		xNUM_NF     := SF2->F2_DOC             // Numero
		xSERIE      := SF2->F2_SERIE           // Serie
		xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    := SF2->F2_VALBRUT         // Valor Total da Fatura
		xCLIENTE    := SF2->F2_CLIENTE         // Cliente
		xLOJA       := SF2->F2_LOJA            // Loja do Cliente
		xFRETE      := SF2->F2_FRETE           // Frete
		xSEGURO     := SF2->F2_SEGURO          // Seguro
		xDESPESAS   := SF2->F2_DESPESA         // Despesas
		xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS := SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xBSICMRET	:= SF2->F2_BRICMS 
		xVALOR_IPI  := SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     := SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     := SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME1    := SF2->F2_VOLUME1         // Volume 1 no Pedido
		xVAL_ISS    := SF2->F2_VALISS          // Valor do ISS
		xBASE_ISS   := SF2->F2_BASEISS         // Base de calculo para ISS
		xPIS        := SF2->F2_VALIMP6         // Valor do PIS
		xCOFINS     := SF2->F2_VALIMP5         // Valor do Cofins
		
		// Cadastro de itens de vendas
		
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial()+ xNUM_NF+ xSERIE)
		
		cPedAtu    := SD2->D2_PEDIDO
		cItemAtu   := SD2->D2_ITEMPV
		xZONS_FRANC:= 0
		xVALDESC   := 0
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
		xCLASFIS   := {} 						 // Classificacao Fiscal do Produto		
		xICMSOL    := {}                         // Base do ICMS Solidario
		xICM_PROD  := {}                         // ICMS do Produto
		xMeNota    := {}                         // Texto da nota fiscal
		xVLR_NFDV  := {}
		
		
		// Armazena nos arrays correspondentes os itens da nota fiscal de saida
		
		Do While !Eof().And.SD2->D2_DOC==xNUM_NF.And.SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE <> mv_par03
				DbSkip()
				Loop
			EndIf
			
			aAdd(xPED_VEND , SD2->D2_PEDIDO)
			aAdd(xITEM_PED , SD2->D2_ITEMPV)
			aAdd(xNUM_NFDV , SD2->D2_NFORI)
			aAdd(xPREF_DV  , SD2->D2_SERIORI)
			aAdd(xITEM_DV  , SD2->D2_ITEMORI)
			aAdd(xICMS     , SD2->D2_PICM)
			aAdd(xCOD_PRO  , SD2->D2_COD)
			aAdd(xQTD_PRO  , SD2->D2_QUANT)
			aAdd(xPRE_UNI  , SD2->D2_PRCVEN)
			aAdd(xPRE_TAB  , SD2->D2_PRUNIT)
			aAdd(xIPI      , SD2->D2_IPI)
			aAdd(xVAL_IPI  , SD2->D2_VALIPI)
			aAdd(xDESC     , SD2->D2_DESC)
			aAdd(xVAL_MERC , SD2->D2_TOTAL)
			aAdd(xTES      , SD2->D2_TES)
			aAdd(xCLASFIS  , SD2->D2_CLASFIS)
			
			aAdd(xCF       , SD2->D2_CF)
			aAdd(xICM_PROD , SD2->D2_PICM)
			aAdd(xVLR_NFDV , SD2->D2_TOTAL)
			xZONS_FRANC+= SD2->D2_DESCZFR
			xVALDESC+= SD2->D2_DESCON
			dbskip()
		EndDo
		
		// Cadastro de produtos
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		
		xPESO_PRO   := {}                     // Peso Liquido
		xPESO_UNIT  := {}                     // Peso Unitario do Produto
		xDESCRICAO  := {}                     // Descricao do Produto
		xUNID_PRO   := {}                     // Unidade do Produto
		xCOD_TRIB   := {}                     // Codigo de Tributacao
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
		xVolume     := 0
		I           := 1
		I1          := 0
		
		// Dados dos itens do produto
		
		For I:=1 to Len(xCOD_PRO)
			dbSeek(xFilial()+xCOD_PRO[I])
			//aAdd(xPESO_LIQ  , (SB1->B1_PESO * xQTD_PRO[I]))
			//aAdd(xPESO_BRUTO, (SB1->B1_PESBRU * xQTD_PRO[I]))
			xPESO_LIQ += SB1->B1_PESO * xQTD_PRO[I]
			xPESO_BRUTO += SB1->B1_PESBRU * xQTD_PRO[I]
			xVolume += xQTD_PRO[I] / SB1->B1_QE
			aAdd(xUNID_PRO , SB1->B1_UM)
			aAdd(xDESCRICAO, SB1->B1_DESC)
			
			dbSelectArea("SF4")
			DbSetOrder(1)
			dbSeek(xFilial()+ xTES[I])
			
			aAdd(xCOD_TRIB , SB1->B1_ORIGEM+SF4->F4_SITTRIB)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)== 0
				aAdd(xMEN_TRIB , SB1->B1_ORIGEM)
			EndIf
			dbSelectArea("SB1")
			npElem:= ascan(xCLAS_FIS,SB1->B1_POSIPI) // Verifica posição da C.F.
			
			If npElem == 0     // Se não existir adiciona
				aAdd(xCLAS_FIS, SB1->B1_POSIPI)
				npElem:= ascan(xCLAS_FIS,SB1->B1_POSIPI) // Verifica posição da C.F.
			EndIf
			
			aAdd(xCLAS_PRO,_aCLASFIS[npElem])
			
			_ClasFis  := _aCLASFIS[npElem]
			
			nPteste:= Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0.And._CLASFIS <> " "
				aAdd(xCLFISCAL,_CLASFIS)
				++I1
			EndIf
			
			aAdd(xCOD_FIS , _CLASFIS)
			aAdd(xISS     , SB1->B1_ALIQISS)
			aAdd(xTIPO_PRO, SB1->B1_TIPO)
			aAdd(xLUCRO   , SB1->B1_PICMRET)
		Next
		
		// Pedidos de Venda
		
		dbSelectArea("SC9")
		dbSetOrder(1)
		
		xPED     := {}
		xCod_Txt := {}
		xPedCli  := " "  // Para pedido do cliente na observacao da nota fiscal
		
		// Carrega arrays com dados do pedido de venda
		
		For I:=1 to Len(xPED_VEND)
			dbSeek(xFilial('SC9') + xPED_VEND[I])
			xPEDID:= SC9->C9_pedido
			If ASCAN(xPED,xPED_VEND[I])== 0
				dbSeek(xFilial('SC9') + xPED_VEND[I])
				xCOD_MENS   := '' //SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				/*
				If !empty(Substr(SC5->C5_MENNOTA,1,70))
					aAdd(xMeNota,Substr(SC5->C5_MENNOTA,1,70))
				EndIf
				If !empty(Substr(SC5->C5_MENNOTA,71,70))
					aAdd(xMeNota,Substr(SC5->C5_MENNOTA,71,70))
				EndIf
				If !empty(Substr(SC5->C5_MENNOTA,141,70))
					aAdd(xMeNota,Substr(SC5->C5_MENNOTA,141,70))
				EndIf
				
				xTPFRETE    := SC5->C5_TPFRETE            // Tipo de Entrega
				xMARCA      := SC5->C5_ESPECI2            // Marca
				xCONDPAG    := SC5->C5_CONDPAG            // Condicao de Pagamento
				xCOD_VEND   := {SC5->C5_VEND1,;           // Codigo do Vendedor 1
				SC5->C5_VEND2,;                           // Codigo do Vendedor 2
				SC5->C5_VEND3,;                           // Codigo do Vendedor 3
				SC5->C5_VEND4,;                           // Codigo do Vendedor 4
				SC5->C5_VEND5}                            // Codigo do Vendedor 5
				xDESC_NF    := {SC5->C5_DESC1,;           // Desconto Global 1
				SC5->C5_DESC2,;                           // Desconto Global 2
				SC5->C5_DESC3,;                           // Desconto Global 3
				SC5->C5_DESC4}                            // Desconto Global 4
				xTRANS_PED  :=  SC5->C5_TRANSP            // TRANSPORTADORA
				xESPECIE    :=  SC5->C5_ESPECI1
				*/

				xTPFRETE    := 'C'            // Tipo de Entrega
				xMARCA      := ''                         // Marca
				xCONDPAG    := ''                         // Condicao de Pagamento
				xCOD_VEND   := {'','','','','',''}
				xDESC_NF    := {0,0,0,0,0}                // Desconto Global 4
				xTRANS_PED  :=  ''                        // TRANSPORTADORA

				aAdd(xPED,xPED_VEND[I])
			EndIf
		Next
		
		// Condicao de Pagamento
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+ xCONDPAG)
		                                                                                                      
		xDESC_PAG:= SE4->E4_DESCRI
		
		// Itens de Pedido de Venda
		
		dbSelectArea("SC9")
		dbSetOrder(1)
		
		xPED_CLI := {}                          // Numero de Pedido
		xDESC_PRO:= {}                          // Descricao aux do produto
		//	xCOD_TRIB:= {}                          // Codigo de Tributacao
		xObsItem := {}                          // Observacao do item do pedido
		
		J:= Len(xPED_VEND)
		
		For I:=1 to J
			dbSeek(xFilial()+ xPED_VEND[I]+ xITEM_PED[I])
			//aAdd(xPED_CLI , SC6->C6_PEDCLI)
			//aAdd(xVAL_DESC, SC6->C6_VALDESC)
			aAdd(xPED_CLI , '')
			aAdd(xVAL_DESC, 0)
			dbSelectArea("SB1")
			dbSetOrder(1)
			SB1->(dbSeek(xFilial() + SC9->C9_PRODUTO))
			aAdd(xDESC_PRO, alltrim(SB1->B1_DESC))
			dbSelectArea("SC9")
			dbSetOrder(1)
		Next
		
		If xTIPO=='N'.OR.xTIPO=='C'.OR.xTIPO=='P'.OR.xTIPO=='I'.OR.xTIPO=='S'.OR.xTIPO=='T'.OR.xTIPO=='O'
			
			// Cadastro de Clientes
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+ xCLIENTE+ xLOJA)
			
			xCOD_CLI := SA1->A1_COD             // Codigo do Cliente
			xLOJA_CLI:= SA1->A1_LOJA            // Loja cliente
			xNOME_CLI:= SA1->A1_NOME            // Nome
			xEND_CLI := SA1->A1_END             // Endereco
			xBAIRRO  := SA1->A1_BAIRRO          // Bairro
			xCEP_CLI := SA1->A1_CEP             // CEP
			xMUN_CLI := SA1->A1_MUN             // Municipio
			xEST_CLI := SA1->A1_EST             // Estado
			xCGC_CLI := SA1->A1_CGC             // CGC
			xINSC_CLI:= SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:= SA1->A1_TRANSP          // Transportadora
			xTEL_CLI := SA1->A1_TEL             // Telefone
			xFAX_CLI := SA1->A1_FAX             // Fax
			xSUFRAMA := SA1->A1_SUFRAMA         // Codigo Suframa
			xCALCSUF := SA1->A1_CALCSUF         // Calcula Suframa
			
			// Pega o endereco de entrega para colocar na observacao da nota
			
			If SA1->A1_CEPE <> ''                  // CEP de Entrega
				xENDE_CLI:= SA1->A1_ENDENT          // Endereco Entrega
				xBAIRROE := SA1->A1_BAIRROE         // Bairro Entrega
				xMUNE_CLI:= SA1->A1_MUNE            // Municipio Entrega
				xOBSE_CLI:= SA1->A1_ENDREC          // Obs da Entrega
			else
				xENDE_CLI:= ""
				xBAIRROE := ""
				xMUNE_CLI:= ""
				xOBSE_CLI:= ""
			EndIf
			
			// Alteracao p/ Calculo de Suframa
			
			If !empty(xSUFRAMA).and.xCALCSUF=="S"
				If XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				else
					zFranca := .T.
				EndIf
			Else
				zfranca:= .F.
			EndIf
		Else
			zFranca:=.F.
			
			// Cadastro de Fornecedores
			
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			
			xCOD_CLI := SA2->A2_COD             // Codigo do Fornecedor
			xLOJA_CLI:= SA2->A2_LOJA            // Loja fornecedor
			xNOME_CLI:= SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI := SA2->A2_END             // Endereco
			xBAIRRO  := SA2->A2_BAIRRO          // Bairro
			xCEP_CLI := SA2->A2_CEP             // CEP
			xMUN_CLI := SA2->A2_MUN             // Municipio
			xEST_CLI := SA2->A2_EST             // Estado
			xCGC_CLI := SA2->A2_CGC             // CGC
			xINSC_CLI:= SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:= SA2->A2_TRANSP          // Transportadora
			xTEL_CLI := SA2->A2_TEL             // Telefone
			xFAX_CLI := SA2->A2_FAX             // Fax
		EndIf
		
		// Cadastro de Vendedores
		
		dbSelectArea("SA3")
		dbSetOrder(1)
		
		xVENDEDOR:= {}                          // Nome do Vendedor
		I := 1
		J := 1
		
		For I:=1 to J
			dbSeek(xFilial("SA3")+ xCOD_VEND[I])
			xVENDEDOR:=SA3->A3_NOME
			xCODVEN  :=SA3->A3_COD
		Next
		
		// Transportadoras
		
		dbSelectArea("SA4")
		dbSetOrder(1)
		
		If !empty(xTRAN_CLI)
			dbSeek(xFilial()+xTRAN_CLI)
		Else
			dbSeek(xFilial()+xTRANS_PED)
		EndIf
		
		xNOME_TRANSP:= SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP := SA4->A4_END            // Endereco
		xMUN_TRANSP := SA4->A4_MUN            // Municipio
		xEST_TRANSP := SA4->A4_EST            // Estado
		xVIA_TRANSP := SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP := SA4->A4_CGC            // CGC
		xINS_INSEST := SA4->A4_INSEST         // Inscricao estadual
		xTEL_TRANSP := SA4->A4_TEL            // Fone
		
		// Contas a Receber
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		
		xPARC_DUP   := {}                       // Parcela
		xVENC_DUP   := {}                       // Vencimento
		xVALOR_DUP  := {}                       // Valor
		xDUPLICATAS := iif(dbSeek(xFilial()+ subst(xSERIE,1,1)+ xFILNOTA+ xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		xInssAux    := 0
		xIrrfAux    := 0
		xCSLL       := 0
		
		// Carrega arrays com duplicatas
		
		_ndupli := 0
		Do While !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			EndIf
			If _ndupli < 3
				aAdd(xPARC_DUP ,SE1->E1_PARCELA)
				aAdd(xVENC_DUP ,SE1->E1_VENCTO)
				aAdd(xVALOR_DUP,SE1->E1_VALOR - (SE1->E1_IRRF + SE1->E1_INSS + SE1->E1_PIS + SE1->E1_COFINS + SE1->E1_CSLL))
				xInssAux += SE1->E1_INSS
				xIrrfAux += SE1->E1_IRRF
				xCSLL    := SE1-> E1_CSLL
				_ndupli  ++
			EndIf
			dbSkip()
		EndDo
		
		// Tipos de Entrada e Saida
		
		dbSelectArea("SF4")
		DbSetOrder(1)
		dbSeek(xFilial()+ xTES[1])
		
		xNATUREZA:= SF4->F4_TEXTO     // Natureza da Operacao
        xFormula := Posicione("SM4", 1, xFilial("SM4")+SF4->F4_FORMULA,"M4_FORMULA")    // Formula da TES 
        xFormula := Formula(SF4->F4_FORMULA)
        xMenPad  := Posicione("SM4", 1, xFilial("SM4")+xCOD_MENS,"M4_FORMULA")   //Formula padrão SC5 (C5_MENPAD)
        
		_cFormularios := ''					// formularios onde foram impressos os dados adicionais
		_aMensagens := {}
		Mensagens()
		Imprime()
		
		IncRegua()
		
		RecLock( 'SF2', .F. )
		SF2->F2_FIMP := 'S'
		SF2->(MsUnLock())
		
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		nContad +=1
		
	EndDo
	
Else
	// Cabecalho da Nota Fiscal Entrada
	
	dbSelectArea("SF1")
	dbSeek(xFilial()+ mv_par01+ mv_par03,.t.)
	
	Do While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua .and. SF1->F1_SERIE == mv_par03
		If SF1->F1_SERIE # mv_par03
			DbSkip()
			Loop
		EndIf
		
		If SF1->F1_FORMUL <> 'S'  // impressao de nf de entrada somente com formulario proprio
			DbSkip()
			Loop
		EndIf
		
		
		SetRegua(Val(mv_par02)- Val(mv_par01))
		
		If lAbortPrint
			@ 00,01 pSay "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		EndIf
		
		//****************************************************************
		//       Inicio de Levantamento dos Dados da Nota Fiscal         ³
		//****************************************************************
		
		// Cabecalho da Nota Fiscal
		
		xFILNOTA    := SF1->F1_FILIAL
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
		xVALDESC    := SF1->F1_DESCONT		   // Desconto da NF
		
		// Itens da N.F. de Compra
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial()+ xNUM_NF+ xSERIE+ xFORNECE+ xLOJA)
		
		cPedAtu  := SD1->D1_PEDIDO
		cItemAtu := SD1->D1_ITEMPC
		
		xPEDIDO  := {}                         // Numero do Pedido de Compra
		xITEM_PED:= {}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:= {}                         // Numero quando houver devolucao
		xPREF_DV := {}                         // Serie  quando houver devolucao
		xITEM_DV := {}                         // Item da nota de devolucao
		xICMS    := {}                         // Porcentagem do ICMS
		xCOD_PRO := {}                         // Codigo  do Produto
		xQTD_PRO := {}                         // Peso/Quantidade do Produto
		xPRE_UNI := {}                         // Preco Unitario de Compra
		xIPI     := {}                         // Porcentagem do IPI
		xPESOPROD:= {}                         // Peso do Produto
		xVAL_IPI := {}                         // Valor do IPI
		xDESC    := {}                         // Desconto por Item
		xVAL_MERC:= {}                         // Valor da Mercadoria
		xTES     := {}                         // TES
		xCF      := {}                         // Classificacao quanto natureza da Operacao
		xICMSOL  := {}                         // Base do ICMS Solidario
		xICM_PROD:= {}                         // ICMS do Produto
		xCLASFIS := {}
		// Carrega itens com dados dos itens da nota fiscal de devolucao
		
		Do While !eof() .and. SD1->D1_DOC == xNUM_NF .and. SD1->D1_FORMUL = 'S'
			If SD1->D1_SERIE # mv_par03
				DbSkip()
				Loop
			EndIf
			
			aAdd(xPEDIDO   , SD1->D1_PEDIDO)         // Ordem de Compra
			aAdd(xITEM_PED , SD1->D1_ITEMPC)         // Item da O.C.
			aAdd(xNUM_NFDV , iif(empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			aAdd(xPREF_DV  , SD1->D1_SERIORI)        // Serie Original
			aAdd(xITEM_DV  , SD1->D1_ITEMORI)        // Item Original
			aAdd(xICMS     , iif(empty(SD1->D1_PICM),0,SD1->D1_PICM))
			aAdd(xCOD_PRO  , SD1->D1_COD)            // Produto
			aAdd(xQTD_PRO  , SD1->D1_QUANT)          // Guarda as quant. da NF
			aAdd(xPRE_UNI  , SD1->D1_VUNIT)          // Valor Unitario
			aAdd(xIPI      , SD1->D1_IPI)            // % IPI
			aAdd(xVAL_IPI  , SD1->D1_VALIPI)         // Valor do IPI
			aAdd(xPESOPROD , SD1->D1_PESO)           // Peso do Produto
			aAdd(xVAL_MERC , SD1->D1_TOTAL)          // Valor Total
			aAdd(xTES      , SD1->D1_TES)            // Tipo de Entrada/Saida
			aAdd(xCF       , SD1->D1_CF)             // Codigo Fiscal
			aAdd(xNUM_NFDV , SD1->D1_NFORI)
			aAdd(xICM_PROD , iif(empty(SD1->D1_PICM),0,SD1->D1_PICM))
			aAdd(xCLASFIS  , SD1->D1_CLASFIS)
			dbskip()
		End
		
		// Desc. Generica do Produto
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		
		xUNID_PRO := {}                         // Unidade do Produto
		xDESC_PRO := {}                         // Descricao do Produto
		xMEN_POS  := {}                         // Mensagem da Posicao IPI
		xDESCRICAO:= {}                         // Descricao do Produto
		xCOD_TRIB := {}                         // Codigo de Tributacao
		xMEN_TRIB := {}                         // Mensagens de Tributacao
		xCOD_FIS  := {}                         // Cogigo Fiscal
		xCLAS_FIS := {}                         // Classificacao Fiscal
		xISS      := {}                         // Aliquota de ISS
		xTIPO_PRO := {}                         // Tipo do Produto
		xCLAS_PRO := {}                         // Classificacao fiscal produto
		xLUCRO    := {}                         // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL := {}
		xSUFRAMA  := ""
		xCALCSUF  := ""
		I := 1
		I1:= 0
		
		// Carrega arrays com dados do produto
		
		For I:=1 to Len(xCOD_PRO)
			dbSelectArea("SB1")
			SB1->(dbSeek(xFilial()+ xCOD_PRO[I]))
			
			aAdd(xDESC_PRO, alltrim(SB1->B1_DESC))
			aAdd(xUNID_PRO, SB1->B1_UM)
			aAdd(xCOD_TRIB, SB1->B1_ORIGEM+SB1->B1_CLASFIS)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				aAdd(xMEN_TRIB, SB1->B1_ORIGEM)
			EndIf
			
			aAdd(xDESCRICAO, SB1->B1_DESC)
			aAdd(xMEN_POS  , SB1->B1_POSIPI)
			aAdd(xISS, SB1->B1_ALIQISS)
			aAdd(xTIPO_PRO, SB1->B1_TIPO)
			aAdd(xLUCRO   , SB1->B1_PICMRET)
			
			npElem:= ascan(xCLAS_FIS,SB1->B1_POSIPI) // Verifica posição da C.F.
			
			If npElem == 0     // Se não existir adiciona
				aAdd(xCLAS_FIS, SB1->B1_POSIPI)
				npElem := Len(xCLAS_FIS)
			EndIf
			
			aAdd(xCLAS_PRO,_aCLASFIS[npElem])
			_ClasFis  := _aCLASFIS[npElem]
			
			nPteste:= Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0.And._CLASFIS <> " "
				aAdd(xCLFISCAL,_CLASFIS)
				++I1
			EndIf
			
			aAdd(xCOD_FIS , _CLASFIS)
			aAdd(xISS     , SB1->B1_ALIQISS)
			aAdd(xTIPO_PRO, SB1->B1_TIPO)
			aAdd(xLUCRO   , SB1->B1_PICMRET)
		Next
		
		// Pedidos de Compra
		
		dbSelectArea("SC7")
		dbSetOrder(1)
		
		// Carrega arrays com dados do pedido de venda
		
		For I:=1 to Len(xPEDIDO)
			Set SoftSeek On
			DbSeek(xFilial("SC7")+xPEDIDO[I]+ xITEM_PED[I])
			Set SoftSeek Off
			
			If !Eof()
				aAdd(xDESC_PRO, alltrim(SC7->C7_DESCRI))
			EndIf
			
		Next
		
		// Condicao de Pagamento
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+ xCOND_PAG)
		
		xDESC_PAG:= SE4->E4_DESCRI
		
		If xTIPO == "D"
			l_Benef := .T.
			// Cadastro de Clientes
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE)
			
			xCOD_CLI := SA1->A1_COD             // Codigo do Cliente
			xLOJA_CLI:= SA1->A1_LOJA            // Loja do cliente
			xNOME_CLI:= SA1->A1_NOME            // Nome
			xEND_CLI := SA1->A1_END             // Endereco
			xBAIRRO  := SA1->A1_BAIRRO          // Bairro
			xCEP_CLI := SA1->A1_CEP             // CEP
			xMUN_CLI := SA1->A1_MUN             // Municipio
			xEST_CLI := SA1->A1_EST             // Estado
			xCGC_CLI := SA1->A1_CGC             // CGC
			xINSC_CLI:= SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:= SA1->A1_TRANSP          // Transportadora
			xTEL_CLI := SA1->A1_TEL             // Telefone
			xFAX_CLI := SA1->A1_FAX             // Fax
			
			// Pega o endereco de entrega para colocar na observacao da nota
			If SA1->A1_CEPE <> ''                  // CEP de Entrega
				xENDE_CLI:= SA1->A1_ENDENT          // Endereco Entrega
				xBAIRROE := SA1->A1_BAIRROE         // Bairro Entrega
				xMUNE_CLI:= SA1->A1_MUNE            // Municipio Entrega
				xOBSE_CLI:= SA1->A1_ENDREC          // Obs da Entrega
			else
				xENDE_CLI:= ""
				xBAIRROE := ""
				xMUNE_CLI:= ""
				xOBSE_CLI:= ""
			EndIf
		Else
			//  Cadastro de Fornecedores
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			
			xCOD_CLI := SA2->A2_COD             // Codigo do Cliente
			xLOJA_CLI:= SA2->A2_LOJA            // Loja do Fornecedor
			xNOME_CLI:= SA2->A2_NOME            // Nome
			xEND_CLI := SA2->A2_END             // Endereco
			xBAIRRO  := SA2->A2_BAIRRO          // Bairro
			xCEP_CLI := SA2->A2_CEP             // CEP
			xMUN_CLI := SA2->A2_MUN             // Municipio
			xEST_CLI := SA2->A2_EST             // Estado
			xCGC_CLI := SA2->A2_CGC             // CGC
			xINSC_CLI:= SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:= SA2->A2_TRANSP          // Transportadora
			xTEL_CLI := SA2->A2_TEL             // Telefone
			xFAX     := SA2->A2_FAX             // Fax
		EndIf
		
		// Contas a Receber
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		xPARC_DUP  := {}                       // Parcela
		xVENC_DUP  := {}                       // Vencimento
		xVALOR_DUP := {}                       // Valor
		xDUPLICATAS := iif(dbSeek(xFilial()+ subst(xSERIE,1,1)+ xFILNOTA+ xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		// Carrega arrays com duplicatas
		
		Do While !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			aAdd(xPARC_DUP ,SE1->E1_PARCELA)
			aAdd(xVENC_DUP ,SE1->E1_VENCTO)
			aAdd(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		// Tipos de Entrada e Saida
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		xNOME_TRANSP:= " "                    // Nome Transportadora
		xEND_TRANSP := " "                    // Endereco
		xMUN_TRANSP := " "                    // Municipio
		xEST_TRANSP := " "                    // Estado
		xVIA_TRANSP := " "                    // Via de Transporte
		xCGC_TRANSP := " "                    // CGC
		xINS_INSEST := " "                    // INSCR.ESTADUAL
		xTEL_TRANSP := " "                    // Fone
		//xCOD_MENS   := " "                    // Codigo da Mensagem
		xCOD_TXT    := " "                    // Codigo texto padrao

		_cFormularios := ''					// formularios onde foram impressos os dados adicionais
		_aMensagens := {}
		Mensagens()
		Imprime()
		IncRegua()
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
	EndDo
EndIf

@ prow(), 000 pSay chr(18)
@ prow(), 015 pSay Chr(27) + "2"                       // Espacejamento 1/6"

If mv_par04 == 2
	dbSelectArea("SF2")
	Retindex("SF2")
	dbSelectArea("SD2")
	Retindex("SD2")
Else
	dbSelectArea("SF1")
	Retindex("SF1")
	dbSelectArea("SD1")
	Retindex("SD1")
EndIf
set device to screen
set printer to
If aReturn[5] == 1
	ourspool(wnrel)
EndIf

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                   Impressao da nota fiscal                    ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Imprime()
/////////////////////////

Cabecalho()
ImpDet() 
TotNota()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                   Impressao da nota fiscal                    ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Cabecalho()
///////////////////////////

nLin := 4

If mv_par05 == 1 // imprime endereco no cabec. da NF, se for stralog não imprime tem impresso no formulario.
		
	If ! SM0->M0_CODFIL == "C0"   // Verifica se a Filial que está imprimindo é a C0 - CLIO MATRIZ 
		If ! SM0->M0_CODFIL $ GetMV("LA_EMPNF") // "83,05,A0,A1,BH,C1,C2,C3,C4,C4,C5,C6,C7,R0,R1,R2,R3,R4,R5,G0,G1,G2,G3,G4,G5,G6,G7,G8,G9,GA,GB,GC,GD,GE,GF,GG"
			@ nlin,043 pSay SM0->M0_ENDENT
			@ nLin, iif(mv_par04 == 2,89,104) pSay "X"
			@ nLin, 128 pSay xNUM_NF   // Numero da Nota Fiscal

			nLin+=2

			@ nlin,043 pSay SM0->M0_CIDENT + ' - ' + SM0->M0_ESTENT
		
			nLin+=2

			@ nlin,043 pSay "CEP " + SM0->M0_CEPENT + " TEL " +SM0->M0_TEL
			@ nlin,090 pSay SM0->M0_CGC
			
			nLin+=2
	    Else
			@ nLin, iif(mv_par04 == 2,89,104) pSay "X"
			@ nLin, 128 pSay xNUM_NF  	// Numero da Nota Fiscal
			
			nLin+=2                              	
		EndIf
	Else     	// Imprime cabeçalho para NF da filial C0 - Clio Matriz 
			@ nlin, 023 pSay "AV. PAULISTA, 967 - 14 AND. - CJ. 9 - C. CESAR" //AllTrim(SM0->M0_ENDENT) + " - " + SM0->M0_COMPENT
			@ nLin, iif(mv_par04 == 2,89,104) pSay "X"
			@ nLin, 128 pSay xNUM_NF   	// Numero da Nota Fiscal 
			
			nLin+=1
            
			@ nlin,023 pSay "01311-100 - SAO PAULO - SP"
		    //@ nlin,023 pSay AllTrim(SM0->M0_CEPENT) Picture "@R 99999-999" 
		    //@ nlin,023 pSay " - " + AllTrim(SM0->M0_CIDENT) + ' - ' + AllTrim(SM0->M0_ESTENT) 
		   
		    nLin+=1
		    
		    @ nlin,023 pSay "clioeditora@clioeditora.com.br"
		    
			nLin+=2

			@ nlin,089 pSay AllTrim(SM0->M0_CGC) Picture "@R 99.999.999/9999-99" 
			
			nLin+=2
	EndIf	
Else
   
	@ nLin, iif(mv_par04 == 2,89,104) pSay "X"
	@ nLin, 128 pSay xNUM_NF   // Numero da Nota Fiscal
	
	nLin+=6 
   	
EndIf

@ nlin, 006 pSay xNATUREZA                              // Texto da Natureza de Operacao

If Len(xCF)>1
	If xCF[1]<>xCF[2]
		XSOMA_CFO= xCF[1]+"/"+xCF[2]
		@ nlin, 043 pSay AllTrim(XSOMA_CFO)             // Codigo da Natureza de Operacao
	Else
		@ nlin, 043 pSay xCF[1] Picture "@ER 9999"     // Codigo da Natureza de Operacao
	EndIf
Else
	@ nlin, 043 pSay xCF[1] Picture "@ER 9999"          // Codigo da Natureza de Operacao
EndIf

If ! SM0->M0_CODFIL $ GetMV("LA_EMPNF") // "83,05,A0,A1,BH,C1,C2,C3,C4,C4,C5,C6,C7,R0,R1,R2,R3,R4,R5,G0,G1,G2,G3,G4,G5,G6,G7,G8,G9,GA,GB,GC,GD,GE,GF,GG"
	@ nlin,089 pSay AllTrim(SM0->M0_INSC) Picture "@R 999.999.999.999"
EndIf

nLin+= 3

@ nLin, 004 pSay xNOME_CLI + " ("+xLOJA_CLI+")"                              // Nome do Cliente
If !empty(xCGC_CLI)                                     // Se o C.G.C. do Cli/Forn nao for Vazio
	@ nLIn, 089 pSay xCGC_CLI Picture "@R 99.999.999/9999-99"
EndIf

@ nLin, 123 pSay xEMISSAO                               // Data da Emissao do Documento

@ nLin+=2, 004 pSay xEND_CLI                               // Endereco
@ nLin	 , 072 pSay xBAIRRO                                // Bairro
@ nLin   , 102 pSay xCEP_CLI Picture "@R 99999-999"        // CEP

@ nLin+=2, 004 pSay xMUN_CLI                               // Municipio
@ nLin	 , 054 pSay xTEL_CLI                               // Telefone/FAX
@ nLin	 , 080 pSay xEST_CLI                               // U.F.
@ nLin	 , 089 pSay xINSC_CLI                              // Insc. Estadual

// Impressao da Fatura/Duplicata

If mv_par04 == 2   // nf saida
	nLin+= 3
	DUPLIC()
Else
	nLin+= 6
EndIf

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///                   Impressao das Duplicatas                    ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function DUPLIC()
////////////////////////

nCol    := pcol()+3
@ nLin,00 pSay ''

For BB:= 1 to Len(xVALOR_DUP)
	@ nLin,PCOL()+3 pSay subst(xNUM_DUPLIC,1,6) + " " + SUBST(xPARC_DUP[BB],1,1)
	@ nLin,PCOL()+4 pSay xVENC_DUP[BB]
	@ nLin,PCOL()+5 pSay xVALOR_DUP[BB] Picture("@E 9,999,999.99")
Next

nLin+= 3
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//         Inicio da Impressao dos Dados da Nota Fiscal          ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function IMPDET()
////////////////////////

nTamDet:= 100                 // Tamanho da Area de Detalhe
W      := 1                   // Controle de Do While
J      := 39//GETMV("MV_NUMITEM") // Controla o total de linhas que faltam completas as 16 impressas
Z      := 0                   // Controla o numero de continuacao de notas
X      := 0
xTOTAL := 0

//prepara array para impressao dos produtos em ordem alfabetica - rf

_anota:= {}

Do While W<=Len(xCOD_PRO) .and. xISS[W]= 0
	
	_rproduto := xCOD_PRO[W] // Codigo do Produto
	_rdescpro := subst(xDESC_PRO[W],1,48)                 // Descric. Produto
	_rclass   := xCLAS_PRO[W]                              // Classif. Fiscal do Produto
	_runid    := xUNID_PRO[W]                              // Unidade
	_rquant   := xQTD_PRO[W]                               // Quantidade
	_rpreunit := xPRE_UNI[W]                               // Preço Unitário
	_sit_trib := xCLASFIS[W] 							   // Situacao Tributaria
	_rvaltot  := xVAL_MERC[W]                              // Valor total
	_raliqicm := xICM_PROD[W]                              // Aliq. ICM
	_raliqipi := xIPI[W]                                   // Aliq. IPI
	aAdd(_anota, {_rproduto,_rdescpro,_rclass,_sit_trib,_runid,_rquant,_rpreunit,_rvaltot,_raliqicm,_raliqipi})
	
	W:=W+1
	Z:=Z+1
	
EndDo

aSort(_anota,,,{|x,y| x[2] < y[2]})

// volta as variaveis com conteudos originais - rf

nTamDet:= 100                 // Tamanho da Area de Detalhe
W      := 1                   // Controle de Do While
J      := 39 //GETMV("MV_NUMITEM") // Controla o total de linhas que faltam completas as 16 impressas
Z      := 0                   // Controla o numero de continuacao de notas
X      := 0
xTOTAL := 0
_totitem := len(_anota)
_totfolh := _totitem/j
_subnota := 1

If _totfolh - int(_totfolh) <> 0
	_totfolh := int(_totfolh)
	_totfolh++
else
	_totfolh := int(_totfolh)
EndIf

nLin++

If xTipo <> 'I'

	Do While W<=Len(_anota) .and. xISS[W] == 0
		
		@ ++nLin, 003 pSay _anota[W][1]                              // Codigo do Produto
		@   nLin, 019 pSay _anota[W][2]                              // Descric. Produto
		@   nLin, 071 pSay _anota[W][3]                              // Classif. Fiscal do Produto 
		@   nLin, 074 pSay _anota[W][4]								 // Situacao Tributaria
		@   nLin, 079 pSay _anota[W][5]                              // Unidade
		@   nLin, 083 pSay _anota[W][6]  Picture "@E 99,999"  	      // Quantidade
		@   nLin, 093 pSay _anota[W][7]  Picture "@E 999,999.99"     // Preço Unitário
		@   nLin, 107 pSay _anota[W][8]  Picture "@E 99,999,999.99"  // Valor total
		@   nLin, 122 pSay _anota[W][9]  Picture "99"                // Aliq. ICM
		@   nLin, 127 pSay _anota[W][10] Picture "99"                // Aliq. IPI
		
		W:=W+1
		Z:=Z+1
		If Z > J
			If J <> nLin
				RodapeNF()  // Rodape da nota fiscal
				//nLin+= 1
				//@   nLin, 3  pSay ""
				Cabecalho() // Cabecalho da nota fiscal
				J = 39 //GETMV("MV_NUMITEM")
				X = Z
				Z = 0
			EndIf
		EndIf
	EndDo

Else
	
	_cNfOri := ''
	For _nI := 1 to len(xNUM_NFDV)
		_cNFOri += iif(at(alltrim(xNum_NFDv[_nI]),_cNFOri) == 0,alltrim(xNum_NFDv[_nI]) + ', ','')
	Next                                 
	_cNFOri := left(_cNFOri,len(_cNFOri)-2)
	If !empty(_cNFOri)
		If xTipo == 'I'
			@ ++nLin,19 pSay 'Nota fiscal complementar de ICMS"
			@ ++nLin,19 pSay 'ref NF(s): ' + _cNFOri
		EndIf
	EndIf

EndIf

nlin--
lFimDet := .T.

If xCALCSUF= "S"
	
	If Z > J
		nLin+= J+1 // Alterado
		RodapeNF()
		Cabecalho()
		J= 27//17
	EndIf
	@ ++nLin, 020 pSay "Desconto Zona Franca R$ "
	@   nLin, 099 pSay xZONS_FRANC Picture "@E 99,999,999.99"
	J=J-1
EndIf

If X > 0
	nLin+= J
ELSE
	nLin+= J+1-8
EndIf

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                    Rodape da nota fiscal                      ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static function RodapeNF()
//////////////////////////
nLin := 66

@ nlin	 , 004 pSay "***.***,**"  // Base do ICMS
@ nlin	 , 032 pSay "***.***,**"  // Valor do ICMS
@ nlin	 , 059 pSay "***.***,**"  // Base ICMS Ret.
@ nlin	 , 087 pSay "***.***,**"  // Valor  ICMS Ret.
@ nlin	 , 113 pSay "***.***,**"  // Valor Tot. Prod.

@ nLin+=2, 004 pSay "***.***,**"  // Valor do Frete
@ nLin	 , 032 pSay "***.***,**"  // Valor Seguro
@ nLin	 , 059 pSay "***.***,**"  // Valor outras despesas
@ nLin	 , 087 pSay "***.***,**"  // Valor do IPI
@ nLIn	 , 113 pSay "***.***,**"  // Valor Total NF

ImTransp()
Return .t.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                   Impressao do total da nota                  ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function TotNota()
/////////////////////////

If xTipo == 'I'
	xValor_Icm  := xTot_Fat
	xTot_Fat    := 0
	xValor_Merc := 0
EndIf

nLin := 66
@ nlin	 , 003 pSay xBASE_ICMS  Picture "@E 999,999,999.99"  // Base do ICMS
@ nlin	 , 026 pSay xVALOR_ICMS Picture "@E 999,999,999.99"  // Valor do ICMS
@ nlin	 , 061 pSay xBSICMRET   Picture "@E 999,999,999.99"  // Base ICMS Ret.
@ nlin 	 , 085 pSay xICMS_RET   Picture "@E 999,999,999.99"  // Valor  ICMS Ret.
@ nlin	 , 110 pSay xVALOR_MERC Picture "@E 999,999,999.99"  // Valor Tot. Prod. ou  Valor Tot. Devolução.

@ nLin+=2, 003 pSay xFRETE      Picture "@E 999,999,999.99"  // Valor do Frete
@ nLin	 , 026 pSay xSEGURO     Picture "@E 999,999,999.99"  // Valor Seguro
@ nLin	 , 061 pSay xDESPESAS   Picture "@E 999,999,999.99"  // Valor outras despesas
@ nLin	 , 085 pSay xVALOR_IPI  Picture "@E 999,999,999.99"  // Valor do IPI
@ nLin	 , 110 pSay XTOT_FAT Picture "@E 999,999,999.99"  // Valor Total NF ou Valor Total Devoluçao  //xVALOR_MERC

ImTransp()

Return .t.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                 Impressao da transportadora                   ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ImTransp()
//////////////////////////

@ nLin+=3, 004 pSay subs(xNOME_TRANSP,1,70)                              // Nome da Transport.
@ nLin	 , 083 pSay iif(xTPFRETE=='C',"1","2")                            // Frete por conta do Emitente (1) ou Destinatario (2)
@ nLin	 , 102 pSay xEST_TRANSP                                // U.F.
If !empty(xCGC_TRANSP)                                      // Se C.G.C. Transportador nao for Vazio
	@ nLin, 107 pSay xCGC_TRANSP Picture "@R 99.999.999/9999-99"
EndIf

@ nLin+=2, 004 pSay xEND_TRANSP                                // Endereco Transp.
@ nLin	 , 083 pSay xMUN_TRANSP                                // Municipio
@ nLin	 , 102 pSay xEST_TRANSP                                // U.F.
@ nLin	 , 107 pSay xINS_INSEST                                // Reservado p/Insc. Estad.

@ nLin+=2, 012 pSay xVOLUME1                                    // Quant. Volumes
@ nLin	 , 021 pSay xESPECIE									// Especie  // conteudo anterior "Volumes" // * Alterado por Vanilson 28-07 
@ nLin	 , 040 pSay xMARCA   Picture "@!"                      // Res para Marca
@ nLin	 , 095 pSay xPESO_BRUTO Picture "@E@Z 999,999.999"     // Res para Peso Bruto
@ nLin	 , 120 pSay xPESO_LIQ   Picture "@E@Z 999,999.999"     // Res para Peso Liquido

 nLin+= 2                  
     
If len(_aMensagens) > 9
	For _nI := 1 to 8
		@ ++nLin,03 pSay _aMensagens[_nI]
	Next                                 
	@ ++nLin,03 pSay '(Continua no proximo formulario)'
	_aCopia := aClone(_aMensagens)
	_aMensagens := {}
	_cFormularios += alltrim(str(_subnota,2)) + ' / ' + alltrim(str(_totfolh,2)) + ', '
	For _nI := 9 to len(_aCopia)
		aAdd(_aMensagens, _aCopia[_nI])
	Next
ElseIf len(_aMensagens) > 0
	For _nI := 1 to len(_aMensagens)
		@ ++nLin,03 pSay _aMensagens[_nI]
	Next                               
	If !empty(_cFormularios)
		_aMensagens := {}
		_cFormularios += alltrim(str(_subnota,2)) + ' / ' + alltrim(str(_totfolh,2)) + ', '
	EndIf
ElseIf len(_aMensagens) == 0 .and. !empty(_cFormularios)
	@ ++nLin,03 pSay 'Dados adicionais conforme formularios ' + left(_cFormularios,len(_cFormularios)-2)
EndIf                                           

/*
// Rotina para impressao dos dados Suframa
If !empty(xSuframa)
	@ ++nLin,110 pSay "SUFRAMA : " + xSuframa
EndIf

Clasfis()                           // Impressao de Classif. Fiscal

If mv_par04 == 1 .AND. xTIPO == "D" .OR. xTIPO == "B"
	@ ++nLin,002 pSay " Nf. de Origem: " + xNUM_NFDV[1]
EndIf

// busca numero do romaneio - rf                                       '
cquery := " SELECT * FROM PA6010 WHERE D_E_L_E_T_ = '' AND PA6_NFS = '" + xnum_nf  + "' AND PA6_FILORI = '" + xfilial("SF2")  + "'"
TcQuery cquery NEW ALIAS "QRYCONT"

If !empty(QRYCONT->PA6_NUMROM)
	@ ++nlin,02 pSay "Romaneio Numero: " + QRYCONT->PA6_NUMROM
EndIf

QRYCONT->(DbCloseArea())

If lFimDet .And. xVALDESC > 0
	@++nlin, 02 pSay "Desconto: " + Alltrim(Transform(xVALDESC, "@E 999,999,99"))
EndIf

If xMeNota <> NIL .AND. !empty(xMeNota) //Jonas CARAIO DA PORRA DO PROGRAMADOR NÃO PREVEU QUE ESSA MATRIZ É CONDICIONAL!
	@ ++nlin,02 pSay xMeNota[1]
EndIf // Jonas
*/
             
nLin := 91
@ nLin,122 pSay xNUM_NF             // Numero da Nota Fiscal
@ nlin,131 pSay str(_subnota,2)+'/'+str(_totfolh,2)
_subnota++

@ 96,00 pSay '.'
SetPrc(0,0)

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                 Impressao da classificacao fiscal             ³
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CLASFIS()
/////////////////////////
nCont 	 := 12
_ctrlcol := 1
nCol  	 := 2

nLin+=1
For nCont:= 1 To len(_aClasFis)
	
	If nCont > 16		// numero maximo da classificacao que cabe na nossa nota
		_aCopia := aClone(_aClasFis)
		_aClasFis := {}
		For _nI := 17 to len(_aCopia)
			aAdd(_aClasFis,_aCopia[_nI])
		Next
		Exit
	EndIf
	
	do case
		case _ctrlcol == 1
			ncol := 2
			_ctrlcol++
		case _ctrlcol == 2
			ncol := 17
			_ctrlcol++
		case _ctrlcol == 3
			ncol := 32
			_ctrlcol++
		case _ctrlcol == 4
			ncol := 47
			_ctrlcol:=1
	endcase
	
	@ nLin, nCol pSay _aClasFis[nCont,1] + " " + Transform(_aClasFis[nCont,2],"@R 99.99.99.99")
	
	If ncol == 47 .and. ncont < 16
		nLin+=1
	EndIf
	
Next
nCol := 4
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Mensagens()
/////////////////////////////
nCont1 := 0
Do While ++nCont1 <= len(xCLFISCAL)
	nCont2 := 0
	aAdd(_aMensagens,xClFiscal[nCont1] + ' ' + tran(xClas_fis[nCont1],'@R 99.99.99.99') )
	Do While nCont1 < len(xCLFISCAL) .and. ++nCont2 <= 3
		_aMensagens[len(_aMensagens)] += '  ' + xClFiscal[++nCont1] + ' ' + tran(xClas_fis[nCont1],'@R 99.99.99.99')
	EndDo
EndDo

If !empty(xSuframa)
	aAdd(_aMensagens, "SUFRAMA : " + xSuframa)
EndIf
If mv_par04 == 1 .AND. xTIPO == "D" .OR. xTIPO == "B"
	aAdd(_aMensagens, " Nf. de Origem: " + xNUM_NFDV[1])
EndIf

// busca numero do romaneio - rf                                       '
cquery := " SELECT * FROM " + RetSqlName('PA6') + " (NOLOCK)"
cQuery += " WHERE D_E_L_E_T_ = '' AND "
cQuery += " PA6_NFS = '" + xnum_nf  + "' AND "
cQuery += " PA6_FILORI = '" + xfilial("SF2")  + "' AND "
cQuery += " D_E_L_E_T_ = ''"

TcQuery cquery NEW ALIAS "QRYCONT"

If !empty(QRYCONT->PA6_NUMROM)
	aAdd(_aMensagens, "Romaneio Numero: " + QRYCONT->PA6_NUMROM)
EndIf

QRYCONT->(DbCloseArea())

If lFimDet .And. xVALDESC > 0
	aAdd(_aMensagens, "Desconto: " + Alltrim(Transform(xVALDESC, "@E 999,999,99")))
EndIf

If !Empty(xFormula)  // Pega a formula contida na TES 
	
	If Len(xFormula) <= 60
		aAdd(_aMensagens, xFormula)
	Else
	    aAdd(_aMensagens, Substr(xFormula, 1, 60))  
	    aAdd(_aMensagens, Substr(xFormula, 61, LEN(xFormula))) 
	EndIf	
	
EndIf

If !Empty(xMenPad) .AND. AllTrim(xMenPad) <> AllTrim(xFormula)  // Pega a formula contida no pedido de Venda.

	If Len(xMenPad) <= 60
		aAdd(_aMensagens, xMenPad)
	Else
	    aAdd(_aMensagens, Substr(xMenPad, 1, 60))  
	    aAdd(_aMensagens, Substr(xMenPad, 61, LEN(xMenPad))) 
	EndIf	  

Endif

If xMeNota <> NIL .AND. !empty(xMeNota) //Jonas CARAIO DA PORRA DO PROGRAMADOR NÃO PREVEU QUE ESSA MATRIZ É CONDICIONAL!
	aAdd(_aMensagens, xMeNota[1])
EndIf // Jonas

Return()



 