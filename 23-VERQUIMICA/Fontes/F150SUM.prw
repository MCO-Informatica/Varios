#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: F150SUM   | Autor: Celso Ferrone Martins | Data: 22/01/2015  |||
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
User Function F150SUM()

	Local _nSomaVlr := SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE
	Local aAreaSe1  := SE1->(GetArea())
	Local nAbat     := 0
	Local cBusca    := xFilial("SE1")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)        

	DbSelectArea("SE1") ; DbSetOrder(1)

	dbSeek(cBusca)

	While !Eof() .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == cBusca
		If SE1->E1_TIPO $ MVABATIM 
			nAbat += SE1->E1_SALDO
		Endif
		SE1->(dbSkip())
	EndDo

	_nSomaVlr -= nAbat

	SE1->(RestArea(aAreaSe1))

Return(_nSomaVlr)