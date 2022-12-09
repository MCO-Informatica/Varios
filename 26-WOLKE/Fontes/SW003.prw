#Include 'Protheus.ch'

STATIC cCampo_01 := space(len(SC5->C5_VEND1))

/*
Programa: SW003
Autor: André Lanzieri
Data:10/09/2013
Descrição: Consulta padrao customizada valores incentivo
*/

User Function SW003()
	Local cConta := ""//M->C5_INCEN
	Local lMostra := IIF(ALTERA .OR. INCLUI,.T.,.F.)
	Local nRet := 2
	Local _cAlias
	Private aHeaderGrd := {}
	Private aColsGrd := {}
	Private aAlter  	:= {"REP","CLI","REC","RET"}
	Private cCadastro := "Valores Incentivo"
	Private oLayer
	Private oGetGrade
	
	IF FunName() == "MATA410"
		_cAlias := "C5"
	ELSE
		_cAlias := "CJ"
	endif
	
	cConta := &("M->"+_cAlias+"_INCEN")
	Aadd(aHeaderGrd,{"Representante" ,'REP'	,PESQPICT("SA3","A3_COD"),TamSX3('A3_COD' )[1] 		,0,'(EMPTY(&(ReadVar())) .OR. ExistCpo("SA3",&(ReadVar()))) .AND. u_VLDCAMPO("SA3")','û','C','SA3','' } )
	Aadd(aHeaderGrd,{"Cliente" 		 ,'CLI'	,PESQPICT("SA1","A1_COD"),TamSX3('A1_COD' )[1] 		,0,'(EMPTY(&(ReadVar())) .OR. ExistCpo("SA1",&(ReadVar()))) .AND. U_VLDCAMPO("SA1")','û','C','SA1','' } )
	Aadd(aHeaderGrd,{"Valor Retorno" ,'RET'	,PESQPICT("SC5","C5_RET1"),TamSX3('C5_RET1' )[1]	,0,,'û','N','','' } )
	Aadd(aHeaderGrd,{"Valor Recompra",'REC'	,PESQPICT("SC5","C5_REC1"),TamSX3('C5_REC1' )[1]    ,0,,'û','N','','' } )
	
	//	             REPRESENTANTE			,CLIENTE				 ,RETORNO				  , RECOMPRA
	Aadd(aColsGrd,{&("M->"+_cAlias+"_REP")	,&("M->"+_cAlias+"_CLI") ,&("M->"+_cAlias+"_RET1"),&("M->"+_cAlias+"_REC1"),.F.} )
	Aadd(aColsGrd,{&("M->"+_cAlias+"_REP2") ,&("M->"+_cAlias+"_CLI2"),&("M->"+_cAlias+"_RET2"),&("M->"+_cAlias+"_REC2"),.F.} )
	Aadd(aColsGrd,{&("M->"+_cAlias+"_REP3")	,&("M->"+_cAlias+"_CLI3"),&("M->"+_cAlias+"_RET3"),&("M->"+_cAlias+"_REC3"),.F.} )
	Aadd(aColsGrd,{&("M->"+_cAlias+"_REP4")	,&("M->"+_cAlias+"_CLI4"),&("M->"+_cAlias+"_RET4"),&("M->"+_cAlias+"_REC4"),.F.} )
	
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 250,500 OF oMainWnd PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estancia Objeto FWLayer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer := FWLayer():new()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o objeto com a janela que ele pertencera. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:init(oDlg,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Linha do Layer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oLayer:addLine('Lin01',100,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria a coluna do Layer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addCollumn('Col01',100,.F.,'Lin01')
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona Janelas as suas respectivas Colunas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addWindow('Col01','L1_Win01','Valores Incentivos',85,.F.,.F.,,'Lin01',)
	
	oGetGrade:=MsNewGetDados():New(1,1,1,1,IIF(lMostra,GD_UPDATE,0),,/*"T_MA06TudOk"*/,"MAREF",aAlter,,3,,,,oLayer:getWinPanel('Col01','L1_Win01','Lin01'),@aHeaderGrd,@aColsGrd)
	oGetGrade:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| nRet := 1, oDlg:End()},{|| nRet:= 2 ,oDlg:End() },,) CENTERED
	
	IF nRet == 1
		&("M->"+_cAlias+"_REP")  := oGetGrade:aCols[1][1]
		&("M->"+_cAlias+"_CLI")  := oGetGrade:aCols[1][2]
		&("M->"+_cAlias+"_RET1") := oGetGrade:aCols[1][3]
		&("M->"+_cAlias+"_REC1") := oGetGrade:aCols[1][4]
		
		
		&("M->"+_cAlias+"_REP2") := oGetGrade:aCols[2][1]
		&("M->"+_cAlias+"_CLI2") := oGetGrade:aCols[2][2]
		&("M->"+_cAlias+"_RET2") := oGetGrade:aCols[2][3]
		&("M->"+_cAlias+"_REC2") := oGetGrade:aCols[2][4]
		
		&("M->"+_cAlias+"_REP3") := oGetGrade:aCols[3][1]
		&("M->"+_cAlias+"_CLI3") := oGetGrade:aCols[3][2]
		&("M->"+_cAlias+"_RET3") := oGetGrade:aCols[3][3]
		&("M->"+_cAlias+"_REC3") := oGetGrade:aCols[3][4]
		
		&("M->"+_cAlias+"_REP4") := oGetGrade:aCols[4][1]
		&("M->"+_cAlias+"_CLI4") := oGetGrade:aCols[4][2]
		&("M->"+_cAlias+"_RET4") := oGetGrade:aCols[4][3]
		&("M->"+_cAlias+"_REC4") := oGetGrade:aCols[4][4]
		
		cConta := oGetGrade:aCols[1][3]+oGetGrade:aCols[1][4]+oGetGrade:aCols[2][3]+oGetGrade:aCols[2][4]+oGetGrade:aCols[3][3]+oGetGrade:aCols[3][4]
	endif
	
	cCampo_01 := cConta
	
Return(.T.)

User Function retSW003()
return(cCampo_01)

User Function VLDCAMPO(cTabela)
	Local lRet := .T.
	
	IF cTabela == "SA1"
		IF !EMPTY(oGetGrade:aCols[oGetGrade:nAt][1])
			MSGINFO("Representante já preenchido")
			lRet := .F.
		endif
	elseIF !EMPTY(oGetGrade:aCols[oGetGrade:nAt][2])
		MSGINFO("Cliente já preenchido")
		lRet := .F.
	endif
	
return(lRet)
