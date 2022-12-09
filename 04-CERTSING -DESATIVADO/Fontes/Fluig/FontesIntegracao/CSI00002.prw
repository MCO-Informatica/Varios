#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE	4

#DEFINE nTRANSLADO 1

user function CSI00002( nTipoRequi, filial, matricula, dIni, dFim, hIni, hFim, abono )
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_POST
		cRetorno := CSIPost(nTIPO_REQUISICAO_POST, filial, matricula, dIni, dFim, hIni, hFim, abono )
	elseif nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet(nTIPO_REQUISICAO_GET )
	endif
return cRetorno

static function CSIGet()
	local aAux 		 := {}
	local aFunc		 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

    cQuery := "	SELECT "
    cQuery += "		P6_CODIGO, "
    cQuery += "		P6_DESC, "
    cQuery += "		P6_PREABO, "
    cQuery += "		P6_PORTAL "
    cQuery += "	FROM "+RetSqlName("SP6")
    cQuery += "	WHERE "
    cQuery += "		D_E_L_E_T_ = ' ' "
    cQuery += "	ORDER BY "
    cQuery += "		P6_DESC "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		CONOUT("# CSI00002: Gerando lista de abonos. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->P6_CODIGO )
			aAdd( aAux, Capital( (cAlias)->P6_DESC 	) )
			aAdd( aAux, (cAlias)->P6_PREABO )
			aAdd( aAux, (cAlias)->P6_PORTAL	 	)
			aAdd( aFunc, aAux)
			(cAlias)->( dbSkip() )
		end
		CONOUT("# CSI00002: Gerando lista de abonos. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
	endif

	aAdd( aProp, 'P6_CODIGO' )
	aAdd( aProp, 'P6_DESC'   )
	aAdd( aProp, 'P6_PREABO' )
	aAdd( aProp, 'P6_PORTAL' )

	U_json( @cRetorno, aFunc, aProp, 'listaAbono' )
return cRetorno

static function CSIPost(nTipoRequi, filial, matricula, dIni, dFim, hIni, hFim, abono )
	local aAux 		 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	Default filial 	  := ""
	Default matricula := ""
	Default dIni	  := ""
	Default dFim 	  := ""
	Default hIni 	  := 0
	Default hFim 	  := 0
	Default abono     := "001"

	if !Empty( filial ) .And. !Empty( matricula ) .And. !Empty( dIni ) .And. !Empty( dFim )
		dIni := ctod( dIni )
		dFim := ctod( dFim )

		cQuery := " SELECT
		cQuery += " 	R_E_C_N_O_  REC
		cQuery += " FROM
		cQuery += " 	"+RetSqlName('RF0')+" RF0 "
		cQuery += " WHERE
		cQuery += " 	RF0.D_E_L_E_T_ = ' '
		cQuery += " 	AND RF0.RF0_FILIAL = '" + filial + "'
		cQuery += " 	AND RF0.RF0_MAT    = '" + matricula + "'
		cQuery += " 	AND RF0.RF0_DTPREI = '" + dToS( dIni ) + "'
		cQuery += " 	AND RF0.RF0_DTPREF = '" + dToS( dFim ) + "'

		if !Empty( dIni ) .And. !Empty( dFim ) .and. dIni == dFim .and. hIni != 0 .and. hFim != 0
			hIni := hIni - nTRANSLADO
			hFim := hFim + nTRANSLADO

			if hIni < 0
				hIni := 0
			endif
			if hFim < 0
				hFim := 0
			endif

			if hIni > 24
				hIni := 24
			endif
			if hFim > 24
				hFim := 24
			endif

			cQuery += " 	AND RF0.RF0_HORINI = '" + cValToChar(hIni) + "'
			cQuery += " 	AND RF0.RF0_HORFIM = '" + cValToChar(hFim) + "'
		endif

		//Executa consulta SQL
		CONOUT("# CSI00002: Filial: "+filial+" Matricula: "+matricula+" Data Atestado: "+dToC(dIni)+" Incluindo Pre-abono. Data e hora Inicio: "+dToC(dDataBase)+" - "+Time() )
		if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
			RF0->( dbGoTo( (cAlias)->REC ) )
			if RF0->( !EoF() )
				RecLock('RF0', .F.)
				RF0->RF0_FILIAL := filial
				RF0->RF0_MAT    := matricula
				RF0->RF0_DTPREI := dIni
				RF0->RF0_DTPREF := dFim
				RF0->RF0_HORINI := hIni
				RF0->RF0_HORFIM := hFim
				RF0->RF0_CODABO := abono
				RF0->RF0_HORTAB := 'N'
				RF0->RF0_ABONA  := 'N'
				RF0->( MsUnLock() )
			endif
		else
			RecLock('RF0', .T.)
			RF0->RF0_FILIAL := filial
			RF0->RF0_MAT    := matricula
			RF0->RF0_DTPREI := dIni
			RF0->RF0_DTPREF := dFim
			RF0->RF0_HORINI := hIni
			RF0->RF0_HORFIM := hFim
			RF0->RF0_CODABO := '001'
			RF0->RF0_HORTAB := 'N'
			RF0->RF0_ABONA  := 'N'
			RF0->( MsUnLock() )
		endif

		aAdd( aProp, 'filial')
		aAdd( aProp, 'matricula')
		aAdd( aProp, 'dIni')
		aAdd( aProp, 'dFim')
		aAdd( aProp, 'hIni')
		aAdd( aProp, 'hFim')
		aAdd( aProp, 'abono')
		aAdd( aProp, 'status')

		aAdd( aAux, RF0->RF0_FILIAL )
		aAdd( aAux, RF0->RF0_MAT    )
		aAdd( aAux, RF0->RF0_DTPREI )
		aAdd( aAux, RF0->RF0_DTPREF )
		aAdd( aAux, RF0->RF0_HORINI )
		aAdd( aAux, RF0->RF0_HORFIM )
		aAdd( aAux, RF0->RF0_CODABO )
		aAdd( aAux, "ok" )

		U_json( @cRetorno, aAux, aProp, 'preAbono' )
		CONOUT("# CSI00002: Filial: "+filial+" Matricula: "+matricula+" Data Atestado: "+dToC(dIni)+" Incluindo Pre-abono. Data e hora Fim: "+dToC(dDataBase)+" - "+Time() )
	endif
Return(cRetorno)


