#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'COLORS.CH'

// DISPARA UM PEDIDO PARA TESTES
// http://192.168.1.36/gerapedido/index.pl

// VERIFICA O STATUS DAS NOTAS DE UM DETERMINADO PEDIDO NO GAR
// http://gestaoar-homolog.certisign.com.br/gestaoar/invoices/list?id=7249&documento=74004336791

/* --------------------------------------------------------------------
Monitor de status das tabelas de log de entrada e saida do GT 
Mais monitoramento dos status dos engines de retransmissao 
-------------------------------------------------------------------- */
User Function GTMonitor()
Local oDlg,oFolder,oDummy,oGoOut,oSay,oGet,oFonte,oReturn,oInfo,oDescarte,oParam,oLbxOut,oLbxIn,oChave
Local oFilIn,oOrdIn,oFilOut,oOrdOut,oBFiltro,oBOrdem,oLbxInErr,oParamErr,oVtex,oBigFonte
Local aInfo		:= {}
Local aSay		:= {}
Local aDat		:= {}
Local nZero		:= 0
Local nI		:= 0
Local nLMax		:= 550	// 480
Local nCMax		:= 800	// 640
Local aGtOut	:= {}
Local aGtIn		:= {}
Local aGtInErr	:= {}
Local cReturn	:= ""
Local cInfo		:= ""
Local cParam	:= ""
Local cParamErr	:= ""
Local cChave	:= Space(250)
Local lGtCallB	:= .T.
Local cVtex		:= ""
Local nCor		:= 0

Private cFilIn	:= Space(250)
Private cOrdIn	:= Space(250)
Private cFilOut	:= Space(250)
Private cOrdOut	:= Space(250)


// Prepara a tabela de mensagens padronizadas
U_GARMensagem()

// Verifica se as tabelas de log foram todas criadas corretamente
U_GTSetUp()

// Cria um grupo de perguntas para selecao de apresentacao no monitor
AjustaSX1("GTMONI")
AjustaSX1("GTMOIN")
AjustaSX1("GTMOOU")
AjustaSX1("GTORIN")
AjustaSX1("GTOROU")


Private oPend,oDesc,oHist
Private lPend	:= .T.

DEFINE FONT oFonte    NAME "Courier New" SIZE 0,15 BOLD
DEFINE FONT oBigFonte NAME "Courier New" SIZE 0,25 BOLD

Aadd( aGtOut,	{"","","","","","","","","","","",0} )
Aadd( aGtIn,	{"","","","","","",0} )
Aadd( aGtInErr,	{"","","","","","","",0} )

MsgRun("Obtendo informa็๕es ...","Aguarde ...",{|| GetInfo(aInfo) } )

DEFINE MSDIALOG oDlg TITLE "Monitor de Processos - Integra็ใo GT" FROM 0,0 TO nLMax, nCMax OF oMainWnd PIXEL

@ 0,0 FOLDER oFolder ITEMS "Integra็ใo com GAR", "Pacotes Recebidos", "Pacotes Devolvidos" OF oDlg SIZE (nCMax/2)+5,(nLMax/2)-18 PIXEL


// OBJETOS DO PRIMEIRO FOLDER

@ 005,010 TO 030,(nCMax/2)-10 LABEL "Monitoramento do servi็o VTEX" OF oFolder:aDialogs[1] PIXEL

USE GTLOG ALIAS GTLOG SHARED NEW VIA "TOPCONN"
GTLOG->( DbGoTo( LastRec() ) )

If lGtCallB
	If GTLOG->GT_DATE <> Date()
		If GTLOG->GT_DATE < Date()-1
			lGtCallB := .F.
		Endif
		If lGtCallB
			If !( Val(SubStr(GTLOG->GT_TIME,1,2)) == 0 .AND. Val(SubStr(GTLOG->GT_TIME,4,2)) > 2 )
				lGtCallB := .F.
			Endif
		Endif
	Else
		If Val(SubStr(GTLOG->GT_TIME,1,2)) < Val(SubStr(Time(),1,2)) .OR. Val(SubStr(GTLOG->GT_TIME,4,2)) < Val(SubStr(Time(),4,2))
			lGtCallB := .F.
		Endif
	Endif
Endif

Do Case
	Case !lGtCallB
		cVtex := "NรO MONITORADO"
		nCor := CLR_BLACK
	Case GTLOG->GT_ONLINE
		cVtex := "VTEX ATIVO"
		nCor := CLR_GREEN
	OtherWise
		cVtex := "VTEX PARADO"
		nCor := CLR_RED
Endcase
GTLOG->( DbCloseArea() )

@ 015,015 SAY oVtex PROMPT cVtex OF oFolder:aDialogs[1] PIXEL FONT oBigFonte COLOR nCor SIZE 100,10

@ 010,120 SAY "Empresa.: " + Getjobprofstring("JOBEMP","01") OF oFolder:aDialogs[1] PIXEL FONT oFonte
@ 020,120 SAY "Filial..: " + Getjobprofstring("JOBFIL","02") OF oFolder:aDialogs[1] PIXEL FONT oFonte
@ 010,170 SAY "Intervalo.: " + Getjobprofstring("INTERVAL","60") + " segundos" OF oFolder:aDialogs[1] PIXEL FONT oFonte
@ 020,170 SAY "Servi็o...: " + Getjobprofstring("GTRESPONSEURL","http://200.219.128.28:8000/VTEXServiceBus") OF oFolder:aDialogs[1] PIXEL FONT oFonte

For nI := 1 To Len(aInfo)
	
	@ (nI*10)+30 , 010 SAY oSay PROMPT space(50) OF oFolder:aDialogs[1] PIXEL FONT oFonte
	@ (nI*10)+30 , 200 SAY oDat PROMPT space(15) OF oFolder:aDialogs[1] PIXEL FONT oFonte
	
	Aadd( aSay , oSay )
	aSay[nI]:SetText(aInfo[nI][1])
	
	Aadd( aDat , oDat ) 
	Do Case
		Case ValType(aInfo[nI][2]) == "C"
			aDat[nI]:SetText(aInfo[nI][2])
		Case ValType(aInfo[nI][2]) == "N"
			aDat[nI]:SetText(Str(aInfo[nI][2],10))
		Case ValType(aInfo[nI][2]) == "D"
			aDat[nI]:SetText(DotC(aInfo[nI][2]))
		Case ValType(aInfo[nI][2]) == "L"
			aDat[nI]:SetText(IIF(aInfo[nI][2],".T.",".F."))
	Endcase
	
Next nI


// OBJETOS DO SEGUNDO FOLDER

@ 02,02 SAY "Pacotes recebidos" OF oFolder:aDialogs[2] PIXEL FONT oFonte

@ 10, 0 LISTBOX oLbxIn FIELDS HEADER "Pedido GAR/Site", "Data", "Hora", "Tipo", "Status" SIZE (nCMax/4),(nLMax/5)-10 OF oFolder:aDialogs[2] PIXEL
oLbxIn:SetArray(aGtIn)
oLbxIn:bLine := {||{;
				aGtIn[oLbxIn:nAt][1],;
				aGtIn[oLbxIn:nAt][2],;
				aGtIn[oLbxIn:nAt][3],;
				aGtIn[oLbxIn:nAt][4],;
				aGtIn[oLbxIn:nAt][5];
				}}
oLbxIn:bChange := { || AtuInMemo(oLbxIn, @oParam, @cParam) }


@ (nLMax/5),0 GET oParam VAR cParam OF oFolder:aDialogs[2] MEMO SIZE (nCMax/4),(nLMax/5) READONLY PIXEL FONT oFonte
oParam:lWordWrap := .F.

@ 02,(nCMax/4)+02 SAY "Pacotes nใo respondidos" OF oFolder:aDialogs[2] PIXEL FONT oFonte

