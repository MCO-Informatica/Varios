#INCLUDE "PROTHEUS.CH"

User Function MT100LOK


    Local _aArea	:= GetArea()
    Local _lRet		:=.T.
    //Local _nOpcao 	:= 0
    Local _cProduto	:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_COD"})]
    Local _cLocal	:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_LOCAL"})]
    Local _cTes		:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_TES"})]
    Local _cLoteCtl	:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_LOTECTL"})]
    Local _dDtValid	:= acols[n,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_DTVALID"})]
    Local _lDelet   := acols[n,Len(aHeader) + 1]



//----> VALIDA O TIPO DE NOTA FISCAL (NORMAL/DEVOLUCAO)
    If cTipo $ "N/D"
        //----> VERIFICA SE A LINHA NAO EST? DELETADA
        If !_lDelet
            //----> VERIFICA SE O PRODUTO CONTROLA RASTREABILIDADE POR LOTE
            If Rastro(_cProduto)
                //----> VERIFICA SE A TES ATUALIZA ESTOQUE
                If Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_ESTOQUE")$"S"
                    //----> VERIFICA SE O LOTE NAO FOI PREENCHIDO
                    If Empty(_cLoteCtl)
                        Aviso("LOTE","Aten??o! Favor incluir o n?mero do lote para reastreabilidade!", {"OK"} )
                        _lRet:=.F.
                    EndIf
                    //----> VERIFICA SE A DATA DE VALIDADE NAO FOI PREENCHIDA
                    If Empty(_dDtValid) .or. _dDtValid <= dDataBase
                        Aviso("DATA VALIDADE","Aten??o Favor, incluir a data de validade para rastreabilidade!", {"OK"} )
                        _lRet:=.F.
                    EndIf
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

Return(_lret)
