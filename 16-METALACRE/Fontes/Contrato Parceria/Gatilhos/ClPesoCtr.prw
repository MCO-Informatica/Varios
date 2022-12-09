#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CLPESOCTR Autor ³ Luiz Alberto        ³ Data ³ 28/04/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos         ±±
				   de Peso Bruto e Peso Liquido do Contrato Parceria
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±± U_ClPesoCtr(M->ADB_XEMBAL)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function ClPesoCtr(cValor)
Local nVolume := 0
Local nPesoBruto := 0                  
Local nPesoLiqui := 0

nPosItem := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_ITEM"})
nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_CODPRO"})
nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_QUANT"})
nPosQtdL := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_QUANT"})
nPosEmba := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_XEMBAL"})
nPosVolm := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_XVOLIT"})
nPosPesB := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_XPBITE"})
nPosPesL := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "ADB_XPLITE"})

If ! aCols[n,Len(aHeader)+1]
	Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosProd],"")
		 
    // Posiciona-se no item do pedido atual gravado e efetua o abatimento caso o mesmo já tenha sido atendido parcialmente
       
    lOk := .f.
    lAc := .t.

	// Posiciona Registro do Conteudo da Embalagem
	If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+aCols[n,nPosEmba]))
		lAc := .f.
	Endif
	// Posiciona Registro do Tipo da Embalagem
	If !Z05->(dbSetOrder(1), dbSeek(xFilial("Z05")+Z06->Z06_EMBALA))
		lAc := .f.
	Endif                                     

                  
	If lAc	// Se Encontrou os Registros de Embalagem então Calculo, senão, irá abrir tela para digitação
	
		&&Quantidade de Caixas/Item    &&Oscar
		nxCaixa	:= aCols[n,nPosQtde]/Z06->Z06_QTDMAX
		nInt  := Int(nxCaixa)
		nFrac := (nxCaixa - nInt)
		If !Empty(nFrac)
		    nInt++
		Endif
		nxCaixa := nInt
		nxCaixa := Iif(Empty(nxCaixa),1,nxCaixa)

		// Efetua a Soma de Mais uma caixa
		// apenas se a quantidade faturada for superior
		// a quantidade maxima da embalagem

//		If aCols[n,nPosQtde] > Z06->Z06_QTDMAX
//			IIf(Mod(aCols[n,nPosQtde],Z06->Z06_QTDMAX)<>0,nxCaixa+=1,0)
//		Endif
				
		&&Peso Liquido/Item
		nxPliqu:=Z06->Z06_PESOUN*aCols[n,nPosQtde]
		&&Peso Bruto/Item
		nxPbrut:=Z06->Z06_PESOUN*aCols[n,nPosQtde]+(Z05->Z05_PESOEM*nxCaixa)
	
		// Preenche Vetores aCols Posicionado
	            

		aCols[n,nPosVolm] := nxCaixa
		aCols[n,nPosPesB] := nxPbrut
		aCols[n,nPosPesL] := nxPliqu
	Endif
Endif

For _nItem := 1 to Len(aCols)                    
    If ! aCols[_nItem,Len(aHeader)+1]
		 Posicione("SB1",1,xFilial("SB1")+aCols[_nItem,nPosProd],"")
		 
		 If Type("aCols[_nItem,nPosVolm]") <> "U"
			 nVolume += aCols[_nItem,nPosVolm]
			 nPesoBruto += aCols[_nItem,nPosPesB]
			 nPesoLiqui += aCols[_nItem,nPosPesL]
         Endif
    EndIf
Next

GetDRefresh() 
Return cValor
