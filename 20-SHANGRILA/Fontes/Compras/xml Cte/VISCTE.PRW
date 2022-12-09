#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"

User FuncTion VISCTE()
Local c_Titulo := "Consulta Resumida CT-e"
Local nOpca := 0
Local aButtons := {}
Local aPosObj     := {}
Local aObjects    := {}
Private cCadastro:= "Consulta Resumida CT-e"
errStr := ""
warnStr := ""
// Checa se o xml e referente a CTRC
cTag1 := "<cteProc"
cTag2 := "<CTe"
cTag3 := "<infCte"
cTag4 := "<infNF"

IF Alltrim(ZZS->ZZS_ESPECI) <> "CTE"
	Alert("Este Xml nao e CTE...")
	Return
EndIf

cXML     := ZZS->ZZS_XML
_cDoc    := ZZS->ZZS_DOC
_cSerie  := ZZS->ZZS_SERIE
_cCGC    := ZZS->ZZS_CGC

cXML := StrTran(cXML,CHR(13),'')
cXML := StrTran(cXML,CHR(10),'')

If '>' # Substr(cXML,Len(cXML),1)
	cXML := cXML +">"
EndIf
oXml := XmlParser ( cXML, "_", @errStr, @warnStr )

nPosTag1 := At(cTag1,cXML)
nPosTag2 := At(cTag2,cXML)
nPosTag3 := At(cTag3,cXML)
nPosTag4 := At(cTag4,cXML)

lCteproc := .F.
If nPosTag1 > 0
	lCteproc := .T.
EndIf
nVlrFrete :=_nBaseIcms:=_nValIcm:= 0
c_CNJEmit :=""
c_NomeEmit:=""
c_IEEmit  :=""
c_EstEmit :=""
c_RemCNPJ  := ""
c_NomeReme := ""
c_IERemet  := ""
c_EstRemet := ""
c_NomeDest := ""
c_IEDest   := ""
c_EstDest  := ""


If lCteproc
	c_Versao  := oXML:_CTEPROC:_CTE:_INFCTE:_VERSAO:TEXT
	c_CFOP    := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT
	c_NatOp   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NATOP:TEXT
	c_DigVal  := oXML:_CTEPROC:_PROTCTE:_INFPROT:_DIGVAL:TEXT
	c_TipoSer := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPSERV:TEXT
	c_UFIni   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT
	c_UFFim   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT
	c_MunINI  := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT
	c_MunFim  := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
	c_Modal   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_MODAL:TEXT
	
	c_CNJEmit := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
	c_NomeEmit:= oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT
	c_IEEmit  := ""
	If Type("oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_IE") <> "U"
		c_IEEmit  := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_IE:TEXT
	EndIf
	c_EstEmit := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
	If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF") <> "U"
		c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF:TEXT
	Else
		c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
	EndIf
	c_RemCNPJ  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	c_NomeReme := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT
	c_IERemet  := ""
	If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_IE") <> "U"
		c_IERemet  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_IE:TEXT
	EndIf	
	c_EstRemet := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_enderReme:_UF:TEXT
	
	c_NomeDest := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT
	c_IEDest   := ""
	If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_IE") <> "U"
		c_IEDest   := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_IE:TEXT
	EndIf	
	c_EstDest  := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
	
	nVlrFrete := Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)
	dEmissao  := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	_xDtEmiss := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	If Type("oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00") <> "U"
		_nValIcm := Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
		_nAliqIcm := Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
		_nBaseIcms:= Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
	EndIf
