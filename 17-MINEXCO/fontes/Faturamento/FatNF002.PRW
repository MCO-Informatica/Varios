#include "rwmake.ch"                             
                                            
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function FatNF002() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE1,XVOLUME1,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XESPECIE2,XVOLUME2,XESPECIE3,XVOLUME3,XPLACA,XUFPLACA,XINSCESTT,XMOTORISTA")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM,XMENMINEX")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF,XDDD_CLI")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL,xDESCONT")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,xCLASFIS,xPESSOA,xPESS_TRANSP,xMSGDEV")

#IFNDEF WINDOWS

#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FatNF001  ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  11/07/06   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  03/08/06   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  04/09/06   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  11/09/06   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  25/09/06   º±±
±±º			 ³          ºModif  ³Cesar Moura         º Data ³  28/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Nota Fiscal de Entrada/Saida                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda (LX300)        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
| Variaveis utilizadas para parametros                                      |
| mv_par01             // Da Nota Fiscal                                    | 
| mv_par02             // Ate a Nota Fiscal                                 |
| mv_par03             // Da Serie                                          |
| mv_par04             // Nota Fiscal de Entrada/Saida                      | 
³ Tamanho do Formulario de Nota Fiscal (em Linhas)                          |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

CbTxt		:=""
CbCont		:=""
nOrdem 		:=0
Alfa 		:=0
Z			:=0
M			:=0
tamanho		:="G" 
limite		:=220
titulo 		:=PADC("Nota Fiscal - Nfiscal",74)
cDesc1 		:=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 		:=""
//cDesc3 		:=PADC("da Nfiscal",74) Magh
cDesc3      := ""
cNatureza	:="" 
aReturn 	:={ "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog	:="FatNF002" 
cPerg		:="NFSIGW"
nLastKey	:=0 
lContinua 	:=.T.
nLin		:=0
wnrel    	:="FatNF002"
dDate		:=DTOC(Date())
dTime		:=Substr(Time(),1,5)
XPLACA		:=""
XUFPLACA	:="" //Magh 04/07/06
XMOTORISTA  :="" //Magh 11/07/06
xPESSOA     :="" //Magh 04/09/06
xPESS_TRANSP:="" //Magh 04/09/06
xCOB_CLI    :="" //Magh 11/09/06
xMENMINEX   :="" //Magh 25/09/06            
xDESCONT	:= 0 //CM 29/09/06
xMSGDEV		:="" //CM 29/09/06

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Tamanho do Formulario de Nota Fiscal (em Linhas)                           |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
nTamNf:=72     // Apenas Informativo 

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Verifica as perguntas selecionadas, busca o padrao da Nfiscal              |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Pergunte(cPerg,.F.)               							// Grupo de Perguntas no SX1, Chama "NFSING"
cString:="SF2"

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Envia controle para a funcao SETPRINT                                      |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
   Return
Endif

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Verifica Posicao do Formulario na Impressora                               | 
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

VerImp()       

If mv_par04 == 1
	
	RptStatus({||NFEntrada()})
	
Elseif mv_par04 == 2
	
	
	RptStatus({|| RptDetail()})
	
Endif

Return

Static Function NFEntrada()

U_NFEntrada()

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
Endif

MS_FLUSH()


Static Function RptDetail()

Local J
Local I

If mv_par04 == 2
	dbSelectArea("SF2")                // Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

If mv_par04 == 1
	dbSelectArea("SF2")                // Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Inicializa  regua de impressao                                             |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

SetRegua(Val(mv_par02)-Val(mv_par01))
If mv_par04 == 2
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua
		
		If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                   // do Parametro Informado !!!
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
		
		nLinIni:=nLin                 // Linha Inicial da Impressao
		
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Inicio de Levantamento dos Dados da NF                                     |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		// Cabecalho da Nota Fiscal
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
		xBSRET      :=SF2->F2_BRICMS          //BASE DE ICMS RETIDO
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     :=0	//SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     :=0	//SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE1   :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME1    :=SF2->F2_VOLUME1         // Volume 1 no Pedido
		xESPECIE2   :=SF2->F2_ESPECI2         // Especie 1 no Pedido
		xVOLUME2    :=SF2->F2_VOLUME2         // Volume 1 no Pedido
		xESPECIE3   :=SF2->F2_ESPECI3         // Especie 1 no Pedido
		xVOLUME3    :=SF2->F2_VOLUME3         // Volume 1 no Pedido
		xDESCONT    :=SF2->F2_DESCONT         // Desconto da Nota Fiscal
		
		dbSelectArea("SD2")                   // Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu  := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		
		xPED_VEND:={}                         // Numero do Pedido de Venda
		xITEM_PED:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
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
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xCLASFIS :={}						 // Classificacao Fiscal
		xCFIMP   :={}
		xChave   :={}                         // Chave para busca do pedido+item
		
		while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03             // Se a Serie do Arquivo for Diferente
				DbSkip()                       // do Parametro Informado !!!
				Loop
			Endif
			
			_nPos := ASCAN(xChave,SD2->D2_PEDIDO+SD2->D2_COD)
			
			If _nPos<>0
				xQTD_PRO[_nPos]  :=  xQTD_PRO[_nPos]  + SD2->D2_QTSEGUM
				xVAL_IPI [_nPos] :=  xVAL_IPI [_nPos] + SD2->D2_VALIPI
				xVAL_MERC[_nPos] :=  xVAL_MERC[_nPos] + SD2->D2_TOTAL
				xPRE_UNI[_nPos]  :=  A410Arred((xVAL_MERC[_nPos] / xQTD_PRO[_nPos]),"C6_PRUNIT")
				
			Else
				
				AADD(xChave ,SD2->D2_PEDIDO+SD2->D2_COD)
				AADD(xPED_VEND ,SD2->D2_PEDIDO)
				AADD(xITEM_PED ,SD2->D2_ITEMPV)
				AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
				AADD(xPREF_DV  ,SD2->D2_SERIORI)
				AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
				AADD(xCOD_PRO  ,SD2->D2_COD)
				AADD(xQTD_PRO  ,SD2->D2_QTSEGUM)     // Guarda as quant. da NF
				AADD(xPRE_UNI  ,A410Arred((SD2->D2_TOTAL / SD2->D2_QTSEGUM),"C6_PRUNIT"))
				AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
				AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
				AADD(xVAL_IPI  ,SD2->D2_VALIPI)
				AADD(xDESC     ,SD2->D2_DESC)
				AADD(xVAL_MERC ,SD2->D2_TOTAL)
				AADD(xTES      ,SD2->D2_TES)
				AADD(xCF       ,SD2->D2_CF)
				AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
				AADD(xCLASFIS  ,SD2->D2_CLASFIS)
				
			EndIf
			   
			xPBRUTO += (SB1->B1_PESBRU * SD2->D2_QTSEGUM)
			xPLIQUI += (SB1->B1_PESO * SD2->D2_QTSEGUM)
			
			dbskip()
		End
		
		For x:= 1 to Len(xCF)
			If aScan(xCFImp,{|z| z[1] == xCF[x]}) == 0
				AADD(xCFImp,{xCF[x],Subs(Posicione("SF4",1,xFilial("SF4")+xTES[x],"F4_TEXTO"),1,20)})
			Endif
			
		Next
		
		dbSelectArea("SB1")                       // Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO  :={}                           // Peso Liquido
		xPESO_UNIT :={}                           // Peso Unitario do Produto
		xDESCRICAO :={}                           // Descricao do Produto
		xUNID_PRO  :={}                           // Unidade do Produto
		xCOD_TRIB  :={}                           // Codigo de Tributacao
		xMEN_TRIB  :={}                           // Mensagens de Tributacao
		xCOD_FIS   :={}                           // Cogigo Fiscal
		xCLAS_FIS  :={}                           // Classificacao Fiscal
		xMEN_POS   :={}                           // Mensagem da Posicao IPI
		xISS       :={}                           // Aliquota de ISS
		xTIPO_PRO  :={}                           // Tipo do Produto
		xLUCRO     :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL  :={}
		xPESO_LIQ  := 0
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,IIF(!EMPTY(SB1->B1_SEGUM),SB1->B1_SEGUM,SB1->B1_UM))
			// Magh 03/08/06 Ira buscar descricao campo C6_DESCRI em virtude do Ex Sel (extra selecionado)
			//AADD(xDESCRICAO ,SB1->B1_DESC)
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
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Calculo do Peso Liquido da Nota Fiscal                                     |
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			xPESO_LIQUID:=0                    // Peso Liquido da Nota Fiscal
			For j:=1 to Len(xPESO_PRO)
				xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
			Next j
			
		Next I
		
		dbSelectArea("SC5")                            // Pedidos de Venda
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
				xMENMINEX   :=SC5->C5_OBSMIN             // Mensagem propria da Minexco - Magh 04/07/05
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
				xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
				xPLACA		:=SC5->C5_PLACA			      // Placa do Veiculo
				xUFPLACA    :=SC5->C5_UFPLACA            // Estado da Placa do Veiculo - Magh 04/07/05
				xMOTORISTA  :=SC5->C5_MOTORIS            // Nome do Motorista - Magh 11/07/06
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
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Pesquisa da Condicao de Pagto                                              |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		dbSelectArea("SC6")                    // Itens de Pedido de Venda
		dbSetOrder(1)
		xPED_CLI :={}                          // Numero de Pedido
		xDESC_PRO:={}                          // Descricao aux do produto
		J:=Len(xPED_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,SC6->C6_DESCRI)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
			// Magh 03/08/06 Ira buscar descricao campo C6_DESCRI em virtude do Ex Sel (extra selecionado)
			AADD(xDESCRICAO,SC6->C6_DESCRI)
			
		Next j
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			dbSelectArea("SA1")                //Cadastro de Clientes
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
			xDDD_CLI :=SA1->A1_DDD             // DDD - Magh 11/09/06
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSUFRAMA :=SA1->A1_SUFRAMA         // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF         // Calcula Suframa
			xPessoa  :=SA1->A1_PESSOA          // Se pessoa Fisica = F ou Juridica = J - Magh 04/09/06
			
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
			
			dbSelectArea("SA2")                // Cadastro de Fornecedores
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
			xDDD_CLI :=SA2->A2_DDD             // DDD - Magh 11/09/06
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
			xPessoa  :=SA2->A2_TIPO           // Se pessoa Fisica = F ou Juridica = J - Magh 04/09/06
			
		Endif
		dbSelectArea("SA3")                   // Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next j
		
		/*  If xICMS_RET >0                          // Apenas se ICMS Retido > 0
		dbSelectArea("SF3")                   // Cadastro de Livros Fiscais
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
		*/
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
		xINSCESTT    :=SA4->A4_INSEST		    // Inscricao Est. Transportador
		xPess_Transp :=SA4->A4_PESSOA        // Se pessoa Fisica = F ou Juridica = J - Magh 04/09/06
		
		dbSelectArea("SE1")                   // Contas a Receber
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
		
		dbSelectArea("SF4")                   // Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		Imprime()
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		| Termino da Impressao da Nota Fiscal                                       |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
Else
	
	dbSelectArea("SF1")              // Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                   // do Parametro Informado !!!
			Loop
		Endif
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		| Inicializa  regua de impressao                                            |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
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
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		| Inicio de Levantamento dos Dados da Nota Fiscal                           |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
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
		xNFORI      :="" //SF1->F1_NFORI      // NF Original
		xPREF_DV    :="" //SF1->F1_SERIORI    // Serie Original
		
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
		xCLASFIS :={}	  					    // Classificacao Fiscal NF Entrada
		xMSGDEV  :={}                     	// Mensagem do Item da Nota Fiscal de Devolção
		xChave   :={}
		
		while !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE #mv_par03         // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			_nPos := ASCAN(xChave,SD1->D1_PEDIDO+SD1->D1_COD)
			
			If _nPos<>0
				xQTD_PRO[_nPos]  :=  xQTD_PRO[_nPos]  + SD1->D1_QTSEGUM
				xVAL_IPI [_nPos] :=  xVAL_IPI [_nPos] + SD1->D1_VALIPI
				xVAL_MERC[_nPos] :=  xVAL_MERC[_nPos] + SD1->D1_TOTAL
				xPRE_UNI[_nPos]  :=  A410Arred((xVAL_MERC[_nPos] / xQTD_PRO[_nPos]),"C6_PRUNIT")
				
			Else
				
				AADD(xChave ,SD1->D1_PEDIDO+SD1->D1_COD)
				AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
				AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
				AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
				AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
				AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
				AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
				AADD(xQTD_PRO  ,SD1->D1_QTSEGUM)          // Guarda as quant. da NF
				AADD(xPRE_UNI  ,A410Arred((SD1->D1_TOTAL / SD1->D1_QTSEGUM),"C6_PRUNIT"))
				AADD(xIPI      ,SD1->D1_IPI)            // % IPI
				AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
				AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
				AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
				AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
				AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
				AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
				AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
				AADD(xCLASFIS  ,SD1->D1_CLASFIS)        // Classificacao Fiscal NF Entrada
				AADD(xMSGDEV   ,SD1->D1_OBSMIN)         // Mensagem Utilizada para Retonro de Notas Fiscais , CM em 29/11/2006
			EndIf
			
			IF !Empty(ALLTRIM(SD1->D1_OBSMIN))
				xMENMINEX:= xMENMINEX + " " + ALLTRIM(SD1->D1_OBSMIN)    // Mensagem propria da Minexco - Magh 25/09/06
			EndIf
			
			dbskip()
		End
		
		
		
		
		
		dbSelectArea("SB1")                     // Desc. Generica do Produto
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
			
			dbSeek(xFilial()+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(xUNID_PRO ,IIF(!EMPTY(SB1->B1_SEGUM),SB1->B1_SEGUM,SB1->B1_UM))
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
			AADD(xCOD_FIS ,_CLASFIS)
			
		Next I
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		| Pesquisa da Condicao de Pagto               							  |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO == "D"
			
			dbSelectArea("SA1")                 // Cadastro de Clientes
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
			xDDD_CLI :=SA1->A1_DDD             // DDD - Magh 11/09/06
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xPessoa  :=SA1->A1_PESSOA          // Se pessoa Fisica = F ou Juridica = J - Magh 04/09/06
			
		Else
			
			dbSelectArea("SA2")                   // Cadastro de Fornecedores
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
			xDDD_CLI :=SA2->A2_DDD                // DDD - Magh 11/09/06
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			xPessoa  :=SA2->A2_TIPO               // Se pessoa Fisica = F ou Juridica = J - Magh 04/09/06
		EndIf
		
		dbSelectArea("SE1")                   	// Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       	// Parcela
		xVENC_DUP  :={}                       	// Vencimento
		xVALOR_DUP :={}                       	// Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // Tipos de Entrada e Saida
		dbSetOrder(1)
		//      dbSeek(xFilial()+SD1->D1_TES) Magh 25/09/06 estava buscando natureza errada
		dbSeek(xFilial()+xTES[1])
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
		
		
		Imprime()
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		| Termino da Impressao da Nota Fiscal                          			  |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|                                                                           |
|                                                                           |
|                           FIM DA IMPRESSAO                                |
|                                                                           |
|                                                                           |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|Fechamento do Programa da Nota Fiscal                                      |
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

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

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  |Fimo do Programa                                                           |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/



/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  |                                                                           |
  |                                                                           |
  |                          FUNCOES ESPECIFICAS                              |
  |                                                                           |
  |                                                                           |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerImp    ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica posicionamento de papel na Impressora             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Inicio da Funcao                                                          |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

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

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Fim da Funcao                                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPDET    ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±±
±±º			 ³          ºModif  ³Magh                º Data ³  13/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de Linhas de Detalhe da Nota Fiscal              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda (MFMIN)        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Inicio da Funcao                                                          |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function IMPDET()

Local I:=1
Local J:=1

nTamDet :=10            // Tamanho da Area de Detalhe

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

For I:=1 to nTamDet

      If I<= Len(xCOD_PRO)
          @ nLin, 007  PSAY xCOD_PRO[I]
          @ nLin, 015  PSAY xDESCRICAO[I]
          @ nLin, 059  PSAY xCOD_FIS[I]
          @ nLin, 064  PSAY xCLASFIS[I]
          @ nLin, 072  PSAY xUNID_PRO[I]
          @ nLin, 074  PSAY xQTD_PRO[I]               Picture "@E 99,999.9999"

          If !xTIPO $ "I/P" //Magh 13/09/06 Segundo a Sueli nao deverao ser impressos os valores de precos quando a NF for Complemento de ICMS e IPI
 //          @ nLin, 080  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99"
             @ nLin, 082  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.9999" //Magh 13/09/06
//          @ nLin, 102  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
             @ nLin, 099  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99" //Magh 13/09/06
          EndIf      
          
          @ nLin, 121  PSAY xICM_PROD[I]              Picture "99"
          @ nLin, 125  PSAY xIPI[I]                   Picture "99"
          @ nLin, 128  PSAY xVAL_IPI[I]               Picture "@E 99,999.99"
          J:=J+1
      Endif
   nLin :=nLin+1

Next

Return

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Fim da Funcao                                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CLASFIS   ºAutor  ³Marcos Simidu       º Data ³  16/11/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de Array com as Classificacoes Fiscais           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda (MFMIN)        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Inicio da Funcao                                                          |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function CLASFIS()

Local nLen := Len(xCLFISCAL)
Local nCont

@ nLin,006 PSAY "Classificacao Fiscal"
nLin := nLin + 1            

If nLen > 12
	nLen := 12
Endif

For nCont := 1 to nLen
   nCol := If(Mod(nCont,2) != 0, 05, 33)
   @ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
   @ nLin, nCol+ 03 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99")
   nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Fim da Funcao                                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPMENP   ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±± 
±±º			 ³          ºModif  ³Magh Moura          º Data ³  04/07/06   º±± 
±±º			 ³          ºModif  ³Magh Moura          º Data ³  11/09/06   º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao Mensagem Padrao da Nota Fiscal                   º±±
±±º          ³ Sera Impresso o Campo C5_OBSMIN pois a formula sofre       º±±
±±º          ³ modificacoes como no. nota, data emissao(NF Simp.Rem. p/ex)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda (MFMIN)        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Inicio da Funcao                                                          |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function IMPMENP()

//nCol:= 05
//nTamObs:=320
nCol:= 06 //Magh 11/09/06
nTamObs:= 120 //Magh 11/09/06              

/*If !Empty(xCOD_MENS)
   @ nLin, NCol PSAY FORMULA(xCOD_MENS)
Endif
*/

@ nLin, nCol PSAY SUBSTR(xMENMINEX,1,nTamObs)
nlin:=nlin+1
@ nLin, nCol PSAY SUBSTR(xMENMINEX,121,nTamObs)//Magh 11/09/06
nlin:=nlin+1
@ nLin, nCol PSAY SUBSTR(xMENMINEX,242,nTamObs)//Magh 11/09/06
nlin:=nlin+1
@ nLin, nCol PSAY SUBSTR(xMENMINEX,363,nTamObs)//cesar 13/10/06
nlin:=nlin+1
@ nLin, nCol PSAY SUBSTR(xMENMINEX,484,nTamObs)//cesar 13/10/06

Return
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Fim da Funcao                                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MENSOBS   ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  11/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao Mensagem no Campo Observacao                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda (MFMIN)        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Inicio da Funcao                                                          |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function MENSOBS()

//nTamObs:=150 - magh 11/09/06
//nCol:=05  - magh 11/09/06  

nTamObs:=120
nCol:=06  

//Magh 11/09/06
If !Empty(xCOB_CLI)
	@ nLin, nCol PSAY "END.COBRANÇA: " + SUBSTR(xCOB_CLI,1,nTamObs)
	nLin:= nlin+1
EndIf              
//------Magh 11/09/06

@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
nlin:=nlin+1
//@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,151,nTamObs))
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,121,nTamObs)) // magh 11/09/06
nlin:=nlin+1
//@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,301,nTamObs))
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,242,nTamObs))// magh 11/09/06
Return


