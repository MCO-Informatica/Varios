#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA300Ren   �Autor  �Wellington Mendes     � Data �  28/05/15 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para contabilizar t�tulos do tipo PA AP�S
a contabiliza��o dos titulos baixados pelo LP 532 no retorno Sispag .     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
���������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
