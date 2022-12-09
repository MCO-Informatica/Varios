#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MT120OK  ³ Totvs                         ³ Data ³ 09/11    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada para validacao do PC.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT120OK()

Local _lRet    := .T.
Local _nPosCt  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XCONTRA'})
Local _nPosProd:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local _nPosItm := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'   })
Local _nPosSC  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_NUMSC'  })
Local _nPosISC := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEMSC' })
Local _nPosBicm:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_BASEICM' })
Local _nPosTPCom:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XTPCOM' })

Local nValLimC := GetMv("MV_XVLCDEC")  // Valor limite para compras decentralizadas
Local lPms     := .F.
Local nSavN    := n
Local _nTotPed := 0
Local lRegraGrExc := .F.
Local _cOrigem := ''
Local _cCompCen := ''

//Acrescido validação do tipo de compras   - 30/03/2016
Local nCont    := 1
Local nCont2   := 1

// Roberto - 18/08 - Ajustes das regras de centralização
// Apura total do pedido
_nPed := 0

For _nPed := 1 to len(aCols)
	// Verifica apenas linhas que não estejam deletadas
	if aCols[_nPed] [(len(aCols[_nPed]))] = .F.
		_nTotPed += aCols[_nPed,_nPosBicm]
	Endif
	
	// Aplica a regra apenas para o primeiro item
	
	// Compara a origem, regras para produto importado
	_cOrigem := Posicione("SB1",1,xFilial("SB1")+aCols[_nPed,_nPosProd],"B1_ORIGEM")
	If _cOrigem $ "1/6"
		lRegraGrExc := .T.
	Endif
	
	// Compara se o item deve ser centralizado independente do valor
	_cCompCen := Posicione("SB1",1,xFilial("SB1")+aCols[_nPed,_nPosProd],"B1_XITEMC")// ITEM CENTRALIZADO
	If _cCompCen = '1'
		lRegraGrExc := .T.
	Endif
	
Next

_CTipoCen := iif(_nTotPed >= nValLimC .or. lRegraGrExc ,'1','2') // 1-Centralizada - 2 - Descentralizada

// Atualiza conteudo do campo de acordo com resultado da regra
_nPed := 0
For _nPed := 1 to len(aCols)
	// Verifica apenas linhas que não estejam deletadas
	if aCols[_nPed] [(len(aCols[_nPed]))] = .F.
		aCols[_nPed,_nPosTPCom] :=  _CTipoCen
	Endif
Next

//Fim da modificação   - 18/08

If AllTrim(Upper(FunName())) == "CNTA120"
	If CND->CND_XPMS == "1"
		lPms := .T.
	EndIf
EndIf

For nX := 1 to Len(aCols)
	n := nX
	If !Empty(aCols[nx,_nPosCt])
		dbSelectArea("PA2")
		dbSetOrder(3)
		
		If !Empty(aCols[nX,_nPosSC]) .And. dbSeek(xFilial("PA2") + cA120Num + aCols[nX, _nPosItm])
			Reclock("PA2", .F.)
			PA2->PA2_NUMPC := cA120Num
			PA2->PA2_ITPC  := aCols[nX, _nPosItm]
			MsUnlock()
		Else
			Reclock("PA2", .T.)
			PA2->PA2_FILIAL := xFilial("PA2")
			PA2->PA2_CONTRA := aCols[nX,_nPosCt]
			PA2->PA2_NUMPC  := cA120Num
			PA2->PA2_ITPC   := aCols[nX, _nPosItm]
			PA2->PA2_USADO  := "2"
			MsUnlock()
		EndIf
	EndIf
	
	If lPms
		PmsDlgPC(3,cA120Num)
	EndIf
Next nX
n := nSavN

If lPms
	PmsWritePC(1,"SC7")
EndIf

Return(_lRet)
