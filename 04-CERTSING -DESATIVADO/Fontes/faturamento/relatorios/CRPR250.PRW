#INCLUDE "PROTHEUS.CH"

#DEFINE CRLF CHR(13) + CHR(10)

#DEFINE GERA_CSV    1
#DEFINE GERA_EXCEL  2
#DEFINE GERA_EMAIL  3

/*/{Protheus.doc} CRPR250
Relat?rio para extra??o de pedidos referentes aos produtos SAGE e SinteseNET para 
remunera??o de parceiros.

@author     yuri.volpe
@since      14/07/2021
@version    1.0

@param      null
@return     null
*/
User Function CRPR250()

    Local cPeriodo  := AllTrim(GetMV("MV_REMMES"))
    Local cProduto  := ""
    Local cDataDe   := ""
    Local cDataAte  := ""
    Local cDir      := ""
    Local lSage     := .F.

    Private cPrefixo    := ""
    Private cNomeArq    := ""
    Private oQuery      := Nil

    // Cria Parambox para parametriza??o
    oParambox := CSParambox():New()
    oParambox:addCombo("PRODUTO","Selecione o Produto", {"1-SAGE","2-SINTESE NET"})
    oParambox:addInput("PERIODO","Per?odo", cPeriodo)
    oParambox:addRadio("EXTRACAO","Gerar relat?rio", {"CSV","Excel","E-Mail"})
    oParambox:addFile("DIRETORIO","Diret?rio", "Todos os arquivos (*.*) |*.*", "C:\", GETF_RETDIRECTORY+GETF_LOCALHARD)
    oParambox:addInput("EMAIL","Destinat?rio", Space(150), "")
    oParambox:show()

    // Se o Parambox foi cancelado, interrompe execu??o
    If !oParambox:hasData()
        Return
    EndIf

    // Carga de vari?veis
    lSage       := oParambox:getValueByLabel("PRODUTO") == 1        // Flag para indicar se deve extrair SAGE ou SINTESENET
    cPeriodo    := oParambox:getValueByLabel("PERIODO")             // Per?odo de Remunera??o a ser considerado
    cDataDe     := cPeriodo + "01"                                  // Monta a "data de" baseada do per?odo informado
    cDataAte    := DTOS(LastDay(STOD(cDataDe)))                     // Monta a "data at?" baseada no per?odo informado
    nOpcGera    := oParambox:getValueByLabel("EXTRACAO")            // Op??o selecionada no Radio Box
    cDir        := AllTrim(oParambox:getValueByLabel("DIRETORIO"))  // Diret?rio informado para grava??o do CSV
    cEmailDest  := oParambox:getValueByLabel("EMAIL")

    // Trata diret?rio padr?o
    cTempPath := GetTempPath() 
    If Empty(cDir) .And. nOpcGera == GERA_CSV
        cDir := Substr(cTempPath, 1, at("\AppData", cTempPath)) + "Documents\"
    EndIf

    // Defini??o do produto
    If lSage
        cProduto := "SRFA1PJEMISSORSAGEHV5"
        cPrefixo := "SAGE"
    Else
        cProduto := "OABA3PFISCIOB1AHV5"
        cPrefixo := "SINTESENET"
    EndIf

    // Nome do Arquivo CSV que ser? gerado
    cNomeArq    := cPrefixo + "_" + NomeDoMes(Substr(cPeriodo,5,2)) + "." + Substr(cPeriodo,3,2) + ".csv"

    // Executa Query e d? o devido tratamento para extra??o
    oQuery := CSQuerySQL():New()
    If oQuery:Consultar(montaQuery(cProduto, cDataDe, cDataAte))
        Do Case
            Case nOpcGera == GERA_CSV   ; Processa({|| criaCSV(cDir + cNomeArq)}, "Gera??o CSV", "Aguarde enquanto o arquivo CSV ? gerado.", .F.)
            Case nOpcGera == GERA_EXCEL ; Processa({|| criaExcel() }, "Gera??o Excel", "Aguarde enquanto o Excel ? gerado.", .F.)
            Case nOpcGera == GERA_EMAIL ; enviaEmail(cEmailDest)
        EndCase
        oQuery:Close()
    Else
        MsgInfo("N?o foram encontrados dados para o per?odo e produto selecionados.")
    EndIf

Return

/*/{Protheus.doc} MontaQuery
Fun??o est?tica respons?vel por montar a query de extra??o do relat?rio.
Caso o retorno seja .T., a ?rea estar? aberta com os dados carregados.

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Static Function

@param      cProduto (string)   C?digo do Produto que ser? utilizado para extra??o
@param      cDataDe (string)    Data a partir da qual ser?o considerados os pedidos emitidos
@param      cDataAte (string)   Data at? a qual ser?o considerados os pedidos emitidos 
@return     lHasData (bool)     Informa se h? dados recuperados pela query executada
*/
Static Function MontaQuery(cProduto, cDataDe, cDataAte)

    Local cQuery := ""

    cQuery := "    SELECT DISTINCT " + CRLF
    cQuery += "         Z5_PEDGAR PEDIDO_GAR," + CRLF
    cQuery += "         C5_XNPSITE PEDIDO_SITE," + CRLF
    cQuery += "         SUBSTR(Z5_DATEMIS,7,2)||'/'||SUBSTR(Z5_DATEMIS,5,2)||'/'||SUBSTR(Z5_DATEMIS,1,4) AS DATA_EMISSAO," + CRLF
    cQuery += "         Z3_CODENT COD_ENT," + CRLF
    cQuery += "		 Z3_DESENT DESC_ENT," + CRLF
    cQuery += "		 Z5_NOMAGE AGENTE_VAL," + CRLF
    cQuery += "		 Z5_PRODGAR PRODUTO_GAR," + CRLF
    cQuery += "		 PA8_DESBPG DESC_PROD," + CRLF
    cQuery += "		 CASE " + CRLF
    cQuery += "			WHEN Z5_TIPO = 'VERIFI' THEN 'VERIFICADO' " + CRLF
    cQuery += "			WHEN Z5_TIPO = 'VALIDA' THEN 'VALIDADO'" + CRLF
    cQuery += "			WHEN Z5_TIPO = 'EMISSA' THEN 'EMITIDO'" + CRLF
    cQuery += "		 END STATUS_PEDIDO," + CRLF
    cQuery += "		 Z5_EMISSAO DATA_PEDIDO," + CRLF
    cQuery += "		 Z5_DATVAL DT_VALIDA," + CRLF
    cQuery += "		 Z5_DATVER DT_VERIFI," + CRLF
    cQuery += "		 Z5_DATEMIS DT_EMISSAO," + CRLF
    cQuery += "		 Z5_NTITULA TITULAR," + CRLF
    cQuery += "		 Z5_PEDGANT PED_ANTERIOR," + CRLF
    cQuery += "		 CASE WHEN Z5_PEDGANT > ' ' THEN (SELECT SZ5B.Z5_EMISSAO FROM SZ5010 SZ5B WHERE SZ5B.Z5_FILIAL = SZ5.Z5_FILIAL AND SZ5B.Z5_PEDGAR = SZ5.Z5_PEDGAR) ELSE '' END DT_PEDANT," + CRLF
    cQuery += "		 CASE WHEN Z3_CODCCR > ' ' THEN (SELECT SZ3B.Z3_CODAC FROM SZ3010 SZ3B WHERE SZ3B.Z3_FILIAL = SZ3.Z3_FILIAL AND SZ3B.Z3_CODENT = SZ3.Z3_CODCCR AND SZ3B.D_E_L_E_T_ = ' ') ELSE SZ3.Z3_CODAC END DESC_CCR," + CRLF
    cQuery += "		 CASE WHEN Z3_CODCCR > ' ' THEN (SELECT SZ3B.Z3_DESAC FROM SZ3010 SZ3B WHERE SZ3B.Z3_FILIAL = SZ3.Z3_FILIAL AND SZ3B.Z3_CODENT = SZ3.Z3_CODCCR AND SZ3B.D_E_L_E_T_ = ' ') ELSE SZ3.Z3_DESAC END DESC_CCR," + CRLF
    cQuery += "		 Z5_DESGRU DESC_GRUPO" + CRLF
    cQuery += "    FROM SZ5010 SZ5" + CRLF
    cQuery += "         LEFT JOIN SC6010 " + CRLF
    cQuery += "             ON C6_PEDGAR = Z5_PEDGAR " + CRLF
    cQuery += "         LEFT JOIN SC5010 " + CRLF
    cQuery += "             ON C5_NUM = C6_NUM" + CRLF
    cQuery += "		 INNER JOIN SZ3010 SZ3" + CRLF
    cQuery += "			 ON Z3_CODGAR = Z5_CODPOS" + CRLF
    cQuery += "			 AND Z3_FILIAL = ' '" + CRLF
    cQuery += "			 AND SZ3.D_E_L_E_T_ = ' '" + CRLF
    cQuery += "		 INNER JOIN PA8010 PA8 " + CRLF
    cQuery += "			 ON PA8_CODBPG = Z5_PRODGAR" + CRLF
    cQuery += "			 AND PA8_FILIAL = ' ' " + CRLF
    cQuery += "			 AND PA8.D_E_L_E_T_ = ' '" + CRLF
    cQuery += "    WHERE " + CRLF
    cQuery += "         SZ5.Z5_FILIAL = '  '" + CRLF
    cQuery += "     AND SZ5.Z5_DATEMIS >= '" + cDataDe + "' AND SZ5.Z5_DATEMIS <= '" + cDataAte + "'" + CRLF
    cQuery += "     AND SZ5.Z5_PRODGAR = '" + cProduto + "'" + CRLF
    cQuery += "     AND SZ5.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += "    ORDER BY Z5_DATEMIS,Z5_PEDGAR " 

Return cQuery

/*/{Protheus.doc} criaExcel
Fun??o est?tica respons?vel por gerar o Excel com a extra??o dos dados.

@author     yuri.volpe
@since      24/05/2021
@version    1.0
@type       Static Function

@param      null
@return     null
*/
Static Function criaExcel()

    Local aCabec := getHeader()
    Local aDados := {}

    ProcRegua(oQuery:total)

    // Recupera as linhas da query em array para gera??o do Excel
    While oQuery:hasNext()
        IncProc()
        aAdd(aDados, oQuery:getLineArray())
    EndDo

    // Apresenta MSAGUARDE para gera??o do Excel
    MsAguarde( {|| DlgToExcel({ {"ARRAY","Relat?rio " + cPrefixo, aCabec, aDados} }) }, "Rela??o de Produtos " + cPrefixo, "Aguarde, exportando para Excel...",.T.)

Return

/*/{Protheus.doc} criaCSV
Fun??o est?tica respons?vel por gerar o arquivo CSV com a extra??o dos dados.

@author     yuri.volpe
@since      24/05/2021
@version    1.0
@type       Static Function

@param      cArquivo (string)   Nome do arquivo que ser? gerado o CSV
@return     lGerado (bool)      Informa se o arquivo foi gerado
*/
Static Function criaCSV(cArquivo, lEmail)

    Local cSeparador    := ";"
    Local oArquivo      := Nil

    DEFAULT lEmail := .F.

    // Alimenta a r?gua de processamento
    ProcRegua(oQuery:total)

    // Cria o arquivo no caminho indicado
    oArquivo := FileOutputStream():New(cArquivo)

    // Checa se o arquivo foi criado    
    If oArquivo:lCreated
    
        // Recupera o Header em String separado por ponto-e-v?rgula
        oArquivo:writeLine(ArrToStr(getHeader(), cSeparador))

        // Grava o Header
        While oQuery:hasNext()

            // Incrementa a r?gua de processamento
            IncProc()

            // Grava a linha
            oArquivo:writeLine(oQuery:getLineString(cSeparador, .F.))

        EndDo

        oArquivo:Close()

    EndIf

    If !lEmail
        If File(cArquivo)
            MsgInfo("Arquivo criado com sucesso. " + CRLF + "Local: " + cArquivo,"Relat?rio " + cPrefixo)
        Else
            Alert("N?o foi poss?vel gerar o arquivo.")
        EndIf
    EndIf

Return File(cArquivo)

/*/{Protheus.doc} enviaEmail
Dispara o e-mail com o arquivo CSV gerado, usando a fun??o geraCSV.

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Static Function

@param      null
@return     null
*/
Static Function enviaEmail(cEmailDest)

    Local oMail
    Local lGeraArq  := .F.
    Local cTmpDir   := GetTempPath()

    // Cria CSV para envio por e-mail
    Processa( {|| lGeraArq := criaCSV(cTmpDir + cNomeArq, .T.) }, "Gerando CSV " + cPrefixo, "Aguarde, gerando arquivo CSV...",.T.)

    If lGeraArq
        
        // Instancia Classe CSMailSender para disparo de e-mail
        oMail := CSMailSender():New()
        
        // Anexa o arquivo gerado ? mensagem
        If oMail:Attach(cTmpDir + cNomeArq)
            oMail:setMailSubject("Relat?rio " + cPrefixo)
            oMail:setMailBody("Extra??o pedidos Produto " + cPrefixo + " - " + DTOC(Date()) + " " + Time())
            oMail:setMailDestinatario(cEmailDest)
            If !oMail:sendMail()
                Alert(oMail:cMailStatus)
            Else
                MsgInfo("E-Mail enviado com sucesso.")
            EndIf
            oMail:Disconnect()
        EndIf

        // Deleta o arquivo tempor?rio
        fErase(cTmpDir + cNomeArq)

    EndIf

Return

/*/{Protheus.doc} nomeDoMes
Fun??o est?tica respons?vel por retornar o nome do m?s por extenso

@author     yuri.volpe
@since      14/07/2021
@version    1.0
@type       Static Function

@param      cMes (string)       N?mero do m?s para retornar seu nome
@return     cNomeMes (string)   Nome do m?s informado no par?metro
*/
Static Function NomeDoMes(cMes)

    // Trata estrutura do par?metro, para valida??o no Case
    If ValType(cMes) != "C"
        cMes := StrZero(cMes,2)
    ElseIf ValType(cMes) == "C" .And. Len(cMes) < 2
        cMes := PadL(cMes,2,"0")
    EndIf

    Do Case
        Case cMes == "01"; Return "Janeiro"
        Case cMes == "02"; Return "Fevereiro"
        Case cMes == "03"; Return "Mar?o"
        Case cMes == "04"; Return "Abril"
        Case cMes == "05"; Return "Maio"
        Case cMes == "06"; Return "Junho"
        Case cMes == "07"; Return "Julho"
        Case cMes == "08"; Return "Agosto"
        Case cMes == "09"; Return "Setembro"
        Case cMes == "10"; Return "Outubro"
        Case cMes == "11"; Return "Novembro"
        Case cMes == "12"; Return "Dezembro"
    EndCase

Return ""

/*/{Protheus.doc} getHeader
Monta o Header do relat?rio num array para tratamento externo

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      null
@return     aCabec (array)  Array com o cabe?alho do relat?rio
*/
Static Function getHeader()

    Local aCabec := {}

    aAdd(aCabec, "Pedido GAR")
    aAdd(aCabec, "Pedido Site")
    aAdd(aCabec, "Data Emiss?o")
    aAdd(aCabec, "Cod.Ent.")
    aAdd(aCabec, "Des. Entidade")
    aAdd(aCabec, "Desc. Agente Val.")
    aAdd(aCabec, "C?d. Produto")
    aAdd(aCabec, "Desc.Produto")
    aAdd(aCabec, "Pedido")
    aAdd(aCabec, "Status Pedido")
    aAdd(aCabec, "Dt.Pedido")
    aAdd(aCabec, "Dt.Valida??o")
    aAdd(aCabec, "Dt.Verifica??o")
    aAdd(aCabec, "Dt.Emiss?o / Renova??o")
    aAdd(aCabec, "Nome Cliente")
    aAdd(aCabec, "Ped. Anterior")
    aAdd(aCabec, "Dt.Pedido Anterior")
    aAdd(aCabec, "Desc. CCR")
    aAdd(aCabec, "C?d. AC")
    aAdd(aCabec, "Desc. AC")
    aAdd(aCabec, "Desc. Grupo")

    // Contagem Geral; Contagem Soft .; Contagem Hard .	    

Return aCabec

/*/{Protheus.doc} ArrToStr
Quebra o array passado em uma string com o delimitador indicado.

@author     yuri.volpe
@since      24/05/2021
@version    1.0

@param      aArray (array)         Array com dados que ser? quebrado em string
@param      cSeparador (string)    Caractere usado como separador da string
@return     cString (string)       String com o array quebrado e concatenado 
*/
Static Function ArrToStr(aArray, cSeparador)

    Local Ni := 1
    Local cString := ""

    For Ni := 1 To Len(aArray)
        cString += aArray[Ni] + cSeparador
    Next

Return cString


/*Class CSLinhaRelSage

    Data cPedidoGAR
    Data cPedidoSite
    Data dDtPedProt
    Data cCodEntidade
    Data cDescEntidade
    Data cAgValida
    Data cProdutoGAR
    Data cDescProduto
    Data cStatus
    Data dDtPedido
    Data dDtValida
    Data dDtVerifi
    Data dDtEmissao
    Data cTitular
    Data cPedAnterior
    Data dDtPedAnt
    Data cCodCCR
    Data cDescCCR
    Data cGrupo

    Method New() Constructor
    Method feed(cAlias)

EndClass

Method New() Class CSLinhaRelSage
Return

Method feed(cAlias) Class CSLinhaRelSage
    ::cPedidoGAR := (cAlias)->PEDIDO_GAR
    ::cPedidoSite := (cAlias)->PEDIDO_SITE
    ::dDtPedProt := (cAlias)->DATA_EMISSAO
    ::cCodEntidade := (cAlias)->COD_ENT
    ::cDescEntidade := (cAlias)->DESC_ENT
    ::cAgValida := (cAlias)->AGENTE_VAL
    ::cProdutoGAR := (cAlias)->PRODUTO_GAR
    ::cDescProduto := (cAlias)->DESC_PROD
    ::cStatus := (cAlias)->STATUS_PEDIDO
    ::dDtPedido := (cAlias)->DATA_PEDIDO
    ::dDtValida := (cAlias)->DT_VALIDA
    ::dDtVerifi := (cAlias)->DT_VERIFI
    ::dDtEmissao := (cAlias)->DT_EMISSAO
    ::cTitular := (cAlias)->TITULAR
    ::cPedAnterior := (cAlias)->PED_ANTERIOR
    ::dDtPedAnt := (cAlias)->DT_PEDANT
    ::cCodCCR := (cAlias)->COD_CCR
    ::cDescCCR := (cAlias)->DESC_CCR
    ::cGrupo := (cAlias)->DESC_GRUPO
Return

*/
