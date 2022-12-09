#Include 'protheus.ch'
#Include 'rwmake.ch'
#Include 'topconn.ch'

#Define PAD_LEFT            0
#Define PAD_RIGHT           1
#Define PAD_CENTER          2

#Define DMPAPER_A4          9           /* A4 210 x 297 mm                    */

#Define PS_SOLID            0
#Define PS_DASH             1
#Define PS_DOT              2
#Define PS_DASHDOT          3
#Define PS_DASHDOTDOT       4
#Define PS_NULL             5
#Define PS_INSIDEFRAME      6

#Define  _LF  Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa   ³ afPrnOP   º Autor ³ Cesar Arneiro (Fictor Consulting)º Data ³ 14/03/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao  ³ Impressao grafica da Ordem de Producao.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Analista Resp. ³   Data   ³ Manutencao Efetuada                                     º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±º                ³   /  /   ³                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function OpGrf()

Local _aArea   := GetArea()
Local cDesc1   := OemToAnsi("Este programa irá emitir a impressão gráfica")
Local cDesc2   := OemToAnsi("das Ordens de Produção, conforme parâmetros.")
Local cDesc3   := OemToAnsi("")
Local aSX1     := {}
Local aSays    := {}
Local aButtons := {}

Private cTitulo   := OemToAnsi("Ordem de Produção")
Private nRec      := 0
Private nOpca     := 0
Private M_PAG     := 0
Private lEnd      := .T.
Private _cOPDe, _cOPAte

Private cPerg := PadR("MTR820",10)

/*aAdd(aSX1, {"GRUPO", "ORDEM", "PERGUNT"  , "VARIAVL", "TIPO", "TAMANHO", "DECIMAL", "GSC", "VALID", "VAR01"   , "F3" , "GRPSXG", "DEF01", "DEF02"     , "DEF03"    , "DEF04", "DEF05"})
aAdd(aSX1, {cPerg  , "01"   , "Da OP?"   , "mv_ch1" , "C"   , 13       , 0        , "G"  , ""     , "mv_par01", "SC2", ""      , ""     , ""          , ""         , ""     , ""     })
aAdd(aSX1, {cPerg  , "02"   , "Ate a OP?", "mv_ch2" , "C"   , 13       , 0        , "G"  , ""     , "mv_par02", "SC2", ""      , ""     , ""          , ""         , ""     , ""     })

cf_PutSX1(cPerg, aSX1)*/
Pergunte(cPerg, .F.)

aAdd(aSays, cDesc1)
aAdd(aSays, cDesc2)
aAdd(aSays, cDesc3)
aAdd(aButtons, {5, .T., {|| Pergunte(cPerg, .T.)}})
aAdd(aButtons, {1, .T., {|| nOpca := 1, FechaBatch()}})
aAdd(aButtons, {2, .T., {|| nOpca := 2, FechaBatch()}})

FormBatch(cTitulo, aSays, aButtons)

If nOpca == 1
	_cOPDe  := mv_par01
	_cOPAte := mv_par02
	
	Processa({|lEnd| fRelat()}, cTitulo)
EndIf

RestArea(_aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa   ³ fRelat    º Autor ³ Cesar Arneiro (Fictor Consulting)º Data ³ 29/03/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao  ³ Processamento da rotina principal.                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fRelat()

Local _aPosBox := {}
Local _cQuery, _nCount, _nCol

Local _lDebug := .F.

Private _cCod    := ""
Private _nAcum     := 0
Private _aPrint    := {}
Private nLin       := 10000
Private cLogo	   := GetSrvProfString("Startpath","")+"logo_metalacre.gif" //verificar
Private _aMargens  := {40, 65, 3100, 2285}	// Top, Left, Bottom, Right
Private _aItens    := {}
Private nLinIni    := 0
Private oPrn, oPen1, oPen2

If !File(cLogo)
	cLogo := "lgrl" + cEmpAnt + ".bmp"
	If !File(cLogo)
		cLogo := "lgrl" + cEmpAnt + cFilAnt + ".bmp"
	EndIf
EndIf

// Valida OP Inicial

If SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+MV_PAR01))
	If SC2->(FieldPos("C2_XDTIMP")) > 0 .And. !Empty(SC2->C2_XDTIMP)
		If !MsgYesNo("Atenção a OP " + MV_PAR01 + " Foi Impressa " + Str(SC2->C2_XQTIMP,2) + " Vez(es) e a Última em " + DtoC(SC2->C2_XDTIMP)+" Continua ?")	
			Return .f.
		Endif
		// Registra Data da Impressao da OP
		If SC2->(FieldPos("C2_XDTIMP")) > 0
			If RecLock("SC2",.f.)
				SC2->C2_XDTIMP	:=	dDataBase
				SC2->C2_XQTIMP	:=	(SC2->C2_XQTIMP + 1)
				SC2->(MsUnlock())
			Endif
		Endif
	Endif
Endif

dUltImp	:= SC2->C2_XDTIMP
nQtdImp := SC2->C2_XQTIMP

