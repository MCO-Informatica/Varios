#include "protheus.ch"

#define POS_OK		1
#define POS_CODPD	2
#define POS_DESPD	3

/*
------------------------------------------------------------------------------
| Rotina    | CSEst001     | Autor | Gustavo Prudente | Data | 12.01.2016    |
|----------------------------------------------------------------------------|
| Descricao | Permitir realizar a manutencao dos pontos de distribuicao do   |
|           | contato posicionado.                                           |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
User Function CSEst001
    
//Campos que serao usados no aHeader.
Local cHeader   	:= "AC8_CODENT"  

//Campos que serao usados no aCols.
Local cItens   		:= "AC8_CODENT"
Local nUsado		:= 0 

Private oGetDAC8
Private cLinhaOk 	:= ".T."
Private cTudoOk  	:= ""       
Private cDescPonto	:= ""
Private aCols		:= {}                                

// Configura tecla F3 para nova consulta
SetKey( VK_F3, { || VldConPD( oGetDAC8 ) .And. CSConPD() } )

// Montando aHeader para a Getdados
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("AC8")

aHeader := {}

Do While !Eof() .And. (SX3->X3_ARQUIVO == "AC8")
	
	If X3USO(SX3->X3_USADO) .And. AllTrim(SX3->X3_CAMPO) $ cItens
		nUsado ++
		AADD( aHeader, { 	TRIM(X3_TITULO)	, ;
					  		X3_CAMPO		, ;
							X3_PICTURE		, ;
							X3_TAMANHO		, ;
							X3_DECIMAL		, ;
							X3_VALID		, ;
							X3_USADO		, ;
							X3_TIPO			, ; 
							X3_ARQUIVO		, ;
							X3_CONTEXT 		} )
	EndIf
	
	DbSkip()
	
EndDo
                                     
nUsado ++

// Descricao do ponto de distribuicao
AAdd( aHeader, { 	"Descrição"		, ;
			   		"cDescPonto"	, ;
					""				, ;
					40				, ;
					0				, ;
					""				, ;
					"€€€€€€€€€€€€€€", ;
					"C"				, ; 
					"AC8"			, ;
					"V"		 		} )

nUsado ++

//Adiciono o Recno para controle de exclusão e gravação.
AAdd( aHeader, { 	"Recno"			, ;
			   		"RECNO"			, ;
					""				, ;
					15				, ;
					0				, ;
					""				, ;
					"€€€€€€€€€€€€€€", ;
					"N"				, ; 
					"AC8"			, ;
					"V"		 		} )
                                                  
cCodCon := SU5->U5_CODCONT
                    
// Carrega pontos de distribuicao no aCols
aCols := CSEstAtuPD( cCodCon )

DEFINE MSDIALOG oDlg TITLE "Pontos de Distribuição x Contato" FROM 0, 0 TO 600, 800 PIXEL

oDlg:lMaximized := .T.

// Painel dados do contato
oPanelCont		 := tPanel():New( 01, 01,, oDlg,,.T.,,,, 1, 50, .F., .F. )
oPanelCont:Align := CONTROL_ALIGN_TOP
                                
oGroup1 := TGroup():New( 02, 02, 130, 130, "Informações do Contato", oPanelCont,,, .T. )
oGroup1:Align    := CONTROL_ALIGN_ALLCLIENT

// Painel getdados
oPanelGetD		 := tPanel():New( 01, 01,, oDlg,,.T.,,,, 1, 32, .F., .F. )
oPanelGetD:Align := CONTROL_ALIGN_ALLCLIENT

// Painel da barra de botoes
oPanelBtn		 := tPanel():New( 01, 01,, oDlg,,.T.,,,, 1, 13, .F., .F. )
oPanelBtn:Align	 := CONTROL_ALIGN_BOTTOM

oBtnFechar := TButton():New( 02, 02, "&Fechar", oPanelBtn, { || oDlg:End() }, 045, 012,,,,.T.,,"",,,,.F. )
oBtnFechar:Align := CONTROL_ALIGN_RIGHT

oBtnGravar := TButton():New( 02, 02, "&Gravar", oPanelBtn, { || CSProcGrv( oDlg, cCodCon ), ;
																aCols := CSEstAtuPD( cCodCon ), ;
																CSAtuGD( aCols ) }, 045, 012,,,,.T.,,"",,,,.F. )
oBtnGravar:Align := CONTROL_ALIGN_RIGHT
																
oBtnRemover := TButton():New( 02, 02, "&Remover Todos", oPanelBtn, { || CSDelPtos( aCols ), oGetDAC8:oBrowse:SetFocus() }, 045, 012,,,,.T.,,"",,,,.F. )
oBtnRemover:Align := CONTROL_ALIGN_RIGHT
															
@ 015, 005 SAY "Código: " PIXEL SIZE 55, 9 OF oPanelCont 
@ 014, 035 MSGET oCodCon VAR cCodCon SIZE 080, 9 PICTURE "@!" OF oPanelCont Pixel WHEN .F.

@ 015, 130 SAY "Nome: " PIXEL SIZE 55, 9 OF oPanelCont 
@ 014, 150 MSGET oNome VAR SU5->U5_CONTAT SIZE 250, 9 PICTURE "@!" OF oPanelCont Pixel WHEN .F.
                                                
@ 030, 005 SAY "CPF/CNPJ:" PIXEL SIZE 55, 9 OF oPanelCont 
@ 029, 035 MSGET oNome VAR SU5->U5_CPF SIZE 080, 9 PICTURE "@!" OF oPanelCont Pixel WHEN .F.

oGetDAC8 := MsNewGetDados():New( 0, 2, 2, 1, GD_INSERT + GD_DELETE, /*"u_GetDLinOk()"/*cLinOk*/, /*cTudoOk*/, /*cIniCpos*/ , ;
				{ "AC8_CODENT" } /*aAlter*/, /*nFreeze*/, 1000, /*cFieldOk*/, /*cSuperDel*/, /*cDelOk*/, ;
				oPanelGetD, aHeader, aCols)

