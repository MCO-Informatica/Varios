#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR    ºAutor  ³Osmil Squarcine     º Data ³  22/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera informações para o PagFor                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico HCI          	                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PAGFOR(cOp)

Local cReturn  		:= ""
Local nReturn  		:= 0
Local cAgencia		:= " "
Local cDvAgencia	:= " "
Local cRETDIG 		:= " "
Local cDIG1   		:= " "
Local cDIG2   		:= " "
Local cDIG3   		:= " "
Local cDIG4   		:= " "
Local cMULT   		:= 0
Local cRESUL 		:= 0
Local cRESTO  		:= 0
Local cDIGITO 		:= 0
Local cRetCar		:= " "
Local cRetNos		:= " "
Local nTamCpf		:= " "
Local cCPF   		:= " "
Local cCtlCpf		:= " "
Local cNum			:= " "
Local nVltit		:= 0
Local nAbat			:= 0
Local cConta		:= " "
Local cDigCta		:= " "

If cOp == "1"    // obter código do banco
	
	if Alltrim(SEA->EA_MODELO) $ "30/31"
		cReturn:= SubStr(SE2->E2_CODBAR,1,3)
	ElseIf Alltrim(SEA->EA_MODELO) $ "01/03/05/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		cReturn:= SA2->A2_BANCO
	Else
		cReturn:= " "
	EndIf
	
ElseIf cOp == "2"
	
	If 	Alltrim(SEA->EA_MODELO) $ "01/03/05/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		cAgencia :=  Alltrim(SA2->A2_AGENCIA)
		If AT("-",cAgencia) > 0
			cAgencia := Substr(cAgencia,1,AT("-",cAgencia)-1)
		Endif
		
		cAgencia := STRTRAN(cAgencia,".","")
		
		// Obtem o digito da agencia
		
		cDVAgencia :=  Alltrim(SA2->A2_AGENCIA)
		If AT("-",cDVAgencia) > 0
			cDVAgencia := Substr(cDVAgencia,AT("-",cDVAgencia)+1,1)
		Else
			cDVAgencia := Space(1)
		Endif
		
		cReturn:= StrZero(val(cAgencia),5) + cDVAgencia
				
	ElseIf SEA->EA_MODELO =="30" .or. Substr(SE2->E2_CODBAR,1,3) == "237"
		If !EMPTY(ALLTRIM(SE2->E2_CODBAR))
			cAgencia  :=  "0" + SUBSTR(SE2->E2_CODBAR,20,4)
			cRETDIG := " "
			cDIG1   := SUBSTR(SE2->E2_CODBAR,20,1)
			cDIG2   := SUBSTR(SE2->E2_CODBAR,21,1)
			cDIG3   := SUBSTR(SE2->E2_CODBAR,22,1)
			cDIG4   := SUBSTR(SE2->E2_CODBAR,23,1)
			
			cMULT   := (VAL(cDIG1)*5) +  (VAL(cDIG2)*4) +  (VAL(cDIG3)*3) +   (VAL(cDIG4)*2)
			cRESUL  := INT(cMULT /11 )
			cRESTO  := INT(cMULT % 11)
			cDIGITO := 11 - cRESTO
			
			cRETDIG := IF( cRESTO == 0,"0",IF(cRESTO == 1,"0",ALLTRIM(STR(cDIGITO))))
			
			cAgencia:= cAgencia + cRETDIG
			cReturn:= cAgencia
		EndIf
	Else
		cAgencia:= replicate("0",5)
		cReturn:= cAgencia
	EndIf
	
ElseIf cOp == "3"  // CONTA CORRENTE DO FORNECEDOR
	
	If Alltrim(SEA->EA_MODELO) $ "01/03/05/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		
		cNumCC :=  Alltrim(SA2->A2_NUMCON)
		
		If AT("-",cNumCC) > 0
			cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
		Endif
		
		// obtem o digito da conta corrente
		cDVNumCC :=  Alltrim(SA2->A2_NUMCON)
		If AT("-",cDVNumCC) > 0
			cDVNumCC := Substr(cDVNumCC,AT("-",cDVNumCC)+1,2)
		Else
			cDVNumCC := Space(1)
		Endif
		
		cReturn:= Strzero(Val(cNumCC),13) + cDVNumCC
		
		
	ElseIf Alltrim(SEA->EA_MODELO) == "30" .or. Substr(SE2->E2_CODBAR,1,3) == "237"
		
		cCtaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
		
		cRETDIG := " "
		cDIG1   := SUBSTR(SE2->E2_CODBAR,37,1)
		cDIG2   := SUBSTR(SE2->E2_CODBAR,38,1)
		cDIG3   := SUBSTR(SE2->E2_CODBAR,39,1)
		cDIG4   := SUBSTR(SE2->E2_CODBAR,40,1)
		cDIG5   := SUBSTR(SE2->E2_CODBAR,41,1)
		cDIG6   := SUBSTR(SE2->E2_CODBAR,42,1)
		cDIG7   := SUBSTR(SE2->E2_CODBAR,43,1)
		
		cMULT   := (VAL(cDIG1)*2) +  (VAL(cDIG2)*7) +  (VAL(cDIG3)*6) +   (VAL(cDIG4)*5) +  (VAL(cDIG5)*4) +  (VAL(cDIG6)*3)  + (VAL(cDIG7)*2)
		cRESUL  := INT(cMULT /11 )
		cRESTO  := INT(cMULT % 11)
		cDIGITO := STRZERO((11 - cRESTO),1,0)
		
		cRETDIG := IF( cresto == 0,"0",IF(cresto == 1,"P",cDIGITO))
		cCtaced:= cCtaced + cRETDIG
		cReturn:= cCtaCed
	Else
		cCtaced:= replicate("0",15)
		cReturn:= cCtaCed
	EndIf
	
	
