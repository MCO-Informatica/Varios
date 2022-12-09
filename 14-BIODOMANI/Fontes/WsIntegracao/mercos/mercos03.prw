#include "protheus.ch"
#include "FwMvcDef.ch"
/* Executar sincronismo Mercos -> Protheus */
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
User function mercos03(cCodApi)

	//Local lJob 	  := ( Select( "SX6" ) == 0 )
	Local cJobEmp := '01'
	Local cJobFil := '0103'
	Local cJobMod := 'FAT'
	Local nI      := 0
	Local nO      := 0
	Local nP      := 0

	Local cLocal
	Local aLocal := {}
	Local oJson
	Local oObj
	Local cError := ""
	Local cMens := ""

	Local cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
	Local cCodRet := ""
	Local cLojRet := ""
	Local cNumPed := ""

	Local lInc := .t.

	Default cCodApi := " "

	aLocal := u_mercos98()

	for nI := 1 to len(aLocal)

		cJobFil := aLocal[nI,1]
		cLocal := aLocal[nI,2]

		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

		/* Receber Clientes = Mercos -> Protheus */
		if empty(cCodApi) .or. cCodApi == "C"
			cObj := 'C'
			cUlt := ultTran(cObj,"I","P")
			cError := ""
			oObj:=cliMercos():new()
			oJson:=u_mercos02(cObj,"C",oObj,"","",cUlt,@cError)
			if empty(cError)
				for nO := 1 to len(oJson)
					aAtrib := oJson[1]:GetNames()
					for nP := 1 to len(aAtrib)
						cOri := 'oJson['+str(nO)+']["'+lower(aAtrib[nP])+'"]'
						cDes := 'oObj:'+lower(aAtrib[nP])
						&cDes := &cOri
					next nP
					//função que inclui Cliente no protheus
					lInc := .t.
					cCodRet := ""
					cLojRet := ""
					cMens := ""
					cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
					lOk := cadCli(oObj,@lInc,@cMens,@cCodRet,@cLojRet)
					if lOk .and. lInc
						szb->(RecLock("SZB", .t.))
						szb->zb_filori := cFilAnt
						szb->zb_tipreg := cObj
						szb->zb_codigo := cCodRet+cLojRet
						szb->zb_idreg  := alltrim(str(oObj:id))
						szb->zb_ativo  := "1"
						szb->(MsUnlock())
					endif
					szc->(RecLock("SZC", .t.))
					szc->zc_filori := cFilAnt
					szc->zc_tipreg := cObj
					szc->zc_codigo := cCodRet+cLojRet
					szc->zc_oper   := iif('Inclus'$cMens,"I","A")
					szc->zc_local  := 'P'
					szc->zc_dtoper := cDtoper
					szc->zc_status := iif(lOk,'R','F')
					szc->zc_mensag := cMens
					szc->(MsUnlock())
				next nO
			endif
		endif

		/* Receber Pedidos = Mercos -> Protheus */
		if empty(cCodApi) .or. cCodApi == "O"
			cObj := 'O'
			cUlt := ultTran(cObj,"I","P")
			cError := ""
			oObj:=pedMercos():new()
			oJson:=u_mercos02(cObj,"C",oObj,"","",cUlt,@cError)
			if empty(cError)
				for nO := 1 to len(oJson)
					aAtrib := oJson[1]:GetNames()
					for nP := 1 to len(aAtrib)
						cOri := 'oJson['+str(nO)+']["'+lower(aAtrib[nP])+'"]'
						cDes := 'oObj:'+lower(aAtrib[nP])
						&cDes := &cOri
					next nP
					//função que inclui pedidos
					cNumPed := ""
					cMens := ""
					cDtoper := transform(dtos(date()),"@R 9999-99-99")+" "+time()
					lOk := incPed(oObj,@cMens,@cNumPed)
					if lOk
						szb->(RecLock("SZB", .t.))
						szb->zb_filori := cFilAnt
						szb->zb_tipreg := cObj
						szb->zb_codigo := cNumPed
						szb->zb_idreg  := alltrim(str(oObj:id))
						szb->zb_ativo  := "1"
						szb->(MsUnlock())
					endif
					szc->(RecLock("SZC", .t.))
					szc->zc_filori := cFilAnt
					szc->zc_tipreg := cObj
					szc->zc_codigo := cNumPed
					szc->zc_oper   := iif('Inclus'$cMens,"I","A")
					szc->zc_local  := 'P'
					szc->zc_dtoper := cDtoper
					szc->zc_status := iif(lOk,'R','F')
					szc->zc_mensag := cMens
					szc->(MsUnlock())

				next nO
			endif
		endif

		RpcClearEnv()

	Next

