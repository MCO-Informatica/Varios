#include "Protheus.ch"
#include "Fileio.ch"
#include "mapaspf.ch"

#DEFINE TPR_POS 1
#DEFINE TPC_POS 2
#DEFINE TSC_POS 3
#DEFINE TRC_POS 4
#DEFINE TRS_POS 5
#DEFINE TRB_POS 6
#DEFINE MVN_POS 7
#DEFINE TMM_POS 8
#DEFINE TMT_POS 9
#DEFINE TUP_POS 10
#DEFINE TUF_POS 11
#DEFINE TUC_POS 12
#DEFINE TFB_POS 13
#DEFINE TTN_POS 14
#DEFINE TCC_POS 15
#DEFINE TTM_POS 16 

#DEFINE SUBSECTION_NAME_POS 1
#DEFINE REAL_NAME_POS 2
#DEFINE ALIAS_POS 3
#DEFINE OBJECT_POS 4

/*/{Protheus.doc} MAPASPF
    Classe para geração do Mapa de Controle de Produtos Químicos conforme Portaria nº 240 de 12 de Março de 2019.
    A nova legislação entra em vigor em 01/09/2019 conforme Portaria nº 577 de 05 de Junho de 2019.
    @type  CLASS
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.in.gov.br/materia/-/asset_publisher/Kujrw0TZC2Mb/content/id/66952742/do1-2019-03-14-portaria-n-240-de-12-de-marco-de-2019-66952457)
/*/
CLASS MAPAIMCD

    DATA dDataDe as Date
    DATA dDataAte as Date
    DATA cGrupoDe as String
    DATA cGrupoAte as String
    DATA cProdDe as String
    DATA cProdAte as String
    DATA nProcFil as Integer
    DATA cCnpjFil as String
    DATA cFilRazSoc as String
    DATA lConfigOk as Boolean
    DATA cFilSB1 as String
    DATA cFilSB5 as String
    DATA cFilSG1 as String
    DATA cFilSGG as String
    DATA cFilSD3 as String
    DATA cFilSD1 as String
    DATA cFilSD2 as String
    DATA cFilSF4 as String
    DATA cFilSF1 as String
    DATA cFilSF2 as String
    DATA cSqlNameB1 as String
    DATA cSqlNameB5 as String
    DATA cSqlNameG1 as String
    DATA cSqlNameGG as String
    DATA cSqlNameD3 as String
    DATA cSqlNameD1 as String
    DATA cSqlNameD2 as String
    DATA cSqlNameF4 as String
    DATA cSqlNameF1 as String
    DATA cSqlNameF2 as String
    DATA nTamB1Cod as Integer
    DATA nTamF1Doc as Integer
    DATA nTamF1Seri as Integer
    DATA nTamF1Forn as Integer
    DATA nTamF1Loja as Integer
    DATA nTamD3Seq as Integer
    DATA nTamF5Cod as Integer
    DATA nTamD3Op as Integer
    DATA cNcmPic as String
    DATA cProdPF as String
    DATA cCodMapas as String
    DATA cDescPR as String
    DATA cGrupRes as String
    DATA cPFCompo as string
    DATA cPicQuant as String
    DATA lExistDesc as Boolean
    DATA lPFCompo as Boolean
    DATA lMVN as Boolean
    DATA lUP as Boolean
    DATA lUC as Boolean
    DATA lFB as Boolean
    DATA lTN as Boolean
    DATA lUMSet as Boolean
    DATA cCpoUN as String
    DATA cCpoFator as String
    DATA cCpoTpFator as String
    DATA cMapVII as String
    DATA lMapVII as Boolean
    DATA lMvAglut as Boolean
    DATA cDescProd as String
    DATA lDescProd as Boolean

    DATA aTrab
    DATA aModaisSF1
    DATA aModaisSC5

    METHOD New(dDataDe, dDataAte, cGrupoDe, cGrupoAte, cProdDe, cProdAte, nProcFil, cCnpjFil,lReceb) CONSTRUCTOR
    METHOD SetTrabArr()
    METHOD CriaMapTPR()
    METHOD CriaMapTPC()
    METHOD CriaMapTSC()
    METHOD CriaMapTRC()
    METHOD CriaMapTRS()
    METHOD CriaMapTRB()
    METHOD CriaMapMVN()
    METHOD CriaMapTMM()
    METHOD CriaMapTMT()
    METHOD CriaMapTUP()
    METHOD CriaMapTUF()
    METHOD CriaMapTUC()
    METHOD CriaMapTFB()
    METHOD CriaMapTTN()
    METHOD CriaMapTCC()
    METHOD CriaMapTTM()
    METHOD SetMapa()
    METHOD SubSecPRRC(aTrabPR)
    METHOD SubSecComp(aTrabPC, aTrabSC, aTrabRS, aTrabRB)
    METHOD ProcessMov()
    METHOD ProcesProd()
    METHOD ProcessaUC()
    METHOD ProcessFab()
    METHOD GravaMVN(aRecMVN, aRecMM, aRecMT)
    METHOD GravaTN(aRecTN, aRecCC, aRecTM)
    METHOD FirstUpper(cPar)
    METHOD GeraTXT(cArqDest, cDir)
    METHOD TxtSecDG(nHandle)
    METHOD TxtSecMVN(nHandle)
    METHOD TxtSecUP(nHandle)
    METHOD TxtSecUC(nHandle)
    METHOD TxtSecFB(nHandle)
    METHOD TxtSecTN(nHandle)
    METHOD NomeMes()
    METHOD ConvUMMAPA(nValor, nFatConv, cTpFatorConv)
    METHOD GetModalCod(cEntSai, cCod)
    METHOD Destructor()

ENDCLASS

/*/{Protheus.doc} MAPAIMCD
    Método Construtor. Concentrará todas as informações pertinentes a uma filial, para que sejam acessadas pelos demais métodos.
    Tem como principal objetivo otimizar processamento com funções de acesso ao Dicionário de Dados.
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.in.gov.br/materia/-/asset_publisher/Kujrw0TZC2Mb/content/id/66952742/do1-2019-03-14-portaria-n-240-de-12-de-marco-de-2019-66952457)
/*/
METHOD New(dDataDe, dDataAte, cGrupoDe, cGrupoAte, cProdDe, cProdAte, nProcFil, cCnpjFil,lReceb) CLASS MAPAIMCD

    Local lHasMinCps := .F.
    Local lProdPF := .F.
    Local lCodMapas := .F.
    Local cMVCPOMAPA:= SuperGetMv("MV_CPOMAPA", .F., "")
    Local nPos := 0
    Local nPosFinal := 0
    Local cF1Modal := GetSx3Cache('F1_MODAL', 'X3_CBOX')
    Local aOptions := Strtokarr2(cF1Modal, ';')
    Local aModaisF1 := {}
    Local nX := 0

    For nX := 1 To Len(aOptions)

        Aadd(aModaisF1, Strtokarr2(aOptions[nX], '='))

    Next

    ::aModaisSF1 := aModaisF1
    ::aModaisSC5 := FWGetSX5('HA')
    ::dDataDe := dDataDe
    ::dDataAte := dDataAte
    ::cGrupoDe := cGrupoDe
    ::cGrupoAte := cGrupoAte
    ::cProdDe := cProdDe
    ::cProdAte := cProdAte
    ::nProcFil := nProcFil
    ::cCnpjFil := cCnpjFil
    ::cFilRazSoc := FWFilRazSocial()
    ::cFilSB1 := FWxFilial("SB1")
    ::cFilSB5 := FWxFilial("SB5")
    ::cFilSG1 := FWxFilial("SG1")
    ::cFilSGG := FWxFilial("SGG")
    ::cFilSD3 := FWxFilial("SD3")
    ::cFilSD1 := FWxFilial("SD1")
    ::cFilSD2 := FWxFilial("SD2")
    ::cFilSF4 := FWxFilial("SF4")
    ::cFilSF1 := FWxFilial("SF1")
    ::cFilSF2 := FWxFilial("SF2")
    ::cSqlNameB1 := RetSqlName("SB1")
    ::cSqlNameB5 := RetSqlName("SB5")
    ::cSqlNameG1 := RetSqlName("SG1")
    ::cSqlNameGG := RetSqlName("SGG")
    ::cSqlNameD3 := RetSqlName("SD3")
    ::cSqlNameD1 := RetSqlName("SD1")
    ::cSqlNameD2 := RetSqlName("SD2")
    ::cSqlNameF4 := RetSqlName("SF4")
    ::cSqlNameF1 := RetSqlName("SF1")
    ::cSqlNameF2 := RetSqlName("SF2")
    ::nTamB1Cod := TamSx3("B1_COD")[01]
    ::nTamF1Doc := TamSx3("F1_DOC")[01]
    ::nTamF1Seri := TamSx3("F1_SERIE")[01]
    ::nTamF1Forn := TamSx3("F1_FORNECE")[01]
    ::nTamF1Loja := TamSx3("F1_LOJA")[01]
    ::nTamD3Seq := TamSx3("D3_NUMSEQ")[01]
    ::nTamF5Cod := TamSx3("F5_CODIGO")[01]
    ::nTamD3Op := TamSx3("D3_OP")[01]
    ::cNcmPic := X3Picture("B1_POSIPI")
    ::cGrupRes := Left(SuperGetMv('MV_GRUPRES', .F., ""), TamSx3('B1_GRUPO')[1])
    ::cProdPF := SuperGetMv('MV_PRODPF', .F., "B5_PRODPF")
    ::cCodMapas := SuperGetMv('MV_CODMAPA', .F., "B5_CODMAPA")
    ::cDescPR := SuperGetMv('MV_DESCPR', .F., "B5_DESCPR")
    ::cPFCompo := SuperGetMv('MV_PFCOMPO', .F., "B5_PFCOMPO")
    ::cPicQuant := "@E 999,999,999.999" 
    ::lPFCompo := !Empty(::cPFCompo) .And. SB5->(COLUMNPOS(::cPFCompo)) > 0
    ::lExistDesc := !Empty(::cDescPR) .And. SB5->(COLUMNPOS(::cDescPR)) > 0
    ::aTrab := {}
    ::lMVN := .F.
    ::lUP := .F.
    ::lUC := .F.
    ::lFB := .F.
    ::lTN := .F.
    ::cCpoUN := ""
    ::cCpoFator := ""
    ::cCpoTpFator := ""
    ::cMapVII := SuperGetMv("MV_MAPIV",.F.,"")
    ::lMapVII := !Empty(::cMapVII) .And. SB5->(FieldPos(::cMapVII)) > 0
    ::lMvAglut := SuperGetMv("MV_AGLUTPR",.F.,.F.)
    ::cDescProd := SuperGetMv("MV_DESCPRO", .F., "")
    ::lDescProd := !Empty(::cDescProd) .And. SF5->(COLUMNPOS(::cDescProd)) > 0

    If !Empty(cMVCPOMAPA)

        nPos := 01
        
        nPosFinal   := AT('/',Alltrim(cMVCPOMAPA))
        
        ::cCpoUn    := Substr(cMVCPOMAPA,nPos,nPosFinal - 1)
        
        nPos        := nPos + nPosFinal
        
        nPosFinal   := AT('/',Alltrim(Substr(cMVCPOMAPA,nPos,Len(Alltrim(cMVCPOMAPA)))))
        
        ::cCpoFator := Substr(cMVCPOMAPA,nPos,nPosFinal - 1)
        
        nPos        := nPos + nPosFinal
        
        nPosFinal   := AT('/',Alltrim(Substr(cMVCPOMAPA,nPos,Len(Alltrim(cMVCPOMAPA)))))
        
        If nPosFinal == 0
        
            ::cCpoTpFator := Substr(cMVCPOMAPA,nPos,Len(Alltrim(cMVCPOMAPA)))
        
        Else
        
            ::cCpoTpFator := Substr(cMVCPOMAPA,nPos,nPosFinal - 1)
        
        EndIf
    
    EndIf

    If !Empty(::cCpoUN) .And. SB5->(COLUMNPOS(::cCpoUN)) > 0 .And. !Empty(::cCpoFator) ;
        .And. SB5->(COLUMNPOS(::cCpoFator)) > 0 .And. !Empty(::cCpoTpFator) .And. SB5->(COLUMNPOS(::cCpoTpFator)) > 0
    
        ::lUMSet := .T.
    
    Else

        ::lUMSet := .F.

    EndIf

    lHasMinCps := SB5->(COLUMNPOS("B5_CONCENT")) > 0 .And. SB5->(COLUMNPOS("B5_DENSID")) > 0

    lProdPF := !Empty(::cProdPF) .And. SB5->(COLUMNPOS(::cProdPF)) > 0
    lCodMapas := !Empty(::cCodMapas) .And. SB5->(COLUMNPOS(::cCodMapas)) > 0

    ::lConfigOk := lHasMinCps .And. lProdPF .And. lCodMapas

    If ::lConfigOk

        ::SetTrabArr()
        ::SetMapa(lReceb)
    
    Else

        Help(,,"NOCONFIG",,STR0001, 1, 0)

    EndIf

Return self

/*/{Protheus.doc} SetTrabArr
    Método para criação das tabelas temporárias que compõem a estrutura a ser utilizada para geração do arquivo TXT ou para geração de Relatório
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD SetTrabArr() CLASS MAPAIMCD

    Local aTemp := {}
    Local aRet := {}

    // NÃO ALTERAR A ORDEM DO PROCESSAMENTO

    // Criação da Tabela Temporária TPR
    aTemp := ::CriaMapTPR()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TPC
    aTemp := ::CriaMapTPC()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TSC
    aTemp := ::CriaMapTSC()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TRC
    aTemp := ::CriaMapTRC()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TRS
    aTemp := ::CriaMapTRS()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TRB
    aTemp := ::CriaMapTRB()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária MVN
    aTemp := ::CriaMapMVN()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TMM
    aTemp := ::CriaMapTMM()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TMT
    aTemp := ::CriaMapTMT()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TUP
    aTemp := ::CriaMapTUP()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TUF
    aTemp := ::CriaMapTUF()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TUC
    aTemp := ::CriaMapTUC()
    Aadd(aRet, aTemp)
    
    // Criação da Tabela Temporária TFB
    aTemp := ::CriaMapTFB()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TTN
    aTemp := ::CriaMapTTN()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TCC
    aTemp := ::CriaMapTCC()
    Aadd(aRet, aTemp)

    // Criação da Tabela Temporária TTM
    aTemp := ::CriaMapTTM()
    Aadd(aRet, aTemp)

    ::aTrab := aRet

Return

/*/{Protheus.doc} CriaMapTPR
    Método para criação da tabela temporária TPR, para os Produtos Controlados (Subseção PR)
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTPR() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTPR
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"    , "C", ::nTamB1Cod, 0})
    Aadd(aStru, {"TIPO"   , "C",  2, 0}) // "PR"
    Aadd(aStru, {"CODNCM" , "C", 11, 0}) 
    Aadd(aStru, {"NOMECOM", "C", 70, 0}) 
    Aadd(aStru, {"CONCENT", "N",  3, 0}) 
    Aadd(aStru, {"DENSID" , "N",  5, 2}) 

    oTmpTblTPR := FWTemporaryTable():New(cAlias)
    oTmpTblTPR:SetFields( aStru )
    oTmpTblTPR:AddIndex('I1', {"COD"})
    oTmpTblTPR:AddIndex('I2', {"CODNCM", "CONCENT", "DENSID"})
    oTmpTblTPR:Create()

    aRet := { "PR", oTmpTblTPR:GetRealName(), oTmpTblTPR:GetAlias(), oTmpTblTPR }

Return aRet

