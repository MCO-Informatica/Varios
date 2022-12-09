#include "protheus.ch"

#define X_DATA_ABERTURA		3
#define X_HORA_ABERTURA		4

#define X_TOTAL_COL			11

/*
---------------------------------------------------------------------------
| Rotina    | CSSDKACM    | Autor | Gustavo Prudente | Data | 20.01.2015  |
|-------------------------------------------------------------------------|
| Descricao | Rotina de acompanhamento de atendimentos que iniciaram ou   |
|           | passaram pelo grupo e nao foram finalizados.                |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function CSSDKACM()

Local oDlgACM      
Local oPanelBtn                                  
Local oBtnPesq
Local oBtnAtu
Local oBtnSair                                                  
Local oListACM
Local oChkTra
Local oTotal
Local oPeriodo

Local oAzul    := LoadBitmap( GetResources(), "BR_AZUL" )
Local oVerde   := LoadBitmap( GetResources(), "BR_VERDE" )
Local oCinza   := LoadBitmap( GetResources(), "BR_CINZA" )

Local cDias    := ""

Local nPos	   := 0

Local lChkTra  := .T.

Local aPeriodo := { "15 dias", "30 dias", "60 dias", "90 dias", "Todos" }
Local aDias	   := { 15, 30, 60, 90, 0 }
Local nTotPer  := Len( aPeriodo )

Private aACM	
                
aACM := {}                 
AAdd( aACM, Array( X_TOTAL_COL ) )

// Ativa diálogo centralizado
oDlgACM := MSDialog():New( 120, 120, 550, 950, "Acompanhamento de Chamados - Grupo " + RetGrupo()[2],,,,, CLR_BLACK, CLR_WHITE,,, .T. )  

oPanelBtn		:= tPanel():New( 01, 01, "", oDlgACM,,.T.,,,, 1, 16, .F., .F. )
oPanelBtn:Align := CONTROL_ALIGN_BOTTOM
                             
TSay():New( 04, 130, { || "Selecionar:" }, oPanelBtn,,,,,, .T., CLR_BLUE, CLR_WHITE, 200, 08 )

cDias := aPeriodo[ 1 ]    
oPeriodo := TComboBox():New( 02, 159, { |u| Iif( PCount() > 0, cDias := u, cDias ) }, aPeriodo, 60, 20, oPanelBtn,, ;
				{ || /*na alteracao do item*/ },,,, .T.,,,,,,,,, 'cDias' )

FwMsgRun( , { |oSay| aACM := BuscaResult( oSay,, oPeriodo:nAt, nTotPer, aDias ) } )            
             
@ 005, 005 	LISTBOX oListACM FIELDS ;
			HEADER " ", "Protocolo", "Dt.Abertura", "Hr.Abertura", "Contato", "Equipe", "Analista", "Data", "Hora", "Pedido GAR", "Pedido Site" ;
			SIZE 500, 500 OF oDlgACM PIXEL 
	                                      
oListACM:SetArray( aACM )
oListACM:nAt   := 1
oListACM:bLine := { || 	{ Iif( aACM[ oListACM:nAt, 1 ] == "1", oVerde, ;
						  Iif( Empty( aACM[ oListACM:nAt, 1 ] ), oCinza, oAzul ) ), ;
  						  aACM[ oListACM:nAt, 02 ] , ;
  						  aACM[ oListACM:nAt, 03 ] , ;
  						  aACM[ oListACM:nAt, 04 ] , ;
  						  aACM[ oListACM:nAt, 05 ] , ;
  						  aACM[ oListACM:nAt, 06 ] , ;
  						  aACM[ oListACM:nAt, 07 ] , ;
  						  aACM[ oListACM:nAt, 08 ] , ;
  						  aACM[ oListACM:nAt, 09 ] , ;
  						  aACM[ oListACM:nAt, 10 ] , ;
  						  aACM[ oListACM:nAt, 11 ] } }

oListACM:Align := CONTROL_ALIGN_ALLCLIENT

oTotal := TSay():New( 04, 248, { || "Total: " + XRetTotAt( aACM ) }, oPanelBtn,,,,,, .T., CLR_BLUE, CLR_WHITE, 200, 08 )

