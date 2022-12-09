#INCLUDE "PROTHEUS.CH"
#include "fileio.ch"

/*/{Protheus.doc} VNDA610E

Funcao criada para enviar log do portal de assinaturas   

@author Renato Ruy
@since 17/11/2016
@version P11

/*/
User Function VNDA610E(aParSch)
	
	Local cMV_XLOGPAS := ""
	Local cArqLog 	  := ""
	Local _lJob		  := (Select('SX6')==0)
	
	Private aGrupos	  := {}
	Private nTotRec   := 0

	default aParSch	:= {"01","02"}
	
	cJobEmp	:= aParSch[1]
	cJobFil	:= aParSch[2]
	
 	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf
	
	cMV_XLOGPAS := GetNewPar('MV_XLOGPAS',"renato.bernardo@certisign.com.br") //Emails que receberão o e-mail
	cArqLog 	  := "\pedidosfaturados\log_portal-"+DtoS(dDatabase)+".csv"   //Caminho do arquivo gerado
	
	//Le arquivo para montar totais. 
	VNDA610L(cArqLog)
	
	//Envia arquivo para os destinatarios
	VNDA610M("Log Portal de Assinaturas",cMV_XLOGPAS,cArqLog)
			
Return

Static Function VNDA610L(cArqLog)

Local xBuff	  := ""
Local aLin	  := {}
Local nLin	  := 0
Local cCodAc  := ""


nHdl    := fOpen(cArqLog,68)

FT_FUSE(cArqLog)
nTotRec := FT_FLASTREC()-1 //Busca quantidade de registros e retira cabeçalho.
FT_FGOTOP()

While !FT_FEOF()
     
	//Leio a linha e gero array com os dados
	xBuff	:= alltrim(FT_FREADLN())
	aLin 	:= StrTokArr(xBuff,";")
	cCodAc  := Iif(Len(aLin)<2,"",aLin[2])
	
	IF Len( aLin ) > 0
		If aLin[1] != "Pedido" //Somente adiciona totalizadores para pedidos e desconsidera cabeçalho.
			
			nLin := Ascan( aGrupos, { |x| AllTrim(x[1])==cCodAc } )
			If nLin > 0
				aGrupos[nLin,2] += 1
			Else
				AADD(aGrupos, {cCodAc,1})
			Endif
			
		Endif
	EndIF

	//Pulo para a próxima linha.
	FT_FSKIP()
Enddo

conout("Finalizou!")

Return

Static Function VNDA610M(cAssunto,cParametro,cArquivo)

Default cAssunto 	:= ""
Default cParametro 	:= ""
Default cArquivo 	:= ""

cHTML := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
cHTML += '<html>'
cHTML += '	<head>'
cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
cHTML += '		<title>Log de processamento</title>'
cHTML += '	</head>'
cHTML += '	<body>'
cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
cHTML += '			<tbody>'
cHTML += '				<tr>'
cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle" colspan="4">'
cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Portal de Assinaturas</strong></font></span><br />'
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

cHTML += '<tr>'
cHTML += '<td colspan=4>Descrição Rede</td>'
cHTML += '<td colspan=1>Qtde.Pedidos</td>'
cHTML += '</tr>'

For i := 1 to Len(aGrupos)
	cHTML += '<tr>'
	cHTML += '<td colspan=4>'+aGrupos[i,1]+'</td>'
	cHTML += '<td colspan=1>'+Str(aGrupos[i,2])+'</td>'
	cHTML += '</tr>'
Next

cHTML += '				<tr><td bgcolor="#F4811D" colspan=5><b>Total de Pedidos: '+Str(nTotRec)+'</b></td></tr>'

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
			cParametro,; 
			cAssunto, ;
			cHTML,;
			cArquivo)
Return