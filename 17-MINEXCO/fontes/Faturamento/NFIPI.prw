#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 31/05/01

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATR01_AP5ºAutor  ³Microsiga          º Data ³  27/04/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Emissao da Nota Fiscal de Saida ou Entrada                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracoes³ 26/05/03-Jose Novaes - Verificar o conteudo de TES1 e TES2 º±±
±±º          ³                        somente quando for nota de saida na º±±
±±º          ³                        impressao da natureza e CFOP        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NFIPI()        // incluido pelo assistente de conversao do AP5 IDE em 31/05/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_DRIVER,WTOTAL,WTCESTA,XBASE1,XBASE2,XBASE3")
SetPrvt("I,TES1,TES2,_CMSG1,CBTXT,CBCONT")
SetPrvt("NORDEM,ALFA,Z,M,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CNATUREZA,ARETURN")
SetPrvt("NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN,CDESCR1")
SetPrvt("CDESCR2,WNREL,_CDESCCFO,WDESCONTO,CSTRING,NTAMNF")
SetPrvt("WREG,NLININI,XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT")
SetPrvt("XLOJA,XCLIENTE,XFRETE,XSEGURO,XBASE_ICMS,XBASE_IPI")
SetPrvt("XVALOR_ICMS,XICMS_RET,XVALOR_IPI,XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG")
SetPrvt("XPBRUTO,XPLIQUI,XTIPO,XESPECIE,XVOLUME,XVALISS")
SetPrvt("XOUTDESP,_CMSG2,_CDISP,_COS,_CPEDCOM,WPESOBRUT")
SetPrvt("WPESOLIQD,WPEDIDO,WLOJA,WLOJAENT,WCLIENTE,WESPECIE")
SetPrvt("WPLACA,WMARCA,XTPFRETE,WLOCENT,XNQTD,CPEDATU,CITEMATU")
SetPrvt("XPED_VEND,XITEM_PED,XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO")
SetPrvt("XQTD_PRO,XQTD_PROD,XUNID_PRO,XPRE_UNI,XPRE_TAB,XIPI")
SetPrvt("XVAL_IPI,XVAL_ICM,XDESC,XVAL_DESC,XVAL_MERC,XTES")
SetPrvt("XCF,XICMSOL,XICM_PROD,XNATUREZ2,NQUANT,CLINHA1")
SetPrvt("CLINHA2,CLINHA3,XPESO_PRO,XPESO_PROB,XPESO_UNIT,XDESCRICAO")
SetPrvt("XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS,XMEN_POS,XISS")
SetPrvt("XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,XCESPECIE,XCMARCA")
SetPrvt("_CDESCCHECK,_NCFOITEM,XPESO_LIQUID,XPESO_BRUTO,XCOD_CLI,XLOJA_CLI")
SetPrvt("XNOME_CLI,XEND_CLI,XBAIRRO,XCEP_CLI,XCOB_CLI,XREC_CLI")
SetPrvt("XMUN_CLI,XEST_CLI,XCGC_CLI,XINSC_CLI,XTRAN_CLI,XFAX_CLI")
SetPrvt("XSUFRAMA,XCALCSUF,XTEL_CLI,XFAX,XBSICMRET,XNOME_TRANSP")
SetPrvt("XEND_TRANSP,XMUN_TRANSP,XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP")
SetPrvt("XINSCRICAO,XPARC_DUP,XVENC_DUP,XVALOR_DUP,XDUPLICATAS,XNATUREZA")
SetPrvt("XFORNECE,XNFORI,_CMENSNF,XPEDIDO,XPESOPROD,XDESC_PRO")
SetPrvt("NPELEM,_CLASFIS,NPTESTE,XCOD_MENS,XMENSAGEM,XPED_CLI")
SetPrvt("XEND_ENT1,WPULALI,NCONT,WMLIN,PEDCOM,OS")
SetPrvt("NCOL1,NCOL2,VEZ,WBARRA,")
_Driver := "EPSON.DRV"
_cMSG2    := ""
WTOTAL    := 0
WTCESTA   := 0
xbase1    := ""
xbase2    := ""
xbase3    := ""
I         := 1
TES1      := ""
TES2      := ""
_CMSG1    := ""
CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
tamanho   := "M" //"P"
limite    := 132 // 80 //220
titulo    := "Emissao de Nota Fiscal"
cDesc1    := "Este programa emitira Nota Fiscal de Saida ou Entrada"
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "PFATR001"
cPerg     := "FAT001"
nLastKey  := 0
lContinua := .T.
nLin      := 0
cDESCR1   := ""
cDESCR2   := ""
wnrel     := "PFATR001"
_cDescCfo :=''
WDESCONTO := 0
cInsumos  := GetMV("MV_INSUMO")   //CFOS
cInsumos1 := GetMV("MV_INSUMO1")  //TES
cInsumos2 := GetMV("MV_INSUMO2")  //SE O CFOP ESTIVER CONTIDO NESTA VARIAVEL O TOTAL DA NOTA SERA IGUAL O TOTAL DOS PRODUTOS
pergunte(cPerg)
cString := "SF2"

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,tamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTamNf  := 69     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

VerImp()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento da Nota Fiscal                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
   RptStatus({|| RptDetail()},Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 31/05/01 ==>    RptStatus({|| Execute(RptDetail)})
   Return
#ELSE
   RptDetail()   
   Return
#ENDIF

Static Function RptDetail()

If mv_par04 == 1 //Nota Fiscal de Saida
   dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
   WREG:=VAL(MV_PAR02)-VAL(MV_PAR01)
   IF WREG == 0
      WREG:=1
   ENDIF
   SetRegua(WREG)
   dbSetOrder(1)
   dbSeek(xFilial("SF2")+mv_par01+mv_par03,.t.)

   dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
   dbSetOrder(3)
Else
   dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
   WREG:=VAL(MV_PAR02)-VAL(MV_PAR01)
   IF WREG == 0
      WREG:=1
   ENDIF
   SetRegua(WREG)
   DbSetOrder(1)
   dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)

   dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
   dbSetOrder(3)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par04 == 1 //Nota Fiscal de Saida
   dbSelectArea("SF2")
   While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE <= mv_par02+mv_par03 .and. lContinua
      WTOTAL:=0
      WTCESTA:=0
      IncRegua("Imprimindo NF ...")
      dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
      dbSetOrder(3)
      dbSeek(xFilial("SD2")+SF2->(F2_DOC + F2_SERIE))

      nLinIni:=nLin               // Linha Inicial da Impressao

