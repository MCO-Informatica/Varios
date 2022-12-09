#Include 'Protheus.ch'
//-----------------------------------------------------------------------
// Rotina | CN140GREV  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | PE - Executado apos a conclus�o da grava��o da revis�o.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN140GREV()
	Local cMV_650PROC := 'MV_650PROC'
	IF GetMv( cMV_650PROC, .F. ) == '1' //Par�metro habilitado para envio de e-mail
		//Rotina que envia e-mail sobre revis�o de contratos
		U_A650Rev( PARAMIXB )
	EndIF
Return

