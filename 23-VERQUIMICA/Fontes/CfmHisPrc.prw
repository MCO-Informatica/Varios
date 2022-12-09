#Include "Protheus.Ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmHisPrc  | Autor: Celso Ferrone Martins | Data: 06/07/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmHisPrc(cCodProd)

Local aCpoZ03  := {}
Local aCpoZ15  := {}
Local aCpoEmb  := {}
Local aHeadZ03 := {}
Local aHeadZ15 := {}
Local aHeadEmb := {}

////////////////////////////////////////////////////////////////////////
Aadd(aCpoZ15, {"Z15_COD"    , "C", 15, 0})
Aadd(aCpoZ15, {"Z15_REVISA" , "C", 04, 0})
Aadd(aCpoZ15, {"Z15_UM"     , "C", 02, 0})
Aadd(aCpoZ15, {"Z15_MOEDA"  , "C", 01, 0})
Aadd(aCpoZ15, {"Z15_DATAIN" , "D", 08, 0})
Aadd(aCpoZ15, {"Z15_DATAAL" , "D", 08, 0})
Aadd(aCpoZ15, {"Z15_DENSID" , "N", 15, 6})
Aadd(aCpoZ15, {"Z15_TXMOED" , "N", 11, 4})
Aadd(aCpoZ15, {"Z15_DATACO" , "D", 08, 0})
Aadd(aCpoZ15, {"Z15_DTRCOM" , "D", 08, 0})
Aadd(aCpoZ15, {"Z15_REFCOM" , "N", 12, 2})
Aadd(aCpoZ15, {"Z15_FRETEC" , "N", 12, 2})
Aadd(aCpoZ15, {"Z15_MARGEA" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_MARGEB" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_MARGEC" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_MARGED" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_MARGEE" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_CUSOPE" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_CODMP"  , "C", 15, 0})
Aadd(aCpoZ15, {"Z15_CODEM"  , "C", 15, 0})
Aadd(aCpoZ15, {"Z15_PICMMP" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_PIPIMP" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_PICMEM" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_PIPIEM" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_CUSTO"  , "N", 12, 2})
Aadd(aCpoZ15, {"Z15_PEXTRA" , "N", 06, 2})
Aadd(aCpoZ15, {"Z15_VEXTRA" , "N", 12, 2})
Aadd(aCpoZ15, {"Z15_ORIGEM" , "C", 08, 0})
Aadd(aCpoZ15, {"Z15_REVUSR" , "C", 30, 0})
Aadd(aCpoZ15, {"Z15_REVDAT" , "D", 08, 0})
Aadd(aCpoZ15, {"Z15_REVTIM" , "C", 08, 0})
Aadd(aCpoZ15, {"Z15_VQEMCS" , "C", 01, 0})
Aadd(aCpoZ15, {"Z15_B1MSBL" , "C", 01, 0})

//Aadd(aHeadZ15, {"Z15_COD"    ,, "Produto"      , "@!"})
//Aadd(aHeadZ15, {"Z15_REVISA" ,, "Revisao"      , "@!"})
//Aadd(aHeadZ15, {"Z15_DATAIN" ,, "Data Criacao" , "@D"})
//Aadd(aHeadZ15, {"Z15_MARGEA" ,, "Marg.Lucro A" , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_MARGEB" ,, "Marg.Lucro B" , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_MARGEC" ,, "Marg.Lucro C" , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_MARGED" ,, "Marg.Lucro D" , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_MARGEE" ,, "Marg.Lucro E" , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_CODMP"  ,, "Mat. Prima"   , "@!"})
//Aadd(aHeadZ15, {"Z15_CODEM"  ,, "Embalagem"    , "@!"})
//Aadd(aHeadZ15, {"Z15_ORIGEM" ,, "Origem"       , "@!"})
//Aadd(aHeadZ15, {"Z15_PEXTRA" ,, "%Extra"       , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_VEXTRA" ,, "Valor Extra"  , "@E 999,999,999.99"})
//Aadd(aHeadZ15, {"Z15_PICMEM" ,, "%Icms Embal." , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_PIPIEM" ,, "%Ipi Embal."  , "@E 999.99"})
//Aadd(aHeadZ15, {"Z15_CUSTO"  ,, "Custo Embal." , "@E 999,999,999.99"})

