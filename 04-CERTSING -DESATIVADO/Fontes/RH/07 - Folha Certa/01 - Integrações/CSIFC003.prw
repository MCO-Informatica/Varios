#INCLUDE 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FILEIO.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE aREST_HEADER {"apiKey:362E80D4DF43B03AE6D3F8540CD63626", "Content-Type:application/json; charset=utf-8"}
#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "07"

user function CSIFC003(lDebug)
	default lDebug := .T.
	if lDebug
		rpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL
		sncCargo()
		RESET ENVIRONMENT
	else
		sncCargo()
	endif
return

static function sncCargo( )
	local aPCargo := {}
	local aFCargo := {}

	aPCargo := getPCargo() //Protheus
	aFCargo := getFCargo() //Folha Certa

	procCargo(aPCargo, aFCargo)
return

static function procCargo(aProtheus, aFolCer)
	local i    := 0
	local nPos := 0
	local lUpd := .F.

	default aProtheus := {}
	default aFolCer   := {}

	if len(aProtheus) > 0 .and. len(aFolCer) > 0
		for i := 1 to len(aProtheus)
			nPos := aScan(aFolCer, {|x| x[2] == aProtheus[i][1] })
			if nPos == 0
				postCargo(aProtheus[i])
			else
				if !(aProtheus[i][1] == aFolCer[nPos][2])
					lUpd := .T.
					conout("ApID diferente"+aFolCer[nPos][2])
				endif
				if !(aProtheus[i][2] == aFolCer[nPos][3])
					lUpd := .T.
					conout("Nome diferente: "+aProtheus[i][2])
				endif
				if lUpd
					putCargo(aProtheus[i], aFolCer[nPos][1])
				endif
			endif
		next i
	endif
return

static function postCargo( aCargo )
	local aField := { "ApiID", "Nome" }
	local oRestClient := nil
	local cBody := ""

	default aCargo := {}

	U_json( @cBody, aCargo, aField, "" )

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Cargos" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou cargos:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "POST", "cargo", aCargo[1])
	else
		conout("erro ao gravar cargos:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "POST", "cargo", aCargo[1])
	endif
	FreeObj( oRestClient )
return

static function putCargo( aCargo, cId )
	local aField := { "ApiID", "Nome", "Id"}
	local oRestClient := nil
	local cBody := ""

	default aCargo := {}
	default cId := ""

	aAdd(aCargo, cValToChar(cId))

	U_json( @cBody, aCargo, aField, '' )

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Cargos" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou cargos:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "PUT", "cargo", aCargo[1])
	else
		conout("erro ao gravar cargos:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "PUT", "cargo", aCargo[1])
	endif
	FreeObj( oRestClient )
return

static function getFCargo()
	local oRestClient := nil

	local cJson := ""
	local oJHM := nil
	local aJson := {}
	local oJson := nil
	local nJson := 0
	local aLstCargo := {}
	local aCargo := {}
	local i := 0
	local j := 0
	local aAux := {}

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/Cargos?quantidade=99999" )
	oRestClient:setPath( "" )

	if oRestClient:Get( aREST_HEADER )
		cJson := oRestClient:GetResult()

		oJson := tJsonParser():New()
		oJson:Json_Hash(cJson, len(cJson), @aJson, @nJson, @oJHM)

		if len(aJson) > 0
			aLstCargo := aJson[1]

			for i := 1 to len(aLstCargo)
				aAux := {}
				for j := 1 to len(aLstCargo[i][2])
					aAdd(aAux, aLstCargo[i][2][j][2] )
				next j
				aAdd(aCargo,  aAux )
			next i
		endif

		u_logFlCer(.F., cJson, "GET", "cargo")
	else
		u_logFlCer(.T., oRestClient:GetLastError(), "GET", "cargo")
	endif
	FreeObj( oRestClient )

return aCargo

static function getPCargo()
	local aAux 		 := {}
	local aCargo     := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	cQuery  	 := " SELECT "
	cQuery  	 += " 	SRJ.RJ_FUNCAO ApiId, "
	cQuery  	 += " 	SRJ.RJ_DESC Nome"
	cQuery  	 += " FROM "
	cQuery  	 += " 	"+RetSqlName('SRJ')+" SRJ "
	cQuery  	 += " WHERE "
	cQuery  	 += " 	SRJ.D_E_L_E_T_ = ' ' "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, alltrim((cAlias)->ApiID) ) //01
			aAdd( aAux, NoAcento( alltrim(Capital( (cAlias)->Nome 	)))) //02

			aAdd( aCargo, aAux)
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif

return aCargo