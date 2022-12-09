#Include "Protheus.ch"
#Include "TBICONN.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} PLOOMESPRD
	Atualização de produtos no Ploomes via API, chamado no ponto de entrada da rotina de cadastro de produtos.
	@type  Function
	@author Gustavo Gonzalez
	@since 25/09/2022
/*/
User Function PLOOMESPRD()
    Local oObjProd

    Private nTimeOut	:= 120
    Private cHeadRet	:= ''
    Private aHeadApi  	:= {}
    Private cPostRet    := ''

    //Variáveis da Rotina.
    cChaveApi 	:= SuperGetMv( "PL_KEY"     ,.F.,'04DED59E1F32E6599751F7E04F1B6231D6A30410D827110032775FE59D7E8E2F9DBB764F32CA85B0487EBBCDE7D40EC0F61913DD3D3A917E3EBAD25F87B210B0')					// Chave API gerada no site da Ploomes
    cEndpoint	:= SuperGetMv( "PL_ENDPOI"  ,.F.,'https://prozyn.ploomes-services.com')				// Ambiente a ser passado como parametros para acesso Ã  API da Ploomes

    //Monta Cabeçalho
    Aadd( aHeadApi	, 'Content-Type: application/json' )
    Aadd( aHeadApi	, 'accept": /' )

    If M->B1_TIPO $ 'PA/ME'
        oObjProd                := ObjProd():New()
        oObjProd:B1_FILIAL      := Alltrim(M->B1_FILIAL)
        oObjProd:B1_COD         := Alltrim(M->B1_COD)
        oObjProd:B1_DESC        := U_CONVJSON(M->B1_DESC)
        oObjProd:B1_TIPO        := U_CONVJSON(M->B1_TIPO + ' - ' + Posicione("SX5", 1, xfilial("SX5")+'02'+M->B1_TIPO, "X5_DESCRI"))
        oObjProd:B1_UM          := U_CONVJSON(M->B1_UM + ' - ' + Posicione("SAH", 1, xfilial("SAH")+M->B1_UM, "AH_UMRES"))
        oObjProd:B1_ATIVO       := U_CONVJSON(M->B1_ATIVO + ' - ' + Iif(M->B1_ATIVO == 'S','ATIVO','INATIVO'))
        oObjProd:B1_PRVALID     := M->B1_PRVALID
        oObjProd:B1_COMOD       := U_CONVJSON(M->B1_COMOD + ' - ' + Iif(M->B1_COMOD == 'S','SIM','NÃO'))
        oObjProd:B1_XGRPCOM     := IIF(Empty(M->B1_XGRPCOM),'',U_CONVJSON(M->B1_XGRPCOM + ' - ' + Posicione("SZU", 1, xfilial("SZU")+M->B1_XGRPCOM, "ZU_DESCRI")))
        cProdJson       	    := FWJsonSerialize(oObjProd,.F.,.F.)
        cProdJson               := Strtran(cProdJson,'\\','\')

        cURLParam	:= "/webhook/00872709-93fc-4fb3-b2a9-8c170c484r5"
        cPostRet 	:= HttpPost( cEndpoint+cURLParam, "", cProdJson, nTimeOut, aHeadApi, @cHeadRet )
        cErr		:= Substr(cHeadRet,10,3)
        Memowrite('\PLOOMES\log_ploomesprd.json',cProdJson)

        If cErr == "200"
            FWAlertSuccess("Produto integrado ao Ploomes com sucesso.", "Ploomes")
        else
            FWAlertError("Erro ao integrar produto com o Ploomes." + Chr(13)+Chr(10) +;
                "Erro:" + cErr + ' ' + cPostRet, "Ploomes")
        EndIf

        FreeObj(oObjProd)
    EndIf

Return

Class ObjProd
    Data B1_FILIAL
    Data B1_COD
    Data B1_DESC
    Data B1_TIPO
    Data B1_UM
    Data B1_ATIVO
    Data B1_PRVALID
    Data B1_COMOD
    Data B1_XGRPCOM

    Method New() CONSTRUCTOR
EndClass

Method New() Class ObjProd
    ::B1_FILIAL     := ''
    ::B1_COD        := ''
    ::B1_DESC       := ''
    ::B1_TIPO       := ''
    ::B1_UM         := ''
    ::B1_ATIVO      := ''
    ::B1_PRVALID    := 0
    ::B1_COMOD      := ''
    ::B1_XGRPCOM    := ''
Return
