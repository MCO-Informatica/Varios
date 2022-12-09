#include "protheus.ch"

User Function MT410BRW()

    Local _aArea  := GetArea()
    Local _aGrupo := UsrRetGrp(,RetCodUsr())
    Local _cGrupo := IIF(__cUserID$"000000","000003",IIF(Empty(_aGrupo), " ",_aGrupo[1])) //Iif(__cUserID$"000000","000003",_aGrupo[1])

//----> GRUPO OPERACIONAL / GRUPO CALL CENTER
    If Alltrim(cUserName)$"adriana.antunes" 
        dbSelectArea("SC5")
        Set Filter To Alltrim(SC5->C5_X_USERS) $ Alltrim(cUserName)
    ElseIf Alltrim(_cGrupo)$"000002.000004"
        dbSelectArea("SC5")
        Set Filter To 
    Else
        dbSelectArea("SC5")
        Set Filter To
    EndIf

    RestArea(_aArea)

Return()
