#Include "TopConn.ch"
#Include "Protheus.ch"        
#INCLUDE "RWMAKE.CH"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVQCONVEN  บAutor  ณ Felipe - Armi      บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VQCONMES()

Local aSize, aObjects, aInfo

Local bOk      := {|| oDlg:End()}
Local bCancel  := {|| oDlg:End()}
Local cTitle   := "Consulta de Vendas Mensal"
Local oGetdb
Local nBoxSize := 0
Local aButtons := {{"IMPRESSAO",{|| Imprime() },               "Imprimir"} }   

Public cCfmFilNew := "" 

Private _cFilRegV	 := ""    //Regioes do vendedor para usar no filtro do SELECT
Private _cFilGrpV    := ""    //Divisoes do vendedor para usar no filtro do SELECT 
Private _cUsuario	 := Upper(Alltrim(__cUserID))   // C๓digo do usuแrio
Private _cCodVend    := _getVended(_cUsuario)       // C๓digo do Vendedor  
Private _aFilRegV	 := U__getRegV(_cCodVend)		// Filtra as regioes de vendas do vendedor
Private _aFilGrpV	 := U__getGrpV(_cCodVend)		// Filtra as grupo de vendas do vendedor  
Private _cGrpReg 	 := ""
Private _aGrpRegV	 := getGrpRegV(_cCodVend)                                      

Private _cUsrLibA	 := _cUsuario $ GetMv("VQ_CONMES") // Usuarios que podem Visualizar todos os clientes, por consequencia liberei tudo na tela.
//Local _aFilVenR	 := essa vai ser responsavel por retornar os vendedores da mesma regiao 

Private cEof := Chr(13) + Chr(10)

Private oDlg
Private aPosObj

Private oGetDados
Private aHeader := {}
Private aCols   := {}

Private _cFiltela := ""

// Filtro
Private oGDatDe
Private dGDatDe := FirstDay(dDataBase)

If substr(DTOS(dGDatDe),5,2) = "12"
	_cAnoIni := substr(DTOS(dGDatDe),1,4)
	_cMesIni := "01"
Else
	_cAnoIni := strzero(Val(substr(DTOS(dGDatDe),1,4))-1,4)
	_cMesIni := strzero(Val(substr(DTOS(dGDatDe),5,2))+1,2)
EndIf

dGDatDe := stod(_cAnoIni+_cMesIni+"01")



Private oGDatAte
Private dGDatAte := LastDay(dDataBase)

Private oGCodVen
Private cGCodVen := CriaVar("A3_COD", .F.)
Private oGNomVen
Private cGNomVen

Private oGCodTra
Private cGCodTra := CriaVar("A4_COD", .F.)
Private oGNomTra
Private cGNomTra

Private oGCodPrd
Private cGCodPrd := CriaVar("B1_COD", .F.)
Private oGNomPrd
Private cGNomPrd

Private oGCodCli
Private cGCodCli := CriaVar("A1_COD", .F.)
Private oGLojCli
Private cGLojCli := CriaVar("A1_LOJA", .F.)
Private oGNomCli
Private cGNomCli

Private oGCodGrp
Private cGCodGrp := CriaVar("BM_GRUPO", .F.)
Private oGNomGrp
Private cGNomGrp

Private oGCodReg
Private cGCodReg := CriaVar("Z06_CODIGO", .F.)
Private oGNomReg
Private cGNomReg

Private oGCodZon
Private cGCodZon := CriaVar("ACY_GRPVEN", .F.)
Private oGNomZon
Private cGNomZon

Private oCTipo
Private cCTipo
Private aCTipo := { "Produto","Grupo" , "Vendedor" , "Cliente" , "Regiao" , "Divisao", "Transportadora", "Por Nota Fiscal" }
Private aTipoV := { "Produto","Grupo" , "Vendedor" , "Cliente" , "Regiao" , "Divisao", "Transportadora", "Por Nota Fiscal" }


Private oCTpImp
Private cCTpImp
Private aCTpImp  := { "KG","R$"  }
Private aCTpImpV := { "KG","R$"  }

//Private aTipoC := { "Produto", "Grupo" , "Fornecedor" , "Por Nota Fiscal" }

Private oBFiltro
Private lEdit     := .T.
Private lEditPesq := .T.
Private lEditVend := .T.
Private lEditComp := .T.

// Totais

Private oLTot1
Private nLTot1 := 0

Private oLTot2
Private nLTot2 := 0

Private oLTot3
Private nLTot3 := 0

Private oLTot4
Private nLTot4 := 0

Private oLTot5
Private nLTot5 := 0

Private oLTot6
Private nLTot6 := 0

Private oLTot7
Private nLTot7 := 0

Private oLTot8
Private nLTot8 := 0

Private oLTot9
Private nLTot9 := 0

Private oLTot10
Private nLTot10 := 0

Private oLTot11
Private nLTot11 := 0

Private oLTot12
Private nLTot12 := 0

Private oLTot13
Private nLTot13 := 0

Private oLTot14
Private nLTot14 := 0

Private oLTot15
Private nLTot15 := 0
Private oQtdReg
Private nQtdReg := 0

Private nColAnt := 0
Private cOrdAnt := "C"

