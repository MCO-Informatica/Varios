#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGSFR    ºAutor  ³Rodrigo Okamoto       º Data ³  17/02/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna string para o CNAB SAFRA 400 de pagamento a        º±±
±±º          ³ fornecedores (SAFRA.CPE)                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10 - LINCIPLAS                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PAGSFR01

Private cRet   := ""
Private nValor := 0

nValor := SE2->E2_SALDO-SE2->E2_DECRESC
If SEA->EA_MODELO=="01"
	cRet := "CC "
ElseIf SEA->EA_MODELO=="03" .and. nValor < 5000
	cRet := "DOC"
ElseIf SEA->EA_MODELO=="03".and. nValor >= 5000
	cRet := "TED"
ElseIf SEA->EA_MODELO$"30/31"
	cRet := "COB"
EndIf


Return(cRet) 

//***********************************************
//Retorna se é pessoa fisica ou juridica somente para DOC/TED ou transferência entre contas
User Function PAGSFR02

Private cRet2   := ""

If SEA->EA_MODELO$"30/31"
	cRet2 := " "
Else
	cRet2 := IIF(SUBSTR(SA2->A2_TIPO,1,1)="F","1","2")
EndIf


Return(cRet2) 

     
//***********************************************
//Retorna o codigo do banco com diferenciação se o pagamento é de boleto ou DOC/TED
User Function PAGSFR03

Private cRet3   := ""

If SEA->EA_MODELO$"30/31"
	cRet3 := Subs(SE2->E2_CODBAR,1,3)
Else
	cRet3 := SA2->A2_BANCO
EndIf

Return(cRet3) 


//***********************************************
//Retorna a agencia 
User Function PAGSFR04

Private cRet4   := ""

If SEA->EA_MODELO $ "30/31"
	cRet4 := REPLICATE("0",7)
Else
	cRet4 := STRZERO(VAL(ALLTRIM(SA2->A2_AGENCIA)),7,0)                  
EndIf

Return(cRet4) 

   
//***********************************************
//Retorna a conta
User Function PAGSFR05

Private cRet5   := ""

If SEA->EA_MODELO $ "30/31"
	cRet5 := REPLICATE("0",10)
Else
	cRet5 := STRZERO(VAL(ALLTRIM(SA2->A2_NUMCON)),10,0)
EndIf

Return(cRet5) 


//***********************************************
//Retorna o valor do desconto para pagamento de boletos bancários
User Function PAGSFR06

Private cRet6   := ""

If SEA->EA_MODELO $ "30/31"
	cRet6 := STRZERO((ROUND(SE2->E2_DECRESC,2)*100),13)
Else
	cRet6 := REPLICATE("0",13)
EndIf

Return(cRet6) 

