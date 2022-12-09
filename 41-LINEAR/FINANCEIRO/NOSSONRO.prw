#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOSSONRO  ºAutor  |Thiago Queiroz      º Data ³  02/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNÇÃO QUE CRIA O NOSSO NUMERO NO CAMPO E1_NUMBCO PARA     º±±
±±º          ³ IMPRESSÃO DO BOLETO DO BRADESCO 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10 - LINCIPLAS                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NOSSONRO()

Private cRet := ""
Private cDig := ""

IF SE1->E1_PORTADO == "237" //BANCO BRADESCO
	IF EMPTY(SE1->E1_NUMBCO)
		//	cRet := "00" + SUBSTR(NOSSONUM(),4,9)
		cRet := "00" + NOSSONUM()
		cDig := U_CNABBRAD()
		
		// GRAVA O DIGITO DE VERIFICAÇÃO DO NOSSO NUMERO NO SE1
		RecLock("SE1",.F.)
		//SE1->E1_NUMBCO  := Alltrim(Str(Val(SE1->E1_NUMBCO)))+_cDig
		SE1->E1_NUMBCO  := 	ALLTRIM(SE1->E1_NUMBCO) + cDig
	ELSE
		//	cRet := "00" + SUBSTR(SE1->E1_NUMBCO,4,9)
		cRet := "00" + SUBSTR(SE1->E1_NUMBCO,1,9)
	ENDIF
ELSEIF SE1->E1_PORTADO == "341" //BANCO ITAU
	IF EMPTY(SE1->E1_NUMBCO)
		//	cRet := "00" + SUBSTR(NOSSONUM(),4,9)
		cRet := SUBSTR(NOSSONUM(),2,9)
		cDig := U_CNABITAU()
		
		// GRAVA O DIGITO DE VERIFICAÇÃO DO NOSSO NUMERO NO SE1
		RecLock("SE1",.F.)
		//SE1->E1_NUMBCO  := Alltrim(Str(Val(SE1->E1_NUMBCO)))+_cDig
		SE1->E1_NUMBCO  := 	ALLTRIM(SE1->E1_NUMBCO) + cDig
		
	ELSE
		//	cRet := "00" + SUBSTR(SE1->E1_NUMBCO,4,9)
		cRet := SUBSTR(SE1->E1_NUMBCO,2,9)
	ENDIF
ENDIF


Return(cRet)

