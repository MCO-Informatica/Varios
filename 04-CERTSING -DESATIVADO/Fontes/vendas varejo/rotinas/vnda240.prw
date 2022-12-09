#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
//---------------------------------------------------------------------
// Rotina | VNDA240 | Autor | Opvs (David)          | Data | 01.02.2012
//---------------------------------------------------------------------
// Descr. | Programa para enviar ao Hub Lista de Postos
//        | 
//---------------------------------------------------------------------
// Release| #TP20130218 - Restricao de Postos / Inclusao do campo de
//        |  rede.
//        | #TP20130621 - mantido espacos vazios no campo REDE
//        | #TP20160617 - Definido o limite de 1000 postos por mensagem
//        | devido erro de String size overflow
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function VNDA240(aParSch)

Local lReturn	:= .T.
Local lContinua := .T.
Local cQrySZ3	:= ""
Local cxmlret	:= ""
Local cEmpSch	:= ""
Local cFilSch	:= ""
Local cMV_VNDA240 := 'MV_VNDA240'
Local nREGMAX := 0
Local nCount  := 1
Local _lJob 	:= (Select('SX6')==0)

Private nQtde   := 0
Default aParSch	:= {"01","02"}

cEmpSch	:= aParSch[1]
cFilSch	:= aParSch[2]

If _lJob
	RpcSetType(3)
	RpcSetEnv(cEmpSch,cFilSch)
EndIf

If .NOT. SX6->( ExisteSX6( cMV_VNDA240 ) )
	CriarSX6( cMV_VNDA240, 'N', 'Quantidade de postos enviados por mensagem ao HUB. VNDA240.prw', "1000" )
Endif
		
nREGMAX := GetMv( cMV_VNDA240 )

// #TP20130218 - Restricao de Postos / Inclusao do campo de rede
cQrySZ3 := "SELECT Z3_CODENT, Z3_CODGAR, Z3_DESENT, Z3_CGC, Z3_ESTADO, Z3_MUNICI, Z3_LOGRAD, Z3_NUMLOG, Z3_BAIRRO, Z3_COMPLE, Z3_CEP,"
cQrySZ3 += " Z3_DDD, Z3_TEL, Z3_REDE, Z3_RAZSOC, Z3_NMFANT, Z3_ATIVO, Z3_ENTREGA, Z3_LATITUD,  Z3_LONGITU "
cQrySZ3 += "FROM " + RetSqlName("SZ3") + " "
cQrySZ3 += "WHERE Z3_FILIAL = '" + xFilial("SZ3") + "' "
cQrySZ3 += "  AND Z3_LOGRAD <> '" + Space(TamSX3("Z3_LOGRAD")[1]) + "' "
cQrySZ3 += "  AND Z3_CODGAR <> '" + Space(TamSX3("Z3_CODGAR")[1]) + "' "
cQrySZ3 += "  AND Z3_MUNICI <> '" + Space(TamSX3("Z3_MUNICI")[1]) + "' "
cQrySZ3 += "  AND Z3_BAIRRO <> '" + Space(TamSX3("Z3_BAIRRO")[1]) + "' "
cQrySZ3 += "  AND Z3_ESTADO <> '" + Space(TamSX3("Z3_ESTADO")[1]) + "' "
cQrySZ3 += "  AND LENGTH(TRIM(Z3_CEP)) = 8 "
cQrySZ3 += "  AND Z3_CEP <> '00000000' "
cQrySZ3 += "  AND LENGTH(TRIM(Z3_TEL)) >= 10 "
cQrySZ3 += "  AND Z3_TIPENT = '4' "
cQrySZ3 += "  AND D_E_L_E_T_ = ' ' "
cQrySZ3 += "  AND Z3_LATITUD > ' ' "
cQrySZ3 += "  AND Z3_LONGITU > ' ' "
cQrySZ3 += "ORDER BY Z3_ESTADO, Z3_MUNICI, Z3_CODENT, Z3_NMFANT "

cQrySZ3 := ChangeQuery(cQrySZ3)

TCQUERY cQrySZ3 NEW ALIAS "QRYSZ3"
DbSelectArea("QRYSZ3")

