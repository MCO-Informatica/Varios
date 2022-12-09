#include 'protheus.ch'

/*
-----------------------------------------------------------------------------
| Rotina    | SDKTMKENT    | Autor | Gustavo Prudente | Data | 16.05.2014   |
|---------------------------------------------------------------------------|
| Descricao | Configurar campos de retorno para entidades customizadas do   |
|           | modulo Service Desk - rotina TKENTIDADE()                     |
|---------------------------------------------------------------------------|
| Parametros| EXPC1 - Entidade para configuracao dos campos de retorno      |
|           | EXPN2 - Tipo de informacao (campo) para retorno               |
|---------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                           |
-----------------------------------------------------------------------------
*/
User Function SDKTMKENT( cEntidade, nTipo )

Local cCpo := ""

Default nTipo := 1
Default cEntidade := ""

If cEntidade == "SZ3"
	If nTipo == 1
		cCpo := "Z3_DESENT"
	ElseIf nTipo == 6
		cCpo := "Z3_TEL"
	ElseIf nTipo == 9
		cCpo := "Z3_DDD"
	EndIf
EndIf		

Return( cCpo )