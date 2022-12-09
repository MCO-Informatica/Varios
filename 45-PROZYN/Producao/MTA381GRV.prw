#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
����������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � MT380ALT � Autor � Newbridge			  � Data � 09/08/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajuste das ordens de separa��o ap�s altera�ao de lote      ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MTA381GRV()

// Local ExpL1:= PARAMIXB[1]
// Local ExpL2:= PARAMIXB[2]
// Local ExpL3:= PARAMIXB[3]

Local _aSavArea := GetArea()
Local _aSavSC2	:= SC2->(GetArea())
// Local _cRotina	:= "MTA381GRV"

//----------------- For�a o preenchimento do campo C2_BATCH para n�o excluir a OP quando o empenho for inclu�do manualmente.
dbSelectArea("SC2")
dbSetOrder(1)
If SC2->(dbSeek(xFilial("SC2")+SD4->D4_OP))
	RecLock("SC2",.F.)
	SC2->C2_BATCH := "S"
	SC2->(MsUnLock())
Endif

RestArea(_aSavSC2)
RestArea(_aSavArea)


/*IF L381ALT .And. IsOrdSep(SD4->D4_OP) .and. !Upper(GetEnvServer()) $ 'PROZYN_HM.MELIORAPP'
   Aviso("Aten��o","As ordens de separa��o ser�o ajustadas em caso de altera��o do empenho.",{"Ok"},2)
   MsgRun( "Aguarde...",, { || U_PZCVACD1(SD4->D4_OP) } )
Endif*/

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �IsOrdSep		�Autor  �Microsiga	     � Data �  17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se existe ordem de separa��o						  ���
���          �												              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
// Static Function IsOrdSep(cOp)

// 	Local aArea		:= GetArea()
// 	Local lRet		:= .F.
// 	Local cQuery	:= ""
// 	Local cArqTmp	:= GetNextAlias()

// 	Default cOp := ""

// 	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("CB7")+" CB7 "+CRLF
// 	cQuery	+= " 	WHERE CB7.CB7_FILIAL = '"+xFilial("CB7")+"' " +CRLF
// 	cQuery	+= " 	AND CB7.CB7_OP = '"+cOp+"' "+CRLF
// 	cQuery	+= " 	AND CB7.D_E_L_E_T_ = ' ' "+CRLF

// 	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

// 	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR>0
// 		lRet	:= .T.
// 	EndIf

// 	If Select(cArqTmp) > 0
// 		(cArqTmp)->(DbCloseArea())
// 	EndIf

// 	RestArea(aArea)
// Return lRet
