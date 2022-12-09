#Include "PROTHEUS.CH"
#Include "rwmake.CH"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para tratamento dos Sub-Totais por Ocorrencia  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE DESPESAS           3
#DEFINE DESCONTOS          4
#DEFINE ABATIMENTOS        5
#DEFINE VALORRECEBIDO      6
#DEFINE JUROS              7
#DEFINE MULTA              8
#DEFINE VALORIOF           9
#DEFINE VALORCC	           10
#DEFINE OUTRDESP		  11


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINR01   º Autor ³ Ricardo Felipelli  º Data ³  09/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ imprime arquivo retorno.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FINR01(_xaPar)
///////////////////////////

Local wnrel
Local cString
Local lOk := .t.
Local cDesc1  := "Este programa tem como objetivo imprimir o arquivo"
Local cDesc2  := "Retorno da Comunicação Banc ria, conforme layout, "
Local cDesc3  := "previamente configurado."
LOCAL tamanho := "G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Titulo := "Impressao do Retorno da Comunicacao Bancaria"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { "Zebrado",1,"Administracao", 2, 2, 1, "",1 }
PRIVATE cPerg    := Padr("FIN650",len(SX1->X1_GRUPO)," ")   , nLastKey := 0
PRIVATE nomeprog := "FINR01"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If ValType(_xaPar) == 'A'
	mv_par01 := _xaPar[1]
	mv_par02 := _xaPar[2]
	mv_par03 := _xaPar[3]
	mv_par04 := _xaPar[4]
	mv_par05 := _xaPar[5]
	mv_par06 := _xaPar[6]
	mv_par07 := _xaPar[7]
	mv_par08 := _xaPar[8]
Else
	pergunte(cPerg,.F.)
EndIf
*/
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Arquivo de Entrada                    ³
//³ mv_par02            // Arquivo de Configura‡„o               ³
//³ mv_par03            // Codigo do Banco                       ³
//³ mv_par04            // Codigo Agencia						 ³
//³ mv_par05            // Codigo Conta			                 ³
//³ mv_par06            // Codigo SubConta			             ³
//³ mv_par07            // Receber / Pagar                       ³
//³ mv_par08            // Modelo Cnab / Cnab2		             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par07 == 1
	cString := "SE1"
Else
	cString := "SE2"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR01"            //Nome Default do relatorio em Disco
