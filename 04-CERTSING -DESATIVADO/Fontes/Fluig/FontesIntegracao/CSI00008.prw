#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE	4

#DEFINE nTRANSLADO 1

user function CSI00008( nTipoRequi )
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_POST
		//cRetorno := CSIPost(nTIPO_REQUISICAO_POST, filial, matricula, dIni, dFim, hIni, hFim, abono )
	elseif nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet( nTIPO_REQUISICAO_GET )
	endif
return cRetorno

static function CSIGet( nTipoRequi )
	local aAux 		 := {}
	local aFunc		 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	
	default nTipoRequi := nTIPO_REQUISICAO_GET

	cQuery := " SELECT "
	cQuery += " 	RA_FILIAL, "
	cQuery += " 	RA_MAT, "
	cQuery += " 	RA_CC, "
	cQuery += " 	RA_NOME, "
	cQuery += " 	RA_NOMECMP, "
	cQuery += " 	RA_TNOTRAB, "
	cQuery += " 	RA_CODFUNC, "
	cQuery += " 	RA_SINDICA, "
	cQuery += " 	RA_ADMISSA, "
	cQuery += " 	RA_CIC, "
	cQuery += " 	RA_RG, "
	cQuery += " 	RA_NUMCP, "
	cQuery += " 	RA_SERCP, "
	cQuery += " 	RA_EMAIL "
	cQuery += " FROM "
	cQuery += " "+RetSQLName("SRA")+" SRA "
	cQuery += " WHERE "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RA_DEMISSA = ' ' "
   	cQuery += " 	AND RA_REGRA  <> '99' "              	//-> Regra 99 = Não marca ponto.
    cQuery += " 	AND RA_CATEFD NOT IN( '103', '901' ) "  //-> 103 = Menor Aprendiz / 901 = Estagiario, conforme EFD (eSocial).

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		CONOUT("# CSI00008: Gerando lista de funcionarios do ponto. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->RA_FILIAL ) //01
			aAdd( aAux, (cAlias)->RA_MAT 	) //02
			aAdd( aAux, (cAlias)->RA_CC 	) //03
			aAdd( aAux, Capital( (cAlias)->RA_NOME ) ) //04
			aAdd( aAux, (cAlias)->RA_TNOTRAB ) //05
			aAdd( aAux, (cAlias)->RA_CODFUNC ) //06
			aAdd( aAux, (cAlias)->RA_SINDICA ) //07
			aAdd( aAux, stod( (cAlias)->RA_ADMISSA ) ) //08
			aAdd( aAux, (cAlias)->RA_CIC 	 ) //09
			aAdd( aAux, (cAlias)->RA_RG 	 ) //10
			aAdd( aAux, (cAlias)->RA_NUMCP 	 ) //11
			aAdd( aAux, (cAlias)->RA_SERCP 	 ) //12
			aAdd( aAux, Capital( (cAlias)->RA_NOMECMP ) ) //13
			aAdd( aAux, lower( (cAlias)->RA_EMAIL ) ) //14
			aAdd( aFunc, aAux)
			(cAlias)->( dbSkip() )
		end
		CONOUT("# CSI00008: Gerando lista de funcionarios do ponto. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
	endif

	aAdd( aProp, 'filial' 		 ) //01
	aAdd( aProp, 'matricula'   	 ) //02
	aAdd( aProp, 'centroCusto'   ) //03
	aAdd( aProp, 'nome' 		 ) //04
	aAdd( aProp, 'turnoTrabalho' ) //05
	aAdd( aProp, 'codFuncao' 	 ) //06
	aAdd( aProp, 'codSindicato'  ) //07
	aAdd( aProp, 'admissao' 	 ) //08
	aAdd( aProp, 'cpf' 	 		 ) //09
	aAdd( aProp, 'rg' 	 		 ) //10
	aAdd( aProp, 'ctps' 	 	 ) //11			
	aAdd( aProp, 'ctpsSerie' 	 ) //12
	aAdd( aProp, 'nomeCompleto'  ) //13
	aAdd( aProp, 'email'  ) //14

	U_json( @cRetorno, aFunc, aProp, 'listaColaboradoresPonto' )
return cRetorno

/*
static function CSIPost(nTipoRequi, filial, matricula, dBaseFer, dIniGozo, dFimGozo, cAbonoPec, c13ParAnt )
	local aAux 		 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local lCriaDir   := .T.
	local lApaga     := .T.

	Default nTipoRequi := nTIPO_REQUISICAO_POST
	Default filial 	   := ""
	Default matricula  := ""
	Default dBaseFer   := ctod("//")
	Default dIniGozo   := ctod("//")
	Default dFimGozo   := ctod("//")
	Default cAbonoPec  := ""
	Default c13ParAnt  := ""

	if 	!Empty( filial ) .And. ;
		!Empty( matricula ) .And. ;
		!Empty( dBaseFer ) .And. ;
		!Empty( dIniGozo ) .And. ;
		!Empty( dIniGozo )  .And. ;
		!Empty( cAbonoPec )  .And. ;
		!Empty( c13ParAnt )  
		cTexto := "filial: "+filial+"; "
		cTexto += "matricula: "+matricula+"; "
		cTexto += "dBaseFer: "+dtos(dBaseFer)+"; "
		cTexto += "dIniGozo: "+dtos(dIniGozo)+"; "
		cTexto += "dFimGozo: "+dtos(dFimGozo)+"; "
		cTexto += "cAbonoPec: "+cAbonoPec+"; "
		cTexto += "c13ParAnt: "+c13ParAnt+"; "

		u_GerarArq(cTexto, "\fluig\solicitacao_ferias\"+filial+matricula+dtos(dBaseFer)+".txt", lCriaDir, lApaga)

		aAdd( aProp, 'filial')
		aAdd( aProp, 'matricula')
		aAdd( aProp, 'dBaseFerias')
		aAdd( aProp, 'dFim')
		aAdd( aProp, 'dIniGozo')
		aAdd( aProp, 'dFimGozo')
		aAdd( aProp, 'abonoPecuniario')
		aAdd( aProp, 'primeiraParcela13')

		aAdd( aAux, filial )
		aAdd( aAux, matricula    )
		aAdd( aAux, dBaseFer )
		aAdd( aAux, dIniGozo )
		aAdd( aAux, dFimGozo )
		aAdd( aAux, cAbonoPec )
		aAdd( aAux, c13ParAnt )
		aAdd( aAux, "ok" )

		U_json( @cRetorno, aAux, aProp, 'solicitacaoFerias' )
		CONOUT("# CSI00008: Filial: "+filial+" Matricula: "+matricula+" Incluindo solicitacao ferias. Data e hora Fim: "+dToC(dDataBase)+" - "+Time() )
	endif
Return(cRetorno)
*/