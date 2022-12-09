#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FILEIO.CH'
#INCLUDE 'TbiConn.ch'

#DEFINE cPARAM_CAMINHO 'PARAM_CAMINHO'
#DEFINE cPARAM_MODO_DEBUG 'PARAM_MODO_DEBUG'

#DEFINE cMSG1 'Prezado(a) '
#DEFINE cMSG2 ', '
#DEFINE cMSG3 'existem [xx] apontamentos aguardando manutenção.'
#DEFINE cMSG4 'Solicitamos que acesse Portal do Ponto e efetue a(s) manutenção(ões).'
#DEFINE cMSG6 'Ao finalizar a manutenção dos apontamentos, pressione o botão enviar apontamento.'
#DEFINE cTITULO_EMAIL 	'Apontamentos Pendente(s).'
#DEFINE aTITULO_TABELA 	{'Colaborador(es)','Pendência(s)'} //Corpo do email - tabela
#DEFINE aTYPE_COL 		{'T', 'N'}
#DEFINE aALIGN_COL 		{'left', 'center'}

#DEFINE cMSG1_GES 'Prezado(a) '
#DEFINE cMSG2_GES ', '
#DEFINE cMSG3_GES 'existem [xx] colaborador(es) aguardando aprovação.'
#DEFINE cMSG4_GES 'Solicitamos que acesse Portal do Ponto e efetue a(s) aprovação(ões).'
#DEFINE cMSG6_GES 'Ao finalizar a aprovações dos apontamentos, pressione o botão efetuar aprovações.'
#DEFINE cTITULO_EMAIL_GES 	'Aprovações Pendente(s).'
#DEFINE aTITULO_TABELA_GES 	{'Colaborador(es)','Pendência(s)'} //Corpo do email - tabela
#DEFINE aTYPE_COL_GES 		{'T', 'N'}
#DEFINE aALIGN_COL_GES 		{'left', 'center'}

#DEFINE cMSG1_DLC 'Prezado(a) '
#DEFINE cMSG2_DLC ', '
#DEFINE cMSG3_DLC 'existem [xx] apontamentos aguardando aprovação pois não foi aprovado em tempo pelo seus aprovadores.'
#DEFINE cMSG4_DLC 'Solicitamos que acesse Portal do Ponto e efetue a(s) manutenção(ões) em medida de urgência.'
#DEFINE cMSG6_DLC 'Ao finalizar a aprovações dos apontamentos, pressione o botão efetuar aprovações.'
#DEFINE cTITULO_EMAIL_DLC	'Aprovações Pendente(s).'
#DEFINE aTITULO_TABELA_DLC 	{'Colaborador(es)','Pendência(s)'} //Corpo do email - tabela
#DEFINE aTYPE_COL_DLC 		{'T', 'N'}
#DEFINE aALIGN_COL_DLC 		{'left', 'center'}

