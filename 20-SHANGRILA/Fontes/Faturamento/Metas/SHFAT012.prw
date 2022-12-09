#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

Static aIndSZ6
Static lCopia

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	30/07/2014
* Descricao		:	
* Retorno		: 	
*/
User Function SHFAT012()

	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "SHFAT012"
	Private cCampo      := ""
	Private aParamBox	:= {}
	Private aRet      := {}

	aAdd(aSays," Rotina Responsável por efetuar a Geração da Meta de Vendas Mes a Mes		")
	aAdd(aSays,"             																")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Desenvolvido Por João Zabotto - Totvs IP   								")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Clique no botao OK para continuar.											")

	aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
	aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(),FechaBatch() },"Aguarde Gerando... !!!" ) }})
	aAdd(aButtons,{2,.T.,{||  lOk := .F. ,FechaBatch() }})

	FormBatch(FunDesc(),aSays,aButtons)


Return


/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
	Local cPerg		:= "SHFAT012"
	Local lRet		:= .F.

	aParamBox:= {}

	aAdd(@aParamBox,{1,"Data De?"	        ,StoD("")                      ,"","","",""   , 100,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"Data Ate?"          ,StoD("")                      ,"","","",""   , 100,.F.})		// MV_PAR02
	aAdd(@aParamBox,{1,"Codigo Peso?"       ,SPace(3)                      ,"","","SZB",""   , 100,.T.})		// MV_PAR02

	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

Return(lRet)

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	30/07/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function Processar()

	Local lRet := .T.
	Local aMata700 := {}
	Local nX := 0
	Local nOpc   := 3
	Local aMes   := SHGETPER(MV_PAR01,MV_PAR02)
	Local cAliasPrev		:= ''
	Local cAliasReg			:= ''
	Local cAno   := cValtoChar(Year(MV_PAR01))
	Local cSeq   := '000'
	Local cPeso  := MV_PAR03
	Local cTpNeg := ''
	Local cDesNeg := ''
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	ProcRegua(0)

	For nX := 1 to Len(aMes)
		cSeq   := '000'
		SZE->(DbSetOrder(1))
		If SZE->(DbSeek(xFilial('SZE') + StrZero(Month(FirstDate( CTOD("'01/" +  aMes[nX] + "'") )),2) + cAno))
			MsgInfo("Já Existe Registro gerado para esse período: " +StrZero(Month(FirstDate( CTOD("'01/" +  aMes[nX] + "'") )),2) + '/' + cAno + chr(13) + chr(10) + chr(13) + chr(10) + 'Por Favor exclua o registro ou informe outro período'  )
			Return .T.
		EndIf
	
		IncProc('Meta Venda Do Mês: ' + MesExtenso(Month(FirstDate( CTOD("'01/" +  aMes[nX] + "'") ))) + ' do Ano: ' + cAno )
	
		cAliasPrev := GetNextAlias()
		BeginSql Alias cAliasPrev
			%noparser%
			COLUMN C4_DATA AS DATE
			SELECT *
			FROM %TABLE:SC4% SC4
			WHERE
			SC4.C4_DATA BETWEEN %EXP:FirstDate( CTOD("'01/" +  aMes[nX] + "'") )% AND %EXP:LastDate( CTOD("'01/" +  aMes[nX] + "'") )% AND
			SC4.%NOTDEL% 			
		EndSql
	
		If Reclock('SZE',.T.)
			SZE->ZE_FILIAL := xFilial('SZE')
			SZE->ZE_MESANO := StrZero(Month(FirstDate( CTOD("'01/" +  aMes[nX] + "'") )),2) + cAno
			SZE->ZE_DESCRI := 'Meta Venda Do Mês: ' + MesExtenso(Month(FirstDate( CTOD("'01/" +  aMes[nX] + "'") ))) + ' do Ano: ' + cAno
			MsUnlock()
		EndIf
	
		SB1->(DbSetOrder(1))
		SBM->(DbSetOrder(1))

		While !(cAliasPrev)->(Eof())
			If SB1->(DbSeek(xFilial('SB1') + (cAliasPrev)->C4_PRODUTO))
				If SBM->(DbSeek(xFilial('SBM') + SB1->B1_GRUPO))
				
					SX5->(DbSetOrder(1))
					SX5->(DbSeeK(xFilial("SX5")+"12",.T.))
				
					While !SX5->(Eof()) .And. SX5->X5_TABELA == "12"
						If Alltrim(SX5->X5_CHAVE) == 'EX'
							SX5->(DbSkip())
							Loop
						EndIf
														
						cAliasReg := GetNextAlias()
						SHGETREG(@cAliasReg,SX5->X5_CHAVE)
					
						While !(cAliasReg)->(Eof())
								
							IF Alltrim(SBM->BM_TIPGRU) == '1'
								cDesNeg := 'DOOR'
							ElseIF Alltrim(SBM->BM_TIPGRU) == '2'
								cDesNeg := 'PROPRIA'
							ElseIF Alltrim(SBM->BM_TIPGRU) == '3'
								cDesNeg := 'GENERICO' 
							ElseIF Alltrim(SBM->BM_TIPGRU) == '4'
								cDesNeg := 'SERVICO'
							EndIF
							
							If !Alltrim(SBM->BM_TIPGRU) $'0'
								If !cDesNeg $ (cAliasReg)->Z8_DESCNEW
									(cAliasReg)->(DbSkip())
									Loop
								EndIF
							ElseIf Alltrim(SBM->BM_TIPGRU) $'0'
								If 'DOOR' $ (cAliasReg)->Z8_DESCNEW .Or. 'PROPRIA' $ (cAliasReg)->Z8_DESCNEW .Or. 'SERVICO' $ (cAliasReg)->Z8_DESCNEW .Or. 'GENERICO' $ (cAliasReg)->Z8_DESCNEW
									(cAliasReg)->(DbSkip())
									Loop
								EndIF
							EndIF
							
							nPerc               := SHGETPES((cAliasPrev)->C4_PRODUTO, cAno,aMes[nX] ,IF((cAliasReg)->Z7_CODZONA == '1','C','I'),(cAliasReg)->Z7_UF,cPeso,cDesNeg)
							If nPerc >0
						/*		If SBM->BM_TIPGRU $ '1|2'
									nPerc := 100
								EndIf*/
								cSeq := Soma1(cSeq)
								If Reclock('SZF',.T.)
									SZF->ZF_FILIAL		:= xFilial('SZE')
									SZF->ZF_DOC			:= SZE->ZE_MESANO
									SZF->ZF_SEQUEN		:= cSeq
									SZF->ZF_DESCRI 		:= SZE->ZE_DESCRI
									SZF->ZF_REGIAO 		:= (cAliasReg)->Z8_CODNEW
									SZF->ZF_CCUSTO 		:= ''
									SZF->ZF_ITEMCC 		:= ''
									SZF->ZF_VEND   		:= ''
									SZF->ZF_DATA		:= FirstDate( CTOD("'01/" +  aMes[nX] + "'") )
									SZF->ZF_GRUPO  		:= SB1->B1_GRUPO
									SZF->ZF_TIPO   		:= SB1->B1_TIPO
									SZF->ZF_PRODUTO		:= (cAliasPrev)->C4_PRODUTO
									SZF->ZF_QUANT  		:= Round(((((cAliasPrev)->C4_QUANT * nPerc)/100)* (cAliasReg)->Z9_PERCENT)/100,0)
									SZF->ZF_VALOR  		:= Round(((((cAliasPrev)->C4_VALOR * nPerc)/100)* (cAliasReg)->Z9_PERCENT)/100,2)
									SZF->ZF_MOEDA  		:= 1
									MsUnlock()
								EndIf
							EndIf
							(cAliasReg)->(DbSkip())
						EndDo
						(cAliasReg)->(DbCloseArea())
					
						SX5->(DbSkip())
					EndDo
				EndIf
			EndIf
			(cAliasPrev)->(DbSkip())
		EndDo
		(cAliasPrev)->(DbCloseArea())
	Next