@ 10, (nCMax/4) LISTBOX oLbxInErr FIELDS HEADER "Pedido GAR/Site", "Data", "Hora", "Tipo", "Status", "Pedido" SIZE (nCMax/4)+3,(nLMax/5)-10 OF oFolder:aDialogs[2] PIXEL
oLbxInErr:SetArray(aGtInErr)
oLbxInErr:bLine := {||{;
				aGtInErr[oLbxInErr:nAt][1],;
				aGtInErr[oLbxInErr:nAt][2],;
				aGtInErr[oLbxInErr:nAt][3],;
				aGtInErr[oLbxInErr:nAt][4],;
				aGtInErr[oLbxInErr:nAt][5],;
				aGtInErr[oLbxInErr:nAt][6];
				}}
oLbxInErr:bChange := { || AtuInErrMemo(oLbxInErr, @oParamErr, @cParamErr) }

@ (nLMax/5),(nCMax/4) GET oParamErr VAR cParamErr OF oFolder:aDialogs[2] MEMO SIZE (nCMax/4)+2,(nLMax/5) READONLY PIXEL FONT oFonte
oParamErr:lWordWrap := .F.


@ (nLMax/2)-48, 005 SAY "Filtro" OF oFolder:aDialogs[2] PIXEL FONT oFonte
@ (nLMax/2)-50, 030 GET oFilIn VAR cFilIn OF oFolder:aDialogs[2] SIZE 120,10 PIXEL FONT oFonte VALID Filtro("GTMOIN",.T.,@oFilIn)

@ (nLMax/2)-50, 150 BUTTON oBFiltro PROMPT "?" SIZE 10,12 ;
	ACTION Filtro("GTMOIN",.T.,@oFilIn,.T.) ; 
	OF oFolder:aDialogs[2] PIXEL

@ (nLMax/2)-48, 180 SAY "Ordem" OF oFolder:aDialogs[2] PIXEL FONT oFonte
@ (nLMax/2)-50, 205 GET oOrdIn VAR cOrdIn OF oFolder:aDialogs[2] SIZE 120,10 PIXEL FONT oFonte VALID Ordem("GTORIN",.T.,@oOrdIn)

@ (nLMax/2)-50, 325 BUTTON oBOrdem PROMPT "?" SIZE 10,12 ;
	ACTION Ordem("GTORIN",.T.,@oOrdIn,.T.) ; 
	OF oFolder:aDialogs[2] PIXEL


// OBJETOS DO TERCEIRO FOLDER

@ 0, 0 LISTBOX oLbxOut FIELDS HEADER "Pedido GAR/Site", "Data", "Hora", "Tipo", "Mensagem", "Time Descarte", "Usuario", "Status" SIZE (nCMax/2)+3,(nLMax/5) OF oFolder:aDialogs[3] PIXEL
oLbxOut:SetArray(aGtOut)
oLbxOut:bLine := {||{;
				aGtOut[oLbxOut:nAt][1],;
				aGtOut[oLbxOut:nAt][2],;
				aGtOut[oLbxOut:nAt][3],;
				aGtOut[oLbxOut:nAt][4],;
				aGtOut[oLbxOut:nAt][5],;
				aGtOut[oLbxOut:nAt][6],;
				aGtOut[oLbxOut:nAt][7],;
				aGtOut[oLbxOut:nAt][8];
				}}
oLbxOut:bChange := { || AtuOutMemo(oLbxOut, @oReturn, @cReturn, @oInfo, @cInfo) }

@ (nLMax/5),0 GET oReturn VAR cReturn OF oFolder:aDialogs[3] MEMO SIZE (nCMax/4),(nLMax/5) READONLY PIXEL FONT oFonte
oReturn:lWordWrap := .F.

@ (nLMax/5),(nCMax/4) GET oInfo VAR cInfo OF oFolder:aDialogs[3] MEMO SIZE (nCMax/4)+2,(nLMax/5) READONLY PIXEL FONT oFonte
oInfo:lWordWrap := .F.


@ (nLMax/2)-48, 005 SAY "Filtro" OF oFolder:aDialogs[3] PIXEL FONT oFonte
@ (nLMax/2)-50, 030 GET oFilOut VAR cFilOut OF oFolder:aDialogs[3] SIZE 120,10 PIXEL FONT oFonte VALID Filtro("GTMOOU",.T.,@oFilOut)

@ (nLMax/2)-50, 150 BUTTON oBFiltro PROMPT "?" SIZE 10,12 ;
	ACTION Filtro("GTMOOU",.T.,@oFilOut,.T.) ; 
	OF oFolder:aDialogs[3] PIXEL

@ (nLMax/2)-48, 180 SAY "Ordem" OF oFolder:aDialogs[3] PIXEL FONT oFonte
@ (nLMax/2)-50, 205 GET oOrdOut VAR cOrdOut OF oFolder:aDialogs[3] SIZE 120,10 PIXEL FONT oFonte VALID Ordem("GTOROU",.T.,@oOrdOut)

@ (nLMax/2)-50, 325 BUTTON oBOrdem PROMPT "?" SIZE 10,12 ;
	ACTION Ordem("GTOROU",.T.,@oOrdOut,.T.) ; 
	OF oFolder:aDialogs[3] PIXEL


@ (nLMax/2)-55, (nCMax/2)-051 CHECKBOX oPend VAR lPend PROMPT "Pend๊ncias" SIZE 50,5 OF oFolder:aDialogs[3] PIXEL ;
	ON CHANGE MsgRun("Atualizando informa็๕es ...","Aguarde ...",{|| (Atualizar(.T.,aInfo,aDat,@oLbxOut,@oReturn,@cReturn,@oInfo,@cInfo,@oLbxIn,@oParam,@cParam,@oParamErr,@cParamErr,@oLbxInErr,@oVtex),oLbxOut:SetFocus()) } )

@ (nLMax/2)-45, (nCMax/2)-051 BUTTON oDescarte PROMPT "Descartar" SIZE 40,12 ;
	ACTION Descarte(@oDlg,nLMax,nCMax,aInfo,aDat,@oLbxOut,@oReturn,@cReturn,@oInfo,@cInfo,@oLbxIn,@oParam,@cParam,@oParamErr,@cParamErr,@oDlg,@oFolder,@oLbxInErr,@oVtex) ; 
	OF oFolder:aDialogs[3] PIXEL WHEN lPend


// OBJETOS DA DIALOG

@ (nLMax/2)-15, 010 BUTTON oDummy PROMPT "Atualizar" SIZE 40,12 ;
	ACTION MsgRun("Atualizando informa็๕es ...","Aguarde ...",{|| Atualizar(.T.,aInfo,aDat,@oLbxOut,@oReturn,@cReturn,@oInfo,@cInfo,@oLbxIn,@oParam,@cParam,@oParamErr,@cParamErr,@oLbxInErr,@oVtex) } ) ; 
	OF oDlg PIXEL

@ (nLMax/2)-15, 060 GET oChave VAR cChave OF oDlg SIZE 150,10 PIXEL FONT oFonte

@ (nLMax/2)-15, 210 BUTTON oDummy PROMPT ">>>" SIZE 20,12 ;
	ACTION MsgRun("Pesquisando informa็๕es ...","Aguarde ...",{|| Pesquisar(oFolder,@cChave,@oLbxOut,@oReturn,@cReturn,@oInfo,@cInfo,@oLbxIn,@oParam,@cParam,@oParamErr,@cParamErr) } ) ; 
	OF oDlg PIXEL

@ (nLMax/2)-15,300 BUTTON oGoOut PROMPT "Editar XML" SIZE 40,12 ;
	ACTION EditXml(oFolder,oLbxOut,oLbxIn) ;
	OF oDlg PIXEL

@ (nLMax/2)-15, (nCMax/2)-50 BUTTON oGoOut PROMPT "Finalizar" SIZE 40,12 ;
	ACTION oDlg:End() ;
	OF oDlg PIXEL

Filtro("GTMOIN",.F.,@oFilIn)
Ordem("GTORIN",.F.,@oOrdIn)

Filtro("GTMOOU",.F.,@oFilOut)
Ordem("GTOROU",.F.,@oOrdOut)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT MsgRun("Pesquisando informa็๕es ...","Aguarde ...",{|| ;
Atualizar(.F.,aInfo,aDat,@oLbxOut,@oReturn,@cReturn,@oInfo,@cInfo,@oLbxIn,@oParam,@cParam,@oParamErr,@cParamErr,@oLbxInErr,@oVtex) ;
 } )