/*
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ ExpA1 := MsAdvSize( [ ExpL1 ], [ ExpL2 ], [ ExpN1 ] )      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpL1 -> Enchoicebar .T. ou .F.                            ณฑฑ
ฑฑณ          ณ ExpL2 -> Retorna janela padrao siga                        ณฑฑ
ฑฑณ          ณ ExpN1 -> Tamanho minimo ( altura )                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ ExpA1 -> Dimensoes da janela / area de trabalho            ณฑฑ
ฑฑณ          ณ     1 -> Linha inicial area trabalho                       ณฑฑ
ฑฑณ          ณ     2 -> Coluna inicial area trabalho                      ณฑฑ
ฑฑณ          ณ     3 -> Linha final area trabalho                         ณฑฑ
ฑฑณ          ณ     4 -> Coluna final area trabalho                        ณฑฑ
ฑฑณ          ณ     5 -> Coluna final dialog                               ณฑฑ
ฑฑณ          ณ     6 -> Linha final dialog                                ณฑฑ
ฑฑณ          ณ     7 -> Linha inicial dialog                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ GENERICO                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

aSize    := MsAdvSize()

If aSize[3] < 495  // for็o tamanho da tela para 1024 x 768
	aSize[3] := 495
	aSize[4] := 283
	aSize[5] := 990
	aSize[6] := 597
	aSize[7] := 17
EndIf

aObjects := {{ 100, 040, .T., .F. },;
{ 100, 100, .T., .T. },;
{ 100, 022, .T., .F. }}

aInfo    := { aSize[1],;
aSize[2],;
aSize[3],;
aSize[4],;
3,;
3 }


/*
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณSintaxe   ณ ExpA1 := MsObjSize( ExpA2, ExpA3, [ ExpL1 ], [ ExpL2 ] )   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpA2 -> Area de trabalho                                  ณฑฑ
ฑฑณ          ณ ExpA3 -> Definicoes de objetos                             ณฑฑ
ฑฑณ          ณ    1 - Tamanho X    / 2 - Tamanho Y  / 3 - Dimensiona X    ณฑฑ
ฑฑณ          ณ    4 - Dimensiona Y / 5 - Retorna dimensoes X e Y ao inves ณฑฑ
ฑฑณ          ณ       de linha / coluna final                              ณฑฑ
ฑฑณ          ณ ExpL1 -> Mantem a proporcao dos objetos                    ณฑฑ
ฑฑณ          ณ ExpL2 -> Indica calculo de objetos horizontais             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ ExpA1 -> Array com as posicoes de cada objeto              ณฑฑ
ฑฑณ          ณ     1 -> Linha inicial                                     ณฑฑ
ฑฑณ          ณ     2 -> Coluna inicial                                    ณฑฑ
ฑฑณ          ณ     3 -> Linha final                                       ณฑฑ
ฑฑณ          ณ     4 -> Coluna final Ou:                                  ณฑฑ
ฑฑณ          ณ     Caso seja passado o elemento 5 de cada definicao de    ณฑฑ
ฑฑณ          ณ     objetos como .t. o retorno sera:                       ณฑฑ
ฑฑณ          ณ     3 -> Tamanho da dimensao X                             ณฑฑ
ฑฑณ          ณ     4 -> Tamanho da dimensao Y                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ GENERICO                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

aPosObj  := MsObjSize(aInfo, aObjects)

Define MsDialog oDlg Title cTitle From aSize[7], 0 To aSize[6], aSize[5] Of oMainWnd Pixel

@ aPosObj[1][1], aPosObj[1][2] To aPosObj[1][3]+22, aPosObj[1][4] Prompt "Filtro" Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+004 Say "Data de" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+032 MSGet oGDatDe Var dGDatDe VALID !Vazio() Size 45, 09 Picture "@D" When lEdit Of oDlg Pixel
@ aPosObj[1][1]+10, aPosObj[1][2]+084 Say "at้" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+101 MSGet oGDatAte Var dGDatAte VALID !Vazio() Size 45, 09 Picture "@D" When lEdit Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+205 Say "Produto" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+233 MSGet oGCodPrd Var cGCodPrd Valid Iif(Vazio() .or. ExistCpo("SB1", cGCodPrd, 1), (cGNomPrd := GetAdvFVal("SB1","B1_DESC",XFILIAL("SB1")+cGCodPrd,1,""),.T.),.F.) Size 30, 09 F3 "SB1" When lEdit Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+278 MSGet oGNomPrd Var cGNomPrd Size 100, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+383 Say "Grupo" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+403 MSGet oGCodGrp Var cGCodGrp Valid Iif(Vazio() .or. ExistCpo("SBM", cGCodGrp, 1), (cGNomGrp := GetAdvFVal("SBM","BM_DESC",XFILIAL("SBM")+cGCodGrp,1,""),.T.),.F.) Size 30, 09 F3 "SBM" When lEdit Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+438 MSGet oGNomGrp Var cGNomGrp Size 70, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+25, aPosObj[1][2]+004 Say "Cliente" Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+032 MSGet oGCodCli Var cGCodCli Valid Iif(Vazio() .or. ExistCpo("SA1", cGCodCli, 1), (cGNomCli := GetAdvFVal("SA1","A1_NOME",XFILIAL("SA1")+cGCodCli,1,""),.T.),.F.) Size 30, 09 F3 "SA1VEN" When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+067 MSGet oGLojCli Var cGLojCli Size 008, 09 When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+084 MSGet oGNomCli Var cGNomCli Size 120, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+25, aPosObj[1][2]+205 Say "Regiao" Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+233 MSGet oGCodReg Var cGCodReg Valid Iif(Vazio() .or. ExistCpo("Z06", cGCodReg, 1), (cGNomReg := GetAdvFVal("Z06","Z06_DESCRI",XFILIAL("Z06")+cGCodReg,1,""),.T.),.F.) Size 30, 09 F3 "Z06" When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+278 MSGet oGNomReg Var cGNomReg Size 100, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+25, aPosObj[1][2]+383 Say "Divisao" Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+403 MSGet oGCodZon Var cGCodZon Valid Iif(Vazio() .or. ExistCpo("ACY", cGCodZon, 1), (cGNomZon := GetAdvFVal("ACY","ACY_DESCRI",XFILIAL("ACY")+cGCodZon,1,""),.T.),.F.) Size 30, 09 F3 "ACY" When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+438 MSGet oGNomZon Var cGNomZon Size 70, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+40, aPosObj[1][2]+004 Say "Transp." Of oDlg Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+032 MSGet oGCodTra Var cGCodTra Valid Iif(Vazio() .or. ExistCpo("SA4", cGCodTra, 1), (cGNomTra := GetAdvFVal("SA4","A4_NOME",XFILIAL("SA4")+cGCodTra,1,""),.T.),.F.) Size 30, 09 F3 "SA4" When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+067 MSGet oGNomTra Var cGNomTra Size 137, 09 When .F. Of oDlg Pixel


@ aPosObj[1][1]+40, aPosObj[1][2]+205 Say "Vendedor" Of oDlg Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+233 MSGet oGCodVen Var cGCodVen Valid Iif(Vazio() .or. ExistCpo("SA3", cGCodVen, 1), (cGNomVen := GetAdvFVal("SA3","A3_NOME",XFILIAL("SA3")+cGCodVen,1,""),.T.),.F.) Size 30, 09 F3 "SA3" When lEditVend Of oDlg Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+278 MSGet oGNomVen Var cGNomVen Size 100, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+40, aPosObj[1][2]+383 Say "Tipo" Of oDlg Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+403 ComboBox oCTipo Var cCTipo Items aCTipo Size 40, 80 When lEdit Of oDlg Pixel

@ aPosObj[1][1]+40, aPosObj[1][2]+448 Say "Imprimir por: " Of oDlg Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+478 ComboBox oCTpImp Var cCTpImp Items aCTpImp  Size 40, 20 When lEdit Of oDlg Pixel

@ aPosObj[1][1]+38, aPosObj[1][2]+523 Button oBFiltro Prompt "Filtrar" Size 40, 16 Action BtnFiltro() Of oDlg Pixel

oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)

oGetDados:lInsert := .F.
oGetDados:lDelete := .F.
oGetDados:lUpdate := .F.

nBoxSize := (aPosObj[3][4]-aPosObj[3][2])/11      

If (!_cUsrLibA)    
	U_DBFILSA1()
	DbSelectArea("Z06") ; DbSetOrder(1)
	Set Filter To
	_cFilZ06 := ""
	If Len(_aFilRegV) > 0
		_cFilZ06 := "Z06_FILIAL=='" + xFilial("Z06") + "'"
		For nX := 1 To Len(_aFilRegV)
			If nX == 1
				_cFilZ06 += ".And.("
			Else
				_cFilZ06 += ".Or."
			EndIf
			_cFilZ06 += "(Z06_CODIGO=='"+_aFilRegV[nX] + "')"
		Next
		_cFilZ06 += ")"
		DbSelectArea("Z06")
		Set Filter To &(_cFilZ06)
	EndIf
	
	DbSelectArea("ACY") ; DbSetOrder(1)
	Set Filter To
	_cFilACY := ""
	If Len(_aFilGrpV) > 0
		_cFilACY := "ACY_FILIAL=='" + xFilial("ACY") + "'"
		For nX := 1 To Len(_aFilGrpV)
			If nX == 1
				_cFilACY += ".And.("
			Else
				_cFilACY += ".Or."
			EndIf
			_cFilACY += "(ACY_GRPVEN=='"+_aFilGrpV[nX] + "')"
		Next
		_cFilACY += ")"
		DbSelectArea("ACY")
		Set Filter To &(_cFilACY)
	EndIf
EndIf

//fValCon(.T.)  

/*
@ aPosObj[3][1], aPosObj[3][2]  To aPosObj[3][3], nBoxSize-1      Prompt "Quant Mes 1" Of oDlg Pixel
@ aPosObj[3][1],  nBoxSize+1    To aPosObj[3][3], (nBoxSize*2)-1  Prompt "Quant Mes 2" Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*2)+1 To aPosObj[3][3], (nBoxSize*3)-1  Prompt "Quant Mes 3" Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*3)+1 To aPosObj[3][3], (nBoxSize*4)-1  Prompt "Quant Mes 4" Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*4)+1 To aPosObj[3][3], (nBoxSize*5)-1  Prompt "Quant Mes 5"  Of oDlg Pixel

@ aPosObj[3][1], (nBoxSize*5)+1 To aPosObj[3][3], (nBoxSize*3)-1  Prompt "Quant Mes 6" Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*6)+1 To aPosObj[3][3], (nBoxSize*4)-1  Prompt "Quant Mes 7" Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*7)+1 To aPosObj[3][3], (nBoxSize*5)-1  Prompt "Quant Mes 8"  Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*8)+1 To aPosObj[3][3], (nBoxSize*3)-1  Prompt "Quant Mes 9" Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*9)+1 To aPosObj[3][3], (nBoxSize*4)-1  Prompt "Quant Mes 10" Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*10)+1 To aPosObj[3][3], (nBoxSize*5)-1  Prompt "Quant Mes 11"  Of oDlg Pixel
@ aPosObj[3][1], (nBoxSize*11)+1 To aPosObj[3][3], (nBoxSize*5)-1  Prompt "Quant Mes 12"  Of oDlg Pixel

@ aPosObj[3][1]+9, (nBoxSize-1)-42  Say oLTot1	  Var nLTot1    Picture "@E 99,999,999.99" 	Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*2)-43  Say oLTot2    Var nLTot2    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*3)-43  Say oLTot3 	  Var nLTot3    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*4)-43  Say oLTot4    Var nLTot4    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*5)-43  Say oLTot5    Var nLTot5    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*6)-43  Say oLTot6    Var nLTot6    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*7)-43  Say oLTot7    Var nLTot7    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*8)-43  Say oLTot8    Var nLTot8    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*9)-43  Say oLTot9    Var nLTot9    Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*10)-43  Say oLTot10   Var nLTot10   Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*11)-43  Say oLTot11   Var nLTot11   Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
@ aPosObj[3][1]+9, (nBoxSize*12)-43  Say oLTot12   Var nLTot12   Picture "@E 99,999,999.99"  Right Size 40, 17 Of oDlg Pixel
*/

