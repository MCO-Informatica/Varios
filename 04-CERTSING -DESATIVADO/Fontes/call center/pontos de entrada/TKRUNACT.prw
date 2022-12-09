#include "protheus.ch"
                         
/*           
------------------------------------------------------------------------------
| Rotina    | TKRUNACT     | Autor | Gustavo Prudente | Data | 22.05.2015    |
|----------------------------------------------------------------------------|
| Descricao | Executar regra antes de executar a acao do item do atendimento |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
User Function TKRUNACT
           
Local lRet := .F.
    
Local aHeaderADF  := AClone( ParamIxb[1] )
Local aColsADF    := AClone( ParamIxb[2] )
Local nItem		  := ParamIxb[3]                                                           
                  
nRecno := aColsADF[ nItem, Len( aColsADF[ nItem ] ) - 1 ]
     
// Somente retorna verdadeiro se nao encontrou o Recno do item no atendimento
lRet := ( nRecno == 0 )

If lRet .And. IsInCallStack( "U_CTSDK12" )

	//
	// Realiza a gravacao dos anexos no atendimento antes do envio do workflow
	//            
	// 1o. Parametro: 1-Armazena informacoes do anexo em memoria
	// 				  2-Realiza a gravacao dos anexos a partir das informacoes armazenadas no array.
	//
	U_CTSDKSVA( 2, ADE->ADE_CODIGO )
		
EndIf

Return lRet