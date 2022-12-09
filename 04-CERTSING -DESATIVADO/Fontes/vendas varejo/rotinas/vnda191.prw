#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} VNDA190
Rotina personalizada para gerar o faturamento automatico
@author Giovanni
@since 0301/2020 
@version P12
/*/
User Function VNDA191( cEmpP, cFilP, aParamFun, nRecPed )
	Local cPedido		:= nil
	Local nIdJob		:= nil
	Local lFat			:= nil
	Local cNsNum		:= nil
	Local lServ			:= nil
	Local lProd			:= nil
	Local nQtdFat		:= nil
	Local cOpVen		:= nil
	Local cOpEnt		:= nil
	Local cOpSer		:= nil
	Local cPedLog		:= nil
	Local dCredCnab		:= nil
	Local lRecPgto		:= nil
	Local lGerTitRecb	:= nil
	Local cTipTitRecb 	:= nil
	Local lEnt			:= nil
	Local bVldCtd		:= {|a,b,c| IIf( Len(a) >= b .and. a[b] <> nil .and. iif(Valtype(a[b]) == "L" , .T.  , !Empty(a[b]) )  , a[b] , c ) }
	Local cPedGarIt		:= ""
	Local cPedSite      := ""
	Local oVoucher      := nil

	Default aParamFun	:= Array(18)
	Default cGtId       := ""
	Default cEmpP		:='01'
	Default cFilP		:='02' 

	//Abre empresa para Faturamento retirar comentário para processamento em JOB	
	RpcSetType(3)
	RpcSetEnv(cEmpP,cFilP)

	cPedido		:= Eval(bVldCtd, aParamFun, 1	,"")
	nIdJob		:= Eval(bVldCtd, aParamFun, 2	,1)
	lFat		:= Eval(bVldCtd, aParamFun, 3	,.T.)
	cNsNum		:= Eval(bVldCtd, aParamFun, 4	,"")
	lServ		:= Eval(bVldCtd, aParamFun, 5	,.T.)
	lProd		:= Eval(bVldCtd, aParamFun, 6	,.T.)
	nQtdFat		:= Eval(bVldCtd, aParamFun, 7	,0)
	cOpVen		:= Eval(bVldCtd, aParamFun, 8	,GetNewPar("MV_XOPEVDH", "62"))
	cOpEnt		:= Eval(bVldCtd, aParamFun, 9	,GetNewPar("MV_XOPENTH", "53"))
	cOpSer		:= Eval(bVldCtd, aParamFun, 10	,GetNewPar("MV_XOPEVDS", "61"))
	cPedLog		:= Eval(bVldCtd, aParamFun, 11	,Alltrim(Str(nIdJob)))
	dCredCnab	:= Eval(bVldCtd, aParamFun, 12	,dDataBase)
	lRecPgto	:= Eval(bVldCtd, aParamFun, 13	,.F.)
	lGerTitRecb	:= Eval(bVldCtd, aParamFun, 14	,.T.)
	cTipTitRecb := Eval(bVldCtd, aParamFun, 15	,"")
	lEnt		:= Eval(bVldCtd, aParamFun, 16	,!lFat)
	nVlrTitRecb := Eval(bVldCtd, aParamFun, 17	,0)
	cBcoCnab	:= Eval(bVldCtd, aParamFun, 18	,'341')
	cPedGarIt	:= Eval(bVldCtd, aParamFun, 19	,'')

	//Posiciona no Pedido
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTo(nRecPed))

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

	//Processa Faturamento
	If !Empty(SC5->C5_XNUMVOU)
		cID      := DTOS(DATE())+SC5->C5_XNPSITE
		cPedSite := SC5->C5_XNPSITE
		cPedLog  := IIF(EMPTY(SC5->C5_CHVBPAG), SC5->C5_XNPSITE,SC5->C5_CHVBPAG)
		oVoucher := getVoucher( cPedSite, cPedLog  )
		aRVou    := U_VNDA430( oVoucher )

		aParamFun := {SC5->C5_NUM,;
		Val(SC5->C5_XNPSITE),;
		lFat,;
		nil,;
		aRVou[4],;
		aRVou[5],;
		nil,;
		iif(!Empty(aRVou[7]),aRVou[7],nil),;
		iif(!Empty(aRVou[8]),aRVou[8],nil),;
		iif(!Empty(aRVou[6]),aRVou[6],nil),;
		nil,;
		nil,;
		lRecPgto,;
		lGerTitRecb,;
		cTipTitRecb,;
		lEnt,;
		nil,;
		nil,;
		cPedGarIt}

	EndIf

	U_VNDA190( SC5->C5_XNPSITE ,aParamFun	)

Return


/*/{Protheus.doc} VN191GST
Chama o pergunte MT460A e seta a geração da guia de recolhimento do ST para Sim.

