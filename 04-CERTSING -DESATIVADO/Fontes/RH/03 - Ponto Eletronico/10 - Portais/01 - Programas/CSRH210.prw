#include 'protheus.ch'
#include 'parmtype.ch'

user function CSRH210(cAprovador)
	local aAux 		 := {}
	local aLista     := {}
	local aProp      := {'grupo_codigo', 'grupo_descricao', 'cc_codigo', 'cc_descricao', 'funcionario_filial', 'funcionario_matricula', 'funcionario_nome'}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local cRetorno 	 := ""
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cQuery2    := ""
	local cGetGerInd := ""

	default cAprovador := ""

	if !empty(cAprovador)
		cGetGerInd := getGerInd( cAprovador )

		cQuery := " SELECT "
		cQuery += " 	PBD.PBD_GRUPO GRUPO, "
		cQuery += " 	PBA.PBA_DESC, "
		cQuery += " 	SRA.RA_CC, "
		cQuery += " 	CTT.CTT_DESC01, "
		cQuery += " 	SRA.RA_FILIAL, "
		cQuery += " 	SRA.RA_MAT, "
		cQuery += " 	SRA.RA_NOME "
		cQuery += " FROM "
		cQuery += " 	 "+RetSqlName("PBD")+"  PBD "
		cQuery += " INNER JOIN  "+RetSqlName("PBA")+"  PBA ON "
		cQuery += " 	PBA.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND PBA.PBA_COD = PBD.PBD_GRUPO "
		cQuery += " INNER JOIN  "+RetSqlName("RD0")+"  RD0 ON "
		cQuery += " 	RD0.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND RD0.RD0_GRPAPV = PBD.PBD_GRUPO "
		cQuery += " INNER JOIN  "+RetSqlName("RDZ")+"  RDZ ON "
		cQuery += " 	RDZ.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
		cQuery += " 	AND RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO "
		cQuery += " INNER JOIN  "+RetSqlName("SRA")+"  SRA ON "
		cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND CONCAT(SRA.RA_FILIAL, SRA.RA_MAT) = RDZ.RDZ_CODENT "
		cQuery += " 	AND SRA.RA_DEMISSA = '' "
		cQuery += " 	AND SRA.RA_REGRA <> '99' "
		cQuery += " INNER JOIN  "+RetSqlName("CTT")+"  CTT ON "
		cQuery += " 	CTT.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND CTT.CTT_CUSTO = SRA.RA_CC "
		cQuery += " WHERE "
		cQuery += " 	PBD.D_E_L_E_T_ = ' ' "
		if !empty( cGetGerInd )
			cQuery += " AND PBD.PBD_GRUPO IN ('"+cGetGerInd+"') " 
		else
			cQuery += " AND PBD.PBD_APROV = '"+cAprovador+"' "
		endif
		cQuery += " GROUP BY "
		cQuery += " 	PBD.PBD_GRUPO, "
		cQuery += " 	PBA.PBA_DESC, "
		cQuery += " 	SRA.RA_CC, "
		cQuery += " 	CTT.CTT_DESC01, "
		cQuery += " 	SRA.RA_FILIAL, "
		cQuery += " 	SRA.RA_MAT, "
		cQuery += " 	SRA.RA_NOME "

		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza)
			while (calias)->(!EoF())
				aAux := {}
				aAdd( aAux, (calias)->GRUPO )
				aAdd( aAux, Capital( (calias)->PBA_DESC ) )
				aAdd( aAux, (calias)->RA_CC )
				aAdd( aAux, Capital( (calias)->CTT_DESC01 ) )
				aAdd( aAux, (calias)->RA_FILIAL )
				aAdd( aAux, (calias)->RA_MAT )
				aAdd( aAux, Capital( (calias)->RA_NOME ) )
				aAdd( aLista, aAux )
				(calias)->(dbskip())
			end
			(calias)->(dbCloseArea())
		endif

		cQuery2 := " SELECT "
		cQuery2 += " 	RD0.RD0_GRPAPV GRUPO, "
		cQuery2 += " 	PBA.PBA_DESC, "
		cQuery2 += " 	SRA.RA_CC, "
		cQuery2 += " 	CTT.CTT_DESC01, "
		cQuery2 += " 	SRA.RA_FILIAL, "
		cQuery2 += " 	SRA.RA_MAT, "
		cQuery2 += " 	SRA.RA_NOME "
		cQuery2 += " FROM "
		cQuery2 += " 	 "+RetSqlName("RD0")+"  RD0 "
		cQuery2 += " INNER JOIN  "+RetSqlName("PBA")+"  PBA ON "
		cQuery2 += " 	PBA.D_E_L_E_T_ = ' ' "
		cQuery2 += " 	AND PBA.PBA_COD = RD0.RD0_GRPAPV "
		cQuery2 += " INNER JOIN  "+RetSqlName("RDZ")+"  RDZ ON "
		cQuery2 += " 	RDZ.D_E_L_E_T_ = ' ' "
		cQuery2 += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
		cQuery2 += " 	AND RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO "
		cQuery2 += " INNER JOIN  "+RetSqlName("SRA")+"  SRA ON "
		cQuery2 += " 	SRA.D_E_L_E_T_ = ' ' "
		cQuery2 += " 	AND CONCAT(SRA.RA_FILIAL, SRA.RA_MAT) = RDZ.RDZ_CODENT "
		cQuery2 += " 	AND SRA.RA_DEMISSA = '' "
		cQuery2 += " 	AND SRA.RA_REGRA <> '99' "
		cQuery2 += " INNER JOIN  "+RetSqlName("CTT")+"  CTT ON "
		cQuery2 += " 	CTT.D_E_L_E_T_ = ' ' "
		cQuery2 += " 	AND CTT.CTT_CUSTO = SRA.RA_CC "
		cQuery2 += " WHERE "
		cQuery2 += " 	RD0.D_E_L_E_T_ = ' ' "
		cQuery2 += " 	AND RD0.RD0_CODIGO = '"+cAprovador+"' "
		cQuery2 += " GROUP BY "
		cQuery2 += " 	RD0.RD0_GRPAPV, "
		cQuery2 += " 	PBA.PBA_DESC, "
		cQuery2 += " 	SRA.RA_CC, "
		cQuery2 += " 	CTT.CTT_DESC01, "
		cQuery2 += " 	SRA.RA_FILIAL, "
		cQuery2 += " 	SRA.RA_MAT, "
		cQuery2 += " 	SRA.RA_NOME "

		cAlias := GetNextAlias() //Alias resevardo para consulta SQL
		if U_MontarSQ(calias, @nRec, cQuery2, lExeChange, lTotaliza)
			while (calias)->(!EoF())
				aAux := {}
				aAdd( aAux, (calias)->GRUPO )
				aAdd( aAux, Capital( (calias)->PBA_DESC ) )
				aAdd( aAux, (calias)->RA_CC )
				aAdd( aAux, Capital( (calias)->CTT_DESC01 ) )
				aAdd( aAux, (calias)->RA_FILIAL )
				aAdd( aAux, (calias)->RA_MAT )
				aAdd( aAux, Capital( (calias)->RA_NOME ) )
				aAdd( aLista, aAux )
				(calias)->(dbskip())
			end
			(calias)->(dbCloseArea())
		endif
	endif
	
	U_json(@cRetorno, aLista, aProp, 'listaUniversoGrupo')

