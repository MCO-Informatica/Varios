
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA455I   ºAutor  ³Microsiga           º Data ³  03/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA455I()
   Local cPedido
   Local cItem
   Local cProduto
   Local cLocal  
   Local nSaldo
   lOCAL lPode:=.T.
   Private cEmpAtual:= SM0->M0_CODIGO
   if MsgYesNo("Libera Todos os itens do Pedido?","Automacao de Processo")
       	cPedido := SC9->C9_PEDIDO
		dbSelectArea("SC9")
		dbSetOrder(1)
		MsSeek(xFilial("SC9")+cPedido)
		nTotRec := SC9->(LastRec())
		While ( !Eof() .And. SC9->C9_FILIAL == xFilial("SC9") .And.;
				SC9->C9_PEDIDO == cPedido) 				
			SC9->(dbSkip())
			nRecSc9 := SC9->(Recno())
			SC9->(dbSkip(-1))
			cPedido := SC9->C9_PEDIDO
            cItem   := SC9->C9_ITEM
            cLocal  := SC9->C9_LOCAL
            cProduto:= SC9->C9_PRODUTO
            nSaldo:=U_SALRAPV(cProduto,cLocal,SC9->C9_PEDIDO,SC9->C9_ITEM,"LP") 	
            IF cEmpAtual="01"
              if nSaldo+SC9->C9_QTDLIB<SC9->C9_QTDLIB
                Aviso("Bloqueio de Operação","O pedido <<<NAO SERA LIBERADO>>>. Nao tem saldo disponivel no almoxarifado para atender a venda",{"Ok"},,"Bloqueio de operacao")
                lPode:=.F.
              endif    	
			ENDIF
			If lPode=.t.
		     	If !( Empty(SC9->C9_BLEST) .Or. SC9->C9_BLEST=="10")
			    	a450Grava(1,.F.,.T.)
			    EndIf
			endif
			lPode:=.T.
			SC9->(MsGoto(nRecSc9))
		EndDo 
	ENDIF	
	
Return()
	