#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT105LOK   ºAutor  ³Wellington Mendes  º Data ³  Ago/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ permite a validação das entidades contábeis no momento da º±±
gravação do lançamento contábil das rotinas CTBA102 e CTBA105 , esse pontoº±±
de entrada pode substituir a validação atual que verifica se as entidades º±±
de débito e crédito são iguais.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT105LOK()

Local aArea  := GetArea()
Local lRet   := .T.

Local _cDCR       := TMP->CT2_DC
Local _cDebitoR   := TMP->CT2_DEBITO
Local _cCreditoR  := TMP->CT2_CREDIT
Local _cHist      := TMP->CT2_HIST

//If _cDebitoR == _cCreditoR .AND. _cDCR <> "4" // exemplo de condicao que pode ser feita para validacao das entidades
//	lRet := .F.
//	MsgAlert("Não é permitido partida dobrada para mesma conta, contas debito/credito não podem ser iguais")

IF _cDCR == "2" .AND. !empty(_cDebitoR)
	MsgAlert("Não é permitido preencher uma conta Débito em um lançamento do tipo Crédito.")
	lRet := .F.
ElseIF _cDCR == "1" .AND. !empty(_cCreditoR)
	MsgAlert("Não é permitido preencher uma conta Crédito em um lançamento do tipo Débito.")
	lRet := .F.
	
Elseif ALLTRIM(SA2->A2_COD) $"UNIAO" .AND. "UNIAO" $ ALLTRIM(_cHist) .AND. IsInCallStack("FINA190")
	MsgAlert("Não é permitido histórico com fornecedor UNIAO, favor colocar o nome correto do fornecedor do cheque.")
	lRet := .F.
Else
	lRet := .T.
Endif

RestArea(aArea)

Return lRet

