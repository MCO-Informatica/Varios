#include "protheus.ch"
Static cnt := 0 // tratamento temporario para suprir chamada recursiva ( tmk padrao ) aguardando solucao da tot

/*
----------------------------------------------------------------------------
| Rotina    | XCSOCO       | Autor | Gustavo Prudente | Data | 14.10.2014  |
|--------------------------------------------------------------------------|
| Descricao | Consulta F3 para permitir selecao de ocorrencias por assunto |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
User Function XCSOCO
     
Local oDlgOco

Local lDebug	:= .F.                   
Local lNovaCons	:= .F.
                                
Local nOpca		:= 2

Local cGrpOpe	:= ""
Local cCodOco	:= ""
Local cCodAss	:= ""      
Local cPesq		:= Space(50)
        
Local aListOco	:= {}
Local aListAss	:= {}
Local aArea		:= GetArea()

Private oListOco
Private oSayMsg
Private oBmpAlert

cnt ++
if cnt = 3
	cnt := 0
	If lDebug
		RpcSetType( 3 )
		//	RpcSetEnv( "99", "01" )
		RpcSetEnv( "01", "02" )
	EndIf	                               
	
	// Verifica se usa a consulta de assuntos x ocorrencias, de acordo com a 
	// configuracao do grupo de atendimento
	//                   
	cGrpOpe := u_RTmkRetGrp()	// Retorna grupo do operador
	
	SU0->( DbSetOrder( 1 ) )
	SU0->( DbSeek( xFilial( "SU0" ) + cGrpOpe ) )
	
	If SU0->( FieldPos( "U0_XCONOCO" ) ) > 0 .And. SU0->U0_XCONOCO == "1"
		lNovaCons := .T.
	EndIf               
	
	If ! lNovaCons
	
		If ConPad1( ,,, "OCO" )
		    cCodOco := SU9->U9_CODIGO		
		EndIf
		
	Else
	
		// Cria dialog para selecao de assuntos x ocorrencias
		oDlgOco := MSDialog():New( 180, 180, 600, 900, "Assuntos x Ocorrências",,,,, CLR_BLACK, CLR_WHITE,,, .T. )  // Ativa diálogo centralizado
	
		// Painel para listbox de assuntos do grupo                                           
		oPnlListAss		 	:= tPanel():New( 00, 00, "", oDlgOco,,.T.,,,, 180, 10, .F., .T. )
		oPnlListAss:Align	:= CONTROL_ALIGN_LEFT
		                                            
		// Painel para listbox de ocorrencias do assunto posicionado
		oPnlListOco		 	:= tPanel():New( 00, 00, "", oDlgOco,,.T.,,,, 180, 10, .F., .T. )
		oPnlListOco:Align	:= CONTROL_ALIGN_RIGHT
		
		// Painel de botoes
		oPnlLin1 			:= tPanel():New( 00, 00, "", oDlgOco,,.T.,,,, 02, 02 )
		oPnlLin1:Align		:= CONTROL_ALIGN_BOTTOM                                     
		
		oPnlBut 			:= tPanel():New( 00, 00, "", oDlgOco,,.T.,,,, 10, 11 )
		oPnlBut:Align		:= CONTROL_ALIGN_BOTTOM
		
		oPnlLin2 			:= tPanel():New( 00, 00, "", oDlgOco,,.T.,,,, 02, 02 )
		oPnlLin2:Align		:= CONTROL_ALIGN_BOTTOM                                     
		
		// Painel para opcoes de pesquisa
		oPnlPesq 			:= tPanel():New( 00, 00, "", oPnlListOco,,.T.,,,, 10, 18 )
		oPnlPesq:Align		:= CONTROL_ALIGN_BOTTOM                                     
	
		// Objeto para impressao de mensagens no painel oPanelMsg
		oSayMsg			 	:= tSay():New( 03, 16, { || .T. }, oPnlBut,,,,,, .T., RGB( 255, 127, 39 ),, 250, 20 )
		oBmpAlert		 	:= TBtnBmp2():New( 00, 00, 30, 25, 'PMSINFO' , 'PMSINFO' ,,,, oPnlBut,,, .T. )	
		
		// Desabilita componentes antes de abrir a tela
		oSayMsg:Hide()
		oBmpAlert:Hide()
			
		// Botao Sair
		oBtnSair := TButton():New( 02, 02, "&Sair", oPnlBut, { || oDlgOco:End() }, 035, 011,,,,.T.,,"",,,,.F. )
		oBtnSair:Align := CONTROL_ALIGN_RIGHT                             
		             
		// Botao Confirmar
		oBtnConf := TButton():New( 02, 02, "&Confirmar", oPnlBut, { || 	nOpca 	:= 1, ;
																		cCodOco := aListOco[ oListOco:nAt, 1 ], ;
																		cCodAss := aListAss[ oListAss:nAt, 1 ], ;
																		oDlgOco:End() }, 035, 011,,,,.T.,,"",,,,.F. )
		oBtnConf:Align := CONTROL_ALIGN_RIGHT                             
		
		//
		// Lista os assuntos do grupo do operador
		//
		aListAss := XRetAssGrp()
		                              
		@ 00, 00 LISTBOX oListAss FIELDS aListAss HEADER "Assunto", "Descrição" SIZE 120, 120 OF oPnlListAss PIXEL
		
		oListAss:SetArray( aListAss )
		oListAss:Align := CONTROL_ALIGN_ALLCLIENT
		
		oListAss:bLine	 := { || { aListAss[ oListAss:nAt, 1 ], aListAss[ oListAss:nAt,2 ] } }
		oListAss:bChange := { || XSincOco( aListAss[ oListAss:nAt, 1 ], @aListOco ) }
		oListAss:LHScroll := .F.  
		
		//
		// Lista as ocorrencias relacionadas ao assunto
		//
		@ 00, 00 LISTBOX oListOco FIELDS aListOco HEADER "Ocorrência", "Descrição" SIZE 120, 120 OF oPnlListOco PIXEL ;
					ON DBLCLICK ( 	nOpca := 1, ;
									cCodOco := aListOco[ oListOco:nAt, 1 ], ;
									cCodAss := aListAss[ oListAss:nAt, 1 ], ;
									oDlgOco:End() )
		                   
		aListOco := XRetOcoAss( aListAss[ oListAss:nAt, 1 ] )
		
		oListOco:SetArray( aListOco )
		oListOco:Align := CONTROL_ALIGN_ALLCLIENT
		oListOco:LHScroll := .F.  
		
		oListOco:bLine := { || { aListOco[ oListOco:nAt, 1 ], aListOco[ oListAss:nAt,2 ] } }
		
		//
		// String de pesquisa de descricao das ocorrencias                     
		// 
		oGetPesq := TGet():New( 03, 30, { |x| Iif( Pcount() > 0, cPesq := x, cPesq ) }, oPnlPesq, 114, 10, ;
								"", { || oBtnPesq:SetFocus(), .T. },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cPesq,,,, )
		                                  
		oBtnPesq := TButton():New( 04, 144, "&Buscar", oPnlPesq, { || XBtnPesq( cPesq, aListOco, oListOco ) }, 035, 011,,,,.T.,,"",,,,.F. )
		                               
		TSay():New( 05, 02, { || "Pesquisar:" }, oPnlPesq,,,,,, .T., CLR_BLUE, CLR_WHITE, 30, 08 )
		
		oDlgOco:Activate( ,,, .T. )  
		                 
		If nOpca == 1
			M->ADE_ASSUNT := cCodAss	
		EndIf
		
		RestArea( aArea )
	
	EndIf
endif		                 
Return( cCodOco )

/*
----------------------------------------------------------------------------
| Rotina    | XRetAssGrp   | Autor | Gustavo Prudente | Data | 14.10.2014  |
|--------------------------------------------------------------------------|
| Descricao | Retorna vetor com o conjunto de assuntos do grupo principal  |
|           | do operador.                                                 |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XRetAssGrp()
              
Local aRet		:= {}
Local aArea		:= GetArea()                 

Local cWhereGrp	:= ""
Local cCodAss	:= ""	// Codigo do Assunto
Local cDesAss	:= ""	// Descricao do Assunto
                  
Local cGrpOpe	:= u_RTmkRetGrp()
                                
// Seleciona os assuntos do grupo principal do operador              
cGrpOpe   := "KK_CODSU0  = '" + cGrpOpe + "' "
cWhereGrp := "% " + cGrpOpe + "%"

BeginSql Alias "TRBSKK"
                          
	SELECT 	KK_CODSU0, KK_CODSKQ
	FROM 	%Table:SKK%
	WHERE	KK_FILIAL  = %xFilial:SKK% AND
			%Exp:cWhereGrp% AND
			%notDel%

EndSql
                                                       
// Retorna vetor com todos os assuntos do grupo do operador
Do While TRBSKK->( ! EoF() )         
	
	cCodAss := AllTrim( TRBSKK->KK_CODSKQ )
	cDesAss := Tabela( "T1", cCodAss, .F. )

	AAdd( aRet, { cCodAss, cDesAss } )
                           
	TRBSKK->( DbSkip() )
	
EndDo	

TRBSKK->( DbCloseArea() )

RestArea( aArea )

Return( aRet )



/*
----------------------------------------------------------------------------
| Rotina    | XRetOcoAss   | Autor | Gustavo Prudente | Data | 21.10.2014  |
|--------------------------------------------------------------------------|
| Descricao | Retorna vetor com o conjunto de ocorrencias dos assuntos do  |
|           | grupo principal do operador.                                 |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XRetOcoAss( cCodAss )

Local aRet	:= {}
Local aArea	:= GetArea()

BeginSql Alias "TRBSU9"

    SELECT 	U9_CODIGO, U9_DESC
    FROM 	%Table:SU9%
    WHERE	U9_FILIAL = %xFilial:SU9% AND
    		U9_ASSUNTO = %Exp:cCodAss% AND
    		U9_VALIDO = '1' AND
    		%notDel%

EndSql             
                        
If TRBSU9->( EoF() )
     
	// Caso nao tenha ocorrencias, retorna linha em branco para selecao
	aRet := { { "", "" } }
	
Else	

	// Retorna array com as ocorrencias e descricoes
	Do While TRBSU9->( ! EoF() )
	
		cCodOco := TRBSU9->U9_CODIGO
		cDesOco := TRBSU9->U9_DESC
		
		Aadd( aRet, { cCodOco, cDesOco } )     
		
		TRBSU9->( DbSkip() )
	
	EndDo       

EndIf

TRBSU9->( DbCloseArea() )

RestArea( aArea )

Return( aRet )



/*
----------------------------------------------------------------------------
| Rotina    | XSincOco     | Autor | Gustavo Prudente | Data | 30.10.2014  |
|--------------------------------------------------------------------------|
| Descricao | Sincroniza lista de assuntos com lista de ocorrências, de    |
|           | acordo com o cadastro de ocorrencias.                        |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XSincOco( cCodAss, aListOco )

// Retorna lista de ocorrências do assunto posicionado
aRet := XRetOcoAss( cCodAss )

aListOco := AClone( aRet )
                         
oListOco:SetArray( aListOco )
oListOco:nAt := 1
oListOco:bLine := { || { aListOco[ oListOco:nAt, 1 ], aListOco[ oListOco:nAt, 2 ] } }
oListOco:Refresh()

Return( .T. )

      

/*
----------------------------------------------------------------------------
| Rotina    | XPesqOco     | Autor | Gustavo Prudente | Data | 30.10.2014  |
|--------------------------------------------------------------------------|
| Descricao | Sincroniza lista de assuntos com lista de ocorrências, de    |
|           | acordo com o cadastro de ocorrencias.                        |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XPesqOco( cPesq, aListOco, oListOco )

Static nPosPesq := 1		// Ultima posicao pesquisada
Static cChvPesq	:= ""		// Ultima chave de pesquisa
      
Local lRet		:= .T.
Local aRetPos	:= {}               
Local nPosIni 	:= 1

// Variavies para chave de pesquisa
cPesq := Upper( AllTrim( cPesq ) )

// Verifica qual deve ser a posicao inicial de pesquisa
If nPosPesq < Len( aListOco ) 
	nPosIni := oListOco:nAt + 1		// Pesquisa sempre a partir da proxima posicao
Else
	nPosIni := 1
EndIf
             
// Atualiza posicao de pesquisa atual
If nPosPesq > 1 
	nPosPesq := oListOco:nAt
EndIf
                                     
// Executa a pesquisa no vetor de lista de ocorrencias x assuntos   
aRetPos := XRetPos( nPosIni, cPesq, aListOco )

// Se encontrou, atualiza posicao, chave e posicionamento do listbox
If aRetPos[ 1 ]		
	nPosPesq := aRetPos[ 2 ]
	cChvPesq := cPesq
	oListOco:nAt := nPosPesq
	oListOco:Refresh()
Else                 
	// Se nao encontrou, continua a pesquisa com chamada recursiva
	If nPosPesq > 1 .Or. oListOco:nAt > 1
		nPosPesq := aRetPos[ 2 ]
		oListOco:nAt := 1
		lRet := XPesqOco( cPesq, aListOco, oListOco )
	Else                                     
		// Se a posicao eh menor que o total de ocorrencias, retorna verdadeiro
		lRet := ( aRetPos[ 2 ] < Len( aListOco ) )
	EndIf
EndIf
	
Return( lRet )
                       
                     
    
/*
----------------------------------------------------------------------------
| Rotina    | XRetPos      | Autor | Gustavo Prudente | Data | 26.11.2014  |
|--------------------------------------------------------------------------|
| Descricao | Realiza a pesquisa no vetor de ocorrencias por assunto       |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XRetPos( nPosIni, cPesq, aListOco )

Local lRet 		:= .F.                            

Local nPos 		:= 1
Local nLenOco	:= Len( aListOco )

Local cDesOco	:= ""

For nPos := nPosIni To nLenOco
	cDesOco := Upper( AllTrim( aListOco[ nPos, 2 ] ) )
	// Se a chave esta na descricao da ocorrencia, entao encontrou.
	If cPesq $ cDesOco
		lRet := .T.
		Exit
	EndIf
Next nX
		
Return( { lRet, nPos } )       
	
	

/*
-----------------------------------------------------------------------------
| Rotina    | MsgStatus    | Autor | Gustavo Prudente | Data | 25.11.2014   |
|---------------------------------------------------------------------------|
| Descricao | Mostra mensagens de aviso na tela de pesquisa de ocorrencias  |
|---------------------------------------------------------------------------|
| Parametros| EXPC1 - Mensagem para exibicao na barra de status             |
|---------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                           |
-----------------------------------------------------------------------------
*/
Static Function MsgStatus( cMsg )

