#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT300GRA  �Autor  �Opvs (David)        � Data �  23/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FT300GRA()
//Local nOpcPE	:= paramixb[1]
Local aAliasExc	:= {'SU2','SZE'}
Local cAliasExc	:= ""
Local cSql 		:= ""
Local nI		:= 0

Local oModel := PARAMIXB[1]
Local oMdlAD1 := oModel:GetModel("AD1MASTER")
Local nOperation := oModel:GetOperation()

If nOperation == 3 

	For nI := 1 to Len(aAliasExc)
		cAliasExc	:= aAliasExc[nI]	
	
		cSql := " SELECT "
		cSql += "	R_E_C_N_O_ RECEXC "
		cSql += "FROM  "
		cSql += RetSqlName(cAliasExc)
		cSql += " WHERE "
		If cAliasExc = "SU2"
			cSql += "	U2_FILIAL = '"+xFilial(cAliasExc)+"' AND "
			cSql += "	U2_CODOPOR = '"+M->AD1_NROPOR+"' AND "
		ElseIf cAliasExc = "SZE" 
			cSql += "	ZE_FILIAL = '"+xFilial(cAliasExc)+"' AND "
			cSql += "	ZE_NROPOR = '"+M->AD1_NROPOR+"' AND "		
		EndIf
		cSql += "	D_E_L_E_T_ = ' ' "
		
		If select("TMPEXC") > 0
			TMPEXC->(DbCloseArea())				
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPEXC",.F.,.T.)					
		
		While !TMPEXC->(EoF())
			
			(cAliasExc)->(DbGoTo(TMPEXC->RECEXC))
			
			RecLock(cAliasExc,.f.)
			(cAliasExc)->(DbDelete())
			(cAliasExc)->(MsUnlock())
			
			TMPEXC->(DbSkip())				
		Enddo
		
	Next
Else
	cSql := " SELECT "
	cSql += "	SUM(ZE_VALOR) VLR_EXP "
	cSql += "FROM  "
	cSql += RetSqlName("SZE")
	cSql += " WHERE "
	cSql += "	ZE_FILIAL = '"+xFilial("SZE")+"' AND "
	cSql += "	ZE_NROPOR = '"+M->AD1_NROPOR+"' AND "		
	cSql += "	D_E_L_E_T_ = ' ' "
		
	If select("TMPSZE") > 0
		TMPSZE->(DbCloseArea())				
	EndIf
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPSZE",.F.,.T.)
	
	TcSetField("TMPSZE","VLR_EXP","N",15,2)
	
	If TMPSZE->VLR_EXP <> M->AD1_VERBA
		MsgAlert("Valor de Verba Informado Difere da Expectativa Mensal!")  	
	EndIf
	
EndIf

Return