#include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: CfmAtuPrc | Autor: Celso Ferrone Martins   | Data: 15/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Atualiza todas tabelas de preco                             |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
User Function CfmAtuPrc()

Processa({|| fCfmTela()},"Carregando dados...")

Return()

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: fCfmTela | Autor: Celso Ferrone Martins  | Data: 28/04/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Tela de selecao dos itens para reprocessamento de preco   |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fCfmTela()

Local aStruct     := {}
Local aCampos     := {}
Local cArqTrab1   := ""
Local cKey1       := ""
Local cKey2       := ""
Local cKey3       := ""
Local cIndTab1    := ""
Local cIndTab2    := ""
Local cIndTab3    := ""
Private cMarca    := "XX"//GetMark()
Private cAliasSEL := "TMPSEL"
Private lInverte  := .F.							// Flag de invers?o de sele¡?o

DbSelectArea("SB1") ; DbSetOrder(1) // Cadastro de Produtos
DbSelectArea("SG1") ; DbSetOrder(1) // Estrutura de produto
DbSelectArea("Z02") ; DbSetOrder(1) // Tabela de Precos - Cabecalho
DbSelectArea("Z03") ; DbSetOrder(2) // Tabela de Precos - Itens

aAdd(aStruct,{"Z02_OK"    ,"C" ,02,0 })
aAdd(aStruct,{"Z02_COD"   ,"C" ,15,0 })
aAdd(aStruct,{"Z02_CODVQ1","C" ,15,0 })
aAdd(aStruct,{"Z02_CODVQ2","C" ,15,0 })
aAdd(aStruct,{"Z02_DESC"  ,"C" ,30,0 })
aAdd(aStruct,{"Z02_UM"    ,"C" ,02,0 })
aAdd(aStruct,{"Z02_MOEDA" ,"C" ,05,0 })
aAdd(aStruct,{"Z02_CODMP" ,"C" ,15,0 })
aAdd(aStruct,{"Z02_CODEM" ,"C" ,15,0 })
aAdd(aStruct,{"ORDEM"     ,"C" ,03,0 })

AADD(aCampos,{"Z02_OK"     ,"" ," "          ," " })
AADD(aCampos,{"Z02_COD"    ,"" ,"Codigo"     ," " })
AADD(aCampos,{"Z02_CODVQ1" ,"" ,"Cod.Verq."  ," " })
//AADD(aCampos,{"Z02_CODVQ2" ,"" ,"Cod.Verq2"  ," " })
AADD(aCampos,{"Z02_DESC"   ,"" ,"Descricao"  ," " })
AADD(aCampos,{"Z02_UM"     ,"" ,"Un.Medida"  ," " })
AADD(aCampos,{"Z02_MOEDA"  ,"" ,"Moeda"      ," " })

cKey1 := "Z02_COD"
cKey2 := "Z02_CODVQ1"
cKey3 := "ORDEM+Z02_COD"

If Select(cAliasSEL) > 0
	(cAliasSEL)->(dbCloseArea())
EndIf

cArqTrab1 := CriaTrab(aStruct, .T.)
dbUseArea(.T.,, cArqTrab1 ,cAliasSEL, .F.,.F. )
dbSelectArea(cAliasSEL)

cIndTab1 := cArqTrab1+"A"
cIndTab2 := cArqTrab1+"B"
cIndTab3 := cArqTrab1+"C"

IndRegua(cAliasSEL,cIndTab1,cKey1,,,"Ordenando Arquivo de trabalho !!!")
IndRegua(cAliasSEL,cIndTab2,cKey2,,,"Ordenando Arquivo de trabalho !!!")
IndRegua(cAliasSEL,cIndTab3,cKey3,,,"Ordenando Arquivo de trabalho !!!")

(cAliasSEL)->(dbClearIndex())
(cAliasSEL)->(dbSetIndex(cIndTab1+OrdBagExt()))
(cAliasSEL)->(dbSetIndex(cIndTab2+OrdBagExt()))
(cAliasSEL)->(dbSetIndex(cIndTab3+OrdBagExt()))

CfmCarrega() // Carrega temporario

x1 := 1
x2 := 1
x3 := 650
x4 := 900

y1 := 1
y2 := 1
y3 := 300
y4 := 450

DEFINE MSDIALOG oDlgFil TITLE "Manutencao de Custos" From x1,x2 To x3,x4 OF oMainWnd PIXEL

oDlgFil:lEscClose := .F. // Desabilita fechar apertando a tecla escape ESC.

oMark  := MsSelect():New(cAliasSEL,"Z02_OK",,aCampos,@lInverte,cMarca,{y1,   y2, y3, y4})

//@ 310,001 BMPBUTTON TYPE 03 ACTION fDefDel(.T.,@lRet,oDlgFil,oMark)

nyy := 310
nxx := 10//252

@ nyy,nxx BMPBUTTON TYPE 01 ACTION fDefSel(.T.) ; nxx += 30
@ nyy,nxx BMPBUTTON TYPE 02 ACTION fDefSel(.F.) ; nxx += 30
//@ 310,nxx BMPBUTTON TYPE 17 ACTION fDefSel() ; nxx += 30
//@ 310,nxx BMPBUTTON TYPE 19 ACTION fDefSel() ; nxx += 30
//@ 310,nxx BMPBUTTON TYPE 14 ACTION fDefSel() ; nxx += 30

