#Include 'Protheus.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ�
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±�
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±�
±±ºPrograma  ³ PCO355 ºAutor  ³Wellington Mendes� 
Data� 17/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fun��o utilizada no ponto de lan�amento 000355 do pco - medi��o
de contrato.
º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova Energia S.A.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±�
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PCO355(_Contrat,_Revisa)

Local _cTipCont   := ""
Local _cTipPed    := ""
Local aAreaCN9    := CN9->(GetArea())
Local aAreaCN1    := CN1->(GetArea())


	DbSelectArea("CN9")
	DbSetOrder(1)
	If(dbSeek(xFilial()+_Contrat+_Revisa))
		_cTipCont := CN9->CN9_TPCTO
	Endif
	
	
	DbSelectArea("CN1")
	DbSetOrder(1)
	If(dbSeek(xFilial()+_cTipCont))
		_cTipPed := CN1->CN1_XPED
	Endif

RestArea(aAreaCN9)  
RestArea(aAreaCN1)


Return(_cTipPed)
                                                       	