#INCLUDE "PROTHEUS.CH"
/*/{Protheus.doc} IMCDENVPO
(long_description)
@type  Function
@author user
@since 30/08/2021
@version version
@param  cFilPO, Char , Filial do PO
cNumPOLib, Char, Numero do PO
@return nil
/*/

User Function IMCDENVPO(cFilPO, cNumPOLib )

//	Local aVetor := {}
//  Local nX := 0

	Local aAnexoXML := {}
	Local cAliasPO := ""
	Private nIdioma := 1
	Private cRetXml := ""
	Private lJob := .T.

	default cEmpProc := ""
	default cFilProc := ""

	default cFilPO := "0"
	default cNumPOLib := "0"
/*
	aAdd(aVetor,{"01","02"})
	aAdd(aVetor,{"02","02"})

	FOR nX := 1 To Len(aVetor)

		cEmpProc := aVetor[nX,1]
		cFilProc := aVetor[nX,2]

		RpcSetType(3)// Não consome licensa de uso
		RpcSetEnv(cEmpProc,cFilProc,,,'FAT','IMCDENVPO')

		dbCloseAll()

		cEmpAnt := cEmpProc
		cFilAnt := cFilProc
		cNumEmp := cEmpAnt+cFilAnt

		OpenSM0(cEmpAnt+cFilAnt)
		OpenFile(cEmpAnt+cFilAnt)
*/
	aAnexoXML := {}
	cAliasPO := getNextAlias()

	BEGINSQL ALIAS cAliasPO

			SELECT W2_FILIAL, W2_PO_NUM, SW2.R_E_C_N_O_ RECNO
			FROM %table:SW2% SW2
			WHERE W2_PO_DT >= '20210101'
			AND W2_CONAPRO = 'L'
			AND	W2_FILIAL = %Exp:cFilPO%
			AND SW2.%notDel%\
			AND SW2.W2_PO_NUM = %Exp:cNumPOLib%
			AND W2_ENVMAIL = ' '
			
			ORDER BY W2_FILIAL, W2_PO_NUM
			fetch first 5 rows only 
	ENDSQL
	//aQuery := GetLastQuery()
	(cAliasPO)->(DbGotop())
	While (cAliasPO)->(!Eof())

		cFilPO := (cAliasPO)->W2_FILIAL
		cNumPO := (cAliasPO)->W2_PO_NUM

		aAdd(aMarcados,(cAliasPO)->RECNO)

		aAnexoXML := PO150Report()

		if !Empty(aAnexoXML )
			ENVPO(aAnexoXML , cNumPO, (cAliasPO)->RECNO)
		Endif

		(cAliasPO)->(dbSkip())

	Enddo
/*
Next nX

RPCCLEARENV()
*/

Return()


STATIC Function ENVPO(aAnexoXML,cNumPO,RECNO)

	Local cAssunto		:= "Purchase Order  "+Alltrim(cNumPO)
	Local cMensagem		:= CORPOEMAIL(cAssunto)
	Local aAttach 		:= {}
	Local cFilePrint	:= aAnexoXML[2]
	Local cDirDest		:= aAnexoXML[1]
	Local aUsuarios		:= {}
	Local cUsuarios 	:= SuperGetMv("ES_EMAILPO",,'000390')
	Local cPara 		:= ""
	Local cCopia 		:= ""
	Local nX 			:= 0
	Local cEmpresa := SM0->M0_CODIGO+"/"+alltrim(SM0->M0_CODFIL)+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )
	Local cSupplier := LITERAL_FORNECEDOR + ALLTRIM(SA2->A2_NOME)+ Space(2) + Alltrim(IF(EICLOJA(), LITERAL_STORE /*"Loja:"*/ + Alltrim(SA2->A2_LOJA),""))

	aAdd(aAttach,cDirDest+cFilePrint)

	aUsuarios := StrToArray( cUsuarios, ";")

	For nX:= 1 TO Len(aUsuarios)
		aAllusers := FWSFALLUSERS({aUsuarios[nX]})

		cPara += aAllusers[1,5]+';'

	Next nX

	lEnviou := U_ENVMAILIMCD(cPara,cCopia,/*copia oculta*/"","TESTE - "+cAssunto +"-"+cEmpresa+"-"+cSupplier,cMensagem,aAttach,.T.)

	if lEnviou

		cQuery := "UPDATE " + RetSQLName( "SW2" )
		cQuery += " SET W2_ENVMAIL = '"+DTOS(DDATABASE)+"' "
		cQuery += " WHERE R_E_C_N_O_ = "+STR(RECNO)

		TCSQLExec( cQuery )
		TCRefresh( 'SF2' )

	endif


	ferase(cDirDest+cFilePrint )


Return


Static Function CORPOEMAIL(cAssunto)
	Local cMensagem := ' '

	cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
	cMensagem += '<head>'
	cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
	cMensagem += '<title>'+cAssunto+'</title>'
	cMensagem += '  <style type="text/css"> '
	cMensagem += '	<!-- '
	cMensagem += '	body {background-color: transparent;} '
	cMensagem += '	.style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} '
	cMensagem += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} '
	cMensagem += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} '
	cMensagem += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} '
	cMensagem += '	.style5 {font-size: 10pt} '
	cMensagem += '	--> '
	cMensagem += '  </style>'
	cMensagem += '</head>'
	cMensagem += '<body>'
	cMensagem += '<p> <strong>O '+cAssunto+' </strong>.</p>'
	cMensagem += '<p> Foi Aprovado por .'+UsrRetName( __cUserId ) 
	
	cMensagem += '<p>Segue arquivo pdf em anexo.</p>'
	cMensagem += '<p> Email do Supplier - '+ALLTRIM(SA2->A2_EMAIL)+' </p>'
	cMensagem += '</body> '
	cMensagem += '</html>'

Return(cMensagem)