ObjectMethod(oMark:oBrowse,"Refresh()")
oMark:bMark := {|| fRegSel()}
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := {|| fMarkAll()}
oMark:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}

Activate MsDialog oDlgFil Centered

Return()

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

If col != 1
	
	Do Case
		Case col == 2
			DbSelectArea(cAliasSEL) ; DbSetOrder(1)
		Case col == 3
			DbSelectArea(cAliasSEL) ; DbSetOrder(2)
			//		Case col == 4
			//			DbSelectArea(cAliasSEL) ; DbSetOrder(3)
	EndCase
	
	(cAliasSEL)->(DbGoTop())
	
	oMark:oBrowse:Refresh(.T.)
	oDlgFil:Refresh()
	
EndIf

Return()

/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: fRegSel  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | Seleciona itens do MsSelect                              |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       |                                                          |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function fRegSel()

Local lRet := .T.

If Marked("Z02_OK")
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->Z02_OK := cMarca
	(cAliasSEL)->(MsUnlock())
Else
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->Z02_OK := "  "
	(cAliasSEL)->(MsUnlock())
Endif

oMark:oBrowse:Refresh(.t.)
oDlgFil:Refresh()

Return(lRet)

/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: fMarkAll | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | Marca todos os registros do MsSelect                     |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       |                                                          |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function fMarkAll()

Local nREC  := (cAliasSEL)->(Recno())
Local lRet  := .T.
Local lMack := .T.

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(EOF())
	RecLock(cAliasSEL,.F.)
	If Empty((cAliasSEL)->Z02_OK)
		(cAliasSEL)->Z02_OK := cMarca
		lMack := .T.
	Else
		(cAliasSEL)->Z02_OK := "  "
		lMack := .F.
	Endif
	(cAliasSEL)->(MsUnlock())
	
	(cAliasSEL)->(DbSkip())
EndDo

(cAliasSEL)->(DbGoTo(nREC))
oMark:oBrowse:Refresh(.t.)
oDlgFil:Refresh()

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fDefSel   | Autor: Celso Ferrone Martins  | Data: 17/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Define selecao. Encerra ou atualiza                        |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fDefSel(lRet)

Local lEncerra := .F.
Default lRet   := .F.

If lRet
	If MsgYesNo("Deseja recalcular os itens selecionados ?","Atencao!")
		If lRet
			fAtualiza()
		EndIf
		lEncerra := .T.
	EndIf
Else
	lEncerra := .T.
EndIf

If lEncerra
	If Select(cAliasSEL) > 0
		(cAliasSEL)->(dbCloseArea())
	EndIf
	Close(oDlgFil)
EndIf

Return(.F.)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fAtualiza | Autor: Celso Ferrone Martins  | Data: 17/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Atualiza tabela de preco                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fAtualiza()

Processa({|| fCfmPVer() },"Processando Estruturas...")
Processa({|| fCfmPMat() },"Processando Materia Primas...")
Processa({|| fCfmProc() },"Processando Tabelas de Precos...")

MsgAlert("Processamento executado com sucesso.","Fim do processamento.")

Return()

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: fCfmPVer | Autor: Celso Ferrone Martins  | Data: 28/04/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Ajustando produtos Versolve                               |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fCfmPVer()

Local cQuery    := ""
Local aDadosVer := {}
Local aVersolve := {}
Local aStruVers := {}
Local cVersolve := ""
Local aAreaSb1  := SB1->(GetArea("SB1"))
Local nTaxaM2   := GetMV("VQ_TXMOED2", .F.)
Local cOrdem    := "301"

Private nPerPis := 1.65      // % Pis
Private nPerCof := 7.60      // % Cofins
Private nPerIR  := 2.00      // % IR

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(EOF())
	IncProc()
	If !Empty((cAliasSEL)->Z02_OK)
		cVersolve += AllTrim((cAliasSEL)->Z02_CODMP) + "|"
	EndIf
	(cAliasSEL)->(DbSkip())
EndDo

cVersolve := FormatIn(SubStr(cVersolve,1,Len(cVersolve)-1),"|")

cQuery := " SELECT DISTINCT G1_COD FROM "+RetSqlName("SG1")+" SG1 "
cQuery += "    INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
cQuery += "       SB1.D_E_L_E_T_ <> '*' "
cQuery += "       AND B1_FILIAL = G1_FILIAL "
cQuery += "       AND B1_COD    = G1_COD "
cQuery += "       AND B1_TIPO   = 'MP' "
cQuery += "       AND B1_VQ_VERS = 'S' "
cQuery += " WHERE "
cQuery += "    SG1.D_E_L_E_T_ <> '*' "
cQuery += "    AND G1_FILIAL = '"+xFilial("SG1")+"' "
cQuery += "    AND G1_COMP IN " + cVersolve
//cQuery += " ORDER BY G1_FILIAL, G1_COD, G1_COMP "

