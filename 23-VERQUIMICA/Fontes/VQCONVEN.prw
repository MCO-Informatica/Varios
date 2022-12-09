#Include "TopConn.ch"
#Include "Protheus.ch"
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


User Function VQCONVEN()   

Local aSize, aObjects, aInfo

Local bOk      := {|| oDialog:End()}
Local bCancel  := {|| oDialog:End()}
Local cTitle   := "Consulta de Vendas"
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
Private _cUsrLibA	 := _cUsuario $ GetMv("VQ_CONVEN") // Usuarios que podem Visualizar todos os clientes, por consequencia liberei tudo na tela. 
Private _cGrpReg 	 := ""
Private _aGrpRegV	 := getGrpRegV(_cCodVend)                                      

//Local _aFilVenR	 := essa vai ser responsavel por retornar os vendedores da mesma regiao 


Private cEof := Chr(13) + Chr(10)                                                           

Private oDialog
Private aPosObj

Private oGetDados
Private aHeader := {}
Private aCols   := {}


// Filtro
Private oGDatDe
Private dGDatDe := FirstDay(dDataBase)

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

Private oGCodFor
Private cGCodFor := CriaVar("A2_COD", .F.)
Private oGLojFor
Private cGLojFor := CriaVar("A2_LOJA", .F.)
Private oGNomFor
Private cGNomFor

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

Private oPesqu
Private cPesqu
Private aPesqu := IIF(EMPTY(_cCodVend) .OR. _cUsrLibA,{"Vendas","Compras" },{"Vendas"}) //Vendedores s๓ podem enxergar Vendas

Private oCTipo
Private cCTipo
Private aCTipo := {}
Private aTipoV := { "Produto", "Grupo" , "Vendedor" , "Cliente" , "Regiao" , "Divisao", "Transportadora", "Por Nota Fiscal" }
Private aTipoC := { "Produto", "Grupo" , "Fornecedor" , "Por Nota Fiscal" }

Private oBFiltro
Private lEdit     := .F.
Private lEditPesq := .T.
Private lEditVend := .F.
Private lEditComp := .F.

// Totais

Private oLTot1
Private nLTot1 := 0

Private oLTot2
Private nLTot2 := 0

Private oLTot3
Private nLTot3 := 0

Private oLTot4
Private nLTot4 := 0

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

Define MsDialog oDialog Title cTitle From aSize[7], 0 To aSize[6], aSize[5] Of oMainWnd Pixel

@ aPosObj[1][1], aPosObj[1][2] To aPosObj[1][3]+28, aPosObj[1][4] Prompt "Filtro" Of oDialog Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+004 Say "Pesquisa" Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+032 ComboBox oPesqu Var cPesqu Items aPesqu Valid fValCon(.T.) Size 40, 50 When lEditPesq Of oDialog Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+077 Say "Data de" Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+101 MSGet oGDatDe Var dGDatDe VALID !Vazio() Size 45, 09 Picture "@D" When lEdit Of oDialog Pixel 	
@ aPosObj[1][1]+10, aPosObj[1][2]+150 Say "at้" Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+163 MSGet oGDatAte Var dGDatAte VALID !Vazio() Size 45, 09 Picture "@D" When lEdit Of oDialog Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+215 Say "Produto" Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+243 MSGet oGCodPrd Var cGCodPrd Valid Iif(Vazio() .or. ExistCpo("SB1", cGCodPrd, 1), (cGNomPrd := GetAdvFVal("SB1","B1_DESC",XFILIAL("SB1")+cGCodPrd,1,""),.T.),.F.) Size 30, 09 F3 "SB1" When lEdit Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+278 MSGet oGNomPrd Var cGNomPrd Size 100, 09 When .F. Of oDialog Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+383 Say "Grupo" Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+403 MSGet oGCodGrp Var cGCodGrp Valid Iif(Vazio() .or. ExistCpo("SBM", cGCodGrp, 1), (cGNomGrp := GetAdvFVal("SBM","BM_DESC",XFILIAL("SBM")+cGCodGrp,1,""),.T.),.F.) Size 30, 09 F3 "SBM" When lEdit Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+438 MSGet oGNomGrp Var cGNomGrp Size 70, 09 When .F. Of oDialog Pixel

@ aPosObj[1][1]+25, aPosObj[1][2]+004 Say "Cliente" Of oDialog Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+032 MSGet oGCodCli Var cGCodCli Valid Iif(Vazio() .or. ExistCpo("SA1", cGCodCli, 1), (cGNomCli := GetAdvFVal("SA1","A1_NOME",XFILIAL("SA1")+cGCodCli,1,""),.T.),.F.) Size 30, 09 F3 "SA1" When lEditVend Of oDialog Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+067 MSGet oGLojCli Var cGLojCli Size 008, 09 When lEditVend Of oDialog Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+084 MSGet oGNomCli Var cGNomCli Size 120, 09 When .F. Of oDialog Pixel

@ aPosObj[1][1]+25, aPosObj[1][2]+215 Say "Regiao" Of oDialog Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+243 MSGet oGCodReg Var cGCodReg Valid Iif(Vazio() .or. ExistCpo("Z06", cGCodReg, 1), (cGNomReg := GetAdvFVal("Z06","Z06_DESCRI",XFILIAL("Z06")+cGCodReg,1,""),.T.),.F.) Size 30, 09 F3 "Z06" When lEditVend Of oDialog Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+278 MSGet oGNomReg Var cGNomReg Size 100, 09 When .F. Of oDialog Pixel                                                                                                                                                      

@ aPosObj[1][1]+25, aPosObj[1][2]+383 Say "Divisao" Of oDialog Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+403 MSGet oGCodZon Var cGCodZon Valid Iif(Vazio() .or. ExistCpo("ACY", cGCodZon, 1), (cGNomZon := GetAdvFVal("ACY","ACY_DESCRI",XFILIAL("ACY")+cGCodZon,1,""),.T.),.F.) Size 30, 09 F3 "ACY" When lEditVend Of oDialog Pixel
@ aPosObj[1][1]+23, aPosObj[1][2]+438 MSGet oGNomZon Var cGNomZon Size 70, 09 When .F. Of oDialog Pixel

