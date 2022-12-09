#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZBC0008		�Autor  �Microsiga	     � Data �  21/09/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �BACA para atualizar o centro de custo nos titulos			  ���
���          �do contas a pagar. N�o utilizar esse fonte no RPO de 		  ���
���          �produ��o													  ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� 
*/
User Function PZBC0008()
	
	Local aParam	:= {}

	If PergRel(@aParam)
		Processa( {|| RunAtuSE2(aParam[1],aParam[2]) },"Aguarde...","" )
	EndIf

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
Static Function RunAtuSE2(dDtIni, dDtFin)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nCnt		:= 0
	
	Default dDtIni	:= CTOD('') 
	Default dDtFin	:= CTOD('')

	cQuery	:= " SELECT D1_DOC, D1_SERIE, D1_CC, CTT_DESC01, SE2.R_E_C_N_O_ RECSE2 FROM "+RetSqlName("SD1")+" SD1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF1")+" SF1 "+CRLF
	cQuery	+= " ON SF1.F1_FILIAL = SD1.D1_FILIAL "+CRLF
	cQuery	+= " AND SF1.F1_DOC = SD1.D1_DOC "+CRLF
	cQuery	+= " AND SF1.F1_SERIE = SD1.D1_SERIE "+CRLF
	cQuery	+= " AND SF1.F1_FORNECE = SD1.D1_FORNECE "+CRLF
	cQuery	+= " AND SF1.F1_LOJA = SD1.D1_LOJA "+CRLF
	cQuery	+= " AND SF1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("CTT")+" CTT "+CRLF
	cQuery	+= " ON CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "+CRLF
	cQuery	+= " AND CTT.CTT_CUSTO = SD1.D1_CC "+CRLF
	cQuery	+= " AND CTT.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD1.D1_TES "+CRLF
	cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SE2")+" SE2 "+CRLF
	cQuery	+= " ON SE2.E2_FILIAL = '"+xFilial("SE2")+"' "+CRLF
	cQuery	+= " AND SE2.E2_PREFIXO = SF1.F1_PREFIXO "+CRLF
	cQuery	+= " AND SE2.E2_NUM = SF1.F1_DUPL "+CRLF
	cQuery	+= " AND SE2.E2_FORNECE = SF1.F1_FORNECE "+CRLF
	cQuery	+= " AND SE2.E2_LOJA = SF1.F1_LOJA "+CRLF
	cQuery	+= " AND SE2.E2_CCUSTO = '' "+CRLF
	cQuery	+= " AND SE2.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' "+CRLF
	cQuery	+= " AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFin)+"'  "+CRLF
	cQuery	+= " AND SD1.D1_TIPO != 'D' "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " AND (SELECT COUNT(DISTINCT D1_CC) CONTADOR FROM SD1010 SD1_2 "+CRLF
	cQuery	+= " 	WHERE SD1_2.D1_FILIAL= SD1.D1_FILIAL "+CRLF
	cQuery	+= " 	AND SD1_2.D1_DOC = SD1.D1_DOC "+CRLF
	cQuery	+= " 	AND SD1_2.D1_SERIE = SD1.D1_SERIE "+CRLF
	cQuery	+= " 	AND SD1_2.D1_FORNECE = SD1.D1_FORNECE "+CRLF
	cQuery	+= " 	AND SD1_2.D1_LOJA = SD1.D1_LOJA "+CRLF
	cQuery	+= " 	AND SD1_2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " 	 ) =1 "+CRLF
	cQuery	+= " ORDER BY D1_DOC, D1_SERIE "+CRLF

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
		SE2->E2_CCUSTO	:= (cArqTmp)->D1_CC 
		SE2->E2_YDESCCU	:= (cArqTmp)->CTT_DESC01
		SE2->(MsUnLock())

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
���Programa  �PergRel  �Autor  �Microsiga	         � Data �  16/10/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pergunta para selecionar o arquivo                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                               	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PergRel(aParam)

	Local aArea 		:= GetArea()
	Local aParamBox		:= {} 
	Local lRet			:= .F.
	Local cLoadArq		:= "PZBC0008_"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)		

	AADD(aParamBox,{1,"Dt.Digit. De"				  ,CTOD('')					,"","","","",50,.T.})
	AADD(aParamBox,{1,"Dt.Digit. At�"				  ,CTOD('')					,"","","","",50,.T.})

	//Monta a pergunta
	lRet := ParamBox(aParamBox, "Par�metros", @aParam, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

	RestArea(aArea)
Return lRet  

