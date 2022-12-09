#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE 4

user function CSI00006(nTipoRequi, id)
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
	cQuery += "		RJ_FUNCAO, "
	cQuery += "		RJ_DESC "
	cQuery += "	FROM "+RetSqlName("SRJ")+" SRJ "
	cQuery += "	WHERE "
	cQuery += "		D_E_L_E_T_ = ' '"
	if !empty(id)
		cQuery += "		AND RJ_FUNCAO = '"+id+"'"
	endif
    cQuery += "	ORDER BY "
    cQuery += "		RJ_DESC "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		CONOUT("# CSI00006: Gerando lista de funcoes. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->RJ_FUNCAO )
			aAdd( aAux, Capital( (cAlias)->RJ_DESC ))

			aAdd( aDepto, aAux)
			(cAlias)->( dbSkip() )
		end
		CONOUT("# CSI00006: Gerando lista de funcoes. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
	endif

	aAdd( aProp, 'funcaoId')
	aAdd( aProp, 'funcaoDescricao')

	U_json( @cRetorno, aDepto, aProp, 'listaFuncoes' )
return cRetorno