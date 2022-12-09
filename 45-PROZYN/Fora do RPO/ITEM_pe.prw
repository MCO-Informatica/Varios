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
 
    //Se tiver par�metros
    If aParam != Nil 
        ConOut("> "+aParam[2]) 
 
        //Pega informa��es dos par�metros
        oObj := aParam[1] 
        cIdPonto := aParam[2] 
        cIdModel := aParam[3] 
 
        //Valida a abertura da tela
        If cIdPonto == "MODELVLDACTIVE"
            xRet := .T. 
            //nOper := oObj:nOperation
 
            //Pr� configura��es do Modelo de Dados
        ElseIf cIdPonto == "MODELPRE"
            xRet := .T. 
 
            //Pr� configura��es do Formul�rio de Dados
        ElseIf cIdPonto == "FORMPRE"
            xRet := .T. 
 
            //nOper := oObj:GetModel(cIdPonto):nOperation
            //cTipo := aParam[4]
            //cCampo := aParam[5]
 
            //Se for Altera��o
            //If nOper == 4
            //N�o permite altera��o dos campos
            //    If cTipo == "CANSETVALUE" .And. Alltrim(cCampo) $ ("CAMPO1;CAMPO2;CAMPO3")
            //        xRet := .F.
            //    EndIf
            //EndIf
 
            //Adi��o de op��es no A��es Relacionadas dentro da tela
        ElseIf cIdPonto == "BUTTONBAR"
            xRet := {}
            //aAdd(xRet, {"* Titulo 1", "", {|| Alert("Bot�o 1")}, "Tooltip 1"})
            //aAdd(xRet, {"* Titulo 2", "", {|| Alert("Bot�o 2")}, "Tooltip 2"})
            //aAdd(xRet, {"* Titulo 3", "", {|| Alert("Bot�o 3")}, "Tooltip 3"})
 
            //P�s configura��es do Formul�rio
        ElseIf cIdPonto == "FORMPOS"
            nOper := oObj:GetModel(cIdPonto):nOperation
 
            xRet := .T. 
 
            //Valida��o ao clicar no Bot�o Confirmar
        ElseIf cIdPonto == "MODELPOS"
            xRet := .T. 
 
            //Pr� valida��es do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
 
            //P�s valida��es do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
 
            //Commit das opera��es (antes da grava��o)
        ElseIf cIdPonto == "MODELCOMMITTTS"
            cTeste := ""
 
            //Commit das opera��es (ap�s a grava��o)
        ElseIf cIdPonto == "MODELCOMMITNTTS"
            nOper := oObj:nOperation
 
            //Mostrando mensagens no fim da opera��o
            If nOper == 3
                // Alert("Fim da Inclus�o")
                 
            ElseIf nOper == 4  
                // Alert("Fim da Altera��o")
            EndIf
        EndIf 
    EndIf 
Return xRet
