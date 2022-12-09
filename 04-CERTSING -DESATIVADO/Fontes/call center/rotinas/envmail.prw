#INCLUDE "PROTHEUS.CH"


USER FUNCTION EnvMail(cEstPara,aPara,lNew)

Local lResulConn := .T.
Local lResulSend := .T.
Local lResult := .T.
Local cError := ""
Local cServer   := Trim(GetMV('MV_RELSERV'))   // Ex.: smtp.ig.com.br ou
Local cConta    := Trim(GetMV('MV_RELACNT'))   // Conta Autenticacao Ex.: fuladetal@fulano.com.br
Local cPsw      := Trim(GetMV('MV_RELAPSW'))   // Senha de acesso Ex.: 123abc
Local lRelauth  := SuperGetMv("MV_RELAUTH",, .F.) // Parametro que indica se existe autenticacao no e-mail
Local lRet     := .F.        // Se tem autorizacao para o envio de e-mail
Local cDe := cConta
Local cAssunto := ""
Local cMsg := ""
Local aArea := GetArea() 
Local cPara := ""

Default lNew := .f.
            
If Substr(ZCE->ZCE_ESTNOV,1,3) = "007"        
	cAssunto := UPPER("CRM - " + IIf(ACZ->ACZ_ACAO $ "1,2","AVANÇO","RETORNO") + " / Etapa anterior  " + iif(lNew, " INCLUSÃO E OPORTUNIDADE " ,AD1->AD1_STAGE) + " Para etapa atual  " + cEstPara +" / Oportunidade "+ Alltrim( AD1->AD1_DESCRI ) + " / Cliente: " + IIF(Empty( Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )),Posicione("SUS",1,xFilial("SUS")+AD1->AD1_PROSPE+AD1->AD1_LOJPRO,"US_NOME"),Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" ))) + " / Nome do Ganhador: " + POSICIONE("AC3", 1,xfilial("AC3")+POSICIONE("AD3",1,xFilial("AD1")+AD1->AD1_NROPOR,"AD3_CODCON"), "AC3_NOME" )// + " / Valor Ganho: R$" + IIF(AD3->AD3_PRECO = 0,0,ALLTRIM(STR(Transform(AD3->AD3_PRECO,"@ze 999,999,999.99"))))
Else
	cAssunto := UPPER("CRM - " + IIf(ACZ->ACZ_ACAO $ "1,2","AVANÇO","RETORNO") + " / Etapa anterior  " + iif(lNew, " INCLUSÃO E OPORTUNIDADE " ,AD1->AD1_STAGE) + " Para etapa atual  " + cEstPara +" / Oportunidade "+ Alltrim( AD1->AD1_DESCRI ) + " / Cliente: " + IIF(Empty( Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )),Posicione("SUS",1,xFilial("SUS")+AD1->AD1_PROSPE+AD1->AD1_LOJPRO,"US_NOME"),Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )))
EndIf
//Transform(Val(AD3->AD3_PRECO),"@ze 999,999,999.99")
cMsg := "Prezados," + CRLF + CRLF 
cMsg += "Alertamos para"+iiF(lNew," Inclusão ", " alteração ")+"da oportunidade: " + AD1->AD1_NROPOR 
cMsg += " cliente " + IIF(Empty( Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )),;
									Posicione("SUS",1,xFilial("SUS")+AD1->AD1_PROSPE+AD1->AD1_LOJPRO,"US_NOME"),;
									Posicione( "SA1", 1, xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI, "A1_NOME" )) 
cMsg += "-" +AD1->AD1_DESCRI  
cMsg += " do estágio " + iif( lNew," Inclusão de Oportunidade ",AD1->AD1_STAGE + " - " + Posicione( "AC2", 1, xFilial("AC2") + AD1->AD1_PROVEN + AD1->AD1_STAGE , "AC2_DESCRI" ) ) 
cMsg += " para o " + cEstPara + " - " + Posicione( "AC2", 1, xFilial("AC2") + AD1->AD1_PROVEN + cEstPara , "AC2_DESCRI" )  
cMsg += " na data " + dToC(ddatabase) + CRLF + CRLF 
cMsg += "Obs. apontamento:" + CRLF + CRLF +MSMM(AD5->AD5_CODMEN) + CRLF + CRLF 
cMsg += "Obs. oportunidade:" + CRLF + CRLF + MSMM(AD1->AD1_CODMEM) + CRLF + CRLF 
If lNew
	cMsg += "Atc." + CRLF + CRLF + Posicione("SA3",1,xFilial("SA3")+AD1->AD1_VEND,"A3_NOME")
Else
	cMsg += "Atc." + CRLF + CRLF + Posicione("SA3",1,xFilial("SA3")+AD5->AD5_VEND,"A3_NOME")
EndIf


lResulConn := MailSmtpOn( cServer, cConta, cPsw, 60)
If !lResulConn // Exibe mensagem de erro de nao houver conexão
	cError := MailGetErr()
	                                                                                                                                                 
	MsgAlert("Falha na conexao "+cError)
	
	Return(.F.)
Endif

If lRelauth
	lResult := MailAuth(Alltrim(cConta), Alltrim(cPsw))
	
	If !lResult
		//	nA := At("@",cConta)
		//	cUser := If(nA>0,Subs(cConta,1,nA-1),cConta)
		lResult := MailAuth(Alltrim(cConta), Alltrim(cPsw))
	Endif
Endif

If lResult
	
	lResulSend:= MailSend(cConta,aPara,{},{},cAssunto,cMsg,{},.F.)
	IF !lResulSend
		cError := MailGetErr()
		MsgAlert("Falha no envio do e-mail " + cError)
	EndIf
Else
	MsgAlert("Falha no envio do e-mail " + cError)
Endif

MailSmtpOff()

IF lResulSend
	aeval(aPara,{|x| cPara += x+", "   })
	MsgInfo("E-mail enviado com sucesso para " + cPara + "." + cError)
	
ENDIF

RestArea(aArea)

RETURN lResulSend