cQuery := ChangeQuery(cQuery)

If Select("TMPSG1") > 0
	TMPSG1->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPSG1"

lTemVersol := .T.
aTemVersol := {}

While lTemVersol

	IncProc()

	DbSelectArea("TMPSG1")
	While !TMPSG1->(Eof())
		IncProc()
		nPos := aScan(aTemVersol,{|x|x[1]==TMPSG1->G1_COD})
		If nPos == 0
			Aadd(aTemVersol,{TMPSG1->G1_COD,.F.,cOrdem})
			cOrdem := Soma1(cOrdem)
		EndIf
		TMPSG1->(DbSkip())
	EndDo

	cVersolve := ""
	lTemVersol := .F.
	For nX := 1 To Len(aTemVersol)
		IncProc()
		If !aTemVersol[nX][2]
			lTemVersol := .T.
			aTemVersol[nX][2] := .T.
			cVersolve += AllTrim(aTemVersol[nX][1]) + "|"
		EndIf
	Next Nx

	If !Empty(cVersolve)
		cVersolve := FormatIn(SubStr(cVersolve,1,Len(cVersolve)-1),"|")

			cQuery := " SELECT DISTINCT G1_COD FROM "+RetSqlName("SG1")+" SG1 "
			cQuery += "    INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
			cQuery += "       SB1.D_E_L_E_T_ <> '*' "
			cQuery += "       AND B1_FILIAL = G1_FILIAL "
			cQuery += "       AND B1_COD    = G1_COD "
			cQuery += "       AND B1_TIPO   = 'MP' "
			cQuery += "       AND B1_VQ_VERS = 'S' "
			cQuery += " WHERE "
			cQuery += "    SG1.D_E_L_E_T_ <> '*' "
			cQuery += "    AND G1_FILIAL = '"+xFilial("SG1")+"' "
			cQuery += "    AND G1_COMP IN " + cVersolve
			
			cQuery := ChangeQuery(cQuery)
			
			If Select("TMPSG1") > 0
				TMPSG1->(DbCloseArea())
			EndIf
			
			TcQuery cQuery New Alias "TMPSG1"

	EndIf
	
EndDo

If Select("TMPSG1") > 0
	TMPSG1->(DbCloseArea())
EndIf

For Nx := 1 To Len(aTemVersol)
	IncProc()
	
	If SG1->(DbSeek(xFilial("SG1")+aTemVersol[nX][1]))
		While !SG1->(Eof()) .And. SG1->(G1_FILIAL+G1_COD) == xFilial("SG1")+aTemVersol[nX][1]
			
			nPos := aScan(aStruVers,{|x|x[1]==SG1->G1_COD})
			If nPos == 0
				SB1->(DbSeek(xFilial("SB1")+SG1->G1_COD))
				
				aDadoVers := {}
				aAdd(aDadoVers,SB1->B1_COD)											//01 - Codigo Produto Pai
				aAdd(aDadoVers,SB1->B1_UM)											//02 - Um
				aAdd(aDadoVers,SB1->B1_CONV)										//03 - Densidade
				aAdd(aDadoVers,SB1->B1_QB) 											//04 - Quantidade Base
				aAdd(aDadoVers,0)													//05
				aAdd(aDadoVers,SB1->B1_VQ_UM)  										//06 - UM
				aAdd(aDadoVers,SB1->B1_VQ_MOED)										//07 - Moeda
				aAdd(aDadoVers,0)													//08 - Referencia de Compra
				aAdd(aDadoVers,0)													//09 - Frete
				aAdd(aDadoVers,SB1->B1_VQ_ICMS)										//10 - Icms
				aAdd(aDadoVers, 1-((SB1->B1_VQ_ICMS/100)+((nPerPis+nPerCof)/100)) )	//11 - Base para calc de Icms Calculado
				aAdd(aDadoVers,{})													//12 - Componentes
				aAdd(aDadoVers,"S")													//13 - Item Ativos
				aAdd(aDadoVers,aTemVersol[nX][3])									//14 - Ordem de Gravacao
				aAdd(aStruVers,aDadoVers)
				nPos := aScan(aStruVers,{|x|x[1]==SG1->G1_COD})
			EndIf
			
			SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
//			If SB1->B1_MSBLQL == "1"
//				aStruVers[nPos][13] := "N"
//			EndIf
			aDadosVer := {}
			Aadd(aDadosVer,SG1->G1_COMP)										//01 - Codigo Produto
			Aadd(aDadosVer,SB1->B1_UM)											//02 - Um
			Aadd(aDadosVer,SB1->B1_CONV) 										//03 - Densidade
			Aadd(aDadosVer,SG1->G1_QUANT)										//04 - Quantidade
			Aadd(aDadosVer,SG1->G1_VQ_PVER)								   		//05 - % do produto
			Aadd(aDadosVer,SB1->B1_VQ_UM)										//06 - UM da Tabela
			Aadd(aDadosVer,SB1->B1_VQ_MOED) 									//07 - Moeda da Tabela
			Aadd(aDadosVer,SB1->B1_VQ_RCOM) 									//08 - Referencia de Compra
			Aadd(aDadosVer,SB1->B1_VQ_FRET) 									//09 - Frete
			Aadd(aDadosVer,SB1->B1_VQ_ICMS)										//10 - ICMS do Componente
			Aadd(aDadosVer,1-((SB1->B1_VQ_ICMS/100)+((nPerPis+nPerCof)/100)) )	//11 - Dif Icms
			Aadd(aStruVers[nPos][12],aDadosVer)
			
			SG1->(DbSkip())
		EndDo
		
	EndIf
	
