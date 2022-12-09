#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FLUIG05     º Autor ³ RENATO RUY BERNARDOº Data ³  17/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ JOB PARA ENVIO DE RNC PENDENTE.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERTISIGN                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FLUIG05

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
cQuery += " LOG_ATIV = 1 " // SOMENTE RNC NÃO FINALIZADA

If Select("TMPRNC") > 0
	DbSelectArea("TMPRNC")
	TMPRNC->(DbCloseArea())
Endif

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"TMPRNC", .F., .T.)

cHead := FLUHEAD()
cFoot := FLUFOOT()

While !TMPRNC->(EOF()) 
        cHtml := '				<tr><td bgcolor="#FFE4B5" colspan=5><center><b>DADOS RNC</b><center></td></tr>'		
		cHtml += '				<tr><td width="15%"><b>Numero RNC</b></td><td colspan=4>'+TMPRNC->PROCESSO+'</td></tr>'
		cHtml += '				<tr><td width="15%"><b>Solicitante</b></td><td colspan=4>'+TMPRNC->USUARIO+'</td></tr>'
		cHtml += '				<tr><td  bgcolor="#02519B" colspan="5" height="2" width="0"><img alt="" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" height="2" width="1"></td></tr>'
		
		cHtml += '				<tr><td bgcolor="#FFE4B5" colspan=5><center><b>DETALHES</b><center></td></tr>'	
		cHtml += '				<tr><td width="15%"><b>Ação</b></td><td colspan=4>'+TMPRNC->ACAO+'</td></tr>'
		cHtml += '				<tr><td width="15%"><b>Ocorrência</b></td><td colspan=4>'+TMPRNC->OCORRE + " - " + TMPRNC->DTOCORRE+'</td></tr>'
		cHtml += '				<tr><td width="15%"><b>Data Abertura</b></td><td colspan=4>'+TMPRNC->DTREGISTRO+'</td></tr>'
		cHtml += '				<tr><td width="15%"><b>Area</b></td><td colspan=4>'+TMPRNC->AREA+'</td></tr>'
		cHtml += '				<tr><td width="15%"><b>Origem</b></td><td colspan=4>'+TMPRNC->ORIGEM+'</td></tr>'
		cHtml += '				<tr><td width="15%"><b>Criticidade</b></td><td colspan=4>'+TMPRNC->CRITICO+'</td></tr>'
		cHtml += '				<tr><td width="15%"><b>Reincidente</b></td><td colspan=4>'+TMPRNC->REINCID+Iif(!Empty(TMPRNC->CODREINC)," - " + TMPRNC->CODREINC," ") + '</td></tr>'
		cHtml += '				<tr><td bgcolor="#02519B" colspan="5" height="2" width="0"><img alt="" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" height="2" width="1"></td></tr>'
		
		cHtml += '				<tr><td bgcolor="#FFE4B5" colspan=5><center><b>SOLICITAÇÃO</b><center></td></tr>'
		cHtml += '				<tr><td width="15%"><b>Descrição</b></td><td colspan=4>'+StrTran(AllTrim(TMPRNC->DSOCORRE),chr(13)+chr(10),"<br>")+'</td></tr>'
		cHtml += '				<tr><td bgcolor="#02519B" colspan="5" height="2" width="0"><img alt="" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" height="2" width="1"></td></tr>'
		
		If !Empty(TMPRNC->DESCCONT)
			cHtml += '				<tr><td bgcolor="#FFE4B5" colspan=5><center><b>DADOS CONTENÇÃO</b><center></td></tr>'		
			cHtml += '				<tr><td width="15%"><b>Contenção</b></td><td colspan=4>'+TMPRNC->CONTENCAO+'</td></tr>'
			cHtml += '				<tr><td width="15%"><b>Descrição</b></td><td colspan=4>'+StrTran(AllTrim(TMPRNC->DESCCONT),chr(13)+chr(10),"<br>")+'</td></tr>'
			cHtml += '				<tr><td bgcolor="#02519B" colspan="5" height="2" width="0"><img alt="" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" height="2" width="1"></td></tr>'
		Endif
		
		If !Empty(TMPRNC->ANALISE)
			cHtml += '				<tr><td bgcolor="#FFE4B5" colspan=5><center><b>ANÁLISE DE CAUSA</b><center></td></tr>'
			cHtml += '				<tr><td width="15%"><b>Análise de Causa</b></td><td colspan=4>'+StrTran(AllTrim(TMPRNC->ANALISE),chr(13)+chr(10),"<br>")+'</td></tr>'
			cHtml += '				<tr><td bgcolor="#02519B" colspan="5" height="2" width="0"><img alt="" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" height="2" width="1"></td></tr>'
		Endif
		
		If !Empty(TMPRNC->DESCEFIC)
			cHtml += '				<tr><td bgcolor="#FFE4B5" colspan=5><center><b>DESCRIÇÃO EFICÁCIA</b><center></td></tr>'
			cHtml += '				<tr><td width="15%"><b>Eficácia</b></td><td colspan=4>'+StrTran(AllTrim(TMPRNC->DESCEFIC),chr(13)+chr(10),"<br>")+'</td></tr>' 
			cHtml += '				<tr><td bgcolor="#02519B" colspan="5" height="2" width="0"><img alt="" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" height="2" width="1"></td></tr>'
		Endif
		
		//Renato Ruy - 24/04/2017
		//Busca os dados do plano de ação.
		cAnexo := FLUIG05E(AllTrim(TMPRNC->IDPROCESSO), AllTrim(TMPRNC->PROCESSO))
		
		//Renato Ruy - 24/04/2017
		//Busca email do Gestor para envio
		cDest := FLUIG05D(AllTrim(TMPRNC->IDGRUPO))
		
		If !Empty(cDest)
			//Envio e-mail para os gestores do grupo
			FSSendMail( ;
			cDest+";jgarcia@certisign.com.br",; 
			"Não Conformidade Nº: "+AllTrim(TMPRNC->PROCESSO)+" - Pendente", ;
			cHead+cHTML+cFoot ,;
			cAnexo)
		Endif
		
	TMPRNC->(DbSkip())
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

