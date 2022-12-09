/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³Mauro Nagata        º      ³  17/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE de quando esta valido a exclusao da NF Saida             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT   www.actualtrend.com.br                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2520E()

Local aArea     := GetArea()                         //armazena area corrente
Local aArea_SD2 := SD2->(GetArea())                 //armazena area da tabela SD2
Local cDoc      := SF2->F2_DOC                      //armazena o numero do documento de saida
Local cSerie    := SF2->F2_SERIE                    //armazena a serie do documento de saida
                                   
/*                                                                                                                    
Em razao das filiais utilizarem o mesmo estoque foi customizado 
para que ao excluir um documento de saida que movimentasse o estoque 
a mesma quantidde fosse abatido do estoque da outra filial
*/
DbSelectArea("SD2")    
DbSetOrder(3)
DbSeek(xFilial("SD2")+cDoc+cSerie)
Do While !Eof().And.SD2->D2_DOC==cDoc.And.SD2->D2_SERIE==cSerie                     //verifica todos os itens do documento excluido
  If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SD2->D2_TES,1,"N") == "S"         //verifica se a TES do item movimenta estoque
     Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_COD")                         //posiciona o produto do item
     //{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
     //U_AEST001({SD2->D2_QUANT,0,"",SD2->D2_LOCAL,"D2",SD2->(Recno()),"002"})   //[Mauro Nagata, Actual Trend, 19/11/2010]
     U_AEST001({SD2->D2_QUANT,SD2->D2_CUSTO1,"",SD2->D2_LOCAL,"D2",SD2->(Recno()),"010",SD2->D2_DOC})       //definir um TM para esta movimentacao especifica
  EndIf                               
  SD2->(DbSkip())
EndDo
RestArea(aArea_SD2)  
RestArea(aArea)
Return