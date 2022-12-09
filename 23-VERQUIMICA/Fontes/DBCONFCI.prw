#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: DBCONFCI   | Autor: Danilo Alves Del Busso| Data: 18/11/2015 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Consulta e Preenche o código FCI do Produto Verquímica     |||
||+-----------+------------------------------------------------------------+||
||| Alterado Por: | 										| Data:		   |||
||+-----------+------------------------------------------------------------+||
||| Descrição:| 					                                       |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/        

User Function DBCONFCI(lote, produto, mp) 
	Local cCodFCI := ""
	Local cNumItem := ""   
                                  
	DbSelectArea("SC6"); DbSetOrder(1)
   //	nPosLote := aScan(aHeader,{|x| Alltrim(x[2])=='C6_LOTECTL'})        	                                  
           	                                          
	if(N<10)
		cNumItem := "0"+cValToChar(N)
	else
		cNumItem := cValToChar(N)		
	endif
	  
	If SC6->(DbSeek(xFilial("SC5")+SC5->C5_NUM+cNumItem))  
		cLoteCtl := SC6->C6_LOTECTL
		cProduto := SC6->C6_PRODUTO
		cMatPrim := SC6->C6_VQ_MP
		
	  	cCodFCI := POSICIONE("SD1",27,xFilial("SD1")+(cLoteCtl)+(cProduto),"D1_FCICOD")     
	  	If(Empty(cCodFCI))
	  		cCodFCI := POSICIONE("SD1",15,xFilial("SD1")+(cLoteCtl)+(cMatPrim),"D1_FCICOD")     
	  	EndIf      	   
	EndIf		
Return (cCodFCI)
