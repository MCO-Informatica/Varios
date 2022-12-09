#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SET.CH"

User Function MKETQ001()
Local lConf := .F.

Local aArea    := GetArea()
Local aParam   := {}
Local aStruct  := {}
Local cTitulo  := "Impressão de etiquetas"
Local cCodPro  := ""
Local cLotPro  := ""
Local cArmPro  := ""
Local cPathCli := ""
Local cPathSrv := ""
Local cOrdemP	:= ""
Local nCopias	 := 0
Local oWord    := Nil
Local i
Local cQuery 	:= ""


//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MKETQ001" , __cUserID )

cPathSrv := GetMv("MV_PATHETQ")
If Empty(cPathSrv)
	MsgAlert("Parametro MV_PATHETQ não existe ou não preenchido.", cTitulo)
	Return
EndIf

lConf := MsgYesNo("Deseja imprimir etiquetas da Produção - OP ?","Alterações")

If !Pergunte("MKETQ001", .T.)
	Return
EndIf

cCodPro := MV_PAR01
cArmPro := MV_PAR02
cLotPro := MV_PAR03
nCopias	:= MV_PAR04
cOrdemP	:= MV_PAR05

cQuery := " SELECT A.R_E_C_N_O_  AS REC "
cQuery += "   FROM "+retsqlname("SC2")+" A   "
cQuery += "  WHERE C2_PRODUTO = '"+cCodPro+"'   "
cQuery += "    AND C2_LOCAL = '"+cArmPro+"'   "
cQuery += "    AND A.C2_LOTECTL = '"+cLotPro+"' "
cQuery += "    AND A.D_E_L_E_T_ <> '*' "
cQuery += "    AND A.C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery += "    AND C2_NUM = '"+cOrdemP+"' "
cQuery := ChangeQuery(cQuery)
iif(select("SC2XXX")>0,SC2XXX->(dbclosearea()),nil)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"SC2XXX",.F.,.T.)

If  lConf
	IF SC2XXX->(!EOF())
		SC2->(DBGOTO(SC2XXX->REC))
	EndIf
	
else
	SB8->(DbSetOrder(3))
	SB8->(DbSeek(xFilial("SB8") + cCodPro + cArmPro + cLotPro))
Endif

