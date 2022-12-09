#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHFXML00X  บAutor  ณRoberto Souza       บ Data ณ  01/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface/Dialog de Aviso.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HFXML00X(cCodProd,cVersion,cCNPJ,dVencLic,lAv)
Local lRet      := .F.
Local cChave    := ""
Local cBaseCNPJ := SUBSTR(cCNPJ,1,14) //a partir de 10 de abril chave exclusiva por filial
Local cFileKey  := cCodProd+cBaseCNPJ+".hfc"
Local nEnviar   := 99
Local cMsg      := ""
Default lAv := .T.

If File(cFileKey)
	cChave := memoRead(cCodProd+cBaseCNPJ+".hfc") 
	cKey := cCodProd+;
			cBaseCnpj+;
		 	'HF-CONSULTING-XML'
	
	cKey := Upper(Sha1(cKey))
	dDateVenc := Stod( Substr(Decode64(Substr(cChave,41)),1,8) )
	dVencLic  := dDateVenc
	If Substr(cKey,1,40) == Substr(cChave,1,40)
		If Date() <= dDateVenc
			lRet := .T.			 
			nDaysLeft := (dDateVenc -Date())
			If nDaysLeft < 30 
				cMsgAviso:="A licen็a irแ expirar em "+AllTrim(Str(nDaysLeft))+" dias!" +CHR(13)+CHR(10)+"Entre em contato com a HF - Consulting." +CHR(13)+CHR(10)+;
				"Tel: 11-5524-5124 ou Pelo E-mail comercial@hfbr.com.br."
				if lAv
	           		Aviso("Aviso", cMsgAviso,{"OK"},3)
	   			endif
	           	nEnviar := nDaysLeft
	           	if nEnviar == 0
			    	cMsg := "A licen็a do ImportaXml irแ expirar amanha!" +CHR(13)+CHR(10)
	           	else
			    	cMsg := "A licen็a do ImportaXml irแ expirar em "+AllTrim(Str(nEnviar))+" dias!" +CHR(13)+CHR(10)
			    endif
			EndIf
		Else
			cMsgAviso:="Licen็a expirada!" +CHR(13)+CHR(10)+"Entre em contato com a HF - Consulting." +CHR(13)+CHR(10)+;
			"Tel: 11-5524-5124 ou Pelo E-mail comercial@hfbr.com.br."
			if lAv
           		Aviso("Aviso", cMsgAviso,{"OK"},3)
   			endif
           	nEnviar := -1 //aquiiiii
		    cMsg    := "Licen็a do ImportaXml expirada!" +CHR(13)+CHR(10)
		EndIf	
	Else
		cMsgAviso:="Licen็a invแlida!" +CHR(13)+CHR(10)+"Entre em contato com a HF - Consulting." +CHR(13)+CHR(10)+;
		"Tel: 11-5524-5124 ou Pelo E-mail comercial@hfbr.com.br." 

		if lAv
			Aviso("Aviso", cMsgAviso,{"OK"},3)
		endif
	EndIf

Else

	cMsgAviso:= "Licen็a nใo encontrada!" +CHR(13)+CHR(10)+"Entre em contato com a HF - Consulting." +CHR(13)+CHR(10)+;
	"Tel: 11-5524-5124 ou Pelo E-mail comercial@hfbr.com.br."

	if lAv
		Aviso("Aviso", cMsgAviso,{"OK"},3)
	endif

EndIf

EmailCom(cCodProd,cCNPJ,cMsg,nEnviar)

Return(lRet)



Static Function EmailCom( cCodProd,cCNPJ,cMsg,nEnviar )
Local cBaseCNPJ := SUBSTR(cCNPJ,1,14)  // 8 para 14                 
Local cFileEma  := cCodProd+cBaseCNPJ+".hfe"
Local aTo       := {}
Local cAssunto  := ""
Local cEma      := ""
Local cError    := ""
Local nMsg      := 0
Local cMsgCfg   := ""

if file(cFileEma)
	if nEnviar == 99
		FErase(cFileEma)
	else
		cEma := MemoRead(cFileEma)
		if val(cEma) == -1 //Para enviar somente uma vez depois de expirado
		   nEnviar := 99
		else
			if (val(cEma) - nEnviar) < 10 //Para enviar de 10 em 10 dias
			   if (val(cEma) = nEnviar) .or. nEnviar > 0 //para nใo pular o ultimo dia e o expirado.
			   		nEnviar := 99
			   endif
			endif
		endif
	endif
endif
if nEnviar <> 99
    aTo  := Separa("comercial@hfbr.com.br",";")
    cAssunto := "Aviso de Vencimento de Licen็a "+alltrim(SM0->M0_NOMECOM)
    cMsg += "<br>CNPJ: ("+cCNPJ+") "+transform(cCNPJ, "@R 99.999.999/9999-99")
    cMsg += "<br>Empresa: "+ SM0->M0_NOMECOM
    
    cMsgCfg := ''
    cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">'
	cMsgCfg += '<body>'
	cMsgCfg += '<p>'
	cMsgCfg += cMsg
	cMsgCfg += '</p>'
	cMsgCfg += '</body>'
	cMsgCfg += '</html>'

	nMsg :=	U_MAILSEND(aTo,cAssunto,cMsgCfg,@cError,"","","comercial@hfbr.com.br","","")
	if nMsg == 0
		cEma := AllTrim(Str(nEnviar))
		MemoWrite(cFileEma,cEma)
	endif
endif

Return


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_HFXML00X()
	EndIF
Return(lRecursa)