Return


Static Function cadCli(oCli,lInc,cMens,cCodRet,cLojRet)
	Local lRet    := .t.
	Local nOpcAuto:= 0
	Local cEvento := ""
	Local ni := 0

	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description} )

	Local aTel    := oCli['telefones']
	Local aEmail  := oCli['emails']
	Local aContato:= oCli['contatos']

	Local lCliExcl:= oCli['excluido']

	Local aJson   := {}

	Private oModel
	Private oField

	Private cCodCli := ""
	Private cLojCli := ""
	Private cNome   := oCli['razao_social']
	Private cNReduz := oCli['nome_fantasia']
	Private cPessoa := oCli['tipo']
	Private cCpf    := oCli['cnpj']
	Private IE      := oCli['inscricao_estadual']
	Private cTipoCli:= "F"  //Consumidor final
	Private cEnd    := oCli['rua']
	Private cNum    := oCli['numero']
	Private cCompl  := oCli['complemento']
	Private cCep    := oCli['cep']
	Private cBairro := oCli['bairro']
	Private cMun    := oCli['cidade']
	Private cCodMun := ""
	Private cEst    := oCli['estado']
	Private cDdd    := "0"
	Private cTel1   := iif(len(aTel)>0,"","0")
	Private cTel2   := iif(len(aTel)>0,"","0")
	Private cEmail  := "."
	Private cContato:= "MERCOS"
	//Private cRisco  := "A"
	Private cNaturez:= "101010"
	Private cVend   := ""
	Private cSeg    := buscaSeg(alltrim(str(oCli['segmento_id'])),@cMens)

	//Private lMsErroAuto := .f.

	if !empty(cMens)
		Return .f.
	endif

	Begin Sequence

		cNome   := FwCutOff(DecodeUTF8(cNome, "cp1252"), .t.)
		cNome   := upper(cNome)
		cNReduz := iif(empty(cNReduz),substr(cNome,1,20),FwCutOff(DecodeUTF8(cNReduz, "cp1252"),.t.) )
		cNReduz := upper(cNReduz)
		cEnd    := FwCutOff(cEnd, .t.)
		cEnd    := upper(cEnd)
		cCompl  := iif(empty(cCompl),"",FwCutOff(cCompl, .t.))
		cCompl  := upper(cCompl)
		cBairro := FwCutOff(cBairro, .t.)
		cBairro := upper(cBairro)
		cMun    := FwCutOff(cMun, .t.)
		cMun    := upper(cMun)

		cEnd := alltrim(cEnd)
		if !empty(cNum)
			cEnd += ", "+alltrim(cNum)
		endif
		if !empty(cCompl)
			cEnd += " "+alltrim(cCompl)
		endif

		cc2->( dbSetOrder(2) )
		cc2->( dbseek(xfilial()+upper(alltrim(cMun)) ) )
		cCodMun := FwCutOff(cc2->cc2_codmun, .t.)
		cc2->( dbSetOrder(1) )

		for nI := 1 to len(aTel)
			aJson := ClassDataArr(aTel[nI])
			nP := Ascan(aJson,{|x| x[1]=="numero"})
			if ni == 2
				cTel2 += aJson[nP,2]
			else
				if nI > 1
					cTel1 += ";"
				endif
				cTel1 += aJson[nP,2]
			endif
		next
		nP := at("(",cTel1)
		if nP > 0
			cDdd := substr(cTel1,nP+1,2)
		endif
		if len(aEmail) > 0
			aJson := ClassDataArr(aEmail[1])
			nP := Ascan(aJson,{|x| x[1]=="email"})
			cEmail := aJson[nP,2]
		endif
		if len(aContato) > 0
			aJson := ClassDataArr(aContato[1])
			nP := Ascan(aJson,{|x| x[1]=="nome"})
			cContato := aJson[nP,2]
		endif

		oModel := FwLoadModel("CRMA980")
		oField := oModel:GetModel("SA1MASTER")

		sa1->(dbSetOrder(3))
		if sa1->(MsSeek(xFilial()+cCpf))
			cCodCli  := sa1->a1_cod
			cLojCli  := sa1->a1_loja
			if lCliExcl
				nOpcAuto := 5
				cEvento  := "Exclusão"
				oModel:SetOperation(MODEL_OPERATION_DELETE)
			else
				nOpcAuto := 4
				cEvento  := "Alteração"
				oModel:SetOperation(MODEL_OPERATION_UPDATE)
			endif
			lInc := .f.
		else
			nOpcAuto := 3
			cEvento := "Inclusão"
			cCodCli := GetSxeNum("SA1","A1_COD")
			cLojCli := "01"
			oModel:SetOperation(MODEL_OPERATION_INSERT)
		endif

		oModel:Activate()
		if nOpcAuto == 3
			oModel:SetValue("SA1MASTER","A1_COD"    , cCodCli)
			oModel:SetValue("SA1MASTER","A1_LOJA"   , cLojCli)
		endif
		oModel:SetValue("SA1MASTER","A1_CGC"    , cCpf)
		sya->( dbSetOrder(1) )
		oModel:SetValue("SA1MASTER","A1_NOME"   , cNome)
		oModel:SetValue("SA1MASTER","A1_PESSOA" , cPessoa)
		oModel:SetValue("SA1MASTER","A1_NREDUZ" , cNReduz )
		oModel:SetValue("SA1MASTER","A1_TIPO"   , cTipoCli)
		oModel:SetValue("SA1MASTER","A1_DDI"    , "55")
		oModel:SetValue("SA1MASTER","A1_DDD"    , cDdd )
		oModel:SetValue("SA1MASTER","A1_TEL"    , cTel1 )
		oModel:SetValue("SA1MASTER","A1_TEL2"   , cTel2 )
		oModel:SetValue("SA1MASTER","A1_CONTATO", cContato )
		oModel:SetValue("SA1MASTER","A1_EMAIL"  , cEmail )
		/*oModel:SetValue("SA1MASTER","A1_RISCO"  , cRisco)*/	
		oModel:SetValue("SA1MASTER","A1_SATIV1" , cSeg)
		if nOpcAuto == 3
			if cPessoa == "F"
				oModel:SetValue("SA1MASTER","A1_CONTRIB", "2")
				oModel:SetValue("SA1MASTER","A1_IENCONT", "2")
			else
				if empty(IE) .or. Alltrim(IE) $ "ISENTO|ISENTA"
					oModel:SetValue("SA1MASTER","A1_CONTRIB", "2")
					oModel:SetValue("SA1MASTER","A1_IENCONT", "2")
				else
					oModel:SetValue("SA1MASTER","A1_CONTRIB", "1")
					oModel:SetValue("SA1MASTER","A1_IENCONT", "1")
				endif
			endif
			oModel:SetValue("SA1MASTER","A1_NATUREZ", cNaturez)
			if substr(cVend,1,1) == 'C'
				oModel:SetValue("SA1MASTER","A1_VEND"	, cVend)
				oModel:SetValue("SA1MASTER","A1_VEND1"	, 'Z00011')
			elseif substr(cVend,1,1) == 'S'
				oModel:SetValue("SA1MASTER","A1_VEND"	, 'Z00004')
				oModel:SetValue("SA1MASTER","A1_VEND1"	, cVend)
			else
				oModel:SetValue("SA1MASTER","A1_VEND"	, 'Z00004')
				oModel:SetValue("SA1MASTER","A1_VEND1"	, 'Z00011')
			endif
		endif
		oModel:SetValue("SA1MASTER","A1_CEP"    , cCep)
		oModel:SetValue("SA1MASTER","A1_END"    , DecodeUTF8(cEnd   , "cp1252"))
		if empty(m->a1_bairro)
			oModel:SetValue("SA1MASTER","A1_BAIRRO" , DecodeUTF8(cBairro, "cp1252"))
		endif
		if empty(m->a1_est)
			oModel:SetValue("SA1MASTER","A1_EST"    , cEst)
		endif
		if empty(m->a1_mun)
			oModel:SetValue("SA1MASTER","A1_MUN"    , DecodeUTF8(cMun   , "cp1252"))
		endif
		/*
		oModel:SetValue("SA1MASTER","A1_ENDCOB" , DecodeUTF8(cEnd   , "cp1252"))
		oModel:SetValue("SA1MASTER","A1_BAIRROC", DecodeUTF8(cBairro, "cp1252"))
		oModel:SetValue("SA1MASTER","A1_CEPC"   , cCep)
		oModel:SetValue("SA1MASTER","A1_MUNC"   , DecodeUTF8(cMun   , "cp1252"))
		oModel:SetValue("SA1MASTER","A1_ESTC"   , cEst)
		oModel:SetValue("SA1MASTER","A1_ENDENT" , DecodeUTF8(cEnd   , "cp1252"))
		oModel:SetValue("SA1MASTER","A1_BAIRROE", DecodeUTF8(cBairro, "cp1252"))
		oModel:SetValue("SA1MASTER","A1_CEPE"   , cCep)
		oModel:SetValue("SA1MASTER","A1_MUNE"   , DecodeUTF8(cMun   , "cp1252"))
		oModel:SetValue("SA1MASTER","A1_ESTE"   , cEst)
		*/
		//oModel:SetValue("SA1MASTER","A1_CODPAIS", "01058")
		oModel:SetValue("SA1MASTER","A1_COD_MUN", cCodMun)
		oModel:SetValue("SA1MASTER","A1_PAIS"   , "105")
		oModel:SetValue("SA1MASTER","A1_INSCR"  , iif(empty(IE),"ISENTO",Alltrim(IE)) )

		If oModel:VldData()
			oModel:CommitData()
			if empty(cError)
				cMens := "Sucesso na "+cEvento+" do Cliente CPF/CNPJ: "+cCpf+" !"
			else
				lRet := .f.
				cMens := "Sem "+cEvento+" do Cliente CPF/CNPJ: "+cCpf+". "
			endif
		Else
			lRet := .f.
			cMens := "Falha na "+cEvento+" do Cliente CPF/CNPJ: "+cCpf+". Detalhes: "+oModel:GetErrorMessage()[6]
		EndIf

		oModel:DeActivate()
		oModel:Destroy()
		oModel:=nil

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError) .or. !lRet	//Se houve erro, será mostrado ao usuário
		cMens += iif(empty(cError),""," => "+substr( FwCutOff(cError, .t.) ,1,150))
		lRet := .f.
	EndIf

	cCodRet := cCodCli
	cLojRet := cLojCli

