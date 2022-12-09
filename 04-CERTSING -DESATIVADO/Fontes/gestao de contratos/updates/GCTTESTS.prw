// Bibliotecas necess�rias
#Include "TOTVS.ch"

// Namespaces para organiza��o
// NAMESPACE analysis
// USING NAMESPACE utils

/*/{Protheus.doc} GCT01Test
	Gera o conte�do de arquivo .CSV com as diverg�ncias entre o campo
	CN9_MEDACU e a soma das medi��es para o contrato
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
/*/
User Function GCT01Test() As Variant
	Local oGCT   := NIL As Object    // Objeto de an�lise
	Local cKey   := ""  As Character // Chave de busca da CN9
	Local cAlias := ""  As Character // Alias da tabela tempor�ria
	Local cText  := ""  As Array     // CSV de contratos divergentes

	// Abertura de ambiente sem interface gr�fica ou consumo de licen�a
	RPCSetType(3)
	RPCSetEnv("01", "01")
		// Captura a listagem de contratos da base
		oGCT := GCTAnalysis():New()
		cAlias := oGCT:GetAllContracts()
		FreeObj(oGCT)

		// Posiciona no arquivo e move para o in�cio
		DBSelectArea(cAlias)
		DBGoTop()

		// Adiciona o cabe�alho do arquivo CSV
		cText += "FILIAL;CONTRATO;REVISAO;R_E_C_N_O_;CN9_MEDACU;CND_VLTOT;DIFERENCA" + Chr(13)

		// Percorre todos os contratos da base
		While (!EOF())
			// Posiciona no contrato
			cKey := CN9FILIAL + CN9NUMERO + CnUltRev(CN9NUMERO, CN9FILIAL)
			DBSelectArea(cAlias)
			CN9->(DBSeek(cKey))

			// Captura o valor total de medi��es
			oGCT := GCTAnalysis():New(CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA)
			nCNDTot := oGCT:GetCNDTotal()

			// Se os valores forem diferntes, grava no vetor de diferen�as
			If (nCNDTot != CN9->CN9_MEDACU)
				cText += "'" + CN9->CN9_FILIAL + ";'"
				cText += CN9->CN9_NUMERO + ";'"
				cText += IIf(Empty(CN9->CN9_REVISA), "000", CN9->CN9_REVISA) + ";"
				cText += CValToChar(RecNo()) + ";"
				cText += AllTrim(Transform(CN9->CN9_MEDACU, "@E " + Repl("9", 15) + ".99")) + ";"
				cText += AllTrim(Transform(nCNDTot, "@E " + Repl("9", 15) + ".99")) + ";"
				cText += AllTrim(Transform(Abs(CN9->CN9_MEDACU - nCNDTot), "@E " + Repl("9", 15) + ".99")) + Chr(13)
			EndIf

			// Limpa o objeto e avan�a o registro
			FreeObj(oGCT)
			DBSkip()
		End

		// Envia estrutura .CSV para a �rea de transfer�ncia
		CopyToClipBoard(cText)
	RPCClearEnv() // Encerra o ambiente
Return (NIL)