@ aPosObj[1][1]+40, aPosObj[1][2]+004 Say "Transp." Of oDialog Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+032 MSGet oGCodTra Var cGCodTra Valid Iif(Vazio() .or. ExistCpo("SA4", cGCodTra, 1), (cGNomTra := GetAdvFVal("SA4","A4_NOME",XFILIAL("SA4")+cGCodTra,1,""),.T.),.F.) Size 30, 09 F3 "SA4" When lEditVend Of oDialog Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+067 MSGet oGNomTra Var cGNomTra Size 137, 09 When .F. Of oDialog Pixel

@ aPosObj[1][1]+40, aPosObj[1][2]+215 Say "Vendedor" Of oDialog Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+243 MSGet oGCodVen Var cGCodVen Valid Iif(Vazio() .or. ExistCpo("SA3", cGCodVen, 1), (cGNomVen := GetAdvFVal("SA3","A3_NOME",XFILIAL("SA3")+cGCodVen,1,""),.T.),.F.) Size 30, 09 F3 "SA3" When lEditVend Of oDialog Pixel
@ aPosObj[1][1]+38, aPosObj[1][2]+278 MSGet oGNomVen Var cGNomVen Size 100, 09 When .F. Of oDialog Pixel

@ aPosObj[1][1]+55, aPosObj[1][2]+004 Say "Fornec." Of oDialog Pixel
@ aPosObj[1][1]+53, aPosObj[1][2]+032 MSGet oGCodFor Var cGCodFor Valid Iif(Vazio() .or. ExistCpo("SA2", cGCodFor, 1), (cGNomFor := GetAdvFVal("SA2","A2_NOME",XFILIAL("SA2")+cGCodFor,1,""),.T.),.F.) Size 30, 09 F3 "SA2" When lEditComp Of oDialog Pixel
@ aPosObj[1][1]+53, aPosObj[1][2]+067 MSGet oGLojFor Var cGLojFor Size 008, 09 When lEditComp Of oDialog Pixel
@ aPosObj[1][1]+53, aPosObj[1][2]+084 MSGet oGNomFor Var cGNomFor Size 120, 09 When .F.   Of oDialog Pixel

@ aPosObj[1][1]+55, aPosObj[1][2]+383 Say "Tipo" Of oDialog Pixel
@ aPosObj[1][1]+53, aPosObj[1][2]+403 ComboBox oCTipo Var cCTipo Items aCTipo Size 40, 60 When lEdit Of oDialog Pixel

@ aPosObj[1][1]+53, aPosObj[1][2]+458 Button oBFiltro Prompt "Filtrar" Size 42, 11 Action BtnFiltro() Of oDialog Pixel

oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDialog, aHeader, aCols)

oGetDados:lInsert := .F.
oGetDados:lDelete := .F.
oGetDados:lUpdate := .F.

nBoxSize := (aPosObj[3][4]-aPosObj[3][2])/11


@ aPosObj[3][1], aPosObj[3][2]  To aPosObj[3][3], nBoxSize-1      Prompt "Quant KG Total" Of oDialog Pixel
@ aPosObj[3][1],  nBoxSize+1    To aPosObj[3][3], (nBoxSize*2)-1  Prompt "Quant LT Total" Of oDialog Pixel
@ aPosObj[3][1], (nBoxSize*2)+1 To aPosObj[3][3], (nBoxSize*3)-1  Prompt "Valor Total R$" Of oDialog Pixel
@ aPosObj[3][1], (nBoxSize*3)+1 To aPosObj[3][3], (nBoxSize*4)-1  Prompt "Valor Total U$" Of oDialog Pixel
@ aPosObj[3][1], (nBoxSize*4)+1 To aPosObj[3][3], (nBoxSize*5)-1  Prompt "Qtd.Registros"  Of oDialog Pixel

@ aPosObj[3][1]+9, (nBoxSize-1)-42  Say oLTot1	  Var nLTot1    Picture "@E 9,999,999,999.99" 	Right Size 40, 17 Of oDialog Pixel
@ aPosObj[3][1]+9, (nBoxSize*2)-43  Say oLTot2    Var nLTot2    Picture "@E 9,999,999,999.99"  	Right Size 40, 17 Of oDialog Pixel
@ aPosObj[3][1]+9, (nBoxSize*3)-43  Say oLTot3 	  Var nLTot3    Picture "@E 9,999,999,999.99"  	Right Size 40, 17 Of oDialog Pixel
@ aPosObj[3][1]+9, (nBoxSize*4)-43  Say oLTot4    Var nLTot4    Picture "@E 9,999,999,999.99"  	Right Size 40, 17 Of oDialog Pixel
@ aPosObj[3][1]+9, (nBoxSize*5)-43  Say oQtdReg   Var nQtdReg   Picture "@E 9,999,999,999"  	Right Size 40, 17 Of oDialog Pixel
         

If (!_cUsrLibA)    
	
   //	U_CFMFILSA1() 
   U_DBFILSA1()
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
		DbSelectArea("Z06");DbSetOrder(1)
		Set Filter To &(_cFilZ06)
	EndIf

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
		DbSelectArea("ACY"); DbSetOrder(1)
		Set Filter To &(_cFilACY)
	EndIf
EndIf

fValCon(.T.)         

Activate MsDialog oDialog On Init (EnchoiceBar(oDialog,{||lOk:=.T.,oDialog:End()},{||oDialog:End()},,@aButtons))

Return()       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_getVended บAutor ณDanilo A. Del Busso บ Data ณ  23/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o codigo de vendedor do usuario que esta acessando บฑฑ
ฑฑบ          ณ a rotina, isso se for um vendedor.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_getRegV บAutor ณDanilo A. Del Busso บ Data ณ  23/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as regioes de vendas do usuario que esta acessando บฑฑ
ฑฑบ          ณ a rotina, isso se for um vendedor.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetono    ณ Recebe um codigo de vendedor e retorna um ARRAY            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _getRegV(_cCodVend)
Local _aRet := {}

DbSelectArea("Z12"); DbSetOrder(1)

