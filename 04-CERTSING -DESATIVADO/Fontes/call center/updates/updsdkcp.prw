#include "PROTHEUS.CH"

#DEFINE DEF_X3USADO 	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
			   			Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
						Chr(128) + Chr(128) + Chr(128) + Chr(128)

#DEFINE DEF_X3RESERV	Chr(254) + Chr(192)

/*
---------------------------------------------------------------------------
| Rotina    | UPDSDKCP    | Autor | Gustavo Prudente | Data | 16.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para utilizacao nas rotinas customizadas    |
|           | do modulo Service-Desk, sem necessidade de acesso exclusivo |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function UPDSDKCP

Local oMsgInfo
Local oSayMsg1, oEmpFil, oChkEmpFil
Local oBtnSair, oBtnSalvar, oBtnProc
Local oPanelTop, oPEmpFil, oPanelBtn

Local oOk		:= LoadBitMaps( Nil, "BR_VERDE_MDI" )
Local oNo		:= LoadBitMaps( Nil, "BR_VERMELHO_MDI" )
Local oFont		:= TFont():New( "Consolas",, -11 )

Local lEmpFil	:= .T.
Local lOpen		:= .T.

Local aEmpFil 	:= { { oOk, "", "", "", "" } }
Local aMsgList	:= { "Atualização de Dicionário de Dados - Modo compartilhado" }

Private oMainWnd                          

// Abre conexao com a empresa 01 e filial 02
RpcSetType( 3 )
//RpcSetEnv( "99", "01" )
RpcSetEnv( "01", "02" )

// Monta tela de processamento do update
oMainWnd := MSDialog():New( 100, 100, 600, 800, "Certisign - Atualização de Dicionário de Dados",,,,, CLR_BLACK,,,,.T. )

oPanelTop		:= tPanel():New( 01, 01, "", oMainWnd,,.T.,,CLR_BLACK,, 1, 15, .F., .T. )
oPanelTop:Align := CONTROL_ALIGN_TOP  

oPEmpFil 		:= tPanel():New( 01, 01, "", oMainWnd,,.T.,,CLR_BLACK,, 1, 110, .F., .T. )
oPEmpFil:Align 	:= CONTROL_ALIGN_TOP  

oPanelBtn		:= tPanel():New( 01, 01, "", oMainWnd,,.T.,,CLR_BLACK,, 1, 13, .F., .T. )
oPanelBtn:Align := CONTROL_ALIGN_BOTTOM

oPanelL01		:= tPanel():New( 01, 01, "", oMainWnd,,.T.,,CLR_BLACK,, 1, 01, .F., .F. )
oPanelL01:Align := CONTROL_ALIGN_BOTTOM

oSayMsg1 := tSay():New( 04, 02, { || "Realizar alterações no dicionario de dados, que não exigem acesso exclusivo, nas empresas e filiais selecionadas." }, ;
						oPanelTop,,oFont,,,, .T.,,, 400, 18 )
										
@ 001, 001 LISTBOX oEmpFil FIELDS HEADER " ", "Empresa", "Filial", "Nome", "Nome Filial" SIZE 250,90 FONT oFont OF oPEmpFil PIXEL
                                         
aEmpFil := USDKRetSM0( oOk )

oEmpFil:SetArray( aEmpFil )
oEmpFil:bLine := { || { aEmpFil[ oEmpFil:nAt, 1 ], aEmpFil[ oEmpFil:nAt, 2 ], aEmpFil[ oEmpFil:nAt, 3 ], aEmpFil[ oEmpFil:nAt, 4 ], aEmpFil[ oEmpFil:nAt, 5 ] } }
oEmpFil:Align := CONTROL_ALIGN_ALLCLIENT
oEmpFil:bLDblClick := { || USDKMark( oOk, oNo, aEmpFil, oEmpFil ) }
oEmpFil:SetCss("QPushButton{}")                             

@ 095, 00 CHECKBOX oChkEmpFil VAR lEmpFil PROMPT 'Marcar/Desmarcar Todas as Filiais' FONT oFont PIXEL OF oPEmpFil SIZE 110, 50 ;
			MESSAGE 'Marcar ou desmarcar todas as empresas e filiais' ON CLICK USDKInv( oOk, oNo, @aEmpFil, oEmpFil, lEmpFil )

oChkEmpFil:SetCss("QPushButton{}")
oChkEmpFil:Align := CONTROL_ALIGN_BOTTOM 

@ 001, 001 LISTBOX oMsgInfo FIELDS HEADER "" SIZE 100,100 FONT oFont OF oMainWnd PIXEL
                  
oMsgInfo:SetArray( aMsgList )                      
oMsgInfo:bLine := { || { aMsgList[ oMsgInfo:nAt ] } }
oMsgInfo:Align := CONTROL_ALIGN_ALLCLIENT                      
oMsgInfo:lUseDefaultColors := .F.
oMsgInfo:SetCss("QPushButton{}")
oMsgInfo:lHScroll := .F.
oMsgInfo:lVScroll := .T.         
oMsgInfo:lHitBottom := .T.

oBtnSair := TButton():New( 0, 0, "Sair", oPanelBtn, { || oMainWnd:End() },40, 013,,oFont,,.T.,,"",,,,.F. )
oBtnSair:Align := CONTROL_ALIGN_RIGHT                                                                      
oBtnSair:SetCSS("QPushButton{}")

oBtnProc := TButton():New( 0, 0, "Processar", oPanelBtn, { || USDKProc( oOk, oMsgInfo, @aMsgList, aEmpFil ) }, 40, 013,,oFont,,.T.,,"",,,,.F. )
oBtnProc:Align := CONTROL_ALIGN_RIGHT
oBtnProc:SetCSS("QPushButton{}")

oBtnSalvar	:= TButton():New( 0, 0, "Salvar", oPanelBtn, { || USDKLog( aMsgList ) }, 40, 013,,oFont,,.T.,,"",,,,.F. )
oBtnSalvar:Align := CONTROL_ALIGN_RIGHT
oBtnSalvar:SetCSS("QPushButton{}")

oMainWnd:lCentered := .T.
oMainWnd:Activate()

Return( .T. )


/*
---------------------------------------------------------------------------
| Rotina    | USDKProc    | Autor | Gustavo Prudente | Data | 16.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para utilizacao nas rotinas customizadas    |
|           | do módulo Service-Desk, sem necessidade de acesso exclusivo |
|-------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de selecao confirmada (Marcado)              |
|           | do módulo Service-Desk, sem necessidade de acesso exclusivo |
|           | EXPO2 - Objeto da mensagem a ser exibida no listbox         |
|           | EXPA3 - Vetor com a lista de mensagens                      |
|           | EXPA4 - Vetor com a lista de empresas e filiai selecionadas |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function USDKProc( oOk, oMsgInfo, aMsgList, aEmpFil )

Local nX 		:= 0 
Local nY 		:= 0  

Local cCodEmp 	:= ""
Local cCodFil 	:= ""
Local cMsgEmp 	:= ""                    

AtuMsg( "Inicio do processamento - " + DtoC( Date() ) + " - " + Time(), oMsgInfo, @aMsgList, .T., .T. )

For nX := 1 To Len( aEmpFil )

	// Somente processa se foi selecionado e se modificou a empresa
	If aEmpFil[ nX, 1 ] == oOk .And. cCodEmp <> aEmpFil[ nX, 2 ]
                                                
		//
		// Altera a empresa e filial de acordo com o que foi selecionado para processamento
		//
		cCodEmp := aEmpFil[ nX, 2 ]
		cCodFil := aEmpFil[ nX, 3 ]
		
		cMsgEmp := "[Empresa: " + cCodEmp + "0] "

		AtuMsg( cMsgEmp + "Selecionando dicionario ...", oMsgInfo, @aMsgList, .T., .T. )
		
		CursorWait()
				
		// Abre conexao com a empresa e filial
		RpcClearEnv()
		RpcSetType( 3 ) 
		RpcSetEnv( cCodEmp, cCodFil )    			
			                                    
		// Posiciona SM0
		SM0->( DbSetOrder( 1 ) )
		SM0->( DbSeek( cCodEmp + cCodFil ) )
	    
		CursorArrow()
		
		// 
		// Atualiza dicionario SX3
		//
		AtuMsg( cMsgEmp + "Processando atualizações no SX3 ...", oMsgInfo, @aMsgList, .T., .T. )
	
        USDKAtuSX3( oMsgInfo, @aMsgList, cMsgEmp )

		// 
		// Atualiza dicionario SXB
		//
		AtuMsg( cMsgEmp + "Processando atualizações no SXB ...", oMsgInfo, @aMsgList, .T., .T. )
        
		USDKAtuSXB( oMsgInfo, @aMsgList, cMsgEmp )
		        
	EndIf

Next nX

AtuMsg( "Processamento finalizado com sucesso!", oMsgInfo, @aMsgList, .T., .T. )

Return( .T. )


/*
---------------------------------------------------------------------------
| Rotina    | USDKAtuSX3  | Autor | Gustavo Prudente | Data | 18.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Logica para atualizacao do dicionario de campos (SX3)       |
|-------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto da mensagem a ser exibida no listbox         |
|           | EXPA2 - Vetor com a lista de mensagens                      |
|           | EXPC3 - String com a mensagem de empresa e filial           |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function USDKAtuSX3( oMsgInfo, aMsgList, cMsgEmp )

Local aEstrut   := {}
Local aSX3      := {}
Local aArqUpd	:= {}
Local aArea		:= GetArea()
Local nX		:= 0
Local nI        := 0
Local nJ        := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local cAliasAtu := ""
Local cSeqAtu   := ""                               
Local cCpoSX3	:= ""

Local aEstrut	:= {  { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, ;
					  { "X3_TITULO" , 0 }, { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, ;
					  { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, ;
					  { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, ;
					  { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, ;
					  { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, { "X3_PYME"   , 0 }, ;
					  { "X3_AGRUP"  , 0 } }

Local aSX3Alt	:= {  { "ADE_PEDGAR", "X3_VALID"	, "u_CTSDK05(M->ADE_PEDGAR,.F.)" }, ;	// Totalizacao de atendimentos por pedido GAR
					  { "ADE_XPSITE", "X3_VALID"	, "u_CTSDK20( M->ADE_XPSITE )"	 }, ;	// Totalizacao de atendimentos por pedido Site
					  { "ADF_CODSU9", "X3_VLDUSER"	, 'u_CTSDK23() .And. Iif(SU9->U9_XEXECAM == "1",U_CTSDK19(),.T.)' }, ;	// Total de atendimentos por pedido x campanha
					  { "ADE_XTOTAT", "X3_RELACAO"  , '"0"' 						 }, ;
					  { "ADF_CODSU9", "X3_F3"       , "XCSOCO"						 }, ;	// Correcao no X3_RELACAO do campo ADE_XTOTAT
					  { "ADE_EMAIL" , "X3_VALID"	, "U_Valida_Email()"			 }, ;	// Adiciona rotina de validacao do e-mail do remetente
					  { "ADE_TO"	, "X3_VALID"	, "U_Valida_Email()"			 }, ;	// Adiciona rotina de validacao do e-mail do destinatario
					  { "ADE_CC"	, "X3_VALID"	, "U_Valida_Email()"			 }, ;	// Adiciona rotina de validacao do e-mail com copia
					  { "ADE_CCO"	, "X3_VALID"	, "U_Valida_Email()"			 }  }	// Adiciona rotina de validacao do e-mail com copia oculta

aSX3Inc	:= {  { "ADE"					, ; // X3_ARQUIVO
			    "12"					, ; // X3_ORDEM
				"ADE_XTOTAT"			, ; // X3_CAMPO
				"C"						, ; // X3_TIPO
				6  						, ; // X3_TAMANHO
				0						, ; // X3_DECIMAL
			    "Total Atend."			, ; // X3_TITULO
			    "Total Atend."			, ; // X3_TITSPA
				"Total Atend."			, ; // X3_TITENG
				"Total Atendimentos"	, ; // X3_DESCRIC
				"Total Atendimentos"	, ; // X3_DESCSPA
				"Total Atendimentos"	, ; // X3_DESCENG
				"999999"				, ; // X3_PICTURE
				""						, ; // X3_VALID
				DEF_X3USADO				, ; // X3_USADO
				'"0"'					, ; // X3_RELACAO
				""						, ; // X3_F3
				1						, ; // X3_NIVEL
				DEF_X3RESERV			, ; // X3_RESERV
				""						, ; // X3_CHECK
				""						, ; // X3_TRIGGER
				"U"						, ; // X3_PROPRI
				"N"						, ; // X3_BROWSE
				"V"						, ; // X3_VISUAL
				"V"						, ; // X3_CONTEXT
				""						, ; // X3_OBRIGAT 
				""						, ; // X3_VLDUSER
				""						, ; // X3_CBOX
				""						, ; // X3_CBOXSPA
				""						, ; // X3_CBOXENG
				""						, ; // X3_PICTVAR
				""						, ; // X3_WHEN
				""						, ; // X3_INIBRW
				""						, ; // X3_GRPSXG
				"1"						} } // X3_FOLDER

aEval( aEstrut, { |x| x[ 2 ] := SX3->( FieldPos( x[ 1 ] ) ) } )

nPosArq := aScan( aEstrut, { |x| AllTrim( x[ 1 ] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[ 1 ] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[ 1 ] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[ 1 ] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[ 1 ] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[ 1 ] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[ nPosArq ] + x[ nPosOrd ] + x[ nPosCpo ] < y[ nPosArq ] + y[ nPosOrd ] + y[ nPosCpo ] } )

cAliasAtu := ""
nTamSeek  := Len( SX3->X3_CAMPO )

For nI := 1 To Len( aSX3Inc )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3Inc[ nI, nPosSXG ] )
		SXG->( DbSetOrder( 1 ) )
		If SXG->( DbSeek( aSX3Inc[ nI, nPosSXG ] ) )
			If  aSX3Inc[ nI, nPosTam ] <> SXG->XG_SIZE
			
				aSX3Inc[ nI, nPosTam ] := SXG->XG_SIZE
				AtuMsg( cMsgEmp + "O tamanho do campo " + aSX3Inc[ nI, nPosCpo ] + " NÃO foi atualizado e foi mantido em [" + ;
								AllTrim( Str( SXG->XG_SIZE ) ) + "]", oMsgInfo, @aMsgList, .T., .F. )
				AtuMsg( cMsgEmp + "por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]", oMsgInfo, @aMsgList, .F., .T. )
				
			EndIf
		EndIf
	EndIf
         
	cCpoSX3 := PadR( aSX3Inc[ nI, nPosCpo ], nTamSeek )
                                                       
	SX3->( DbSetOrder( 2 ) )

	If ! SX3->( DbSeek( cCpoSX3 ) )

		AtuMsg( cMsgEmp + "[Iniciado  ] Criar campo " + cCpoSX3, oMsgInfo, @aMsgList, .T./*Pula linha*/, .F. /*Refresh*/)

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3Inc[ nI, nPosArq ] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3Inc[ nI, nPosArq ]

			SX3->( DbSetOrder( 1 ) )
			SX3->( DbSeek( cAliasAtu + "ZZ", .T. ) )
			SX3->( DbSkip( -1 ) )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu ++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3Inc[ nI ] )
			If nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[ nJ, 1 ] ), cSeqAtu ) )

			ElseIf aEstrut[ nJ, 2 ] > 0
				SX3->( FieldPut( FieldPos( aEstrut[ nJ, 1 ] ), aSX3Inc[ nI, nJ ] ) )

			EndIf
		Next nJ

		DbCommit()
		SX3->( MsUnLock() )

		AtuMsg( cMsgEmp + "[Finalizado] Criar campo " + cCpoSX3 , oMsgInfo, @aMsgList, .F. /*Pula linha*/, .T. /*Refresh*/ )

	EndIf

