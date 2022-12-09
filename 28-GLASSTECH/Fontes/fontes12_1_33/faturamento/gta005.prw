#include "Protheus.ch"
/* 
filtros - 
Diretoria	- não tem, todos os orçamento e pedidos estarão disponíveis.
Gerente		- orçamentos/pedidos dele e dos seus vendedores
Vendedor	- orçamentos/pedidos dele
*/
User function gta005(cCampo,cFiltro)	//Faz filtro em orçamentos e pedidos conforme regras Glasstech

	Local cRet 	  := cFiltro
	Local cCodUsr := RetCodUsr()
	Local aUsuGrps := UsrRetGrp(cCodUsr)
	Local aAllGrps := AllGroups()
	Local aGrupos := {}
	local cCodVen := ""
	Local clCodUsr:= ""
	local cSql	  := ""
	Local nI	  := 0
	Local nO	  := 0

	for nI := 1 to len(aUsuGrps)
		for nO := 1 to len(aAllGrps)
			if aUsuGrps[nI] == aAllGrps[nO,1,1] 
				aadd(aGrupos,aAllGrps[nO,1,2])
			endif
		next
	next
	/*
	aEval(aGrupos, {|x| lDir := iif(!lDir.and.alltrim(x)=="DIR",.t.,.f.) })
	aEval(aGrupos, {|x| lGer := iif(!lGer.and.alltrim(x)=="GER",.t.,.f.) })
	aEval(aGrupos, {|x| lVen := iif(!lVen.and.alltrim(x)=="VEN",.t.,.f.) })
	*/
	for nI := 1 to len(aGrupos)
		if !lDir .and. alltrim(aGrupos[nI]) == "DIR"
			lDir := .t.
		endif
		if !lGer .and. alltrim(aGrupos[nI]) == "GER"
			lGer := .t.
		endif
		if !lVen .and. alltrim(aGrupos[nI]) == "VEN"
			lVen := .t.
		endif
	next

	if lVen .or. lGer .or. lDir
		cRet := ""
		/*
		if !lDir
			cRet := "CJ_XCODUSU == '"+cCodUsr+"'"
			if lGer
				cSql := "select * from "+RetSQLName("SA3")+" a3 where a3_filial = '"+xFilial("SA3")+"' and "
				cSql += "a3_codusr = '"+cCodUsr+"' and a3.d_e_l_e_t_ = ' '"
				cSql := ChangeQuery( cSql )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
				if !trb->( Eof() )
					cCodVen := trb->a3_cod
				endif
				trb->( DbCloseArea() )
				cSql := "select * from "+RetSQLName("SA3")+" a3 where a3_filial = '"+xFilial("SA3")+"' and "
				cSql += "a3_geren = '"+cCodVen+"' and a3.d_e_l_e_t_ = ' '"
				cSql := ChangeQuery( cSql )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
				while !trb->( Eof() )
					clCodUsr += trb->a3_codusr+"|"
					trb->( DbSkip() )
				End
				trb->( DbCloseArea() )
				cRet += " .OR. CJ_XCODUSU $ '"+clCodUsr+"'"
			endif
		endif
		*/
		if !lDir
			cSql := "select * from "+RetSQLName("SA3")+" a3 where a3_filial = '"+xFilial("SA3")+"' and "
			cSql += "a3_codusr = '"+cCodUsr+"' and a3.d_e_l_e_t_ = ' '"
			cSql := ChangeQuery( cSql )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			if !trb->( Eof() )
				cCodVen := trb->a3_cod
			endif
			trb->( DbCloseArea() )
			cRet := cCampo+" == '"+cCodVen+"'"
			if lGer
				cSql := "select * from "+RetSQLName("SA3")+" a3 where a3_filial = '"+xFilial("SA3")+"' and "
				cSql += "a3_geren = '"+cCodVen+"' and a3.d_e_l_e_t_ = ' '"
				cSql := ChangeQuery( cSql )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
				while !trb->( Eof() )
					clCodUsr += trb->a3_cod+"|"
					trb->( DbSkip() )
				End
				trb->( DbCloseArea() )
				cRet += " .OR. "+cCampo+" $ '"+clCodUsr+"'"
			endif
		endif
	endif

Return cRet
