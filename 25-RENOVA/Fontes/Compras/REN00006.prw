#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � REN00006 �Autor  �Danilo Jos� Grodzicki� Data�  05/11/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho dos campos C1_PRODUTO, C1_QUANT e C1_VLESTIM.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Renova Energia S.A.                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function REN00006()

Local nI
Local cRet
Local nPosRegra
Local aRegra   := {}
Local nValor   := 0
Local cRegra   := GetMV("MV_XCOMCEN")
Local nPosPrd  := Ascan(aHeader,{|x| x[2] == "C1_PRODUTO"})
Local nPosQtd  := Ascan(aHeader,{|x| x[2] == "C1_QUANT  "})
Local nPosVlr  := Ascan(aHeader,{|x| x[2] == "C1_VLESTIM"})
Local nPosTip  := Ascan(aHeader,{|x| x[2] == "C1_XTIPO  "})
Local aAreaSB1 := SB1->(GetArea())

if nPosPrd <= 0 .or. nPosQtd <= 0 .or. nPosVlr <= 0 .or. nPosTip <= 0 .or. Empty(AllTrim(aCols[n][nPosPrd]))
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

if nValor <= 0  // n�o achei nenhuma regra.
	nValor := 30000
endif

if aCols[n][nPosQtd]*aCols[n][nPosVlr] >= nValor
	aCols[n][nPosTip] := "1"
	cRet              := "1"
else
	aCols[n][nPosTip] := "2"
	cRet              := "2"
endif

RestArea(aAreaSB1)

Return(cRet)