#include "protheus.ch"
#include "parmtype.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WFGEFOR   ณAutor  ณ  Junior Carvalho   ณ Data ณ 18/09/2019  บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar o e-mail de altera็ใo do Fornecedor                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA020                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WFGEFOR(aDadosBco)
Local nX:= 0 
Private cForn := aDadosBco[1,1]+' '+aDadosBco[1,2]+' - '+aDadosBco[1,3]
Private cAssunto := 'Altera็ใo dados Bancแrios . Fornecedor ' + cForn

cTO := ''
cCc := ''
cBcc := ''
cBody := CORPOEMAIL(aDadosBco)
aAttach := {}
cUsuarios := GetMv("ES_MAILFOR") // 000556

aUsuarios := StrToArray( cUsuarios, ";")

For nX:= 1 TO Len(aUsuarios)
	
	cTO += alltrim(UsrRetMail(aUsuarios[nX]))+';'
	
Next nX



U_ENVMAILIMCD(cTO,cCc,cBcc, cAssunto,cBody,aAttach)

Return()

Static Function CORPOEMAIL( aDadosBco )

Local cMensagem := ' '

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '<title> '+cAssunto+'</title>'
cMensagem += '</head>'
cMensagem += '<body>'

cMensagem += '<p>Os dados Bancแrios do Fornecedor: <strong>'+cForn+'</strong>, foram alterados, confira abaixo as Altera็๕es.</p>'
cMensagem += '<p>O Fornecedor estแ bloqueado para gera็ใo de Border๔s de pagamento</p>
cMensagem += '<p>Para desbloquear acesse o Protheus e realize a libera็ใo no Cadastro do Fornecedor.</p>

cMensagem += '<table border="1" cellpadding="1" cellspacing="1" style="width: 800px">'
cMensagem += '	<thead>'
cMensagem += '	<tr>'
cMensagem += '	<th scope="col"> </th>'
cMensagem += '	<th scope="col">Banco</th>'
cMensagem += '	<th scope="col">Ag๊ncia</th>'
cMensagem += '	<th scope="col">Conta</th>'
cMensagem += '	</tr>'
cMensagem += '	</thead>'
cMensagem += '<tbody>'

cMensagem += '<tr>'
cMensagem += '<td>De</td>'
cMensagem += '<td>'+aDadosBco[2][3]+' </td>
cMensagem += '<td>'+aDadosBco[3][3]+'</td>
cMensagem += '<td>'+aDadosBco[4][3]+'</td>
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td>Para </td>'
cMensagem += '<td>'+aDadosBco[2][2]+' </td>
cMensagem += '<td>'+aDadosBco[3][2]+'</td>
cMensagem += '<td>'+aDadosBco[4][2]+'</td>
cMensagem += '</tr>'

cMensagem += '</tbody>'
cMensagem += '</table>'

cMensagem += '<p>Data da Altera็ใo: <strong>'+DTOC(DDATABASE)+'</strong></p>'

cMensagem += '<p>Usuแrio : <strong>'+UsrFullName(__CUSERID)+'</strong> '

cMensagem += '<p>* Este e-mail foi enviado automaticamente pelo Sistema PROTHEUS - WFGRFOR. Favor nใo responder.</p>'
cMensagem += '</body> '
cMensagem += '</html>'

Return(cMensagem)
