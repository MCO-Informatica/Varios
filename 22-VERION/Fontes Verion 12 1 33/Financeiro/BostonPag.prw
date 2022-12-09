#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BostonPag ºAutor  ³Andreza Favero      º Data ³  05/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera as informacoes para cnab de contas a pagar do          º±±                                                         
±±º          ³Banco de Boston                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BostonPag(cOpcao)

Local cReturn   := ""
Local nReturn   := 0
Local cAgencia  := " "
Local cNumCC    := " " 
Local cDVAgencia:= " "
Local cDVNumCC  := " "
Local nVlTit	:= 0
Local nValor	:= 0
Local nAbat		:= 0  

If cOpcao == "1"  // Obtem o numero da agencia
	cAgencia :=  Alltrim(SA2->A2_AGENCIA)
	
	If AT("-",cAgencia) > 0
		cAgencia := Substr(cAgencia,1,AT("-",cAgencia)-1)
	Endif
	
	cAgencia := STRTRAN(cAgencia,".","")
	cReturn  := strzero(val(cAgencia),7)

ElseIf cOpcao =="2"  // Obtem o digito da agencia
	cDVAgencia :=  Alltrim(SA2->A2_AGENCIA)
	If AT("-",cDVAgencia) > 0
		cDVAgencia := Substr(cDVAgencia,AT("-",cDVAgencia)+1,1)
	Else
		cDVAgencia := Space(1)
	Endif
	
	cReturn:= cDVAgencia
	
ElseIf cOpcao == "3"    // Obtem o numero da conta corrente
	cNumCC :=  Alltrim(SA2->A2_NUMCON)
	
	If AT("-",cNumCC) > 0
		cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
	Endif
	
	cReturn  := StrZero(val(cNumCC),10)
		
ElseIf cOpcao =="4"         // EXECUTA ROTINA DV C/C
	cDVNumCC :=  Alltrim(SA2->A2_NUMCON)
	If AT("-",cDVNumCC) > 0
		cDVNumCC := Substr(cDVNumCC,AT("-",cDVNumCC)+1,2)
	Else
		cDVNumCC := Space(1)
	Endif
	
	cReturn := cDvNumCC
	
ElseIf cOpcao =="5"   // EXECUTA ROTINA DV AGENCIA ou C/C
	cDV :=  Alltrim(SA2->A2_AGENCIA)
	If AT("-",cDV) > 0
		cDV := Substr(cDV,AT("-",cDV)+2,1)
	Else
		cDV :=  Alltrim(SA2->A2_NUMCON)
		If AT("-",cDV) > 0
			cDV := Substr(cDV,AT("-",cDV)+2,1)
		Else
			cDV := Space(1)
		Endif
	Endif
	
	cReturn	:= cDv         
	
ElseIf cOpcao == "6"  // Valor Nominal

	If SEA->EA_MODELO $ "30/31" .and. Val(Substr(SE2->E2_CODBAR,10,10)) <> 0
		nVlTit	:= StrZero(Val(Substr(SE2->E2_CODBAR,10,10)),13)
	Else		
		nVlTit:= StrZero((SE2->E2_SALDO*100),13)	
	EndIf
		
	cReturn := nVlTit

ElseIf cOpcao == "7"  // Valor de desconto
	
	nAbat	:=	SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA)
	nDesconto	:= SE2->E2_DECRESC + nAbat
	cReturn := Strzero((nDesconto * 100),13)
	
ElseIf cOpcao == "8"  // valor a pagar

	nAbat	:=	SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA)	
	If SEA->EA_MODELO $ "30/31" .and. Val(Substr(SE2->E2_CODBAR,10,10)) <> 0
		nVlTit	:= Val(Substr(SE2->E2_CODBAR,10,10))/100 + SE2->E2_ACRESC-SE2->E2_DECRESC - nAbat	
	Else	
		nVlTit	:= SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC - nAbat
	EndIf
		
	cReturn := Strzero((nVlTit * 100),13)    	 
	
ElseIf cOpcao == "9"	// dados bancario do pagador - agencia

	cAgPag :=  Alltrim(SA6->A6_AGENCIA)
	
	If AT("-",cAgPag) > 0
		cAgPag := Substr(cAgPag,1,AT("-",cAgPag)-1)
	Endif
	
	cAgPag := STRTRAN(cAgPag,".","")
	cReturn  := strzero(val(cAgPag),7)
	
ElseIf cOpcao  == "A"	// dados bancario do pagador - conta corrente

	cNumCCPag :=  Alltrim(SA6->A6_NUMCON)
	
	If AT("-",cNumCCPag) > 0
		cNumCCPag := Substr(cNumCCPag,1,AT("-",cNumCCPag)-1)
	Else
		cNumCCPag := Substr(cNumCCPag,1,Len(cNumCCPag)-1)
	Endif
	
	cReturn  := StrZero(val(cNumCCPag),12)
	
ElseIf cOpcao == "B"	// dados bancarios do pagador - digito da conta corrente

	cDVNumCCPg :=  Alltrim(SA6->A6_NUMCON)
	If AT("-",cDVNumCCPg) > 0
		cDVNumCCPg := Substr(cDVNumCCPg,AT("-",cDVNumCCPg)+1,2)
	Else
		cDVNumCCPg := Substr(cDVNumCCPg,Len(cDVNumCCPg),1)
	Endif
	
	cReturn := cDvNumCCPg   

ElseIf cOpcao == "C"		// tipo de pagamento

	If SEA->EA_MODELO $ "03/41/43"
		cReturn := "DOC"
	ElseIf 	SEA->EA_MODELO $ "01/05"
		cReturn := "CC"
	Else
		cReturn	:= "COB"
	Endif	        
	
ElseIf cOpcao == "D"	// Agencia para pagto
	If SEA->EA_MODELO $ "01/03/05/41/43"
		cAgencia :=  Alltrim(SA2->A2_AGENCIA)
		
		If AT("-",cAgencia) > 0
			cAgencia := Substr(cAgencia,1,AT("-",cAgencia)-1)
		Endif
		
		cAgencia := STRTRAN(cAgencia,".","")
		cReturn  := strzero(val(cAgencia),7)
	Else	
		cReturn	:= "0000000"
	EndIf	
	
ElseIf cOpcao == "E"	// Conta para pagto
	If SEA->EA_MODELO $ "01/03/05/41/43"
		cNumCC :=  Alltrim(SA2->A2_NUMCON)
		
		If AT("-",cNumCC) > 0
			cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
		Endif
		
		cReturn  := StrZero(val(cNumCC),10)
	Else	
		cReturn	:= "0000000000"
	EndIf		
EndIf

Return(cReturn)     