aOrd  := {"Por Numero","Por Natureza","Por Vencimento","Por Banco","Fornecedor","Por Emissao","Por Cod.Fornec."}
wnrel := SetPrint(cString,wnrel,iif(ValType(_xaPar) == 'A','',cPerg),@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
End
fErase(__RelDir + wnrel + '.##R')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| U_Far650Imp12(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA650Imp ³ Autor ³ Elaine F. T. Beraldo  ³ Data ³ 20/06/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impress„o da Comunicacao Bancaria - Retorno                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA650Imp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR650                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FAr650Imp12(lEnd,wnRel,cString)
/////////////////////////////////////////////

Local cPosPrin,  cPosJuro,  cPosMult, cPosCC,   cPosTipo, cPosOutrd
Local cPosNum ,  cPosData,  cPosDesp, cPosDesc, cPosAbat, cPosDtCC, cPosIof, cPosOcor
Local cPosNosso, cPosForne, cPosCgc
Local lPosNum  := .f. , lPosData := .f. , lPosAbat  := .f.
Local lPosDesp := .f. , lPosDesc := .f. , lPosMult  := .f.
Local lPosPrin := .f. , lPosJuro := .f. , lPosDtCC  := .f.
Local lPosOcor := .f. , lPosTipo := .f. , lPosIof   := .f.
Local lPosCC   := .f. , lPosNosso:= .f. , lPosRej   := .f.
Local lPosForne:= .f. , lPosCgc  := .F. , lPosOutrD := .f.
Local nLidos ,nLenNum  ,nLenData ,nLenDesp ,nLenDesc ,nLenAbat ,nLenDtCC, nLenCGC
Local nLenPrin ,nLenJuro ,nLenMult ,nLenOcor ,nLenTipo ,nLenIof  ,nLenCC, lLenNosso, nLenOutrD
Local nLenRej := 0
Local cArqConf ,cArqEnt  ,xBuffer  ,nTipo
Local tamanho := "G", lOcorr := .F.
Local cDescr
LOCAL cEspecie,cData,nTamArq,cForne,cCgc
Local nValIof    := 0
Local nDespT     :=nDescT:=nAbatT:=nValT:=nJurT:=nMulT:=nIOFT:=nCCT:=nOut:=0
Local nHdlBco    := 0
Local nHdlConf   := 0
Local cTabela 	 := "17"
Local lRej       := .f.
Local cCarteira
Local nTamDet
Local lHeader    := .f.
Local lTrailler  := .F.
Local aTabela 	 := {}
Local cChave650
Local nPos       := 0
Local lAchouTit  := .F.
Local nValPadrao := 0
Local aValores   := {}
LOCAL lF650Var   := ExistBlock("F650VAR" )
Local nTamparc   := TamSX3("E1_PARCELA")[1]
LOCAL dDataFin   := Getmv("MV_DATAFIN")
Local nCont
Local lOk
Local x
Local nCntOco    := 0
Local aCntOco    := {}
Local cCliFor	 := '000000 00'

PRIVATE m_pag , cbtxt , cbcont , li

//Essas variaveis tem que ser private para serem manipuladas
//nos pontos de entrada, assim como eh feito no FINA200
Private cNumTit
Private dBaixa
Private cTipo
Private cNossoNum
Private nDespes	  := 0
Private nDescont  := 0
Private nAbatim	  := 0
Private nValrec	  := 0
Private nJuros	  := 0
Private nMulta	  := 0
Private nValCc	  := 0
Private nOutrDesp := 0
Private dCred
Private cOcorr
Private _nom_cl_fo:='' // guarda o nome do cliente / fornecedor
Private _num_cnab :=0  // guarda o numero dado ao titulo pelo banco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
	Cabec1  := 'no.Titulo       Esp Cliente                      Ocorrencia                 Dt.Ocor.    Desp. Cobr    Desconto  Abatimento   Principal       Juros       Multa       IOF   Outros Cr   Data Cred Nro Titulo Bco'
Else
	Cabec1  := 'no.Titulo       Esp Fornecedor                   Ocorrencia                 Dt.Ocor.    Desp. Cobr    Desconto  Abatimento   Principal       Juros       Multa       IOF   Outros Cr   Data Cred Nro Titulo Bco'
EndIf
cabec2  := ""
nTipo:=Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca tamanho do detalhe na configura‡„o do banco            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEE")
If dbSeek(xFilial("SEE")+mv_par03+mv_par04+mv_par05+mv_par06)
	nTamDet:= Iif(Empty (SEE->EE_NRBYTES), 400, SEE->EE_NRBYTES)
	ntamDet+= 2  // Ajusta tamanho do detalhe para leitura do CR (fim de linha)
Else
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOBCOCAD")
	Return .F.
Endif

cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

dbSelectArea( "SX5" )
If !SX5->( dbSeek( cFilial + cTabela ) )
	Help(" ",1,"PAR150")
	Return .F.
Endif
While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
	AADD(aTabela,{Alltrim(X5Descri()),Pad(SX5->X5_CHAVE,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)))})  // correcao da tabela de titulos (Pequim 18/08/00)
	SX5->(dbSkip( ))
Enddo
_nBaixaOK  := 0
_nBaixaNOk := 0
IF mv_par08 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo de configura‡„o ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqConf:=mv_par02
	IF !FILE(cArqConf)
		Set Device To Screen
		Set Printer To
		Help(" ",1,"NOARQPAR")
		Return .F.
	Else
		nHdlConf:=FOPEN(cArqConf,0+64)
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ arquivo de configura‡„o ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos :=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)
	
	While nLidos <= nTamArq
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o tipo de qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)
		
		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
			nLidos+=85
			Loop
		EndIF
		
		If mv_par07 == 1						// Somente cart receber deve ler estes campos
			IF !lPosIof
				cPosIof:=Substr(xBuffer,17,10)
				nLenIof:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosIof:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosCC
				cPosCC:=Substr(xBuffer,17,10)
				nLenCC:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosCC:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosDtCc
				cPosDtCc:=Substr(xBuffer,17,10)
				nLenDtCc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosDtCc:=.t.
				nLidos+=85
				Loop
			EndIF
		EndIf
		
		IF !lPosNosso
			cPosNosso:=Substr(xBuffer,17,10)
			nLenNosso:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNosso:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosRej
			cPosRej:=Substr(xBuffer,17,10)
			nLenRej:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosRej:=.t.
			nLidos+=85
			Loop
		EndIF
		If mv_par07 == 2
			IF !lPosForne
				cPosForne := Substr(xBuffer,17,10)
				nLenForne := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosForne := .t.
				nLidos += 85
				Loop
			EndIF
			IF !lPosCgc
				cPosCgc   := Substr(xBuffer,17,10)
				nLenCgc   := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosCgc   := .t.
				nLidos += 85
				Loop
			EndIF
		Endif
		Exit
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ fecha arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Fclose(nHdlConf)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqEnt:=mv_par01
IF !FILE(cArqEnt)
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOARQENT")
	Return .F.
