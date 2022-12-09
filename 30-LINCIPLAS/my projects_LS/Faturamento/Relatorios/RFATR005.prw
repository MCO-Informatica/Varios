#include "rwmake.ch"
#include "topconn.ch"   
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³  RFATR005 ³      ³ Ricardo Felipelli     ³ Data ³ 04/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Saida da Laselva - Escalena                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Laselva                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATR005()

SetPrvt("MV_PAR01,MV_PAR02,MV_PAR03,CSAVCUR1,CSAVROW1,CSAVCOL1")
SetPrvt("CSAVCOR1,CSAVSCR1,CBTXT,CBCONT,CABEC1,CABEC2")
SetPrvt("CABEC3,WNREL,NORDEM,TAMANHO,LIMITE,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,CNATUREZA,CSTRING,NDUPS")
SetPrvt("NPOSREG,NELEMENTOS,NDOCANT,ACFOVAL,ACFO,DDATANT")
SetPrvt("LCONTINUA,NPESO,NPRECOU,NPRECOT,NPERICM,CMENPAD")
SetPrvt("CMENDESC,NCONT,NPESOB,NPESOL,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,M_PAG,TREGS,M_MULT,P_ANT")
SetPrvt("P_ATU,P_CNT,M_SAV20,M_SAV7,NLIN,MENNOTA1")
SetPrvt("MENNOTA2,CPESOL,CPESOB,CDOCANT,AITENS,AMENS")
SetPrvt("ATES,NVLRFAT,NX,CNUMPED,NPELEM,NEL")
SetPrvt("CMEN,NLIN2,")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mv_par01   := Space(6)
mv_par02   := Space(6)
mv_par03   := Space(3)
cSavCur1   := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont     := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem     := 0
tamanho    := "G"
limite     := 220
titulo     := "NOTA FISCAL SAIDA - LASELVA"
cDesc1     := "Este programa ira emitir a Nota Fiscal de Laselva,"
cDesc2     := "dos pedidos migrado pelo e-commerce da Escalena."
cDesc3     := ""
cNatureza  := ""
cString    := "SF2"
nDups      := 0.00
nPosReg    := 0
nElementos := 0
nDocAnt    := 0
aCFOVAL    := {}
aCFO       := {}
dDatAnt    := CTOD('  /  /  ')
lContinua  := .T.
nPeso      := 0
nPrecoU    := 0
nPrecoT    := 0
nPerIcm    := 0
cMenPad    := ""
cMenDesc   := ""
nCont      := 0
nPesoB     := 0
nPesoL     := 0
aReturn    := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "RFATR005"
nLastKey   := 0
cPerg      := Padr("FATR09",len(SX1->X1_GRUPO)," ")
wnrel      := "RFATR005"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := ' '
cbcont   := ' '
m_pag    := 1


_pergunt()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da NFSAI  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Nota                              ³
//³ mv_par02             // Ate a Nota                           ³
//³ mv_par03             // Serie                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If LastKey() == 27 .OR. nLastKey == 27
	Return
Endif


RptStatus({|lend| IMPNOTA()},"Aguarde , Gerando a nota ....",,)

RETURN nil


******
STATIC FUNCTION IMPNOTA()
*************************
VerImp()

dbSelectArea("SF2")                // Cabecalho da Nota Fiscal Saida
dbSetOrder(1)
dbSeek(xFilial()+mv_par01+mv_par03,.t.)

SetPrc(0,0)
nLin:= 0 
_strg  := iif((val(mv_par02)-val(mv_par01))>0 ,(val(mv_par02)-val(mv_par01)),1)   
_impnf := 0
SETREGUA(_strg)

