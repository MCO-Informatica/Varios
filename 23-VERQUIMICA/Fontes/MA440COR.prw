#Include "Protheus.ch"

User Function MA440COR()
Local aCores :={}

Aadd(aCores,	{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .AND. Empty(SC5->C5_BLQ) " ,"BR_VERDE","Pedido de Venda em aberto"    })        						//Pedido Bloqueado por Regra      			                                                                                         
Aadd(aCores,    {"!Empty(SC5->C5_LIBEROK).And. Empty(SC5->C5_NOTA) .AND. !(U_DBVPCRD()) .AND. !(U_DBVPATE())","BR_MARROM ","Pedido de Venda Liberado" } )           
Aadd(aCores,	{"SC5->C5_BLQ == '1'", "BR_PINK"})        						//Pedido Bloqueado por Regra      
Aadd(aCores,	{"Empty(SC5->C5_BLQ) .AND. U_DBVPCRD()"	, "BR_LARANJA"	})	//Pedido bloqueado por Credito
Aadd(aCores,	{"Empty(SC5->C5_BLQ) .AND. U_DBVPATE()"	, "BR_AMARELO"	}) 	//Bloqueado por Estoque
Aadd(aCores,	{"!Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK=='E'"   ,"DISABLE"   }) //Pedido Encerrado     


Return aCores