#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FOLDER.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOME005  ºAutor  ³Anderson C. P. Coelho º Data ³  20/07/11 º±±
±±ºPrograma  ³RCOME005  ºAutor  ³Adriano Leonardo      º Data ³  17/11/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cálculo/simulação de importação, com geração de  º±±
±±º          ³ documento de entrada de importação automática.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus12 - Específico para a Prozyn                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCOME005()

Private cCadastro  := "Importações"
Private _cRotina   := "RCOME005"
Private nOpc       := 0
Private aRotina    := {	{"Locali&zar"   		,"AxPesqui"                    ,0,1},;
						{"&Visualizar"  		,"U_COMA001M('SZJ',Recno(),2)" ,0,2},;
						{"&Incluir"     		,"U_COMA001M('SZJ',Recno(),3)" ,0,3},;
						{"&Alterar"     		,"U_COMA001M('SZJ',Recno(),4)" ,0,4},;
						{"&Excluir"     		,"U_COMA001E('SZJ',Recno(),5)" ,0,5},;
						{"I&mportar CSV"		,"U_COMA001I('SZJ',Recno(),4)" ,0,3},;
						{"&Gera NF"     		,"U_COMA001G('SZJ',Recno(),4)" ,0,3},;
						{"&Legenda"     		,"U_COMA001L()"                ,0,6} }

Private cDelFunc   := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString    := "SZJ"
Private aCores     := { {'!Empty(SZJ->ZJ_DOC)', 'BR_VERMELHO'},;
						{'Empty(SZJ->ZJ_DOC)' , 'BR_VERDE'   } }

Private bFiltraBrw := {|| NIL }

dbSelectArea(cString)
dbSetOrder(1)
aIndexSZJ          := {}
cFiltraSZJ         := ''
bFiltraBrw         := {|| FilBrowse(cString,@aIndexSZJ,@cFiltraSZJ)}
Eval(bFiltraBrw)

mBrowse(06,01,22,75,cString,,,,,,aCores)

EndFilBrw(cString,aIndexSZJ)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMA001M  ºAutor  ³Anderson C. P. Coelho º Data ³  27/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem da tela de manutenção da importação.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMA001M(cAlias,nReg,nOpc)

If !Empty(SZJ->ZJ_DOC)
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1") + SZJ->ZJ_DOC + SZJ->ZJ_SERIE)
		If nOpc == 4
			nOpc := 2
			MsgAlert("Atenção! Documento de Entrada já gerado. Não será permitido alterar este registro!")
		EndIf
	Else
		dbSelectArea("SZJ")
		RecLock("SZJ",.F.)
		SZJ->ZJ_DOC     := ""
		SZJ->ZJ_SERIE   := ""
		SZJ->ZJ_EMISSAO := STOD("")
		SZJ->(MSUNLOCK())
	EndIf
EndIf

Processa({|| ProcImp(cAlias,nReg,nOpc)}, cCadastro,"Iniciando...",.F.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcImp   ºAutor  ³Anderson C. P. Coelho º Data ³  01/08/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento da rotina...                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005(COMA001M)                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcImp(cAlias,nReg,nOpc)

Local _aSavArea := GetArea()
Local aTitulos  := {}
Local aPaginas  := {}
Local aButtons  := {}
Local lDeleta   := If(nOpc==2 .Or. nOpc==5,.F.,.T.)
Local nOpcA     := 0
Local nHRes     := oMainWnd:nClientWidth //--Resolucao horizontal do monitor

Local bCond     := {|| .T. }
Local bAction1  := {|| .T. }
Local bAction2  := {|| .T. }
Local bWhile    := {|| }
Local cSeek     := ""
Local cQuery    := ""
Local lOnlyYes  := .F. 						// se verdadeiro, exibe apenas os campos de usuário;
Local nX		:= 0
Local _ni		:= 0

Private oDlg
Private oFolder
Private aTela      := {}
Private aGets      := {}

Private aHeader    := {}
Private aCols      := {} 
Private nUsado     := 0

//Folder 1
Private oGetItens
Private aHeadItem  := {}
Private aColsItem  := {}
Private nUsadItem  := 0
Private nItemAtu   := 1

//Folder 2
Private oGetDupl
Private aHeadDupl  := {}
Private aColsDupl  := {}
Private nUsadDupl  := 0
Private nDuplAtu   := 1

//Folder 3
Private oGetResu
Private aHeadResu  := {}
Private aColsResu  := {}
Private nUsadResu  := 0
Private nResuAtu   := 1

Private nFldAtu    := 0		//Folder atual

//Define as coordenadas da Tela
Private aSize		:= MsAdvSize(.T.)		//Traz o tamanho da tela, de acordo com a resolução
Private aObjects	:= {}
Private aInfo		:= {}
Private aPosObj	:= {}
Private lFlatMode	:= If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
Private nFat		:= 1

Private _aFaturas   := {}

dbSelectArea("SZJ")
cAlias := Alias()
nReg   := Recno()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche as opcoes do Folder											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aTitulos,"&Itens"                     )
Aadd(aTitulos,"&Duplicatas"                )
Aadd(aTitulos,"&Resumo da Importação"      )
Aadd(aPaginas,"ITENS"                      )
Aadd(aPaginas,"DUPLICATAS"                 )
Aadd(aPaginas,"RESUMO DA IMPORTACAO"       )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria as variaveis para edicao na enchoice - Cabeçalho                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//RegToMemory(cAlias,[lInc]             ,[lDic],[lInitPad])
  RegToMemory(cAlias,If(nOpc==3,.T.,.F.),.T.   ,.T.       )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Composição do Folder 1 - Itens da Importação        					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZK")
dbSetOrder(1)
aHeader := {}
aCols   := {}
//bWhile  := {|| RetSIX("SZK","1",.T.,{})}													//{|| RetSIX("SZK","1",.T.,{"ZK_NUM"})}
cSeek 	:= IIf((nOpc == 3),"",(xFilial("SZK") + Padr(SZJ->ZJ_NUM,TamSx3("ZK_NUM")[1])))		//RetSIX("SZ1","1",.T.)

//FillGetDados(	nOpc,; 							// numero correspondente à operação a ser executada, exemplo: 3 - inclusão, 4 alteração e etc;
//               	"SZK",;       					// area a ser utilizada;
//               	1,;      						// nOrdem - ordem correspondente a chave de índice para preencher o acols;
//               	cSeek,; 					 	// chave utilizada no posicionamento da área para preencher o acols; 
//               	bWhile,; 						// bloco contendo a expressão a ser comparada com cSeekKey na condição  do While. 
//               	{{bCond,bAction1,bAction2}},;	// uSeekFor
//               	/*aNoFields*/,; 			 	// aNoFields - array contendo os campos que não estarao no aHeader;
//               	/*aYesFields*/,; 				// aYesFields - array contendo somente os campos que estarao no aHeader;
//               	.F.,;      						// se verdadeiro, exibe apenas os campos de usuário;
//                Iif((nOpc == 3),"",cQuery),;	// cQuery - query a ser executada para preencher o acols;
//               	/*bMontCols*/,; 	   			// bloco contendo funcao especifica para preencher o aCols; 
//               	Iif((nOpc == 3),.T.,.F.),;  	// lEmpty - Se for uma inclusão, passar .T. para que o aCols seja incializado com 1 linha em branco.
//               	aHeadItem	/*aHeaderAux*/,;	// aHeaderAux - Nome do aHeader auxiliar. Caso necessite tratar o aheader e acols como variáveis locais ( por exemplo, no uso de várias getdados).
//               	aColsItem	/*aColsAux*/,; 		// aColsAux - Nome do aCols auxiliar. Caso necessite tratar o aheader e acols como variáveis locais ( por exemplo, no uso de várias getdados).
//               	/*bafterCols*/,;				// bAfterCols - Bloco executado após a inclusão de cada linha no aCols.
//               	/*bBeforeCols*/,; 				// bBeforeCols - Bloco de código contendo expressão para sair do While. É executado antes da inclusão de cada linha no aCols
//               	/*bAfterHeader*/,;				// bAfterHeader - Bloco para manipular o aHeader após o preenchimento dos campos padrões e antes de incluir os campos reservados para o WalkThru.
//               	"SZK") 							// cAliasQry

nUsado := 0
dbSelectArea("SX3")
dbSetOrder(1)
If dbSeek("SZK")
	While !EOF() .AND. X3_ARQUIVO == "SZK"
		If X3USO(X3_USADO) .AND. cNivel>=X3_NIVEL
			nUsado++
			AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSkip()
	EndDo
	AADD(aHeader,{ "Alias WT", Padr("ZK_ALI_WT",Len(X3_CAMPO)), Space(Len(X3_PICTURE)), 3 , 0, Space(Len(X3_VALID)), Padr("€€€€€€€€€€€€€€€",Len(X3_USADO)), Padr("C",Len(X3_TIPO)), Padr("SZK",Len(X3_ARQUIVO)), Padr("V",Len(X3_CONTEXT)) } )
	AADD(aHeader,{ "Recno WT", Padr("ZK_REC_WT",Len(X3_CAMPO)), Space(Len(X3_PICTURE)), 10, 0, Space(Len(X3_VALID)), Padr("€€€€€€€€€€€€€€€",Len(X3_USADO)), Padr("N",Len(X3_TIPO)), Padr("SZK",Len(X3_ARQUIVO)), Padr("V",Len(X3_CONTEXT)) } )
Else
	Alert("Estrutura da tabela SZK não localizada!")
	RestArea(_aSavArea)
	Return(.F.)
EndIf
dbSelectArea("SZK")
dbSetOrder(1)
ProcRegua(RecCount("SZK"))
If nOpc <> 3 .AND. dbSeek(cSeek)
	aCols := {}
	While !EOF() .AND. SZK->ZK_FILIAL == xFilial("SZK") .AND. SZK->ZK_NUM == Padr(SZJ->ZJ_NUM,TamSx3("ZK_NUM")[1])
		IncProc()
		AADD(aCols,Array(Len(aHeader)+1))
		For nX := 1 To Len(aHeader) - 2
			aCols[Len(aCols),nX] := FieldGet(FieldPos(aHeader[nX,2]))
		Next
		aCols[Len(aCols),Len(aHeader)-1] := "SZK"
		aCols[Len(aCols),Len(aHeader)  ] := SZK->(RECNO())
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		dbSelectArea("SZK")
		dbSetOrder(1)
		dbSkip()
	EndDo
Else
	AADD(aCols,Array(Len(aHeader)+1))
	For _ni := 1 To Len(aHeader) - 2
		If Alltrim(aHeader[_ni,2]) == "ZK_ITEM"
			aCols[1,_ni] := StrZero(1,TamSx3("ZK_ITEM")[1])
		Else
			aCols[1,_ni] := CriaVar(aHeader[_ni,2])
		EndIf
	Next
	aCols[1,Len(aHeader)-1] := "SZK"
	aCols[1,Len(aHeader)+1] := .F.
EndIf

aHeadItem := aClone(aHeader)
aColsItem := aClone(aCols)
nUsadItem := Len(aHeader)	//Len(aHeadItem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Composição do Folder 2 - Duplicatas                 					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aHeadDupl,{"Vencimento" ,"VENCIMENTO",""                 ,08,0,"","€€€€€€€€€€€€€€ ","D","","R","",""})
Aadd(aHeadDupl,{"Valor"      ,"VALOR"     ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aColsDupl,{STOD(""),0,.F.})
nUsadDupl := Len(aHeadDupl)		//Len(aHeader)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Composição do Folder 3 - Resumo da Importação       					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aHeadResu,{"Emissão"    ,"EMISSAO" ,""                 ,08,0,"","€€€€€€€€€€€€€€ ","D","","R","",""})
Aadd(aHeadResu,{"Nota Fiscal","NF"      ,"@!"               ,09,0,"","€€€€€€€€€€€€€€ ","C","","R","",""})
Aadd(aHeadResu,{"Série"      ,"SERIE"   ,"@!"               ,03,0,"","€€€€€€€€€€€€€€ ","C","","R","",""})
Aadd(aHeadResu,{"Mercadorias","VALMERC" ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"Val. Frete" ,"FRETE"   ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"Despesas"   ,"DESPESAS","@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"Seguro"     ,"SEGURO"  ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"I.I."       ,"II"      ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"PIS"        ,"PIS"     ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"COFINS"     ,"COFINS"  ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"IPI"        ,"IPI"     ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"ICMS"       ,"ICMS"    ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
Aadd(aHeadResu,{"TOTAL"      ,"TOTAL"   ,"@E 999,999,999.99",14,2,"","€€€€€€€€€€€€€€ ","N","","R","",""})
If !Empty(SZJ->ZJ_DOC)
	dbSelectArea("SZK")
	dbSetOrder(1)
	If dbSeek(xFilial("SZK") + SZJ->ZJ_NUM)
		While !EOF() .AND. SZJ->ZJ_NUM == SZK->ZK_NUM
			If aScan(aColsResu,{|x|AllTrim(x[2]+x[3])==AllTrim(SZK->(ZK_DOC+ZK_SERIE))}) == 0
				dbSelectArea("SF1")
				dbSetOrder(1)
				If dbSeek(xFilial("SF1") + SZK->(ZK_DOC+ZK_SERIE+ZK_FORNECE+ZK_LOJA))
					Aadd(aColsResu,{SF1->F1_EMISSAO,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_VALMERC,SF1->F1_FRETE,SF1->F1_DESPESA,SF1->F1_SEGURO,SF1->F1_II,SF1->F1_VALIMP6,SF1->F1_VALIMP5,SF1->F1_VALIPI,SF1->F1_VALICM,SF1->F1_VALBRUT,.F.})
				EndIf
			EndIf
			dbSelectArea("SZK")
			dbSetOrder(1)
			dbSkip()
		EndDo
	EndIf
//Else
//	Processa({|| RECALCIMP(0)}, cCadastro,"Calculando duplicadas e resumo...",.F.)
EndIf
If Len(aColsResu) == 0
	Aadd(aColsResu,{STOD(""),"","",0,0,0,0,0,0,0,0,0,0,.F.})
EndIf
nUsadResu := Len(aHeadResu)

IncProc()

nFat := 1 // Valor Default
If lFlatMode
	AAdd( aObjects, { 100,40,.T.,.T. } )
	If (nHRes >= 776 .AND. nHRes <= 800) // Resolucao 800x600
		AAdd( aObjects, { 100,60,.T.,.T. } )
		nFat := 0.92
	Else
		AAdd( aObjects, { 100,60,.T.,.T. } )
		nFat := 0.95
	EndIf	
Else                                       
	AAdd( aObjects, { 100,30,.T.,.T. } )
	AAdd( aObjects, { 100,70,.T.,.T. } )
EndIf

aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4], 0, 0 }
aPosObj:= MsObjSize( aInfo, aObjects, .T. )

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],000 To aSize[6],aSize[5] OF oMainWnd Pixel
IncProc()
//oEnch   := MsMGet():New(cAliasE, nReg, nOpc, /*aCRA*/, /*cLetra*/,/*cTexto*/, aCpoEnch   ,aPos                                                                ,aAlterEnch    , nModelo   , /*nColMens*/,/*cMensagem*/      , /*cTudoOk*/, oDlg, lF3   , lMemoria, lColumn,caTela, lNoFolder, lProperty)
  oEncEsp := MsMGet():New(cAlias , nReg, nOpc, /*aCRA*/, /*cLetra*/,/*cTexto*/,/*aCpoEnch*/,{aPosObj[ 1, 1 ], aPosObj[ 1, 2 ], aPosObj[ 1, 3 ], aPosObj[ 1, 4 ]},/*aAlterEnch*/,/*nModelo*/, /*nColMens*/,/*cMensagem*/      , /*cTudoOk*/, oDlg,/*lF3*/,.T.      ,        ,      ,          ,          ,,,.T.)
  oEncEsp:oBox:Align := CONTROL_ALIGN_TOP

//Montagem dos folders
oFolder := TFolder():New(7.4,0.3,aTitulos,aPaginas,oDlg,,,, .F., .F.,304,71.5)
Aeval(oFolder:aDialogs,{|x|x := oDlg:oFont})
oFolder:Align := CONTROL_ALIGN_ALLCLIENT

For nX := 1 to Len(oFolder:aDialogs)
   DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION AllwaysTrue() ENABLE OF oFolder:aDialogs[nX]
Next nX

//Recálculo
Aadd(aButtons,{"CGETFILE_9",{|| Processa({|| RECALCIMP(1)}, cCadastro,"Recalculando valores..."   ,.F.) } ,"Recalcular Valores  - F5","Recálculo"      })
Aadd(aButtons,{"CGETFILE_9",{|| Processa({|| PREENAUTO() }, cCadastro,"Preenchendo informações...",.F.) } ,"Preench. Automático - F6","Preench. Auto." })

// Insere um SetKey
SetKEY(VK_F5,{|| Processa({|| RECALCIMP(1)}, cCadastro,"Recalculando valores..."   ,.F.) })
SetKEY(VK_F6,{|| Processa({|| PREENAUTO() }, cCadastro,"Preenchendo informações...",.F.) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder 3 - Monta a Getdados do Resumo da Importação                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IncProc()
aHeader    := aClone(aHeadResu)
aCols      := aClone(aColsResu)
nUsado     := Len(aHeader)
N          := 1
oGetResu   := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]*nFat,aPosObj[2,4]*nFat, 5     ,"AllwaysTrue","AllwaysTrue",             , .F.     ,        ,         ,        ,999   ,          ,           ,      ,        ,oFolder:aDialogs[3],            ,       )

oGetResu:oBrowse:lDisablePaint := .F.
oGetResu:oBrowse:Align         := CONTROL_ALIGN_TOP
oGetResu:oBrowse:Refresh()
oGetResu:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder 2 - Monta a Getdados das Duplicatas da Importação                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IncProc()
aHeader    := aClone(aHeadDupl)
aCols      := aClone(aColsDupl)
nUsado     := Len(aHeader)
N          := 1
oGetDupl   := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]*nFat,aPosObj[2,4]*nFat, 5     ,"AllwaysTrue","AllwaysTrue",             , .F.     ,        ,         ,        ,999   ,          ,           ,      ,        ,oFolder:aDialogs[2],            ,       )

oGetDupl:oBrowse:lDisablePaint := .F.
oGetDupl:oBrowse:Align         := CONTROL_ALIGN_TOP
oGetDupl:oBrowse:Refresh()
oGetDupl:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder 1 - Monta a Getdados dos Itens da Importação                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IncProc()
aHeader    := aClone(aHeadItem)
aCols      := aClone(aColsItem)
nUsado     := Len(aHeader)
N          := 1
/*
Nome		Tipo		Descrição																															Obrigatório	Referência
nTop		Numérico	Distância entre a MsGetDados e a extremidade superior do objeto que a contém.															X	
nLeft		Numérico	Distância entre a MsGetDados e a extremidade esquerda do objeto que a contém.															X	
nBottom		Numérico	Distância entre a MsGetDados e a extremidade inferior do objeto que a contém.															X	
nRight		Numérico	Distância entre a MsGetDados e o extremidade direita do objeto que a contém.															X	
nOpc		Numérico	Posição do elemento do vetor aRotina que a MsGetDados usará como referência.															X	
cLinhaOk	Caracter	Função executada para validar o contexto da linha atual do aCols.		
cTudoOk		Caracter	Função executada para validar o contexto geral da MsGetDados (todo aCols).		
cIniCpos	Caracter	Nome dos campos do tipo caracter que utilizarão incremento automático. Este parametro deve ser no formato “+++...”.		
lDeleta		Lógico		Habilita deletar linhas do aCols. Valor padrão falso.		
aAlter		Vetor		Vetor com os campos que poderão ser alterados.		
nFreeze		Qualquer	Quantidade de colunas que serão apresentadas de forma fixa durante a navegação horizontal, iniciando da esquerda para direita.		
lEmpty		Lógico		Habilita validação da primeira coluna do aCols para que esta não possa ser vazia. Valor padrão falso.		
nMax		Numérico	Número máximo de linhas permitidas. Valor padrão 99.		
cFieldOk	Caracter	Função executada na validação do campo.		
cSuperDel	Caracter	Função executada quando pressionada as teclas +.		
uPar		Vetor		Parâmetro reservado		
cDelOk		Caracter	Função executada para validar a exclusão de uma linha do aCols.		
oWnd		Objeto		Objeto no qual a MsGetDados será criada.		
lUseFreeze	Lógico		Determina se as colunas poderão ser fixadas durante a navegação horizontal. Valor padrão falso.		
cTela		Caracter	Parâmetro reservado		

               MsGetDados():New(<nTop>      ,<nLeft>     ,<nBottom>        ,<nRight>         ,<nOpc> ,[cLinhaOk]   ,[cTudoOk]    ,[cIniCpos], [lDeleta],[aAlter],[nFreeze],[lEmpty],[nMax],[cFieldOk],[cSuperDel],[uPar],[cDelOk],[oWnd]             ,[lUseFreeze],[cTela]) --> oGetDados
*/
oGetItens   := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]*nFat,aPosObj[2,4]*nFat,nOpc   ,"AllwaysTrue","AllwaysTrue","+ZK_ITEM", lDeleta  ,        ,         ,        ,999   ,          ,           ,      ,        ,oFolder:aDialogs[1],            ,       )

oGetItens:oBrowse:lDisablePaint   := .F.
oGetItens:oBrowse:Align := CONTROL_ALIGN_TOP
oGetItens:oBrowse:Refresh()
oGetItens:Refresh()

oFolder:bSetOption := {|nAt|ValidFolder(nFldAtu := nAt,oFolder:nOption)}
oFolder:SetOption(1)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||Eval(oFolder:bSetOption),nOpcA:=1,Confirm(nOpc)},{||nOpcA:=2,oDlg:End()},,aButtons)

// Apaga um SetKey
SetKEY(VK_F5,{||})
SetKEY(VK_F6,{||})

