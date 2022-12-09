#INCLUDE "Protheus.ch"                              
#INCLUDE "TopConn.ch"

User Function SF2460I()
Local aAreaSD2     := SD2->( GetArea() )
Local aAreaSF2     := SF2->( GetArea() )

Local cPedido  := SD2->D2_PEDIDO
Local cCliente := SD2->D2_CLIENTE
Local cLoja    := SD2->D2_LOJA
Local cItemCC

dbSelectArea("SC5")
SC5->( dbSetOrder(3) ) 
If SC5->( dbSeek( xFilial("SC5")+cCliente+cLoja+cPedido) )
	//msginfo("1" + cItemCC)
	cItemCC  := SC5->C5_XXIC
EndIf

dbSelectArea("SD2")
SD2->( dbGoTop() )
SD2->(dbSetOrder(8) ) // D2_FILIAL + D2_PEDIDO

If SD2->( dbSeek(xFilial("SD2")+cPedido) )

                While SD2->( ! EOF() ) .AND. SD2->D2_CLIENTE == cCliente    ;
                           .AND. SD2->D2_LOJA    == cLoja       ;
                           .AND. SD2->D2_PEDIDO  == cPedido
                
                               RecLock("SD2",.F.)            
                                         SD2->D2_ITEMCC := cItemCC
                               MsUnlock()  
 
                               SD2->( dbSkip() )
                EndDo
                msginfo("2" + cItemCC)
EndIf

RestArea(aAreaSD2)
RestArea(aAreaSF2) 

Return( NIL )

