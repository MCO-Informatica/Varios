#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ITAUCP    ºAutor  ³Cezar Bellini       º Data ³  10/01/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera as informacoes para o cnab de contas a pagar para o    º±±
±±º          ³Banco Itau.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico HCI                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ItauCP(cOpcao)

Local cReturn   := " "
Local cAgencia  := " "
Local cNumCC    := " "
Local cDVAgencia:= " "
Local cDVNumCC  := " "            
Local cAgcli	:= " "
Local nVlTit	:= 0
Local nAbat		:= 0

If cOpcao == "1"  // Obtem o numero da agencia do cliente

	cAgCli :=  Alltrim(SEE->EE_XAGCNAB)
	
	If AT("-",cAgCli) > 0
		cAgCli := Substr(cAgCli,1,AT("-",cAgCli)-1)
	Endif
	
	cAgCli := STRTRAN(cAgCli,".","")
	
	cReturn  := strzero(val(cAgCli),7)

ElseIf cOpcao == "2"	// Zera o numero sequencial de envio a cada dia, pois conforme o manual, a sequencial de remessa
						// e por dia.

	If dDataBase <> SEE->EE_XULTDIA
		RecLock("SEE",.F.)
			SEE->EE_ULTDSK	:= "000000"
			SEE->EE_XULTDIA	:= DDATABASE
		MsUnlock()
	EndIf		
		  
	cReturn	:= StrZero(VAL(SEE->EE_ULTDSK)+1,6)
								                              
ElseIf cOpcao =="3"  						// identifica o tipo de pagamento no Cnab que e o Modelo no Bordero do Sistema

If SEA->EA_MODELO $ "03/41/43"  			// Doc e TED
	cReturn	:= "DOC"
ElseIf SEA->EA_MODELO $ "02"				// Cheque
	cReturn	:= "CHQ"
Elseif SEA->EA_MODELO $ "30/31/13/16"		// Boleto do banco e outros bancos  // 16 - Darf Normal
	cReturn	:= "COB"
ElseIf SEA->EA_MODELO $ "01/05"				// Credito em conta corrente
	cReturn := "CC"
Else
	cReturn := " "
EndIf		
    
ElseIf cOpcao == "4"		// identifica o banco para pagamento

	If SEA->EA_MODELO $ "03/41/43/01"  // Doc e TED	e C/C
		cReturn := StrZero(Val(SA2->A2_BANCO),3)
    Else
    	cReturn	:= "000"
//    	cReturn	:= space(3)
    EndIf
    
Elseif cOpcao == "5"

	If SEA->EA_MODELO $ "41/43"
		cReturn	:= "018"
	Elseif SEA->EA_MODELO $ "03"
		cReturn := "700"
	Else
		cReturn := "000"	
	EndIf	

ElseIf cOpcao == "6"  			// ITAU - Agencia s/ Digito

	cAgencia :=  Alltrim(SA2->A2_AGENCIA)
		
	If AT("-",cAgencia) > 0
		cAgencia := Substr(cAgencia,1,AT("-",cAgencia)-1)
	Endif
		
	cAgencia := STRTRAN(cAgencia,".","")
		
	cDVAg :=  Alltrim(SA2->A2_AGENCIA)
	If AT("-",cDVAg) > 0
		cDVAg := Substr(cDVAg,AT("-",cDVAg)+1,2)
	Else
		cDVAg := Space(1)
	Endif

	cReturn := StrZero(Val(cAgencia),5)
	//cReturn := StrZero(Val(cAgencia + cDvAg),7)
				    		
ElseIf cOpcao == "7"    		// ITAU - Obtem o numero da conta corrente s/ DV
	
	cNumCC :=  Alltrim(SA2->A2_NUMCON)
	
	If AT("-",cNumCC) > 0
		cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
	Endif
	
	cReturn := StrZero(Val(cNumCC),12)

ElseIf cOpcao == "8"    		// ITAU - Obtem o DV Conta corrente
	
	cDVNumCC :=  Alltrim(SA2->A2_NUMCON)
	If AT("-",cDVNumCC) > 0
		cDVNumCC := Substr(cDVNumCC,AT("-",cDVNumCC)+1,2)
	Else
		cDVNumCC := Space(1)
	Endif
	
	cReturn := StrZero(Val(cNumCC),1)

ElseIf cOpcao == "9"  //Valor do Pagamento
	
	// nVlTit	:= Replicate("0",15)
	nAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,1,"S",dDataBase,SE2->E2_LOJA)
	
	nVlTit:= SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-nAbat
	nVltit := Strzero((nVlTit*100),15)
	
	cReturn := nVltit

EndIf

Return(cReturn)