//@ aPosObj[3][1]+9, (nBoxSize*5)-43  Say oQtdReg   Var nQtdReg   Picture "@E 9,999,999,999"  Right Size 40, 17 Of oDlg Pixel


Activate MsDialog oDlg On Init (EnchoiceBar(oDlg, bOk, bCancel,, aButtons), ButWhen(@oDlg)) Centered


Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBtnFiltro บAutor  ณMicrosiga           บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcal Botao Filtrar                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BtnFiltro

Local _nI             
Local _cMsgAl := "" 
Local _nMeses := 0   

_nMeses := DateDiffMonth( dGDatAte , dGDatDe )  
        
If _nMeses > 11 
	MsgAlert("O periodo do relatorio nao pode ser maior que o de 12 meses","Periodo Maior de 12 meses")
	Return()
EndIf
                   
If dGDatAte < dGDatDe    
	MsgAlert("A Data Final nใo pode ser inferior a Data Inicial do Relat๓rio","Data Final Menor que Data Inicial")
	Return()
EndIf    

_cMsgAl += IIF(Empty(_cFilGrpV), "Usuario sem Regiao de Vendas Cadastrada" + cEof , "")
_cMsgAl += IIF(Empty(_cFilRegV), "Usuario sem Divisao de Vendas Cadastrada" + cEof , "")

If (!Empty(AllTrim(_cMsgAl))) .And. !_cUsrLibA   
	_cMsgAl += cEof + cEof +  "Verifique estas informacoes e em caso de duvidas, entre em contao com o T.I. Verquํmica"
	MessageBox(_cMsgAl,"Verquimica: Alerta", 48) //Alerta
	Return()
EndIf 

If !Empty(cGCodCli) .Or. !Empty(cGLojCli)
	DbSelectArea("SA1") ; DbSetOrder(1)
	If !SA1->(DbSeek(xFilial("SA1")+cGCodCli+cGLojCli))
		MsgAlert("Cliente nao encontrado. Verifique se o codigo e loja estao corretos","Cadastro Nao Encontrado?")
		Return()
	EndIf
EndIf

Do Case
	
	Case lEditPesq
		
		lEdit     := .F.
		lEditPesq := .F.
		lEditComp := .F.
		lEditVend := .F.
		
		oBFiltro:cTitle := "Limpar"
		
		MsAguarde({|| FilAnual() }, "Aguarde", "Gerando Consulta ...", .F.)
		
//		oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)
 	    oGetDados := MsNewGetDados():New(aPosObj[2][1]+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)
		oGetDados:lInsert := .F.
		oGetDados:lDelete := .F.
		oGetDados:lUpdate := .F.                                                             
		oGetDados:lActive := .F.
		oGetDados:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}
	Otherwise
		
		oBFiltro:cTitle := "Filtrar"
		lEditPesq := .T.
		fValCon()
		
		oGetDados:aCols := {}
		
		nLTot1  := 0
		nLTot2  := 0
		nLTot3  := 0
		nLTot4  := 0
		nLTot5  := 0
		nLTot6  := 0
		nLTot7  := 0
		nLTot8  := 0
		nLTot9  := 0
		nLTot10 := 0
		nLTot11 := 0
		nLTot12 := 0
		nLTot13 := 0
		nLTot14 := 0
		nLTot15 := 0
		nQtdReg := 0
		
		/*
		oLTot1:Refresh()
		oLTot2:Refresh()
		oLTot3:Refresh()
		oLTot4:Refresh() 
		oLTot5:Refresh()
		oLTot6:Refresh()
		oLTot7:Refresh()
		oLTot8:Refresh()
		oLTot9:Refresh()
		oLTot10:Refresh()
		oLTot11:Refresh()
		oLTot12:Refresh()
		*/				
