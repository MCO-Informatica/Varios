#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOLE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraDoc   º Autor ³Norbert Waage Juniorº Data ³  12/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de geracao de documentacao automatica utilizando     º±±
±±º          ³integracao com o Ms-Word.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³aTabelas - Array com os nomes das tabelas para documentacao º±±
±±º          ³lImpPar  - Logico que indica se os parametros de usuario de-º±±
±±º          ³           vem ser impressos ou nao.                        º±±
±±º          ³cFile    - Localizacao completa do nome do arquivo modelo doº±±
±±º          ³           MS-Word, contendo as macros comentadas ao final  º±±
±±º          ³           deste fonte.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GeraDoc(aTabelas,lImpPar,cFile)
Local aArea     := GetArea()
Local hWord 	:=	NIL
Local cPathIni	:= GetSrvProfString("RootPath", "")+GetSrvProfString("Startpath", "")
Local nX
Local cFiltSX2  := ''
Local bFiltSX2  := NIL

Default cFile	:= cGetFile("Modelos Word | *.dot","Selecione o modelo Ms-Word",,cPathIni,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE )
Default lImpPar := .F.


dbSelectArea( 'SX2' )
cFiltSX2 := dbFilter()
bFiltSX2 := IIf( !Empty( cFiltSX2 ), &( '{ || ' + AllTrim( cFiltSX2 ) + ' }' ), '' )
dbClearFilter()
dbGoTop()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicionamento dos dicionarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SIX->(dbSetOrder(1))
SX2->(dbSetOrder(1))
SX7->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa conexao com o MsWord³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cFile)
	PrepLink(@hWord,cFile)
Else
	MsgAlert("Arquivo inválido","Integração")
	Return NIL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime tabelas selecionadas pelo usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aTabelas)
	Tabela(@hWord,AllTrim(Upper(aTabelas[nX])))
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime parametros se solicidado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpPar
	Params(@hWord)
EndIf

If SubStr(Trim( oApp:cVersion ) ,1,3) == "MP8"
	//	OLE_CloseLink( hWord ,.F.)
Else
	//	OLE_CloseLink( hWord )
EndIf

dbSelectArea( 'SX2' )
If !Empty( cFiltSX2 )
	dbSetFilter( bFiltSX2, cFiltSX2 )
EndIf

RestArea( aArea )
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrepLink  º Autor ³Norbert Waage Juniorº Data ³  12/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Estabelece conexao com o MsWord, abrindo o arquivo recebido º±±
±±º          ³em parametro                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico o                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrepLink(hWord,cFile)

//Cria o link de comunicacao
hWord := OLE_CreateLink('TMsOleWord97')

//Abre o arquivo e ajusta as suas propriedades
OLE_OPENFILE(hWord,cFile, .T.)
OLE_SetProperty( hWord, oleWdVisible,   .T. )
OLE_SetProperty( hWord, oleWdPrintBack, .T. )
OLE_SetProperty( hWord, oleWdWindowState, "MAX" )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tabela    º Autor ³Norbert Waage Juniorº Data ³  13/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de impressao dos dados de cada tabela                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tabela(hWord,cTabela)

Local aValids	:=	{}
Local lCabec	:= .F.
Local cModo

If !SX2->(dbSeek(cTabela))
	Return NIL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Modo da tabela por extenso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cModo	:= AllTrim(SX2->X2_MODO)
cModo2	:= "Uso: [" + Iif(cModo=="E","X"," ") + "]Exclusivo [" + Iif(cModo=="C","X"," ") + "]Compart."

SX3->(dbSeek(cTabela))

While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == cTabela
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime somente os campos de usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SX3->X3_PROPRI == "U"
		
		If !lCabec
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta Cabecalho³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			OLE_SetDocumentVar(hWord, "cTabNome"	,AllTrim(SX2->X2_CHAVE))
			OLE_SetDocumentVar(hWord, "cTabDesc"	,AllTrim(SX2->X2_NOME))
			OLE_SetDocumentVar(hWord, "cTabModo"	,cModo2)
			OLE_ExecuteMacro(hWord,"MsCriaCabTab")
			lCabec := .T.
		EndIf
		
		Campo(@hWord,@aValids)
		
	EndIf
	
	SX3->(dbSkip())
	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Termina a tabela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCabec
	OLE_ExecuteMacro(hWord,"Rodape")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime validacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Valids(@hWord,aValids)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime Indices³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Indices(@hWord,cTabela)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Campo     º Autor ³Norbert Waage Juniorº Data ³  14/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Imprime detalhes dos campos e armazena as validacoes        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Campo(hWord,aValids)