/*/{Protheus.doc} CriaMapTPC
    Método para criação da tabela temporária TPC, para os Produtos Compostos de Substâncias Controladas (Subseção PC)
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTPC() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTPC
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"    , "C", ::nTamB1Cod, 0}) // "B1_COD" (Faz relação com o campo CODPAI da tabela TSC)
    Aadd(aStru, {"TIPO"   , "C",  2, 0}) // "PC"
    Aadd(aStru, {"NCMCOM" , "C", 10, 0}) 
    Aadd(aStru, {"NOMECOM", "C", 70, 0}) 
    Aadd(aStru, {"DENSID" , "N",  5, 2}) 

    oTmpTblTPC := FWTemporaryTable():New(cAlias)
    oTmpTblTPC:SetFields( aStru )
    oTmpTblTPC:AddIndex('I1', {"COD"}) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TSC
    oTmpTblTPC:Create()

    aRet := { "PC", oTmpTblTPC:GetRealName(), oTmpTblTPC:GetAlias(), oTmpTblTPC }

Return aRet

/*/{Protheus.doc} CriaMapTSC
    Método para criação da tabela temporária TSC, para as Substâncias Controladas que compõem o Produto Composto (Subseção SC)
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTSC() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTSC
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"CODPAI" , "C", ::nTamB1Cod, 0}) // "B1_COD" (Faz relação com o campo COD da tabela TPC)
    Aadd(aStru, {"COD"    , "C", ::nTamB1Cod, 0})
    Aadd(aStru, {"TIPO"   , "C",  2, 0}) // "SC"
    Aadd(aStru, {"CODNCM" , "C", 11, 0}) 
    Aadd(aStru, {"CONCENT", "N",  2, 0}) 

    oTmpTblTSC := FWTemporaryTable():New(cAlias)
    oTmpTblTSC:SetFields( aStru )
    oTmpTblTSC:AddIndex('I1', { "CODPAI", "COD" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TPC
    oTmpTblTSC:AddIndex('I2', { "CODPAI", "CODNCM", "CONCENT" })
    oTmpTblTSC:Create()

    aRet := { "SC", oTmpTblTSC:GetRealName(), oTmpTblTSC:GetAlias(), oTmpTblTSC }

Return aRet

/*/{Protheus.doc} CriaMapTRC
    Método para criação da tabela temporária TRC, para os Resíduos Controlados (Subseção RC)
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTRC() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTRC
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"    , "C", ::nTamB1Cod, 0})
    Aadd(aStru, {"TIPO"   , "C",  2, 0}) // "RC"
    Aadd(aStru, {"CODNCM" , "C", 11, 0}) 
    Aadd(aStru, {"NOMECOM", "C", 70, 0}) 
    Aadd(aStru, {"CONCENT", "N",  3, 0}) 
    Aadd(aStru, {"DENSID" , "N",  5, 2}) 

    oTmpTblTRC := FWTemporaryTable():New(cAlias)
    oTmpTblTRC:SetFields( aStru )
    oTmpTblTRC:AddIndex('I1', {"COD"})
    oTmpTblTRC:AddIndex('I2', {"CODNCM", "CONCENT", "DENSID"})
    oTmpTblTRC:Create()

    aRet := { "RC", oTmpTblTRC:GetRealName(), oTmpTblTRC:GetAlias(), oTmpTblTRC }

Return aRet

/*/{Protheus.doc} CriaMapTRS
    Método para criação da tabela temporária TRS, para os Resíduos Compostos de Substâncias Controladas (Subseção RS)
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTRS() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTRS
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"    , "C", ::nTamB1Cod, 0}) // "B1_COD" (Faz relação com a tabela CODPAI da tabela TRB)
    Aadd(aStru, {"TIPO"   , "C",  2, 0}) // "RS"
    Aadd(aStru, {"NCMCOM" , "C", 10, 0})
    Aadd(aStru, {"NOMECOM", "C", 70, 0}) 
    Aadd(aStru, {"DENSID" , "N",  5, 2}) 

    oTmpTblTRS := FWTemporaryTable():New(cAlias)
    oTmpTblTRS:SetFields( aStru )
    oTmpTblTRS:AddIndex('I1', {"COD"}) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TRB
    oTmpTblTRS:Create()

    aRet := { "RS", oTmpTblTRS:GetRealName(), oTmpTblTRS:GetAlias(), oTmpTblTRS }

Return aRet

/*/{Protheus.doc} CriaMapTRB
    Método para criação da tabela temporária TRB, para as Substâncias Controladas que compõem o Resíduo Composto (Subseção RB)
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTRB() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTRB
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"CODPAI" , "C", ::nTamB1Cod, 0}) // "B1_COD" (Faz relação com o campo COD da tabela TRS)
    Aadd(aStru, {"COD"    , "C", ::nTamB1Cod, 0})
    Aadd(aStru, {"TIPO"   , "C",  2, 0}) // "RB"
    Aadd(aStru, {"CODNCM" , "C", 11, 0}) 
    Aadd(aStru, {"CONCENT", "N",  2, 0}) 

    oTmpTblTRB := FWTemporaryTable():New(cAlias)
    oTmpTblTRB:SetFields( aStru )
    oTmpTblTRB:AddIndex('I1', { "CODPAI", "COD" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TRS
    oTmpTblTRB:AddIndex('I2', { "CODPAI", "CODNCM", "CONCENT" })
    oTmpTblTRB:Create()

    aRet := { "RB", oTmpTblTRB:GetRealName(), oTmpTblTRB:GetAlias(), oTmpTblTRB }

Return aRet

/*/{Protheus.doc} CriaMapMVN
    Método para criação da tabela temporária MVN, para as operações de Entrada e Saída
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapMVN() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblMVN
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"NUMDOC"     , "C"   , ::nTamF1Doc,  0}) // Campo para relacionamento com tabelas TMM e TMT
    Aadd(aStru, {"SERIE"      , "C"   , ::nTamF1Seri, 0}) // Campo para relacionamento com tabelas TMM e TMT
    Aadd(aStru, {"CLIFOR"     , "C"   , ::nTamF1Forn, 0}) // Campo para relacionamento com tabelas TMM e TMT
    Aadd(aStru, {"LOJA"       , "C"   , ::nTamF1Loja, 0}) // Campo para relacionamento com tabelas TMM e TMT
    Aadd(aStru, {"TIPO"       , "C"   , 3 , 0}) // "MVN"
    Aadd(aStru, {"ENTSAI"     , "C"   , 1 , 0}) // "E" ou "S"
    Aadd(aStru, {"OPERACAO"   , "C"   , 2 , 0})
    Aadd(aStru, {"CNPJ"       , "C"   , 14, 0})
    Aadd(aStru, {"RAZAOSOC"   , "C"   , 69, 0})
    Aadd(aStru, {"NUMERONF"   , "C"   , 10, 0})
    Aadd(aStru, {"EMISSAONF"  , "D"   ,  8, 0})
    Aadd(aStru, {"ARMAZENAG"  , "C"   ,  1, 0})
    Aadd(aStru, {"TRANSPORT"  , "C"   ,  1, 0})

    oTmpTblMVN := FWTemporaryTable():New(cAlias)
    oTmpTblMVN:SetFields( aStru )
    oTmpTblMVN:AddIndex('I1', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI", "OPERACAO" }) // Tomar cuidado pois o índice declarado estabelece relação com as tabelas TMM e TMT
    oTmpTblMVN:Create()

    aRet := { "MVN", oTmpTblMVN:GetRealName(), oTmpTblMVN:GetAlias(), oTmpTblMVN }

Return aRet

/*/{Protheus.doc} CriaMapTMM
    Método para criação da tabela temporária TMM, referente aos itens da operação de Entrada e Saída descrita em MVN
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTMM() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTMM
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"NUMDOC"     , "C"   , ::nTamF1Doc,  0}) // Campo para relacionamento com tabelas MVN e TMT
    Aadd(aStru, {"SERIE"      , "C"   , ::nTamF1Seri, 0}) // Campo para relacionamento com tabelas MVN e TMT
    Aadd(aStru, {"CLIFOR"     , "C"   , ::nTamF1Forn, 0}) // Campo para relacionamento com tabelas MVN e TMT
    Aadd(aStru, {"LOJA"       , "C"   , ::nTamF1Loja, 0}) // Campo para relacionamento com tabelas MVN e TMT
    Aadd(aStru, {"ENTSAI"     , "C"   ,  1, 0}) // "E" ou "S"
    Aadd(aStru, {"OPERACAO"   , "C"   , 2 , 0})
    Aadd(aStru, {"COD"        , "C"   , ::nTamB1Cod, 0}) // Apenas informativo, não será impresso no arquivo magnético
    Aadd(aStru, {"TIPO"       , "C"   ,  2, 0}) // "MM"
    Aadd(aStru, {"CODNCM"     , "C"   , 13, 0}) 
    Aadd(aStru, {"CONCENT"    , "N"   ,  3, 0}) 
    Aadd(aStru, {"DENSID"     , "N"   ,  5, 2})
    Aadd(aStru, {"QUANT"      , "N"   , 13, 3})
    Aadd(aStru, {"UM"         , "C"   ,  1, 0})

    oTmpTblTMM := FWTemporaryTable():New(cAlias)
    oTmpTblTMM:SetFields( aStru )
    oTmpTblTMM:AddIndex('I1', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI", "OPERACAO" }) // Tomar cuidado pois o índice declarado estabelece relação com as tabelas MVN e TMT
    oTmpTblTMM:AddIndex('I2', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI", "OPERACAO", "CODNCM", "CONCENT", "DENSID", "UM" })
    oTmpTblTMM:Create()

    aRet := { "MM", oTmpTblTMM:GetRealName(), oTmpTblTMM:GetAlias(), oTmpTblTMM }

Return aRet

/*/{Protheus.doc} CriaMapTMT
    Método para criação da tabela temporária TMT, referente à transportadora terceira da operação de Entrada/Saída descrita em MVN
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTMT() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTMT
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"NUMDOC"     , "C"   , ::nTamF1Doc,  0}) // Campo para relacionamento com tabelas MVN e TMM
    Aadd(aStru, {"SERIE"      , "C"   , ::nTamF1Seri, 0}) // Campo para relacionamento com tabelas MVN e TMM
    Aadd(aStru, {"CLIFOR"     , "C"   , ::nTamF1Forn, 0}) // Campo para relacionamento com tabelas MVN e TMM
    Aadd(aStru, {"LOJA"       , "C"   , ::nTamF1Loja, 0}) // Campo para relacionamento com tabelas MVN e TMM
    Aadd(aStru, {"ENTSAI"     , "C"   ,  1, 0}) // "E" ou "S"
    Aadd(aStru, {"OPERACAO"   , "C"   , 2 , 0})
    Aadd(aStru, {"TIPO"       , "C"   ,  2, 0}) // "MM"
    Aadd(aStru, {"CNPJ"       , "C"   , 14, 0}) 
    Aadd(aStru, {"RAZSOC"     , "C"   , 70, 0}) 

    oTmpTblTMT := FWTemporaryTable():New(cAlias)
    oTmpTblTMT:SetFields( aStru )
    oTmpTblTMT:AddIndex('I1', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI", "OPERACAO" }) // Tomar cuidado pois o índice declarado estabelece relação com as tabelas MVN e TMM
    oTmpTblTMT:Create()

    aRet := { "MT", oTmpTblTMT:GetRealName(), oTmpTblTMT:GetAlias(), oTmpTblTMT }

Return aRet

/*/{Protheus.doc} CriaMapTUP
    Método para criação da tabela temporária TUP, referente aos produtos químicos controlados consumidos para produção de produto químico controlado
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTUP() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTUP
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"        , "C"   , ::nTamB1Cod, 0}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"CODPAI"     , "C"   , ::nTamB1Cod, 0}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"CODNCMPAI"  , "C"   , 13, 0}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"CONCENTPAI" , "N"   ,  3, 0}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"DENSIDPAI"  , "N"   ,  5, 2}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"UMPAI"      , "C"   ,  1, 0}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"NUMSEQ"     , "C"   , ::nTamD3Seq, 0}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"TM"         , "C"   , ::nTamF5Cod, 0}) // Campo para relacionamento com tabela TUF
    Aadd(aStru, {"TIPO"       , "C"   ,  2, 0}) // "UP"
    Aadd(aStru, {"CODNCM"     , "C"   , 13, 0}) 
    Aadd(aStru, {"CONCENT"    , "N"   ,  3, 0})
    Aadd(aStru, {"DENSID"     , "N"   ,  5, 2})
    Aadd(aStru, {"QUANT"      , "N"   , 13, 3})
    Aadd(aStru, {"UM"         , "C"   ,  1, 0})
    Aadd(aStru, {"EMISSAO"    , "D"   ,  8, 0})

    oTmpTblTUP := FWTemporaryTable():New(cAlias)
    oTmpTblTUP:SetFields( aStru )
    oTmpTblTUP:AddIndex('I1', { "EMISSAO", "CODPAI", "TM", "COD" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TUF
    oTmpTblTUP:AddIndex('I2', { "EMISSAO", "NUMSEQ", "COD" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TUF
    oTmpTblTUP:AddIndex('I3', { "EMISSAO", "CODNCMPAI", "CONCENTPAI", "DENSIDPAI", "UMPAI", "TM", "CODNCM", "CONCENT", "DENSID", "UM" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TUF
    oTmpTblTUP:Create()

    aRet := { "UP", oTmpTblTUP:GetRealName(), oTmpTblTUP:GetAlias(), oTmpTblTUP }

Return aRet

/*/{Protheus.doc} CriaMapTUF
    Método para criação da tabela temporária TUF, referente aos produtos químicos controlados produzidos
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTUF() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTUF
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"        , "C"   , ::nTamB1Cod, 0})
    Aadd(aStru, {"NUMSEQ"     , "C"   , ::nTamD3Seq, 0})
    Aadd(aStru, {"TM"         , "C"   , ::nTamF5Cod, 0})
    Aadd(aStru, {"TIPO"       , "C"   ,   2, 0}) // "UF"
    Aadd(aStru, {"CODNCM"     , "C"   ,  13, 0}) 
    Aadd(aStru, {"CONCENT"    , "N"   ,   3, 0})
    Aadd(aStru, {"DENSID"     , "N"   ,   5, 2})
    Aadd(aStru, {"QUANT"      , "N"   ,  13, 3})
    Aadd(aStru, {"UM"         , "C"   ,   1, 0})
    Aadd(aStru, {"DESCPROD"   , "C"   , 200, 0})
    Aadd(aStru, {"EMISSAO"    , "D"   ,   8, 0})

    oTmpTblTUF := FWTemporaryTable():New(cAlias)
    oTmpTblTUF:SetFields( aStru )
    oTmpTblTUF:AddIndex('I1', { "EMISSAO", "COD", "TM" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TUP
    oTmpTblTUF:AddIndex('I2', { "EMISSAO", "NUMSEQ" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TUP
    oTmpTblTUF:AddIndex('I3', { "EMISSAO", "CODNCM", "CONCENT", "DENSID", "UM", "TM" }) // Tomar cuidado pois o índice declarado estabelece relação com a tabela TUP
    oTmpTblTUF:Create()

    aRet := { "UF", oTmpTblTUF:GetRealName(), oTmpTblTUF:GetAlias(), oTmpTblTUF }

Return aRet

/*/{Protheus.doc} CriaMapTUF
    Método para criação da tabela temporária TUC, referente aos consumos gerais de produtos químicos
    No momento, somente consumo para processo produtivo é coberto pelo novo MAPAS
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTUC() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTUC
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"        , "C"   , ::nTamB1Cod, 0})
    Aadd(aStru, {"NUMSEQ"     , "C"   , ::nTamD3Seq, 0})
    Aadd(aStru, {"TM"         , "C"   , ::nTamF5Cod, 0})
    Aadd(aStru, {"TIPO"       , "C"   ,   2, 0}) // "UC"
    Aadd(aStru, {"CODNCM"     , "C"   ,  13, 0}) 
    Aadd(aStru, {"CONCENT"    , "N"   ,   3, 0})
    Aadd(aStru, {"DENSID"     , "N"   ,   5, 2})
    Aadd(aStru, {"QUANT"      , "N"   ,  13, 3})
    Aadd(aStru, {"UM"         , "C"   ,   1, 0})
    Aadd(aStru, {"CODCONSUMO" , "N"   ,   1, 0})
    Aadd(aStru, {"OBSERVACAO" , "C"   ,  62, 0})
    Aadd(aStru, {"EMISSAO"    , "D"   ,   8, 0})

    oTmpTblTUC := FWTemporaryTable():New(cAlias)
    oTmpTblTUC:SetFields( aStru )
    oTmpTblTUC:AddIndex('I1', { "EMISSAO", "CODNCM", "CONCENT", "DENSID", "UM", "TM" })
    oTmpTblTUC:AddIndex('I2', { "EMISSAO", "NUMSEQ" })
    oTmpTblTUC:Create()

    aRet := { "UC", oTmpTblTUC:GetRealName(), oTmpTblTUC:GetAlias(), oTmpTblTUC }

Return aRet

/*/{Protheus.doc} CriaMapTFB
    Método para criação da tabela temporária TUC, referente aos produtos químicos controlados fabricados
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTFB() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTFB
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"COD"        , "C"   , ::nTamB1Cod, 0})
    Aadd(aStru, {"NUMSEQ"     , "C"   , ::nTamD3Seq, 0})
    Aadd(aStru, {"TIPO"       , "C"   ,   2, 0}) // "FB"
    Aadd(aStru, {"CODNCM"     , "C"   ,  13, 0}) 
    Aadd(aStru, {"CONCENT"    , "N"   ,   3, 0})
    Aadd(aStru, {"DENSID"     , "N"   ,   5, 2})
    Aadd(aStru, {"QUANT"      , "N"   ,  13, 3})
    Aadd(aStru, {"UM"         , "C"   ,   1, 0})
    Aadd(aStru, {"EMISSAO"    , "D"   ,   8, 0})

    oTmpTblTFB := FWTemporaryTable():New(cAlias)
    oTmpTblTFB:SetFields( aStru )
    oTmpTblTFB:AddIndex('I1', { "EMISSAO", "CODNCM", "CONCENT", "DENSID", "UM" })
    oTmpTblTFB:AddIndex('I2', { "EMISSAO", "NUMSEQ" })
    oTmpTblTFB:Create()

    aRet := { "FB", oTmpTblTFB:GetRealName(), oTmpTblTFB:GetAlias(), oTmpTblTFB }

Return aRet

/*/{Protheus.doc} CriaMapTTN
    Método para criação da tabela temporária TTN, referente às operações de transporte realizadas pela filial
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTTN() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTTN
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"NUMDOC"     , "C"   , ::nTamF1Doc, 0}) // Campo para relacionamento
    Aadd(aStru, {"SERIE"      , "C"   , ::nTamF1Seri, 0}) // Campo para relacionamento
    Aadd(aStru, {"CLIFOR"     , "C"   , ::nTamF1Forn, 0}) // Campo para relacionamento
    Aadd(aStru, {"LOJA"       , "C"   , ::nTamF1Loja, 0}) // Campo para relacionamento
    Aadd(aStru, {"ENTSAI"     , "C"   ,  1 , 0}) // "E" ou "S" - Campo para relacionamento
    Aadd(aStru, {"TIPO"       , "C"   ,   2, 0}) // "TN"
    Aadd(aStru, {"CGCCONTRAT" , "C"   ,  14, 0}) 
    Aadd(aStru, {"NOMECONTRA" , "C"   ,  70, 0})
    Aadd(aStru, {"NUMERONF"   , "C"   ,  10, 0})
    Aadd(aStru, {"EMISSAONF"  , "D"   ,   8, 0})
    Aadd(aStru, {"CGCORIGEM"  , "C"   ,  14, 0})
    Aadd(aStru, {"NOMEORIGEM" , "C"   ,  70, 0})
    Aadd(aStru, {"RETIRADA"   , "C"   ,   1, 0})
    Aadd(aStru, {"ENTREGA"    , "C"   ,   1, 0})

    oTmpTblTTN := FWTemporaryTable():New(cAlias)
    oTmpTblTTN:SetFields( aStru )
    oTmpTblTTN:AddIndex('I1', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI" }) // Tomar cuidado pois o índice declarado estabelece relação com as tabelas TCC e TTM
    oTmpTblTTN:Create()

    aRet := { "TN", oTmpTblTTN:GetRealName(), oTmpTblTTN:GetAlias(), oTmpTblTTN }

Return aRet

/*/{Protheus.doc} CriaMapTCC
    Método para criação da tabela temporária TCC, referente às informações do conhecimento de carga das operações de transporte descritas em TTN
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTCC() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTCC
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"NUMDOC"     , "C"   , ::nTamF1Doc, 0}) // Campo para relacionamento
    Aadd(aStru, {"SERIE"      , "C"   , ::nTamF1Seri, 0}) // Campo para relacionamento
    Aadd(aStru, {"CLIFOR"     , "C"   , ::nTamF1Forn, 0}) // Campo para relacionamento
    Aadd(aStru, {"LOJA"       , "C"   , ::nTamF1Loja, 0}) // Campo para relacionamento
    Aadd(aStru, {"ENTSAI"     , "C"   ,   1, 0}) // "E" ou "S" - Campo para relacionamento
    Aadd(aStru, {"TIPO"       , "C"   ,   2, 0}) // "CC"
    Aadd(aStru, {"NUMCC"      , "C"   ,   9, 0}) 
    Aadd(aStru, {"DATACC"     , "D"   ,   8, 0})
    Aadd(aStru, {"DATARECEB"  , "D"   ,   8, 0})
    Aadd(aStru, {"RESPRECEB"  , "C"   ,  70, 0})
    Aadd(aStru, {"MODALTRANS" , "C"   ,   8, 0})
    
    oTmpTblTCC := FWTemporaryTable():New(cAlias)
    oTmpTblTCC:SetFields( aStru )
    oTmpTblTCC:AddIndex('I1', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI" }) // Tomar cuidado pois o índice declarado estabelece relação com as tabelas TTN e TTM
    oTmpTblTCC:Create()

    aRet := { "CC", oTmpTblTCC:GetRealName(), oTmpTblTCC:GetAlias(), oTmpTblTCC }

Return aRet

/*/{Protheus.doc} CriaMapTTM
    Método para criação da tabela temporária TTM, referente aos itens transportados nas operações de transporte descritas em TTN
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD CriaMapTTM() CLASS MAPAIMCD

    Local aStru := {}
    Local aRet := {}
    Local oTmpTblTTM
    Local cAlias := GetNextAlias()

    Aadd(aStru, {"NUMDOC"     , "C"   , ::nTamF1Doc, 0}) // Campo para relacionamento
    Aadd(aStru, {"SERIE"      , "C"   , ::nTamF1Seri, 0}) // Campo para relacionamento
    Aadd(aStru, {"CLIFOR"     , "C"   , ::nTamF1Forn, 0}) // Campo para relacionamento
    Aadd(aStru, {"LOJA"       , "C"   , ::nTamF1Loja, 0}) // Campo para relacionamento
    Aadd(aStru, {"ENTSAI"     , "C"   ,  1 , 0}) // "E" ou "S" - Campo para relacionamento
    Aadd(aStru, {"COD"        , "C"   , ::nTamB1Cod, 0}) // Apenas informativo, não será impresso no arquivo magnético
    Aadd(aStru, {"TIPO"       , "C"   ,   2, 0}) // "TM" - Apenas informativo, não será impresso no arquivo magnético
    Aadd(aStru, {"CODNCM"     , "C"   ,  13, 0}) 
    Aadd(aStru, {"CONCENT"    , "N"   ,   3, 0})
    Aadd(aStru, {"DENSID"     , "N"   ,   5, 2})
    Aadd(aStru, {"QUANT"      , "N"   ,  13, 3})
    Aadd(aStru, {"UM"         , "C"   ,   1, 0})
    
    oTmpTblTTM := FWTemporaryTable():New(cAlias)
    oTmpTblTTM:SetFields( aStru )
    oTmpTblTTM:AddIndex('I1', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI" }) // Tomar cuidado pois o índice declarado estabelece relação com as tabelas TTN e TCC
    oTmpTblTTM:AddIndex('I2', { "NUMDOC", "SERIE", "CLIFOR", "LOJA", "ENTSAI", "CODNCM", "CONCENT", "DENSID", "UM" })
    oTmpTblTTM:Create()

    aRet := { "TM", oTmpTblTTM:GetRealName(), oTmpTblTTM:GetAlias(), oTmpTblTTM }

Return aRet

/*/{Protheus.doc} SetMapa
    Método que centraliza o preenchimento das tabelas temporárias referentes às subseções da seção DG 
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD SetMapa(lReceb) CLASS MAPAIMCD

    // Preenche TPR e TRC
    ::SubSecPRRC(::aTrab[TPR_POS], ::aTrab[TRC_POS])

    If ::lPFCompo
        // Preenche TPC e TSC, TRS e TRB
        ::SubSecComp(::aTrab[TPC_POS], ::aTrab[TSC_POS], ::aTrab[TRS_POS], ::aTrab[TRB_POS])
    EndIf

    //Preenche MVN, TMM e TMT; e TTN, TCC e TTM
    ::ProcessMov(lReceb)

    // Preenche TUP e TUF
    ::ProcesProd()

    // Preenche TUC
    ::ProcessaUC()

    // Preenche TFB
    ::ProcessFab()

Return

/*/{Protheus.doc} SubSecPRRC
    Método que preenche a tabela temporária referente às subseções PR e RC.
    Produtos Químicos Controlados e Resíduos Controlados.
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD SubSecPRRC(aTrabPR, aTrabRC) CLASS MAPAIMCD

    Local cQuery := ""
    Local cAliasPRRC := GetNextAlias()
    Local cAliasTPR := aTrabPR[ALIAS_POS]
    Local cAliasTRC := aTrabRC[ALIAS_POS]
    Local cCodNcm := ""
    Local nConcent := 0
    Local nDensid := 0

    If ::lMvAglut
        (cAliasTPR)->(dbSetOrder(2))
        (cAliasTRC)->(dbSetOrder(2))
    EndIf

    cQuery := "SELECT DISTINCT SB1.B1_COD AS COD, SB1.B1_POSIPI AS NCM, SB5.B5_CONCENT AS CONCENT, SB5.B5_DENSID AS DENSID, "
    
    If ::lExistDesc
        cQuery += "SB5." + ::cDescPR + " AS NOMECOM, "
    Else
        cQuery += "SB1.B1_DESC AS NOMECOM, "
    EndIf

    cQuery += "SB5." + ::cCodMapas + " AS CODMAPAS, "
    cQuery += "SB1.B1_GRUPO AS GRUPO "
    cQuery += "FROM " + ::cSqlNameB1 + " SB1 "
    cQuery += "JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SB1.B1_FILIAL = '" + ::cFilSB1 + "' AND "
    cQuery += "SB5.B5_FILIAL = '" + ::cFilSB5 +"' AND "
    cQuery += "SB1.B1_COD = SB5.B5_COD "

    If ::lPFCompo

        cQuery += "LEFT JOIN ( "
            //-- Query para buscar as estruturas da SG1 de produtos compostos controlados
            cQuery += "SELECT B1.B1_COD, G1.G1_COMP "
            cQuery += "FROM " + ::cSqlNameB1 + " B1 "
            cQuery += "JOIN " + ::cSqlNameB5 + " B5 "
            cQuery += "ON B1.B1_FILIAL = '" + ::cFilSB1 + "' AND "
            cQuery += "B5.B5_FILIAL = '" + ::cFilSB5 + "' AND "
            cQuery += "B1.B1_COD = B5.B5_COD "
            cQuery += "JOIN " + ::cSqlNameG1 + " G1 "
            cQuery += "ON G1.G1_FILIAL ='" + ::cFilSG1 + "' AND "
            cQuery += "G1.G1_COD = B1.B1_COD "
            cQuery += "WHERE B5." + ::cProdPF + " IN ('S', 's') AND "
            cQuery += "B5." + ::cPFCompo + " IN ('S', 's') AND "
            cQuery += "B1.D_E_L_E_T_ = ' ' AND B5.D_E_L_E_T_ = ' ' AND G1.D_E_L_E_T_ = ' ' "
        cQuery += ") G1 ON SB1.B1_COD = G1.G1_COMP LEFT JOIN ( "
            //-- Query para buscar as pré-estruturas da SGG de produtos compostos controlados
            cQuery += "SELECT B1.B1_COD, GG.GG_COMP "
            cQuery += "FROM " + ::cSqlNameB1 + " B1 "
            cQuery += "JOIN " + ::cSqlNameB5 + " B5 "
            cQuery += "ON B1.B1_FILIAL = '" + ::cFilSB1 + "' AND "
            cQuery += "B5.B5_FILIAL = '" + ::cFilSB5 + "' AND "
            cQuery += "B1.B1_COD = B5.B5_COD "
            cQuery += "JOIN " + ::cSqlNameGG + " GG "
            cQuery += "ON GG.GG_FILIAL = '" + ::cFilSGG + "' AND "
            cQuery += "GG.GG_COD = B1.B1_COD "
            cQuery += "WHERE B5." + ::cProdPF + " IN ('S', 's') AND "
            cQuery += "B5." + ::cPFCompo + " IN ('S', 's') AND "
            cQuery += "B1.D_E_L_E_T_ = ' ' AND B5.D_E_L_E_T_ = ' ' AND GG.D_E_L_E_T_ = ' ' "
        cQuery += ") GG ON SB1.B1_COD = GG.GG_COMP "

    EndIf

    cQuery += "WHERE SB5." + ::cProdPF + " IN ('S', 's') AND "
    
    If ::lPFCompo
        cQuery += "SB5." + ::cPFCompo + " IN ('N', 'n', ' ') AND "
        cQuery += "(G1.B1_COD IS NOT NULL OR (G1.B1_COD IS NULL AND GG.B1_COD IS NULL)) AND "
    EndIf

    cQuery += "SB1.B1_GRUPO >= '" + ::cGrupoDe + "' AND SB1.B1_GRUPO <= '" + ::cGrupoAte + "' AND "
    cQuery += "SB1.B1_COD >= '" + ::cProdDe + "' AND SB1.B1_COD <= '" + ::cProdAte + "' AND "

    cQuery += "SB1.D_E_L_E_T_ = ' ' AND SB5.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY SB1.B1_COD"

    cQuery := ChangeQuery(cQuery)

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPRRC)

    While !(cAliasPRRC)->(EoF())

        cCodNcm := Left((cAliasPRRC)->CODMAPAS + (cAliasPRRC)->NCM, 11)
        nConcent := Iif((cAliasPRRC)->CONCENT > 100, 100, ROUND((cAliasPRRC)->CONCENT, 0))
        nDensid := Iif((cAliasPRRC)->DENSID > 99.99, 99.99, (cAliasPRRC)->DENSID)
    
        If !Empty(::cGrupRes) .And. (cAliasPRRC)->GRUPO == ::cGrupRes

            If !::lMvAglut .Or. (::lMvAglut .And. !(cAliasTRC)->(dbSeek(cCodNcm + StrZero(nConcent, 3) + StrZero(nDensid, 5, 2))))

                RecLock(cAliasTRC,.T.)
                (cAliasTRC)->COD := (cAliasPRRC)->COD
                (cAliasTRC)->TIPO := "RC"
                (cAliasTRC)->CODNCM := (cAliasPRRC)->CODMAPAS + (cAliasPRRC)->NCM
                (cAliasTRC)->NOMECOM := (cAliasPRRC)->NOMECOM
                (cAliasTRC)->CONCENT := Iif((cAliasPRRC)->CONCENT > 100, 100, ROUND((cAliasPRRC)->CONCENT, 0)) // Permitido somente inteiro de 0 a 100
                (cAliasTRC)->DENSID := Iif((cAliasPRRC)->DENSID > 99.99, 99.99, (cAliasPRRC)->DENSID) // Permitido somente valores entre 00,01 a 99,99
                MsUnLock()    

            EndIf

        Else

            If !::lMvAglut .Or. (::lMvAglut .And. !(cAliasTPR)->(dbSeek(cCodNcm + StrZero(nConcent, 3) + StrZero(nDensid, 5, 2))))

                RecLock(cAliasTPR,.T.)
                (cAliasTPR)->COD := (cAliasPRRC)->COD
                (cAliasTPR)->TIPO := "PR"
                (cAliasTPR)->CODNCM := cCodNcm 
                (cAliasTPR)->NOMECOM := (cAliasPRRC)->NOMECOM
                (cAliasTPR)->CONCENT := nConcent // Permitido somente inteiro de 0 a 100
                (cAliasTPR)->DENSID := nDensid // Permitido somente valores entre 00,01 a 99,99
                MsUnLock()

            EndIf

        EndIf
 
        (cAliasPRRC)->(dbSkip())

    End

    (cAliasPRRC)->(dbCloseArea())

Return

/*/{Protheus.doc} SubSecComp
    Método que preenche as tabelas temporárias referentes às subseções PC e SC, RS e RB.
    Produtos Compostos de Substâncias Controladas e Componentes do Produto Composto, Resíduos Químicos Compostos e Componentes do Resíduo Composto. 
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD SubSecComp(aTrabPC, aTrabSC, aTrabRS, aTrabRB) CLASS MAPAIMCD

    Local cQuery := ""
    Local cAliasPCRS := GetNextAlias()
    Local cAliasTPC := aTrabPC[ALIAS_POS]
    Local cAliasTSC := aTrabSC[ALIAS_POS]
    Local cAliasTRS := aTrabRS[ALIAS_POS]
    Local cAliasTRB := aTrabRB[ALIAS_POS]
    Local cChave := ""
    Local cCodNcm := ""
    Local nConcent := 0

    If ::lMvAglut 
        (cAliasTSC)->(dbSetOrder(2))
        (cAliasTRB)->(dbSetOrder(2))
    Else
        (cAliasTSC)->(dbSetOrder(1))
        (cAliasTRB)->(dbSetOrder(1))
    EndIf

    cQuery := "SELECT DISTINCT * FROM ( "
    
    cQuery += "SELECT SB1.B1_COD AS COD, SB1.B1_GRUPO AS GRUPO, SB1.B1_POSIPI AS NCM, "
    cQuery += "SB5.B5_DENSID AS DENSID, SG1.G1_COMP AS C_COD, "
    If ::lExistDesc
        cQuery += "SB5." + ::cDescPR + " AS NOMECOM, "
    Else
        cQuery += "SB1.B1_DESC AS NOMECOM, "
    EndIf
    cQuery += "SB1COMP.B1_POSIPI AS C_NCM, SB5COMP.B5_CONCENT AS C_CONCENT, "
    cQuery += "SB5COMP." + ::cCodMapas + " AS C_CODMAPAS "
    cQuery += "FROM " + ::cSqlNameB1 + " SB1 "
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SB1.B1_FILIAL = '" + ::cFilSB1 + "' "
    cQuery += "AND SB5.B5_FILIAL = '" + ::cFilSB5 + "' "
    cQuery += "AND SB1.B1_COD = SB5.B5_COD "
    cQuery += "INNER JOIN " + ::cSqlNameG1 + " SG1 "
    cQuery += "ON SG1.G1_FILIAL = '" + ::cFilSG1 + "' "
    cQuery += "AND SG1.G1_COD = SB1.B1_COD "
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1COMP "
    cQuery += "ON SB1COMP.B1_FILIAL = '" + ::cFilSB1 + "' "
    cQuery += "AND SB1COMP.B1_COD = SG1.G1_COMP "
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5COMP "
    cQuery += "ON SB5COMP.B5_FILIAL = '" + ::cFilSB5 + "' "
    cQuery += "AND SB5COMP.B5_COD = SB1COMP.B1_COD "
    cQuery += "WHERE SB5." + ::cProdPF + " IN ('S', 's') "
    cQuery += "AND SB5." + ::cPFCompo + " IN ('S', 's') "
    cQuery += "AND SB5COMP." + ::cProdPF + " IN ('S', 's') "
    cQuery += "AND SB5COMP." + ::cPFCompo + " IN ('N', 'n', ' ') "
    cQuery += "AND SB1.B1_GRUPO >= '" + ::cGrupoDe + "' "
    cQuery += "AND SB1.B1_GRUPO <= '" + ::cGrupoAte + "' "
    cQuery += "AND SB1COMP.B1_GRUPO >= '" + ::cGrupoDe + "' "
    cQuery += "AND SB1COMP.B1_GRUPO <= '" + ::cGrupoAte + "' "
    cQuery += "AND SB1.B1_COD >= '" + ::cProdDe + "' "
    cQuery += "AND SB1.B1_COD <= '" + ::cProdAte + "' "
    cQuery += "AND SB1COMP.B1_COD >= '" + ::cProdDe + "' "
    cQuery += "AND SB1COMP.B1_COD <= '" + ::cProdAte + "' "
    cQuery += "AND SG1.G1_QUANT > 0 "
    cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB5.D_E_L_E_T_ = ' ' "
    cQuery += "AND SG1.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB1COMP.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB5COMP.D_E_L_E_T_ = ' ' "
    
    cQuery += "UNION ALL "

    cQuery += "SELECT SB1.B1_COD AS COD, SB1.B1_GRUPO AS GRUPO, SB1.B1_POSIPI AS NCM, "
    cQuery += "SB5.B5_DENSID AS DENSID, SGG.GG_COMP AS C_COD, "
    If ::lExistDesc
        cQuery += "SB5." + ::cDescPR + " AS NOMECOM, "
    Else
        cQuery += "SB1.B1_DESC AS NOMECOM, "
    EndIf
    cQuery += "SB1COMP.B1_POSIPI AS C_NCM, SB5COMP.B5_CONCENT AS C_CONCENT, "
    cQuery += "SB5COMP." + ::cCodMapas + " AS C_CODMAPAS "
    cQuery += "FROM " + ::cSqlNameB1 + " SB1 "
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SB1.B1_FILIAL = '" + ::cFilSB1 + "' "
    cQuery += "AND SB5.B5_FILIAL = '" + ::cFilSB5 + "' "
    cQuery += "AND SB1.B1_COD = SB5.B5_COD "
    cQuery += "INNER JOIN " + ::cSqlNameGG + " SGG "
    cQuery += "ON SGG.GG_FILIAL = '" + ::cFilSGG + "' "
    cQuery += "AND SGG.GG_COD = SB1.B1_COD "
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1COMP "
    cQuery += "ON SB1COMP.B1_FILIAL = '" + ::cFilSB1 + "' "
    cQuery += "AND SB1COMP.B1_COD = SGG.GG_COMP "
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5COMP "
    cQuery += "ON SB5COMP.B5_FILIAL = '" + ::cFilSB5 + "' "
    cQuery += "AND SB5COMP.B5_COD = SB1COMP.B1_COD "
    cQuery += "WHERE SB5." + ::cProdPF + " IN ('S', 's') "
    cQuery += "AND SB5." + ::cPFCompo + " IN ('S', 's') "
    cQuery += "AND SB5COMP." + ::cProdPF + " IN ('S', 's') "
    cQuery += "AND SB5COMP." + ::cPFCompo + " IN ('N', 'n', ' ') "
    cQuery += "AND SB1.B1_GRUPO >= '" + ::cGrupoDe + "' "
    cQuery += "AND SB1.B1_GRUPO <= '" + ::cGrupoAte + "' "
    cQuery += "AND SB1COMP.B1_GRUPO >= '" + ::cGrupoDe + "' "
    cQuery += "AND SB1COMP.B1_GRUPO <= '" + ::cGrupoAte + "' "
    cQuery += "AND SB1.B1_COD >= '" + ::cProdDe + "' "
    cQuery += "AND SB1.B1_COD <= '" + ::cProdAte + "' "
    cQuery += "AND SB1COMP.B1_COD >= '" + ::cProdDe + "' "
    cQuery += "AND SB1COMP.B1_COD <= '" + ::cProdAte + "' "
    cQuery += "AND SGG.GG_QUANT > 0 "
    cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB5.D_E_L_E_T_ = ' ' "
    cQuery += "AND SGG.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB1COMP.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB5COMP.D_E_L_E_T_ = ' ' "

    cQuery += ") QUERY "

    cQuery := ChangeQuery(cQuery)

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPCRS)

    (cAliasTRS)->(dbSetOrder(1))
    (cAliasTPC)->(dbSetOrder(1))

    While !(cAliasPCRS)->(EoF())

        cCodNcm := Left((cAliasPCRS)->C_CODMAPAS + (cAliasPCRS)->C_NCM, 11)
        nConcent := Iif((cAliasPCRS)->C_CONCENT > 99, 99, ROUND((cAliasPCRS)->C_CONCENT, 0))

        If ::lMvAglut

            cChave := (cAliasPCRS)->COD + cCodNcm + StrZero(nConcent, 2)

        Else

            cChave := (cAliasPCRS)->COD + (cAliasPCRS)->C_COD

        EndIf

        If !Empty(::cGrupRes) .And. (cAliasPCRS)->GRUPO == ::cGrupRes
            
            If !(cAliasTRS)->(dbSeek((cAliasPCRS)->COD))
                RecLock(cAliasTRS,.T.)
                (cAliasTRS)->COD := (cAliasPCRS)->COD
                (cAliasTRS)->TIPO := "RS"
                (cAliasTRS)->NCMCOM := Transform((cAliasPCRS)->NCM, ::cNcmPic)
                (cAliasTRS)->NOMECOM := ::FirstUpper((cAliasPCRS)->NOMECOM)
                (cAliasTRS)->DENSID := Iif((cAliasPCRS)->DENSID > 99.99, 99.99, (cAliasPCRS)->DENSID) // Permitido somente valores entre 00,01 a 99,99
                MsUnLock()
            EndIf

            If !(cAliasTRB)->(dbSeek(cChave))
                RecLock(cAliasTRB,.T.)
                (cAliasTRB)->CODPAI := (cAliasPCRS)->COD
                (cAliasTRB)->COD := (cAliasPCRS)->C_COD
                (cAliasTRB)->TIPO := "RB"
                (cAliasTRB)->CODNCM := cCodNcm
                (cAliasTRB)->CONCENT := nConcent // Permitido somente inteiro de 1 a 99
                MsUnLock()
            EndIf
        
        Else

            If !(cAliasTPC)->(dbSeek((cAliasPCRS)->COD))
                RecLock(cAliasTPC,.T.)
                (cAliasTPC)->COD := (cAliasPCRS)->COD
                (cAliasTPC)->TIPO := "PC"
                (cAliasTPC)->NCMCOM := Transform((cAliasPCRS)->NCM, ::cNcmPic)
                (cAliasTPC)->NOMECOM := ::FirstUpper((cAliasPCRS)->NOMECOM)
                (cAliasTPC)->DENSID := Iif((cAliasPCRS)->DENSID > 99.99, 99.99, (cAliasPCRS)->DENSID) // Permitido somente valores entre 00,01 a 99,99
                MsUnLock()
            EndIf

            If !(cAliasTSC)->(dbSeek(cChave))
                RecLock(cAliasTSC,.T.)
                (cAliasTSC)->CODPAI := (cAliasPCRS)->COD
                (cAliasTSC)->COD := (cAliasPCRS)->C_COD
                (cAliasTSC)->TIPO := "SC"
                (cAliasTSC)->CODNCM := cCodNcm
                (cAliasTSC)->CONCENT := nConcent // Permitido somente inteiro de 1 a 99
                MsUnLock()
            EndIf
        
        EndIf

        (cAliasPCRS)->(dbSkip())

    End

    (cAliasPCRS)->(dbCloseArea())

Return

/*/{Protheus.doc} ProcessMov
    Método que preenche as tabelas temporárias referentes às Seções MVN e TN, e as subseções MM, MT, CC e TM
    Movimentações Nacionais e Operações de Transporte 
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD ProcessMov(lReceb) CLASS MAPAIMCD

    Local nConcent := 0
    Local nQuant := 0
    Local aRecMVN := {}
    Local aRecMM := {}
    Local aRecMT := {}
    Local cQuery := ""
    Local cAliasMov := GetNextAlias()
    Local cFilSA2 := FWxFilial("SA2")
    Local cFilSA1 := FWxFilial("SA1")
    Local cFilSA4 := FWxFilial("SA4")
    Local cFilSF8 := FWxFilial("SF8")
    Local cFilSC5 := FWxFilial("SC5")
    Local cUM := ""
    Local cChave := ""
    Local cSFAnt := ""
    Local cSFFil := ""
    Local cSFSeek := ""
    Local cCodMov := ""
    Local cCodTran := ""
    Local cMapCfop := ""
    Local cCNPJ := ""
    Local cCNPJT := ""
    Local cRazSoc := ""
    Local cRazSocT := ""
    Local cCodTransp := ""
    Local cCodNcm := ""
    Local cMapTrans	:= SuperGetMv("MV_MAPTRAN", .F., "1")
    Local lIntTms := SuperGetMv("MV_INTTMS", .F., .F.)

    Local cNumCC := ""
    Local cDigitCC := ""
    Local cEmissaoCC := ""
    Local cRespReceb := ""
    Local cModalTran := ""
    Local cPedidoTra := ""
    Local lEmpTran := SuperGetMv("MV_EMPTRAN", .F., .F.)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Verificando todas as ocorrencias do parametro MV_MAPCFO no SX6³
    //³para compor os CFOPs a serem desconsiderados no processamento.³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    cMapCfop := GETMV("MV_MAPCFO")
        
    cQuery := "SELECT * FROM ( "
    cQuery += "SELECT 'E' AS ENTSAI, SF1.F1_TIPO AS TIPO, SF1.F1_DOC AS DOC, "
    cQuery += "SF1.F1_SERIE AS SERIE, SF1.F1_FORNECE AS CLIFOR, SF1.F1_LOJA AS LOJA, SF1.F1_DTDIGIT AS DIGIT, "
    cQuery += "SD1.D1_EMISSAO AS EMISSAO, SD1.D1_TES AS TES, SF4.F4_PODER3 AS PODER3, SF1.F1_MODAL AS MODAL, "
    cQuery += "'' AS PEDIDO, "
    cQuery += "SF4.F4_TRANFIL AS TRANSFIL, SD1.D1_CF AS CF, SF1.F1_TRANSP AS TRANSP, "
    cQuery += "SD1.D1_COD AS COD, SD1.D1_QUANT AS QUANT, SB1.B1_POSIPI AS NCM, "
    cQuery += "SB1.B1_UM AS UM, SB5.B5_CONCENT AS CONCENT, SB5.B5_DENSID AS DENSID, "
    cQuery += "SD1.D1_NFORI AS NFORI, SD1.D1_SERIORI AS SERIORI, SB1.B1_GRUPO AS GRUPO, "
    If ::lUMSet
        cQuery += "SB5." + ::cCpoUn + " AS UNMAPA, "
        cQuery += "SB5." + ::cCpoFator + " AS CONVMAP, "
        cQuery += "SB5." + ::cCpoTpFator + " AS TCONVMA, "
    EndIf
    If ::lPFCompo
        cQuery += "SB5." + ::cPFCompo + " AS PFCOMPO, "
    EndIf
    cQuery += "SB5." + ::cCodMapas + " AS CODMAPAS, "
    cQuery += "SD1.D1_NUMSEQ AS NUMSEQ "
    cQuery += "FROM " + ::cSqlNameD1 + " SD1 "
    cQuery += "INNER JOIN " + ::cSqlNameF1 + " SF1 "
    cQuery += "ON SD1.D1_DOC = SF1.F1_DOC "
    cQuery += "AND SD1.D1_SERIE = SF1.F1_SERIE "
    cQuery += "AND SD1.D1_FORNECE = SF1.F1_FORNECE "
    cQuery += "AND SD1.D1_LOJA = SF1.F1_LOJA "
    cQuery += "INNER JOIN " + ::cSqlNameF4 + " SF4 "
    cQuery += "ON SF4.F4_CODIGO = SD1.D1_TES "
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1 "
    cQuery += "ON SB1.B1_COD = SD1.D1_COD "
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SB5.B5_COD = SB1.B1_COD "
    cQuery += "WHERE SF1.F1_FILIAL = '" + ::cFilSF1 + "' "
    cQuery += "AND SD1.D1_FILIAL = '" + ::cFilSD1 + "' "
    cQuery += "AND SB1.B1_FILIAL = '" + ::cFilSB1 + "' "
    cQuery += "AND SB5.B5_FILIAL = '" + ::cFilSB5 + "' "
    cQuery += "AND SF4.F4_FILIAL = '" + ::cFilSF4 + "' "
    cQuery += "AND SB1.B1_GRUPO BETWEEN '" + ::cGrupoDe + "' AND '" + ::cGrupoAte + "' "
    cQuery += "AND SB1.B1_COD BETWEEN '" + ::cProdDe + "' AND '" + ::cProdAte + "' "
    //Customizado IMCD
    if lReceb
        cQuery += "AND SF1.F1_DTDIGIT BETWEEN '" + DtoS(::dDataDe) + "' AND '" + DtoS(::dDataAte) + "' "
    else
        cQuery += "AND SD1.D1_EMISSAO BETWEEN '" + DtoS(::dDataDe) + "' AND '" + DtoS(::dDataAte) + "' "
    endif
    cQuery += "AND SD1.D1_QUANT > 0 "
    cQuery += "AND SB5." + ::cProdPF + " IN ('S', 's') "
    If ::lMapVII
        cQuery += "AND SB5." + ::cMapVII + " IN ('2', ' ') "
    EndIf
    cQuery += "AND SF4.F4_ESTOQUE = 'S' "
    cQuery += "AND SF1.D_E_L_E_T_ = ' ' "
    cQuery += "AND SD1.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB5.D_E_L_E_T_ = ' ' "
    cQuery += "AND SF4.D_E_L_E_T_ = ' ' "
    
    cQuery += "UNION ALL "

    cQuery += "SELECT 'S' AS ENTSAI, SF2.F2_TIPO AS TIPO, SF2.F2_DOC AS DOC, "
    cQuery += "SF2.F2_SERIE AS SERIE, SF2.F2_CLIENTE AS CLIFOR, SF2.F2_LOJA AS LOJA, '' AS DIGIT, "
    cQuery += "SD2.D2_EMISSAO AS EMISSAO, SD2.D2_TES AS TES, SF4.F4_PODER3 AS PODER3, '' AS MODAL, "
    cQuery += "SD2.D2_PEDIDO AS PEDIDO, "
    cQuery += "SF4.F4_TRANFIL AS TRANSFIL, SD2.D2_CF AS CF, SF2.F2_TRANSP AS TRANSP, "
    cQuery += "SD2.D2_COD AS COD, SD2.D2_QUANT AS QUANT, SB1.B1_POSIPI AS NCM, "
    cQuery += "SB1.B1_UM AS UM, SB5.B5_CONCENT AS CONCENT, SB5.B5_DENSID AS DENSID, "
    cQuery += "SD2.D2_NFORI AS NFORI, SD2.D2_SERIORI AS SERIORI, SB1.B1_GRUPO AS GRUPO, "
    If ::lUMSet
        cQuery += "SB5." + ::cCpoUn + " AS UNMAPA, "
        cQuery += "SB5." + ::cCpoFator + " AS CONVMAP, "
        cQuery += "SB5." + ::cCpoTpFator + " AS TCONVMA, "
    EndIf
    If ::lPFCompo
        cQuery += "SB5." + ::cPFCompo + " AS PFCOMPO, "
    EndIf
    cQuery += "SB5." + ::cCodMapas + " AS CODMAPAS, "
    cQuery += "SD2.D2_NUMSEQ AS NUMSEQ "
    cQuery += "FROM " + ::cSqlNameD2 + " SD2 "
    cQuery += "INNER JOIN " + ::cSqlNameF2 + " SF2 "
    cQuery += "ON SD2.D2_DOC = SF2.F2_DOC "
    cQuery += "AND SD2.D2_SERIE = SF2.F2_SERIE "
    cQuery += "AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "
    cQuery += "AND SD2.D2_LOJA = SF2.F2_LOJA "
    cQuery += "INNER JOIN " + ::cSqlNameF4 + " SF4 "
    cQuery += "ON SF4.F4_CODIGO = SD2.D2_TES "
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1 "
    cQuery += "ON SB1.B1_COD = SD2.D2_COD "
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SB5.B5_COD = SB1.B1_COD "
    cQuery += "WHERE SF2.F2_FILIAL = '" + ::cFilSF2 + "' "
    cQuery += "AND SD2.D2_FILIAL = '" + ::cFilSD2 + "' "
    cQuery += "AND SB1.B1_FILIAL = '" + ::cFilSB1 + "' "
    cQuery += "AND SB5.B5_FILIAL = '" + ::cFilSB5 + "' "
    cQuery += "AND SF4.F4_FILIAL = '" + ::cFilSF4 + "' "
    cQuery += "AND SB1.B1_GRUPO BETWEEN '" + ::cGrupoDe + "' AND '" + ::cGrupoAte + "' "
    cQuery += "AND SB1.B1_COD BETWEEN '" + ::cProdDe + "' AND '" + ::cProdAte + "' "
    cQuery += "AND SD2.D2_EMISSAO BETWEEN '" + DtoS(::dDataDe) + "' AND '" + DtoS(::dDataAte) + "' "
    cQuery += "AND SD2.D2_QUANT > 0 "
    cQuery += "AND SB5." + ::cProdPF + " IN ('S', 's') "
    If ::lMapVII
        cQuery += "AND SB5." + ::cMapVII + " IN ('2', ' ') "
    EndIf
    cQuery += "AND SF4.F4_ESTOQUE = 'S' "
    cQuery += "AND SF2.D_E_L_E_T_ = ' ' "
    cQuery += "AND SD2.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += "AND SB5.D_E_L_E_T_ = ' ' "
    cQuery += "AND SF4.D_E_L_E_T_ = ' ' "

    cQuery += ") MOV ORDER BY MOV.EMISSAO, MOV.DOC, MOV.SERIE, MOV.CLIFOR, MOV.LOJA, MOV.ENTSAI"

    cQuery := ChangeQuery(cQuery)

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasMov)

    While !(cAliasMov)->(EoF())

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica os CFOPs que nao devem ser processados na rotina³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Alltrim((cAliasMov)->CF) $ cMapCfop
			(cAliasMov)->(DbSkip())
			Loop
		Endif

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ignora CFOPs referentes à movimentações internacionais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If Left((cAliasMov)->CF,1) $ "3/7"
            (cAliasMov)->(DbSkip())
			Loop
        EndIf

        cChave := (cAliasMov)->ENTSAI + (cAliasMov)->DOC + (cAliasMov)->SERIE + (cAliasMov)->CLIFOR + (cAliasMov)->LOJA

        If cChave != cSFAnt // O processamento a seguir só é necessário 1 vez por NF

            cCNPJ := ""
            cCNPJT := ""
            cRazSoc := ""
            cRazSocT := ""
            cCodTransp := ""
            cNumCC := ""
            cDigitCC := ""
            cEmissaoCC := ""
            cRespReceb := ""
            cModalTran := ""
            cPedidoTra := ""

            cSFAnt := cChave

            // Definição das informações de Cliente/Fornecedor
            If ((cAliasMov)->ENTSAI == "E" .And. (cAliasMov)->TIPO $ "D/B");
                .Or. ((cAliasMov)->ENTSAI == "S" .And. !((cAliasMov)->TIPO $ "D/B"))

                SA1->(dbSetOrder(1))
                If !SA1->(dbSeek(cFilSA1 + (cAliasMov)->CLIFOR + (cAliasMov)->LOJA))
                    (cAliasMov)->(DbSkip())
                    Loop
                Endif
                cCNPJ    := Iif(!Empty(SA1->A1_CGC),aRetDig(SA1->A1_CGC,.F.),Space(14))
                cRazSoc  := SA1->A1_NOME
            Else
                SA2->(dbSetOrder(1))
                If !SA2->(dbSeek(cFilSA2 + (cAliasMov)->CLIFOR + (cAliasMov)->LOJA))
                    (cAliasMov)->(DbSkip())
                    Loop
                Endif
                cCNPJ    := IIf(!Empty(SA2->A2_CGC), aRetDig(SA2->A2_CGC,.F.), Space(14))
                cRazSoc  := SA2->A2_NOME
            EndIf

            // Definição das informações da Transportadora
            If (cAliasMov)->ENTSAI == "E"
                
                SF8->(dbSetOrder(2))
                If SF8->(dbSeek(cFilSF8 + (cAliasMov)->DOC + (cAliasMov)->SERIE + (cAliasMov)->CLIFOR + (cAliasMov)->LOJA))
                    
                    If cMapTrans == "1"
                        SA4->(dbSetOrder(1))
                        If SA4->(dbSeek(cFilSA4 + SF8->F8_TRANSP))   
                            cCNPJT := aRetDig(SA4->A4_CGC,.F.)
                            cRazSocT := SA4->A4_NOME
                        EndIf
                    Else
                        SA2->(DbSetOrder(1))
                        If SA2->(dbSeek(cFilSA2 + SF8->F8_TRANSP + SF8->F8_LOJTRAN))
                            cCNPJT := aRetDig(SA2->A2_CGC,.F.)
                            cRazSocT := SA2->A2_NOME
                        Endif
                    EndIf

                    If !lIntTms .And. lEmpTran .And. !Empty(cCNPJT) .And. cCNPJT == ::cCnpjFil

                        cNumCC := SF8->F8_NFDIFRE

                        cDigitCC := DtoS(SF8->F8_DTDIGIT)
                        cDigitCC := SubStr(cDigitCC, 7, 2) + "/" + SubStr(cDigitCC, 5, 2) + "/" + SubStr(cDigitCC, 1, 4)

                        SF1->(dbSetOrder(1))
                        If SF1->(dbSeek(::cFilSF1 + cNumCC + SF8->F8_SEDIFRE + SF8->F8_TRANSP + SF8->F8_LOJTRAN))

                            cEmissaoCC := DtoS(SF1->F1_EMISSAO)
                            cEmissaoCC := SubStr(cEmissaoCC, 7, 2) + "/" + SubStr(cEmissaoCC, 5, 2) + "/" + SubStr(cEmissaoCC, 1, 4)

                            cModalTran := ::GetModalCod("E", SF1->F1_MODAL)

                        EndIf

                    EndIf
                
                Else
                
                    If cMapTrans == "1"
                        SA4->(dbSetOrder(1))
                        If SA4->(dbSeek(cFilSA4 + (cAliasMov)->TRANSP))
                            cCNPJT := aRetDig(SA4->A4_CGC,.F.)
                            cRazSocT := SA4->A4_NOME
                        EndIf
                    Else
                        cCNPJT := cCNPJ
                    EndIf

                    If !lIntTms .And. lEmpTran .And. !Empty(cCNPJT) .And. cCNPJT == ::cCnpjFil

                        cNumCC := (cAliasMov)->DOC

                        cDigitCC := (cAliasMov)->DIGIT
                        cDigitCC := SubStr(cDigitCC, 7, 2) + "/" + SubStr(cDigitCC, 5, 2) + "/" + SubStr(cDigitCC, 1, 4)

                        cEmissaoCC := (cAliasMov)->EMISSAO
                        cEmissaoCC := SubStr(cEmissaoCC, 7, 2) + "/" + SubStr(cEmissaoCC, 5, 2) + "/" + SubStr(cEmissaoCC, 1, 4)

                        cModalTran := ::GetModalCod("E", (cAliasMov)->MODAL)

                    EndIf
                
                EndIf
            Else
                SD2->(dbSetOrder(10))
                cChave := ::cFilSD2 + (cAliasMov)->DOC + (cAliasMov)->SERIE
                If SD2->(dbSeek(cChave))
                    SF2->(dbSetOrder(1))
                    While SD2->D2_FILIAL + SD2->D2_NFORI + SD2->D2_SERIORI == cChave
                        If SD2->D2_TIPO == "C" .And. SF2->(dbSeek(::cFilSF2 + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA));
                            .And. SF2->F2_TPCOMPL == "1" .And. !Empty(SF2->F2_TRANSP)

                            cCodTransp := SF2->F2_TRANSP

                            // Pré-processamento dos dados de CC
                            // Caso encontre complemento de valor com transportadora preenchida, considerar como CC
                            cNumCC := SF2->F2_DOC
                            cPedidoTra := SD2->D2_PEDIDO
                            cEmissaoCC := DtoS(SF2->F2_EMISSAO)

                            Exit

                        EndIf
                        SD2->(dbSkip())
                    End
                EndIf
                
                cCodTransp := Iif(!Empty(cCodTransp), cCodTransp, (cAliasMov)->TRANSP)
                
                If !Empty(cCodTransp)
                    SA4->(dbSetOrder(1))
                    If SA4->(dbSeek(cFilSA4 + cCodTransp))
                        cCNPJT := aRetDig(SA4->A4_CGC,.F.)
                        cRazSocT := SA4->A4_NOME
                    EndIf

                    // Pré-processamento dos dados de CC
                    // Caso não tenha encontrado complemento anteriormente, utiliza dados da prórpia NF como CC
                    If Empty(cNumCC)

                        cNumCC := (cAliasMov)->DOC
                        cPedidoTra := (cAliasMov)->PEDIDO
                        cEmissaoCC := (cAliasMov)->EMISSAO

                    EndIf

                EndIf

                // Finaliza processamento dos dados de CC somente quando ao transporte for feito pela própria filial
                If !lIntTms .And. lEmpTran .And. !Empty(cCNPJT) .And. cCNPJT == ::cCnpjFil

                    cEmissaoCC := SubStr(cEmissaoCC, 7, 2) + "/" + SubStr(cEmissaoCC, 5, 2) + "/" + SubStr(cEmissaoCC, 1, 4)

                    SC5->(dbSetOrder(1))
                    If SC5->(dbSeek(cFilSC5 + cPedidoTra))

                        cDigitCC := DtoS(SC5->C5_FECENT)
                        cDigitCC := SubStr(cDigitCC, 7, 2) + "/" + SubStr(cDigitCC, 5, 2) + "/" + SubStr(cDigitCC, 1, 4)

                        cModalTran := ::GetModalCod("S", SC5->C5_MODANP)

                    Endif

                EndIf

            EndIf

            /////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Definição do código de transporte a ser utilizado:                                                      //
            //  // - F: Fornecedor                                                                                     //
            //  // - A: Adquirente                                                                                     //
            //  // - T: Terceirizado                                                                                   //
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////

            If !Empty(cCNPJT) .And. cCNPJT == ::cCnpjFil

                cCodTran := Iif((cAliasMov)->ENTSAI == "E", "A", "F")

            ElseIf (!Empty(cCNPJT) .And. cCNPJT == cCNPJ) .Or. Empty(cCNPJT)

                cCodTran := Iif((cAliasMov)->ENTSAI == "E", "F", "A")

            Else

                cCodTran := "T"

            EndIf

        
        EndIf

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // Definição do código de operação a ser utilizado                                                         //
        // Códigos não cobertos:                                                                                   // 
        //  // - SA: Devolução de produto armazenado (no momento, o MVP não cobrirá armazenagem terceirizada)      //
        //  // - SR: Remessa para armazenagem                                                                      //
        //  // - SO: Outras remessas                                                                               //
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////

        SF1->(dbSetOrder(1))
        SF2->(dbSetOrder(1))

        cSFFil := Iif((cAliasMov)->ENTSAI == "E", ::cFilSF2, ::cFilSF1)
        cSFSeek := cSFFil + (cAliasMov)->NFORI + (cAliasMov)->SERIORI + (cAliasMov)->CLIFOR + (cAliasMov)->LOJA

        If (cAliasMov)->TRANSFIL == "1"

            cCodMov := Iif((cAliasMov)->ENTSAI == "E", "ET", "ST") // Transferência
        
        ElseIf (cAliasMov)->PODER3 == "D" .And. (Iif((cAliasMov)->ENTSAI == "E", "SF2", "SF1"))->(dbSeek(cSFSeek))
        
            cCodMov := Iif((cAliasMov)->ENTSAI == "E", "EP", "SI") // Devolução de produto industrializado
        
        ElseIf (cAliasMov)->TIPO == "B" .And. (cAliasMov)->PODER3 == "R"

            cCodMov := Iif((cAliasMov)->ENTSAI == "E", "EI", "SP") // Remessa para industrialização

        ElseIf Alltrim((cAliasMov)->CF) $ "1910/2910/5910/6910"

            cCodMov := Iif((cAliasMov)->ENTSAI == "E", "ED", "SD") // Doação

        Else

            cCodMov := Iif((cAliasMov)->ENTSAI == "E", "EC", "SV") // Compra/Venda

        EndIf
        
        // Definição da quantidade movimentada
        If !Empty(::cCpoUn) .And. !Empty(Alltrim((cAliasMov)->UNMAPA)) .And. !Empty(::cCpoFator);
            .And. !Empty((cAliasMov)->CONVMAP) .And. !Empty(::cCpoTpFator) .And. !Empty(Alltrim((cAliasMov)->TCONVMA))

            //Conversao da Unidade de Medida atraves do parametro MV_CPOMAPA
            nQuant := ::ConvUMMAPA((cAliasMov)->QUANT,(cAliasMov)->CONVMAP,(cAliasMov)->TCONVMA)
            nQuant := Iif(nQuant > 999999999.999, 999999999.999, nQuant)

        Else

            nQuant := Iif((cAliasMov)->QUANT > 999999999.999, 999999999.999, (cAliasMov)->QUANT)

        EndIf

        // Definições do código NCM e Concentração
        If ::lPFCompo .And. (cAliasMov)->PFCOMPO $ "S/s"   
            
            If !Empty(::cGrupRes) .And. (cAliasMov)->GRUPO == ::cGrupRes
            
                cCodNcm := "RS"
        
            Else
            
                cCodNcm := "PC"
            
            EndIf
            
            cCodNcm += Transform((cAliasMov)->NCM, ::cNcmPic)
            nConcent := 0
    
        Else
        
            If !Empty(::cGrupRes) .And. (cAliasMov)->GRUPO == ::cGrupRes
            
                cCodNcm := "RC"
        
            Else
            
                cCodNcm := "PR"
            
            EndIf

            cCodNcm += (cAliasMov)->CODMAPAS + (cAliasMov)->NCM
            nConcent := Iif((cAliasMov)->CONCENT > 100, 100, ROUND((cAliasMov)->CONCENT, 0))
    
        EndIf

        // Definição da Unidade de Medida a ser considerada para o MAPAS
        If (!::lUMSet .And. (cAliasMov)->UM != "KG" .And. (cAliasMov)->UM != "L ") .Or. (::lUMSet .And. (cAliasMov)->UNMAPA != "KG" .And. (cAliasMov)->UNMAPA != "L ")
                
            cUM := " "
        
        Else
            
            cUM := Iif(::lUMSet, Left((cAliasMov)->UNMAPA, 1), Left((cAliasMov)->UM, 1))
        
        EndIf

        cEmissao := SubStr((cAliasMov)->EMISSAO, 7, 2) + "/"
        cEmissao += SubStr((cAliasMov)->EMISSAO, 5, 2) + "/"
        cEmissao += SubStr((cAliasMov)->EMISSAO, 1, 4)

        aRecMVN := Array(13)

        aRecMVN[01] := (cAliasMov)->DOC
        aRecMVN[02]	:= (cAliasMov)->SERIE
        aRecMVN[03]	:= (cAliasMov)->CLIFOR
        aRecMVN[04] := (cAliasMov)->LOJA
        aRecMVN[05]	:= "MVN"
        aRecMVN[06] := (cAliasMov)->ENTSAI
        aRecMVN[07] := cCodMov
        aRecMVN[08] := cCNPJ
        aRecMVN[09] := cRazSoc
        aRecMVN[10] := (cAliasMov)->DOC
        aRecMVN[11] := CtoD(cEmissao)
        aRecMVN[12] := Iif((cAliasMov)->ENTSAI == "E", "N", "F") // No momento, o MVP não irá cobrir armazenagens terceirizadas
        aRecMVN[13] := cCodTran

        aRecMM := Array(7)

        aRecMM[01] := (cAliasMov)->COD
        aRecMM[02] := "MM"
        aRecMM[03] := cCodNcm
        aRecMM[04] := nConcent
        aRecMM[05] := Iif((cAliasMov)->DENSID > 99.99, 99.99, (cAliasMov)->DENSID)
        aRecMM[06] := nQuant
        aRecMM[07] := cUM

        aRecMT := Nil

        If cCodTran == "T"

            aRecMT := Array(3)
            aRecMT[01] := "MT"
            aRecMT[02] := cCNPJT
            aRecMT[03] := ::FirstUpper(cRazSocT)
        
        EndIf 

        ::GravaMVN(aRecMVN, aRecMM, aRecMT)

        // Gera registros de transporte
        If !lIntTms .And. lEmpTran .And. cModalTran $ "RO/AQ/FE/AE";
            .And. (((cAliasMov)->ENTSAI == "E" .And. cCodTran == "A") .Or. ((cAliasMov)->ENTSAI == "S" .And. cCodTran == "F"))

            aRecTN := Array(14)
            aRecCC := Array(6)
            aRecTM := Array(7)

            aRecTN[01] := (cAliasMov)->DOC
            aRecTN[02] := (cAliasMov)->SERIE
            aRecTN[03] := (cAliasMov)->CLIFOR
            aRecTN[04] := (cAliasMov)->LOJA
            aRecTN[05] := (cAliasMov)->ENTSAI
            aRecTN[06] := "TN"
            aRecTN[07] := Iif((cAliasMov)->ENTSAI == "E", ::cCnpjFil, cCNPJ)
            aRecTN[08] := Iif((cAliasMov)->ENTSAI == "E", ::cFilRazSoc, cRazSoc)
            aRecTN[09] := (cAliasMov)->DOC
            aRecTN[10] := CtoD(cEmissao)
            aRecTN[11] := Iif((cAliasMov)->ENTSAI == "E", cCNPJ, ::cCnpjFil)
            aRecTN[12] := Iif((cAliasMov)->ENTSAI == "E", cRazSoc, ::cFilRazSoc) 
            aRecTN[13] := "P" // No momento, o MVP não cobrirá cenário de armazenagem terceirizada
            aRecTN[14] := "P" // No momento, o MVP não cobrirá cenário de armazenagem terceirizada

            aRecCC[01] := "CC"
            aRecCC[02] := cNumCC
            aRecCC[03] := CtoD(cEmissaoCC)
            aRecCC[04] := CtoD(cDigitCC)
            aRecCC[05] := "SEM INFORMAÇÃO"
            aRecCC[06] := cModalTran

            aRecTM[01] := (cAliasMov)->COD
            aRecTM[02] := "TM" // Gravado apenas para identificação. Não será impresso no arquivo magnético. 
            aRecTM[03] := cCodNcm
            aRecTM[04] := nConcent
            aRecTM[05] := Iif((cAliasMov)->DENSID > 99.99, 99.99, (cAliasMov)->DENSID)
            aRecTM[06] := nQuant
            aRecTM[07] := cUM

            ::GravaTN(aRecTN, aRecCC, aRecTM)

            ::lTN := .T.

        EndIf

        ::lMVN := .T.

        (cAliasMov)->(dbSkip())

    End

    If lIntTms .And. FindFunction("MAPASXTMS")
        ::lTN := MAPASXTMS(self,cMapCfop)
    EndIf

    (cAliasMov)->(dbCloseArea())

Return

/*/{Protheus.doc} GravaMVN
    Método que efetivamente grava os registros vindos do método ProcessMov
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD GravaMVN(aRecMVN, aRecMM, aRecMT) CLASS MAPAIMCD

    Local cAliasMVN := ::aTrab[MVN_POS][ALIAS_POS]
    Local cAliasTMM := ::aTrab[TMM_POS][ALIAS_POS]
    Local cAliasTMT := ::aTrab[TMT_POS][ALIAS_POS]
    Local cChave := ""

    (cAliasMVN)->(dbSetOrder(1))
    (cAliasTMT)->(dbSetOrder(1))

    If ::lMvAglut
        
        (cAliasTMM)->(dbSetOrder(2))

        cChave := aRecMVN[1] + aRecMVN[2] + aRecMVN[3] + aRecMVN[4] + aRecMVN[6] + aRecMVN[07] + Left(aRecMM[03], 13) + StrZero(aRecMM[04], 3) + StrZero(aRecMM[05], 5, 2) + Iif(Empty(aRecMM[07]), " ", aRecMM[07])
    
    EndIf

    If !(cAliasMVN)->(dbSeek(aRecMVN[1] + aRecMVN[2] + aRecMVN[3] + aRecMVN[4] + aRecMVN[6] + aRecMVN[07]))

        RecLock(cAliasMVN, .T.)
        (cAliasMVN)->NUMDOC	    := aRecMVN[01]
        (cAliasMVN)->SERIE	    := aRecMVN[02]
        (cAliasMVN)->CLIFOR	    := aRecMVN[03]
        (cAliasMVN)->LOJA	    := aRecMVN[04]
        (cAliasMVN)->TIPO	    := aRecMVN[05]
        (cAliasMVN)->ENTSAI	    := aRecMVN[06]
        (cAliasMVN)->OPERACAO   := aRecMVN[07]
        (cAliasMVN)->CNPJ	    := aRecMVN[08]
        (cAliasMVN)->RAZAOSOC   := aRecMVN[09]
        (cAliasMVN)->NUMERONF	:= aRecMVN[10]
        (cAliasMVN)->EMISSAONF	:= aRecMVN[11]
        (cAliasMVN)->ARMAZENAG	:= aRecMVN[12]
        (cAliasMVN)->TRANSPORT	:= aRecMVN[13]
        MsUnlock()

    EndIf

    If aRecMM != Nil

        If !::lMvAglut .Or. (::lMvAglut .And. !(cAliasTMM)->(dbSeek(cChave)))

            RecLock(cAliasTMM, .T.)
            (cAliasTMM)->NUMDOC   := aRecMVN[01]
            (cAliasTMM)->SERIE	  := aRecMVN[02]
            (cAliasTMM)->CLIFOR	  := aRecMVN[03]
            (cAliasTMM)->LOJA	  := aRecMVN[04]
            (cAliasTMM)->ENTSAI	  := aRecMVN[06]
            (cAliasTMM)->OPERACAO := aRecMVN[07]
            (cAliasTMM)->COD      := aRecMM[01]
            (cAliasTMM)->TIPO	  := aRecMM[02]
            (cAliasTMM)->CODNCM   := aRecMM[03]
            (cAliasTMM)->CONCENT  := aRecMM[04]
            (cAliasTMM)->DENSID   := aRecMM[05]
            (cAliasTMM)->QUANT    := aRecMM[06]
            (cAliasTMM)->UM       := aRecMM[07]
            MsUnlock()

        ElseIf (cAliasTMM)->(dbSeek(cChave))

            RecLock(cAliasTMM, .F.)
            If (cAliasTMM)->QUANT + aRecMM[06] <= 999999999.999
                
                (cAliasTMM)->QUANT += aRecMM[06]
            
            Else
            
                (cAliasTMM)->QUANT := 999999999.999
            
            EndIf
            MsUnlock()

        EndIf

    EndIf

    If aRecMT != Nil .And. !(cAliasTMT)->(dbSeek(aRecMVN[1] + aRecMVN[2] + aRecMVN[3] + aRecMVN[4] + aRecMVN[6] + aRecMVN[07]))
        
        RecLock(cAliasTMT, .T.)
        (cAliasTMT)->NUMDOC   := aRecMVN[01]
        (cAliasTMT)->SERIE	  := aRecMVN[02]
        (cAliasTMT)->CLIFOR	  := aRecMVN[03]
        (cAliasTMT)->LOJA	  := aRecMVN[04]
        (cAliasTMT)->ENTSAI	  := aRecMVN[06]
        (cAliasTMT)->OPERACAO := aRecMVN[07]
        (cAliasTMT)->TIPO	  := aRecMT[01]
        (cAliasTMT)->CNPJ     := aRecMT[02]
        (cAliasTMT)->RAZSOC   := aRecMT[03]
        MsUnlock()
    
    EndIf

Return

/*/{Protheus.doc} GravaTN
    Método que efetivamente grava os registros vindos do método ProcessMov
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD GravaTN(aRecTN, aRecCC, aRecTM) CLASS MAPAIMCD

    Local cAliasTTN := ::aTrab[TTN_POS][ALIAS_POS]
    Local cAliasTCC := ::aTrab[TCC_POS][ALIAS_POS]
    Local cAliasTTM := ::aTrab[TTM_POS][ALIAS_POS]
    Local cChave := ""

    (cAliasTTN)->(dbSetOrder(1))

    If ::lMvAglut

        (cAliasTTM)->(dbSetOrder(2))
    
        cChave := aRecTN[1] + aRecTN[2] + aRecTN[3] + aRecTN[4] + aRecTN[5] + Left(aRecTM[03], 13) + StrZero(aRecTM[04], 3) + StrZero(aRecTM[05], 5, 2) + Iif(Empty(aRecTM[07]), " ", aRecTM[07])

    EndIf

    If !(cAliasTTN)->(dbSeek(aRecTN[1] + aRecTN[2] + aRecTN[3] + aRecTN[4] + aRecTN[5]))

        RecLock(cAliasTTN, .T.)
        (cAliasTTN)->NUMDOC     := aRecTN[01]
        (cAliasTTN)->SERIE	    := aRecTN[02]
        (cAliasTTN)->CLIFOR	    := aRecTN[03]
        (cAliasTTN)->LOJA	    := aRecTN[04]
        (cAliasTTN)->ENTSAI	    := aRecTN[05]
        (cAliasTTN)->TIPO	    := aRecTN[06]
        (cAliasTTN)->CGCCONTRAT := aRecTN[07]
        (cAliasTTN)->NOMECONTRA := aRecTN[08]
        (cAliasTTN)->NUMERONF   := aRecTN[09]
        (cAliasTTN)->EMISSAONF  := aRecTN[10]
        (cAliasTTN)->CGCORIGEM  := aRecTN[11]
        (cAliasTTN)->NOMEORIGEM := aRecTN[12]
        (cAliasTTN)->RETIRADA   := aRecTN[13]
        (cAliasTTN)->ENTREGA    := aRecTN[14]
        MsUnlock()

        RecLock(cAliasTCC, .T.)
        (cAliasTCC)->NUMDOC     := aRecTN[01]
        (cAliasTCC)->SERIE	    := aRecTN[02]
        (cAliasTCC)->CLIFOR	    := aRecTN[03]
        (cAliasTCC)->LOJA	    := aRecTN[04]
        (cAliasTCC)->ENTSAI	    := aRecTN[05]
        (cAliasTCC)->TIPO	    := aRecCC[01]
        (cAliasTCC)->NUMCC      := aRecCC[02]
        (cAliasTCC)->DATACC     := aRecCC[03]
        (cAliasTCC)->DATARECEB  := aRecCC[04]
        (cAliasTCC)->RESPRECEB  := aRecCC[05]
        (cAliasTCC)->MODALTRANS := aRecCC[06]
        MsUnlock()

    EndIf

    If !::lMvAglut .Or. (::lMvAglut .And. !(cAliasTTM)->(dbSeek(cChave)))

        RecLock(cAliasTTM, .T.)
        (cAliasTTM)->NUMDOC  := aRecTN[01]
        (cAliasTTM)->SERIE	 := aRecTN[02]
        (cAliasTTM)->CLIFOR	 := aRecTN[03]
        (cAliasTTM)->LOJA	 := aRecTN[04]
        (cAliasTTM)->ENTSAI	 := aRecTN[05]
        (cAliasTTM)->COD     := aRecTM[01]
        (cAliasTTM)->TIPO	 := aRecTM[02]
        (cAliasTTM)->CODNCM  := aRecTM[03]
        (cAliasTTM)->CONCENT := aRecTM[04]
        (cAliasTTM)->DENSID  := aRecTM[05]
        (cAliasTTM)->QUANT   := aRecTM[06]
        (cAliasTTM)->UM      := aRecTM[07]
        MsUnlock()

    ElseIf (cAliasTTM)->(dbSeek(cChave))

        RecLock(cAliasTTM, .F.)
        If (cAliasTTM)->QUANT + aRecTM[06] <= 999999999.999
            
            (cAliasTTM)->QUANT += aRecTM[06]
        
        Else
        
            (cAliasTTM)->QUANT := 999999999.999
        
        EndIf
        MsUnlock()

    EndIf

Return

/*/{Protheus.doc} ProcesProd
    Método que preenche as tabelas temporárias referentes às Seções UP e UF.
    Consumos para Produção e Produtos Produzidos
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD ProcesProd() CLASS MAPAIMCD

    Local cQuery := ""
    Local cAliasUPUF := GetNextAlias()
    Local cAliasTUP := ::aTrab[TUP_POS][ALIAS_POS]
    Local cAliasTUF := ::aTrab[TUF_POS][ALIAS_POS]
    Local cUM := ""
    Local cUMUP := ""
    Local cChaveUF := ""
    Local cChaveUP := ""
    Local cCodNcm := ""
    Local cCodNcmUP := ""
    Local nQuant := 0
    Local nQuantUP := 0
    Local nConcent := 0
    Local nConcentUP := 0
    Local nDensid := 0
    Local nDensidUP := 0
    Local cEmissao := ""

    If ::lMvAglut

        (cAliasTUP)->(dbSetOrder(3))
        (cAliasTUF)->(dbSetOrder(3))

    Else

        (cAliasTUP)->(dbSetOrder(2))
        (cAliasTUF)->(dbSetOrder(2))

    EndIf

    cQuery := "SELECT SD3.D3_NUMSEQ, SD3.D3_COD, SB1.B1_GRUPO, SB1.B1_POSIPI, SB5.B5_CONCENT, SB5.B5_DENSID, SD3.D3_QUANT, SB1.B1_UM, SF5.F5_TEXTO, "

    If ::lUMSet 
        cQuery += "SB5." + ::cCpoUN + ", SB5." + ::cCpoFator + ", SB5." + ::cCpoTpFator + ", "
        cQuery += "SB5UP." + ::cCpoUN + " AS UP_UNMAPA, SB5UP." + ::cCpoFator + " AS UP_CONVMAPA, SB5UP." + ::cCpoTpFator + " AS UP_TCONVMA, "
    EndIf
    
    If ::lPFCompo
        cQuery += "SB5." + ::cPFCompo + ", "
        cQuery += "SB5UP." + ::cPFCompo + " AS UP_PFCOMPO, "
    EndIf
    
    If ::lDescProd
        cQuery += "SF5." + ::cDescProd + ", "
    EndIf
    
    cQuery += "SB5." + ::cCodMapas + " AS CODMAPAS, "
    cQuery += "SB5UP." + ::cCodMapas + " AS UP_CODMAPA, "

    cQuery += "SD3.D3_EMISSAO, SD3.D3_TM, SD3.D3_OP, SC2.C2_QUANT, SD4.D4_COD AS UP_COD, SB1UP.B1_GRUPO AS UP_GRUPO, SB1UP.B1_POSIPI AS UP_POSIPI, "
    cQuery += "SB5UP.B5_CONCENT AS UP_CONCENT, SB5UP.B5_DENSID AS UP_DENSID, SD4.D4_QTDEORI AS UP_QTDORI, SB1UP.B1_UM AS UP_UM "
    
    cQuery += "FROM " + ::cSqlNameD3 + " SD3 "
    
    cQuery += "INNER JOIN " + RetSqlName("SF5") + " SF5 "
    cQuery += "ON SF5.F5_FILIAL = '" + FWxFilial("SF5") + "' AND "
    cQuery += "SD3.D3_FILIAL = '" + ::cFilSD3 + "' AND "
    cQuery += "SF5.F5_CODIGO = SD3.D3_TM "
    
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1 "
    cQuery += "ON SB1.B1_FILIAL = '" + ::cFilSB1 + "' AND "
    cQuery += "SD3.D3_COD = SB1.B1_COD "
    
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SB5.B5_FILIAL = '" + ::cFilSB5 + "' AND "
    cQuery += "SB5.B5_COD = SB1.B1_COD "
    
    cQuery += "INNER JOIN " + RetSqlName("SC2") + " SC2 "
    cQuery += "ON SC2.C2_FILIAL = '" + FWxFilial("SC2") + "' AND "
    cQuery += "SC2.C2_NUM " + MatiConcat() + " SC2.C2_ITEM " + MatiConcat() + " SC2.C2_SEQUEN = SD3.D3_OP "
    
    cQuery += "INNER JOIN " + RetSqlName("SD4") + " SD4 "
    cQuery += "ON SD4.D4_FILIAL = '" + FWxFilial("SD4") + "' AND "
    cQuery += "SD4.D4_OP = SD3.D3_OP "
    
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1UP "
    cQuery += "ON SB1UP.B1_FILIAL = '" + ::cFilSB1 + "' AND "
    cQuery += "SB1UP.B1_COD = SD4.D4_COD "
    
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5UP "
    cQuery += "ON SB5UP.B5_FILIAL = '" + ::cFilSB5 + "' AND "
    cQuery += "SB5UP.B5_COD = SB1UP.B1_COD "

    cQuery += "WHERE SD3.D3_CF LIKE 'PR%' AND "
    cQuery += "SD3.D3_OP <> '" + Space(::nTamD3Op) + "' AND "
    cQuery += "SD3.D3_ESTORNO <> 'S' AND "
    cQuery += "SD3.D3_EMISSAO BETWEEN '" + DtoS(::dDataDe) + "' AND '" + DtoS(::dDataAte) + "' AND "
    cQuery += "SB5." + ::cProdPF + " IN ('S', 's') AND "
    cQuery += "SB5UP." + ::cProdPF + " IN ('S', 's') AND "
    cQuery += "SD4.D4_QTDEORI > 0 AND "

    If ::lMapVII
        cQuery += "SB5." + ::cMapVII + " IN ('2', ' ') AND "
        cQuery += "SB5UP." + ::cMapVII + " IN ('2', ' ') AND "
    EndIf

    cQuery += "SB1.B1_GRUPO >= '" + ::cGrupoDe + "' AND SB1.B1_GRUPO <= '" + ::cGrupoAte + "' AND "
    cQuery += "SB1.B1_COD >= '" + ::cProdDe + "' AND SB1.B1_COD <= '" + ::cProdAte + "' AND "

    cQuery += "SB1UP.B1_GRUPO >= '" + ::cGrupoDe + "' AND SB1UP.B1_GRUPO <= '" + ::cGrupoAte + "' AND "
    cQuery += "SB1UP.B1_COD >= '" + ::cProdDe + "' AND SB1UP.B1_COD <= '" + ::cProdAte + "' AND "

    cQuery += "SD3.D_E_L_E_T_ = ' ' AND "
    cQuery += "SF5.D_E_L_E_T_ = ' ' AND "
    cQuery += "SB1.D_E_L_E_T_ = ' ' AND "
    cQuery += "SB5.D_E_L_E_T_ = ' ' AND "
    cQuery += "SC2.D_E_L_E_T_ = ' ' AND "
    cQuery += "SD4.D_E_L_E_T_ = ' ' AND "
    cQuery += "SB1UP.D_E_L_E_T_ = ' ' AND "
    cQuery += "SB5UP.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY SD3.D3_EMISSAO, SD3.D3_NUMSEQ "

    cQuery := ChangeQuery(cQuery)

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasUPUF)

    While !(cAliasUPUF)->(EoF())

        // Definição da UM do registro da subseção UF
        If !Empty(::cCpoUn) .And. !Empty(Alltrim((cAliasUPUF)->&(::cCpoUn))) .And. !Empty(::cCpoFator);
            .And. !Empty((cAliasUPUF)->&(::cCpoFator)) .And. !Empty(::cCpoTpFator) .And. !Empty(Alltrim((cAliasUPUF)->&(::cCpoTpFator)))

            //Conversao da Unidade de Medida atraves do parametro MV_CPOMAPA
            nQuant := ::ConvUMMAPA((cAliasUPUF)->D3_QUANT,(cAliasUPUF)->&(::cCpoFator),(cAliasUPUF)->&(::cCpoTpFator))
            nQuant := Iif(nQuant > 999999999.999, 999999999.999, nQuant)

        Else

            nQuant := Iif((cAliasUPUF)->D3_QUANT > 999999999.999, 999999999.999, (cAliasUPUF)->D3_QUANT)

        EndIf

        // Definição da UM do registro da seção UP
        If !Empty(::cCpoUn) .And. !Empty(Alltrim((cAliasUPUF)->UP_UNMAPA)) .And. !Empty(::cCpoFator);
            .And. !Empty((cAliasUPUF)->UP_CONVMAP) .And. !Empty(::cCpoTpFator) .And. !Empty(Alltrim((cAliasUPUF)->UP_TCONVMA))

            //Conversao da Unidade de Medida atraves do parametro MV_CPOMAPA

            nQuantUP := ((cAliasUPUF)->UP_QTDORI * (cAliasUPUF)->D3_QUANT) / (cAliasUPUF)->C2_QUANT
            nQuantUP := ::ConvUMMAPA(nQuantUP, (cAliasUPUF)->UP_CONVMAP, (cAliasUPUF)->UP_TCONVMA)
            nQuantUP := Iif(nQuantUP > 999999999.999, 999999999.999, nQuantUP)
        
        Else

            nQuantUP := ((cAliasUPUF)->UP_QTDORI * (cAliasUPUF)->D3_QUANT) / (cAliasUPUF)->C2_QUANT
            nQuantUP := Iif(nQuantUP > 999999999.999, 999999999.999, nQuantUP)
        
        EndIf
            
        // Código NCM e concentração do registro da subseção UF
        If ::lPFCompo .And. (cAliasUPUF)->&(::cPFCompo) $ "S/s"   
        
            If !Empty(::cGrupRes) .And. (cAliasUPUF)->B1_GRUPO == ::cGrupRes
            
                cCodNcm := "RS"
        
            Else
            
                cCodNcm := "PC"
            
            EndIf
            
            cCodNcm += Transform((cAliasUPUF)->B1_POSIPI, ::cNcmPic)
            nConcent := 0
    
        Else
        
            If !Empty(::cGrupRes) .And. (cAliasUPUF)->B1_GRUPO == ::cGrupRes
            
                cCodNcm := "RC"
        
            Else
            
                cCodNcm := "PR"
            
            EndIf

            cCodNcm += (cAliasUPUF)->CODMAPAS + (cAliasUPUF)->B1_POSIPI
            nConcent := Iif((cAliasUPUF)->B5_CONCENT > 100, 100, ROUND((cAliasUPUF)->B5_CONCENT, 0))
    
        EndIf

        // Definição da UM do registro da subseção UF
        If (!::lUMSet .And. (cAliasUPUF)->B1_UM != "KG" .And. (cAliasUPUF)->B1_UM != "L ") .Or. (::lUMSet .And. (cAliasUPUF)->&(::cCpoUn) != "KG" .And. (cAliasUPUF)->&(::cCpoUn) != "L ")
            
            cUM := " "
        
        Else
            
            cUM := Iif(::lUMSet, Left((cAliasUPUF)->&(::cCpoUn), 1), Left((cAliasUPUF)->B1_UM, 1))
        
        EndIf

        // Código NCM e concentração do registro da seção UP
        If ::lPFCompo .And. (cAliasUPUF)->UP_PFCOMPO $ "S/s" 
            
            If !Empty(::cGrupRes) .And. (cAliasUPUF)->UP_GRUPO == ::cGrupRes
            
                cCodNcmUP := "RS"
        
            Else
            
                cCodNcmUP := "PC"
        
            EndIf
            
            cCodNcmUP += Transform((cAliasUPUF)->UP_POSIPI, ::cNcmPic)
            nConcentUP := 0
        
        Else

            If !Empty(::cGrupRes) .And. (cAliasUPUF)->UP_GRUPO == ::cGrupRes
            
                cCodNcmUP := "RC"
        
            Else
            
                cCodNcmUP := "PR"
        
            EndIf

            cCodNcmUP += (cAliasUPUF)->UP_CODMAPA + (cAliasUPUF)->UP_POSIPI
            nConcentUP := Iif((cAliasUPUF)->UP_CONCENT > 100, 100, ROUND((cAliasUPUF)->UP_CONCENT, 0))
        
        EndIf

        // Definição da UM do registro da seção UP
        If (!::lUMSet .And. (cAliasUPUF)->UP_UM != "KG" .And. (cAliasUPUF)->UP_UM != "L ") .Or. (::lUMSet .And. (cAliasUPUF)->UP_UNMAPA != "KG" .And. (cAliasUPUF)->UP_UNMAPA != "L ")
            
            cUMUP := " "
    
        Else
            
            cUMUP := Iif(::lUMSet, Left((cAliasUPUF)->UP_UNMAPA, 1), Left((cAliasUPUF)->UP_UM, 1))
        
        EndIf

        nDensid := Iif((cAliasUPUF)->B5_DENSID > 99.99, 99.99, (cAliasUPUF)->B5_DENSID)
        nDensidUP := Iif((cAliasUPUF)->UP_DENSID > 99.99, 99.99, (cAliasUPUF)->UP_DENSID)

        If ::lMvAglut 

            cChaveUF := (cAliasUPUF)->D3_EMISSAO + Left(cCodNcm, 13) + StrZero(nConcent, 3) + StrZero(nDensid, 5, 2) + cUM + (cAliasUPUF)->D3_TM
            cChaveUP := cChaveUF + Left(cCodNcmUP, 13) + StrZero(nConcentUP, 3) + StrZero(nDensidUP, 5, 2) + cUMUP

        Else

            cChaveUF := (cAliasUPUF)->D3_EMISSAO + (cAliasUPUF)->D3_NUMSEQ
            cChaveUP := cChaveUF + (cAliasUPUF)->UP_COD

        EndIf

        // Preenchimento da subseção UF
        If !(cAliasTUF)->(dbSeek(cChaveUF)) 

            cEmissao := SubStr((cAliasUPUF)->D3_EMISSAO, 7, 2) + "/"
            cEmissao += SubStr((cAliasUPUF)->D3_EMISSAO, 5, 2) + "/"
            cEmissao += SubStr((cAliasUPUF)->D3_EMISSAO, 1, 4)

            RecLock(cAliasTUF, .T.)
            (cAliasTUF)->COD := (cAliasUPUF)->D3_COD
            (cAliasTUF)->NUMSEQ	:= (cAliasUPUF)->D3_NUMSEQ
            (cAliasTUF)->TM	:= (cAliasUPUF)->D3_TM
            (cAliasTUF)->TIPO := "UF"
            (cAliasTUF)->CODNCM := cCodNcm
            (cAliasTUF)->CONCENT := nConcent
            (cAliasTUF)->DENSID := nDensid
            (cAliasTUF)->QUANT := nQuant
            (cAliasTUF)->UM := cUM
            (cAliasTUF)->DESCPROD := Iif(::lDescProd, (cAliasUPUF)->&(::cDescProd), (cAliasUPUF)->F5_TEXTO)
            (cAliasTUF)->EMISSAO := CtoD(cEmissao)
            MsUnlock()

        Else

            RecLock(cAliasTUF, .F.)
            If (cAliasTUF)->QUANT + nQuant > 999999999.999
                (cAliasTUF)->QUANT := 999999999.999
            Else
                (cAliasTUF)->QUANT += nQuant
            EndIf
            MsUnlock()

        EndIf

        // Preenchimento da seção UP
        If !(cAliasTUP)->(dbSeek(cChaveUP)) 

            cEmissao := SubStr((cAliasUPUF)->D3_EMISSAO, 7, 2) + "/"
            cEmissao += SubStr((cAliasUPUF)->D3_EMISSAO, 5, 2) + "/"
            cEmissao += SubStr((cAliasUPUF)->D3_EMISSAO, 1, 4)

            RecLock(cAliasTUP, .T.)
            (cAliasTUP)->COD := (cAliasUPUF)->UP_COD
            (cAliasTUP)->CODPAI := (cAliasUPUF)->D3_COD
            (cAliasTUP)->CODNCMPAI := cCodNcm
            (cAliasTUP)->CONCENTPAI := nConcent
            (cAliasTUP)->DENSIDPAI := nDensid
            (cAliasTUP)->UMPAI := cUM
            (cAliasTUP)->NUMSEQ	:= (cAliasUPUF)->D3_NUMSEQ
            (cAliasTUP)->TM	:= (cAliasUPUF)->D3_TM
            (cAliasTUP)->TIPO := "UP"
            (cAliasTUP)->CODNCM := cCodNcmUP
            (cAliasTUP)->CONCENT := nConcentUP
            (cAliasTUP)->DENSID := nDensidUP
            (cAliasTUP)->QUANT := nQuantUP
            (cAliasTUP)->UM := cUMUP
            (cAliasTUP)->EMISSAO := CtoD(cEmissao)
            MsUnlock()

        Else

            RecLock(cAliasTUP, .F.)
            If (cAliasTUP)->QUANT + nQuantUP > 999999999.999
                (cAliasTUP)->QUANT := 999999999.999
            Else
                (cAliasTUP)->QUANT += nQuantUP
            EndIf
            MsUnlock()

        EndIf

        If !::lUP
            ::lUP := .T.
        Endif

        (cAliasUPUF)->(dbSkip())

    End

    (cAliasUPUF)->(dbCloseArea())

