#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SET.CH"

User Function ETQENTURU(cAlias, nReg, nOpcx )

Local aArea    := GetArea()
Local cPerg  := "ETQENTURU"
Local lGerou := .F.
Private cTitulo  := "Impressão de etiquetas"
Private cAliasQry := ""
Private cPathSrv := "\Etiquetas"
Private cPathCli := "C:\Etiquetas\" //GetTempPath(.T.)
Private cFolder := DToS(Date()) + "_" + Replace(Time(), ":", "")+"\"

cPathCli += cFolder

cPathSrv :=  SuperGetMV("MV_PATHETQ", ,"\Etiquetas")

If Empty(cPathSrv)
	MsgAlert("Parametro MV_PATHETQ não existe ou não preenchido.", cTitulo)
	Return
EndIf

If UsePergs(cAlias, nReg)
	
	if Pergunte(cPerg, .T.)
	Processa( {|| 	GERAETIQ(MV_PAR01 ,MV_PAR02,MV_PAR03, @lGerou)},'Gerando Etiqueta...')
	Endif
	
Else
	cAliasQry := GetNextAlias()
	
	BSCDADOS(cAliasQry)
	
	//Count To nTotRecs
	(cAliasQry)->(dbGoTop())
	ProcRegua(RecCount())
	
	If !(cAliasQry)->(Eof())
		While !(cAliasQry)->(Eof())
			Processa( {|| GERAETIQ((cAliasQry)->DBC_CODPRO,(cAliasQry)->DBC_LOCAL,(cAliasQry)->DBC_XLOTE , @lGerou) },'Gerando Etiquetas...')
			(cAliasQry)->(DBSKIP())
		ENDDO
		
	EndIf
EndIf

If lGerou
AVISO("Etiquetas", "Etiquetas geradas na pasta " + CRLF + cPathCli, {"Ok"},2)
Endif

RestArea(aArea)

Return Nil


Static Function GERAETIQ(cCodPro,cArmPro,cLotPro,lGerou)

Local aParam   := {}
Local aStruct  := {}
Local oWord    := Nil
Local cNomeArq := ""
Local i := 0

ProcRegua(15)

if !ExistDir( cPathCli )
	if MakeDir( cPathCli ) != 0
		Alert( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
		return()
	endif
Endif

if !ExistDir( cPathCli )
	if MakeDir( cPathCli ) != 0
		Alert( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
		return()
	endif
endif


dbselectarea("SB8")
SB8->(DbSetOrder(3))
SB8->(DbSeek(xFilial("SB8") + cCodPro + cArmPro + cLotPro))

dbselectarea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + cCodPro))

cArq := AllTrim(SB1->B1_MKDOCET)
nPos := AT( ".", cArq )
cExt := RIGHT(cArq,len(cArq)-nPos+1)
cArq := LEFT(cArq,nPos-1)
cNomeArq := cArq+"_"+Alltrim(cLotPro)+"_"+DToS(Date()) + "_" + Replace(Time(), ":", "")+cExt

cPathEtq := cPathSrv+ "\" + AllTrim(SB1->B1_MKDOCET)

If !SB1->(Found())
	MsgAlert("Produto não encontrado.", cTitulo)
	Return()
ElseIf !SB8->(Found())
	MsgAlert("Lote/Armazém não encontrados na OP.", cTitulo)
	Return()
ElseIf File(cPathCli + cNomeArq ) .And. fErase(cPathCli + cNomeArq ) <> 0
	MsgAlert("Não foi possível excluir o arquivo temporário. Feche todos os documentos word.", cTitulo)
	Return()
ElseIf !CpyS2T(cPathEtq, cPathCli)
	MsgAlert("Não foi possível copiar o modelo do servidor. Arquivo "+AllTrim(SB1->B1_MKDOCET)+" não localizado ", cTitulo)
	Return()
