#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PZCVV006	ºAutor  ³Microsiga		     º Data ³  15/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação do saldo do produto na desmontagem de produto     º±±
±±º          ³(Mata242)                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function PZCVV006()

	Local aArea		:= GetArea()
	local cQuery	:= ""
	Local cArqTmp	:= ""
	Local lRet		:= .T.
	Local cCod		:= "" 
	Local cArmaz	:= ""

	If IsInCallStack("MATA242")

		cCod	:= GdFieldGet("D3_COD") 
		cArmaz	:= GdFieldGet("D3_LOCAL")

		If Empty(cCod) .Or. Empty(cArmaz) 
			lRet := .F.
			Aviso("Atenção","Código do produto e/ou armazém não informado.",{"Ok"},2)
		Else
			cArqTmp	:= GetNextAlias()
			cQuery	:= " SELECT B2_COD, B2_LOCAL, (B2_QATU-B2_RESERVA-B2_QACLASS) SALDO FROM "+RetSqlName("SB2")+" SB2 "
			cQuery	+= " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' "
			cQuery	+= " AND SB2.B2_COD = '"+cCod+"' " 
			cQuery	+= " AND SB2.B2_LOCAL = '"+cArmaz+"' "
			cQuery	+= " AND SB2.D_E_L_E_T_ = ' ' "

			DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

			If (cArqTmp)->(!Eof())
				If (cArqTmp)->SALDO > 0
					lRet := .F.
					Aviso("Atenção","Produto com saldo existente, não será permitido à desmontagem. ",{"Ok"},2)
				EndIf
			EndIf

			If Select(cArqTmp) > 0
				(cArqTmp)->(DbCloseArea())
			EndIf
		EndIf
	EndIf

	RestArea(aArea)	
Return lRet