oFnt08  := TFont():New("Arial", , 08, , .F., , , , .F., .F.)
oFnt08N := TFont():New("Arial", , 08, , .T., , , , .T., .F.)
oFnt09  := TFont():New("Arial", , 09, , .F., , , , .F., .F.)
oFnt09N := TFont():New("Arial", , 09, , .T., , , , .T., .F.)
oFnt10  := TFont():New("Arial", , 10, , .F., , , , .F., .F.)
oFnt10N := TFont():New("Arial", , 10, , .T., , , , .T., .F.)
oFnt12  := TFont():New("Arial", , 12, , .T., , , , .F., .F.)
oFnt12N := TFont():New("Arial", , 12, , .F., , , , .T., .F.)
oFnt14  := TFont():New("Arial", , 14, , .T., , , , .F., .F.)

oBrush := TBrush():New("", RGB(209, 232, 255))


oPrn := TMSPrinter():New(cTitulo)
oPrn:SetPortrait()
oPrn:SetPage(DMPAPER_A4)
//oPen1 := TPen():New(PS_DASH, 1, , oPrn)
//oPen2 := TPen():New(2 , 1, , oPrn)

// Define conversao Pixel -> Centimetros, para a MsBar
_nLin1Cnt := 1
_nLin2Cnt := 10
_nCol1Cnt := 1
_nCol2Cnt := 10
_nLin1Px := _nLin1Cnt
_nLin2Px := _nLin2Cnt
_nCol1Px := _nCol1Cnt
_nCol2Px := _nCol2Cnt
oPrn:Cmtr2Pix(_nLin1Px, _nCol1Px)
oPrn:Cmtr2Pix(_nLin2Px, _nCol2Px)
_nConvLin := (_nLin2Cnt - _nLin1Cnt) / (_nLin2Px - _nLin1Px)
_nConvCol := (_nCol2Cnt - _nCol1Cnt) / (_nCol2Px - _nCol1Px)

// Define as boxes
//{{Top do box, Left do box, Bottom do box, Imprime Grid, Cor de fundo}}
_aPosBox := {	{  0,    0, 130,  410							, .T., 0					},;	// 01-Logotipo
				{  0,  410, 130, 2220							, .T., RGB(210, 210, 210)	},;	// 02-Titulo
				{130,    0, 220,  750							, .T., 0					},;	// 03-Numero da OP
				{130,  750, 220, 1500							, .T., 0					},;	// 04-Data de emissao
				{130, 1500, 300, _aMargens[4] - _aMargens[2]	, .T., 0					},;	// 05-Codigo de barras
				{220,    0, 300, 1500							, .T., 0					},;	// 06-Cliente
				{300,    0, 380,  700							, .T., 0					},;	// 07-Codigo do produto
				{300,  700, 380, 1200							, .T., 0					},;	// 08-Quantidade
				{300, 1200, 380, 1700						    , .T., 0					},;	// 09-Inicio OP
				{300, 1700, 380, _aMargens[4] - _aMargens[2]	, .T., 0					},;	// 10-Termino OP
				{380,    0, 460, 1500							, .T., 0					},;	// 11-Produto
				{380, 1500, 460, _aMargens[4] - _aMargens[2]	, .T., 0					},;	// 12-Produto PAI
				{460,    0, 540, 1400							, .T., 0					},;	// 13-Personalizacao
				{460, 1400, 540, 1700							, .T., 0					},;	// 14-Regrava
				{460, 1700, 540, _aMargens[4] - _aMargens[2]	, .T., 0					},;	// 15-Cód.Especial
				{540,    0, 620, 0800					     	, .T., 0					},;	// 16-Teste CQ
				{540, 0800, 620, _aMargens[4] - _aMargens[2]	, .T., 0					},;	// 17-Auto Controle
				{620,    0, 700, _aMargens[4] - _aMargens[2]	, .T., 0					},;	// 18-Obs OP:
				{730,    0, 810, _aMargens[4] - _aMargens[2]	, .T., RGB(210, 210, 210)	}}	// 19-Componentes

// Define as impressoes:
//{{Top do box, Left do box, Bottom do box, Right do box, Imprime Grid, Cor de fundo}, {{Top do logo  , Left do logo  , arquivo de bitmap                        }}}	-> para bitmap
//{{Top do box, Left do box, Bottom do box, Right do box, Imprime Grid, Cor de fundo}, {{Top do codigo, Left do codigo, tipo de codigo   , conteudo              }}}	-> para codigo de barras
//{{Top do box, Left do box, Bottom do box, Right do box, Imprime Grid, Cor de fundo}, {{Top do texto , Left do texto , texto            , fonte    , alinhamento}}}	-> para texto
aAdd(_aPrint, {_aPosBox[01], {{_aPosBox[01][1] + 20, _aPosBox[01][2] + 60, cLogo}}})
aAdd(_aPrint, {_aPosBox[02], {{_aPosBox[02][1] + 40, ((_aPosBox[02][4] + _aPosBox[02][2]) / 2), "'ORDEM DE PRODUÇÃO'", oFnt14, PAD_CENTER}}})
aAdd(_aPrint, {_aPosBox[03], {{_aPosBox[03][1] + 20, _aPosBox[03][2] + 20, "'Número: '", oFnt10N, PAD_LEFT}, {_aPosBox[03][1] + 20, _aPosBox[03][2] + 220, "_cCod", oFnt10, PAD_LEFT}}})
aAdd(_aPrint, {_aPosBox[04], {{_aPosBox[04][1] + 20, _aPosBox[04][2] + 20, "'Emissão:'", oFnt10N, PAD_LEFT}, {_aPosBox[04][1] + 20, _aPosBox[04][2] + 220, "DToC(dDataBase)", oFnt10, PAD_LEFT  }}})
aAdd(_aPrint, {_aPosBox[05], {{_nConvLin * (_aPosBox[05][1] + 75), _nConvCol * (_aPosBox[05][2] + 250), "CODE128", "_cCod"}}})

