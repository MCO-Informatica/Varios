#INCLUDE "Protheus.ch"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矯TA100MNU  ? Autor ? Marcelo Celi Marques ? Data ? 19/10/12 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 砅onto de Entrada para incluir funcionalidades no menu de    潮? 
北?          矴est鉶 de Contratos.									      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Certisign                                                  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
		AAdd( aRotina, { 'Manuten珲es espec韋icas', "U_CSGCT080"	, 0, 7, 0, .F. } )
	EndIF
	//Devido a nova vers鉶, estava apresentando erro ao utilizar o conceito de SubMenu, com isso foi unificado as op珲es
	//no fonte CSGCT080 - Rafael Beghini 26.02.2018
	/*
	AAdd(aRotina,{ "ISO27001",	"U_CSISO27M1",	0, 7, 0, .F. })
	
	AAdd( aSubMnu1, { 'Status de aprova玢o'  , 'U_A650STAP'  , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Aprovar legado'       , 'U_CSFA640'   , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Aprovar contrato'     , 'U_A650APROV' , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Reenviar WF aprova玢o', 'U_A650APMNU' , 0, 7, 0, .F. } )
	
	AAdd( aRotina, { 'Aprova玢o', aSubMnu1, 0, 7, 0, .F. } )	
	
	If RetCodUsr() $ cMV_670USER
		AAdd( aSubMnu2, { 'Modificar data'       , 'U_A670MNCP(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Modificar vig阯cia'   , 'U_A670VIGE(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Data anivers醨io'     , 'U_A670ANIV(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Tipo Renova玢o'       , 'U_A670RENO(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Reajuste/Indice'      , 'U_A670REAJ(1)'  , 0, 7, 0, .F. } )
	Else
		AAdd( aSubMnu2, { 'Modificar data'       , 'U_A670MNCP(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Modificar vig阯cia'   , 'U_A670VIGE(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Data anivers醨io'     , 'U_A670ANIV(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Tipo Renova玢o'       , 'U_A670RENO(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Reajuste/Indice'      , 'U_A670REAJ(0)'  , 0, 7, 0, .F. } )
	Endif
	AAdd( aSubMnu2, { 'Notifica玢o eMails'   , 'U_CSGCT040(1)'  , 0, 7, 0, .F. } )

	AAdd( aRotina, { 'Manuten珲es espec韋icas', aSubMnu2	, 0, 7, 0, .F. } )
	*/
Return