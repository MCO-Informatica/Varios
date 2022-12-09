#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BRASILCP  ºAutor  ³Andreza Favero      º Data ³  10/01/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera as informacoes para o cnab de contas a pagar para o    º±±
±±º          ³Banco Brasil                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico HCI    .                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BrasilCP(cOpcao)

Local cReturn   := " "
Local cAgencia  := " "
Local cNumCC    := " "
Local cDVAgencia:= " "
Local cDVNumCC  := " "            
Local cAgcli	:= " "

If 	cOpcao == "1" // Obtem o numero da agencia
	
	cAgencia :=  Alltrim(SA2->A2_AGENCIA)
	
	If AT("-",cAgencia) > 0
		cAgencia := Substr(cAgencia,1,AT("-",cAgencia)-1)
	Endif
	
	cAgencia := STRTRAN(cAgencia,".","")

	cReturn := StrZero(Val(cAgencia),5)
	
ElseIf cOpcao == "2"    // Obtem o DV do numero da agencia

	cDVAg :=  Alltrim(SA2->A2_AGENCIA)
	If AT("-",cDVAg) > 0
		cDVAg := Substr(cDVAg,AT("-",cDVAg)+1,2)
	Else
		cDVAg := Space(1)
	Endif
	
	cReturn := StrZero(Val(cDvAg),1)
			    		
ElseIf cOpcao == "3"    // Obtem o numero da conta corrente
	
	cNumCC :=  Alltrim(SA2->A2_NUMCON)
	
	If AT("-",cNumCC) > 0
		cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
	Endif

	cReturn := StrZero(Val(cNumCC),12)

ElseIf cOpcao == "4"    // Obtem o DV numero da conta corrente
	
	cDVNumCC :=  Alltrim(SA2->A2_NUMCON)
	If AT("-",cDVNumCC) > 0
		cDVNumCC := Substr(cDVNumCC,AT("-",cDVNumCC)+1,2)
	Else
		cDVNumCC := Space(1)
	Endif
	
	cReturn := StrZero(Val(cDvNumCC),1)

ElseIf cOpcao == "5"    // Obtem o Modelo do Bordero
	
	cReturn :=  Alltrim(SEA->EA_MODELO)

	If cReturn	==	"01" .OR. cReturn	==	"05" 	// CC
		cReturn	:=	"000"
	ElseIf cReturn	==	"03"    // DOC
		cReturn	:=	"700"
	ElseIf cReturn	==	"41"	// TED
		cReturn	:=	"018"
	Endif
		
EndIf

Return(cReturn)