aAdd(_aPrint, {_aPosBox[06], {{_aPosBox[06][1] + 20, _aPosBox[06][2] + 20, "'Cliente:'"       , oFnt10N, PAD_LEFT}	, {_aPosBox[06][1] + 20, _aPosBox[06][2] + 220, "cClient"                            , oFnt09, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[07], {{_aPosBox[07][1] + 20, _aPosBox[07][2] + 20, "'Código: '"       , oFnt10N, PAD_LEFT}	, {_aPosBox[07][1] + 20, _aPosBox[07][2] + 220, "cProduto"                          , oFnt10, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[08], {{_aPosBox[08][1] + 20, _aPosBox[08][2] + 20, "'Quantidade:'"    , oFnt10N, PAD_LEFT}	, {_aPosBox[08][1] + 20, _aPosBox[08][4] - 030, "nQuantid", oFnt10, PAD_RIGHT}}})
aAdd(_aPrint, {_aPosBox[09], {{_aPosBox[09][1] + 20, _aPosBox[09][2] + 20, "'Início Prev.:'"  , oFnt10N, PAD_LEFT}	, {_aPosBox[09][1] + 20, _aPosBox[09][2] + 300, "cInicio"                               , oFnt10, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[10], {{_aPosBox[10][1] + 20, _aPosBox[10][2] + 20, "'Término Prev.: '", oFnt10N, PAD_LEFT}	, {_aPosBox[10][1] + 20, _aPosBox[10][2] + 300, "cFinal"               			  , oFnt10, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[11], {{_aPosBox[11][1] + 20, _aPosBox[11][2] + 20, "'Produto: '"  	  , oFnt10N, PAD_LEFT}	, {_aPosBox[11][1] + 20, _aPosBox[11][2] + 220, "cDescric"                              , oFnt10, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[12], {{_aPosBox[12][1] + 20, _aPosBox[12][2] + 20, "'Prod.Pai: '"     , oFnt10N, PAD_LEFT}	, {_aPosBox[12][1] + 10, _aPosBox[12][2] + 240, "cProdPai"                              , oFnt14, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[13], {{_aPosBox[13][1] + 20, _aPosBox[13][2] + 20, "'Person.:'"  	  , oFnt10N, PAD_LEFT}	, {_aPosBox[13][1] + 20, _aPosBox[13][2] + 220, "cPerson"				                  , oFnt10, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[14], {{_aPosBox[14][1] + 20, _aPosBox[14][2] + 20, "'Regrava: '"	  , oFnt10N, PAD_LEFT}	, {_aPosBox[14][1] + 20, _aPosBox[14][4] - 030, "cRegrav"   , oFnt10, PAD_RIGHT }}})
aAdd(_aPrint, {_aPosBox[15], {{_aPosBox[15][1] + 20, _aPosBox[15][2] + 20, "'Cód.Especial: '" , oFnt10N, PAD_LEFT}	, {_aPosBox[15][1] + 20, _aPosBox[15][2] + 300, "cCodEsp"               			  , oFnt10, PAD_LEFT }}})


aAdd(_aPrint, {_aPosBox[16], {{_aPosBox[16][1] + 20, _aPosBox[16][2] + 20, "'Teste C.Q. Realizado:'"    , oFnt10N, PAD_LEFT}	, {_aPosBox[16][1] + 20, _aPosBox[16][2] + 400, "'(   ) SIM  (   ) NÃO'"                              , oFnt10N, PAD_LEFT }}})
aAdd(_aPrint, {_aPosBox[17], {{_aPosBox[17][1] + 20, _aPosBox[17][2] + 20, "'Autocontrole Realizado:'"  , oFnt10N, PAD_LEFT}	, {_aPosBox[17][1] + 20, _aPosBox[17][2] + 500, "'(   ) SIM  (   ) NÃO'"                              , oFnt10N, PAD_LEFT }}})

aAdd(_aPrint, {_aPosBox[18], {{_aPosBox[18][1] + 20, _aPosBox[18][2] + 20, "'Obs.O.P.: '"  , oFnt10N, PAD_LEFT}	, {_aPosBox[18][1] + 20, _aPosBox[18][2] + 270, "cObsOp"                              , oFnt10, PAD_LEFT }}})

aAdd(_aPrint, {_aPosBox[19], {{_aPosBox[19][1] + 20, ((_aPosBox[19][4] + _aPosBox[19][2]) / 2), "'C O M P O N E N T E S'", oFnt14, PAD_CENTER}}})

aAdd(_aItens, {"Código"    ,  320							, "tOPTmp->CODCOMP"								, PAD_LEFT  })
aAdd(_aItens, {"Descrição" , 1100							, "tOPTmp->DESCCOMP"							, PAD_LEFT  })
aAdd(_aItens, {"Quantidade",  300							, "Transform(tOPTmp->QTDCOMP, '@E 999,999,999')"	, PAD_RIGHT })
aAdd(_aItens, {"Lote"      , _aMargens[4] - _aMargens[2]	, "tOPTmp->LOTECOMP"							, PAD_CENTER})
For _nI := 1 To Len(_aItens) - 1
	_aItens[Len(_aItens), 2] -= _aItens[_nI, 2]
Next

// Define a consulta
_cQuery := "SELECT SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_PRODUTO, SC2.C2_EMISSAO, SC2.C2_QUANT, SC2.C2_XLACRE, SC2.C2_ITEMPV, SC2.C2_OPC, SC2.C2_UM, SC2.C2_DATPRI, SC2.C2_DATPRF, SC2.C2_CLI, SC2.C2_LOJA, SC2.C2_XDESCLI, SC2.C2_OBS, ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),SC5.C5_OBSOP)),'') AS C5_OBSOP, SC2.C2_PEDIDO, SB1.B1_DESC DESCPROD, " + _LF
_cQuery += "			ISNULL(SH1.H1_DESCRI,'') RECURSO, SD4.D4_COD CODCOMP, SD4.D4_QUANT QTDCOMP, SB1_COMP.B1_DESC DESCCOMP, SB1_COMP.B1_UM UMCOMP, SD4.D4_LOCAL LOCCOMP, SD4.D4_LOTECTL LOTECOMP, ISNULL(Z00.Z00_DESC,'') Z00_DESC, ISNULL(Z00.Z00_REGRAV,'') Z00_REGRAV, ISNULL(Z00.Z00_BARRAS,'') Z00_BARRAS " + _LF
_cQuery += "FROM " + RetSQLName("SC2") + " SC2 " + _LF
_cQuery += "	INNER JOIN " + RetSQLName("SB1") + " SB1 " + _LF
_cQuery += "		 ON SB1.B1_FILIAL  = '" + xFilial("SB1") + "' " + _LF
_cQuery += "		AND SB1.B1_COD     = SC2.C2_PRODUTO " + _LF
_cQuery += "		AND SB1.D_E_L_E_T_ = ' ' " + _LF
_cQuery += "	LEFT JOIN " + RetSQLName("SG2") + " SG2 " + _LF
_cQuery += "		 ON SG2.G2_FILIAL  = '" + xFilial("SG2") + "' " + _LF
_cQuery += "		AND SG2.G2_PRODUTO = SC2.C2_PRODUTO " + _LF
_cQuery += "		AND SG2.G2_CODIGO  = SC2.C2_OPERAC " + _LF
_cQuery += "		AND SG2.D_E_L_E_T_ = ' ' " + _LF
_cQuery += "	LEFT JOIN " + RetSQLName("SC5") + " SC5 " + _LF
_cQuery += "		 ON SC5.C5_FILIAL  = '" + xFilial("SC5") + "' " + _LF
_cQuery += "		AND SC5.C5_NUM = SC2.C2_PEDIDO " + _LF
_cQuery += "		AND SC5.D_E_L_E_T_ = ' ' " + _LF
_cQuery += "	LEFT JOIN " + RetSQLName("SH1") + " SH1 " + _LF
_cQuery += "		 ON SH1.H1_FILIAL  = '" + xFilial("SH1") + "' " + _LF
_cQuery += "		AND SH1.H1_CODIGO  = SG2.G2_RECURSO " + _LF
_cQuery += "		AND SH1.D_E_L_E_T_ = ' ' " + _LF
_cQuery += "	LEFT JOIN " + RetSQLName("SD4") + " SD4 " + _LF
_cQuery += "		 ON SD4.D4_FILIAL  = SC2.C2_FILIAL " + _LF
_cQuery += "		AND SD4.D4_OP      = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN " + _LF
_cQuery += "		AND SD4.D_E_L_E_T_ = ' ' " + _LF
_cQuery += "	LEFT JOIN " + RetSQLName("Z00") + " Z00 " + _LF 
_cQuery += "		 ON Z00.Z00_FILIAL  = '" + xFilial("Z00") + "' " + _LF
_cQuery += "		AND Z00.Z00_COD+Z00.Z00_CLI+Z00.Z00_LOJA = SC2.C2_XLACRE+SC2.C2_CLI+SC2.C2_LOJA " + _LF
_cQuery += "		AND Z00.D_E_L_E_T_ = ' ' " + _LF 
_cQuery += "	LEFT JOIN " + RetSQLName("SB1") + " SB1_COMP " + _LF
_cQuery += "		 ON SB1_COMP.B1_FILIAL  = '" + xFilial("SB1") + "' " + _LF
_cQuery += "		AND SB1_COMP.B1_COD     = SD4.D4_COD " + _LF
_cQuery += "		AND SB1_COMP.D_E_L_E_T_ = ' ' " + _LF
_cQuery += "WHERE   SC2.C2_FILIAL  = '" + xFilial("SC2") + "' " + _LF
_cQuery += "	AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN BETWEEN '" + _cOPDe + "' AND '" + _cOPAte + "' " + _LF
_cQuery += "	AND SC2.C2_DATPRF BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' " + _LF
_cQuery += "	AND SC2.C2_EMISSAO BETWEEN '" + DtoS(MV_PAR14) + "' AND '" + DtoS(MV_PAR15) + "' " + _LF
_cQuery += "	AND SC2.D_E_L_E_T_ = ' ' " + _LF
_cQuery += "ORDER BY SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN"

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da OP                                 ³
//³ mv_par02            // Ate a OP                              ³
//³ mv_par03            // Da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Imprime roteiro de operacoes          ³
//³ mv_par06            // Imprime codigo de barras              ³
//³ mv_par07            // Imprime Nome Cientifico               ³
//³ mv_par08            // Imprime Op Encerrada                  ³
//³ mv_par09            // Impr. por Ordem de                    ³
//³ mv_par10            // Impr. OP's Firmes, Previstas ou Ambas ³
//³ mv_par11            // Impr. Item Negativo na Estrutura      ³
//³ mv_par12            // Imprime Lote/Sub-Lote                 ³
//³ mv_par14            // Da Emissao                               ³
//³ mv_par15            // Ate Emissao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If Select("tOPTmp") > 0
	tOPTmp->(dbCloseArea())
EndIf

If _lDebug
	AutoGrLog(_cQuery)
	MostraErro()
EndIf

TCQUERY _cQuery NEW ALIAS "tOPTmp"
tOPTmp->(dbGoTop())
Count To _nCount
ProcRegua(_nCount)	// Total de Elementos da regua

nLin    := 0
tOPTmp->(dbGoTop())

cPedido := ''
cPerson := ''
cRegrav := ''
cCodEsp := ''
cClient := ''
cObsOP  := ''
cOpcion := ''


Do While !tOPTmp->(Eof())

	If Empty(cPedido)
		cPedido := tOPTmp->C2_PEDIDO
		If Empty(tOPTmp->C2_PEDIDO)    
			if !Empty(tOPTmp->C2_XLACRE) .and. !empty(tOPTmp->C2_CLI)
				Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+tOPTmp->C2_XLACRE+tOPTmp->C2_CLI+tOPTmp->C2_LOJA))
				SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+tOPTmp->C2_CLI+tOPTmp->C2_LOJA))
			endif
			SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+tOPTmp->C2_NUM)) 
			SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+tOPTmp->C2_NUM))
		Else           
			SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+tOPTmp->C2_PEDIDO+tOPTmp->C2_ITEMPV)) 
			SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+tOPTmp->C2_PEDIDO))
			If SC5->C5_CLIENTE+SC5->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401')
				Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+SC6->C6_XLACRE+SC5->C5_CLIMTS+SC5->C5_LOJMTS))
				SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIMTS+SC5->C5_LOJMTS))  	
			Else
				Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+SC6->C6_XLACRE+SC6->C6_CLI+SC6->C6_LOJA))
				SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA))  	
			Endif
		Endif 

		cPerson := Z00->Z00_DESC
		cRegrav := Iif(Z00->Z00_REGRAV=='S','S I M','N A O')
		cCodEsp := Iif(Z00->Z00_BARRAS=='1','1D',Iif(Z00->Z00_BARRAS=='2','2D','N A O'))
		cClient := SA1->A1_COD + '/' + SA1->A1_LOJA + ' - ' + SA1->A1_NOME
		cObsOP  := SC5->C5_OBSOP
		If SGA->(dbSetOrder(1), dbSeek(xFilial("SGA")+TOPTMP->C2_OPC))
			cOpcion := SGA->GA_DESCOPC
		Endif
		cProduto := tOPTmp->C2_PRODUTO
		cProdPai := tOPTmp->C2_PRODUTO
		nQuantid := Transform(tOPTmp->C2_QUANT, '@E 999,999,999')
		cInicio  := DToC(SToD(tOPTmp->C2_DATPRI))
		cFinal 	 := DToC(SToD(tOPTmp->C2_DATPRF))
		cDescric := AllTrim(tOPTmp->DESCPROD)+' - ('+AllTrim(cOpcion)+')'
	Endif

	If _cCod <> tOPTmp->(C2_NUM + C2_ITEM + C2_SEQUEN)
		If nLin > 0
			oPrn:EndPage()
		EndIf
		_cCod 	 := tOPTmp->(C2_NUM + C2_ITEM + C2_SEQUEN)
		cProduto := tOPTmp->C2_PRODUTO
		nQuantid := Transform(tOPTmp->C2_QUANT, '@E 999,999,999')
		cInicio  := DToC(SToD(tOPTmp->C2_DATPRI))
		cFinal 	 := DToC(SToD(tOPTmp->C2_DATPRF))
		cDescric := AllTrim(tOPTmp->DESCPROD)+' - ('+AllTrim(cOpcion)+')'

		nLin := Cabecalho()
	EndIf
	
	If nLin >= _aMargens[3]-200
	//	FimPagina(nLin, .T.)
		oPrn:EndPage()
		nLin := Cabecalho()
	EndIf
	
	nLin   += 60
	_nCol  := _aMargens[2]
	
	For _nI := 1 To Len(_aItens)
		oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
		oPrn:Line(nLin, _nCol, nLin + 60, _nCol)

		If _aItens[_nI][4] = PAD_LEFT
			oPrn:Say(nLin + 10, _nCol + 10, &(_aItens[_nI][3]), oFnt09, , , , PAD_LEFT)
		ElseIf _aItens[_nI][4] = PAD_CENTER
			oPrn:Say(nLin + 10, _nCol + (_aItens[_nI][2] / 2), &(_aItens[_nI][3]), oFnt10, , , , PAD_CENTER)
		Else
			oPrn:Say(nLin + 10, _nCol + _aItens[_nI][2] - 10, &(_aItens[_nI][3]), oFnt10, , , , PAD_RIGHT)
		EndIf
		_nCol += _aItens[_nI][2]
	Next
	
	cProduto := TOPTMP->C2_PRODUTO

	tOPTmp->(dbSkip())

	If _cCod <> tOPTmp->(C2_NUM + C2_ITEM + C2_SEQUEN)
		
		_aRecursos := {}
	
		// Impressão dos Recursos Ferramentas e Operações
			
		If SG2->(dbSetOrder(3), dbSeek(xFilial("SG2")+cProduto))
			While SG2->(!Eof()) .And. SG2->G2_FILIAL == xFilial("SG2") .And. SG2->G2_PRODUTO == cProduto
				SH1->(dbSeek(xFilial("SH1")+SG2->G2_RECURSO))
				
				AAdd(_aRecursos,{SG2->G2_RECURSO,SH1->H1_DESCRI,SG2->G2_OPERAC,SG2->G2_DESCRI})
					
				SG2->(dbSkip(1))
							
			Enddo
		Endif
		If Len(_aRecursos) > 0
			nLin := Recursos(nLin,_aRecursos)
		Endif
	Endif
	
