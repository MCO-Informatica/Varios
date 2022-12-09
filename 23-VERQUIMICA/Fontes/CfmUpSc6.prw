#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmUpSc6 | Autor: Celso Ferrone Martins   | Data: 21/11/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmUpSc6()

Private dDataIni := dDataBase//cTod("")
Private dDataFim := dDataBase//cTod("")
Private lDataPrc := .T.
Private aHeadCpo := {}
Private aItemCpo := {}
Private aItemLot := {}
Private cNumSc5  := ""
Private cNomCli  := ""
Private dEmissa  := cTod("")
Private nPesoLiq := 0
Private nPesoBru := 0

Private cSc6Prod := ""
Private cSc6Desc := ""
//Private cSc6Unid := ""
//Private nSc6Qtde := 0
//Private nSc6VlUn := 0
//Private nSc6VlTo := 0
//Private nSc6Peso := 0

Private lSc6Qtde  := .F.
Private lButGrava := .F.

Private cSc9Lote  := ""
Private nSb1Conv  := 0
Private nC9QLib1  := 0
Private nC9QLib2  := 0

CfmCriaTmp()

Define MsDialog oDlgSc5 Title "Manutencao de Custos" From 1,1 To 650,900 Of oMainWnd Pixel

oDlgSc5:lEscClose := .F. // Desabilita fechar apertando a tecla escape ESC.

@ 005,005 Say "Emissao:" Of oDlgSc5 Pixel //SIZE 050,006
@ 013,005 Say "De" Of oDlgSc5 Pixel //SIZE 050,006
@ 013,069 Say "Ate" Of oDlgSc5 Pixel //SIZE 050,006
@ 012,015 Get dDataIni Picture "@D" Size 050,006 Valid CfmValData(1) When lDataPrc Object oDlgDat// HASBUTTON
@ 012,080 Get dDataFim Picture "@D" Size 050,006 Valid CfmValData(2) When lDataPrc Object oDlgDat// HASBUTTON

@ 025,005 Say "Pedido"       Of oDlgSc5 Pixel
@ 025,060 Say "Cliente"      Of oDlgSc5 Pixel
@ 025,195 Say "Emissao"      Of oDlgSc5 Pixel
@ 025,250 Say "Peso Liquido" Of oDlgSc5 Pixel
@ 025,305 Say "Peso Bruto"   Of oDlgSc5 Pixel

@ 033,005 Get cNumSc5  Picture "@!"                Size 050,006 When .F. Object oNumSc5
@ 033,060 Get cNomCli  Picture "@!"                Size 130,006 When .F. Object oNomCli
@ 033,195 Get dEmissa  Picture "@D"                Size 050,006 When .F. Object oEmissa
@ 033,250 Get nPesoLiq Picture "@E 999,999,999.99999" Size 050,006 When .F. Object oPesoLiq
@ 033,305 Get nPesoBru Picture "@E 999,999,999.99999" Size 050,006 When .F. Object oPesoBru

//oMark1 := MsSelect():New("TMP1", "", "", aHeadCpo, , ,{050, 001, 160, 450})
oMark1 := MsSelect():New("TMP1", "", "", aHeadCpo, , ,{050, 001, 130, 450})
oMark1:oBrowse:Refresh()
oMark1:oBrowse:bLDblClick:={|| fSc5Tela(TMP1->C5_NUM)}
//oMark1:oBrowse:BLCLICKED:={|| fSc5Tela(TMP1->C5_NUM)}
//oMark1:oBrowse:BRCLICKED
oMark1:oBrowse:cToolTip := "[ Um duplo click para calcular custo ]"
oMark1:oBrowse:lActive := .F.

//oMark2 := MsSelect():New("TMP2", "", "", aItemCpo, , ,{170, 001, 270, 450})
oMark2 := MsSelect():New("TMP2", "", "", aItemCpo, , ,{135, 001, 210, 450})
oMark2:oBrowse:Refresh()
oMark2:oBrowse:bLDblClick:={|| fSc6Tela(TMP1->C5_NUM+TMP2->C6_ITEM)}
oMark2:oBrowse:cToolTip := "[ Um duplo click para calcular custo ]"
oMark2:oBrowse:lActive := .F.

oMark3 := MsSelect():New("TMP3", "", "", aItemLot, , ,{215, 001, 270, 450})
oMark3:oBrowse:Refresh()
oMark3:oBrowse:bLDblClick:={|| fSc9Tela(TMP3->C9_LOTECTL)}
oMark3:oBrowse:cToolTip := "[ Um duplo click para calcular custo ]"
oMark3:oBrowse:lActive := .F.

@ 275,005 Say "Produto"    Of oDlgSc5 Pixel
@ 275,055 Say "Descricao"  Of oDlgSc5 Pixel
	//@ 275,195 Say "Volume"     Of oDlgSc5 Pixel
	//@ 275,240 Say "Quantidade" Of oDlgSc5 Pixel
	//@ 275,285 Say "Valor Unit" Of oDlgSc5 Pixel
	//@ 275,330 Say "Total"      Of oDlgSc5 Pixel
	//@ 275,375 Say "Peso"       Of oDlgSc5 Pixel
@ 275,185 Say "Lote"       Of oDlgSc5 Pixel
@ 275,235 Say "Densidade"  Of oDlgSc5 Pixel
@ 275,285 Say "Qtde.Kg"    Of oDlgSc5 Pixel
@ 275,345 Say "Qtde.Lt"    Of oDlgSc5 Pixel

@ 282,005 Get cSc6Prod Picture "@!"                    Size 050,006 When .F.      	Object oSc6Prod
@ 282,055 Get cSc6Desc Picture "@!"                    Size 130,006 When .F.      	Object oSc6Desc
	//@ 282,195 Get cSc6Unid Picture "@!"                    Size 040,006 When .F.      Object oSc6Unid
	//@ 282,240 Get nSc6Qtde Picture "@E 9,999,999.99"       Size 040,006 When lSc6Qtde Object oSc6Qtde
	//@ 282,285 Get nSc6VlUn Picture "@E 999,999,999.999999" Size 040,006 When .F.      Object oSc6VlUn
	//@ 282,330 Get nSc6VlTo Picture "@E 999,999,999,999.99" Size 040,006 When .F.      Object oSc6VlTo
	//@ 282,375 Get nSc6Peso Picture "@E 999,999,999.99"     Size 040,006 When .F.      Object oSc6Peso
