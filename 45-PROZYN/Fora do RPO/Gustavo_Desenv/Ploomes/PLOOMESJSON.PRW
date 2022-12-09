#Include "Protheus.ch"
#Include "TBICONN.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} PLOOMESJSON
	Integração geral com o Ploomes. TESTE
	@type  Function
	@author Gustavo Gonzalez
	@since 02/09/2021
/*/
User Function PLOOMESJSON()
    Local lTeste        := .T.
    Local lExecCli      := .F.
    Local lExecPrd      := .T.
    Local lExecPrc      := .F.
    Local oObjCliJson

    Private nTimeOut	:= 120
    Private cHeadRet	:= ''
    Private aHeadApi  	:= {}
    Private cPostRet    := ''

    If lTeste
        //Abre o Ambiente
        RPCSetType(3)
        RpcSetEnv ( "01", "01")
    EndIf

    //Variáveis da Rotina.
    cChaveApi 	:= SuperGetMv( "PL_KEY"     ,.F.,'04DED59E1F32E6599751F7E04F1B6231D6A30410D827110032775FE59D7E8E2F9DBB764F32CA85B0487EBBCDE7D40EC0F61913DD3D3A917E3EBAD25F87B210B0')					// Chave API gerada no site da Ploomes
    cEndpoint	:= SuperGetMv( "PL_ENDPOI"  ,.F.,'https://prozyn.ploomes-services.com')				// Ambiente a ser passado como parametros para acesso Ã  API da Ploomes

    //Monta Cabeçalho
    Aadd( aHeadApi	, 'Content-Type: application/json' )
    Aadd( aHeadApi	, 'accept": /' )

    If lExecPrd //Roda Integração de Produto.
        QrySB1  := GetNextAlias()

        cQuery  := " SELECT TOP 1 * FROM " + RetSqlName("SB1")
        cQuery  += " WHERE B1_TIPO IN ('PA','ME') "
        cQuery  += " AND B1_GRUPO <> '9999' "
        cQuery  += " AND D_E_L_E_T_ = ''  "

        Memowrite('\PLOOMES\cQueryPrd.txt',cQuery)
        TcQuery cQuery New Alias QrySB1

        While QrySB1->(!Eof())
            oObjProdJson                := ObjProdJson():New()
            oObjProdJson:B1_FILIAL      := Alltrim(QrySB1->B1_FILIAL)
            oObjProdJson:B1_COD         := Alltrim(QrySB1->B1_COD)
            oObjProdJson:B1_DESC        := U_CONVJSON(QrySB1->B1_DESC)
            oObjProdJson:B1_POSIPI      := U_CONVJSON(Substr(QrySB1->B1_POSIPI,1,4)+'.'+Substr(QrySB1->B1_POSIPI,5,2)+'.'+Substr(QrySB1->B1_POSIPI,7,2))
            oObjProdJson:B1_TIPO        := U_CONVJSON(QrySB1->B1_TIPO)
            oObjProdJson:B1_UM          := U_CONVJSON(QrySB1->B1_UM)
            oObjProdJson:B1_MSBLQL      := U_CONVJSON(QrySB1->B1_MSBLQL + ' - ' + Iif(QrySB1->B1_MSBLQL == 'S','ATIVO','INATIVO'))
            oObjProdJson:B1_PRVALID     := QrySB1->B1_PRVALID
            oObjProdJson:B1_COMOD       := U_CONVJSON(Iif(QrySB1->B1_COMOD == 'S','SIM','NÃO'))
            oObjProdJson:ZU_DESCRI      := IIF(Empty(QrySB1->B1_XGRPCOM),'',U_CONVJSON(Posicione("SZU", 1, xfilial("SZU")+QrySB1->B1_XGRPCOM, "ZU_DESCRI")))      
            oObjProdJson:B1_ESPVEND     := U_CONVJSON(QrySB1->B1_ESPVEND)
            oObjProdJson:B1_QE          := QrySB1->B1_QE
            oObjProdJson:B1_IPI         := U_CONVJSON(Str(QrySB1->B1_IPI)+'%')
            cProdJson       	    := FWJsonSerialize(oObjProdJson,.F.,.F.)
            cProdJson               := Strtran(cProdJson,'\\','\')

            cURLParam	:= "/webhook/00872709-93fc-4fb3-b2a9-8c170c484r5"
            cPostRet 	:= HttpPost( cEndpoint+cURLParam, "", cProdJson, nTimeOut, aHeadApi, @cHeadRet )
            cErr		:= Substr(cHeadRet,10,3)
            If cErr == "200"
                Conout('PLOOMES PRODUTO DEU CERTO')
                Memowrite('\PLOOMES\PRODUTO_' + oObjProdJson:B1_COD + '.JSON',cProdJson)
            else
                Conout('PLOOMES PRODUTO NÃO DEU CERTO')
                Memowrite('\PLOOMES\ERRO_PRODUTO_' + oObjProdJson:B1_COD + '.JSON',cProdJson + CHR(13)+CHR(10) + cPostRet)
            EndIf

            FreeObj(oObjProdJson)
            QrySB1->(DBSkip())
        Enddo
    EndIf

    If lExecCli //Roda Integração de Cliente
        QrySA1  := GetNextAlias()

        cQuery  := " SELECT * FROM " + RetSqlName("SA1")
        cQuery  += " WHERE A1_PESSOA = 'J' "
        //cQuery  += " AND A1_COD IN ('005098') AND A1_LOJA = '01' "
        cQuery  += " AND D_E_L_E_T_ = ''  "
        cQuery  += " AND A1_CEP like '%-%' "

        Memowrite('\PLOOMES\cQueryCli.txt',cQuery)
        TcQuery cQuery New Alias QrySA1

        While QrySA1->(!Eof())
            oObjCliJson                 := ObjCliJson():New()
            oObjCliJson:A1_COD_A1_LOJA  := Alltrim(QrySA1->A1_COD + QrySA1->A1_LOJA)
            oObjCliJson:A1_FILIAL       := Alltrim(QrySA1->A1_FILIAL)
            oObjCliJson:A1_COD          := Alltrim(QrySA1->A1_COD)
            oObjCliJson:A1_LOJA         := Alltrim(QrySA1->A1_LOJA)
            oObjCliJson:A1_NOME         := U_CONVJSON(QrySA1->A1_NOME)
            oObjCliJson:A1_PESSOA       := U_CONVJSON(QrySA1->A1_PESSOA + ' - ' + Iif(QrySA1->A1_PESSOA == 'J','EMPRESA','PESSOA'))
            oObjCliJson:A1_NREDUZ       := U_CONVJSON(QrySA1->A1_NREDUZ)
            oObjCliJson:A1_END          := U_CONVJSON(QrySA1->A1_END)
            oObjCliJson:A1_BAIRRO       := U_CONVJSON(QrySA1->A1_BAIRRO)
            oObjCliJson:A1_MUN          := U_CONVJSON(QrySA1->A1_MUN)
            oObjCliJson:A1_COD_MUN      := Alltrim(QrySA1->A1_COD_MUN)
            oObjCliJson:A1_EST          := Alltrim(QrySA1->A1_EST)
            oObjCliJson:A1_CEP          := Alltrim(QrySA1->A1_CEP)
            oObjCliJson:A1_PAIS         := U_CONVJSON(QrySA1->A1_PAIS + ' - ' + Posicione("SYA",1,xFilial("SYA")+QrySA1->A1_PAIS,"YA_DESCR"	))
            oObjCliJson:A1_CGC          := Alltrim(QrySA1->A1_CGC)
            oObjCliJson:A1_GRPVEN       := U_CONVJSON(QrySA1->A1_GRPVEN + ' - ' + Posicione("ACY",1,xFilial("ACY")+QrySA1->A1_GRPVEN,"ACY_DESCRI"	))
            oObjCliJson:A1_SUFRAMA      := U_CONVJSON(QrySA1->A1_SUFRAMA)
            oObjCliJson:A1_INSCR        := U_CONVJSON(QrySA1->A1_INSCR)
            oObjCliJson:A1_MSBLQL       := U_CONVJSON(QrySA1->A1_MSBLQL + ' - ' + Iif(QrySA1->A1_MSBLQL == '1','INATIVO','ATIVO'))
            oObjCliJson:A1_COND         := U_CONVJSON(QrySA1->A1_COND + ' - ' + Posicione("SE4", 1, xfilial("SE4")+QrySA1->A1_COND, "E4_DESCRI"))
            oObjCliJson:A1_VEND         := U_CONVJSON(QrySA1->A1_VEND + ' - ' + Posicione("SA3", 1, xfilial("SA3")+QrySA1->A1_VEND, "A3_NOME"))
            oObjCliJson:A1_RISCO        := U_CONVJSON(QrySA1->A1_RISCO)
            oObjCliJson:E4_XDECOM       := U_CONVJSON(Posicione("SE4", 1, xfilial("SE4")+QrySA1->A1_COND, "E4_XDECOM"))
            cCliJson       	        := FWJsonSerialize(oObjCliJson,.F.,.F.)
            cCliJson                := Strtran(cCliJson,'\\','\')

            cURLParam	:= "/webhook/00872709-93fc-4fb3-b2a9-8c170c487e04"
            cPostRet 	:= HttpPost( cEndpoint+cURLParam, "", cCliJson, nTimeOut, aHeadApi, @cHeadRet )
            cErr		:= Substr(cHeadRet,10,3)
            If cErr == "200"
                Conout('PLOOMES CLIENTE DEU CERTO')
                Memowrite('\PLOOMES\CLIENTE_'+oObjCliJson:A1_COD_A1_LOJA+'.json',cCliJson)
            else
                Conout('PLOOMES CLIENTE NÃO DEU CERTO')
                Memowrite('\PLOOMES\ERRO_'+oObjCliJson:A1_COD_A1_LOJA+'.json',cCliJson + CHR(13)+CHR(10) + cPostRet)
            EndIf

            FreeObj(oObjCliJson)

            QrySA1->(DBSkip())
        Enddo
    EndIf

    If lExecPrc //Roda integração de tabela de preço.
        QryDA0  := GetNextAlias()

        cQuery  := " SELECT * FROM " + RetSqlName("DA0") + " DA0 "
        cQuery  += " INNER JOIN " + RetSqlName("DA1") + " DA1 ON DA0_CODTAB = DA1_CODTAB "
        cQuery  += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON DA1_CODPRO = B1_COD "
        cQuery  += " WHERE DA0_CODTAB IN ('002') "
        cQuery  += " AND DA0.D_E_L_E_T_ = ''  "
        cQuery  += " AND DA1.D_E_L_E_T_ = ''  "
        cQuery  += " AND SB1.D_E_L_E_T_ = ''  "

        Memowrite('\PLOOMES\cQueryPrc.txt',cQuery)
        TcQuery cQuery New Alias QryDA0

        While QryDA0->(!Eof())
            oObjPrc                         := ObjPrc():New()
            oObjPrc:DA0_YCODCL_DA0_YLJCLI   := QryDA0->DA0_YCODCL+QryDA0->DA0_YLJCLI
            oObjPrc:DA0_DESCRI              := U_CONVJSON(QryDA0->DA0_DESCRI)
            oObjPrc:DA1_CODPRO              := Alltrim(QryDA0->DA1_CODPRO)
            oObjPrc:DA1_DESCRI              := U_CONVJSON(QryDA0->B1_DESC)
            oObjPrc:DA1_PRNET               := QryDA0->DA1_PRNET
            oObjPrc:DA1_YICMS               := U_CONVJSON(Str(QryDA0->DA1_YICMS)+'%')
            oObjPrc:DA1_YIPI                := U_CONVJSON(Str(QryDA0->DA1_YIPI)+'%')
            oObjPrc:DA1_YCOFIN              := U_CONVJSON(Str(QryDA0->DA1_YCOFIN )+'%')
            oObjPrc:DA1_YPIS                := U_CONVJSON(Str(QryDA0->DA1_YPIS  )+'%')
            oObjPrc:DA1_MOEDA               := U_CONVJSON(Alltrim(Str(QryDA0->DA1_MOEDA)) + ' - ' + Iif(QryDA0->DA1_MOEDA == 1,'REAL','DÓLAR'))
            cPrcJson       	                := FWJsonSerialize(oObjPrc,.F.,.F.)
            cPrcJson                        := Strtran(cPrcJson,'\\','\')
            Memowrite('\PLOOMES\PRECO_' + oObjPrc:DA0_YCODCL_DA0_YLJCLI + '_' + oObjPrc:DA1_CODPRO + '.JSON',cPrcJson)
            FreeObj(oObjPrc)
            QryDA0->(DBSkip())
        Enddo
    EndIf

Return


Class ObjProdJson
    Data B1_FILIAL
    Data B1_COD
    Data B1_DESC
    Data B1_POSIPI 
    Data B1_TIPO
    Data B1_UM
    Data B1_MSBLQL
    Data B1_PRVALID
    Data B1_COMOD
    Data ZU_DESCRI
    Data B1_ESPVEND
    Data B1_QE
    Data B1_IPI


    Method New() CONSTRUCTOR
EndClass

Method New() Class ObjProdJson
    ::B1_FILIAL     := ''
    ::B1_COD        := ''
    ::B1_DESC       := ''
    ::B1_POSIPI     := ''
    ::B1_TIPO       := ''
    ::B1_UM         := ''
    ::B1_MSBLQL     := ''
    ::B1_PRVALID    := 0
    ::B1_COMOD      := ''
    ::ZU_DESCRI     := ''
    ::B1_ESPVEND    := ''
    ::B1_QE         := 0
    ::B1_IPI        := 0
Return


Class ObjCliJson
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

Method New() Class ObjCliJson
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

Class ObjPrc
    Data DA0_YCODCL_DA0_YLJCLI
    Data DA0_DESCRI
    Data DA1_CODPRO
    Data DA1_DESCRI
    Data DA1_PRNET
    Data DA1_YICMS
    Data DA1_YIPI
    Data DA1_YCOFIN
    Data DA1_YPIS
    Data DA1_MOEDA


    Method New() CONSTRUCTOR
EndClass

Method New() Class ObjPrc
    ::DA0_YCODCL_DA0_YLJCLI     := ''
    ::DA0_DESCRI                := ''
    ::DA1_CODPRO                := ''
    ::DA1_DESCRI                := ''
    ::DA1_PRNET                 := 0
    ::DA1_YICMS                 := ''
    ::DA1_YIPI                  := ''
    ::DA1_YCOFIN                := ''
    ::DA1_YPIS                  := ''
    ::DA1_MOEDA                 := ''
Return
