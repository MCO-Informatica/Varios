#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
 
User Function F050ROT()
     
    Local aArea   := GetArea()
    Local aRotina := Paramixb // Array contendo os botoes padrões da rotina.
 
    // Tratamento no array aRotina para adicionar novos botoes e retorno do novo array.
    /*Aadd(aRotina, { "Rastrear LP",;
                    "U_CSCTB01('SE2',SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO,SE2->(RECNO()))",0, 8, 0,.F.})*/
    
    //Yuri Volpe - 18.11.19
    //Adequação para padrão MVC - Errorlog pós migração de release
    ADD OPTION aRotina TITLE "Rastrear LP" ACTION "U_CSCTB01('SE2',SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO,SE2->(RECNO()))" OPERATION 2 ACCESS 0
    
    RestArea(aArea)
 
Return aRotina