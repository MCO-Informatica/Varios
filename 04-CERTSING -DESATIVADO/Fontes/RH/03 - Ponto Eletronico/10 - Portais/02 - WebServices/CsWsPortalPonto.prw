#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE cNOME_FONTE 'CSWSPORTALPONTO.PRW'
#DEFINE nLiberado 	1
#DEFINE nPermissao 	2
#DEFINE nValorRCC	3

#DEFINE cTAB_GENERICA_PORTAL_PONTO 'U007'

/*
{Protheus.doc} WsCsPortalRH
Web Service do Portal do Ponto
@author Bruno Nunes
@since 12/08/2016
@version 2.01
*/
WsService WsCsPortalRH Description "Dados do colaborador em Json"
	WsData idkey 				  		As String
	WsData idPortalParticipante	  		As String
	WsData matResp				  		As String
	WsData ponmes 				  		As String
	WsData gestor				  		As String
	WsData dia 					 		As String
	WsData cc 					  		As String
	WsData ordemDia				  		As String
	WsData jsonFuncionario		  		As String
	WsData jsonMarcacao			  		As String
	WsData jsonLimiteAponta		  		As String
	WsData jsonPeriodoFerias	  		As String
	WsData jsonTotalColunas		  		As String
	WsData jsonEvePos			  		As String
	WsData jsonEveNeg			  		As String
	WsData jsonToAprovacao		  		As String
	WsData jsonListPeriodo        		As String
	WsData jsonListEquipe         		As String
	WsData jsonPortal             		As String
	WsData jsonPeriodo            		As String
	WsData jsonGrupoAprovadores   		As String
	WsData jsonListaAprovPenden   		As String
	WsData jsonListaResultParcial 		As String
	WsData jsonResultDiretoria    		As String
	WsData jsonListaAprovacoes    		As String
	WsData jsonListaAprovadores   		As String
	WsData jsonTipoGestor		  		As String
	WsData jsonPeriodoAberto	  		As String
	WsData jsonAprovador	      		As String
	WsData jsonPossuiAprovador    		As String
	WsData jsonListaProcesso      		As String
	WsData json					  		As String
	WsData marcacaoDia 			  		AS strMarcDia
	WsData Result				  		As strResult
	WsData liberaAprovacao		  		As strLiberaAprovacao
	WsData parametros					As String
	WsData aprovador					As String
	WsData filColab						As String
	WsData matColab						As String
	WsData grupo						As String
	WsData dIni						    As Date
	WsData dFim						    As Date
	WsData nHoraIni					    As float
	WsData nHoraFim					    As float
	WsData tipoUsuario					As String

	WsMethod getFuncionario 	  		Description "Método para retonar dados do colaborador"
	WsMethod getMarcacao 		  		Description "Retorna o cabecalho e itens da marcacao"
	WsMethod setMarcacaoDia 	  		Description "Grava nova marcação / apontamento"
	WsMethod getEvePos            		Description "Retorna lista de eventos positivos"
	WsMethod getEveNeg            		Description "Retorna lista de eventos positivos"
	WsMethod setToAprovacao       		Description "Envia marcações para aprovação"
	WSMethod getListaPeriodo	  		Description "Lista de Período para apontamento por funcionário"
	WSMethod getListaEquipe		  		Description "Lista de colaboradores da equipe do gestor"
	WSMethod setMarcacaoInicial   		Description "volta as marcacações para informação do ponto"
	WSMethod getPortal            		Description "Indica se deve abrir o novo ou velho portal"
	WSMethod getDetalheNeg 		  		Description "Lista de detalhe de evento negativo"
	WSMethod getDetalhePos 		  		Description "Lista de detalhe de evento positivo"
	WSMethod getGrupoAprovadores  		Description "Dados do aprovadores as quais o aprovadore esteja no mesmo grupo "
	WSMethod getAprovacaoPendente 		Description "Lista de aprovacoes pendentes"
	WSMethod getAprovacaoV2     		Description "Lista de aprovacoes pendentes V2"
	WSMethod getAprovador         		Description "Dados do aprovador aprovador"
	WSMethod getListaAprovacao	  		Description "Lista de aprovacoes"
	WSMethod getResultParcial	  		Description "Lista de Resultado Parcial de horas"
	WSMethod getResultDiretoria	  		Description "Lista de Resultado Parcial de horas"
	WsMethod getTipoGestor		  		Description "Tipo de Gestor que visualiza os gráficos 0-Não é usuário, 1-Diretoria, 2-Gestor de área"
	WsMethod getPeriodoAberto	  		Description "Mostra todos os periodos em aberto"
	WsMethod getListaCentroCusto  		Description "Lista de centro de custo que o aprovador pode visualizar"
	WsMethod getPossuiAprovador   		Description "Retorna 1-Possui Grupo de aprovadores, 2-Nao possui grupo de aprovadores"
	WsMethod getListaProcesso     		Description "Lista de como esta processo"
	WsMethod getMarcacaoFechada	  		Description "Retorna o cabecalho e itens da marcacao fechada"
	WsMethod getListaParticipante     	Description "Lista de participantes ativos que possuem SRA"
	WSMethod getDetalhePosPago	  		Description "Lista de detalhe de evento positivo que serão pagos em folha"
	WSMethod setReverterAprovacao	  	Description "Reverte todas as aprovaçoes do funcionario"
	WSMethod getParticipante			Description "Pega dados de participante utilizando como chave a matricula"
	WSMethod getListaGrupoAprovadores	Description "Monta lista de grupo de aprovadores para o participante logado."
	WSMethod getSaldoBH					Description "Retorna Saldo do banco de horas."
	WSMethod setPreAbono				Description "Grava Pré Abono"
	//WSMethod getQtdMarcacao				Description "Quantidade de marcacoes que podem ser alteradas."
	WSMethod getImportFuncionario		Description "Pega dados do funcionario para importacao Fluig"
	WSMethod getListaUniversoGrupo		Description "Monta lista dos grupos, aprovadores"
	WsMethod getExcelBancoHoras		    Description "Gera Excel na protheus data"
	WsMethod getExcelBancoHorasCusto    Description "Gera Excel na protheus data"
	WsMethod getListaExcelArquivo		Description "Gera Excel na protheus data"
EndWsService

/*
{Protheus.doc} strMarcDia
Estrutura do Web Service

@Return String
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WsStruct strMarcDia
	WsData cData 				As Date
	WsData c1E 					As String
	WsData c1S 					As String
	WsData c2E 					As String
	WsData c2S 					As String
	WsData c3E 					As String
	WsData c3S 					As String
	WsData c4E 					As String
	WsData c4S 					As String
	WsData horaNegValor 		As float
	WsData horaNegEvento 		As String
	WsData horaNegJustificativa As String
	WsData horaPosValor 		As float
	WsData horaPosEvento		As String
	WsData horaPosJustificativa As String
	WsData calend1EHR 			As float
	WsData calend1ETP 			As String
	WsData calend1SHR 			As float
	WsData calend1STP 			As String
	WsData calend2EHR 			As float
	WsData calend2ETP 			As String
	WsData calend2SHR 			As float
	WsData calend2STP 			As String
	WsData calend3EHR 			As float
	WsData calend3ETP 			As String
	WsData calend3SHR 			As float
	WsData calend3STP 			As String
	WsData calend4EHR 			As float
	WsData calend4ETP 			As String
	WsData calend4SHR 			As float
	WsData calend4STP 			As String
	WsData ordem 				As String
	WsData aponta 				As String
	WsData perAponta 			As String
	WsData turno 				As String
	WsData justificativaMarcacao As String
	WsData M1E 					As String
	WsData M1S 					As String
	WsData M2E 					As String
	WsData M2S 					As String
	WsData M3E 					As String
	WsData M3S 					As String
	WsData M4E 					As String
	WsData M4S 					As String
	WsData statusMarc 			As String
	WsData flagaponta 			As String
	WsData statusAtraso 		As String
	WsData statusHE 			As String
EndWsStruct

/*
{Protheus.doc} strLiberaAprovacao
Estrutura do Web Service

@Return String
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WsStruct strLiberaAprovacao
	WsData PerAponta 	As String
	WsData marcStatus 	As String
	WsData dia 			As String
	WsData statusAtraso As String
	WsData statusHe 	As String
	WsData aprovador 	As String
EndWsStruct

/*
{Protheus.doc} strResult
Estrutura do Web Service
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
*/
WsStruct strResult
	WsData periodo		As String
	WsData tipoGes		As String
	WsData tipoGra		As String
	WsData totaliza		As String
	WsData grafico		As String
	WsData filtro		As String
EndWsStruct

/*
{Protheus.doc} getFuncionario
Metodo para consultar informaçãoes do
funcionario com retorno em Json
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author Bruno Nunes
@since 05/02/2016
@version 2.0
*/
WsMethod getFuncionario WsReceive idkey, idPortalParticipante WsSEnd jsonFuncionario WsService WsCsPortalRH
	local cQuery 	 := "" //Consulta SQL
	local calias 	 := GetNextalias() // alias resevardo para consulta SQL
	local nRec 		 := 0 //Numero Total de Registros da consulta SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local aProperty  := { 'filial', 'matricula', 'nome', 'admissao', 'superior', 'funcao', 'cargo', 'departamento', 'centroCusto', 'horarioPadrao', 'horarioVigente', 'idParticipant' } //Propriedade do json
	local aData 	 := {} //Dados do json
	local aAux 		 := {} //Array auxiliar
	local cJson      := ""
	local aParam     := {}
	local aParti	 := {}
	local cIdLog	 := ""

	default ::idkey 	 			:= ""
	default ::idPortalParticipante 	:= ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			//Monta qurey do participantes
			cQuery := " SELECT  "
			cQuery += "     SRA.RA_FILIAL "
			cQuery += "     , SRA.RA_MAT "
			cQuery += "     , RD0.RD0_NOME "
			cQuery += "     , SRA.RA_ADMISSA "
			cQuery += "     , CTT.CTT_DESC01 "
			cQuery += "     , RD0.RD0_CODIGO "
			cQuery += "     , SRARESP.RA_MAT RESP_MAT "
			cQuery += "     , SRARESP.RA_NOME RESP_NOME "
			cQuery += "     , SRJ.RJ_DESC "
			cQuery += "     , SQ3.Q3_DESCSUM "
			cQuery += "     , SQB.QB_DESCRIC "
			cQuery += "     , SR6.R6_DESC "
			cQuery += " FROM "
			cQuery += "     "+RetSqlName("RD0")+" RD0, "
			cQuery += "     "+RetSqlName("RDZ")+" RDZ, "
			cQuery += "     "+RetSqlName("SRA")+" SRA  "
			cQuery += " LEFT JOIN "+RetSqlName("SQB")+" SQB ON  "
			cQuery += "     SQB.D_E_L_E_T_  = ' ' "
			cQuery += "     AND SQB.QB_CC = SRA.RA_CC "
			cQuery += " LEFT JOIN "+RetSqlName("SRA")+" SRARESP ON  "
			cQuery += "     SRARESP.D_E_L_E_T_  = ' ' "
			cQuery += "     AND SRARESP.RA_FILIAL = SQB.QB_FILRESP "
			cQuery += "     AND SRARESP.RA_MAT = SQB.QB_MATRESP "
			cQuery += " LEFT JOIN "+RetSqlName("SRJ")+" SRJ ON  "
			cQuery += "     SRJ.D_E_L_E_T_  = ' ' "
			cQuery += "     AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "
			cQuery += " LEFT JOIN "+RetSqlName("SQ3")+" SQ3 ON  "
			cQuery += "     SQ3.D_E_L_E_T_  = ' ' "
			cQuery += "     AND SQ3.Q3_CARGO = SRA.RA_CARGO "
			cQuery += " LEFT JOIN "+RetSqlName("SR6")+" SR6 ON  "
			cQuery += "     SR6.D_E_L_E_T_  = ' ' "
			cQuery += "     AND SR6.R6_TURNO = SRA.RA_TNOTRAB "
			cQuery += " LEFT JOIN "+RetSqlName("CTT")+" CTT ON  "
			cQuery += "     CTT.D_E_L_E_T_  = ' ' "
			cQuery += "     AND CTT.CTT_CUSTO = SRA.RA_CC "
			cQuery += " WHERE "
			cQuery += "		RD0.RD0_CODIGO = '"+aParam[3]+"'
			cQuery += "     AND SRA.D_E_L_E_T_ = ' ' "
			cQuery += "     AND RD0.D_E_L_E_T_ = ' ' "
			cQuery += "     AND RDZ.D_E_L_E_T_ = ' ' "
			cQuery += "     AND RD0.RD0_CODIGO = RDZ.RDZ_CODRD0  "
			cQuery += "     AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT  "
			cQuery += "     AND RDZ.RDZ_ENTIDA = 'SRA'  "
			cQuery += "     AND SRA.RA_SITFOLH <> 'D' "

			//Executa consultar
			if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lExeChange, lTotaliza)
				(calias)->(dbGoTop())

				aAdd(aAux, (calias)->(RA_FILIAL))  //filial
				aAdd(aAux, (calias)->(RA_MAT))    //matricula
				aAdd(aAux, Capital((calias)->(RD0_NOME)))   //nome
				aAdd(aAux, DtoC(StoD((calias)->(RA_ADMISSA)))) //admissao
				aAdd(aAux, Capital((calias)->(RESP_NOME)))  //superior
				aAdd(aAux, Capital((calias)->(RJ_DESC)))    //funcao
				aAdd(aAux, Capital((calias)->(Q3_DESCSUM))) //cargo
				aAdd(aAux, Capital((calias)->(QB_DESCRIC))) //departamento
				aAdd(aAux, Capital((calias)->(CTT_DESC01))) //centroCusto
				aAdd(aAux, (calias)->(R6_DESC)) //horarioPadrao
				aAdd(aAux, (calias)->('')) //horarioVigente
				aAdd(aAux, (calias)->RD0_CODIGO)   //idParticipant
				aAdd(aData, aAux)

				//Montar json
				U_json(@cJson, aData, aProperty, 'funcionario')
				::jsonFuncionario := cJson
				(calias)->(dbCloseArea())
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getMarcacao
Metodo que lista marcacao do funcionario
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author David Moraes
@since 05/02/2016
@version 2.0
*/
WSMethod getMarcacao WSReceive idkey, idPortalParticipante, ponmes WSSend jsonMarcacao WSService WsCsPortalRH
	local cMarcacao := ""
	local aRet      := {}
	local aPropMarc := {}
	local aParam 	:= {}
	local aParti 	:= {}
	local cIdLog    := ""
	local cPeriodo  := {}

	default ::idkey 	 			:= ""
	default ::idPortalParticipante 	:= ""
	default ::ponmes 				:= ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::ponmes)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)
		cPeriodo := ::ponmes

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				//Consutlta Marcacoes
				if u_perFecha( cPeriodo )
					u_LoadPB8( @aRet, aFunc[1], aFunc[2], cPeriodo, cIdLog)
				else
					aRet := U_CSRH012(aFunc[1], aFunc[2], cPeriodo, cIdLog)
				endif

				if Len(aRet) > 0
					U_json(@cMarcacao, aRet, aPropMarc, 'marcacao') //Monta Marcacao
					::jsonMarcacao := cMarcacao
				else
					::jsonMarcacao := ''
				endif
			endif
		endif
	endif
Return .T.

