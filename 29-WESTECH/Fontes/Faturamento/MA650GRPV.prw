#INCLUDE "Protheus.ch"                              
#INCLUDE "TopConn.ch"

User Function MA650GRPV()

// Após a gravação das informações referentes as OPs nos PVs.

Local aAreaSC5  := SC5->( GetArea() )
Local cPedido	:= SC2->C2_PEDIDO
Local cItemCC
Local cOP		:= Alltrim(SC2->C2_NUM)

//msginfo ( "Numero OP: " + cOP )
dbSelectArea("SC5")
SC5->( dbSetOrder(1) ) 
If SC5->( dbSeek( xFilial("SC5")+cOP) )
	cItemCC  := SC5->C5_XXIC
EndIf

//msginfo ( "Numero ItemCTA: " + cItemCC )


dbSelectArea("SC2")
SC2->( dbGoTop() )
SC2->(dbSetOrder(1) )


If SC2->( dbSeek(xFilial("SC2")+cOP) )
	
	While SC2->( ! EOF() ) .AND. SC2->C2_NUM == cOP
	
		   RecLock("SC2",.F.) 
				//msginfo ( cItemCC )           
	               SC2->C2_ITEMCTA	:= cItemCC
	               SC2->C2_PEDIDO 	:= cOP
	       MsUnlock()  
	    
	     SC2->( dbSkip() )
	
	EndDo

ENDIF

//**************************************
/*
dbSelectArea("SC1")
SC1->( dbGoTop() )
SC1->(dbSetOrder(4) )


If SC1->( dbSeek(xFilial("SC1")+cOP) )
	
	While SC1->( ! EOF() ) .AND. SC1->C1_OP == cOP
		   RecLock("SC1",.F.) 
				//msginfo ( "ARMAZENAR ITEMCTA: " + cItemCC )           
	               SC1->C1_ITEMCTA	:= cItemCC
	            //msginfo ( "ARMAZENAR ITEMCTA DEPOIS: " + cItemCC )   
	       MsUnlock()  
	    
	     SC1->( dbSkip() )
	
	EndDo

ENDIF
*/

RestArea(aAreaSC5)


Return( NIL )