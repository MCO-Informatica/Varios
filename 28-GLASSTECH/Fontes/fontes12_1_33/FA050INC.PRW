#include 'protheus.ch'
User Function FA050INC()
	Local lRet := .t.

	if m->e2_tipo == "PA "
		lRet := u_verPA()
	endif

Return lRet

User Function verPA()
	Local lRet := .t.
	Local aInfUsr := {}
	if type("cAliasSE2") != "U" .and. cAliasSE2 == "__SUBS"
		if m->e2_tipo == "PA " .and. ( dtos(m->e2_emissao) != dtos(dDataBase) .or. dtos(m->e2_emissao) != dtos(m->e2_vencto) .or. dtos(m->e2_emissao) != dtos(m->e2_vencrea) )
			lRet := .f.
			Help( ,, 'Help',, "Data do vencimento/emissão deve ser igual a data de inclusão do título. ", 1, 0 )
			m->e2_emissao := dDataBase
			m->e2_vencto  := dDataBase
			m->e2_vencrea := dDataBase
		endif
	else
		if m->e2_tipo == "PA "
			PswOrder(2)
			//if PswSeek( SubStr(cUsuario,7,15), .t. ) 
			if PswSeek(cUserName,.t.)
				aInfUsr := PswRet()
			endif
			if empty(aInfUsr) .or. !"financeiro" $ lower(aInfUsr[1,12])
				lRet := .f.
				Help( ,, 'Help',, "Tipo PA, somente será utilizado na Substituição de títulos. ", 1, 0 )
			endif
		endif
	endif

Return lRet
