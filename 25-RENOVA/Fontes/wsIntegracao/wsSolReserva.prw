#include 'Protheus.ch'
#include 'Restful.ch'
#include 'tbiconn.ch'
//#include "Topconn.ch"

class itsolReserva			/* Classe Itens da Solicitação de Reserva */

	data cod
	data qtd
	data armazem
	data endereco
	// Declaração dos Métodos da Classe
	method new() constructor

endclass


method new() class itsolReserva

	::cod := ""
	::qtd := 0
	::armazem := ""
	::endereco := ""

Return Self


	class solReserva			/* Classe Solicitação de Reserva */

		data operacao
		data grupo
		data filial
		data OScmms
		data emissao
		data necessidade
		data destino
		data itens
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass


method new() class solReserva

	::operacao := ""
	::grupo := ""
	::filial := ""
	::OScmms := ""
	::emissao := ""
	::necessidade := ""
	::destino := ""
	::itens := {}

Return Self


	WsRestful wsSolReserva  Description 'Solicitação de Reserva' format "application/json"

		WsMethod POST Description 'Solicitação da Reserva' WsSyntax ""
		WsMethod PUT  Description 'Alteração da Solicitação da reserva' WsSyntax ""
		//WsMethod DELETE Description 'Exclusão da Solicitação da reserva' WsSyntax ""

	End WsRestful

WsMethod POST WsService wsSolReserva

	local lRet  := .t.
	Local cJson := ::getContent()
	Local oResp

	::SetContentType("application/json; charset=utf-8")
	oResp := fazReserva(cJson,"I")
	::SetResponse(oResp:toJson())
	FreeObj(oResp)

Return lRet


WsMethod PUT WsService wsSolReserva

	local lRet  := .t.
	Local cJson := ::getContent()
	Local oResp

	::SetContentType("application/json; charset=utf-8")
	oResp := fazReserva(cJson,"A")
	::SetResponse(oResp:toJson())
	FreeObj(oResp)

Return lRet
/*
WsMethod DELETE WsService wsSolReserva

	local lRet  := .t.
	Local cJson := ::getContent()
	Local oResp

	::SetContentType("application/json; charset=utf-8")
	oResp := fazReserva(cJson,"E")
	::SetResponse(oResp:toJson())
	FreeObj(oResp)

Return lRet
*/
Static Function fazReserva(cJson,cVerbo)	//cVerbo = "I"-Inclui; "A"-Altera; "E"-Exclui

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

			if critReserva(oJson,@cVerbo,@cDemanda,@cMens,@cCodRet)
				if SolReserva(oJson,cVerbo,@cDemanda,@cMens)
					cCodRet := "201"
				else
					lRet := .f.
					cCodRet := "400"
				endif
			else
				lRet := .f.
				//cCodRet := "400"
			endif

			if lRet
				if cVerbo == "I"
					szb->(RecLock("szb", .t.))
					szb->zb_filobj := cFilAnt
					szb->zb_tipreg := "R"		//Reserva
					szb->zb_codobj := cDemanda
					szb->zb_idreg  := cDemanda
					szb->zb_ativo  := "1"
					szb->(MsUnlock())
				elseif cVerbo == "E"
					szb->(DbSetOrder(1))
					if szb->(dbseek(xfilial()+cFilAnt+"R"+cDemanda))
						szb->(RecLock("szb", .f.))
						szb->zb_ativo  := "0"
						szb->(MsUnlock())
					endif
				endif
			endif

			szc->(RecLock("szc", .t.))
			szc->zc_filobj := cFilAnt
			szc->zc_tipreg := "R"
			szc->zc_codobj := cDemanda
			szc->zc_oper := cVerbo
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


