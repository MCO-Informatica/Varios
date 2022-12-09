#Include "Protheus.ch"
#Include "TBICONN.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} PLOOMESCLI
	Atualização de clientes no Ploomes via API, chamado no ponto de entrada da rotina de cadastro de Clientes.
	@type  Function
	@author Gustavo Gonzalez
	@since 25/09/2022
/*/
User Function PLOOMESCLI()
    Local oObjCli

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

    If SA1->A1_PESSOA == 'J'
        oObjCli                 := ObjCli():New()
        oObjCli:A1_COD_A1_LOJA  := Alltrim(SA1->A1_COD + SA1->A1_LOJA)
        oObjCli:A1_FILIAL       := Alltrim(SA1->A1_FILIAL)
        oObjCli:A1_COD          := Alltrim(SA1->A1_COD)
        oObjCli:A1_LOJA         := Alltrim(SA1->A1_LOJA)
        oObjCli:A1_NOME         := U_CONVJSON(SA1->A1_NOME)
        oObjCli:A1_PESSOA       := U_CONVJSON(SA1->A1_PESSOA + ' - ' + Iif(SA1->A1_PESSOA == 'J','EMPRESA','PESSOA'))
        oObjCli:A1_NREDUZ       := U_CONVJSON(SA1->A1_NREDUZ)
        oObjCli:A1_END          := U_CONVJSON(SA1->A1_END)
        oObjCli:A1_BAIRRO       := U_CONVJSON(SA1->A1_BAIRRO)
        oObjCli:A1_MUN          := U_CONVJSON(SA1->A1_MUN)
        oObjCli:A1_COD_MUN      := Alltrim(SA1->A1_COD_MUN)
        oObjCli:A1_EST          := Alltrim(SA1->A1_EST)
        oObjCli:A1_CEP          := Alltrim(SA1->A1_CEP)
        oObjCli:A1_PAIS         := U_CONVJSON(SA1->A1_PAIS + ' - ' + Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR"	))
        oObjCli:A1_CGC          := Alltrim(SA1->A1_CGC)
        oObjCli:A1_GRPVEN       := U_CONVJSON(SA1->A1_GRPVEN + ' - ' + Posicione("ACY",1,xFilial("ACY")+SA1->A1_GRPVEN,"ACY_DESCRI"	))
        oObjCli:A1_SUFRAMA      := U_CONVJSON(SA1->A1_SUFRAMA)
        oObjCli:A1_INSCR        := U_CONVJSON(SA1->A1_INSCR)
        oObjCli:A1_MSBLQL       := U_CONVJSON(SA1->A1_MSBLQL + ' - ' + Iif(SA1->A1_MSBLQL == '1','INATIVO','ATIVO'))
        oObjCli:A1_COND         := U_CONVJSON(SA1->A1_COND + ' - ' + Posicione("SE4", 1, xfilial("SE4")+SA1->A1_COND, "E4_DESCRI"))
        oObjCli:A1_VEND         := U_CONVJSON(SA1->A1_VEND + ' - ' + Posicione("SA3", 1, xfilial("SA3")+SA1->A1_VEND, "A3_NOME"))
        oObjCli:A1_RISCO        := U_CONVJSON(SA1->A1_RISCO)
        oObjCli:E4_XDECOM       := U_CONVJSON(Posicione("SE4", 1, xfilial("SE4")+SA1->A1_COND, "E4_XDECOM"))
        cCliJson       	        := FWJsonSerialize(oObjCli,.F.,.F.)
        cCliJson                := Strtran(cCliJson,'\\','\')

        cURLParam	:= "/webhook/00872709-93fc-4fb3-b2a9-8c170c487e04"
        cPostRet 	:= HttpPost( cEndpoint+cURLParam, "", cCliJson, nTimeOut, aHeadApi, @cHeadRet )
        cErr		:= Substr(cHeadRet,10,3)
        Memowrite('\PLOOMES\log_ploomescli.json',cCliJson)
        If cErr == "200"
            FWAlertSuccess("Cliente integrado ao Ploomes com sucesso.", "Ploomes")
        else
            FWAlertError("Erro ao integrar cliente com o Ploomes." + Chr(13)+Chr(10) +;
                         "Erro:" + cErr + ' ' + cPostRet, "Ploomes")
        EndIf

        FreeObj(oObjCli)
    EndIf
Return

Class ObjCli
    Data A1_COD_A1_LOJA
    Data A1_FILIAL
    Data A1_COD
    Data A1_LOJA
    Data A1_NOME
    Data A1_PESSOA
    Data A1_NREDUZ
    Data A1_END
    Data A1_BAIRRO
    Data A1_MUN
    Data A1_COD_MUN
    Data A1_EST
    Data A1_CEP
    Data A1_PAIS
    Data A1_CGC
    Data A1_GRPVEN
    Data A1_SUFRAMA
    Data A1_INSCR
    Data A1_MSBLQL
    Data A1_COND
    Data A1_VEND
    Data A1_RISCO
    Data E4_XDECOM

    Method New() CONSTRUCTOR
EndClass

Method New() Class ObjCli
    ::A1_COD_A1_LOJA    := ''
    ::A1_FILIAL         := ''
    ::A1_COD            := ''
    ::A1_LOJA           := ''
    ::A1_NOME           := ''
    ::A1_PESSOA         := ''
    ::A1_NREDUZ         := ''
    ::A1_END            := ''
    ::A1_BAIRRO         := ''
    ::A1_MUN            := ''
    ::A1_COD_MUN        := ''
    ::A1_EST            := ''
    ::A1_CEP            := ''
    ::A1_PAIS           := ''
    ::A1_CGC            := ''
    ::A1_GRPVEN         := ''
    ::A1_SUFRAMA        := ''
    ::A1_INSCR          := ''
    ::A1_MSBLQL         := ''
    ::A1_COND           := ''
    ::A1_VEND           := ''
    ::A1_RISCO          := ''
    ::E4_XDECOM         := ''
Return