oGetDAC8:oBrowse:blDblClick := { || VldConPD( oGetDAC8 ) .And. CSConPD() }
oGetDAC8:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE DIALOG oDlg

SetKey( VK_F3, { || } )

Return

                
/*
------------------------------------------------------------------------------
| Rotina    | CSProcGrv    | Autor | Gustavo Prudente | Data | 20.01.2016    |
|----------------------------------------------------------------------------|
| Descricao | Processa gravacao dos pontos de distribuicao com apresentacao  |
|           | de gauge de processamento.                                     |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function CSProcGrv( oDlg, cCodCon )

MsgMeter( { |oMeter,oText| CSGrvPto( cCodCon, oMeter, oText ) }, "Aguarde...", "Pontos de Distribuição x Contato", .T. )

Aviso( "Atenção", "Alterações gravadas com sucesso.", { "OK" } )

Return .T.

                
/*
------------------------------------------------------------------------------
| Rotina    | CSGrvPto     | Autor | Gustavo Prudente | Data | 14.01.2016    |
|----------------------------------------------------------------------------|
| Descricao | Grava novos pontos de distribuicao na base de dados, a partir  |
|           | das informacoes cadastradas na aCols.                          |
|----------------------------------------------------------------------------|
| Parametros| EXPC1 - Codigo do contato                                      |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function CSGrvPto( cCodCon, oMeter, oText )

Local nX		:= 1                     
Local nTotReg	:= Len( oGetDAC8:aCols )
Local cCodEnt	:= ""
Local aColsTmp	:= oGetDAC8:aCols

Local cFilAC8	:= xFilial( "AC8" )
Local cFilSZ8	:= xFilial( "SZ8" )
                        
oMeter:nTotal := nTotReg

For nX := 1 To nTotReg
                                
	IncMeter( oMeter, oText, nX, "Processando linha: " + LTrim( Str( nX ) ) + " de " + LTrim( Str( nTotReg ) ) )

	cCodEnt := aColsTmp[ nX, 1 ]
           
 	If ! Empty( cCodEnt )
 
	 	If ! aColsTmp[ nX, Len( aColsTmp[ nX ] ) ]
	                                                                                         
			// Realiza a inclusao do ponto de distribuicao relacionado ao contato posicionado
			AC8->( DbSetOrder( 1 ) )
	                                                                                         
			If ! AC8->( DbSeek( cFilAC8 + cCodCon + "SZ8" + cFilSZ8 + cCodEnt ) )
				RecLock( "AC8", .T. )
				AC8->AC8_FILIAL := cFilAC8
				AC8->AC8_FILENT := cFilSZ8
				AC8->AC8_ENTIDA := "SZ8"
				AC8->AC8_CODENT := cCodEnt
				AC8->AC8_CODCON := cCodCon
				AC8->( MsUnlock() )
			EndIf
	
		Else
	                   
			// Realiza a exclusao do ponto de distribuicao caso o mesmo exista para o contato
			If AC8->( DbSeek( cFilAC8 + cCodCon + "SZ8" + cFilSZ8 + cCodEnt ) )
				RecLock( "AC8", .F. )
				AC8->( DbDelete() )
				AC8->( MsUnlock() )
	        EndIf
	
		EndIf

	EndIf
	
Next nX 

Return Nil                                      
      

/*
------------------------------------------------------------------------------
| Rotina    | IncMeter     | Autor | Gustavo Prudente | Data | 20.01.2016    |
|----------------------------------------------------------------------------|
| Descricao | Atualizar gauge de progresso do processamento                  |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function IncMeter( oMeter, oText, nCount, cText )

oText:SetText( cText )

bBlock := { || oMeter:Set(nCount), SysRefresh() }

Eval( bBlock )

Return

                               
/*
-----------------------------------------------------------------------------
| Rotina    | CSEstAtuPD   | Autor | Gustavo Prudente | Data | 14.01.2016   |
|---------------------------------------------------------------------------|
| Descricao | Monta aCols a partir dos pontos de distribuicao cadastrados   |
|---------------------------------------------------------------------------|
| Parametros| EXPC1 - Codigo do contato                                     |
|---------------------------------------------------------------------------|
| Retorno   | EXPA1 - Vetor com os pontos de distribuicao selecionados.     |
|---------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                           |
-----------------------------------------------------------------------------
*/
Static Function CSEstAtuPD( cCodCon )
                                    