@ 04, 02 CHECKBOX oChkTra VAR lChkTra PROMPT "Somente atendimentos transferidos" PIXEL OF oPanelBtn SIZE 100, 50 ;
				MESSAGE "Apresenta somente os atendimentos transferidos" ;
				ON CLICK { || FwMsgRun( , { |oSay| aACM :=	BuscaResult( oSay, lChkTra, oPeriodo:nAt, nTotPer, aDias ), ;
															SetArrayACM( oListACM, aACM, oAzul, oVerde, oCinza, oTotal ) } ) }
                
// Permitir atualizar os resultados em tela - executa novamente o BuscaResult (Query)
oBtnPesq := TButton():New( 002, 294, "&Atualizar", oPanelBtn, ;
				{ || FwMsgRun( , { |oSay| aACM := 	BuscaResult( oSay, lChkTra, oPeriodo:nAt, nTotPer, aDias ) } ), ;
													SetArrayACM( oListACM, aACM, oAzul, oVerde, oCinza, oTotal ) }, 040, 012,,,, .T.,, "",,,, .F. )
                                                                                     
// Chama a pesquisa de historico de atendimentos para o protocolo de atendimento posicionado
oBtnAtu  := TButton():New( 002, 335, "&Historico", oPanelBtn, ;
				{ || HistACM( oListACM ) }, 040, 012,,,, .T.,, "",,,, .F. )
				                                                                            
oBtnSair := TButton():New( 002, 376, "&Sair", oPanelBtn, ;
				{ || lRet := .F., oDlgACM:End() }, 040, 012,,,, .T.,, "",,,, .F. )

oDlgACM:Activate( ,,, .T. )

Return .T.


/*
---------------------------------------------------------------------------------
| Rotina     | BuscaResult    | Autor | Gustavo Prudente   | Data | 22.01.2015  |
|-------------------------------------------------------------------------------|
| Descricao  | Monta o array com os atendimentos que passaram pelo grupo        |
|            | e nao constam como finalizados.                                  |
|-------------------------------------------------------------------------------|
| Parametros | EXPO1 - Objeto com o texto da mensagem.                          |
|            | EXPL2 - Somente atendimentos transferidos ou todos.              |
|            | EXPN3 - Posicao do periodo selecionado.                          |
|            | EXPN4 - Total de periodos para selecao.                          |
|            | EXPA5 - Opcoes de dias para retroagir na selecao de atendimentos |
|-------------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                              |
---------------------------------------------------------------------------------
*/
Static Function BuscaResult( oSay, lChkTra, nPosPer, nTotPer, aDias )
                             
Local cGrupo 	:= ""
Local cCond		:= ""                   
Local cOperador	:= ""
Local cContato	:= ""
Local cDias		:= ""

Local cDescSU0	:= ""
Local cDescSU7	:= ""
Local cDescSU5	:= ""             

Local aDescSU0	:= {}
Local aDescSU7	:= {}
Local aDescSU5	:= {}
Local aRet		:= {}

Local nPosSU0	:= 0
Local nPosSU7	:= 0
Local nPosSU5	:= 0

Local cFilSU0	:= ""
Local cFilSU7	:= ""
Local cFilSU5	:= ""
    
Default lChkTra := .T.    
                     
oSay:cCaption := "Aguarde ... "

ProcessMessages()

cFilSU0	:= xFilial( "SU0" )
cFilSU7	:= xFilial( "SU7" )
cFilSU5	:= xFilial( "SU5" )

cGrupo  := RetGrupo()[ 1 ]                            

If nPosPer < nTotPer
	cDias := AllTrim( Str( aDias[ nPosPer ] ) )
EndIf

AAdd( aRet, Array( X_TOTAL_COL ) )

// Adiciona condicao para selecionar somente atendimentos transferidos em aberto
If lChkTra
	cCond := " ADE.ADE_GRUPO <> '" + cGrupo + "' AND "
	If !Empty( cDias )
		cCond += " ADE.ADE_DATA >= to_char( sysdate - " + cDias + ", 'yyyymmdd' ) AND "
	EndIf	
	cCond += " ADE.D_E_L_E_T_ = ' ' "
Else     
	If !Empty( cDias )
		cCond := " ADE.ADE_DATA >= to_char( sysdate - " + cDias + ", 'yyyymmdd' ) AND "
	EndIf	
	cCond += " ADE.D_E_L_E_T_ = ' ' "
EndIf      

cCond := "%" + cCond + "%"
                                
