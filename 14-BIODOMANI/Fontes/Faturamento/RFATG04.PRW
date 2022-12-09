#include "protheus.ch"

User Function RFATG04()

    Local _cRet   := ""
    Local _aGrupo := UsrRetGrp(,RetCodUsr())
    Local _cGrupo := Iif(__cUserID$"000000","000003",_aGrupo[1])

    If INCLUI

        _cRet := M->A1_VEND1

//----> GRUPO GERENCIAL
    ElseIf ALTERA
        If Alltrim(_cGrupo)$"000003"
            _cRet := M->A1_VEND1
        Else
            _cRet := SA1->A1_VEND1
            MsgAlert("Você não tem permissão para alterar o Vendedor Samana do cliente. Procure a Supervisão para fazer essa alteração.")
        EndIf
    EndIf

Return(_cRet)


