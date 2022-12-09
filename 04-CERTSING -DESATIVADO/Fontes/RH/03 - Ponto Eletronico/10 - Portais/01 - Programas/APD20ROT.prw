#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#include "parmtype.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "TbiConn.ch"

#DEFINE cPARAM_CAMINHO    "PARAM_CAMINHO"
#DEFINE cPARAM_MODO_DEBUG "PARAM_MODO_DEBUG"

#define cPENDENCIA_APROVACAO_TIT "Existem Aprovação Criadas"
#define cPENDENCIA_APROVACAO_MSG "Existem aprovações pendentes. Deseja alterar o grupo de aprovação?"+CRLF+;
								 "Se confirmar as aprovações serão canceladas e os apontamentos serão"+;
								 " revertidos para o status aguardando manutenção."
#define cPENDENCIA_MARCACAO_TIT  "Existem Marcações Criadas"
#define cPENDENCIA_MARCACAO_MSG  "Existem marcações criadas. Deseja alterar o grupo de aprovação?"+CRLF+;
								 "Se confirmar as marcações serão"+;
								 " revertidos para o status aguardando manutenção."
#DEFINE cMSG1 "Prezado(a) [xx], o colaborador(a) [yy] foi transferido para o seu grupo de aprovação."
#DEFINE cMSG2 "Fique atento para realizar as aprovações desse colaborador(a)."
#DEFINE cTITULO_EMAIL 	"Fique atento para realizar as aprovações desse colaborador(a)."

User Function APD20ROT()
	Local aArea 	:= GetArea()
	Local aRotinas 	:= {}

	aAdd( aRotinas, { "Conhecimento"      , "MsDocument", 0, 7 } )
	aAdd( aRotinas, { "Grupo de Aprovação", "u_ALTGRP01", 0, 7 } )

	RestArea( aArea )
Return( aRotinas )

User Function ALTGRP01()
	local cGrupo   := ""
	local cFilMat  := ""
	local cMat	   := ""
	local cNome    := ""
	local lRemote  := .T.
	local aPeriodo := {}
	local i        := 0

	if inputGrupo(@cGrupo)
		RDZ->(dbSetOrder(2))
		if RDZ->(dbSeek( xFilial('RDZ')+RD0->RD0_CODIGO))
			cFilMat := substr(RDZ->RDZ_CODENT, 1, 2)
			cMat    := substr(RDZ->RDZ_CODENT, 3, 6)
			if existPBB( cFilMat, cMat, @aPeriodo )
				if msgYesNo( cPENDENCIA_APROVACAO_MSG, cPENDENCIA_APROVACAO_TIT)
					RD0AtuaGrp( cGrupo, @cNome )
					PB7AtuaGrp( cGrupo )
					for i := 1 to len(aPeriodo)
						u_fRestPB7(lRemote, "", cFilMat, cMat, aPeriodo[i])
					next i
					geraEmail( cGrupo, cNome )
					msgInfo("Grupo alterado para: "+cGrupo+". Aprovações e marcações revertidas.", "Alteração de grupo")
				endif
			elseif existPB7( cFilMat, cMat, @aPeriodo )
				if msgYesNo( cPENDENCIA_MARCACAO_MSG, cPENDENCIA_MARCACAO_TIT)
					RD0AtuaGrp( cGrupo, @cNome )
					PB7AtuaGrp(cGrupo)
					//for i := 1 to len(aPeriodo)
					//	u_fRestPB7(lRemote, "", cFilMat, cMat, aPeriodo[i])
					//next i
					geraEmail( cGrupo, cNome )
					msgInfo("Grupo alterado para: "+cGrupo+". Marcações revertidas.", "Alteração de grupo")
				endif
			else
				//Nesse caso não envia email pois não esta com PB7 ou PBB criada.
				RD0AtuaGrp( cGrupo )
				PB7AtuaGrp( cGrupo )
				msgInfo("Grupo alterado para: "+cGrupo+". Marcações revertidas.", "Alteração de grupo")
			endif
		endif
	else
		msgInfo("Alteração cancelada pelo usuário.", "Informação")
	endif
Return


