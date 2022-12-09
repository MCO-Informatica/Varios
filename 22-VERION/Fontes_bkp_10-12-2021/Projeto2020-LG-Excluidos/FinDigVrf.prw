#include "protheus.ch"
#include "topconn.ch"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINDIGVRF ºAutor  ³Silverio Bastos     º Data ³  03/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito da Agencia e Conta Corrente do Bradesco  º±±
±±º          ³ para ser incluso no arquivo de remessa PagFor, posicao 99  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verion                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function DigVerf

M->nCont   := 0
M->cPeso   := 2
M->nBanco  := SUBSTR(SE2->E2_CODBAR,1,3)
M->nAgenc  := SUBSTR(SE2->E2_CODBAR,20,4)
M->nConta  := SUBSTR(SE2->E2_CODBAR,37,7)

IF M->nBanco == "237"
		
   For i := LEN(M->nConta) To 1 Step -1
		
       M->nCont := M->nCont + (Val(SUBSTR(M->nConta,i,1))) * M->cPeso
			
       M->cPeso := M->cPeso + 1
			
       If M->cPeso == 8
          M->cPeso := 2
       Endif
			
   Next
		
   M->Resto := ( M->nCont % 11 )
		
   Do Case
      Case M->Resto == 1
           M->DV_NNUM := "P"
      Case M->Resto == 0
	        M->DV_NNUM := "0"
	        OtherWise
	        M->Resto   := ( 11 - M->Resto )
		     M->DV_NNUM := AllTrim(Str(M->Resto))
   EndCase    

   M->nCont   := 0
   M->cPeso   := 2

   For i := LEN(M->nAgenc) To 1 Step -1
		
       M->nCont := M->nCont + (Val(SUBSTR(M->nAgenc,i,1))) * M->cPeso
			
       M->cPeso := M->cPeso + 1
			
       If M->cPeso == 8
          M->cPeso := 2
       Endif
			
   Next
		
   M->Resto := ( M->nCont % 11 )
		
   Do Case
      Case M->Resto == 1
           M->DV_NNAG := "P"
      Case M->Resto == 0
	        M->DV_NNAG := "0"
	        OtherWise
	        M->Resto   := ( 11 - M->Resto )
		     M->DV_NNAG := AllTrim(Str(M->Resto))
   EndCase    
	
	L_CODAG := strzero(VAL(SUBSTR(SE2->E2_CODBAR,20,4)),5)+M->DV_NNAG+STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13)+M->DV_NNUM

Else
	
   L_CODAG := STRZERO(0,21)

Endif		

return(L_CODAG)

USER Function DigVer2

M->nBanco  := SUBSTR(SE2->E2_CODBAR,1,3)

If M->nBanco == "237"

   L_CODAG2 := STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,24,2)),3)

else

   L_CODAG2 := STRZERO(0,3)

endif          

return(L_CODAG2)

USER Function DigVer3

M->nBanco  := SUBSTR(SE2->E2_CODBAR,1,3)

If M->nBanco == "237" 

   L_CODAG3 := STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,26,11)),12)

Else

   L_CODAG3 := STRZERO(0,12)

Endif	

return(L_CODAG3)