/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Fim da Funcao                                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DUPLIC    ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do Parcelamento das Duplicacatas                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda (MFMIN)        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Inicio da Funcao                                                          |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function DUPLIC()

Local BB

nCol := 6 //coluna que inicia a impressao

nAjuste := 0

For BB:= 1 to Len(xVALOR_DUP)
   If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
        nCol:= If(Mod(BB,2) != 0, 06, 80)
    	@ nLin, nCol PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]
      	@ nLin, nCol + 22 PSAY xVENC_DUP[BB]
      	@ nLin, nCol + 45 PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
      	nLin := nLin + If(Mod(BB,2) != 0, 0, 1)
   Endif
Next

Return

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Fim da Funcao                                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRIME   ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±º			 ³          ºModif  ³CM Info             º Data ³  27/12/05   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  11/07/06   º±±         
±±º			 ³          ºModif  ³Magh Moura          º Data ³  04/09/06   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  11/09/06   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  13/09/06   º±±
±±º			 ³          ºModif  ³Magh Moura          º Data ³  25/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime a Nota Fiscal de Entrada e de Saida                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Minexco Com. Imp. Exp. Ltda (MFMIN)        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Inicio da Funcao                                                          |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function Imprime()

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  |                    IMPRESSAO DA N.F. DA Nfiscal               		      |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Impressao do Cabecalho da N.F.                                            |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