If !Empty(_cCodVend)
	If (Z12->(Dbseek(xFilial("Z12")+_cCodVend)))     
		While !Z12->(EoF())
			If (_cCodVend = Z12->Z12_COD)  
				nPos := aScan(_aRet,{|x|x == Z12->Z12_REGIAO}) 
				If (nPos = 0) 
					aadd(_aRet, Z12->Z12_REGIAO )  
					_cFilRegV += "'" + Z12->Z12_REGIAO + "',"
				EndIf
			EndIf
			Z12->(DbSkip())
		EndDo	
	EndIf
EndIf	 
_cFilRegV := SUBSTR(_cFilRegV, 1, Len(_cFilRegV) -1 )
Return _aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_getGrpV บAutor ณDanilo A. Del Busso บ Data ณ  23/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as grupos de vendas do usuario que esta acessando  บฑฑ
ฑฑบ          ณ a rotina, isso se for um vendedor.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorna   ณ Recebe codigo vendedor e retorna ARRAY com as Divisoes     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _getGrpV(_cCodVend)
Local _aRet := {}

DbSelectArea("Z12"); DbSetOrder(1)

If !Empty(_cCodVend)
	If (Z12->(Dbseek(xFilial("Z12")+_cCodVend)))     
		While !Z12->(EoF())
			If (_cCodVend = Z12->Z12_COD)  
				nPos := aScan(_aRet,{|x|x == Z12->Z12_GRUPO})
				If (nPos = 0) 
					aadd(_aRet, Z12->Z12_GRUPO )   
					_cFilGrpV += "'" + Z12->Z12_GRUPO + "',"
				EndIf
			EndIf
			Z12->(DbSkip())
		EndDo	
	EndIf
EndIf	     
_cFilGrpV := SUBSTR(_cFilGrpV, 1, Len(_cFilGrpV) -1 )
Return _aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_getVenR บAutor ณDanilo A. Del Busso   บ Data ณ  24/03/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os Vendedores da regiao de vendas do usuario       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorna   ณRecebe um ARRAY com os dados das regioes e retorna ARRAY comบฑฑ
ฑฑบ			 ณ os vendedores das regioes pesquisadas                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    
User Function _getVenR(_aFilVenR)
Local _aRet := {}




Return(_aRet)


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

If Empty(cPesqu)
	MsgAlert("Selecione um tipo de pesquisa","Vendas ou Compras?")
	Return()
EndIf       

_nMeses := DateDiffMonth(  dGDatAte, dGDatDe )
  

//If _nMeses > 11 
//	MsgAlert("O periodo do relatorio nao pode ser maior que o de 12 meses","Periodo Maior de 12 meses")
//	Return()
//EndIf


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

If !Empty(cGCodFor) .Or. !Empty(cGLojFor)
	DbSelectArea("SA2") ; DbSetOrder(1)
	If !SA2->(DbSeek(xFilial("SA2")+cGCodFor+cGLojFor))
		MsgAlert("Fornecedor nao encontrado. Verifique se o codigo e loja estao corretos","Cadastro Nao Encontrado?")
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
		
		oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDialog, aHeader, aCols)
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
		nQtdReg := 0
		
		oLTot1:Refresh()
		oLTot2:Refresh()
		oLTot3:Refresh()
		oLTot4:Refresh()
		oQtdReg:Refresh()
		
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
Next nX

aAdd(aTmpTotal,aClone(oGetDados:ACOLS[nPosTos]))

oGetDados:ACOLS := aClone(aTmpCols)

If cOrdAnt == "C"
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] < y[col]})
Else
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] > y[col]})
EndIf

aAdd(oGetDados:ACOLS,aClone(aTmpTotal[1]))

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
Local _cQryCod := "" 
Local _cQryWhe := ""   
Local _lGrpWhe  := .F.
Local _cQryDes := ""

Private	_cQryCod := "  "
Private	_cQryDes := "  "

nOpTipo := aScan( aCTipo, cCTipo)

aHeader := {}


If cPesqu == "Vendas"
	//aTipoV := { "Produto","Grupo" , "Vendedor" , "Cliente" , "Regiao" , "Divisao", "Transportadora", "Por Nota Fiscal" }

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
		
		_cQryCod := " REGIAO "   
		If !Empty(cGCodReg) 
			_cQryWhe := " WHERE REGIAO IN ('"+cGCodReg+"')"  
			_lGrpWhe := .T.
		Else    
			If !Empty( _cFilRegV ) .AND. !_cUsrLibA                                         
				_cQryWhe := " WHERE REGIAO IN ("+_cFilRegV+")"   
				_lGrpWhe := .T.
			EndIf
		EndIf
		
		_cQryDes := " NOME_REG "
		
	ElseIf nOpTipo == 6 // Por Zona
		_cCod    := "Divisao"
		_cDesc   := "Descricao"
		_nTGrp   := TamSX3("ACY_DESCRI")[1]
		_cPicCod := PesqPict("ACY","ACY_GRPVEN",15)
		_cPicDes := PesqPict("ACY","ACY_DESCRI",_nTGrp)
		
		_cQryCod := " GRUPO_VE " 
	    If !Empty(cGCodZon) 
	   		_cQryWhe := " WHERE GRUPO_VE IN ('"+cGCodZon+"')" 
	   		_lGrpWhe := .T.
		Else   
			If !Empty( _cFilGrpV ) .AND. !_cUsrLibA
				_cQryWhe := "WHERE GRUPO_VE IN ("+_cFilGrpV+")"  
				_lGrpWhe := .T.                                  
			EndIf
		EndIf
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
Else
	//aTipoC := { "Produto","Grupo" , "Fornecedor" , "Por Nota Fiscal" }

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
		
	ElseIf nOpTipo == 3 // Por Cliente
		_cCod    := "Fornecedor"
		_cDesc   := "Nome"
		_nTGrp   := TamSX3("A2_NOME")[1]
		_cPicCod := PesqPict("SA2","A2_COD",15)
		_cPicDes := PesqPict("SA2","A2_NOME",_nTGrp)
		
		_cQryCod := " FORNECE, LOJA "
		_cQryDes := " NOME_FOR "