Local cIniPad	:= " "
Local cGatilho	:= " "
Local cF3		:= " "
Local cCombo	:= " "
Local cWhen		:= " "
Local cValid	:= " "
Local cObrig	:= " "
Local cVisual	:= " "
Local cContext	:= " "
Local cCampo	:= AllTrim(SX3->X3_CAMPO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializador padrao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SX3->X3_RELACAO)
	aAdd(aValids,{cCampo,"1",AllTrim(SX3->X3_RELACAO)})
	cIniPad := "X"
EndIf

//ÚÄÄÄÄÄÄÄÄ¿
//³Gatilhos³
//ÀÄÄÄÄÄÄÄÄÙ
If SX7->(dbSeek(cCampo))
	
	While !SX7->(EOF()) .AND. SX7->X7_CAMPO == cCampo
		aAdd(aValids,{cCampo,"2",AllTrim(SX7->X7_REGRA)})
		SX7->(dbSkip())
	End
	
	cGatilho := "X"
	
EndIf

//ÚÄÄÄÄÄÄÄÄ¿
//³Campo F3³
//ÀÄÄÄÄÄÄÄÄÙ
If !Empty(SX3->X3_F3)
	aAdd(aValids,{cCampo,"3",AllTrim(SX3->X3_F3)})
	cF3 := "X"
EndIf

//ÚÄÄÄÄÄ¿
//³Combo³
//ÀÄÄÄÄÄÙ
If !Empty(SX3->X3_CBOX)
	aAdd(aValids,{cCampo,"4",AllTrim(SX3->X3_CBOX)})
	cCombo := "X"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³Campo When³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SX3->X3_WHEN)
	aAdd(aValids,{cCampo,"5",AllTrim(SX3->X3_WHEN)})
	cWhen := "X"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³Validacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SX3->X3_VALID) .OR. !Empty (SX3->X3_VLDUSER)
	
	If !Empty(SX3->X3_VALID)
		aAdd(aValids,{cCampo,"6",AllTrim(SX3->X3_VALID)})
	EndIf
	
	If !Empty(SX3->X3_VLDUSER)
		aAdd(aValids,{cCampo,"6",AllTrim(SX3->X3_VLDUSER)})
	EndIf
	
	cValid := "X"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campo Obrigatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX3->( X3Obrigat(cCampo) )
	cObrig := "X"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campo Visual³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ((SX3->X3_VISUAL)== "V")
	cVisual := "X"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campo Contexto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ((SX3->X3_CONTEXT)=="V")
	cContext := "X"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza word³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord, "cX3Nome"		,cCampo)
OLE_SetDocumentVar(hWord, "cX3Tipo"		,AllTrim(SX3->X3_TIPO))
OLE_SetDocumentVar(hWord, "cX3TamI"		,AllTrim(Str(SX3->X3_TAMANHO)))
OLE_SetDocumentVar(hWord, "cX3TamD"		,AllTrim(Str(SX3->X3_DECIMAL)))
OLE_SetDocumentVar(hWord, "cX3Tit" 		,AllTrim(SX3->X3_TITULO))
OLE_SetDocumentVar(hWord, "cX3Desc"		,AllTrim(SX3->X3_DESCRIC))
OLE_SetDocumentVar(hWord, "cX3Pict"		,AllTrim(SX3->X3_PICTURE))
OLE_SetDocumentVar(hWord, "cX3Inip"		,cIniPad)
OLE_SetDocumentVar(hWord, "cX3Gati"		,cGatilho)
OLE_SetDocumentVar(hWord, "cX3F3"		,cF3)
OLE_SetDocumentVar(hWord, "cX3Comb"		,cCombo)
OLE_SetDocumentVar(hWord, "cX3When"		,cWhen)
OLE_SetDocumentVar(hWord, "cX3Vali"		,cValid)
OLE_SetDocumentVar(hWord, "cX3Obrig"	,cObrig)
OLE_SetDocumentVar(hWord, "cX3Visual"	,cVisual)
OLE_SetDocumentVar(hWord, "cX3Context"	,cContext)