Static Function critReserva(oJson,cVerbo,cDemanda,cError,cCodRet)	//cVerbo = "I"-Inclui; "A"-Altera; "E"-Exclui

	Local lRet := .t.
	Local nI   := 0
	Local nX   := 0

	Local cOper   := oJson['operacao']				//(I)nclusão; (A)lteração; (E)xclusão
	Local cOScmms := oJson['OScmms']
	Local cEmis   := oJson['emissao']
	Local dEmis   := stod( replace(substr(cEmis,1,at(' ',cEmis)-1),"-","") )
	Local dNecess := stod( replace(oJson['necessidade'],"-","") )
	Local cDestino:= oJson['destino']
	Local aItens  := iif(oJson['itens']==nil,{},oJson['itens'])

	local cMaterial := ""
	local cLocal := ""
	local cLocaliz := ""
	local nQuant := 0

	local nSldAtu := 0

	cCodRet := '400'

	nnr->(dbSetOrder(1))
	sbe->(dbSetOrder(1))
	sb1->(dbSetOrder(1))
	sm0->(dbSetOrder(1))
	szn->(dbSetOrder(1))
	szm->(dbSetOrder(2))
	szm->(dbSeek(xFilial()+cOScmms))
	if szm->(!eof())
		cDemanda := szm->zm_demanda
		if cVerbo == "I"
			cError := "A solicitação de reserva referente a OS "+alltrim(cOScmms)+", já foi incluida."
			cCodRet := '204'
			lRet := .f.
		else
			if !szm->zm_situa $ '0|1|6'
				cError := "A solicitação de reserva não pode ser Alterada nem excluida."
				lRet := .f.
			endif
		endif
	else
		cDemanda := "000000"
		if cVerbo != "I"
			cError := "A Solicitação de reserva referente a OS "+alltrim(cOScmms)+", não foi encontrada."
			lRet := .f.
		endif
	endif

	if lRet
		if empty(cOScmms)
			cError := "O número da OS CMMS deve ser informado."
			lRet := .f.
		else
			if cOper $ "I|A"
				if !sm0->(dbSeek(cEmpAnt+cDestino))
					cError := "Destino enviado não foi encontrado."
					lRet := .f.
				elseif empty(cDestino)
					cError := "Destino que será efetuada a manutenção deve ser preenchido."
					lRet := .f.
				elseif empty(dNecess)
					cError := "Data necessidade enviada não é válida."
					lRet := .f.
				endif
			endif
			if lRet
				if cVerbo == "I"
					if cOper != 'I'
						cError := "A operação "+cOper+", indicada no Json, esta incorreta."
						lRet := .f.
					elseif empty(dEmis)
						cError := "A data da emissão da OS CMMS deve ser informada."
						lRet := .f.
					elseif len(aItens) == 0
						cError := "Não foram encaminhados os itens da solicitação de reserva."
						lRet := .f.
					endif
				else
					if cVerbo == "A" .and. !cOper $ 'A|E'
						cError := "A operação "+cOper+", indicada no Json, esta incorreta."
						lRet := .f.
					elseif cOper == "A" .and. len(aItens) == 0
						cError := "Não foram encaminhados os itens para alteração da solicitação de reserva."
						lRet := .f.
					endif
				endif
			endif
			if lRet
				for nI := 1 to len(aItens)

					cMaterial := Padr(aItens[nI]["cod"] ,TamSx3("B1_COD")[1])
					cLocal := Padr(aItens[nI]["armazem"] ,TamSx3("B2_LOCAL")[1])
					cLocaliz := Padr( aItens[nI]["endereco"] ,TamSx3("BF_LOCALIZ")[1])
					nQuant := aItens[nI]["qtd"]

					if !sb1->(dbseek(xfilial()+cMaterial))
						cError := "O código do produto informado não existe."
						lRet := .f.
					elseif nQuant <= 0
						cError := "A quantidade de solicitação deve ser maior que zero."
						lRet := .f.
					elseif !nnr->(dbseek(xfilial()+cLocal))
						cError := "O armazém não é válido."
						lRet := .f.
					elseif !sbe->(dbseek(xfilial()+cLocal+cLocaliz))
						cError := "O endereço do armazém "+cLocal+" não é válido."
						lRet := .f.
					elseif cOper != "E"
						aEstru := retEstrut(cMaterial,nQuant)
						if len(aEstru) == 0

							if cVerbo == "A"
								if szn->(dbSeek(xFilial()+cDemanda+cMaterial+cLocal+cLocaliz))
									nQuant := nQuant - szn->zn_quant
								endif
							endif
							if nQuant > 0 .and. !critSaldo(cMaterial,cLocal,cLocaliz,nQuant,.t.,@nSldAtu,@cError)
								lRet := .f.
							endif

						else
							for nX := 1 to len(aEstru)	//cod prod filho,qtd total fiho,cod prod pai,qtd pai

								cMaterial := aEstru[nX, 1]
								nQuant := aEstru[nX, 2]

								if cVerbo == "A"
									if szn->(dbSeek(xFilial()+cDemanda+cMaterial+cLocal+cLocaliz))
										nQuant := nQuant - szn->zn_quant
									endif
								endif
								if nQuant > 0 .and. !critSaldo(cMaterial,cLocal,cLocaliz,nQuant,.t.,@nSldAtu,@cError)
									lRet := .f.
								endif
							next
						endif
					endif
				next
			endif

		endif
	endif

	if lRet
		cVerbo := cOper
	endif