Aadd(aHeadZ15, {"Z15_DATAAL" ,, "Dt Alteracao" , "@D"})
Aadd(aHeadZ15, {"Z15_UM"     ,, "UM"           , "@!"})
Aadd(aHeadZ15, {"Z15_MOEDA"  ,, "Moeda"        , "@!"})
Aadd(aHeadZ15, {"Z15_DENSID" ,, "Densidade"    , "@E 99,999,999.999999"})
Aadd(aHeadZ15, {"Z15_TXMOED" ,, "Taxa moeda"   , "@E 999,999.9999"})
Aadd(aHeadZ15, {"Z15_DATACO" ,, "Data Cotacao" , "@D"})
Aadd(aHeadZ15, {"Z15_REFCOM" ,, "Val.Ref.Comp" , "@E 999,999,999.99"})
Aadd(aHeadZ15, {"Z15_DTRCOM" ,, "Dt.Rf.Compra" , "@D"})
Aadd(aHeadZ15, {"Z15_FRETEC" ,, "Frete Compra" , "@E 999,999,999.99"})
Aadd(aHeadZ15, {"Z15_CUSOPE" ,, "Custo Operac" , "@E 999.99"})
Aadd(aHeadZ15, {"Z15_PICMMP" ,, "%Icms MP"     , "@E 999.99"})
Aadd(aHeadZ15, {"Z15_PIPIMP" ,, "%IPI MP"      , "@E 999.99"})
Aadd(aHeadZ15, {"Z15_REVUSR" ,, "Usr. Revisao" , "@!"})
Aadd(aHeadZ15, {"Z15_REVDAT" ,, "Data Revisao" , "@D"})
Aadd(aHeadZ15, {"Z15_REVTIM" ,, "Hora Revisao" , "@!"})
Aadd(aHeadZ15, {"Z15_VQEMCS" ,, "Custo Embal." , "@!"})
Aadd(aHeadZ15, {"Z15_B1MSBL" ,, "Blq.Produto"  , "@!"})

If Select("TRBZ15") > 0
	TRBZ15->(DbCloseArea())
EndIf

cNomeTRBZ15 := CriaTrab(aCpoZ15, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTRBZ15, "TRBZ15", .F., .F.)
cIndTRBZ15 := CriaTrab(NIL,.F.)
IndRegua("TRBZ15",cIndTRBZ15,"Z15_REVISA",,,"Selecionando Registros...")

////////////////////////////////////////////////////////////////////////
Aadd(aCpoEmb, {"EMBALAGEM"   , "C", 15, 0})
Aadd(aCpoEmb, {"DESCRICAO"   , "C", 30, 0})
Aadd(aCpoEmb, {"CAPACIDADE"  , "N", 12, 2})
Aadd(aCpoEmb, {"VALOR"       , "N", 12, 2})
Aadd(aCpoEmb, {"EXTRAPER"    , "N", 12, 2})
Aadd(aCpoEmb, {"EXTRAVAL"    , "N", 12, 2})
Aadd(aCpoEmb, {"FRETEENT"    , "N", 12, 2})
Aadd(aCpoEmb, {"CUSTO1"      , "N", 12, 2})
Aadd(aCpoEmb, {"EMBICMS"     , "N", 12, 2})
Aadd(aCpoEmb, {"EMBIPI"      , "N", 12, 2})

Aadd(aHeadEmb, {"EMBALAGEM"  ,, "Embalagem"  , "@!"})
Aadd(aHeadEmb, {"DESCRICAO"  ,, "Descricao"  , "@!"})
Aadd(aHeadEmb, {"CAPACIDADE" ,, "Capacidade" , "@E 999,999,999.99"})
Aadd(aHeadEmb, {"VALOR"      ,, "$ Embalagem", "@E 999,999,999.99"})
Aadd(aHeadEmb, {"EXTRAPER"   ,, "% Extra"    , "@E 999,999,999.99"})
Aadd(aHeadEmb, {"EXTRAVAL"   ,, "$ Extra"    , "@E 999,999,999.99"})
Aadd(aHeadEmb, {"FRETEENT"   ,, "Frete Ent." , "@E 999,999,999.99"})
Aadd(aHeadEmb, {"CUSTO1"     ,, "1o Custo"   , "@E 999,999,999.99"})
Aadd(aHeadEmb, {"EMBICMS"    ,, "% ICMS"     , "@E 999,999,999.99"})
Aadd(aHeadEmb, {"EMBIPI"     ,, "% IPI"      , "@E 999,999,999.99"})

