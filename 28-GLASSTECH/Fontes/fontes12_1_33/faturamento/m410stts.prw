#Include "Protheus.ch"

User Function m410stts()
	Local nOper := PARAMIXB[1]		//3 - Inclusão;4 - Alteração;5 - Exclusão;6 - Cópia;7 - Devolução de Compras
	Local cJobFil := ""
	Local cJobMod := "FAT"
	Local aCab := {}
	Local aLinha := {}
	Local aItens := {}
	Local cErro := ""
	Local cQuery := ""
	local nFator := 0

	If nOper == 3

		if sc5->c5_xtpfatu == "2"

			scj->(dbSetOrder(1))
			sck->(dbSetOrder(1))
			sc6->(dbSetOrder(1))
			sc6->(dbseek(xfilial()+sc5->c5_num))
			if !empty(sc6->c6_numorc) .and. scj->(dbseek(xfilial()+substr(sc6->c6_numorc,1,6)))

				nFator := u_gtf002(scj->cj_xnivel,scj->cj_xtpfatu,cEstE)

				if sc5->c5_cliente == "016016"	//SP
					cJobFil := "0701"
				elseif sc5->c5_cliente == "023895"	//RJ
					cJobFil := "1602"
				elseif sc5->c5_cliente == "022979"	//MG
					cJobFil := "1601"
				endif

				if !empty(cJobFil)
					aadd(aCab, {"C5_NUM"    , ""			  ,Nil})
					aadd(aCab, {"C5_TIPO"   , "N"			  ,Nil})	// TIPO PEDIDO SEMPRE N-NORMAL
					aadd(aCab, {"C5_CLIENTE", scj->cj_cliente ,Nil})
					aadd(aCab, {"C5_LOJACLI", scj->cj_lojacli ,Nil})
					aadd(aCab, {"C5_TRANSP" , scj->cj_zztrans ,Nil})
					aadd(aCab, {"C5_FORMAPG", scj->cj_formapg ,Nil})  //
					aadd(aCab, {"C5_CONDPAG", scj->cj_condpag ,Nil})  //
					aadd(aCab, {"C5_TABELA"	, scj->cj_tabela  ,Nil})  //
					aadd(aCab, {"C5_VEND1"	, scj->cj_zzven   ,Nil})  // - ?

					sck->( dbSeek(xFilial()+scj->cj_num) )
					While sck->(!Eof()) .and. sck->ck_num == scj->cj_num

						aLinha := {}
						aadd(aLinha,{"C6_ITEM"   ,sck->ck_item   ,Nil})
						aadd(aLinha,{"C6_PRODUTO",sck->ck_produto,Nil})
						aadd(aLinha,{"C6_LOCAL"	 ,sck->ck_Local  ,Nil})
						aadd(aLinha,{"C6_QTDVEN" ,sck->ck_qtdven ,Nil})
						aadd(aLinha,{"C6_PRCVEN" ,round(sck->ck_prcven*nFator,2) ,Nil})
						aadd(aLinha,{"C6_VALOR"  ,round(sck->ck_valor*nFator,2)  ,Nil})
						aadd(aLinha,{"C6_TES"    ,cTes			 ,Nil})
						aadd(aLinha,{"C6_PRUNIT" ,round(sck->ck_prcven*nFator,2) ,Nil})
						//aadd(aLinha,{"C6_QTDLIB" ,nQtdLib		,Nil})
						aadd(aItens, aLinha)

						sck->(dbskip())
					end

					lOk := startjob("u_gta003",getenvserver(),.t.,cEmpAnt,cJobFil,cJobMod,3,aCab,aItens,@cErro)
					if !lOk
						MsgInfo(cErro, "Inclusão do pedido")
					endif
				else
					MsgInfo("Pedido esta fora da regra, favor verificar!", "Inclusão do pedido")
				endif
			endif

		endif
	elseif nOper == 5

		scj->(dbSetOrder(1))
		sck->(dbSetOrder(1))

		cQuery := "select distinct c6_numorc from "+RetSqlname("SC6")
		cQuery += " where c6_filial = '"+sc6->(xfilial())+"' and c6_num = '"+sc5->c5_num+"' and d_e_l_e_t_ = '*' and c6_numorc != ' '"
		dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),"tmp",.f.,.t.)
		while !tmp->(eof())
			if scj->(dbseek(xfilial()+substr(tmp->c6_numorc,1,6)))
				scj->(RecLock("SCJ",.f.))
				scj->cj_status := "A"
				scj->(MsUnLock())

				sck->(dbSeek(xFilial()+scj->cj_num))
				While sck->(!Eof()) .and. scj->cj_filial == sck->ck_filial .and. scj->cj_num == sck->ck_num
					if !Empty(sck->ck_numpv)
						sck->(RecLock("SCK",.f.))
						sck->ck_numpv   := " "
						sck->ck_xdescV  := 0
						sck->ck_xdescG  := 0
						sck->ck_xvldesG := 0
						sck->ck_descont := 0
						sck->ck_valdesc := 0
						sck->ck_prcven  := sck->ck_prunit
						sck->ck_valor   := sck->ck_prunit * sck->ck_qtdven
						sck->(MsUnLock())
					endif
					sck->(dbskip())
				end
			endif
			tmp->(dbskip())
		end
		tmp->(dbclosearea())
	endif

return nil
