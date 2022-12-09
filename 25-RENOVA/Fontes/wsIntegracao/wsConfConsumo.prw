#include 'Protheus.ch'
#include 'Restful.ch'
#include 'tbiconn.ch'
//#include "Topconn.ch"

class itconfConsumo			/* Classe Itens da Solicitação de Reserva */

	data cod
	data qtd
	data armazem
	data endereco
	data armDePara
	data endDePara

	// Declaração dos Métodos da Classe
	method new() constructor

endclass


method new() class itconfConsumo

	::cod := ""
	::qtd := 0
	::armazem := ""
	::endereco := ""
	::armDePara := ""
	::endDePara := ""

Return Self


	class confConsumo			/* Classe Solicitação de Reserva */

		data grupo
		data filial
		data OScmms
		data OSfinal
		data itens
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass


method new() class confConsumo

	::grupo := ""
	::filial := ""
	::OScmms := ""
	::OSfinal := ""
	::itens := {}

Return Self


	WsRestful wsconfConsumo  Description 'Confirmação do material aplicado na manutenção' format "application/json"

		WsMethod POST Description 'Confirmação do material aplicado na manutenção' WsSyntax ""

	End WsRestful

WsMethod POST WsService wsconfConsumo

	local lRet  := .t.
	Local cJson := ::getContent()
	Local oResp

	::SetContentType("application/json; charset=utf-8")
	oResp := fazConsumo(cJson)
	::SetResponse(oResp:toJson())
	FreeObj(oResp)

Return lRet


Static Function fazConsumo(cJson)

	local lRet   := .t.
	Local cCodRet:= ""
	Local cDemanda:= ""
	Local cMens  := ""

	Local cGru   := ""
	Local cFil   := ""

	Local oJson := JsonObject():New()
	Local oResp := JsonObject():New()

	if u_critJson(cJson,@cMens)

		oJson:fromJson(cJson)
		cGru := oJson['grupo']
		cFil := oJson['filial']
		if empty(cGru)
			cGru := "00"
		endif
		if empty(cFil)
			cFil := "1330001"
		endif

		if u_abrirAmb(cGru,cFil,"FAT")

			if critConsumo(oJson,@cDemanda,@cMens)

				if confConsumo(oJson,@cDemanda,@cMens)
					cCodRet := "201"
				else
					lRet := .f.
					cCodRet := "400"
				endif

			else
				lRet := .f.
				cCodRet := "400"
			endif

			if lRet
				szb->(RecLock("szb", .t.))
				szb->zb_filobj := cFilAnt
				szb->zb_tipreg := "C"		//Consumo
				szb->zb_codobj := cDemanda
				szb->zb_idreg  := cDemanda
				szb->zb_ativo  := "1"
				szb->(MsUnlock())
			endif

			szc->(RecLock("szc", .t.))
			szc->zc_filobj := cFilAnt
			szc->zc_tipreg := "C"
			szc->zc_codobj := cDemanda
			szc->zc_oper := "I"
			szc->zc_local  := 'P'
			szc->zc_dtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
			if lRet
				szc->zc_status := "R"
			else
				szc->zc_status := 'F'
			endif
			szc->zc_mensag := cMens
			szc->(MsUnlock())

			RpcClearEnv()
		else
			cDemanda := "000000"
			lRet := .f.
			cCodRet := "400"
			cMens := "Não conseguiu abrir o Ambiente Protheus"
		endif
	else
		cDemanda := "000000"
		lRet := .f.
		cCodRet := "500"
	endif

	oResp['codigo'] := cCodRet
	oResp['demanda'] := cDemanda
	oResp['Mensagem'] := cMens

	// Descarta o objeto json
	FreeObj(oJson)

return oResp


