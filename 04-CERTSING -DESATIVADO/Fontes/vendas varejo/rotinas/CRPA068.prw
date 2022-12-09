#Include 'Protheus.ch' 
#Include 'Parmtype.ch' 
#Include "ApWizard.ch" 
 
#DEFINE CRLF Chr(13)+Chr(10) 
 
//Static cCodFun := Space(9) 
 
//+-------------+---------+-------+-----------------------+------+-------------+ 
//|Programa:    |CRPA068  |Autor: |                       |Data: |12/04/2019   | 
//|-------------+---------+-------+-----------------------+------+-------------| 
//|Descricao:   |Rotina de AdministraÁ„o de TÌtulos ProvisÛrios referentes aos | 
//|             |adiantamentos de comiss„o realizados aos parceiros.           | 
//|-------------+--------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                            | 
//+-------------+--------------------------------------------------------------+ 
User Function CRPA068() 
 
	//Local aParam := {} 
	Local cMVPerRem := GetMv("MV_REMMES") 
	//Local cMesRemu := Substr(cMVPerRem,5,2) 
	//Local cAnoRemu := Substr(cMVPerRem,1,4) 
	//Local nLastRem := Val(cMesRemu) - 2 
	 
	Private aCanal    := {} 
	Private cCadastro := 'AdministraÁ„o de TÌtulos ProvisÛrios' 
	Private nHdlLog	  := 0 
	Private cPerRemu  := "" 
	Private cFullLog 
	Private aGridPar  := {} 
	Private oTree 
	Private dDataVenc := CTOD("05/"+StrZero(Month(dDataBase),2)+"/"+cValToChar(Year(dDataBase))) 
	 
	MV_PAR01 := "2" 
 
	//Captura o ⁄ltimo periodo fechado para calcular a antecipacao  
	//Se Fevereiro, o valor ù zero, se Janeiro, -1. 
	//Em Janeiro, considera Novembro do ano anterior como ultimo calculo valido 
	/*If nLastRem == -1 
		cPerRemu := cValToChar(Val(Substr(cMVPerRem,1,4)) - 1) + "12" 
	Else 
		cPerRemu := Substr(cMVPerRem,1,4) + StrZero(Val(Substr(cMVPerRem,5,2)) - 1, 2) 
	EndIf*/ 
	cPerRemu := cMVPerRem 
		 
//	AAdd(aParam, {1, 'Entidade De', Space(TamSX3("Z3_CODENT")[1]),'@!',"ExistCpo('SZ3')",'SZ3','',50,.F.} ) 
//	AAdd(aParam, {1, 'Entidade Atù', Space(TamSX3("Z3_CODENT")[1]),'@!',"ExistCpo('SZ3')",'SZ3','',50,.F.} ) 
	 
	//If ParamBox( aParam,'Informe o canal de vendas',@aCanal,,,,,,,,.F.,.F.) 
		CRP068PROC() 
	//EndIf 
	 
Return 
 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |FTC068PROC |Autor: |David Alves dos Santos |Data: |15/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Processamento da rotina.                                        | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
Static Function CRP068PROC() 
	 
	//Local cFiltro    := FTC068FILT() 
	Local cTitulo    := ' - RelaÁ„o de TÌtulos ProvisÛrios a serem efetivados.' 
	 
	Local aC         := {} 
	Local aBtn       := {} 
	Local aAcoes     := {} 
	Local aTam_Tit   := {} 
	 
	Local nI         := 0 
	 
	Local oDlg 
	Local oWin1 
	Local oWin2 
	Local oFWLayer 
	Local oSplitter 
	Local oPnl1 
	Local bMarkAll   	:= { || }
	Local bClearAll  	:= { || }
	Local bMarkAllSaldo := { || }
	Local bGeraPA		:= { || }
	Local bDeletaPR		:= { || }
		 
	Private aTitulos := {} 
	Private nColAux  := 0 
	Private oLbx1 
	Private oMrk     	:= LoadBitmap(,'NGCHECKOK.PNG') 
	Private oNoMrk   	:= LoadBitmap(,'NGCHECKNO.PNG') 
	Private oOK		 	:= LoadBitmap(GetResources(),"br_verde") 
	Private oNO		 	:= LoadBitmap(GetResources(),"br_vermelho") 
	Private lMarkX   	:= .T. 
	Private aHead_Tit 	:= {} 

	bMarkAll   		:= { || FC068Mark(.T.) } 
	bClearAll  		:= { || FC068Mark(.F.) } 
	bMarkAllSaldo 	:= { || FC068Mark(.T.,.T.) } 
	bGeraPA			:= { || CP068GeraPA() } 
	bDeletaPR		:= { || CP068DelPR()} 

	aCpoCli := {'','','PC2_PERIOD','PC2_CODENT','PC2_DESENT','PC2_PREFIX','PC2_NUM','PC2_PARCEL','PC2_TIPO','PC2_PER1','PC2_PER2','PC2_PER3','PC2_SOMA','Z3_PERCENTUAL','ZZ7_VALOR'} 
	 
	//-- Captura do tamanho das colunas com base nos campos. 
	SX3->( dbSetOrder( 2 ) ) 
	For nI := 1 To Len( aCpoCli ) 
		SX3->( dbSeek( aCpoCli[ nI ] ) ) 
		SX3->( AAdd( aTam_Tit, CalcFieldSize( X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_PICTURE, X3_TITULO ) ) ) 
	Next nI 
	 
	//-- Ajustes no largura da coluna. 
	aTam_Tit[ 2 ] := aTam_Tit[ 2 ] + 10 
	 
	//-- DefiniÁ„o do titulo das colunas. 
	aHead_Tit := { 	' ', ' ',; 
				'PerÌodo Ref.',;  
				'Cod. Entidade',;  
				'Desc. Entidade',;  
				'Prefixo',;  
				'Num Titulo',; 
				'Tipo TÌtulo',; 
				'⁄ltimo PerÌodo',; 
				'Pen⁄ltimo PerÌodo',; 
				'Antepen˙tlimo PerÌodo',; 
				'Total Faturamento',; 
				'MÈdia Faturamento',; 
				'Percentual',; 
				'Valor do Adiantamento'} 
	 
	//-- DefiniÁ„o dos botùes. 
	AAdd( aAcoes ,{ 'Visualizar'      		,'{|| CP068Visu() }'} ) 
	AAdd( aAcoes ,{ 'Imprimir Tela'			,'{|| CP068VisPA(aHead_Tit, aTitulos) }'} ) 
	AAdd( aAcoes ,{ 'Imprimir Tudo'			,'{|| CP068Print() }'} ) 
	AAdd( aAcoes ,{ 'Gerar PA'		  		,'{|| Proc2BarGauge(bGeraPA,"Gerando PA","Aguarde o processamento de geraùùo dos PAs") }'  } ) 
	AAdd( aAcoes ,{ 'Marcar todos'    		,'{|| Processa(bMarkAll,"","",.F.)}'} ) 
	//AAdd( aAcoes ,{ 'Marcar todos s/ saldo'	,'{|| Iif(MsgYesNo("Somente os TÌtulos sem saldo residual serùo marcados. Deseja continuar?",cCadastro),Processa(bMarkAllSaldo,"","",.F.),NIL) }' } )	 
	AAdd( aAcoes ,{ 'Desmarcar todos' 		,'{|| Iif(MsgYesNo("Desmarcar todos os TÌtulos marcados?",cCadastro),Processa(bClearAll,"","",.F.),NIL) }' } ) 
	AAdd( aAcoes ,{ 'Excluir Selecionados'	,'{|| Iif(MsgYesNo("Deseja realmente excluir todos os TÌtulos selecionados?",cCadastro),Proc2BarGauge(bDeletaPR,"Excluindo Titulos","Aguarde o processamento de exclusùo dos TÌtulos selecionados"),NIL) }' } ) 
	AAdd( aAcoes ,{ 'Imprimir PA Gerados	'	,'{|| PrintAllPA() }' } ) 
	AAdd( aAcoes ,{ 'Sair'            		,'{|| oDlg:End() }' } ) 
	 
	 
	//-- DefiniÁ„o das aùùes da teclas de atalho. 
	/*SetKey( VK_F5  ,&(aAcoes[1,2]) ) 
	SetKey( VK_F6  ,&(aAcoes[2,2]) ) 
	SetKey( VK_F7  ,&(aAcoes[3,2]) ) 
	SetKey( VK_F8  ,&(aAcoes[4,2]) ) 
	SetKey( VK_F9  ,&(aAcoes[5,2]) ) 
	SetKey( VK_F10 ,&(aAcoes[6,2]) ) 
	SetKey( VK_F11 ,&(aAcoes[7,2]) )*/ 
	 
	SetKey( VK_F11 ,{|| CRPA068DT() } ) 
	SetKey( VK_F12 ,{|| C068Param() } ) 
	 
	// [1] - propriedade do objeto 
	// [2] - TÌtulo do botùo 
	// [3] - funùùo a ser executada quando acionado o botùo 
	// [4] - texto explicativo da funcionalidade da rotina 
	AAdd( aBtn ,{ NIL ,aAcoes[1,1] ,aAcoes[1,2] ,'<F5> Visualizar.'                    						} ) 
	AAdd( aBtn ,{ NIL ,aAcoes[2,1] ,aAcoes[2,2] ,'<  > Imprimir RelaÁ„o de TÌtulos.'   						} ) 
	AAdd( aBtn ,{ NIL ,aAcoes[3,1] ,aAcoes[3,2] ,'<  > Imprimir RelaÁ„o de TÌtulos.'   						} )	 
	AAdd( aBtn ,{ NIL ,aAcoes[4,1] ,aAcoes[4,2] ,'<F6> Gerar TÌtulo PA.'               						} ) 
	AAdd( aBtn ,{ NIL ,aAcoes[5,1] ,aAcoes[5,2] ,'<F7> Marcar todos os registros.'							} ) 
	AAdd( aBtn ,{ NIL ,aAcoes[6,1] ,aAcoes[6,2] ,'<F8> Marcar todos os registros.'     						} ) 
	AAdd( aBtn ,{ NIL ,aAcoes[7,1] ,aAcoes[7,2] ,'<  > Excluir registros selecionados.'						} ) 
	AAdd( aBtn ,{ NIL ,aAcoes[8,1] ,aAcoes[8,2] ,'<F10> Legenda.'											} ) 
	AAdd( aBtn ,{ NIL ,aAcoes[9,1] ,aAcoes[9,2] ,'<F12> Sair da rotina.'									} ) 
	 
	aC := FWGetDialogSize( oMainWnd ) 
	 
	DEFINE DIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP) 
		 
		oDlg:lEscClose := .F. 
		oFWLayer := FWLayer():New() 
		 
		oFWLayer:Init( oDlg, .F. ) 
		 
		oFWLayer:AddCollumn( 'Col01', 20, .T. ) 
		oFWLayer:AddCollumn( 'Col02', 80, .F. ) 
		 
		oFWLayer:SetColSplit( 'Col01', CONTROL_ALIGN_RIGHT,, {|| .T. } ) 
		 
		oFWLayer:AddWindow('Col01','Win01','Aùùes'             ,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/) 
		oFWLayer:AddWindow('Col02','Win02',cCadastro + cTitulo ,100,.F.,.T.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/) 
		 
		oWin1 := oFWLayer:GetWinPanel('Col01','Win01') 
		oWin2 := oFWLayer:GetWinPanel('Col02','Win02') 
		 
		oSplitter := TSplitter():New( 1, 1, oWin2, 1000, 1000, 1 )  
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT 
		 
		oPnl1:= TPanel():New(1,1,' Painel 01',oSplitter,,,,,/*CLR_YELLOW*/,60,60) 
		 
		oPnl1:Align := CONTROL_ALIGN_ALLCLIENT 
		 
		oPnl2:= TPanel():New(1,1,' Painel 02',oWin1,,,,,/*CLR_YELLOW*/,60,100) 
		 
		oPnl2:Align := CONTROL_ALIGN_BOTTOM			 
 
		oPnl3:= TPanel():New(1,1,' Painel 03',oWin1,,,,,/*CLR_YELLOW*/,60,150) 
		 
		oPnl3:Align := CONTROL_ALIGN_TOP		 
				 
		oTree := DBTree():New(1,1,150,125,oPnl3, ,, .T., .F., , ) 
		oTree:Align := CONTROL_ALIGN_TOP 
		oTree:lShowHint := .F. 
		oTree:bLClicked := {|| Iif(oTree:getCargo()!="Rede",MsgRun("Executando consulta dos dados. Por gentileza, aguarde.","TÌtulos ProvisÛrios",{||CR068Array(oTree)}),Nil)} //M926ShHi(oTree,aPaineis,aPnTree,aPnlNF)} 
		 
		CR59LoadTree(@oTree) 
			 
		For nI := 1 To Len(aBtn) 
			aBtn[nI,1] := TButton():New(1,1,aBtn[nI,2],oPnl2,&(aBtn[nI,3]),50,11,,,.F.,.T.,.F.,aBtn[nI,4],.F.,,,.F.) 
			aBtn[nI,1]:Align := CONTROL_ALIGN_TOP 
		Next nI 
			 
	   //-- Controle visual do cliente. 
	   oLbx1              := TwBrowse():New(1,1,1000,1000,,aHead_Tit,,oPnl1,,,,,,,,,,,,.F.,,.T.,,.F.,,,) 
	   oLbx1:aColSizes    := aTam_Tit 
	   oLbx1:Align        := CONTROL_ALIGN_ALLCLIENT 
	   oLbx1:bLDblClick   := {|| C068MrkTit() } 
	   oLbx1:bHeaderClick := {|oBrw, nCol| C068HdrClc(nCol) } 
	 
	   //-- Chama funùùo para montar o array de clientes. 
	   MsgRun("Executando consulta dos dados. Por gentileza, aguarde.","TÌtulos ProvisÛrios",{||CR068Array(oTree)}) 
	   oLbx1:Refresh() 
	   oLbx1:SetFocus() 
	    
	ACTIVATE DIALOG oDlg CENTERED 
 
