#INCLUDE "Protheus.ch"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CTA100MNU  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de Entrada para incluir funcionalidades no menu de    ³±± 
±±³          ³Gestão de Contratos.									      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		AAdd( aRotina, { 'Manutenções específicas', "U_CSGCT080"	, 0, 7, 0, .F. } )
	EndIF
	//Devido a nova versão, estava apresentando erro ao utilizar o conceito de SubMenu, com isso foi unificado as opções
	//no fonte CSGCT080 - Rafael Beghini 26.02.2018
	/*
	AAdd(aRotina,{ "ISO27001",	"U_CSISO27M1",	0, 7, 0, .F. })
	
	AAdd( aSubMnu1, { 'Status de aprovação'  , 'U_A650STAP'  , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Aprovar legado'       , 'U_CSFA640'   , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Aprovar contrato'     , 'U_A650APROV' , 0, 7, 0, .F. } )
	AAdd( aSubMnu1, { 'Reenviar WF aprovação', 'U_A650APMNU' , 0, 7, 0, .F. } )
	
	AAdd( aRotina, { 'Aprovação', aSubMnu1, 0, 7, 0, .F. } )	
	
	If RetCodUsr() $ cMV_670USER
		AAdd( aSubMnu2, { 'Modificar data'       , 'U_A670MNCP(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Modificar vigência'   , 'U_A670VIGE(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Data aniversário'     , 'U_A670ANIV(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Tipo Renovação'       , 'U_A670RENO(1)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Reajuste/Indice'      , 'U_A670REAJ(1)'  , 0, 7, 0, .F. } )
	Else
		AAdd( aSubMnu2, { 'Modificar data'       , 'U_A670MNCP(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Modificar vigência'   , 'U_A670VIGE(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Data aniversário'     , 'U_A670ANIV(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Tipo Renovação'       , 'U_A670RENO(0)'  , 0, 7, 0, .F. } )
		AAdd( aSubMnu2, { 'Reajuste/Indice'      , 'U_A670REAJ(0)'  , 0, 7, 0, .F. } )
	Endif
	AAdd( aSubMnu2, { 'Notificação eMails'   , 'U_CSGCT040(1)'  , 0, 7, 0, .F. } )

	AAdd( aRotina, { 'Manutenções específicas', aSubMnu2	, 0, 7, 0, .F. } )
	*/
Return