Return lRet

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	30/07/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function SHGETPES(cProduto,cAno,cMes,cCapInt,cEst,cPeso,cDesNeg)
	Local aRet 	 := {}
	Local cAlias := ''
	Local cIn    := ''
	Local nValor := 0
	Local nQuant := 0
	Local nPercent := 0

	If !Empty(cDesNeg) .And. cEst != "SP"
		cIn := "%("
		cin += " SZC.ZC_PERC"  + cEst
		cIn += " + SZC.ZC_PERI"  + cEst
		cIn += ") NPERC %"
	Else
		cIn := "% (SZC.ZC_PER" + cCapInt + cEst + ") NPERC %"
	EndIf
 
	cAlias := GetNextAlias()
	BeginSql Alias cAlias
		SELECT %Exp:cIn%
		FROM %TABLE:SZC% SZC
		WHERE
		SZC.ZC_CODIGO  = %EXP:cPeso% AND
		SZC.ZC_ANO     = %EXP:cAno% AND
		SZC.ZC_PRODUTO = %EXP:cProduto% AND
		SZC.%NOTDEL%
	EndSql

	If !(cAlias)->(Eof())
		nPercent := (cAlias)->NPERC
	EndIf

	(cAlias)->(DbCloseArea())
Return nPercent


/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	30/07/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function SHGETREG(cAliasReg,cEst)
	Local aRet 	 := {}
	Local cAlias := ''
	Local cIn    := ''
	Local nValor := 0
	Local nQuant := 0

	BeginSql Alias cAliasReg
		SELECT Z8_CODIGO,Z7_UF,Z8_CODNEW,Z8_DESCNEW,Z7_CODREG,Z7_CODZONA, Z9_PERCENT
		FROM %TABLE:SZ7% SZ7
		INNER JOIN %TABLE:SZ8% SZ8 ON SZ7.Z7_CODIGO = SZ8.Z8_CODIGO AND SZ8.%NOTDEL%
		INNER JOIN %TABLE:SZ9% SZ9 ON SZ9.Z9_CODIGO = SZ7.Z7_CODREG AND SZ9.Z9_PERCENT > 0 AND SZ9.%NOTDEL%
		WHERE
		SZ7.Z7_UF = %EXP:cEst% AND
		SZ7.%NOTDEL%
		GROUP BY  Z8_CODIGO,Z7_UF,Z8_CODNEW,Z8_DESCNEW,Z7_CODREG,Z7_CODZONA, Z9_PERCENT
		ORDER BY  Z8_CODIGO
	EndSql

Return

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	30/07/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function SHGETPER(dIni,dFim)
	Local aMes := {}

	Default dIni := CTOD('01/01/2013')  // Data no formato mm/dd/aa
	Default dFim := CTOD('31/12/2013')  // Data no formato mm/dd/aa

	aAdd ( aMes, StrZero(Month( dIni ),2) + '/' + StrZero ( Year ( dIni ), 4 ) )
	For i := 1 To dFim - dIni
		dIni++
		If aScan( aMes, StrZero(Month( dIni ),2) + '/' + StrZero ( Year ( dIni ), 4 ) ) == 0
			aAdd ( aMes, StrZero(Month( dIni ),2) + '/' + StrZero ( Year ( dIni ), 4 ) )
		EndIf
	Next i

Return ( aMes )

