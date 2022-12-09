#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE 4

user function CSI00005(nTipoRequi, id)
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet(id)
	endif
return cRetorno

static function CSIGet(id)
	local aAux 		 := {}
	local aDepto	 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	Default id := ""

    cQuery := "	SELECT "
    cQuery += "		CTT_CUSTO, "
    cQuery += "		CTT_DESC01 "
    cQuery += "	FROM "+RetSqlName("CTT") "
    cQuery += "	WHERE "
    cQuery += "		D_E_L_E_T_ = ' ' "
    cQuery += "		AND CTT_DTEXSF = ' ' "
    cQuery += "		AND CTT_CLASSE = '2' "
    if !empty(id)
    	cQuery += "		AND CTT_CUSTO = '"+id+"' "
    endif
    cQuery += "	ORDER BY "
    cQuery += "		CTT_DESC01 "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		CONOUT("# CSI00005: Gerando lista de departamentos. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->CTT_CUSTO )
			aAdd( aAux, Capital( (cAlias)->CTT_DESC01 ))

			aAdd( aDepto, aAux)
			(cAlias)->( dbSkip() )
		end
		CONOUT("# CSI00005: Gerando lista de departamentos. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
	endif

	aAdd( aProp, 'estruturaId')
	aAdd( aProp, 'estruturaNome')

	U_json( @cRetorno, aDepto, aProp, 'listaDepartamento' )
return cRetorno