ElseIf cOP == "4"   // carteira
	
	cRetCar:= "000"
	
	If SubStr(SE2->E2_CODBAR,01,3) == "237"
		
		cRetCar := StrZero(Val(SubStr(SE2->E2_CODBAR,24,2)),3)
		
	EndIf
	
	cReturn := StrZero(Val(cRetCar),3)
	
ElseIf cOP ==  "5"  // nosso numero
	
	cRetNos:= REPLICATE("0",12)
	
	If Alltrim(SEA->EA_MODELO) =="30" .or. Substr(SE2->E2_CODBAR,1,3) == "237"
		cRetNos := StrZero(Val(SubStr(SE2->E2_CODBAR,26,11)),12)
	Else
		cRetNos:= REPLICATE("0",12)
	EndIf
	
	cReturn:= cRetNos
	
ElseIf cOP == "6"  // fator de vencimento
	
	cFtVen:= "0000"
	
	If Alltrim(SEA->EA_MODELO) $ "30/31"
		cFtVen:= SubStr(SE2->E2_CODBAR,6,4)
	Else
		cFtVen:= "0000"
	EndIf
	
	cReturn:= cFtVen
	
ElseIf cOP == "7"  // Valor do Documento
	
	nValor:= Replicate("0",10)
	
	If Alltrim(SEA->EA_MODELO) $ "30/31"
		nVltit := SubStr(SE2->E2_CODBAR,10,10)
	ElseIf Alltrim(SEA->EA_MODELO) $ "01/03/05/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		nAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,1,"S",dDataBase,SE2->E2_LOJA)
		nVlTit:= SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE-nAbat
		nVltit := Strzero((nVlTit*100),10)
	Endif
	
	cReturn:= nVltit
	
ElseIf cOP == "8"  //Valor do Pagamento
	
	nVlTit:= Replicate("0",15)
	nAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,1,"S",dDataBase,SE2->E2_LOJA)
	
	If Alltrim(SEA->EA_MODELO) $ "30/31"
		nVltit := Val(SubStr(SE2->E2_CODBAR,10,10))
		If nVlTit == 0			// Existem boletos que nao possuem valor
		nVlTit:= SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE
			nVltit := Strzero((nVlTit*100),15)
		Else
			nVlTit	:= StrZero(nVlTit,15)	
		EndIf      
		
	ElseIf Alltrim(SEA->EA_MODELO) $ "01/03/05/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		nVlTit:= SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-nAbat
		nVltit := Strzero((nVlTit*100),15)
	Endif
	
	cReturn:= nVltit
	
ElseIf cOP == "9"
	
	cMod  := "                        "
	
	If Alltrim(SEA->EA_MODELO) $ "01/03/05/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		cMod := "C000000"
		/*
		If SA2->A2_TPCON == "1"
		_cTpCred:= "01"    // DOC para conta corrente
		Else
		_cTpCred:= "11"    // DOC para poupança
		EndIf
		*/
		cTpCred	:="01"
		
		cReturn := cMod + cTpCred
		
	ElseIf Alltrim(SEA->EA_MODELO) = "01"    // SE FOR CREDITO EM C/C
		cReturn := Space(40)		
	ElseIf Alltrim(SEA->EA_MODELO) $ "30/31"	  // BOLETOS
		cCpoLiv:= SubStr(SE2->E2_CODBAR,20,25)
		cDvBar:= SubStr(SE2->E2_CODBAR,5,1)
		cMoeda:= SubStr(SE2->E2_CODBAR,4,1)
		cReturn := cCpoLiv + cDvBar + cMoeda
	EndIf
	
ElseIf cOP == "10"
	
	If Alltrim(SEA->EA_MODELO) $ "01/05"       // Credito em C/C
		cReturn := "01"
	ElseIF Alltrim(SEA->EA_MODELO) = "03"  // DOC Comp
		cReturn := "03"
	ElseIf Alltrim(SEA->EA_MODELO) = "30"   // Boleto Bradesco
		cReturn := "31"
	ElseIf Alltrim(SEA->EA_MODELO) = "31"   // Boleto Outros Bancos
		cReturn := "31"
	ElseIf Alltrim(SEA->EA_MODELO) = "41"   // TED CIP
		cReturn := "07"
	ElseIf Alltrim(SEA->EA_MODELO) = "43"   // TED CIP
		cReturn := "08"     
	Else	
		cReturn := " "	
	EndIf
	
ElseIf cOP == "11"
	
	If SA2->A2_TIPO <>'F'
		cReturn:= Strzero(val(SA2->A2_CGC),15)
	Else
		nTamCpf:= len(Alltrim(SA2->A2_CGC))
		cNum:= Alltrim(SA2->A2_CGC)
		cCPF   := Substr(cNum,1,nTamCpf-2)  // -2 para tirar o controle do CPF
		cCtlCpf:= RIGHT(alltrim(SA2->A2_CGC),2)
		// base                + filial   + controle
		cReturn:= Strzero(val(cCPF),9) + "0000" + cCtlCpf
	EndIf

ElseIf cOP == "12" 		// Conta corrente da empresa

		cConta :=  Alltrim(SA6->A6_NUMCON)
		
		If AT("-",cConta) > 0
			cConta := Substr(cConta,1,AT("-",cConta)-1)
		Endif
		cReturn:= StrZero(Val(cConta),7)
	
EndIf

Return(cReturn)