return lRet


Static Function SolReserva(oJson,cVerbo,cDemanda,cMens)

	Local lRet := .t.
	Local cOScmms := oJson['OScmms']

	if cVerbo == "I" //inclusão
		lRet := fazIncl(oJson,@cDemanda,@cMens)
	else

		szm->(dbSetOrder(2))
		if szm->(dbSeek(xFilial()+cOScmms))

			cDemanda := szm->zm_demanda
			If cVerbo == "A" //alteração
				lRet := fazAlte(cDemanda,oJson,@cMens)
			elseif cVerbo == "E" //exclusão
				lRet := fazExcl(cDemanda,@cMens)
			endif

		else
			lRet := .f.
			cMens += 'A demanda referente a OS '+cOScmms+' não foi encontrada. '
		endif

	endif

Return lRet


static function fazIncl(oJson,cDemanda,cMens)

	Local aAreas := {sc0->(GetArea()), GetArea()}

	Local lRet := .t.

	Local cOScmms := oJson['OScmms']
	Local cEmis   := oJson['emissao']
	Local dEmis   := stod( replace(substr(cEmis,1,at(' ',cEmis)-1),"-","") )
	Local cHora   := substr(cEmis,at(' ',cEmis)+1,8)
	Local cNecess := oJson['necessidade']
	Local dNecess := stod( replace(cNecess,"-","") )
	Local cDestino:= oJson['destino']
	Local aItens  := oJson['itens']

	Local aOperacao := {}
	//aOperacao:
	//1 - Operacao : 1 Inclui,2 Altera,3 Exclui
	//2 - Tipo da Reserva - LB = Liberação, VD = Vendedor, CL = Cliente, PD = Pedido, NF = Nota fiscal, LJ = Sigaloja
	//3 - Documento que originou a Reserva
	//4 - Solicitante
	//5 - Filial da Reserva
	Local aIt       := {}

	Private aHeader := {}
	Private aCols	:= {}

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
	szm->zm_situa	:= '0'
	szm->(MsUnLock())

	//Montagem do HEADER E ACOLS para campos customizados ou padrão
	//If FieldPos("C0_FILRES") > 0
	//	aAdd(aHeader,{ 	GetSx3Cache("C0_FILRES", 'X3_TITULO'),;
		//					GetSx3Cache("C0_FILRES", 'X3_CAMPO' ),;
		//					GetSx3Cache("C0_FILRES", 'X3_PICTURE'),;
		//					GetSx3Cache("C0_FILRES", 'X3_TAMANHO'),;
		//					GetSx3Cache("C0_FILRES", 'X3_DECIMAL'),;
		//					GetSx3Cache("C0_FILRES", 'X3_VALID' ),;
		//					GetSx3Cache("C0_FILRES", 'X3_USADO' ),;
		//					GetSx3Cache("C0_FILRES", 'X3_TIPO' ),;
		//					GetSx3Cache("C0_FILRES", 'X3_F3' ),;
		//					GetSx3Cache("C0_FILRES", 'X3_CONTEXT'),;
		//					GetSx3Cache("C0_FILRES", 'X3_CBOX' ),;
		//					GetSx3Cache("C0_FILRES", 'X3_RELACAO') })
	//	aadd(aCols,"1330001")
	//endif
	aOperacao := {1,"PD",cDemanda,"CMMS",xFilial("SC0")}
	aIt := fazIt(aItens)
	lRet := fazInclIt(aOperacao,cDemanda,aIt,aHeader,aCols,@cMens)
	if lRet
		cMens += 'A inclusão do controle de demandas '+cDemanda+' foi realizada. '
	endif

	aEval(aAreas, {|x| RestArea(x) })
