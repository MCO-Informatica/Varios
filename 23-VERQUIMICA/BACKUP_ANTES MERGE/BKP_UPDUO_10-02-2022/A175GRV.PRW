#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

User Function A175GRV()

    Local _aArea     := GetArea()
    Local LMSERROAUTO:= .f.
    Local aCabSDA    := {}
    Local aItSDB     := {}
    Local _nRecno    := 0
    Local _cChave    := SD7->(D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL)
    Local _aAutoItens:= {}
    PRIVATE l265Auto := .t.


    dbSelectArea("SD7")
    _nRecno:= Recno()
    dbSetOrder(1)
    dbSeek(_cChave)

    While Eof() == .f. .And. SD7->(D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL) == _cChave

        _cProdOrig  := SD7->D7_PRODUTO
        _cDescOrig  := Posicione("SB1",1,xFilial("SB1")+SD7->D7_PRODUTO,"B1_DESC")
        _cUmOrig    := Posicione("SB1",1,xFilial("SB1")+SD7->D7_PRODUTO,"B1_UM")
        _cLocOrig   := SD7->D7_LOCDEST
        _cEndOrig   := SD7->D7_LOCALIZ

        _cProdDest  := SD7->D7_PRODUTO
        _cDescDest  := Posicione("SB1",1,xFilial("SB1")+SD7->D7_PRODUTO,"B1_DESC")
        _cUmDest    := Posicione("SB1",1,xFilial("SB1")+SD7->D7_PRODUTO,"B1_UM")
        _cLocDest   := SD7->D7_LOCDEST
        _cEndDest   := "09"

        _cLoteOrig  := SD7->D7_LOTECTL
        _cNumlOrig  := SD7->D7_NUMLOTE
        _dDtValOrig := SD7->D7_DTVALID
        _nQtde      := SD7->D7_QTDE
        _nQtSegum   := SD7->D7_QTSEGUM
        _cNumSeq    := SD7->D7_NUMSEQ
        _cLoteDest  := "TESTE"
        _nNumlDest  := ""
        _dDtValDest := dDataBase+760
        _cDocD3     := SD7->D7_NUMERO
        _cTipo      := SD7->D7_TIPO

        dbSelectArea("SD7")
        dbSkip()
    EndDo

    If _cTipo==1

        dbSelectArea("SDA")
        dbSetOrder(1)
        If dbSeek(xFilial('SDA')+_cProdDest+_cLocDest+_cNumSeq+_cDocD3,.f.)
    
        //Cabeçalho com a informação do item e NumSeq que sera endereçado.
        aCabSDA := {{"DA_PRODUTO" ,_cProdDest    ,Nil},;
            {"DA_LOCAL"   ,_cLocDest     ,Nil},;
            {"DA_LOTECTL" ,_cLoteOrig    ,Nil},;
            {"DA_DOC"     ,_cDocD3       ,Nil},;
            {"DA_ORIGEM"  ,"SD3"         ,Nil}}

        //Dados do item que será endereçado
        aadd(aItSDB,{{"DB_ITEM"	    ,"0001"	     ,Nil},;
            {"DB_LOCALIZ"  ,"09"        ,Nil},;
            {"DB_DATA"	   ,dDataBase   ,Nil},;
            {"DB_QUANT"    ,_nQtde      ,Nil},;
            {"DB_QTSEGUM"  ,_nQtSegum   ,Nil}})


        ALERT(SDA->DA_PRODUTO+"-"+SDA->DA_LOCAL+"-"+SDA->DA_NUMSEQ+"-"+SDA->DA_DOC)
    
        A265Inclui("SDA",Recno(),3)
        
        //MsExecAuto({|x,y,z| Mata265(x,y,z)},aCabSDA,aItSDB,3)

        //If lMsErroAuto
        //    MOSTRAERRO()
        //    DisarmTransaction()
        //    Break
        //Else
         //   MsgAlert("Endereçamento Automático Verquímica OK!")
        //Endif
        EndIf
        _cDocD3 := IIf(Empty(_cDocD3),NextNumero("SD3",2,"D3_DOC",.T.),_cDocD3)
        _cDocD3 := A261RetINV(_cDocD3)

        aadd(_aAutoItens,{ _cDocD3, ddatabase})

        aadd(_aAutoItens , Array(24) )

        //----> Produto Origem
        _aAutoItens[ 2 , 01 ] := _cProdOrig
        _aAutoItens[ 2 , 02 ] := _cDescOrig
        _aAutoItens[ 2 , 03 ] := _cUmOrig
        _aAutoItens[ 2 , 04 ] := _cLocOrig
        _aAutoItens[ 2 , 05 ] := _cEndOrig

        //----> Produto Destino
        _aAutoItens[ 2 , 06 ] := _cProdDest
        _aAutoItens[ 2 , 07 ] := _cDescDest
        _aAutoItens[ 2 , 08 ] := _cUmDest
        _aAutoItens[ 2 , 09 ] := _cLocDest
        _aAutoItens[ 2 , 10 ] := _cEndDest

        //----> Demais Itens
        _aAutoItens[ 2 , 11 ] := criavar('D3_NUMSERI')
        _aAutoItens[ 2 , 12 ] := _cLoteOrig
        _aAutoItens[ 2 , 13 ] := _cNumlOrig
        _aAutoItens[ 2 , 14 ] := _dDtValOrig
        _aAutoItens[ 2 , 15 ] := criavar('D3_POTENCI')
        _aAutoItens[ 2 , 16 ] := _nQtde
        _aAutoItens[ 2 , 17 ] := _nQtSegum
        _aAutoItens[ 2 , 18 ] := criavar('D3_ESTORNO')
        _aAutoItens[ 2 , 19 ] := _cNumSeq
        _aAutoItens[ 2 , 20 ] := _cLoteDest
        _aAutoItens[ 2 , 21 ] := _dDtValDest
        _aAutoItens[ 2 , 22 ] := criavar('D3_ITEMGRD')
        _aAutoItens[ 2 , 23 ] := criavar('D3_PERIMP')
        _aAutoItens[ 2 , 24 ] := "TRANSFERENCIA CQ PARA LOTE"

        MSExecAuto({|x| MATA261(x)},_aAutoItens)

        If lMsErroAuto
            MOSTRAERRO()
            DisarmTransaction()
            Break
        Else
            MsgAlert("Transferência Lote Verquímica OK!")
        EndIf
    EndIf


    dbSelectArea("SD7")
    dbGoto(_nRecno)

    RestArea(_aArea)

Return(.T.)