Else
	nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLidos:=0
FSEEK(nHdlBco,0,0)
nTamArq:=FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)

SetRegua(nTamArq/nTamDet)

While nTamArq-nLidos >= nTamDet
	If mv_par08 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(nTamDet)
		FREAD(nHdlBco,@xBuffer,nTamDet)
		
		IncRegua()
		
		IF !lHeader
			nLidos+=nTamDet
			lHeader := .t.
			Loop
		EndIF
		
		IF	SubStr(xBuffer,1,1) == "0" .or. SubStr(xBuffer,1,1) == "9" .or. ;
			SubStr(xBuffer,1,1) == "8"
			nLidos+=nTamDet
			Loop
		EndIF
		
		If SubStr(xBuffer,1,1) $ "1#F#J#7#2" .or. Substr(xBuffer,1,3) == "001"
			nDespes :=0
			nDescont:=0
			nAbatim :=0
			nValRec :=0
			nJuros  :=0
			nMulta  :=0
			nOutrDesp := 0
			If mv_par07 == 1						// somente carteira receber
				nValIof :=0
				nValCc  :=0
				dCred   :=ctod("  /  /  ")
			Else
				cCgc := " "
			EndIf
			cData   :=""
			dBaixa  :=ctod("  /  /  ")
			cEspecie:="   "
			cNossoNum:=Space(15)
			cForne:= Space(8)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Lˆ os valores do arquivo Retorno ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF !Empty(cPosDesp)
				nDespes:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100
			EndIF
			IF !Empty(cPosDesc)
				nDescont:=Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100
			EndIF
			IF !Empty(cPosAbat)
				nAbatim:=Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100
			EndIF
			IF !Empty(cPosPrin)
				nValRec :=Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100
			EndIF
			IF !Empty(cPosJuro)
				nJuros  :=Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100
			EndIF
			IF !Empty(cPosMult)
				nMulta  :=Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100
			EndIF
			IF !Empty(cPosOutrd)
				nOutrDesp  :=Val(Substr(xBuffer,Int(Val(Substr(cPosOutrd,1,3))),nLenOutrd))/100
			EndIF
			IF !Empty(cPosIof)
				nValIof :=Val(Substr(xBuffer,Int(Val(Substr(cPosIof,1,3))),nLenIof))/100
			EndIF
			IF !Empty(cPosCc)
				nValCc :=Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100
			EndIF
			IF !Empty(cPosNosso)
				cNossoNum :=Substr(xBuffer,Int(Val(Substr(cPosNosso,1,3))),nLenNosso)
			EndIF
			IF !Empty(cPosForne)
				cForne  :=Substr(xBuffer,Int(Val(Substr(cPosForne,1,3))),nLenForne)
			Endif
			If !Empty(cPosCgc)
				cCgc  :=Substr(xBuffer,Int(Val(Substr(cPosCgc,1,3))),nLenCgc)
			Endif
			
			cDescr  := ""
			cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
			cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
			cData   := ChangDate(cData,SEE->EE_TIPODAT)
			dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
			cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
			cTipo   := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
			IF !Empty(cPosDtCc)
				cData :=Substr(xBuffer,Int(Val(Substr(cPosDtCc,1,3))),nLenDtCc)
				dCred :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
			EndIF
			If nLenOcor == 2
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
			Else
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
			EndIf
			If nLenRej > 0
				cRej		:= Substr(xBuffer,Int(Val(Substr(cPosRej,1,3))),nLenRej)
			EndIf
			
			lOk := .T.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ o array aValores ir  permitir ³
			//³ que qualquer exce‡„o ou neces-³
			//³ sidade seja tratado no ponto  ³
			//³ de entrada em PARAMIXB        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Estrutura de aValores
			// Numero do T¡tulo	- 01
			// data da Baixa		- 02
			// Tipo do T¡tulo		- 03
			// Nosso Numero		- 04
			// Valor da Despesa	- 05
			// Valor do Desconto	- 06
			// Valor do Abatiment- 07
			// Valor Recebido    - 08
			// Juros					- 09
			// Multa					- 10
			// Valor do Credito	- 11
			// Data Credito		- 12
			// Ocorrencia			- 13
			// Linha Inteira		- 14
			
			aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer, nOutrDesp })
			
			If lF650Var
				ExecBlock("F650VAR",.F.,.F.,{aValores})
			Endif
			
			If !Empty(cTipo)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica especie do titulo    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					cEspecie	:= "   "
				EndIf
				If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
					nLidos+=nTamDet
					Loop
				Endif
				dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
				dbSetOrder(IIF(mv_par07==1,16,11))
				lAchouTit := .F.
				// Busca pelo IdCnab
				If dbSeek(xFilial(IIF(mv_par07==1,"SE1","SE2"))+Substr(cNumTit,1,10))
					If ( mv_par07 == 1 )
						cEspecie  := SE1->E1_TIPO
					Else
						cEspecie  := SE2->E2_TIPO
					Endif
					lAchouTit := .T.
					nPos   	  := 1
				Endif
				// Busca pela chave antiga
				If !lAchouTit .And. !Empty(Substr(cNumtit,1,10))
					If dbSeek(xFilial()+Substr(cNumtit,1,10))
						lAchouTit := .T.
						nPos   := 1
					Endif
				Endif
				While !lAchouTit
					dbSetOrder(1)
					cChave650 := IIf(!Empty(cForne),cNumTit+Space(nTamParc-1)+cEspecie+SubStr(cForne,1,6),cNumTit+Space(nTamParc-1)+cEspecie)
					If !dbSeek(xFilial()+cChave650)
						nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
						If nPos != 0
							cEspecie := aTabela[nPos][2]
						Else
							Exit
						Endif
					Else
						If mv_par07 == 2
							cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
							cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
							nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso
							// Encontre o titulo
							While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave650
								nPos := nPosEsp
								If Empty(cCgc)
									Exit
								Endif
								dbSelectArea("SA2")
								If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
									If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
										Exit
									Endif
								Endif
								dbSelectArea("SE2")
								dbSkip()
								cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
								cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
								nPos 	  := 0
							Enddo
						Endif
						Exit
					Endif
				Enddo
				If nPos == 0
					cEspecie	:= "   "
					cCliFor	:= '000000 00'
				Else
					cEspecie := IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)
					cNumTit := IIF(mv_par07==1,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
					cCliFor	:= IIF(mv_par07==1,SE1->E1_CLIENTE+" "+SE1->E1_LOJA,SE2->E2_FORNECE+" "+SE2->E2_LOJA)
				EndIF
				If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
					nLidos += nTamDet
					Loop
				EndIf
			EndIF
		Else
			lTrailler := .T.
		Endif
		
	Else
		
		aLeitura := ReadCnab2(nHdlBco,MV_PAR02,nTamDet)
		If ( Empty(aLeitura[1]) )
			nLidos += nTamDet
			Loop
		Endif
		cNumTit  	:= SubStr(aLeitura[1],1,15)
		cData    	:= aLeitura[04]
		cData   	:= ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa   	:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y", Len(Substr(cData,5))))
		cTipo    	:= aLeitura[02]
		cTipo    	:= Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
		cNossoNum   := aLeitura[11]
		nDespes  	:= aLeitura[06]
		nDescont 	:= aLeitura[07]
		nAbatim  	:= aLeitura[08]
		nValRec  	:= aLeitura[05]
		nJuros   	:= aLeitura[09]
		nMulta   	:= aLeitura[10]
		cOcorr   	:= PadR(aLeitura[03],3)
		nValOutrD	:= aLeitura[12]
		nValCC   	:= aLeitura[13]
		cData    	:= aLeitura[14]
		cData   	:= ChangDate(cData,SEE->EE_TIPODAT)
		dDataCred	:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
		dDataUser	:= dDataCred
		dCred		:= dDataCred
		cRej	  	:= aLeitura[15]
		cForne		:= aLeitura[16]
		nOutrDesp	:= aLeitura[12]
		cCgc		:= " "
		lOk         := .t.
		lAchouTit 	:= .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ o array aValores ir  permitir ³
		//³ que qualquer exce‡„o ou neces-³
		//³ sidade seja tratado no ponto  ³
		//³ de entrada em PARAMIXB        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Estrutura de aValores
		//	Numero do T¡tulo	- 01
		//	data da Baixa		- 02
		// Tipo do T¡tulo		- 03
		// Nosso Numero		- 04
		// Valor da Despesa	- 05
		// Valor do Desconto	- 06
		// Valor do Abatiment- 07
		// Valor Recebido    - 08
		// Juros					- 09
		// Multa					- 10
		// Valor do Credito	- 11
		// Data Credito		- 12
		// Ocorrencia			- 13
		// Linha Inteira		- 14
		
		aValores := ( { cNumTit, dBaixa, cTipo, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer, nOutrDesp })
		nLenRej := Len(AllTrim(cRej))
		If lF650Var
			ExecBlock("F650VAR",.F.,.F.,{aValores})
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica especie do titulo    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))})
		If nPos != 0
			cEspecie := aTabela[nPos][2]
		Else
			cEspecie	:= "   "
		EndIf
		If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
			nLidos += nTamDet
			Loop
		Endif
		dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
		dbSetOrder(IIF(mv_par07==1,16,11))
		// Busca pelo IdCnab
		If dbSeek(xFilial(IIF(mv_par07==1,"SE1","SE2"))+Substr(cNumTit,1,10))
			If ( mv_par07 == 1 )
				cEspecie  := SE1->E1_TIPO
			Else
				cEspecie  := SE2->E2_TIPO
			Endif
			lAchouTit := .T.
			nPos   	  := 1
		Endif
		// Busca pela chave antiga
		If !lAchouTit .And. dbSeek(xFilial()+Substr(cNumtit,1,10))
			lAchouTit := .T.
			nPos   := 1
		Endif
		While !lAchouTit
			dbSetOrder(1)
			cChave650 := IIf(!Empty(cForne),cNumTit+Space(nTamParc-1)+cEspecie+SubStr(cForne,1,6),cNumTit+Space(nTamParc-1)+cEspecie)
			If !dbSeek(xFilial()+cChave650)
				nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,Len(IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO))))},nPos+1)
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					Exit
				Endif
			Else
				If mv_par07 == 2
					cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
					cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
					nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso
					// Encontre o titulo
					While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave650
						nPos := nPosEsp
						If Empty(cCgc)
							Exit
						Endif
						dbSelectArea("SA2")
						If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
							If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
								Exit
							Endif
						Endif
						dbSelectArea("SE2")
						dbSkip()
						cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
						cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
						nPos 	  := 0
					Enddo
				Endif
				Exit
			Endif
		Enddo
		If nPos == 0
			cEspecie := "   "
			cCliFor	 := '000000 00'
		Else
			cEspecie := IIF(mv_par07==1,SE1->E1_TIPO,SE2->E2_TIPO)
			cNumTit  := IIF(mv_par07==1,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
			cCliFor	 := IIF(mv_par07==1,SE1->E1_CLIENTE+" "+SE1->E1_LOJA,SE2->E2_FORNECE+" "+SE2->E2_LOJA)
		EndIF
		If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
			nLidos+=nTamDet
			Loop
		EndIf
	EndIf
	
	If ( ltrailler )
		nLidos+=nTamDet
		loop
	EndIf
	
	IF lEnd
		@ PROW()+1, 001 pSay "CANCELADO PELO OPERADOR"
		Exit
	End
	
	IF li > 58
		cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
	End
	
	// rf inicio da impressao
	
	@li,000 pSay padr(alltrim(cNumTit),15,' ')      		// No.Titulo
	
	@li,pCol()+1 pSay cEspecie      // Cliente/Fornecedor
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica codigo da ocorrencia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEB")
	If mv_par07 == 1
		cCarteira := "R"
	Else
		cCarteira := "P"
	EndIf
	If (dbSeek(cFilial+mv_par03+cOcorr+cCarteira))
		cDescr := cOcorr + "- " + Subs(SEB->EB_DESCRI,1,27)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua contagem dos SubTotais por ocorrencia  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCntOco := Ascan(aCntOco, { |X| X[1] == cOcorr})
		If nCntOco == 0
			Aadd(aCntOco,{cOcorr,Subs(SEB->EB_DESCRI,1,27),nDespes,nDescont,nAbatim,nValRec,nJuros,nMulta,nValIof,nValCc,nOutrDesp})
		Else
			aCntOco[nCntOco][DESPESAS]     +=nDespes
			aCntOco[nCntOco][DESCONTOS]    +=nDescont
			aCntOco[nCntOco][ABATIMENTOS]  +=nAbatim
			aCntOco[nCntOco][VALORRECEBIDO]+=nValRec
			aCntOco[nCntOco][JUROS]        +=nJuros
			aCntOco[nCntOco][MULTA]        +=nMulta
			aCntOco[nCntOco][VALORIOF]     +=nValIOF
			aCntOco[nCntOco][VALORCC]      +=nValCC
			aCntOco[nCntOco][OUTRDESP]     +=nOutrDesp
		Endif
		
		If SEB->EB_OCORR $ "03ü15ü16ü17ü40ü41ü42"		//Registro rejeitado
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica tabela de rejeicao   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLenRej > 0
				If dbSeek(cFilial+mv_par03+cOcorr+cCarteira+Substr(cRej,1,2))
					cDescr := cOcorr + "(" + Substr(cRej,1,2) + ;
					")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
				EndIf
				lRej := .T.
			EndIf
		EndIf
		lOcorr := .T.
	Else
		cDescr  := Space(29)
		lOcorr  := .F.
		nCntOco := Ascan(aCntOco, { |X| X[2] == "OCORRENCIA NAO ENCONTRADA"})
		If nCntOco == 0
			Aadd(aCntOco,{"00 ","OCORRENCIA NAO ENCONTRADA",nDespes,nDescont,nAbatim,nValRec,nJuros,nMulta,nValIof,nValCc,nOutrDesp})
		Else
			aCntOco[nCntOco][DESPESAS]     +=nDespes
			aCntOco[nCntOco][DESCONTOS]    +=nDescont
			aCntOco[nCntOco][ABATIMENTOS]  +=nAbatim
			aCntOco[nCntOco][VALORRECEBIDO]+=nValRec
			aCntOco[nCntOco][JUROS]        +=nJuros
			aCntOco[nCntOco][MULTA]        +=nMulta
			aCntOco[nCntOco][VALORIOF]     +=nValIOF
			aCntOco[nCntOco][VALORCC]      +=nValCC
			aCntOco[nCntOco][OUTRDESP]     +=nOutrDesp
		Endif
	Endif
	
	If mv_par07 == 1 // receber  -  cliente - rf
		dbselectarea("SA1")
		dbsetorder(01)
		SA1->(dbseek(space(02)+subst(cCliFor,1,6)+subst(cCliFor,8,2)))
		if SA1->(found())
			_nom_cl_fo := SA1->A1_NREDUZ
		else
			_nom_cl_fo := space(20)
		endif
		dbSelectArea("SE1")
	Else             // pagar    - fornecedor - rf
		dbselectarea("SA2")
		dbsetorder(01)
		SA2->(dbseek(space(02)+subst(cCliFor,1,6)+subst(cCliFor,8,2)))
		if SA2->(found())
			_nom_cl_fo := SA2->A2_NREDUZ
		else
			_nom_cl_fo := space(20)
		endif
		dbSelectArea("SE2")
	EndIf
	@li,pCol()+1 pSay cCliFor    // /Fornecedor             Ocorrencia                 Dt.Ocor.  Desp. Cobr  Vlr Descon   Vlr Abat.  Vlr Princ.    Vlr Juros  Vlr Multa    Vlr IOF  Out Cred  Dt.Cred.   Nro Titulo Bco      Consistencia"
	@li,pCol()+1 pSay subs(_nom_cl_fo,1,18)
	@li,pCol()+1 pSay Subs(cDescr,1,26)
	@li,pCol()+1 pSay dBaixa
	@li,pCol()+1 pSay nDespes  picture tm(nDespes,11)  //'@E 99999,999.99'
	@li,pCol()+1 pSay nDescont picture tm(nDescont,11) //'@E 99999,999.99'
	@li,pCol()+1 pSay nAbatim  picture tm(nAbatim,11)  //'@E 99999,999.99'
	@li,pCol()+1 pSay nValRec  picture tm(nValRec,11)	 //'@E 99999,999.99'
	@li,pCol()+1 pSay nJuros   picture tm(nJuros,11)	 //'@E 99999,999.99'
	@li,pCol()+1 pSay nMulta   picture tm(nMulta,11)	 //'@E 99999,999.99'
	If mv_par07 == 1
		@li,pCol()+1 pSay nValIof  picture tm(nValIof,9) //'@E 99,999.99'
		@li,pCol()+1 pSay nValCc   picture tm(nValCC,11)  //'@E 99999,999.99'
		@li,pCol()+2 pSay DToC(Iif(Empty(dCred),dDataBase,dCred))
		@li,pCol()+1 pSay Pad(cNossoNum,19)
	Else
		@li,pCol()+1 pSay nOutrDesp picture tm(nOutrDesp,10)	 //'@E 99999,999.99'
		@li,pCol()+1 pSay Pad(cNossoNum,19)
	EndIf
	++li
	nDespT += nDespes
	nDescT += nDescont
	nAbatT += nAbatim
	nValT  += nValRec
	nJurT  += nJuros
	nMulT  += nMulta
	nOut   += nOutrDesp
	If mv_par07 == 1
		nIOFT  += nValIOF
		nCCT   += nValCC
	EndIf
	
	IF Empty(cOcorr)
		cDescr := "OCORRENCIA NAO ENVIADA"
		lOk := ImpCons(cDescr)
	Else
		If ! lOcorr
			cDescr := "OCORRENCIA NAO ENCONTRADA"
			lOk := ImpCons(cDescr)
		End
	EndIf
	
	If dBaixa < dDataFin
		cDescr := "DATA MENOR QUE DATA FECH.FINANCEIRO"
		lOk := ImpCons(cDescr)
	Endif
	
	IF Empty(cNumTit)
		cDescr := "NUMERO TITULO NAO ENVIADO"
		lOk := ImpCons(cDescr)
	End
	
	lAchouTit := .F.
	dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
	dbSetOrder(1)
	If mv_par07 == 1
		cChave650 := cNumTit+cEspecie
	Else
		cChave650 := IIf(!Empty(cForne), cNumTit+cEspecie+SubStr(cForne,1,6), cNumTit+cEspecie+left(cclifor,6)+right(cCliFor,2))
	EndIf
	If !dbSeek(cFilial+cChave650)
		cDescr := "TITULO NAO ENCONTRADO"
		lOk := ImpCons(cDescr)
	Else
		lAchouTit := .T.
	Endif
	IF Substr(dtoc(dBaixa),1,1)=' '
		cDescr := "DATA DE BAIXA NAO ENVIADA"
		lOk := ImpCons(cDescr)
	EndIF
	
	IF Empty(cTipo)
		cDescr := "ESPECIE NAO ENVIADA"
		lOk := ImpCons(cDescr)
	Endif
	
	If Empty(cEspecie)
		cDescr := "ESPECIE NAO ENCONTRADA"
		lOk := ImpCons(cDescr)
	Endif
	
	If mv_par07 == 1 .and. lAchouTit .and. nAbatim == 0 .and. SE1->E1_SALDO > 0
		nValPadrao := nValRec-(nJuros+nMulta-nDescont)
		nTotAbat := SumAbatRec(Substr(cNumtit,1,3),Substr(cNumtit,4,6),;
		Substr(cNumtit,10,1),1,"S")
		If Round(NoRound((SE1->E1_SALDO-nTotAbat),3),2) < Round(NoRound(nValPadrao,3),2)
			cDescr := "VALOR RECEBIDO A MAIOR"
			lOk := ImpCons(cDescr)
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informa a condicao da baixa do titulo         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	a := 0
	If lOk
		If mv_par07 == 1
			If SE1->E1_SALDO = 0        
				_nBaixaOK += nValRec
				cDescr := "BAIXADO ANTERIORMENTE - TOTAL"
				lOk := ImpCons(cDescr)
			ElseIf SE1->E1_VALOR <> SE1->E1_SALDO
				_nBaixaOK += nValRec
				cDescr := "BAIXADO ANTERIORMENTE - PARCIAL"
				lOk := ImpCons(cDescr)
			End
		Else
			If SE2->E2_SALDO = 0
				_nBaixaOK += nValRec
				cDescr := "BAIXADO ANTERIORMENTE - TOTAL"
				lOk := ImpCons(cDescr)
			ElseIf SE2->E2_VALOR <> SE2->E2_SALDO
				_nBaixaOK += nValRec
				cDescr := "BAIXADO ANTERIORMENTE - PARCIAL"
				lOk := ImpCons(cDescr)
			End
		Endif
	Else
		_nBaixaNOk += nValRec

	Endif
	
	If lOk
		cDescr := "TITULO OK"
		lOk := ImpCons(cDescr)
	EndIf
	
	If nLenRej > 0
		If Len(Alltrim(cRej)) > 2
			For nCont := 3 to Len(Alltrim(cRej)) Step 2
				If lRej
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica tabela de rejeicao   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SEB")
					If dbSeek(cFilial+mv_par03+cOcorr+cCarteira+Substr(cRej,nCont,2))
						cDescr := cOcorr + "(" + Substr(cRej,nCont,2) + ;
						")" + "-" + Substr(SEB->EB_DESCMOT,1,22)
						@li,027 pSay Subs(cDescr,1,26)
						li++
					EndiF
				EndIf
			Next nCont
		EndIf
	EndIf
	If mv_par07 == 1
		dbSelectArea("SE1")
	Else
		dbSelectArea("SE2")
	EndIf
	If mv_par08 == 1
		nLidos+=nTamDet
	Endif
EndDO

IF li != 80
	Li+=2
	
	If (Len(aCntOco) + Li) > 55
		Cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Subtotais por ocorrencia  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ li,000 pSay "SUBTOTAIS DO RELATORIO"
	Li+=2
	For x :=1 to Len(aCntOco)
		If(x <= 10)
			@li,000 pSay aCntOco[x][1] + Substr(aCntOco[x][2],1,30)
			@li,086 pSay (aCntOco[x][DESPESAS])      picture Tm((aCntOco[x][03]),12) //'@E 9,999,999,999.99'  // 63
			@li,pCol()+0 pSay (aCntOco[x][DESCONTOS])     picture Tm((aCntOco[x][04]),12) //'@E 9,999,999,999.99'  // 76
			@li,pCol()+0  pSay (aCntOco[x][ABATIMENTOS])   picture Tm((aCntOco[x][05]),12) //'@E 9,999,999,999.99'  // 89
			@li,pCol()+0  pSay (aCntOco[x][VALORRECEBIDO]) picture Tm((aCntOco[x][06]),12) //'@E 9,999,999,999.99'  // 102
			@li,pCol()+0  pSay (aCntOco[x][JUROS])         picture Tm((aCntOco[x][07]),12) //'@E 9,999,999,999.99'  // 115
			@li,pCol()+0  pSay (aCntOco[x][MULTA])         picture Tm((aCntOco[x][08]),12) //'@E 9,999,999,999.99'  // 128
			If mv_par07 == 1
				@li,pCol()+0  pSay (aCntOco[x][VALORIOF])   picture Tm((aCntOco[x][09]),09) //'@E 9,999,999,999.99'  // 141
				@li,pCol()+0  pSay (aCntOco[x][VALORCC])    picture Tm((aCntOco[x][10]),12) //'@E 9,999,999,999.99'  // 151
			Else
				@li,pCol()+1 pSay (aCntOco[x][OUTRDESP])   picture Tm((aCntOco[x][11]),10) //'@E 9,999,999,999.99'  // 140
			Endif
		Else
			Exit
		Endif
		Li ++
	Next
	Li+=2
	
	If (Len(aCntOco) + Li) > 58
		Cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Totais                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@li,000 pSay  "TOTAIS DO RELATORIO"
	@li,086 pSay nDespT      	  picture TM(nDespT,12) //'@E 9,999,999,999.99'
	@li,pCol()+0 pSay nDescT      picture TM(nDescT,12) //'@E 9,999,999,999.99'
	@li,pCol()+0 pSay nAbatT      picture TM(nAbatT,12) //'@E 9,999,999,999.99'
	@li,pCol()+0 pSay nValT       picture Tm(nValT,12)  //'@E 9,999,999,999.99'
	@li,pCol()+0 pSay nJurT       picture Tm(nJurT,12)  //'@E 9,999,999,999.99'
	@li,pCol()+0 pSay nMulT       picture Tm(nMult,12)  //'@E 9,999,999,999.99'
	If mv_par07 == 1
		@li,pCol()+0 pSay nIofT   picture TM(nIofT,09) //'@E 9,999,999,999.99'
		@li,pCol()+0 pSay nCcT    picture TM(nCcT,12)  //'@E 9,999,999,999.99'
	Else
		@li,pCol()+1 pSay nOut     	  picture TM(nOut,10)  //'@E 9,999,999,999.99'
	EndIf

	@li+=2,000 pSay  "Totais de Titulos ok                                                                                                      " +tran(_nBaixaOK  ,      Tm(nValT,12))
	@li+=1,000 pSay  "Totais de Titulos com problemas                                                                                           " +tran(_nBaixaNOK ,      Tm(nValT,12))

	roda(cbcont,cbtxt,tamanho)
EndIF


fClose(nHdlBco)
fClose(nHdlConf)

Set Device TO Screen
dbSelectArea("SEF")
dbSetOrder(1)
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	Ourspool(wnrel)
End
MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ IMPCONS  ³ Autor ³ Elaine F. T. Beraldo  ³ Data ³ 27/06/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impress„o da Consistencia                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ IMPCONS(texto)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR650.PRG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ImpCons(cTexto)
/////////////////////////////
If mv_par07 == 1
	@ li,199  pSay cTexto
Else
	@ li,pCol()+1 pSay Pad(cTexto,31)
EndIf
li++
Return .F.