Next nI

//
// Atualizacao de campos especificos do dicionario, sem necessidade de acesso exclusivo.
//                         
DbSelectArea( "SX3" )
                 
For nX := 1 To Len( aSX3Alt )

	cCpoTab := aSX3Alt[ nX, 1 ]
	cCpoSX3 := aSX3Alt[ nX, 2 ]    
	cValCpo := aSX3Alt[ nX, 3 ]
		
	SX3->( DbSetOrder( 2 ) )				

	If ! SX3->( DbSeek( cCpoTab ) )    
	
		AtuMsg( cMsgEmp + '[Atenção!  ] Campo "' + cCpoTab + '" não encontrado.', oMsgInfo, @aMsgList, .T., .T. )
		
	Else
	
		nPos := AScan( aSX3Alt, { |x| x[ 1 ] == cCpoTab } )
		                                   
		If nPos > 0
		
			AtuMsg( cMsgEmp + "[Iniciado  ] Alterar propriedade " + cCpoSX3 + " do campo " + cCpoTab, oMsgInfo, @aMsgList, .T., .T. )
			
			If AllTrim( cValCpo ) <> AllTrim( FieldGet( FieldPos( cCpoSX3 ) ) )
			
				AtuMsg( cMsgEmp + '[Atual     ] "' + AllTrim( FieldGet( FieldPos( cCpoSX3 ) ) ) + '"', oMsgInfo, @aMsgList, .F., .F. )
				
				RecLock( "SX3", .F. )	                   
				SX3->( FieldPut( FieldPos( cCpoSX3 ), cValCpo ) )
				SX3->( MsUnlock() )
			
				AtuMsg( cMsgEmp + '[Novo      ] "' + cValCpo + '"', oMsgInfo, @aMsgList, .F., .F. )
				
			Else
						                                                                           
				AtuMsg( cMsgEmp + "[Inalterado] Alteração já realizada anteriormente.", oMsgInfo, @aMsgList, .F., .F. )
				
			EndIf
			
			AtuMsg( cMsgEmp + "[Finalizado] Alterar propriedade " + cCpoSX3 + " do campo " + cCpoTab, oMsgInfo, @aMsgList, .F., .T. )
		
		EndIf                                                        
	
	EndIf
	                           
