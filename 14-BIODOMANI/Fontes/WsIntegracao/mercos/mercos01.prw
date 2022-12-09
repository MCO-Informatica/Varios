#include "protheus.ch"
/* Executar sincronismo Protheus -> Mercos */
/* Opções parametro função cCodApi:
	G-Segmentos de clientes
	C-Clientes
	T-Categorias de produtos
	P-Produtos
	E-Envio do Estoque
	B-tabela de preços cabeçalho 
	R-tabela de preços itens
	S-Transportadoras
	D-cond. pagamento
	F-forma pagamento
	I-configurações de ICMS-ST
	O-Pedidos
*/
User function mercos01(cCodApi)
	//Local lJob 	  := ( Select( "SX6" ) == 0 )
	Local cJobEmp := '01'
	Local cJobFil := '0103'
	Local cJobMod := 'FAT'
	Local nI      := 0
	Local cSql    := ""
	Local cOper   := ""
	Local nOper   := 1000
	Local nExec   := 0
	Local cLocal
	Local aLocal := {}
	Local cErro := ""
	Local oObj

	Default cCodApi := " "

	aLocal := u_mercos98()

	if empty(cCodApi) .or. cCodApi == "G"
		/* Para popular no Mercos Segmentos de clientes */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("SX5")+" X5 "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'G' AND "
			cSql += "ZB_CODIGO = X5_CHAVE AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE X5_FILIAL = '"+sx5->(xFilial())+"' AND X5_TABELA = 'T3' " //AND X5.D_E_L_E_T_ = ' '
			//cSql += "AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cOper := ""
				if !empty(trb->zb_codigo)
					if trb->r_e_c_d_e_l != 0 .and. trb->zb_ativo == "1"
						cOper := "E"
					elseif trb->zb_ativo == "1"
						cOper := "A"
					endif
				elseif trb->r_e_c_d_e_l == 0 .and. empty(trb->zb_codigo)
					cOper := "I"
				endif
				if !empty(cOper)
					cErro := ""
					oObj:=segMercos():new()
					oObj:busca(trb->x5_chave)
					u_mercos02("G",cOper,oObj,trb->x5_chave,,,@cErro)
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

	if empty(cCodApi) .or. cCodApi == "C"
		/* Para popular no Mercos Clientes */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			nExec := 0
			cSql := "SELECT * FROM "+RetSQLName("SA1")+" A1 "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'C' AND "
			cSql += "ZB_CODIGO = A1_COD+A1_LOJA AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE A1_FILIAL = '"+sa1->(xFilial())+"' AND A1.D_E_L_E_T_ = ' ' AND "
			cSql += "A1_MSBLQL != '1' AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cErro := ""
				oObj:=cliMercos():new()
				oObj:busca(trb->a1_cod,trb->a1_loja)
				u_mercos02("C","I",oObj,trb->a1_cod+trb->a1_loja,,,@cErro)
				nExec += 1
				if nExec >= nOper
					exit
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

	if empty(cCodApi) .or. cCodApi == "T"
		/* Para popular no Mercos Categorias de produtos */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("ACU")+" ACU "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'T' AND "
			cSql += "ZB_CODIGO = ACU_COD AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE ACU_FILIAL = '"+acu->(xFilial())+"'  " //AND ACU.D_E_L_E_T_ = ' ' AND ZB_CODIGO IS NULL "
			cSql += "ORDER BY ACU_FILIAL,ACU_CODPAI,ACU_COD "
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cOper := ""
				if !empty(trb->zb_codigo)
					if trb->r_e_c_d_e_l != 0 .and. trb->zb_ativo == "1"
						cOper := "E"
					elseif trb->zb_ativo == "1"
						cOper := "A"
					endif
				elseif trb->r_e_c_d_e_l == 0 .and. empty(trb->zb_codigo)
					cOper := "I"
				endif
				if !empty(cOper)
					cErro := ""
					oObj:=catMercos():new()
					oObj:busca(trb->acu_cod)
					u_mercos02("T",cOper,oObj,trb->acu_cod,,,@cErro)
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

	if empty(cCodApi) .or. cCodApi == "P"
		/* Para popular no Mercos Produtos */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			nExec := 0
			cSql := "SELECT * FROM "+RetSQLName("SB1")+" B1 "
			cSql += "INNER JOIN "+RetSQLName("SB5")+" B5 ON B5_FILIAL = B1_FILIAL AND B5_COD = B1_COD AND B5.D_E_L_E_T_ = ' ' "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'P' AND "
			cSql += "ZB_CODIGO = B1_COD AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE B1_FILIAL = '"+sb1->(xFilial())+"' AND B1.D_E_L_E_T_ = ' ' AND B1_MSBLQL != '1' "
			cSql += "AND B5_XMERCOS = '1' AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cErro := ""
				oObj:=prodMercos():new()
				oObj:busca(trb->b1_cod,cLocal)
				u_mercos02("P","I",oObj,trb->b1_cod,,,@cErro)
				nExec += 1
				if nExec >= nOper
					exit
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

	if empty(cCodApi) .or. cCodApi == "E"
		/* Envio do Estoque para o Mercos */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("SB1")+" B1 "
			cSql += "INNER JOIN "+RetSQLName("SB5")+" B5 ON B5_FILIAL = B1_FILIAL AND B5_COD = B1_COD AND B5.D_E_L_E_T_ = ' ' "
			cSql += "INNER JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'E' AND "
			cSql += "ZB_CODIGO = B1_COD AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE B1_FILIAL = '"+sb1->(xFilial())+"' AND B1.D_E_L_E_T_ = ' ' AND B1_MSBLQL != '1' "
			cSql += "AND B5_XMERCOS = '1'"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cErro := ""
				oObj:=EstoqMercos():new()
				oObj:busca(trb->b1_cod,cLocal)
				u_mercos02("E","A",oObj,trb->b1_cod,,,@cErro)
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

	if empty(cCodApi) .or. cCodApi == "B"
		/* Para popular no Mercos tabela de preços cabeçalho */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("DA0")+" DA0 "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' "
			cSql += "AND ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'B' "
			cSql += "AND ZB_CODIGO = DA0_CODTAB AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE DA0_FILIAL = '"+da0->(xFilial())+"' AND DA0_CODTAB IN ('005','201') "
			cSql += "AND DA0.D_E_L_E_T_ = ' ' AND DA0_ATIVO = '1' AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cErro := ""
				oObj:=preMercos():new()
				oObj:busca(trb->da0_codtab)
				u_mercos02("B","I",oObj,trb->da0_codtab,,,@cErro)
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

	if empty(cCodApi) .or. cCodApi == "R"
		/* Para popular no Mercos tabela de preços itens */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("DA1")+" DA1 "
			cSql += "INNER JOIN "+RetSQLName("SB5")+" B5 ON B5_FILIAL = DA1_FILIAL AND B5_COD = DA1_CODPRO AND B5.D_E_L_E_T_ = ' ' "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'R' AND "
			cSql += "ZB_CODIGO = DA1_CODTAB+DA1_CODPRO AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE DA1_FILIAL = '"+da0->(xFilial())+"' AND DA1_CODTAB IN ('005','201') "
			cSql += "AND DA1.D_E_L_E_T_ = ' ' AND DA1_ATIVO = '1' AND B5_XMERCOS = '1' AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cErro := ""
				oObj:=prePrdMercos():new()
				oObj:busca(trb->da1_codtab,trb->da1_codpro)
				u_mercos02("R","I",oObj,trb->da1_codtab+trb->da1_codpro,,,@cErro)
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

	if empty(cCodApi) .or. cCodApi == "S"
    	/* Para popular no Mercos Transportadoras */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("SA4")+" A4 "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'S' AND "
			cSql += "ZB_CODIGO = A4_COD AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE A4_FILIAL = '"+sa4->(xFilial())+"' "	//AND A4.D_E_L_E_T_ = ' '
			//cSql += "AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cOper := ""
				if !empty(trb->zb_codigo)
					if trb->r_e_c_d_e_l != 0 .and. trb->zb_ativo == "1"
						cOper := "E"
					elseif trb->zb_ativo == "1"
						cOper := "A"
					endif
				elseif trb->r_e_c_d_e_l == 0 .and. empty(trb->zb_codigo)
					cOper := "I"
				endif
				if !empty(cOper)
					cErro := ""
					oObj:=transMercos():new()
					oObj:busca(trb->a4_cod)
					u_mercos02("S",cOper,oObj,trb->a4_cod,,,@cErro)
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	Endif

	if empty(cCodApi) .or. cCodApi == "D"
    	/* Para popular no Mercos cond. pagamento */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("SE4")+" E4 "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' "
			cSql += "AND ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'D' "
			cSql += "AND ZB_CODIGO = E4_CODIGO AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE E4_FILIAL = '"+se4->(xFilial())+"' "	//AND E4_MSBLQL != '1' AND E4.D_E_L_E_T_ = ' ' "
			//cSql += "AND E4_XMERCOS = '1' AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cOper := ""
				if !empty(trb->zb_codigo)
					if trb->r_e_c_d_e_l != 0 .and. trb->zb_ativo == "1" .or. trb->e4_xmercos != "1"
						cOper := "E"
					elseif trb->zb_ativo == "1" .and. trb->e4_msblql != "1"
						cOper := "A"
					endif
				elseif trb->e4_msblql != "1" .and. trb->r_e_c_d_e_l == 0 .and.;
						trb->e4_xmercos == "1" .and. empty(trb->zb_codigo)
					cOper := "I"
				endif
				if !empty(cOper)
					cErro := ""
					oObj:=condMercos():new()
					oObj:busca(trb->e4_codigo)
					u_mercos02("D",cOper,oObj,trb->e4_codigo,,,@cErro)
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	Endif

	if empty(cCodApi) .or. cCodApi == "F"
    	/* Para popular no Mercos forma pagamento */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("SX5")+" X5 "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'F' AND "
			cSql += "ZB_CODIGO = X5_CHAVE AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE X5_FILIAL = '"+sx5->(xFilial())+"' AND X5_TABELA = '24' "	//AND X5.D_E_L_E_T_ = ' ' "
			//cSql += "AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cOper := ""
				if !empty(trb->zb_codigo)
					if trb->r_e_c_d_e_l != 0 .and. trb->zb_ativo == "1"
						cOper := "E"
					elseif trb->zb_ativo == "1"
						cOper := "A"
					endif
				elseif trb->r_e_c_d_e_l == 0 .and. empty(trb->zb_codigo)
					cOper := "I"
				endif
				if !empty(cOper)
					cErro := ""
					oObj:=formMercos():new()
					oObj:busca(trb->x5_chave)
					u_mercos02("F",cOper,oObj,trb->x5_chave,,,@cErro)
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	Endif

	if empty(cCodApi) .or. cCodApi == "I"
		/* Para popular no Mercos configurações de ICMS-ST */
		for nI := 1 to len(aLocal)

			cJobFil := aLocal[nI,1]
			cLocal := aLocal[nI,2]

			RpcSetType( 3 )
			RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

			cSql := "SELECT * FROM "+RetSQLName("SF7")+" F7 "
			cSql += "INNER JOIN "+RetSQLName("SX5")+" X5 ON X5_FILIAL = F7_FILIAL AND X5_TABELA = '21' AND X5_CHAVE = F7_GRTRIB AND X5.D_E_L_E_T_ = ' ' "
			cSql += "LEFT JOIN "+RetSQLName("SZB")+" ZB ON ZB_FILIAL = '"+szb->(xFilial())+"' AND "
			cSql += "ZB_FILORI = '"+cFilAnt+"' AND ZB_TIPREG = 'I' AND ZB_CODIGO = F7_GRTRIB+F7_SEQUEN AND ZB.D_E_L_E_T_ = ' ' "
			cSql += "WHERE F7_FILIAL = '"+sf7->(xFilial())+"' AND F7_SEQUEN != ' ' AND F7_EST != '**' "	//AND F7.D_E_L_E_T_ = ' ' "
			//cSql += "AND ZB_CODIGO IS NULL"
			dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
			while !trb->(eof())
				cOper := ""
				if !empty(trb->zb_codigo)
					if trb->r_e_c_d_e_l != 0 .and. trb->zb_ativo == "1"
						cOper := "E"
						//else
						//	cOper := "A"		//retirado porque o api configurações de ICMS-ST não realiza requisição PUT
					endif
				elseif trb->r_e_c_d_e_l == 0 .and. empty(trb->zb_codigo)
					cOper := "I"
				endif
				if !empty(cOper)
					cErro := ""
					oObj:=icmsStMercos():new()
					oObj:busca(trb->f7_grtrib,trb->f7_sequen)
					u_mercos02("I",cOper,oObj,trb->f7_grtrib+trb->f7_sequen,,,@cErro)
				endif
				trb->(dbskip())
			end
			trb->(dbclosearea())
			FreeObj(oObj)

			RpcClearEnv()
		Next
	endif

