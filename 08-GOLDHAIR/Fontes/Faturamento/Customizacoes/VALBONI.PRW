#INCLUDE "PROTHEUS.CH"


/****************************************************************************
* Programa: GHVALBON  * Autor  Fábio Alves Carneiro  * Data   03/07/13      *
*****************************************************************************
* Desc.:     Validação se pedido está em condições de ser bonificado        *                            
*****************************************************************************
* Uso:       Gold Hair                                                      *
****************************************************************************/

/***************************************************************************/
User Function GHVALBON
/***************************************************************************/

Local cProd   := ""
Local cBoni   := ""
Local nTotPed := 0 
      lRet    := .T.
      
If M->C5_X_BON1 > 0 .OR. M->C5_X_BON2 > 0
	DbselectArea("SB1")
	SB1->(DbSetOrder(1)) // Filial + Produto
	For nh:=1 to len(acols)
		cProd := aCols[n][Ascan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO"})]
		If SB1->(DbSeek(xFilial("SB1") + cProd))
	   		cBoni :=POSICIONE("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_X_BONI")
	   		if cBoni == "1"
	      		nTotped += acols[nh][GDFIELDPOS("C6_VALOR")]
	   		Endif   
		Endif    
	Next nh  
	If nTotped < GetMV("MV_X_PEDMI")
   		Alert("Pedido com valor menor do que o permitido para bonificação, percentuais serão zerados!")
   		lRet:= .F.
   	Endif
Endif	          
Return lRet