OLE_ExecuteMacro(hWord,"LinCampo")

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Valids    º Autor ³Norbert Waage Juniorº Data ³  15/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Imprime as validacoes dos campos da tabela atual            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Valids(hWord,aValids)

Local nX	:=	0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Aborta rotina se não houverem validacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aValids) == 0
	Return NIL
EndIf

OLE_ExecuteMacro(hWord,"CriaCabVal")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime validacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aValids)
	
	OLE_SetDocumentVar(hWord, "cVldCpo"		,aValids[nX][1])
	OLE_SetDocumentVar(hWord, "cVldAtri"	,aValids[nX][2])
	OLE_SetDocumentVar(hWord, "cVldCont"	,aValids[nX][3])
	
	OLE_ExecuteMacro(hWord,"LinValid")
	
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime rodape de detalhe³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_ExecuteMacro(hWord,"Rodape")

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Params    º Autor ³Norbert Waage Juniorº Data ³  14/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Imprime parametros criados pelo usuario                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Params(hWord)

Local cArq		:=	""
Local cParDesc	:=	""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria indice temporario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX6")
cArq := CriaTrab(Nil,.F.)
IndRegua("SX6",cArq,"X6_PROPRI+X6_FIL+X6_VAR")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se houver parametros de usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dbSeek("U")
	
	OLE_ExecuteMacro(hWord,"CriaCabPar")
	
	While !SX6->(EOF()) .AND. SX6->X6_PROPRI == "U"
		
		cParDesc := AllTrim(SX6->X6_DESCRIC) + AllTrim(SX6->X6_DESC1) + AllTrim(SX6->X6_DESC2)
		
		OLE_SetDocumentVar(hWord, "cParNome"	,AllTrim(SX6->X6_VAR))
		OLE_SetDocumentVar(hWord, "cParTipo"	,AllTrim(SX6->X6_TIPO))
		OLE_SetDocumentVar(hWord, "cParCont"	,AllTrim(SX6->X6_CONTEUD))
		OLE_SetDocumentVar(hWord, "cParDesc"	,cParDesc)
		
		OLE_ExecuteMacro(hWord,"LinPar")
		
		SX6->(dbSkip())
		
	End
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apaga indice temporario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArq+OrdBagExt())
OLE_ExecuteMacro(hWord,"FimTab")

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Indices   º Autor ³Norbert Waage Juniorº Data ³  15/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de impressao dos indices especificos                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Indices(hWord,cTabela)

Local lCabec := .F.

If SIX->(dbSeek(cTabela))
	
	While !SIX->(EOF()) .AND. SIX->INDICE == cTabela
		
		If SIX->PROPRI == "U"
			
			If !lCabec
				OLE_ExecuteMacro(hWord,"CriaCabInd")
				lCabec := .T.
			EndIf
			
			OLE_SetDocumentVar(hWord, "cIndOrd"		,AllTrim(SIX->ORDEM))
			OLE_SetDocumentVar(hWord, "cIndChav"	,AllTrim(SIX->CHAVE))
			OLE_ExecuteMacro(hWord,"LinInd")
			
		EndIf
		
		SIX->(dbSkip())
		
	End
	
	If lCabec
		OLE_ExecuteMacro(hWord,"FimTab")
	EndIf
	
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Estas macros devem existir no documento trabalhado
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Dim nLinhas As Integer

Sub msCriaCabTab()
'
' msCriaTab Macro
' Macro criada 12/8/2005 por Norbert Waage Jr

Dim nTabAtu As Integer
Dim nLinAtu As Integer
Dim cComp As String
Dim cExc As String
Dim RangeX As Range


'Cria a tabela com nome e descricao da tabela do SX2
ActiveDocument.Tables.Add Selection.Range, 1, 5, wdWord9TableBehavior, wdAutoFitFixed
nTabAtu = ActiveDocument.Tables.Count

