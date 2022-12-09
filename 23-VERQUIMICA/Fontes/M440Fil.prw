#Include "Protheus.Ch"
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: M440Fil    | Autor: Celso Ferrone Martins | Data: 14/11/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function M440Fil()

Local aAreaSc5	:= SC5->(GetArea())
Local lRet 		:= ""
Local cFiltro	:= ""

SX1->(DbSetOrder(1))
SX1->(DbSeek("M440PERG"))

While !SX1->(EoF()) .And. AllTrim(SX1->X1_GRUPO) == "M440PERG"
	//
	RecLock("SX1", .F.)
		SX1->X1_CNT01 := ""
		//
		If AllTrim(SX1->X1_GSC) == "C"
			SX1->X1_PRESEL := 1
		EndIf
		//
	SX1->(MsUnLock())
	//
	SX1->(DbSkip())
	//
EndDo

DbSelectArea("SC5")

lRet := Pergunte("M440PERG", .T.)

If lRet .And. (!Empty(MV_PAR01) .Or. !Empty(MV_PAR02) .Or. MV_PAR04 <> 1)
	//
	If !Empty(MV_PAR01)
		cFiltro += ".And.C5_TRANSP=='"+MV_PAR01+"'"
	EndIf
	//
	If !Empty(MV_PAR02)
		cFiltro += ".And.C5_CLIENTE=='"+MV_PAR02+"'.And.C5_LOJACLI=='"+MV_PAR03+"'"
	EndIf
	//
	If MV_PAR04 == 2
		cFiltro += ".And.C5_VQ_FVER=='N'"
	ElseIf MV_PAR04 == 3
		cFiltro += ".And.(C5_VQ_FVER=='R' .Or. C5_VQ_FCLI=='R')"
	ElseIf MV_PAR04 == 4
		cFiltro += ".And.(C5_VQ_FVER=='D' .Or. C5_VQ_FCLI=='D')"
	EndIf
	//
	Set Filter To &("C5_FILIAL=='"+xFilial("SC5")+"'.And.Empty(C5_BLQ).And.Empty(C5_NOTA)"+cFiltro)	
	//
Else
	//
	Set Filter To &("C5_FILIAL=='"+xFilial("SC5")+"'.And.Empty(C5_BLQ).And.Empty(C5_NOTA)")
	//
EndIf

RestArea(aAreaSc5)

Return()