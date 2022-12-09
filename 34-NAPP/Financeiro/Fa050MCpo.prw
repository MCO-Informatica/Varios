#Include 'Protheus.ch'

User Function F050MCP()

	Local aCpo := paramixb
	
	AADD(aCpo,"E2_CREDIT")	
	AADD(aCpo,"E2_VENCTO")
	AADD(aCpo,"E2_VENCREA")
	AADD(aCpo,"E2_CCUSTO")
	AADD(aCpo,"E2_CONTAD")
	AADD(aCpo,"E2_JUROS")
	AADD(aCpo,"E2_MULTA")
	AADD(aCpo,"E2_CORREC")
	AADD(aCpo,"E2_NATUREZ")
	AADD(aCpo,"E2_VALOR")
	
Return aCpo