Else
	c_Versao  := oXML:_CTE:_INFCTE:_VERSAO:TEXT
	c_CFOP    := oXML:_CTE:_INFCTE:_IDE:_CFOP:TEXT
	c_NatOp   := oXML:_CTE:_INFCTE:_IDE:_NATOP:TEXT
	c_DigVal  := oXML:_CTE:_PROTCTE:_INFPROT:_DIGVAL:TEXT
	c_TipoSer := oXML:_CTE:_INFCTE:_IDE:_TPSERV:TEXT
	c_UFIni   := oXML:_CTE:_INFCTE:_IDE:_UFINI:TEXT
	c_UFFim   := oXML:_CTE:_INFCTE:_IDE:_UFFIM:TEXT
	c_MunINI  := oXML:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT
	c_MunFim  := oXML:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
	c_Modal   := oXML:_CTE:_INFCTE:_IDE:_MODAL:TEXT
	
	c_CNJEmit := oXML:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
	c_NomeEmit:= oXML:_CTE:_INFCTE:_EMIT:_XNOME:TEXT
	c_IEEmit  := oXML:_CTE:_INFCTE:_EMIT:_IE:TEXT
	c_EstEmit := oXML:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
	
	c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	c_NomeReme := oXML:_CTE:_INFCTE:_REM:_XNOME:TEXT
	c_IERemet  := oXML:_CTE:_INFCTE:_REM:_IE:TEXT
	c_EstRemet := oXML:_CTE:_INFCTE:_REM:_enderReme:_UF:TEXT
	
	c_NomeDest := oXML:_CTE:_INFCTE:_DEST:_XNOME:TEXT
	c_IEDest   := oXML:_CTE:_INFCTE:_DEST:_IE:TEXT
	c_EstDest  := oXML:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
	
	If Type("oXML:_CTE:_INFCTE:_DEST:_CPF") <> "U"
		c_DestCNPJ := oXML:_CTE:_INFCTE:_DEST:_CPF:TEXT
	Else
		c_DestCNPJ := oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
	EndIf
	c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	nVlrFrete := Val(oXml:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)
	_xDtEmiss := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	dEmissao  := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	If Type("oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00") <> "U"
		_nValIcm   := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
		_nAliqIcm  := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
		_nBaseIcms := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
	EndIf
EndIf   
aDocOrig := {}
aDocOrig := NFORIG(oXml,cXML,lCteproc,c_DestCNPJ)

c_Var0   := "Chave: " +ZZS->ZZS_CHAVE+ "         Numero CT-e: " + Transform(Val(_cDoc), "@E 999,999,999") + "       Versao XML: " +c_Versao

DEFINE FONT oFont1  NAME "Times New Roman"    SIZE 0,12  BOLD
DEFINE FONT oFont2  NAME "Times New Roman"    SIZE 0,14  BOLD
DEFINE FONT oFont3  NAME "Times New Roman"    SIZE 0,18  BOLD
DEFINE FONT oFont4  NAME "Times New Roman"    SIZE 0,12        UNDERLINE
DEFINE FONT oFont6  NAME "Times New Roman"    SIZE 0,10
DEFINE FONT oFont5  NAME "Mono AS"            SIZE 5,14
c_Var1 := "Dados do CT-e"
c_Var2 := "Numero"
c_Var3 := "Serie"
c_Var4 := "Data de Emissao"

c_Get2 := _cDoc
c_Get3 := _cSerie
c_Get4 := _xDtEmiss

c_Var5 := "Valores"
c_Var6 := "Valor Total Servico"
c_Var7 := "Base Calculo ICMS"
c_Var8 := "Valor ICMS"

c_Get6 := Transform(nVlrFrete , "@E 9999,999.99")
c_Get7 := Transform(_nBaseIcms, "@E 9999,999.99")
c_Get8 := Transform(_nValIcm  , "@E 9999,999.99")

c_Var9 := "Emitente"

c_Var10 := "CNPJ"
c_Var11 := "Nome/Razao Social"
c_Var12 := "Inscricao Estadual"
c_Var13 := "UF"

c_Get10 := c_CNJEmit
c_Get11 := c_NomeEmit
c_Get12 := c_IEEmit
c_Get13 := c_EstEmit

c_Var14 := "Remetente"

c_Get15 := c_RemCNPJ
c_Get16 := c_NomeReme
c_Get17 := c_IERemet
c_Get18 := c_EstRemet

c_Var19 := "Destinatario"

c_Get20 := c_DestCNPJ
c_Get21 := c_NomeDest
c_Get22 := c_IEDest
c_Get23 := c_EstDest


c_Var24 := "Caracteristicas"

c_Var25 := "Modal"
c_Var26 := "Tipo Servico"
c_Var27 := "Finalidade"
c_Var28 := "Forma"
c_Get25 := 	If(Alltrim(c_Modal)=="01","Rodoviario","Outros")
c_Get26 :=  c_TipoSer // := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPSERV:TEXT
c_Get27 := "CT-e Normal"
c_Get28 := "Normal"

