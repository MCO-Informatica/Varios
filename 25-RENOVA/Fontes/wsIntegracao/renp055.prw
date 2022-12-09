#Include 'Protheus.ch'

/* Função retorna numero da demanda*/
User Function renp055()

	local cDemanda := ""

	szm->(DbSetOrder(1))
	cDemanda := GetSx8Num("SZM","ZM_DEMANDA")
	szm->(dbSeek(xFilial()+cDemanda))
	while !szm->(eof())
		cDemanda := GetSx8Num("SZM","ZM_DEMANDA")
		szm->(dbSeek(xFilial()+cDemanda))
	end

Return cDemanda