Return lRet


Static Function incPed(oPed,cMens,cNumPed)
	Local lRet := .t.
	Local nI 	:= 0
	Local nP 	:= 0
	Local nOpcAuto := 0
	Local cEvento := ""

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}

	Local cNum	   := ""

	/*
	::id	:= nil
	::cliente_id := 0
	::cliente_razao_social := ""
	::cliente_nome_fantasia := ""
	::cliente_cnpj := ""
	::cliente_inscricao_estadual := ""
	::cliente_rua := ""
	::cliente_numero := ""
	::cliente_complemento := ""
	::cliente_cep := ""
	::cliente_bairro := ""
	::cliente_cidade := ""
	::cliente_estado := ""
	::cliente_suframa := ""
	::cliente_telefone := {}
	::cliente_email := {}
	::representada_id := 0
	::representada_nome_fantasia := ""
	::representada_razao_social := ""
	::transportadora_id := 0
	::transportadora_nome:= ""
	::criador_id := 0
	::nome_contato := ""
	::numero := 0						//Número auto-incremental do pedido.                                                                                                                                  |
	::rastreamento := ""				//Código ou link para rastreamento de envio do pedido.                                                                                                                |
	::valor_frete := 0
	::total := 0						//Valor total do pedido.                                                                                                                                              |
	::condicao_pagamento := ""
	::condicao_pagamento_id := 0
	::tipo_pedido_id  := 0
	::forma_pagamento_id := 0
	::endereco_entrega := ""
	::data_emissao := ""
	::observacoes := ""
	::contato_nome := ""
	::status_faturamento := 0			//Não faturado = 0, Parcialmente faturado = 1, Faturado = 2.                                                                                                          |
	::status_custom_id := 0
	::status_b2b := 0					//Status atual do pedido no B2b. null = Pedido não foi gerado com o B2B, 1 = Em aberto, 2 = Concluído.
	::data_criacao := ""
	::ultima_alteracao := nil
	::extras := {}

	itens
		data id
		data produto_id
		data produto_codigo
		data produto_nome
		data tabela_preco_id
		data quantidade
		data preco_bruto			//preço de tabela
		data preco_liquido			//preço dewscontado
		data cotacao_moeda
		data quantidade_grades
		data descontos_do_vendedor
		data descontos_de_promocoes
		data descontos_de_politicas
		data descontos
		data observacoes
		data excluido
		data ipi
		data tipo_ipi
		data st
		data subtotal
	*/

	Local cIdPed := alltrim(str(oPed['id']))
	Local cIdFor := alltrim(str(oPed['forma_pagamento_id']))
	Local cIdCon := alltrim(str(oPed['condicao_pagamento_id']))
	Local cIdTra := alltrim(str(oPed['transportadora_id']))
	Local cIdCri := alltrim(str(oPed['criador_id']))
	Local cStat  := oPed['status']		//Status atual do pedido. 0 = Cancelado, 1 = Orçamento, 2 = Pedido.
	Local cCnpj  := oPed['cliente_cnpj']
	Local cVend  := ""
	//Local cNoUser := ""
	Local cLinVen:= ""
	Local cTrans := ""
	Local cCond  := ""
	Local cForm  := ""
	Local cDf    := ""
	Local cArmaz := ""
	//Local nValFre := oPed['valor_frete']

	Local aPedIt := oPed['itens']
	Local aCExtr := oPed['extras']
	Local cKit   := ""
	Local cProd  := ""
	Local nQtdVen:= 0
	Local nPrcVen:= 0
	Local cTes   := ""
	Local nPrcUni:= 0
	//Local nQtdLib:= 0

	Local aJson  := {}

	local cErroAuto := "" //local aErroAuto := {}
	Local cLogErro := ""
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

	if cStat != '2'
		cMens := "O status da venda é: "+iif(cStat=='0',"Cancelado",iif(cStat=='1',"Orçamento",""))
		lRet := .f.
		Return lRet
	endif

	sa1->(dbSetOrder(3))
	szb->(DbSetOrder(2))
	sg1->(dbSetOrder(1))

	if !sa1->(MsSeek(xFilial()+cCnpj))
		cMens := "Cliente com CPF/CNPJ: "+cCnpj+", não encontrado !"
		lRet := .f.
		Return lRet
	endif

	if szb->(dbseek(xfilial()+cFilAnt+"U"+cIdCri ))
		cVend := alltrim(szb->zb_codigo)
	else
		cError := ""
		cVend := buscaVend(cIdCri,@cError)
	endif
	if !empty(cVend)
		sa1->(RecLock("SA1", .f.))
		if substr(cVend,1,1) == "C"
			sa1->a1_vend := cVend
			sa1->a1_vend1 := "Z00011"
		elseif substr(cVend,1,1) == "S"
			sa1->a1_vend := "Z00004"
			sa1->a1_vend1 := cVend
		endif
		sa1->(MsUnlock())

		if substr(cVend,1,1) == "C"
			cLinVen := "1"
		elseif substr(cVend,1,1) == "S"
			cLinVen := "2"
		else
			cLinVen := "5"
		endif
	endif

	if empty(cVend) .or. !sa3->(dbseek(xfilial()+cVend))
		cMens := "Usuário criador do pedido no Mercos, não encontrado !"
		lRet := .f.
		Return lRet
		//else
		//cNoUser := UsrRetName(sa3->a3_codusr)		//UsrRetMail(sa3->a3_codusr)
	endif

	if szb->(dbseek(xfilial()+cFilAnt+"F"+cIdFor ))
		cForm := alltrim(szb->zb_codigo)
	endif
	if cForm == "DV"
		cCond := "900"
	else
		if szb->(dbseek(xfilial()+cFilAnt+"D"+cIdCon ))
			cCond := alltrim(szb->zb_codigo)
		endif
	endif
	if szb->(dbseek(xfilial()+cFilAnt+"S"+cIdTra ))
		cTrans := alltrim(szb->zb_codigo)
	endif

	if szb->(dbseek(xfilial()+cFilAnt+"O"+cIdPed ))
		nOpcAuto := 4
		cEvento  := "Alteração"
		cNum := alltrim(szb->zb_codigo)
	else
		nOpcAuto := 3
		cEvento := "Inclusão"

		cNum := GetSXENum("SC5","C5_NUM")
		sc5->(dbSetOrder(1))
		sc5->(dbseek(xfilial()+cNum))
		while !sc5->(eof())
			cNum := GetSXENum("SC5","C5_NUM")
			sc5->(dbseek(xfilial()+cNum))
		end

	endif

	Begin Sequence

		for nI := 1 to len(aCExtr)
			aJson := ClassDataArr(aCExtr[nI])
			if aJson[8,2] == 'doc_fiscal'
				cDf := substr(aJson[nI,2,1,2],1,1)
			endif
			if aJson[8,2] == 'armazem'
				cArmaz := aJson[nI,2,1,2]
			endif
		next

		aadd(aCabec, {"C5_X_USERS"  , "MERCOS"		,Nil})  // USUÁRIO
		aadd(aCabec, {"C5_X_EMPFA"  , cFilAnt		,Nil})  // EMP FAT
		aadd(aCabec, {"C5_X_ARMAZ"  , cArmaz		,Nil})  // ARMAZEM
		aadd(aCabec, {"C5_DF"  		, cDf			,Nil})  // DOCTO FISCAL - SIM OU NÃO - VERIFICAR
		aadd(aCabec, {"C5_X_PROGR"  , "N"			,Nil})  // PROGRAMAÇÃO
		aadd(aCabec, {"C5_NUM"    	, cNum			,Nil})
		aadd(aCabec, {"C5_TIPO"   	, "N"			,Nil})	// TIPO PEDIDO SEMPRE N-NORMAL
		aadd(aCabec, {"C5_CLIENTE"	, sa1->a1_cod	,Nil})
		aadd(aCabec, {"C5_LOJAENT"	, sa1->a1_loja	,Nil})
		aadd(aCabec, {"C5_LOJACLI"	, sa1->a1_loja	,Nil})
		aadd(aCabec, {"C5_CLIENT "	, sa1->a1_cod	,Nil})
		aadd(aCabec, {"C5_VENDE"  	, cLinVen		,Nil})	// LINHA VENDA
		aadd(aCabec, {"C5_TRANSP" 	, cTrans		,Nil})
		aadd(aCabec, {"C5_X_VIASP"	, 1				,Nil})  // INICIALIZADOR PADRÃO 1
		aadd(aCabec, {"C5_X_IMPRE"  , "N"			,Nil})
		aadd(aCabec, {"C5_TIPOCLI"	, sa1->a1_tipo	,Nil})
		aadd(aCabec, {"C5_FORMAPG"  , cForm			,Nil})  //
		aadd(aCabec, {"C5_CONDPAG"  , cCond			,Nil})  //
		//aadd(aCabec, {"C5_TABELA"	, 				,Nil})  //
		aadd(aCabec, {"C5_XDIA"		, "Liberado Entrega",Nil})  // NÃO ENTREGAR EM ALGUM DIA DA SEMANA OU ENTREGA LIBERADA - ?
		aadd(aCabec, {"C5_OBS1"		, "PED. MERCOS" ,Nil})  // - ?
		if substr(cVend,1,1) == 'C'
			aadd(aCabec, {"C5_VEND1"	, cVend		,Nil})  // - ?
		elseif substr(cVend,1,1) == 'S'
			aadd(aCabec, {"C5_VEND2"	, cVend		,Nil})  // - ?
		endif
		aadd(aCabec, {"C5_TPFRETE"  , "C"			,Nil})  // - ?
		//aadd(aCabec, {"C5_X_AUTOR"  , 				,Nil})  // AUTORIZAÇÃO - OS DADOS DO CARTÃO NÃO VEM ?
		//aadd(aCabec, {"C5_X_DATCC"  , 				,Nil})  // DT AUTORIZAÇÃO
		//aadd(aCabec, {"C5_X_TERMI"  , 				,Nil})  // TERMINAL
		//aadd(aCabec, {"C5_NATUREZ", cNaturez		,Nil})

		for nI := 1 to len(aPedIt)
			aJson := ClassDataArr(aPedIt[nI])
			nP := Ascan(aJson,{|x| x[1]=="excluido"})
			if !aJson[nP,2]
				nP := Ascan(aJson,{|x| x[1]=="produto_codigo"})
				cProd := aJson[nP,2]
				if len(cProd) == 4 .and. sg1->(dbseek(xfilial()+substr(cProd,1,15)))
					cKit := "S"
				else
					cKit := "N"
				endif
				cLocal := cArmaz	//aLocal[1,2]
				nP := Ascan(aJson,{|x| x[1]=="quantidade"})
				nQtdVen:= aJson[nP,2]
				nP := Ascan(aJson,{|x| x[1]=="preco_liquido"})
				nPrcVen:= aJson[nP,2]
				cTes   := "501"	//Como seia a TES correta? Quando for bonificação verificar o parametro MV_BONUSTS?
				nPrcUni:= nPrcVen
				//nQtdLib:= 0

				aLinha := {}
				aadd(aLinha,{"C6_ITEM"   ,strzero(nI,2) ,Nil})
				aadd(aLinha,{"C6_X_KIT"  ,cKit			,Nil})
				aadd(aLinha,{"C6_PRODUTO",cProd			,Nil})
				aadd(aLinha,{"C6_LOCAL"	 ,cLocal		,Nil})
				aadd(aLinha,{"C6_QTDVEN" ,nQtdVen		,Nil})
				aadd(aLinha,{"C6_PRCVEN" ,nPrcVen		,Nil})
				aadd(aLinha,{"C6_VALOR"  ,nQtdVen*nPrcVen,Nil})
				aadd(aLinha,{"C6_TES"    ,cTes			,Nil})
				aadd(aLinha,{"C6_PRUNIT" ,nPrcUni		,Nil})
				//aadd(aLinha,{"C6_QTDLIB" ,nQtdLib		,Nil})
				aadd(aItens, aLinha)
			endif
		next
		if len(aItens) > 0
			MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcAuto, .f. )
			if lMsErroAuto
				//aErroAuto := GetAutoGRLog()
				//For nI := 1 to Len(aErroAuto)
				//	cLogErro += StrTran(StrTran(aErroAuto[nI], "<", ""), "-", "") + " "
				//Next
				cErroAuto := MostraErro()
				cLogErro := alltrim(FwCutOff(cErroAuto, .t.))
				lRet := .f.
				cMens := "Falha na "+cEvento+" do pedido: "+cNum+". Detalhes: "+iif(Empty(cLogErro),"Internal Error.",Substr(cLogErro,1,150) )
			Else
				cMens := "Sucesso na "+cEvento+" do Pedido: "+cNum+" !"
			EndIf
		else
			lRet := .f.
			cMens := "Falha na "+cEvento+" do pedido: "+cNum+". Detalhes: Todos os itens do pedido estão excluidos !"
		endif

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError) .or. !lRet	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens += iif(empty(cError),""," => "+substr( FwCutOff(cError, .t.) ,1,150))
	EndIf

	cNumPed := cNum

