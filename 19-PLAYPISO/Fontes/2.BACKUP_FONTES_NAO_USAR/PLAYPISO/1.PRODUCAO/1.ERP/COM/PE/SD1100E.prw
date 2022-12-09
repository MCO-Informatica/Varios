/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD1100E   ºAutor  ³Alexandre Sousa     º Data ³  11/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. durante a exclusao do documento de entrada             º±±
±±º          ³utilizado para sincronizar o estoque das filiais.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA / ACTUAL.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SD1100E()
                                                                            
  //If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SD2->D2_TES,1,"N") == "S"  //[Mauro Nagata, Actual Trend, 19/11/2010]
  If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SD1->D1_TES,1,"N") == "S"
     Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_COD")
     //{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
     //U_AEST001({SD1->D1_QUANT,0,"",SD1->D1_LOCAL,"D1",SD1->(Recno()),"501"})  //[Mauro Nagata, Actual Trend, 19/11/2010]
     U_AEST001({SD1->D1_QUANT,SD1->D1_TOTAL,"",SD1->D1_LOCAL,"D1",SD1->(Recno()),"510",SD1->D1_DOC})       //definir um TM para esta movimentacao especifica        
  EndIf

Return