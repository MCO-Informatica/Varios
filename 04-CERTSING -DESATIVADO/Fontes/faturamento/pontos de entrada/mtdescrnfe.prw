#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTDESCRNFEºAutor  ³Cristian Gutierrez  º Data ³  23/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para criacao de msg no pedido de vendas e  º±±
±±º          ³geracao de linhas para venda de kit conforme estrutura      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTDESCRNFE()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMens	:= cMen1	:= ""
Local cMen2	:= cMen3	:= ""
Local cMen4 :=''
Local cPedido :=''
DbSelectArea("SD2")
DbSetOrder(3)
DbGoTop()
DbSeek(xFilial("SD2")+ParamIxb[1]+ParamIxb[2]+ParamIxb[3]+ParamIxb[4])

If Found()
	
	cPedido:= SD2->D2_PEDIDO
	
	Do While !Eof("SD2") .and. xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == xFilial("SD2")+ParamIxb[1]+ParamIxb[2]+ParamIxb[3]+ParamIxb[4]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o produto no pedido eh um item de servico               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbGoTop()
		DbSeek(xFilial("SB1")+SD2->D2_COD)
		If Found()
			If SB1->B1_TIPO <> "MR" //tipo de produto servico
				cMen1 += AllTrim(SB1->B1_DESC) + ";"
				cMen1	+= Space(1) + "Qtde:"
				cMen1	+= Space(1) + 	AllTrim(Transform(SD2->D2_QUANT, "@E 999,999,999.99")) + ";"
				cMen1	+= Space(1) + "Preço Unitário:"
				cMen1	+= Space(1) + 	AllTrim(Transform(SD2->D2_PRCVEN, "@E 999,999,999.99")) + ";"
				cMen1	+= Space(1) + "Valor Total:"
				cMen1	+= Space(1) + 	AllTrim(Transform(SD2->D2_TOTAL,  "@E 9,999,999,999.99")) + ";"
				DbSelectArea("SC5")
				DbSetOrder(1)
				DbGoTop()
				DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
				If Found()
					If !Empty(SC5->C5_AR)
						cMen2	+= Space(1) + "A.R.: "		
						cMen2	+= Space(1) + SC5->C5_AR
					 	If !Empty(SC5->C5_NUMATEX)
					 		cMen2 += Space(1) + " Nº Atend. Externo:"
					 		cMen2 += Space(1) + SC5->C5_NUMATEX
					 	Endif
					 Else 
					   If !Empty(SC5->C5_CHVBPAG)
							cMen2	+= Space(1) + "NF Liquidada - Pedido Bpag: " + SC5->C5_CHVBPAG
						Endif 	
						/*
						If !Empty(SC5->C5_CHVBPAG)
							cMen	+= Space(1) + "PEDIDO BPAG:"		
							cMen	+= Space(1) + SC5->C5_CHVBPAG + ";"
						End If
						cMen	+= Space(1) + SC5->C5_MENNOTA
						
   					If At("PEDIDO BPAG", Upper(SC5->C5_MENNOTA)) > 0
  							cMen	+= Space(1) + Substr(AllTrim(SC5->C5_MENNOTA),At("PEDIDO BPAG", Upper(SC5->C5_MENNOTA)),Len(AllTrim(SC5->C5_MENNOTA)))
						Else
							cMen	+= Space(1) + AllTrim(SC5->C5_MENNOTA)						
						EndIf 						*/
					EndIf
				EndIf
				cMen1	+= "|"
			End If
		End If
		DbSelectArea("SD2")
		DbSkip()
	End Do
	
	// By Henio in 13/12/07
	If Empty(cMen2) 
		// cMen2	+= Space(1) + AllTrim(SC5->C5_MENNOTA)							
	   // Else
		cMen2	+= "|"
	 	cMen2	+= AllTrim(SC5->C5_MENNOTA)	
	Endif 		
	cMen3	+= "|"
	cMen3	+= "|"
	cMen3	+= "ESTA É UMA NOTA FISCAL DE SERVIÇO, CASO A SUA COMPRA SE COMPONHA DE MAIS ITENS, ENVIAREMOS A NOTA FISCAL DE PRODUTO POSTERIORMENTE EM FORMATO ELETRÔNICO."
	cMen3	+= "|" 
	cMen3   += "*** NOTA FISCAL NAO SUJEITA A RETENCAO NA FONTE DO ISS ***"
	cMen3	+= "|"
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbGoTop()
	If DbSeek(xFilial("SC5")+cPedido) .and. !Empty(SC5->C5_XMENSUG)
		cMen4	+= "| *** "		
		cMen4  += Alltrim(Formula(SC5->C5_XMENSUG)) +" *** |"
	
	Endif
	cMens := cMen1+cMen2+cMen3+cMen4

EndIf
Return(cMens)
