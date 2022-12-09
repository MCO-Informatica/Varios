#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � CNTPRSE2 � Autor � Wilson Martins Junior � Data � 04.09.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de entrada executado no momento da geracao de tiutlos ���
���          �provisionados no Financeiro apos alterar a situacao do Cto. ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Renova                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CNTPRSE2()

// Salva o ambiente atual
Local _aAmbiente := { {Alias()} , {"CN1"}, {"CN9"}, {"SE2"} }
SalvaAmbiente(@_aAmbiente)

CN1->(dbSetOrder(1))

If CN1->(DbSeek(xFilial("CN1")+CN9->CN9_TPCTO)) .AND. ! Empty(CN1->CN1_NATURE)
	SE2->E2_NATUREZ := CN1->CN1_NATURE
Endif

// Grava no contrato a filial que foi gerado a medi��o para tratativa
// dos titulos provis�rios
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
