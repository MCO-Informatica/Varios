#Include 'Protheus.ch'
/* Função para efetivar a tranferencia de materiais entre almoxarifados */
user function renp100(aAuto,nOpc,cMens)

	Local lRet     := .t.
	Local cDocumen := ""
	Local nI       := 0
	
	local aErro := {}
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
			if isBlind()
				aErro := GetAutoGRLog()
				for nI := 1 To Len(aErro)
					cMens += aErro[nI]+chr(10)+chr(13)
				Next
			else
				cMens += MostraErro()
			endif
			lRet := .f.
			cMens += "Detalhes: "+iif(Empty(cMens),"Internal Error.",cMens )
		Else
			cMens += "Transferência "+cDocumen+" Realizada. "
		EndIf

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	if !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens += Substr("Error: "+cError,1,150)
	endIf

Return lRet
