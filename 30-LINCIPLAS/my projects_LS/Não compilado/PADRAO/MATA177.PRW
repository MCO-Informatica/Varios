#INCLUDE "PROTHEUS.CH"   
#INCLUDE "MATA177.CH"
Static lTPLDRO		:= HasTemplate("DRO")
Static lTPBD		:= If(Upper(TcGetDb()) $ "ORACLE*DB2*POSTGRES", .T.,.F.) // Verifica se o banco e oracle 
Static oDadosPed 	:= NIL									//Objeto do tipo LJCColecao com os dados do pedido de compra
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MATA177     ³Autor  ³Vitor Raspa          ³Data  ³ 24-Mar-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Central de Compras                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function MATA177()
Local aAreaSM0      := {}
Local aAreaSX5      := {}
Local aAreaSBM      := {}
Local aAreaSX3      := {}
Local aCposFiltr    := {}
Local aFiliais      := {}
Local aTipos        := {}
Local aGrupos       := {}
Local aCategorias   := {}
Local bAction       := {||}
Local cFiltUsr      := ''
Local cFilCent      := Space(FWGETTAMFILIAL)
Local cPerg         := 'MTA177'
Local cLockBy       := 'MTA177INUSE'
Local cVarFil
Local cVarGrp
Local lInvFil
Local lNecess
Local lCategorias
Local lInvMat
Local lVarMat
Local lInvGrp
Local lShowScreen
Local lLog
Local oDlg
Local oChkInvFil
Local oLstFilial
Local oRadAnalisa
Local oGetFilCent
Local oChkNeces
Local oChkCateg
Local oChkInvMat
Local oLstTipo
Local oChkInvGrp
Local oLstGrp
Local oShowScreen
Local oFont
Local oLog
Local oOk           := LoadBitmap( GetResources(), 'LBOK')
Local oNo           := LoadBitmap( GetResources(), 'LBNO')
Local nRadAnls
Local nCount        := 0
Local nOpcA         := 0
Local nOrdem        := 0
Local lBonus	    := .F.		//Flag para indicar se sera' Pedido de Bonificacao    
Local cFiltroTPL    := "()"		//Filtro especifico para o Template Drogaria
Local aSelGrupos    := {}      //Array q guarda os Grupos que esta sendo usados  


Private aPARAM177   := {}
Private aLog        := {}
Private cCadastro   := STR0001 //--"Central de Compras"
Private lMsErroAuto := .F.
Private oProcess    := Nil

//-- Verificar release    
If cVersao == "P10"
	If !(GetRpoRelease() >= "R1.2")
		MsgAlert(STR0206, STR0205)
		Return()
	EndIf
EndIf

// -- Valida o compartilhamneto dos alias SC1 e SC7.
If a177MdAccess("SC1") .Or. a177MdAccess("SC7")
	MsgAlert(OemToAnsi(STR0266), STR0199) //"A rotina somente será processada caso não exista compartilhamento para as tabelas SC1 e SC7"
	Return()
EndIf 

//-- Ajustar Help
AjustaHelp()

//-- Ajustar SXB
AjustaSXB()

//-- Ajusta SX1
AjustaSX1( cPerg )

//-- Carregar o grupo de perguntas da rotina
Pergunte( cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                   ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³mv_par01      // Gerar?                                                 |
//|                   1-Compras                                            |
//|                   2-Distribuicao                                       ³
//³mv_par02      // Tipo Documento:                                        |
//|                   1-Sol. Compra                                        |
//|                   2-Pedido Compra                                      ³
//³mv_par03      // Doc Prev Entr na Origem?                               |
//|                   1-Sim                                                |
//|                   2-Nao                                                ³
//³mv_par04      // Tipo Documento:                                        |
//|                   1-Sol. Compra                                        |
//|                   2-Pedido Compra                                      ³
//³mv_par05      // Doc Prev Saida na Central?                             |
//|                   1-Sim                                                |
//|                   2-Nao                                                ³
//³mv_par06      // Tipo Calc Necess?                                      ³
//³                   1-(Est. Maximo-Est. Atual)+(Media Vendas X Periodos) ³
//³                   2-(Est. Maximo-Est.Atual)                            ³
//³                   3-Ponto de Pedido (Padrao Rot. Ponto Pedido)         ³
//³                   4-Formula propria do usuario (SM4)                   ³
//³mv_par07      // Formula?                                               ³
//³mv_par08      // Numero Periodos?                                       ³
//³mv_par09      // Tipo Periodo?                                          |
//|                   1-Dias                                               |
//|                   2-Semanas                                            |
//|                   3-Meses                                              ³
//³mv_par10      // Periodos Projecao?                                     ³
//³mv_par11      // Armazem De?                                            ³
//³mv_par12      // Armazem Ate?                                           ³
//³mv_par13      // Amarracao Prod X Forn?                                 |
//|                   1-Sim                                                |
//|                   2-Nao                                                ³
//³mv_par14      // Fornecedor De?                                         ³
//³mv_par15      // Fornecedor Ate?                                        ³
//³mv_par16      // Numero do Calculo?                                     ³
//³mv_par17      // Preco para Compra?                                     ³
//³                   1-Ultimo preco de Compra                             ³
//³                   2-Tabela de Preco informada                          ³
//³                   3-Custo Standard                                     ³
//³mv_par18      // Cod Tabela Preco?                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAreaSX3 := SX3->( GetArea() )
SX3->( DbSetOrder(1) )
If SX3->( DbSeek( 'SB1' ) )
	Do While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == 'SB1' 
		If X3Uso( SX3->X3_USADO ) .And. cNivel >= SX3->X3_NIVEL .And.; 
			!(AllTrim(SX3->X3_CAMPO) $ '|B1_GRUPO|B1_TIPO|B1_FILIAL|')
			AAdd( aCposFiltr, AllTrim( SX3->X3_CAMPO ) )
		EndIf
		SX3->( DbSkip() )
	EndDo
EndIf
RestArea( aAreaSX3 )

//--Montagem da Tela
Define MsDialog oDlg Title STR0001 From 0,0 To 390, 930 Of oMainWnd Pixel //--"Central de Compras"
	oFont := oDlg:oFont

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FILIAIS                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaSM0 := SM0->( GetArea() )
	@ 10,15  TO 160,197 Label STR0002 Of oDlg Pixel //--"Filiais"
	SM0->( DbSetOrder(1) ) 
	SM0->( DbSeek( cEmpAnt ) )
	Do While SM0->( !Eof() ) .And. SM0->M0_CODIGO == cEmpAnt
		AAdd( aFiliais, { .T., FWGETCODFILIAL, Capital( SM0->M0_FILIAL ) } )
		SM0->( DbSkip() )
	EndDo
	RestArea( aAreaSM0 )

	@ 23,25 CheckBox oChkInvFil ; 
			Var lInvFil 		; 
			Prompt STR0003 		; //--"Inverter selecao"
			Size 70,10 			;
			On Click (AEval( aFiliais, {|x| x[1] := If(x[1]==.T., .F., .T.)}), oLstFilial:Refresh(.F.)) ;
			Of oDlg Pixel 		;
			Font oFont

	@ 34,25 ListBox oLstFilial 	;
			Var cVarFil 		;
			Fields Header '', STR0004, STR0005 ; //--"Filial"#"Descricao"
			Size 160,81 		;
			On DblClick ( aFiliais[oLstFilial:nAt,1] := !aFiliais[oLstFilial:nAt,1] ) ;
			Of oDlg Pixel 		;
			Font oFont

	oLstFilial:SetArray( aFiliais )
	oLstFilial:bLine := { || {If(aFiliais[oLstFilial:nAt,1],oOk,oNo),aFiliais[oLstFilial:nAt,2],aFiliais[oLstFilial:nAt,3]}}
	
	@ 121,025 RADIO oRadAnalisa ;
				VAR nRadAnls 	;
				ITEMS STR0006, STR0007 ; //--"Analisa estoque por filial"#"Utiliza a seguinte filial como Centralizadora:"
				SIZE 125,12 	;
				OF oDlg PIXEL 	;
				ON Change If(nRadAnls == 2,oGetFilCent:Enable(),oGetFilCent:Disable())
	
	oRadAnalisa:oFont := oFont

	@ 131,145 MSGET oGetFilCent ;
				VAR cFilCent PICTURE '@!' ;
				SIZE 40,10 		;
				PIXEL OF oDlg 	;
				Font oFont

	oGetFilCent:Disable()	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PRODUTOS               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 10,210 To 160,450 Label STR0008 Of oDlg Pixel //--"Produtos"

	@ 18,220 CHECKBOX oChkNeces	;
			 VAR lNecess 		;
			 Prompt STR0009 	; //--"Exibir somente produtos com necessidade"
			 SIZE 130,10 		;
			 OF oDlg PIXEL 		;
			 Font oFont

	@ 28,220 CHECKBOX oChkCateg ;
			 VAR lCategorias 	;
			 Prompt STR0010 	; //--"Apresentar filtro por categoria"
			 SIZE 130, 10 		;
			 On Click ( A177Categ( @aCategorias, lCategorias ) ) ;
			 OF oDlg PIXEL 		;
			 Font oFont
	
	//-- TIPOS DE PRODUTOS
	aAreaSX5 := ( GetArea() )
	SX5->( DbSetOrder(1) )
	SX5->( DbSeek( xFilial('SX5') + '02' ) )
	Do While !SX5->( Eof() ) .And. SX5->( X5_FILIAL + X5_TABELA ) == xFilial('SX5') + '02'
		AAdd( aTipos, {	.T.,; 
						PadR( SX5->X5_CHAVE, Len(SB1->B1_TIPO) ),;
						Capital(X5Descri()) } )

		SX5->( DbSkip() )
	EndDo
	RestArea( aAreaSX5 )
	
	@ 38,220 CHECKBOX oChkInvMat 	;
			 VAR lInvMat 			;
			 PROMPT STR0003 		; //--"Inverter selecao"
			 SIZE 70, 10 			;
			 OF oDlg PIXEL 			;
			 ON CLICK (AEval(aTipos , {|x| x[1] := If(x[1],.F.,.T.)}), oLstTipo:Refresh(.F.)) ;
			 Font oFont

	@ 49,220 LISTBOX oLstTipo 		;
			 VAR lVarMat 			;
			 Fields HEADER '', STR0011, STR0012 ; //--"Codigo"#"Descricao"
			 SIZE 105,81 			;
			 On DblClick ( aTipos[oLstTipo:nAt,1] := !aTipos[oLstTipo:nAt,1] ) ;
			 OF oDlg PIXEL 			;
			 Font oFont

	oLstTipo:SetArray( aTipos )
	oLstTipo:bLine := { || {If( aTipos[oLstTipo:nAt,1], oOk, oNo), aTipos[oLstTipo:nAt,2], aTipos[oLstTipo:nAt,3] } }

	@ 135,220 BUTTON STR0013 ; //--"Regra de filtragem"
			  ACTION cFiltUsr := BuildExpr( 'SB1',, cFiltUsr, .T.,,, aCposFiltr ) ;
			  SIZE 105, 11 ;
			  OF oDlg FONT oFont PIXEL
	
	//--GRUPOS DE PRODUTOS
	aAdd( aGrupos, {.T., Criavar('B1_GRUPO',.F.), STR0014} ) //--"Grupo em Branco"
	aAreaSBM := SBM->( GetArea() )
	SBM->( DbSetOrder(1) )
	SBM->( DbSeek( xFilial('SBM') ) )
	Do While !SBM->( Eof() ) .And. SBM->BM_FILIAL == xFilial('SBM') 	
		AAdd( aGrupos, { .T., SBM->BM_GRUPO, Capital(SBM->BM_DESC) } )
		SBM->( DbSkip() )
	EndDo
	RestArea( aAreaSBM ) 

	@ 39,330 CHECKBOX oChkInvGrp	;
			 VAR lInvGrp 			;
			 Prompt STR0003 		; ///--"Inverter selecao"
			 SIZE 70, 10 			;
			 OF oDlg PIXEL 			;
			 ON CLICK (AEval(aGrupos, {|x| x[1] := If(x[1], .F., .T.)}), oLstGrp:Refresh(.F.)) ;
			 Font oFont

	@ 49,330 LISTBOX oLstGrp 		;
			 VAR cVarGrp 			;
			 Fields HEADER '', STR0011, STR0012 ; //--"Codigo"#"Descricao"
			 SIZE 110,081 			;
			 On DblClick ( aGrupos[oLstGrp:nAt,1] := !aGrupos[oLstGrp:nAt,1] ) ;
			 OF oDlg PIXEL 			;
			 Font oFont

	oLstGrp:SetArray( aGrupos )
	oLstGrp:bLine := { || { If( aGrupos[oLstGrp:nAt,1], oOk, oNo), aGrupos[oLstGrp:nAt,2], aGrupos[oLstGrp:nAt,3] }}
	If lTPLDRO
		lShowScreen := .T.
	Endif
	@ 135,330 BUTTON STR0015 		; //--"Regra de ordenacao"
			  ACTION nOrdem := A177Ordem( lShowScreen ) ;
			  SIZE 110, 11 			;
			  OF oDlg 				;
			  FONT oFont PIXEL

	If !lTPLDRO
		@ 165,20 CHECKBOX oShowScreen ;
				 VAR lShowScreen 	;
				 Prompt STR0138 	; //--"Exibir tela apos o Processamento"
				 SIZE 120,10 		;
				 OF oDlg PIXEL 		;
				 Font oFont
	Else
		@ 165,20 CHECKBOX oShowScreen ;
				 VAR lBonus 		;
				 Prompt STR0208 	; //--"Pedido de Bonificacao"
				 SIZE 120,10 		;
				 OF oDlg PIXEL 		;
				 Font oFont
	Endif

	@ 175,20 CHECKBOX oLog 			;
			 VAR lLog 				;
			 Prompt STR0139 		; //--"Gerar Log de processamento"
			 SIZE 120,10 			;
			 OF oDlg PIXEL 			;
			 Font oFont

	//--BOTOES        
	If lTPLDRO
		@170,279 BUTTON STR0207	ACTION (cFiltroTPL := T_DRO0011()) SIZE 40, 11 OF oDlg PIXEL //"Filtro Drogaria"
	Endif
	Define SButton From 170,350 Type 5 Action Pergunte(cPerg,.T.) Enable Of oDlg Font oFont
	Define SButton From 170,380 Type 1 Action If( A177VldPar( aFiliais, nRadAnls, cFilCent, lShowScreen, lNecess,; 
																lCategorias, aCategorias, aGrupos, aTipos, cFiltUsr,;
																nOrdem,lLog,@aSelGrupos ),;
																(nOpcA:= 1, oDlg:End()), nOpcA:= 0 ) Enable Of oDlg Font oFont

	Define SButton From 170,410 Type 2 Action (nOpcA:= 0, oDlg:End()) Enable Of oDlg Font oFont
	
Activate MSDialog oDlg Centered

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXECUTA O PROCESSAMENTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA == 1
	bAction := {|lEnd| A177ProcTop( @lEnd,cFiltroTPL,lBonus,@aSelGrupos ) }

	oProcess := MsNewProcess():New( bAction, STR0016, STR0017,.T.)
	oProcess:Activate()	
EndIf

Return    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177ProcTop ³Autor  ³Vitor Raspa          ³Data  ³  24-Mar-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Processamento das Necessidades (Topconnect)                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177ProcTop( lEnd,cFiltroTPL,lBonus,aSelGrupos )
Local cAliasTrb   	:= '' //--Alias contendo todas as informacoes necessarias para os calculos
Local cCondicao   	:= 'QTDNEC > 0' //--Condicao usada para filtrar alias de trabalho
Local nTotReg     	:= 0 //--Contador do total de registros retornados

//--Ponto de entrada para manipular a formula de calculo da necessidade
Local lMTA177Qry  	:= ExistBlock('MTA177Qry')
Local aMTA177Qry  	:= {}
If lTPLDRO
	oDadosPed 		:= LJCColecao():Colecao()    
Endif

//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0140 ) //--"Inicio do Processo"
EndIf

If !Empty( aPARAM177[16] )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³OBTEM O CALCULO INFORMADO PELO USUARIO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A177GetCalc( @cAliasTrb,cFiltroTPL )
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³TRATA ALIAS DE TRABALHO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:SetRegua1( If( aPARAM177[01] == 1, 2, 3 ) )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MONTAGEM DA QUERY - SALDOS x FILIAL CENTRAL³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:IncRegua1( STR0047 + aPARAM177[21] + ' - ' + AllTrim( GetAdvFval( 'SM0','M0_FILIAL', cEmpAnt + aPARAM177[21], 1 ) ) ) //--"Filial: "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PONTO DE ENTRADA PARA MANIPULAR A QUERY PRINCIPAL³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMTA177Qry
		//--CALCULO ESPECIFICO - PONTO DE ENTRADA
		aMTA177Qry := ExecBlock('MTA177Qry', .F., .F., {aPARAM177} )
		
		If ValType( aMTA177Qry ) <> 'A'
			aMTA177Qry := {}
		EndIf
		//--RETORNO ESPERADO DO PONTO DE ENTRADA: 
		//--Array com os seguintes elementos:
		//--[01]Sub-query ou funcao SQL para obter a qtd. da necessidade;
		//--[02]Join's a serem acrescidos (Opcional);
		//--[03]Condicoes a serem acrescidas na clausula "Where" (Opcional);
		//--[04]Campos a serem acrescidos na clausula "Group By" (Opcional);
	EndIf	
	
	//--QUERY PRINCIPAL PARA PROCESSAMENTO
	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0145 ) //--"Selecionando registros no arquivo de trabalho"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do alias de trabalho de acordo com  ³
	//³o processo selecionado                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPARAM177[01] == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PROCESSO DE COMPRAS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		A177Compra( @cAliasTrb, lMTA177Qry, aMTA177Qry,cFiltroTPL )
	ElseIf aPARAM177[01] == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PROCESSO DE DISTRIBUICAO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		A177Distribui( @cAliasTrb, lMTA177Qry, aMTA177Qry,cFiltroTPL )
	EndIf
	
	//--Visualizar apenas produtos com necessidade?
	If (aPARAM177[06] == 1 .Or. aPARAM177[06] == 2) .And. aPARAM177[23]
		(cAliasTrb)->( DbSetFilter({|| &cCondicao}, cCondicao ) )
  		(cAliasTrb)->( dbGoTop() )
	EndIf

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0147 ) //--"Obtendo o total de registros a serem processados"
	EndIf

	A177TotReg(cAliasTrb, @nTotReg) //--Obtem a qtde. de registros no alias de trabalho

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0148 + AllTrim( Str( nTotReg ) ) ) //--"Total de registros obtido. Total: "
	EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PROCESSAMENTO DOS RESULTADOS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cAliasTrb)->( Eof() )
	Help( ' ', 1, 'MATA17701' )
Else
	A177Resumo( @lEnd, cAliasTrb, nTotReg,lBonus,@aSelGrupos )
EndIf

//--Fecha a area corrente
(cAliasTrb)->( DbCloseArea() )

//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0150, .T. ) //--"Fim do Processo"
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A177TotReg ³ Autor ³ Emerson Rony Oliveira    ³ Data ³21/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o total de registros do alias de trabalho              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void A177TotReg(ExpC1, ExpN1)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias de trabalho a ser analisado                      ³±±
±±³          ³ ExpN1 = Variavel que recebera a quantidade total de regitros   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177TotReg( cAliasTrb, nTotReg )
(cAliasTrb)->(dbGoTop())
Do While !(cAliasTrb)->(Eof())
	nTotReg += 1
	(cAliasTrb)->(dbSkip())
EndDo
(cAliasTrb)->(dbGoTop())
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A177GetCalc³ Autor ³ Emerson Rony Oliveira    ³ Data ³11/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Monta o alias de trabalho a partir dos parametros selecionados ³±±
±±³          ³ pelo usuario quando ele informa um calculo ja gravado          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void A177GetCalc(ExpC1)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias de trabalho a ser montado                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177GetCalc( cAliasTrb,cFiltroTPL )
Local cFilSA2     := If( a177MdAccess("SA2"), "'"+FWxFilial('SA2')+"'", 'AIE.AIE_FILNEC' )
Local cFilSB1     := If( a177MdAccess("SB1"), "'"+FWxFilial('SB1')+"'", 'AIE.AIE_FILNEC' )
Local cQuery      := ''     
Local cDadosProd  := Upper(SuperGetMV('MV_ARQPROD', .F., 'SB1' ))

cQuery := "SELECT AIE.AIE_NUM NUMCALC "
cQuery +=     " , AIE.AIE_DTCALC DTCALC "
cQuery +=     " , AIE.AIE_FILCEN FILCEN "
cQuery +=     " , AIE.AIE_FILNEC FILNEC "
cQuery +=     " , AIE.AIE_CODPRO CODPRO "
cQuery +=     " , SB1.B1_DESC DESPRO "
cQuery +=     " , SB1.B1_GRUPO GRUPO "
cQuery +=     " , SB1.B1_TIPO TIPO "
cQuery +=     " , AIE.AIE_EMAX EMAX "
cQuery +=     " , AIE.AIE_NECESS QTDNEC "
cQuery +=     " , AIE.AIE_NECDIG QTDDIG "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDAR O TIPO DE CALCULO GRAVADO:                  ³
//|SE FOR COMPRAS, DEVE-SE FAZER JOIN COM A TABELA SA2 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aPARAM177[01] == 1 // Compras
	cQuery += " , SA2.A2_CGC CNPJFOR "
Else
	cQuery += " , '' CNPJFOR "
EndIf

cQuery +=     " , AIE.AIE_SLDCEN SLDFILCEN "
cQuery +=     " , AIE.AIE_SLDNEC SLDFILNEC "
cQuery +=     " , AIE.AIE_MEDVEN MEDVENDAS "     

If lTPLDRO 
	cQuery += ",SB1.B1_MINCUS MENOR_CUSTO,"
	cQuery += "SB1.B1_DMINCUS DT_MENOR_CUSTO," 
	cQuery += "SB1.B1_UPRC ULTIMA_COMRA,"   
	cQuery += "SB1.B1_UCOM DT_ULT_COMPRA," 					
	cQuery += "SB1.B1_MAXCUS MAIOR_CUSTO,"
	cQuery += "SB1.B1_DMAXCUS DT_MAIOR_CUSTO,"   
	cQuery += "SB1.B1_CODFAB COD_FABRICANTE,"
	cQuery += "SB1.B1_LOJA	LOJ_FABRICANTE,"	
	cQuery += "SB1.B1_UM UNIDADE_MEDIDA "
Endif
cQuery +=  " FROM " + RetSQLTab('AIE') 
cQuery +=     " , " + RetSQLTab('SB1') 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDAR O TIPO DE CALCULO GRAVADO:                  ³
//|SE FOR COMPRAS, DEVE-SE FAZER JOIN COM A TABELA SA2 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aPARAM177[01] == 1 // Compras
  cQuery += " , " + RetSQLTab('SA2')
EndIf

cQuery += " WHERE AIE.AIE_NUM    = '" + aPARAM177[16] + "' "
cQuery +=   " AND AIE.D_E_L_E_T_ = ' ' "
cQuery +=   " AND SB1.B1_FILIAL  = " + cFilSB1 + " "
cQuery +=   " AND SB1.B1_COD     = AIE.AIE_CODPRO "
cQuery +=   " AND SB1.D_E_L_E_T_ = ' ' "    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDAR O TIPO DE CALCULO GRAVADO:                  ³
//|SE FOR COMPRAS, DEVE-SE FAZER JOIN COM A TABELA SA2 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aPARAM177[01] == 1 // Compras
	cQuery += " AND SA2.A2_FILIAL  = " + cFilSA2 + " "
	cQuery += " AND SA2.A2_COD     = AIE.AIE_CODFOR "
	cQuery += " AND SA2.A2_LOJA    = AIE.AIE_LOJFOR "
	cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
EndIf

If lTPLDRO   
	If cDadosProd == 'SBZ'
		cQuery += " AND SBZ.BZ_SUSPENC <> '1' "			
	Else
		cQuery += " AND SB1.B1_SUSPENC <> '1' "						
	Endif
	If cFiltroTPL <> "()"  
		cQuery += " AND " + cFiltroTPL  // ADICIONA O FILTROS DE DROGARIA NA QUERY 
	Endif
Endif        
	
//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0141 + aPARAM177[16] + ')' ) //--"Obtendo calculo ja realizado anteriormente (N.o do calculo: "
EndIf

//--Executa a Query
cAliasTrb := GetNextAlias()
cQuery    := ChangeQuery( cQuery )
DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTrb, .T., .F. )
       
//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0142 ) //--"Calculo obtido com sucesso!"
EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A177Compra ³ Autor ³ Emerson Rony Oliveira    ³ Data ³07/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Monta o alias de trabalho a partir dos parametros selecionados ³±±
±±³          ³ pelo usuario para o processo de Compras                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void A177Compra(ExpC1, ExpL1, ExpA1)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias de trabalho a ser montado                        ³±±
±±³          ³ ExpL1 = Variavel que indica se existe ou nao o PE              ³±±
±±³          ³ ExpA1 = Array contendo as sentencas SQL retornadas pelo PE     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177Compra( cAliasTrb, lMTA177Qry, aMTA177Qry,cFiltroTPL )
Local cFiliaisIn  := ''
Local cFilSF4     := If( a177MdAccess("SF4"), "'"+FWxFilial('SF4')+"'", 'SB2.B2_FILIAL' )
Local cFilSA5     := If( a177MdAccess("SA5"), "'"+FWxFilial('SA5')+"'", 'SB2.B2_FILIAL' )
Local cFilSA2     := If( a177MdAccess("SA2"), "'"+FWxFilial('SA2')+"'", 'SB2.B2_FILIAL' )
Local cSaldoSB2   := '' //--Formula para obter o saldo em estoque
Local cFormNec    := '' //--Formula para calcular a necessidade
Local cQuery      := '' //--Sentenca para obter os produtos a serem analisados
Local cQuery2     := '' //--Query para condição CASE
Local cDadosProd  := Upper(SuperGetMV( 'MV_ARQPROD', .F., 'SB1' ))
Local aDatas      := A177CalcDt( aPARAM177[08], aPARAM177[09] ) // Retorno da Data inicial e final
Local dDtIni      := aDatas[1]
Local dDtFim      := aDatas[2]
Local lConsPrev   := If( SuperGetMV( 'MV_QTDPREV', .F., 'N' ) == 'S', .T., .F. )
Local nCount      := 0   

//--MONTA EXPRESSAO PARA FILTRO DAS FILIAIS SELECIONADAS...
cFiliaisIn := '('
For nCount := 1 To Len( aPARAM177[19] )
	cFiliaisIn += "'" + aPARAM177[19,nCount] + "'"
	If nCount < Len( aPARAM177[19] )
		cFiliaisIn += ','
	EndIf
Next
cFiliaisIn += ')'

//--FORMULA PARA OBTER O SALDO EM ESTOQUE:	
cSaldoSB2 := "SUM(SB2.B2_QATU) - "
cSaldoSB2 += "SUM(SB2.B2_RESERVA) - "
cSaldoSB2 += "SUM(SB2.B2_QEMP) - "
cSaldoSB2 += "SUM(SB2.B2_QACLASS) - "
cSaldoSB2 += "SUM(SB2.B2_QEMPSA) " 
cSaldoSB2 += If( lConsPrev, " - SUM(SB2.B2_QEMPPRE) ", "" ) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³QUERY PRINCIPAL PARA SELECIONAR OS PRODUTOS A SEREM CALCULADOS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Criar a query da tabela temporaria 
cQuery := "SELECT SB2.B2_FILIAL FILNEC "
cQuery +=     " , SB2.B2_COD CODPRO "
cQuery +=     " , SB1.B1_DESC DESPRO "
cQuery +=     " , SB1.B1_GRUPO GRUPO "
cQuery +=     " , SB1.B1_TIPO TIPO "
cQuery += If( cDadosProd == 'SB1', " , SB1.B1_EMAX EMAX ", " , SBZ.BZ_EMAX EMAX " )

//--SALDO NA FILIAL CENTRALIZADORA
cQuery +=     " , 0 SLDFILCEN "

//--CONSIDERA A AMARRACAO PRODUTO x FORNECEDOR
If aPARAM177[13] == 1
  // Retornar o primeiro fornecedor associado ao produto
	cQuery +=     " , (SELECT MIN(SA2.A2_CGC) "
	cQuery +=          " FROM " + RetSQLTab('SA2')
	cQuery +=         " WHERE SA2.A2_COD     = (SELECT MIN(SA5.A5_FORNECE) "
	cQuery +=                                   " FROM " + RetSQLTab('SA5')
	cQuery +=                                  " WHERE SA5.A5_FILIAL  = "+ cFilSA5 +" "
	cQuery +=                                    " AND SA5.A5_PRODUTO = SB2.B2_COD "
	cQuery +=                                    " AND SA5.D_E_L_E_T_ = ' ' "
	cQuery +=                                    " AND SA2.A2_LOJA = SA5.A5_LOJA ) "
	cQuery +=           " AND SA2.A2_FILIAL  = "+ cFilSA2 +" "
	cQuery +=           " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery +=       " ) CNPJFOR "
	
    cQuery +=     " , (SELECT MIN(SA2.A2_COD) "
	cQuery +=          " FROM " + RetSQLTab('SA2')
	cQuery +=         " WHERE SA2.A2_COD     = (SELECT MIN(SA5.A5_FORNECE) "
	cQuery +=                                   " FROM " + RetSQLTab('SA5')
	cQuery +=                                  " WHERE SA5.A5_FILIAL  = "+ cFilSA5 +" "
	cQuery +=                                    " AND SA5.A5_PRODUTO = SB2.B2_COD "
	cQuery +=                                    " AND SA5.D_E_L_E_T_ = ' '"
	cQuery +=                                    " AND SA2.A2_LOJA = SA5.A5_LOJA  ) "
	cQuery +=           " AND SA2.A2_FILIAL  = "+ cFilSA2 +" "
	cQuery +=           " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery +=       " ) CODFOR "
	
	cQuery +=     " , (SELECT MIN(SA2.A2_LOJA) "
	cQuery +=          " FROM " + RetSQLTab('SA2')
	cQuery +=         " WHERE SA2.A2_COD     = (SELECT MIN(SA5.A5_FORNECE) "
	cQuery +=                                   " FROM " + RetSQLTab('SA5')
	cQuery +=                                  " WHERE SA5.A5_FILIAL  = "+ cFilSA5 +" "
	cQuery +=                                    " AND SA5.A5_PRODUTO = SB2.B2_COD "
	cQuery +=                                    " AND SA5.D_E_L_E_T_ = ' '"
	cQuery +=                                    " AND SA2.A2_LOJA = SA5.A5_LOJA ) "
	cQuery +=           " AND SA2.A2_FILIAL  = "+ cFilSA2 +" "
	cQuery +=           " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery +=       " ) LOJA "

ElseIf aPARAM177[13] == 2
	cQuery +=     " , (SELECT SA2.A2_CGC "
	cQuery +=          " FROM " + RetSQLTab('SA2')
	cQuery +=         " WHERE SA2.A2_COD     = SB1.B1_PROC "
	cQuery +=           " AND SA2.A2_LOJA    = SB1.B1_LOJPROC "
	cQuery +=           " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery +=       " ) CNPJFOR "
	
    cQuery +=     " , (SELECT SA2.A2_COD "
	cQuery +=          " FROM " + RetSQLTab('SA2')
	cQuery +=         " WHERE SA2.A2_COD     = SB1.B1_PROC "
	cQuery +=           " AND SA2.A2_LOJA    = SB1.B1_LOJPROC "
	cQuery +=           " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery +=       " ) CODFOR "
	
    cQuery +=     " , (SELECT SA2.A2_LOJA "
	cQuery +=          " FROM " + RetSQLTab('SA2')
	cQuery +=         " WHERE SA2.A2_COD     = SB1.B1_PROC "
	cQuery +=           " AND SA2.A2_LOJA    = SB1.B1_LOJPROC "
	cQuery +=           " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery +=       " ) LOJA "

EndIf

//-- Query para obter o Total de Quantidade Prevista, será considerada quando o PE: MT177QRY não existir --
//-- e quando o Tipo de Tratamento for Com Aglutinação --
If AliasInDic("SDP") .And. !lMTA177Qry .And. !Empty(aParam177[21]) .And. aPARAM177[34]=2
	cQuery2 :=    " (Select SUM(DP_QUANT-DP_QTDENT) " 
	cQuery2 +=    "    FROM " + RetSQLTab('SDP')
	cQuery2 +=    "   WHERE SDP.DP_FILIAL  = '"+xFilial('SDP')+"'"                
	cQuery2 +=    "     AND SDP.DP_FILCEN  = '"+aParam177[21]+"'"
	cQuery2 +=    "     AND SDP.DP_FILNEC  = SB2.B2_FILIAL "
	cQuery2 +=    "     AND SDP.DP_CODPRO  = SB2.B2_COD    "
	cQuery2 +=    "     AND SDP.D_E_L_E_T_  = ' ' )         "
	
EndIf

//--SALDO NA FILIAL ONDE HA NECESSIDADE
cQuery +=     " , (" + cSaldoSB2 + ") "     
If AliasInDic("SDP") .And. !lMTA177Qry .And. !Empty(aParam177[21]) .And. aPARAM177[34]=2
    cQuery += " + Case When "+cQuery2+" Is Null then 0"
    cQuery += " Else "+cQuery2+" End"+" SLDFILNEC "
Else
    cQuery +=" SLDFILNEC "
Endif