Return 
 
Static Function C068Param() 
 
Local aParams 	:= {} 
 
	aAdd(aParams, {2, 'Utiliza Filtros?', "1-Sim",{"1-Sim","2-Nùo","3-Somente PerÌodo"},50,,.T.} ) 
	 
	//If ParamBox( aParam,'Informe o canal de vendas',@aCanal,,,,,,,,.F.,.F.) 
 
	If Parambox(aParams, "", @aGridPar,,,,,,,,.F.,.F.) 
		MV_PAR01 := Substr(aGridPar[1],1,1) 
	 
		MsgRun("Executando consulta dos dados. Por gentileza, aguarde.","TÌtulos ProvisÛrios",{||CR068Array(oTree)}) 
		 
	EndIf 
  
Return 
 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |C068HdrClc |Autor: |David Alves dos Santos |Data: |15/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Rotina para ordenar colunas.                                    | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
Static Function C068HdrClc(nCol) 
	 
	Local bMarkAll   := { || FC068Mark(.T.) } 
	Local bClearAll  := { || FC068Mark(.F.) } 
	 
	If nCol == 2 
		If lMarkX 
			Processa(bMarkAll,"","",.F.) 
			lMarkX := .F. 
		Else 
			Processa(bClearAll,"","",.F.) 
			lMarkX := .T. 
		EndIf 
	Else 
		//-- Define quais colunas poderùo ser ordenadas. 
		If nCol == 3 .Or. nCol == 5 .Or. nCol == 6 .Or. nCol == 7 .Or. nCol == 8  
			If nCol == nColAux 
				//-- Ordem Descendente. 
				ASort(aTitulos,,, { | x,y | x[nCol] < y[nCol] } ) 
				oLbx1:Refresh() 
				nColAux := 0 
			Else 
				//-- Ordem Acendente. 
				ASort(aTitulos,,, { | x,y | x[nCol] > y[nCol] } ) 
				oLbx1:Refresh() 
				nColAux := nCol 
			EndIf 
		Else 
			MsgAlert("Nùo ù possivel ordenar esta coluna.", cCadastro) 
		EndIf 
	EndIf 
Return 
 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |FC068Visu  |Autor: |David Alves dos Santos |Data: |22/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Funùùo para realizar a visualizaùùo dos registros.              | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
Static Function CP068Visu() 
	 
	If !Empty(aTitulos[1,7]) 
		dbSelectArea("SE2") 
		dbSetOrder(1) 
		//-- Apresenta a visulizaùùo do registro se encontrar na tabela SE2. 
		SE2->(dbGoTo(aTitulos[oLbx1:nAt,13])) 
		//If SE2->(MsSeek(xFilial("SE2")+aTitulos[oLbx1:nAt,6] + aTitulos[oLbx1:nAt,7] + aTitulos[oLbx1:nAt,8 + aTitulos[oLbx1:nAt,9]])) 
			//-- Utiliza a funùùo AxVisual para visualizaùùo do registro. 
			AxVisual("SE2",oLbx1:AARRAY[oLbx1:nAt,13],2) 
		//EndIf 
	EndIf 
	 
Return 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |CP068GeraPA|Autor: |David Alves dos Santos |Data: |18/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Funùùo para realizar atualizaùùes de cadastro.                  | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
 
