#include 'totvs.ch'

/*
---------------------------------------------------------------------------
| Rotina    | RTmkRetAss  | Autor | Gustavo Prudente | Data | 01.04.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria/Consulta descricao dos assuntos da tabela T1           |
|-------------------------------------------------------------------------|
| Parametros| EXPN1 - 1 - Cria vetor com os assuntos da tabela T1         |
|           |         2 - Consulta descricao do assunto passado como      |
|           |             parametro.                                      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function RTmkRetAss( nTipo, cAssunto )

Static aTabAssunto
                                                         
Local nPos 		:= 0
Local cRet 		:= ""   
Local cFilSX5 	:= ""
          
Default nTipo		:= 2
Default cAssunto	:= ""

If nTipo == 1
                         
	aTabAssunto	:= {}
	cFilSX5		:= xFilial( "SX5" )
             
	SX5->( dbSetOrder( 1 ) )
	SX5->( dbSeek( cFilSX5 + "T1" ) )
                      
	While SX5->( ! EoF() ) .And. SX5->X5_FILIAL == cFilSX5 .And. SX5->X5_TABELA == "T1"
		AAdd( aTabAssunto, { AllTrim( SX5->X5_CHAVE ), SX5->X5_DESCRI } ) 
		SX5->( dbSkip() )                
	EndDo

Else                                                     

	If !Empty( cAssunto )
		cAssunto := AllTrim( cAssunto )
		nPos := AScan( aTabAssunto, { |x| AllTrim( x[1] ) == cAssunto } )
		If nPos > 0
			cRet := SubStr( aTabAssunto[ nPos, 2 ], 1, 40 )
		EndIf
	EndIf

EndIf

Return( cRet )


/*
-------------------------------------------------------------------------------
| Rotina     | RTmkRetGrp     | Autor | Gustavo Prudente | Data | 01.04.2014  |
|-----------------------------------------------------------------------------|
| Descricao  | Retorna o grupo do usuario logado no Call Center               |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
User Function RTmkRetGrp()

Local cCodUser := AllTrim( TkOperador() )
Local cGrupo	 := ""                      

SU7->( DbSetOrder( 1 ) )
SU7->( DbSeek( xFilial() + cCodUser ) )

cGrupo := SU7->U7_POSTO

Return( cGrupo )

/*
----------------------------------------------------------------------------
| Rotina    | RTmkSelGrp  | Autor | Gustavo Prudente | Data | 01.04.2014   |
|--------------------------------------------------------------------------|
| Descricao | Permite selecionar os grupos que o usuário logado tem acesso |
|--------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com os grupos de atendimento do operador       |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/ 
User Function RTmkSelGrp( aSelGrp, cTitulo )

Local oDlgGrp      
Local oListGrp
                                    
Local oBtn1
Local oBtn2

Local oPanelList
Local oPanelBtn

Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )

Local lRet	:= .F.
Local cFilAG9	:= xFilial( "AG9" )
Local cFilSU0	:= xFilial( "SU0" )
Local cCodUser:= ""

Default cTitulo := ""

// Seleciona grupos de atendimento do usuario logado no Service Desk
If Len( aSelGrp ) == 1 .And. Empty( aSelGrp[ 1, 2 ] ) .And. Empty( aSelGrp[ 1, 3 ] )

	cCodUser := AllTrim( TkOperador() )                     
	aSelGrp  := {}

	SU0->( dbSetOrder( 1 ) )	        
	AG9->( dbSetOrder( 1 ) )
	AG9->( dbSeek( cFilAG9 + cCodUser ) )

	// Monta array com os grupos do usuario logado, para permitir seleção de grupos
	While AG9->( ! EoF() ) .And. AG9->AG9_FILIAL == cFilAG9 .And. AG9->AG9_CODSU7 == cCodUser
		SU0->( dbSeek( cFilSU0 + AG9->AG9_CODSU0 ) )
		AAdd( aSelGrp, { .T., AG9->AG9_CODSU0, SubStr( SU0->U0_NOME, 1, 40 ) } )
		AG9->( dbSkip() )
	EndDo

EndIf

// Se nao encontrou grupos para o operador, exibe mensagem de alerta
If Len( aSelGrp ) == 0
	
	Aviso( cTitulo, ">> Problema: " + CRLF + ;
					'O operador "' + Alltrim( UsrRetName( RetCOdUsr() ) ) + ;
					'" não está relacionado à nenhum grupo de atendimento.' + CRLF + CRLF + ;
					">> Solução: " + CRLF + ;
					"Acesse o cadastro de operadores e relacione os grupos de atendimento para o operador.", ;
					{ "Ok" }, 3 )
	
Else	

	oDlgGrp := MSDialog():New( 180, 180, 400, 600, cTitulo,,,,, CLR_BLACK, CLR_WHITE,,, .T. )  // Ativa diálogo centralizado
	             
	oPanelBtn	 := tPanel():New( 01, 01, "", oDlgGrp,,.T.,,,, 1, 16, .F., .F. )
	oPanelBtn:Align := CONTROL_ALIGN_BOTTOM
	
	@ 005, 005 LISTBOX oListGrp FIELDS HEADER " ", "Grupo", "Descrição", ;
		SIZE 100, 100 OF oDlgGrp PIXEL ON dblClick( aSelGrp[ oListGrp:nAt, 1 ] := ! aSelGrp[ oListGrp:nAt, 1 ] )
		                                      
	oListGrp:SetArray( aSelGrp )
	oListGrp:bLine := { || 	{ Iif( 	aSelGrp[ oListGrp:nAt, 1 ], oOk, oNo ) , ;
	  								aSelGrp[ oListGrp:nAt, 2 ] , ;
									aSelGrp[ oListGrp:nAt, 3 ] } }
	
	oListGrp:Align := CONTROL_ALIGN_ALLCLIENT
	
	oBtn1 := TButton():New( 003, 143, "&Ok"		, oPanelBtn, { || Iif( ValGrp( aSelGrp, cTitulo ), ( lRet := .T., oDlgGrp:End() ), .T. ) }, 032, 011,,,, .T.,, "",,,, .F. )
	oBtn1 := TButton():New( 003, 178, "&Cancelar"	, oPanelBtn, { || lRet := .F., oDlgGrp:End() }, 032, 011,,,, .T.,, "",,,, .F. )
	
	oDlgGrp:Activate( ,,, .T. )

EndIf
	
Return lRet

/*
---------------------------------------------------------------------------
| Rotina    | ValGrp      | Autor | Gustavo Prudente | Data | 31.03.2014  |
|-------------------------------------------------------------------------|
| Descricao | Valida selecao de grupos de atendimento                     |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com os grupos de atendimento do operador      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/ 
Static Function ValGrp( aSelGrp, cTitulo )

Local lRet 	:= .F.
Local nX	:= 0              
            
For nX := 1 To Len( aSelGrp )
	If aSelGrp[ nX, 1 ]
		lRet := .T.
		Exit
	EndIf	
Next nX

If ! lRet
	Aviso( cTitulo, "Selecione um grupo de atendimento para continuar.", { "Ok" }, 1 )
EndIf

Return( lRet )