//		oQtdReg:Refresh()
		
EndCase

Return(Nil)

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+------------------------------+------------------+||
||| Programa: fOrdTemp  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+---------+------------------------------+------------------+||
||| Descricao | Organiza MsSelect. Altera o indice de selecao             |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fOrdTemp(obj, col)

Local aTmpCols  := {}
Local aTmpTotal := {}
Local aTm1Cols  := {}
Local aTm1Total := {}

If nColAnt != col
	nColAnt := col
	cOrdAnt := "C"
Else
	If cOrdAnt == "C"
		cOrdAnt := "D"
	Else
		cOrdAnt := "C"
	EndIf
EndIf

nPosTos := Len(oGetDados:ACOLS)

For nX := 1 To nPosTos -1
	aadd(aTmpCols,aClone(oGetDados:ACOLS[nX]))
	aadd(aTm1Cols,aClone(ACOLS[nX]))
Next nX

aAdd(aTmpTotal,aClone(oGetDados:ACOLS[nPosTos]))
aAdd(aTm1Total,aClone(ACOLS[nPosTos]))

oGetDados:ACOLS := aClone(aTmpCols)
ACOLS := aClone(aTm1Cols)

If cOrdAnt == "C"
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] < y[col]})
	ACOLS := aSort(ACOLS,,,{|x,y| x[col] < y[col]})
Else
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] > y[col]})
	ACOLS := aSort(ACOLS,,,{|x,y| x[col] > y[col]})
EndIf

aAdd(oGetDados:ACOLS,aClone(aTmpTotal[1]))
aAdd(ACOLS,aClone(aTm1Total[1]))

