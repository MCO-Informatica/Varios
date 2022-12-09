#Include 'Protheus.ch'

user function fazTransferM(aAuto,nOpc,cMens)

	Local lRet     := .t.
	Local cDocumen := ""
	Local nI       := 0

	local aErroAuto := {}
	Local cLogErro := ""
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .F.

	cDocumen := GetSxeNum("SD3","D3_DOC")
	sd3->(dbSetOrder(1))
	sd3->(dbseek(xfilial()+cDocumen))
	while !sd3->(eof())
		cDocumen := GetSxeNum("SD3","D3_DOC")
		sd3->(dbseek(xfilial()+cDocumen))
	end
	aAuto[1,1] := cDocumen
	
	Begin Sequence

		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpc)
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
			cMens := cDocumen
		EndIf

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	if !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens += Substr("Error: "+cError,1,150)
	endIf

Return(lRet)
