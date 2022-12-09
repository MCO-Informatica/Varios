#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CTA100MNU  � Autor � Marcelo Celi Marques � Data � 19/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de Entrada para incluir funcionalidades no menu de    ��� 
���          �Gest�o de Contratos.									      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                 
User Function CTA100MNU
	Local aSubMnu1 := {}
	Local aSubMnu2 := {}
	Local cMV_670USER := 'MV_670USER'
	
	If .NOT. GetMv( cMV_670USER, .T. )
		CriarSX6( cMV_670USER, 'C', 'CODIGO DE USUARIOS AUTORIZADO FAZER ALTERACAO ESPECIFICA EM CONTRATOS. CSFA670.prw', '000908' )
	Endif
	
	cMV_670USER := GetMv( cMV_670USER, .F. )
	
	SetKey( VK_F5,  {|| U_CSFA640() } )
	
	IF RetCodUsr() $ cMV_670USER
		AAdd( aRotina, { 'Manuten��es espec�ficas', "U_CSGCT080"	, 0, 7, 0, .F. } )
	EndIF
	//Devido a nova vers�o, estava apresentando erro ao utilizar o conceito de SubMenu, com isso foi unificado as op��es
	//no fonte CSGCT080 - Rafael Beghini 26.02.2018
	/*
	AAdd(aRotina,{ "ISO27001",	"U_CSISO27M1",	0, 7, 0, .F. })
	
	AAdd( aSubMnu1, { 'Status de aprova��o'  , 'U_A650STAP'  , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Aprovar legado'       , 'U_CSFA640'   , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Aprovar contrato'     , 'U_A650APROV' , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Reenviar WF aprova��o', 'U_A650APMNU' , 0, 7, 0, .F. } )
	
	AAdd( aRotina, { 'Aprova��o', aSubMnu1, 0, 7, 0, .F. } )	
	
	If RetCodUsr() $ cMV_670USER
		AAdd( aSubMnu2, { 'Modificar data'       , 'U_A670MNCP(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Modificar vig�ncia'   , 'U_A670VIGE(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Data anivers�rio'     , 'U_A670ANIV(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Tipo Renova��o'       , 'U_A670RENO(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Reajuste/Indice'      , 'U_A670REAJ(1)'  , 0, 7, 0, .F. } )
	Else
		AAdd( aSubMnu2, { 'Modificar data'       , 'U_A670MNCP(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Modificar vig�ncia'   , 'U_A670VIGE(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Data anivers�rio'     , 'U_A670ANIV(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Tipo Renova��o'       , 'U_A670RENO(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Reajuste/Indice'      , 'U_A670REAJ(0)'  , 0, 7, 0, .F. } )
	Endif
	AAdd( aSubMnu2, { 'Notifica��o eMails'   , 'U_CSGCT040(1)'  , 0, 7, 0, .F. } )

	AAdd( aRotina, { 'Manuten��es espec�ficas', aSubMnu2	, 0, 7, 0, .F. } )
	*/
Return