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


User Function VQCONHIST()

Local aSize, aObjects, aInfo

Local bOk      := {|| oDlg:End()}
Local bCancel  := {|| oDlg:End()}
Local cTitle   := "Consulta Historico Preco"
Local oGetdb
Local nBoxSize := 0
Local aButtons := {{"IMPRESSAO",{|| Imprime() },               "Imprimir"} }

Private cEof := Chr(13) + Chr(10)

Private oDlg
Private aPosObj

Private oGetDados
Private aHeader := {}
Private aCols   := {}

Private oGCodPrd
Private cGCodPrd := CriaVar("B1_COD", .F.)
Private oGNomPrd
Private cGNomPrd

Private oGCodGrp
Private cGCodGrp := CriaVar("BM_GRUPO", .F.)
Private oGNomGrp
Private cGNomGrp

Private oBFiltro
Private lEdit     := .F.

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

@ aPosObj[1][1], aPosObj[1][2] To aPosObj[1][3]+28, aPosObj[1][4] Prompt "Filtro" Of oDlg Pixel

//@ aPosObj[1][1]+10, aPosObj[1][2]+004 Say "Pesquisa" Of oDlg Pixel
//@ aPosObj[1][1]+08, aPosObj[1][2]+032 ComboBox oPesqu Var cPesqu Items aPesqu Valid fValCon(.T.) Size 40, 50 When lEditPesq Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+077 Say "Produto" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+105 MSGet oGCodPrd Var cGCodPrd Valid Iif(Vazio() .or. ExistCpo("SB1", cGCodPrd, 1), (cGNomPrd := GetAdvFVal("SB1","B1_DESC",XFILIAL("SB1")+cGCodPrd,1,""),.T.),.F.) Size 30, 09 F3 "SB1" When lEdit Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+140 MSGet oGNomPrd Var cGNomPrd Size 100, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+250 Say "Grupo" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+278 MSGet oGCodGrp Var cGCodGrp Valid Iif(Vazio() .or. ExistCpo("SBM", cGCodGrp, 1), (cGNomGrp := GetAdvFVal("SBM","BM_DESC",XFILIAL("SBM")+cGCodGrp,1,""),.T.),.F.) Size 30, 09 F3 "SBM" When lEdit Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+313 MSGet oGNomGrp Var cGNomGrp Size 70, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+53, aPosObj[1][2]+458 Button oBFiltro Prompt "Filtrar" Size 42, 11 Action BtnFiltro() Of oDlg Pixel

oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)

oGetDados:lInsert := .F.
oGetDados:lDelete := .F.
oGetDados:lUpdate := .F.

nBoxSize := (aPosObj[3][4]-aPosObj[3][2])/11

//Activate MsDialog oDlg On Init (EnchoiceBar(oDlg, bOk, bCancel,, aButtons), ButWhen(@oDlg)) Centered
Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()},,@aButtons))


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

Do Case
	
	Case lEditPesq
		
		lEdit     := .F.
		lEditPesq := .F.
		lEditComp := .F.
		lEditVend := .F.

		oBFiltro:cTitle := "Limpar"
		
		MsAguarde({|| FilAnual() }, "Aguarde", "Gerando Consulta ...", .F.)
		
		oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)
		oGetDados:lInsert := .F.
		oGetDados:lDelete := .F.
		oGetDados:lUpdate := .F.
		oGetDados:lActive := .F.
		oGetDados:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}

	Otherwise
		
		oBFiltro:cTitle := "Filtrar"
		lEditPesq := .T.
//		fValCon()

		oGetDados:aCols := {}
				
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
Local _cQryDes := ""

Private	_cQryCod := "  "
Private	_cQryDes := "  "

nOpTipo := aScan( aCTipo, cCTipo)

aHeader := {}


Aadd(aHeader,{"Produto"	   ,"Z15_COD"    		,PesqPict("Z15","Z15_COD"),TamSX3("Z15_COD")[1],0,"",USADO,"C",,""})
Aadd(aHeader,{"Descricao"  ,"B1_DESC"   		,PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],0,"",USADO,"C",,""})

Aadd(aHeader,{"Revisao"       	,"Z15_REVISA" 	,PesqPict("Z15","Z15_REVISA"),TamSX3("Z15_REVISA")[1],0,"",USADO,"N",,""})
Aadd(aHeader,{"UM"        		,"Z15_UM"  		,PesqPict("Z15","Z15_UM")	,TamSX3("Z15_UM")[1],0,"",USADO,"N",,""})
Aadd(aHeader,{"Moeda"      		,"Z15_MOEDA" 	,PesqPict("Z15","Z15_MOEDA"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Tx Moeda"   		,"Z15_TXMOED" 	,PesqPict("Z15","Z15_TXMOEDA"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Data Alt"     	,"Z15_DATAAL" 	,PesqPict("Z15","Z15_DATAAL"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Densidade"		,"Z15_DENSID" 	,PesqPict("Z15","Z15_DENSID"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Ref. Com"		,"Z15_REFCOM" 	,PesqPict("Z15","Z15_REFCOM"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Frete C" 		,"Z15_FRETEC" 	,PesqPict("Z15","Z15_FRETEC"),14,4,"",USADO,"N",,""})

_cQry := " "

_cQry += " SELECT                                                                         " + cEof
_cQry += " * 							                                                  " + cEof
_cQry += "    FROM "+RetSQlName("Z15")+" Z15                                              " + cEof
_cQry += "     WHERE                                                                      " + cEof
_cQry += "       Z15.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "       AND Z15.Z15_FILIAL = '"+xFilial("Z15")+"'                                " + cEof
_cQry += "      AND Z15.Z15_COD = '"+cGCodPrd+"'                                          " + cEof

_cQry += " ORDER BY Z15_DATAAL, Z15_REVISA  						                      " + cEof

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
	
	TABTMP->(DbSkip())
EndDo


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
LOCAL cDesc1   := "Relatorio"

PRIVATE nomeprog := "VQCONVEN"
PRIVATE titulo   := "Relatorio de Vendas - De " + DtoC(dGDatDe) + " a " + DtoC(dGDatAte)
Private aFiltros := {}

U_ConVenTRep( Titulo , cDesc1 , nomeprog , aFiltros )

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

User Function ConVenTRep( cTitulo , cDescri , cReport , aFilt , aHeaderx , aColsx )

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