oGetDados:oBrowse:Refresh(.T.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVQCONVEN  บAutor  ณMicrosiga           บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza Filtro na base de dados conf. parametros           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FilAnual()

Local cSQL := cSQLP := cSQLD := ""
Local nOpcRank
Local _nI := _nAux := 0
Local _aMeses    := {}
Local _dGDatDe
Local _dGetdtAte
Local nLenAnt
Local aEstru
Local cCod
Local nOpcPerc

Local _cCod    := ""
Local _cDesc   := ""
Local _cPicCod := ""
Local _cPicDes := ""
Local _nTGrp   := 0    
                     
Local _lGrpWhe  := .F.
Local _cQryCod := "" 
Local _cQryWhe := ""   

//Local _cQryCod := ""
//Local _cQryDes := ""

Private	_cQryCod := "  "
Private	_cQryDes := "  "

nOpTipo := aScan( aCTipo, cCTipo)
nTipImp := aScan( aCTpImp, cCTpImp)

aHeader := {}


If nOpTipo == 1   // Produto
	_cCod    := "Produto"
	_cDesc   := "Descricao"
	
	_nTGrp   := TamSX3("B1_DESC")[1]
	_cPicCod := PesqPict("SB1","B1_COD",15)
	_cPicDes := PesqPict("SB1","B1_DESC",_nTGrp)
	
	_cQryCod := " PRODUTO "
	_cQryDes := " DESC_PRD "
ElseIf nOpTipo == 2   // Por Grupo
	_cCod    := "Grupo"
	_cDesc   := "Descricao"
	
	_nTGrp   := TamSX3("BM_DESC")[1]
	_cPicCod := PesqPict("SBM","BM_GRUPO",15)
	_cPicDes := PesqPict("SBM","BM_DESC",_nTGrp)
	
	_cQryCod := " GRUPO "
	_cQryDes := " DESC_GRP "
	
ElseIf nOpTipo == 3 // Por Vendedor
	_cCod    := "Vendedor"
	_cDesc   := "Nome"
	_nTGrp   := TamSX3("A3_NOME")[1]
	_cPicCod := PesqPict("SA3","A3_COD",15)
	_cPicDes := PesqPict("SA3","A3_NOME",_nTGrp)
	
	_cQryCod := " VENDEDOR "
	_cQryDes := " NOME_VEN "
	
ElseIf nOpTipo == 4 // Por Cliente
	_cCod    := "Cliente"
	_cDesc   := "Nome"
	_nTGrp   := TamSX3("A1_NOME")[1]
	_cPicCod := PesqPict("SA1","A1_COD",15)
	_cPicDes := PesqPict("SA1","A1_NOME",_nTGrp)
	
	_cQryCod := " CLIENTE, LOJA "
	_cQryDes := " NOME_CLI "
	
ElseIf nOpTipo == 5 // Por Regiao
	_cCod    := "Regiao"
	_cDesc   := "Descricao"
	_nTGrp   := TamSX3("Z06_DESCRI")[1]
	_cPicCod := PesqPict("Z06","Z06_CODIGO",15)
	_cPicDes := PesqPict("Z06","Z06_DESCRI",_nTGrp)

	If !Empty(cGCodReg)
		_cQryWhe := " WHERE REGIAO IN ('"+cGCodReg+"')"  
		_lGrpWhe := .T.
	Else    
		If !Empty( _cFilRegV ) .AND. !_cUsrLibA                                     
			_cQryWhe := " WHERE REGIAO IN ("+_cFilRegV+")"   
			_lGrpWhe := .T.
		EndIf
	EndIf	
	
	_cQryCod := " REGIAO "
	_cQryDes := " NOME_REG "
	
ElseIf nOpTipo == 6 // Por Zona
	_cCod    := "Divisao"
	_cDesc   := "Descricao"
	_nTGrp   := TamSX3("ACY_DESCRI")[1]
	_cPicCod := PesqPict("ACY","ACY_GRPVEN",15)
	_cPicDes := PesqPict("ACY","ACY_DESCRI",_nTGrp)   
	
	If !Empty(cGCodZon) 
		_cQryWhe := " WHERE GRUPO_VE IN ('"+cGCodZon+"')" 
	   	_lGrpWhe := .T.
	Else   
		If !Empty( _cFilGrpV ) .AND. !_cUsrLibA
			_cQryWhe := "WHERE GRUPO_VE IN ("+_cFilGrpV+")"  
			_lGrpWhe := .T.                                  
		EndIf
	EndIf
	
	_cQryCod := " GRUPO_VE "
	_cQryDes := " NOME_ZON "
	
ElseIf nOpTipo == 7 // Transportadora
	_cCod    := "Transportadora"
	_cDesc   := "Nome"
	_nTGrp   := TamSX3("A4_NOME")[1]
	_cPicCod := PesqPict("SA4","A4_COD",15)
	_cPicDes := PesqPict("SA4","A4_NOME",_nTGrp)
	
	_cQryCod := " TRANSP "
	_cQryDes := " NOME_TRA "
	
ElseIf nOpTipo == 8 // Por Nota
	_cCod    := "Nota.Fiscal"
	_cDesc   := "Descricao"
	_nTGrp   := TamSX3("F2_SERIE")[1]
	_cPicCod := PesqPict("SF2","F2_DOC",15)
	_cPicDes := PesqPict("SF2","F2_SERIE",_nTGrp)
	
	_cQryCod := " DOC "
	_cQryDes := " SERIE "
	
EndIf

Aadd(aHeader,{_cCod	   ,_cCod    		,_cPicCod,12    ,0,"",USADO,"C",,""})
Aadd(aHeader,{_cDesc   ,_cDesc   		,_cPicDes,30,0,"",USADO,"C",,""})
//Aadd(aHeader,{_cDesc   ,_cDesc   		,_cPicDes,_nTGrp,0,"",USADO,"C",,""})

If substr(DTOS(dGDatAte),5,2) = "12"
	_cAnoIni := substr(DTOS(dGDatAte),1,4)
	_cMesIni := "01"
Else
	_cAnoIni := strzero(Val(substr(DTOS(dGDatAte),1,4))-1,4)
	_cMesIni := strzero(Val(substr(DTOS(dGDatAte),5,2))+1,2)
EndIf

_cMesAtu := _cMesIni //substr(DTOS(dGDatAte),1,4)
_cAnoAtu := _cAnoIni                                   
_aMes    := {}

For _nCont := 1 to 12
	

	Aadd(_aMes,_cMesAtu)
	
	If _cMesAtu = "01" 
		_cNomMes := "Jan / "+_cAnoAtu
	ElseIf _cMesAtu = "02" 
		_cNomMes := "Fev / "+_cAnoAtu
	ElseIf _cMesAtu = "03" 
		_cNomMes := "Mar / "+_cAnoAtu	
	ElseIf _cMesAtu = "04" 
		_cNomMes := "Abr / "+_cAnoAtu	
	ElseIf _cMesAtu = "05" 
		_cNomMes := "Mai / "+_cAnoAtu
	ElseIf _cMesAtu = "06" 
		_cNomMes := "Jun / "+_cAnoAtu
	ElseIf _cMesAtu = "07" 
		_cNomMes := "Jul / "+_cAnoAtu
	ElseIf _cMesAtu = "08" 
		_cNomMes := "Ago / "+_cAnoAtu
	ElseIf _cMesAtu = "09" 
		_cNomMes := "Set / "+_cAnoAtu
	ElseIf _cMesAtu = "10" 
		_cNomMes := "Out / "+_cAnoAtu
	ElseIf _cMesAtu = "11" 
		_cNomMes := "Nov / "+_cAnoAtu
	ElseIf _cMesAtu = "12" 
		_cNomMes := "Dez / "+_cAnoAtu
	EndIf
	
	Aadd(aHeader,{_cNomMes       ,_cMesAtu 		,"@E 999,999,999,999.99",15,2,"",USADO,"N",,""})
//	Aadd(aHeader,{_cNomMes       ,_cMesAtu 		,PesqPict("SD2","D2_QUANT",14),14,4,"",USADO,"N",,""})	
	
	If _cMesAtu = "12"
		_cMesAtu := "01"
		_cAnoAtu := strzero(Val(_cAnoAtu)+1,4)
	Else
		_cMesAtu := strzero(Val(_cMesAtu)+1,2)
	EndIf
	
Next _nCont

Aadd(aHeader,{"Total"       ,"TOTAL" ,"@E 999,999,999,999.99"/*PesqPict("SD2","D2_TOTAL",14)*/,15,2,"",USADO,"N",,""})
Aadd(aHeader,{"Media Mes"   ,"MEDIA" ,"@E 99,999,999.99"/*PesqPict("SD2","D2_TOTAL",14)*/,11,2,"",USADO,"N",,""})
Aadd(aHeader,{"Maior Venda" ,"MAIOR" ,"@E 99,999,999.99"/*PesqPict("SD2","D2_TOTAL",14)*/,11,2,"",USADO,"N",,""})


_cQry := " "

_cQry := " 		SELECT    "
_cQry += _cQryCod + ", " + _cQryDes + ",                                                   " + cEof

If nTipImp == 1   
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[1]+"' THEN D2_QUANT ELSE 0 END )  C01,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[2]+"' THEN D2_QUANT ELSE 0 END )  C02,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[3]+"' THEN D2_QUANT ELSE 0 END )  C03,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[4]+"' THEN D2_QUANT ELSE 0 END )  C04,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[5]+"' THEN D2_QUANT ELSE 0 END )  C05,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[6]+"' THEN D2_QUANT ELSE 0 END )  C06,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[7]+"' THEN D2_QUANT ELSE 0 END )  C07,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[8]+"' THEN D2_QUANT ELSE 0 END )  C08,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[9]+"' THEN D2_QUANT ELSE 0 END )  C09,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[10]+"' THEN D2_QUANT ELSE 0 END )  C10,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[11]+"' THEN D2_QUANT ELSE 0 END )  C11,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[12]+"' THEN D2_QUANT ELSE 0 END )  C12,     " + cEof
_cQry +=  "		SUM( D2_QUANT )  TOTAL,   " + cEof
_cQry +=  "		SUM( D2_QUANT )/12  MEDIA,   " + cEof
_cQry +=  "		MAX( D2_QUANT )  MAIOR   " + cEof
ElseIf nTipImp == 2 
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[1]+"' THEN D2_TOTAL ELSE 0 END )  C01,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[2]+"' THEN D2_TOTAL ELSE 0 END )  C02,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[3]+"' THEN D2_TOTAL ELSE 0 END )  C03,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[4]+"' THEN D2_TOTAL ELSE 0 END )  C04,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[5]+"' THEN D2_TOTAL ELSE 0 END )  C05,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[6]+"' THEN D2_TOTAL ELSE 0 END )  C06,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[7]+"' THEN D2_TOTAL ELSE 0 END )  C07,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[8]+"' THEN D2_TOTAL ELSE 0 END )  C08,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[9]+"' THEN D2_TOTAL ELSE 0 END )  C09,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[10]+"' THEN D2_TOTAL ELSE 0 END )  C10,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[11]+"' THEN D2_TOTAL ELSE 0 END )  C11,     " + cEof
_cQry +=  "		SUM( CASE WHEN MES = '"+_aMes[12]+"' THEN D2_TOTAL ELSE 0 END )  C12,     " + cEof
_cQry +=  "		SUM( D2_TOTAL )  TOTAL,   " + cEof
_cQry +=  "		SUM( D2_TOTAL )/12  MEDIA,   " + cEof
_cQry +=  "		MAX( D2_TOTAL )  MAIOR   " + cEof
EndIf

_cQry +=  "		FROM (SELECT SUBSTRING(D2_EMISSAO,5,2)  MES,   " + cEof

