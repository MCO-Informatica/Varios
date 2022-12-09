#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"
#Include "dbtree.ch"
#Include "TbiConn.ch"

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: CfmTPreco | Autor: Celso Ferrone Martins      | Data: 10/03/2014 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: | Manutencao de tabela de precos                                |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       | Verquimica                                                    |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/

User Function CfmTPreco()

Private ldbTree := .T.

Pergunte('MTA200', .F.)

fPreco()

Return

/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: CfmTPreco | Autor: Celso Ferrone Martins      | Data: 10/03/2014 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: | Manutencao de tabela de precos                                |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       | Verquimica                                                    |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/

Static Function fPreco()

Local cDlgTitle    := "Manutencao de Custos"
Local lRet         := .T.  
Local _cUsrLib     := GetMv("MV_VQCUSTO") //Danilo Busso - Usuarios com permissao de editar formulario 

Private oDlg

Private cCodMp     := Space(15) // Codigo Produto Materia Prima
Private cDescMp    := ""        // Descricao Materia Prima
Private lCodMp     := .F.
Private lEditCalc  := .F.
Private cRevisao   := Space(3)  // Revisao Estrutura
Private nDensidade := 0         // Densidade do Produto
Private oDensidade              // Objeto do campo
Private nFrete     := 0         // Frete de Compra
Private lVersolve  := .F.

Private nValRefCom := 0         // Valor Referencia de Compras
Private nPrcMem	   := 0			// Valor Referencia de Compras Versolve
Private dDatRefCom := cTod("")  // Data Referencia de Compras
Private nPerIcms   := 0         // % de Icms
Private nPIcmsMp   := 0
Private nPerIpi    := 0         // % de Ipi
Private nDifIcms   := 0         // Dif. Icms
Private nIndIcms   := 0         // Indice de Icms
Private cGrTrib    := Space(3)	// Grupo
Private lPerIcms   := .F.       // When do campo Icms da MP

Private nTabA      := 0         // Margem de Lucro Tabela A
Private nTabB      := 0         // Margem de Lucro Tabela B
Private nTabC      := 0         // Margem de Lucro Tabela C
Private nTabD      := 0         // Margem de Lucro Tabela D
Private nTabE      := 0         // Margem de Lucro Tabela E
Private nCustoOp   := 0         // Custo Operacional

Private aUm        := {}        // Array Unidade de Medido
Private cUm        := "L"      // Unidade de Medida
Private oUm
//Private nFatConv   := 1 // Fator de conversaro de litros para quilos

Private aMoeda     := {}        // Array Moedas
Private cMoeda     := "01"      // Variavel Moedas
Private oMoeda                  // Objeto Moedas

Private aB1Blql    := {}
Private cB1Blql    := "S"
Private oB1Blql

Private aEmbCus    := {}
Private cEmbCus    := "S"
Private oEmbCus

Private nTaxConv   := 1

Private dDataRef   := cTod("")  // Data Referencia de Cotacao
Private nTaxaM2    := 0         // Taxa da Moeda
Private nFretTon   := 0         // Frete por Tonelada
Private nFretMet   := 0         // Frete por metro cubico
Private nBaseCal   := 0         // Base de calculo Litros
Private nBaseCalKg := 0         // Base de calculo Kg
Private _nFretTon  := 0         // Frete por Tonelada
Private _nFretMet  := 0         // Frete por metro cubico
Private _nBaseCal  := 0         // Base de calculo Litros
Private _nBaseCalKg:= 0         // Base de calculo Kg

Private cNomeTmp1  := ""        //
Private cIndTmp1   := ""        //
Private cNomeTmp2  := ""        //
Private cIndTmp2   := ""        //

Private nPerPis    := 1.65      // % Pis
Private nPerCof    := 7.60      // % Cofins
Private nPerIR     := 2.00      // % IR

Private cCodEm     := ""        // Codigo Embalagem
Private cDescEm    := ""        // Descricao Embalagem
Private nPIcmsEm   := 0         // Icms Embalagem
Private nPIpiEm    := 0         // Ipi Embalagm
Private nPerExt    := 0         //
Private nValEm     := 0         // Preco da Embalagem

Private cCodPai    := ""        // Codigo Produto Pai
Private cDescPai   := ""        // Descricao Produto Pai

Private oPanel2
Private oTree
Private lRevAut      := SuperGetMv("MV_REVAUT",.F.,.F.)
Private aPaiEstru	 := {}
Private lGetRevisao  := .T.
Private nOpcX        := 2

Private nIndex   := 1

Private oPanel1
Private oPanel2
Private oPanel3

Private dD1DtDigit := cTod("")
Private nD1Quant   := 0
Private nD1Valor   := 0     
Private nC7VFret   := 0 //Danilo Busso   
Private nD1Icms    := 0
Private nD1Taxa    := 0
Private cD1Frete   := ""     
Private cC7TFret   := "" //Danilo Busso  
Private cC7Forne   := "" //Danilo Busso     
Private cC7Pedid   := "" //Danilo Busso
Private cD1Um      := ""
Private cD1Moeda   := ""
Private cD1Embal   := ""         



Private cEol       := CHR(13)+CHR(10)    
Private _userLib //Danilo Busso variavel para controle dos usuarios liberados

If __cUserID $ _cUsrLib
	_userLib := .T.
Else
	_userLib := .F.
EndIf

RegToMemory("Z02",.T.)

Aadd(aMoeda,"01=Real")
Aadd(aMoeda,"02=Dolar")

Aadd(aUm,"L=Metro Cubico")
Aadd(aUm,"K=Tonelada")

Aadd(aB1Blql,"S=Sim")
Aadd(aB1Blql,"N=Nao")

Aadd(aEmbCus,"S=Sim")
Aadd(aEmbCus,"N=Nao")

dDataRef := GetMV("VQ_DTCOTAC", .F.)
nTaxaM2  := GetMV("VQ_TXMOED2", .F.)
nFretTon := GetMV("VQ_FRETONE", .F.)
nFretMet := GetMV("VQ_FRETMET", .F.)
nBaseCal := GetMV("VQ_BASELIT", .F.)
_nFretTon := GetMV("VQ_FRETONE", .F.)
_nFretMet := GetMV("VQ_FRETMET", .F.)
_nBaseCal := GetMV("VQ_BASELIT", .F.)

DbSelectArea("SB1") ; DbSetOrder(1) // Cadastro de produtos
DbSelectArea("SG1") ; DbSetOrder(1) // Estrutura de produtos
DbSelectArea("Z02") ; DbSetOrder(1) // Tabela de Preco customizada
DbSelectArea("Z03") ; DbSetOrder(2) // Tabela de Preco customizada - Itens
DbSelectArea("SC7") ; DbSetOrder(1) // Pedido de Compras

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

aCampos := {}
Aadd(aCampos, {"B1_COD"     , "C", 15, 0}) // Codigo
Aadd(aCampos, {"B1_CODPAI"  , "C", 15, 0}) // Codigo PA
Aadd(aCampos, {"B1_UM"      , "C", 02, 0}) // UM
Aadd(aCampos, {"B1_DESC"    , "C", 30, 0}) // Descricao
Aadd(aCampos, {"CAPAC_EMBA" , "N", 12, 2}) // Capacidade Unitaria
Aadd(aCampos, {"_CAPACEMBA" , "N", 12, 6}) // Capacidade Unitaria
Aadd(aCampos, {"CAPA_FATOR" , "N", 12, 2}) // Capacidade X Fator
Aadd(aCampos, {"B1_QTDEMB"  , "N", 12, 2}) // Qtde Embalagem
Aadd(aCampos, {"B1_PCUSTO"  , "C", 03, 0}) // Possui Custo
Aadd(aCampos, {"B1_VQ_RCOM" , "N", 12, 2}) // Custo Embalagem
Aadd(aCampos, {"CUSTOEMBAL" , "N", 12, 2}) // Custo Total Embalagem
Aadd(aCampos, {"B1_VQ_PEXT" , "N", 06, 2}) // % Extra
Aadd(aCampos, {"B1_VQ_VEXT" , "N", 12, 2}) // Valor Extra
Aadd(aCampos, {"B1_VQ_FRET" , "N", 12, 2}) // Frete de Entrega
Aadd(aCampos, {"B1_VQ_IPI"  , "N", 12, 2}) // IPI
Aadd(aCampos, {"B1_VQ_ICMS" , "N", 12, 2}) // ICMS
Aadd(aCampos, {"B1_PESO"    , "N", 12, 2}) // Peso
Aadd(aCampos, {"B1_CUSTO1"  , "N", 12, 2}) // 1o Custo
Aadd(aCampos, {"B1_MSBLQL"  , "C", 03, 0}) // Ativada
Aadd(aCampos, {"B1_VQ_UMEM" , "C", 01, 0}) // UM Embalagem
Aadd(aCampos, {"B1_VQ_EMCS" , "C", 03, 0}) // Custo Embalagem

cNomeTmp1 := CriaTrab(aCampos, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTmp1, "TMP1", .F., .F.)
cIndTmp1 := CriaTrab(NIL,.F.)
IndRegua("TMP1",cIndTmp1,"B1_COD",,,"Selecionando Registros...")

aHeadCpo := {}
Aadd(aHeadCpo, {"B1_COD"     ,, "Codigo"        , "@!"})
Aadd(aHeadCpo, {"B1_DESC"    ,, "Descricao"     , "@!"})
Aadd(aHeadCpo, {"CAPA_FATOR" ,, "Capacidade"    , "@E 999,999.99"})
Aadd(aHeadCpo, {"CUSTOEMBAL" ,, "$ Embalagem"   , "@E 999,999.99"})
Aadd(aHeadCpo, {"B1_VQ_PEXT" ,, "% Extra"       , "@E 999.99"})
Aadd(aHeadCpo, {"B1_VQ_VEXT" ,, "Valor Extra"   , "@E 999,999.99"})
Aadd(aHeadCpo, {"B1_VQ_FRET" ,, "Frete Entrega" , "@E 999,999.99"})
Aadd(aHeadCpo, {"B1_CUSTO1"  ,, "1o_Custo"      , "@E 999,999.99"})
Aadd(aHeadCpo, {"B1_VQ_EMCS" ,, "Custo"         , "@!"})
Aadd(aHeadCpo, {"B1_MSBLQL"  ,, "Ativada ?"     , "@!"})

If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf

aCampos := {}
Aadd(aCampos, {"LETRA"     ,"C", 01, 00 })
Aadd(aCampos, {"VALVEND"   ,"N", 12, 02 })
Aadd(aCampos, {"TBPRECO"   ,"N", 12, 02 })
Aadd(aCampos, {"VLCALC"    ,"N", 12, 02 })
Aadd(aCampos, {"MARKUP"    ,"N", 12, 04 })
Aadd(aCampos, {"ICMS"      ,"N", 12, 02 })
Aadd(aCampos, {"PISCOFINS" ,"N", 12, 02 })
Aadd(aCampos, {"CUSOPER"   ,"N", 12, 02 })
Aadd(aCampos, {"CUSTO2"    ,"N", 12, 02 })
Aadd(aCampos, {"LUCROBRU"  ,"N", 12, 02 })
Aadd(aCampos, {"IR"        ,"N", 12, 02 })
Aadd(aCampos, {"LUCROLIQ"  ,"N", 12, 02 })

cNomeTmp2 := CriaTrab(aCampos, .T.)          // Arquivo Temporario
DbUseArea(.T.,, cNomeTmp2, "TMP2", .F., .F.)
cIndTmp2 := CriaTrab(NIL,.F.)
IndRegua("TMP2",cIndTmp2,"LETRA",,,"Selecionando Registros...")

cLetra := "A"
For nX := 1 To 5
	RecLock("TMP2",.T.)
	TMP2->LETRA := cLetra
	MsUnLock()
	cLetra := Soma1(cLetra)
Next nX
TMP2->(DbGoTop())

aHadTab := {}
Aadd(aHadTab, {"LETRA"     ,, "Letra"          , "@!"})
Aadd(aHadTab, {"VALVEND"   ,, "Vl.Venda"       , "@E 999,999.99"})
Aadd(aHadTab, {"TBPRECO"   ,, "Tb.Preco"       , "@E 999,999.99"})
Aadd(aHadTab, {"VLCALC"    ,, "Vl.Calculado"   , "@E 999,999.99"})
Aadd(aHadTab, {"MARKUP"    ,, "Markup"         , "@E 9,999.99999"})
Aadd(aHadTab, {"ICMS"      ,, "$ ICMS"         , "@E 999,999.99"})
Aadd(aHadTab, {"PISCOFINS" ,, "$ Pis/Cofins"   , "@E 999,999.99"})
Aadd(aHadTab, {"CUSOPER"   ,, "Custo Oper."    , "@E 999,999.99"})
Aadd(aHadTab, {"CUSTO2"    ,, "2o Custo"       , "@E 999,999.99"})
Aadd(aHadTab, {"LUCROBRU"  ,, "Lucro Bruto"    , "@E 999,999.99"})
Aadd(aHadTab, {"IR"        ,, "I.R."           , "@E 999,999.99"})
Aadd(aHadTab, {"LUCROLIQ"  ,, "Lucro Liquido"  , "@E 999,999.99"})

aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 020, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

Define Dialog oDlg Title cDlgTitle From aSize[7],0 To aSize[6],aSize[5] STYLE DS_MODALFRAME PIXEL

oDlg:lEscClose  := .F. //Nao permite sair ao se pressionar a tecla ESC.
oDlg:lMaximized := .T.