Static Function critConsumo(oJson,cDemanda,cError)

	Local lRet := .t.
	Local nI   := 0
	Local nX   := 0

	Local cOScmms := oJson['OScmms']
	Local cEmis   := iif(oJson['emissao']==nil,"",oJson['emissao'])
	Local dEmis   := stod( replace(substr(cEmis,1,at(' ',cEmis)-1),"-","") )
	Local cNecess := iif(oJson['necessidade']==nil,"",oJson['necessidade'])
	Local dNecess := stod( replace(cNecess,"-","") )
	Local cDestino:= oJson['destino']
	Local cDtFim  := iif(oJson['OSfinal']==nil,"",oJson['OSfinal'])
	Local dDtFim  := stod( replace(substr(cDtFim,1,at(' ',cDtFim)-1),"-","") )
	Local aItens  := iif(oJson['itens']==nil,{},oJson['itens'])
	Local aDePara := {}

	Local cMaterial := space(TamSx3("B1_COD")[1])
	Local nQuant := 0
	Local cLocal := space(TamSx3("B2_LOCAL")[1])
	Local cLocaliz := space(TamSx3("BF_LOCALIZ")[1])
	Local nQtdDP := 0
	Local cLocDP := space(TamSx3("B2_LOCAL")[1])
	Local cEndDP := space(TamSx3("BF_LOCALIZ")[1])

	Local aEnviado := {}

	nnr->(dbSetOrder(1))
	sbe->(dbSetOrder(1))
	sb1->(dbSetOrder(1))
	sm0->(dbSetOrder(1))
	sc0->(DbSetOrder(1))
	szm->(dbSetOrder(2))
	if szm->(dbSeek(xFilial()+cOScmms))
		cDemanda := szm->zm_demanda
		if szm->zm_situa != '2'
			cError := "A confirmação do consumo não pode ser feita, pois o status da demanda não indica que materiais estão em campo."
			lRet := .f.
		endif
	else
		cDemanda := "000000"
		//cError := "A Solicitação de reserva referente a OS "+alltrim(cOScmms)+", não foi encontrada."
		//lRet := .f.
	endif

	if empty(cDestino)
		cError := "Destino que será efetuada a manutenção deve ser preenchido."
		lRet := .f.
	elseif !sm0->(dbSeek(cEmpAnt+cDestino))
		cError := "Destino enviado não foi encontrado."
		lRet := .f.
	elseif empty(cOScmms)
		cError := "O número da OS CMMS deve ser informado."
		lRet := .f.
	elseif empty(dEmis)
		cError := "Data emissao enviada não é válida."
		lRet := .f.
	elseif empty(dNecess)
		cError := "Data necessidade enviada não é válida."
		lRet := .f.
	elseif empty(dDtFim)
		cError := "Data do fim da manutenção enviada não é válida."
		lRet := .f.
	elseif len(aItens) == 0
		cError := "Não foram encaminhados os itens para a confirmação do consumo."
		lRet := .f.
	else
		for nI := 1 to len(aItens)

			cMaterial := Padr(aItens[nI]["cod"] ,TamSx3("B1_COD")[1])
			nQuant := aItens[nI]["qtd"]
			cLocal := Padr(aItens[nI]["armazem"] ,TamSx3("B2_LOCAL")[1])
			cLocaliz := Padr(aItens[nI]["endereco"] ,TamSx3("BF_LOCALIZ")[1])

			if !sb1->(dbseek(xfilial()+cMaterial))
				cError := "O código do material informado não existe."
				lRet := .f.
				//elseif nQuant <= 0
				//	cError := "A quantidade de solicitação deve ser maior que zero."
				//	lRet := .f.
			elseif !nnr->(dbseek(xfilial()+cLocal))
				cError := "O armazém "+cLocal+" não é válido."
				lRet := .f.
			elseif !sbe->(dbseek(xfilial()+cLocal+cLocaliz))
				cError := "O endereço DePara "+cLocaliz+" do armazém "+cLocal+" não foi encontrado."
				lRet := .f.
			else
				nQtdDP := 0
				cLocDP := space(TamSx3("B2_LOCAL")[1])
				cEndDP := space(TamSx3("BF_LOCALIZ")[1])
				aDePara := iif(aItens[nI]['dePara']==nil,{},aItens[nI]['dePara'])
				if len(aDePara) > 0
					for nX := 1 to len(aDePara)
						nQtdDP := aDePara[nX]["qtd"]
						cLocDP := Padr(aDePara[nX]["armazem"] ,TamSx3("B2_LOCAL")[1])
						cEndDP := Padr(aDePara[nX]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
						if nQtdDP <= 0
							cError := "A quantidade DePara deve ser maior que zero."
							lRet := .f.
						elseif empty(cLocDP+cEndDP)
							cError := "O armazém DePara e endereço DePara devem ser preenchidos."
							lRet := .f.
						else
							if cLocDP != cLocal
								cError := "O armazém DePara "+cLocDP+" e armazém origem não podem ser diferentes."
								lRet := .f.
							elseif !nnr->(dbseek(xfilial()+cLocDP))
								cError := "O armazém DePara "+cLocDP+" não é válido."
								lRet := .f.
							elseif !sbe->(dbseek(xfilial()+cLocDP+cEndDP))
								cError := "O endereço DePara "+cEndDP+" do armazém "+cLocDP+" não foi encontrado."
								lRet := .f.
							endif
						endif
					next
				endif
				if lRet
					for nX := 1 to len(aEnviado)
						if aEnviado[nX,1] == cMaterial .and. aEnviado[nX,2] == cLocal .and. aEnviado[nX,3] == cLocaliz
							cError := "O material "+cMaterial+" foi enviado mais de uma vez com o mesmo armazém e endereço "+cLocal+"/"+cLocaliz
							lRet := .f.
						endif
					next
				endif
				if lRet
					if !critEst(cDemanda,cMaterial,nQuant,cLocal,cLocaliz,aDePara,@cError)
						lRet := .f.
					endif
				endif
			endif
			aadd(aEnviado,{cMaterial,cLocal,cLocaliz})

		next

		if lRet .and. !szm->(eof())
			szn->(dbSetOrder(2))
			szn->(dbSeek(xFilial()+cDemanda))
			while !szn->(eof()) .and. szn->zn_filial == szm->zm_filial .and. szn->zn_demanda == cDemanda .and. lRet
				nI := aScan(aEnviado, {|x| x[1]==szn->zn_matpai})
				if nI == 0
					cError := "O consumo do material "+szn->zn_matpai+" não foi informado."
					lRet := .f.
				endif
				szn->(dbskip())
			end
		endif

	endif

Return lRet


Static Function critEst(cDemanda,cMaterial,nQuant,cLocal,cLocaliz,aDePara,cError)

	local lRet := .t.
	/*
	local nSldAtu := 0
	Local nX := 0
	Local nQtd := 0
	Local cQuery := ""
	Local nQtdDP := 0
	Local cLocDP := space(TamSx3("B2_LOCAL")[1])
	Local cEndDP := space(TamSx3("BF_LOCALIZ")[1])
	*/
	szn->(dbSetOrder(2))
	if szn->(dbSeek(xFilial()+cDemanda+cMaterial+cLocal+cLocaliz))
		if nQuant > szn->zn_quapai
			lRet := .f.
			cError := "A qtd consumida do material "+szn->zn_materia+" não pode exceder ao quantidade programada. Favor verificar!"
			/*
			while !szn->(eof()) .and. szn->zn_filial == szm->(xFilial()) .and. szn->zn_demanda == cDemanda .and. ;
					szn->zn_matpai == cMaterial .and. szn->zn_local == cLocal .and. szn->zn_localiz == cLocaliz .and. lRet

				if szn->zn_matpai != szn->zn_materia .and. sg1->(dbSeek(xFilial()+szn->zn_matpai+szn->zn_materia))
					nqtd := nQuant * sg1->g1_quant
				else
					nqtd := nQuant
				endif

				lRet := u_verReserv(cDemanda,szn->zn_materia,szn->zn_local,szn->zn_localiz,cSitua,cMens)
				if lRet
					if len(aDePara) == 0
						nSldAtu := u_verSaldo(szn->zn_materia,cLocal,cLocaliz)
						if nSldAtu < nqtd-szn->zn_quant
							lRet := .f.
							cError := "O material "+szn->zn_materia+'/'+cLocal+'/'+alltrim(cLocaliz)+" não possui estoque para atender o consumo."
						endif
					else
						for nX := 1 to len(aDePara)
							nQtdDP := aDePara[nX]["qtd"]
							cLocDP := Padr(aDePara[nX]["armazem"] ,TamSx3("B2_LOCAL")[1])
							cEndDP := Padr(aDePara[nX]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
							nSldAtu := u_verSaldo(szn->zn_materia,cLocDP,cEndDP)
							if nSldAtu < nQtdDP
								lRet := .f.
								cError := "O material "+szn->zn_materia+'/'+cLocDP+'/'+alltrim(cEndDP)+" não possui estoque para atender o consumo."
							endif
						next
					endif
				endif

				szn->(dbskip())
			end*/
		endif
	else
		lRet := .f.
		cError := "O material "+cMaterial+" não pode ser acrescentado na demanda. Favor verificar!"
		/*
		cQuery := "select g1_filial,g1_cod,g1_comp,g1_quant from "+RetSQLName("SG1")+" g1 "
		cQuery += "where g1_filial = '"+xFilial("SG1")+"' and g1_cod = '"+cMaterial+"' and g1.d_e_l_e_t_ = ' ' "
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),"trb",.f.,.t.)
		if !trb->( eof() )
			//sbf->(dbSetOrder(1))
			while !trb->( eof() ) .and. lRet
				nqtd := nQuant * trb->g1_quant
				if len(aDePara) == 0
					nSldAtu := u_verSaldo(trb->g1_comp,cLocal,cLocaliz)
					if nSldAtu < nqtd
						lRet := .f.
						cError := "O material "+trb->g1_comp+'/'+cLocal+'/'+alltrim(cLocaliz)+" não possui estoque para atender o consumo."
					endif
				else
					for nX := 1 to len(aDePara)
						nQtdDP := aDePara[nX]["qtd"]
						nqtd := nQtdDP * trb->g1_quant
						cLocDP := Padr(aDePara[nX]["armazem"] ,TamSx3("B2_LOCAL")[1])
						cEndDP := Padr(aDePara[nX]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
						nSldAtu := u_verSaldo(trb->g1_comp,cLocDP,cEndDP)
						if nSldAtu < nqtd
							lRet := .f.
							cError := "O material "+trb->g1_comp+'/'+cLocDP+'/'+alltrim(cEndDP)+" não possui estoque para atender o consumo."
						endif
					next
				endif

				trb->( DbSkip() )
			end
		else
			if len(aDePara) == 0
				nSldAtu := u_verSaldo(cMaterial,cLocal,cLocaliz)
				if nSldAtu < nQuant
					lRet := .f.
					cError := "O material "+cMaterial+'/'+cLocal+'/'+alltrim(cLocaliz)+" não possui estoque para atender o consumo."
				endif
			else
				for nX := 1 to len(aDePara)
					nQtdDP := aDePara[nX]["qtd"]
					cLocDP := Padr(aDePara[nX]["armazem"] ,TamSx3("B2_LOCAL")[1])
					cEndDP := Padr(aDePara[nX]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
					nSldAtu := u_verSaldo(cMaterial,cLocDP,cEndDP)
					if nSldAtu < nQtdDP
						lRet := .f.
						cError := "O material "+cMaterial+'/'+cLocDP+'/'+alltrim(cEndDP)+" não possui estoque para atender o consumo."
					endif
				next
			endif
		endif
		trb->( DbCloseArea() )
		*/
	endif

Return lret


Static Function confConsumo(oJson,cDemanda,cMens)

	Local lRet := .t.
	Local nI   := 0
	Local nX   := 0

	Local cOScmms := oJson['OScmms']
	Local cEmis   := oJson['emissao']
	Local dEmis   := stod( replace(substr(cEmis,1,at(' ',cEmis)-1),"-","") )
	Local cHora   := substr(cEmis,at(' ',cEmis)+1,8)
	Local cNecess := oJson['necessidade']
	Local dNecess := stod( replace(cNecess,"-","") )
	Local cDestino:= oJson['destino']

	Local cDtFim  := oJson['OSfinal']
	Local dDtFim  := stod( replace(substr(cDtFim,1,at(' ',cDtFim)-1),"-","") )
	Local cHrFim  := substr(cDtFim,at(' ',cDtFim)+1,8)
	Local aItens  := oJson['itens']

	Local aIt       := {}
	Local aNovos    := {}

	Local aOperacao := {}
	//aOperacao:
	//1 - Operacao : 1 Inclui,2 Altera,3 Exclui
	//2 - Tipo da Reserva - LB = Liberação, VD = Vendedor, CL = Cliente, PD = Pedido, NF = Nota fiscal, LJ = Sigaloja
	//3 - Documento que originou a Reserva
	//4 - Solicitante
	//5 - Filial da Reserva
	Local cMaterial := ''				//C0_PRODUTO
	Local cLocal	:= ''				//C0_LOCAL
	Local nQuant	:= 0				//C0_QUANT
	Local nqtd		:= 0
	Local cTpmov 	:= ""

	Local aDePara := {}
	Local nQtdDP := 0
	Local cLocDP := space(TamSx3("B2_LOCAL")[1])
	Local cEndDP := space(TamSx3("BF_LOCALIZ")[1])
	/*
	Local lFez := .t.
	Local nqtdTrf := 0
	Local cLocOri := ""
	Local cEndOri := ""
	Local cLocDes := ""
	Local cEndDes := ""
	*/

	sg1->(DbSetOrder(1))
	szn->(dbSetOrder(2))

	if cDemanda == "000000"
		cDemanda := u_renp055()
		szm->(RecLock("szm",.t.))
		szm->zm_filial 	:= szm->(xfilial())
		szm->zm_demanda := cDemanda
		szm->zm_codios 	:= cOScmms
		szm->zm_emissao	:= dEmis
		szm->zm_hora	:= cHora
		szm->zm_dtneces	:= dNecess
		szm->zm_destino	:= cDestino
		szm->zm_dtfim	:= StoD(' ')
		szm->zm_horafi	:= ' '
		szm->zm_situa	:= '2'
		szm->(MsUnLock())
	endif

	aIt := fazIt(aItens)

	for nI := 1 to len(aIt)

		cMaterial := aIt[nI,1]
		nQuant := aIt[nI,2]
		cLocal := aIt[nI,3]
		cLocaliz := aIt[nI,4]
		aDePara := fazDP(aItens,cMaterial,cLocal,cLocaliz)

		if szn->(dbSeek(xFilial()+cDemanda+cMaterial+cLocal+cLocaliz))
			while !szn->(eof()) .and. szn->zn_filial == szm->zm_filial .and. ;
					szn->zn_demanda == cDemanda .and. szn->zn_matpai == cMaterial .and. ;
					szn->zn_local == cLocal .and. szn->zn_localiz == cLocaliz

				if szn->zn_matpai != szn->zn_materia .and. sg1->(dbSeek(xFilial()+szn->zn_matpai+szn->zn_materia))
					nqtd := nQuant * sg1->g1_quant
				else
					nqtd := nQuant
				endif
				/*
				lFez := .t.
				if nqtd != szn->zn_quant
					if nqtd < szn->zn_quant
						lFez := u_altReserva(szn->zn_codres,szn->zn_materia,szn->zn_local,szn->zn_localiz,@nqtd,@cMens)
					endif
					if lFez .and. len(aDePara) > 0
						for nX := 1 to len(aDePara)
							nQtdDP := aDePara[nX,1]
							cLocDP := aDePara[nX,2]
							cEndDP := aDePara[nX,3]
							if cLocal+cLocaliz != cLocDP+cEndDP
								if nqtd > szn->zn_quant
									nqtdTrf := nQtdDP
									cLocOri := cLocDP
									cEndOri := cEndDP
									cLocDes := cLocal
									cEndDes := cLocaliz
								else
									nqtdTrf := nQtdDP
									cLocOri := cLocal
									cEndOri := cLocaliz
									cLocDes := cLocDP
									cEndDes := cEndDP
								endif
								if !u_renp090({{szn->zn_materia,nqtdTrf,cLocOri,cEndOri,cLocDes,cEndDes}},@cMens)
									lFez := .f.
								endif
							endif
						next
					endif
					if lFez .and. nqtd > szn->zn_quant
						lFez := u_altReserva(szn->zn_codres,szn->zn_materia,szn->zn_local,szn->zn_localiz,@nqtd,@cMens)
					endif
				endif
				if lFez*/
					szn->(RecLock("szn",.f.))
					szn->zn_qtdcons := nqtd
					szn->zn_conspai := nQuant
					szn->(MsUnLock())

					if nqtd != szn->zn_quant .and. len(aDePara) > 0
						cTpmov := ""
						if nqtd > szn->zn_quant
							cTpmov := "O"
						else
							cTpmov := "D"
						endif
						for nX := 1 to len(aDePara)
							nQtdDP := aDePara[nX,1]
							cLocDP := aDePara[nX,2]
							cEndDP := aDePara[nX,3]

							szo->(RecLock("szo",.t.))
							szo->zo_filial := szo->(xfilial())
							szo->zo_demanda := szn->zn_demanda
							szo->zo_materia:= szn->zn_materia
							szo->zo_local  := szn->zn_local
							szo->zo_localiz:= szn->zn_localiz
							szo->zo_adesori:= cLocDP
							szo->zo_edesori:= cEndDP
							szo->zo_quant := nQtdDP
							szo->zo_tpmov  := cTpmov
							szo->(MsUnLock())
						next
					endif
				/*
				else
					lRet := .f.
				endif
				*/
				szn->(dbskip())
			end
		else
			aadd(aNovos,{cMaterial,nQuant,cLocal,cLocaliz,aDePara})
		endif
	next

	if lRet .and. len(aNovos) > 0
		aOperacao := {1,"PD",cDemanda,"CMMS",xFilial("SC0")}
		if !fazInclIt(aOperacao,cDemanda,aNovos,@cMens)
			lRet := .f.
		endif
	endif

	if lRet
		szm->(RecLock("szm",.f.))
		szm->zm_dtfim := dDtFim
		szm->zm_horafi := cHrFim
		szm->zm_situa := "3"
		szm->(MsUnLock())
		cMens += 'O Consumo da demanda '+cDemanda+' foi informada com sucesso. '
	endif

Return lRet


static function fazIt(aItens)

	Local aIt := {}
	Local nI := 0
	Local cMaterial := space(TamSx3("B1_COD")[1])
	Local cLocal := space(TamSx3("B2_LOCAL")[1])
	Local cLocaliz := space(TamSx3("BF_LOCALIZ")[1])

	for nI := 1 to len(aItens)
		cMaterial := Padr(aItens[nI]["cod"] ,TamSx3("B1_COD")[1])
		cLocal :=  Padr(aItens[nI]["armazem"] ,TamSx3("B2_LOCAL")[1])
		cLocaliz := Padr(aItens[nI]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
		aadd(aIt, {cMaterial, aItens[nI]["qtd"], cLocal, cLocaliz} )
	next

Return aIt


Static Function fazDP(aItens,cMatPes,cArmPes,cEndPes)

	Local aDePara := {}
	Local nI := 0
	Local nX := 0
	Local cMaterial := space( TamSx3("B1_COD")[1] )
	Local cLocal := space(TamSx3("B2_LOCAL")[1] )
	Local cLocaliz := space(TamSx3("BF_LOCALIZ")[1] )

	Local aDP := {}
	Local nQtdDP := 0
	Local cLocDP := space(TamSx3("B2_LOCAL")[1])
	Local cEndDP := space(TamSx3("BF_LOCALIZ")[1])

	for nI := 1 to len(aItens)
		cMaterial := Padr(aItens[nI]["cod"] ,TamSx3("B1_COD")[1])
		cLocal := Padr(aItens[nI]["armazem"] ,TamSx3("B2_LOCAL")[1])
		cLocaliz := Padr(aItens[nI]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
		if cMatPes == cMaterial .and. cArmPes == cLocal .and. cEndPes == cLocaliz
			aDP := iif(aItens[nI]['dePara']==nil,{},aItens[nI]['dePara'])
			for nX := 1 to len(aDP)
				nQtdDP := aDP[nX]["qtd"]
				cLocDP := Padr(aDP[nX]["armazem"] ,TamSx3("B2_LOCAL")[1])
				cEndDP := Padr(aDP[nX]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
				aadd(aDePara,{nQtdDP,cLocDP,cEndDP})
			next
		endif
	next

Return aDePara


static function fazInclIt(aOperacao,cDemanda,aItens,cMens)

	Local lRet := .t.
	Local cQuery := ""
	Local nqtd := 0
	Local nI := 0

	Local cMaterial := ""
	Local nQuant   := 0
	Local cLocal   := ""
	Local cLocaliz := ""

	Local aDePara := {}
	Local nQtdDP := 0
	Local cLocDP := space(TamSx3("B2_LOCAL")[1])
	Local cEndDP := space(TamSx3("BF_LOCALIZ")[1])

	Local aLote		:= {"","","",""}	//C0_NUMLOTE,C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI

	local nX := 0
	local aRerv    := {}
	local nSldAtu := 0
	local cReserva := ""

	Private aHeader := {}
	Private aCols	:= {}

	for nI := 1 to len(aItens)
		cMaterial := aItens[nI,1]
		nQuant := aItens[nI,2]
		cLocal := aItens[nI,3]
		cLocaliz := aItens[nI,4]
		aDePara := aItens[nI,5]

		aLote[3] := cLocaliz

		cQuery := "select g1_filial,g1_cod,g1_comp,g1_quant from "+RetSQLName("SG1")+" g1 "
		cQuery += "where g1_filial = '"+xFilial("SG1")+"' and g1_cod = '"+cMaterial+"' and g1.d_e_l_e_t_ = ' ' "
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),"trb",.f.,.t.)
		if !trb->( eof() )
			while !trb->( eof() )
				nqtd := nQuant * trb->g1_quant
				if lFez .and. len(aDePara) > 0
					for nX := 1 to len(aDePara)
						nQtdDP := aDePara[nX,1]
						cLocDP := aDePara[nX,2]
						cEndDP := aDePara[nX,3]
						if cLocal+cLocaliz != cLocDP+cEndDP
							if !u_renp090({{trb->g1_comp,nQtdDP,cLocDP,cEndDP,cLocal,cLocaliz}},@cMens)
								lFez := .f.
							endif
						endif
					next
				endif
				if lRet
					nSldAtu := u_verSaldo(trb->g1_comp,cLocal,cLocaliz)
					if nSldAtu >= nqtd
						nX := aScan(aRerv, {|x| x[1]==trb->g1_comp})
						if len(aRerv) == 0 .or. nX != 0
							aRerv := {}
							cReserva := u_renp050()
						endif
						aadd(aRerv, {trb->g1_comp} )
						if !a430Reserv(aOperacao,cReserva,trb->g1_comp,cLocal,nqtd,aLote,aHeader,aCols)
							lRet := .f.
							cMens += "Problemas na inclusão da reserva do item - "+alltrim(trb->g1_comp)+'/'+cLocal+'/'+alltrim(cLocaliz)+'. '
						endif
					else
						lRet := .f.
						cMens := "O material "+trb->g1_comp+'/'+cLocal+'/'+alltrim(cLocaliz)+" não possui estoque para atender o consumo."
					endif
				endif
				if lRet
					if szn->(RecLock("szn",.t.))
						szn->zn_filial := szn->(xfilial())
						szn->zn_demanda:= cDemanda
						szn->zn_materia:= trb->g1_comp
						szn->zn_local  := cLocal
						szn->zn_localiz:= cLocaliz
						szn->zn_qorig  := nqtd
						szn->zn_quant  := nqtd
						szn->zn_codres := cReserva
						szn->zn_qtdcons:= nqtd
						szn->zn_matpai := cMaterial
						szn->zn_qorpai := nQuant
						szn->zn_quapai := nQuant
						szn->zn_conspai:= nQuant
						szn->(MsUnLock())

						for nX := 1 to len(aDePara)
							nQtdDP := aDePara[nX,1]
							cLocDP := aDePara[nX,2]
							cEndDP := aDePara[nX,3]

							szo->(RecLock("szo",.t.))
							szo->zo_filial := szo->(xfilial())
							szo->zo_demanda:= szn->zn_demanda
							szo->zo_materia:= szn->zn_materia
							szo->zo_local  := szn->zn_local
							szo->zo_localiz:= szn->zn_localiz
							szo->zo_adesori:= cLocDP
							szo->zo_edesori:= cEndDP
							szo->zo_quant  := nQtdDP
							szo->zo_tpmov  := "O"
							szo->(MsUnLock())
						next
					else
						lRet := .f.
						cMens += 'Problemas na inclusão do item '+alltrim(trb->g1_comp)+'/'+cLocal+' no controle de demandas. '
					endif
				endif
				trb->( DbSkip() )
			end
		else
			if lRet .and. len(aDePara) > 0
				for nX := 1 to len(aDePara)
					nQtdDP := aDePara[nX,1]
					cLocDP := aDePara[nX,2]
					cEndDP := aDePara[nX,3]
					if lRet .and. cLocal+cLocaliz != cLocDP+cEndDP
						if !u_renp090({{cMaterial,nQtdDP,cLocDP,cEndDP,cLocal,cLocaliz}},@cMens)
							lRet := .f.
						endif
					endif
				next
			endif
			if lRet
				nSldAtu := u_verSaldo(cMaterial,cLocal,cLocaliz)
				if nSldAtu >= nqtd
					nX := aScan(aRerv, {|x| x[1]==trb->g1_comp})
					if len(aRerv) == 0 .or. nX != 0
						aRerv := {}
						cReserva := u_renp050()
					endif
					aadd(aRerv, {cMaterial} )
					if !a430Reserv(aOperacao,cReserva,cMaterial,cLocal,nQuant,aLote,aHeader,aCols)
						lRet := .f.
						cMens += 'Problemas na inclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+'. '
					endif
				else
					lRet := .f.
					cMens := "O material "+cMaterial+'/'+cLocal+'/'+alltrim(cLocaliz)+" não possui estoque para atender o consumo."
				endif

				if lRet
					if szn->(RecLock("szn",.t.))
						szn->zn_filial := szn->(xfilial())
						szn->zn_demanda:= cDemanda
						szn->zn_materia:= cMaterial
						szn->zn_local  := cLocal
						szn->zn_localiz:= cLocaliz
						szn->zn_qorig  := nQuant
						szn->zn_quant  := nQuant
						szn->zn_codres := cReserva
						szn->zn_qtdcons:= nQuant
						szn->zn_matpai := cMaterial
						szn->zn_qorpai := nQuant
						szn->zn_quapai := nQuant
						szn->zn_conspai:= nQuant
						szn->(MsUnLock())

						for nX := 1 to len(aDePara)
							nQtdDP := aDePara[nX,1]
							cLocDP := aDePara[nX,2]
							cEndDP := aDePara[nX,3]
							szo->(RecLock("szo",.t.))
							szo->zo_filial := szo->(xfilial())
							szo->zo_demanda := szn->zn_demanda
							szo->zo_materia:= szn->zn_materia
							szo->zo_local  := szn->zn_local
							szo->zo_localiz:= szn->zn_localiz
							szo->zo_adesori:= cLocDP
							szo->zo_edesori:= cEndDP
							szo->zo_quant := nQtdDP
							szo->zo_tpmov  := "O"
							szo->(MsUnLock())
						next

					else
						lRet := .f.
						cMens += 'Problemas na inclusão do item '+alltrim(cMaterial)+'/'+cLocal+' no controle de demandas. '
					endif
				endif
			endif
		endif
		trb->( DbCloseArea() )
	next

Return lRet

User Function verReserv(cDemanda,cMaterial,cArmazem,cEndereco,cSitua,cMens)

	local lRet := .t.
	local lAchou := .t.
	local nQuant := 0

	szn->(dbSetOrder(1))
	if szn->(dbSeek(xFilial()+cDemanda+cMaterial+cArmazem+cEndereco))
		lAchou := .f.
		if sc0->(DbSeek(xFilial()+szn->zn_codres+szn->zn_materia+szn->zn_local))
			while !sc0->(eof()) .and. sc0->c0_filial == szn->zn_filial .and. ;
					sc0->c0_num == szn->zn_codres  .and. sc0->c0_produto == szn->zn_materia .and. ;
					sc0->c0_local == szn->zn_local .and. lRet
				if sc0->c0_localiz == szn->zn_localiz
					lAchou := .t.
					nQuant := iif(cSitua<="2",szn->zn_quant,szn->zn_qtdcons)
					if nQuant != sc0->c0_quant
						cMens := "A qtd programada do material "+szn->zn_materia+" não esta iqual a qtd resevada"
						lRet := .f.
					endif
				endif
				sc0->(dbskip())
			end
		endif
		if !lAchou
			cMens := "O material "+szn->zn_materia+" não esta reservado"
			lRet := .f.
		endif
	else
		cMens := "O material "+cMaterial+" não esta na demanda"
		lRet := .f.
	endif

return lRet