//--MEDIA DE VENDAS NO PERIODO
cQuery += " ,ROUND (" + If(lTPBD ,"COALESCE( ","ISNULL (" )  
cQuery +=     " ((SELECT (SUM(SD2.D2_QUANT) / " + If( !lTPLDRO , AllTrim( Str(aPARAM177[08]) ), T_DroQuery(lTPBD) ) + ") "
cQuery +=                   " FROM " + RetSQLTab('SD2') 
cQuery +=                      " , " + RetSQLTab('SF4')
cQuery +=                  " WHERE SD2.D2_FILIAL        = SB2.B2_FILIAL "
cQuery +=                    " AND SD2.D2_COD           = SB2.B2_COD "
cQuery +=                    " AND SD2.D2_TIPO          = 'N' "
cQuery +=                    " AND SD2.D2_EMISSAO BETWEEN '" + DtoS( dDtIni ) + "' AND '" + DtoS( dDtFim ) + "' "
cQuery +=                    " AND SD2.D_E_L_E_T_       = ' ' "
cQuery +=                    " AND SF4.F4_FILIAL        = " + cFilSF4 + " "
cQuery +=                    " AND SF4.F4_CODIGO        = SD2.D2_TES "
cQuery +=                    " AND SF4.F4_ESTOQUE       = 'S' "
cQuery +=                    " AND SF4.D_E_L_E_T_       = ' ' "
cQuery +=                  " GROUP BY SD2.D2_FILIAL "
cQuery +=                         " , SD2.D2_COD "
cQuery +=                " )),0),2) MEDVENDAS, "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CALCULO DA NECESSIDADE  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTA177Qry .And. Len( aMTA177Qry ) >= 1 .And. ValType( aMTA177Qry[1] ) == 'C' .And. !Empty( aMTA177Qry[1] )
	cFormNec := aMTA177Qry[1] + " "
Else
	If aPARAM177[06] == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³(ESTOQUE MAXIMO - ESTOQUE ATUAL) + (MEDIA VENDAS * NUMERO PERIODOS PROJECAO)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFormNec := " ( " + If( cDadosProd == 'SB1', "SB1.B1_EMAX - ", "SBZ.BZ_EMAX - " ) + " (" + cSaldoSB2 + ") ) + ROUND("
		cFormNec += If(lTPBD ," ((COALESCE","((ISNULL" ) 
		cFormNec += " ((SELECT (SUM(SD2.D2_QUANT) / " + If( !lTPLDRO , AllTrim( Str(aPARAM177[08]) ), T_DroQuery(lTPBD) ) + ") "
		cFormNec +=               " FROM " + RetSQLTab('SD2') 
		cFormNec +=                  " , " + RetSQLTab('SF4') 
		cFormNec +=              " WHERE SD2.D2_FILIAL        = SB2.B2_FILIAL "
		cFormNec +=                " AND SD2.D2_COD           = SB2.B2_COD "
		cFormNec +=                " AND SD2.D2_TIPO          = 'N' "
		cFormNec +=                " AND SD2.D2_EMISSAO BETWEEN '" + DtoS( dDtIni ) + "' AND '" + DtoS( dDtFim ) + "' "
		cFormNec +=                " AND SD2.D_E_L_E_T_       = ' ' "
		cFormNec +=                " AND SF4.F4_FILIAL        = " + cFilSF4 + " "
		cFormNec +=                " AND SF4.F4_CODIGO        = SD2.D2_TES "
		cFormNec +=                " AND SF4.F4_ESTOQUE       = 'S' " 
		cFormNec +=                " AND SF4.D_E_L_E_T_       = ' ' "
		cFormNec +=              " GROUP BY SD2.D2_FILIAL "
		cFormNec +=                     " , SD2.D2_COD "
		cFormNec +=            " ),0) * " + AllTrim( Str(aPARAM177[10]) ) 
		cFormNec +=  " ) "
		cFormNec += " ),0) "
	ElseIf aPARAM177[06] == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ESTOQUE MAXIMO - ESTOQUE ATUAL³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cDadosProd == 'SB1'
			cFormNec := " (SB1.B1_EMAX - (" + cSaldoSB2 + ") ) "
		Else
			cFormNec := " (SBZ.BZ_EMAX - (" + cSaldoSB2 + ") ) "
		EndIf
	Else
		cFormNec := " (0) "
	EndIf
EndIf    	    
cQuery += cFormNec + " QTDNEC "

//ADICIONA OS CAMPOS DO TEMPLATE NO SELECT DA QUERY DE NECESSIDADES

If lTPLDRO 
	cQuery += ",SB1.B1_MINCUS MENOR_CUSTO,"
	cQuery += "SB1.B1_DMINCUS DT_MENOR_CUSTO," 
	cQuery += "SB1.B1_UPRC ULTIMA_COMRA,"   
	cQuery += "SB1.B1_UCOM DT_ULT_COMPRA," 					
	cQuery += "SB1.B1_MAXCUS MAIOR_CUSTO,"
	cQuery += "SB1.B1_DMAXCUS DT_MAIOR_CUSTO,"   
	cQuery += "SB1.B1_CODFAB COD_FABRICANTE,"
	cQuery += "SB1.B1_LOJA	LOJ_FABRICANTE,"	
	cQuery += "SB1.B1_UM UNIDADE_MEDIDA "
Endif

cQuery +=  " FROM " + RetSQLTab('SB1')
cQuery +=     " , " + RetSQLTab('SB2')

//--VERIFICA A ORIGEM DOS DADOS DO PRODUTO
If cDadosProd == 'SBZ'
	cQuery += " LEFT JOIN " + RetSQLTab('SBZ') + " ON (SBZ.BZ_FILIAL  = SB2.B2_FILIAL AND "
	cQuery +=                                        " SBZ.BZ_COD     = SB2.B2_COD AND "
	cQuery +=                                        " SBZ.D_E_L_E_T_ = ' ') "
EndIf

//--CONSIDERA O PONTO DE ENTRADA MTA177QRY (JOIN'S ADICIONAIS)
If lMTA177Qry .And. Len( aMTA177Qry ) >= 2 .And. ValType( aMTA177Qry[2] ) == 'C' .And. !Empty( aMTA177Qry[2] )
	cQuery += " " + aMTA177Qry[2] + " "
EndIf

cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial('SB1') + "' "
cQuery +=   " AND SB1.B1_GRUPO IN " + aPARAM177[26] 
cQuery +=   " AND SB1.B1_TIPO  IN " + aPARAM177[27] 
cQuery += If( !Empty(aPARAM177[28]), " AND (" + StrTran( aPARAM177[28], 'B1_', 'SB1.B1_' ) + ") ", "" )

//--CONSIDERA O FILTRO POR CATEGORIAS
If aPARAM177[24]
  cQuery += "  AND SB1.B1_COD IN ( SELECT DISTINCT "
  cQuery +=                             " SB1.B1_COD " 
  cQuery +=                        " FROM " + RetSQLTab('ACV') + " "
  cQuery +=                             " INNER JOIN " + RetSQLTab('SB1') + " ON ((SB1.B1_COD      = ACV.ACV_CODPRO OR "
  cQuery +=                                                                      " (SB1.B1_GRUPO   = ACV.ACV_GRUPO AND "
  cQuery +=                                                                      "  ACV.ACV_GRUPO <> '"+Criavar('ACV_GRUPO',.F.)+"')) AND "
  cQuery +=                                                                      " SB1.B1_FILIAL   = ACV.ACV_FILIAL AND "
  cQuery +=                                                                      " SB1.D_E_L_E_T_  = ' ') "
  cQuery +=                       " WHERE ACV.ACV_CATEGO IN  " + aPARAM177[25] + " "
  cQuery +=                         " AND ACV.D_E_L_E_T_  = ' ' ) "
EndIf

If lTPLDRO   
	If cDadosProd == 'SBZ'
		cQuery += " AND SBZ.BZ_SUSPENC <> '1' "			
	Else
		cQuery += " AND SB1.B1_SUSPENC <> '1' "						
	Endif
	If cFiltroTPL <> "()"  
		cQuery += " AND " + cFiltroTPL  // ADICIONA O FILTROS DE DROGARIA NA QUERY 
	Endif
Endif          
//--CONSIDERA A AMARRACAO PRODUTO x FORNECEDOR
If aPARAM177[13] == 2
	cQuery += " AND SB1.B1_PROC BETWEEN '" + aPARAM177[14] + "' AND '" + aPARAM177[15] + "' "
ElseIf aPARAM177[13] == 1
	cQuery += " AND EXISTS( SELECT SA5.A5_FORNECE "
	cQuery +=               " FROM " + RetSQLTab('SA5')
	cQuery +=              " WHERE SA5.A5_FILIAL        = " + cFilSA5 + " "
	cQuery +=                " AND SA5.A5_PRODUTO       = SB2.B2_COD "
	cQuery +=                " AND SA5.A5_FORNECE BETWEEN '" + aPARAM177[14] + "' AND '" + aPARAM177[15] + "' "
	cQuery +=                " AND SA5.D_E_L_E_T_ = ' ' "
	cQuery +=           " ) "
EndIf

cQuery += " AND SB1.D_E_L_E_T_ = ' ' "

// Validar bloqueio de produtos (B1_MSBLQL e B1_MSBLQD)
If SB1->(FieldPos('B1_MSBLQL')) > 0
	cQuery += " AND SB1.B1_MSBLQL <> '1' "
EndIf

If SB1->(FieldPos('B1_MSBLQD')) > 0
	cQuery += " AND (SB1.B1_MSBLQD = '        ' OR SB1.B1_MSBLQD >= '"+DtoS(dDatabase)+"') "
EndIf

cQuery += " AND SB2.B2_FILIAL     IN " + cFiliaisIn 
cQuery += " AND SB2.B2_COD         = SB1.B1_COD "
cQuery += " AND SB2.B2_LOCAL BETWEEN '" + aPARAM177[11] + "' AND '" + aPARAM177[12] + "' "
cQuery += " AND SB2.D_E_L_E_T_     = ' ' "

//--CONSIDERA O PONTO DE ENTRADA MTA177QRY (FILTROS ADICIONAIS)
If lMTA177Qry .And. Len( aMTA177Qry ) >= 3 .And. ValType( aMTA177Qry[3] ) == 'C' .And. !Empty( aMTA177Qry[3] )
	cQuery += " AND " + aMTA177Qry[3] + " "
EndIf

cQuery += " GROUP BY SB2.B2_FILIAL "
cQuery +=        " , SB2.B2_COD "
cQuery +=        " , SB1.B1_COD "
cQuery +=        " , SB1.B1_DESC "
cQuery +=        " , SB1.B1_GRUPO "
cQuery +=        " , SB1.B1_TIPO "
cQuery += If( aPARAM177[01] == 1 .And. aPARAM177[13] == 2, " , SB1.B1_PROC, SB1.B1_LOJPROC ", "" )
cQuery += If( cDadosProd == 'SB1', " , SB1.B1_EMAX ", " , SBZ.BZ_EMAX " )
 

// ADICIONA OS CAMPOS DO TEMPLATE NO GROUP BY
If lTPLDRO 
	cQuery += ",SB1.B1_MINCUS,"
	cQuery += "SB1.B1_DMINCUS," 
	cQuery += "SB1.B1_UPRC   ,"
	cQuery += "SB1.B1_UCOM,"
	cQuery += "SB1.B1_MAXCUS ,"
	cQuery += "SB1.B1_DMAXCUS,"
	cQuery += "SB1.B1_CODFAB ,"
	cQuery += "SB1.B1_LOJA	 ,"	
	cQuery += "SB1.B1_UM     " 
	cQuery +=  T_DroRetConini(cDadosProd) 
Endif
//--CONSIDERA O PONTO DE ENTRADA MTA177QRY (CAMPOS ADICIONAIS NO GROUP BY)
If lMTA177Qry .And. Len( aMTA177Qry ) == 4 .And. ValType( aMTA177Qry[4] ) == 'C' .And. !Empty( aMTA177Qry[4] )
	cQuery += " , " + aMTA177Qry[4] + " "
EndIf

//--ORDENACAO PARA GERACAO DOS PC'S / SC'S E PV'S
cQuery += " ORDER BY FILNEC, CODFOR, LOJA "   

//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0017 ) //--"Selecionando registros..."
EndIf

//--Cria alias de trabalho
oProcess:IncRegua1( STR0017 ) //--"Selecionando registros..."
cAliasTrb := GetNextAlias()
cQuery    := ChangeQuery(cQuery)
DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTrb, .T., .F.)
//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0149 ) //--"Registros selecionados. Iniciando o Processo."
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A177Distribui ³ Autor ³ Emerson Rony Oliveira ³ Data ³07/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Monta o alias de trabalho a partir dos parametros selecionados ³±±
±±³          ³ pelo usuario para o processo de Distribuicao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void A177Distribui(ExpC1, ExpL1, ExpA1)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias de trabalho a ser montado                        ³±±
±±³          ³ ExpL1 = Variavel que indica se existe ou nao o PE              ³±±
±±³          ³ ExpA1 = Array contendo as sentencas SQL retornadas pelo PE     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177Distribui( cAliasTrb, lMTA177Qry, aMTA177Qry,cFiltroTPL )
Local cFiliaisIn  := ''
Local cFilSF4     := If( a177MdAccess("SF4"), "'"+FWxFilial('SF4')+"'", 'SB2.B2_FILIAL' )
Local cFilSB1     := If( a177MdAccess("SB1"), "'"+FWxFilial('SB1')+"'", "'" + aPARAM177[21]+ "'" )
Local cSaldoSB2   := '' //--Formula para obter o saldo em estoque
Local cFormNec    := '' //--Formula para calcular a necessidade
Local cQuery      := '' //--Sentenca para obter os produtos a serem analisados
Local cQueryCEN   := '' //--Sentenca para obter os dados da filial centralizadora
Local cSaldoCEN   := '' //--Formula para obter o saldo em estoque da filial centralizadora
Local cDadosProd  := Upper(SuperGetMV( 'MV_ARQPROD', .F., 'SB1' ))
Local aDatas      := A177CalcDt( aPARAM177[08], aPARAM177[09] )
Local dDtIni      := aDatas[1]
Local dDtFim      := aDatas[2]
Local lConsPrev   := If( SuperGetMV( 'MV_QTDPREV', .F., 'N' ) == 'S', .T., .F. )
Local nCount      := 0
Local lB1_MSBLQL  := SB1->(FieldPos('B1_MSBLQL')) > 0
Local lB1_MSBLQD  := SB1->(FieldPos('B1_MSBLQD')) > 0

//--MONTA EXPRESSAO PARA FILTRO DAS FILIAIS SELECIONADAS...
cFiliaisIn := '('
For nCount := 1 To Len( aPARAM177[19] )
	cFiliaisIn += "'" + aPARAM177[19,nCount] + "'"
	If nCount < Len( aPARAM177[19] )
		cFiliaisIn += ','
	EndIf
Next
cFiliaisIn += ')' 

//--FORMULA PARA OBTER O SALDO EM ESTOQUE NA FILIAL CENTRALIZADORA:	
cSaldoCEN := "SUM(SB2.B2_QATU) - "
cSaldoCEN += "SUM(SB2.B2_RESERVA) - "
cSaldoCEN += "SUM(SB2.B2_QEMP) - "
cSaldoCEN += "SUM(SB2.B2_QACLASS) - "
cSaldoCEN += "SUM(SB2.B2_QEMPSA) " 
cSaldoCEN += If( lConsPrev, " - SUM(SB2.B2_QEMPPRE)", "" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³QUERY PARA OBTER OS SALDOS x FILIAL CENTRALIZADORA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQueryCEN := "SELECT SB2.B2_COD CODPRO "
cQueryCEN +=     " , SB1.B1_DESC DESPRO "
cQueryCEN +=     " , SB1.B1_GRUPO GRUPO "
cQueryCEN +=     " , SB1.B1_TIPO TIPO "
cQueryCEN +=     " , ( " + cSaldoCEN + " ) SLDFILCEN "   
If lTPLDRO
	cQueryCEN += ",SB1.B1_MINCUS,SB1.B1_DMINCUS,SB1.B1_UPRC,SB1.B1_UCOM,"
    cQueryCEN += "SB1.B1_MAXCUS,SB1.B1_DMAXCUS,SB1.B1_CODFAB,SB1.B1_LOJA,SB1.B1_UM "
EndIf
cQueryCEN +=  " FROM " + RetSQLTab('SB1') 
cQueryCEN +=     " , " + RetSQLTab('SB2')


cQueryCEN += " WHERE SB2.B2_FILIAL      = '" + aPARAM177[21] + "' "
cQueryCEN +=   " AND SB2.B2_COD         = SB1.B1_COD "
cQueryCEN +=   " AND SB2.B2_LOCAL BETWEEN '" + aPARAM177[11] + "' AND '" + aPARAM177[12] + "' "
cQueryCEN +=   " AND SB2.D_E_L_E_T_     = ' ' "
cQueryCEN +=   " AND SB1.B1_FILIAL      = " + cFilSB1 + " "
cQueryCEN +=   " AND SB1.B1_GRUPO      IN " + aPARAM177[26]
cQueryCEN +=   " AND SB1.B1_TIPO       IN " + aPARAM177[27]
cQueryCEN += If( !Empty(aPARAM177[28]), " AND (" + StrTran( aPARAM177[28], 'B1_', 'SB1.B1_' ) + ") ", "" )
cQueryCEN +=   " AND SB1.D_E_L_E_T_ = ' ' "  

// Validar bloqueio de produtos (B1_MSBLQL e B1_MSBLQD) na filial centralizadora
If lB1_MSBLQL
	cQueryCEN += " AND SB1.B1_MSBLQL <> '1' "
EndIf
If lB1_MSBLQD
	cQueryCEN += " AND (SB1.B1_MSBLQD = '        ' OR SB1.B1_MSBLQD >= '"+DtoS(dDatabase)+"') "
EndIf

//--CONSIDERA O FILTRO POR CATEGORIAS
If aPARAM177[24]
  cQueryCEN += "  AND SB1.B1_COD IN ( SELECT DISTINCT "
  cQueryCEN +=                             " SB1.B1_COD " 
  cQueryCEN +=                        " FROM " + RetSQLTab('ACV') + " "
  cQueryCEN +=                             " INNER JOIN " + RetSQLTab('SB1') + " ON ((SB1.B1_COD      = ACV.ACV_CODPRO OR "
  cQueryCEN +=                                                                      " (SB1.B1_GRUPO   = ACV.ACV_GRUPO AND "
  cQueryCEN +=                                                                      "  ACV.ACV_GRUPO <> '"+Criavar('ACV_GRUPO',.F.)+"')) AND "
  cQueryCEN +=                                                                      " SB1.B1_FILIAL   = ACV.ACV_FILIAL AND "
  cQueryCEN +=                                                                      " SB1.D_E_L_E_T_  = ' ') "
  cQueryCEN +=                       " WHERE ACV.ACV_CATEGO IN  " + aPARAM177[25] + " "
  cQueryCEN +=                         " AND ACV.D_E_L_E_T_  = ' ' ) "
EndIf

cQueryCEN += " GROUP BY SB2.B2_COD "
cQueryCEN +=        " , SB1.B1_DESC "
cQueryCEN +=        " , SB1.B1_GRUPO "
cQueryCEN +=        " , SB1.B1_TIPO " 
If lTPLDRO
	cQueryCEN += ",SB1.B1_MINCUS,SB1.B1_DMINCUS,SB1.B1_UPRC,SB1.B1_UCOM,"
    cQueryCEN += "SB1.B1_MAXCUS,SB1.B1_DMAXCUS,SB1.B1_CODFAB,SB1.B1_LOJA,SB1.B1_UM "
EndIf
cQueryCEN += " HAVING (" + cSaldoCEN + ") > 0 "
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MONTAGEM DA QUERY PRINCIPAL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//--FORMULA PARA OBTER O SALDO EM ESTOQUE:	
cSaldoSB2 := "SUM(SB2.B2_QATU) - "
cSaldoSB2 += "SUM(SB2.B2_RESERVA) - "
cSaldoSB2 += "SUM(SB2.B2_QEMP) - "
cSaldoSB2 += "SUM(SB2.B2_QACLASS) - "
cSaldoSB2 += "SUM(SB2.B2_QEMPSA) " 
cSaldoSB2 += If( lConsPrev, " - SUM(SB2.B2_QEMPPRE) ", "" ) 
cSaldoSB2 += " + SUM(SB2.B2_SALPEDI) "


cQuery += "SELECT SB2.B2_FILIAL FILNEC "
cQuery +=     " , SB2.B2_COD CODPRO "
cQuery +=     " , TRB1.DESPRO DESPRO "
cQuery +=     " , TRB1.GRUPO GRUPO "
cQuery +=     " , TRB1.TIPO TIPO "
cQuery += If( cDadosProd == 'SB1', " , SB1.B1_EMAX EMAX ", " , SBZ.BZ_EMAX EMAX " )

//--SALDO NA FILIAL CENTRALIZADORA
cQuery +=     " , TRB1.SLDFILCEN SLDFILCEN "

//--PROCESSO DE DISTRIBUICAO NAO POSSUI FORNECEDOR
cQuery +=     " , '' CNPJFOR "

//--SALDO DAS FILIAIS DE NECESSIDADE
cQuery +=     " , (" + cSaldoSB2 + ") SLDFILNEC "

//--MEDIA DE VENDAS NO PERIODO
cQuery += " , ROUND(" + If(lTPBD ,"COALESCE(","ISNULL(" ) 
cQuery +=     " ((SELECT (SUM(SD2.D2_QUANT) / " + If( !lTPLDRO , AllTrim( Str(aPARAM177[08]) ), T_DroQuery(lTPBD) ) + ") "
cQuery +=                   " FROM " + RetSQLTab('SD2') 
cQuery +=                      " , " + RetSQLTab('SF4')
cQuery +=                  " WHERE SD2.D2_FILIAL        = SB2.B2_FILIAL "
cQuery +=                    " AND SD2.D2_COD           = SB2.B2_COD "
cQuery +=                    " AND SD2.D2_TIPO          = 'N' "
cQuery +=                    " AND SD2.D2_EMISSAO BETWEEN '" + DtoS( dDtIni ) + "' AND '" + DtoS( dDtFim ) + "' "
cQuery +=                    " AND SD2.D_E_L_E_T_       = ' ' "
cQuery +=                    " AND SF4.F4_FILIAL        = " + cFilSF4 + " "
cQuery +=                    " AND SF4.F4_CODIGO        = SD2.D2_TES "
cQuery +=                    " AND SF4.F4_ESTOQUE       = 'S' "
cQuery +=                    " AND SF4.D_E_L_E_T_       = ' ' "
cQuery +=                  " GROUP BY SD2.D2_FILIAL "
cQuery +=                         " , SD2.D2_COD "
cQuery +=                " )),0),2) MEDVENDAS, "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CALCULO DA NECESSIDADE               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTA177Qry .And. Len( aMTA177Qry ) >= 1 .And. ValType( aMTA177Qry[1] ) == 'C' .And. !Empty( aMTA177Qry[1] )
	cFormNec := aMTA177Qry[1]
Else
	If aPARAM177[06] == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³(ESTOQUE MAXIMO - ESTOQUE ATUAL) + (MEDIA VENDAS * NUMERO PERIODOS PROJECAO)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFormNec := " ( " + If( cDadosProd == 'SB1', "SB1.B1_EMAX - ", "SBZ.BZ_EMAX - " ) + " (" + cSaldoSB2 + ") ) + ROUND("
	    cFormNec += If(lTPBD ," ((COALESCE","((ISNULL" ) 
		cFormNec += "((SELECT (SUM(SD2.D2_QUANT) / " + If( !lTPLDRO , AllTrim( Str(aPARAM177[08]) ), T_DroQuery(lTPBD) ) + ") "
		cFormNec +=               " FROM " + RetSQLTab('SD2') 
		cFormNec +=                  " , " + RetSQLTab('SF4') 
		cFormNec +=              " WHERE SD2.D2_FILIAL        = SB2.B2_FILIAL "
		cFormNec +=                " AND SD2.D2_COD           = SB2.B2_COD "
		cFormNec +=                " AND SD2.D2_TIPO          = 'N' " 
		cFormNec +=                " AND SD2.D2_EMISSAO BETWEEN '" + DtoS( dDtIni ) + "' AND '" + DtoS( dDtFim ) + "' "
		cFormNec +=                " AND SD2.D_E_L_E_T_       = ' ' "
		cFormNec +=                " AND SF4.F4_FILIAL        = " + cFilSF4 + " "
		cFormNec +=                " AND SF4.F4_CODIGO        = SD2.D2_TES "
		cFormNec +=                " AND SF4.F4_ESTOQUE       = 'S' "
		cFormNec +=                " AND SF4.D_E_L_E_T_       = ' ' "
		cFormNec +=              " GROUP BY SD2.D2_FILIAL "
		cFormNec +=                     " , SD2.D2_COD "
		cFormNec +=            " ),0) * " + AllTrim( Str(aPARAM177[10]) ) 
		cFormNec +=  " ) "
		cFormNec += " ),0) "
		
	ElseIf aPARAM177[06] == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ESTOQUE MAXIMO - ESTOQUE ATUAL³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cDadosProd == 'SB1'
			cFormNec := " (SB1.B1_EMAX - (" + cSaldoSB2 + ") ) "
		Else
			cFormNec := " (SBZ.BZ_EMAX - (" + cSaldoSB2 + ") ) "
		EndIf
	Else
		cFormNec := " (0) "
  EndIf
EndIf    	    
cQuery += cFormNec + " QTDNEC "

If lTPLDRO 
	cQuery += ",TRB1.B1_MINCUS  MENOR_CUSTO,"
	cQuery += "TRB1.B1_DMINCUS DT_MENOR_CUSTO," 
	cQuery += "TRB1.B1_UPRC    ULTIMA_COMRA,"  
	cQuery += "TRB1.B1_UCOM    DT_ULT_COMPRA," 									
	cQuery += "TRB1.B1_MAXCUS  MAIOR_CUSTO,"
	cQuery += "TRB1.B1_DMAXCUS DT_MAIOR_CUSTO,"   
	cQuery += "TRB1.B1_CODFAB  COD_FABRICANTE,"
	cQuery += "TRB1.B1_LOJA	  LOJ_FABRICANTE,"	
	cQuery += "TRB1.B1_UM      UNIDADE_MEDIDA "
Endif                                       

//--UTILIZA O SELECT DOS DADOS DA FILIAL CENTRALIZADORA COMO UMA TABELA (SubQuery)
cQuery += "  FROM ("+ cQueryCEN +") TRB1 "

// Validar bloqueio de produtos
If lB1_MSBLQL .Or. lB1_MSBLQD
	cQuery += " , " + RetSQLName('SB1')+" SB1Nec "
EndIf

cQuery +=     " , " + RetSQLTab('SB2')

If cDadosProd == 'SB1'
	cQuery += " , " + RetSQLTab('SB1')
ElseIf cDadosProd == 'SBZ'
	cQuery += " LEFT JOIN " + RetSQLTab('SBZ') + " ON (SBZ.BZ_FILIAL  = SB2.B2_FILIAL AND "
	cQuery +=                                        " SBZ.BZ_COD     = SB2.B2_COD AND "
	cQuery +=                                        " SBZ.D_E_L_E_T_ = ' ') "
EndIf

If lTPLDRO .AND. cDadosProd == 'SBZ'
	cQuery += " LEFT JOIN  " + RetSQLTab('SB1') + " ON SB2.B2_COD = SB1.B1_COD "
EndIf
	 
//--CONSIDERA O PONTO DE ENTRADA MTA177QRY (JOIN'S ADICIONAIS)
If lMTA177Qry .And. Len( aMTA177Qry ) >= 2 .And. ValType( aMTA177Qry[2] ) == 'C' .And. !Empty( aMTA177Qry[2] )
	cQuery += " " + aMTA177Qry[2] + " "
EndIf

cQuery += " WHERE SB2.B2_FILIAL     IN " + cFiliaisIn
cQuery +=   " AND SB2.B2_COD         = TRB1.CODPRO " 
cQuery +=   " AND SB2.B2_LOCAL BETWEEN '" + aPARAM177[11] + "' AND '" + aPARAM177[12] + "' "
cQuery +=   " AND SB2.D_E_L_E_T_     = ' ' "

If cDadosProd == 'SB1'
	cQuery += " AND SB1.B1_FILIAL  = " + cFilSB1 + " "
	cQuery += " AND SB1.B1_COD     = SB2.B2_COD "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
EndIf

// Validar bloqueio de produtos (B1_MSBLQL e B1_MSBLQD) nas filiais de necessidade
If lB1_MSBLQL .Or. lB1_MSBLQD
	cQuery += " AND SB1Nec.B1_FILIAL  = " + cFilSB1 + " "   
	cQuery += " AND SB1Nec.B1_COD     = SB2.B2_COD "
	cQuery += " AND SB1Nec.D_E_L_E_T_ = ' ' "

	If lB1_MSBLQL
		cQuery += " AND SB1Nec.B1_MSBLQL <> '1' "
	EndIf
	
	If lB1_MSBLQD
		cQuery += " AND (SB1Nec.B1_MSBLQD = '        ' OR SB1Nec.B1_MSBLQD >= '"+DtoS(dDatabase)+"') "
	EndIf
EndIf

If lTPLDRO   
	If cDadosProd == 'SBZ'
		cQuery += " AND SBZ.BZ_SUSPENC <> '1' "			
	Else
		cQuery += " AND SB1.B1_SUSPENC <> '1' "						
	Endif
	If cFiltroTPL <> "()"  
		cQuery += " AND " + cFiltroTPL  // ADICIONA O FILTROS DE DROGARIA NA QUERY 
	EndIf	
Endif
//--CONSIDERA O PONTO DE ENTRADA MTA177QRY (FILTROS ADICIONAIS)
If lMTA177Qry .And. Len( aMTA177Qry ) >= 3 .And. ValType( aMTA177Qry[3] ) == 'C' .And. !Empty( aMTA177Qry[3] )
	cQuery += " AND " + aMTA177Qry[3] + " "
EndIf

cQuery += " GROUP BY SB2.B2_FILIAL "
cQuery +=        " , SB2.B2_COD "
cQuery +=        " , TRB1.DESPRO "
cQuery +=        " , TRB1.GRUPO "
cQuery +=        " , TRB1.TIPO "			
cQuery += If( cDadosProd == 'SB1', " , SB1.B1_EMAX ", " , SBZ.BZ_EMAX " )
cQuery +=        " , TRB1.SLDFILCEN "
                                       
If lTPLDRO 
	cQuery += ",TRB1.B1_MINCUS,"
	cQuery += "TRB1.B1_DMINCUS," 
	cQuery += "TRB1.B1_UPRC,"
	cQuery += "TRB1.B1_UCOM,"
	cQuery += "TRB1.B1_MAXCUS,"
	cQuery += "TRB1.B1_DMAXCUS,"
	cQuery += "TRB1.B1_CODFAB,"
	cQuery += "TRB1.B1_LOJA,"	
	cQuery += "TRB1.B1_UM   "    
	cQuery += T_DroRetConini(cDadosProd)
Endif
//--CONSIDERA O PONTO DE ENTRADA MTA177QRY (GROUP BY ADICIONAIS)
If lMTA177Qry .And. Len( aMTA177Qry ) >= 4 .And. ValType( aMTA177Qry[4] ) == 'C' .And. !Empty( aMTA177Qry[4] )
	cQuery += " , " +	aMTA177Qry[4]
EndIf

//--ORDENACAO
cQuery += " ORDER BY FILNEC, CODPRO "

//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0017 ) //--"Selecionando registros..."
EndIf

//--Cria alias de trabalho
oProcess:IncRegua1( STR0017 ) //--"Selecionando registros..."
cAliasTrb := GetNextAlias()
cQuery    := ChangeQuery(cQuery)
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTrb, .F., .F.)                             
//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0149 ) //--"Registros selecionados. Iniciando o Processo."
EndIf

Return




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177Resumo  ³Autor  ³Vitor Raspa          ³Data  ³ 25-Mar-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exibe a tela com o resultado do Calculo das Necessidades    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177Resumo( lEnd, cAliasTrb, nTotReg,lBonus,aSelGrupos )
Local aCabec     := {}
Local aItens     := {}
Local aTotNec    := {}
Local aNecAlt    := {}
Local aSize      := {}
Local aInfo      := {}
Local aObjects   := {}
Local aButtons   := {}
Local bAction    := {||}
Local cCodPro    := CriaVar( 'B1_COD', .F. )
Local cDesPro    := CriaVar( 'B1_DESC', .F. )
Local cNumCalc   := ''
Local bBlockRes  := '' 
Local nOpcA      := 0
Local nCount     := 0
Local nQtdNec    := 0
Local nPosTotNec := ''
Local nPosSld    := 0
Local nPosMed    := 0
Local nEstMax    := 0
Local nMedia     := 0
Local nSldFilCen := 0
Local nQtdProp   := 0
Local nPropAcum  := 0
Local oDlg
Local oCodPro
Local oDesPro     
Local oBrwNec
Local oBtnEdtNec
Local oBtnCancNec
Local oBtnOkNec   

//--Ponto de entrada para manipular a Qtd. da Necessidade
Local lMTA177Nec  := ExistBlock('MTA177Nec')
Local nMTA177Nec  := 0
Local nGiro	   	  := 0	//GIRO POR FILIAL
Local nPPendente  := 0	//QUANTIDADE DE PEDIDOS PENDENTES	

Local oGetMinCusto              
Local oGetDtMinCus
Local dDtMinCusto := dDatabase  
Local nMinCusto   := 0 

