#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Itau   ºAutor  ³					     º Data ³  27/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera as informacoes para o cnab a receber  banco Itau	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 						                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Itau(cOpcao)


If cOpcao  == "1"	// dados bancario da empresa - conta corrente

	cNumCC :=  Alltrim(SEE->EE_CONTA)
	
	If AT("-",cNumCC) > 0
		cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
	Else
		cNumCC := Substr(cNumCC,1,Len(cNumCC)-1)
	Endif
	
	cReturn  := StrZero(val(cNumCC),5)
	
ElseIf cOpcao == "2"	// dados bancarios da empresa - digito da conta corrente

	cDVNumCC :=  Alltrim(SEE->EE_CONTA)
	If AT("-",cDVNumCC) <> 0
		cDVNumCC := Substr(cDVNumCC,AT("-",cDVNumCC)+1,1)
	Else
		cDVNumCC := Substr(cDVNumCC,Len(cDVNumCC),1)
	Endif
	
	cReturn := cDvNumCC

ElseIf cOpcao == "3"	// Calculo do nosso numero

    DO CASE
		CASE SE1->E1_PARCELA == "A"
			cParcela := "1"
		CASE SE1->E1_PARCELA == "B"
			cParcela := "2"
		CASE SE1->E1_PARCELA == "C"
			cParcela := "3"
		CASE SE1->E1_PARCELA == "D"
			cParcela := "4"
		CASE SE1->E1_PARCELA == "E"
			cParcela := "5"
		CASE SE1->E1_PARCELA == "F"
			cParcela := "6"
		CASE SE1->E1_PARCELA == "G"
			cParcela := "7"
		CASE SE1->E1_PARCELA == "H"
			cParcela := "8"
		CASE SE1->E1_PARCELA == "I"
			cParcela := "9"
		OTHERWISE
			cParcela := "0"
	ENDCASE
	//
	cReturn := cFilant + substr((strzero(Val(Alltrim(SE1->E1_NUM)),6)),2,5) + cParcela //Composicao Filial + Titulo + Parcela


EndIf

Return(cReturn)     