Return(.T.)

/* --------------------------------------------------------------------
Rotina de pesquisa pelo numero do pedido GAR
-------------------------------------------------------------------- */
Static Function Pesquisar(oFolder,cChave,oLbxOut,oReturn,cReturn,oInfo,cInfo,oLbxIn,oParam,cParam,oParamErr,cParamErr)

Local nPos	:= 0

If oFolder:nOption == 1
	MsgStop("Nใo hแ pesquisa para este folder...")
Endif

If oFolder:nOption == 2
	nPos := Ascan( oLbxIn:aArray, { |x| AllTrim(x[1])==AllTrim(cChave) } )
	If nPos > 0
		oLbxIn:nAt := nPos
		oLbxIn:Refresh()
		
		AtuInMemo(@oLbxIn, @oParam, @cParam)
	Else
		MsgStop("Pedido nใo localizado...")
	Endif
Endif

If oFolder:nOption == 3
	nPos := Ascan( oLbxOut:aArray, { |x| AllTrim(x[1])==AllTrim(cChave) } )
	If nPos > 0
		oLbxOut:nAt := nPos
		oLbxOut:Refresh()
		
		AtuOutMemo(oLbxOut, oReturn, cReturn, oInfo, cInfo)
	Else
		MsgStop("Pedido nใo localizado...")
	Endif
Endif

cChave := Space(100)

Return(.T.)

/* --------------------------------------------------------------------
Rotina para editar o XML da Fila de Atendimento
-------------------------------------------------------------------- */
Static Function EditXml(oFolder,oLbxOut,oLbxIn)
Local nRec 		:= 0
Local nAt		:= 0
Local cSql		:= ""
Local lRet		:= .F.
Local cID       := ""
Local cNpSite 	:= ""
Local cUpdPed	:= ""
Local cPedGar	:= ""
Local cParam	:= ""

If oFolder:nOption == 1
	MsgStop("Nใo hแ pesquisa para este folder...")
Endif

If oFolder:nOption == 2
	
	nAt := oLbxIn:nAt
	nRec:= oLbxIn:aArray[nAt][7]
	cSql	:= " SELECT " 
	cSql	+= " 	GT_ID, "
	cSql	+= " 	GT_TYPE, "
	cSql	+= " 	GT_PEDGAR, "
	cSql	+= " 	GT_XNPSITE "
	cSql	+= " FROM " 
	cSql	+= " 	GTIN "
	cSql	+= " WHERE "
	cSql	+= " 	R_E_C_N_O_ = "+Alltrim(Str(nRec))
	
	USE (TcGenQry(,,cSql)) ALIAS TMPIN EXCLUSIVE NEW VIA "TOPCONN"
	cID		:= Alltrim(TMPIN->GT_ID)
	cNpSite := Alltrim(TMPIN->GT_XNPSITE) 
	cPedGar:= Alltrim(TMPIN->GT_PEDGAR)
	cType	:= Alltrim(TMPIN->GT_TYPE)  
	If !TMPIN->(Eof()) 
		lRet := U_VNDA080(cID,cNpSite,cPedGar,cType,nRec)
	Else
		MsgStop("Nใo Foram Encontrados Dados para Pesquisa")
	EndIf
	
	TMPIN->(DbCloseArea())
Endif

If oFolder:nOption == 3
	nAt := oLbxOut:nAt
	nRec:= iif(Len(oLbxOut:aArray[nAt]) >= 12, oLbxOut:aArray[nAt][12], 0 )
	cSql	:= " SELECT " 
	cSql	+= " 	GT_ID, "
	cSql	+= " 	GT_XNPSITE, "
	cSql	+= " 	GT_PEDGAR "	
	cSql	+= " FROM " 
	cSql	+= " 	GTOUT "
	cSql	+= " WHERE "
	cSql	+= " 	R_E_C_N_O_ = "+Alltrim(Str(nRec))
	
	USE (TcGenQry(,,cSql)) ALIAS TMPOUT EXCLUSIVE NEW VIA "TOPCONN"
	
	If !TMPOUT->(Eof()) 
		cID		:= Alltrim(TMPOUT->GT_ID)
		cNpSite := Alltrim(TMPOUT->GT_XNPSITE) 
		cPedGar:= Alltrim(TMPOUT->GT_PEDGAR) 
		lRet := U_VNDA080(cID,cNpSite)
	Else
		MsgStop("Nใo Foram Encontrados Dados para Pesquisa")
	EndIf
	
	TMPOUT->(DbCloseArea())
Endif

If lRet
	cUpdPed := "UPDATE GTIN "
	cUpdPed += "SET GT_SEND = 'F' "
	cUpdPed += "WHERE GT_ID = '" + cID + "' "
	cUpdPed += "  AND GT_TYPE = 'F' "
	cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' "
	cUpdPed += "  AND D_E_L_E_T_ = ' ' "	
	
	TCSqlExec(cUpdPed)

EndIf

Return(.T.)

/* --------------------------------------------------------------------
Recupera numero de registros da tabela informada rodando 
Query diretamente no banco de dados
-------------------------------------------------------------------- */
STATIC Function GetCount(cTable,cCondicao)
Local cQry := 'SELECT COUNT(*) AS TOTAL FROM '+cTable
Local nTot := -1
DEFAULT cCondicao := ''
If !empty(cCondicao)
	cQry += ' WHERE '+cCondicao
Endif
USE (TcGenQry(,,cQry)) ALIAS TMPQRY EXCLUSIVE NEW VIA "TOPCONN"
If !eof()
	nTot := TMPQRY->TOTAL
Endif
USE
Return(nTot)


/* --------------------------------------------------------------------
Funcao para criar na tela os itens que serao apresentados e seus
respectivos valroes apurados na base de LOGs 
-------------------------------------------------------------------- */
STATIC Function GetInfo(aInfo)

Asize(aInfo,0)

Aadd( aInfo, {PadR("TOTAL DE PROCESSOS POR LOG "+Replicate("-",86),86),	"" } )
Aadd( aInfo, {"   Total de Registros de Entrada (GTIN)", GetCount("GTIN") } )
Aadd( aInfo, {"   Total de Registros de Saida (GTOUT)", GetCount("GTOUT") } )
Aadd( aInfo, {"   Total de Registros de Retorno (GTRET)", GetCount("GTRET") } )
Aadd( aInfo, {"",""} )
Aadd( aInfo, {PadR("TOTAL DE PROCESSOS DA TABELA GTIN "+Replicate("-",86),86),	"" } )
Aadd( aInfo, {"   Requisicoes distribuidas - WEBPROC pegou", GetCount("GTIN","GT_SEND='T'") } )
Aadd( aInfo, {"   Processamento indisponivel - WEBPROC todos ocupados", GetCount("GTIN","GT_SEND='F'") } )
Aadd( aInfo, {"   Bombardeio do VTEX", GetCount("GTIN","GT_INPROC='T'") } )
Aadd( aInfo, {"",""} )
Aadd( aInfo, {PadR("TOTAL DE PROCESSOS DA TABELA GTRET "+Replicate("-",86),86),	"" } )
Aadd( aInfo, {"   Retorno Pendente - Pedidos (GTRET, TYPE='P')", GetCount("GTRET","GT_TYPE = 'P' AND D_E_L_E_T_ = ' '") } )
Aadd( aInfo, {"   Retorno Pendente - Entrega Futura (GTRET, TYPE='F')", GetCount("GTRET","GT_TYPE = 'F' AND D_E_L_E_T_ = ' '") } )
Aadd( aInfo, {"   Retorno Pendente - Entrega Efetiva (GTRET, TYPE='E')", GetCount("GTRET","GT_TYPE = 'E' AND D_E_L_E_T_ = ' '") } )
Aadd( aInfo, {"",""} )
Aadd( aInfo, {PadR("TOTAL DE PROCESSOS DA TABELA GTOUT "+Replicate("-",86),86),	"" } )
Aadd( aInfo, {"   Processos com erro na entrada", GetCount("GTOUT","GT_STATUS = 'N' AND GT_ULTIMO = 'S' AND D_E_L_E_T_ = ' '") } )
Aadd( aInfo, {"   Processos descartados", GetCount("GTOUT","GT_STATUS = 'D' AND D_E_L_E_T_ = ' '") } )
Aadd( aInfo, {"   Processos com sucesso na entrada", GetCount("GTOUT","GT_STATUS = 'S' AND GT_ULTIMO = 'S' AND D_E_L_E_T_ = ' '") } )