@ 02, 000 PSAY Chr(15)               // Compressao de Impressao

@ 02, 130 PSAY xNUM_NF               // Numero da Nota Fiscal                                                               

If mv_par04 == 1
//   @ 02, 116 PSAY "XX" //Entrada     Magh
     @ 02, 101 PSAY "XX" //Entrada
Else       
// @ 02, 101 PSAY "XX" //Saida(ok) Magh
   @ 02, 90 PSAY "XX" //Saida(ok)
Endif


//If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1]) NAO PODERA VERIFICAR POR ESSA CONDICAO POIS NOTAS FISCAIS DE DEVOLUÇÃO DE VENDA TEM OS CAMPOS ALIMENTADOS E NAO SAO NOTAS FISCAIS COMPLEMENTARES - Magh 25/09/06
If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1]) .and. !xTIPO $ "D" 
    @ 07, 006 PSAY xNATUREZA + " - COMPLEMENTAR"	// Texto da Natureza de Operacao quando NF complementar.
Else
	@ 07, 006 PSAY xNATUREZA                    // Texto da Natureza de Ope	racao
Endif

If mv_par04 == 1
    @ 07, 046 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else
    @ 07, 046 PSAY xCF[1] Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
EndIf


/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Impressao dos Dados do Cliente                                            |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