/*/
      If SF2->F2_SERIE #mv_par03           // Se a Serie do Arquivo for Diferente
         DbSkip()                           // do Parametro Informado !!!
         IncProc()
         Loop
      Endif
/*/

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      xNUM_NF     := SF2->F2_DOC             // Numero
      xSERIE      := SF2->F2_SERIE           // Serie
      xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
      xTOT_FAT    := SF2->F2_VALFAT          // Valor Total da Fatura
      If xTOT_FAT == 0
         xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
      Endif

      xLOJA       := SF2->F2_LOJA            // Loja do Cliente
      xCLIENTE    := SF2->F2_CLIENTE         // Codigo do Cliente
      xFRETE      := SF2->F2_FRETE           // Frete
      xSEGURO     := SF2->F2_SEGURO          // Seguro
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
      xTIPO       := SF2->F2_TIPO            // Tipo da N.F.     //do Cliente
      xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
      xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido
      xVALISS     := SF2->F2_VALISS          // VALOR DO ISS
      xOUTDESP    := SF2->F2_DESPESA         // Valor Outras Despesas Acessorios

      dbSelectArea("SC5")
      DBSETORDER(1)
      DBSEEK(XFILIAL("SC5")+SD2->D2_PEDIDO)
      _cMSG1   := SC5->C5_MSG1
      _cMSG2   := SC5->C5_MSG2
      _cDISP   := SC5->C5_DISPOS
      _cOS     := SC5->C5_OSP
      _cPedCom := SC5->C5_PEDCOM
      WPESOBRUT:= SC5->C5_PBRUTO
      WPESOLIQD:= SC5->C5_PESOL
      WPEDIDO  := SC5->C5_NUM
      WLOJA    := SC5->C5_LOJACLI
      WLOJAENT := SC5->C5_LOJAENT
      WCLIENTE := SC5->C5_CLIENTE
      WESPECIE := SC5->C5_ESPECI1
      WMARCA   := "" //SC5->C5_MARCA        -CRIAR CAMPO SIGA
      WPLACA   := SC5->C5_PLACA
      xTPFRETE := SC5->C5_TPFRETE
      WDESCONTO:= SC5->C5_DESCFI
      WLOCENT  := SC5->C5_LOCENT
      xnqtd    := SC5->C5_VOLUME1

      DbSelectArea("SD2")                   // * Itens de Venda da N.F.
      DbSetOrder(3)
      DbSeek(xFilial("SD2")+xNUM_NF+xSERIE)

      cPedAtu   := SD2->D2_PEDIDO
      cItemAtu  := SD2->D2_ITEMPV

      xPED_VEND := {}                         // Numero do Pedido de Venda
      xITEM_PED := {}                         // Numero do Item do Pedido de Venda
      xNUM_NFDV := {}                         // nUMERO QUANDO HOUVER DEVOLUCAO
      xPREF_DV  := {}                         // Serie  quando houver devolucao
      xICMS     := {}                         // Porcentagem do ICMS
      xCOD_PRO  := {}                         // Codigo  do Produto
      xQTD_PRO  := {}                         // Peso/Quantidade do Produto
      xQTD_PROD := 0
      xUNID_PRO := {} 
      xPRE_UNI  := {}                         // Preco Unitario de Venda
      xPRE_TAB  := {}                         // Preco Unitario de Tabela
      xIPI      := {}                         // Porcentagem do IPI
      xVAL_IPI  := {}                         // Valor do IPI
      XVAL_ICM  := {}
      xDESC     := {}                         // Desconto por Item
      xVAL_DESC := {}                         // Valor do Desconto
      xVAL_MERC := {}                         // Valor da Mercadoria     
      xTES      := {}                         // TES
      xCF       := {}                         // Classificacao quanto natureza da Operacao
      xICMSOL   := {}                         // Base do ICMS Solidario
      xICM_PROD := {}                         // ICMS do Produto
//      xnQTD     := 0

      While !Eof() .and. SD2->D2_DOC == xNUM_NF .and. SD2->D2_SERIE == xSERIE
         AADD(xPED_VEND ,SD2->D2_PEDIDO)
         AADD(xITEM_PED ,SD2->D2_ITEMPV)
         AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
         AADD(xPREF_DV  ,SD2->D2_SERIORI)
         AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
         AADD(xCOD_PRO  ,SD2->D2_COD)
         AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
         xQTD_PROD := xQTD_PROD + SD2->D2_QUANT
         AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
         AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
         AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
         AADD( xVAL_IPI ,SD2->D2_VALIPI)
         AADD( XVAL_ICM ,SD2->D2_VALICM)
         AADD(xDESC     ,SD2->D2_DESC)
         AADD(xVAL_MERC ,SD2->D2_TOTAL)
         WTOTAL:=WTOTAL+SD2->D2_TOTAL
         IF SUBSTR(SD2->D2_COD,1,9) == "070010007"
              WTCESTA:=WTCESTA+SD2->D2_TOTAL
         ENDIF
         AADD(xVAL_desc ,SD2->D2_descon)  // desconto no item, em valor
         AADD(xTES      ,SD2->D2_TES)
         AADD(xCF       ,SD2->D2_CF)
         AADD(xUNID_PRO ,SD2->D2_UM)
         AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
//         xnQtd := xnQtd + SD2->D2_QUANT                        
         //Abate quando for insumo
//         IF ALLTRIM(SD2->D2_CF) == "5902" .OR. ALLTRIM(SD2->D2_CF) == "6902"
         IF ALLTRIM(SD2->D2_TES) $ cInsumos1
               XVALOR_MERC:=XVALOR_MERC - SD2->D2_TOTAL