return lRet


static function fazInclIt(aOperacao,cDemanda,aItens,aHeader,aCols,cMens)

	Local aAreas := {sbf->(GetArea()), GetArea()}

	Local lRet := .t.
	local lRes := .t.
	Local cQuery := ""
	Local nqtd := 0
	Local nSldAtu := 0
	Local nI := 0

	Local cMaterial:= ""
	Local cLocal   := ""
	Local cLocaliz := ""
	Local nQuant   := 0

	Local aLote		:= {"","","",""}	//C0_NUMLOTE,C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI

	local nX := 0
	local aRerv    := {}
	local cReserva := ""

	for nI := 1 to len(aItens)
		cMaterial := aItens[nI,1]
		cLocal := aItens[nI,2]
		cLocaliz := aItens[nI,3]
		nQuant := aItens[nI,4]

		aLote[3] := cLocaliz

		cQuery := "select g1_filial,g1_cod,g1_comp,g1_quant from "+RetSQLName("SG1")+" g1 "
		cQuery += "where g1_filial = '"+xFilial("SG1")+"' and g1_cod = '"+cMaterial+"' and g1.d_e_l_e_t_ = ' ' "
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),"trb",.f.,.t.)
		if !trb->( eof() )
			while !trb->( eof() )
				nqtd := nQuant * trb->g1_quant

				if szn->(RecLock("szn",.t.))
					szn->zn_filial := szn->(xfilial())
					szn->zn_demanda:= cDemanda
					szn->zn_materia:= trb->g1_comp
					szn->zn_local  := cLocal
					szn->zn_localiz:= cLocaliz
					szn->zn_qorig  := nqtd
					szn->zn_quant  := nqtd
					szn->zn_matpai := cMaterial
					szn->zn_qorpai := nQuant
					szn->zn_quapai := nQuant
					szn->(MsUnLock())

					nSldAtu := u_verSaldo(trb->g1_comp,cLocal,cLocaliz)
					if nSldAtu > 0
						cMens := ""
						if nSldAtu < nqtd
							nqtd := nSldAtu
						endif
						if nqtd > 0
							nX := aScan(aRerv, {|x| x[1]==trb->g1_comp})
							if len(aRerv) == 0 .or. nX != 0
								aRerv := {}
								cReserva := u_renp050()
							endif
							aadd(aRerv, {cMaterial} )
							lRes := a430Reserv(aOperacao,cReserva,trb->g1_comp,cLocal,nqtd,aLote,aHeader,aCols)
							if lRes
								szn->(RecLock("szn",.f.))
								szn->zn_codres := cReserva
								szn->(MsUnLock())
							else
								cMens += 'Problemas na inclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+'. '
							endif
						else
							cMens += "O item "+alltrim(trb->g1_comp)+'/'+cLocal+'/'+alltrim(cLocaliz)+' não foi reservado porque esta sem saldo. '
						endif
					else
						cMens += "O item "+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+' não foi reservado porque esta sem saldo. '
					endif

				else
					lRet := .f.
					cMens += 'Problemas na inclusão do item '+alltrim(trb->g1_comp)+'/'+cLocal+' no controle de demandas. '
				endif

				trb->( DbSkip() )
			end
		else

			if szn->(RecLock("szn",.t.))
				szn->zn_filial := szn->(xfilial())
				szn->zn_demanda:= cDemanda
				szn->zn_materia:= cMaterial
				szn->zn_local  := cLocal
				szn->zn_localiz:= cLocaliz
				szn->zn_qorig  := nQuant
				szn->zn_quant  := nQuant
				szn->zn_matpai := cMaterial
				szn->zn_qorpai := nQuant
				szn->zn_quapai := nQuant
				szn->(MsUnLock())

				nSldAtu := u_verSaldo(cMaterial,cLocal,cLocaliz)
				if nSldAtu > 0
					if nSldAtu < nQuant
						nQuant := nSldAtu
					endif
					if nQuant > 0
						nX := aScan(aRerv, {|x| x[1]==cMaterial})
						if len(aRerv) == 0 .or. nX != 0
							aRerv := {}
							cReserva := u_renp050()
						endif
						aadd(aRerv, {cMaterial} )
						lRes := a430Reserv(aOperacao,cReserva,cMaterial,cLocal,nQuant,aLote,aHeader,aCols)
						if lRes
							szn->(RecLock("szn",.f.))
							szn->zn_codres := cReserva
							szn->(MsUnLock())
						else
							cMens += 'Problemas na inclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+'. '
						endif
					else
						cMens += "O item "+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+' não foi reservado porque esta sem saldo. '
					endif
				else
					cMens += "O item "+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+' não foi reservado porque esta sem saldo. '
				endif
			else
				lRet := .f.
				cMens += 'Problemas na inclusão do item '+alltrim(cMaterial)+'/'+cLocal+' no controle de demandas. '
			endif
		endif

		trb->( DbCloseArea() )
	next

	aEval(aAreas, {|x| RestArea(x) })

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
		aadd(aIt, {cMaterial, cLocal, cLocaliz, aItens[nI]["qtd"]} )
	next

