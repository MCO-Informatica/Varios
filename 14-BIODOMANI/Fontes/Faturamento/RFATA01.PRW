#include "protheus.ch"

User Function RFATA01()

    Local _aGrupo := UsrRetGrp(,RetCodUsr())
    Local _cGrupo := IIF(__cUserID$"000000","000003",IIF(Empty(_aGrupo), " ",_aGrupo[1])) //Iif(__cUserID$"000000","000003",_aGrupo[1])
    Local _lRet	  := .f.


//----> GRUPO GERENCIAL
    If Alltrim(_cGrupo)$"000003.000004"
        _lRet	:= .t.
    Elseif AllTrim(_cGrupo) = " "
        _lRet   := .T.
    EndIf

Return(_lRet)