Return(.T.)


/* --------------------------------------------------------------------
Funcao para calcular o total para cada indicador, tambem eh utilizada
para calcular os valores em caso de REFRESH da tela.
-------------------------------------------------------------------- */
STATIC Function UpdateInfo(aInfo,aDat)
Local nI
For nI := 1 to len(aInfo)
	Do Case
		Case ValType(aInfo[nI][2]) == "C"
			aDat[nI]:SetText(aInfo[nI][2])
		Case ValType(aInfo[nI][2]) == "N"
			aDat[nI]:SetText(Str(aInfo[nI][2],10))
		Case ValType(aInfo[nI][2]) == "D"
			aDat[nI]:SetText(DotC(aInfo[nI][2]))
		Case ValType(aInfo[nI][2]) == "L"
			aDat[nI]:SetText(IIF(aInfo[nI][2],".T.",".F."))
	Endcase
Next
Return(.T.)


/* --------------------------------------------------------------------
Funcao disparada pelo botao atualizar na tela de monitoramento que 
ira realizar um refresh de tela
-------------------------------------------------------------------- */
Static Function Atualizar(lOpen,aInfo,aDat,oLbxOut,oReturn,cReturn,oInfo,cInfo,oLbxIn,oParam,cParam,oParamErr,cParamErr,oLbxInErr,oVtex)

Local lGtCallB	:= .T.
Local nCor		:= 0
Local cVTex		:= ""

GetInfo(aInfo)

UpdateInfo(aInfo,aDat)

//Processa( { || GtInList(@oLbxIn, @oParam, @cParam) } )
MsgRun("Processando entrada...","Aguarde ...",{|| GtInList(lOpen, @oLbxIn, @oParam, @cParam) } )

//Processa( { || GtInErrList(@oLbxInErr, @oParamErr, @cParamErr) } )
MsgRun("Processando entrada nใo devolvida...","Aguarde ...",{|| GtInErrList(lOpen, @oLbxInErr, @oParamErr, @cParamErr) } )

//Processa( { || GtOutList(@oLbxOut, @oReturn, @cReturn, @oInfo, @cInfo) } )
MsgRun("Processando saํda...","Aguarde ...",{|| GtOutList(lOpen, @oLbxOut, @oReturn, @cReturn, @oInfo, @cInfo) } )

	If Select("GTLOG") > 0
		DbSelectArea("GTLOG")
		DbCloseArea("GTLOG")
	End If

USE GTLOG ALIAS GTLOG SHARED NEW VIA "TOPCONN"
GTLOG->( DbGoTo( LastRec() ) )

If lGtCallB
	If GTLOG->GT_DATE <> Date()
		If GTLOG->GT_DATE < Date()-1
			lGtCallB := .F.
		Endif
		If lGtCallB
			If !( Val(SubStr(GTLOG->GT_TIME,1,2)) == 0 .AND. Val(SubStr(GTLOG->GT_TIME,4,2)) > 2 )
				lGtCallB := .F.
			Endif
		Endif
	Else
		If Val(SubStr(GTLOG->GT_TIME,1,2)) < Val(SubStr(Time(),1,2)) .OR. Val(SubStr(GTLOG->GT_TIME,4,2))+1 < Val(SubStr(Time(),4,2))
			lGtCallB := .F.
		Endif
	Endif
Endif

Do Case
	Case !lGtCallB
		cVtex := "NรO MONITORADO"
		nCor := CLR_BLACK
	Case GTLOG->GT_ONLINE
		cVtex := "VTEX ATIVO"
		nCor := CLR_GREEN
	OtherWise
		cVtex := "VTEX PARADO"
		nCor := CLR_RED
Endcase
GTLOG->( DbCloseArea() )

oVtex:cCaption	:= cVtex
oVtex:cTitle	:= cVtex
oVtex:nClrText	:= nCor
oVtex:Refresh()

Return(.T.)


/* --------------------------------------------------------------------
Atualiza o objeto listbox que estah apresentado no segundo folder da
tela de monitoramento.
-------------------------------------------------------------------- */
Static Function GtOutList(lOpen, oLbxOut, oReturn, cReturn, oInfo, cInfo)
Local nAt		:= oLbxOut:nAt
Local aGtOut	:= {}
Local cOrder	:= ""
Local cWhere	:= ""
Local cQry		:= ""
Local nQtd		:= 0

cOrder := AllTrim(cOrdOut)
cOrder := StrTran(cOrder,"Crescente",		"")
cOrder := StrTran(cOrder,"Decrescente",		"DESC")
cOrder := StrTran(cOrder,"Pedido",			"GT_PEDGAR")
cOrder := StrTran(cOrder,"Data",			"GT_DATE")
cOrder := StrTran(cOrder,"Hora",			"GT_TIME")
cOrder := StrTran(cOrder,"Tipo",			"GT_TYPE")

cWhere := AllTrim(cFilOut)
cWhere := StrTran(cWhere,"(maior ou igual a)",	">=")
cWhere := StrTran(cWhere,"(menor ou igual a)",	"<=")
cWhere := StrTran(cWhere,"(em)",				"IN")
cWhere := StrTran(cWhere,"(e)",					"AND")
cWhere := StrTran(cWhere,"(ou)",				"OR")
cWhere := StrTran(cWhere,"(igual a)",			"=")
cWhere := StrTran(cWhere,"(deferente de)",		"<>")
cWhere := StrTran(cWhere,"Pedido",				"GT_PEDGAR")
cWhere := StrTran(cWhere,"Data",				"GT_DATE")
cWhere := StrTran(cWhere,"Tipo",				"GT_TYPE")
cWhere := StrTran(cWhere,"Usuario",				"GT_USRDES")
cWhere := StrTran(cWhere,"Hora",				"GT_TIME")

If lPend
	cWhere +=	" AND GT_ULTIMO = 'S' AND GT_STATUS = 'N' "
Endif

If lOpen
	cQry :=	" SELECT  GT_PEDGAR, GT_DATE, GT_TIME, GT_TYPE, GT_CODMSG, GT_TIMDES, GT_USRDES, GT_STATUS, " +;
			"         NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_MOTDES,2000,1)),'') AS GT_MOTDES, " +;
			"         NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_RETURN,2000,1)),'') AS GT_RETURN, " +;
			"         NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_INFO,2000,1)),'') AS GT_INFO, " +;
			"         R_E_C_N_O_ " +;
			" FROM    GTOUT " +;
			" WHERE    " + cWhere + " AND "
	
	cQry +=	" D_E_L_E_T_ = ' '  "
	cQry += " UNION "+;
				StrTran(cQry,"GT_PEDGAR ", "GT_XNPSITE ")

	
	If !Empty(cOrder)
		cQry +=	" ORDER BY " + cOrder
	Endif
	
	USE (TcGenQry(,,cQry)) ALIAS TMPQRY EXCLUSIVE NEW VIA "TOPCONN"

	If Select("GTOUT") > 0
		DbSelectArea("GTOUT")
		DbCloseArea("GTOUT")
	End If

	USE GTOUT ALIAS GTOUT SHARED NEW VIA "TOPCONN"
	
	//ProcRegua( 0 )
	
	While TMPQRY->( !Eof() )
		
		GTOUT->(DbGoTo(TMPQRY->R_E_C_N_O_))
		
		nQtd++
	//	IncProc("Lendo Saidas " + AllTrim(Str(nQtd)))
	//	ProcessMessage()
		
		SZ7->( DbSetOrder(1) )
		SZ7->( !MsSeek( xFilial("SZ7")+TMPQRY->GT_CODMSG ) )
		
		Aadd( aGtOut, {	TMPQRY->GT_PEDGAR,;
						StoD(TMPQRY->GT_DATE),;
						TMPQRY->GT_TIME,;
						TMPQRY->GT_TYPE,;
						SZ7->Z7_DESMEN,;
						TMPQRY->GT_TIMDES,;
						TMPQRY->GT_USRDES,;
						TMPQRY->GT_STATUS,;
						GTOUT->GT_RETURN,;
						GTOUT->GT_MOTDES,;
						GTOUT->GT_INFO,;
						TMPQRY->R_E_C_N_O_} )
		TMPQRY->( DbSkip() )
	End
	USE
	TMPQRY->( DbCloseArea() )
	