With ActiveDocument.Tables(nTabAtu)

'.Range.Fields.Add Selection.Range, , "DOCVARIABLE cTabModo"
.Rows.Height = InchesToPoints(0.18)
.Range.Font.Name = "Verdana"
.Range.Font.Size = 10
.Range.Font.Color = wdColorWhite
.Range.Font.Bold = True
.Range.Shading.BackgroundPatternColorIndex = wdWhite

'Coluna Tabela
.Cell(1, 1).Width = CentimetersToPoints(3.12)
.Cell(1, 1).Shading.BackgroundPatternColorIndex = wdGray50
.Cell(1, 1).Range.Text = "Tabela:"
.Cell(1, 1).Select

'Coluna Nome da tabela
Selection.MoveRight wdCell
.Cell(1, 2).Width = CentimetersToPoints(1.52)
.Cell(1, 2).Range.Font.Color = wdColorBlack
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cTabNome", PreserveFormatting:=True

'Coluna Descricao
.Cell(1, 3).Width = CentimetersToPoints(2.54)
.Cell(1, 3).Shading.BackgroundPatternColorIndex = wdGray50
.Cell(1, 3).Range.Text = "Descrição"
.Cell(1, 3).Select

'Coluna Descricao da tabela
Selection.MoveRight wdCell
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cTabDesc", PreserveFormatting:=True
.Cell(1, 4).Range.Font.Color = wdColorBlack
.Cell(1, 4).Width = CentimetersToPoints(11.53)
.Cell(1, 4).Select

'Coluna Modo de acesso
Selection.MoveRight
.Cell(1, 5).Width = CentimetersToPoints(6.23)
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cTabModo", PreserveFormatting:=True
.Cell(1, 5).Range.Font.Color = wdColorBlack
.Cell(1, 5).Range.Font.Bold = False

End With

'Encerra tabela
Call FimTab

'Cria a tabela e define suas propriedades
ActiveDocument.Tables.Add Selection.Range, 1, 6, wdWord9TableBehavior, wdAutoFitFixed

'Atualiza contador de tabelas
nTabAtu = ActiveDocument.Tables.Count

'Dimensiona tabela e suas propriedades
With ActiveDocument.Tables(nTabAtu)

.Rows.Height = InchesToPoints(0.18)
.Range.Font.Name = "Verdana"
.Range.Font.Size = 10
.Range.Font.Color = wdColorWhite
.Range.Font.Bold = True
.Range.Shading.BackgroundPatternColorIndex = wdGray50

'Ajusta Largura das colunas
.Cell(1, 1).Width = CentimetersToPoints(3.12)
.Cell(1, 2).Width = CentimetersToPoints(1.52)
.Cell(1, 3).Width = CentimetersToPoints(2.54)
.Cell(1, 4).Width = CentimetersToPoints(11.53)
.Cell(1, 5).Width = CentimetersToPoints(2.75)
.Cell(1, 6).Width = CentimetersToPoints(3.48)

End With

'Cria subcolunas do tamanho
ActiveDocument.Tables(nTabAtu).Columns(3).Cells(1).Split 2, 2
ActiveDocument.Tables(nTabAtu).Columns(3).Cells(2).Range.Text = "Int."
ActiveDocument.Tables(nTabAtu).Columns(4).Cells(2).Range.Text = "Dec."

'Cria subcolunas da descricao
ActiveDocument.Tables(nTabAtu).Columns(5).Cells(1).Split 2, 2
ActiveDocument.Tables(nTabAtu).Columns(5).Cells(2).Range.Text = "Resumida"
ActiveDocument.Tables(nTabAtu).Columns(6).Cells(2).Range.Text = "Completa"

