#INCLUDE "PROTHEUS.CH"

User Function MT241LOK


    Local _aArea	:= GetArea()
    Local _lRet		:=.T.
    //Local _nOpcao 	:= 0
    Local _cProduto	:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D3_COD"})]
    local _cLocal   := acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D3_LOCAL"})]
    Local _cTes		:= cTM
    Local _cLoteCtl	:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D3_LOTECTL"})]
    Local _dDtValid	:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D3_DTVALID"})]
    Local _lDelet   := acols[n,Len(aHeader) + 1]

      //----> VERIFICA SE A LINHA NAO ESTÁ DELETADA
    If !_lDelet
        //----> VERIFICA SE O PRODUTO CONTROLA RASTREABILIDADE POR LOTE
        If Rastro(_cProduto)
            //----> VERIFICA SE A TM É ENTRADA

            If _cTes < "500"
                //----> VERIFICA SE O LOTE NAO FOI PREENCHIDO

                If Empty(_cLoteCtl)
                    Aviso("LOTE","Atenção! Favor incluir o número do lote para reastreabilidade!", {"OK"} )
                    _lRet:=.F.
                EndIf
                //----> VERIFICA SE A DATA DE VALIDADE NAO FOI PREENCHIDA
                If Empty(_dDtValid) .or. _dDtValid <= dDataBase
                    Aviso("DATA VALIDADE","Atenção Favor, incluir a data de validade para rastreabilidade!", {"OK"} )
                    _lRet:=.F.
                EndIf
            EndIf
        EndIf
    EndIf

    DbSelectArea("SB2")
    DbSetOrder(1)
    If dbSeek(xFilial("SB2")+_cProduto+_cLocal,.f.)
        If Empty(SB2->B2_DESC)
            RecLock("SB2", .F.)
            SB2->B2_DESC    :=  Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC")
            MsUnlock()
        EndIf
    EndIf

    RestArea(_aArea)

Return(_lRet)