EndDo

//FimPagina(nLin)

oPrn:Preview()

tOPTmp->(dbCloseArea())

Return

Static Function Cabecalho(_lPrnComp)

Local nLin, _nI

Default _lPrnComp := .T.

oPrn:StartPage()
oPrn:Box(_aMargens[1] - 10, _aMargens[2] - 10, _aMargens[3] + 10, _aMargens[4] + 10)
nLin := _aMargens[1]

For _nI := 1 To Len(_aPrint)
	If _lPrnComp .Or. _nI <> Len(_aPrint)
		If _aPrint[_nI][1][6] <> 0
			oBrushTmp := TBrush():New("", _aPrint[_nI][1][6])
			oPrn:FillRect({nLin + _aPrint[_nI][1][1], _aPrint[_nI][1][2] + _aMargens[2], nLin + _aPrint[_nI][1][3], _aPrint[_nI][1][4] + _aMargens[2]}, oBrushTmp)
		EndIf
		If _aPrint[_nI][1][5]
			oPrn:Box(nLin + _aPrint[_nI][1][1], _aPrint[_nI][1][2] + _aMargens[2], nLin + _aPrint[_nI][1][3], _aPrint[_nI][1][4] + _aMargens[2])
		EndIf
		
		For _nJ := 1 To Len(_aPrint[_nI][2])
			If Len(_aPrint[_nI][2][_nJ]) = 3	// Logotipo
				oPrn:SayBitmap(nLin + _aPrint[_nI][2][_nJ][1], _aPrint[_nI][2][_nJ][2] + _aMargens[2], _aPrint[_nI][2][_nJ][3], 300, 100)
			ElseIf Len(_aPrint[_nI][2][_nJ]) = 4	// Codigo de Barras
				MsBar3(_aPrint[_nI][2][_nJ][3], _aPrint[_nI][2][_nJ][1], _aPrint[_nI][2][_nJ][2], &(_aPrint[_nI][2][_nJ][4]), oPrn, , , , .02960, 0.9, .F., , "C", .F.)
			Else
				oPrn:Say(nLin + _aPrint[_nI][2][_nJ][1], _aPrint[_nI][2][_nJ][2] + _aMargens[2], &(_aPrint[_nI][2][_nJ][3]), _aPrint[_nI][2][_nJ][4], , , , _aPrint[_nI][2][_nJ][5])
			EndIf
		Next
	EndIf