/*
	ElseIf nOpTipo == 4 // Transportadora
		_cCod    := "Transportadora"
		_cDesc   := "Nome"
		_nTGrp   := TamSX3("A4_NOME")[1]
		_cPicCod := PesqPict("SA4","A4_COD",15)
		_cPicDes := PesqPict("SA4","A4_NOME",_nTGrp)
	
		_cQryCod := " TRANSP "
		_cQryDes := " NOME_TRA "
*/
	ElseIf nOpTipo == 4 // Por Nota
		_cCod    := "Nota.Fiscal"
		_cDesc   := "Descricao"
		_nTGrp   := TamSX3("F1_SERIE")[1]
		_cPicCod := PesqPict("SF1","F1_DOC",15)
		_cPicDes := PesqPict("SF1","F1_SERIE",_nTGrp)
		
		_cQryCod := " DOC "
		_cQryDes := " SERIE "

	EndIf
EndIf

Aadd(aHeader,{_cCod	   ,_cCod    		,_cPicCod,15    ,0,"",USADO,"C",,""})
Aadd(aHeader,{_cDesc   ,_cDesc   		,_cPicDes,_nTGrp,0,"",USADO,"C",,""})

Aadd(aHeader,{"Qtde KG"       ,"QTDTN" 		,PesqPict("SD2","D2_TOTAL",14),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Qtde L"        ,"QTDL"  		,PesqPict("SD2","D2_TOTAL",14),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Valor R$"      ,"VLRRS" 		,PesqPict("SD2","D2_TOTAL",14),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Valor U$"      ,"VLRUS" 		,PesqPict("SD2","D2_TOTAL",14),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Pre็o Medio R$","PRCMEDRS" 	,PesqPict("SD2","D2_TOTAL",14),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Pre็o Medio U$","PRCMEDUS" 	,PesqPict("SD2","D2_TOTAL",14),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Qtde.Registos" ,"QTDREG" 	,"@E 9,999,999,999"           ,14,4,"",USADO,"N",,""})

_cQry := " "


_cQry += " SELECT                                                                          " + cEof

_cQry += _cQryCod + ", " + _cQryDes + ",                                                   " + cEof

_cQry += "    ROUND(SUM(QTDVE_KG),2) QTDTOT_KG,                                           " + cEof
_cQry += "    ROUND(SUM(QTDVE_LT),2) QTDTOT_LT,                                           " + cEof
_cQry += "    ROUND(SUM(TOTVE_RE),2) TOTTOT_RE,                                           " + cEof
_cQry += "    ROUND(SUM(TOTVE_DO),2) TOTTOT_DO,                                           " + cEof
_cQry += "    ROUND(SUM(CONTADOR),2) QTDREG2  ,                                           " + cEof
_cQry += "    COUNT(*)               QTDREG                                               " + cEof
_cQry += " FROM (                                                                         " + cEof

/*
|||||||||||||||||||||||||||||||||||||||||||||||
||+-----------------------------------------+||
||| * * * * * * QUERY DE VENDAS * * * * * * |||
||+-----------------------------------------+||
||| * * * * * * * * INICIO* * * * * * * * * |||
||+-----------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||
*/
If cPesqu == "Vendas"
	
	_cQry += "    SELECT                                                                       " + cEof
	_cQry += "      SD2.D2_ITEM                                                    ITEMNF   ,  " + cEof
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
	_cQry += "      SB1.B1_CONV                                                    DENSIDAD ,  " + cEof
	_cQry += "      SD2.D2_TES                                                     TES      ,  " + cEof
	_cQry += "      SD2.D2_QUANT                                                   QTDVE_KG ,  " + cEof
	_cQry += "      SD2.D2_QTSEGUM                                                 QTDVE_LT ,  " + cEof
	_cQry += "      SD2.D2_PRCVEN                                                  PRCVE_KG ,  " + cEof
	_cQry += "      SD2.D2_TOTAL                                                   TOTVE_RE ,  " + cEof
	_cQry += "      ROUND(SD2.D2_TOTAL / SM2.M2_MOEDA2,2)                          TOTVE_DO ,  " + cEof
	_cQry += "      SM2.M2_MOEDA2                                                  MOEDA2   ,  " + cEof
	_cQry += "      1                                                              CONTADOR    " + cEof
	_cQry += "    FROM " + RetSqlName("SF2") + " SF2                                           " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SA1") + " SA1 ON                                " + cEof
	_cQry += "        SA1.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'                             " + cEof
	_cQry += "        AND SA1.A1_COD    = SF2.F2_CLIENTE                                       " + cEof
	_cQry += "        AND SA1.A1_LOJA   = SF2.F2_LOJA                                          " + cEof
