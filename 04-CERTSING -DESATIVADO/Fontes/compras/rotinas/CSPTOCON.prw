#include "protheus.ch"

/*           
------------------------------------------------------------------------------
| Rotina    | CSPTOCON     | Autor | Gustavo Prudente | Data | 15.07.2015    |
|----------------------------------------------------------------------------|
| Descricao | Cria relacionamento entre o contato e o posto de atendimento.  |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
User Function CSPTOCON

Local oFont1 	:= TFont():New( "Arial",, -11 )

Local cCPF	 	:= ""
Local cPostos	:= ""

RpcSetType( 3 )
RpcSetEnv( "01", "02" )
//RpcSetEnv( "99", "01" )

DEFINE MSDIALOG oMainWnd TITLE "Certisign - Relacionar Pontos de Distribuição x Contatos" FROM 0,0 TO 500,600 FONT oFont1 PIXEL
                    
// Painel e campo memo de CPF
oPanelMsg1     		:= tPanel():New( 00, 00, "", oMainWnd,,.T.,,, CLR_WHITE, 1, 20, .T., .F. )
oPanelMsg1:Align	:= CONTROL_ALIGN_TOP

oSayMsg1			:= tSay():New( 02, 02, { || ;	
							"Informe os números de CPF dos contatos, separados por ponto e virgula, sem formatação. " + CRLF + "Exemplo: 00000000000;11111111100" }, ;
							oPanelMsg1,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE, 300, 20 )

oPanelMemCPF		:= tPanel():New( 00, 00, "", oMainWnd,,.T.,,, CLR_WHITE, 1, 92, .F., .F. )
oPanelMemCPF:Align	:= CONTROL_ALIGN_TOP                                                          

oMemoCPF 			:= TMultiget():New( 01, 01, { |u| Iif( Pcount() > 0, cCPF := u, cCPF ) }, oPanelMemCPF, 10, 10,,.T.,,,, .T.)
oMemoCPF:Align		:= CONTROL_ALIGN_ALLCLIENT                                                                                  

oMemoCPF:EnableVScroll(.T.)
                             
// Painel e campo memo para informar codigos de postos para filtro
oPanelMsg2			:= tPanel():New( 00, 00, "", oMainWnd,,.T.,,, CLR_WHITE, 1, 30, .T., .F. )
oPanelMsg2:Align	:= CONTROL_ALIGN_TOP

oSayMsg2			:= tSay():New( 02, 02, { || ;
							"Informe o filtro por postos de atendimento separados por ponto e virgula. " + CRLF + "Exemplo: P11111;P00001" }, ;
							oPanelMsg2,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE, 300, 15 )

oSayMsg3			:= tSay():New( 22, 02, { || ;
							"Atenção! Deixe o campo abaixo em branco, se desejar relacionar os contatos acima à todos os postos de atendimento." }, ;
							oPanelMsg2,, oFont1,,,, .T.,CLR_RED,CLR_WHITE, 300, 15 )                             
							
oPanelMemPos		:= tPanel():New( 00, 00, "", oMainWnd,,.T.,,, CLR_WHITE, 1, 92, .F., .F. )
oPanelMemPos:Align	:= CONTROL_ALIGN_TOP                                                      

oMemoPosto 			:= TMultiget():New( 01, 01, { |u| Iif( Pcount() > 0, cPostos := u, cPostos ) }, oPanelMemPos, 10, 10,,.T.,,,, .T.)
oMemoPosto:Align	:= CONTROL_ALIGN_ALLCLIENT

oMemoPosto:EnableVScroll(.T.)
                                                                  
// Painel de mensagem e botoes no rodape
oPanelMsg			:= tPanel():New( 00, 00, "", oMainWnd,,.T.,,, CLR_WHITE, 1, 13, .F., .F. )
oPanelMsg:Align		:= CONTROL_ALIGN_BOTTOM

oBtnSair := TButton():New( 02, 02, "&Sair", oPanelMsg, { || oMainWnd:End() }, 040, 012,,,,.T.,,"",,,,.F. )
oBtnSair:Align 		:= CONTROL_ALIGN_RIGHT

oBtnProc := TButton():New( 02, 02, "&Processar", oPanelMsg, { || ;
			MsgRun( "Aguarde. Em processamento ...", "Relacionar Pontos de Distribuição x Contatos", { || ProcPtoCon( cCPF, cPostos ) } ) }, 040, 012,,,,.T.,,"",,,,.F. )
			
oBtnProc :Align 	:= CONTROL_ALIGN_RIGHT

oPanelLin1			:= tPanel():New( 00, 00, "", oMainWnd,,.T.,,, CLR_WHITE, 1, 2, .T., .F. )
oPanelLin1:Align	:= CONTROL_ALIGN_BOTTOM

ACTIVATE MSDIALOG oMainWnd CENTER

Return .T.


/*           
------------------------------------------------------------------------------
| Rotina    | ProcPtoCon   | Autor | Gustavo Prudente | Data | 15.07.2015    |
|----------------------------------------------------------------------------|
| Descricao | Processa relacionamento entre o contato do CPF informado       |
|           | com o codigo do ponto de atendimento do filtro ou, se nao      |
|           | for informado codigos de postos, relaciona com todos os postos |
|----------------------------------------------------------------------------|
| Parametros| EXPC1 - String com os numeros de CPF de contatos               |
|           | EXPC2 - String com os codigos dos postos de atendimento para   |
|           |         relacionamento.                                        |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function ProcPtoCon( cCPF, cPostos )

Local aCPF 		:= {}
Local aInfoSZ8  := {}
Local aFilSZ8   := {}

Local nHandle 	:= 0          
Local nX		:= 0     

Local cFilSU5	:= ""
Local cFilAC8	:= ""
Local cFilSZ8	:= ""                                                                                             

// Gera arrays com as informacoes de CPF de contatos e postos de atendimento
aCPF     := StrToKArr( cCPF, ";" )
aInfoSZ8 := StrToKArr( cPostos, ";" )

cFilSU5 := xFilial( "SU5" )              
cFilAC8	:= xFilial( "AC8" )
cFilSZ8 := xFilial( "SZ8" )

u_CSGERLog( 1, @nHandle, "Atualização de Pontos de Distribuição X Contatos", "\logpdcon", "\" + DtoS( Date() ) )

aFilSZ8	:= {}				

// Valida pontos de distribuicao informados para filtro
For nX := 1 To Len( aInfoSZ8 )         
	// Somente adiciona no filtro postos validos
	If SZ8->( DbSeek( cFilSZ8 + aInfoSZ8[ nX ] ) )
		AAdd( aFilSZ8, aInfoSZ8[ nX ] )
	Else
		u_CSGERLog( 2, nHandle, "[Ponto de Distribuição: " + AllTrim( aInfoSZ8[ nX ] ) + " não encontrado na base de dados do Protheus.] " )
	EndIf	
Next nX

lFilSZ8 := Len( aFilSZ8 ) > 0

// Se foi informado filtro e não existe ponto valido, cancela o processamento.
If Len( aInfoSZ8 ) > 0 .And. ! lFilSZ8

	u_CSGERLog( 2, nHandle, "[Atenção! Nenhum ponto de distribuição válido para realizar o filtro na base de dados do Protheus.]" )

Else				
	
	For nX := 1 To Len( aCPF )
	       
		If ! Empty( aCPF[ nX ] )
	            
			SU5->( DbSetOrder( 8 ) )	// U5_FILIAL + U5_CPF
	
			If ! SU5->( DbSeek( cFilSU5 + aCPF[ nX ] ) )
			
				u_CSGERLog( 2, nHandle, "[Contato: " + aCPF[ nX ] + " não encontrado.] " )
			
			Else                      
			
				u_CSGERLog( 2, nHandle, "[Inicio de processamento de contato]" + CRLF + "[Contato: " + SU5->U5_CODCONT + "][Nome: " + SU5->U5_CONTAT + "]" )
	
				SZ8->( DbGoTop () )
				
				Do While SZ8->( ! EoF() )
				                
					If lFilSZ8                     
						If AScan( aFilSZ8, SZ8->Z8_COD ) == 0
							SZ8->( DbSkip() )
							Loop
						EndIf
					EndIf
				             
					If AC8->( DbSeek( cFilAC8 + SU5->U5_CODCONT + "SZ8" + Space( 02 ) + SZ8->Z8_COD ) )
				        
						u_CSGERLog( 2, nHandle, "[Contato: " + SU5->U5_CODCONT + " já relacionado ao ponto de distribuicao: " + SZ8->Z8_COD + " ] " )
				       
				 	Else
	
					    // Cria relacionamento entre contato e ponto de distribuicao                     
						RecLock( "AC8", .T. )
						AC8->AC8_ENTIDA := "SZ8"
						AC8->AC8_CODENT := SZ8->Z8_COD
						AC8->AC8_CODCON := SU5->U5_CODCONT
						AC8->( MsUnlock() )			
					
						u_CSGERLog( 2, nHandle, "[Ponto de Distribuição: " + SZ8->Z8_COD + "] " +;
												"[CPF: " + aCPF[ nX ]  + "] " +;
												"[Contato: " + SU5->U5_CODCONT + "] " +;
												"[AC8 gerada: " +;
												"<AC8_ENTIDA=" + RTrim( AC8->AC8_ENTIDA ) + "> " +;
												"<AC8_CODENT=" + RTrim( AC8->AC8_CODENT ) + "> " +;
												"<AC8_CODCON=" + RTrim( AC8->AC8_CODCON ) + "> " +;
												"<R_E_C_N_O_=" + AC8->( AllTrim( Str( Recno() ) ) ) + "> " )
					
					EndIf
																	
					SZ8->( DbSkip() )
				
				EndDo
	
			EndIf
		
		EndIf
			
	Next nX

EndIf
              
u_CSGERLog( 3, nHandle )	// Fecha arquivo de log

MsgInfo( "Processamento encerrado." + CRLF + "Log gerado no Rootpath, pasta: \logpdcon\" + DtoS( Date() ) )

Return