#include "protheus.ch"
#include "topconn.ch"

User Function FISVALNFE()

    Local _lTran	:=.T.
    Local _cTipo	:=PARAMIXB[1]
    Local _cFil		:=PARAMIXB[2]
    Local _cEmissao	:=PARAMIXB[3]
    Local _cNota	:=PARAMIXB[4]
    Local _cSerie	:=PARAMIXB[5]
    Local _cClieFor	:=PARAMIXB[6]
    Local _cLoja	:=PARAMIXB[7]
    Local _cEspec	:=PARAMIXB[8]
    Local _cFormul	:=PARAMIXB[9]
    Local _cAux		:="0"+Subs(cFilAnt,3,2)

//----> TRAVA SERIE DA NOTA DIFERENTE DA FILIAL
    If _cAux <> _cSerie
        _lTran	:=	.F.
        Alert("A nota fiscal "+_cNota+"/"+_cSerie+" não pertence a empresa/filial corrente.")
    EndIf


Return(_lTran)

