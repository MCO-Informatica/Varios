#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE 4

user function CSI00001(nTipoRequi, filColab)
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet(filColab)
	endif
return cRetorno

static function CSIGet(filColab)
	local aAux 		 := {}
	local aFunc		 := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .F. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	Default filColab 	:= ""



	cQuery := " SELECT "
	cQuery += " 	RA_FILIAL, "
	cQuery += " 	RA_MAT, "
	cQuery += " 	RA_NOME, "
	cQuery += " 	RA_CC, "
	cQuery += " 	RA_EMAIL "
	cQuery += " FROM "
	cQuery += " 	"+RetSqlName('SRA')+" SRA "
	cQuery += " WHERE
	cQuery += " 	SRA.D_E_L_E_T_ = ' '
	cQuery += " 	AND RA_DEMISSA = ' ' "
	if !Empty( filColab )
		cQuery += " 	AND SRA.RA_FILIAL = '" + filColab + "'
	endif
	cQuery += " ORDER BY "
	cQuery += " 	RA_FILIAL, RA_MAT "

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		CONOUT("# CSI00001: Filial: "+filColab+" Gerando lista de funcionarios. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, (cAlias)->RA_FILIAL )
			aAdd( aAux, (cAlias)->RA_MAT 	)
			aAdd( aAux, Capital( (cAlias)->RA_NOME ) )
			aAdd( aAux, (cAlias)->RA_CC	 	)
			aAdd( aAux, (cAlias)->RA_EMAIL 	)

			aAdd( aFunc, aAux)
			(cAlias)->( dbSkip() )
		end
		CONOUT("# CSI00001: Filial: "+filColab+" Gerando lista de funcionarios. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
	endif

	aAdd( aProp, 'RA_FILIAL')
	aAdd( aProp, 'RA_MAT'   )
	aAdd( aProp, 'RA_NOME'  )
	aAdd( aProp, 'RA_CC'    )
	aAdd( aProp, 'RA_EMAIL' )

	U_json( @cRetorno, aFunc, aProp, 'listaFuncionario' )

return cRetorno