#Include 'Protheus.ch'

User Function GatNomeForn()

Local _cRetorno 


IF     !EMPTY(ALLTRIM(SC7->C7_FORNECE)) 

     _cRetorno := Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE,"SA2->A2_NREDUZ")      
      
Else 

    _cRetorno := SPACE(10)
      
Endif 

Return _cRetorno