@ 282,185 Get cSc9Lote Picture "@!"                    Size 050,006 When .F.      	Object oSc9Lote
@ 282,235 Get nSb1Conv Picture "@E 999,999,999.999999" Size 050,006 When .F.      	Object oSb1Conv
@ 282,285 Get nC9QLib1 Picture "@E 999,999,999.99999"     Size 060,006 When lSc6Qtde 	Object oC9QLib1
@ 282,345 Get nC9QLib2 Picture "@E 999,999,999.99999"     Size 060,006 When .F.      	Object oC9QLib2

oButNova  := tButton():New(012,145,"Nova Contulta",oDlgSc5,{|| fNovaODlg()  },040,010,,,,.T.)
oButGrava := tButton():New(012,418,"Gravar"       ,oDlgSc5,{|| fGravaODlg() },030,010,,,,.T.)
oButSair  := tButton():New(030,418,"Sair"         ,oDlgSc5,{|| fCloseODlg() },030,010,,,,.T.)
oButAlter := tButton():New(282,418,"Alterar"      ,oDlgSc5,{|| fAlteraDlg() },030,010,,,,.T.)
oButOk    := tButton():New(282,418,"OK"           ,oDlgSc5,{|| fOkDlg()     },030,010,,,,.T.)
oButCance := tButton():New(300,418,"Cancela"      ,oDlgSc5,{|| fCancDlg()   },030,010,,,,.T.)

oButGrava:lVisibleControl := .F.
oButSair:lVisibleControl  := .T.
oButAlter:lVisibleControl := .F.
oButOk:lVisibleControl    := .F.
oButCance:lVisibleControl := .F.
oButNova:lVisibleControl  := .F.

Activate MsDialog oDlgSc5 Centered

If Select("TMP0") > 0
	TMP0->(DbCloseArea())
EndIf

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmCriaTmp | Autor: Celso Ferrone Martins | Data: 21/11/2014 |||
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
Static Function CfmCriaTmp()

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

aCampos := {}
Aadd(aCampos, {"C5_NUM"     , "C", 06, 0 }) //
Aadd(aCampos, {"C5_CLIENTE" , "C", 06, 0 }) //
Aadd(aCampos, {"C5_LOJACLI" , "C", 02, 0 }) //
Aadd(aCampos, {"A1_NOME"    , "C", 30, 0 }) //
Aadd(aCampos, {"C5_EMISSAO" , "D", 08, 0 }) //
Aadd(aCampos, {"C5_PESOL"   , "N", 12, 4 }) //
Aadd(aCampos, {"C5_PBRUTO"  , "N", 12, 4 }) //
Aadd(aCampos, {"C5_MOEDA"   , "N", 01, 0 }) //
Aadd(aCampos, {"C5_VEND1"   , "C", 06, 0 }) //
Aadd(aCampos, {"A3_NOME"    , "C", 30, 0 }) //
Aadd(aCampos, {"C5_TRANSP"  , "C", 06, 0 }) //
Aadd(aCampos, {"A4_NOME"    , "C", 30, 0 }) //
Aadd(aCampos, {"C5_VOLUME1" , "N", 12, 4 }) //
Aadd(aCampos, {"C5_ESPECI1" , "C", 15, 0 }) //
Aadd(aCampos, {"C6_ITEM"    , "C", 02, 0 }) //
Aadd(aCampos, {"C6_PRODUTO" , "C", 15, 0 }) //
Aadd(aCampos, {"B1_DESC"    , "C", 30, 0 }) //
Aadd(aCampos, {"B1_UM"      , "C", 02, 0 }) //
Aadd(aCampos, {"B1_SEGUM"   , "C", 02, 0 }) //
Aadd(aCampos, {"B1_CONV"    , "N", 15, 6 }) //
Aadd(aCampos, {"C6_QTDVEN"  , "N", 15, 5 }) //
Aadd(aCampos, {"C6_UNSVEN"  , "N", 15, 5 }) //
Aadd(aCampos, {"C6_PRCVEN"  , "N", 16, 8 }) //
Aadd(aCampos, {"C9_QTDLIB"  , "N", 15, 5 }) //
Aadd(aCampos, {"C9_QTDLIB2" , "N", 15, 5 }) //
Aadd(aCampos, {"C6_VQ_UM"   , "C", 02, 0 }) //
Aadd(aCampos, {"C6_VQ_MOED" , "C", 01, 0 }) //
Aadd(aCampos, {"C6_VQ_QTDE" , "N", 15, 5 }) //
Aadd(aCampos, {"C6_VQ_UNIT" , "N", 16, 8 }) //
Aadd(aCampos, {"C6_VQ_TOTA" , "N", 18, 2 }) //
Aadd(aCampos, {"C6_PESO"    , "N", 12, 4 }) //
Aadd(aCampos, {"STATUS"     , "C", 01, 0 }) //

cNomeTmp0 := CriaTrab(aCampos, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTmp0, "TMP0", .F., .F.)
cIndTmp0 := CriaTrab(NIL,.F.)
IndRegua("TMP0",cIndTmp0,"C5_NUM+C6_ITEM",,,"Selecionando Registros...")

aCampos := {}
Aadd(aCampos, {"C5_NUM"     , "C", 06, 0 }) // Num Pedido
Aadd(aCampos, {"C5_CLIENTE" , "C", 09, 0 }) // Codigo Cliente
Aadd(aCampos, {"C5_LOJA"    , "C", 02, 0 }) // Loja Cliente
Aadd(aCampos, {"C5_NOME"    , "C", 30, 0 }) //
Aadd(aCampos, {"C5_EMISSAO" , "D", 08, 0 }) // Data Emissao
Aadd(aCampos, {"C5_PESOL"   , "N", 12, 5 }) //
Aadd(aCampos, {"C5_PBRUTO"  , "N", 12, 5 }) //
Aadd(aCampos, {"C5_MOEDA"   , "N", 01, 0 }) //
Aadd(aCampos, {"C5_VENDE"   , "C", 20, 0 }) //
Aadd(aCampos, {"C5_TRANSP"  , "C", 30, 0 }) //
Aadd(aCampos, {"C5_VOLUME"  , "N", 04, 0 }) //
Aadd(aCampos, {"C5_ESPECIE" , "C", 15, 0 }) //