/*/{Protheus.doc} CSRH060
Envia lista de aprovação de justificativas para os aprovadores que estão com aprovações pendentes.
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aParam, array, Posição 1 - Código da empresa Posição 2 - Código da Filial

@return nulo
/*/
User Function CSRH060(aParam)
	Local cEmailCorp   := 'sistemascorporativos@certisign.com.br' // email usado para teste
	Local cLinkPortal  := ''
	Local cMV_MAIL_ENV := 'MV_CSRH010' //nome do parametro com o email a ser usado com teste, em ambiente de produção deixar vazio.
	Local cQuery 	 	:= '' 	//Consulta SQL
	Local lExeChange 	:= .T. 	//Executa o change Query
	local lTotaliza 	:= .F.
	Local nRec 		    := 0   	//Numero Total de Registros da consulta SQL
	Local cAliasRCC 	:= getNextAlias()
	Local cPeriodo      := ''
	Local dDataIni	    := ctod('  /  /  ')
	Local dDataFim      := ctod('  /  /  ')
	Local dWFF          := ctod('  /  /  ')
	Local dWFG          := ctod('  /  /  ')
	Local dDLC          := ctod('  /  /  ')
	Local nTempo     := 0
	local nTempoFim  := 0

	private lModoDebug := .F.

	Default aParam 	 	:= {'01', '07'}

	//configura parametros se estiver vazio
	if Len(aParam) == 0
		aAdd(aParam, '01')
		aAdd(aParam, '07')
	endif

	//configurar ambiente
	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO 'PON'

	//Configura caminho do portal GCH
	if empty(GetGlbValue(cPARAM_CAMINHO)) .or. empty(GetGlbValue(cPARAM_MODO_DEBUG))
		u_ParamPtE()
	endif
	cLinkPortal := GetGlbValue(cPARAM_CAMINHO)
	if GetGlbValue(cPARAM_MODO_DEBUG) == "1"
		lModoDebug := .T.
	endif

	if lModoDebug
		nTempo := seconds()
		conout("	CSRH060 iniciado em: "+dtoc(msDate())+" as "+time())
	endif

	//Trata PB7 para nao enviar email para funcionario com rescisao ja calculada.
	updDesliga()

	//Cria parametro e preenche a variavel com o conteudo dele
	If !GetMv( cMV_MAIL_ENV, .T. )
		CriarSX6( cMV_MAIL_ENV, 'C', 'EMAIL QUE SERA USADA PARA ENVIO DE EMAIL TESTE. EM PRODUCAO DEIXAR VAZIO CSRH010.prw', cEmailCorp )
	Endif
	cMV_MAIL_ENV := GetMv( cMV_MAIL_ENV, .F. )

	//Monta SQL
	cQuery := " SELECT "
	cQuery += " SUBSTRING(RCC.RCC_CONTEU,  1, 16) CODIGO,   "
	cQuery += " SUBSTRING(RCC.RCC_CONTEU,  1,  8) DATA_INI, "
	cQuery += " SUBSTRING(RCC.RCC_CONTEU, 09,  8) DATA_FIM, "
	cQuery += " SUBSTRING(RCC.RCC_CONTEU, 17,  1) LIBERA,   "
	cQuery += " SUBSTRING(RCC.RCC_CONTEU, 18,  8) WFF,      "
	cQuery += " SUBSTRING(RCC.RCC_CONTEU, 26,  8) WFG,      "
	cQuery += " SUBSTRING(RCC.RCC_CONTEU, 34,  8) DLC       "
	cQuery += " FROM  "+RetSqlName('RCC')+" RCC             "
	cQuery += " WHERE RCC.D_E_L_E_T_ = ' '                  "
	cQuery += "   AND RCC.RCC_CODIGO = 'U007'               "
	cQuery += "   AND SUBSTRING(TRIM(RCC.RCC_CONTEU), 17, 1) = '1'   "
	cQuery += " ORDER BY 2, 3 "

	//Executa consulta SQL
	if U_MontarSQL(cAliasRCC, @nRec, cQuery, lExeChange, lTotaliza)
		(cAliasRCC)->(dbGoTop())
		while (cAliasRCC)->(!EoF())
			cPeriodo      := (cAliasRCC)->CODIGO
			dDataIni      := stod( (cAliasRCC)->DATA_INI )
			dDataFim      := stod( (cAliasRCC)->DATA_FIM )
			dWFF          := stod( (cAliasRCC)->WFF )
			dWFG          := stod( (cAliasRCC)->WFG )
			dDLC          := stod( (cAliasRCC)->DLC )

			//Envia email para funcionário que esta pendente de apontamento
			if msDate() >= dWFF .And. !Empty(dWFF) .And. !Empty(cLinkPortal)
				envPendFun(cPeriodo, cMV_MAIL_ENV, cLinkPortal)
			endif

			//Envia email para aprovador que esta pendente de aprovacao
			if msDate() >= dWFG .And. !Empty(dWFG)  .And. !Empty(cLinkPortal)
				envPendGes(cPeriodo, cMV_MAIL_ENV, cLinkPortal)
			endif

			//1 - Envia email para gestor que esta pendente de aprovacao e venceu o seu prazo de aprovacao
			//2 - Muda automaticamente a ordem de aprovacao para a ultimo aprovador no caso o gerente
			if msDate() >= dDLC .And. !Empty(dDLC) .And. !Empty(cLinkPortal)
				envPendDlc(cPeriodo, cMV_MAIL_ENV, cLinkPortal)
			endif

			(cAliasRCC)->(dbSkip())
		end
		(cAliasRCC)->(dbCloseArea())
	endif

	if lModoDebug
		nTempoFim := seconds()
		conout("	Tempo de execucao: " +  cValToChar(nTempoFim - nTempo )+" segundos")
		conout("	CSRH060 encerrado em: "+dtoc(msDate())+" as "+time())
	endif

	RESET ENVIRONMENT
Return()

