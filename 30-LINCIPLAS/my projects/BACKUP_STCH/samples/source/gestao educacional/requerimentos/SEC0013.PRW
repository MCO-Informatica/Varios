#Include "RWMAKE.CH"
#Include "MSOLE.CH"

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北砅rograma  ? SEC0013   	? Autor ?  ALAN S. R. OLIVEIRA  ? Data ? 19/06/02 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Emite o Conteudo Programatico             		       	      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? EXPL1 - Imprime apenas disciplinas aprovadas				   	  潮?
北?          ? EXPL2 - Solicita as assinaturas                	   	 	      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so		 ? Especifico Academico 							              潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
User Function SEC0013( lAprovadas )

lAprovadas	:= Iif( lAprovadas == NIL, .F., lAprovadas )

If LastKey() == 27
	Set Filter To
	Return
EndIf

// Chamada da rotina de armazenamento de dados...
Processa({||U_ACATRB0013(lAprovadas) })

DbSelectArea("JA2")	//CADASTRO DE ALUNOS
RetIndex("JA2")
DbSelectArea("JAE")	//CADASTRO DE DISCIPLINAS
RetIndex("JAE")
DbSelectArea("JC7")
RetIndex("JC7")
DbSelectArea("JAH")
RetIndex("JAH")
DbSelectArea("JBE")
RetIndex("JBE")

Return( .T. )

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矨CATRB0013? Autor ?  Regiane R. Barreira  ? Data ? 03/06/02 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Armazenamento e Tratamento dos dados 					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso 	 ? Especifico Academico              				          潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪幢?
北? Revis刼  ?								            ? Data ?  		  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
USER FUNCTION ACATRB0013(lAprovadas)

Local hWord
Local aRet		:= {}
Local cRA		:= Left(JBH_CODIDE,TamSX3("JA2_NUMRA")[1])
Local cQuery	:= ""
Local cArqDot	:= ""
Local cPathDot	:= ""
Local cPathEst	:= ""
Local cDECRET1	:= ""
Local cEMENTA1	:= ""
Local cCONTEUDO1:= ""
Local cOBJETIVO1:= ""
Local cBIBLIO1	:= ""
Local cDecret	:= ""
Local cConteudo := ""
Local cEmenta	:= ""
Local cObjetivo	:= ""
Local cBiblio	:= ""

ProcRegua( 3 )

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Retorna um vetor com os conteudos dos campos do script          ?
//硁a ordem que foi configurada no tipo do requerimento.            ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
aRet := ACScriptReq( JBH->JBH_NUM )

cQuery := "SELECT DISTINCT "
cQuery += " JA2.JA2_NOME   NOME    , "
cQuery += " JC7.JC7_DISCIP CODDISC , "
cQuery += " JAE.JAE_DESC   DISNOME , "
cQuery += " JC7.JC7_PERLET SERIE   , "
cQuery += " JC7.JC7_TURMA  TURMA   , "
cQuery += " JAH.JAH_CURSO  CURPAD  , "
cQuery += " JAE.JAE_MEMO1  CONT    , "
cQuery += " JAE.JAE_MEMO2  EMENTA  , "
cQuery += " JAE.JAE_MEMO4  OBJETIVO, "
cQuery += " JAE.JAE_MEMO3  BIBLIO  , "
cQuery += " JAE.JAE_MEMO5  METODO  , "
cQuery += " JAE.JAE_CARGA  CARGA   , "
cQuery += " JAH.JAH_UNIDAD UNIDADE , "
cQuery += " JBE.JBE_ANOLET ANO     , "
cQuery += " JBE.JBE_PERIOD SEMEST  , "
cQuery += " JC7.JC7_SITUAC SITUA   , "
cQuery += " JBE.JBE_DCOLAC DCOLAC  , "
cQuery += " JBE.JBE_HABILI HABILI "

cQuery += "FROM " 
cQuery += RetSQLName("JA2") + " JA2, "
cQuery += RetSQLName("JAE") + " JAE, "
cQuery += RetSQLName("JC7") + " JC7, "
cQuery += RetSQLName("JBE") + " JBE, "
cQuery += RetSQLName("JAH") + " JAH "

cQuery += "WHERE "
cQuery += "JA2.JA2_FILIAL = '" + xFilial("JA2") + "' AND "
cQuery += "JAE.JAE_FILIAL = '" + xFilial("JAE") + "' AND "
cQuery += "JC7.JC7_FILIAL = '" + xFilial("JC7") + "' AND "
cQuery += "JBE.JBE_FILIAL = '" + xFilial("JBE") + "' AND "
cQuery += "JAH.JAH_FILIAL = '" + xFilial("JAH") + "' AND "

