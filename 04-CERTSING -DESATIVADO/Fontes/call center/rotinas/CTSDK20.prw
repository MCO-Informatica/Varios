#include "protheus.ch"
                     
/*
---------------------------------------------------------------------------
| Rotina    | CTSDK20      | Autor | Gustavo Prudente | Data | 04.06.2014 |
|-------------------------------------------------------------------------|
| Descricao | Rotina para validacao do pedido site informado na tela do   |
|           | atendimento.                                                |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - Numero do pedido site informado no atendimento.     |
|           | EXPL2 - Indica se deve executar como Job.                   |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function CTSDK20( cPedSite, lJob )

Local lRet := .T. 
Local lFound := .T.                   

Default lJob := .F.

If ! lJob

	// Se nao informou pedido site, zera total de atendimentos e retorna
	If Vazio()
		M->ADE_XTOTAT := 0
		Return .T.
	EndIf	
                         
    // Atualiza total de atendimentos do pedido site
    M->ADE_XTOTAT := XTotPSite( cPedSite )
    
	DbSelectArea("SC5")// Incluído por Renato Ruy
	dbOrderNickNAme('PEDSITE')// Incluído por Renato Ruy
	SZG->( DbSetOrder(3) )
	Z11->(DbSetOrder(2)) // 10/04/2018 - Incluído por Renato Ruy
	// Mesmo se nao encontrar o pedido site, deve retornar .T. para permitir  
	// que o numero seja informado no atendimento
	If SC5->( DbSeek( xFilial( "SC5" ) + cPedSite ) )
		lFound := .F.
	ElseIF SZG->( dbSeek( xFilial('SZG') + cPedSite ) )
		lFound := .F.
	ElseIF Z11->( dbSeek( xFilial('Z11') + cPedSite ) )
		lFound := .F.
	EndIf
	
	IF lFound
		MsgAlert( "Pedido site número " + Alltrim( cPedSite ) + " não encontrado." )
		M->ADE_XPSITE := Space( TamSX3( "ADE_XPSITE" )[ 1 ] )
	EndIF
EndIf

Return( lRet )


/*
------------------------------------------------------------------------------
| Rotina    | XTotPSite   | Autor | Gustavo Prudente  | Data | 16.09.2014    |
|----------------------------------------------------------------------------|
| Descricao | Totaliza atendimentos do pedido site informado.                |
|----------------------------------------------------------------------------|
| Parametros| EXPN1 - Numero do pedido site                                  |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function XTotPSite( cPedSite )
           
Local nRet   := 0
Local cAlias := Alias()              
              
Default cPedSite := ""

If ! Empty( cPedSite )
	
	BeginSql Alias "TOTSITE"
	      
		SELECT COUNT( R_E_C_N_O_ ) AS TOTAL
		FROM %Table:ADE% 
		WHERE	ADE_FILIAL = %xFilial:ADE% AND
				ADE_XPSITE = %Exp:cPedSite% AND
				%notDel%
	
	EndSql
	
	nRet := TOTSITE->TOTAL
	
	TOTSITE->( DbCloseArea() )

EndIf
	
DbSelectArea( cAlias )

Return( nRet )