RestArea(_aSavArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ValidFolder    ³ Autor ³Anderson C. P. Coelho  ³ Data ³20/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Realiza a validacao na troca dos folders.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ValidFolder(EXPN1,EXPN2)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao do Folder selecionado                           ³±±
±±³			 ³ EXPN2 = Posicao do ultimo Folder selecionado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Lógico                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RPESC005                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValidFolder(nGot,nLost)

Local lRetorno := .T.

IncProc()

If nLost # NIL
	If nLost == 1
		aColsItem := aClone(aCols)
		oGetItens:oBrowse:lDisablePaint := .T.
	ElseIf nLost == 2
		aColsDupl  := aClone(aCols)
		oGetDupl:oBrowse:lDisablePaint  := .T.
	ElseIf nLost == 3
		aColsResu  := aClone(aCols)
		oGetResu:oBrowse:lDisablePaint  := .T.
	EndIf
EndIf

RECALCIMP(0)

If nGot # NIL
	If nGot == 1
		aHeader := aClone(aHeadItem)
		aCols   := aClone(aColsItem)
		nUsado  := Len(aHeadItem)		//Len(aHeader)
		N       := 1
		oGetItens:oBrowse:lDisablePaint := .F.
        oGetItens:oBrowse:Refresh()
        oGetItens:Refresh()
	ElseIf nGot == 2
		aHeader := aClone(aHeadDupl)
		aCols   := aClone(aColsDupl)
		nUsado  := Len(aHeadDupl)		//Len(aHeader)
	 	N       := 1
		oGetDupl:oBrowse:lDisablePaint := .F.
		oGetDupl:oBrowse:Refresh()
		oGetDupl:Refresh()
	ElseIf nGot == 3
		aHeader := aClone(aHeadResu)
		aCols   := aClone(aColsResu)
		nUsado  := Len(aHeadResu)		//Len(aHeader)
	 	N       := 1
		oGetResu:oBrowse:lDisablePaint := .F.
		oGetResu:oBrowse:Refresh()
		oGetResu:Refresh()
	EndIf        
EndIf

Return(lRetorno)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Confirm   ºAutor  ³Anderson C. P. Coelho º Data ³  25/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de gravação dos dados da importação nas tabelas SCJ º±±
±±º          ³e SCK.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Confirm(nOpc)
Local _he	:= 0
Local _ac	:= 0

If nOpc == 3 .OR. nOpc == 4 		//Inclusão ou Alteração
	_lContinua := .T.
	//Tratamento de gravação do cabeçalho da importação (SZJ)
	If _lContinua
		Begin Transaction
			dbSelectArea("SZJ")
			dbSetOrder(1)
			If dbSeek(xFilial("SZJ") + M->ZJ_NUM)
				RecLock("SZJ",.F.)
			Else
				RecLock("SZJ",.T.)
				ConfirmSx8(M->ZJ_NUM)
			EndIf
				SZJ->ZJ_FILIAL := xFilial("SZJ")
				dbSelectArea("SX3")
				dbSetOrder(1)
				If dbSeek("SZJ")
					While !EOF() .AND. SX3->X3_ARQUIVO == "SZJ"
						If X3USO(X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT <> "V"
							&("SZJ->"+AllTrim(SX3->X3_CAMPO)) := &("M->"+AllTrim(SX3->X3_CAMPO))
						EndIf
						dbSelectArea("SX3")
						dbSetOrder(1)
						dbSkip()
					EndDo
				Else
					Alert("Atenção!!! [SZJ] Problemas com a gravação do cabeçalho da importação. Contate o administrator!")
					_lContinua := .F.
				EndIf
			SZJ->(MSUNLOCK())
		End Transaction
	EndIf
	//Tratamento de gravação dos itens da importação
	If _lContinua
		For _ac := 1 To Len(aColsItem)
			If !Empty(aColsItem[001][aScan(aHeadItem,{|x| AllTrim(x[2])=="ZK_COD"})])
				Begin Transaction
					dbSelectArea("SZK")
					dbSetOrder(1)
					If dbSeek(xFilial("SZK") + M->ZJ_NUM + aColsItem[_ac][aScan(aHeadItem,{|x| AllTrim(x[2])=="ZK_ITEM"})])
						RecLock("SZK",.F.)
						If aColsItem[_ac][Len(aHeadItem)+1]
							DELETE
							SZK->(MSUNLOCK())
						EndIf
					Else
						If !aColsItem[_ac][Len(aHeadItem)+1]
							RecLock("SZK",.T.)
						EndIf
					EndIf
					If !aColsItem[_ac][Len(aHeadItem)+1]
						SZK->ZK_FILIAL := xFilial("SZK")
						For _he := 1 To Len(aHeadItem)-2
							dbSelectArea("SX3")
							dbSetOrder(2)
							If dbSeek(aHeadItem[_he][002])
								If SX3->X3_CONTEXT <> "V"
									&("SZK->"+AllTrim(SX3->X3_CAMPO)) := aColsItem[_ac][_he]
								EndIf
							Else
								Alert("Atenção!!! [SZK] Problemas com a gravação dos itens da importação [Campo: " + aHeadItem[_he][002] + "]. Contate o administrator!")
								_lContinua := .F.
								Exit
							EndIf
						Next
						SZK->ZK_NUM     := M->ZJ_NUM
						SZK->ZK_FORNECE := M->ZJ_FORNECE
						SZK->ZK_LOJA    := M->ZJ_LOJA
						SZK->(MSUNLOCK())
					EndIf
				End Transaction
			EndIf
		Next
	EndIf
EndIf

oDlg:End()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMA001E  ºAutor  ³Anderson C. P. Coelho º Data ³  25/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de exclusão do registro selecionado.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function COMA001E(cAlias,nReg,nOpc)

If (_lContinua := MsgYesNo("Deseja realmente excluir este registro?","COMA001E_A"))
	_cQry      := "SELECT COUNT(*) CONTAGEM "
	_cQry      += "FROM " + RetSqlName("SZK") + " SZK "
	_cQry      += "WHERE SZK.D_E_L_E_T_<> '*' "
	_cQry      += "  AND SZK.ZK_FILIAL  = '"  + xFilial("SZK")  + "' "
	_cQry      += "  AND SZK.ZK_NUM     = '"  + SZJ->ZJ_NUM     + "' "
	_cQry      += "  AND (SZK.ZK_DOC||SZK.ZK_SERIE||SZK.ZK_FORNECE||SZK.ZK_LOJA) IN (SELECT (F1_DOC||F1_SERIE||F1_FORNECE||F1_LOJA) "
	_cQry      += "                                                                  FROM " + RetSqlName("SF1") + " SF1 "
	_cQry      += "                                                                  WHERE SF1.D_E_L_E_T_<>'*' "
	_cQry      += "                                                                    AND SF1.F1_FILIAL = '" + xFilial("SF1") + "' "
	_cQry      += "                                                                    AND SF1.F1_FORMUL = 'S' "
	_cQry      += "                                                                  ) "
	_cQry      := ChangeQuery(_cQry)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"TABTMP",.T.,.F.)

	dbSelectArea("TABTMP")
	If TABTMP->CONTAGEM > 0
		_lContinua := .F.
		Alert("Este registro não pode ser excluído pois está vinculado a pelo menos um documento de entrada. Exclua o(s) documento(s) fiscal(is) vinculados, antes de prosseguir!")
	EndIf
	TABTMP->(dbCloseArea())

	If _lContinua
		dbSelectArea("SZK")
		dbSetOrder(1)
		If dbSeek(xFilial("SZK") + SZJ->ZJ_NUM)
			While !EOF() .AND. SZK->ZK_FILIAL == xFilial("SZK") .AND. SZK->ZK_NUM == Padr(SZJ->ZJ_NUM,TamSx3("ZK_NUM")[1])
				RecLock("SZK",.F.)
				DELETE
				SZK->(MSUNLOCK())
				dbSelectArea("SZK")
				dbSetOrder(1)
				dbSkip()
			EndDo
		EndIf
		dbSelectArea("SCJ")
		RecLock("SZJ",.F.)
		DELETE
		SZJ->(MSUNLOCK())	
		ApMsgInfo("Importação excluída com sucesso!")
	EndIf
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMA001L  ºAutor  ³Anderson C. P. Coelho º Data ³  20/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Legenda da tela.                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function COMA001L(cAlias,nReg,nOpc)

Local aLegenda := {}

Aadd(aLegenda,{"BR_VERDE"   ,"Importação Aberta"   })
Aadd(aLegenda,{"BR_VERMELHO","Importação Encerrada"})

BrwLegenda(cCadastro,"Status das Importações",aLegenda)

Return(NIL)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PREENAUTO ºAutor  ³Anderson C. P. Coelho º Data ³  25/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de preenchimento automático de campos nos itens.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PREENAUTO()

Local _x	:= 0

If oFolder:nOption == 1 .AND. Len(aCols) > 0
	If Empty(M->ZJ_DOC)
		If !Empty(M->ZJ_ARQUIVO)
			_lAltIt  := MsgYesNo("Deseja alterar a ordem dos itens por Adição/Seq.Adição, ou mantém a ordem original, conforme o arquivo importado?","ALTORDER")
		Else
			_lAltIt  := .T.
		EndIf
	Else
		_lAltIt  := .F.
	EndIf
	_nAdi    := 0
	_nSeqAd  := 0
	_nPosIt  := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_ITEM"   })
	_nPProd  := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_COD"    })
	_nPosTES := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_TES"    })
	_nPosCST := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_CLASFIS"})
	_nPosNCM := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_POSIPI" })
	_nPosAdi := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_ADICAO" })
	_nPosSAd := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_SEQADI" })
	_nPFabr  := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_FABRIC" })
	_nPDFabr := aScan(aHeader,{|x| AllTrim(x[2])=="ZK_DFABRIC"})
	_nPFrete := aScan(aHeader,{|x|AllTrim(x[2])=="ZK_FRETE"   })
	_nPSegur := aScan(aHeader,{|x|AllTrim(x[2])=="ZK_SEGURO"  })
	_nPDesp  := aScan(aHeader,{|x|AllTrim(x[2])=="ZK_DESPESA" })
	_nPTotal := aScan(aHeader,{|x|AllTrim(x[2])=="ZK_TOTAL"   })
	_aItZK   := aClone(aCols)
	_aItZK   := aSort(_aItZK,,,{|x,y| x[_nPosNCM] < y[_nPosNCM]})

	_lRateia := .F.
	If (M->ZJ_FRETE+M->ZJ_SEGURO+M->ZJ_DESPESA) > 0 .AND. MsgYesNo("Deseja ratear os valores de Frete, Seguro e Despesas para os itens, neste momento?")
		_lRateia := .T.
	EndIf
	If _lRateia
		_nValTot := 0
		_nSumFre := 0
		_nSumSeg := 0
		_nSumDes := 0
		For _x := 1 To Len(_aItZK)
			IncProc()
			If !_aItZK[_x,Len(aHeader)+1]
				_nValTot += _aItZK[_x,_nPTotal]
			EndIf
		Next
	EndIf
	For _x := 1 To Len(_aItZK)
		IncProc()
		If _lAltIt
			_aItZK[_x][_nPosIt] := StrZero(_x,TamSx3("ZK_ITEM")[1])
		EndIf
		If !_aItZK[_x][Len(aHeader)+1]
			If _lRateia
				_aItZK[_x,_nPFrete] := Round((M->ZJ_FRETE   / _nValTot) * _aItZK[_x,_nPTotal],TamSx3("D1_VALFRE" )[2])
				_aItZK[_x,_nPSegur] := Round((M->ZJ_SEGURO  / _nValTot) * _aItZK[_x,_nPTotal],TamSx3("D1_SEGURO" )[2])
				_aItZK[_x,_nPDesp ] := Round((M->ZJ_DESPESA / _nValTot) * _aItZK[_x,_nPTotal],TamSx3("D1_DESPESA")[2])
				_nSumFre += _aItZK[_x,_nPFrete]
				_nSumSeg += _aItZK[_x,_nPSegur]
				_nSumDes += _aItZK[_x,_nPDesp ]
			EndIf
			dbSelectArea("SB1")
			dbSetOrder(1)
			If !dbSeek(xFilial("SB1") + _aItZK[_x][_nPProd])
				Alert("Produto " + _aItZK[_x][_nPProd] + " não localizado!")
				_aItZK[_x][Len(aHeader)+1] := .T.
			Else
				dbSelectArea("SF4")
				dbSetOrder(1)
				If !dbSeek(xFilial("SF4") + _aItZK[_x][_nPosTES])
					Alert("TES " + _aItZK[_x][_nPosTES] + " não localizado!")
					_aItZK[_x][Len(aHeader)+1] := .T.
				Else
					If Empty(_aItZK[_x][_nPosCST])
						_aItZK[_x][_nPosCST] := IIF(Empty(SB1->B1_ORIGEM),"1",AllTrim(SB1->B1_ORIGEM)) + AllTrim(SF4->F4_SITTRIB)
					EndIf
				EndIf
				If Empty(_aItZK[_x][_nPFabr])
					_aItZK[_x][_nPFabr]  := IIF(!Empty(SB1->B1_FABR),SB1->B1_FABR,M->ZJ_FORNECE)
				EndIf
				If Empty(_aItZK[_x][_nPDFabr])
					_aItZK[_x][_nPDFabr]  := dDataBase-10
				EndIf
				If Empty(_aItZK[_x][_nPosTES]) .AND. !Empty(SB1->B1_TE)
					_aItZK[_x][_nPosTES] := SB1->B1_TE
				EndIf
			EndIf
		EndIf
		If !_aItZK[_x][Len(aHeader)+1]
			If _x == 1 .OR. _aItZK[_x][_nPosNCM] <> _aItZK[_x-1][_nPosNCM]
				_nAdi++
				_nSeqAd := 1
			Else
				_nSeqAd++
			EndIf
			_aItZK[_x][_nPosAdi] := cValToChar(_nAdi)
			_aItZK[_x][_nPosSAd] := cValToChar(_nSeqAd)
		EndIf
	Next
	If _lRateia
		_nSldFre := M->ZJ_FRETE   - _nSumFre
		_nSldSeg := M->ZJ_SEGURO  - _nSumSeg
		_nSldDes := M->ZJ_DESPESA - _nSumDes
		_nRegs   := INT(_nSldFre * 100)
		For _x   := 1 To _nRegs
			_aItZK[_x,_nPFrete] += 0.01
		Next
		_nRegs   := INT(_nSldSeg * 100)
		For _x   := 1 To _nRegs
			_aItZK[_x,_nPSegur] += 0.01
		Next
		_nRegs   := INT(_nSldDes * 100)
		For _x   := 1 To _nRegs
			_aItZK[_x,_nPDesp ] += 0.01
		Next
	EndIf
	If !_lAltIt
		_aItZK   := aSort(_aItZK,,,{|x,y| x[_nPosIt] < y[_nPosIt]})
	EndIf
	aCols := aClone(_aItZK)
EndIf

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RECALCIMP ºAutor  ³Anderson C. P. Coelho º Data ³  25/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de recálculo de impostos.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RECALCIMP(_nOpcBot)

Local _nValTot   := 0
Local _x		:= 0
Local nX		:= 0
Default _nOpcBot := 0

MaFisEnd()

If Type("oFolder")<>"U"
	If oFolder:nOption == 1					//Itens
		aColsItem := aClone(aCols)
	EndIf
	If _nOpcBot == 1						//Chamada pelo botão
		If MsgYesNo("Tem certeza que deseja recalcular os impostos dos itens?","RECALCIMP_1")
			_lContinua := .T.
		Else
			_lContinua := .F.
		EndIf
	Else
		_lContinua := .F.
	EndIf
Else
	_lContinua := .F.
EndIf
If _lContinua
	For _x := 1 To Len(aColsItem)
		IncProc()
		If !aColsItem[_x,Len(aHeadItem)+1]
			_nValTot += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"})]
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1") + aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_COD"})])
				//Definição das alíquotas
				dbSelectArea("SYD")
				dbSetOrder(1)
				If dbSeek(xFilial("SYD") + Padr(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_POSIPI"})],TamSx3("YD_TEC")[1]))
					If aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALIQII"})] == 0
						aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALIQII"})] := SYD->YD_PER_II
					EndIf
					If aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})] == 0
						aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})] := SYD->YD_PER_PIS
					EndIf
					If aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})] == 0
						aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})] := SYD->YD_PER_COF
					EndIf
					If aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })] == 0
						aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })] := SYD->YD_PER_IPI
					EndIf
				EndIf
				If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})] == 0 .OR. ;
					aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})] == 0 .OR. ;
					aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })] == 0 .OR. ;
					aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })] == 0
					dbSelectArea("SF4")
					dbSetOrder(1)
					If dbSeek(xFilial("SF4") + aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TES"})])
						MaFisIni(M->ZJ_FORNECE,;
						         M->ZJ_LOJA,;
						         "F",;
						         "N",;
						         "R",;
						         NIL,;
						         ,;
						         ,;
						         "SB1",;
						         "RCOME005";
						        )
						MaFisAdd(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_COD"      })],;
						         aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TES"      })],;
						         aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_QUANT"    })],;
						        (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF"   })]+aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"})])/aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_QUANT"})],;
						         0,;
						         ,;
						         ,;
						         ,;
								 Round(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"    })],TamSx3("D1_VALFRE" )[2]),;
								 Round(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"  })],TamSx3("D1_DESPESA")[2]),;
								 Round(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO"   })],TamSx3("D1_SEGURO" )[2]),;
						         0,;
						        (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF"   })]+aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"})]),;
						         0,;
						         SB1->(Recno()),;
						         SF4->(Recno()) ;
						        )
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})] := MAFISRET(1,"IT_ALIQPS2")
						EndIf
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})] := MAFISRET(1,"IT_ALIQCF2")
						EndIf
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })] := MAFISRET(1,"IT_ALIQIPI")
						EndIf
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })] := MAFISRET(1,"IT_ALIQICM")
						EndIf
						MaFisEnd()
					Else
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})] := SuperGetMv("MV_TXPIS",.F.,2.10)
						EndIf
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})] := SuperGetMv("MV_TXCOF",.F.,9.65)
						EndIf
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })] := SB1->B1_IPI
						EndIf
						If  aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })] == 0
							aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })] := SB1->B1_PICM
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	If Len(aColsItem) > 0
		_nValX    := 0
		_nValY    := 0
	EndIf
	For _x := 1 To Len(aColsItem)
		IncProc()
		If !aColsItem[_x,Len(aHeadItem)+1]
			IncProc()
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1") + aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_COD"})])
				//Calculo dos valores
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"  })] := Round((M->ZJ_FRETE   / _nValTot) * aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"})],TamSx3("D1_VALFRE" )[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO" })] := Round((M->ZJ_SEGURO  / _nValTot) * aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"})],TamSx3("D1_SEGURO" )[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"})] := Round((M->ZJ_DESPESA / _nValTot) * aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"})],TamSx3("D1_DESPESA")[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF" })] := Round(	aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"  })] + ;
																													aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"  })] + ;
																													aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO" })]         ,TamSx3("D1_TOTAL"  )[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"     })] := Round(	aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF" })] * ;
																													(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALIQII"})]/100)    ,TamSx3("ZK_II"     )[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASEIPI"})] := Round(	aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF" })] + ;
								 																					aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"     })]         ,TamSx3("D1_BASEIPI")[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALIPI" })] := Round(	aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASEIPI"})] * ;
																													(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })]/100)    ,TamSx3("D1_VALIPI" )[2])
//				_nValX := ((((1+ALIQ.ICMS*(ALIQ.II+ALIQ.IPI*(1+ALIQ.II)))/((1-ALIQ.PIS-ALIQ.COFINS)*(1-ALIQ.ICMS)))))
				_nValX := ((((1+(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })]/100) *;
							 (     (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALIQII"})]/100) +;
							 (      aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_IPI"   })]/100) *;
							 ( 1 + (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALIQII"})]/100))))/;
							 ((1 - (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})]/100) -;
							 (      aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})]/100))*;
							 ( 1 - (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })]/100))))))
//				_nValY := (ALIQ.ICMS/(1-ALIQ.PIS-ALIQ.COFINS-ALIQ.ICMS))
				_nValY := (     (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })]/100) /;
							 ( 1 - (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS"})]/100) -;
							 (      aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF"})]/100) -;
							 (      aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"  })]/100)))
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASEPIS"})] := Round((aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF" })] * _nValX),TamSx3("D1_BASIMP6")[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALPIS" })] := Round((aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQPIS" })] /100) * ;
																											     aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASEPIS"})]          ,TamSx3("D1_VALIMP6")[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASECOF"})] := Round((aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF" })] * _nValX),TamSx3("D1_BASIMP5")[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCOF" })] := Round((aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_ALQCOF" })] /100) * ;
																											     aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASECOF"})]          ,TamSx3("D1_VALIMP5")[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASEICM"})] := Round((aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF" })] + ;
																											     aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"     })] + ;
																											     aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALIPI" })] + ;
																											     aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"})] + ;
																											     aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALPIS" })] + ;
																											     aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCOF" })])/ ;
																											    (1-(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"})] /100))   ,TamSx3("D1_BASEICM")[2])
				aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALICM" })] := Round((aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_BASEICM"})] * ;
																											    (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_PICM"   })] /100))   ,TamSx3("D1_VALICM" )[2])
			EndIf
		EndIf
	Next
EndIf
If (oFolder:nOption == 3 .AND. _nOpcBot == 1) .OR. IIF(Type("nFldAtu")<>"U",nFldAtu == 3,.F.)
	aColsResu := {}
	For _x := 1 To Len(aColsItem)
		IncProc()
		If !aColsItem[_x,Len(aHeadItem)+1]
			_nLinArr := aScan(aColsResu,{|x| AllTrim(x[2]+x[3]) == AllTrim(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DOC"  })]+aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SERIE"})])})
			If _nLinArr == 0
				Aadd(aColsResu,{	aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_EMISSAO"})],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DOC"    })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SERIE"  })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"  })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"  })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"})],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO" })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"     })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALPIS" })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCOF" })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALIPI" })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALICM" })],;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"  })] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"  })] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"})] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO" })] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"     })] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALPIS" })] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCOF" })] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALIPI" })] + ;
										aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALICM" })],;
								.F. } )
			Else
				aColsResu[_nLinArr][04] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"  })]
				aColsResu[_nLinArr][05] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"  })]
				aColsResu[_nLinArr][06] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"})]
				aColsResu[_nLinArr][07] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO" })]
				aColsResu[_nLinArr][08] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"     })]
				aColsResu[_nLinArr][09] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALPIS" })]
				aColsResu[_nLinArr][10] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCOF" })]
				aColsResu[_nLinArr][11] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALIPI" })]
				aColsResu[_nLinArr][12] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALICM" })]
				aColsResu[_nLinArr][13] += aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TOTAL"  })] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"  })] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"})] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO" })] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"     })] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALPIS" })] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCOF" })] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALIPI" })] + ;
												   aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALICM" })]
			EndIf
		EndIf
	Next
	If Len(aColsResu) == 0
		Aadd(aColsResu,{STOD(""),"","",0,0,0,0,0,0,0,0,0,0,.F.})
	EndIf
