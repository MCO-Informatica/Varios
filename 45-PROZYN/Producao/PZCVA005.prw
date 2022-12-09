#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVA005		�Autor  �Microsiga	     � Data �  06/06/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Preenche a data de fabrica��o na tabela SB8				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCVA005(cProd, cLocal, cLote, cSubL, dDtFabric, lConsArmz)

Default cProd		:= "" 
Default cLocal		:= "" 
Default cLote		:= "" 
Default cSubL		:= ""
Default dDtFabric	:= CTOD('')
Default lConsArmz	:= .F.

//Atualiza a data de fabrica��o
If !Empty(cProd) .And. !Empty(cLote) .And. !Empty(dDtFabric)
	AtuFabSb8(cProd, cLocal, cLote, cSubL, dDtFabric, lConsArmz )
EndIf	
	
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuFabSb8 �Autor  �Microsiga           � Data � 06/06/19    ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza��o da data de fabrica��o na tabela SB8			  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function AtuFabSb8(cProd, cLocal, cLote, cSubL, dDtFabric, lConsArmz )

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default cProd		:= "" 
Default cLocal		:= "" 
Default cLote		:= "" 
Default cSubL		:= ""
Default dDtFabric	:= CTOD('')
Default lConsArmz	:= .F.

cQuery	:= " SELECT R_E_C_N_O_ RECSB8 FROM "+RetSqlName("SB8")+" SB8 "
cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
cQuery	+= " AND SB8.B8_PRODUTO = '"+cProd+"' "

//Informa se considera o armazem no filtro
If lConsArmz
	cQuery	+= " AND SB8.B8_LOCAL = '"+cLocal+"' "
EndIf

cQuery	+= " AND SB8.B8_LOTECTL = '"+cLote+"' "
cQuery	+= " AND SB8.B8_NUMLOTE = '"+cSubL+"' " 
cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

DbSelectArea("SB8")
DbSetOrder(1)
While (cArqTmp)->(!Eof()) 
	
	SB8->(DbGoTo((cArqTmp)->RECSB8))
	
	RecLock("SB8",.F.)
	SB8->B8_YFABRIC := dDtFabric
	SB8->(MsUnLock())
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PZCVADT5 �Autor  �Microsiga           � Data � 06/06/19    ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a data de fabrica��o do produto e lote			  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function PZCVADT5(cProd, cLocal, cLote, cSubL, lConsArmz)

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local dDtRet	:= CTOD('')

Default cProd		:= "" 
Default cLocal		:= "" 
Default cLote		:= "" 
Default cSubL		:= ""
Default lConsArmz	:= .F.

cQuery	:= " SELECT B8_YFABRIC FROM "+RetSqlName("SB8")+" SB8 "+CRLF
cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
cQuery	+= " AND SB8.B8_PRODUTO = '"+cProd+"' "+CRLF

//Informa se considera o armazem no filtro
If lConsArmz
	cQuery	+= " AND SB8.B8_LOCAL = '"+cLocal+"' "+CRLF
EndIf

cQuery	+= " AND SB8.B8_LOTECTL = '"+cLote+"' "+CRLF
cQuery	+= " AND SB8.B8_NUMLOTE = '"+cSubL+"' "+CRLF 
cQuery	+= " AND SB8.B8_YFABRIC != '' "+CRLF
cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

DbSelectArea("SB8")
DbSetOrder(1)
If (cArqTmp)->(!Eof()) 
	dDtRet := StoD((cArqTmp)->B8_YFABRIC)
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return dDtRet