Endif

If Empty(aGtOut)
	Aadd( aGtOut, {"1234567890",dDataBase,Time(),"X","Nใo hแ pedidos com erros pendentes de corre็ใo","20100101245959","Administrador","X","Memo cReturn sem informa็ใo","Memo DESCARTE sem Informa็ใo","Memo cInfo sem informa็ใo"} )
Endif

oLbxOut:SetArray(aGtOut)
oLbxOut:bLine := {||{;
				aGtOut[oLbxOut:nAt][1],;
				aGtOut[oLbxOut:nAt][2],;
				aGtOut[oLbxOut:nAt][3],;
				aGtOut[oLbxOut:nAt][4],;
				aGtOut[oLbxOut:nAt][5],;
				aGtOut[oLbxOut:nAt][6],;
				aGtOut[oLbxOut:nAt][7],;
				aGtOut[oLbxOut:nAt][8];
				}}
If nAt <= Len(aGtOut)
	oLbxOut:nAt := nAt
Else
	oLbxOut:nAt := Len(aGtOut)
Endif
oLbxOut:Refresh()

cReturn:=oLbxOut:aArray[oLbxOut:nAt][9]
oReturn:Refresh()

IF !Empty(oLbxOut:aArray[oLbxOut:nAt][10])
	cInfo:=oLbxOut:aArray[oLbxOut:nAt][10]+CRLF+CRLF+oLbxOut:aArray[oLbxOut:nAt][11]
Else
	cInfo:=oLbxOut:aArray[oLbxOut:nAt][11]
Endif
oInfo:Refresh()

Return(.T.)



/* --------------------------------------------------------------------
Atualiza o objeto listbox que estah apresentado no segundo folder da
tela de monitoramento.
-------------------------------------------------------------------- */
Static Function GtInList(lOpen, oLbxIn, oParam, cParam)
Local nAt		:= oLbxIn:nAt
Local aGtIn		:= {}
Local cWhere	:= ""
Local cOrder	:= ""
Local cQry		:= ""
Local nQtd		:= 0

cWhere := AllTrim(cFilIn)
cWhere := StrTran(cWhere,"(maior ou igual a)",	">=")
cWhere := StrTran(cWhere,"(menor ou igual a)",	"<=")
cWhere := StrTran(cWhere,"(em)",				"IN")
cWhere := StrTran(cWhere,"(e)",					"AND")
cWhere := StrTran(cWhere,"(ou)",				"OR")
cWhere := StrTran(cWhere,"(igual a)",			"=")
cWhere := StrTran(cWhere,"(deferente de)",		"<>")
cWhere := StrTran(cWhere,"Pedido",				"GT_PEDGAR")
cWhere := StrTran(cWhere,"Data",				"GT_DATE")
cWhere := StrTran(cWhere,"Tipo",				"GT_TYPE")
cWhere := StrTran(cWhere,"Status",				"GT_SEND")
cWhere := StrTran(cWhere,"Hora",				"GT_TIME")

cOrder := AllTrim(cOrdIn)
cOrder := StrTran(cOrder,"Crescente",		"")
cOrder := StrTran(cOrder,"Decrescente",		"DESC")
cOrder := StrTran(cOrder,"Pedido",			"GT_PEDGAR")
cOrder := StrTran(cOrder,"Data",			"GT_DATE")
cOrder := StrTran(cOrder,"Hora",			"GT_TIME")
cOrder := StrTran(cOrder,"Tipo",			"GT_TYPE")

If lOpen
	cQry :=	" SELECT   GT_PEDGAR, GT_DATE, GT_TIME, GT_TYPE, GT_SEND, " +;
			"          NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)),'') AS GT_PARAM, " +;
			"          R_E_C_N_O_ " +;
			" FROM     GTIN " +;
			" WHERE    " + cWhere + " AND " +;
			"          D_E_L_E_T_ = ' '  "
	cQry += " UNION "+;
					StrTran(cQry,"GT_PEDGAR ", "GT_XNPSITE ")
	
	If !Empty(cOrder)
		cQry +=	" ORDER BY " + cOrder
	Endif
	
	USE (TcGenQry(,,cQry)) ALIAS TMPQRY EXCLUSIVE NEW VIA "TOPCONN"
	
	If Select("GTIN") > 0
		DbSelectArea("GTIN")
		DbCloseArea("GTIN")
	End If
	
	USE GTIN ALIAS GTIN SHARED NEW VIA "TOPCONN"
	
	//ProcRegua( 0 )
	
	While TMPQRY->( !Eof() )
		
		GTIN->(DbGoTo(TMPQRY->R_E_C_N_O_)) 
		
		nQtd++
	//	IncProc("Lendo Entradas " + AllTrim(Str(nQtd)))
	//	ProcessMessage()
		
		Aadd( aGtIn, {	TMPQRY->GT_PEDGAR,;
						StoD(TMPQRY->GT_DATE),;
						TMPQRY->GT_TIME,;
						TMPQRY->GT_TYPE,;
						IIF(TMPQRY->GT_SEND=="T","ACEITO","NEGADO"),;
						GTIN->GT_PARAM,;
						TMPQRY->R_E_C_N_O_} )
		TMPQRY->( DbSkip() )
	End
	USE
	TMPQRY->( DbCloseArea() )
	
Endif

If Empty(aGtIn)
	Aadd( aGtIn, {"1234567890",dDataBase,Time(),"X","SEM DADOS","",0} )
Endif

oLbxIn:SetArray(aGtIn)
oLbxIn:bLine := {||{;
				aGtIn[oLbxIn:nAt][1],;
				aGtIn[oLbxIn:nAt][2],;
				aGtIn[oLbxIn:nAt][3],;
				aGtIn[oLbxIn:nAt][4],;
				aGtIn[oLbxIn:nAt][5];
				}}
If nAt <= Len(aGtIn)
	oLbxIn:nAt := nAt
Else
	oLbxIn:nAt := Len(aGtIn)
Endif
oLbxIn:Refresh()

cParam=oLbxIn:aArray[oLbxIn:nAt][6]
oParam:Refresh()

Return(.T.)


/* --------------------------------------------------------------------
Atualiza o objeto listbox que estah apresentado no segundo folder da
tela de monitoramento.
-------------------------------------------------------------------- */
Static Function GtInErrList(lOpen, oLbxInErr, oParamErr, cParamErr)
Local nAt		:= oLbxInErr:nAt
Local aGtInErr	:= {}
Local cWhere	:= ""
Local cOrder	:= ""
Local cQry		:= ""
Local cPedido	:= ""
Local nQtd		:= 0

cWhere := AllTrim(cFilIn)
cWhere := StrTran(cWhere,"(maior ou igual a)",	">=")
cWhere := StrTran(cWhere,"(menor ou igual a)",	"<=")
cWhere := StrTran(cWhere,"(em)",				"IN")
cWhere := StrTran(cWhere,"(e)",					"AND")
cWhere := StrTran(cWhere,"(ou)",				"OR")
cWhere := StrTran(cWhere,"(igual a)",			"=")
cWhere := StrTran(cWhere,"(deferente de)",		"<>")
cWhere := StrTran(cWhere,"Pedido",				"GT_PEDGAR")
cWhere := StrTran(cWhere,"Data",				"GT_DATE")
cWhere := StrTran(cWhere,"Tipo",				"GT_TYPE")
cWhere := StrTran(cWhere,"Status",				"GT_SEND")
cWhere := StrTran(cWhere,"Hora",				"GT_TIME")

