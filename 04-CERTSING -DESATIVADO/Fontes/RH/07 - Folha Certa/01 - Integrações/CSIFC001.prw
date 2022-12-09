#INCLUDE 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FILEIO.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE aREST_HEADER {"apiKey:362E80D4DF43B03AE6D3F8540CD63626", "Content-Type:application/json; charset=utf-8"}
#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "07"

user function CSIFC001(lDebug)
	default lDebug := .T.
	if lDebug
		rpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL
		sncLocTrab()
		RESET ENVIRONMENT
	else
		sncLocTrab()
	endif
return

static function sncLocTrab( )
	local aPLocTrab := {}
	local aFLocTrab := {}

	aPLocTrab := getPLocTra()
	aFLocTrab := getFLocTra()

	procLocTra(aPLocTrab, aFLocTrab)
return

static function procLocTra(aProtheus, aFolCer)
	local i    := 0
	local nPos := 0
	local lUpd := .F.

	default aProtheus := {}
	default aFolCer   := {}

	if len(aProtheus) > 0 .and. len(aFolCer) > 0
		for i := 1 to len(aProtheus)
			nPos := aScan(aFolCer, {|x| x[2] == aProtheus[i][1] })

			if nPos == 0
				postLocTra(aProtheus[i])
			else
				if !(aProtheus[i][2] == aFolCer[nPos][3])
					lUpd := .T.
					conout("Nome diferente:"+CRLF+"--Protheus..: "+aProtheus[i][2]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][3]))
				endif
				if !(aProtheus[i][3] == aFolCer[nPos][4])
					lUpd := .T.
					conout("Matriz diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][3])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][4]))
				endif
				if !(aProtheus[i][4] == aFolCer[nPos][6])
					lUpd := .T.
					conout("CNPJ diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][4])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][6]))
				endif
				if !(aProtheus[i][5] == aFolCer[nPos][7])
					lUpd := .T.
					conout("Telefone diferente:"+CRLF+"-- Protheus..: "+cValToChar(aProtheus[i][5])+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][7]))
				endif
				if !(aProtheus[i][6] == aFolCer[nPos][8])
					lUpd := .T.
					conout("CEP diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][6]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][8]))
				endif
				if !(aProtheus[i][7] == aFolCer[nPos][9])
					lUpd := .T.
					conout("Endereco diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][7]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][9]))
				endif
				if !(aProtheus[i][8] == aFolCer[nPos][10])
					lUpd := .T.
					conout("Numero diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][8]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][10]))
				endif
				if !(aProtheus[i][9] == aFolCer[nPos][11])
					lUpd := .T.
					conout("Complemento diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][9]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][11]))
				endif
				if !(aProtheus[i][10] == aFolCer[nPos][12])
					lUpd := .T.
					conout("Bairro diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][10]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][12]))
				endif
				if !(aProtheus[i][12] == aFolCer[nPos][16])
					if !(aProtheus[i][12] $ "Sao Paulo/Brasilia/Goiania")
						lUpd := .T.
						conout("Cidade diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][12]+CRLF+"-- FolhaCerta: "+cValToChar(aFolCer[nPos][16]))
					endif
				endif
				if !(aProtheus[i][13] == aFolCer[nPos][17])
					lUpd := .T.
					conout("Estado diferente:"+CRLF+"-- Protheus..: "+aProtheus[i][13]+CRLF+"--FolhaCerta: "+cValToChar(aFolCer[nPos][17]))
				endif

				if lUpd
					putLocTrab(aProtheus[i], aFolCer[nPos][1])
				endif
			endif
		next i
	endif
return

static function postLocTra( aLocTrab )
	local aField := { "ApiID", "Nome", "Matriz", "CNPJ", "Telefone", "CEP", "Endereco", "Numero", "Complemento", "Bairro", "RaioToleranciaGPSMetros", "Cidade", "Estado" }
	local oRestClient := nil
	local cBody := ""

	default aLocTrab := {}

	U_json( @cBody, aLocTrab, aField, '' )

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/LocaisTrabalho" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou local de trabalho:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "POST", "localTrabalho", aLocTrab[1])
	else
		conout("erro ao gravar local de trabalho:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "POST", "localTrabalho", aLocTrab[1])
	endif
	FreeObj( oRestClient )
return

static function putLocTrab( aLocTrab, cId )
	local aField := { "ApiID", "Nome", "Matriz", "CNPJ", "Telefone", "CEP", "Endereco", "Numero", "Complemento", "Bairro", "Cidade", "Estado", "Id" }
	local oRestClient := nil
	local cBody := ""

	default aLocTrab := {}
	default cId := ""

	ADel( aLocTrab, 11 ) //Removo o GPS
	ASize( aLocTrab, 12 )

	aAdd(aLocTrab, cId)

	U_json( @cBody, aLocTrab, aField, '' )

	if !(aLocTrab[12] == "Sao Paulo")
		cBody := replace( cBody, "Sao Paulo", "São Paulo")
	endif
	if !(aLocTrab[12] == "Brasilia")
		cBody := replace( cBody, "Brasilia", "Brasília")
	endif
	if !(aLocTrab[12] == "Goiania")
		cBody := replace( cBody, "Goiania", "Goiânia")
	endif

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/LocaisTrabalho" )
	oRestClient:setPath( "" )
	oRestClient:SetPostParams( cBody )

	if oRestClient:Post( aREST_HEADER )
		conout("gravou local de trabalho:"+CRLF+cBody)
		u_logFlCer(.F., cBody, "PUT", "localTrabalho", aLocTrab[1])
	else
		conout("erro ao gravar local de trabalho:"+CRLF+cBody+CRLF+"erro: "+oRestClient:GetLastError()+CRLF+"erro 2: "+oRestClient:cResult)
		u_logFlCer(.T., cBody, "PUT", "localTrabalho", aLocTrab[1])
	endif
	FreeObj( oRestClient )
return

static function getFLocTra()
	local oRestClient := nil

	local cJson := ""
	local oJHM := nil
	local aJson := {}
	local oJson := nil
	local nJson := 0
	local aLstLTrab := {}
	local aLocTrab := {}
	local i := 0
	local j := 0
	local aAux := {}

	oRestClient := FWRest():New( "https://api.folhacerta.com/api/LocaisTrabalho" )
	oRestClient:setPath( "" )

	if oRestClient:Get( aREST_HEADER )
		cJson := oRestClient:GetResult()

		oJson := tJsonParser():New()
		oJson:Json_Hash(cJson, len(cJson), @aJson, @nJson, @oJHM)

		if len(aJson) > 0
			aLstLTrab := aJson[1]

			for i := 1 to len(aLstLTrab)
				aAux := {}
				for j := 1 to len(aLstLTrab[i][2])
					aAdd(aAux, aLstLTrab[i][2][j][2] )
				next j
				aAdd(aLocTrab,  aAux )
			next i
		endif
		u_logFlCer(.F., cJson, "GET", "localTrabalho")
	else
		u_logFlCer(.T., oRestClient:GetLastError(), "GET", "localTrabalho")
	endif
	FreeObj( oRestClient )
return aLocTrab

static function getPLocTra()
	local aAux 		 := {}
	local aLocTra    := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	cQuery  	 := " SELECT "
	cQuery  	 += " RCC_SEQUEN ApiID, " //01
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 001, 30) Nome, " //02
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 001, 30) Matriz, " //03
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 206, 18) CNPJ, " //04
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 158, 13) Telefone, " //05
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 139, 09) CEP, " //06
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 031, 30) Endereco, " //07
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 061, 06) Numero, " //08
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 067, 30) Complemento, " //09
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 097, 20) Bairro, " //10
	cQuery  	 += " 100 GPSMETROS, " //11
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 117, 20) Cidade, " //12
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 137, 2) Estado " //13
	cQuery  	 += " FROM
	cQuery  	 += " 	"+RetSqlName('RCC')+" RCC "
	cQuery  	 += " WHERE
	cQuery  	 += " 	RCC_CODIGO = 'U006'
	cQuery  	 += " 	AND D_E_L_E_T_ = ' '

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->ApiID ) //01
			aAdd( aAux, alltrim(Capital( (cAlias)->Nome 	))) //02
			aAdd( aAux, alltrim(Capital( (cAlias)->Matriz ) )) //03
			aAdd( aAux, noacento((cAlias)->CNPJ	 )	) //04
			aAdd( aAux, substr((cAlias)->Telefone,1,4)+space(1)+substr((cAlias)->Telefone,5) 	) //05
			aAdd( aAux, (cAlias)->CEP 	) //06
			aAdd( aAux, alltrim((cAlias)->Endereco 	)) //07
			aAdd( aAux, alltrim((cAlias)->Numero 	)) //08
			aAdd( aAux, noacento(alltrim((cAlias)->Complemento 	))) //09
			aAdd( aAux, alltrim((cAlias)->Bairro 	)) //10
			aAdd( aAux, (cAlias)->GPSMETROS 	) //11
			aAdd( aAux, alltrim(Capital( (cAlias)->Cidade 	) )) //12
			aAdd( aAux, (cAlias)->Estado 	)			 //13

			aAdd( aLocTra, aAux)
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif

return aLocTra