@ 10, 006 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio 
   If xPessoa == "J" //Se for CNPJ(Pessoa juridica) - Magh 04/09/06
      @ 10, 090 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99" 
   ElseIf xPessoa == "F"
      @ 10, 090 PSAY xCGC_CLI Picture"@R 999.999.999-99"
   EndIf
Else
   @ 10, 090 PSAY " "                // Caso seja vazio
Endif

@ 10, 127 PSAY xEMISSAO              // Data da Emissao do Documento


@ 12, 006 PSAY xEND_CLI                               // Endereco
@ 12, 080 PSAY xBAIRRO                                // Bairro
@ 12, 105 PSAY xCEP_CLI Picture"@R 99999-999"         // CEP
If mv_par04 == 2
	@ 12, 127 PSAY dDate                              // Data da Saida/Entrada
EndIf
@ 14, 006 PSAY xMUN_CLI                               // Municipio
//@ 14, 065 PSAY xTEL_CLI                             // Telefone/FAX
@ 14, 060 PSAY "("+ xDDD_CLI + ") " + xTEL_CLI       // Telefone/FAX + DDD Magh 11/09/06
@ 14, 082 PSAY xEST_CLI                               // U.F.
@ 14, 095 PSAY xINSC_CLI                              // Insc. Estadual
If mv_par04 == 2
	@ 14, 128 PSAY dTime                                  // Hora da Saida/Entrada