Next

//_cCod   := tOPTmp->(C2_NUM + C2_ITEM + C2_SEQUEN)

If _lPrnComp
	nLin    += _aPrint[Len(_aPrint)][1][3] //+ 20
	nLinIni := nLin
	
	oBrushTmp := TBrush():New("", RGB(230, 230, 230))
	oPrn:FillRect({nLin, _aMargens[2], nLin + 80, _aMargens[4]}, oBrushTmp)
	oPrn:Box(nLin, _aMargens[2], nLin + 80, _aMargens[4])
	
	_nCol := _aMargens[2]
	For _nI := 1 To Len(_aItens)
		oPrn:Say(nLin + 20, _nCol + (_aItens[_nI][2] / 2), _aItens[_nI][1], oFnt10N, , , , PAD_CENTER)
		_nCol += _aItens[_nI][2]
	Next
Else
	nLin += _aPrint[Len(_aPrint)][1][1]
EndIf

oBrushTmp := TBrush():New("", RGB(230, 230, 230))
oPrn:FillRect({_aMargens[3], _aMargens[2], _aMargens[3] - 80, 1000}, oBrushTmp)
oPrn:Box(_aMargens[3], _aMargens[2], _aMargens[3] - 80, 1000)

oPrn:Say(_aMargens[3]-60, _aMargens[2]+20, 'Endereçamento: ', oFnt10n, , , , PAD_LEFT)