cQuery += "JA2.JA2_NUMRA  = '" + cRA + "' AND "
cQuery += "JBE.JBE_NUMRA  = '" + cRA + "' AND "
cQuery += "JC7.JC7_NUMRA  = '" + cRA + "' AND "
cQuery += "JAH.JAH_CODIGO = '" + aRet[1] + "' AND "
cQuery += "JBE.JBE_CODCUR = '" + aRet[1] + "' AND "
cQuery += "JC7.JC7_CODCUR = '" + aRet[1] + "' AND "
cQuery += "JC7.JC7_SITUAC IN " + Iif( lAprovadas, "('2')", "('2', '1', '8')" ) + " AND "

cQuery += "JBE.JBE_NUMRA  = JC7.JC7_NUMRA  AND "
cQuery += "JBE.JBE_CODCUR = JC7.JC7_CODCUR AND "
cQuery += "JBE.JBE_PERLET = JC7.JC7_PERLET AND "
cQuery += "JBE.JBE_HABILI = JC7.JC7_HABILI AND "
cQuery += "JBE.JBE_TURMA  = JC7.JC7_TURMA  AND "
cQuery += "JAE.JAE_CODIGO = JC7.JC7_DISCIP AND "
cQuery += "JA2.JA2_NUMRA  = JBE.JBE_NUMRA  AND "
cQuery += "JAH.JAH_CODIGO = JBE.JBE_CODCUR AND "

cQuery += "JA2.D_E_L_E_T_ <> '*' AND "
cQuery += "JAE.D_E_L_E_T_ <> '*' AND "
cQuery += "JC7.D_E_L_E_T_ <> '*' AND "
cQuery += "JAH.D_E_L_E_T_ <> '*' AND "
cQuery += "JBE.D_E_L_E_T_ <> '*' "

cQuery += "ORDER BY JBE.JBE_ANOLET, JBE.JBE_PERIOD, JAE.JAE_DESC "

cQuery := ChangeQuery(cQuery)

IncProc()

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQJ", .F., .T.)
TcSetField("SQJ","CARGA" ,"N",3,0)
TcSetField("SQJ","DCOLAC" ,"D",8,0)

IncProc()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Criando link de comunicacao com o word                                ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
hWord := OLE_CreateLink()
OLE_SetProperty( hWord, oleWdVisible, .F.)

cArqDot  := "SEC0013.DOT" // Nome do Arquivo MODELO do Word
cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD
cPathEst:= Alltrim(GetMv("MV_DIREST")) // PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO

MontaDir(cPathEst)

If !File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgBox("Atencao... SEC0013.DOT nao encontrado no Servidor")
	Return NIL
EndIf

If File( cPathEst + cArqDot )
	Ferase( cPathEst + cArqDot )
EndIf

CpyS2T(cPathDot,cPathEst,.T.)

IncProc()

DbSelectArea("SQJ")
dbGoTop()

While !Eof()
	
	cDECRET1	:= ""
	cEMENTA1	:= ""
	cCONTEUDO1	:= ""
	cOBJETIVO1	:= ""
	cBIBLIO1	:= ""
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//? Gerando novo documento do Word na estacao                             ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	OLE_NewFile( hWord, cPathEst + cArqDot)
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//? Gerando variaveis do documento                                        ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	cDecret   := MSMM(AcDecret(SQJ->CURPAD, SQJ->DCOLAC, SQJ->UNIDADE))
	cDecret1  := StrTran( cDecret, Chr(13)+Chr(10), "/13/10" )
	
	cConteudo := MSMM(SQJ->CONT)
	cConteudo1:= StrTran( cConteudo, Chr(13)+Chr(10), "/13/10" )
	
	cEmenta   := MSMM(SQJ->EMENTA)
	cEmenta1  := StrTran( cEmenta, Chr(13)+Chr(10), "/13/10" )
	
	cObjetivo := MSMM(SQJ->OBJETIVO)
	cObjetivo1:= StrTran( cObjetivo, Chr(13)+Chr(10), "/13/10" )
	
	cBiblio   := MSMM(SQJ->BIBLIO)
	cBiblio1  := StrTran( cBiblio, Chr(13)+Chr(10), "/13/10" )
	
	cMetodo   := MSMM(SQJ->METODO)
	cMetodo1  := StrTran( cMetodo, Chr(13)+Chr(10), "/13/10" )
	
	OLE_SetDocumentVar(hWord, "cDECRET"		, Alltrim(cDECRET1))
	OLE_SetDocumentVar(hWord, "cCURSO"      , Alltrim(aRet[2]))
	OLE_SetDocumentVar(hWord, "cHABILI"     , Posicione("JDK",1,xFilial("JDK")+SQJ->HABILI,"JDK_DESC"))
	OLE_SetDocumentVar(hWord, "cNOMEDIS"	, Alltrim(SQJ->DISNOME))
	OLE_SetDocumentVar(hWord, "nCH"			, SQJ->CARGA)
	OLE_SetDocumentVar(hWord, "cCONTEUDO"	, Alltrim(cCONTEUDO1))
	OLE_SetDocumentVar(hWord, "cEMENTA"		, Alltrim(cEMENTA1))
	OLE_SetDocumentVar(hWord, "cOBJETIVO"	, Alltrim(cOBJETIVO1))
	OLE_SetDocumentVar(hWord, "cBIBLIO"		, Alltrim(cBIBLIO1))
	OLE_SetDocumentVar(hWord, "cMETODO"		, Alltrim(cMETODO1))
	OLE_SetDocumentVar(hWord, "nSERIE"		, SQJ->SERIE)
	OLE_SetDocumentVar(hWord, "nANO"		, SQJ->ANO)
	OLE_SetDocumentVar(hWord, "nSEMEST"		, SQJ->SEMEST)
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//? Atualizando variaveis do documento                                    ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	OLE_UpdateFields(hWord)
	
	OLE_ExecuteMacro(hWord,"Quebras")
	
	dbskip()