'Cria subcolunas dos atributos
ActiveDocument.Tables(nTabAtu).Columns(8).Cells(1).Split 2, 9
ActiveDocument.Tables(nTabAtu).Columns(8).Cells(2).Range.Text = "1"
ActiveDocument.Tables(nTabAtu).Columns(9).Cells(2).Range.Text = "2"
ActiveDocument.Tables(nTabAtu).Columns(10).Cells(2).Range.Text = "3"
ActiveDocument.Tables(nTabAtu).Columns(11).Cells(2).Range.Text = "4"
ActiveDocument.Tables(nTabAtu).Columns(12).Cells(2).Range.Text = "5"
ActiveDocument.Tables(nTabAtu).Columns(13).Cells(2).Range.Text = "6"
ActiveDocument.Tables(nTabAtu).Columns(14).Cells(2).Range.Text = "7"
ActiveDocument.Tables(nTabAtu).Columns(15).Cells(2).Range.Text = "8"
ActiveDocument.Tables(nTabAtu).Columns(16).Cells(2).Range.Text = "9"
ActiveDocument.Tables(nTabAtu).Columns(16).Cells(2).Select

'Cria nova linha
Selection.MoveRight wdCell

'Une titulos que foram repartidos
ActiveDocument.Tables(nTabAtu).Cell(1, 3).Merge ActiveDocument.Tables(nTabAtu).Cell(1, 4)
ActiveDocument.Tables(nTabAtu).Cell(1, 4).Merge ActiveDocument.Tables(nTabAtu).Cell(1, 5)
ActiveDocument.Tables(nTabAtu).Cell(1, 6).Merge ActiveDocument.Tables(nTabAtu).Cell(1, 14)

'Insere títulos nas colunas primarias
With ActiveDocument.Tables(nTabAtu)

.Cell(1, 1).Range.Text = "Campo"
.Cell(1, 2).Range.Text = "Tipo"
.Cell(1, 3).Range.Text = "Tamanho"
.Cell(1, 4).Range.Text = "Descrição"
.Cell(1, 5).Range.Text = "Picture"
.Cell(1, 6).Range.Text = "Atributos"

End With

nLinhas = 1

End Sub

Sub LinCampo()

Dim nTabAtu As Integer
Dim nRow As Integer

If nLinhas > 1 Then
nTabAtu = ActiveDocument.Tables.Count
ActiveDocument.Tables(nTabAtu).Rows.Add
End If

nTabAtu = ActiveDocument.Tables.Count
nRow = ActiveDocument.Tables(nTabAtu).Rows.Count

If nLinhas = 1 Then
With ActiveDocument.Tables(nTabAtu)
For nr = 1 To 16
.Cell(nRow, nr).Shading.BackgroundPatternColorIndex = wdWhite
.Cell(nRow, nr).Range.Font.Color = wdColorBlack
.Cell(nRow, nr).Range.Font.Bold = False
Next
End With
End If


With ActiveDocument.Tables(nTabAtu)

'Ajusta Largura das colunas
.Cell(nRow, 2).Select
Selection.MoveLeft wdCell

'Nome
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Nome", PreserveFormatting:=True

'Tipo
.Cell(nRow, 1).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Tipo", PreserveFormatting:=True

'Tamanho int
.Cell(nRow, 2).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3TamI", PreserveFormatting:=True

'Tamanho dec
.Cell(nRow, 3).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3TamD", PreserveFormatting:=True

'Titulo
.Cell(nRow, 4).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Tit", PreserveFormatting:=True

'Descricao
.Cell(nRow, 5).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Desc", PreserveFormatting:=True

'Picture
.Cell(nRow, 6).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Pict", PreserveFormatting:=True

'Inicializador padrao
.Cell(nRow, 7).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Inip", PreserveFormatting:=True

'Gatilho
.Cell(nRow, 8).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Gati", PreserveFormatting:=True

'F3
.Cell(nRow, 9).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3F3", PreserveFormatting:=True

'Compo
.Cell(nRow, 10).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Comb", PreserveFormatting:=True

'When
.Cell(nRow, 11).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3When", PreserveFormatting:=True

'Valids
.Cell(nRow, 12).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Vali", PreserveFormatting:=True

'Obrigatorio
.Cell(nRow, 13).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Obrig", PreserveFormatting:=True

'Visual
.Cell(nRow, 14).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Visual", PreserveFormatting:=True

'Context
.Cell(nRow, 15).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cX3Context", PreserveFormatting:=True

End With

nLinhas = nLinhas + 1

End Sub

Sub LinValid()