oPrn:Say(_aMargens[3]+20, _aMargens[2]+20, 'Ultima Impressão: ' + DtoC(dUltImp) + ' - Qtde Impressões: ' + Str(nQtdImp,3), oFnt08, , , , PAD_LEFT)

nLin+=20
Return(nLin)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa   ³ cf_PutSx1 ³ Autor ³ Andre Carralero                   ³ Data ³ 13/03/06 º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ¶±±
±±º Descricao  ³ Cria pergunta no SX1.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Analista Resp. ³   Data   ³ Manutencao Efetuada                                      º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±º                ³   /  /   ³                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function cf_PutSx1(cPerg, aSx1, lExcl)

Local nLin, nCol, cCampo, _nPos

lExcl := If(lExcl == Nil, .F., lExcl)
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))

SX1->(dbSetOrder(1))

SX1->(dbSeek(cPerg))
While !SX1->(Eof()) .And. AllTrim(SX1->X1_GRUPO) == AllTrim(cPerg)
	_nPos := aScan(aSx1, {|X| X[2] == SX1->X1_ORDEM})
	
	If _nPos = 0 .Or. lExcl
		SX1->(RecLock("SX1", .F., .F.))
			SX1->(dbDelete())
		SX1->(MsUnLock())
	Else
		For nCol := 2 To Len(aSX1[_nPos])
			If SX1->&("X1_" + aSX1[1, nCol]) <> aSX1[_nPos, nCol]
				If ValType(aSX1[_nPos, nCol]) = "C"
					If AllTrim(SX1->&("X1_" + aSX1[1, nCol])) <> AllTrim(aSX1[_nPos, nCol])
						SX1->(RecLock("SX1", .F., .F.))
							SX1->(dbDelete())
						SX1->(MsUnLock())
						Exit
					EndIf
				Else
					SX1->(RecLock("SX1", .F., .F.))
						SX1->(dbDelete())
					SX1->(MsUnLock())
					Exit
				EndIf
			EndIf
		Next
	EndIf
	
	SX1->(dbSkip())