_cQry += "      SF2.F2_DOC                                                     DOC      ,  " + cEof
_cQry += "      SF2.F2_SERIE                                                   SERIE    ,  " + cEof
_cQry += "      SF2.F2_CLIENTE                                                 CLIENTE  ,  " + cEof
_cQry += "      SF2.F2_LOJA                                                    LOJA     ,  " + cEof
_cQry += "      SA1.A1_NOME                                                    NOME_CLI ,  " + cEof
_cQry += "      SF2.F2_REGIAO                                                  REGIAO   ,  " + cEof
_cQry += "      COALESCE(Z06.Z06_DESCRI,' ')                                   NOME_REG ,  " + cEof
_cQry += "      SF2.F2_GRPVEN                                                  GRUPO_VE ,  " + cEof
_cQry += "      COALESCE(ACY.ACY_DESCRI,' ')                                   NOME_ZON ,  " + cEof
_cQry += "      COALESCE(SA4.A4_COD    ,' ')                                   TRANSP   ,  " + cEof
_cQry += "      COALESCE(SA4.A4_NOME   ,' ')                                   NOME_TRA ,  " + cEof
_cQry += "      SF2.F2_EMISSAO                                                 EMISSAO  ,  " + cEof
_cQry += "      SF2.F2_VEND1                                                   VENDEDOR ,  " + cEof
_cQry += "      SA3.A3_NOME                                                    NOME_VEN ,  " + cEof
_cQry += "      SBM.BM_GRUPO                                                   GRUPO    ,  " + cEof
_cQry += "      SBM.BM_DESC                                                    DESC_GRP ,  " + cEof
_cQry += "      SD2.D2_COD                                                     PRODUTO  ,  " + cEof
_cQry += "      SB1.B1_DESC                                                    DESC_PRD ,  " + cEof
_cQry +=  "		D2_QUANT,   " + cEof
_cQry +=  "		D2_TOTAL   " + cEof
_cQry += "    FROM " + RetSqlName("SD2") + " SD2                                           " + cEof  
_cQry += "      INNER JOIN " + RetSqlName("SF2") + " SF2 ON                                " + cEof
_cQry += "        SF2.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'                             " + cEof
_cQry += "        AND SF2.F2_DOC    = SD2.D2_DOC                                           " + cEof
_cQry += "        AND SF2.F2_SERIE  = SD2.D2_SERIE                                         " + cEof
_cQry += "        AND SF2.F2_EMISSAO BETWEEN '"+DTOS(dGDatDe)+"' AND '"+DTOS(dGDatAte)+"'  " + cEof

_cQry += "      INNER JOIN " + RetSqlName("SA1") + " SA1 ON                                " + cEof
_cQry += "        SA1.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'                             " + cEof
_cQry += "        AND SA1.A1_COD    = SD2.D2_CLIENTE                                       " + cEof
_cQry += "        AND SA1.A1_LOJA   = SD2.D2_LOJA                                          " + cEof
If !Empty(cGCodReg)
_cQryJoin := "INNER"
Else
_cQryJoin := "LEFT "
EndIf
_cQry += "      "+_cQryJoin+" JOIN " + RetSqlName("Z06") + " Z06 ON                        " + cEof
_cQry += "        Z06.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND Z06.Z06_FILIAL = '" + xFilial("Z06") + "'                            " + cEof
_cQry += "        AND Z06.Z06_CODIGO = SF2.F2_REGIAO                                       " + cEof
_cQry += "      LEFT  JOIN " + RetSqlName("ACY") + " ACY ON                                " + cEof
_cQry += "        ACY.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'                            " + cEof
_cQry += "        AND ACY.ACY_GRPVEN = SF2.F2_GRPVEN                                       " + cEof
_cQry += "      LEFT  JOIN " + RetSqlName("SA4") + " SA4 ON                                " + cEof
_cQry += "        SA4.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'                             " + cEof
_cQry += "        AND SA4.A4_COD    = SF2.F2_TRANSP                                         " + cEof
_cQry += "      INNER JOIN " + RetSqlName("SA3") + " SA3 ON                                " + cEof
_cQry += "        SA3.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'                             " + cEof
_cQry += "        AND SA3.A3_COD    = SF2.F2_VEND1                                         " + cEof
_cQry += "      INNER JOIN " + RetSqlName("SB1") + " SB1 ON                                " + cEof
_cQry += "        SB1.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'                             " + cEof
_cQry += "        AND SB1.B1_COD    = SD2.D2_COD                                           " + cEof
_cQry += "      INNER JOIN " + RetSqlName("SBM") + " SBM ON                                " + cEof
_cQry += "        SBM.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'                             " + cEof
_cQry += "        AND SBM.BM_GRUPO  = SB1.B1_GRUPO                                         " + cEof
_cQry += "      INNER JOIN " + RetSqlName("SF4") + " SF4 ON                                " + cEof
_cQry += "        SF4.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'                             " + cEof
_cQry += "        AND SF4.F4_CODIGO = SD2.D2_TES                                           " + cEof
_cQry += "        AND SF4.F4_DUPLIC = 'S'                                                  " + cEof
//_cQry += "        AND SF4.F4_ESTOQUE = 'S'                                                 " + cEof
_cQry += "      INNER JOIN " + RetSqlName("SM2") + " SM2 ON                                " + cEof
_cQry += "        SM2.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "        AND M2_DATA = F2_EMISSAO                                                 " + cEof
_cQry += "    WHERE                                                                        " + cEof
_cQry += "      SD2.D_E_L_E_T_ <> '*'                                                      " + cEof
_cQry += "      AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'                               " + cEof
_cQry += "      AND SD2.D2_TIPO   IN ('N','C')                                             " + cEof  
If !Empty(cGCodZon)
_cQry += "      AND ACY.ACY_GRPVEN = '"+cGCodZon+"'                                      " + cEof
EndIf
If !Empty(cGCodReg)
_cQry += "      AND Z06.Z06_CODIGO = '"+cGCodReg+"'                                    " + cEof
EndIf
If !Empty(cGCodVen)
_cQry += "      AND SF2.F2_VEND1 = '"+cGCodVen+"'                                      " + cEof
EndIf
If !Empty(cGCodTra)
_cQry += "      AND SF2.F2_TRANSP = '"+cGCodTra+"'                                      " + cEof
EndIf
If !Empty(cGCodGrp)
_cQry += "      AND SD2.D2_GRUPO = '"+cGCodGrp+"'                                      " + cEof
EndIf              
If !Empty(cGCodPrd)
_cQry += "      AND SD2.D2_COD   = '"+cGCodPrd+"'                                      " + cEof
EndIf       

If !Empty(cGCodReg)
	_cQry += "      AND SF2.F2_REGIAO = '"+cGCodReg+"'                                    " + cEof
Else
	If !_cUsrLibA .And. !Empty(_cFilRegV)
		_cQry += "      AND SF2.F2_REGIAO IN ("+_cFilRegV+")	                           " + cEof		
	EndIf
EndIf 

If !Empty(cGCodZon)
	_cQry += "      AND SF2.F2_GRPVEN = '"+cGCodZon+"'                                      " + cEof  
Else
	If !_cUsrLibA .And. !Empty(_cFilGrpV)
		_cQry += "      AND SF2.F2_GRPVEN IN ("+_cFilGrpV+")	                           " + cEof		
	EndIf              
