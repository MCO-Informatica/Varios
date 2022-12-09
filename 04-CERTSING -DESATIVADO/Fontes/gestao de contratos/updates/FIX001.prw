// Bibliotecas necessárias
#Include "TOTVS.ch"

// Namespaces para organização
// NAMESPACE hotfix
// USING NAMESPACE utils

/*/{Protheus.doc} FIX001
	FIX para alteração do campo CN9_MEDACU com base na soma
	das medições do contrato contidas na tabela CND
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
/*/
User Function FIX001() As Variant
	Local oGCT    := NIL As Object    // Objeto de análise
	Local cKey    := ""  As Character // Chave de busca da CN9
	Local cTmpTbl := ""  As Character // Alias da tabela temporária
	Local cFixTbl := ""  As Character // Alias da tabela de logs
	Local nCNDTot := 0   As Numeric   // Acumulado de medições (CND)
	Local aArea   := {}  As Array     // Área de trabalho atual

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

			// Captura o valor total de medições
			oGCT := GCTAnalysis():New(CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA)
			nCNDTot := oGCT:GetCNDTotal()

			// Se os valores forem diferntes, grava no vetor de diferenças
			If (nCNDTot != CN9->CN9_MEDACU)
				// Inícia transação para integridade e
				// armazena a área de trabalho anterior
				BEGIN TRANSACTION
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
						HF_CN9MED := CN9->CN9_MEDACU
						HF_CNDMED := nCNDTot
					MsUnlock()

					// Altera os valores da CN9
					DBSelectArea("CN9")
					RecLock("CN9", .F.)
						CN9_MEDACU := nCNDTot
					MsUnlock()

					// Restaura a área de trabalho anterior e
					// fecha a transação
					RestArea(aArea)
				END TRANSACTION
			EndIf

			// Limpa o objeto e avança o registro
			FreeObj(oGCT)
			DBSkip()
		End

	// Limpa o vetor e encerra o ambiente
	FwFreeArray(aArea)
	RPCClearEnv()
Return (NIL)

/*/{Protheus.doc} FixTableDef
	Cria tabela de logs para armazenar as alterações do FIX001
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@return Character, Alias da tabela de logs
/*/
Static Function FixTableDef() As Character
	Local cTable  := "HFIX001"  As Character // Nome da tabela
	Local cIndex  := ""         As Character // Nome do índice
	Local aStruct := {}         As Array     // Estrutura da tabela

	// Monta a estrutura da tabela
	AAdd(aStruct, {"HF_DATA",   "D", 8,                                       0})
	AAdd(aStruct, {"HF_HORA",   "C", 8,                                       0})
	AAdd(aStruct, {"HF_FILCTR", "C", GetSX3Cache("CN9_FILIAL", "X3_TAMANHO"), 0})
	AAdd(aStruct, {"HF_CONTRA", "C", GetSX3Cache("CN9_NUMERO", "X3_TAMANHO"), 0})
	AAdd(aStruct, {"HF_REVISA", "C", GetSX3Cache("CN9_REVISA", "X3_TAMANHO"), 0})
	AAdd(aStruct, {"HF_CRECNO", "N", 10,                                      0})
	AAdd(aStruct, {"HF_CN9MED", "N", GetSX3Cache("CN9_VLATU", "X3_TAMANHO"), GetSX3Cache("CN9_VLATU", "X3_DECIMAL")})
	AAdd(aStruct, {"HF_CNDMED", "N", GetSX3Cache("CN9_VLATU", "X3_TAMANHO"), GetSX3Cache("CN9_VLATU", "X3_DECIMAL")})

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

