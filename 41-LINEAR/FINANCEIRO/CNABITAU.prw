#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNABITAU  ºAutor  ³Thiago Queiroz      º Data ³  23/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza o calculo do digito verificador do arquivo CNAB    º±±
±±º          ³ e do Boleto Itau	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10 - LINCIPLAS                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CNABITAU

//Public _cDig := ""
//MSGBOX(ALLTRIM(SE1->E1_PORTADO), ALLTRIM(SE1->E1_AGEDEP), ALLTRIM(SE1->E1_CONTA))
IF ALLTRIM(SE1->E1_PORTADO) == "341" .AND. ALLTRIM(SE1->E1_AGEDEP) == "7646" .AND. ALLTRIM(SE1->E1_CONTA) == "075270" //BANCO ITAU
	//Alert("garantia")
	xcpo := "764607527109"+SUBSTR(SE1->E1_NUMBCO,2,9)
	_cDig := U_MOD10(xcpo,1,2)
	//IF val(_cDig) == 10
	//	_cDig := "P"
	//ELSE
	_cDig := SUBSTR(_cDig,2,1)
	//ENDIF
	//ELSE
	//Alert("A agencia/conta do Itau deve ser a 7646/075270. <br> O arquivo não será gerado.")
ELSEIF ALLTRIM(SE1->E1_PORTADO) == "341" .AND. ALLTRIM(SE1->E1_AGEDEP) == "7646" .AND. ALLTRIM(SE1->E1_CONTA) == "004791" //BANCO ITAU
	//Alert("garantia")
	xcpo := "764600479109"+SUBSTR(SE1->E1_NUMBCO,2,9)
	_cDig := U_MOD10(xcpo,1,2)
	//IF val(_cDig) == 10
	//	_cDig := "P"
	//ELSE
	_cDig := SUBSTR(_cDig,2,1)
	
ENDIF



Return(_cDig)