EndIf

If mv_par04 == 2
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Impressao da Fatura/Duplicata                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
   nLin:= 17
   BB:=1
   nCol := 10             //  duplicatas
   DUPLIC()
Endif

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Dados dos Produtos Vendidos                                               |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

nLin := 22 
ImpDet()                 // Detalhe da NF

If mv_par04 == 2 .and. Len(xISS) == 0

//  nLin:=39 - Magh 11/09/06
  nLin:= 33
  MensObs()             // Imprime Mensagem de Observacao

  nLin:=37
  ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal

Endif
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Impressão do Valor do Desconto na Nota Fiscal                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If xDESCONT > 0 
	@ 42, 020  PSAY "Desconto:......R$"+ Transf(xDESCONT, "@EZ 999,999,999.99")
EndIf

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Impressão da Msg de Devolução                                             |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If xTIPO =='D' .And. mv_par04 == 1
	@ 43, 020  PSAY xMSGDEV[1]
EndIf

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Prestacao de Servicos Prestados                                           |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(xISS) > 0

   nLin := 40
   Impmenp()

   nLin :=41
   MensObs()

  @ 44, 142  PSAY xTOT_FAT  Picture"@E@Z 999,999,999.99"   // Valor do Servico
Endif                                                    
*/

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Calculo dos Impostos                                                      |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

