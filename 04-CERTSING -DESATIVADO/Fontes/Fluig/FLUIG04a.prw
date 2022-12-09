#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

#DEFINE nFLUIG_LOGAR 	1
#DEFINE nFLUIG_DESLOGAR 2

#DEFINE nFLUIG_CONN_PORTA 7890

#DEFINE nPARAM_TREINADO_DE 	1
#DEFINE nPARAM_TREINADO_ATE 2
#DEFINE nPARAM_CRIADO_DE 	3
#DEFINE nPARAM_CRIADO_ATE 	4

#DEFINE nCOLAB_MAT    1
#DEFINE nCOLAB_GESTOR 2
#DEFINE nCOLAB_CC     3
#DEFINE nCOLAB_FUNCAO 4
#DEFINE nCOLAB_EMAIL  5
#DEFINE nCOLAB_NOME   6

#DEFINE nSUPERIOR_COORD 1
#DEFINE nSUPERIOR_SUPER 2
#DEFINE nSUPERIOR_GEREN 3
#DEFINE nSUPERIOR_DIRET 4
#DEFINE nSUPERIOR_VICEP 5

#DEFINE cSX6_COORD_COD "MV_QCOORD"
#DEFINE cSX6_SUPER_COD "MV_QSUPER"
#DEFINE cSX6_GEREN_COD "MV_QGEREN"
#DEFINE cSX6_DIRET_COD "MV_QDIRET"
#DEFINE cSX6_VICEP_COD "MV_QVICEP"
#DEFINE cSX6_FLUIG_BD_IP   "MV_FLUIGT"
#DEFINE cSX6_FLUIG_BD_NOME "MV_FLUIGB"

#DEFINE cSX6_COORD_TIT "Uso da Qualiade. Lista de cargos de coordenadores"
#DEFINE cSX6_SUPER_TIT "Uso da Qualiade. Lista de cargos de supervisores"
#DEFINE cSX6_GEREN_TIT "Uso da Qualiade. Lista de cargos de gerentes"
#DEFINE cSX6_DIRET_TIT "Uso da Qualiade. Lista de cargos de diretorias"
#DEFINE cSX6_VICEP_TIT "Uso da Qualiade. Lista de cargos de vice presidentes"
#DEFINE cSX6_FLUIG_BD_TIT_IP 	"Ip do servidor top fluig"
#DEFINE cSX6_FLUIG_BD_TIT_NOME 	"Nome do servidor top fluig"

#DEFINE cSX6_LISTA_COORD '1305,1305,1144,1307,1137,1146,1129,1198,1137,1215,1130,1145,'+;
	'1308,1138,1126,1215,1137,1130,1198,1131,1273,1143,1142,1215,'+;
	'1137,1216,1136,1134,1130,1198,1198,1128,1311,1198'

#DEFINE cSX6_LISTA_SUPER '1231,1182,1185,1186,1189,1185,1302,1185,1182,1183,1190,1312,'+;
	'1301,1267,1185,1185,1185,1240,1185,1183,1185,1188,1183,1271,'+;
	'1183,1185,1185,1183,1185,1183,1183,1185,1185,987,1185,1186,'+;
	'1183,1183'

#DEFINE cSX6_LISTA_GEREN '1169,1166,1298,1156,1125,1249,1167,1155,1177,1155,1176,1162,'+;
	'1269,1168,1232,1268,1309,1274,1252,1163,1298,1298,1178,1175,'+;
	'1157,1250,1174,1275,1199,1224,1285,1280,1306,1313,1173,1285,'+;
	'1179,1299,1269,1299,1299,1232'

#DEFINE cSX6_LISTA_DIRET '989,1286,1149,1222,1257,990,1148'

#DEFINE cSX6_LISTA_VICEP '1219'

#DEFINE cSX6_FLUIG_BD_IP_CONTEUDO 	"192.168.16.106"//"192.168.16.133"
#DEFINE cSX6_FLUIG_BD_NOME_CONTEUDO "ORACLE/FLUIG_PRD"

