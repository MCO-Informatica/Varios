#Include 'Protheus.ch'

/* Função retorna numero da reserva*/
User Function renp050()

	local cNumres := ""

	sc0->(DbSetOrder(1))
	cNumres := GetSx8Num("SC0","C0_NUM")
	sc0->(dbSeek(xFilial()+cNumres))
	while !sc0->(eof())
		cNumres := GetSx8Num("SC0","C0_NUM")
		sc0->(dbSeek(xFilial()+cNumres))
	end

Return cNumres
