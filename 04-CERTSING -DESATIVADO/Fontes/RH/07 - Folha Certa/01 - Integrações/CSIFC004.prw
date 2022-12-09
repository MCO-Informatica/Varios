#INCLUDE 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FILEIO.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE aREST_HEADER {"apiKey:362E80D4DF43B03AE6D3F8540CD63626", "Content-Type:application/json; charset=utf-8"}
#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "07"

user function CSIFC004(lDebug)
	default lDebug := .T.
	if lDebug
		rpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL
		sncFunc()
		RESET ENVIRONMENT
	else
		sncFunc()
	endif
return

static function sncFunc()
	local aPFunc := {}
	local aFFunc := {}

	aPFunc := getPFunc() //Protheus
	aFFunc := getFFunc() //Folha Certa

	//delCC(aFFunc)
	
	procFunc(aPFunc, aFFunc)
return

static function procFunc(aProtheus, aFolCer)
	local i    := 0
	local nPos := 0
	local lUpd := .F.

	default aProtheus := {}
	default aFolCer   := {}

	if len(aProtheus) > 0 .and. len(aFolCer) > 0
		for i := 1 to len(aProtheus)
			nPos := aScan(aFolCer, {|x| x[2] == aProtheus[i][1] })
			if nPos == 0
				postFunc(aProtheus[i])
			else
				if !(aProtheus[i][1] == cValToChar(aFolCer[nPos][2]))
					lUpd := .T.
					conout("ApID diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][1]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][2]))
				endif
				if !( cValToChar(aProtheus[i][2]) == cValToChar(aFolCer[nPos][4]))
					lUpd := .T.
					conout("Cargo_ApiID diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][2]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][4]))
				endif
				if !(aProtheus[i][3] == aFolCer[nPos][6])
					lUpd := .T.
					conout("Departamento_ApiID diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][3]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][6]))
				endif
				if !(aProtheus[i][4] == aFolCer[nPos][8])
					lUpd := .T.
					conout("CentroCusto_ApiID diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][4]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][9]))
				endif
				if !(aProtheus[i][5] == aFolCer[nPos][9])
					lUpd := .T.
					conout("Nome diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][5]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][9]))
				endif
				if !(cValToChar(aProtheus[i][6]) == cValToChar(aFolCer[nPos][10]))
					lUpd := .T.
					conout("Status diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][6])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][10]))
				endif
				if !(cValToChar(aProtheus[i][7]) == cValToChar(aFolCer[nPos][11]))
					lUpd := .T.
					conout("OrigemDefinicoes diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][7])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][11]))
				endif
				if !(aProtheus[i][8] == cValToChar(aFolCer[nPos][12]))
					lUpd := .T.
					conout("DataAdmissao diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][8])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][12]))
				endif
				if !(cValToChar(aProtheus[i][9]) == cValToChar(aFolCer[nPos][14]))
					lUpd := .T.
					conout("Regime diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][9])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][12]))
				endif
				if !(cValToChar(aProtheus[i][10]) == cValToChar(aFolCer[nPos][15]))
					lUpd := .T.
					conout("Funcional diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][10]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][12]))
				endif
				if !(cValToChar(aProtheus[i][11]) == cValToChar(aFolCer[nPos][17]))
					lUpd := .T.
					conout("Email diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][11]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][17]))
				endif
				if !(aProtheus[i][12] == cValToChar(aFolCer[nPos][23]))
					lUpd := .T.
					conout("DataNascimento diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][12]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][23]))
				endif
				if !(cValToChar(aProtheus[i][13]) == cValToChar(aFolCer[nPos][24]))
					lUpd := .T.
					conout("RG diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][13])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][24]))
				endif
				if !(cValToChar(aProtheus[i][14]) == cValToChar(aFolCer[nPos][25]))
					lUpd := .T.
					conout("PIS diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][14]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][25]))
				endif
				if !(aProtheus[i][15] == aFolCer[nPos][26])
					lUpd := .T.
					conout("CPF diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][15]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][26]))
				endif
				if !(cValToChar(aProtheus[i][16]) == cValToChar(aFolCer[nPos][27]))
					lUpd := .T.
					conout("ReceberNotificacoes diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][16]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][27]))
				endif
				if !(cValToChar(aProtheus[i][17]) == cValToChar(aFolCer[nPos][28]))
					lUpd := .T.
					conout("ReceberNotificacoesFerias diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][17]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][28]))
				endif
				if !(cValToChar(aProtheus[i][18]) == cValToChar(aFolCer[nPos][29]))
					lUpd := .T.
					conout("ReceberNotificacoesDayOff diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][18]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][29]))
				endif
				if !(cValToChar(aProtheus[i][19]) == cValToChar(aFolCer[nPos][30]))
					lUpd := .T.
					conout("ReceberNotificacoesRecesso diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][19]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][30]))
				endif
				if !(cValToChar(aProtheus[i][20]) == cValToChar(aFolCer[nPos][31]))
					lUpd := .T.
					conout("ReceberNotificacoesAvisoAusencia diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][20]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][31]))
				endif
				if ( valtype(aFolCer[nPos][41]) == "U" )
					lUpd := .T.
					conout("Sem configuracao!")
				else
					iif(!aFolCer[nPos][41][01][2], lUpd := .T., nil ) // MarcarPonto
					iif( aFolCer[nPos][41][02][2], lUpd := .T., nil )  // HabilitarAusencia
					iif( aFolCer[nPos][41][03][2], lUpd := .T., nil )  // RegistrarPontoSomenteComFoto
					iif(!aFolCer[nPos][41][04][2], lUpd := .T., nil )  // ForcarLoginAparelhoUnico
					iif(!aFolCer[nPos][41][05][2], lUpd := .T., nil )  // MarcacaoAutomaticaIntervaloAlmoco
					iif(!aFolCer[nPos][41][06][2], lUpd := .T., nil )  // RegistrarPontoSomenteLocalTrabalho
					iif(!aFolCer[nPos][41][07][2], lUpd := .T., nil )  // UtilizarWiFi
					iif( aFolCer[nPos][41][08][2], lUpd := .T., nil )  // UtilizarBeacon
					iif(!aFolCer[nPos][41][09][2], lUpd := .T., nil )  // UtilizarGPS
					iif(!aFolCer[nPos][41][10][2], lUpd := .T., nil )  // HabilitarMarcacaoPelaWeb
					iif(!aFolCer[nPos][41][11][2], lUpd := .T., nil )  // HabilitarTravaPorIP
					iif(!aFolCer[nPos][41][12][2], lUpd := .T., nil )  // HabilitarTravaPorGPS
					iif(!aFolCer[nPos][41][13][2], lUpd := .T., nil )  // HabilitarTravaPorIPApp
					if lUpd
						conout("Configuracao invalida!")
					endif
				endif
				if lUpd
					putFunc(aProtheus[i], aFolCer[nPos][1])
				endif
			endif
		next i
	endif
return

static function postFunc( aFunc )
	local aField := { "ApiID", "Cargo_ApiID", "Departamento_ApiID", "CentroCusto_ApiID", "Nome", "Status", "OrigemDefinicoes", "DataAdmissao", "Regime", "Funcional", "Email", "DataNascimento", "RG", "PIS", "CPF", "ReceberNotificacoes", "ReceberNotificacoesFerias", "ReceberNotificacoesDayOff", "ReceberNotificacoesRecesso", "ReceberNotificacoesAvisoAusencia", "Configuracao"}
	local oRestClient := nil
	local cBody := ""
	local cConf := retCfgPon()

	default aFunc := {}

	aAdd(aFunc, 9999999 )

	U_json( @cBody, aFunc, aField, "" )

	cBody := replace( cBody, "9999999", cConf )

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Usuarios" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou funcionario:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "POST", "funcionario", aFunc[1])
	else
		conout("erro ao gravar funcionario:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "POST", "funcionario", aFunc[1])
	endif
	FreeObj( oRestClient )
return

static function putFunc( aFunc, cId )
	local aField := { "ApiID", "Cargo_ApiID", "Departamento_ApiID", "CentroCusto_ApiID", "Nome", "Status", "OrigemDefinicoes", "DataAdmissao", "Regime", "Funcional", "Email", "DataNascimento", "RG", "PIS", "CPF", "ReceberNotificacoes", "ReceberNotificacoesFerias", "ReceberNotificacoesDayOff", "ReceberNotificacoesRecesso", "ReceberNotificacoesAvisoAusencia", "Id", "Configuracao"}
	local oRestClient := nil
	local cBody := ""
	local cConf := retCfgPon()

	default aFunc := {}
	default cId := ""

	aAdd(aFunc, cValToChar(cId))
	aAdd(aFunc, 9999999 )

	U_json( @cBody, aFunc, aField, '' )

	cBody := replace( cBody, "9999999", cConf )

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Usuarios" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou funcionario:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "PUT", "funcionario", aFunc[1])
	else
		conout("erro ao gravar funcionario:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "PUT", "funcionario", aFunc[1])
	endif
	FreeObj( oRestClient )
return

static function getFFunc()
	local oRestClient := nil

	local cJson := ""
	local oJHM := nil
	local aJson := {}
	local oJson := nil
	local nJson := 0
	local aLstFunc := {}
	local aFunc := {}
	local i := 0
	local j := 0
	local aAux := {}

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Usuarios?quantidade=99999" )
	oRestClient:setPath( "" )

	if oRestClient:Get( aREST_HEADER )
		cJson := oRestClient:GetResult()

		oJson := tJsonParser():New()
		oJson:Json_Hash(cJson, len(cJson), @aJson, @nJson, @oJHM)

		if len(aJson) > 0
			aLstFunc := aJson[1]

			for i := 1 to len(aLstFunc)
				aAux := {}
				for j := 1 to len(aLstFunc[i][2])
					if( len(aLstFunc[i][2][j]) > 1 )
						aAdd(aAux, aLstFunc[i][2][j][2] )
					else
						aAdd(aAux, nil ) 
					endif
				next j
				aAdd(aFunc,  aAux )
			next i
		endif

		u_logFlCer(.F., cJson, "GET", "funcionario")
	else
		u_logFlCer(.T., oRestClient:GetLastError(), "GET", "funcionario")
	endif
	FreeObj( oRestClient )

return aFunc

static function getPFunc()
	local aAux 		 := {}
	local aFunc    := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	cQuery := " SELECT "
	cQuery += " 	SRA.RA_FILIAL || SRA.RA_MAT	ApiID, " //01
	cQuery += " 	SRA.RA_CODFUNC Cargo, "				//02
	cQuery += " 	SRA.RA_CC Departamento_ApiID, " //03
	cQuery += " 	'07' CentroCusto_ApiID, "		//04
	cQuery += " 	SRA.RA_NOME Nome, "			//05
	cQuery += " 	1 Status, "	//06
	cQuery += " 	2 OrigemDefinicoes, "	//07
	cQuery += " 	SRA.RA_ADMISSA DataAdmissao, " //08
	cQuery += " 	0 Regime, " //09
	cQuery += " 	SRA.RA_MAT Funcional, " //10
	cQuery += " 	SRA.RA_EMAIL Email, " //11
	cQuery += " 	SRA.RA_NASC DataNascimento, " //12
	cQuery += " 	SRA.RA_RG RG, " //13
	cQuery += " 	SRA.RA_PIS PIS, " //14
	cQuery += " 	SRA.RA_CIC CPF " //15
	cQuery += " FROM  "
	cQuery += " 	"+RetSqlName('SRA')+" SRA "
	cQuery += " WHERE  "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SRA.RA_REGRA <> '99' "
	cQuery += " 	AND SRA.RA_DEMISSA = '' "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, alltrim( (cAlias)->ApiID ) ) //01
			aAdd( aAux, (cAlias)->Cargo ) //02
			aAdd( aAux, (cAlias)->Departamento_ApiID ) //03
			aAdd( aAux, (cAlias)->CentroCusto_ApiID ) //04
			aAdd( aAux, alltrim(Capital( (cAlias)->Nome ) ) ) //05
			aAdd( aAux, (cAlias)->Status ) //06
			aAdd( aAux, (cAlias)->OrigemDefinicoes ) //07
			aAdd( aAux, fDDMMYYYY( (cAlias)->DataAdmissao ) ) //08
			aAdd( aAux, (cAlias)->Regime ) //09
			aAdd( aAux, (cAlias)->Funcional ) //10
			aAdd( aAux, alltrim((cAlias)->Email) ) //11
			aAdd( aAux, fDDMMYYYY((cAlias)->DataNascimento) ) //12
			aAdd( aAux, alltrim((cAlias)->RG )) //13
			aAdd( aAux, alltrim((cAlias)->PIS) ) //14
			aAdd( aAux,  Transform( (cAlias)->CPF, "@R 999.999.999-99" ) ) //15
			aAdd( aAux, .T. ) //16 ReceberNotificacoes
			aAdd( aAux, .T. ) //17 ReceberNotificacoesFerias
			aAdd( aAux, .T. ) //18 ReceberNotificacoesDayOff
			aAdd( aAux, .T. ) //19 ReceberNotificacoesRecesso
			aAdd( aAux, .T. ) //20 ReceberNotificacoesAvisoAusencia

			aAdd( aFunc, aAux)
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif

	return aFunc

	static funct fDDMMYYYY( cDate )
	local cRet := ""
	default cDate := ""
	if !empty(cDate)
		cRet := substr( cDate, 7, 2 )+"/"+substr( cDate, 5, 2 )+"/"+substr( cDate, 1, 4 )
	endif
return cRet

static function retCfgPon()
	local aField :=  {}
	local aFill  := {}
	local cJson  := ""

	aAdd( aField, "MarcarPonto" )
	aAdd( aField, "HabilitarAusencia")
	aAdd( aField, "RegistrarPontoSomenteComFoto")
	aAdd( aField, "ForcarLoginAparelhoUnico")
	aAdd( aField, "MarcacaoAutomaticaIntervaloAlmoco")
	aAdd( aField, "RegistrarPontoSomenteLocalTrabalho")
	aAdd( aField, "UtilizarWiFi")
	aAdd( aField, "UtilizarBeacon")
	aAdd( aField, "UtilizarGPS")
	aAdd( aField, "HabilitarMarcacaoPelaWeb")
	aAdd( aField, "HabilitarTravaPorIP")
	aAdd( aField, "HabilitarTravaPorGPS")
	aAdd( aField, "HabilitarTravaPorIPApp")

	aAdd( aFill, .T. ) // MarcarPonto
	aAdd( aFill, .F. ) // HabilitarAusencia
	aAdd( aFill, .F. ) // RegistrarPontoSomenteComFoto
	aAdd( aFill, .T. ) // ForcarLoginAparelhoUnico
	aAdd( aFill, .T. ) // MarcacaoAutomaticaIntervaloAlmoco
	aAdd( aFill, .T. ) // RegistrarPontoSomenteLocalTrabalho
	aAdd( aFill, .T. ) // UtilizarWiFi
	aAdd( aFill, .F. ) // UtilizarBeacon
	aAdd( aFill, .T. ) // UtilizarGPS
	aAdd( aFill, .T. ) // HabilitarMarcacaoPelaWeb
	aAdd( aFill, .T. ) // HabilitarTravaPorIP
	aAdd( aFill, .T. ) // HabilitarTravaPorGPS
	aAdd( aFill, .T. ) // HabilitarTravaPorIPApp

	U_json( @cJson, aFill, aField, "", {0, {1}} )
return cJson

////////////////////


static function getFDepto()
	local oRestClient := nil

	local cJson := ""
	local oJHM := nil
	local aJson := {}
	local oJson := nil
	local nJson := 0
	local aLstDepto := {}
	local aDepto := {}
	local i := 0
	local j := 0
	local aAux := {}

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Departamentos?quantidade=99999" )
	oRestClient:setPath( "" )

	if oRestClient:Get( aREST_HEADER )
		cJson := oRestClient:GetResult()

		oJson := tJsonParser():New()
		oJson:Json_Hash(cJson, len(cJson), @aJson, @nJson, @oJHM)

		if len(aJson) > 0
			aLstDepto := aJson[1]

			for i := 1 to len(aLstDepto)
				aAux := {}
				for j := 1 to len(aLstDepto[i][2])
					aAdd(aAux, aLstDepto[i][2][j][2] )
				next j
				aAdd(aDepto,  aAux )
			next i
		endif
		u_logFlCer(.F., cJson, "GET", "departamento")
	else
		u_logFlCer(.T., oRestClient:GetLastError(), "GET", "departamento")
	endif
	FreeObj( oRestClient )
return aDepto

static function delCC(aFunc)

	local aDepto := getFDepto()
	local i := 1
	local oRestClient := nil

	for i := 1 to len(aDepto)
		nPos := aScan(aFunc, {|x| x[6] == aDepto[i][2] })
		if nPos == 0
			conout("tentando deletar o departamento: "+cValToChar(aDepto[i][2])+" - "+cValToChar(aDepto[i][3]))
			oRestClient := FWRest():New( "https://api.folhacerta.com/api/Departamentos?Id="+cValToChar(aDepto[i][1]) )
			oRestClient:setPath( "" )
			//oRestClient:SetPostParams( cBody )

			if oRestClient:Delete( aREST_HEADER )
				conout("deletou departamento:"+CRLF)

			else
				conout("erro ao deletar departamento:"+CRLF+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)

			endif
			FreeObj( oRestClient )


		endif
	next i				
return

