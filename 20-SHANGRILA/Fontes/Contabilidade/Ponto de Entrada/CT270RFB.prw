#include "rwmake.ch"
#include "protheus.ch"

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	23/01/2014
* Descricao		:	
* Retorno		: 	
*/
User Function CT270RFB()
	Local cAliasNew := PARAMIXB[1]
	Local cRatOld := ''
	Local nTotal  := 0
	Local nPerc   := 0
	Local nPercT  := 0
	Local cCodRat := SuperGetMv('ZZ_CODRAT',.F.,'000001')
	Local nValor := 0

	(cAliasNew)->(DbSetOrder(1))
	If (cAliasNew)->(DbSeek(xFilial(cAliasNew) + MV_PAR01))
	
		While (cAliasNew)->(!EOF()) .AND. 	(cAliasNew)->CTQ_FILIAL == xFilial('CTQ') .AND.;
				(cAliasNew)->CTQ_RATEIO <= MV_PAR02
				
			If Alltrim((cAliasNew)->CTQ_RATEIO) $ cCodRat
				(cAliasNew)->( dbSkip() )
				Loop
			EndIf
			
			If cRatOld <> 	(cAliasNew)->CTQ_RATEIO
				If nPercT > 0
					IF nPercT < 100 .Or. nPercT > 100
						SHGETMAX(cAliasNew,cRatOld,nPercT)
						nPercT := 0
					EndIf
				EndIf
				nPercT 	 := 0
				cRatOld  := (cAliasNew)->CTQ_RATEIO
				nTotal   := SHGETHRT(cRatOld)
				nTotalKW := SHGETPERKW(cAliasNew,cRatOld)
			EndIf
				
			nValor := SHGETHRR('MOD'+(cAliasNew)->CTQ_CCCPAR)
			
			If CTQ->CTQ_ZZKWHR > 0
				nPerc := Round(((CTQ->CTQ_ZZKWHR * nValor)/nTotalKW)*100,2)
			Else
				nPerc := Round((nValor / nTotal) * 100,2)
			EndIf
			
			nPercT += nPerc
			
			If Reclock(cAliasNew,.F.)
				(cAliasNew)->CTQ_PERCEN := nPerc
			EndIf
		
			(cAliasNew)->( dbSkip() )
									
		EndDo
		
		If nPercT > 0
			IF nPercT < 100 .Or. nPercT > 100
				SHGETMAX(cAliasNew,cRatOld,nPercT)
				nPercT := 0
			EndIf
		EndIf
				
	EndIf
Return

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	23/01/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function SHGETPERKW(cAliasNew,cRateio)
	Local aArea  := (cAliasNew)->(GetArea())
	Local nTotal := 0

	CTQ->(DbSetOrder(1))
	If CTQ->(DbSeek(xFilial('CTQ') + cRateio))
	
		While CTQ->(!EOF()) .AND. 	CTQ->CTQ_FILIAL == xFilial('CTQ') .AND.;
				CTQ->CTQ_RATEIO >= cRateio .And. CTQ->CTQ_RATEIO <= cRateio
			
			nPerc := SHGETHRR('MOD'+ CTQ->CTQ_CCCPAR)
			
			If CTQ->CTQ_ZZKWHR > 0
				nTotal += CTQ->CTQ_ZZKWHR * nPerc
			EndIf
			
			CTQ->( dbSkip() )
		EndDo
	EndIf
	
	RestArea(aArea)