/*/{Protheus.doc} EnvEmail
Envia email conforme parametros
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aHeader, array, [1] - codigo do usario aprovador; [2] - email do usuario aprovador -- UsrRetMail(); [3] - nome do usuario aprovador; [4] - Mensagem titulo
@param aBody, array, Lista de pedido de compras
@param aTypeCol, array, Tipo de coluna (T - Texto, N - Númerico, A - Link)
@param cTituloEmail, string, Título de email
@param aTabTitulo, array, Mensagem que sera montada no email

@return nulo
/*/
Static Function EnvEmail(aHeader, aBody, aTypeCol, cTituloEmail, aTabTitulo, cPeriodo)
	Local nLinha      := 1  //Linha do array
	Local nColuna     := 1  //Posicao da coluna no array
	Local aLinha      := {} //Array temporario
	Local chtml 	  := '' //Strinf com html
	Local cEmailAprov := '' //Email do aprovador
	Local cNomeAprov  := '' //Nome do aprovador
	Local cMsgHTML 	  := '' //Mensagem do email
	Local cClassLin   := '' //Nome da classe que controla linha no html
	Local cLinlk      := ''
	local cDtIni      := ''
	local cDtFim      := ''

	Default cTituloEmail := 'Email enviado pelo Protheus'
	Default aTabTitulo := Array(Len(aBody))
	Default cPeriodo := ''

	if len(cPeriodo) == 16
		cDtIni := dtoc(stod(left( cPeriodo, 8)))
		cDtFim := dtoc(stod(right(cPeriodo, 8)))
	endif

	cNomeAprov 	:= aHeader[1] //codigo do usario aprovador
	cEmailAprov := aHeader[2] //email do usuario aprovador
	cMsgHTML 	:= replace(aHeader[3], '[xx]', aHeader[4]) //Mensagem titulo
	cLinlk 		:= aHeader[5]

	//Inicia construcao do html
	chtml += '<!DOCTYPE HTML>'
	chtml += '<html>'
	chtml += '	<head>'
	chtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> '
	chtml += '	</head>'
	chtml += '	<body style="font-family: Fontin Roman, Lucida Sans Unicode">'
	chtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	chtml += '		<tr>'
	chtml += '			<td valign="top" align="center">'
	chtml += '				<table width="627">'
	chtml += '					<tr>'
	chtml += '						<td valign="middle" align="left" style="border-bottom:2px solid #FE5000;">'
	chtml += '							<h2>'
	chtml += '								<span style="color:#FE5000" ><strong>'+cTituloEmail+'</strong></span>'
	chtml += '								<br />'
	chtml += '								<span style="color:#003087" >Recursos Humanos</span>'
	chtml += '							</h2>'
	chtml += '						</td>'
	chtml += '						<td valign="top" align="left" style="border-bottom:2px solid #FE5000;">'
	chtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	chtml += '						</td>'
	chtml += '					</tr>'
	chtml += '				</table>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>'+cMsgHTML+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>Período de '+cDtIni+' a '+cDtFim+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	if len(aBody) > 0
		chtml += '		<tr>'
		chtml += '			<td valign="top"  align="center" >'
		chtml += '				<table border="0" cellpadding="0" cellspacing="0" style="width:90%;">'
		chtml += '					<thead  >'
		chtml += '						<tr>'
		for nLinha := 1 to len(aTabTitulo)
			chtml += '						<th align="'+aALIGN_COL[nLinha]+'" style="border-bottom:2px solid #003087; " >'+alltrim(aTabTitulo[nLinha])+'</th>' //Monta cabecalho da tabela
		next nLinha
		chtml += '						</tr>'
		chtml += '					</thead>'

		for nLinha := 1 to len(aBody)
			aLinha := aBody[nLinha]

			iif (cClassLin == 'bgcolor=#FFFFFF', cClassLin := 'bgcolor=#DCDCDC', cClassLin := 'bgcolor=#FFFFFF')
			chtml += '				<tbody>'
			chtml += '					<tr>'
			for nColuna := 1 to len(aLinha)
				if aTypeCol[nColuna] == 'T'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span>'+alltrim(left(Capital(aLinha[nColuna]),75))+'</span></div></td>' //insere coluna
				elseif aTypeCol[nColuna] == 'N'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span>'+cValToChar(aLinha[nColuna])+'</span></div></td>' //insere coluna
				elseif aTypeCol[nColuna] == 'A'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span><a href="'+alltrim(aLinha[nColuna])+'">Aprovar / Reprovar</a></span></div></td>'  //insere coluna
				endif
			next nColuna
			chtml += '					</tr>'
		next nLinha
		chtml += '					</tbody>'
		chtml += '				</table>'
		chtml += '			</td>'
		chtml += '		</tr>'
	endif
	chtml += '			<tr>'
	chtml += '				<td valign="top" style="padding:15px;" align="center">'
	chtml += '					<p>Para acessa-los <a href="'+cLinlk+'">clique aqui</a><br /></p>'
	chtml += '				</td>'
	chtml += '			</tr>'
	chtml += '			<tr>'
	chtml += '				<td valign="top" style="padding:15px;">'
	chtml += '					<p>'+cMSG6+'<br /></p>'
	chtml += '				</td>'
	chtml += '			</tr>'
	chtml += '			<tr>'
	chtml += '				<td valign="top" style="border-bottom:2px solid #003087; " >'
	chtml += '				</td>'
	chtml += '			</tr>'
	chtml += '			<tr>'
	chtml += '				<td valign="top" colspan="2" style="padding:5px" width="0">'
	chtml += '					<p align="left">'
	chtml += '						<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	chtml += '					</p>'
	chtml += '				</td>'
	chtml += '			</tr>'
	chtml += '		</table>'
	chtml += '	</body>'
	chtml += '</html>'

	//Rotina de envio de email
	FsSendMail(cEmailAprov, cTituloEmail, chtml)

	if lModoDebug
		conout("	|")
		conout("	+---> Enviado para: "+cEmailAprov + " Titulo: "+cTituloEmail+" Periodo de: "+cDtIni+" a "+cDtFim)
		conout("	|")
		conout("	+---> Processado em: "+dtoc(msDate()) + " Por: " + RetCodUsr() + " - "+ usrFullName(RetCodUsr()) )
		conout("")
	endif