End
If !lExcl
	For nLin := 2 To Len(aSX1)
		If !SX1->(dbSeek(cPerg + aSX1[nLin, 2]))
			SX1->(RecLock("SX1", .T.))
			For nCol := 1 To Len(aSX1[1])
				cCampo := "X1_" + aSX1[1, nCol]
				SX1->(FieldPut(SX1->(FieldPos(cCampo)), aSx1[nLin,nCol]))
			Next nCol
			SX1->(MsUnLock())
		EndIf
	Next nLin
EndIf

Return


Static Function Recursos(nLin, _aRecursos)
Local _nCol     := _aMargens[2]
Local _nLinPerd := 3
Local _nI, _nPos, _nLinObs

// Recursos

nLin += 060
If nLin >= _aMargens[3]-200
	oPrn:EndPage()
	nLin := Cabecalho(.F.)
EndIf

oBrshTmp1 := TBrush():New("", RGB(210, 210, 210))
oBrshTmp2 := TBrush():New("", RGB(230, 230, 230))
oPrn:FillRect({nLin, _aMargens[2], nLin + 80, _aMargens[4]}, oBrshTmp1)
oPrn:Box(nLin, _aMargens[2], nLin + 80, _aMargens[4])
oPrn:Say(nLin + 20, (_aMargens[2] + _aMargens[4]) / 2, "R E C U R S O S", oFnt14, , , , PAD_CENTER)
nLin += 80