If Select("TRBEMB") > 0
	TRBEMB->(DbCloseArea())
EndIf

cNomeTRBEMB := CriaTrab(aCpoEmb, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTRBEMB, "TRBEMB", .F., .F.)
cIndTRBEMB := CriaTrab(NIL,.F.)

////////////////////////////////////////////////////////////////////////
Aadd(aCpoZ03, {"Z03_COD"     , "C", 15, 0})
Aadd(aCpoZ03, {"Z03_DESC"    , "C", 30, 0})
Aadd(aCpoZ03, {"Z03_REVISA"  , "C", 04, 0})
Aadd(aCpoZ03, {"Z03_UM"      , "C", 02, 0})
Aadd(aCpoZ03, {"Z03_MOEDA"   , "C", 01, 0})
Aadd(aCpoZ03, {"Z03_TABELA"  , "C", 01, 0})
Aadd(aCpoZ03, {"Z03_MARGEM"  , "N", 06, 2})
Aadd(aCpoZ03, {"Z03_FRTTON"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_FRTCUB"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_CAPACI"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_CUSTOE"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_FREENT"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_CUSTO1"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_VALVEN"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_VALCAL"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_MARKUP"  , "N", 12, 4})
Aadd(aCpoZ03, {"Z03_VALICM"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_PISCOF"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_CUSOPE"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_CUSTO2"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_LUCBRU"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_VALIR"   , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_LUCLIQ"  , "N", 12, 2})
Aadd(aCpoZ03, {"Z03_ORIGEM"  , "C", 08, 0})
Aadd(aCpoZ03, {"Z03_REVUSR"  , "C", 30, 0})
Aadd(aCpoZ03, {"Z03_REVDAT"  , "D", 08, 0})