//	_cQry += "      LEFT  JOIN " + RetSqlName("Z06") + " Z06 ON                                " + cEof
	If !Empty(cGCodReg)
		_cQryJoin := "INNER"
	Else
		_cQryJoin := "LEFT "
	EndIf	
	_cQry += "      "+_cQryJoin+" JOIN " + RetSqlName("Z06") + " Z06 ON                        " + cEof
	_cQry += "        Z06.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND Z06.Z06_FILIAL = '" + xFilial("Z06") + "'                            " + cEof
	_cQry += "        AND Z06.Z06_CODIGO = SF2.F2_REGIAO                                      " + cEof
	  /*DANILO BUSSO INICIO 01/09/2016 */
	If !Empty(cGCodZon)
		_cQry += "      INNER  JOIN " + RetSqlName("ACY") + " ACY ON                                " + cEof	
	Else
		_cQry += "      LEFT  JOIN " + RetSqlName("ACY") + " ACY ON                                " + cEof
	EndIf 
	/*DANILO BUSSO FIM*/   
	_cQry += "        ACY.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'                            " + cEof
	_cQry += "        AND ACY.ACY_GRPVEN = SF2.F2_GRPVEN                                       " + cEof	
	_cQry += "      LEFT JOIN " + RetSqlName("SA3") + " SA3 ON                                " + cEof
	_cQry += "        SA3.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'                             " + cEof
	_cQry += "        AND SA3.A3_COD    = SF2.F2_VEND1                                         " + cEof
	_cQry += "      LEFT  JOIN " + RetSqlName("SA4") + " SA4 ON                                " + cEof
	_cQry += "        SA4.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'                             " + cEof
	_cQry += "        AND SA4.A4_COD    = SF2.F2_TRANSP                                         " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SD2") + " SD2 ON                                " + cEof
	_cQry += "        SD2.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'                             " + cEof
	_cQry += "        AND SD2.D2_DOC    = SF2.F2_DOC                                           " + cEof
	_cQry += "        AND SD2.D2_SERIE  = SF2.F2_SERIE                                         " + cEof
	_cQry += "        AND SD2.D2_EMISSAO BETWEEN '"+DTOS(dGDatDe)+"' AND '"+DTOS(dGDatAte)+"'  " + cEof
	If !Empty(cGCodGrp)
		_cQry += "      AND SD2.D2_GRUPO = '"+cGCodGrp+"'                                      " + cEof
	EndIf
	If !Empty(cGCodPrd)
		_cQry += "      AND SD2.D2_COD   = '"+cGCodPrd+"'                                      " + cEof
	EndIf	
	_cQry += "      INNER JOIN " + RetSqlName("SB1") + " SB1 ON                                " + cEof
	_cQry += "        SB1.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'                             " + cEof
	_cQry += "        AND SB1.B1_COD    = SD2.D2_COD                                           " + cEof
	_cQry += "        AND SB1.B1_GRUPO NOT IN ('4000','5000')                              " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SBM") + " SBM ON                                " + cEof
	_cQry += "        SBM.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'                             " + cEof
	_cQry += "        AND SBM.BM_GRUPO  = SB1.B1_GRUPO                                         " + cEof	
	_cQry += "      INNER JOIN " + RetSqlName("SF4") + " SF4 ON                                " + cEof
	_cQry += "        SF4.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'                             " + cEof
	_cQry += "        AND SF4.F4_CODIGO = SD2.D2_TES                                           " + cEof
	_cQry += "        AND SF4.F4_DUPLIC = 'S'                                                  " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SM2") + " SM2 ON                                " + cEof
	_cQry += "        SM2.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND M2_DATA = F2_EMISSAO                                                 " + cEof
	_cQry += "    WHERE                                                                        " + cEof
	_cQry += "      SF2.D_E_L_E_T_ <> '*'                                                      " + cEof
	_cQry += "      AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'                               " + cEof
	_cQry += "      AND SF2.F2_TIPO   IN ('N','C')                                             " + cEof   
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
	If !Empty(cGCodVen)
		_cQry += "      AND SF2.F2_VEND1 = '"+cGCodVen+"'                                      " + cEof
	EndIf
	If !Empty(cGCodCli) .And. !Empty(cGLojCli)
		_cQry += "      AND SF2.F2_CLIENTE = '"+cGCodCli+"'                                      " + cEof
		_cQry += "      AND SF2.F2_LOJA    = '"+cGLojCli+"'                                      " + cEof
	EndIf
	If !Empty(cGCodTra)
		_cQry += "      AND SF2.F2_TRANSP = '"+cGCodTra+"'                                      " + cEof
	EndIf	
	_cQry += "    UNION ALL                                                                    " + cEof
	_cQry += "    SELECT  DISTINCT                                                            " + cEof
	_cQry += "      SD2.D2_ITEM                                                    ITEMNF  ,  " + cEof
	_cQry += "      SF2.F2_DOC                                                     DOC     ,  " + cEof
	_cQry += "      SF2.F2_SERIE                                                   SERIE   ,  " + cEof
	_cQry += "      SF2.F2_CLIENTE                                                 CLIENTE ,  " + cEof
	_cQry += "      SF2.F2_LOJA                                                    LOJA    ,  " + cEof
	_cQry += "      SA1.A1_NOME                                                    NOME_CLI,  " + cEof
	_cQry += "      SF2.F2_REGIAO                                                  REGIAO  ,  " + cEof
	_cQry += "      COALESCE(Z06.Z06_DESCRI,' ')                                   NOME_REG,  " + cEof
	_cQry += "      SF2.F2_GRPVEN                                                  GRUPO_VE,  " + cEof
	_cQry += "      COALESCE(ACY.ACY_DESCRI,' ')                                   NOME_ZON,  " + cEof
	_cQry += "      COALESCE(SA4.A4_COD    ,' ')                                   TRANSP  ,  " + cEof
	_cQry += "      COALESCE(SA4.A4_NOME   ,' ')                                   NOME_TRA,  " + cEof
	_cQry += "      SF2.F2_EMISSAO                                                 EMISSAO ,  " + cEof
	_cQry += "      SF2.F2_VEND1                                                   VENDEDOR,  " + cEof
	_cQry += "      SA3.A3_NOME                                                    NOME_VEN,  " + cEof
	_cQry += "      SBM.BM_GRUPO                                                   GRUPO   ,  " + cEof
	_cQry += "      SBM.BM_DESC                   	                               DESC_GRP,  " + cEof
	_cQry += "      SD2.D2_COD                                                     PRODUTO  ,  " + cEof
	_cQry += "      SB1.B1_DESC                                                    DESC_PRD ,  " + cEof
	_cQry += "      SB1.B1_CONV                                                    DENSIDAD ,  " + cEof
	_cQry += "      SD2.D2_TES                                                     TES      ,  " + cEof
	_cQry += "      (SD1.D1_QUANT                         )*-1                     QTDVE_KG ,  " + cEof
	_cQry += "      (SD1.D1_QTSEGUM                       )*-1                     QTDVE_LT ,  " + cEof
	_cQry += "      (SD1.D1_VUNIT                         )*-1                     PRCVE_KG ,  " + cEof
	_cQry += "      ((SD1.D1_TOTAL-SD1.D1_VALDESC)        )*-1                     TOTVE_RE ,  " + cEof
	_cQry += "      (ROUND(SD1.D1_TOTAL / SM2.M2_MOEDA2,2))*-1                     TOTVE_DO ,  " + cEof
	_cQry += "      SM2.M2_MOEDA2                                                  MOEDA2   ,  " + cEof
	_cQry += "      -1                                                             CONTADOR    " + cEof

	_cQry += "    FROM " + RetSqlName("SF2") + " SF2                                           " + cEof
	
	_cQry += "      INNER JOIN " + RetSqlName("SA1") + " SA1 ON                                " + cEof
	_cQry += "        SA1.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'                             " + cEof
	_cQry += "        AND SA1.A1_COD    = SF2.F2_CLIENTE                                       " + cEof
	_cQry += "        AND SA1.A1_LOJA   = SF2.F2_LOJA                                          " + cEof
	
