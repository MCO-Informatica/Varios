#Include 'Protheus.ch'
#include 'tbiconn.ch'

#Define MATERIAL 1
#Define DESCPRO  2
#Define ARMAZEM  3
#Define ENDERECO 4
#Define QTDORIG  5
#Define QTDSOLI  6
#Define RESERVA  7
#Define CODRESE  8
#Define CONSUMO  9

/* Gerar solicitação de tranferências */
User Function renp105(cDemanda,oBrwIt)

	Local lRet := .t.
	Local lRep := .f.
	Local aObj := iif(oBrwIt==nil,{},oBrwIt:oData:aArray)
	Local nI := 0
	Local cMens := ""
	Local aTrans := {}
	Local aSTran := {}
	Local nExcSobr := 0
	local cJustif := ''
	local cSolTrf := ''

	szm->(dbSetOrder(1))
	if szm->(dbSeek(xFilial()+cDemanda))
		if szm->zm_situa != "4"
			if szm->zm_situa == "6"
				cMens := "A demanda "+cDemanda+" esta cancelada"
			elseif szm->zm_situa > "4"
				cMens := "Solicitação transferência Já realizada"
			else
				cMens := "Consumo material demandado ainda não confirmado"
			endif
			MsgInfo(cMens, "Solic. transferências")
			lRet := .f.
		else
			if empty(aObj)
				lRep := .t.
				aObj := {}
				cSql := "select * from "+RetSQLName("SZN")+" zn "
				cSql += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+xFilial("SB1")+"' and b1_cod = zn_materia "
				cSql += "and b1.d_e_l_e_t_ = ' ' "
				cSql += "left join "+RetSQLName("SC0")+" c0 on c0_filial = '"+xFilial("SC0")+"' and c0_num = zn_codres "
				cSql += "and c0_produto = zn_materia and c0_local = zn_local and c0_localiz = zn_localiz and c0.d_e_l_e_t_ = ' ' "
				cSql += "where zn_filial = '"+xFilial("SZN")+"' and zn_demanda = '"+cDemanda+"' "
				cSql += "and zn.d_e_l_e_t_ = ' ' order by zn_materia"
				cSql := ChangeQuery( cSql )
				dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
				while !trb->( Eof() )
					nExcSobr := iif(szm->zm_situa>"2",trb->zn_quant-trb->zn_qtdcons,0)
					Aadd(aObj, { trb->zn_materia, trb->b1_desc, trb->zn_local, trb->zn_localiz, trb->zn_qorig, trb->zn_quant, trb->c0_quant, trb->zn_codres, trb->zn_qtdcons, nExcSobr, "", "" } )
					trb->( DbSkip() )
				End
				trb->( DbCloseArea() )
			endif
			for nI := 1 to len(aObj)
				if aObj[nI,CONSUMO] > 0
					if !lRep .and. !u_verReserv(cDemanda,aObj[nI,MATERIAL],aObj[nI,ARMAZEM],aObj[nI,ENDERECO],szm->zm_situa,@cMens)
						lRet := .f.
						MsgInfo(cMens, "Solic. transferências")
					endif        //MATERIAL         ,QTD TRANF       ,ARMAZEM         ,ENDEREÇO         ,ARMAZEM DEST                  ,ENDEREÇO DEST
					aadd( aTrans,{aObj[nI,MATERIAL],aObj[nI,CONSUMO],aObj[nI,ARMAZEM],aObj[nI,ENDERECO],"R"+substr(aObj[nI,ARMAZEM],2),"REVENDA"/*aObj[nI,ENDERECO]*/ } )
					//FILIAL ,MATERIAL         ,ARMAZEM                       ,ENDEREÇO       				 , QTD CONSUMIDA  ,FILDES         ,PRODD            ,LOCLD                         ,LOCLID,TS   ,TE
					aadd( aSTran,{cFilAnt,aObj[nI,MATERIAL],"R"+substr(aObj[nI,ARMAZEM],2),"REVENDA"/*aObj[nI,ENDERECO]*/,aObj[nI,CONSUMO],szm->zm_destino,aObj[nI,MATERIAL],"R"+substr(aObj[nI,ARMAZEM],2),""    ,"501","001" } )
				endif
			next
		endif
		if lRet
			if lRep .or. prepSol(cDemanda,aTrans,@cMens)
				cJustif := 'Gerada por confirmação de consumo de manutenção pela demanda: '+cDemanda
				if u_renp110(aSTran,cJustif,@cSolTrf,@cMens)
					szm->(RecLock("szm",.f.))
					szm->zm_situa := '5'
					szm->zm_soltrf := cSolTrf
					szm->(MsUnLock())
				else
					lRet := .f.
				endif
				MsgInfo(cMens, "Solic. transferências")
			else
				lRet := .f.
				MsgInfo(cMens, "Solic. transferências")
			endif
		endif
	else
		MsgInfo("Demanda Não foi encontrada", "Solic. transferências")
		lRet := .f.
	endif

Return lRet


Static Function prepSol(cDemanda,aTrans,cMens)
	Local lRet := .t.

	if cancReser(cDemanda,@cMens)
		if !u_renp090(aTrans,@cMens)
			lRet := .f.
		endif
	else
		lRet := .f.
	endif

Return lRet


Static Function cancReser(cDemanda,cMens)

	Local lRet := .t.
	Local lAchou := .f.

	Local aOperacao:= {}
	Local cReserva := ""
	Local cMaterial := ""
	local cLocal := ""
	local cLocaliz := ""
	local nQuant := 0

	local aLote	:= {"","","",""}	//C0_NUMLOTE,C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI

	Private aHeader := {}
	Private aCols	:= {}

	sc0->(dbSetOrder(1))
	szn->(dbSetOrder(1))
	szn->(dbSeek(xFilial()+cDemanda))
	while !szn->(eof()) .and. szn->zn_filial == szn->(xFilial()) .and. szn->zn_demanda == cDemanda

		lAchou := .f.

		if sc0->(DbSeek(xFilial()+szn->zn_codres+szn->zn_materia+szn->zn_local))
			while !sc0->(eof()) .and. sc0->c0_filial == szn->zn_filial .and. ;
					sc0->c0_num == szn->zn_codres .and. sc0->c0_produto == szn->zn_materia .and. ;
					sc0->c0_local == szn->zn_local

				if sc0->c0_localiz == szn->zn_localiz

					lAchou := .t.
					aOperacao:= {3,sc0->c0_tipo,sc0->c0_docres,sc0->c0_solicit,sc0->c0_filial}
					cReserva := sc0->c0_num
					cMaterial := sc0->c0_produto
					cLocal := sc0->c0_local
					cLocaliz := sc0->c0_localiz
					nQuant := sc0->c0_quant
					aLote[3] := cLocaliz

					if !a430Reserv(aOperacao,cReserva,cMaterial,cLocal,nQuant,aLote,aHeader,aCols)
						lRet := .f.
						cMens += 'Exclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+', não foi realizada. '
					endif
				endif

				sc0->(dbskip())
			end
		else
			if szn->zn_qtdcons == 0
				lAchou := .t.
			endif
		endif

		if !lAchou
			lRet := .f.
			cMens += 'Reserva do item '+alltrim(szn->zn_materia)+'/'+szn->zn_local+'/'+alltrim(szn->zn_localiz)+', não foi encontrada e exclusão reserva não foi realizada. '
		endif

		szn->(dbskip())
	end

Return lRet