// Seleciona os atendimentos 
BeginSql Alias "QRYACM"
              
	column ADE_DATA as Date              
	column ADF_DATA as Date

	SELECT      ADE.ADE_STATUS, ADE.ADE_CODIGO, ADE.ADE_DATA, ADE.ADE_HORA,    
	            ADE.ADE_GRUPO, ADE.ADE_OPERAD, ADE.ADE_CODCON, ADF.ADF_DATA, 
	            ADF.ADF_HORA, ADE.ADE_PEDGAR, ADE.ADE_XPSITE
	FROM        %Table:ADE% ADE
	INNER JOIN  %Table:ADF% ADF
	ON          ADF.ADF_FILIAL = %xFilial:ADF% AND
	            ADF.ADF_CODIGO = ADE.ADE_CODIGO AND
	            ADF.ADF_ITEM   = 
	            ( SELECT  MAX( ADFA.ADF_ITEM )
	              FROM    %Table:ADF% ADFA
	              WHERE   ADFA.ADF_FILIAL = %xFilial:ADF% AND
					      ADFA.ADF_CODIGO = ADE.ADE_CODIGO AND
					      ADFA.%notDel% ) AND
	            ( SELECT  COUNT( ADFB.R_E_C_N_O_ )
	              FROM    %Table:ADF% ADFB
	              WHERE   ADFB.ADF_FILIAL = %xFilial:ADF% AND
	                      ADFB.ADF_CODIGO = ADE.ADE_CODIGO AND
	                      ADFB.ADF_CODSU0 = %Exp:cGrupo% AND
	                      ADFB.%notDel% ) > 0 AND
	            ADF.%notDel%                
	WHERE       ADE.ADE_FILIAL = %xFilial:ADE% AND
	            ADE.ADE_STATUS <> '3' AND         
				%Exp:cCond%

EndSql

If QRYACM->( ! EoF() )

	aRet := {}                                                                                                                     
	
	SU0->( DbSetOrder( 1 ) )
	SU7->( DbSetOrder( 1 ) )
	SU5->( DbSetOrder( 1 ) )
                         
	Do While QRYACM->( ! EoF() )                                  
	
		cGrupo   	:= QRYACM->ADE_GRUPO
		cOperador	:= QRYACM->ADE_OPERAD
		cContato	:= QRYACM->ADE_CODCON

		cDescSU0 	:= Space( 40 )
		cDescSU7 	:= Space( 40 )
		cDescSU5 	:= Space( 40 )
                    
		// Verifica se preenche descricao do grupo a partir do array (cache) ou 
		// busca na tabela de grupos (SU0)
		If ! Empty( cGrupo )
			nPosSU0 := AScan( aDescSU0, { |x| x[ 1 ] == cGrupo } ) 
			If nPosSU0 > 0
				cDescSU0 := aDescSU0[ nPosSU0, 2 ]
			Else	 
				SU0->( DbSeek( cFilSU0 + cGrupo ) )
				cDescSU0 := cGrupo + "-" + SubStr( SU0->U0_NOME, 1, 40 )
				AAdd( aDescSU0, { cGrupo, cDescSU0 } )
			EndIf
		EndIf         
		         
		// Verifica se preenche descricao do operador a partir do array (cache) ou 
		// busca na tabela de operadores (SU7)
		If ! Empty( cOperador )
			nPosSU7 := AScan( aDescSU7, { |x| x[ 1 ] == cOperador } ) 
			If nPosSU7 > 0
				cDescSU7 := aDescSU7[ nPosSU7, 2 ]
			Else	 
				SU7->( DbSeek( cFilSU7 + cOperador ) )
				cDescSU7 := cOperador + "-" + SubStr( SU7->U7_NOME, 1, 40 )
				AAdd( aDescSU7, { cOperador, cDescSU7 } )
			EndIf	
		EndIf	      

		// Verifica se preenche descricao do contato a partir do array (cache) ou 
		// busca na tabela de contatos (SU5)
		If ! Empty( cContato )
			nPosSU5 := AScan( aDescSU5, { |x| x[ 1 ] == cContato } ) 
			If nPosSU5 > 0
				cDescSU5 := aDescSU5[ nPosSU5, 2 ]
			Else	 
				SU5->( DbSeek( cFilSU5 + cContato ) )
				cDescSU5 := cContato + "-" + SubStr( SU5->U5_CONTAT, 1, 40 )
				AAdd( aDescSU5, { cContato, cDescSU5 } )
			EndIf	
		EndIf	      

		AAdd( aRet, { 	QRYACM->ADE_STATUS,	;
						QRYACM->ADE_CODIGO,	;
						QRYACM->ADE_DATA,	;
						QRYACM->ADE_HORA,	;
						cDescSU5,			;
						cDescSU0,			;
						cDescSU7,			;
						QRYACM->ADF_DATA, 	;
						QRYACM->ADF_HORA,	;
						QRYACM->ADE_PEDGAR,	;
						QRYACM->ADE_XPSITE } )
                                        
		QRYACM->( DbSkip() )
	
	EndDo

