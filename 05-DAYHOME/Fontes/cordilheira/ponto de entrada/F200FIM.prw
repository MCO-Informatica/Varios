#include "rwmake.ch"
/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � F200FIM  � Autor � Ricardo Correa de Souza � Data � 15/09/2010 ���
���          �          �       � MVG Consultoria         �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Elimina os registros de recepcao cnab das tabelas FI0 e FI1    ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Dayhome                                                        ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
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