Return Round(nTotal,2)

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	23/01/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function SHGETMAX(cAliasNew,cRateio,nPerc)
	Local aArea  := (cAliasNew)->(GetArea())
	Local nTotal := 0
	Local cAliasC := GetNextAlias()
	Local nReg  := 0
	Local nCount  := 0
	Local cRet    := ''
	Local nPerMax := 0
	Local nPerDif := 0
	
	BeginSql Alias cAliasC
		%noparser%
		SELECT
		CTQ_CCCPAR,CTQ_SEQUEN,MAX(CTQ_PERCEN) CTQ_PERCEN
		FROM %TABLE:CTQ% CTQ
		WHERE
		CTQ.CTQ_RATEIO = %EXP:cRateio% AND
		CTQ.%NOTDEL%
		GROUP BY CTQ_CCCPAR ,CTQ_SEQUEN
		ORDER BY CTQ_PERCEN DESC
	EndSql
	
	If !(cAliasC)->(Eof())
		nPerMax := (cAliasC)->CTQ_PERCEN
	EndIF
	CTQ->(DbSetOrder(1))
	If CTQ->(DbSeek(xFilial('CTQ') + cRateio + (cAliasC)->CTQ_SEQUEN))
		If Reclock('CTQ',.F.)
	
			If nPerc > 100
				nPerDif := nPerc - 100
				nPerMax -= nPerDif
			ElseIf nPerc < 100
				nPerDif := 100 - nPerc
				nPerMax += nPerDif
			EndIF
	
			CTQ->CTQ_PERCEN := nPerMax
			
			CTQ->(MsUnlock())
		EndIf
	EndIf
	
	RestArea(aArea)
	(cAliasC)->(DbCloseArea())
Return

Static Function SHGETHRT(cRateio)
	Local cAliasT := GetNextAlias()
	Local nValor  := 0

	cIn := "% SD3.D3_COD IN (" + SHGETCC(cRateio) + ") %"

	BeginSql Alias cAliasT
		%noparser%
		SELECT
		SUM(D3_QUANT) AS HORATOTAL
		FROM %TABLE:SD3% SD3
		WHERE
		%Exp:cIn% AND
		SD3.D3_EMISSAO BETWEEN %EXP:DTOS(MV_PAR03)% AND %EXP:DTOS(MV_PAR04)% AND
		SD3.D3_TIPO = %EXP:'MO'% AND
		SD3.D3_OP <> %EXP:'             '% AND
		SD3.%NOTDEL%
	EndSql

	If !(cAliasT)->(Eof())
		nValor := Round((cAliasT)->HORATOTAL,2)
	EndIf
	
	(cAliasT)->(DbCloseArea())
Return nValor

Static Function SHGETHRR(cCusto)
	Local cAliasR := GetNextAlias()
	Local nValor  := 0

	BeginSql Alias cAliasR
		%noparser%
		SELECT
		SUM(D3_QUANT) AS HORATOTAL
		FROM %TABLE:SD3% SD3
		WHERE
		SD3.D3_COD = %EXP:cCusto% AND
		SD3.D3_EMISSAO BETWEEN %EXP:DTOS(MV_PAR03)% AND %EXP:DTOS(MV_PAR04)% AND
		SD3.D3_TIPO = %EXP:'MO'% AND
		SD3.D3_OP <> %EXP:'             '% AND
		SD3.%NOTDEL%
	EndSql

	If !(cAliasR)->(Eof())
		nValor := Round((cAliasR)->HORATOTAL,2)
	EndIf
	
	(cAliasR)->(DbCloseArea())
Return nValor

Static Function SHGETCC(cRateio)
	Local cAliasC := GetNextAlias()
	Local nReg  := 0
	Local nCount  := 0
	Local cRet    := ''
	
	BeginSql Alias cAliasC
		%noparser%
		SELECT CTQ_CCCPAR
		FROM %TABLE:CTQ% CTQ
		WHERE
		CTQ.CTQ_RATEIO = %EXP:cRateio% AND
		CTQ.%NOTDEL%
		ORDER BY  CTQ_CCCPAR
	EndSql
	
	Count to nReg
	
	(cAliasC)->(DbGoTop())

	While !(cAliasC)->(EoF())
		nCount++
		
		cRet +=  If(Empty(cRet),"'MOD" + Alltrim((cAliasC)->CTQ_CCCPAR) ,",'MOD"  + Alltrim((cAliasC)->CTQ_CCCPAR) )
		
		If nCount <= nReg
			cRet += "'"
		EndIf
			
		(cAliasC)->(DbSkip())
	Enddo
	
	(cAliasC)->(DbCloseArea())
Return cRet


Static Function AjustaPerg()
	Local cPerg		:= "CT270RFB"
	Local lRet		:= .F.

	aParamBox:= {}

	aAdd(@aParamBox,{1,"Data De?"	        ,StoD("")                      ,"","","",""   , 100,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"Data Ate?"          ,StoD("")                      ,"","","",""   , 100,.F.})		// MV_PAR02
	
	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

Return(lRet)