/*/{Protheus.doc} FLUIG04a
Relatório customizado da qualidade, integrando dados
de funcionário com dados do FLUIG.
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
User Function FLUIG04a()
	private nHndOra //Handler do objeto de conexao com FLUIG.
	private oProcess

	oProcess := MsNewProcess():New( {|| procRel() }, "Relatório por documento Fluig", "Iniciando o processamento", .F. )
	oProcess:Activate()
Return

/*/{Protheus.doc} procRel
Processo o relatório
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
Static Function procRel()
	local aAux       := {}
	Local aCabec     := {}
	local aColab 	 := {}
	Local aLinha     := {}
	local aLstCoord  := {}
	local aLstDiret  := {}
	local aLstGeren  := {}
	local aLstSuper  := {}
	local aLstViceP  := {}
	local aSuperior  := {}
	local cAlias     := getNextAlias()
	local cEmail     := ""
	local cFluigIp   := ""
	local cFluigNome := ""
	local nRec       := 0
	local i			 := 0
	local cCC        := ""
	local cCCDesc    := ""

	//Carrego lista de parametros do sistema
	loadSx6( @aLstCoord, @aLstSuper, @aLstGeren, @aLstDiret, @aLstViceP, @cFluigIp, @cFluigNome )

	//Carrego os funcionário ativos em lista
	if !loadSra( @aColab )
		msgInfo( "Não foi encontrado nenhum funcionáro", "Processamento Cancelado" )
		return
	endif

	//Faço Conexão com o banco do Fluig.
	if !connFluig( nFLUIG_LOGAR, cFluigIp, cFluigNome )
		return
	endif

	//Carrego query do fluig em tabela temporaria
	if !loadFluig( cAlias )
		msgInfo("Erro ao carregar dados no servidor Fluig", "Processamento Cancelado")
		return
	endif

	Count To nRec
	( cAlias )->(dbGoTop())
	oProcess:SetRegua2( nRec )

	//Carrega cabecalho do relatório
	loadCabec( @aLinha, @aCabec )

	while ( cAlias )->( !EOF() )
		i++
	 	oProcess:IncRegua2("Carregando lista de documentos: "+strZero( i, 6)+"/"+strZero( nRec, 6))

		aAux := {}
		cEmail := lower( allTrim( ( cAlias )->EMAIL ) )

		aAdd( aAux, allTrim( ( cAlias )->NOME ) )

		nPos := aScan(aColab, {|x| x[nCOLAB_EMAIL] == cEmail })
		if nPos > 0
			cCC		 := aColab[nPos][3]
			cCCDesc	 := aColab[nPos][7]
		else
			cCC		 := ""
			cCCDesc	 := ""
		endif

		aAdd( aAux, cCC )
		aAdd( aAux, cCCDesc )
		aAdd( aAux, cValToChar( ( cAlias )->QUANT ) )

		//Carrego array com superiores do colaborador
		if loadSuper( @aSuperior, aColab, aLstCoord, aLstSuper, aLstGeren, aLstDiret, aLstViceP, cEmail )
			aAdd( aAux, aSuperior[nSUPERIOR_SUPER] )
			aAdd( aAux, aSuperior[nSUPERIOR_COORD] )
			aAdd( aAux, aSuperior[nSUPERIOR_GEREN] )
			aAdd( aAux, aSuperior[nSUPERIOR_DIRET] )
			aAdd( aAux, aSuperior[nSUPERIOR_VICEP] )
		endif

		aAdd( aLinha, aAux )
		( cAlias )->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
	end

	connFluig( nFLUIG_DESLOGAR )

	//Gera Excel
	DlgToExcel({ {"ARRAY","Doctos. Fluig", aCabec, aLinha} })
Return