Local aPosObj     := {} 
Local nTotNecObt  := 0		// Total de Necessidades Obtida
Local nTotNecInf  := 0		// Total de Necessidades Informada   

Local nUltCompra   := 0
Local oGetUltCompra
Local dDtUltCompra := dDatabase
Local oGetDtUltCompra

Local oGetDtMaxCus
Local nMaxCusto   := 0
Local oGetMaxCusto
Local dDtMaxCusto := dDatabase  

Local nUltPrVenda  := 0
Local oGetUltPrVenda
Local dUltDtVenda  := dDatabase
Local oGetUltDtVenda

Local cNomeFabr    := Space(TamSX3("A2_NOME")[1])
Local oGetNomeFabr

Local cUnidProd    := Space(TamSX3("B1_UM")[1])
Local oGetUnidProd  

Local cCodProd     := Space(TamSX3("B1_COD")[1])
Local oGetCodProd        

Local nMedatraso    := 0
Local oGetMedatraso     

Local nCusto	   := 0	

Local nMesAtu      := 0
Local oGetMesAtu

Local nMesAnt      := 0                 
Local oGetMesAnt 

Local nMedMes    	:= 0
Local oGetMedMes

Local nEstAtu		:= 0
Local oGetEstAtu   


Local nContProd     := 0  // Controla a troca de produtos 
Local nQuntProd     := 0  // Controla a quantidades de produto   
Local nI            := 0  
Local cFilAIB       := "" // variavel para controle para verificacao do preco 
Local cPrUnit       := ""  // Preco unitario do produto
Local nDecimais     := msdecimais(1)  
Local cTotalPreco   := ""   // Preco Total dos produtos   
Local nValTotalProd := 0   // Somatoria dos valores Totais dos produtos
Local oTotValProd            
Local oTotNecInf   
Local aTamB2_QATU   := TamSX3('B2_QATU')        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CABECALHO DO GRID³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aCabec, STR0024 ) //--"Filial Necess."
AAdd( aCabec, STR0025 ) //--"Filial Central."
AAdd( aCabec, STR0026 ) //--"Produto"
AAdd( aCabec, STR0012 ) //--"Descricao"
AAdd( aCabec, STR0027 ) //--"Grupo"
AAdd( aCabec, STR0028 ) //--"Tipo"
AAdd( aCabec, STR0029 ) //--"Necess. Obtida"
AAdd( aCabec, STR0030 ) //--"Necess. Informada"
If aPARAM177[01] == 2
	AAdd( aCabec, STR0151 ) //--"Qtd. Propor."
EndIf
AAdd( aCabec, STR0031 ) //--"Saldo Atual"
AAdd( aCabec, STR0032 ) //--"Media Vendas"
AAdd( aCabec, STR0033 ) //--"Est. Maximo"
AAdd( aCabec, STR0034 ) //--"Sld. Filial Cent." 
If lTPLDRO
	AAdd( aCabec, STR0216 )   // Giro por filial
	AAdd( aCabec, STR0217 )   // Quantidade de pedidos pendentes
	AAdd( aCabec, STR0218 )   // Preco unitario do produto   
	AAdd( aCabec, STR0219 )   // Total do valor das mercadorias
Endif
 
