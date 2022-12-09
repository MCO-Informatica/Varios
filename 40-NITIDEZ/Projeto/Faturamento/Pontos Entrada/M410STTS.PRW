#include 'protheus.ch'

user function M410STTS()
Local nQtdTotC6 := 0
Local nQtdTotC9 := 0
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSC9 := SC9->(GetArea())
Local aAreaSC5 := SC5->(GetArea())

If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC5->C5_NUM))
	While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
		nQtdTotC6 += (SC6->C6_QTDVEN-SC6->C6_QTDENT)
		
		SC6->(dbSkip(1))
	Enddo
Endif

RestArea(aAreaSC6)

DBSELECTAREA("SC9")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SC9") + SC5->C5_NUM)  
	DO WHILE !EOF() .AND. ALLTRIM(SC9->C9_PEDIDO) == SC5->C5_NUM .And. SC9->C9_FILIAL == xFilial("SC9")
		If Empty(SC9->C9_NFISCAL)
			nQtdTotC9 += SC9->C9_QTDLIB
			RECLOCK("SC9",.F.)
			SC9->C9_BLEST := '' 
			SC9->C9_BLCRED:= '' 
			SC9->(MSUNLOCK()) 
		Endif
		
		DBSELECTAREA("SC9")
		DBSKIP()
	ENDDO
ENDIF
	
If Str(nQtdTotC6,10,3) <> Str(nQtdTotC9,10,3)
	MsgStop("Atenção Existe Divergência na Quantidade Total do Pedido de Vendas x a Quantidade Liberada em Itens Liberados, Favor Verificar !")
Endif
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
return .t.