Local aArea		:= GetArea()
Local aColsTmp	:= {}
Local cFilSZ8	:= xFilial("AC8")
     
AC8->( DbSetOrder( 1 ) )
AC8->( DbSeek( cFilSZ8 + cCodCon + "SZ8" ) )

SZ8->( DbSetOrder( 1 ) )
	    
Do While AC8->( !EoF() ) .And. AC8->AC8_CODCON == cCodCon .And. AC8->AC8_ENTIDA == "SZ8"
	SZ8->( DbSeek( cFilSZ8 + AC8->AC8_CODENT ) )
	AAdd( aColsTmp, { AC8->AC8_CODENT, SZ8->Z8_DESC, AC8->( Recno() ), .F. } )
	AC8->( DbSkip() )
EndDo 
                           
If Len( aColsTmp ) == 0
	AAdd( aColsTmp, { "", "", 0, .F. } )
EndIf
                      
RestArea( aArea )

Return( aColsTmp )


/*
-----------------------------------------------------------------------------
| Rotina    | CSAtuGD      | Autor | Gustavo Prudente | Data | 19.01.2016   |
|---------------------------------------------------------------------------|
| Descricao | Realiza refresh na lista da getdados a partir de novo aCols   |
|---------------------------------------------------------------------------|
| Parametros| EXPA1 - ACols temporario para atualizacao e refresh           |
|---------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                           |
-----------------------------------------------------------------------------
*/
Static Function CSAtuGD( aColsTmp )

oGetDAC8:SetArray( aColsTmp )
oGetDAC8:oBrowse:Refresh()
oGetDAC8:GoBottom()

Return .T.                                                                   


