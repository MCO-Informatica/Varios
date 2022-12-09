/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A250ETRAN ºAutor  ³Microsiga           º Data ³  11/18/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A250ETRAN()

	dbSelectArea("SF5")
	Set Filter To 
	dbGoTop()
            
    a_area := SD3->(GetArea())
	DbSelectArea('SD3')
	DbSetOrder(1) //D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
	If DbSeek(xFilial('SD3')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
		While SD3->(!EOF()) .and. SD3->D3_OP = SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)       
			
			If SD3->D3_TM == "001"
				Posicione("SF5",1,xFilial("SF5")+"010","F5_CODIGO")
				Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")
				//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento,documento de entrada/saida}
				//U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"300"}) //[Mauro Nagata, Actual Trend, 19/11/2010]
				U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"011",SC2->(C2_NUM+C2_ITEM)})       //definir um TM para esta movimentacao especifica
			Else
				Posicione("SF5",1,xFilial("SF5")+"510","F5_CODIGO")
				Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")
				//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento,documento de entrada/saida}
				//U_AEST001({SD3->D3_QUANT,0,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"501"})       //[Mauro Nagata, Actual Trend, 19/11/2010]
				U_AEST001({SD3->D3_QUANT,0,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"511",SC2->(C2_NUM+C2_ITEM)})       //definir um TM para esta movimentacao especifica
			EndIf
			
			SD3->(DbSkip())
		EndDo
	EndIf   
	RestArea(a_area)
	

	dbSelectArea("SF5")
	Set Filter To F5_TIPO == "P"
	dbGoTop()

Return