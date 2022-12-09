#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ F200FIM  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 15/09/2010 ³±±
±±³          ³          ³       ³ MVG Consultoria         ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Elimina os registros de recepcao cnab das tabelas FI0 e FI1    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Dayhome                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F200FIM()

Local cQuery   := ""
Local cAliasTOP
Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local lFI0InDic := AliasInDic("FI0")

If ! lFI0InDic
	Return Nil
Endif

DbSelectArea("FI0")
cQuery := "SELECT R_E_C_N_O_ FI0RECNO FROM " + RetSqlName("FI0") + " WHERE D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)
MemoWrit('F200FIMFI0.SQL',cQuery)
cAliasTOP := CriaTrab(Nil, .F.)
MsAguarde({|| dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery), cAliasTOP,.F.,.T.)}, "Selecionando Registros ...")

DbSelectArea((cAliasTOP))
ProcRegua((cAliasTOP)->( RecCount() ))
(cAliasTOP)->( DbGoTop() )
Do While ! (cAliasTOP)->(Eof() )
	FI0->( MsGoTo( (cAliasTOP)->FI0RECNO ) )
	
	RecLock( "FI0", .f. )
	FI0->( dbDelete() )
	FI0->( MsUnlock() )
	
	ProcessMessages()
	IncProc("Eliminando Registros")
	ProcessMessages()
	(cAliasTOP)->( DbSkip() )
EndDo
dbSelectArea((cAliasTOP))
dbCloseArea()


DbSelectArea("FI1")
cQuery := "SELECT R_E_C_N_O_ FI1RECNO FROM " + RetSqlName("FI1") + " WHERE D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)
MemoWrit('F200FIMFI1.SQL',cQuery)
cAliasTOP := CriaTrab(Nil, .F.)
MsAguarde({|| dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery), cAliasTOP,.F.,.T.)}, "Selecionando Registros ...")

DbSelectArea((cAliasTOP))
ProcRegua((cAliasTOP)->( RecCount() ))
(cAliasTOP)->( DbGoTop() )
Do While ! (cAliasTOP)->(Eof() )
	FI1->( MsGoTo( (cAliasTOP)->FI1RECNO ) )
	
	RecLock( "FI1", .f. )
	FI1->( dbDelete() )
	FI1->( MsUnlock() )
	
	ProcessMessages()
	IncProc("Eliminando Registros")
	ProcessMessages()
	(cAliasTOP)->( DbSkip() )
EndDo
dbSelectArea((cAliasTOP))
dbCloseArea()

SE1->(RestArea(aAreaSE1))
RestArea(aArea)

Return Nil