Return()

static function envPendFun(cPeriodo, cMV_MAIL_ENV, cLinkPortal)
	Local aBody		   := {}  	//Dados que irao compor a tabela do html
	Local aHeader	   := {}  	//Dados que irao compor o envio do email
	Local aLogArq 	   := {}   //Array com log do que foi feito pela rotina
	Local calias 	   := GetNextalias() //alias resevardo para consulta SQL
	Local cQuery 	 	:= '' 	//Consulta SQL
	Local lExeChange 	:= .T. 	//Executa o change Query
	local lTotaliza 	:= .F.
	Local nRec 		    := 0   	//Numero Total de Registros da consulta SQL

	default cPeriodo := ''
	default cMV_MAIL_ENV := ''
	default cLinkPortal := ''

	cQuery := "SELECT RA_FILIAL AS FILIAL                 "
	cQuery += "      ,RA_MAT    AS MAT                    "
	cQuery += "      ,RA_NOME   AS NOME                   "
	cQuery += "      ,RA_EMAIL  AS EMAIL                  "
	cQuery += "      ,XXX.MRC   AS TOTAL                  "
	cQuery += "FROM "+RetSqlName("SRA")+" SRA             "
	cQuery += "INNER JOIN (                               "
	cQuery += "            SELECT PB7X.PB7_FILIAL  AS FIL "
	cQuery += "                  ,PB7X.PB7_MAT     AS MAT "
	cQuery += "                  ,COUNT(*)         AS MRC "
	cQuery += "            FROM (SELECT PB7_FILIAL        "
	cQuery += "                        ,PB7_MAT           "
	cQuery += "                        ,PB7_DATA          "
	cQuery += "                        ,PB7_HRPOSV        "
	cQuery += "                        ,PB7_HRNEGV        "
	cQuery += "                        ,PB7_STATUS        "
	cQuery += "                        ,PB7_STAATR        "
	cQuery += "                        ,PB7_STAHE         "
	cQuery += "                        ,PB7_VERSAO        "
	cQuery += "                  FROM "+RetSqlName("PB7")+" PB7                    "
	cQuery += "                  INNER JOIN (SELECT DISTINCT PB7_FILIAL AS FILIAL  "
	cQuery += "                                             ,PB7_MAT    AS MAT     "
	cQuery += "                                             ,PB7_DATA   AS DATA    "
	cQuery += "                                             ,MAX(PB7_VERSAO) OVER (PARTITION BY PB7_FILIAL, PB7_MAT, PB7_DATA) AS MAX_VERS "
	cQuery += "                              FROM "+RetSqlName("PB7")+"                          "
	cQuery += "                              WHERE D_E_L_E_T_ <> '*'                             "
	cQuery += "                              AND PB7_PAPONT = '"+cPeriodo+"'"
	cQuery += "                              AND PB7_DATA <= '"+dTos(msDate()-1)+"'"
	cQuery += "                              GROUP BY PB7_FILIAL, PB7_MAT, PB7_DATA, PB7_VERSAO  "
	cQuery += "                              ORDER BY PB7_FILIAL, PB7_MAT, PB7_DATA, MAX_VERS    "
	cQuery += "                             ) PBX ON PB7_FILIAL = PBX.FILIAL AND PB7_MAT = PBX.MAT AND PB7_DATA = PBX.DATA AND PB7_VERSAO = PBX.MAX_VERS "
	cQuery += "                  WHERE PB7.D_E_L_E_T_ <> '*'                                         "
	cQuery += "                    AND PB7.PB7_PAPONT  = '"+cPeriodo+"'                              "
	cQuery += "                    AND (PB7.PB7_STATUS = '1' OR PB7_STAHE = '1' OR PB7_STAATR = '1') "
	cQuery += "                    AND (PB7_HRPOSV <> 0  OR PB7_HRNEGV <> 0)                         "
	cQuery += "                  ORDER BY PB7_FILIAL, PB7_MAT, PB7_DATA                              "
	cQuery += "                 ) PB7X                                               "
	cQuery += "            GROUP BY PB7X.PB7_FILIAL, PB7X.PB7_MAT                    "
	cQuery += "            ORDER BY PB7X.PB7_FILIAL, PB7X.PB7_MAT                    "
	cQuery += "           ) XXX ON SRA.RA_FILIAL = XXX.FIL AND SRA.RA_MAT = XXX.MAT  "
	cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' "

	//Executa consulta SQL
	if U_MontarSQL(calias, @nRec, cQuery, lExeChange, lTotaliza)
		//Guarda dados em array para gerar os html
		(calias)->(dbGoTop())
		while (calias)->(!EoF())
			aHeader   := {}
			aBody     := {}

			aAdd( aHeader, capital( alltrim( (calias)->NOME ) ) )                            //Nome no Fluig
			aAdd( aHeader, iif(empty(cMV_MAIL_ENV), alltrim((calias)->EMAIL), cMV_MAIL_ENV)) //email no fluig
			aAdd( aHeader, cMSG1+aHeader[1]+cMSG2+cMSG3+cMSG4)                               //Mensagem titulo
			aAdd( aHeader, cValToChar((calias)->TOTAL) )                                     //Número de documentos por funcionário.
			aAdd( aHeader, cLinkPortal )                                                    //Link Email

			EnvEmail( aHeader, aBody, aTYPE_COL, cTITULO_EMAIL, aTITULO_TABELA, cPeriodo )   //Envia email para os aprovadores
			aAdd( aLogArq, {aHeader, aBody} )
			(calias)->(dbSkip())
		end
		//aAdd(aLogArq, {aHeader, aBody})
		(calias)->(dbCloseArea())

		//GeraArqLog(aLogArq)
	endif

