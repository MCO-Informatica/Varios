
/*/{Protheus.doc} User Function CADZA0
    (long_description)
    @type  Function
    @author Pirolo
    @since 26/10/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CADZA0()
 Local aRotAdic :={} 
 Local bPre := {||}
 Local bOK  := {||, .T.}
 Local bTTS  := {||}
 Local bNoTTS  := {||}    
 Local aButtons := {}//adiciona bot?es na tela de inclus?o, altera??o, visualiza??o e exclusao
 
 //aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Bot?o Teste" }  ) //adiciona chamada no aRotina
 //aadd(aRotAdic,{ "Adicional","U_Adic", 0 , 6 })
 AxCadastro("ZA0", "Classifica??o Customizada", , , aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )  

Return(.T.)                        
   
