User Function AGCTAFAV()

If SA2->A2_BANCO == "341"
      If Substr(SEA->EA_MODELO,1,2)=="02" .or. Substr(SEA->EA_MODELO,1,2)=="10"
         _xCta := "00000"
         _xDAC := "0"
       Else 
         _xCta := Strzero(Val(SA2->A2_NUMCON),5)
         _xDAC := Substr(SA2->A2_XDVCONT,1,1)
       EndIf  
      _xAgCta := Strzero(Val(SA2->A2_AGENCIA),5)+" "+"0000000"+_xCta+" "+_xDAC
Else 
      If Substr(SA2->A2_XDVCONT,1,2) <> " "
         _xAgCta := Strzero(Val(SA2->A2_AGENCIA),5)+" "+Strzero(Val(SA2->A2_NUMCON),12)+SA2->A2_XDVCONT
      Else 
         _xAgCta := Strzero(Val(SA2->A2_AGENCIA),5)+" "+Strzero(Val(SA2->A2_NUMCON),12)+" "+Substr(SA2->A2_XDVCONT,1,1)
      EndIf   
EndIf   

Return(_xAgCta)