//	_cQry += "      LEFT  JOIN " + RetSqlName("Z06") + " Z06 ON                                " + cEof
	If !Empty(cGCodReg)
		_cQryJoin := "INNER"
	Else
		_cQryJoin := "LEFT "
	EndIf	
	_cQry += "      "+_cQryJoin+" JOIN " + RetSqlName("Z06") + " Z06 ON                        " + cEof
	_cQry += "        Z06.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND Z06.Z06_FILIAL = '" + xFilial("Z06") + "'                            " + cEof
	_cQry += "        AND Z06.Z06_CODIGO = SF2.F2_REGIAO                                       " + cEof
	If !Empty(cGCodZon)
		_cQry += "      INNER  JOIN " + RetSqlName("ACY") + " ACY ON                             " + cEof	
	Else
		_cQry += "      LEFT  JOIN " + RetSqlName("ACY") + " ACY ON                              " + cEof
	EndIf
	_cQry += "        ACY.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'                            " + cEof
	_cQry += "        AND ACY.ACY_GRPVEN = SF2.F2_GRPVEN                                    " + cEof	
	_cQry += "      LEFT JOIN " + RetSqlName("SA3") + " SA3 ON                                " + cEof
	_cQry += "        SA3.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'                             " + cEof
	_cQry += "        AND SA3.A3_COD    = SF2.F2_VEND1                                         " + cEof
	_cQry += "      LEFT  JOIN " + RetSqlName("SA4") + " SA4 ON                                " + cEof
	_cQry += "        SA4.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'                             " + cEof
	_cQry += "        AND SA4.A4_COD    = SF2.F2_TRANSP                                         " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SD2") + " SD2 ON                                " + cEof
	_cQry += "        SD2.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'                             " + cEof
	_cQry += "        AND SD2.D2_DOC    = SF2.F2_DOC                                           " + cEof
	_cQry += "        AND SD2.D2_SERIE  = SF2.F2_SERIE                                         " + cEof
	If !Empty(cGCodGrp)
		_cQry += "      AND SD2.D2_GRUPO = '"+cGCodGrp+"'                                      " + cEof
	EndIf
	If !Empty(cGCodPrd)
		_cQry += "      AND SD2.D2_COD   = '"+cGCodPrd+"'                                      " + cEof
	EndIf
	_cQry += "      INNER JOIN " + RetSqlName("SB1") + " SB1 ON                                " + cEof
	_cQry += "        SB1.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'                             " + cEof
	_cQry += "        AND SB1.B1_COD    = SD2.D2_COD                                           " + cEof
	_cQry += "        AND SB1.B1_GRUPO NOT IN ('4000','5000')                                  " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SBM") + " SBM ON                                " + cEof
	_cQry += "        SBM.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'                             " + cEof
	_cQry += "        AND SBM.BM_GRUPO  = SB1.B1_GRUPO                                         " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SF4") + " SF4 ON                                " + cEof
	_cQry += "        SF4.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'                             " + cEof
	_cQry += "        AND SF4.F4_CODIGO = SD2.D2_TES                                           " + cEof
	_cQry += "        AND SF4.F4_DUPLIC = 'S'                                                  " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SM2") + " SM2 ON                                " + cEof
	_cQry += "        SM2.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND M2_DATA = F2_EMISSAO                                                 " + cEof
	_cQry += "      INNER JOIN " + RetSqlName("SD1") + " SD1 ON                                " + cEof
	_cQry += "        SD1.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "'                            " + cEof
	_cQry += "        AND SD1.D1_NFORI   = SD2.D2_DOC                                          " + cEof
	_cQry += "        AND SD1.D1_SERIORI = SD2.D2_SERIE                                        " + cEof
	_cQry += "        AND SD1.D1_ITEMORI = SD2.D2_ITEM                                         " + cEof
	_cQry += "        AND SD1.D1_QUANT > 0                                         			   " + cEof // Danilo 03/05/2018 - Solu็ใo Paliativa quando haviam mais de dois itens na saida por causa do Lote, mesmo um ๚nico item na entrada da devolu็ใo duplicava a linha.
	_cQry += "        AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(dGDatDe)+"' AND '"+DTOS(dGDatAte)+"'  " + cEof 
	_cQry += "      INNER JOIN " + RetSqlName("SF1")+ " SF1 ON                                 " + cEof
	_cQry += "        SF1.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "        AND SF1.F1_FILIAL  = '" + xFilial("SF1") + "'                            " + cEof
	_cQry += "        AND SF1.F1_DOC   = SD1.D1_DOC                                            " + cEof	     
	_cQry += "        AND SF1.F1_SERIE = SD1.D1_SERIE										   " + cEof	     
	_cQry += "        AND SF1.F1_STATUS <> ' '                                                 " + cEof		
	_cQry += "    WHERE                                                                        " + cEof
	_cQry += "      SF2.D_E_L_E_T_ <> '*'                                                      " + cEof
	_cQry += "      AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'                               " + cEof
	_cQry += "      AND SF2.F2_TIPO   IN ('N','C')                                             " + cEof 
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
		_cQry += "      AND SF2.F2_REGIAO||SF2.F2_GRPVEN IN ("+_cGrpReg+")	                        " + cEof		
	EndIf       
	
	If !Empty(cGCodVen)
		_cQry += "      AND SF2.F2_VEND1 = '"+cGCodVen+"'                                      		" + cEof
	EndIf
	If !Empty(cGCodCli) .And. !Empty(cGLojCli)                                                                                   	
		_cQry += "      AND SF2.F2_CLIENTE = '"+cGCodCli+"'                                      	" + cEof
		_cQry += "      AND SF2.F2_LOJA    = '"+cGLojCli+"'                                      	" + cEof
	EndIf
	If !Empty(cGCodTra)
		_cQry += "      AND SF2.F2_TRANSP = '"+cGCodTra+"'                                      	" + cEof
	EndIf
	
	/*
	|||||||||||||||||||||||||||||||||||||||||||||||
	||+-----------------------------------------+||
	||| * * * * * * QUERY DE VENDAS * * * * * * |||
	||+-----------------------------------------+||
	||| * * * * * * * * * FIM * * * * * * * * * |||
	||+-----------------------------------------+||
	|||||||||||||||||||||||||||||||||||||||||||||||
	*/
