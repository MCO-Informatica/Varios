#INCLUDE 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FILEIO.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE aREST_HEADER {"apiKey:362E80D4DF43B03AE6D3F8540CD63626", "Content-Type:application/json; charset=utf-8"}
#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "07"

user function CSIFC002(lDebug)
	default lDebug := .T.
	if lDebug
		rpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL
		sncDepto()
		RESET ENVIRONMENT
	else
		sncDepto()
	endif
return

static function sncDepto( )
	local aPDepto := {}
	local aFDepto := {}

	aPDepto := getPDepto() //Protheus
	aFDepto := getFDepto() //Folha Certa

	procDepto(aPDepto, aFDepto)
return

static function procDepto(aProtheus, aFolCer)
	local i    := 0
	local nPos := 0
	local lUpd := .F.

	default aProtheus := {}
	default aFolCer   := {}

	if len(aProtheus) > 0 .and. len(aFolCer) > 0
		for i := 1 to len(aProtheus)
			nPos := aScan(aFolCer, {|x| x[2] == aProtheus[i][1] })
			if nPos == 0
				postDepto(aProtheus[i])
			else
				if !(aProtheus[i][1] == aFolCer[nPos][2])
					lUpd := .T.
					conout("ApID diferente"+aFolCer[nPos][2])
				endif
				if !(aProtheus[i][2] == aFolCer[nPos][3])
					lUpd := .T.
					conout("Nome diferente: "+aProtheus[i][2])
				endif
				if ( valtype(aFolCer[nPos][8]) == "U" )
					lUpd := .T.
					conout("Sem configuração!")
				endif
				if lUpd
					putDepto(aProtheus[i], aFolCer[nPos][1])
				endif
			endif
		next i
	endif
return

static function postDepto( aDepto )
	local aField := { "ApiID", "Nome" , "Configuracao"}
	local oRestClient := nil
	local cBody := ""
	local cConf := retCfgPon()

	default aDepto := {}

	aAdd(aDepto, 9999999 )

	U_json( @cBody, aDepto, aField, "" )

	cBody := replace( cBody, "9999999", cConf )

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Departamentos" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou departamento:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "POST", "departamento", aDepto[1])
	else
		conout("erro ao gravar departamento:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "POST", "departamento", aDepto[1])
	endif
	FreeObj( oRestClient )
return

static function putDepto( aDepto, cId )
	local aField := { "ApiID", "Nome", "Id", "Configuracao"}
	local oRestClient := nil
	local cBody := ""
	local cConf := retCfgPon()

	default aDepto := {}
	default cId := ""


	aAdd(aDepto, cId)
	aAdd(aDepto, 9999999 )

	U_json( @cBody, aDepto, aField, "" )

	cBody := replace( cBody, "9999999", cConf )


	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Departamentos" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou departamento:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "PUT", "departamento", aDepto[1])
	else
		conout("erro ao gravar departamento:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "PUT", "departamento", aDepto[1])
	endif
	FreeObj( oRestClient )
return

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

static function getPDepto()
	local aAux 		 := {}
	local aDepto    := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	cQuery := " SELECT "
	//Id
	cQuery += " 	CTT.CTT_CUSTO ApiId, "
	cQuery += " 	CTT.CTT_DESC01 Nome"
	//DepartamentoSuperior_id
	//DepartamentoSuperior_ApiId
	//UsuariosGestores_Ids
	//UsuariosGestores_ApiIDs
	//Configuracao
	cQuery += " FROM "
	cQuery += " 	"+RetSqlName('CTT')+" CTT "
	cQuery += " INNER JOIN "+RetSqlName('SRA')+" SRA ON "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SRA.RA_CC = CTT.CTT_CUSTO "
	cQuery += " 	AND SRA.RA_REGRA <> '99' "
	cQuery += " 	AND SRA.RA_DEMISSA = '' "
	
	cQuery  	 += " WHERE "
	cQuery  	 += " 	CTT.D_E_L_E_T_ = ' ' "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->ApiID ) //01
			aAdd( aAux, NoAcento( alltrim(Capital( (cAlias)->Nome 	)))) //02

			aAdd( aDepto, aAux)
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif

return aDepto


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