//Renato Ruy - 24/04/2017
//Busca email dos Gestores para envio
Static Function FLUIG05D(cGrupo)

Local cDest := ""

Default cGrupo := " "

If select("TMPGRP") > 0 
	DbSelectArea("TMPGRP")
	TMPGRP->(DbCloseArea())
Endif

Beginsql Alias "TMPGRP"
  SELECT USR.LOGIN, USR.EMAIL FROM FDN_GROUPUSERROLE GRP
  JOIN FDN_USERTENANT USR ON USR.LOGIN = GRP.LOGIN
  WHERE
  GROUP_CODE IN ( SELECT TO_CHAR(COD_VALOR) FROM FICHA FIC
				  WHERE
				  NR_FICHARIO = '2488' AND
				  NR_FICHA= (	SELECT MAX(NR_FICHA) 
				  				FROM FICHA 
				  				WHERE 
				  				NR_FICHARIO = '2488' AND 
				  				TO_CHAR(COD_VALOR) = %Exp:cGrupo%) AND
				  COD_CAMPO = 'groupGestoresIdResp')
Endsql

While !TMPGRP->(EOF())
	cDest += If(!Empty(cDest),";","")+RTrim(TMPGRP->EMAIL)
	TMPGRP->(DbSkip())
Enddo

Return cDest

//Renato Ruy - 24/04/2017
//Funcao para o usuario marcar os dias em que o relatorio sera gerado
//Armazena no parametro MV_FLUIGD
User Function FLUIG05R()

Local cDias := ""
Local aPergs:= {}
Local aRet  := {}

aAdd( aPergs ,{4,"Dias Para envio",.F., "Domingo"	, 80,'.T.',.F.})
aAdd( aPergs ,{4,"               ",.F., "Segunda"	, 80,'.T.',.F.})
aAdd( aPergs ,{4,"               ",.F., "Terca"		, 80,'.T.',.F.})
aAdd( aPergs ,{4,"               ",.F., "Quarta"	, 80,'.T.',.F.})
aAdd( aPergs ,{4,"               ",.F., "Quinta"	, 80,'.T.',.F.})
aAdd( aPergs ,{4,"               ",.F., "Sexta"		, 80,'.T.',.F.})
aAdd( aPergs ,{4,"               ",.F., "Sabado"	, 80,'.T.',.F.})
If ParamBox(aPergs ,"Dias para geração do relatório de RNC",aRet)
	cDias := Iif(!Empty(cDias) .And. aRet[1],"/","")+Iif(aRet[1],"Domingo","")  
	cDias += Iif(!Empty(cDias) .And. aRet[2],"/","")+Iif(aRet[2],"Segunda","")
	cDias += Iif(!Empty(cDias) .And. aRet[3],"/","")+Iif(aRet[3],"Terca","")
	cDias += Iif(!Empty(cDias) .And. aRet[4],"/","")+Iif(aRet[4],"Quarta","")
	cDias += Iif(!Empty(cDias) .And. aRet[5],"/","")+Iif(aRet[5],"Quinta","")
	cDias += Iif(!Empty(cDias) .And. aRet[6],"/","")+Iif(aRet[6],"Sexta","")
	cDias += Iif(!Empty(cDias) .And. aRet[7],"/","")+Iif(aRet[7],"Sabado","")
	
	If PutMv("MV_FLUIGD",cDias)
		MsgInfo("Os parâmetros foram atualizados com sucesso!")
	Else
		Alert("Não foi possível atualizar o parâmetro, por favor tente mais tarde!")
	Endif

