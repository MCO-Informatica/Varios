#INCLUDE "PROTHEUS.CH"

/*
---------------------------------------------------------------------------
| Rotina    | CSGerLog     | Autor | Gustavo Prudente | Data | 09.10.2013 |
|-------------------------------------------------------------------------|
| Descricao | Cria e atualiza arquivo de log de processamento             |
|-------------------------------------------------------------------------|
| Parametros| EXPN1 - Tipo de processamento: 1-Cria; 2-Atualiza; 3-Fecha  |
|           | EXPN2 - Handle do arquivo de log.                           |
|           | EXPC3 - Mensagem de log caracter                            |
|           | EXPC4 - Pasta para gravacao dos logs               	      |
|           | EXPC5 - Sub-pasta para gravacao dos logs            	      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/        
User Function CSGERLog( nTipo, nHandle, cMsg, cDir, cSubDir )

Local nX 		:= 0               

Local cFile		:= ""   
Local lRet		:= .T.
Local nError	:= 0

Default nTipo 	:= 0
Default cMsg  	:= ""                               
Default cDir 	:= "\GerLog"
Default cSubDir	:= ""

If nTipo == 1	// Cria
    
	cFile := cDir
	
	If !ExistDir( cDir )
		MakeDir( cDir )
	EndIf
	
	If !Empty( cSubDir )
		cFile := cDir + cSubDir
		If !ExistDir( cDir + cSubDir )
			MakeDir( cDir + cSubDir )
		EndIf	
	EndIf
         
	cFile += "\" + Criatrab(,.F.) + ".LOG"
                       
	nHandle := fCreate( cFile )

	If nHandle < 0                                                                           
		nError := fError()                                                      
		MsgAlert( "Nao foi possivel criar o arquivo de Log " + cFile + ". Erro numero: " + PadR( Str( nError ), 4 ) )
		lRet := .F.
	Else
		fClose( nHandle )
	EndIf	
                    
	If lRet

		nHandle := fOpen( cFile, 2 )
		
		If nHandle == -1 .Or. Empty( cFile )
			MsgStop( "Não foi possível abrir o arquivo de log. Processo finalizado." )
			lRet := .F.
		Else				
			fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
			fWrite( nHandle, "[CSGerLog - " + DtoC( Date() ) + "] Log de processamento " + Iif( Empty( cMsg ), "", cMsg ) + CRLF + CRLF )
		EndIf

	EndIf

ElseIf nTipo == 2		// Grava

	fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
	fWrite( nHandle, "[CSGerLog - " + Time() + "] " + cMsg + CRLF )

ElseIf nTipo == 3		// Fecha

	fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
	fWrite( nHandle, CRLF + "[CSGerLog - " + Time() + "] Fim de arquivo de log." )

	fClose( nHandle )
	
EndIf

Return lRet