/*
{Protheus.doc} setMarcacaoDia
Metodo que altera a marcacao de um dia determidao
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param marcacaoDia - Estrutura com dados para alteração
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod setMarcacaoDia WSReceive idkey, idPortalParticipante, marcacaoDia WSSend jsonMarcacao WSService WsCsPortalRH
	local aRet       := {}
	local aPropMarc  := {}
	local aFunc 	 := {}
	local aParam     := {}
	local aParti     := {}
	local aMarcacao  := {}
	local cMarcacao  := ""
	local cIdLog	 := ""

	default ::idkey 	 			:= ""
	default ::idPortalParticipante 	:= ""
	default ::marcacaoDia 			:= Nil

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. valtype(::marcacaoDia) == 'O'
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			cIdLog	  := aParam[3]
			aPropMarc := loadPropMa()
			aFunc 	  := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0

				aAdd(aMarcacao, aFunc[1] 							) //1
				aAdd(aMarcacao, aFunc[2] 							) //2
				aAdd(aMarcacao, ::marcacaoDia:cData 				) //3
				aAdd(aMarcacao, ::marcacaoDia:c1E 					) //4
				aAdd(aMarcacao, ::marcacaoDia:c1S 					) //5
				aAdd(aMarcacao, ::marcacaoDia:c2E 					) //6
				aAdd(aMarcacao, ::marcacaoDia:c2S 					) //7
				aAdd(aMarcacao, ::marcacaoDia:c3E 					) //8
				aAdd(aMarcacao, ::marcacaoDia:c3S 					) //9
				aAdd(aMarcacao, ::marcacaoDia:c4E 					) //10
				aAdd(aMarcacao, ::marcacaoDia:c4S 					) //11
				aAdd(aMarcacao, ::marcacaoDia:horaNegValor 			) //12
				aAdd(aMarcacao, ::marcacaoDia:horaNegEvento 		) //13
				aAdd(aMarcacao, ::marcacaoDia:horaNegJustificativa 	) //14
				aAdd(aMarcacao, ::marcacaoDia:horaPosValor 			) //15
				aAdd(aMarcacao, ::marcacaoDia:horaPosEvento 		) //16
				aAdd(aMarcacao, ::marcacaoDia:horaPosJustificativa 	) //17
				aAdd(aMarcacao, ::marcacaoDia:calend1EHR 			) //18
				aAdd(aMarcacao, ::marcacaoDia:calend1ETP 			) //19
				aAdd(aMarcacao, ::marcacaoDia:calend1SHR 			) //20
				aAdd(aMarcacao, ::marcacaoDia:calend1STP 			) //21
				aAdd(aMarcacao, ::marcacaoDia:calend2EHR 			) //22
				aAdd(aMarcacao, ::marcacaoDia:calend2ETP 			) //23
				aAdd(aMarcacao, ::marcacaoDia:calend2SHR 			) //24
				aAdd(aMarcacao, ::marcacaoDia:calend2STP 			) //25
				aAdd(aMarcacao, ::marcacaoDia:calend3EHR 			) //26
				aAdd(aMarcacao, ::marcacaoDia:calend3ETP 			) //27
				aAdd(aMarcacao, ::marcacaoDia:calend3SHR 			) //28
				aAdd(aMarcacao, ::marcacaoDia:calend3STP 			) //29
				aAdd(aMarcacao, ::marcacaoDia:calend4EHR 			) //30
				aAdd(aMarcacao, ::marcacaoDia:calend4ETP 			) //31
				aAdd(aMarcacao, ::marcacaoDia:calend4SHR 			) //32
				aAdd(aMarcacao, ::marcacaoDia:calend4STP 			) //33
				aAdd(aMarcacao, ::marcacaoDia:ordem 				) //34
				aAdd(aMarcacao, ::marcacaoDia:aponta			 	) //35
				aAdd(aMarcacao, ::marcacaoDia:perAponta 			) //36
				aAdd(aMarcacao, ::marcacaoDia:turno 				) //37
				aAdd(aMarcacao, ::marcacaoDia:justificativaMarcacao ) //38
				aAdd(aMarcacao, ::marcacaoDia:M1E 					) //39
				aAdd(aMarcacao, ::marcacaoDia:M1S 					) //40
				aAdd(aMarcacao, ::marcacaoDia:M2E 					) //41
				aAdd(aMarcacao, ::marcacaoDia:M2S 					) //42
				aAdd(aMarcacao, ::marcacaoDia:M3E 					) //43
				aAdd(aMarcacao, ::marcacaoDia:M3S 					) //44
				aAdd(aMarcacao, ::marcacaoDia:M4E 					) //45
				aAdd(aMarcacao, ::marcacaoDia:M4S 					) //46
				aAdd(aMarcacao, ::marcacaoDia:statusMarc	 		) //47
				aAdd(aMarcacao, ::marcacaoDia:flagaponta 			) //48
				aAdd(aMarcacao, ::marcacaoDia:statusAtraso 			) //49
				aAdd(aMarcacao, ::marcacaoDia:statusHE 				) //50

				if len(aMarcacao) > 0
					//Consutlta Marcacoes
					aRet := U_CSRH013( aMarcacao, cIdLog, cIdLog )

					if Len(aRet) > 0
						U_json( @cMarcacao, aRet, aPropMarc, 'marcacao' ) //Monta Marcacao
						::jsonMarcacao := cMarcacao
					endif
				endif
			endif
		endif
	endif
return(.T.)

/*
{Protheus.doc} getEvePos
Metodo que lista os eventes de horas extras que estao liberado para portal
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod getEvePos WSReceive idkey, idPortalParticipante WSSend jsonEvePos WSService WsCsPortalRH
	local cQuery  	 := "" //Query SQL
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local nRec 		 := 0 //Numero Total de Registros da consulta SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local aEvento	 := {}
	local aProp      := {'P9_CODIGO', 'P9_PORTAL', 'P9_DPORTAL'}
	local cRetorno   := ""
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			//Monta SQL
			cQuery := " SELECT P9_CODIGO, "
			cQuery += " 	P9_PORTAL, "
			cQuery += " 	P9_DPORTAL "
			cQuery += " FROM "+RetSqlName("SP9")+" SP9"
			cQuery += " WHERE SP9.D_E_L_E_T_ <> '*'"
			cQuery += " 	AND SP9.P9_PORTAL = '2' "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				//Procura por funcionario que esteja ativo
				While (cAlias)->(!EOF())
					aAdd(aEvento, {(cAlias)->P9_CODIGO, (cAlias)->P9_PORTAL, Capital((cAlias)->P9_DPORTAL)})
					(cAlias)->(DbSkip())
				EndDo
				(cAlias)->(dbCloseArea())
				U_json(@cRetorno, aEvento, aProp, 'listaEvento') //Monta Marcacao
				::jsonEvePos := cRetorno
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getEveNeg
Metodo que lista os eventos negativos liberados para o portal do ponto
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod getEveNeg WSReceive idkey, idPortalParticipante WSSend jsonEveNeg WSService WsCsPortalRH
	local cQuery  	 := "" //Query SQL
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local nRec 		 := 0 //Numero Total de Registros da consulta SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local aEvento	 := {}
	local aProp      := {'P6_CODIGO', 'P6_PORTAL', 'P6_DPORTAL'}
	local cRetorno 	 := ""
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			//Monta SQL
			cQuery := " SELECT "
			cQuery += " 	P6_CODIGO, "
			cQuery += " 	P6_PORTAL, "
			cQuery += " 	P6_DPORTAL "
			cQuery += " FROM "+RetSqlName("SP6")+" SP6 "
			cQuery += " WHERE SP6.D_E_L_E_T_ <> '*'"
			cQuery += " 	AND SP6.P6_PORTAL = '2' "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				//Procura por funcionario que esteja ativo
				While (cAlias)->(!EOF())
					aAdd(aEvento, {(cAlias)->P6_CODIGO, (cAlias)->P6_PORTAL, Capital((cAlias)->P6_DPORTAL)})
					(cAlias)->(DbSkip())
				EndDo
				(cAlias)->(dbCloseArea())

				U_json(@cRetorno, aEvento, aProp, 'listaEvento') //Monta Marcacao
				::jsonEveNeg := cRetorno
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} setToAprovacao
Metodo para aprovar ou reprovar apontamento
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param liberaAprovacao - Estrutura do web service com dados para liberacao
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod setToAprovacao WSReceive idkey, idPortalParticipante, parametros, aprovador WSSend jsonToAprovacao WSService WsCsPortalRH
	local aParam  	:= {}
	local aParti  	:= {}
	local aFunc	  	:= {}
	local cIdLog	:= ""
	local oJson 	:= nil
	local i 		:= 0

	default ::idkey 	 			:= ""
	default ::idPortalParticipante 	:= ""
	default ::parametros 			:= ""
	default ::aprovador 			:= ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !empty(::parametros)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		FWJsonDeserialize( ::parametros, @oJson)
		if !empty( oJson )
			if ValidKey(aParam, aParti, 3)
				cIdLog := aParam[1]
				aFunc 	  := RetFuncSRA( aParam[3] )

				for i := 1 to len( oJson )
					if len(aFunc) > 0
						U_CSRH014( 	aFunc[1], ;
						aFunc[2], ;
						oJson[i]:cPerAPonta, ;
						oJson[i]:cDia, ;
						oJson[i]:cStatus, ;
						cIdLog, ;
						oJson[i]:statusAtraso, ;
						oJson[i]:statusHe, ;
						::aprovador, ;
						oJson[i]:criaAprovacao )
					endif
				next i
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getListaPeriodo
Metodo para montar uma lista de periodos do funcionario
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod getListaPeriodo WSReceive idkey, idPortalParticipante WSSend jsonListPeriodo WSService WsCsPortalRH
	local aAux		 := {}
	local aFunc      := {}
	local aParam     := {}
	local aParti	 := {}
	local aRet 		 := {}
	local aProp 	 := {'id', 'periodo', 'qtde', 'datainicio', 'datafim', 'idParticipant', 'qtd2', 'qtd3', 'qtd4','qtdt', 'mat', 'nome', 'cc', 'cc_desc', 'depto'}
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local cId  		 := ""
	local cRetorno	 := ""
	local cQuery 	 := "" 	//Consulta SQL
	local calias 	 := GetNextalias() 	// alias resevardo para consulta SQL
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""

	default ::idkey 	 		   := ''
	default ::idPortalParticipante := ''

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 1)
			cIdLog := aParam[1]
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 1
				if aFunc[7] != "99"
					cQuery := QueryPer({{aFunc[1], aFunc[2]}})
					if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
						while (calias)->(!eof())
							aAux := {}
							cId := u_CrypCsPE(.T., aParam[1]+';'+dtos(MsDate())+';'+(calias)->RD0_CODIGO+';'+(calias)->PB7_PAPONT, cIdLog )
							aAdd(aAux, cId)
							aAdd(aAux, (calias)->PB7_PAPONT)
							aAdd(aAux, (calias)->QTDE)
							aAdd(aAux, dtoc(stod(left((calias)->PB7_PAPONT,8))))
							aAdd(aAux, dtoc(stod(right((calias)->PB7_PAPONT,8))))
							aAdd(aAux, (calias)->RD0_CODIGO)
							aAdd(aAux, (calias)->QTD2)
							aAdd(aAux, (calias)->QTD3)
							aAdd(aAux, (calias)->QTD4)
							if  (calias)->( ABS(QTDE+QTD2+QTD3+QTD4) ) == 0
								aAdd(aAux, 99 )
							else
								aAdd(aAux, (calias)->( QTDE+QTD2 ) )
							endif
							aAdd(aAux, (calias)->RA_MAT)
							aAdd(aAux, (calias)->RA_NOME)
							aAdd(aAux, (calias)->RA_CC)
							aAdd(aAux, POSICIONE('CTT', 1, (calias)->(xFilial('CTT')+RA_CC), 'CTT_DESC01') )
							aAdd(aAux, POSICIONE('SQB', 4, (calias)->(xFilial('SQB')+RA_CC), 'QB_DESCRIC') )

							aAdd(aRet, aAux)
							(calias)->(dbSkip())
						end
						(calias)->(dbCloseArea())
					endif

					if len(aRet) == 0
						cQuery := " SELECT "
						cQuery += " 	SUBSTRING(RCC.RCC_CONTEU, 1, 16) PERIODO   "
						cQuery += " FROM  "
						cQuery += " 	"+RetSqlName('RCC')+" RCC "
						cQuery += " WHERE  "
						cQuery += " 	RCC.D_E_L_E_T_ = ' ' "
						cQuery += " 	AND RCC.RCC_CODIGO = 'U007' "
						cQuery += " 	AND SUBSTRING(RTRIM(RCC.RCC_CONTEU), 17, 1) = '1' "

						//Executa consulta SQL
						if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
							while (cAlias)->(!EoF())
								//Gera versao 0 na PB7
								u_geraVer0(aFunc[1], aFunc[2], (calias)->PERIODO, aFunc[3], aFunc[6])

								aAux := {}
								cId := u_CrypCsPE(.T., aParam[1]+';'+dtos(MsDate())+';'+aFunc[4]+';'+(calias)->PERIODO, cIdLog )
								aAdd(aAux, cId)
								aAdd(aAux, (calias)->PERIODO)
								aAdd(aAux, 0)
								aAdd(aAux, dtoc(stod(left((calias)->PERIODO,8))))
								aAdd(aAux, dtoc(stod(right((calias)->PERIODO,8))))
								aAdd(aAux, aFunc[4])
								aAdd(aAux, 0)
								aAdd(aAux, 0)
								aAdd(aAux, 0)

								aAdd(aAux, 99 )

								aAdd(aAux, aFunc[2])
								aAdd(aAux, aFunc[5])
								aAdd(aAux, aFunc[3])
								aAdd(aAux, POSICIONE('CTT', 1, xFilial('CTT')+aFunc[3], 'CTT_DESC01') )
								aAdd(aAux, "" )

								aAdd(aRet, aAux)

								(cAlias)->( dbSkip() )
							end
							(cAlias)->( dbCloseArea() )
						endif
					endif

					U_json(@cRetorno, aRet, aProp, 'listaPeriodo') //Monta Marcacao
					::jsonListPeriodo := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getListaEquipe
Metodo para montar uma lista de periodos do funcionario para o gestor da area
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod getListaEquipe WSReceive idkey, idPortalParticipante, matResp WSSend jsonListEquipe WSService WsCsPortalRH
	local lExeChange 	:= .T. 				//Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local cQuery 	 	:= "" 				//Consulta SQL
	local calias 	 	:= GetNextalias() 	// alias resevardo para consulta SQL
	local nRec 		 	:= 0 				//Numero Total de Registros da consulta SQL
	local aRet 			:= {}
	local aAux			:= {}
	local cRetorno	    := ""
	local aFunc 		:= {}
	local nPos 			:= 0
	local nTot 			:= 0
	local cDepto 		:= ""
	local aParam     	:= {}
	local aParti	 	:= {}
	local aFuncDepto 	:= {}
	local cIdLog	 	:= ""
	local cId 			:= ""
	local matResp		:= ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""
	default ::matResp := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam  := Descriptog(::idkey)
		aParti  := Descriptog(::idPortalParticipante)
		matResp := ::matResp

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				cQuery := " SELECT  "
				cQuery += " 	SQB.QB_CC,  "
				cQuery += " 	SQB.QB_MATRESP,  "
				cQuery += " 	SRA.RA_FILIAL,  "
				cQuery += " 	SRA.RA_MAT,  "
				cQuery += " 	SRA.RA_NOME,  "
				cQuery += " 	RD0.RD0_CODIGO,  "
				cQuery += " 	MASTER.QB_DEPTO, "
				cQuery += "     ( 	SELECT COUNT(*)  "
				cQuery += "     	FROM  "+RetSQLName("SRA")+"  SRAFUNC "
				cQuery += "    		WHERE  "
				cQuery += "     		SRAFUNC.D_E_L_E_T_ = ' '  "
				cQuery += "     		AND SQB.QB_DEPTO = SRAFUNC.RA_DEPTO ) AS TOT  "
				cQuery += " FROM "
				cQuery += " 	"+RetSQLName("SQB")+" MASTER"
				cQuery += " INNER JOIN  "+RetSQLName("SQB")+"  SQB ON "
				cQuery += " 	SQB.QB_DEPSUP = MASTER.QB_DEPTO "
				cQuery += " 	AND SQB.D_E_L_E_T_ = ' ' "
				cQuery += " INNER JOIN "+RetSQLName("SRA")+" SRA ON "
				cQuery += " 	SRA.RA_MAT = SQB.QB_MATRESP "
				cQuery += " 	AND SRA.D_E_L_E_T_ = ' ' "
				cQuery += " INNER JOIN "+RetSQLName("RDZ")+" RDZ ON "
				cQuery += " 	RDZ.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SRA.RA_FILIAL || SRA.RA_MAT = RDZ.RDZ_CODENT "
				cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
				cQuery += " 	AND SRA.RA_DEMISSA = '' "
				cQuery += " INNER JOIN "+RetSQLName("RD0")+" RD0 ON "
				cQuery += " 	RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 "
				cQuery += " 	AND RD0.D_E_L_E_T_ = ' ' "
				if empty( alltrim( aFunc[1]+aFunc[2] ) )
					cQuery += " WHERE  "
					cQuery += " MASTER.D_E_L_E_T_ = ' ' "
				else
					cQuery += " WHERE  "
					//cQuery += " MASTER.QB_FILRESP = '"+aFunc[1]+"' "
					if empty( matResp )
						cQuery += " MASTER.QB_MATRESP = '"+aFunc[2]+"' "
					else
						cQuery += " MASTER.QB_MATRESP = '"+matResp+"' "
					endif

					cQuery += " AND MASTER.D_E_L_E_T_ = ' ' "
				endif
				cQuery += " ORDER BY SQB.QB_CC, SRA.RA_NOME "

				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					aFuncDepto := {}
					(calias)->(dbGoTop())
					while (calias)->(!eof())
						aAux := {}
						aAdd(aAux, (calias)->RA_FILIAL)  	 //0
						aAdd(aAux, (calias)->RA_MAT) //1
						aAdd(aAux, (calias)->TOT) //1

						aAdd(aFuncDepto, aAux)
						(calias)->(dbSkip())
					end
					(calias)->(dbCloseArea())
				endif

				cQuery := QueryPer(aFuncDepto)
				if !empty(cQuery)
					if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
						(calias)->(dbGoTop())
						while (calias)->(!eof())

							if ( nPos := aScan( aFuncDepto , { |x| x[2] ==  (calias)->RA_MAT } ) ) > 0
								nTot := aFuncDepto[nPos][3]
							else
								nTot := 0
							endif

							aAux  := {}
							aAdd(aAux, (calias)->RA_CIC)
							aAdd(aAux, (calias)->RA_MAT)
							aAdd(aAux, Capital((calias)->RA_NOME))
							aAdd(aAux, dtoc(stod(left((calias)->PB7_PAPONT,8))))
							aAdd(aAux, dtoc(stod(right((calias)->PB7_PAPONT,8))))
							aAdd(aAux, nTot)
							aAdd(aAux, (calias)->RD0_CODIGO)
							aAdd(aAux, (calias)->QTDE)
							aAdd(aAux, (calias)->QTD2)
							aAdd(aAux, (calias)->QTD3)
							aAdd(aAux, (calias)->QTD4)
							if  (calias)->( ABS(QTDE+QTD2+QTD3+QTD4) ) == 0
								aAdd(aAux, 99 )
							else
								aAdd(aAux, (calias)->( QTDE+QTD2 ) )
							endif
							aAdd(aAux, (calias)->PB7_PAPONT)
							cId := u_CrypCsPE(.T., aParam[1]+';'+dtos(MsDate())+';'+(calias)->RD0_CODIGO+';'+(calias)->PB7_PAPONT, cIdLog )
							aAdd( aAux, cId )

							aAdd(aRet, aAux)
							(calias)->(dbSkip())
						end
						(calias)->(dbCloseArea())
					endif
				endif

				cQuery := " SELECT QB_DEPTO FROM "
				cQuery += " "+RetSQLName("SQB")+" SQB "
				cQuery += " WHERE "
				cQuery += " SQB.D_E_L_E_T_ = ' ' "
				//cQuery += " AND SQB.QB_FILRESP = '"+aFunc[1]+"' "
				if empty(matResp)
					cQuery += " AND SQB.QB_MATRESP = '"+aFunc[2]+"' "
				else
					cQuery += " AND SQB.QB_MATRESP = '"+matResp+"' "
				end

				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(calias)->(dbGoTop())
					while (calias)->(!EoF())
						if !empty(cDepto)
							cDepto += "', '"
						endif
						cDepto += ALLTRIM((calias)->QB_DEPTO)
						(calias)->(dbSkip())
					end
					(calias)->(dbCloseArea())
				endif

				if !empty(cDepto )
					cQuery := QueryPer(NIL, cDepto)
					if !empty(cQuery)
						if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
							(calias)->(dbGoTop())
							while (calias)->(!eof())
								if (calias)->RA_MAT != aFunc[2]
									aAux  := {}
									aAdd(aAux, (calias)->RA_CIC)
									aAdd(aAux, (calias)->RA_MAT)
									aAdd(aAux, Capital((calias)->RA_NOME))
									aAdd(aAux, dtoc(stod(left((calias)->PB7_PAPONT,8))))
									aAdd(aAux, dtoc(stod(right((calias)->PB7_PAPONT,8))))
									aAdd(aAux, 0)
									aAdd(aAux, (calias)->RD0_CODIGO)
									aAdd(aAux, (calias)->QTDE)
									aAdd(aAux, (calias)->QTD2)
									aAdd(aAux, (calias)->QTD3)
									aAdd(aAux, (calias)->QTD4)
									if  (calias)->( ABS(QTDE+QTD2+QTD3+QTD4) ) == 0
										aAdd(aAux, 99 )
									else
										aAdd(aAux, (calias)->( QTDE+QTD2 ) )
									endif
									aAdd(aAux, (calias)->PB7_PAPONT)
									cId := u_CrypCsPE(.T., aParam[1]+';'+dtos(MsDate())+';'+(calias)->RD0_CODIGO+';'+(calias)->PB7_PAPONT, cIdLog )
									aAdd( aAux, cId )

									aAdd(aRet, aAux)
								endif
								(calias)->(dbSkip())
							end
							(calias)->(dbCloseArea())
						endif
					endif
				endif

				if len(aRet) > 0
					U_json(@cRetorno, aRet, {'centroCusto', 'matricula', 'nome', 'dataini', 'datafim', 'total', 'idParticipant', 'qtde', 'qtd2', 'qtd3', 'qtd4', 'qtdt', 'periodo', 'id' }, 'listaEquipe') //Monta Marcacao
					::jsonListEquipe := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} setMarcacaoInicial
Metodo para voltar a marcações e apontamentos para os valores originais
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param dia - Dia que para retornar marcacocao inicial
@Param ponmes - Periodo de apontamento
@Param ordemDia - Ordem -> campo numerico ao qual define o grupo de datas pertencentes ao dia de marcacao inicial
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod setMarcacaoInicial WSReceive idkey, idPortalParticipante, dia, ponmes, ordemDia WSSend jsonMarcacao WSService WsCsPortalRH
	local cMarcacao	:= ""
	local aRet 		:= {}
	local aPropMarc := {}
	local cIdLog	:= ""

	default ::idkey 	    	   := ""
	default ::idPortalParticipante := ""
	default ::dia				   := ""
	default ::ponmes			   := ""
	default ::ordemDia			   := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::dia) .And. !Empty(::ponmes) .And. !Empty(::ordemDia)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			aFunc  := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				aPropMarc := loadPropMa()
				aRet      := U_CSRH015(aFunc[1], aFunc[2], dia, ::ponmes, ordemDia, cIdLog)
				if Len(aRet) > 0
					U_json(@cMarcacao, aRet, aPropMarc, 'marcacao') //Monta Marcacao
					::jsonMarcacao := cMarcacao
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} QueryPer
Funcao que monta uma string com conteudo SQL de periodo
@Param aLista - Array com filiais
@Param cDepto - Departamento do funcionario
@Return String de uma query SQL
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function QueryPer(aLista, cDepto)
	local cQuery  := ''
	local nLinha  := ''
	local cMats   := ''
	local cFils   := ''
	local cQDepto := ''
	local lCont   := .F.
	local dLimite := u_ponDLimL()

	default aLista := {}
	default cDepto := ''

	if len(aLista) > 0 .or. !empty(cDepto)
		if len(aLista) > 0
			cFils += "AND PB7_FILIAL IN ("
			for nLinha := 1 to len(aLista)
				iif (nLinha != 1, cFils += ", ", nil)
				if !empty(aLista[nLinha][1])
					cFils += "'"+aLista[nLinha][1]+"'"
					lCont := .T.
				endif
			next nLinha
			cFils += ")"
			if !lCont
				cFils := ''
			endif
			lCont := .F.

			cMats += " AND PB7_MAT IN ("
			for nLinha := 1 to len(aLista)
				iif (nLinha != 1, cMats += ", ", nil)
				if !empty(aLista[nLinha][2])
					cMats += "'"+aLista[nLinha][2]+"'"
					lCont := .T.
				endif
			next nLinha
			cMats += ")"
			if !lCont
				cMats := ''
			endif
			lCont := .F.
		endif

		if !empty(cDepto)
			cQDepto := " AND RA_DEPTO IN ('" +cDepto +"')"
		endif

		cQuery := " SELECT * FROM "
		cQuery += ' (  '
		cQuery += '     SELECT '
		cQuery += '     PB7FIL.PB7_FILIAL, '
		cQuery += '     PB7FIL.PB7_MAT,  '
		cQuery += '     PB7FIL.PB7_PAPONT, '
		cQuery += '     RD0.RD0_CODIGO,   '
		cQuery += '     SRA.RA_CIC,  '
		cQuery += '     SRA.RA_MAT, '
		cQuery += '     SRA.RA_NOME, '
		cQuery += '     SRA.RA_CC, '
		cQuery += '     COUNT(PB7.PB7_MAT) AS "QTDE", '
		cQuery += '     COUNT(PB72.PB7_MAT) AS "QTD2", '
		cQuery += '     COUNT(PB73.PB7_MAT) AS "QTD3", '
		cQuery += '     COUNT(PB74.PB7_MAT) AS "QTD4", '
		cQuery += '     COUNT(PB7TOT.PB7_MAT) AS "QTDT" '
		cQuery += " FROM "
		cQuery += "  "+RetSQLName("SRA")+" SRA,"
		cQuery += "  "+RetSQLName("RDZ")+" RDZ,"
		cQuery += "  "+RetSQLName("RD0")+" RD0,"
		cQuery += "  ( "
		cQuery += "     SELECT   "
		cQuery += "           PB7_FILIAL "
		cQuery += "           , PB7_MAT  "
		cQuery += "           , PB7_DATA  "
		cQuery += "           , MAX(PB7_VERSAO) VERSAO  "
		cQuery += "           , PB7_PAPONT "
		cQuery += "     FROM   "
		cQuery += "           "+RetSQLName("PB7")+" PB7,"
		cQuery += "           "+RetSQLName("SRA")+" SRA,"
		cQuery += "           "+RetSQLName("RCC")+" RCC"
		cQuery += "     WHERE    "
		cQuery += "           SRA.D_E_L_E_T_     = ' '  "
		cQuery += "           AND PB7.D_E_L_E_T_ = ' '  "
		cQuery += "           AND RCC.D_E_L_E_T_ = ' '  "
		cQuery += "           AND PB7.PB7_MAT    = SRA.RA_MAT   "
		cQuery += "           AND PB7.PB7_FILIAL = SRA.RA_FILIAL   "
		cQuery += "           AND PB7.PB7_DATA  <= '" + dToS( dLimite ) + "'"
		cQuery += "           AND PB7.PB7_PAPONT = SUBSTRING(RTRIM(RCC.RCC_CONTEU), 1, 16)   "
		cQuery += "           AND RCC_CODIGO     = 'U007' "
		cQuery += "           AND SUBSTRING(RTRIM(RCC.RCC_CONTEU), 17, 1) = '1'   "
		cQuery += "           "+cFils
		cQuery += "           "+cMats
		cQuery += "           "+cQDepto
		cQuery += "       GROUP BY  "
		cQuery += "           PB7_FILIAL  "
		cQuery += "           , PB7_MAT  "
		cQuery += "           , PB7_DATA  "
		cQuery += "           , PB7_PAPONT "
		cQuery += " ) PB7FIL "
		cQuery += " LEFT JOIN "+ RetSQLName("PB7")+" PB7 ON   "
		cQuery += "       PB7.PB7_STATUS = '1'  "
		cQuery += "       AND PB7.D_E_L_E_T_    = ' '  "
		cQuery += "       AND PB7FIL.PB7_FILIAL = PB7.PB7_FILIAL "
		cQuery += "       AND PB7FIL.PB7_MAT    = PB7.PB7_MAT "
		cQuery += "       AND PB7FIL.PB7_DATA   = PB7.PB7_DATA "
		cQuery += "       AND PB7FIL.VERSAO     = PB7.PB7_VERSAO "
		cQuery += " LEFT JOIN  "+RetSQLName("PB7")+" PB72 ON   "
		cQuery += "       PB72.PB7_STATUS = '2'  "
		cQuery += "       AND PB72.D_E_L_E_T_   = ' '  "
		cQuery += "       AND PB7FIL.PB7_FILIAL = PB72.PB7_FILIAL "
		cQuery += "       AND PB7FIL.PB7_MAT    = PB72.PB7_MAT "
		cQuery += "       AND PB7FIL.PB7_DATA   = PB72.PB7_DATA "
		cQuery += "       AND PB7FIL.VERSAO     = PB72.PB7_VERSAO "
		cQuery += " LEFT JOIN  "+RetSQLName("PB7")+" PB73 ON   "
		cQuery += "       PB73.PB7_STATUS = '7'  "
		cQuery += "       AND PB73.D_E_L_E_T_   = ' '  "
		cQuery += "       AND PB7FIL.PB7_FILIAL = PB73.PB7_FILIAL "
		cQuery += "       AND PB7FIL.PB7_MAT    = PB73.PB7_MAT "
		cQuery += "       AND PB7FIL.PB7_DATA   = PB73.PB7_DATA "
		cQuery += "       AND PB7FIL.VERSAO     = PB73.PB7_VERSAO "
		cQuery += " LEFT JOIN  "+RetSQLName("PB7")+" PB74 ON   "
		cQuery += "       PB74.PB7_STATUS = '8'  "
		cQuery += "       AND PB74.D_E_L_E_T_   = ' '  "
		cQuery += "       AND PB7FIL.PB7_FILIAL = PB74.PB7_FILIAL "
		cQuery += "       AND PB7FIL.PB7_MAT    = PB74.PB7_MAT "
		cQuery += "       AND PB7FIL.PB7_DATA   = PB74.PB7_DATA "
		cQuery += "       AND PB7FIL.VERSAO     = PB74.PB7_VERSAO "
		cQuery += " LEFT JOIN  "+RetSQLName("PB7")+" PB7TOT ON   "
		cQuery += "       PB7TOT.PB7_STATUS <> '0' "
		cQuery += "       AND PB7TOT.D_E_L_E_T_   = ' '  "
		cQuery += "       AND PB7FIL.PB7_FILIAL = PB7TOT.PB7_FILIAL "
		cQuery += "       AND PB7FIL.PB7_MAT    = PB7TOT.PB7_MAT "
		cQuery += "       AND PB7FIL.PB7_DATA   = PB7TOT.PB7_DATA "
		cQuery += "       AND PB7FIL.VERSAO     = PB7TOT.PB7_VERSAO "
		cQuery += " WHERE  "
		cQuery += "       RD0.D_E_L_E_T_ = ' '  "
		cQuery += "       AND RDZ.D_E_L_E_T_ = ' '  "
		cQuery += "       AND SRA.D_E_L_E_T_ = ' '  "
		cQuery += "       AND PB7FIL.PB7_MAT = SRA.RA_MAT   "
		cQuery += "       AND PB7FIL.PB7_FILIAL = SRA.RA_FILIAL   "
		cQuery += "       AND RD0.RD0_MSBLQL = '2' "
		cQuery += "       AND RD0.RD0_CODIGO = RDZ.RDZ_CODRD0   "
		cQuery += "       AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT   "
		cQuery += " 	  AND RDZ.RDZ_ENTIDA = 'SRA' "
		cQuery += "       "+cQDepto
		cQuery += " GROUP BY  "
		cQuery += "       PB7FIL.PB7_FILIAL, "
		cQuery += "       PB7FIL.PB7_MAT,  "
		cQuery += "       PB7FIL.PB7_PAPONT, "
		cQuery += "       RD0.RD0_CODIGO, "
		cQuery += "       SRA.RA_CIC,  "
		cQuery += "       SRA.RA_MAT, "
		cQuery += "       SRA.RA_NOME, "
		cQuery += "       SRA.RA_CC "
		cQuery += " ) TAB "
		cQuery += " ORDER BY 2, 3 "
	endif
Return(cQuery)

/*
{Protheus.doc} getPortal
Metodo que indica se o portal foi liberado e se deve abrir o novo ou antigo
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WsMethod getPortal WsReceive idkey, idPortalParticipante WsSEnd jsonPortal WsService WsCsPortalRH
	local cQuery 	 := "" //Consulta SQL
	local calias 	 := GetNextalias() // alias resevardo para consulta SQL
	local nRec 		 := 0 //Numero Total de Registros da consulta SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local cJson      := ""
	local cMV_PORTAL := "MV_CSRH001"
	local aParam     := {}
	local aParti     := {}
	local cIdLog	 := ""

	default ::idkey 	    	   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			if .NOT. GetMv( cMV_PORTAL, .T. )
				CriarSX6( cMV_PORTAL, 'C', 'CAMPO COM CC QUE DEVEM FAZER PARTE DO NOVO PORTAL. SE VAZIO SEMPRE CONSIDERA O NOVO', '060211' )
			endif
			cMV_PORTAL := GetMv( cMV_PORTAL, .F. )

			//Monta qurey do participantes
			cQuery := " SELECT SRA.RA_CC"
			cQuery += " FROM "
			cQuery += " 	"+RetSqlName("RD0")+" RD0, "
			cQuery += " 	"+RetSqlName("RDZ")+" RDZ, "
			cQuery += " 	"+RetSqlName("SRA")+" SRA  "
			cQuery += " WHERE RD0.RD0_CODIGO = '"+aParam[1]+"' "
			cQuery += " 	AND SRA.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND RD0.D_E_L_E_T_ = ' '"
			cQuery += " 	AND RDZ.D_E_L_E_T_ = ' '"
			cQuery += " 	AND RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 "
			cQuery += " 	AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT "
			cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
			cQuery += " 	AND SRA.RA_SITFOLH <> 'D' "

			//Executa consultar
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(calias)->(dbGoTop())

				if !empty(alltrim(cMV_PORTAL))
					if cMV_PORTAL $ (calias)->(RA_CC)
						//Montar json
						U_json(@cJson, {'1'}, {'portal'}, 'portal')
					else
						U_json(@cJson, {'0'}, {'portal'}, 'portal')
					endif
				else
					U_json(@cJson, {'1'}, {'portal'}, 'portal')
				endif
				::jsonPortal := cJson
				(calias)->(dbCloseArea())
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getDetalheNeg
Metodo que lista os apontamentos negativos do funcionario
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param dia - Data de consulta dos apontamentos
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod getDetalheNeg WSReceive idkey, idPortalParticipante, dia WSSend jsonEveNeg WSService WsCsPortalRH
	local aAux 		 := {}
	local aEvento	 := {}
	local aProp      := {'PC_PD', 'P9_DESC', 'PC_QUANTC', 'PC_QTABONO', 'DESC_NEG', 'DIFERENCA', 'DESC_POS', 'PREABONO' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""
	local lAprovado  := .F.
	local dLimite    := u_ponDLimL()

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""
	default ::dia 	 			   := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::dia)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 4)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				//Marcacao não aprovada
				//Monta SQL
				cQuery := " SELECT  "
				cQuery += " 	SPC.PC_FILIAL,  "
				cQuery += " 	SPC.PC_MAT,  "
				cQuery += " 	SPC.PC_PD,  "
				cQuery += " 	SP9.P9_DESC, "
				cQuery += " 	SPC.PC_QUANTC, "
				cQuery += " 	SPC.PC_ABONO, "
				cQuery += " 	SPC.PC_QTABONO, "
				cQuery += ' 	NEG.P6_DESC DESC_NEG, '
				cQuery += " 	SPC.PC_PDI, "
				cQuery += ' 	POS.P9_DESC DESC_POS, '
				cQuery += " 	coalesce(NEG.P6_PORTAL, 'A') P6_PORTAL"
				cQuery += " FROM  "
				cQuery += " 	"+RetSqlName('SP9')+" SP9, "
				cQuery += " 	"+RetSqlName('SPC')+" SPC "
				cQuery += " LEFT JOIN "+RetSqlName('SP9')+" POS ON "
				cQuery += " 	POS.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_PDI = POS.P9_CODIGO "
				cQuery += " LEFT JOIN "+RetSqlName('SP6')+" NEG ON "
				cQuery += " 	NEG.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_ABONO = NEG.P6_CODIGO "
				cQuery += " WHERE "
				cQuery += " 	SPC.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SP9.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_PD = SP9.P9_CODIGO "
				cQuery += " 	AND  SP9.P9_CLASEV IN ('02', '03', '04', '05') "
				cQuery += " 	AND SPC.PC_FILIAL = '" + aFunc[1] + "'"
				cQuery += " 	AND SPC.PC_MAT    = '" + aFunc[2] + "'"
				cQuery += " 	AND SPC.PC_DATA   = '" + DTOS( CTOD( dia ) ) + "'"
				cQuery += " 	AND SPC.PC_DATA   <= '" + dToS( dLimite ) + "'"

				lAprovado := u_MaNgAprv(aFunc[1], aFunc[2], CTOD(dia))

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
					//Procura por funcionario que esteja ativo
					While (cAlias)->(!EOF())
						aAux := {}
						aAdd(aAux, (cAlias)->PC_PD)
						aAdd(aAux, Capital((cAlias)->P9_DESC))
						aAdd(aAux, replace(STRZERO((cAlias)->(PC_QUANTC), 5, 2), '.', ':') )
						if lAprovado
							aAdd(aAux, replace(STRZERO((cAlias)->(PC_QUANTC), 5, 2), '.', ':') )
							aAdd(aAux, Capital((cAlias)->DESC_NEG))
							aAdd(aAux, replace(STRZERO(0, 5, 2), '.', ':') )
							aAdd(aAux, Capital((cAlias)->DESC_POS) )
						else
							aAdd(aAux, replace(STRZERO((cAlias)->(PC_QTABONO), 5, 2), '.', ':') )
							aAdd(aAux, Capital((cAlias)->DESC_NEG))
							aAdd(aAux, replace(STRZERO(__TimeSub((cAlias)->PC_QUANTC, (cAlias)->PC_QTABONO ) , 5, 2), '.', ':') )
							aAdd(aAux, Capital((cAlias)->DESC_POS) )
						endif

						if (cAlias)->P6_PORTAL == '2' .or. (cAlias)->P6_PORTAL == 'A'
							aAdd(aAux, 'Não')
						else
							aAdd(aAux, 'Sim')
						endif

						aAdd(aEvento, aAux)
						(cAlias)->(DbSkip())
					EndDo
					(cAlias)->(dbCloseArea())

					U_json(@cRetorno, aEvento, aProp, 'listaEventoDetalhado') //Monta Marcacao
					::jsonEveNeg := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getDetalhePos
Funcao que lista os apontamentos Positivos do funcionario
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param dia - Data de consulta dos apontamentos
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod getDetalhePos WSReceive idkey, idPortalParticipante, dia WSSend jsonEvePos WSService WsCsPortalRH
	local aAux 		 := {}
	local aEvento	 := {}
	local aProp      := {'PC_PD', 'P9_DESC', 'PC_QUANTC', 'PC_ABONO', 'DESC_NEG', 'PC_PDI', 'DESC_POS', 'PREABONO' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""
	local dLimite     := u_ponDLimL()

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""
	default ::dia 	 			   := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::dia)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 4)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0

				//Monta SQL
				cQuery := " SELECT  "
				cQuery += " 	SPC.PC_FILIAL,  "
				cQuery += " 	SPC.PC_MAT,  "
				cQuery += " 	SPC.PC_PD,  "
				cQuery += " 	SP9.P9_DESC, "
				cQuery += " 	SPC.PC_QUANTC, "
				cQuery += " 	SPC.PC_ABONO, "
				cQuery += ' 	NEG.P6_DESC DESC_NEG, '
				cQuery += " 	SPC.PC_PDI, "
				cQuery += ' 	POS.P9_DESC DESC_POS, '
				cQuery += " 	SPC.PC_QUANTI "
				cQuery += " FROM  "
				cQuery += " 	"+RetSqlName('SP9')+" SP9, "
				cQuery += " 	"+RetSqlName('SPC')+" SPC "
				cQuery += " LEFT JOIN "+RetSqlName('SP9')+" POS ON "
				cQuery += " 	POS.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_PDI = POS.P9_CODIGO "
				cQuery += " LEFT JOIN "+RetSqlName('SP6')+" NEG ON "
				cQuery += " 	NEG.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_ABONO = NEG.P6_CODIGO "
				cQuery += " WHERE "
				cQuery += " 	SPC.D_E_L_E_T_      = ' ' "
				cQuery += " 	AND SP9.D_E_L_E_T_  = ' ' "
				cQuery += " 	AND SPC.PC_PD       = SP9.P9_CODIGO "
				cQuery += " 	AND SP9.P9_TIPOCOD  = '1'"
				cQuery += " 	AND SP9.P9_CLASEV  IN ('01','ZZ' ) "
				cQuery += " 	AND SPC.PC_FILIAL 	= '"+aFunc[1]+"'"
				cQuery += " 	AND SPC.PC_MAT 		= '"+aFunc[2]+"'"
				cQuery += " 	AND SPC.PC_DATA 	= '"+DTOS(CTOD(dia))+"'"
				cQuery += " 	AND SPC.PC_DATA    <= '"+dToS( dLimite )+"'"

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
					//Procura por funcionario que esteja ativo
					While (cAlias)->(!EOF())
						aAux := {}
						aAdd(aAux, (cAlias)->PC_PD)
						if empty((cAlias)->PC_PDI)
							aAdd(aAux, (cAlias)->P9_DESC)
							aAdd(aAux, replace(STRZERO((cAlias)->PC_QUANTC, 5, 2), '.', ':') )
							aAdd(aAux, (cAlias)->PC_ABONO)
							aAdd(aAux, (cAlias)->DESC_NEG)
						else
							aAdd(aAux, (cAlias)->DESC_POS)
							aAdd(aAux, replace(STRZERO((cAlias)->PC_QUANTI, 5, 2), '.', ':') )
							aAdd(aAux, (cAlias)->PC_ABONO)
							aAdd(aAux, (cAlias)->DESC_NEG)
						endif
						aAdd(aAux, (cAlias)->PC_PDI)
						aAdd(aAux, (cAlias)->DESC_POS)
						aAdd(aAux, 'N&atilde;o')
						aAdd(aEvento, aAux)
						(cAlias)->(DbSkip())
					EndDo
					(cAlias)->(dbCloseArea())

					U_json(@cRetorno, aEvento, aProp, 'listaEventoDetalhado') //Monta Marcacao
					::jsonEvePos := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} Descriptog
Funcao que desfaz a criptografia
@Param cId - String criptografada
@Return String descriptografada
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function Descriptog(cId)
Return StrTokArr( u_CrypCsPE(.F., cId ), ';' )

/*
{Protheus.doc} ValidKey
Funcao que valida chave recebido pelo web service
@Param aParamA - Array com conteudo de comparacao
@Param aParamB - Array com conteudo de comparacao
@Param nChkCampo - Qual posicao do array verificar se existe
@Return Booleana - .T. Array validado, .F. Array invalido
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function ValidKey(aParamA, aParamB, nChkCampo)
	local lRetorno := .T.

	default aParamA   := {}
	default aParamB   := {}
	default nChkCampo := 0

	if len(aParamA) > 0 .or.  len(aParamB) > 0
		if len(aParamA) > nChkCampo-1
			if !empty(aParamA[nChkCampo])
				if !empty(aParamA[1]) .and. !empty(aParamB[1])
					if aParamA[1] != aParamB[1]
						lRetorno := .F.
					endif
				else
					lRetorno := .F.
				endif
			else
				lRetorno := .F.
			endif
		else
			lRetorno := .F.
		endif
	else
		lRetorno := .F.
	endif
Return(lRetorno)

/*
{Protheus.doc} RetFuncSRA
Retorna json com dados de funcionario do participante logando.
@Param aParamA - Array com conteudo de comparacao
@Param aParamB - Array com conteudo de comparacao
@Param nChkCampo - Qual posicao do array verificar se existe
@Return Booleana - .T. Array validado, .F. Array invalido
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function RetFuncSRA(idPart)
	local cQuery  	 := "" //Query SQL
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local nRec 		 := 0 //Numero Total de Registros da consulta SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local aRetorno 	 := {}

	default idPart 	 := ""

	if !empty(idPart)
		//Monta SQL
		cQuery := " SELECT "
		cQuery += " 	RA_FILIAL, "
		cQuery += " 	RA_MAT, "
		cQuery += " 	RA_CC, "
		cQuery += " 	RD0_CODIGO, "
		cQuery += " 	RA_NOME, "
		cQuery += " 	RD0_GRPAPV, "
		cQuery += " 	RA_REGRA "
		cQuery += " FROM "
		cQuery += " 	"+RetSqlName("RD0")+" RD0,"
		cQuery += " 	"+RetSqlName("RDZ")+" RDZ,"
		cQuery += " 	"+RetSqlName("SRA")+" SRA "
		cQuery += " WHERE "
		cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND RDZ.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND RD0.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND SRA.RA_FILIAL || SRA.RA_MAT = RDZ_CODENT "
		cQuery += " 	AND SRA.RA_DEMISSA = '' "
		cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
		cQuery += " 	AND RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 "
		cQuery += " 	AND RD0.RD0_CODIGO = '"+idPart+"' "

		//Executa consulta SQL
		if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
			aAdd( aRetorno, (cAlias)->RA_FILIAL  )
			aAdd( aRetorno, (cAlias)->RA_MAT	 )
			aAdd( aRetorno, (cAlias)->RA_CC	 	 )
			aAdd( aRetorno, (cAlias)->RD0_CODIGO )
			aAdd( aRetorno, (cAlias)->RA_NOME	 )
			aAdd( aRetorno, (cAlias)->RD0_GRPAPV )
			aAdd( aRetorno, (cAlias)->RA_REGRA )
			(cAlias)->(dbCloseArea())
		endif
	endif
Return(aRetorno)

/*
{Protheus.doc} loadPropMa
Funcao que monta em array, nomes de campos do cabecalho do json
@Return array - lista de string com nome do cabecalho de marcacao do json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function loadPropMa()
	local aPropMarc := {}

	aAdd(aPropMarc, 'id'					)//01
	aAdd(aPropMarc, 'filial'				)//02
	aAdd(aPropMarc, 'matricula'				)//03
	aAdd(aPropMarc, 'data'					)//04
	aAdd(aPropMarc, '1E'					)//05
	aAdd(aPropMarc, '1S'					)//06
	aAdd(aPropMarc, '2E'					)//07
	aAdd(aPropMarc, '2S'					)//08
	aAdd(aPropMarc, '3E'					)//09
	aAdd(aPropMarc, '3S'					)//10
	aAdd(aPropMarc, '4E'					)//11
	aAdd(aPropMarc, '4S'					)//12
	aAdd(aPropMarc, 'horaPosValor'			)//13
	aAdd(aPropMarc, 'horaPosEvento'			)//14
	aAdd(aPropMarc, 'horaPosJustificativa'	)//15
	aAdd(aPropMarc, 'horaNegValor'			)//16
	aAdd(aPropMarc, 'horaNegEvento'			)//17
	aAdd(aPropMarc, 'horaNegJustificativa'	)//18
	aAdd(aPropMarc, 'versao'				)//19
	aAdd(aPropMarc, 'status'				)//20
	aAdd(aPropMarc, 'calend1EHr'			)//21
	aAdd(aPropMarc, 'calend1ETp'			)//22
	aAdd(aPropMarc, 'calend1SHr'			)//23
	aAdd(aPropMarc, 'calend1STp'			)//24
	aAdd(aPropMarc, 'calend2EHr'			)//25
	aAdd(aPropMarc, 'calend2ETp'			)//26
	aAdd(aPropMarc, 'calend2SHr'			)//27
	aAdd(aPropMarc, 'calend2STp'			)//28
	aAdd(aPropMarc, 'calend3EHr'			)//29
	aAdd(aPropMarc, 'calend3ETp'			)//30
	aAdd(aPropMarc, 'calend3SHr'			)//31
	aAdd(aPropMarc, 'calend3STp'			)//32
	aAdd(aPropMarc, 'calend4EHr'			)//33
	aAdd(aPropMarc, 'calend4ETp'			)//34
	aAdd(aPropMarc, 'calend4SHr'			)//35
	aAdd(aPropMarc, 'calend4STp'			)//36
	aAdd(aPropMarc, 'dataext' 				)//37
	aAdd(aPropMarc, 'ordem'					)//38
	aAdd(aPropMarc, 'aponta'				)//39
	aAdd(aPropMarc, 'peraponta'				)//40
	aAdd(aPropMarc, 'turno'					)//41
	aAdd(aPropMarc, 'justificativaMarcacao'	)//42
	aAdd(aPropMarc, 'M1E'					)//43
	aAdd(aPropMarc, 'M1S'					)//44
	aAdd(aPropMarc, 'M2E'					)//45
	aAdd(aPropMarc, 'M2S'					)//46
	aAdd(aPropMarc, 'M3E'					)//47
	aAdd(aPropMarc, 'M3S'					)//48
	aAdd(aPropMarc, 'M4E'					)//49
	aAdd(aPropMarc, 'M4S'					)//50
	aAdd(aPropMarc, 'DESCEVEPOS'			)//51
	aAdd(aPropMarc, 'DESCEVENEG'			)//52
	aAdd(aPropMarc, 'AFASTAMENTO'			)//53
	aAdd(aPropMarc, 'T1E'					)//54
	aAdd(aPropMarc, 'T1S'					)//55
	aAdd(aPropMarc, 'T2E'					)//56
	aAdd(aPropMarc, 'T2S'					)//57
	aAdd(aPropMarc, 'T3E'					)//58
	aAdd(aPropMarc, 'T3S'					)//59
	aAdd(aPropMarc, 'T4E'					)//60
	aAdd(aPropMarc, 'T4S'					)//61
	aAdd(aPropMarc, 'statusAtraso'			)//62
	aAdd(aPropMarc, 'statusHE'				)//63
Return aPropMarc

/*
{Protheus.doc} getGrupoAprovadores
Monta lista de aprovações
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return string - lista de aprovadores em json
*/
WSMethod getGrupoAprovadores WSReceive idkey, idPortalParticipante WSSend jsonGrupoAprovadores WSService WsCsPortalRH
	local aAux 		 := {}
	local aLinha	 := {}
	local aProp      := {'codGrupo', 'codAprovador', 'nomeAprovador', 'ccAprovador', 'descGrupo', 'nivel', 'dataIni', 'datafim', 'recesso', 'tipo', 'codSubstituto', 'nomeSubstituto' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""

	default ::idkey 	 := ''
	default ::idPortalParticipante := ''

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			//Monta SQL
			cQuery += " SELECT  "
			cQuery += " 	PBA.PBA_COD, "
			cQuery += " 	RD0.RD0_CODIGO, "
			cQuery += " 	RD0.RD0_NOME, "
			//cQuery += " 	PBA.PBA_CC, "
			cQuery += " 	PBA.PBA_DESC, "
			cQuery += " 	PBD.PBD_NIVEL, "
			cQuery += " 	PB9.PB9_DTAUI, "
			cQuery += " 	PB9.PB9_DTAUF, "
			cQuery += " 	PB9.PB9_RECES, "
			cQuery += " 	PB9.PB9_TIPO, "
			cQuery += " 	PB9.PB9_SUBAU, "
			cQuery += " 	SUBS.RD0_NOME SUBSTITUTO "
			cQuery += " FROM  "
			cQuery += " ( "
			cQuery += " 	SELECT PBD.PBD_GRUPO "
			cQuery += " 	FROM "+RetSqlName('PBD')+" PBD "
			cQuery += " 	WHERE "
			cQuery += " 		PBD.PBD_APROV = '"+aParam[1]+"' "
			cQuery += " 		AND PBD.D_E_L_E_T_ = ' ' "
			cQuery += " ) GRUPO, "
			cQuery += " 	"+RetSqlName('RD0')+" RD0, "
			cQuery += " 	"+RetSqlName('PBA')+" PBA, "
			cQuery += " 	"+RetSqlName('PBD')+" PBD, "
			cQuery += " 	"+RetSqlName('PB9')+" PB9 "
			cQuery += " LEFT JOIN "+RetSqlName('RD0')+" SUBS ON "
			cQuery += " 	SUBS.RD0_CODIGO = PB9.PB9_SUBAU "
			cQuery += " 	AND SUBS.D_E_L_E_T_ = ' ' "
			cQuery += " WHERE  "
			cQuery += " 	RD0.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PB9.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBA.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBD.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PB9.PB9_COD = RD0.RD0_CODIGO "
			cQuery += " 	AND PBD.PBD_APROV = PB9.PB9_COD "
			cQuery += " 	AND PBD.PBD_GRUPO = GRUPO.PBD_GRUPO "
			cQuery += " 	AND PBA.PBA_COD = GRUPO.PBD_GRUPO  "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				//Procura por funcionario que esteja ativo
				While (cAlias)->(!EOF())
					aAux := {}
					aAdd(aAux, (cAlias)->PBA_COD 	)
					aAdd(aAux, (cAlias)->RD0_CODIGO	)
					aAdd(aAux, Capital( (cAlias)->RD0_NOME	) )
					aAdd(aAux, ""		) //PBA->CC
					aAdd(aAux, Capital( (cAlias)->PBA_DESC	) )
					aAdd(aAux, (cAlias)->PBD_NIVEL	)
					aAdd(aAux, StoD((cAlias)->PB9_DTAUI)	)
					aAdd(aAux, StoD((cAlias)->PB9_DTAUF)	)
					aAdd(aAux, iif( (cAlias)->PB9_RECES == '1', 'Sim', 'Não' ) )
					if (cAlias)->PB9_TIPO == '1'
						aAdd(aAux, 'Somente atrasos e Sa&iacute;da Antecipada' )
					elseif (cAlias)->PB9_TIPO == '2'
						aAdd(aAux, 'Somente hora extra' )
					elseif (cAlias)->PB9_TIPO == '3'
						aAdd(aAux, 'Atrasos e hora extra' )
					else
						aAdd(aAux, ' ' )
					endif
					aAdd(aAux, (cAlias)->PB9_SUBAU	)
					aAdd(aAux, Capital( (cAlias)->SUBSTITUTO ) )
					aAdd(aLinha, aAux)
					(cAlias)->(DbSkip())
				EndDo
				(cAlias)->(dbCloseArea())

				U_json(@cRetorno, aLinha, aProp, 'listaGrupoAprovadores') //Monta Marcacao
				::jsonGrupoAprovadores := cRetorno
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getAprovacaoPendente
Monta Json com lista do colaboradores que estao subordinados ao participante logado.
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getAprovacaoPendente WSReceive idkey, idPortalParticipante  WSSend jsonListaAprovPenden WSService WsCsPortalRH
	local aAux 		 := {}
	local aLinha	 := {}
	local aProp      := { 'filial', 'matricula', 'nome', 'idParticipante', 'periodoApontamento', 'codGrupo', 'descGrupo', 'periodo', 'codTipo', 'tipo', 'id', 'aprovador', 'aprovadorNome' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""
	local cId 		 := ""
	local cPar       := ""
	local dLimite    := u_ponDLimL()

	default ::idkey 	 			:= ""
	default ::idPortalParticipante  := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			cQuery := " SELECT PB9.PB9_COD FROM "
			cQuery += " 	"+RetSqlName('PB9')+" PB9 "
			cQuery += " WHERE "
			cQuery += " 	PB9_SUBAU =  '"+aParam[1]+"'"
			cQuery += " 	AND '"+DTOS(msDate())+"' BETWEEN PB9_DTAUI AND PB9_DTAUF "
			cQuery += " 	AND PB9_RECES = '1' "

			cPar := "'"+aParam[1]+"'"

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				//Procura por funcionario que esteja ativo
				While (cAlias)->(!EOF())
					if !Empty(cPar)
						cPar += ","
					endif
					cPar += "'"+(cAlias)->PB9_COD+"'"
					(cAlias)->(DbSkip())
				EndDo
				(cAlias)->(dbCloseArea())
			endif

			//Monta SQL
			cQuery := " SELECT "
			cQuery += " 	SRA.RA_FILIAL, "
			cQuery += " 	SRA.RA_MAT, "
			cQuery += " 	SRA.RA_NOME, "
			cQuery += " 	RD0.RD0_CODIGO, "
			cQuery += " 	PB7.PB7_PAPONT, "
			cQuery += " 	PBA.PBA_COD, "
			cQuery += " 	PBA.PBA_DESC, "
			cQuery += " 	PB9.PB9_TIPO, "
			cQuery += " 	PBB.PBB_APROV "
			cQuery += " FROM  "
			cQuery += " 	"+RetSqlName('PBB')+" PBB, "
			cQuery += " 	"+RetSqlName('RD0')+" RD0, "
			cQuery += " 	"+RetSqlName('RDZ')+" RDZ, "
			cQuery += " 	"+RetSqlName('SRA')+" SRA, "
			cQuery += " 	"+RetSqlName('PB7')+" PB7, "
			cQuery += " 	"+RetSqlName('PBA')+" PBA, "
			cQuery += " 	"+RetSqlName('PBD')+" PBD, "
			cQuery += " 	"+RetSqlName('PB9')+" PB9 "
			cQuery += " WHERE  "
			cQuery += " 	PBB.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND RD0.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND RDZ.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND SRA.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PB7.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBA.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PB9.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBD.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBB.PBB_APROV IN("+cPar+") "
			cQuery += " 	AND PBB.PBB_STATUS = '1' "
			cQuery += " 	AND RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 "
			cQuery += " 	AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT "
			cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA'"
			cQuery += " 	AND RD0.RD0_MSBLQL <> '1'  "
			cQuery += " 	AND PB7.PB7_FILIAL = PBB.PBB_FILMAT "
			cQuery += " 	AND PB7.PB7_MAT = PBB.PBB_MAT "
			cQuery += " 	AND PB7.PB7_DATA = PBB.PBB_DTAPON "
			cQuery += " 	AND SRA.RA_FILIAL = PBB.PBB_FILMAT "
			cQuery += " 	AND SRA.RA_MAT = PBB.PBB_MAT "
			cQuery += " 	AND PBD.PBD_GRUPO = PBB.PBB_GRUPO "
			cQuery += " 	AND PBD.PBD_APROV = PBB.PBB_APROV "
			cQuery += " 	AND PBD.PBD_APROV = PB9.PB9_COD "
			cQuery += " 	AND PBA.PBA_COD = PBD.PBD_GRUPO "
			cQuery += " 	AND PB7.PB7_DATA <= '" + dToS(dLimite) + "'"
			cQuery += " 	AND PBB.PBB_DTAPON <= '" + dToS(dLimite) + "'"
			cQuery += " GROUP BY "
			cQuery += " 	RA_FILIAL, "
			cQuery += " 	RA_MAT, "
			cQuery += " 	RA_NOME, "
			cQuery += " 	RD0_CODIGO, "
			cQuery += " 	PB7_PAPONT, "
			cQuery += " 	PBA.PBA_COD, "
			cQuery += " 	PBA.PBA_DESC, "
			cQuery += " 	PB9.PB9_TIPO, "
			cQuery += " 	PBB.PBB_APROV "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				//Procura por funcionario que esteja ativo
				While (cAlias)->(!EOF())
					aAux := {}
					aAdd(aAux, (cAlias)->RA_FILIAL )
					aAdd(aAux, (cAlias)->RA_MAT )
					aAdd(aAux, Capital( (cAlias)->RA_NOME ) )
					aAdd(aAux, (cAlias)->RD0_CODIGO )
					aAdd(aAux, dtoc( stod( left( ( cAlias )->PB7_PAPONT, 8 ) ) ) +" a "+dtoc( stod( right( ( cAlias )->PB7_PAPONT, 8 ) ) ) )
					aAdd(aAux, (cAlias)->PBA_COD )
					aAdd(aAux, Capital( (cAlias)->PBA_DESC ) )
					aAdd(aAux, (cAlias)->PB7_PAPONT )
					aAdd(aAux, (cAlias)->PB9_TIPO )
					if (cAlias)->PB9_TIPO == '1'
						aAdd(aAux, 'Somente atrasos e Sa&iacute;da Antecipada' )
					elseif (cAlias)->PB9_TIPO == '2'
						aAdd(aAux, 'Somente hora extra' )
					elseif (cAlias)->PB9_TIPO == '3'
						aAdd(aAux, 'Atrasos e hora extra' )
					else
						aAdd(aAux, ' ' )
					endif
					cId := u_CrypCsPE(.T., aParam[1]+';'+dtos(MsDate())+';'+(calias)->RD0_CODIGO+';'+(calias)->PB7_PAPONT+';'+(calias)->PBA_COD, cIdLog)
					aAdd( aAux, cId )
					aAdd( aAux, (calias)->PBB_APROV )
					aAdd( aAux, Capital( POSICIONE('PB9', 1, (calias)->(xFilial('PB9')+PBB_APROV), 'PB9_NOME' ) ) )

					aAdd(aLinha, aAux)
					(cAlias)->(DbSkip())
				EndDo
				(cAlias)->(dbCloseArea())

				U_json(@cRetorno, aLinha, aProp, 'listaAprovacaoPendente') //Monta Marcacao
				::jsonListaAprovPenden := cRetorno
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getListaAprovacao
Lista de aprovacoes
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getListaAprovacao WSReceive idkey, idPortalParticipante, ponmes WSSend jsonListaAprovacoes WSService WsCsPortalRH
	local aAux 		 := {}
	local aLinha	 := {}
	local aProp      := { 'idAprovador', 'nome', 'periodoApontamento', 'codGrupo', 'descGrupo', 'status', 'nivel', 'dataAvaliacao', 'tipo' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""
	local dLimite    := u_ponDLimL()

	default ::idkey 	 			:= ""
	default ::idPortalParticipante  := ""
	default ::ponmes 				:= ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				//Monta SQL
				cQuery += " SELECT "
				cQuery += " 	RD0.RD0_CODIGO, "
				cQuery += " 	RD0.RD0_NOME, "
				cQuery += " 	PB7.PB7_PAPONT, "
				cQuery += " 	PBA.PBA_COD, "
				cQuery += " 	PBA.PBA_DESC, "
				cQuery += " 	PBB.PBB_STATUS, "
				cQuery += " 	PBB.PBB_NIVEL, "
				cQuery += " 	PBB.PBB_DTAVAL, "
				cQuery += " 	PB9.PB9_TIPO "
				cQuery += " FROM  "
				cQuery += " 	"+RetSqlName('PBB')+" PBB, "
				cQuery += " 	"+RetSqlName('RD0')+" RD0, "
				cQuery += " 	"+RetSqlName('PB7')+" PB7, "
				cQuery += " 	"+RetSqlName('SRA')+" SRA, "
				cQuery += " 	"+RetSqlName('PBA')+" PBA, "
				cQuery += " 	"+RetSqlName('PBD')+" PBD, "
				cQuery += " 	"+RetSqlName('PB9')+" PB9 "
				cQuery += " WHERE  "
				cQuery += " 	PBB.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND RD0.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND PB7.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SRA.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND PBA.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND PB9.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND PBD.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND RD0.RD0_CODIGO = PBB.PBB_APROV "
				cQuery += " 	AND PB7.PB7_FILIAL = PBB.PBB_FILMAT "
				cQuery += " 	AND PB7.PB7_MAT    = PBB.PBB_MAT "
				cQuery += " 	AND PB7.PB7_DATA   = PBB.PBB_DTAPON "
				cQuery += " 	AND SRA.RA_FILIAL  = PBB.PBB_FILMAT "
				cQuery += " 	AND SRA.RA_MAT     = PBB.PBB_MAT "
				cQuery += " 	AND PB7.PB7_FILIAL = '"+aFunc[1]+"' "
				cQuery += " 	AND PB7.PB7_MAT    = '"+aFunc[2]+"' "
				cQuery += " 	AND PB7.PB7_PAPONT = '"+::periodo+"' "
				cQuery += " 	AND PBD.PBD_APROV  = PBB.PBB_APROV "
				cQuery += " 	AND PBD.PBD_GRUPO  = PBA.PBA_COD "
				//cQuery += " 	AND PBA.PBA_CC     = SRA.RA_CC "
				cQuery += " 	AND PBD.PBD_APROV  = PB9.PB9_COD "
				cQuery += " 	AND PB7.PB7_DATA   <= '" + dToS(dLimite) + "'"
				cQuery += " 	AND PBB.PBB_DTAPON <= '" + dToS(dLimite) + "'"
				cQuery += " GROUP BY "
				cQuery += " 	RD0.RD0_CODIGO, "
				cQuery += " 	RD0.RD0_NOME, "
				cQuery += " 	PB7.PB7_PAPONT, "
				cQuery += " 	PBA.PBA_COD, "
				cQuery += " 	PBA.PBA_DESC, "
				cQuery += " 	PBB.PBB_STATUS, "
				cQuery += " 	PBB.PBB_NIVEL, "
				cQuery += " 	PBB.PBB_DTAVAL, "
				cQuery += " 	PB9.PB9_TIPO "

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
					//Procura por funcionario que esteja ativo
					While (cAlias)->(!EOF())
						aAux := {}
						aAdd(aAux, (cAlias)->RD0_CODIGO)
						aAdd(aAux, Capital( (cAlias)->RD0_NOME) )
						aAdd(aAux, (cAlias)->PB7_PAPONT)
						aAdd(aAux, (cAlias)->PBA_COD)
						aAdd(aAux, Capital( (cAlias)->PBA_DESC) )
						if (cAlias)->PBB_STATUS == '1'
							aAdd(aAux, 'Em Aprova&ccedil;&atilde;o' )
						elseif (cAlias)->PBB_STATUS == '2'
							aAdd(aAux, 'Aguardando N&iacute;vel' )
						elseif (cAlias)->PBB_STATUS == '3'
							aAdd(aAux, 'Aprovado' )
						elseif (cAlias)->PBB_STATUS == '4'
							aAdd(aAux, 'Reprovado' )
						else
							aAdd(aAux, ' ' )
						endif
						aAdd(aAux, (cAlias)->PBB_NIVEL)
						aAdd(aAux, (cAlias)->PBB_DTAVAL)
						if (cAlias)->PB9_TIPO == '1'
							aAdd(aAux, 'Somente atrasos e Sa&iacute;da Antecipada' )
						elseif (cAlias)->PB9_TIPO == '2'
							aAdd(aAux, 'Somente hora extra' )
						elseif (cAlias)->PB9_TIPO == '3'
							aAdd(aAux, 'Atrasos e hora extra' )
						else
							aAdd(aAux, ' ' )
						endif
						aAdd(aLinha, aAux)
						(cAlias)->(DbSkip())
					EndDo
					(cAlias)->(dbCloseArea())

					U_json(@cRetorno, aLinha, aProp, 'listaAprovacao') //Monta Marcacao
					::jsonListaAprovacoes := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getResultParcial
Lista a somarização das horas apontadas
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getResultParcial WSReceive idkey, idPortalParticipante, Result WSSend jsonListaResultParcial WSService WsCsPortalRH
	local aAux 		 := {}
	local aEvento	 := {}
	local aLabels	 := {}
	local aProp      := {'matricula', 'evento', 'tipo', 'descricao', 'quantidade', 'nome' }
	local aDatasets	 := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cDatasets	 := ""
	local cLabels 	 := ""
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local nHoras	 := 0.00
	local nPos		 := 0
	local cor        := ""
	local cId		 := ""
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0

				//Monta SQL
				cQuery := " SELECT "
				cQuery += " 	SPC.PC_MAT,  "
				cQuery += " 	SRA.RA_NOME,  "
				cQuery += " 	SPC.PC_PD,  "
				cQuery += " 	SPC.PC_TIPOHE,  "
				cQuery += " 	SP9.P9_DESC, "
				cQuery += " 	SUM(SPC.PC_QUANTC) PC_QUANTC  "
				cQuery += " FROM  "
				cQuery += " 	"+RetSqlName('SPC')+" SPC, "
				cQuery += " 	"+RetSqlName('SRA')+" SRA, "
				cQuery += " 	"+RetSqlName('SP9')+" SP9 "
				cQuery += " WHERE  "
				cQuery += " 	SPC.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_FILIAL = '"+aFunc[1]+"' "
				cQuery += " 	AND SPC.PC_MAT = '"+aFunc[2]+"' "
				cQuery += " 	AND SPC.PC_DATA BETWEEN '"+Result:dia+"' AND '"+Result:diaFim+"' "
				cQuery += " 	AND SP9.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SP9.P9_CODIGO = SPC.PC_PD "
				cQuery += " 	AND SRA.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SRA.RA_FILIAL = SPC.PC_FILIAL "
				cQuery += " 	AND SRA.RA_MAT = SPC.PC_MAT "
				cQuery += " GROUP BY  "
				cQuery += " 	SPC.PC_MAT,  "
				cQuery += " 	SRA.RA_NOME,  "
				cQuery += " 	SPC.PC_PD,  "
				cQuery += " 	SPC.PC_TIPOHE,  "
				cQuery += " 	SP9.P9_DESC "
				cQuery += " ORDER BY SPC.PC_MAT, SPC.PC_TIPOHE, SP9.P9_DESC "

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
					While (cAlias)->(!EOF())
						if Result:grafico == 'N'
							nHoras := fConvHr((calias)->PC_QUANTC, "H" )
							aAux := {}
							aAdd(aAux, (cAlias)->PC_MAT)
							aAdd(aAux, (cAlias)->PC_PD)
							aAdd(aAux, (cAlias)->PC_TIPOHE)
							aAdd(aAux, (cAlias)->P9_DESC)
							aAdd(aAux, replace(STRZERO( nHoras, 5, 2 ), '.', ':') )
							aAdd(aAux, (cAlias)->RA_NOME)
							aAdd(aEvento, aAux)
						else
							if ( nPos := aScan( aLabels , { |x| x ==  (cAlias)->RA_NOME } ) ) == 0
								aAdd(aLabels, (cAlias)->RA_NOME )
								aAdd(aId, (cAlias)->PC_MAT )
							endif

							nHoras := fConvHr((calias)->PC_QUANTC, "H" )
							if ( nPos := aScan( aDatasets , { |x| x[1] ==  (calias)->P9_DESC } ) ) > 0
								aAdd(aDatasets[nPos][3], nHoras)
							else
								if Empty((cAlias)->PC_TIPOHE)
									cor := "#d9534f"
								else
									cor := "#428bca"
								endif
								aAdd(aDatasets, {(cAlias)->P9_DESC, cor, {nHoras} })
							endif
						endif
						(cAlias)->(DbSkip())
					EndDo
					(cAlias)->(dbCloseArea())

					if Result:grafico == 'N'
						U_json(@cRetorno, aEvento, aProp, 'listaResultadoParcial') //Monta Marcacao
					else
						U_json(@cLabels, {aLabels}  , {'labels'}, '', {0, {1}} ) //Monta Marcacao
						U_json(@cDatasets, {aDatasets}, {'label', 'backgroundColor', 'data'}, '', {0, {0, {0,{3}}}}) //Monta Marcacao
						U_json(@cId, {aId}  , {'id'}, '', {0, {1}} ) //Monta Marcacao
						cRetorno := '{"grafico" : ['+cLabels+', {"datasets": ['+cDatasets+']}, {"id": ['+cId+' ]} ]}'
					endif
					::jsonListaResultParcial := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getResultDiretoria
Lista horas apontadas respeitando parametros
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getResultDiretoria WSReceive idkey, idPortalParticipante, Result WSSend jsonResultDiretoria WSService WsCsPortalRH
	local aAux 		 := {}
	local aEvento	 := {}
	local aLabels	 := {}
	local aProp      := {'matricula', 'evento', 'tipo', 'descricao', 'quantidade', 'nome' }
	local aDatasets	 := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cDatasets	 := ""
	local cLabels 	 := ""
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local nHoras	 := 0.00
	local nPos		 := 0
	local cor        := ""
	local cLabel	 := ""
	local cCC		 := ""
	local cId		 := ""
	local aId		 := {}
	local cData      := ""
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0

				if !empty(::Result:periodo)
					cData := " AND SPCINT.PC_DATA >= '"+left(Result:periodo, 8)+"' AND SPCINT.PC_DATA  <= '"+right(Result:periodo, 8)+"' "
				endif

				if ::Result:tipoGes == "0"
					cMat := aFunc[2]
				elseif ::Result:tipoGes == "1"
					cQuery := " SELECT "
					cQuery += " 	PBC.PBC_CC CC"
					cQuery += " FROM  "
					cQuery += " 	"+RetSqlName('PBC')+" PBC "
					cQuery += " WHERE "
					cQuery += " 	PBC.D_E_L_E_T_ = ' ' "
					cQuery += " 	AND PBC.PBC_CODGER = '"+aFunc[2]+"'
					if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
						(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
						While (cAlias)->(!EOF())
							if !empty(cCC)
								cCC += "', '"
							endif
							cCC += (cAlias)->CC
							(cAlias)->(DbSkip())
						EndDo
						(cAlias)->(dbCloseArea())
					endif
				elseif ::Result:tipoGes == "2"
					cQuery := " SELECT  "
					cQuery += " 	SQB.QB_CC CC "
					cQuery += " FROM  "
					cQuery += " 	"+RetSqlName('SQB')+" SQB "
					cQuery += " WHERE  "
					cQuery += " 	SQB.D_E_L_E_T_ = ' ' "
					cQuery += " 	AND SQB.QB_FILRESP = '"+aFunc[1]+"' "
					cQuery += " 	AND SQB.QB_MATRESP = '"+aFunc[2]+"' "
					if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
						(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
						While (cAlias)->(!EOF())
							if !empty(cCC)
								cCC += "', '"
							endif
							cCC += (cAlias)->CC
							(cAlias)->(DbSkip())
						EndDo
						(cAlias)->(dbCloseArea())
					endif
				endif

				//Monta SQL
				cQuery := ""
				if ::Result:tipoGra == '1'
					cQuery := " SELECT * FROM ( "
					cQuery += " 	SELECT 	 "
					cQuery += " 		CTT.CTT_CUSTO ID,   "
					cQuery += " 		CTT.CTT_DESC01 NOME,   "
					cQuery += " 		(SELECT SUM(PC_QUANTC) PC_QUANTC FROM "+RetSqlName('SPC')+" SPCINT, "+RetSqlName('SP9')+" SP9INT WHERE SPCINT.D_E_L_E_T_ = ' ' AND SP9INT.D_E_L_E_T_ = ' ' AND SP9INT.P9_TIPOCOD IN('2') AND SP9INT.P9_CODIGO =  SPCINT.PC_PD AND PC_CC = CTT.CTT_CUSTO "+cData+") NEGATIVO, "
					cQuery += " 		(SELECT SUM(PC_QUANTC) PC_QUANTC FROM "+RetSqlName('SPC')+" SPCINT, "+RetSqlName('SP9')+" SP9INT WHERE SPCINT.D_E_L_E_T_ = ' ' AND SP9INT.D_E_L_E_T_ = ' ' AND SP9INT.P9_TIPOCOD IN('1') AND SP9INT.P9_CODIGO =  SPCINT.PC_PD AND PC_CC = CTT.CTT_CUSTO "+cData+") POSITIVO "
					cQuery += " 	FROM   "
					cQuery += " 		"+RetSqlName('CTT')+" CTT "
					cQuery += " 	WHERE   "
					cQuery += " 		CTT.D_E_L_E_T_ = ' '  "
					cQuery += " 		AND CTT.CTT_CUSTO IN ('"+cCC+"')"
					cQuery += " 	ORDER BY 1 "
					cQuery += " ) TAB WHERE"
					cQuery += " POSITIVO > 0 OR NEGATIVO > 0 "
				elseif ::Result:tipoGra == '2'
					cQuery := " SELECT * FROM ( "
					cQuery += " 	SELECT 	 "
					cQuery += " 		SRA.RA_MAT ID,   "
					cQuery += " 		SRA.RA_NOME NOME,   "
					cQuery += " 		(SELECT SUM(PC_QUANTC) PC_QUANTC FROM "+RetSqlName('SPC')+" SPCINT, "+RetSqlName('SP9')+" SP9INT WHERE SPCINT.D_E_L_E_T_ = ' ' AND SP9INT.D_E_L_E_T_ = ' ' AND SP9INT.P9_TIPOCOD IN('2') AND SP9INT.P9_CODIGO =  SPCINT.PC_PD AND SPCINT.PC_FILIAL = SRA.RA_FILIAL AND SPCINT.PC_MAT = SRA.RA_MAT "+cData+") NEGATIVO, "
					cQuery += " 		(SELECT SUM(PC_QUANTC) PC_QUANTC FROM "+RetSqlName('SPC')+" SPCINT, "+RetSqlName('SP9')+" SP9INT WHERE SPCINT.D_E_L_E_T_ = ' ' AND SP9INT.D_E_L_E_T_ = ' ' AND SP9INT.P9_TIPOCOD IN('1') AND SP9INT.P9_CODIGO =  SPCINT.PC_PD AND SPCINT.PC_FILIAL = SRA.RA_FILIAL AND SPCINT.PC_MAT = SRA.RA_MAT "+cData+") POSITIVO "
					cQuery += " 	FROM   "
					cQuery += " 		"+RetSqlName('SRA')+" SRA, "
					cQuery += " 		"+RetSqlName('CTT')+" CTT "
					cQuery += " 	WHERE   "
					cQuery += " 		SRA.D_E_L_E_T_ = ' '  "
					cQuery += " 		AND CTT.D_E_L_E_T_ = ' '  "
					cQuery += " 		AND SRA.RA_CC IN ('"+cCC+"')"
					cQuery += " 		AND SRA.RA_CC = CTT.CTT_CUSTO"
					if !Empty(::Result:filtro)
						cQuery	 += " 	AND CTT.CTT_CUSTO = '"+::Result:filtro+"' "
					endif
					cQuery += " 	ORDER BY SRA.RA_NOME "
					cQuery += " 	) TAB WHERE"
					cQuery += " POSITIVO > 0 OR NEGATIVO > 0 "
				elseif ::Result:tipoGra == '3'
					cQuery := " SELECT NOME, ID, POSITIVO, NEGATIVO FROM (  "
					cQuery += " 	SELECT "
					cQuery += " 		SP9.P9_CODIGO ID, "
					cQuery += " 		SP9.P9_DESC NOME, "
					cQuery += " 		(SELECT SUM(PC_QUANTC) FROM
					cQuery += " 			"+RetSqlName('SPC')+" SPCINT, "
					cQuery += " 			"+RetSqlName('SP9')+" SP9INT, "
					cQuery += " 			"+RetSqlName('SRA')+" SRAINT
					cQuery += " 		WHERE SPCINT.D_E_L_E_T_ = ' ' AND SP9INT.D_E_L_E_T_ = ' ' AND SRAINT.D_E_L_E_T_ = ' ' "
					cQuery += " 			AND SP9INT.P9_TIPOCOD IN('2') AND SP9INT.P9_CODIGO = SPCINT.PC_PD AND SP9INT.P9_CODIGO = SP9.P9_CODIGO "
					cQuery += " 			AND SPCINT.PC_FILIAL = SRAINT.RA_FILIAL "
					cQuery += " 			AND SPCINT.PC_MAT = SRAINT.RA_MAT "
					cQuery += " 			AND SPCINT.PC_CC IN('"+cCC+"') "
					if !Empty(::Result:filtro)
						cQuery	 += " 		AND SRAINT.RA_MAT = '"+::Result:filtro+"' "
					endif
					cQuery += " 		"+cData+") NEGATIVO,  "
					cQuery += " 		(SELECT SUM(PC_QUANTC) FROM
					cQuery += " 			"+RetSqlName('SPC')+" SPCINT, "
					cQuery += " 			"+RetSqlName('SP9')+" SP9INT, "
					cQuery += " 			"+RetSqlName('SRA')+" SRAINT
					cQuery += " 		WHERE SPCINT.D_E_L_E_T_ = ' ' AND SP9INT.D_E_L_E_T_ = ' ' AND SRAINT.D_E_L_E_T_ = ' ' "
					cQuery += " 			AND SP9INT.P9_TIPOCOD IN('1') AND SP9INT.P9_CODIGO = SPCINT.PC_PD AND SP9INT.P9_CODIGO = SP9.P9_CODIGO "
					cQuery += " 			AND SPCINT.PC_FILIAL = SRAINT.RA_FILIAL "
					cQuery += " 			AND SPCINT.PC_MAT = SRAINT.RA_MAT "
					cQuery += " 			AND SPCINT.PC_CC IN('"+cCC+"') "
					if !Empty(::Result:filtro)
						cQuery	 += " 		AND SRAINT.RA_MAT = '"+::Result:filtro+"' "
					endif
					cQuery += " 			"+cData+") POSITIVO  "
					cQuery += " 	FROM "
					cQuery += " 		"+RetSqlName('SP9')+" SP9, "
					cQuery += " 	WHERE  "
					cQuery += " 		SP9.D_E_L_E_T_ = ' '  "
					cQuery += " 	ORDER BY  SP9.P9_DESC"
					cQuery += " ) TAB WHERE"
					cQuery += " 	POSITIVO > 0 OR NEGATIVO > 0 "
					cQuery += " GROUP BY NOME, ID , POSITIVO, NEGATIVO  "
				endif

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
					While (cAlias)->(!EOF())
						if ::Result:grafico == 'N'
							nHoras := fConvHr((calias)->PC_QUANTC, "H" )
							aAux := {}
							aAdd(aAux, (cAlias)->PC_MAT)
							aAdd(aAux, (cAlias)->PC_PD)
							aAdd(aAux, (cAlias)->PC_TIPOHE)
							aAdd(aAux, (cAlias)->P9_DESC)
							aAdd(aAux, replace(STRZERO( nHoras, 5, 2 ), '.', ':') )
							aAdd(aAux, (cAlias)->RA_NOME)
							aAdd(aEvento, aAux)
						else
							aAdd(aLabels, (cAlias)->NOME )
							aAdd(aId, (cAlias)->ID )

							cor := "#428bca"
							cLabel := "Horas Positivas"
							nHoras := fConvHr((calias)->POSITIVO, "H" )
							if ( nPos := aScan( aDatasets , { |x| x[1] == cLabel } ) ) > 0
								aAdd( aDatasets[nPos][3], nHoras)
							else
								aAdd( aDatasets, {cLabel, cor, {nHoras} } )
							endif

							//Grava Horas Negativas
							cor := "#d9534f"
							cLabel := "Horas Negativas"
							nHoras := fConvHr((calias)->NEGATIVO, "H" ) *-1
							if ( nPos := aScan( aDatasets , { |x| x[1] == cLabel } ) ) > 0
								aAdd(aDatasets[nPos][3], nHoras)
							else
								aAdd(aDatasets, {cLabel, cor, {nHoras} })
							endif
						endif
						(cAlias)->(DbSkip())
					EndDo
					(cAlias)->(dbCloseArea())

					if ::Result:grafico == 'N'
						U_json(@cRetorno, aEvento, aProp, 'listaResultadoParcial') //Monta Marcacao
					else
						U_json(@cLabels, {aLabels}  , {'labels'}, '', {0,{1}} ) //Monta Marcacao
						U_json(@cDatasets, {aDatasets}, {'label', 'backgroundColor', 'data'}, '', {0, {0, {0,{3}}}}) //Monta Marcacao
						U_json(@cId, {aId}  , {'id'}, '', {0,{1}} ) //Monta Marcacao

						cRetorno := '{"grafico" : ['+cLabels+', {"datasets": ['+cDatasets+']}, '+cId+'     ]}'
					endif
					::jsonResultDiretoria := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getTipoGestor
Retorna o tipo do gestor
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getTipoGestor WSReceive idkey, idPortalParticipante WSSend jsonTipoGestor WSService WsCsPortalRH
	local aProp      := {'tipoGestor'}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cTipo      := '0'
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			//Monta SQL
			cQuery := " SELECT "
			cQuery += " 	COUNT(*) QTDE "
			cQuery += " FROM  "
			cQuery += " 	"+RetSqlName('RDZ')+" RDZ, "
			cQuery += " 	"+RetSqlName('SRA')+" SRA, "
			cQuery += " 	"+RetSqlName('PBC')+" PBC "
			cQuery += " WHERE  "
			cQuery += " 	PBC.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND SRA.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND RDZ.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBC_CODGER = SRA.RA_MAT "
			cQuery += " 	AND RDZ.RDZ_CODRD0 = '"+cIdLog+"' "
			cQuery += " 	AND ( SRA.RA_FILIAL || SRA.RA_MAT ) = RDZ.RDZ_CODENT "
			cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
			cQuery += " 	AND SRA.RA_DEMISSA = ' ' "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				if (cAlias)->QTDE > 0
					cTipo      := '1'
				endif
				(cAlias)->( dbCloseArea() )
			endif

			if cTipo == '0'
				cQuery := " SELECT "
				cQuery += " 	COUNT(*) QTDE "
				cQuery += " FROM "
				cQuery += " 	"+RetSqlName('RDZ')+" RDZ, "
				cQuery += " 	"+RetSqlName('SQB')+" SQB, "
				cQuery += " 	"+RetSqlName('SRA')+" SRA "
				cQuery += " WHERE "
				cQuery += " 	RDZ.D_E_L_E_T_     = ' ' "
				cQuery += " 	AND SQB.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND (SQB.QB_FILRESP || SQB.QB_MATRESP) = RDZ.RDZ_CODENT "
				cQuery += " 	AND RDZ.RDZ_CODRD0 = '"+cIdLog+"' "
				cQuery += " 	AND SRA.RA_DEMISSA = ' ' "
				cQuery += " 	AND SRA.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SRA.RA_FILIAL  = SQB.QB_FILRESP "
				cQuery += " 	AND SRA.RA_MAT     = SQB.QB_MATRESP "
				cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "

				if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
					(cAlias)->( dbGoTop() ) //Posiciona no primeiro registro
					if (cAlias)->QTDE > 0
						cTipo      := '2'
					endif
					(cAlias)->(dbCloseArea())
				endif
			endif

			U_json(@cRetorno, {cTipo}, aProp, 'tipoGestor')
			::jsonTipoGestor := cRetorno
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getPeriodoAberto
TEXTO
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getPeriodoAberto WSReceive idkey, idPortalParticipante WSSend jsonPeriodoAberto WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'codigo', 'descricao' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local cDescricao := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			//Monta SQL
			cQuery := " SELECT "
			cQuery += " 	SUBSTRING(RCC.RCC_CONTEU, 1, 16) CODIGO,   "
			cQuery += " 	SUBSTRING(RCC.RCC_CONTEU, 1, 08) DATA_INI, "
			cQuery += " 	SUBSTRING(RCC.RCC_CONTEU, 9, 08) DATA_FIM  "
			cQuery += " FROM  "
			cQuery += " 	"+RetSqlName('RCC')+" RCC "
			cQuery += " WHERE  "
			cQuery += " 	RCC.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND RCC.RCC_CODIGO = 'U007' "
			//cQuery += " 	AND SUBSTRING(RTRIM(RCC.RCC_CONTEU), 17, 1) = '1' "
			cQuery += " ORDER BY 2 DESC, 3 "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				while (cAlias)->(!EoF())
					cDescricao := dtoc( stod( (cAlias)->DATA_INI) )
					cDescricao += " - "
					cDescricao += dtoc( stod( (cAlias)->DATA_FIM) )
					aAdd(aAux, { (cAlias)->CODIGO, cDescricao } )
					(cAlias)->( dbSkip() )
				end
				(cAlias)->( dbCloseArea() )
			endif

			U_json( @cRetorno, aAux, aProp, 'listaPeriodo' )
			::jsonPeriodoAberto := cRetorno
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getAprovador
Retorna em Json o tipo do aprovador.
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getAprovador WSReceive idkey, idPortalParticipante WSSend jsonAprovador WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'tipoAprovador' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty( ::idkey ) .And. !Empty( ::idPortalParticipante )
		aParam := Descriptog( ::idkey )
		aParti := Descriptog( ::idPortalParticipante )

		if ValidKey( aParam, aParti, 3 )
			cIdLog := aParam[1]

			//Monta SQL
			cQuery := " SELECT  "
			cQuery += " PB9.PB9_TIPO "
			cQuery += " FROM "
			cQuery += "  "+RetSqlName('PB9')+" PB9 "
			cQuery += " WHERE "
			cQuery += " PB9.D_E_L_E_T_ = ' ' "
			cQuery += " AND PB9.PB9_COD = '"+aParam[1]+"' "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				while (cAlias)->(!EoF())
					aAdd(aAux, {(cAlias)->PB9_TIPO })
					(cAlias)->(dbSkip())
				end
				(cAlias)->(dbCloseArea())
			else
				aAdd(aAux, {'0'} )
			endif

			U_json(@cRetorno, aAux, aProp, 'listaAprovador')
			::jsonAprovador := cRetorno
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getPossuiAprovador
Verifica se o colaborador possui aprovodar cadastrado.
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getPossuiAprovador WSReceive idkey, idPortalParticipante, ponmes WSSend jsonPossuiAprovador WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'possuiGrupoAprovador' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::ponmes)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				//Monta SQL
				cQuery := " SELECT "
				cQuery += " 	RD0.RD0_GRPAPV "
				cQuery += " FROM  "
				cQuery += " 	"+RetSqlName('RD0')+" RD0 "
				cQuery += " WHERE  "
				cQuery += " 	RD0.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND RD0.RD0_CODIGO = '"+aParam[3]+"'"

				//Executa consulta SQL
				aAdd(aAux, {'0'} )
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop())
					if !empty( (cAlias)->RD0_GRPAPV)
						if !diferPB7Gp(aFunc[1], aFunc[2], ::ponmes, (cAlias)->RD0_GRPAPV)
							aAux := {}
							aAdd(aAux, {'1'} )
						endif
					endif
					(cAlias)->(dbCloseArea())
				endif

				U_json(@cRetorno, aAux, aProp, 'grupoAprovador')
				::jsonPossuiAprovador := cRetorno
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getListaProcesso
Monta lista de status do ponto do colaborador
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getListaProcesso WSReceive idkey, idPortalParticipante, ponmes, grupo WSSend jsonListaProcesso WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'ordem', 'descricao', 'cc', 'status', 'qtde', 'id', 'he', 'he_n', 'atr', 'atr_n', 'aguard', 'periodo' }
	local aFlow      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""
	local cCC 		 := ""
	local cMat       := ""
	local nTot		 := 0
	local enviouApon := .F.
	local aAprov 	 := {}
	local cGrupo 	 := ""
	local cPeriodo 	 := ""
	local perAnt     := ""
	local i 		 := 0
	local cDescCC    := ""
	local nomeAprov	 := ""
	local dLimite    := u_ponDLimL()

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				//Pertenco a um grupo de aprovação?
				cQuery += " SELECT "
				cQuery += " 	PBD.PBD_GRUPO  "
				cQuery += " FROM "
				cQuery += " 	"+RetSqlName('PBA')+" PBA, "
				cQuery += " 	"+RetSqlName('PBD')+" PBD "
				cQuery += " WHERE "
				cQuery += " 	PBA.D_E_L_E_T_ = '  ' "
				cQuery += " 	AND PBD.D_E_L_E_T_ = '  ' "
				cQuery += " 	AND PBA.PBA_COD = PBD.PBD_GRUPO "
				cQuery += " 	AND PBD.PBD_APROV = '"+cIdLog+"' "

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop())
					while (cAlias)->(!EoF())
						if !empty( cGrupo )
							cGrupo += "', '"
						endif
						cGrupo += (cAlias)->PBD_GRUPO
						(cAlias)->(dbSkip())
					end
					(cAlias)->(dbCloseArea())
				endif

				cQuery := " SELECT "
				cQuery += " 	GERAL.PB7_MAT, "
				cQuery += " 	GERAL.PB7_PAPONT, "
				cQuery += " 	GERAL.PB7_FILIAL, "
				cQuery += " 	GERAL.PB7_GRPAPV, "
				cQuery += " 	GERAL.RA_NOME, "
				cQuery += " 	GERAL.PBD_NIVEL, "
				cQuery += " 	GERAL.PB9_TIPO, "
				cQuery += " 	GERAL.STATUS_GERAL, "
				cQuery += " 	GERAL.PBA_DESC,  "
				cQuery += " 	GERAL.Aprovadores, "
				cQuery += " 	( GERAL.Sem_Alteracao + GERAL.Em_Manutencao ) QTDCOLAB, "
				cQuery += " 	Count( CASE WHEN GERAL.PBB_STAHE  = '3' THEN 1 END ) HE_AUT, "
				cQuery += " 	Count( CASE WHEN GERAL.PBB_STAHE  = '4' THEN 1 END ) HE_NAUT, "
				cQuery += " 	Count( CASE WHEN GERAL.PBB_STAATR = '3' THEN 1 END ) ATR_AUT, "
				cQuery += " 	Count( CASE WHEN GERAL.PBB_STAATR = '4' THEN 1 END ) ATR_NAUT,  "
				cQuery += " 	Count( CASE WHEN GERAL.PBB_STATUS = '1' THEN 1 END ) AGUARD, "
				cQuery += " 	Count( * ) QTDE  "
				cQuery += " FROM "
				cQuery += " 	( "
				cQuery += " 		SELECT "
				cQuery += " 			TODOS.PB7_FILIAL, "
				cQuery += " 			TODOS.PB7_MAT, "
				cQuery += " 			TODOS.PB7_PAPONT, "
				cQuery += " 			TODOS.PB7_GRPAPV, "
				cQuery += " 			TODOS.RA_NOME, "
				cQuery += " 			coalesce(PBD.PBD_NIVEL, 0) PBD_NIVEL, "
				cQuery += " 			coalesce(PB9.PB9_TIPO, '') PB9_TIPO, "
				cQuery += " 			PBB.PBB_STAATR, "
				cQuery += " 			PBB.PBB_STAHE, "
				cQuery += " 			PBB.PBB_STATUS, "
				cQuery += " 			PBA.PBA_DESC, "
				cQuery += " 			RD0APROV.RD0_NOME Aprovadores, "
				cQuery += " 			TODOS.Sem_Alteracao, "
				cQuery += " 			TODOS.Em_Manutencao, "
				cQuery += " 			TODOS.Aguardando_Aprovacao, "
				cQuery += " 			TODOS.Alterado_pelo_RH, "
				cQuery += " 			TODOS.Nao_justificado, "
				cQuery += " 			TODOS.Aprovacao_concluida, "
				cQuery += " 			TODOS.Processo_concluido, "
				cQuery += " 			CASE  "
				cQuery += " 				WHEN PBB.PBB_STATUS IS NULL AND TODOS.Sem_Alteracao > 0 THEN '00' "
				cQuery += " 				WHEN PBB.PBB_STATUS IS NULL AND TODOS.EM_MANUTENCAO > 0 THEN '01'  "
				cQuery += " 				WHEN PBB.PBB_STATUS IS NULL AND ( TODOS.ALTERADO_PELO_RH > 0 OR TODOS.NAO_JUSTIFICADO > 0 OR TODOS.APROVACAO_CONCLUIDA > 0 OR TODOS.PROCESSO_CONCLUIDO > 0 ) THEN '02' "
				cQuery += " 				WHEN PBB.PBB_STATUS = '1' OR PBB.PBB_STATUS = '2' THEN '03'  "
				cQuery += " 				WHEN PBB.PBB_STATUS = '3' AND TODOS.PROCESSO_CONCLUIDO = 0 THEN '04' "
				cQuery += " 				WHEN PBB.PBB_STATUS = '3' AND TODOS.PROCESSO_CONCLUIDO > 0 THEN '05'  "
				cQuery += " 				ELSE '03' "
				cQuery += " 			END Status_Geral "
				cQuery += " 		FROM "
				cQuery += " 			( "
				cQuery += " 				SELECT "
				cQuery += " 					PB7FIL.PB7_FILIAL, "
				cQuery += " 					PB7FIL.PB7_MAT, "
				cQuery += " 					PB7FIL.PB7_PAPONT, "
				cQuery += " 					PB7FIL.PB7_GRPAPV, "
				cQuery += " 					RD0.RD0_CODIGO, "
				cQuery += " 					SRA.RA_MAT, "
				cQuery += " 					SRA.RA_NOME, "
				cQuery += " 					Count(PB70.PB7_MAT) AS Sem_Alteracao, "
				cQuery += " 					Count(PB71.PB7_MAT) AS Em_Manutencao, "
				cQuery += " 					Count(PB72.PB7_MAT) AS Aguardando_Aprovacao, "
				cQuery += " 					Count(PB75.PB7_MAT) AS Alterado_pelo_RH, "
				cQuery += " 					Count(PB76.PB7_MAT) AS Nao_justificado, "
				cQuery += " 					Count(PB77.PB7_MAT) AS Aprovacao_concluida, "
				cQuery += " 					Count(PB78.PB7_MAT) AS Processo_concluido  "
				cQuery += " 				FROM "
				cQuery += " 					"+RetSqlName('SRA')+"  SRA, "
				cQuery += " 					"+RetSqlName('RDZ')+"  RDZ, "
				cQuery += " 					"+RetSqlName('RD0')+"  RD0, "
				cQuery += " 					( "
				cQuery += " 						SELECT "
				cQuery += " 							PB7_FILIAL, "
				cQuery += " 							PB7_MAT, "
				cQuery += " 							PB7_DATA, "
				cQuery += " 							Max(PB7_VERSAO) VERSAO, "
				cQuery += " 							PB7.PB7_GRPAPV, "
				cQuery += " 							PB7_PAPONT  "
				cQuery += " 						FROM "
				cQuery += " 							"+RetSqlName('PB7')+" PB7, "
				cQuery += " 							"+RetSqlName('SRA')+" SRA, "
				cQuery += " 							"+RetSqlName('RCC')+" RCC  "
				cQuery += " 						WHERE "
				cQuery += " 							SRA.D_E_L_E_T_ = ' ' "
				cQuery += " 							AND PB7.D_E_L_E_T_ = ' ' "
				cQuery += " 							AND RCC.D_E_L_E_T_ = ' '  "
				cQuery += "                             AND PB7.PB7_DATA <= '"+ dToS( dLimite )+"'"
				cQuery += " 							AND PB7.PB7_MAT = SRA.RA_MAT  "
				cQuery += " 							AND PB7.PB7_FILIAL = SRA.RA_FILIAL "
				cQuery += " 							AND PB7.PB7_PAPONT = Substring( Rtrim(RCC.RCC_CONTEU), 1, 16) "
				cQuery += " 							AND Substring(Rtrim(RCC.RCC_CONTEU), 17, 1) = '1' "
				cQuery += " 							AND RCC_CODIGO = 'U007' "
				if empty( cGrupo )
					cQuery += "                             AND RA_FILIAL = '"+aFunc[1]+"'"
					cQuery += "                             AND RA_MAT    = '"+aFunc[2]+"'"
				else
					cQuery += "                          	AND PB7.PB7_GRPAPV IN ('"+cGrupo+"') "
				endif
				if !empty( ::ponmes )
					cQuery += "                          	AND PB7.PB7_PAPONT = '"+::ponmes+"'"
				endif
				if !empty( ::grupo )
					cQuery += "                          	AND PB7.PB7_GRPAPV = '"+::grupo+"'"
				endif
				cQuery += " 						GROUP BY "
				cQuery += " 							PB7_FILIAL, "
				cQuery += " 							PB7_MAT, "
				cQuery += " 							PB7_DATA, "
				cQuery += " 							PB7_GRPAPV, "
				cQuery += " 							PB7_PAPONT "
				cQuery += " 					) PB7FIL  "
				cQuery += " 			LEFT JOIN "+RetSqlName('PB7')+" PB70 ON "
				cQuery += " 				PB70.PB7_STATUS       = '0' "
				cQuery += " 				AND PB70.D_E_L_E_T_   = ' ' "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = PB70.PB7_FILIAL "
				cQuery += " 				AND PB7FIL.PB7_MAT    = PB70.PB7_MAT  "
				cQuery += " 				AND PB7FIL.PB7_DATA   = PB70.PB7_DATA  "
				cQuery += " 				AND PB7FIL.VERSAO     = PB70.PB7_VERSAO  "
				cQuery += " 				AND PB7FIL.PB7_PAPONT = PB70.PB7_PAPONT  "
				cQuery += " 				AND PB70.PB7_DATA <= '" + dToS(dLimite) + "'"
				cQuery += " 			LEFT JOIN "+RetSqlName('PB7')+" PB71 ON  "
				cQuery += " 				PB71.PB7_STATUS       = '1' "
				cQuery += " 				AND PB71.D_E_L_E_T_   = ' ' "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = PB71.PB7_FILIAL "
				cQuery += " 				AND PB7FIL.PB7_MAT    = PB71.PB7_MAT  "
				cQuery += " 				AND PB7FIL.PB7_DATA   = PB71.PB7_DATA  "
				cQuery += " 				AND PB7FIL.VERSAO     = PB71.PB7_VERSAO "
				cQuery += " 				AND PB7FIL.PB7_PAPONT = PB71.PB7_PAPONT  "
				cQuery += " 				AND PB71.PB7_DATA <= '" + dToS(dLimite) + "'"
				cQuery += " 			LEFT JOIN "+RetSqlName('PB7')+" PB72 ON  "
				cQuery += " 				PB72.PB7_STATUS       = '2' "
				cQuery += " 				AND PB72.D_E_L_E_T_   = ' ' "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = PB72.PB7_FILIAL "
				cQuery += " 				AND PB7FIL.PB7_MAT    = PB72.PB7_MAT "
				cQuery += " 				AND PB7FIL.PB7_DATA   = PB72.PB7_DATA "
				cQuery += " 				AND PB7FIL.VERSAO     = PB72.PB7_VERSAO  "
				cQuery += " 				AND PB7FIL.PB7_PAPONT = PB72.PB7_PAPONT  "
				cQuery += " 				AND PB72.PB7_DATA <= '" + dToS(dLimite) + "'"
				cQuery += " 			LEFT JOIN "+RetSqlName('PB7')+" PB75 ON  "
				cQuery += " 				PB75.PB7_STATUS       = '5'  "
				cQuery += " 				AND PB75.D_E_L_E_T_   = ' ' "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = PB75.PB7_FILIAL "
				cQuery += " 				AND PB7FIL.PB7_MAT    = PB75.PB7_MAT  "
				cQuery += " 				AND PB7FIL.PB7_DATA   = PB75.PB7_DATA  "
				cQuery += " 				AND PB7FIL.VERSAO     = PB75.PB7_VERSAO  "
				cQuery += " 				AND PB7FIL.PB7_PAPONT = PB75.PB7_PAPONT  "
				cQuery += " 				AND PB75.PB7_DATA <= '" + dToS(dLimite) + "'"
				cQuery += " 			LEFT JOIN "+RetSqlName('PB7')+" PB76 ON  "
				cQuery += " 				PB76.PB7_STATUS       = '6'  "
				cQuery += " 				AND PB76.D_E_L_E_T_   = ' ' "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = PB76.PB7_FILIAL "
				cQuery += " 				AND PB7FIL.PB7_MAT    = PB76.PB7_MAT  "
				cQuery += " 				AND PB7FIL.PB7_DATA   = PB76.PB7_DATA  "
				cQuery += " 				AND PB7FIL.VERSAO     = PB76.PB7_VERSAO  "
				cQuery += " 				AND PB7FIL.PB7_PAPONT = PB76.PB7_PAPONT  "
				cQuery += " 				AND PB76.PB7_DATA <= '" + dToS(dLimite) + "'"
				cQuery += " 			LEFT JOIN "+RetSqlName('PB7')+" PB77 ON  "
				cQuery += " 				PB77.PB7_STATUS       = '7'  "
				cQuery += " 				AND PB77.D_E_L_E_T_   = ' ' "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = PB77.PB7_FILIAL "
				cQuery += " 				AND PB7FIL.PB7_MAT    = PB77.PB7_MAT  "
				cQuery += " 				AND PB7FIL.PB7_DATA   = PB77.PB7_DATA  "
				cQuery += " 				AND PB7FIL.VERSAO     = PB77.PB7_VERSAO  "
				cQuery += " 				AND PB7FIL.PB7_PAPONT = PB77.PB7_PAPONT  "
				cQuery += " 				AND PB77.PB7_DATA <= '" + dToS(dLimite) + "'"
				cQuery += " 			LEFT JOIN "+RetSqlName('PB7')+" PB78 ON  "
				cQuery += " 				PB78.PB7_STATUS       = '8'  "
				cQuery += " 				AND PB78.D_E_L_E_T_   = ' ' "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = PB78.PB7_FILIAL "
				cQuery += " 				AND PB7FIL.PB7_MAT    = PB78.PB7_MAT  "
				cQuery += " 				AND PB7FIL.PB7_DATA   = PB78.PB7_DATA  "
				cQuery += " 				AND PB7FIL.VERSAO     = PB78.PB7_VERSAO  "
				cQuery += " 				AND PB7FIL.PB7_PAPONT = PB78.PB7_PAPONT  "
				cQuery += " 				AND PB78.PB7_DATA <= '" + dToS(dLimite) + "'"
				cQuery += " 			WHERE "
				cQuery += " 				RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 "
				cQuery += " 				AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT "
				cQuery += " 				AND RDZ.RDZ_ENTIDA = 'SRA'  "
				cQuery += " 				AND RD0.D_E_L_E_T_ = ' '  "
				cQuery += " 				AND RDZ.D_E_L_E_T_ = ' '  "
				cQuery += " 				AND SRA.D_E_L_E_T_ = ' '  "
				cQuery += " 				AND PB7FIL.PB7_MAT    = SRA.RA_MAT "
				cQuery += " 				AND PB7FIL.PB7_FILIAL = SRA.RA_FILIAL "
				cQuery += " 				AND RD0.RD0_MSBLQL    = '2'  "
				cQuery += " 			GROUP BY "
				cQuery += " 				PB7FIL.PB7_FILIAL, "
				cQuery += " 				PB7FIL.PB7_MAT, "
				cQuery += " 				PB7FIL.PB7_PAPONT, "
				cQuery += " 				PB7FIL.PB7_GRPAPV, "
				cQuery += " 				RD0.RD0_CODIGO, "
				cQuery += " 				SRA.RA_MAT, "
				cQuery += " 				SRA.RA_NOME "
				cQuery += " 		) "
				cQuery += " 		TODOS "
				cQuery += " 		LEFT JOIN "+RetSqlName('PBA')+" PBA ON "
				cQuery += " 			PBA.D_E_L_E_T_ = ' '  "
				cQuery += " 			AND PBA.PBA_COD = TODOS.PB7_GRPAPV "
				cQuery += " 		LEFT JOIN "+RetSqlName('PBD')+" PBD ON  "
				cQuery += " 			PBD.D_E_L_E_T_ = ' '  "
				cQuery += " 			AND PBA.PBA_COD = PBD.PBD_GRUPO "
				cQuery += " 		LEFT JOIN "+RetSqlName('PB9')+" PB9 ON  "
				cQuery += " 			PB9.D_E_L_E_T_ = ' '  "
				cQuery += " 			AND PB9.PB9_COD = PBD.PBD_APROV "
				cQuery += " 		LEFT JOIN "+RetSqlName('PBB')+" PBB ON  "
				cQuery += " 			PBB.D_E_L_E_T_ = ' '  "
				cQuery += " 			AND PBB.PBB_GRUPO   = PBD.PBD_GRUPO "
				cQuery += " 			AND PBB.PBB_APROV   = PBD.PBD_APROV  "
				cQuery += " 			AND PBB.PBB_FILMAT  = TODOS.PB7_FILIAL "
				cQuery += " 			AND PBB.PBB_MAT     = TODOS.PB7_MAT  "
				cQuery += " 			AND PBB.PBB_PAPONT  = TODOS.PB7_PAPONT  "
				cQuery += " 			AND PBB.PBB_DTAPON <= '" + dToS(dLimite) + "'"
				cQuery += " 		LEFT JOIN "+RetSqlName('RD0')+" RD0APROV ON  "
				cQuery += " 			RD0APROV.D_E_L_E_T_ = ' '  "
				cQuery += " 			AND RD0APROV.RD0_CODIGO = PBD.PBD_APROV "
				cQuery += " 	) "
				cQuery += " 	GERAL "
				cQuery += " GROUP BY "
				cQuery += " 	GERAL.PB7_MAT, "
				cQuery += " 	GERAL.PB7_PAPONT, "
				cQuery += " 	GERAL.PB7_FILIAL, "
				cQuery += " 	GERAL.PB7_GRPAPV, "
				cQuery += " 	GERAL.RA_NOME, "
				cQuery += " 	GERAL.PBD_NIVEL, "
				cQuery += " 	GERAL.STATUS_GERAL, "
				cQuery += " 	GERAL.PBA_DESC,  "
				cQuery += " 	GERAL.PB9_TIPO, "
				cQuery += " 	GERAL.Aprovadores, "
				cQuery += " 	GERAL.Sem_Alteracao, "
				cQuery += " 	GERAL.Em_Manutencao "
				cQuery += " ORDER BY "
				cQuery += " 	GERAL.PB7_PAPONT, "
				cQuery += " 	GERAL.PB7_GRPAPV, "
				cQuery += " 	GERAL.PB7_FILIAL, "
				cQuery += " 	GERAL.PB7_MAT, "
				cQuery += " 	GERAL.RA_NOME, "
				cQuery += " 	GERAL.PBD_NIVEL, "
				cQuery += " 	GERAL.STATUS_GERAL "

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					cChaveAnt := (cAlias)->(PB7_FILIAL+PB7_MAT)
					perAnt    := dtoc( stod( left( (cAlias)->PB7_PAPONT, 8) ) ) + ' - ' +dtoc( stod( right( (cAlias)->PB7_PAPONT, 8) ) )
					aAux := structFlow(cAlias)

					while (cAlias)->(!EoF())
						cPeriodo := dtoc( stod( left( (cAlias)->PB7_PAPONT, 8) ) ) + ' - ' +dtoc( stod( right( (cAlias)->PB7_PAPONT, 8) ) )
						if cChaveAnt != (cAlias)->(PB7_FILIAL+PB7_MAT) .or. perAnt != cPeriodo
							if !enviouApon
								if len(aAprov) > 0
									for i := 1 to len(aAprov)
										aAdd( aAux, aAprov[i] )
									next i
								else
									PBD->(dbSetOrder(2))
									if PBD->( dbSeek( xFilial("PBD")+cGrupo  ) )
										while PBD->(!EoF() ) .and. PBD->( PBD_FILIAL + PBD_GRUPO ) ==  xFilial("PBD")+cGrupo
											nomeAprov :=  POSICIONE( "RD0", 1, RD0->( xFilial("RD0") + PBD->PBD_APROV ), "RD0_NOME" )
											aAdd( aAux, { 03, Capital( left( nomeAprov, 17) ),cDescCC , '01', 0,  cMat, 0, 0, 0, 0, 0, perAnt  } )
											PBD->( dbSkip() )
										end
									endif
								endif
							endif
							aAdd( aAux, { 06, 'Concluído', cCC, '05', nTot, cMat, 0, 0, 0, 0, 0, perAnt  } )
							aAdd( aFlow, aAux )
							aAux := structFlow(cAlias)
							nTot := 0
							enviouApon := .F.
							aAprov := {}
						endif

						if (cAlias)->STATUS_GERAL == '00'
							aAux[1][2] := Capital( left( (cAlias)->RA_NOME, 17 ) )
							aAux[1][3] := Capital( (cAlias)->PBA_DESC )
							aAux[1][5] := (cAlias)->QTDCOLAB
							aAux[1][6] := (cAlias)->PB7_MAT
							aAux[1][7] := (cAlias)->QTDCOLAB
							aAux[1][10] :=  cPeriodo
						elseif (cAlias)->STATUS_GERAL == '01'
							aAux[2][2] := Capital( left( (cAlias)->RA_NOME, 17 ) )
							aAux[2][3] := Capital( (cAlias)->PBA_DESC )
							aAux[2][5] := (cAlias)->QTDCOLAB
							aAux[2][6] := (cAlias)->PB7_MAT
							aAux[2][8] := (cAlias)->QTDCOLAB
							aAux[2][10] :=  cPeriodo
							aAdd( aAprov, { 03, Capital( left( (cAlias)->Aprovadores, 17 ) ), Capital( (cAlias)->PBA_DESC ), (cAlias)->STATUS_GERAL, (cAlias)->QTDE,  (cAlias)->PB7_MAT, (cAlias)->HE_AUT , (cAlias)->HE_NAUT , (cAlias)->ATR_AUT , (cAlias)->ATR_NAUT, (cAlias)->AGUARD, cPeriodo  } )
						elseif (cAlias)->STATUS_GERAL == '02'
							aAux[3][2] := Capital( left( (cAlias)->RA_NOME, 17 ) )
							aAux[3][3] := Capital( (cAlias)->PBA_DESC )
							aAux[3][5] := (cAlias)->QTDCOLAB
							aAux[3][6] := (cAlias)->PB7_MAT
							aAux[3][9] := (cAlias)->QTDCOLAB
							aAux[3][10] :=  cPeriodo
						elseif (cAlias)->STATUS_GERAL == '03'
							enviouApon := .T.
							aAdd( aAux, { 03, Capital( left( (cAlias)->Aprovadores, 17 ) ), Capital( (cAlias)->PBA_DESC ), '03', (cAlias)->QTDE,  (cAlias)->PB7_MAT, (cAlias)->HE_AUT , (cAlias)->HE_NAUT , (cAlias)->ATR_AUT , (cAlias)->ATR_NAUT, (cAlias)->AGUARD, cPeriodo  } )
						elseif (cAlias)->STATUS_GERAL == '04'
							enviouApon := .T.
							aAdd( aAux, { 03, Capital( left( (cAlias)->Aprovadores, 17 ) ), Capital( (cAlias)->PBA_DESC ), '04', (cAlias)->QTDE,  (cAlias)->PB7_MAT, (cAlias)->HE_AUT , (cAlias)->HE_NAUT , (cAlias)->ATR_AUT , (cAlias)->ATR_NAUT, (cAlias)->AGUARD, cPeriodo  } )
						elseif (cAlias)->STATUS_GERAL == '05'
							enviouApon := .T.
							aAdd( aAux, { 03, Capital( left( (cAlias)->Aprovadores, 17 ) ), Capital( (cAlias)->PBA_DESC ), '05', (cAlias)->QTDE,  (cAlias)->PB7_MAT, (cAlias)->HE_AUT , (cAlias)->HE_NAUT , (cAlias)->ATR_AUT , (cAlias)->ATR_NAUT, (cAlias)->AGUARD, cPeriodo  } )
							nTot := (cAlias)->QTDE
						elseif (cAlias)->STATUS_GERAL == '99'
							aAdd( aAux, { 03, Capital( left( (cAlias)->Aprovadores, 17 ) ), Capital( (cAlias)->PBA_DESC ), '99', (cAlias)->QTDE,  (cAlias)->PB7_MAT, (cAlias)->HE_AUT , (cAlias)->HE_NAUT , (cAlias)->ATR_AUT , (cAlias)->ATR_NAUT, (cAlias)->AGUARD, cPeriodo } )
						endif
						cCC 	  := Capital( (cAlias)->PBA_DESC )
						cMat      := (cAlias)->PB7_MAT
						cChaveAnt := (cAlias)->(PB7_FILIAL+PB7_MAT)
						perAnt    := dtoc( stod( left( (cAlias)->PB7_PAPONT, 8) ) ) + ' - ' +dtoc( stod( right( (cAlias)->PB7_PAPONT, 8) ) )
						cGrupo    := (cAlias)->PB7_GRPAPV
						cDescCC   :=  Capital( (cAlias)->PBA_DESC )
						cMat      := (cAlias)->PB7_MAT
						(cAlias)->(dbSkip())
					end
					(cAlias)->(dbCloseArea())

					if !enviouApon
						if len(aAprov) > 0
							for i := 1 to len(aAprov)
								aAdd( aAux, aAprov[i] )
							next i
						else
							PBD->(dbSetOrder(2))
							if PBD->( dbSeek( xFilial("PBD")+cGrupo  ) )
								while PBD->(!EoF() ) .and. PBD->( PBD_FILIAL + PBD_GRUPO ) ==  xFilial("PBD")+cGrupo
									nomeAprov :=  POSICIONE( "RD0", 1, RD0->( xFilial("RD0") + PBD->PBD_APROV ), "RD0_NOME" )
									aAdd( aAux, { 03, Capital( left( nomeAprov, 17) ),cDescCC , '01', 0,  cMat, 0, 0, 0, 0, 0, perAnt  } )
									PBD->( dbSkip() )
								end
							endif
						endif
					endif
					aAdd( aAux, { 06, 'Concluído', cCC, '05', nTot, cMat, 0, 0, 0, 0, 0, cPeriodo } )
					aAdd( aFlow, aAux )

					U_json(@cRetorno, aFlow, aProp, 'listaFlow')
					::jsonListaProcesso := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} structFlow
