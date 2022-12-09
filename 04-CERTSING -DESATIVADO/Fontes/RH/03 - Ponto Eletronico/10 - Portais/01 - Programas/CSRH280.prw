#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"

#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "07"
#DEFINE cLOG "## CSRH280 - "

user function CSRH280()
	Local aAreaSQB 	:= {}
	Local nCont 	:= 0
	Local aDeptos 	:= {}
	Local lKeyIni 	:= .F.

	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL

	log280("inicio: "+dtoc(date())+" - hora: "+time())

	aAreaSQB 	:= SQB->( GetArea() )
	lKeyIni 	:= SQB->( ColumnPos("QB_KEYINI") ) > 0

	aDeptos := fEstrutDepto( cFilAnt,,,.T. )
	log280("carregou departamentos")

	DbSelectArea( "SQB" )
	SQB->(DbSetOrder( 1 ))
	For nCont := 1 To Len( aDeptos )
		If SQB->(DbSeek(xFilial("SQB", aDeptos[nCont,8]) + aDeptos[nCont,1]))
			Reclock("SQB", .F.)
			SQB->QB_KEYINI := aDeptos[nCont,5]
			log280( "Departamento: " + SQB->QB_DEPTO + " - " + SQB->QB_DESCRIC + " - " + "KeyIni: " + SQB->QB_KEYINI )
			SQB->(MsUnlock())
		EndIf
	Next nCont

	Restarea(aAreaSQB)
	
	log280("fim: "+dtoc(date())+" - hora: "+time())

	RESET ENVIRONMENT	
return

static function log280( cMSG )
	conout( cLOG + cMSG )
return