/*
------------------------------------------------------------------------------
| Rotina    | CSDelPtos    | Autor | Gustavo Prudente | Data | 19.01.2016    |
|----------------------------------------------------------------------------|
| Descricao | Apaga a lista de pontos de distribuicao do contato posicionado |
|----------------------------------------------------------------------------|
| Parametros| EXPA1 - ACols temporario para atualizacao da getdados          |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function CSDelPtos( aColsTmp )

Local nPosDel := Len( aColsTmp[ 1 ] )

// Caso exista algum item com Recno, percorre os itens marcando como deletado              
If AScan( aColsTmp, { |x| x[ 3 ] > 0 } ) > 0
                           
	If MsgYesNo( "Deseja marcar os pontos de distribuição para exclusão?", "Pontos de Distribuição x Contato" )
                    
		For nX := 1 To Len( aColsTmp )
			aColsTmp[ nX, nPosDel ] := .T.
		Next nX
     
		Aviso( "Atenção", 'Pontos de Distribuição marcados com sucesso.' + CRLF + CRLF + 'Selecione a opção "Gravar" para confirmar a exclusão.', { "Ok" }, 2 )

	EndIf

// Caso nao exista nenhum ponto de distribuicao gravado, inicializa aCols
Else 
	
	aColsTmp := { { "", "", 0, .F. } }
	
EndIf

CSAtuGD( aColsTmp )		

Return .T.


//
//
// Rotinas referentes ao funcionamento da consulta dos pontos de distribuicao
//
//


/*
-----------------------------------------------------------------------------
| Rotina     | CSConPD      | Autor | Gustavo Prudente | Data | 13.01.2016  |
|---------------------------------------------------------------------------|
| Descricao  | Rotina de consulta dos pontos de distribuicao                |
|---------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                          |
-----------------------------------------------------------------------------
*/
Static Function CSConPD()

Local oListPD                          
Local aListPD := {}                                                                    
Local lTodos  := .T.
Local cPesq   := Space(50)   

Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )
                                
Private oDlgConPD

// Cria dialog para selecao de assuntos x ocorrencias
oDlgConPD := MSDialog():New( 180, 180, 600, 900, "Pontos de Distribuição",,,,, CLR_BLACK, CLR_WHITE,,, .T. )  // Ativa diálogo centralizado

// Painel para listbox de ocorrencias do assunto posicionado
oPnlPtoDist		 	:= tPanel():New( 00, 00, "", oDlgConPD,,.T.,,,, 180, 10, .F., .T. )
oPnlPtoDist:Align	:= CONTROL_ALIGN_ALLCLIENT

// Painel de botoes
oPnlLin1 			:= tPanel():New( 00, 00, "", oDlgConPD,,.T.,,,, 02, 02 )
oPnlLin1:Align		:= CONTROL_ALIGN_BOTTOM                                     

oPnlBut 			:= tPanel():New( 00, 00, "", oDlgConPD,,.T.,,,, 10, 11 )
oPnlBut:Align		:= CONTROL_ALIGN_BOTTOM

oPnlLin2 			:= tPanel():New( 00, 00, "", oDlgConPD,,.T.,,,, 02, 02 )
oPnlLin2:Align		:= CONTROL_ALIGN_BOTTOM                                     

// Painel para opcoes de pesquisa
oPnlPesq 			:= tPanel():New( 00, 00, "", oPnlPtoDist,,.T.,,,, 10, 18 )
oPnlPesq:Align		:= CONTROL_ALIGN_BOTTOM                                     

// Objeto para impressao de mensagens no painel oPanelMsg
oSayMsg			 	:= tSay():New( 03, 16, { || .T. }, oPnlBut,,,,,, .T., RGB( 255, 127, 39 ),, 250, 20 )
oBmpAlert		 	:= TBtnBmp2():New( 00, 00, 30, 25, 'PMSINFO' , 'PMSINFO' ,,,, oPnlBut,,, .T. )	

// Desabilita componentes antes de abrir a tela
oSayMsg:Hide()
oBmpAlert:Hide()
	
// Botao Sair
oBtnSair := TButton():New( 02, 02, "&Sair", oPnlBut, { || oDlgConPD:End() }, 035, 011,,,,.T.,,"",,,,.F. )
oBtnSair:Align := CONTROL_ALIGN_RIGHT                             
             
// Botao Confirmar
oBtnConf := TButton():New( 02, 02, "&Confirmar", oPnlBut, { || 	XSetPD( aListPD ), ;
																oDlgConPD:End() }, 035, 011,,,,.T.,,"",,,,.F. )
