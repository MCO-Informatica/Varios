#Include "Totvs.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBA005  บAutor  ณLucas               บ Data ณ  14/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para importacao de lan็amentos contabeis de despesa บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBA005
    local 		_aCab			:= {}
    local		_aItem			:= {}
    local		_aItens			:= {}
    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.
    Private CTF_LOCK := 0
    Private lSubLote := .T.
    Private cPerg	:= "RCTBA005"

    // RPCSetType( 3 )						// Nใo consome licensa de uso
    // PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01 " MODULO "CTB" TABLES "CT2"
    ApMsgInfo("Data: Define o periodo de lan็amento e a busca do balancete para base dos valores. Trabalha em conjunto a moeda e o tipo de saldo."+Chr(13)+Chr(10)+;
        "Serแ gerada contabiliza็ใo de transferencia de valores entre centros de custo. Serแ utilizada a conta contabil transitoria 529999991."+Chr(13)+Chr(10)+;
        "Moeda"+Chr(13)+Chr(10)+;
        "Moeda utilizada para obter o balancete e gerar o lan็amento na mesma. Trabalha em conjunto a data e o tipo de saldo"+Chr(13)+Chr(10)+;
        "Tipo de Saldo"+Chr(13)+Chr(10)+;
        "Tipo de Saldo utilizado para obter o balancete e gerar o lan็amento na mesma. Trabalha em conjunto a data e a moeda.")
    If Pergunte(cPerg,.T.)
        //        RETURN
        //    Else
        Processa({||Importar(),"Gerando Rateio..."})
    EndIf

Return