Dim nTabAtu As Integer
Dim nRow As Integer

nTabAtu = ActiveDocument.Tables.Count
nRow = ActiveDocument.Tables(nTabAtu).Rows.Count

With ActiveDocument.Tables(nTabAtu)

.Rows.Add
nRow = .Rows.Count

If nRow = 2 Then

.Rows(nRow).Shading.BackgroundPatternColorIndex = wdWhite
.Rows(nRow).Range.Font.Color = wdColorBlack
.Rows(nRow).Range.Font.Bold = False

End If

.Cell(nRow, 2).Select
Selection.MoveLeft wdCell
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cVldCpo", PreserveFormatting:=True

.Cell(nRow, 1).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cVldAtri", PreserveFormatting:=True

.Cell(nRow, 2).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cVldCont", PreserveFormatting:=True

End With


End Sub
Sub Rodape()

Dim nTabAtu As Integer

'Conta a quantidade de tabelas criadas
nTabAtu = ActiveDocument.Tables.Count

'Move o ponteiro para o fim da tabela
Set RangeX = ActiveDocument.Range(ActiveDocument.Tables(nTabAtu).Range.End, ActiveDocument.Tables(nTabAtu).Range.End)
RangeX.MoveEnd wdCharacter, 1
RangeX.SetRange RangeX.Start + 2, RangeX.End
RangeX.Select

'Inicia tabela com campos
ActiveDocument.Tables.Add Selection.Range, 1, 10, wdWord9TableBehavior, wdAutoFitFixed

'Conta a quantidade de tabelas criadas
nTabAtu = ActiveDocument.Tables.Count

'Dimensiona tabela e suas propriedades
With ActiveDocument.Tables(nTabAtu)

.Rows.Height = InchesToPoints(0.18)
.Range.Font.Name = "Verdana"
.Range.Font.Size = 10
.Range.Font.Color = wdColorWhite
.Range.Font.Bold = True
.Range.Shading.BackgroundPatternColorIndex = wdGray50

'Ajusta nome das colunas
.Cell(1, 1).Range.Text = "Atributos"
.Cell(1, 2).Range.Text = "1-Inic.Padrão"
.Cell(1, 3).Range.Text = "2-Gatilho"
.Cell(1, 4).Range.Text = "3-F3"
.Cell(1, 5).Range.Text = "4-Combo"
.Cell(1, 6).Range.Text = "5-cláusula when"
.Cell(1, 7).Range.Text = "6-Validação"
.Cell(1, 8).Range.Text = "7-Obrigat"
.Cell(1, 9).Range.Text = "8-Visual"
.Cell(1, 10).Range.Text = "9-Virtual"

End With

Call FimTab

End Sub

Sub CriaCabVal()

Dim nTabAtu As Integer

'Inicia tabela com campos
ActiveDocument.Tables.Add Selection.Range, 1, 3, wdWord9TableBehavior, wdAutoFitFixed

nTabAtu = ActiveDocument.Tables.Count

With ActiveDocument.Tables(nTabAtu)

.Rows.Height = InchesToPoints(0.18)
.Range.Font.Name = "Verdana"
.Range.Font.Size = 10
.Range.Font.Color = wdColorWhite
.Range.Font.Bold = True
.Range.Shading.BackgroundPatternColorIndex = wdGray50

.Cell(1, 1).Width = CentimetersToPoints(3.06)
.Cell(1, 1).Range.Text = "Campo"
.Cell(1, 2).Width = CentimetersToPoints(1.96)
.Cell(1, 2).Range.Text = "Atributo"
.Cell(1, 3).Width = CentimetersToPoints(19.94)
.Cell(1, 3).Range.Text = "Conteudo"

End With

End Sub
Sub CriaCabPar()

Dim nTabAtu As Integer

'Inicia tabela com campos
ActiveDocument.Tables.Add Selection.Range, 1, 4, wdWord9TableBehavior, wdAutoFitFixed

nTabAtu = ActiveDocument.Tables.Count

With ActiveDocument.Tables(nTabAtu)

