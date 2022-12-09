#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTPRSE2 ³ Autor ³ Wilson Martins Junior ³ Data ³ 04.09.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada executado no momento da geracao de tiutlos ³±±
±±³          ³provisionados no Financeiro apos alterar a situacao do Cto. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CNTPRSE2()

// Salva o ambiente atual
Local _aAmbiente := { {Alias()} , {"CN1"}, {"CN9"}, {"SE2"} }
SalvaAmbiente(@_aAmbiente)

CN1->(dbSetOrder(1))

If CN1->(DbSeek(xFilial("CN1")+CN9->CN9_TPCTO)) .AND. ! Empty(CN1->CN1_NATURE)
	SE2->E2_NATUREZ := CN1->CN1_NATURE
Endif

// Grava no contrato a filial que foi gerado a medição para tratativa
// dos titulos provisórios
DbSelectArea("CN9")
Reclock("CN9",.F.)
CN9->CN9_XFTITI := xFilial("SE2")
MsUnlock()
RestAmbiente(_aAmbiente)

Return


*****************************
// Funcao para salvar o ambiente
*****************************
Static function SalvaAmbiente(_aAmbiente)

Local _ni

For _ni := 1 to len(_aAmbiente)
	dbselectarea(_aAmbiente[_ni,1])
	AADD(_aAmbiente[_ni],indexord())
	AADD(_aAmbiente[_ni],recno())
Next

Return

// Funcao para restaurar o ambiente
Static function RestAmbiente(_aAmbiente)

Local _ni

For _ni := len(_aAmbiente) to 1 step -1
	dbselectarea(_aAmbiente[_ni,1])
	dbsetorder(_aAmbiente[_ni,2])
	dbgoto(_aAmbiente[_ni,3])
Next

Return()
