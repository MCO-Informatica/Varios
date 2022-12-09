#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP508     �Autor  �Junior Carvalho     � Data �  21/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LP508(cTipo,cCPF)

Local aArea  := " "
Local cRet := " "
Local cAliasSRA := " "
IF !ALLTRIM(SA2->A2_COD) $ ('PIS|TAXA|UNIAO')
	IF !Empty( cCPF )
		cAliasSRA := GetNextAlias()
		aArea  := GetArea()
		BeginSql Alias cAliasSRA
			SELECT RA_CC,RA_ITEM
			FROM %Table:SRA%
			WHERE
			RA_CIC = %Exp:cCPF%
			AND RA_DEMISSA = ' '
			AND D_E_L_E_T_ <> '*'
		EndSql
		//aQuery := GetLastQuery()
		IF cTipo == 'CC'
			cRet  := (cAliasSRA)->RA_CC
		ELSEIF cTipo == "IC"
			cRet  := (cAliasSRA)->RA_ITEM
		ENDIF
		
		IF Select(cAliasSRA) > 0
			(cAliasSRA)->( dbCloseArea() )
		ENDIF
		
		RestArea(aArea)
	ELSE
		Alert("Fornecedor"+SA2->A2_NOME+"Sem CPF Cadastrado.")
	ENDIF
ENDIF

RETURN(cRet)
