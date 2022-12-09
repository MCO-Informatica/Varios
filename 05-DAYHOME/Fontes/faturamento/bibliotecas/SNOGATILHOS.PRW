#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SNOGATILHOS ºAutor  ³Sergio Lacerda - SNL SISTEMAS º Data ³  24/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao Biblioteca de Gatilhos                                          º±±
±±º          ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SNOGATILHOS(nOpcao,cProduto,cCodVend,cTabela,nComiss1)

Local xRetorno
Local aArea			:= GetArea()
Local cVendedores   := SuperGetMv("ES_CODVND",.F.,"106")

If nOpcao == 1 // Retorno do Percentual de Comissao cadastrado na tabela de Preco
	If !Alltrim(M->CJ_VEND1) $ cVendedores
		cProduto	:= TMP1->CK_PRODUTO
		cTabela		:= M->CJ_TABELA
	
		dbSelectArea("DA1")
		DbSetOrder(1)
		If DbSeek(xFilial("DA1") + cTabela + cProduto)	
			xRetorno 	:= DA1->DA1_XCOMIS
		Else
			xRetorno	:= M->CJ_COMIS1                                                                                        	
		Endif
		
		If xRetorno == 0
			xRetorno := M->CJ_COMIS1		
		Endif
	Else
		xRetorno := 0
	Endif	
Elseif nOpcao == 2 // Retorno do tipo de preco cadastrado na tabela de Preco
	cProduto	:= TMP1->CK_PRODUTO
	cTabela		:= M->CJ_TABELA

	dbSelectArea("DA1")
	DbSetOrder(1)
	If DbSeek(xFilial("DA1") + cTabela + cProduto)
		xRetorno 	:= DA1->DA1_XPROMO
	Else
		xRetorno	:= "N"
	Endif
Elseif nOpcao == 3 // Retorno do Percentual de Comissao Cadastrado na Tabela de Preco, chamado atraves da integracao Fenix
	If !Alltrim(cCodVend) $ cVendedores
		dbSelectArea("DA1")
		DbSetOrder(1)
		If DbSeek(xFilial("DA1") + cTabela + cProduto)	
			xRetorno 	:= DA1->DA1_XCOMIS
		Else
			xRetorno	:= nComiss1                                                                                       	
		Endif
	Else
		xRetorno := 0
	Endif
Elseif nOpcao == 4 // Retorno do tipo de preco cadastrado na tabela de Preco, chamado atraves da integracao Fenix
	dbSelectArea("DA1")
	DbSetOrder(1)
	If DbSeek(xFilial("DA1") + cTabela + cProduto)	
		xRetorno 	:= DA1->DA1_XPROMO
	Else
		xRetorno	:= "N"
	Endif
Endif

RestArea(aArea)

Return(xRetorno)           