@ 46, 006  PSAY xBASE_ICMS  Picture"@E@Z 999,999,999.99"  // Base do ICMS
@ 46, 034  PSAY xVALOR_ICMS Picture"@E@Z 999,999,999.99"  // Valor do ICMS
@ 46, 063  PSAY xBSICMRET   Picture"@E@Z 999,999,999.99"  // Base ICMS Ret.
@ 46, 093  PSAY xICMS_RET   Picture"@E@Z 999,999,999.99"  // Valor  ICMS Ret.
If !xTIPO $ "I/P" //Magh 13/09/06
   @ 46, 124  PSAY xVALOR_MERC Picture"@E@Z 99,999,999.99"  // Valor Tot. Prod.
Endif
@ 48, 006  PSAY xFRETE      Picture"@E@Z 999,999,999.99"  // Valor do Frete
@ 48, 034  PSAY xSEGURO     Picture"@E@Z 999,999,999.99"  // Valor Seguro
@ 48, 093  PSAY xVALOR_IPI  Picture"@E@Z 999,999,999.99"  // Valor do IPI
If !xTIPO $ "I" //Magh 13/09/06      Quando for complemento de IPI Informar o valor no total da Nota pois o IPI agrega-se ao total da nota
	@ 48, 124  PSAY xTOT_FAT    Picture"@E@Z 99,999,999.99"  // Valor Total NF