return aLogArq

static function envPendGes(cPeriodo, cMV_MAIL_ENV, cLinkPortal)
	Local aBody		   := {}  	//Dados que irao compor a tabela do html
	Local aHeader	   := {}  	//Dados que irao compor o envio do email
	Local aLogArq 	   := {}   //Array com log do que foi feito pela rotina
	Local calias 	   := GetNextalias() //alias resevardo para consulta SQL
	Local cQuery 	 	:= '' 	//Consulta SQL
	Local cUserAnte  	:= ''  	//user anterior
	Local lExeChange 	:= .T. 	//Executa o change Query
	local lTotaliza 	:= .F.
	Local nRec 		    := 0   	//Numero Total de Registros da consulta SQL
	Local nContaDoc     := 0

	default cPeriodo := ''
	default cMV_MAIL_ENV := ''
	default cLinkPortal := ''

	cQuery := " SELECT "
	cQuery += " SRAGES.RA_NOME GESTOR "
	cQuery += " , SRAGES.RA_EMAIL  EMAIL"
	cQuery += " , SRACOL.RA_NOME COLAB "
	cQuery += " , COUNT(PBB.PBB_DTAPON) QTDE  "
	cQuery += " FROM  "
	cQuery += " "+RetSQLName("PBB")+" PBB, "
	cQuery += " "+RetSQLName("RDZ")+" RDZ, "
	cQuery += " "+RetSQLName("SRA")+" SRAGES, "
	cQuery += " "+RetSQLName("SRA")+" SRACOL  "
	cQuery += " WHERE  "
	cQuery += " PBB.D_E_L_E_T_ = ' ' "
	cQuery += " AND RDZ.D_E_L_E_T_ = ' ' "
	cQuery += " AND SRAGES.D_E_L_E_T_ = ' ' "
	cQuery += " AND SRACOL.D_E_L_E_T_ = ' ' "
	cQuery += " AND PBB.PBB_STATUS = '1' "
	cQuery += " AND PBB.PBB_PAPONT = '"+cPeriodo+"' "
	cQuery += " AND PBB.PBB_APROV = RDZ.RDZ_CODRD0 "
	cQuery += " AND SRAGES.RA_FILIAL || SRAGES.RA_MAT = RDZ.RDZ_CODENT "
	cQuery += " AND SRACOL.RA_FILIAL =  PBB.PBB_FILMAT "
	cQuery += " AND SRACOL.RA_MAT = PBB.PBB_MAT "
	cQuery += " AND SRACOL.RA_DEMISSA = '' "
	cQuery += " GROUP BY  "
	cQuery += " SRAGES.RA_NOME "
	cQuery += " , SRAGES.RA_EMAIL "
	cQuery += " , SRACOL.RA_NOME "

	//Executa consulta SQL
	if U_MontarSQL(calias, @nRec, cQuery, lExeChange, lTotaliza)
		aAdd( aHeader, capital( alltrim((calias)->GESTOR) ) )         						//Nome no Fluig
		aAdd( aHeader, iif(empty(cMV_MAIL_ENV), alltrim((calias)->EMAIL), cMV_MAIL_ENV))	//email no fluig
		aAdd( aHeader, cMSG1_GES+aHeader[1]+cMSG2_GES+cMSG3_GES+cMSG4_GES) 						//Mensagem titulo
		cUserAnte := (calias)->GESTOR  				//guarda o ultimo usuario processado

		//Guarda dados em array para gerar os html
		while (calias)->(!EoF())
			if (calias)->GESTOR != cUserAnte
				aAdd( aHeader, cValToChar(nContaDoc) )                                     //Número de documentos por funcionário.
				aAdd( aHeader, cLinkPortal )                                                    //Link Email

				EnvEmail(aHeader, aBody, aTYPE_COL_GES, cTITULO_EMAIL_GES, aTITULO_TABELA_GES, cPeriodo) 	//Envia email para os aprovadores

				aAdd(aLogArq, {aHeader, aBody})
				aHeader   := {}
				aBody     := {}
				nContaDoc := 0

				aAdd( aHeader, capital( alltrim((calias)->GESTOR) ) )         						//Nome no Fluig
				aAdd( aHeader, iif(empty(cMV_MAIL_ENV), alltrim((calias)->EMAIL), cMV_MAIL_ENV))	//email no fluig
				aAdd( aHeader, cMSG1_GES+aHeader[1]+cMSG2_GES+cMSG3_GES+cMSG4_GES) 						//Mensagem titulo
			endif

			//Monta array aBody
			aAux := {}
			aAdd(aAux, alltrim((calias)->COLAB))
			aAdd(aAux, (calias)->QTDE )
			aAdd(aBody, aAux) 					 //guarda dados do item do email

			nContaDoc++
			cUserAnte := (calias)->GESTOR  				//guarda o ultimo usuario processado
			(calias)->(dbSkip())
		end
		aAdd(aLogArq, {aHeader, aBody})
		(calias)->(dbCloseArea())

		if !empty(aHeader) .and. nContaDoc > 0
			aAdd( aHeader, cValToChar(nContaDoc) )                                     //Número de documentos por funcionário.
			aAdd( aHeader, cLinkPortal )                                                    //Link Email
			EnvEmail(aHeader, aBody, aTYPE_COL_GES, cTITULO_EMAIL_GES, aTITULO_TABELA_GES, cPeriodo) //Envia email para os aprovadores
		endif

		//GeraArqLog(aLogArq)
	endif