Return

/*/{Protheus.doc} ProcessaUC
    Método que preenche a tabela temporária referente à Seção UC.
    Consumos de produtos químicos controlados 
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD ProcessaUC() CLASS MAPAIMCD

    Local cUM := ""
    Local cQuery := ""
    Local cChave := ""
    Local cCodNcm := ""
    Local cEmissao := ""
    Local cAliasUC := GetNextAlias()
    Local cAliasTUC := ::aTrab[TUC_POS][ALIAS_POS]
    Local nQuant := 0
    Local nConcent := 0
    Local nDensid := 0

    cQuery := "SELECT SD3.D3_TM, SD3.D3_NUMSEQ, SD4.D4_COD, SB1.B1_GRUPO, SB1.B1_POSIPI, SB1.B1_UM, SF5.F5_TEXTO, "
    cQuery += "SB5UC.B5_CONCENT, SB5UC.B5_DENSID, SD3.D3_EMISSAO, SD3.D3_QUANT, SC2.C2_QUANT, SD4.D4_QTDEORI, "
    
    cQuery += "SB5UC." + ::cCodMapas + " AS CODMAPAS "

    If ::lUMSet
        cQuery += ", SB5UC." + ::cCpoUn + ", SB5UC." + ::cCpoFator + ", SB5UC." + ::cCpoTpFator + " "
    EndIf
    
    If ::lPFCompo
        cQuery += ", SB5UC." + ::cPFCompo + " "
    EndIf
    
    If ::lDescProd
        cQuery += ", SF5." + ::cDescProd + " "
    EndIf
    
    cQuery += "FROM " + ::cSqlNameD3 + " SD3 "
    
    cQuery += "LEFT JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SD3.D3_FILIAL = '" + ::cFilSD3 + "' AND "
    cQuery += "SB5.B5_FILIAL = '" + ::cFilSB5 + "' AND "
    cQuery += "SB5.D_E_L_E_T_ = ' ' AND "
    cQuery += "SD3.D3_COD = SB5.B5_COD "

    cQuery += "INNER JOIN " + RetSqlName("SD4") + " SD4 "
    cQuery += "ON SD4.D4_FILIAL = '" + FWxFilial("SD4") + "' AND "
    cQuery += "SD4.D4_OP = SD3.D3_OP "

    cQuery += "INNER JOIN " + RetSqlName("SC2") + " SC2 "
    cQuery += "ON SC2.C2_FILIAL = '" + FWxFilial("SC2") + "' AND "
    cQuery += "SC2.C2_NUM " + MatiConcat() + " SC2.C2_ITEM " + MatiConcat() + " SC2.C2_SEQUEN = SD3.D3_OP "
    
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1 "
    cQuery += "ON SB1.B1_FILIAL = '" + ::cFilSB1 + "' AND "
    cQuery += "SB1.B1_COD = SD4.D4_COD "

    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5UC "
    cQuery += "ON SB5UC.B5_FILIAL = '" + ::cFilSB5 + "' AND "
    cQuery += "SB5UC.B5_COD = SB1.B1_COD "

    cQuery += "INNER JOIN " + RetSqlName("SF5") + " SF5 "
    cQuery += "ON SF5.F5_FILIAL = '" + FWxFilial("SF5") + "' AND "
    cQuery += "SF5.D_E_L_E_T_ = ' ' AND "
    cQuery += "SF5.F5_CODIGO = SD3.D3_TM "

    cQuery += "WHERE SD3.D3_CF LIKE 'PR%' AND "
    cQuery += "SD3.D3_ESTORNO <> 'S' AND "
    cQuery += "SD3.D3_EMISSAO BETWEEN '" + DtoS(::dDataDe) + "' AND '" + DtoS(::dDataAte) + "' AND "
    cQuery += "(SB5." + ::cProdPF + " IS NULL OR (SB5." + ::cProdPF + " IS NOT NULL AND SB5." + ::cProdPF + " IN ('N', 'n', ' '))) AND "
    cQuery += "SB5UC." + ::cProdPF + " IN ('S', 's') AND "

    If ::lMapVII
        cQuery += "SB5UC." + ::cMapVII + " IN ('2', ' ') AND "
    EndIf

    cQuery += "SB1.B1_GRUPO >= '" + ::cGrupoDe + "' AND SB1.B1_GRUPO <= '" + ::cGrupoAte + "' AND "
    cQuery += "SB1.B1_COD >= '" + ::cProdDe + "' AND SB1.B1_COD <= '" + ::cProdAte + "' AND "

    cQuery += "SD3.D_E_L_E_T_ = ' ' AND "
    cQuery += "SD4.D_E_L_E_T_ = ' ' AND "
    cQuery += "SC2.D_E_L_E_T_ = ' ' AND "
    cQuery += "SB1.D_E_L_E_T_ = ' ' AND "
    cQuery += "SB5UC.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY SD3.D3_EMISSAO, SD3.D3_NUMSEQ"

    cQuery := ChangeQuery(cQuery)

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasUC)

    (cAliasTUC)->(dbSetOrder(Iif(::lMvAglut, 1, 2)))

    While !(cAliasUC)->(EoF())

        If !Empty(::cCpoUn) .And. !Empty(Alltrim((cAliasUC)->&(::cCpoUn))) .And. !Empty(::cCpoFator);
            .And. !Empty((cAliasUC)->&(::cCpoFator)) .And. !Empty(::cCpoTpFator) .And. !Empty(Alltrim((cAliasUC)->&(::cCpoTpFator)))

            //Conversao da Unidade de Medida atraves do parametro MV_CPOMAPA
            nQuant := ((cAliasUC)->D4_QTDEORI * (cAliasUC)->D3_QUANT) / (cAliasUC)->C2_QUANT
            nQuant := ::ConvUMMAPA(nQuant,(cAliasUC)->&(::cCpoFator),(cAliasUC)->&(::cCpoTpFator))
            nQuant := Iif(nQuant > 999999999.999, 999999999.999, nQuant)

        Else

            nQuant := ((cAliasUC)->D4_QTDEORI * (cAliasUC)->D3_QUANT) / (cAliasUC)->C2_QUANT
            nQuant := Iif((cAliasUC)->D3_QUANT > 999999999.999, 999999999.999, (cAliasUC)->D3_QUANT)

        EndIf

        If ::lPFCompo .And. (cAliasUC)->&(::cPFCompo) $ "S/s"   
            
            If !Empty(::cGrupRes) .And. (cAliasUC)->B1_GRUPO == ::cGrupRes
            
                cCodNcm := "RS"
        
            Else
            
                cCodNcm := "PC"
            
            EndIf
            
            cCodNcm += Transform((cAliasUC)->B1_POSIPI, ::cNcmPic)
            nConcent := 0
    
        Else
        
            If !Empty(::cGrupRes) .And. (cAliasUC)->B1_GRUPO == ::cGrupRes
            
                cCodNcm := "RC"
        
            Else
            
                cCodNcm := "PR"
            
            EndIf

            cCodNcm += (cAliasUC)->CODMAPAS + (cAliasUC)->B1_POSIPI
            nConcent := Iif((cAliasUC)->B5_CONCENT > 100, 100, ROUND((cAliasUC)->B5_CONCENT, 0))
    
        EndIf

        If (!::lUMSet .And. (cAliasUC)->B1_UM != "KG" .And. (cAliasUC)->B1_UM != "L ") .Or. (::lUMSet .And. (cAliasUC)->&(::cCpoUn) != "KG" .And. (cAliasUC)->&(::cCpoUn) != "L ")
            
            cUM := " "
        
        Else
            
            cUM := Iif(::lUMSet, Left((cAliasUC)->&(::cCpoUn), 1), Left((cAliasUC)->B1_UM, 1))
        
        EndIf

        nDensid := Iif((cAliasUC)->B5_DENSID > 99.99, 99.99, (cAliasUC)->B5_DENSID)

        If ::lMvAglut

            cChave := (cAliasUC)->D3_EMISSAO + Left(cCodNcm, 13) + StrZero(nConcent, 3) + StrZero(nDensid, 5, 2) + cUM + (cAliasUC)->D3_TM

        Else

            cChave := (cAliasUC)->D3_EMISSAO + (cAliasUC)->D3_NUMSEQ

        EndIf

        If !(cAliasTUC)->(dbSeek(cChave))
            
            cEmissao := SubStr((cAliasUC)->D3_EMISSAO, 7, 2) + "/"
            cEmissao += SubStr((cAliasUC)->D3_EMISSAO, 5, 2) + "/"
            cEmissao += SubStr((cAliasUC)->D3_EMISSAO, 1, 4)

            RecLock(cAliasTUC, .T.)
            (cAliasTUC)->COD := (cAliasUC)->D4_COD
            (cAliasTUC)->NUMSEQ	:= (cAliasUC)->D3_NUMSEQ
            (cAliasTUC)->TM := (cAliasUC)->D3_TM
            (cAliasTUC)->TIPO := "UC"
            (cAliasTUC)->CODNCM := cCodNcm
            (cAliasTUC)->CONCENT := nConcent
            (cAliasTUC)->DENSID := nDensid
            (cAliasTUC)->QUANT := nQuant
            (cAliasTUC)->UM := cUM
            (cAliasTUC)->CODCONSUMO := 4 // Processo Produtivo - Outros códigos de consumo não serão cobertos no momento 
            (cAliasTUC)->OBSERVACAO := Iif(::lDescProd, (cAliasUC)->&(::cDescProd), (cAliasUC)->F5_TEXTO)
            (cAliasTUC)->EMISSAO := CtoD(cEmissao)
            MsUnlock()

        Else
            
            RecLock(cAliasTUC, .F.)
            If (cAliasTUC)->QUANT + nQuant > 999999999.999
                (cAliasTUC)->QUANT := 999999999.999
            Else
                (cAliasTUC)->QUANT += nQuant
            EndIf
            MsUnlock()

        EndIf

        If !::lUC
            ::lUC := .T.
        EndIf

        (cAliasUC)->(dbSkip())

    End

    (cAliasUC)->(dbCloseArea())

Return

/*/{Protheus.doc} ProcessFab
    Método que preenche a tabela temporária referente à Seção FB.
    Produtos químicos fabricados 
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
    @see (http://www.pf.gov.br/servicos-pf/produtos-quimicos/arquivos-siproquim2/documentos/manual-tecnico.pdf)
/*/
METHOD ProcessFab() CLASS MAPAIMCD

    Local cQuery := ""
    Local cCodNcm := ""
    Local nConcent := ""
    Local cUM := ""
    Local cChave := ""
    Local cEmissao := ""
    Local cAliasFB := GetNextAlias()
    Local cAliasTFB := ::aTrab[TFB_POS][ALIAS_POS]
    Local nQuant := 0  
    Local nDensid := 0

    cQuery := "SELECT SD3.D3_COD, SD3.D3_NUMSEQ, SB1.B1_GRUPO, SB1.B1_POSIPI, SB5.B5_CONCENT, SB5.B5_DENSID, SD3.D3_QUANT, SB1.B1_UM, SD3.D3_EMISSAO, "
    
    cQuery += "SB5." + ::cCodMapas + " AS CODMAPAS " 

    If ::lUMSet
        cQuery += ", SB5." + ::cCpoUn + ", SB5." + ::cCpoFator + ", SB5." + ::cCpoTpFator + " "
    EndIf
    
    If ::lPFCompo
        cQuery += ", SB5." + ::cPFCompo + " "
    EndIf
    
    cQuery += "FROM " + ::cSqlNameD3 + " SD3 "
    cQuery += "INNER JOIN " + ::cSqlNameB1 + " SB1 "
    cQuery += "ON SD3.D3_FILIAL = '" + ::cFilSD3 + "' AND "
    cQuery += "SB1.B1_FILIAL = '" + ::cFilSB1 + "' AND "
    cQuery += "SD3.D3_COD = SB1.B1_COD "
    cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5 "
    cQuery += "ON SB5.B5_FILIAL = '" + ::cFilSB5 + "' AND "
    cQuery += "SB5.B5_COD = SB1.B1_COD "
    cQuery += "LEFT JOIN ( "
        //-- Subquery para identificar produções do mês que consumiram produtos químicos controlados
        cQuery += "SELECT DISTINCT SD4.D4_OP "
        cQuery += "FROM " + RetSqlName("SD4") + " SD4 "
        cQuery += "INNER JOIN " + ::cSqlNameB5 + " SB5 "
        cQuery += "ON SD4.D4_FILIAL = '" + FWxFilial("SD4") + "' AND "
        cQuery += "SB5.B5_FILIAL = '" + ::cFilSB5 + "' AND "
        cQuery += "SD4.D4_COD = SB5.B5_COD "
        cQuery += "INNER JOIN " + ::cSqlNameD3 + " SD3APONT "
        cQuery += "ON SD3APONT.D3_FILIAL = '" + ::cFilSD3 + "' AND "
        cQuery += "SD3APONT.D3_OP = SD4.D4_OP "
        cQuery += "WHERE SD3APONT.D3_CF LIKE 'PR%' AND "
        cQuery += "SD4.D4_QTDEORI > 0 AND "
        cQuery += "SD3APONT.D3_ESTORNO <> 'S' AND "
        cQuery += "SD3APONT.D3_EMISSAO BETWEEN '" + DtoS(::dDataDe) + "' AND '" + DtoS(::dDataAte) + "' AND "
        cQuery += "SB5." + ::cProdPF + " IN ('S', 's') AND "
        cQuery += "SD4.D_E_L_E_T_ = ' ' AND SB5.D_E_L_E_T_ = ' ' AND SD3APONT.D_E_L_E_T_ = ' ' "
    cQuery += ") EXCLUDEDOP ON EXCLUDEDOP.D4_OP = SD3.D3_OP "
    cQuery += "WHERE SD3.D3_CF LIKE 'PR%' AND "
    cQuery += "SD3.D3_OP <> '" + Space(::nTamD3Op) + "' AND "
    cQuery += "SD3.D3_ESTORNO <> 'S' AND "
    cQuery += "SD3.D3_EMISSAO BETWEEN '" + DtoS(::dDataDe) + "' AND '" + DtoS(::dDataAte) + "' AND "
    cQuery += "SB5." + ::cProdPF + " IN ('S', 's') AND "
    
    If ::lMapVII
        cQuery += "SB5." + ::cMapVII + " IN ('2', ' ') AND "
    EndIf

    cQuery += "SB1.B1_GRUPO >= '" + ::cGrupoDe + "' AND SB1.B1_GRUPO <= '" + ::cGrupoAte + "' AND "
    cQuery += "SB1.B1_COD >= '" + ::cProdDe + "' AND SB1.B1_COD <= '" + ::cProdAte + "' AND "

    cQuery += "EXCLUDEDOP.D4_OP IS NULL AND " // Somente produções que não consumiram nenhum Produto Químico controlado
    cQuery += "SD3.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SB5.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY SD3.D3_EMISSAO, SD3.D3_NUMSEQ "

    cQuery := ChangeQuery(cQuery)

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFB)

    (cAliasTFB)->(dbSetOrder(Iif(::lMvAglut, 1, 2)))

    While !(cAliasFB)->(EoF())

        If !Empty(::cCpoUn) .And. !Empty(Alltrim((cAliasFB)->&(::cCpoUn))) .And. !Empty(::cCpoFator);
            .And. !Empty((cAliasFB)->&(::cCpoFator)) .And. !Empty(::cCpoTpFator) .And. !Empty(Alltrim((cAliasFB)->&(::cCpoTpFator)))

            //Conversao da Unidade de Medida atraves do parametro MV_CPOMAPA
            nQuant := ::ConvUMMAPA((cAliasFB)->D3_QUANT,(cAliasFB)->&(::cCpoFator),(cAliasFB)->&(::cCpoTpFator))
            nQuant := Iif(nQuant > 999999999.999, 999999999.999, nQuant)

        Else

            nQuant := Iif((cAliasFB)->D3_QUANT > 999999999.999, 999999999.999, (cAliasFB)->D3_QUANT)

        EndIf

        If ::lPFCompo .And. (cAliasFB)->&(::cPFCompo) $ "S/s"   
            
            If !Empty(::cGrupRes) .And. (cAliasFB)->B1_GRUPO == ::cGrupRes
            
                cCodNcm := "RS"
        
            Else
            
                cCodNcm := "PC"
            
            EndIf
            
            cCodNcm += Transform((cAliasFB)->B1_POSIPI, ::cNcmPic)
            nConcent := 0
    
        Else

            If !Empty(::cGrupRes) .And. (cAliasFB)->B1_GRUPO == ::cGrupRes
            
                cCodNcm := "RC"
        
            Else
            
                cCodNcm := "PR"
            
            EndIf
        
            cCodNcm += (cAliasFB)->CODMAPAS + (cAliasFB)->B1_POSIPI
            nConcent := Iif((cAliasFB)->B5_CONCENT > 100, 100, ROUND((cAliasFB)->B5_CONCENT, 0))
    
        EndIf

        If (!::lUMSet .And. (cAliasFB)->B1_UM != "KG" .And. (cAliasFB)->B1_UM != "L ") .Or. (::lUMSet .And. (cAliasFB)->&(::cCpoUn) != "KG" .And. (cAliasFB)->&(::cCpoUn) != "L ")
            
            cUM := " "
        
        Else
            
            cUM := Iif(::lUMSet, Left((cAliasFB)->&(::cCpoUn), 1), Left((cAliasFB)->B1_UM, 1))
        
        EndIf

        nDensid := Iif((cAliasFB)->B5_DENSID > 99.99, 99.99, (cAliasFB)->B5_DENSID)

        If ::lMvAglut

            cChave := (cAliasFB)->D3_EMISSAO + Left(cCodNcm, 13) + StrZero(nConcent, 3) + StrZero(nDensid, 5, 2) + cUM 

        Else

            cChave := (cAliasFB)->D3_EMISSAO + (cAliasFB)->D3_NUMSEQ

        EndIf

        If !(cAliasTFB)->(dbSeek(cChave)) 

            cEmissao := SubStr((cAliasFB)->D3_EMISSAO, 7, 2) + "/"
            cEmissao += SubStr((cAliasFB)->D3_EMISSAO, 5, 2) + "/"
            cEmissao += SubStr((cAliasFB)->D3_EMISSAO, 1, 4)

            RecLock(cAliasTFB, .T.)
            (cAliasTFB)->COD := (cAliasFB)->D3_COD
            (cAliasTFB)->NUMSEQ	:= (cAliasFB)->D3_NUMSEQ
            (cAliasTFB)->TIPO := "FB"
            (cAliasTFB)->CODNCM := cCodNcm
            (cAliasTFB)->CONCENT := nConcent
            (cAliasTFB)->DENSID := nDensid
            (cAliasTFB)->QUANT := nQuant
            (cAliasTFB)->UM := cUM
            (cAliasTFB)->EMISSAO := CtoD(cEmissao)
            MsUnlock()

        Else

            RecLock(cAliasTFB, .F.)
            If (cAliasTFB)->QUANT + nQuant > 999999999.999
                (cAliasTFB)->QUANT := 999999999.999
            Else
                (cAliasTFB)->QUANT += nQuant
            EndIf
            MsUnlock()

        EndIf

        If !::lFB
            ::lFB := .T.
        Endif

        (cAliasFB)->(dbSkip())

    End

    (cAliasFB)->(dbCloseArea())
    
Return

/*/{Protheus.doc} FirstUpper
    Método que, à partir de uma string, devolve a mesma string com a primeira letra maiúscula e as demais minúsculas.
    Escrita para atender ao requisito de layout do novo MAPAS
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD FirstUpper(cPar) CLASS MAPAIMCD

    Local cFirst := ""
    Local cRest := ""

    If !Empty(cPar)
        cFirst := Upper(SubStr(cPar, 1, 1))
    EndIf

    If Len(cPar) > 1
        cRest := Lower(SubStr(cPar, 2))
    EndIf

Return cFirst + cRest

/*/{Protheus.doc} NomeMes
    Método que, à partir de uma data, devolve a abreviação do mês em letras maiúsculas.
    Escrita para atender ao requisito de layout do novo MAPAS
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD NomeMes(dData) CLASS MAPAIMCD

    Local nMes := Month(dData)
    Local cRet := ""

    Do Case
        Case nMes == 1
            cRet := "JAN"
        Case nMes == 2
            cRet := "FEV"
        Case nMes == 3
            cRet := "MAR"
        Case nMes == 4
            cRet := "ABR"
        Case nMes == 5
            cRet := "MAI"
        Case nMes == 6
            cRet := "JUN"
        Case nMes == 7
            cRet := "JUL"
        Case nMes == 8
            cRet := "AGO"
        Case nMes == 9
            cRet := "SET"
        Case nMes == 10
            cRet := "OUT"
        Case nMes == 11
            cRet := "NOV"
        Case nMes == 12
            cRet := "DEZ"
    EndCase

Return cRet

/*/{Protheus.doc} Destructor
    Método que apaga as tabelas temporárias criadas
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD Destructor() CLASS MAPAIMCD

    Aeval(::aTrab, { |aSub| aSub[OBJECT_POS]:Delete() })

Return
//*------------Especifico IMCD para inclusão de barra de progresso em cada etapa de geração do arquivo--------------*//
/*/{Protheus.doc} GeraTXT
    Método para geração do arquivo magnético do novo MAPAS utilizando as tabelas temporárias montadas durante a construção do objeto
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD GeraTXT(cArqDest, cDir, oProcess) CLASS MAPAIMCD

    Local cMes := ::NomeMes(::dDataDe)
    Local cAno := cValToChar(Year(::dDataDe))
    Local cFil := Iif(::nProcFil == 1, cFilAnt + " - ", "")
    Local nHandle := FCreate(Alltrim(cDir) + cFil + Alltrim(cArqDest),,,.F.)
    Local cLin := ""
    Local cMapas := ""
    Local lRet := .F.

    If nHandle != -1
        
        // Seção EM
        cLin := "EM" + ::cCnpjFil + cMes + cAno
        cMapas += Iif(::lMVN, "1", "0")
        cMapas += "0" // Movimentação Internacional: cenário não coberto no momento
        cMapas += Iif(::lUP, "1", "0")
        cMapas += "0" // Transformação: cenário não coberto no momento
        cMapas += Iif(::lUC, "1", "0")
        cMapas += Iif(::lFB, "1", "0")
        cMapas += Iif(::lTN, "1", "0")
        cMapas += "0" // Transporte Internacional: cenário não coberto no momento
        FWrite(nHandle, cLin + cMapas + CRLF)

        // Seção DG 
        oProcess:incRegua2("Processando seção DG")
        SysRefresh()
        ProcessMessage()
        ::TxtSecDG(nHandle)

        //Seção MVN
        oProcess:incRegua2("Processando seção MVN")
        SysRefresh()
        ProcessMessage()
        ::TxtSecMVN(nHandle)

        //Seção UP
        oProcess:incRegua2("Processando seção UP")
        SysRefresh()
        ProcessMessage()
        ::TxtSecUP(nHandle)

        //Seção UC
        oProcess:incRegua2("Processando seção UC")
        SysRefresh()
        ProcessMessage()
        ::TxtSecUC(nHandle)
        
        //Seção FB
        oProcess:incRegua2("Processando seção FB")
        SysRefresh()
        ProcessMessage()
        ::TxtSecFB(nHandle)

        //Seção TN
        oProcess:incRegua2("Processando seção TN")
        SysRefresh()
        ProcessMessage()
        ::TxtSecTN(nHandle)
        
        FClose(nHandle)
    
        lRet := .T.

    Else

        lRet := .F.
        Help(,,"ERRORFILE",,STR0002 + cValToChar(FError()), 1, 0)
    
    EndIf

Return lRet

/*/{Protheus.doc} TxtSecDG
    Realiza a gravação formatada dos dados referentes à seção DG no arquivo magnético
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD TxtSecDG(nHandle) CLASS MAPAIMCD

    Local cAliasTPR := ::aTrab[TPR_POS][ALIAS_POS]
    Local cAliasTPC := ::aTrab[TPC_POS][ALIAS_POS]
    Local cAliasTSC := ::aTrab[TSC_POS][ALIAS_POS]
    Local cAliasTRC := ::aTrab[TRC_POS][ALIAS_POS]
    Local cAliasTRS := ::aTrab[TRS_POS][ALIAS_POS]
    Local cAliasTRB := ::aTrab[TRB_POS][ALIAS_POS]
    Local cLin := ""

    FWrite(nHandle, "DG" + CRLF)

    If ::lMvAglut
        (cAliasTPR)->(DbSetOrder(1))
    Else
        (cAliasTPR)->(DbSetOrder(2))
    EndIf

    (cAliasTPR)->(DbGoTop())

    // Subseção PR
    While !(cAliasTPR)->(EoF())

        cLin := (cAliasTPR)->TIPO
        cLin += (cAliasTPR)->CODNCM
        cLin += (cAliasTPR)->NOMECOM
        cLin += StrZero((cAliasTPR)->CONCENT, 3)
        cLin += StrTran(StrZero((cAliasTPR)->DENSID, 5, 2), ".", ",")

        FWrite(nHandle, cLin + CRLF)

        (cAliasTPR)->(DbSkip())
    
    End

    (cAliasTPC)->(DbSetOrder(1))
    (cAliasTPC)->(DbGoTop())


    If ::lMvAglut
        (cAliasTSC)->(DbSetOrder(1))
    Else
        (cAliasTSC)->(DbSetOrder(2))
    EndIf

    (cAliasTSC)->(DbGoTop())

    // Subseções PC e SC
    While !(cAliasTPC)->(EoF())

        cLin := (cAliasTPC)->TIPO
        cLin += (cAliasTPC)->NCMCOM
        cLin += (cAliasTPC)->NOMECOM
        cLin += StrTran(StrZero((cAliasTPC)->DENSID, 5, 2), ".", ",")

        FWrite(nHandle, cLin + CRLF)

        While (cAliasTPC)->COD == (cAliasTSC)->CODPAI 

            cLin := (cAliasTSC)->TIPO
            cLin += (cAliasTSC)->CODNCM
            cLin += StrZero((cAliasTSC)->CONCENT, 2)

            FWrite(nHandle, cLin + CRLF)

            (cAliasTSC)->(DbSkip())

        End

        (cAliasTPC)->(DbSkip())

    End

    If ::lMvAglut
        (cAliasTRC)->(DbSetOrder(1))
    Else
        (cAliasTRC)->(DbSetOrder(2))
    EndIf

    (cAliasTRC)->(DbGoTop())

    // Subseção RC
    While !(cAliasTRC)->(EoF())

        cLin := (cAliasTRC)->TIPO
        cLin += (cAliasTRC)->CODNCM
        cLin += (cAliasTRC)->NOMECOM
        cLin += StrZero((cAliasTRC)->CONCENT, 3)
        cLin += StrTran(StrZero((cAliasTRC)->DENSID, 5, 2), ".", ",")

        FWrite(nHandle, cLin + CRLF)

        (cAliasTRC)->(DbSkip())
    
    End

    (cAliasTRS)->(DbSetOrder(1))
    (cAliasTRS)->(DbGoTop())

    If ::lMvAglut   
        (cAliasTRB)->(DbSetOrder(1))
    Else
        (cAliasTRB)->(DbSetOrder(2))
    EndIf

    (cAliasTRB)->(DbGoTop())

    // Subseções RS e RB
    While !(cAliasTRS)->(EoF())

        cLin := (cAliasTRS)->TIPO
        cLin += (cAliasTRS)->NCMCOM
        cLin += (cAliasTRS)->NOMECOM
        cLin += StrTran(StrZero((cAliasTRS)->DENSID, 5, 2), ".", ",")

        FWrite(nHandle, cLin + CRLF)

        While (cAliasTRS)->COD == (cAliasTRB)->CODPAI 

            cLin := (cAliasTRB)->TIPO
            cLin += (cAliasTRB)->CODNCM
            cLin += StrZero((cAliasTRB)->CONCENT, 2)

            FWrite(nHandle, cLin + CRLF)

            (cAliasTRB)->(DbSkip())

        End

        (cAliasTRS)->(DbSkip())

    End

Return

/*/{Protheus.doc} TxtSecMVN
    Realiza a gravação formatada dos dados referentes à seção MVN no arquivo magnético
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD TxtSecMVN(nHandle) CLASS MAPAIMCD

    Local cAliasMVN := ::aTrab[MVN_POS][ALIAS_POS]
    Local cAliasTMM := ::aTrab[TMM_POS][ALIAS_POS]
    Local cAliasTMT := ::aTrab[TMT_POS][ALIAS_POS]
    Local cLin := ""
    Local cChv := ""

    (cAliasMVN)->(DbSetOrder(1))
    (cAliasMVN)->(DbGoTop())

    If ::lMvAglut
        (cAliasTMM)->(DbSetOrder(2))
    Else
        (cAliasTMM)->(DbSetOrder(1))
    EndIf
    (cAliasTMM)->(DbGoTop())

    (cAliasTMT)->(DbSetOrder(1))
    (cAliasTMT)->(DbGoTop())

    // Seção MVN
    While !(cAliasMVN)->(EoF())

        cLin := (cAliasMVN)->TIPO
        cLin += (cAliasMVN)->ENTSAI
        cLin += (cAliasMVN)->OPERACAO
        cLin += (cAliasMVN)->CNPJ
        cLin += (cAliasMVN)->RAZAOSOC
        cLin += (cAliasMVN)->NUMERONF
        cLin += DtoC((cAliasMVN)->EMISSAONF)
        cLin += (cAliasMVN)->ARMAZENAG
        cLin += (cAliasMVN)->TRANSPORT

        FWrite(nHandle, cLin + CRLF)

        cChv := (cAliasMVN)->NUMDOC + (cAliasMVN)->SERIE + (cAliasMVN)->CLIFOR + (cAliasMVN)->LOJA + (cAliasMVN)->ENTSAI + (cAliasMVN)->OPERACAO

        // Subseção MM
        While (cAliasTMM)->NUMDOC + (cAliasTMM)->SERIE + (cAliasTMM)->CLIFOR + (cAliasTMM)->LOJA + (cAliasTMM)->ENTSAI + (cAliasTMM)->OPERACAO == cChv

            cLin := (cAliasTMM)->TIPO
            cLin += (cAliasTMM)->CODNCM
            cLin += Iif(Left((cAliasTMM)->CODNCM, 2) $ "PR/RC", StrZero((cAliasTMM)->CONCENT, 3), "   ") // Só preenche se não for produto composto 
            cLin += StrTran(StrZero((cAliasTMM)->DENSID, 5, 2), ".", ",")
            cLin += PadL(Transform((cAliasTMM)->QUANT, ::cPicQuant), 15)
            cLin += (cAliasTMM)->UM

            FWrite(nHandle, cLin + CRLF)

            (cAliasTMM)->(DbSkip())

        End

        // Subseção MT
        While (cAliasTMT)->NUMDOC + (cAliasTMT)->SERIE + (cAliasTMT)->CLIFOR + (cAliasTMT)->LOJA + (cAliasTMT)->ENTSAI + (cAliasTMT)->OPERACAO == cChv

            cLin := (cAliasTMT)->TIPO
            cLin += (cAliasTMT)->CNPJ
            cLin += (cAliasTMT)->RAZSOC

            FWrite(nHandle, cLin + CRLF)

            (cAliasTMT)->(DbSkip())

        End

        (cAliasMVN)->(DbSkip())
    
    End

Return

/*/{Protheus.doc} TxtSecUP
    Realiza a gravação formatada dos dados referentes à seção UP no arquivo magnético
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD TxtSecUP(nHandle) CLASS MAPAIMCD

    Local cAliasTUP := ::aTrab[TUP_POS][ALIAS_POS]
    Local cAliasTUF := ::aTrab[TUF_POS][ALIAS_POS]
    Local cEmissao := ""
    Local cChaveAnt := ""
    Local cChaveAtu := ""
    Local cLin := ""

    (cAliasTUP)->(dbGoTop())
    (cAliasTUF)->(dbGoTop())

    If ::lMvAglut

        (cAliasTUP)->(dbSetOrder(3))
        (cAliasTUF)->(dbSetOrder(3))

        cChaveAnt := DtoS((cAliasTUP)->EMISSAO) + (cAliasTUP)->CODNCMPAI + StrZero((cAliasTUP)->CONCENTPAI, 3) + StrZero((cAliasTUP)->DENSIDPAI) + Iif(Empty((cAliasTUP)->UMPAI), " ", (cAliasTUP)->UMPAI) + (cAliasTUP)->TM

    Else

        (cAliasTUP)->(dbSetOrder(2))
        (cAliasTUF)->(dbSetOrder(2)) 

        cChaveAnt := DtoS((cAliasTUP)->EMISSAO) + (cAliasTUP)->NUMSEQ     

    EndIf

    While !(cAliasTUP)->(EoF())

        cLin := (cAliasTUP)->TIPO
        cLin += (cAliasTUP)->CODNCM
        cLin += Iif(Left((cAliasTUP)->CODNCM, 2) $ "PR/RC", StrZero((cAliasTUP)->CONCENT, 3), "   ")
        cLin += StrTran(StrZero((cAliasTUP)->DENSID, 5, 2), ".", ",")
        cLin += PadL(Transform((cAliasTUP)->QUANT, ::cPicQuant), 15)
        cLin += (cAliasTUP)->UM

        FWrite(nHandle, cLin + CRLF)

        (cAliasTUP)->(DbSkip())

        If !(cAliasTUP)->(EoF())
        
            If ::lMvAglut
                cChaveAtu := DtoS((cAliasTUP)->EMISSAO) + (cAliasTUP)->CODNCMPAI + StrZero((cAliasTUP)->CONCENTPAI, 3) + StrZero((cAliasTUP)->DENSIDPAI) + Iif(Empty((cAliasTUP)->UMPAI), " ", (cAliasTUP)->UMPAI) + (cAliasTUP)->TM
            Else
                cChaveAtu := DtoS((cAliasTUP)->EMISSAO) + (cAliasTUP)->NUMSEQ
            EndIf

        EndIf
        
        If ((cAliasTUP)->(EoF()) .Or. cChaveAtu != cChaveAnt) .And. !(cAliasTUF)->(EoF())

            cEmissao := DtoS((cAliasTUF)->EMISSAO)
            cEmissao := SubStr(cEmissao, 7, 2) + "/" + SubStr(cEmissao, 5, 2) + "/" + SubStr(cEmissao, 1, 4)

            cLin := (cAliasTUF)->TIPO
            cLin += (cAliasTUF)->CODNCM
            cLin += Iif(Left((cAliasTUF)->CODNCM, 2) $ "PR/RC", StrZero((cAliasTUF)->CONCENT, 3), "   ")
            cLin += StrTran(StrZero((cAliasTUF)->DENSID, 5, 2), ".", ",")
            cLin += PadL(Transform((cAliasTUF)->QUANT, ::cPicQuant), 15)
            cLin += (cAliasTUF)->UM
            cLin += (cAliasTUF)->DESCPROD
            cLin += cEmissao

            FWrite(nHandle, cLin + CRLF)

            (cAliasTUF)->(dbSkip())

        EndIf

        cChaveAnt := cChaveAtu

    End

Return

/*/{Protheus.doc} TxtSecUC
    Realiza a gravação formatada dos dados referentes à seção UC no arquivo magnético
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD TxtSecUC(nHandle) CLASS MAPAIMCD

    Local cLin := ""
    Local cEmissao := ""
    Local cAliasTUC := ::aTrab[TUC_POS][ALIAS_POS]

    If ::lMvAglut
        (cAliasTUC)->(dbSetOrder(1))
    Else
        (cAliasTUC)->(dbSetOrder(2))
    Endif

    (cAliasTUC)->(dbGoTop())

    While !(cAliasTUC)->(EoF())

        cEmissao := DtoS((cAliasTUC)->EMISSAO)
        cEmissao := SubStr(cEmissao, 7, 2) + "/" + SubStr(cEmissao, 5, 2) + "/" + SubStr(cEmissao, 1, 4)

        cLin := (cAliasTUC)->TIPO
        cLin += (cAliasTUC)->CODNCM
        cLin += Iif(Left((cAliasTUC)->CODNCM, 2) $ "PR/RC", StrZero((cAliasTUC)->CONCENT, 3), "   ")
        cLin += StrTran(StrZero((cAliasTUC)->DENSID, 5, 2), ".", ",")
        cLin += PadL(Transform((cAliasTUC)->QUANT, ::cPicQuant), 15)
        cLin += (cAliasTUC)->UM
        cLin += cValToChar((cAliasTUC)->CODCONSUMO)
        cLin += (cAliasTUC)->OBSERVACAO
        cLin += cEmissao

        FWrite(nHandle, cLin + CRLF)        

        (cAliasTUC)->(dbSkip())

    End

Return

/*/{Protheus.doc} TxtSecFB
    Realiza a gravação formatada dos dados referentes à seção FB no arquivo magnético
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD TxtSecFB(nHandle) CLASS MAPAIMCD

    Local cLin := ""
    Local cEmissao := ""
    Local cAliasTFB := ::aTrab[TFB_POS][ALIAS_POS]

    If ::lMvAglut
        (cAliasTFB)->(dbSetOrder(1))
    Else
        (cAliasTFB)->(dbSetOrder(2))
    Endif

    (cAliasTFB)->(dbGoTop())

    While !(cAliasTFB)->(EoF())

        cEmissao := DtoS((cAliasTFB)->EMISSAO)
        cEmissao := SubStr(cEmissao, 7, 2) + "/" + SubStr(cEmissao, 5, 2) + "/" + SubStr(cEmissao, 1, 4)

        cLin := (cAliasTFB)->TIPO
        cLin += (cAliasTFB)->CODNCM
        cLin += Iif(Left((cAliasTFB)->CODNCM, 2) $ "PR/RC", StrZero((cAliasTFB)->CONCENT, 3), "   ")
        cLin += StrTran(StrZero((cAliasTFB)->DENSID, 5, 2), ".", ",")
        cLin += PadL(Transform((cAliasTFB)->QUANT, ::cPicQuant), 15)
        cLin += (cAliasTFB)->UM
        cLin += cEmissao

        FWrite(nHandle, cLin + CRLF)

        (cAliasTFB)->(dbSkip())

    End

Return

/*/{Protheus.doc} TxtSecTN
    Realiza a gravação formatada dos dados referentes à seção TN no arquivo magnético
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD TxtSecTN(nHandle) CLASS MAPAIMCD

    Local cLin := ""
    Local cChave := ""
    Local cEmissao := ""
    Local cRecebimento := ""
    Local cAliasTTN := ::aTrab[TTN_POS][ALIAS_POS]
    Local cAliasTCC := ::aTrab[TCC_POS][ALIAS_POS]
    Local cAliasTTM := ::aTrab[TTM_POS][ALIAS_POS]

    (cAliasTTN)->(dbSetOrder(1))
    (cAliasTTN)->(dbGoTop())

    (cAliasTCC)->(dbSetOrder(1))
    (cAliasTCC)->(dbGoTop())

    If ::lMvAglut
        (cAliasTTM)->(dbSetOrder(2))
    Else
        (cAliasTTM)->(dbSetOrder(1))
    EndIf

    (cAliasTTM)->(dbGoTop())

    While !(cAliasTTN)->(EoF())

        cChave := (cAliasTTN)->NUMDOC + (cAliasTTN)->SERIE + (cAliasTTN)->CLIFOR + (cAliasTTN)->LOJA + (cAliasTTN)->ENTSAI

        cEmissao := DtoS((cAliasTTN)->EMISSAONF)
        cEmissao := SubStr(cEmissao, 7, 2) + "/" + SubStr(cEmissao, 5, 2) + "/" + SubStr(cEmissao, 1, 4)

        cLin := (cAliasTTN)->TIPO
        cLin += (cAliasTTN)->CGCCONTRAT
        cLin += (cAliasTTN)->NOMECONTRA
        cLin += (cAliasTTN)->NUMERONF
        cLin += cEmissao
        cLin += (cAliasTTN)->CGCORIGEM
        cLin += (cAliasTTN)->NOMEORIGEM
        cLin += (cAliasTTN)->RETIRADA
        cLin += (cAliasTTN)->ENTREGA

        FWrite(nHandle, cLin + CRLF)

        While (cAliasTCC)->NUMDOC + (cAliasTCC)->SERIE + (cAliasTCC)->CLIFOR + (cAliasTCC)->LOJA + (cAliasTCC)->ENTSAI == cChave

            cEmissao := DtoS((cAliasTCC)->DATACC)
            cEmissao := SubStr(cEmissao, 7, 2) + "/" + SubStr(cEmissao, 5, 2) + "/" + SubStr(cEmissao, 1, 4)

            cRecebimento := DtoS((cAliasTCC)->DATARECEB)
            cRecebimento := SubStr(cRecebimento, 7, 2) + "/" + SubStr(cRecebimento, 5, 2) + "/" + SubStr(cRecebimento, 1, 4)

            cLin := (cAliasTCC)->TIPO
            cLin += (cAliasTCC)->NUMCC
            cLin += cEmissao
            cLin += cRecebimento
            cLin += (cAliasTCC)->RESPRECEB
            cLin += Alltrim((cAliasTCC)->MODALTRANS)
            
            FWrite(nHandle, cLin + CRLF)

            (cAliasTCC)->(dbSkip())

        End

        While (cAliasTTM)->NUMDOC + (cAliasTTM)->SERIE + (cAliasTTM)->CLIFOR + (cAliasTTM)->LOJA + (cAliasTTM)->ENTSAI == cChave

            cLin := (cAliasTTM)->TIPO
            cLin += (cAliasTTM)->CODNCM
            cLin += Iif(Left((cAliasTTM)->CODNCM, 2) $ "PR/RC", StrZero((cAliasTTM)->CONCENT, 3), "   ")
            cLin += StrTran(StrZero((cAliasTTM)->DENSID, 5, 2), ".", ",")
            cLin += PadL(Transform((cAliasTTM)->QUANT, ::cPicQuant), 15)
            cLin += (cAliasTTM)->UM

            FWrite(nHandle, cLin + CRLF)

            (cAliasTTM)->(dbSkip())

        End

        (cAliasTTN)->(dbSkip())

    End

Return

/*/{Protheus.doc} ConvUMMAPA
    Método para conversão de unidade de medida
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD ConvUMMAPA(nValor, nFatConv, cTpFatorConv) CLASS MAPAIMCD

    Local nRet := 0

    Default nFatConv     := 0
    Default cTpFatorConv := ""

    If (ValType(cTpFatorConv) == 'C' .And. !Empty(cTpFatorConv) ;
        .And. ValType(nFatConv)   == 'N' .And. nFatConv != 0)
        
        If cTpFatorConv == "M"
            
            nRet := nValor * nFatConv
        
        Else
            
            nRet := nValor / nFatConv
        
        EndIf
    
    Else
        
        nRet := nValor
    
    EndIf

Return nRet

/*/{Protheus.doc} GetModalCod
    Método para conversão do código de modal de transporte vindos da SF1 ou SC5.
    Feito para atender requisito de layout do novo MAPAS.
    @type  METHOD
    @author SQUAD Entradas
    @since 01/08/2019
    @version P12.1.25
/*/
METHOD GetModalCod(cEntSai, cCod) CLASS MAPAIMCD

    Local cReturn := ""
    Local nPos := 0 

    If cEntSai == "E"
        
        If !Empty(cCod)

            nPos := aScan(::aModaisSF1, {|x| Alltrim(x[01]) == Alltrim(cCod)})
        
        EndIf

        If nPos > 0

            cReturn := Upper(Left(::aModaisSF1[nPos][2], 2))


        EndIf
    Else

        If !Empty(cCod)

            nPos := aScan(::aModaisSC5, {|x| Alltrim(x[03]) == Alltrim(cCod)})
        
        EndIf

        If nPos > 0

            cReturn := NoAcento(Upper(Left(::aModaisSC5[nPos][4], 2)))

        EndIf

    EndIf

    // Códigos modais aceitos no novo MAPAS
    If !(cReturn $ "RO/AQ/FE/AE")

        cReturn := ""

    Endif

Return cReturn
