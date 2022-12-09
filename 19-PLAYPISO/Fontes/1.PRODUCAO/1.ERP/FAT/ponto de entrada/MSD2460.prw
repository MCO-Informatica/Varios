/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   ºAutor  ³JOVENIRIAM T. L. SOUSA     ³  27/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para atualizar CAMPOS CENTRO DE CUSTO,     º±±
±±º          ³ITEM CONTABIL E CLVL nos itens da nf                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2460()

Local aArea := GetArea()
Local cMovEst 

DbSelectArea("SC6") 
DbSelectArea("SD2")    

RecLock("SD2", .f.) 

  SD2->D2_CCUSTO	:= SC6->C6_CCUSTO       
  SD2->D2_PROJPMS	:= SC6->C6_PROJPMS  // Incluido por MHD 14/01/2010
  //SD2->D2_ITEMCC	:= SC6->C6_ITEMCC
  SD2->D2_CLVL  	:= SC6->C6_CLVL            
  
  If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+SD2->D2_TES,1,"N") == "S"       
     Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_COD")
     //{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
     //U_AEST001({SD2->D2_QUANT,0,"",SD2->D2_LOCAL,"D2",SD2->(Recno()),"501"})  //[Mauro Nagata, Actual Trend, 19/11/2010]
     U_AEST001({SD2->D2_QUANT,SD2->D2_CUSTO1,"",SD2->D2_LOCAL,"D2",SD2->(Recno()),"510",SD2->D2_DOC})       //definir um TM para esta movimentacao especifica
  EndIf   

Msunlock()

RestArea(aArea)
Return