//                  xtot_fat:=xtot_fat - sd2->d2_total
         ENDIF
         IF EMPTY(TES1)
               TES1:=SD2->D2_CF
         ELSE
               DBSELECTAREA("SF4")
               DBSETORDER(1)
               DBSEEK(XFILIAL("SF4")+SD2->D2_TES)
               xnaturez2:=SF4->F4_TEXTO
               TES2:=SD2->D2_CF
         ENDIF

         DBSELECTAREA("SD2")
         dbskip()       
      End
      
      nQuant := 0
      cLinha1 := cLinha2 := cLinha3 := ""
   
      DbSelectArea("SB1")                        // * Desc. Generica do Produto
      DbSetOrder(1)

      xPESO_PRO  := {}                           // Peso Liquido
      xPESO_PROB := {}                           // Peso Bruto
      xPESO_UNIT := {}                           // Peso Unitario do Produto
      xDESCRICAO := {}                           // Descricao do Produto
//      xUNID_PRO  := {}                           // Unidade do Produto
      xCOD_TRIB  := {}                           // Codigo de Tributacao
      xMEN_TRIB  := {}                           // Situacao Tributaria
      xCOD_FIS   := {}                           // Cogigo Fiscal
      xCLAS_FIS  := {}                           // Classificacao Fiscal
      xMEN_POS   := {}                           // Mensagem da Posicao IPI
      xISS       := {}                           // Aliquota de ISS
      xTIPO_PRO  := {}                           // Tipo do Produto
      xLUCRO     := {}                           // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL  := {}
      xPESO_LIQ  := 0
      xcEspecie  := ""      //"Caixa(s)"
      xcMarca    := " "

      For I:=1 to Len(xCOD_PRO)
          DbSeek(xFilial("SB1")+xCOD_PRO[I])
          AADD(xPESO_PRO     , SB1->B1_PESO  * xQTD_PRO[I])
          AADD(xPESO_PROB    , SB1->B1_PESO  * xQTD_PRO[I])
          AADD(xPESO_UNIT    , SB1->B1_PESO               )
//          AADD(xUNID_PRO     , SB1->B1_UM                 )
          SC6->(DbSetOrder(1))
          SC6->(DbSeek(xFilial("SC6")+xPED_VEND[i]+xITEM_PED[i],.F.))
          _cDescCheck:=SC6->C6_DESCRI
          _nCfoItem:=I
         
          AADD(xDESCRICAO    , SC6->C6_DESCRI             )
          AADD(xCOD_TRIB     , SB1->B1_CLASFIS            )
          AADD(xCOD_FIS      , SB1->B1_POSIPI             )
          AADD(xTIPO_PRO     , SB1->B1_TIPO               )
          AADD(xLUCRO        , SB1->B1_PICMRET            )
          AADD(xMEN_TRIB     , SB1->B1_ORIGEM             )
      Next

      xPESO_LIQUID := 0                                 // Peso Liquido da Nota Fiscal
      For I:=1 to Len(xPESO_PRO)
         xPESO_LIQUID := xPESO_LIQUID + xPESO_PRO[I]
      Next

      xPESO_BRUTO := 0                                 // Peso Bruto da Nota Fiscal
      For I:=1 to Len(xPESO_PRO)
         xPESO_BRUTO := xPESO_BRUTO + xPESO_PROB[I]
      Next

      If xTIPO <> "B" .and. xTIPO <> "D"
         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         DbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
         xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         xLOJA_CLI:=SA1->A1_LOJA
         xNOME_CLI:=SA1->A1_NOME            // Nome
         xEND_CLI :=SA1->A1_END             // Endereco
         xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         xCEP_CLI :=SA1->A1_CEP             // CEP
         xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI :=Left(SA1->A1_ENDENT,40) // Endereco de Entrega
         xMUN_CLI :=SA1->A1_MUN             // Municipio
         xEST_CLI :=SA1->A1_EST             // Estado
         xCGC_CLI :=SA1->A1_CGC             // CGC
         xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         xFAX_CLI :=SA1->A1_FAX             // Fax
         xSUFRAMA :=SA1->A1_SUFRAMA         // Codigo Suframa
         xCALCSUF :=SA1->A1_CALCSUF         // Calcula Suframa
         xTEL_CLI :=SA1->A1_TEL             // Telefone
      Else
         dbSelectArea("SA2")                   // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial("SA2")+xCLIENTE+xLOJA)
         xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
         xLOJA_CLI:=SA2->A2_LOJA
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
         xFAX     :=SA2->A2_FAX                // Fax
         xSUFRAMA := ""                        // Codigo Suframa
         xCALCSUF := ""                        // Calcula Suframa
         xTEL_CLI := ""                        // Telefone
      EndIf

      If xICMS_RET > 0                          // Apenas se ICMS Retido > 0
         DbSelectArea("SF3")                    // * Cadastro de Livros Fiscais
         DbSetOrder(4)
         DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
         If Found()
            xBSICMRET:=F3_VALOBSE
         Else
            xBSICMRET:=0
         Endif
      Else
         xBSICMRET:=0
      Endif

      DbSelectArea("SA4")                   // * Transportadoras
      DbSetOrder(1)
      DbSeek(xFilial("SA4")+SF2->F2_TRANSP)
      xNOME_TRANSP := SA4->A4_NOME           // Nome Transportadora
      xEND_TRANSP  := SA4->A4_END            // Endereco
      xMUN_TRANSP  := SA4->A4_MUN            // Municipio
      xEST_TRANSP  := SA4->A4_EST            // Estado
      xVIA_TRANSP  := SA4->A4_VIA            // Via de Transporte
      xCGC_TRANSP  := SA4->A4_CGC            // CGC
      xTEL_TRANSP  := SA4->A4_TEL            // Fone
      xINSCRICAO   := SA4->A4_INSEST         // Inscricao Estadual

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
         AADD(xVALOR_DUP,SE1->(E1_VALOR-(E1_VALOR*(E1_DESCFIN/100))))
         dbSkip()
      EndDo

      DbSelectArea("SF4")                   // * Tipos de Entrada e Saida
      DbSetOrder(1)
      DbSeek(xFilial("SF4")+xTES[1])
      xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
            
      Imprime()

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Termino da Impressao da Nota Fiscal                          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nLin:=15
      DbSelectArea("SF2")
      DbSkip()                // passa para a proxima Nota Fiscal

   EndDo