/*/{Protheus.doc} loadSra
Carrega funcionário ativos da tabela SRA em array
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
static function loadSra( aColab )
	local cAlias    := getNextAlias()
	local cQuery    := ""
	local aAux      := {}
	local lCarregou := .F.
	local nRec      := 0
	local i := 0

	default aColab := {}

	cQuery := " SELECT "
	cQuery += " 	RA_MAT "
	cQuery += " 	, RA_XCGEST "
	cQuery += " 	, RA_CC "
	cQuery += " 	, CTT_DESC01 "
	cQuery += " 	, RA_CODFUNC "
	cQuery += " 	, RA_EMAIL "
	cQuery += " 	, RA_NOME "
	cQuery += " FROM "
	cQuery += " 	"+retSqlName("SRA")+" SRA, "
	cQuery += " 	"+retSqlName("CTT")+" CTT "
	cQuery += " WHERE "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND CTT.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND CTT.CTT_CUSTO = SRA.RA_CC "
	cQuery += " 	AND SRA.RA_DEMISSA = ' ' "

	cQuery := ChangeQuery(cQuery)
	if select( cAlias ) > 0
		( cAlias )->( dbCloseArea() )
	EndIf
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), ( cAlias ), .F., .T.)

	Count To nRec
	( cAlias )->(dbGoTop())
	oProcess:SetRegua1( nRec )

	While ( cAlias )->(!EOF())
		i++
	 	oProcess:IncRegua1("Carregando lista de colabodoradores: "+strZero( i, 6)+"/"+strZero( nRec, 6))
		aAux := {}
		aAdd( aAux, ( cAlias )->RA_MAT     )
		aAdd( aAux, ( cAlias )->RA_XCGEST  )
		aAdd( aAux, ( cAlias )->RA_CC      )
		aAdd( aAux, ( cAlias )->RA_CODFUNC )
		aAdd( aAux, lower( allTrim( ( cAlias )->RA_EMAIL ) ) )
		aAdd( aAux, capital( allTrim( ( cAlias )->RA_NOME  ) ) )
		aAdd( aAux, capital( allTrim( ( cAlias )->CTT_DESC01 ) ) )
		aAdd( aColab, aAux )
		lCarregou := .T.
		( cAlias )->( dbSkip() )
	EndDo
	( cAlias )->( dbCloseArea() )

return lCarregou

/*/{Protheus.doc} connFluig
Conexão com FLUIG
1-Abre conexão.
2-Fecha conexão.
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
static function connFluig( nOperacao, cFluigIp, cFluigNome )
	local lConn := .T.

	default nOperacao  := 0
	default cFluigIp   := ""
	default cFluigNome := ""

	if nOperacao == nFLUIG_LOGAR
		TCConType("TCPIP")
		nHndOra := tcLink( cFluigNome, cFluigIp, nFLUIG_CONN_PORTA )
		If nHndOra < 0
			alert( "Erro (" + str( nHndOra, 4 ) + ") ao conectar com " + cFluigIp + " em " + cFluigNome )
			lConn := .F.
		Endif
	elseif nOperacao == nFLUIG_DESLOGAR
		TcUnlink(nHndOra)
	else
		lConn := .F.
	endif
return lConn

