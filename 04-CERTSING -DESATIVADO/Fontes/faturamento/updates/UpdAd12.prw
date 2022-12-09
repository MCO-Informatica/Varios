#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'

//+-----------------------------------------------------------------------------------------------+
//| Função para inserir dados do time de venda para oportunidades que não possuam time de vendas. |
//+-----------------------------------------------------------------------------------------------+
User Function UpdAd12()
	Local xteste := ""
	
	//-- Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'FAT' TABLES 'AD1', 'AD2', 'SA3'
		
		Processa( {|| ProcAtuAD12() }, "Aguarde...", "Atualizandos dados da AD2 com base na AD1...",.F.)
		
	RESET ENVIRONMENT
	
Return


Static Function ProcAtuAD12()

	Local cCarg  := ""
	Local cQuery := ""
	Local cTmp   := GetNextAlias()
	Local nNum   := 0
	
	//-- Montagem da query.
	cQuery := " SELECT ad1.AD1_FILIAL, "
	cQuery += "        ad1.AD1_NROPOR, "
	cQuery += "        ad1.AD1_VEND "
	cQuery += " FROM   AD1010 ad1 "
	cQuery += "        LEFT JOIN AD2010 ad2 "
	cQuery += "               ON ad1.AD1_NROPOR = ad2.AD2_NROPOR  "
	cQuery += " WHERE  ad2.AD2_NROPOR IS NULL "
	
	//-- Verifica se a tabela esta aberta.
	If Select(cTmp) > 0
		cTmp->(DbCloseArea())				
	EndIf
	
	//-- Execucao da query.
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
	(cTmp)->(DbGoTop())
	dbSelectArea("SA3")
	SA3->(dbSetOrder(1)) 
	Conout("[UPDAD12 - " + DToC(Date()) + " " + Time() + "] " + "Inciando processo de atualização para oportunidades sem time de vendas")
	While (cTmp)->(!Eof())
		cCarg := ""
		If SA3->(DbSeek(xFilial("SA3")+(cTmp)->AD1_VEND))
			
			cCarg := SA3->A3_CARGO 
			
			RecLock("AD2",.T.)
				AD2_FILIAL := (cTmp)->AD1_FILIAL
				AD2_NROPOR := (cTmp)->AD1_NROPOR
				AD2_REVISA := "01"
				AD2_HISTOR := "2"
				AD2_VEND   := (cTmp)->AD1_VEND
				AD2_PERC   := 100
				AD2_CODCAR := cCarg
			AD2->(MsUnlock())
		
		Else
		
			Conout("[UPDAD12 - " + DToC(Date()) + " " + Time() + "] Oportunidade: " + (cTmp)->AD1_NROPOR + " - Vendedor não encontrado.")
			
		EndIf
		
		(cTmp)->(DbSkip())
		
	EndDo
	
	Conout("[UPDAD12 - " + DToC(Date()) + " " + Time() + "] " + "Processo finalizado!")
	
Return