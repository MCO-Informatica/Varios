#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function kfat01r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,NIMPRIME,WNREL,_APERGUNTAS,_NLACO,NTAMNF")
SetPrvt("CSTRING,CPEDANT,NLININI,XNUM_NF,XSERIE,XEMISSAO")
SetPrvt("XTOT_FAT,XLOJA,XFRETE,XSEGURO,XBASE_ICMS,XBASE_IPI")
SetPrvt("XVALOR_ICMS,XICMS_RET,XVALOR_IPI,XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG")
SetPrvt("XPBRUTO,XPLIQUI,XTIPO,XESPECIE,XVOLUME,CPEDATU")
SetPrvt("CITEMATU,XPED_VEND,XITEM_PED,XNUM_NFDV,XPREF_DV,XICMS")
SetPrvt("XCOD_PRO,XDESC_PRO,XCOD_PECA,XQTD_ENT,XQTD_SAI,XLOC_PRO")
SetPrvt("XQTD_PRO,XPRE_UNI,XPRE_TAB,XIPI,XVAL_IPI,XDESC")
SetPrvt("XVAL_DESC,XVAL_MERC,XTES,XCF,XICMSOL,XICM_PROD")
SetPrvt("XLOT_PRO,XPESO_PRO,XPESO_UNIT,XDESCRICAO,XUNID_PRO,XCOD_TRIB")
SetPrvt("XMEN_TRIB,XCOD_FIS,XCLAS_FIS,XMEN_POS,XISS,XTIPO_PRO")
SetPrvt("XLUCRO,XCLFISCAL,XPESO_LIQ,I,_CLASFIS,XPESO_LIQUID")
SetPrvt("XPED,XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS")
SetPrvt("XMENSAGEM,XTPFRETE,XCONDPAG,XDESCONT,XCOD_VEND,XDESC_NF")
SetPrvt("XDESC_PAG,XPED_CLI,J,XCOD_CLI,XNOME_CLI,XEND_CLI")
SetPrvt("XBAIRRO,XCEP_CLI,XCOB_CLI,XREC_CLI,XREC_MUN,XREC_EST")
SetPrvt("XREC_CEP,XREC_BAIR,XMUN_CLI,XEST_CLI,XCGC_CLI,XINSC_CLI")
SetPrvt("XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF,ZFRANCA")
SetPrvt("XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP,XEST_TRANSP")
SetPrvt("XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP,XVALOR_DUP")
SetPrvt("XDUPLICATAS,XNATUREZA,NTAMDET,XB_ICMS_SOL,XV_ICMS_SOL,_NTOTPROD")
SetPrvt("_CPRODAUX,_NTOTITEM,_NTOTENTR,_NTOTDIFE,_NPROPECA,AMOD")
SetPrvt("L,_CPECAAUX,NCONT,NCOL,XCODFOR,NTAMOBS")
SetPrvt("NAJUSTE,BB,K,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT01R  ³ Autor ³Luciano Lorenzetti     ³ Data ³29/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao dos Romaneios para Carregamento                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Correa³07/11/00³Impressao do vendedor, transportador e preco   ³±±
±±³Ricardo Correa³19/06/01³Impressao da data e valor total                ³±±
±±³Jefferson     ³31/03/03³Criacao de Parametro (Venda / Terceiros)       ³±±
±±³Jefferson     ³31/03/03³Criacao de Lay Out para Romaneio de Terceiros  ³±±
±±³Jefferson     ³03/05/03³Ajustes de Lay Out para Romaneio de Terceiros  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G"
limite:=220
titulo :=PADC("Romaneio para carregamento",74)
cDesc1 :=PADL("Este programa ira emitir o Romaneio por lote, para separa‡Æo e ",74)
cDesc2 :=PADL("conferencia de material.",74)
cDesc3 :=""
cNatureza:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="KFAT01R"
cPerg:="ROMANE    "
nLastKey:= 0
lContinua := .T.
nLin:=0
nImprime := 0
wnrel    := "KFAT01R"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01                     // Do Romaneio                  ³
//³ mv_par02                     // Ate Romaneio                 ³
//³ mv_par03                     // Da Serie                     ³
//³ mv_par04                     // Lay Out (Venda/Terceiros)    ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ O trecho de programa abaixo verifica se o arquivo SX1 esta   ³
//³ atualizado. Caso nao, deve ser inserido o grupo de perguntas ³
//³ que sera utilizado.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerguntas:= {}
//                   1       2          3                 4       5  6  7 8  9   10     11      12         13 14    15        16 17 18 19 20 21 22 23 24 25   26

AADD(_aPerguntas,{"ROMANE    ","01","Do Romaneio        ? " ,"mv_ch1","C",9,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","  ",})
AADD(_aPerguntas,{"ROMANE    ","02","Ate Romaneio       ? " ,"mv_ch2","C",9,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","  ",})
AADD(_aPerguntas,{"ROMANE    ","03","Da Serie             " ,"mv_ch3","C",3,0,0,"G"," ","mv_par03","         ","","","         ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"ROMANE    ","04","Lay Out              " ,"mv_ch4","N",1,0,0,"G"," ","mv_par04","         ","","","         ","","","","","","","","","","","   ",})

dbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
	If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
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
NEXT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario (em linhas)                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas.                                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
	Return()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento do romaneio                                                  ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	RptStatus({|| Execute(RptDetail)})
	Return()
	// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> 	Function RptDetail
	Static Function RptDetail()
#ENDIF

dbSelectArea("SF2")                // * Cabecalho do romaneio
dbSetOrder(1)
dbSeek(xFilial()+mv_par01+mv_par03,.t.)

dbSelectArea("SD2")                // * Itens do Romaneio
dbSetOrder(3)
dbSeek(xFilial()+mv_par01+mv_par03)
cPedant := SD2->D2_PEDIDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Val(mv_par02)-Val(mv_par01))
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
	//³ Inicio de Levantamento dos Dados do Romaneio                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// * Cabecalho do Romaneio
	
	xNUM_NF     :=SF2->F2_DOC             // Numero
	xSERIE      :=SF2->F2_SERIE           // Serie
	xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
	xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
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
	xUNID_PRO:={}                           // Unidade do Produto
	xDESC_PRO:={}                         // Codigo  do Produto
	xCOD_PECA:={}                         // Codigo  do Produto
	xQTD_ENT:={}                         // Codigo  do Produto
	xQTD_SAI:={}                         // Codigo  do Produto
	xLOC_PRO :={}                         // Local   do Produto
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
	xLOT_PRO :={}                                                 // Codigo  do Produto
	
	while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
		If SD2->D2_SERIE #mv_par03                    // Se a Serie do Arquivo for Diferente
			DbSkip()                                                       // do Parametro Informado !!!
			Loop
		Endif
		
		
		If mv_par04 == 2 .And. Subs(Alltrim(SD2->D2_COD),4,3)$"000"
			dbSkip()
			Loop
		EndIf
		
		
		AADD(xPED_VEND ,SD2->D2_PEDIDO)
		AADD(xITEM_PED ,SD2->D2_ITEMPV)
		AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
		AADD(xPREF_DV  ,SD2->D2_SERIORI)
		AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
		AADD(xCOD_PRO  ,SD2->D2_COD)
		AADD(xUNID_PRO ,SB1->B1_UM)
		AADD(xLOC_PRO  ,SD2->D2_LOCAL)
		AADD(xLOT_PRO  ,SD2->D2_LOTECTL)
		AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
		//     AADD(xQTD_SAI ,SD2->D2_QTSEGUM )   // Guarda as quant. da NF 2aUN
		AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
		AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
		AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
		AADD(xVAL_IPI  ,SD2->D2_VALIPI)
		AADD(xDESC     ,SD2->D2_DESC)
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
	xPESO_LIQUID:=0
	I:=1
	
	For I:=1 to Len(xCOD_PRO)
		
		dbSeek(xFilial()+xCOD_PRO[I])
		AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
		//xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
		AADD(xPESO_UNIT , SB1->B1_PESO)
		AADD(xDESCRICAO ,SB1->B1_DESC)
		AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
		
		If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
			AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
		Endif
		
		_CLASFIS := SB1->B1_POSIPI
		
		AADD(xCOD_FIS ,_CLASFIS)
		If SB1->B1_ALIQISS > 0
			AADD(xISS ,SB1->B1_ALIQISS)
		Endif
		AADD(xTIPO_PRO ,SB1->B1_TIPO)
		AADD(xLUCRO    ,SB1->B1_PICMRET)
		
		//
		// Calculo do Peso Liquido do Romaneio
		//
		
		xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[I]

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
			xMENSAGEM       :=SC5->C5_MENNOTA                        // Mensagem para o Romaneio
			xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
			xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
			xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
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
	xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao
	
	nImprime := nImprime + 1
	
	Imprime()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino da Impressao do Romaneio.                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncRegua()                    // Termometro de Impressao
	
	nLin:=0
	dbSelectArea("SF2")
	dbSkip()                                              // passa para o proximo Romaneio
	
EndDo



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                      FIM DA IMPRESSAO                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa do Romaneio                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")

EJECT

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
±±³Fun‡…o    ³ IMPVENDA ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe do Romaneio de Vendas       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function IMPVENDA
Static Function IMPVENDA()

nTamDet := 999            // Tamanho da Area de Detalhe
I:=1
J:=1
xB_ICMS_SOL:=0                  // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

_nTotProd := 0
_cProdAux := xCOD_PRO[1]

For I:=1 to nTamDet
	
	If I<= Len(xCOD_PRO)
		If xCOD_PRO[I] #_cProdAux
			@ nLin, 001 PSAY "Total "+Alltrim(_cProdAux)
			@ nLin, 016 PSAY _nTotProd  Picture "@E 9,999,999.99"
			nLin := nLin + 1
			_nTotProd := 0
		EndIf
		
		@ nLin, 001 PSAY Alltrim(xCOD_PRO[I])
		@ nLin, 016 PSAY xQTD_PRO[I]      Picture"@E 9,999,999.99"
		@ nLin, 031 PSAY xUNID_PRO[I]
		@ nLin, 035 PSAY xPed_Vend[I]+"/"+xItem_Ped[I]
		@ nLin, 042 PSAY xPRE_UNI[I]         Picture"@E 99,999,999.99"
		_nTotProd := _nTotProd + xQTD_PRO[I]
		_nTotItem := xQTD_PRO[I] * xPRE_UNI[I]
		@ nLin, 054 PSAY _nTotItem           Picture"@E 99,999,999.99"
		If Empty(xLot_Pro[I])
			@ nLin, 068 PSAY "NAO POSSUI"
		Else
			@ nLin, 068 PSAY xLOT_PRO[I]
		EndIf
		
		J:=J+1
		nLin := nLin+1
		_cProdAux := xCOD_PRO[I]
	Endif

	If nLin > 59
		nLin := 0
		CabecRoman()
		nLin := nLin + 1
	Endif

Next

@ nLin, 001 PSAY "Total "+Alltrim(_cProdAux)
@ nLin, 016 PSAY _nTotProd  Picture "@E 9,999,999.99"
nLin := nLin + 1

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPTERCEI³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe do Romaneio de Terceiros    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function IMPTERCEIROS
Static Function IMPTERCEIROS()

nTamDet := 999           // Tamanho da Area de Detalhe
I:=1
J:=1
xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

_nTotProd := 0
_nTotEntr := 0
_nTotDife := 0
_nProPeca := 0
_cProdAux := xCOD_PRO[1]
aMOD      := {}

For L := 1 to Len(xCOD_PRO)
	
	dbSelectArea("SD3")
	dbSetOrder(19)
	If !dbSeek(xFilial("SD3")+xCOD_PRO[L]+xLOC_PRO[L]+xLOT_PRO[L],.F.)
		AADD(xQTD_SAI,0)
		AADD(xCOD_PECA,"****")
	Else
		AADD(xQTD_SAI,SD3->D3_QUANT)
		AADD(xCOD_PECA,SD3->D3_X_PECAS)
	EndIf
	
	//----> PECA 1
	dbSelectArea("SC2")
	dbSetOrder(27)
	If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
		AADD(xQTD_ENT,SC2->C2_QUANT_1)
	Else
		//----> PECA 2
		dbSelectArea("SC2")
		dbSetOrder(12)
		If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
			AADD(xQTD_ENT,SC2->C2_QUANT_2)
		Else
			//----> PECA 3
			dbSelectArea("SC2")
			dbSetOrder(13)
			If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
				AADD(xQTD_ENT,SC2->C2_QUANT_3)
			Else
				//----> PECA 4
				dbSelectArea("SC2")
				dbSetOrder(14)
				If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
					AADD(xQTD_ENT,SC2->C2_QUANT_4)
				Else
					//----> PECA 5
					dbSelectArea("SC2")
					dbSetOrder(15)
					If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
						AADD(xQTD_ENT,SC2->C2_QUANT_5)
					Else
						//----> PECA 6
						dbSelectArea("SC2")
						dbSetOrder(16)
						If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
							AADD(xQTD_ENT,SC2->C2_QUANT_6)
						Else
							//----> PECA 7
							dbSelectArea("SC2")
							dbSetOrder(17)
							If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
								AADD(xQTD_ENT,SC2->C2_QUANT_7)
							Else
								//----> PECA 8
								dbSelectArea("SC2")
								dbSetOrder(18)
								If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
									AADD(xQTD_ENT,SC2->C2_QUANT_8)
								Else
									//----> PECA 9
									dbSelectArea("SC2")
									dbSetOrder(19)
									If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
										AADD(xQTD_ENT,SC2->C2_QUANT_9)
									Else
										//----> PECA 10
										dbSelectArea("SC2")
										dbSetOrder(20)
										If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
											AADD(xQTD_ENT,SC2->C2_QUANT_A)
										Else
											//----> PECA 11
											dbSelectArea("SC2")
											dbSetOrder(21)
											If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
												AADD(xQTD_ENT,SC2->C2_QUANT_B)
											Else
												//----> PECA 12
												dbSelectArea("SC2")
												dbSetOrder(22)
												If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
													AADD(xQTD_ENT,SC2->C2_QUANT_C)
												Else
													//----> PECA 13
													dbSelectArea("SC2")
													dbSetOrder(23)
													If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
														AADD(xQTD_ENT,SC2->C2_QUANT_D)
													Else
														//----> PECA 14
														dbSelectArea("SC2")
														dbSetOrder(24)
														If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
															AADD(xQTD_ENT,SC2->C2_QUANT_E)
														Else
															//----> PECA 15
															dbSelectArea("SC2")
															dbSetOrder(25)
															If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
																AADD(xQTD_ENT,SC2->C2_QUANT_F)
															Else
																//----> PECA 16
																dbSelectArea("SC2")
																dbSetOrder(26)
																If dbSeek(xFilial("SC2")+SD3->D3_X_PECAS+Subs(SD3->D3_OP,1,6),.F.)
																	AADD(xQTD_ENT,SC2->C2_QUANT_G)
																Else
																	AADD(xQTD_ENT,0)
																EndIf
															EndIf
														EndIf
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Next

_cPecaAux   :=  xCOD_PECA[1]
For I:=1 to nTamDet
	
	If I<= Len(xCOD_PRO)
		
		If xCOD_PRO[I] #_cProdAux
			@ nLin, 001 PSAY "Total "+Iif(Alltrim(_cProdAux)$"2207/2221","Mao de Obra   ",_cProdAux)
			If Alltrim(_cProdAux) $ "2207/2221"
				@ nLin, PCOL()+22 PSAY _nTotProd  Picture "@E 99,999.99"
				@ nLin, Pcol()+16 PSAY xTOT_FAT Picture "@E 999,999.99"
				nLin := nLin + 2
				@ nLin, 001 PSAY Repl("-",78)
				nLin := nLin + 1
				@ nLin, 001 PSAY "PRODUTO                     PECA      MTS ENT   MTS SAI   MTS DIF  LOTE/ETIQ"
				nLin := nLin + 1
				@ nLin, 001 PSAY Repl("-",78)
				//_cPecaAux := xCOD_PECA[I]
			Else
				@ nLin, PCOL()+15 PSAY _nTotEntr  Picture "@E 99,999.99"
				@ nLin, Pcol()+01 PSAY _nTotProd  Picture "@E 99,999.99"
				@ nLin, Pcol()+01 PSAY _nTotDife  Picture "@E 99,999.99"
			EndIf
			nLin := nLin + 2
			_nTotProd := 0
			_nTotEntr := 0
			_nTotDife := 0
			
		EndIf
		
		If Alltrim(xCOD_PRO[I]) $ "2207/2221"
			@ nLin, 001       PSAY xDESC_PRO[I]
			@ nLin, Pcol()+12 PSAY xQTD_PRO[I]      Picture"@E 99,999.99"
			@ nLin, Pcol()+00 PSAY xPRE_UNI[I]      Picture"@E 99,999.99"
			@ nLin, Pcol()+08 PSAY xVAL_MERC[I]     Picture"@E 99,999.99"
			AADD(AMOD,"")
			
			//If xTOT_FAT == 0
			//	xTOT_FAT	+=	xVAL_MERC[I]
			//EndIf 
		Else
			If xCOD_PECA[I] == _cPecaAux
				_nProPeca := _nProPeca  +  xQTD_PRO[I]
			Else
				_nProPeca :=  xQTD_PRO[I]
			EndIf
			
			@ nLin, 001       PSAY xCOD_PRO[I]
			@ nLin, Pcol()+13 PSAY xCOD_PECA[I]
			@ nLin, Pcol()+01 PSAY xQTD_ENT[I]                           Picture"@E 99,999.99"
			@ nLin, Pcol()+01 PSAY xQTD_PRO[I]                           Picture"@E 99,999.99"
			@ nLin, Pcol()+01 PSAY (xQTD_ENT[I] - _nProPeca)             Picture"@E 99,999.99"
			
			If Empty(xLot_Pro[I])
				@ nLin, 068 PSAY "NAO POSSUI"
			Else
				@ nLin, 068 PSAY xLOT_PRO[I]
			EndIf
			
		EndIf
		
		If nLin > 59
			nLin := 0
			CabecRoman()
			nLin := nLin + 1
			@ nLin, 001 PSAY Repl("-",78)
			nLin := nLin + 1
			@ nLin, 001 PSAY "PRODUTO                     PECA      MTS ENT   MTS SAI   MTS DIF   LOTE/ETIQ"
			nLin := nLin + 1
			@ nLin, 001 PSAY Repl("-",78)
		Endif
		
		J:=J+1
		nLin := nLin+1
		_nTotProd := _nTotProd + xQTD_PRO[I]
		
		If xCOD_PECA[I] == _cPecaAux
			_nTotEntr := _nTotEntr
		Else
			_nTotEntr := _nTotEntr + xQTD_ENT[I]
		EndIf
		
		_nTotDife := _nTotEntr - _nTotProd
		
		_cProdAux := xCOD_PRO[I]
		_cPecaAux := xCOD_PECA[I]
	Endif
Next

@ nLin, 001 PSAY "Total "+_cProdAux
@ nLin, PCOL()+15 PSAY _nTotEntr  Picture "@E 99,999.99"
@ nLin, Pcol()+01 PSAY _nTotProd  Picture "@E 99,999.99"
@ nLin, Pcol()+01 PSAY _nTotDife  Picture "@E 99,999.99"

nLin := nLin + 1

Return()



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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CLASFIS
Static Function CLASFIS()

@ nLin,006 PSAY "Classificacao Fiscal"
nLin := nLin + 1
For nCont := 1 to Len(xCLFISCAL) .And. nCont <= 12
	nCol := If(Mod(nCont,2) != 0, 06, 33)
	@ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
	@ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
	nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPMENP  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Mensagem Padrao do Romaneio                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function IMPMENP
Static Function IMPMENP()

nCol:= 05

If !Empty(xCOD_MENS)
	
	@ nLin, NCol PSAY Substr( FORMULA(xCOD_MENS), 1, 70 )
	nLin := nLin + 1
	@ nLin, NCol PSAY Substr( FORMULA(xCOD_MENS),71, 140)
	nLin := nLin + 1
	@ nLin, NCol PSAY Substr( FORMULA(xCOD_MENS),141, 210)
	
Endif

Return()

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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function MENSOBS
Static Function MENSOBS()

If Substr( Upper( xMENSAGEM ), 1 ,7 ) == "FORMULA"            // se for uma formula
	xCODFOR    := SUbstr( xMENSAGEM, 9,3 )                     // imprime o resultado
	xMENSAGEM  := Formula(xCODFOR)                             // da formula
EndIf

nTamObs:=150
nCol:=05
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,151,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,301,nTamObs))
Return()

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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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

Return()

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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                      IMPRESSAO DO ROMANEIO                   ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CabecRoman()

//----> IMPRIME ROMANEIO COM LAY OUT DE VENDA
If MV_PAR04 == 1
	@ nLin, 001 PSAY"Cod Prod         Quantidade   UM  Pedido/It  Prc Unit   Vlr Total  Lote/Etiq "
	//               XXXXXXXX        XXXXXXXXXXXXXXX  9.999.999.99  XX      XXXXXX/XX                                               XXXXXXXXXX
	//                              012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                              0                 1             2                 3             4                 5             6                 7             8
	//----> IMPRIME ROMANEIO COM LAY OUT DE TERCEIROS
Else
	@ nLin, 001 PSAY "MAO-DE-OBRA                                    QTDE  VL UNIT          VLR TOT                "
	//                XXXXXXXX         XXXX                    999,999.99999.99999,999.99999,999.99      XXXXXXXXXX"
	//                              012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                              0         1         2         3         4         5         6         7         8
EndIf
nLin := nLin + 1
@ nLin, 001 PSAY Replicate("-",78)
nLin := nLin + 1

//----> IMPRIME ROMANEIO COM LAY OUT DE VENDA
If MV_PAR04 == 1
	ImpVenda()
	//----> IMPRIME ROMANEIO COM LAY OUT DE TERCEIROS
Else
	ImpTerceiros()
EndIf

@ nLin, 001 PSAY REPLICATE("-",78)
nLin := nLin + 1

@ nLin, 001      PSAY "Total de Itens : "
@ nLin, Pcol()+1 PSAY Iif(MV_PAR04 == 1,Transform((J-1),"@E 999,999.99"),Transform((J-Len(aMOD)-1),"@E 999,999.99"))

If mv_par04 == 1
	@ nLin, 045 PSAY "Valor Total : "
	@ nLin, 053 PSAY xTOT_FAT Picture "@E 999,999,999.99"
EndIf

nLin := nLin + 1

/*
If mv_par04 == 2
@ nLin, 001 PSAY "Valor Total    : "
@ nLin, Pcol()+1 PSAY xTOT_FAT Picture "@E 999,999.99"
nLin := nLin + 1
EndIf
*/

If mv_par04 == 1
	@ nLin, 001      PSAY "Peso Liquido   : "
	@ nLin, Pcol()+1 PSAY xPESO_LIQUID     Picture"@E 999,999.99"
EndIf

Return(.t.)


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CabecRoman
Static Function CabecRoman()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho da N.F.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 000, 000 PSAY ""

nLin := 1

@ nLin, 001 PSAY REPLICATE("_",78)
nLin := nLin + 1
@ nLin, 001 PSAY "  " + PADC("ROMANEIO - "+xNUM_NF,74) + "  "
nLin := nLin + 1
@ nLin, 001 PSAY "  " + PADC("EMISSAO  "+DTOC(xEMISSAO),74) + "  "
nLin := nLin + 1
@ nLin, 001 PSAY REPLICATE("_",78)
nLin := nLin + 2

@ nLin, 001 PSAY "Cliente:        "+ xNOME_CLI
nLin := nLin + 1
@ nLin, 001 PSAY "Transportadora: "+ xNOME_TRANSP
nLin := nLin + 1
@ nLin, 001 PSAY "Cond. Pagto.  : "+ xDESC_PAG
nLin := nLin + 1
@ nLin, 001 PSAY "Numero Pedido : "
For k := 1 to Len(xPED)
	@ nLin, Pcol() PSAY xPED[k] + " "
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados dos Produtos Vendidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := nLin + 2
@ nLin, 001 PSAY Replicate("-",78)
nLin := nLin + 1

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