c_Var29 := "CFOP"
c_Var30 := "Natureza da Prestacao"
c_Var31 := "Digest Value do CT-e"

c_Get29 := c_CFOP
c_Get30 := c_NatOp
c_Get31 := c_DigVal

c_Var32 := "Inicio da Prestacao"
c_Var33 := "Fim da Prestacao"

c_Get32 := c_MunINI + " " + c_UFIni
c_Get33 := c_MunFim + " " + c_UFFim
c_Var34 := Space(80)

nLin := 3
nCol := 5
aSvFolder:={}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aSvFolder[ n, 1 ] = aHeader                                               ³
//³ aSvFolder[ n, 2 ] = aCols                                                 ³
//³ aSvFolder[ n, 3 ] = Nr da linha da GetDados da pasta atual, variavel n    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa aSvFolder e Carrega variaveis para pasta Parceria               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSvFolder,{{},{},1})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader e aCols da Folder "Distribuicao"  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nFolder := 1
nUsado := 0
c_Alias := "SD1"
aHeader := {}
aCols   := {}
cContem := "D1_NFORI,D1_SERIORI,"
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek(c_Alias)
While !EOF() .And. X3_ARQUIVO == c_Alias
	If  Trim(X3_CAMPO) $ cContem
		nUsado := nUsado + 1
		cTitulo :=  TRIM(X3_TITULO)
		AADD(aHeader,{ cTitulo, X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, X3_VALID,;
		X3_USADO, X3_TIPO, X3_ARQUIVO } )
	EndIf
	Skip
EndDo
c_Alias := "SF2"
cContem := "F2_CLIENTE,F2_LOJA"
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek(c_Alias)
While !EOF() .And. X3_ARQUIVO == c_Alias
	If AllTrim(X3_CAMPO) <> "F2_CLIENT"
		DbSkip()
		Loop
	EndIf	
	If  Trim(X3_CAMPO) $ cContem 
		nUsado := nUsado + 1
		cTitulo :=  TRIM(X3_TITULO)
		AADD(aHeader,{ cTitulo, X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, X3_VALID,;
		X3_USADO, X3_TIPO, X3_ARQUIVO } )
	EndIf
	Skip
EndDo
c_Alias := "SA1"
cContem := "A1_NOME"
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek(c_Alias)
While !EOF() .And. X3_ARQUIVO == c_Alias
	If  Trim(X3_CAMPO) $ cContem
		nUsado := nUsado + 1
		cTitulo :=  TRIM(X3_TITULO)
		AADD(aHeader,{ cTitulo, X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, X3_VALID,;
		X3_USADO, X3_TIPO, X3_ARQUIVO } )
	EndIf
	Skip
EndDo
/*
c_Alias := "SF2"
cContem := "F2_XDTCOL"
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek(c_Alias)
While !EOF() .And. X3_ARQUIVO == c_Alias
	If  Trim(X3_CAMPO) $ cContem
		nUsado := nUsado + 1
		cTitulo :=  TRIM(X3_TITULO)
		AADD(aHeader,{ cTitulo, X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, X3_VALID,;
		X3_USADO, X3_TIPO, X3_ARQUIVO } )
	EndIf
	Skip
EndDo
*/
aadd(aCols,Array(nUsado+1))
nCnt  := Len(aDocOrig)
If nCnt > 0
	aCOLS := Array(nCnt,nUsado+1)
	nCnt := 0
	//              Doc     N.Fiscal Cliente Loja Nome Dt. Coleta
	// aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
	
	For nD:=1 To Len(aDocOrig)
		aCOLS[nD][1] := aDocOrig[nD][1]
		aCOLS[nD][2] := aDocOrig[nD][2]
		aCOLS[nD][3] := aDocOrig[nD][3]
		aCOLS[nD][4] := aDocOrig[nD][4]
		aCOLS[nD][5] := aDocOrig[nD][5]
		aCOLS[nD][6] := .f. //aDocOrig[nD][6]
//		aCOLS[nD][7] := .f. //Flag de Delecao
	Next