/*/{Protheus.doc} loadFluig
Carrega tabela temporaria do FLUIG
passada em parâmetro da rotina.
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
static function loadFluig( cAlias )
	local cQuery := ""
	local lCarregou := .F.

	default cAlias := ""

	if !empty(cAlias)
		cQuery := " SELECT NOME "
		cQuery += "       ,EMAIL "
		cQuery += "       ,COUNT(*) QUANT "
		cQuery += " FROM DOCUMENT "
		cQuery += " WHERE "
		cQuery += " dateExecuted is null "
		cQuery += " GROUP BY NOME, EMAIL "
		cQuery += " ORDER BY NOME, EMAIL "

		If Select( cAlias ) > 0
			( cAlias )->( dbCloseArea() )
		EndIf

		dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
		dbSelectArea( cAlias )
		( cAlias )->( dbGoTop() )
		lCarregou := .T.
	endif
return lCarregou

/*/{Protheus.doc} loadSuper
Carrega lista de cargos do superiores
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
static function loadSuper( aSuperior, aColab, aLstCoord, aLstSuper, aLstGeren, aLstDiret, aLstViceP, cEmail )
	local lCarregou := .F.
	local nPos      := 0
	local cSuperior := ""
	local cNome     := ""
	local cFuncao   := ""

	default aSuperior := {}
	default aColab	  := {}
	default aLstCoord := {}
	default aLstSuper := {}
	default aLstGeren := {}
	default aLstDiret := {}
	default aLstViceP := {}
	default cEmail    := ""

	//Carrego o array com 4 posições vazias
	aSuperior := array(5)
	aFill( aSuperior, "" )

	//Verifico se o array de colaboradores e o email estão vazios.
	if !empty(aColab) .and. !empty( cEmail )
		//Busco o colaborador pelo email
		nPos := aScan(aColab, {|x| x[nCOLAB_EMAIL] == cEmail })
		if nPos > 0
			cSuperior := aColab[ nPos ][ nCOLAB_GESTOR ] //Pego o codigo da matricula do gestor
			nPos      := aScan( aColab, { |x| x[ nCOLAB_MAT ] == cSuperior }) //Pesquiso a matricula do gestor imediato
		endif
		while nPos > 0
			cSuperior := aColab[ nPos ][ nCOLAB_GESTOR ]
			cNome 	  := aColab[ nPos ][ nCOLAB_NOME ]
			cFuncao   := allTrim( aColab[ nPos ][ nCOLAB_FUNCAO ] )

			//Verifico se o superior é coordenardor
			nPos := aScan( aLstCoord, { |x| x == cFuncao })
			if nPos > 0
				if !empty(aSuperior[ nSUPERIOR_COORD ])
					aSuperior[ nSUPERIOR_COORD ] += ";"
				endif
				aSuperior[ nSUPERIOR_COORD ] += cNome
			endif

			//Verifico se o superior é supervisor
			nPos := aScan( aLstSuper, { |x| x == cFuncao })
			if nPos > 0
				if !empty(aSuperior[ nSUPERIOR_SUPER ])
					aSuperior[ nSUPERIOR_SUPER ] += ";"
				endif
				aSuperior[ nSUPERIOR_SUPER ] += cNome
			endif

			//Verifico se o superior é gerente
			nPos := aScan( aLstGeren, { |x| x == cFuncao })
			if nPos > 0
				if !empty(aSuperior[ nSUPERIOR_GEREN ])
					aSuperior[ nSUPERIOR_GEREN ] += ";"
				endif
				aSuperior[ nSUPERIOR_GEREN ] += cNome
			endif

			//Verifico se o superior é diretor
			nPos := aScan( aLstDiret, { |x| x == cFuncao })
			if nPos > 0
				if !empty(aSuperior[ nSUPERIOR_DIRET ])
					aSuperior[ nSUPERIOR_DIRET ] += ";"
				endif
				aSuperior[ nSUPERIOR_DIRET ] += cNome
			endif

			//Verifico se o superior é vice-presidente
			nPos := aScan( aLstViceP, { |x| x == cFuncao })
			if nPos > 0
				if !empty(aSuperior[ nSUPERIOR_VICEP ])
					aSuperior[ nSUPERIOR_VICEP ] += ";"
				endif
				aSuperior[ nSUPERIOR_VICEP ] += cNome
			endif

			//Busco o superior do superior que estou posicinado até não haver mais superior
			nPos := aScan( aColab, { |x| x[ nCOLAB_MAT ] == cSuperior })
			lCarregou := .T.
		end
	endif

return lCarregou