QRYSZ3->(DbGoTop())
If QRYSZ3->(!Eof())
	While QRYSZ3->(!Eof())
		cxmlret += '		<posto>' + CRLF
		cxmlret += '			<nome>' + AllTrim(QRYSZ3->Z3_DESENT) + '</nome>' + CRLF 
		cxmlret += '			<cnpj>' + AllTrim(QRYSZ3->Z3_CGC) + '</cnpj>' + CRLF
		cxmlret += '			<codGAR>' + AllTrim(QRYSZ3->Z3_CODGAR) + '</codGAR>' + CRLF
		IF QRYSZ3->Z3_ATIVO == 'S'
			cxmlret += '			<status>' + AllTrim(QRYSZ3->Z3_ENTREGA) + '</status>' + CRLF
		Else
			cxmlret += '			<status>' + 'N' + '</status>' + CRLF
		EndIF	
		cxmlret += '			<endereco>' + CRLF
		cxmlret += '				<desc>' + AllTrim(QRYSZ3->Z3_LOGRAD) + '</desc>' + CRLF 
		cxmlret += '				<bairro>' + Upper(FwCutOff(AllTrim(QRYSZ3->Z3_BAIRRO),.T.)) + '</bairro>' + CRLF
		cxmlret += '				<numero>' + AllTrim(QRYSZ3->Z3_NUMLOG) + '</numero>' + CRLF
		cxmlret += '				<compl>' + AllTrim(QRYSZ3->Z3_COMPLE) + '</compl>' + CRLF
		cxmlret += '				<cep>' + AllTrim(QRYSZ3->Z3_CEP) + '</cep>' + CRLF
		cxmlret += '				<fone>' +  AllTrim(QRYSZ3->Z3_TEL) + '</fone>' + CRLF
		cxmlret += '				<cidade>' + CRLF
		cxmlret += '					<nome>' + Upper(FwCutOff(AllTrim(QRYSZ3->Z3_MUNICI),.T.)) + '</nome>' + CRLF 
		cxmlret += '					<uf>' + CRLF 
		cxmlret += '						<sigla>' + Upper(FwCutOff(AllTrim(QRYSZ3->Z3_ESTADO),.T.)) + '</sigla>' + CRLF 
		cxmlret += '					</uf>' + CRLF 
		cxmlret += '				</cidade>' + CRLF
		cxmlret += '				<latitude>' + AllTrim(QRYSZ3->Z3_LATITUD) + '</latitude>' + CRLF
		cxmlret += '				<longitude>' + AllTrim(QRYSZ3->Z3_LONGITU) + '</longitude>' + CRLF
		cxmlret += '			</endereco>' + CRLF        
		cxmlret += '				<rede>' + AllTrim(QRYSZ3->Z3_REDE) + '</rede>' + CRLF		// #GR20130621
		cxmlret += '		</posto>' + CRLF
		QRYSZ3->(DbSkip())
		nCount += 1
		IF nCount > nREGMAX //Definido o limite de 1000 postos por mensagem devido erro de String size overflow
			SendMSGPosto(cxmlret)
			cxmlret := ''	
			nCount  := 0
		EndIF
	EndDo
	
	IF .NOT. Empty( cxmlret )
		SendMSGPosto(cxmlret)
	EndIF
EndIf

DbSelectArea("QRYSZ3")
DbCloseArea()

Return(lReturn)
//---------------------------------------------------------------------
// Rotina | SendMSGPosto | Autor | Rafael Beghini | Data | 17.06.2016
//---------------------------------------------------------------------
// Descr. | Rotina para enviar a mensagem ao HUB de Postos
//        | 
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
Static Function SendMSGPosto(cXML)
	Local cDados      := ''
	Local cError      := ''
	Local cSvcError   := ''
	Local cSoapFCode  := ''
	Local cSoapFDescr := ''
	Local lOk         := .T.
	Local oWsObj
	
	nQtde += 1
	
	cDados := XML_VERSION
	cDados += '<listPostoType>' + CRLF
	cDados += '		<code>1</code>' + CRLF
	cDados += '		<msg>Solicitação das informações do(s) posto(s) ok</msg>' + CRLF
	cDados += '		<exception></exception>' + CRLF
	
	cDados += cXML
	
	cDados += '</listPostoType>' + CRLF
	
	oWsObj := WSVVHubServiceService():New()
	
	lOk := oWsObj:sendMessage("ATUALIZA-POSTOS",cDados)
	
	cSvcError   := GetWSCError()  // Resumo do erro
	cSoapFCode  := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
	If !empty(cSoapFCode)
		//Caso a ocorrência de erro esteja com o fault_code preenchido ,
		//a mesma teve relação com a chamada do serviço .
		MsgStop(cSoapFDescr,cSoapFCode)
		Conout('VNDA240 > ' + cSoapFDescr + ' ' + cSoapFCode)
		Return(.F.)
	ElseIf !Empty(cSvcError)
		//Caso a ocorrência não tenha o soap_code pree
		//Ela está relacionada a uma outra falha ,
		//provavelmente local ou interna.
		MsgStop(cSvcError,'FALHA INTERNA DE EXECUCAO DO SERVIÇO')
		Conout('VNDA240 > ' + cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIÇO')
		Return(.F.)
	Endif
	
	IF lOk
		Conout('VNDA240 [ATUALIZA-POSTOS] > Mensagem enviada com sucesso em ['+DtoC(Date())+"-"+Time()+'] - ' + lTrim(Strzero(nQtde,3)) + 'º vez.')
	Else
		Conout('VNDA240 [ATUALIZA-POSTOS] > Não foi possível comunicação com o HUB em ['+DtoC(Date())+"-"+Time()+']')
	EndIf
Return