return aLogArq

static function envPendDlc(cPeriodo, cMV_MAIL_ENV, cLinkPortal)
	Local aBody		   := {}  	//Dados que irao compor a tabela do html
	Local aHeader	   := {}  	//Dados que irao compor o envio do email
	Local aLogArq 	   := {}   //Array com log do que foi feito pela rotina
	Local calias 	   := GetNextalias() //alias resevardo para consulta SQL
	Local cQuery 	 	:= '' 	//Consulta SQL
	Local cUserAnte  	:= ''  	//user anterior
	Local lExeChange 	:= .T. 	//Executa o change Query
	local lTotaliza 	:= .F.
	Local nRec 		    := 0   	//Numero Total de Registros da consulta SQL
	Local nContaDoc     := 0
	Local lUltApro := .F.

	default cPeriodo := ''
	default cMV_MAIL_ENV := ''
	default cLinkPortal := ''

	cQuery := " SELECT "
	cQuery += " SRAGES.RA_NOME GESTOR "
	cQuery += " , SRAGES.RA_EMAIL  EMAIL"
	cQuery += " , SRACOL.RA_NOME COLAB "
	cQuery += " , PBB.PBB_FILIAL "
	cQuery += " , PBB.PBB_GRUPO "
	cQuery += " , PBB.PBB_APROV       "
	cQuery += " , PBB.PBB_FILMAT "
	cQuery += " , PBB.PBB_MAT "
	cQuery += " , PBB.PBB_DTAPON "
	cQuery += " , PBB.PBB_NIVEL "
	cQuery += " , COUNT(PBB.PBB_DTAPON) QTDE  "
	cQuery += " FROM  "
	cQuery += " "+RetSQLName("PBB")+" PBB, "
	cQuery += " "+RetSQLName("RDZ")+" RDZ, "
	cQuery += " "+RetSQLName("SRA")+" SRAGES, "
	cQuery += " "+RetSQLName("SRA")+" SRACOL  "
	cQuery += " WHERE  "
	cQuery += " PBB.D_E_L_E_T_ = ' ' "
	cQuery += " AND RDZ.D_E_L_E_T_ = ' ' "
	cQuery += " AND SRAGES.D_E_L_E_T_ = ' ' "
	cQuery += " AND SRACOL.D_E_L_E_T_ = ' ' "
	cQuery += " AND PBB.PBB_STATUS = '1' "
	cQuery += " AND PBB.PBB_APROV = RDZ.RDZ_CODRD0 "
	cQuery += " AND SRAGES.RA_FILIAL || SRAGES.RA_MAT = RDZ.RDZ_CODENT "
	cQuery += " AND SRACOL.RA_FILIAL =  PBB.PBB_FILMAT "
	cQuery += " AND SRACOL.RA_MAT = PBB.PBB_MAT "
	cQuery += " AND SRACOL.RA_DEMISSA = '' "
	cQuery += " GROUP BY  "
	cQuery += " SRAGES.RA_NOME "
	cQuery += " , SRAGES.RA_EMAIL "
	cQuery += " , SRACOL.RA_NOME "
	cQuery += " , PBB.PBB_FILIAL "
	cQuery += " , PBB.PBB_GRUPO "
	cQuery += " , PBB.PBB_APROV       "
	cQuery += " , PBB.PBB_FILMAT "
	cQuery += " , PBB.PBB_MAT "
	cQuery += " , PBB.PBB_DTAPON "
	cQuery += " , PBB.PBB_NIVEL "
	//Executa consulta SQL
	if U_MontarSQL(calias, @nRec, cQuery, lExeChange, lTotaliza)
		aAdd(aHeader, capital( alltrim((calias)->GESTOR) ) )         						//Nome no Fluig
		aAdd(aHeader, iif(empty(cMV_MAIL_ENV), alltrim((calias)->EMAIL), cMV_MAIL_ENV))	//email no fluig
		aAdd(aHeader, cMSG1_DLC+aHeader[1]+cMSG2_DLC+cMSG3_DLC+cMSG4_DLC) 						//Mensagem titulo
		aAdd(aHeader, cValToChar(nContaDoc)) //Número de documentos por funcionário.
		cUserAnte := (calias)->GESTOR  		 //guarda o ultimo usuario processado

		//Guarda dados em array para gerar os html
		PBB->(dbSetOrder(2))
		while (calias)->(!EoF())
			//Sou o ultimo aprovador?
			atualPBB(calias, aUltAprov)
			lUltApro := !( PBB->(dbSeek( (calias)->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+STR( PBB_NIVEL+1, 2, 0 )+PBB_GRUPO))) )

			//Se for o último aprovador
			if lUltApro
				//Volto no último aprovador
				if PBB->(dbSeek( (calias)->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+PBB_NIVEL+PBB_GRUPO+PBB_APROV+STR( PBB_NIVEL, 2, 0 ))))
					RecLock('PBB', .F.)
					PBB->PBB_STATUS := '1'
					//PBB->PBB_LOG := "Alt. Auto. envPendDlc User: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
					PBB->(MsUnLock())
				endif
			else
				//Volto no aprovador que não é último
				if PBB->(dbSeek( (calias)->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+PBB_NIVEL+PBB_GRUPO+PBB_APROV+STR( PBB_NIVEL, 2, 0 ))))
					RecLock('PBB', .F.)
					PBB->PBB_STATUS := '4' //Pulou a vez
					//PBB->PBB_LOG := "Alt. Auto. envPendDlc User: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
					PBB->(MsUnLock())
				endif

			endif

			if (calias)->NOME != cUserAnte
				EnvEmail(aHeader, aBody, aTYPE_COL_DLC, cTITULO_EMAIL_DLC, aTITULO_TABELA_DLC, cPeriodo) 	//Envia email para os aprovadores

				aAdd(aLogArq, {aHeader, aBody})
				aHeader   := {}
				aBody     := {}
				nContaDoc := 0

				aAdd(aHeader, capital( alltrim((calias)->GESTOR) ) )         						//Nome no Fluig
				aAdd(aHeader, iif(empty(cMV_MAIL_ENV), alltrim((calias)->EMAIL), cMV_MAIL_ENV))	//email no fluig
				aAdd(aHeader, cMSG1_DLC+aHeader[1]+cMSG2_DLC+cMSG3_DLC+cMSG4_DLC) 						//Mensagem titulo
				aAdd(aHeader, cValToChar(nContaDoc)) //Número de documentos por funcionário.
			endif

			//Monta array aBody
			aAux := {}
			aAdd(aAux, alltrim((calias)->COLAB))
			aAdd(aAux, alltrim((calias)->QTDE))
			aAdd(aBody, aAux) 							//guarda dados do item do email

			nContaDoc++
			cUserAnte := (calias)->GESTOR  				//guarda o ultimo usuario processado


			(calias)->(dbSkip())
		end
		aAdd(aLogArq, {aHeader, aBody})
		(calias)->(dbCloseArea())

		if !empty(aHeader)
			EnvEmail(aHeader, aBody, aTYPE_COL_DLC, cTITULO_EMAIL_DLC, aTITULO_TABELA_DLC, cPeriodo) //Envia email para os aprovadores
		endif

		//GeraArqLog(aLogArq)
	endif
