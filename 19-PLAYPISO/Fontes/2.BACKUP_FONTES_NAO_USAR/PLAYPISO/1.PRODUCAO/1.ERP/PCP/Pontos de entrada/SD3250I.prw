/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SD3250I   �Autor  �Alexnadre Sousa     � Data �  11/18/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada durante o apontamento de producao          ���
���          �Utilizado para sincronizar os estoques das filiais.         ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA / ACTUAL TREND.                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SD3250I()

	If SD3->D3_TM == "001"
		Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")
		//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
		//U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"300"})  //[Mauro Nagata, Actual Trend, 19/11/2010]
		U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"010",SD3->D3_DOC})       //definir um TM para esta movimentacao especifica
	Else
		Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")
		//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
		//U_AEST001({SD3->D3_QUANT,0,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"501"})  //[Mauro Nagata, Actual Trend, 19/11/2010]
		U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"510",SD3->D3_DOC})       //definir um TM para esta movimentacao especifica
	EndIf

Return