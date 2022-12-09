#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE	4

#DEFINE nTRANSLADO 1

user function CSI00007( nTipoRequi, filial, matricula, dIni, dFim, hIni, hFim, abono )
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
    cQuery += "		RF_FILIAL, "
    cQuery += "		RF_MAT, "
    cQuery += "		RA_NOME, "
    cQuery += "		RA_ADMISSA, "
    cQuery += "		RF_DFERVAT, "
    cQuery += "		RF_DFERANT, "
    cQuery += "		RF_DATABAS, "
    cQuery += "		RF_DATAFIM "
    cQuery += "	FROM  "
    cQuery += "		"+RetSqlName("SRF")+" SRF "
    cQuery += "	INNER JOIN "+RetSqlName("SRA")+" SRA ON "
    cQuery += "	    SRA.D_E_L_E_T_ = ' ' "
    cQuery += "		AND RA_FILIAL  = RF_FILIAL "
    cQuery += "		AND RA_MAT 	   = RF_MAT "
    cQuery += "		AND RA_DEMISSA = ' ' "
    cQuery += "	WHERE  "
    cQuery += "		SRF.D_E_L_E_T_ = ' ' "
    cQuery += "		AND RF_DFERVAT - RF_DFERANT > 0 "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		CONOUT("# CSI00007: Gerando lista de abonos. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->RF_FILIAL ) //1
			aAdd( aAux, (cAlias)->RF_MAT ) //2
			aAdd( aAux, Capital( (cAlias)->RA_NOME ) ) //3
			aAdd( aAux, dtoc( stod( (cAlias)->RA_ADMISSA ) ) ) //4
			aAdd( aAux, dtoc( stod( (cAlias)->RF_DATABAS ) ) ) //5
			aAdd( aAux, dtoc( stod( (cAlias)->RF_DATAFIM ) ) ) //6
			aAdd( aAux, (cAlias)->RF_DFERVAT ) //7
			aAdd( aAux, (cAlias)->RF_DFERANT ) //8
			
			aAdd( aFunc, aAux)
			(cAlias)->( dbSkip() )
		end
		CONOUT("# CSI00007: Gerando lista de ferias vencidas. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
	endif

	aAdd( aProp, 'filial' ) //1
	aAdd( aProp, 'matricula'   ) //2
	aAdd( aProp, 'nome' ) //3
	aAdd( aProp, 'admissao' ) //4
	aAdd( aProp, 'dtInicioFerias' ) //5
	aAdd( aProp, 'dtFimFerias' ) //6
	aAdd( aProp, 'qtdFeriasVencidas' ) //7
	aAdd( aProp, 'qtdFeriasAntecipadas' ) //8

	U_json( @cRetorno, aFunc, aProp, 'listaFerias' )
return cRetorno

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
		CONOUT("# CSI00007: Filial: "+filial+" Matricula: "+matricula+" Incluindo solicitacao ferias. Data e hora Fim: "+dToC(dDataBase)+" - "+Time() )
	endif
Return(cRetorno)