cNomeTmp1 := CriaTrab(aCampos, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTmp1, "TMP1", .F., .F.)
cIndTmp1 := CriaTrab(NIL,.F.)
IndRegua("TMP1",cIndTmp1,"C5_NUM",,,"Selecionando Registros...")

aHeadCpo := {}
Aadd(aHeadCpo, {"C5_NUM"     ,, "Pedido"        , "@!"})
Aadd(aHeadCpo, {"C5_CLIENTE" ,, "Cliente"       , "@!"})
//Aadd(aHeadCpo, {"C5_LOJA"    ,, "Loja"          , "@!"})
Aadd(aHeadCpo, {"C5_NOME"    ,, "Nome"          , "@!"})
Aadd(aHeadCpo, {"C5_EMISSAO" ,, "Emissao"       , "@D"})
Aadd(aHeadCpo, {"C5_PESOL"   ,, "Peso Liq"      , "@E 999,999.99999"})
Aadd(aHeadCpo, {"C5_PBRUTO"  ,, "Peso Bruto"    , "@E 999,999.99999"})
Aadd(aHeadCpo, {"C5_MOEDA"   ,, "Moeda"         , "@E"})
Aadd(aHeadCpo, {"C5_VENDE"   ,, "Vendedor"      , "@!"})
Aadd(aHeadCpo, {"C5_TRANSP"  ,, "Tranport."     , "@!"})
Aadd(aHeadCpo, {"C5_VOLUME"  ,, "Volume"        , "@E"})
Aadd(aHeadCpo, {"C5_ESPECIE" ,, "Especie"       , "@!"})

If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf

aCampos := {}
Aadd(aCampos, {"C6_ITEM"    , "C", 02, 0 }) // Num Pedido
Aadd(aCampos, {"C6_PRODUTO" , "C", 15, 0 }) // Codigo Cliente
Aadd(aCampos, {"C6_DESCRIC" , "C", 30, 0 }) // Loja Cliente
Aadd(aCampos, {"C6_VQ_UM"   , "C", 02, 0 }) //
Aadd(aCampos, {"C6_VQ_MOED" , "C", 01, 0 }) // Data Emissao
Aadd(aCampos, {"C6_VQ_QTDE" , "N", 15, 5 }) //
Aadd(aCampos, {"C6_VQ_UNIT" , "N", 16, 8 }) //
Aadd(aCampos, {"C6_VQ_TOTA" , "N", 18, 2 }) //
Aadd(aCampos, {"C6_PESO"    , "N", 12, 2 }) //
Aadd(aCampos, {"C6_STATUS"  , "C", 01, 0 }) //
Aadd(aCampos, {"C6_QTDVEN"  , "N", 15, 5 }) //
Aadd(aCampos, {"C6_UNSVEN"  , "N", 15, 5 }) //
Aadd(aCampos, {"C6_PRCVEN"  , "N", 16, 8 }) //
Aadd(aCampos, {"C6_VALOR"   , "N", 18, 2 }) //
Aadd(aCampos, {"B1_CONV"    , "N", 18, 6 }) //

cNomeTMP2 := CriaTrab(aCampos, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTMP2, "TMP2", .F., .F.)
cIndTMP2 := CriaTrab(NIL,.F.)
IndRegua("TMP2",cIndTMP2,"C6_ITEM",,,"Selecionando Registros...")

aItemCpo := {}
Aadd(aItemCpo, {"C6_ITEM"    ,, "Item"         , "@!"})
Aadd(aItemCpo, {"C6_PRODUTO" ,, "Produto"      , "@!"})
Aadd(aItemCpo, {"C6_DESCRIC" ,, "Descricao"    , "@!"})
Aadd(aItemCpo, {"C6_VQ_UM"   ,, "Volume"       , "@!"})
Aadd(aItemCpo, {"C6_VQ_MOED" ,, "Moeda"        , "@!"})
Aadd(aItemCpo, {"C6_VQ_QTDE" ,, "Quantidade"   , "@E 9,999,999.99999"})
Aadd(aItemCpo, {"C6_VQ_UNIT" ,, "Valor Unit."  , "@E 999,999,999.99999999"})
Aadd(aItemCpo, {"C6_VQ_TOTA" ,, "Total"        , "@E 999,999,999,999.99"})
Aadd(aItemCpo, {"C6_PESO"    ,, "Peso"         , "@E 9,999,999.99999"})


If Select("TMP3") > 0
	TMP3->(DbCloseArea())
EndIf

aCampos := {}
Aadd(aCampos, {"C9_LOTECTL" , "C", 10, 0 }) // Lote
Aadd(aCampos, {"C9_QTDLIB"  , "N", 15, 5 }) //
Aadd(aCampos, {"C9_QTDLIB2" , "N", 15, 5 }) //
Aadd(aCampos, {"C9_STATUS"  , "C", 01, 0 }) //
Aadd(aCampos, {"C9_RECNO"   , "N", 12, 0 }) //

cNomeTmp3 := CriaTrab(aCampos, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTmp3, "TMP3", .F., .F.)
cIndTmp3 := CriaTrab(NIL,.F.)
IndRegua("TMP3",cIndTmp3,"C9_LOTECTL",,,"Selecionando Registros...")

aItemLot := {}
Aadd(aItemLot, {"C9_LOTECTL" ,, "Lote"         , "@!"})
aAdd(aItemLot, {"C9_QTDLIB"  ,, "Qtde.Kg"      , "@E 9,999,999.99999"})
aAdd(aItemLot, {"C9_QTDLIB2" ,, "Qtde.Lt"      , "@E 9,999,999.99999"})


Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CFMProcSc5 | Autor: Celso Ferrone Martins | Data: 21/11/2014 |||
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
Static Function CFMProcSc5()

Local cEof := Chr(13) + Chr(10)

TMP1->(DbGoTop())
While !TMP1->(Eof())
	RecLock("TMP1",.F.)
	DbDelete()
	MsUnLock()
	TMP1->(DbSkip())
EndDo

TMP2->(DbGoTop())
While !TMP2->(Eof())
	RecLock("TMP2",.F.)
	DbDelete()
	MsUnLock()
	TMP2->(DbSkip())