Return aIt


static function fazAlte(cDemanda,oJson,cMens)

	Local aAreas := {sbf->(GetArea()), sg1->(GetArea()), szn->(GetArea()),sc0->(GetArea()), GetArea()}

	Local lRet := .t.
	Local lRes := .t.
	Local nI 	:= 0

	//Local cOScmms := oJson['OScmms']
	Local cNecess := oJson['necessidade']
	Local dNecess := stod( replace(cNecess,"-","") )
	Local cDestino:= oJson['destino']
	Local aItens  := oJson['itens']

	Local aIt       := {}
	Local aNovos    := {}
	Local aAlter    := {}

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
	Local aLote		:= {"","","",""}	//C0_NUMLOTE,C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI

	local nX 		:= 0
	local aRerv		:= {}
	local cReserva  := ""

	Private aHeader := {}
	Private aCols	:= {}

	sc0->(DbSetOrder(1))
	sg1->(DbSetOrder(1))
	szn->(dbSetOrder(2))

	aIt := fazIt(aItens)

	for nI := 1 to len(aIt)

		cMaterial := aIt[nI,1]
		cLocal := aIt[nI,2]
		cLocaliz := aIt[nI,3]
		nQuant := aIt[nI,4]

		aLote[3] := cLocaliz

		if szn->(dbSeek(xFilial()+cDemanda+cMaterial+cLocal+cLocaliz))
			while !szn->(eof()) .and. szn->zn_filial == szm->zm_filial .and. ;
					szn->zn_demanda == cDemanda .and. szn->zn_matpai == cMaterial .and. ;
					szn->zn_local == cLocal .and. szn->zn_localiz == cLocaliz

				if szn->zn_matpai != szn->zn_materia .and. sg1->(dbSeek(xFilial()+szn->zn_matpai+szn->zn_materia))
					nqtd := nQuant * sg1->g1_quant
				else
					nqtd := nQuant
				endif

				nSldAtu := u_verSaldo(szn->zn_materia,cLocal,cLocaliz)

				lAchou := .f.
				if sc0->(DbSeek(xFilial()+szn->zn_codres+szn->zn_materia+szn->zn_local))
					while !sc0->(eof()) .and. sc0->c0_filial == szn->zn_filial .and. ;
							sc0->c0_num == szn->zn_codres  .and. sc0->c0_produto == szn->zn_materia .and. ;
							sc0->c0_local == szn->zn_local

						if sc0->c0_localiz == szn->zn_localiz
							lAchou := .t.
							if nqtd > sc0->c0_quant
								if nSldAtu < (nqtd-sc0->c0_quant)
									nqtd := sc0->c0_quant+nSldAtu
								endif
							endif
							if sc0->c0_quant != nqtd
								aOperacao := {2,sc0->c0_tipo,sc0->c0_docres,sc0->c0_solicit,sc0->c0_filial}
								lRes := a430Reserv(aOperacao,szn->zn_codres,szn->zn_materia,cLocal,nqtd,aLote,aHeader,aCols)
								if !lRes
									cMens += 'Problemas na alteração da reserva do item '+alltrim(szn->zn_materia)+'/'+cLocal+'/'+alltrim(cLocaliz)+'. '
								endif
							endif
						endif

						sc0->(dbskip())
					end
				endif
				if !lAchou
					if nSldAtu < nqtd
						nqtd := nSldAtu
					endif
					if nqtd > 0
						aOperacao := {1,"PD",cDemanda,"CMMS",xFilial("SC0")}
						nX := aScan(aRerv, {|x| x[1]==cMaterial})
						if len(aRerv) == 0 .or. nX != 0
							aRerv := {}
							cReserva := u_renp050()
						endif
						aadd(aRerv, {cMaterial} )
						lRes := a430Reserv(aOperacao,cReserva,szn->zn_materia,cLocal,nqtd,aLote,aHeader,aCols)
						if lRes
							szn->(RecLock("szn",.f.))
							szn->zn_codres := cReserva
							szn->(MsUnLock())
						else
							cMens += 'Problemas na inclusão da reserva do item '+alltrim(szn->zn_materia)+'/'+cLocal+'/'+alltrim(cLocaliz)+'. '
						endif
					else
						cMens += "O item - "+alltrim(szn->zn_materia)+'/'+cLocal+'/'+alltrim(cLocaliz)+' não foi reservado porque esta sem saldo. '
					endif
				endif

				szn->(RecLock("szn",.f.))
				szn->zn_quant  := nqtd
				szn->zn_quapai := nQuant
				szn->(MsUnLock())

				szn->(dbskip())
			end
			aadd(aAlter,{cMaterial,cLocal,cLocaliz,nQuant})
		else
			aadd(aNovos,{cMaterial,cLocal,cLocaliz,nQuant})
		endif
	next

	szn->(dbSetOrder(1))
	szn->(dbSeek(xFilial()+cDemanda))
	while !szn->(eof()) .and. szn->zn_filial == szm->zm_filial .and. szn->zn_demanda == cDemanda

		nI := aScan(aAlter, {|x| x[1]==szn->zn_materia})
		if nI == 0
			if sc0->(DbSeek(xFilial()+szn->zn_codres+szn->zn_materia+szn->zn_local))

				while !sc0->(eof()) .and. sc0->c0_filial == szn->zn_filial .and. ;
						sc0->c0_num == szn->zn_codres  .and. sc0->c0_produto == szn->zn_materia .and. ;
						sc0->c0_local == szn->zn_local

					if sc0->c0_localiz == szn->zn_localiz
						aOperacao:= {3,sc0->c0_tipo,sc0->c0_docres,sc0->c0_solicit,sc0->c0_filial}
						cReserva := sc0->c0_num
						cMaterial := sc0->c0_produto
						cLocal := sc0->c0_local
						cLocaliz := sc0->c0_localiz
						nQuant := sc0->c0_quant
						aLote[3] := cLocaliz
						lRes := a430Reserv(aOperacao,cReserva,cMaterial,cLocal,nQuant,aLote,aHeader,aCols)
						if lRes
							cMens += 'Exclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+', realizada com sucesso. '
						else
							cMens += 'Exclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+', não foi realizada. '
						endif
					endif

					sc0->(dbskip())
				end

			endif

			szn->(RecLock("szn",.f.))
			szn->(dbdelete())
			szn->(MsUnLock())

		endif

		szn->(dbskip())
	end

	if len(aNovos) > 0
		aOperacao := {1,"PD",cDemanda,"CMMS",xFilial("SC0")}
		lRet := fazInclIt(aOperacao,cDemanda,aNovos,aHeader,aCols,@cMens)
	endif

	szm->(RecLock("szm",.f.))
	if szm->zm_situa == '6'
		szm->zm_situa := '0'
	endif
	szm->zm_dtneces	:= dNecess
	szm->zm_destino	:= cDestino
	szm->(MsUnLock())

	if lRet
		cMens += 'A Alteração do controle de demandas '+cDemanda+' foi realizada. '
	endif

	aEval(aAreas, {|x| RestArea(x) })