For _nJ := 1 To Len(_aRecursos)
	oPrn:FillRect({nLin, _aMargens[2], nLin + 60, _aMargens[4]}, oBrshTmp2)
	oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
	nLin += 10
	oPrn:Say(nLin,0070	,'Recurso', oFnt10N, , , , PAD_LEFT)
	oPrn:Say(nLin,0400	,'Descrição', oFnt10N, , , , PAD_LEFT)
	oPrn:Say(nLin,1200	,'Operação', oFnt10N, , , , PAD_LEFT)
	oPrn:Say(nLin,1400	,'Descrição', oFnt10N, , , , PAD_LEFT)
	
	nLin += 50

	If nLin >= _aMargens[3]-200
		oPrn:EndPage()
		nLin := Cabecalho(.F.)

		oPrn:FillRect({nLin, _aMargens[2], nLin + 60, _aMargens[4]}, oBrshTmp2)
		oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
		nLin += 10
		oPrn:Say(nLin,0070	,'Recurso', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,0400	,'Descrição', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,1200	,'Operação', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,1400	,'Descrição', oFnt10N, , , , PAD_LEFT)
		
		nLin += 50

	EndIf

	oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
	oPrn:Line(nLin, 0390, nLin + 60, 0390)
	oPrn:Line(nLin, 1190, nLin + 60, 1190)
	oPrn:Line(nLin, 1390, nLin + 60, 1390)

	oPrn:Say(nLin+10, 0070, Left(_aRecursos[_nJ,1],Len(AllTrim(_aRecursos[_nJ,1]))-2), oFnt10, , , , PAD_LEFT)
	oPrn:Say(nLin+10, 0400, _aRecursos[_nJ,2], oFnt09, , , , PAD_LEFT)
	oPrn:Say(nLin+10, 1200, _aRecursos[_nJ,3], oFnt10, , , , PAD_LEFT)
	oPrn:Say(nLin+10, 1400, _aRecursos[_nJ,4], oFnt10, , , , PAD_LEFT)
	
	nLin += 60
	
	oPrn:FillRect({nLin, _aMargens[2], nLin + 60, _aMargens[4]}, oBrshTmp2)
	oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
	nLin += 10
	oPrn:Say(nLin,70	,'Inicio Real', oFnt10N, , , , PAD_LEFT)
	oPrn:Say(nLin,500	,'Término Final', oFnt10N, , , , PAD_LEFT)
	oPrn:Say(nLin,1100	,'Quantidade', oFnt10N, , , , PAD_LEFT)
	oPrn:Say(nLin,1500	,'Colaborador(a)', oFnt10N, , , , PAD_LEFT)

	nLin += 50
	
	If nLin >= _aMargens[3]-200
		oPrn:EndPage()
		nLin := Cabecalho(.F.)

		oPrn:FillRect({nLin, _aMargens[2], nLin + 60, _aMargens[4]}, oBrshTmp2)
		oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
		nLin += 10
		oPrn:Say(nLin,70	,'Inicio Real', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,500	,'Término Final', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,1100	,'Quantidade', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,1500	,'Colaborador(a)', oFnt10N, , , , PAD_LEFT)
	
		nLin += 50
		
	EndIf

	nTotLinR := 3
	lRefugo := .T.
	If 'COL'$_aRecursos[_nJ,1]
		nTotLinR := 6
		lRefugo := .F.
	ElseIf 'MLA'$_aRecursos[_nJ,1]
		nTotLinR := 7
	ElseIf 'CCA'$_aRecursos[_nJ,1]
		nTotLinR := 7
	ElseIf 'PEX'$_aRecursos[_nJ,1]
		nTotLinR := 7
	ElseIf 'MON'$_aRecursos[_nJ,1]
		nTotLinR := 6
	ElseIf 'SEL'$_aRecursos[_nJ,1]
		nTotLinR := 2
		lRefugo := .F.
	Endif

	For nI := 1 To nTotLinR
		If nLin >= _aMargens[3]-200
			oPrn:EndPage()
			nLin := Cabecalho(.F.)
	
			oPrn:FillRect({nLin, _aMargens[2], nLin + 60, _aMargens[4]}, oBrshTmp2)
			oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
			nLin += 10
			oPrn:Say(nLin,70	,'Inicio Real', oFnt10N, , , , PAD_LEFT)
			oPrn:Say(nLin,500	,'Término Final', oFnt10N, , , , PAD_LEFT)
			oPrn:Say(nLin,1100	,'Quantidade', oFnt10N, , , , PAD_LEFT)
			oPrn:Say(nLin,1500	,'Colaborador(a)', oFnt10N, , , , PAD_LEFT)
		
			nLin += 50
			
		EndIf

		oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
		oPrn:Line(nLin, 0490, nLin + 60, 0490)
		oPrn:Line(nLin, 1090, nLin + 60, 1090)
		oPrn:Line(nLin, 1490, nLin + 60, 1490)
		
		oPrn:Say(nLin+24,075,'____/____/_____   _____:_____', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin+24,505,'____/____/_____   _____:_____', oFnt10N, , , , PAD_LEFT)
		
		nLin += 60
	Next

	If nLin >= _aMargens[3]-200
		oPrn:EndPage()
		nLin := Cabecalho(.F.)
	EndIf

	If lRefugo
		oPrn:FillRect({nLin, _aMargens[2], nLin + 60, _aMargens[4]}, oBrshTmp2)
		oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
		nLin += 10
		oPrn:Say(nLin,70	,'Refugo', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,700	,'Lote', oFnt10N, , , , PAD_LEFT)
		oPrn:Say(nLin,1400	,'Quantidade', oFnt09N, , , , PAD_LEFT)
		oPrn:Say(nLin,1900	,'Reaproveitável', oFnt09N, , , , PAD_LEFT)
	
		nLin += 50
	
		If nLin >= _aMargens[3]-200
			oPrn:EndPage()
			nLin := Cabecalho(.F.)
	
			oPrn:FillRect({nLin, _aMargens[2], nLin + 60, _aMargens[4]}, oBrshTmp2)
			oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
			nLin += 10
			oPrn:Say(nLin,70	,'Refugo', oFnt10N, , , , PAD_LEFT)
			oPrn:Say(nLin,700	,'Lote', oFnt10N, , , , PAD_LEFT)
			oPrn:Say(nLin,1400	,'Quantidade', oFnt09N, , , , PAD_LEFT)
			oPrn:Say(nLin,1900	,'Reaproveitável', oFnt09N, , , , PAD_LEFT)
	
			nLin += 50
	
		EndIf
	
		oPrn:Box(nLin, _aMargens[2], nLin + 60, _aMargens[4])
		oPrn:Line(nLin, 0690, nLin + 60, 0690)
		oPrn:Line(nLin, 1390, nLin + 60, 1390)
		oPrn:Line(nLin, 1890, nLin + 60, 1890)
		
		nLin += 10
	
		oPrn:Say(nLin+10, 1920, '(  ) Sim  (  ) Não ', oFnt10n, , , , PAD_LEFT)
	Endif
	nLin+=50
Next
nLin-=90
Return nLin