Else

   DbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
   DbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
   While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua

      If lAbortPrint
         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         lContinua := .F.
         Exit
      Endif

      nLinIni:=nLin                         // Linha Inicial da Impressao
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      xNUM_NF     :=SF1->F1_DOC             // Numero
      xSERIE      :=SF1->F1_SERIE           // Serie
      xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
      xLOJA       :=SF1->F1_LOJA
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
      xOUTDESP    :=SF1->F1_DESPESA         // Valor Outras Despesas Acessorios
      xVALISS     :=""
//      _cMensNF    := SF1->F1_TCMSG

      dbSelectArea("SD1")                   // * Itens da N.F. de Compra
      dbSetOrder(1)
      dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)

      cPedAtu  := SD1->D1_PEDIDO
      cItemAtu := SD1->D1_ITEMPC

      xPEDIDO  :={}                         // Numero do Pedido de Compra
      xITEM_PED:={}                         // Numero do Item do Pedido de Compra
      xNUM_NFDV:={}                         // Numero quando houver devolucao
      xPREF_DV :={}                         // Serie  quando houver devolucao
      xICMS    :={}                         // Porcentagem do ICMS
      xCOD_PRO :={}                         // Codigo  do Produto
      xQTD_PRO :={}                         // Peso/Quantidade do Produto
      xPRE_TAB :={}                         // Preco Unitario de Compra
      xPRE_UNI :={}                          //PRECO UNITARIO
      xIPI     :={}                         // Porcentagem do IPI
      xPESOPROD:={}                         // Peso do Produto
      xVAL_IPI :={}                         // Valor do IPI
      XVAL_ICM :={}
      xDESC    :={}                         // Desconto por Item
      xVAL_DESC:={}                         // Valor do Desconto
      xVAL_MERC:={}                         // Valor da Mercadoria
      xTES     :={}                         // TES
      xCF      :={}                         // Classificacao quanto natureza da Operacao
      xICMSOL  :={}                         // Base do ICMS Solidario
      xICM_PROD:={}                         // ICMS do Produto
      xDESCRICAO:={}                        // Descricao do Produto

      xnQTD    := 0
//      _cOS     := " "
//      _cPedCom := " "

      DBSELECTAREA("SZ1")
      DBSETORDER(1)
      DBSEEK(XFILIAL("SZ1")+SD1->D1_CODFISC)
      _CDISP:=SZ1->Z1_DISPOSI

      DBSELECTAREA("SD1")

      while !eof() .and. SD1->D1_DOC==xNUM_NF .and. SD1->D1_SERIE==xSERIE
         IF EMPTY(_CMSG1)
                 _CMSG1:=SD1->D1_OCORDEV
         ELSE
                 IF EMPTY(_CMSG2)
                      _CMSG2:=SD1->D1_OCORDEV
                 ENDIF
         ENDIF
         AADD(xPEDIDO   ,SD1->D1_PEDIDO)       // Ordem de Compra
         AADD(xITEM_PED ,SD1->D1_ITEMPC)     // Item da O.C.
         AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
         AADD(xPREF_DV  ,SD1->D1_SERIORI)    // Serie Original
         AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         AADD(xCOD_PRO  ,SD1->D1_COD)        // Produto
         AADD(xQTD_PRO  ,SD1->D1_QUANT)      // Guarda as quant. da NF
         AADD(xPRE_TAB  ,SD1->D1_VUNIT)
         AADD(XPRE_UNI  ,SD1->D1_VUNIT)      //PRECO UNITARIO
         AADD(xIPI      ,SD1->D1_IPI)        // % IPI
         AADD(xVAL_IPI  ,SD1->D1_VALIPI)     // Valor do IPI
         AADD(XVAL_ICM  ,SD1->D1_VALICM)  
         AADD(xPESOPROD ,SD1->D1_PESO)       // Peso do Produto
         AADD(xDESC     ,sd1->d1_desc)       // % Desconto
         AADD(xVAL_MERC ,SD1->D1_TOTAL)      // Valor Total
         AADD(xTES      ,SD1->D1_TES)        // Tipo de Entrada/Saida
         AADD(xCF       ,SD1->D1_CF)         // Codigo Fiscal
         AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         AADD(xDESCRICAO,SD1->D1_DESCPRD)

         xnQtd := xnQtd + SD1->D1_QUANT
         dbskip()       
      End

      dbSelectArea("SB1")                     // * Desc. Generica do Produto
      dbSetOrder(1)
      xUNID_PRO:={}                           // Unidade do Produto
      xDESC_PRO:={}                           // Descricao do Produto
      xMEN_POS :={}                           // Mensagem da Posicao IPI
      xCOD_TRIB:={}                           // Codigo de Tributacao
      xMEN_TRIB:={}                           // Situacao Tributaria
      xCOD_FIS :={}                           // Cogigo Fiscal
      xCLAS_FIS:={}                           // Classificacao Fiscal
      xISS     :={}                           // Aliquota de ISS
      xTIPO_PRO:={}                           // Tipo do Produto
      xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL:={}
      xSUFRAMA :=""
      xCALCSUF :=""
      xcEspecie  := " " //"Caixa(s)"
      xcMarca    := " "
      xPeso_Liquid := 0

      cLinha1 := cLinha2 := cLinha3 := ""
      For I:=1 to Len(xCOD_PRO)
         dbSeek(xFilial("SB1")+xCOD_PRO[I])

         xPeso_Liquid := xPeso_Liquid + SB1->B1_PESO * xQtd_Pro[I]
         _cDescCheck  := sb1->b1_desc
         _nCfoItem    := I
