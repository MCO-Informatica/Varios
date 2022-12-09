#include 'protheus.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MA261TRD3		�Autor  �Microsiga	     � Data �  06/06/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. apos a grava��o da transferencia MULTIPLA			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA261TRD3()

Local aArea := GetArea()

If INCLUI .Or. ALTERA	
	//Atualiza��o da data de fabrica��o
	AtuDtFab(SD3->D3_DOC)
EndIf	
RestArea(aArea)	
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AtuDtFab		�Autor  �Microsiga	     � Data �  06/06/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza da de fabrica��o dos produtos utilizados no 		  ���
���          �movimento                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuDtFab(cDocD3)

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local dDtFabric	:= CTOD('')

Default cDocD3	:= ""

cQuery	:= " SELECT D3_COD, D3_LOTECTL, D3_NUMLOTE FROM "+RetSqlName("SD3")+" SD3 "+CRLF
cQuery	+= " WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
cQuery	+= " AND SD3.D3_DOC = '"+cDocD3+"' "+CRLF
cQuery	+= " and SD3.D3_LOTECTL != '' " +CRLF
cQuery	+= " AND SD3.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " GROUP BY D3_COD, D3_LOTECTL, D3_NUMLOTE "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

While (cArqTmp)->(!Eof())
	dDtFabric := CTOD('')
	
	//Data de fabrica��o
	dDtFabric := U_PZCVADT5(D3_COD,, D3_LOTECTL, D3_NUMLOTE)
	
	If !Empty(dDtFabric)
		//Atualiza a data de fabrica��o
		U_PZCVA005((cArqTmp)->D3_COD,, (cArqTmp)->D3_LOTECTL, (cArqTmp)->D3_NUMLOTE, dDtFabric)
	EndIf
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return