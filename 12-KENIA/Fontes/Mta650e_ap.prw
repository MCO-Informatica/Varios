#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mta650e()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_NITEM,_CITEMMO,_CTIPCOB,_CPEDIDO,_AAREAANT,_AAREASC5")
SetPrvt("_AAREASC6,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? MTA650E  ? Autor ? Jefferson Marques     ? Data ?04/06/2004낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Estorna Pedido de Venda Automatico para OP de Terceiros    낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   Analista   ?  Data  ?             Motivo da Alteracao               낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?              ?        ?                                               낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
_nItem      :=  0
_cItemMo    :=  ""
_cTipCob    :=  ""
_cPedido    :=  ""
_aAreaANT   :=  GetArea()

dbSelectArea("SC5")
_aAreaSC5   :=  GetArea()

dbSelectArea("SC6")
_aAreaSC6   :=  GetArea()

dbSelectArea("SC2")

//----> VERIFICA SE E ORDEM DE PRODUCAO DE TERCEIROS
If SC2->C2_TERCEI$"S"

    //----> PRODUTO BENEFICIADO
    dbSelectArea("SC6")
    _aAreaSC6   :=  GetArea()
    dbSetOrder(2)
    If dbSeek(xFilial("SC6")+SC2->C2_PRODUTO+SC2->C2_PV_TERC+SC2->C2_IT_TERC,.F.)

        //----> CHECA SE HA SALDO NO PEDIDO PARA EXCLUIR
        If (SC6->C6_QTDVEN - SC6->C6_QTDENT) < SC2->C2_QUANT .Or. SC6->C6_BLQ == "R"
            MsgBox("O Pedido de Venda "+SC6->C6_NUM+" nao podera ser ajustado devido a quantidade da Ordem de Producao excluida ser maior que o saldo do item no Pedido de Venda.","Exclusao do Pedido de Venda Automatico","Stop")
        Else
            _cPedido := SC6->C6_NUM

            RecLock("SC6",.F.)
            SC6->C6_QTDVEN  :=  Round(SC6->C6_QTDVEN - SC2->C2_QUANT,2)
            SC6->C6_VALOR   :=  SC6->C6_QTDVEN * SC6->C6_PRCVEN
            MsUnLock()

            //----> CHECA SE A QUANTIDADE FOR ZERO E DELETA O ITEM
            If SC6->C6_QTDVEN <= 0
                RecLock("SC6",.F.)
                dbDelete()
                MsUnLock()
            EndIf

            //----> CHECA SE O PEDIDO POSSUI MAIS DE UM ITEM
            dbSelectArea("SC6")
            _aAreaSC6   :=  GetArea()
            dbSetOrder(1)
            If dbSeek(xFilial("SC6")+_cPedido,.F.)

                While SC6->C6_NUM == _cPedido
                    _nItem  :=  _nItem + 1
                    dbSkip()
                EndDo
            EndIf

            //----> CASO O PEDIDO SO POSSUA UM ITEM DELETA O CABECALHO
            If _nItem <= 1
                dbSelectArea("SC5")
                _aAreaSC5   :=  GetArea()
                dbSetOrder(1)
                If dbSeek(xFilial("SC5")+_cPedido,.f.)
                    RecLock("SC5",.F.)
                    dbDelete()
                    MsUnLock()
                EndIf
            EndIf
        EndIf
    EndIf

    _cPedido := ""
    _nItem   := 0

    //----> MAO DE OBRA
    dbSelectArea("SC6")
    _aAreaSC6   :=  GetArea()
    dbSetOrder(1)
    If dbSeek(xFilial("SC6")+SC2->C2_PV_TERC,.F.)

        _cTipCob    :=  Posicione("SZC",2,xFilial("SZC")+SC2->C2_PRODUTO+SC2->C2_TIPO,"ZC_TIPCOB")

        //----> LOCALIZA A MAO DE OBRA DO PRODUTO A SER EXCLUIDO
        While SC6->C6_NUM == SC2->C2_PV_TERC
            If Alltrim(SC6->C6_DESCRI) == "MO TING "+Iif(_cTipCob$"M","MT ","KG ")+Alltrim(SC2->C2_PRODUTO)
                _cItemMo :=  SC6->C6_ITEM
            EndIf
            dbSkip()
        EndDo

        dbSelectArea("SC6")
        _aAreaSC6   :=  GetArea()
        dbSetOrder(1)
        If dbSeek(xFilial("SC6")+SC2->C2_PV_TERC+_cItemMo,.F.)

            _cTipCob    :=  Posicione("SZC",2,xFilial("SZC")+SC2->C2_PRODUTO+SC2->C2_TIPO,"ZC_TIPCOB")

            //----> CHECA SE HA SALDO NO PEDIDO PARA EXCLUIR
            If (SC6->C6_QTDVEN - SC6->C6_QTDENT) < Iif(_cTipCob$"M",SC2->C2_QUANT,SC2->C2_QTSEGUM) .Or. SC6->C6_BLQ == "R"
                MsgBox("O Pedido de Venda "+SC6->C6_NUM+" nao podera ser ajustado devido a quantidade da Ordem de Producao excluida ser maior que o saldo do item no Pedido de Venda.","Exclusao do Pedido de Venda Automatico","Stop")
            Else

                _cPedido := SC6->C6_NUM

                RecLock("SC6",.F.)
                SC6->C6_QTDVEN  :=  Round(SC6->C6_QTDVEN - Iif(_cTipCob$"M",SC2->C2_QUANT,SC2->C2_QTSEGUM),2)
                SC6->C6_VALOR   :=  SC6->C6_QTDVEN * SC6->C6_PRCVEN
                MsUnLock()

                MsgBox("O Pedido de Venda "+SC2->C2_PV_TERC+" foi ajustado apos a exclusao da Ordem de Producao "+SC2->C2_NUM+".","Ajuste Pedido de Venda Automatico","Info")

                //----> CHECA SE A QUANTIDADE FOR ZERO E DELETA O ITEM
                If SC6->C6_QTDVEN <= 0
                    RecLock("SC6",.F.)
                    dbDelete()
                    MsUnLock()
                EndIf

                dbSelectArea("SC6")
                _aAreaSC6   :=  GetArea()
                dbSetOrder(1)
                If dbSeek(xFilial("SC6")+_cPedido,.F.)

                    //----> CHECA SE O PEDIDO POSSUI MAIS DE UM ITEM
                    While SC6->C6_NUM == _cPedido
                        _nItem  :=  _nItem + 1
                        dbSkip()
                    EndDo
                EndIf

                //----> CASO O PEDIDO SO POSSUA UM ITEM DELETA O CABECALHO
                If _nItem <= 1
                    dbSelectArea("SC5")
                    _aAreaSC5   :=  GetArea()
                    dbSetOrder(1)
                    If dbSeek(xFilial("SC5")+_cPedido,.f.)
                        RecLock("SC5",.F.)
                        dbDelete()
                        MsUnLock()
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
EndIf

//----> RESTAURA AREA SC5
RestArea(_aAreaSC5)

//----> RESTAURA AREA SC6
RestArea(_aAreaSC6)

//----> RESTAURA AREA ANTERIOR
RestArea(_aAreaANT)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


