#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE	4

user function CSI00003( nTipoRequi, filial, matricula )
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet(nTIPO_REQUISICAO_GET, filial, matricula )
	endif
return cRetorno

static function CSIGet(nTipoRequi, filial, matricula )
	local aAux 		 := {}
	local aAprov     := {}
	local aProp      := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	Default filial 	  := ""
	Default matricula := ""

	cQuery := " SELECT "
	cQuery += " 	SRAFUNC.RA_MAT MAT_FUNC, "
	cQuery += " 	SRAFUNC.RA_EMAIL MAT_EMAIL, "
	cQuery += " 	SRAAPROV.RA_MAT APROV_MAT, "
	cQuery += " 	SRAAPROV.RA_NOME APROV_NOME, "
	cQuery += " 	SRAAPROV.RA_EMAIL APROV_EMAIL, "
	cQuery += " 	PBD_NIVEL APROV_NIVEL "
	cQuery += " FROM "
	cQuery += " 	"+RetSqlName('PBD')+" PBD, "
	cQuery += " 	"+RetSqlName('PB9')+" PB9, "
	cQuery += " 	"+RetSqlName('RD0')+" RD0, "
	cQuery += " 	"+RetSqlName('RDZFUNC')+" RDZFUNC, "
	cQuery += " 	"+RetSqlName('SRAFUNC')+" SRAFUNC, "
	cQuery += " 	"+RetSqlName('RDZAPROV')+" RDZAPROV, "
	cQuery += " 	"+RetSqlName('SRAAPROV')+" SRAAPROV "
	cQuery += " WHERE "
	cQuery += " 	PBD.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND PB9.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RD0.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RDZFUNC.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SRAFUNC.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND PBD_GRUPO = RD0_GRPAPV "
	cQuery += " 	AND PBD_APROV = PB9_COD "
	cQuery += " 	AND PBD_STATUS = '1' "
	cQuery += " 	AND PB9_TIPO IN ('1','3') "
	cQuery += " 	AND RDZFUNC.RDZ_CODRD0 = RD0_CODIGO "
	cQuery += " 	AND RDZFUNC.RDZ_CODENT = SRAFUNC.RA_FILIAL || SRAFUNC.RA_MAT "
	cQuery += " 	AND RDZFUNC.RDZ_ENTIDA = 'SRA' "
	cQuery += " 	AND RDZAPROV.RDZ_CODRD0 = PBD_APROV "
	cQuery += " 	AND RDZAPROV.RDZ_CODENT = SRAAPROV.RA_FILIAL || SRAAPROV.RA_MAT "
	cQuery += " 	AND RDZAPROV.RDZ_ENTIDA = 'SRA' "
	if !Empty( filial )
		cQuery += " AND SRAFUNC.RA_FILIAL = '"+filial+"'"
	endif
	if !Empty( matricula )
		cQuery += " AND SRAFUNC.RA_MAT = '"+matricula+"'"
	endif
	cQuery += " ORDER BY "
	cQuery += " 	1, 5 "

	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		aAdd( aProp, 'MAT_FUNC')
		aAdd( aProp, 'MAT_EMAIL')
		aAdd( aProp, 'APROV_MAT')
		aAdd( aProp, 'APROV_NOME')
		aAdd( aProp, 'APROV_EMAIL')
		aAdd( aProp, 'APROV_NIVEL')

		while (cAlias)->(!EoF())
			aAux := {}

			aAdd( aAux, (cAlias)->MAT_FUNC )
			aAdd( aAux, (cAlias)->MAT_EMAIL )
			aAdd( aAux, (cAlias)->APROV_MAT )
			aAdd( aAux, Capital( (cAlias)->APROV_NOME ) )
			aAdd( aAux, (cAlias)->APROV_EMAIL )
			aAdd( aAux, (cAlias)->APROV_NIVEL )

			aAdd( aAprov, aAux )

			(cAlias)->(dbSkip())
		end
		(cAlias)->(dbCloseArea())
	endif

	U_json( @cRetorno, aAprov, aProp, 'listaAprovadores' )
Return(cRetorno)