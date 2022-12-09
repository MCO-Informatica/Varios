#Include "RwMake.Ch"


User Function VALPRC
*-------------------- 
// Valida o preco de venda na digitacao do pedido
Local wret := .T. 
Dbselectarea("SB5")
Dbsetorder(1)
Dbseek(xFilial("SB5")+aCols[N,2],.F.)
If M->C6_PRCVEN < (SB5->B5_PRV3 - (SB5->B5_PRV3 * 0.10))
   Alert("Atencao, preco 10% abaixo da Tabela "+Str((SB5->B5_PRV3 - (SB5->B5_PRV3 * 0.10)),10,2))
   //wret := .F.
Endif
Return(wret)