Else
	Alert("Rotina cancelada pelo usuário!")
Endif
	
Return

//Renato Ruy - 24/04/2017
//Busca dados do Plano de Acao e gera em arquivo para envio
Static Function FLUIG05E(cProcId, cRnc)

Local cEOL 	:= CHR(13)+CHR(10)
Local cLine := ""
Local cHead := ""
Local cStat := ""
Local cNota := ""
Local cMeth := ""
Local cArq  := "\CONECTA\Plano de Acao - RNC "+RTrim(cRnc)+".xls"
Local nArq  := 0
Local nNum  := 0

Default cProcId := " "

//Cria o diretorio caso nao exista
If !ExistDir("\CONECTA")
	Makedir("\CONECTA")
Endif

nArq    := fCreate(cArq)

If nArq == -1
	ConOut("O arquivo não pode ser criado!")
	Return " "
Endif

If Select("TMPPLA") > 0
	DbSelectArea("TMPPLA")
	TMPPLA->(DbCloseArea())
Endif

//Cria cabecalho do arquivo anexo
cHead := "<HTML>"
cHead += "<BODY>"
cHead += "<TABLE BORDER='0'>"
cHead += "<TR bgcolor='#008B8B'>"
cHead += "<TD><center><b><font color='white'>Código</TD>"
cHead += "<TD><center><b><font color='white'>Status</TD>"
cHead += "<TD><center><b><font color='white'>Previsão Início</TD>"
cHead += "<TD><center><b><font color='white'>Previsão Finalização</TD>"
cHead += "<TD><center><b><font color='white'>Data Real Finalização</TD>"
cHead += "<TD><center><b><font color='white'>Responsável</TD>"
cHead += "<TD><center><b><font color='white'>Solicitação</TD>"
cHead += "<TD><center><b><font color='white'>Metódo Verificação</TD>"
cHead += "<TD><center><b><font color='white'>Nota de Acompanhamento</TD>"
cHead += "</TR>"
cHead += cEOL

Beginsql Alias "TMPPLA"
	%NoParser%
	SELECT	TO_CHAR(CODIGO) CODIGO,
			TO_CHAR(STATUS) STATUS,
			TO_CHAR(DTINICIAL) DTINICIAL,
			TO_CHAR(DTFINAL) DTFINAL,
			TO_CHAR(DTREALIZADO) DTREALIZADO,
			TO_CHAR(RESPONSAVEL) RESPONSAVEL,
			TO_CHAR(TIPOACAO) TIPOACAO,
			TO_CHAR(DESCRICAO) DESCRICAO,
			TO_CHAR(ANALISE) ANALISE,
			TO_CHAR(NOTA) NOTA
	FROM 
		(SELECT	TO_CHAR(NR_FICHA) NRFICHA,
				MAX(CASE WHEN COD_CAMPO IN ('_cdAtividadePA','cdAtividadePA') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) CODIGO,
				MAX(CASE WHEN COD_CAMPO IN ('_nmStatus','nmStatus','state') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) STATUS,
				MAX(CASE WHEN COD_CAMPO IN ('_nmDtInicial','nmDtInicial') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) DTINICIAL,
				MAX(CASE WHEN COD_CAMPO IN ('_nmPrazoConclusao','nmPrazoConclusao') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) DTFINAL,
				MAX(CASE WHEN COD_CAMPO IN ('_nmDtFinalReal','nmDtFinalReal') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) DTREALIZADO,
				MAX(CASE WHEN COD_CAMPO IN ('_nmResponsavelPA','nmResponsavelPA') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) RESPONSAVEL,
				MAX(CASE WHEN COD_CAMPO IN ('_nmTipoAcaoPA','nmTipoAcaoPA') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) TIPOACAO,
				MAX(CASE WHEN COD_CAMPO IN ('_nmOqueComo','nmOqueComo') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) DESCRICAO,
				MAX(CASE WHEN COD_CAMPO IN ('_metodoVerificacao','metodoVerificacao') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) ANALISE,
				MAX(CASE WHEN COD_CAMPO IN ('_notaAcompanhamento','notaAcompanhamento') THEN TO_CHAR(COD_VALOR) ELSE ' ' END) NOTA
		FROM FICHA
		WHERE
		NR_FICHA IN (SELECT NR_FICHA FROM FICHA
					WHERE
					NR_FICHARIO = 2487 AND
					COD_CAMPO IN ('_cdOccurrence','_cdOcorrencia','cdOcorrenciaFluig') AND
					TO_CHAR(COD_VALOR) = %Exp:cRnc%)
		GROUP BY NR_FICHA) ABC
	UNION ALL
	SELECT  TO_CHAR(cdAtividadePA) CODIGO,
			TO_CHAR(nmStatus) STATUS,
			TO_CHAR(nmDtInicial) DTINICIAL,
			TO_CHAR(nmPrazoConclusao) DTFINAL,
			TO_CHAR(nmDtFinalReal) DTREALIZADO,
			TO_CHAR(nmResponsavelAtiv) RESPONSAVEL,
			TO_CHAR(nmTipoAcaoPA) TIPOACAO,
			TO_CHAR(nmOqueComo) DESCRICAO,
			TO_CHAR(metodoVerificacao) ANALISE,
			TO_CHAR(notaAcompanhamento) NOTA
	FROM ML001040
	WHERE
	documentid = %Exp:cProcId% and
	version = nvl((select max(version) from ML001040 where documentid = %Exp:cProcId%),1000) and
	TO_CHAR(cdAtividadePA) > ' '