Return


/************************************************************************************************/
/* Operações com entidades Atualizadas na Mercos por operações (Inclusão, alteração e Exclusão) */
/* nos respectivos cadastros																	*/
/************************************************************************************************/
User function cliOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local oCli
	Local lJob := ( Select( "SX6" ) == 0 )

	verSleep("U_CLIOPER",12,110)

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		DbSelectArea("SA1")
		oCli:=cliMercos():new()
		oCli:busca(cCod,cCompl)
		u_mercos02("C",cOpc,oCli,cCod+cCompl,,,@cErro)
		FreeObj(oCli)
		if !empty(cErro)
			lRet := .f.
		endif
		if lJob
			RpcClearEnv()
		endif
	endif

Return lRet


User function prodOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local oProd
	Local lJob := ( Select( "SX6" ) == 0 )

	verSleep("U_PRODOPER",12,110)

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		DbSelectArea("ACV")
		DbSelectArea("DA1")
		DbSelectArea("SB2")
		DbSelectArea("SB1")
		oProd:=prodMercos():new()
		oProd:busca(cCod,cCompl)
		u_mercos02("P",cOpc,oProd,cCod,,,@cErro)
		FreeObj(oProd)
		if !empty(cErro)
			lRet := .f.
		endif
		if lJob
			RpcClearEnv()
		endif
	endif

Return lRet


User function tabOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local oPre
	Local lJob := ( Select( "SX6" ) == 0 )

	verSleep("U_TABOPER",12,110)

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		DbSelectArea("DA0")
		oPre:=preMercos():new()
		oPre:busca(cCod)
		u_mercos02("B",cOpc,oPre,cCod,,,@cErro)
		FreeObj(oPre)
		if !empty(cErro)
			lRet := .f.
		endif
		if lJob
			RpcClearEnv()
		endif
	endif

Return lRet


User function prePrdOper(cEmp,cFil,cMod,cOpc,cCod,cCompl,cErro)
	Local lRet := .t.
	Local oPPr
	Local lJob := ( Select( "SX6" ) == 0 )

	verSleep("U_PREPRDOPER",12,110)

	if lJob
		RpcSetType( 3 )
		lRet := RpcSetEnv( cEmp, cFil, , , cMod )
	endif
	if lRet
		DbSelectArea("DA1")
		oPPr:=prePrdMercos():new()
		oPPr:busca(cCod,cCompl)
		u_mercos02("R",cOpc,oPPr,cCod+cCompl,,,@cErro)
		FreeObj(oPPr)
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