EndDo

cQuery := " SELECT " + cEof
cQuery += "    C5_NUM, " + cEof
cQuery += "    C5_CLIENTE, " + cEof
cQuery += "    C5_LOJACLI, " + cEof
cQuery += "    A1_NOME, " + cEof
cQuery += "    C5_EMISSAO, " + cEof
cQuery += "    C5_PESOL, " + cEof
cQuery += "    C5_PBRUTO, " + cEof
cQuery += "    C5_MOEDA, " + cEof
cQuery += "    C5_VEND1, " + cEof
cQuery += "    COALESCE(A3_NOME,'') AS A3_NOME, " + cEof
cQuery += "    C5_TRANSP, " + cEof
cQuery += "    COALESCE(A4_NOME,'') AS A4_NOME, " + cEof
cQuery += "    C5_VOLUME1, " + cEof
cQuery += "    C5_ESPECI1, " + cEof
cQuery += "    C6_ITEM, " + cEof
cQuery += "    C6_PRODUTO, " + cEof
cQuery += "    B1_DESC, " + cEof
cQuery += "    B1_UM, " + cEof
cQuery += "    B1_SEGUM, " + cEof
cQuery += "    B1_CONV, " + cEof
cQuery += "    C6_VQ_UM, "  + cEof
cQuery += "    C6_VQ_MOED, " + cEof
cQuery += "    C6_VQ_QTDE, " + cEof
cQuery += "    C6_VQ_UNIT, "  + cEof
cQuery += "    C6_VQ_TOTA, " + cEof
cQuery += "    C6_UM, " + cEof
cQuery += "    C6_SEGUM, " + cEof
cQuery += "    C6_QTDVEN, " + cEof
cQuery += "    C6_UNSVEN, " + cEof
cQuery += "    C6_PRCVEN, " + cEof
//cQuery += "    C9_LOTECTL,  " + cEof
cQuery += "    SUM(C9_QTDLIB)  AS C9_QTDLIB, " + cEof
cQuery += "    SUM(C9_QTDLIB2) AS C9_QTDLIB2 " + cEof
cQuery += " FROM " + RetSqlName("SC5") + " SC5 " + cEof
cQuery += "    INNER JOIN " + RetSqlName("SC6") + " SC6 ON " + cEof
cQuery += "       SC6.D_E_L_E_T_ <> '*' " + cEof
cQuery += "       AND C6_FILIAL  = C5_FILIAL " + cEof
cQuery += "       AND C6_NUM     = C5_NUM " + cEof
cQuery += "    INNER JOIN " + RetSqlName("SB1") + " SB1 ON " + cEof
cQuery += "       SB1.D_E_L_E_T_ <> '*' " + cEof
cQuery += "       AND B1_FILIAL  = '"+xFilial("SB1")+"' " + cEof
cQuery += "       AND B1_COD     = C6_PRODUTO " + cEof
cQuery += "       AND B1_TIPO    = 'MP' " + cEof
cQuery += "    INNER JOIN " + RetSqlName("SC9") + " SC9 ON " + cEof
cQuery += "       SC9.D_E_L_E_T_ <> '*' " + cEof
cQuery += "       AND C9_FILIAL  = '"+xFilial("SC9")+"' " + cEof
cQuery += "       AND C9_PEDIDO  = C5_NUM " + cEof
cQuery += "       AND C9_ITEM    = C6_ITEM " + cEof
cQuery += "       AND C9_PRODUTO = C6_PRODUTO " + cEof
cQuery += "       AND C9_BLEST   = '  ' " + cEof
cQuery += "       AND C9_BLCRED  = '  ' " + cEof
cQuery += "    INNER JOIN " + RetSqlName("SA1") + " SA1 ON  " + cEof
cQuery += "       SA1.D_E_L_E_T_ <> '*'  " + cEof
cQuery += "       AND A1_FILIAL  = '"+xFilial("SA1")+"'  " + cEof
cQuery += "       AND A1_COD     = C5_CLIENTE  " + cEof
cQuery += "       AND A1_LOJA    = C5_LOJACLI  " + cEof
cQuery += "    LEFT JOIN " + RetSqlName("SA3") + " SA3 ON  " + cEof
cQuery += "       SA3.D_E_L_E_T_ <> '*'  " + cEof
cQuery += "       AND A3_FILIAL = '"+xFilial("SA3")+"'  " + cEof
cQuery += "       AND A3_COD    = C5_VEND1  " + cEof
cQuery += "    LEFT JOIN " + RetSqlName("SA4") + " SA4 ON  " + cEof
cQuery += "       SA4.D_E_L_E_T_ <> '*'  " + cEof
cQuery += "       AND A4_FILIAL = '"+xFilial("SA4")+"'  " + cEof
cQuery += "       AND A4_COD    = C5_TRANSP  " + cEof
cQuery += " WHERE " + cEof
cQuery += "    SC5.D_E_L_E_T_ <> '*' " + cEof
cQuery += "    AND C5_FILIAL  = '"+xFilial("SC5")+"' " + cEof
cQuery += "    AND C5_TIPO    = 'N' " + cEof
cQuery += "    AND C5_NOTA    = '         ' " + cEof
cQuery += "    AND C5_EMISSAO BETWEEN '"+dTos(dDataIni)+"' AND '"+dTos(dDataFim)+"' " + cEof
cQuery += " GROUP BY       " + cEof
cQuery += "    C5_NUM,     " + cEof
cQuery += "    C5_CLIENTE, " + cEof
cQuery += "    C5_LOJACLI, " + cEof
cQuery += "    A1_NOME,    " + cEof
cQuery += "    C5_EMISSAO, " + cEof
cQuery += "    C5_PESOL,   " + cEof
cQuery += "    C5_PBRUTO,  " + cEof
cQuery += "    C5_MOEDA,   " + cEof
cQuery += "    C5_VEND1,   " + cEof
cQuery += "    A3_NOME,    " + cEof
cQuery += "    C5_TRANSP,  " + cEof
cQuery += "    A4_NOME,    " + cEof
cQuery += "    C5_VOLUME1, " + cEof
cQuery += "    C5_ESPECI1, " + cEof
cQuery += "    C6_ITEM,    " + cEof
cQuery += "    C6_PRODUTO, " + cEof
cQuery += "    B1_DESC,    " + cEof
cQuery += "    B1_UM,      " + cEof
cQuery += "    B1_SEGUM,   " + cEof
cQuery += "    B1_CONV,    " + cEof
cQuery += "    C6_VQ_UM,   " + cEof
cQuery += "    C6_VQ_MOED, " + cEof
cQuery += "    C6_VQ_QTDE, " + cEof
cQuery += "    C6_VQ_UNIT, " + cEof
cQuery += "    C6_VQ_TOTA, " + cEof
cQuery += "    C6_UM,      " + cEof
cQuery += "    C6_SEGUM,   " + cEof
cQuery += "    C6_QTDVEN,  " + cEof
cQuery += "    C6_UNSVEN,  " + cEof
cQuery += "    C6_PRCVEN   " + cEof
//cQuery += "    C9_LOTECTL  " + cEof

