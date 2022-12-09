#INCLUDE "PROTHEUS.CH"

USER FUNCTION QLTF002()

    If M->C5_TIPO $"D/B"
        M->C5_NOMCLI := Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_NOME")
    Else
        M->C5_NOMCLI := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE,"A1_NOME")
    Endif

Return .T.