Static Function CP068GeraPA() 
 
	Local aSelTit	:= {} 
	Local aTitSubs	:= {} 
	Local aRecnoZZ7 := {} 
	Local aRecnoPC2 := {} 
	Local aRecnoSE2 := {} 
	Local nCounter	:= 0 
	Local cOldMV	:= "" 
	//Local aDadosSZ3 := {} 
	Local aTitPA	:= {} 
	Local nTotalPA	:= 0 
	Local aHeadLog	:= {"Cod. AR","Nome AR","Prefixo Titulo", "Numero Titulo","Parcela", "Tipo", "Fornecedor", "Loja", "Valor Titulo", "Dt Emissao", "Dt Vencto"} 
	Local cBcoPA	:= GetMV("MV_XBCOADT") 
	Local cAgencPA	:= GetMV("MV_XAGEADT") 
	Local cCtaPA	:= GetMV("MV_XCTAADT") 
	Local cParcela	:= Space(TamSX3("E2_PARCELA")[1]) 
	//Local nDiaVenc	:= GetMV("MV_XREMDTV") 
	//Local cMesVenc	:= StrZero(Month(dDataBase),2) 
	Local Ni, Ne 
	 
	Private lMsErroAuto	:= .F. 
	 
	/*If cMesVenc == Substr(cPerRemu,5,2) 
		dDataVenc := CTOD("05/" + StrZero(Month(dDataBase) + 1,2) + "/" + cValToChar(Year(dDataBase))) 
	EndIf*/ 
	 
	LogInit() 
	LogWrite(Time() + " | Iniciando Substituiùùo de TÌtulos pelo usuùrio " + cUserName) 
	LogWrite(Replicate("-",95)) 
	 
	ProcRegua(Len(aTitulos)) 
	 
	For Ni := 1 To Len(aTitulos) 
	 
		IncProcG1("Processando registro " + cValToChar(Ni) + "/" + cValToChar(Len(aTitulos))) 
		ProcessMessage() 
		 
		If aTitulos[Ni][2] 
		 
			dbSelectArea("SZ3") 
			SZ3->(dbSetOrder(1)) 
			SZ3->(dbSeek(xFilial("SZ3") + aTitulos[Ni][4])) 
			 
			dbSelectArea("SA2") 
			SA2->(dbSetOrder(1)) 
		 
			dbSelectArea("SE2") 
			If SE2->(dbSeek(xFilial("SE2")+aTitulos[Ni][6]+aTitulos[Ni][7]+cParcela+aTitulos[Ni][8]+SZ3->Z3_CODFOR+SZ3->Z3_LOJA)) 
			 
				If SA2->(dbSeek(xFilial("SA2") + SZ3->Z3_CODFOR + SZ3->Z3_LOJA)) 
				 
					aAdd(aSelTit, {{"E2_FILIAL"  , SE2->E2_FILIAL , NIL },; //1 
							{"E2_PREFIXO" , SE2->E2_PREFIXO, NIL },;		//2 
							{"E2_NUM"     , SE2->E2_NUM    , NIL },;		//3 
							{"E2_PARCELA" , SE2->E2_PARCELA, NIL },;		//4 
							{"E2_TIPO"    , SE2->E2_TIPO   , NIL },;		//5 
							{"E2_NATUREZ" , SE2->E2_NATUREZ, NIL },;		//6 
							{"E2_FORNECE" , SE2->E2_FORNECE, NIL },;		//7 
							{"E2_LOJA"    , SE2->E2_LOJA   , NIL },;		//8 
							{"E2_EMISSAO" , SE2->E2_EMISSAO, NIL },;		//9 
							{"E2_VENCTO"  , SE2->E2_VENCTO , NIL },;		//10 
							{"E2_VALOR"   , SE2->E2_VALOR  , NIL },;		//11 
							{"E2_HIST"    , SE2->E2_HIST   , NIL },; 
							{"E2_MOEDA"   , SE2->E2_MOEDA  , NIL },; 
							{"E2_VENCREA" , SE2->E2_VENCREA, NIL },; 
							{"AUTBANCO"	  , cBcoPA		   , NIL },; 
							{"AUTAGENCIA" , cAgencPA	   , NIL },; 
							{"AUTCONTA"	  , cCtaPA		   , NIL }}) 
							 
					aAdd(aRecnoZZ7, aTitulos[Ni][17]) 
					aAdd(aRecnoPC2, aTitulos[Ni][16]) 
					aAdd(aRecnoSE2, aTitulos[Ni][18]) 
				Else 
					MsgStop("Fornecedor " + SZ3->Z3_CODFOR + "/" + SZ3->Z3_LOJA + " nùo encontrado.") 
				EndIf 
			EndIf 
		EndIf 
	Next 
		 
	If Len(aSelTit) > 0 
	 
		aTitSubs := aClone(aSelTit) 
		 
		For Ni := 1 To Len(aTitSubs) 
			aTitSubs[Ni][aScan(aTitSubs[Ni],{|x| x[1] == "E2_TIPO"})][2] 	:= "PA" 
			aTitSubs[Ni][aScan(aTitSubs[Ni],{|x| x[1] == "E2_EMISSAO"})][2] := dDataVenc				//dDataBase + nDiaVenc	 
			aTitSubs[Ni][aScan(aTitSubs[Ni],{|x| x[1] == "E2_VENCTO"})][2] 	:= dDataVenc				//dDataBase + nDiaVenc 
			aTitSubs[Ni][aScan(aTitSubs[Ni],{|x| x[1] == "E2_VENCREA"})][2] := DataValida(dDataVenc)	//DataValida(dDataBase + nDiaVenc)   
		Next 
		 
		cOldMv := MV_PAR01 
		 
		// Estabelecer o nome da rotina de TÌtulo a receber. 
		SetFunName('FINA050') 
		 
		// Recarregar os dados dos par‚metros da rotina. 
		Pergunte( 'FIN050', .F. ) 
		 
		If MV_PAR09 <> 1 
			If SX1->( dbSeek( PadR( 'FIN050', Len( SX1->X1_GRUPO ), ' ' ) + '09' ) ) 
				SX1->( RecLock( 'SX1', .F. ) ) 
				SX1->X1_PRESEL := 1 
				SX1->( MsUnLock() ) 
			Endif 
		Endif		 
		 
		For Ni := 1 To Len(aSelTit) 
		 
			IncprocG2("Gerando TÌtulo de Substituiùùo " + cValToChar(Ni) + "/" + cValToChar(Len(aSelTit))) 
			ProcessMessage() 
		 
			// Executar a substituiùùo dos TÌtulos. 
			//MsExecAuto( { |a,b,c,d,e| FINA050( a, b, c, d, e ) } , aTitSubs[Ni], ,6, aSelTit[Ni]) 
			MsExecAuto( { |a,b,c,d,e,f,g,h,i,j,k| FINA050( a, b, c, d, e, f, g, h, i, j, k) } ,; 
			 				aTitSubs[Ni],;					//[01] aRotAuto 
			 				6,;								//[02] nOpcion 
			 				6,;								//[03] nOpcAuto 
			 				{||  },;						//[04] bExecuta 
			 				{cBcoPA,cAgencPA,cCtaPA,"",,,.T.},;	//[05] aDadosBco 
			 				.F.,;							//[06] lExibeLcto 
			 				.F.,;							//[07] lOnline 
			 				{},;							//[08] aDadosCtb 
			 				{aSelTit[Ni]},;					//[09] aTitPrv 
			 				.T.,;							//[10] lMsBlQl 
			 				.T.)							//[11] lPaMovBco	 
			 
			// Se houver erro capturar a mensagem. 
			If lMsErroAuto 
				lRet := .F. 
				MostraErro() 
				cMsg := 'Inconsistùncia para substituir TÌtulo' + CRLF + CRLF 
				aAutoErr := GetAutoGRLog() 
				For ne := 1 To Len( aAutoErr ) 
					cMsg += aAutoErr[ ne ] + CRLF 
				Next ne 
				LogWrite(cMsg) 
				lMsErroAuto := .F. 
			Else 
				// Se nùo houver erro vincular o TÌtulo principal com as baixas dos TÌtulos ProvisÛrios. 
				//For Nx := 1 To Len(aRecnoPC2) 
					PC2->(dbGoTo(aRecnoPC2[Ni])) 
					 
					RecLock("PC2",.F.) 
						PC2->PC2_TIPO := "PA" 
					PC2->(MsUnlock()) 
				//Next 
				 
				/*For Nj := 1 To Len(aRecnoZZ7) 
					ZZ7->(dbGoTo(aRecnoZZ7[Nj])) 
					 
					RecLock("ZZ7",.F.) 
						ZZ7->ZZ7_SALDO := 0 
					ZZ7->(MsUnlock()) 
				Next*/ 
	 
				LogWrite("[Gerado PA] TÌtulo " + SE2->E2_PREFIXO + SE2->E2_NUM +; 
				 	". Fornecedor: " + SE2->E2_FORNECE + "/" + SE2->E2_LOJA + ". Valor R$ " + AllTrim(Transform(SE2->E2_VALOR,"@E 999,999,999.99"))) 
				LogWrite(Replicate("-",95)) 
				nCounter++ 
				 
				SZ3->(dbSetOrder(1)) 
				SZ3->(dbSeek(xFilial("SZ3") + PC2->PC2_CODENT + "9")) 
				 
				SE2->(dbSeek(xFilial("SE2") + aSelTit[Ni][2][2] + aSelTit[Ni][3][2] + aSelTit[Ni][4][2] + "PA " + aSelTit[Ni][7][2] + aSelTit[Ni][8][2])) 
				 
				aAdd(aTitPA,{SZ3->Z3_CODENT,SZ3->Z3_DESENT,SE2->E2_PREFIXO, SE2->E2_NUM,; 
				 				SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_LOJA, AllTrim(Transform(SE2->E2_VALOR,"@E 999,999,999.99")), DTOC(SE2->E2_EMISSAO), DTOC(SE2->E2_VENCTO)}) 
				 
				nTotalPA += SE2->E2_VALOR 
				 
			Endif 
			 
		Next 
		 
		aAdd(aTitPA,{"TOTAL", "", "", "", "", "", "", "", AllTrim(Transform(nTotalPA,"@E 999,999,999.99")), "", ""}) 
		 
		MV_PAR01 := cOldMV 
		 
		// Estabelecer o nome da rotina de TÌtulo a receber. 
		SetFunName('CRPA068') 
		 
		MsgRun("Aguarde","Exportando registros para o Excel",{|| DlgToExcel({ {"ARRAY","TÌtulos Substituùdos para PA", aHeadLog, aTitPA} })}) 
		 
		LogWrite("Foram substituùdos " + cValToChar(nCounter) + " TÌtulos com sucesso.") 
		LogEnd() 
		MostraLog() 
		 
		MsgRun("Executando atualizaùùo dos dados. Por gentileza, aguarde.","TÌtulos ProvisÛrios",{||CR068Array(oTree)}) 
		oLbx1:Refresh() 
		oLbx1:SetFocus() 
		 
	EndIf 
 
Return 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |FC068Mark  |Autor: |David Alves dos Santos |Data: |15/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Funùùo para marcar ou desmarcar todos os registros.             | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
Static Function FC068Mark(lMark,lNoSaldo) 
 
	Local nI   := 0 
	Local nSum := 0 
	 
	DEFAULT lNoSaldo := .F. //Apenas TÌtulos sem saldo residual 
	 
	nSum := Len( aTitulos ) 
	ProcRegua( nSum ) 
	 
	If !lNoSaldo 
		//-- Varre o aTitulos para atualizar o Mark. 
		For nI := 1 To Len( aTitulos ) 
			IncProc() 
			If lMark 
				aTitulos[ nI, 2 ] := .T.	//-- Marca 
			Else 
				aTitulos[ nI, 2 ] := .F.	//-- Desmarca 
			EndIf 
		Next nI 
	Else 
			//-- Varre o aTitulos para atualizar o Mark. 
		For nI := 1 To Len( aTitulos ) 
			IncProc() 
			If lMark .And. aTitulos[Ni][1] 
				aTitulos[ nI, 2 ] := .T.	//-- Marca 
			Else 
				aTitulos[ nI, 2 ] := .F.	//-- Desmarca 
			EndIf 
		Next nI 
	 
	EndIf  
	 
	oLbx1:Refresh() 
 
Return 
 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |C068MrkTit |Autor: |David Alves dos Santos |Data: |15/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Marcaùùo de registro.                                           | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
Static Function C068MrkTit() 
	 
	Local lMark := aTitulos[ oLbx1:nAt, 2 ] 
	 
	/*If !aTitulos[oLbx1:nAt, 1] 
		If !MsgYesNo("O TÌtulo selecionado jù possui saldo em aberto de meses passados. Deseja realmente gerar um PA para esta Entidade?", "Geraùùo de PA") 
			aTitulos[ oLbx1:nAt, 2 ] := .F.	//-- Desmarca 
			Return 
		EndIf 
	EndIf*/ 
	 
	//-- Realiza a marcaùùo apenas se tiver registro na tela. 
	If !Empty(aTitulos[1,3]) 
		If lMark 
			aTitulos[ oLbx1:nAt, 2 ] := .F.	//-- Desmarca 
		Else 
			aTitulos[ oLbx1:nAt, 2 ] := .T.	//-- Marca 
		EndIf 
	 
		oLbx1:Refresh() 
	EndIf 
	 
