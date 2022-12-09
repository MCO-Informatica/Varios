#include "totvs.ch"

//Renato Ruy - 07/02/2018
//Ajusta o rateio para gravar com a informação da filial de entrega diferente
//No link abaixo a Totvs informa que nao funcionara mais desta forma
//O usuario devera efetuar o rateio novamente no documento de entrada
//http://tdn.totvs.com/display/public/PROT/PCOM04015+-+Pedido+de+compras%28MATA121%29+com+rateio+e+filial+de+entrega+diferente+da+filial+de+origem

User Function SD1140I

If SC7->C7_FILIAL <> SC7->C7_FILENT

	dbSelectArea("SCH")  
	dbSetOrder(1) // CH_FILIAL+CH_PEDIDO+CH_FORNECE+CH_LOJA+CH_ITEMPD+CH_ITEM
	If(SCH->(DbSeek(SC7->(C7_FILIAL + C7_NUM + C7_FORNECE + C7_LOJA ))))
		While SCH->(!EOF()) .And. ; 
		SCH->(CH_FILIAL + CH_PEDIDO + CH_FORNECE+ CH_LOJA) == SC7->(C7_FILIAL + C7_NUM + C7_FORNECE + C7_LOJA  )
			dbSelectArea("SDE")  
			SDE->(dbSetOrder(1)) // DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF+DE_ITEM
			If !(SDE->(MsSeek(xFilial("SDE")+SD1->D1_DOC+SD1->D1_SERIE+SCH->CH_FORNECE+SCH->CH_LOJA+SD1->D1_ITEM+SCH->CH_ITEM)))
				
				RecLock("SDE",.T.)
				
				For nY := 1 to SDE->(FCount())
					nPos := SCH->(FieldPos("CH"+SubStr(SDE->(FieldName(nY)),3)))
					If nPos > 0 
						FieldPut(nY,SCH->(FieldGet(nPos)))
					EndIf
				Next nY
				
				SDE->DE_FILIAL	:= xFilial("SDE")
				SDE->DE_DOC		:= SD1->D1_DOC
				SDE->DE_SERIE		:= SD1->D1_SERIE
				SDE->DE_FORNECE	:= SD1->D1_FORNECE
				SDE->DE_LOJA	:= SD1->D1_LOJA
				SDE->DE_ITEMNF 	:= SD1->D1_ITEM											
				SDE->(MsUnLock())
			Endif
			SCH->(dbSkip())
		EndDo
	EndIf
Endif

Return