//         _fGeraDesc() // Concatena a descricao do produto com o CFO
//                      // se for o caso, atualiza a variavel _cDescCfo, usa
//                      // como parametro _cDescCheck

         AADD(xDESC_PRO,  _cDescCfo)
         AADD(xUNID_PRO,  SB1->B1_UM)
         AADD(xCOD_TRIB,  SB1->B1_CLASFIS)
         AADD(xMEN_TRIB,  SB1->B1_ORIGEM)
//         AADD(xDESCRICAO, _cDescCfo)
         AADD(xMEN_POS,   SB1->B1_POSIPI)
//         xcMarca := Tabela("03",SB1->B1_GRUPO,.F.)
//         If I > 1 .OR. Empty(xcMarca)
//            xcMarca   := "ACIMA"
//         EndIf

         If SB1->B1_ALIQISS > 0
            AADD(xISS,SB1->B1_ALIQISS)
         Else
            AADD(xISS, 0)
         Endif

         AADD(xTIPO_PRO, SB1->B1_TIPO)
         AADD(xLUCRO,    SB1->B1_PICMRET)

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
         AADD(xCOD_FIS,_CLASFIS)
      Next

      If xTIPO == "D" .or. xTIPO == "B" 
         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         dbSeek(xFilial("SA1")+xFORNECE+XLOJA)

         xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         xLOJA_CLI:=SA1->A1_LOJA
         xNOME_CLI:=SA1->A1_NOME            // Nome
         xEND_CLI :=SA1->A1_END             // Endereco
         xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         xCEP_CLI :=SA1->A1_CEP             // CEP
         xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI :=Left(SA1->A1_ENDENT,40) // Endereco de Entrega
         xMUN_CLI :=SA1->A1_MUN             // Municipio
         xEST_CLI :=SA1->A1_EST             // Estado
         xCGC_CLI :=SA1->A1_CGC             // CGC
         xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         xTEL_CLI :=SA1->A1_TEL             // Telefone
         xFAX_CLI :=SA1->A1_FAX             // Fax
      Else
         dbSelectArea("SA2")                   // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial("SA2")+xFORNECE+xLOJA)
         xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
         xLOJA_CLI:=SA2->A2_LOJA
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

      dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
      dbSetOrder(1)
      dbSeek(xFilial("SF4")+xTES[1])
      xNATUREZA    :=SF4->F4_TEXTO          // Natureza da Operacao

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
      xMENSAGEM    :=" "           // Mensagem da Nota
      xINSCRICAO   :=" "           // Inscricao Estadual
      xPED_CLI     :={}
      xEND_ENT1    := " " 

      If xFrete > 0
         xTPFRETE := "F"  //Destinatario
      Else
         xTPFRETE := "C"  //Emitente
      End

      Imprime()

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Termino da Impressao da Nota Fiscal                          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nLin:=0
      dbSelectArea("SF1")     //
      dbSkip()                // e passa para a proxima Nota Fiscal
//      IncProc()
   EndDo

Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                      FIM DA IMPRESSAO                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Eject            

dbSelectArea("SC5")
Retindex("SC5")
dbSelectArea("SC6")
Retindex("SC6")
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

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPDET   ³ Autor ³ Sergio R. Tersarioli  ³ Data ³ 08/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe da Nota Fiscal              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 31/05/01 ==> Function IMPDET
Static Function IMPDET()
   WPULALI:="S"
   For nCont := 1 To Len( xCOD_PRO )
      IF ALLTRIM(XCOD_PRO[nCont]) == "FAT002" .AND. WPULALI=="S"
              nLin:=nLin + 2
      ENDIF

      IF ALLTRIM(XCOD_PRO[nCont]) == "FAT002"
              WMLIN:=129 //alterado de 131 para 129
      ELSE 
              WMLIN:=58
      ENDIF

      IF ALLTRIM(XCOD_PRO[nCont]) $ "FAT006/FAT007/FAT008"    //Verifica se nao e produto de aliq. cesta basica
              iif(EMPTY(xbase1),xbase1:=ALLTRIM(XDESCRICAO[NCONT])+"= R$"+ALLTRIM(STR(XVAL_MERC[ncont]))+" = "+ALLTRIM(STR(XVAL_ICM[ncont])),;             //alimenta campos para imprimir como observacao na nf.
              iif(EMPTY(xbase2),xbase2:=ALLTRIM(XDESCRICAO[NCONT])+"= R$"+ALLTRIM(STR(XVAL_MERC[ncont]))+" = "+ALLTRIM(STR(XVAL_ICM[ncont])),xbase3:=ALLTRIM(XDESCRICAO[NCONT])+"= R$"+ALLTRIM(STR(XVAL_MERC[ncont]))+" = "+ALLTRIM(STR(XVAL_ICM[ncont]))))
      ELSE
              nLin := nLin + 1 //ajuste para pular uma linha; Impressora Epson FX890 - Alterado: Leandro Nobrega 03/01/08
              @ nLin,005 PSAY SUBSTR(xDESCRICAO[nCont],1,WMLIN)
      ENDIF
      
      IF ALLTRIM(XCOD_PRO[nCont]) $ "FAT002/FAT006/FAT007/FAT008"
      *
      ELSE
              @ nLin,064  PSAY xCOD_TRIB[nCont]
              @ nLin,068  PSAY xUNID_PRO[nCont]
              @ nLin,070  PSAY xQTD_PRO[nCont]  PICTURE "@E 999,999.999"
              @ nLin,086  PSAY xPRE_UNI[nCont]  PICTURE "@E 999,999.9999"
              @ nLin,101  PSAY xVAL_MERC[nCont] PICTURE "@E 99,999,999.999"
              @ nlin,119  PSAY XICMS[NCONT] PICTURE "@E 99"
              @ NLIN,123  PSAY XIPI[NCONT] PICTURE "@E 99"
              @ NLIN,123  PSAY XVAL_IPI[NCONT] PICTURE "@E 99,999,999.999"
      ENDIF

      IF ALLTRIM(XCOD_PRO[nCont]) $ "FAT006/FAT007/FAT008"
      *
      ELSE
              nLin := nLin + 1
              If Len(AllTrim(SUBSTR(xDESCRICAO[nCont],WMLIN,WMLIN))) > 0
                 @ nLin,005 PSAY SUBSTR(xDESCRICAO[nCont],WMLIN+1,WMLIN+1)
                 //nLin := nLin + 1
              EndIF
              If Len(AllTrim(SUBSTR(xDESCRICAO[nCont],WMLIN*2,WMLIN))) > 0
                 @ nLin,005 PSAY SUBSTR(xDESCRICAO[nCont],(WMLIN+1)*2,WMLIN+1)
                 //nLin := nLin + 1
              EndIF
              If Len(AllTrim(SUBSTR(xDESCRICAO[nCont],WMLIN*3,WMLIN))) > 0
                 @ nLin,005 PSAY SUBSTR(xDESCRICAO[nCont],(WMLIN+1)*3,WMLIN+1)
                 //nLin := nLin + 1
              EndIF
              IF ALLTRIM(XCOD_PRO[NCONT]) == "FAT002"
                   WPULALI:="N"
              ENDIF
      ENDIF
   Next

   if WDESCONTO <> 0
       nLin:=nLin+1
       @ nLin,005 PSAY "DESCONTO:  R$ "
       @ nLin,020 PSAY SF2->F2_VALBRUT*(WDESCONTO/100) picture '@e 999,999,999.99'
       nLin:=nLin+1
   endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRIME  ³ Autor ³ Sergio R. Tersarioli  ³ Data ³ 10/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a Nota Fiscal de Entrada e de Saida                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 31/05/01 ==> Function Imprime
