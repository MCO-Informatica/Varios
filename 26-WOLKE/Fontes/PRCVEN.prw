#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function PRCVEN() 
Local aAreaAtu 	:= GetArea()
Local nValor := M->CK_PRCVEN
Local nMinVlr := 0
Local cProduto := CK_PRODUTO
Local lRet := .T.
nMinVlr := POSICIONE("DA1",1,xFilial("DA1")+"002"+cProduto,"DA1_PRCLIQ")

IF nValor < nMinVlr
	     
	MSGINFO("Valor menor que o valor autorizado para venda."+CRLF+"Valor minimo de venda : R$ "+ALLTRIM(Transform(nMinVlr,PESQPICT("SCK","CK_PRCVEN")))) 
	lRet := .F.                 
                 
endif

       
RestArea(aAreaAtu)
return(lRet) 