cQuery := ChangeQuery(cQuery)

If Select("TMPSC5") > 0
	TMPSC5->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPSC5"

While !TMPSC5->(Eof())
	
	nc6Peso := 0
	If TMPSC5->C6_UM == "KG"
		nc6Peso := TMPSC5->C6_QTDVEN
	ElseIf TMPSC5->C6_SEGUM == "KG"
		nc6Peso := TMPSC5->C6_UNSVEN
	EndIf
	
	RecLock("TMP0",.T.)
	TMP0->C5_NUM     := TMPSC5->C5_NUM
	TMP0->C5_CLIENTE := TMPSC5->C5_CLIENTE
	TMP0->C5_LOJACLI := TMPSC5->C5_LOJACLI
	TMP0->A1_NOME    := TMPSC5->A1_NOME
	TMP0->C5_EMISSAO := sTod(TMPSC5->C5_EMISSAO)
	TMP0->C5_PESOL   := TMPSC5->C5_PESOL
	TMP0->C5_PBRUTO  := TMPSC5->C5_PBRUTO
	TMP0->C5_MOEDA   := TMPSC5->C5_MOEDA
	TMP0->C5_VEND1   := TMPSC5->C5_VEND1
	TMP0->A3_NOME    := TMPSC5->A3_NOME
	TMP0->C5_TRANSP  := TMPSC5->C5_TRANSP
	TMP0->A4_NOME    := TMPSC5->A4_NOME
	TMP0->C5_VOLUME1 := TMPSC5->C5_VOLUME1
	TMP0->C5_ESPECI1 := TMPSC5->C5_ESPECI1
	TMP0->C6_ITEM    := TMPSC5->C6_ITEM
	TMP0->C6_PRODUTO := TMPSC5->C6_PRODUTO
	TMP0->B1_DESC    := TMPSC5->B1_DESC
	TMP0->B1_UM      := TMPSC5->B1_UM
	TMP0->B1_SEGUM   := TMPSC5->B1_SEGUM
	TMP0->B1_CONV    := TMPSC5->B1_CONV
	TMP0->C6_QTDVEN  := TMPSC5->C6_QTDVEN
	TMP0->C6_UNSVEN  := TMPSC5->C6_UNSVEN
	TMP0->C6_PRCVEN  := TMPSC5->C6_PRCVEN
	TMP0->C6_VQ_UM   := TMPSC5->C6_VQ_UM
	TMP0->C6_VQ_MOED := TMPSC5->C6_VQ_MOED
	TMP0->C6_VQ_QTDE := TMPSC5->C6_VQ_QTDE
	TMP0->C6_VQ_UNIT := TMPSC5->C6_VQ_UNIT
	TMP0->C6_VQ_TOTA := TMPSC5->C6_VQ_TOTA
	TMP0->C6_PESO    := nc6Peso
	MsUnLock()
	
	If !TMP1->(DbSeek(TMPSC5->C5_NUM))
		RecLock("TMP1",.T.)
		TMP1->C5_NUM     := TMPSC5->C5_NUM
		TMP1->C5_CLIENTE := TMPSC5->C5_CLIENTE+"-"+TMPSC5->C5_LOJACLI
		TMP1->C5_NOME    := TMPSC5->A1_NOME
		TMP1->C5_EMISSAO := sTod(TMPSC5->C5_EMISSAO)
		TMP1->C5_PESOL   := TMPSC5->C5_PESOL
		TMP1->C5_PBRUTO  := TMPSC5->C5_PBRUTO
		TMP1->C5_MOEDA   := TMPSC5->C5_MOEDA
		TMP1->C5_VENDE   := TMPSC5->A3_NOME
		TMP1->C5_TRANSP  := TMPSC5->A4_NOME
		TMP1->C5_VOLUME  := TMPSC5->C5_VOLUME1
		TMP1->C5_ESPECIE := TMPSC5->C5_ESPECI1
		MsUnLock()
	EndIf
	
	TMPSC5->(DbSkip())
EndDo

If Select("TMPSC5") > 0
	TMPSC5->(DbCloseArea())
EndIf

TMP1->(DbGoTop())

oMark1:oBrowse:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmValData | Autor: Celso Ferrone Martins | Data: 21/11/2014 |||
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
Static Function CfmValData(nOpc)

Local lRet := .T.

If nOpc == 1
	If Empty(dDataIni)
		//		lRet := .F.
		//		MsgAlert("Data nao pode ser branco.","Atencao!!!")
	ElseIf !Empty(dDataFim)
		If dDataIni > dDataFim
			lRet := .F.
			MsgAlert("Datas com Divergencia","Atencao!!!")
		EndIf
	EndIf
Else
	If Empty(dDataFim)
		//		lRet := .F.
		//		MsgAlert("Data nao pode ser branco.","Atencao!!!")
	ElseIf !Empty(dDataIni)
		If dDataIni > dDataFim
			lRet := .F.
			MsgAlert("Datas com Divergencia","Atencao!!!")
		EndIf
	EndIf
EndIf

If lRet .And. !Empty(dDataIni) .And. !Empty(dDataFim)
	lDataPrc := .F.
	oMark1:oBrowse:lActive := .T.
	oButNova:lVisibleControl  := .T.
	Processa( {|| CFMProcSc5() }, "Carregando Informacoes...")
EndIf

