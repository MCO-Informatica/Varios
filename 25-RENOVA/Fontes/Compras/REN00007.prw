#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ REN00007 ºAutor  ³Danilo José Grodzickiº Data³  05/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho dos campos C7_PRODUTO, C7_QUANT, C7_PRECO e        º±±
±±º          ³ C7_TOTAL.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova Energia S.A.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function REN00007()

Local nI
Local cRet
Local nPosRegra
Local aRegra   := {}
Local nValor   := 0
Local cRegra   := GetMV("MV_XCOMCEN")
Local nPosPrd  := Ascan(aHeader,{|x| x[2] == "C7_PRODUTO"})
Local nPosQtd  := Ascan(aHeader,{|x| x[2] == "C7_QUANT  "})
Local nPosPrc  := Ascan(aHeader,{|x| x[2] == "C7_PRECO  "})
Local nPosTot  := Ascan(aHeader,{|x| x[2] == "C7_TOTAL  "})
Local nPosTip  := Ascan(aHeader,{|x| x[2] == "C7_XTPCOM "})
Local aAreaSB1 := SB1->(GetArea())

if nPosPrd <= 0 .or. nPosQtd <= 0 .or. nPosPrc <= 0 .or. nPosTot <= 0 .or. nPosTip <= 0 .or. Empty(AllTrim(aCols[n][nPosPrd]))
	Return Nil
endif

if !Empty(AllTrim(cRegra))
	aRegra := Separa(cRegra,";",.T.)
else
	Return Nil
endif

DbSelectArea("SB1")
SB1->(DbSetOrder(01))
if !SB1->(DbSeek(xFilial("SB1")+aCols[n][nPosPrd]))
	RestArea(aAreaSB1)
	Return Nil
endif

for nI = 1 to Len(aRegra)
	if Mod(nI,2) <> 0
		if AllTrim(aRegra[nI]) == AllTrim(SB1->B1_GRUPO)
			nValor := Val(aRegra[nI+1])
			exit
		endif
	endif
next

if nValor <= 0  // não achei nenhuma regra.
	nValor := 30000
endif

if aCols[n][nPosQtd]*aCols[n][nPosPrc] > nValor .or. aCols[n][nPosTot] >= nValor
	aCols[n][nPosTip] := "1"
	cRet              := "1"
else
	aCols[n][nPosTip] := "2"
	cRet              := "2"
endif

RestArea(aAreaSB1)

Return(cRet)