Return 
 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |FC068Array |Autor: |David Alves dos Santos |Data: |15/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Montagem do array de clientes.                                  | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
Static Function CR068Array(oTree) 
	 
	//Local nI       := 0 
	//Local nP       := 0 
	//Local nElem    := 0 
	//Local cCnaeAmi := "" 
	//Local cCnaeDsc := "" 
	Local cQuery   := "" 
	Local cTmp     := GetNextAlias() 
	//Local lSaldo   := .F. 
	Local nCnt	   := 1 
	Local cLastEnt := "" 
	//Local cCanal   := "" 
	Local cPedido  := "" 
	//Local lNoFilter:= .F. 
	 
	DEFAULT oTree := Nil 
	 
	dbSelectArea("SC7") 
	dbSelectArea("SD1") 
	dbSelectArea("CND") 
	 
	aTitulos := {} 
	 
	cQuery := "SELECT PC2_PERIOD,"  
	cQuery += "       PC2_CODENT,"  
	cQuery += "       PC2_DESENT, " 
	cQuery += "       PC2_PREFIX, " 
	cQuery += "       PC2_NUM, " 
	cQuery += "       PC2_PARCEL,"  
	cQuery += "       PC2_TIPO, " 
	cQuery += "		  PC2_PEDIDO," 
	cQuery += "		  PC2_TIPPED," 
	cQuery += "       ZZ7_VALOR, " 
	cQuery += "       E2_VALOR, " 
	cQuery += "       E2_SALDO, " 
	cQuery += "       E2_BAIXA, " 
	cQuery += "       PC2.R_E_C_N_O_ RECNOPC2," 
	cQuery += "       SE2.R_E_C_N_O_ RECNOSE2," 
	cQuery += "       ZZ7.R_E_C_N_O_ RECNOZZ7, " 
	cQuery += "       PC2.PC2_PER1 PERIODO1, " 
	cQuery += "       PC2.PC2_PER2 PERIODO2, "					 
	cQuery += "       PC2.PC2_PER3 PERIODO3, " 
	cQuery += "       PC2.PC2_SOMA SOMA, " 
	cQuery += "		  Round((PC2.PC2_SOMA / 3),2) AS MEDIA," 
	cQuery += "		  SZ3.Z3_PERADTO AS PERCENTUAL" 
	cQuery += "FROM " + RetSqlName("PC2") + " PC2 " 
	cQuery += ""	 
	cQuery += "       INNER JOIN " + RetSqlName("ZZ7") + " ZZ7 " 
	cQuery += "               ON ZZ7_FILIAL = PC2_FILIAL " 
	cQuery += "                  AND ZZ7_PRETIT = PC2_PREFIX " 
	cQuery += "                  AND ZZ7_TITULO = PC2_NUM " 
	cQuery += "                  AND ZZ7_CODPAR = PC2_CODENT " 
	cQuery += "       INNER JOIN " + RetSqlName("SE2") + " SE2 " 
	cQuery += "               ON E2_NUM = PC2_NUM " 
	cQuery += "                  AND E2_PREFIXO = PC2_PREFIX " 
	cQuery += "                  AND E2_TIPO = PC2_TIPO " 
	cQuery += "                  AND E2_FORNECE = PC2_FORNEC " 
	cQuery += "		  INNER JOIN " + RetSqlName("SZ3") + " SZ3 " 
	cQuery += "				  ON Z3_FILIAL = ' ' " 
	cQuery += "					 AND Z3_CODENT = PC2_CODENT " 
	cQuery += "WHERE  PC2_NUM > ' ' " 
	cQuery += "		  AND ZZ7_VALOR > 0 "	 
	cQuery += "       AND E2_BAIXA = ' ' " 
	cQuery += "		  AND PC2_TIPO = 'PR' " 
	cQuery += "       AND PC2.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND ZZ7.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND SE2.D_E_L_E_T_ = ' ' " 
	cQuery += "		  AND SZ3.D_E_L_E_T_ = ' ' " 
	If SZ3->(FieldPos("Z3_DESCREDE")) > 0 
		cQuery += "		AND Z3_DESCRED != 'S' " 
	EndIf 
	If oTree != Nil 
		cQuery += "		  AND PC2_CODENT IN (SELECT Z3_CODENT FROM "+RetSqlName("SZ3")+" WHERE Z3_CODAC = "+CR068ParaDe(AllTrim(oTree:GetCargo()))+" OR Z3_CODENT = '"+CR068DePara(AllTrim(oTree:GetCargo()))+"')" 
	EndIf 
	If MV_PAR01 $ "1|3" 
		cQuery += " AND PC2_PERIOD = '" + cPerRemu + "'" 
	EndIf 
	cQuery += "	ORDER BY PC2_DESENT, PC2_PERIOD" 
 
	 
	//-- Filtro retornado pela classe FWFiltewr. 
	/*If !Empty(cFiltro) 
		//+--------------------------------------------------------+ 
		//| Tratamento com o campo CC3_DESC pois existem registros | 
		//| utilizando caracteres maiusculo e minisculo.           | 
		//+--------------------------------------------------------+ 
		If "CC3_DESC" $ cFiltro 
			cFiltro := StrTran(cFiltro,'CC3_DESC', 'UPPER(CC3_DESC)') 
			cQuery  += " AND " + cFiltro 
		Else 
			cQuery  += " AND " + cFiltro 
		EndIf 
	EndIf*/ 
		 
	//-- Verifica se a tabela esta aberta. 
	If Select(cTmp) > 0 
		(cTmp)->(DbCloseArea())				 
	EndIf 
	 
	//-- Execucao da query. 
	cQuery := ChangeQuery(cQuery) 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.) 
		 
		 
	aHead_Tit := { 	' ', ' ',; 
				'PerÌodo Ref.',;  
				'Cod. Entidade',;  
				'Desc. Entidade',;  
				'Prefixo',;  
				'Num Titulo',; 
				'Tipo TÌtulo',; 
				'⁄ltimo PerÌodo',; 
				'Pen⁄ltimo PerÌodo',; 
				'Antepen˙tlimo PerÌodo',; 
				'Total Faturamento',; 
				'MÈdia Faturamento',; 
				'Percentual',; 
				'Valor do Adiantamento'} 
		 
	(cTmp)->(dbGoTop()) 
	While (cTmp)->( !Eof() ) 
						 
		//Verifica se ha mais de um registro da mesma entidade 
		If cLastEnt == (cTmp)->PC2_CODENT 
			nCnt++ 
		Else 
			nCnt := 1 
		EndIf 
		 
		If MV_PAR01 == "1" 
			//No caso das Medicoes, ù necessùrio buscar a mediùùo e na tabela CND encontrar o nùmero do Pedido 
			//Depois do nùmero do pedido, serù possùvel chegar ù Nota de Entrada e verificar se estù classificada. 
			 
			dbSelectArea("ZZ6") 
			ZZ6->(dbSetOrder(1)) 
			If ZZ6->(dbSeek(xFilial("ZZ6") + (cTmp)->PC2_PERIOD + (cTmp)->PC2_CODENT)) 
				 
				If ZZ6->ZZ6_TIPPED == "M" 
					 
					CND->(dbSetOrder(4)) 
					If !CND->(dbSeek(xFilial("CND") + ZZ6->ZZ6_PEDIDO)) 
						ZZ6->( DbSkip() ) 
						Loop //Nùo encontrou a mediùùo 
					Else 
						cPedido := CND->CND_PEDIDO 
					EndIf 
				 
				ElseIf ZZ6->ZZ6_TIPPED == "P" 
					cPedido := ZZ6->ZZ6_PEDIDO 
				ElseIf Empty(ZZ6->PC2_PEDIDO) 
					ZZ6->( dbSkip() ) 
					Loop //Pedido ou Mediùùo vazio 
				EndIf 
				 
				SC7->(dbSetOrder(1)) 
				SD1->(dbOrderNickName("PEDIDO")) 
				 
				lPedFound := SC7->(dbSeek(xFilial("SC7") + cPedido)) 
				lNFFound := SD1->(dbSeek(xFilial("SD1") + SC7->C7_NUM)) 
				lNFClass := (!Empty(SD1->D1_TES) .And. !Empty(SD1->D1_CF)) 
							 
				If !lPedFound .Or. !lNFFound .Or. !lNFClass 
					(cTmp)->(DbSkip()) 
					Loop 
				EndIf 
			EndIf 
		EndIf 
		 
		aAdd(aTitulos, { ((cTmp)->PC2_PERIOD == cPerRemu),;  //Auxiliar para controlar luz verde ou vermelha 
						 .F.,; 
						 (cTmp)->PC2_PERIOD,;										 
						 (cTmp)->PC2_CODENT,;										 
						 (cTmp)->PC2_DESENT,;										 
						 (cTmp)->PC2_PREFIX,; 
						 (cTmp)->PC2_NUM,; 
						 (cTmp)->PC2_TIPO,; 
						 Transform((cTmp)->PERIODO1, "R$ @E 999,999,999.99"),; 
						 Transform((cTmp)->PERIODO2, "R$ @E 999,999,999.99"),; 
						 Transform((cTmp)->PERIODO3, "R$ @E 999,999,999.99"),; 
						 Transform((cTmp)->SOMA, "@E 999,999,999.99"),; 
						 Transform(0, "@E 999,999,999.99"),;//Transform((cTmp)->MEDIA, "@E 999,999,999.99"),; 
						 Transform((cTmp)->PERCENTUAL, "@E 999.99%"),;						  
						 Transform((cTmp)->ZZ7_VALOR, "R$ @E 999,999,999.99"),; 
						 (cTmp)->RECNOPC2,; 
						 (cTmp)->RECNOZZ7,; 
						 (cTmp)->RECNOSE2})									 
	 
		//Salva o codigo da entidade processada 
		cLastEnt := (cTmp)->PC2_CODENT 
	 
		(cTmp)->( DbSkip() ) 
	EndDo 
	 
	//-- Se nùo encontrar nada na tabe 
	If Len(aTitulos) == 0 
		AAdd( aTitulos, {.F.,.F., "", "", "", "","","","","","","","","","",""} ) 
	EndIf 
		 
	//-- Alimenta o aTitulos para apresentar no browse. 
   	oLbx1:SetArray( aTitulos ) 
	oLbx1:bLine := { ||	{ 		Iif( aTitulos[ oLbx1:nAt, 01 ], oOK, oNO),; 
								Iif( aTitulos[ oLbx1:nAt, 02 ], oMrk, oNoMrk ),; 
								aTitulos[ oLbx1:nAt, 03 ],; 
								aTitulos[ oLbx1:nAt, 04 ],; 
								aTitulos[ oLbx1:nAt, 05 ],; 
								aTitulos[ oLbx1:nAt, 06 ],; 
								aTitulos[ oLbx1:nAt, 07 ],; 
								aTitulos[ oLbx1:nAt, 08 ],; 
								aTitulos[ oLbx1:nAt, 09 ],; 
								aTitulos[ oLbx1:nAt, 10 ],; 
								aTitulos[ oLbx1:nAt, 11 ],; 
								aTitulos[ oLbx1:nAt, 12 ],; 
								aTitulos[ oLbx1:nAt, 13 ],; 
								aTitulos[ oLbx1:nAt, 14 ],; 
								aTitulos[ oLbx1:nAt, 15 ],; 
								aTitulos[ oLbx1:nAt, 16 ],; 
						} } 
						 
	FC068Mark(.F.)  
 