oBtnConf:Align := CONTROL_ALIGN_RIGHT                             

// Lista as ocorrencias relacionadas ao assunto
//
@ 00, 00 LISTBOX oListPD FIELDS aListPD HEADER " ", "Código", "Nome do Ponto de Distribuição"  SIZE 120, 120 OF oPnlPtoDist PIXEL ;
			ON DBLCLICK( Inverte( oListPD, @aListPD ) )
                   
aListPD := XRetPD()

oListPD:SetArray( aListPD )
oListPD:Align := CONTROL_ALIGN_ALLCLIENT
oListPD:LHScroll := .F.  

oListPD:bLine := { || { Iif( aListPD[ oListPD:nAt, POS_OK ], oOk, oNo ) , ;
						aListPD[ oListPD:nAt, POS_CODPD ], ;
						aListPD[ oListPD:nAt, POS_DESPD ] } }

// String de pesquisa de descricao das ocorrencias                     
// 
oGetPesq := TGet():New( 03, 55, { |x| Iif( Pcount() > 0, cPesq := x, cPesq ) }, oPnlPesq, 135, 10, ;
						"", { || oBtnPesq:SetFocus(), .T. },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cPesq,,,, )
                                  
oBtnPesq := TButton():New( 04, 194, "&Buscar", oPnlPesq, { || XBtnPesq( cPesq, aListPD, oListPD ) }, 035, 011,,,,.T.,,"",,,,.F. )
                               
TSay():New( 05, 02, { || "Pesquisar por nome:" }, oPnlPesq,,,,,, .T., CLR_BLUE, CLR_WHITE, 60, 08 )
                                           
@ 005, 250 CHECKBOX oChkMar VAR lTodos PROMPT "Inverte Seleção" MESSAGE SIZE 100, 010 PIXEL OF oPnlPesq;
	ON CLICK { || MarcaTodos( oListPD, @aListPD ), SetArray( @oListPD, aListPD ) }

oListPD:SetFocus()

oDlgConPD:Activate( ,,, .T. )  
                 
Return


