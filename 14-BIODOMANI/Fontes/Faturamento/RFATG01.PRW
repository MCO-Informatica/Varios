#include "protheus.ch"

User Function RFATG01()

    Local _cRet   := ""
    Local _aGrupo := UsrRetGrp(,RetCodUsr())
    Local _cGrupo := Iif(__cUserID$"000000","000003",_aGrupo[1])

    If INCLUI

        _cRet := M->A1_VEND

//----> GRUPO GERENCIAL
    ElseIf ALTERA
        If Alltrim(_cGrupo)$"000003"
            _cRet := M->A1_VEND
        Else
            _cRet := SA1->A1_VEND
            MsgAlert("Voc? n?o tem permiss?o para alterar o Vendedor Cosmobeauty do cliente. Procure a Supervis?o para fazer essa altera??o.")
        EndIf
    EndIf

Return(_cRet)


