#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE 4

user function CSI00004(nTipoRequi, filColab, matricula)
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_GET
		cRetorno := CSIGet(filColab, matricula)
	endif
return cRetorno

static function CSIGet(filColab, matricula)
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
	Default matricula := ""

	cQuery := " SELECT  "
	cQuery += " 	RA_FILIAL EMPRESA, "
	cQuery += " 	RA_MAT IDCORPORATIVO, "
	cQuery += " 	RA_EMAIL EMAIL, "
	cQuery += " 	RA_NOME NOME, "
	cQuery += " 	RA_NASC NASCIMENTO, "
	cQuery += " 	RA_ADMISSA DATAINICIOEMPRESA, "
	cQuery += " 	RA_SEXO GENERO, "
	cQuery += " 	RA_CIC IDPESSOAL, "
	cQuery += " 	RA_CODFUNC CARGO, "
	cQuery += " 	RJ_DESC NOMECARGO, "
	cQuery += " 	RA_CC DEPARTAMENTO, "
	cQuery += " 	CTT_DESC01 NOMEDEPARTAMENTO, "
    cQuery += " 	RA_CODLT UNIDADE, "
    cQuery += " 	SUBSTR(RCC_CONTEU,1,30) NOMEUNIDADE  "
    cQuery += " FROM "
    cQuery += " 	 "+RetSqlName('SRA')+" SRA "
    cQuery += " JOIN "+RetSqlName('SRJ')+" SRJ   ON "
    cQuery += " 	SRJ.D_E_L_E_T_ = ' ' "
    cQuery += " 	AND RA_CODFUNC = RJ_FUNCAO "
    cQuery += " JOIN "+RetSqlName('CTT')+" CTT   ON "
    cQuery += " 	CTT.D_E_L_E_T_ = ' ' "
    cQuery += " 	AND RA_CC      = CTT_CUSTO "
    cQuery += " JOIN "+RetSqlName('RCC')+" RCC   ON "
    cQuery += " 	RCC.D_E_L_E_T_ = ' ' "
    cQuery += " 	AND RCC.RCC_CODIGO = 'U006' "
    cQuery += " 	AND RCC.RCC_SEQUEN = RA_CODLT "
    cQuery += " WHERE "
    cQuery += "		SRA.D_E_L_E_T_ = ' '  "
    cQuery += "		AND SRA.RA_DEMISSA = ' '  "
	if !Empty( filColab )
		cQuery += " 	AND SRA.RA_FILIAL = '" + filColab + "'
	endif
	if !Empty( matricula )
		cQuery += " 	AND SRA.RA_MAT= '" + matricula + "'
	endif

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		CONOUT("# CSI00004: Gerando lista de funcionarios. Data e hora Inicio: "+DtoC(dDataBase)+" - "+Time() )
		while (cAlias)->( !EoF() )
			aAux := {}

			aAdd( aAux, (cAlias)->EMPRESA )
			aAdd( aAux, Capital( FWFilName( FWCodEmp(), (cAlias)->EMPRESA ) ) )
			aAdd( aAux, (cAlias)->IDCORPORATIVO )
			aAdd( aAux, (cAlias)->EMAIL )
			aAdd( aAux, Capital( (cAlias)->NOME ))
			aAdd( aAux, dtoc( stod( (cAlias)->NASCIMENTO )))
			aAdd( aAux, dtoc( stod( (cAlias)->DATAINICIOEMPRESA )))
			aAdd( aAux, (cAlias)->GENERO )
			aAdd( aAux, (cAlias)->IDPESSOAL )
			aAdd( aAux, (cAlias)->CARGO )
			aAdd( aAux, Capital( (cAlias)->NOMECARGO ))
			aAdd( aAux, (cAlias)->DEPARTAMENTO )
			aAdd( aAux, Capital( (cAlias)->NOMEDEPARTAMENTO ))
		    aAdd( aAux, (cAlias)->UNIDADE )
		    aAdd( aAux, Capital( (cAlias)->NOMEUNIDADE ))

			aAdd( aFunc, aAux)
			(cAlias)->( dbSkip() )
		end
		CONOUT("# CSI00004: Gerando lista de funcionarios. Data e hora Fim: "+DtoC(dDataBase)+" - "+Time() )
	endif

	aAdd( aProp, 'EMPRESA')
	aAdd( aProp, 'EMPRESANOME')
	aAdd( aProp, 'IDCORPORATIVO'   )
	aAdd( aProp, 'EMAIL'  )
	aAdd( aProp, 'NOME'    )
	aAdd( aProp, 'NASCIMENTO' )
	aAdd( aProp, 'DATAINICIOEMPRESA' )
	aAdd( aProp, 'GENERO' )
	aAdd( aProp, 'IDPESSOAL' )
	aAdd( aProp, 'CARGO' )
	aAdd( aProp, 'NOMECARGO' )
	aAdd( aProp, 'DEPARTAMENTO' )
	aAdd( aProp, 'NOMEDEPARTAMENTO' )
	aAdd( aProp, 'UNIDADE' )
	aAdd( aProp, 'NOMEUNIDADE' )

	U_json( @cRetorno, aFunc, aProp, 'listaFuncionario' )
return cRetorno