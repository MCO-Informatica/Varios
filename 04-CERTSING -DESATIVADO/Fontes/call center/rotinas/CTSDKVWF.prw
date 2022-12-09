#include "protheus.ch"

/*
-------------------------------------------------------------------------------
| Rotina     | CTSDKVWF   | Autor | Gustavo Prudente     | Data | 06.03.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Realiza validacao de envio do modelo de workflow               |
|-----------------------------------------------------------------------------|
| Parametros | EXPC1 - Conta de origem do workflow na conta                   |
|-----------------------------------------------------------------------------|
| Retorno    | EXPL1 - Retorna se deve enviar workflow de resposta automatica |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
User Function CTSDKVWF( cFrom )
	Local nCont    := 1
	Local nTotal   := 0
	Local lRet     := .T.
	Local cXSDKNWF := GetNewPar( "MV_XSDKNWF", "MAILER-DAEMON" )

	Default cFrom := ""

	If ! Empty( cFrom )
		//Cria array com os enderecos que nao deve enviar workflow
		aNaoEnvia	:= StrToKArr( cXSDKNWF, ";" )
		nTotal		:= Len( aNaoEnvia )

    	//Caso a conta de envio contiver algum dos e-mails bloqueados
    	//Apaga string de contas para nao enviar o workflow
		Do While nCont <= nTotal .And. lRet
			If aNaoEnvia[ nCont ] $ cFrom
				lRet := .F.
			EndIf
			nCont ++
		EndDo
	EndIf

Return lRet