Else
	/*
	|||||||||||||||||||||||||||||||||||||||||||||||
	||+-----------------------------------------+||
	||| * * * * * * QUERY DE COMPRAS * * * * * * |||
	||+-----------------------------------------+||
	||| * * * * * * * * INICIO* * * * * * * * * |||
	||+-----------------------------------------+||
	|||||||||||||||||||||||||||||||||||||||||||||||
	*/
		
	_cQry += "     SELECT
	_cQry += "       SF1.F1_DOC                                                   DOC      ,  " + cEof
	_cQry += "       SF1.F1_SERIE                                                 SERIE    ,  " + cEof
	_cQry += "       SF1.F1_FORNECE                                               FORNECE  ,  " + cEof
	_cQry += "       SF1.F1_LOJA                                                  LOJA     ,  " + cEof
	_cQry += "       SA2.A2_NOME                                                  NOME_FOR ,  " + cEof
	_cQry += "       SF1.F1_EMISSAO                                               EMISSAO  ,  " + cEof
	_cQry += "       SF1.F1_DTDIGIT                                               DTDIGIT  ,  " + cEof
	_cQry += "       SBM.BM_GRUPO                                                 GRUPO    ,  " + cEof
	_cQry += "       SBM.BM_DESC                                                  DESC_GRP ,  " + cEof
	_cQry += "       SD1.D1_COD                                                   PRODUTO  ,  " + cEof
	_cQry += "       SB1.B1_DESC                                                  DESC_PRD ,  " + cEof
	_cQry += "       SB1.B1_CONV                                                  DENSIDAD ,  " + cEof
	_cQry += "       SD1.D1_TES                                                   TES      ,  " + cEof
	_cQry += "       SD1.D1_QUANT                                                 QTDVE_KG ,  " + cEof
	_cQry += "       SD1.D1_QTSEGUM                                               QTDVE_LT ,  " + cEof
	_cQry += "       SD1.D1_VUNIT                                                 PRCVE_KG ,  " + cEof
	_cQry += "       (SD1.D1_TOTAL-SD1.D1_VALDESC)                                TOTVE_RE ,  " + cEof
	_cQry += "       ROUND(SD1.D1_TOTAL / SM2.M2_MOEDA2,2)                        TOTVE_DO ,  " + cEof
	_cQry += "       SM2.M2_MOEDA2                                                MOEDA2   ,  " + cEof
	_cQry += "       1	                                                          CONTADOR    " + cEof
	_cQry += "     FROM "+RetSqlName("SF1")+" SF1                                             " + cEof
	_cQry += "       INNER JOIN "+RetSqlName("SA2")+" SA2 ON                                  " + cEof
	_cQry += "         SA2.D_E_L_E_T_ <> '*'                                                  " + cEof
	_cQry += "         AND SA2.A2_FILIAL = '"+xFilial("SA2")+"'                               " + cEof
	_cQry += "         AND SA2.A2_COD    = SF1.F1_FORNECE                                     " + cEof
	_cQry += "         AND SA2.A2_LOJA   = SF1.F1_LOJA                                        " + cEof
	_cQry += "       INNER JOIN "+RetSqlName("SD1")+" SD1 ON                                  " + cEof
	_cQry += "         SD1.D_E_L_E_T_ <> '*'                                                  " + cEof
	_cQry += "         AND SD1.D1_FILIAL  = '"+xFilial("SF1")+"'                              " + cEof
	_cQry += "         AND SD1.D1_DOC     = SF1.F1_DOC                                        " + cEof
	_cQry += "         AND SD1.D1_SERIE   = SF1.F1_SERIE                                      " + cEof
	_cQry += "         AND SD1.D1_FORNECE = SF1.F1_FORNECE                                    " + cEof
	_cQry += "         AND SD1.D1_LOJA    = SF1.F1_LOJA                                       " + cEof
	If !Empty(cGCodGrp)
		_cQry += "      AND SD1.D1_GRUPO = '"+cGCodGrp+"'                                      " + cEof
	EndIf
	If !Empty(cGCodPrd)
		_cQry += "      AND SD1.D1_COD   = '"+cGCodPrd+"'                                      " + cEof
	EndIf
	_cQry += "       INNER JOIN "+RetSqlName("SB1")+" SB1 ON                                  " + cEof
	_cQry += "         SB1.D_E_L_E_T_ <> '*'                                                  " + cEof
	_cQry += "         AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'                               " + cEof
	_cQry += "         AND SB1.B1_COD    = SD1.D1_COD                                         " + cEof
	_cQry += "       INNER JOIN "+RetSqlName("SBM")+" SBM ON                                  " + cEof
	_cQry += "         SBM.D_E_L_E_T_ <> '*'                                                  " + cEof
	_cQry += "         AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'                               " + cEof
	_cQry += "         AND SBM.BM_GRUPO  = SB1.B1_GRUPO                                       " + cEof
	_cQry += "       INNER JOIN "+RetSqlName("SF4")+" SF4 ON                                  " + cEof
	_cQry += "         SF4.D_E_L_E_T_ <> '*'                                                  " + cEof
	_cQry += "         AND SF4.F4_FILIAL  = '"+xFilial("SF4")+"'                              " + cEof
	_cQry += "         AND SF4.F4_CODIGO  = SD1.D1_TES                                        " + cEof
	_cQry += "         AND SF4.F4_DUPLIC  = 'S'                                               " + cEof
	_cQry += "         AND SF4.F4_ESTOQUE = 'S'                                               " + cEof
	_cQry += "       INNER JOIN "+RetSqlName("SM2")+" SM2 ON                                  " + cEof
	_cQry += "         SM2.D_E_L_E_T_ <> '*'                                                  " + cEof
	_cQry += "         AND SM2.M2_DATA = SF1.F1_DTDIGIT                                       " + cEof
	_cQry += "     WHERE                                                                      " + cEof
	_cQry += "       SF1.D_E_L_E_T_ <> '*'                                                    " + cEof
	_cQry += "       AND SF1.F1_FILIAL = '"+xFilial("SF1")+"'                                 " + cEof
	_cQry += "       AND SF1.F1_TIPO   IN ('N','C')                                           " + cEof
	_cQry += "       AND SF1.F1_DTDIGIT BETWEEN '"+DTOS(dGDatDe)+"' AND '"+DTOS(dGDatAte)+"'  " + cEof
	If !Empty(cGCodFor) .And. !Empty(cGLojFor)
		_cQry += "      AND SF1.F1_FORNECE = '"+cGCodFor+"'                                      " + cEof
		_cQry += "      AND SF1.F1_LOJA    = '"+cGLojFor+"'                                      " + cEof
	EndIf
	
