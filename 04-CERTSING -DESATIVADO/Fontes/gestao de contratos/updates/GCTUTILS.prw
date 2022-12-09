// Bibliotecas necessárias
#Include "TOTVS.ch"

// Namespaces para organização
// NAMESPACE utils

/*/{Protheus.doc} GCTAnalysis
	Classe de utilidades para análise de contrato
	@type Class
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
/*/
Class GCTAnalysis
	Private Data cBranch   As Character // Filial do contrato
	Private Data cContract As Character // Número do contrato
	Private Data cReview   As Character // Revisão do contrato
	Private Data aSheets   As Array     // Código das planilhas
	Public  Data aValues   As Array     // Valores do contrato

	// Método construtor
	Public Method New(cBranch, cContract, cReview) As Object

	// Demais métodos da classe
	Public Method GetCN9Total() As Numeric
	Public Method GetCNATotal() As Numeric
	Public Method GetCNBTotal() As Numeric
	Public Method GetCNDTotal() As Numeric
	Public Method GetAllContracts() As Character
	Public Method GetSheets() As Array
EndClass

/*/{Protheus.doc} GCTAnalysis::New
	Método construtor
	@type Method
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@param cBranch, Character, Filial do contrato
	@param cContract, Character, Número do contrato
	@param cReview, Character, Revisão do contrato
	@return Object, Objeto da classe GCTAnalysis
/*/
Method New(cBranch As Character, cContract As Character, cReview As Character) As Object Class GCTAnalysis
	Default cBranch   := "" // Filial do contrato
	Default cContract := "" // Número do contrato
	Default cReview   := "" // Revisão do contrato

	// Inicialização dos atributos da classe
	::cBranch   := cBranch
	::cContract := cContract
	::cReview   := cReview
	::aValues   := {}

	// Captura as planilhas se o contrato estiver preenchido
	If (!Empty(cBranch) .And. !Empty(cContract))
		::GetSheets()
	EndIf
Return (Self)

/*/{Protheus.doc} GCTAnalysis::GetCN9Total
	Captura o valor total do cabeçalho do contrato
	@type Method
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@return Numeric, Valor total do cabeçalho do contrato (CN9_VLATU)
/*/
Method GetCN9Total() As Numeric Class GCTAnalysis
	Local aArea := GetArea() As Array // Área de trabalho anterior

	// Posiciona o cabeçalho do contrato
	DBSelectArea("CN9")
	DBSetOrder(1)
	DBGoTop()
	DBSeek(::cBranch + ::cContract + ::cReview)

	// Captura o valor total do contrato
	AAdd(::aValues, {"CN9", CN9_VLATU})
	AAdd(::aValues[Len(::aValues)], {CN9_VLATU})

	// Restaura a área anterior
	RestArea(aArea)
	FwFreeArray(aArea)
Return (::aValues[Len(::aValues)][2])

/*/{Protheus.doc} GCTAnalysis::GetCNATotal
	Calcula o valor total das planilhas do contrato
	@type method
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@return Numeric, Valor total das planilhas do contrato (CNA_VLTOT)
/*/
Method GetCNATotal() As Numeric Class GCTAnalysis
	Local nAux  := 0         As Numeric // Auxiliar de soma de valores
	Local aArea := GetArea() As Array   // Área de trabalho anterior

	// Posiciona nas planilhas do contrato
	DBSelectArea("CNA")
	DBSetOrder(1)
	DBGoTop()
	DBSeek(::cBranch + ::cContract + ::cReview)

	// Captura o número e o valor total do planilha
	AAdd(::aValues, {"CNA", 0, {}})
	While (!EOF() .And. ::cBranch + ::cContract + ::cReview == CNA_FILIAL + CNA_CONTRA + CNA_REVISA)
		nAux += CNA_VLTOT
		AAdd(::aValues[Len(::aValues)][3], CNA_VLTOT)
		DBSkip()
	End
	::aValues[Len(::aValues)][2] := nAux

	// Posiciona nos itens do contrato
	DBSelectArea("CNB")
	DBSetOrder(1)
	DBGoTop()

	// Restaura a área anterior
	RestArea(aArea)
	FwFreeArray(aArea)
Return (::aValues[Len(::aValues)][2])

