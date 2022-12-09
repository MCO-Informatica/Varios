#include "rwmake.ch"             // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Nf_Conju()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
                                                                    
SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XDESCONTO,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XCFPR,XCFSV,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
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
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  Nfiscal � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Nota Fiscal de Entrada/Saida                               ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//+--------------------------------------------------------------+
//� Define Variaveis Ambientais                                  �
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Nota Fiscal                       �
//� mv_par02             // Ate a Nota Fiscal                    � 
//� mv_par03             // Da Serie                             � 
//� mv_par04             // Nota Fiscal de Entrada/Saida         � 
//+--------------------------------------------------------------+
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
nomeprog:="nfiscal" 
cPerg:= PADR("NFSIGW",len(SX1->X1_GRUPO))
nLastKey:= 0 
lContinua := .T.
nLin:=0
wnrel    := "siganf"

//+-----------------------------------------------------------+
//� Tamanho do Formulario de Nota Fiscal (em Linhas)          �
//+-----------------------------------------------------------+

nTamNf:=72     // Apenas Informativo 

//+-------------------------------------------------------------------------+
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT                        �
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//� Verifica Posicao do Formulario na Impressora                 �          
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

VerImp()       

//+--------------------------------------------------------------+
//�                                                              �
//� Inicio do Processamento da Nota Fiscal                       �
//�                                                              �
//+--------------------------------------------------------------+
RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})	
Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	Function RptDetail
Static Function RptDetail()

Local J
Local I

totnota:= 0

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
//� Inicializa  regua de impressao                            �
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))
If mv_par04 == 2
   dbSelectArea("SF2") 
   dbSeek(xFilial()+MV_PAR01+MV_PAR03)
   While !eof() .and. SF2->F2_DOC <= mv_par02 .and. lContinua

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


      //+--------------------------------------------------------------+
      //� Inicio de Levantamento dos Dados da Nota Fiscal              �
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
 
