#Include 'Protheus.ch'
#Include 'Topconn.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 15:49:58
* @description: Função para incluir todos os dados da tabela 44 do SX5 na tabela ZRM. 
*/ 
User Function SHPCP003()

	local aDadosX5 := {}
	local nADadosX5:= 0
	
	aDadosX5 := dadosSX5()
	
	nADadosX5 := len(aDadosX5)
	
	DbSelectArea("ZRM")
	ZRM->(DbSetOrder())
	for nI:=1 to nADadosX5
		if !ZRM->(DbSeek(xFilial("ZRM")+padr(aDadosX5[nI][1],tamSX3("ZRM_CHAVE")[1])))
			if RecLock("ZRM",.T.)
				ZRM->ZRM_FILIAL := xFilial("ZRM") 
				ZRM->ZRM_CHAVE	:= aDadosX5[nI][1]
				ZRM->ZRM_DESCRI	:= aDadosX5[nI][2]
										
				ZRM->(MSUnlock())
			endIf	
		endIf
	next nI
	 
Return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 15:51:08
* @description: Consulta à tabela SX5. 
*/ 
static function dadosSX5()

	local cQuery := ""
	local aRet	 := {}
	
	cQuery := "SELECT X5_CHAVE,X5_DESCRI FROM "+retSqlTab("SX5") + CRLF
	cQuery += " WHERE	X5_FILIAL = '"+xFilial("SX5")+"'"+CRLF
	cQuery += "	AND		SX5.D_E_L_E_T_	= ' '"+CRLF
	cQuery += "	AND		X5_TABELA	= '44'"
	
	TCQUERY cQuery NEW ALIAS ZZZ
	
	DbSelectArea("ZZZ")
	
	ZZZ->(DbGoTop())
	
	while !ZZZ->(Eof())
		aadd(aRet,{allTrim(ZZZ->X5_CHAVE),allTrim(ZZZ->X5_DESCRI)})
		
		ZZZ->(DbSkip())
	end
	
	ZZZ->(DbCloseArea())
	
return aRet