While ! eof() .and. F2_FILIAL== xFilial() .and. F2_DOC <= mv_par02 .and. F2_SERIE == mv_par03
	
	INCREGUA()
	IF LastKey()==286
		@nLin+nLiNot,001 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif

	if SF2->F2_FIMP == 'S'        
		alert("Nota: " + SF2->F2_DOC + " ja foi impressa.......")
		If !MSGyesno("Deseja imprimir outra vez ??")
			SF2->(dbskip())
			loop
		endif
	endif

	nQtdMaster:=0 
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SD2 para buscar os itens da NF                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o SC5 para buscar mensagem do pedido de venda para NF   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial()+SD2->D2_PEDIDO)
	mennota1:=subs(SC5->C5_MENNOTA,1,100)
	mennota2:=subs(SC5->C5_MENNOTA,101,100)
	cMenPad :=SC5->C5_MENPAD
	cPesoL  :=SC5->C5_PESOL
	cPesoB  :=SC5->C5_PBRUTO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o SA1(Cliente) ou (SA2)Fornecedor para buscar os Dados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF2->F2_TIPO $ "B/D"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SD2->D2_CLIENTE+SD2->D2_LOJA)
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SD2->D2_CLIENTE+SD2->D2_LOJA)
	Endif        
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Analisa se a nota para impressao veio do e-commerce          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    if !'ESCALENA' $ SA1->A1_OBSERV	 
		alert("Nota: " + SF2->F2_DOC + " Não pode ser impressa, não é nota de e-Commerce  !!")
		dbSelectArea("SF2")
		dbSkip()
		loop
    endif                                                                   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA4 para buscar a Transportadora                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SA4")
	DbSetOrder(1)
	DbSeek(XFilial()+SF2->F2_TRANSP)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SM4 para buscar as Formulas                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SM4")
	DbSetOrder(1)
	DbSeek(XFilial()+cMenPad)
	cMenDesc := SM4->M4_FORMULA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SE1 para buscar contas  a receber                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SE1")
	DbSetOrder(1)
	dbSeek(xFilial()+SF2->F2_SERIE+SF2->F2_DOC)
	
	dbSelectArea("SD2")
	cDocant   := D2_DOC+D2_SERIE
	aItens    := {}
	aCFO      := {}
	aCFOVAL   := {}
	aMens     := {}
	aTES      := {}
	nVlrFat   := 0.00
	nPeso     := 0.00
	nCont     := 0
	nPosReg   := Recno()
	nX        := 0
	cNatureza :=""
	nVlrFat   := (SF2->F2_VALMERC+SF2->F2_SEGURO+SF2->F2_FRETE+SF2->F2_ICMSRET)
	xPESO_LIQ := 0
	xPESO_BRUTO := 0

	dbSelectArea("SD2")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva o numero do pedido pelo SD2                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumPed := SD2->D2_PEDIDO
	
	While ! eof() .and. D2_FILIAL+D2_DOC+D2_SERIE == xFilial()+cDocant
		// Estrutura do array de Itens da NF
		// aItens[n][1] | aItens[n][2] | aItens[n][3] | aItens[n][4] | aItens[n][5] | aItens[n][6] | aItens[n][7] | aItens[n][8]  |
		// Quantidade   | Un.de medida | Descricao    | Preco unit.  | Valor total  | Class. Fiscal| Aliq. ipil   | Valor do ipi  |
		IF LastKey()==286
			@nLin,001 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		If !Empty(SD2->D2_PICM)
			nPerICM := SD2->D2_PICM
		Endif
		
		dbSelectArea("SB1")
		dbSeek(xFilial()+SD2->D2_COD)
		dbSelectArea("SD2")
		nPrecou := SD2->D2_PRCVEN
		nPrecot := SD2->D2_TOTAL
		nPeso:=nPeso+(SB1->B1_PESO*SD2->D2_QUANT)   
		_cf  := SD2->D2_CF
		
		dbSelectArea("SC6")
		dBSetOrder(1)
		dbSeek(xFilial()+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
		cProduto:= SB1->B1_COD

/*		AADD(aItens,{SD2->D2_COD})  // codigo do produto
		AADD(aItens,{subst(SB1->B1_DESC,1,48)})   // descricao do produto
		AADD(aItens,{''})  // c.f.
		AADD(aItens,{''})  // sit.trib.
		AADD(aItens,{SB1->B1_UM})  // un
		AADD(aItens,{SD2->D2_QUANT})  // quantidade
		AADD(aItens,{SD2->D2_PRCVEN})  // valor unitario
		AADD(aItens,{SD2->D2_TOTAL})  // valor total
		AADD(aItens,{IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM)})  // aliquota icms
		AADD(aItens,{IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI)})  // aliquota ipi
*/

		AADD(aItens,{SD2->D2_COD,;
			subst(SB1->B1_DESC,1,48),;
			'',;
			'',;
			SB1->B1_UM,;
			SD2->D2_QUANT,;
			SD2->D2_PRCVEN,;
			SD2->D2_TOTAL,;
			IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM),;
			IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI) } )  



		npElem := Ascan(aCFO,SD2->D2_CF)
		xPESO_LIQ   += SB1->B1_PESO * SD2->D2_QUANT
		xPESO_BRUTO += SB1->B1_PESBRU * SD2->D2_QUANT 

		If npElem == 0
			AADD(aCFO,SD2->D2_CF)
			AADD(aCFOVAL,SD2->D2_TOTAL)
			dbSelectArea("SF4")
			dbSeek(xFilial()+SD2->D2_TES)
			cNatureza := SF4->F4_TEXTO+"    "+Trim(SD2->D2_CF)
			dbSelectArea("SD2")
		Else
			aCFOVAL[npElem] := aCFOVAL[npElem]+SD2->D2_TOTAL
		Endif
		nEl:=Ascan(aTES,SD2->D2_TES)
		IF nEL == 0
			dbSelectArea("SF4")
			dbSeek(xFilial()+SD2->D2_TES)
			IF !Empty(SF4->F4_TEXTO)
				AADD(aTES,SD2->D2_TES)
				AADD(aMens,SF4->F4_TEXTO)
			EndIF
		EndIF
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	Go nPosReg
	nElementos := 1
	cMen := .F.
	@ nLin, 000 PSAY Chr(15)                                // Compacta caracteres
	nLin := nLin + 1
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio da impressao                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ nLin,088 PSAY "-X-"
	@ nLin,120 PSAY SF2->F2_DOC  // NUMERO DA NF
	nLin := nLin + 3
	
	@nLin,006 PSAY cNatureza   // Texto da Natureza de Operacao    
	@nLin,049 PSAY _cf  // CFOP
	@nlin,062 PSAY SM0->M0_INSC
	nLin := nLin + 1
	
	If SF2->F2_TIPO $ "B/D"
		@nLin,004 PSAY SA2->A2_NOME
	Else
		@nLin,004 PSAY SA1->A1_NOME
	Endif
	@nLin,089 PSAY iif(SF2->F2_TIPO $ "B/D",SA2->A2_CGC,SA1->A1_CGC) PICTURE "@R 99.999.999/9999-99"
	@nLin,118  PSAY SF2->F2_EMISSAO
	nLin := nLin + 2
	
	If SF2->F2_TIPO $ "B/D"
		@nLin,004 PSAY SA2->A2_END
		@nLin,072 PSAY SA2->A2_BAIRRO
		@nLin,102 PSAY SA2->A2_CEP PICTURE "@R 99999-999"
	ELSE
		@nLin,004 PSAY SA1->A1_END
		@nLin,072 PSAY SA1->A1_BAIRRO
		@nLin,102 PSAY SA1->A1_CEP PICTURE "@R 99999-999"
	Endif
	nLin := nLin + 1
	
	If SF2->F2_TIPO $ "B/D"
		@nLin,004 PSAY SA2->A2_MUN
		@nLin,054 PSAY SA2->A2_TEL
		@nLin,082 PSAY SA2->A2_EST
	ELSE
		@nLin,004 PSAY SA1->A1_MUN
		@nLin,054 PSAY SA1->A1_TEL
		@nLin,082 PSAY SA1->A1_EST
	ENDIF
	@ nLin,090 PSAY iif(SF2->F2_TIPO $ "B/D",SA2->A2_INSCR,SA1->A1_INSCR)
	nLin := nLin + 2


	nx:=1
		
	For nx := 1 to 10
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa vetor para impressao dos itens para cada linha relacionada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@nLin,00 PSAY CHR(15)

		If Len(aItens) >= nElementos
			@nLin,003  PSAY aItens[nElementos][1]                              // Codigo do Produto
			@nLin,016  PSAY subst(aItens[nElementos][2],1,40)                  // Descric. Produto
			@nLin,058  PSAY subst(aItens[nElementos][3],1,1)                   // Classif. Fiscal do Produto
			@nLin,060  PSAY subst(aItens[nElementos][4],1,1)                   // Unidade
			@nLin,064  PSAY aItens[nElementos][5]  Picture "@E 9999.99"     // Quantidade
			@nLin,073  PSAY aItens[nElementos][6]  Picture "@E 999,999.99"     // Preço Unitário
			@nLin,086  PSAY aItens[nElementos][7]  Picture "@E 99,999,999.99"  // Valor total
			@nLin,108  PSAY aItens[nElementos][8]  Picture "99"                // Aliq. ICM
			@nLin,115  PSAY aItens[nElementos][9]  Picture "99"                // Aliq. IPI
		Endif
		
		nLin := nLin + 1
		nElementos:=nElementos+1
		nCont := nCont + 1
		
	Next nX
		
	nLin2 := ABS(nCont - 25)
