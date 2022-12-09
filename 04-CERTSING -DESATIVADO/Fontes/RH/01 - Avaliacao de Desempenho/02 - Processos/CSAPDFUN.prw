#Include 'Protheus.ch'
STATIC cMV_APD01  := ''
STATIC cMV_APD02  := ''
STATIC cMV_APD03  := ''
STATIC cMV_APD04  := ''
//-----------------------------------------------------------------------
// Rotina | CSAPDFUN  | Autor | Rafael Beghini    | Data | 20.07.2016
//-----------------------------------------------------------------------
// Descr. | Habilita a utilização dos campos no cadastro de Objetivos
//        | para usuários do RH.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSAPDFUN()
	Local cCODUSR := RetCodUsr()
	Local lRet    := .F.
	A010PARAM()
	
	IF cCODUSR $ cMV_APD01
		lRet := .T.
	EndIF
Return( lRet )

//+-------------------------------------------
//|Função: A010PARAM - Cria o parâmetro
//+-------------------------------------------
Static Function A010PARAM()
	cMV_APD01 := 'MV_CSAPD01'
	
	If .NOT. GetMv( cMV_APD01, .T. )
		CriarSX6( cMV_APD01, 'C', 'USUÁRIOS LIBERADOS PARA ALTERAR DADOS DO OBJETIVO DE PLANO/METAS. CSAPDFUN.prw', '000445' )
	Endif		
	cMV_APD01 := GetMv( cMV_APD01, .F. )
Return

//-----------------------------------------------------------------------
// Rotina | CSAPDCFG  | Autor | Rafael Beghini    | Data | 20.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para compatibilizar os campos da tabela (RDI)
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSAPDCFG()
	cMV_APD01 := 'MV_CSAPD01'
	cMV_APD02 := 'MV_CSAPD02'
	cMV_APD03 := 'MV_CSAPD03'
	cMV_APD04 := 'MV_CSAPD04'
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	If .NOT. GetMv( cMV_APD01, .T. )
		CriarSX6( cMV_APD01, 'C', 'USUÁRIOS LIBERADOS PARA ALTERAR DADOS DO OBJETIVO DE PLANO/METAS. CSAPDFUN.prw', '000445' )
	Endif		
	cMV_APD01 := GetMv( cMV_APD01, .F. )
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	If .NOT. GetMv( cMV_APD02, .T. )
		CriarSX6( cMV_APD02, 'C', 'CÓDIGO DA RELEVANCIA PADRAO OBJETIVO DE PLANO/METAS. CSAPDFUN.prw', "'20'" )
	Endif		
	cMV_APD02 := GetMv( cMV_APD02, .F. )
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	If .NOT. GetMv( cMV_APD03, .T. )
		CriarSX6( cMV_APD03, 'C', 'CÓDIGO DA ATINGINMENTO/CONHECIMENTO PADRAO OBJETIVO DE PLANO/METAS. CSAPDFUN.prw', "'21'" )
	Endif		
	cMV_APD03 := GetMv( cMV_APD03, .F. )
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	If .NOT. GetMv( cMV_APD04, .T. )
		CriarSX6( cMV_APD04, 'C', 'CÓDIGO DA VISAO PADRAO OBJETIVO DE PLANO/METAS. CSAPDFUN.prw', "'000018'" )
	Endif		
	cMV_APD04 := GetMv( cMV_APD04, .F. )
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	SX3->( dbSetOrder(2) )
	IF SX3->( dbSeek('RDI_TIPO') )
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_RELACAO := '2'
		SX3->X3_WHEN    := 'U_CSAPDFUN()'
		SX3->X3_CBOX    := ''
		SX3->( MsUnlock() )
	EndIF

	IF SX3->( dbSeek('RDI_ESCREL') )
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_RELACAO := cMV_APD02
		SX3->X3_WHEN    := 'U_CSAPDFUN()'
		SX3->( MsUnlock() )
	EndIF	
	
	IF 	SX3->( dbSeek('RDI_ESCATG') )
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_RELACAO := cMV_APD03
		SX3->X3_WHEN    := 'U_CSAPDFUN()'
		SX3->( MsUnlock() )
	EndIF
	
	IF SX3->( dbSeek('RDI_ESCCON') )
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_RELACAO := cMV_APD03
		SX3->X3_WHEN    := 'U_CSAPDFUN()'
		SX3->( MsUnlock() )
	EndIF
	
	IF SX3->( dbSeek('RDI_VISAO') )
		SX3->( RecLock( 'SX3', .F. ) )
		SX3->X3_RELACAO := cMV_APD04
		SX3->X3_WHEN    := 'U_CSAPDFUN()'
		SX3->( MsUnlock() )
	EndIF
	
	Aviso( 'SIGAAPD', "Compatibilização executada com sucesso.", {"Ok"} )	
Return