Monta lista com dados inicias para estrutura do fluxo de aprovacao
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
static function structFlow(cAlias)
	local aAux     := {}
	local cPeriodo := dtoc( stod( left( (cAlias)->PB7_PAPONT, 8) ) ) + ' - ' +dtoc( stod( right( (cAlias)->PB7_PAPONT, 8) ) )

	aAdd( aAux, { 00, Capital( left( (cAlias)->RA_NOME, 17 ) ), Capital( (cAlias)->PBA_DESC ), '00'	, (cAlias)->QTDCOLAB, (cAlias)->PB7_MAT, 0, 0, 0, 0, 0, cPeriodo } )
	aAdd( aAux, { 01, Capital( left( (cAlias)->RA_NOME, 17 ) ), Capital( (cAlias)->PBA_DESC ), '01'	, (cAlias)->QTDCOLAB, (cAlias)->PB7_MAT, 0, 0, 0, 0, 0, cPeriodo } )
	aAdd( aAux, { 02, Capital( left( (cAlias)->RA_NOME, 17 ) ), Capital( (cAlias)->PBA_DESC ), '02'	, (cAlias)->QTDCOLAB, (cAlias)->PB7_MAT, 0, 0, 0, 0, 0, cPeriodo } )
return aAux

/*
{Protheus.doc} getListaCentroCusto
Monta lista de centro de custo para o participante logado.
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getListaCentroCusto WSReceive idkey, idPortalParticipante WSSend json WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'codigo', 'descricao' }
	local cRetorno 	 := ""
	local cIdLog	 := ""

	default ::idkey 	           := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			/*
			descontinuado
			//Monta SQL
			cQuery += " SELECT "
			cQuery += " 	PBA.PBA_CC, "
			cQuery += " 	CTT.CTT_DESC01 "
			cQuery += " FROM  "
			cQuery += " 	"+RetSqlName('PBA')+" PBA, "
			cQuery += " 	"+RetSqlName('PBD')+" PBD, "
			cQuery += " 	"+RetSqlName('CTT')+" CTT "
			cQuery += " WHERE  "
			cQuery += " 	PBA.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBD.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND CTT.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND PBD.PBD_GRUPO = PBA.PBA_COD "
			cQuery += " 	AND PBA.PBA_CC = CTT.CTT_CUSTO "
			cQuery += " 	AND PBD.PBD_APROV = '"+cIdLog+"'"
			cQuery += " GROUP BY "
			cQuery += " 	PBA.PBA_CC, "
			cQuery += " 	CTT.CTT_DESC01 "
			cQuery += " ORDER BY "
			cQuery += " 	CTT.CTT_DESC01 "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				while (cAlias)->(!EoF())
					aAdd( aAux, { (cAlias)->PBA_CC, Capital( (cAlias)->CTT_DESC01 ) } )
					(cAlias)->(dbSkip())
				end
				(cAlias)->(dbCloseArea())
			endif
			*/

			U_json(@cRetorno, aAux, aProp, 'listaCentroCusto')
			::json := cRetorno
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getMarcacaoFechada
Metodo que lista marcacao do funcionario
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Return String em Json
@author David Moraes
@since 05/02/2016
@version 2.0
*/
WSMethod getMarcacaoFechada WSReceive idkey, idPortalParticipante, ponmes WSSend jsonMarcacao WSService WsCsPortalRH
	local cMarcacao := ""
	local aRet      := {}
	local aPropMarc := {}
	local aParam 	:= {}
	local aParti 	:= {}
	local cIdLog	:= ""
	local cPeriodo 	:= {}

	default ::idkey 	 			:= ""
	default ::idPortalParticipante 	:= ""
	default ::ponmes 				:= ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::ponmes)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)
		cPeriodo := ::ponmes

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0
				//Consutlta Marcacoes
				u_LoadPB8(@aRet, aFunc[1], aFunc[2], cPeriodo, cIdLog)

				if Len(aRet) > 0
					U_json(@cMarcacao, aRet, aPropMarc, 'marcacaoFechada') //Monta Marcacao
					::jsonMarcacao := cMarcacao
				else
					::jsonMarcacao := ''
				endif
			endif
		endif
	endif