EndIf
Private nPosDoc := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="D1_NFORI"})
Private nPosIte := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="D1_SERIORI"})
/*
c_Alias  := "ZZL"
nUsado   := 0
aHeaEnt  := {}
aColEnt  := {}
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek(c_Alias)
While !EOF() .And. X3_ARQUIVO == c_Alias
	If x3_usado != " " .And. cNivel >= X3_NIVEL .And. ! AllTrim(X3_CAMPO) $ "ZZL_DESOCO" // .And. AllTrim(X3_CAMPO) $ cContem
		nUsado := nUsado + 1
		cTitulo :=  TRIM(X3_TITULO)
		AADD(aHeaEnt,{ cTitulo, X3_CAMPO, X3_PICTURE,;
		X3_TAMANHO, X3_DECIMAL, X3_VALID,;
		X3_USADO, X3_TIPO, X3_ARQUIVO } )
	EndIf
	Skip
EndDo
aadd(aColEnt,Array(nUsado+1))
_cDoc    := ZZS->ZZS_DOC
_cSerie  := ZZS->ZZS_SERIE
_cCGC    := ZZS->ZZS_CGC
cAlias   := "ZZL"
nCnt     := 0
dbSelectArea("ZZL")
dbSetOrder(5)
If DbSeek(xFilial("ZZL") + _cCGC +  _cDoc + _cSerie ,.F.)

	While !EOF() .And. ZZL_FILIAL+ZZL_EMISDC + ZZL_NRDC + ZZL_SERDC == ;
		xFilial("ZZL") + _cCGC +  _cDoc + _cSerie
	    nCnt := nCnt+1
		DbSkip()
	EndDo

	aColEnt := Array(nCnt,nUsado+1)
	nCnt    := 0
	DbSeek(xFilial("ZZL") + _cCGC +  _cDoc + _cSerie ,.F.)
	While !EOF() .And. ZZL_FILIAL+ZZL_EMISDC + ZZL_NRDC + ZZL_SERDC == ;
		xFilial("ZZL") + _cCGC +  _cDoc + _cSerie
		nCnt := nCnt+1
		nUsado:=0
		Select SX3
		Seek cAlias
		While !EOF() .And. X3_ARQUIVO == cAlias
			If x3_usado != " " .And. cNivel >= X3_NIVEL .And. ! AllTrim(X3_CAMPO) $ "ZZL_DESOCO"
				nUsado := nUsado+1
				aColEnt[nCnt][nUsado] :=  &(cAlias+"->"+x3_campo)
			EndIf
			Skip
		EndDo
		aColEnt[nCnt][nUsado+1] := .f. //Flag de Delecao
		dbSelectArea( cAlias )
		Skip
	EndDo
Else
	For nX := 1 To nUsado
		aColEnt[Len(aColEnt)][nX] := CriaVar(aHeaEnt[nX,2],.F.)
	Next nX
	aColEnt[Len(aColEnt)][nUsado+1] := .F.
	c_Var34 := "Nenhuma Ocorrencia foi encontrada..."
EndIf
*/
aSvFolder[nFolder][1] := aClone(aHeader)
aSvFolder[nFolder][2] := aClone(aCols)
aSvFolder[nFolder][3] := Len(aCols)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configura variaveis do Objeto Folder                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTitles   := {}
aPages	  := {"HEADER","HEADER"}
Aadd(aTitles,"&Resumo")
Aadd(aTitles,"&Doc.Origem")
//Aadd(aTitles,"&Ocorrencias Entrega")

aAdd(aButtons,{"PEDIDO"    ,{|| Cons_NFS(oBrow:aCols[oBrow:nAt][nPosDoc],oBrow:aCols[oBrow:nAt][nPosIte])},"Nota"})

// Inicia Montagem da Tela
aAdvSize := MsAdvSize()
aSize    := MsAdvSize()
AAdd( aObjects, { 100,065,.T.,.T. } )
AAdd( aObjects, { 100,100,.T.,.T.,.T. } )
aInfo := { aSize[1],aSize[2],aSize[3],aSize[4], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T. )
DEFINE MSDIALOG oDlg TITLE OemToAnsi(c_Titulo) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Objeto Folder                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder:=TFolder():New( aPosObj[2,1],aPosObj[2,2],aTitles,aPages,oDlg,,,,.T.,.T.,aPosObj[2,3],aPosObj[2,4])
aPosGetD := { 5, 5, aPosObj[ 2, 4 ] - 18, aPosObj[ 2, 3 ] - 8 }
oFolder:Align := CONTROL_ALIGN_ALLCLIENT

