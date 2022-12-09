//Bibliotecas
#INCLUDE "protheus.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "topconn.ch"
#include "parmtype.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "TbiConn.ch"

#DEFINE cPARAM_CAMINHO    "PARAM_CAMINHO"
#DEFINE cPARAM_MODO_DEBUG "PARAM_MODO_DEBUG"

#DEFINE cMSG1 "Prezado(a) [xx], o grupo de aprovação [yy] foi alterado pelo analista [zz]."
#DEFINE cTITULO_EMAIL 	"Alteração no grupo de aprovação do Portal do Ponto Eletrônico."
#DEFINE aTITULO_TABELA_GRUPO 	{"Aprovadores","Nível"}
#DEFINE aTYPE_COL_GRUPO 		{"T", "N"}
#DEFINE aALIGN_COL_GRUPO 		{"left", "center"}
#DEFINE aTITULO_TABELA_COLAB 	{"Matrícula","Nome"}
#DEFINE aTYPE_COL_COLAB 		{"T", "T"}
#DEFINE aALIGN_COL_COLAB		{"left", "left"}



//Variáveis Estáticas
Static cTitulo := "Grupo de Aprovadores x Aprovadores - Portal do Ponto Eletrônico"

/*/{Protheus.doc} CSRH030
Função para cadastro de Grupo de Produtos (SBM) e Produtos (SB1), exemplo de Modelo 3 em MVC
@author Atilio
@since 17/08/2015
@version 1.0
@return Nil, Função não tem retorno
@example
u_CSRH030()
@obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function CSRH030()
	local aArea   := GetArea()
	local oBrowse

	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()

	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("PBA")

	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)

	//Desabilita detalhes
	oBrowse:DisableDetails()

	//Ativa a Browse
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Autor: Daniel Atilio                                                |
| Data:  17/08/2015                                                   |
| Desc:  Criação do menu MVC                                          |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function MenuDef()
	local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.CSRH030" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.CSRH030" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE "Alterar"    ACTION "VIEWDEF.CSRH030" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE "Excluir"    ACTION "VIEWDEF.CSRH030" OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE "Imprimir"   ACTION "VIEWDEF.CSRH030" OPERATION 8 					 ACCESS 0 //OPERATION 8
	ADD OPTION aRot TITLE "Copiar"     ACTION "VIEWDEF.CSRH030" OPERATION 9 					 ACCESS 0 //OPERATION 9

Return aRot

/*---------------------------------------------------------------------*
| Func:  ModelDef                                                     |
| Autor: Daniel Atilio                                                |
| Data:  17/08/2015                                                   |
| Desc:  Criação do modelo de dados MVC                               |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function ModelDef()
	local oModel    := Nil
	local oStPai    := FWFormStruct(1, "PBA")
	local oStFilho  := FWFormStruct(1, "PBD")
	local aRel      := {}
	local aGatilho  := {}

	//Monta Gatilho de nome do aprovador no grid
	aGatilho := FwStruTrigger( "PBD_APROV" , "PBD_APRNOM" , "RD0->RD0_NOME" , .T. , "RD0" , 1 , "xFilial('RD0')+M->PBD_APROV" )
	oStFilho:AddTrigger( aGatilho[1] , aGatilho[2] , aGatilho[3] ,aGatilho[4] )

	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New("CSRH030M", , {|| validGrupo(oModel)}   )
	oModel:AddFields("PBAMASTER",/*cOwner*/,oStPai)
	oModel:AddGrid("PBDDETAIL","PBAMASTER",oStFilho, { |oModelGrid| ValidLin(oModelGrid) }, /*bLinePost*/,/*bPre - Grid Inteiro*/, /**/ ,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence


	//if oModel:GetOperation() == 1
	//	oModel:InitValue("PBA_COD") := GETSXENUM("PBA","PBA_COD",,1)
	//endif

	oModel:GetModel("PBAMASTER"):SetFldNoCopy({"PBA_COD"})

	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aRel, {"PBD_FILIAL", "PBA_FILIAL"} )
	aAdd(aRel, {"PBD_GRUPO", "PBA_COD"})

	oModel:SetRelation("PBDDETAIL", aRel, PBD->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
	oModel:GetModel("PBDDETAIL"):SetUniqueLine({ "PBD_APROV" })  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})

	//Setando as descrições
	oModel:SetDescription("Grupo Aprovadores x Aprovadores")
	oModel:GetModel("PBAMASTER"):SetDescription("Modelo Grupo")
	oModel:GetModel("PBDDETAIL"):SetDescription("Modelo Aprovadores")