Default cMsg := ""

oSayMsg:cCaption := cMsg

If ! Empty( cMsg )
	// Mostra o texto de cMsg na barra de mensagem
	oSayMsg:Show()
	oBmpAlert:Show()	// Alerta
Else
	// Oculta objetos da barra de mensagem
	oSayMsg:Hide()
	oBmpAlert:Hide()
EndIf

oSayMsg:Refresh()
oSayMsg:SetFocus()

Return( .T. )
                                                     
      
             
/*
----------------------------------------------------------------------------
| Rotina    | XBtnPesq     | Autor | Gustavo Prudente | Data | 26.11.2014  |
|--------------------------------------------------------------------------|
| Descricao | Realiza a chamada da rotina de pesquisa de assuntos x        |
|           | ocorrencias.                                                 |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XBtnPesq( cPesq, aListOco, oListOco )

MsgStatus()
                               
// Se nao encontrou a chave de pesquisa na lista de ocorrencias
If ! XPesqOco( cPesq, aListOco, oListOco )
	If Empty( cPesq )
		MsgStatus( 'A chave de pesquisa não foi informada.' )
	Else	
		MsgStatus( 'A chave de pesquisa "' + AllTrim( cPesq ) + '" não foi encontrada.' )
	EndIf	
EndIf

Return( .T. )