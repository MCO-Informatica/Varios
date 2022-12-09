#include "rwmake.ch"
//
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: SHNOTAF                            Modulo : SIGAFAT      //
//                                                                          //
//   Autor ......: PAULO ROBERTO DE OLIVEIRA          Data ..: 13/08/01     //
//                                                                          //
//   Objetivo ...: Emissao de Notas Fiscais de Entrada/Saida                //
//                                                                          //
//   Uso ........: Especifico da Shangri-la                                 //
//                                                                          //
//   Observacoes : A emissao da nota fiscal sera em 1/6 e alguns detalhes   //
//                 com compressao de caracteres                             //
//                                                                          //
//   Atualizacao : 13/08/01 - PAULO ROBERTO DE OLIVEIRA                     //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
//

///////////////////////
User Function Shnotaf()
///////////////////////
//
SetPrvt("CBTXT,CBCONT,xMensage1,xMensage2,xMensage3")
SetPrvt("xMensage4,xMensage5,xMensage6")
SetPrvt("xMensage4,NORDEM,ALFA,Z,M,TAMANHO")
SetPrvt("LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CNATUREZA")
SetPrvt("ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN")
SetPrvt("WNREL,NTAMNF,CSTRING,CPEDANT,NLININI,XNUM_NF")
SetPrvt("XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE,XSEGURO")
SetPrvt("XDESPESA,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPLIQUI,XTIPO,XESPECIE")
SetPrvt("XVOLUME,XDESCZFR,CPEDATU,CITEMATU,XORD,XORDENA")
SetPrvt("XPED_VEND,XITEM_PED,XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO")
SetPrvt("XQTD_PRO,XPRE_UNI,XPRE_TAB,XIPI,XVAL_IPI,XDESC,XDESCON")
SetPrvt("XVAL_DESC,XVAL_MERC,XTES,XCF,XNATUREZA,XICMSOL")
SetPrvt("XICM_PROD,XICMSITE,XUNID_PRO,XCOD_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XISS,XTIPO_PRO,XCLFISCAL,XTIPOPRO,A,XPESO_PRO")
SetPrvt("XPESO_UNIT,XDESCRICAO,XMEN_TRIB,XMEN_POS,XLUCRO,XPESO_LIQ")
SetPrvt("I,XLPESO_LIQ,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID")
SetPrvt("XPED,XP_LIQ_PED,XC5_VEND1,XC5_NUM,XCLIENTE,XTIPO_CLI")
SetPrvt("XCOD_MENS,XTPFRETE,XCONDPAG,XBANCO,XPESOLIQUI,XPESOBRUTO")
SetPrvt("XCOD_MEN2,XCOD_MEN3,XCOD_MEN4")
SetPrvt("XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI,XDESC_PRO,J")
SetPrvt("XNOME_CLI,XEND_CLI,XBAIRRO,XCEP_CLI,XCOB_CLI,XREC_CLI")
SetPrvt("XMUN_CLI,XEST_CLI,XCGC_CLI,XINSC_CLI,XTRAN_CLI,XTEL_CLI,XDDD_CLI")
SetPrvt("XFAX_CLI,XSUFRAMA,XCALCSUF,ZFRANCA,XCOD_CLI,XVENDEDOR")
SetPrvt("XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP,XEST_TRANSP,XVIA_TRANSP")
SetPrvt("XCGC_TRANSP,XTEL_TRANSP,XINSC_TRANSP,XPARC_DUP,XVENC_DUP,XVALOR_DUP")
SetPrvt("XDUPLICATAS,XPORTADOR,XPEDCLI,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,NOPC,CCOR,NTAMDET,XB_ICMS_SOL,XV_ICMS_SOL")
SetPrvt("XX,AA,XORDIMP,WISS,WTOTSER,LPASSOU1,LPASSOU2")
SetPrvt("NCOL,NCONT,xMensage0,XNLIN,XLINDUP01,XLINDUP02")
SetPrvt("XLINDUP03,XLINDUP04,XLINDUP05,XLINDUP06,XLINDUP07,XLINDUP08")
SetPrvt("XNATOP,XCOLUNA,WSERV,WPROD,NCOPIAS,")
//
CbTxt     := ""                   // Variaveis de Ambiente
CbCont    := ""
xMensage1 := ""
xMensage2 := ""
xMensage3 := ""
xMensage4 := ""
xMensage5 := ""
xMensage6 := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
Tamanho   := "P"
Limite    := 80
Titulo    := "Nota Fiscal"
cDesc1    := "Este programa ira Emitir a Nota Fiscal de Entrada/Saida ou"
cDesc2    := "Orcamento de Venda."
cDesc3    := ""
cNatureza := ""
aReturn   := {"Especial", 1, "Administracao", 1, 1, 1, "", 1}
Nomeprog  := "SLNFISCA"
cPerg     := PADR("NFSIGW",LEN(SX1->X1_GRUPO))
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnRel     := "SHNOTAF"
nTamNf    := 81              // Apenas Informativo
cString   := "SF2"
wSERV     := .F.
wPROD     := .F.
nCopias   := 1
xC5_VEND1   := ""                  // Vendedor
xCONDPAG    := ""
//                                
Pergunte(cPerg, .F.)
//
wnRel := SetPrint(cString, wnRel, cPerg, Titulo, cDesc1, cDesc2, cDesc3,;
         .T., {}, .T., Tamanho)
//
If nLastKey == 27
   Return (.T.)
Endif
//
SetDefault(aReturn, cString)
//
If nLastKey == 27
   Return (.T.)
Endif
//
VerImp()
//
RptStatus({|| Shnff()})
//
Return (.T.)

///////////////////////
Static Function Shnff()
///////////////////////
//
If Mv_Par04 == 2                       // Saidas
   //
   nCopias := 2
   //
   If Empty(Mv_Par03)
      //
      @ 150, 180 To 270, 415 Dialog xJanela Title "Emissao de Orcamentos"
      //
      @ 010, 015 Say "Numero de Copias"
      @ 010, 065 Get nCopias Picture "@E 9" Valid (nCopias >= 1 .And.;
        nCopias <= 9) Size 10, 20
      //
      @ 035, 082 BmpButton Type 1 Action Close(xJanela)
      //
      Activate Dialog xJanela Center
      //
   Endif
   //
   DbSelectArea("SF2")
   DbSetOrder(1)
   DbSeek(xFilial("SF2") + Mv_Par01 + Mv_Par03, .T.)
   //
   DbSelectArea("SD2")
   DbSetOrder(3)
   DbSeek(xFilial("SD2") + Mv_Par01 + Mv_Par03)
   cPedant := SD2->D2_PEDIDO
   //
Else
   //
   DbSelectArea("SF1")                 // Entradas
   DbSetOrder(1)
   DbSeek(xFilial("SF1") + Mv_Par01 + Mv_Par03, .T.)
   //
   DbSelectArea("SD1")
   DbSetOrder(3)
   //