EndIf

/*
|||||||||||||||||||||||||||||||||||||||||||||||
||+-----------------------------------------+||
||| * * * * * * QUERY DE COMPRAS* * * * * * |||
||+-----------------------------------------+||
||| * * * * * * * * * FIM * * * * * * * * * |||
||+-----------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||
*/

_cQry += "    ) TRB                                                                        " + cEof

If _lGrpWhe
	_cQry += _cQryWhe + cEof 
EndIf

_cQry += " GROUP BY " + _cQryCod + ", " + _cQryDes + "                                     " + cEof
_cQry += " ORDER BY " + _cQryCod + ", " + _cQryDes + "                                     " + cEof

If "Administrador"$cUserName .And. !EECVIEW(@_cQry)
	RETURN
EndIf

_cQry := ChangeQuery(_cQry)

TCQUERY _cQry NEW ALIAS "TABTMP"          	


// aCols
aCols := {}
Dbselectarea("TABTMP")
//TABTMP->(dbGoTop())

While TABTMP->(!Eof())
	
	aAdd( aCols, { TABTMP->&(StrTran(_cQryCod,",","+' - '+")) , ;
	TABTMP->&_cQryDes,;
	TABTMP->QTDTOT_KG,;
	TABTMP->QTDTOT_LT,;
	TABTMP->TOTTOT_RE,;
	TABTMP->TOTTOT_DO,;
	ROUND(TABTMP->TOTTOT_RE/TABTMP->QTDTOT_KG,2),;
	ROUND(TABTMP->TOTTOT_DO/TABTMP->QTDTOT_KG,2),;
	TABTMP->QTDREG2,;
	.F. } )
	
	nLTot1  += TABTMP->QTDTOT_KG
	nLTot2  += TABTMP->QTDTOT_LT
	nLTot3  += TABTMP->TOTTOT_RE
	nLTot4  += TABTMP->TOTTOT_DO
    nQtdReg += TABTMP->QTDREG2
	TABTMP->(DbSkip())
EndDo

aAdd( aCols, { "",;
"TOTAL "+UPPER(_cCod) ,;
nLTot1,;
nLTot2,;
nLTot3,;
nLTot4,;
Round(nLTot3/nLTot1,2),;
Round(nLTot4/nLTot1,2),;
nQtdReg,;
.F. } )


oLTot1:Refresh()
oLTot2:Refresh()
oLTot3:Refresh()
oLTot4:Refresh()
oQtdReg:Refresh()


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
LOCAL cDesc1   := "Relatorio de Vendas"

PRIVATE nomeprog := "VQCONVEN"
PRIVATE titulo   := "Relatorio de Vendas - De " + DtoC(dGDatDe) + " a " + DtoC(dGDatAte)
Private aFiltros := {}
  
IF (_cUsrLibA)
	U_ConVenT2( Titulo , cDesc1 , nomeprog , aFiltros )
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
ฑฑบPrograma  ณConVenTRepบAutor  ณMicrosiga           บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Imprime relatorio TReport com base na Acols               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConVenT2( cTitulo , cDescri , cReport , aFilt , aHeaderx , aColsx )

Local   oReport
Local   oSection1
Default cDescri   := ""
Default cReport   := "Relatorio de Vendas"
Default cTitulo   := "Relatorio de Vendas"
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
EndIf

If cPesqu == "Vendas"
	lEditVend := .T.
	lEdit     := .T.
	cGCodFor  := Space(Len(cGCodFor))
	cGLojFor  := Space(Len(cGLojFor))
	cGNomFor  := Space(Len(cGNomFor))
	If lTroca
		aCTipo        := aClone(aTipoV)
		OCTipo:aItems := aClone(aTipoV)
		oCTipo:nAt    := 1
		cCTipo        := aTipoC[1]
	EndIf
EndIf

If cPesqu == "Compras"
	lEditComp := .T.
	lEdit     := .T.
	cGCodCli  := Space(Len(cGCodCli))
	cGLojCli  := Space(Len(cGLojCli))
	cGNomCli  := Space(Len(cGNomCli))
	cGCodVen  := Space(Len(cGCodVen))
	cGNomVen  := Space(Len(cGNomVen))
	cGCodReg  := Space(Len(cGCodReg))
	cGNomReg  := Space(Len(cGNomReg))
	cGCodZon  := Space(Len(cGCodZon))
	cGNomZon  := Space(Len(cGNomZon))
	cGCodTra  := Space(Len(cGCodTra))
	cGNomTra  := Space(Len(cGNomTra))
	If lTroca
		aCTipo        := aClone(aTipoC)
		oCTipo:aItems := aClone(aTipoC)
		oCTipo:nAt    := 1
		cCTipo        := aTipoC[1]
	EndIf
EndIf

OCTipo:Refresh()

Return(lRet)      



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