EndIf
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  | Impressao Dados da Transportadora                                         |
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
                  
If !EMPTY(XMOTORISTA) //Magh 11/07/06
    @ 51, 006  PSAY ALLTRIM(xNOME_TRANSP) + "/MOTOR. " + ALLTRIM(xMOTORISTA) // Nome da Transportadora + Nome Motorista
Else
    @ 51, 006  PSAY xNOME_TRANSP                   // Nome da Transportadora
EndIf

If xTPFRETE=='C'                                   // Frete por conta do
   @ 51, 086 PSAY "1"                              // Emitente (1)
Else                                               //     ou
   @ 51, 086 PSAY "2"                              // Destinatario (2)
Endif

If !EMPTY(XPLACA)
	@ 51, 092 PSAY XPLACA    picture "@E AAA-9999"   // Res. p/Placa do Veiculo
	@ 51, 105 PSAY XUFPLACA	   						 //Magh 04/07/05
EndIf

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
   If xPess_Transp == "J"      //Se transportador for pessoa Juridica - Magh 04/09/06
      @ 51, 110 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
   ElseIf xPess_Transp == "F"         
      @ 51, 110 PSAY xCGC_TRANSP Picture"@R 999.999.999-99"
   EndIf     
Else
   @ 51, 115 PSAY " "                               // Caso seja vazio
Endif

@ 53, 006 PSAY xEND_TRANSP                          // Endereco Transp.
@ 53, 074 PSAY xMUN_TRANSP                          // Municipio
@ 53, 105 PSAY xEST_TRANSP                          // U.F.
@ 53, 115 PSAY XINSCESTT                            // Reservado p/Insc. Estad.


@ 55, 005 PSAY xVOLUME1  Picture"@E@Z 999,999.99"             // Quant. Volumes
@ 55, 020 PSAY xESPECIE1 Picture"@!"                          // Especie

If mv_par04 == 2
	@ 55, 107 PSAY "Kg " + ALLTRIM(STR(xPBRUTO))    // Peso Bruto
	@ 55, 125 PSAY "Kg " + ALLTRIM(STR(xPLIQUI))    // Peso Liquido
EndIf

//@ 55, 005 PSAY xVOLUME3  Picture"@E@Z 999,999.99"             // Quant. Volumes
//@ 55, 020 PSAY xESPECIE3 Picture"@!"                          // Especie

@ 56, 005 PSAY xVOLUME2  Picture"@E@Z 999,999.99"             // Quant. Volumes
@ 56, 020 PSAY xESPECIE2 Picture"@!"                          // Especie
//@ 56, 052 PSAY " "                                           // Res para Marca
//@ 56, 075 PSAY " "                                           // Res para Numero


If mv_par04 == 2
   nLin := 58
   Clasfis()               // Impressao de Classif. Fiscal
Endif                   

//Magh 13/09/06 - Segundo a Sueli nao eh necessario imprimir devido a formula que indicara a NF original
/*If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
   @ 64, 006 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1] + "Complementar" 
Endif*/


If !Empty(xSuframa)
//   @ 64, 60 PSAY "SUFRAMA : "+xSuframa //Magh 13/09/06
   @ 63,006 PSAY "SUFRAMA : "+xSuframa
EndIf


@ 66, 130 PSAY xNUM_NF                   // Numero da Nota Fiscal

@ 67, 000 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.

