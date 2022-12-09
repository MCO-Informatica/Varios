STATIC aItenSC9:={}
STATIC aItenSC6:={}
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ACDHCI06 ³ Autor ³ Luiz Enrique          ³ Data ³ 12/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ GuardaIten():											  ³±±
±±³          ³ Guarda itens do SC9 e do SC6 antes da Alteracao no Pedido  ³±± 
±±³          ³ para posterior geração das liberacoes que ja existiam.	  ³±±  
±±³Chamada   ³ Chamado pelo Ponto de Entrada : MTA410 (MATA410) 	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI	                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GuardaItem() 

Local aSC9		:= SC9->(GetArea('SC9'))
Local aSC6		:= SC6->(GetArea('SC6'))

//Guarda SC6
SC6->(DBSetOrder(1)) //FILIAL+PEDIDO
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
While SC6->(! Eof() .And. C6_FILIAL+C6_NUM ==xFilial("SC6")+SC5->C5_NUM)	
	aadd(aItenSC6,{	SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_QTDVEN})					  		
	SC6->(DbSkip())	
EndDo 

//Guarda SC9
SC9->(DBSetOrder(1)) //FILIAL+PEDIDO
SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))
While SC9->(! Eof() .And. C9_FILIAL+C9_PEDIDO ==xFilial("SC9")+SC5->C5_NUM)	
	aadd(aItensC9,{SC9->C9_PRODUTO,SC9->C9_ITEM,SC9->C9_LOCAL,SC9->C9_LOTECTL,SC9->C9_QTDLIB})				  		
	SC9->(DbSkip())	
EndDo

SC6->(RestArea(aSC6))
SC9->(RestArea(aSC9))

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ LiberaC9 ³ Autor ³ Luiz Enrique          ³ Data ³ 12/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Relibera os Itens do SC9 referente ao Pedido ALterado.      ³±± 
±±³		     ³Chamado Pelo Ponto de Entrada MTA410T.					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HCI	                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function LiberaC9()

Local aSaldos 	:= {}
Local aSC6		:= SC6->(GetArea('SC6')) 
Local nPos		:= 0
Local nVez, nI
Local nQtdLib	:= 0 
Local cSta		:= ""
Local nQtdLc9	:=0


If Len(aItenSC9) == 0
	Return
Endif

SC6->(DBSetOrder(1)) //FILIAL+PEDIDO
aSort(aItenSC9,,,{ |x, y| x[1]+x[2] < y[1]+y[2]} ) 

For nVez:=1 to Len (aItenSC6)     //Pedido      +Item            +Produto
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM+aItenSC6[nVez,2]+aItenSC6[nVez,1])) 	  
		If SC6->C6_QTDVEN == aItenSC6[nVez,3] 
			If (nPos :=AScan(aItenSC9,{|x| x[1]+x[2]==aItenSC6[nVez,1]+aItenSC6[nVez,2] })) >0
				For nI:=nPos to len(aItenSC9)
			   		If (aItenSC9[nI,1]+aItenSC9[nI,2]) <> SC6->(C6_PRODUTO+C6_ITEM)
			   			Exit
			   		Endif 
			   		//Executa Liberação dos respectivos Itens guardados.
			   		nQtdLc9	:= aItenSC9[nI,5]		   		
			   		aSaldos := {}
					aSaldos := {{ Alltrim(aItenSC9[nI,4]),"","","",nQtdLc9,ConvUm(Alltrim(aItenSC9[nI,1]),0,2,nQtdLc9),Ctod(""),"","","",SC6->C6_LOCAL,0}}
					MaLibDoFat	(SC6->(Recno()),nQtdLc9,.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,aSaldos,NIL,NIL,NIL)
			   		MaLiberOk	({SC6->C6_NUM},.F.)
			   		nQtdLib++
			  	Next
			Endif
		Endif 		
	Endif	
Next

If nQtdLib == Len (aItenSC6) 
	cSta:="2"	//Separacao Contiuna Concluida 
Elseif nQtdLib == 0 .And. Len (aItenSC6) > 0 
	cSta:=""	//Separacao se torna "nao Iniciada"
Else
	cSta:="1"	//Separacao se torna "em Andamento"
Endif

SC5->(Reclock('SC5',.F.))
SC5->C5_STASEP:= cSta 
SC5->(MsUnlock())


SC6->(RestArea(aSC6))

Return