Next nX

RestArea( aArea )

Return Nil



/*
---------------------------------------------------------------------------
| Rotina    | AtuMsg      | Autor | Gustavo Prudente | Data | 19.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Rotina para geracao de mensagem no listbox da tela do update|
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Mensagem a ser exibida                              |
|			| EXPO2 - Objeto da mensagem a ser exibida no listbox         |
|           | EXPA2 - Vetor com a lista de mensagens                      |
|           | EXPL4 - Indica se deve pular linha entre as mensagens       |
|           | EXPL5 - Indica se deve atualizar o listbox de mensagens     |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function AtuMsg( cMsg, oMsgInfo, aMsgList, lLinha, lRefresh )
                 
If lLinha
	AAdd( aMsgList, "" )
EndIf
	
AAdd( aMsgList, cMsg )
    
If lRefresh    
          
	oMsgInfo:aArray := aMsgList
	oMsgInfo:bLine := { || { aMsgList[ oMsgInfo:nAt ] } }
	oMsgInfo:nAt := Len( aMsgList )
	oMsgInfo:Refresh()
	oMsgInfo:GoBottom()

EndIf	

Return Nil



/*
---------------------------------------------------------------------------
| Rotina    | USDKRetSM0  | Autor | Gustavo Prudente | Data | 19.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria vetor com a lista de empresas e filiais da SM0         |
|-------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto da opcao confirmada (Marcado)                |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function USDKRetSM0( oOk )

Local aArea   	:= GetArea()
Local aRetSM0 	:= {}                 

DbSelectArea( "SM0" )
SM0->( DbGoTop() )

Do While SM0->( ! Eof() )
	
	aAux := { 	oOk				, ;
				SM0->M0_CODIGO	, ;
				SM0->M0_CODFIL	, ;
				SM0->M0_NOME  	, ;
				SM0->M0_FILIAL	}

	AAdd( aRetSM0, aClone( aAux ) )
	
	SM0->( DbSkip() )
	
EndDo                     

RestArea( aArea )

Return( aRetSM0 )


/*
---------------------------------------------------------------------------
| Rotina    | USDKInv     | Autor | Gustavo Prudente | Data | 19.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Inverte selecao de empresas e filiais                       |
|-------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto da opcao confirmada (Marcado)                |
|           | EXPO2 - Objeto da opcao negada (Desmarcado)                 |
|           | EXPA3 - Vetor com todas as empresas e filiais selecionadas  |
|           | EXPO4 - Objeto de selecao de empresas e filiais marcadas    |
|           | EXPL5 - Indica se deve marcar ou desmarcar todas as filiais |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function USDKInv( oOk, oNo, aEmpFil, oEmpFil, lEmpFil )

Local nX := 0

For nX := 1 To Len( aEmpFil )
                       
	If lEmpFil
		aEmpFil[ nX, 1 ] := oOk
	Else	
		aEmpFil[ nX, 1 ] := oNo
	EndIf
	
Next nX

oEmpFil:Refresh()

Return Nil


/*
---------------------------------------------------------------------------
| Rotina    | USDKMark    | Autor | Gustavo Prudente | Data | 19.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Marca ou desmarca empresas e filiais                        |
|-------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto da opcao confirmada (Marcado)                |
|           | EXPO2 - Objeto da opcao negada (Desmarcado)                 |
|           | EXPA3 - Vetor com todas as empresas e filiais selecionadas  |
|           | EXPO4 - Objeto de selecao de empresas e filiais marcadas    |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function USDKMark( oOk, oNo, aEmpFil, oEmpFil )
             
Local cEmpAtu	:= aEmpFil[ oEmpFil:nAt, 2 ]
Local nPosFil	:= 0
Local nX   := 0

nPosFil := AScan( aEmpFil, { |x| x[ 2 ] == cEmpAtu } )
                    
If nPosFil > 0

	Do While nPosFil <= Len( aEmpFil ) .And. aEmpFil[ nPosFil, 2 ] == cEmpAtu
		If aEmpFil[ nPosFil, 1 ] == oOk
			aEmpFil[ nPosFil, 1 ] := oNo
		Else	
			aEmpFil[ nPosFil, 1 ] := oOk
		EndIf
		nPosFil ++
	EndDo	

EndIf                  

oEmpFil:Refresh()

Return Nil


/*
---------------------------------------------------------------------------
| Rotina    | USDKLog     | Autor | Gustavo Prudente | Data | 19.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Realiza a gravacao das mensagens em arquivo de log.         |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Vetor com mensagens geradas durante o processamento |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function USDKLog( aMsgInfo )

Local oDlg
Local oMemo                
Local oFont 	:= TFont():New( "Consolas",, -11 )           

Local nX 		:= 0

Local cTexto	:= ""
Local cFileLog	:= ""
Local cFile		:= ""
Local cMask     := "Arquivos Texto " + "(*.TXT)|*.txt|"

For nX := 1 To Len( aMsgInfo )
	cTexto += aMsgInfo[ nX ] + CRLF
Next nX
          
cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cTexto )

oDlg := MSDialog():New( 03, 00, 300, 600, "Certisign - Atualização de Dicionário de Dados",,,,, CLR_BLACK,,,,.T. )          
                               
oMemo := TMultiGet():New( 05, 05, { |u| Iif( PCount() > 0, cTexto := u, cTexto ) }, oDlg, 200, 145, oFont,,,,, .T.,,,,,,.T. )
oMemo:Align := CONTROL_ALIGN_ALLCLIENT

oMemo:bRClicked := { || AllwaysTrue() }

oPanelBtn		:= tPanel():New( 01, 01, "", oDlg,,.T.,,CLR_BLACK,, 1, 12, .F., .F. )
oPanelBtn:Align := CONTROL_ALIGN_BOTTOM        

oPanelL01		:= tPanel():New( 01, 01, "", oDlg,,.T.,,CLR_BLACK,, 1, 02, .F., .F. )
oPanelL01:Align := CONTROL_ALIGN_BOTTOM
          
oBtnSair   := SButton():New( 03, 175, 1 , { || oDlg:End() }, oPanelBtn, .T. )
oBtnSalvar := SButton():New( 03, 145, 13, { || cFile := cGetFile( cMask, "" ), If( cFile == "", .T., MemoWrite( cFile, cTexto ) ) }, oPanelBtn, .T. )

oBtnSair:Align	:= CONTROL_ALIGN_RIGHT
oBtnSalvar:Align:= CONTROL_ALIGN_RIGHT

oDlg:lCentered := .T.
oDlg:Activate()

Return Nil


/*
---------------------------------------------------------------------------
| Rotina    | USDKAtuSXB  | Autor | Gustavo Prudente | Data | 30.10.2014  |
|-------------------------------------------------------------------------|
| Descricao | Atualiza dicionario de consultas padrao SXB.                |
|-------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto da mensagem a ser exibida no listbox         |
|           | EXPA2 - Vetor com a lista de mensagens                      |
|           | EXPC3 - String com a mensagem de empresa e filial           |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function USDKAtuSXB( oMsgInfo, aMsgList, cMsgEmp )

Local aEstrut   := {}
Local aSXB      := {}
Local lContinua := .T.
Local lReclock  := .T.
Local nI        := 1
Local nJ        := 0
Local nTamVar   := Len( SXB->XB_ALIAS )
          
aEstrut := { "XB_ALIAS", "XB_TIPO", "XB_SEQ", "XB_COLUNA", "XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM", "XB_WCONTEM" }
          
AAdd( aSXB, { "XCSOCO", "1", "01", "RE", "Assunto x Ocorrencia", "Assunto x Ocorrencia", "Assunto x Ocorrencia", "SU9", "" } )
AAdd( aSXB, { "XCSOCO", "2", "01", "01", "", "", "", ".T.", "" } )
AAdd( aSXB, { "XCSOCO", "5", "01", ""  , "", "", "", "U_XCSOCO()", "" } )

/*
AAdd( aSXB, {"SZT","1","01","DB","Common Name"        ,"Common Name"        ,"Common Name"        ,"SZT"           ,""})
AAdd( aSXB, {"SZT","2","01","01","Codigo"             ,"Codigo"             ,"Codigo             ",""              ,""})
AAdd( aSXB, {"SZT","2","02","02","Common Name+Produto","Common Name+Produto","Common Name+Produto",""              ,""})
AAdd( aSXB, {"SZT","4","01","01","Codigo"             ,"Codigo"             ,"Codigo"             ,"ZT_CODIGO"     ,""})
AAdd( aSXB, {"SZT","4","01","02","Empresa"            ,"Empresa"            ,"Empresa"            ,"ZT_EMPRESA"    ,""})
AAdd( aSXB, {"SZT","4","01","03","Common Name"        ,"Common Name"        ,"Common Name"        ,"ZT_COMMON"     ,""})
AAdd( aSXB, {"SZT","4","01","04","Produto"            ,"Produto"            ,"Produto"            ,"ZT_PRODUT"     ,""})
AAdd( aSXB, {"SZT","4","02","01","Codigo"             ,"Codigo"             ,"Codigo"             ,"ZT_CODIGO"     ,""})
AAdd( aSXB, {"SZT","4","02","02","Empresa"            ,"Empresa"            ,"Empresa"            ,"ZT_EMPRESA"    ,""})
AAdd( aSXB, {"SZT","4","02","03","Common Name"        ,"Common Name"        ,"Common Name"        ,"ZT_COMMON"     ,""})
AAdd( aSXB, {"SZT","4","02","04","Produto"            ,"Produto"            ,"Produto"            ,"ZT_PRODUT"     ,""})
AAdd( aSXB, {"SZT","5","01",""  ,""                   ,""                   ,""                   ,"SZT->ZT_CODIGO",""})
*/

//
// Atualizando dicionário
//
DbSelectArea( "SXB" )
DbSetOrder( 1 )

Do While nI <= Len( aSXB )

	cSXB := aSXB[ nI, 1 ]
	
	AtuMsg( cMsgEmp + '[Iniciado  ] Criação da consulta "' + cSXB + '"', oMsgInfo, @aMsgList, .T./*Pula linha*/, .F. /*Refresh*/)

	Do While nI <= Len( aSXB ) .And. cSXB == aSXB[ nI, 1 ]

		If ! DbSeek( PadR( aSXB[ nI, 1 ], nTamVar ) + aSXB[ nI, 2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] )

			RecLock( "SXB", .T. )

			For nJ := 1 To Len( aSXB[ nI ] )
				If FieldPos( aEstrut[ nJ ] ) > 0
					FieldPut( FieldPos( aEstrut[ nJ ] ), aSXB[ nI, nJ ] )
				EndIf
			Next nJ

			DbCommit()
			MsUnLock()

		EndIf                        
		
		nI ++
	
	EndDo
	
	AtuMsg( cMsgEmp + '[Finalizado] Consulta "' + cSXB + '" criada com sucesso.', oMsgInfo, @aMsgList, .F., .T. )

EndDo

Return Nil