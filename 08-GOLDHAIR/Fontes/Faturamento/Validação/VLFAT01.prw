
#INCLUDE "Protheus.ch"

User Function VLFAT01(nLinha,cProd)
Local lRet    := .T.

/*
Local nQtdTOT := 0
Local aArea   := GetArea()      
Local cBoni   := ""
//Local cProd   := aCols[n][Ascan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO"})]
Private cCodUser := Alltrim(UsrRetName(__CUSERID))

If (cCodUser != "Joao") .AND. (cCodUser != "Fabio")
If M->C5_X_PEDBO == "1"
   If SB1->(DbSeek(xFilial("SB1") + cProd))
      cBoni :=POSICIONE("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_X_BONI")
      If cBoni <> "1"
         lRet := .F.
         Alert("Produto faz parte de grupo que nao pode ser bonificado!")
      Endif
   Endif
Endif            
Endif

For nh:=1 to len(acols)
	IF nh <> nLinha .and. !acols[nh][len(aHeader)+1]
		IF cProd == acols[nh][GDFIELDPOS("C6_PRODUTO")]
			Msgalert("Este Produto ja foi digitado neste Pedido na Linha "+ alltrim(str(nh))+" !")
			lRet := .F.
		ENDIF
	ENDIF 
Next nh                    
IF M->C5_CONDPAG == "999"
	M->C5_PARC1 := 0
	M->C5_PARC2 := 0
	M->C5_PARC3 := 0
	M->C5_PARC4 := 0
	M->C5_PARC5 := 0
ENDIF

RestArea(aArea)
*/

return lRet

