#Include 'Protheus.ch'
#Include 'Totvs.ch'

Static cCS_CODINC := ''
//---------------------------------------------------------------
// Rotina | TK500INC | Autor | Rafael Beghini | Data | 04/08/2015 
//---------------------------------------------------------------
// Descr. | PE - Acionado para possibilitar a alteração do 
//        | campo INCIDENCIA
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//---------------------------------------------------------------
User Function TK500INC()
	Local cIncNew  := ParamIxb[1]
	Local cIncOld  := MSMM(ADE->ADE_CODINC)   
	Local cRetorno := cIncNew 
	Local cGrupo   := ''
	Local cMV_TK500INC := 'MV_TK500IN'
	
	cCS_CODINC := cIncOld

	If .NOT. SX6->( ExisteSX6( cMV_TK500INC ) )
		CriarSX6( cMV_TK500INC, 'C', 'Grupos que nao podem alterar o incidente TK500INC.prw', "'24'" )
	Endif
		
	cGrupo := GetMv( cMV_TK500INC )
	
	IF .NOT. INCLUI
		IF ADE->ADE_GRUPO $ cGrupo .Or. ADF->ADF_CODSU0 $ cGrupo
			IF cIncNew <> cIncOld
				Aviso( 'Atenção', 'O campo Incidente não pode ser alterado para este grupo.', {"Ok"} )
				Sleep(300)
			EndIF
			cRetorno := cIncOld
		Else
			cRetorno := cIncNew
		EndIF
	EndIF
Return cRetorno

//-- Função criada para retornar no TK510END
//-- Será utilizado quando o campo incidente estiver em branco.
User Function CSCODINC()
Return(cCS_CODINC)