/*/{Protheus.doc} loadSx6
Carrega parametros SX6
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
static function loadSx6( aLstCoord, aLstSuper, aLstGeren, aLstDiret, aLstViceP, cFluigIp, cFluigNome )
	default aLstCoord := {}
	default aLstSuper := {}
	default aLstGeren := {}
	default aLstDiret := {}
	default aLstViceP := {}
	default cFluigIp	:= ""
	default cFluigNome	:= ""

	//Cria parametro lista de coordenador
	SX6->( dbSetOrder(1) )
	if !SX6->( dbSeek(xFilial('SX6')+cSX6_COORD_COD))
		CriarSX6( cSX6_COORD_COD, 'C', cSX6_COORD_TIT, cSX6_LISTA_COORD )
	endif

	//Cria parametro lista de supervisor
	SX6->( dbSetOrder(1) )
	if !SX6->( dbSeek(xFilial('SX6')+cSX6_SUPER_COD))
		CriarSX6( cSX6_SUPER_COD, 'C', cSX6_SUPER_TIT, cSX6_LISTA_SUPER )
	endif

	//Cria parametro lista de gerente
	SX6->( dbSetOrder(1) )
	if !SX6->( dbSeek(xFilial('SX6')+cSX6_GEREN_COD))
		CriarSX6( cSX6_GEREN_COD, 'C', cSX6_GEREN_TIT, cSX6_LISTA_GEREN )
	endif

	//Cria parametro lista de diretor
	SX6->( dbSetOrder(1) )
	if !SX6->( dbSeek(xFilial('SX6')+cSX6_DIRET_COD))
		CriarSX6( cSX6_DIRET_COD, 'C', cSX6_DIRET_TIT, cSX6_LISTA_DIRET )
	endif

	//Cria parametro lista de vice-presidencia
	SX6->( dbSetOrder(1) )
	if !SX6->( dbSeek(xFilial('SX6')+cSX6_VICEP_COD))
		CriarSX6( cSX6_VICEP_COD, 'C', cSX6_VICEP_TIT, cSX6_LISTA_VICEP )
	endif

	aLstCoord := StrTokArr( GetMv( cSX6_COORD_COD ), "," )
	aLstSuper := StrTokArr( GetMv( cSX6_SUPER_COD ), "," )
	aLstGeren := StrTokArr( GetMv( cSX6_GEREN_COD ), "," )
	aLstDiret := StrTokArr( GetMv( cSX6_DIRET_COD ), "," )
	aLstViceP := StrTokArr( GetMv( cSX6_VICEP_COD ), "," )

	//Cria parametro lista de vice-presidencia
	SX6->( dbSetOrder(1) )
	if !SX6->( dbSeek(xFilial('SX6')+cSX6_FLUIG_BD_IP))
		CriarSX6( cSX6_FLUIG_BD_IP, 'C', cSX6_FLUIG_BD_TIT_IP, cSX6_FLUIG_BD_IP_CONTEUDO )
	endif

	//Cria parametro lista de vice-presidencia
	SX6->( dbSetOrder(1) )
	if !SX6->( dbSeek(xFilial('SX6')+cSX6_FLUIG_BD_NOME))
		CriarSX6( cSX6_FLUIG_BD_NOME, 'C', cSX6_FLUIG_BD_TIT_NOME, cSX6_FLUIG_BD_NOME_CONTEUDO )
	endif

	cFluigIp   := GetMv( cSX6_FLUIG_BD_IP )
	cFluigNome := GetMV( cSX6_FLUIG_BD_NOME )
return

/*/{Protheus.doc} loadCabec
Carrega array com cabeçalho do relatório.
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
static function loadCabec( aLinha, aCabec )
	local aAux := {}

	default aLinha := {}
	default aCabec := {}

	aAdd(aCabec, {"Nome" 			,"C", 040, 0})
	aAdd(aCabec, {"Centro de Custo" ,"C", 040, 0})
	aAdd(aCabec, {"Descrição C.C." 	,"C", 040, 0})
	aAdd(aCabec, {"Quantidade" 	   	,"C", 015, 0})
	aAdd(aCabec, {"Supervisor" 	   	,"C", 015, 0})
	aAdd(aCabec, {"Coordenador"    	,"C", 015, 0})
	aAdd(aCabec, {"Gerente" 	   	,"C", 015, 0})
	aAdd(aCabec, {"Diretor" 	   	,"C", 015, 0})
	aAdd(aCabec, {"Vice presidente"	,"C", 015, 0})

	aAdd(aAux, "Nome" )
	aAdd(aAux, "Centro de Custo")
	aAdd(aAux, "Descrição C.C.")
	aAdd(aAux, "Quantidade" )
	aAdd(aAux, "Supervisor" )
	aAdd(aAux, "Coordenador" )
	aAdd(aAux, "Gerente" )
	aAdd(aAux, "Diretor" )
	aAdd(aAux, "Vice presidente" )

	aAdd( aLinha, aAux )
return