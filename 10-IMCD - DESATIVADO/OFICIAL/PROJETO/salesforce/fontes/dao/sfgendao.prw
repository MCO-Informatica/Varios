#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} SFGENDAO
Classe DAO (Data Access Object) genérico utilizado na extração de 
dados para o Sales Force. Esta classe utiliza views para a extração
de dados.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFGENDAO

    method new() constructor
    method getByDay()
    method getBtDates()
    method getByMsExp()
    method viewExists()
    method executeQry()
    method logSetPop()
    method createView()
    method checkChv()
    
    data lJob      as boolean //indica se processamento está sendo realizada via job
    data cViewName as string  //prefixo da view a ser utilizada
    data oSfMod    as object  //objeto do model
    data lEnd      as boolean //flag de cancelamento
    data aLogSet   as array   //array com os registros de log.
    data cChvSF    as string  //chave sales force
    data lOracle   as boolean //indica se o banco de dados é oracle
    data cX2Unico  as string  //x2_unico da tabela
    data cStampMsg as string  //Timestamp para mensagens de erro
    data cTableName as string //Nome da tabela
    data aHeader   as array   //array com o cabeçalho do arquivo
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cViewName , character, prefixo da view a ser utilizado no DAO
@return  object, self
/*/
//-------------------------------------------------------------------
method new (cViewName,cTableName,aLogSet, lJob, lEnd) class SFGENDAO

    default lJob := .T.
    default lEnd := .F.

    //-----------------------------------------------------
    //Atribuição da view a ser utilizado no DAO
    //-----------------------------------------------------
    self:cViewName := cViewName
    self:cTableName := cTableName

    //----------------------------
    //Inicialização de atributos
    //----------------------------
    self:lJob      := lJob                                                  //flag de execução via job
    self:lEnd      := lEnd                                                  //flag de cancelamento do processamento , rotina manual
    self:cStampMsg := "'[SFGENDAO] ['+FwTimeStamp(2,date(),time())+ '] '"   //Timestamp para gravação de mensagem de erro
    self:aLogSet   := aLogSet                                               //Array para gravar o dataset do log ZNP
    self:cChvSF    := alltrim(FWGetSX5 ("Z7", PADR(self:cTableName, tamSx3("X5_CHAVE")[1]))[1][4])  //Verifica na tabela SX5 a chave SF
    self:cX2Unico  := FWX2Unico(self:cTableName )                           //Chave X2_UNICO Protheus
    self:lOracle   := upper(alltrim(TCGetDB())) == "ORACLE"	                //Banco de dados oracle?
    self:aHeader   := {}
return

//-------------------------------------------------------------------
/*/{Protheus.doc} getByDay
description
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getByDay(dDataRef,lOkProc, cMsgErro) class SFGENDAO

    local cScript as character //script de execução

    //-----------------------------------------
    //Execução da view
    //-----------------------------------------
    cScript := " SELECT * FROM "+UPPER(self:cViewName)+" "+CRLF+;
               " WHERE DATA_MOVIMENTO = '"+dtos(dDataRef) +"'  "

    lOkProc := self:executeQry(cScript,@cMsgErro)


return self:oSfMod