Next


For Nx := 1 To Len(aStruVers)
	For Ny := 1 To Len(aStruVers[nX][12])
		
		SB1->(DbSeek(xFilial("SB1")+aStruVers[nX][12][Ny][1]))
		aStruVers[nX][12][Ny][8] := SB1->B1_VQ_RCOM
		aStruVers[nX][12][Ny][9] := SB1->B1_VQ_FRET
		
		If AllTrim(aStruVers[nX][6]) == AllTrim(aStruVers[nX][12][Ny][6])		// Unidade de Medida
			nCalRCom := (aStruVers[nX][12][Ny][8]*aStruVers[nX][12][Ny][11]) 	// Referencia de Compra Tirando ICMS da tabela
			nCalFret := aStruVers[Nx][12][nY][9]								// Frete
		Else
			If AllTrim(aStruVers[nX][12][Ny][6]) == "KG"
				nCalRCom := aStruVers[nX][12][Ny][8] * aStruVers[nX][12][Ny][3]
				nCalFret := aStruVers[Nx][12][nY][9] * aStruVers[nX][12][Ny][3]
			Else
				nCalRCom := aStruVers[nX][12][Ny][8] / aStruVers[nX][12][Ny][3]
				nCalFret := aStruVers[Nx][12][nY][9] / aStruVers[nX][12][Ny][3]
			EndIf
			nCalRCom := (nCalRCom*aStruVers[nX][12][Ny][11]) // Referencia de Compra Tirando ICMS da tabela
		EndIf
		
		If aStruVers[nX][7] != aStruVers[nX][12][Ny][7]
			If aStruVers[nX][12][Ny][7] == "1"
				nCalRCom := nCalRCom / nTaxaM2
				nCalFret := nCalFret / nTaxaM2
			Else
				nCalRCom := nCalRCom * nTaxaM2
				nCalFret := nCalFret * nTaxaM2
			EndIf
		EndIf
		
		nCalRCom     := nCalRCom / aStruVers[nX][11]
		aStruVers[nX][8] += Round((nCalRCom / 100) * aStruVers[nX][12][Ny][5],2)	// Versolver - Ref. Compra
		aStruVers[nX][9] += Round((nCalFret / 100) * aStruVers[nX][12][Ny][5],2)	// Versolver - Ref. Compra
		
	Next Ny

	If aStruVers[nX][13] == "S"
		If SB1->(DbSeek(xFilial("SB1")+aStruVers[nX][1]))
			RecLock("SB1",.F.)
			SB1->B1_VQ_RCOM := aStruVers[nX][8]
			SB1->B1_VQ_FRET := aStruVers[nX][9]
			MsUnLock()
			
			If Z02->(DbSeek(xFilial("Z02")+aStruVers[nX][1]))
				
				RecLock(cAliasSEL,.T.)
				(cAliasSEL)->Z02_OK     := cMarca
				(cAliasSEL)->Z02_COD    := Z02->Z02_COD
				(cAliasSEL)->Z02_CODVQ1 := SB1->B1_VQ_COD
				//	(cAliasSEL)->Z02_CODVQ2 := SB1->B1_VQ_COD2
				(cAliasSEL)->Z02_DESC   := SB1->B1_DESC
				(cAliasSEL)->Z02_UM     := Z02->Z02_UM
				(cAliasSEL)->Z02_MOEDA  := iIf(Z02->Z02_MOEDA=="1","Real","Dolar")
				(cAliasSEL)->Z02_CODMP  := Z02->Z02_CODMP
				(cAliasSEL)->Z02_CODEM  := Z02->Z02_CODEM
				(cAliasSEL)->ORDEM      := aStruVers[Nx][14]
				MsUnLock()
				
			EndIf
			
		EndIf
	EndIf
Next nX

SB1->(RestArea(aAreaSb1))

Return()
/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: fCfmProc | Autor: Celso Ferrone Martins  | Data: 28/04/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Processamento da ataulizacao da tabela de preco           |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fCfmProc()

