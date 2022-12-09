#Include 'Protheus.ch'

//------------------------------------------------------------\
// Rotina | cpacer02 | Renato Ruy      	| Data | 30.06.14     |
// -----------------------------------------------------------|
// Descr. | Rotina para registro de informações complementares|
//        | do pedido de compras através da Analise de Pedido.|
//------------------------------------------------------------/
User Function cpacer02(cNumCpr,lInc,lAlt)

Local aArea		:= GetArea()

Local _aCab		:= {}
Local _aItem	:= {}
Local _aItens	:= {}


If lAlt
	
	nOpc:= 4
	DbSelectArea("SC7")
	DbSetOrder(1)
	If DbSeek(xFilial("SC7")+cNumCpr)
	
		aadd(_aCab,{"C7_NUM" 		,cNumCpr   			})
		aadd(_aCab,{"C7_EMISSAO" 	,dDataBase 			})
		aadd(_aCab,{"C7_FORNECE" 	,SC7->C7_FORNECE	})
		aadd(_aCab,{"C7_LOJA" 		,SC7->C7_LOJA		})
		aadd(_aCab,{"C7_COND" 		,SC7->C7_COND		})
		aadd(_aCab,{"C7_CONTATO" 	,"AUTO"				})
		aadd(_aCab,{"C7_FILENT"	,SC7->C7_FILENT		}) 
		
		Do While !Eof("SC7") .and. cNumCpr==SC7->C7_NUM
			_aItem := {}
			aadd(_aItem,{"C7_ITEM"		,SC7->C7_ITEM ,Nil})
			aadd(_aItem,{"C7_PRODUTO"	,SC7->C7_PRODUTO ,Nil})
			aadd(_aItem,{"C7_QUANT"		,SC7->C7_QUANT	 ,Nil})
			aadd(_aItem,{"C7_PRECO"		,SC7->C7_PRECO	 ,Nil})
			aadd(_aItem,{"C7_TOTAL"		,SC7->C7_TOTAL	 ,Nil})
			aadd(_aItem,{"C7_REC_WT" 	,SC7->(RECNO())  ,NIL})
			aadd(_aItens,_aItem)
			DbSelectArea("SC7")
			DbSkip()
		EndDo
		
		MATA120(1,_aCab,_aItens,nOpc)
	EndIf
EndIf

RestArea(aArea)
	
Return()
