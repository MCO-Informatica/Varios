#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2520   ºAutor  ³Luiz Alberto       º Data ³  28/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na exclusao apos nota fiscal              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MS520VLD

Local _aArea := GetArea()
Local cPrf	:= ""
If xFilial("SD2") == "0101"
	cPrf := "AT "
Elseif xFilial("SD2") == "0102"
	cPrf := "MA "
Elseif xFilial("SD2") == "0103"
	cPrf := "DR "
Endif

_aArea := GetArea()
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+ SD2->D2_PEDIDO)

If SC5->C5_XPRIORI <> "A"

	_aArea := GetArea()
	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+cPrf+SD2->D2_DOC)
		While !Eof() .and. E1_PREFIXO == cPrf .And. E1_NUM == SD2->D2_DOC .And. E1_CLIENTE == SD2->D2_CLIENTE .And. E1_LOJA == SD2->D2_LOJA

			RecLock("SE1",.f.)
			dbDelete()
			MsUnlock()

			dbSelectArea("SE1")
			dbSkip()
		End

	Endif
	RestArea(_aArea)
EndIf

return(.T.)