@ 000,001 To 027,313 Label "Produto" Pixel Of oDlg
@ 006,003 Say U_CfmFHtml("Produto"       ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 006,065 Say U_CfmFHtml("Densidade"     ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 006,127 Say U_CfmFHtml("Unidade"       ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 006,188 Say U_CfmFHtml("Moeda"         ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 006,250 Say U_CfmFHtml("$ Frete Compra","Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 014,003 Get cCodMp     Picture "@!"                     Size 060,010 When .F. Object oCod //When .T. F3 "SB1MP" Valid fValProd(.T.) Object oCod
@ 014,065 Get nDensidade Picture "@E 999,999.999999"      Size 060,010 When .F. Object oDensidade
@ 014,127 MSCOMBOBOX oUm    Var cUm    Items aUm          Size 060,010 When lCodMp OF oDlg PIXEL
@ 014,188 MSCOMBOBOX oMoeda Var cMoeda Items aMoeda       Size 060,010 When lCodMp OF oDlg PIXEL
@ 014,250 Get nFrete     Picture "@E 999,999,999,999.99"  Size 060,010 When !lVersolve.and.lCodMp Object oFrete

@ 000,316 To 027,442 Label "Dolar de Referencia" Pixel Of oDlg
@ 006,318 Say U_CfmFHtml("Data da Cotacao","Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 006,380 Say U_CfmFHtml("Valor"          ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 014,318 Get dDataRef Picture "@D" Size 060,010 When .F. Object oMoeda
@ 014,380 Get nTaxaM2  Picture "@E 999,999.9999" Size 060,010 When .F. Object oMoeda

@ 028,001 To 054,210 Label "Referencia de Compra" Pixel Of oDlg
@ 033,003 Say U_CfmFHtml("Valor"       ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 033,050 Say U_CfmFHtml("Data"        ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 033,097 Say U_CfmFHtml("% ICMS"      ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
//@ 033,144 Say U_CfmFHtml("% IPI"       ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 033,147 Say U_CfmFHtml("Excecao Fis.","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 041,003 Get nValRefCom Picture "@E 999,999,999.99"    Size 045,010 When !lVersolve.and.lCodMp Object oValor
@ 041,050 Get dDatRefCom Picture "@D"                   Size 045,010 When .F. Object oCod
@ 041,097 Get nPerIcms   Picture "@E 999.99"            Size 045,010 When lPerIcms Object oIcms Valid CfmVIcms()
//@ 041,144 Get nPerIpi    Picture "@E 999.99"            Size 045,010 When lCodMp Object oIpi
@ 041,151 Get cGrTrib    Picture "@!"                   Size 045,010 When lCodMp Object oGrTrib F3 "21" Valid CfmVExce()

@ 026,212 To 083,442 Label "Informacoes sobre o ultimo pedido" Pixel Of oDlg

@ 030,214 Say U_CfmFHtml("Fornecedor","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 030,286 Say U_CfmFHtml("Quantidade","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 030,336 Say U_CfmFHtml("Valor"     ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 030,383 Say U_CfmFHtml("Icms"      ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 030,410 Say U_CfmFHtml("UM"        ,"Navy","8","L") Size 020,010 Pixel OF oDlg Html

@ 038,214 Get cC7Forne   Picture "@!"                Size 070,010 When .F. Object oC7Forne //Danilo Busso
@ 038,286 Get nD1Quant   Picture "@E 999,999,999.99" Size 045,010 When .F. Object oD1Quant
@ 038,336 Get nD1Valor   Picture "@E 999,999.999999" Size 045,010 When .F. Object oD1Valor
@ 038,383 Get nD1Icms    Picture "@E 999"            Size 020,010 When .F. Object oD1Icms
@ 038,410 Get cD1Um      Picture "@!"                Size 020,010 When .F. Object oD1Um

@ 047,214 Say U_CfmFHtml("Data"      ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 047,255 Say U_CfmFHtml("Frete"     ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 047,312 Say U_CfmFHtml("Moeda"     ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 047,339 Say U_CfmFHtml("Taxa M2"   ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 047,386 Say U_CfmFHtml("Embalagem" ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html

@ 055,214 Get dD1DtDigit Picture "@D"                Size 040,010 When .F. Object oD1Emissao
@ 055,255 Get cD1Frete   Picture "@!"                Size 055,010 When .F. Object oD1Frete
@ 055,312 Get cD1Moeda   Picture "@!"                Size 025,010 When .F. Object oD1Moeda
@ 055,339 Get nD1Taxa    Picture "@E 999,999.999999" Size 045,010 When .F. Object oD1Taxa
@ 055,386 Get cD1Embal   Picture "@!"                Size 045,010 When .F. Object oD1Embal

//DANILO BUSSO
@ 063,214 Say U_CfmFHtml("Tipo Frete"     ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 063,275 Say U_CfmFHtml("Valor Frete"     ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html     
@ 063,336 Say U_CfmFHtml("Num. Pedido"     ,"Navy","8","L") Size 050,010 Pixel OF oDlg Html     
@ 071,214 Get cC7TFret 	 Picture "@!"                Size 055,010 When .F. Object oC7TFret //Danilo Busso
@ 071,275 Get nC7VFret Picture "@E 999,999.999999" Size 045,010 When .F. Object oC7VFret   //Danilo Busso
@ 071,336 Get cC7Pedid Picture "@!" Size 045,010 When .F. Object oC7Pedid   //Danilo Busso


@ 054,001 To 081,210 Label "Outras Informacoes" Pixel Of oDlg
@ 060,003 Say U_CfmFHtml("$ Frete Tonelada"    ,"Navy","8","L") Size 100,010 Pixel OF oDlg Html
@ 060,127 Say U_CfmFHtml("$ Frete Metro Cubico","Navy","8","L") Size 070,010 Pixel OF oDlg Html
@ 068,003 Get nFretTon   Picture "@E 999,999,999.99" Size 060,010 When .F. Object oCod
@ 068,141 Get nFretMet   Picture "@E 999,999,999.99" Size 060,010 When .F. Object oCod

@ 081,001 To 108,313 Label "Margem de Lucro" Pixel Of oDlg
@ 087,003 Say U_CfmFHtml("Tabela A","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 087,065 Say U_CfmFHtml("Tabela B","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 087,127 Say U_CfmFHtml("Tabela C","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 087,188 Say U_CfmFHtml("Tabela D","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 087,250 Say U_CfmFHtml("Tabela E","Navy","8","L") Size 050,010 Pixel OF oDlg Html
@ 095,003 Get nTabA Picture "@E 999.99" Size 060,010 When lCodMp Object oTabA
@ 095,065 Get nTabB Picture "@E 999.99" Size 060,010 When lCodMp Object oTabB
@ 095,127 Get nTabC Picture "@E 999.99" Size 060,010 When lCodMp Object oTabC
@ 095,188 Get nTabD Picture "@E 999.99" Size 060,010 When lCodMp Object oTabD
@ 095,250 Get nTabE Picture "@E 999.99" Size 060,010 When lCodMp Object oTabE

@ 081,316 To 108,442 Label "Custo Operacional" Pixel Of oDlg
@ 087,318 Say U_CfmFHtml("Valor","Navy","8","L") Size 100,010 Pixel OF oDlg Html
@ 095,318 Get nCustoOp Picture "@E 999.99" Size 060,010 When lCodMp Object oCusto

@ 108,001 To 135,442 Label "Dados da Embalagens" Pixel Of oDlg
@ 114,003 Say U_CfmFHtml("Codigo"   ,"Navy","8","L")   Size 060,010 Pixel OF oDlg Html
@ 114,040 Say U_CfmFHtml("Embalagem","Navy","8","L")   Size 060,010 Pixel OF oDlg Html
@ 114,152 Say U_CfmFHtml("Valor"    ,"Navy","8","L")   Size 060,010 Pixel OF oDlg Html
@ 114,193 Say U_CfmFHtml("%ICMS"    ,"Navy","8","L")   Size 060,010 Pixel OF oDlg Html
@ 114,234 Say U_CfmFHtml("%IPI"     ,"Navy","8","L")   Size 060,010 Pixel OF oDlg Html
@ 114,275 Say U_CfmFHtml("%Extra"   ,"Navy","8","L")   Size 060,010 Pixel OF oDlg Html
@ 114,316 Say U_CfmFHtml("Custo?"   ,"Navy","8","L")   Size 060,010 Pixel OF oDlg Html
@ 114,357 Say U_CfmFHtml("Ativada?" ,"Navy","8","L")   Size 060,010 Pixel OF oDlg Html

@ 122,003 Get cCodEm   Picture "@!"                    Size 035,010 When .F.    Object oCodEm
@ 122,040 Get cDescEm  Picture "@!"                    Size 110,010 When .F.    Object oDescEm
@ 122,152 Get nValEm   Picture "@E 999,999.99"         Size 039,010 When lCodMp Object oValEm
@ 122,193 Get nPIcmsEm Picture "@E 999.99"             Size 039,010 When lCodMp Object oIcmEm
@ 122,234 Get nPIpiEm  Picture "@E 999.99"             Size 039,010 When lCodMp Object oIpiEm
@ 122,275 Get nPerExt  Picture "@E 999.99"             Size 039,010 When lCodMp Object oExtra
@ 122,316 MSCOMBOBOX oEmbCus Var cEmbCus Items aEmbCus Size 039,010 When lCodMp OF oDlg PIXEL
@ 122,357 MSCOMBOBOX oB1Blql Var cB1Blql Items aB1Blql Size 039,010 When lCodMp OF oDlg PIXEL

@ 122,398 Button "Atualiza" SIZE 040,010 ACTION fCfmAtul()

@ 000,445 To 081,600 Label "Detalhes do Produto" Pixel Of oDlg
@ 006,447 Say U_CfmFHtml("Produto"        ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 024,447 Say U_CfmFHtml("Produto Acabado","Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 042,447 Say U_CfmFHtml("Materia Prima"  ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 060,447 Say U_CfmFHtml("Embalagem"      ,"Navy","8","L") Size 060,010 Pixel OF oDlg Html
@ 014,447 Get cCodPai  Picture "@!" Size 060,010 When .F. Object oCodPai
@ 032,447 Get cDescPai Picture "@!" Size 152,010 When .F. Object oDescPai
@ 050,447 Get cDescMp  Picture "@!" Size 152,010 When .F. Object oDescMp
@ 068,447 Get cDescEm  Picture "@!" Size 152,010 When .F. Object oDescEm2

//oMark1 := MsSelect():New("TMP1", "OK", "", aHeadCpo, @lInverte, cMarca, {137, 001, 195, 442})
oMark1 := MsSelect():New("TMP1", "", "", aHeadCpo, , ,{137, 001, 195, 442})
oMark1:oBrowse:Refresh()
oMark1:oBrowse:bLDblClick:={|| fCalcCus(TMP1->B1_COD,.T.)}
oMark1:oBrowse:cToolTip := "[ Um duplo click para calcular custo ]"

//ObjectMethod(oMark1:oBrowse,"Refresh()")
//oMark1:bMark := {|| fRegSel()}
//oMark1:oBrowse:lhasMark = .t.
//oMark1:oBrowse:lCanAllmark := .t.
//oMark1:oBrowse:bAllMark := {|| fMarkAll()}
//oMark1:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}

oMark2 := MsSelect():New("TMP2", "", "", aHadTab, , , {197, 001, 272, 442})
oMark2:oBrowse:Refresh()

@ 275,001 Button "Mat.Prima"       Size 050,015 Action fCfmConPad("SB1MP","Z02_CODMP") 

@ 275,256 Button "Estoque"         Size 050,015 Action fConsEst() 
@ 275,409 Button "Historico Preco" Size 050,015 Action fCfmHisPrc() 
@ 275,460 Button "Encerrar"        Size 050,015 Action fCfmClose() 

@ 275,358 Button "Compras/Vendas"  Size 050,015 Action fCfmComFat() 

If(_userLib)
	@ 275,052 Button "Editar"          Size 050,015 Action fCfmEdit() 
	@ 275,103 Button "Calcular"        Size 050,015 Action fCfmCalcu()
	@ 275,154 Button "Grava"           Size 050,015 Action fGrvaZ02() 
	@ 275,205 Button "Tabela de Preco" Size 050,015 Action fTabPrec() 
	@ 275,307 Button "Composicao"      Size 050,015 Action fComposi() 

EndIf
	
Define DbTree oTree From 084,445 To 272,600 Of oDlg CARGO

Activate Dialog oDlg Centered

Return()

/*
================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+--------------------------------+------------------+||
||| Programa: fCfmConPad | Autor: Celso Ferrone Martins   | Data: 24/05/2014 |||
||+-----------+----------+--------------------------------+------------------+||
||| Descricao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Alteracao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Uso       |                                                              |||
||+-----------+--------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
================================================================================
*/
Static Function fCfmConPad(cConSxb,cConCpo,lRefresh)

Local lRet := .F.
Local cFilMp := ""
//Local cAlias := AliasCpo(cConCpo) //Retirado Danilo Busso 15/08/2016 - Não é necessário após atualização de fonte. 
//Local uRetF3	//Retirado Danilo Busso 15/08/2016 - Não é necessário após atualização de fonte. 
Default lRefresh := .F.

fCfmParam()
/* Retirado Danilo Busso 15/08/2016 - Não é necessário após atualização de fonte.             
If !lRefresh
	lRet := ConPad1(,,,cConSxb,cConCpo,,.F.)
Else
	lRet := .T.
	SB1->(DbSeek(xFilial("SB1")+cCodMp))
EndIf
*/ 
   
If !lRefresh
	cFilMp := U_DBFILSBMP()  
Else
    lRet := .T.     
    cFilMp := cCodMp
	SB1->(DbSeek(xFilial("SB1")+cFilMp))
EndIf

If !Empty(cFilMp)  
	lRet := .T.
	/*
	If !lRefresh
		uRetF3	:= ( cAlias )->( FieldGet( FieldPos( cConCpo ) ) )
	EndIf
	
	cCodMp := SB1->B1_COD
	 */
	cCodMp := cFilMp
		 
	lEditCalc := .T.
	lCodMp    := .F.
	oMark1:OBROWSE:LACTIVE := .T.
	
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
		TMP2->VALVEND   := 0
		TMP2->TBPRECO   := 0
		TMP2->VLCALC    := 0
		TMP2->MARKUP    := 0
		TMP2->ICMS      := 0
		TMP2->PISCOFINS := 0
		TMP2->CUSOPER   := 0
		TMP2->CUSTO2    := 0
		TMP2->LUCROBRU  := 0
		TMP2->IR        := 0
		TMP2->LUCROLIQ  := 0
		MsUnLock()
		TMP2->(DbSkip())
	EndDo
	TMP2->(DbGoTop())
	/*
	cQuery := " SELECT * FROM " + RetSqlName("SB1") + " B1"
	cQuery += " LEFT JOIN  "+ RetSqlName("Z02") + " Z2"
	cQuery += "		ON Z2.D_E_L_E_T_ <> '*' AND ( B1.B1_COD = Z2.Z02_COD) "
	cQuery += " WHERE "
	cQuery += "    B1.D_E_L_E_T_ <> '*' "
	//cQuery += "    AND B1.B1_FILIAL = '"+xFilial("SB1")+"' " 
	cQuery += "    AND Z2.Z02_FILIAL = " + cFilAnt
	cQuery += "    AND B1.B1_COD = '"+cCodMp+"' "
*/	
cQuery := " SELECT 	"
cQuery += "  TB1.*, "
cQuery += "  (CASE WHEN TB2.Z02_REFCOM IS NULL THEN 0 ELSE TB2.Z02_REFCOM END) AS Z02_REFCOM, (CASE WHEN TB2.Z02_DTRCOM IS NULL THEN '' ELSE TB2.Z02_DTRCOM END) AS Z02_DTRCOM FROM (      "
cQuery += " 	SELECT * FROM " + RetSqlName("SB1") + " B1"
cQuery += "  		WHERE     B1.D_E_L_E_T_ <> '*'     "	
cQuery += " 		AND B1.B1_FILIAL = '"+xFilial("SB1")+"' " 
cQuery += " 		AND B1.B1_COD = '"+cCodMp+"' "
cQuery += " 	) TB1 LEFT JOIN ( "
cQuery += " 	SELECT 	Z02_COD,  "
cQuery += " 		Z02_REFCOM,    "
cQuery += " 		Z02_DTRCOM     "
cQuery += " 	FROM "+ RetSqlName("Z02") + " Z2"
cQuery += " 		WHERE Z02_FILIAL = '"+xFilial("Z02")+"' " 
cQuery += " 		AND Z02_COD = '"+cCodMp+"' "
cQuery += " 	) TB2 ON TB1.B1_COD = TB2.Z02_COD   "
	
	If Select("TRBMP") > 0
		TRBMP->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TRBMP"
	MemoWrite("C:\temp\query1.txt",cQuery)	
   //	If !TRBMP->(Eof())
		fValProd(.T.)
	//EndIf

	fCfmSc7()
	
EndIf

Return(lRet)
/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: fValProd | Autor: Celso Ferrone Martins | Data: 11/03/2014 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | Valida produto MP e Estrutura                            |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       | CFMTPRECO                                                |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function fValProd(lAtuEst,_cCodEm)

Local lRet      := .T.
Default _cCodEm := ""
Default lAtuEst := .F.

If Empty(TRBMP->B1_TIPO)
	MsgAlert("Selecione uma Materia Prima.","Atencao!!!")
	Return(.F.)
ElseIf TRBMP->B1_TIPO != "MP"
	MsgAlert("Produto nao pertence ao grupo de Materia Prima.","Atencao!!!")
	Return(.F.)
EndIf

If SG1->(DbSeek(xFilial("SG1")+cCodMp))
	lVersolve := .T.
Else
	lVersolve := .F.
EndIf

cCodEm   := ""
cDescEm  := ""
nPIcmsEm := 0
nPIpiEm  := 0
nValEm   := 0
cCodPai  := ""
cDescPai := ""
nPerExt  := 0

nTabA    := 0 // % Margem de Lucro A
nTabB    := 0 // % Margem de Lucro B
nTabC    := 0 // % Margem de Lucro C
nTabD    := 0 // % Margem de Lucro D
nTabE    := 0 // % Margem de Lucro E
nCustoOp := 0 // Custo Operacional

nDensidade := TRBMP->B1_CONV    // Densidade
cDescMp    := TRBMP->B1_DESC    // Descricao
If !lVersolve
	nFrete     := TRBMP->B1_VQ_FRET // Frete de Compra
EndIf

If Z02->(DbSeek(cFilAnt+cCodMp))  //DANILO BUSSO 18/08/2016
	nTabA    := Z02->Z02_MARGEA // % Margem de Lucro A
	nTabB    := Z02->Z02_MARGEB // % Margem de Lucro B
	nTabC    := Z02->Z02_MARGEC // % Margem de Lucro C
	nTabD    := Z02->Z02_MARGED // % Margem de Lucro D
	nTabE    := Z02->Z02_MARGEE // % Margem de Lucro E
	nCustoOp := Z02->Z02_CUSOPE // Custo Operacional
EndIf

If lAtuEst
	If !lVersolve
//		nValRefCom := TRBMP->B1_VQ_RCOM // Valor de Referencia de Compra
		nValRefCom := TRBMP->Z02_REFCOM    // DANILO BUSSO 19/08/2016 - ADICIONADO, RETIRADO ^
	EndIf
   //dDatRefCom := Stod(TRBMP->B1_VQ_DATA) // Data de Referencia de Compra     
   	dDatRefCom := Stod(TRBMP->Z02_DTRCOM)
	nPerIcms   := TRBMP->B1_VQ_ICMS // ICMS
	cGrTrib    := TRBMP->B1_GRTRIB  // Excecao Fiscal
	nPIcmsMp   := TRBMP->B1_VQ_ICMS // ICMS
	nPerIpi    := TRBMP->B1_VQ_IPI  // IPI
	cUm	       := If(!Empty(TRBMP->B1_VQ_UM),SubStr(TRBMP->B1_VQ_UM,1,1),"L")
	cMoeda     := iIf(Empty(TRBMP->B1_VQ_MOED),"01","0"+TRBMP->B1_VQ_MOED)
EndIf

If lVersolve
	//cUM := "K"
	CfmVerCalc()
EndIf

nIndIcms   := 1-(nPerIcms/100)
nIndIcmPrd := 1-(TRBMP->B1_VQ_ICMS/100)
nDifIcms   := ((nValRefCom*(nIndIcms))/nIndIcmPrd)-nValRefCom
nBaseCalKg := nBaseCal * nDensidade
fValEmbal()

If lAtuEst
	oTree:Reset()
EndIf
oDensidade:Refresh()

If Empty(cCodEm) .And. lVersolve
	oTree:Reset()
	cRevisao := Posicione("SB1",1,xFilial("SB1")+cCodMp,"B1_REVATU")
	A200GetRev(lGetRevisao, oDlg, oTree, cCodMp, cRevisao, nOpcX, lRevAut,@aPaiEstru)
	oTree:Refresh()
EndIf

oCod:Refresh()
oCodEm:Refresh()
oDescEm:Refresh()
oDescEm2:Refresh()
oValor:Refresh()
oFrete:Refresh()
oExtra:Refresh()
oB1Blql:Refresh()
oEmbCus:Refresh()
oMark1:oBrowse:Refresh()
oMark2:oBrowse:Refresh()

Return(lRet)

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+------------------------------+------------------+||
||| Programa: fValEmbal | Autor: Celso Ferrone Martins | Data: 11/03/2014 |||
||+-----------+---------+------------------------------+------------------+||
||| Descricao | Valida produto MP e Estrutura                             |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       | CFMTPRECO                                                 |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/

Static Function fValEmbal()

Local aAreaSb1 := SB1->(GetArea())

If cMoeda == "01" // Real
	nTaxConv := 1
Else              // Dolar
	nTaxConv := nTaxaM2
EndIf

nFretTon := _nFretTon / nTaxConv // Custo do Frete por Tonelada
nFretMet := _nFretMet / nTaxConv // Custo do Frete por Metro Cubico

cQuery := " SELECT * FROM " + RetSqlName("SG1") + " SG1 "
cQuery += "    INNER JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "       SB1.D_E_L_E_T_ <> '*' "
cQuery += "       AND B1_FILIAL = G1_FILIAL "
cQuery += "       AND B1_COD    = G1_COMP "
cQuery += "       AND B1_TIPO   = 'EM' "
cQuery += " WHERE "
cQuery += "    SG1.D_E_L_E_T_ <> '*' "
cQuery += "    AND G1_COD IN ( SELECT DISTINCT G1_COD FROM " + RetSqlName("SG1") + " WHERE D_E_L_E_T_ <> '*' AND G1_COMP = '" + cCodMp + "' ) "
//cQuery += "    AND G1_COD = '" + cCodMp + "' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
MemoWrite("C:\temp\query2.txt",cQuery)

TcQuery cQuery New Alias "TRB"

While !TRB->(Eof())

	SB1->(DbSeek(xFilial("SB1")+TRB->G1_COD))
	SG1->(DbSeek(xFilial("SG1")+TRB->G1_COD+cCodMp))
	
	nZ02PExtra := 0
	_cPCusto := "NAO"
	cB1MsBlQl := iIf(SB1->B1_MSBLQL =="1","Nao","Sim")
	cBqVqEmCs := iIf(SB1->B1_VQ_EMCS=="S","Sim","Nao")
	
	If Z02->(DbSeek(cFilAnt+TRB->G1_COD))//DANILO BUSSO 18/08/2016
		nZ02PExtra := Z02->Z02_PEXTRA
		_cPCusto := "SIM"
	EndIf

	If TRB->B1_VQ_UMEM == SB1->B1_UM
		nCapSg1 := SG1->G1_QUANT
	ElseIf SB1->B1_UM == "KG"
		nCapSg1 := SG1->G1_QUANT/SB1->B1_CONV
	Else
		nCapSg1 := SG1->G1_QUANT*SB1->B1_CONV
	EndIf
	
	RecLock("TMP1",.T.)
	TMP1->B1_COD     := TRB->B1_COD     // Codigo
	TMP1->B1_CODPAI  := TRB->G1_COD     // Cod Pai
	TMP1->B1_UM      := Posicione("SB1",1,xFilial("SB1")+TRB->G1_COD,"B1_UM")      // Um
	TMP1->B1_DESC    := TRB->B1_DESC    // Descricao
	TMP1->B1_VQ_IPI  := TRB->B1_VQ_IPI  // IPI
	TMP1->B1_VQ_ICMS := TRB->B1_VQ_ICMS // ICMS
	TMP1->B1_PESO    := TRB->B1_PESO    // PESO
	TMP1->B1_VQ_RCOM := TRB->B1_VQ_RCOM // Custo Unitario Embalagem
	TMP1->B1_VQ_PEXT := nZ02PExtra		// % Extra
	TMP1->B1_PCUSTO  := _cPCusto
	TMP1->B1_VQ_EMCS := cBqVqEmCs
	TMP1->CAPAC_EMBA := nCapSg1			//TRB->B1_VQ_ECAP
	TMP1->_CAPACEMBA := nCapSg1
	TMP1->B1_VQ_UMEM := SubStr(TRB->B1_VQ_UMEM,1,1)
	TMP1->B1_MSBLQL  := cB1MsBlQl
	MsUnLock()
	fPrimeiroCusto()
	
	TRB->(DbSkip())
	
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cB1MsBlQl := iIf(Posicione("SB1",1,xFilial("SB1")+cCodMp,"B1_MSBLQL" )=="1","Nao","Sim")
cBqVqEmCs := iIf(Posicione("SB1",1,xFilial("SB1")+cCodMp,"B1_VQ_EMCS")=="S","Sim","Nao")
SB1->(DbSeek(xFilial("SB1")+"03000"))
nZ02PExtra := 0
_cPCusto := "NAO"

If Z02->(DbSeek(cFilAnt+cCodMp))//DANILO BUSSO 18/08/2016
	nZ02PExtra := Z02->Z02_PEXTRA
	_cPCusto := "SIM"
EndIf

RecLock("TMP1",.T.)
TMP1->B1_COD     := SB1->B1_COD		// Codigo
TMP1->B1_CODPAI  := cCodMp			// Cod Pai
TMP1->B1_UM      := Posicione("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_UM")	// Um
TMP1->B1_DESC    := SB1->B1_DESC	// Descricao
TMP1->B1_VQ_IPI  := SB1->B1_VQ_IPI	// IPI
TMP1->B1_VQ_ICMS := SB1->B1_VQ_ICMS	// ICMS
TMP1->B1_PESO    := SB1->B1_PESO	// PESO
TMP1->B1_VQ_RCOM := SB1->B1_VQ_RCOM	// Custo Unitario Embalagem
TMP1->B1_VQ_PEXT := nZ02PExtra		// % Extra
TMP1->B1_PCUSTO  := _cPCusto
TMP1->B1_VQ_EMCS := cBqVqEmCs
TMP1->CAPAC_EMBA := SB1->B1_VQ_ECAP // OK
TMP1->_CAPACEMBA := SB1->B1_VQ_ECAP
//TMP1->CAPA_FATOR := SB1->B1_VQ_ECAP
TMP1->B1_VQ_UMEM := SubStr(SB1->B1_VQ_UMEM,1,1)
TMP1->B1_MSBLQL  := cB1MsBlQl
MsUnLock()

fPrimeiroCusto()

TMP1->(DbGoTop())

SB1->(RestArea(aAreaSb1))

Return()

/*
===================================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------------+-------------------------------+------------------+||
||| Programa: fPrimeiroCusto | Autor: Celso Ferrone Martins  | Data: 13/06/2014 |||
||+-----------+--------------+-------------------------------+------------------+||
||| Descricao | Calculo do primeiro custo                                       |||
||+-----------+-----------------------------------------------------------------+||
||| Alteracao |                                                                 |||
||+-----------+-----------------------------------------------------------------+||
||| Uso       |                                                                 |||
||+-----------+-----------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===================================================================================
*/
Static Function fPrimeiroCusto()

If TMP1->B1_VQ_UMEM == cUm
	_nCapacida := TMP1->_CAPACEMBA
Else
	If TMP1->B1_VQ_UMEM == "K"
		_nCapacida := TMP1->_CAPACEMBA / nDensidade
	ElseIf TMP1->B1_VQ_UMEM == "L"
		_nCapacida := TMP1->_CAPACEMBA * nDensidade
	Else
		_nCapacida := TMP1->_CAPACEMBA
	EndIf
EndIf
_nValCusto := TMP1->B1_VQ_RCOM
_nPerIPI   := TMP1->B1_VQ_IPI
_nValIPI   := (_nValCusto*_nPerIPI)/100
If TMP1->B1_VQ_UMEM == "K"
	_nQtdEmb   := (nBaseCal*nDensidade)/TMP1->_CAPACEMBA
Else
	_nQtdEmb   := nBaseCal/TMP1->_CAPACEMBA
EndIf

If SubStr(TMP1->B1_VQ_EMCS,1,1) == "S"
	_nCusEmb := (((_nValCusto+_nValIPI)*_nQtdEmb) / nTaxConv) ///  nFatConv
Else
	_nCusEmb := 0
EndIf

If TMP1->B1_VQ_UMEM != cUm
	If TMP1->B1_VQ_UMEM != "K"
		//		_nCusEmb := _nCusEmb * nDensidade /// Verificar
		//	Else
		_nCusEmb := _nCusEmb / nDensidade
	EndIf
ElseIf TMP1->B1_VQ_UMEM == "K"
	_nCusEmb := _nCusEmb / nDensidade
EndIf
_nPesoTot  := (_nQtdEmb*TMP1->B1_PESO)+nBaseCalKg
_nValExtra := (nValRefCom*TMP1->B1_VQ_PEXT) / 100
_nPriCusto := nValRefCom + nFrete + _nCusEmb + _nValExtra

If !AllTrim(TMP1->B1_COD) == "03000"
	_nValFrete := (nFretTon * _nPesoTot) / nBaseCal
	If TMP1->B1_VQ_UMEM != cUm
		If TMP1->B1_VQ_UMEM != "K"
			//			_nValFrete := _nValFrete * nDensidade /// Verificar
			//		Else
			_nValFrete := _nValFrete / nDensidade
		EndIf
	ElseIf TMP1->B1_VQ_UMEM == "K"
		_nValFrete := _nValFrete / nDensidade
	EndIf
Else
	_nValFrete := ((nFretMet * nBaseCal) / 15000)
	If TMP1->B1_VQ_UMEM != cUm
		If TMP1->B1_VQ_UMEM == "K"
			_nValFrete := _nValFrete / nDensidade
		Else
			_nValFrete := _nValFrete //* nFatConv
		EndIf
	EndIf
EndIf

RecLock("TMP1",.F.)
TMP1->CAPA_FATOR := _nCapacida	// Capacidade
TMP1->B1_QTDEMB  := _nQtdEmb	// Quantidade de Embalagem
TMP1->CUSTOEMBAL := _nCusEmb
TMP1->B1_VQ_VEXT := _nValExtra	// Valor Extra
TMP1->B1_VQ_FRET := _nValFrete
TMP1->B1_CUSTO1  := _nPriCusto
MsUnLock()

Return()

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: fCalcCus | Autor: Celso Ferrone Martins  | Data: 12/03/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fCalcCus(cCodTmp1,lAtuEst)

Default lAtuEst := .F.
If Empty(cCodTmp1)
	Return()
EndIf

_nCusEmb   := TMP1->CUSTOEMBAL
_nValExtra := TMP1->B1_VQ_VEXT  // Valor Extra
_nValFrete := TMP1->B1_VQ_FRET
_nPriCusto := TMP1->B1_CUSTO1

cCodEm     := TMP1->B1_COD
cDescEm    := TMP1->B1_DESC
nPIcmsEm   := TMP1->B1_VQ_ICMS
nPIpiEm    := TMP1->B1_VQ_IPI
nValEm     := TMP1->B1_VQ_RCOM
cCodPai    := TMP1->B1_CODPAI
cDescPai   := Posicione("SB1",1,xFilial("SB1")+cCodPai,"B1_DESC")
nPerExt    := TMP1->B1_VQ_PEXT
cB1Blql    := SubStr(TMP1->B1_MSBLQL,1,1)
cEmbCus    := SubStr(TMP1->B1_VQ_EMCS,1,1)

TMP2->(DbGoTop())
_xLetra := "A"
While !TMP2->(Eof())
	
	_nValTabela := 0
	If Z02->(DbSeek(cFilAnt+TMP1->B1_CODPAI))//DANILO BUSSO 18/08/2016
		If Z03->(DbSeek(xFilial("Z03")+TMP1->B1_CODPAI+Z02->Z02_REVISA+_xLetra))
			_nValTabela := Z03->Z03_VALCAL
		EndIf
	EndIf
	
	_nTabx    := &("nTab"+_xLetra)
	//	_nMarkUp  := _nPriCusto/(((nValRefCom*(1-nPerIcms/100))+nFrete+_nValExtra-((nValRefCom+nFrete+_nCusEmb+_nValFrete)*((nPerPis+nPerCof)/100))+_nValFrete+(_nCusEmb*((100-nPIcmsEm)/100)))/(100-nPIcmsMp-nPerPis-nPerCof-nPerIR-(nCustoOp+_nTabx))*100)
	
	nCalc01  := (nValRefCom*(1-nPerIcms/100))+nFrete+_nValExtra+_nValFrete
	nCalc02  := (nValRefCom+nFrete+_nCusEmb+_nValFrete)*((nPerPis+nPerCof)/100)
	nCalc03  := _nCusEmb*((100-nPIcmsEm)/100)
	nCalc04  := 100-nPIcmsMp-nPerPis-nPerCof-nPerIR-(nCustoOp+_nTabx)
	nCalc05  := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
	_nMarkUp := _nPriCusto/nCalc05
	_nMarkUp := Round(_nMarkUp,4)
	
	_nValVend := _nPriCusto / _nMarkUp
	_nValCalc := _nValVend / nBaseCal
	_nValIcms := (_nValVend-(nValRefCom+nDifIcms+_nCusEmb))*(nPerIcms/100)
	_nValPisC := (_nValVend-(nValRefCom+nDifIcms+nFrete+_nCusEmb+_nValFrete))*((nPerPis+nPerCof)/100)
	_nCusOper := _nValVend*(nCustoOp/100)
	_nCusto2  := _nValFrete+_nPriCusto+_nValIcms+_nValPisC+_nCusOper
	_nLucBrut := _nValVend-_nCusto2
	_nValIr   := _nValVend*(nPerIR/100)
	_nLucLic  := _nLucBrut-_nValIr
	
	RecLock("TMP2",.F.)
	TMP2->VALVEND   := _nValVend
	TMP2->TBPRECO   :=_nValTabela
	TMP2->VLCALC    := _nValCalc
	TMP2->MARKUP    := _nMarkUp
	TMP2->ICMS      := _nValIcms
	TMP2->PISCOFINS := _nValPisC
	TMP2->CUSOPER   := _nCusOper
	TMP2->CUSTO2    := _nCusto2
	TMP2->LUCROBRU  := _nLucBrut
	TMP2->IR        := _nValIr
	TMP2->LUCROLIQ  := _nLucLic
	MsUnLock()
	
	_xLetra := Soma1(_xLetra)
	
	TMP2->(DbSkip())
EndDo

TMP2->(DbGoTop())
oMark2:oBrowse:Refresh()
oCodEm:Refresh()
oDescEm:Refresh()
oDescEm2:Refresh()
//oIcmEm:Refresh()
//oCodMP4:Refresh()
oExtra:Refresh()
oB1Blql:Refresh()
oEmbCus:Refresh()
oValEm:Refresh()
oIcmEm:Refresh()
oIpiEm:Refresh()
oExtra:Refresh()

oCodPai:Refresh()
oDescPai:Refresh()
oDescMp:Refresh()

If lAtuEst
	oTree:Reset()
	If SG1->(DbSeek(xFilial("SG1")+cCodPai))
		cRevisao := Posicione("SB1",1,xFilial("SB1")+cCodPai,"B1_REVATU")
		A200GetRev(lGetRevisao, oDlg, oTree, cCodPai, cRevisao, nOpcX, lRevAut,@aPaiEstru)
	EndIf
	oTree:Refresh()
EndIf

Return()

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: CfmFHtml | Autor: Celso Ferrone Martins  | Data: 10/03/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
User Function CfmFHtml(cMsg,cColor,cTamFont,cAlign)

Local aMsg     := {}
Local cBody    := ""
Local lCabec   := .T.
Local cStr     := ""
Local cSegCor  := "Blue"
Local cSegTFnt := "20"
Local bEval

Default cColor   := "Brown"
Default cTamFont := "25"
Default cAlign   := "C"

If cAlign == "C"
	cAlign := "Center"
ElseIf cAlign == "L"
	cAlign := "Left"
ElseIf cAlign == "R"
	cAlign := "Rigth"
Else
	cAlign := "Center"
EndIf

iIf(Empty(cColor),cColor:="Brown",)
iIf(Empty(cTamFont),cTamFont:="25",)

cMsg := StrTran(cMsg,CRLF,"|")
cMsg := StrTran(cMsg,"'","")
cMsg := Alltrim(cMsg)
cMsg := iIf(Right(cMsg,1)=="|",Substr(cMsg,1,Len(cMsg)-1),cMsg)

cStr  := StrTran(cMsg,"|","'),AADD(aMsg,'")
cStr  := "AADD(aMsg,'" + cStr + "')"
bEval := &("{||" + cStr + "}")
EVAL(bEval)

cBody := "<table align='"+cAlign+"' heigth='200px'>"
For nA := 1 to Len(aMsg)
	//	cBody += "<tr bgcolor='#FF0000'>"
	cBody += "<tr>"
	cBody += "<td align='"+cAlign+"' style='font-Size: "+cTamFont+"pt; color: "+cColor+"; font-family: Verdana; font-weight: bold; vertical-align: middle; text-align: center;'>"
	cBody += aMsg[nA]
	cBody += "</td>"
	cBody += "</tr>"
	If lCabec
		lCabec   := .F.
		cColor   := cSegCor
		cTamFont := cSegTFnt
	EndIf
Next nA
cBody += "</table>"

Return cBody

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: fCfmAtul | Autor: Celso Ferrone Martins  | Data: 14/03/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fCfmAtul()

If Empty(cCodEm)
	MsgAlert("Selecione alguma embalagem","Atencao!!!")
	Return()
EndIf

TMP1->(DbSeek(cCodEm))

_nValIPI   := (nValEm*nPIpiEm)/100
//_nQtdEmb   := nBaseCal/Posicione("SB1",1,xFilial("SB1")+cCodEm,"B1_VQ_ECAP")
_nQtdEmb   := nBaseCal/TMP1->_CAPACEMBA

If SubStr(cEmbCus,1,1) == "S"
	_nCusEmb := (((nValEm+_nValIPI)*_nQtdEmb) / nTaxConv) // / nFatConv
Else
	_nCusEmb := 0
EndIf

_nPerExtra := nPerExt
_nValExtra := (nValRefCom*_nPerExtra) / 100
_nPriCusto := nValRefCom + nFrete + _nCusEmb  + _nValExtra

RecLock("TMP1",.F.)
TMP1->CUSTOEMBAL := _nCusEmb
TMP1->B1_VQ_RCOM := nValEm
TMP1->B1_VQ_IPI  := nPIpiEm
TMP1->B1_VQ_ICMS := nPIcmsEm
TMP1->B1_VQ_PEXT := _nPerExtra // % Extra
TMP1->B1_VQ_VEXT := _nValExtra // Valor Extra
TMP1->B1_CUSTO1  := _nPriCusto // Primeiro Custo
TMP1->B1_MSBLQL  := iIf(cB1Blql=="S","Sim","Nao")
TMP1->B1_VQ_EMCS := iIf(cEmbCus=="S","Sim","Nao")
MsUnLock()

oMark1:oBrowse:Refresh()

fCalcCus(TMP1->B1_COD,.F.)

Return()

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: fGrvaZ02 | Autor: Celso Ferrone Martins  | Data: 14/03/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fGrvaZ02()

Local cZ02Revs  := "0001"
Local lAtuValor := .F.
Local _cMoeda   := ""
//Local _nFatConv := 0
Local _nTaxConv := 0
//Local nRecTmp1  := TMP1->(RecNo())

If Empty(cCodMp) //.Or. Empty(cCodEm)
	MsgAlert("Selecione uma materia prima e uma embalagem.","Atencao.")
	Return()
EndIf

If lCodMp
	fCfmCalcu()
EndIf

If !MsgYesNo("Deseja atualizar a tabela de preco?","Salvar Tabela")
	Return()
EndIf

TMP1->(DbGoTop())
While !TMP1->(Eof())
	
	//If TMP1->B1_MSBLQL == "Sim"
		
		fCalcCus(TMP1->B1_COD,.T.)
		
		If SB1->(DbSeek(xFilial("SB1")+cCodPai))
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL  := Iif(SubStr(cB1Blql,1,1)=="S","2","1")
			SB1->B1_GRTRIB  := cGrTrib
			SB1->B1_VQ_EMCS := Upper(SubStr(cEmbCus,1,1))
			MsUnLock()
		EndIf
		
		If SB1->(DbSeek(xFilial("SB1")+cCodMp))
			If SB1->B1_VQ_ICMS != nPerIcms
				CfmAtuIcm(cCodMp,nPerIcms)
			EndIf
			RecLock("SB1",.F.)
			SB1->B1_VQ_FRET := nFrete           // Frete de Compra
			If SB1->B1_VQ_RCOM != nValRefCom
				SB1->B1_VQ_RCOM := nValRefCom   // Valor de Referencia de Compra
				SB1->B1_VQ_DATA := dDataBase    // Data de Referencia de Compra
			EndIf
			SB1->B1_VQ_ICMS := nPerIcms         // ICMS
			SB1->B1_GRTRIB  := cGrTrib			// Excecao Fiscal
			SB1->B1_VQ_IPI  := nPerIpi          // IPI
			SB1->B1_VQ_UM   := If(cUm=="K","KG","L ")
			SB1->B1_VQ_MOED := SubStr(cMoeda,2,1)
			MsUnLock()
		EndIf
		
		TMP1->(DbSeek(cCodEm))
		
		If SB1->(DbSeek(xFilial("SB1")+cCodEm))
			RecLock("SB1",.F.)
			If SB1->B1_VQ_RCOM != TMP1->B1_VQ_RCOM
				SB1->B1_VQ_RCOM := TMP1->B1_VQ_RCOM   // Valor de Referencia de Compra
				SB1->B1_VQ_DATA := dDataBase    // Data de Referencia de Compra
			EndIf
			SB1->B1_VQ_ICMS := TMP1->B1_VQ_ICMS      // ICMS
			SB1->B1_VQ_IPI  := TMP1->B1_VQ_IPI       // IPI
			MsUnLock()
		EndIf
		
		SB1->(DbSeek(xFilial("SB1")+cCodPai))
		
		If Z02->(DbSeek(cFilAnt+cCodPai))//DANILO BUSSO 18/08/2016
			cZ02Revs := Soma1(Z02->Z02_REVISA)
			RecLock("Z02",.F.)
		Else
			RecLock("Z02",.T.)
			Z02->Z02_FILIAL := xFilial("Z02")
			Z02->Z02_COD    := cCodPai
			Z02->Z02_DATAIN := dDataBase
			Z02->Z02_ORIGEM := "CFMTPREC"
		EndIf
		Z02->Z02_REVISA := cZ02Revs
		Z02->Z02_DATAAL := dDataBase
		Z02->Z02_UM     := If(cUm=="K","KG","L ")
		Z02->Z02_MOEDA  := If(cMoeda=="01","1","2")
		Z02->Z02_TXMOED := nTaxaM2
		
		Z02->Z02_DATACO := dDataRef
		Z02->Z02_FRETEC := nFrete  
		If (Z02->Z02_REFCOM <> nValRefCom)
			dDatRefCom := Date()
		EndIf                   
		Z02->Z02_DTRCOM := dDatRefCom
		Z02->Z02_REFCOM := nValRefCom
		Z02->Z02_DENSID := nDensidade             

		Z02->Z02_MARGEA := nTabA
		Z02->Z02_MARGEB := nTabB
		Z02->Z02_MARGEC := nTabC
		Z02->Z02_MARGED := nTabD
		Z02->Z02_MARGEE := nTabE
		Z02->Z02_CUSOPE := nCustoOp
		Z02->Z02_CODMP  := cCodMp
		Z02->Z02_CODEM  := cCodEm
		Z02->Z02_PICMMP := nPerIcms
		Z02->Z02_PIPIMP := nPerIpi
		Z02->Z02_PICMEM := nPIcmsEm
		Z02->Z02_PIPIEM := nPIpiEm
		Z02->Z02_CUSTO  := Posicione("SB1",1,xFilial("SB1")+cCodEm,"B1_VQ_RCOM")
		Z02->Z02_PEXTRA := TMP1->B1_VQ_PEXT
		Z02->Z02_VEXTRA := TMP1->B1_VQ_VEXT                        

		MsUnLock()

		//Tabela de Auditoria
		RecLock("Z15",.T.)
		Z15->Z15_FILIAL := xFilial("Z15")
		Z15->Z15_COD    := cCodPai
		Z15->Z15_DATAIN := dDataBase
		Z15->Z15_ORIGEM := "CFMTPREC"
   		Z15->Z15_REVISA := cZ02Revs
		Z15->Z15_DATAAL := dDataBase
		Z15->Z15_UM     := If(cUm=="K","KG","L ")
		Z15->Z15_MOEDA  := If(cMoeda=="01","1","2")
		Z15->Z15_TXMOED := nTaxaM2
		Z15->Z15_DATACO := dDataRef
		Z15->Z15_FRETEC := nFrete
		Z15->Z15_REFCOM := nValRefCom
		Z15->Z15_DENSID := nDensidade
		Z15->Z15_DTRCOM := dDatRefCom
		Z15->Z15_MARGEA := nTabA
		Z15->Z15_MARGEB := nTabB
		Z15->Z15_MARGEC := nTabC
		Z15->Z15_MARGED := nTabD
		Z15->Z15_MARGEE := nTabE
		Z15->Z15_CUSOPE := nCustoOp
		Z15->Z15_CODMP  := cCodMp
		Z15->Z15_CODEM  := cCodEm
		Z15->Z15_PICMMP := nPerIcms
		Z15->Z15_PIPIMP := nPerIpi
		Z15->Z15_PICMEM := nPIcmsEm
		Z15->Z15_PIPIEM := nPIpiEm
		Z15->Z15_CUSTO  := Posicione("SB1",1,xFilial("SB1")+cCodEm,"B1_VQ_RCOM")
		Z15->Z15_PEXTRA := TMP1->B1_VQ_PEXT
		Z15->Z15_VEXTRA := TMP1->B1_VQ_VEXT
		Z15->Z15_REVUSR := Upper(cUserName)
		Z15->Z15_REVDAT := Date()
		Z15->Z15_REVTIM := Time()
		Z15->Z15_VQEMCS := cEmbCus
		Z15->Z15_B1MSBL := cB1Blql
		MsUnLock()
		
		cLetra := "A"
		
		TMP2->(DbGoTop())
		While !TMP2->(Eof())
			
			RecLock("Z03",.T.)
			Z03->Z03_FILIAL := xFilial("Z03")   //
			Z03->Z03_COD    := cCodPai          //
			Z03->Z03_TABELA := TMP2->LETRA      //
			Z03->Z03_REVISA := cZ02Revs         //
			Z03->Z03_UM     := If(cUm=="K","KG","L ")
			Z03->Z03_MOEDA  := If(cMoeda=="01","1","2")
			Z03->Z03_CUSTOE := TMP1->CUSTOEMBAL
			Z03->Z03_FRTTON := nFretTon         // Custo do Frete por Tonelada
			Z03->Z03_FRTCUB := nFretMet         // Custo do Frete por Metro Cubico
			Z03->Z03_MARGEM := &("nTab"+cLetra) //
			Z03->Z03_CAPACI := TMP1->CAPA_FATOR // Capacidade
			Z03->Z03_FREENT := TMP1->B1_VQ_FRET // Frete de Entrega
			Z03->Z03_CUSTO1 := TMP1->B1_CUSTO1  //
			Z03->Z03_VALVEN := TMP2->VALVEND    // Valor de Venda
			Z03->Z03_VALCAL := TMP2->VLCALC     //
			Z03->Z03_MARKUP := TMP2->MARKUP     //
			Z03->Z03_VALICM := TMP2->ICMS       //
			Z03->Z03_PISCOF := TMP2->PISCOFINS  //
			Z03->Z03_CUSOPE := TMP2->CUSOPER    //
			Z03->Z03_CUSTO2 := TMP2->CUSTO2     //
			Z03->Z03_LUCBRU := TMP2->LUCROBRU   //
			Z03->Z03_VALIR  := TMP2->IR         //
			Z03->Z03_LUCLIQ := TMP2->LUCROLIQ   //
			Z03->Z03_ORIGEM := "CFMTPREC"
			Z03->Z03_REVUSR := Upper(cUserName)
			Z03->Z03_REVDAT := Date()
			MsUnLock()
			cLetra := Soma1(cLetra)
			TMP2->(DbSkip())
		EndDo
		
		TMP2->(DbGoTop())
/*
	Else

		If SB1->(DbSeek(xFilial("SB1")+TMP1->B1_CODPAI))
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL  := Iif(SubStr(TMP1->B1_MSBLQL,1,1)=="S","2","1")
			MsUnLock()
		EndIf
	EndIf
*/
	TMP1->(DbSkip())
	
EndDo

//TMP1->(DbGoTop())
//TMP1->(DbGoTo(nRecTmp1))
//fCalcCus(TMP1->B1_COD,.T.)
fCfmConPad("","",.T.)

MsgAlert("Tabela de preco atualizada com sucesso.","Atualizado!!")

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fConsEst  | Autor: Celso Ferrone Martins   | Data: 18/06/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Chamada de rotina visualizar o estoque de mercadoria        |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fConsEst()

If Empty(cCodPai)
	MsgAlert("Selecione alguma embalagem.","Atencao!!!")
	Return()
EndIf

If lCodMp
	fCfmCalcu()
EndIf

U_VQCONPROD(cCodPai)

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmClose | Autor: Celso Ferrone Martins   | Data: 25/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Encerra rotina de formacao de Preco                         |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function fCfmClose()

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf
If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf
If Select("TMP2") > 0
	TMP2->(DbCloseArea())
EndIf
If Select("TRBMP") > 0
	TRBMP->(DbCloseArea())
EndIf

Close(oDlg)

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmEdit  | Autor: Celso Ferrone Martins   | Data: 12/06/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Encerra rotina de formacao de Preco                         |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function fCfmEdit()

fCfmParam()

If !Empty(cCodMp)
	If  !Empty(cCodEm) .And. !lCodMp
		lCodMp := .T.
		lPerIcms := iIf(Empty(cGrTrib),.T.,.F.)
		oMark1:OBROWSE:LACTIVE := .F.
	EndIf
Else
	MsgAlert("Selecione uma materia prima e uma embalagem!","Atencao!")
EndIf

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmCalcu | Autor: Celso Ferrone Martins   | Data: 12/06/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Encerra rotina de formacao de Preco                         |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
Static Function fCfmCalcu()

fCfmParam()

If lVersolve
	CfmVerCalc()
EndIf

If !Empty(cCodMp) .And. !Empty(cCodEm) .And. lCodMp
	
	lCodMp   := .F.
	lPerIcms := .F.
	
	oMark1:OBROWSE:LACTIVE := .T.
	
	//	If cUm == "01" // Metros Cubicos
	//		nFatConv := 1
	//	Else           // Toneladas
	//		nFatConv := nDensidade
	//	EndIf
	
	If cMoeda == "01" // Real
		nTaxConv := 1
	Else              // Dolar
		nTaxConv := nTaxaM2
	EndIf
	
	nFretTon := _nFretTon / nTaxConv // Custo do Frete por Tonelada
	nFretMet := _nFretMet / nTaxConv // Custo do Frete por Metro Cubico
	
	nPIcmsMp := nPerIcms
	
	If TMP1->(Eof())
		Return()
	EndIf
	
	nRecTmp1 := TMP1->(RecNo())
	TMP1->(DbGoTop())
	While !TMP1->(Eof())
		
		fPrimeiroCusto()
		
		TMP1->(DbSkip())
	EndDo
	TMP1->(DbGoTop())
	TMP1->(DbGoTo(nRecTmp1))
	
	fCalcCus(cCodEm)
	
	oMark1:oBrowse:Refresh()
	oCod:Refresh()
	
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmAtuIcm | Autor: Celso Ferrone Martins  | Data: 18/08/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Ajusta Icms dos itens com a mesma materia prima            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function CfmAtuIcm(cCodMp,nPerIcms)

cQuery := " UPDATE " + RetSqlName("SB1")
cQuery += " SET B1_VQ_ICMS = " + AllTrim(Str(nPerIcms))
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += "    AND B1_VQ_MP = '"+AllTrim(cCodMp)+"' "

MsAguarde({ | | TcSqlExec(cQuery) },"Por favor aguarde","Ajustando ICMS")

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmVExce | Autor: Celso Ferrone Martins   | Data: 26/08/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Validacao do campo de Excecao Fiscal                       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmVExce()

Local lRet := .T.

If !Empty(cGrTrib)
	lPerIcms := .F.
	nPerIcms := 0
	lRet := ExistCpo("SX5","21"+cGrTrib)
	If lRet
		DbSelectArea("SF7") ; DbSetOrder(1)
		If SF7->(DbSeek(xFilial("SF7")+cGrTrib))
			While !SF7->(Eof()) .And. SF7->(F7_FILIAL+F7_GRTRIB) == xFilial("SF7") + cGrTrib
				If SF7->F7_EST == "SP"
//					nPerIcms := SF7->F7_ALIQINT
					If AllTrim(SB1->B1_GRTRIB) == "001"
						nPerIcms := SF7->F7_ALIQINT // VERIFICAR - CELSO MARTINS 05/01/2015
					Else
						nPerIcms := SF7->F7_ALIQEXT // VERIFICAR - CELSO MARTINS 05/01/2015
					EndIf
					Exit
				EndIf
				SF7->(DbSkip())
			EndDo
		EndIf
		If nPerIcms == 0
			MsgAlert("Excecao Fiscal de ICMS para o grupo tributario "+cGrTrib+" nao cadastrado para o estado de SP","Atencao!!!")
		EndIf
	EndIf
Else
	lPerIcms := .T.
	CfmVIcms()
EndIf

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmVExce | Autor: Celso Ferrone Martins   | Data: 26/08/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Validacao do campo de Excecao Fiscal                       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmVIcms()

Local lRet := .T.

If nPerIcms <> 18
	MsgAlert("Para Icms diferente de 18% verificar a necessidade de utilizar Excecao Fiscal para o estado de SP","Atencao!!! Icms 18%")
EndIf

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmVerCalc | Autor: Celso Ferrone Martins | Data: 15/09/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Calculo de Custo Produtos Versolve                         |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function CfmVerCalc()

Local aAreaSg1  := SG1->(GetArea())
Local aAreaSb1  := SB1->(GetArea())
Local aStruVers := {}
Local aDadosVer := {}

DbSelectArea("SG1") ; DbSetOrder(1)
DbSelectArea("SB1") ; DbSetOrder(1)

SB1->(DbSeek(xFilial("SB1")+cCodMp))

aAdd(aStruVers,cCodMp) 				//01 - Codigo Produto Pai
aAdd(aStruVers,SB1->B1_UM)			//02 - Um
aAdd(aStruVers,SB1->B1_CONV)		//03 - Densidade
aAdd(aStruVers,SB1->B1_QB) 			//04 - Quantidade Base
aAdd(aStruVers,0)					//05
aAdd(aStruVers,cUm)			   		//06 - UM
aAdd(aStruVers,SubStr(cMoeda,2,1))	//07 - Moeda
aAdd(aStruVers,0)					//08 - Referencia de Compra
aAdd(aStruVers,0)					//09 - Frete
aAdd(aStruVers,nPerIcms)			//10 - ICms
aAdd(aStruVers, 1-((nPerIcms/100)+((nPerPis+nPerCof)/100)) )
aAdd(aStruVers,{})					//12 - Componentes

SG1->(DbSeek(xFilial("SG1")+cCodMp))
While !SG1->(Eof()) .And. SG1->(G1_FILIAL+G1_COD) == xFilial("SG1") + cCodMp
	
	SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
	aDadosVer := {}
	Aadd(aDadosVer,SG1->G1_COMP)						//01 - Codigo Produto
	Aadd(aDadosVer,SB1->B1_UM)							//02 - Um
	Aadd(aDadosVer,SB1->B1_CONV) 						//03 - Densidade
	Aadd(aDadosVer,SG1->G1_QUANT)						//04 - Quantidade
	Aadd(aDadosVer,SG1->G1_VQ_PVER)						//05 - % do produto
	Aadd(aDadosVer,SB1->B1_VQ_UM)						//06 - UM da Tabela
	Aadd(aDadosVer,SB1->B1_VQ_MOED) 					//07 - Moeda da Tabela
	Aadd(aDadosVer,SB1->B1_VQ_RCOM) 					//08 - Referencia de Compra
	Aadd(aDadosVer,SB1->B1_VQ_FRET) 					//09 - Frete
	Aadd(aDadosVer,SB1->B1_VQ_ICMS)						//10 - ICMS do Componente
	Aadd(aDadosVer,1-((SB1->B1_VQ_ICMS/100)+((nPerPis+nPerCof)/100)) ) //11 - Dif Icms
	Aadd(aStruVers[12],aDadosVer)
	
	SG1->(DbSkip())
EndDo

For Nx := 1 To Len(aStruVers[12])
	
	If SubStr(aStruVers[6],1,1) <> SubStr(aStruVers[12][nX][6],1,1)
		nCalRCom := (aStruVers[12][nX][8]*aStruVers[12][nX][11]) // Referencia de Compra Tirando ICMS da tabela
		nCalFret := aStruVers[12][nX][9]
	
		//ALERT("1 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99"))
	
	Else
		If AllTrim(aStruVers[12][nX][6]) == "KG"
			nCalRCom := aStruVers[12][nX][8] * aStruVers[12][nX][3]
			nCalFret := aStruVers[12][nX][9] * aStruVers[12][nX][3]
			//ALERT("2 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99"))
		Else
			nCalRCom := aStruVers[12][nX][8] / aStruVers[12][nX][3]
			nCalFret := aStruVers[12][nX][9] / aStruVers[12][nX][3]
			//ALERT("3 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99"))
		EndIf
		nCalRCom := (nCalRCom*aStruVers[12][nX][11]) // Referencia de Compra Tirando ICMS da tabela
		//ALERT("4 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99")) 
	EndIf
	
	If aStruVers[7] != aStruVers[12][nX][7]
		If aStruVers[12][nX][7] == "1"
			nCalRCom := nCalRCom / nTaxaM2
			nCalFret := nCalFret / nTaxaM2
			//ALERT("5 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99"))
		Else
			nCalRCom := nCalRCom * nTaxaM2
			nCalFret := nCalFret * nTaxaM2
			//ALERT("6 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99"))
		EndIf
	EndIf
	
	If cUM$"KG" .And. cMoeda$"02"
		nCalRCom := ((nCalRCom / aStruVers[12][nX][3]))
	ElseIf cUM$"L" .And. cMoeda$"02"
		nCalRCom := ((nCalRCom * aStruVers[12][nX][3]))
	ElseIf cUM$"L" .And. cMoeda$"01"
		nCalRCom := ((nCalRCom * aStruVers[12][nX][3]))
	ElseIf cUM$"KG" .And. cMoeda$"01"
		nCalRCom := ((nCalRCom / aStruVers[12][nX][3]))
	EndIf 

	nCalRCom     := nCalRCom / aStruVers[11]
	aStruVers[8] += (nCalRCom / 100) * aStruVers[12][nX][5]	// Versolver - Ref. Compra
	aStruVers[9] += (nCalFret / 100) * aStruVers[12][nX][5]	// Versolver - Frete
	//aStruVers[8] += (nCalRCom/10)
	//aStruVers[9] += (nCalFret/10)
	
	
	//ALERT("Preco Ref "+TRANSFORM(aStruVers[8],"@E 999,999,999.99"))
	//ALERT("7 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99"))

Next

nValRefCom := aStruVers[8]
nFrete     := aStruVers[9]

SG1->(RestArea(aAreaSg1))
SB1->(RestArea(aAreaSb1))

oFrete:Refresh()
oValor:Refresh()

//ALERT("8 -"+TRANSFORM(nCalRcom,"@E 999,999,999.99"))

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fTabPrec  | Autor: Celso Ferrone Martins   | Data: 18/06/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Chamada de rotina para a atualizacao da tabela de preco     |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fTabPrec()

If lCodMp
	fCfmCalcu()
EndIf

U_CfmAtuPrc()

fCfmConPad("","",.T.)

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: fComposi | Autor: Celso Ferrone Martins   | Data: 23/09/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Botao de composicao do produto                             |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fComposi() 

If lCodMp
	fCfmCalcu()
EndIf

U_CFMVERSO(cCodMp)

fCfmConPad("","",.T.)

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: fCfmSc7  | Autor: Celso Ferrone Martins   | Data: 06/01/2015 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Seleciona ultimo pedido de compra                          |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fCfmSc7()

Local aAreaSc7  := SC7->(GetArea())
Local _nValItem := 0

DbSelectArea("SC7") ; DbSetOrder(1)   
DbSelectArea("SA2") ; DbSetOrder(1)

dD1DtDigit := cTod("")
nD1Quant   := 0
nD1Valor   := 0
nD1Icms    := 0
cD1Frete   := ""  
cC7TFret   := "" //Danilo Busso
nC7VFret   := 0  //Danilo Busso 
cC7Forne   := "" //Danilo Busso  
cC7Pedid   := "" //Danilo Busso
cD1Um      := ""
cD1Moeda   := ""
cD1Embal   := ""

cQuery := " "
cQuery += " SELECT * FROM (" + cEol
cQuery += "    SELECT " + cEol
cQuery += "      D1_FILIAL, " + cEol
cQuery += "      D1_ITEM, " + cEol
cQuery += "      D1_COD, " + cEol
cQuery += "      D1_UM, " + cEol
cQuery += "      D1_SEGUM, " + cEol
cQuery += "      D1_QUANT, " + cEol
cQuery += "      D1_VUNIT, " + cEol
cQuery += "      D1_TOTAL, " + cEol
cQuery += "      D1_VALIPI, " + cEol
cQuery += "      D1_VALICM, " + cEol
cQuery += "      D1_TES, " + cEol
cQuery += "      D1_CF, " + cEol
cQuery += "      D1_DESC, " + cEol
cQuery += "      D1_IPI, " + cEol
cQuery += "      D1_PICM, " + cEol
cQuery += "      D1_PESO, " + cEol
cQuery += "      D1_CONTA, " + cEol
cQuery += "      D1_ITEMCTA, " + cEol
cQuery += "      D1_CC, " + cEol
cQuery += "      D1_OP, " + cEol
cQuery += "      D1_PEDIDO, " + cEol
cQuery += "      D1_ITEMPC, " + cEol
cQuery += "      D1_FORNECE, " + cEol
cQuery += "      D1_LOJA, " + cEol
cQuery += "      D1_LOCAL, " + cEol
cQuery += "      D1_DOC, " + cEol
cQuery += "      D1_EMISSAO, " + cEol
cQuery += "      D1_DTDIGIT, " + cEol
cQuery += "      D1_GRUPO, " + cEol
cQuery += "      D1_TIPO, " + cEol
cQuery += "      D1_SERIE, " + cEol
cQuery += "      D1_CUSTO2, " + cEol
cQuery += "      D1_CUSTO3, " + cEol
cQuery += "      D1_CUSTO4, " + cEol
cQuery += "      D1_CUSTO5, " + cEol
cQuery += "      D1_TP, " + cEol
cQuery += "      D1_QTSEGUM, " + cEol
cQuery += "      D1_NUMSEQ, " + cEol
cQuery += "      D1_DATACUS, " + cEol
cQuery += "      D1_NFORI, " + cEol
cQuery += "      D1_SERIORI, " + cEol
cQuery += "      D1_ITEMORI, " + cEol
cQuery += "      D1_QTDEDEV, " + cEol
cQuery += "      D1_VALDEV, " + cEol
cQuery += "      D1_ORIGLAN, " + cEol
cQuery += "      D1_ICMSRET, " + cEol
cQuery += "      D1_BRICMS, " + cEol
cQuery += "      D1_NUMCQ, " + cEol
cQuery += "      D1_DATORI, " + cEol
cQuery += "      D1_BASEICM, " + cEol
cQuery += "      D1_VALDESC, " + cEol
cQuery += "      D1_IDENTB6, " + cEol
cQuery += "      D1_LOTEFOR, " + cEol
cQuery += "      D1_SKIPLOT, " + cEol
cQuery += "      D1_BASEIPI, " + cEol
cQuery += "      D1_SEQCALC, " + cEol
cQuery += "      D1_LOTECTL, " + cEol
cQuery += "      D1_NUMLOTE, " + cEol
cQuery += "      D1_DTVALID, " + cEol
cQuery += "      D1_PLACA, " + cEol
cQuery += "      D1_CHASSI, " + cEol
cQuery += "      D1_ANOFAB, " + cEol
cQuery += "      D1_MODFAB, " + cEol
cQuery += "      D1_MODELO, " + cEol
cQuery += "      D1_COMBUST, " + cEol
cQuery += "      D1_COR, " + cEol
cQuery += "      D1_EQUIPS, " + cEol
cQuery += "      D1_FORMUL, " + cEol
cQuery += "      D1_II, " + cEol
cQuery += "      D1_TEC, " + cEol
cQuery += "      D1_CONHEC, " + cEol
cQuery += "      D1_NUMPV, " + cEol
cQuery += "      D1_ITEMPV, " + cEol
cQuery += "      D1_CUSFF1, " + cEol
cQuery += "      D1_CUSFF2, " + cEol
cQuery += "      D1_CUSFF3, " + cEol
cQuery += "      D1_CUSFF4, " + cEol
cQuery += "      D1_CUSFF5, " + cEol
cQuery += "      D1_CODCIAP, " + cEol
cQuery += "      D1_CLASFIS, " + cEol
cQuery += "      D1_BASIMP1, " + cEol
cQuery += "      D1_REMITO, " + cEol
cQuery += "      D1_SERIREM, " + cEol
cQuery += "      D1_CUSTO, " + cEol
cQuery += "      D1_BASIMP3, " + cEol
cQuery += "      D1_BASIMP4, " + cEol
cQuery += "      D1_BASIMP5, " + cEol
cQuery += "      D1_BASIMP6, " + cEol
cQuery += "      D1_VALIMP1, " + cEol
cQuery += "      D1_VALIMP2, " + cEol
cQuery += "      D1_VALIMP3, " + cEol
cQuery += "      D1_VALIMP4, " + cEol
cQuery += "      D1_VALIMP5, " + cEol
cQuery += "      D1_VALIMP6, " + cEol
cQuery += "      D1_CBASEAF, " + cEol
cQuery += "      D1_ICMSCOM, " + cEol
cQuery += "      D1_CIF, " + cEol
cQuery += "      D1_ITEMREM, " + cEol
cQuery += "      D1_BASIMP2, " + cEol
cQuery += "      D1_PROJ, " + cEol
cQuery += "      D1_TIPO_NF, " + cEol
cQuery += "      D1_ALQIMP1, " + cEol
cQuery += "      D1_ALQIMP2, " + cEol
cQuery += "      D1_ALQIMP3, " + cEol
cQuery += "      D1_ALQIMP4, " + cEol
cQuery += "      D1_ALQIMP5, " + cEol
cQuery += "      D1_ALQIMP6, " + cEol
cQuery += "      D1_QTDPEDI, " + cEol
cQuery += "      D1_VALFRE, " + cEol
cQuery += "      D1_RATEIO, " + cEol
cQuery += "      D1_SEGURO, " + cEol
cQuery += "      D1_DESPESA, " + cEol
cQuery += "      D1_BASEIRR, " + cEol
cQuery += "      D1_ALIQIRR, " + cEol
cQuery += "      D1_VALIRR, " + cEol
cQuery += "      D1_BASEISS, " + cEol
cQuery += "      D1_ALIQISS, " + cEol
cQuery += "      D1_VALISS, " + cEol
cQuery += "      D1_BASEINS, " + cEol
cQuery += "      D1_ALIQINS, " + cEol
cQuery += "      D1_VALINS, " + cEol
cQuery += "      D1_CUSORI, " + cEol
cQuery += "      D1_LOCPAD, " + cEol
cQuery += "      D1_CLVL, " + cEol
cQuery += "      D1_ORDEM, " + cEol
cQuery += "      D1_CODFIS, " + cEol
cQuery += "      D1_SERVIC, " + cEol
cQuery += "      D1_STSERV, " + cEol
cQuery += "      D1_ENDER, " + cEol
cQuery += "      D1_TPESTR, " + cEol
cQuery += "      D1_REGWMS, " + cEol
cQuery += "      D1_PCCENTR, " + cEol
cQuery += "      D1_ITPCCEN, " + cEol
cQuery += "      D1_QTPCCEN, " + cEol
cQuery += "      D1_TIPODOC, " + cEol
cQuery += "      D1_POTENCI, " + cEol
cQuery += "      D1_TRT, " + cEol
cQuery += "      D1_TESACLA, " + cEol
cQuery += "      D1_NUMDESP, " + cEol
cQuery += "      D1_ORIGEM, " + cEol
cQuery += "      D1_GRADE, " + cEol
cQuery += "      D1_ITEMGRD, " + cEol
cQuery += "      D1_DESCICM, " + cEol
cQuery += "      D1_BASEPS3, " + cEol
cQuery += "      D1_ALIQPS3, " + cEol
cQuery += "      D1_VALPS3, " + cEol
cQuery += "      D1_BASECF3, " + cEol
cQuery += "      D1_ALIQCF3, " + cEol
cQuery += "      D1_VALCF3, " + cEol
cQuery += "      D1_CFPS, " + cEol
cQuery += "      D1_ABATISS, " + cEol
cQuery += "      D1_ESTCRED, " + cEol
cQuery += "      D1_CODISS, " + cEol
cQuery += "      D1_VALACRS, " + cEol
cQuery += "      D1_ICMSDIF, " + cEol
cQuery += "      D1_BASECOF, " + cEol
cQuery += "      D1_BASECSL, " + cEol
cQuery += "      D1_BASEPIS, " + cEol
cQuery += "      D1_VALCOF, " + cEol
cQuery += "      D1_QTDCONF, " + cEol
cQuery += "      D1_VALFAB, " + cEol
cQuery += "      D1_BASEFAC, " + cEol
cQuery += "      D1_ALIQFAC, " + cEol
cQuery += "      D1_VALFAC, " + cEol
cQuery += "      D1_BASEFET, " + cEol
cQuery += "      D1_ALIQFET, " + cEol
cQuery += "      D1_VALFET, " + cEol
cQuery += "      D1_AVLINSS, " + cEol
cQuery += "      D1_CRDZFM, " + cEol
cQuery += "      D1_PRUNDA, " + cEol
cQuery += "      D1_VALANTI, " + cEol
cQuery += "      D1_SLDDEP, " + cEol
cQuery += "      D1_CODNOR, " + cEol
cQuery += "      D1_BASEFAB, " + cEol
cQuery += "      D1_ALIQFAB, " + cEol
cQuery += "      D1_ABATMAT, " + cEol
cQuery += "      D1_DTFIMNT, " + cEol
cQuery += "      D1_GRUPONC, " + cEol
cQuery += "      D1_CNATREC, " + cEol
cQuery += "      D1_TNATREC, " + cEol
cQuery += "      D1_ALIQSOL, " + cEol
cQuery += "      D1_CRPRSIM, " + cEol
cQuery += "      D1_DFABRIC, " + cEol
cQuery += "      D1_CONBAR, " + cEol
cQuery += "      D1_MARGEM, " + cEol
cQuery += "      D1_NFVINC, " + cEol
cQuery += "      D1_SERVINC, " + cEol
cQuery += "      D1_ITMVINC, " + cEol
cQuery += "      D1_IDSB5, " + cEol
cQuery += "      D1_IDSB1, " + cEol
cQuery += "      D1_IDSBZ, " + cEol
cQuery += "      D1_ALSENAR, " + cEol
cQuery += "      D1_BSSENAR, " + cEol
cQuery += "      D1_REVISAO, " + cEol
cQuery += "      D1_ABATINS, " + cEol
cQuery += "      D1_ALIQINA, " + cEol
cQuery += "      D1_BASEINA, " + cEol
cQuery += "      D1_CONIMP, " + cEol
cQuery += "      D1_VALCMAJ, " + cEol
cQuery += "      D1_VALINA, " + cEol
cQuery += "      D1_VALPMAJ, " + cEol
cQuery += "      D1_VLSENAR, " + cEol
cQuery += "      D1_CRPRESC, " + cEol
cQuery += "      D1_RGESPST, " + cEol
cQuery += "      D1_VALCSL, " + cEol
cQuery += "      D1_VALPIS, " + cEol
cQuery += "      D1_ALQCOF, " + cEol
cQuery += "      D1_ALQCSL, " + cEol
cQuery += "      D1_ALQPIS, " + cEol
cQuery += "      D1_CUSRP1, " + cEol
cQuery += "      D1_CUSRP2, " + cEol
cQuery += "      D1_CUSRP3, " + cEol
cQuery += "      D1_CUSRP4, " + cEol
cQuery += "      D1_CUSRP5, " + cEol
cQuery += "      D1_TRANSIT, " + cEol
cQuery += "      D1_BASESES, " + cEol
cQuery += "      D1_VALSES, " + cEol
cQuery += "      D1_ALIQSES, " + cEol
cQuery += "      D1_OPERADO, " + cEol
cQuery += "      D1_CODLAN, " + cEol
cQuery += "      D1_CODBAIX, " + cEol
cQuery += "      D1_ALIQFUN, " + cEol
cQuery += "      D1_GARANTI, " + cEol
cQuery += "      D1_BASNDES, " + cEol
cQuery += "      D1_ICMNDES, " + cEol
cQuery += "      D1_VALFDS, " + cEol
cQuery += "      D1_PRFDSUL, " + cEol
cQuery += "      D1_UFERMS, " + cEol
cQuery += "      D1_CRPREPR, " + cEol
cQuery += "      D1_BASEFUN, " + cEol
cQuery += "      D1_VALFUN, " + cEol
cQuery += "      D1_ALIQII, " + cEol
cQuery += "      D1_PRINCMG, " + cEol
cQuery += "      D1_VLINCMG, " + cEol
cQuery += "      D1_OKISS, " + cEol
cQuery += "      D1_IDSF7, " + cEol
cQuery += "      D1_IDSF4, " + cEol
cQuery += "      D1_FILORI, " + cEol
cQuery += "      D1_IDCFC, " + cEol
cQuery += "      D1_FCICOD, " + cEol
cQuery += "      D1_VLCIDE, " + cEol
cQuery += "      D1_BASECID, " + cEol
cQuery += "      D1_ALQCIDE, " + cEol
cQuery += "      D1_VALCPM, " + cEol
cQuery += "      D1_BASECPM, " + cEol
cQuery += "      D1_ALQCPM, " + cEol
cQuery += "      D1_BASEFMD, " + cEol
cQuery += "      D1_ALQFMD, " + cEol
cQuery += "      D1_VALFMD, " + cEol
cQuery += "      D1_VQ_VSEG, " + cEol
cQuery += "      D1_VQ_UM, " + cEol
cQuery += "      D1_VALFMP, " + cEol
cQuery += "      D1_BASEFMP, " + cEol
cQuery += "      D1_ALQFMP, " + cEol
cQuery += "      D1_DESCZFR, " + cEol
cQuery += "      D1_DESCZFP, " + cEol
cQuery += "      D1_DESCZFC, " + cEol
cQuery += "      D1_GRPCST, " + cEol
cQuery += "      D1_BASECPB, " + cEol
cQuery += "      D1_VALCPB, " + cEol
cQuery += "      D1_ALIQCPB, " + cEol
cQuery += "      D1_DIFAL, " + cEol
cQuery += "      F1_FILIAL, " + cEol
cQuery += "      F1_DOC, " + cEol
cQuery += "      F1_SERIE, " + cEol
cQuery += "      F1_FORNECE, " + cEol
cQuery += "      F1_LOJA, " + cEol
cQuery += "      F1_COND, " + cEol
cQuery += "      F1_DUPL, " + cEol
cQuery += "      F1_EMISSAO, " + cEol
cQuery += "      F1_EST, " + cEol
cQuery += "      F1_FRETE, " + cEol
cQuery += "      F1_DESPESA, " + cEol
cQuery += "      F1_BASEICM, " + cEol
cQuery += "      F1_VALICM, " + cEol
cQuery += "      F1_BASEIPI, " + cEol
cQuery += "      F1_VALIPI, " + cEol
cQuery += "      F1_VALMERC, " + cEol
cQuery += "      F1_VALBRUT, " + cEol
cQuery += "      F1_TIPO, " + cEol
cQuery += "      F1_DESCONT, " + cEol
cQuery += "      F1_DTDIGIT, " + cEol
cQuery += "      F1_CPROVA, " + cEol
cQuery += "      F1_NUMTRIB, " + cEol
cQuery += "      F1_BRICMS, " + cEol
cQuery += "      F1_ICMSRET, " + cEol
cQuery += "      F1_BASEFD, " + cEol
cQuery += "      F1_DTLANC, " + cEol
cQuery += "      F1_OK, " + cEol
cQuery += "      F1_ORIGLAN, " + cEol
cQuery += "      F1_TX, " + cEol
cQuery += "      F1_CONTSOC, " + cEol
cQuery += "      F1_IRRF, " + cEol
cQuery += "      F1_FORMUL, " + cEol
cQuery += "      F1_NFORIG, " + cEol
cQuery += "      F1_SERORIG, " + cEol
cQuery += "      F1_ESPECIE, " + cEol
cQuery += "      F1_IMPORT, " + cEol
cQuery += "      F1_II, " + cEol
cQuery += "      F1_REMITO, " + cEol
cQuery += "      F1_BASIMP2, " + cEol
cQuery += "      F1_BASIMP3, " + cEol
cQuery += "      F1_BASIMP4, " + cEol
cQuery += "      F1_BASIMP5, " + cEol
cQuery += "      F1_BASIMP6, " + cEol
cQuery += "      F1_VALIMP1, " + cEol
cQuery += "      F1_VALIMP2, " + cEol
cQuery += "      F1_VALIMP3, " + cEol
cQuery += "      F1_VALIMP4, " + cEol
cQuery += "      F1_VALIMP5, " + cEol
cQuery += "      F1_VALIMP6, " + cEol
cQuery += "      F1_ORDPAGO, " + cEol
cQuery += "      F1_HORA, " + cEol
cQuery += "      F1_INSS, " + cEol
cQuery += "      F1_ISS, " + cEol
cQuery += "      F1_BASIMP1, " + cEol
cQuery += "      F1_HAWB, " + cEol
cQuery += "      F1_TIPO_NF, " + cEol
cQuery += "      F1_IPI, " + cEol
cQuery += "      F1_ICMS, " + cEol
cQuery += "      F1_PESOL, " + cEol
cQuery += "      F1_FOB_R, " + cEol
cQuery += "      F1_SEGURO, " + cEol
cQuery += "      F1_CIF, " + cEol
cQuery += "      F1_MOEDA, " + cEol
cQuery += "      F1_PREFIXO, " + cEol
cQuery += "      F1_STATUS, " + cEol
cQuery += "      F1_VALEMB, " + cEol
cQuery += "      F1_RECBMTO, " + cEol
cQuery += "      F1_CTR_NFC, " + cEol
cQuery += "      F1_APROV, " + cEol
cQuery += "      F1_TXMOEDA, " + cEol
cQuery += "      F1_PEDVEND, " + cEol
cQuery += "      F1_TIPODOC, " + cEol
cQuery += "      F1_TIPOREM, " + cEol
cQuery += "      F1_GNR, " + cEol
cQuery += "      F1_PLACA, " + cEol
cQuery += "      F1_VALPIS, " + cEol
cQuery += "      F1_VALCOFI, " + cEol
cQuery += "      F1_VALCSLL, " + cEol
cQuery += "      F1_BASEPS3, " + cEol
cQuery += "      F1_VALPS3, " + cEol
cQuery += "      F1_BASECF3, " + cEol
cQuery += "      F1_VALCF3, " + cEol
cQuery += "      F1_NFELETR, " + cEol
cQuery += "      F1_EMINFE, " + cEol
cQuery += "      F1_HORNFE, " + cEol
cQuery += "      F1_CODNFE, " + cEol
cQuery += "      F1_CREDNFE, " + cEol
cQuery += "      F1_VNAGREG, " + cEol
cQuery += "      F1_NUMRPS, " + cEol
cQuery += "      F1_VALIRF, " + cEol
cQuery += "      F1_NUMMOV, " + cEol
cQuery += "      F1_CHVNFE, " + cEol
cQuery += "      F1_RECISS, " + cEol
cQuery += "      F1_FILORIG, " + cEol
cQuery += "      F1_NODIA, " + cEol
cQuery += "      F1_ESTCRED, " + cEol
cQuery += "      F1_DIACTB, " + cEol
cQuery += "      F1_NUMRA, " + cEol
cQuery += "      F1_BASEINS, " + cEol
cQuery += "      F1_VALFDS, " + cEol
cQuery += "      F1_TRANSP, " + cEol
cQuery += "      F1_PLIQUI, " + cEol
cQuery += "      F1_PBRUTO, " + cEol
cQuery += "      F1_ESPECI1, " + cEol
cQuery += "      F1_VOLUME1, " + cEol
cQuery += "      F1_ESPECI2, " + cEol
cQuery += "      F1_VOLUME2, " + cEol
cQuery += "      F1_ESPECI3, " + cEol
cQuery += "      F1_VOLUME3, " + cEol
cQuery += "      F1_ESPECI4, " + cEol
cQuery += "      F1_VOLUME4, " + cEol
cQuery += "      F1_MENNOTA, " + cEol
cQuery += "      F1_VALFET, " + cEol
cQuery += "      F1_VALFAC, " + cEol
cQuery += "      F1_VALFAB, " + cEol
cQuery += "      F1_FIMP, " + cEol
cQuery += "      F1_FORRET, " + cEol
cQuery += "      F1_LOJARET, " + cEol
cQuery += "      F1_RECOPI, " + cEol
cQuery += "      F1_VALPEDG, " + cEol
cQuery += "      F1_FORENT, " + cEol
cQuery += "      F1_LOJAENT, " + cEol
cQuery += "      F1_LOJAORI, " + cEol
cQuery += "      F1_CLIORI, " + cEol
cQuery += "      F1_BASEINA, " + cEol
cQuery += "      F1_VALINA, " + cEol
cQuery += "      F1_ANOAIDF, " + cEol
cQuery += "      F1_NUMAIDF, " + cEol
cQuery += "      F1_VLSENAR, " + cEol
cQuery += "      F1_MENPAD, " + cEol
cQuery += "      F1_BASCSLL, " + cEol
cQuery += "      F1_BASCOFI, " + cEol
cQuery += "      F1_BASPIS, " + cEol
cQuery += "      F1_STATCON, " + cEol
cQuery += "      F1_QTDCONF, " + cEol
cQuery += "      F1_DOCFOL, " + cEol
cQuery += "      F1_VERBAFO, " + cEol
cQuery += "      F1_TPFRETE, " + cEol
cQuery += "      F1_MSIDENT, " + cEol
cQuery += "      F1_BASEFUN, " + cEol
cQuery += "      F1_TPCTE, " + cEol
cQuery += "      F1_IDSED, " + cEol
cQuery += "      F1_IDSA2, " + cEol
cQuery += "      F1_IDSA1, " + cEol
cQuery += "      F1_CODRGS, " + cEol
cQuery += "      F1_DAUTNFE, " + cEol
cQuery += "      F1_EVENFLG, " + cEol
cQuery += "      F1_FLAGRGS, " + cEol
cQuery += "      F1_HAUTNFE, " + cEol
cQuery += "      F1_IDCCE, " + cEol
cQuery += "      F1_IDRGS, " + cEol
cQuery += "      F1_MODAL, " + cEol
cQuery += "      F1_TPNFEXP, " + cEol
cQuery += "      F1_INCISS, " + cEol
cQuery += "      F1_ESTPRES, " + cEol
cQuery += "      F1_IDRECOP, " + cEol
cQuery += "      F1_VLCIDE, " + cEol
cQuery += "      F1_BASECID, " + cEol
cQuery += "      F1_VLCPM, " + cEol
cQuery += "      F1_BASECPM, " + cEol
cQuery += "      F1_VALFMD, " + cEol
cQuery += "      F1_DTCPISS, " + cEol
cQuery += "      F1_VALFMP, " + cEol
cQuery += "      F1_BASEFMP, " + cEol
cQuery += "      B1_FILIAL, " + cEol
cQuery += "      B1_COD, " + cEol
cQuery += "      B1_DESC, " + cEol
cQuery += "      B1_TIPO, " + cEol
cQuery += "      B1_CODITE, " + cEol
cQuery += "      B1_UM, " + cEol
cQuery += "      B1_LOCPAD, " + cEol
cQuery += "      B1_GRUPO, " + cEol
cQuery += "      B1_PICM, " + cEol
cQuery += "      B1_IPI, " + cEol
cQuery += "      B1_POSIPI, " + cEol
cQuery += "      B1_ESPECIE, " + cEol
cQuery += "      B1_EX_NCM, " + cEol
cQuery += "      B1_EX_NBM, " + cEol
cQuery += "      B1_ALIQISS, " + cEol
cQuery += "      B1_CODISS, " + cEol
cQuery += "      B1_TE, " + cEol
cQuery += "      B1_TS, " + cEol
cQuery += "      B1_PICMRET, " + cEol
cQuery += "      B1_PICMENT, " + cEol
cQuery += "      B1_IMPZFRC, " + cEol
cQuery += "      B1_BITMAP, " + cEol
cQuery += "      B1_SEGUM, " + cEol
cQuery += "      B1_CONV, " + cEol
cQuery += "      B1_TIPCONV, " + cEol
cQuery += "      B1_ALTER, " + cEol
cQuery += "      B1_QE, " + cEol
cQuery += "      B1_PRV1, " + cEol
cQuery += "      B1_EMIN, " + cEol
cQuery += "      B1_CUSTD, " + cEol
cQuery += "      B1_UCALSTD, " + cEol
cQuery += "      B1_UPRC, " + cEol
cQuery += "      B1_MCUSTD, " + cEol
cQuery += "      B1_UCOM, " + cEol
cQuery += "      B1_PESO, " + cEol
cQuery += "      B1_ESTSEG, " + cEol
cQuery += "      B1_ESTFOR, " + cEol
cQuery += "      B1_FORPRZ, " + cEol
cQuery += "      B1_PE, " + cEol
cQuery += "      B1_TIPE, " + cEol
cQuery += "      B1_LE, " + cEol
cQuery += "      B1_LM, " + cEol
cQuery += "      B1_CONTA, " + cEol
cQuery += "      B1_TOLER, " + cEol
cQuery += "      B1_CC, " + cEol
cQuery += "      B1_ITEMCC, " + cEol
cQuery += "      B1_FAMILIA, " + cEol
cQuery += "      B1_PROC, " + cEol
cQuery += "      B1_QB, " + cEol
cQuery += "      B1_LOJPROC, " + cEol
cQuery += "      B1_APROPRI, " + cEol
cQuery += "      B1_TIPODEC, " + cEol
cQuery += "      B1_ORIGEM, " + cEol
cQuery += "      B1_CLASFIS, " + cEol
cQuery += "      B1_FANTASM, " + cEol
cQuery += "      B1_RASTRO, " + cEol
cQuery += "      B1_UREV, " + cEol
cQuery += "      B1_DATREF, " + cEol
cQuery += "      B1_FORAEST, " + cEol
cQuery += "      B1_COMIS, " + cEol
cQuery += "      B1_MONO, " + cEol
cQuery += "      B1_PERINV, " + cEol
cQuery += "      B1_DTREFP1, " + cEol
cQuery += "      B1_GRTRIB, " + cEol
cQuery += "      B1_MRP, " + cEol
cQuery += "      B1_NOTAMIN, " + cEol
cQuery += "      B1_PRVALID, " + cEol
cQuery += "      B1_NUMCOP, " + cEol
cQuery += "      B1_CONINI, " + cEol
cQuery += "      B1_CONTSOC, " + cEol
cQuery += "      B1_IRRF, " + cEol
cQuery += "      B1_CODBAR, " + cEol
cQuery += "      B1_GRADE, " + cEol
cQuery += "      B1_FORMLOT, " + cEol
cQuery += "      B1_FPCOD, " + cEol
cQuery += "      B1_LOCALIZ, " + cEol
cQuery += "      B1_OPERPAD, " + cEol
cQuery += "      B1_CONTRAT, " + cEol
cQuery += "      B1_DESC_P, " + cEol
cQuery += "      B1_DESC_GI, " + cEol
cQuery += "      B1_DESC_I, " + cEol
cQuery += "      B1_VLREFUS, " + cEol
cQuery += "      B1_IMPORT, " + cEol
cQuery += "      B1_OPC, " + cEol
cQuery += "      B1_ANUENTE, " + cEol
cQuery += "      B1_CODOBS, " + cEol
cQuery += "      B1_SITPROD, " + cEol
cQuery += "      B1_FABRIC, " + cEol
cQuery += "      B1_MODELO, " + cEol
cQuery += "      B1_SETOR, " + cEol
cQuery += "      B1_BALANCA, " + cEol
cQuery += "      B1_TECLA, " + cEol
cQuery += "      B1_PRODPAI, " + cEol
cQuery += "      B1_TIPOCQ, " + cEol
cQuery += "      B1_SOLICIT, " + cEol
cQuery += "      B1_AGREGCU, " + cEol
cQuery += "      B1_GRUPCOM, " + cEol
cQuery += "      B1_QUADPRO, " + cEol
cQuery += "      B1_DESPIMP, " + cEol
cQuery += "      B1_BASE3, " + cEol
cQuery += "      B1_DESBSE3, " + cEol
cQuery += "      B1_NUMCQPR, " + cEol
cQuery += "      B1_CONTCQP, " + cEol
cQuery += "      B1_REVATU, " + cEol
cQuery += "      B1_INSS, " + cEol
cQuery += "      B1_CODEMB, " + cEol
cQuery += "      B1_ESPECIF, " + cEol
cQuery += "      B1_MAT_PRI, " + cEol
cQuery += "      B1_NALNCCA, " + cEol
cQuery += "      B1_REDINSS, " + cEol
cQuery += "      B1_ALADI, " + cEol
cQuery += "      B1_NALSH, " + cEol
cQuery += "      B1_REDIRRF, " + cEol
cQuery += "      B1_TAB_IPI, " + cEol
cQuery += "      B1_GRUDES, " + cEol
cQuery += "      B1_REDPIS, " + cEol
cQuery += "      B1_REDCOF, " + cEol
cQuery += "      B1_DATASUB, " + cEol
cQuery += "      B1_PCSLL, " + cEol
cQuery += "      B1_PCOFINS, " + cEol
cQuery += "      B1_PPIS, " + cEol
cQuery += "      B1_MTBF, " + cEol
cQuery += "      B1_MTTR, " + cEol
cQuery += "      B1_FLAGSUG, " + cEol
cQuery += "      B1_CLASSVE, " + cEol
cQuery += "      B1_MIDIA, " + cEol
cQuery += "      B1_QTMIDIA, " + cEol
cQuery += "      B1_VLR_IPI, " + cEol
cQuery += "      B1_ENVOBR, " + cEol
cQuery += "      B1_QTDSER, " + cEol
cQuery += "      B1_SERIE, " + cEol
cQuery += "      B1_FAIXAS, " + cEol
cQuery += "      B1_NROPAG, " + cEol
cQuery += "      B1_ISBN, " + cEol
cQuery += "      B1_TITORIG, " + cEol
cQuery += "      B1_LINGUA, " + cEol
cQuery += "      B1_EDICAO, " + cEol
cQuery += "      B1_OBSISBN, " + cEol
cQuery += "      B1_CLVL, " + cEol
cQuery += "      B1_ATIVO, " + cEol
cQuery += "      B1_EMAX, " + cEol
cQuery += "      B1_PESBRU, " + cEol
cQuery += "      B1_TIPCAR, " + cEol
cQuery += "      B1_FRACPER, " + cEol
cQuery += "      B1_INT_ICM, " + cEol
cQuery += "      B1_VLR_ICM, " + cEol
cQuery += "      B1_VLRSELO, " + cEol
cQuery += "      B1_CODNOR, " + cEol
cQuery += "      B1_CORPRI, " + cEol
cQuery += "      B1_CORSEC, " + cEol
cQuery += "      B1_NICONE, " + cEol
cQuery += "      B1_ATRIB1, " + cEol
cQuery += "      B1_ATRIB2, " + cEol
cQuery += "      B1_ATRIB3, " + cEol
cQuery += "      B1_REGSEQ, " + cEol
cQuery += "      B1_CPOTENC, " + cEol
cQuery += "      B1_POTENCI, " + cEol
cQuery += "      B1_QTDACUM, " + cEol
cQuery += "      B1_QTDINIC, " + cEol
cQuery += "      B1_REQUIS, " + cEol
cQuery += "      B1_SELO, " + cEol
cQuery += "      B1_LOTVEN, " + cEol
cQuery += "      B1_OK, " + cEol
cQuery += "      B1_USAFEFO, " + cEol
cQuery += "      B1_IAT, " + cEol
cQuery += "      B1_IPPT, " + cEol
cQuery += "      B1_CNATREC, " + cEol
cQuery += "      B1_TNATREC, " + cEol
cQuery += "      B1_REFBAS, " + cEol
cQuery += "      B1_COEFDCR, " + cEol
cQuery += "      B1_UMOEC, " + cEol
cQuery += "      B1_UVLRC, " + cEol
cQuery += "      B1_GCCUSTO, " + cEol
cQuery += "      B1_CCCUSTO, " + cEol
cQuery += "      B1_VLR_PIS, " + cEol
cQuery += "      B1_PIS, " + cEol
cQuery += "      B1_PARCEI, " + cEol
cQuery += "      B1_CLASSE, " + cEol
cQuery += "      B1_FUSTF, " + cEol
cQuery += "      B1_ESCRIPI, " + cEol
cQuery += "      B1_MSBLQL, " + cEol
cQuery += "      B1_CODQAD, " + cEol
cQuery += "      B1_PMACNUT, " + cEol
cQuery += "      B1_PMICNUT, " + cEol
cQuery += "      B1_VALEPRE, " + cEol
cQuery += "      B1_TIPOBN, " + cEol
cQuery += "      B1_CODPROC, " + cEol
cQuery += "      B1_CRICMS, " + cEol
cQuery += "      B1_QBP, " + cEol
cQuery += "      B1_PRODSBP, " + cEol
cQuery += "      B1_VLCIF, " + cEol
cQuery += "      B1_LOTESBP, " + cEol
cQuery += "      B1_TALLA, " + cEol
cQuery += "      B1_GDODIF, " + cEol
cQuery += "      B1_MARKUP, " + cEol
cQuery += "      B1_DTCORTE, " + cEol
cQuery += "      B1_DCR, " + cEol
cQuery += "      B1_DCRII, " + cEol
cQuery += "      B1_DIFCNAE, " + cEol
cQuery += "      B1_TPPROD, " + cEol
cQuery += "      B1_GRPNATR, " + cEol
cQuery += "      B1_DTFIMNT, " + cEol
cQuery += "      B1_DCI, " + cEol
cQuery += "      B1_DCRE, " + cEol
cQuery += "      B1_FECP, " + cEol
cQuery += "      B1_TPREG, " + cEol
cQuery += "      B1_VEREAN, " + cEol
cQuery += "      B1_VIGENC, " + cEol
cQuery += "      B1_AFABOV, " + cEol
cQuery += "      B1_CHASSI, " + cEol
cQuery += "      B1_PRN944I, " + cEol
cQuery += "      B1_CODLAN, " + cEol
cQuery += "      B1_CARGAE, " + cEol
cQuery += "      B1_PRINCMG, " + cEol
cQuery += "      B1_CSLL, " + cEol
cQuery += "      B1_COFINS, " + cEol
cQuery += "      B1_FRETISS, " + cEol
cQuery += "      B1_PRFDSUL, " + cEol
cQuery += "      B1_VLR_COF, " + cEol
cQuery += "      B1_CNAE, " + cEol
cQuery += "      B1_RETOPER, " + cEol
cQuery += "      B1_IVAAJU, " + cEol
cQuery += "      B1_REGRISS, " + cEol
cQuery += "      B1_CODANT, " + cEol
cQuery += "      B1_CRDEST, " + cEol
cQuery += "      B1_SELOEN, " + cEol
cQuery += "      B1_RICM65, " + cEol
cQuery += "      B1_PRODREC, " + cEol
cQuery += "      B1_DESBSE2, " + cEol
cQuery += "      B1_COLOR, " + cEol
cQuery += "      B1_TIPVEC, " + cEol
cQuery += "      B1_FETHAB, " + cEol
cQuery += "      B1_ESTRORI, " + cEol
cQuery += "      B1_CALCFET, " + cEol
cQuery += "      B1_PAUTFET, " + cEol
cQuery += "      B1_BASE, " + cEol
cQuery += "      B1_ALFUMAC, " + cEol
cQuery += "      B1_BASE2, " + cEol
cQuery += "      B1_GARANT, " + cEol
cQuery += "      B1_PERGART, " + cEol
cQuery += "      B1_ADMIN, " + cEol
cQuery += "      B1_TRIBMUN, " + cEol
cQuery += "      B1_PR43080, " + cEol
cQuery += "      B1_RPRODEP, " + cEol
cQuery += "      B1_IDHIST, " + cEol
cQuery += "      B1_MSEXP, " + cEol
cQuery += "      B1_PAFMD5, " + cEol
cQuery += "      B1_SITTRIB, " + cEol
cQuery += "      B1_AFACS, " + cEol
cQuery += "      B1_AFETHAB, " + cEol
cQuery += "      B1_AJUDIF, " + cEol
cQuery += "      B1_ALFECOP, " + cEol
cQuery += "      B1_ALFECRN, " + cEol
cQuery += "      B1_ALFECST, " + cEol
cQuery += "      B1_CFEM, " + cEol
cQuery += "      B1_CFEMA, " + cEol
cQuery += "      B1_CFEMS, " + cEol
cQuery += "      B1_CRDPRES, " + cEol
cQuery += "      B1_CRICMST, " + cEol
cQuery += "      B1_RSATIVO, " + cEol
cQuery += "      B1_TFETHAB, " + cEol
cQuery += "      B1_TPDP, " + cEol
cQuery += "      B1_PRDORI, " + cEol
cQuery += "      B1_FECOP, " + cEol
cQuery += "      B1_FECPBA, " + cEol
cQuery += "      B1_MEPLES, " + cEol
cQuery += "      B1_REGESIM, " + cEol
cQuery += "      B1_IMPNCM, " + cEol
cQuery += "      B1_CRNFLG, " + cEol
cQuery += "      B1_VQ_COD, " + cEol
cQuery += "      B1_VQ_COD2, " + cEol
cQuery += "      B1_VQ_FRET, " + cEol
cQuery += "      B1_VQ_RCOM, " + cEol
cQuery += "      B1_VQ_DATA, " + cEol
cQuery += "      B1_VQ_ECAP, " + cEol
cQuery += "      B1_VQ_MOED, " + cEol
cQuery += "      B1_VQ_UM, " + cEol
cQuery += "      B1_VQ_TAX2, " + cEol
cQuery += "      B1_CODSIMP, " + cEol
cQuery += "      B1_VQ_MP, " + cEol
cQuery += "      B1_VQ_EM, " + cEol
cQuery += "      B1_VQ_FRT2, " + cEol
cQuery += "      B1_VQ_ICMS, " + cEol
cQuery += "      B1_VQ_IPI, " + cEol
cQuery += "      B1_VQ_UMEM, " + cEol
cQuery += "      B1_VQ_VERS, " + cEol
cQuery += "      B1_VQ_COMP, " + cEol
cQuery += "      B1_PORCPRL, " + cEol
cQuery += "      B1_AFAMAD, " + cEol
cQuery += "      B1_VQ_EMCS, " + cEol
cQuery += "      B1_VQ_MPDE, " + cEol
cQuery += "      B1_VQ_EMDE, " + cEol
cQuery += "      B1_GRPTI, " + cEol
cQuery += "      B1_GRPCST, " + cEol
cQuery += "      B1_CEST, " + cEol
cQuery += "      F4_FILIAL, " + cEol
cQuery += "      F4_CODIGO, " + cEol
cQuery += "      F4_TIPO, " + cEol
cQuery += "      F4_ICM, " + cEol
cQuery += "      F4_IPI, " + cEol
cQuery += "      F4_CREDICM, " + cEol
cQuery += "      F4_CREDIPI, " + cEol
cQuery += "      F4_DUPLIC, " + cEol
cQuery += "      F4_ESTOQUE, " + cEol
cQuery += "      F4_CF, " + cEol
cQuery += "      F4_TEXTO, " + cEol
cQuery += "      F4_CFEXT, " + cEol
cQuery += "      F4_BASEICM, " + cEol
cQuery += "      F4_BASEIPI, " + cEol
cQuery += "      F4_PODER3, " + cEol
cQuery += "      F4_LFICM, " + cEol
cQuery += "      F4_LFIPI, " + cEol
cQuery += "      F4_DESTACA, " + cEol
cQuery += "      F4_INCIDE, " + cEol
cQuery += "      F4_COMPL, " + cEol
cQuery += "      F4_IPIFRET, " + cEol
cQuery += "      F4_ISS, " + cEol
cQuery += "      F4_LFISS, " + cEol
cQuery += "      F4_NRLIVRO, " + cEol
cQuery += "      F4_UPRC, " + cEol
cQuery += "      F4_CONSUMO, " + cEol
cQuery += "      F4_FORMULA, " + cEol
cQuery += "      F4_AGREG, " + cEol
cQuery += "      F4_INCSOL, " + cEol
cQuery += "      F4_CIAP, " + cEol
cQuery += "      F4_DESPIPI, " + cEol
cQuery += "      F4_LIVRO, " + cEol
cQuery += "      F4_ATUTEC, " + cEol
cQuery += "      F4_ATUATF, " + cEol
cQuery += "      F4_TPIPI, " + cEol
cQuery += "      F4_STDESC, " + cEol
cQuery += "      F4_BSICMST, " + cEol
cQuery += "      F4_CREDST, " + cEol
cQuery += "      F4_BASEISS, " + cEol
cQuery += "      F4_DESPICM, " + cEol
cQuery += "      F4_SITTRIB, " + cEol
cQuery += "      F4_PISCOF, " + cEol
cQuery += "      F4_PISCRED, " + cEol
cQuery += "      F4_TESDV, " + cEol
cQuery += "      F4_BASEPIS, " + cEol
cQuery += "      F4_BASECOF, " + cEol
cQuery += "      F4_IPILICM, " + cEol
cQuery += "      F4_MOVPRJ, " + cEol
cQuery += "      F4_ICMSDIF, " + cEol
cQuery += "      F4_TESP3, " + cEol
cQuery += "      F4_QTDZERO, " + cEol
cQuery += "      F4_SLDNPT, " + cEol
cQuery += "      F4_DEVZERO, " + cEol
cQuery += "      F4_MSBLQL, " + cEol
cQuery += "      F4_TIPOPER, " + cEol
cQuery += "      F4_TRFICM, " + cEol
cQuery += "      F4_TESENV, " + cEol
cQuery += "      F4_OBSICM, " + cEol
cQuery += "      F4_OBSSOL, " + cEol
cQuery += "      F4_PICMDIF, " + cEol
cQuery += "      F4_SELO, " + cEol
cQuery += "      F4_ISSST, " + cEol
cQuery += "      F4_FINALID, " + cEol
cQuery += "      F4_PISFISC, " + cEol
cQuery += "      F4_CONTSOC, " + cEol
cQuery += "      F4_COP, " + cEol
cQuery += "      F4_INDNTFR, " + cEol
cQuery += "      F4_CODBCC, " + cEol
cQuery += "      F4_CPPRODE, " + cEol
cQuery += "      F4_AJUSTE, " + cEol
cQuery += "      F4_TPPRODE, " + cEol
cQuery += "      F4_CPRECTR, " + cEol
cQuery += "      F4_IPIANT, " + cEol
cQuery += "      F4_TPCPRES, " + cEol
cQuery += "      F4_DESPCOF, " + cEol
cQuery += "      F4_CRDPRES, " + cEol
cQuery += "      F4_REGDSTA, " + cEol
cQuery += "      F4_OPEMOV, " + cEol
cQuery += "      F4_TRANFIL, " + cEol
cQuery += "      F4_PISBRUT, " + cEol
cQuery += "      F4_DSPRDIC, " + cEol
cQuery += "      F4_TPREG, " + cEol
cQuery += "      F4_AFRMM, " + cEol
cQuery += "      F4_COFBRUT, " + cEol
cQuery += "      F4_COFDSZF, " + cEol
cQuery += "      F4_LFICMST, " + cEol
cQuery += "      F4_BCRDPIS, " + cEol
cQuery += "      F4_BCRDCOF, " + cEol
cQuery += "      F4_ICMSST, " + cEol
cQuery += "      F4_FRETAUT, " + cEol
cQuery += "      F4_MKPCMP, " + cEol
cQuery += "      F4_CRPRST, " + cEol
cQuery += "      F4_CRPRELE, " + cEol
cQuery += "      F4_AGRRETC, " + cEol
cQuery += "      F4_BENSATF, " + cEol
cQuery += "      F4_RETISS, " + cEol
cQuery += "      F4_CTIPI, " + cEol
cQuery += "      F4_CRDEST, " + cEol
cQuery += "      F4_AGRCOF, " + cEol
cQuery += "      F4_AGRPIS, " + cEol
cQuery += "      F4_DESPPIS, " + cEol
cQuery += "      F4_PISDSZF, " + cEol
cQuery += "      F4_IPIPC, " + cEol
cQuery += "      F4_TESE3, " + cEol
cQuery += "      F4_ISEFEMT, " + cEol
cQuery += "      F4_IDHIST, " + cEol
cQuery += "      F4_TABGIAC, " + cEol
cQuery += "      F4_APSCFST, " + cEol
cQuery += "      F4_TNATREC, " + cEol
cQuery += "      F4_CNATREC, " + cEol
cQuery += "      F4_GRPNATR, " + cEol
cQuery += "      F4_DTFIMNT, " + cEol
cQuery += "      F4_BSRURAL, " + cEol
cQuery += "      F4_CREDPRE, " + cEol
cQuery += "      F4_CRICMST, " + cEol
cQuery += "      F4_CODOBSE, " + cEol
cQuery += "      F4_NATOPER, " + cEol
cQuery += "      F4_CSBHISS, " + cEol
cQuery += "      F4_CTBHISS, " + cEol
cQuery += "      F4_CONSIND, " + cEol
cQuery += "      F4_NORESP, " + cEol
cQuery += "      F4_MALQCOF, " + cEol
cQuery += "      F4_BSRDICM, " + cEol
cQuery += "      F4_RECDAC, " + cEol
cQuery += "      F4_CIAPTRB, " + cEol
cQuery += "      F4_TIPODUB, " + cEol
cQuery += "      F4_OPERGAR, " + cEol
cQuery += "      F4_DESTRUI, " + cEol
cQuery += "      F4_DICMFUN, " + cEol
cQuery += "      F4_IMPIND, " + cEol
cQuery += "      F4_APLIRED, " + cEol
cQuery += "      F4_APLREDP, " + cEol
cQuery += "      F4_CRDACUM, " + cEol
cQuery += "      F4_IVAUTIL, " + cEol
cQuery += "      F4_PERCMED, " + cEol
cQuery += "      F4_CSOSN, " + cEol
cQuery += "      F4_PERCATM, " + cEol
cQuery += "      F4_MALQPIS, " + cEol
cQuery += "      F4_FTATUSC, " + cEol
cQuery += "      F4_DEVPARC, " + cEol
cQuery += "      F4_ICMSTMT, " + cEol
cQuery += "      F4_IPIOBS, " + cEol
cQuery += "      F4_CRDTRAN, " + cEol
cQuery += "      F4_PSCFST, " + cEol
cQuery += "      F4_CFPS, " + cEol
cQuery += "      F4_ISEFECP, " + cEol
cQuery += "      F4_OPERSUC, " + cEol
cQuery += "      F4_ESTCRED, " + cEol
cQuery += "      F4_CREDACU, " + cEol
cQuery += "      F4_DESCOND, " + cEol
cQuery += "      F4_CRPRSIM, " + cEol
cQuery += "      F4_REDANT, " + cEol
cQuery += "      F4_NUMDUB, " + cEol
cQuery += "      F4_CODDET, " + cEol
cQuery += "      F4_ANTICMS, " + cEol
cQuery += "      F4_BENDUB, " + cEol
cQuery += "      F4_CROUTSP, " + cEol
cQuery += "      F4_CFACS, " + cEol
cQuery += "      F4_CFABOV, " + cEol
cQuery += "      F4_CPRESPR, " + cEol
cQuery += "      F4_VARATAC, " + cEol
cQuery += "      F4_ATACVAR, " + cEol
cQuery += "      F4_MOVFIS, " + cEol
cQuery += "      F4_AGRDRED, " + cEol
cQuery += "      F4_APLIIVA, " + cEol
cQuery += "      F4_TEMDOCS, " + cEol
cQuery += "      F4_VENPRES, " + cEol
cQuery += "      F4_VDASOFT, " + cEol
cQuery += "      F4_COMPONE, " + cEol
cQuery += "      F4_REGESP, " + cEol
cQuery += "      F4_MSGLT, " + cEol
cQuery += "      F4_MTRTBH, " + cEol
cQuery += "      F4_ISEFERN, " + cEol
cQuery += "      F4_TABGIAI, " + cEol
cQuery += "      F4_TABGIAO, " + cEol
cQuery += "      F4_SOMAIPI, " + cEol
cQuery += "      F4_ISEFEMG, " + cEol
cQuery += "      F4_TPRSPL, " + cEol
cQuery += "      F4_TRFICST, " + cEol
cQuery += "      F4_CODLAN, " + cEol
cQuery += "      F4_RESSARC, " + cEol
cQuery += "      F4_VLRZERO, " + cEol
cQuery += "      F4_ALSENAR, " + cEol
cQuery += "      F4_CALCFET, " + cEol
cQuery += "      F4_ESCRDPR, " + cEol
cQuery += "      F4_MOTICMS, " + cEol
cQuery += "      F4_INDDET, " + cEol
cQuery += "      F4_MKPSOL, " + cEol
cQuery += "      F4_CLFDSUL, " + cEol
cQuery += "      F4_BCPCST, " + cEol
cQuery += "      F4_PCREDAC, " + cEol
cQuery += "      F4_TRANSIT, " + cEol
cQuery += "      F4_COMPRED, " + cEol
cQuery += "      F4_CSTPIS, " + cEol
cQuery += "      F4_CSTCOF, " + cEol
cQuery += "      F4_RGESPST, " + cEol
cQuery += "      F4_PRZESP, " + cEol
cQuery += "      F4_CRPRESP, " + cEol
cQuery += "      F4_CSTISS, " + cEol
cQuery += "      F4_TIPOTES, " + cEol
cQuery += "      F4_AGREGCP, " + cEol
cQuery += "      F4_FRETISS, " + cEol
cQuery += "      F4_ART274, " + cEol
cQuery += "      F4_PR35701, " + cEol
cQuery += "      F4_INTBSIC, " + cEol
cQuery += "      F4_CRICMS, " + cEol
cQuery += "      F4_CRPREPR, " + cEol
cQuery += "      F4_CODLEG, " + cEol
cQuery += "      F4_BONIF, " + cEol
cQuery += "      F4_CRLEIT, " + cEol
cQuery += "      F4_CODPAG, " + cEol
cQuery += "      F4_PAGCOM, " + cEol
cQuery += "      F4_REDBCCE, " + cEol
cQuery += "      F4_RGESPCI, " + cEol
cQuery += "      F4_VLAGREG, " + cEol
cQuery += "      F4_PAUTICM, " + cEol
cQuery += "      F4_STCONF, " + cEol
cQuery += "      F4_CROUTGO, " + cEol
cQuery += "      F4_REFATAN, " + cEol
cQuery += "      F4_DBSTCSL, " + cEol
cQuery += "      F4_DBSTIRR, " + cEol
cQuery += "      F4_CRPREPE, " + cEol
cQuery += "      F4_DUPLIST, " + cEol
cQuery += "      F4_CRPRERO, " + cEol
cQuery += "      F4_STLIQ, " + cEol
cQuery += "      F4_VQ_CTB, " + cEol
cQuery += "      F4_RFETALG, " + cEol
cQuery += "      F4_BSICMRE, " + cEol
cQuery += "      F4_PARTICM, " + cEol
cQuery += "      F4_XCONTAB, " + cEol
cQuery += "      F4_XCTAD, " + cEol
cQuery += "      F4_XCTAC, " + cEol
cQuery += "      F4_XCTAB, " + cEol
cQuery += "      F4_XICM, " + cEol
cQuery += "      F4_XIPI, " + cEol
cQuery += "      F4_XPIS, " + cEol
cQuery += "      F4_XCOF, " + cEol
cQuery += "      F4_XISS, " + cEol
cQuery += "      F4_XCUSTO, " + cEol
cQuery += "      F4_XICMSST, " + cEol
cQuery += "      F4_XTESBON, " + cEol
cQuery += "      F4_CV139, " + cEol
cQuery += "      F4_ALICRST, " + cEol
cQuery += "      F4_TRAFILI, " + cEol
cQuery += "      F4_IPIVFCF, " + cEol
cQuery += "      F4_RDBSICM, " + cEol
cQuery += "      F4_INOVAUT, " + cEol
cQuery += "      F4_CFAMAD, " + cEol
cQuery += "      F4_DESCISS, " + cEol
cQuery += "      F4_IPMSP, " + cEol
cQuery += "      F4_IPMMG, " + cEol
cQuery += "      F4_VQENTAN, " + cEol
cQuery += "      F4_OUTPERC, " + cEol
cQuery += "      F4_PISMIN, " + cEol
cQuery += "      F4_COFMIN, " + cEol
cQuery += "      F4_IPIMIN, " + cEol
cQuery += "      F4_ENQLEG, " + cEol
cQuery += "      F4_TREGDMA, " + cEol
cQuery += "      F4_CUSENTR, " + cEol
cQuery += "      F4_IPIPECR, " + cEol
cQuery += "      F4_TXAPIPI, " + cEol
cQuery += "      F4_GRPCST, " + cEol
cQuery += "      F4_CALCCPB, " + cEol
cQuery += "      F4_DIFAL " + cEol
cQuery += "    FROM " + RetSqlName("SD1") + " SD1 " + cEol
cQuery += "       INNER JOIN " + RetSqlName("SF1") + " SF1 ON " + cEol
cQuery += "          SF1.D_E_L_E_T_ <> '*' " + cEol
cQuery += "          AND F1_FILIAL  = '"+cFilAnt+"' " + cEol
cQuery += "          AND F1_DOC     = D1_DOC     " + cEol
cQuery += "          AND F1_SERIE   = D1_SERIE   " + cEol
cQuery += "          AND F1_FORNECE = D1_FORNECE " + cEol
cQuery += "          AND F1_LOJA    = D1_LOJA    " + cEol
cQuery += "          AND F1_TIPO    = 'N' " + cEol
cQuery += "       INNER JOIN " + RetSqlName("SB1") + " SB1 ON " + cEol
cQuery += "          SB1.D_E_L_E_T_ <> '*' " + cEol
//cQuery += "          AND B1_FILIAL  = '"+cFilAnt+"' " + cEol //REMOVIDO PARA FILTRAR A ULTIMA VENDA POR FILIAL DANILO BUSSO 18/08/2016
cQuery += "          AND B1_COD     = D1_COD " + cEol
cQuery += "       INNER JOIN " + RetSqlName("SF4") + " SF4 ON " + cEol
cQuery += "          SF4.D_E_L_E_T_ <> '*' " + cEol
cQuery += "          AND F4_FILIAL  = '"+cFilAnt+"' " + cEol
cQuery += "          AND F4_CODIGO  = D1_TES " + cEol
cQuery += "          AND (F4_CODIGO = '031' OR F4_ESTOQUE = 'S') " + cEol
cQuery += "    WHERE " + cEol
cQuery += "       SD1.D_E_L_E_T_ <> '*' " + cEol
cQuery += "       AND D1_FILIAL = '"+cFilAnt+"' " + cEol
cQuery += "       AND D1_COD IN (" + cEol
cQuery += "          SELECT B1_COD FROM " + RetSqlName("SB1") + " SB1 " + cEol
cQuery += "          WHERE " + cEol
cQuery += "             SB1.D_E_L_E_T_ <> '*' " + cEol
cQuery += "             AND (B1_COD = '"+cCodMp+"' OR B1_VQ_MP = '"+cCodMp+"') " + cEol
cQuery += "       ) " + cEol                                                           
cQuery += "			AND D1_PEDIDO <> '      '" + cEol
cQuery += " ) TRB " + cEol
cQuery += "    ORDER BY F1_DTDIGIT DESC, F1_DOC DESC, F1_SERIE DESC" + cEol

cQuery := ChangeQuery(cQuery)
MemoWrite("C:\temp\query3.txt",cQuery)

If Select("TMPSD1") > 0
	TMPSD1->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPSD1"

If !TMPSD1->(Eof())

	If Empty(TMPSD1->B1_VQ_EM)
		cD1Embal := "GRANEL"
	Else
		cD1Embal := Posicione("SB1",1,xFilial("SB1")+TMPSD1->B1_VQ_EM,"B1_DESC")
	EndIf
	cSc7TpFrete := ""
	If TMPSD1->F1_TPFRETE == "C"
		cSc7TpFrete := "CIF"
	ElseIf TMPSD1->F1_TPFRETE == "F"
		cSc7TpFrete := "FOB"
	ElseIf TMPSD1->F1_TPFRETE == "T"
		cSc7TpFrete := "TERCEIROS"
	ElseIf TMPSD1->F1_TPFRETE == "S"
		cSc7TpFrete := "SEM FRETE"
	Else
		cSc7TpFrete := "NAO INFORMADO"
	EndIf

	If SC7->(DbSeek(xFilial("SC7")+TMPSD1->(D1_PEDIDO+D1_ITEMPC)))  
		cC7Pedid := SC7->C7_NUM
		If SA2->(DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))
			cC7Forne  := SA2->A2_NOME
		EndIf
		_nValItem := SC7->C7_PRECO  
						      
		//Danilo Busso
		If SC7->C7_VQ_TFRE == "T"
			cC7TFret := "F. TONELADA"
			nC7VFret := (SC7->C7_QUANT / 1000) * SC7->C7_VQ_VFRE
		ElseIf SC7->C7_VQ_TFRE == "F"    
		    cC7TFret := "F. FECHADO"  
		    nC7VFret := SC7->C7_VQ_VFRE
		Else 
			cC7TFret := "NAO INFORMADO"
		EndIf                    
		
		If SC7->C7_MOEDA == 1
			nD1Taxa := 0
//		ElseIf SC7->C7_TXMOEDA > 0
//			nD1Taxa := SC7->C7_TXMOEDA
//		ElseIf SM2->(DbSeek(dTos(SC7->C7_EMISSAO)))
		ElseIf SM2->(DbSeek(TMPSD1->D1_EMISSAO))
			nD1Taxa := SM2->M2_MOEDA2
		Else
			nD1Taxa := 0
		EndIf
	Else
		_nValItem := TMPSD1->D1_VUNIT
		nD1Taxa   := 0
	EndIf

	If cUm == "L"
		nD1Quant   := TMPSD1->D1_QUANT / TMPSD1->B1_CONV
		nD1Valor   := _nValItem * TMPSD1->B1_CONV
		cD1Um      := "L "
	Else
		nD1Quant   := TMPSD1->D1_QUANT
		nD1Valor   := _nValItem
		cD1Um      := "KG"
	EndIf
	
	dD1DtDigit := sTod(TMPSD1->F1_DTDIGIT)
	nD1Icms    := TMPSD1->D1_PICM
	cD1Frete   := cSc7TpFrete
	If SC7->(DbSeek(xFilial("SC7")+TMPSD1->(D1_PEDIDO+D1_ITEMPC)))
		cD1Moeda   := If(AllTrim(Str(SC7->C7_MOEDA))=="1","REAL","DOLAR")
	EndIf
EndIf

If Select("TMPSD1") > 0
	TMPSD1->(DbCloseArea())
EndIf
                     
oC7TFret:Refresh() //Danilo Busso 
oC7Forne:Refresh() //Danilo Busso      
oC7VFret:Refresh() //Danilo Busso      
oC7Pedid:Refresh() //Danilo Busso
oD1Emissao:Refresh()
oD1Quant:Refresh()
oD1Valor:Refresh()
oD1Icms:Refresh()
oD1Frete:Refresh()
oD1Um:Refresh()
oD1Moeda:Refresh()
oD1Embal:Refresh()

SC7->(RestArea(aAreaSc7))    

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: fCfmComFat | Autor: Celso Ferrone Martins | Data: 07/01/2015 |||
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
Static Function fCfmComFat()

If lCodMp
	fCfmCalcu()
EndIf

If !Empty(cCodMp)
	U_CfmComFat(cCodMp)
Else
	MsgAlert("Selecione uma meteria prima!","Atencao!")
EndIf

//fCfmConPad("","",.T.)

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: fCfmParam  | Autor: Celso Ferrone Martins | Data: 03/03/2015 |||
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
Static Function fCfmParam()

dDataRef := GetMV("VQ_DTCOTAC", .F.)
nTaxaM2  := GetMV("VQ_TXMOED2", .F.)
nFretTon := GetMV("VQ_FRETONE", .F.)
nFretMet := GetMV("VQ_FRETMET", .F.)
nBaseCal := GetMV("VQ_BASELIT", .F.)

_nFretTon := GetMV("VQ_FRETONE", .F.)
_nFretMet := GetMV("VQ_FRETMET", .F.)
_nBaseCal := GetMV("VQ_BASELIT", .F.)

oMoeda:Refresh()
oCod:Refresh()

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: fCfmHisPrc | Autor: Celso Ferrone Martins | Data: 06/07/2015 |||
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
Static Function fCfmHisPrc()

If lCodMp
	fCfmCalcu()
EndIf

If !Empty(cCodPai)
	U_CfmHisPrc(cCodPai)
Else
	MsgAlert("Selecione uma Embalagem!","Atencao!")
EndIf

Return()
