#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'
#Include 'TbiConn.ch'
/* Função para incluir uma solicitação de tranferencia de materiais */
User Function renp110(aTransf,cJustif,cSolTrf,cMens)

	Local lRet := .t.
	Local oModel
	local oMaster
	local oDetail
	Local aLog
	Local nX

	Local cFilOri := ""
	local cProduto := ""
	local cLocal := ""
	local cLocaliz := ""
	local nQuant := 0
	local cFilDes := ""
	local cProdDes:= ""
	local cLocDes := ""
	local cLocaDes := ""
	local cTs := ""
	local cTe := ""
	Local nIts := len(aTransf)

	Private lMsErroAuto := .f. //seta variavel private como erro

	Private L311GTL := .t.
	Private C311NUMSER  := ""
	Private C311LOTE := ""
	Private C311NUMLOTE := ""

	oModel := FWLoadModel("MATA311") //Carrega o modelo
	oModel:SetOperation(MODEL_OPERATION_INSERT) // Seta operação de inclusão
	oModel:Activate() // Ativa o Modelo

	oMaster := oModel:GetModel( 'NNSMASTER' )
	oDetail := oModel:GetModel( 'NNTDETAIL' )

	//Cabeçalho da solicitacao
	oMaster:SetValue( 'NNS_CLASS', '1' )
	oMaster:SetValue( 'NNS_ESPECI', 'SPED' )

	//Itens da solicitacao
	for nX := 1 to nIts

		cFilOri := aTransf[nX, 1]
		cProduto := aTransf[nX, 2]
		cLocal := aTransf[nX, 3]
		cLocaliz := aTransf[nX, 4]
		nQuant := aTransf[nX, 5]
		cFilDes := aTransf[nX, 6]
		cProdDes:= aTransf[nX, 7]
		cLocDes := aTransf[nX, 8]
		cLocaDes := aTransf[nX, 9]
		cTs := aTransf[nX, 10]
		cTe := aTransf[nX, 11]

		// produto e local de origem
		oDetail:SetValue( 'NNT_FILORI', cFilOri )
		oDetail:SetValue( 'NNT_PROD', cProduto )
		oDetail:SetValue( 'NNT_LOCAL', cLocal )
		oDetail:SetValue( 'NNT_LOCALI', cLocaliz )
		//oDetail:SetValue( 'NNT_NSERIE', " " )
		//oDetail:SetValue( 'NNT_LOTECT', " " )
		//oDetail:SetValue( 'NNT_NUMLOT', " " )
		//oDetail:SetValue( 'NNT_DTVALID', dDataBase )
		oDetail:SetValue( 'NNT_QUANT', nQuant )
		// produto e local de destino
		if !empty(cFilDes)
			oDetail:SetValue( 'NNT_FILDES', cFilDes )
		endif
		if !empty(cProdDes)
			oDetail:SetValue( 'NNT_PRODD', cProdDes )
		endif
		if !empty(cLocDes)
			oDetail:SetValue( 'NNT_LOCLD', cLocDes )
		endif
		if !empty(cLocaDes)
			oDetail:SetValue( 'NNT_LOCLID', cLocaDes )
		endif
		// Caso seja transferencia de filiais os campos de TES de entrada e saida são obrigatorios
		if !empty(cTs)
			oDetail:SetValue( 'NNT_TS', cTs )
		endif
		if !empty(cTe)
			oDetail:SetValue( 'NNT_TE', cTe )
		endif

		if nX < nIts
			oDetail:AddLine()
		endif

	next

	If oModel:VldData() //Validação do modelo
		oModel:CommitData() // Gravação do Modelo
		nns->(RecLock("nns",.f.))
		nns->nns_justif := cJustif
		nns->(MsUnLock())
		cSolTrf := nns->nns_cod
		cMens += "A solicitação de transferências "+cSolTrf+", foi gerada!"
	Else
		aLog := oModel:GetErrorMessage() //Recupera o erro do model quando nao passou no VldData
		//laco para gravar em string cLog conteudo do array aLog
		For nX := 1 to Len(aLog)
			If !Empty(aLog[nX])
				cMens += Alltrim(aLog[nX]) + CHR(13)+CHR(10)
			EndIf
		Next nX
		lRet := .f.
		//AutoGRLog(cMens) //grava log para exibir com funcao mostraerro
		//MostraErro()
	EndIf

	oModel:DeActivate() //desativa modelo

Return lRet