oDlgDat:Refresh()

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fSc5Tela  | Autor: Celso Ferrone Martins  | Data: 24/11/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fSc5Tela(cNumPed)

oMark2:oBrowse:lActive := .T.
oMark3:oBrowse:lActive := .T.

fLimpSc6()

TMP2->(DbGoTop())
While !TMP2->(Eof())
	RecLock("TMP2",.F.)
	DbDelete()
	MsUnLock()
	TMP2->(DbSkip())
EndDo

TMP3->(DbGoTop())
While !TMP3->(Eof())
	RecLock("TMP3",.F.)
	DbDelete()
	MsUnLock()
	TMP3->(DbSkip())
EndDo

cNumSc5  := TMP1->C5_NUM
cNomCli  := TMP1->C5_NOME
dEmissa  := TMP1->C5_EMISSAO
nPesoLiq := TMP1->C5_PESOL
nPesoBru := TMP1->C5_PBRUTO

TMP0->(DbGoTop())
If TMP0->(DbSeek(cNumSc5))
	While !TMP0->(Eof()) .And. TMP0->C5_NUM == cNumSc5
		
		RecLock("TMP2",.T.)
		TMP2->C6_ITEM    := TMP0->C6_ITEM
		TMP2->C6_PRODUTO := TMP0->C6_PRODUTO
		TMP2->C6_DESCRIC := TMP0->B1_DESC
		TMP2->C6_VQ_UM   := TMP0->C6_VQ_UM
		TMP2->C6_VQ_MOED := TMP0->C6_VQ_MOED
		TMP2->C6_VQ_QTDE := TMP0->C6_VQ_QTDE
		TMP2->C6_VQ_UNIT := TMP0->C6_VQ_UNIT
		TMP2->C6_VQ_TOTA := TMP0->C6_VQ_TOTA
		TMP2->C6_PRCVEN  := TMP0->C6_PRCVEN
		TMP2->C6_PESO    := TMP0->C6_PESO
		TMP2->B1_CONV    := TMP0->B1_CONV
		MsUnLock()
		TMP0->(DbSkip())
	EndDo
EndIf

TMP2->(DbGoTop())

oMark2:oBrowse:Refresh()
oMark3:oBrowse:Refresh()
oNumSc5:Refresh()
oNomCli:Refresh()
oEmissa:Refresh()
oPesoLiq:Refresh()
oPesoBru:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fSc6Tela  | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function fSc6Tela(cTmp0Chave)

/*
oButAlter:lVisibleControl := .T.
//oMark1:oBrowse:lActive := .F.

cSc6Prod := TMP2->C6_PRODUTO
cSc6Desc := TMP2->C6_DESCRIC
//cSc6Unid := TMP2->C6_VQ_UM
//nSc6Qtde := TMP2->C6_VQ_QTDE
//nSc6VlUn := TMP2->C6_VQ_UNIT
//nSc6VlTo := TMP2->C6_VQ_TOTA
//nSc6Peso := TMP2->C6_PESO

oSc6Prod:Refresh()
oSc6Desc:Refresh()
//oSc6Unid:Refresh()
//oSc6Qtde:Refresh()
//oSc6VlUn:Refresh()
//oSc6VlTo:Refresh()
//oSc6Peso:Refresh()
oButAlter:Refresh()
*/

//oMark1:oBrowse:lActive := .F.
oMark3:oBrowse:lActive := .T.

TMP3->(DbGoTop())
While !TMP3->(Eof())
	RecLock("TMP3",.F.)
	DbDelete()
	MsUnLock()
	TMP3->(DbSkip())
EndDo

DbSelectArea("SC9") ; DbSetOrder(1)

If SC9->(DbSeek(xFilial("SC9")+cTmp0Chave))
	While !SC9->(Eof()) .And. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == xFilial("SC9")+cTmp0Chave
		
		If Empty(SC9->C9_BLEST) .And. Empty(C9_BLCRED)
			RecLock("TMP3",.T.)
			TMP3->C9_LOTECTL := SC9->C9_LOTECTL
			TMP3->C9_QTDLIB  := SC9->C9_QTDLIB
			TMP3->C9_QTDLIB2 := SC9->C9_QTDLIB2
			TMP3->C9_RECNO   := SC9->(RecNo())
			MsUnLock()
		EndIf
		
		SC9->(DbSkip())
	EndDo
EndIf

TMP3->(DbGoTop())
oMark3:oBrowse:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fSc9Tela  | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function fSc9Tela(cTmp2Chave)

oButAlter:lVisibleControl := .T.

cSc6Prod := TMP2->C6_PRODUTO
cSc6Desc := TMP2->C6_DESCRIC

cSc9Lote := TMP3->C9_LOTECTL
nSb1Conv := TMP2->B1_CONV
nC9QLib1 := TMP3->C9_QTDLIB
nC9QLib2 := TMP3->C9_QTDLIB2

oSc6Prod:Refresh()
oSc6Desc:Refresh()
oButAlter:Refresh()

oSc9Lote:Refresh()
oSb1Conv:Refresh()
oC9QLib1:Refresh()
oC9QLib2:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fLimpSc6  | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function fLimpSc6()

cSc6Prod := ""
cSc6Desc := ""
cSc9Lote := ""
nSb1Conv := 0
nC9QLib1 := 0
nC9QLib2 := 0

oSc6Prod:Refresh()
oSc6Desc:Refresh()
oSc9Lote:Refresh()
oSb1Conv:Refresh()
oC9QLib1:Refresh()
oC9QLib2:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fLimpSc6  | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fCloseODlg()

If lButGrava
	If !MsgYesNo("Ocorreram alteracoes no documento, deseja descarta-la?","Atencao!!!")
		Return()
	EndIf
EndIf

If Select("TMP0") > 0
	TMP0->(DbCloseArea())
EndIf

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf

If Select("TMP3") > 0
	TMP3->(DbCloseArea())
EndIf

Close(oDlgSc5)

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fAlteraDlg| Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fAlteraDlg()

oMark1:oBrowse:lActive := .F.
oMark2:oBrowse:lActive := .F.
oMark3:oBrowse:lActive := .F.

oButSair:lVisibleControl  := .F.
oButOk:lVisibleControl    := .T.
oButAlter:lVisibleControl := .F.
oButGrava:lVisibleControl := .F.
oButCance:lVisibleControl := .T.

