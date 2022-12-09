// Bibliotecas necessárias
#Include "TOTVS.ch"

// Namespaces para organização
// NAMESPACE hotfix
// USING NAMESPACE utils

/*/{Protheus.doc} FIX002
	FIX para alteração do campo CN9_SALDO e CN9_VLATU com base na
	soma das medições contidas no campo CN9_MEDACU em contratos
	sem previsão financeira definida
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 22/07/2021
/*/
User Function FIX002() As Variant
	Local oGCT      := NIL As Object    // Objeto de análise
	Local cKey      := ""  As Character // Chave de busca da CN9
	Local cTmpTbl   := ""  As Character // Alias da tabela temporária
	Local cFixTbl   := ""  As Character // Alias da tabela de logs
	Local lFlexivel := .F. As Logical   // Flag para contratos flexíveis
	Local lPrevMed  := .F. As Logical   // Flag para contrato com previsão financeira
	Local aArea     := {}  As Array     // Área de trabalho atual

	// FIX para alteração do campo CN9_MEDACU com base na soma
	// das medições do contrato contidas na tabela CND
	// Obs: Necessário para uso correto dos valores no FIX002
	// U_FIX001()

	// Abertura de ambiente sem interface gráfica e consumo de licença
	RPCSetType(3)
	RPCSetEnv("01", "01")
		// Cria/abre a tabela de logs
		cFixTbl := FixTableDef()

		// Captura a listagem de contratos da base
		oGCT := GCTAnalysis():New()
		cTmpTbl := oGCT:GetAllContracts()
		FreeObj(oGCT)

		// Posiciona no arquivo e move para o início
		DBSelectArea(cTmpTbl)
		DBGoTop()

		// Percorre todos os contratos da base
		While (!EOF())
			// Posiciona no contrato
			cKey := CN9FILIAL + CN9NUMERO + CnUltRev(CN9NUMERO, CN9FILIAL)
			DBSelectArea(cTmpTbl)
			CN9->(DBSeek(cKey))

			// Verifica se o contrato é flexível e se tem previsão financeira
			lFlexivel := !CN300RetSt("FIXO",       2, NIL, CN9->CN9_NUMERO, CN9->CN9_FILCTR, .F.)
			lPrevMed  :=  CN300RetSt("PREVFINANC", 2, NIL, CN9->CN9_NUMERO, CN9->CN9_FILCTR, .F.)

			// Se o contrato for flexível e NÃO tiver previsão financeira, inicia a alteração
			If (lFlexivel .And. !lPrevMed .And. (CN9->CN9_VLATU != CN9->CN9_MEDACU .Or. CN9->CN9_SALDO > 0))
				// Inícia transação para integridade
				BEGIN TRANSACTION
					// Armazena a área anterior
					aArea := GetArea()

					// Grava os valores na tabela de logs
					DBSelectArea(cFixTbl)
					RecLock(cFixTbl, .T.)
						HF_DATA   := dDatabase
						HF_HORA   := Time()
						HF_FILCTR := CN9->CN9_FILIAL
						HF_CONTRA := CN9->CN9_NUMERO
						HF_REVISA := CN9->CN9_REVISA
						HF_CRECNO := CN9->(RecNo())
						HF_OLDATU := CN9->CN9_VLATU
						HF_NEWATU := CN9->CN9_MEDACU
						HF_OLDINI := CN9->CN9_VLINI
						HF_NEWINI := CN9->CN9_VLINI
						HF_OLDSLD := CN9->CN9_SALDO
						HF_NEWSLD := 0
					MsUnlock()

					// Altera os valores da CN9
					// Caso o contrato NÃO tenha previsão financeira, o saldo será zero
					// e o valor atual será igual ao total de medições
					DBSelectArea("CN9")
					RecLock("CN9", .F.)
						CN9_VLATU := CN9_MEDACU
						CN9_SALDO := 0
					MsUnlock()
				END TRANSACTION

				// Restaura a área de trabalho anterior
				RestArea(aArea)
			EndIf

			// Se o contrato for flexível e tiver previsão financeira, inicia a alteração
			If (lFlexivel .And. lPrevMed .And. CN9->CN9_SALDO != CN9->CN9_VLATU - CN9->CN9_MEDACU)
				// Inícia transação para integridade
				BEGIN TRANSACTION
					// Armazena a área anterior
					aArea := GetArea()

					// Grava os valores na tabela de logs
					DBSelectArea(cFixTbl)
					RecLock(cFixTbl, .T.)
						HF_DATA   := dDatabase
						HF_HORA   := Time()
						HF_FILCTR := CN9->CN9_FILIAL
						HF_CONTRA := CN9->CN9_NUMERO
						HF_REVISA := CN9->CN9_REVISA
						HF_CRECNO := CN9->(RecNo())
						HF_OLDATU := CN9->CN9_VLATU
						HF_NEWATU := CN9->CN9_VLATU
						HF_OLDINI := CN9->CN9_VLINI
						HF_NEWINI := CN9->CN9_VLINI
						HF_OLDSLD := CN9->CN9_SALDO
						HF_NEWSLD := CN9->CN9_VLATU - CN9->CN9_MEDACU
					MsUnlock()

					// Altera os valores da CN9
					// Caso o contrato NÃO tenha previsão financeira, o saldo será zero
					// e o valor atual será igual ao total de medições
					DBSelectArea("CN9")
					RecLock("CN9", .F.)
						CN9_SALDO := CN9_VLATU - CN9_MEDACU
					MsUnlock()
				END TRANSACTION

				// Restaura a área de trabalho anterior
				RestArea(aArea)
			EndIf

			// Avança para o próximo registro
			DBSkip()
		End

		// Limpa o vetor e encerra o ambiente
		FwFreeArray(aArea)
	RPCClearEnv()
