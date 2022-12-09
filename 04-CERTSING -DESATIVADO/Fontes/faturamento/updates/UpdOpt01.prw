#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Colors.ch"
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'
#include "FileIO.ch"

user function UpdOpt01()
	
	Local cQuery  := ""
	Local cTmp    := GetNextAlias()
	Local cCodCon := ""
	
	//-- Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'FAT' TABLES 'AD1', 'AD9', 'AC8', 'SU5', 'SA1'
	
	Conout("[UPDOPT01] Iniciando processo de atualização...")
	Conout("[UPDOPT01] Criando query...")
	cQuery := " SELECT AD1_NROPOR, "
	cQuery += "        AD1_CNPJ, "
	cQuery += "        AD1_CODCLI, "
	cQuery += "        AD1_LOJCLI, "
	cQuery += "        AD1_PROSPE, "
	cQuery += "        AD1_LOJPRO "
	cQuery += " FROM   AD1010 ad1 "
	cQuery += "        INNER JOIN SA1010 sa1 "
	cQuery += "                ON AD1_CNPJ = A1_CGC "
	cQuery += " WHERE  AD1_CNPJ <> ' ' "
	cQuery += "        AND AD1_CODCLI = ' ' "
	cQuery += "        AND ad1.D_E_L_E_T_ = ' ' "
	cQuery += "        AND sa1.D_E_L_E_T_ = ' ' "
	
	Conout("[UPDOPT01] Montando tabela temporária...")
	//-- Verifica se a tabela esta aberta.
	If Select(cTmp) > 0
		(cTmp)->(DbCloseArea())				
	EndIf
	
	//-- Execucao da query.
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
	
	dbSelectArea("SU5")
	dbSetOrder(9)
	If dbSeek(xFilial("SU5")+"padrao@padrao.com.br")
		cCodCon := SU5->U5_CODCONT
	Else
		Conout("[UPDOPT01] Criando contato padrao...")
		cCodCon := GETSX8NUM('SU5','U5_CODCONT')
		//-- Cadastro de Contato.
		RecLock("SU5",.T.)
			SU5->U5_CODCONT := cCodCon					//-- Codigo.
			SU5->U5_CONTAT  := "CONTATO PADRAO"			//-- Nome.
			SU5->U5_DDD     := "99"						//-- DDD.
			SU5->U5_FCOM1   := "99999999"				//-- Telefone.
			SU5->U5_EMAIL   := "padrao@padrao.com.br"	//-- E-mail.
			SU5->U5_TIPOCON := "1"						//-- Tipo Contato.
		SU5->(MsUnLock())
		SU5->(ConfirmSX8())
	EndIf
	
	dbSelectArea("SA1")
	dbSetOrder(3)
	
	dbSelectArea("AD1")
	dbSetOrder(1)
	
	Conout("[UPDOPT01] Processando atualização...")
	While (cTmp)->(!Eof())
		
		If SA1->(dbSeek( xFilial("SA1") + (cTmp)->AD1_CNPJ ))
			If AD1->(dbSeek( xFilial("AD1") + (cTmp)->AD1_NROPOR ))
				Conout("[UPDOPT01] Alterando Oportunidade: " + (cTmp)->AD1_NROPOR)
				RecLock("AD1", .F.)
					AD1->AD1_PROSPE := ""
					AD1->AD1_LOJPRO := ""
					AD1->AD1_CODCLI := SA1->A1_COD
					AD1->AD1_LOJCLI := SA1->A1_LOJA
				AD1->(MsUnLock())
				
				
				If .Not. AC8->( dbSeek( xFilial("AC8") + cCodCon + "SA1" + xFilial("SZ3") + SA1->A1_COD + SA1->A1_LOJA ))
					Conout("[UPDOPT01] Incluindo AC8 " + SA1->A1_COD + SA1->A1_LOJA + " | " + cCodCon)
					RecLock("AC8",.T.)
						AC8->AC8_FILIAL := xFilial("AC8") 
						AC8->AC8_FILENT := xFilial("SZ3")
						AC8->AC8_ENTIDA := "SA1"
						AC8->AC8_CODENT := SA1->A1_COD + SA1->A1_LOJA
						AC8->AC8_CODCON := cCodCon
					AC8->(MsUnLock())
				EndIf
					
				dbSelectArea("AD9")
				dbSetOrder(1)
				If .Not. AD9->(dbSeek(xFilial("AD9")+(cTmp)->AD1_NROPOR))
					Conout("[UPDOPT01] Incluindo contato na oportunidade: " + (cTmp)->AD1_NROPOR)
					RecLock("AD9",.T.)
						AD9->AD9_FILIAL := xFilial("AD9") 
						AD9->AD9_NROPOR := (cTmp)->AD1_NROPOR
						AD9->AD9_REVISA := "01"
						AD9->AD9_HISTOR := "2"
						AD9->AD9_CODCON := cCodCon
					AD9->(MsUnLock())
				Else
					Conout("[UPDOPT01] Alterando contato na oportunidade: " + (cTmp)->AD1_NROPOR)
					RecLock("AD9",.F.)
						AD9->AD9_CODCON := cCodCon
					AD9->(MsUnLock())
				EndIf	
			EndIf
		Else
			Conout("*************************************")
			(cTmp)->(dbSkip())
			Loop
		EndIf
		Conout("*************************************")
		(cTmp)->(dbSkip())
		
	EndDo

	Conout("[UPDOPT01] Atualização finalizada com sucesso...")
	
	RESET ENVIRONMENT
	
return