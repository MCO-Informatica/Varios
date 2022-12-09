#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCRME013  ºAutor Derik Santos          º Data ³  19/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsavel por salvar o historio de revisões nas   º±±
±±º          ³ tabelas AD2 - Time de Vendas e ADC - Historio de Oport     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCRME013()

Local _nRevisa := M->AD1_REVISA
Local _cOport  := M->AD1_NROPOR
Local _cVend   := M->AD1_VEND
Local _cConcl1 := M->AD1_CONCL1
Local _cConcl2 := M->AD1_CONCL2
Local _cConcl3 := M->AD1_CONCL3

If _cConcl1 = "2" .OR. _cConcl2 == "2" .OR. _cConcl3 == "2"
	Dbselectarea("AD2")
	DbSetOrder(1)
	If dbSeek(xFilial("AD2") + _cOport + _nRevisa + _cVend) //OPORTUNIDADE + REVISÃO + VENDEDOR
		Reclock ("AD2",.F.)
		AD2->AD2_HISTOR := "1"
		AD2->(MsUnlock())
	EndIf
		_cRevi			:= SOMA1(M->AD1_REVISA)
		
		Dbselectarea("AD2")
		Reclock ("AD2",.T.)
		AD2->AD2_FILIAL := "01"
		AD2->AD2_NROPOR := M->AD1_NROPOR
		AD2->AD2_REVISA := _cRevi
		AD2->AD2_HISTOR := "2"
		AD2->AD2_VEND   := M->AD1_VEND
		AD2->AD2_PERC   := 100
		AD2->(MsUnlock())
		
		Dbselectarea("ADC")
		Reclock ("ADC",.T.)
		ADC->ADC_FILIAL := M->AD1_FILIAL
		ADC->ADC_NROPOR := M->AD1_NROPOR
		ADC->ADC_REVISA := M->AD1_REVISA
		ADC->ADC_DESCRI := M->AD1_DESCRI
		ADC->ADC_DATA   := Date()
		ADC->ADC_HORA   := SUBSTR(TIME(),1,5)
		ADC->ADC_USER   := __cUserID
		ADC->ADC_VEND   := M->AD1_VEND
		ADC->ADC_DTINI  := Date()
		ADC->ADC_PROSPE := M->AD1_PROSPE
		ADC->ADC_LOJPRO := M->AD1_LOJPRO
		ADC->ADC_PROVEN := M->AD1_PROVEN
		ADC->ADC_STAGE  := M->AD1_STAGE
		ADC->ADC_VERBA  := 0
		ADC->ADC_MOEDA  := 2
		ADC->ADC_CODPRO := M->AD1_CODPRO
		ADC->ADC_PRIOR  := "1"
		ADC->ADC_STATUS := "1"
		ADC->ADC_MODO   := "1"
		ADC->(MsUnlock())
		
		Return(_cRevi)
EndIf 