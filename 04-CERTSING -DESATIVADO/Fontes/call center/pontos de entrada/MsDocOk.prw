#Include 'Protheus.ch'
//-------------------------------------------------------------------------
// Rotina | MsDocOk     | Autor | Rafael Beghini     | Data | 28.03.2016
//-------------------------------------------------------------------------
// Descr. | Ponto de entrada para tratamento de informações complementares 
//        | ao gravar um registro no banco de conhecimento.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
User Function MsDocOk()
	IF FunName() == 'CNTA100' //Gestão de Contratos
		IF .NOT. Empty( CN9->CN9_XOPORT )
			CSCRM030( CN9->CN9_XOPORT, AC9->AC9_CODOBJ )
		EndIF 
	EndIF
Return
//-------------------------------------------------------------------------
// Rotina | CSCRM030     | Autor | Rafael Beghini     | Data | 28.03.2016
//-------------------------------------------------------------------------
// Descr. | Replica o documento no banco de conhecimento 
//        | anexado na entidade de Oportunidades.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function CSCRM030( cAC9_CODENT, cAC9_CODOBJ ) 
	Local aArea := GetArea()
	
	AC9->( dbSetOrder(1) )
	IF .NOT. AC9->( dbSeek( xFilial('AC9') + cAC9_CODOBJ + 'AD1' + xFilial('CN9') + cAC9_CODENT ) )
		AC9->( RecLock( 'AC9', .T. ) )
		AC9->AC9_FILIAL := xFilial( 'AC9' )
		AC9->AC9_FILENT := xFilial( 'CN9' )
		AC9->AC9_ENTIDA := 'AD1'
		AC9->AC9_CODENT := cAC9_CODENT
		AC9->AC9_CODOBJ := cAC9_CODOBJ
		AC9->AC9_DTGER  := dDataBase
		AC9->( MsUnLock() )
	EndIF
		
	RestArea(aArea)
Return