oFld1 := oFolder:aDialogs[1]
oFld2 := oFolder:aDialogs[2]
//oFld3 := oFolder:aDialogs[3]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria controles dentro do scrollbox                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPanelA:= TScrollBox():New(oFld1,10,10,200,200,.T.,.T.,.T.) 
oPanelA:Align := CONTROL_ALIGN_ALLCLIENT

//oPanelB:= TScrollBox():New(oFld3,10,10,35,200,.T.,.T.,.T.) 
//oPanelB:Align := CONTROL_ALIGN_TOP

//@5,20 Say oVar34 VAR c_Var34 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelB

aCpoHead:= {}
oBrow   := MsNewGetDados():New(004,090,058,065,0,"","",/*inicpos*/,aCpoHead,/*freeze*/,120,/*fieldok*/,/*superdel*/,/*delok*/,oFld2,aHeader,aCols)		
aCpoHd  := {}

//oEntreg := MsNewGetDados():New(004,090,058,065,0,"","",/*inicpos*/,aCpoHd,/*freeze*/,120,/*fieldok*/,/*superdel*/,/*delok*/,oFld3,aHeaEnt,aColEnt)
// Mostrar o Conteudo dos campos da Getdados
/*
oEntreg:bChange := { ||	fAtu01(	@oEntreg:aCols	,;	// 05 -> aCols utilizado na GetDados
								aHeaEnt 		,;	// 06 -> aHeader utilizado na GetDados
	  					       )                ,;
							oEntreg:Goto( oEntreg:OBROWSE:NAT ),;
							oEntreg:oBrowse:Refresh();
		  			}
*/		  			
oBrow:oBrowse:Align   := CONTROL_ALIGN_ALLCLIENT
//oEntreg:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

@nLin,nCol+20 Say oVar0 VAR c_Var0 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLUE Font oFont2 OF oPanelA
nLin += 10
@ nLin, nCol TO nLin+10 ,aAdvSize[5]-700 LABEL '' OF oPanelA   PIXEL
@nLin,nCol+250 Say oVar1 VAR c_Var1 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_HRED Font oFont3 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar2 VAR c_Var2 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+150 Say oVar3 VAR c_Var3 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+250 Say oVar4 VAR c_Var4 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet2 VAR c_Get2 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+150 Say oGet3 VAR c_Get3 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+250 Say oGet4 VAR c_Get4 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
nLin += 10
@ nLin, nCol TO nLin+10 ,aAdvSize[5]-700 LABEL '' OF oPanelA   PIXEL
@nLin,nCol+20 Say oVar5 VAR c_Var5 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_HRED Font oFont3 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar6 VAR c_Var6 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+150 Say oVar7 VAR c_Var7 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+250 Say oVar8 VAR c_Var8 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet6 VAR c_Get6 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+150 Say oGet7 VAR c_Get7 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+250 Say oGet8 VAR c_Get8 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
nLin += 10
@ nLin, nCol TO nLin+10 ,aAdvSize[5]-700 LABEL '' OF oPanelA   PIXEL
@nLin,nCol+20 Say oVar9 VAR c_Var9 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_HRED Font oFont3 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar10 VAR c_Var10 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+150 Say oVar11 VAR c_Var11 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+350 Say oVar12 VAR c_Var12 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+500 Say oVar13 VAR c_Var13 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet10 VAR c_Get10 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+150 Say oGet11 VAR c_Get11 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+350 Say oGet12 VAR c_Get12 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+500 Say oGet13 VAR c_Get13 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
nLin += 10
@ nLin, nCol TO nLin+10 ,aAdvSize[5]-700 LABEL '' OF oPanelA   PIXEL
@nLin,nCol+20 Say oVar14 VAR c_Var14 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_HRED Font oFont3 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar10 VAR c_Var10 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+150 Say oVar11 VAR c_Var11 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+350 Say oVar12 VAR c_Var12 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+500 Say oVar13 VAR c_Var13 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet15 VAR c_Get15 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+150 Say oGet16 VAR c_Get16 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+350 Say oGet17 VAR c_Get17 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+500 Say oGet18 VAR c_Get18 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
nLin += 10
@ nLin, nCol TO nLin+10 ,aAdvSize[5]-700 LABEL '' OF oPanelA   PIXEL
@nLin,nCol+20 Say oVar19 VAR c_Var19 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_HRED Font oFont3 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar10 VAR c_Var10 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+150 Say oVar11 VAR c_Var11 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+350 Say oVar12 VAR c_Var12 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+500 Say oVar13 VAR c_Var13 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet20 VAR c_Get20 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+150 Say oGet21 VAR c_Get21 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+350 Say oGet22 VAR c_Get22 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+500 Say oGet23 VAR c_Get23 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
nLin += 10
@ nLin, nCol TO nLin+10 ,aAdvSize[5]-700 LABEL '' OF oPanelA   PIXEL
@nLin,nCol+20 Say oVar24 VAR c_Var24 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_HRED Font oFont3 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar25 VAR c_Var25 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+150 Say oVar26 VAR c_Var26 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+350 Say oVar27 VAR c_Var27 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+500 Say oVar28 VAR c_Var28 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet25 VAR c_Get25 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+150 Say oGet26 VAR c_Get26 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+350 Say oGet27 VAR c_Get27 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+500 Say oGet28 VAR c_Get28 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar29 VAR c_Var29 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+150 Say oVar30 VAR c_Var30 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+350 Say oVar31 VAR c_Var31 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet29 VAR c_Get29 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+150 Say oGet30 VAR c_Get30 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+350 Say oGet31 VAR c_Get31 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
nLin += 15
@nLin,nCol+020 Say oVar32 VAR c_Var32 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
@nLin,nCol+500 Say oVar33 VAR c_Var33 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont2 OF oPanelA
nLin += 10
@nLin,nCol+020 Say oGet32 VAR c_Get32 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA
@nLin,nCol+500 Say oGet33 VAR c_Get33 Picture "@!" SIZE aAdvSize[5],8 PIXEL COLOR CLR_BLACK Font oFont1 OF oPanelA

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca:=1,oDlg:End()},{||oDlg:End()},,aButtons)