//      xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
      
      xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
      xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
      xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
      xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
      xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
      xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
      xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
      xVAL_ISS    :=SF2->F2_VALISS          // Valor ISS 
      xBASE_ISS   :=SF2->F2_BASEISS         // Valor ISS 
      dbSelectArea("SE1")
      dbSetOrder(1)
      xVAL_IRRF   := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"IR-","E1_VALOR") //SF2->F2_VALIRRF         // Valor IRRF
      xVAL_COFI   := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"CF-","E1_VALOR") //SF2->F2_VALCOFI         // Valor COFINS
      xVAL_CSLL   := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"CS-","E1_VALOR") //SF2->F2_VALCSLL         // Valor CSLL
      xVAL_PIS    := POSICIONE("SE1",1,xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC+" "+"PI-","E1_VALOR") //SF2->F2_VALPIS          // Valor PIS 

      dbSelectArea("SD2")                   // * Itens de Venda da N.F.
      dbSetOrder(3)
      dbSeek(xFilial()+xNUM_NF+xSERIE)

      cPedAtu := SD2->D2_PEDIDO
      cItemAtu := SD2->D2_ITEMPV

      xPED_VEND:={}                         // Numero do Pedido de Venda
      xITEM_PED:={}                         // Numero do Item do Pedido de Venda
      xTIPO_PRO:={}                         // Tipo mercadoria ou servi�o
      xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
      xPREF_DV :={}                         // Serie  quando houver devolucao
      xICMS    :={}                         // Porcentagem do ICMS
      xCOD_PRO :={}                         // Codigo  do Produto
      xQTD_PRO :={}                         // Peso/Quantidade do Produto
      xPRE_UNI :={}                         // Preco Unitario de Venda
      xPRE_TAB :={}                         // Preco Unitario de Tabela
      xIPI     :={}                         // Porcentagem do IPI
      xVAL_IPI :={}                         // Valor do IPI
      xDESC    :={}                         // Desconto % por Item
      xDesconto:={}                         // Desconto Valor por Item
      xVAL_DESC:={}                         // Valor do Desconto
      xVAL_MERC:={}                         // Valor da Mercadoria
      xVALO_MERC:={}                         // Valor da Mercadoria      
      xTES     :={}                         // TES
      xCF      :={}                         // Classificacao quanto natureza da Operacao
      xICMSOL  :={}                         // Base do ICMS Solidario
      xICM_PROD:={}                         // ICMS do Produto
      xCFPR    := SPACE(5)
      xCFSV    := SPACE(5)
      while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
	     If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
        	 DbSkip()                   // do Parametro Informado !!!
	         Loop
	     Endif
	 
         AADD(xPED_VEND ,SD2->D2_PEDIDO)
         AADD(xITEM_PED ,SD2->D2_ITEMPV)
         AADD(xTIPO_PRO ,SD2->D2_TP)
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
         AADD(xDESConto ,SD2->D2_DESCON)
         if SD2->D2_TP="MR"
            xCFPR := SD2->D2_CF
         else
            xCFSV := SD2->D2_CF   
         endif                            
         AADD(xVAL_MERC ,SD2->D2_TOTAL)
         AADD(xTES      ,SD2->D2_TES)
         AADD(xCF       ,SD2->D2_CF)
         AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
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
      xCOD_FIS :={}                           // Cogigo Fiscal
      xCLAS_FIS:={}                           // Classificacao Fiscal
      xMEN_POS :={}                           // Mensagem da Posicao IPI
      xISS     :={}                           // Aliquota de ISS
      xTIPO_PRO:={}                           // Tipo do Produto
      xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL   :={}
      xPESO_LIQ := 0
      xTIPO_ITEM:= {}                        // tipo item = Produto ou Servico   
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
          If SB1->B1_ALIQISS > 0
             AADD(xISS ,SB1->B1_ALIQISS)
             AADD(xTIPO_ITEM , 'S' + strzero(I,2))             
          else
             AADD(xTIPO_ITEM , 'P' + strzero(I,2))
          Endif                         
          
          AADD(xTIPO_PRO ,SB1->B1_TIPO)
          AADD(xLUCRO    ,SB1->B1_PICMRET)


         //
         // Calculo do Peso Liquido da Nota Fiscal
         //

         xPESO_LIQUID:=SC5->C5_PESOL /*0                                 // Peso Liquido da Nota Fiscal
         For j:=1 to Len(xPESO_PRO)
            xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
         Next j              
          */
      Next I

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
            xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
            xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
            xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
            xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
            xP_LIQ_PED  :=SC5->C5_PESOL              // Peso Liquido
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

      Next I

      //+---------------------------------------------+
      //� Pesquisa da Condicao de Pagto               �
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
         xCGC_CLI :=AllTrim(SA1->A1_CGC)    // CGC
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
         xCGC_CLI :=AllTrim(SA2->A2_CGC)    // CGC
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
      Next j

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
      xINSEST_TRANSP :=SA4->A4_INSEST       // Inscricao estadual 

      dbSelectArea("SE1")                   // * Contas a Receber
      dbSetOrder(1)
      xPARC_DUP  :={}                       // Parcela
      xVENC_DUP  :={}                       // Vencimento
      xVALOR_DUP :={}                       // Valor
      xDUPLICATAS:=IIF(dbSeek(xFilial()+(xFilial("SF2")+Substr(xSERIE,1,1))+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

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
      xTES1 := ""
      xCFO  := ""

      totnota++
      Imprime(totnota)

      //+--------------------------------------------------------------+
      //� Termino da Impressao da Nota Fiscal                          �
      //+--------------------------------------------------------------+

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
      //+-----------------------------------------------------------+
      //� Inicializa  regua de impressao                            �
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
      //� Inicio de Levantamento dos Dados da Nota Fiscal              �
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
      xVAL_ISS    := 0          // Valor ISS 
      xBASE_ISS   := 0        // Valor ISS 
      

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
      xDESC    :={}                         // Desconto % por Item
      xDESCONTO:={}                         // Desconto Valor por Item      
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
         AADD(xDESCONTO ,SD1->D1_DESC)           // Valor Desconto         
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
      xTIPO_ITEM:= {}

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
            AADD(xTIPO_ITEM , 'S' + strzero(I,2))             
          else
             AADD(xTIPO_ITEM , 'P' + strzero(I,2))
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
         AADD(xCOD_FIS ,_CLASFIS)

      Next I

      //+---------------------------------------------+
      //� Pesquisa da Condicao de Pagto               �
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
         xCGC_CLI :=AllTrim(SA1->A1_CGC)    // CGC
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
         xMUN_CLI :=SA2->A2_MUN                // Municipio
         xEST_CLI :=SA2->A2_EST                // Estado
         xCGC_CLI :=AllTrim(SA2->A2_CGC)       // CGC
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
      xDUPLICATAS:=IIF(dbSeek(xFilial()+(xFilial("SF2")+Substr(xSERIE,1,1))+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

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
      xMENSAGEM    :=" "           // Mensagem da Nota
      xPESO_LIQUID :=" "
      xINSEST_TRANSP :=" "         // Insc. estadual transportadora

      // Imprime()
      totnota++
      Imprime(totnota)      

      //+--------------------------------------------------------------+
      //� Termino da Impressao da Nota Fiscal                          �
      //+--------------------------------------------------------------+

      IncRegua()                    // Termometro de Impressao

      nLin:=0
      dbSelectArea("SF1")           
      dbSkip()                     // e passa para a proxima Nota Fiscal

   EndDo
Endif
//+--------------------------------------------------------------+
//�                                                              �
//�                      FIM DA IMPRESSAO                        �
//�                                                              �
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//� Fechamento do Programa da Nota Fiscal                        �
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
//� Fim do Programa                                              �
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//�                                                              �
//�                   FUNCOES ESPECIFICAS                        �
//�                                                              �
//+--------------------------------------------------------------+

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � VERIMP   � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Verifica posicionamento de papel na Impressora             ���
��+----------+------------------------------------------------------------���
���Uso       � Nfiscal                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//+---------------------+
//� Inicio da Funcao    �
//+---------------------+

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

//+---------------------+
//� Fim da Funcao       �
//+---------------------+

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � IMPDET   � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao de Linhas de Detalhe da Nota Fiscal              ���
��+----------+------------------------------------------------------------���
���Uso       � Nfiscal                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//+---------------------+
//� Inicio da Funcao    �
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function IMPDET
Static Function IMPDET()

Local I:= 1
Local J:= 1
Local y:=.F.
Local w:=.F.

asort(xTIPO_ITEM)

nTamDet :=10            // Tamanho da Area de Detalhe

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario
nItS= 0              
xValor_Merc:=0
For J:=1 to len(xTIPO_ITEM)              

    if xTIPO_PRO[J]=="PR"
       xValor_Merc+=xVAL_MERC[J]
    endif                            

    I:= val(subs(xTIPO_ITEM[J],2,2))
    if subs(xTIPO_ITEM[J],1,1) == "S" .and. nLin < 32
       nLin:= 32 
    endif   

      If I<= Len(xCOD_PRO)
         if subs(xTIPO_ITEM[J],1,1) == "S" 
            @ nLin, 000  PSAY subs(xDESCRICAO[I],1,70)
            @ nLin, 073  PSAY xQTD_PRO[I]               Picture"@ 999"
            @ nLin, 078  PSAY xPRE_UNI[I]               Picture"@E 99,999,999.99"
            @ nLin, 096  PSAY xVAL_MERC[I]              Picture"@E 99,999,999.99"
            if xDesc[I] <> 0 
               nlin=nlin+1
               @ nLin, 002  PSAY "Val.Bruto: "
               @ nLin, 011  PSAY xVAL_MERC[I]+xDesconto[I]           Picture"@E 99,999,999.99"               
               @ nLin, 028  PSAY "Desconto: "
               @ nLin, 038  PSAY xDesconto[I]           Picture"@E 99,999,999.99"
            endif
         else
            @ nLin, 004  PSAY subs(xDESCRICAO[I],1,65)
            @ nLin, 074  PSAY xCOD_FIS[I]
            @ nLin, 078  PSAY xCOD_TRIB[I]
            @ nLin, 085  PSAY xUNID_PRO[I]
            @ nLin, 088  PSAY xQTD_PRO[I]               Picture"@E 999,999"
            @ nLin, 096  PSAY xPRE_UNI[I]               Picture"@E 99,999,999.99"
            @ nLin, 116  PSAY xVAL_MERC[I]              Picture"@E 99,999,999.99"
            @ nLin, 132  PSAY xICM_PROD[I]              Picture"99"  
            if xDesc[I] <> 0
               nlin=nlin+1
               @ nLin, 004  PSAY "Val.Bruto: "
               @ nLin, 013  PSAY xVAL_MERC[I]+xDesconto[I]           Picture"@E 99,999,999.99"               
               @ nLin, 030  PSAY "Desconto: "
               @ nLin, 040  PSAY xDesconto[I]           Picture"@E 99,999,999.99"
            endif
         endif   
      Endif

      if nLin == 34
         @ nLin, 120  PSAY xVAL_ISS               Picture"@E 99,999,999.99"            
         y:= .T.      //Imprimiu o Valor do ISS
      elseif nLin == 37 
         @ nLin, 120  PSAY xBASE_ISS              Picture"@E 99,999,999.99"         
         w:= .T.      //Imprimiu o Valor dos Servi�os
      endif
      nLin := nLin+1
Next        

if nLin <= 34 .and. y=.F.
   @ 34, 120  PSAY xVAL_ISS               Picture"@E 99,999,999.99"            
endif   

if nLin <= 37 .and. w=.F.
   @ 37, 120  PSAY xBASE_ISS              Picture"@E 99,999,999.99"            
endif   

Return

//+---------------------+
//� Fim da Funcao       �
//+---------------------+


/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � CLASFIS  � Autor �   Marcos Simidu       � Data � 16/11/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao de Array com as Classificacoes Fiscais           ���
��+----------+------------------------------------------------------------���
���Uso       � Nfiscal                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//+---------------------+
//� Inicio da Funcao    �
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function CLASFIS
Static Function CLASFIS()

Local nLen := Len(xCLFISCAL)
Local nCont

@ nLin,000 PSAY "Classificacao Fiscal"
nLin := nLin + 1            

If nLen > 12
	nLen := 12
Endif

For nCont := 1 to nLen
   nCol := If(Mod(nCont,2) != 0, 00, 27)
   @ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
   @ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
   nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return


/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � IMPMENP  � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao Mensagem Padrao da Nota Fiscal                   ���
��+----------+------------------------------------------------------------���
���Uso       � Nfiscal                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//+---------------------+
//� Inicio da Funcao    �
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function IMPMENP
Static Function IMPMENP()

nCol:= 05

If !Empty(xCOD_MENS)

   @ nLin, NCol PSAY FORMULA(xCOD_MENS)

Endif

Return

//+---------------------+
//� Fim da Funcao       �
//+---------------------+

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � MENSOBS  � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao Mensagem no Campo Observacao                     ���
��+----------+------------------------------------------------------------���
���Uso       � Nfiscal                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//+---------------------+
//� Inicio da Funcao    �
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function MENSOBS
Static Function MENSOBS()

nTamObs:=150
nCol:=05
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,151,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,301,nTamObs))
Return

//+---------------------+
//� Fim da Funcao       �
//+---------------------+

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � DUPLIC   � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao do Parcelamento das Duplicacatas                 ���
��+----------+------------------------------------------------------------���
���Uso       � Nfiscal                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//+---------------------+
//� Inicio da Funcao    �
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function DUPLIC
Static Function DUPLIC()

Local BB

nCol := 0
nAjuste := 0
For BB:= 1 to Len(xVALOR_DUP)
   If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
    If BB > 2  // N�o Tinha
      nCol:= 0 
      nAjuste := 0
      nLin++
    End  
      @ nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]        
      @ nLin, nCol + 26 + nAjuste PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")      
      @ nLin, nCol + 46 + nAjuste PSAY xVENC_DUP[BB]
      nAjuste := nAjuste + 70
   Endif
Next

Return

//+---------------------+
//� Fim da Funcao       �
//+---------------------+
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � LI       � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Pula 1 linha                                               ���
��+----------+------------------------------------------------------------���
���Uso       � Generico RDMAKE                                            ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//+---------------------+
//� Inicio da Funcao    �
//+---------------------+

//+---------------------+
//� Fim da Funcao       �
//+---------------------+


/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � IMPRIME  � Autor �   Marcos Simidu       � Data � 20/12/95 ���
��+----------+------------------------------------------------------------���
���Descri��o � Imprime a Nota Fiscal de Entrada e de Saida                ���
��+----------+------------------------------------------------------------���
���Uso       � Generico RDMAKE                                            ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function Imprime
Static Function Imprime(totnota)
//+--------------------------------------------------------------+
//�                                                              �
//�              IMPRESSAO DA N.F. DA Nfiscal                    �
//�                                                              �
//+--------------------------------------------------------------+

asort(xTIPO_ITEM)
     
cl:=0
C_CFO:=1
I:= val(subs(xTIPO_ITEM[1],2,2))
xCFO:= xCF[I]
xTES1:= xTES[I]
y:= val(subs(xTIPO_ITEM[1],2,2))

dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
DbSetOrder(1)
dbSeek(xFilial()+xTES1)
xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao

//+-------------------------------------+
//� Impressao do Cabecalho da N.F.      �
//+-------------------------------------+

adriver:= readdriver()

//@ 01, 000 PSAY Chr(18)		// Compressao de Impressao    
          
If totnota == 1
   @ 01, 000 PSAY &(adriver[1])
 Else
   @03 , 00 PSAY " "
   setprc(0,0)
Endif   

//@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
//@ 00, 120 PSAY XNUM_NF 
DbSelectArea("SM0")
DbSetOrder(1)
DbSeek(CNUMEMP)
If Found()
	xCGC_EMP := SM0->M0_CGC
	xINSC_EMP:= SM0->M0_INSC
	xEND_EMP := AllTrim(SM0->M0_ENDENT)+' - '+AllTrim(SM0->M0_BAIRENT)
	xCOMP_EMP:= AllTrim(SM0->M0_CIDENT)+' - '+AllTrim(SM0->M0_ESTENT)+ ' - CEP ' +AllTrim(SM0->M0_CEPENT)
	xTEL_EMP := 'FAX: '+AllTrim(SM0->M0_FAX)

End If

If mv_par04 == 1
   @ 01, 98 PSAY "X"
Else
   @ 01, 82 PSAY "X"
Endif

@ 01, 120 PSAY xNUM_NF               // Numero da Nota Fiscal

//@ 04, 86 PSAY xCGC_EMP Picture"@R 99.999.999/9999-99"		


@ 06, 000 PSAY xNATUREZA             // Texto da Natureza de Operacao
If mv_par04 == 1
    @ 06, 030 PSAY xCFO Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else                                // Altera��o para emitir duas CFOPs na Nota Fiscal de Saida
    
   For I := 1 to Y                 // Somente impress�o de duas CFOPs se houver tempo por remover esse For e testar
    IF I = 1
       IF !EMPTY(xCFPR)
          @ 06, 030+cl PSAY xCFPR Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
          cl=cl+4
          IF !EMPTY(xCFSV)
             @ 06, 030+cl PSAY "/" 
             cl=cl+1       
          ENDIF
       ENDIF
       IF !EMPTY(xCFSV)
          @ 06, 030+cl PSAY xCFSV Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
          cl=cl+4         
       ENDIF
     ENDIF
    Next

EndIf


  //		@ 06, 86 PSAY xINSC_EMP Picture"@R 99.999.999/9999-99"		

//+-------------------------------------+
//� Impressao dos Dados do Cliente      �
//+-------------------------------------+

@ 09, 000 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
//   @ 09, 86 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
	If Len(xCGC_CLI) == 14
		@ 09, 86 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"		
	Else
		@ 09, 86 PSAY xCGC_CLI Picture"@R 999.999.999-99"					
	EndIf	
Else
   @ 09, 86 PSAY " "                // Caso seja vazio
Endif

@ 09, 120 PSAY xEMISSAO              // Data da Emissao do Documento

@ 11, 000 PSAY xEND_CLI                                 // Endereco
@ 11, 078 PSAY xBAIRRO                                  // Bairro
@ 11, 098 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 11, 120 PSAY " "                                      // Reservado  p/Data Saida/Entrada

@ 13, 000 PSAY xMUN_CLI                               // Municipio
@ 13, 060 PSAY xTEL_CLI                               // Telefone/FAX
@ 13, 078 PSAY xEST_CLI                               // U.F.
@ 13, 085 PSAY xINSC_CLI                              // Insc. Estadual
@ 13, 120 PSAY " "                                    // Reservado p/Hora da Saida

If mv_par04 == 2

   //+-------------------------------------+
   //� Impressao da Fatura/Duplicata       �
   //+-------------------------------------+

   nLin:=16
   BB:=1
   nCol := 10             //  duplicatas
   DUPLIC()

Endif

//+-------------------------------------+
//� Dados dos Produtos Vendidos         �
//+-------------------------------------+

cTipoItem:= "" 
nLin := 21
ImpDet()                 // Detalhe da NF

If mv_par04 == 2 .and. Len(xISS) == 0

  //nLin:=34
  //MensObs()             // Imprime Mensagem de Observacao

  //nLin:=37
  //ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal

Endif


//+-------------------------------------+
//� Prestacao de Servicos Prestados     �
//+-------------------------------------+

If Len(xISS) > 0

   //nLin := 40
   //Impmenp()

   //nLin :=41
   //MensObs()

  //@ 44, 142  PSAY xTOT_FAT  Picture"@E@Z 999,999,999.99"   // Valor do Servico
Endif
//+-------------------------------------+
//� Calculo dos Impostos                �
//+-------------------------------------+

@ 40, 005  PSAY xBASE_ICMS  Picture"@E 999,999,999.99"  // Base do ICMS
@ 40, 032  PSAY xVALOR_ICMS Picture"@E 999,999,999.99"  // Valor do ICMS
@ 40, 060  PSAY xBSICMRET   Picture"@E 999,999,999.99"  // Base ICMS Ret.
@ 40, 085  PSAY xICMS_RET   Picture"@E 999,999,999.99"  // Valor  ICMS Ret.
@ 40, 114  PSAY xVALOR_MERC Picture"@E 999,999,999.99"  // Valor Tot. Prod.

@ 42, 005  PSAY xFRETE      Picture"@E 999,999,999.99"  // Valor do Frete
@ 42, 032  PSAY xSEGURO     Picture"@E 999,999,999.99"  // Valor Seguro
@ 42, 085  PSAY xVALOR_IPI  Picture"@E 999,999,999.99"  // Valor do IPI
@ 42, 114  PSAY xTOT_FAT    Picture"@E 999,999,999.99"  // Valor Total NF

//+------------------------------------+
//� Impressao Dados da Transportadora  �
//+------------------------------------+

@ 45, 006  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
   @ 45, 076 PSAY "1"                              // Emitente (1)
Else                                               //     ou
   @ 45, 076 PSAY "2"                              // Destinatario (2)
Endif

@ 45, 092 PSAY " "                                  // Res. p/Placa do Veiculo
@ 45, 112 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
   @ 45, 117 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
   @ 45, 123 PSAY " "                               // Caso seja vazio
Endif

@ 47, 006 PSAY xEND_TRANSP                          // Endereco Transp.
@ 47, 074 PSAY xMUN_TRANSP                          // Municipio
@ 47, 099 PSAY xEST_TRANSP                          // U.F.
@ 47, 117 PSAY xINSEST_TRANSP                       // Reservado p/Insc. Estad.

@ 49, 005 PSAY xVOLUME  Picture"@E 999,999.99"             // Quant. Volumes
@ 49, 026 PSAY xESPECIE Picture"@!"                          // Especie
@ 49, 052 PSAY " "                                           // Res para Marca
@ 49, 075 PSAY " "                                           // Res para Numero
@ 49, 102 PSAY xPESO_BRUTO     Picture"@E 999,999.99"      // Res para Peso Bruto
@ 49, 120 PSAY SC5->C5_PESOL    Picture"@E 999,999.99"      // Res para Peso Liquido

If mv_par04 == 2
   nLin := 52
   //Clasfis()               // Impressao de Classif. Fiscal
Endif
If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
   //@ 64, 006 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
Endif
If !Empty(xSuframa)
   //@ 64,60 PSAY "SUFRAMA : "+xSuframa
EndIf

@ 53, 000  PSAY subs(xMENSAGEM,1,65)
@ 54, 000  PSAY subs(xMENSAGEM,66,65)

if xBASE_ISS > 0
   @ 55, 000  PSAY "IRRF R$ " + trans(xVAL_IRRF,"@e 999,999,999.99")
   @ 56, 000  PSAY "COFINS PIS CSLL R$ " + trans(xVAL_COFI + xVAL_CSLL + xVAL_PIS,"@e 999,999,999.99")
endif   

@ 61, 120 PSAY xNUM_NF                   // Numero da Nota Fiscal

//@ 63, 00 PSAY chr(18)                   // Descompressao de Impressao

@ 63, 00 PSAY " "

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.