User function RCTBS005
    local 		_aCab			:= {}
    local		_aItem			:= {}
    local		_aItens			:= {}
    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.
    Private CTF_LOCK := 0
    Private lSubLote := .T.
    Private cPerg	:= "RCTBA005"
    RPCSetType( 3 )						// Nใo consome licensa de uso
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01 " MODULO "CTB" TABLES "CT2"
    MV_PAR01 := STOD('20210930')
    MV_PAR02 := "05"
    MV_PAR03 := "1"
    Processa({||Importar(),"Gerando Rateio..."})

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBC001  บAutor  ณMicrosiga           บ Data ณ  14/05/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importar()
    Local _xx
    // MV_PAR01 := STOD('20210930')
    // MV_PAR02 := "05"
    // MV_PAR03 := "2"
    dDataBase := mv_par01

    cNumlote := SUBSTR(dtos(mv_par01),5,2)+SUBSTR(dtos(mv_par01),1,4)
    aCab := {}

    aAdd(aCab, {'DDATALANC' ,MV_PAR01 ,NIL} )
    aAdd(aCab, {'CLOTE' ,cNumLote ,NIL} )
    aAdd(aCab, {'CSUBLOTE' ,'001' ,NIL} )
    //        aAdd(aCab, {'CDOC' ,'000001' ,NIL} )
    aAdd(aCab, {'CPADRAO' ,'' ,NIL} )
    aAdd(aCab, {'NTOTINF' ,0 ,NIL} )
    aAdd(aCab, {'NTOTINFLOT' ,0 ,NIL} )

    _aParms := {}
    AADD(_aParms,{"01","1"})
    AADD(_aParms,{"01","2"})

    aItens := {}
    _nX	:= 1
    For _xx := 1 to Len(_aParms)
        MV_PAR02 := _aParms [_xx,1]
        MV_PAR03 := _aParms [_xx,2]
        _crlf := Chr(13) +Chr(10)
        //_cAnoMes := SUBSTR(DTOS(_dData),1,4)+SUBSTR(DTOS(_dData),5,2) //012014
        cQry := "SELECT * ,ROUND(ISNULL(MOV_01,0)*PERC*PER_BASE,2) VLR_01,ROUND(ISNULL(MOV_05,0)*PERC*PER_BASE,2) VLR_05 "
        cQry += "FROM V_MAPA_RATEIO_RECURSOS "
        cQry += "   LEFT JOIN (SELECT CQ2_DATA,CQ2_CCUSTO,SUM(CQ2_DEBITO-CQ2_CREDIT) MOV_01 "
        cQry += "   				FROM CQ2010 CQ2 "
        cQry += "   				WHERE CQ2.D_E_L_E_T_<>'*' AND CQ2_MOEDA='01' AND CQ2_TPSALD='"+MV_PAR03+"' "
        cQry += "   					AND CQ2_CCUSTO<>'' AND CQ2_CONTA BETWEEN '521020001' AND '521020098' AND CQ2_CONTA<>'521020004' "
        cQry += "   				GROUP BY CQ2.CQ2_CCUSTO,CQ2_DATA) MOVIMENTO_01 ON MOVIMENTO_01.CQ2_CCUSTO=CC_ORIGEM AND PERIODO=MOVIMENTO_01.CQ2_DATA "
        cQry += "   LEFT JOIN (SELECT CQ2_DATA,CQ2_CCUSTO,SUM(CQ2_DEBITO-CQ2_CREDIT) MOV_05 "
        cQry += "   				FROM CQ2010 CQ2 "
        cQry += "   				WHERE CQ2.D_E_L_E_T_<>'*' AND CQ2_MOEDA='05' AND CQ2_TPSALD='"+MV_PAR03+"' "
        cQry += "   					AND CQ2_CCUSTO<>'' AND CQ2_CONTA BETWEEN '521020001' AND '521020098' AND CQ2_CONTA<>'521020004' "
        cQry += "   				GROUP BY CQ2.CQ2_CCUSTO,CQ2_DATA) MOVIMENTO_05 ON MOVIMENTO_05.CQ2_CCUSTO=CC_ORIGEM AND PERIODO=MOVIMENTO_05.CQ2_DATA "
        cQry += "WHERE PERIODO='"+dtos(MV_PAR01)+"' "
        cQry += "ORDER BY CC_ORIGEM,CC_DESTINO "
        MemoWrite("RCTBA005.TXT",cQry)
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPX",.T.,.F.)
        DbSelectArea("TMPX")
        DbGotop()
        If !TMPX->(Eof())
            While !TMPX->(Eof())
                If TMPX->VLR_01 > 0 .or. TMPX->VLR_05>0
                    _aItem	:=	{}
                    aAdd(_aItem	,{"CT2_FILIAL"		,xFilial("CT2")		,NIL}) // Linha do lan็amento no lote
                    aAdd(_aItem	,{"CT2_LINHA"		,strZero(_nX,3)		,NIL}) // Linha do lan็amento no lote
                    _nX ++
                    aAdd(_aItem	,{"CT2_MOEDLC"	,"01"					,NIL}) // Tipo do Lan็amento 1 = D้bito, 2 = Cr้dito, 3 = Partilha dobrada, 4 = Complemento de historico"
                    aAdd(_aItem	,{"CT2_DC"		,"3"					,NIL}) // Tipo do Lan็amento 1 = D้bito, 2 = Cr้dito, 3 = Partilha dobrada, 4 = Complemento de historico"
                    aAdd(_aItem	,{"CT2_DEBITO"	,TMPX->CTA_DEBITO,NIL}) // Conta Banco
                    aAdd(_aItem	,{"CT2_CREDIT"	,TMPX->CTA_CREDITO,NIL}) // Conta Cr้dito
                    If TMPX->VLR_01>0 .AND. TMPX->VLR_05 == 0
                        aAdd(_aItem	,{"CT2_VALOR"	,TMPX->VLR_01			,NIL}) // Valor
                        aAdd(_aItem	,{'CT2_CONVER' ,'1' , NIL})
                    EndIf
                    If TMPX->VLR_05> 0 .AND. TMPX->VLR_01 == 0
                        aAdd(_aItem	,{'CT2_CONVER' ,'55554' , NIL})
                        aAdd(_aItem	,{"CT2_VALR05"	,TMPX->VLR_05		,NIL}) // Valor
                    EndIf
                    If TMPX->VLR_05> 0 .AND. TMPX->VLR_01 > 0
                        aAdd(_aItem	,{"CT2_VALOR"	,TMPX->VLR_01			,NIL}) // Valor
                        aAdd(_aItem	,{'CT2_CONVER' ,'15554' , NIL})
                        aAdd(_aItem	,{"CT2_VALR05"	,TMPX->VLR_05		,NIL}) // Valor
                    EndIf
                    aAdd(_aItem	,{"CT2_CCC"	    ,Alltrim(TMPX->CC_ORIGEM)        ,NIL}) // Conta Cr้dito
                    aAdd(_aItem	,{"CT2_CCD"	    ,Alltrim(TMPX->CC_DESTINO)       ,NIL}) // Conta Banco
                    aAdd(_aItem	,{"CT2_TPSALD"	,MV_PAR03						,NIL}) // Tipo de Saldo
                    aAdd(_aItem	,{"CT2_ORIGEM"	,'RCTBA005',NIL}) // Origem do lan็amento
                    //aAdd(_aItem	,{"CT2_FILORI"	,xFilial("CT2")		,NIL}) // Linha do lan็amento no lote
                    aAdd(_aItem	,{'CT2_HP' ,'' , NIL})
                    //            If MV_PAR03 == "1"
                    //                aAdd(_aItem	,{'CT2_CONVER' ,'15554' , NIL})
                    //            Else
                    //aAdd(_aItem	,{'CT2_CONVER' ,'15555' , NIL})
                    //aAdd(_aItem	,{'CT2_HIST' ,'MSEXECCT2LINHA2' , NIL})
                    aAdd(_aItem	,{"CT2_HIST"	,'RATEIO '+TMPX->DESTINO+' PERC: '+Transform(TMPX->PERC*100,"@E 999.99")+' BASE: '+Transform(TMPX->PER_BASE*100,"@E 999.99") ,NIL}) // Hist๓rido do lan็amento
                    aadd(aItens,_aItem)
                EndIf
                TMPX->(DBSKIP())
            EndDo
        EndIf
        TMPX->(DbCloseArea())
    Next
    //RpcClearEnv()
    If Len(aItens) > 0
        MSExecAuto({|x,y,z| Ctba102(x,y,z)},aCab,aItens,3)
        If lMsErroAuto
            MostraErro()
        Endif
    Else
        Alert("Nenhum dado a ser contabilizado")
    Endif

Return


Static Function EXECAUTO(_aCabec,_aList)
    local aCab		:= {}
    //local aItens	:= {}
    local aList		:= {}
    private	lMsErroAuto	:=	.F.

    aCab 	:= _aCabec
    aList	:= _aList
    MSExecAuto({|X,Y,Z|CTBA102(X,Y,Z)},aCab,aList,3)// Executa importa็ใo automแtica da linha

    If lMserroAuto
        Mostraerro()
        _lRet := .F.
    Else
        _lRet := .T.
    EndIf
Return _lRet
