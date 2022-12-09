#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103EXC ºAutor  ³ Junior Carvalho    º Data ³  31/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ BLOQUEAR EXCLUSAO DE DOC. DE ENTRADA QUE GERARAM CUSTOS    º±±
±±º          ³ PELA MOVIMENTACAO INTERNA                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IMCD                                                       º±±
±±ÌÍÍÍÑÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºREV³ Programador   ³ Data     ³ Motivo da Alteracao                    º±±
±±ÌÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 01|Junior Carvalho³10/05/2016³ Nova validação para bloquear exclusao  º±±
±±º   |               ³          ³ dos Doc. gerados Pelo EIC              º±±
±±ÈÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103EXC()
	lRet := .T.
	if !(isincallstack("EICDI158"))
		if !(isincallstack("EICDI154"))

			If !EMPTY(ALLTRIM(SD1->D1_XINTSD3))

				cMsg1:= "Nao é permitida exclusão do documento."
				cMsg2:= "Esse Documento gerou custo de Importação."
				cMsg3:= "Solcicite o Desbloqueio ao Departamento de Custos."

				Aviso( "MT103EXC", cMsg1+CRLF+cMsg2+CRLF+cMsg3, { "Ok" }, 2 )

				lRet := .F.
			EndIf
			//REV 01 - Junior Carvalho - 10/05/2016
			If (!EMPTY(ALLTRIM(SD1->D1_CONHEC)) .AND. !(SD1->D1_TES $ '056|001' ) ) .AND. !(isincallstack("MATA140"))

				cMsg1:= "Não é permitida exclusão do documento Gerado Pelo Modulo de Importação SIGAEIC."
				cMsg2:= "Exclusão somente pelo Modulo de Importação(SIGAEIC)."

				Aviso( "MT103EXC", cMsg1+CRLF+cMsg2, { "Ok" }, 2 )

				lRet := .F.
			EndIf
		EndIf
	EndIf
//REV 01 - Junior Carvalho - 10/05/2016

Return lRet