return lRet


static function fazExcl(cDemanda,cMens)

	Local lRet := .t.
	Local lAchou := .t.

	Local aOperacao := {}
	//aOperacao:
	//1 - Operacao : 1 Inclui,2 Altera,3 Exclui
	//2 - Tipo da Reserva - LB = Liberação, VD = Vendedor, CL = Cliente, PD = Pedido, NF = Nota fiscal, LJ = Sigaloja
	//3 - Documento que originou a Reserva
	//4 - Solicitante
	//5 - Filial da Reserva
	local cReserva  := ''
	Local cMaterial := ''				//C0_PRODUTO
	Local cLocal	:= ''				//C0_LOCAL
	Local nQuant	:= 0				//C0_QUANT

	Local aLote		:= {"","","",""}	//C0_NUMLOTE,C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI

	Private aHeader := {}
	Private aCols	:= {}

	szn->(dbSetOrder(1))
	szn->(dbSeek(xFilial()+cDemanda))
	while !szn->(eof()) .and. szn->zn_filial == szm->zm_filial .and. szn->zn_demanda == cDemanda

		lRet := .t.
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
					lRet := a430Reserv(aOperacao,cReserva,cMaterial,cLocal,nQuant,aLote,aHeader,aCols)
					if lRet
						cMens += 'Exclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+', realizada com sucesso. '
					else
						cMens += 'Exclusão da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+', não foi realizada. '
					endif
				endif

				sc0->(dbskip())
			end

		endif

		if !lAchou
			cMens += 'Exclusão da reserva do item '+alltrim(szn->zn_materia)+'/'+szn->zn_local+'/'+alltrim(szn->zn_localiz)+', não foi realizada pois não havia sido feita antes. '
		endif

		if lRet
			szn->(RecLock("szn",.f.))
			szn->(dbdelete())
			szn->(MsUnLock())
		endif

		szn->(dbskip())
	end

	if lRet
		szm->(RecLock("szm",.f.))
		//szm->(dbdelete())
		szm->zm_situa := '6'
		szm->(MsUnLock())
		cMens += "O controle de Demanda foi excluído com sucesso. "
	endif

