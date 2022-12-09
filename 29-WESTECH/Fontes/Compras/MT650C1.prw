#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH" 

User Function MT650C1()

// Após gravar o arquivo SC1 (Solicitações de compra) na inclusão
// de uma Ordem de Produção que gere Solicitação de Compras.

Local aAreaSC5  := SC5->( GetArea() )
Local aAreaSC1  := SC1->( GetArea() )

Local cItemCC
Local cOP		:= Alltrim(SC1->C1_OP)
Local cSC		:= Alltrim(SC1->C1_NUM)
Local cOP2		:= substr(Alltrim(SC1->C1_OP),1,6)

//msginfo ( "Numero OP: " + cOP )


dbSelectArea("SC2")
SC2->( dbSetOrder(1) ) 
If SC2->( dbSeek( xFilial("SC2")+cOP) )
	cItemCC  := SC2->C2_ITEMCTA
EndIf

//msginfo ( "Numero ItemCTA: " + cItemCC )


dbSelectArea("SC1")
SC1->( dbGoTop() )
SC1->(dbSetOrder(1) )


If SC1->( dbSeek(xFilial("SC1")+cSC) )
	
	While SC1->( ! EOF() ) //.AND. SC1->C1_OP == cOP
	
		   RecLock("SC1",.F.) 
				         
	               SC1->C1_ITEMCTA	:= cItemCC
	            
	       MsUnlock()  
	    
	     SC1->( dbSkip() )
	
	EndDo

ENDIF


Return ( nil )