Local nCusOpera  := 0 			// Custo Operacional
Local nFatorMp   := 0 			// Fator
Local nIcmsMp    := 0 			// ICMS Materia Prima
Local nIcmsEm    := 0 			// ICMS Embalagem
Local nIcmsPa    := 0 			// ICMS Produto Pai
Local nIpiMp     := 0 			// IPI Materia Prima
Local nIpiEm     := 0 			// IPI Embalagem
Local nIpiPa     := 0 			// IPI Produto Pai
Local nCapacid   := 0 			// Capacidade da embalagem
Local nReComMp   := 0 			// Referencia de Compra Materia Prima
Local nReComEm   := 0 			// Referencia de Compra Embalagem
//Local lZ01       := .F.
Local nTxMoed2   := 0 			// Taxa Moeda 2
Local nFreteTon  := 0 			// Frete por Tonelada
Local _nFreteTon := 0 			// Frete por Tonelada
Local nFreteMet  := 0 			// Frete por Metro Cubico
Local _nFreteMet := 0 			// Frete por Metro Cubico
Local nBasCalc   := 0 			// Base para calculo de conversao
Local nPercExt   := 0 			// Percentual Extra da Embalagem
Local nFreteMp   := 0 			// Frete de Compras
Local nPesoEm    := 0 			// Peso da Embalagem
Local nBasCalcKg := 0 			//
Local cRevAtua   := ""
Local cRevNova   := ""
Local nPercPis   := 1.65		// % Pis
Local nPercCof   := 7.60		// % Cofins
Local nPercIR    := 2.00		// % IR

Local cUmAtu     := ""
Local cUmPri     := ""
Local cUmSeg     := ""

Local cMoeAtu    := ""
Local cVqEmcs    := ""

Local nIcmInd    := 0 			// Indice de Icms Tabela
Local nIcmIndPrd := 0 			// Indice de Icms Produto
Local nIcmDif    := 0 			// Diferencial de Icms

Private nMargemA := 0 			// Margem Tabela A
Private nMargemB := 0 			// Margem Tabela B
Private nMargemC := 0 			// Margem Tabela C
Private nMargemD := 0 			// Margem Tabela D
Private nMargemE := 0 			// Margem Tabela E

IncProc()

If GetMV("VQ_DTCOTAC", .F.) <= dDataBase
	nTxMoed2   := GetMV("VQ_TXMOED2", .F.)
	nFreteTon  := GetMV("VQ_FRETONE", .F.)
	_nFreteTon := GetMV("VQ_FRETONE", .F.)
	nFreteMet  := GetMV("VQ_FRETMET", .F.)
	_nFreteMet := GetMV("VQ_FRETMET", .F.)
	nBasCalc   := GetMV("VQ_BASELIT", .F.)
	dDataCot   := GetMV("VQ_DTCOTAC", .F.)
EndIf

