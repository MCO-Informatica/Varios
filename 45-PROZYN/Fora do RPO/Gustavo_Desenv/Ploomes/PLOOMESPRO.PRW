#Include "Protheus.ch"
#Include "TBICONN.ch"

/*/{Protheus.doc} PLOOMESPRO
	Atualização de produtos no Ploomes via API
	@type  Function
	@author Gustavo Gonzalez
	@since 02/09/2021
/*/
User Function PLOOMESPRO()
    Local cEmpDef 	:= '01'
    Local cFilDef	:= '01'
    Local lTeste    := .T.
    Local nIDPro    := 0
    Local cBody     := ''


    Private oObjGet
    Private oObjPost
    Private nTimeOut	:= 120
    Private cHeadRet	:= ''
    Private aHeadApi  	:= {}
    Private cGetRet	:= ''
    Private cPatchRet  := ''
    Private cPostRet   := ''

    If lTeste
        //Abre o Ambiente
        RPCSetType(3)
        RpcSetEnv ( cEmpDef, cFilDef)
        cProduto    := '009721         '
        DBselectArea('SB5')
        DBSetOrder(1)
        SB5->(dbSeek(xFilial("SB5")+cProduto))
    EndIf

    //Variáveis da Rotina.
    cChaveApi 	:= SuperGetMv( "PL_KEY"     ,.F.,'04DED59E1F32E6599751F7E04F1B6231D6A30410D827110032775FE59D7E8E2F9DBB764F32CA85B0487EBBCDE7D40EC0F61913DD3D3A917E3EBAD25F87B210B0')					// Chave API gerada no site da Ploomes
    cEndpoint	:= SuperGetMv( "PL_ENDPOI"  ,.F.,'https://api2.ploomes.com')				// Ambiente a ser passado como parametros para acesso à API da Ploomes

    //Monta Array do Cabecalho
    Aadd( aHeadApi	, 'User-Key: ' + cChaveApi )

    //Verificar ID do cliente na Ploomes
    nIDPro  := IDPROPLOOM()

    //Gerar dados para requisição de atualização de dados.
    cBody   := '{'
    cBody   += '    "Name": "TESTE ' + Alltrim(SB5->B5_CEME) + '"'
    cBody   += '}'

    cBody   := EncodeUTF8(cBody, "cp1252")

    If nIDPro == 0 //Cadastrar cliente novo
        cURLParam	:= "/Products"
        cPostRet 	:= HttpPost( cEndpoint+cURLParam, "", cBody, nTimeOut, aHeadApi, @cHeadRet )
        cErr		:= Substr(cHeadRet,10,3)
        If cErr == "200"
            FWJsonDeserialize(cPostRet ,@oObjPost)
            Reclock('SB5',.F.)
            SB5->B5_IDPLOOM := oObjPost:VALUE[1]:ID
            MsUnlock()
            MsgInfo('Produto Atualizado na Ploomes')
        else
            Alert("Erro ao atualizar produto na Ploomes")
        EndIf
    else //Atualizar cadastro existente
        cURLParam	:= "/Products(" + Alltrim(STR(nIDPro)) + ")"
        cPatchRet 	:= HttpQuote( cEndpoint+cURLParam,"PATCH","",cBody , nTimeOut, aHeadApi, @cHeadRet )
        cErr		:= Substr(cHeadRet,10,3)
        If cErr == "200"
            MsgInfo('Produto Atualizado na Ploomes')
        else
            Alert("Erro ao atualizar produto na Ploomes")
        EndIf
    EndIf

Return

Static Function IDPROPLOOM()
    Local nRet  := 0

    If SB5->B5_IDPLOOM <> 0
        nRet    := SB5->B5_IDPLOOM
    else
        cURLParam	:= "/Products?$filter=Code+eq+'" + Alltrim(SB5->B5_COD) + "'"
        cGetRet  	:= HttpGet(cEndpoint+cURLParam, "", nTimeOut, aHeadApi, @cHeadRet )
        cErr		:= Substr(cHeadRet,10,3)
        If cErr == '200'
            cGetRet	:= DecodeUTF8(cGetRet)
            FWJsonDeserialize(cGetRet ,@oObjGet)
            If Len(oObjGet:VALUE) > 0
                nRet    := oObjGet:VALUE[1]:ID
                Reclock('SB5',.F.)
                SB5->B5_IDPLOOM := nRet
                MsUnlock()
            EndIf
        else
            Alert('Erro na comunicacao com o Ploomes, favor informar o administrador.')
        EndIf
    EndIf

Return nRet

