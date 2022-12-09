#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MntCnab   �Autor  �Darcio R. Sporl     � Data �  08/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte criado para no retorno do Cnab, o sistema procurar o  ���
���          �titulo provisorio gerado pela venda no site, pegar as infor ���
���          �macoes do mesmo, exclui-lo gerar o faturamento do pedido,   ���
���          �para que seja gerado o novo titulo conforme faturamento,    ���
���          �e baixado o mesmo via Cnab.                                 ���
�������������������������������������������������������������������������͹��
���Parametros� 1 - cNosso - Nosso numero                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MntCnab(cNosso)
Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSF2	:= SF2->(GetArea())
Local cQRYTRB	:= ""
Local cQrySC5	:= ""
Local sQrySC6	:= ""
Local cQrySF2	:= ""
Local cPrefix	:= GetNewPar("MV_XPREFHD", "VDI")
Local cNumPed	:= ""
Local cXnpSite	:= ""
Local aRetFat	:= {}
Local cGerPR	:= GetNewPar("MV_XSITEPR", "0") 
Local cAliasTrb	:= ""
Local aRet
//������������������������������������������Ŀ
//�Retorno o titulo referente ao nosso numero�
//��������������������������������������������

If cGerPR == "1" 
	cQRYTRB := "SELECT R_E_C_N_O_ RECTRB "
	cQRYTRB += "FROM " + RetSqlName("SE1") + " "
	cQRYTRB += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
	cQRYTRB += "  AND E1_NUMBCO = '" + cNosso + "' "
	cQRYTRB += "  AND E1_XNPSITE <> '" + Space(TamSX3("E1_XNPSITE")[1]) + "' "
	cQRYTRB += "  AND E1_PREFIXO = '" + cPrefix + "' "
	cQRYTRB += "  AND E1_TIPO = 'PR ' "
	cQRYTRB += "  AND D_E_L_E_T_ = ' ' "
	cAliasTrb	:= "SE1"
Else
	cQRYTRB := "SELECT R_E_C_N_O_ RECTRB "
	cQRYTRB += "FROM " + RetSqlName("SC5") + " "
	cQRYTRB	+= "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
	cQRYTRB += "  AND C5_XNPSITE = '" + cNosso + "' "
	cQRYTRB += "  AND C5_XNFHRD = ' ' "
	cQRYTRB += "  AND C5_XNFHRE = ' ' "
	cQRYTRB += "  AND D_E_L_E_T_ = ' ' "
	cAliasTrb	:= "SC5"
EndIf
	
cQRYTRB := ChangeQuery(cQRYTRB)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQRYTRB),"QRYTRB",.F.,.T.)
	
