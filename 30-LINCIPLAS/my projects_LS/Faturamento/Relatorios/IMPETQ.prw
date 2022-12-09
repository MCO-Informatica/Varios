#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPETQ   º Autor ³ THIAGO QUEIROZ     º Data ³  24/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de Etiquetas LINCIPLAS.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LINCIPLAS                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IMPETQ()
Local cDesc1        := "Este programa tem como objetivo imprimir Etiquetas  "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Etiquetas"
Local cPict         := ""
Local titulo        := "Etiquetas"
Local nLin          := 81
Local Cabec1        := "Etiquetas"
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "IMPETQ"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "ETIVOL"
Private cAlias      := "SF2"
Private _cPerg      := "ETIVOL"

Private _cA1NumSer  := Space(06)

ValidPerg()

Pergunte(_cPerg,.F.)
dbSelectArea("SF2")
dbSetOrder(1)          // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cAlias,wnrel,_cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cAlias)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR02 == 1
	RptStatus({|| Run01Report(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Else
	If MV_PAR02 == 2
		RptStatus({|| Run02Report(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else
	    If MV_PAR02 == 3
		    RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	    EndIf
	EndIf
EndIf

dbSelectArea("SA1")
RecLock("SA1",.F.)
SA1->A1_XNUMSER := _cA1NumSer
MsUnlock()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local _cDoc   := "000000000"
Local _cSerie := ""
Local _nI     := 0
Local _lDoc   := .T.

For _nI := 1  To  Len(AllTrim(MV_PAR01))
	If _lDoc
		If Substr(AllTrim(MV_PAR01),_nI,1) <> "-"
			_cDoc := Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
		Else
			_lDoc := .F.
		EndIf
	Else
		_cSerie += Substr(AllTrim(MV_PAR01),_nI,1)
	EndIf
Next

_cSerie := _cSerie+Space(3-Len(_cSerie))

dbSelectArea("SF2")
dbSetOrder(1)              // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
dbSeek(xFilial("SF2")+_cDoc+_cSerie,.T.)
If Eof()
	Alert("Numero de Nota + Serie Não Encontrada no Sistema...")
	Return
EndIf
//
//
dbSelectArea("SA1")
dbSetOrder(1)         // A1_FILIAL+A1_COD+A1_LOJA
If !(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	Alert("Cliente "+SF2->F2_CLIENTE+"-"+SF2->F2_LOJA+" Não Encontrado...")
	Return
Else
	_cA1NumSer := SA1->A1_XNUMSER
EndIf
//
//
Private cPath   := GetSrvProfString("Startpath","") + "\"

Private oPrn
Private oFtNegrito 	:= TFont():New("Verdana LT 47 LightCn" ,09,09,,.T.,,,,.T.,.F.)
Private oFtNormal	:= TFont():New("Verdana LT 47 LightCn" ,10,10,,.F.,,,,.T.,.F.)
Private oFtMedio 	:= TFont():New("Verdana LT 47 LightCn" ,10,10,,.F.,,,,.T.,.F.)
Private oFtMedia 	:= TFont():New("Verdana LT 47 LightCn" ,10,10,,.T.,,,,.T.,.F.)
Private oFtPequeno	:= TFont():New("Verdana LT 47 LightCn" ,09,09,,.T.,,,,.T.,.F.)
Private oFtPPequeno := TFont():New("Verdana LT 47 LightCn" ,08,08,,.F.,,,,.T.,.F.)
Private oFtGrande	:= TFont():New("Verdana LT 47 LightCn" ,15,15,,.T.,,,,.T.,.F.)
Private oFtGigante  := TFont():New("Verdana LT 47 LightCn" ,18,18,,.T.,,,,.T.,.F.)
Private oFtBig      := TFont():New("Verdana LT 47 LightCn" ,35,35,,.T.,,,,.T.,.F.)

Private oFont       := TFont():New("Verdana LT 47 LightCn" ,10,10,,.F.,,,,.T.,.F.)

oPrn:=TMSPrinter():New()
oPrn:setPaperSize(9)
oPrn:SetPortrait()
oPrn:Setup()

Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE == _cDoc+_cSerie

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	dbSelectArea("SD2")
	dbSetOrder(3)                    // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.)
	Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		dbSelectArea("SA4")
		dbSetOrder(1)
		dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
		_cTransp := AllTrim(SA4->A4_NOME)

		dbSelectArea("SB1")
		dbSetOrder(1)
		If !(dbSeek(xFilial("SB1")+SD2->D2_COD))
			Alert("Produto "+SD2->D2_COD+" Não Encontrado...")
			Exit
		EndIf

        oPrn:StartPage()
        
        oPrn:Box(0030, 0050, 1600, 2300)    // Linha Inicial, Coluna Inicial, Linha Final, Coluna Final
        oPrn:Box(0030, 0050, 0120, 0220)    // FROM
        oPrn:Box(0030, 0050, 0120, 1020)    // LINCIPLAS
        oPrn:Box(0030, 0050, 0120, 1200)    // TO
        oPrn:Box(0030, 0050, 0120, 2300)    // EM BRANCO

        oPrn:Box(0120, 0050, 0350, 1020)    // COD FORNEC.
        oPrn:Box(0350, 0050, 0450, 0500)    // N NOTA FISCAL
        oPrn:Box(0350, 0500, 0450, 1020)    // NUMERO DA NOTA E SERIE
        oPrn:Box(0450, 0050, 0550, 1020)    // CODIGO DE BARRAS COM NUMERO DA NOTA E SERIE

        oPrn:Box(0550, 0050, 1600, 2300)
        oPrn:Box(0550, 0050, 0700, 1600)   // PART NAME
        oPrn:Box(0550, 1600, 0650, 2300)   // CONTROL OF QUALITY

        oPrn:Box(0700, 0050, 0950, 1600)   // PART NUMBER
        oPrn:Box(0950, 0050, 1300, 2300)   // QUANTIDADE
        oPrn:Box(0950, 0700, 1300, 2300)   // UNID.MEDIDA
        oPrn:Box(0950, 1200, 1300, 2300)   // LOTE DE FABRICACAO

        oPrn:Box(1300, 0050, 1600, 2300)   // No.SERIE SEQUENCIAL
        oPrn:Box(1300, 0900, 1600, 2300)   // EMBALAGEM
        oPrn:Box(1300, 1600, 1600, 2300)   // DATE DE EXPEDICAO

        oPrn:Say(0070, 0060, "FROM: "                      , oFtNormal )
        oPrn:Say(0060, 0250, "LINCIPLAS IND. E COM."       , oFtGrande )
        oPrn:Say(0070, 1050, "TO: "                        , oFtNormal )

        oPrn:SayBitmap(0160,1060,cPath+"logomae.BMP",0375,0315)
        oPrn:Say(0150, 1450, "IRAMEC AUTOPEÇAS LTDA."      , oFtGrande )
        oPrn:Say(0210, 1450, "AV. EURICO AMBROGI DOS SANTOS, No. 1500"  , oFtNormal )
        oPrn:Say(0260, 1450, "BAIRRO: PIRACANGAGUA"                     , oFtNormal )
        oPrn:Say(0310, 1450, "CEP: 12042-010"                           , oFtNormal )
        oPrn:Say(0360, 1450, "TAUBATÉ - SPA"                            , oFtNormal )
        oPrn:Say(0410, 1450, "BRASIL"                                   , oFtNormal )

        oPrn:Say(0450, 1980, "Rev.3.0 - 11/08/08"                       , oFtPequeno)

        oPrn:Say(0150, 0100, "CÓD.FORNEC.(Z):"             , oFtNormal )
        oPrn:Say(0150, 0550, "00"+SA1->A1_XCODSA2          , oFtGigante)
        MSBAR3("CODE128",1.9,1.5,"00"+SA1->A1_XCODSA2,oPrn,.F.,Nil,.T.,0.048,0.80,.F.,Nil,"A",.F.)
        
        oPrn:Say(0380, 0100, "No.NOTA FISCAL (N):"         , oFtNormal )
        oPrn:Say(0370, 0550, AllTrim(MV_PAR01)             , oFtGigante)
        MSBAR3("CODE128",3.9,1.8,AllTrim(MV_PAR01),oPrn,.F.,Nil,.T.,0.040,0.60,.F.,Nil,"A",.F.)
        
        oPrn:Say(0580, 1700, "CONTROL OF QUALITY"          , oFtNormal )

        oPrn:Say(0600, 0100, "PART NAME:"                  , oFtNormal )
        oPrn:Say(0590, 0350, ALLTRIM(SB1->B1_DESC)         , oFtGrande)
        
        oPrn:Say(0850, 0100, "PART NUMBER (P):"            , oFtNormal )
        oPrn:Say(0690, 0560, AllTrim(SB1->B1_LCODCLI)      , oFtBig)
        MSBAR3("CODE128",7.0,4.3,AllTrim(SB1->B1_LCODCLI),oPrn,.F.,Nil,.T.,0.040,0.80,.F.,Nil,"A",.F.)

        oPrn:Say(1000, 0180, "QUANTIDADE (Q):"             , oFtNormal )
        oPrn:Say(1000, 0850, "UNID.MED.:"                  , oFtNormal )
        oPrn:Say(1000, 1500, "LOTE DE FABRICAÇÃO (L)"      , oFtNormal )

        oPrn:Say(1070, 0180, STRZERO(SD2->D2_QUANT,6)      , oFtGigante)
        MSBAR3("CODE128",10.0,1.5,STRZERO(SD2->D2_QUANT,6),oPrn,.F.,Nil,.T.,0.025,0.70,.F.,Nil,"A",.F.)
        
        oPrn:Say(1150, 0880,"PÇS"                          , oFtGigante)

        oPrn:Say(1070, 1500, AllTrim(MV_PAR04)             , oFtGigante)
        MSBAR3("CODE128",09.8,11.5,AllTrim(MV_PAR04),oPrn,.F.,Nil,.T.,0.040,0.80,.F.,Nil,"A",.F.)

        oPrn:Say(1350, 0180, "No.SÉRIE SEQUENCIAL (S)"     , oFtNormal )
        oPrn:Say(1350, 1150, "EMBALAGEM"                   , oFtNormal )
        oPrn:Say(1350, 1800, "DATA DE EXPEDIÇÃO"           , oFtNormal )

		_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
        oPrn:Say(1400, 0280, AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer)    , oFtGigante)
        MSBAR3("CODE128",12.5,1.2,AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer),oPrn,.F.,Nil,.T.,0.035,0.80,.F.,Nil,"A",.F.)

        oPrn:Say(1500, 1150, "PALLET"                      , oFtGigante)
        oPrn:Say(1500, 1800, Dtoc(SD2->D2_EMISSAO)         , oFtGigante)
        
		dbSelectArea("SD2")
		dbSkip()
//
//      SEGUNDA ETIQUETA DA PAGINA.
//
		dbSelectArea("SB1")
		dbSetOrder(1)
		If !(dbSeek(xFilial("SB1")+SD2->D2_COD))
			Alert("Produto "+SD2->D2_COD+" Não Encontrado...")
			Exit
		EndIf

        oPrn:Box(1780, 0050, 3350, 2300)    // Linha Inicial, Coluna Inicial, Linha Final, Coluna Final
        oPrn:Box(1780, 0050, 1870, 0220)    // FROM
        oPrn:Box(1780, 0050, 1870, 1020)    // LINCIPLAS
        oPrn:Box(1780, 0050, 1870, 1200)    // TO
        oPrn:Box(1780, 0050, 1870, 2300)    // EM BRANCO

        oPrn:Box(1870, 0050, 2100, 1020)    // COD FORNEC.
        oPrn:Box(2100, 0050, 2200, 0500)    // N NOTA FISCAL
        oPrn:Box(2100, 0500, 2200, 1020)    // NUMERO DA NOTA E SERIE
        oPrn:Box(2200, 0050, 2300, 1020)    // CODIGO DE BARRAS COM NUMERO DA NOTA E SERIE

        oPrn:Box(2300, 0050, 3350, 2300)
        oPrn:Box(2300, 0050, 2450, 1600)   // PART NAME
        oPrn:Box(2300, 1600, 2400, 2300)   // CONTROL OF QUALITY

        oPrn:Box(2450, 0050, 2700, 1600)   // PART NUMBER
        oPrn:Box(2700, 0050, 3050, 2300)   // QUANTIDADE
        oPrn:Box(2700, 0700, 3050, 2300)   // UNID.MEDIDA
        oPrn:Box(2700, 1200, 3050, 2300)   // LOTE DE FABRICACAO

        oPrn:Box(3050, 0050, 3350, 2300)   // No.SERIE SEQUENCIAL
        oPrn:Box(3050, 0900, 3350, 2300)   // EMBALAGEM
        oPrn:Box(3050, 1600, 3350, 2300)   // DATE DE EXPEDICAO

        oPrn:Say(1820, 0060, "FROM: "                      , oFtNormal )
        oPrn:Say(1810, 0250, "LINCIPLAS IND. E COM."       , oFtGrande )
        oPrn:Say(1820, 1050, "TO: "                        , oFtNormal )

        oPrn:SayBitmap(1910,1060,cPath+"logomae.BMP",0375,0315)
        oPrn:Say(1900, 1450, "IRAMEC AUTOPEÇAS LTDA."      , oFtGrande )
        oPrn:Say(1960, 1450, "AV. EURICO AMBROGI DOS SANTOS, No. 1500"  , oFtNormal )
        oPrn:Say(2010, 1450, "BAIRRO: PIRACANGAGUA"                     , oFtNormal )
        oPrn:Say(2060, 1450, "CEP: 12042-010"                           , oFtNormal )
        oPrn:Say(2110, 1450, "TAUBATÉ - SPA"                            , oFtNormal )
        oPrn:Say(2160, 1450, "BRASIL"                                   , oFtNormal )

        oPrn:Say(2200, 1980, "Rev.3.0 - 11/08/08"                       , oFtPequeno)

        oPrn:Say(1900, 0100, "CÓD.FORNEC.(Z):"             , oFtNormal )
        oPrn:Say(1900, 0550, "00"+SA1->A1_XCODSA2          , oFtGigante)
        MSBAR3("CODE128",16.7,1.5,"00"+SA1->A1_XCODSA2,oPrn,.F.,Nil,.T.,0.048,0.80,.F.,Nil,"A",.F.)
        
        oPrn:Say(2130, 0100, "No.NOTA FISCAL (N):"         , oFtNormal )
        oPrn:Say(2120, 0550, AllTrim(MV_PAR01)             , oFtGigante)
        MSBAR3("CODE128",18.7,1.8,AllTrim(MV_PAR01),oPrn,.F.,Nil,.T.,0.040,0.60,.F.,Nil,"A",.F.)
        
        oPrn:Say(2330, 1700, "CONTROL OF QUALITY"          , oFtNormal )

        oPrn:Say(2350, 0100, "PART NAME:"                  , oFtNormal )
        oPrn:Say(2340, 0350, ALLTRIM(SB1->B1_DESC)         , oFtGrande)
        
        oPrn:Say(2600, 0100, "PART NUMBER (P):"            , oFtNormal )
        oPrn:Say(2440, 0560, AllTrim(SB1->B1_LCODCLI)      , oFtBig)
        MSBAR3("CODE128",21.8,4.3,AllTrim(SB1->B1_LCODCLI),oPrn,.F.,Nil,.T.,0.040,0.80,.F.,Nil,"A",.F.)

        oPrn:Say(2750, 0180, "QUANTIDADE (Q):"             , oFtNormal )
        oPrn:Say(2750, 0850, "UNID.MED.:"                  , oFtNormal )
        oPrn:Say(2750, 1500, "LOTE DE FABRICAÇÃO (L)"      , oFtNormal )

        oPrn:Say(2820, 0180, STRZERO(SD2->D2_QUANT,6)      , oFtGigante)
        MSBAR3("CODE128",24.8,1.5,STRZERO(SD2->D2_QUANT,6),oPrn,.F.,Nil,.T.,0.025,0.70,.F.,Nil,"A",.F.)
        
        oPrn:Say(2900, 0880,"PÇS"                          , oFtGigante)

        oPrn:Say(2820, 1500, AllTrim(MV_PAR04)             , oFtGigante)
        MSBAR3("CODE128",24.6,11.5,AllTrim(MV_PAR04),oPrn,.F.,Nil,.T.,0.040,0.80,.F.,Nil,"A",.F.)

        oPrn:Say(3100, 0180, "No.SÉRIE SEQUENCIAL (S)"     , oFtNormal )
        oPrn:Say(3100, 1150, "EMBALAGEM"                   , oFtNormal )
        oPrn:Say(3100, 1800, "DATA DE EXPEDIÇÃO"           , oFtNormal )

		_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
        oPrn:Say(3150, 0280, AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer)    , oFtGigante)
        MSBAR3("CODE128",27.3,1.2,AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer),oPrn,.F.,Nil,.T.,0.035,0.80,.F.,Nil,"A",.F.)

        oPrn:Say(3250, 1150, "PALLET"                      , oFtGigante)
        oPrn:Say(3250, 1800, Dtoc(SD2->D2_EMISSAO)         , oFtGigante)
        
        oPrn:EndPage()
		dbSelectArea("SD2")
		dbSkip()
	EndDo

	dbSelectArea("SF2")
	dbSkip()
EndDo

oPrn:Preview()
Return
//
//
/*/
Funcao      RUN02REPORT
Autor		AP6 IDE
Data		02/09/17
Descricao	Funcao auxiliar chamada pela RPTSTATUS. A funcao RPT02STATUS monta a janela com a regua de processamento.
Uso			Programa principal
/*/
Static Function Run01Report(Cabec1,Cabec2,Titulo,nLin)
Local _cDoc   := "000000000"
Local _cSerie := ""
Local _nI     := 0
Local _lDoc   := .T.

Private _nQtdEmb   := 0
Private _nQtdEtq   := 0
Private _nResto    := 0
Private _nQtdVen   := 0

For _nI := 1  To  Len(AllTrim(MV_PAR01))
	If _lDoc
		If Substr(AllTrim(MV_PAR01),_nI,1) <> "-"
			_cDoc := Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
		Else
			_lDoc := .F.
		EndIf
	Else
		_cSerie += Substr(AllTrim(MV_PAR01),_nI,1)
	EndIf
Next

_cSerie := _cSerie+Space(3-Len(_cSerie))

dbSelectArea("SF2")
dbSetOrder(1)              // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
dbSeek(xFilial("SF2")+_cDoc+_cSerie,.T.)
If Eof()
	Alert("Numero de Nota + Serie Não Encontrada no Sistema...")
	Return
EndIf
//
//
dbSelectArea("SA1")
dbSetOrder(1)         // A1_FILIAL+A1_COD+A1_LOJA
If !(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	Alert("Cliente "+SF2->F2_CLIENTE+"-"+SF2->F2_LOJA+" Não Encontrado...")
	Return
Else
	_cA1NumSer := SA1->A1_XNUMSER
EndIf
//
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())
MSCBPRINTER("S600","LPT1",,80,.F.,,,,)
MSCBCHKSTATUS(.F.) //.T. -- seta o controle de status do sistema com a impressora

Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE == _cDoc+_cSerie
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	dbSelectArea("SD2")
	dbSetOrder(3)                    // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.)
	Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		dbSelectArea("SA4")
		dbSetOrder(1)
		dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
		_cTransp := AllTrim(SA4->A4_NOME)
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			_nQtdEmb := SB1->B1_XQTDETQ
		Else
			Alert("Produto "+SD2->D2_COD+" Não Encontrado...")
			Exit
		EndIf
		
		If _nQtdEmb <= 0
			_nQtdEtq := 1
			_nQtdVen := SD2->D2_QUANT
			_nResto  := 0
		Else
			If SD2->D2_QUANT <= _nQtdEmb
				_nQtdEtq := 1
				_nQtdVen := SD2->D2_QUANT
				_nResto  := 0
			Else
				_nQtdEtq := Int(SD2->D2_QUANT / _nQtdEmb)
				If Mod(SD2->D2_QUANT,_nQtdEmb) > 0
					_nResto  := SD2->D2_QUANT - (_nQtdEtq * _nQtdEmb)
					_nQtdEtq := _nQtdEtq + 1
				Else
				    _nResto  := 0
				EndIf
				_nQtdVen := _nQtdEmb
			EndIf
		EndIf
		
		For _nI := 1  To  _nQtdEtq
			If _nI == _nQtdEtq .And. _nResto > 0
				_nQtdVen := _nResto
			EndIf
			//      MSCBLOADGRF("LOGOE1.PCX")
			MSCBBEGIN(1,6) // ,31.5)
			MSCBBOX(001,002,100,091,006) // COLUNA1, LINHA1, COLUNA2, LINHA2, ESPESSURA
			
			MSCBSAY(003,004,"FROM:"							    ,"N","A","015,008")
			If SM0->M0_CODFIL == "01" .Or. SM0->M0_CODFIL == "04"
				MSCBSAY(011,004,"H.SILVA INJECAO TERMOPLAS. (LINCIPLAS)" ,"N","B","019")
			Else
				MSCBSAY(011,004,"LINEAR - GRU / SP"               ,"N","B","019")
			EndIf
			MSCBLineH(001,008,100,005,"B") // COLUNA1, LINHA1, COLUNA2 // LINHA ABAIXO DO FROM
			// ------------------------------------------------------------
			MSCBSAY(003,010,"COD FORN (Z):"					    ,"N","A","015,008")
			MSCBSAY(040,010,"00"+SA1->A1_XCODSA2	            ,"N","B","017,008")
			MSCBSAYBAR(006,015,"00"+SA1->A1_XCODSA2,"MB07","C",4.36,.F.,.F.,.F.,,3,2)
			MSCBLineH(001,023,056,005,"B")
			MSCBLineV(056,008,037,005,"B")
			// ------------------------------------------------------------
			MSCBSAY(058,009,"TO:"							    ,"N","A","015,008") // DESTINO
			
			//      MSCBGRAFIC(058,013,"LOGOE1")
			
			//		MSCBSAY(058,013,"LOGO TO"						    ,"N","A","015,008") // LOGO DESTINO
			MSCBSAY(058,025,ALLTRIM(SUBSTR(SA1->A1_END,01,22))  ,"N","A","015,008") // ENDEREÇO DE DESTINO
			MSCBSAY(058,028,ALLTRIM(SUBSTR(SA1->A1_END,23,12))+" - "+ALLTRIM(SA1->A1_BAIRRO)	,"N","A","015,008") // ENDEREÇO DE DESTINO
			MSCBSAY(058,031,"CEP: " + ALLTRIM(SUBSTR(SA1->A1_CEP,1,5))+"-"+ALLTRIM(SUBSTR(SA1->A1_CEP,6,3))	    ,"N","A","015,008") // ENDEREÇO DE DESTINO
			MSCBSAY(058,034,ALLTRIM(SA1->A1_MUN)+" - "+SA1->A1_EST+" - BRASIL"	,"N","A","015,008") // ENDEREÇO DE DESTINO
			// ------------------------------------------------------------
			MSCBSAY(003,025,"N.NOTA FISCAL (N):"			    ,"N","A","015,008")
			MSCBSAY(045,025,AllTrim(MV_PAR01)                   ,"N","B","017,008")
			MSCBSAYBAR(006,029,ALLTRIM(MV_PAR01),"MB07","C",6.36,.F.,.F.,.F.,,3,2)
			MSCBLineH(001,037,100,005,"B")
			// ------------------------------------------------------------
			MSCBSAY(003,038,"PART NAME:"					    ,"N","A","015,008")
			MSCBSAY(025,038,ALLTRIM(SB1->B1_DESC)			    ,"N","B","017")
			MSCBLineH(001,041,100,005,"B")
			// ------------------------------------------------------------
			MSCBSAY(003,043,"PART NUMBER (P):"				    ,"N","A","015,008")
			MSCBSAY(040,043,AllTrim(SB1->B1_LCODCLI)            ,"N","B","025,012")
			MSCBSAYBAR(008,048,AllTrim(SB1->B1_LCODCLI),"MB07","C",6.36,.F.,.F.,.F.,,3,3)
			MSCBLineH(001,056,100,005,"B")
			// ------------------------------------------------------------
			MSCBSAY(006,058,"QUANTIDADE (Q):"					,"N","A","015,008")
			MSCBSAY(038,058,"UNID.MEDIDA:"					    ,"N","A","015,008")
			MSCBSAY(058,058,"LOTE FABRICACAO (L):"			    ,"N","A","015,008")
			MSCBLineH(001,061,100,005,"B")
			
			MSCBSAY(015,062,STRZERO(_nQtdVen,5)		        	,"N","B","023")
			MSCBSAYBAR(006,066,STRZERO(_nQtdVen,5),"MB07","C",7.36,.F.,.F.,.F.,,2,1)
			MSCBLineV(036,056,075,005,"B")
			
			MSCBSAY(041,066,"PCS" /*SB1->B1_UM*/			    ,"N","B","020,012")
			MSCBLineV(056,056,075,005,"B")
			
			MSCBSAY(062,062,AllTrim(MV_PAR04)			        ,"N","B","023")
			MSCBSAYBAR(059,066,AllTrim(MV_PAR04),"MB07","C",7.36,.F.,.F.,.F.,,2,1)
			MSCBLineH(001,075,100,005,"B")
			// ------------------------------------------------------------
			MSCBLineH(001,075,100,005,"B")
			// ------------------------------------------------------------
			MSCBSAY(003,076,"N.SERIE SEQUENCIAL (S):"		    ,"N","A","015,008")
			_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
			MSCBSAY(010,079,"00"+AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer) ,"N","B","023")
			MSCBSAYBAR(003,083,"00"+AllTrim(SA1->A1_XCODSA2)+_cA1NumSer,"MB07","C",6.36,.F.,.F.,.F.,,2,1)
			
			MSCBLineV(052,075,091,005,"B")
			MSCBSAY(055,077,"PACKING:"						    ,"N","A","015,008")
			MSCBSAY(054,084,ALLTRIM(SB1->B1_XMODCX)	     		,"N","B","020")
			MSCBLineV(070,075,091,005,"B")
			MSCBSAY(072,077,"DATA EXPEDICAO:"					,"N","A","015,008")
			MSCBSAY(072,084,DTOC(SF2->F2_EMISSAO)			    ,"N","B","020")
			
			MSCBEND()
		Next
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	dbSelectArea("SF2")
	dbSkip()
EndDo

MSCBCLOSEPRINTER()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If aReturn[5]==1
//	dbCommitAll()
//	SET PRINTER TO
//	OurSpool(wnrel)
//Endif

//MS_FLUSH()

Return
//
// Funcao       RUN02REPORT
// Autor		CARLOS N. PUERTA - DevStudio
// Data		    02/09/2017
// Descricao	Funcao auxiliar chamada pela RPTSTATUS. A funcao RPT02STATUS monta a janela com a regua de processamento.
// Uso			Programa principal
//
Static Function Run02Report(Cabec1,Cabec2,Titulo,nLin)
Local _cDoc   := "000000000"
Local _cSerie := ""
Local _nI     := 0
Local _lDoc   := .T.

Private _nQtdEmb   := 0
Private _nQtdEtq   := 0
Private _nResto    := 0
Private _nQtdVen   := 0

Private _nLote     := 1
Private _cLote01   := ""
Private _cLote02   := ""

For _nI := 1  To  Len(AllTrim(MV_PAR01))
	If _lDoc
		If Substr(AllTrim(MV_PAR01),_nI,1) <> "-"
			_cDoc := Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
		Else
			_lDoc := .F.
		EndIf
	Else
		_cSerie += Substr(AllTrim(MV_PAR01),_nI,1)
	EndIf
Next

_cSerie := _cSerie+Space(3-Len(_cSerie))

dbSelectArea("SF2")
dbSetOrder(1)              // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
dbSeek(xFilial("SF2")+_cDoc+_cSerie,.T.)
If Eof()
	Alert("Numero de Nota + Serie Não Encontrada no Sistema...")
	Return
EndIf
//
//
For _nI := 1  To  Len(AllTrim(MV_PAR04))
	If Substr(AllTrim(MV_PAR04),_nI,1) <> "/"
		If _nLote == 1 .Or. _nLote == 2
			_cLote01 := _cLote01 + Substr(AllTrim(MV_PAR04),_nI,1)
		Else
			If _nLote == 3 .Or. _nLote == 4
				_cLote02 := _cLote02 + Substr(AllTrim(MV_PAR04),_nI,1)
			Else
				Exit
			EndIf
		EndIf
	Else
		If _nLote == 1
			_cLote01 := AllTrim(_cLote01) + " / "
		Else
			If _nLote == 3
				_cLote02 := AllTrim(_cLote02) + " / "
			EndIf
		EndIf
		_nLote++
	EndIf
Next
//
//
dbSelectArea("SA1")
dbSetOrder(1)         // A1_FILIAL+A1_COD+A1_LOJA
If !(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	Alert("Cliente "+SF2->F2_CLIENTE+"-"+SF2->F2_LOJA+" Não Encontrado...")
	Return
Else
	_cA1NumSer := SA1->A1_XNUMSER
EndIf
//
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())
MSCBPRINTER("S600","LPT1",,,.F.,,,,,,)
MSCBCHKSTATUS(.F.)                             //.T. -- seta o controle de status do sistema com a impressora

Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE == _cDoc+_cSerie
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	dbSelectArea("SD2")
	dbSetOrder(3)                    // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.)
	Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SD2->D2_COD)
			_cB1LCODCLI := ""
			For _nI := 1  To  Len(AllTrim(SB1->B1_LCODCLI))
				If Substr(AllTrim(SB1->B1_LCODCLI),_nI,1) $ "0123456789"
					_cB1LCODCLI += Substr(AllTrim(SB1->B1_LCODCLI),_nI,1)
				EndIf
			Next
			_nQtdEmb := SB1->B1_XQTDETQ
		Else
			Alert("Produto "+SD2->D2_COD+" Não Encontrado...")
			Exit
		EndIf
		
		If _nQtdEmb <= 0
			_nQtdEtq := 1
			_nQtdVen := SD2->D2_QUANT
			_nResto  := 0
		Else
			If SD2->D2_QUANT <= _nQtdEmb
				_nQtdEtq := 1
				_nQtdVen := SD2->D2_QUANT
				_nResto  := 0
			Else
				_nQtdEtq := Int(SD2->D2_QUANT / _nQtdEmb)
				If Mod(SD2->D2_QUANT,_nQtdEmb) > 0
					_nResto  := SD2->D2_QUANT - (_nQtdEtq * _nQtdEmb)
					_nQtdEtq := _nQtdEtq + 1
				Else
				    _nResto  := 0
				EndIf
				_nQtdVen := _nQtdEmb
			EndIf
		EndIf
		
		For _nI := 1  To  _nQtdEtq
			If _nI == _nQtdEtq .And. _nResto > 0
				_nQtdVen := _nResto
			EndIf
			MSCBBEGIN(1,6)  // ,220)
			MSCBLineV(015,008,212,06,"B")
			MSCBLineV(088,008,212,06,"B")
			MSCBLineH(015,008,088,06,"B")
			MSCBLineH(015,212,088,06,"B")
			
			MSCBSAY(084,010,"CLIENTE"						     ,"R","B","016")
			MSCBSAY(083,030,ALLTRIM(SA1->A1_NREDUZ)       	     ,"R","B","028")
			MSCBSAY(084,075,"DOCA"                               ,"R","B","016")
			MSCBSAY(083,088,"DOCA 6"                             ,"R","B","028")
			MSCBSAY(084,120,"EXPEDIDOR"                          ,"R","B","016")
			If SM0->M0_CODFIL == "01" .Or. SM0->M0_CODFIL == "04"
				MSCBSAY(083,145,"H SILVA - GRU / SP"             ,"R","B","028")
			Else
				MSCBSAY(083,145,"LINEAR - GRU / SP"              ,"R","B","028")
			EndIf
			MSCBLineH(082,072,088,06,"B")
			MSCBLineH(082,118,088,06,"B")
			
			MSCBLineV(082,008,212,06,"B")
			MSCBSAY(078,010,"NUMERO NOTA FISCAL (N)"		     ,"R","B","016")
			MSCBBOX(077,077,081,094,17,"B")
			MSCBSAY(078,078,"N"+AllTrim(MV_PAR01)        	     ,"R","B","020",.T.)
			
			MSCBSAY(070,015,AllTrim(MV_PAR01)            	     ,"R","B","023")
			MSCBSAYBAR(070,040,AllTrim(MV_PAR01)                 ,"R","MB07",7.36,.F.,.F.,.F.,,2,1)
			MSCBLineH(068,098,082,06,"B")
			
			MSCBSAY(078,100,"ENDERECO DO CLIENTE"                ,"R","B","016")
			MSCBSAY(070,100,AllTrim(SA1->A1_END)+" - "+AllTrim(SA1->A1_BAIRRO)+" / "+AllTrim(SA1->A1_MUN)+" / "+SA1->A1_EST        ,"R","B","027")
			
			MSCBLineV(068,008,212,06,"B")
			MSCBSAY(063,010,"REFERENCIA DO CLIENTE (P)"		     ,"R","B","016")
			
			MSCBBOX(062,071,067,096,20,"B")
			MSCBSAY(063,072,"P"+ALLTRIM(_cB1LCODCLI)           	 ,"R","B","023",.T.)
			
			MSCBSAY(057,025,ALLTRIM(_cB1LCODCLI)                 ,"R","B","030,030")
			MSCBSAYBAR(047,025,ALLTRIM(_cB1LCODCLI)              ,"R","MB07",7.86,.F.,.F.,.F.,,2,1)
			MSCBLineH(045,098,082,06,"B")
			
			MSCBSAY(063,100,"PESO NETO"                          ,"R","B","016")
			MSCBSAY(063,125,Str((SB1->B1_PESBRU*_nQtdVen),10,3)  ,"R","B","023")
			MSCBLineV(060,098,150,06,"B")
			
			MSCBSAY(055,100,"PESO BRUTO"                         ,"R","B","016")
			MSCBSAY(055,125,Str((SB1->B1_PESBRU*_nQtdVen),10,3)  ,"R","B","023")
			MSCBLineV(052,098,150,06,"B")
			
			MSCBSAY(047,100,"DATA"                               ,"R","B","016")
			MSCBSAY(047,125,Dtoc(SF2->F2_EMISSAO)                ,"R","B","023")
			
			MSCBLineH(045,150,068,06,"B")
			MSCBSAY(063,152,"QUANTIDADE (Q)"                     ,"R","B","016")
			
			MSCBBOX(062,194,067,210,20,"B")
			MSCBSAY(063,195,"Q"+ALLTRIM(STR(_nQtdVen))      	 ,"R","B","023",.T.)
			
			MSCBSAY(057,168,ALLTRIM(Str(_nQtdVen))               ,"R","B","030,030")
			MSCBSAYBAR(047,165,ALLTRIM(Str(_nQtdVen))            ,"R","MB07",7.86,.F.,.F.,.F.,,2,1)
			
			MSCBLineV(045,008,212,06,"B")
			
			MSCBSAY(040,010,"Num.Serie (S)"                      ,"R","B","016")
			MSCBBOX(039,044,043,072,20,"B")
			
			_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
			MSCBSAY(040,045,"S"+AllTrim(SA1->A1_XCODSA2)+_cA1NumSer     ,"R","B","023",.T.)
			MSCBSAY(030,015,"S"+AllTrim(SA1->A1_XCODSA2)+_cA1NumSer     ,"R","B","030",.T.)
			MSCBSAYBAR(020,015,AllTrim(SA1->A1_XCODSA2)+_cA1NumSer  ,"R","MB07",8.86,.F.,.F.,.F.,,2,1)
			
			MSCBLineH(030,073,045,06,"B")
			MSCBSAY(040,075,"REF.FORNEC.(F)"                     ,"R","B","016")
			MSCBBOX(039,111,044,135,20,"B")
			MSCBSAY(040,112,"F"+ALLTRIM(_cB1LCODCLI)    	     ,"R","B","017",.T.)
			
			MSCBSAY(033,075,ALLTRIM(_cB1LCODCLI)                 ,"R","B","017")
			MSCBSAYBAR(033,100,ALLTRIM(_cB1LCODCLI),"R","MB07",4.36,.F.,.F.,.F.,,2,1)
			
			MSCBLineH(030,136,045,06,"B")
			MSCBSAY(040,138,"DESCRICAO"                         ,"R","B","016")
			MSCBSAY(033,138,ALLTRIM(SB1->B1_DESC)               ,"R","B","023")
			MSCBLineV(030,058,212,06,"B")
			
			MSCBLineH(015,058,030,06,"B")
			MSCBSAY(025,060,"NUM.FORNEC.(I)"                    ,"R","B","016")
			MSCBBOX(024,094,029,116,20,"B")
			MSCBSAY(025,095,"I"+StrZero(Val(SA1->A1_XCODSA2),8,0)  ,"R","B","017",.T.)
			
			MSCBSAY(017,060,StrZero(Val(SA1->A1_XCODSA2),8,0)            ,"R","B","017")
			MSCBSAYBAR(017,083,StrZero(Val(SA1->A1_XCODSA2),8,0),"R","MB07",4.36,.F.,.F.,.F.,,2,1)
			
			MSCBLineH(015,118,030,06,"B")
			MSCBSAY(025,120,"MOD.CAIXA"                ,"R","B","016")
			MSCBSAY(025,133,AllTrim(SB1->B1_XMODCX)    ,"R","B","017")
			
			MSCBLineH(021,150,030,06,"B")
			MSCBSAY(025,152,"TURNO"                    ,"R","B","016")
			MSCBSAY(025,162,ALLTRIM(MV_PAR03)          ,"R","B","017")
			
			MSCBLineV(021,118,170,06,"B")
			MSCBSAY(017,120,"OPERADOR "                ,"R","B","016")
			MSCBSAY(017,130,ALLTRIM(MV_PAR05)          ,"R","B","020")
			
			MSCBLineH(015,170,030,06,"B")
			MSCBSAY(026,175,"NUM.LOTE"                 ,"R","B","016")
			If !Empty(_clote01)
				MSCBSAY(021,175,AllTrim(_clote01)      ,"R","B","017")
			EndIf
			If !Empty(_clote02)
				MSCBSAY(018,175,AllTrim(_clote02)      ,"R","B","017")
			EndIf
			
			MSCBEND() //Fim da imagem da etiqueta
		Next
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	
	dbSelectArea("SF2")
	dbSkip()
EndDo

MSCBCLOSEPRINTER()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If aReturn[5]==1
//	dbCommitAll()
//	SET PRINTER TO
//	OurSpool(wnrel)
//Endif

//MS_FLUSH()

Return
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
// ** ValidPerg() **************************************************************************************** //
////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
Local _aAreaVP := GetArea()
Local _nI      := 0
Local _nJ      := 0

Private _aRegs :={}
_cPerg := PADR(_cPerg,10)

dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(_aRegs,{_cPerg,"01","Numero Nota-Serie ","","","mv_ch1","C",13,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"02","Tipo Etiqueta     ","","","mv_ch2","N",01,0,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"03","Turno             ","","","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"04","Lote              ","","","mv_ch4","C",27,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{_cPerg,"05","Operador          ","","","mv_ch5","C",16,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For _nI:=1 to Len(_aRegs)
	If !DBSeek(_cPerg+_aRegs[_nI,2])
		RecLock("SX1",.T.)
		For _nJ:=1 to Len(_aRegs[_nI])
			FieldPut(_nJ,_aRegs[_nI,_nJ])
		Next
		MsUnlock()
	EndIf
Next

RestArea(_aAreaVP)
Return