//--Barra de progresso
If aPARAM177[22]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³EXIBE A TELA COM AS NECESSIDADES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0155 ) //--"Preparando ambiente para exibicao dos registros"
	EndIf

	//--Atualiza o Array com os Itens	
	aItens := {}
	oProcess:SetRegua2( nTotReg )
	(cAliasTrb)->( DbGoTop() )
	Do While !(cAliasTrb)->( Eof() ) .And. !lEnd
		//--Calculo da Necessidade
		If aPARAM177[06] == 1 .Or. aPARAM177[06] == 2
			nQtdNec := (cAliasTrb)->QTDNEC
		Else
			nQtdNec := A177CalcNec( (cAliasTrb)->FILNEC, (cAliasTrb)->CODPRO, (cAliasTrb)->SLDFILNEC )
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³P. E. PARA MODIFICAR A QTDE. DA NECESSIDADE³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMTA177Nec
			 nMTA177Nec := ExecBlock('MTA177Nec', .F., .F.,;
										{ (cAliasTrb)->CODPRO,;		//--[01]Codigo do Produto
										  aPARAM177[20],;			//--[02]Processamento por Filial (1) ou Centralizado (2)
										  (cAliasTrb)->FILNEC,;		//--[03]Filial Necessidade
										  aPARAM177[21],;			//--[04]Filial Centralizadora
										  nQtdNec,; 				//--[05]Necessidade Obtida
										  (cAliasTrb)->MEDVENDAS,;	//--[06]Media de Vendas do periodo
										  (cAliasTrb)->EMAX,;		//--[07]Estoque Maximo do Produto na filial da necessidade
										  (cAliasTrb)->SLDFILNEC,;	//--[08]Saldo atual na filial da necessidade
										  (cAliasTrb)->SLDFILCEN,;	//--[09]Saldo atual na filial Centralizadora
										  aPARAM177[19],;			//--[10]Filiais selecionadas
										  aPARAM177[27],;			//--[11]Tipos selecionados
										  aPARAM177[26],;			//--[12]Grupos selecionados
										  aPARAM177[25],;			//--[13]Categorias selecionadas
										  aPARAM177[28],;			//--[14]Filtro especifico do usuario
										  aPARAM177[29] })			//--[15]Ordem selecionada pelo usuario

			If ValType( nMTA177Nec ) == 'N'
				nQtdNec := nMTA177Nec
			EndIf				
		EndIf
		If ( aPARAM177[23] .And. nQtdNec > 0 ) .Or. ( !aPARAM177[23] .And. nQtdNec >= 0 )
			If aPARAM177[01] == 1 
		   		If lTPLDRO    
		  			//Obtem o preco conforme o parametro para visualizacao 
		  		 	If aPARAM177[17] == 1
						cPrUnit :=Right( space(29) + AllTrim(Transform(Round( T_DroSB1ToSBZ((cAliasTrb)->CODPRO , 'B1_UPRC',(cAliasTrb)->FILNEC ),nDecimais),"999999.99")),29)
					ElseIf aPARAM177[17] == 2
						//-- Obtem o preco unitario atraves da tabela informada e para o fornecedor do pedido de compra
					    cFilAIB := If( a177MdAccess("AIB"), FWxFilial('AIB'), (cAliasTrb)->FILNEC ) 
					    DbSelectArea("AIB")
					    DbSetorder(2)
					    If AIB ->(DbSeek(cFilAIB + (cAliasTrb)->CODFOR + (cAliasTrb)->LOJA + aPARAM177[18] + (cAliasTrb)->CODPRO ))
							cPrUnit :=  AllTrim(Transform(Round(GetAdvFval( 'AIB','AIB_PRCCOM', cFilAIB + (cAliasTrb)->CODFOR + (cAliasTrb)->LOJA + aPARAM177[18] + (cAliasTrb)->CODPRO, 2 ),nDecimais), "999999.99"))
						Else
							cPrUnit :=  AllTrim("0.00")
						EndIf	
					Else                               
					    cPrUnit := AllTrim(Transform(Round( T_DroSB1ToSBZ((cAliasTrb)->CODPRO , 'B1_CUSTD',(cAliasTrb)->FILNEC ),nDecimais),"999999.99"))
					EndIf  
		  		    cTotalPreco := AllTrim(Transform(Round(Val(cPrUnit) * nQtdNec,nDecimais)," 999999.99"))
		  			nValTotalProd += Val(cTotalPreco)
		  			
		  			nGiro 		:= T_A177Giro((cAliasTrb)->FILNEC,(cAliasTrb)->CODPRO, aPARAM177)	//--[13]GIRO POR FILIAL
		  			nPPendente 	:= T_A177PPend((cAliasTrb)->FILNEC,(cAliasTrb)->CODPRO)  			//--[14]QUANTIDADE DE PEDIDOS PENDENTES
		  		Endif
				AAdd( aItens, {	(cAliasTrb)->FILNEC,;		  //--[01]FILIAL DA NECESSIDADE
						        aPARAM177[21],;				  //--[02]FILIAL CENTRALIZADORA
						        (cAliasTrb)->CODPRO,;		  //--[03]CODIGO DO PRODUTO
						        (cAliasTrb)->DESPRO,;		  //--[04]DESCRICAO
						        (cAliasTrb)->GRUPO,;		  //--[05]GRUPO
						        (cAliasTrb)->TIPO,;			  //--[06]TIPO
						        nQtdNec,;					  //--[07]QTD. DA NECESSIDADE (CALCULO)
						        nQtdNec,;					  //--[08]QTD. DA NECESSIDADE (INFORMADA)
						        (cAliasTrb)->SLDFILNEC,;	  //--[09]SALDO DO PRODUTO x FILIAL NECESSIDADE
						        (cAliasTrb)->MEDVENDAS,;	  //--[10]MEDIA DE VENDAS DO PERIODO
						        (cAliasTrb)->EMAX,;			  //--[11]ESTOQUE MAXIMO DO PRODUTO
						       	(cAliasTrb)->SLDFILCEN,;     //--[12]SALDO DO PRODUTO x FILIAL CENTRALIZADORA
						       	 nGiro,                 ;	  //--[13]GIRO POR FILIAL
						    	 nPPendente,     		;	  //--[14]QUANTIDADE DE PEDIDOS PENDENTES
						    	 cPrUnit,               ;     //--[15]PRECO UNITARIO DO PRODUTO
						    	 cTotalPreco } )  			  //--[16]PRECO TOTAL DOS PRODUTOS  	 
				If lTPLDRO
					//Inicializa o OBJETO
					oInfoPed := NIL		
					//Instancia o objeto MATCInfoPed
					oInfoPed := DROCInfoPed():InfoPed()
		
					//Alimenta as informacoes  	 		
					oInfoPed:nMinCusto		:= (cAliasTrb)->MENOR_CUSTO				
					oInfoPed:dDtMinCusto	:= STOD((cAliasTrb)->DT_MENOR_CUSTO)
					oInfoPed:nMaxCusto		:= (cAliasTrb)->MAIOR_CUSTO
					oInfoPed:dDtMaxCusto	:= STOD((cAliasTrb)->DT_MAIOR_CUSTO)
					oInfoPed:cCodProd		:= (cAliasTrb)->CODPRO
					oInfoPed:cUnidProd		:= (cAliasTrb)->UNIDADE_MEDIDA
	
		   			oInfoPed:nUltCompra		:= (cAliasTrb)->ULTIMA_COMRA
		   			oInfoPed:dDtUltCompra	:= STOD((cAliasTrb)->DT_ULT_COMPRA)
		   			oInfoPed:nUltPrVenda	:= Posicione("SB0",1,xFilial("SB0")+(cAliasTrb)->CODPRO,"B0_PRV1")
		   			oInfoPed:dUltDtVenda	:= dDatabase
		   			oInfoPed:cNomeFabr		:= Posicione("SA2",1,xFilial("SA2")+ (cAliasTrb)->COD_FABRICANTE+(cAliasTrb)->LOJ_FABRICANTE ,"A2_NOME")
					oInfoPed:nMediaAtraso	:= Posicione("SA2",1,xFilial("SA2")+ (cAliasTrb)->COD_FABRICANTE+(cAliasTrb)->LOJ_FABRICANTE ,"A2_METR")
	
					oInfoPed:nVMesAtual		:= T_A177SB3((cAliasTrb)->FILNEC,(cAliasTrb)->CODPRO, 1)//Quantidade Atual
					oInfoPed:nVMesAnterior	:= T_A177SB3((cAliasTrb)->FILNEC,(cAliasTrb)->CODPRO, 2)//Quantidade Anterior
			  		oInfoPed:nMediaMes		:= T_A177SB3((cAliasTrb)->FILNEC,(cAliasTrb)->CODPRO, 3)//Media
			  		oInfoPed:nEstoqueAtual	:= (cAliasTrb)->SLDFILNEC	
				
			  		//Adiciona as informacoes na colecao
			  		oDadosPed:Add((cAliasTrb)->FILNEC+(cAliasTrb)->CODPRO, oInfoPed)	
			 		nTotNecObt += nQtdNec
			   		nTotNecInf += nQtdNec 
		   		Endif
			Else
				AAdd( aItens, {	(cAliasTrb)->FILNEC,;		  //--[01]FILIAL DA NECESSIDADE
						        aPARAM177[21],;				  //--[02]FILIAL CENTRALIZADORA
						        (cAliasTrb)->CODPRO,;		  //--[03]CODIGO DO PRODUTO
						        (cAliasTrb)->DESPRO,;		  //--[04]DESCRICAO
						        (cAliasTrb)->GRUPO,;		  //--[05]GRUPO
						        (cAliasTrb)->TIPO,;			  //--[06]TIPO
						        nQtdNec,;					  //--[07]QTD. DA NECESSIDADE (CALCULO)
						        nQtdNec,;					  //--[08]QTD. DA NECESSIDADE (INFORMADA)
						        0,;							  //--[09]QTD. PROPORCIONAL
						        (cAliasTrb)->SLDFILNEC,;	  //--[10]SALDO DO PRODUTO x FILIAL NECESSIDADE
						        (cAliasTrb)->MEDVENDAS,;	  //--[11]MEDIA DE VENDAS DO PERIODO
						        (cAliasTrb)->EMAX,;			  //--[12]ESTOQUE MAXIMO DO PRODUTO
						        (cAliasTrb)->SLDFILCEN} )	  //--[13]SALDO DO PRODUTO x FILIAL CENTRALIZADORA				    
			EndIf
		EndIf
				
		oProcess:IncRegua2( STR0156 ) //--"Processando registros... "
    	(cAliasTrb)->( DbSkip() )
	EndDo

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0157 ) //--"Registros exibidos com sucesso!"
		A177Log( STR0198 ) //--"Aguardando ação do usuário"
	EndIf

	If Len( aItens ) > 0

		//--REALIZA O CALCULO DA PROPORCAO
		If aPARAM177[01] == 2
			//--Totaliza as necessidades para calculo da proporcao
			aTotNec := A177TotNec(,aItens, cAliasTrb, aNecAlt)

			//--Ordena o Array por Produto + Qtd. de Necessidade + Filial Necessidade
		   If lTPLDRO
		  		ASort(aItens,,,{|x,y| x[3] + Str( x[7], aTamB2_QATU[1],;
						aTamB2_QATU[2] ) + x[1] <  y[3] + Str( y[7],;
						aTamB2_QATU[1], aTamB2_QATU[2] ) + y[1] } )			   
		   Else
				ASort(aItens,,,{|x,y| x[3] + Str( x[7], aTamB2_QATU[1],;
						aTamB2_QATU[2] ) + x[1] >  y[3] + Str( y[7],;
						aTamB2_QATU[1], aTamB2_QATU [2] ) + y[1] } )
           EndIf
			//--Realiza o calculo de proporcao
			//--Se a necessidade for maior que o saldo da filial centralizadora, aplica
			//--a regra de proporcao: (Necessidade / Total das Necessidades) * Saldo Filial Centralizadora
			For nCount := 1 To Len( aItens )
				If cCodPro <> aItens[nCount,3]
					nPropAcum := 0					
					cCodPro := aItens[nCount,3]					    
					nContProd := 0
					nQuntProd := 0
					nI := nCount  
				 	While cCodPro == aItens[nI ,3] .AND. nI <= Len(aItens) 
				   		nQuntProd += 1
				   		nI += 1	
						If nI > Len(aItens) 
							Exit 
						EndIf							
					End			 			
		   			nCount -= 1					
				Else
					If lTPLDRO
					   aItens := T_DroQProp(aItens,aTotNec,@nPropAcum, cCodPro, nCount,@nContProd,@nQuntProd,1)
					Else
						If (nPosTotNec := AScan( aTotNec, {|x| x[1] == cCodPro} )) > 0
							If aTotNec[nPosTotNec,2] > aItens[nCount,13]
								nQtdProp := Round( (aItens[nCount,7] / aTotNec[nPosTotNec, 2]) * aItens[nCount,13], TamSX3('B2_QATU')[2] )
								If nPropAcum + nQtdProp <= aItens[nCount,13]
									aItens[nCount,9] := nQtdProp
									nPropAcum += aItens[nCount,9]						
								EndIf
							Else
								aItens[nCount,9] := aItens[nCount,7]
							EndIf
						EndIf
					EndIf
				Endif
			Next
		EndIf

		//--Ajusta o Array conforme a ordem selecionada pelo usuario:
		If aPARAM177[29] == 0 .Or. aPARAM177[29] == 1 //--Produto
			ASort( aItens,,,{|x,y| x[3] < y[3]} )		
		ElseIf aPARAM177[29] == 2 //--Descricao
			ASort( aItens,,,{|x,y| x[4] < y[4]} )	
		ElseIf aPARAM177[29] == 3 //--Grupo + Produto
			ASort( aItens,,,{|x,y| x[5] + x[3] < y[5] + y[3]} )	
		ElseIf aPARAM177[29] == 4 //--Tipo + Produto
			ASort( aItens,,,{|x,y| x[6] + x[3] < y[6] + y[3]} )	
		ElseIf aPARAM177[29] == 5 //--Filial Necess. + Produto
			ASort( aItens,,,{|x,y| x[1] + x[3] < y[1] + y[3]} )	
		ElseIf aPARAM177[29] == 6 //--Filial Necess. + Descr.
			ASort( aItens,,,{|x,y| x[1] + x[4] < y[1] + y[4]} )	
		ElseIf aPARAM177[29] == 7 //--Filial Necess. + Grupo + Produto
			ASort( aItens,,,{|x,y| x[1] + x[5] + x[3] < y[1] + y[5] + y[3]} )	
		ElseIf aPARAM177[29] == 8 //--Filial Necess. + Tipo + Produto
			ASort( aItens,,,{|x,y| x[1] + x[6] + x[3] < y[1] + y[6] + y[3]} )	
		ElseIf aPARAM177[29] == 9  //--"Descr. Produto + Filial da Necess." 
            ASort( aItens,,,{|x,y| x[4] + x[1] < y[4] + y[1]} )					
		EndIf

		//-- Dimensoes padroes
		aSize    := MsAdvSize(, .F., 400)
		aInfo 	 := {aSize[1], aSize[2], aSize[3], aSize[4], 1, 1 }
		aObjects := {{100, 100,.T.,.T. }} 
		aPosObj := MsObjSize( aInfo, aObjects,.T. ) 
		
		
		//--Botoes Adicionais:
		AAdd( aButtons, {'TK_FIND' , {|| A177TWBrwPesq( @aItens, @oBrwNec ) } , STR0037, STR0038} ) //--"Pesquisar Produto..."#"Pesquisar"
		AAdd( aButtons, {'PMSPRINT', {|| A177Print( aCabec, cAliasTrb, aNecAlt, nTotReg, aItens ) }, STR0152, STR0153}) //--"Imprimir Calculo"#"Imprimir"
		If lTPLDRO    
        	AAdd( aButtons, {'S4WB009N' , {|| T_DroVldSt( @aItens,oDadosPed, oBrwNec:nAT ) } ,STR0209,STR0209} )   // 'Sintetico'     	   
		EndIf
		If Empty( aPARAM177[16] )
			aAdd( aButtons, {'SALVAR' , {|| Processa( {|| A177GrvCalc( cAliasTrb, aNecAlt, @cNumCalc, nTotReg )}, STR0043, STR0154) },STR0041, STR0042}) //--"Aguarde"#"Salvando calculo..."#"Salvar Calculo"#"Salvar"
		EndIf
		If aPARAM177[01] == 02
	  		aAdd( aButtons, {'PMSRRFSH' , {|| IIf(A177VerRecal( aNecAlt ), Processa( {|| A177ReCalPro( @aItens, @oBrwNec, aNecAlt, cAliasTrb )}, STR0043, STR0044), {||}) }, STR0201 + ' ' + STR0151, STR0201})
		EndIf                          
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Code Block a ser Executado pelo PE: MT177BUT       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		bBlockRes:={||a177ResBlock(@oBrwNec)}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PE: MT177BUT - Adcionar Botões                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock( "MT177BUT" ) 
			If ValType( aUsButtons := ExecBlock( "MT177BUT", .F., .F.,{bBlockRes}) ) == "A"
				AEval( aUsButtons, { |x| AAdd( aButtons, x ) } ) 	 	
			EndIf 	
		EndIf
	
		//--Exibicao da Tela / Browse
		Define MSDialog oDlg Title STR0001 From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel //--"Central de Compras"
	        If lTPLDRO
				TGroup():New(aPosObj[1,1]	 , aPosObj[1,2]    ,aPosObj[1,1]+73,aPosObj[1,4]-165,STR0250 ,oDlg,,,.T.) //" Informações do Produto "
				TGroup():New(aPosObj[1,1]	 , aPosObj[1,4]-169,aPosObj[1,1]+73,aPosObj[1,4]+05 ,STR0251 ,oDlg,,,.T.) //" Quantidades "
				TGroup():New(aPosObj[1,3]-35, aPosObj[1,2]    ,aPosObj[1,3]+05,aPosObj[1,4]+05 ,STR0252 ,oDlg,,,.T.) //" Totais "				
                                         
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Get's para o BOX Informacoes do produto|
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				@aPosObj[1,1]+15, aPosObj[1,2]+05 SAY STR0220 			 				PIXEL SIZE 45,25 //"Menor Compra :"
				@aPosObj[1,1]+10, aPosObj[1,2]+45 MSGET oGetMinCusto 	VAR nMinCusto  	PIXEL SIZE 40,10 PICTURE PesqPict("SD1","D1_VUNIT") WHEN .F.
				@aPosObj[1,1]+10, aPosObj[1,2]+87 MSGET oGetDtMinCus 	VAR dDtMinCusto	PIXEL SIZE 40,10 PICTURE "@!" WHEN .F.
				
				@aPosObj[1,1]+30, aPosObj[1,2]+05  SAY STR0221							PIXEL SIZE 45,25 //"Maior Compra  :"
				@aPosObj[1,1]+25, aPosObj[1,2]+45 MSGET oGetMaxCusto 	VAR nMaxCusto  	PIXEL SIZE 40,10 PICTURE PesqPict("SD1","D1_VUNIT") WHEN .F.
				@aPosObj[1,1]+25, aPosObj[1,2]+87 MSGET oGetDtMaxCus 	VAR dDtMaxCusto	PIXEL SIZE 40,10 PICTURE "@!" WHEN .F.
			
				@aPosObj[1,1]+45, aPosObj[1,2]+05 SAY STR0222 			 				PIXEL SIZE 45,25 OF oDlg //"Codigo Prod.    :"
				@aPosObj[1,1]+40, aPosObj[1,2]+45 MSGET oGetCodProd 	VAR cCodProd  	PIXEL SIZE 40,10 PICTURE "@!" WHEN .F. OF oDlg
				
				@aPosObj[1,1]+60, aPosObj[1,2]+05 SAY  STR0223 		 				PIXEL SIZE 45,25 //"Embalagem      :"
				@aPosObj[1,1]+55, aPosObj[1,2]+45 MSGET oGetUnidProd 	VAR cUnidProd 	PIXEL SIZE 40,10 PICTURE "@!" WHEN .F.
				                               //195,232,274
				@aPosObj[1,1]+15, aPosObj[1,2]+195 SAY STR0224 		  	 				 PIXEL SIZE 45,25 //"Ult. Compra   :"
				@aPosObj[1,1]+10, aPosObj[1,2]+232 MSGET oGetUltCompra 	VAR nUltCompra 	 PIXEL SIZE 40,10 PICTURE PesqPict("SD1","D1_VUNIT") WHEN .F.
				@aPosObj[1,1]+10, aPosObj[1,2]+274 MSGET oGetDtUltCompra	VAR dDtUltCompra PIXEL SIZE 40,10 PICTURE "@!" WHEN .F.
				
				@aPosObj[1,1]+30, aPosObj[1,2]+195 SAY STR0225  					    PIXEL SIZE 45,25 //"Preço Venda :"
				@aPosObj[1,1]+25, aPosObj[1,2]+232 MSGET oGetUltPrVenda 	VAR nUltPrVenda PIXEL SIZE 40,10 PICTURE PesqPict("SD1","D1_VUNIT") WHEN .F.
				@aPosObj[1,1]+25, aPosObj[1,2]+274 MSGET oGetUltDtVenda 	VAR dUltDtVenda	PIXEL SIZE 40,10 PICTURE "@!" WHEN .F.
			
				@aPosObj[1,1]+45, aPosObj[1,2]+195 SAY STR0226  				        PIXEL SIZE 45,25 //"Fabricante     :" 
				@aPosObj[1,1]+40, aPosObj[1,2]+232 MSGET oGetNomeFabr	VAR cNomeFabr  	PIXEL SIZE 82,10 PICTURE "@!" WHEN .F.
			
				@aPosObj[1,1]+60, aPosObj[1,2]+195 SAY STR0227    				        PIXEL SIZE 45,25 //"Média Atraso :"
				@aPosObj[1,1]+55, aPosObj[1,2]+232 MSGET oGetMedAtraso	VAR nMedatraso 	PIXEL SIZE 40,10 PICTURE PesqPict("SD2","D2_QUANT") WHEN .F.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Get's para o BOX Quantidades³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				@aPosObj[1,1]+15, aPosObj[1,2]+345 SAY STR0228 	 			PIXEL SIZE 55,25 //"Venda mês atual     :"
				@aPosObj[1,1]+10, aPosObj[1,2]+397 MSGET oGetMesAtu	 		VAR nMesAtu  	PIXEL SIZE 40,10 PICTURE PesqPict("SD1","D1_VUNIT") WHEN .F.
				
				
				@aPosObj[1,1]+30, aPosObj[1,2]+345 SAY STR0229  				PIXEL SIZE 55,25 //"Venda mês anterior :"
				@aPosObj[1,1]+25, aPosObj[1,2]+397 MSGET oGetMesAnt 			VAR nMesAnt 	PIXEL SIZE 40,10 PICTURE PesqPict("SD1","D1_VUNIT") WHEN .F.
				
				                              //345,397
				@aPosObj[1,1]+45, aPosObj[1,2]+345 SAY STR0230    		    	PIXEL SIZE 55,25  //"Média mensal           :"
				@aPosObj[1,1]+40, aPosObj[1,2]+397 MSGET oGetMedMes 			VAR nMedMes 	PIXEL SIZE 40,10 PICTURE PesqPict("SD1","D1_VUNIT") WHEN .F.
				
				
				@aPosObj[1,1]+60, aPosObj[1,2]+345 SAY STR0231 	 		    PIXEL SIZE 55,25  //"Estoque atual           :"
				@aPosObj[1,1]+55, aPosObj[1,2]+397 MSGET oGetEstAtu 			VAR nEstAtu 	PIXEL SIZE 40,10 PICTURE PesqPict("SB2","B2_QATU") WHEN .F.
				
				oFont := TFont():New( 'Arial',, -13,, .T. )				
				TSay():New( aPosObj[1,3]-15, aPosObj[1,2]+10, {|| STR0232 }, oDlg,, oFont,,,, .T., CLR_BLACK,, 200, 20 ) //"Necessidade Obtida: "
				TSay():New( aPosObj[1,3]-15, aPosObj[1,2]+80, {|| nTotNecObt}, oDlg,PesqPict("SD2","D2_QUANT"), oFont,,,, .T., CLR_RED,, 200, 20 )


							  	TSay():New( aPosObj[1,3]-15, aPosObj[1,2]+200, {|| STR0233 }, oDlg,, oFont,,,, .T., CLR_BLACK,, 200, 20 ) // "Necessidade Informada: "
				oTotNecInf :=	TSay():New( aPosObj[1,3]-15, aPosObj[1,2]+280, {|| nTotNecInf}, oDlg,PesqPict("SD2","D2_QUANT"), oFont,,,, .T., CLR_RED,, 200, 20 )
				
			    If aPARAM177[01] == 1
					TSay():New( aPosObj[1,3]-15, aPosObj[1,2]+370, {|| STR0234 }, oDlg,, oFont,,,, .T., CLR_BLACK,, 200, 20 )   // "Valor Total dos Produtos: "
					oTotValProd :=  TSay():New( aPosObj[1,3]-15, aPosObj[1,2]+470, {|| nValTotalProd}, oDlg,PesqPict("SD2","D2_QUANT"), oFont,,,, .T., CLR_RED,, 200, 20 )
                EndIf
			
				oBrwNec := TWBrowse():New(	aPosObj[1,1]+75, aPosObj[1,2]  , aPosObj[1,4]+4, (aPosObj[1,3]/2)+8,,aCabec,,;
				oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) 
				oBrwNec:bChange := 	 {|| A177AtuCabec(	@oGetMinCusto  			, @nMinCusto   , @oGetDtMinCus  , @dDtMinCusto,;
														@oGetMaxCusto  			, @nMaxCusto   , @oGetDtMaxCus  , @dDtMaxCusto,;
											 			@oGetUltPrVenda			, @nUltPrVenda , @oGetUltDtVenda, @dUltDtVenda,;
														@oGetCodProd   			, @cCodProd    , @oGetNomeFabr  , @cNomeFabr  ,;
														@oGetUnidProd  			, @cUnidProd   , @oGetMesAtu    , @nMesAtu    ,;
														@oGetMinCusto  			, @nMinCusto   , @oGetMesAnt    , @nMesAnt    ,;
														@oGetMedMes    			, @nMedMes     , @oGetEstAtu    , @nEstAtu    ,;
														@oGetMedatraso			, @nMedatraso  , @oGetUltCompra , @nUltCompra ,;
														@oGetDtUltCompra		, @dDtUltCompra, oBrwNec:nAT    , aItens)}
				
			    If aPARAM177[1] == 1
					oBrwNec:AddColumn(TCColumn():New( STR0235  ,{|| aItens[ oBrwNec:nAT,  1 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))  // 'Filial Necess.'
					oBrwNec:AddColumn(TCColumn():New( STR0236  ,{|| aItens[ oBrwNec:nAT,  2 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))  // 'Filial Central.'
					oBrwNec:AddColumn(TCColumn():New( STR0237  ,{|| aItens[ oBrwNec:nAT,  3 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))  // 'Produto'
					oBrwNec:AddColumn(TCColumn():New( STR0238  ,{|| aItens[ oBrwNec:nAT,  4 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))  // 'Descricao'
					oBrwNec:AddColumn(TCColumn():New( STR0239  ,{|| aItens[ oBrwNec:nAT,  5 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))  // 'Grupo'
					oBrwNec:AddColumn(TCColumn():New( STR0240  ,{|| aItens[ oBrwNec:nAT,  6 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))  // 'Tipo'
					oBrwNec:AddColumn(TCColumn():New( STR0241  ,{|| aItens[ oBrwNec:nAT,  7 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,)) // 'Necess. Obtida'
					oBrwNec:AddColumn(TCColumn():New( STR0242  ,{|| aItens[ oBrwNec:nAT,  8 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,)) // 'Necess. Informada'
					oBrwNec:AddColumn(TCColumn():New( STR0243  ,{|| aItens[ oBrwNec:nAT,  9 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,)) // 'Saldo Atual'
					oBrwNec:AddColumn(TCColumn():New( STR0244  ,{|| aItens[ oBrwNec:nAT, 10 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,)) // 'Media Vendas'
					oBrwNec:AddColumn(TCColumn():New( STR0245  ,{|| aItens[ oBrwNec:nAT, 11 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,))  // "Est. Maximo"
					oBrwNec:AddColumn(TCColumn():New( STR0246  ,{|| aItens[ oBrwNec:nAT, 12 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,))  // "Sld. Filial Cent."
					oBrwNec:AddColumn(TCColumn():New( STR0216  ,{|| aItens[ oBrwNec:nAT, 13 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,))  // "Giro"
					oBrwNec:AddColumn(TCColumn():New( STR0247	,{|| aItens[ oBrwNec:nAT, 14 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,))  // "Quant.Ped. Pendentes" 
					oBrwNec:AddColumn(TCColumn():New( STR0248  ,{|| aItens[ oBrwNec:nAT, 15 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,))  // "Preco Unitario" 
					oBrwNec:AddColumn(TCColumn():New( STR0249  ,{|| aItens[ oBrwNec:nAT, 16 ] },,,,'RIGHT',,.F.,.F.,,,,.F.,))  // "Preco Total"
				EndIf				
				oBrwNec:bLDblClick := {|| A177EdtCol( @aItens, oBrwNec:nAT, .T.,@aNecAlt,@oTotNecInf,@nTotNecInf,@oTotValProd,@nValTotalProd,nDecimais  ) }
			Else
				oBrwNec := TWBrowse():New( aInfo[2], aInfo[1], aInfo[3]+2, aInfo[4]+2,,aCabec,,oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		        oBrwNec:bLDblClick := {|| A177EdtCol( @aItens, oBrwNec:nAT, .T., @aNecAlt ) }
			Endif
			
			oBrwNec:SetArray( aItens )
			
			If aPARAM177[01] == 01
				oBrwNec:bLine := {|| {	aItens[ oBrwNec:nAT, 01 ], aItens[ oBrwNec:nAT, 02 ], aItens[ oBrwNec:nAT, 03 ],;
						 				aItens[ oBrwNec:nAT, 04 ], aItens[ oBrwNec:nAT, 05 ], aItens[ oBrwNec:nAT, 06 ],;
										aItens[ oBrwNec:nAT, 07 ], aItens[ oBrwNec:nAT, 08 ], aItens[ oBrwNec:nAT, 09 ],;
										aItens[ oBrwNec:nAT, 10 ], aItens[ oBrwNec:nAT, 11 ], aItens[ oBrwNec:nAT, 12 ],;
										aItens[ oBrwNec:nAT, 13 ], aItens[ oBrwNec:nAT, 14 ], aItens[ oBrwNec:nAT, 15 ],;
										aItens[ oBrwNec:nAT, 16 ] } }
			Else
				oBrwNec:bLine := {|| {	aItens[ oBrwNec:nAT, 01 ], aItens[ oBrwNec:nAT, 02 ], aItens[ oBrwNec:nAT, 03 ],;
									 	aItens[ oBrwNec:nAT, 04 ], aItens[ oBrwNec:nAT, 05 ], aItens[ oBrwNec:nAT, 06 ],;
									 	aItens[ oBrwNec:nAT, 07 ], aItens[ oBrwNec:nAT, 08 ], aItens[ oBrwNec:nAT, 09 ],;
										aItens[ oBrwNec:nAT, 10 ], aItens[ oBrwNec:nAT, 11 ], aItens[ oBrwNec:nAT, 12 ],;
										aItens[ oBrwNec:nAT, 13 ] } }
			EndIf
	
		Activate MSDialog oDlg On Init EnchoiceBar( oDlg, {|| nOpcA := 1, oDlg:End()}, {|| oDlg:End()},, aButtons )
	Else
		Help( ' ', 1, 'MATA17701' )
	EndIf
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³NAO EXIBE A TELA COM AS NECESSIDADES, APENAS³
	//³DISPONIBILIZA PESQUISA E AGUARDA CONFIRMACAO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0198 ) //--"Aguardando ação do usuário"
	EndIf 
	
	//--Botoes Adicionais
	AAdd( aButtons, {'PMSPRINT', {|| A177Print( aCabec, cAliasTrb, aNecAlt, nTotReg, aItens ) }, STR0152, STR0153}) //--"Imprimir Calculo"#"Imprimir"
	If Empty( aPARAM177[16] )
		aAdd( aButtons, {'SALVAR', {|| Processa( {|| A177GrvCalc( cAliasTrb, aNecAlt, @cNumCalc, nTotReg )}, STR0043, STR0154) },STR0041, STR0042}) //--"Aguarde"#"Salvando calculo..."#"Salvar Calculo"#"Salvar"
	EndIf

	//--Cria linha de itens vazia
	aItens := Array( 1, Len( aCabec ) ) 
	Define MSDialog oDlg Title STR0001 From 000, 000 To 500,650 Pixel //--"Central de Compras"

	  //--Grupo EDITAR NECESSIDADES
		TGroup():New( 015, 005, 055, 320, STR0158, oDlg, CLR_BLUE,, .T. ) //--" EDITAR NECESSIDADE "
		@ 025, 010 Say STR0159 Pixel Of oDlg //--"Codigo do Produto: "
		@ 035, 010 MsGet oCodPro Var cCodPro Picture '@!' ;
					F3 'SB1' ;
					Size 70, 10 ;
					Valid Empty( cCodPro ) .Or. A177VldPro( cCodPro, @cDesPro ) ;
					Pixel Of oDlg
	
		@ 025, 085 Say STR0160 Pixel Of oDlg //--"Descricao: "
		@ 035, 085 MsGet oDesPro Var cDesPro Picture '@!' ;
					When .F. ;
					Size 150, 10 ;
					Pixel Of oDlg
	
		oBtnEdtNec  := TButton():New( 030, 245, STR0161, oDlg,; //--"Editar Necessidades"
										{|| oCodPro:Disable(), oBtnEdtNec:Disable(), oBtnOkNec:Enable(), oBtnCancNec:Enable(), oBrwNec:Enable(),;
										A177BuildBrw( aCabec, @aItens, @oBrwNec, cCodPro, aNecAlt, cAliasTrb, oBtnCancNec )},; 
										070,15,,,,.T. )
	
		//--Grupo NECESSIDADES
		TGroup():New( 060, 005, 230, 320, STR0162, oDlg, CLR_BLUE,, .T. ) //--" NECESSIDADES "
	
		//--Definicao e Criacao do Grid
		oBrwNec := TWBrowse():New( 070, 010, 305, 135,, aCabec,, oDlg,,,,, {||},,,,,,, .F.,, .T.,, .F.,,, )
	
		oBrwNec:bLDblClick := {||  A177EdtCol( @aItens, oBrwNec:nAT, .F., @aNecAlt ) }
		
		oBrwNec:SetArray( aItens )
		If aPARAM177[01] == 01
			oBrwNec:bLine := {|| {	aItens[ oBrwNec:nAT, 01 ], aItens[ oBrwNec:nAT, 02 ], aItens[ oBrwNec:nAT, 03 ],;
									aItens[ oBrwNec:nAT, 04 ], aItens[ oBrwNec:nAT, 05 ], aItens[ oBrwNec:nAT, 06 ],;
									aItens[ oBrwNec:nAT, 07 ], aItens[ oBrwNec:nAT, 08 ], aItens[ oBrwNec:nAT, 09 ],;
									aItens[ oBrwNec:nAT, 10 ], aItens[ oBrwNec:nAT, 11 ], aItens[ oBrwNec:nAT, 12 ] } }
		Else
			oBrwNec:bLine := {|| {	aItens[ oBrwNec:nAT, 01 ], aItens[ oBrwNec:nAT, 02 ], aItens[ oBrwNec:nAT, 03 ],;
									aItens[ oBrwNec:nAT, 04 ], aItens[ oBrwNec:nAT, 05 ], aItens[ oBrwNec:nAT, 06 ],;
									aItens[ oBrwNec:nAT, 07 ], aItens[ oBrwNec:nAT, 08 ], aItens[ oBrwNec:nAT, 09 ],;
									aItens[ oBrwNec:nAT, 10 ], aItens[ oBrwNec:nAT, 11 ], aItens[ oBrwNec:nAT, 12 ],;
									aItens[ oBrwNec:nAT, 13 ] } }
		EndIf
		
		oBtnOkNec   := TButton():New(	210, 170, STR0163, oDlg,; //--"Confirmar Edicao"
										{|| oBtnOkNec:Disable(), oBtnCancNec:Disable(), oCodPro:Enable(), oBtnEdtNec:Enable(), oBrwNec:Disable(),;
										A177EdtOK( aCabec, @aItens, @aNecAlt, @oBrwNec) }, 070, 015,,,,.T. )
		
		oBtnCancNec := TButton():New(	210, 245, STR0164, oDlg,; //--"Cancelar Edicao"
										{|| oBtnOkNec:Disable(), oBtnCancNec:Disable(), oCodPro:Enable(), oBtnEdtNec:Enable(), oBrwNec:Disable(),;
										aItens := Array(1, Len(aCabec) ), oBrwNec:SetArray( aItens ), oBrwNec:Refresh() }, 070, 015,,,,.T. )

		oBrwNec:Disable()
		oBtnOkNec:Disable()
		oBtnCancNec:Disable()
	
	Activate MSDialog oDlg Center On Init EnchoiceBar( oDlg, {|| IIf(A177ValEdt(oBrwNec),(nOpcA := 1, oDlg:End()), nOpcA := 0)}, {|| oDlg:End()},, aButtons )

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PROCESSAMENTO DAS NECESSIDADES³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA == 1
	If aPARAM177[01] == 1
		//--Processo de Compras
		If aPARAM177[02] == 1
			//--Gerar Documento "Solicitacao de Compras"
			bAction := {|lEnd| A177GrvSC1( @lEnd, cAliasTrb, aItens, aNecAlt, nTotReg, @aSelGrupos ) }
		ElseIf aPARAM177[02] == 2
			//--Gerar Documento "Pedido de Compra"
			bAction := {|lEnd| A177GrvSC7( @lEnd, cAliasTrb, aItens, aNecAlt, nTotReg,lBonus, @aSelGrupos ) }
		EndIf
	ElseIf aPARAM177[01] == 2
		//--Processo de Distribuicao
		bAction := {|lEnd| A177GrvDist( @lEnd, cAliasTrb, aItens, aNecAlt, nTotReg, @aSelGrupos ) }
	EndIf
	Processa( bAction, STR0043, STR0044, .T. ) //--"Aguarde"#"Processando o Calculo..."	      
Else
	A177UnLockGr(@aSelGrupos)	
EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177GrvSC1   ³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³GERACAO DAS SOLICITACOES DE COMPRA                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177GrvSC1( lEnd, cAliasTrb, aItens, aNecAlt, nTotReg,aSelGrupos )
Local aAreaSB1   := SB1->( GetArea() )
Local aCbSC      := {}
Local aItSC      := {}
Local aMsgErr    := {}
Local aPedVen    := {}
Local aCbPV      := {}
Local aItPV      := {}
Local aDadCli    := {}
Local cFilSB1    := ''
Local cFilAntBkp := cFilAnt
Local cItemSC    := ''
Local cQuebra    := ''
Local cTxtLog    := ''
Local cItemPV    := ''
Local nQtdNec    := 0
Local nPosNec    := 0
Local nCount     := 0
Local nProc      := 0  
Local cPreco     := ""   //preco para a geracao dos pedidos de Venda  
Local nDecimais  := msdecimais(1)     // retorna o numero de casas decimais para moeda

//--Ponto de entrada para manipular a Qtd. da Necessidade
Local lMTA177Nec := ExistBlock('MTA177Nec')
Local nMTA177Nec := 0     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³INICIO DO PROCESSAMENTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0172 ) //--"Iniciando a geracao de Solicitacoes de Compra"
EndIf

If lTPLDRO
	cPreco 	 := If(aPARAM177[33] == 1, "SB1->B1_PRV1","SB2->B2_CM1")
Else
	cPreco   := "SB1->B1_PRV1"  
EndIf
ProcRegua( nTotReg )
(cAliasTrb)->( DbGoTop() )
Do While !(cAliasTrb)->( Eof() ) .And. !lEnd
	//--Verifica o tipo da analise:
	//--(1) - Por Filial | (2) - Por Filial Centralizadora
	cFilAnt := If( aPARAM177[20] == 1, (cAliasTrb)->FILNEC, aPARAM177[21] )

	aCbSC := {}
	aItSC := {}
	If cQuebra <> (cAliasTrb)->FILNEC
		//--Cabecalho da Solicitacao de Compras
		AAdd( aCbSC, {'C1_SOLICIT', CriaVar( 'C1_SOLICIT', .T. )	, Nil} )
		AAdd( aCbSC, {'C1_EMISSAO', dDataBase						, Nil} )
		AAdd( aCbSC, {'C1_FILENT' , (cAliasTrb)->FILNEC				, NIL} )
		
		cQuebra := (cAliasTrb)->FILNEC
		cItemSC := StrZero( 0, Len( SC1->C1_ITEM ) )
	EndIf

	//--Itens
	Do While !(cAliasTrb)->( Eof() ) .And. cQuebra == (cAliasTrb)->FILNEC
		//--Verifica se a necessidade foi alterada
		nPosNec := AScan( aNecAlt, {|x| x[1] + x[2] == (cAliasTrb)->( FILNEC + CODPRO )} )
		If nPosNec <> 0
			nQtdNec := aNecAlt[nPosNec,3]
		Else
			If aPARAM177[22]
				//--Caso os dados tenham sido exibidos em tela,
				//--nao realiza novamente o calculo das necessidades...
				nPosNec := AScan( aItens, {|x| x[1] + x[3] == (cAliasTrb)->( FILNEC + CODPRO )} )
				nQtdNec := If( nPosNec <> 0, aItens[nPosNec,8], 0 )
			Else
				If aPARAM177[06] == 1 .Or. aPARAM177[06] == 2
					nQtdNec := (cAliasTrb)->QTDNEC
				Else
					nQtdNec := A177CalcNec( (cAliasTrb)->FILNEC, (cAliasTrb)->CODPRO, (cAliasTrb)->SLDFILNEC )
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³P. E. PARA MODIFICAR A QTDE. DA NECESSIDADE³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lMTA177Nec
					 nMTA177Nec := ExecBlock('MTA177Nec', .F., .F.,;
												{ (cAliasTrb)->CODPRO,;    //--[01]Codigo do Produto
												  aPARAM177[20],;          //--[02]Processamento por Filial (1) ou Centralizado (2)
												  (cAliasTrb)->FILNEC,;    //--[03]Filial Necessidade
												  aPARAM177[21],;          //--[04]Filial Centralizadora
												  nQtdNec,;                //--[05]Necessidade Obtida
												  (cAliasTrb)->MEDVENDAS,; //--[06]Media de Vendas do periodo
												  (cAliasTrb)->EMAX,;      //--[07]Estoque Maximo do Produto na filial da necessidade
												  (cAliasTrb)->SLDFILNEC,; //--[08]Saldo atual na filial da necessidade
												  (cAliasTrb)->SLDFILCEN,; //--[09]Saldo atual na filial Centralizadora
												  aPARAM177[19],;          //--[10]Filiais selecionadas
												  aPARAM177[27],;          //--[11]Tipos selecionados
												  aPARAM177[26],;          //--[12]Grupos selecionados
												  aPARAM177[25],;          //--[13]Categorias selecionadas
												  aPARAM177[28],;          //--[14]Filtro especifico do usuario
												  aPARAM177[29] })         //--[15]Ordem selecionada pelo usuario

					If ValType( nMTA177Nec ) == 'N'
						nQtdNec := nMTA177Nec
					EndIf				
				EndIf
			EndIf
		EndIf
		If nQtdNec > 0
			cItemSC := Soma1( cItemSC )
			AAdd( aItSC, {	{ 'C1_ITEM'   , cItemSC				, NIL } ,;
							{ 'C1_PRODUTO', (cAliasTrb)->CODPRO	, NIL } ,;
							{ 'C1_QUANT'  , nQtdNec				, NIL } } )
		EndIf
		IncProc()
		(cAliasTrb)->( DbSkip() )	
	EndDo
				
	//--Efetua a inclusao da SC
	If Len( aCbSC ) > 0 .And. Len( aItSC ) > 0
		lMsErroAuto := .F.
		MSExecAuto( {|v,x,y,z| MATA110(v, x, y, z)}, aCbSC, aItSC, 3, .F. )
		If lMsErroAuto		
			cTxtLog := NomeAutoLog()
			If ValType( cTxtLog ) == 'C'
				AAdd( aMsgErr, Memoread( cTxtLog ) )
			EndIf			
		Else
			nProc++ //--Incrementa o contador somente se nao houver erro
			
			//--Verifica o tratamento para geracao do documento
			//--de previsao de saida na filial centralizadora
			If aPARAM177[20] == 2 .And. aPARAM177[05] == 1
				aDadCli := A177GetCli( aCbSC[3,2] )
				If Len( aDadCli ) == 3
					If AScan( aPedVen, {|x| x[1,2,2] + x[1,3,2] == aDadCli[1] + aDadCli[2]} ) == 0
						AAdd( aPedVen, Array(2) )
						ATail(aPedVen)[1] := {}
						ATail(aPedVen)[2] := {}

						//--Cabecalho
						AAdd( ATail(aPedVen)[1], {'C5_TIPO'		, 'N'		, NIL})
						AAdd( ATail(aPedVen)[1], {'C5_CLIENTE'	, aDadCli[1], NIL})
						AAdd( ATail(aPedVen)[1], {'C5_LOJACLI'	, aDadCli[2], NIL})
						AAdd( ATail(aPedVen)[1], {'C5_CONDPAG'	, aDadCli[3], NIL})
					EndIf

					cItemPV := StrZero( 0, Len( SC6->C6_ITEM ) )
					//--Itens do Pedido de Vendas
					For nCount := 1 To Len( aItSC )
						//--Posicionar no produto...
						cFilSB1 := If( a177MdAccess("SB1"), FWxFilial('SB1'), aCbSC[3,2] ) 
						SB1->( DbSetOrder(1) )
						SB1->( DbSeek( cFilSB1 + aItSC[nCount,2,2] ) )
						
						cItemPV := Soma1( cItemPV )											      	
						AAdd( ATail(aPedVen)[2], {	{ 'C6_ITEM'		, cItemPV								, NIL },;
													{ 'C6_PRODUTO'	, aItSC[nCount,2,2]						, NIL },;
													{ 'C6_QTDVEN'	, aItSC[nCount,3,2]						, NIL },;
													{ 'C6_PRCVEN'	, Round(&(cPreco),nDecimais)			, NIL },;
													{ 'C6_PRUNIT'	, Round(&(cPreco),nDecimais)			, NIL },;
													{ 'C6_TES'		, RetFldProd(aItSC[nCount,2,2], 'B1_TS') , NIL } } )
					Next
				EndIf
			EndIf	
		EndIf
	EndIf
EndDo

//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0173 + AllTrim( Str( nProc ) ) + STR0174 ) //--"Geracao das Solicitacoes de compra concluida. Geradas "#" Solicitacoes"
EndIf

//--Verifica o tratamento para geracao do documento
//--de previsao de saida na filial centralizadora
If aPARAM177[20] == 2 .And. aPARAM177[05] == 1 .And. Len( aPedVen ) > 0

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0175 ) //--"Inicio da geracao dos Documentos de Previsao de Saida na Filial Centralizadora"
		nProc := 0
	EndIf

	ProcRegua( Len( aPedVen ) )	
	For nCount := 1 To Len( aPedVen )
		aCbPV := aPedVen[nCount, 1]
		aItPV := aPedVen[nCount, 2]
		//--Gera o Pedido de Venda
		lMsErroAuto := .F.
		MSExecAuto( {|x,y,z| MATA410(x, y, z) }, aCbPV, aItPV, 3 )
		If lMsErroAuto
			cTxtLog := NomeAutoLog()
			If ValType( cTxtLog ) == 'C'
				AAdd( aMsgErr, Memoread( cTxtLog ) )
			EndIf
		Else
			nProc++ //--Incrementa o contador somente se nao houver erro
		EndIf
		IncProc()
	Next

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0176 + AllTrim( Str( nProc ) ) + STR0177 ) //--"Geracao dos Documentos de Previsao de Saida concluida. Gerados "##" Documentos"
	EndIf
EndIf

//--Exibe LOG com as inconsistencias
If Len( aMsgErr ) > 0
	For nCount := 1 To Len( aMsgErr )
		AutoGrLog( aMsgErr[nCount] )
	Next
	AutoGrLog('')
	MostraErro()
EndIf

A177UnLockGr(@aSelGrupos) //Destrava os Grupos usados
cFilAnt := cFilAntBKP    
RestArea( aAreaSB1 )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177GrvSC7   ³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³REALIZA A GERACAO DOS PEDIDOS DE COMPRA                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177GrvSC7( lEnd, cAliasTrb, aItens, aNecAlt, nTotReg,lBonus,aSelGrupos )
Local aAreaSB1   := SB1->( GetArea() )
Local aAreaAIB   := AIB->( GetArea() )
Local aPedVen    := {}
Local aCbPV      := {}
Local aItPV      := {}
Local aDadCli    := {}
Local aCbSC      := {}
Local aItSC      := {}
Local aDadFor    := {}
Local aMsgErr    := {}
Local cItemPV    := ''
Local cTxtLog    := ''
Local cItemPC    := ''
Local cQuebra    := ''
Local cFilSB1    := ''
Local cFilAIB    := ''
Local cFilAntBkp := cFilAnt
Local lCabec     := .F.
Local nProc      := 0
Local nQtdNec    := 0
Local nPrUnit    := 0
Local nPosNec    := 0
Local nCount     := 0    
Local cArqLog    := "CentralCompras.Log"      
Local cPreco     := "" //preco para a geracao dos Pedidos de venda
Local nDecimais  := msdecimais(1)     // retorna o numero de casas decimais para moeda

//--Ponto de entrada para manipular a Qtd. da Necessidade
Local lMTA177Nec := ExistBlock('MTA177Nec')
Local nMTA177Nec := 0     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³INICIO DO PROCESSAMENTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0178 ) //--"Iniciando a geracao dos Pedidos de Compra"
EndIf

If lTPLDRO
	cPreco 	 := If(aPARAM177[33] == 1, "SB1->B1_PRV1","SB2->B2_CM1")
Else
	cPreco   := "SB1->B1_PRV1"  
EndIf
	
ProcRegua( nTotReg )
(cAliasTrb)->( DbGoTop() )   
Begin Transaction
Do While !(cAliasTrb)->( Eof() ) .And. !lEnd
	//--Verifica o tipo da analise:
	//--(1) - Por Filial | (2) - Por Filial Centralizadora
	cFilAnt := If( aPARAM177[20] == 1, (cAliasTrb)->FILNEC, aPARAM177[21] )

	aCbPC := {}
	aItPC := {}

	//--Cabecalho do Pedido de Compras
	If cQuebra <> (cAliasTrb)->( FILNEC + CODFOR + LOJA ) 
		//--Obtem o Fornecedor
   	    aDadFor  := A177GetFor( (cAliasTrb)->FILNEC, (cAliasTrb)->CNPJFOR, (cAliasTrb)->CODPRO ,(cAliasTrb)->CODFOR,(cAliasTrb)->LOJA )  
		If Len( aDadFor ) == 3
			//--Cabecalho do Pedido de Compra
			AAdd( aCbPC, {'C7_NUM'		, Criavar('C7_NUM',.T.)		, Nil})	//--Numero do Pedido
			AAdd( aCbPC, {'C7_EMISSAO'	, dDataBase					, Nil})	//--Data de Emissao
			AAdd( aCbPC, {'C7_FORNECE'	, aDadFor[1]				, Nil})	//--Fornecedor
			AAdd( aCbPC, {'C7_LOJA'		, aDadFor[2]				, Nil})	//--Loja do Fornecedor
			AAdd( aCbPC, {'C7_CONTATO'	, CriaVar('C7_CONTATO',.F.)	, Nil})	//--Contato
			AAdd( aCbPC, {'C7_COND'		, aDadFor[3]				, Nil})	//--Condicao de Pagamento
			AAdd( aCbPC, {'C7_FILENT'	, (cAliasTrb)->FILNEC		, Nil})	//--Filial de Entrega 
			
			cQuebra := (cAliasTrb)->( FILNEC + CODFOR + LOJA )   
			cItemPC   := StrZero( 0, Len( SC7->C7_ITEM ) )
			lCabec  := .T.
		Else    
			//--Despreza o Registro, pois o fornecedor eh inconsistente!
			(cAliasTrb)->( DbSkip() )
			cQuebra := ''
			lCabec  := .F.
		EndIf
	EndIf

	//--Itens do Pedido de Compra
	Do While lCabec .And. !(cAliasTrb)->( Eof() ) .And. cQuebra == (cAliasTrb)->( FILNEC + CODFOR + LOJA )
		//--Verifica se a necessidade foi alterada
		nPosNec := AScan( aNecAlt, {|x| x[1] + x[2] == (cAliasTrb)->( FILNEC + CODPRO )} )
		If nPosNec <> 0
			nQtdNec := aNecAlt[nPosNec,3]
		Else
			If aPARAM177[22]
				//--Caso os dados tenham sido exibidos em tela,
				//--nao realiza novamente o calculo das necessidades...
				nPosNec := AScan( aItens, {|x| x[1] + x[3] == (cAliasTrb)->( FILNEC + CODPRO )} )
				nQtdNec := If( nPosNec <> 0, aItens[nPosNec,8], 0 )
			Else
				If aPARAM177[06] == 1 .Or. aPARAM177[06] == 2
					nQtdNec := (cAliasTrb)->QTDNEC
				Else
					nQtdNec := A177CalcNec( (cAliasTrb)->FILNEC, (cAliasTrb)->CODPRO, (cAliasTrb)->SLDFILNEC )
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³P. E. PARA MODIFICAR A QTDE. DA NECESSIDADE³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lMTA177Nec
					 nMTA177Nec := ExecBlock('MTA177Nec', .F., .F.,;
												{ (cAliasTrb)->CODPRO,;    //--[01]Codigo do Produto
												  aPARAM177[20],;          //--[02]Processamento por Filial (1) ou Centralizado (2)
												  (cAliasTrb)->FILNEC,;    //--[03]Filial Necessidade
												  aPARAM177[21],;          //--[04]Filial Centralizadora
												  nQtdNec,;                //--[05]Necessidade Obtida
												  (cAliasTrb)->MEDVENDAS,; //--[06]Media de Vendas do periodo
												  (cAliasTrb)->EMAX,;      //--[07]Estoque Maximo do Produto na filial da necessidade
												  (cAliasTrb)->SLDFILNEC,; //--[08]Saldo atual na filial da necessidade
												  (cAliasTrb)->SLDFILCEN,; //--[09]Saldo atual na filial Centralizadora
												  aPARAM177[19],;          //--[10]Filiais selecionadas
												  aPARAM177[27],;          //--[11]Tipos selecionados
												  aPARAM177[26],;          //--[12]Grupos selecionados
												  aPARAM177[25],;          //--[13]Categorias selecionadas
												  aPARAM177[28],;          //--[14]Filtro especifico do usuario
												  aPARAM177[29] })         //--[15]Ordem selecionada pelo usuario

					If ValType( nMTA177Nec ) == 'N'
						nQtdNec := nMTA177Nec
					EndIf				
				EndIf
			EndIf
		EndIf

		If nQtdNec > 0
			//--Posicionar no produto...
			cFilSB1  := If( a177MdAccess("SB1"), FWxFilial('SB1'), (cAliasTrb)->FILNEC ) 
			SB1->( DbSetOrder(1) )
			SB1->( DbSeek( cFilSB1 + (cAliasTrb)->CODPRO ) )
			If aPARAM177[17] == 1
				nPrUnit := RetFldProd((cAliasTrb)->CODPRO, 'B1_UPRC')
			ElseIf aPARAM177[17] == 2
				//-- Obtem o preco unitario atraves da tabela informada e para o fornecedor do pedido de compra
				cFilAIB := If( a177MdAccess("AIB"), FWxFilial('AIB'), (cAliasTrb)->FILNEC ) 
				nPrUnit := GetAdvFval( 'AIB','AIB_PRCCOM', cFilAIB + aDadFor[1] + aDadFor[2] + aPARAM177[18] + SB1->B1_COD, 2 )
			Else
				nPrUnit := RetFldProd((cAliasTrb)->CODPRO, 'B1_CUSTD')
			EndIf

			cItemPC := Soma1( cItemPC )
			AAdd(aItPC, {	{ 'C7_ITEM'		, cItemPC														 , NIL },;
							{ 'C7_PRODUTO'	, (cAliasTrb)->CODPRO									  		 , NIL },;
							{ 'C7_CODTAB'	, Iif(aPARAM177[17] = 2, aPARAM177[18], Criavar('C7_CODTAB',.F.)), NIL },;
							{ 'C7_QUANT'	, nQtdNec														 , NIL },;
							{ 'C7_PRECO'	, nPrUnit														 , NIL },;
							{ 'C7_TES'		, RetFldProd((cAliasTrb)->CODPRO, 'B1_TE')						 , NIL },;
							{ 'C7_TPOP'		, 'F'															 , NIL } } )	
		EndIf
		IncProc()
		(cAliasTrb)->( DbSkip() )
	EndDo
	If lTPLDRO
		If Len(aItPC) > 0
			aA177C7 := T_MTA177C7(aCbPC, aItPC, lBonus )
			If ValType( aA177C7 ) == "A"
				aCbPC := aA177C7[1]
				aItPC := aA177C7[2]
			EndIf 
			cNumPed := aCbPC[1][2]		
		Endif
	EndIf
	
	If Len( aCbPC ) > 0 .And. Len( aItPC ) > 0
		lMsErroAuto := .F.
		DbSelectArea("SC7")
		MSExecAuto({|v,x,y,z,w| MATA120(v, x, y, z, w) }, 1, aCbPC, aItPC, 3, .F. )
		If lMsErroAuto
			cTxtLog := NomeAutoLog()
			If ValType( cTxtLog ) == 'C'
				AAdd( aMsgErr, Memoread( cTxtLog ) )
			EndIf
			Disarmtransaction()
			Exit			
		Else
			nProc++ //--Incrementa o contador somente se nao houver erro
			
			//--Verifica o tratamento para geracao do documento
			//--de previsao de saida na filial centralizadora
			If aPARAM177[20] == 2 .And. aPARAM177[05] == 1 
				aDadCli := A177GetCli( aCbPC[7,2] )
					If Len( aDadCli ) == 3
						If AScan( aPedVen, {|x| x[1,2,2] + x[1,3,2] == aDadCli[1] + aDadCli[2]} ) == 0
							AAdd( aPedVen, Array(2) )
							ATail(aPedVen)[1] := {}
							ATail(aPedVen)[2] := {}
	
							//--Cabecalho
							AAdd( ATail(aPedVen)[1], {'C5_TIPO'		, 'N'		, NIL})
							AAdd( ATail(aPedVen)[1], {'C5_CLIENTE'	, aDadCli[1], NIL})
							AAdd( ATail(aPedVen)[1], {'C5_LOJACLI'	, aDadCli[2], NIL})
							AAdd( ATail(aPedVen)[1], {'C5_CONDPAG'	, aDadCli[3], NIL})
						EndIf
	
						cItemPV := StrZero( 0, Len( SC6->C6_ITEM ) )
						//--Itens do Pedido de Vendas
						For nCount := 1 To Len( aItPC )
							//--Posicionar no produto...
							cFilSB1 := If( a177MdAccess("SB1"), FWxFilial('SB1'), aCbPC[7,2] ) 
							SB1->( DbSetOrder(1) )
							SB1->( DbSeek( cFilSB1 + aItPC[nCount,2,2] ) ) 
	
							cItemPV := Soma1( cItemPV )
							AAdd( ATail(aPedVen)[2], {	{ 'C6_ITEM'		, cItemPV								, NIL },;
														{ 'C6_PRODUTO'	, aItPC[nCount,2,2]						, NIL },;
														{ 'C6_QTDVEN'	, aItPC[nCount,4,2]						, NIL },;
														{ 'C6_PRCVEN'	, Round(&(cPreco),nDecimais)			, NIL },;
														{ 'C6_PRUNIT'	, Round(&(cPreco),nDecimais)			, NIL },;
														{ 'C6_TES'		, RetFldProd(aItPC[nCount,2,2], 'B1_TS'), NIL } } )
						Next
					EndIf 
			EndIf
		EndIf
	EndIf
EndDo

//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0179 + AllTrim( Str( nProc ) ) + STR0180 ) //--"Geração dos Pedidos de Compra concluída. Gerados "#" Pedidos"
EndIf

//--Verifica o tratamento para geracao do documento
//--de previsao de saida na filial centralizadora
If aPARAM177[20] == 2 .And. aPARAM177[05] == 1 .And. Len( aPedVen ) > 0 .AND. !lMsErroAuto

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0175 ) //--"Inicio da geracao dos Documentos de Previsao de Saida na Filial Centralizadora"
		nProc := 0
	EndIf

	ProcRegua( Len( aPedVen ) )
	For nCount := 1 To Len( aPedVen )
		aCbPV       := aPedVen[nCount, 1]
		aItPV       := aPedVen[nCount, 2]
		lMsErroAuto := .F.
		MSExecAuto( {|x,y,z| MATA410(x, y, z) }, aCbPV, aItPV, 3 )
		If lMsErroAuto
			cTxtLog := NomeAutoLog()
			If ValType( cTxtLog ) == 'C'
				AAdd( aMsgErr, Memoread( cTxtLog ) )
			EndIf
			Disarmtransaction()
		   	Exit
		Else
			nProc++ //--Incrementa o contador somente se nao houver erro
		EndIf
		IncProc()
	Next

	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0176 + AllTrim( Str( nProc ) ) + STR0177 ) //--'Geracao dos Documentos de Previsao de Saida concluida. Gerados '#' Documentos'
	EndIf
EndIf
End Transaction

//--Exibe LOG com as inconsistencias encontradas...
If Len( aMsgErr ) > 0
	For nCount := 1 To Len( aMsgErr )
		AutoGrLog( aMsgErr[nCount] )
	Next
	AutoGrLog('')
	MostraErro()
	If lTPLDRO
		T_DRODelLKC(cNumPed) 	    
	Endif
EndIf

A177UnLockGr(@aSelGrupos) //Destrava os Grupos usados
RestArea( aAreaSB1 )
RestArea( aAreaAIB )
cFilAnt := cFilAntBKP
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177GrvDist  ³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³REALIZA A GERACAO DA DISTRIBUICAO (PEDIDOS DE VENDA)        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177GrvDist( lEnd, cAliasTrb, aItens, aNecAlt, nTotReg, aSelGrupos) 
Local aAreaSB1   := SB1->( GetArea() )
Local aAreaAIB   := AIB->( GetArea() )
Local aTotNec    := {}
Local aDadCli    := {}
Local aDadFor    := {}
Local aCbPV      := {}
Local aItPV      := {}
Local aQtdProp   := {}
Local aSolic     := {}
Local aCbSC      := {}
Local aItSC      := {}
Local aProdPC    := {}
Local aCbPC      := {}
Local aItPC      := {}
Local aMsgErr    := {}
Local cTxtLog    := ''
Local cItemPC    := ''
Local cItemSC    := ''
Local cItemPV    := ''
Local cQuebra    := ''
Local cFilSB1    := ''
Local cFilAIB    := ''
Local cFilAntBkp := cFilAnt
Local lCabec     := .F.
Local nProc      := 0
Local nQtdNec    := 0
Local nPosNec    := 0
Local nPosProp   := 0
Local nPosItem   := 0
Local nCount     := 0
Local nPrUnit    := 0  
Local cArqLog    := "CentralCompras.Log"  
Local cPreco     := "" // Preco para a geracao do Pedido de Venda 
Local nDecimais  := msdecimais(1)     // retorna o numero de casas decimais para moeda

//--Ponto de entrada para manipular a Qtd. da Necessidade
Local lMTA177Nec := ExistBlock('MTA177Nec')
Local nMTA177Nec := 0    
Local xRet       // Variavel para uso de controle do Ponto de entrada
Local cTES       := "" // Guarda a TES de Entrada e Saida para a Geracao dos Pedidos    
Local aAuxPc     := {"","",""} // Guarda o Produto, TES e a Filial de necessidade para o Ponto de Eentrada.

//--Controle da Qtde de Itens para geracao do Pedido de venda
Local nQtdItens  := SuperGetMV( 'MV_QTITENS', .F., 999999 )
Local nTotItens  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³INICIO DO PROCESSAMENTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0181 ) //--"Iniciando a geracao dos Pedidos de Venda"
EndIf

If lTPLDRO
	cPreco 	 := If(aPARAM177[33] == 1, "SB1->B1_PRV1","SB2->B2_CM1")
Else
	cPreco   := "SB1->B1_PRV1"  
EndIf  

//--Totaliza as Necessidades de cada produto
aTotNec := A177TotNec(, aItens, cAliasTrb, aNecAlt)


//--Refaz o cálculo das quantidades proporcionais para todos os produtos
A177CalcProp( @aQtdProp, aNecAlt, cAliasTrb, aTotNec, aItens )
	

//--Modifica a filial corrente para a filial centralizadora informada
cFilAnt := aPARAM177[21]

ProcRegua( nTotReg )
(cAliasTrb)->( dbGoTop() )   

Begin Transaction
Do While !(cAliasTrb)->( Eof() ) .And. !lEnd
	aCbPV := {}
	aItPV := {}
	If cQuebra <> (cAliasTrb)->( FILNEC + CODPRO ) .Or. (nQtdItens <= nTotItens)

		//--Obtem o Cliente...                       
		aDadCli := A177GetCli( (cAliasTrb)->FILNEC )             
		If Len( aDadCli ) == 3
			//--Cabecalho do Pedido de Vendas
			aAdd( aCbPV, {'C5_TIPO'		, 'N'		, NIL})
			aAdd( aCbPV, {'C5_CLIENTE'	, aDadCli[1], NIL})
			aAdd( aCbPV, {'C5_LOJACLI'	, aDadCli[2], NIL})
			aAdd( aCbPV, {'C5_CONDPAG'	, aDadCli[3], NIL})
			
			cQuebra   := (cAliasTrb)->FILNEC
			cItemPV   := StrZero( 0, Len(SC6->C6_ITEM) )
			lCabec    := .T.                                
			nTotItens := 1
		Else
			//--Cliente inconsistente
			(cAliasTrb)->( DbSkip() )
			lCabec  := .F.
			cQuebra := ''
		EndIf
	EndIf
	
	//--Itens do Pedido
	Do While lCabec .And. !(cAliasTrb)->( Eof() ) .And. cQuebra == (cAliasTrb)->FILNEC .And. (nQtdItens >= nTotItens)
		nPosNec := AScan( aTotNec, {|x| x[1] == (cAliasTrb)->CODPRO} )
		If nPosNec > 0
			nTotNec := aTotNec[nPosNec,2]
			
			//--Localiza o Produto e sua quantidade proporcional:
			nPosProp := AScan( aQtdProp, {|x| x[1] + x[2] == (cAliasTrb)->(FILNEC + CODPRO)} )
			If nPosProp == 0
				nQtdNec := 0
			Else
				nQtdNec := aQtdProp[nPosProp,4]
			EndIf
	
			If nQtdNec > 0
				//--Posicionar no produto...
				SB1->( DbSetOrder(1) )
				SB1->( DbSeek( FWxFilial('SB1') + (cAliasTrb)->CODPRO ) )
				
				cItemPV := Soma1( cItemPV ) 
				
		   		// Ponto de entrada para a Troca da TES de Saida.
		      	If FindFunction('U_MTA177TES')
		      		xRet := U_MTA177TES("S",(cAliasTrb)->CODPRO, (cAliasTrb)->FILNEC )
 				    If ValType(xRet) == "C" 
 		    	    	cTES := xRet
 			  	    Else 
 		    	    	cTES := RetFldProd((cAliasTrb)->CODPRO, 'B1_TS')	
 			   	    EndIf
 		     	Else
 			   		cTES := RetFldProd((cAliasTrb)->CODPRO, 'B1_TS')	    
		      	EndIf       
				      	
				AAdd( aItPV, {	{ 'C6_ITEM'		, cItemPV									, NIL },;
								{ 'C6_PRODUTO'	, (cAliasTrb)->CODPRO						, NIL },;
								{ 'C6_QTDVEN'	, nQtdNec									, NIL },;
								{ 'C6_QTDLIB'	, nQtdNec									, NIL },;
								{ 'C6_PRCVEN'	, Round(&(cPreco),nDecimais)				, NIL },;
								{ 'C6_PRUNIT'	, Round(&(cPreco),nDecimais)				, NIL },;
								{ 'C6_TES'		, cTES										, NIL } } )
			  	nTotItens++	
			EndIf
		EndIf
		IncProc()
		(cAliasTrb)->( DbSkip() )
	EndDo  
	
	//--Realiza a Geracao do Pedido de Venda
	If Len( aCbPV ) > 0 .And. Len( aItPV ) > 0 
		lMsErroAuto := .F.
		MSExecAuto( {|x,y,z| MATA410(x, y, z) }, aCbPV, aItPV, 3 )  
		If lMsErroAuto
			cTxtLog := NomeAutoLog()
			If ValType( cTxtLog ) == 'C'
				AAdd( aMsgErr, Memoread( cTxtLog ) )
			EndIf 
			DisarmTransaction() 
			Exit
		Else
			nProc++ //--Incrementa o contador somente se nao houver erro
			
			//--Verifica a geracao dos documentos de previsao de
			//--entrada na filial da necessidade
			If aPARAM177[03] == 1
				If aPARAM177[04] == 1
				//--Geracao de SC's
					AAdd( aSolic, Array(2) )
					ATail(aSolic)[1] := {}
					ATail(aSolic)[2] := {}
					//--Cabecalho da SC
					AAdd( ATail(aSolic)[1], {'C1_SOLICIT'	, CriaVar( 'C1_SOLICIT', .T. )	, Nil} )
					AAdd( ATail(aSolic)[1], {'C1_EMISSAO'	, dDataBase						, NIL} )
					AAdd( ATail(aSolic)[1], {'C1_FILENT'	, cQuebra						, NIL} )
					For nCount := 1 To Len( aItPV )
						cItemSC := StrZero( Len(aTail(aSolic)[2] ) + 1, Len( SC1->C1_ITEM ) )
						AAdd( ATail(aSolic)[2], {	{ 'C1_ITEM'   , cItemSC				, NIL } ,;
													{ 'C1_PRODUTO', aItPV[nCount,2,2]	, NIL } ,;
													{ 'C1_QUANT'  , aItPV[nCount,3,2]	, NIL } } )
					Next
				Else
					//--Geracao de PC's
					//--Aglutina os Produtos para geracao dos Pedidos de Compra
					For nCount := 1 To Len( aItPV )
						nPosItem := AScan( aProdPC, {|x| x[1]+x[2] == cQuebra + aItPV[nCount,2,2]} )
						If nPosItem == 0      
						    aDadFor  := A177GetFor( cQuebra,NIL, aItPV[nCount,2,2],NIL,NIL,.T. )   
							If Len( aDadFor ) == 3
								AAdd( aProdPC, {cQuebra,;           //--[01]Filial da Necessidade
												aItPV[nCount,2,2],; //--[02]Cod. Produto
												aItPV[nCount,3,2],; //--[03]Qtd.												
												aDadFor[1],;        //--[04]Cod. Fornecedor
												aDadFor[2],;        //--[05]Loja Fornecedor
												aDadFor[3],;        //--[06]Condicao de Pagto. padrao
												SC5->(Recno())})    //--[07] Numero Registro do Cabeçalho do PV
							EndIf
						Else
							aProdPC[nPosItem,3] += aItPV[nCount,3,2]
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	EndIf
EndDo

//--Trata o Log de Operacoes da Rotina
If aPARAM177[30]
	A177Log( STR0182 + AllTrim( Str( nProc ) ) + STR0180 ) //--"Geracao dos Pedidos de Venda concluida. Gerados "#" Pedidos"
EndIf

//--Verifica a geracao dos documentos de previsao de
//--entrada na filial da necessidade
If aPARAM177[03] == 1 .AND. !lMsErroAuto
	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0183 ) //--"Inicio da geracao dos Documentos de Previsao de Entrada"
		nProc := 0
	EndIf

	If aPARAM177[04] == 1 .And. Len( aSolic ) > 0  
		//--Geracao de SC's
		ProcRegua( Len(aSolic) )
		For nCount := 1 To Len( aSolic )
			aCbSC       := aSolic[nCount, 1]
			aItSC       := aSolic[nCount, 2]
			lMsErroAuto := .F.
			MSExecAuto( {|v,x,y,z| MATA110(v, x, y, z)}, aCbSC, aItSC, 3, .F. )
			If lMsErroAuto
				cTxtLog := NomeAutoLog()
				If ValType( cTxtLog ) == 'C'
					AAdd( aMsgErr, Memoread( cTxtLog ) )
				EndIf
			    Disarmtransaction()
			    Exit
			Else
				nProc++ //--Incrementa o contador somente se nao houver erro
			EndIf
			IncProc()
		Next
	ElseIf aPARAM177[04] == 2 .And. Len( aProdPC ) > 0  
		//--Geracao de PC's
		ProcRegua( Len(aProdPC) )
		cQuebra := ''
		nCount  := 1
		nRecPV  := 0
		ASort( aProdPC,,,{|x,y| x[1]+x[4]+x[5]+x[2] < y[1]+y[4]+y[5]+y[2]} )
		Do While nCount <= Len( aProdPC )
			aCbPC := {}
			aItPC := {}
			//--Cabecalho
			If cQuebra <> aProdPC[nCount,1] + aProdPC[nCount,4] + aProdPC[nCount,5]               
				aAdd(aCbPC, {'C7_NUM'		, Criavar('C7_NUM',.T.)		, Nil})	//--Numero do Pedido
				aAdd(aCbPC, {'C7_EMISSAO'	, dDataBase					, Nil})	//--Data de Emissao
				aAdd(aCbPC, {'C7_FORNECE'	, aProdPC[nCount,4]			, Nil})	//--Fornecedor
				aAdd(aCbPC, {'C7_LOJA'		, aProdPC[nCount,5]			, Nil})	//--Loja do Fornecedor
				aAdd(aCbPC, {'C7_CONTATO'	, CriaVar('C7_CONTATO',.F.)	, Nil})	//--Contato
				aAdd(aCbPC, {'C7_COND'		, aProdPC[nCount,6]			, Nil})	//--Condicao de Pagamento
				aAdd(aCbPC, {'C7_FILENT'	, aProdPC[nCount,1]			, Nil})	//--Filial de Entrega			
		
				cQuebra := aProdPC[nCount,1] + aProdPC[nCount,4] + aProdPC[nCount,5]
				cItemPC := Replicate( '0', Len( SC7->C7_ITEM ) )
				
				//-- Atualiza a cFilAnt para a Filial de Necessidade 
				//-- Para gerar o Pedido de Compra na Filial de Necessidade quando o processo for Distribuição e Tipo de Tratamento = Com Aglutinação
				If aPARAM177[34] == 2
					cFilAnt := aProdPC[nCount,1]
				EndIf
				
				//-- Posiciona o Registro referente ao Pedido de Venda Gerado 
				//-- para que seja possível vincular a SC6 X SC7
				If aProdPC[nCount,7]>0
					SC5->(MsGoto(aProdPC[nCount,7]))
				EndIf
			EndIf	
			//--Itens
			Do While nCount <= Len( aProdPC ) .And. cQuebra == aProdPC[nCount,1] + aProdPC[nCount,4] + aProdPC[nCount,5]
				//--Posicionar no produto...
				cFilSB1  := If( a177MdAccess("SB1"), FWxFilial('SB1'), aCbPC[7,2] )
				SB1->( DbSetOrder(1) )
				If SB1->( DbSeek( cFilSB1 + aProdPC[nCount,2] ) )
					nPosItem := AScan( aItPC, {|x| x[2,2] == aProdPC[nCount,2]} )
					If nPosItem == 0
						If aPARAM177[17] == 1
							nPrUnit := RetFldProd(aProdPC[nCount,2], 'B1_UPRC')
						ElseIf aPARAM177[17] == 2
							//-- Obtem o preco unitario atraves da tabela informada e para o fornecedor do pedido de compra
							cFilAIB := If( a177MdAccess("AIB"), FWxFilial('AIB'), aProdPC[nCount,1] ) 
							nPrUnit := GetAdvFval( 'AIB','AIB_PRCCOM', cFilAIB + aProdPC[nCount,4] + aProdPC[nCount,5] + aPARAM177[18] + aProdPC[nCount,2], 2 )
						Else
							nPrUnit := RetFldProd(aProdPC[nCount,2], 'B1_CUSTD')
						EndIf
						
						cItemPC := Soma1( cItemPC )
						
						// Ponto de entrada para a Troca da TES de Entrada
				      	If FindFunction('U_MTA177TES')
				      		xRet := U_MTA177TES("E"     , aProdPC[nCount,2] , aProdPC[nCount,1] )
				      	                       //Entrada,  Cod Produto       , Filial de necessidade
		 				    If ValType(xRet) == "C" 
		 		    	    	cTES := xRet
		 			  	    Else 
		 		    	    	cTES := RetFldProd(aProdPC[nCount,2], 'B1_TE')
		 			   	    EndIf
		 		     	Else
		 			   		cTES := RetFldProd(aProdPC[nCount,2], 'B1_TE')   
				      	EndIf     
								
						AAdd(aItPC, {	{ 'C7_ITEM'		, cItemPC														 , NIL },;
										{ 'C7_PRODUTO'	, aProdPC[nCount,2]												 , NIL },;
										{ 'C7_CODTAB' 	, Iif(aPARAM177[17] = 2, aPARAM177[18], Criavar('C7_CODTAB',.F.)), NIL },;
										{ 'C7_QUANT'	, aProdPC[nCount,3]												 , NIL },;
										{ 'C7_PRECO'	, nPrUnit														 , NIL },;
										{ 'C7_TES'		, cTES															 , NIL },;
										{ 'C7_FILCEN'	, aParam177[21]													 , Nil },;
										{ 'C7_TPOP'		, 'F'															 , NIL } } )
										
					Else
						aItPC[nPosItem,3,2] += aProdPC[nCount,3]
	   				EndIf
				EndIf
				nCount++
				IncProc()
			EndDo

			If Len( aCbPC ) > 0 .And. Len( aItPC ) > 0
				lMsErroAuto := .F.
				MSExecAuto( {|v,x,y,z,w| MATA120(v,x,y,z,w)}, 1, aCbPC, aItPC, 3, .F. )
				If lMsErroAuto
					cTxtLog := NomeAutoLog()
					If ValType( cTxtLog ) == 'C'
						AAdd( aMsgErr, Memoread( cTxtLog ) )
					EndIf 
					Disarmtransaction()
					Exit
				Else
					nProc++ //--Incrementa o contador somente se nao houver erro
				EndIf
			EndIf	
		EndDo
	EndIf
	//--Trata o Log de Operacoes da Rotina
	If aPARAM177[30]
		A177Log( STR0184 + AllTrim( Str( nProc ) ) + STR0177 ) //--"Geracao dos Documentos de Previsao de Entrada concluida. Gerados "#" Documentos"
	EndIf
EndIf
End Transaction

If Len( aMsgErr ) > 0
	For nCount := 1 To Len( aMsgErr )
		AutoGrLog( aMsgErr[nCount] )
	Next
	AutoGrLog('')
	MostraErro()
EndIf

A177UnLockGr(@aSelGrupos) //Destrava os Grupos usados
RestArea( aAreaSB1 )
RestArea( aAreaAIB )
cFilAnt := cFilAntBkp
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177BuildBrw³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Prepara o Browse para edicao das Necessidades quando os    ³±±
±±³          ³resultados nao sao apresentados em tela                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177BuildBrw( aCabec, aItens, oBrwNec, cCodPro, aNecAlt, cAliasTrb, oBtnCancNec )
Local aTotNec    := {}
Local nQtdNec    := 0
Local nPosNecAlt := 0
Local nNecAlt    := 0
Local nCount     := 0
Local nPropAcum  := 0
Local nQtdProp   := 0

//--Ponto de entrada para manipular a Qtd. da Necessidade
Local lMTA177Nec := ExistBlock('MTA177Nec')
Local nMTA177Nec := 0

//--Processamento...
aItens := {}
(cAliasTrb)->( DbGoTop() )
Do While !(cAliasTrb)->( Eof() )
	If ((!Empty( cCodPro )) .And. ((cAliasTrb)->CODPRO == cCodPro)) .OR. (Empty( cCodPro ))
		//--Calculo da Necessidade
		If aPARAM177[06] == 1 .Or. aPARAM177[06] == 2
			nQtdNec := (cAliasTrb)->QTDNEC
		Else
			nQtdNec := A177CalcNec( (cAliasTrb)->FILNEC, (cAliasTrb)->CODPRO, (cAliasTrb)->SLDFILNEC )
		EndIf				
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³P. E. PARA MODIFICAR A QTDE. DA NECESSIDADE³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMTA177Nec
			 nMTA177Nec := ExecBlock('MTA177Nec', .F., .F.,;
										{ (cAliasTrb)->CODPRO,;    //--[01]Codigo do Produto
										  aPARAM177[20],;          //--[02]Processamento por Filial (1) ou Centralizado (2)
										  (cAliasTrb)->FILNEC,;    //--[03]Filial Necessidade
										  aPARAM177[21],;          //--[04]Filial Centralizadora
										  nQtdNec,;                //--[05]Necessidade Obtida
										  (cAliasTrb)->MEDVENDAS,; //--[06]Media de Vendas do periodo
										  (cAliasTrb)->EMAX,;      //--[07]Estoque Maximo do Produto na filial da necessidade
										  (cAliasTrb)->SLDFILNEC,; //--[08]Saldo atual na filial da necessidade
										  (cAliasTrb)->SLDFILCEN,; //--[09]Saldo atual na filial Centralizadora
										  aPARAM177[19],;          //--[10]Filiais selecionadas
										  aPARAM177[27],;          //--[11]Tipos selecionados
										  aPARAM177[26],;          //--[12]Grupos selecionados
										  aPARAM177[25],;          //--[13]Categorias selecionadas
										  aPARAM177[28],;          //--[14]Filtro especifico do usuario
										  aPARAM177[29] })         //--[15]Ordem selecionada pelo usuario
	
			If ValType( nMTA177Nec ) == 'N'
				nQtdNec := nMTA177Nec
			EndIf				
		EndIf
	
		nPosNecAlt := AScan( aNecAlt, {|x| x[1] + x[2] == (cAliasTrb)->( FILNEC + CODPRO )} )
		nNecAlt    := If( nPosNecAlt <> 0, aNecAlt[nPosNecAlt, 3], nQtdNec )
	
		If ( aPARAM177[23] .And. nQtdNec > 0 ) .Or. ( !aPARAM177[23] .And. nQtdNec >= 0 )
			If aPARAM177[01] == 1
				AAdd( aItens, {	(cAliasTrb)->FILNEC,; 				//--[01]FILIAL DA NECESSIDADE
								aPARAM177[21],;						//--[02]FILIAL CENTRALIZADORA
								(cAliasTrb)->CODPRO,;				//--[03]CODIGO DO PRODUTO
								(cAliasTrb)->DESPRO,;				//--[04]DESCRICAO
								(cAliasTrb)->GRUPO,;				//--[05]GRUPO
								(cAliasTrb)->TIPO,;					//--[06]TIPO
								nQtdNec,;							//--[07]QTD. DA NECESSIDADE (CALCULO)
								nNecAlt,;							//--[08]QTD. DA NECESSIDADE (INFORMADA)
								(cAliasTrb)->SLDFILNEC,;			//--[09]SALDO DO PRODUTO x FILIAL NECESSIDADE
								(cAliasTrb)->MEDVENDAS,;			//--[10]MEDIA DE VENDAS DO PERIODO
								(cAliasTrb)->EMAX,;					//--[11]ESTOQUE MAXIMO DO PRODUTO
								(cAliasTrb)->SLDFILCEN} )			//--[12]SALDO DO PRODUTO x FILIAL CENTRALIZADORA
			ElseIf aPARAM177[01] == 2
				AAdd( aItens, {	(cAliasTrb)->FILNEC,;				//--[01]FILIAL DA NECESSIDADE
								aPARAM177[21],;						//--[02]FILIAL CENTRALIZADORA
								(cAliasTrb)->CODPRO,;				//--[03]CODIGO DO PRODUTO
								(cAliasTrb)->DESPRO,;				//--[04]DESCRICAO
								(cAliasTrb)->GRUPO,;				//--[05]GRUPO
								(cAliasTrb)->TIPO,;					//--[06]TIPO
								nQtdNec,;							//--[07]QTD. DA NECESSIDADE (CALCULO)
								nNecAlt,;							//--[08]QTD. DA NECESSIDADE (INFORMADA)
								0,;									//--[09]QTD. PROPORCIONAL
								(cAliasTrb)->SLDFILNEC,;			//--[10]SALDO DO PRODUTO x FILIAL NECESSIDADE
								(cAliasTrb)->MEDVENDAS,;			//--[11]MEDIA DE VENDAS DO PERIODO
								(cAliasTrb)->EMAX,;					//--[12]ESTOQUE MAXIMO DO PRODUTO
								(cAliasTrb)->SLDFILCEN} )			//--[13]SALDO DO PRODUTO x FILIAL CENTRALIZADORA
			EndIf
		EndIf
	EndIf
 	(cAliasTrb)->(DbSkip())
EndDo

//--Realiza a Proporcao das Qtdes, caso seja o calculo de distribuicao
If Len( aItens ) > 0	
	If aPARAM177[01] == 2
		//--Totaliza as necessidades para calculo da proporcao
		aTotNec := A177TotNec( cCodPro, aItens, cAliasTrb, aNecAlt )

		//--Ordena o Array por Produto + Qtd. de Necessidade + Filial Necessidade
		ASort(aItens,,,{|x,y| x[3] + Str( x[7], TamSX3('B2_QATU')[1],;
					TamSX3('B2_QATU')[2] ) + x[1] >  y[3] + Str( y[7],;
					TamSX3('B2_QATU')[1], TamSX3('B2_QATU')[2] ) + x[1] } )

		//--Realiza o calculo de proporcao
		//--Se a necessidade for maior que o saldo da filial centralizadora, aplica
		//--a regra de proporcao: (Necessidade / Total das Necessidades) * Saldo Filial Centralizadora
		For nCount := 1 To Len( aItens )
			If cCodPro <> aItens[nCount,3]
				nPropAcum := 0
				cCodPro := aItens[nCount,3]
				nCount -= 1
			Else
				If (nPosTotNec := AScan( aTotNec, {|x| x[1] == cCodPro} )) > 0
					If aTotNec[nPosTotNec,2] > aItens[nCount,13]
						nQtdProp := Round( (aItens[nCount,8] / aTotNec[nPosTotNec, 2]) * aItens[nCount,13], TamSX3('B2_QATU')[2] )
						If nPropAcum + nQtdProp <= aItens[nCount,13]
							aItens[nCount,9] := nQtdProp
							nPropAcum += aItens[nCount,9]						
						EndIf
					Else
						aItens[nCount,9] := aItens[nCount,8]
					EndIf
				EndIf
			Endif
		Next
	EndIf
Else
	Help( ' ', 1, 'MATA17701',, IIf(!Empty(cCodPro), STR0050 + cCodPro, ''), 4, 11 )
	aItens := Array( 1, Len(aCabec) )
	oBtnCancNec:Click()
EndIf

(cAliasTrb)->( DbGoTop() )

//--Atualiza o Browse com as informacoes das Necessidades...
oBrwNec:SetArray( aItens )
If aPARAM177[01] == 01
	oBrwNec:bLine := {|| {	aItens[ oBrwNec:nAT, 01 ], aItens[ oBrwNec:nAT, 02 ], aItens[ oBrwNec:nAT, 03 ],;
							aItens[ oBrwNec:nAT, 04 ], aItens[ oBrwNec:nAT, 05 ], aItens[ oBrwNec:nAT, 06 ],;
							aItens[ oBrwNec:nAT, 07 ], aItens[ oBrwNec:nAT, 08 ], aItens[ oBrwNec:nAT, 09 ],;
							aItens[ oBrwNec:nAT, 10 ], aItens[ oBrwNec:nAT, 11 ], aItens[ oBrwNec:nAT, 12 ] } }
Else
	oBrwNec:bLine := {|| {	aItens[ oBrwNec:nAT, 01 ], aItens[ oBrwNec:nAT, 02 ], aItens[ oBrwNec:nAT, 03 ],;
							aItens[ oBrwNec:nAT, 04 ], aItens[ oBrwNec:nAT, 05 ], aItens[ oBrwNec:nAT, 06 ],;
							aItens[ oBrwNec:nAT, 07 ], aItens[ oBrwNec:nAT, 08 ], aItens[ oBrwNec:nAT, 09 ],;
							aItens[ oBrwNec:nAT, 10 ], aItens[ oBrwNec:nAT, 11 ], aItens[ oBrwNec:nAT, 12 ],;
							aItens[ oBrwNec:nAT, 13 ] } }
EndIf
oBrwNec:Refresh()
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177VerRecal³ Autor ³Emerson Rony Oliveira ³ Data ³ 07.Ago.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica se existe necessidade de recalcular as quantidades  ³±±
±±³          ³proporcionais e pede confirmacao do usuario                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177VerRecal( aNecAlt )
Local lRet := .F.
lRet := (Len( aNecAlt ) > 0) .And. (MsgYesNo( STR0203 + STR0204 + Chr(13) + Chr(13) + STR0202 ))
Return (lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177ReCalPro³ Autor ³Emerson Rony Oliveira ³ Data ³ 07.Ago.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Realiza o recalculo da quantidade proporcional para os itens ³±±
±±³          ³editados. Atualiza as informacoes no browse.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177ReCalPro( aItens, oBrwNec, aNecAlt, cAliasTrb )
Local aTotNec    := {}
Local cCodPro    := ''
Local nCount     := 0
Local nPropAcum  := 0
Local nPosTotNec := 0

//--Rotina executada apenas quando for processo de "Distribuicao"
If aPARAM177[01] == 2
	//--Totaliza as necessidades para calculo da proporcao
	aTotNec := A177TotNec(, aItens, cAliasTrb, aNecAlt )

	//--Ordena o Array por Produto + Qtd. de Necessidade + Filial Necessidade
	ASort(aItens,,,{|x,y| x[3] + Str( x[7], TamSX3('B2_QATU')[1],;
				TamSX3('B2_QATU')[2] ) + x[1] >  y[3] + Str( y[7],;
				TamSX3('B2_QATU')[1], TamSX3('B2_QATU')[2] ) + x[1] } )

	//--Realiza o calculo de proporcao
	//--Se a necessidade for maior que o saldo da filial centralizadora, aplica
	//--a regra de proporcao: (Necessidade / Total das Necessidades) * Saldo Filial Centralizadora
	For nCount := 1 To Len( aItens )
		If cCodPro <> aItens[nCount,3]
			nPropAcum := 0
			cCodPro := aItens[nCount,3]
			nCount -= 1
		Else
			If (nPosTotNec := AScan( aTotNec, {|x| x[1] == cCodPro} )) > 0
				If aTotNec[nPosTotNec,2] > aItens[nCount,13]
					nQtdProp := Round( (aItens[nCount,8] / aTotNec[nPosTotNec, 2]) * aItens[nCount,13], TamSX3('B2_QATU')[2] )
					If nPropAcum + nQtdProp <= aItens[nCount,13]
						aItens[nCount,9] := nQtdProp
						nPropAcum += aItens[nCount,9]						
					EndIf
				Else
					aItens[nCount,9] := aItens[nCount,8]
				EndIf
			EndIf
		Endif
	Next

	//--Ajusta o Array conforme a ordem selecionada pelo usuario:
	If aPARAM177[29] == 0 .Or. aPARAM177[29] == 1 //--Produto
		ASort( aItens,,,{|x,y| x[3] < y[3]} )	
	ElseIf aPARAM177[29] == 2 //--Descricao
		ASort( aItens,,,{|x,y| x[4] < y[4]} )
	ElseIf aPARAM177[29] == 3 //--Grupo + Produto
		ASort( aItens,,,{|x,y| x[5] + x[3] < y[5] + y[3]} )
	ElseIf aPARAM177[29] == 4 //--Tipo + Produto
		ASort( aItens,,,{|x,y| x[6] + x[3] < y[6] + y[3]} )
	ElseIf aPARAM177[29] == 5 //--Filial Necess. + Produto
		ASort( aItens,,,{|x,y| x[1] + x[3] < y[1] + y[3]} )
	ElseIf aPARAM177[29] == 6 //--Filial Necess. + Descr.
		ASort( aItens,,,{|x,y| x[1] + x[4] < y[1] + y[4]} )
	ElseIf aPARAM177[29] == 7 //--Filial Necess. + Grupo + Produto
		ASort( aItens,,,{|x,y| x[1] + x[5] + x[3] < y[1] + y[5] + y[3]} )
	ElseIf aPARAM177[29] == 8 //--Filial Necess. + Tipo + Produto
		ASort( aItens,,,{|x,y| x[1] + x[6] + x[3] < y[1] + y[6] + y[3]} )
	ElseIf aPARAM177[29] == 9  //--"Descr. Produto + Filial da Necess." 
            ASort( aItens,,,{|x,y| x[4] + x[1] < y[4] + y[1]} )	
	EndIf
	
	//--Atualiza o Browse com as informacoes das Necessidades...
	oBrwNec:SetArray( aItens )
	oBrwNec:bLine := {|| {	aItens[ oBrwNec:nAT, 01 ], aItens[ oBrwNec:nAT, 02 ], aItens[ oBrwNec:nAT, 03 ],;
							aItens[ oBrwNec:nAT, 04 ], aItens[ oBrwNec:nAT, 05 ], aItens[ oBrwNec:nAT, 06 ],;
							aItens[ oBrwNec:nAT, 07 ], aItens[ oBrwNec:nAT, 08 ], aItens[ oBrwNec:nAT, 09 ],;
							aItens[ oBrwNec:nAT, 10 ], aItens[ oBrwNec:nAT, 11 ], aItens[ oBrwNec:nAT, 12 ],;
							aItens[ oBrwNec:nAT, 13 ] } }
	oBrwNec:Refresh()

EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177TotNec ³ Autor ³VITOR RASPA           ³ Data ³ 27.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Totaliza as Necessidades por produto                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177TotNec( cCodPro, aItens, cAliasTrb, aNecAlt)
Local aRet         := {}
Local cQuery       := ''
Local nQtdNec      := 0
Local nTotNec      := 0
Local nPosNec      := 0
Local nPosAlt      := 0
Local nCount       := 0  
Local nQuantItns   := 0      //verifica se no array se existe quantida de alterada

Default aItens     := {}
Default cCodPro    := ''

If aPARAM177[06] == 1 .Or. aPARAM177[06] == 2
	//--Preenche o vetor aTotNec com o total das necessidades de cada produto
	(cAliasTrb)->(dbGoTop())	
	Do While !(cAliasTrb)->( Eof() )  
    	nPosAlt    := AScan( aNecAlt, {|x| x[1] + x[2] == (cAliasTrb)->(FILNEC + CODPRO) } )
    	nQuantItns := If(nPosAlt > 0 , aNecAlt[nPosAlt,3], 0)
		If ( ( !Empty( cCodPro ) .And. (cAliasTrb)->CODPRO == cCodPro ) .OR. Empty( cCodPro ) ) .And. ( (cAliasTrb)->QTDNEC > 0 .OR. nQuantItns > 0 )
			//--Verifica se a necessidade foi alterada		  
			If nPosAlt <> 0
				nQtdNec := aNecAlt[nPosAlt,3]
			Else
				nQtdNec := (cAliasTrb)->QTDNEC
			EndIf
			
			nPosNec := AScan( aRet, {|x| x[1] == (cAliasTrb)->CODPRO} )
			If nPosNec == 0
				aAdd( aRet, {(cAliasTrb)->CODPRO, nQtdNec} )
			Else
				aRet[nPosNec, 2] += nQtdNec
			EndIf
		EndIf
		(cAliasTrb)->( dbSkip() )		
	EndDo	
Else
	(cAliasTrb)->( DbGoTop() )
	Do While !(cAliasTrb)->( Eof() )
		If (!Empty( cCodPro ) .And. (cAliasTrb)->CODPRO == cCodPro) .OR. Empty( cCodPro )
			//--Verifica se a necessidade foi alterada
			nPosAlt := AScan( aNecAlt, {|x| x[1] + x[2] == (cAliasTrb)->(FILNEC + CODPRO) } )
			If nPosAlt <> 0
				nQtdNec := aNecAlt[nPosAlt,3]
			Else
				If aPARAM177[22]
					//--Caso os dados tenham sido exibidos em tela,
					//--nao realiza novamente o calculo das necessidades...
					nPosNec := AScan( aItens, {|x| x[1] + x[3] == (cAliasTrb)->( FILNEC + CODPRO )} )
					nQtdNec := If( nPosNec <> 0, aItens[nPosNec,7], 0 )
				Else
					nQtdNec := A177CalcNec( (cAliasTrb)->FILNEC, (cAliasTrb)->CODPRO, (cAliasTrb)->SLDFILNEC )
				EndIf
			EndIf
			
			nPosNec := AScan( aRet, {|x| x[1] == (cAliasTrb)->CODPRO} )
			If nPosNec == 0
				AAdd( aRet, {(cAliasTrb)->CODPRO, IIf(nQtdNec < 0, 0, nQtdNec)  } )
			Else
				aRet[nPosNec,2] += IIf(nQtdNec < 0, 0, nQtdNec)
			EndIf
		EndIf
		(cAliasTrb)->( DbSkip() )
	EndDo
EndIf
  
(cAliasTrb)->(dbGoTop())

Return( aRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177CalcProp ³ Autor ³Vitor Raspa         ³ Data ³ 11.Jun.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Calcula a Qtd. Proporcional para geracao do Pedido de Venda ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177CalcProp( aQtdProp, aNecAlt, cAliasTrb, aTotNec, aItens )
Local cCodPro    := ''
Local nCount     := 0
Local nPosNec    := 0
Local nQtdNec    := 0
Local nPosTotNec := 0
Local nQtdProp   := 0
Local nPropAcum  := 0
Local nTotNec    := 0

//--Ponto de entrada para manipular a Qtd. da Necessidade
Local lMTA177Nec := ExistBlock('MTA177Nec')
Local nMTA177Nec := 0  

Local nContProd     := 0  // Controla a troca de produtos 
Local nQuntProd     := 0  // Controla a quantidades de produto     
Local nI            := 0   
Local aTamB2_QATU   := TamSX3('B2_QATU')  

//--Localiza a quantidade Total para o produto

(cAliasTrb)->( dbGoTop() )
Do While !(cAliasTrb)->( Eof() )
	//--Obtem a Necessidade Total do Produto
	nPosNec := AScan( aTotNec, { |x| x[1] == (cAliasTrb)->CODPRO } )
	If nPosNec > 0
		nTotNec := aTotNec[nPosNec,2]
	
		//--Verifica se a necessidade foi alterada
		nPosNec := AScan( aNecAlt, { |x| x[1] + x[2] == (cAliasTrb)->(FILNEC + CODPRO) } )
		If nPosNec <> 0
			nQtdNec := aNecAlt[nPosNec,3]
		Else
			If aPARAM177[22]
				//--Caso os dados tenham sido exibidos em tela,
				//--nao realiza novamente o calculo das necessidades...
				nPosNec := AScan( aItens, {|x| x[1] + x[3] == (cAliasTrb)->( FILNEC + CODPRO )} )
				nQtdNec := If( nPosNec <> 0, aItens[nPosNec,7], 0 )
			Else
				If aPARAM177[06] == 1 .Or. aPARAM177[06] == 2
					nQtdNec := (cAliasTrb)->QTDNEC
				Else
					nQtdNec := A177CalcNec( (cAliasTrb)->FILNEC, (cAliasTrb)->CODPRO, (cAliasTrb)->SLDFILNEC )
				EndIf
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³P. E. PARA MODIFICAR A QTDE. DA NECESSIDADE³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lMTA177Nec
					nMTA177Nec := ExecBlock('MTA177Nec', .F., .F.,;
												{ (cAliasTrb)->CODPRO,;		//--[01]Codigo do Produto
												  aPARAM177[20],;			//--[02]Processamento por Filial (1) ou Centralizado (2)
												  (cAliasTrb)->FILNEC,;		//--[03]Filial Necessidade
												  aPARAM177[21],;			//--[04]Filial Centralizadora
												  nQtdNec,;					//--[05]Necessidade Obtida
												  (cAliasTrb)->MEDVENDAS,;	//--[06]Media de Vendas do periodo
												  (cAliasTrb)->EMAX,;		//--[07]Estoque Maximo do Produto na filial da necessidade
												  (cAliasTrb)->SLDFILNEC,;	//--[08]Saldo atual na filial da necessidade
												  (cAliasTrb)->SLDFILCEN,;	//--[09]Saldo atual na filial Centralizadora
												  aPARAM177[19],;			//--[10]Filiais selecionadas
												  aPARAM177[27],;			//--[11]Tipos selecionados
												  aPARAM177[26],;			//--[12]Grupos selecionados
												  aPARAM177[25],;			//--[13]Categorias selecionadas
												  aPARAM177[28],;			//--[14]Filtro especifico do usuario
												  aPARAM177[29] })			//--[15]Ordem selecionada pelo usuario
					If ValType( nMTA177Nec ) == 'N'
						nQtdNec := nMTA177Nec
					EndIf
				EndIf
			EndIf
		EndIf
		//--Alimenta array com as necessidades obtidas para posterior
		//--calculo da proporcao
		If nQtdNec > 0
			AAdd( aQtdProp, {	(cAliasTrb)->FILNEC,;		//--Filial Necessidade
								(cAliasTrb)->CODPRO,;		//--Produto
								nQtdNec,;					//--Qtd. Necessidade
								0,;							//--Qtd. Proporcional a ser calculada abaixo
								(cAliasTrb)->SLDFILCEN } )	//--Saldo na filial Centralizadora
		EndIf
	EndIf
	(cAliasTrb)->( dbSkip() )
EndDo

//--Realiza o calculo de proporcao
//--Regra de proporcao: (Necessidade / Total das Necessidades) * Saldo Filial Centralizadora
If lTPLDRO
	//--Ordena o Array por Produto + Qtd. de Necessidade + Filial Necessidade
	ASort(aQtdProp,,,{|x,y| x[2] + Str( x[3], aTamB2_QATU[1],;
	aTamB2_QATU[2] ) + x[1] <  y[2] + Str( y[3],;
	aTamB2_QATU[1], aTamB2_QATU[2] ) + y[1] } ) 		   
EndIf		   

For nCount := 1 To Len( aQtdProp )
	If cCodPro <> aQtdProp[nCount,2]
		nPropAcum := 0 
		cCodPro := aQtdProp[nCount,2]
		nContProd := 0
		nQuntProd := 0
		nI := nCount     
		If nI<=Len(aItens)
			While cCodPro == aItens[nI ,3] 
				nQuntProd += 1
	   			nI += 1	                          
				If nI > Len(aItens) 
					Exit 
				EndIf						
			End  		   			
		EndIf
		nCount -= 1			
	Else
		If lTPLDRO
        	aQtdProp := T_DroQProp(aQtdProp,aTotNec,@nPropAcum, cCodPro, nCount,@nContProd,@nQuntProd,2)
        Else
			If (nPosTotNec := AScan( aTotNec, {|x| x[1] == cCodPro} )) > 0
				If aTotNec[nPosTotNec,2] > aQtdProp[nCount,5]
					nQtdProp := Round( (aQtdProp[nCount,3] / aTotNec[nPosTotNec, 2]) * aQtdProp[nCount,5], TamSX3('B2_QATU')[2] )
					If nPropAcum + nQtdProp <= aQtdProp[nCount,5]
						aQtdProp[nCount,4] := nQtdProp
						nPropAcum += aQtdProp[nCount,4]
					EndIf
				Else
					aQtdProp[nCount,4] := aQtdProp[nCount,3]
				EndIf
			EndIf
		EndIf
	Endif
Next
If lTPLDRO
	//--Ordena o Array por  Filial Necessidade  + Produto + Qtd. de Necessidade 
	ASort(aQtdProp,,,{|x,y| x[1]  + x[2] + Str( x[3], aTamB2_QATU[1],;
                        	aTamB2_QATU[2] ) < ;
	                         y[1]  + y[2] + Str( y[3], aTamB2_QATU[1],;
                          	 aTamB2_QATU[2] ) } )	                          	 			   
EndIf	
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177CalcNec  ³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³CALCULA A NECESSIDADE DO PRODUTO                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177CalcNec( cFilNec, cCodPro, nSldFilNec )
Local aArea      := GetArea()
Local aAreaSB1   := SB1->( GetArea() )
Local aAreaSBZ   := SBZ->( GetArea() )
Local aAreaSM4   := SM4->( GetArea() )
Local aAreaSX1   := {}
Local cFormula   := ''
Local cFilAntBkp := cFilAnt
Local nQtdNec    := 0
Local nPosTotNec := 0
Local nSaldo     := 0
Local nSaldoMax  := 0
Local nEstSeq    := 0
Local cArea      := ""
Local cAreSek    := ""    
Local nI         := 0

If aPARAM177[06] == 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CALCULO POR PONTO DE PEDIDO (PADRAO ERP)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//--Trata a Filial corrente:
	cFilAnt := cFilNec

	//--Ajusta e Carrega o grupo de perguntas padrao do ponto de pedido
	aAreaSX1 := SX1->( GetArea() )
	nTamSX1  := Len(SX1->X1_GRUPO)

	SX1->( dbSetOrder(1) )
	SX1->( dbSeek( PadR('MTA170', nTamSX1)+'01' ) )
	RecLock('SX1', .F. )
	SX1->X1_CNT01 := cCodPro
	SX1->( MsUnLock() )

	SX1->( dbSeek( PadR('MTA170', nTamSX1)+'02' ) )
	RecLock('SX1', .F. )
	SX1->X1_CNT01 := cCodPro
	SX1->( MsUnLock() )
	RestArea( aAreaSX1 )
		
	Pergunte( 'MTA170', .F. )

	//--Filtra se produto possui estrutura
	If !SG1->( dbSeek(xFilial('SG1') + cCodPro) )

		//--Posiciona o SB1
		SB1->( dbSetOrder(1) )
		SB1->( dbSeek( xFilial('SB1') + cCodPro ) )

		nSaldo    := nSldFilNec
		nEstSeg   := CalcEstSeg( RetFldProd(cCodPro, 'B1_ESTFOR', 'SB1'), 'SB1' )
		nSaldo    -= nEstSeg
		nSaldoMax := A711Sb1EstMax( cCodPro )
	
		If Round(nSaldo,4) <> 0 .Or. MV_PAR09 == 1
			If RetFldProd( cCodPro, 'B1_EMIN', 'SB1' ) <> 0 .And. MV_PAR09 == 1
				If ( MV_PAR10 == 2 .And. nSaldo < 0 )
					nSaldo -= RetFldProd(cCodPro,'B1_LE','SB1')
				EndIf
					
				nQtdNec := If((nSaldo < 0),Abs(nSaldo)+RetFldProd(cCodPro,'B1_EMIN','SB1'),;
							(If(QtdComp(nSaldo)==QtdComp(RetFldProd(cCodPro,'B1_EMIN','SB1')),1,0);
							+RetFldProd(cCodPro,'B1_EMIN','SB1')-nSaldo))
					
				//-- Soma 1 na quantidade da necessidade.
				//-- Ex: Ponto Pedido = 10 e Estoque = 9, ao inves de gerar 2 SCs de 1 pc ira gera 1 SC de 2 pcs  (para sair do ponto de pedido)
				If nSaldo < QtdComp(RetFldProd(cCodPro,'B1_EMIN','SB1')) //-- Se o Saldo for menor que o Ponto do Pedido
					nQtdNec += 1
				EndIf
					
			ElseIf RetFldProd(cCodPro,'B1_EMIN','SB1') <> 0 .And. MV_PAR09 == 2
				If ( MV_PAR10 == 2 .And. nSaldo < 0 )
					nSaldo -= RetFldProd(cCodPro,'B1_LE','SB1')
				EndIf
					
				nQtdNec := If((nSaldo < 0),Abs(nSaldo),;
				(If(QtdComp(nSaldo) ==  QtdComp(  RetFldProd(cCodPro,'B1_EMIN','SB1')  ),1,0);
				+RetFldProd(cCodPro,'B1_EMIN','SB1')-nSaldo))
					
				//-- Soma 1 na quantidade da necessidade.
				//-- Ex: Ponto Pedido = 10 e Estoque = 9, ao inves de gerar 2 SCs de 1 pc ira gera 1 SC de 2 pcs  (para sair do ponto de pedido)
				If nSaldo < QtdComp(RetFldProd(cCodPro,'B1_EMIN','SB1')) //-- Se o Saldo for menor que o Ponto do Pedido
					nQtdNec += 1
				EndIf
					
			ElseIf RetFldProd(cCodPro,'B1_LE','SB1') <> 0 .And. (nSaldo < 0  .or. MV_PAR09 == 2)
				If ( MV_PAR10 == 2 .And. nSaldo < 0 )
					nQtdNec := Abs(nSaldo)+RetFldProd(cCodPro,'B1_LE','SB1')
				Else
					nQtdNec := If( Abs(nSaldo)<RetFldProd(cCodPro,'B1_LE','SB1'),RetFldProd(cCodPro,'B1_LE','SB1'),if(nSaldo<0,Abs(nSaldo),0))
				EndIf
			Else
				nQtdNec := IF(MV_PAR09 == 1,IIf(nSaldo<0,Abs(nSaldo),0),0)
			EndIf
		Else
			If RetFldProd(cCodPro,'B1_EMIN','SB1') <> 0
				nQtdNec := RetFldProd(cCodPro,'B1_EMIN','SB1')
			Else
				nQtdNec := 0
			Endif
		EndIf
		If nSaldoMax <> 0 .And. MV_PAR14 == 2
			nQtdNec   := Min(nSaldoMax - nSaldo, QtdNec)
		Endif
	EndIf

	//--Restaura o ambiente
	cFilAnt := cFilAntBkp
	Pergunte( 'MTA177', .F. )

ElseIf aPARAM177[06] == 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FORMULA ESPECIFICA DO USUARIO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SM4")
	DbSetOrder(1)	
	cFormula := GetAdvFval( 'SM4', 'M4_FORMULA', xFilial('SM4') + aPARAM177[07], 1 )
	If !Empty( cFormula )  
	    For nI := 1 to 2 
		    Do Case 
		    	Case nI == 1
		        	cArea := "SB1" 
		        	cAreSek := xFilial("SB1")
		    	Case nI == 2
		    		cArea := "SBZ"
		    		cAreSek := cFilNec		    
		    EndCase		    	    
		    DbSelectArea( cArea  )
		    DbSetOrder(1)
		    DbSeek(( cAreSek )+ cCodPro ) 
	    Next nI 
		nQtdNec := &( cFormula )
		If ValType( nQtdNec ) <> 'N'
			nQtdNec := 0
		EndIf
	Else
		nQtdNec := 0
	EndIf

EndIf

RestArea( aArea )
RestArea( aAreaSB1 )
RestArea( aAreaSBZ )
RestArea( aAreaSM4 )

Return( nQtdNec )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177EdtCol  ³Autor  ³Vitor Raspa          ³Data  ³ 07-Mai-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Edita uma coluna especifica do Grid                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177EdtCol( aItens, nLin, lConf, aNecAlt,oTotNecInf,  ;
							nTotNecInf	, oTotValProd,nValTotalProd,nDecimais  )

Local nOpcA   := 0                        
Local nPos    := 0
Local nCount  := 0
Local nTotNec := 0
Local nAtuNec := aItens[nLin,7]
Local nNewNec := aItens[nLin,8]
Local oDlg
Local oFont
Local oGetNewNec    
DEFAULT nTotNecInf := 0
DEFAULT oTotNecInf := NIL  
DEFAULT nValTotalProd := 0
DEFAULT oTotValProd   := NIL

//--Totaliza as Necessidades
AEval( aItens, {|x| If( x[3] == aItens[nLin,3], nTotNec += x[07], )} )

//--Monta tela para edicao da necessidade
Define MSDialog oDlg Title STR0165 From 000, 000 To 190, 450 Pixel //--"Editar Necessidade"

	oFont := TFont():New( 'Arial',, -12,, .T. )
	
	TGroup():New( 005, 005, 035, 220, STR0166, oDlg, CLR_BLUE,, .T. ) //--" Produto "
	TSay():New( 018, 010, {|| AllTrim( aItens[nLin, 3] ) + ' - ' + aItens[nLin,4]}, oDlg,, oFont,,,, .T., CLR_RED, CLR_WHITE, 200, 20 )

	TGroup():New( 040, 005, 070, 070, STR0167, oDlg, CLR_BLUE,, .T. ) //--" Total das Neces. "
	TGet():New( 050, 010, {|x| If( PCount() > 0, nTotNec := x, nTotNec )}, oDlg, 50, 05, '99999', {|| },,,oFont,,,.T.,,,{|| .F.}) 

	TGroup():New( 040, 072, 070, 146, STR0168, oDlg, CLR_BLUE,, .T. ) //--" Necessidade Atual "
	TGet():New( 050, 077, {|x| If( PCount() > 0, nAtuNec := x, nAtuNec )}, oDlg, 50, 05, '99999', {|| },,,oFont,,,.T.,,,{|| .F.}) 

	TGroup():New( 040, 148, 070, 220, STR0169, oDlg, CLR_BLUE,, .T. ) //--" Nova Necessidade "
	ToGetNewNec := TGet():New( 050, 153, {|x| If( PCount() > 0, nNewNec := x, nNewNec )}, oDlg, 50, 05, '99999', {|| nNewNec >= 0 },,,oFont,,,.T.,,,{|| .T.}) 

	TButton():New( 075, 075, STR0170, oDlg, {|| nOpcA := 1, oDlg:End() }, 070, 015,,,,.T. ) //--"Confirmar"
	TButton():New( 075, 150, STR0171, oDlg, {|| nOpcA := 0, oDlg:End() }, 070, 015,,,,.T. ) //--"Cancelar"

Activate MSDialog oDlg Centered

//--Efetiva a alteracao no Grid
If nOpcA == 1
    If lTPLDRO  
		nTotNecInf -= aItens[nLin,8]
		nTotNecInf += nNewNec
		oTotNecInf:REFRESH() 	
		If aPARAM177[1]	== 1    
			nValTotalProd := (nValTotalProd - Val(aItens[nLin,16]) ) + ; 
		                   Val(aItens[nLin,16] := Right(Space(29) + AllTrim(Transform(Round(Val(aItens[nLin,15]) * nNewNec ,nDecimais)," 999999.99")),29)  )
	    	oTotValProd:REFRESH()
	    EndIf
	Endif
	aItens[nLin,8] := nNewNec

	//--Dispensa a confirmacao geral da edicao
	//--Utilizado quando os dados sao exibidos em tela ( aPARAM177[22] == .T. (lShowScreen) )
	If lConf
		nPos := AScan( aNecAlt, {|x| x[1] + x[2] == aItens[nLin,1] + aItens[nLin,3]} )
		If nPos == 0
			AAdd(aNecAlt, {	aItens[nLin,1],;	//--Filial da Necessidade
							aItens[nLin,3],;	//--Codigo do Produto
							nNewNec} )			//--Qtd. Informada (Necessidade)
		Else
			aNecAlt[nPos,3] := nNewNec
		EndIf
	EndIf
EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177EdtOK   ³Autor  ³Vitor Raspa          ³Data  ³ 07-Mai-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Confirma as edicoes realizadas no Grid                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177EdtOK( aCabec, aItens, aNecAlt, oBrwNec)
Local nCount := 0
Local nPos   := 0

For nCount := 1 To Len( aItens )
	nPos := AScan( aNecAlt, {|x| x[1] + x[2] == aItens[nCount,1] + aItens[nCount,3]} )
	If aItens[nCount,7] <> aItens[nCount,8] .Or. nPos <> 0
		If nPos == 0
			AAdd(aNecAlt, {	aItens[nCount,1],;	//--Filial da Necessidade
							aItens[nCount,3],;	//--Codigo do Produto
							aItens[nCount,8]} )	//--Qtd. Informada (Necessidade)
		Else
			aNecAlt[nPos,3] := aItens[nCount,8]
		EndIf
	EndIf
Next

aItens := Array( 1, Len(aCabec) )

//--Atualiza o Browse com as informacoes do Produto...
oBrwNec:SetArray( aItens )
If aPARAM177[01] == 01
	oBrwNec:bLine := {|| {	aItens[ 01, 01 ], aItens[ 01, 02 ], aItens[ 01, 03 ],;
 							aItens[ 01, 04 ], aItens[ 01, 05 ], aItens[ 01, 06 ],;
 							aItens[ 01, 07 ], aItens[ 01, 08 ], aItens[ 01, 09 ],;
							aItens[ 01, 10 ], aItens[ 01, 11 ], aItens[ 01, 12 ] } }
Else
	oBrwNec:bLine := {|| {	aItens[ 01, 01 ], aItens[ 01, 02 ], aItens[ 01, 03 ],;
 							aItens[ 01, 04 ], aItens[ 01, 05 ], aItens[ 01, 06 ],;
 							aItens[ 01, 07 ], aItens[ 01, 08 ], aItens[ 01, 09 ],;
							aItens[ 01, 10 ], aItens[ 01, 11 ], aItens[ 01, 12 ],;
							aItens[ 01, 13 ] } }
EndIf
oBrwNec:Refresh()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177ValEdt  ³Autor  ³Emerson Rony Oliveira³Data  ³ 07-Ago-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Velifica se a edicao dos produtos foi finalizada ou nao     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177ValEdt(oBrwNec)
Local lRet := .F.
lRet := !(oBrwNec:lActive == .T.)

If !lRet
	Help( ' ', 1, 'MATA17711')
EndIf

Return (lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177TWBrwPesq ³Autor ³Vitor Raspa         ³Data  ³ 26-Mar-08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Realiza pesquisa no Browse (oBrwNec)                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177TWBrwPesq( aItens, oBrwNec )
Local aCboOrdens := {}
Local cOrdem     := ''
Local cCpoPesq   := Space(40)
Local lSeek      := .F.
Local nOrdem     := 1
Local nSeek      := 0
Local oDlgPesq
Local oCboOrdens
Local oCpoPesq

//--Adiciona as Ordens de Pesquisa...
AAdd( aCboOrdens, STR0026 ) //--"Produto"
AAdd( aCboOrdens, STR0012 ) //--"Descricao"
AAdd( aCboOrdens, STR0027 ) //--"Grupo"
AAdd( aCboOrdens, STR0028 ) //--"Tipo"
AAdd( aCboOrdens, STR0062 ) //--"Filial Necess. + Produto"

Define MSDialog oDlgPesq Title STR0038 From 00,00 To 100,490 Pixel //--"Pesquisar"

	@ 05,05 ComboBox oCboOrdens Var cOrdem Items aCboOrdens Size 206,36 Pixel Of oDlgPesq On Change (nOrdem := oCboOrdens:nAT)
	@ 22,05 MSGet oCpoPesq Var cCpoPesq Picture '@!' Size 206,10 Pixel Of oDlgPesq

	Define SButton From 05,215 Type 1 Of oDlgPesq Enable Action ( lSeek := .T., oDlgPesq:End() )
	Define SButton From 20,215 Type 2 Of oDlgPesq Enable Action ( lSeek := .F., oDlgPesq:End() )

Activate MSDialog oDlgPesq Center

If lSeek
	cCpoPesq := AllTrim( cCpoPesq )

	If nOrdem == 1
		//--Produto
		ASort( aItens,,,{|x,y| x[3] < y[3]} )
		nSeek := AScan( aItens, {|x| AllTrim(x[3]) == cCpoPesq } )
	
	ElseIf nOrdem == 2
		//--Descricao
		ASort( aItens,,,{|x,y| x[4] < y[4]} )
		nSeek := AScan( aItens, {|x| Left( x[4], Len( cCpoPesq ) ) == cCpoPesq } )
		
	ElseIf nOrdem == 3
		//--Grupo
		ASort( aItens,,,{|x,y| x[5] < y[5]} )
		nSeek := AScan( aItens, {|x| AllTrim(x[5])== cCpoPesq } )

	ElseIf nOrdem == 4
		//--Tipo
		ASort( aItens,,,{|x,y| x[6] < y[6]} )
		nSeek := AScan( aItens, {|x| AllTrim(x[6]) == cCpoPesq } )
	
	ElseIf nOrdem == 5
		//--Filial Necessidade + Produto
		ASort( aItens,,,{|x,y| x[1]+x[3] < y[1]+y[3]} )
		nSeek := AScan( aItens, {|x| AllTrim(x[1]+x[3]) == cCpoPesq } )

	EndIf

	If	nSeek > 0
		oBrwNec:nAT := nSeek		
	EndIf

	oBrwNec:Refresh()
	oBrwNec:SetFocus()
EndIf

Return      


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177GetFor   ³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³OBTEM O FORNECEDOR PARA GERACAO DO PEDIDO DE COMPRA         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function A177GetFor( cFilNec,  cCNPJ, cCodPro, cCodFor,cloja,lDistrb ) 
Local aArea      := GetArea()
Local aAreaSA2   := SA2->( GetArea() )
Local aAreaSA5   := SA5->( GetArea() )
Local aAreaSB1   := SB1->( GetArea() )
Local aRet       := {}
Local cFilSA2    := If( a177MdAccess("SA2"), FWxFilial('SA2'), cFilNec )

//--P. E. p/ retornar o fornecedor (Cod.Fornecedor / Filial) a ser considerado na emissao do Pedido
Local lMTA177For  := ExistBlock('MTA177For') 
Local aMTA177For  :={}  
Local aMTA177     :={}     
Local aLojFor     :={}      // recebe o retorno da funcao do TEmplate de Drogaria
Local lMTA177TFor := ExistTemplate( 'MTA177For' )	             

Default cCNPJ    := ''
Default cCodPro  := ''
Default cCodFor  := '' 
Default cLoja    := ''  
Default lDistrb  := .F.   

If lMTA177For
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³EXECUTA PONTO DE ENTRADA PARA TROCA DO FORNECEDOR³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aMTA177For := ExecBlock('MTA177For', .F., .F., { cFilNec, cCNPJ, cCodPro, cCodFor, cLoja } )
	If ValType( aMTA177For ) <> 'A'  // Nao retornou array, considera o que foi obtido pelo SQL
	    AAdd(aMTA177,cCNPJ)
	    AAdd(aMTA177,cCodFor)
	    AAdd(aMTA177,cLoja)
	Else      
	    aMTA177:=aclone(aMTA177For)   
	EndIf  
End
If lMTA177TFor .AND. !lDistrb
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³EXECUTA PONTO DE ENTRADA PARA TROCA DO FORNECEDOR³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aMTA177For := ExecTemplate( 'MTA177For', .F., .F.,{ cFilNec, cCNPJ, cCodPro, cCodFor, cLoja } )
	If ValType( aMTA177For ) <> 'A'  // Nao retornou array, considera o que foi obtido pelo SQL
	    AAdd(aMTA177,cCNPJ)
	    AAdd(aMTA177,cCodFor)
	    AAdd(aMTA177,cLoja)  
	    lMTA177For := .T.
	Else      
	    aMTA177:=aclone(aMTA177For)   
	EndIf  														  
EndIf

If lTPLDRO .AND. lDistrb 
	lMTA177For := .F.
    aLojFor := T_DroRetFornec()	
  	cCodFor := aLojFor[1]
  	cLoja   := aLojFor[2]	
EndIf
//-- Obtem dados do Fornecedor // ---
//-- Sem utilizar o PE, considera a Fornecedor/Loja do arquivo de trabalho
//-- Com PE, considera a Filial / Fornecedor retornardo pelo PE

If  AllTrim(cCodFor) <> "" .AND. AllTrim(cLoja) <> ""  //ALTERACAO PARA O TEMPLATE DE DROGARIA
	SA2->( DbSetOrder(1) ) 
	If SA2->( DbSeek( cFilSA2 + If( lMTA177For, aMTA177[2]+aMTA177[3], cCodFor+cLoja ) ) )
    	aRet    := {'','',''}
		aRet[1] := SA2->A2_COD
		aRet[2] := SA2->A2_LOJA
		aRet[3] := SA2->A2_COND			
	EndIf	
Else    
	If Empty(cCNPJ) .And. Empty(cCodFor) .And. Empty(cLoja) .And. lDistrb  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	    //| Geração de Pedido de Compras para Distribuição.                                 |
  	    //| Considera como sendo o fornecedor do pedido de compras, a Filial Centralizadora |
  	    //| se o processo possuir filial Centralizadora										|
 	  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	       
		//--Obtem o CNPJ conforme SIGAMAT.EMP
		SM0->( DbSetOrder(1) )
		If SM0->( DbSeek(cEmpAnt + aParam177[21]))
			cCNPJ := SM0->M0_CGC
		EndIf
		
		SA2->(DbSetOrder(3)) 
		If SA2->(DbSeek( cFilSA2 + cCNPJ))
	    	aRet    := {'','',''}
			aRet[1] := SA2->A2_COD
			aRet[2] := SA2->A2_LOJA
			aRet[3] := SA2->A2_COND			
		Else
			aRet    := {'','',''}			
		EndIf
	Else
		aRet    := {'','',''}			
	EndIf	
EndIf
RestArea( aAreaSA2 )
RestArea( aAreaSA5 )
RestArea( aAreaSB1 )
RestArea( aArea )
Return( aRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177GetCli   ³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³OBTEM O CLIENTE PARA GERACAO DO PEDIDO DE VENDA             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177GetCli( cFilNec )
Local aArea      := GetArea()
Local aAreaSA1   := SA1->( GetArea() )
Local aAreaSM0   := SM0->( GetArea() )
Local aRet       := {}
Local cCNPJ      := ''
Local cFilSA1    := If( a177MdAccess("SA1"), xFilial('SA1'), cFilNec )

//--Ponto de Entrada para retornar o fornecedor (CNPJ) a ser considerado na emissao do Pedido
Local lMTA177Cli := ExistBlock('MTA177Cli')
Local cMTA177Cli := ''

//--Obtem o CNPJ conforme SIGAMAT.EMP
SM0->( DbSetOrder(1) )
If SM0->( DbSeek( cEmpAnt + cFilNec ) )
	cCNPJ := SM0->M0_CGC
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXECUTA PONTO DE ENTRADA PARA TROCA DO CLIENTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTA177Cli
	cMTA177Cli := ExecBlock('MTA177Cli', .F., .F., { cFilNec, cCNPJ } )
	If ValType( cMTA177Cli ) <> 'C'
		cMTA177Cli := cCNPJ
	EndIf
EndIf

SA1->( DbSetOrder(3) )
If SA1->( DbSeek( cFilSA1 + IIf(lMTA177Cli .And. !Empty(cMTA177Cli) , cMTA177Cli, cCNPJ) ) )
	aRet    := {'', '', ''}
	aRet[1] := SA1->A1_COD
	aRet[2] := SA1->A1_LOJA
	aRet[3] := SA1->A1_COND
EndIf

RestArea( aAreaSA1 )
RestArea( aAreaSM0 )
RestArea( aArea )

Return( aRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177Print    ³ Autor ³Vitor Raspa         ³ Data ³ 01.Abr.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do Calculo da Necessidade                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177Print( aCabec, cAliasTrb, aNecAlt, nTotReg, aItens )
Local aArea         := GetArea()
Local cCabec1       := ''
Local cCabec2       := ''
Local cDesc1        := STR0083 //--"Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := STR0084 //--"com os resultados dos calculos de necessidades gerados a   "
Local cDesc3        := STR0085 //--"partir da rotina 'Central de Compras'"
Local cTitulo       := STR0086 //--"Calculo de Necessidades - Central de Compras"
Local nLin          := 80

Private aOrd        := {}
Private aReturn     := { STR0087, 1, STR0088, 2, 2, 1, '', 1} //--"Zebrado"#"Administracao"
Private cString     := 'SB1'
Private cNomeprog   := CriaTrab(Nil, .F.)
Private lEnd        := .F.
Private lAbortPrint := .F.
Private m_pag       := 01
Private nLimite     := 220
Private nTipo       := 18
Private nLastKey    := 0
Private Tamanho     := 'G'
Private wnrel       := CriaTrab(Nil, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,'',@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
	RestArea( aArea )
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| RunReport( @lEnd, cCabec1, cCabec2, cTitulo, nLin, aCabec, cAliasTrb, aNecAlt, nTotReg, aItens ) }, cTitulo)
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunReport    ³ Autor ³Vitor Raspa         ³ Data ³ 01.Abr.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao responsavel pela impressao                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RunReport( lEnd, cCabec1, cCabec2, cTitulo, nLin, aCabec, cAliasTrb, aNecAlt, nTotReg, aItens )
Local cLinha  := ''
Local nQtdNec := 0
Local nPos    := 0

//--Formata o cabecalho:
cCabec1 := '---FILIAIS---- ------------------------------PRODUTO------------------------------------  ---NECESSIDADES---- ---SALDO--- MEDIA'
cCabec2 := 'CENTR. NECESS. CODIGO          DESCRICAO                                GRP  TP EST. MAX  CALCULADA INFORMADA ATUAL CENT. VENDA'

//--Impressao!
SetRegua( nTotReg )
(cAliasTrb)->( DbGoTop() )
Do While !(cAliasTrb)->( Eof() )
	If lAbortPrint .Or. lEnd
		@ 000,000 PSay STR0091 //--"***CANCELADO PELO OPERADOR!"
		Exit
	EndIf
	
	//--IMPRIME O CABECALHO
	If nLin > 55
		nLin := Cabec( cTitulo, cCabec1, cCabec2, '', Tamanho, nTipo )
		nLin++
	EndIf

	//--Verifica se a necessidade foi alterada
	nPos := AScan( aNecAlt, {|x| x[1] + x[2] == (cAliasTrb)->( FILNEC + CODPRO )} )
	If nPos <> 0
		nQtdNec := aNecAlt[nPos,3]
	Else
		If aPARAM177[22]
			//--Caso os dados tenham sido exibidos em tela,
			//--nao realiza novamente o calculo das necessidades...
			nPos := AScan( aItens, {|x| x[1] + x[3] == (cAliasTrb)->( FILNEC + CODPRO )} )
			nQtdNec := If( nPos <> 0, aItens[nPos,8], 0 )
		Else
			If aPARAM177[06] == 1 .Or. aPARAM177[06] == 2
				nQtdNec := (cAliasTrb)->QTDNEC
			Else
				nQtdNec := A177CalcNec( (cAliasTrb)->FILNEC, (cAliasTrb)->CODPRO, (cAliasTrb)->SLDFILNEC )
			EndIf
		EndIf
	EndIf
	
	//cCabec1 := '---FILIAIS---- ------------------------------PRODUTO------------------------------------  ---NECESSIDADES---- ---SALDO--- MEDIA'
	//cCabec2 := 'CENTR. NECESS. CODIGO          DESCRICAO                                GRP  TP EST. MAX  CALCULADA INFORMADA ATUAL CENT. VENDA'
	//            0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111
	//            0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222
	//            1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
	//              99     99    123456789012345 1234567890123456789012345678901234567890
	If ( aPARAM177[23] .And. nQtdNec > 0 ) .Or. ( !aPARAM177[23] .And. nQtdNec >= 0 )
		//--Formata a linha de impressao
		cLinha := '  '
		cLinha += If(Empty(aPARAM177[21]), '  ', aPARAM177[21]) + Space(05)
		cLinha += (cAliasTrb)->FILNEC + Space(04)
		cLinha += (cAliasTrb)->CODPRO + Space(01)
		cLinha += Left( (cAliasTrb)->DESPRO + Space(40), 40 ) + Space(01)
		cLinha += (cAliasTrb)->GRUPO + Space(01)
		cLinha += (cAliasTrb)->TIPO + Space(04)
		cLinha += Transform( (cAliasTrb)->EMAX, '99999') + Space(05)
		cLinha += Transform( (cAliasTrb)->QTDNEC, '99999') + Space(05)
		cLinha += Transform( nQtdNec, '99999') + Space(01)
		cLinha += Transform( (cAliasTrb)->SLDFILNEC, '99999') + Space(01)
		cLinha += Transform( (cAliasTrb)->SLDFILCEN, '99999') + Space(01)
		cLinha += Transform( (cAliasTrb)->MEDVENDAS, '99999')

		//--Impressao:
		@nLin, 000 PSAY cLinha
		nLin++
  EndIf	
	(cAliasTrb)->( DbSkip() )
	IncRegua()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177GrvCalc ³ Autor ³VITOR RASPA          ³ Data ³ 29.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Salva o calculo em questao                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177GrvCalc( cAliasTrb, aNecAlt, cNumCalc, nTotReg )  
Local aAreaSA2 := SA2->( GetArea() )
Local cFilSA2  := ''
Local lNewCalc := .F.
Local nPosNec  := 0

//--Caso seja a primeira vez que o calculo esta sendo salvo,
//--obtem o proximo numero disponivel...
If Empty( cNumCalc )
	cNumCalc := GetSxeNum('AIE', 'AIE_NUM')	
	ConfirmSX8()
	lNewCalc := .T.
EndIf

//--Processa a gravacao...
ProcRegua( nTotReg )
(cAliasTrb)->( DbGoTop() )
Do While !(cAliasTrb)->( Eof() )
	
	//--Verifica se o usuario alterou a necessidade calculada...
	nPosNec := AScan( aNecAlt, {|x| x[1] + x[2] == (cAliasTrb)->(FILNEC + CODPRO)} )
	
	If lNewCalc
		RecLock( 'AIE', .T. )
		AIE->AIE_FILIAL := xFilial('AIE') 
		AIE->AIE_NUM    := cNumCalc
		AIE->AIE_DTCALC := dDataBase
		AIE->AIE_FILNEC := (cAliasTrb)->FILNEC     
		AIE->AIE_CODPRO := (cAliasTrb)->CODPRO
	Else
		AIE->( DbSetOrder(1) )
		AIE->( DbSeek( xFilial('AIE') + cNumCalc + (cAliasTrb)->(FILNEC + CODPRO)  ) )
		RecLock( 'AIE', .F. )
	EndIf

	AIE->AIE_FILCEN := aPARAM177[21]
	AIE->AIE_EMAX   := (cAliasTrb)->EMAX
	AIE->AIE_NECESS := (cAliasTrb)->QTDNEC
	AIE->AIE_NECDIG := If( nPosNec <> 0, aNecAlt[nPosNec,3], (cAliasTrb)->QTDNEC )
	AIE->AIE_SLDCEN := (cAliasTrb)->SLDFILCEN
	AIE->AIE_SLDNEC := (cAliasTrb)->SLDFILNEC
	AIE->AIE_MEDVEN := (cAliasTrb)->MEDVENDAS

    // -- Considera o Fornecedor / Loja do Arquivo de Trabalho quando o aPARAM177[01]==1 ---
	AIE->AIE_CODFOR := If( aPARAM177[01] == 1, (cAliasTrb)->CODFOR, '' )
    AIE->AIE_LOJFOR := If( aPARAM177[01] == 1, (cAliasTrb)->LOJA, '' )

	AIE->(MsUnLock() )
    
	(cAliasTrb)->( DbSkip() )
	IncProc()
EndDo

If lNewCalc
	Aviso( STR0185, STR0186 + Chr(13) + Chr(10) + STR0187 + cNumCalc, {'OK'}, 2 )  //--"Gravacao do Calculo"#"Calculo gravado com sucesso!"#"O N.o do calculo e "
Else
	Aviso( STR0188, STR0189 + cNumCalc + STR0190, {'OK'}, 2 ) //--"Atualizacao do Calculo"#"O calculo "#" foi atualizado com sucesso!"
EndIf

RestArea( aAreaSA2 )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177Log   ³Auto   ³Vitor Raspa            ³Data  ³ 29.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Realiza o Log das operacoes                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177Log( cMsgLog, lShowLog )
Local aCabec    := {}
Local nAux      := 0
Local oIconTime := LoadBitmap( GetResources(), 'OPERACAO')
Local oIcon     := LoadBitmap( GetResources(), 'PCOFXOK')
Local oDlgLog
Local oBrwLog

Default cMsgLog  := ''
Default lShowLog := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ESTRUTURA DO VETOR aLOG             ³
//³[01]TEXTO                           ³
//³[02]Hora de Inicio                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//--Adiciona nova linha ao Log
AAdd( aLog, {cMsgLog, Time()} )

//--Exibe mensagem no console do Server
ConOut( cMsgLog + ' - ' + Time() )

//--Exibe a janela com o Log
If lShowLog

	//--Calcula o Tempo gasto
	AAdd( aLog, {STR0191, ElapTime( aLog[1,2], Time() )} ) //--"TEMPO GASTO"

	AAdd( aCabec, '' )
	AAdd( aCabec, STR0192 ) //--"Operacao"
	AAdd( aCabec, STR0193 ) //--"Inicio"
	Define MsDialog oDlgLog Title STR0194 From 0,0 To 350, 750 Of oMainWnd Pixel //--"Log de Operacoes - Central de Compras"
		oBrwLog := TWBrowse():New( 010, 010, 355, 135,, aCabec, {20,200,30}, oDlgLog,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		oBrwLog:SetArray( aLog )
		oBrwLog:bLine := { || { If(oBrwLog:nAt == Len(aLog), oIconTime, oIcon) , aLog[oBrwLog:nAt,1], aLog[oBrwLog:nAt,2] }}

		@ 150,260 BUTTON STR0195 ; 
				  ACTION oDlgLog:End() ;
				  SIZE 105, 15 ;
				  OF oDlgLog PIXEL

	Activate MSDialog oDlgLog Centered

EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177Categ ³ Autor ³ Rafael Braga Cancian  ³ Data ³06/09/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Filtro por categoria                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177Categ( aCategorias, lCategorias )
Local aArea    := GetArea()
Local aAreaACV := ACV->( GetArea() )
Local cVarCateg
Local lInvCat
Local nOpcA    := 0
Local oOk      := LoadBitmap( GetResources(), 'LBOK')
Local oNo      := LoadBitmap( GetResources(), 'LBNO')
Local oDlgCateg
Local oChkInvCat
Local oLstCateg

If lCategorias
	ACV->( DbSetOrder(1) )
	ACV->( DbSeek( xFilial('ACV') ) )
	Do While !ACV->( Eof() ) .And. ACV->ACV_FILIAL == xFilial('ACV')
		If AScan( aCategorias, {|x|, x[2] == ACV->ACV_CATEGO} ) == 0
			AAdd( aCategorias, { .T., ACV->ACV_CATEGO, Posicione('ACU', 1, xFilial('ACU')+ ACV->ACV_CATEGO, 'ACU_DESC' ) } )
		EndIf
		ACV->( DbSkip() )
	EndDo

	//--Monta Janela para selecao das categorias
	If Len(aCategorias) > 0

    	Define MSDialog oDlgCateg Title STR0069 From 145,0 To 445,628 Of oMainWnd Pixel //--"Selecao de Categorias"
			@ 05,15 To 125,300 Label STR0070 Of oDlgCateg Pixel //--"Marque as categorias a serem consideradas"

			@ 15,20 CheckBox oChkInvCat ;
					Var lInvCat ;
					Prompt STR0003 ; //--"Inverte selecao"
					SIZE 50, 10 ;
					Of oDlgCateg Pixel ;
					On Click ( AEval(aCategorias, {|x| x[1] := If( x[1], .F., .T. )} ), oLstCateg:Refresh(.F.) )

			@ 30,20 ListBox oLstCateg ; 
					VAR cVarCateg ;
					Fields HEADER '',STR0071, STR0005; ///--"Categoria"#"Descricao"
					SIZE 273,090 ;
					On DblClick ( aCategorias[oLstCateg:nAt,1] := !aCategorias[oLstCateg:nAt,1] ) ;
					OF oDlgCateg PIXEL
					
			oLstCateg:SetArray( aCategorias )
			oLstCateg:bLine := { || {If(aCategorias[oLstCateg:nAt,1], oOk, oNo ), aCategorias[oLstCateg:nAt,2], aCategorias[oLstCateg:nAt,3] } }

			DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION (nOpcA := 1, oDlgCateg:End()) ENABLE OF oDlgCateg
			DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (nOpcA := 2, oDlgCateg:End()) ENABLE OF oDlgCateg

		Activate MSDialog oDlgCateg Center  

	EndIf
EndIf

If nOpcA == 0
	If MsgYesNo( STR0072 ) //--"Limpar selecao das Categorias?"
		AEval( aCategorias, {|x| x[1] := .F. } )
	EndIf
EndIf

RestArea( aAreaACV )
RestArea( aArea )

Return

                          
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A177CalcDt³ Autor ³ Rafael Braga Cancian  ³ Data ³06/09/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Calcula a data inicial do periodo de acordo com os         ³±±
±±³          ³ parametros passados                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177CalcDt(nPeriodo, nTipo )
Local dDtIni := CtoD( Space(08) )
Local lIntervalo  := (!Empty(aPARAM177[31]) .AND. !Empty(aParam177[32]) )	//Verifica se o intervalo de datas foi preenchido
Local aRetorno    := {}  // Retorno da Data inicial e data final do periodo
Local dDtFim      := dDataBase         // data final 
Local nPeriod     := 0                 // periodo do parametro aPARAM177[08]

If !lIntervalo
	//--Calcula periodo de acordo com o tipo selecionado
	If nTipo == 1 //Dias
		dDtIni := dDataBase - nPeriodo + 1
	ElseIf nTipo == 2 //Semanas
		dDtIni := dDataBase - (nPeriodo * 7) + 1
	Else //Meses
		dDtIni :=  dDataBase - (nPeriodo * 30) + 1
	EndIf 
	aRetorno := {dDtIni,dDtFim} 
Else
	dDtIni	 := aPARAM177[31]
	dDtFim	 := aPARAM177[32] 
    aRetorno := {dDtIni,dDtFim}
    nPeriod := dDtFim - dDtIni + 1
   	aPARAM177[08] := nPeriod    	
EndIf	 

  
Return( aRetorno )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177VldPro   ³ Autor ³Vitor Raspa         ³ Data ³ 06.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida digitacao do Produto na tela resumida de Necessidades³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177VldPro( cCodPro, cDesPro )
Local aAreaSB1 := SB1->( GetArea() )
Local lRet     := .T.

SB1->( dbSetOrder(1) )
If SB1->( dbSeek( xFilial('SB1') + cCodPro ) )
	cDesPro := SB1->B1_DESC
	lRet := .T.
Else
	Help( ' ', 1, 'REGNOIS' )
	lRet := .F.
EndIf

RestArea( aAreaSB1 )

Return( lRet )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177Ordem ³ Autor ³ Rafael Braga Cancian  ³ Data ³06/09/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Tela de definicao da ordem dos produtos                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177Ordem( lShowScreen )
Local aOrdem     := {}
Local cResultado := ''
Local nOrdem     := 0
Local oDlg
Local oListBox
Local oBut1
Local oBut2
Local oBold

If !lShowScreen
	MsgAlert( STR0197 ) //--"A regra de Ordenação somente poderá ser definida quando a opção 'Exibir tela apos o Processamento' estiver selecionada"
	nOrdem := 0
Else
	/*[01]*/AAdd( aOrdem, STR0075 ) //--"Cod. Produto"
	/*[02]*/AAdd( aOrdem, STR0076 ) //--"Descr. Produto"
	/*[03]*/AAdd( aOrdem, STR0077 ) //--"Grupo + Cod. Produto"
	/*[04]*/AAdd( aOrdem, STR0078 ) //--"Tipo + Cod. Produto"
	/*[05]*/AAdd( aOrdem, STR0079 ) //--"Filial da Necess. + Cod. Produto"
	/*[06]*/AAdd( aOrdem, STR0080 ) //--"Filial da Necess. + Descr. Produto"
	/*[07]*/AAdd( aOrdem, STR0081 ) //--"Filial da Necess. + Grupo + Cod. Produto"
	/*[08]*/AAdd( aOrdem, STR0082 ) //--"Filial da Necess. + Tipo + Cod. Produto"     
    /*[09]*/AAdd( aOrdem, STR0212 ) //--"Descr. Produto + Filial da Necess."     	
	
	DEFINE MSDIALOG oDlg TITLE STR0001 FROM 0,0 TO 264,478 OF oMainWnd	PIXEL //--"Central de Compras"
		DEFINE FONT oBold NAME 'Arial' SIZE 0, -13 BOLD
		@  0, -25 BITMAP oBmp RESNAME 'PROJETOAP' oF oDlg SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
		@ 03, 40 SAY STR0015 FONT oBold PIXEL //--"Regra de ordenacao"
		@ 14, 30 TO 16 ,400 LABEL '' OF oDlg PIXEL
		@ 25, 40 LISTBOX oListBox VAR cResultado ITEMS aOrdem PIXEL SIZE 190, 80 OF oDlg MULTI	
	
		DEFINE SBUTTON oBut1 FROM 113, 169 TYPE 1 ACTION ( nOrdem := oListBox:nAt, oDlg:End() )  ENABLE of oDlg
		DEFINE SBUTTON oBut2 FROM 113, 202 TYPE 2 ACTION ( nOrdem := 1, oDlg:End() )  ENABLE of oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf

Return( nOrdem )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A177VldPar³ Autor ³ Rafael Braga Cancian  ³ Data ³ 13.Mai.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida os Parametros da rotina                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A177VldPar( aFiliais, nRadAnls, cFilCent, lShowScreen, lNecess ,;
							lCategorias, aCategorias, aGrupos, aTipos, cFiltUsr, nOrdem, lLog,aSelGrupos)
Local aArea		  := GetArea()
Local aAreaAIE    := AIE->(GetArea())
Local aGruposSel  := {}
Local aTiposSel   := {}
Local aCategSel   := {}
Local aFiliaisSel := {}
Local lRet		  := .T.
Local nFilSel	  := 0
Local nCount      := 0
Local cQuery      := ''
Local cAliasTmp   := ''   
Local nI          := 0   
Local cGruposUso  := ""  
aSelGrupos := {} // Zerando o array para fazer a nova verificação


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ESTRUTURA DO ARRAY "aPARAM177"                                   ³
//³-----------------------------                                    ³
//³aPARAM177[01]...aPARAM177[18]: Perguntas SX1 (Grupo MTA177)      ³
//³aPARAM177[19]: Filiais selecionadas;                             ³
//³aParam177[20]: (1)Analise por Filial | (2)Analise Centralizada   ³
//³aPARAM177[21]: Codigo da Filial Centralizadora                   ³
//³aPARAM177[22]: Exibicao da tela de processamento (.T./.F.)       ³
//³aPARAM177[23]: Exibir somente produtos c/ necessidade (.T./.F.)  ³
//³aPARAM177[24]: Filtro por categoria (.T./.F.)                    ³
//³aPARAM177[25]: Categorias selecionadas                           ³
//³aPARAM177[26]: Grupos selecionados                               ³
//³aPARAM177[27]: Tipos selecionados                                ³
//³aPARAM177[28]: Regra de Filtragem                                ³
//³aPARAM177[29]: Ordem selecionada                                 ³
//³aPARAM177[30]: Log de processamento (.T./.F.)                    ³
//³aPARAM177[31]: Data Inicial p/Calc.Necessidade                   ³
//³aPARAM177[32]: Data Final p/Calc.Necessidade                     ³
//³aPARAM177[33]: Preço para Pedido de Venda	                    ³
//³aPARAM177[34]: Tipo de Tratamento			                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aPARAM177 := Array(34)

//--Alimenta vetor de parametros
For nCount := 1 to 18
	aPARAM177[nCount] := &( 'MV_PAR' + StrZero( nCount, 2 ) )
Next

//--Verifica as Filiais selecionadas...
aPARAM177[19] := {}
aEval( aFiliais, {|x| If( x[1], AAdd( aPARAM177[19], x[2] ), ) } )

aPARAM177[20] := nRadAnls	
aPARAM177[21] := cFilCent
aPARAM177[22] := lShowScreen
aPARAM177[23] := lNecess

//--Verifica as Categorias selecionadas...
aPARAM177[24] := lCategorias
aPARAM177[25] := ''
AEval( aCategorias, {|x| If( x[1], AAdd( aCategSel, x[2] ), ) } )
If Len( aCategSel ) > 0
	aPARAM177[25] := '('
	For nCount := 1 To Len( aCategSel )
		aPARAM177[25] += "'" + aCategSel[nCount] + "'"
		If nCount < Len( aCategSel )
			aPARAM177[25] += ','
		EndIf
	Next
	aPARAM177[25] += ')'
Else
   	aPARAM177[25] += "('')"
EndIf

//--Verifica os Grupos de Produtos selecionados...
aPARAM177[26] := ''
AEval( aGrupos, {|x| If( x[1], AAdd( aGruposSel, x[2] ), ) } )
If Len( aGruposSel ) > 0
	aPARAM177[26] := '('
	For nCount := 1 To Len( aGruposSel )
		aPARAM177[26] += "'" + aGruposSel[nCount] + "'"
		If nCount < Len( aGruposSel )
			aPARAM177[26] += ','
		EndIf
	Next
	aPARAM177[26] += ')'
Else
   	aPARAM177[26] += "('')"
EndIf

//--Verifica os Tipos de Produtos selecionados...
aPARAM177[27] := ''
aEval( aTipos, {|x| If( x[1], AAdd( aTiposSel, x[2] ), ) } )
If Len( aTiposSel ) > 0
	aPARAM177[27] := '('
	For nCount := 1 To Len( aTiposSel )
		aPARAM177[27] += "'" + aTiposSel[nCount] + "'"
		If nCount < Len( aTiposSel )
			aPARAM177[27] += ','
		EndIf
	Next
	aPARAM177[27] += ')'
Else
	aPARAM177[27] += "('')"
EndIf

aPARAM177[28] := cFiltUsr
aPARAM177[29] := nOrdem
aPARAM177[30] := lLog


aPARAM177[31] := &("MV_PAR19")
aPARAM177[32] := &("MV_PAR20") 
aPARAM177[33] := &("MV_PAR21") 	
aPARAM177[34] := &("MV_PAR22") 	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VALIDA OS PARAMETROS INFORMADOS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aPARAM177[19]) == 0
	Help( ' ', 1, 'MATA17710')
	lRet := .F.
EndIf

If lRet .And. (aPARAM177[20] == 1 .And. aPARAM177[01] == 2)
	Help( ' ', 1, 'MATA17702' )
	lRet := .F.
EndIf

If lRet .And. (aPARAM177[1] == 1 .And. aPARAM177[3] == 2)
    Aviso("MATA17709",STR0255+" "+STR0111+ " "+STR0256+" "+STR0112,{'Ok'})
	lRet:= .F.
EndIf

If lRet .And. (aPARAM177[1] == 1 .And. aPARAM177[5] == 1 .And. aPARAM177[34] == 2)
    Aviso("MATA17710",STR0255+" "+STR0117+ " "+STR0256+" "+STR0113+" "+STR0264+" "+STR0263+" "+STR0265+" "+STR0262,{'Ok'})
	lRet:= .F.
EndIf

If lRet .And. (aPARAM177[20] == 1 .And. aPARAM177[05] == 1)
	MsgAlert( STR0196 ) //--"Nao sera possivel gerar os documentos de previsao de saida, pois nao foi definida uma filial centralizadora!"
	lRet := .F.
EndIf

If lRet .And. (aPARAM177[20] == 2 .And. Empty(cFilCent))
	Help( ' ', 1, 'MATA17703' )
	lRet:= .F.
EndIf

If lRet .And. (aPARAM177[1] == 2 .And. aPARAM177[5] == 2 .And. aPARAM177[34] == 2)
    Aviso("MATA17711",STR0260+" "+STR0117+ " "+STR0256+" "+STR0112+" "+STR0264+" "+STR0263+" "+STR0265+" "+STR0262,{'Ok'})
	lRet:= .F.
EndIf

If lRet .And. (aPARAM177[1] == 2 .And. aPARAM177[3] == 2)  
	Aviso("MATA17712",STR0257+" "+STR0111+" "+STR0258+" "+STR0112+" "+STR0264+" "+STR0263+" "+STR0265+" "+STR0262,{'Ok'})
	lRet:= .F.
EndIf

If lRet .And. (aPARAM177[1] == 2 .And. aPARAM177[2] == 1 .And. aPARAM177[34] == 2)
    Aviso("MATA17713",STR0260+" "+STR0114+ " "+STR0256+" "+STR0116+" "+STR0264+" "+STR0263+" "+STR0265+" "+STR0262,{'Ok'})
	lRet:= .F.
EndIf

If lRet .And. (aPARAM177[1] == 2 .And. aPARAM177[5] == 1 .And. aPARAM177[4] == 1 .And. aPARAM177[34] == 2)
    Aviso("MATA17714",STR0260+" "+STR0117+"/"+STR0114+ " "+STR0256+" "+STR0116+" "+STR0264+" "+STR0263+" "+STR0265+" "+STR0262,{'Ok'})
	lRet:= .F.
EndIf

nFilSel := aScan( aFiliais,{|x| x[2] == cFilCent })
If lRet .And. (aPARAM177[20] == 2 .And. (nFilSel <= 0))                 
	Help( ' ', 1, 'MATA17704',, STR0047 + cFilCent, 5, 11 )
	lRet:= .F.
EndIf

If lRet .And. !(Empty(aPARAM177[16]))
	dbSelectArea('AIE')
	dbSetOrder(1)
	If !(dbSeek( xFilial('AIE') + aPARAM177[16]))
		Help( ' ', 1, 'MATA17705',, STR0134 + ': ' + aPARAM177[16], 5, 11 )
		lRet := .F.
	Else
		If (Empty(AIE->AIE_CODFOR)) .And. aPARAM177[01] == 1
			Help( ' ', 1, 'MATA17707',, STR0134 + ': ' + aPARAM177[16], 5, 11)
			lRet := .F.
		EndIf
	EndIf
EndIf

If lRet .And. (aPARAM177[20] == 2)
	If aFiliais[nFilSel, 1] == .T.
		Help( ' ', 1, 'MATA17706',, STR0047 + aFiliais[nFilSel, 2], 5, 11 )
		lRet := .F.
	EndIf
EndIf

If lRet .And. (aPARAM177[06] == 4)
	dbSelectArea('SM4')
	dbSetOrder(1)
	If !(dbSeek(xFilial('SM4')+aPARAM177[07]))
		Help ( ' ', 1, 'MATA17708',, STR0122 + ': ' + aPARAM177[07], 5, 11)
		lRet := .F.
	EndIf
EndIf

If Len(aGruposSel) > 0 .And. lRet  
    aSelGrupos  := {}
    For nI := 1 to len(aGruposSel)
       If AllTrim(aGruposSel[nI]) == ""
		  AADD(aSelGrupos,"GRBRANCO")       
       Else
    	  AADD(aSelGrupos,"GR" + aGruposSel[nI] )
       EndIf	  
    Next nI
	
	cGruposUso  := ""
	For nI := 1 to Len(aSelGrupos)
		If LockByName(aSelGrupos[nI],.T.,.F.)	 // parametros -> arquivo, Empresa, Filial
		   lRet := .T.
		Else
		   cGruposUso += SubStr(aSelGrupos[nI], 3 ,len(aSelGrupos[nI])) + ","
		EndIf
	Next nI
	If !Empty(cGruposUso)
		cGruposUso := SubStr(cGruposUso,1,Len(cGruposUso) -1)
		lRet := .F.
	EndIf
EndIf	

If !lRet 
	If !Empty(cGruposUso) 
		//Aviso( "Grupos Em Uso" ,"Os Seguintes Grupos estão em uso por outro usuário: " + chr(13)+ chr(10) + cGruposUso + chr(13)+ chr(10) +  "Desmarque esses Itens para processar os Demais", {'OK'} ) //"A rotina está em uso por outra estação no momento. Aguarde a liberação da rotina para realização do processamento"
		MsgAlert(STR0253 + chr(13)+ chr(10) + cGruposUso + chr(13)+ chr(10) +  STR0254, {'OK'} )  //"Os seguintes Grupos de Produtos estao em processamento por outro usuario: " /  "Desmarque esses grupos para realizar o processamento da Central de Compras."
	EndIf
ElseIf (aPARAM177[17] == 2)
	cQuery := "SELECT AIA.AIA_CODTAB "
	cQuery +=  " FROM " + RetSQLTab('AIA')
	cQuery += " WHERE AIA.AIA_CODTAB = '" + aPARAM177[18] + "' "
	
	cAliasTmp := GetNextAlias()
	cQuery    := ChangeQuery(cQuery)
	dbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTmp, .T., .F. )
	If (cAliasTmp)->( Eof() )
		Help( ' ', 1, 'MATA17709',, STR0136 + ': ' + aPARAM177[18], 5, 11)
		lRet := .F.
	EndIf
	(cAliasTmp)->( DbCloseArea() )
EndIf

If lRet .AND. !Empty(aPARAM177[16])
	lRet := MsgYesNo( STR0073 + PadL( AllTrim(aPARAM177[16] ), Len(AIE->AIE_NUM), '0' ) + '. ' + STR0074 )	 //--"Sera obtido o calculo de numero "#"Confirma?"
EndIf

RestArea(aAreaAIE)
RestArea(aArea)
               
Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³AjustaHelp ³Autor ³Emerson Rony Oliveira ³ Data ³ 23/06/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Ajusta Help's da Rotina                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaHelp()
//-- Problemas
PutHelp( 'PMATA17701', {'Não foram encontradas necessidades com  ',;
                        'os parâmetros informados.               '},;
                       {'No needs with indicated parameters were ',;
                        'found.                                  '},;
                       {'No se encontraron necesidades con los   ',;
                        'parametros informados.                  '}, .T. )

PutHelp( 'PMATA17702', {'Para a opção de DISTRIBUIÇÃO, é         ',;
					    'necessário a seleção de uma filial      ',;
					    'centralizadora                          '},;
                       {'For option DISTRIBUTION, selecting a    ',;
                        'central branch is necessary.            '},;
					   {'Para la opcion de DISTRIBUCION, es      ',;
					    'necesaria la seleccion de una sucursal  ',;
                        'centralizadora.                         '}, .T. )

PutHelp( 'PMATA17703', {'A filial centralizadora não foi         ',;
						'informada.                              '},;
                       {'Central branch not indicated.           '},;
					   {'No se informo la sucursal               ',;
					    'centralizadora.                         '}, .T. )

PutHelp( 'PMATA17704', {'A filial centralizadora informada não   ',;
						'existe!                                 '},;
                       {'Central branch indicated does not exist.'},;
					   {'La sucursal centralizadora informada no ',;
					    'existe.                                 '}, .T. )

PutHelp( 'PMATA17705', {'O cálculo informado no paramêtro        ',;
						'"Número do Cálculo" não existe!         '},;
					   {'Calculation indicated in parameter      ',;
					    '"Number of Claculation" does not exist. '},;
					   {'El calculo informado en el parametro    ',;
					    '"Numero del Calculo" no existe.         '}, .T. )

PutHelp( 'PMATA17706', {'A Filial Centralizadora informada não   ',;
						'pode ser marcada para realização do     ',;
						'calculo das necessidades                '},;
                       {'Central branch indicated cannot be      ',;
                        'checked to make calculation of needs.   '},;
					   {'La sucursal centralizadora informada no ',;
					    'puede marcarse para realizacion del     ',;
					    'calculo de las necesidades.             '}, .T. )

PutHelp( 'PMATA17707', {'O cálculo informado não poderá ser      ',;
						'usado no processo selecionado.          '},;
                       {'Calculation indicated cannot be used in ',;
                        'the process selected.                   '},;
					   {'El calculo informado no podra utilizarse',;
					    ' en el proceso seleccionado.            '}, .T. )

PutHelp( 'PMATA17708', {'Código de fórmula inválido.             '},;
                       {'Invalid formula code.                   '},;
                       {'Codigo de formula invalido.             '}, .T. )

PutHelp( 'PMATA17709', {'Código de tabela de preços inválido.    '},;
                       {'Invalid price table code.               '},;
                       {'Codigo de lista de precios invalido.    '}, .T. )

PutHelp( 'PMATA17710', {'Não foi selecionada nenhuma filial para ',;
						'análise das necessidades.               '},;
                       {'No branch to analyze the needs was      ',;
                        'selected.                               '},;
					   {'No se selecciono ninguna sucursal para  ',;
					    'analisis de las necesidades.            '}, .T. )

PutHelp( 'PMATA17711', {'A edição das necessidades não foi       ',;
						'concluída.                              '},;
                       {'Issue of needs was not concluded.       '},;
                       {'La edicion de las necesidades no se     ',;
                        'concluyo.                               '}, .T. )
//-- Solucoes 
PutHelp( 'SMATA17701', {'Verifique:                              ',;
						'1) Parâmetros usados (intervalos De-Até)',;
						'2) Saldo em estoque do(s) produto(s)    ',;
						'3) Ponto de Pedido (se tipo cálculo = 3)',;
						'4) Fórmula própria (se tipo cálculo = 4)'},;
                       {'Check:                                  ',;
                        '1) Parameters used (intervals From-To)  ',;
                        '2) Product(s) stock balance             ',;
                        '3) Point of order (if calc. type = 3)   ',;
                        '4) Own formula (if calc. type = 4)      '},;
                       {'Verifique:                              ',;
                        '1) Parametros utilizados (interv. De A) ',;
                        '2) Saldo en stock de los productos      ',;
                        '3) Punto de Pedido (si fuera tipo = 3)  ',;
                        '4) Formula propia (si fuera tipo = 4)   '}, .T. )

PutHelp( 'SMATA17702', {'Selecione uma filial centralizadora     ',;
						'entre as filiais disponíveis antes de   ',;
						'prosseguir.                             '},;
                       {'Select a central branch among available ',;
                        'branches before continue.               '},;
					   {'Seleccione una sucursal centralizadora  ',;
					    'entre las disponibles antes de          ',;
					    'continuar.                              '}, .T. )

PutHelp( 'SMATA17703', {'Informe uma filial centralizadora.      '},;
                       {'Indicate a central branch.              '},;
                       {'Informe una sucursal centralizadora     '}, .T. )

PutHelp( 'SMATA17704', {'Digite uma filial centralizadora        ',;
						'válida antes de prosseguir.             '},;
                       {'Enter a valid central branch before     ',;
                        'continue.                               '},;
					   {'Digite una sucursal centralizadora      ',;
					    'valida antes de continuar.              '}, .T. )

PutHelp( 'SMATA17705', {'Digite um código de cálculo válido.     '},;
                       {'Enter a valid calculation code.         '},;
                       {'Digite un codigo de calculo valido.     '}, .T. )

PutHelp( 'SMATA17706', {'Desmarque a filial centralizadora da    ',;
						'caixa de seleção de filiais.            '},;
                       {'Uncheck central branch from branch      ',;
                        'checkbox.                               '},;
					   {'Desmarque la sucursal centralizadora de ',;
					    'la caja de seleccion de sucursales.     '}, .T. )

PutHelp( 'SMATA17707', {'Selecione o cálculo de acordo com o     ',;
						'processo informado.                     ',;
						'Os cálculos usados no processo de       ',;
						'"Distribuição" não podem ser usados no  ',;
						'processo de "Compras".                  '},;
                       {'Select calculation in accordance with   ',;
                        'process indicated. Calculations used in ',;
                        '"Distribution" process cannot be used in',;
                        ' "Purchase" process.                    '},;
					   {'Seleccione el calculo de acuerdo con el ',;
					    'proceso informado. Los calculos usados  ',;
					    'en el proceso de "Distribucion" no      ',;
					    'pueden utilizarse en el proceso de      ',;
					    '"Compras"                               '}, .T. )

PutHelp( 'SMATA17708', {'Digite um código de fórmula válido.     '},;
                       {'Enter a valid formula code.             '},;
                       {'Digite un codigo de formula valido.     '}, .T. )

PutHelp( 'SMATA17709', {'Digite um código de tabela de preços    ',;
						'válido.                                 '},;
                       {'Enter a valid price table code.         '},;
					   {'Digite un codigo de lista de precios    ',;
					    'valido.                                 '}, .T. )

PutHelp( 'SMATA17710', {'Selecione ao menos uma filial para      ',;
						'análise das necessidades.               '},;						 
                       {'Select at least one branch to analyze   ',;
                        'the needs.                              '},;
                       {'Seleccione por lo menos una sucursal    ',;
                        'para analisis de las necesidades.       '}, .T. )

PutHelp( 'SMATA17711', {'Finalize a edição das necessidades antes',;
						'de prosseguir.                          '},;
					   {'Finish issuing the needs before         ',;
					    'continue.                               '},;
					   {'Antes de proseguir, analice la edicion  ',;
					    'de las necesidades.                     '}, .T. )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSX1 ³ Autor ³ Emerson Rony Oliveira ³ Data ³23/06/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Montagem do grupo de perguntas                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void AjustaSx1(ExpC1)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Grupo de perguntas                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1( cPerg )
Local aArea    := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

dbSelectArea('SX1')
dbSetOrder(1)

//-- mv_par1 --
If dbSeek(PadR(cPerg, 10)+'01') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "01", STR0105, STR0105, STR0105, "MV_CH01", "C", 2, 0, 0, "C", "", "",,, "mv_par01", STR0106, STR0106, STR0106,, STR0107, STR0107, STR0107)//--"Gerar"#Compras"#"Distribuicao"
aHelpPor := {'Gera compras (reposição comprando ', 'materiais) ou distribuição (reposição ',;
             'considerando somente saldo em estoque ', 'da filial centralizadora). ',;
             'Não deve permitir selecionar a opção de ', 'distribuição sem que haja uma filial ',;
             'centralizadora.', 'Importante: Ao utilizar a opção ', '"Distribuição" é obrigatória a seleção ',;
             'da geração de documento de previsão de ', 'entrada (pergunta 3), previsão de saída ',;
             '(pergunta 5) ou ambos.', ''}
aHelpSpa := {'Genera compras (reposicion comprando ', 'materiales) o distribucion (reposicion ',;
             'considerando solamente saldo en stock ', 'de la sucursal centralizadora). ',;
             'No debe permitir seleccionar la opcion ', 'de distribucion sin que exista una ',;
             'sucursal centralizadora. Importante: Al ', 'utilizar la opcion "Distribucion", es ',;
             'obligatoria la seleccion de la ', 'generacion de documento de prevision de ',;
             'entrada (pregunta 3), prevision de ', 'salida (pregunta 5) o ambos.', ''}
aHelpEng := {'Purchase (replacement buying materials) ', 'or distribution (replacemente ',;
             'considering stock balance only in stock ', 'of central branch) is generated. ',;
             'Selecting the option Distribution ', 'without a central branch shall not be ',;
             'allowed. Important: By using the option ', 'Distribution, selecting generation of ',;
             'document of entry forecast (question 3),', ' exit forecast (question 5) or both is ',;
             'mandatory.', ''}
PutSX1Help("P."+cPerg+"01.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par2 --
If dbSeek(PadR(cPerg, 10)+'02') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "02", STR0108, STR0108, STR0108, "MV_CH02", "C", 2, 0, 0, "C", "", "",,, "mv_par02", STR0109, STR0109, STR0109,, STR0110, STR0110, STR0110)//"Tipo Documento"#"Solicit. compra"#"Pedido compra"
aHelpPor := {'Tipo de documento a ser gerado: ', 'Solicitação de Compras ou Pedido de ',;
             'Compras (quando a pergunta anterior for', '"Gera Compras"). Se a opção ',;
             'selecionada for "Pedido de Compras"', 'gera pedido para o primeiro fornecedor',;
             'encontrado na amarração de ', 'produto X fornecedor.', ''}
aHelpSpa := {'Tipo de documento que se generara: ', 'Solicitud de Compras o Pedido de ',;
             'Compras (cuando la pregunta anterior ', 'sea "Genera Compras"). Si la opcion ',;
             'seleccionada fuera "Pedido de Compras", ', 'generara pedido para el primer ',;
             'proveedor encontrado en el vinculo de ', 'producto vs. proveedor.', ''}
aHelpEng := {'Type of document to be generated: ', 'Purchase Requisition or Purchase Order ',;
             '(when previous question is "Purchase ', 'Generation"). If selected option is ',;
             '"Purchase Order", order will generated ', 'for the first supplier found in binding',;
             ' of product x supplier.', ''}
PutSX1Help("P."+cPerg+"02.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par3 --
If dbSeek(PadR(cPerg, 10)+'03') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "03", STR0111, STR0111, STR0111, "MV_CH03", "C", 2, 0, 0, "C", "", "",,, "mv_par03", STR0112, STR0112, STR0112,, STR0113, STR0113, STR0113)//--Doc Prev Entr na Origem#"SIM"#"NAO"
aHelpPor := {'Gera documento de previsão de entrada ', 'nas filiais que originaram as ',;
             'necessidades. ', 'Esta pergunta só deve ser considerada ',;
             'quando existir uma filial ', 'centralizadora.', ''}
aHelpSpa := {'Genera documento de prevision de ', 'entrada en las sucursales que ',;
             'originaron las necesidades. Esta ', 'pregunta solo debe considerarse cuando ',;
             'exista una sucursal centralizadora.', ''}
aHelpEng := {'Document of forecast of entry in ', 'branches that originated the demands is ',;
             'generated. This question shall be ', 'considered only when there is a central ',;
             'branch.', ''}
PutSX1Help("P."+cPerg+"03.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par4 --
If dbSeek(PadR(cPerg, 10)+'04') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "04", STR0114, STR0114, STR0114, "MV_CH04", "C", 2, 0, 0, "C", "", "",,, "mv_par04", STR0115, STR0115, STR0115,, STR0116, STR0116, STR0116)//--"Tipo Documento"#"Solicit. compra"#"Pedido compra"
aHelpPor := {'Tipo de documento a ser gerado: ', 'Solicitação de Compras ou Pedido de ',;
             'Compras (quando a pergunta anterior for ', 'Sim). Esta pergunta só deve ser ',;
             'considerada quando existir uma filial ', 'centralizadora.', ''}
aHelpSpa := {'Tipo de documento que se generara: ', 'Solicitud de Compras o Pedido de ',;
             'Compras (cuando la pregunta anterior ', 'sea Si). Esta pregunta solo debe ',;
             'considerarse cuando exista una sucursal ', 'centralizadora.', ''}
aHelpEng := {'Type of document to be generated: ', 'Purchase Requisition or Purchase Order ',;
             '(when previous question is Yes). This ', 'question shall be considered only when ',;
             'there is a central branch.', ''}
PutSX1Help("P."+cPerg+"04.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par5 --
If dbSeek(PadR(cPerg, 10)+'05') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "05", STR0117, STR0117, STR0117, "MV_CH05", "C", 2, 0, 0, "C", "", "",,, "mv_par05", STR0112, STR0112, STR0112,, STR0113, STR0113, STR0113)//--"Doc Prev Saida na Central"#
aHelpPor := {'Gera documento "Pedido de Venda" como', 'previsão de saída na filial',;
             'centralizadora. Esta pergunta só deve', ' ser considerada quando existir uma ',;
             'filial centralizadora.', ''}
aHelpSpa := {'Genera documento "Pedido de Venta" como', ' prevision de salida en la sucursal    ',;
             'centralizadora. Solo se debe tener en  ', 'cuenta esta pregunta cuando haya una   ',;
             'sucursal centralizadora.               ', ''}
aHelpEng := {'"Purchase Requisition" as forecast of ', 'exit in central branch is generated. ',;
             'This question shall be considered only ', 'when there is a central branch.', ''}
PutSX1Help("P."+cPerg+"05.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par6 --
If dbSeek(PadR(cPerg, 10)+'06') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "06", STR0137, STR0137, STR0137, "MV_CH06", "C", 2, 0, 0, "C", "", "",,, "mv_par06", STR0118, STR0118, STR0118,, STR0119, STR0119, STR0119, STR0120, STR0120, STR0120, STR0121, STR0121, STR0121)//--"Tipo Calc Necess"#"Tipo 1"#"Tipo 2"#"Tipo 3"#"Tipo 4"
aHelpPor := {'Tipo de calculo para necessidade:', 'Tipo 1: (Estoque Máximo - Estoque Atual)',;
             ' + (Média de vendas dos períodos X', ' Número de períodos para projeção)',;
             'Tipo 2: Estoque Máximo - Estoque Atual', 'Tipo 3: Ponto de Pedido (padrão rotina ',;
             'ponto de pedido)', 'Tipo 4: Fórmula própria', ''}
aHelpSpa := {'Tipo de calculo para necessidad: ', 'Tipo 1: (Stock Maximo - Stock Actual) + ',;
             '(Promedio de ventas de los periodos vs. ', 'Numero de periodos)',;
             'Tipo 2: Stock Maximo - Stock Actual', 'Tipo 3: Punto de Pedido (estandar ',;
             'rutina punto de pedido)', 'Tipo 4: Formula propia ', ''}
aHelpEng := {'Type of calculation for demand:', 'Type 1: (Maximum Stock - Current Stock) ',;
             '+ (Sales average of periods x Number of ', 'periods)',;
             'Type 2: Maximum Stock - Current Stock', 'Type 3: Point of Order (standard routine',;
             ' point of order)', 'Type 4: Own Formula', ''}
PutSX1Help("P."+cPerg+"06.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par7 --
If dbSeek(PadR(cPerg, 10)+'07') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "07", STR0122, STR0122, STR0122, "MV_CH07" , "C", TamSX3("M4_CODIGO")[1], 0, 0, "G", "", "SM4",,, "mv_par07")//--"Formula"
aHelpPor := {'Código da fórmula para cálculo (quando ', 'a pergunta anterior for selecionada ',;
             'como "Tipo 4").', ''}
aHelpSpa := {'Codigo de la formula para calculo ', '(cuando la pregunta anterior sea ',;
             'seleccionada como "Tipo 4").', ''}
aHelpEng := {'Code of formula for calculation (when ', 'previous question is selected as ',;
             '"Type 4").', ''}
PutSX1Help("P."+cPerg+"07.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par8 --
If dbSeek(PadR(cPerg, 10)+'08') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "08", STR0123, STR0123, STR0123, "MV_CH08" , "N", 3, 0, 0, "G", "", "",,, "mv_par08")//--"Numero periodos"
aHelpPor := {'Número de períodos de vendas para ', 'análise (quando a pergunta ',;
             '"Tipo Calc Necess" for selecionada como ', '"Tipo 1").', ''}
aHelpSpa := {'Numero de periodos de venta para ', 'analisis (cuando la pregunta "Tipo Calc ',;
             'Neces" sea seleccionada como "Tipo 1").', ''}
aHelpEng := {'Number of sales periods for analysis ', '(when the question "Demand Calc.Tp." is ',;
             'selected as "Type 1").', ''}
PutSX1Help("P."+cPerg+"08.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par9 --
If dbSeek(PadR(cPerg, 10)+'09') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "09", STR0124, STR0124, STR0124, "MV_CH09" , "C", 2, 0, 0, "C", "", "",,, "mv_par09", STR0125, STR0125, STR0125,, STR0126, STR0126, STR0126, STR0127, STR0127, STR0127)//--"Tipo Periodo"#"Dias"#"Semanas"#"Meses"
aHelpPor := {'Tipo de períodos para análise: ', '- Dias ', '- Semanas ou ', '- Meses', ''}
aHelpSpa := {'Tipo de periodos para analisis:', '- Dias ', '- Semanas o ', '- Meses', ''}
aHelpEng := {'Type of periods to analyze:', '- Days ', '- Weeks or ', '- Months ', ''}
PutSX1Help("P."+cPerg+"09.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par10 --
If dbSeek(PadR(cPerg, 10)+'10') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "10", STR0128, STR0128, STR0128, "MV_CH10" , "N", 3, 0, 0, "G", "", "",,, "mv_par10")//--"Periodos Projecao"
aHelpPor := {'Número de períodos para projeção ', '(quando a pergunta "Tipo Calc Necess"',;
             'for selecionada como "Tipo 1").', ''}
aHelpSpa := {'Numero de periodos para proyeccion ', '(cuando la pregunta "Tipo Calc Neces" ',;
             'sea seleccionada como "Tipo 1").', ''}
aHelpEng := {'Number of periods for projection (when ', 'the question "Demand Calc.Tp." is ',;
             'selected as "Type 1").', ''}
PutSX1Help("P."+cPerg+"10.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par11 --
If dbSeek(PadR(cPerg, 10)+'11') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "11", STR0129, STR0129, STR0129, "MV_CH11" , "C", TamSX3("B1_LOCPAD")[1], 0, 0, "G", "", "",,, "mv_par11")//--"Armazem De"
aHelpPor := {'Valor inicial da faixa de armazéns a ', 'serem considerados para cálculo do ',;
             'estoque disponível.', ''}
aHelpSpa := {'Valor inicial del intervalo de ', 'almacenes que se considerara para ',;
             'calculo del stock disponible.', ''}
aHelpEng := {'Initial value of warehouse range to be ', 'considered for calculation of stock ',;
             'available.', ''}
PutSX1Help("P."+cPerg+"11.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par12 --
If dbSeek(PadR(cPerg, 10)+'12') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "12", STR0130, STR0130, STR0130, "MV_CH12" , "C", TamSX3("B1_LOCPAD")[1], 0, 0, "G", "", "",,, "mv_par12")//--"Armazem Ate"
aHelpPor := {'Valor final da faixa de armazéns a ', 'serem considerados para calculo do ',;
             'estoque disponível.', ''}
aHelpSpa := {'Valor final del intervalo de almacenes ', 'que se consideraran para calculo del ',;
             'stock disponible.', ''}
aHelpEng := {'Final value of warehouse range to be ', 'considered for calculation of stock ',;
             'available.', ''}
PutSX1Help("P."+cPerg+"12.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par13 --
If dbSeek(PadR(cPerg, 10)+'13') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "13", STR0131, STR0131, STR0131, "MV_CH13" , "C", 2, 0, 0, "C", "", "",,, "mv_par13", STR0112, STR0112, STR0112,, STR0113, STR0113, STR0113)//--"Amarracao Prod X Forn"#"SIM"#"NAO"
aHelpPor := {'Filtra produtos pela amarração Produto ', 'X Fornecedor. Caso a opção seja NÃO, ',;
             'será utilizado o fornecedor associado ', 'ao produto.', ''}
aHelpSpa := {'Filtra productos por vinculacion entre  ', 'producto y proveedor. Si la opcion es NO',;
             ', se utiliza el proveedor asociado al   ', 'producto.                               ', ''}
aHelpEng := {'Products filtered by binding product x ', 'supplier. If the option is NO, supplier ',;
             'associated with the product will be ', 'used.', ''}
PutSX1Help("P."+cPerg+"13.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par14 --
If dbSeek(PadR(cPerg, 10)+'14') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "14", STR0132, STR0132, STR0132, "MV_CH14" , "C", TamSX3("A2_COD")[1], 0, 0, "G", "", "SA2",,, "mv_par14")//--"Fornecedor De"
aHelpPor := {'Valor inicial da faixa de fornecedores ', 'a serem considerados para seleção de ',;
             'produtos. ', ''}
aHelpSpa := {'Valor inicial del rango de proveedores ', 'por considerar para seleccion de ',;
             'productos.', ''}
aHelpEng := {'Initial value of supplier range to be ', 'considered for product selection.', ''}
PutSX1Help("P."+cPerg+"14.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par15 --
If dbSeek(PadR(cPerg, 10)+'15') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "15", STR0133, STR0133, STR0133, "MV_CH15" , "C", TamSX3("A2_COD")[1], 0, 0, "G", "", "SA2",,, "mv_par15")//--"Fornecedor Ate"
aHelpPor := {'Valor final da faixa de fornecedores ', 'a serem considerados para seleção de ',;
             'produtos.', ''}
aHelpSpa := {'Valor final del rango de proveedores ', 'que se utilizaran para la seleccion  ',;
             'de productos.                        ', ''}
aHelpEng := {'Final value of supplier range to be ', 'considered for product selection.', ''}
PutSX1Help("P."+cPerg+"15.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par16 --
If dbSeek(PadR(cPerg, 10)+'16') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "16", STR0134, STR0134, STR0134, "MV_CH16" , "C", TamSX3("AIE_NUM")[1], 0, 0, "G", "", "AIE",,, "mv_par16")//--"Numero do Calculo"
aHelpPor := {'Número do cálculo a ser considerado.', 'Quando preenchido lê e apresenta as ',;
             'informações de um cálculo já realizado ', 'e não efetua nenhum cálculo novo.', ''}             
aHelpSpa := {'Numero del calculo que se considerara. ', 'Al rellenarlo lee y muestra las ',;
             'informaciones de un calculo realizado y ', 'no efectua ningun calculo nuevo.', ''}
aHelpEng := {'Number of calculation to be considered. ', 'When filled, information of a ',;
             'calculation already made is diplayed and', ' no new calculation is made.', ''}
PutSX1Help("P."+cPerg+"16.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par17 --
If dbSeek(PadR(cPerg, 10)+'17') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "17", STR0135, STR0135, STR0135, "MV_CH17" , "C", 2, 0, 0, "C", "", "",,, "mv_par17", STR0118, STR0118, STR0118,, STR0119, STR0119, STR0119, STR0120, STR0120, STR0120)//--"Preco para Compra"#"Tipo 1#"Tipo 2#"Tipo 3
aHelpPor := {'Preço para compra dos produtos. Quando ', 'as perguntas 2 ou 4 "Tipo de Documento"',;
             'estiverem selecionadas com a opção ', '"Pedido de Compra", será usado um dos  ',;
             'tipos de preço abaixo: ', 'Tipo 1: Último preço de compra',;
             'Tipo 2: Tabela de preços informada', 'Tipo 3: Custo standard', ''}
aHelpSpa := {'Precio para compra. Si la pregunta ', '"Generar" estuviera seleccionada con la ',;
             'opcion "Genera Compras" y la pregunta ', '"Tipo Documento" estuviera seleccionada ',;
             'con la opcion "Pedido de Compras", debe ', 'permitir seleccionar uno de los ',;
             'siguientes tipos de precio: ', 'Tipo 1: Ultimo precio de compras',;
             'Tipo 2: Lista de precio informada', 'Tipo 3: Costo estandar', ''}
aHelpEng := {'Purchase price. When the question ', '"Generate" is selected  with the option ',;
             '"Generate Purchase" and the question ', '"Document Type" is selected with the ',;
             'option "Purchase Order," selecting one ', 'of price types below shall be allowed:',;
             'Type 1: Last purchase price ', 'Type 2: Price table indicated ',;
             'Type 3: Standard cost ', ''}
PutSX1Help("P."+cPerg+"17.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par18 --
dbSelectArea('SX1')
dbSetOrder(1)
If dbSeek(PadR(cPerg, 10)+'18') .And. ( !(RTrim(SX1->X1_F3) == 'AIA') .Or. Empty(Trim(SX1->X1_PERSPA)) )
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "18", STR0136, STR0136, STR0136, "MV_CH18" , "C", TamSX3("AIA_CODTAB")[1], 0, 0, "G", "", "AIA",,, "mv_par18")//--"Cod Tabela Preco"
aHelpPor := {'Código da tabela de preço (quando a ', 'pergunta "Preco para Compra" estiver ',;
             'selecionada com "Tipo 2").', ''}
aHelpSpa := {'Codigo de la lista de precio (si la ', 'pregunta "Precio para Compra" estuviera ',;
             'seleccionada con "Tipo 2").', ''}
aHelpEng := {'Price table code (when the question ', '"Purchase Price" is selected with ',;
             '"Type 2"). ', ''}
PutSX1Help("P."+cPerg+"18.",aHelpPor,aHelpEng,aHelpSpa)


//-- mv_par19 -- 
If dbSeek(PadR(cPerg, 10)+'19') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1(cPerg,"19",STR0267,STR0267,STR0267,"MV_CH19","D",8,0,0,"G","","",,,"MV_PAR19",,,,,,,,,,,,,,,,,,,,) 					 		//--"Data de: "
aHelpPor := {'Data inicial para o cálculo'  , 'das necessidades', ''}
aHelpSpa := {'Fecha inicial para el calculo', 'de las necesidades',''}
aHelpEng := {'Initial date for calculation ', 'of the needs'}
PutSX1Help("P.MTA17719.",aHelpPor,aHelpEng,aHelpSpa,.T.)


//-- mv_par20 -- 
If dbSeek(PadR(cPerg, 10)+'20') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()
		msUnLock()
	EndIf
EndIf
PutSx1(cPerg,"20",STR0268,STR0268,STR0268,"MV_CH20","D",8,0,0,"G","","",,,"MV_PAR20",,,,,,,,,,,,,,,,,,,,)					 			//Data ate
aHelpPor := {'Data final para o cálculo'  , 'das necessidades', ''}
aHelpSpa := {'Fecha final para el calculo', 'de las necesidades',''}
aHelpEng := {'Final date for calculation' , 'of the needs',''}
PutSX1Help("P.MTA17720.",aHelpPor,aHelpEng,aHelpSpa,.T.)               

//-- mv_par21 --EXISTCPO()  
If dbSeek(PadR(cPerg, 10)+'21')  .And. Empty(Trim(SX1->X1_PERSPA)) 
   If RecLock('SX1',.F.)
  		dbDelete()
   		msUnLock()
   	EndIf
EndIf
PutSx1( cPerg, "21", STR0213, STR0213, STR0213, "MV_CH21", "C", 2, 0, 0, "C", "", "",,, "mv_par21", STR0214, STR0214, STR0214,, STR0215, STR0215, STR0215) //--"Preco para Pedido de Venda"
aHelpPor := {'Campo de preço para a utlização para a ','geração de pedido de venda Utilize os', ;
   	         'seguintes campos B1_PRV1 ou B2_CM1.', ''}  
aHelpSpa := {'Campo de precios para utilizar en la','generacion del pedido de venta Utilice los',;
             'siguientes campos B1_PRV1 o B2_CM1.', ''}  
aHelpEng := {'Price field to use for generation of','sales order Use the following fields ',;
             'B1_PRV1 or B2_CM1.', ''}  
PutSX1Help("P."+cPerg+"21.",aHelpPor,aHelpEng,aHelpSpa,.T.)

//-- mv_par22 -- 
If dbSeek(PadR(cPerg, 10)+'22') .And. Empty(Trim(SX1->X1_PERSPA))
	If RecLock('SX1',.F.)
		dbDelete()             
		msUnLock()
	EndIf
EndIf
PutSx1( cPerg, "22", STR0263, STR0263, STR0263, "MV_CH22", "C", 2, 0, 0, "C", "", "",,, "mv_par22", STR0261, STR0261, STR0261,, STR0262, STR0262, STR0262) //--Tipo de Tratamento
aHelpPor := {'Campo utilizado para definir como ','será o processo de Análise.','', ;
   	         'Sem Aglutinação: Não irá trabalhar com a','Tabela de Previsão de Entrada permitindo','gerar Análises distribuidas em relação','as Filiais','',;
   	         'Com Aglutinação: Irá trabalhar com a','Tabela de Previsão de Entrada fazendo','análise centralizada em relação as',;
   	         'Filiais e controles posteriores','relacionados aos documentos gerados','',;
   	         'Para este tipo de análise, será','necessário executar o programa','de Aglutinação de Pedidos após',;
   	         'gerar a Análise de Compras',''}
   	         
aHelpSpa := {'Campo utilizado para definir como','sera el proceso de Analisis.','',;
			 'Sin Agrupacion: No trabajara con la','Tabla de Prevision de Entrada permitiendo','generar Analisis distribuidas en relacion','a las Sucursales','',;
			 'Con Agrupacion: Trabajara con la','Tabla de Prevision de Entrada haciendo','analisis centralizado en relacion a las',;
			 'Sucursales y controles posteriores','relacionados a los documentos generados','',;
			 'Para este tipo de analisis, sera','necesario ejecutar el programa','de Agrupacion de Pedidos tras','',;
			 'generar el Analisis de Compras'}
aHelpEng := {'Field used to establish how Analysis Process is ','performed.','',;
			 'Without Grouping: It does not work',' with the table of Delivery Provision which',' enables the generation of Analysis ','distributed among the Branches','',;    
			 'With Grouping: Works with the table','of Delivery Provision performing a ','centralized analysis among all branches','and also controls of generated documents','',;
			 'For this type of analysis, it ',     ' is necessary to run the program  ',' of Orders Grouping after generating ',' Purchases Analysis'}
PutSX1Help("P."+cPerg+"22.",aHelpPor,aHelpEng,aHelpSpa,.T.)

RestArea(aAreaSX1)
RestArea(aArea)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSXB  ³ Autor ³ Emerson Rony Oliveira³ Data ³23/06/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajustar dicionario de dados "SXB"                           ³±±
±±³          ³Contem nomes de campos inexistentes na consulta padrao "AIE"³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSXB()
Local aArea     := GetArea()
Local aAreaSXB  := SXB->(GetArea())
Local cFilAIEF3 := '(MV_PAR01 == 1 .AND. !Empty(AIE->AIE_CODFOR)) .OR. (MV_PAR01 == 2 .AND. Empty(AIE->AIE_CODFOR))'
Local nTamSXB   := Len(SXB->XB_ALIAS)

dbSelectArea('SXB')
dbSetOrder(1)
If dbSeek(PadR('AIE', nTamSXB)+'40105') .And. !(RTrim(SXB->XB_CONTEM) == 'AIE_CODPRO')
	RecLock('SXB', .F.)
	SXB->XB_DESCRI  := 'Produto'
	SXB->XB_DESCSPA := 'Producto'
	SXB->XB_DESCENG := 'Product'
	SXB->XB_CONTEM  := 'AIE_CODPRO'
	MsUnlock()
Endif

If dbSeek(PadR('AIE', nTamSXB)+'40106') .And. !(RTrim(SXB->XB_CONTEM) == 'AIE_DTCALC')
	RecLock('SXB', .F.)
	SXB->XB_DESCRI  := 'Dt. Calculo'
	SXB->XB_DESCSPA := 'Fch Calculo'
	SXB->XB_DESCENG := 'Calc. Date'
	SXB->XB_CONTEM  := 'AIE_DTCALC'
	MsUnlock()
Endif

If !(dbSeek(PadR('AIE', nTamSXB)+'601  '))
  RecLock('SXB', .T.)
  SXB->XB_ALIAS   := 'AIE'
  SXB->XB_TIPO    := '6'
  SXB->XB_SEQ     := '01'
  SXB->XB_CONTEM  := cFilAIEF3
  MsUnLock()
EndIf

RestArea(aAreaSXB)
RestArea(aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A177Media    ³ Autor ³ Vendas Clientes       ³ Data ³12/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Query auxiliar para calcular a media de vendas             	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                       				                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD1 - Data inicial                                        	 ³±±
±±³          ³ExpD2 - Data final                                          	 ³±±
±±³          ³ExpC3 - Expressao                                           	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                  	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A177Media(dDtIni, dDtFim)
Local cQuery   := ""		//Retorno da funcao
Local cFilSF4  := ""		//Expressao para filtro
Local cDivisao := ""		//Divisor 	

If Empty(xFilial('SF4'))
	cFilSF4 := 'SF4.F4_FILIAL'
Else 
	cFilSF4 := 'SB2.B2_FILIAL'
Endif

If lTPLDRO
	cDivisao := AllTrim(Str(dDtFim - dDtIni))
Else
	cDivisao := AllTrim( Str(aPARAM177[08]) )
Endif

cQuery +=     "   SELECT (SUM(SD2.D2_QUANT) / " + cDivisao + ") "
cQuery +=                   " FROM " + RetSQLTab('SD2') 
cQuery +=                      " , " + RetSQLTab('SF4')
cQuery +=                  " WHERE SD2.D2_FILIAL        = SB2.B2_FILIAL "
cQuery +=                    " AND SD2.D2_COD           = SB2.B2_COD "
cQuery +=                    " AND SD2.D2_TIPO          = 'N' "
cQuery +=                    " AND SD2.D2_EMISSAO BETWEEN '" + DtoS( dDtIni ) + "' AND '" + DtoS( dDtFim ) + "' "
cQuery +=                    " AND SD2.D_E_L_E_T_       = ' ' "
cQuery +=                    " AND SF4.F4_FILIAL        = " + cFilSF4 + " "
cQuery +=                    " AND SF4.F4_CODIGO        = SD2.D2_TES "
cQuery +=                    " AND SF4.F4_ESTOQUE       = 'S' "
cQuery +=                    " AND SF4.D_E_L_E_T_       = ' ' "
cQuery +=                  " GROUP BY 	SD2.D2_FILIAL, "
cQuery +=                  "   			SD2.D2_COD "

Return  (cQuery)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A177AtuCabec ³ Autor ³ Vendas Cliente        ³ Data ³12/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza os campos do cabecalho da tela de pre - pedido    	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                       				                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                  	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A177AtuCabec( 	oGetMinCusto   , nMinCusto   , oGetDtMinCus  , dDtMinCusto,;
						oGetMaxCusto   , nMaxCusto   , oGetDtMaxCus  , dDtMaxCusto,;
						oGetUltPrVenda , nUltPrVenda , oGetUltDtVenda, dUltDtVenda,;
						oGetCodProd    , cCodProd    , oGetNomeFabr  , cNomeFabr  ,;
						oGetUnidProd   , cUnidProd   , oGetMesAtu    , nMesAtu    ,;
						oGetMinCusto   , nMinCusto   , oGetMesAnt    , nMesAnt    ,;
						oGetMedMes     , nMedMes     , oGetEstAtu    , nEstAtu    ,;
						oGetMedatraso  , nMedatraso  , oGetUltCompra , nUltCompra ,;
						oGetDtUltCompra, dDtUltCompra, nLinhaAtual   , aItens)  



Local lExistRegistro := .F.		//Verifica se existe o registro
Local oInfoPed 		 := NIL    	//Objeto referente a informacoes do pedido 



If oDadosPed:Contains(aItens[nLinhaAtual][1]+aItens[nLinhaAtual][3])
	lExistRegistro := .T.
Endif

If lExistRegistro
	oInfoPed := oDadosPed:ElementKey(aItens[nLinhaAtual][1]+aItens[nLinhaAtual][3])

	nMinCusto := oInfoPed:nMinCusto
	oGetMinCusto:REFRESH()
	
	dDtMinCusto := oInfoPed:dDtMinCusto
	oGetDtMinCus:REFRESH()  

	nMaxCusto := oInfoPed:nMaxCusto
	oGetMaxCusto:REFRESH()
	
	dDtMaxCusto := oInfoPed:dDtMaxCusto
	oGetDtMaxCus:REFRESH()

	cNomeFabr := oInfoPed:cNomeFabr
	oGetNomeFabr:REFRESH()  
	
	nMedatraso := oInfoPed:nMediaAtraso
	oGetMedatraso:REFRESH()
		
	nUltCompra := oInfoPed:nUltCompra
	oGetUltCompra:REFRESH()
	
	dDtUltCompra := oInfoPed:dDtUltCompra
	oGetDtUltCompra:REFRESH()
	
	nUltPrVenda := oInfoPed:nUltPrVenda
	oGetUltPrVenda:REFRESH()
	
	dUltDtVenda := oInfoPed:dUltDtVenda
	oGetUltDtVenda:REFRESH()
	
	cCodProd  := oInfoPed:cCodProd
	oGetCodProd:REFRESH()
	
	cUnidProd  := oInfoPed:cUnidProd
	oGetUnidProd:REFRESH()
	
	nMesAtu  := oInfoPed:nVMesAtual
	oGetMesAtu:REFRESH()

	nMesAnt  := oInfoPed:nVMesAnterior
	oGetMesAnt:REFRESH() 
	
	nMedMes  := oInfoPed:nMediaMes
	oGetMedMes:REFRESH()
	
	nEstAtu  := oInfoPed:nEstoqueAtual		
	oGetEstAtu:REFRESH()
Endif	

Return 	  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A177UnLockGr ³ Autor ³ Vendas Cliente        ³ Data ³12/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Desbloqueia o Grupos que foram usados para Gerar necessidades ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                       				                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aSelGrupos  Array com os Grupos usados.                     	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                  	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function A177UnLockGr(aSelGrupos)
Local nI := 0 // variavel para controlar o for

For nI:= 1 to Len(aSelGrupos)
	UnLockByName(aSelGrupos[nI],.T.,.F. )
Next nI 
aSelGrupos := {}
Return()  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a177ResBlock | Autor ³ Julio Cesar Guerato   ³ Data ³02/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o Aheader e o Aitem posicionado no TwBrowse           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                       				                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Objeto 								                    	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                  	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a177ResBlock(oObj)
Local nPos:= oObj:nAt
Local aRet:={}

If nPos>0
    aRet:={oObj:aHeaders,oObj:aArray[oObj:nAt]}
EndIf

return (aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a177MdAccess | Autor ³ Aecio Ferreira Gomes  ³ Data ³22/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida existencia de compartilhamento no Alias	             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                       				                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1:= Alias 												 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA177()                                                  	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a177MdAccess(cAlias)
Local lRet:= .f.

//Retorna verdadeiro caso Empresa ou Unidade de Negocio ou Filial esteja com compartilhamento.
Do Case
Case FWModeAccess(cAlias,1) == "C" .And. cVersao <> "P10"
	lRet:= .T.	
Case FWModeAccess(cAlias,2) == "C" .And. cVersao <> "P10"
    lRet:= .T.
Case FWModeAccess(cAlias) == "C"
    lRet:= .T.
EndCase

Return(lRet)
