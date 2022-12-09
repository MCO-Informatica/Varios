#Include 'Protheus.ch'
#Include 'Parmtype.ch'
#Include "ApWizard.ch"

#Define CRLF Chr(13)+Chr(10)

Static cCodFun := Space(9)

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSFTM010 |Autor: |David Alves dos Santos |Data: |15/09/2017   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina de adminstra็ใo de clientes.                           |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |CS  = Certisign.                                              |
//|do codigo    |FT  = Modulo Faturamento SIGAFAT.                             |
//|fonte.       |M   = Miscelanea.                                             |
//|             |999 = Numero sequencial.                                      |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSFTM010()

	Local aParam := {}
	
	Private aCanal    := {}
	Private cCadastro := 'Administra็ใo de Clientes'
	
	AAdd(aParam, {1, 'C๓digo do canal de vendas', Space(TamSX3("Z2_CODIGO")[1]),'@!',"ExistCpo('SZ2')",'SZ2','',50,.T.} )
	
	If ParamBox( aParam,'Informe o canal de vendas',@aCanal,,,,,,,,.F.,.F.)
		FTM010PROC()
	EndIf
	
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FTM010PROC |Autor: |David Alves dos Santos |Data: |15/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Processamento da rotina.                                        |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FTM010PROC()
	
	Local cFiltro    := FTM010FILT()
	Local cTitulo    := ' - Logo abaixo encontra-se a rela็ใo de clientes.'
	
	Local aC         := {}
	Local aBtn       := {}
	Local aAcoes     := {}
	Local aTam_Cli   := {}
	Local aHead_Cli  := {}
	
	Local nI         := 0
	
	Local oDlg
	Local oWin1
	Local oWin2
	Local oFWLayer
	Local oSplitter
	Local oPnl1
	
	Local bMarkAll   := { || FM010Mark(.T.) }
	Local bClearAll  := { || FM010Mark(.F.) }
		
	Private aCliente := {}
	Private nColAux  := 0
	Private oLbx1
	Private oMrk     := LoadBitmap(,'NGCHECKOK.PNG')
	Private oNoMrk   := LoadBitmap(,'NGCHECKNO.PNG')
	Private lMarkX   := .T.
			
	aCpoCli := {'','A1_COD','A1_NOME','A1_CGC','A1_CNAE','','F2_VALBRUT','F2_VALBRUT','A1_EST','A1_MUN'}
	
	//-- Captura do tamanho das colunas com base nos campos.
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpoCli )
		SX3->( dbSeek( aCpoCli[ nI ] ) )
		SX3->( AAdd( aTam_Cli, CalcFieldSize( X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_PICTURE, X3_TITULO ) ) )
	Next nI
	
	//-- Ajustes no largura da coluna.
	aTam_Cli[ 2 ] := aTam_Cli[ 2 ] + 10
	
	//-- Defini็ใo do titulo das colunas.
	aHead_Cli := { 	'X',;
					'C๓digo',; 
					'Nome',; 
					'CNPJ',; 
					'CNAE',; 
					'Descri็ใo CNAE',;
					'CNAE Amigavel',; 
					'Faturamento ' + cValToChar(Year(Date())-1),;
					'Faturamento ' + cValToChar(Year(Date())),;
					'UF',;
					'Cidade',;
					'Segmento 1',;
					'Segmento 2',;
					'Segmento 3',;
					'Segmento 4',;
					'Segmento 5',;
					'Segmento 6',;
					'Segmento 7',;
					'Segmento 8' }
	
	//-- Defini็ใo dos bot๕es.
	AAdd( aAcoes ,{ 'Visualizar'      ,'{|| FM010Visu() }'                                                                                       } )
	AAdd( aAcoes ,{ 'Filtrar'         ,'{|| cFiltro := FTM010FILT(),  FM010Array(cFiltro), oLbx1:Refresh(), oLbx1:SetFocus()}'                   } )
	AAdd( aAcoes ,{ 'Gerar Agenda'    ,'{|| FM010GerAg() }'                                                                                      } )
	AAdd( aAcoes ,{ 'Atualizar'       ,'{|| FM010Atu()}'                                                                                         } ) 
	AAdd( aAcoes ,{ 'Marcar todos'    ,'{|| Iif(MsgYesNo("Marcar todos os tํtulos?",cCadastro),Processa(bMarkAll,"","",.F.),NIL) }'              } )
	AAdd( aAcoes ,{ 'Desmarcar todos' ,'{|| Iif(MsgYesNo("Desmarcar todos os tํtulos marcados?",cCadastro),Processa(bClearAll,"","",.F.),NIL) }' } )
	AAdd( aAcoes ,{ 'Sair'            ,'{|| Iif(MsgYesNo("Deseja realmente sair da rotina?",cCadastro),oDlg:End(),NIL) }'                        } )
	
	
	//-- Defini็ใo das a็๕es da teclas de atalho.
	SetKey( VK_F5  ,&(aAcoes[1,2]) )
	SetKey( VK_F6  ,&(aAcoes[2,2]) )
	SetKey( VK_F7  ,&(aAcoes[3,2]) )
	SetKey( VK_F8  ,&(aAcoes[4,2]) )
	SetKey( VK_F9  ,&(aAcoes[5,2]) )
	SetKey( VK_F10 ,&(aAcoes[6,2]) )
	SetKey( VK_F11 ,&(aAcoes[7,2]) )
	
	// [1] - propriedade do objeto
	// [2] - tํtulo do botใo
	// [3] - fun็ใo a ser executada quando acionado o botใo
	// [4] - texto explicativo da funcionalidade da rotina
	AAdd( aBtn ,{ NIL ,aAcoes[1,1] ,aAcoes[1,2] ,'<F5> Visualizar.'                    } )
	AAdd( aBtn ,{ NIL ,aAcoes[2,1] ,aAcoes[2,2] ,'<F6> Filtrar.'                       } )
	AAdd( aBtn ,{ NIL ,aAcoes[3,1] ,aAcoes[3,2] ,'<F7> Gerar Agenda.'                  } )
	AAdd( aBtn ,{ NIL ,aAcoes[4,1] ,aAcoes[4,2] ,'<F8> Atualiza็๕es.'                  } )
	AAdd( aBtn ,{ NIL ,aAcoes[5,1] ,aAcoes[5,2] ,'<F9> Marcar todos os registros.'     } )
	AAdd( aBtn ,{ NIL ,aAcoes[6,1] ,aAcoes[6,2] ,'<F10> Desmarcar todos os registros.' } )
	AAdd( aBtn ,{ NIL ,aAcoes[7,1] ,aAcoes[7,2] ,'<F11> Sair da rotina.'               } )
	
	aC := FWGetDialogSize( oMainWnd )
	
	DEFINE DIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
		
		oDlg:lEscClose := .F.
		oFWLayer := FWLayer():New()
		
		oFWLayer:Init( oDlg, .F. )
		
		oFWLayer:AddCollumn( 'Col01', 10, .T. )
		oFWLayer:AddCollumn( 'Col02', 90, .F. )
		
		oFWLayer:SetColSplit( 'Col01', CONTROL_ALIGN_RIGHT,, {|| .T. } )
		
		oFWLayer:AddWindow('Col01','Win01','A็๕es'             ,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		oFWLayer:AddWindow('Col02','Win02',cCadastro + cTitulo ,100,.F.,.T.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		
		oWin1 := oFWLayer:GetWinPanel('Col01','Win01')
		oWin2 := oFWLayer:GetWinPanel('Col02','Win02')
		
		oSplitter := TSplitter():New( 1, 1, oWin2, 1000, 1000, 1 ) 
		oSplitter:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnl1:= TPanel():New(1,1,' Painel 01',oSplitter,,,,,/*CLR_YELLOW*/,60,60)
		
		oPnl1:Align := CONTROL_ALIGN_ALLCLIENT
		
		For nI := 1 To Len(aBtn)
			aBtn[nI,1] := TButton():New(1,1,aBtn[nI,2],oWin1,&(aBtn[nI,3]),50,11,,,.F.,.T.,.F.,aBtn[nI,4],.F.,,,.F.)
			aBtn[nI,1]:Align := CONTROL_ALIGN_TOP
		Next nI
		
	   //-- Controle visual do cliente.
	   oLbx1              := TwBrowse():New(1,1,1000,1000,,aHead_Cli,,oPnl1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx1:aColSizes    := aTam_Cli
	   oLbx1:Align        := CONTROL_ALIGN_ALLCLIENT
	   oLbx1:bLDblClick   := {|| M010MrkCli() }
	   oLbx1:bHeaderClick := {|oBrw, nCol| M010HdrClc(nCol) }
	
	   //-- Chama fun็ใo para montar o array de clientes.
	   FM010Array(cFiltro)
	   oLbx1:Refresh()
	   oLbx1:SetFocus()
	   
	ACTIVATE DIALOG oDlg CENTERED

Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |M010HdrClc |Autor: |David Alves dos Santos |Data: |15/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Rotina para ordenar colunas.                                    |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function M010HdrClc(nCol)
	
	Local bMarkAll   := { || FM010Mark(.T.) }
	Local bClearAll  := { || FM010Mark(.F.) }
	
	If nCol == 1
		If lMarkX
			Processa(bMarkAll,"","",.F.)
			lMarkX := .F.
		Else
			Processa(bClearAll,"","",.F.)
			lMarkX := .T.
		EndIf
	Else
		//-- Define quais colunas poderใo ser ordenadas.
		If nCol == 2 .Or. nCol == 5 .Or. nCol == 6 .Or. nCol == 7 .Or. nCol == 8 
			If nCol == nColAux
				//-- Ordem Descendente.
				ASort(aCliente,,, { | x,y | x[nCol] < y[nCol] } )
				oLbx1:Refresh()
				nColAux := 0
			Else
				//-- Ordem Acendente.
				ASort(aCliente,,, { | x,y | x[nCol] > y[nCol] } )
				oLbx1:Refresh()
				nColAux := nCol
			EndIf
		Else
			MsgAlert("Nใo ้ possivel ordenar esta coluna.", cCadastro)
		EndIf
	EndIf
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010Visu  |Autor: |David Alves dos Santos |Data: |22/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Fun็ใo para realizar a visualiza็ใo dos registros.              |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010Visu()
	
	If !Empty(aCliente[1,2])
		dbSelectArea("SA1")
		dbSetOrder(1)
		//-- Apresenta a visuliza็ใo do registro se encontrar na tabela SA1.
		If SA1->(MsSeek(xFilial("SA1")+aCliente[oLbx1:nAt,2]))
			//-- Utiliza a fun็ใo AxVisual para visualiza็ใo do registro.
			AxVisual("SA1",oLbx1:AARRAY[oLbx1:nAt,11],2)
		EndIf
	EndIf
	
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010Atu   |Autor: |David Alves dos Santos |Data: |18/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Fun็ใo para realizar atualiza็๕es de cadastro.                  |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010Atu()
	
	Local oWizard, oPanel
	Local cVendedor := Space( TamSX3("A1_VEND")[1]   )
	Local cCnae     := Space( TamSX3("A1_CNAE")[1]   )
	Local cGrpVen   := Space( TamSX3("A1_GRPVEN")[1] )
	Local cSeg1     := Space( TamSX3("A1_SATIV1")[1] )
	Local cSeg2     := Space( TamSX3("A1_SATIV2")[1] )
	Local cSeg3     := Space( TamSX3("A1_SATIV3")[1] )
	Local cSeg4     := Space( TamSX3("A1_SATIV4")[1] )
	Local cSeg5     := Space( TamSX3("A1_SATIV5")[1] )
	Local cSeg6     := Space( TamSX3("A1_SATIV6")[1] )
	Local cSeg7     := Space( TamSX3("A1_SATIV7")[1] )
	Local cSeg8     := Space( TamSX3("A1_SATIV8")[1] )
    Local lOK       := .F.
    Local nX        := 0
    
    For nX := 1 to Len(aCliente)
    	If aCliente[nX,1]
    		lOk := .T.
    		Exit
    	EndIf
    Next
    
    If lOk
    	//-- Constru็ใo do wizard de atualiza็ใo.
    	DEFINE	WIZARD oWizard TITLE "Wizard - Atualiza็ใo de clientes" ;
    	       	HEADER "Atualiza็ใo de clientes" ;
    	       	MESSAGE "Assistente para altera็๕es de clientes" ;
    	       	TEXT "Este assistente ajudarแ voc๊ a realizar atualiza็๕es nos registros dos clientes selecionados" ;
    	       	NEXT {||.T.} ;
    	       	FINISH {|| .T. } ;
    	       	PANEL
	   
	           //-- Primeira etapa
	           CREATE 	PANEL oWizard ;
	           			HEADER "Atualiza็ใo de clientes" ;
	           			MESSAGE "Informe os dados que deseja atualizar." ;
	           			BACK {|| .T. } ;
	           			NEXT {|| .T. } ;
	           			FINISH {|| .F. } ;
	           			PANEL
	           oPanel := oWizard:GetPanel(2)
	           @ 15,15 SAY "Vendedor" SIZE 45,8 PIXEL OF oPanel
	           @ 25,15 MSGET cVendedor PICTURE "@!" SIZE 160,10 PIXEL F3 "SA3" OF oPanel
	   
	           @ 45,15 SAY "CNAE" SIZE 45,8 PIXEL OF oPanel
	           @ 55,15 MSGET cCnae PICTURE "@!" SIZE 160,10 PIXEL F3 "FTM010" OF oPanel
	   
	           @ 75,15 SAY "Grupo Venda Cliente" SIZE 45,8 PIXEL OF oPanel
	           @ 85,15 MSGET cGrpVen PICTURE "@!" SIZE 160,10 PIXEL F3 "ACY" OF oPanel
	   
	           //-- Segunda etapa.
	           CREATE 	PANEL oWizard ;
	           			HEADER "Atualiza็ใo de clientes" ;
	           			MESSAGE "Informe os dados que deseja atualizar." ;
	           			BACK {|| .T. } ;
	           			NEXT {|| .F. } ;
	           			FINISH {|| .T. } ;
	           			PANEL
	           oPanel := oWizard:GetPanel(3)
	           @ 15,15   SAY "Segmento 1" SIZE 45,8 PIXEL OF oPanel
	           @ 25,15   MSGET cSeg1 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	   
	           @ 15,155  SAY "Segmento 2" SIZE 45,8 PIXEL OF oPanel
	           @ 25,155  MSGET cSeg2 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	   
	           @ 45,15   SAY "Segmento 3" SIZE 45,8 PIXEL OF oPanel
	           @ 55,15   MSGET cSeg3 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	   
	           @ 45,155  SAY "Segmento 4" SIZE 45,8 PIXEL OF oPanel
	           @ 55,155  MSGET cSeg4 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	   
	           @ 75,15   SAY "Segmento 5" SIZE 45,8 PIXEL OF oPanel
	           @ 85,15   MSGET cSeg5 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	   
	           @ 75,155  SAY "Segmento 6" SIZE 45,8 PIXEL OF oPanel
	           @ 85,155  MSGET cSeg6 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	   
	           @ 105,15  SAY "Segmento 7" SIZE 45,8 PIXEL OF oPanel
	           @ 115,15  MSGET cSeg7 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	           
	           @ 105,155 SAY "Segmento 8" SIZE 45,8 PIXEL OF oPanel
	           @ 115,155 MSGET cSeg8 PICTURE "@!" SIZE 130,10 PIXEL F3 "T3" OF oPanel
	   
	    ACTIVATE WIZARD oWizard CENTERED
    
	    //-- O usuแrio deve informar ao menos um campo para realizar a atualiza็ใo.
	    If Empty(cVendedor) .And. Empty(cCnae) .And. Empty(cGrpVen) .And. Empty(cSeg1) .And. Empty(cSeg2) .And. ;
	    	Empty(cSeg3) .And. Empty(cSeg4) .And. Empty(cSeg5) .And. Empty(cSeg6) .And. Empty(cSeg7) .And. Empty(cSeg8)
    	
	    	MsgStop("Nใo foi possivel realizar a atualiza็ใo. ษ necessario informar pelo menos um campo.", cCadastro) 

	    Else
    
	    	//-- Inicia o processo de atualiza็ใo do cliente.
	    	Processa( { || FM010PrAtu(cVendedor,cCnae,cGrpVen,cSeg1,cSeg2,cSeg3,cSeg4,cSeg5,cSeg6,cSeg7,cSeg8) }, cCadastro, "Processando aguarde...", .F.)
    	
	    EndIf
	Else
		MsgStop("Nenhum registro selecionado. Favor marcar ao menos um registro.",cCadastro)
    EndIf
    
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010PrAtu |Autor: |David Alves dos Santos |Data: |21/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Fun็ใo para processar a atualiza็ใo dos clientes.               |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010PrAtu(cVendedor, cCnae, cGrpVen, cSeg1, cSeg2, cSeg3, cSeg4, cSeg5, cSeg6, cSeg7, cSeg8)
	
	Local aAreaSA1 := SA1->( GetArea() )
	Local nX       := 0
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	
	//-- Varre o array aCliente
	For nX := 1 To Len(aCliente)
		If aCliente[nX,1]
			IncProc( "Atualizando o cliente: " + aCliente[nX,2] )
			If SA1->(MsSeek(xFilial("SA1") + aCliente[nX,2]))
				//-- Atualiza a tabela SA1, apenas para os campos que foram preenchidos no wizard de atualiza็ใo.
				RecLock("SA1",.F.)
					SA1->A1_VEND   := Iif( Empty(cVendedor) ,SA1->A1_VEND   ,cVendedor ) 
					SA1->A1_CNAE   := Iif( Empty(cCnae)     ,SA1->A1_CNAE   ,cCnae     ) 
					SA1->A1_GRPVEN := Iif( Empty(cGrpVen)   ,SA1->A1_GRPVEN ,cGrpVen   ) 
					SA1->A1_SATIV1 := Iif( Empty(cSeg1)     ,SA1->A1_SATIV1 ,cSeg1     ) 
					SA1->A1_SATIV2 := Iif( Empty(cSeg2)     ,SA1->A1_SATIV2 ,cSeg2     ) 
					SA1->A1_SATIV3 := Iif( Empty(cSeg3)     ,SA1->A1_SATIV3 ,cSeg3     ) 
					SA1->A1_SATIV4 := Iif( Empty(cSeg4)     ,SA1->A1_SATIV4 ,cSeg4     ) 
					SA1->A1_SATIV5 := Iif( Empty(cSeg5)     ,SA1->A1_SATIV5 ,cSeg5     ) 
					SA1->A1_SATIV6 := Iif( Empty(cSeg6)     ,SA1->A1_SATIV6 ,cSeg6     ) 
					SA1->A1_SATIV7 := Iif( Empty(cSeg7)     ,SA1->A1_SATIV7 ,cSeg7     ) 
					SA1->A1_SATIV8 := Iif( Empty(cSeg8)     ,SA1->A1_SATIV8 ,cSeg8     ) 
				SA1->(MsUnLock())
				//-- Desmarca o cliente processado
				aCliente[nX,1]  := .F.
				If !Empty(cCnae)
					aCliente[nX,5]  := cCnae
					aCliente[nX,6]  := Posicione( "CC3" ,1 ,xFilial("CC3") + cCnae ,"CC3_DESC" )
					
					cCnaeAmi := AllTrim( Posicione( "CC3", 1, xFilial("CC3") + cCnae , "CC3_XCAMIG" ) )
					cCnaeAmi := AllTrim( Posicione( "SX5", 1, XFILIAL("SX5") + 'ZX' + cCnaeAmi , "X5_DESCRI"  ) )
					
					aCliente[nX,7]  := cCnaeAmi
				EndIf 
				aCliente[ nX,11 ] := Iif( !Empty( cSeg1 ) ,cSeg1 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg1 ,"X5_DESCRI" ) ,aCliente[ nX,11 ] )
				aCliente[ nX,12 ] := Iif( !Empty( cSeg2 ) ,cSeg2 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg2 ,"X5_DESCRI" ) ,aCliente[ nX,12 ] )
				aCliente[ nX,13 ] := Iif( !Empty( cSeg3 ) ,cSeg3 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg3 ,"X5_DESCRI" ) ,aCliente[ nX,13 ] )
				aCliente[ nX,14 ] := Iif( !Empty( cSeg4 ) ,cSeg4 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg4 ,"X5_DESCRI" ) ,aCliente[ nX,14 ] )
				aCliente[ nX,15 ] := Iif( !Empty( cSeg5 ) ,cSeg5 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg5 ,"X5_DESCRI" ) ,aCliente[ nX,15 ] )
				aCliente[ nX,16 ] := Iif( !Empty( cSeg6 ) ,cSeg6 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg6 ,"X5_DESCRI" ) ,aCliente[ nX,16 ] )
				aCliente[ nX,17 ] := Iif( !Empty( cSeg7 ) ,cSeg7 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg7 ,"X5_DESCRI" ) ,aCliente[ nX,17 ] )
				aCliente[ nX,18 ] := Iif( !Empty( cSeg8 ) ,cSeg8 + " - " + Posicione( "SX5" ,1 ,xFilial( "SX5" ) + "T3" + cSeg8 ,"X5_DESCRI" ) ,aCliente[ nX,18 ] )
				
 			EndIf
		EndIf	
	Next nX
	
	oLbx1:Refresh()
	
	//-- Apresenta mensaem de sucesso para o usuแrio.
	MsgInfo( "Cliente(s) atualizado(s) com sucesso!", cCadastro )
	
	RestArea( aAreaSA1 )
	
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010Mark  |Autor: |David Alves dos Santos |Data: |15/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Fun็ใo para marcar ou desmarcar todos os registros.             |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010Mark(lMark)

	Local nI   := 0
	Local nSum := 0
	
	nSum := Len( aCliente )
	ProcRegua( nSum )
	
	//-- Varre o aCliente para atualizar o Mark.
	For nI := 1 To Len( aCliente )
		IncProc()
		If lMark
			aCliente[ nI, 1 ] := .T.	//-- Marca
		Else
			aCliente[ nI, 1 ] := .F.	//-- Desmarca
		EndIf
	Next nI 
	
	oLbx1:Refresh()

Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |M010MrkCli |Autor: |David Alves dos Santos |Data: |15/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Marca็ใo de registro.                                           |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function M010MrkCli()
	
	Local lMark := aCliente[ oLbx1:nAt, 1 ]
	
	//-- Realiza a marca็ใo apenas se tiver registro na tela.
	If !Empty(aCliente[1,2])
		If lMark
			aCliente[ oLbx1:nAt, 1 ] := .F.	//-- Desmarca
		Else
			aCliente[ oLbx1:nAt, 1 ] := .T.	//-- Marca
		EndIf
	
		oLbx1:Refresh()
	EndIf
	
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010Array |Autor: |David Alves dos Santos |Data: |15/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Montagem do array de clientes.                                  |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010Array(cFiltro)
	
	Local nI       := 0
	Local nP       := 0
	Local nElem    := 0
	Local cCnaeAmi := ""
	Local cCnaeDsc := ""
	Local cQuery   := ""
	Local cTmp     := GetNextAlias()
	
	DEFAULT cFiltro := ""
	
	aCliente := {}
	
	//-- Montagem da Query.
	cQuery   := " SELECT a1.A1_COD, " 
	cQuery   += "        a1.A1_PESSOA, " 
	cQuery   += "        a1.A1_NOME, " 
	cQuery   += "        a1.A1_CNAE, " 
	cQuery   += "        a1.A1_EST, " 
	cQuery   += "        a1.A1_COD_MUN, " 
	cQuery   += "        a1.A1_MUN, " 
	cQuery   += "        a1.A1_CGC, " 
	cQuery   += "        a1.A1_VEND, "
	cQuery   += "        a1.A1_ULTCOM, "
	cQuery   += "        a1.A1_SATIV1, " 
	cQuery   += "        a1.A1_SATIV2, " 
	cQuery   += "        a1.A1_SATIV3, " 
	cQuery   += "        a1.A1_SATIV4, " 
	cQuery   += "        a1.A1_SATIV5, " 
	cQuery   += "        a1.A1_SATIV6, " 
	cQuery   += "        a1.A1_SATIV7, " 
	cQuery   += "        a1.A1_SATIV8, " 
	cQuery   += "        a1.A1_GRPVEN, "
	cQuery   += "        a1.R_E_C_N_O_, " 
	cQuery   += "        a3.A3_COD, " 
	cQuery   += "        a3.A3_XCANAL, "
	cQuery   += "        (SELECT Sum(F2_VALBRUT) AS Valor1 "
	cQuery   += "         FROM   SF2010 "
	cQuery   += "         WHERE  F2_FILIAL = '" + xFilial("SF2") + "' "
	cQuery   += "                AND F2_CLIENTE = A1.A1_COD "
	cQuery   += "                AND Substr(F2_EMISSAO, 1, 4) = '" + cValToChar(Year(Date())) + "' "
	cQuery   += "         GROUP  BY F2_CLIENTE,  "
	cQuery   += "                   Substr(F2_EMISSAO, 1, 4)) AS VlrAnoAtu, "
	cQuery   += "        (SELECT Sum(F2_VALBRUT) AS Valor2  "
	cQuery   += "         FROM   SF2010 "
	cQuery   += "         WHERE  F2_FILIAL = '" + xFilial("SF2") + "'  "
	cQuery   += "                AND F2_CLIENTE = A1.A1_COD "
	cQuery   += "                AND Substr(F2_EMISSAO, 1, 4) = '" + cValToChar(Year(Date())-1) + "'  "
	cQuery   += "         GROUP  BY F2_CLIENTE,  "
	cQuery   += "                   Substr(F2_EMISSAO, 1, 4)) AS VlrAnoPas  "
	cQuery   += " FROM   " + RetSqlName("SA1") + " a1 " 
	cQuery   += "        LEFT JOIN " + RetSqlName("SA3") + " a3 " 
	cQuery   += "               ON a1.A1_VEND = a3.A3_COD " 
	cQuery   += "        LEFT JOIN " + RetSqlName("CC3") + " cc3 " 
	cQuery   += "               ON a1.A1_CNAE = cc3.CC3_COD " 
	cQuery   += "        LEFT JOIN " + RetSqlName("SX5") + " x5 " 
	cQuery   += "               ON x5.X5_TABELA = 'ZX' "
	cQuery   += "              AND x5.X5_CHAVE = cc3.CC3_XCAMIG " 
	cQuery   += " WHERE  a3.A3_XCANAL = '" + aCanal[1] + "' " 
	
	//-- Filtro retornado pela classe FWFilter.
	If !Empty(cFiltro)
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
	EndIf
	
	cQuery   += "        AND a3.D_E_L_E_T_ = ' ' " 
	cQuery   += "        AND a1.D_E_L_E_T_ = ' ' "
	
	//-- Verifica se a tabela esta aberta.
	If Select(cTmp) > 0
		(cTmp)->(DbCloseArea())				
	EndIf
	
	//-- Execucao da query.
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
		
	(cTmp)->(dbGoTop())
	While (cTmp)->( !Eof() )
		aHead_Cli := {	'x',;
						'C๓digo',;
						'Nome',;
						'CNPJ',;
						'CNAE',;
						'Descri็ใo CNAE',;
						'CNAE Amigavel',;
						'Faturamento ' + cValToChar(Year(Date())-1),;
						'Faturamento ' + cValToChar(Year(Date())),;
						'UF',;
						'Cidade',;
						'Segmento 1',;
						'Segmento 2',;
						'Segmento 3',;
						'Segmento 4',;
						'Segmento 5',;
						'Segmento 6',;
						'Segmento 7',;
						'Segmento 8' }
						
						
						
		
		cCnaeDsc := AllTrim(Posicione("CC3", 1, xFilial("CC3") + (cTmp)->A1_CNAE, "CC3_DESC"))
		cCnaeAmi := AllTrim( Posicione( "CC3", 1, xFilial("CC3") + (cTmp)->A1_CNAE , "CC3_XCAMIG" ) )
		cCnaeAmi := AllTrim( Posicione( "SX5", 1, XFILIAL("SX5") + 'ZX' + cCnaeAmi , "X5_DESCRI"  ) )
		
		AAdd(aCliente, { .F.,;
						 (cTmp)->A1_COD,;										
						 (cTmp)->A1_NOME,;										
						 (cTmp)->A1_CGC,;										
						 Transform((cTmp)->A1_CNAE, PesqPict("SA1","A1_CNAE")),;
						 cCnaeDsc,;
						 cCnaeAmi,;										
						 Transform((cTmp)->VlrAnoPas, "@E 999,999,999.99"),;
						 Transform((cTmp)->VlrAnoAtu, "@E 999,999,999.99"),;
						 (cTmp)->A1_EST,;
						 (cTmp)->A1_MUN,;
						 Iif( Empty( (cTmp)->A1_SATIV1) ,"" ,(cTmp)->A1_SATIV1 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV1 ,"X5_DESCRI") ),;
						 Iif( Empty( (cTmp)->A1_SATIV2) ,"" ,(cTmp)->A1_SATIV2 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV2 ,"X5_DESCRI") ),;
						 Iif( Empty( (cTmp)->A1_SATIV3) ,"" ,(cTmp)->A1_SATIV3 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV3 ,"X5_DESCRI") ),;
						 Iif( Empty( (cTmp)->A1_SATIV4) ,"" ,(cTmp)->A1_SATIV4 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV4 ,"X5_DESCRI") ),;
						 Iif( Empty( (cTmp)->A1_SATIV5) ,"" ,(cTmp)->A1_SATIV5 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV5 ,"X5_DESCRI") ),;
						 Iif( Empty( (cTmp)->A1_SATIV6) ,"" ,(cTmp)->A1_SATIV6 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV6 ,"X5_DESCRI") ),;
						 Iif( Empty( (cTmp)->A1_SATIV7) ,"" ,(cTmp)->A1_SATIV7 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV7 ,"X5_DESCRI") ),;
						 Iif( Empty( (cTmp)->A1_SATIV8) ,"" ,(cTmp)->A1_SATIV8 + " - " + Posicione( "SX5" ,1 ,xFilial("SX5") + "T3" + (cTmp)->A1_SATIV8 ,"X5_DESCRI") ),;
						 (cTmp)->R_E_C_N_O_ })									
	
		(cTmp)->( DbSkip() )
	EndDo
	
	//-- Se nใo encontrar nada na tabe
	If Len(aCliente) == 0
		AAdd( aCliente, {.F., "", "", "", "","","","","","","","","","","","","","",""} )
	EndIf
		
	//-- Alimenta o aCliente para apresentar no browse.
   	oLbx1:SetArray( aCliente )
	oLbx1:bLine := { ||	{ Iif( 	aCliente[ oLbx1:nAt, 01 ], oMrk, oNoMrk ),;
								aCliente[ oLbx1:nAt, 02 ],;
								aCliente[ oLbx1:nAt, 03 ],;
								aCliente[ oLbx1:nAt, 04 ],;
								aCliente[ oLbx1:nAt, 05 ],;
								aCliente[ oLbx1:nAt, 06 ],;
								aCliente[ oLbx1:nAt, 07 ],;
								aCliente[ oLbx1:nAt, 08 ],;
								aCliente[ oLbx1:nAt, 09 ],;
								aCliente[ oLbx1:nAt, 10 ],;
								aCliente[ oLbx1:nAt, 11 ],;
								aCliente[ oLbx1:nAt, 12 ],;
								aCliente[ oLbx1:nAt, 13 ],;
								aCliente[ oLbx1:nAt, 14 ],;
								aCliente[ oLbx1:nAt, 15 ],;
								aCliente[ oLbx1:nAt, 16 ],;
								aCliente[ oLbx1:nAt, 17 ],;
								aCliente[ oLbx1:nAt, 18 ],;
						} } 

Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FTM010FILT |Autor: |David Alves dos Santos |Data: |15/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Tela de filtro personalizado.                                   |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FTM010FILT()

	Local oFWFilter  := Nil
	Local aColunas   := {}
	Local aRet       := {}
	Local aIndexSC1	 := {}
	Local cAuxFil    := "" 
	Local cQryFilter := ""
	
	Private bFiltraBrw := {|| {"","","",""}}
	Private cMarca     := GetMark()
	Private lInverte   := .F.
	
	//-- Campos que estarใo disponiveis no filtro (FWFilter).
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
	
	//-- Utiliza็ใo da classe FWFilter.
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


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010GerAg |Autor: |David Alves dos Santos |Data: |29/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Gera็ใo de agenda.                                              |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010GerAg()

	Local aSay      := {}
	Local aButton   := {}
	Local aPar      := {}
	Local aOriLst   := {}
	Local nOpcao    := 0
	Local nP        := 0
	Local nX        := 0
	Local cLog      := ""
	Local cDSaveLog := ""
	Local cFileLog  := ""
	
	Private cNomeLista := ""
	Private cMV_ORILST := GetMv('MV_ORILST2')+'|'
	Private aRet       := {}
	Private aFTM010Log := {}
	
	//------------------------------------
	// Monta tela de interacao com usuario
	//------------------------------------
	AAdd( aSay, "Gera็ใo de agendas."                                                                    )
	AAdd( aSay, ""                                                                                       )
	AAdd( aSay, "Os dados serใo gravados na tabela de importa็ใo de lista, logo serแ gerado cadastro do" )
	AAdd( aSay, "contato e agenda do operador conforme o c๓digo de consultor informado em cada"          )
	AAdd( aSay, "registro."                                                                              )
	AAdd( aSay, ""                                                                                       )
	AAdd( aSay, "Clique em OK para prosseguir"                                                           )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		
		//+-----------------------------+
		//| Cabe็alho do log de eventos |
		//+-----------------------------+
		AAdd( aFTM010Log, ";" + Replicate("-",200) )
		AAdd( aFTM010Log, ";"+"DESCRIวรO DA ROTINA: IMPORTAวรO DE LISTA DE CONTATOS")
		AAdd( aFTM010Log, ";"+"NOME DA ROTINA: " + FunName() )
		AAdd( aFTM010Log, ";"+"CำDIGO E NOME DO USUมRIO: " + __cUserID + " - " + Upper( RTrim( cUserName ) ) )
		AAdd( aFTM010Log, ";"+"DATA/HORA DA EXECUวรO DA ROTNA: " + Dtoc( MsDate() ) + " - " + Time() )
		AAdd( aFTM010Log, ";"+"NOME DA MมQUINA ONDE FOI EXECUTADO: " + GetComputerName() )
		AAdd( aFTM010Log, "" )
		AAdd( aFTM010Log, ";" + Replicate("-",200) )
		
		//+----------------------------------------------------------+
		//| Colocar cada nome de tipo de lista no elemento do vetor. |
		//+----------------------------------------------------------+
		While !Empty(cMV_ORILST)
			nP := At('|',cMV_ORILST)
			If nP > 0
				AAdd(aOriLst,SubStr(cMV_ORILST,1,nP-1))
				cMV_ORILST := SubStr(cMV_ORILST,nP+1)
			Endif
		EndDo
		
		//-- Apresenta tela apenas se existir lista de origem.
		If Len(aOriLst) > 0
			
			aRet := {}
			
			//-- Parametros utilizado na fun็ใo parambox.
			AAdd(aPar,{1,"Data da agenda",MsDate(),"99/99/99","","","",50,.T.})
			AAdd(aPar,{2,"Prioridade Atend.",1,{"1=Baixa","2=Alta"},80,"",.T.})
			AAdd(aPar,{2,"Nome da lista",1,aOriLst,80,"",.T.})
			AAdd(aPar,{1,"Complemento p/ nome lista",Space(99),"@!","","","",100,.F.})
			AAdd(aPar,{1,"Campanha",Space(6),"@!","Vazio().Or.ExistCpo('SUO')","SUO","",50,.F.})
		
			If ParamBox( aPar, "Parโmetros", @aRet,,,,,,,,.F.,.F.)
				
				//-- Tratamento da op็ใo Nome da Lista.
				If Valtype(aRet[3]) == "N"
					If !Empty(aRet[3])
						cNomeLista := AllTrim(aOriLst[aRet[3]]) + Iif( Empty(aRet[4]), "", " - " + AllTrim(aRet[4]))
					EndIf
				ElseIf Valtype(aRet[3]) == "C"
					If !Empty(aRet[3])
						cNomeLista := AllTrim(aOriLst[Val(aRet[3])]) + Iif( Empty(aRet[4]), "", " - " + AllTrim(aRet[4]))
					EndIf
				EndIf
				
				//-- Processamento da gera็ใo de agendas.
				MsAguarde( {|| FM010Dados()}, "Processamento", "Gerando agendas. Aguarde..." )
				
				//-- Gera็ใo do arquivo .log
				If MsgYesNo("Deseja salvar log de processamento?", cCadastro)
					cDSaveLog:= cGetFile( '*.txt' , 'Textos (TXT)', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
					For nX := 1 To Len(aFTM010Log)
						cLog += aFTM010Log[nX] + CRLF
					Next nX
					
					If !Empty( cLog )
						cFileLog := "log_csftm010-" + DTOS(Date()) + StrTran(Time(),":","") + ".txt"
						//-- Grava as informa็๕es do array em arquivo log.
						MemoWrite( cDSaveLog + cFileLog, cLog )
						If MsgYesNo("Deseja abrir o log de processamento?", cCadastro)
							//-- Abre o arquivo .log
							ShellExecute( "open", cFileLog, "", cDSaveLog, 1 )
						EndIf
					EndIf
				EndIf
				
				MsgInfo("Agendas geradas com sucesso!",cCadastro)
				
			EndIf
		EndIf
	EndIf
	
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010Dados |Autor: |David Alves dos Santos |Data: |29/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Tratamento de dados e grava็ใo.                                 |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010Dados()
	
	Local aArea      := GetArea()
	Local nX         := 0
	Local nUF        := 0
	Local aPAB       := {}
	Local aSU5       := {}
	Local cCNPJ      := ''
	Local cCPF       := ''
	Local cCpfCnpj   := ''
	Local cTEL       := ''
	Local cEMAIL     := ''
	Local cEstado    := ''
	Local cNOME      := ''
	Local cU4_XPRIOR := ''
	
	Private cU7_POSTO := ''
	Private lPAB_DESC := PAB->(FieldPos("PAB_DESC"))>0
	
	//-- Seleciona Tabelas.
	dbSelectArea("SA1")
	dbSelectArea("SA3")
	dbSelectArea("SU7")
	
	//-- Processa com base no array aCliente.
	For nX := 1 To Len(aCliente)
		If aCliente[nX,1]
			SA1->(dbSetOrder(1))
			If SA1->( MsSeek( xFilial("SA1") + aCliente[nX,2] ) )
				
				//-- Criticar se o consultor/vendedor existe, e logo capturar o c๓digo de operador.
				SA3->(dbSetOrder(1))
				If SA3->( MsSeek( xFilial( "SA3" ) + SA1->A1_VEND ) )
					
					//-- Capturar o c๓digo de operador do vendedor/consultor.
					SU7->(dbSetOrder(4))
					If SU7->( dbSeek( xFilial( "SU7") + SA3->A3_CODUSR ) )
						cU7_POSTO := SU7->U7_POSTO
						
						//-- Montar os vetores para serem gravados os seus dados.
						cNOME := Upper( RTrim( NoAcento( AnsiToOem( SA1->A1_NOME ) ) ) )
						AAdd( aPAB, { 'PAB_NOME'  ,cNOME } )
						AAdd( aSU5, { "U5_CONTAT" ,cNOME } )
						
						cEMAIL := AllTrim( Lower( SA1->A1_EMAIL ) )
						AAdd( aPAB, { 'PAB_EMAIL' ,cEMAIL } )
						AAdd( aSU5, { "U5_EMAIL"  ,cEMAIL } )
						
						AAdd( aPAB, { 'PAB_DDD' ,SA1->A1_DDD } )
						AAdd( aSU5, { "U5_DDD"  ,SA1->A1_DDD } )
						
						cTEL := AllTrim( SA1->A1_TEL )
						cTEL := FM010SoNum( cTEL )
						AAdd( aPAB, { 'PAB_TELEFO' ,cTEL } )
						AAdd( aSU5, { "U5_FONE"    ,cTEL } )
						AAdd( aSU5, { "U5_FCOM1"   ,cTEL } )
						
						AAdd( aPAB, { 'PAB_CELULA',cTEL } )
						AAdd( aSU5, { "U5_CELULAR",cTEL } )
												
						cCpfCnpj := AllTrim( SA1->A1_CGC )
						cCpfCnpj := FM010SoNum( cCpfCnpj )
						If SA1->A1_PESSOA == "F"
							AAdd( aPAB, { 'PAB_CPF'  ,cCpfCnpj } )
							AAdd( aPAB, { 'PAB_CNPJ' ,""       } )
						Else
							AAdd( aPAB, { 'PAB_CPF'  ,""       } )
							AAdd( aPAB, { 'PAB_CNPJ' ,cCpfCnpj } ) 
						EndIf
						
						//-- Tratamento da prioridade do atendimento.
						If ValType(aRet[4]) == "N"
							cU4_XPRIOR := cValToChar(aRet[4])
						ElseIf ValType(aRet[4]) == "C"
							cU4_XPRIOR := aRet[4]
						EndIf
												
						AAdd( aPAB, { 'PAB_EST',SA1->A1_EST } )
						AAdd( aSU5, { "U5_EST", SA1->A1_EST } )
						
						AAdd( aPAB, { Iif(lPAB_DESC,'PAB_DESC','PAB_DESCR'), "DESCRICAO" } )
						
						/*
						If nEMPRESA > 0     ; AAdd( aPAB, { 'PAB_EMPRES',  aDados[ nEMPRESA ] } )     ; Endif 
						If nRAMO_ATIV > 0   ; AAdd( aPAB, { 'PAB_ATIVID',  aDados[ nRAMO_ATIV ] } )   ; Endif 
						If nCARGO > 0       ; AAdd( aPAB, { 'PAB_CARGO',   aDados[ nCARGO ] } )       ; Endif 
						If nPROFISSAO > 0   ; AAdd( aPAB, { 'PAB_PROFIS',  aDados[ nPROFISSAO ] } )   ; Endif 
						If nENDERECO > 0    ; AAdd( aPAB, { 'PAB_END',     aDados[ nENDERECO ] } )    ; Endif 
						If nNUMERO > 0      ; AAdd( aPAB, { 'PAB_NUMEND',  aDados[ nNUMERO ] } )      ; Endif 
						If nCOMPLEMENTO > 0 ; AAdd( aPAB, { 'PAB_COMPL',   aDados[ nCOMPLEMENTO ] } ) ; Endif 
						If nBAIRRO > 0      ; AAdd( aPAB, { 'PAB_BAIRRO',  aDados[ nBAIRRO ] } )      ; Endif 
						If nCEP > 0         ; AAdd( aPAB, { 'PAB_CEP',     aDados[ nCEP ] } )         ; Endif 
						If nCIDADE > 0      ; AAdd( aPAB, { 'PAB_CIDADE',  aDados[ nCIDADE ] } )      ; Endif 
						If nDT_ATUALIZ > 0  ; AAdd( aPAB, { 'PAB_DTATUAL', aDados[ nDT_ATUALIZ ] } )  ; Endif 
						If nCONSULTOR > 0   ; AAdd( aPAB, { 'PAB_CONSUL',  aDados[ nCONSULTOR ] } )   ; Endif 
						*/
						
						AAdd( aPAB, { 'PAB_OPERAD',  SU7->U7_COD } )
						AAdd( aSU5, { "U5_ATIVO"  , "1" } )
						
						//-- Chama a rotina para grava็ใo dos dados.
						STATICCALL( CSFA160, FA160GRVDAD, aPAB, aSU5, cU4_XPRIOR )
						
					EndIf
					
				EndIf
				
			EndIf
			
		EndIf
		
		aCliente[nx,1] := .F.
		
	Next nX
	
	oLbx1:Refresh()
	
	RestArea( aArea )
	
Return


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |FM010SoNum |Autor: |David Alves dos Santos |Data: |29/09/2017   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Retira caracteres diferentes de numeros.                        |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function FM010SoNum( cVar )
	
	Local nI       := 0
	Local cAux     := ""
	Local cNumeros := "0123456789"
	
	//+--------------------------------------------------------------------+
	//| Varrer toda a variแvel e considerar somente o conte๚do em cNumeros |
	//+--------------------------------------------------------------------+
	For nI := 1 To Len( cVar )
		If SubStr( cVar, nI, 1 ) $ cNumeros
			cAux += SubStr( cVar, nI, 1 )
		Endif
	Next nI
	
Return( cAux )


















User Function CSFTM10A()
	
	Local cSQL     := ''
	Local cTRB     := ''
	Local cCODENT  := ''
	Local cEntida  := ''
	Local cNomeEnt := ''
	Local cOrdem   := ''
	Local cRet     := ''
	Local cSeek    := Space(60)
	Local nOrd     := 2
	Local nOpc     := 0
	Local aDados   := {}
	Local aOrdem   := {}
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oSeek
	Local oPesq
	Local oPnlTop
	Local oPnlAll
	Local oPnlBot
	Local ONOMRK
	Local oMrk
	
	Local aParam    := {}
	Local aRetParam := {}
	AAdd(aParam, {1, 'CNAE Amigavel', Space(TamSX3("X5_DESCRI")[1]),'@!',"",'','',60,.T.} )
	
	If ParamBox( aParam,'Informe o CNAE Amigavel',@aRetParam,,,,,,,,.F.,.F.)
	
		AAdd( aOrdem, 'Cod. CNAE' )
	
		//-- Montagem da query.
		cSQL += " SELECT cc3.CC3_FILIAL, " 
		cSQL += "        cc3.CC3_COD, " 
		cSQL += "        cc3.CC3_DESC, "
		cSQL += "        cc3.CC3_XCAMIG, " 
		cSQL += "        cc3.R_E_C_N_O_, "
		cSQL += "        x5.X5_DESCRI " 
		cSQL += " FROM  " + RetSqlName("CC3") + " cc3"
		cSQL += "        INNER JOIN " + RetSqlName("SX5") + " x5 "
		cSQL += "                ON x5.X5_TABELA = 'ZX' "
		cSQL += "               AND x5.X5_CHAVE =  cc3.CC3_XCAMIG "
		cSQL += " WHERE  cc3.D_E_L_E_T_ = ' ' "
		
		If !Empty(aRetParam[1])
			cSQL += "    AND UPPER(x5.X5_DESCRI ) LIKE '%" + AllTrim(aRetParam[1]) + "%' "
		EndIf
		
		cSQL += "    AND  x5.D_E_L_E_T_ = ' ' "
	
		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
		If (cTRB)->( !Eof() )
			While (cTRB)->( !Eof() )
				(cTRB)->( AAdd( aDados, { (cTRB)->CC3_COD, (cTRB)->X5_DESCRI, (cTRB)->CC3_DESC, (cTRB)->R_E_C_N_O_  } ) )
				(cTRB)->( dbSkip() )
			End
		Else
			MsgInfo('Aten็ใo, ' + CRLF + 'Nใo consta contato cadastrado para este ' +;
			   	'. Por favor inclua um contato do tipo Corporativo.','Contatos')
			AAdd( aDados, { '', '', '', ''  } )	
		EndIf
		(cTRB)->(dbCloseArea())
	
		//-- Montagem da tela que sera apresentado para o usuario no momento da acao da tecla F3.
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 308,770 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
	   
			oDlg:lEscClose := .F.
		
			oPnlTop       := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
			oPnlTop:Align := CONTROL_ALIGN_TOP
		
			@ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
			@ 1,082 MSGET    oSeek  VAR cSeek          SIZE 160,9 PIXEL OF oPnlTop
			@ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (CSFTM10Psq(nOrd,cSeek,@oLbx))
		
			oPnlAll := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
			oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
			oPnlBot := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
			oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
			oLbx := TwBrowse():New( 0, 0, 1000, 1020,, {'CNAE', 'CNAE Amigavel', 'Descri็ใo'},, oPnlAll,,,,,,,,,,,, .F.,, .T.,, .F. )
			oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray( aDados )
			oLbx:bLine := {|| { aDados[oLbx:nAt,1], aDados[oLbx:nAt,2], aDados[oLbx:nAt,3], '' } }

			oLbx:bLDblClick := {|| Iif(CSFTM10Cod(oLbx,@nOpc,@cRet,oLbx:nAt),oDlg:End(),Nil) }
	   
			@ 1,001 BUTTON oConfirm PROMPT 'OK'   SIZE 40,11 PIXEL OF oPnlBot ACTION Iif( CSFTM10Cod(oLbx,@nOpc,@cRet,oLbx:nAt), oDlg:End(), Nil )
			@ 1,044 BUTTON oCancel  PROMPT 'Sair' SIZE 40,11 PIXEL OF oPnlBot ACTION ( cCodFun := '', oDlg:End() )
	
		ACTIVATE MSDIALOG oDlg CENTER
	
		If nOpc == 1
			cCodFun := cRet
		EndIf
		
	EndIf
	
	
	
		
	
		
Return( .T. )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณCSFTM10Psq บAutor: ณDavid Alves dos Santos บData: ณ23/08/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina para pesquisar a informacao digitada e posicionar.   บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                          บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
			MsgStop('Registro nใo localizado.','Pesquisar')
		EndIf
	Else
		MsgStop('Op็ใo de pesquisa invแlida.',cCadastro)
	EndIf
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณCSFTM10Cod บAutor: ณDavid Alves dos Santos บData: ณ23/08/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina para retornar o codigo do funcionario conforme       บฑฑ
ฑฑบ           ณo posicionamento.                                           บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                          บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CSFTM10Cod( oLbx, nOpc, cRet, nLin )
	
	Local lRet := .T.
	
	cRet := AllTrim( oLbx:aArray[nLin,1] )
	nOpc := Iif( lRet, 1, 0 )
	
Return( lRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณFTM10Ret บAutor: ณDavid Alves dos Santos บData: ณ23/08/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณMatricula do funcionario no retorno da consulta padrao.     บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                          บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FTM10Ret()
Return( cCodFun )