Return



Static FuncTion NFORIG(oXml,cXML,lCteproc,c_DestCNPJ)
Local a_Docs := {}
DbSelectArea("SA1")
DbSetOrder(3)
DbSeek(xFilial("SA1") + c_DestCNPJ)
c_A1_COD  := SA1->A1_COD
c_A1_LOJA := SA1->A1_LOJA
c_A1_NOME := SA1->A1_NOME

If lCteproc
	CONOUT(" NFORIG CteProc...")
	n_Chave := AT("<infNFe><chave>",cXML) // Verifica se foi informado a chave da NF-e na Origem
	If n_Chave > 0
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE") <> "U"
			aRef := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cXMLNFRef := aRef[nI]:_CHAVE:TEXT // oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE[nI]:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cSerRef   := Substr(cXMLNfRef,23,3)
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
				cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
				cSerRef   := Substr(cXMLNfRef,23,3)
//				cSerRef   := STRTRAN(cSerRef,"0","")
//				cSerRef   := Substr(cSerRef+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
		EndIf
	Else
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF") <> "U"
			aRef := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
					cSerRef   := aRef[nI]:_SERIE:TEXT
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
		EndIf
	EndIf
Else
	If Type("oXml:_CTE:_INFCTE:_REM:_INFNF:_NDOC") <> "U"
		aRef := oXml:_CTE:_INFCTE:_REM:_INFNF
		If ValType(aRef) == "A"
			For nI := 1 To Len(aRef)
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef[nI]:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(cSerRef+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			Next
		Else
			cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
			cSerRef   := aRef:_SERIE:TEXT
			cSerRef   := STRTRAN(cSerRef,"0","")
			cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
			aadd(a_Docs,{cDocRef,cSerRef})
		EndIf
	Else
		Conout(" NFORIG infCte...")
	EndIf
EndIf  
xx := "'"
If Len(a_Docs) == 0 // Se nao achou
	If Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE") <> "U" // Existe tag INFCTENORM
		a_Ref := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE 
		If ValType(a_Ref) == "A"
		   If Len(a_Ref) > 0
		   	For nA := 1 To Len(a_Ref)
			   	cXMLNfRef := a_Ref[nA]:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cDocRef   := StrZero(Val(cDocRef),9)
					cSerRef   := Substr(cXMLNfRef,23,3)
			   	aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
			   Next	
		   Else
				cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
				cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
				cDocRef   := StrZero(Val(cDocRef),9)
				cSerRef   := Substr(cXMLNfRef,23,3)
				//aadd(a_Docs,{cDocRef,cSerRef})
				aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
			EndIf	
		Else
				cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
				cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
				cDocRef   := StrZero(Val(cDocRef),9)
				cSerRef   := Substr(cXMLNfRef,23,3)
				//aadd(a_Docs,{cDocRef,cSerRef})
				aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
		EndIf	
	Else      
		xx := "1"                                                        
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF") <> "U"
			a_Ref := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF
			If ValType(a_Ref) == "A"
				If Len(a_Ref) > 0            
				   For nA := 1 To Len(a_Ref)
						cDocRef   := a_Ref[nA]:_NDOC:TEXT
						cSerRef   := a_Ref[nA]:_SERIE:TEXT
						cDocRef   := StrZero(Val(cDocRef),9)
						cSerRef   := StrZero(Val(cSerRef),3)
						aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})		
					Next
				Else
					cDocRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT
					cDocRef   := StrZero(Val(cDocRef),9)
					cSerRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT
					aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
				EndIf	
			Else
					cDocRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT
					cDocRef   := StrZero(Val(cDocRef),9)
					cSerRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT
					aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
			EndIf	
		EndIf
	EndIf
