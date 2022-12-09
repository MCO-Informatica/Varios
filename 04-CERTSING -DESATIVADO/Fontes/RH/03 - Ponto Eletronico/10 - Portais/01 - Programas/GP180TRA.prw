#Include "Protheus.ch"

//+-------------+----------+-------+-----------------------+------+--------------+
//|Programa:    |GP180TRA  |Autor: |Bruno Nunes            |Data: |12/07/2016    |
//|-------------+----------+-------+-----------------------+------+--------------|
//|Descricao:   |Ponto de Entrada executado logo após a atualização dos dados da |
//|             |tabela Cadastro de Funcionários (SRA).                          | 
//|             |A tabela fica posicionada no funcionário que foi transferido, e |
//|             |as informações atualizadas ficam disponíveis e podem ser        | 
//|             |utilizadas em outros módulos do sistema ou rotinas específicas. |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
User Function GP180TRA()
	
	Local cQuery     := ''				//-> Consulta SQL
	Local cAlias     := GetNextAlias()	//-> Alias resevardo para consulta SQL
	Local nRec       := 0				//-> Numero Total de Registros da consulta SQL
	Local lExeChange := .T.
	Local aPergs     := {}
	Local cLocTrab   := Space(6)
	Local aRetPBox   := {}
	
	/*+-------------------------------------------------------------------------+
	  | Verifica se o colaborador possui alguma aprovação de ponto pendente.    |
	  | Caso haja, todas as aprovações serão estornadas para que o colabora as  | 
	  | submeta ao novo grupo de aprovações.                                    |
	  | Um e-mail será enviado ao colaborador.                                  |
	  +-------------------------------------------------------------------------+
	*/
	
	
	
	
	//-> Montagem da query.
	cQuery := " SELECT "
	cQuery += " R_E_C_N_O_  REC "
	cQuery += " FROM " + RetSQLName("PBB") + " "
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND PBB_FILMAT = '" + cFilDe + "' "
	cQuery += " AND PBB_MAT = '" + cMatDe + "' "
		
	If U_MontarSQL(cAlias, @nRec, cQuery, lExeChange)
		(cAlias)->(dbGoTop())
		While (cAlias)->(!EoF())			
			PBB->(dbGoTo((cAlias)->REC))
			If PBB->(RecNo()) == (cAlias)->(REC)
				//-> Altera dados da tabela PBB.
				RecLock('PBB',.F.)
					PBB->PBB_FILMAT := cFilAte
					PBB->PBB_MAT    := cMatAte
				MsUnLock()
			EndIf
			(cAlias)->(dbSkip())
		End
		(cAlias)->(dbCloseArea())
	EndIf
	
	//+--------------------------------------------------------------------------+
	//| Tratamento com local de trabalho no momento de realizar a transferencia. |
	//+--------------------------------------------------------------------------+
	If SQB->(FieldPos("QB_CODLT")) > 0
		//+---------------------------------------------------------------------------+
		//| Atualização do campo local de trabalho na tabela SRA utilizando Parambox. |
		//+---------------------------------------------------------------------------+
		aAdd( aPergs ,{1,"Local Trab. : ",cLocTrab,"@!",'.T.','RCC_06','.T.',6,.F.}) 
		If ParamBox(aPergs ,"Informações Adicionais", aRetPBox)
			If !Empty(aRetPBox[1])
				RecLock("SRA",.F.)
					SRA->RA_CODLT := aRetPBox[1]
				SRA->(MsUnLock())
				RecLock("SQB",.F.)
					SQB->QB_CODLT := aRetPBox[1]
				SQB->(MsUnLock())
			EndIf               
		EndIf
	EndIf

Return