cOrder := AllTrim(cOrdIn)
cOrder := StrTran(cOrder,"Crescente",		"")
cOrder := StrTran(cOrder,"Decrescente",		"DESC")
cOrder := StrTran(cOrder,"Pedido",			"GT_PEDGAR")
cOrder := StrTran(cOrder,"Data",			"GT_DATE")
cOrder := StrTran(cOrder,"Hora",			"GT_TIME")
cOrder := StrTran(cOrder,"Tipo",			"GT_TYPE")

If lOpen
	cQry :=	" SELECT   GT_PEDGAR, GT_DATE, GT_TIME, GT_TYPE, GT_SEND, " +;
			"          NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)),'') AS GT_PARAM, " +;
			"          R_E_C_N_O_ " +;
			" FROM     GTIN " +;
			" WHERE    GTIN.GT_ID NOT IN (SELECT GT_ID FROM GTOUT WHERE GTOUT.GT_ID = GTIN.GT_ID AND D_E_L_E_T_ = ' ') AND " +;
			"          GTIN.GT_PEDGAR NOT IN (SELECT GT_PEDGAR FROM GTOUT WHERE GTOUT.GT_PEDGAR = GTIN.GT_PEDGAR AND GTOUT.GT_TYPE = 'P' AND D_E_L_E_T_ = ' ') AND " +;
			"          GTIN.GT_TYPE = 'P' AND " +;
			"          GTIN.GT_SEND = 'T' AND " +;
			"          " + cWhere + " AND " +;
			"          D_E_L_E_T_ = ' ' " +;
			" UNION " +;
			" SELECT   GT_PEDGAR, GT_DATE, GT_TIME, GT_TYPE, GT_SEND, " +;
			"          NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)),'') AS GT_PARAM, " +;
			"          R_E_C_N_O_ " +;
			" FROM     GTIN " +;
			" WHERE    GTIN.GT_ID NOT IN (SELECT GT_ID FROM GTOUT WHERE GTOUT.GT_ID = GTIN.GT_ID AND D_E_L_E_T_ = ' ') AND " +;
			"          GTIN.GT_PEDGAR NOT IN (SELECT GT_PEDGAR FROM GTOUT WHERE GTOUT.GT_PEDGAR = GTIN.GT_PEDGAR AND GTOUT.GT_TYPE = 'E' AND D_E_L_E_T_ = ' ') AND " +;
			"          GTIN.GT_TYPE = 'N' AND " +;
			"          GTIN.GT_SEND = 'T' AND " +;
			"          " + cWhere + " AND " +;
			"          D_E_L_E_T_ = ' ' "
	
	
	If !Empty(cOrder)
		cQry +=	" ORDER BY " + cOrder
	Endif
	
	USE (TcGenQry(,,cQry)) ALIAS TMPQRY EXCLUSIVE NEW VIA "TOPCONN"
	
	If Select("GTIN") > 0
		DbSelectArea("GTIN")
		DbCloseArea("GTIN")
	End If

	USE GTIN ALIAS GTIN SHARED NEW VIA "TOPCONN"
	
	
	//SC5->( DbSetOrder(5) )		// C5_FILIAL + C5_CHVBPAG
	SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
	
	//ProcRegua( 0 )
	
	While TMPQRY->( !Eof() )
	
		GTIN->(DbGoTo(TMPQRY->R_E_C_N_O_))
		
		nQtd++
	//	IncProc("Lendo Saidas " + AllTrim(Str(nQtd)))
	//	ProcessMessage()
		
		If SC5->( MsSeek( xFilial("SC5")+TMPQRY->GT_PEDGAR ) )
			cPedido := SC5->C5_NUM
		Else
			cPedido := ""
		Endif
		
		Aadd( aGtInErr, {	TMPQRY->GT_PEDGAR,;
							StoD(TMPQRY->GT_DATE),;
							TMPQRY->GT_TIME,;
							TMPQRY->GT_TYPE,;
							IIF(TMPQRY->GT_SEND=="T","ACEITO","NEGADO"),;
							cPedido,;
							GTIN->GT_PARAM,;
							TMPQRY->R_E_C_N_O_} )
		TMPQRY->( DbSkip() )
	End
	USE
	TMPQRY->( DbCloseArea() )

Endif

If Empty(aGtInErr)
	Aadd( aGtInErr, {"1234567890",dDataBase,Time(),"X","SEM DADOS","","",0} )
Endif

oLbxInErr:SetArray(aGtInErr)
oLbxInErr:bLine := {||{;
				aGtInErr[oLbxInErr:nAt][1],;
				aGtInErr[oLbxInErr:nAt][2],;
				aGtInErr[oLbxInErr:nAt][3],;
				aGtInErr[oLbxInErr:nAt][4],;
				aGtInErr[oLbxInErr:nAt][5],;
				aGtInErr[oLbxInErr:nAt][6];
				}}
If nAt <= Len(aGtInErr)
	oLbxInErr:nAt := nAt
Else
	oLbxInErr:nAt := Len(aGtInErr)
Endif
oLbxInErr:Refresh()

cParamErr=oLbxInErr:aArray[oLbxInErr:nAt][7]
oParamErr:Refresh()

Return(.T.)



/* --------------------------------------------------------------------
Atualiza os campos MEMO no evento change no listbox
-------------------------------------------------------------------- */
Static Function AtuInMemo(oLbxIn, oParam, cParam)

cParam := RTrim(oLbxIn:aArray[oLbxIn:nAt][6])
oParam:SetFocus()
oParam:Refresh()
oLbxIn:SetFocus()
oLbxIn:Refresh()

Return(.T.)



/* --------------------------------------------------------------------
Atualiza os campos MEMO no evento change no listbox
-------------------------------------------------------------------- */
Static Function AtuInErrMemo(oLbxInErr, oParamErr, cParamErr)

cParamErr := RTrim(oLbxInErr:aArray[oLbxInErr:nAt][7])
oParamErr:SetFocus()
oParamErr:Refresh()
oLbxInErr:SetFocus()
oLbxInErr:Refresh()

Return(.T.)



/* --------------------------------------------------------------------
Atualiza os campos MEMO no evento change no listbox
-------------------------------------------------------------------- */
Static Function AtuOutMemo(oLbxOut, oReturn, cReturn, oInfo, cInfo)

cReturn:=oLbxOut:aArray[oLbxOut:nAt][9]
oReturn:Refresh()

IF !Empty(oLbxOut:aArray[oLbxOut:nAt][10])
	cInfo:=oLbxOut:aArray[oLbxOut:nAt][10]+CRLF+CRLF+oLbxOut:aArray[oLbxOut:nAt][11]
Else
	cInfo:=oLbxOut:aArray[oLbxOut:nAt][11]
Endif
oInfo:Refresh()

Return(.T.)


/* --------------------------------------------------------------------
Em caso de acontecer uma ocorerncia de erro em um pedido que naum sera
incluido no sistema por motivos diversos, o mesmo poderah ser descarta
do do controle do log de pendencias. Para isto deverแ ser informado  o 
motivo e ficarah registrado o nome data e hora de quem descartou.
-------------------------------------------------------------------- */
Static Function Descarte(oDlg,nLMax,nCMax,aInfo,aDat,oLbxOut,oReturn,cReturn,oInfo,cInfo,oLbxIn,oParam,cParam,oParamErr,cParamErr,oDlg,oFolder,oLbxInErr,oVtex)

Local oDlgDes,oTime,oUsrDes,oMotDes,oConfirma,oCancela
Local cTime		:= DtoS(Date())+StrTran(Time(),":","")
Local cUsrDes	:= cUserName
Local cMotDes	:= ""
Local nOpcA		:= 0
Local cUpdate	:= ""
Local cSelect	:= ""
Local cStatus	:= ""

cSelect	:=	" SELECT GT_STATUS FROM GTOUT WHERE R_E_C_N_O_ = " + AllTrim(Str(oLbxOut:aArray[oLbxOut:nAt][12]))
USE (TcGenQry(,,cSelect)) ALIAS TMPQRY EXCLUSIVE NEW VIA "TOPCONN"
If !Eof()
	cStatus := TMPQRY->GT_STATUS