(cAliasSEL)->(DbSetOrder(3))
(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(EOF())
	IncProc()
	If !Empty((cAliasSEL)->Z02_OK)
		
		Z02->(DbSeek(xFilial("Z02")+(cAliasSEL)->Z02_COD))
		Z03->(DbSeek(xFilial("Z03")+Z02->(Z02_COD+Z02_REVISA)))
		SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
		cRevAtua := Z02->Z02_REVISA
		cRevNova := Soma1(cRevAtua)
		cVqEmcs  := SB1->B1_VQ_EMCS
		cB1Blql  := If(SB1->B1_MSBLQL=="2","S","N")
		cEmbCus  := SB1->B1_VQ_EMCS

		// Materia Prima
		SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODMP))
		nMargemA  := Z02->Z02_MARGEA
		nMargemB  := Z02->Z02_MARGEB
		nMargemC  := Z02->Z02_MARGEC
		nMargemD  := Z02->Z02_MARGED
		nMargemE  := Z02->Z02_MARGEE
		nCusOpera := Z02->Z02_CUSOPE

		nFatorMp  := SB1->B1_CONV
		nIcmsMp   := SB1->B1_VQ_ICMS
		nIpiMp    := SB1->B1_VQ_IPI
		nReComMp  := SB1->B1_VQ_RCOM
		nFreteMp  := SB1->B1_VQ_FRET
		
		cUmPri    := SB1->B1_UM
		cUmSeg    := SB1->B1_SEGUM
		cUmAtu    := iIf(SB1->B1_VQ_UM==SB1->B1_UM,"01","02")
		cMoeAtu   := "0"+SB1->B1_VQ_MOED
				
		// Embalagem
		SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
		nIcmsEm  := SB1->B1_VQ_ICMS
		nIpiEm   := SB1->B1_VQ_IPI
		nReComEm := SB1->B1_VQ_RCOM
		nPercExt := Z02->Z02_PEXTRA
		nPesoEm  := SB1->B1_PESO
		nCapB1G1 := SB1->B1_VQ_ECAP // ok

		If SB1->B1_COD != "03000"
			aAreaNow := SG1->(GetArea())
			SG1->(DbSeek(xFilial("SG1")+Z02->(Z02_COD+Z02_CODMP)))
			If SB1->B1_VQ_UMEM == cUmPri
				nCapB1G1 := SG1->G1_QUANT
			ElseIf cUmPri == "KG"
				nCapB1G1 := SG1->G1_QUANT/nFatorMp
			Else
				nCapB1G1 := SG1->G1_QUANT*nFatorMp
			EndIf
			SG1->(RestArea(aAreaNow))
		EndIf

		
		If SB1->B1_VQ_UMEM == Z02->Z02_UM
			nCapacid := nCapB1G1
		Else
			If SB1->B1_VQ_UMEM == "KG"
				nCapacid := nCapB1G1 / nFatorMp
			ElseIf SB1->B1_VQ_UMEM == "L "
				nCapacid := nCapB1G1 * nFatorMp
			Else
				nCapacid := nCapB1G1
			EndIf
		EndIf

		dDatRefCom := Z02->Z02_DTRCOM
		cCodMp     := Z02->Z02_CODMP
		cCodEm     := Z02->Z02_CODEM
		cCodPai    := Z02->Z02_COD
		cZ02Um     := Z02->Z02_UM
		cZ02Moeda  := Z02->Z02_MOEDA

		RecLock("Z02",.F.)
		Z02->Z02_REVISA := cRevNova
		Z02->Z02_DATAAL := dDataBase
		Z02->Z02_DENSID := nFatorMp
		Z02->Z02_TXMOED := nTxMoed2
		Z02->Z02_DATACO := dDataCot
		Z02->Z02_REFCOM := nReComMp
		Z02->Z02_FRETEC := nFreteMp
		Z02->Z02_MARGEA := nMargemA
		Z02->Z02_MARGEB := nMargemB
		Z02->Z02_MARGEC := nMargemC
		Z02->Z02_MARGED := nMargemD
		Z02->Z02_MARGEE := nMargemE
		Z02->Z02_CUSOPE := nCusOpera
		Z02->Z02_PICMMP := nIcmsMp
		Z02->Z02_PIPIMP := nIpiMp
		Z02->Z02_PICMEM := nIcmsEm
		Z02->Z02_PIPIEM := nIpiEm
		Z02->Z02_CUSTO  := nReComEm
		Z02->Z02_PEXTRA := nPercExt
		Z02->Z02_VEXTRA := (nReComMp*nPercExt)/100
		MsUnLock()

		If cMoeAtu == "01"
			nTaxConv  := 1
		Else
			nTaxConv  := nTxMoed2
		EndIf

		If cUmAtu == "01" 
			nFatConv  := 1
		Else
			nFatConv  := nFatorMp
		EndIf
		
		nFreteTon := _nFreteTon / nTaxConv // Custo do Frete por Tonelada
		nFreteMet := _nFreteMet / nTaxConv // Custo do Frete por Metro Cubico
		
		nIcmInd    := 1-(Z02->Z02_PICMMP/100)
		nIcmIndPrd := 1-(nIcmsMp/100) 							/////// VERIFICAR SE ESTA CERTO
		nIcmDif   := ((nReComMp*(nIcmInd))/nIcmIndPrd)-nReComMp /////// VERIFICAR SE ESTA CERTO
		nBasCalcKg := nBasCalc*nFatorMp
		
		//		nZ03Capaci := nCapacid*nFatConv
		nZ03Capaci := nCapacid
		If SubStr(cVqEmcs,1,1) == "S"
			nZ03CustoE := ((nReComEm+((nReComEm*nIpiEm)/100))*(nBasCalc/nCapacid))/nTaxConv
		Else
			nZ03CustoE := 0
		EndIf

		nZ03Custo1 := Round(nReComMp+nFreteMp+nZ03CustoE+((nReComMp*nPercExt)/100),2)		
		
		//		nZ03FreEnt := Round(((nFreteTon*(((nBasCalc/nCapacid)*nPesoEm)+nBasCalcKg))/nBasCalc)/nFatConv,2)
		
		If SubStr(SB1->B1_VQ_UMEM,1,1) == "L"
			_nQtdEmb   := nBasCalc/nCapB1G1
		Else
			_nQtdEmb := (nBasCalc*nFatorMp)/nCapB1G1
		EndIf

		//_nQtdEmb   := nBasCalc/nCapacid
		_nPesoTot  := (_nQtdEmb*nPesoEm)+nBasCalcKg
		If !AllTrim(SB1->B1_COD) == "03000"
			nZ03FreEnt := ((nFreteTon * _nPesoTot) / nBasCalc)
			If SB1->B1_VQ_UMEM != Z02->Z02_UM
				If SB1->B1_VQ_UMEM != "KG"
					nZ03FreEnt := nZ03FreEnt / nFatorMp
				EndIf
			ElseIf SB1->B1_VQ_UMEM == "KG"
				nZ03FreEnt := nZ03FreEnt / nFatorMp
			EndIf
		Else
			nZ03FreEnt := ((nFreteMet * nBasCalc) / 15000)
			If SB1->B1_VQ_UMEM != Z02->Z02_UM
				If SB1->B1_VQ_UMEM == "KG"
					nZ03FreEnt := nZ03FreEnt / nFatorMp
				Else
					nZ03FreEnt := nZ03FreEnt
				EndIf
			EndIf
		EndIf
		
		nZ03FreEnt := Round(nZ03FreEnt,2)

		//Tabela de Auditoria
		RecLock("Z15",.T.)
		Z15->Z15_FILIAL := xFilial("Z15")
		Z15->Z15_COD    := cCodPai
		Z15->Z15_DATAIN := dDataBase
		Z15->Z15_ORIGEM := "CFMATUPR"
		Z15->Z15_REVISA := cRevNova
		Z15->Z15_DATAAL := dDataBase
		Z15->Z15_UM     := cZ02Um
		Z15->Z15_MOEDA  := cZ02Moeda
		Z15->Z15_TXMOED := nTxMoed2
		Z15->Z15_DATACO := dDataCot
		Z15->Z15_FRETEC := nFreteMp
		Z15->Z15_REFCOM := nReComMp
		Z15->Z15_DENSID := nFatorMp
		Z15->Z15_DTRCOM := dDatRefCom
		Z15->Z15_MARGEA := nMargemA
		Z15->Z15_MARGEB := nMargemB
		Z15->Z15_MARGEC := nMargemC
		Z15->Z15_MARGED := nMargemD
		Z15->Z15_MARGEE := nMargemE
		Z15->Z15_CUSOPE := nCusOpera
		Z15->Z15_CODMP  := cCodMp
		Z15->Z15_CODEM  := cCodEm
		Z15->Z15_PICMMP := nIcmsMp
		Z15->Z15_PIPIMP := nIpiMp
		Z15->Z15_PICMEM := nIcmsEm
		Z15->Z15_PIPIEM := nIpiEm
		Z15->Z15_CUSTO  := nReComEm
		Z15->Z15_PEXTRA := nPercExt
		Z15->Z15_VEXTRA := (nReComMp*nPercExt)/100
		Z15->Z15_REVUSR := Upper(cUserName)
		Z15->Z15_REVDAT := Date()
		Z15->Z15_REVTIM := Time()
		Z15->Z15_VQEMCS := cEmbCus
		Z15->Z15_B1MSBL := cB1Blql
		MsUnLock()
		
		cZ03Tabela  := "A"
		For nY := 1 To 5
			IncProc()
			
			nZ03Margem  := &("nMargem"+cZ03Tabela)
			//				nZ03Markup  := nZ03Custo1/(((nReComMp*(1-nIcmsMp/100))+nFreteMp+(Round((nReComMp*nPercExt)/100,2))-((nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100))+nZ03FreEnt+(nZ03CustoE*((100-nIcmsEm)/100)))/(100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem))*100)
			_nValExtra := (nReComMp*nPercExt)/100
			nCalc01    := (nReComMp*(1-nIcmsMp/100))+nFreteMp+_nValExtra+nZ03FreEnt
			nCalc02    := (nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100)
			nCalc03    := nZ03CustoE*((100-nIcmsEm)/100)
			nCalc04    := 100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem)
			nCalc05    := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
			nZ03Markup := nZ03Custo1/nCalc05
			nZ03Markup := Round(nZ03Markup,4)
			
			
			nZ03ValVen := nZ03Custo1/nZ03Markup
			nZ03ValCal := nZ03ValVen/nBasCalc
			nZ03ValIcm := (nZ03ValVen-(nReComMp+nIcmDif+nZ03CustoE))*(nIcmsMp/100)
			nZ03PisCof := (nZ03ValVen-(nReComMp+nIcmDif+nFreteMp+nZ03CustoE+nZ03FreEnt))*((nPercPis+nPercCof)/100)
			nZ03CusOpe := nZ03ValVen*(nCusOpera/100)
			nZ03Custo2 := nZ03FreEnt+nZ03Custo1+nZ03ValIcm+nZ03PisCof+nZ03CusOpe
			nZ03LucBru := nZ03ValVen-nZ03Custo2
			nZ03ValIr  := nZ03ValVen*(nPercIR/100)
			nZ03LucLiq := nZ03LucBru-nZ03ValIr
			
			RecLock("Z03",.T.)
			Z03->Z03_FILIAL := xFilial("Z03")
			Z03->Z03_COD    := Z02->Z02_COD
			Z03->Z03_TABELA := cZ03Tabela
			Z03->Z03_REVISA := Z02->Z02_REVISA
			Z03->Z03_UM     := If(cUmAtu=="01",cUmPri,cUmSeg)
			Z03->Z03_MOEDA  := If(cMoeAtu=="01","1","2")
			Z03->Z03_CUSTOE := nZ03CustoE
			Z03->Z03_FRTTON := nFreteTon
			Z03->Z03_FRTCUB := nFreteMet
			Z03->Z03_MARGEM := nZ03Margem
			Z03->Z03_CAPACI := nZ03Capaci
			Z03->Z03_FREENT := nZ03FreEnt
			Z03->Z03_CUSTO1 := nZ03Custo1
			Z03->Z03_VALVEN := nZ03ValVen
			Z03->Z03_VALCAL := nZ03ValCal
			Z03->Z03_MARKUP := nZ03Markup
			Z03->Z03_VALICM := nZ03ValIcm
			Z03->Z03_PISCOF := nZ03PisCof
			Z03->Z03_CUSOPE := nZ03CusOpe
			Z03->Z03_CUSTO2 := nZ03Custo2
			Z03->Z03_LUCBRU := nZ03LucBru
			Z03->Z03_VALIR  := nZ03ValIr
			Z03->Z03_LUCLIQ := nZ03LucLiq
			Z03->Z03_ORIGEM := "CFMATUPR"
			Z03->Z03_REVUSR := Upper(cUserName)
			Z03->Z03_REVDAT := Date()
			MsUnLock()
			
			cZ03Tabela := Soma1(cZ03Tabela)
		Next nY
		
	Endif
	(cAliasSEL)->(DbSkip())
