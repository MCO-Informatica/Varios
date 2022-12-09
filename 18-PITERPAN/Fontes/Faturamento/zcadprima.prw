//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} ZCADPRIM
Função de Teste
@type function
@author Terminal de Informação
@since 13/11/2016
@version 1.0
    @example
    u_zTeste()
/*/
 
User Function ZCADPRIM()
    Local aArea    := GetArea()
    Local aAreaZ1  := ZZ1->(GetArea())
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T." //Pode ser colocado como "u_zVldTst()"
 
    //Chamando a tela de cadastros
    AxCadastro('ZZ1', 'Cadastro de Materia Prima Piterpan', cDelOk, cFunTOk)
 
    RestArea(aAreaZ1)
    RestArea(aArea)
Return