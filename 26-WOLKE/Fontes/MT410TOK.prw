#Include 'Protheus.ch'
/*
Programa: MT410TOK
Autor: André Lanzieri
Data:06/09/2013
Descrição: Função para calculo comissão.
*/

User Function MT410TOK()
/*
Parametro MV_PORCVE = 25
Parametro MV_PORCSW = 75
Campo C5_INCEN = Valor incentivo(usuario irá preencher)
Campo C6_VLRBRT = Gatilho(C6_PRODUTO) pega valor da tabela e campo B2_VATU1
Campo E4_VLRBOL VALOR DO BOLETO A DESCONTAR DO VALOR TOTAL DO PEDIDO
*/  

Local lRet := .T.
Local nPorc :=GetMv("MV_PORCVE") //Valor procentagem para calculo vendedor
Local nTotal := 0
Local nBruto := 0
Local nCalc := 0
Local nTotalm := 0
Local nVlrBol := 0

IF M->C5_COMIS1 == 0
	//Calcula valor total pedido de venda e valor bruto produtos
	For nCont := 1 to Len(aCols)
		IF !(GDDeleted(nCont))
			nTotal += GDFIELDGET("C6_VALOR",nCont) //Calculo valor total PV
			nBruto += (GDFIELDGET("C6_VLRBRT",nCont)*GDFIELDGET("C6_QTDVEN",nCont)) //Calcula valor bruto
		EndIF
	next
	
	//nVlrBol := Posicione("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_VLRBOL")
	//nTotal := nTotal-M->C5_FRETE-M->C5_INCEN-nVlrBol //Calcula valor total do pedido sem frete, incentivo e boleto
	nTotal := nTotal-M->C5_FRETE-(M->C5_RET1+M->C5_RET2+M->C5_RET3)-nVlrBol //Calcula valor total do pedido sem frete, retorno e boleto
	nCalc := (nTotal-nBruto)// Calcula valor total pedido - valor bruto(LUCRO)
	nCalc := nCalc*(nPorc/100) // Calcula valor 25%(MV_PORCVE)
	nCalc := (nCalc/nTotal)*100 //Calcula valor total pedido / valor 25% do lucro
	
	M->C5_COMIS1 := Round(nCalc,2) //Coloca valor porcentagem no campo
ENDIF

Return(lRet)       