EndDo

CfmCarrega()

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+-------------------------------+------------------+||
||| Programa: CfmCarrega | Autor: Celso Ferrone Martins  | Data: 23/09/2014 |||
||+-----------+----------+-------------------------------+------------------+||
||| Descricao | Carrega TMP                                                 |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function CfmCarrega()

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(Eof())
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->(DbDelete())
	MsUnLock()
	(cAliasSEL)->(DbSkip())
EndDo

cQuery := " SELECT * FROM " + RetSqlName("Z02")
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY Z02_FILIAL, Z02_COD "

If Select("TMPZ02") > 0
	TMPZ02->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPZ02"

DbSelectArea("TMPZ02")
While !TMPZ02->(Eof())
	SB1->(DbSeek(xFilial("SB1")+TMPZ02->Z02_COD))
	If SB1->B1_TIPO == "MP" .And. SB1->B1_VQ_VERS != "S"// .And. SB1->B1_MSBLQL <> "1"
		RecLock(cAliasSEL,.T.)
		(cAliasSEL)->Z02_OK     := cMarca
		(cAliasSEL)->Z02_COD    := TMPZ02->Z02_COD
		(cAliasSEL)->Z02_CODVQ1 := SB1->B1_VQ_COD
		//	(cAliasSEL)->Z02_CODVQ2 := SB1->B1_VQ_COD2
		(cAliasSEL)->Z02_DESC   := SB1->B1_DESC
		(cAliasSEL)->Z02_UM     := TMPZ02->Z02_UM
		(cAliasSEL)->Z02_MOEDA  := iIf(TMPZ02->Z02_MOEDA=="1","Real","Dolar")
		(cAliasSEL)->Z02_CODMP  := TMPZ02->Z02_CODMP
		(cAliasSEL)->Z02_CODEM  := TMPZ02->Z02_CODEM
		(cAliasSEL)->ORDEM      := "100"
		MsUnLock()
	EndIf
	TMPZ02->(DbSkip())
