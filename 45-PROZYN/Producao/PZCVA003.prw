#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuAtivSb8 �Autor  �Microsiga           � Data � 06/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza��o da atividade na tabela SB8					  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function PZCVA003(cProd, cLocal, cLote, cSubL, nAtiv)

Local aArea := GetArea()

Default cProd	:= "" 
Default cLocal	:= "" 
Default cLote	:= "" 
Default cSubL	:= ""
Default nAtiv	:= 0

//Atualiza a atividade no saldo por lote
AtuAtivSb8(cProd, cLocal, cLote, cSubL, nAtiv )

RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuAtivSb8 �Autor  �Microsiga           � Data � 06/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza��o da atividade na tabela SB8					  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function AtuAtivSb8(cProd, cLocal, cLote, cSubL, nAtiv )

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default cProd	:= "" 
Default cLocal	:= "" 
Default cLote	:= "" 
Default cSubL	:= ""
Default nAtiv	:= 0

cQuery	:= " SELECT R_E_C_N_O_ RECSB8 FROM "+RetSqlName("SB8")+" SB8 "
cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
cQuery	+= " AND SB8.B8_PRODUTO = '"+cProd+"' "
cQuery	+= " AND SB8.B8_LOCAL = '"+cLocal+"' "
cQuery	+= " AND SB8.B8_LOTECTL = '"+cLote+"' "
cQuery	+= " AND SB8.B8_NUMLOTE = '"+cSubL+"' " 
cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

DbSelectArea("SB8")
DbSetOrder(1)
While (cArqTmp)->(!Eof()) 
	
	SB8->(DbGoTo((cArqTmp)->RECSB8))
	
	RecLock("SB8",.F.)
	SB8->B8_YATIVID := nAtiv
	SB8->(MsUnLock())
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

MemoWrite('Qry_AtuAtivSb8.txt',cQuery)

RestArea(aArea)
Return