@author Raphael
@since 30/11/2014
@version 1.0
@example
(examples)
@see (links_or_references)
/*/

User Function VN191GST()
	Local cPerg		:= "MT460A"
	/* 
	Grupo de pergunte padrão da rotina MT460A
	mv_par01 Mostra Lan‡.Contab       	Sim/Nao
	mv_par02 Aglut. Lan‡amentos       	Sim/Nao
	mv_par03 Lan‡.Contab.On-Line      	Sim/Nao
	mv_par04 Contb.Custo On-Line      	Sim/Nao
	mv_par05 Reaj. na mesma N.F.      	Sim/Nao
	mv_par06 Taxa deflacao ICMS       	Numeric
	mv_par07 Metodo calc.acr.fin      	Taxa defl/Dif.lista/% Acrs.ped
	mv_par08 Arred.prc unit vist      	Sempre/Nunca/Consumid.final
	mv_par09 Agreg. liberac. de       	Caracter
	mv_par10 Agreg. liberac. ate      	Caracter
	mv_par11 Aglut.Ped. Iguais        	Sim/Nao
	mv_par12 Valor Minimo p/fatu    
	mv_par13 Transportadora de      
	mv_par14 Transportadora ate     
	mv_par15 Atualiza Cli.X Prod    
	mv_par16 Emitir                   	Nota / Cupom Fiscal / DAV
	mv_par17 Gera Titulo              	Sim/Nao
	mv_par18 Gera guia recolhimento		Sim/Nao
	mv_par19 Gera Titulo ICMS Próprio	Sim/Nao
	mv_par20 Gera Guia ICMS Próprio		Sim/Nao
	mv_par22 Gera Titulo por Pruduto	Sim/Nao
	mv_par23 Gera Guia por Produto		Sim/Nao
	*/
	// X1_GRUPO+X1_ORDEM
	SX1->(DbSetOrder(1))
	//Seta pré seleção para gera guia recolhimento como SIM (1)
	If SX1->( DbSeek( Padr( cPerg,Len(SX1->X1_GRUPO))+ "18"))
		RecLock("SX1",.F.)
		SX1->X1_PRESEL	:= 1
		MsUnlock()
	EndIf
	Pergunte(cPerg,.F.)
	MV_PAR18	:= 1
Return

static function getVoucher(  cPedSite, cPedLog  )
	local oVoucher := nil
	local oPedido  := nil
	local cError   := ""
	local cWarning := ""
	local nPed     := 0
	local cID      := ""
	
	default cPedSite := ""
	
	if !empty( cPedSite ) 
	
		//Retorna o ID da GTIN pelo pedido SITE
		cID := getIdGtIn( cPedSite )

		if !empty( cID )
			//Monto XML do pedido
			oPedido  := montarXML( cID, @cError, @cWarning, @nPed )
		
			//Carrego dados do Voucher
			oVoucher := CSVoucherPV():New( cID, cPedSite, cPedLog, oPedido:_LISTPEDIDOFULLTYPE:_PEDIDO[ nPed ] )
		endif
	endif
return oVoucher

static function montarXML( cID, cError, cWarning, nPed )
	Local cRootPath		:= ""
	Local cArquivo		:= ""
	local oXml := nil
	
	default cID      := ""
	default cError   := ""
	default cWarning := ""
	default nPed     := 0 

	//Monta caminho do arquivo
	cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
	cRootPath	+= "vendas_site\"
	If Len( cID ) <= 18
		cArquivo	:= "Pedidos_" + Left(cID,12) + ".XML"
	Else
		cArquivo	:= "Pedidos_" + Left(cID,17) + ".XML"
	EndIf
	cArquivo	:= cRootPath + cArquivo

	//Monta xml com base em arquivo fisico gravado no servidor
	oXml := XmlParserFile( cArquivo, "_", @cError, @cWarning )
	
	if empty( cError)
		If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
			XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
		EndIf

		nPed := Val( Right( alltrim( cID ), 6 ) )
	endif
return oXml

static function getIdGtIn( cPedSite )
	local cQuery := ""
	local cAlias := ""
	local oQuery := nil

	cQuery := "SELECT GT_ID, GT_PEDGAR "
	cQuery += "FROM GTIN "
	cQuery += "WHERE GT_TYPE = 'F' "
	cQuery += "		AND D_E_L_E_T_ = ' ' "	
	cQuery += "		AND GT_XNPSITE IN ('"+ alltrim( cPedSite )+ "')"
		
	oQuery := CSQuerySQL():New()
	if oQuery:Consultar( cQuery )
		cAlias  := oQuery:GetAlias() //Alias da tabela temporaria
		cID := AllTrim( (cAlias)->GT_ID )
		( cAlias )->( dbCloseArea() )
	endif			
return cID