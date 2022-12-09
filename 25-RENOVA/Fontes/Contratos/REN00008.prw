#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ REN00008 ºAutor  ³Danilo José Grodzickiº Data³  05/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho dos campos CNB_PRODUT, CNB_QUANT, CNB_VLUNIT e     º±±
±±º          ³ CNB_VLTOT.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova Energia S.A.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function REN00008()

Local nI
Local cRet
Local nPosRegra
Local aRegra   := {}
Local nValor   := 0
Local cRegra   := GetMV("MV_XCOMCEN")
Local nPosPrd  := Ascan(aHeader,{|x| x[2] == "CNB_PRODUT"})
Local nPosQtd  := Ascan(aHeader,{|x| x[2] == "CNB_QUANT "})
Local nPosPrc  := Ascan(aHeader,{|x| x[2] == "CNB_VLUNIT"})
Local nPosTot  := Ascan(aHeader,{|x| x[2] == "CNB_VLTOT "})
Local aAreaSB1 := SB1->(GetArea())

if nPosPrd <= 0 .or. nPosQtd <= 0 .or. nPosPrc <= 0 .or. nPosTot <= 0 .or. Empty(AllTrim(aCols[n][nPosPrd]))
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
	M->CN9_TPCONT := "1"
	cRet          := "1"
else
	M->CN9_TPCONT := "2"
	cRet          := "2"
endif

RestArea(aAreaSB1)

Return(cRet)