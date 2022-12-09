#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FLUIG07     º Autor ³ RENATO RUY BERNARDOº Data ³  28/03/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ JOB PARA ENVIO DE RNC PENDENTE.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERTISIGN                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FLUIG07

Local cQuery  := ""
Local cHead	  := ""
Local cDest	  := ""
Local cHTML	  := ""
Local cFoot	  := ""
Local cAnexo  := ""
Local aInfo	  := {}
Local cDBOra  := ""
Local cSrvOra := ""
Local cDayRep := ""
Local cArea   := ""
Local nNum    := 0

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

//BUSCA PARAMETROS PARA ABRIR BASE DO FLUIG
cDBOra  := GetNewPar("MV_FLUIGB","ORACLE/FLUIG_PRD")
cSrvOra := GetNewPar("MV_FLUIGT", "10.0.14.172")
cDayRep := GetNewPar("MV_FLUIGD", "Segunda/Terca/Quarta/Quinta/Sexta")

//Faço Conexão com o banco do Fluig.
TCConType("TCPIP")
nHndOra := TcLink(cDbOra,cSrvOra,7890)

If !RTrim(DiaSemana(dDataBase))$cDayRep
	Conout("O relatorio nao foi selecionado pelo usuario para gerar neste dia!")
	Return
Endif

cQuery := " SELECT * FROM RNC "
cQuery += " WHERE "
cQuery += " LOG_ATIV = 1 "
cQuery += " ORDER BY AREA "

If Select("TMPRNC") > 0
	DbSelectArea("TMPRNC")
	TMPRNC->(DbCloseArea())
Endif

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"TMPRNC", .F., .T.)

cHead := FLUHEAD()
cFoot := FLUFOOT()

//Armazena a area atual para fazer o diff.
cArea := TMPRNC->AREA

While !TMPRNC->(EOF()) 

		//Busca Descricao da atividade atual
		If Select("TMPSEQ") > 0
			DbSelectArea("TMPSEQ")
			TMPSEQ->(DbCloseArea())
		Endif
		
		Beginsql Alias "TMPSEQ"
			SELECT TO_CHAR(NOM_ESTADO) ESTADO
			FROM HISTOR_PROCES HP
			JOIN ESTADO_PROCES EP 
			ON NUM_SEQ = NUM_SEQ_ESTADO AND NUM_VERS = (SELECT MAX(NUM_VERS) FROM ESTADO_PROCES WHERE COD_DEF_PROCES = EP.COD_DEF_PROCES)
			WHERE
			NUM_SEQ_MOVTO = (SELECT MAX(NUM_SEQ_MOVTO) FROM HISTOR_PROCES
							 WHERE
							 NUM_PROCES = %Exp:TMPRNC->PROCESSO%) AND
			COD_DEF_PROCES IN ('ecm_kgq_ro_2','ecm_kgq_ro') AND
			NUM_PROCES = %Exp:TMPRNC->PROCESSO%
		Endsql
		
        //Formata cor da linha
		If Mod( nNum, 2 ) == 0
			cHtml += "<TR bgcolor='#FFF8DC'>"
		else
			cHtml += "<TR bgcolor='#FFEBCD'>"
		Endif		
        cHtml += '				<td>'+TMPRNC->PROCESSO+'</td>'		
        cHtml += '				<td colspan="3">'+TMPRNC->TITULO+'</td>'		
        cHtml += '				<td>'+TMPSEQ->ESTADO+'</td>'		
		cHtml += '				</tr>'
		
		//Renato Ruy - 24/04/2017
		//Busca email do Gestor para envio
		cDest := StaticCall(FLUIG05,FLUIG05D,TMPRNC->IDGRUPO)
		
		nNum++
				
	TMPRNC->(DbSkip())
	
	If (cArea != TMPRNC->AREA .OR. TMPRNC->(EOF())) .And. !Empty(cDest)
		//Armazena a area atual para fazer o diff.
		cArea := TMPRNC->AREA
		
		nNum    := 0
		cHtml   := ""
		
		//Envio e-mail para os gestores do grupo
		FSSendMail( ;
		cDest+";jgarcia@certisign.com.br",; 
		"Lista de Não Conformidades Pendentes", ;
		cHead+cHTML+cFoot ,;
		cAnexo)
	Endif	
Enddo 

TcUnlink(nHndOra)
Return

Static function FLUHEAD()

Local cHead := ""

cHead := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
cHead += '<html>'
cHead += '	<head>'
cHead += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
cHead += '		<title>Conecta</title>'
cHead += '	</head>'
cHead += '	<body>'
cHead += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
cHead += '			<tbody>'
cHead += '				<tr>'
cHead += '					<td style="padding:5px; vertical-align:middle;" valign="middle" colspan="4">'
cHead += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Conecta</strong></font></span><br />'
cHead += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
cHead += '						<p>'
cHead += '							&nbsp;</p>'
cHead += '					</td>'
cHead += '					<td align="right" width="210">'
cHead += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
cHead += '						&nbsp;</td>'
cHead += '				</tr>'
cHead += '				<tr>'
cHead += '					<td bgcolor="#F4811D" colspan="5" height="4" width="0">'
cHead += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHead += '				</tr>'
cHead += '				<tr>'
cHead += '					<td colspan="5" style="padding:5px;" width="0">'
cHead += '						<p>'
cHead += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
cHead += '						<p>'
cHead += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Constatamos que a Não Conformidade abaixo, encontra-se pendente para continuidade do processo.</font></span></span></p>'
cHead += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Por gentileza, recomendamos que avalie e execute as ações necessárias para encerramento das etapas. </font></span></span></p>'
cHead += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Contamos com o seu apoio!</font></span></span></p>'
cHead += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">O time da Qualidade estará a sua disposição para mais esclarecimentos.</font></span></span></p>'
cHead += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Grato,</font></span></span></p>'
cHead += '							<tr><td><img alt="Certisign" height="46" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="119" /></td>
cHead += '							    <td><font color="white" size="15">|</td></td> <td colspan="2"> <span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:11px;"><font color="#FF6600"><b>'
cHead += '							         <br>José Roberto Giani Garcia </b></font><br> <font color="#000000">Gerente do Departamento da Qualidade <br> Certisign |</font> <font color="blue"><u>jgarcia@certisign.com.br</u></font><br><font color="#000000"> +55 11 99448.4949 | +55 11 4501.2201 </font></span></span></p>'
cHead += '					</td>'
cHead += '				</tr>'
cHead += '				<tr>'
cHead += '					<td bgcolor="#02519B" colspan="5" height="2" width="0">'
cHead += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHead += '				</tr>'
cHead += '				<tr bgcolor="#FF4500">'		
cHead += '				<td><b><font color="white">PROCESSO</td>'			
cHead += '				<td colspan="3"><b><font color="white"><center>TITULO</td>'			
cHead += '				<td><b><font color="white"><center>ATIVIDADE ATUAL</td>'			
cHead += '				</tr>' 

Return cHead

Static Function FLUFOOT()
Local cFoot	  := ""

cFoot := '				<tr>'
cFoot += '					<td colspan="5" style="padding:5px" width="0">'
cFoot += '						<p align="left">'
cFoot += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
cFoot += '					</td>'
cFoot += '				</tr>'
cFoot += '			</tbody>'
cFoot += '		</table>'
cFoot += '		<p>'
cFoot += '			&nbsp;</p>'
cFoot += '	</body>'
cFoot += '</html>'

Return cFoot