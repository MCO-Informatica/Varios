#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

User Function RFINA03()

    Processa({||Clientes()},"Baixas Cartao Crédito/Débito")
Return

Static Function Clientes()


    dbSelectArea("SE1")
    dbSetOrder(7)
    dbGoTop()

    ProcRegua(RecCount())
    While Eof() == .f.

        IncProc("Processando Titulo: "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA)

        If SE1->E1_SALDO == 0
            dbSkip()
            Loop
        EndIf

        If !ALLTRIM(SE1->E1_FORMAPG)$"CC.CD.CH.DA.DH.R$.TR"
            dbSkip()
            Loop
        EndIf

        If DTOS(SE1->E1_VENCTO) > '20191231'
            dbSkip()
            Loop
        EndIf

        _aCabec      := {}
        Aadd(_aCabec, {"E1_PREFIXO"      , SE1->E1_PREFIXO          , nil})
        Aadd(_aCabec, {"E1_NUM"          , SE1->E1_NUM              , nil})
        Aadd(_aCabec, {"E1_PARCELA"      , SE1->E1_PARCELA          , nil})
        Aadd(_aCabec, {"E1_TIPO"         , SE1->E1_TIPO             , nil})
        Aadd(_aCabec, {"E1_CLIENTE"      , SE1->E1_CLIENTE          , nil})
        Aadd(_aCabec, {"E1_LOJA"         , SE1->E1_LOJA             , nil})
        AADD(_aCabec, {"AUTBANCO"        , "CX1"                    , Nil})
        AADD(_aCabec, {"AUTAGENCIA"      , "00001"                  , Nil})
        AADD(_aCabec, {"AUTCONTA"        , "0000000001"             , Nil})
        Aadd(_aCabec, {"AUTMOTBX"        , "NOR"                    , nil})
        Aadd(_aCabec, {"AUTDTBAIXA"      , dDataBase                , nil})
        Aadd(_aCabec, {"AUTDTCREDITO"    , dDataBase                , nil})
        Aadd(_aCabec, {"AUTHIST"         , "BAIXA CARTAO/DINHEIRO"  , nil})
        Aadd(_aCabec, {"AUTVALREC"       , SE1->E1_VALOR            , nil})

        lMsErroAuto := .F.
        Begin Transaction
            MSExecAuto({|x,y| fina070(x,y)},_aCabec,3) //3-Inclusao
            IF lMsErroAuto
                DisarmTransaction()
                Break
            Else
                // sucesso
            EndIf
        End Transaction

        IF lMsErroAuto
            MostraErro()
        EndIf

        dbSelectArea("SE1")
        dbSkip()
    EndDo

Return