return aLogArq

static function atualPBB(calias, aUltAprov)
	default calias    := ""
	default aUltAprov := ""

	if PBB->(dbSeek( (calias)->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+STR( PBB_NIVEL, 2, 0 )+PBB_GRUPO)))
		lUltApro := !( PBB->(dbSeek( (calias)->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+STR( PBB_NIVEL+1, 2, 0 )+PBB_GRUPO))) )
		if PBB->(dbSeek( (calias)->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+PBB_NIVEL+PBB_GRUPO+PBB_APROV+STR( PBB_NIVEL, 2, 0 ))))
			//Se for o último aprovador
			if lUltApro
				//Volto no último aprovador

				RecLock('PBB', .F.)
				PBB->PBB_STATUS := '1'
				//PBB->PBB_LOG := "Alt. Auto. envPendDlc User: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
				PBB->(MsUnLock())
			endif
		else
			//Volto no aprovador que não é último

			RecLock('PBB', .F.)
			PBB->PBB_STATUS := '4' //Pulou a vez
			//PBB->PBB_LOG := "Alt. Auto. envPendDlc User: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
			PBB->(MsUnLock())
		endif
	endif

return

//OTRS - 2020011310001158 - 13/01/2020 - BRUNO NUNES
static function updDesliga()
	Local calias 	 := GetNextalias() //alias resevardo para consulta SQL
	Local cQuery 	 := "" 	//Consulta SQL
	Local lExeChange := .T. 	//Executa o change Query
	local lTotaliza  := .F.
	Local nRec 		 := 0   	//Numero Total de Registros da consulta SQL
	local cChavePB7  := ""
	local cChavePBB  := ""
	local cStatus    := ""

	cQuery := " SELECT "
	cQuery += "    PB7.PB7_FILIAL, " 
	cQuery += "    PB7.PB7_MAT, "
	cQuery += "    PB7.PB7_DATA, "
	cQuery += "    PB7.PB7_STATUS "
	cQuery += " FROM "
	cQuery += "    "+RetSqlName('PB7')+" PB7 " 
	cQuery += "    INNER JOIN "
	cQuery += "       "+RetSqlName('SRA')+" SRA " 
	cQuery += "       ON SRA.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND SRA.RA_FILIAL = PB7.PB7_FILIAL " 
	cQuery += "       AND SRA.RA_MAT = PB7.PB7_MAT  "
	cQuery += "       AND SRA.RA_DEMISSA <> ' '  "
	cQuery += "    INNER JOIN "
	cQuery += "       "+RetSqlName('SRG')+" SRG " 
	cQuery += "       ON SRG.D_E_L_E_T_ = ' ' " 
	cQuery += "       AND SRG.RG_FILIAL = PB7.PB7_FILIAL " 
	cQuery += "       AND SRG.RG_MAT = PB7.PB7_MAT  "
	cQuery += "       AND SRG.RG_EFETIVA = 'S'  "
	cQuery += " WHERE "
	cQuery += "    PB7.D_E_L_E_T_ = ' ' " 
	cQuery += "    AND PB7.PB7_STATUS IN  "
	cQuery += "    ( "
	cQuery += "       '0', "
	cQuery += "       '1', "
	cQuery += "       '2'  "
	cQuery += "    ) "
	
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		
		while (cAlias)->( !EoF() )
			PB7->( dbSetOrder(1) )
			cChavePB7 := (cAlias)->( PB7_FILIAL + PB7_MAT + PB7_DATA ) 
			if PB7->( dbSeek( cChavePB7 ) )
				while cChavePB7 == PB7->( PB7_FILIAL + PB7_MAT + dToS(PB7_DATA) )
					RecLock( 'PB7', .F. )
					cStatus := iif ( PB7->PB7_STATUS == "1", "5", "6" ) 
					PB7->PB7_STATUS := cStatus
					PB7->PB7_STAATR := cStatus
					PB7->PB7_STAHE  := cStatus
					PB7->PB7_HRPOSE := ""
					PB7->PB7_HRPOSJ := ""
					PB7->PB7_HRNEGE := ""
					PB7->PB7_HRNEGJ := ""
					PB7->PB7_LOG    := "Trata PB7 para nao enviar email para funcionario com rescisao ja calculada."
					PB7->PB7_ALTERH := "000000"
					PB7->PB7_DALTRH := dDatabase
					PB7->PB7_HALTRH := replace( time(), ":", "")
					PB7->( MsUnLock() )
					PB7->( dbSkip() )
				end
			endif
			
			PBB->( dbSetOrder(2) )
			cChavePBB := (cAlias)->( xFilial("PBB") + PB7_FILIAL + PB7_MAT + PB7_DATA ) 
			if PBB->( dbSeek( cChavePBB ) )
				while cChavePBB == PBB->( PBB_FILIAL + PBB_MAT + dToS(PBB_DATA) )
					RecLock( 'PBB', .F. )
					PBB->( dbDelete() )
					PBB->PBB_LOG    := "Trata PB7 para nao enviar email para funcionario com rescisao ja calculada."
					PBB->( MsUnLock() )
					PBB->( dbSkip() )
				end
			endif
			(cAlias)->( dbSkip() )			
		end
		(cAlias)->( dbCloseArea() )
	endif
return