EndIf

For nD := 1 To Len(a_Docs)
	c_DocRef := a_Docs[nD][1]
	c_SerRef := a_Docs[nD][2]
	//              Doc     N.Fiscal Cliente Loja Nome Dt. Coleta
	// aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
	a_Docs[nD][3] := c_A1_COD
	a_Docs[nD][4] := c_A1_LOJA
	a_Docs[nD][5] := c_A1_NOME
//	DbSelectArea("SF2")
//	DbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA
//	DbSeek(xFilial("SF2") + c_DocRef + c_SerRef + c_A1_COD + c_A1_LOJA )
	a_Docs[nD][6] := Ctod("") // SF2->F2_XDTCOL 
Next
xx:="1"
Return(a_Docs)
                                 

Static Function Cons_NFS(c_NOTA,c_SERIE)
Local aSavSX3   := SX3->(GetArea())
Local aSavSD2   := SD2->(GetArea())
Local cCadastro := "Consulta N.Fiscal"

If Empty(c_NOTA) .And. Empty(c_SERIE)
	MsgInfo("Não há nota fiscal a visualizar",cCadastro)
	Return
Endif
c_NOTA := StrZero(Val(c_NOTA),9)                                      
dbSelectArea("SD2")
DbSetOrder(3) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
If dbSeek(xFilial("SD2") + c_NOTA + c_SERIE )
	C_NFSaida(SD2->(Recno()))
Else
	MsgInfo("Nenhuma nota fiscal encontrada",cCadastro)
	Return
EndIf

Return


Static Function C_NFSaida(nRecNo)
Local aSavSD2 := SD2->(GetArea())
dbSelectArea("SD2")
dbSetOrder(3)
dbGoTo(nRecNo)
A920NFSAI("SD2",nRecNo,0)
RestArea(aSavSD2)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fAuxAll  ºAutor  ³Francisco C Godinho º Data ³  24/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ bsetget da getdados para atualizar os gets do item posicio º±±
±±º          ³ nado.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static FuncTion fAtu01(_aCols,aHeaEnt)
Local nPosOco := GdFieldPos( "ZZL_CODOCO", aHeaEnt )
c_Var34	 := Space(80)
c_CodOco := _aCols[n][nPosOco]
DbSelectArea("ZZI")
DbSetOrder(1) // ZZI_FILIAL+ZZ_COD
If DbSeek(xFilial("ZZI") + c_CodOco)
  c_Var34	:= "Ocorrencia: " + ZZI->ZZI_DESC
Else
    c_Var34	:= "Nenhuma Ocorrencia foi encontrada..."
EndIf
oVar34:Refresh()

Return