Return .T.

/*
{Protheus.doc} getListaParticipante
Monta listade participante.
@type function
@author Bruno Nunes
@since 13/05/2016
@version P11.5
@return nulo
*/
WSMethod getListaParticipante WSReceive idkey WSSend json WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'codigo', 'nome' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	default ::idkey  := ""

	//Monta SQL
	cQuery := " SELECT RD0_CODIGO, RD0_NOME FROM "
	cQuery += " 	"+RetSqlName("RD0")+" RD0,"
	cQuery += " 	"+RetSqlName("RDZ")+" RDZ,"
	cQuery += " 	"+RetSqlName("SRA")+" SRA "
	cQuery += " WHERE "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RDZ.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SRA.RA_FILIAL || SRA.RA_MAT = RDZ_CODENT "
	cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
	cQuery += " 	AND RD0.RD0_CODIGO = RDZ_CODRD0 "
	cQuery += " 	AND SRA.RA_DEMISSA = '' "

	//Executa consulta SQL
	if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		while (cAlias)->(!EoF())
			aAdd( aAux, { (cAlias)->RD0_CODIGO, Capital( (cAlias)->RD0_NOME ) } )
			(cAlias)->(dbSkip())
		end
		(cAlias)->(dbCloseArea())
	endif

	U_json(@cRetorno, aAux, aProp, 'listaParticipante')
	::json := cRetorno
