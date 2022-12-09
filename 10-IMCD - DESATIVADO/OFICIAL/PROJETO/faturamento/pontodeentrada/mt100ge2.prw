/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2  ºAutor  ³Marcos J.           º Data ³  12/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para gravar no titulo o grupo de aprovacao financeira   º±±
±±º          ³de acordo com o cadastro de fornecedores                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#include "PROTHEUS.CH"
User Function MT100GE2()
	Local cAlias  := Alias()
	Local aAreaSA2:= SA2->(GetArea())

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT100GE2" , __cUserID )

	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + SF1->(F1_FORNECE + F1_LOJA), .F.))
	RECLOCK("SE2",.F.)
	SE2->E2_GRUPO		:= SA2->A2_GRPAPRO 
	SE2->E2_DESCONT		:= SE2->E2_DESCONT + SF1->F1_DESCONT
	SE2->E2_MULTA  		:= SE2->E2_MULTA
	SE2->E2_JUROS  		:= SE2->E2_JUROS
	SE2->E2_VLCRUZ 		:= SE2->E2_VLCRUZ+ SF1->F1_DESCONT
	MSUNLOCK()
Return