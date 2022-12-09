#Include "Protheus.ch" 
  
 /*/{Protheus.doc} User Function xGARMAZ() 
 ?    (long_description) 
 ?    @type  Function 
 ?    @author Lucas Baia - UPDUO 
 ?    @since 13/05/2021 
 ?    @version version 
 ?    @param  
 ?    @return  
 ?    @example 
 ?    (examples) 
 ?    @see (links_or_references) 
 ?    /*/ 
User Function RESTG08() 
  
Local cLocal := aCols[n,Ascan(aHeader,{|x|Alltrim(x[2])=="D3_LOCAL"})] 
Local cTipo  := Posicione("SB1",1,xFilial("SB1")+aCols[n,Ascan(aHeader,{|x|Alltrim(x[2])=="D3_COD"})],"B1_TIPO")
Local nCount := 0
  
  
FOR nCount := 1 to Len(aCols) 
  
    IF !aCols[nCount][Len(aHeader)+1] 
    
        IF cFilAnt$"0101/0102/0107/0109/0110/0111/0113/0114/0115/0119/0120/0121/0122/0123" 
            cLocal := subs(cFilAnt,3,2)+"A1" 
        ELSEIF cFilAnt$"0118" 
            cLocal := "08A1" 
        ELSEIF cFilAnt$"0103"
            If cTipo$"PA"
                cLocal := "03A1"
            ElseIf cTipo$"EM"
                cLocal := "03A3"
            ElseIf cTipo$"MP"
                cLocal := "03A2"
            EndIf
        ELSEIF cFilAnt$"0106"
            If cTipo$"PA"
                cLocal := "06A1"
            ElseIf cTipo$"EM"
                cLocal := "06A3"
            ElseIf cTipo$"MP"
                cLocal := "06A2"
            EndIf
        ENDIF 
    
    ENDIF 
 
NEXT nCount 
  
Return cLocal