Static Function Imprime()
//   SetPrc(00,00)         // (Zera o Formulario)
   @ 00,000 PSAY Chr(15) // Compressao de Impressao
   If mv_par04 == 1
      @ 01,087 PSAY "X"  // Saida
   Else
      @ 01,102 PSAY "X"  // Entrada
   EndIf
   @ 01,125 PSAY xNUM_NF // Numero da Nota Fiscal
 
//   If ALLTRIM(TES1)+"/"+ALLTRIM(TES2) $ cInsumos - Novaes 26/05/03
   If mv_par04 == 1 .And. ALLTRIM(TES1)+"/"+ALLTRIM(TES2) $ cInsumos
           @ 06,001 PSAY ALLTRIM(XNATUREZA)+"/"+ALLTRIM(XNATUREZ2)
           @ 06,038 PSAY ALLTRIM(TES1)+"/"+ALLTRIM(TES2)
   Else
           @ 06,001 PSAY xNATUREZA                 //Natureza de Operacao
           @ 06,038 PSAY xCF[1] Picture "@R 9999" //Codigo da Natureza
   EndIf

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao dos Dados do Cliente      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   @ 10,001 PSAY xNOME_CLI                       //Nome do Cliente
   If !EMPTY(xCGC_CLI) .AND. xEST_CLI <> "EX"    // Se o C.G.C. do Cli/Forn nao for Vazio
      @ 10,086 PSAY xCGC_CLI PICTURE If(Len(AllTrim(xCGC_CLI))==14,"@R 99.999.999/9999-99","@R 999.999.999-99")
   Endif
   @ 10,123 PSAY xEMISSAO          // Data da Emissao do Documento
   @ 12,001 PSAY xEND_CLI          // Endereco
   @ 12,080 PSAY Left(xBAIRRO,20)  // Bairro
   @ 12,101 PSAY xCEP_CLI PICTURE "@R 99999-999"  // CEP
   @ 14,001 PSAY xMUN_CLI          // Municipio
   If !Empty(xTEL_CLI)
      @ 14,053 PSAY LEFT(xTEL_CLI,18)          // Telefone/FAX
   EndIf   
   @ 14,077 PSAY IIF(xEST_CLI<>"EX",xEST_CLI,"")  // U.F.
   @ 14,088 PSAY xINSC_CLI     // Insc. Estadual

   //IMPRIME A(S) DUPLICATA(S)
   nLin:=16
   IF MV_PAR04 == 1
           DUPLIC()
   ENDIF

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Dados dos Produtos Vendidos         ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   nLin := 22
   ImpDet()           // Detalhe da NF
   
   nLin := 33
   @ nLin,005 PSAY MemoLine(_cMsg1,94,1)   //94 CARACTERES POR LINHA, ANTES.
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cMsg1,94,2)
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cMsg1,94,3)
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cMsg2,94,1)
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cMsg2,94,2)
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cMsg2,94,3)
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cDisp,94,1)
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cDisp,94,2)
   nLin := nLin + 1
   @ nLin,005 PSAY MemoLine(_cDisp,94,3)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Dados de Impostos                   ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   @ 43, 001  PSAY xBASE_ICMS  PICTURE "@E@Z 999,999,999.99"  // Base do ICMS
   @ 43, 024  PSAY xVALOR_ICMS PICTURE "@E@Z 999,999,999.99"  // Valor do ICMS
   @ 43, 048  PSAY xBSICMRET   PICTURE "@E@Z 999,999,999.99"  // Base ICMS Ret.
   @ 43, 080  PSAY xICMS_RET   PICTURE "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
   IF WTCESTA <> 0
           @ 43, 117 PSAY WTCESTA PICTURE "@E@Z 999,999,999.99"  // Valor Tot. CESTA BASICA
   ELSE
           @ 43, 117  PSAY xVALOR_MERC PICTURE "@E@Z 999,999,999.99"  // Valor Tot. Prod.
   ENDIF
   @ 45, 001  PSAY xFRETE      PICTURE "@E@Z 999,999,999.99"  // Valor do Frete
   @ 45, 024  PSAY xSEGURO     PICTURE "@E@Z 999,999,999.99"  // Valor Seguro
   @ 45, 048  PSAY xOUTDESP    PICTURE "@E@Z 999,999,999.99"  // Valor de Outras Despesas
   
   
   IF xVALOR_IPI == 0 
   
   @ 45, 080  PSAY xVALOR_IPI   PICTURE "@E@Z 999,999,999.99"  // Valor do IPI 
   
   ENDIF
   
   IF WTCESTA <> 0
           @ 46, 117 PSAY  WTCESTA PICTURE "@E@Z 999,999,999.99"  // Valor Total NF DE CESTA BASICA
   ELSEIF XTOT_FAT <> 0                                                 
           @ 46, 117  PSAY iif(ALLTRIM(xCF[1]) $ cINSUMOS2,xVALOR_MERC,xTOT_FAT-(xTOT_FAT*(WDESCONTO/100)))  PICTURE "@E@Z 999,999,999.99"  // Valor Total NF
   ELSE
           @ 46, 118  PSAY WTOTAL-(xTOT_FAT*(WDESCONTO/100))  PICTURE "@E@Z 999,999,999.99"  // Valor Total NF
   ENDIF
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Dados de Transportadoras            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   @ 49, 001 PSAY xNOME_TRANSP     // Nome da Transport.
   If xTPFRETE == 'C'              // Frete por conta do Emitente (1)
      @ 49, 081 PSAY "1"
   Else                            // Frete por conta do Destinatario (2)
      @ 49, 081 PSAY "2"
   Endif
   @ 49, 096 PSAY WPLACA           // Placa do transportador
   @ 49, 105 PSAY xEST_TRANSP      // U.F.
   If !EMPTY(xCGC_TRANSP)          // Se C.G.C. Transportadora nao for Vazio
      @ 49, 115 PSAY xCGC_TRANSP PICTURE "@R 99.999.999/9999-99"
   Else
      @ 49, 115 PSAY " "           // Caso seja vazio
   Endif
   @ 51, 001 PSAY xEND_TRANSP      // Endereco Transp.
   @ 51, 067 PSAY xMUN_TRANSP      // Municipio
   @ 51, 107 PSAY xEST_TRANSP      // U.F.
   @ 51, 115 PSAY xINSCRICAO       // Inscricao Estadual
   @ 52, 001 PSAY xnQtd            // Quantidade produtos da Nota Fiscal