Return oModel

/*---------------------------------------------------------------------*
| Func:  ViewDef                                                      |
| Autor: Daniel Atilio                                                |
| Data:  17/08/2015                                                   |
| Desc:  Criação da visão MVC                                         |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function ViewDef()
	local oView     := Nil
	local oModel    := FWLoadModel("CSRH030")
	local oStPai    := FWFormStruct(2, "PBA")
	local oStFilho  := FWFormStruct(2, "PBD")

	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//Retira campo de relacionamento da tela
	oStFilho:RemoveField( "PBD_GRUPO" )

	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField( "VIEW_PBA" , oStPai , "PBAMASTER" )
	oView:AddGrid( "VIEW_PBD" , oStFilho , "PBDDETAIL" )
	oView:AddIncrementField( "VIEW_PBD", "PBD_ITEM" )

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox( "CABEC" , 30 )
	oView:CreateHorizontalBox( "GRID" , 70 )

	//Amarrando a view com as box
	oView:SetOwnerView( "VIEW_PBA" , "CABEC" )
	oView:SetOwnerView( "VIEW_PBD" , "GRID" )

	//Habilitando título
	oView:EnableTitleView( "VIEW_PBA" , "Grupo" )
	oView:EnableTitleView( "VIEW_PBD" , "Aprovadores" )
Return oView


Static Function ValidLin( oModelPBD )
	local lRet := .T.
	local oModel := FWModelActive()
	local cGrupo := oModel:GetValue( "PBAMASTER", "PBA_COD" )

	if empty( oModelPBD:GetValue( "PBD_GRUPO" )  )
		oModelPBD:LoadValue( "PBD_GRUPO", cGrupo )
	endif
Return lRet

Static Function validGrupo(oMdl)
	local lRetorno   := .T.
	local cQuery     := ''
	local cAliasRCC  := getNextAlias()
	local nRec       := 0
	local lExeChange := .T.
	local oGrid := nil
	local cGrupo := ""

	oGrid := oMdl:GetModel('PBDDETAIL')

	if validaNvl( oGrid )
		//Monta SQL
		cQuery := " SELECT "+CRLF
		cQuery += " SUBSTRING(RCC.RCC_CONTEU,  1, 16) CODIGO,   "+CRLF
		cQuery += " SUBSTRING(RCC.RCC_CONTEU,  1,  8) DATA_INI, "+CRLF
		cQuery += " SUBSTRING(RCC.RCC_CONTEU, 09,  8) DATA_FIM, "+CRLF
		cQuery += " SUBSTRING(RCC.RCC_CONTEU, 17,  1) LIBERA,   "+CRLF
		cQuery += " SUBSTRING(RCC.RCC_CONTEU, 18,  8) WFF,      "+CRLF
		cQuery += " SUBSTRING(RCC.RCC_CONTEU, 26,  8) WFG,      "+CRLF
		cQuery += " SUBSTRING(RCC.RCC_CONTEU, 34,  8) DLC       "+CRLF
		cQuery += " FROM  "+RetSqlName('RCC')+" RCC             "+CRLF
		cQuery += " WHERE RCC.D_E_L_E_T_ = ' '                  "+CRLF
		cQuery += "   AND RCC.RCC_CODIGO = 'U007'               "+CRLF
		cQuery += "   AND SUBSTRING(TRIM(RCC.RCC_CONTEU), 17, 1) = '1'   "+CRLF
		cQuery += " ORDER BY 2, 3 "+CRLF

		//Executa consulta SQL
		if MontarSQL(cAliasRCC, @nRec, cQuery, lExeChange)
			if msgYesNo("Todas as aprovações serão revertidas para o colaborador reenvia-las.", "Reverter aprovações")
				cGrupo := oMdl:GetValue( "PBAMASTER", "PBA_COD" )
				if !empty( cGrupo )
					u_fRestPB7(.T., cGrupo )
					avisaAprov( oGrid, cGrupo )
				endif
			else
				lRetorno := .F.
				Help( ,, "Ação cancelada pelo usuário",, "Não se aplica", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Não se aplica"})
				//oMdl:Activate(.F.)
			endif
			(cAliasRCC)->(dbCloseArea())
		endif
	else
		lRetorno := .F.
	endif
Return lRetorno

Static Function MontarSQL(cAlias, nRec, cQuery, lExeChange)
	local lRetorno := .F.

	default lExeChange := .T.

	//Monta tabela temporaria conforme query pre formatada
	If lExeChange
		cQuery := ChangeQuery(cQuery)
	EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)

	//Verifica se ha dados na tabela temporaria
	if select( cAlias ) > 0
		( cAlias )->(!dbGoTop())
		if ( cAlias )->(!EoF())
			nRec := 9999999
			lRetorno := .T.
			( cAlias )->(!dbGoTop())
		else
			( cAlias )->(dbCloseArea())
		endif
	Else
		(cAlias)->(dbCloseArea())
	EndIf

Return(lRetorno)

static function avisaAprov( oGrid, cGrupo )
	local cNivel 	 := ""
	local nAtivado 	 := 0
	local cNomeGrp 	 := ""
	local cNomeApv 	 := ""
	local aGrupo 	 := {}
	local aColaGrp 	 := {}
	local i 		 := 0

	default cGrupo := ""

	totLinhas := oGrid:GetQTDLine()

	//Monta lista grupo
	for i := 1 to totLinhas
		cAprov     := oGrid:GetValue( 'PBD_APROV', i)
		cNivel     := oGrid:GetValue( 'PBD_NIVEL', i)
		nAtivado   := oGrid:GetValue( 'PBD_STATUS', i)
		cNomeApv   := posicione( "RD0", 1, xFilial("RD0") + cAprov, "RD0_NOME" )

		if nAtivado == "1" .and. !( oGrid:IsDeleted(i) )
			aAdd( aGrupo, { cNomeApv, cNivel } )
		endif
	next i
	if !empty( aGrupo )
		aSort( aGrupo, , , {|x,y| x[2] < y[2] } )
	endif

	//Monta lista de colaboradores do grup9o
	aColaGrp := listaColab( cGrupo )

	//Processa email
	for i := 1 to totLinhas
		cAprov := oGrid:GetValue( 'PBD_APROV', i)
		cNomeGrp   := posicione( "PBA", 1, xFilial("PBA") + cGrupo, "PBA_DESC" )
		geraEmail(cAprov, cNomeGrp, aGrupo, aColaGrp)
	next i
return

static function geraEmail(cAprov, cNomeGrp, aGrupo, aColaGrp)
	local aHeader	:= {}  	//Dados que irao compor o envio do email
	local nTempo    := 0
	local nTempoFim := 0
	local aArea     := GetArea()

	private lModoDebug := .F.

	default cAprov := ""
	default cNomeGrp  := ""
	default aGrupo := {}
	default aColaGrp := {}

	if empty(cNomeGrp)
		return
	endif

	//Configura caminho do portal GCH
	if empty( GetGlbValue( cPARAM_CAMINHO ) ) .or. empty( GetGlbValue( cPARAM_MODO_DEBUG ) )
		u_ParamPtE()
	endif

	if GetGlbValue(cPARAM_MODO_DEBUG) == "1"
		lModoDebug := .T.
	endif

	if lModoDebug
		nTempo := seconds()
		conout("	CSRH030 iniciado em: " + dtoc( msDate() ) + " as " + time() )
	endif

	SRA->(dbSetOrder(1))
	RDZ->(dbSetOrder(2))
	if RDZ->( dbSeek( xFilial('RDZ') + cAprov ) )
		while RDZ->(!EoF()) .and. RDZ->RDZ_CODRD0 == cAprov
			if RDZ->RDZ_ENTIDA == 'SRA'
				if SRA->(dbSeek(RDZ->RDZ_CODENT))
					aHeader := {}
					aAdd( aHeader, SRA->RA_EMAIL )
					aAdd( aHeader, capital( SRA->RA_NOME ) )
					aAdd( aHeader, cMSG1 )
					aAdd( aHeader, capital( cNomeGrp ) )
					envEmail( aHeader, cTITULO_EMAIL, aGrupo, aColaGrp )
				endif
			endif
			RDZ->( dbSkip() )
		end
	endif

	if lModoDebug
		nTempoFim := seconds()
		conout("	Tempo de execucao: " + cValToChar( nTempoFim - nTempo ) + " segundos" )
		conout("	CSRH030 encerrado em: " + dtoc( msDate() ) + " as " + time() )
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
Static Function envEmail(aHeader, cTituloEmail, aGrupo, aColaGrp )
	local chtml 	  := '' //Strinf com html
	local cEmailAprov := '' //Email do aprovador
	local cMsgHTML 	  := '' //Mensagem do email
	local aLinha := {}
	local nLinha := 0
	local cClassLin := ""
	local nColuna := 0

	default aHeader 	 := {}
	default cTituloEmail := 'Email enviado pelo Protheus'
	default aGrupo := {}
	default aColaGrp := {}

	cEmailAprov := aHeader[1] //email do usuario aprovador
	cMsgHTML 	:= replace(aHeader[3], '[xx]', aHeader[2]) //Mensagem titulo
	cMsgHTML 	:= replace(cMsgHTML  , '[yy]', aHeader[4]) //Mensagem titulo
	cMsgHTML 	:= replace(cMsgHTML  , '[zz]', usrFullName(RetCodUsr())) //Mensagem titulo

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
	chtml += '				<p>Lista de como ficou o grupo: <br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'

	//Lista do grupo de aprovção
	if len(aGrupo) > 0
		chtml += '		<tr>'
		chtml += '			<td valign="top"  align="center" >'
		chtml += '				<table border="0" cellpadding="0" cellspacing="0" style="width:90%;">'
		chtml += '					<thead  >'
		chtml += '						<tr>'
		for nLinha := 1 to len(aTITULO_TABELA_GRUPO)
			chtml += '						<th align="'+aALIGN_COL_GRUPO[nLinha]+'" style="border-bottom:1px solid ; " >'+alltrim(aTITULO_TABELA_GRUPO[nLinha])+'</th>' //Monta cabecalho da tabela
		next nLinha
		chtml += '						</tr>'
		chtml += '					</thead>'
		for nLinha := 1 to len(aGrupo)
			aLinha := aGrupo[nLinha]

			iif (cClassLin == 'bgcolor=#FFFFFF', cClassLin := 'bgcolor=#DCDCDC', cClassLin := 'bgcolor=#FFFFFF')
			chtml += '				<tbody>'
			chtml += '					<tr>'
			for nColuna := 1 to len(aLinha)
				if aTYPE_COL_GRUPO[nColuna] == 'T'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL_GRUPO[nColuna]+'"  ><div><span>'+alltrim(left(Capital(aLinha[nColuna]),75))+'</span></div></td>' //insere coluna
				elseif aTYPE_COL_GRUPO[nColuna] == 'N'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL_GRUPO[nColuna]+'"  ><div><span>'+cValToChar(aLinha[nColuna])+'</span></div></td>' //insere coluna
				elseif aTYPE_COL_GRUPO[nColuna] == 'A'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL_GRUPO[nColuna]+'"  ><div><span><a href="'+alltrim(aLinha[nColuna])+'">Aprovar / Reprovar</a></span></div></td>'  //insere coluna
				endif
			next nColuna
			chtml += '					</tr>'
		next nLinha
		chtml += '					</tbody>'
		chtml += '				</table>'
		chtml += '			</td>'
		chtml += '		</tr>'
	endif

	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>Lista dos colaboradores do grupo: <br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'


	//Lista dos colaboradores
	if len(aColaGrp) > 0
		chtml += '		<tr>'
		chtml += '			<td valign="top"  align="center" >'
		chtml += '				<table border="0" cellpadding="0" cellspacing="0" style="width:90%;">'
		chtml += '					<thead  >'
		chtml += '						<tr>'
		for nLinha := 1 to len(aTITULO_TABELA_COLAB)
			chtml += '						<th align="'+aALIGN_COL_COLAB[nLinha]+'" style="border-bottom:1px solid ; " >'+alltrim(aTITULO_TABELA_COLAB[nLinha])+'</th>' //Monta cabecalho da tabela
		next nLinha
		chtml += '						</tr>'
		chtml += '					</thead>'
		for nLinha := 1 to len(aColaGrp)
			aLinha := aColaGrp[nLinha]

			iif (cClassLin == 'bgcolor=#FFFFFF', cClassLin := 'bgcolor=#DCDCDC', cClassLin := 'bgcolor=#FFFFFF')
			chtml += '				<tbody>'
			chtml += '					<tr>'
			for nColuna := 1 to len(aLinha)
				if aTYPE_COL_COLAB[nColuna] == 'T'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL_COLAB[nColuna]+'"  ><div><span>'+alltrim(left(Capital(aLinha[nColuna]),75))+'</span></div></td>' //insere coluna
				elseif aTYPE_COL_COLAB[nColuna] == 'N'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL_COLAB[nColuna]+'"  ><div><span>'+cValToChar(aLinha[nColuna])+'</span></div></td>' //insere coluna
				elseif aTYPE_COL_COLAB[nColuna] == 'A'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL_COLAB[nColuna]+'"  ><div><span><a href="'+alltrim(aLinha[nColuna])+'">Aprovar / Reprovar</a></span></div></td>'  //insere coluna
				endif
			next nColuna
			chtml += '					</tr>'
		next nLinha
		chtml += '					</tbody>'
		chtml += '				</table>'
		chtml += '			</td>'
		chtml += '		</tr>'
	endif
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
Return

static function listaColab( cGrupo )
	local aColaGrp 	 := {}
	local cQuery     := ''
	local cAlias 	 := getNextAlias()
	local nRec       := 0
	local lExeChange := .T.

	default cGrupo := ""

	//Monta SQL
	cQuery := " SELECT "
	cQuery += "    RA_MAT, "
	cQuery += "    RA_NOME "
	cQuery += " FROM "
	cQuery += "     "+RetSqlName('RD0')+"  RD0 "
	cQuery += "    INNER JOIN
	cQuery += "        "+RetSqlName('RDZ')+"  RDZ "
	cQuery += "       ON RDZ.D_E_L_E_T_ = '' "
	cQuery += "       AND RD0_CODIGO = RDZ.RDZ_CODRD0 "
	cQuery += "       AND RDZ.RDZ_ENTIDA = 'SRA' "
	cQuery += "    INNER JOIN "
	cQuery += "        "+RetSqlName('SRA')+"  SRA "
	cQuery += "       ON SRA.D_E_L_E_T_ = '' "
	cQuery += "       AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT "
	cQuery += "       AND SRA.RA_DEMISSA = '' "
	cQuery += "       AND SRA.RA_REGRA <> '99' "
	cQuery += " WHERE "
	cQuery += "    RD0.D_E_L_E_T_ = '' "
	cQuery += "    AND RD0.RD0_GRPAPV = '"+cGrupo+"' "

	//Executa consulta SQL
	if MontarSQL(cAlias, @nRec, cQuery, lExeChange)
		while (cAlias)->(!EoF())
			aAdd( aColaGrp, { (cAlias)->RA_MAT, (cAlias)->RA_NOME } )
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif
return aColaGrp

static function validaNvl( oGrid )
	local cAprov 	 := ""
	local cNivel 	 := ""
	local nAtivado 	 := 0
	local cNomeApv 	 := ""
	local aGrupo 	 := {}
	local i 		 := 0
	local nivelAnt   := 0
	local lValido    := .T.

	totLinhas := oGrid:GetQTDLine()

	//Monta lista grupo
	for i := 1 to totLinhas
		cAprov     := oGrid:GetValue( "PBD_APROV" , i )
		cNivel     := oGrid:GetValue( "PBD_NIVEL" , i )
		nAtivado   := oGrid:GetValue( "PBD_STATUS", i )

		if nAtivado == "1" .and. !( oGrid:IsDeleted( i ) )
			aAdd( aGrupo, { cNomeApv, cNivel } )
		endif
	next i
	if !empty( aGrupo )
		aSort( aGrupo, , , {|x,y| x[2] < y[2] } )
	endif

	//Processa email
	for i := 1 to len( aGrupo )
		if nivelAnt+1 != aGrupo[i][2]
			MSGALERT( "Ordenação de níveis inválida, revise a ordem cadastrada.", "Ordem de níveis inválida." )
			lValido := .F.
			exit
		endif
		nivelAnt := aGrupo[i][2]
	next i
return lValido