/*/{Protheus.doc} inputDesc
Função para gravar descrição do processo
@type function
@author Bruno Nunes
@since 22/10/2018
@version P12 1.12.17
@return null, Nulo
/*/
static function inputGrupo(cRetGrupo)
	local aPergs   := {}
	local aRet	   := {}
	local cDescri  := space(6)
	local lRetorno := .F.

	default cRetGrupo := ""

	aAdd( aPergs ,{1,"Digite o novo grupo",cDescri,"@!",'.T.','GAPPON','.T.',60,.T.})

	if ParamBox(aPergs ,"Processo", @aRet)
		cRetGrupo := aRet[1]
		lRetorno  := .T.
	else
		cRetDescri := ""
		lRetorno   := .F.
	endif
return lRetorno

/*/{Protheus.doc} PB7AtuaGrp
Atualiza o campo dcaso o campo grupo de aprovação esteja preenchido

@Return Null
@author Bruno Nunes
@since 21/11/2018
@version 1.0
/*/
static function PB7AtuaGrp( cGrupo )
	local aArea  := GetArea()

	default cGrupo   := ""

	PB7->(dbSetOrder(1))
	if PB7->(dbSeek( alltrim(RDZ->RDZ_CODENT) ))
		While PB7->(!EoF()) .and. PB7->(PB7_FILIAL+PB7_MAT) == alltrim(RDZ->RDZ_CODENT)
			RecLock('PB7', .F.)
			PB7->PB7_GRPAPV := cGrupo
			//PB7->PB7_LOG := "Grupo Alt. PB7AtuaGrp pelo usuario: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
			PB7->(MsUnLock())
			PB7->(dbSkip())
		End
	endif

	RestArea(aArea)
Return

static function existPBB( cFilMat, cMat, aPeriodo )
	local lRetorno := .F.
	local cAlias   := getNextAlias()
	local nRec	   := 0
	local cQuery   := ""
	local lExeChange := .T.

	default cFilMat  := ""
	default cMat     := ""
	default aPeriodo := ""

	cQuery := " SELECT "
	cQuery += "    PBB_PAPONT "
	cQuery += " FROM "
	cQuery += "    "+RetSqlName("PBB")+"  "
	cQuery += " WHERE "
	cQuery += "    D_E_L_E_T_ = ' ' "
	cQuery += "    AND PBB_FILMAT = '"+cFilMat+"' "
	cQuery += "    AND PBB_MAT = '"+cMat+"'  "
	cQuery += " GROUP BY "
	cQuery += "    PBB_PAPONT "

	if U_MontarSQL( cAlias, @nRec, cQuery, lExeChange )
		lRetorno := .T.
		while (cAlias)->(!EoF())
			aAdd( aPeriodo, (cAlias)->PBB_PAPONT )
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif
return lRetorno

static function existPB7( cFilMat, cMat, aPeriodo )
	local lRetorno := .F.
	local cAlias   := getNextAlias()
	local nRec	   := 0
	local cQuery   := ""
	local lExeChange := .T.

	default cFilMat  := ""
	default cMat     := ""
	default aPeriodo := ""

	cQuery := " SELECT "
	cQuery += "    PB7_PAPONT "
	cQuery += " FROM "
	cQuery += "    "+RetSqlName("PB7")+"  "
	cQuery += " WHERE "
	cQuery += "    D_E_L_E_T_ = ' ' "
	cQuery += "    AND PB7_FILIAL = '"+cFilMat+"' "
	cQuery += "    AND PB7_MAT    = '"+cMat+"'  "
	cQuery += " GROUP BY "
	cQuery += "    PB7_PAPONT "

	if U_MontarSQL( cAlias, @nRec, cQuery, lExeChange )
		lRetorno := .T.
		while (cAlias)->(!EoF())
			aAdd( aPeriodo, (cAlias)->PB7_PAPONT )
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif
return lRetorno

static function RD0AtuaGrp( cGrupo, cNome )
	local aArea  := GetArea()

	default cGrupo := ""
	default cNome  := ""

	RD0->(dbSetOrder(1))
	if RD0->(dbSeek( xFilial('RD0') + alltrim( RDZ->RDZ_CODRD0 ) ) )
		RecLock('RD0', .F.)
		RD0->RD0_GRPAPV := cGrupo
		cNome := RD0->RD0_NOME
		RD0->(MsUnLock())
		RD0->(dbSkip())
	endif

	RestArea(aArea)
Return