IF MV_PAR04 == 1
   @ 52, 025 PSAY WEspecie         // Especie do Produto
   @ 52, 040 PSAY WMarca           // Marca do Produto
   @ 52, 101 PSAY WPesoBRUT  PICTURE "@E 99999999.99"  // peso liquido
   @ 52, 119 PSAY WPESOLIQD  PICTURE "@E 99999999.99"  // Peso Bruto da Mercadoria
   
   
   if !EMPTY(_CPEDCOM)
       PEDCOM:=" Pedido de Compra: "
   else
       PEDCOM:=""
   endif

   if !EMPTY(_cOS)
       OS:="O.S.: "
   else
       OS:=""
   endif
      
      @ 53, 001 PSAY OS+_cOS+pedcom+_cPedcom
      @ 54, 001 PSAY "Valor de IPI:" +xVALOR_IPI
      @ 54, 026 PSAY "Devolução Parcial"
      @ 55, 001 PSAY  XBASE2
      @ 58, 001 PSAY "EMITIDA POR: "+SUBSTR(CUSUARIO,7,15)
      @ 58, 030 PSAY "HORA:   " + TIME ( )
 
   
   //nlin:=56 
  
    //If xVALOR_IPI <> 0    
      //Entrega()
   // Endif

 
  
 
  

EndIf
      



//  ***********************************************************************
//  * Procura e imprime a Local de entrega                                *
//  * Modificado por: Alex Rodrigues                                      *
//  ***********************************************************************
 /*
   IF WTCESTA == 0 
       IF SF2->F2_TIPO $ "BD" //.AND. WLOJA <> WLOJAENT //.OR. (EMPT(SA1->A1_ENDENT) .AND. EMPT(WLOCENT))
          DBSELECTAREA("SA2")
          DBSETORDER(1)
          DBSEEK(XFILIAL()+WCLIENTE+WLOJAENT)   
          @ 57, 001 PSAY "LOCAL DE ENTREGA:"
          @ 58, 001 PSAY ALLTRIM(SA2->A2_END)+" - "+ALLTRIM(SA2->A2_BAIRRO)
          @ 59, 001 PSAY ALLTRIM(SA2->A2_MUN)+"-"+ALLTRIM(SA2->A2_EST)
       ENDIF
       IF WLOJA <> WLOJAENT //.OR. (EMPT(SA1->A1_ENDENT) .AND. EMPT(WLOCENT))
          DBSELECTAREA("SA1")
          DBSETORDER(1)
          DBSEEK(XFILIAL()+WCLIENTE+WLOJAENT)
                
          @ 57, 001 PSAY "LOCAL DE ENTREGA:"
          @ 58, 001 PSAY ALLTRIM(SA1->A1_END)+" - "+ALLTRIM(SA1->A1_BAIRRO)
          @ 59, 001 PSAY ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
       ELSE
          IF EMPTY(WLOCENT)
             IF !EMPTY(SA1->A1_ENDENT)
                @ 57, 001 PSAY "LOCAL DE ENTREGA:"
                @ 58, 001 PSAY MEMOLINE(SA1->A1_ENDENT,45,1)
                @ 59, 001 PSAY MEMOLINE(SA1->A1_ENDENT,45,2)
             ENDIF
          ELSE
             @ 57, 001 PSAY "LOCAL DE ENTREGA:"
             @ 58, 001 PSAY MEMOLINE(WLOCENT,45,1)
             @ 59, 001 PSAY MEMOLINE(WLOCENT,45,2)
          ENDIF
       ENDIF  
   ELSE
       @ 57, 001 PSAY XBASE1
       @ 58, 001 PSAY XBASE2
       @ 59, 001 PSAY XBASE3
   ENDIF

   @ 61, 015 PSAY WPEDIDO     
   */
 /*  IF WTCESTA == 0 
   
       IF WLOJA <> WLOJAENT //.OR. (EMPT(SA1->A1_ENDENT) .AND. EMPT(WLOCENT))
          DBSELECTAREA("SA1")
          DBSETORDER(1)
          DBSEEK(XFILIAL()+WCLIENTE+WLOJAENT)
                
          @ 57, 001 PSAY "LOCAL DE ENTREGA:"
          @ 58, 001 PSAY ALLTRIM(SA1->A1_END)+" - "+ALLTRIM(SA1->A1_BAIRRO)
          @ 59, 001 PSAY ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
       ELSE
          IF EMPTY(WLOCENT) .AND. WCLIENTE == "003332" .AND. "002810"
             IF !EMPTY(SA1->A1_ENDENT)
                @ 57, 001 PSAY "LOCAL DE ENTREGA:"
                @ 58, 001 PSAY MEMOLINE(SA1->A1_ENDENT,45,1)
                @ 59, 001 PSAY MEMOLINE(SA1->A1_ENDENT,45,2)
             ENDIF
          ELSE
             @ 57, 001 PSAY "LOCAL DE ENTREGA:"
             @ 58, 001 PSAY MEMOLINE(WLOCENT,45,1)
             @ 59, 001 PSAY MEMOLINE(WLOCENT,45,2)
          ENDIF
       ENDIF
       
   	   	DBSELECTAREA("SF2")
   		IF SF2->F2_TIPO $ "BD" //.AND. WLOJA <> WLOJAENT //.OR. (EMPT(SA1->A1_ENDENT) .AND. EMPT(WLOCENT))
          DBSELECTAREA("SA2")
          DBSETORDER(1)
          DBSEEK(XFILIAL()+WCLIENTE+WLOJAENT)   
          @ 57, 001 PSAY "LOCAL DE ENTREGA:"
          @ 58, 001 PSAY ALLTRIM(SA2->A2_END)+" - "+ALLTRIM(SA2->A2_BAIRRO)
          @ 59, 001 PSAY ALLTRIM(SA2->A2_MUN)+"-"+ALLTRIM(SA2->A2_EST)
   	    ENDIF
   	    //DBCLOSEAREA("SF2")
   ELSE
       @ 57, 001 PSAY XBASE1
       @ 58, 001 PSAY XBASE2
       @ 59, 001 PSAY XBASE3
   ENDIF

   @ 61, 015 PSAY WPEDIDO
   
   
ENDIF
      */
                
  
   @ 65, 125 PSAY xNUM_NF

   @ 72, 00 PSAY ""
   _CMSG1    := ""
   _CMSG2    := ""
           2020