Enddo

OLE_SetProperty( hWord, oleWdVisible, .T. )
OLE_SetProperty( hWord, oleWdWindowState, "MAX" )

OLE_CloseLink( hWord, .F. )

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Apaga arquivos tempor爎ios							         ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DbSelectArea("SQJ")
DbCloseArea()

Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  ? SEC0013B ? Autor ? Gustavo Henrique   ? Data ?  02/12/02   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋escricao ? Calcula valor da solicitacao do requerimento a partir do   罕?
北?          ? total de disciplinas em que o aluno estah matriculado      罕?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? lWeb - Requerimento para Web (.T.)					   	  潮?
北?          ? cNumReq - Cod Requerimento (Somente para Web)		      潮?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Gestao Educacional                                         罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
User Function SEC0013B()

local nValDis	:= 0.50
local nValCalc	:= 0
local cRA		:= ""
local cCodCur	:= ""
local lWeb		:= IsBlind()

if !lWeb
	cRA		:= PadR( M->JBH_CODIDE, TamSx3("JA2_NUMRA")[1] )
	cCodCur := ACScriptReq( JBH->JBH_NUM )[1]
else
	cRa     := Padr(HttpSession->ra,TamSx3("JC7_NUMRA")[1])
	cCodCur := Padr(HttpSession->ccurso,TamSx3("JC7_CODCUR")[1])
endif

nValCalc := DisAprov( cRA, cCodCur ) * nValDis

Return( nValCalc )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  ? SEC0013C ? Autor ? Gustavo Henrique   ? Data ?  11/06/03   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋escricao ? Verifica se o aluno jah cursou pelo menos uma disciplina   罕?
北?          ? para poder solicitar o conteudo programatico do curso      罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Gestao Educacional                                         罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
User Function SEC0013C()

local cCodCur := ""
local cRA     := ""
local aRet    := {}
local lWeb    := IsBlind()
local lRet    := .T.

if ! lWeb
	cRA		:= PadR( M->JBH_CODIDE, TamSx3("JA2_NUMRA")[1] )
	cCodCur := M->JBH_SCP01
else
	cRa     := Padr(HttpSession->ra,TamSx3("JC7_NUMRA")[1])
	cCodCur := Padr(HttpSession->ccurso,TamSx3("JC7_CODCUR")[1])
endif

if DisAprov( cRA, cCodCur ) == 0
	
	if lWeb
		aadd(aRet,{.F.,"N鉶 existem disciplinas aprovadas para emiss鉶 do conte鷇o program醫ico."})
	else
		MsgStop( "N鉶 existem disciplinas aprovadas para emiss鉶 do conte鷇o program醫ico." )
		lRet := .F.
	endIf
	
endif

Return( iif( ! lWeb, lRet, aRet ) )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  ? DisAprov ? Autor ? Gustavo Henrique   ? Data ?  11/06/03   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋escricao ? Verifica se o aluno estah aprovado em alguma disciplina    罕?
北?          ? Utilizada para validar a permissao de solicitacao deste    罕?
北?          ? requerimento.                                              罕?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? EXPC1 - Numero do RA      			     				  潮?
北?          ? EXPC2 - Codigo do Curso Vigente              		      潮?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Gestao Educacional                                         罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function DisAprov( cRA, cCodCur )

local aDiscip := {}

JC7->( dbSetOrder( 1 ) )
JC7->( dbSeek( xFilial( "JC7" ) + cRA + cCodCur ) )

do while JC7->( ! EoF() .And. JC7_FILIAL + JC7_NUMRA + JC7_CODCUR == xFilial( "JC7" ) + cRA + cCodCur )
	
	if JC7->JC7_SITUAC == "2" .And. aScan( aDiscip, JC7->JC7_DISCIP ) == 0
		AAdd( aDiscip, JC7->JC7_DISCIP )
	endif
	
	JC7->( dbSkip() )
	
enddo

Return( len( aDiscip ) )