Return 
 
 
//+-------------+-----------+-------+-----------------------+------+-------------+ 
//|Programa:    |FTC068FILT |Autor: |David Alves dos Santos |Data: |15/09/2017   | 
//|-------------+-----------+-------+-----------------------+------+-------------| 
//|Descricao:   |Tela de filtro personalizado.                                   | 
//|-------------+----------------------------------------------------------------| 
//|Uso:         |Certisign - Certificadora Digital.                              | 
//+-------------+----------------------------------------------------------------+ 
/*Static Function FTC068FILT() 
 
	Local oFWFilter  := Nil 
	Local aColunas   := {} 
	Local aRet       := {} 
	Local aIndexSC1	 := {} 
	Local cAuxFil    := ""  
	Local cQryFilter := "" 
	 
	Private bFiltraBrw := {|| {"","","",""}} 
	Private cMarca     := GetMark() 
	Private lInverte   := .F. 
	 
	//-- Campos que estarùo disponiveis no filtro (FWFilter). 
	AAdd( aColunas, { "A1_COD"     ,"Codigo"       ,"C" ,TamSX3("A1_COD")[1]     ,TamSX3("A1_COD")[2]     ,"@!" } ) 
	AAdd( aColunas, { "A1_NOME"    ,"Nome"         ,"C" ,TamSX3("A1_NOME")[1]    ,TamSX3("A1_NOME")[2]    ,"@!" } ) 
	Aadd( aColunas, { "A1_PESSOA"  ,"Fisica/Jurid" ,"C" ,TamSX3("A1_PESSOA")[1]  ,TamSX3("A1_PESSOA")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_EST"     ,"Estado"       ,"C" ,TamSX3("A1_EST")[1]     ,TamSX3("A1_EST")[2]     ,"@!" } ) 
	Aadd( aColunas, { "A1_COD_MUN" ,"Cd.Municipio" ,"C" ,TamSX3("A1_COD_MUN")[1] ,TamSX3("A1_COD_MUN")[2] ,"@!" } ) 
	Aadd( aColunas, { "A1_VEND"    ,"Vendedor"     ,"C" ,TamSX3("A1_VEND")[1]    ,TamSX3("A1_VEND")[2]    ,"@!" } ) 
	Aadd( aColunas, { "A1_GRPVEN"  ,"Grp. Vendas"  ,"C" ,TamSX3("A1_GRPVEN")[1]  ,TamSX3("A1_GRPVEN")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_CNAE"    ,"CNAE"         ,"C" ,TamSX3("A1_CNAE")[1]    ,TamSX3("A1_CNAE")[2]    ,"@!" } ) 
	Aadd( aColunas, { "CC3_DESC"   ,"Descr.CNAE"   ,"C" ,TamSX3("CC3_DESC")[1]   ,TamSX3("CC3_DESC")[2]   ,"@!" } ) 
	Aadd( aColunas, { "X5_DESCRI"  ,"CNAE Amig."   ,"C" ,TamSX3("X5_DESCRI")[1]  ,TamSX3("X5_DESCRI")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_ULTCOM"  ,"Ult. Compra"  ,"D" ,TamSX3("A1_ULTCOM")[1]  ,TamSX3("A1_ULTCOM")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV1"  ,"Segmento 1"   ,"C" ,TamSX3("A1_SATIV1")[1]  ,TamSX3("A1_SATIV1")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV2"  ,"Segmento 2"   ,"C" ,TamSX3("A1_SATIV2")[1]  ,TamSX3("A1_SATIV2")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV3"  ,"Segmento 3"   ,"C" ,TamSX3("A1_SATIV3")[1]  ,TamSX3("A1_SATIV3")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV4"  ,"Segmento 4"   ,"C" ,TamSX3("A1_SATIV4")[1]  ,TamSX3("A1_SATIV4")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV5"  ,"Segmento 5"   ,"C" ,TamSX3("A1_SATIV5")[1]  ,TamSX3("A1_SATIV5")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV6"  ,"Segmento 6"   ,"C" ,TamSX3("A1_SATIV6")[1]  ,TamSX3("A1_SATIV6")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV7"  ,"Segmento 7"   ,"C" ,TamSX3("A1_SATIV7")[1]  ,TamSX3("A1_SATIV7")[2]  ,"@!" } ) 
	Aadd( aColunas, { "A1_SATIV8"  ,"Segmento 8"   ,"C" ,TamSX3("A1_SATIV8")[1]  ,TamSX3("A1_SATIV8")[2]  ,"@!" } ) 
	 
	//-- Utilizaùùo da classe FWFilter. 
	oFWFilter := FWFilter():New(GetWndDefault()) 
	oFWFilter:SetSQLFilter() 
	oFWFilter:DisableValid() 
	oFWFilter:SetField(aColunas) 
	oFWFilter:LoadFilter() 
	If oFWFilter:FilterBar() 		 
		If !Empty( AllTrim( oFwFilter:GetExprSQL() ) ) 
			cQryFilter += AllTrim(oFwFilter:GetExprSQL()) 
		EndIf 
	EndIf 
	 
Return( cQryFilter ) 
*/ 
/*/{Protheus.doc} CSFTM10Psq
Rotina para pesquisar a informacao digitada e posicionar.
@author David Alves dos Santos
@since 23/08/2016
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function CSFTM10Psq( nOrd,cPesq,oLbx )
	 
	Local bAScan := {|| .T. } 
	Local nCol   := nOrd 
	Local nBegin := nEnd := nP := 0 
	 
	cPesq := Upper( AllTrim( cPesq ) ) 
		 
	If nCol > 0 
		nBegin := Min( oLbx:nAt, Len( oLbx:aArray ) ) 
		nEnd   := Len( oLbx:aArray ) 
		 
		If oLbx:nAt == Len( oLbx:aArray ) 
			nBegin := 1 
		EndIf 
		 
		bAScan := {|p| Upper(AllTrim( cPesq ) ) $ AllTrim( p[nCol] ) }  
		 
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd ) 
		 
		If nP > 0 
			oLbx:nAt := nP 
			oLbx:Refresh() 
			oLbx:SetFocus() 
		Else 
			MsgStop('Registro nùo localizado.','Pesquisar') 
		EndIf 
	Else 
		MsgStop('Opùùo de pesquisa invùlida.',cCadastro) 
	EndIf 
	 
Return 
 
 /*/{Protheus.doc} CSFTM10Cod
Rotina para retornar o codigo do funcionario conforme o posicionamento.
@author David Alves dos Santos
@since 23/08/2016
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function CSFTM10Cod( oLbx, nOpc, cRet, nLin )
	 
	Local lRet := .T. 
	 
	cRet := AllTrim( oLbx:aArray[nLin,1] ) 
	nOpc := Iif( lRet, 1, 0 ) 
	 
Return( lRet ) 
 
static function CR068Leg() 
 
    local aLegenda := {} 
     
    aAdd( aLegenda,{"BR_VERDE"    	,"TÌtulo sem saldo em aberto." 		}) 
    aAdd( aLegenda,{"BR_VERMELHO"  	,"TÌtulo com saldo de outros PerÌodos em aberto." 	})     
 
    BrwLegenda("Legenda", "Legenda", aLegenda) 
 
Return Nil 
 
 
//--------------------------------------------------------------- 
/*/{Protheus.doc} LogWrite 
Realiza a validacao dos Dados do Reprocessamento recebido, e  
retorna qual tipo a ser executado. 
 
@param	cExec		Dados recebidos do Reprocessamento 
		cProcesso	 
		cMessage 
@return	Nil	 
/*/ 
//--------------------------------------------------------------- 
Static Function LogWrite(cMessage) 
	 
	Default cMessage 	:= ""		// Mensagem enviada a ser exibida no Conout 
	 
	//--------------------------------------------------------------------------------- 
	// Realizado essa funcao para caso estiver outra userfunction, podera ser chamada  
	// essa funcao somente precisara acrescentar o nProcesso e Descricao. 
	//--------------------------------------------------------------------------------- 
	If LogStatus() 
		FWrite(nHdlLog, Iif(!Empty(cMessage),AllTrim(cMessage),"") + CRLF) 
	EndIf 
		 
	CONOUT( "[ CRPA068 - " + cUserName + Dtoc( date() ) + " - " + time() + " ] " + Iif(!Empty(cMessage),AllTrim(cMessage),"") ) 
 
	//-------------------------------------------------------------------------------------------- 
	//	Exemplo:  
	//	** NFSE 
	//	[ AUTONFSE JOB(CSJB03) - TRANSMISSAO - 26/06/2015 - 17:47:00 ] - Iniciando o JOB 
	//	** TOTALIP 
	//	[ TOTALIP JOB(CSTOTIP) - IMPORTACAO LISTA - 07/08/2015 - 16:14:00 ] - Iniciando o JOB 
	//-------------------------------------------------------------------------------------------- 
	 
Return 
 
//--------------------------------------------------------------- 
/*/{Protheus.doc} LogInit 
Realiza a validacao dos Dados do Reprocessamento recebido, e  
retorna qual tipo a ser executado. 
 
@param	aDados		Dados recebidos do Reprocessamento 
@return	lLogOk		Retorno logico se trata de Reprocessamento.	 
/*/ 
//--------------------------------------------------------------- 
Static Function LogInit() 
 
