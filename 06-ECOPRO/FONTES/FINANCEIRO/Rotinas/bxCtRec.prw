#Include 'Protheus.ch'
/* Função para executar movimentação de um título a receber - nOpc = 3 -> baixar*/

User Function bxCtRec( nOpc, cPrefixo, cNum, cPar, cTipo, cMotBx, cBco, cAge, cCta, dBaixa, dCredito, cHist, nVlrBx, nVlrDesc, cMens )
	Local lRet := .t.
	Local nI := 0
	Local aBaixa := {}

	Private lMsErroAuto := .f.

	aBaixa := {{"E1_PREFIXO"	,cPrefixo   ,Nil},;
		{"E1_NUM"		,cNum       ,Nil},;
		{"E1_PARCELA"	,cPar       ,Nil},;
		{"E1_TIPO"		,cTipo      ,Nil},;
		{"AUTMOTBX"		,cMotBx     ,Nil},;
		{"AUTBANCO"		,cBco       ,Nil},;
		{"AUTAGENCIA"	,cAge       ,Nil},;
		{"AUTCONTA"		,cCta       ,Nil},;
		{"AUTDTBAIXA"	,dBaixa     ,Nil},;
		{"AUTDTCREDITO"	,dCredito   ,Nil},;
		{"AUTHIST"	    ,cHist		,Nil},;
		{"AUTVALREC"	,nVlrBx     ,Nil},;
		{"AUTDESCONT"   ,nVlrDesc   ,Nil,.t.}}

	Begin Transaction

		MSExecAuto({|x,y| fina070(x,y)},aBaixa,nOpc)
		if lMsErroAuto
			lRet := .f.
			cMens := "O título "+cPrefixo+cNum+cPar+cTipo+" não foi baixado !"
			if isblind()
				aAutoErr := GetAutoGRLog()
				for nI := 1 To Len(aAutoErr)
					cMens += aAutoErr[nI] + CRLF
				next
			else
				MostraErro()
			endif
			DisarmTransaction()
		endif

	End Transaction

Return lRet
