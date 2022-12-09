#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"

User Function HCIBM001(_cEmpFil)

	Local _cFil
	Local _cEmp
	Local _cNumPc
	
	Private aFiles:= { 'SA1','SA2','SA3','SA4','SB1','SB2','SB6','SB8','SBJ','SBZ','SC5','SC6',;
	'SC9','SD1','SD2','SD5','SE1','SE2','SF1','SF2','SF3','SF4',;
	'CT1','CT2', 'CT5', 'CTT','CTK','CTJ','CTI','SM0','SM4' }
	
	RpcSetType(3)
	
	If Valtype(_cEmpFil) != "A"
		_cFil := cFilAnt
		_cEmp := cEmpAnt
		_cNumPc:=SC7->C7_NUM                         
	Else
		_cFil := _cEmpFil[1,2]
		_cEmp := _cEmpFil[1,1]
	EndIf
	
	Conout("<<============ Formato dos Parametros passados ==============>>")
	Conout("Filial   "+Valtype(_cFil))
	Conout("Filial   "+_cFil)
	Conout("<<============ Formato dos Parametros passados ==============>>")
	Conout("Empresa   "+_cEmp)
	
	RpcSetEnv(_cEmp,_cFil,,,,, aFiles ) 
	
	Conout("Chamando funcao - _WFHB001")
	//***************************************************************
	_WFHB001(.F.,"",_cEmp)
	//***************************************************************
	ConOut("Retorno da Funcao - _WFHB001")
	
	RpcClearEnv() //Limpa o ambiente, liberando a licença e fechando as conexões                               
	

Return()