Return (NIL)

/*/{Protheus.doc} FixTableDef
	Cria tabela de logs para armazenar as alterações do FIX002
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 22/07/2021
	@return Character, Alias da tabela de logs
/*/
Static Function FixTableDef() As Character
	Local cTable  := "HFIX002" As Character // Nome da tabela
	Local cIndex  := ""        As Character // Nome do índice
	Local aStruct := {}        As Array     // Estrutura da tabela

	// Monta a estrutura da tabela
	AAdd(aStruct, {"HF_DATA",   "D", 8,                                       0})
	AAdd(aStruct, {"HF_HORA",   "C", 8,                                       0})
	AAdd(aStruct, {"HF_FILCTR", "C", GetSX3Cache("CN9_FILIAL", "X3_TAMANHO"), 0})
	AAdd(aStruct, {"HF_CONTRA", "C", GetSX3Cache("CN9_NUMERO", "X3_TAMANHO"), 0})
	AAdd(aStruct, {"HF_REVISA", "C", GetSX3Cache("CN9_REVISA", "X3_TAMANHO"), 0})
	AAdd(aStruct, {"HF_CRECNO", "N", 10,                                      0})
	AAdd(aStruct, {"HF_OLDATU", "N", GetSX3Cache("CN9_VLATU", "X3_TAMANHO"),  GetSX3Cache("CN9_VLATU", "X3_DECIMAL")})
	AAdd(aStruct, {"HF_NEWATU", "N", GetSX3Cache("CN9_VLATU", "X3_TAMANHO"),  GetSX3Cache("CN9_VLATU", "X3_DECIMAL")})
	AAdd(aStruct, {"HF_OLDINI", "N", GetSX3Cache("CN9_VLINI", "X3_TAMANHO"),  GetSX3Cache("CN9_VLINI", "X3_DECIMAL")})
	AAdd(aStruct, {"HF_NEWINI", "N", GetSX3Cache("CN9_VLINI", "X3_TAMANHO"),  GetSX3Cache("CN9_VLINI", "X3_DECIMAL")})
	AAdd(aStruct, {"HF_OLDSLD", "N", GetSX3Cache("CN9_SALDO", "X3_TAMANHO"),  GetSX3Cache("CN9_SALDO", "X3_DECIMAL")})
	AAdd(aStruct, {"HF_NEWSLD", "N", GetSX3Cache("CN9_SALDO", "X3_TAMANHO"),  GetSX3Cache("CN9_SALDO", "X3_DECIMAL")})

	// Cria a tabela caso ela não exita
	If (!TCCanOpen(cTable))
		DBCreate(cTable, aStruct, "TOPCONN")
	EndIF

	// Abre a tabela
	DBUseArea(.F., "TOPCONN", cTable, cTable, .F., .F.)
	DBSelectArea(cTable)

	// Cria o índice único caso ele não exista
	cIndex := cTable + "A"
	If (!TCCanOpen(cTable, cIndex))
		cKey := "DTOS(HF_DATA)+HF_HORA+HF_FILCTR+HF_CONTRA+HF_REVISA"
		DBCreateIndex(cIndex, cKey, {||cKey})
	EndIf

	// Define o índice atual
	DBSetIndex(cIndex)

	// Remove o vetor da memória
	FwFreeArray(aStruct)
Return (cTable)
