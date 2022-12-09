#include "protheus.ch"

/*/{Protheus.doc} M460FIL
description
@type function
@version  
@author rickson.oliveira mv_par19       
@since 18/05/2022
@return variant, return_description
/*/

User Function M460FIL()  

_cFil :=  ""
_cPedEcom := REPLICATE("Z",55)

If Alltrim(FunName()) $"MATA460A"
    If !Empty(MV_PAR19)
        _cFil += " SUBSTRING(SC9->C9_PEDECOM,1,3) = '"+MV_PAR19+"' "
    Else 
        _cFil += " SC9->C9_PEDECOM >= '' .AND. SC9->C9_PEDECOM <= '"+_cPedEcom+"' "
    EndIf
EndIf

Return(_cFil)