Endif
//
SetRegua(Val(Mv_Par02) - Val(Mv_Par01))
//
If Mv_Par04 == 2                       // Saidas
   //
   DbSelectArea("SF2")
   //
   While SF2->(!Eof()) .And. SF2->F2_DOC <= Mv_Par02 .And. lContinua
         //
         If SF2->F2_SERIE # Mv_Par03   // Verifica a Serie
            DbSkip()
            Loop
         Endif
         //
         If lAbortPrint
            @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
            lContinua := .F.
            Exit
         Endif
         //
         nLinIni := nLin               // Linha Inicial da Impressao
         //
         xNUM_NF     := SF2->F2_DOC              // Numero
         xSERIE      := SF2->F2_SERIE            // Serie
         xEMISSAO    := SF2->F2_EMISSAO          // Data de Emissao
         xTOT_FAT    := SF2->F2_VALBRUT          // Valor Total da Fatura
         //
         If xTOT_FAT == 0
            // xTOT_FAT := SF2->F2_VALMERC + SF2->F2_VALIPI + SF2->F2_SEGURO + SF2->F2_FRETE
         Endif
         //
         xLOJA       := SF2->F2_LOJA             // Loja do Cliente
         xFRETE      := SF2->F2_FRETE            // Frete
         xSEGURO     := SF2->F2_SEGURO           // Seguro
         xDESPESA    := SF2->F2_DESPESA          // Despesas acessorias
         xBASE_ICMS  := SF2->F2_BASEICM          // Base   do ICMS
         xBASE_IPI   := SF2->F2_BASEIPI          // Base   do IPI
         xVALOR_ICMS := SF2->F2_VALICM           // Valor  do ICMS
         xICMS_RET   := SF2->F2_ICMSRET          // Valor  do ICMS Retido
         xVALOR_IPI  := SF2->F2_VALIPI           // Valor  do IPI
         // xVALOR_MERC := SF2->F2_VALMERC       // Valor  da Mercadoria
         xVALOR_MERC := IIf(xTOT_FAT == 0, 0, SF2->F2_VALMERC)   // Valor  da Mercadoria
         xNUM_DUPLIC := SF2->F2_DUPL             // Numero da Duplicata
         xCOND_PAG   := SF2->F2_COND             // Condicao de Pagamento
         xPLIQUI     := SF2->F2_PLIQUI           // Peso Liquido
         xTIPO       := SF2->F2_TIPO             // Tipo da Nota
         xESPECIE    := SF2->F2_ESPECI1          // Especie 1 no Pedido
         xVOLUME     := SF2->F2_VOLUME1          // Volume 1 no Pedido
         xDESCZFR    := 0                        // Desc. ZONA FRANCA
         xDESCONT    := SF2->F2_DESCONT          // Desconto da Nota Fiscal
         //
         DbSelectArea("SD2")
         DbSetOrder(3)
         DbSeek(xFilial("SD2") + xNUM_NF + xSERIE)
         //
         cPedAtu   := SD2->D2_PEDIDO
         cItemAtu  := SD2->D2_ITEMPV
         xORD      := {}                    // Ordem Original
         xORDENA   := {}                    // Ordena Impressao DETALHE N.F. - ORDEM PEDIDO DE VENDA
         xPED_VEND := {}                    // Numero do Pedido de Venda
         xITEM_PED := {}                    // Numero do Item do Pedido de Venda
         xNUM_NFDV := {}                    // Numero qdo houver Devolucao
         xPREF_DV  := {}                    // Serie qdo houver Devolucao
         xICMS     := {}                    // Porcentagem do ICMS
         xCOD_PRO  := {}                    // Codigo  do Produto
         xQTD_PRO  := {}                    // Peso/Quantidade do Produto
         xPRE_UNI  := {}                    // Preco Unitario de Venda
         xPRE_TAB  := {}                    // Preco Unitario de Tabela
         xIPI      := {}                    // Porcentagem do IPI
         xVAL_IPI  := {}                    // Valor do IPI
         xDESC     := {}                    // Desconto por Item
         xVAL_DESC := {}                    // Valor do Desconto
         xVAL_MERC := {}                    // Valor da Mercadoria
         xTES      := {}                    // TES
         xCF       := {}                    // Classificacao quanto natureza da Operacao
         xNATUREZA := {}                    // Nat. de Operacao
         xICMSOL   := {}                    // Base do ICMS Solidario
         xICM_PROD := {}                    // ICMS do Produto
         xICMSITE  := {}
         nDescProd := 0                     // Desconto dos Produtos
         nDescServ := 0                     // Desconto dos Servicos
         //
         While SD2->(!Eof()) .And. SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_DOC == xNUM_NF .And. SD2->D2_SERIE == xSERIE
               //
               If SD2->D2_SERIE # Mv_Par03
                  DbSkip()
                  Loop
               Endif
               //
               Aadd(xORDENA  , SD2->D2_ITEMPV)
               Aadd(xORD     , {SD2->D2_ITEMPV, LEN(xORDENA)})
               Aadd(xPED_VEND, SD2->D2_PEDIDO)
               Aadd(xITEM_PED, SD2->D2_ITEMPV)
               //
               If Ascan(xNUM_NFDV, SD2->D2_NFORI) == 0
                  Aadd(xNUM_NFDV, SD2->D2_NFORI)
               Endif
               //
               Aadd(xPREF_DV, SD2->D2_SERIORI)
               Aadd(xICMS   , IIf(Empty(SD2->D2_PICM), 0, SD2->D2_PICM))
               Aadd(xCOD_PRO, SD2->D2_COD)
               Aadd(xQTD_PRO, SD2->D2_QUANT)     // Guarda Quant. da NF
               //
               If SD2->D2_DESCZFR == 0
                  Aadd(xVAL_MERC, (SD2->D2_TOTAL ))
                  Aadd(xPRE_UNI , (SD2->D2_PRCVEN ))
               Else
                  Aadd(xVAL_MERC, SD2->D2_TOTAL + SD2->D2_DESCZFR)
                  Aadd(xPRE_UNI , (SD2->D2_TOTAL + SD2->D2_DESCZFR) / SD2->D2_QUANT)
                  xDESCZFR := xDESCZFR + SD2->D2_DESCZFR
               Endif
               //
               Aadd(xPRE_TAB, SD2->D2_PRUNIT)
               Aadd(xIPI    , IIf(Empty(SD2->D2_IPI), 0, SD2->D2_IPI))
               Aadd(xVAL_IPI, SD2->D2_VALIPI)
               Aadd(xDESC   , SD2->D2_DESC)
               Aadd(xTES    , SD2->D2_TES)
               Aadd(xICMSITE, SD2->D2_VALICM)
               //
               If Ascan(xCF, SD2->D2_CF)==0
                  Aadd(xCF , SD2->D2_CF)
               Endif
               //
               Aadd(xICM_PROD, IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
               //
               If SD2->D2_TP # "MO"
                  nDescProd := nDescProd + SD2->D2_DESCON
               Else
                  nDescServ := nDescServ + SD2->D2_DESCON
               Endif
               //
               DbSelectArea("SD2")
               DbSkip()
               //
         Enddo
         //
         Asort(xORDENA,,,{|X,Y| X<Y})       // Ordem Crescente Itens Ped. Vda
         //
         DbSelectArea("SF4")
         DbSetOrder(1)
         //
         For A := 1 To LEN(xTES)
             DbSeek(xFilial("SF4")+xTES[A])
             If Ascan(xNATUREZA, SF4->F4_TEXTO) == 0
                Aadd(xNATUREZA , SF4->F4_TEXTO)  // Natureza da Operacao
             Endif
         Next
         //
         DbSelectArea("SB1")
         DbSetOrder(1)
         //
         xPESO_PRO  := {}                   // Peso Liquido
         xPESO_UNIT := {}                   // Peso Unitario do Produto
         xDESCRICAO := {}                   // Descricao do Produto
         xUNID_PRO  := {}                   // Unidade do Produto
         xCOD_TRIB  := {}                   // Codigo de Tributacao
         xMEN_TRIB  := {}                   // Mensagens de Tributacao
         xCOD_FIS   := {}                   // Cogigo Fiscal
         xCLAS_FIS  := {}                   // Classificacao Fiscal
         xMEN_POS   := {}                   // Mensagem da Posicao IPI
         xISS       := {}                   // Aliquota de ISS
         xTIPO_PRO  := {}                   // Tipo do Produto
         xLUCRO     := {}                   // Margem de Lucro p/ ICMS Solidario
         xCLFISCAL  := {}
         xTIPOPRO   := {}
         xPESO_LIQ  := 0
         I          := 1
         //
         For I := 1 To Len(xCOD_PRO)
             //
             DbSelectArea("SB1")
             DbSeek(xFilial("SB1")+xCOD_PRO[I])
             //
             Aadd(xPESO_PRO, SB1->B1_PESO * xQTD_PRO[I])
             xPESO_LIQ := xPESO_LIQ + (SB1->B1_PESO * xQTD_PRO[I])
             Aadd(xPESO_UNIT, SB1->B1_PESO)
             Aadd(xUNID_PRO, SB1->B1_UM)
             Aadd(xTIPOPRO, SB1->B1_TIPO)
             Aadd(xDESCRICAO, SB1->B1_DESC)
             //
             If Ascan(xMEN_TRIB, Substr(SC6->C6_CLASFIS, 1, 2)) == 0
                Aadd(xMEN_TRIB, Substr(SC6->C6_CLASFIS, 1, 2))
             Endif
             //
             npElem := Ascan(xCLAS_FIS,SB1->B1_POSIPI)
             //
             If npElem == 0
                Aadd(xCLAS_FIS, SB1->B1_POSIPI)
             Endif
             //
             npElem := Ascan(xCLAS_FIS, SB1->B1_POSIPI)
             //
             Do Case
                Case npElem == 1
                     _CLASFIS := "A"
                Case npElem == 2
                     _CLASFIS := "B"
                Case npElem == 3
                     _CLASFIS := "C"
                Case npElem == 4
                     _CLASFIS := "D"
                Case npElem == 5
                     _CLASFIS := "E"
                Case npElem == 6
                     _CLASFIS := "F"
                Case npElem == 7
                     _CLASFIS := "G"
                Case npElem == 8
                     _CLASFIS := "H"
                Case npElem == 9
                     _CLASFIS := "I"
             EndCase
             //
             nPteste := Ascan(xCLFISCAL, _CLASFIS)
             //
             If nPteste == 0
                Aadd(xCLFISCAL, _CLASFIS)
             Endif
             //
             Aadd(xCOD_FIS, SB1->B1_CLASFIS)
             //
             If SB1->B1_ALIQISS > 0
                Aadd(xISS, SB1->B1_ALIQISS)
             Endif
             //
             Aadd(xTIPO_PRO, SB1->B1_TIPO)
             Aadd(xLUCRO   , SB1->B1_PICMRET)
             //
             xPESO_LIQUID := 0              // Peso Liquido da Nota Fiscal
             //
             For I := 1 To Len(xPESO_PRO)
                 xPESO_LIQUID := xPESO_LIQUID + xPESO_PRO[I]
             Next
             //
         Next
         //
         xMensage1 := ""
         xMensage2 := ""
         xMensage3 := ""
         xMensage4 := ""
         xMensage5 := ""
         xMensage6 := ""
         //
         DbSelectArea("SC5")
         DbSetOrder(1)
         //
         xPED       := {}
         xP_LIQ_PED := 0
         //
         For I := 1 To Len(xPED_VEND)
             //
             DbSeek(xFilial("SC5")+xPED_VEND[I])
             //
             If Ascan(xPED,xPED_VEND[I]) == 0
                //
                DbSeek(xFilial("SC5")+xPED_VEND[I])
                //
                xC5_VEND1   := SC5->C5_VEND1          // Codigo do Vendedor
                xC5_NUM     := SC5->C5_NUM            // Numero do Pedido
                xPEDCLI     := ""                     // Nro Pedido do Cliente
                xCLIENTE    := SC5->C5_CLIENTE        // Codigo do Cliente
                xTIPO_CLI   := SC5->C5_TIPOCLI        // Tipo de Cliente
                xCOD_MENS   := SC5->C5_MENPAD         // Codigo da Mensagem Padrao
                xCOD_MEN2   := SC5->C5_MENPAD2        // Codigo da Mensagem Padrao
                xCOD_MEN3   := SC5->C5_MENPAD3        // Codigo da Mensagem Padrao
                xCOD_MEN4   := SC5->C5_MENPAD4        // Codigo da Mensagem Padrao                                                
                
                xMensage1   := SC5->C5_MENNOTA        // Mensagem 1 da Nota Fiscal
                xTPFRETE    := SC5->C5_TPFRETE        // Tipo de Entrega
                xCONDPAG    := SC5->C5_CONDPAG        // Condicao de Pagamento
                xBANCO      := SC5->C5_BANCO          // Banco (mauricio)
                xP_LIQ_PED  := xP_LIQ_PED + SC5->C5_PESOL  // Peso Liquido
                xPESOLIQUI  := SC5->C5_PESOL
                xPESOBRUTO  := SC5->C5_PBRUTO
                xCOD_VEND   := {SC5->C5_VEND1,;       // Codigo do Vendedor 1
                               SC5->C5_VEND2,;        // Codigo do Vendedor 2
                               SC5->C5_VEND3,;        // Codigo do Vendedor 3
                               SC5->C5_VEND4,;        // Codigo do Vendedor 4
                               SC5->C5_VEND5}         // Codigo do Vendedor 5
                xDESC_NF    := {SC5->C5_DESC1,;       // Desconto Global 1
                               SC5->C5_DESC2,;        // Desconto Global 2
                               SC5->C5_DESC3,;        // Desconto Global 3
                               SC5->C5_DESC4}         // Desconto Global 4
                Aadd(xPED, xPED_VEND[I])
                //
             Endif
             //
             If xP_LIQ_PED > 0
                xPESO_LIQ := xP_LIQ_PED
             Endif
             //
         Next
         //
         DbSelectArea("SA3")                // Condicao de Pagamento
         DbSetOrder(1)
         DbSeek(xFilial("SA3") + xC5_VEND1)
         xNOMVEND1 := Substr(SA3->A3_NOME, 1, 28)
         //
         DbSelectArea("SE4")                // Condicao de Pagamento
         DbSetOrder(1)
         DbSeek(xFilial("SE4") + xCONDPAG)
         xDESC_PAG := Substr(SE4->E4_COND, 1, 30)
         //
         DbSelectArea("SC6")
         DbSetOrder(1)
         //
         xPED_CLI  := {}                    // Numero de Pedido
         xDESC_PRO := {}                    // Descricao aux do produto
         J := Len(xPED_VEND)
         //
         For I := 1 To J
             //
             DbSeek(xFilial("SC6") + xPED_VEND[I] + xITEM_PED[I])
             //
             Aadd(xPED_CLI , SC6->C6_PEDCLI)
             Aadd(xDESC_PRO, SC6->C6_DESCRI)
             Aadd(xVAL_DESC, SC6->C6_VALDESC)
             Aadd(xCOD_TRIB, Substr(SC6->C6_CLASFIS, 1, 3))
             //
             xPEDCLI := Substr(IIf(Empty(xPEDCLI), SC6->C6_PEDCLI, xPEDCLI), 1, 10)
             //
         Next
         //
         If xTIPO == 'N' .Or. xTIPO == 'C' .Or. xTIPO == 'P' .Or. xTIPO == 'I' .OR. xTIPO == 'S' .Or. xTIPO == 'T' .Or. xTIPO == 'O'
            //
            DbSelectArea("SA1")
            DbSetOrder(1)
            DbSeek(xFilial("SA1") + xCLIENTE + xLOJA)
            //
            xCOD_CLI  := SA1->A1_COD             // Codigo do Cliente
            xNOME_CLI := SA1->A1_NOME            // Nome
            xEND_CLI  := SA1->A1_END             // Endereco
            xBAIRRO   := SA1->A1_BAIRRO          // Bairro
            xCEP_CLI  := SA1->A1_CEP             // CEP
            xCOB_CLI  := SA1->A1_ENDCOB          // Endereco de Cobranca
            xREC_CLI  := SA1->A1_ENDENT          // Endereco de Entrega
            xMUN_CLI  := SA1->A1_MUN             // Municipio
            xEST_CLI  := SA1->A1_EST             // Estado
			xCGC_CLI  := SA1->A1_CGC	     // CGC

            If SA1->A1_PESSOA == "J"
            	xINSC_CLI := SA1->A1_INSCR           // Inscricao estadual
	        Else
				xINSC_CLI := SA1->A1_PFISICA     // RG
	        EndIf	        	        
            xTRAN_CLI := SA1->A1_TRANSP          // Transportadora
			xDDD_CLI  := ALLTRIM(SA1->A1_DDD)
            xTEL_CLI  := SA1->A1_TEL             // Telefone
            xFAX_CLI  := SA1->A1_FAX             // Fax
            xSUFRAMA  := SA1->A1_SUFRAMA         // Codigo Suframa
            xCALCSUF  := SA1->A1_CALCSUF         // Calcula Suframa
            xENDCOB   := SA1->A1_ENDCOB          // Endereco de Cobranca
            xMUNCOB   := SA1->A1_MUNC            // Municipio de Cobranca
            xBAICOB   := SA1->A1_BAIRROC         // Bairro de Cobranca
            xESTCOB   := SA1->A1_ESTC            // Estado de Cobranca
            xCEPCOB   := SA1->A1_CEPC            // CEP de Cobranca
            xENDENT   := SA1->A1_ENDENT          // Endereco de Entrega
            xMUNENT   := SA1->A1_MUNE            // Municipio de Entrega
            xBAIENT   := SA1->A1_BAIRROE         // Bairro de Entrega
            xESTENT   := SA1->A1_ESTE            // Estado de Entrega
            xCEPENT   := SA1->A1_CEPE            // CEP de Entrega
            //
            If !Empty(xSUFRAMA) .And. xCALCSUF == "S"
               //
               If XTIPO == 'D' .OR. XTIPO == 'B'
                  zFranca := .F.
               Else
                  zFranca := .T.
               Endif
               //
            Else
               zFranca := .F.
            Endif
            //
         Else
            //
            zFranca := .F.
            //
            DbSelectArea("SA2")
            DbSetOrder(1)
            DbSeek(xFilial("SA2") + xCLIENTE + xLOJA)
            //
            xCOD_CLI := SA2->A2_COD              // Codigo do Fornecedor
            xNOME_CLI:= SA2->A2_NOME             // Nome Fornecedor
            xEND_CLI := SA2->A2_END              // Endereco
            xBAIRRO  := SA2->A2_BAIRRO           // Bairro
            xCEP_CLI := SA2->A2_CEP              // CEP
            xCOB_CLI := ""                       // Endereco de Cobranca
            xREC_CLI := ""                       // Endereco de Entrega
            xMUN_CLI := SA2->A2_MUN              // Municipio
            xEST_CLI := SA2->A2_EST              // Estado
            xCGC_CLI := SA2->A2_CGC              // CGC
            xINSC_CLI:= SA2->A2_INSCR            // Inscricao estadual
            xTRAN_CLI:= SA2->A2_TRANSP           // Transportadora
            xDDD_CLI := AllTrim(SA2->A2_DDD)     // DDD				
            xTEL_CLI := SA2->A2_TEL              // Telefone
            xFAX_CLI := SA2->A2_FAX              // Fax
            xENDCOB  := ""                       // Endereco de Cobranca
            xMUNCOB  := ""                       // Municipio de Cobranca
            xBAICOB  := ""                       // Bairro de Cobranca
            xESTCOB  := ""                       // Estado de Cobranca
            xCEPCOB  := ""                       // CEP de Cobranca
            xENDENT  := ""                       // Endereco de Entrega
            xMUNENT  := ""                       // Municipio de Entrega
            xBAIENT  := ""                       // Bairro de Entrega
            xESTENT  := ""                       // Estado de Entrega
            xCEPENT  := ""                       // CEP de Entrega
            //
         Endif
         //
         DbSelectArea("SA3")
         DbSetOrder(1)
         //
         xVENDEDOR := {}                         // Nome do Vendedor
         I := 1
         J := Len(xCOD_VEND)
         //
         For I := 1 to J
             DbSeek(xFilial("SA3")+xCOD_VEND[I])
             Aadd(xVENDEDOR, SA3->A3_NREDUZ)
         Next
         //
         If xICMS_RET > 0                        // Apenas se ICMS Retido > 0
            //
            DbSelectArea("SF3")
            DbSetOrder(4)
            DbSeek(xFilial("SF3") + SA1->A1_COD + SA1->A1_LOJA + SF2->F2_DOC + SF2->F2_SERIE)
            //
            If Found()
               xBSICMRET := F3_VALOBSE
            Else
               xBSICMRET := 0
            Endif
            //
         Else
            xBSICMRET := 0
         Endif
         //
         DbSelectArea("SA4")
         DbSetOrder(1)
         DbSeek(xFilial("SA4")+SF2->F2_TRANSP)
         //
         xNOME_TRANSP := SA4->A4_NOME       // Nome Transportadora
         xEND_TRANSP  := SA4->A4_END        // Endereco da Transportadora
         xMUN_TRANSP  := SA4->A4_MUN        // Municipio
         xEST_TRANSP  := SA4->A4_EST        // Estado
         xVIA_TRANSP  := SA4->A4_VIA        // Via de Transporte
         xCGC_TRANSP  := SA4->A4_CGC        // CGC
         xTEL_TRANSP  := SA4->A4_TEL        // Fone
         xINSC_TRANSP := SA4->A4_INSEST     // Insc. Estadual
         //
         DbSelectArea("SE1")
         DbSetOrder(1)
         //
         xPARC_DUP   := {}                  // Parcela
         xVENC_DUP   := {}                  // Vencimento
         xVALOR_DUP  := {}                  // Valor
         xDUPLICATAS := IIf(DbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
         //
         xPORTADOR := " "
         xCOB_CLI  := " "                   // Endereco de Cobranca
         //
         If xDUPLICATAS
            //
            DbSelectArea("SA6")
            DbSetOrder(1)
            DbSeek(xFilial("SA6")+xBANCO)
            //
            xPORTADOR := Trim(xBANCO)+" - "+Left(SA6->A6_NOME,27)
            xCOB_CLI  := Trim(SA1->A1_ENDCOB)
            //
         Endif
         //
         DbSelectArea("SE1")
         //
         While !Eof() .And. SE1->E1_NUM == xNUM_DUPLIC .And. xDUPLICATAS == .T.
               //
               If !("NF" $ SE1->E1_TIPO)
                  DbSkip()
                  Loop
               Endif
               //
               Aadd(xPARC_DUP , SE1->E1_PARCELA)
               Aadd(xVENC_DUP , SE1->E1_VENCTO)
               Aadd(xVALOR_DUP, SE1->E1_VALOR)
               //
               DbSkip()
               //
         End
         //
         If !Empty(SF2->F2_SERIE)      // Serie Preenchida, Imprimir NF
            //
            ImpNotaF()
            //
         Else                          // Serie em Branco, Imprimir Orcamento
            //
            ImpOrcam()
            //
         Endif
         //
         IncRegua()                    // Termometro de Impressao
         //
         nLin := 0
         //
         DbSelectArea("SF2")
         Rlock()
         SF2->F2_FIMP := "S"
         MsUnlock()
         //
         DbSkip()                      // Passa para a Proxima Nota Fiscal
         //
   Enddo
   //
Else                                   // Entradas
   //
   DbSelectArea("SF1")
   DbSeek(xFilial("SF1") + Mv_Par01 + Mv_Par03, .T.)
   //
   While SF1->(!Eof()) .And. SF1->F1_DOC <= Mv_Par02 .And. SF1->F1_SERIE == Mv_Par03 .And. lContinua
         //
         If SF1->F1_SERIE # Mv_Par03    // Se a Serie do Arquivo for Diferente
            DbSkip()                    // do Parametro Informado !!!
            Loop
         Endif
         //
         SetRegua(Val(Mv_Par02) - Val(Mv_Par01))
         //
         If lAbortPrint
            @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
            lContinua := .F.
            Exit
         Endif
         //
         nLinIni := nLin                    // Linha Inicial da Impressao
         //
         xDESCZFR    := 0                   // Desconto ZONA FRANCA
         xNUM_NF     := SF1->F1_DOC         // Numero
         xDESPESA    := SF1->F1_DESPESA     // Despesa
         xC5_VEND1   := ""                  // Vendedor
         xNOMVEND1   := ""                  // Nome do Vendedor
         xC5_NUM     := ""                  // Numero do Pedido
         xPEDCLI     := ""                  // Nro Pedido do Cliente
         xSERIE      := SF1->F1_SERIE       // Serie
         xFORNECE    := SF1->F1_FORNECE     // Cliente/Fornecedor
         xEMISSAO    := SF1->F1_EMISSAO     // Data de Emissao
         xTOT_FAT    := SF1->F1_VALBRUT     // Valor Bruto da Compra
         xLOJA       := SF1->F1_LOJA        // Loja do Cliente
         xFRETE      := SF1->F1_FRETE       // Frete
         xSEGURO     := 0                   // Seguro
         xBASE_ICMS  := SF1->F1_BASEICM     // Base   do ICMS
         xBASE_IPI   := SF1->F1_BASEIPI     // Base   do IPI
         xBSICMRET   := SF1->F1_BRICMS      // Base do ICMS Retido
         xVALOR_ICMS := SF1->F1_VALICM      // Valor  do ICMS
         xICMS_RET   := SF1->F1_ICMSRET     // Valor  do ICMS Retido
         xVALOR_IPI  := SF1->F1_VALIPI      // Valor  do IPI
         xVALOR_MERC := SF1->F1_VALMERC     // Valor  da Mercadoria
         xNUM_DUPLIC := SF1->F1_DUPL        // Numero da Duplicata
         xCOND_PAG   := SF1->F1_COND        // Condicao de Pagamento
         xTIPO       := SF1->F1_TIPO        // Tipo do Cliente
         xNFORI      := SF1->F1_NFORI       // NF Original
         xPREF_DV    := SF1->F1_SERIORI     // Serie Original
         xPESOLIQUI  := SF1->F1_PESOL       // Peso Liquido
         xPESOBRUTO  := SF1->F1_PESOL       // Peso Bruto
         xDESCONT    := 0                   // Desconto da Nota Fiscal
         //
         xMensage1 := ""
         xMensage2 := ""
         xMensage3 := ""
         xMensage4 := ""
         xMensage5 := ""
         xMensage6 := ""
         //
         DbSelectArea("SD1")
         DbSetOrder(1)
         DbSeek(xFilial("SD1") + xNUM_NF + xSERIE + xFORNECE + xLOJA)
         //
         cPedAtu   := SD1->D1_PEDIDO
         cItemAtu  := SD1->D1_ITEMPC
         xPEDIDO   := {}                    // Numero do Pedido de Compra
         xITEM_PED := {}                    // Numero do Item do Pedido de Compra
         xNUM_NFDV := {}                    // Numero quando houver devolucao
         xPREF_DV  := {}                    // Serie  quando houver devolucao
         xICMS     := {}                    // Porcentagem do ICMS
         xCOD_PRO  := {}                    // Codigo  do Produto
         xQTD_PRO  := {}                    // Peso/Quantidade do Produto
         xPRE_UNI  := {}                    // Preco Unitario de Compra
         xIPI      := {}                    // Porcentagem do IPI
         xPESOPROD := {}                    // Peso do Produto
         xVAL_IPI  := {}                    // Valor do IPI
         xDESC     := {}                    // Desconto por Item
         xVAL_DESC := {}                    // Valor do Desconto
         xVAL_MERC := {}                    // Valor da Mercadoria
         xTES      := {}                    // TES
         xCF       := {}                    // Classificacao quanto natureza da Operacao
         xNATUREZA := {}                    // NATUREZA OPERACAO
         xICMSOL   := {}                    // Base do ICMS Solidario
         xICM_PROD := {}                    // ICMS do Produto
         xICMS     := {}
         nDescProd := 0                     // Desconto dos Produtos
         nDescServ := 0                     // Desconto dos Servicos
         //
         While SD1->(!Eof()) .And. SD1->D1_DOC == xNUM_NF
               //
               If SD1->D1_SERIE # Mv_Par03  // Se a Serie do Arquivo for Diferente
                  DbSkip()                  // do Parametro Informado !!!
                  Loop
               Endif
               //
               Aadd(xPEDIDO  , SD1->D1_PEDIDO)        // Ordem de Compra
               Aadd(xITEM_PED, SD1->D1_ITEMPC)        // Item da O.C.
               //
               If Ascan(xNUM_NFDV,SD1->D1_NFORI) == 0
                  Aadd(xNUM_NFDV,SD1->D1_NFORI)
               Endif
               //
               Aadd(xPREF_DV , SD1->D1_SERIORI)       // Serie Original
               Aadd(xICMS    , IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
               Aadd(xCOD_PRO , SD1->D1_COD)           // Produto
               Aadd(xQTD_PRO , SD1->D1_QUANT)         // Guarda as quant. da NF
               Aadd(xPRE_UNI , SD1->D1_VUNIT)         // Valor Unitario
               Aadd(xIPI     , SD1->D1_IPI)           // % IPI
               Aadd(xVAL_IPI , SD1->D1_VALIPI)        // Valor do IPI
               Aadd(xPESOPROD, SD1->D1_PESO)          // Peso do Produto
               Aadd(xDESC    , SD1->D1_DESC)          // % Desconto
               Aadd(xVAL_MERC, SD1->D1_TOTAL)         // Valor Total
               Aadd(xTES     , SD1->D1_TES)           // Tipo de Entrada/Saida
               //
               If Ascan(xCF, SD1->D1_CF) == 0
                  Aadd(xCF , SD1->D1_CF)
               Endif
               //
               Aadd(xICM_PROD, IIf(Empty(SD1->D1_PICM), 0, SD1->D1_PICM))
               //
               DbSelectArea("SD1")
               DbSkip()
               //
         Enddo
         //
         DbSelectArea("SF4")
         DbSetOrder(1)
         //
         For A := 1 To LEN(xTES)
             //
             DbSeek(xFilial("SF4")+xTES[A])
             //
             If Ascan(xNATUREZA, SF4->F4_TEXTO) == 0
                Aadd(xNATUREZA , SF4->F4_TEXTO)       // Natureza da Operacao
             Endif
             //
         Next
         //
         DbSelectArea("SB1")
         DbSetOrder(1)
         //
         xUNID_PRO  := {}                   // Unidade do Produto
         xDESC_PRO  := {}                   // Descricao do Produto
         xMEN_POS   := {}                   // Mensagem da Posicao IPI
         xDESCRICAO := {}                   // Descricao do Produto
         xCOD_TRIB  := {}                   // Codigo de Tributacao
         xMEN_TRIB  := {}                   // Mensagens de Tributacao
         xCOD_FIS   := {}                   // Cogigo Fiscal
         xCLAS_FIS  := {}                   // Classificacao Fiscal
         xISS       := {}                   // Aliquota de ISS
         xTIPO_PRO  := {}                   // Tipo do Produto
         xLUCRO     := {}                   // Margem de Lucro p/ ICMS Solidario
         xCLFISCAL  := {}
         xTIPOPRO   := {}
         xSUFRAMA   := ""
         xCALCSUF   := ""
         I          := 1
         //
         For I := 1 To Len(xCOD_PRO)
             //
             DbSelectArea("SB1")
             DbSeek(xFilial("SB1")+xCOD_PRO[I])
             //
             Aadd(xDESC_PRO, SB1->B1_DESC)
             Aadd(xTIPOPRO , SB1->B1_TIPO)
             Aadd(xUNID_PRO, SB1->B1_UM)
             Aadd(xCOD_TRIB, SB1->B1_ORIGEM)
             //
             If Ascan(xMEN_TRIB, SB1->B1_ORIGEM) == 0
                Aadd(xMEN_TRIB , SB1->B1_ORIGEM)
             Endif
             //
             Aadd(xDESCRICAO, SB1->B1_DESC)
             Aadd(xMEN_POS  , SB1->B1_POSIPI)
             //
             If SB1->B1_ALIQISS > 0
                Aadd(xISS, SB1->B1_ALIQISS)
             Endif
             //
             Aadd(xTIPO_PRO, SB1->B1_TIPO)
             Aadd(xLUCRO   , SB1->B1_PICMRET)
             //
             npElem := Ascan(xCLAS_FIS, SB1->B1_POSIPI)
             //
             If npElem == 0
                Aadd(xCLAS_FIS, SB1->B1_POSIPI)
             Endif
             //
             npElem := Ascan(xCLAS_FIS, SB1->B1_POSIPI)
             //
             DO Case
                Case npElem == 1
                     _CLASFIS := "A"
                Case npElem == 2
                     _CLASFIS := "B"
                Case npElem == 3
                     _CLASFIS := "C"
                Case npElem == 4
                     _CLASFIS := "D"
                Case npElem == 5
                     _CLASFIS := "E"
                Case npElem == 6
                     _CLASFIS := "F"
            ENDCase
            //
            nPteste := Ascan(xCLFISCAL,_CLASFIS)
            //
            If nPteste == 0
               Aadd(xCLFISCAL, _CLASFIS)
            Endif
            //
            Aadd(xCOD_FIS , _CLASFIS)
            //
         Next
         //
         DbSelectArea("SE4")
         DbSetOrder(1)
         DbSeek(xFilial("SE4") + xCOND_PAG)
         xDESC_PAG := SE4->E4_COND
         //
         If xTIPO == "D" .OR. xTIPO == "B"
            //
            DbSelectArea("SA1")
            DbSetOrder(1)
            DbSeek(xFilial("SA1") + xFORNECE)
            //
            xCOD_CLI  := SA1->A1_COD             // Codigo do Cliente
            xNOME_CLI := SA1->A1_NOME            // Nome
            xEND_CLI  := SA1->A1_END             // Endereco
            xBAIRRO   := SA1->A1_BAIRRO          // Bairro
            xCEP_CLI  := SA1->A1_CEP             // CEP
            xCOB_CLI  := SA1->A1_ENDCOB          // Endereco de Cobranca
            xREC_CLI  := SA1->A1_ENDENT          // Endereco de Entrega
            xMUN_CLI  := SA1->A1_MUN             // Municipio
            xEST_CLI  := SA1->A1_EST             // Estado
            xCGC_CLI  := SA1->A1_CGC             // CGC
            If SA1->A1_PESSOA == "J"
            	xINSC_CLI := SA1->A1_INSCR           // Inscricao estadual
	        Else
				xINSC_CLI := SA1->A1_PFISICA     // RG
	        EndIf	        	        
//            xINSC_CLI := SA1->A1_INSCR           // Inscricao estadual
            xTRAN_CLI := SA1->A1_TRANSP          // Transportadora
            xDDD_CLI  := AllTrim(SA1->A1_DDD)     // DDD
            xTEL_CLI  := SA1->A1_TEL             // Telefone
            xFAX_CLI  := SA1->A1_FAX             // Fax
            xENDCOB   := SA1->A1_ENDCOB          // Endereco de Cobranca
            xMUNCOB   := SA1->A1_MUNC            // Municipio de Cobranca
            xBAICOB   := SA1->A1_BAIRROC         // Bairro de Cobranca
            xESTCOB   := SA1->A1_ESTC            // Estado de Cobranca
            xCEPCOB   := SA1->A1_CEPC            // CEP de Cobranca
            xENDENT   := SA1->A1_ENDENT          // Endereco de Entrega
            xMUNENT   := SA1->A1_MUNE            // Municipio de Entrega
            xBAIENT   := SA1->A1_BAIRROE         // Bairro de Entrega
            xESTENT   := SA1->A1_ESTE            // Estado de Entrega
            xCEPENT   := SA1->A1_CEPE            // CEP de Entrega
            //
         Else
            //
            DbSelectArea("SA2")
            DbSetOrder(1)
            DbSeek(xFilial("SA2") + xFORNECE + xLOJA)
            //
            xCOD_CLI  := SA2->A2_COD             // Codigo do Cliente
            xNOME_CLI := SA2->A2_NOME            // Nome
            xEND_CLI  := SA2->A2_END             // Endereco
            xBAIRRO   := SA2->A2_BAIRRO          // Bairro
            xCEP_CLI  := SA2->A2_CEP             // CEP
            xCOB_CLI  := ""                      // Endereco de Cobranca
            xREC_CLI  := ""                      // Endereco de Entrega
            xMUN_CLI  := SA2->A2_MUN             // Municipio
            xEST_CLI  := SA2->A2_EST             // Estado
            xCGC_CLI  := SA2->A2_CGC             // CGC
            xINSC_CLI := SA2->A2_INSCR           // Inscricao estadual
            xTRAN_CLI := SA2->A2_TRANSP          // Transportadora
			xDDD_CLI  := Alltrim(SA2->A2_DDD)    // Telefone            
            xTEL_CLI  := SA2->A2_TEL             // Telefone
            xFAX_CLI  := SA2->A2_FAX             // Fax
            xENDCOB   := ""                      // Endereco de Cobranca
            xMUNCOB   := ""                      // Municipio de Cobranca
            xBAICOB   := ""                      // Bairro de Cobranca
            xESTCOB   := ""                      // Estado de Cobranca
            xCEPCOB   := ""                      // CEP de Cobranca
            xENDENT   := ""                      // Endereco de Entrega
            xMUNENT   := ""                      // Municipio de Entrega
            xBAIENT   := ""                      // Bairro de Entrega
            xESTENT   := ""                      // Estado de Entrega
            xCEPENT   := ""                      // CEP de Entrega
            //
         Endif
         //
         DbSelectArea("SE1")
         DbSetOrder(1)
         //
         xPARC_DUP   := {}                       // Parcela
         xVENC_DUP   := {}                       // Vencimento
         xVALOR_DUP  := {}                       // Valor
         xDUPLICATAS := IIf(DbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.)  // Flag p/ Impressao de Duplicatas
         //
         While !Eof() .And. SE1->E1_NUM == xNUM_DUPLIC .And. xDUPLICATAS == .T.
               //
               Aadd(xPARC_DUP , SE1->E1_PARCELA)
               Aadd(xVENC_DUP , SE1->E1_VENCTO)
               Aadd(xVALOR_DUP, SE1->E1_VALOR)
               //
               DbSkip()
               //
         Enddo
         //
         xNOME_TRANSP := " "           // Nome Transportadora
         xEND_TRANSP  := " "           // Endereco
         xMUN_TRANSP  := " "           // Municipio
         xEST_TRANSP  := " "           // Estado
         xVIA_TRANSP  := " "           // Via de Transporte
         xCGC_TRANSP  := " "           // Cgc
         xINSC_TRANSP := " "           // Inscr. Estad.
         xTEL_TRANSP  := " "           // Fone
         xTPFRETE     := " "           // Tipo de Frete
         xVOLUME      := 0             // Volume
         xESPECIE     := " "           // Especie
         xPESO_LIQ    := 0             // Peso Liquido
         xCOD_MENS    := " "           // Codigo da Mensagem
         xCOD_MENS    := "   "         // Codigo da Mensagem Padrao
		 XCOD_MEN2	  := " "           // Codigo da Mensagem Padrao 2
		 XCOD_MEN3	  := " "		   // Codigo da Mensagem Padrao 3
		 XCOD_MEN4    := " "		   // Codigo da Mensagem Padrao 4
         xPESO_LIQUID := " "
         //
         ImpNotaF()
         //
         IncRegua()                    // Termometro de Impressao
         //
         nLin := 0
         //
         DbSelectArea("SF1")
         DbSkip()                      // Passa para a Proxima Nota Fiscal
         //
   Enddo
   //
Endif
//
@ nLin, 000 PSAY " " + Chr(18)         // Reset de Impressao
// @ nLin, 000 PSAY " "
SetPrc(0,0)
//
DbSelectArea("SF2")
Retindex("SF2")
DbSelectArea("SF1")
Retindex("SF1")
DbSelectArea("SD2")
Retindex("SD2")
DbSelectArea("SD1")
Retindex("SD1")
//
Set Device To Screen
//
If aReturn[5] == 1
   Set Printer To
   DbcommitAll()
   OurSpool(wnRel)
Endif

MS_FLUSH()

//
Return (.T.)

////////////////////////
Static Function VerImp()
////////////////////////
//
nLin    := 0                 // Contador de Linhas
nLinIni := 0
//
If aReturn[5] == 2 .Or. aReturn[5] == 3
   //
   nOpc := 1
   //
   While .T.
         //
         SetPrc(0,0)
         dbCommitAll()
         //
         @ nLin ,000 PSAY " "
         @ nLin ,004 PSAY " "
         @ nLin ,022 PSAY " "
         //
         If MsgYesNo("Formulario esta Posicionado ? ")
            nOpc := 1
         ElseIF MsgYesNo("Tenta Novamente ? ")
            nOpc := 2
         Else
            nOpc := 3
         Endif
         //
         Do Case
            Case nOpc == 1
                 lContinua := .T.
                 Exit
            Case nOpc == 2
                 @ nLin ,000 PSAY " "
                 @ nLin ,004 PSAY "*"
                 @ nLin ,022 PSAY "."
                 Loop
            Case nOpc == 3
                 lContinua := .F.
                 Return
          EndCase
   Enddo
   //
Endif
//
Return (.T.)

/////////////////////////
Static Function ClasFis()
/////////////////////////
//
nCol := 4
//
For nCont := 1 To Len(xCLFISCAL)
    //
    If (nCol / 4) == 14
       nCol := 4
       nLin := nLin + 1
    Endi
    //
    @ nLin, nCol PSAY xCLFISCAL[nCont] + "-"
    @ nLin, nCol + 03 PSAY Transform(xCLAS_FIS[nCont],"@R 9999999999")
    nCol := nCol + 13
    //
Next
//
Return (.T.)

////////////////////////
Static Function Duplic()
////////////////////////
//
If Mv_Par04 == 2                       // Dados da Fatura
   //
   If xDUPLICATAS == .T.
      //
      xLinDup01 := ""
      xLinDup02 := ""
      xLinDup03 := ""
      xLinDup04 := ""
      //
      If Len(xPARC_DUP) > 0
         xLinDup01 := Space(1) + xNUM_NF + xPARC_DUP[01] + Space(2) + Transform(xVALOR_DUP[01], "@E 99,999,999.99") + Space(3) + Dtoc(xVENC_DUP[01])
      Endif
      //
      If Len(xPARC_DUP) > 1
         xLinDup02 := Space(1) + xNUM_NF + xPARC_DUP[02] + Space(2) + Transform(xVALOR_DUP[02], "@E 99,999,999.99") + Space(3) + Dtoc(xVENC_DUP[02])
      Endif
      //
      If Len(xPARC_DUP) > 2
         xLinDup03 := Space(1) + xNUM_NF + xPARC_DUP[03] + Space(2) + Transform(xVALOR_DUP[03], "@E 99,999,999.99") + Space(3) + Dtoc(xVENC_DUP[03])
      Endif
      //
      If Len(xPARC_DUP) > 3
         xLinDup04 := Space(1) + xNUM_NF + xPARC_DUP[04] + Space(2) + Transform(xVALOR_DUP[04], "@E 99,999,999.99") + Space(3) + Dtoc(xVENC_DUP[04])
      Endif
      //
      If !Empty(xLinDup01)
         @ 22, 008 PSAY xLinDup01
      Endif
      //
      If !Empty(xLinDup02)
         @ 22, 043 PSAY xLinDup02
      Endif
      //
      If !Empty(xLinDup03)
         @ 23, 008 PSAY xLinDup03
      Endif
      //
      If !Empty(xLinDup04)
         @ 23, 043 PSAY xLinDup04
      Endif
      //
   Endif
   //
Endif
//
Return (.T.)

//////////////////////////
Static Function ImpNotaF()
//////////////////////////
//
@ 00, 000 PSAY ""
//
If Mv_Par04 == 1                            // NF de Entrada
   @ 07, 058 PSAY "X"
Else                                        // NF de Saida
   @ 07, 048 PSAY "X"
Endif
//
xNATOP := {}
//
For A := 1 To Len(xCF)
    //
    If Ascan(xNATOP, xCF[A]+xNATUREZA[A]) == 0
       Aadd(xNATOP , xCF[A]+xNATUREZA[A])
    Endif
    //
Next
//
Asort(xNATOP,,,{|X,Y| X<Y})            // Coloca em Ordem Crescente CFO
//
xCOLUNA := 0
//
For A := 1 To Len(xNATOP)
    //
    @ 12, 001+xCOLUNA PSAY Substr(Substr(xNATOP[A], 5, Len(Rtrim(xNATOP[A])) - 4), 1, 15) + ;
         IIf(A == 1," ","/")     // Texto da Natureza de Operacao
    xCOLUNA := xCOLUNA + Len(Rtrim(xNATOP[A])) - 1
    //

//    @ 12, 001+xCOLUNA PSAY Substr(Substr(xNATOP[A], 5, Len(Rtrim(xNATOP[A])) - 4), 1, 15) + ;
//         IIf(A == 1," ","/")     // Texto da Natureza de Operacao
//    xCOLUNA := xCOLUNA + Len(Rtrim(xNATOP[A])) - 1
//
Next
//
xCOLUNA := 0
xCODCFO := ""
//
For A := 1 To Len(xNATOP)
    //
    xBARRA  := IIf(A == 1,"","/")  
    xCODCFO := xCODCFO + xBARRA + Alltrim(Substr(xNATOP[A], 1, 4))    
    //
Next
//
@ 12, 024 PSAY xCODCFO                      // C.F.O.
//
@ 15, 002 PSAY Substr(xNOME_CLI, 1, 40)     // Nome do Cliente
//
If Mv_Par04 == 1                            // NF de Entrada
   // @ 14, 041 PSAY xCOD_CLI
Else                                        // NF de Saida
   // @ 14, 041 PSAY xCLIENTE
Endif
//
If !Empty(xCGC_CLI)                         // C.G.C. ou C.P.F.
   //
   If Len(Alltrim(xCGC_CLI)) == 11
      @ 15, 050 PSAY xCGC_CLI Picture "@R 999.999.999-99"          // C.P.F.
   Else
      @ 15, 049 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"      // C.G.C.
   Endif
   //
Else
   @ 15, 049 PSAY " "
Endif
//
@ 15, 070 PSAY xEMISSAO                // Data da Emissao do Documento
@ 17, 002 PSAY SubStr(xEND_CLI,1,38)   // Endereco
@ 17, 041 PSAY Substr(xBAIRRO, 1, 16)  // Bairro
@ 17, 059 PSAY Transform(xCEP_CLI, "@R 99999-999")
@ 17, 070 PSAY xEMISSAO //dDataBase               // Data da Saida
//
@ 19, 002 PSAY Alltrim(substr(xMUN_CLI,1,26))                // Municipio
@ 19, 029 PSAY IIf(!Empty(xDDD_CLI),xDDD_CLI+" "+Substr(xTEL_CLI, 1, 11),Substr(xTEL_CLI, 1, 11)) // + " - " + xFAX_CLI // Telefone/FAX
@ 19, 043 PSAY xEST_CLI                // U.F.
@ 19, 049 PSAY xINSC_CLI               // Insc. Estadual
@ 19, 071 PSAY " "                     // Reservado p/Hora da Saida
//
Duplic()                     // Impressao de Duplicatas
//
@ 25, 002 PSAY Chr(15) + Substr(xENDCOB, 1, 70) + "   " + Substr(xBAICOB, 1, 15) +;  //Mudanca do Campo a1_endecob para 70 posicoes, era 40 posicoes
  "   " + Substr(xMUNCOB, 1, 15) + "   " + xESTCOB + "   " +;
  IIf(!Empty(xCEPCOB), Transform(xCEPCOB, "@R 99999-999"), "") + Chr(18)
//
nLin    := 29 // Mudei de 28 p/ 29 a pedido de Ardriana - Roberto Oliveira 18/03/02
nTamDet := 19                // Tamanho da Area de Detalhe
xQtdVol := 0                 // Quantidade de Volumes Calculada
xPesoLi := 0                 // Peso Liquido Calculado
xPesoBr := 0                 // Peso Bruto Calculado
I       := 1
//
For I := 1 To nTamDet
      //
      If I <= Len(xCOD_PRO)
         //
         xORDIMP := I
         //
         DbSelectArea("SB1")
         DbSeek(xFilial("SB1") + xCOD_PRO[xORDIMP])
         //
         If xTIPO # "I"
            //
            @ nLin, 001 PSAY Chr(15) + Substr(Strtran(xCOD_PRO[xORDIMP], ".", ""), 1, 8)
            @ nLin, 011 PSAY Substr(xDESC_PRO[xORDIMP], 1, 40)
            @ nLin, 060 PSAY SB1->B1_CLASFIS        // xCOD_FIS[xORDIMP]
            @ nLin, 063 PSAY xCOD_TRIB[xORDIMP] //SB1->B1_ORIGEM         // xCOD_TRIB[xORDIMP]
            @ nLin, 070 PSAY SB1->B1_UM             // xUNID_PRO[xORDIMP]
            @ nLin, 074 PSAY xQTD_PRO[xORDIMP]      Picture "@E 99999.999"
            @ nLin, 082 PSAY xPRE_UNI[xORDIMP]      Picture "@E 9999999.999"
            @ nLin, 100 PSAY xVAL_MERC[xORDIMP]     Picture "@E 9999999.99"
            If !Empty(xSUFRAMA) .And. xCALCSUF == "S"
               @ nLin, 116 PSAY 0 Picture "@E 99"
            Else
               @ nLin, 116 PSAY xICM_PROD[xORDIMP]     Picture "@E 99"
            Endif   
            @ nLin, 120 PSAY xIPI[xORDIMP]          Picture "@E 99"
            @ nLin, 123 PSAY xVAL_IPI[xORDIMP]      Picture "@E 999999.99"
            @ nLin, 132 PSAY Chr(18)
            //
            xQtdVol := xQtdVol + xQTD_PRO[xORDIMP]
            xPesoLi := xPesoLi + (xQTD_PRO[xORDIMP] * SB1->B1_PESO)
            xPesoBr := xPesoBr + (xQTD_PRO[xORDIMP] * SB1->B1_PESO)
            //
         Endif
         //
         nLin := nLin + 1
         //
      Endif
      //
Next
//
//If xVOLUME == 0 // Adriana pediu para imprimir o zero mesmo -Roberto 18/03/02
//   xVOLUME := xQtdVol
//Endif
//
If xPESOLIQUI == 0
   xPESOLIQUI := xPesoLi
Endif
//
If xPESOBRUTO == 0
   xPESOBRUTO := xPesoBr
Endif
//
//nLin := 48 // Mudei de 47 p/ 48 a pedido de Adriana - Roberto Oliveira 18/03/02
nLin := 45 // Mudei de 48 p/ 45 a pedido de Adriana - Felipe Pieroni 01/08/02
//      
xMensage2 := ""
If !Empty(xCOD_MENS)
   //
   DbSelectArea("SM4")
   DbSetOrder(1)
   //
   xMensage0 := Substr(Formula(xCOD_MENS), 1, 128)
   xMensage2 := Substr(Formula(xCOD_MENS), 129, 128)
   //
   @ nLin, 002 PSAY Chr(15) + xMensage0 + Chr(18)
   //
Endif             
// Mensagem Padrao 2
nLin := 46
xMens2  := ""
If !Empty(xCOD_MEN2)
   //
   DbSelectArea("SM4")
   DbSetOrder(1)
   //
   xMens2 := Substr(Formula(xCOD_MEN2), 1, 130)
   //
   @ nLin, 002 PSAY Chr(15) + xMens2 + Chr(18)
   //
Endif             
// Mensagem Padrao 3
nLin := 47
xMens3  := ""
If !Empty(xCOD_MEN3)
   //
   DbSelectArea("SM4")
   DbSetOrder(1)
   //
   xMens3 := Substr(Formula(xCOD_MEN3), 1, 130)
   //
   @ nLin, 002 PSAY Chr(15) + xMens3 + Chr(18)
   //
Endif             
// Mensagem Padrao 4
nLin := 48
xMens4  := ""
If !Empty(xCOD_MEN4)
   //
   DbSelectArea("SM4")
   DbSetOrder(1)
   //
   xMens4 := Substr(Formula(xCOD_MEN4), 1, 130)
   //
   @ nLin, 002 PSAY Chr(15) + xMens4 + Chr(18)
   //
Endif             

If !Empty(xSUFRAMA)
   nLin := nLin + 1      // "Desconto Concedido : " + Transform(xDESCONT, "@E 99,999,999.99")
   @ nLin, 002 PSAY Chr(15) + " SUFRAMA "+xSUFRAMA + " Valor do Desconto 7% "+Transform(XDESCZFR,"9,999,999.99")+Chr(18)
Endif

/*
If !Empty(xMensage2)
   //
   DbSelectArea("SM4")
   DbSetOrder(1)
   //
   nLin := nLin + 1      // "Desconto Concedido : " + Transform(xDESCONT, "@E 99,999,999.99")
   @ nLin, 002 PSAY Chr(15) + xMensage2 + Chr(18)
   //
Endif
*/
//
nLin := nLin + 1      // "Desconto Concedido : " + Transform(xDESCONT, "@E 99,999,999.99")
@ nLin, 002 PSAY Chr(15) + Substr(xMensage1, 1, 130) + Chr(18)
//
nLin := 52
@ nLin, 001 PSAY xBASE_ICMS  Picture "@E 99,999,999.99"    // Base do ICMS
@ nLin, 016 PSAY xVALOR_ICMS Picture "@E 99,999,999.99"    // Valor do ICMS
@ nLin, 032 PSAY xBSICMRET   Picture "@E 99,999,999.99"    // Base ICMS Ret.
@ nLin, 048 PSAY xICMS_RET   Picture "@E 99,999,999.99"    // Valor ICMS Ret.
@ nLin, 066 PSAY xVALOR_MERC + xDESCZFR  Picture "@E 99,999,999.99"    // Valor Tot. Prod.
//
nLin := nLin + 2
@ nLin, 001 PSAY xFRETE      Picture "@E 99,999,999.99"    // Valor do Frete
@ nLin, 016 PSAY xSEGURO     Picture "@E 99,999,999.99"    // Valor Seguro
@ nLin, 032 PSAY xDESPESA    Picture "@E 99,999,999.99"    // Desp. Acessorias
@ nLin, 048 PSAY xVALOR_IPI  Picture "@E 99,999,999.99"    // Valor do IPI --> IIf(xTIPO == "D" .And. Mv_Par04 == 2, 0, xVALOR_IPI)
@ nLin, 066 PSAY xTOT_FAT    Picture "@E 99,999,999.99"    // Valor Total NF
//
nLin := 57
@ nLin, 002 PSAY Substr(xNOME_TRANSP, 1, 35)     // Nome da Transport.
//
If xTPFRETE # 'C' .Or. Empty(xTPFRETE)          // Frete por Conta do
   @ nLin, 044 PSAY "2"                          // Emitente (1)
Else                                             //     ou
   @ nLin, 044 PSAY "1"                          // Destinatario (2)
Endif
//
@ nLin, 061 PSAY " "                             // xEST_TRANSP // U.F.
//
If !Empty(xCGC_TRANSP)
   @ nLin, 066 PSAY Chr(15) + Transform(xCGC_TRANSP, "@R 99.999.999/9999-99") + Chr(18)
Else
   @ nLin, 066 PSAY " "
Endif
//
nLin := nLin + 2
@ nLin, 002 PSAY Substr(xEND_TRANSP, 1, 33)      // Endereco Transp. // Original 34
@ nLin, 048 PSAY xMUN_TRANSP                     // Municipio
@ nLin, 060 PSAY xEST_TRANSP                     // U.F.
@ nLin, 065 PSAY xINSC_TRANSP                    // Inscricao Estadual
//
nLin := nLin + 2
@ nLin, 005 PSAY xVOLUME     Picture "@E 999999"           // Quant. Volumes
@ nLin, 015 PSAY IIf(Empty(xESPECIE), "VOLUMES", xESPECIE) // Especie
@ nLin, 055 PSAY xPESOBRUTO  Picture "@E 999,999.99"      // Peso Bruto Total
//@ nLin, 067 PSAY xPESOLIQUI  Picture "@E 999,999.99"      // Peso Liquido Total
//Desabilitado em 21/05/2004 por Rodrigo Caetano a pedido da Adriana
//
If Mv_Par04 == 2
   //
   nLin := 67
   @ nLin, 003 PSAY xC5_VEND1          // Vendedor
   @ nLin, 013 PSAY xPEDCLI            // Numero do Pedido
   @ nLin, 027 PSAY xC5_NUM            // Numero do Pedido
   //
Endif
//
nLin := 69
//
If Mv_Par04 == 2                       // Endereco de Entrega para N.Fiscal de Saida
   xMensage2 := Substr(xENDENT, 1, 85) + "  " + Substr(xBAIENT, 1, 15) + " " +; //mudanca de 40 para 85 posicoes
                xMUNENT + " " + xESTENT
   //
   If !Empty(xMensage2)
      @ nLin, 002 PSAY Chr(15) + xMensage2 + Chr(18)
      nLin := nLin + 1
   Endif
   //
Endif
//
nLin := 71
@ nLin, 071 PSAY ""  // xNUM_NF
nLin := nLin + 1
@ nLin, 000 PSAY ""
nLin := nLin + 6
@ nLin, 000 PSAY " " + Chr(18)         // Reset de Impressao
//
SetPrc(0,0)
//
Return (.T.)

//////////////////////////
Static Function ImpOrcam()
//////////////////////////
//
For nX := 1 To nCopias
    //
    // @ 00, 00 PSAY ""                   // Dados do Cliente
    //
    Li := 1
    @ Li, 00 PSAY "================================================================================"
    Li := Li + 1
    //
    @ Li, 00 PSAY "Orcamento : " + xNUM_NF + Space(44) + "Emissao : " + Dtoc(xEMISSAO)
    Li := Li + 1
    //
    @ Li, 00 PSAY "Cliente ..: " + Substr(xNOME_CLI, 1, 40)  + Space(20) + "(" + xCLIENTE + ")"
    Li := Li + 1
    //
    @ Li, 00 PSAY "Endereco .: " + Trim(xEND_CLI) + Space(1) +;
      "CEP : " + Transform(xCEP_CLI, "@R 99999-999")
    Li := Li + 1
    //
    @ Li, 00 PSAY "Municipio : " + xMUN_CLI + "/" + xEST_CLI + Space(5) +;
      "Bairro : " + Substr(xBAIRRO, 1, 20)
    Li := Li + 1
    //
    @ Li, 00 PSAY "Telefone .: " + IIf(!Empty(xDDD_CLI),xDDD_CLI+" "+Substr(xTEL_CLI, 1, 13),Substr(xTEL_CLI, 1, 13)) //Substr(xTEL_CLI, 1, 15)
    Li := Li + 1
    //
    @ Li, 00 PSAY "Local Ent.: " +  Substr(xENDENT, 1, 85) + " " +; //alteracao de 40 para 85 posicoes
      Substr(xBAIENT, 1, 12) + " " + Substr(xMUNENT, 1, 11) + " " + xESTENT
    Li := Li + 1
    //
    @ Li, 00 PSAY "--------------------------------------------------------------------------------"
    Li := Li + 1
    //
    xLinDup01 := Space(24)              // Dados da Fatura
    xLinDup02 := Space(24)
    xLinDup03 := Space(24)
    xLinDup04 := Space(24)
    //
    If Len(xPARC_DUP) > 0
       xLinDup01 := Dtoc(xVENC_DUP[01]) + Space(3) + Transform(xVALOR_DUP[01], "@E 99,999,999.99")
    Endif
    //
    If Len(xPARC_DUP) > 1
       xLinDup02 := Dtoc(xVENC_DUP[02]) + Space(3) + Transform(xVALOR_DUP[02], "@E 99,999,999.99")
    Endif
    //
    If Len(xPARC_DUP) > 2
       xLinDup03 := Dtoc(xVENC_DUP[03]) + Space(3) + Transform(xVALOR_DUP[03], "@E 99,999,999.99")
    Endif
    //
    If Len(xPARC_DUP) > 3
       xLinDup04 := Dtoc(xVENC_DUP[04]) + Space(3) + Transform(xVALOR_DUP[04], "@E 99,999,999.99")
    Endif
    //
    @ Li, 00 PSAY "Vencimentos :   1=  " + xLinDup01 + "   3=  " + xLinDup03
    Li := Li + 1
    @ Li, 00 PSAY "                2=  " + xLinDup02 + "   4=  " + xLinDup04
    Li := Li + 1
    //
    @ Li, 00 PSAY "--------------------------------------------------------------------------------"
    Li := Li + 1
    @ Li, 00 PSAY "Codigo   Descricao                       UN   Qtdade   Preco Unit.   Valor Total"
    //             XXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX 99999999 99.999.999,99 99.999.999,99
    Li := Li + 1
    @ Li, 00 PSAY "--------------------------------------------------------------------------------"
    Li := Li + 1
    //
    nTamDet := 26                      // Tamanho da Area de Detalhe
    xQtdVol := 0                       // Quantidade de Volumes Calculada
    xPesoLi := 0                       // Peso Liquido Calculado
    xPesoBr := 0                       // Peso Bruto Calculado
    I       := 1
    For I := 1 To nTamDet              // Dados dos Produtos
          //
          If I <= Len(xCOD_PRO)
             //
             xORDIMP := I
             //
             DbSelectArea("SB1")
             DbSeek(xFilial("SB1") + xCOD_PRO[xORDIMP])
             //
             @ Li, 00 PSAY Substr(Strtran(xCOD_PRO[xORDIMP], ".", ""), 1, 8)
             @ Li, 09 PSAY Substr(xDESC_PRO[xORDIMP], 1, 30)
             @ Li, 41 PSAY SB1->B1_UM
             @ Li, 43 PSAY xQTD_PRO[xORDIMP]    Picture "@E 99999.999"
             @ Li, 53 PSAY xPRE_UNI[xORDIMP]    Picture "@E 99,999,999.999"
             @ Li, 67 PSAY xVAL_MERC[xORDIMP]   Picture "@E 99,999,999.99"
             //
             xQtdVol := xQtdVol + xQTD_PRO[xORDIMP]
             xPesoLi := xPesoLi + (xQTD_PRO[xORDIMP] * SB1->B1_PESO)
             xPesoBr := xPesoBr + (xQTD_PRO[xORDIMP] * SB1->B1_PESO)
             //
          Endif
          //
          Li := Li + 1
          //
    Next
    //
//    If xVOLUME == 0 // Adriana pediu para imprimir o zero mesmo -Roberto 18/03/02
//       xVOLUME := xQtdVol
//    Endif
    //
    If xPESOLIQUI == 0
       xPESOLIQUI := xPesoLi
    Endif
    //
    If xPESOBRUTO == 0
       xPESOBRUTO := xPesoBr
    Endif
    //
@ Li, 00 PSAY xMensage1    
    //
    Li := Li + 4
    @ Li, 00 PSAY "--------------------------------------------------------------------------------"
    Li := Li + 1
    @ Li, 00 PSAY "Volumes    Especie           Peso Liquido     Peso Bruto             Total      "
    //             999999     XXXXXXXXXXXXXXX    999.999,999     999.999,999       999.999.999,99
    Li := Li + 1
    //
    @ Li, 00 PSAY Transform(xVOLUME, "@E 999999")
    @ Li, 11 PSAY IIf(Empty(xESPECIE), "VOLUMES", xESPECIE)
    @ Li, 30 PSAY Transform(xPESOBRUTO, "@E 999,999.999")
//    @ Li, 46 PSAY Transform(xPESOLIQUI, "@E 999,999.999")
//Desabilitado em 21/05/2004 por Rodrigo Caetano a pedido da Adriana
    @ Li, 64 PSAY Transform(xVALOR_MERC, "@E 999,999,999.99")
    Li := Li + 1
    //
    @ Li, 00 PSAY "--------------------------------------------------------------------------------"
    Li := Li + 1
    @ Li, 00 PSAY "Representante .: " + xC5_VEND1 + Space(28) + "De Acordo"
    Li := Li + 1
    @ Li, 00 PSAY "Pedido Interno : " + xC5_NUM
    Li := Li + 1
    @ Li, 00 PSAY "Pedido Externo : " + xPEDCLI
    Li := Li + 1
    @ Li, 00 PSAY "--------------------------------------------------------------------------------"
    Li := Li + 1
    @ Li, 00 PSAY "Transportadora : " + xNOME_TRANSP
    Li := Li + 1
    @ Li, 00 PSAY "Endereco.......: " + xEND_TRANSP + "   " + xTEL_TRANSP
    Li := Li + 1
    @ Li, 00 PSAY "CIF/FOB........: " + If(xTPFRETE=="C","CIF","FOB")
    Li := Li + 1
    @ Li, 00 PSAY "Valor do Frete : " + Transform(xFRETE,"@E 999,999.99")
    Li := Li + 1
    @ Li, 00 PSAY "--------------------------------------------------------------------------------"
    //
Next
//
Return (.T.)