return cRetorno

user function CSRH211( idParticipante, cGrupo, cCC, cColaborador )
	local aLista   := {}
	local aProp    := {'nomeArquivo', 'status'}
	local aFunc    := {}
	local aLinha   := {}
	local aParam   := {}
	local cRetorno := ''
	local cArquivo := ''
	local cFilMat  := ''
	local cMat     := ''
	local i 	   := 0
	local nomeArq  := ''
	local cPasta   := ''

	if !empty( idParticipante ) .and. ( !empty( cGrupo ) .and. !empty( cCC )  .and. !empty( cColaborador ) )
		cPasta := '\web\pp\ponto_eletronico\relatorios\'+idParticipante+'\'
		U_CriarDir( cPasta )
		nomeArq := 'bh_aberto_'+dtos(dDataBase)+'_'+replace(time(),":","_")+'.xml'
		cArquivo := cPasta+nomeArq
		aLinha := StrTokArr( cColaborador, "," )
		if len(aLinha) > 0
			for i := 1 to len(aLinha)
				aFunc   := StrTokArr( aLinha[i], "-" )
				if !empty(cFilMat)
					cFilMat += ","
				endif
				if !empty(cMat)
					cMat += ","
				endif

				cFilMat += "'"+aFunc[1]+"'"
				cMat 	+= "'"+aFunc[2]+"'"
			next i
		endif

		aAdd( aParam, cArquivo )
		aAdd( aParam, cGrupo )
		aAdd( aParam, cCC )
		aAdd( aParam, cFilMat )
		aAdd( aParam, cMat )

		if u_CSRH133( aParam )
			aAdd( aLista, {nomeArq, 'ok'} )
			delRelat( cPasta )
		else
			aAdd( aLista, {nomeArq, 'erro'} )
		endif
	endif
	U_json( @cRetorno, aLista, aProp, 'relatorio' )