Endsql

While !TMPPLA->(EOF())
    
    //Monta o status do plano de ação 
	If Empty(TMPPLA->DTREALIZADO) .And. CtoD(TMPPLA->DTFINAL) >= dDatabase
		cStat := "Em Aberto - Dentro do Prazo"
	Elseif Empty(TMPPLA->DTREALIZADO) .And. CtoD(TMPPLA->DTFINAL) < dDatabase
		cStat := "Em Aberto - Fora do Prazo"
	Elseif CtoD(TMPPLA->DTFINAL) >= CtoD(TMPPLA->DTREALIZADO)
		cStat := "Encerrado - Dentro do Prazo"
	Elseif CtoD(TMPPLA->DTFINAL) < CtoD(TMPPLA->DTREALIZADO)
		cStat := "Encerrado - Fora do Prazo"
	Endif
	
	//Em alguns casos a informacao nao esta vindo na tabela nova, somente nas fichas
	//por isso foi necessario buscar a informacao.
	If select("TMPITP") > 0
		DbSelectArea("TMPITP")
		TMPITP->(DbCloseArea())
	Endif
	
	Beginsql Alias "TMPITP"
		%NoParser%

		select TO_CHAR(METODO) METODO,
				TO_CHAR(NOTA) NOTA
		from (
		select	MAX(CASE WHEN COD_CAMPO = 'metodoVerificacao' THEN TO_CHAR(COD_VALOR) ELSE ' ' END) METODO,
				MAX(CASE WHEN COD_CAMPO = 'dsAtividade' THEN TO_CHAR(COD_VALOR) ELSE ' ' END) NOTA			
		from ficha
		where
		NR_FICHA = (SELECT MAX(NR_FICHA) FROM FICHA WHERE NR_FICHARIO = 2487 AND upper(TO_CHAR(COD_VALOR)) = %Exp:TMPPLA->CODIGO%) AND
		COD_CAMPO IN ('dsAtividade','metodoVerificacao')) abc
	Endsql
	
	cMeth := Iif(Empty(TMPPLA->ANALISE),TMPITP->METODO,TMPPLA->ANALISE) 
	cNota := Iif(Empty(TMPPLA->NOTA),TMPITP->NOTA,TMPPLA->NOTA)
	
	//Formata cor da linha
	If Mod( nNum, 2 ) == 0
		cLine += "<TR bgcolor='#F0FFFF'>"
	else
		cLine += "<TR bgcolor='#B0E0E6'>"
	Endif
	cLine += "<TD>" + TMPPLA->CODIGO 		+ "</TD>"
	cLine += "<TD>" + cStat			 		+ "</TD>"
	cLine += "<TD>" + TMPPLA->DTINICIAL 	+ "</TD>"
	cLine += "<TD>" + TMPPLA->DTFINAL 		+ "</TD>"
	cLine += "<TD>" + TMPPLA->DTREALIZADO	+ "</TD>"
	cLine += "<TD>" + TMPPLA->RESPONSAVEL	+ "</TD>"
	cLine += "<TD>" + Strtran(RTrim(TMPPLA->DESCRICAO),";","/")	+ "</TD>"	
	cLine += "<TD>" + Strtran(RTrim(cMeth),";","/")				+ "</TD>"
	cLine += "<TD>" + Strtran(RTrim(cNota),";","/")				+ "</TD>"
	cLine += "</TR>"		
	cLine += cEOL
	
	nNum++
	
	TMPPLA->(DbSkip())
Enddo

cLine += "</TABLE>
cLine += "</BODY>
cLine += "</HTML>


//Efetuo gravação de dados do relatório em arquivo.
fWrite(nArq,cHead+cLine)

//Fecho o arquivo anterior
fClose(nArq)

Return cArq