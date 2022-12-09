#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATE014  �Autor  �DERIK SANTOS        � Data �  04/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para retornar o proximo numero do cadastro de       ���
���          � produtos, pois a rotina automatica esta com falha          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATE014()

Local _cQuery	:= ""
Local _cAlias	:= GetNextAlias()
Local _cEnt		:= CHR(13) + CHR(10)
Local _cCod		:= ""

	_cQuery := " SELECT ISNULL(MAX(B1_COD),'000000') B1_COD " + _cEnt 
	_cQuery += " FROM " + RetSqlName("SB1") + " SB1         " + _cEnt  
	_cQuery += " WHERE D_E_L_E_T_=''                        " + _cEnt  
	_cQuery += " AND B1_FILIAL='" + xFilial("SB1") + "'     " + _cEnt  
	_cQuery += " AND ISNUMERIC(B1_COD)=1                    " + _cEnt 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
	
	dbSelectArea(_cAlias)

	_cCod := SOMA1(AllTrim((_cAlias)->B1_COD))
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())

Return(_cCod)