return cRetorno

static function delRelat( cPasta )
	local aDirectory := {}
	default cPasta := ""

	if !empty( cPasta )
		aDirectory := Directory(cPasta+'\*.*')
		aSort(aDirectory, , , {|x, y| dtos(x[3])+replace(x[4],":","") > dtos(y[3])+replace(y[4],":","") })
		varinfo("aDirectory", aDirectory)
		for i := 4 to len(aDirectory)
			if fErase( cPasta+aDirectory[i][1] ) == -1
				conout("CSRH211 nao deletou arquivo Excel: "+cPasta+aDirectory[i][1])
			end
		next i
	endif
return

user function CSRH212( idParticipante )
	local aLista := {}
	local aProp := {'nome', 'data'}
	local cRetorno := ''
	local cArquivo := ''
	local i := 0
	local aDirectory := {}

	cArquivo := '\web\pp\ponto_eletronico\relatorios\'+idParticipante

	aDirectory := Directory(cArquivo+'\*.*')

	for i := 1 to len(aDirectory)
		aAux := {}
		aAdd( aAux, aDirectory[i][1])
		aAdd( aAux, aDirectory[i][3])
		aAdd( aLista, aAux )
	next i
	U_json( @cRetorno, aLista, aProp, 'listaArquivos' )
return cRetorno

static function getGerInd( cAprovador )
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cGrupos    := ""

	default cAprovador := ""

	cQuery := " SELECT "
	cQuery += " 	PBA.PBA_COD "
	cQuery += " FROM "
	cQuery += " 	"+RetSqlName("RD0")+" RD0 "
	cQuery += " INNER JOIN "+RetSqlName("RDZ")+" RDZ ON "
	cQuery += " 	RDZ.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO "
	cQuery += " INNER JOIN "+RetSqlName("SRA")+" SRA ON "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT "
	cQuery += " INNER JOIN "+RetSqlName("PBA")+" PBA ON "
	cQuery += " 	PBA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND PBA.PBA_CODGER = SRA.RA_MAT "
	cQuery += " WHERE "
	cQuery += " 	RD0.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RD0.RD0_CODIGO = '"+cAprovador+"' "

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza)
		while (calias)->(!EoF())
			if !empty(cGrupos)
				cGrupos += "','"
			endif
			cGrupos += (calias)->PBA_COD
			(calias)->(dbskip())
		end
		(calias)->(dbCloseArea())
	endif
return cGrupos