static function geraEmail(cGrupo, cNome)
	Local aHeader	:= {}  	//Dados que irao compor o envio do email
	Local nTempo    := 0
	local nTempoFim := 0
	local aArea  := GetArea()

	private lModoDebug := .F.

	default cGrupo := ""
	default cNome  := ""

	if empty(cGrupo)
		return
	endif

	//Configura caminho do portal GCH
	if empty( GetGlbValue( cPARAM_CAMINHO ) ) .or. empty( GetGlbValue( cPARAM_MODO_DEBUG ) )
		u_ParamPtE()
	endif
	cLinkPortal := GetGlbValue(cPARAM_CAMINHO)
	if GetGlbValue(cPARAM_MODO_DEBUG) == "1"
		lModoDebug := .T.
	endif

	if lModoDebug
		nTempo := seconds()
		conout("	APD20ROT iniciado em: " + dtoc( msDate() ) + " as " + time() )
	endif

	SRA->(dbSetOrder(1))
	RDZ->(dbSetOrder(2))
	PBD->(dbSetOrder(1))
	if PBD->( dbSeek( xFilial('PBD') + cGrupo ) )
		while PBD->(!EoF()) .and. PBD->PBD_GRUPO == cGrupo
			if RDZ->(dbSeek(xFilial('RDZ')+PBD->PBD_APROV) ) .and. PBD->PBD_STATUS == '1'
				while RDZ->(!EoF()) .and. RDZ->RDZ_CODRD0 == PBD->PBD_APROV
					if RDZ->RDZ_ENTIDA == 'SRA'
						if SRA->(dbSeek(RDZ->RDZ_CODENT))
							aHeader := {}
							aAdd( aHeader, SRA->RA_EMAIL )
							aAdd( aHeader, capital( SRA->RA_NOME ) )
							aAdd( aHeader, cMSG1 + cMSG2  )
							aAdd( aHeader, capital( cNome ) )
							envEmail( aHeader, cTITULO_EMAIL )
						endif
					endif
					RDZ->( dbSkip() )
				end
			endif
			PBD->( dbSkip() )
		end
	endif

	if lModoDebug
		nTempoFim := seconds()
		conout("	Tempo de execucao: " + cValToChar( nTempoFim - nTempo ) + " segundos" )
		conout("	APD20ROT encerrado em: " + dtoc( msDate() ) + " as " + time() )
	endif
	RestArea(aArea)
Return

/*/{Protheus.doc} EnvEmail
Envia email conforme parametros
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aHeader, array, [1] - codigo do usario aprovador; [2] - email do usuario aprovador -- UsrRetMail(); [3] - nome do usuario aprovador; [4] - Mensagem titulo
@param aTypeCol, array, Tipo de coluna (T - Texto, N - Númerico, A - Link)
@param cTituloEmail, string, Título de email
@param aTabTitulo, array, Mensagem que sera montada no email

@return nulo
/*/
Static Function envEmail(aHeader, cTituloEmail)
	Local chtml 	  := '' //Strinf com html
	Local cEmailAprov := '' //Email do aprovador
	Local cMsgHTML 	  := '' //Mensagem do email

	Default aHeader 	 := {}
	Default cTituloEmail := 'Email enviado pelo Protheus'

	cEmailAprov := aHeader[1] //email do usuario aprovador
	cMsgHTML 	:= replace(aHeader[3], '[xx]', aHeader[2]) //Mensagem titulo
	cMsgHTML 	:= replace(cMsgHTML  , '[yy]', aHeader[4]) //Mensagem titulo

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
	chtml += '			<td valign="top" style="border-bottom:2px solid #003087; " >'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" colspan="2" style="padding:5px" width="0">'
	chtml += '				<p align="left">'
	chtml += '					<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	chtml += '				</p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '	</table>'
	chtml += '	</body>'
	chtml += '</html>'

	//Rotina de envio de email
	FsSendMail(cEmailAprov, cTituloEmail, chtml)

	if lModoDebug
		conout("	|")
		conout("	+---> Enviado para: "+cEmailAprov + " Titulo: "+cTituloEmail )
		conout("	|")
		conout("	+---> Processado em: "+dtoc(msDate()) + " Por: " + RetCodUsr() + " - "+ usrFullName(RetCodUsr()) )
		conout("")
	endif

Return()