Local cLogName 	:= "crpa068_"+DToS(dDataBase)+StrTran(Time(),":","")+".log" 
Local cLogPath	:= "\remuneracao\antecipacao\"  
 
cFullLog	:= cLogPath + cLogName 
 
If !ExistDir(cLogPath) 
	MakeDir(cLogPath) 
EndIf 
 
nHdlLog := FCreate(cFullLog) 
 
If nHdlLog == -1 
	CONOUT("[ CRPJ010 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation failure.") 
Else 
	CONOUT("[ CRPJ010 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation successful.") 
EndIf 
 
Return nHdlLog > -1 
 
//--------------------------------------------------------------- 
/*/{Protheus.doc} LogEnd 
Realiza a validacao dos Dados do Reprocessamento recebido, e  
retorna qual tipo a ser executado. 
 
@param	Nil 
@return	Nil 
/*/ 
//--------------------------------------------------------------- 
Static Function LogEnd() 
 
If nHdlLog > -1 
	FClose(nHdlLog) 
	CONOUT("[ CRPJ010 - Log Closure - " + Dtoc( date() ) + " - " + time() + " ] Log file closed.") 
EndIf 
 
Return 
 
//--------------------------------------------------------------- 
/*/{Protheus.doc} LogStatus 
Realiza a validacao dos Dados do Reprocessamento recebido, e  
retorna qual tipo a ser executado. 
 
@param	Nil			Dados recebidos do Reprocessamento 
@return	lLogOk		Retorno logico se trata de Reprocessamento. 
/*/ 
//--------------------------------------------------------------- 
Static Function LogStatus() 
Return (nHdlLog > -1) 
 
//--------------------------------------------------------------- 
/*/{Protheus.doc} LogStatus 
Realiza a validacao dos Dados do Reprocessamento recebido, e  
retorna qual tipo a ser executado. 
 
@param	Nil			Dados recebidos do Reprocessamento 
@return	lLogOk		Retorno logico se trata de Reprocessamento. 
/*/ 
//--------------------------------------------------------------- 
 
Static Function MostraLog() 
Local oDlg 
Local cMemo := MemoRead(cFullLog) 
//Local cFile 
Local oFont  
 
	DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15 
 
	DEFINE MSDIALOG oDlg TITLE cFullLog From 3,0 to 340,417 PIXEL 
 
	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL  
	oMemo:bRClicked := {||AllwaysTrue()} 
	oMemo:oFont:=oFont 
 
	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga 
	//DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL  
	//DEFINE SBUTTON  FROM 153,115 TYPE 6 ACTION (PrintAErr(cFullLog),oDlg:End()) ENABLE OF oDlg PIXEL //Imprime e Apaga 
 
	ACTIVATE MSDIALOG oDlg CENTER 
 
Return 
 
Static Function CR59LoadTree(oTree) 
 
Local cQuery 
Local cAliasTmp := GetNextAlias() 
Local cCargo	:= "" 
 
//cQuery :=  "SELECT Z3_CODENT,Z3_DESENT FROM "+RetSqlName("SZ3") + " WHERE Z3_TIPENT = '2' AND D_E_L_E_T_ = ' ' AND Z3_TIPCOM = '1' AND Z3_ADIANTA = 'S'" 
cQuery :=  "SELECT Z3_CODENT,Z3_DESENT FROM "+RetSqlName("SZ3") + " WHERE Z3_TIPENT = '2' AND D_E_L_E_T_ = ' ' AND Z3_ATIVO != 'N' ORDER BY Z3_CODENT" 
 
If Select(cAliasTmp) > 0 
	(cAliasTmp)->(dbCloseArea()) 
EndIf 
 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T.) 
 
oTree:AddItem(Padr("Redes",70),"Rede","PMSEDT2",,,,) 
 
While (cAliasTmp)->(!EoF()) 
 
	If AllTrim((cAliasTmp)->Z3_CODENT) $ "BB|BV|CER|CNC|NAOREM|TDARED|FECOAL/FECOAM/FECOBA/FECOCE/FECODF/FECOMA/FECOMG/FECOMS/FECOMT/FECOPA/FECOPB/FECOPE/FECOPR/FECORJ/FECORN/FECORO/FECORS/FECOSC/FECOSE/FECOTO" 
		(cAliasTmp)->(dbSkip()) 
		Loop 
	EndIf 
 
	cCargo := CR068DePara((cAliasTmp)->Z3_CODENT) 
 
	oTree:AddItem(Substr((cAliasTmp)->Z3_DESENT,1,70),cCargo,"PMSEDT3",,,,2) 
	(cAliasTmp)->(dbSkip()) 
EndDo 
 
//Adiciono a FECOMERCIO fora do Laùo para centralizar em apenas uma entidade 
cCargo := CR068DePara("FECOMALL") 
oTree:AddItem("FECOMERCIO",cCargo,"PMSEDT3",,,,2) 
 
(cAliasTmp)->(dbCloseArea()) 
 
Return 
 
// DELETE 
Static Function CP068DelPR() 
 
	Local aSelTit	:= {} 
	//Local aTitSubs	:= {} 
	Local aRecnoZZ7 := {} 
	Local aRecnoPC2 := {} 
	Local aRecnoSE2 := {} 
	Local nCounter	:= 0 
	//Local nTotalPA	:= 0 
	Local cParcela	:= Space(TamSX3("E2_PARCELA")[1]) 
	Local Ni, Ne, Nx, Nj 
	 
	Private lMsErroAuto	:= .F. 
	 
	LogInit() 
	LogWrite(Time() + " | Iniciando Exclusùo de TÌtulos pelo usuùrio " + cUserName) 
	LogWrite(Replicate("-",95)) 
	 
	ProcRegua(Len(aTitulos)) 
	 
	For Ni := 1 To Len(aTitulos) 
	 
		IncProcG1("Processando registro " + cValToChar(Ni) + "/" + cValToChar(Len(aTitulos))) 
		ProcessMessage() 
		 
		If aTitulos[Ni][2] 
		 
			dbSelectArea("SZ3") 
			SZ3->(dbSetOrder(1)) 
			SZ3->(dbSeek(xFilial("SZ3") + aTitulos[Ni][4])) 
			 
			dbSelectArea("SA2") 
			SA2->(dbSetOrder(1)) 
		 
			dbSelectArea("SE2") 
			If SE2->(dbSeek(xFilial("SE2")+aTitulos[Ni][6]+aTitulos[Ni][7]+ cParcela +aTitulos[Ni][8]+SZ3->Z3_CODFOR+SZ3->Z3_LOJA)) 
			 
				If SA2->(dbSeek(xFilial("SA2") + SZ3->Z3_CODFOR + SZ3->Z3_LOJA)) 
				 
					aAdd(aSelTit, {{"E2_FILIAL"  , SE2->E2_FILIAL , NIL },; 
							{"E2_PREFIXO" , SE2->E2_PREFIXO, NIL },; 
							{"E2_NUM"     , SE2->E2_NUM    , NIL },; 
							{"E2_PARCELA" , SE2->E2_PARCELA, NIL },; 
							{"E2_TIPO"    , SE2->E2_TIPO   , NIL },; 
							{"E2_NATUREZ" , SE2->E2_NATUREZ, NIL },; 
							{"E2_FORNECE" , SE2->E2_FORNECE, NIL },; 
							{"E2_LOJA"    , SE2->E2_LOJA   , NIL },; 
							{"E2_EMISSAO" , SE2->E2_EMISSAO, NIL },; 
							{"E2_VENCTO"  , SE2->E2_VENCTO , NIL },; 
							{"E2_VALOR"   , SE2->E2_VALOR  , NIL },; 
							{"E2_HIST"    , SE2->E2_HIST  , NIL },; 
							{"E2_MOEDA"   , SE2->E2_MOEDA  , NIL }}) 
							 
					aAdd(aRecnoZZ7, aTitulos[Ni][17]) 
					aAdd(aRecnoPC2, aTitulos[Ni][16]) 
					aAdd(aRecnoSE2, aTitulos[Ni][18]) 
				Else 
					MsgStop("Fornecedor " + SZ3->Z3_CODFOR + "/" + SZ3->Z3_LOJA + " nùo encontrado.") 
				EndIf 
			EndIf 
		EndIf 
	Next 
		 
	If Len(aSelTit) > 0 
				 
		For Ni := 1 To Len(aSelTit) 
		 
			IncprocG2("Excluindo TÌtulo Provisùrio " + cValToChar(Ni) + "/" + cValToChar(Len(aSelTit))) 
			ProcessMessage() 
		 
			// Executar a exclusùo dos TÌtulos. 
			MsExecAuto( { |a,b,c| FINA050( a, b, c ) } , aSelTit[Ni], ,5) 
			 
			// Se houver erro capturar a mensagem. 
			If lMsErroAuto 
				lRet := .F. 
				MostraErro() 
				cMsg := 'Inconsistùncia para excluir TÌtulo' + CRLF + CRLF 
				aAutoErr := GetAutoGRLog() 
				For ne := 1 To Len( aAutoErr ) 
					cMsg += aAutoErr[ ne ] + CRLF 
				Next ne 
				LogWrite(cMsg) 
				lMsErroAuto := .F. 
			Else 
				// Se nùo houver erro vincular o TÌtulo principal com as baixas dos TÌtulos ProvisÛrios. 
				For Nx := 1 To Len(aRecnoPC2) 
					PC2->(dbGoTo(aRecnoPC2[Nx])) 
					 
					RecLock("PC2",.F.) 
						PC2->PC2_PREFIX	:= "" 
						PC2->PC2_NUM	:= "" 
						PC2->PC2_PARCEL	:= "" 
						PC2->PC2_TIPO	:= "" 
						PC2->PC2_FORNEC	:= "" 
						PC2->PC2_LOJA	:= "" 
					PC2->(MsUnlock()) 
				Next 
				 
				For Nj := 1 To Len(aRecnoZZ7) 
					ZZ7->(dbGoTo(aRecnoZZ7[Nj])) 
					 
					RecLock("ZZ7",.F.) 
						dbDelete() 
					ZZ7->(MsUnlock()) 
				Next 
	 
				LogWrite("[Exclusùo] TÌtulo " + SE2->E2_PREFIXO + SE2->E2_NUM +; 
				 	". Fornecedor: " + SE2->E2_FORNECE + "/" + SE2->E2_LOJA + ". Valor R$ " + AllTrim(Transform(SE2->E2_VALOR,"@E 999,999,999.99"))) 
				LogWrite(Replicate("-",95)) 
				nCounter++ 
				 
			Endif 
			 
		Next 
		 
		LogWrite("Foram excluùdos " + cValToChar(nCounter) + " TÌtulos com sucesso.") 
		LogWrite(Time() + " | Fim da rotina.") 
		LogEnd() 
		MostraLog() 
		 
		MsgRun("Executando atualizaùùo dos dados. Por gentileza, aguarde.","TÌtulos ProvisÛrios",{||CR068Array(oTree)}) 
		oLbx1:Refresh() 
		oLbx1:SetFocus() 
		 
	EndIf 
 
 