Static Function _WFHB001(_lNextApv,_cNumPC,_cEmp)

	Local _nVlrTot		:= 0
	Local _nICMTot		:= 0
	Local _nIPITot		:= 0
	Local _nFreTot		:= 0
	Local _nTotDes		:= 0
	Local _nTotSeg		:= 0
	Local _cAliasSC7	:= GetNextAlias()
	Local _cQuery		:= ""
	Local _cMsg			:= ""
	Local _cPara		:= ""
	Local _cAssunto		:= ""
	Local _aArea		:= GetArea()
	Local cHostWF		:= GetMv("ES_HWFHOST",,"http://201.28.59.194:8088/WF")	
	Private _oHTML
	Private _oProcess
	
	_cNumPc:=SC7->C7_NUM
	_cQuery	:= "SELECT DISTINCT C7_FILIAL, C7_NUM "
	_cQuery += " FROM " + RetSqlName("SC7")
	_cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
	If !_lNextApv
 //		_cQuery += " AND C7_XWFE = 'F' "
		_cQuery += " AND C7_NUM = '" + _cNumPC + "' "
	Else
		_cQuery += " AND C7_NUM = '" + _cNumPC + "' "
	EndIf
	_cQuery+= " AND C7_CONAPRO = 'B' "
	_cQuery+= " AND C7_TIPO = 1 "
	_cQuery+= " AND D_E_L_E_T_ = ' ' "
	_cQuery+= " ORDER BY C7_NUM "
	TCQUERY _cQuery NEW ALIAS &(_cAliasSC7)
	
	If (_cAliasSC7)->(!EOF())
		
		dbSelectArea("SCR")
		SCR->(dbSetOrder(1))
		
		dbSelectArea("SC7")
		SC7->(dbSetOrder(1))
		
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		
		dbSelectArea("SE4")
		SE4->(dbSetOrder(1))
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		
		While (_cAliasSC7)->(!EOF())
			
			If SCR->(dbSeek(xFilial("SCR") + "PC" + (_cAliasSC7)->C7_NUM))	
				While SCR->(!EOF()) .And. AllTrim(SCR->CR_NUM) == (_cAliasSC7)->C7_NUM .And. SCR->CR_TIPO == "PC"
					If SCR->CR_STATUS <> "02"
						SCR->(dbSkip())
						Loop
					EndIf
					
					If SC7->(dbSeek(xFilial("SC7") + (_cAliasSC7)->C7_NUM))
						If SA2->(dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))
							If SE4->(dbSeek(xFilial("SE4") + SC7->C7_COND))
							
								_cAssunto	:= "AVISO APROVAÇÃO DE PEDIDO DE COMPRA NR " + SC7->C7_NUM
							
								_oProcess := TWFProcess():New( "PEDCOM", "Aviso Pedido de Compras" )
								_oProcess:NewTask( "000001", "\WORKFLOW\AprovacaoPC_" + _cEmp + ".HTM" )
								
								_oProcess:cSubject := "AVISO APROVAÇÃO DE PEDIDO DE COMPRA NR " + SC7->C7_NUM
								_oProcess:bReturn  := "U__fWFRPC1()"
								_oProcess:UserSiga := SC7->C7_USER
								_oProcess:NewVersion(.T.)
								_oHTML   := _oProcess:oHTML
								_oHTML:ValByName( "FILIAL"    , SC7->C7_FILIAL )
								_oHTML:ValByName( "NUMPC"     , SC7->C7_NUM )
								_oHTML:ValByName( "CAPROV"    , SCR->CR_USER )
								_oHTML:ValByName( "APROVADOR" , UsrRetname(SCR->CR_USER)  )
								_oHTML:ValByName( "EMISSAO"   , SC7->C7_EMISSAO)
								_oHTML:ValByName( "FORNEC"    , Alltrim(SA2->A2_COD)+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME)
								_oHTML:ValByName( "COND"      , SE4->E4_CODIGO+" ( "+Alltrim(SE4->E4_DESCRI)+" )")
								
								While SC7->(!EOF()) .And. AllTrim(SC7->C7_NUM) == AllTrim((_cAliasSC7)->C7_NUM)
									
									If SB1->(dbSeek(xFilial("SB1") + SC7->C7_PRODUTO))
								
										AAdd( (_oHTML:ValByName( "prod.cItem"    )),SC7->C7_ITEM )
										AAdd( (_oHTML:ValByName( "prod.cCod"     )),SC7->C7_PRODUTO )
										AAdd( (_oHTML:ValByName( "prod.cDesc"    )),SC7->C7_DESCRI )
										AAdd( (_oHTML:ValByName( "prod.cUM"      )),SC7->C7_UM )
										AAdd( (_oHTML:ValByName( "prod.nQuant"   )),TRANSFORM( SC7->C7_QUANT,'@E 999,999,999.99' ) )
										AAdd( (_oHTML:ValByName( "prod.nVrUnit"  )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
										AAdd( (_oHTML:ValByName( "prod.nIPI"     )),TRANSFORM( SC7->C7_IPI,'@E 999,999,999.99' ) )
										AAdd( (_oHTML:ValByName( "prod.nVrTot"   )),TRANSFORM( SC7->(C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE),'@E 999,999,999.99' ) )
										AAdd( (_oHTML:ValByName( "prod.dEntrega" )),SC7->C7_DATPRF )
										AAdd( (_oHTML:ValByName( "prod.nEstoque" )),TRANSFORM(CalcEst(SB1->B1_COD,SB1->B1_LOCPAD,dDataBase)[1],'@E 999,999,999.99' ) )
										
										WFSalvaID('SC7','SC7->C7_XWFE', .T.)
												
										_nVlrTot	+= (SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_SEGURO + SC7->C7_DESPESA + SC7->C7_VALFRE)
										_nICMTot	+= SC7->C7_VALICM
										_nIPITot	+= SC7->C7_VALIPI
										_nFreTot	+= SC7->C7_VALFRE
										_nTotDes	+= SC7->C7_DESPESA
										_nTotSeg	+= SC7->C7_SEGURO
										
									EndIf										
									
									SC7->(dbSkip())
								EndDo
								
								_oHTML:ValByName( "ICMS"      ,TRANSFORM(_nICMTot,"@E 999,999,999.99"))
								_oHTML:ValByName( "IPI"       ,TRANSFORM(_nIPITot,"@E 999,999,999.99"))
								_oHTML:ValByName( "FRETE"     ,TRANSFORM(_nFreTot,"@E 999,999,999.99"))
								_oHTML:ValByName( "DESPESA"   ,TRANSFORM(_nTotDes,"@E 999,999,999.99"))
								_oHTML:ValByName( "SEGURO"    ,TRANSFORM(_nTotSeg,"@E 999,999,999.99"))
								_oHTML:ValByName( "NTOTAL"    ,TRANSFORM(_nVlrTot ,"@E 999,999,999.99"))
								
								_oProcess:cTo := "APROVPC"
								cMailID := _oProcess:Start("\web\messenger\emp"+cEmpAnt+"\APROVPC\")
								
								_cMsg := "<html>"
								_cMsg += "<head>"
								_cMsg += "<title>Untitled Document</title>"
								_cMsg += "</head> "
								_cMsg += "<body> "
								_cMsg += "  <p>&nbsp;</p>"
								_cMsg += "  <p>Prezado(a) " + AllTrim(UsrRetName(SCR->CR_USER)) + ", </p>"
								_cMsg += "  <p>Favor acessar o <a href='"+Alltrim(cHostWF)+"/WEB/messenger/emp" + cEmpAnt + "/APROVPC/" + cMailID + ".htm'" +">link</a>" 
								_cMsg += "    para analise da aprovação do pedido de compra. </p>"
								_cMsg += "	<p>Grato(a),"
								_cMsg += "</body>"
								_cMsg += "</html>"

								_cPara		:= AllTrim(UsrRetMail(SCR->CR_USER))
								
								MailDSC(_cPara, _cAssunto, _cMsg, "")
								_nVlrTot	:= 0
								_nICMTot	:= 0
								_nIPITot	:= 0
								_nFreTot	:= 0
								_nTotDes	:= 0
								_nTotSeg	:= 0
							EndIf
						EndIf
					EndIf
					
					SCR->(dbSkip())
				EndDo				
			EndIf
			_nVlrTot	:= 0
			_nICMTot	:= 0
			_nIPITot	:= 0
			_nFreTot	:= 0
			_nTotDes	:= 0
			_nTotSeg	:= 0
			(_cAliasSC7)->(dbSkip())
		EndDo
	EndIF
	
	RestArea(_aArea)

Return()                                                     


User Function _fWFRPC1(oProcess)

	_cFilial	:= alltrim(oProcess:oHtml:RetByName("FILIAL"))
	_cFilial	:= IIF(Alltrim(_cFilial)=="",Xfilial("SC7"),_cFilial)
	_cNumPC		:= alltrim(oProcess:oHtml:RetByName("NUMPC"))
	_cObs		:= alltrim(oProcess:oHtml:RetByName("OBS"))
	_cAprov		:= alltrim(oProcess:oHtml:RetByName("CAPROV"))
	cOpc		:= alltrim(oProcess:oHtml:RetByName("OPC"))
	_cObsSCR	:= IIF(cOpc == "APROVAR","Aprovado pelo WF APVPC","Reprovado pelo WF APVPC")
	
	_cObsPC := "===========================================" +CRLF
	_cObsPC += "[" + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time() + "]"+CRLF
	_cObsPC += "[" +_cObsSCR + " ]" +CRLF
	_cObsPC += "[ Usuario - " + UsrFullName(_cAprov) + " ]" +CRLF
	_cObsPC += AllTrim(_cObs)+CRLF
	_cObsPC += "===========================================" +CRLF

	
	oProcess:Finish() // FINALIZA O PROCESSO
	lLiberou := .f.
	
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(_cFilial+_cNumPC))
	
	dbSelectArea("SCR")
	SCR->(dbSetOrder(2))
	IF SCR->(dbSeek(XFilial("SCR")+"PC"+_cNumPC+Space(TamSx3("CR_NUM")[1]-Len(_cNumPC))+_cAprov))
		If Empty(SCR->CR_DATALIB)
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV,,,,,_cObsSCR},dDataBase,IIF(cOpc == "APROVAR",4,6))
			If !Empty(SCR->CR_DATALIB) .And. !lLiberou
				lLiberou	:= .T.
			EndIf
		EndIf
	ELSE
		ConOut('Alcada nao encontrada!!!')
	ENDIF
	
	If lLiberou
		IF cOpc == "APROVAR"
			_fVerif(_cFilial,_cNumPC,_cObs)
			DbSelectArea("SC7")
			DbSetOrder(1)
			DbSeek(_cFilial+_cNumPC)
			_cObsPC += AllTrim(SC7->C7_XOBSWF)
			While !Eof() .And. SC7->(C7_FILIAL+C7_NUM) == _cFilial+_cNumPC
				If RecLock("SC7",.F.)
					SC7->C7_XOBSWF := _cObsPC
					SC7->(msUnlock())
				EndIf
				SC7->(DbSkip())
			EndDo
		ELSE
			DbSelectArea("SC7")
			DbSetOrder(1)
			DbSeek(_cFilial+_cNumPC)
			_cObsPC += AllTrim(SC7->C7_XOBSWF)
			While !Eof() .And. SC7->(C7_FILIAL+C7_NUM) == _cFilial+_cNumPC
				If RecLock("SC7",.F.)
					SC7->C7_XOBSWF := _cObsPC
					SC7->(msUnlock())
				EndIf
				SC7->(DbSkip())
			EndDo
		ENDIF
	EndIf
	