Endif
USE

If Empty(cStatus) .OR. cStatus <> "N"
	MsgStop("Apenas processos pendentes poderใo ser descartados...")
	Return(.F.)
Endif

nLMax := nLMax/2
nCMax := nCMax/2

DEFINE MSDIALOG oDlgDes TITLE "Descarte do processo" FROM 0,0 TO nLMax, nCMax OF oDlg PIXEL
	
@ 010, 010 SAY "Data e Hora" OF oDlgDes PIXEL
@ 010, (nCMax/4)-10 GET oTime VAR cTime OF oDlgDes SIZE (nCMax/4),5 READONLY PIXEL

@ 020, 010 SAY "Responsavel" OF oDlgDes PIXEL
@ 020, (nCMax/4)-10 GET oUsrDes VAR cUsrDes OF oDlgDes SIZE (nCMax/4),5 READONLY PIXEL

@ 030, 010 SAY "Descri็ใo do Motivo" OF oDlgDes PIXEL
@ 040, 010 GET oMotDes VAR cMotDes OF oDlgDes MEMO SIZE (nCMax/2)-20,(nLMax/4) PIXEL
oMotDes:lWordWrap := .F.

@ (nLMax/2)-15, (nCMax/2)-100 BUTTON oConfirma PROMPT "Confirmar" SIZE 40,12 ;
	ACTION ( nOpcA:=1,oDlgDes:End() ) ; 
	OF oDlgDes PIXEL

@ (nLMax/2)-15, (nCMax/2)-050 BUTTON oCancela PROMPT "Cancelar" SIZE 40,12 ;
	ACTION ( nOpcA:=0,oDlgDes:End() ) ; 
	OF oDlgDes PIXEL

ACTIVATE MSDIALOG oDlgDes CENTERED

If nOpcA == 1 .AND. MsgYesNo("Confirma o descarte deste processo...")
	cUpdate	:=	" UPDATE GTOUT " +;
				" SET    GT_TIMDES = '" + cTime + "', " +;
				"        GT_USRDES = '" + cUsrDes + "', " +;
				"        GT_MOTDES = '" + cMotDes + "', " +;
				"        GT_STATUS = 'D' " +;
				" WHERE  R_E_C_N_O_ = "+ AllTrim(Str(oLbxOut:aArray[oLbxOut:nAt][12]))
	
	MsgRun("Descartando processo ...","Aguarde ...",{|| TcSqlExec(cUpdate) } )
	MsgRun("Atualizando informa็๕es ...","Aguarde ...",{|| Atualizar(.T.,aInfo,aDat,@oLbxOut,@oReturn,@cReturn,@oInfo,@cInfo,@oLbxIn,@oParam,@cParam,@oParamErr,@cParamErr,@oLbxInErr,@oVtex) } )
	
Endif

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1 บAutor  ณArmando M. Tessaroliบ Data ณ  31/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o pergunte padrao                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Aromatica                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

Local aRegs	:=	{}