.Rows.Height = InchesToPoints(0.18)
.Range.Font.Name = "Verdana"
.Range.Font.Size = 10
.Range.Font.Color = wdColorWhite
.Range.Font.Bold = True
.Range.Shading.BackgroundPatternColorIndex = wdGray50

.Cell(1, 1).Width = CentimetersToPoints(3.99)
.Cell(1, 1).Range.Text = "Parâmetros"
.Cell(1, 2).Width = CentimetersToPoints(1.59)
.Cell(1, 2).Range.Text = "Tipo"
.Cell(1, 3).Width = CentimetersToPoints(4.44)
.Cell(1, 3).Range.Text = "Conteudo"
.Cell(1, 4).Width = CentimetersToPoints(14.94)
.Cell(1, 4).Range.Text = "Descrição"

End With

End Sub

Sub LinPar()

Dim nTabAtu As Integer
Dim nRow As Integer

nTabAtu = ActiveDocument.Tables.Count
nRow = ActiveDocument.Tables(nTabAtu).Rows.Count

With ActiveDocument.Tables(nTabAtu)

.Rows.Add
nRow = .Rows.Count
.Rows(nRow).Shading.BackgroundPatternColorIndex = wdWhite

If nRow = 2 Then

.Rows(nRow).Shading.BackgroundPatternColorIndex = wdWhite
.Rows(nRow).Range.Font.Color = wdColorBlack
.Rows(nRow).Range.Font.Bold = False

End If

.Cell(nRow, 2).Select
Selection.MoveLeft wdCell
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cParNome", PreserveFormatting:=True

.Cell(nRow, 1).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cParTipo", PreserveFormatting:=True

.Cell(nRow, 2).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cParCont", PreserveFormatting:=True

.Cell(nRow, 3).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cParDesc", PreserveFormatting:=True


End With


End Sub

Sub CriaCabInd()

Dim nTabAtu As Integer

'Inicia tabela com campos
ActiveDocument.Tables.Add Selection.Range, 1, 2, wdWord9TableBehavior, wdAutoFitFixed

nTabAtu = ActiveDocument.Tables.Count

With ActiveDocument.Tables(nTabAtu)

.Rows.Height = InchesToPoints(0.18)
.Range.Font.Name = "Verdana"
.Range.Font.Size = 10
.Range.Font.Color = wdColorWhite
.Range.Font.Bold = True
.Range.Shading.BackgroundPatternColorIndex = wdGray50

.Cell(1, 1).Width = CentimetersToPoints(3.99)
.Cell(1, 1).Range.Text = "Índice / Ordem"
.Cell(1, 2).Width = CentimetersToPoints(20.96)
.Cell(1, 2).Range.Text = "Chave"

End With

End Sub

Sub LinInd()

Dim nTabAtu As Integer
Dim nRow As Integer

nTabAtu = ActiveDocument.Tables.Count
nRow = ActiveDocument.Tables(nTabAtu).Rows.Count

With ActiveDocument.Tables(nTabAtu)

.Rows.Add
nRow = .Rows.Count
.Rows(nRow).Shading.BackgroundPatternColorIndex = wdWhite

If nRow = 2 Then

.Rows(nRow).Shading.BackgroundPatternColorIndex = wdWhite
.Rows(nRow).Range.Font.Color = wdColorBlack
.Rows(nRow).Range.Font.Bold = False

End If

.Cell(nRow, 2).Select
Selection.MoveLeft wdCell
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cIndOrd", PreserveFormatting:=True

.Cell(nRow, 1).Select
Selection.MoveRight
Selection.Fields.Add Range:=Selection.Range, Type:=wdFieldEmpty, Text:="DOCVARIABLE  cIndChav", PreserveFormatting:=True

End With

End Sub

Sub FimTab()

Dim Range3 As Range
Dim I As Integer
I = ActiveDocument.Tables.Count
Set Range3 = ActiveDocument.Range(Start:=ActiveDocument.Tables(I).Range.End, End:=ActiveDocument.Tables(I).Range.End)

Range3.MoveEnd unit:=wdCharacter, Count:=1
Range3.SetRange Start:=Range3.Start + 2, End:=Range3.End
Range3.Select

With Selection
.Collapse Direction:=wdCollapseEnd
.TypeParagraph
End With

End Sub
*/