Return

Static Function Entrega ()

IF WTCESTA == 0 
   
       IF WLOJA <> WLOJAENT //.OR. (EMPT(SA1->A1_ENDENT) .AND. EMPT(WLOCENT))
          DBSELECTAREA("SA1")
          DBSETORDER(1)
          DBSEEK(XFILIAL()+WCLIENTE+WLOJAENT)
                
          @ 54, 001 PSAY "LOCAL DE ENTREGA:"
          @ 55, 001 PSAY ALLTRIM(SA1->A1_END)+" - "+ALLTRIM(SA1->A1_BAIRRO)
          @ 56, 001 PSAY ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
       ELSE
          IF EMPTY(WLOCENT) .AND. WCLIENTE == "003332" .AND. "002810"
             IF !EMPTY(SA1->A1_ENDENT)
                @ 54, 001 PSAY "LOCAL DE ENTREGA:"
                @ 55, 001 PSAY MEMOLINE(SA1->A1_ENDENT,45,1)
                @ 56, 001 PSAY MEMOLINE(SA1->A1_ENDENT,45,2)
                
             ENDIF
          ELSE
             @ 54, 001 PSAY "LOCAL DE ENTREGA:"
             @ 55, 001 PSAY MEMOLINE(WLOCENT,45,1)
             @ 56, 001 PSAY MEMOLINE(WLOCENT,45,2)
              	 
          ENDIF
       ENDIF
       
   	 
   	 
   	   	DBSELECTAREA("SF2")
   		IF SF2->F2_TIPO $ "BD" //.AND. WLOJA <> WLOJAENT //.OR. (EMPT(SA1->A1_ENDENT) .AND. EMPT(WLOCENT))
          DBSELECTAREA("SA2")
          DBSETORDER(1)
          DBSEEK(XFILIAL()+WCLIENTE+WLOJAENT)   
          @ 54, 001 PSAY "LOCAL DE ENTREGA:"
          @ 55, 001 PSAY ALLTRIM(SA2->A2_END)+" - "+ALLTRIM(SA2->A2_BAIRRO)
          @ 56, 001 PSAY ALLTRIM(SA2->A2_MUN)+"-"+ALLTRIM(SA2->A2_EST)
   	    ENDIF
   	    //DBCLOSEAREA("SF2")
   ELSE
       @ 54, 001 PSAY XBASE1
       @ 55, 001 PSAY XBASE2
       @ 56, 001 PSAY XBASE3
   ENDIF
     
   @ 61, 015 PSAY WPEDIDO
   
   
//ENDIF
     

Return




// Substituido pelo assistente de conversao do AP5 IDE em 31/05/01 ==> FUNCTION DUPLIC

Static FUNCTION DUPLIC()
NCOL1:=05
NCOL2:=29
VEZ:=1
FOR I:=1 TO LEN(XPARC_DUP)
     IF VEZ <= 3
       IF VEZ <> 1
             VEZ:=VEZ+1
             NCOL1:=NCOL1+43
             NCOL2:=NCOL2+43
       ELSE
             VEZ:=VEZ+1
       ENDIF
     ELSE
         VEZ:=2
         NCOL1:=05
         NCOL2:=29
         nLin:=nLin+1
     ENDIF

     IIF(EMPTY(XPARC_DUP[I]),WBARRA:="",WBARRA:="/")
     
     @ nLin, NCOL1 PSAY XNUM_DUPLIC+WBARRA+XPARC_DUP[I]+" - "+DTOC(XVENC_DUP[I])+" - "+"R$" 
     @ nLin, NCOL2 PSAY XVALOR_DUP[I] PICTURE '@E 999,999,999.99'  
NEXT

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

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function VerImp
Static Function VerImp()

nLin   := 0                // Contador de Linhas
nLinIni:= 0
If aReturn[5] > 1

   nOpc       := 1
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

