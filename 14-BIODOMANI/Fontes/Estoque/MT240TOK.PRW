#INCLUDE "PROTHEUS.CH"

User Function MT240TOK


    Local _aArea	:= GetArea()
    Local _lRet		:=.T.
    Local _nOpcao 	:= 0
    Local _cProduto	:= M->D3_COD
    Local _cTes		:= M->D3_TM
    Local _cLoteCtl	:= M->D3_LOTECTL
    Local _dDtValid	:= M->D3_DTVALID


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

    RestArea(_aArea)

Return(_lret)
