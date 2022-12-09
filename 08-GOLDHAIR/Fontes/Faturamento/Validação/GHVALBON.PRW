#INCLUDE "Protheus.ch"

USER FUNCTION GHVALBON
Local cProd   := ""
Local cBoni   := ""
Local nTotPed := 0 
Local lRet    := .T.

/*
Private cCodUser := Alltrim(UsrRetName(__CUSERID))

If (cCodUser != "Joao") .AND. (cCodUser != "Sue Ellen")
If M->C5_X_BON1 > 0 .OR. M->C5_X_BON2 > 0
	DbselectArea("SB1")
	SB1->(DbSetOrder(1)) // Filial + Produto
	nTotped := 0
	For nh:=1 to len(acols)
	    If !aCols[nh][len(aHeader)+1]
           cProd := acols[nh][GDFIELDPOS("C6_PRODUTO")]
           If SB1->(DbSeek(xFilial("SB1") + cProd))
	   	      cBoni :=POSICIONE("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_X_BONI")
	   		  If cBoni == "1"
	      	     nTotped += acols[nh][GDFIELDPOS("C6_VALOR")]
	   		  Endif   
		   Endif
		Endif	       
	Next nh                  
	If nTotped < GetMV("MV_X_PEDMI") .AND. M->C5_X_BON1 > 0
   		Alert("Pedido com valor menor do que o permitido para bonificação, percentuais serão zerados!")
   		lRet:= .F.
   		M->C5_X_BON1 := 0 
   	Endif	
    M->C5_X_TBO1 := nTotped * (M->C5_X_BON1 / 100)
    M->C5_X_TBO2 := nTotped * (M->C5_X_BON2 / 100)
Endif
If M->C5_X_BON1 > 10
   lRet := .F.
Endif
If M->C5_X_BON2 > 5
   lRet := .F.
Endif
Endif /**** cCodUser ***/

Return lRet