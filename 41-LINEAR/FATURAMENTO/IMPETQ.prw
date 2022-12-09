#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPETQ   บ Autor ณ THIAGO QUEIROZ     บ Data ณ  24/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao de Etiquetas LINCIPLAS.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LINCIPLAS                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	wnrel:=SetPrint(cAlias,wnrel,_cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cAlias)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

	If !Empty(_cA1NumSer)
		dbSelectArea("SA1")
		RecLock("SA1",.F.)
		SA1->A1_XNUMSER := _cA1NumSer
		MsUnlock()
	EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  02/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local _cDoc   := "000000000"
	Local _cDoc01 := "         "
	Local _cSerie := ""
	Local _cSer01 := ""
	Local _nI     := 0
	Local _lDoc   := .T.
	/*/
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
	/*/
	For _nI := 1  To  Len(AllTrim(MV_PAR01))
		If _lDoc
			If Substr(AllTrim(MV_PAR01),_nI,1) <> "-"
				_cDoc := Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
				If !(Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1) == "0")
				_cDoc01 := Substr(_cDoc01,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
			EndIf
		Else
			_lDoc := .F.
		EndIf
		Else
		_cSerie += Substr(AllTrim(MV_PAR01),_nI,1)
		If !(Substr(AllTrim(MV_PAR01),_nI,1) == "0")
		_cSer01 += Substr(AllTrim(MV_PAR01),_nI,1)
		EndIf
		EndIf
	Next

	_cSerie := _cSerie+Space(3-Len(_cSerie))

	dbSelectArea("SF2")
	dbSetOrder(1)              // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	dbSeek(xFilial("SF2")+_cDoc+_cSerie,.T.)
	If Eof()
		Alert("Numero de Nota + Serie Nใo Encontrada no Sistema...")
		Return
	EndIf
	//
	//
	dbSelectArea("SA1")
	dbSetOrder(1)         // A1_FILIAL+A1_COD+A1_LOJA
	If !(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Alert("Cliente "+SF2->F2_CLIENTE+"-"+SF2->F2_LOJA+" Nใo Encontrado...")
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

			If !Empty(MV_PAR06)
				If !(AllTrim(MV_PAR06) == AllTrim(SD2->D2_ITEM))
					dbSkip()
					Loop
				EndIf
			EndIf

			dbSelectArea("SA4")
			dbSetOrder(1)
			dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
			_cTransp := AllTrim(SA4->A4_NOME)

			dbSelectArea("SB1")
			dbSetOrder(1)
			If !(dbSeek(xFilial("SB1")+SD2->D2_COD))
				Alert("Produto "+SD2->D2_COD+" Nใo Encontrado...")
				Exit
			EndIf

			dbSelectArea("SC9")
			dbSetOrder(2)              // C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
			If dbSeek(xFilial("SC9")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
				If !Empty(SC9->C9_XLOTE01)
					_cLote01 := SC9->C9_XLOTE01
					If !Empty(SC9->C9_XLOTE02)
						_cLote01  := _cLote01 + " " + SC9->C9_XLOTE02
					EndIf
				EndIf
				If !Empty(SC9->C9_XLOTE03)
					_cLote02 := SC9->C9_XLOTE03 + " " + SC9->C9_XLOTE04
				EndIf
			EndIf

			oPrn:StartPage()

			oPrn:Box(0030, 0050, 1600, 2300)    // Linha Inicial, Coluna Inicial, Linha Final, Coluna Final
			oPrn:Box(0029, 0049, 1599, 2299)    // Linha Inicial, Coluna Inicial, Linha Final, Coluna Final
			oPrn:Box(0028, 0048, 1598, 2298)    // Linha Inicial, Coluna Inicial, Linha Final, Coluna Final

			oPrn:Box(0030, 0050, 0120, 1020)    //
			oPrn:Box(0029, 0049, 0119, 1019)    //
			oPrn:Say(0070, 0060, "FROM: "                      , oFtNormal )
			oPrn:Say(0060, 0250, "LINCIPLAS IND. E COM."       , oFtGrande )
			oPrn:Say(0070, 1050, "TO: "                        , oFtNormal )
			//	oPrn:SayBitmap(0160,1060,cPath+"logomae.BMP",0375,0315)
			oPrn:Say(0150, 1450, "IRAMEC AUTOPEวAS LTDA."      , oFtGrande )
			oPrn:Say(0210, 1450, "AV. EURICO AMBROGI DOS SANTOS, No. 1500"  , oFtNormal )
			oPrn:Say(0260, 1450, "BAIRRO: PIRACANGAGUA"                     , oFtNormal )
			oPrn:Say(0310, 1450, "CEP: 12042-010"                           , oFtNormal )
			oPrn:Say(0360, 1450, "TAUBATษ - SPA"                            , oFtNormal )
			oPrn:Say(0410, 1450, "BRASIL"                                   , oFtNormal )
			//		oPrn:Say(0450, 1980, "Rev.3.0 - 11/08/08"                       , oFtPequeno)

			oPrn:Box(0120, 0050, 0350, 1020)
			oPrn:Box(0350, 0050, 0550, 1020)
			oPrn:Box(0550, 0050, 1600, 2300)
			oPrn:Box(0550, 0050, 0670, 2300)

			oPrn:Box(0119, 0049, 0349, 1019)
			oPrn:Box(0349, 0049, 0549, 1019)
			oPrn:Box(0549, 0049, 1599, 2299)
			oPrn:Box(0549, 0049, 0669, 2299)
			oPrn:Say(0150, 0060, "CำD.FORNECEDOR:"             , oFtNormal )
			oPrn:Say(0150, 0550, "00"+SA1->A1_XCODSA2          , oFtGigante)
			MSBAR3("CODE128",1.9,1.5,"00"+SA1->A1_XCODSA2,oPrn,.F.,Nil,.T.,0.048,0.80,.F.,Nil,"A",.F.)

			oPrn:Say(0380, 0060, "No.NOTA FISCAL (N):"                                                    , oFtNormal )
			oPrn:Say(0370, 0550, AllTrim(_cDoc01)+"-"+AllTrim(_cSer01)                                    , oFtGigante)
			MSBAR3("CODE128",3.9,1.8,"N"+AllTrim(_cDoc01)+"-"+AllTrim(_cSer01),oPrn,.F.,Nil,.T.,0.040,0.60,.F.,Nil,"A",.F.)

			oPrn:Say(0560, 0060, "PART NAME:"                  , oFtNormal )
			oPrn:Say(0590, 0350, ALLTRIM(SB1->B1_DESC)         , oFtGrande)

			oPrn:Box(0670, 0050, 0950, 1750)
			oPrn:Box(0669, 0049, 0949, 1749)
			oPrn:Say(0680, 0060, "PART NUMBER (P):"            , oFtNormal )

			_cLCODCLI := ""
			For _nP := 1  To  Len(AllTrim(SB1->B1_LCODCLI))
				If !(Substr(AllTrim(SB1->B1_LCODCLI),_nP,1) == ".")
				_cLCODCLI += Substr(AllTrim(SB1->B1_LCODCLI),_nP,1)
				EndIf
			Next _nP

			oPrn:Say(0690, 0560, AllTrim(_cLCODCLI)            , oFtBig)
			MSBAR3("CODE128",7.0,4.3,"P"+AllTrim(_cLCODCLI)    ,oPrn,.F.,Nil,.T.,0.040,0.80,.F.,Nil,"A",.F.)
			oPrn:Say(0680, 1780, "CONTROL OF QUALITY"          , oFtNormal )

			oPrn:Box(0950, 0050, 1300, 2300)   // QUANTIDADE
			oPrn:Box(0950, 0700, 1300, 2300)   // LOTE DE FABRICACAO
			oPrn:Box(0950, 1750, 1300, 2300)   // DATA DE EXPEDICAO
			oPrn:Box(0949, 0049, 1299, 2299)   // QUANTIDADE
			oPrn:Box(0949, 0699, 1299, 2299)   // LOTE DE FABRICACAO
			oPrn:Box(0949, 1749, 1299, 2299)   // DATA DE EXPEDICAO
			oPrn:Say(0980, 0060, "QUANTIDADE (Q):"                    , oFtNormal )
			oPrn:Say(0980, 0750, "LOTE DE FABRICAวรO:"                , oFtNormal )
			oPrn:Say(0980, 1780, "DATA DE EXPEDIวรO:"                 , oFtNormal )
			oPrn:Say(1070, 0180, STR(SD2->D2_QUANT)                   , oFtGigante)
			MSBAR3("CODE128",10.0,1.5,"Q"+ALLTRIM(STR(SD2->D2_QUANT)) ,oPrn,.F.,Nil,.T.,0.025,0.70,.F.,Nil,"A",.F.)
			If Empty(MV_PAR04)
				oPrn:Say(1120, 0850, AllTrim(_cLote01)+AllTrim(_cLote02)   , oFtGigante)
			Else
				oPrn:Say(1120, 0850, AllTrim(MV_PAR04)         , oFtGigante)
			EndIf
			oPrn:Say(1120, 1900, Dtoc(SD2->D2_EMISSAO)         , oFtGigante)

			oPrn:Box(1300, 0050, 1600, 2300)   // No.SERIE SEQUENCIAL
			oPrn:Box(1300, 1300, 1600, 2300)   // EMBALAGEM
			oPrn:Box(1300, 1750, 1600, 2300)   // DATE DE EXPEDICAO
			oPrn:Box(1299, 0049, 1599, 2299)   // No.SERIE SEQUENCIAL
			oPrn:Box(1299, 1299, 1599, 2299)   // EMBALAGEM
			oPrn:Box(1299, 1749, 1599, 2299)   // DATE DE EXPEDICAO
			oPrn:Say(1330, 0060, "No.SษRIE SEQUENCIAL (S):"    , oFtNormal )
			oPrn:Say(1330, 1340, "UNID.MED.:"                  , oFtNormal )
			oPrn:Say(1330, 1780, "EMBALAGEM:"                  , oFtNormal )
			_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
			oPrn:Say(1400, 0280, AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer)    , oFtGigante)
			MSBAR3("CODE128",12.5,1.2,"S"+AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer),oPrn,.F.,Nil,.T.,0.035,0.80,.F.,Nil,"A",.F.)

			oPrn:Say(1500, 1400,"PวS"                          , oFtGigante)
			oPrn:Say(1500, 1900, "PALLET"                      , oFtGigante)

			dbSelectArea("SD2")
			dbSkip()
			//
			//      SEGUNDA ETIQUETA DA PAGINA.
			//
			If !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
				dbSelectArea("SB1")
				dbSetOrder(1)
				If !(dbSeek(xFilial("SB1")+SD2->D2_COD))
					Alert("Produto "+SD2->D2_COD+" Nใo Encontrado...")
					Exit
				EndIf

				dbSelectArea("SC9")
				dbSetOrder(2)              // C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
				If dbSeek(xFilial("SC9")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
					If !Empty(SC9->C9_XLOTE01)
						_cLote01 := SC9->C9_XLOTE01
						If !Empty(SC9->C9_XLOTE02)
							_cLote01  := _cLote01 + " " + SC9->C9_XLOTE02
						EndIf
					EndIf
					If !Empty(SC9->C9_XLOTE03)
						_cLote02 := SC9->C9_XLOTE03 + " " + SC9->C9_XLOTE04
					EndIf
				EndIf

				oPrn:Box(1780, 0050, 3350, 2300)    // Linha Inicial, Coluna Inicial, Linha Final, Coluna Final
				oPrn:Box(1780, 0050, 1870, 1020)    // LINCIPLAS
				oPrn:Box(1779, 0049, 3349, 2299)    // Linha Inicial, Coluna Inicial, Linha Final, Coluna Final
				oPrn:Box(1779, 0049, 1869, 1019)    // LINCIPLAS
				oPrn:Say(1820, 0060, "FROM: "                      , oFtNormal )
				oPrn:Say(1810, 0250, "LINCIPLAS IND. E COM."       , oFtGrande )
				oPrn:Say(1820, 1050, "TO: "                        , oFtNormal )
				//		oPrn:SayBitmap(1910,1060,cPath+"logomae.BMP",0375,0315)
				oPrn:Say(1900, 1450, "IRAMEC AUTOPEวAS LTDA."      , oFtGrande )
				oPrn:Say(1960, 1450, "AV. EURICO AMBROGI DOS SANTOS, No. 1500"  , oFtNormal )
				oPrn:Say(2010, 1450, "BAIRRO: PIRACANGAGUA"                     , oFtNormal )
				oPrn:Say(2060, 1450, "CEP: 12042-010"                           , oFtNormal )
				oPrn:Say(2110, 1450, "TAUBATษ - SPA"                            , oFtNormal )
				oPrn:Say(2160, 1450, "BRASIL"                                   , oFtNormal )

				//			oPrn:Say(2200, 1980, "Rev.3.0 - 11/08/08"                       , oFtPequeno)

				oPrn:Box(1870, 0050, 2100, 1020)    // COD FORNEC.
				oPrn:Box(2100, 0050, 2300, 1020)    // NUMERO DA NOTA E SERIE
				oPrn:Box(2300, 0050, 3350, 2300)
				oPrn:Box(2300, 0050, 2420, 2300)    // CONTROL OF QUALITY
				oPrn:Box(1869, 0049, 2099, 1019)    // COD FORNEC.
				oPrn:Box(2099, 0049, 2299, 1019)    // NUMERO DA NOTA E SERIE
				oPrn:Box(2299, 0049, 3349, 2299)
				oPrn:Box(2299, 0049, 2419, 2299)    // CONTROL OF QUALITY
				oPrn:Say(1900, 0060, "CำD.FORNECEDOR:"             , oFtNormal )
				oPrn:Say(1900, 0550, "00"+SA1->A1_XCODSA2          , oFtGigante)
				MSBAR3("CODE128",16.7,1.5,"00"+SA1->A1_XCODSA2,oPrn,.F.,Nil,.T.,0.048,0.80,.F.,Nil,"A",.F.)

				oPrn:Say(2130, 0060, "No.NOTA FISCAL (N):"                                                     , oFtNormal )
				oPrn:Say(2120, 0550, AllTrim(_cDoc01)+"-"+AllTrim(_cSer01)                                     , oFtGigante)
				MSBAR3("CODE128",18.7,1.8,"N"+AllTrim(_cDoc01)+"-"+AllTrim(_cSer01),oPrn,.F.,Nil,.T.,0.040,0.60,.F.,Nil,"A",.F.)

				oPrn:Say(2310, 0060, "PART NAME:"                  , oFtNormal )
				oPrn:Say(2340, 0350, ALLTRIM(SB1->B1_DESC)         , oFtGrande)

				oPrn:Box(2420, 0050, 3050, 1750)
				oPrn:Box(2419, 0049, 3049, 1749)
				oPrn:Say(2430, 0060, "PART NUMBER (P):"            , oFtNormal )

				_cLCODCLI := ""
				For _nP := 1  To  Len(AllTrim(SB1->B1_LCODCLI))
					If !(Substr(AllTrim(SB1->B1_LCODCLI),_nP,1) == ".")
					_cLCODCLI += Substr(AllTrim(SB1->B1_LCODCLI),_nP,1)
					EndIf
				Next _nP

				oPrn:Say(2440, 0560, AllTrim(_cLCODCLI)            , oFtBig)
				MSBAR3("CODE128",21.8,4.3,"P"+AllTrim(_cLCODCLI)   ,oPrn,.F.,Nil,.T.,0.040,0.80,.F.,Nil,"A",.F.)
				oPrn:Say(2430, 1780, "CONTROL OF QUALITY"          , oFtNormal )

				oPrn:Box(2700, 0050, 3050, 2300)   // QUANTIDADE
				oPrn:Box(2700, 0700, 3050, 2300)   // UNID.MEDIDA
				oPrn:Box(2700, 1750, 3050, 2300)   // LOTE DE FABRICACAO
				oPrn:Box(2699, 0049, 3049, 2299)   // QUANTIDADE
				oPrn:Box(2699, 0699, 3049, 2299)   // UNID.MEDIDA
				oPrn:Box(2699, 1749, 3049, 2299)   // LOTE DE FABRICACAO
				oPrn:Say(2730, 0060, "QUANTIDADE (Q):"             , oFtNormal )
				oPrn:Say(2730, 0750, "LOTE DE FABRICAวรO:"         , oFtNormal )
				oPrn:Say(2730, 1780, "DATA DE EXPEDIวรO:"          , oFtNormal )
				oPrn:Say(2820, 0180, STR(SD2->D2_QUANT)                    , oFtGigante)
				MSBAR3("CODE128",24.8,1.5,"Q"+ALLTRIM(STR(SD2->D2_QUANT))  ,oPrn,.F.,Nil,.T.,0.025,0.70,.F.,Nil,"A",.F.)
				If Empty(MV_PAR04)
					oPrn:Say(2870, 0850, AllTrim(_cLote01)+AllTrim(_cLote02) , oFtGigante)
				Else
					oPrn:Say(2870, 0850, AllTrim(MV_PAR04)         , oFtGigante)
				EndIf
				oPrn:Say(2870, 1900, Dtoc(SD2->D2_EMISSAO)         , oFtGigante)

				oPrn:Box(3050, 0050, 3350, 2300)   // No.SERIE SEQUENCIAL
				oPrn:Box(3050, 1300, 3350, 2300)   // EMBALAGEM
				oPrn:Box(3050, 1750, 3350, 2300)   // DATE DE EXPEDICAO
				oPrn:Box(3049, 0049, 3349, 2299)   // No.SERIE SEQUENCIAL
				oPrn:Box(3049, 1299, 3349, 2299)   // EMBALAGEM
				oPrn:Box(3049, 1749, 3349, 2299)   // DATE DE EXPEDICAO
				oPrn:Say(3080, 0060, "No.SษRIE SEQUENCIAL (S):"    , oFtNormal )
				oPrn:Say(3080, 1340, "UNID.MED.:"                  , oFtNormal )
				oPrn:Say(3080, 1780, "EMBALAGEM:"                  , oFtNormal )
				_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
				oPrn:Say(3150, 0280, AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer)    , oFtGigante)
				MSBAR3("CODE128",27.3,1.2,"S"+AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer),oPrn,.F.,Nil,.T.,0.035,0.80,.F.,Nil,"A",.F.)
				oPrn:Say(3250, 1400,"PวS"                          , oFtGigante)
				oPrn:Say(3250, 1900, "PALLET"                      , oFtGigante)
			EndIf

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
	Local _cDoc01 := "         "
	Local _cSerie := ""
	Local _cSer01 := ""
	Local _nI     := 0
	Local _nP     := 0
	Local _lDoc   := .T.

	Private _cLote01   := Space(06)

	Private _nQtdEmb   := 0
	Private _nQtdEtq   := 0
	Private _nResto    := 0
	Private _nQtdVen   := 0
	Private _cLCODCLI  := 0

	For _nI := 1  To  Len(AllTrim(MV_PAR01))
		If _lDoc
			If Substr(AllTrim(MV_PAR01),_nI,1) <> "-"
				_cDoc := Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
				If !(Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1) == "0")
				_cDoc01 := Substr(_cDoc01,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
			EndIf
		Else
			_lDoc := .F.
		EndIf
		Else
		_cSerie += Substr(AllTrim(MV_PAR01),_nI,1)
		If !(Substr(AllTrim(MV_PAR01),_nI,1) == "0")
		_cSer01 += Substr(AllTrim(MV_PAR01),_nI,1)
		EndIf
		EndIf
	Next

	_cSerie := _cSerie+Space(3-Len(_cSerie))
	_nI     := 0

	dbSelectArea("SF2")
	dbSetOrder(1)              // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	dbSeek(xFilial("SF2")+_cDoc+_cSerie,.T.)
	If Eof()
		Alert("Numero de Nota + Serie Nใo Encontrada no Sistema...")
		Return
	EndIf
	//
	//
	dbSelectArea("SA1")
	dbSetOrder(1)         // A1_FILIAL+A1_COD+A1_LOJA
	If !(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Alert("Cliente "+SF2->F2_CLIENTE+"-"+SF2->F2_LOJA+" Nใo Encontrado...")
		Return
	Else
		_cA1NumSer := SA1->A1_XNUMSER
	EndIf
	//
	//
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SetRegua(RecCount())
	//MSCBPRINTER("S600","LPT1",,80,.F.,,,,)
	//MSCBCHKSTATUS(.F.) //.T. -- seta o controle de status do sistema com a impressora

	Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE == _cDoc+_cSerie

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		dbSelectArea("SD2")
		dbSetOrder(3)                    // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.)
		Do While !Eof() .And. SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			If !Empty(MV_PAR06)
				If !(AllTrim(MV_PAR06) == AllTrim(SD2->D2_ITEM))
					dbSkip()
					Loop
				EndIf
			EndIf

			dbSelectArea("SA4")
			dbSetOrder(1)
			dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
			_cTransp := AllTrim(SA4->A4_NOME)

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				_nQtdEmb := SB1->B1_XQTDETQ
			Else
				Alert("Produto "+SD2->D2_COD+" Nใo Encontrado...")
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

			dbSelectArea("SC9")
			dbSetOrder(2)              // C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
			If dbSeek(xFilial("SC9")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
				If !Empty(SC9->C9_XLOTE01)
					_cLote01 := SC9->C9_XLOTE01
					If !Empty(SC9->C9_XLOTE02)
						_cLote01  := _cLote01 + " " + SC9->C9_XLOTE02
					EndIf
				EndIf
				If !Empty(SC9->C9_XLOTE03)
					_cLote02 := SC9->C9_XLOTE03 + " " + SC9->C9_XLOTE04
				EndIf
			EndIf

			_cTurno    := Space(10)
			_cOperador := Space(16)
			dbSelectArea("SZC")
			dbSetOrder(9)              // ZC_FILIAL+ZC_LOTEOP+ZC_OP
			If dbSeek(xFilial("SZC")+SC9->C9_XLOTE01+SC9->C9_XOP01)
				_cTurno    := SZC->ZC_TURNO
				_cOperador := SZC->ZC_OPERADO
			EndIf

			For _nI := 1  To  _nQtdEtq
				If _nI == _nQtdEtq .And. _nResto > 0
					_nQtdVen := _nResto
				EndIf

				MSCBPRINTER("S600","LPT1",,80,.F.,,,,)
				MSCBCHKSTATUS(.F.) //.T. -- seta o controle de status do sistema com a impressora
				MSCBBEGIN(1,6) // ,31.5)
				MSCBBOX(010,002,092,102,006)

				MSCBSAY(012,005,"FROM:"							    ,"N","A","015,008")
				If SM0->M0_CODFIL == "01" .Or. SM0->M0_CODFIL == "04"
					MSCBSAY(020,004,"H.SILVA INJ.TERMOP."           ,"N","B","017")
					//				MSCBSAY(018,004,"H.SILVA INJECAO TERMOPLAS - LINCIPLAS" ,"N","B","019")
				Else
					MSCBSAY(018,004,"LINEAR - GRU / SP"             ,"N","B","017")
				EndIf
				// ------------------------------------------------------------
				MSCBSAY(012,010,"COD.FORNECEDOR"				    ,"N","A","015,008")
				MSCBSAY(052,010,"00"+SA1->A1_XCODSA2	            ,"N","B","017,008")
				MSCBSAYBAR(013,014,"00"+SA1->A1_XCODSA2,"MB07","C",6.76,.F.,.F.,.F.,,2.5,1)
				MSCBLineH(010,023,064,004,"B")
				MSCBLineV(064,002,037,004,"B")
				// ------------------------------------------------------------
				MSCBSAY(065,004,"TO:"							    ,"N","A","015,008")

				If SA1->A1_COD == "001706"
					MSCBSAY(066,025,"AVENIDA VENUS, 67"             ,"N","A","015,007")
					MSCBSAY(066,028,"ITAPEGICA"          	        ,"N","A","015,007")
					MSCBSAY(066,031,"CEP: 07044-170"                ,"N","A","015,007")
					MSCBSAY(066,034,"GUARULHOS - SP - BRASIL"	    ,"N","A","015,007")
				Else
					MSCBSAY(066,025,ALLTRIM(SUBSTR(SA1->A1_END,01,22))  ,"N","A","015,007")
					MSCBSAY(066,028,ALLTRIM(SUBSTR(SA1->A1_END,23,12))+" - "+ALLTRIM(SA1->A1_BAIRRO)	,"N","A","015,007")
					MSCBSAY(066,031,"CEP: " + ALLTRIM(SUBSTR(SA1->A1_CEP,1,5))+"-"+ALLTRIM(SUBSTR(SA1->A1_CEP,6,3))	    ,"N","A","015,007")
					MSCBSAY(066,034,ALLTRIM(SA1->A1_MUN)+" - "+SA1->A1_EST+" - BRASIL"	,"N","A","015,007")
				EndIf
				// ------------------------------------------------------------
				MSCBSAY(012,025,"NOTA FISCAL (N)"		        	    ,"N","A","015,008")
				MSCBSAY(050,025,AllTrim(_cDoc01)+"-"+AllTrim(_cSer01)   ,"N","B","017,008")
				MSCBSAYBAR(013,029,"N"+AllTrim(_cDoc01)+"-"+AllTrim(_cSer01),"MB07","C",6.36,.F.,.F.,.F.,,3,2)
				MSCBLineH(010,037,092,004,"B")
				// ------------------------------------------------------------
				MSCBSAY(012,039,"PART NAME:"					    ,"N","A","015,008")
				MSCBSAY(012,042,ALLTRIM(SB1->B1_DESC)			    ,"N","B","017")
				MSCBLineH(010,046,092,004,"B")
				// ------------------------------------------------------------
				MSCBSAY(012,048,"PART NUMBER (P)"				    ,"N","A","015,008")

				_cLCODCLI := ""
				For _nP := 1  To  Len(AllTrim(SB1->B1_LCODCLI))
					If !(Substr(AllTrim(SB1->B1_LCODCLI),_nP,1) == ".")
					_cLCODCLI += Substr(AllTrim(SB1->B1_LCODCLI),_nP,1)
					EndIf
				Next _nP

				MSCBSAY(048,048,AllTrim(_cLCODCLI)                  ,"N","B","025,012")
				MSCBSAYBAR(013,052,"P"+AllTrim(_cLCODCLI),"MB07","C",6.36,.F.,.F.,.F.,,3,2)
				MSCBLineH(010,060,092,004,"B")
				// ------------------------------------------------------------
				MSCBSAY(012,062,"LOTE FABRICACAO"	         		    ,"N","A","015,008")
				If Empty(MV_PAR04)
					MSCBSAY(012,066,AllTrim(_cLote01)+AllTrim(_cLote02) ,"N","B","023")
				Else
					MSCBSAY(012,066,AllTrim(MV_PAR04)			        ,"N","B","023")
				EndIf
				MSCBSAY(052,062,"DATA EXPED.:"	        				,"N","A","015,008")
				MSCBSAY(058,066,DTOC(SF2->F2_EMISSAO)			        ,"N","B","020")
				MSCBLineV(051,060,084,004,"B")
				MSCBLineH(010,070,092,004,"B")
				// ------------------------------------------------------------
				MSCBSAY(012,072,"QUANTIDADE (Q)"					,"N","A","015,008")
				MSCBSAY(052,072,"UNID.MED."		     			    ,"N","A","015,008")
				MSCBSAY(070,072,"PACKING:"						    ,"N","A","015,008")
				MSCBLineV(068,070,084,005,"B")

				MSCBSAY(038,072,STR(_nQtdVen)		             	,"N","B","023")
				MSCBSAYBAR(013,076,"Q"+ALLTRIM(STR(_nQtdVen)),"MB07","C",7.36,.F.,.F.,.F.,,2,1)
				MSCBSAY(055,077,"PCS" /*SB1->B1_UM*/			    ,"N","B","020,012")
				MSCBSAY(072,077,ALLTRIM(SB1->B1_XMODCX)	     		,"N","B","020")
				MSCBLineH(010,084,092,004,"B")
				If SA1->A1_COD == "001706"
					// ------------------------------------------------------------
					MSCBSAY(012,086,"N.SERIE SEQUENCIAL (S)"		    ,"N","A","015,008")
					_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
					MSCBSAY(052,086,AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer) ,"N","B","023")
					MSCBSAYBAR(013,091,"S"+AllTrim(SA1->A1_XCODSA2)+_cA1NumSer,"MB07","C",6.36,.F.,.F.,.F.,,3,2)
					//
					MSCBWRITE("^FO544,20")
					MSCBWRITE("^GFA,02560,02560,00016,:Z64:")
					MSCBWRITE("eJztlTFrFEEUx9/mkISAHBZBQUFIdUxhJ9hItvAj5HnVJfkIFjlSyU05LFjaH1MNL1/ASvIR0ixWJ9YWlzSHUY4bZzY7O2/2YA8Rg4JvYeHHf//zZnbemwH4H/90bFsWS4A+sfgI8CT5GOAF556EN5wzCSfJ6HfAft6rDp60uOf4C+PM8QUfn31e8WSNl518YG9a/Lv6Jv7L/Kvb4jGNPkIX5ac8sFFKGVNMA9sxDvHt2WnNVz8EkRQkZK1/R3wN9xAvQn43AGwZNQ35F07PFngZ9H2tAYQ2gREPATDqA+cH/6r9lf4cj4IuBAHsEiX+PZwF3vH+HVUk/j0sk/y7miT330eUqV9J7nd6HvKTcH6x5s87/L137gex/L1Ca+7ffo/I599X6fr7o6j79fdFuv6nL/Ez9z9u/b+DMd7w9U9IT7nflphz/8oYyfzZt+OzwG7/3Qx8ATV+xNnsEqK/UAXJpv+8jqdNva32ST9bxv50BTi0nAfq3H6o2ff/Am2j+/PBntvbInf8sD4bA/vjxNorzomu5/P5V6L5dcgHvvQOY3+4EFQkvK6LTr3a/w69qr8OfbDBX9X/L/jHG/KXrj85G5WsPytxyHmr6v3IrvXxmvGgIKMiZ2O//TLqRJoocvbAB8/fxJ/n9v3Y5vZ9+ihhdx/PcNQ8R+v3NbxikcNdx09rqwOd:0EFE")
					MSCBWRITE("^PQ1,0,1,Y^XZ")
					//
					MSCBEND()
					MSCBCLOSEPRINTER()
				Else
					// ------------------------------------------------------------
					MSCBSAY(012,086,"N.SERIE SEQUENCIAL (S)"		    ,"N","A","015,008")
					_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
					MSCBSAY(052,086,AllTrim(SA1->A1_XCODSA2)+AllTrim(_cA1NumSer) ,"N","B","023")
					MSCBSAYBAR(013,091,"S"+AllTrim(SA1->A1_XCODSA2)+_cA1NumSer,"MB07","C",6.36,.F.,.F.,.F.,,3,2)
					//
					MSCBWRITE("^FO544,64")
					MSCBWRITE("^GFA,03072,03072,00024,:Z64:")
					MSCBWRITE("eJztlbFr20AUxk+KDEIprQz2LjSJ85C10EUGZ3fAoh1qCPRfaMbC4Ulc/4ciPIlziUumoIO4Q4eOHbo3o0lLtQY7+Pp0dtK7kw0pNEOhX4iSPH7+7rt3TxeE/uuBRJTnQ8hNKUv/gA/ZhLOsXm8noH6tTJkAXRGz3kikYrO+t+SV5jv42gJPKvuyvK7xw7iKNDDr+2IcHnB+XotfPbbwjzNEbCFuahuQH6rzUp26v5S1g/fq+Tf8ix3+u/haf9I8J4SJWj+lGsmxUQkxY+OgM8tqbNOv9msUPVaW5dX76YrUnEGDxOBtLA/3slOYuaWQZcSXs7MqM2rET5JvMXrzEqFYD8+5YPZsYYd6fGudQ4dh8ielyGEPc5fq8ZPk45p3tI+Ek3VbAhtr/rdT0NeXIKdCtoUuGLvcYm8NnIbK25xLW1wwrPK3Q9NO/PaxUp+WN9UmqFjpx7uJAyfQVV8vsP+AZI8WnZnqv36poEf9hsq/XYlr4tKpENl0TogSR/JwXGT4RbHZ57wIwwnYo0Dd7ZqHV/E10rRfip/stBSr1HVhG3d1yD3ogfswNng5OjNxie3UznLVH/S8j/zqD4UXq2p6FmRM01GW6vzwK0K+46j+e8slX4oFdAj8g9/7Re2T5KR+ryF0AKNZxfBcOkL5FsCUHd4DUlRlIFXn5fd2JjbXQIGLM0wCL7DVugXT2fSP4DffUuuY5J5H0zzy8EitN1DPcaw4jp2exkcZ9uwRwSbfXC8CZ9DU+Dxj1KME517E1C34cRf84Ydz1FX5LAqZPUI4gi+17t/5+02l7DJYAPyjyIs8lT+M4x7k78dO3FDbQ3CA7RHLMY20/oBz5R37jtYfm3gZpYTBLvIRQf+eUkXk79vbQqqUT6W+udA317rCwyUUjr1i/KrDuc73LeT46LCt8/Cft2DznH6He0jND5eE/6nnt7pt0784G0eswM9M/0E1Qi3L9C9/FOzR53fnM1ESg++14pZf8784o9GYPuVb/J0+6idm/tVFcbXIr4WZf1d/uODVTaT775Sr6D78A+kXdKloUA==:FB9A")
					MSCBWRITE("^PQ1,0,1,Y^XZ")
					//
					MSCBEND()
					MSCBCLOSEPRINTER()
				EndIf
			Next

			dbSelectArea("SD2")
			dbSkip()
		EndDo
		dbSelectArea("SF2")
		dbSkip()
	EndDo

	//MSCBCLOSEPRINTER()
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
	Local _cDoc01 := "         "
	Local _cSerie := ""
	Local _cSer01 := ""
	Local _nI     := 0
	Local _lDoc   := .T.

	Private _nQtdEmb   := 0
	Private _nQtdEtq   := 0
	Private _nResto    := 0
	Private _nQtdVen   := 0

	Private _nLote     := 1
	Private _cLote01   := ""
	Private _cLote02   := ""
	/*/
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
	/*/
	For _nI := 1  To  Len(AllTrim(MV_PAR01))
		If _lDoc
			If Substr(AllTrim(MV_PAR01),_nI,1) <> "-"
				_cDoc := Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
				If !(Substr(_cDoc,2,8)+Substr(AllTrim(MV_PAR01),_nI,1) == "0")
				_cDoc01 := Substr(_cDoc01,2,8)+Substr(AllTrim(MV_PAR01),_nI,1)
			EndIf
		Else
			_lDoc := .F.
		EndIf
		Else
		_cSerie += Substr(AllTrim(MV_PAR01),_nI,1)
		If !(Substr(AllTrim(MV_PAR01),_nI,1) == "0")
		_cSer01 += Substr(AllTrim(MV_PAR01),_nI,1)
		EndIf
		EndIf
	Next

	_cSerie := _cSerie+Space(3-Len(_cSerie))

	dbSelectArea("SF2")
	dbSetOrder(1)              // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	dbSeek(xFilial("SF2")+_cDoc+_cSerie,.T.)
	If Eof()
		Alert("Numero de Nota + Serie Nใo Encontrada no Sistema...")
		Return
	EndIf
	//
	//
	If !Empty(MV_PAR04)
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
	EndIf
	//
	//
	dbSelectArea("SA1")
	dbSetOrder(1)         // A1_FILIAL+A1_COD+A1_LOJA
	If !(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Alert("Cliente "+SF2->F2_CLIENTE+"-"+SF2->F2_LOJA+" Nใo Encontrado...")
		Return
	Else
		_cA1NumSer := SA1->A1_XNUMSER
	EndIf

	If !(SA1->A1_COD == "001741")
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

				If !Empty(MV_PAR06)
					If !(AllTrim(MV_PAR06) == AllTrim(SD2->D2_ITEM))
						dbSkip()
						Loop
					EndIf
				EndIf

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
					Alert("Produto "+SD2->D2_COD+" Nใo Encontrado...")
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

				If Empty(MV_PAR04)
					dbSelectArea("SC9")
					dbSetOrder(2)              // C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
					If dbSeek(xFilial("SC9")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
						If !Empty(SC9->C9_XLOTE01)
							_cLote01 := SC9->C9_XLOTE01 + " / " + SC9->C9_XLOTE02
						EndIf
						If !Empty(SC9->C9_XLOTE03)
							_cLote02 := SC9->C9_XLOTE03 + " / " + SC9->C9_XLOTE04
						EndIf
					EndIf

					_cTurno    := Space(10)
					_cOperador := Space(16)
					dbSelectArea("SZC")
					dbSetOrder(9)              // ZC_FILIAL+ZC_LOTEOP+ZC_OP
					If dbSeek(xFilial("SZC")+SC9->C9_XLOTE01+SC9->C9_XOP01)
						_cTurno    := SZC->ZC_TURNO
						_cOperador := SZC->ZC_OPERADO
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
					MSCBBOX(077,072,081,095,17,"B")
					MSCBSAY(078,073,"N"+AllTrim(_cDoc01)+"-"+AllTrim(_cSer01) ,"R","B","020",.T.)

					MSCBSAY(070,013,AllTrim(_cDoc01)+"-"+AllTrim(_cSer01)     ,"R","B","023")
					MSCBSAYBAR(070,036,AllTrim(_cDoc01)+"-"+AllTrim(_cSer01)  ,"R","MB07",7.36,.F.,.F.,.F.,,2,1)
					MSCBLineH(068,098,082,06,"B")

					MSCBSAY(078,100,"ENDERECO DO CLIENTE"                ,"R","B","016")
					MSCBSAY(070,100,AllTrim(SA1->A1_END)+" - "+AllTrim(SA1->A1_BAIRRO)+" / "+AllTrim(SA1->A1_MUN)+" / "+SA1->A1_EST        ,"R","B","027")

					MSCBLineV(068,008,212,06,"B")
					MSCBSAY(063,010,"REFERENCIA DO CLIENTE (P)"		     ,"R","B","016")

					MSCBBOX(062,065,067,096,20,"B")
					MSCBSAY(063,066,"P"+ALLTRIM(_cB1LCODCLI)           	 ,"R","B","023",.T.)

					MSCBSAY(057,025,ALLTRIM(_cB1LCODCLI)                 ,"R","B","030,030")
					MSCBSAYBAR(047,025,ALLTRIM(_cB1LCODCLI)              ,"R","MB07",7.86,.F.,.F.,.F.,,2,1)
					MSCBLineH(045,098,082,06,"B")

					MSCBSAY(063,100,"PESO NETO"                          ,"R","B","016")
					MSCBSAY(063,125,Str((SB1->B1_PESO*_nQtdVen),10,3)  ,"R","B","023")
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
					MSCBSAY(043,075,"REF.FORNEC.(F)"                     ,"R","B","016")
					MSCBBOX(039,105,044,135,20,"B")
					MSCBSAY(040,106,"F"+ALLTRIM(_cB1LCODCLI)    	     ,"R","B","017",.T.)

					MSCBSAY(038,075,ALLTRIM(_cB1LCODCLI)                 ,"R","B","017")
					MSCBSAYBAR(032,085,ALLTRIM(_cB1LCODCLI),"R","MB07",4.36,.F.,.F.,.F.,,1.5,2)

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
					If Empty(MV_PAR03)
						MSCBSAY(025,162,ALLTRIM(_cTurno)       ,"R","B","017")
					Else
						MSCBSAY(025,162,ALLTRIM(MV_PAR03)      ,"R","B","017")
					EndIf

					MSCBLineV(021,118,170,06,"B")
					MSCBSAY(017,120,"OPERADOR "                ,"R","B","016")
					If Empty(MV_PAR05)
						MSCBSAY(017,130,ALLTRIM(_cOperador)    ,"R","B","020")
					Else
						MSCBSAY(017,130,ALLTRIM(MV_PAR05)      ,"R","B","020")
					EndIf

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

	Else

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

				If !Empty(MV_PAR06)
					If !(AllTrim(MV_PAR06) == AllTrim(SD2->D2_ITEM))
						dbSkip()
						Loop
					EndIf
				EndIf

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
					Alert("Produto "+SD2->D2_COD+" Nใo Encontrado...")
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

				If Empty(MV_PAR04)
					dbSelectArea("SC9")
					dbSetOrder(2)              // C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
					If dbSeek(xFilial("SC9")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
						If !Empty(SC9->C9_XLOTE01)
							_cLote01 := SC9->C9_XLOTE01 + " / " + SC9->C9_XLOTE02
						EndIf
						If !Empty(SC9->C9_XLOTE03)
							_cLote02 := SC9->C9_XLOTE03 + " / " + SC9->C9_XLOTE04
						EndIf
					EndIf

					_cTurno    := Space(10)
					_cOperador := Space(16)
					dbSelectArea("SZC")
					dbSetOrder(9)              // ZC_FILIAL+ZC_LOTEOP+ZC_OP
					If dbSeek(xFilial("SZC")+SC9->C9_XLOTE01+SC9->C9_XOP01)
						_cTurno    := SZC->ZC_TURNO
						_cOperador := SZC->ZC_OPERADO
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
					MSCBBOX(077,072,081,095,17,"B")
					MSCBSAY(078,073,"N"+AllTrim(_cDoc01)+"-"+AllTrim(_cSer01) ,"R","B","020",.T.)

					MSCBSAY(070,013,AllTrim(_cDoc01)+"-"+AllTrim(_cSer01)     ,"R","B","023")
					MSCBSAYBAR(070,036,AllTrim(_cDoc01)+"-"+AllTrim(_cSer01)  ,"R","MB07",7.36,.F.,.F.,.F.,,2,1)
					MSCBLineH(068,098,082,06,"B")

					//				MSCBSAY(078,100,"ENDERECO DO CLIENTE"                ,"R","B","016")
					MSCBSAY(078,100,AllTrim(SA1->A1_END)+" - "+AllTrim(SA1->A1_BAIRRO)+" / "+AllTrim(SA1->A1_MUN)+" / "+SA1->A1_EST        ,"R","B","027")
					MSCBLineV(076,098,212,06,"B")

					MSCBLineV(068,008,098,06,"B")
					MSCBSAY(063,010,"REFERENCIA DO CLIENTE (P)"		     ,"R","B","016")

					MSCBBOX(062,065,067,096,20,"B")
					MSCBSAY(063,066,"P"+ALLTRIM(_cB1LCODCLI)           	 ,"R","B","023",.T.)

					MSCBSAY(057,025,ALLTRIM(_cB1LCODCLI)                 ,"R","B","030,030")
					MSCBSAYBAR(047,025,ALLTRIM(_cB1LCODCLI)              ,"R","MB07",7.86,.F.,.F.,.F.,,2,1)
					MSCBLineH(045,098,082,06,"B")

					MSCBSAY(073,100,"PESO NETO"                          ,"R","B","016")
					MSCBSAY(072,125,Str((SB1->B1_PESO*_nQtdVen),10,3)  ,"R","B","023")
					MSCBLineV(070,098,150,06,"B")

					MSCBSAY(067,100,"PESO BRUTO"                         ,"R","B","016")
					MSCBSAY(066,125,Str((SB1->B1_PESBRU*_nQtdVen),10,3)  ,"R","B","023")
					MSCBLineV(064,098,150,06,"B")

					MSCBSAY(061,100,"DATA"                               ,"R","B","016")
					MSCBSAY(060,120,Dtoc(SF2->F2_EMISSAO)                ,"R","B","023")

					MSCBLineH(058,150,076,06,"B")
					MSCBSAY(074,152,"QUANTIDADE (Q)"                     ,"R","B","016")

					MSCBBOX(069,194,074,210,23,"B")
					MSCBSAY(070,195,"Q"+ALLTRIM(STR(_nQtdVen))      	 ,"R","B","023",.T.)

					MSCBSAY(070,170,ALLTRIM(Str(_nQtdVen))               ,"R","B","030,030")
					MSCBSAYBAR(060,167,ALLTRIM(Str(_nQtdVen))            ,"R","MB07",7.86,.F.,.F.,.F.,,2,1)

					MSCBLineV(058,098,212,06,"B")
					MSCBSAY(055,100,"CODIGO HONDA"                       ,"R","B","016")
					If !(Empty(SB1->B1_XCODINT))
						MSCBSAY(054,130,AllTrim(SB1->B1_XCODINT)         ,"R","B","023")    // ,030")
						MSCBSAYBAR(047,120,ALLTRIM(SB1->B1_XCODINT)      ,"R","MB07",5.86,.F.,.F.,.F.,,1.5,2)
					EndIf

					MSCBLineV(045,008,212,06,"B")

					MSCBSAY(040,010,"Num.Serie (S)"                      ,"R","B","016")
					MSCBBOX(039,044,043,072,20,"B")

					_cA1NumSer := Soma1(AllTrim(_cA1NumSer))
					MSCBSAY(040,045,"S"+AllTrim(SA1->A1_XCODSA2)+_cA1NumSer     ,"R","B","023",.T.)
					MSCBSAY(030,015,"S"+AllTrim(SA1->A1_XCODSA2)+_cA1NumSer     ,"R","B","030",.T.)
					MSCBSAYBAR(020,015,AllTrim(SA1->A1_XCODSA2)+_cA1NumSer      ,"R","MB07",8.86,.F.,.F.,.F.,,2,1)

					MSCBLineH(030,073,045,06,"B")
					MSCBSAY(043,075,"REF.FORNEC.(F)"                     ,"R","B","016")
					MSCBBOX(039,105,044,135,20,"B")
					MSCBSAY(040,106,"F"+ALLTRIM(_cB1LCODCLI)    	     ,"R","B","017",.T.)

					MSCBSAY(038,075,ALLTRIM(_cB1LCODCLI)                 ,"R","B","017")
					MSCBSAYBAR(032,085,ALLTRIM(_cB1LCODCLI),"R","MB07",4.36,.F.,.F.,.F.,,1.5,2)

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
					If Empty(MV_PAR03)
						MSCBSAY(025,162,ALLTRIM(_cTurno)       ,"R","B","017")
					Else
						MSCBSAY(025,162,ALLTRIM(MV_PAR03)      ,"R","B","017")
					EndIf

					MSCBLineV(021,118,170,06,"B")
					MSCBSAY(017,120,"OPERADOR "                ,"R","B","016")
					If Empty(MV_PAR05)
						MSCBSAY(017,130,ALLTRIM(_cOperador)    ,"R","B","020")
					Else
						MSCBSAY(017,130,ALLTRIM(MV_PAR05)      ,"R","B","020")
					EndIf

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
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//SET DEVICE TO SCREEN

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	AADD(_aRegs,{_cPerg,"06","Item da Nota      ","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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