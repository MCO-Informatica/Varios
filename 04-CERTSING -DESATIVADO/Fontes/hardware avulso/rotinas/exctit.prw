#INCLUDE 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExcTit    �Autor  �Darcio R. Sporl     � Data �  04/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte criado para verificar a existencia do titulo "PR" -   ���
���          �Provisorio, e excluir o mesmo, implementacao devido a troca ���
���          �da forma de pagamento.                                      ���
�������������������������������������������������������������������������͹��
���Parametros� cNumPed  - Numero do Pedido Protheus                       ���
���Parametros� cPrefix  - Prefixo do Titulo Provisorio                    ���
���Parametros� cXNPSite - Numero do Pedido Criado pelo Site               ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ExcTit(cNumPed, cPrefix, cXNPSite, cLinDig, lExc)
Local aArea 	:= GetArea()		//Salva a area atual
Local aAreaSE1	:= SE1->(GetArea())	//Salva a area atual da tabela SE1
Local cQrySD2	:= ""
Local cQrySE1	:= ""
Local cNosso 	:= ""
Local cXNPSITE	:= ""

Default cPrefix	:= GetNewPar("MV_XPREFHD", "VDI")

If !Empty(cLinDig)
	cNosso := SubStr(cLinDig,8,2)+SubStr(cLinDig,12,5)
EndIf

//Pego o recno no titulo provisorio criado pelo site
cQrySE1 := "SELECT R_E_C_N_O_ NRECE1 "
cQrySE1 += "FROM " + RetSqlName("SE1") + " "
cQrySE1 += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
cQrySE1 += "  AND E1_PREFIXO = '" + cPrefix + "' "
cQrySE1 += "  AND E1_NUM = '" + cNumPed + "' "
cQrySE1 += "  AND E1_XNPSITE = '" + cXNPSite + "' "
cQrySE1 += "  AND E1_TIPO = 'PR ' "
cQrySE1 += "  AND D_E_L_E_T_ = ' ' "

cQrySE1 := ChangeQuery(cQrySE1)

If Select("QRYSE1") > 0
	QRYSE1->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySE1),"QRYSE1",.F.,.T.)
	
DbSelectArea("QRYSE1")
If QRYSE1->(!Eof())

	DbSelectArea("SE1")
	SE1->(DbGoto(QRYSE1->NRECE1))

	If lExc					
		//Excluo o titulo provisorio
		RecLock("SE1", .F.)
			SE1->(DbDelete())
		SE1->(MsUnLock())
	Else
		RecLock("SE1", .F.)
			Replace SE1->E1_NUMBCO With cNosso
		SE1->(MsUnLock())
	EndIf
	    
	DbSelectArea("QRYSE1")
	QRYSE1->(DbCloseArea())
EndIf

RestArea(aArea)		//Restaura a area
RestArea(aAreaSE1)	//Restaura a area da tabela SE1
Return