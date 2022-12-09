#Include "RwMake.Ch"

//========================================================================================================================================================
//Nelson Hammel - 27/07/11 - Rotina para validar o preco de venda na digitacao do pedido, na verdade copia da rotina VALPRC com algumas adequações e melhorias
//========================================================================================================================================================

User Function VALPRC01

Local wret := .T. 
xPosProduto	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})

Dbselectarea("SB5")
Dbsetorder(1)

Dbseek(xFilial("SB5")+aCols[N,xPosProduto],.F.)
If M->UB_VRUNIT < (SB5->B5_PRV3 - (SB5->B5_PRV3 * 0.10))
   Alert("Atencao, preco 10% abaixo da Tabela "+Str((SB5->B5_PRV3 - (SB5->B5_PRV3 * 0.10)),10,2))
   //wret := .F.
Endif
Return(wret)







