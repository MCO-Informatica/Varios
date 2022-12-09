#Include "Protheus.ch"

User Function VldGrpUsr()

    Local aArea  := GetArea()
    Local aGrupo := UsrRetGrp(,RetCodUsr())
    Local cGrupo := IIF(Empty(aGrupo), " ",aGrupo[1])

    If Alltrim(cGrupo)$"000000,000014,000029,000030,000003" //,000120,000309,000163,000362
        lRet := .T.
    else
       lRet := .F.
    EndIf

    RestArea(aArea)

Return lRet
