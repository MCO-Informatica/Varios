/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD1100I   ºAutor  ³Alexnadre Sousa     º Data ³  11/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. durante a gravacao do item da nota fiscal de entrada.  º±±
±±º          ³utilizado para repclicar o estoque na outra filial.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA / ACTUAL TREND.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SD1100I()
                                                                            
  //If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SD2->D2_TES,1,"N") == "S"  //[Mauro Nagata, Actual Trend, 19/11/2010]
  If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SD1->D1_TES,1,"N") == "S"
     Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_COD")
     //{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
     //U_AEST001({SD1->D1_QUANT,SD1->D1_TOTAL,"",SD1->D1_LOCAL,"D1",SD1->(Recno()),"300"}) //[Mauro Nagata, Actual Trend, 19/11/2010]
     U_AEST001({SD1->D1_QUANT,SD1->D1_TOTAL,"",SD1->D1_LOCAL,"D1",SD1->(Recno()),"010",SD1->D1_DOC})       //definir um TM para esta movimentacao especifica    
  EndIf


Return