Return()

Static Function _fVerif(_cFil,_cPedido,_cObs,_cNiv)

	Local _cQuery  := ""
	Local _cArqSCR := CriaTrab(nil,.f.)
	
	// verifica se o pedido foi totalmente liberado
	_cQuery := "SELECT * FROM "+RetSqlName("SCR")+" "
	_cQuery += "WHERE D_E_L_E_T_ = '' AND CR_FILIAL = '"+XFilial("SCR")+"' AND CR_NUM = '"+_cPedido+"' AND CR_STATUS NOT IN ('03','05') "
	_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqSCR,.t.,.t.)
	
	dbSelectArea(_cArqSCR)
	IF Eof()
		
		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(_cFil+_cPedido)
		
		While !Eof() .And. SC7->(C7_FILIAL+C7_NUM) == _cFil+_cPedido
			If RecLock("SC7",.F.)
				SC7->C7_CONAPRO	:= "L"
				SC7->(msUnlock())
			EndIf
			SC7->(DbSkip())
		EndDo
	ELSE
		_WFHB001(.T.,_cPedido, cEmpAnt) // envia e-mail para o proximo aprovador
	ENDIF

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} MailDSC
Funcao para envio de email em caso de conta SMTP usar criptografia TLS

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/10/2014
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function MailDSC(cPara, cAssunto, cMsg, cCC)

	Local oMail 
	Local oMessage
	Local nErro
	Local lRet 			:= .T.
	Local cSMTPServer	:= Alltrim(GetMV("MV_WFSMTP"))
	Local cSMTPUser		:= Alltrim(GetMV("MV_WFAUTUS"))
	Local cSMTPPass		:= Alltrim(GetMV("MV_WFAUTSE"))
	Local cMailFrom		:= cSMTPUser
	Local nPort	   		:= 587
	Local lUseAuth		:= .T.
	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
//	oMail:SetUseTLS(.t.)
	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( 30 )
	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()
	
	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		EndIf
	EndIf
	
	If nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
		lRet := .F.
	EndIf 
	
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cMailFrom
		oMessage:cTo		:= cPara
		oMessage:cCC		:= cCC
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
		
		If nErro <> 0
			xError := oMail:GetErrorString(nErro)
			conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Else
			conout("Mensagem enviada com sucesso!")
		EndIf
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	EndIf
Return lRet