lSc6Qtde := .T.
oC9QLib1:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fOkDlg    | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fOkDlg()

If TMP3->C9_QTDLIB != nC9QLib1
	
	lButGrava := .T.
	oMark1:oBrowse:lActive := .F.
	oMark2:oBrowse:lActive := .F.
	//	oMark3:oBrowse:lActive := .T.
	nC9QLib2 := Round(nC9QLib1/TMP2->B1_CONV,2)
	nTotQl1  := 0
	nTotQl2  := 0
	
	nPosTmp3 := TMP3->(RecNo())
	RecLock("TMP3",.F.)
	TMP3->C9_QTDLIB  := nC9QLib1
	TMP3->C9_QTDLIB2 := nC9QLib2
	TMP3->C9_STATUS  := "A"
	MsUnLock()
	
	TMP3->(DbGoTop())
	While !TMP3->(Eof())
		nTotQl1 += TMP3->C9_QTDLIB
		nTotQl2 += TMP3->C9_QTDLIB2
		TMP3->(DbSkip())
	EndDo
	
	TMP3->(DbGoTop())
	TMP3->(DbGoTo(nPosTmp3))
	
	If TMP2->C6_VQ_UM == "KG"
		nQtdTmp2 := nTotQl1
	Else
		nQtdTmp2 := nTotQl2
	EndIf
	
	nMaisPeso := 0
	If TMP0->(DbSeek(cNumSc5+TMP2->C6_ITEM))
		If TMP0->B1_UM == TMP0->C6_VQ_UM
			If TMP0->B1_UM == "KG"
				nMaisPeso := nTotQl1 - TMP2->C6_PESO
			Else
				nMaisPeso := nTotQl2 - TMP2->C6_PESO
			EndIf
		ElseIf TMP0->B1_SEGUM == TMP0->C6_VQ_UM
			If TMP0->B1_SEGUM == "KG"
				nMaisPeso := nTotQl2 - TMP2->C6_PESO
			Else
				nMaisPeso := nTotQl1 - TMP2->C6_PESO
			EndIf
		EndIf
	EndIf
	
	RecLock("TMP2",.F.)
	TMP2->C6_VQ_QTDE := nQtdTmp2
	TMP2->C6_VQ_TOTA := nQtdTmp2 * TMP2->C6_VQ_UNIT
	TMP2->C6_STATUS  := "A"
	TMP2->C6_QTDVEN  := nTotQl1
	TMP2->C6_UNSVEN  := nTotQl2
	TMP2->C6_VQ_TOTA := nQtdTmp2 * TMP2->C6_VQ_UNIT
	TMP2->C6_VALOR   := nTotQl1  * TMP2->C6_PRCVEN
	TMP2->C6_PESO    += nMaisPeso
	MsUnLock()
	
	RecLock("TMP1",.F.)
	TMP1->C5_PESOL  += nMaisPeso
	TMP1->C5_PBRUTO += nMaisPeso
	MsUnLock()
	
	nPesoLiq += nMaisPeso
	nPesoBru += nMaisPeso
	oPesoLiq:Refresh()
	oPesoBru:Refresh()
	
EndIf

oButOk:lVisibleControl    := .F.
oButGrava:lVisibleControl := lButGrava
oButAlter:lVisibleControl := .T.
oButCance:lVisibleControl := .F.
oButSair:lVisibleControl  := .T.
oMark3:oBrowse:lActive    := .T.

lSc6Qtde := .F.
//oSc6Qtde:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fCancDlg  | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fCancDlg()

oButGrava:lVisibleControl := lButGrava
oButSair:lVisibleControl  := .T.
oButAlter:lVisibleControl := .T.
oButOk:lVisibleControl    := .F.
oButCance:lVisibleControl := .F.
oMark2:oBrowse:lActive    := .T.
oMark3:oBrowse:lActive    := .T.

If !lButGrava
	oMark1:oBrowse:lActive := .T.
EndIf

lSc6Qtde := .F.
//oSc6Qtde:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fGravaODlg| Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fGravaODlg()

If MsgYesNo("Deseja Salvar as alteracoes efetuadas ?","Salvar alteracoes ?")
	
	lButGrava := .F.
	
	Processa({|| fAtuSc5Sc6() },"Processando Dados...")
	
	fCloseODlg()
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fNovaODlg | Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fNovaODlg()

If lButGrava
	If !MsgYesNo("Ocorreram alteracoes no documento, deseja descarta-la?","Atencao!!!")
		Return()
	EndIf
EndIf

oButGrava:lVisibleControl := .F.
oButSair:lVisibleControl  := .T.
oButAlter:lVisibleControl := .F.
oButOk:lVisibleControl    := .F.
oButCance:lVisibleControl := .F.
oButNova:lVisibleControl  := .F.

lDataPrc := .T.
dDataIni := cTod("")
dDataFim := cTod("")
oDlgDat:Refresh()

TMP0->(DbGoTop())
While !TMP0->(Eof())
	RecLock("TMP0",.F.)
	DbDelete()
	MsUnLock()
	TMP0->(DbSkip())
EndDo

TMP1->(DbGoTop())
While !TMP1->(Eof())
	RecLock("TMP1",.F.)
	DbDelete()
	MsUnLock()
	TMP1->(DbSkip())
EndDo

TMP2->(DbGoTop())
While !TMP2->(Eof())
	RecLock("TMP2",.F.)
	DbDelete()
	MsUnLock()
	TMP2->(DbSkip())
EndDo

TMP3->(DbGoTop())
While !TMP3->(Eof())
	RecLock("TMP3",.F.)
	DbDelete()
	MsUnLock()
	TMP3->(DbSkip())
EndDo

oMark1:oBrowse:lActive := .F.
oMark2:oBrowse:lActive := .F.
oMark3:oBrowse:lActive := .F.

cNumSc5  := ""
cNomCli  := ""
dEmissa  := cTod("")
nPesoLiq := 0
nPesoBru := 0
cSc6Prod := ""
cSc6Desc := ""
cSc9Lote := ""
nSb1Conv := 0
nC9QLib1 := 0
nC9QLib2 := 0

