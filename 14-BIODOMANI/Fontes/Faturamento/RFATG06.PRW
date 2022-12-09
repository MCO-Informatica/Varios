#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"

User Function RFATG06()

    Local _cProduto := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO" })]
    Local _cLocal	:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"   })]
    Local _nQtdLib  := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"  })]
    Local _nPrcVen  := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRUNIT"  })]
    Local _cTes		:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"  	 })]
//Local _cCfop	:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_CF"  	 })]
    Local _nEstoque := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_QTEST" })]
    Local _cLotectl := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_LOTECTL" })]
    Local _dDtValid := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_DTVALID" })]
    Local _nLotes   := 0
    Local _nCount	:= 0
    Local _lSaldoOK := .F.
    Local _lSaldoMSG:= .F.
    Local _cAtuEst	:= Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_ESTOQUE")

//----> SOMENTE PEDIDOS NORMAIS PASSAM PELA VALIDACAO
    If M->C5_TIPO$"N" .AND. _cAtuEst$"S"

        //----> SE NAO FOR PROGRAMACAO DE ENTREGA
        If !M->C5_X_PROGR$"S"

            //----> SE O PRODUTO CONTROLA LOTE (RASTRO)
            If Rastro(_cProduto)

                dbSelectArea("SB8")
                dbSetOrder(1)
                If dbSeek(xFilial("SB8")+_cProduto+_cLocal,.f.)

                    While Eof() == .f. .And. SB8->(B8_PRODUTO+B8_LOCAL) == _cProduto+_cLocal

                        //----> VERIFICA SE O SALDO DO LOTE ESTÁ ZERADO E DESCONSIDERA O LOTE
                        If SB8->B8_SALDO <= 0
                            dbSelectArea("SB8")
                            dbSkip()
                            Loop
                        EndIf

                        _nLotes++

                        //----> VERIFICA SE O SALDO DO LOTE É SUFICIENTE PARA ATENDER O PEDIDO
                        If (SB8->B8_SALDO - SB8->B8_EMPENHO) >= _nQtdLib .And. !_lSaldoOK
                            _nEstoque := _nQtdLib
                            _cLotectl := SB8->B8_LOTECTL
                            _dDtValid := SB8->B8_DTVALID
                            _lSaldoOK := .T.

                            //----> VERIFICA SE A VALIDADE DO LOTE É MENOR QUE 1 ANO E AVISA
                            If SB8->B8_DTVALID < (dDataBase+90)
                                //MsgStop("A validade do lote "+Alltrim(SB8->B8_LOTECTL)+" - "+DTOC(SB8->B8_DTVALID)+" é menor que 90 dias.")
                            EndIf
                        Else
                            //MsgAlert("O produto "+Alltrim(_cProduto)+" possui mais de um lote em estoque. Verifique a necessidade de desmembrar o produto de acordo com o saldo por lote para não deixar vencer o lote mais antigo.")
                        EndIf

                        //----> VERIFICA SE EXISTE MAIS DE UM LOTE E AVISA
                        If _nLotes > 1 .And. _nLotes < 3
                            //MsgStop("O produto "+Alltrim(_cProduto)+" possui mais de um lote em estoque. Verifique a necessidade de desmembrar o produto de acordo com o saldo por lote para não deixar vencer o lote mais antigo.")
                        EndIf

                        dbSelectArea("SB8")
                        dbSkip()
                    EndDo
                EndIf
            EndIf

            If _nEstoque == 0
                //MsgAlert("O produto "+Alltrim(_cProduto)+" não possui estoque disponível. Se for programação, digite este produto em pedido separado.")

                //_nQtdLib := 0

                //aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDLIB" })]	:= _nQtdLib
                aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]	:= ""
                aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DTVALID"})]	:= CTOD("  /  /  ")
                //		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_TES"	   })]	:= _cTes
                //		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_CF"     })]	:= fImpostos(_cProduto,_cTes,1,1,Val(_cProduto))
                aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:= _nPrcVen
                aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]  := A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")

            ElseIf _nEstoque <> _nQtdLib
                //MsgStop("O produto "+Alltrim(_cProduto)+" não possui lote disponível em estoque para atender a quantidade vendida. É necessário desmembrar o produto de acordo com o saldo por lote.")

                //aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDLIB" })]	:= _nQtdLib
                aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]	:= ""
                aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DTVALID"})]	:= CTOD("  /  /  ")
                //		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_TES"	   })]	:= _cTes
                //		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_CF"     })]	:= fImpostos(_cProduto,_cTes,1,1,Val(_cProduto))
                aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:= _nPrcVen
                aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]  := A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")

            Else

                //aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDLIB" })]	:= _nQtdLib
                aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]	:= "" //_cLotectl
                aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DTVALID"})]	:= CTOD("  /  /  ")   //_dDtValid
                //		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_TES"	   })]	:= _cTes
                //		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_CF"     })]	:= fImpostos(_cProduto,_cTes,1,1,Val(_cProduto))
                aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:= _nPrcVen
                aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]  := A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")

            EndIf
        Else

            //	_nQtdLib := 0

            //aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDLIB" })]	:= _nQtdLib
            aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOTECTL"})]	:= ""
            aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DTVALID"})]	:= CTOD("  /  /  ")
            //	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_TES"	   })]	:= _cTes
            //	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_CF"     })]	:= fImpostos(_cProduto,_cTes,1,1,Val(_cProduto))
            aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:= _nPrcVen
            aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]  := A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")

        EndIf
    EndIf

Return(_nQtdLib)



Static Function fImpostos(cProduto,cTes,nQtd,nValor,nLinha)

    Local _cCFOP := ""

    MaFisIni(M->C5_CLIENTE,;										// 01- Codigo Cliente/Fornecedor
    M->C5_LOJACLI,;										// 02- Loja do Cliente/Fornecedor
    "C",;											// 03- C: Cliente / F: Fornecedor
    "N",;											// 04- Tipo da NF
    M->C5_TIPOCLI,;										// 05- Tipo do Cliente/Fornecedor
    MaFisRelImp("MTR700",{"SC5","SC6"}),;			// 06- Relacao de Impostos que suportados no arquivo
    ,;												// 07- Tipo de complemento
    ,;												// 08- Permite incluir impµostos no rodape (.T./.F.)
    "SB1",;										// 09- Alias do cadastro de Produtos - ("SBI" para Front Loja)
    "MTR700")										// 10- Nome da rotina que esta utilizando a funcao


    MaFisAdd(cProduto,cTes,nQtd,1,0,"","",,0,0,0,0,nValor,0)


    _cCFOP := MaFisRet(1,"IT_CF")

    MaFisEnd()

Return(_cCFOP)
