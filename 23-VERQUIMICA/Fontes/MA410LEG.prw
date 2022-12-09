User Function MA410LEG()   

Local aArea  := GetArea()    

Local aLegenda := {}
Aadd(aLegenda,	{"ENABLE"    ,"Pedido de Venda em aberto"})              
Aadd(aLegenda,	{"BR_MARROM" ,"Pedido de Venda Liberado" })
Aadd(aLegenda,	{"BR_PINK"	 ,"Pedido de venda em Bloqueio de Regra"})
Aadd(aLegenda,	{"BR_LARANJA","Pedido de Venda em Bloqueio de Credito"})
Aadd(aLegenda,	{"BR_AMARELO","Pedido de Venda em Bloqueio de Estoque"})
Aadd(aLegenda,	{"DISABLE"   ,"Pedido Encerrado"})     
RestArea(aArea)                                            

Return(aLegenda)