Return 
 
Static Function getPeriodo(cPerAtu,nAnt) 
 
Local cPeriodo 	:= "" 
Local cMesRemu 	:= Substr(cPerAtu,5,2) 
//Local cAnoRemu 	:= Substr(cPerAtu,1,4) 
Local nLastRem 	:= 0 
 
Default nAnt   	:= 0 
 
nLastRem := Val(cMesRemu) - nAnt 
 
//Captura o ⁄ltimo periodo fechado para calcular a antecipacao  
//Se Fevereiro, o valor ù zero, se Janeiro, -1. 
//Em Janeiro, considera Novembro do ano anterior como ultimo calculo valido 
If nLastRem == 0 
	cPeriodo := cValToChar((Val(Substr(cPerAtu,1,4))) - 1) + "12" 
ElseIf nLastRem == -1 
	cPeriodo := cValToChar((Val(Substr(cPerAtu,1,4))) - 1) + "11" 
Else 
	cPeriodo := Substr(cPerAtu,1,4) + StrZero(Val(Substr(cPerAtu,5,2)) - nAnt, 2) 
EndIf 
 
Return cPeriodo 
 
Static Function CP068VisPA(aHead_Tit, aTitulos) 
 
Local aCabec 	:= {} 
Local aItens 	:= {} 
//Local cQuery 	:= "" 
//Local cAliasT2	:= GetNextAlias() 
Local Nz, Nm 
 
For Nz := 3 To Len(aHead_Tit) 
	aAdd(aCabec, aHead_Tit[Nz]) 
Next 
 
For Nz := 1 To Len(aTitulos) 
	aAdd(aItens,{}) 
	For Nm := 3 To (Len(aTitulos[Nz]) - 3) 
		aAdd(aTail(aItens), aTitulos[Nz][Nm]) 
	Next Nm 
Next Nz 
 
DlgToExcel({ {"ARRAY","TÌtulos para Avaliaùùo", aCabec, aItens} }) 
 
Return 
 
Static Function CP068Print() 
 
Local aCabec 	:= {} 
Local aItens 	:= {} 
Local cQuery 	:= "" 
Local cAliasT2	:= GetNextAlias() 
Local cPedido	:= "" 
Local lNFClass	:= .F. 
Local lNFFound	:= .F. 
Local lPedFound	:= .F. 
 
//-- DefiniÁ„o do titulo das colunas. 
aCabec := { 'PerÌodo Ref.',;  
		    'Canal',; 
		    'Desc. Canal',; 
			'Cod. Entidade',;  
			'Desc. Entidade',;  
			'Prefixo',;  
			'Num Titulo',; 
			'Tipo TÌtulo',; 
			'⁄ltimo PerÌodo',; 
			'Pen⁄ltimo PerÌodo',; 
			'Antepen˙tlimo PerÌodo',; 
			'Total Faturamento',; 
			'MÈdia Faturamento',; 
			'Percentual',; 
			'Valor do Adiantamento'} 
 
cQuery := "SELECT PC2_CODAC," 
cQuery += "		  (SELECT SZ3A.Z3_DESENT FROM SZ3010 SZ3A WHERE SZ3A.Z3_FILIAL = ' ' AND SZ3A.Z3_CODENT = PC2_CODAC AND SZ3A.D_E_L_E_T_ = ' ' AND Z3_TIPENT = '2') as PC2_DESCAC," 
cQuery += "		  PC2_PERIOD,"  
cQuery += "       PC2_CODENT,"  
cQuery += "       PC2_DESENT, " 
cQuery += "       PC2_PREFIX, " 
cQuery += "       PC2_NUM, " 
cQuery += "       PC2_PARCEL,"  
cQuery += "       PC2_TIPO, " 
cQuery += "		  PC2_PEDIDO," 
cQuery += "		  PC2_TIPPED," 
cQuery += "       ZZ7_VALOR, " 
cQuery += "       E2_VALOR, " 
cQuery += "       E2_SALDO, " 
cQuery += "       E2_BAIXA, " 
cQuery += "       PC2.R_E_C_N_O_ RECNOPC2," 
cQuery += "       SE2.R_E_C_N_O_ RECNOSE2," 
cQuery += "       ZZ7.R_E_C_N_O_ RECNOZZ7, " 
cQuery += "       PC2.PC2_PER1 PERIODO1, " 
cQuery += "       PC2.PC2_PER2 PERIODO2, "					 
cQuery += "       PC2.PC2_PER3 PERIODO3, " 
cQuery += "       PC2.PC2_SOMA SOMA, " 
cQuery += "		  Round((PC2.PC2_SOMA / 3),2) AS MEDIA," 
cQuery += "		  SZ3.Z3_PERADTO AS PERCENTUAL" 
cQuery += "FROM " + RetSqlName("PC2") + " PC2 " 
cQuery += ""	 
cQuery += "       INNER JOIN " + RetSqlName("ZZ7") + " ZZ7 " 
cQuery += "               ON ZZ7_FILIAL = PC2_FILIAL " 
cQuery += "                  AND ZZ7_PRETIT = PC2_PREFIX " 
cQuery += "                  AND ZZ7_TITULO = PC2_NUM " 
cQuery += "                  AND ZZ7_CODPAR = PC2_CODENT " 
cQuery += "       INNER JOIN " + RetSqlName("SE2") + " SE2 " 
cQuery += "               ON E2_NUM = PC2_NUM " 
cQuery += "                  AND E2_PREFIXO = PC2_PREFIX " 
cQuery += "                  AND E2_TIPO = PC2_TIPO " 
cQuery += "                  AND E2_FORNECE = PC2_FORNEC " 
cQuery += "		  INNER JOIN " + RetSqlName("SZ3") + " SZ3 " 
cQuery += "				  ON Z3_FILIAL = ' ' " 
cQuery += "					 AND Z3_CODENT = PC2_CODENT " 
cQuery += "WHERE  PC2_NUM > ' ' " 
cQuery += "		  AND ZZ7_VALOR > 0 "	 
cQuery += "       AND E2_BAIXA = ' ' " 
cQuery += "		  AND PC2_TIPO = 'PR' " 
cQuery += "       AND PC2.D_E_L_E_T_ = ' ' " 
cQuery += "       AND ZZ7.D_E_L_E_T_ = ' ' " 
cQuery += "       AND SE2.D_E_L_E_T_ = ' ' " 
cQuery += "		  AND SZ3.D_E_L_E_T_ = ' ' " 
If SZ3->(FieldPos("Z3_DESCREDE")) > 0 
	cQuery += "		AND Z3_DESCRED != 'S' " 
EndIf 
 
If MV_PAR01 $ "1|3" 
	cQuery += " AND PC2_PERIOD = '" + cPerRemu + "'" 
EndIf 
cQuery += "	ORDER BY PC2_CODAC,PC2_DESENT, PC2_PERIOD" 
	 
//-- Verifica se a tabela esta aberta. 
If Select(cAliasT2) > 0 
	(cAliasT2)->(DbCloseArea())				 
EndIf 
 
//-- Execucao da query. 
cQuery := ChangeQuery(cQuery) 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasT2,.F.,.T.) 
	 
(cAliasT2)->(dbGoTop()) 
While (cAliasT2)->( !Eof() ) 
	 
	If MV_PAR01 == "1" 
		//No caso das Medicoes, ù necessùrio buscar a mediùùo e na tabela CND encontrar o nùmero do Pedido 
		//Depois do nùmero do pedido, serù possùvel chegar ù Nota de Entrada e verificar se estù classificada. 
		If (cAliasT2)->PC2_TIPPED == "M" 
			 
			CND->(dbSetOrder(4)) 
			If !CND->(dbSeek(xFilial("CND") + (cAliasT2)->PC2_PEDIDO)) 
				(cAliasT2)->( DbSkip() ) 
				Loop //Nùo encontrou a mediùùo 
			Else 
				cPedido := CND->CND_PEDIDO 
			EndIf 
		 
		ElseIf (cAliasT2)->PC2_TIPPED == "P" 
			cPedido := (cAliasT2)->PC2_PEDIDO 
		ElseIf Empty((cAliasT2)->PC2_PEDIDO) 
			(cAliasT2)->( DbSkip() ) 
			Loop //Pedido ou Mediùùo vazio 
		EndIf 
		 
		SC7->(dbSetOrder(1)) 
		SD1->(dbOrderNickName("PEDIDO")) 
		 
		lPedFound := SC7->(dbSeek(xFilial("SC7") + cPedido)) 
		lNFFound := SD1->(dbSeek(xFilial("SD1") + SC7->C7_NUM)) 
		lNFClass := (!Empty(SD1->D1_TES) .And. !Empty(SD1->D1_CF)) 
					 
		If !lPedFound .Or. !lNFFound .Or. !lNFClass 
			(cAliasT2)->(DbSkip()) 
			Loop 
		EndIf 
		 
	EndIf 
	 
	aAdd(aItens, { (cAliasT2)->PC2_PERIOD,; 
					 (cAliasT2)->PC2_CODAC,; 
					 (cAliasT2)->PC2_DESCAC,;					  
					 (cAliasT2)->PC2_CODENT,;										 
					 (cAliasT2)->PC2_DESENT,;										 
					 (cAliasT2)->PC2_PREFIX,; 
					 (cAliasT2)->PC2_NUM,; 
					 (cAliasT2)->PC2_TIPO,; 
					 (cAliasT2)->PERIODO1,; 
					 (cAliasT2)->PERIODO2,; 
					 (cAliasT2)->PERIODO3,; 
					 (cAliasT2)->SOMA,; 
					 0,; 
					 (cAliasT2)->PERCENTUAL,;						  
					 Transform((cAliasT2)->ZZ7_VALOR, "@E 999,999,999.99")})									 
 
	//Salva o codigo da entidade processada 
	cLastEnt := (cAliasT2)->PC2_CODENT 
 
	(cAliasT2)->( DbSkip() ) 
