
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MTA455I   ?Autor  ?Microsiga           ? Data ?  03/02/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function MTA455P()
   Local cPedido
   Local cItem
   Local cProduto
   Local cLocal  
   Local nSaldo
   lOCAL lPode:=.T.
   Private cEmpAtual:= SM0->M0_CODIGO
   cPedido := SC9->C9_PEDIDO
   cItem   := SC9->C9_ITEM
   cLocal  := SC9->C9_LOCAL
   cProduto:= SC9->C9_PRODUTO 
   
   // ROTINA PARA VERIFICAR SE TEM TES BLOQUEADA
   dbSelectArea("SC6")
   dbSetOrder(1)
   msSeek(xFilial("SC6")+cPedido)
   While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cPedido) 				
			if Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_MSBLQL")="1"
              lPode:=.F.
            ENDIF
			SC6->(dbSkip())
   EndDo 
   IF lPode=.F.
     Aviso("Bloqueio de Opera??o","O pedido <<<NAO SERA LIBERADO>>>. Existe algum item com tes Bloqueada",{"Ok"},,"Bloqueio de operacao")
   ENDIF 		
   // Verifica??o do Estoque
   nSaldo:=U_SALRAPV(cProduto,cLocal,SC9->C9_PEDIDO,SC9->C9_ITEM,"LP") 	
   IF cEmpAtual="01"
   if nSaldo+SC9->C9_QTDLIB<SC9->C9_QTDLIB
     Aviso("Bloqueio de Opera??o","O item <<<NAO SERA LIBERADO>>>. Nao tem saldo disponivel no almoxarifado para atender a venda",{"Ok"},,"Bloqueio de operacao")
     lPode:=.F.
   endif
   endif  
   
Return(lPode)
	