Aadd(aHeadZ03, {"Z03_TABELA" ,, "Tabela"       , "@!"})
Aadd(aHeadZ03, {"Z03_MARGEM" ,, "Margem Tabel" , "@E 999.99"})
Aadd(aHeadZ03, {"Z03_VALVEN" ,, "Valor Venda"  , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_VALCAL" ,, "Tb.Preco"     , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_MARKUP" ,, "MarkUp"       , "@E 9,999,999.9999"})
Aadd(aHeadZ03, {"Z03_VALICM" ,, "Val. ICMS"    , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_PISCOF" ,, "Vl.Pis/Cofin" , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_CUSOPE" ,, "Custo Operac" , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_CUSTO2" ,, "Seg.Custo"    , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_LUCBRU" ,, "Lucro Bruto"  , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_VALIR"  ,, "Valor IR"     , "@E 999,999,999.99"})
Aadd(aHeadZ03, {"Z03_LUCLIQ" ,, "Lucro Liquid" , "@E 999,999,999.99"})

//Aadd(aHeadZ03, {"Z03_COD"    ,, "Produto"      , "@!"})
//Aadd(aHeadZ03, {"Z03_DESC"   ,, "Descricao"    , "@!"})
//Aadd(aHeadZ03, {"Z03_REVISA" ,, "Revisao"      , "@!"})
//Aadd(aHeadZ03, {"Z03_UM"     ,, "UM"           , "@!"})
//Aadd(aHeadZ03, {"Z03_MOEDA"  ,, "Moeda"        , "@!"})
//Aadd(aHeadZ03, {"Z03_FRTTON" ,, "Frete Tonela" , "@E 999,999,999.99"})
//Aadd(aHeadZ03, {"Z03_FRTCUB" ,, "Frete M.Cubi" , "@E 999,999,999.99"})
//Aadd(aHeadZ03, {"Z03_CAPACI" ,, "Capacidade"   , "@E 999,999,999.99"})
//Aadd(aHeadZ03, {"Z03_CUSTOE" ,, "Custo Embal." , "@E 999,999,999.99"})
//Aadd(aHeadZ03, {"Z03_FREENT" ,, "Frete Entreg" , "@E 999,999,999.99"})
//Aadd(aHeadZ03, {"Z03_CUSTO1" ,, "Pri.Custo"    , "@E 999,999,999.99"})
//Aadd(aHeadZ03, {"Z03_ORIGEM" ,, "Origem"       , "@!"})
//Aadd(aHeadZ03, {"Z03_REVUSR" ,, "Usr. Revisao" , "@!"})
//Aadd(aHeadZ03, {"Z03_REVDAT" ,, "Data Revisao" , "@D"})

If Select("TRBZ03") > 0
	TRBZ03->(DbCloseArea())
EndIf

cNomeTRBZ03 := CriaTrab(aCpoZ03, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTRBZ03, "TRBZ03", .F., .F.)
cIndTRBZ03 := CriaTrab(NIL,.F.)
IndRegua("TRBZ03",cIndTRBZ03,"Z03_TABELA",,,"Selecionando Registros...")

CfmZ15Z03(cCodProd)

Define MsDialog oDlgComFat TITLE "Historico de Precos" From 001,001 To 550,1200 OF oMainWnd PIXEL

oDlgComFat:lEscClose := .F. // Desabilita fechar apertando a tecla escape ESC.

x1 := 0
x2 := 133

y1 := 134
y2 := 176

z1 := 177
z2 := 253

//@ 000,001 To 167,599 Label "Hitoricos" Pixel Of oDlgComFat
//oMrkS15 := MsSelect():New("TRBZ15", "", "", aHeadZ15, , , {008, 004, 164, 596})
@ x1,001 To x2,599 Label "Hitoricos" Pixel Of oDlgComFat
oMrkS15 := MsSelect():New("TRBZ15", "", "", aHeadZ15, , , {x1+8, 004, x2-4, 596})
oMrkS15:oBrowse:Refresh()
oMrkS15:oBrowse:bLDblClick:={|| fCfmZ03(TRBZ15->Z15_COD,TRBZ15->Z15_REVISA)}
oMrkS15:oBrowse:cToolTip := "[ Um duplo click para listar o historico]"

@ y1,001 To y2,599 Label "Embalagem"   Pixel Of oDlgComFat
oMrkEmb := MsSelect():New("TRBEMB", "", "", aHeadEmb, , , {y1+8, 004, y2-4, 596})
oMrkEmb:oBrowse:Refresh()

@ z1,001 To z2,599 Label "Tabela de Preco"   Pixel Of oDlgComFat
oMrkZ03 := MsSelect():New("TRBZ03", "", "", aHeadZ03, , , {z1+8, 004, z2-4, 596})
oMrkZ03:oBrowse:Refresh()

@ 257,560 Button "Encerrar" Size 040,010 Action f2CfmClose() Pixel Of oDlgComFat

Activate MsDialog oDlgComFat Centered

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmZ15Z03  | Autor: Celso Ferrone Martins | Data: 07/01/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmZ15Z03(cCodProd)

TRBZ15->(DbGoTop())
While !TRBZ15->(Eof())
	RecLock("TRBZ15",.F.)
	TRBZ15->(DbDelete())
	MsUnLock()
	TRBZ15->(DbSkip())
EndDo

TRBZ03->(DbGoTop())
While !TRBZ03->(Eof())
	RecLock("TRBZ03",.F.)
	TRBZ03->(DbDelete())
	MsUnLock()
	TRBZ03->(DbSkip())
EndDo

TRBEMB->(DbGoTop())
While !TRBEMB->(Eof())
	RecLock("TRBEMB",.F.)
	TRBEMB->(DbDelete())
	MsUnLock()
	TRBEMB->(DbSkip())
EndDo

cQuery := " SELECT "
cQuery += "   * "
cQuery += " FROM "+RetSqlName("Z15")+" Z15 "
cQuery += " WHERE "
cQuery += "   Z15.D_E_L_E_T_ <> '*' "
cQuery += "   AND Z15_FILIAL  = '"+xFilial("Z15")+"' " 
cQuery += "   AND Z15_COD     = '"+cCodProd+"' "
cQuery += " ORDER BY Z15_COD, Z15_REVISA "

cQuery := ChangeQuery(cQuery)

If Select("TMPZ15") > 0 
	TMPZ15->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPZ15"

While !TMPZ15->(Eof())

	RecLock("TRBZ15",.T.)
	TRBZ15->Z15_COD    := TMPZ15->Z15_COD
	TRBZ15->Z15_REVISA := TMPZ15->Z15_REVISA
	TRBZ15->Z15_UM     := TMPZ15->Z15_UM
	TRBZ15->Z15_MOEDA  := TMPZ15->Z15_MOEDA
	TRBZ15->Z15_DATAIN := sTod(TMPZ15->Z15_DATAIN)
	TRBZ15->Z15_DATAAL := sTod(TMPZ15->Z15_DATAAL)
	TRBZ15->Z15_DENSID := TMPZ15->Z15_DENSID
	TRBZ15->Z15_TXMOED := TMPZ15->Z15_TXMOED
	TRBZ15->Z15_DATACO := sTod(TMPZ15->Z15_DATACO)
	TRBZ15->Z15_DTRCOM := sTod(TMPZ15->Z15_DTRCOM)
	TRBZ15->Z15_REFCOM := TMPZ15->Z15_REFCOM
	TRBZ15->Z15_FRETEC := TMPZ15->Z15_FRETEC
	TRBZ15->Z15_MARGEA := TMPZ15->Z15_MARGEA
	TRBZ15->Z15_MARGEB := TMPZ15->Z15_MARGEB
	TRBZ15->Z15_MARGEC := TMPZ15->Z15_MARGEC
	TRBZ15->Z15_MARGED := TMPZ15->Z15_MARGED
	TRBZ15->Z15_MARGEE := TMPZ15->Z15_MARGEE
	TRBZ15->Z15_CUSOPE := TMPZ15->Z15_CUSOPE
	TRBZ15->Z15_CODMP  := TMPZ15->Z15_CODMP
	TRBZ15->Z15_CODEM  := TMPZ15->Z15_CODEM
	TRBZ15->Z15_PICMMP := TMPZ15->Z15_PICMMP
	TRBZ15->Z15_PIPIMP := TMPZ15->Z15_PIPIMP
	TRBZ15->Z15_PICMEM := TMPZ15->Z15_PICMEM
	TRBZ15->Z15_PIPIEM := TMPZ15->Z15_PIPIEM
	TRBZ15->Z15_CUSTO  := TMPZ15->Z15_CUSTO
	TRBZ15->Z15_PEXTRA := TMPZ15->Z15_PEXTRA
	TRBZ15->Z15_VEXTRA := TMPZ15->Z15_VEXTRA
	TRBZ15->Z15_ORIGEM := TMPZ15->Z15_ORIGEM
	TRBZ15->Z15_REVUSR := TMPZ15->Z15_REVUSR
	TRBZ15->Z15_REVDAT := sTod(TMPZ15->Z15_REVDAT)	
	TRBZ15->Z15_REVTIM := TMPZ15->Z15_REVTIM
	TRBZ15->Z15_VQEMCS := TMPZ15->Z15_VQEMCS
	TRBZ15->Z15_B1MSBL := TMPZ15->Z15_B1MSBL
	MsUnLock()

	TMPZ15->(DbSkip())
EndDo

If Select("TMPZ15") > 0 
	TMPZ15->(DbCloseArea())
EndIf

TRBZ15->(DbGoTop())
TRBZ03->(DbGoTop())

If TRBZ15->(Eof())
	RecLock("TRBZ15",.T.)
	MsUnLock()
	TRBZ15->(DbGoTop())
EndIf
If TRBZ03->(Eof())
	RecLock("TRBZ03",.T.)
	MsUnLock()
	TRBZ03->(DbGoTop())
EndIf
If TRBEMB->(Eof())
	RecLock("TRBEMB",.T.)
	MsUnLock()
	TRBEMB->(DbGoTop())
EndIf
	
Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: f2CfmClose | Autor: Celso Ferrone Martins | Data: 07/01/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function f2CfmClose()

If Select("TRBZ15") > 0
	TRBZ15->(DbCloseArea())
EndIf

If Select("TRBZ03") > 0
	TRBZ03->(DbCloseArea())
EndIf

close(oDlgComFat)

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: fCfmZ03    | Autor: Celso Ferrone Martins | Data: 06/07/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fCfmZ03(cZ15COD,cZ15REVISA)

Local cQuery := ""

TRBZ03->(DbGoTop())
While !TRBZ03->(Eof())
	RecLock("TRBZ03",.F.)
	TRBZ03->(DbDelete())
	MsUnLock()
	TRBZ03->(DbSkip())
EndDo

TRBEMB->(DbGoTop())
While !TRBEMB->(Eof())
	RecLock("TRBEMB",.F.)
	TRBEMB->(DbDelete())
	MsUnLock()
	TRBEMB->(DbSkip())
EndDo

cQuery := " SELECT * FROM " + RetSqlName("Z03") + " Z03 "
cQuery += " WHERE "
cQuery += "    Z03.D_E_L_E_T_ <> '*' "
cQuery += "    AND Z03_FILIAL = '" + xFilial("Z03") + "' "
cQuery += "    AND Z03_COD    = '" + cZ15COD        + "' "
cQuery += "    AND Z03_REVISA = '" + cZ15REVISA     + "' "
cQuery += " ORDER BY Z03_REVISA"

If Select("TMPZ03") > 0
	TMPZ03->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias "TMPZ03"

While !TMPZ03->(Eof())

	RecLock("TRBZ03",.T.)
	TRBZ03->Z03_COD    := TMPZ03->Z03_COD
//	TRBZ03->Z03_DESC   := TMPZ03->Z03_DESC
	TRBZ03->Z03_REVISA := TMPZ03->Z03_REVISA
	TRBZ03->Z03_UM     := TMPZ03->Z03_UM
	TRBZ03->Z03_MOEDA  := TMPZ03->Z03_MOEDA
	TRBZ03->Z03_TABELA := TMPZ03->Z03_TABELA
	TRBZ03->Z03_MARGEM := TMPZ03->Z03_MARGEM
	TRBZ03->Z03_FRTTON := TMPZ03->Z03_FRTTON
	TRBZ03->Z03_FRTCUB := TMPZ03->Z03_FRTCUB
	TRBZ03->Z03_CAPACI := TMPZ03->Z03_CAPACI
	TRBZ03->Z03_CUSTOE := TMPZ03->Z03_CUSTOE
	TRBZ03->Z03_FREENT := TMPZ03->Z03_FREENT
	TRBZ03->Z03_FREENT := TMPZ03->Z03_FREENT
	TRBZ03->Z03_VALVEN := TMPZ03->Z03_VALVEN
	TRBZ03->Z03_VALCAL := TMPZ03->Z03_VALCAL
	TRBZ03->Z03_MARKUP := TMPZ03->Z03_MARKUP
	TRBZ03->Z03_VALICM := TMPZ03->Z03_VALICM
	TRBZ03->Z03_PISCOF := TMPZ03->Z03_PISCOF
	TRBZ03->Z03_CUSOPE := TMPZ03->Z03_CUSOPE
	TRBZ03->Z03_CUSTO2 := TMPZ03->Z03_CUSTO2
	TRBZ03->Z03_LUCBRU := TMPZ03->Z03_LUCBRU
	TRBZ03->Z03_VALIR  := TMPZ03->Z03_VALIR
	TRBZ03->Z03_LUCLIQ := TMPZ03->Z03_LUCLIQ
	TRBZ03->Z03_ORIGEM := TMPZ03->Z03_ORIGEM
	TRBZ03->Z03_REVUSR := TMPZ03->Z03_REVUSR
	TRBZ03->Z03_REVDAT := sTod(TMPZ03->Z03_REVDAT)
	MsUnLock()

	RecLock("TRBEMB",.T.)
	TRBEMB->EMBALAGEM  := TRBZ15->Z15_CODEM
	TRBEMB->DESCRICAO  := Posicione("SB1",1,xFilial("SB1")+TRBZ15->Z15_CODEM,"B1_DESC")
	TRBEMB->CAPACIDADE := TMPZ03->Z03_CAPACI
	TRBEMB->VALOR      := TMPZ03->Z03_CUSTOE
	TRBEMB->EXTRAPER   := TRBZ15->Z15_PEXTRA
	TRBEMB->EXTRAVAL   := TRBZ15->Z15_VEXTRA
	TRBEMB->FRETEENT   := TMPZ03->Z03_FREENT
	TRBEMB->CUSTO1     := TMPZ03->Z03_CUSTO1
	TRBEMB->EMBICMS    := TRBZ15->Z15_PICMEM
	TRBEMB->EMBIPI     := TRBZ15->Z15_PIPIEM
	MsUnLock()

	TMPZ03->(DbSkip())
EndDo

If Select("TMPZ03") > 0
	TMPZ03->(DbCloseArea())
EndIf

TRBZ03->(DbGoTop())
oMrkZ03:oBrowse:Refresh()

TRBEMB->(DbGoTop())
oMrkEMB:oBrowse:Refresh()

Return()