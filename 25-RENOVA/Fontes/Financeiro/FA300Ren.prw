#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA300Ren   ºAutor  ³Wellington Mendes     º Data ³  28/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para contabilizar títulos do tipo PA APÓS
a contabilização dos titulos baixados pelo LP 532 no retorno Sispag .     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FA300REN()
Local aArea := {SE5->(GetArea()), GetArea()}
Local lRet := .T.
Local cPadraoPA := "100"
Local nHdlPrv := 0
Local cLote := "008850"
Local cOrigem := "FINA300"
Local cArquivo := " "
Local nTotal := 0
Local nLoop := Nil

nHdlPrv := HeadProva(cLote, cOrigem, SubStr(cUsuario, 7, 6), @cArquivo)

If (nHdlPrv > 0)
	
	For nLoop := 1 to Len(MV_PAR60)
		SE2->(dbGoto(MV_PAR60[nLoop, 1]))
		SE5->(dbGoto(MV_PAR60[nLoop, 2]))
		nTotal += DetProva(nHdlPrv, cPadraoPA, cOrigem, cLote, , , , , , , , , , )
		
		RecLock("SE5", .F.)
		SE5->E5_ARQCNAB := "CNAB"
		SE5->E5_LA := "S"
		SE5->(MsUnlock())
	Next
Endif

RodaProva(nHdlPrv, nTotal)

cA100Incl(cArquivo, nHdlPrv, 3, cLote, .F., .F.)

M->MV_PAR60 := {}
aEval(aArea, {|x| RestArea(x)})
Return(lRet)