EndIf

If !_cUsrLibA .And. !Empty(_cGrpReg)
	_cQry += "      AND SF2.F2_REGIAO||SF2.F2_GRPVEN IN ("+_cGrpReg+")	                           " + cEof		
EndIf              



If !Empty(cGCodCli) .And. !Empty(cGLojCli)
_cQry += "      AND SD2.D2_CLIENTE = '"+cGCodCli+"'                                      " + cEof
_cQry += "      AND SD2.D2_LOJA    = '"+cGLojCli+"'                                      " + cEof   

EndIf

_cQry += "      ) SD " + cEof        

If _lGrpWhe
	_cQry += _cQryWhe + cEof 
EndIf

_cQry += " GROUP BY " + _cQryCod + ", " + _cQryDes + "                                     " + cEof
_cQry += " ORDER BY " + _cQryCod + ", " + _cQryDes + "                                     " + cEof

      
// Carrega variavel para impressao no cabecalho do relatorio
_cFiltela :=""
If !Empty(cGCodReg)
   _cFiltela += " Regiao: "+AllTrim(cGNomReg)
EndIf

If !Empty(cGCodZon)
   _cFiltela += " Zona: "+AllTrim(cGNomZon)
EndIf

If !Empty(cGCodVen)
   _cFiltela += " Vendedor: "+AllTrim(cGNomVen)
EndIf

If !Empty(cGCodTra)
   _cFiltela += " Transp: "+AllTrim(cGNomTra)
EndIf

If !Empty(cGCodGrp)
   _cFiltela += " Grupo: "+AllTrim(cGNomGrp)
EndIf

If !Empty(cGCodPrd)
   _cFiltela += " Produto: "+AllTrim(cGNomPrd)
EndIf

If !Empty(cGCodCli)
   _cFiltela += " Cliente: "+AllTrim(GetAdvFVal("SA1","A1_NREDUZ",XFILIAL("SA1")+cGCodCli,1,""))
EndIf


///padrao
/*
_cQry +=  "		 WHERE SD2.D_E_L_E_T_ <> '*'  "
_cQry +=  "		 AND SF4.D_E_L_E_T_ <> '*'    "
_cQry +=  "		 AND SA1.D_E_L_E_T_ <> '*'    "
_cQry +=  "		 AND SB1.D_E_L_E_T_ <> '*'    "
_cQry +=  "		 AND D2_COD = B1_COD   		  "
_cQry +=  "		 AND D2_CLIENTE = A1_COD      "
_cQry +=  "		 AND D2_LOJA = A1_LOJA        "
_cQry +=  "		 AND D2_TES = F4_CODIGO       "
_cQry +=  "		 AND F4_DUPLIC = 'S'          "
_cQry +=  "		 AND D2_EMISSAO BETWEEN '20140501' AND '20150631'   "
_cQry +=  "		 AND D2_TIPO = 'N')  D2   "
*/

If "Administrador"$cUserName .And. !EECVIEW(@_cQry)
	RETURN
EndIf

_cQry := ChangeQuery(_cQry)


TCQUERY _cQry NEW ALIAS "TABTMP"
MemoWrite("C:\temp\VQCONVEN.txt",_cQry)

// aCols
aCols := {}
Dbselectarea("TABTMP")
  
Do While TABTMP->(!Eof())
	
	aAdd( aCols, { TABTMP->&(StrTran(_cQryCod,",","+' - '+")) , ;
	TABTMP->&_cQryDes,;
	TABTMP->C01,;
	TABTMP->C02,;
	TABTMP->C03,;
	TABTMP->C04,;
	TABTMP->C05,;
	TABTMP->C06,;
	TABTMP->C07,;
	TABTMP->C08,;
	TABTMP->C09,;
	TABTMP->C10,;
	TABTMP->C11,;
	TABTMP->C12,;
	TABTMP->TOTAL,;
	TABTMP->MEDIA,;
	TABTMP->MAIOR,;
	.F. } )
	
	nLTot1  += TABTMP->C01
	nLTot2  += TABTMP->C02
	nLTot3  += TABTMP->C03
	nLTot4  += TABTMP->C04
	nLTot5  += TABTMP->C05
	nLTot6  += TABTMP->C06
	nLTot7  += TABTMP->C07
	nLTot8  += TABTMP->C08
	nLTot9  += TABTMP->C09
	nLTot10 += TABTMP->C10								
	nLTot11 += TABTMP->C11	
	nLTot12 += TABTMP->C12
	nLTot13 += TABTMP->TOTAL
	nLTot14 += TABTMP->MEDIA
	nLTot15 += TABTMP->MAIOR
//	nQtdReg += TABTMP->MAIOR
	
	TABTMP->(DbSkip())
	
EndDo


aAdd( aCols, { "",;
"TOTAL "+UPPER(_cCod) ,;
nLTot1,;
nLTot2,;
nLTot3,;
nLTot4,;
nLTot5,;
nLTot6,;
nLTot7,;
nLTot8,;
nLTot9,;
nLTot10,;
nLTot11,;
nLTot12,;
nLTot13,;
nLTot14,;
nLTot15,;
.F. } )

/*
oLTot1:Refresh()
oLTot2:Refresh()
oLTot3:Refresh()
oLTot4:Refresh()
oLTot5:Refresh()
oLTot6:Refresh()
oLTot7:Refresh()
oLTot8:Refresh()
oLTot9:Refresh()
oLTot10:Refresh()
oLTot11:Refresh()
oLTot12:Refresh()
*/
TABTMP->(dbCloseArea())


Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVQCONVEN  บAutor  ณMicrosiga           บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Imprime()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
LOCAL cDesc1   := "Relatorio de Vendas Mensal em KG"

PRIVATE nomeprog := "VQCONVEN"
PRIVATE titulo   := "Fat. Mensal(KG) De " + DtoC(dGDatDe) + " a " + DtoC(dGDatAte)+" Filtro: "+_cFiltela
Private aFiltros := {}
  
IF (_cUsrLibA)
	U_VenMesTRep( Titulo , cDesc1 , nomeprog , aFiltros )
Else
	MessageBox("Usuario sem permissao para impressao do relatorio","Verquimica: Usuario sem permissao", 48) //Alerta
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVQCONVEN  บAutor  ณMicrosiga           บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Desabilita / Habilita botao da barra                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function ButWhen(_oObj)

Local _nPosImp

If ( _nPosImp := AScan(_oObj:aControls, { |x| x:cTitle == "Imprimir" } ) ) > 0
	_oObj:aControls[_nPosImp]:lActive := !lEdit
	_oObj:aControls[_nPosImp]:bWhen   := { || !lEdit }
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVenMesTRepบAutor  ณMicrosiga           บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Imprime relatorio TReport com base na Acols               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VenMesTRep( cTitulo , cDescri , cReport , aFilt , aHeaderx , aColsx )

