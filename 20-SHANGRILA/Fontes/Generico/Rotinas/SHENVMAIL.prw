#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndZCY
Static lCopia

/*
* Funcao		:	SHENVMAIL
* Autor			:	João Zabotto
* Data			: 	13/10/2014
* Descricao		:
* Retorno		:
*/
User Function SHENVMAIL(aCabec,aDados,cCabecalho,cAssunto,cRodape,cBody,cMail,cTipoWF,cDirWf,cRemet)
Local aArea		  := GetArea()
Local oEmail      := SHMAIL():New()
Local aMail		  := {}

Default aCabec 		:= {}
Default aDados 		:= {}
Default cCabecalho  := ''
Default cAssunto  	:= ''
Default cRodape		:= ''
Default cBody		:= ''
Default cMail		:= ''
Default cTipoWF		:= ''
Default cDirWf		:= ''
Default cRemet		:= ''

oEmail:aCabec	  := aCabec
oEmail:aDados 	  := aDados
oEmail:cCabecalho := cCabecalho
oEmail:cAssunto   := cAssunto
oEmail:cLogo	  := 'http://www.aegea.com.br/wp-content/uploads/2015/06/logo.png'
oEmail:cRodape 	  := cRodape

If !Empty(oEmail:aDados)
	
	oEmail:lUsaCript    := .T.
	oEmail:cRemet       := Alltrim(GetMv("MV_RELACNT"))
	
	oEmail:cDest        := cMail
	oEmail:DEFAUT()
	
	If GetMv("MV_RELTLS")
		oEmail:cTipoAut     := 'TLS'
	Else
		oEmail:cTipoAut     := ''
	EndIf
	
	If !Empty(cRemet)
		oEmail:cRemet := Alltrim(cRemet)
	EndIF
	
	
	/*oEmail:cConta       := Alltrim(GetMv("MV_RELACNT"))
	oEmail:cUserAut     := Alltrim(GetMv("MV_RELACNT"))
	oEmail:cSenha       := Alltrim(GetMv("MV_RELPSW"))
	oEmail:cSmtp        := Alltrim(GetMv("MV_RELSERV"))
	oEmail:nPorta       := Val(Alltrim('25'))
	oEmail:lAutent      := GetMv("MV_RELAUTH")
	oEmail:cTipoAut     := ''*/
	/*oEmail:cConta       := 'workflow.microsiga@aegea.com.br'
	oEmail:cUserAut     := 'workflow.microsiga@aegea.com.br'
	oEmail:cSenha       := 'f79jNPu9'
	oEmail:cSmtp        := '172.17.1.142'
	oEmail:nPorta       := Val(Alltrim('25'))
	oEmail:lAutent      := GetMv("MV_RELAUTH")
	oEmail:cTipoAut     := ''*/
	
	oEmail:setTipoWf(cTipoWF /*"log_Mov_fiscal"*/)
	oEmail:setDirWf(cDirWf /*"MovFis"*/)
	oEmail:cTexto := oEmail:formToFile(oEmail:aDados)
	
	If oEmail:Conecta()==0
		nRet:= oEmail:ENVIAR2(oEmail:cDest,"","",oEmail:cAssunto,cBody,oEmail:cPatchFile)
		If nRet == 0
			lOk  := .T.
		EndIf
	EndIf
ElseIF !Empty(cBody)
	oEmail:lUsaCript    := .T.
	oEmail:cRemet       := Alltrim(GetMv("MV_RELACNT"))
	
	oEmail:cDest        := cMail
	oEmail:DEFAUT()
	
	If GetMv("MV_RELTLS")
		oEmail:cTipoAut     := 'TLS'
	Else
		oEmail:cTipoAut     := ''
	EndIf         
	
	If !Empty(cRemet)
		oEmail:cRemet := Alltrim(cRemet)
	EndIF
	
	
	If oEmail:Conecta()==0
		nRet:= oEmail:ENVIAR2(oEmail:cDest,"","",oEmail:cAssunto,cBody)
		If nRet == 0
			lOk  := .T.
		EndIf
	EndIf
EndIf
RestArea(aArea)

Return

