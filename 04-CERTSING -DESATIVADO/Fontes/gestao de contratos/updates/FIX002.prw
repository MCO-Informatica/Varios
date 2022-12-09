// Bibliotecas necess�rias
#Include "TOTVS.ch"

// Namespaces para organiza��o
// NAMESPACE hotfix
// USING NAMESPACE utils

/*/{Protheus.doc} FIX002
	FIX para altera��o do campo CN9_SALDO e CN9_VLATU com base na
	soma das medi��es contidas no campo CN9_MEDACU em contratos
	sem previs�o financeira definida
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 22/07/2021
/*/
User Function FIX002() As Variant
	Local oGCT      := NIL As Object    // Objeto de an�lise
	Local cKey      := ""  As Character // Chave de busca da CN9
	Local cTmpTbl   := ""  As Character // Alias da tabela tempor�ria
	Local cFixTbl   := ""  As Character // Alias da tabela de logs
	Local lFlexivel := .F. As Logical   // Flag para contratos flex�veis
	Local lPrevMed  := .F. As Logical   // Flag para contrato com previs�o financeira
	Local aArea     := {}  As Array     // �rea de trabalho atual

	// FIX para altera��o do campo CN9_MEDACU com base na soma
	// das medi��es do contrato contidas na tabela CND
	// Obs: Necess�rio para uso correto dos valores no FIX002
	// U_FIX001()

	// Abertura de ambiente sem interface gr�fica e consumo de licen�a
	RPCSetType(3)
	RPCSetEnv("01", "01")
		// Cria/abre a tabela de logs
		cFixTbl := FixTableDef()

		// Captura a listagem de contratos da base
		oGCT := GCTAnalysis():New()
		cTmpTbl := oGCT:GetAllContracts()
		FreeObj(oGCT)

		// Posiciona no arquivo e move para o in�cio
		DBSelectArea(cTmpTbl)
		DBGoTop()

		// Percorre todos os contratos da base
		While (!EOF())
			// Posiciona no contrato
			cKey := CN9FILIAL + CN9NUMERO + CnUltRev(CN9NUMERO, CN9FILIAL)
			DBSelectArea(cTmpTbl)
			CN9->(DBSeek(cKey))

			// Verifica se o contrato � flex�vel e se tem previs�o financeira
			lFlexivel := !CN300RetSt("FIXO",       2, NIL, CN9->CN9_NUMERO, CN9->CN9_FILCTR, .F.)
			lPrevMed  :=  CN300RetSt("PREVFINANC", 2, NIL, CN9->CN9_NUMERO, CN9->CN9_FILCTR, .F.)

			// Se o contrato for flex�vel e N�O tiver previs�o financeira, inicia a altera��o
			If (lFlexivel .And. !lPrevMed .And. (CN9->CN9_VLATU != CN9->CN9_MEDACU .Or. CN9->CN9_SALDO > 0))
				// In�cia transa��o para integridade
				BEGIN TRANSACTION
					// Armazena a �rea anterior
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
					// Caso o contrato N�O tenha previs�o financeira, o saldo ser� zero
					// e o valor atual ser� igual ao total de medi��es
					DBSelectArea("CN9")
					RecLock("CN9", .F.)
						CN9_VLATU := CN9_MEDACU
						CN9_SALDO := 0
					MsUnlock()
				END TRANSACTION

				// Restaura a �rea de trabalho anterior
				RestArea(aArea)
			EndIf

			// Se o contrato for flex�vel e tiver previs�o financeira, inicia a altera��o
			If (lFlexivel .And. lPrevMed .And. CN9->CN9_SALDO != CN9->CN9_VLATU - CN9->CN9_MEDACU)
				// In�cia transa��o para integridade
				BEGIN TRANSACTION
					// Armazena a �rea anterior
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
					// Caso o contrato N�O tenha previs�o financeira, o saldo ser� zero
					// e o valor atual ser� igual ao total de medi��es
					DBSelectArea("CN9")
					RecLock("CN9", .F.)
						CN9_SALDO := CN9_VLATU - CN9_MEDACU
					MsUnlock()
				END TRANSACTION

				// Restaura a �rea de trabalho anterior
				RestArea(aArea)
			EndIf

			// Avan�a para o pr�ximo registro
			DBSkip()
		End

		// Limpa o vetor e encerra o ambiente
		FwFreeArray(aArea)
	RPCClearEnv()
Return (NIL)

/*/{Protheus.doc} FixTableDef
	Cria tabela de logs para armazenar as altera��es do FIX002
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 22/07/2021
	@return Character, Alias da tabela de logs
/*/
Static Function FixTableDef() As Character
	Local cTable  := "HFIX002" As Character // Nome da tabela
	Local cIndex  := ""        As Character // Nome do �ndice
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

	// Cria a tabela caso ela n�o exita
	If (!TCCanOpen(cTable))
		DBCreate(cTable, aStruct, "TOPCONN")
	EndIF

	// Abre a tabela
	DBUseArea(.F., "TOPCONN", cTable, cTable, .F., .F.)
	DBSelectArea(cTable)

	// Cria o �ndice �nico caso ele n�o exista
	cIndex := cTable + "A"
	If (!TCCanOpen(cTable, cIndex))
		cKey := "DTOS(HF_DATA)+HF_HORA+HF_FILCTR+HF_CONTRA+HF_REVISA"
		DBCreateIndex(cIndex, cKey, {||cKey})
	EndIf

	// Define o �ndice atual
	DBSetIndex(cIndex)

	// Remove o vetor da mem�ria
	FwFreeArray(aStruct)
Return (cTable)