//-------------------------------------------------------------------
/*/{Protheus.doc} getBtDates
description
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method getBtDates(dDataIni, dDataFim,lOkProc, cMsgErro) class SFGENDAO

    local cScript as character //script de execução

    //-----------------------------------------
    //Execução da view
    //-----------------------------------------
    cScript := " SELECT * FROM "+UPPER(self:cViewName)+" "+CRLF+;
               " WHERE DATA_MOVIMENTO BETWEEN '"+dtos(dDataIni) +"' AND '"+dtos(dDataFim)+"' "

    lOkProc:= self:executeQry(cScript,@cMsgErro)


return self:oSfMod


method getByMsExp(lOkProc, cMsgErro) class SFGENDAO
    local cScript   as character //script de execução
    local cFilMsExp as character

    cFilMsExp := substr(self:cViewName, 2, 2)+"_MSEXP"
    //-----------------------------------------
    //Execução da view
    //-----------------------------------------
    cScript := " SELECT * FROM "+UPPER(self:cViewName)+" WHERE TRIM("+cFilMsExp+") IS NULL OR TRIM("+cFilMsExp+") = '"+cFilMsExp+"' "

    lOkProc:= self:executeQry(cScript, @cMsgErro,cFilMsExp)


return self:oSfMod

//-------------------------------------------------------------------
/*/{Protheus.doc} executeQry
Execução da query 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cScript, character, script
@param   lOkProc, boolean, sucesso na execução da query
/*/
//-------------------------------------------------------------------
method executeQry(cScript,cMsgErro, cFilMsExp) class SFGENDAO
    local nRegs   as numeric     //Total de registros
    local nIndReg as numeric     //Indice do registro atual
    local lOkProc as logical     //Flag de sucesso no processamento
    local cAliasMod as character //Alias temporário
    local lHeadSep as logical    //View com a header separada do restante da query 
    local cAliasSep as character //Indica quais são os aliases com a header separada.
    local cAliasAux as character //Variável para armazenar temporariamente o alias
    local cAliasHead as character //Alias temporário do cabeçalho
    local cTableName as character //Nome da tabela principal
    local nRegHead   as numeric   //Quantidade de registros da tabela temporária de cabeçalho
    local cChvReg    as character //Chave de aglutinação.
    local lAcumula   as logical   //Indica se deve aglutinar os valores.
    local cChvSeq    as character //chave utilizado na sequencialização de produtos com vários C6_ITEM iguais
    local cSufixo    as character //sufixo do campo ORDERLINEADDRESSKEY
    local cPrefixo   as character //prefixo do campo ORDERLINEADDRESSKEY
    local nPosSub    as numeric   //local o onde deve ser inserido a sequencial da chave ORDERLINEADDRESSKEY
    local nSeq       as numeric   //sequencial do campo ORDERLINEADDRESSKEY
    local cNewCode   as character //novo código.
    local cCampAdic  as character //campo adicional para a chave
    local nPosAdic   as numeric


    cNewCode  := ""
    cCampAdic := ""
    cAliasSep := superGetMv("ES_SFSEPAL", .F., "SD2/")
    cAliasMod := getNextAlias()
    nSeq      := 1
    cChvSeq   := ""
    cTableName := substr(self:cViewName,1,3) 
    lHeadSep := cTableName $ cAliasSep
    //---------------------------
    //Inicialização de variáveis
    //---------------------------
    nIndReg := 1
    nRegs   := 0
    lOkProc := .T.
    nRegHead := 0
    cChvReg  := ""
    lAcumula := .F.

    
    tcRefresh(UPPER(self:cViewName))
    //-----------------------------------------------------------
    //Execução de query
    //-----------------------------------------------------------
    cScript := ChangeQuery(cScript)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cScript),cAliasMod,.F.,.T.)
    
    //-----------------------------------
    //Contagem de registros
    //-----------------------------------
    nRegs := contar(cAliasMod, "!eof()")
    (cAliasMod)->(dbGoTop())
    
    if lHeadSep
        cAliasHead := getNextAlias()
        cScrHead := "SELECT * FROM "+cTableName+"_HEADER"
        cScrHead := ChangeQuery(cScrHead)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cScrHead),cAliasHead,.F.,.T.)

        nRegHead := contar(cAliasHead, "!eof()")
        (cAliasHead)->(dbGoTop())
    else
        cAliasHead := cAliasMod
    endif
    //-----------------------------------------
    //Verifica se a view retornou registros
    //a primeira linha sempre será o cabeçalho
    //por isso deve ser desconsiderada
    //-----------------------------------------
    if nRegs > 1 .or. (nRegs>=1 .and. nRegHead >= 1)
        if !self:lJob
            procRegua(nRegs+1)
        endif
        
        //---------------------------------------------------
        //Inicialização do model
        //---------------------------------------------------
        self:oSfMod  := SFGENMOD():new(self:cViewName, cAliasHead, self:cX2Unico, cFilMsExp, self:aHeader, cAliasMod)
        
        //-----------------------------------------------
        //Pula o primeiro registro , pois ele contém os 
        //dados das colunas que irão no arquivo
        //-----------------------------------------------
        if !lHeadSep
            (cAliasMod)->(dbSkip())
        else
            if self:cTableName == 'SD2'
                nPosAdic := aScan(self:oSfMod:aColumns, {|cColumn| alltrim(upper(cColumn))== 'LOT NUMBER' })
                if nPosAdic > 0 
                    cCampAdic := self:oSfMod:aColumnAux[nPosAdic]
                endif
            endif

            cChvSFTbl := alltrim(self:checkChv())+iif(!empty(cCampAdic),"+"+cCampAdic, "")

        endif
       
        //-------------------------------------------
        //Gravação do dataset
        //-------------------------------------------
        while (cAliasMod)->(!eof()) .and. !self:lEnd .and. nIndReg <= 2000
            if !self:lJob
                IncProc("Processando registro do arquivo "+self:cViewName+": "+alltrim(cValToChar(nIndReg))+"/"+alltrim(cValToChar(nRegs)))
            endif
            if lHeadSep

                if cChvReg <> (cAliasMod)->&(cChvSFTbl)
                    cChvReg := (cAliasMod)->&(cChvSFTbl)
                    lAcumula := .F.
                else
                    lAcumula := .T.
                endif

                //-----------------------------------------------------------------
                //Realiza sequencialização para registros da SD2 com mesmo numero
                //de item do pedido de venda só que com lotes diferentes
                //------------------------------------------------------------------
                if self:cTableName == 'SD2'
                    //Coluna ORDERLINEADDRESSKEY + LOT NUMBER
                    cColumD2 := substr(cChvSFTbl,1,at("+", cChvSFTbl)-1)
                    if cChvSeq <> (cAliasMod)->&(cColumD2)
                        cChvSeq := (cAliasMod)->&(cColumD2)
                        nSeq := 1
                    else
                        //Inserção da sequencial
                        nSeq ++
                        nPosSub := at("__", (cAliasMod)->&(cColumD2))
                        cPrefixo:= substr((cAliasMod)->&(cColumD2) ,1, nPosSub-1)
                        cSufixo := substr((cAliasMod)->&(cColumD2), nPosSub,len((cAliasMod)->&(cColumD2)))
                        cNewCode := cPrefixo+"_"+strzero(nSeq,2)+cSufixo
                    endif
                endif
                 
            endif
            self:oSfMod:setDataSet(lAcumula, cNewCode)
            self:logSetPop(cAliasMod,lAcumula)

            cNewCode := ""
            (cAliasMod)->(dbSkip())
            nIndReg++
        enddo
    else
        lOkProc := .F.
        cMsgErro := iif(self:lJob, &(self:cStampMsg),"")+" Não existem registros para o arquivo "
    endif

    if self:lEnd 
        lOkProc := .F.
        cMsgErro := "Processamento cancelado pelo usuário"
        self:oSfMod:destroy()
        freeObj(self:oSfMod)
    endif

    (cAliasMod)->(dbCloseArea())
    aSize(self:aHeader,0)   
    
return lOkProc
//-------------------------------------------------------------------
/*/{Protheus.doc} viewExists
Verifica se a view existe no banco de dados
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@return  boolean, existe = .T. não existe = .F.
/*/
//-------------------------------------------------------------------
method viewExists() class SFGENDAO

    local cScript as character
    local cAliasView as character
    local lExist   as logical

    cAliasView := getNextAlias()
    if self:lOracle
        cScript := " SELECT COUNT(*) as TOTAL "+CRLF+;
                   " FROM all_views "+CRLF+; 
                   " WHERE view_name = '"+UPPER(self:cViewName)+"' "
    else
        
        cScript := " SELECT COUNT(*) as TOTAL FROM sys.views v "+CRLF+;
                   " INNER JOIN sys.schemas s on v.schema_id = s.schema_id "+CRLF+;
                   " WHERE s.name = 'dbo' and v.name = '"+UPPER(self:cViewName)+"' "
        
    endif

    cScript := ChangeQuery(cScript)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cScript),cAliasView,.F.,.T.)    

    lExist := (cAliasView)->TOTAL > 0

    (cAliasView)->(dbCloseArea())

return lExist

//-------------------------------------------------------------------
/*/{Protheus.doc} createView
Cria a view no banco de dados
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@param   cMsgErro, character, mensagem de erro
@return  boolean, criado com sucesso = .T. não Ok = .F.
/*/
//-------------------------------------------------------------------
method createView(cMsgErro) class SFGENDAO
    local oSfUtils as object
    local cPath    as character
    local lOkProc as logical


    lOkProc := .T.
    oSfUtils := SFUTILS():new()
    cPath := oSfUtils:getViewPth()

    cViewExec := MemoRead( cPath+"\"+UPPER(self:cViewName)+".sql")

    if !empty(cViewExec)
        if tcSqlExec(cViewExec) < 0
            lOkProc:= .F.
            cMsgErro := "Erro na criação da view "+self:cViewName()+CRLF+TcSqlError()
        endif
    else
        lOkProc:= .F.
        cMsgErro := "Erro na criação da view: arquivo "+self:cViewName()+".sql  não encontrado"        
    endif

return lOkProc

//-------------------------------------------------------------------
/*/{Protheus.doc} logSetPop
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
method logSetPop(cAliasMod, lAcumula) class SFGENDAO
    local aAuxLog as array
    local cTableName as character
    local aX2Unico as array
    local cChvSFTbl as character
    local nPosChvSF as numeric
    private cAliasChv as character
    private cChvLog as character
    private cDisp   as character
    default lAcumula := .F.  

    cAliasChv := cAliasMod
    cChvLog := ""
    cDisp   := ""

    
    if !lAcumula
        aAuxLog := {}
        nUltReg := len(self:aLogSet)
        aX2Unico := StrTokArr(self:cX2Unico,"+")
        aEval(aX2Unico, {|cX2Unico| cChvLog += PADR((cAliasChv)->&(cX2Unico), tamSx3(cX2Unico)[1])})
        
        aadd(aAuxLog, {"ZNP_LINE"  , nUltReg+1})  //Linha do arquivo

        aadd(aAuxLog, {"ZNP_CHVPRT", (cAliasChv)->RECNUMBER}) //Chave do registro no Protheus

        aEval(aX2Unico, {|cX2Unico| cDisp += alltrim(FWSX3Util():GetDescription( cX2Unico ))+":"+PADR((cAliasChv)->&(cX2Unico), tamSx3(cX2Unico)[1])+" / "})
        aadd(aAuxLog, {"ZNP_DISPLY", cDisp}) //Chave do registro no Protheus


        cChvSFTbl := self:checkChv()
        if !empty(cChvSFTbl)
            aadd(aAuxLog, {"ZNP_CHVSF" , (cAliasMod)->&(cChvSFTbl)}) //Chave do registro no arquivo SF
        endif

        aadd(aAuxLog, {"ZNP_STATUS", "1"}) //Status 

        aadd(self:aLogSet, aClone(aAuxLog))
        aSize(aAuxLog,0)
    else
        nUltReg := len(self:aLogSet)
        if nUltReg >= 1
            self:aLogSet[nUltReg][2][2] := alltrim(self:aLogSet[nUltReg][2][2])+"/"+alltrim((cAliasChv)->RECNUMBER)
        endif
    endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} checkChv
Verifica o nome do campo da chave Sales Force.
@author  marcio.katsumata
@since   13/08/2019
@version 1.0
@return  character, nome do campo
/*/
//-------------------------------------------------------------------
method checkChv() class SFGENDAO
    local nPosChvSF as numeric   //posição do campo
    local cFieldRet as character //nome do campo

    nPosChvSF := 0
    cFieldRet := ""

    if !empty(self:cChvSF)
    
        if "|" $ self:cChvSF
            self:cChvSF := substr(self:cChvSF,1,at("|", self:cChvSF)-1)
        endif
        
        nPosChvSF := aScan(self:aHeader[2], {|cColumn| upper(alltrim(cColumn)) == upper(alltrim(self:cChvSF)) })
        
        
        if nPosChvSF == 0
            self:cChvSF := strtran(self:cChvSF,"__C", "")
            nPosChvSF := aScan(self:aHeader[2], {|cColumn| upper(alltrim(cColumn)) == upper(alltrim(self:cChvSF)) })
        endif
        
        if nPosChvSF > 0
            cFieldRet := alltrim(self:aHeader[1][nPosChvSF])
        endif
    endif

return cFieldRet


user function sfgendao()
return