EndIf

QRYACM->( dbCloseArea() )

// Ordena array por data e hora de abertura
aRet := aSort( aRet,,, { |x, y| DtoS( x[ X_DATA_ABERTURA ] ) + x[ X_HORA_ABERTURA ] > ;
								DtoS( y[ X_DATA_ABERTURA ] ) + y[ X_HORA_ABERTURA ] } )

DbSelectArea( "ADE" )

Return( aRet )


/*
-------------------------------------------------------------------------------
| Rotina     | RetGrupo       | Autor | Gustavo Prudente | Data | 20.01.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Retorna o grupo do usuario logado no Call Center               |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function RetGrupo()

Local cCodUser	:= AllTrim( TkOperador() )

SU7->( DbSetOrder( 1 ) )
SU7->( DbSeek( xFilial() + cCodUser ) )

SU0->( DbSetOrder( 1 ) )
SU0->( DbSeek( xFilial() + SU7->U7_POSTO ) )

Return( { SU0->U0_CODIGO, SU0->U0_CODIGO + " - " + SU0->U0_NOME } )


/*
----------------------------------------------------------------------------
| Rotina    | SetArray    | Autor | Gustavo Prudente | Data | 21.01.2015   |
|--------------------------------------------------------------------------|
| Descricao | Atualiza array com o resultado dos atendimentos.             |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de lista de atendimentos                      |
|           | EXPA2 - Array com os atendimentos pendentes que passaram     |
|           |         pelo grupo.                                          |
|           | EXPO3 - Objeto de status do listbox                          |
|           | EXPO4 - Objeto de status do listbox                          |
|           | EXPO5 - Objeto de status do listbox                          |
|           | EXPO6 - Objeto de totalizacao dos atendimentos               |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/      
Static Function SetArrayACM( oListACM, aACM, oAzul, oVerde, oCinza, oTotal )
          
oListACM:SetArray( aACM )
                   
oListACM:bLine := { || 	{ Iif( aACM[ oListACM:nAt, 1 ] == "1", oVerde, ;
						  Iif( Empty( aACM[ oListACM:nAt, 1 ] ), oCinza, oAzul ) ), ;
  						  aACM[ oListACM:nAt, 02 ] , ;
  						  aACM[ oListACM:nAt, 03 ] , ;
  						  aACM[ oListACM:nAt, 04 ] , ;
  						  aACM[ oListACM:nAt, 05 ] , ;
  						  aACM[ oListACM:nAt, 06 ] , ;
  						  aACM[ oListACM:nAt, 07 ] , ;
  						  aACM[ oListACM:nAt, 08 ] , ;
  						  aACM[ oListACM:nAt, 09 ] , ;
  						  aACM[ oListACM:nAt, 10 ] , ;
  						  aACM[ oListACM:nAt, 11 ] } }
          
oListACM:nAt := 1
oListACM:Refresh()
oTotal:Refresh()

Return .T.

                            
/*
----------------------------------------------------------------------------
| Rotina    | HistACM     | Autor | Gustavo Prudente | Data | 27.01.2015   |
|--------------------------------------------------------------------------|
| Descricao | Gatilha pesquisa de historico para o atendimento posicionado |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de lista de atendimentos                      |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/      
Static Function HistACM( oListACM )

Local cCodigo := aACM[ oListACM:nAt, 2 ]	// Protocolo

u_PesqHist( .F., "ADE_CODIGO", cCodigo, .T. )

Return .T.


/*
----------------------------------------------------------------------------
| Rotina    | XRetTotAt   | Autor | Gustavo Prudente | Data | 15.05.2015   |
|--------------------------------------------------------------------------|
| Descricao | Retorna o total de atendimentos selecionados                 |
|--------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com os atendimentos selecionados para exibicao |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/      
Static Function XRetTotAt( aACM )

Local nTotal := Len( aACM )

If nTotal == 1 .And. Empty( aACM[ nTotal, 2 ] )
	cRet := "0"
Else
	cRet := Transform( nTotal, "@E 9,999,999" )
EndIf	

Return( AllTrim( cRet ) )