/*
----------------------------------------------------------------------------
| Rotina    | XRetPD       | Autor | Gustavo Prudente | Data | 13.01.2016  |
|--------------------------------------------------------------------------|
| Descricao | Monta e retorna a lista de pontos de distribuicao            |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XRetPD()

Local aRet	:= {}
Local aArea	:= GetArea()

BeginSql Alias "TRBSZ8"

    SELECT 	Z8_COD, Z8_DESC
    FROM 	%Table:SZ8%
    WHERE	Z8_FILIAL = %xFilial:SZ8% AND
    		%notDel%
    ORDER BY Z8_COD

EndSql             
                        
If TRBSZ8->( EoF() )
     
	// Caso nao tenha pontos de distribuicao, retorna linha em branco para selecao
	aRet := { { .F., "", "" } }
	
Else	

	// Retorna array com as ocorrencias e descricoes
	Do While TRBSZ8->( ! EoF() )                        
		If ! Empty( TRBSZ8->Z8_COD )
			AAdd( aRet, { .F., TRBSZ8->Z8_COD, TRBSZ8->Z8_DESC } )
		EndIf
		TRBSZ8->( DbSkip() )
	EndDo

EndIf

TRBSZ8->( DbCloseArea() )

RestArea( aArea )

Return( aRet )




/*
----------------------------------------------------------------------------
| Rotina    | XBtnPesq     | Autor | Gustavo Prudente | Data | 13.01.2016  |
|--------------------------------------------------------------------------|
| Descricao | Realiza a chamada da rotina de pesquisa de pontos de         |
|           | distribuicao                                                 |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XBtnPesq( cPesq, aListPD, oListPD )

MsgStatus()
                               
// Se nao encontrou a chave de pesquisa na lista de pontos de distribuicao
If ! XPesqPD( cPesq, aListPD, oListPD )
	If Empty( cPesq )
		MsgStatus( 'A chave de pesquisa não foi informada.' )
	Else	
		MsgStatus( 'A chave de pesquisa "' + AllTrim( cPesq ) + '" não foi encontrada.' )
	EndIf
EndIf

Return( .T. )


/*
-----------------------------------------------------------------------------
| Rotina    | MsgStatus    | Autor | Gustavo Prudente | Data | 13.01.2016   |
|---------------------------------------------------------------------------|
| Descricao | Mostra mensagens de aviso na tela de pesquisa                 |
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
| Rotina    | XPesqPD      | Autor | Gustavo Prudente | Data | 14.01.2016  |
|--------------------------------------------------------------------------|
| Descricao | Regra de pesquisa sequencial na lista de pontos              |
|--------------------------------------------------------------------------|
| Parametros| EXPC1 - Chave de pesquisa                                    |
|           | EXPC2 - Lista de pontos de distribuicao                      |
|           | EXPA3 - Objeto de lista de pontos de distribuicao            |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XPesqPD( cPesq, aListPD, oListPD )

Static nPosPesq := 1		// Ultima posicao pesquisada
Static cChvPesq	:= ""		// Ultima chave de pesquisa
      
Local lRet		:= .T.
Local aRetPos	:= {}               
Local nPosIni 	:= 1

// Variavies para chave de pesquisa
cPesq := Upper( AllTrim( cPesq ) )

// Verifica qual deve ser a posicao inicial de pesquisa
If nPosPesq < Len( aListPD ) 
	nPosIni := oListPD:nAt + 1		// Pesquisa sempre a partir da proxima posicao
Else
	nPosIni := 1
EndIf
             
// Atualiza posicao de pesquisa atual
If nPosPesq > 1 
	nPosPesq := oListPD:nAt
EndIf
                                     
// Executa a pesquisa no vetor de lista 
aRetPos := XRetPos( nPosIni, cPesq, aListPD )

// Se encontrou, atualiza posicao, chave e posicionamento do listbox
If aRetPos[ 1 ]		
	nPosPesq := aRetPos[ 2 ]
	cChvPesq := cPesq
	oListPD:nAt := nPosPesq
	oListPD:Refresh()
Else                 
	// Se nao encontrou, continua a pesquisa com chamada recursiva
	If nPosPesq > 1 .Or. oListPD:nAt > 1
		nPosPesq := aRetPos[ 2 ]
		oListPD:nAt := 1
		lRet := XPesqPD( cPesq, aListPD, oListPD )
	Else                                     
		// Se a posicao eh menor que o total da lista, retorna verdadeiro
		lRet := ( aRetPos[ 2 ] < Len( aListPD ) )
	EndIf
EndIf
	
Return( lRet )


/*
----------------------------------------------------------------------------
| Rotina    | XRetPos      | Autor | Gustavo Prudente | Data | 14.01.2016  |
|--------------------------------------------------------------------------|
| Descricao | Percorre a lista a partir da posicao inicial buscando a      |
|           | chave informada.                                             |
|--------------------------------------------------------------------------|
| Parametros| EXPN1 - Posicao inicial de pesquisa                          |
|           | EXPC2 - Chave de pesquisa                                    |
|           | EXPA3 - Lista dos pontos de distribuicao para pesquisa       |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XRetPos( nPosIni, cPesq, aListPD )

Local lRet 		:= .F.                            

Local nPos 		:= 1
Local nLenOco	:= Len( aListPD )

Local cDesOco	:= ""

For nPos := nPosIni To nLenOco
	cDescri := Upper( AllTrim( aListPD[ nPos, POS_DESPD ] ) )
	If cPesq $ cDescri
		lRet := .T.
		Exit
	EndIf
Next nX
		
Return( { lRet, nPos } )       

/*
-----------------------------------------------------------------------------
| Rotina     | XRetPD       | Autor | Gustavo Prudente | Data | 13.01.2016  |
|---------------------------------------------------------------------------|
| Descricao  | Monta e retorna a lista de pontos de distribuicao            |
|---------------------------------------------------------------------------|
| Parametros | EXPA1 - Lista com os pontos de distribuicao selecionados     |
|---------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                          |
-----------------------------------------------------------------------------
*/
Static Function XSetPD( aListPD )

Local nX 	 	:= 1  
Local nPosPD 	:= 0         
Local aColsTmp	:= AClone( oGetDAC8:aCols )