EndIf
If (oFolder:nOption == 2 .AND. _nOpcBot == 1) .OR. IIF(Type("nFldAtu")<>"U",nFldAtu == 2,.F.)
	aColsDupl := {}
	_nItem    := 0
	If	!Empty(M->ZJ_FORNECE) .AND. ;
		!Empty(M->ZJ_LOJA   )
		MaFisEnd()
		MaFisIni(M->ZJ_FORNECE,;
		         M->ZJ_LOJA,;
		         "F",;
		         "N",;
		         "R",;
		         NIL,;
		         ,;
		         ,;
		         "SB1",;
		         "RCOME005";
		        )
		For _x := 1 To Len(aColsItem)
			IncProc()
			If !aColsItem[_x,Len(aHeadItem)+1]
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1") + aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_COD"})])
					dbSelectArea("SF4")
					dbSetOrder(1)
					If dbSeek(xFilial("SF4") + aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TES"})])
	/*
						MaFisAdd(;
						cProduto,;   					// 1-Codigo do Produto ( Obrigatorio )
						cTes,;						   	// 2-Codigo do TES ( Opcional )
						nQtd,;						  	// 3-Quantidade ( Obrigatorio )
						nPrcUnit,;  				 	// 4-Preco Unitario ( Obrigatorio )
						nDesconto,; 				 	// 5-Valor do Desconto ( Opcional )
						cNFOri,;					   	// 6-Numero da NF Original ( Devolucao/Benef )
						cSEROri,;						// 7-Serie da NF Original ( Devolucao/Benef )
						nRecOri,;						// 8-RecNo da NF Original no arq SD1/SD2
						nFrete,;						// 9-Valor do Frete do Item ( Opcional )
						nDespesa,;						// 10-Valor da Despesa do item ( Opcional )
						nSeguro,;						// 11-Valor do Seguro do item ( Opcional )
						nFretAut,;						// 12-Valor do Frete Autonomo ( Opcional )
						nValMerc,;						// 13-Valor da Mercadoria ( Obrigatorio )
						nValEmb,;						// 14-Valor da Embalagem ( Opiconal )
						nRecSB1,;						// 15-RecNo do SB1
						nRecSF4)						// 16-RecNo do SF4
	*/
						MaFisAdd(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_COD"      })],;
						         aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_TES"      })],;
						         aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_QUANT"    })],;
						        (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF"   })]+aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"})])/aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_QUANT"})],;
						         0,;
						         ,;
						         ,;
						         ,;
									Round(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_FRETE"    })],TamSx3("D1_VALFRE" )[2]),;
									Round(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_DESPESA"  })],TamSx3("D1_DESPESA")[2]),;
									Round(aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_SEGURO"   })],TamSx3("D1_SEGURO" )[2]),;
						         0,;
						        (aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_VALCIF"   })]+aColsItem[_x,aScan(aHeadItem,{|x|AllTrim(x[2])=="ZK_II"})]),;
						         0,;
						         SB1->(Recno()),;
						         SF4->(Recno()) ;
						        )
						_nItem++
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	_aFaturas := {}
	dbSelectArea("SE4")
	dbSetOrder(1)
	If _nItem > 0 .AND. dbSeek(xFilial("SE4") + M->ZJ_COND)
		_aFaturas := Condicao((MaFisRet(,"NF_BASEDUP")-MaFisRet(,"NF_DESCZF")),M->ZJ_COND,MaFisRet(,"NF_VALIPI"),dDataBase,MaFisRet(,"NF_VALSOL"))
	EndIf
	For nX := 1 To Len(_aFaturas)
		IncProc()
		Aadd(aColsDupl,{_aFaturas[nX][01],_aFaturas[nX][02],.F.})
	Next
	If Len(aColsDupl) == 0
		IncProc()
		Aadd(aColsDupl,{STOD(""),0,.F.})
	EndIf
EndIf

MaFisEnd()

If Type("oFolder")<>"U" .AND. Type("oGetItens")<>"U" .AND. Type("oGetDupl")<>"U" .AND. Type("oGetResu")<>"U"
	If IIF(Type("nFldAtu")<>"U",nFldAtu == 1,.F.)		//oFolder:nOption == 1			//Itens
		aCols := aClone(aColsItem)
	ElseIf IIF(Type("nFldAtu")<>"U",nFldAtu == 2,.F.)	//oFolder:nOption == 2			//Duplicatas
		aCols := aClone(aColsDupl)
	ElseIf IIF(Type("nFldAtu")<>"U",nFldAtu == 3,.F.)	//oFolder:nOption == 3			//Resumo
		aCols := aClone(aColsResu)
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMA001G  ºAutor  ³Anderson C. P. Coelho º Data ³  27/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de geração do(s) documento(s) de entrada(s), com    º±±
±±º          ³base no lançamento da importação.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMA001G(cAlias,nReg,nOpc)

Processa({|| GeraNF(cAlias,nReg,nOpc) }, "Geração do Documento de Entrada","Processando informações...",.F.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraNF    ºAutor  ³Anderson C. P. Coelho º Data ³  27/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de geração do(s) documento(s) de entrada(s), com    º±±
±±º          ³base no lançamento da importação.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005 (COMA001G)                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraNF(cAlias,nReg,nOpc)

Local _aSavSZJ      := SZJ->(GetArea())
Local _aSavSZK      := SZK->(GetArea())

Local _aCab         := {}
Local _aItem        := {}

Local nItemNf       := 0

Local _lContinua    := .F.
Local nY			:= 0
Local nX			:= 0		

Private cTipo       := "N"
Private cFormul     := "S"
Private cSerie      := ""
Private cNFiscal    := ""
Private _cNFOK      := ""
Private cA100For    := SZJ->ZJ_FORNECE
Private cLoja       := SZJ->ZJ_LOJA
Private cEspecie    := SZJ->ZJ_ESPECIE
Private cCondicao   := SZJ->ZJ_COND
Private cNatureza   := SZJ->ZJ_NATUREZ

Private dDEmissao   := dDataBase

Private _nMoeda     := 01
Private nMoedaCor	:= 1
Private _nICMS      := 0
Private _nIPI       := 0
Private _nValII     := 0
Private _nCIF       := 0
Private _nFOB_R     := 0
Private _nBasImp6   := 0
Private _nValImp6   := 0
Private _nBasImp5   := 0
Private _nValImp5   := 0
Private _nBaseIcm   := 0
Private _nValIcm    := 0
Private _nBaseIpi   := 0
Private _nValIpi    := 0
Private _nDesp      := 0
Private _nFrete     := 0
Private _nSegur     := 0

Private aHeader     := {}
Private aCols       := {}
Private aHeadSE2    := {}
Private aColsSE2    := {}

Private lMsErroAuto := .F.
Private lAmarra     := .F.
Private lPrecoDes   := .F.
Private lDataUcom   := .T.
Private lAtuAmarra  := .T.

dbSelectArea("SF1")
dbSetOrder(1)
If Empty(SZJ->ZJ_DOC) .OR. !dbSeek(xFilial("SF1") + SZJ->ZJ_DOC + SZJ->ZJ_SERIE)
	If MsgYesNo("Deseja realmente gerar o documento de entrada referente a esta importação neste momento?","NOTA FISCAL")
		If ( _lContinua := NfeNextDoc(@cNFiscal,@cSerie,.T.))
			nItemNf     := a460NumIt(cSerie)
			ProcRegua(nItemNf)
			_nCont      := 0
			nRecSF1     := 0
			nIndexSE2   := 0
			nCounterSD1 := 0
			cCpBasePIS  := ""
			cCpValPIS   := ""
			cCpAlqPIS   := ""
			cCpBaseCOF  := ""
			cCpValCOF   := ""
			cCpAlqCOF   := ""
			cQuery      := ""
			cDelSDE     := ""
			cRecIss     := ""
			cFornIss    := ""
			cLojaIss    := ""
			cDirf       := ""
			cCodRet     := ""
			cModRetPIS  := ""
			dVencIss    := STOD("")
			_aFaturas   := {}
			aHeadSEV    := {}
			aColsSEV    := {}
			aRecSD1     := {}
			aRecSE2     := {}
			aRecSF3     := {}
			aRecSC5     := {}
			aHeadSDE    := {}
			aColsSDE    := {}
			aRecSDE     := {}
			aRecSF1Ori  := {}
			aRatVei     := {}
			aRatFro     := {}
			aCodR       := {}
			aRecClasSD1 := {}
			aMultas     := {}
			aRateio     := {}
			aNFEletr    := {CriaVar("F1_NFELETR"),CriaVar("F1_CODNFE"),CriaVar("F1_EMINFE"),CriaVar("F1_HORNFE"),CriaVar("F1_CREDNFE"),CriaVar("F1_NUMRPS")}
			lInclui     := .T.
			l103Inclui  := .T.
			lDigita     := .F.				//Contabiliza online?
			lAglutina   := .F.				//Aglutina Lançamento Contábil
			lDeleta     := .F.				//Exclusão do Documento de Entrada
			lCtbOnLine  := .F.				//Contabilizou online?
			lConFrete   := .F.
			lConImp     := .F.
			lBloqueio   := .F.
			lTxNeg      := .F.
			lEstNfClass := .F.
			l103Class   := .T.
			lRatLiq     := .T.				//Rateia multiplas naturezas (.T. = Líquido  /  .F. = Bruto)
			lRatImp     := .T.				//Rateia multiplas naturezas (.T. = Bruto e Titulo/Impostos)
			lQuery      := .T.
			lClassOrd	:= ( SuperGetMV( "MV_CLASORD" ) == "1" )  //Indica se na classificacao do documento de entrada os itens devem ser ordenados por ITEM+COD.PRODUTO
			lNfeOrd		:= ( GetNewPar( "MV_NFEORD" , "2" ) == "1" ) // Indica se na visualizacao do documento de entrada os itens devem ser ordenados por ITEM+COD.PRODUTO
			dbSelectArea("SX3")
			dbSetOrder(1)
			If dbSeek("SE2")
				While !EOF() .AND. X3_ARQUIVO == "SE2"
					IncProc("Montando estrutura das parcelas...")
					If X3USO(X3_USADO) .AND. cNivel>=X3_NIVEL
						AADD(aHeadSE2,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
					EndIf
					dbSelectArea("SX3")
					dbSetOrder(1)
					dbSkip()
				EndDo
			EndIf
			nPParcela := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_PARCELA"})
			nPVencto  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VENCTO" })
			nPValor   := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VALOR"  })
			nPFilOri  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_FILORIG"})
			aHeader   := {}
			dbSelectArea("SX3")
			dbSetOrder(1)
			If dbSeek("SD1")
				While !EOF() .AND. AllTrim(X3_ARQUIVO) == "SD1"
					IncProc("Montando estrutura dos itens do Documento de Entrada...")
					If AllTrim(X3_CONTEXT) <> "V"
						AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
					EndIf
					dbSelectArea("SX3")
					dbSetOrder(1)
					dbSkip()
				EndDo
				AADD(aHeader,{ "Alias WT", Padr("D1_ALI_WT",Len(X3_CAMPO)), Space(Len(X3_PICTURE)), 3 , 0, Space(Len(X3_VALID)), Padr("€€€€€€€€€€€€€€€",Len(X3_USADO)), Padr("C",Len(X3_TIPO)), Padr("SZK",Len(X3_ARQUIVO)), Padr("V",Len(X3_CONTEXT)) } )
				AADD(aHeader,{ "Recno WT", Padr("D1_REC_WT",Len(X3_CAMPO)), Space(Len(X3_PICTURE)), 10, 0, Space(Len(X3_VALID)), Padr("€€€€€€€€€€€€€€€",Len(X3_USADO)), Padr("N",Len(X3_TIPO)), Padr("SZK",Len(X3_ARQUIVO)), Padr("V",Len(X3_CONTEXT)) } )
			Else
				Alert("Estrutura da tabela SD1 não localizada!")
				RestArea(_aSavSZK)
				RestArea(_aSavSZJ)
				Return(.F.)
			EndIf
			IncProc("Processando informações de impostos...")
			MaFisEnd()
			MaFisIni(SZJ->ZJ_FORNECE,;
			         SZJ->ZJ_LOJA,;
			         "F",;
			         "N",;
			         NIL,;
			         NIL/*MaFisRelImp("MT100",{"SF1","SD1"})*/,;
			         ,;
			         /*!l103Visual*/,;
			         "SB1",;
			         "RCOME005";
			        )
			dbSelectArea("SZK")
			dbSetOrder(1)
			If dbSeek(xFilial("SZK") + SZJ->ZJ_NUM)
				aCols := {}
				While !EOF() .AND. SZK->ZK_NUM == SZJ->ZJ_NUM .AND. _lContinua
					IncProc("Estruturando informações dos itens...")
					_aSavSZK2 := SZK->(GetArea())
					dbSelectArea("SD1")
					dbSetOrder(1)
					If !dbSeek(xFilial("SD1") + SZK->ZK_DOC + SZK->ZK_SERIE + SZK->ZK_FORNECE + SZK->ZK_LOJA + SZK->ZK_ITEMNF)
						dbSelectArea("SB1")
						dbSetOrder(1)
						If dbSeek(xFilial("SB1") + SZK->ZK_COD)
							dbSelectArea("SF4")
							dbSetOrder(1)
							If dbSeek(xFilial("SF4") + SZK->ZK_TES)
/*								MaFisAdd(;
								cProduto,;   					// 1-Codigo do Produto ( Obrigatorio )
								cTes,;						   	// 2-Codigo do TES ( Opcional )
								nQtd,;						  	// 3-Quantidade ( Obrigatorio )
								nPrcUnit,;  				 	// 4-Preco Unitario ( Obrigatorio )
								nDesconto,; 				 	// 5-Valor do Desconto ( Opcional )
								cNFOri,;					   	// 6-Numero da NF Original ( Devolucao/Benef )
								cSEROri,;						// 7-Serie da NF Original ( Devolucao/Benef )
								nRecOri,;						// 8-RecNo da NF Original no arq SD1/SD2
								nFrete,;						// 9-Valor do Frete do Item ( Opcional )
								nDespesa,;						// 10-Valor da Despesa do item ( Opcional )
								nSeguro,;						// 11-Valor do Seguro do item ( Opcional )
								nFretAut,;						// 12-Valor do Frete Autonomo ( Opcional )
								nValMerc,;						// 13-Valor da Mercadoria ( Obrigatorio )
								nValEmb,;						// 14-Valor da Embalagem ( Opiconal )
								nRecSB1,;						// 15-RecNo do SB1
								nRecSF4)						// 16-RecNo do SF4
*/
								MaFisAdd(SZK->ZK_COD,;
								         SZK->ZK_TES,;
								         SZK->ZK_QUANT,;
								         SZK->(ZK_TOTAL+ZK_II)/SZK->ZK_QUANT,;
								         0,;
								         ,;
								         ,;
								         ,;
											Round(SZK->ZK_FRETE  ,TamSx3("D1_VALFRE" )[2]),;
											Round(SZK->ZK_DESPESA,TamSx3("D1_DESPESA")[2]),;
											Round(SZK->ZK_SEGURO ,TamSx3("D1_SEGURO" )[2]),;
								         0,;
								         SZK->(ZK_TOTAL+ZK_II),;
								         0,;
								         SB1->(Recno()),;
								         SF4->(Recno()) ;
								        )
								_nCont++
								MAFISALT("IT_ALIQPS2",SZK->ZK_ALQPIS ,_nCont)
								MAFISALT("IT_ALIQCF2",SZK->ZK_ALQCOF ,_nCont)
								MAFISALT("IT_ALIQIPI",SZK->ZK_IPI    ,_nCont)
								MAFISALT("IT_ALIQICM",SZK->ZK_PICM   ,_nCont)
								MAFISALT("IT_BASEIPI",SZK->ZK_BASEIPI,_nCont)
								MAFISALT("IT_VALIPI" ,SZK->ZK_VALIPI ,_nCont)
								MAFISALT("IT_BASEICM",SZK->ZK_BASEICM,_nCont)
								MAFISALT("IT_VALICM" ,SZK->ZK_VALICM ,_nCont)
								MAFISALT("IT_BASEPS2",SZK->ZK_BASEPIS,_nCont)
								MAFISALT("IT_VALPS2" ,SZK->ZK_VALPIS ,_nCont)
								MAFISALT("IT_BASECF2",SZK->ZK_BASECOF,_nCont)
								MAFISALT("IT_VALCF2" ,SZK->ZK_VALCOF ,_nCont)
								AADD(aCols,Array(Len(aHeader)+1))
								For nY := 1 To Len(aHeader)
									If AllTrim(aHeader[nY][2]) == "D1_ITEM"
										aCols[_nCont][nY]  	:= StrZero(_nCont,TamSx3("D1_ITEM")[1])
									Else
										If AllTrim(aHeader[nY,2]) == "D1_ALI_WT"
											aCols[Len(aCols)][nY] := "SD1"
										ElseIf AllTrim(aHeader[nY,2]) == "D1_REC_WT"
											aCols[Len(aCols)][nY] := 0
										Else
											aCols[_nCont][nY] := CriaVar(aHeader[nY][2])
										EndIf
									EndIf
									aCols[_nCont][Len(aHeader)+1] := .F.
								Next nY
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_COD"     })] := MAFISRET(_nCont, "IT_PRODUTO")
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_UM"      })] := SZK->ZK_UM
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_LOCAL"   })] := SZK->ZK_LOCAL
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_QUANT"   })] := MAFISRET(_nCont, "IT_QUANT"  )
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_VUNIT"   })] := MAFISRET(_nCont, "IT_PRCUNI" )
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_TOTAL"   })] := MAFISRET(_nCont, "IT_VALMERC")
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_TES"     })] := MAFISRET(_nCont, "IT_TES"    )
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_CF"      })] := MAFISRET(_nCont, "IT_CF"     )
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_CLASFIS" })] := SB1->B1_ORIGEM + SF4->F4_SITTRIB
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_NUM"     })] := SZK->ZK_NUM
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_ITSIM"   })] := SZK->ZK_ITEM
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_IPI"     })] := MAFISRET(_nCont, "IT_ALIQIPI")
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_PICM"    })] := MAFISRET(_nCont, "IT_ALIQICM")
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_BASEIPI" })] := Round(MAFISRET(_nCont, "IT_BASEIPI"),TamSx3("D1_BASEIPI")[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_VALIPI"  })] := Round(MAFISRET(_nCont, "IT_VALIPI" ),TamSx3("D1_VALIPI" )[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_BASEICM" })] := Round(MAFISRET(_nCont, "IT_BASEICM"),TamSx3("D1_BASEICM")[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_VALICM"  })] := Round(MAFISRET(_nCont, "IT_VALICM" ),TamSx3("D1_VALICM" )[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_ALQIMP5" })] := MAFISRET(_nCont, "IT_ALIQCF2")
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_BASIMP5" })] := Round(MAFISRET(_nCont, "IT_BASECF2"),TamSx3("D1_BASIMP5")[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_VALIMP5" })] := Round(MAFISRET(_nCont, "IT_VALCF2" ),TamSx3("D1_VALIMP5")[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_ALQIMP6" })] := MAFISRET(_nCont, "IT_ALIQPS2")
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_BASIMP6" })] := Round(MAFISRET(_nCont, "IT_BASECF2"),TamSx3("D1_BASIMP5")[2])	//Round(MAFISRET(_nCont, "IT_BASEPS2"),TamSx3("D1_BASIMP6")[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_VALIMP6" })] := Round(MAFISRET(_nCont, "IT_VALPS2" ),TamSx3("D1_VALIMP6")[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_VALFRE"  })] := Round(MAFISRET(_nCont, "IT_FRETE"  ),TamSx3("D1_VALFRE" )[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_SEGURO"  })] := Round(MAFISRET(_nCont, "IT_SEGURO" ),TamSx3("D1_SEGURO" )[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_DESPESA" })] := Round(MAFISRET(_nCont, "IT_DESPESA"),TamSx3("D1_DESPESA")[2])
								aCols[_nCont][aScan(aHeader,{|x|AllTrim(x[2])=="D1_VALCMAJ" })] := SZK->ZK_VALCMAJ
//								_nValMerc += SZK->(ZK_TOTAL+ZK_II)
//								_nValBrut += _nValMerc+SZK->(ZK_VALICM+ZK_VALIPI+ZK_VALPIS+ZK_VALCOF+ZK_FRETE+ZK_SEGURO+ZK_DESPESA)
								_nBaseIcm += Round(SZK->ZK_BASEICM,TamSx3("D1_BASEICM")[2])
								_nValIcm  += Round(SZK->ZK_VALICM ,TamSx3("D1_VALICM" )[2])
								_nBaseIpi += Round(SZK->ZK_BASEIPI,TamSx3("D1_BASEIPI")[2])
								_nValIpi  += Round(SZK->ZK_VALIPI ,TamSx3("D1_VALIPI" )[2])
								_nBasImp6 += Round(SZK->ZK_BASECOF,TamSx3("D1_BASIMP5")[2])		//Round(SZK->ZK_BASEPIS,TamSx3("D1_BASIMP6")[2])
								_nValImp6 += Round(SZK->ZK_VALPIS ,TamSx3("D1_VALIMP6")[2])
								_nBasImp5 += Round(SZK->ZK_BASECOF,TamSx3("D1_BASIMP5")[2])
								_nValImp5 += Round(SZK->ZK_VALCOF ,TamSx3("D1_VALIMP5")[2])
								_nDesp    += Round(SZK->ZK_DESPESA,TamSx3("D1_DESPESA")[2])
								_nFrete   += Round(SZK->ZK_FRETE  ,TamSx3("D1_VALFRE" )[2])
								_nSegur   += Round(SZK->ZK_SEGURO ,TamSx3("D1_SEGURO" )[2])
								_nValII   += SZK->ZK_II
								If _nCont >= nItemNf
									ProcRegua(nItemNf)
									If Len(aCols) > 0
										If Empty(cNFiscal) .AND. _lContinua
											While !(_lContinua := NfeNextDoc(@cNFiscal,@cSerie,.T.))
												MsgStop("Informe a série e número do documento fiscal!")
											EndDo
										EndIf
										IncProc("Iniciando geração da nota fiscal " + cNFiscal + "...")
										MAFISALT("NF_NATUREZA",cNatureza      )
										MAFISALT("NF_FRETE"   ,_nFrete        )
										MAFISALT("NF_SEGURO"  ,_nSegur        )
										MAFISALT("NF_DESPESA" ,_nDesp         )
										MAFISALT("NF_BASEIPI" ,_nBaseIpi      )
										MAFISALT("NF_VALIPI"  ,_nValIpi       )
										MAFISALT("NF_BASEICM" ,_nBaseIcm      )
										MAFISALT("NF_VALICM"  ,_nValIcm       )
										MAFISALT("NF_BASEPS2" ,_nBasImp6      )
										MAFISALT("NF_VALPS2"  ,_nValImp6      )
										MAFISALT("NF_BASECF2" ,_nBasImp5      )
										MAFISALT("NF_VALCF2"  ,_nValImp5      )
										dbSelectArea("SE4")
										dbSetOrder(1)
										If dbSeek(xFilial("SE4") + SZJ->ZJ_COND)
											_aFaturas := Condicao((MaFisRet(,"NF_BASEDUP")-MaFisRet(,"NF_DESCZF")),SZJ->ZJ_COND,MaFisRet(,"NF_VALIPI"),dDataBase,MaFisRet(,"NF_VALSOL"))
										EndIf
										aColsSE2 := {}
										If Len(_aFaturas) > 0
											For nX := 1 To Len(_aFaturas)
												aadd(aColsSE2,Array(Len(aHeadSE2)+1))
												For nY := 1 To Len(aHeadSE2)
													aColsSE2[nX][nY] := CriaVar(aHeadSE2[nY][2])
												Next nY
												aColsSE2[nX][Len(aHeadSE2)+1] := .F.
												aColsSE2[nX][nPParcela]       := cValToChar(nX)
												aColsSE2[nX][nPVencto ]       := _aFaturas[nX][01]
												aColsSE2[nX][nPValor  ]       := _aFaturas[nX][02]
											Next
										Else
											aadd(aColsSE2,Array(Len(aHeadSE2)+1))
											For nY := 1 To Len(aHeadSE2)
												aColsSE2[Len(aColsSE2)][nY] := CriaVar(aHeadSE2[nY][2])
											Next nY
										EndIf
										MaFisWrite(1)
										Begin Transaction
											dbSelectArea("SF1")
											dbSetOrder(1)
											RecLock("SF1",.T.)
											SF1->F1_FILIAL  := xFilial("SF1")
											SF1->F1_STATUS  := "A"
											SF1->F1_TIPO    := cTipo
											SF1->F1_FORMUL  := cFormul
											SF1->F1_EMISSAO := dDataBase
											SF1->F1_HORA    := Time() //Linha adicionada por Adriano Leonardo em 25/02/2016 para correção do campo que estava ficando vazio
											SF1->F1_DOC     := cNFiscal
											SF1->F1_SERIE   := cSerie
											SF1->F1_FORNECE := cA100For
											SF1->F1_LOJA    := cLoja
											SF1->F1_ESPECIE := cEspecie
											SF1->F1_COND    := cCondicao
											SF1->F1_MOEDA   := _nMoeda
											SF1->F1_TRANSP  := SZJ->ZJ_TRANSP
											SF1->F1_PLACA   := SZJ->ZJ_PLACA
											SF1->F1_TPFRETE := SZJ->ZJ_TPFRETE
//											SF1->F1_VOLUME1 := SZJ->ZJ_VOLUME1
//											SF1->F1_ESPECI1 := SZJ->ZJ_ESPECI1
//											SF1->F1_PBRUTO  := SZJ->ZJ_PESOB
//											SF1->F1_PLIQUI  := SZJ->ZJ_PESOL
//											SF1->F1_PESOL   := SZJ->ZJ_PESOL
											SF1->F1_MENNOTA := SZJ->ZJ_MENNOTA
											SF1->F1_MENPAD  := SZJ->ZJ_MENPAD
											SF1->F1_FRETE   := MAFISRET(,"NF_FRETE"  )
											SF1->F1_SEGURO  := MAFISRET(,"NF_SEGURO" )
											SF1->F1_DESPESA := MAFISRET(,"NF_DESPESA")
											SF1->F1_BASEICM := MAFISRET(,"NF_BASEICM")
											SF1->F1_VALICM  := MAFISRET(,"NF_VALICM" )
											SF1->F1_BASEIPI := MAFISRET(,"NF_BASEIPI")
											SF1->F1_VALIPI  := MAFISRET(,"NF_VALIPI" )
											SF1->F1_VALMERC := MAFISRET(,"NF_VALMERC")
											SF1->F1_VALBRUT := MAFISRET(,"NF_TOTAL"  )
											SF1->F1_BASIMP5 := MAFISRET(,"NF_BASECF2")
											SF1->F1_BASIMP6 := MAFISRET(,"NF_BASECF2")		//MAFISRET(,"NF_BASEPS2")
											SF1->F1_VALIMP5 := MAFISRET(,"NF_VALCF2" )
											SF1->F1_VALIMP6 := MAFISRET(,"NF_VALPS2" )
											SF1->(MSUNLOCK())
											nRecSF1 := SF1->(Recno())
											MsgRun("Aguarde... Gerando o Documento de Entrada " + AllTrim(cNFiscal) + "...",cCadastro,{ || a103Grava(lDeleta,lCtbOnLine,lDigita,lAglutina,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,nRecSF1,aRecSD1,aRecSE2,aRecSF3,aRecSC5,aHeadSDE,aColsSDE,aRecSDE,lConFrete,lConImp,aRecSF1Ori,aRatVei,aRatFro,cFornIss,cLojaIss,lBloqueio,l103Class,cDirf,cCodRet,cModRetPIS,nIndexSE2,lEstNfClass,dVencIss,lTxNeg,aMultas,lRatLiq,lRatImp,aNFEletr,cDelSDE,aCodR,cRecIss) })
											IncProc("Gerando Lançamento da Apuração do ICMS...")
											a103GrvCDA(.F.,"E",cEspecie,cFormul,cNFiscal,cSerie,cA100For,cLoja)
											IncProc("Finalizando a nota fiscal " + cNFiscal + "...")
										End Transaction
										If !Empty(_cNFOK)
											_cNFOK += "/"
										EndIf
										_cNFOK += AllTrim(cNFiscal)
										dbSelectArea("SD1")
										dbSetOrder(1)
										If dbSeek(xFilial("SD1") + cNFiscal + cSerie) .AND. !EOF() .AND. SD1->(D1_DOC+D1_SERIE) == (cNFiscal+cSerie)
											While !EOF() .AND. SD1->(D1_DOC+D1_SERIE) == (cNFiscal+cSerie)
												IncProc("Processando amarrações relativas a nota fiscal " + cNFiscal + "...")
												dbSelectArea("SZK")
												dbSetOrder(1)
												If dbSeek(xFilial("SZK") + SD1->(D1_NUM+D1_ITSIM+D1_COD))
													RecLock("SZK",.F.)
													SZK->ZK_EMISSAO := SD1->D1_EMISSAO
													SZK->ZK_DOC     := cNFiscal
													SZK->ZK_SERIE   := cSerie
													SZK->ZK_ITEMNF  := SD1->D1_ITEM
													SZK->(MSUNLOCK())
													DbSelectArea("CD5")
													DbSetOrder(4)
													If !dbSeek(xFilial("CD5")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
														RecLock("CD5",.T.)
													Else
														RecLock("CD5",.F.)
													EndIf
													CD5->CD5_FILIAL := xFilial("CD5")
													CD5->CD5_ITEM   := SD1->D1_ITEM
													CD5->CD5_DOC    := SD1->D1_DOC
													CD5->CD5_SERIE  := SD1->D1_SERIE
													CD5->CD5_ESPEC  := cEspecie
													CD5->CD5_FORNEC := SD1->D1_FORNECE
													CD5->CD5_LOJA   := SD1->D1_LOJA
													CD5->CD5_TPIMP  := "0"						//0=Declaracao de importacao;1=Declaracao simplificada de importacao
													CD5->CD5_DOCIMP := SZJ->ZJ_DI				//SZJ->ZJ_INVOICE
													CD5->CD5_NDI    := SZJ->ZJ_DI
													CD5->CD5_DTDI   := SZJ->ZJ_DATADI
													CD5->CD5_DTDES  := SZJ->ZJ_DTDESE
													CD5->CD5_LOCDES := SZJ->ZJ_LOCDESE
													CD5->CD5_UFDES  := SZJ->ZJ_UFDESE
													CD5->CD5_CODEXP := SZJ->ZJ_DESPACH
													CD5->CD5_NADIC  := SZK->ZK_ADICAO
													CD5->CD5_SQADIC := SZK->ZK_SEQADI
													CD5->CD5_CODFAB := SZK->ZK_FABRIC
													CD5->CD5_VDESDI := SZK->ZK_DESPESA
													CD5->CD5_VLRII  := SZK->ZK_II
//													CD5->CD5_BSPIS  := 
//													CD5->CD5_ALPIS  := 
//													CD5->CD5_VLPIS  := 
//													CD5->CD5_DTPPIS := 
//													CD5->CD5_BSCOF  := 
//													CD5->CD5_ALCOF  := 
//													CD5->CD5_VLCOF  := 
//													CD5->CD5_DTPCOF :=
                                       
													//Início - Trecho adicionado por Adriano Leonardo em 31/03/2015 para atender a NF versão 3.10
													CD5->CD5_VTRANS  := SZJ->ZJ_VTRANS
													CD5->CD5_VAFRMM  := SZJ->ZJ_VAFRMM
													CD5->CD5_INTERM  := SZJ->ZJ_INTERM
													CD5->CD5_CNPJAE  := SZJ->ZJ_CNPJAE
													CD5->CD5_UFTERC  := SZJ->ZJ_UFTERC
													CD5->CD5_LOCAL	  := SZJ->ZJ_LOCAL
													//Final  - Trecho adicionado por Adriano Leonardo em 31/03/2015
													
													CD5->(MSUNLOCK())
												Else
													Alert("Problemas na gracação do relacionamento do produto " + AllTrim(SD1->D1_COD) + " da simulação!")
												EndIf
												dbSelectArea("SD1")
												dbSetOrder(1)
												dbSkip()
											EndDo
											dbSelectArea("SZJ")
											RecLock("SZJ",.F.)
											SZJ->ZJ_DOC     := cNFiscal
											SZJ->ZJ_SERIE   := cSerie
											SZJ->ZJ_EMISSAO := SD1->D1_EMISSAO
											SZJ->(MSUNLOCK())
										Else
											Alert("Problemas encontrados após a geração do documento de entrada, na amarração dos itens do documento de entrada com a simulação da importação!")
										EndIf
									Else
										Alert("ATENÇÃO!!! Documento de entrada " + AllTrim(cNFiscal) + ", vinculado a simulação " + AllTrim(SZJ->ZJ_NUM) + " não gerado!")
										RestArea(_aSavSZJ)
										RestArea(_aSavSZK)
										Return
									EndIf
									_nCont      := 0
//									_nValMerc   := 0
//									_nValBrut   := 0
									_nBaseIcm   := 0
									_nValIcm    := 0
									_nBaseIpi   := 0
									_nValIpi    := 0
									_nBasImp6   := 0
									_nValImp6   := 0
									_nBasImp5   := 0
									_nValImp5   := 0
									_nDesp      := 0
									_nFrete     := 0
									_nSegur     := 0
									_nValII     := 0
									nRecSF1     := 0
									nIndexSE2   := 0
									nCounterSD1 := 0
									cNFiscal    := ""
									cCpBasePIS  := ""
									cCpValPIS   := ""
									cCpAlqPIS   := ""
									cCpBaseCOF  := ""
									cCpValCOF   := ""
									cCpAlqCOF   := ""
									cQuery      := ""
									cDelSDE     := ""
									cRecIss     := ""
									cFornIss    := ""
									cLojaIss    := ""
									cDirf       := ""
									cCodRet     := ""
									cModRetPIS  := ""
									dVencIss    := STOD("")
									aCols       := {}
									_aFaturas   := {}
									aHeadSEV    := {}
									aColsSEV    := {}
									aRecSD1     := {}
									aRecSE2     := {}
									aRecSF3     := {}
									aRecSC5     := {}
									aHeadSDE    := {}
									aColsSDE    := {}
									aRecSDE     := {}
									aRecSF1Ori  := {}
									aRatVei     := {}
									aRatFro     := {}
									aCodR       := {}
									aRecClasSD1 := {}
									aMultas     := {}
									aRateio     := {}
									aNFEletr    := {CriaVar("F1_NFELETR"),CriaVar("F1_CODNFE"),CriaVar("F1_EMINFE"),CriaVar("F1_HORNFE"),CriaVar("F1_CREDNFE"),CriaVar("F1_NUMRPS")}
									lInclui     := .T.
									l103Inclui  := .T.
									lDigita     := .F.				//Contabiliza online?
									lAglutina   := .F.				//Aglutina Lançamento Contábil
									lDeleta     := .F.				//Exclusão do Documento de Entrada
									lCtbOnLine  := .F.				//Contabilizou online?
									lConFrete   := .F.
									lConImp     := .F.
									lBloqueio   := .F.
									lTxNeg      := .F.
									lEstNfClass := .F.
									l103Class   := .T.
									lRatLiq     := .T.				//Rateia multiplas naturezas (.T. = Líquido  /  .F. = Bruto)
									lRatImp     := .T.				//Rateia multiplas naturezas (.T. = Bruto e Titulo/Impostos)
									lQuery      := .T.
									lClassOrd	:= ( SuperGetMV( "MV_CLASORD" ) == "1" )  //Indica se na classificacao do documento de entrada os itens devem ser ordenados por ITEM+COD.PRODUTO
									lNfeOrd		:= ( GetNewPar( "MV_NFEORD" , "2" ) == "1" ) // Indica se na visualizacao do documento de entrada os itens devem ser ordenados por ITEM+COD.PRODUTO
									MaFisEnd()
									MaFisIni(SZJ->ZJ_FORNECE,;
									         SZJ->ZJ_LOJA,;
									         "F",;
									         "N",;
									         NIL,;
									         NIL/*MaFisRelImp("MT100",{"SF1","SD1"})*/,;
									         ,;
									         /*!l103Visual*/,;
									         "SB1",;
									         "RCOME005";
									        )
								EndIf
							EndIf
						EndIf
					EndIf
					RestArea(_aSavSZK2)
					dbSelectArea("SZK")
					dbSetOrder(1)
					dbSkip()
				EndDo
				If Len(aCols) > 0
					If Empty(cNFiscal) .AND. _lContinua
						While !(_lContinua := NfeNextDoc(@cNFiscal,@cSerie,.T.))
							MsgStop("Informe a série e número do documento fiscal!")
						EndDo
					EndIf
					IncProc("Iniciando geração da nota fiscal " + cNFiscal + "...")
					MAFISALT("NF_NATUREZA",cNatureza      )
					MAFISALT("NF_FRETE"   ,_nFrete        )
					MAFISALT("NF_SEGURO"  ,_nSegur        )
					MAFISALT("NF_DESPESA" ,_nDesp         )
					MAFISALT("NF_BASEIPI" ,_nBaseIpi      )
					MAFISALT("NF_VALIPI"  ,_nValIpi       )
					MAFISALT("NF_BASEICM" ,_nBaseIcm      )
					MAFISALT("NF_VALICM"  ,_nValIcm       )
					MAFISALT("NF_BASEPS2" ,_nBasImp6      )
					MAFISALT("NF_VALPS2"  ,_nValImp6      )
					MAFISALT("NF_BASECF2" ,_nBasImp5      )
					MAFISALT("NF_VALCF2"  ,_nValImp5      )
					dbSelectArea("SE4")
					dbSetOrder(1)
					If dbSeek(xFilial("SE4") + SZJ->ZJ_COND)
						_aFaturas := Condicao((MaFisRet(,"NF_BASEDUP")-MaFisRet(,"NF_DESCZF")),SZJ->ZJ_COND,MaFisRet(,"NF_VALIPI"),dDataBase,MaFisRet(,"NF_VALSOL"))
					EndIf
					aColsSE2 := {}
					If Len(_aFaturas) > 0
						For nX := 1 To Len(_aFaturas)
							aadd(aColsSE2,Array(Len(aHeadSE2)+1))
							For nY := 1 To Len(aHeadSE2)
								aColsSE2[nX][nY] := CriaVar(aHeadSE2[nY][2])
							Next nY
							aColsSE2[nX][Len(aHeadSE2)+1] := .F.
							aColsSE2[nX][nPParcela]       := cValToChar(nX)
							aColsSE2[nX][nPVencto ]       := _aFaturas[nX][01]
							aColsSE2[nX][nPValor  ]       := _aFaturas[nX][02]
						Next
					EndIf
/*					Else
						nX := 1
						aadd(aColsSE2,Array(Len(aHeadSE2)+1))
						For nY := 1 To Len(aHeadSE2)
							aColsSE2[nX][nY] := CriaVar(aHeadSE2[nY][2])
						Next nY
					EndIf     
					*/
					MaFisWrite(1)
					Begin Transaction
						dbSelectArea("SF1")
						dbSetOrder(1)
						RecLock("SF1",.T.)
						SF1->F1_FILIAL  := xFilial("SF1")
						SF1->F1_STATUS  := "A"
						SF1->F1_TIPO    := cTipo
						SF1->F1_FORMUL  := cFormul
						SF1->F1_EMISSAO := dDataBase
						SF1->F1_HORA    := Time() //Linha adicionada por Adriano Leonardo em 25/02/2016 para correção do campo que estava ficando vazio
						SF1->F1_DOC     := cNFiscal
						SF1->F1_SERIE   := cSerie
						SF1->F1_FORNECE := cA100For
						SF1->F1_LOJA    := cLoja
						SF1->F1_ESPECIE := cEspecie
						SF1->F1_COND    := cCondicao
						SF1->F1_MOEDA   := _nMoeda
						SF1->F1_TRANSP  := SZJ->ZJ_TRANSP
						SF1->F1_PLACA   := SZJ->ZJ_PLACA
						SF1->F1_TPFRETE := SZJ->ZJ_TPFRETE
						SF1->F1_VOLUME1 := SZJ->ZJ_VOLUME1
						SF1->F1_ESPECI1 := SZJ->ZJ_ESPECI1
						SF1->F1_PBRUTO  := SZJ->ZJ_PESOB
						SF1->F1_PLIQUI  := SZJ->ZJ_PESOL
						SF1->F1_PESOL   := SZJ->ZJ_PESOL
						SF1->F1_MENNOTA := SZJ->ZJ_MENNOTA
						SF1->F1_MENPAD  := SZJ->ZJ_MENPAD
						SF1->F1_FRETE   := MAFISRET(,"NF_FRETE"  )
						SF1->F1_SEGURO  := MAFISRET(,"NF_SEGURO" )
						SF1->F1_DESPESA := MAFISRET(,"NF_DESPESA")
						SF1->F1_BASEICM := MAFISRET(,"NF_BASEICM")
						SF1->F1_VALICM  := MAFISRET(,"NF_VALICM" )
						SF1->F1_BASEIPI := MAFISRET(,"NF_BASEIPI")
						SF1->F1_VALIPI  := MAFISRET(,"NF_VALIPI" )
						SF1->F1_VALMERC := MAFISRET(,"NF_VALMERC")
						SF1->F1_VALBRUT := MAFISRET(,"NF_TOTAL"  )
						SF1->F1_BASIMP5 := MAFISRET(,"NF_BASECF2")
						SF1->F1_BASIMP6 := MAFISRET(,"NF_BASECF2")		//MAFISRET(,"NF_BASEPS2")
						SF1->F1_VALIMP5 := MAFISRET(,"NF_VALCF2" )
						SF1->F1_VALIMP6 := MAFISRET(,"NF_VALPS2" )
						SF1->(MSUNLOCK())
						nRecSF1 := SF1->(Recno())
						MsgRun("Aguarde... Gerando o Documento de Entrada " + AllTrim(cNFiscal) + "...",cCadastro,{ || a103Grava(lDeleta,lCtbOnLine,lDigita,lAglutina,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,nRecSF1,aRecSD1,aRecSE2,aRecSF3,aRecSC5,aHeadSDE,aColsSDE,aRecSDE,lConFrete,lConImp,aRecSF1Ori,aRatVei,aRatFro,cFornIss,cLojaIss,lBloqueio,l103Class,cDirf,cCodRet,cModRetPIS,nIndexSE2,lEstNfClass,dVencIss,lTxNeg,aMultas,lRatLiq,lRatImp,aNFEletr,cDelSDE,aCodR,cRecIss) })
						IncProc("Gerando Lançamento da Apuração do ICMS...")
						a103GrvCDA(.F.,"E",cEspecie,cFormul,cNFiscal,cSerie,cA100For,cLoja)
						IncProc("Finalizando a nota fiscal " + cNFiscal + "...")
					End Transaction
					If !Empty(_cNFOK)
						_cNFOK += "/"
					EndIf
					_cNFOK += AllTrim(cNFiscal)
					dbSelectArea("SD1")
					dbSetOrder(1)
					If dbSeek(xFilial("SD1") + cNFiscal + cSerie) .AND. !EOF() .AND. SD1->(D1_DOC+D1_SERIE) == (cNFiscal+cSerie)
						While !EOF() .AND. SD1->(D1_DOC+D1_SERIE) == (cNFiscal+cSerie)
							IncProc("Processando amarrações relativas a nota fiscal " + cNFiscal + "...")
							dbSelectArea("SZK")
							dbSetOrder(1)
							If dbSeek(xFilial("SZK") + SD1->(D1_NUM+D1_ITSIM+D1_COD))
								RecLock("SZK",.F.)
								SZK->ZK_EMISSAO := SD1->D1_EMISSAO
								SZK->ZK_DOC     := cNFiscal
								SZK->ZK_SERIE   := cSerie
								SZK->ZK_ITEMNF  := SD1->D1_ITEM
								SZK->(MSUNLOCK())
								DbSelectArea("CD5")
								DbSetOrder(4)
								If !dbSeek(xFilial("CD5")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)													
									RecLock("CD5",.T.)
								Else
									RecLock("CD5",.F.)
								EndIf
								CD5->CD5_FILIAL := xFilial("CD5")
								CD5->CD5_ITEM   := SD1->D1_ITEM
								CD5->CD5_DOC    := SD1->D1_DOC
								CD5->CD5_SERIE  := SD1->D1_SERIE
								CD5->CD5_ESPEC  := cEspecie
								CD5->CD5_FORNEC := SD1->D1_FORNECE
								CD5->CD5_LOJA   := SD1->D1_LOJA
								CD5->CD5_TPIMP  := "0"						//0=Declaracao de importacao;1=Declaracao simplificada de importacao
								CD5->CD5_DOCIMP := SZJ->ZJ_DI				//SZJ->ZJ_INVOICE
								CD5->CD5_NDI    := SZJ->ZJ_DI
								CD5->CD5_DTDI   := SZJ->ZJ_DATADI
								CD5->CD5_DTDES  := SZJ->ZJ_DTDESE
								CD5->CD5_LOCDES := SZJ->ZJ_LOCDESE
								CD5->CD5_UFDES  := SZJ->ZJ_UFDESE
								CD5->CD5_CODEXP := SZJ->ZJ_DESPACH
								CD5->CD5_NADIC  := SZK->ZK_ADICAO
								CD5->CD5_SQADIC := SZK->ZK_SEQADI
								CD5->CD5_CODFAB := SZK->ZK_FABRIC
								CD5->CD5_VDESDI := SZK->ZK_DESPESA
								CD5->CD5_VLRII  := SZK->ZK_II
//								CD5->CD5_BSPIS  := 
//								CD5->CD5_ALPIS  := 
//								CD5->CD5_VLPIS  := 
//								CD5->CD5_DTPPIS := 
//								CD5->CD5_BSCOF  := 
//								CD5->CD5_ALCOF  := 
//								CD5->CD5_VLCOF  := 
//								CD5->CD5_DTPCOF := 

								//Início - Trecho adicionado por Adriano Leonardo em 31/03/2015 para atender a NF versão 3.10
								CD5->CD5_VTRANS  := SZJ->ZJ_VTRANS
								CD5->CD5_VAFRMM  := SZJ->ZJ_VAFRMM
								CD5->CD5_INTERM  := SZJ->ZJ_INTERM
								CD5->CD5_CNPJAE  := SZJ->ZJ_CNPJAE
								CD5->CD5_UFTERC  := SZJ->ZJ_UFTERC
								CD5->CD5_LOCAL	  := SZJ->ZJ_LOCAL
								//Final  - Trecho adicionado por Adriano Leonardo em 31/03/2015
								CD5->(MSUNLOCK())
							Else
								Alert("Problemas na gravação do relacionamento do produto " + AllTrim(SD1->D1_COD) + " da simulação!")
							EndIf
							dbSelectArea("SD1")
							dbSetOrder(1)
							dbSkip()
						EndDo
						dbSelectArea("SZJ")
						RecLock("SZJ",.F.)
						SZJ->ZJ_DOC     := cNFiscal
						SZJ->ZJ_SERIE   := cSerie
						SZJ->ZJ_EMISSAO := SD1->D1_EMISSAO
						SZJ->(MSUNLOCK())
						IncProc("Finalizando Processos...")
					Else
						Alert("Problemas encontrados após a geração do documento de entrada, na amarração dos itens do documento de entrada com a simulação da importação!")
					EndIf
				Else
					Alert("ATENÇÃO!!! Documento de entrada " + AllTrim(cNFiscal) + ", vinculado a simulação " + AllTrim(SZJ->ZJ_NUM) + " não gerado!")
					RestArea(_aSavSZJ)
					RestArea(_aSavSZK)
					Return
				EndIf
			Else
				Alert("Não foram encontrados itens para a simulação " + AllTrim(SZJ->ZJ_NUM) + ".")
			EndIf
		EndIf
	EndIf
Else
	Alert("Documento de Entrada já gerado. Operação não permitida!")
EndIf

IncProc("Finalizando Processos...")
MaFisEnd()
RestArea(_aSavSZJ)
RestArea(_aSavSZK)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMA001I  ºAutor  ³Anderson C. P. Coelho º Data ³  27/07/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de importação do arquivo CVS, conforme layout espe- º±±
±±º          ³cificado no projeto.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOME005                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMA001I(cAlias,nReg,nOpc)

Private cDrive, cDir, cNome, cExt
Private aErro    := {}
Private cArq     := AllTrim(Lower(SelDirArq()))

nOpc := 4

If !Empty(cArq)
	SplitPath(cArq, @cDrive, @cDir, @cNome, @cExt)
	If !File(cDrive+cDir+cNome+cExt) .OR. ".CSV"<>UPPER(cExt)
		MsgStop("O arquivo " + cDrive+cDir+cNome+cExt + " não foi encontrado ou encontra-se em formato divergente. A importação será abortada!","COMA001I_ABORT")
		Return
	EndIf

	Processa( { || ImportArq() }, "Importação de arquivo CSV","Aguarde, processando arquivo...",.F.)
Else
	Alert("Nenhum arquivo selecionado!")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SelDirArq ºAutor  ³Anderson C. P. Coelho º Data ³  14/07/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleçao de arquivo em diretorio.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SelDirArq()

cTipo := "Arquivos Excel do tipo CSV | *.CSV"
cArq := cGetFile(cTipo, "Selecione o arquivo a ser carregado ",0,"C:\",.F.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY)

Return(cArq)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A103Grava ³ Autor ³ Edson Maricate       ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravacao da Nota Fiscal de Entrada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103Grava(ExpC1,ExpN2,ExpA3)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExpC1 : Controle de Gravacao  1,                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function a103Grava(lDeleta,lCtbOnLine,lDigita,lAglutina,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,nRecSF1,aRecSD1,aRecSE2,aRecSF3,aRecSC5,aHeadSDE,aColsSDE,aRecSDE,lConFrete,lConImp,aRecSF1Ori,aRatVei,aRatFro,cFornIss,cLojaIss,lBloqueio,l103Class,cDirf,cCodRet,cModRetPIS,nIndexSE2,lEstNfClass,dVencIss,lTxNeg,aMultas,lRatLiq,lRatImp,aNFEletr,cDelSDE,aCodR,cRecIss)

Local aPedPV	:= {}
Local aCustoEnt := {}
Local aCustoSDE := {}
Local aSEZ      := {}
Local aContratos:= {}
Local aRecGerSE2:= {}
Local cArquivo  := ""
Local cLote     := ""
Local nHdlPrv   := 0
Local nTotalLcto:= 0
Local nV        := 0
Local nX        := 0
Local nY        := 0
Local nZ        := 0
Local nW        := 0
Local nOper     := 0
Local nUsadoSDE := Len(aHeadSDE)
Local nTaxaNCC  := 0
Local lVer640	:= .F.
Local lVer641	:= .F.
Local lVer650	:= .F.
Local lVer651	:= .F.
Local lVer656	:= .F.
Local lVer660	:= .F.
Local lVer642	:= .F.
Local lVer655	:= .F.
Local lVer665	:= .F.
Local lVer955   := .F.
Local lVer950   := .F.
Local lUsaGCT   := FINDFUNCTION( "A103GCDISP" ) .And. A103GCDisp()
Local cBaseAtf	:= ""
Local cItemAtf	:= ""
Local nItRat    := 0
Local lCompensa := SuperGetMv("MV_CMPDEVV",.F.,.F.)
Local cAliasSE1 := "SE1"
Local aRecSe1   := {}
Local aRecNCC   := {}
Local aStruSE1  := {}
Local nTotalDev := 0
Local lQuery    := .F.
Local cQuery    := ""
Local cMT103APV := ""
Local cGrupo    := SuperGetMv("MV_NFAPROV")
Local cTipoNf   := SuperGetMv("MV_TPNRNFS")
Local nPParcela := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_PARCELA"})
Local nPVencto  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VENCTO"})
Local nPValor   := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VALOR"})
Local aDadosMail:=ARRAY(6) // Doc,Serie,Fornecedor,Loja,Nome,Opcao
Local aDetalheMail:={}
Local cMdRtISS	:= "1"
Local cB1FRETISS := ""
Local cA2FRETISS	:=	""
Local cLocCQ        := GetMV('MV_CQ')
Local lAchou      := .F.
Local nRecSD1SDE  := 0
Local cCIAP		:= ""
Local aCIAP		:= {}
Local lImpRel	:= Existblock("QIEIMPRL")
Local lGeraSD9	:= .T.						// Valida se gera numero SD9

Private aDupl     := {}
Private cNewItSDG := ""

//-- Variaveis utilizadas pela funcao wmsexedcf
Private aLibSDB	  := {}
Private aWmsAviso := {}

DEFAULT lCtbOnLine:= .F.
DEFAULT lDeleta   := .F.
DEFAULT aHeadSE2  := {}
DEFAULT aColsSE2  := {}
DEFAULT aHeadSEV  := {}
DEFAULT aColsSEV  := {}
DEFAULT aHeadSDE  := {}
DEFAULT aColsSDE  := {}
DEFAULT nRecSF1   := 0
DEFAULT aRecSD1   := {}
DEFAULT aRecSE2   := {}
DEFAULT aRecSF3   := {}
DEFAULT aRecSC5   := {}
DEFAULT aRecSDE   := {}
DEFAULT lConFrete := .F.
DEFAULT lConImp   := .F.
DEFAULT aRecSF1Ori:= {}
DEFAULT aRatVei   := {}
DEFAULT aRatFro   := {}
DEFAULT lBloqueio := .F.
DEFAULT l103Class := .F.
DEFAULT lTxNeg	  := .F.
DEFAULT lRatLiq   := .T.
DEFAULT lRatImp   := .F.
DEFAULT aNFEletr  := {}
DEFAULT lEstNfClass := .F. //-- Estorno de Nota Fiscal Classificada (MATA140)
DEFAULT aMultas     := {}
DEFAULT cDelSDE     := "1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Template acionando ponto de entrada                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistTemplate("MT100GRV")
	ExecTemplate("MT100GRV",.F.,.F.,{lDeleta})
EndIf			

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada anterior a gravacao do Documento de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MT100GRV"))
	ExecBlock("MT100GRV",.F.,.F.,{lDeleta})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ha rotina automatica                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
l103Auto := If(Type("L103AUTO")=="U",.F.,l103Auto)
l103Auto := If(Type("L116AUTO")=="U",l103Auto,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ha contabilizacao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtbOnLine .Or. ( lDeleta .And. !Empty(SF1->F1_DTLANC))
	lCtbOnLine := .T.
	DbSelectArea("SX5")
	DbSetOrder(1)
	MsSeek(xFilial("SX5")+"09COM")
	cLote := IIf(Found(),Trim(X5DESCRI()),"COM ")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa um execblock                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At(UPPER("EXEC"),X5Descri()) > 0
		cLote := &(X5Descri())
	EndIf
	nHdlPrv := HeadProva(cLote,"MATA103",Subs(cUsuario,7,6),@cArquivo)
	If nHdlPrv <= 0
		lCtbOnLine := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica quais os lancamentos que estao habilitados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtbOnLine
	lVer640	:= VerPadrao("640") // Entrada de NF Devolucao/Beneficiamento ( Cliente ) - Itens
	lVer650	:= VerPadrao("650") // Entrada de NF Normal ( Fornecedor ) - Itens
	lVer660	:= VerPadrao("660") // Entrada de NF Normal ( Fornecedor ) - Total
	lVer642	:= VerPadrao("642") // Entrada de NF Devol.Vendas - Total (SF1)
	lVer655	:= VerPadrao("655") // Exclusao de NF ( Fornecedor ) - Itens
	lVer665	:= VerPadrao("665") // Exclusao de NF ( Fornecedor ) - Total
	lVer955 := VerPadrao("955") // Do SIGAEIC - Importacao
	lVer950 := VerPadrao("950") // Do SIGAEIC - Importacao
	lVer641	:= VerPadrao("641")	// Entrada de NF Devolucao/Beneficiamento ( Cliente ) - Itens do Rateio
	lVer651	:= VerPadrao("651")	// Entrada de NF Normal ( Fornecedor ) - Itens do Rateio
	lVer656	:= VerPadrao("656")	// Exclusao de NF ( Fornecedor ) - Itens do Rateio
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registros                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo$"DB"
	DbSelectArea("SA1")
	DbSetOrder(1)
	MsSeek(xFilial("SA1")+cA100For+cLoja)
Else
	DbSelectArea("SA2")
	DbSetOrder(1)
	MsSeek(xFilial("SA2")+cA100For+cLoja)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a operacao a ser realizada (Inclusao ou Exclusao )  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lDeleta
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao do cabecalho do documento de entrada             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SF1")
	DbSetOrder(1)
	If nRecSF1 <> 0
		MsGoto(nRecSF1)
		RecLock("SF1",.F.)
		nOper := 2
		If lBloqueio
			MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",SF1->F1_VALBRUT,,,SF1->F1_APROV,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem numero do documento quando utilizar ³
		//³ numeracao pelo SD9 (MV_TPNRNFS = 3)       ³
		//³ Se a chamada for do SIGALOJA nao pode     ³
		//³ gerar outro numero no SD9.                ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

		If ( FUNNAME() == "LOJA720" .OR. FUNNAME() == "LOJA701" )  
	    	If !Empty( cNFiscal )
				lGeraSD9	:= .F.
			Endif	
		Endif    
		
		If cTipoNf == "3" .AND. cFormul == "S" .AND. lGeraSD9 
			SX3->(DbSetOrder(1))
			If (SX3->(dbSeek("SD9")))
				// Se cNFiscal estiver vazio, busca numeração no SD9, senao, respeita o novo numero
				// digitado pelo usuario.
				cNFiscal := MA461NumNf(.T.,cSerie,cNFiscal)
			EndIf			
		Endif
		RecLock("SF1",.T.)
		nOper := 1
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atendimento ao DECRETO 5.052, DE 08/01/2004 para o municipio de ARARAS. ³
	//³Mais especificamente o paragrafo unico do Art 2.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cA2FRETISS	:=	SA2->(FieldGet (FieldPos ("A2_FRETISS")))
	SF1->F1_FILIAL  := xFilial("SF1")
	SF1->F1_DOC     := cNFiscal
	SF1->F1_STATUS  := "A"
	SF1->F1_SERIE   := cSerie
	SF1->F1_FORNECE := cA100For
	SF1->F1_LOJA    := cLoja
	SF1->F1_COND    := cCondicao
	If SA2->(FieldPos("A2_NUMRA"))==0 .Or. Empty(SA2->A2_NUMRA)
		SF1->F1_DUPL    := IIf(MaFisRet(,"NF_BASEDUP")>0,cNFiscal,"")
	ElseIf SF1->(FieldPos("F1_NUMRA"))<>0
		SF1->F1_NUMRA   := SA2->A2_NUMRA
	EndIf
	SF1->F1_TXMOEDA := MaFisRet(,"NF_TXMOEDA")
	SF1->F1_EMISSAO := dDEmissao
	SF1->F1_HORA    := Time() //Linha adicionada por Adriano Leonardo em 25/02/2016 para correção do campo que estava ficando vazio	
	SF1->F1_EST     := IIF(cTipo$"DB",SA1->A1_EST,SA2->A2_EST)
	SF1->F1_TIPO    := cTipo	
	SF1->F1_DTDIGIT := IIf(GetMv("MV_DATAHOM",NIL,"1") == "1".Or.Empty(SF1->F1_RECBMTO),dDataBase,SF1->F1_RECBMTO)
	SF1->F1_RECBMTO := SF1->F1_DTDIGIT
	SF1->F1_FORMUL  := IIF(cFormul=="S","S"," ")
	SF1->F1_ESPECIE := cEspecie
	SF1->F1_PREFIXO := IIf(MaFisRet(,"NF_BASEDUP")>0,&(SuperGetMV("MV_2DUPREF")),"")
	SF1->F1_ORIGLAN := IIf(lConFrete,"F"+SubStr(SF1->F1_ORIGLAN,2),SF1->F1_ORIGLAN)
	SF1->F1_ORIGLAN := IIf(lConImp,SubStr(SF1->F1_ORIGLAN,1,1)+"D",SF1->F1_ORIGLAN)
	If lBloqueio

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para alterar o Grupo de Aprovacao 	 										³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("MT103APV")
			cMT103APV := ExecBlock("MT103APV",.F.,.F.)
			If ValType(cMT103APV) == "C"
				cGrupo := cMT103APV
			EndIf
		EndIf

		cGrupo:= If(Empty(SF1->F1_APROV),cGrupo,SF1->F1_APROV)
		If !Empty(cGrupo)
			MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",0,,,cGrupo,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,1,SF1->F1_DOC+SF1->F1_SERIE)
			DbSelectArea("SF1")
			SF1->F1_STATUS := "B"
			SF1->F1_APROV  := cGrupo
		Else
			lBloqueio := .F.
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos da Nota Fiscal Eletronica³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc == "BRA"
		If Len(aNFEletr) > 0
			SF1->F1_NFELETR	:= aNFEletr[01]
			SF1->F1_CODNFE	:= aNFEletr[02]
			SF1->F1_EMINFE	:= aNFEletr[03]
			SF1->F1_HORNFE 	:= aNFEletr[04]
			SF1->F1_CREDNFE	:= aNFEletr[05]
			SF1->F1_NUMRPS	:= aNFEletr[06]
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SF1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	SF1->(FkCommit())	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para envio de email do messenger                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aDadosMail[1]:=SF1->F1_DOC
	aDadosMail[2]:=SF1->F1_SERIE
	aDadosMail[3]:=SF1->F1_FORNECE
	aDadosMail[4]:=SF1->F1_LOJA
	aDadosMail[5]:=If(cTipo$"DB",SA1->A1_NOME,SA2->A2_NOME)
	aDadosMail[6]:=If(lDeleta,5,If(l103Class,4,3))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao dos impostos calculados no cabecalho do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF4->(MaFisWrite(2,"SF1",Nil))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do array aDupl                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aColsSE2)
		aadd(aDupl,cSerie+"³"+cNFiscal+"³ "+aColsSE2[nX][nPParcela]+" ³"+DTOC(aColsSE2[nX][nPVencto])+"³ "+Transform(aColsSE2[nX][nPValor],PesqPict("SE2","E2_VALOR")))	
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao dos itens do documento de entrada                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aCols)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a regua de processamento                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !aCols[nx][Len(aHeader)+1]
			DbSelectArea("SD1")
			If nX <= Len(aRecSD1)
				MsGoto(aRecSD1[nx,1])
				RecLock("SD1",.F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna os acumulados da Pre-Nota                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaAvalSD1(2)
			Else
				RecLock("SD1",.T.)
			EndIf
			For nY := 1 To Len(aHeader)
				If aHeader[nY][10] # "V"
					SD1->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
				EndIf
			Next nY
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza os dados padroes e dados fiscais.                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atendimento ao DECRETO 5.052, DE 08/01/2004 para o municipio de ARARAS. ³
			//³Mais especificamente o paragrafo unico do Art 2.                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cB1FRETISS <> "2"
				cB1FRETISS	:=	SB1->B1_FRETISS
			EndIf
			SD1->D1_FILIAL := xFilial("SD1")
			SD1->D1_FORNECE:= cA100For
			SD1->D1_LOJA   := cLoja
			SD1->D1_DOC    := cNFiscal
			SD1->D1_SERIE  := cSerie
			SD1->D1_EMISSAO:= dDEmissao
			SD1->D1_DTDIGIT:= SF1->F1_DTDIGIT
			SD1->D1_TIPO   := cTipo
			SD1->D1_NUMSEQ := ProxNum()
			SD1->D1_FORMUL := IIF(cFormul=="S","S"," ")
			SD1->D1_ORIGLAN:= IIf(lConFrete,"FR",SD1->D1_ORIGLAN)
			SD1->D1_ORIGLAN:= IIf(lConImp,"DP",SD1->D1_ORIGLAN)
			SD1->D1_TIPODOC := SF1->F1_TIPODOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza as informacoes relativas aos impostos               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF4->(MaFisWrite(2,"SD1",nX))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Analisa se o documento deve ser bloqueado                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lBloqueio
				SD1->D1_TESACLA := SD1->D1_TES
				SD1->D1_TES := ""
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona registros                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SB1")
			DbSetOrder(1)
			MsSeek(xFilial("SB1")+SD1->D1_COD)

			DbSelectArea("SF4")
			DbSetOrder(1)
			MsSeek(xFilial("SF4")+SD1->D1_TES)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Retencao de ISS - Municipio de SBC/SP                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
			If SF4->F4_RETISS == "N"
				cMdRtISS := "2"		//Retencao por Base
			Else
				cMdRtISS := "1"		//Retencao Normal					
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao dos arquivos vinculados ao item do documento     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
			SD1->D1_TP     := SB1->B1_TIPO
			SD1->D1_GRUPO  := SB1->B1_GRUPO	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo do custo de entrada                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCustoEnt := SB1->(A103Custo(nX,aHeadSE2,aColsSE2))
			SD1->D1_CUSTO	:= aCustoEnt[1]
			SD1->D1_CUSTO2	:= aCustoEnt[2]
			SD1->D1_CUSTO3	:= aCustoEnt[3]
			SD1->D1_CUSTO4	:= aCustoEnt[4]
			SD1->D1_CUSTO5	:= aCustoEnt[5]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualizacao dos acumulados do SD1                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaAvalSD1(If(SF1->F1_STATUS=="A",4,1),"SD1",lAmarra,lDataUcom,lPrecoDes,lAtuAmarra,aRecSF1Ori,@aContratos,.F.)

			If SF1->F1_STATUS == "A" //Classificada sem bloqueio (NORMAL)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualizacao do rateio dos itens do documento de entrada                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCustoSDE := aClone(aCustoEnt)
				AFill(aCustoSDE,0)
				If (nY	:= aScan(aColsSDE,{|x| x[1] == SD1->D1_ITEM})) > 0
					For nZ := 1 To Len(aColsSDE[nY][2])
						If !aColsSDE[nY][2][nZ][nUsadoSDE+1]                              				
							SDE->(DbSetOrder(1))
							lAchou:=SDE->(MsSeek(xFilial("SDE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SD1->D1_ITEM+GdFieldGet("DE_ITEM",nz,NIL,aHeadSDE,ACLONE(aColsSDE[NY,2]))))
							RecLock("SDE",!lAchou)
							For nW := 1 To nUsadoSDE
								If aHeadSDE[nW][10] <> "V"
									SDE->(FieldPut(FieldPos(aHeadSDE[nW][2]),aColsSDE[nY][2][nZ][nW]))
								EndIf
							Next nW
							SDE->DE_FILIAL	:= xFilial("SDE")
							SDE->DE_DOC		:= SD1->D1_DOC
							SDE->DE_SERIE	:= SD1->D1_SERIE
							SDE->DE_FORNECE	:= SD1->D1_FORNECE
							SDE->DE_LOJA	:= SD1->D1_LOJA
							SDE->DE_ITEMNF	:= SD1->D1_ITEM
							For nW:= 1 To Len(aCustoEnt)
								SDE->(FieldPut(FieldPos("DE_CUSTO"+Alltrim(str(nW))),aCustoEnt[nW]*(SDE->DE_PERC/100)))
								aCustoSDE[nW] += SDE->(FieldGet(FieldPos("DE_CUSTO"+Alltrim(str(nW)))))
							Next nW
							If SF4->F4_DUPLIC=="S"
								nW := aScan(aSEZ,{|x| x[1] == SDE->DE_CC .And. x[2] == SDE->DE_ITEMCTA .And. x[3] == SDE->DE_CLVL })
								If nW == 0
									aadd(aSEZ,{SDE->DE_CC,SDE->DE_ITEMCTA,SDE->DE_CLVL,0,0})
									nW := Len(aSEZ)
								EndIf
								If nZ <> Len(aColsSDE[nY][2])
									aSEZ[nW][5] += SDE->DE_CUSTO1
								EndIf
							EndIf
						EndIf
						If nZ == Len(aColsSDE[nY][2])
							For nW := 1 To Len(aCustoEnt)
								SDE->(FieldPut(FieldPos("DE_CUSTO"+Alltrim(str(nW))),FieldGet(FieldPos("DE_CUSTO"+Alltrim(str(nW))))+aCustoEnt[nW]-aCustoSDE[nW]))
							Next nW
							nW := aScan(aSEZ,{|x| x[1] == SDE->DE_CC .And. x[2] == SDE->DE_ITEMCTA .And. x[3] == SDE->DE_CLVL })
							If nW <> 0
								aSEZ[nW][5] += SDE->DE_CUSTO1
							EndIf
						EndIf				

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Ponto de Entrada para o Template                                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (ExistTemplate("SDE100I"))
							ExecTemplate("SDE100I",.F.,.F.,{lConFrete,lConImp,nOper})
						EndIf
						If (ExistBlock("SDE100I"))
							ExecBlock("SDE100I",.F.,.F.,{lConFrete,lConImp,nOper})
						Endif

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Gera Lancamento contabil 641- Devolucao / Beneficiamento ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lCtbOnLine
							If cTipo $ "BD"
								If lVer641
									nTotalLcto	+= DetProva(nHdlPrv,"641","MATA103",cLote)
								EndIf
							Else
								If lVer651
									nTotalLcto	+= DetProva(nHdlPrv,"651","MATA103",cLote)
								EndIf
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Do Case
						Case cTipo == "B"
							PcoDetLan("000054","11","MATA103")
						Case cTipo == "D"
							PcoDetLan("000054","10","MATA103")
						OtherWise
							PcoDetLan("000054","09","MATA103")
						EndCase
					Next nZ
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento da gravacao do SDE na Integridade Referencial            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SDE->(FkCommit())			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a Gravacao do Ativo Imobilizado                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( SF4->F4_ATUATF=="S" )
					INCLUI := .T.
					ALTERA := .F.
					cBaseAtf := ""
					If ( SF4->F4_BENSATF == "1" .And. At(SF1->F1_TIPO,"CIP")==0 )
						If (SD1->D1_TIPO == "C") .Or. (SD1->D1_TIPO == "I")
							nQtdD1 := GetQOri(xFilial("SD1"),SD1->D1_NFORI,SD1->D1_SERIORI,SD1->D1_ITEMORI,;
								SD1->D1_COD,SD1->D1_FORNECE,SD1->D1_LOJA)
						Else
							nQtdD1 := Int(SD1->D1_QUANT)
						Endif

						For nV := 1 TO nQtdD1
							cItemAtf := StrZero(nV,Len(SN1->N1_ITEM))
							cCIAP	 := StrZero(Val(SD1->D1_CODCIAP)+(nV-1),TamSx3("D1_CODCIAP")[1])
							a103GrvAtf(1,@cBaseAtf,cItemAtf,cCIAP,SD1->D1_VALICM+SD1->D1_ICMSCOM)
						Next nV
					Else
						cItemAtf := StrZero(1,Len(SN1->N1_ITEM))
						a103GrvAtf(1,@cBaseAtf,cItemAtf,SD1->D1_CODCIAP,SD1->D1_VALICM+SD1->D1_ICMSCOM)
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Integracao TMS                                                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If IntTMS() .And. (Len(aRatVei)>0  .Or. Len(aRatFro)>0)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿			
					//³Verifica se o Item da NF foi rateado por Veiculo/Viagem ou por Frota    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			                                           		
					nItRat := aScan(aRatVei,{|x| x[1] == SD1->D1_ITEM})
					If nItRat > 0
						A103GrvSDG('SD1',aRatVei,"V",SD1->D1_ITEM,lCtbOnLine,nHdlPrv,@nTotalLcto,cLote,"MATA103")
					Else
						nItRat := aScan(aRatFro,{|x| x[1] == SD1->D1_ITEM})
						If nItRat > 0
							A103GrvSDG('SD1',aRatFro,"F",SD1->D1_ITEM,lCtbOnLine,nHdlPrv,@nTotalLcto,cLote,"MATA103")				
						EndIf
					EndIf	
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponto de entrada apos a gravacao do SD1 e todas atualizacoes.           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SuperGetMV("MV_NGMNTES") == "S"
					NGSD1100I()
				EndIf			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
				//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
				//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
				If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
					GSPF160()
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponto de Entrada para o Template                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (ExistTemplate("SD1100I"))
					ExecTemplate("SD1100I",.F.,.F.,{lConFrete,lConImp,nOper})
				EndIf
				If (ExistBlock("SD1100I"))
					ExecBlock("SD1100I",.F.,.F.,{lConFrete,lConImp,nOper})
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Contabilizacao do item do documento de entrada                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCtbOnline
					If cTipo $ "BD" .And. lVer640
						nTotalLcto	+= DetProva(nHdlPrv,"640","MATA103",cLote)
					Else
						If lVer650
							nTotalLcto	+= DetProva(nHdlPrv,"650","MATA103",cLote)
						EndIf
					EndIf
				EndIf			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Do Case
				Case cTipo == "B"
					PcoDetLan("000054","07","MATA103")
				Case cTipo == "D"
					PcoDetLan("000054","05","MATA103")
				OtherWise
					PcoDetLan("000054","01","MATA103")
				EndCase
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Dados para envio de email do messenger                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			AADD(aDetalheMail,{SD1->D1_ITEM,SD1->D1_COD,SD1->D1_QUANT,SD1->D1_TOTAL})			
		Else
			If  nX <= Len(aRecSD1)
				MsGoto(aRecSD1[nx,1])
				RecLock("SD1",.F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna os acumulados da Pre-Nota                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaAvalSD1(2)
				SD1->(dbDelete())
				SD1->(MsUnLock())
			EndIf
		EndIf
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os acumulados do Cabecalho do documento         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaAvalSF1(4)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera os titulos no Contas a Pagar SE2                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF1->F1_STATUS == "A" //Classificada sem bloqueio
		If !(cTipo$"DB")
			If SF1->(FieldPos("F1_NUMRA"))==0 .Or. Empty(SF1->F1_NUMRA)
				A103AtuSE2(1,aRecSE2,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,cFornIss,cLojaIss,cDirf,cCodRet,cModRetPIS,nIndexSE2,aSEZ,dVencIss,cMdRtISS,SF1->F1_TXMOEDA,lTxNeg,aRecGerSE2,cA2FRETISS,cB1FRETISS,aMultas,lRatLiq,lRatImp,aCodR,cRecIss)
			Else
				A103AtuSRK(1,aHeadSE2,aColsSE2)
			EndIf
		EndIf		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera titulo de NCC ao cliente                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipo == "D" .And. MaFisRet(,"NF_BASEDUP") > 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera a taxa informada para geracao da NCC           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If GetMV( "MV_TXMOENC" ) == "2"
				nTaxaNCC := MaFisRet(,"NF_TXMOEDA")
			Else
				nTaxaNCC := 0 	
			EndIf		

			Aadd(aRecNCC,ADupCred(xmoeda(MaFisRet(,"NF_BASEDUP"),1,nMoedaCor,NIL,NIL,NIL,nTaxaNCC),"001",nMoedaCor,MaFisRet(,"NF_NATUREZA"),nTaxaNCC,aColsSE2[1][2]))
			If lCompensa  //Compensacao automatica do titulo
				DbSelectArea("SE1")
				DbSetOrder(2)
				#IFDEF TOP
					lQuery    := .T.
					aStruSE1  := SE1->(dbStruct())
					cAliasSE1 := "A103DEV"
					cQuery    := "SELECT SE1.*,SE1.R_E_C_N_O_ SE1RECNO "
					cQuery    += "FROM "+RetSqlName("SE1")+" SE1 "
					cQuery    += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
					cQuery    += "SE1.E1_CLIENTE='"+SF1->F1_FORNECE+"' AND "
					cQuery    += "SE1.E1_LOJA='"+SF1->F1_LOJA+"' AND "
					cQuery    += "SE1.E1_PREFIXO='"+SD1->D1_SERIORI+"' AND "
					cQuery    += "SE1.E1_NUM='"+SD1->D1_NFORI+"' AND "
					cQuery    += "SE1.E1_TIPO='NF ' AND "
					cQuery    += "SE1.D_E_L_E_T_=' ' "
					cQuery    += "ORDER BY "+SqlOrder(SE1->(IndexKey()))

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
					For nX := 1 To Len(aStruSE1)
						If aStruSE1[nX][2]<>"C"
							TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
						EndIf
					Next nX
				#ELSE
					MsSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SD1->D1_SERIORI+SD1->D1_NFORI)
				#ENDIF
				While !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
						SF1->F1_FORNECE == (cAliasSE1)->E1_CLIENTE .And.;
						SF1->F1_LOJA == (cAliasSE1)->E1_LOJA .And.;
						SD1->D1_SERIORI == (cAliasSE1)->E1_PREFIXO .And.;
						SD1->D1_NFORI == (cAliasSE1)->E1_NUM
					If (cAliasSE1)->E1_TIPO == "NF " .And. (cAliasSE1)->E1_SITUACA == "0"
						If !SuperGetMv("MV_CHECKNF",.F.,.F.)
							aadd(aRecSE1,If(lQuery,(cAliasSE1)->SE1RECNO,(cAliasSE1)->(RecNo())))
							nTotalDev += (cAliasSE1)->E1_VALOR
						Endif
					Endif
					DbSelectArea(cAliasSE1)
					dbSkip()
				EndDo

				//Compensacao automatica do titulo, somente para devolucao total
				If Round(MaFisRet(,"NF_BASEDUP"),2) == Round(nTotalDev,2)
					MaIntBxCR(3,aRecSe1,,aRecNcc,,{lCtbOnLine,.F.,.F.,.F.,.F.,.F.})
				EndIf
				If lQuery
					DbSelectArea(cAliasSE1)
					dbCloseArea()
					DbSelectArea("SE1")
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna os valores da Comissao.              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( SuperGetMV("MV_TPCOMIS")=="O" )
				Fa440CalcE("MATA100")
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
		//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF01I()
		EndIf

		If cFormul == "S" .And. cTipoNf == "2"
			While ( __lSX8 )
				ConfirmSX8()
			EndDo
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pontos de Entrada 										   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (ExistTemplate("SF1100I"))
			ExecTemplate("SF1100I",.f.,.f.)
		EndIf
		If (ExistBlock("SF1100I"))
			ExecBlock("SF1100I",.f.,.f.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava Pedido de Venda qdo solicitado pelo campo D1_GERAPV  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		a103GrvPV(1,aPedPV)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o arquivo de Livros  (SF3)                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaFisAtuSF3(1,"E",0,"SF1")
		If nRecSf1 == 0
			nRecSF1	:= SF1->(RecNo())
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabilizacao do documento de entrada                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCtbOnLine
			If lVer660 .And. !(cTipo $"DB")
				DbSelectArea("SF1")
				MsGoto(nRecSF1)
				nTotalLcto	+= DetProva(nHdlPrv,"660","MATA103",cLote)
			EndIf
			If lVer642 .And. cTipo $"DB"
				DbSelectArea("SF1")
				MsGoto(nRecSF1)
				nTotalLcto	+= DetProva(nHdlPrv,"642","MATA103",cLote)
			EndIf
			If lVer950 .And. !Empty(SD1->D1_TEC)
				nTotalLcto +=DetProva(nHdlPrv,"950","MATA103",cLote)
			Endif
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
		Case SF1->F1_TIPO == "B"
			PcoDetLan("000054","20","MATA103")
		Case cTipo == "D"
			PcoDetLan("000054","19","MATA103")
		OtherWise
			PcoDetLan("000054","03","MATA103")
		EndCase

		If lUsaGCT 			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava as multas no historico do contrato                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			A103HistMul( 1, aMultas, cNFiscal, cSerie, cA100For, cLoja )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza os movimentos de caucao do contratos - SIGAGCT  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			A103AtuCauc( 1, aContratos, aRecGerSE2, cA100For, cLoja, cNFiscal, cSerie, dDEmissao, SF1->F1_VALBRUT )
		EndIf

	EndIf
	//-- Integrado ao wms devera avaliar as regras para convocacao do servico e disponibilizar os 
	//-- registros do SDB para convocacao
	If	IntDL() .And. !Empty(aLibSDB)
		WmsExeDCF('2')
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada dos execblocks no termino do documento de entrada              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If (ExistTemplate("GQREENTR"))
		ExecTemplate("GQREENTR",.F.,.F.)
	EndIf
	If (ExistBlock("GQREENTR"))
		ExecBlock("GQREENTR",.F.,.F.)
	EndIf
Else

	If lUsaGCT

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem os contratos desta NF - SIGAGCT                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A103GetContr( aRecSD1, @aContratos )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os movimentos de caucao do contratos - SIGAGCT  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A103AtuCauc( 2, aContratos, aRecSE2, cA100For, cLoja, cNFiscal, cSerie )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga as multas do historico do contrato                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A103HistMul( 2, NIL, cNFiscal, cSerie, cA100For, cLoja )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
	Case SF1->F1_TIPO == "B"
		PcoDetLan("000054","20","MATA103",.T.)
	Case cTipo == "D"
		PcoDetLan("000054","19","MATA103",.T.)
	OtherWise
		PcoDetLan("000054","03","MATA103",.T.)
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera Lancamento contabil 665- Exclusao - Total       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lVer665.And.!Empty(SF1->F1_DTLANC)
		nTotalLcto	+= DetProva(nHdlPrv,"665","MATA103",cLote)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o pedido de vendas quando gerado pelo D1_GERAPV      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	a103GrvPV(2,,aRecSC5)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o arquivo de Livros Fiscais (SF3)                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAtuSF3(2,"E",SF1->(RecNo()))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera os titulos no Contas a Pagar SE2                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SF1->F1_TIPO$"DB")
		If SF1->(FieldPos("F1_NUMRA"))==0 .Or. Empty(SF1->F1_NUMRA)
			A103AtuSE2(2,aRecSE2)
		Else
			A103AtuSRK(2)
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os acumulados do Cabecalho do documento         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaAvalSF1(5)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorna os titulos de NCC ao cliente                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A103EstNCC()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclusao do rateio dos itens do documento de entrada                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aRecSDE)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona registro na tabela SDE                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SDE")
		SDE->(MsGoto(aRecSDE[nX]))	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona registro na tabela SD1                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRecSD1SDE := ASCAN(aRecSD1,{|x| x[2] == SDE->DE_ITEMNF})
		If nRecSD1SDE > 0
			SD1->(MsGoto(aRecSD1[nRecSD1SDE,1]))
		EndIf
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek(xFilial("SF4")+SD1->D1_TES)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1")+SD1->D1_COD)		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
		Case cTipo == "B"
			PcoDetLan("000054","11","MATA103",.T.)
		Case cTipo == "D"
			PcoDetLan("000054","10","MATA103",.T.)
		OtherWise
			PcoDetLan("000054","09","MATA103",.T.)
		EndCase
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera Lancamento contabil 656- Exclusao - Itens de Rateio ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lVer656.And.!Empty(SF1->F1_DTLANC)
			nTotalLcto	+= DetProva(nHdlPrv,"656","MATA103",cLote)
		EndIf
		If !lEstNfClass	.Or. (lEstNfClass .And. cDelSDE == "1")
			RecLock("SDE")
			dbDelete()
			MsUnLock()
		EndIf
	Next nX	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SDE na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SDE->(FkCommit())

	For nX := 1 to Len(aRecSD1)
		DbSelectArea("SD1")
		MsGoto(aRecSD1[nx,1])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera Lancamento contabil 955- Exclusao - Total EIC   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nX == 1 .And. lVer955 .And.!Empty(SD1->D1_TEC) .And. !Empty(SF1->F1_DTLANC)
			nTotalLcto +=DetProva(nHdlPrv,"955","MATA103",cLote)
		Endif
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek(xFilial("SF4")+SD1->D1_TES)

		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1")+SD1->D1_COD)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua o Estorno do Ativo Imobilizado                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( SF4->F4_BENSATF == "1" )
			For nV := 1 TO Int(SD1->D1_QUANT)
				a103GrvAtf(2,Trim(SD1->D1_CBASEAF),,,,@aCIAP)
			Next nV
		Else
			a103GrvAtf(2,Trim(SD1->D1_CBASEAF),,,,@aCIAP)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
		Case SD1->D1_TIPO == "B"
			PcoDetLan("000054","07","MATA103",.T.)
		Case SD1->D1_TIPO == "D"
			PcoDetLan("000054","05","MATA103",.T.)
		OtherWise
			PcoDetLan("000054","01","MATA103",.T.)
		EndCase
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera Lancamento contabil 655- Exclusao - Itens       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lVer655.And.!Empty(SF1->F1_DTLANC)
			nTotalLcto	+= DetProva(nHdlPrv,"655","MATA103",cLote)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna o Servico do WMS (DCF)                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A103EstDCF()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorna o Movimento de Custo de Transporte - Integracao TMS             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IntTMS()  .And. (Len(aRatVei)>0 .Or. Len(aRatFro)>0)
			EstornaSDG("SD1",SD1->D1_NUMSEQ,lCtbOnLine,nHdlPrv,@nTotalLcto,cLote,"MATA103")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualizacao dos acumulados do SD1                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaAvalSD1(If(SF1->F1_STATUS=="A",5,2),"SD1",lAmarra,lDataUcom,lPrecoDes, NIL, NIL, @aContratos,MV_PAR15==2,@aCIAP,lEstNfClass)
		MaAvalSD1(If(SF1->F1_STATUS=="A",6,3),"SD1",lAmarra,lDataUcom,lPrecoDes, , ,,MV_PAR15==2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui o item da NF SD1                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SuperGetMV("MV_NGMNTES") == "S"
			NGSD1100E()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
		//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF170()
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Pontos de Entrada 											 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If (ExistTemplate("SD1100E"))
			ExecTemplate("SD1100E",.F.,.F.,{lConFrete,lConImp})
		Endif
		If (ExistBlock("SD1100E"))
			ExecBlock("SD1100E",.F.,.F.,{lConFrete,lConImp})
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados para envio de email do messenger                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		AADD(aDetalheMail,{SD1->D1_ITEM,SD1->D1_COD,SD1->D1_QUANT,SD1->D1_TOTAL})			

		If !lEstNfClass //-- Se nao for estorno de Nota Fiscal Classificada (MATA140)
			RecLock("SD1",.F.,.T.)
			dbDelete()
			MsUnlock()
		Else
			RecLock("SD1",.F.,.T.)		
			SD1->D1_TESACLA := CriaVar('D1_TESACLA',.F.)			
			SD1->D1_TES     := CriaVar('D1_TES',.F.)			
			If lEstNFClass
				If cDelSDE == "1"
					SD1->D1_RATEIO := "2"		// volta para "Nao (2) para permitir a reclassificacao
				EndIf
			Else
				SD1->D1_RATEIO := "2"		// volta para "Nao (2) para permitir a reclassificacao			
			EndIf
			If lEstNfClass .AND. SD1->D1_LOCAL == cLocCQ   // Caso seja um estorno e o armazem seja 98 devo limpa-lo
				SD1->D1_LOCAL := ""
			EndIf			
			MsUnLock()
			If cPaisLoc=="BRA"
				MaAvalSD1(1,"SD1")
			ElseIf cPaisLoc == "ARG"
				If SD1->D1_TIPO_NF == "5"	//Factura Fob
					MaAvalSD1(1,"SD1")
				EndIf
			ElseIf cPaisLoc == "CHI"		
				If SD1->D1_TIPO_NF == "9"	//Factura Aduana
					MaAvalSD1(1,"SD1")
				EndIf			
			Endif			
		EndIf	

	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SD1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SD1->(FkCommit())

	DbSelectArea("SF1")
	MsGoto(nRecSF1)
	RecLock("SF1",.F.,.T.)
	nOper := 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
	//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
	//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
	If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
		GSPF01E()
	EndIf
	If !Empty(SF1->F1_APROV)
		MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",SF1->F1_VALBRUT,,,SF1->F1_APROV,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3,SF1->F1_DOC+SF1->F1_SERIE)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Template acionando ponto de entrada           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistTemplate("SF1100E")
		ExecTemplate("SF1100E",.F.,.F.)
	EndIf
	If (ExistBlock("SF1100E"))
		ExecBlock("SF1100E",.F.,.F.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para envio de email do messenger                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aDadosMail[1]:=SF1->F1_DOC
	aDadosMail[2]:=SF1->F1_SERIE
	aDadosMail[3]:=SF1->F1_FORNECE
	aDadosMail[4]:=SF1->F1_LOJA
	aDadosMail[5]:=If(cTipo$"DB",SA1->A1_NOME,SA2->A2_NOME)
	aDadosMail[6]:=If(lDeleta,5,If(l103Class,4,3))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui a amarracao com os conhecimentos                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsDocument( "SF1", SF1->( RecNo() ), 2, , 3 )

	If !lEstNfClass //-- Se nao for estorno de Nota Fiscal Classificada (MATA140)
		MaAvalSF1(6)
		RecLock("SF1")
		dbDelete()
		MsUnlock()
	Else
		RecLock("SF1",.F.,.T.)		
		SF1->F1_STATUS := CriaVar('F1_STATUS',.F.)
		SF1->F1_DTLANC := Ctod("")
		MsUnLock()
	EndIf		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SF1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF1->(FkCommit())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de e-mails para o evento 030       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MEnviaMail("030",{aDadosMail[1],aDadosMail[2],aDadosMail[3],aDadosMail[4],aDadosMail[5],aDadosMail[6],aDetalheMail})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao dos dados contabeis                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtbOnLine .And. nTotalLcto > 0
	RodaProva(nHdlPrv,nTotalLcto)
	If cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglutina)
		If !SF1->(Deleted()) .And. !lEstNfClass
			RecLock("SF1",.F.)
			SF1->F1_DTLANC := dDataBase
			MsUnLock()
		EndIf
	EndIf
EndIf
//Ponto de Entrada Utilizado na integracao com o QIE
If lImpRel
	ExecBlock("QIEIMPRL",.F.,.F.,{nOper})
Endif
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103AtuSE2³ Autor ³ Edson Maricate        ³ Data ³11.10.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de integracao com o modulo financeiro                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Codigo de operacao                                    ³±±
±±³          ³       [1] Inclusao de Titulos                               ³±±
±±³          ³       [2] Exclusao de Titulos                               ³±±
±±³          ³ExpA2: Array com os recnos dos titulos financeiros. Utilizado³±±
±±³          ³       somente na exclusao                                   ³±±
±±³          ³ExpA3: AHeader dos titulos financeiros                       ³±±
±±³          ³ExpA4: ACols dos titulos financeiro                          ³±±
±±³          ³ExpA5: AHeader das multiplas naturezas                       ³±±
±±³          ³ExpA2: ACols das multiplas naturezas                         ³±±
±±³          ³ExpC6: Fornecedor dos ISS                                    ³±±
±±³          ³ExpC7: Loja do ISS                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a integracao entre o   ³±±
±±³          ³documento de entrada e os titulos financeiros.               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function A103AtuSE2(nOpcA,aRecSE2,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,cFornIss,cLojaIss,cDirf,cCodRet,cModRetPIS,nIndexSE2,aSEZ,dVencIss,cMdRtISS,nTaxa,lTxNeg,aRecGerSE2,cA2FRETISS,cB1FRETISS,aMultas,lRatLiq,lRatImp,aCodR,cRecIss)

Local aArea     := GetArea()
Local aRetIrrf  := {}
Local aProp     := {}
Local aCtbRet   := {0,0,0}
Local cPrefixo  := SF1->F1_PREFIXO
Local cNatureza	:= MaFisRet(,"NF_NATUREZA")
Local cPrefOri  := ""
Local cNumOri   := ""
Local cParcOri  := ""
Local cTipoOri  := ""
Local cCfOri    := ""
Local cLojaOri  := ""
Local lMulta    := .F.
Local nPParcela := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_PARCELA"})
Local nPVencto  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VENCTO"})
Local nPValor   := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VALOR"})
Local nPIRRF    := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_IRRF"})
Local nPISS     := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_ISS"})
Local nPINSS    := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_INSS"})
Local nPPIS     := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_PIS"})
Local nPCOFINS  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_COFINS"})
Local nPCSLL    := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_CSLL"})
Local nPSEST    := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_SEST"})
Local nPFETHAB  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_FETHAB"})
Local nSEST		:= 0
Local nBaseDup  := 0
Local nVlCruz   := MaFisRet(,"NF_BASEDUP")
Local nLoop     := 0
Local nX        := 0
Local nY        := 0
Local nZ        := 0
Local nRateio   := 0
Local nRateioSEZ:= 0
Local nMaxFor   := IIF(aColsSE2==Nil,0,Len(aColsSE2))
Local nRetOriPIS := 0
Local nRetOriCOF := 0
Local nRetOriCSLL:= 0
Local nValor    := 0
Local nValTot   := 0
Local nBasePis  := MaFisRet(,"NF_BASEPIS")
Local nBaseCof  := MaFisRet(,"NF_BASECOF")
Local nBaseCsl  := MaFisRet(,"NF_BASECSL")
Local nSaldoPis := nBasePis
Local nSaldoCof := nBaseCof
Local nSaldoCsl := nBaseCsl
Local nSaldoProp:= 0
Local nProp     := 0
Local nVlRetPIS := 0
Local nVlRetCOF := 0
Local nVlRetCSLL:= 0
Local nSaldoMult:= 0
Local nSaldoBoni:= 0
Local nBaixaMult:= 0
Local lVisDirf  := SuperGetMv("MV_VISDIRF",.F.,"2") == "1"
Local nValMinRet:= GetNewPar( "MV_VL10925", 0 )
Local lRestValImp	:= .F. 				
Local lRetParc		:= .T.
Local cAplVlMn		:= "1"
// Modo de retencao do ISS: 1 = Pela Emissao, 2 = Pela Baixa
Local cMRetISS		:= GetNewPar("MV_MRETISS","1")
Local nValFet   	:= MaFisRet(,"NF_VALFET")
Local cForMinISS 	:= GetNewPar("MV_FMINISS","1")
Local lMT103ISS := ExistBlock("MT103ISS")
Local aMT103ISS:= {}
Local nInss := 0
Local aDadosImp	:= Array(3)
Local nVlRetIR 		:= SuperGetMV("MV_VLRETIR")
Local lPCCBaixa		:= SuperGetMv("MV_BX10925") == "1"

//Verifica se existe controle de retencao de contrato - SIGAGCT
Local lGCTRet     := (GetNewPar( "MV_CNRETNF", "N" ) == "S") .And. (SE2->(FieldPos("E2_RETCNTR")) > 0)
Local nGCTRet     := 0
Local lGCTDesc    := (SE2->(FieldPos("E2_MDDESC")) > 0)
Local nGCTDesc    := 0
Local lGCTMult    := (SE2->(FieldPos("E2_MDMULT")) > 0)
Local nGCTMult    := 0
Local lGCTBoni    := (SE2->(FieldPos("E2_MDBONI")) > 0)
Local nGCTBoni    := 0
Local aContra     := {}

DEFAULT cModRetPIS	:= "1"
DEFAULT cMdRtISS	:= "1"
DEFAULT nTaxa		:= 0
DEFAULT lTxNeg	    := .F.
DEFAULT cA2FRETISS	:=	""
DEFAULT cB1FRETISS	:=	""
DEFAULT aMultas     := {}
DEFAULT lRatLiq    := .T.
DEFAULT lRatImp    := .F.
DEFAULT aCodR      := {}
DEFAULT cRecIss	:=	"1"

PRIVATE nValFun		:= MaFisRet(,"NF_FUNRURAL")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica se o tratamento de valor minimo para retencao (R$ 5.000,00) deve ser aplicado:³
//³Controle pela variavel cAplVlMn, onde :                                              ³
//³1 = Aplica o valor minimo                                                            ³
//³2 = Nao aplica o valor minimo                                                        ³
//³Quando o tratamento da retencao for pela emissao, sera forcada a retencao em cada    ³
//³aquisicao. Quando o tratamento da retencao for pela baixa, o financeiro ira usar o   ³
//³campo E2_APLVLMN para identificar se utilizara ou nao o valor minimo para retencao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_PIS252") > 0 .Or. MaFisRet(,"NF_COF252") > 0
	If cModRetPis <> "3"
		// Forca a retencao sempre - Apenas para retencao na emissao do titulo
		cModRetPis := "2"
	Endif
	cAplVlMn := "2"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a Taxa da Moeda nao foi negociada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lTxNeg
	nTaxa := 0
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o prefixo do titulo a ser gerado                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cPrefixo)
	cPrefixo := &(SuperGetMV("MV_2DUPREF"))
	cPrefixo += Space(Len(SE2->E2_PREFIXO) - Len(cPrefixo))
EndIf
If nOpcA == 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o total de multas e / ou bonificacoes de contrato         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AEval( aMultas, { |x| If( x[5] == "1", nSaldoMult += x[3], nSaldoBoni += x[3] ) } )

	lMulta := ( nSaldoMult > nSaldoBoni )

	If lMulta
		nSaldoMult := nSaldoMult - nSaldoBoni
	Else 			
		nSaldoBoni := nSaldoBoni - nSaldoMult 			
	EndIf 		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula valor da retencao,desconto e multa de contrato            ³
	//³ pelo total de parcelas                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	If lGCTRet .Or. lGCTDesc .Or. lGCTMult .Or. lGCTBoni
	   CntProcGct(lGCTRet,lGCTDesc,lGCTMult,lGCTBoni,@nGCTRet,@nGCTDesc,@nGCTMult,@nGCTBoni,aContra)
	   nGCTRet  := nGCTRet/nMaxFor
	   nGCTDesc := nGCTDesc/nMaxFor
	   nGCTMult := nGCTMult/nMaxFor
	   nGCTBoni := nGCTBoni/nMaxFor
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona registros                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SED")
	DbSetOrder(1)
	MsSeek(xFilial("SED")+cNatureza)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o valor total das duplicatas                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	For nX := 1 To nMaxFor
		nBaseDup += aColsSE2[nX][nPValor]
	Next nX
	nBaseDup -= nValFun
	nBaseDup -= nValFet	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula os percentuais de raeio do SEZ                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRateioSEZ := 0
	For nZ := 1 To Len(aSEZ)
		nRateioSEZ += aSEZ[nZ][5]
	Next nZ
	For nZ := 1 To Len(aSEZ)
		aSEZ[nZ][4] := NoRound(aSEZ[nZ][5]/nRateioSEZ,TamSX3("EZ_PERC")[2])
	Next nZ
	nRateioSEZ := 0
	For nZ := 1 To Len(aSEZ)
		nRateioSEZ += aSEZ[nZ][4]
		If nZ == Len(aSEZ)
			aSEZ[nZ][4] += 1-nRateioSEZ
		EndIf
	Next nZ	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a gravacao dos titulos financeiros a pagar                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

	nValPis := 0
	nValCof := 0
	nValCsl := 0

	For nX := 1 to nMaxFor
		nValTot += aColsSE2[nX][nPValor]
	Next

	aProp := {}

	nSaldoProp := 1

	For nX := 1 to nMaxFor
		If nX == nMaxFor
			nProp := nSaldoProp
		Else 			
			nProp := Round(aColsSE2[nX][nPValor] / nValTot,6)
			nSaldoProp -= nProp
		EndIf	
		AAdd( aProp, nProp )
	Next nX

	For nX := 1 To nMaxFor
		If aColsSE2[nX][nPValor] > 0
			RecLock("SE2",.T.)
			If cForMinISS == "1"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atendimento ao DECRETO 5.052, DE 08/01/2004 para o municipio de ARARAS. ³
				//³Mais especificamente o paragrafo unico do Art 2.                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ("2"$cA2FRETISS) .And. ("2"$cB1FRETISS)
					SE2->E2_FRETISS	:=	"2"
				Else
					SE2->E2_FRETISS	:=	"1"
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atendimento a Lei 3.968 de 23/12/2003 - Americana / SP                                      ³
				//³para alguns produtos, a retencao deve ocorrer apenas para valores maiores que R$ 3.000,00   ³
				//³como um mesmo fornecedor pode prestar mais de um tipo de servico (com minimo e sem minimo   ³					
				//³de retencao, a configuracao e diferenciada. O default sera reter sempre.                    ³					
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ("1"$cA2FRETISS) .And. ("1"$cB1FRETISS)
					SE2->E2_FRETISS	:=	"1"
				Else
					SE2->E2_FRETISS	:=	"2"
				EndIf
			Endif

			SE2->E2_FILIAL  := xFilial("SE2")
			SE2->E2_PREFIXO := cPrefixo
			SE2->E2_NUM     := cNFiscal
			SE2->E2_TIPO    := MVNOTAFIS
			SE2->E2_NATUREZ := cNatureza
			SE2->E2_EMISSAO := dDEmissao
			SE2->E2_EMIS1   := SF1->F1_DTDIGIT
			SE2->E2_FORNECE := SA2->A2_COD
			SE2->E2_LOJA    := SA2->A2_LOJA
			SE2->E2_NOMFOR  := SA2->A2_NREDUZ
			SE2->E2_MOEDA   := nMoedaCor
			SE2->E2_TXMOEDA := nTaxa
			SE2->E2_LA      := "S"
			SE2->E2_PARCELA := aColsSE2[nX][nPParcela]
			SE2->E2_VENCORI := aColsSE2[nX][nPVencto]
			SE2->E2_VENCTO  := aColsSE2[nX][nPVencto]
			SE2->E2_VENCREA := DataValida(aColsSE2[nX][nPVencto],.T.)
			SE2->E2_NATUREZ := cNatureza

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Modo de Retencao de ISS - Municipio de Sao Bernardo do Campo                         ³
			//³1 = Retencao Normal                                                                  ³
			//³2 = Retencao por Base                                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SE2->E2_MDRTISS := cMdRtISS

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Implementacao do SEST/SENAT                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nPSEST > 0 .And. SED->ED_CALCSES == "S"
				nSEST := SE2->E2_SEST := aColsSE2[nX][nPSEST]
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Indica se o tratamento de valor minimo para retencao (R$ 5.000,00) deve ser aplicado:³
			//³1 = Aplica o valor minimo                                                            ³
			//³2 = Nao aplica o valor minimo                                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SE2->E2_APLVLMN := cAplVlMn

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava a filial de origem quando existir o campo no SE2            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SE2->E2_FILORIG := CriaVar("E2_FILORIG",.T.)	

			lRetParc := .T. 							

			If aScan( aCodR, {|aX|aX[4]=="IRR"})>0
				cDirf	:=	AllTrim( Str( aCodR[aScan( aCodR, {|aX|aX[4]=="IRR"})][3] ) )
				cCodRet	:=	aCodR[aScan( aCodR, {|aX|aX[4]=="IRR"})][2]
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica os impostos dos titulos financeiros                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc == "BRA"
				SE2->E2_IRRF    := aColsSE2[nX][nPIRRF]

				If SE2->E2_IRRF >= nVlRetIR
					SF1->F1_VALIRF := SE2->E2_IRRF
				Endif

				If SubStr( cRecIss,1,1 )<>"1"
					SE2->E2_ISS     := aColsSE2[nX][nPISS]
					If cFornIss <> Nil .And. cLojaIss <> Nil .And. aColsSE2[nX][nPISS] > 0

						If lMT103ISS
							aMT103ISS	:=	ExecBlock( "MT103ISS" , .F. , .F. , { cFornIss , cLojaIss , cDirf , cCodRet , dVencIss })
							If Len( aMT103ISS )==5
								cFornIss	:=	aMT103ISS[1]
								cLojaIss	:=	aMT103ISS[2]
								cDirf		:=	aMT103ISS[3]
								cCodRet		:=	aMT103ISS[4]
								dVencIss	:=	aMT103ISS[5]
							EndIf
						EndIf

						SE2->E2_FORNISS := cFornIss
						SE2->E2_LOJAISS := cLojaIss

						If dVencIss <> Nil 							
							SE2->E2_VENCISS := dVencIss
						EndIf
					Endif	
				EndIf

				If lVisDirf
					SE2->E2_DIRF   := cDirf
					SE2->E2_CODRET := cCodRet
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Gravacao dos codigos de receita conforme selecionado na aba impostos³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aScan( aCodR, {|aX|aX[4]=="PIS"})>0
					SE2->E2_CODRPIS  := aCodR[aScan( aCodR, {|aX|aX[4]=="PIS"})][2]
				EndIf
				If aScan( aCodR, {|aX|aX[4]=="COF"})>0
					SE2->E2_CODRCOF  := aCodR[aScan( aCodR, {|aX|aX[4]=="COF"})][2]
				EndIf
				If aScan( aCodR, {|aX|aX[4]=="CSL"})>0
					SE2->E2_CODRCSL  := aCodR[aScan( aCodR, {|aX|aX[4]=="CSL"})][2]
				EndIf

				SE2->E2_INSS    := aColsSE2[nX][nPINSS]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para calculo do IRRF                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (ExistBlock("MT100IR"))
					aRetIrrf := ExecBlock( "MT100IR",.F.,.F., {SE2->E2_IRRF,aColsSE2[nX][nPValor],nX} )
					Do Case
					Case ValType(aRetIrrf)  == "N"
						SE2->E2_IRRF := aRetIrrf
						If SE2->E2_IRRF >= nVlRetIR
							SF1->F1_VALIRF := SE2->E2_IRRF
						Endif
					Case ValType(aRetIrrf)  == "A"
						SE2->E2_IRRF := aRetIrrf[1]
						SE2->E2_ISS  := aRetIrrf[2]
						If SE2->E2_IRRF >= nVlRetIR
							SF1->F1_VALIRF := SE2->E2_IRRF
						Endif
					EndCase
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para calculo do INSS                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE2->E2_INSS > 0
					If ExistBlock("MT100INS")
						SE2->E2_INSS := ExecBlock( "MT100INS",.F.,.F.,{SE2->E2_INSS})
					EndIf
				EndIf

				nInss := Iif( SED->ED_DEDINSS=="2",0,SE2->E2_INSS )

				If nPPIS > 0
					SE2->E2_PIS     := aColsSE2[nX][nPPIS]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para calculo do PIS                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("MT100PIS")
						SE2->E2_PIS := ExecBlock( "MT100PIS",.F.,.F.,{SE2->E2_PIS})
					EndIf					

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Proporcionalizacao da base do PIS pela duplicata                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nX == nMaxFor
						SE2->E2_BASEPIS := nSaldoPis						
					Else
						SE2->E2_BASEPIS := nBasePis * aProp[nX]
						nSaldoPis -= SE2->E2_BASEPIS					
					Endif	

				EndIf

				IF nPCOFINS > 0
					SE2->E2_COFINS  := aColsSE2[nX][nPCOFINS]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para calculo do COFINS                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("MT100COF")
						SE2->E2_COFINS := ExecBlock( "MT100COF",.F.,.F.,{SE2->E2_COFINS})
					EndIf										

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Proporcionalizacao da base do COFINS pela duplicata               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nX == nMaxFor
						SE2->E2_BASECOF := nSaldoCof
					Else
						SE2->E2_BASECOF := nBaseCof * aProp[nX]
						nSaldoCof -= SE2->E2_BASECOF
					Endif	
				EndIf

				If nPCSll > 0
					SE2->E2_CSLL    := aColsSE2[nX][nPCSLL]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para calculo do CSLL                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("MT100CSL")
						SE2->E2_CSLL := ExecBlock( "MT100CSL",.F.,.F.,{SE2->E2_CSLL})
					EndIf					


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Proporcionalizacao da base do CSLL pela duplicata                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nX == nMaxFor
						SE2->E2_BASECSL := nSaldoCsl
					Else
						SE2->E2_BASECSL := nBaseCsl * aProp[nX]
						nSaldoCsl -= SE2->E2_BASECSL
					Endif	

				EndIf

				If nPFETHAB > 0
					SE2->E2_FETHAB := aColsSE2[nX][nPFETHAB]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para calculo do FETHAB                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("MT100FET")
						SE2->E2_FETHAB := ExecBlock( "MT100FET",.F.,.F.,{SE2->E2_FETHAB})
					EndIf					
				EndIf

				// Somente deduz o valor do ISS no titulo principal se a forma de retencao do ISS for pela baixa
				If cMRetISS == "1"
					SE2->E2_VALOR   := aColsSE2[nX][nPValor]-nValFun-SE2->E2_IRRF-SE2->E2_ISS-nInss-nSEST
					SE2->E2_SALDO   := aColsSE2[nX][nPValor]-nValFun-SE2->E2_IRRF-SE2->E2_ISS-nInss-nSEST
				Else
					SE2->E2_VALOR   := aColsSE2[nX][nPValor]-nValFun-SE2->E2_IRRF-nInss-nSEST
					SE2->E2_SALDO   := aColsSE2[nX][nPValor]-nValFun-SE2->E2_IRRF-nInss-nSEST
				Endif

				// Grava a forma de retencao do ISS (1=Emissao / 2=Baixa)
				If SE2->E2_ISS > 0
					SE2->E2_TRETISS := cMRetISS
				Endif

				lRestValImp := .F.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava a Marca de "pendente recolhimento" dos demais registros    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				If ( !Empty( SE2->E2_PIS ) .Or. !Empty( SE2->E2_COFINS ) .Or. !Empty( SE2->E2_CSLL ) )
					SE2->E2_PRETPIS := "1"
					SE2->E2_PRETCOF := "1"
					SE2->E2_PRETCSL := "1"
				EndIf	

				If !lPCCBaixa
					Do Case
					Case cModRetPIS == "1"

						nVlRetPIS	:= 0
						nVlRetCOF	:= 0
						nVlRetCSLL	:= 0

						aDadosRet	:= NfeCalcRet( SE2->E2_VENCREA, nIndexSE2 , @aDadosImp )

						lRetParc	:= .F.

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se ha residual de retencao para ser somada a retencao do titulo atual³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If aDadosRet[ 6 ] > nValMinRet  // PIS
							lRetParc	:= .T.
							nVlRetPis += aDadosImp[1]
						EndIf

						If aDadosRet[ 7 ] > nValMinRet  // COFINS
							lRetParc	:= .T.
							nVlRetCof += aDadosImp[2]
						EndIf

						If aDadosRet[ 8 ] > nValMinRet  // CSLL
							lRetParc	:= .T.
							nVlRetCSLL += aDadosImp[3]
						EndIf

						If lRetParc 							
							nTotARet	:= nVlRetPIS + nVlRetCOF + nVlRetCSLL
							nSobra		:= SE2->E2_VALOR - nTotARet

							If nSobra < 0
								nSavRec		:= SE2->( Recno() )
								nFatorRed	:= 1 - ( Abs( nSobra ) / nTotARet )
								nVlRetPIS	:= NoRound( nVlRetPIS * nFatorRed, 2 )
								nVlRetCOF	:= NoRound( nVlRetCOF * nFatorRed, 2 )
								nVlRetCSLL	:= SE2->E2_VALOR - ( nVlRetPIS + nVlRetCOF ) - 0.01

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava o valor de NDF caso a retencao seja maior   ³
								//³ que o valor do titulo                             ³							
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If FindFunction("ADUPCREDRT")								
									ADupCredRt(Abs(nSobra),"501",SE2->E2_MOEDA)
								Endif	

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Restaura o registro do titulo original            ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								SE2->( MsGoto( nSavRec ) )

								Reclock( "SE2", .F. )
							EndIf

							lRestValImp := .T.

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Guarda os valores originais                           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nRetOriPIS  := SE2->E2_PIS
							nRetOriCOF  := SE2->E2_COFINS
							nRetOriCSLL := SE2->E2_CSLL

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava os novos valores de retencao para este registro ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SE2->E2_PIS    := nVlRetPIS 					
							SE2->E2_COFINS := nVlRetCOF 										
							SE2->E2_CSLL   := nVlRetCSLL 										

							nSavRec := SE2->( Recno() )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Exclui a Marca de "pendente recolhimento" dos demais registros   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aRecnos := aClone( aDadosRet[ 5 ] )

							cPrefOri  := SE2->E2_PREFIXO
							cNumOri   := SE2->E2_NUM
							cParcOri  := SE2->E2_PARCELA
							cTipoOri  := SE2->E2_TIPO
							cCfOri    := SE2->E2_FORNECE
							cLojaOri  := SE2->E2_LOJA

							For nLoop := 1 to Len( aRecnos )

								SE2->( dbGoto( aRecnos[ nLoop ] ) )

								RecLock( "SE2", .F. )

								If !Empty( nVlRetPIS )
									SE2->E2_PRETPIS := "2"
								EndIf

								If !Empty( nVlRetCOF )
									SE2->E2_PRETCOF := "2"
								EndIf

								If !Empty( nVlRetCSLL )
									SE2->E2_PRETCSL := "2"
								EndIf

								SE2->( MsUnlock() )  																								

								If AliasIndic("SFQ")
									If nSavRec <> aRecnos[ nLoop ]
										DbSelectArea("SFQ")
										RecLock("SFQ",.T.)
										SFQ->FQ_FILIAL  := xFilial("SFQ")
										SFQ->FQ_ENTORI  := "SE2"
										SFQ->FQ_PREFORI := cPrefOri
										SFQ->FQ_NUMORI  := cNumOri
										SFQ->FQ_PARCORI := cParcOri
										SFQ->FQ_TIPOORI := cTipoOri										
										SFQ->FQ_CFORI   := cCfOri
										SFQ->FQ_LOJAORI := cLojaOri

										SFQ->FQ_ENTDES  := "SE2"
										SFQ->FQ_PREFDES := SE2->E2_PREFIXO
										SFQ->FQ_NUMDES  := SE2->E2_NUM
										SFQ->FQ_PARCDES := SE2->E2_PARCELA
										SFQ->FQ_TIPODES := SE2->E2_TIPO
										SFQ->FQ_CFDES   := SE2->E2_FORNECE
										SFQ->FQ_LOJADES := SE2->E2_LOJA

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Grava a filial de destino caso o campo exista                    ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										SFQ->FQ_FILDES := SE2->E2_FILIAL

										MsUnlock()
									Endif								
								Endif					

							Next nLoop

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Retorna do ponteiro do SE1 para a parcela         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SE2->( MsGoto( nSavRec ) )
							Reclock( "SE2", .F. )

						Else 	
							lRetParc := .F. 							  	
						EndIf

					Case cModRetPIS == "2"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Efetua a retencao                                                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lRetParc := .T.
					Case cModRetPIS == "3" 			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Nao efetua a retencao                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lRetParc := .F.
					EndCase 			
				Else
					If lPccBaixa
						lRetParc := .F.
					Else
						lRetParc := .T.
					EndIf
				EndIf 					

				SE2->E2_VALOR	-= SE2->E2_PIS
				SE2->E2_SALDO	-= SE2->E2_PIS
				nVlCruz			-= SE2->E2_PIS

				SE2->E2_VALOR	-= SE2->E2_COFINS
				SE2->E2_SALDO	-= SE2->E2_COFINS
				nVlCruz			-= SE2->E2_COFINS					

				SE2->E2_VALOR	-= SE2->E2_CSLL
				SE2->E2_SALDO	-= SE2->E2_CSLL
				nVlCruz			-= SE2->E2_CSLL

				SE2->E2_VALOR   -= SE2->E2_FETHAB
				SE2->E2_SALDO   -= SE2->E2_FETHAB
				nVlCruz         -= SE2->E2_FETHAB					

			Else
				SE2->E2_VALOR   := aColsSE2[nX][nPValor]
				SE2->E2_SALDO   := aColsSE2[nX][nPValor]
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ha necessidade da gravacao das multiplas naturezas    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRateio := 0
			If lRatLiq
				nValor := SE2->E2_VALOR
				If !lRetParc
					nValor   += SE2->E2_PIS
				EndIf
				If !lRetParc
					nValor  += SE2->E2_COFINS
				EndIf
				If !lRetParc
					nValor   += SE2->E2_CSLL
				EndIf
			Else
				nValor   := aColsSE2[nX][nPValor]
			EndIf
			For nY := 1 To Len(aColsSEV)
				If !aColsSEV[nY][Len(aColsSEV[1])] .And. !Empty(aColsSEV[nY][1])
					SE2->E2_MULTNAT := "1"
					RecLock("SEV", .T. )
					For nZ := 1 To Len(aHeadSEV)
						If aHeadSEV[nZ][10]<>"V"
							SEV->(FieldPut(FieldPos(aHeadSEV[nZ][2]),aColsSEV[nY][nZ]))
						EndIf
					Next nZ
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := SE2->E2_PREFIXO
					SEV->EV_NUM      := SE2->E2_NUM
					SEV->EV_PARCELA  := SE2->E2_PARCELA
					SEV->EV_CLIFOR   := SE2->E2_FORNECE
					SEV->EV_LOJA     := SE2->E2_LOJA
					SEV->EV_TIPO     := SE2->E2_TIPO
					SEV->EV_VALOR    := IIf(nY==Len(aColsSEV),nValor-nRateio,NoRound(nValor*SEV->EV_PERC/100,2))
					SEV->EV_PERC     := SEV->EV_PERC/100
					SEV->EV_RECPAG   := "P"
					SEV->EV_LA       := ""
					SEV->EV_IDENT    := "1"
					nRateio += SEV->EV_VALOR
					nRateioSEZ := 0
					For nZ := 1 To Len(aSEZ)
						SEV->EV_RATEICC := "1"
						RecLock("SEZ",.T.)
						SEZ->EZ_FILIAL := xFilial("SEZ")
						SEZ->EZ_PREFIXO:= SEV->EV_PREFIXO
						SEZ->EZ_NUM    := SEV->EV_NUM
						SEZ->EZ_PARCELA:= SEV->EV_PARCELA
						SEZ->EZ_CLIFOR := SEV->EV_CLIFOR
						SEZ->EZ_LOJA   := SEV->EV_LOJA
						SEZ->EZ_TIPO   := SEV->EV_TIPO
						SEZ->EZ_PERC   := aSEZ[nZ][4]
						SEZ->EZ_VALOR  := IIf(nZ==Len(aSEZ),SEV->EV_VALOR-nRateioSEZ,NoRound(SEV->EV_VALOR*SEZ->EZ_PERC,2))
						SEZ->EZ_NATUREZ:= SEV->EV_NATUREZ
						SEZ->EZ_CCUSTO := aSEZ[nZ][1]
						SEZ->EZ_ITEMCTA:= aSEZ[nZ][2]
						SEZ->EZ_CLVL   := aSEZ[nZ][3]
						SEZ->EZ_RECPAG := SEV->EV_RECPAG
						SEZ->EZ_LA     := ""
						SEZ->EZ_IDENT  := SEV->EV_IDENT
						SEZ->EZ_SEQ    := SEV->EV_SEQ
						SEZ->EZ_SITUACA:= SEV->EV_SITUACA
						nRateioSEZ += SEZ->EZ_VALOR
						MsUnLock()
					Next nZ					
				EndIf
			Next nY			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa alteracoes da NF com base no contrato - SIGAGCT ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lGCTRet .Or. lGCTDesc .Or. lGCTMult .Or. lGCTBoni
				CNTAvalGCT(nGCTRet,nGCTDesc,nGCTMult,nGCTBoni,@nVlCruz,aContra)
			EndIf

			FaAvalSE2(1,"MatA100",(nX==1),MaFisRet(,"NF_VALIRR"),MaFisRet(,"NF_VALINS"),lRetParc,MaFisRet(,"NF_VALISS"),MaFisRet(,"NF_BASEISS"),lRatImp,cRecIss)
			If cPaisLoc == "BRA"
				If !lRetParc
					SE2->E2_VALOR	+= SE2->E2_PIS
					SE2->E2_SALDO	+= SE2->E2_PIS
					nVlCruz			+= SE2->E2_PIS
				EndIf
				If !lRetParc
					SE2->E2_VALOR	+= SE2->E2_COFINS
					SE2->E2_SALDO	+= SE2->E2_COFINS
					nVlCruz			+= SE2->E2_COFINS					
				EndIf
				If !lRetParc
					SE2->E2_VALOR	+= SE2->E2_CSLL
					SE2->E2_SALDO	+= SE2->E2_CSLL
					nVlCruz			+= SE2->E2_CSLL					
				EndIf
			EndIf			
			If lRetParc
				aCtbRet[1] += SE2->E2_PIS
				aCtbRet[2] += SE2->E2_COFINS
				aCtbRet[3] += SE2->E2_CSLL
			EndIf
			If lRestValImp
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Restaura os valores originais de PIS / COFINS / CSLL  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SE2->E2_PIS    := nRetOriPIS
				SE2->E2_COFINS := nRetOriCOF
				SE2->E2_CSLL   := nRetOriCSLL
			EndIf
			nInss			:=	Iif( SED->ED_DEDINSS=="2",0,SE2->E2_INSS )
			SE2->E2_VLCRUZ 	:= 	xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,NIL,SF1->F1_TXMOEDA)
			If cMRetISS == "1"
				nVlCruz -= SE2->E2_VLCRUZ+(nValFun+SE2->E2_IRRF+SE2->E2_ISS+nInss+nSEST)
			Else
				nVlCruz -= SE2->E2_VLCRUZ+(nValFun+SE2->E2_IRRF+nInss+nSEST)
			Endif
			If nX == nMaxFor
				SE2->E2_VLCRUZ += nVlCruz
			EndIf			

			If lMulta

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava as multas de contrato ( SIGAGCT ) na parcela                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nBaixaMult := Min( nSaldoMult, SE2->E2_SALDO )

				SE2->E2_DECRESC := nBaixaMult
				SE2->E2_SDDECRE := nBaixaMult

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Baixa o saldo a gravar                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSaldoMult -= nBaixaMult

			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava o valor da bonificacao ( SIGAGCT ) na parcela               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty( nSaldoBoni )

					SE2->E2_ACRESC  := nSaldoBoni
					SE2->E2_SDACRES := nSaldoBoni
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Zera o saldo a gravar                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSaldoBoni := 0

				EndIf 					

			EndIf 	

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Template acionando ponto de entrada                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistTemplate("MT100GE2")
				ExecTemplate("MT100GE2",.F.,.F.)
			EndIf			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada apos a gravacao do titulo a pagar                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Existblock("MT100GE2")
				ExecBlock("MT100GE2",.F.,.F.)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ O funrural somente deve ser gerado para a primeira parcela        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			nValFun	:= 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ A FETHAB somente deve ser gerada para a primeira parcela          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			nValFet	:= 0			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Armazena o recno dos titulos gerados                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If ValType( aRecGerSE2 ) == "A"
				AAdd( aRecGerSE2, SE2->( Recno() ) )
			EndIf 			

		EndIf		
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o valor de retencao do PIS/COFINS/CSLL para contabilizacao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetNewPar("MV_CTRETNF","1")=="2"
		RecLock("SF1")
		SF1->F1_VALPIS := aCtbRet[1]
		SF1->F1_VALCOFI := aCtbRet[2]
		SF1->F1_VALCSLL := aCtbRet[3]
	EndIf	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorno dos titulos a pagar                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFAULT aRecSE2 := {}
	For nX := 1 To Len(aRecSE2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorno dos titulos financeiros                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SE2")
		MsGoto(aRecSE2[nX])	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Template acionando ponto de entrada                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistTemplate("M103DSE2")
			ExecTemplate("M103DSE2",.F.,.F.)
		EndIf			

		If (Existblock("M103DSE2"))
			ExecBlock("M103DSE2",.F.,.F.)
		EndIf
		RecLock("SE2",.F.)
		dbDelete()
		FaAvalSE2(2,"MatA100")
		FaAvalSE2(3,"MatA100")
	Next nX
EndIf

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CntProcGct³ Autor ³Marcelo Custodio       ³ Data ³07/03/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula os valores de retencao, desconto e multas no        ³±±
±±³          ³documento de entrada                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A130GctCtr(lExp01,lExp02,lExp03,lExp04,@nExp05,@nExp06,     ³±±
±±³Sintaxe   ³           @nExp07,@nExp08,aExp09)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lExp01 - Informa se calcula retencao                        ³±±
±±³          ³lExp02 - Informa se calcula desconto                        ³±±
±±³          ³lExp03 - Informa se calcula multa                           ³±±
±±³          ³lExp04 - Informa se calcula bonificacao                     ³±±
±±³          ³nExp05 - Retorna total da retencao - Referencia             ³±±
±±³          ³nExp06 - Retorna total do desconto - Referencia             ³±±
±±³          ³nExp07 - Retorna total da multa - Referencia                ³±±
±±³          ³nExp08 - Retorna total da bonificacao - Referencia          ³±±
±±³          ³aExp09 - Armazena os contratos e medicoes processadas na    ³±±
±±³          ³         nota                                               ³±±
±±³          ³lExp10 - Informa se o titulo deve ser gerado bloqueado      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CntProcGct(lGCTRet,lGCTDesc,lGCTMult,lGCTBoni,nGCTRet,nGCTDesc,nGCTMult,nGCTBoni,aContra,lGCTBloq)

Local aArea    := GetArea()
Local aAreaSC7 := SC7->( GetArea() )
Local nLoop    := 0
Local cFilSC7  := xFilial("SC7")
Local cFilCN9  := xFilial("CN9")
Local cFilCNE  := xFilial("CNE")
Local cFilCND  := xFilial("CND")
Local cFilCNQ  := xFilial("CNQ")
Local cFilCNP  := xFilial("CNP")
Local cFilCNR  := xFilial("CNR")
Local cQuery   := ""
Local cAliasQr := ""
Local aChave   := {}
Local bChave   := {|| (SC7->C7_CONTRA+SC7->C7_CONTREV+SC7->C7_PLANILH+SC7->C7_MEDICAO)}

Local nPosPedido := GDFieldPos( "D1_PEDIDO" )  
Local nPosItem   := GDFieldPos( "D1_ITEMPC" )  
Local nPosTotal  := GDFieldPos( "D1_TOTAL"  )  
Local lM103VRet  := ExistBlock("M103VRET")
Local nM103VRet  := 0
Local lBloq      := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis de totalizacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nGCTRet  := 0
nGCTDesc := 0
nGCTMul  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe controle de bloqueio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lGCTBloq := !Empty( CND->( FieldPos( "CND_AUTFRN" ) ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe controle de retencao, desconto ou multa ³
//³ de contrato no titulo financeiro                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGCTRet .OR. lGCTDesc .OR. lGCTMult .Or. lGCTBoni .Or. lGCTBloq
	
	For nLoop := 1 to Len( aCols ) 
	                                           
		If !ATail( aCols[ nLoop ] ) 	
	
			SC7->( dbSetOrder(1) )
                    
			If SC7->( MsSeek( cFilSC7 + aCols[ nLoop, nPosPedido ] + aCols[ nLoop, nPosItem ] ) )
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Alimenta o array de medicoes / item desta NF                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If !Empty( SC7->C7_CONTRA )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica controle de retencao ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lGCTRet
						CN9->(dbSetOrder(1))
		
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no contrato                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
						If CN9->(dbSeek(cFilCN9+SC7->C7_CONTRA))
		
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o contrato possui retencao ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
							If CN9->CN9_FLGCAU = '1' .And. CN9->CN9_TPCAUC = '2'
								If !lM103VRet
									nGCTRet += (aCols[nLoop,nPosTotal] * CN9->CN9_MINCAU ) / 100
								Else
									If ValType( nM103VRet := ExecBlock("M103VRET",.F.,.F.,{SC7->C7_CONTRA,SC7->C7_CONTREV,SC7->C7_PLANILH})) == "N"
										nGCTRet += (aCols[nLoop,nPosTotal] * nM103VRet ) / 100
									EndIf
								EndIf
							EndIf
						
						EndIf
					
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica controle de desconto/multa ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (lGCTDesc .Or. lGCTMult .Or. lGCTBoni .Or. lGCTBloq) .And. aScan(aChave,Eval(bChave)) == 0
						aAdd(aChave,Eval(bChave))
						aAdd(aContra,{SC7->C7_CONTRA,SC7->C7_CONTREV,SC7->C7_PLANILH,SC7->C7_MEDICAO})
					
						CND->( dbSetOrder(1) )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona na medicao do contrato    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If CND->( dbSeek( cFilCND+SC7->C7_CONTRA+SC7->C7_CONTREV+SC7->C7_PLANILH+SC7->C7_MEDICAO ) )
							
 							If lGCTDesc
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Soma descontos nao aplicados na medicao ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cQuery := "SELECT SUM(CNQ.CNQ_VALOR) AS CNQ_VALOR "
								cQuery += "FROM "+RetSQLName("CNQ")+" CNQ, "+RetSQLName("CNP")+" CNP WHERE "
								cQuery += "CNQ.CNQ_FILIAL = '"+cFilCNQ+"' AND "
								cQuery += "CNP.CNP_FILIAL = '"+cFilCNP+"' AND "
								cQuery += "CNQ.CNQ_TPDESC = CNP.CNP_CODIGO AND "
								cQuery += "CNQ.CNQ_CONTRA = '"+SC7->C7_CONTRA+"' AND "
								cQuery += "CNQ.CNQ_NUMMED = '"+SC7->C7_MEDICAO+"' AND "
								cQuery += "CNP.CNP_FLGPED = '2' AND "
								cQuery += "CNQ.D_E_L_E_T_ = ' ' AND "
								cQuery += "CNP.D_E_L_E_T_ = ' '"
								
								cQuery := ChangeQuery(cQuery)
								cAliasQr := GetNextAlias()
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQr,.F.,.T.)
								
  								TCSetField(cAliasQr,"CNQ_VALOR" ,"N",TamSX3("CNQ_VALOR")[1],TamSX3("CNQ_VALOR")[2])
								
								If !(cAliasQr)->(Eof())
									nGCTDesc += (cAliasQr)->(CNQ_VALOR)
								EndIf
								
								(cAliasQr)->(dbCloseArea())
							EndIf
							
							If lGCTMult
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Soma multas nao aplicadas na medicao ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cQuery := "SELECT SUM(CNR.CNR_VALOR) AS CNR_VALOR "
								cQuery += "FROM "+RetSQLName("CNR")+" CNR WHERE "
								cQuery += "CNR.CNR_FILIAL = '"+cFilCNR+"' AND "
								cQuery += "CNR.CNR_NUMMED = '"+SC7->C7_MEDICAO+"' AND "
								cQuery += "CNR.CNR_FLGPED = '2' AND "
								cQuery += "CNR.CNR_TIPO = '1' AND "
								cQuery += "CNR.D_E_L_E_T_ = ' '"
								
								cQuery := ChangeQuery(cQuery)
								cAliasQr := GetNextAlias()
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQr,.F.,.T.)
								
  								TCSetField(cAliasQr,"CNR_VALOR" ,"N",TamSX3("CNR_VALOR")[1],TamSX3("CNR_VALOR")[2])
								
								If !(cAliasQr)->(Eof())
									nGCTMult += (cAliasQr)->(CNR_VALOR)
								EndIf
								
								(cAliasQr)->(dbCloseArea())
								
							EndIf
							
							If  lGCTBoni
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Soma bonificacoes nao aplicadas na medicao ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cQuery := "SELECT SUM(CNR.CNR_VALOR) AS CNR_VALOR "
								cQuery += "FROM "+RetSQLName("CNR")+" CNR WHERE "
								cQuery += "CNR.CNR_FILIAL = '"+cFilCNR+"' AND "
								cQuery += "CNR.CNR_NUMMED = '"+SC7->C7_MEDICAO+"' AND "
								cQuery += "CNR.CNR_FLGPED = '2' AND "
								cQuery += "CNR.CNR_TIPO = '2' AND "
								cQuery += "CNR.D_E_L_E_T_ = ' '"
								
								cQuery := ChangeQuery(cQuery)
								cAliasQr := GetNextAlias()
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQr,.F.,.T.)

  								TCSetField(cAliasQr,"CNR_VALOR" ,"N",TamSX3("CNR_VALOR")[1],TamSX3("CNR_VALOR")[2])

								If !(cAliasQr)->(Eof())
									nGCTBoni += (cAliasQr)->(CNR_VALOR)
								EndIf
								(cAliasQr)->(dbCloseArea())
							EndIf							

							If lGCTBloq
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se trata de uma autorizacao de fornecimento e se ³
								//³ foi encerrada                                             ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If CND->CND_AUTFRN == "2" .And. Empty(CND->CND_DTFIM)
									lBloq := .T.
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf 
			EndIf 
		EndIf 	
	Next nLoop
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informa se os titulos sao gerados bloqueados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lGCTBloq := lBloq

RestArea(aAreaSC7)

RestArea(aArea)

Return NIL


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOME005  ºAutor  ³Adriano Leonardo      º Data ³  17/11/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa arquivo para importação.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ³RCOME005                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImportArq()

Local   aCampos  := {}
Local   aDados   := {}
Local   aLinha   := {}

Local   cLinha   := ""
Local   _cNum    := ""
Local   _cProds  := ""

Local   nLinha   := 0
Local   _nCabIt  := 0
Local i	:= 0
Local   _lItem1  := .T.
Local   _lIIPrc  := MsgYesNo("O II já está agregado ao preço das mercadorias?","II no Preço")
Local _nCol		:= 0

FT_FUSE(cDrive+cDir+cNome+cExt)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
If !FT_FEOF()
	Begin Transaction
	dbSelectArea("SZJ")
	RecLock("SZJ",.T.)
	While !FT_FEOF()
		nLinha++
		IncProc("Lendo linha " + cValToChar(nLinha) + " do arquivo " + AllTrim(cNome+cExt) + "...")
		cLinha := FT_FREADLN()
		aLinha := Separa(cLinha,";",.T.)

		If nLinha < 13 			//Cabeçalho
			If nLinha == 2		//Romaneio de Nota Fiscal do Processo
				SZJ->ZJ_INVOICE := StrTran(aLinha[02],"EXP-","")
			ElseIf nLinha == 4	//Número da DI
				SZJ->ZJ_DI      := StrTran(StrTran(aLinha[02],"/",""),"-","")
			ElseIf nLinha == 8	//Data de Registro da DI
				SZJ->ZJ_DATADI  := CTOD(aLinha[02])
			EndIf
		Else //Itens
			If !Empty(aLinha[02]) //Certifico que a linha não esteja em branco
				AADD(aDados,Array(Len(aLinha))) //Faço a carga inicial do array de acordo com o número de colunas disponíveis
				
				//Preencho o array aDados com o conteúdo de cada coluna do arquivo CSV
				For _nCol := 1 To Len(aLinha)
					aDados[nLinha-12][_nCol] := aLinha[_nCol]
				Next
			EndIf
		EndIf
		
		FT_FSKIP()
	EndDo
	
	dbSelectArea("SA2")
	Set Filter To SA2->A2_EST == "EX"
	dbFilter()
	dbSelectArea("SF4")
	Set Filter To SF4->F4_CODIGO <= "500"
	dbFilter()
	If Len(aDados) > 0 .AND. ;
		ConPad1(,,,"SA2",,,.F.) .AND. ;
		ConPad1(,,,"SF4",,,.F.) .AND. ;
		IIF(AllTrim(SF4->F4_DUPLIC)=="S",ConPad1(,,,"SE4",,,.F.),.T.)
		_cNum           := GetSxeNum("SZJ","ZJ_NUM")
		ConfirmSx8(_cNum)
		SZJ->ZJ_ARQUIVO := cDrive+cDir+cNome+cExt
		SZJ->ZJ_COND    := SE4->E4_CODIGO
		SZJ->ZJ_FORNECE := SA2->A2_COD
		SZJ->ZJ_LOJA    := SA2->A2_LOJA
		SZJ->ZJ_NOMFOR  := SA2->A2_NOME
		SZJ->ZJ_NATUREZ := SA2->A2_NATUREZ
		SZJ->ZJ_ESPECIE := "SPED"
		SZJ->ZJ_DATA    := dDataBase
		SZJ->ZJ_NUM     := _cNum
		SZJ->ZJ_FILIAL  := xFilial("SZJ")
	Else
		dbSelectArea("SZJ")
		DELETE
	EndIf
	SZJ->(MSUNLOCK())
	End Transaction
	If !Empty(_cNum)
		Begin Transaction
		ProcRegua(Len(aDados))
		For i := 1 To Len(aDados)
			IncProc("Importando informações processadas para o sistema...")
			//_cProd   := StrTran(aDaDos[i][04],'"  / ','')
			//_cProd   := StrTran(SubStr(_cProd,1,AT("/",_cProd)-1),".","")
			//_cProd   := AllTrim(StrTran(_cProd,'"',''))
			
			_cProd := aDaDos[i][02]
			_lConPad 	:= .T.
			dbSelectArea("SB1")
			dbSetOrder(1)
			If !dbSeek(xFilial("SB1") + _cProd) .Or. Empty(_cProd)
			   
				//Validação de segurança para quando o item não contém hífen separador entre o código e a descrição do produto
				If Empty(_cProd)
					_cProd := aDaDos[i][02]
				EndIf
				
				While _lConPad
					If MsgYesNo("O produto " + _cProd + " não foi localizado. Deseja localizar manualmente?","SEEKSB1")
						If !(_lConPad := ConPad1(,,,"SB1",,,.F.))
							If MsgYesNo("Tem certeza de que realmente cancelar a importação deste produto?","ABORTSB1")
								_lConPad := .F.
								_cProds  += _cProd + CHR(13) + CHR(10)
							Else
								_lConPad := .T.
							EndIf
						Else
							_lConPad := .T.
							Exit
						EndIf
					Else
						Alert("Atenção! O produto " + _cProd + " foi descartado da importação!")
						_lConPad := .F.
						_cProds  += _cProd + CHR(13) + CHR(10)
					EndIf
				EndDo
			EndIf
 			If _lConPad
				_cDesc := StrTran(aDaDos[i][04] ,'"  -','')
				_cDesc := StrTran(_cDesc        ,'- "' ,'')
				_cDesc := AllTrim(StrTran(_cDesc,'"'   ,''))
								
				dbSelectArea("SZK")
				dbSetOrder(1)
				RecLock("SZK",.T.)
				SZK->ZK_FILIAL  := xFilial("SZK")
				SZK->ZK_NUM     := _cNum
				SZK->ZK_FORNECE := SA2->A2_COD
				SZK->ZK_LOJA    := SA2->A2_LOJA
				SZK->ZK_FABRIC  := SA2->A2_COD
				SZK->ZK_DFABRIC := dDataBase-10
				If Val(StrTran(aDaDos[i][19],",",".")) <> SuperGetMv("MV_TXCOF",.F.,9.65)
				  SZK->ZK_TES     := "001"
				  SZK->ZK_VALCMAJ := ROUND(Val(StrTran(StrTran(aDaDos[i][16],".",""),",","."))*(POSICIONE("SF4", 1, XFILIAL("SF4")+"050","F4_MALQCOF")/100),TAMSX3("ZK_VALCMAJ")[02])
				else						
					SZK->ZK_TES     := "002"
				EndIf   
				SZK->ZK_CF      := Posicione("SF4",1,xFilial("SF4")+SZK->ZK_TES,SF4->F4_CF)
				SZK->ZK_ITEM    := StrZero(i,TamSx3("ZK_ITEM")[1])
				SZK->ZK_COD     := SB1->B1_COD
				SZK->ZK_UM      := SB1->B1_UM
				SZK->ZK_LOCAL   := SB1->B1_LOCPAD
				SZK->ZK_QUANT   := Val(StrTran(StrTran(aDaDos[i][03],".",""),",","."))
				SZK->ZK_DESCRIC := _cDesc		//aDaDos[i][03]
				SZK->ZK_POSIPI  := IIF(!Empty(aDaDos[i][05]),aDaDos[i][05],SB1->B1_POSIPI)
				SZK->ZK_VUNIT   := Val(StrTran(StrTran(aDaDos[i][06],".",""),",",".")) - IIF(_lIIPrc,(Val(StrTran(StrTran(aDaDos[i][08],".",""),",","."))/Val(StrTran(StrTran(aDaDos[i][09],".",""),",","."))),0)
				SZK->ZK_IPI     := Val(StrTran(StrTran(aDaDos[i][11],".",""),",","."))
				SZK->ZK_VALIPI  := Val(StrTran(StrTran(aDaDos[i][12],".",""),",","."))
				SZK->ZK_BASEIPI := Val(StrTran(StrTran(aDaDos[i][10],".",""),",",".")) //IIF(SZK->ZK_VALIPI>0,((SZK->ZK_VALIPI*100)/SZK->ZK_IPI),0)
//				SZK->ZK_NFENTR  := aDaDos[i][08]
				SZK->ZK_VALPIS  := Val(StrTran(StrTran(aDaDos[i][17],".",""),",","."))
				SZK->ZK_II      := Val(StrTran(StrTran(aDaDos[i][08],".",""),",","."))
				SZK->ZK_CLASFIS := SF4->F4_CF //aDaDos[i][14]
				SZK->ZK_TOTAL   := Val(StrTran(StrTran(aDaDos[i][07],".",""),",",".")) - IIF(_lIIPrc,Val(StrTran(StrTran(aDaDos[i][08],".",""),",",".")),0)
				SZK->ZK_BASEICM := Val(StrTran(StrTran(aDaDos[i][13],".",""),",","."))
				SZK->ZK_PICM    := Val(StrTran(StrTran(aDaDos[i][15],".",""),",","."))
				SZK->ZK_VALICM  := Val(StrTran(StrTran(aDaDos[i][14],".",""),",","."))
				SZK->ZK_VALCOF  := Val(StrTran(StrTran(aDaDos[i][19],".",""),",","."))
				dbSelectArea("SYD")
				dbSetOrder(1)
				// Verifica as alíquotas de impostos na entrada por NCM se a alíquota
				If dbSeek(xFilial("SYD") + Padr(SZK->ZK_POSIPI,TamSx3("YD_TEC")[1])) .AND. SYD->YD_PER_PIS <> 0 .AND. SYD->YD_PER_COF <> 0
					SZK->ZK_ALQPIS  := SYD->YD_PER_PIS
					SZK->ZK_ALQCOF  := SYD->YD_PER_COF
				Else
					SZK->ZK_ALQPIS  := SuperGetMv("MV_TXPIS",.F.,2.10)
					SZK->ZK_ALQCOF  := SuperGetMv("MV_TXCOF",.F.,9.65)
				EndIf
				SZK->ZK_BASEPIS := Val(StrTran(StrTran(aDaDos[i][16],".",""),",","."))//((SZK->ZK_VALPIS * 100) / SZK->ZK_ALQPIS)
				SZK->ZK_BASECOF := Val(StrTran(StrTran(aDaDos[i][16],".",""),",","."))//((SZK->ZK_VALCOF * 100) / SZK->ZK_ALQCOF)
				SZK->(MSUNLOCK())
			EndIf
		Next
		End Transaction
		dbSelectArea("SZK")
		dbSetOrder(2)
		If dbSeek(xFilial("SZK") + _cNum)
			_cPosIPI := ""
			_nAdi    := 0
			_nSeqAd  := 0
			_nItSK   := 0
			_lAltIt  := MsgYesNo("Deseja alterar a ordem dos itens por Adição/Seq.Adição, ou mantém a ordem original, conforme o arquivo importado?","ALTORDER")
			While !EOF() .AND. SZK->ZK_NUM == _cNum
				_nItSK++
				If _cPosIPI <> SZK->ZK_POSIPI
					_nAdi++
					_nSeqAd := 1
				Else
					_nSeqAd++
				EndIf
				RecLock("SZK",.F.)
				If _lAltIt
					SZK->ZK_ITEM := StrZero(_nItSK,TamSx3("ZK_ITEM")[1])
				EndIf
				SZK->ZK_ADICAO   := cValToChar(_nAdi)
				SZK->ZK_SEQADI   := cValToChar(_nSeqAd)
				SZK->(MSUNLOCK())
				_cPosIPI := SZK->ZK_POSIPI
				dbSelectArea("SZK")
				dbSetOrder(2)
				dbSkip()
			EndDo
		EndIf
		If Empty(_cProds)
			ApMsgInfo("Arquivo importado com sucesso!","SUCESS")
		Else
			ApMsgInfo("Arquivo importado, porém alguns produtos não foram considerados por não terem sido localizados!"+CHR(13)+CHR(10)+_cProds,"PRESSIONE ENTER PARA FECHAR ESTA JANELA")
			MemoWrite("C:\Produtos_nao_Importados.txt",_cProds)
		EndIf
		U_COMA001M('SZJ',SZJ->(Recno()),4)
	Else
		Alert("Processamento cancelado!")
	EndIf
	dbSelectArea("SA2")
	Set Filter To
	dbFilter()
	dbSelectArea("SF4")
	Set Filter To
	dbFilter()
Else
	MsgAlert("Arquivo vazio!")
EndIf

FT_FUSE()

Return()