DBSELECTAREA("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + cCodPro))

cPathCli := GetTempPath(.T.)
cPathSrv += "\" + AllTrim(SB1->B1_MKDOCET)

If lConf
	
	If !SB1->(Found())
		MsgAlert("Produto não encontrado.", cTitulo)
		Return()
	ElseIf SC2XXX->(EOF())
		MsgAlert("Lote/Armazém não encontrados na OP.", cTitulo)
		Return()
	ElseIf File(cPathCli + AllTrim(SB1->B1_MKDOCET)) .And. fErase(cPathCli + AllTrim(SB1->B1_MKDOCET)) <> 0
		MsgAlert("Não foi possível excluir o arquivo temporário. Feche todos os documentos word.", cTitulo)
		Return()
	ElseIf !CpyS2T(cPathSrv, cPathCli)
		MsgAlert("Não foi possível copiar o modelo do servidor. Verifique o parametro MV_PATHETQ.", cTitulo)
		Return()
	Else
		aAdd(aParam, {"dDatabase", DtoC(dDatabase), "D"})
		aStruct := SB1->(DbStruct())
		For i := 1 To Len(aStruct)
			aAdd(aParam, {aStruct[i,1], SB1->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
		Next
	Endif
	
ELSE
	If !SB1->(Found())
		MsgAlert("Produto não encontrado.", cTitulo)
		Return()
	ElseIf !SB8->(Found())
		MsgAlert("Lote/Armazém não encontrados na OP.", cTitulo)
		Return()
	ElseIf File(cPathCli + AllTrim(SB1->B1_MKDOCET)) .And. fErase(cPathCli + AllTrim(SB1->B1_MKDOCET)) <> 0
		MsgAlert("Não foi possível excluir o arquivo temporário. Feche todos os documentos word.", cTitulo)
		Return()
	ElseIf !CpyS2T(cPathSrv, cPathCli)
		MsgAlert("Não foi possível copiar o modelo do servidor. Verifique o parametro MV_PATHETQ.", cTitulo)
		Return()
	Else
		aAdd(aParam, {"dDatabase", DtoC(dDatabase), "D"})
		aStruct := SB1->(DbStruct())
		For i := 1 To Len(aStruct)
			aAdd(aParam, {aStruct[i,1], SB1->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
		Next
	Endif
	
ENDIF


If lConf
	aStruct := SC2->(DbStruct())
	SC2->(DBGOTO(SC2XXX->REC))
	For i := 1 To Len(aStruct)
		aAdd(aParam, {aStruct[i,1], SC2->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
	Next
	aStruct := SB8->(DbStruct())
	For i := 1 To Len(aStruct)
		aAdd(aParam, {aStruct[i,1], '', aStruct[i,2]})
	Next
ELSE
	aStruct := SB8->(DbStruct())
	For i := 1 To Len(aStruct)
		aAdd(aParam, {aStruct[i,1], SB8->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
	Next
	aStruct := SC2->(DbStruct())
	For i := 1 To Len(aStruct)
		aAdd(aParam, {aStruct[i,1], '', aStruct[i,2]})
	Next
Endif

aStruct := SM0->(DbStruct())
For i := 1 To Len(aStruct)
	aAdd(aParam, {aStruct[i,1], SM0->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
Next

oWord := OLE_CreateLink('TMsOleWord97')
OLE_SetProperty(oWord, 206, .F.)  // SetProperty 206 visibilidade da janela
OLE_OpenFile(oWord, cPathCli + AllTrim(SB1->B1_MKDOCET))

For i := 1 To Len(aParam)
	OLE_SetDocumentVar(oWord, aParam[i,1], aParam[i,2])
	If  aParam[i,1] $ 'B1_COD|B1_CODBAR|C2_LOTECTL|B8_LOTECTL'  //aParam[i,3] == "C"
		OLE_SetDocumentVar(oWord, aParam[i,1] + "_BAR", StringBar(AllTrim(aParam[i,2]), 1))
	EndIf
Next

OLE_UpDateFields(oWord)
If Aviso("Impressão de etiqueta", "Deseja visualizar ou imprimir?", {"Visualizar", "Imprimir"}, 1) == 2
	OLE_PrintFile(oWord,"ALL",,, nCopias)
	Sleep(1000)
	OLE_CloseFile(oWord)
	OLE_CloseLink(oWord)
Else
	OLE_SaveFile(oWord)
	OLE_CloseFile(oWord)
	OLE_CloseLink(oWord)
	ShellExecute("Open", AllTrim(SB1->B1_MKDOCET),"", cPathCli, 3)
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpEtGraf ³ Autor ³ Fabricio E. da Costa  ³ Data ³ 15/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³          		                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpEtqZPL()
Local cFonte1  := "30,35"
Local cFonte2  := "25,30"
Local cFonte3  := "40,70"
Local nHeigth  := 040   // Altura da etiqueta
Local nWidth   := 090   // Larguta da Etiqueta
Local nMargemD := 001   // Margem da direita
Local nMargemE := 003   // Margem da esquerda
Local nMargemS := 004   // Margem superior
Local nColEsp  := 003   // Espaco entre uma coluna e outra
Local nLinEsp  := 000   // Espaco entre uma linha e outra
Local nTamLin  := 004   // Altura de cada linha
Local nAfastX  := 001   // Distancia entre as strings e as linhas superiores (utilizado quando a etiqueta usa tabelas)
Local nAfastY  := 001   // Distancia entre as strings e as linhas da esquerda (utilizado quando a etiqueta usa tabelas)
Local nTraco1  := 003   // Espessura do traco(em pixels) a ser utilizado
Local nCols    := 1     // Numero de colunas
Local nLins    := 1     // Numero de linhas
Local nPosX    := 0
Local nPosY    := 0
Local k

//PZebra(.T., cPergImp)
MSCBPRINTER("OS 214","LPT1",,,.F.) // configura impressora
MSCBCHKSTATUS(.F.) // Nao checar impressoa

MSCBBEGIN(1,1) // Inicia a escrita das variaveis
nPosY := nMargemS
nPosX := nMargemE
For k := 1 To nCols
	MSCBSay(nPosX+005, nPosY+(nTamLin*1), AllTrim(SB1->B1_DESC), "N", "0", cFonte3)
	MSCBSay(nPosX+005, nPosY+(nTamLin*3), "Produto", "N", "0", cFonte2)
	MSCBSayBar(nPosX+035, nPosY+(nTamLin*3), SB1->B1_COD, "N", "MB07", nTamLin*2, .F., .T., .F., , 2.6, 2, .T.)
	MSCBSay(nPosX+005, nPosY+(nTamLin*5), "Lote", "N", "0", cFonte2)
	MSCBSayBar(nPosX+035, nPosY+(nTamLin*5), AllTrim(SB8->B8_LOTECTL), "N", "MB07", nTamLin*2, .F., .T., .F., , 2.6, 2, .T.)
	nPosY := nMargemS + ((nHeigth + nLinEsp) * (Int(k / nCols) % nLins))
	nPosX := nMargemD + ((nWidth + nColEsp) * (k % nCols))
	If k == nLins * nCols .And. k < nCols
		MSCBEND()
		MSCBBEGIN(1,1)
	EndIf
Next
MSCBEND()
MSCBCLOSEPRINTER() //Finaliza a conexão com a impressora
//PZebra(.F.)
Return

Static Function StringBar(cString, nTipoBar)
Local cStrBar := ""
Local nModulo := 0
Local nSoma   := 0
Local i

If nTipoBar == 1  // COD128 Subset A
	nSoma := PageCodBar("START", "CODE128", "B")[2]
	cString := STRTRAN(cString,' ','')
	For i := 1 To Len(cString)
		nSoma += PageCodBar(substr(cString,i,1), "CODE128", "B")[2] * i
	Next
	cStrBar := Chr(PageCodBar("START", "CODE128", "B")[3]) + cString + Chr(PageCodBar(nSoma % 103, "CODE128", "B")[3]) + Chr(PageCodBar("STOP", "CODE128", "B")[3])
EndIf

Return cStrBar

Static Function PageCodBar(xString, cTipo, cSubSet)
Local aRet     := {}
Local aPageCod := {}
Local nPos     := 0
Local i

If cTipo == "CODE128"
	If cSubSet $ "A/B"
		aAdd(aPageCod, {Chr(0225), 0, 0225})
		For i := 33 To 203
			aAdd(aPageCod, {Chr(i), i-32, i})
		Next
		If cSubSet == "B"
			aAdd(aPageCod, {"START", 104, 204})
			aAdd(aPageCod, {"STOP" , 0  , 206})
		EndIf
	EndIf
EndIf
If ValType(xString) == "C"
	nPos := aScan(aPageCod, {|xItem| xItem[1] == xString})
Else
	IF xString > 94
		xString +=100
		nPos := aScan(aPageCod, {|xItem| xItem[3] == xString})
	else
		nPos := aScan(aPageCod, {|xItem| xItem[2] == xString})
	EndIf
EndIf
aRet := Iif(nPos > 0, aClone(aPageCod[nPos]), {Nil, Nil, Nil})
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PZebra   ºAutor  ³Microsiga           º Data ³  28/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ativar/Desativa zebra                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ativar/Desativar impressora Zebra                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ lAcao	.T.-Ativa, .F.-Desativa                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PZebra(lAcao, cPerg)
Local aPorta := {}
Local cPorta := ""
Local aImp   := {}
Local cImp   := ""

If lAcao
	Pergunte(cPerg,.F.)
	aPorta  := RetBoxX1(cPerg,"01")
	cPorta  := aPorta[MV_PAR01]
	aImp    := RetBoxX1(cPerg,"02")
	cImp    := aImp[MV_PAR02]
	MSCBPRINTER(cImp,cPorta,,,.F.) // configura impressora
	MSCBCHKSTATUS(.F.) // Nao checar impressoa
Else
	MSCBCLOSEPRINTER() //Finaliza a conexão com a impressora
EndIf

Return

//OLE_SetProperty( oWord, oleWdVisible,   .F. ) // seta a propriedade de visibilidade do word
//OLE_SetProperty( oWord, oleWdPrintBack, .T. ) // seta a propriedade de impressão (segundo plano .T. ou .F.)
//OLE_SaveAsFile( _oWinWord, _cArquivo )
//OLE_SetProperty(oWord, oleWdPrintBack, .T. )
//OLE_SetProperty(oWord, 206, .F.)  // SetProperty 206 visibilidade da janela
//#define OLECREATELINK  400
//#define OLECLOSELINK   401
//#define OLEOPENFILE    403
//#define OLESAVEASFILE  405
//#define OLECLOSEFILE   406
//#define OLESETPROPERTY 412
//#define OLEWDVISIBLE   206
//#define WDFORMATTEXT   2
//#define WDFORMATPDF    17
