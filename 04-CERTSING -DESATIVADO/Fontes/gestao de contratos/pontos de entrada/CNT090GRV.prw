#Include 'Protheus.ch'
//-----------------------------------------------------------------------
// Rotina | CNT090GRV  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | PE - Executado apos a conclusão da gravação da caução.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CNT090GRV()
	Local aDADOS := {CN8->CN8_TPCAUC, CN8->CN8_NUMDOC, CN8->CN8_VLEFET}
	Local cMV_650PROC := 'MV_650PROC'
	IF INCLUI
		CN9->( dbSetOrder(1) )
		IF CN9->( dbSeek( CN8->(CN8_FILIAL + CN8_CONTRA + CN8_REVISA) ) )
	   		IF GetMv( cMV_650PROC, .F. ) == '1' //Parâmetro habilitado para envio de e-mail
	   			//Rotina que envia e-mail sobre inclusão de caução.
	   			U_A650CAU( aDADOS )
	   		EndIF
		EndIF
	EndIF
Return

