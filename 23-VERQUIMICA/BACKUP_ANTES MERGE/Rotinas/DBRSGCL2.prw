#include "Protheus.ch"
#include "TopConn.ch"

User Function DBRSGCL2()

Local aSize, aObjects, aInfo

Local bOk      := {|| oDialog:End()}
Local bCancel  := {|| oDialog:End()}
Local cTitle   := "Consulta de Vendas"
Local oGetdb
Local nBoxSize := 0

Public cCfmFilNew := "" 

Private _cFilRegV	 := ""    //Regioes do vendedor para usar no filtro do SELECT
Private _cFilGrpV    := ""    //Divisoes do vendedor para usar no filtro do SELECT
Private _cUsuario	 := Upper(Alltrim(__cUserID))   // Código do usuário
Private _cCodVend    := _getVended(_cUsuario)       // Código do Vendedor  
Private _aFilRegV	 := U__getRegV(_cCodVend)		// Filtra as regioes de vendas do vendedor
Private _aFilGrpV	 := U__getGrpV(_cCodVend)		// Filtra as grupo de vendas do vendedor  
Private _cUsrLibA	 := _cUsuario $ GetMv("VQ_CONVEN") // Usuarios que podem Visualizar todos os clientes, por consequencia liberei tudo na tela.
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
Private aPesqu := IIF(EMPTY(_cCodVend) .OR. _cUsrLibA,{"Vendas","Compras" },{"Vendas"}) //Vendedores só podem enxergar Vendas

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
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := MsAdvSize( [ ExpL1 ], [ ExpL2 ], [ ExpN1 ] )      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 -> Enchoicebar .T. ou .F.                            ³±±
±±³          ³ ExpL2 -> Retorna janela padrao siga                        ³±±
±±³          ³ ExpN1 -> Tamanho minimo ( altura )                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 -> Dimensoes da janela / area de trabalho            ³±±
±±³          ³     1 -> Linha inicial area trabalho                       ³±±
±±³          ³     2 -> Coluna inicial area trabalho                      ³±±
±±³          ³     3 -> Linha final area trabalho                         ³±±
±±³          ³     4 -> Coluna final area trabalho                        ³±±
±±³          ³     5 -> Coluna final dialog                               ³±±
±±³          ³     6 -> Linha final dialog                                ³±±
±±³          ³     7 -> Linha inicial dialog                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

aSize    := MsAdvSize()

If aSize[3] < 495  // forço tamanho da tela para 1024 x 768
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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Sintaxe   ³ ExpA1 := MsObjSize( ExpA2, ExpA3, [ ExpL1 ], [ ExpL2 ] )   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA2 -> Area de trabalho                                  ³±±
±±³          ³ ExpA3 -> Definicoes de objetos                             ³±±
±±³          ³    1 - Tamanho X    / 2 - Tamanho Y  / 3 - Dimensiona X    ³±±
±±³          ³    4 - Dimensiona Y / 5 - Retorna dimensoes X e Y ao inves ³±±
±±³          ³       de linha / coluna final                              ³±±
±±³          ³ ExpL1 -> Mantem a proporcao dos objetos                    ³±±
±±³          ³ ExpL2 -> Indica calculo de objetos horizontais             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 -> Array com as posicoes de cada objeto              ³±±
±±³          ³     1 -> Linha inicial                                     ³±±
±±³          ³     2 -> Coluna inicial                                    ³±±
±±³          ³     3 -> Linha final                                       ³±±
±±³          ³     4 -> Coluna final Ou:                                  ³±±
±±³          ³     Caso seja passado o elemento 5 de cada definicao de    ³±±
±±³          ³     objetos como .t. o retorno sera:                       ³±±
±±³          ³     3 -> Tamanho da dimensao X                             ³±±
±±³          ³     4 -> Tamanho da dimensao Y                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

aPosObj  := MsObjSize(aInfo, aObjects)

Define MsDialog oDialog Title cTitle From aSize[7], 0 To aSize[6], aSize[5] Of oMainWnd Pixel

@ aPosObj[1][1], aPosObj[1][2] To aPosObj[1][3]+28, aPosObj[1][4] Prompt "Filtro" Of oDialog Pixel


@ aPosObj[1][1]+10, aPosObj[1][2]+077 Say "Cliente De:" Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+101 MSGet oGDatDe Var dGDatDe VALID !Vazio() Size 45, 09 Picture "@D" When lEdit Of oDialog Pixel 	
@ aPosObj[1][1]+10, aPosObj[1][2]+150 Say "Cliente Até:" Of oDialog Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+163 MSGet oGDatAte Var dGDatAte VALID !Vazio() Size 45, 09 Picture "@D" When lEdit Of oDialog Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+215 Say "" Of oDialog Pixel
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

If (!_cUsrLibA)    
	
	U_CFMFILSA1() 
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

Activate MsDialog oDialog On Init (EnchoiceBar(oDialog,{||lOk:=.T.,oDialog:End()},{||oDialog:End()},,@aButtons))

Return()    


Static Function _getVended(_cUsuario)
Local _cRet := ""

DbSelectArea("SA3"); DbSetOrder(7)

If (SA3->(Dbseek(xFilial("SA3")+_cUsuario)))
	_cRet := SA3->A3_COD	
EndIf

Return _cRet                                                                                                  

