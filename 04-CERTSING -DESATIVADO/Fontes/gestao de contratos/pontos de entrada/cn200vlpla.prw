//---------------------------------------------------------------------------------
// Rotina | CN200VLPLA | Autor | Robson Gonçalves               | Data | 29/06/2015
//---------------------------------------------------------------------------------
// Descr. | Ponto de entrada está localizado na função CN200Manut e deverá ser 
//        | utilizado para validação do Cadastro de Planilhas.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CN200VLPLA()
	Local lRet    := .F.
	Local aHeader := {}
	Local aCOLS   := {}
	Local aCABEC  := {M->CNA_FILIAL,M->CNA_CONTRA,M->CNA_REVISA,M->CNA_NUMERO,M->CNA_DESCRI,Date()}
	Local ExpA1   := ParamIXB[2]
	Local nOpcao  := ParamIXB[4] //3-Inclusão da planilha
	Local cMV_650PROC := 'MV_650PROC'
	
	aHeader := AClone( ParamIXB[ 1 ]:aHeader )
	aCOLS   := AClone( ParamIXB[ 1 ]:aCOLS )
		
	If FindFunction('U_A650VLPL')
		lRet := U_A650VLPL( aHeader, aCOLS )
	Endif
	
	//Enviar notificação de planilha somente quando não estiver cadastrando o contrato junto.
	IF nOpcao == 3 .And. FunName() == 'CNTA200' //Rotina - Planilhas
		IF GetMv( cMV_650PROC, .F. ) == '1' //Parâmetro habilitado para envio de e-mail
			//Rotina que envia e-mail sobre inclusão de planilha
			U_A650Plan( aCABEC, aCOLS )
		EndIF
	EndIF
Return( lRet )