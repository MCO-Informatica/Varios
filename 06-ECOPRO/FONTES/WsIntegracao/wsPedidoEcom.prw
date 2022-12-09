#include 'protheus.ch'
#include 'Restful.ch'
#include 'tbiconn.ch'

WsRestful wsPedidoEcom Description 'Integração de pedidos e-Commerce' FORMAT "application/json"

	WsMethod POST Description 'Inclusão de pedido e-Commerce' WsSyntax ""

End WsRestful

WsMethod POST WsService wsPedidoEcom
	Local cJson := ::getContent()
	Local oPedE := JsonObject():New()
	Local oResp := JsonObject():New()

	Local cGru := ""
	Local cFil := ""

	Local cMens  := ""
	Local nRetApi := 0

	//::SetContentType("application/json; charset=utf-8")

	if u_critJson(cJson,@cMens)
		oPedE:fromJson(cJson)
		cGru := oPedE['grupo']
		cFil := oPedE['filial']
		if empty(cGru) .or. empty(cFil)
			cGru := "01"
			cFil := "0101"
		endif
		if u_abrirAmb(cGru,cFil,"FAT")
			if u_critPedido(oPedE,@cMens,.t.)
				if incPedEcom(oPedE,@cMens)
					nRetApi := 201
				else
					nRetApi := 500
				endIf
			else
				nRetApi := 400
			endif
			RpcClearEnv()
		else
			nRetApi := 500
			cMens := "Não Abriu Ambiente Protheus"
		endif
	else
		nRetApi := 400
	endif

	if nRetApi >= 200 .and. nRetApi <= 299
		oResp['Status'] := nRetApi
		oResp['Message']:= EncodeUTF8( cMens, "cp1252")
		::SetResponse(oResp:toJson())
	else
		SetRestFault( nRetApi, EncodeUTF8( cMens, "cp1252") )
	endif

	// Descarta o objeto json
	FreeObj(oPedE)
	FreeObj(oResp)

Return

Static Function incPedEcom(oPedE,cMens)
	Local lRet := .t.
	Local nI 	:= 0
	Local nP 	:= 0

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}

	Local nIdPed	:= oPedE['id']
	Local cCgc		:= oPedE['cpf']
	Local cCondPg   := oPedE['condPgto']
	Local cStatPg   := oPedE['statPG']
	Local nParc		:= oPedE['parcelas']
	Local cCartao	:= oPedE['cartao']
	Local cTid		:= oPedE['tid']
	Local cAutoriz  := oPedE['authorizationCode']
	Local cIdPagto  := oPedE['paymentId']
	Local dDtPgto   := StoD(replace(oPedE['paymentDt'],"-",""))
	Local cNaturez  := "0101"
	Local cVend  	:= ""	//"V00005" //Ecopro

	Local aPedIt	:= oPedE['itens']
	Local cProd  	:= ""
	Local cArmaz 	:= "06"		//Armazém das Vendas e-Commerce. Criar parametro?
	Local nQtdVen	:= 0
	Local nPrcVen	:= 0
	Local nPrcUni	:= 0
	//Local nQtdLib	:= 0
	Local cTes   	:= ""

	Local aJson  	:= {}
	Local nOpcAuto 	:= 3
	Local cEvento := ""

	if cCgc != sa1->a1_cgc
		sa1->(DbSetOrder(3))
		sa1->(DbSeek(xFilial()+cCgc))
	endif

	aadd(aCabec, {"C5_NUM"    , ""			,Nil})
	aadd(aCabec, {"C5_TIPO"   , "N"			,Nil})
	aadd(aCabec, {"C5_CLIENTE", sa1->a1_cod	,Nil})
	aadd(aCabec, {"C5_LOJACLI", sa1->a1_loja,Nil})
	aadd(aCabec, {"C5_CLIENT ", sa1->a1_cod	,Nil})
	aadd(aCabec, {"C5_LOJAENT", sa1->a1_loja,Nil})
	aadd(aCabec, {"C5_TIPOCLI", sa1->a1_tipo,Nil})
	aadd(aCabec, {"C5_CONDPAG", cCondPg		,Nil})
	aadd(aCabec, {"C5_NATUREZ", cNaturez	,Nil})
	if !empty(cVend)
		aadd(aCabec, {"C5_VEND1"  , cVend		,Nil})
	endif
	aadd(aCabec, {"C5_VOLUME1", 1			,Nil})
	aadd(aCabec, {"C5_ESPECI1", "VOLUME"	,Nil})
	aadd(aCabec, {"C5_TPFRETE", "S"			,Nil})
	aadd(aCabec, {"C5_XIDAPI" , strzero(nIdPed,11),Nil})
	aadd(aCabec, {"C5_XNPARC" , strzero(nParc,2),Nil})
	aadd(aCabec, {"C5_XADM"   , cCartao		,Nil})
	aadd(aCabec, {"C5_XTID"   , cTid		,Nil})
	aadd(aCabec, {"C5_XAUTOR" , cAutoriz	,Nil})
	aadd(aCabec, {"C5_XPAYID" , cIdPagto	,Nil})
	aadd(aCabec, {"C5_XDTMOV" , dDtPgto    	,Nil})

	sb1->(dbSetOrder(1))
	for nI := 1 to len(aPedIt)
		aJson := ClassDataArr(aPedIt[nI])

		nP := Ascan(aJson,{|x| x[1]=="cod"})
		cProd := aJson[nP,2]
		cLocal := cArmaz
		nP := Ascan(aJson,{|x| x[1]=="qtd"})
		nQtdVen:= aJson[nP,2]
		nP := Ascan(aJson,{|x| x[1]=="valor"})
		nPrcVen:= aJson[nP,2]
		nPrcUni:= nPrcVen
		nQtdLib:= nQtdVen

		sb1->(dbseek(xfilial()+cProd))
		cTes   := sb1->b1_ts

		aLinha := {}
		aadd(aLinha,{"C6_ITEM"   ,strzero(nI,2) ,Nil})
		aadd(aLinha,{"C6_PRODUTO",cProd			,Nil})
		aadd(aLinha,{"C6_LOCAL"	 ,cLocal		,Nil})
		aadd(aLinha,{"C6_QTDVEN" ,nQtdVen		,Nil})
		aadd(aLinha,{"C6_PRCVEN" ,nPrcVen		,Nil})
		aadd(aLinha,{"C6_VALOR"  ,nQtdVen*nPrcVen,Nil})
		aadd(aLinha,{"C6_TES"    ,cTes			,Nil})
		aadd(aLinha,{"C6_PRUNIT" ,nPrcUni		,Nil})
		if cStatPg == "1"
			aadd(aLinha,{"C6_QTDLIB" ,nQtdLib	,Nil})
		endif
		aadd(aItens, aLinha)
	next

	if nOpcAuto == 3
		cEvento := "Inclusão"
	endif

	if u_cadPedido(aCabec,aItens,nOpcAuto,@cMens)
		cMens := "Sucesso na "+cEvento+" do Pedido: "+cMens+" !"
	else
		lRet := .f.
		cMens := "Erro na "+cEvento+" do pedido APi: "+cIdPed+". "+cMens
	endif

Return lRet
