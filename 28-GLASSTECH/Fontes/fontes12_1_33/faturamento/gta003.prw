#Include "Protheus.ch"
/* Inclusão de pedidos de vendas por execauto. Obs: Somente esta implementado a inclusão */

User Function gta003(cJobEmp,cJobFil,cJobMod,nOpc,aCab,aItens,cMens)
	Local lRet := .t.
	Local cEvento := iif(nOpc==3,"Inclusão","")
	Local cNum := ""
	Local nI := 0

	local aErroAuto := {}
	Local cErroAuto := ""
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	Private lMsErroAuto := .f.

    RpcSetType( 3 )
	RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )

	Begin Sequence

		DbSelectArea("SC5")
		DbSetOrder(1)

		cNum := GetSXENum("SC5","C5_NUM")
		dbSeek(xFilial("SC5")+cNum)
		while !sc5->(eof())
			cNum := GetSXENum("SC5","C5_NUM")
			dbSeek(xFilial("SC5")+cNum)
		end

		aCab[1,2] := cNum
		MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCab, aItens, nOpc, .f. )
		if lMsErroAuto
			aErroAuto := MostraErro()	//GetAutoGRLog()
			For nI := 1 To Len(aErroAuto)
				cErroAuto += StrTran(StrTran(aErroAuto[nI], "<", ""), "-", "") + " "
			Next
			lRet := .f.
			cMens := "Erro na "+cEvento+" do pedido: "+cNum+". Detalhes: "+iif(Empty(cErroAuto),"Internal Error.",Substr(cErroAuto,1,150) )
		Else
			cMens := "Sucesso na "+cEvento+" do Pedido: "+cNum+" !"
		EndIf

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		lRet := .f.
		cMens := Substr("Falha na "+cEvento+" do pedido: "+cNum+". Detalhes: "+cError,1,150)
	EndIf

    RpcClearEnv()

Return lRet
