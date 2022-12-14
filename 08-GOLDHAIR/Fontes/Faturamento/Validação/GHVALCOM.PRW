#INCLUDE "PROTHEUS.CH"


/****************************************************************************
* Programa: GHVALCOM  * Autor  F?bio Alves Carneiro  * Data   20/08/13      *
*****************************************************************************
* Desc.:     Checa se comiss?o est? compat?vel com o cadastro do vendedor   *
*            apenas usu?rio Jo?o consegue passar por essa valida??o         *                            
*****************************************************************************
* Uso:       Gold Hair                                                      *
****************************************************************************/

/***************************************************************************/
User Function GHVALCOM
/***************************************************************************/

Local nComiss := 0 
Local lRet    := .T.
Private cCodUser := Alltrim(UsrRetName(__CUSERID))

If (cCodUser != "Joao")      
   nComiss :=POSICIONE("SA3",1,xFilial("SA3")+M->C5_VEND1,"SA3->A3_COMIS")
   IF M->C5_COMIS1 == nComiss
      lRet := .T.
   Else
      lRet := .F.
   Endif
Endif         
Return lRet