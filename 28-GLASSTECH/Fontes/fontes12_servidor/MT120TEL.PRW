#Include "Protheus.ch"
User Function MT120TEL()
    Local aArea     := GetArea()
    Local oDlg      := PARAMIXB[1] 
    Local aPosGet   := PARAMIXB[2]
    Local nOpcx     := PARAMIXB[4]
    Local nRecPC    := PARAMIXB[5]
    Local lEdit     := IIF(nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx ==  9, .T., .F.) //Somente será editável, na Inclusão, Alteração e Cópia
    Local oXObsAux
    Public cXObsAux := ""
     
    //Define o conteúdo para os campos
    SC7->(DbGoTo(nRecPc))
    cXObsAux := Posicione("SA2", 1, xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA), "A2_NREDUZ")

    //Criando na janela o campo OBS
    @ 060, 430 SAY "Nome Fornecedor" OF oDlg PIXEL SIZE 050,006
    @ 060, 495 MSGET oXObsAux VAR cXObsAux SIZE 100, 006 OF oDlg COLORS 0, 16777215  PIXEL SIZE 050, 006
     
    //Se não houver edição, desabilita os gets
    //If !lEdit
        oXObsAux:lActive := .F.
    //EndIf
     
    RestArea(aArea)
Return 