EndDo

(cAliasSEL)->(DbGoTop())

If Select("TMPZ02") > 0
	TMPZ02->(DbCloseArea())
EndIf

Return()

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: fCfmPMat  | Autor: Celso Ferrone Martins   | Data: 23/09/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Materiais com a mesma materia prima para ajuste de tabela   |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function fCfmPMat()

Local aProdsMp := {}
Local aAreaSel := (cAliasSEL)->(GetArea())

(cAliasSEL)->(DbSetOrder(1))

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(Eof())
	
	IncProc()
	
	If !Empty((cAliasSEL)->Z02_OK)
		nPos := aScan(aProdsMp,{|x|x==(cAliasSEL)->Z02_COD})
		If nPos == 0
			aAdd(aProdsMp,(cAliasSEL)->Z02_COD)
		EndIf
	EndIf
	
	(cAliasSEL)->(DbSkip())
EndDo

For Nx := 1 To Len(aProdsMp)
	
	IncProc()
	
	cQuery := " SELECT * FROM " + RetSqlName("Z02") + " Z02 "
	cQuery += "    INNER JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "       SB1.D_E_L_E_T_ <> '*' "
	cQuery += "       AND B1_FILIAL  = '"+xFilial("SB1")+"' "
	cQuery += "       AND B1_COD     = Z02_CODMP "
//	cQuery += "       AND B1_MSBLQL  <> '1' "
	cQuery += " WHERE "
	cQuery += "    Z02.D_E_L_E_T_ <> '*' "
	cQuery += "    AND Z02_CODMP = '"+aProdsMp[nX]+"' "
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("XZ02") > 0
		XZ02->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "XZ02"
	
	While !XZ02->(Eof())
		
		If SB1->(DbSeek(xFilial("SB1")+XZ02->Z02_COD))
			
			If (cAliasSEL)->(DbSeek(XZ02->Z02_COD))
				RecLock(cAliasSEL,.F.)
			Else
				RecLock(cAliasSEL,.T.)
				(cAliasSEL)->Z02_COD    := XZ02->Z02_COD
				(cAliasSEL)->Z02_CODVQ1 := SB1->B1_VQ_COD
				//	(cAliasSEL)->Z02_CODVQ2 := SB1->B1_VQ_COD2
				(cAliasSEL)->Z02_DESC   := SB1->B1_DESC
				(cAliasSEL)->Z02_UM     := XZ02->Z02_UM
				(cAliasSEL)->Z02_MOEDA  := iIf(XZ02->Z02_MOEDA=="1","Real","Dolar")
				(cAliasSEL)->Z02_CODMP  := XZ02->Z02_CODMP
				(cAliasSEL)->Z02_CODEM  := XZ02->Z02_CODEM
				(cAliasSEL)->ORDEM      := "200"
			EndIf
			
			(cAliasSEL)->Z02_OK     := cMarca
			
			MsUnLock()
			
		EndIf
		
		XZ02->(DbSkip())
		
	EndDo
	
Next Nx

(cAliasSEL)->(RestArea(aAreaSel))

Return()
