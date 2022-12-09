#include "protheus.ch"

/*
---------------------------------------------------------------------------
| Rotina    | CTSDK23     | Autor | Gustavo Prudente | Data | 22.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Rotina para totalizacao dos atendimentos realizados para o  |
|           | Pedido GAR ou Pedido Site vs Campanha.                      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function CTSDK23()

Local lRet		:= .T.

Local nTotSite	:= 0
Local nTotGAR 	:= 0
Local nOpca		:= 0

Local cAlias	:= ""
Local cStrCam	:= ""
Local cXGrAPesq	:= GetNewPar( "MV_XGAPESQ", "" )
Local cGrupo	:= XRetGrupo()

// Somente executa totalizacao de pedidos e aviso ao operador, se faz parte
// dos grupos de atendimento que devem exibir o aviso 
//
If ! Empty( cXGrAPesq ) .And. cGrupo $ cXGrAPesq
                     
	cAlias := Alias()
	
	// Totaliza pedido GAR ou pedido Site por Campanha
	//
	XTotPed( @nTotSite, @nTotGAR )
	
	// Se houver atendimentos para o mesmo Pedido GAR/Site e campanha, exibe 
	// mensagem de aviso ao operador.
	//
	cStrCam := "Campanha : " + AllTrim( M->ADE_CODCAM ) + "-" + AllTrim( Posicione( "SUO", 1, xFilial( "SUO" ) + M->ADE_CODCAM, "UO_DESC" ) )
	                  
	If nTotSite > 0
	
		nOpca := Aviso(	"Atendimentos vs Pedidos", ;
					Iif( nTotSite > 1, "Foram ", "Foi " ) + "encontrado(s) " + AllTrim( Str( nTotSite ) ) + ;
					" atendimento(s) para : " + CRLF + CRLF + "Pedido Site : " + AllTrim( M->ADE_XPSITE ) + CRLF + ;
					cStrCam, { "Visualizar", "Continuar" }, 2 )
	
		// Gatilha a pesquisa de historico com o pedido site 
		If nOpca == 1 
			u_PesqHist( .F., "ADE_XPSITE", AllTrim( M->ADE_XPSITE ), .T. )
		EndIf
	
	ElseIf nTotGAR > 0
	
		nOpca := Aviso(	"Atendimentos vs Pedidos", ;
					Iif( nTotGAR > 1, "Foram ", "Foi " ) + "encontrado(s) " + AllTrim( Str( nTotGAR ) ) + ;
					" atendimento(s) para : " + CRLF + CRLF + "Pedido GAR : " + AllTrim( M->ADE_PEDGAR ) + CRLF + ;
					cStrCam, { "Visualizar", "Continuar" }, 2 )
	
		// Gatilha a pesquisa de historico com o pedido site 
		If nOpca == 1
			u_PesqHist( .F., "ADE_PEDGAR", AllTrim( M->ADE_PEDGAR ), .T. )
		EndIf
	
	EndIf                 
	     
	DbSelectArea( cAlias )

EndIf
	
Return lRet


/*
---------------------------------------------------------------------------
| Rotina    | XTotPed     | Autor | Gustavo Prudente | Data | 23.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Rotina para totalizacao dos atendimentos realizados para o  |
|           | Pedido GAR ou Pedido Site vs Campanha.                      |
|-------------------------------------------------------------------------|
| Retorno   | Total de Pedido GAR ou Pedido Site vs Campanha encontrados  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function XTotPed( nTotSite, nTotGar )

Local cPedSite	:= M->ADE_XPSITE
Local cPedGAR	:= M->ADE_PEDGAR
Local cCodCam	:= M->ADE_CODCAM
Local cAlias	:= Alias()

Local nRet		:= 0

If ! Empty( cPedSite )

	BeginSql Alias "TOTSITE"
	      
		SELECT COUNT( R_E_C_N_O_ ) AS TOTAL
		FROM %Table:ADE% 
		WHERE	ADE_FILIAL = %xFilial:ADE% AND
				ADE_XPSITE = %Exp:cPedSite% AND
				ADE_CODCAM = %Exp:cCodCam% AND
				%notDel%
	
	EndSql
	
	nTotSite := TOTSITE->TOTAL
	
	TOTSITE->( DbCloseArea() )

ElseIf ! Empty( cPedGar )

	BeginSql Alias "TOTGAR"
	
		SELECT COUNT( R_E_C_N_O_ ) AS TOTAL
		FROM %Table:ADE%
		WHERE	ADE_FILIAL = %xFilial:ADE% AND
				ADE_PEDGAR = %Exp:cPedGar% AND
				ADE_CODCAM = %Exp:cCodCam% AND
				%notDel%
	
	EndSql
	
	nTotGar := TOTGAR->TOTAL
	
	TOTGAR->( DbCloseArea() )

EndIf
           
DbSelectArea( cAlias )

Return Nil


/*
-------------------------------------------------------------------------------
| Rotina     | XRetGrupo      | Autor | Gustavo Prudente | Data | 25.09.2014  |
|-----------------------------------------------------------------------------|
| Descricao  | Retorna o grupo do usuario logado no Call Center               |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function XRetGrupo()

Local cCodUser	:= AllTrim( TkOperador() )
Local cGrupo	:= ""

SU7->( DbSetOrder( 1 ) )
SU7->( DbSeek( xFilial() + cCodUser ) )

cGrupo := SU7->U7_POSTO

Return( cGrupo )