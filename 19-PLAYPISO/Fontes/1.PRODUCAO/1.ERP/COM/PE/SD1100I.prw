/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SD1100I   �Autor  �Alexnadre Sousa     � Data �  11/17/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. durante a gravacao do item da nota fiscal de entrada.  ���
���          �utilizado para repclicar o estoque na outra filial.         ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA / ACTUAL TREND.                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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