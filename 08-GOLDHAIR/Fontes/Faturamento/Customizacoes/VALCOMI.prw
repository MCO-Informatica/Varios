#INCLUDE "PROTHEUS.CH"


/****************************************************************************
* Programa: GHVALCOM  * Autor  F�bio Alves Carneiro  * Data   20/08/13      *
*****************************************************************************
* Desc.:     Checa se comiss�o est� compat�vel com o cadastro do vendedor   *
*            apenas usu�rio Jo�o consegue passar por essa valida��o         *                            
*****************************************************************************
* Uso:       Gold Hair                                                      *
****************************************************************************/

/***************************************************************************/
User Function GHVALCOM
/***************************************************************************/

Local cProd   := ""
Local cBoni   := ""
Local nTotPed := 0 

lRet    := .T.
/*      
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
   		Alert("Pedido com valor menor do que o permitido para bonifica��o, percentuais ser�o zerados!")
   		lRet:= .F.
   	Endif
Endif	          
*/

Return lRet