//	nLin := nLin + 2
	IF SF2->F2_VALICM != 0
		IF SF2->F2_VALMERC <> SF2->F2_BASEICM
			@ nLin,04 PSAY SF2->F2_BASEICM PICTURE "@E 99,999,999.99"
		ELSE
			@ nLin,04 PSAY SF2->F2_VALMERC PICTURE "@E 99,999,999.99"
		ENDIF
		@ nLin,20 PSAY SF2->F2_VALICM PICTURE "@E 99,999,999.99"
	ENDIF
	@ nLin,113 PSAY SF2->F2_VALMERC PICTURE "@E 99,999,999.99"
	
	nLin+=2
	@ nLin,003 PSAY SF2->F2_FRETE  	Picture "@E 999,999,999.99"  // Valor do Frete
	@ nLin,026 PSAY SF2->F2_SEGURO 	Picture "@E 999,999,999.99"  // Valor Seguro
	@ nLin,045 PSAY SF2->F2_DESPESA  	Picture "@E 999,999,999.99"  // Valor outras despesas
	@ nLin,082 PSAY SF2->F2_VALIPI  Picture "@E 999,999,999.99"  // Valor do IPI
	@ nLin,113 PSAY (SF2->F2_VALMERC+SF2->F2_VALIPI) PICTURE "@E 99,999,999.99"  // Valor total dos produtos
	
              
