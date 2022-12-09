#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZBC0007		�Autor  �Microsiga	     � Data �  21/09/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �BACA para atualizar a descri��o da natureza nos titulos	  ���
���          �do contas a pagar											  ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� 
*/
User Function PZBC0007()

	Processa( {|| RunAtuSE2() },"Aguarde...","" )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RunAtuSE2		�Autor  �Microsiga	     � Data �  21/09/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza��o da tabela SE2									  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� 
*/
Static Function RunAtuSE2()

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nCnt		:= 0

	cQuery := " SELECT SE2.E2_NUM, SE2.E2_PREFIXO, SE2.E2_NATUREZ, E2_YDESNAT, SE2.R_E_C_N_O_ RECSE2 FROM "+RetSqlName("SE2")+" SE2 "+CRLF
	cQuery += " WHERE SE2.E2_FILIAL = '"+xFilial("SE2")+"' "+CRLF
	cQuery += " AND SE2.E2_NATUREZ != '' "
	cQuery += " AND SE2.E2_YDESNAT = '' "+CRLF
	cQuery += " AND SE2.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cArqTmp)->( DbGoTop() )

	ProcRegua(nCnt)

	DbSelectArea("SE2")
	DbSetOrder(1)
	While (cArqTmp)->(!Eof())
		
		IncProc("Processando...")

		SE2->(DbGoTo((cArqTmp)->RECSE2))

		SE2->(RecLock("SE2", .F.))
		SE2->E2_YDESNAT := Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_DESCRIC")
		SE2->(MsUnLock())

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return
