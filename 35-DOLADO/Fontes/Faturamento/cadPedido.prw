#Include 'Protheus.ch'

user Function cadPedido(aCabec,aItens,nOpcAuto,cMens)
	Local lRet := .t.
	Local cNumPed := ""
	Local nI 	:= 0

	local aErroAuto := {}
	Local cLogErro := ""
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

	cNumPed := GetSXENum("SC5","C5_NUM")
	sc5->(dbSetOrder(1))
	sc5->(dbseek(xfilial()+cNumPed))
	while !sc5->(eof())
		cNumPed := GetSXENum("SC5","C5_NUM")
		sc5->(dbseek(xfilial()+cNumPed))
	end

	aCabec[1,2] := cNumPed
	Begin Sequence

		MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcAuto, .f. )
		if lMsErroAuto
			aErroAuto := GetAutoGRLog()
			For nI := 1 To Len(aErroAuto)
				cLogErro += StrTran(StrTran(aErroAuto[nI], "<", ""), "-", "") + " "
			Next
			if empty(cLogErro)
				cLogErro := MostraErro()
			endif
			lRet := .f.
			cMens := "Detalhes: "+iif(Empty(cLogErro),"Internal Error.",Substr(cLogErro,1,150) )
		Else
			cMens := cNumPed
		EndIf

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	if !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens := Substr("Detalhes: "+cError,1,150)
	endIf

Return lRet