For nX := 1 To Len( aListPD )
                                                                 
	nPosPD := AScan( aColsTmp, { |x| AllTrim( x[ 1 ] ) == AllTrim( aListPD[ nX, POS_CODPD ] ) .And. ! x[ Len( x ) ] } )

	If aListPD[ nX, POS_OK ] .And. nPosPD == 0
		If ! Empty( aColsTmp[ Len( aColsTmp ), 1 ] )
			AAdd( aColsTmp, { aListPD[ nX, POS_CODPD ], aListPD[ nX, POS_DESPD ], 0, .F. } )
		Else
			aColsTmp[ Len( aColsTmp ), 1 ] := aListPD[ nX, POS_CODPD ]
			aColsTmp[ Len( aColsTmp ), 2 ] := aListPD[ nX, POS_DESPD ]		
		EndIf	
	EndIf

Next nX
                      
// Caso nao tenha atualizacao, apaga linha em branco do final da lista                          
If Len( aColsTmp ) == Len( oGetDAC8:aCols ) .And. Empty( aColsTmp[ Len( aColsTmp ), 1 ] )
	aColsTmp := ADel( aColsTmp, Len( aColsTmp ) )
	aColsTmp := ASize( aColsTmp, Len( aColsTmp ) - 1 )
EndIf	

// Realiza atualizacao e refresh da getdados
CSAtuGD( aColsTmp )

Return .T.

/*
----------------------------------------------------------------------------
| Rotina    | Inverte     | Autor | Gustavo Prudente | Data | 15.01.2016   |
|--------------------------------------------------------------------------|
| Descricao | Inverte selecao dos pontos de distribuicao                   |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de listbox com a lista dos postos             |
|           | EXPA2 - Array com os pontos de distribuicao                  |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function Inverte( oListPD, aListPD )
                                                                  
If ! Empty( aListPD[ oListPD:nAt, POS_CODPD ] )
	aListPD[ oListPD:nAt, POS_OK ] := ! aListPD[ oListPD:nAt, POS_OK ]
EndIf	

Return .T.


/*
----------------------------------------------------------------------------
| Rotina    | SetArray    | Autor | Gustavo Prudente | Data | 15.01.2016   |
|--------------------------------------------------------------------------|
| Descricao | Atualiza array com o resultado dos pontos de distribuicao    |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de lista de pontos de distribuicao            |
|           | EXPA2 - Array com os pontos de distribuicao                  |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/      
Static Function SetArray( oListPD, aListPD )
      
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )

oListPD:SetArray( aListPD )

oListPD:bLine := { || 	{ Iif( aListPD[ oListPD:nAt, 01 ], oOk, oNo ) , ;
  						  aListPD[ oListPD:nAt, 02 ] , ;
  						  aListPD[ oListPD:nAt, 03 ] } }

oListPD:Refresh()

Return .T.
      

/*
----------------------------------------------------------------------------
| Rotina    | MarcaTodos  | Autor | Gustavo Prudente | Data | 15.01.2016   |
|--------------------------------------------------------------------------|
| Descricao | Marca todos os pontos de distribuicao                        |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto de listbox dos pontos de distribuicao         |
|           | EXPA2 - Array com os pontos de distribuicao                  |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function MarcaTodos( oListPD, aListPD )

Local nX

For nX := 1 To Len( aListPD )
	If !Empty( aListPD[ nX, POS_CODPD ] )
		aListPD[ nX, POS_OK ] := ! aListPD[ nX, POS_OK ]
	EndIf	
Next nX
      
Return .T.


/*
----------------------------------------------------------------------------
| Rotina    | VldConPD    | Autor | Gustavo Prudente | Data | 18.01.2016   |
|--------------------------------------------------------------------------|
| Descricao | Valida chamada da consulta de pontos de distribuicao         |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto getdados com os pontos de distribuicao        |
|           |         associados ao contato.                               |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/                                                                            
Static Function VldConPD( oGetDAC8 )

Return( oGetDAC8:aCols[ oGetDAC8:oBrowse:nAt, 3 ] == 0 .And. ;
		! oGetDAC8:aCols[ oGetDAC8:oBrowse:nAt, Len( oGetDAC8:aCols[ oGetDAC8:oBrowse:nAt ] ) ] )