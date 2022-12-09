#Include "Protheus.ch" 
  
 /*/{Protheus.doc} User Function rcomg02() 
 ?    (Gatilho verifica se o produto a dar entrada no armazen  01A3 está com o endereçamento ativo) 
 ?    @type  Function 
 ?    @author Vladimir Alves - UPDUO 
 ?    @since 05/09/2022 
 ?    @version version 
 ?    @param  
 ?    @return  
 ?    @example 
 ?    (examples) 
 ?    @see (links_or_references) 
 ?    /*/ 
User Function rcomg002() 
  
Local cLocliz  := Posicione("SB1",1,xFilial("SB1")+aCols[n,Ascan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})],"B1_LOCALIZ")
Local cArmz    := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_LOCAL" })]
Local _nQuant  := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_QUANT" })]  

  
        IF  AllTrim(cArmz)$"01A3" .AND. cLocliz == "N" .AND. CTIPO == "N"
            _nQuant := 0
            MsgAlert("O produto está com o controle de endereçamento desativado no cadastro. Solicite a correção do cadastro para poder realizar essa entrada.")
        ENDIF 
    
  
  
Return (_nQuant)