Else
	aAdd(aParam, {"dDatabase", DtoC(dDatabase), "D"})
	aStruct := SB1->(DbStruct())
	For i := 1 To Len(aStruct)
		If  aStruct[i,1] $ 'B1_COD|B1_DESC|B1_TIPO|B1_UM|B1_QE|B1_CODBAR'
			aAdd(aParam, {aStruct[i,1], SB1->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
		EndIf
		
	Next
Endif

IncProc('Produto ' + cCodPro)

FRENAME( cPathCli +  AllTrim(SB1->B1_MKDOCET),cPathCli +  cNomeArq )

aStruct := SB8->(DbStruct())
For i := 1 To Len(aStruct)
	If  aStruct[i,1] $ 'B8_PRODUTO|B8_DTVALID|B8_LOTECTL'
		aAdd(aParam, {aStruct[i,1], SB8->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
	ELSEif aStruct[i,1] $ 'B8_DFABRIC'
		IF !EMPTY(cAliasQry)

			IF !EMPTY( (cAliasQry)->DBC_XDTFAB )
				aAdd(aParam, {aStruct[i,1], DTOC( STOD((cAliasQry)->DBC_XDTFAB )) , aStruct[i,2]})
			ELSE
				aAdd(aParam, {aStruct[i,1], SB8->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
			EndIf
		ELSE
			aAdd(aParam, {aStruct[i,1], SB8->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
		ENDIF
	EndIf
Next

aStruct := SM0->(DbStruct())
For i := 1 To Len(aStruct)
	aAdd(aParam, {aStruct[i,1], SM0->(FieldGet(FieldPos(aStruct[i,1]))), aStruct[i,2]})
Next

oWord := OLE_CreateLink('TMsOleWord97')
OLE_SetProperty(oWord, 206, .F.)  // SetProperty 206 visibilidade da janela
OLE_OpenFile(oWord, cPathCli + cNomeArq )

For i := 1 To Len(aParam)
	OLE_SetDocumentVar(oWord, aParam[i,1], aParam[i,2])
	If  aParam[i,1] $ 'B1_COD|B8_LOTECTL''
		OLE_SetDocumentVar(oWord, aParam[i,1] + "_BAR", StringBar(AllTrim(aParam[i,2]), 1))
	EndIf
Next

OLE_UpDateFields(oWord)
OLE_SaveFile(oWord)
OLE_CloseFile(oWord)
OLE_CloseLink(oWord)
ShellExecute("Open", cNomeArq ,"", cPathCli  , 3)

lGerou := .T.

Return


Static Function UsePergs(cAlias, nReg)
Local lRet		:= .T.

If ValType(cAlias) == "C" .And. !Empty(cAlias) .And. AliasInDic(cAlias) .And. ValType(nReg) == "N" .And. nReg > 0
	(cAlias)->(dbGoTo(nReg))
	If !(cAlias)->(Eof())
		lRet := .F.
	EndIf
EndIf

Return lRet


Static Function BSCDADOS(cAliasQry)
//Local ncount := 0
BeginSQL Alias cAliasQry
	
	SELECT *
	FROM %Table:DBC%
	WHERE DBC_FILIAL=%xFilial:DBC%
	AND DBC_HAWB= %Exp:DBA->DBA_HAWB%
	AND DBC_CODPRO <> ' '
	AND %NotDel%
	
EndSQL

aret := GetLastQuery()
Return


Static Function StringBar(cString, nTipoBar)
Local cStrBar := ""
//Local nModulo := 0
Local nSoma   := 0
Local i

If nTipoBar == 1  // COD128 Subset A
	nSoma := PageCodBar("START", "CODE128", "B")[2]
	For i := 1 To Len(cString)
		nSoma += PageCodBar(SubStr(cString, i, 1), "CODE128", "B")[2] * i
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
	IF xString > 95
		xString +=100
		nPos := aScan(aPageCod, {|xItem| xItem[3] == xString})
	else
		nPos := aScan(aPageCod, {|xItem| xItem[2] == xString})
	EndIf
EndIf
aRet := Iif(nPos > 0, aClone(aPageCod[nPos]), {Nil, Nil, Nil})
Return aRet
