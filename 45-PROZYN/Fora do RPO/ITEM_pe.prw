//Bibliotecas
#Include "Protheus.ch" 
 
/*/{Protheus.doc} ITEM
Exemplo de Ponto de Entrada em MVC 
@author zIsMVC 
@since 29/06/2018
@version 1.0 
@type function 
@obs Deixar o nome do prw como: ITEM_pe.prw 
/*/
 
User Function ITEM() 
    Local aParam := PARAMIXB 
    Local xRet := .T. 
    Local oObj := Nil 
    Local cIdPonto := ""
    Local cIdModel := ""
    Local nOper := 0 
    Local cCampo := ""
    Local cTipo := ""
    Local lEnd
 
    //Se tiver parâmetros
    If aParam != Nil 
        ConOut("> "+aParam[2]) 
 
        //Pega informações dos parâmetros
        oObj := aParam[1] 
        cIdPonto := aParam[2] 
        cIdModel := aParam[3] 
 
        //Valida a abertura da tela
        If cIdPonto == "MODELVLDACTIVE"
            xRet := .T. 
            //nOper := oObj:nOperation
 
            //Pré configurações do Modelo de Dados
        ElseIf cIdPonto == "MODELPRE"
            xRet := .T. 
 
            //Pré configurações do Formulário de Dados
        ElseIf cIdPonto == "FORMPRE"
            xRet := .T. 
 
            //nOper := oObj:GetModel(cIdPonto):nOperation
            //cTipo := aParam[4]
            //cCampo := aParam[5]
 
            //Se for Alteração
            //If nOper == 4
            //Não permite alteração dos campos
            //    If cTipo == "CANSETVALUE" .And. Alltrim(cCampo) $ ("CAMPO1;CAMPO2;CAMPO3")
            //        xRet := .F.
            //    EndIf
            //EndIf
 
            //Adição de opções no Ações Relacionadas dentro da tela
        ElseIf cIdPonto == "BUTTONBAR"
            xRet := {}
            //aAdd(xRet, {"* Titulo 1", "", {|| Alert("Botão 1")}, "Tooltip 1"})
            //aAdd(xRet, {"* Titulo 2", "", {|| Alert("Botão 2")}, "Tooltip 2"})
            //aAdd(xRet, {"* Titulo 3", "", {|| Alert("Botão 3")}, "Tooltip 3"})
 
            //Pós configurações do Formulário
        ElseIf cIdPonto == "FORMPOS"
            nOper := oObj:GetModel(cIdPonto):nOperation
 
            xRet := .T. 
 
            //Validação ao clicar no Botão Confirmar
        ElseIf cIdPonto == "MODELPOS"
            xRet := .T. 
 
            //Pré validações do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
 
            //Pós validações do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
 
            //Commit das operações (antes da gravação)
        ElseIf cIdPonto == "MODELCOMMITTTS"
            cTeste := ""
 
            //Commit das operações (após a gravação)
        ElseIf cIdPonto == "MODELCOMMITNTTS"
            nOper := oObj:nOperation
 
            //Mostrando mensagens no fim da operação
            If nOper == 3
                // Alert("Fim da Inclusão")
                 
            ElseIf nOper == 4  
                // Alert("Fim da Alteração")
            EndIf
        EndIf 
    EndIf 
Return xRet
