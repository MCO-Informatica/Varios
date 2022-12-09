// Bibliotecas necess�rias
#Include "TOTVS.ch"

// Namespaces para organiza��o
// NAMESPACE job

/*/{Protheus.doc} JOB001
	Job para indicar se a solicita��o de libera��o manual de pagamento
	teve o pagamento identificado no financeiro.
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 12/07/2021
/*/
User Function JOB001() As Variant
	Local cText  := "" As Character // Auxiliar de montagem da mensagem
	Local cAlias := "" As Character // Alias da tabela tempor�ria de solicita��es

	RPCSetEnv("01")
		cAlias := TableDef()
		// Percorre os registros encontrados
		While (!EOF())
			// Posiciona na tabela de PBP por meio do R_E_C_N_O_
			DBSelectArea("PBP")
			DBGoTo((cAlias)->RECNOPBP)

			// In�cia transa��o para manter a integridade
			BEGIN TRANSACTION
				// Altera os campos descri��o e status
				DBSelectArea("PBP")
				RecLock("PBP", .F.)
					PBP_STATUS := "1"
					PBP_DESCRI := "PAGAMENTO IDENTIFICADO"

					// Define a mensagem de log da altera��o
					cText := PBP_LOG + Chr(10) + Chr(13)
					cText += "EM " + DToC(Date()) + " " + Time() + " FOI IDENTIFICADO O PAGAMENTO DO PEDIDO "
					cText += "PELO CNAB ID " + (cAlias)->ZQ_ID + " LINHA " + (cAlias)->ZQ_LINHA + " "
					cText += "POR MEIO DA ROTINA " + ProcName(0) + "."
					PBP_LOG := cText
				MsUnlock()
			END TRANSACTION

			// Retorna o cursor para a tempor�ria e salta o registro
			DBSelectArea(cAlias)
			DBSkip()
		End
	RPCClearEnv()
Return (NIL)

/*/{Protheus.doc} TableDef
	Monta uma tabela tempor�ria com as solicita��es dos �ltimos 30 dias
	que n�o est�o com status 1 ou 9 para os casos em que o pagamento
	aconteceu posterior aos 3 dias �teis
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 12/07/2021
	@return Character, Alias da tabela criada
/*/
Static Function TableDef() As Character
	Local cTable := GetNextAlias() As Character // Alias tempor�rio

	// Monta a tabela tempor�ria
	BEGINSQL ALIAS cTable
		SELECT
			PBP.R_E_C_N_O_ RECNOPBP,
			SZQ.ZQ_ID,
			SZQ.ZQ_LINHA
		FROM
			%TABLE:PBP% PBP
		LEFT JOIN
			%TABLE:SZQ% SZQ
		ON
			SZQ.ZQ_PEDIDO = PBP.PBP_PSITE
		WHERE
			PBP.PBP_STATUS NOT IN('1', '9') AND
			SZQ.ZQ_PEDIDO IS NOT NULL       AND
			PBP.PBP_DATA >= %EXP:(dDatabase - 30)%
	ENDSQL

	// Posiciona na tabela atual e move para o in�cio
	DBSelectArea(cTable)
	DBGoTop()
Return (cTable)
