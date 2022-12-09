/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT185SD3  ºAutor  ³Mauro Nagata        º Data ³  22/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada durante a atualizacao das variaveis de     º±±
±±ºDesc.     ³memoria para Inclusao no SD3                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA / ACTUAL TREND.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT185SD3()

Posicione("SB1",1,xFilial("SB1")+M->D3_COD,"B1_COD")
//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
U_AEST001({M->D3_QUANT,M->D3_CUSTO1,"",M->D3_LOCAL,"D3",SD3->(Recno()),"510",M->D3_DOC})       //definir um TM para esta movimentacao especifica


aArea_SB2 := SB2->(GetArea())     //saldo atual     

/*
//movimentar os estou da outra filial quando faturar e tiver movimentacao de estoque            
cFilOld := cFilAnt
cFilAnt := If(cFilAnt="01","02","01")
SM0->(MsSeek(cEmpAnt + cFilAnt))     

SB2->(DbSetOrder(1))
If SB2->(DbSeek(xFilial("SB2")+M->D3_COD+M->D3_LOCAL))
   RecLock("SB2",.F.)
   SB2->B2_QATU -= M->D3_QUANT                 //subtrai o movimento da baixa da pre requisicao
   SB2->(MsUnLock())
EndIf   	
	
//Restaurar a filial
cFilant := cFilOld
SM0->(MsSeek(cEmpAnt + cFilAnt))     

RestArea(aArea_SB2)
*/	

Return