Return(.T.)

/*
{Protheus.doc} getDetalhePos
Funcao que lista os apontamentos Positivos do funcionario
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param dia - Data de consulta dos apontamentos
@Return String em Json
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
WSMethod getDetalhePosPago WSReceive idkey, idPortalParticipante, dia WSSend jsonEvePos WSService WsCsPortalRH
	local aAux 		 := {}
	local aEvento	 := {}
	local aProp      := {'PC_PD', 'P9_DESC', 'PC_QUANTC', 'PC_ABONO', 'DESC_NEG', 'PC_PDI', 'DESC_POS', 'PREABONO' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""
	local dLimite := u_ponDLimL()

	default ::idkey 	 		   := ''
	default ::idPortalParticipante := ''
	default ::dia 	 			   := ''

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::dia)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 4)
			cIdLog := aParam[1]
			aPropMarc := loadPropMa()
			aFunc := RetFuncSRA( aParam[3] )
			if len(aFunc) > 0

				//Monta SQL
				cQuery := " SELECT  "
				cQuery += " 	SPC.PC_FILIAL,  "
				cQuery += " 	SPC.PC_MAT,  "
				cQuery += " 	SPC.PC_PD,  "
				cQuery += " 	SP9.P9_DESC, "
				cQuery += " 	SPC.PC_QUANTC, "
				cQuery += " 	SPC.PC_ABONO, "
				cQuery += ' 	NEG.P6_DESC DESC_NEG, '
				cQuery += " 	SPC.PC_PDI, "
				cQuery += ' 	POS.P9_DESC DESC_POS, '
				cQuery += " 	SPC.PC_QUANTI "
				cQuery += " FROM  "
				cQuery += " 	"+RetSqlName('SP9')+" SP9, "
				cQuery += " 	"+RetSqlName('SPC')+" SPC "
				cQuery += " LEFT JOIN "+RetSqlName('SP9')+" POS ON "
				cQuery += " 	POS.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_PDI = POS.P9_CODIGO "
				cQuery += " LEFT JOIN "+RetSqlName('SP6')+" NEG ON "
				cQuery += " 	NEG.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_ABONO = NEG.P6_CODIGO "
				cQuery += " WHERE "
				cQuery += " 	SPC.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SP9.D_E_L_E_T_ = ' ' "
				cQuery += " 	AND SPC.PC_PD = SP9.P9_CODIGO "
				cQuery += " 	AND SP9.P9_TIPOCOD = '1'"
				cQuery += " 	AND SP9.P9_CLASEV   IN ('ZZ') "
				cQuery += " 	AND SPC.PC_FILIAL = '"+aFunc[1]+"'"
				cQuery += " 	AND SPC.PC_MAT = '"+aFunc[2]+"'"
				cQuery += " 	AND SPC.PC_DATA = '"+DTOS(CTOD(dia))+"'"
				cQuery += " 	AND SPC.PC_DATA <= '" + dLimite + "'"

				//Executa consulta SQL
				if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
					(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
					//Procura por funcionario que esteja ativo
					While (cAlias)->(!EOF())
						aAux := {}
						aAdd(aAux, (cAlias)->PC_PD)
						if empty((cAlias)->PC_PDI)
							aAdd(aAux, (cAlias)->P9_DESC)
							aAdd(aAux, replace(STRZERO((cAlias)->PC_QUANTC, 5, 2), '.', ':') )
							aAdd(aAux, (cAlias)->PC_ABONO)
							aAdd(aAux, (cAlias)->DESC_NEG)
						else
							aAdd(aAux, (cAlias)->DESC_POS)
							aAdd(aAux, replace(STRZERO((cAlias)->PC_QUANTI, 5, 2), '.', ':') )
							aAdd(aAux, (cAlias)->PC_ABONO)
							aAdd(aAux, (cAlias)->DESC_NEG)
						endif
						aAdd(aAux, (cAlias)->PC_PDI)
						aAdd(aAux, (cAlias)->DESC_POS)
						aAdd(aAux, 'N&atilde;o')
						aAdd(aEvento, aAux)
						(cAlias)->(DbSkip())
					EndDo
					(cAlias)->(dbCloseArea())

					U_json(@cRetorno, aEvento, aProp, 'listaEventoDetalhado') //Monta Marcacao
					::jsonEvePos := cRetorno
				endif
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} setReverterAprovacao
Reverte marcacao a partir do portal do ponto eletronico
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param dia - Data de consulta dos apontamentos
@Return String em Json
@author Bruno Nunes
@since 07/01/2019
@version 2.01
*/
WSMethod setReverterAprovacao WSReceive idkey, idPortalParticipante, filColab, matColab, ponmes, tipoUsuario WSSend json WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'status' }
	local cRetorno 	 := ""
	local cIdLog	 := ""

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""
	default ::ponmes 	 		   := ""
	default ::filColab			   := ""
	default ::matColab 			   := ""
	default ::ponmes 			   := ""
	default ::tipoUsuario		   := "1"

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::filColab) .And. !Empty(::matColab) .And. !Empty(::ponmes)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		cIdLog := aParam[1]

		u_fRestPB7(.T., '', ::filColab, ::matColab, ::ponmes, retNomeApr(cIdLog), ::tipoUsuario)
		aAux := {"1"}
	else
		aAux := {"0"}
	endif
	U_json( @cRetorno, {aAux}, aProp, 'reverteraprovacao' )
	::json := cRetorno
