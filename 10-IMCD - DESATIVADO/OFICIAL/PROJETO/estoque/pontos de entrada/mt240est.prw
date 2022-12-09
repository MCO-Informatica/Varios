#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT240EST ºAutor  ³ Junior Carvalho    º Data ³  31/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ BLOQUEAR EXCLUSAO DE MOVIMENTACAO INTERNA  QUE GERARAM     º±±
±±º          ³ CUSTOS do DOC. DE ENTRADA                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IMCD                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT240EST()

	Local lRet := .T.
	Local cDocSd1 := SD3->D3_XIMPEIC
	If !Empty(cDocSd1)

		cChvSF1 := Substr(D3_XIMPEIC,1,At("EIC",cDocSd1)-1)

		cUsuarios := SuperGetMV("ES_USRCEIC", ," ")

		if __CUSERID $ cUsuarios
			dbSelectArea("SD1")
			dbSetOrder(1)
			if MsSeek(cChvSF1)
				RecLock("SD1" , .F.)
				SD1->D1_XINTSD3 := ' '
				MsUnLock()
			EndIf
			lRet := .T.
		Else
			cMsg1:= "Essa movimentação foi gerada por custos de Importação."
			cMsg2:= "Só poderá ser estornada pelo Departamento de Custos."

			Aviso( "MT240EST", cMsg1+CRLF+cMsg2, { "Ok" }, 2 )
			lRet := .F.
		EndIf
	Endif

Return lRet