// Impressao da transportadora 

	nLin := nLin + 3
	@ nLin,004 PSAY SA4->A4_NOME
	@ nLin,080 PSAY "1"          // frete por conta do emitente (1)
	@ nLin,100 PSAY SA4->A4_EST
	@ nLin,104 PSAY SA4->A4_CGC
	nLin := nLin + 2
	
	@ nLin,004 PSAY SA4->A4_END
	@ nLin,065 PSAY SA4->A4_MUN
	@ nLin,100 PSAY SA4->A4_EST
	@ nLin,104 PSAY SA4->A4_INSEST
	nLin := nLin + 2
		
	IF SF2->F2_VOLUME1 != 0
		@ nLin,012 PSAY SF2->F2_VOLUME1
	ENDIF         
	@ nLin,021 PSAY "Volumes"         // Especie
	@ nLin,040  PSAY SC5->C5_ESPECI2  // marca
	IF xPESO_BRUTO != 0
		@ nLin,095 PSAY xPESO_BRUTO PICTURE "@!"
	ENDIF
	IF xPESO_LIQ != 0
		@ nLiN,126 PSAY xPESO_LIQ PICTURE "@!"
	ENDIF
	nLin:=nLin+4
	
	dbSelectArea("SF2")
	RecLock( 'SF2', .F. )
	SF2->F2_FIMP := 'S'
	SF2->(MsUnLock())
	dbSkip() 
	_impnf++

EndDo       

dbSelectArea("SF2")
dbSetOrder(1)

if _impnf <> 0
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Impressao                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RETURN nil


******
Static Function VerImp()
************************
nLin    := 0
nContad := 0
If aReturn[5]== 2
	nOpc:= 1
	
	#IFNDEF WINDOWS
		cCor:= "B/BG"
	#ENDIF
	
	While .T.
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY " "
		@ nLin ,022 PSAY " "
		
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

Return nil



Static function _pergunt()

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+"01")
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "De Nota     ?"
SX1->X1_VARIAVL := "mv_ch1"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 09
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par01"
SX1->X1_F3      := ""
MsUnLock()
dbCommit()


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+"02")

If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Ate a Nota  ?"
SX1->X1_VARIAVL := "mv_ch2"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 9
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par02"
MsUnLock()
dbCommit()


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+"03")
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Serie   ?"
SX1->X1_VARIAVL := "mv_ch3"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 3
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par03"
MsUnLock()
dbCommit()


Return(nil)

          