Do Case
	Case cPerg == "GTMONI"
		SX1->( DbSetOrder(1) )
		SX1->( MsSeek( cPerg ) )
		While	SX1->( !Eof() ) .AND.;
				SX1->X1_GRUPO == cPerg
			
			SX1->( RecLock("SX1",.F.) )
			SX1->( DbDelete() )
			SX1->( MsUnLock() )
			
			SX1->( DbSkip() )
		End		
	
	Case cPerg == "GTMOIN"
		Aadd(aRegs,{cPerg,"01","Pedido GAR De",			"","","MV_CH1","C",10,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"02","Pedido GAR Ate",		"","","MV_CH2","C",10,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"03","Data De",				"","","MV_CH3","D",08,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"04","Data Ate",				"","","MV_CH4","D",08,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"05","Tipo",					"","","MV_CH5","C",20,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"06","Status",				"","","MV_CH6","N",01,0,0,"C","","Mv_Par06","Aceito","","","","","Negado","","","","","Ambos","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"07","Hora De",				"","","MV_CH7","C",05,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"08","Hora Ate",				"","","MV_CH8","C",05,0,0,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		PlsVldPerg( aRegs )
	
	Case cPerg == "GTMOOU"
		Aadd(aRegs,{cPerg,"01","Pedido GAR De",			"","","MV_CH1","C",10,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"02","Pedido GAR Ate",		"","","MV_CH2","C",10,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"03","Data De",				"","","MV_CH3","D",08,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"04","Data Ate",				"","","MV_CH4","D",08,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"05","Tipo",					"","","MV_CH5","C",20,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"06","Usuario",				"","","MV_CH6","C",50,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"07","Hora De",				"","","MV_CH7","C",05,0,0,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"08","Hora Ate",				"","","MV_CH8","C",05,0,0,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		PlsVldPerg( aRegs )
		
	Case cPerg == "GTORIN"
		Aadd(aRegs,{cPerg,"01","Pedido -> 0,1,2,3,4",	"","","MV_CH1","C",01,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"02","Data -> 0,1,2,3,4",		"","","MV_CH2","C",01,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"03","Hora -> 0,1,2,3,4",		"","","MV_CH3","C",01,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"04","Tipo -> 0,1,2,3,4",		"","","MV_CH4","C",01,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"05","Sequencia",				"","","MV_CH5","N",01,0,0,"C","","Mv_Par05","Crescente","","","","","Decrescente","","","","","","","","","","","","","","","","","","","","","","","",""})
		PlsVldPerg( aRegs )
		
	Case cPerg == "GTOROU"
		Aadd(aRegs,{cPerg,"01","Pedido -> 0,1,2,3,4",	"","","MV_CH1","C",01,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"02","Data -> 0,1,2,3,4",		"","","MV_CH2","C",01,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"03","Hora -> 0,1,2,3,4",		"","","MV_CH3","C",01,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"04","Tipo -> 0,1,2,3,4",		"","","MV_CH4","C",01,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"05","Sequencia",				"","","MV_CH5","N",01,0,0,"C","","Mv_Par05","Crescente","","","","","Decrescente","","","","","","","","","","","","","","","","","","","","","","","",""})
		PlsVldPerg( aRegs )

Endcase

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGTMONITOR บAutor  ณMicrosiga           บ Data ณ  04/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Filtro(cPerg,lPerg,oFiltro,lForca)

Local cFilAux	:= ""

Default lForca	:= .F.

Do Case
	Case cPerg == "GTMOIN"
		Pergunte("GTMOIN",.F.)
		cFilAux := ""
		cFilAux += "Pedido (maior ou igual a) '"+IIF(Empty(Mv_Par01),Mv_Par01,AllTrim(Mv_Par01))+"' (e) Pedido (menor ou igual a) '"+IIF(Empty(Mv_Par02),Mv_Par02,AllTrim(Mv_Par02)) + "' "
		cFilAux += " (e) "
		cFilAux += "Data (maior ou igual a) '"+DtoS(Mv_Par03)+"' (e) Data (menor ou igual a) '"+DtoS(Mv_Par04) + "' "
		cFilAux += " (e) "
		cFilAux += "Tipo (em) ('" + StrTran(AllTrim(Mv_Par05),",","','") + "') "
		If Mv_Par06 == 1
			cFilAux += " (e) "
			cFilAux += "Status (igual a) 'T'"
		ElseIf Mv_Par06 == 2
			cFilAux += " (e) "
			cFilAux += "Status (igual a) 'F'"
		Endif
		cFilOut += " (e) "
		cFilOut += "Hora (maior ou igual a) '"+Mv_Par07+"' (e) Hora (menor ou igual a) '"+Mv_Par08 + "' "
		cFilOut := AllTrim(cFilOut)
		
		If AllTrim(cFilAux) <> AllTrim(cFilIn) .OR. lForca
			Pergunte("GTMOIN",lPerg)
			cFilIn := ""
			cFilIn += "Pedido (maior ou igual a) '"+IIF(Empty(Mv_Par01),Mv_Par01,AllTrim(Mv_Par01))+"' (e) Pedido (menor ou igual a) '"+IIF(Empty(Mv_Par02),Mv_Par02,AllTrim(Mv_Par02)) + "' "
			cFilIn += " (e) "
			cFilIn += "Data (maior ou igual a) '"+DtoS(Mv_Par03)+"' (e) Data (menor ou igual a) '"+DtoS(Mv_Par04) + "' "
			cFilIn += " (e) "
			cFilIn += "Tipo (em) ('" + StrTran(AllTrim(Mv_Par05),",","','") + "') "
			If Mv_Par06 == 1
				cFilIn += " (e) "
				cFilIn += "Status (igual a) 'T'"
			ElseIf Mv_Par06 == 2
				cFilIn += " (e) "
				cFilIn += "Status (igual a) 'F'"
			Endif
			cFilIn += " (e) "
			cFilIn += "Hora (maior ou igual a) '"+Mv_Par07+"' (e) Hora (menor ou igual a) '"+Mv_Par08 + "' "
			cFilIn := AllTrim(cFilIn)
		Endif
		
	Case cPerg == "GTMOOU"
		Pergunte("GTMOOU",.F.)
		cFilAux := ""
		cFilAux += "Pedido (maior ou igual a) '"+IIF(Empty(Mv_Par01),Mv_Par01,AllTrim(Mv_Par01))+"' (e) Pedido (menor ou igual a) '"+IIF(Empty(Mv_Par02),Mv_Par02,AllTrim(Mv_Par02)) + "' "
		cFilAux += " (e) "
		cFilAux += "Data (maior ou igual a) '"+DtoS(Mv_Par03)+"' (e) Data (menor ou igual a) '"+DtoS(Mv_Par04) + "' "
		cFilAux += " (e) "
		cFilAux += "Tipo (em) ('" + StrTran(AllTrim(Mv_Par05),",","','") + "') "
		If !Empty(Mv_Par06)
			cFilAux += " (e) "
			cFilAux += "Usuario (igual a) '"+AllTrim(Mv_Par06)+"' "
		Endif
		cFilAux += " (e) "
		cFilAux += "Hora (maior ou igual a) '"+Mv_Par07+"' (e) Hora (menor ou igual a) '"+Mv_Par08 + "' "
		
		If AllTrim(cFilAux) <> AllTrim(cFilOut) .OR. lForca
			Pergunte("GTMOOU",lPerg)
			cFilOut := ""
			cFilOut += "Pedido (maior ou igual a) '"+IIF(Empty(Mv_Par01),Mv_Par01,AllTrim(Mv_Par01))+"' (e) Pedido (menor ou igual a) '"+IIF(Empty(Mv_Par02),Mv_Par02,AllTrim(Mv_Par02)) + "' "
			cFilOut += " (e) "
			cFilOut += "Data (maior ou igual a) '"+DtoS(Mv_Par03)+"' (e) Data (menor ou igual a) '"+DtoS(Mv_Par04) + "' "
			cFilOut += " (e) "
			cFilOut += "Tipo (em) ('" + StrTran(AllTrim(Mv_Par05),",","','") + "') "
			If !Empty(Mv_Par06)
				cFilOut += " (e) "
				cFilOut += "Usuario (igual a) '"+AllTrim(Mv_Par06)+"' "
			Endif
			cFilOut += " (e) "
			cFilOut += "Hora (maior ou igual a) '"+Mv_Par07+"' (e) Hora (menor ou igual a) '" + Mv_Par08 + "' "
			cFilOut := AllTrim(cFilOut)
		Endif
		
Endcase

oFiltro:Refresh()

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGTMONITOR บAutor  ณMicrosiga           บ Data ณ  04/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ordem(cPerg,lPerg,oOrdem,lForca)

Local aOrder	:= {}
Local nI		:= 0
Local cOrdAux	:= ""

Default lForca	:= .F.

Do Case
	Case cPerg == "GTORIN"
		Pergunte(cPerg,.F.)
		Aadd( aOrder, { Mv_Par01, 'Pedido' } )
		Aadd( aOrder, { Mv_Par02, 'Data' } )
		Aadd( aOrder, { Mv_Par03, 'Hora' } )
		Aadd( aOrder, { Mv_Par04, 'Tipo' } )
		Asort( aOrder,,, { |x,y| x[1]<y[1] } )
		cOrdAux := ""
		For nI := 1 To Len(aOrder)
			If !Empty(aOrder[nI][1]) .AND. aOrder[nI][1] <> "0"
				cOrdAux += aOrder[nI][2] + ", "
			Endif
		Next nI
		cOrdAux := PadR(cOrdAux,Len(cOrdAux)-2)
		If !Empty(cOrdAux)
			If Mv_Par05 == 1
				cOrdAux += " Crescente"
			Else
				cOrdAux += " Decrescente"
			Endif
		Endif

		If AllTrim(cOrdIn) <> AllTrim(cOrdAux) .OR. lForca
			Pergunte(cPerg,lPerg)
			aOrder := {}
			Aadd( aOrder, { Mv_Par01, 'Pedido' } )
			Aadd( aOrder, { Mv_Par02, 'Data' } )
			Aadd( aOrder, { Mv_Par03, 'Hora' } )
			Aadd( aOrder, { Mv_Par04, 'Tipo' } )
			Asort( aOrder,,, { |x,y| x[1]<y[1] } )
			cOrdIn := ""
			For nI := 1 To Len(aOrder)
				If !Empty(aOrder[nI][1]) .AND. aOrder[nI][1] <> "0"
					cOrdIn += aOrder[nI][2] + ", "
				Endif
			Next nI
			cOrdIn := PadR(cOrdIn,Len(cOrdIn)-2)
			If !Empty(cOrdIn)
				If Mv_Par05 == 1
					cOrdIn += " Crescente"
				Else
					cOrdIn += " Decrescente"
				Endif
			Endif
			cOrdIn := PadR(cOrdIn,250)
		Endif
		
	Case cPerg == "GTOROU"
		Pergunte(cPerg,.F.)
		Aadd( aOrder, { Mv_Par01, 'Pedido' } )
		Aadd( aOrder, { Mv_Par02, 'Data' } )
		Aadd( aOrder, { Mv_Par03, 'Hora' } )
		Aadd( aOrder, { Mv_Par04, 'Tipo' } )
		Asort( aOrder,,, { |x,y| x[1]<y[1] } )
		cOrdAux := ""
		For nI := 1 To Len(aOrder)
			If !Empty(aOrder[nI][1]) .AND. aOrder[nI][1] <> "0"
				cOrdAux += aOrder[nI][2] + ", "
			Endif
		Next nI
		cOrdAux := PadR(cOrdAux,Len(cOrdAux)-2)
		If !Empty(cOrdAux)
			If Mv_Par05 == 1
				cOrdAux += " Crescente"
			Else
				cOrdAux += " Decrescente"
			Endif
		Endif

		If AllTrim(cOrdOut) <> AllTrim(cOrdAux) .OR. lForca
			Pergunte(cPerg,lPerg)
			aOrder := {}
			Aadd( aOrder, { Mv_Par01, 'Pedido' } )
			Aadd( aOrder, { Mv_Par02, 'Data' } )
			Aadd( aOrder, { Mv_Par03, 'Hora' } )
			Aadd( aOrder, { Mv_Par04, 'Tipo' } )
			Asort( aOrder,,, { |x,y| x[1]<y[1] } )
			cOrdOut := ""
			For nI := 1 To Len(aOrder)
				If !Empty(aOrder[nI][1]) .AND. aOrder[nI][1] <> "0"
					cOrdOut += aOrder[nI][2] + ", "
				Endif
			Next nI
			cOrdOut := PadR(cOrdOut,Len(cOrdOut)-2)
			If !Empty(cOrdOut)
				If Mv_Par05 == 1
					cOrdOut += " Crescente"
				Else
					cOrdOut += " Decrescente"
				Endif
			Endif
			cOrdOut := PadR(cOrdOut,250)
		Endif
		
Endcase

oOrdem:Refresh()

Return(.T.)
