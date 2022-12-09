#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: F200VAR  | Autor: Celso Ferrone Martins   | Data: 24/09/2015 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

// Estrutura de aValores
// Numero do T°tulo		- 01
// data da Baixa		- 02
// Tipo do T°tulo		- 03
// Nosso Numero			- 04
// Valor da Despesa		- 05
// Valor do Desconto	- 06
// Valor do Abatimento	- 07
// Valor Recebido    	- 08
// Juros				- 09
// Multa				- 10
// Outras Despesas		- 11
// Valor do Credito		- 12
// Data Credito			- 13
// Ocorrencia			- 14
// Motivo da Baixa 		- 15
// Linha Inteira		- 16
// Data de Vencto		- 17

User Function F200VAR()

Local aAreaSe1 := SE1->(GetArea())

DbSelectArea("SE1") ; DbSetOrder(5)
If SE1->(DbSeek(xFilial("SE1")+PARAMIXB[1][4]))
	RecLock("SE1",.F.)
	SE1->E1_DESPCAR += PARAMIXB[1][5]
	MsUnLock()
EndIf
SE1->(RestArea(aAreaSe1))

Return()