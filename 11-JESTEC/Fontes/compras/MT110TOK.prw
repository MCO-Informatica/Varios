#include "rwmake.ch"
#include "protheus.ch"

User Function MT110TOK()

    Local nTotAC7 := 0
    Local nTotAFG := 0
    Local cItem	  := ""

    _lRet 		:= .t.
    _nQtdSC 	:= 0
    _nQtdPMS	:= 0

    For nX := 1 to Len(aCols)
        nTotAC7 += aCols[nX][7]
        If Ascan(aRatAFG,{|x|x[1]==aCols[nX][aScan(aHeader,{|x| AllTrim(x[2])=="C1_ITEM"})]}) <> 0
            cItem := aRatAFG[nX][1]
            For nY := 1 to Len(aRatAFG)
                If cItem == aRatAFG[nX][1]
                    nTotAFG	+= aRatAFG[nX][2]
                Endif
            Next
        Else
            Alert("Item:"+ nX + "Sem projeto" )
//		MsgBox("Falta informar o projeto ou o rateio de quantidades está incorreto.","Validação Projeto","Stop")
            _lRet := .f.
        Endif
    Next

Return(_lRet)