/*/{Protheus.doc} GCTAnalysis::GetCNBTotal
	Calcula o valor total itens do contrato
	@type method
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@return Numeric, Valor total dos itens do contrato (CNB_VLTOT)
/*/
Method GetCNBTotal() As Numeric Class GCTAnalysis
	Local nX    := 0         As Numeric // Contador do laço de planilhas
	Local nAux  := 0         As Numeric // Auxiliar de soma de valores
	Local aArea := GetArea() As Array   // Área de trabalho anterior

	// Posiciona nos itens do contrato
	DBSelectArea("CNB")
	DBSetOrder(1)
	DBGoTop()

	// Posiciona nos itens das planilhas em aSheets
	AAdd(::aValues, {"CNB", 0, {}})
	For nX := 1 To Len(::aSheets)
		DBSeek(::cBranch + ::cContract + ::cReview + ::aSheets[nX])

		// Captura o valor total de cada item
		While (!EOF() .And. ::cBranch + ::cContract + ::cReview + ::aSheets[nX] == CNB_FILIAL + CNB_CONTRA + CNB_REVISA + CNB_NUMERO)
			nAux += CNB_VLTOT
			AAdd(::aValues[Len(::aValues)][3], CNB_VLTOT)
			DBSkip()
		End
	Next nX
	::aValues[Len(::aValues)][2] := nAux

	// Restaura a área anterior
	RestArea(aArea)
	FwFreeArray(aArea)
Return (::aValues[Len(::aValues)][2])

/*/{Protheus.doc} GCTAnalysis::GetCNDTotal
	Calcula o valor total de medições encerradas do contrato
	@type method
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@return Numeric, Valor total das medições encerradas do contrato (CND_VLTOT)
/*/
Method GetCNDTotal() As Numeric Class GCTAnalysis
	Local nX    := 0         As Numeric // Contador do laço de planilhas
	Local nAux  := 0         As Numeric // Auxiliar de soma de valores
	Local aArea := GetArea() As Array   // Área de trabalho anterior

	// Posiciona nas medições do contrato
	DBSelectArea("CND")
	DBSetOrder(1)
	DBGoTop()

	// Posiciona nos itens das planilhas em aSheets
	AAdd(::aValues, {"CND", 0, {}})
	For nX := 1 To Len(::aSheets)
		DBSeek(::cBranch + ::cContract + ::cReview + ::aSheets[nX])

		// Captura o valor total de cada item
		While (!EOF() .And. ::cBranch + ::cContract + ::cReview + ::aSheets[nX] == CND_FILIAL + CND_CONTRA + CND_REVISA + CND_NUMERO)
			If (!Empty(CND_DTFIM))
				nAux += CND_VLTOT
				AAdd(::aValues[Len(::aValues)][3], CND_VLTOT)
			EndIf
			DBSkip()
		End
	Next nX
	::aValues[Len(::aValues)][2] := nAux

	// Restaura a área anterior
	RestArea(aArea)
	FwFreeArray(aArea)
Return (::aValues[Len(::aValues)][2])

/*/{Protheus.doc} GCTAnalysis::GetSheets
	Retorna a lista de planilhas de um contrato
	@type method
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@return Array, Lista de planilhas do contrato
/*/
Method GetSheets() As Array Class GCTAnalysis
	Local aSheets := {}        As Array // Código das planilhas
	Local aArea   := GetArea() As Array // Área de trabalho anterior

	// Posiciona nas planilhas do contrato
	DBSelectArea("CNA")
	DBSetOrder(1)
	DBGoTop()
	DBSeek(::cBranch + ::cContract + ::cReview)

	// Captura o número e o valor total do planilha
	While (!EOF() .And. ::cBranch + ::cContract + ::cReview == CNA_FILIAL + CNA_CONTRA + CNA_REVISA)
		AAdd(aSheets, CNA_NUMERO)
		DBSkip()
	End

	// Atribui ao atributo da classe
	::aSheets := aSheets

	// Restaura a área anterior
	RestArea(aArea)
	FwFreeArray(aArea)
Return (aSheets)

/*/{Protheus.doc} GCTAnalysis::GetAllContracts
	Cria uma tabela temporária com todos os contratos da base por filial
	@type method
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
	@return Character, Alias da tabela temporária criada
/*/
Method GetAllContracts() As Character Class GCTAnalysis
	Local cAlias := GetNextAlias() As Character // Alias do arquivo temporário
	Local aArea  := GetArea()      As Array     // Área de trabalho anterior

	// Seleciona a maior revisão dos contratos + R_E_C_N_O_
	BEGINSQL ALIAS cAlias
		SELECT DISTINCT
			CN9A.CN9_FILIAL CN9FILIAL,
			CN9A.CN9_NUMERO CN9NUMERO
		FROM
			%TABLE:CN9% CN9A
		WHERE
			CN9A.%NOTDEL%
	ENDSQL

	// Altera o tipo do campo CN9RECNO
	TCSetField(cAlias, "CN9RECNO", "N", 10, 0)

	// Restaura a área anterior
	RestArea(aArea)
	FwFreeArray(aArea)
Return (cAlias)
