#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVP003		�Autor  �Microsiga	     � Data �  06/06/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de reprocessamento da data de fabrica��o			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCVP003()

If Aviso("Aten��o","Confirma a atualiza��o da data de fabrica��o para produtos com saldo em estoque ?",{"Sim","N�o"},2) == 1
	Processa( {|| ProcDtFb()},"Aguarde...","" )
	
EndIf
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVP003		�Autor  �Microsiga	     � Data �  06/06/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de reprocessamento da data de fabrica��o			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcDtFb()

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local nCnt		:= 0
Local dDtFabric	:= CTOD('')

cQuery	:= " SELECT B8_PRODUTO, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE FROM "+RetSqlName("SB8")+" SB8 "+CRLF
cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
cQuery	+= " AND SB8.B8_SALDO > 0 "+CRLF
cQuery	+= " AND SB8.B8_LOTECTL != '' "+CRLF
cQuery	+= " AND SB8.B8_YFABRIC = '' " +CRLF
cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

(cArqTmp)->( DbGoTop() )
(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
(cArqTmp)->( DbGoTop() )

ProcRegua(nCnt)
While (cArqTmp)->(!Eof())
	
	IncProc("Processando...")
	dDtFabric := CTOD('')
	dDtFabric := GetDtFabri((cArqTmp)->B8_PRODUTO, (cArqTmp)->B8_LOCAL, (cArqTmp)->B8_LOTECTL, (cArqTmp)->B8_NUMLOTE) 
	
	If !Empty(dDtFabric)
		//Atualiza a data de fabrica��o
		u_PZCVA005((cArqTmp)->B8_PRODUTO, (cArqTmp)->B8_LOCAL, (cArqTmp)->B8_LOTECTL, (cArqTmp)->B8_NUMLOTE, dDtFabric)
	EndIf
	
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
���Funcao    �GetDtFabri	�Autor  �Microsiga	     � Data �  06/06/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a data de fabrica��o do ultimo doc.de entrada		  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetDtFabri(cProd, cLocal, cLote, cSubL)

Local aArea 	:= GetArea()
Local dDtRet	:= CTOD('')
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default cProd		:= "" 
Default cLocal		:= "" 
Default cLote		:= "" 
Default cSubL		:= ""

cQuery	:= " SELECT D1_COD, D1_LOCAL, D1_LOTECTL, D1_NUMLOTE, D1_FABRIC, R_E_C_N_O_ RECSD1 FROM "+RetSqlName("SD1")+" SD1 "+CRLF
cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF
cQuery	+= " AND SD1.D1_COD = '"+cProd+"' "+CRLF
//cQuery	+= " AND SD1.D1_LOCAL = '"+cLocal+"' "+CRLF
cQuery	+= " AND SD1.D1_LOTECTL = '"+cLote+"' "+CRLF
cQuery	+= " AND SD1.D1_NUMLOTE = '"+cSubL+"' "+CRLF
cQuery	+= " AND SD1.D1_FABRIC != '' "+CRLF
cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " ORDER BY R_E_C_N_O_ DESC "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

If (cArqTmp)->(!Eof())
	dDtRet := StoD((cArqTmp)->D1_FABRIC) 
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return dDtRet