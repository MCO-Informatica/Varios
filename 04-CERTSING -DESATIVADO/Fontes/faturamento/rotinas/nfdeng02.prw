#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "AP5MAIL.CH"

Static __nHdlSMTP := 0

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NFDENG02ºAutor  ³ Opvs (David)       º Data ³  13/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o XML em Arquivo e Envia por E-Mail.                  º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NFDENG02(cMenErro, lAbandona)
	Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cCNPJDEST	:= Space(14)
	Local dDataNF	:= CtoD("")
	Local lOk      	:= .F.
	Local cCodUsr	:= ""
	Local cCNPJ		:= ""
	Local cIdflush  := ""
	Local cChvNFe  	:= ""
	Local cString	:= ""
	Local cCabec	:= ""
	Local cRodaPe	:= ""
	Local cModelo  	:= ""
	Local cNFes     := ""
	Local cNomArq	:= ""
	Local cAssunto	:= ""
	Local cError	:= ""
	Local cTargetDir:= GetSrvProfString("Startpath","")
	Local cPath		:= cTargetDir + "XMLTMP\"
    Local cIdEnt    := GetIdEnt()
    Local cAssDeneg := ""
    Local cMsgDeneg := ""
    
	Local nX
	Local nY
	Local oXml
	Local oEnvia
	Local oWS
	
	Default cMenErro := "" 
	Default lAbandona:= .f.
	
	cAssDeneg:= "INFORMATIVO: DENEGAÇÃO DO USO DA NOTA FISCAL (SP) CÓDIGO "+SF2->F2_DOC
	
	cMsgDeneg:= "Segue XML referente a NF de aquisição produto adquirido, a qual foi denegada pela SEFAZ devido pendência de regularização de dados de contribuinte junto a SEFAZ. (Portaria CAT Nº 24, de 27-02-2012)e (Portaria CAT- 162, de 29 -12-2008)"+CRLF
	cMsgDeneg+= CRLF
	cMsgDeneg+= "A administração tributaria comunicou que a partir do dia 02/04/2012 estabeleceu que a autorização do uso de NF poderá ser denegada devido a irregularidade fiscal (divergência entre os dados do destinatário em contrapartida com a base de dados da SEFAZ) do destinatário de acordo com as diretrizes da unidade federativa."+CRLF
	cMsgDeneg+= CRLF
	cMsgDeneg+= "A Secretaria da Fazendo do Estado de São Paulo deu inicio a esta ação em 02/04/2012 para as operações internas."+CRLF
	cMsgDeneg+= CRLF
	cMsgDeneg+= "Para que não ocorra denegação o destinatário devera estar enquadrado nas situações: ATIVA; SUSPENSA e/ou BAIXADA no CADESP."+CRLF
	cMsgDeneg+= CRLF
	cMsgDeneg+= "Solicitamos realizarem a regularização para que nas próximas aquisições não ocorra a denegação das NFS."+CRLF
	cMsgDeneg+= CRLF
	cMsgDeneg+= "Att."+CRLF
	cMsgDeneg+= CRLF
	cMsgDeneg+= "CERTISIGN - A sua identidade na rede"
	
	/*
	DbSelectarea("SF2")
	SF2->(DbGoto( aDados[09] ))*/
	cIdflush 	:= SF2->F2_SERIE + SF2->F2_DOC
	dDataNF		:= SF2->F2_EMISSAO
	cNomArq		:= cPath + "XML_NF_" + Alltrim(SF2->F2_DOC) + ".XML"
	//cAssunto	:= "Envio de XML - NF DENEGADA: " + Alltrim(SF2->F2_DOC)
	
	
	DbSelectarea("SA1")
	SA1->(DbSetorder(1))
	SA1->(MsSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))
	cCNPJ	:= SA1->A1_CGC
	
	IsReady()
	
	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN        := "TOTVS"
	oWS:cID_ENT           := cIdEnt 
	oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial        := cIdflush // cNotaIni
	oWS:cIdFinal          := cIdflush
	oWS:dDataDe           := CTOD("01/01/2001")
	oWS:dDataAte          := CTOD("31/12/2049")
	oWS:cCNPJDESTInicial  := cCNPJ
	oWS:cCNPJDESTFinal    := cCNPJ
	oWS:nDiasparaExclusao := 0
	lOk:= oWS:RETORNAFX()
	oRetorno := oWS:oWsRetornaFxResult

	If !lOk
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))+CRLF,{"OK"},3)
		lAbandona := .T.
		Return Nil
	EndIf
	
	For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
 		
 		oXml 	:= oRetorno:OWSNOTAS:OWSNFES3[nX]
		oXmlExp	:= XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
		If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ") <> "U" 
			cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
		ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF") <> "U"
			cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)				
		Else
   			cCNPJDEST := ""
		EndIf	
			
		cCabec 	:= '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.10">'
		cRodape	:= '</nfeProc>'
		cString	:= cCabec
		cString += oXml:oWSNFe:cXML
		cString += oXml:oWSNFe:cXMLPROT
		cString += cRodaPe

		//Grava o Arquivo Anexo
		If (nCria := fCreate(cNomArq)) == -1
			lAbandona := .T.
			Alert("Erro ao criar arquivo: " + Alltrim(cNomArq) + " Verifique...")
			Return Nil
		Else
			fWrite(nCria, cString)
			fClose(nCria)
		EndIf
		
		//Conecta / Envia o E-Mail
		u_MandEmail(cMsgDeneg, SA1->A1_EMAIL, cAssDeneg, cNomArq)
		
		Ferase(cNomArq)
		
	Next nX		
		
Return Nil

/* ----------------------------------------------------------------------------
Recupera o codigo da entidade...
( Esta funcao esta duplicada, pode ser unificada posteriormente )
------------------------------------------------------------------------------*/

Static Function GetIdEnt()

Local cIdEnt := ""                      			
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs                                	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := "microsigafin@certisign.com.br"//UsrRetMail(RetCodUsr()) -- retirado devido a error.log na recepção de nota via JOB
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
EndIf

Return(cIdEnt)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IsReady ºAutor  ³Opvs (David)          º Data ³  18/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se SEFAZ esta no Ar                               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IsReady(cURL,nTipo,lHelp)

Local nX       := 0
Local cHelp    := ""
Local oWS
Local lRetorno := .F.
DEFAULT nTipo := 1
DEFAULT lHelp := .F.
If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "MV_SPEDURL"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "URL SPED NFe"
	MsUnLock()
	PutMV("MV_SPEDURL",cURL)
EndIf
SuperGetMv() //Limpa o cache de parametros - nao retirar
DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o servidor da Totvs esta no ar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWs := WsSpedCfgNFe():New()
oWs:cUserToken := "TOTVS"
oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
If oWs:CFGCONNECT()
	lRetorno := .T.
Else
	If lHelp
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	EndIf
	lRetorno := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo <> 1 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"		
	If oWs:CFGReady()
		lRetorno := .T.
	Else
		If nTipo == 3
			cHelp := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
			If lHelp .And. !"003" $ cHelp
				Aviso("SPED",cHelp,{"ok"},3)
				lRetorno := .F.
			EndIf		
		Else
			lRetorno := .F.
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 2 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"		
	If oWs:CFGStatusCertificate()
		If Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE) > 0
			For nX := 1 To Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE)
				If oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nx]:DVALIDTO-30 <= Date()
				
					Aviso("SPED","O certificado digital irá vencer em: "+Dtoc(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nX]:DVALIDTO),{"ok"},3) //"O certificado digital irá vencer em: "
				
			    EndIf
			Next nX		
		EndIf
	EndIf
EndIf

Return(lRetorno)