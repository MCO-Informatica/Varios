#include "rwmake.ch"       
#include "protheus.ch"
  


//GATILHO    QTDVEN -> PRCVEN
User Function TABPRICE()     

   

Local  nPosProd:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRODUTO" })
Local  nPosQtd:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_QTDVEN" })
Local  nPosVal:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_VALOR" })
SetPrvt("PRECO_TAB") 


preco_tab := 0

//If M->C5_X_ORIG == "P" 

	

	dbselectarea("SB1")
	SB1->(dbsetorder(1))    
	SB1->(dbseek(xFilial("SB1") + acols[n,nPosProd]))     
	
	dbSelectArea("SB5")        
	SB5->(dbSetOrder(1))
	SB5->(dbSeek(xFilial("SB5") + acols[n,nPosProd]))
	
	dbselectarea("DA1")
	dbsetorder(1) 
	dbseek(xFilial("DA1")+M->C5_TABELA+acols[n,nPosProd])
	preco_tab := DA1->DA1_PRCVEN 
		If SB1->B1_LACRE <> "L" 
	
	     
	     	If acols[n,nPosQtd] <= 0.999
	        	preco_tab := DA1->DA1_PRCVEN // trocar
	     	endif    
	 	     
		     if acols[n,nPosQtd] >= 1.000 .and. acols[n,nPosQtd] <= 4.999
		        preco_tab := DA1->DA1_XFX2 //trocar
		     endif
		     
		     if acols[n,nPosQtd] >= 5.000 
		        preco_tab := DA1->DA1_XFX3 // trcar
		     endif
	  
	  	Else
	    		// Preços do lacre 
		     if acols[n,nPosQtd] >= 5.000 .and. acols[n,nPosQtd] <= 9.999
		        preco_tab := SB5->B5_PRV4 
		     endif
		     
		     if acols[n,nPosQtd] >= 10.000 
		        preco_tab := SB5->B5_PRV10 
		     endif    
		     
		   
		Endif     
	
Return(preco_tab)      
                         
                     



//VALIDAÇÃO DO USUARIO PRODUTO
USER FUNCTION PRODMTA410()

LOCAL LRET:=.T.
IF M->C5_X_ORIG == "W" .AND. EMPTY(M->C5_TABELA)
	LRET:=.F.
	ALERT("PREENCHA A TABELA DE PREÇO")
ENDIF

RETURN(LRET)

     


//validação do usuario tabela
user function TABMT410()

local lret:=.t.

IF M->C5_X_ORIG == "W"
	if EMPTY(M->C5_TABELA)
		lret:= .f.
	endif
endif                 



return(lret)



