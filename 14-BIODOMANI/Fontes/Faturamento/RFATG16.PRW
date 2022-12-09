#include "protheus.ch"

User Function RFATG16()

Local _nQtdVen  := aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"    })]
Local _nQtdLib  := aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDLIB"    })]
Local _cKit     := aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_KIT"     })]
Local _cProduto := Alltrim(aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"   })])
Local _cTes     := aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"       })]
Local _cCfop    := aCols[N,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_CF"        })]
Local _nDesc    := Posicione("ACN",3,xFilial("ACN")+_cProduto,"ACN_X_DESC")
Local _nPrcVen  := 0
Local _nValMerc := 0
Local _nValDesc := 0
Local _nQtdV    := 0
Local _nX       := 0
Local _nY       := 0

//----> VERIFICA SE O PRODUTO PERTENCE A KIT
If _cKit$"S" .And. Len(_cProduto)==4

    //----> EXPLODE A EXTRUTURA DOS COMPONENTES DO KIT
    Ma410BOM(aHeader,aCols,N)

    //----> AJUSTA TODOS OS ITENS EXPLODIDOS DA ESTRUTURA
    For _nX:= N to Len(aCols)

		_nQtdV    := aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"})]
        _nPrcVen  := a410Arred(aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRUNIT"})]*((100- _nDesc)/100))
		_nValMerc := a410Arred(aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"})]*_nPrcVen)
		_nValDesc := a410Arred((aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRUNIT"})]*aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN"})] - _nValMerc))

        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_KIT"     })]    := _cKit
        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRCVEN"    })]    := Round(_nValMerc/_nQtdV,8)
        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_VALOR"     })]    := Round(_nValMerc,2)
        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"       })]    := _cTes
        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_CF"        })]    := _cCfop
        //aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_QTDLIB"    })]    := _nQtdLib
        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_DESCONT"   })]    := _nDesc
        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_VALDESC"   })]    := Round(_nValDesc,2)
        aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_PRKIT"   })]    := _cProduto
        aCols[_nX,Len(aHeader)+1] := .F.

    Next _nX    

EndIf

For _nY:= 1 to Len(aCols)
    //----> DELETA A LINHA DO PRODUTO KIT
    If Len(Alltrim(aCols[_nY,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"   })]))==4 .and. aCols[_nY,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_KIT"   })]$"S"
        aCols[_nY,Len(aHeader)+1] := .T.
    EndIf    
Next _nY    

Return(_nQtdVen)
