#Include 'Protheus.ch'

User Function A650PROC()

Local aAreaSC2     := SC2->( GetArea() )
Local aAreaSC5     := SC5->( GetArea() )
Local cPedido  := SC2->C2_NUM
//Local cOP		:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Local cItemCC

dbSelectArea("SC6")
SC6->( dbSetOrder(1) ) 
If SC6->( dbSeek( xFilial("SC6")+cPedido) )
cItemCC  := SC6->C6_XXIC

EndIf

dbSelectArea("SC2")
SC2->( dbGoTop() )
SC2->(dbSetOrder(1) ) // D2_FILIAL + D2_PEDIDO

If SC2->( dbSeek(xFilial("SC2")+cPedido) )

                While SC2->( ! EOF() ) .AND. SC2->C2_PEDIDO  == cPedido
                
                               RecLock("SC2",.F.)            
                                               SC2->C2_ITEMCTA := cItemCC
                               MsUnlock()  
 
                               SC2->( dbSkip() )
                EndDo

EndIf

RestArea(aAreaSC2)
RestArea(aAreaSC5) 

Return()
