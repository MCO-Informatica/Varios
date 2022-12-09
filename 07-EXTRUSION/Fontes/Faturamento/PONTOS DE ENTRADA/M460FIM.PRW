#Include 'Protheus.ch'
#INCLUDE "totvs.CH"
#INCLUDE "TOPCONN.CH"


User Function M460FIM()

	Local lRet          := .T.
	Local aArea         := GetArea()
	Local aAreaE1       := SE1->(GetArea())
	Local nPedido       := SC5->C5_NUM
	Local cQry          := ""
	Local aVetSE1       := {}
	Private cCLiente    := ""
	Private cLojaCli    := ""
	Private cPrefixo    := ""
	Private nNumNCC     := ""
	Private nValCH      := 0

 /*IF! dbSeek(XFILIAL("SE1")+cCLiente + cLojaCli + cPrefixo + nNumNCC+"  "+"NF ") //PESQUISAR NOTA FISCAL
    Return .T.
 EndIf*/
cQry := "SELECT E1_VALOR, E1_NUM, E1_NATUREZ, E1_CLIENTE, E1_LOJA, E1_PREFIXO, R_E_C_N_O_ FROM "+RetSqlName("SE1")+" "
cQry += "WHERE E1_FILIAL =  '"+xFilial("SE1")+"' AND E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA= '"+SC5->C5_LOJACLI+"' "
cQry += "AND D_E_L_E_T_ = ' ' AND E1_PEDIDO = '"+SC5->C5_NUM+"' AND E1_TIPO = 'CH' "

TcQuery cQry New Alias "Tse1"

iF tse1->(eof())
    //Alert("Não foi encontrado titulo tipo CH no Financeiro para o Pedido" +SC5->C5_NUM)
    MsgAlert('Não foi encontrado título CH no Financeiro para o pedido <font color="#FF0000">' + SC5->C5_NUM + '</font>', "Atenção:")
    lRet := .F.
    tse1->(DBCLOSEAREA())   
    Return lret    

EndIf

While !Tse1->(eof())
    nValCH      +=  tse1->E1_VALOR
    nNumNCC     :=  tse1->E1_NUM
    cNaturez    :=  tse1->E1_NATUREZ
    cCLiente    :=  tse1->E1_CLIENTE
    cLojaCli    :=  tse1->E1_LOJA
    cPrefixo    :=  tse1->E1_PREFIXO
    
    tse1->(dbskip())
end
tse1->(DBCLOSEAREA())

//Prepara o array para o execauto

aAdd(aVetSE1, {"E1_FILIAL",  FWxFilial("SE1"),                                  Nil})
aAdd(aVetSE1, {"E1_NUM",     nNumNCC,                                           Nil})
aAdd(aVetSE1, {"E1_PREFIXO", cPrefixo,                                          Nil})
aAdd(aVetSE1, {"E1_PARCELA", "",                                                Nil}) //verificar se vai ser em branco
aAdd(aVetSE1, {"E1_TIPO",    "NCC",                                             Nil})
aAdd(aVetSE1, {"E1_NATUREZ", cNaturez,                                          Nil}) // Verificar natureza com Ricardo 
aAdd(aVetSE1, {"E1_CLIENTE", cCLiente,                                          Nil})
aAdd(aVetSE1, {"E1_LOJA",    cLojaCli,                                          Nil})
//aAdd(aVetSE1, {"E1_NOMCLI",  cNomCli,           Nil})
aAdd(aVetSE1, {"E1_EMISSAO", dDatabase,                                         Nil}) //VER AS DATAS COM RICARDO
aAdd(aVetSE1, {"E1_VENCTO",  dDatabase,                                         Nil}) //VER AS DATAS COM RICARDO
aAdd(aVetSE1, {"E1_VENCREA", dDatabase,                                         Nil}) //VER AS DATAS COM RICARDO
aAdd(aVetSE1, {"E1_VALOR",   nValCH,                                            Nil}) //Somatório dos titulos com tipo CH 
aAdd(aVetSE1, {"E1_HIST",    "RECEBIMENTO ATRAVÉS DE CHEQUES",                  Nil}) //CRIAR HISTÓRICO, VER COM O RICARDO
aAdd(aVetSE1, {"E1_MOEDA",   1,                                                 Nil})
 
//Inicia o controle de transação
Begin Transaction
    //Chama a rotina automática
    lMsErroAuto := .F.
    MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)
     
    //Se houve erro, mostra o erro ao usuário e desarma a transação
    If lMsErroAuto
        MostraErro()
        DisarmTransaction()
    EndIf
//Finaliza a transação
End Transaction

RestArea(aAreaE1)
RestArea(aArea)

    Comp()

Return lRet

**********************************

Static Function Comp()

**********************************

Local lRetOK        := .T.
Local aArea         := GetArea()
Local nTaxaCM       := 1
Local aTxMoeda      := {}
Local cQryNf        := ""
Local nSaldoComp    := nValCH*nTaxaCM 
Private nRecnoE1    := 0


    dbSelectArea("SE1")
    dbSetOrder(2) // E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_*/

        IF dbSeek(XFILIAL("SE1")   +cCLiente + cLojaCli + cPrefixo +nNumNCC+"  "+"NCC") //PROCURAR NCC
            nRecnoRA := RECNO()
             nTaxaCM := RecMoeda(dDataBase,SE1->E1_MOEDA)
        //nTaxaCM := RecMoeda(dDataBase,SE1->E1_MOEDA)

        aAdd(aTxMoeda, {1, 1} )
        //aAdd(aTxMoeda, {2, nTaxaCM} )

        ENDIF
        RestArea(aArea)

        PERGUNTE("FIN330",.F.)
        lContabiliza    := (MV_PAR09 == 1) // Contabiliza On Line ?
        lDigita         := (MV_PAR07 == 1) // Mostra Lanc Contab ?
        lAglutina       := .F.

        cQryNf := "SELECT R_E_C_N_O_ FROM "+RetSqlName("SE1")+" "
        cQryNf += "WHERE E1_FILIAL =  '"+xFilial("SE1")+"' AND E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA= '"+SC5->C5_LOJACLI+"' "
        cQryNf += "AND D_E_L_E_T_ = ' ' AND E1_PEDIDO = '"+SC5->C5_NUM+"' AND E1_TIPO = 'NF ' "

        TcQuery cQryNf New Alias "TseNf"
        while !TseNf->(EoF()) 
            nRecnoE1 := TseNf->R_E_C_N_O_

            aRecRA := { nRecnoRA }
            aRecSE1 := { nRecnoE1 }

            If !MaIntBxCR(3, aRecSE1,,aRecRA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,nSaldoComp,,,, nTaxaCM, aTxMoeda)
                Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo",1,0)
                lRetOK := .F.
            ENDIF
            TseNf->(dbskip())
        End        
        TseNf->(DBCLOSEAREA())


Return lRetOK