Return lRet

/************************/
/* Função de Uso comum */
/************************/
Static Function ultTran(cObj,cOper,cLocal)	/* Retorna da ultima transação Mercos -> Protheus de um determinado Objeto */

	Local cUlt := ""
	Local cSql := ""

	cSql := "SELECT MAX(ZC_DTOPER) ZC_DTOPER FROM "+RetSQLName("SZC")+" "
	cSql += "WHERE ZC_FILIAL = '"+szb->(xFilial())+"' AND ZC_FILORI = '"+cFilAnt+"' AND "
	cSql += "ZC_TIPREG = '"+cObj+"' AND ZC_OPER = '"+cOper+"' AND ZC_LOCAL = '"+cLocal+"' "
	cSql += "AND ZC_STATUS = 'R' AND D_E_L_E_T_ = ' ' "
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
	if empty(trb->zc_dtoper)
		cUlt := transform(dtos(date()),"@R 9999-99-99")+" "+"00:00:00"
	else
		cUlt := trb->zc_dtoper
	endif
	trb->(dbclosearea())
	cUlt := replace(cUlt,' ','%20')

Return cUlt


Static function buscaVend(cId,cError)
	Local cVend
	Local oObj
	Local oJson

	oObj:= usuMercos():new()
	oJson:= u_mercos02("U","C",oObj,"",cId,"",@cError)
	if empty(cError)
		cVend := substr(oJson["nome"],1,6)
		if empty(cVend) .or. !sa3->(dbseek(xfilial()+cVend))
			cError := "Usuário criador do pedido no Mercos, não encontrado !"
		endif
	endif

Return cVend


Static function buscaSeg(cId,cError)
	Local cSeg

	szb->(DbSetOrder(2))
	if szb->(dbseek(xfilial()+cFilAnt+"G"+cId))
		cSeg := alltrim(szb->zb_codigo)
	endif
	if empty(cSeg) .or. !sx5->(dbseek(xfilial()+"T3"+cSeg))
		cError := "Segmento do cliente no Mercos, não encontrado !"
	endif

Return cSeg
