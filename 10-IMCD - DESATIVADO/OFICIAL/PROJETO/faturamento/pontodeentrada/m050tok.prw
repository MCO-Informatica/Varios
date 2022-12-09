#Include "Protheus.ch" 

User Function M050TOK()
Local lRet := .T.
local cFields as character
local oImcdLog as object
local aFields as array
local nFields as numeric
local nIndFld as numeric

    If cEmpAnt $ '02|04' .and. !Altera

        // ROTINA PARA DISPARAR O E-MAIL
        cPara			:= AllTrim(GetMV("ES_MAILTRP"))     //TRANSPORTADORA
        cAssunto		:= "Cadastro de Transportadora " 
        cMensagem		:= CORPOEMAIL() 
        aAttach			:= {}

        lEnviou := U_ENVMAILIMCD(cPara,/*com Copia*/"",/*copia oculta*/"",cAssunto,cMensagem,aAttach)

    Endif 

  
    if Altera
        cFields := superGetMv("ES_AUDFL3A", .F., "")+"/"+superGetMv("ES_AUDFL3B", .F., "")
        aFields := strTokArr2(cFields,"/", .F.)
        oImcdLog := ImcdLogAudit():new()
    	nFields := len(aFields)

    	for nIndFld := 1 to nFields
        	if M->&(aFields[nIndFld]) <> SA4->&(aFields[nIndFld])
            	oImcdLog:recordLog("SA4",1,SA4->(A4_FILIAL+A4_COD),aFields[nIndFld] ,SA4->&(aFields[nIndFld]),M->&(aFields[nIndFld]))
       		endif
    	next nIndFld

        aSize(aFields,0)
        freeObj(oImcdLog)

    endif

Return(lRet)         
       

Static Function CORPOEMAIL()    
Local cMensagem := ' '
Local cCodigo := M->A4_COD
Local cNome := M->A4_NOME

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '<title>CADASTRO DE TRANSPORTADORAS '+cCodigo+" - "+cNome+'</title>'
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

  

cMensagem += ' Atenção, <strong>Foi </strong>criado nova Transportadora conforme descrito abaixo:</p><p>'
cMensagem += ' Código : <strong>'+cCodigo+'</strong> - '
cMensagem += ' Nome <strong>'+cNome+'</strong></p>'

cMensagem += '</body> '
cMensagem += '</html>'


Return(cMensagem)
