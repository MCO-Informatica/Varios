//---------------------------------------------------------------------------------
// Rotina | CN200VLPLA | Autor | Robson Gon�alves               | Data | 29/06/2015
//---------------------------------------------------------------------------------
// Descr. | Ponto de entrada est� localizado na fun��o CN200Manut e dever� ser 
//        | utilizado para valida��o do Cadastro de Planilhas.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CN200VLPLA()
	Local lRet    := .F.
	Local aHeader := {}
	Local aCOLS   := {}
	Local aCABEC  := {M->CNA_FILIAL,M->CNA_CONTRA,M->CNA_REVISA,M->CNA_NUMERO,M->CNA_DESCRI,Date()}
	Local ExpA1   := ParamIXB[2]
	Local nOpcao  := ParamIXB[4] //3-Inclus�o da planilha
	Local cMV_650PROC := 'MV_650PROC'
	
	aHeader := AClone( ParamIXB[ 1 ]:aHeader )
	aCOLS   := AClone( ParamIXB[ 1 ]:aCOLS )
		
	If FindFunction('U_A650VLPL')
		lRet := U_A650VLPL( aHeader, aCOLS )
	Endif
	
	//Enviar notifica��o de planilha somente quando n�o estiver cadastrando o contrato junto.
	IF nOpcao == 3 .And. FunName() == 'CNTA200' //Rotina - Planilhas
		IF GetMv( cMV_650PROC, .F. ) == '1' //Par�metro habilitado para envio de e-mail
			//Rotina que envia e-mail sobre inclus�o de planilha
			U_A650Plan( aCABEC, aCOLS )
		EndIF
	EndIF
Return( lRet )