oNumSc5:Refresh()
oNomCli:Refresh()
oEmissa:Refresh()
oPesoLiq:Refresh()
oPesoBru:Refresh()
oSc6Prod:Refresh()
oSc6Desc:Refresh()
oSc9Lote:Refresh()
oSb1Conv:Refresh()
oC9QLib1:Refresh()
oC9QLib2:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fAtuSc5Sc6| Autor: Celso Ferrone Martins  | Data: 01/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fAtuSc5Sc6()

DbSelectArea("SC5") ; DbSetOrder(1)
DbSelectArea("SC6") ; DbSetOrder(1)
DbSelectArea("SC9") ; DbSetOrder(1)
DbSelectArea("SDC") ; DbSetOrder(1)
DbSelectArea("SBF") ; DbSetOrder(1)      
DbSelectArea("SB2") ; DbSetOrder(1) 	//B2_FILIAL+B2_COD+B2_LOCAL //DANILO BUSSO 07/12/2016 -- CORRIGIR PROBLEMAS RESERVA/EMPENHO SB2
DbSelectArea("SB8") ; DbSetOrder(3) 	//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL //DANILO BUSSO 07/12/2016 -- CORRIGIR PROBLEMAS EMPENHO SB8


Begin Transaction

If SC5->(DbSeek(xFilial("SC5")+cNumSc5))
	RecLock("SC5",.F.)
	If SC5->C5_VQ_BKPL == 0
		SC5->C5_VQ_BKPL := SC5->C5_PESOL
		SC5->C5_VQ_BKPB := SC5->C5_PBRUTO
	EndIf
	SC5->C5_PESOL   := nPesoLiq
	SC5->C5_PBRUTO  := nPesoBru
	MsUnLock()
EndIf

If SC6->(DbSeek(xFilial("SC6")+cNumSc5+TMP2->C6_ITEM))
	RecLock("SC6",.F.)
	If SC6->C6_VQ_BKQ1 == 0
		SC6->C6_VQ_BKQ1 := SC6->C6_QTDVEN
		SC6->C6_VQ_BKQ2 := SC6->C6_UNSVEN
		SC6->C6_VQ_BKQV := SC6->C6_VQ_QTDE
		SC6->C6_VQ_BKVL := SC6->C6_VALOR
		SC6->C6_VQ_BKTV := SC6->C6_VQ_TOTA
	EndIf
	SC6->C6_QTDVEN  := TMP2->C6_QTDVEN
	SC6->C6_UNSVEN  := TMP2->C6_UNSVEN
	SC6->C6_VQ_QTDE := TMP2->C6_VQ_QTDE
	SC6->C6_VQ_TOTA := TMP2->C6_VQ_TOTA
	SC6->C6_VALOR   := TMP2->C6_VALOR
	SC6->C6_QTDEMP  := TMP2->C6_QTDVEN
	SC6->C6_QTDEMP2 := TMP2->C6_UNSVEN
	MsUnLock()
	
	TMP3->(DbGoTop())
	While !TMP3->(Eof())
		
		//If SC9->(DbSeek(xFilial("SC9")+cNumSc5+TMP2->C6_ITEM+TMP3->C9_LOTECTL))
		SC9->(DbGoTo(TMP3->C9_RECNO))
		RecLock("SC9",.F.)
		If SC9->C9_VQ_BKL1 == 0
			SC9->C9_VQ_BKL1 := SC9->C9_QTDLIB
			SC9->C9_VQ_BKL2 := SC9->C9_QTDLIB2
		EndIf
		SC9->C9_QTDLIB  := TMP3->C9_QTDLIB
		SC9->C9_QTDLIB2 := TMP3->C9_QTDLIB2
		MsUnLock()
		If SDC->(DbSeek(xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM)))
			//				DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
			While !SDC->(Eof()) .And. SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM) == xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM)
				If SDC->DC_LOTECTL == SC9->C9_LOTECTL

					nQtd1  := TMP3->C9_QTDLIB
					nQtd2  := TMP3->C9_QTDLIB2
					If SDC->DC_VQ_BKQ1 == 0
						nQtd1b := SDC->DC_QUANT
						nQtd2b := SDC->DC_QTSEGUM
					Else
						nQtd1b := SDC->DC_VQ_BKQ1
						nQtd2b := SDC->DC_VQ_BKQ2
					EndIf
					nQtdO1 := SDC->DC_QUANT
					nQtdO2 := SDC->DC_QTSEGUM

					RecLock("SDC",.F.)
					SDC->DC_VQ_BKQ1 := nQtd1b
					SDC->DC_VQ_BKQ2 := nQtd2b
					SDC->DC_QUANT   := TMP3->C9_QTDLIB
					SDC->DC_QTDORIG := TMP3->C9_QTDLIB
					SDC->DC_QTSEGUM := TMP3->C9_QTDLIB2
					MsUnLock()
					If SBF->(DbSeek(xFilial("SBF")+SDC->(DC_LOCAL+DC_LOCALIZ+DC_PRODUTO+DC_NUMSERI+DC_LOTECTL+DC_NUMLOTE)))
						RecLock("SBF",.F.)
						SBF->BF_EMPENHO += TMP3->C9_QTDLIB  - nQtdO1
						SBF->BF_EMPEN2  += TMP3->C9_QTDLIB2 - nQtdO2
						MsUnLock()
					EndIf        
					
					If SB8->(DbSeek(xFilial("SB8")+SDC->(DC_PRODUTO+DC_LOCAL+DC_LOTECTL)))
						RecLock("SB8", .F.)
						SB8->B8_EMPENHO += TMP3->C9_QTDLIB  - nQtdO1
						SB8->B8_EMPENH2 += TMP3->C9_QTDLIB2 - nQtdO2
						MsUnlock()
					EndIf
					
					If SB2->(DbSeek(xFilial("SB2")+SDC->(DC_PRODUTO+DC_LOCAL)))
						RecLock("SB2", .F.)
						SB2->B2_RESERVA += TMP3->C9_QTDLIB  - nQtdO1
						SB2->B2_RESERV2 += TMP3->C9_QTDLIB2 - nQtdO2
						MsUnlock()
					EndIf
					
				EndIf
				SDC->(DbSkip())
			EndDo
		EndIf
		//EndIf
		
		TMP3->(DbSkip())
	EndDo
	
EndIf

End Transaction

Return()