DbSelectArea("QRYTRB")
If QRYTRB->(!Eof())
	DbSelectArea(cAliasTrb)
	DbGoTo(QRYTRB->RECTRB)
	
	If cGerPR == "1"
		//�����������������������������������������4�
		//�Pego o numero do pedido criado pelo site�
		//�����������������������������������������4�
		cXnpSite := SE1->E1_XNPSITE
		
		//�������������������������������������������������������������������������������������`�
		//�Pego o recno do pedido feito pelo site, para pegar as informacoes do pedido protheus�
		//�������������������������������������������������������������������������������������`�
		cQrySC5 := "SELECT R_E_C_N_O_ RECPED "
		cQrySC5 += "FROM " + RetSqlName("SC5") + " "
		cQrySC5	+= "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
		cQrySC5 += "  AND C5_XNPSITE = '" + cXnpSite + "' "
		cQrySC5 += "  AND D_E_L_E_T_ = ' ' "
	
		cQrySC5 := ChangeQuery(cQrySC5)
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.)
		DbSelectArea("QRYSC5")
	
		If QRYSC5->(!Eof())
			DbSelectArea("SC5")
			DbGoTo(QRYSC5->RECPED)
			
			cNumPed := SC5->C5_NUM	
		EndIf
		DbSelectArea("QRYSC5")
		QRYSC5->(DbCloseArea())

	Else
		cXnpSite 	:= SC5->C5_XNPSITE
		cNumPed 	:= SC5->C5_NUM	
	EndIf
	
	aRetFat	:= U_GERFAT(cNumPed, Val(cXnpSite))
	 
	If aRetFat[1]
	
		aRet := {}
		Aadd( aRet, aRetFat[1])
		Aadd( aRet, "M00001" )
		Aadd( aRet, cXNPSite )
		Aadd( aRet, "" )

		U_GTPutOUT(cXnpSite,"N",cXnpSite,{"GERA��O CNAB",{"N",aRet},"Faturamento realizado com sucesso"})

		If cGerPR == "1"
			//�������������������������������������������������Ŀ
			//�Garanto que esta posicionado no titulo provisorio�
			//���������������������������������������������������
			DbSelectArea("SE1")
			DbGoTo(QRYTRB->RECTRB)
	
			//��������������������������Ŀ
			//�Excluo o titulo provisorio�
			//����������������������������
			RecLock("SE1", .F.)
				SE1->(DbDelete())
			SE1->(MsUnLock())
        EndIf
		//�������������������������������������������������������������������������Ŀ
		//�Posiciono no item de faturamento, para pegar o numero da nota e sua serie�
		//���������������������������������������������������������������������������
		cQrySC6 := "SELECT C6_NOTA, C6_SERIE "
		cQrySC6 += "FROM " + RetSqlName("SC6") + " "
		cQrySC6 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
		cQrySC6 += "  AND C6_NUM = '" + cNumPed + "' "
		cQrySC6 += "  AND C6_XOPER = '52'
		cQrySC6 += "  AND D_E_L_E_T_ = ' '

		cQrySC6 := ChangeQuery(cQrySC6)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC6),"QRYSC6",.F.,.T.)
		
		DbSelectArea("QRYSC6")
		QRYSC6->(DbGoTop())
				
		If QRYSC6->(!Eof())

			//��������������������������������������������������������������������������������������Ŀ
			//�Posiciono na nota e serie, para pegar o numero do titulo que foi gerado no faturamento�
			//����������������������������������������������������������������������������������������
			cQrySF2 := "SELECT F2_PREFIXO, F2_DUPL "
			cQrySF2 += "FROM " + RetSqlName("SF2") + " "
			cQrySF2 += "WHERE F2_FILIAL = '" + xFilial("SF2") + "' "
			cQrySF2 += "  AND F2_DOC = '" + QRYSC6->C6_NOTA + "' "
			cQrySF2 += "  AND F2_SERIE = '" + QRYSC6->C6_SERIE + "' "
			cQrySF2 += "  AND D_E_L_E_T_ = ' ' "

			cQrySF2 := ChangeQuery(cQrySF2)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySF2),"QRYSF2",.F.,.T.)
			
			DbSelectArea("QRYSF2")
			QRYSF2->(DbGoTop())
			
			If QRYSF2->(!Eof())
			
				//������������������������������������������������������������������������������������������������������������������Ŀ
				//�Posiciono no novo titulo gerado pelo faturamento, e gavo nele o nosso numero e o numero do pedido gerado pelo site�
				//��������������������������������������������������������������������������������������������������������������������
				DbSelectArea("SE1")
				DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				If MsSeek(xFilial("SE1") + QRYSF2->F2_PREFIXO + QRYSF2->F2_DUPL)
					RecLock("SE1", .F.)
						Replace SE1->E1_NUMBCO	With cNosso
						Replace SE1->E1_XNPSITE	With cXnpSite
					SE1->(MsUnLock())
				EndIf
			EndIf
		    
			DbSelectArea("QRYSF2")
			QRYSF2->(DbCloseArea())
		EndIf	

		DbSelectArea("QRYSC6")
		QRYSC6->(DbCloseArea())
	Else          
		aRet := {}
		Aadd( aRet, .f.)
		Aadd( aRet, "E00001" )
		Aadd( aRet, cXNPSite )
		Aadd( aRet, "" )
	
		U_GTPutOUT(cXnpSite,"N",cXnpSite,{"GERA��O CNAB",{"N",aRet},"Falha ao tentar gerar o faturamento - " + aRetFat[2]})   
		
	EndIf
	

EndIf

DbSelectArea("QRYTRB")
QRYTRB->(DbCloseArea())

RestArea(aArea)
RestArea(aAreaSE1)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSF2)
Return