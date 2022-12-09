#Include 'Protheus.ch'

User Function zInvMoeda()

	Local nMoeda := M->ZZC_MOEDA
	Local cInvMoeda

	if nMoeda <> 1
		cInvMoeda := cValToChar(nMoeda)
	endif

Return cInvMoeda

