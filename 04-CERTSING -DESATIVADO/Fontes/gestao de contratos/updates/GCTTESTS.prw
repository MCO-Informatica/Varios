// Bibliotecas necessárias
#Include "TOTVS.ch"

// Namespaces para organização
// NAMESPACE analysis
// USING NAMESPACE utils

/*/{Protheus.doc} GCT01Test
	Gera o conteúdo de arquivo .CSV com as divergências entre o campo
	CN9_MEDACU e a soma das medições para o contrato
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 14/07/2021
/*/
User Function GCT01Test() As Variant
	Local oGCT   := NIL As Object    // Objeto de análise
	Local cKey   := ""  As Character // Chave de busca da CN9
	Local cAlias := ""  As Character // Alias da tabela temporária
	Local cText  := ""  As Array     // CSV de contratos divergentes

	// Abertura de ambiente sem interface gráfica ou consumo de licença
	RPCSetType(3)
	RPCSetEnv("01", "01")
		// Captura a listagem de contratos da base
		oGCT := GCTAnalysis():New()
		cAlias := oGCT:GetAllContracts()
		FreeObj(oGCT)

		// Posiciona no arquivo e move para o início
		DBSelectArea(cAlias)
		DBGoTop()

		// Adiciona o cabeçalho do arquivo CSV
		cText += "FILIAL;CONTRATO;REVISAO;R_E_C_N_O_;CN9_MEDACU;CND_VLTOT;DIFERENCA" + Chr(13)

		// Percorre todos os contratos da base
		While (!EOF())
			// Posiciona no contrato
			cKey := CN9FILIAL + CN9NUMERO + CnUltRev(CN9NUMERO, CN9FILIAL)
			DBSelectArea(cAlias)
			CN9->(DBSeek(cKey))

			// Captura o valor total de medições
			oGCT := GCTAnalysis():New(CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA)
			nCNDTot := oGCT:GetCNDTotal()

			// Se os valores forem diferntes, grava no vetor de diferenças
			If (nCNDTot != CN9->CN9_MEDACU)
				cText += "'" + CN9->CN9_FILIAL + ";'"
				cText += CN9->CN9_NUMERO + ";'"
				cText += IIf(Empty(CN9->CN9_REVISA), "000", CN9->CN9_REVISA) + ";"
				cText += CValToChar(RecNo()) + ";"
				cText += AllTrim(Transform(CN9->CN9_MEDACU, "@E " + Repl("9", 15) + ".99")) + ";"
				cText += AllTrim(Transform(nCNDTot, "@E " + Repl("9", 15) + ".99")) + ";"
				cText += AllTrim(Transform(Abs(CN9->CN9_MEDACU - nCNDTot), "@E " + Repl("9", 15) + ".99")) + Chr(13)
			EndIf

			// Limpa o objeto e avança o registro
			FreeObj(oGCT)
			DBSkip()
		End

		// Envia estrutura .CSV para a área de transferência
		CopyToClipBoard(cText)
	RPCClearEnv() // Encerra o ambiente
Return (NIL)
