#include "protheus.ch"

User Function MT121BRW()

Local _aArea  := GetArea()
Local _aGrupo := UsrRetGrp(,RetCodUsr())
Local _cGrupo := Iif(__cUserID$"000000","000000",_aGrupo[1])


//----> SO EXECUTAR SE CHAMAR A FUNCAO MATA121
If Alltrim(FunName())$"MATA121"

    //----> GRUPO ADM
    If Alltrim(_cGrupo)$"000000"

        dbSelectArea("SC7")
        Set Filter To

    //----> GRUPO RH
    ElseIf Alltrim(_cGrupo)$"000005"

        dbSelectArea("SC7")
        Set Filter To Alltrim(SC7->C7_X_ORIG) $ "RH"

    //----> GRUPO COMPRAS
    Else

        dbSelectArea("SC7")
        Set Filter To Alltrim(SC7->C7_X_ORIG) $ "CP"

    EndIf
EndIf

RestArea(_aArea)

Return()