EndDo 
 
DlgToExcel({ {"ARRAY","TÌtulos para Avaliaùùo", aCabec, aItens} }) 
 
If Select(cAliasT2) > 0 
	(cAliasT2)->(DbCloseArea())				 
EndIf 
 
Return 
 
Static Function CR068ParaDe(cCargo)  
 
Local cRet	:= "" 
 
	Do Case 
		Case cCargo == "FECO" 
			cRet := " ANY('FECOAL','FECOAM','FECOBA','FECOCE','FECODF','FECOMA','FECOMG','FECOMS','FECOMT','FECOPA','FECOPB','FECOPE','FECOPR','FECORN','FECORJ','FECORO','FECORS','FECOSC','FECOSE','FECOTO')" 
		Case cCargo == "FACE" 
			cRet := "'FACES'" 
		Case cCargo == "FENC" 
			cRet := "'FENCR'"	 
		Case cCargo == "SINR" 
			cRet := "'SINRJ'" 
		Case cCargo == "SINT" 
		 	cRet := "'SINITU'" 
		Case cCargo == "FASC" 
			cRet := "'FACISC'"			 
		Case cCargo == "SINA" 
			cRet := "'SINAP'"			 
		Otherwise 
			cRet := "'" + cCargo +"'" 
	EndCase 
 
Return cRet 
 
Static Function CR068DePara(cCargo) 
 
Local cRet := "" 
 
	Do Case 
		Case cCargo $ "FECOMALL/FECOAL/FECOAM/FECOBA/FECOCE/FECODF/FECOMA/FECOMG/FECOMS/FECOMT/FECOPA/FECOPB/FECOPE/FECOPR/FECORJ/FECORN/FECORO/FECORS/FECOSC/FECOSE/FECOTO" 
			cRet := "FECO" 
		Case cCargo == "FACES" 
			cRet := "FACE" 
		Case cCargo == "FENCR" 
			cRet := "FENC"			 
		Case cCargo == "SINRJ" 
			cRet := "SINR"			 
		Case cCargo == "SINITU" 
			cRet := "SINT"			 
		Case cCargo == "FACISC" 
			cRet := "FASC"		 
		Case cCargo == "SINAP" 
			cRet := "'SINA'"			 
		Otherwise 
			cRet := cCargo 
	EndCase 
	 
Return cRet 
 
 
Static Function PrintAllPA() 
 
	Local aCabec 	:= {} 
	Local aItens 	:= {} 
	Local cQuery 	:= "" 
	Local cAliasT2	:= GetNextAlias() 
	//Local cPedido	:= "" 
	//Local lNFClass	:= .F. 
	//Local lNFFound	:= .F. 
	//Local lPedFound	:= .F. 
	Local nTotal	:= 0 
	 
	//-- DefiniÁ„o do titulo das colunas. 
	aCabec := { 'PerÌodo Ref.',;  
			    'Canal',; 
			    'Desc. Canal',; 
				'Cod. Entidade',;  
				'Desc. Entidade',;  
				'Prefixo',;  
				'Num Titulo',; 
				'Tipo TÌtulo',; 
				'⁄ltimo PerÌodo',; 
				'Pen⁄ltimo PerÌodo',; 
				'Antepen˙tlimo PerÌodo',; 
				'Total Faturamento',; 
				'MÈdia Faturamento',; 
				'Percentual',; 
				'Valor do Adiantamento'} 
	 
	cQuery := "SELECT PC2_CODAC," 
	cQuery += "		  (SELECT SZ3A.Z3_DESENT FROM SZ3010 SZ3A WHERE SZ3A.Z3_FILIAL = ' ' AND SZ3A.Z3_CODENT = PC2_CODAC AND SZ3A.D_E_L_E_T_ = ' ' AND Z3_TIPENT = '2') as PC2_DESCAC," 
	cQuery += "		  PC2_PERIOD,"  
	cQuery += "       PC2_CODENT,"  
	cQuery += "       PC2_DESENT, " 
	cQuery += "       PC2_PREFIX, " 
	cQuery += "       PC2_NUM, " 
	cQuery += "       PC2_PARCEL,"  
	cQuery += "       PC2_TIPO, " 
	cQuery += "		  PC2_PEDIDO," 
	cQuery += "		  PC2_TIPPED," 
	cQuery += "       ZZ7_VALOR, " 
	cQuery += "       E2_VALOR, " 
	cQuery += "       E2_SALDO, " 
	cQuery += "       E2_BAIXA, " 
	cQuery += "       PC2.R_E_C_N_O_ RECNOPC2," 
	cQuery += "       SE2.R_E_C_N_O_ RECNOSE2," 
	cQuery += "       ZZ7.R_E_C_N_O_ RECNOZZ7, " 
	cQuery += "       PC2.PC2_PER1 PERIODO1, " 
	cQuery += "       PC2.PC2_PER2 PERIODO2, "					 
	cQuery += "       PC2.PC2_PER3 PERIODO3, " 
	cQuery += "       PC2.PC2_SOMA SOMA, " 
	cQuery += "		  Round((PC2.PC2_SOMA / 3),2) AS MEDIA," 
	cQuery += "		  SZ3.Z3_PERADTO AS PERCENTUAL " 
	cQuery += "FROM " + RetSqlName("PC2") + " PC2 " 
	cQuery += ""	 
	cQuery += "       INNER JOIN " + RetSqlName("ZZ7") + " ZZ7 " 
	cQuery += "               ON ZZ7_FILIAL = PC2_FILIAL " 
	cQuery += "                  AND ZZ7_PRETIT = PC2_PREFIX " 
	cQuery += "                  AND ZZ7_TITULO = PC2_NUM " 
	cQuery += "                  AND ZZ7_CODPAR = PC2_CODENT " 
	cQuery += "       INNER JOIN " + RetSqlName("SE2") + " SE2 " 
	cQuery += "               ON E2_NUM = PC2_NUM " 
	cQuery += "                  AND E2_PREFIXO = PC2_PREFIX " 
	cQuery += "                  AND E2_TIPO = PC2_TIPO " 
	cQuery += "                  AND E2_FORNECE = PC2_FORNEC " 
	cQuery += "		  INNER JOIN " + RetSqlName("SZ3") + " SZ3 " 
	cQuery += "				  ON Z3_FILIAL = ' ' " 
	cQuery += "					 AND Z3_CODENT = PC2_CODENT " 
	cQuery += "WHERE  PC2_NUM > ' ' " 
	cQuery += "		  AND ZZ7_VALOR > 0 "	 
	cQuery += "		  AND PC2_TIPO = 'PA' " 
	cQuery += "       AND PC2.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND ZZ7.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND SE2.D_E_L_E_T_ = ' ' " 
	cQuery += "		  AND SZ3.D_E_L_E_T_ = ' ' " 
	cQuery += " AND PC2_PERIOD = '" + cPerRemu + "'" 
	cQuery += "	ORDER BY PC2_CODAC,PC2_DESENT, PC2_PERIOD" 
		 
	//-- Verifica se a tabela esta aberta. 
	If Select(cAliasT2) > 0 
		(cAliasT2)->(DbCloseArea())				 
	EndIf 
	 
	//-- Execucao da query. 
	cQuery := ChangeQuery(cQuery) 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasT2,.F.,.T.) 
		 
	(cAliasT2)->(dbGoTop()) 
	While (cAliasT2)->( !Eof() ) 
				 
		aAdd(aItens, { (cAliasT2)->PC2_PERIOD,; 
						 (cAliasT2)->PC2_CODAC,; 
						 (cAliasT2)->PC2_DESCAC,;					  
						 (cAliasT2)->PC2_CODENT,;										 
						 (cAliasT2)->PC2_DESENT,;										 
						 (cAliasT2)->PC2_PREFIX,; 
						 (cAliasT2)->PC2_NUM,; 
						 (cAliasT2)->PC2_TIPO,; 
						 (cAliasT2)->PERIODO1,; 
						 (cAliasT2)->PERIODO2,; 
						 (cAliasT2)->PERIODO3,; 
						 (cAliasT2)->SOMA,; 
						 0,;//(cAliasT2)->MEDIA,; 
						 (cAliasT2)->PERCENTUAL,;						  
						 Transform((cAliasT2)->ZZ7_VALOR, "@E 999,999,999.99")}) 
						  
		nTotal += (cAliasT2)->ZZ7_VALOR 
	 
		//Salva o codigo da entidade processada 
		cLastEnt := (cAliasT2)->PC2_CODENT 
	 
		(cAliasT2)->( DbSkip() ) 
	EndDo  
	 
	aAdd(aItens, { "TOTAL","","","","","","","","","","","","","",Transform((cAliasT2)->ZZ7_VALOR, "@E 999,999,999.99")}) 
	 
	DlgToExcel({ {"ARRAY","TÌtulos para Avaliaùùo", aCabec, aItens} }) 
	 
	If Select(cAliasT2) > 0 
		(cAliasT2)->(DbCloseArea())				 
	EndIf 
	 
	Return	 
Return 
 
Static Function CRPA068DT() 
 
	Local oDlg2	 
 
	oDlg2 := MSDialog():New(001,001,100,310,'DATA DE VENCIMENTO',,,,,CLR_BLACK,CLR_WHITE,,,.T.) 
 
		@ 35,015 SAY "Data Vencimento: " OF oDlg2 PIXEL 
		@ 35,061 MSGET dDataVenc   SIZE 50,5 OF oDlg2 PIXEL PICTURE "@D" 
 
	// Ativa diùlogo centralizado 
	ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT	EnchoiceBar(oDlg2,{|| oDlg2:End()},{|| lCancela := .T., oDlg2:End()})  
 
Return 