return lRet


Static Function retEstrut(cPrdPai,nQtdPai)

	Local aRet := {}
	Local aEst := {}
	Local nI := 0
	Local cQuery := ""
	Local cAlias := GetNextAlias()

	cQuery := "select g1_filial,g1_cod,g1_comp,g1_quant from "+RetSQLName("SG1")+" g1 "
	cQuery += "where g1_filial = '"+xFilial("SG1")+"' and g1_cod = '"+cPrdPai+"' and g1.d_e_l_e_t_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.f.,.t.)
	while (cAlias)->( !eof() )
		aEst := retEstrut((cAlias)->g1_comp,nQtdPai*(cAlias)->g1_quant)
		if len(aEst) > 0
			for nI := 1 to len(aEst)
				aadd( aRet, {aEst[nI,1],aEst[nI,2],aEst[nI,3],aEst[nI,4]} )
			next
		else
			aadd( aRet, {(cAlias)->g1_comp,nQtdPai*(cAlias)->g1_quant,cPrdPai,nQtdPai} )
		endif

		(cAlias)->(dbskip())
	end

	(cAlias)->( DbCloseArea() )

Return aRet


Static Function critSaldo(cMaterial,cLocal,cLocaliz,nQuant,lCrit,nSldDisp,cError)

	local lRet := .t.

	nSldDisp := u_verSaldo(cMaterial,cLocal,cLocaliz)

	if lCrit .and. nQuant > nSldDisp
		cError += "O produto "+cMaterial+'/'+cLocal+'/'+alltrim(cLocaliz)+" não possui estoque para atender o consumo."
		lRet := .f.
	endif

Return lRet


User Function verSaldo(cMaterial,cLocal,cLocaliz)

	local nSldDisp := 0

	sb2->(DbSetOrder(1))
	sbf->(dbSetOrder(1))

	if empty(cLocaliz)
		if sb2->(dbseek(xfilial()+cMaterial+cLocal))
			nSldDisp := SaldoSB2()
		endif
	else
		if sbf->(dbSeek(xFilial()+cLocal+cLocaliz+cMaterial)) .and.;
				sb2->(dbseek(xfilial()+cMaterial+cLocal))
			nSldDisp := sbf->bf_quant-sbf->bf_empenho
		endif
	endif

Return nSldDisp
