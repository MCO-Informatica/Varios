#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKCND   º Autor ³ Giane - ADV Brasil º Data ³  29/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para alterar as formas de pagamento no    º±±
±±º          ³ orcamentos/televendas                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / televendas/orcamento                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TMKCND(cNumTlv, cCliente, cLoja ,cCodCont,;
	cCodOper	,aParcelas		,cCodPagto		,oCodPagto,;
	cDescPagto	,oDescPagto 	,lHabilAux		,cCodTransp)
	lOCAL aAreaSUA	:= SUA->(GETAREA())
	lOCAL aAreaSUB	:= SUB->(GETAREA())
	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "TMKCND" , __cUserID )

	If cCodPagto == '000' // '001' a vista
		cForma := 'DC'  //deposito em conta
	Else
		cForma := 'BOL' //boleto bancario
	endif

	if cCodPagto != '100' //'000' remessa, nao deve gerar duplicatas
		For i:= 1 to len(aParcelas)
			aParcelas[i,3] := cForma
		Next
	else
		aParcelas := {}
	endif
	SUA->(Dbsetorder(1))
	if SUA->(dbseek(xFilial("SUA")+cNumTlv))
		RECLOCK("SUA",.F.)
		SUA->UA_XPEDCLI := strtran(alltrim(SUA->UA_XPEDCLI ),'	','')

		if valtype(M->UA_XPEDCLI) <> 'U'
			M->UA_XPEDCLI:= strtran(alltrim(M->UA_XPEDCLI),'	','')
		ENDIF
		MSUNLOCK()
		SUB->(DBSETORDER(1))
		SUB->(DBSEEK(XFILIAL("SUB")+SUA->UA_NUM))
		WHILE SUA->UA_NUM == SUB->UB_NUM .AND. SUB->(!EOF())
			RECLOCK("SUB",.F.)
			SUB->UB_XPEDCLI := strtran(alltrim(SUB->UB_XPEDCLI ),'	','')
			MSUNLOCK()
			SUB->(DBSKIP())
		END
		nPP	:= aScan(aHeader,{|z| alltrim(z[2]) == "UB_XPEDCLI" })
		IF nPP > 0
			For nFor := 1 to len(aCols)
				aCols[nFor][nPP] := strtran(alltrim(aCols[nFor][nPP] ),'	','')
			next nFor
		ENDIF
	endif
	//oDescPagto	:ForceRefresh()
	//oCodPagto	:ForceRefresh()
	//GetDRefresh()
	oCodPagto:SetFocus()
	oDescPagto:SetFocus()
	RESTAREA(aAreaSUB)
	RESTAREA(aAreaSUA)
Return(aParcelas)
