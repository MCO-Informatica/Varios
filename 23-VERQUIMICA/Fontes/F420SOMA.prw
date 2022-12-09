#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: F420SOMA   | Autor: Celso Ferrone Martins | Data: 22/01/2015 |||
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
User Function F420SOMA()

Local _nSomaVlr := SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE
Local aAreaSe2  := SE2->(GetArea())
Local nAbat     := 0
Local cBusca    := xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)        

DbSelectArea("SE2") ; DbSetOrder(1)
DbSeek(cBusca)
While !Eof() .and. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA) == cBusca
	If SE2->E2_TIPO $ MVABATIM 
		nAbat += SE2->E2_SALDO
	Endif
	SE2->(dbSkip())
EndDo

_nSomaVlr -= nAbat

SE2->(RestArea(aAreaSe2))

Return(_nSomaVlr)