Return(.T.)

/*
{Protheus.doc} setReverterAprovacao
Verifica se possiu marcação no portal para o participante logado.
@Param idkey - Chave criptografada
@Param idPortalParticipante - Chave criptografada enviada pelo portal
@Param dia - Data de consulta dos apontamentos
@Return String em Json
@author Bruno Nunes
@since 07/01/2019
@version 2.01
*/
static function diferPB7Gp(cFilMat, cMat, cPeriodo, cGrupo)
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local lValid     := .F.

	default cFilMat  := ""
	default cMat     := ""
	default cPeriodo := ""
	default cGrupo   := ""

	//Monta SQL
	cQuery := " SELECT COUNT(*) QTDE FROM "
	cQuery += "    "+RetSqlName("PB7")+" PB7 "
	cQuery += " WHERE "
	cQuery += "    PB7.D_E_L_E_T_     =  ' ' "
	cQuery += "    AND PB7.PB7_FILIAL =  '"+cFilMat+"'
	cQuery += "    AND PB7.PB7_MAT    =  '"+cMat+"'
	cQuery += "    AND PB7.PB7_PAPONT =  '"+cPeriodo+"'
	cQuery += "    AND PB7.PB7_GRPAPV <> '"+cGrupo+"'"

	//Executa consulta SQL
	if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
		(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
		if (cAlias)->QTDE > 0
			lValid := .T.
		endif
		(cAlias)->(dbCloseArea())
	endif
return lValid

/*
{Protheus.doc} getAprovacaoV2
Monta lista de colaboradores subordinados ao participante logado.
@type function
@author Bruno Nunes
@since 07/01/2019
@version P11.5
@return nulo
*/
WSMethod getAprovacaoV2 WSReceive idkey, idPortalParticipante  WSSend jsonListaAprovPenden WSService WsCsPortalRH
	local aAux 		 := {}
	local aLinha	 := {}
	local aProp      := { 'filial', 'matricula', 'nome', 'idParticipante', 'periodoApontamento', 'codGrupo', 'descGrupo', 'periodo', 'codTipo', 'tipo', 'id', 'aprovador', 'aprovadorNome', 'qtde' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""
	local cId 		 := ""
	local dLeitura   := u_ponDLimL()
	local lProcessa  := .F.

	default ::idkey 	 		   := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			cQuery := " SELECT "
			cQuery += "    TAB.*, "
			cQuery += "    NOMEAPROV.RD0_NOME NOME_APROV"
			cQuery += " FROM "
			cQuery += "    ( "
			cQuery += "       SELECT "
			cQuery += "          PB7.PB7_PAPONT, "
			cQuery += "          PBD.PBD_GRUPO, "
			cQuery += "          PBA.PBA_DESC, "
			cQuery += "          RD0.RD0_CODIGO, "
			cQuery += "          SRA.RA_FILIAL, "
			cQuery += "          SRA.RA_MAT, "
			cQuery += "          RD0.RD0_NOME, "
			cQuery += "          SUBSTR(RTRIM(RCC.RCC_CONTEU), 17, 1) LIBE, "
			cQuery += "          count(PBB_APROV) QTDE_APROV, "
			cQuery += "          max( PBB_APROV) PBB_APROV "
			cQuery += "       FROM "
			cQuery += "          "+RetSqlName('PBD')+ " PBD "
			cQuery += "          INNER JOIN "
			cQuery += "             "+RetSqlName('PBA')+ " PBA "
			cQuery += "             ON PBA.D_E_L_E_T_ = ' ' "
			cQuery += "             AND PBA.PBA_COD = PBD.PBD_GRUPO "
			cQuery += "          INNER JOIN "
			cQuery += "             "+RetSqlName('RD0')+ " RD0 "
			cQuery += "             ON RD0.D_E_L_E_T_ = ' ' "
			cQuery += "             AND RD0.RD0_GRPAPV = PBD.PBD_GRUPO "
			cQuery += "          INNER JOIN "
			cQuery += "             "+RetSqlName('RDZ')+ " RDZ "
			cQuery += "             ON RDZ.D_E_L_E_T_ = ' ' "
			cQuery += "             AND RDZ.RDZ_ENTIDA = 'SRA' "
			cQuery += "             AND RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO "
			cQuery += "          INNER JOIN "
			cQuery += "             "+RetSqlName('SRA')+ " SRA "
			cQuery += "             ON SRA.D_E_L_E_T_ = ' ' "
			cQuery += "             AND SRA.RA_FILIAL || SRA.RA_MAT = RDZ.RDZ_CODENT "
			cQuery += "             AND SRA.RA_DEMISSA = ' ' "
			cQuery += "          LEFT JOIN "
			cQuery += "             ( "
			cQuery += "                SELECT "
			cQuery += "                   PB7INT.PB7_FILIAL, "
			cQuery += "                   PB7INT.PB7_MAT, "
			cQuery += "                   PB7INT.PB7_PAPONT "
			cQuery += "                FROM "
			cQuery += "                   "+RetSqlName('PB7')+ " PB7INT "
			cQuery += "                WHERE "
			cQuery += "                   PB7INT.D_E_L_E_T_ = ' ' "
			cQuery += "                GROUP BY "
			cQuery += "                   PB7INT.PB7_FILIAL, "
			cQuery += "                   PB7INT.PB7_MAT, "
			cQuery += "                   PB7INT.PB7_PAPONT "
			cQuery += "             ) "
			cQuery += "             PB7 "
			cQuery += "             ON PB7.PB7_FILIAL = SRA.RA_FILIAL "
			cQuery += "             AND PB7.PB7_MAT = SRA.RA_MAT "
			cQuery += "          LEFT JOIN "
			cQuery += "             "+RetSqlName('PBB')+ " PBB "
			cQuery += "             ON PBB.D_E_L_E_T_   = ' ' "
			cQuery += "             AND PBB.PBB_FILMAT  = SRA.RA_FILIAL "
			cQuery += "             AND PBB.PBB_MAT     = SRA.RA_MAT "
			cQuery += "             AND PBB.PBB_STATUS  = '1' "
			cQuery += "             AND PBB.PBB_GRUPO   = PBD.PBD_GRUPO "
			cQuery += "             AND PBB.PBB_APROV   = PBD.PBD_APROV "
			cQuery += "             AND PBB.PBB_PAPONT  = PB7.PB7_PAPONT "
			cQuery += "             AND PBB.PBB_DTAPON  <= '" + dToS( dLeitura ) +"'"
			cQuery += "          LEFT JOIN "
			cQuery += "             "+RetSqlName('RCC')+ " RCC "
			cQuery += "             ON RCC.D_E_L_E_T_   = ' ' "
			cQuery += "           	AND PB7.PB7_PAPONT = SUBSTR(RTRIM(RCC.RCC_CONTEU), 1, 16)   "
			cQuery += "           	AND RCC.RCC_CODIGO     = 'U007' "
			cQuery += "       WHERE "
			cQuery += "          PBD.D_E_L_E_T_ = ' ' "
			cQuery += "          AND PBD_STATUS = '1' "
			cQuery += "          AND EXISTS "
			cQuery += "          ( "
			cQuery += "             SELECT "
			cQuery += "                SUBPBD.PBD_GRUPO "
			cQuery += "             FROM "
			cQuery += "                "+RetSqlName('PBD')+ " SUBPBD "
			cQuery += "             WHERE "
			cQuery += "                SUBPBD.D_E_L_E_T_     = ' ' "
			cQuery += "                AND SUBPBD.PBD_APROV  = '"+aParam[1]+"' "
			cQuery += "                AND SUBPBD.PBD_STATUS = '1' "
			cQuery += "                AND SUBPBD.PBD_GRUPO  = PBD.PBD_GRUPO "
			cQuery += "          ) "
			cQuery += "       GROUP BY "
			cQuery += "          PBD.PBD_GRUPO, "
			cQuery += "          PBA.PBA_DESC, "
			cQuery += "          RD0.RD0_CODIGO, "
			cQuery += "          RD0.RD0_NOME, "
			cQuery += "          SRA.RA_FILIAL, "
			cQuery += "          SRA.RA_MAT, "
			cQuery += "          PB7.PB7_PAPONT, "
			cQuery += "          RCC.RCC_CONTEU "
			cQuery += "    ) "
			cQuery += "    TAB "
			cQuery += "    LEFT JOIN "
			cQuery += "       "+RetSqlName('RD0')+ " NOMEAPROV "
			cQuery += "       ON TAB.PBB_APROV = NOMEAPROV.RD0_CODIGO "

			//Executa consulta SQL
			if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				//Procura por funcionario que esteja ativo
				While (cAlias)->(!EOF())
					aAux := {}
					if ( cAlias )->LIBE == "1" .and. !empty( ( cAlias )->PB7_PAPONT )
						lProcessa := .T.
					elseif ( cAlias )->LIBE == "0" .and. empty( ( cAlias )->PB7_PAPONT )
						lProcessa := .T.
					else
						lProcessa := .F.
					endif

					if lProcessa
						aAdd(aAux, (cAlias)->RA_FILIAL ) 			//01 - filial
						aAdd(aAux, (cAlias)->RA_MAT ) 				//02 - matricula
						aAdd(aAux, Capital( (cAlias)->RD0_NOME ) ) 	//03 - nome
						aAdd(aAux, (cAlias)->RD0_CODIGO ) 			//04 - idParticipante
						aAdd(aAux, dtoc( stod( left( ( cAlias )->PB7_PAPONT, 8 ) ) ) +" a "+dtoc( stod( right( ( cAlias )->PB7_PAPONT, 8 ) ) ) ) //05 - periodoApontamento
						aAdd(aAux, (cAlias)->PBD_GRUPO ) 			//06 - codGrupo
						aAdd(aAux, Capital( (cAlias)->PBA_DESC ) ) 	//07 - descGrupo
						aAdd(aAux, (cAlias)->PB7_PAPONT ) 			//08 - periodo
						aAdd(aAux, ' ' ) 			//09 - codTipo

						aAdd(aAux, ' ' )
						/*
						if (cAlias)->PB9_TIPO == '1'
						aAdd(aAux, 'Somente atrasos e Sa&iacute;da Antecipada' ) //10 - desc tipo
						elseif (cAlias)->PB9_TIPO == '2'
						aAdd(aAux, 'Somente hora extra' )						 //10 - desc tipo
						elseif (cAlias)->PB9_TIPO == '3'
						aAdd(aAux, 'Atrasos e hora extra' )						 //10 - desc tipo
						else
						aAdd(aAux, ' ' )										 //10 - desc tipo
						endif
						*/

						cId := u_CrypCsPE(.T., aParam[1]+';'+dtos(MsDate())+';'+(calias)->RD0_CODIGO+';'+(calias)->PB7_PAPONT+';'+(calias)->PBD_GRUPO, cIdLog)
						aAdd( aAux, cId ) 							  //11 - id
						aAdd( aAux, (calias)->PBB_APROV ) 		 	  //12 - aprovador
						aAdd( aAux, Capital( (calias)->NOME_APROV ) ) //13 - aprovadorNome
						aAdd( aAux, (calias)->QTDE_APROV ) 			  //14 - aprovadorNome

						aAdd(aLinha, aAux)

					endif

					(cAlias)->( dbSkip() )
				EndDo
				(cAlias)->( dbCloseArea() )

				U_json( @cRetorno, aLinha, aProp, 'listaAprovacaoPendente' ) //Monta Marcacao
				::jsonListaAprovPenden := cRetorno
			endif
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getParticipante
Pega dados de participante utilizando como chave a matricula.
@type function
@author Bruno Nunes
@since 26/02/2019
@version P12.1.17
@return nulo
*/
WSMethod getParticipante WSReceive idkey WSSend json WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'codigo', 'nome' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	default ::idkey  := ""

	//Monta SQL
	cQuery := " SELECT RD0_CODIGO, RD0_NOME FROM "
	cQuery += " 	"+RetSqlName("RD0")+" RD0,"
	cQuery += " 	"+RetSqlName("RDZ")+" RDZ,"
	cQuery += " 	"+RetSqlName("SRA")+" SRA "
	cQuery += " WHERE "
	cQuery += " 	SRA.D_E_L_E_T_     = ' ' "
	cQuery += " 	AND RDZ.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
	cQuery += " 	AND RD0.RD0_CODIGO = RDZ_CODRD0 "
	cQuery += " 	AND SRA.RA_DEMISSA = '' "
	cQuery += " 	AND SRA.RA_MAT     = '"+ ::idkey +"' "
	cQuery += " 	AND SRA.RA_FILIAL || SRA.RA_MAT = RDZ_CODENT "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		(cAlias)->( dbGoTop() ) //Posiciona no primeiro registro
		while (cAlias)->( !EoF() )
			aAdd( aAux, { (cAlias)->RD0_CODIGO, Capital( (cAlias)->RD0_NOME ) } )
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif

	U_json( @cRetorno, aAux, aProp, 'participante' )
	::json := cRetorno
Return(.T.)

/*
{Protheus.doc} getListaGrupoAprovadores
Monta lista de grupo de aprovadores para o participante logado.
@type function
@author Bruno Nunes
@since 28/02/2019
@version P11.5
@return nulo
*/
WSMethod getListaGrupoAprovadores WSReceive idkey, idPortalParticipante WSSend json WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'codigo', 'descricao' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cIdLog	 := ""

	default ::idkey 	           := ""
	default ::idPortalParticipante := ""

	if !Empty( ::idkey ) .And. !Empty( ::idPortalParticipante )
		aParam := Descriptog( ::idkey )
		aParti := Descriptog( ::idPortalParticipante )

		if ValidKey(aParam, aParti, 3)
			cIdLog := aParam[1]

			//Monta SQL
			cQuery += " SELECT "
			cQuery += "    PBA.PBA_COD, "
			cQuery += "    PBA.PBA_DESC "
			cQuery += " FROM  "
			cQuery += "    "+RetSqlName('PBA')+" PBA, "
			cQuery += "    "+RetSqlName('PBD')+" PBD "
			cQuery += " WHERE  "
			cQuery += "    PBA.D_E_L_E_T_     = ' ' "
			cQuery += "    AND PBD.D_E_L_E_T_ = ' ' "
			cQuery += "    AND PBD.PBD_GRUPO  = PBA.PBA_COD "
			cQuery += "    AND PBD.PBD_APROV  = '"+cIdLog+"'"
			cQuery += " GROUP BY "
			cQuery += "    PBA.PBA_COD, "
			cQuery += "    PBA.PBA_DESC "
			cQuery += " ORDER BY "
			cQuery += "    PBA.PBA_DESC "

			//Executa consulta SQL
			if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
				(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
				while (cAlias)->(!EoF())
					aAdd( aAux, { (cAlias)->PBA_COD, Capital( (cAlias)->PBA_DESC ) } )
					(cAlias)->(dbSkip())
				end
				(cAlias)->(dbCloseArea())
			endif

			U_json( @cRetorno, aAux, aProp, 'listaGrupoAprovadores' )
			::json := cRetorno
		endif
	endif
Return(.T.)

/*
{Protheus.doc} getQtdMarcacao
Monta lista de grupo de aprovadores para o participante logado.
@type function
@author Bruno Nunes
@since 28/02/2019
@version P11.5
@return nulo
*/
/*
WSMethod getQtdMarcacao WSReceive idkey, idPortalParticipante WSSend json WSService WsCsPortalRH
local aAux 		 := {}
local aProp      := { 'qtde' }
local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
local cQuery  	 := "" 	//Query SQL
local cRetorno 	 := ""
local lExeChange := .T. //Executa o change Query
local lTotaliza  := .F. //Conta quantidade de registros da query executada
local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
local cIdLog	 := ""
local aQtde		 := {}

default ::idkey 	           := ""
default ::idPortalParticipante := ""

if !Empty(::idkey) .And. !Empty(::idPortalParticipante)
aParam := Descriptog(::idkey)
aParti := Descriptog(::idPortalParticipante)

if ValidKey(aParam, aParti, 3)
cIdLog := aParam[1]

//Monta SQL
cQuery := " SELECT RD0_CODIGO, RD0_NOME, PA_MARCAUT FROM "
cQuery += " "+RetSqlName("RD0")+" RD0,"
cQuery += " "+RetSqlName("RDZ")+" RDZ,"
cQuery += " "+RetSqlName("SRA")+" SRA, "
cQuery += " "+RetSqlName("SPA")+" SPA "
cQuery += " WHERE "
cQuery += " SRA.D_E_L_E_T_ = ' ' "
cQuery += " AND RDZ.D_E_L_E_T_ = ' ' "
cQuery += " AND SPA.D_E_L_E_T_ = ' ' "
cQuery += " AND SRA.RA_FILIAL || SRA.RA_MAT = RDZ_CODENT "
cQuery += " AND RDZ.RDZ_ENTIDA = 'SRA' "
cQuery += " AND RD0.RD0_CODIGO = RDZ_CODRD0 "
cQuery += " AND SRA.RA_DEMISSA = ' ' "
cQuery += " AND RD0.RD0_CODIGO = '"+ ::idkey +"' "
cQuery += " AND SRA.RA_REGRA = SPA.PA_CODIGO "

//Executa consulta SQL
if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
(cAlias)->(dbGoTop()) //Posiciona no primeiro registro
while (cAlias)->(!EoF())
aQtde := StrTokArr( (cAlias)->PA_MARCAUT, "-" )
aAdd( aAux, {   } )
(cAlias)->(dbSkip())
end
(cAlias)->(dbCloseArea())
endif

U_json(@cRetorno, aAux, aProp, 'listaQtdeMarcacoes')
::json := cRetorno
endif
endif

Return(.T.)
*/

/*
{Protheus.doc} getSaldoBH
Retorna Saldo do banco de horas.
@type function
@author Bruno Nunes
@since 11/04/2019
@version P12
@return nulo
*/
WSMethod getSaldoBH WSReceive idkey, idPortalParticipante, filColab, matColab, ponmes  WSSend json WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := { 'saldo' }
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local nSaldo     := 0
	local nHora      := 0
	local nMin 	     := 0
	local lNegativo  := .F.
	local nTamanho   := 0
	local cDataFim   := ""

	default ::idkey 	           := ""
	default ::idPortalParticipante := ""

	if !Empty(::idkey) .And. !Empty(::idPortalParticipante) .And. !Empty(::filColab) .And. !Empty(::matColab) .And. !Empty(::ponmes)
		aParam := Descriptog(::idkey)
		aParti := Descriptog(::idPortalParticipante)

		if len( ::ponmes ) == 8
			cDataFim := right( ::ponmes, 8 )
		endif

		if ValidKey( aParam, aParti, 3 )
			cQuery := " SELECT "
			cQuery += " 	PI_FILIAL, "
			cQuery += " 	PI_MAT, "
			cQuery += " 	SUM ( "
			cQuery += " 		CASE "
			cQuery += " 		WHEN P9_CLASEV = '01' THEN "
			cQuery += " 			trunc( pi_quant ) + ( ( (pi_quant-trunc( pi_quant  ) )/60) * 100 ) "
			cQuery += " 		WHEN P9_CLASEV = '02' OR P9_CLASEV = '03' OR P9_CLASEV = '04' OR P9_CLASEV = '05'  THEN "
			cQuery += " 			( trunc( pi_quant ) + ( ( (pi_quant-trunc( pi_quant  ) )/60) * 100 ) ) * -1 "
			cQuery += " 		END  "
			cQuery += " 	) HORASDECIMAIS "
			cQuery += " FROM  "
			cQuery += " 	"+RetSqlName('SPI')+" SPI, "
			cQuery += " 	"+RetSqlName('SP9')+" SP9 "
			cQuery += " WHERE  "
			cQuery += " 	SPI.D_E_L_E_T_     = ' ' "
			cQuery += " 	AND SP9.D_E_L_E_T_ = ' ' "
			cQuery += " 	AND SPI.PI_STATUS <> 'B' "
			cQuery += " 	AND SPI.PI_FILIAL  = '" + ::filColab + "' "
			cQuery += " 	AND SPI.PI_MAT     = '" + ::matColab + "' "
			//cQuery += " 	AND SPI.PI_DATA    = '" + cDataFim + "' "
			//cQuery += " 	AND SPI.PI_DATA   <= '" + dToS( dLimite ) + "'"
			cQuery += " 	AND SPI.PI_PD = SP9.P9_CODIGO "
			cQuery += " GROUP BY "
			cQuery += " 	PI_FILIAL, "
			cQuery += " 	PI_MAT "

			//Executa consulta SQL
			if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
				nSaldo := NoRound( (cAlias)->HORASDECIMAIS ,2 )
				if nSaldo < 0
					lNegativo := .T.
				endif

				nHora := abs( nSaldo )

				if len( cvaltochar( Int( nHora ) ) ) > 2
					nTamanho := 1
				endif

				nMin   := ( nHora - Int( nHora ) )
				nMin   := ( nMin * 60 )/100
				nSaldo := Int( nHora) + nMin

				if lNegativo
					aAdd( aAux, "-"+replace( StrZero( nSaldo, 5+nTamanho, 2 ), ".", ":") )
				else
					aAdd( aAux,     replace( StrZero( nSaldo, 5+nTamanho, 2 ), ".", ":") )
				endif

				(cAlias)->( dbCloseArea() )
			else
				aAdd( aAux, "00:00" )
			endif

			U_json( @cRetorno, aAux, aProp, 'saldoBH' )
			::json := cRetorno
		endif
	endif
Return(.T.)


/*
{Protheus.doc} setPreAbono
Grava Pré Abono
@type function
@author Bruno Nunes
@since 11/04/2019
@version P12
@return nulo
*/
WSMethod setPreAbono WSReceive filColab, matColab, dIni, dFim, nHoraIni, nHoraFim  WSSend json WSService WsCsPortalRH
	local aAux 		 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	default ::filColab 	:= ""
	default ::matColab 	:= ""
	default ::dIni 		:= ""
	default ::dFim 		:= ""
	default ::nHoraIni 	:= ""
	default ::nHoraFim 	:= ""

	if !Empty( ::filColab ) .And. !Empty( ::matColab ) .And. !Empty( ::dIni ) .And. !Empty( ::dFim )

		cQuery := " SELECT
		cQuery += " 	R_E_C_N_O_  REC
		cQuery += " FROM
		cQuery += " 	"+RetSqlName('RF0')+" RF0 "
		cQuery += " WHERE
		cQuery += " 	RF0.D_E_L_E_T_ = ' '
		cQuery += " 	AND RF0.RF0_FILIAL = '" + ::filColab + "'
		cQuery += " 	AND RF0.RF0_MAT    = '" + ::matColab + "'
		cQuery += " 	AND RF0.RF0_DTPREI = '" + dToS( ::dIni ) + "'
		cQuery += " 	AND RF0.RF0_DTPREF = '" + dToS( ::dFim ) + "'

		if !Empty( ::dIni ) .And. !Empty( ::dFim ) .and. ::dIni < ::dFim
			cQuery += " 	AND RF0.RF0_HORINI = '" + ::nHoraIni + "'
			cQuery += " 	AND RF0.RF0_HORFIM = '" + ::nHoraFim + "'
		endif

		//Executa consulta SQL
		if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
			RF0->( dbGoTo( (cAlias)->REC ) )
			if RF0->( !EoF() )
				RecLock('RF0', .F.)
				RF0->RF0_FILIAL := ::filColab
				RF0->RF0_MAT    := ::matColab
				RF0->RF0_DTPREI := ::dIni
				RF0->RF0_DTPREF := ::dFim
				RF0->RF0_HORINI := ::nHoraIni
				RF0->RF0_HORFIM := ::nHoraFim
				RF0->RF0_CODABO := '001'
				RF0->RF0_HORTAB := 'N'
				RF0->RF0_ABONA  := 'N'
				RF0->( MsUnLock() )
			endif
		else
			RecLock('RF0', .T.)
			RF0->RF0_FILIAL := ::filColab
			RF0->RF0_MAT    := ::matColab
			RF0->RF0_DTPREI := ::dIni
			RF0->RF0_DTPREF := ::dFim
			RF0->RF0_HORINI := ::nHoraIni
			RF0->RF0_HORFIM := ::nHoraFim
			RF0->RF0_CODABO := '001'
			RF0->RF0_HORTAB := 'N'
			RF0->RF0_ABONA  := 'N'
			RF0->( MsUnLock() )
		endif

		aAdd( aProp, 'filial')
		aAdd( aProp, 'matricula')
		aAdd( aProp, 'dataInicio')
		aAdd( aProp, 'dataFim')
		aAdd( aProp, 'horaInicio')
		aAdd( aProp, 'horaFim')
		aAdd( aProp, 'abono')

		aAdd( aAux, RF0->RF0_FILIAL )
		aAdd( aAux, RF0->RF0_MAT    )
		aAdd( aAux, RF0->RF0_DTPREI )
		aAdd( aAux, RF0->RF0_DTPREF )
		aAdd( aAux, RF0->RF0_HORINI )
		aAdd( aAux, RF0->RF0_HORFIM )
		aAdd( aAux, RF0->RF0_CODABO )

		U_json( @cRetorno, aAux, aProp, 'preAbono' )
		::json := cRetorno
	endif
Return(.T.)

Static Function retNomeApr(codPar)
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	default codPar  := ""

	if !empty(codPar)
		//Monta SQL
		cQuery := " SELECT RA_NOME FROM "
		cQuery += " 	"+RetSqlName("RD0")+" RD0,"
		cQuery += " 	"+RetSqlName("RDZ")+" RDZ,"
		cQuery += " 	"+RetSqlName("SRA")+" SRA "
		cQuery += " WHERE "
		cQuery += " 	SRA.D_E_L_E_T_     = ' ' "
		cQuery += " 	AND RDZ.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
		cQuery += " 	AND RD0.RD0_CODIGO = RDZ_CODRD0 "
		cQuery += " 	AND SRA.RA_DEMISSA = '' "
		cQuery += " 	AND RD0.RD0_CODIGO = '"+ codPar +"' "
		cQuery += " 	AND SRA.RA_FILIAL || SRA.RA_MAT = RDZ_CODENT "

		//Executa consulta SQL
		if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
			cRetorno := Capital( alltrim( (cAlias)->RA_NOME )  )
			(cAlias)->( dbCloseArea() )
		endif
	endif
return cRetorno


/*
{Protheus.doc} setPreAbono
Grava Pré Abono
@type function
@author Bruno Nunes
@since 11/04/2019
@version P12
@return nulo
*/
WSMethod getImportFuncionario WSReceive filColab WSSend json WSService WsCsPortalRH
	default ::filColab 	:= ""

	if !Empty( ::filColab )
		::json := U_CSI00001(::filColab)
	endif
Return(.T.)

/*
{Protheus.doc} getListaUniversoGrupo
Grava Pré Abono
@type function
@author Bruno Nunes
@since 27/06/2019
@version P12
@return nulo
*/
WSMethod getListaUniversoGrupo WSReceive idPortalParticipante WSSend json WSService WsCsPortalRH
	default ::idPortalParticipante 	:= ""

	::json := U_CSRH210( ::idPortalParticipante )
Return(.T.)

/*
{Protheus.doc} getExcelBancoHoras
Grava Pré Abono
@type function
@author Bruno Nunes
@since 27/06/2019
@version P12
@return nulo
*/
WSMethod getExcelBancoHoras WSReceive idPortalParticipante, grupo, cc, matColab  WSSend json WSService WsCsPortalRH
	default ::idPortalParticipante 	:= ""

	::json := U_CSRH211( ::idPortalParticipante, ::grupo, ::cc, ::matColab )
Return(.T.)

/*
{Protheus.doc} getExcelBancoHorasCusto
Grava Pré Abono
@type function
@author Bruno Nunes
@since 27/06/2019
@version P12
@return nulo
*/
WSMethod getExcelBancoHorasCusto WSReceive idPortalParticipante, grupo, cc, matColab  WSSend json WSService WsCsPortalRH
	default ::idPortalParticipante 	:= ""

	::json := U_CSRH221( ::idPortalParticipante, ::grupo, ::cc, ::matColab )
Return(.T.)

/*
{Protheus.doc} getListaExcelArquivo
Gera Excel na protheus data
@type function
@author Bruno Nunes
@since 27/06/2019
@version P12
@return nulo
*/
WSMethod getListaExcelArquivo WSReceive idPortalParticipante WSSend json WSService WsCsPortalRH
	default ::idPortalParticipante 	:= ""

	::json := U_CSRH212( ::idPortalParticipante )
Return(.T.)