Local   oReport
Local   oSection1
Default cDescri   := ""
Default cReport   := "Relatorio de Vendas Mensal - De " + DtoC(dGDatDe) + " a " + DtoC(dGDatAte)+"  Por: "+Alltrim(_cQryCod)+"  "+_cFiltela
Default cTitulo   := "Relatorio de Vendas Mensal - De " + DtoC(dGDatDe) + " a " + DtoC(dGDatAte)+"  Por: "+Alltrim(_cQryCod)+"  "+_cFiltela
Default aFilt     := {}
Private aFilter   := aFilt


If ValType( aHeaderx ) = "A"
	Private aHeader := aHeaderx
EndIf
If ValType( aColsx ) = "A"
	Private aCols := aColsx
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe nao passou os parametros para fun็ใo e  ณ
//ณnao existe 'aHeader' ou 'aCols' declarados.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Type( "aHeader" ) = "U"
	Private aHeader := {}
EndIf
If Type( "aCols" ) = "U"
	Private aCols := {}
EndIf

Begin Sequence

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Cria objeto TReportณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport  := TReport():New( cReport, cTitulo ,, { |oReport| ReportPrint( oReport ) } , cDescri )

oReport:SetLandscape()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCria se็ใo do Relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection1 := TRSection():New( oReport, "Parametros do Relatorio"  )
oSection2 := TRSection():New( oReport, "Campos do Relatorio"  )

SX3->( DbSetOrder( 2 ) )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define c้lulas que serใo carregadas na impressใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 To Len( aHeader )
	If !Empty( aHeader[ i ][ 1 ] )
		TRCell():New( oSection2                     ,;
		aHeader[ i ][ 2 ]              ,;
		/* cAlias */                   ,;
		aHeader[ i ][ 1 ] /*Titulo*/   ,;
		aHeader[ i ][ 3 ] /*Picture*/  ,;
		aHeader[ i ][ 4 ] /*Tamanho*/  ,;
		/*lPixel*/   ,;
		/*CodeBlock*/                   ;
		)
	EndIf
Next


TRCell():New( oSection1 , "PARAMETROS" ,, "Parametros do Relatorio" , "" , 200 )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine o cabecalho da secao como padraoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oSection1:SetHeaderPage()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณDefine em 'Arquivo' a saํda default.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
oReport:nDevice := 1

oReport:PrintDialog()


End Sequence

Return( cReport )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrint  บAutor  ณMicrosiga        บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao auxiliar para impressao do relatorio               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ReportPrint( oReport )

Local oSection1 := oReport:Section( 1 )
Local oSection2 := oReport:Section( 2 )
Local i
Local j
Local cFilter   := ""
Local lExcel    := oReport:nDevice = 4
Local xValue
Local nPos

oReport:SetMeter( Len( aCols ) )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o destino nao for para uma planilha, imprime se็ใo de parametros.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lExcel
	For i := 1 To Len( aFilter )
		If Empty( aFilter[ i ][ 2 ] )
			Loop
		EndIf
		If !Empty( cFilter )
			cFilter += " <> "
		EndIf
		cFilter += aFilter[ i ][ 1 ] + ":" + aFilter[ i ][ 2 ]
	Next
	If !Empty( cFilter )
		oSection1:Init()
		oSection1:Cell( "PARAMETROS" ):SetValue( cFilter )
		oSection1:PrintLine()
		oSection1:Finish()
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDesabilita o cabe็alho da se็ใo de parametros, para imprimir somente naณ
//ณprimeira pagina.                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oSection1:SetHeaderSection( .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณInicializa impressao da se็ใo do relatorio.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oSection2:Init()
For i := 1 To Len( aCols )
	If oReport:Cancel()
		Exit
	EndIf
	oReport:IncMeter()
	For j := 1 To Len( oSection2:aCell )
		xValue := GdFieldGet( oSection2:aCell[ j ]:cName , i )
		If !Empty( oSection2:aCell[ j ]:aCBox ) .And. !Empty( xValue )
			If ( nPos := Ascan( oSection2:aCell[ j ]:aCBox , { | x | x[ 1 ] == xValue } ) ) > 0
				oSection2:aCell[ j ]:nSize := Len( oSection2:aCell[ j ]:aCBox[ nPos ][ 2 ] )
				oSection2:Cell( oSection2:aCell[ j ]:cName ):SetValue( oSection2:aCell[ j ]:aCBox[ nPos ][ 2 ] )
			EndIf
		Else
			oSection2:Cell( oSection2:aCell[ j ]:cName ):SetValue( xValue )
			
		EndIf
	Next
	oSection2:PrintLine()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณQuando imprimir em planilha, mostrar o cabe็alho somente uma vez.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lExcel .And. i = 1
		oSection2:SetHeaderSection( .F. )
	EndIf
Next
oSection2:Finish()

Return

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fValCon   | Autor: Celso Ferrone Martins  | Data: 11/03/2015 |||
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

Static Function fValCon(lTroca)

Local lRet := .T.
Default lTroca := .F.

lEditVend := .F.
lEditComp := .F.
lEdit     := .F.

If lTroca
	aCTipo    := {}
	OCTipo:aItems := {}
	oCTipo:nAt    := 0
	
	aCTpImp  := {}
	oCTpImp:aItems := {}
	oCTpImp:nAt := 0
EndIf

lEditVend := .T.
lEdit     := .T.


OCTipo:Refresh()
oCTpImp:Refresh()

Return(lRet)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_getVended บAutor ณDanilo A. Del Busso บ Data ณ  23/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o codigo de vendedor do usuario que esta acessando บฑฑ
ฑฑบ          ณ a rotina, isso se for um vendedor.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP Transformar em funcao de usuario - devido a prazo apert บฑฑ
ฑฑบUso       ณ ado para entrega, criei ela static (errado)                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _getVended(_cUsuario)
Local _cRet := ""

DbSelectArea("SA3"); DbSetOrder(7)

If (SA3->(Dbseek(xFilial("SA3")+_cUsuario)))
	_cRet := SA3->A3_COD	
EndIf

Return _cRet


Static Function getGrpRegV(_cCodVend)
Local _aRet := {}

DbSelectArea("Z12"); DbSetOrder(1)

If !Empty(_cCodVend)
	If (Z12->(Dbseek(xFilial("Z12")+_cCodVend)))     
		While !Z12->(EoF())
			If (_cCodVend = Z12->Z12_COD)  
				nPos := aScan(_aRet,{|x|x == Z12->(Z12_REGIAO+CVALTOCHAR(Z12_GRUPO))}) 
				If (nPos = 0) 
					aadd(_aRet, Z12->(Z12_REGIAO+CVALTOCHAR(Z12_GRUPO)) )  
					_cGrpReg += "'" + Z12->(Z12_REGIAO+CVALTOCHAR(Z12_GRUPO)) + "',"
				EndIf
			EndIf
			Z12->(DbSkip())
		EndDo	
	EndIf
EndIf	 
_cGrpReg := SUBSTR(_cGrpReg, 1, Len(_cGrpReg) -1 )
Return _aRet
