#include "protheus.ch"
/* Executar sincronismo Protheus -> Cmms */
/* Opções parametro função cCodApi:
	P-Produtos
*/
User function renp001(cCodApi)
	Local cJobEmp := "00"
	Local cJobFil := "1330001"
	Local cJobMod := "FAT"
	
	Local cGrupo  := ""
	Local cFiltro := ""
	Local cParte  := ""
	Local nI      := 0
	Local cSql    := ""

	Local cErro := ""
	Local oMts
	Local oMat

	Default cCodApi := " "

	if empty(cCodApi) .or. cCodApi == "M"
		/* Para popular no Cmms Produtos */

		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

		cGrupo := alltrim( GetNewPar("MV_XGRPMAT","AEG1;BOP1") )
		for nI := 1 to len(cGrupo)
			if nI > 1 .or. !substr(cGrupo,nI,1) $ ",;"
				if substr(cGrupo,nI,1) == ";"
					if !empty(cFiltro)
						cFiltro += ","
					endif
					cFiltro += "'"+cParte+"'"
					cParte := ""
				else
					cParte += substr(cGrupo,nI,1)
					if nI == len(cGrupo)
						cFiltro += ",'"+cParte+"'"
					endif
				endif
			endif
		next

		cSql := "SELECT * FROM "+RetSQLName("SB1")+" B1 "
		cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
		cSql += "ZB_FILOBJ = '"+sb1->(xFilial())+"' AND ZB_TIPREG = 'M' AND "
		cSql += "ZB_CODOBJ = B1_COD AND ZB.D_E_L_E_T_ = ' ' "
		cSql += "WHERE B1_FILIAL = '"+sb1->(xFilial())+"' AND B1.D_E_L_E_T_ = ' ' AND B1_MSBLQL != '1' "
		cSql += "AND B1_GRUPO IN ("+cFiltro+") AND ZB_CODOBJ IS NULL"
		dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
		while !trb->(eof())
			cErro := ""
			oMat:=materialCmms():new()
			oMat:buscar(trb->b1_cod,"I")
			oMts:=materiaisCmms():new()
			oMts:add(oMat)
			u_renp002("M","I",oMts,trb->b1_filial,trb->b1_cod,,@cErro)
			trb->(dbskip())
		end
		trb->(dbclosearea())
		FreeObj(oMat)
		FreeObj(oMts)

		RpcClearEnv()

	endif

Return


/************************************************************************************************/
/* Operações com entidades Atualizadas na Cmms por operações (Inclusão, alteração e Exclusão) */
/* nos respectivos cadastros																	*/
/************************************************************************************************/
User function matOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local lJob := ( Select( "SX6" ) == 0 )
	Local oMts
	Local oMat

	Default cCompl := ""

	verSleep("U_MATOPER",12,110)

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		DbSelectArea("SB1")
		oMat:=materialCmms():new()
		oMat:buscar(cCod,cOpc)
		oMts:=materiaisCmms():new()
		oMts:add(oMat)
		u_renp002("M",cOpc,oMts,sb1->(xfilial()),cCod,,@cErro)
		FreeObj(oMat)
		FreeObj(oMts)
		if !empty(cErro)
			lRet := .f.
		endif
		if lJob
			RpcClearEnv()
		endif
	endif

Return lRet


User function atiOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local lJob := ( Select( "SX6" ) == 0 )
	Local oAti
	Local oAts

	Default cCompl := ""

	verSleep("U_ATIOPER",12,110)

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		DbSelectArea("SB1")
		oAti:=ativoCmms():new()
		oAti:buscar(cCod,cCompl,cOpc)
		oAts:=ativosCmms():new()
		oAts:add(oAti)
		u_renp002("A",cOpc,oAts,sb1->(xfilial()),cCod,,@cErro)
		FreeObj(oAti)
		FreeObj(oAts)
		if !empty(cErro)
			lRet := .f.
		endif
		if lJob
			RpcClearEnv()
		endif
	endif

Return lRet


/* Parametros:
cNomFunc - Nome Função(com u_ na frente),
nTotFunc - qtd x que função pode rodar ao mesmo tempo,
nTotLic - número total de licenças
*/
Static function verSleep(cNomFunc,nTotFunc,nTotLic)
	Local nThread := 0
	Local nTotLUs := 0
	Local aMyUsers := Getuserinfoarray()

	aEval(aMyUsers,{|x| iif( substr(upper(x[5]),1,len(cNomFunc)) == cNomFunc,nThread++,nil )  })
	aEval(aMyUsers,{|x| iif( !empty(x[5]),nTotLUs++,nil )  })
	While nThread > nTotFunc .and. nTotLUs > nTotLic
		sleep(5000)		// 5 segundos
		nThread := nTotLUs := 0
		aMyUsers := Getuserinfoarray()
		aEval(aMyUsers,{|x| iif( substr(upper(x[5]),1,len(cNomFunc)) == cNomFunc,nThread++,nil )  })
		aEval(aMyUsers,{|x| iif( !empty(x[5]),nTotLUs++,nil )  })
	End

Return
