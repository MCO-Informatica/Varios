#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSFA115   บ Autor ณ Renato Ruy      	 บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envio de email generico para agenda.						  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign - Agenda do Operador                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSFA115(cAssunto,cParametro,aInfo)

Default cAssunto 	:= ""
Default cParametro 	:= ""
Default aInfo	 	:= {}

cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
cHTML += '<html>'
cHTML += '	<head>'
cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
cHTML += '		<title>Aviso de Fraude</title>'
cHTML += '	</head>'
cHTML += '	<body>'
cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
cHTML += '			<tbody>'
cHTML += '				<tr>'
cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle" colspan="4">'
cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Agenda Certisign</strong></font></span><br />'
cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
cHTML += '						<p>'
cHTML += '							&nbsp;</p>'
cHTML += '					</td>'
cHTML += '					<td align="right" width="210">'
cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
cHTML += '						&nbsp;</td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td bgcolor="#F4811D" colspan="5" height="4" width="0">'
cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td colspan="5" style="padding:5px;" width="0">'
cHTML += '						<p>'
cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
cHTML += '						<p>'
cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Segue abaixo os dados;<strong></font></span></span></p>'
cHTML += '					</td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td bgcolor="#02519B" colspan="5" height="2" width="0">'
cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHTML += '				</tr>'

cHTML += '				<tr><td bgcolor="#F4811D" colspan=5><b>'+cAssunto+'</b></td></tr>'

For i := 1 to Len(aInfo)
	cHTML += '				<tr><td colspan=5>'+aInfo[i]+'</td></tr>'
Next

cHTML += '				<tr>'
cHTML += '					<td colspan="5" style="padding:5px" width="0">'
cHTML += '						<p align="left">'
cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
cHTML += '					</td>'
cHTML += '				</tr>'
cHTML += '			</tbody>'
cHTML += '		</table>'
cHTML += '		<p>'
cHTML += '			&nbsp;</p>'
cHTML += '	</body>'
cHTML += '</html>'

FSSendMail( ;
			UsrRetMail(__cUserID)+";"+AllTrim(GetMv(cParametro)),; 
			cAssunto, ;
			cHTML )
Return