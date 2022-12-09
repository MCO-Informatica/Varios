#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/**
* Funcao		:	SHFAT011
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Rotina para calculo do MUKPD e MKUPM de coeficiente
* Retorno		: 	Nenhum
*/
User Function SHFAT011()
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "SHFT10RE"
	Private cCampo      := ""
	Private aParamBox	:= {}
	Private aCombo    := {'Standard','Tabela','Médio'}
	Private aComboInt := {'Sim','Não','Todos'}
	Private aComboExt := {'Sim','Não','Todos'}
	Private aComboBlq := {'Sim','Não'}
	Private aExecucao := {'Update','Restore'}
	Private aPeriodo  := {'12 Meses','24 Meses','36 Meses'}
	Private aRet      := {}

	aAdd(aSays," Rotina Responsével por efetuar a Geração preço de venda cadastro produto	")
	aAdd(aSays,"             																")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Desenvolvido Por João Zabotto - Totvs IP   								")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Clique no botao OK para continuar.											")

	aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
	aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(),FechaBatch() },"Aguarde... !!!" ) }})
	aAdd(aButtons,{2,.T.,{||  lOk := .F. ,FechaBatch() }})

	FormBatch(FunDesc(),aSays,aButtons)


Return

Static Function Processar()
	Local lRet      := .T.
	Local cAlias010 := GetNextAlias()
	Local nCoefic   := 0
	Local aMa280FLock := {}
	Local dDataFech  := GetMv("MV_ULMES")
	Local nPrcVen   := 0
	Local nCusto    := 0
	Local nTpCusto  := 0
	Local cTabEnt   := ''
	Local cTabInt   := ''
	Local cBloq     := ''
	Local nPrcOld   := 0
	Local nCustoOld := 0

	aAdd( aMa280FLock , "SB1"	) //Produto

	If Valtype(MV_PAR05) == 'N'
		MV_PAR05 := '1'
	EndIf

	If MV_PAR05 $ 'Tabela'
		nTpCusto := 2
	ElseIf MV_PAR05 $ 'Médio'
		nTpCusto := 3
	Else
		nTpCusto := 1
	EndIf

	If Valtype(MV_PAR06) == 'N'
		MV_PAR06 := '1'
	EndIf

	If MV_PAR06 $ 'Não'
		cTabInt := 'N'
	ElseIf MV_PAR06 $ 'Todos'
		cTabInt := 'T'
	Else
		cTabInt := 'S'
	EndIf

	If Valtype(MV_PAR07) == 'N'
		MV_PAR07 := '1'
	EndIf

	If MV_PAR07 $ 'Não'
		cTabEnt := 'N'
	ElseIf MV_PAR07 $ 'Todos'
		cTabEnt := 'T'
	Else
		cTabEnt := 'S'
	EndIf

	If Valtype(MV_PAR08) == 'N'
		MV_PAR08 := '1'
	EndIf

	If MV_PAR08 $ 'Não'
		cBloq := '2'
	Else
		cBloq := '1'
	EndIf
	
	If Valtype(MV_PAR09) == 'N'
		MV_PAR09 := '1'
	EndIf

	If MV_PAR09 $ 'Restore'
		MV_PAR09 := '2'
	Else
		MV_PAR09 := '1'
	EndIf

/*For nX := 1 To Len(aMa280FLock)
	If !MA280FLock(aMa280FLock[nX])
		lLockTabs := .F.
		Exit
	Endif
Next*/

	lLockTabs := .T.

	If lLockTabs
		If Empty(aRet)
			lRet := AjustaPerg()
		EndIf
		If MV_PAR09 == '1'
			If aviso("Atualizar Preço Venda","Confirma Atualização do preço de venda?" ,{"SIM","NAO"},3)=1
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial('SB1') +If(Empty(MV_PAR01),Alltrim(MV_PAR01),MV_PAR01)))
			
					While !SB1->(Eof()) .And. SB1->B1_COD >= MV_PAR01 .And. SB1->B1_COD <= MV_PAR02
				
						IF Alltrim(SB1->B1_GRUPO) >= MV_PAR03 .And. Alltrim(SB1->B1_GRUPO) <= MV_PAR04
					
							If cTabInt <> 'T'
								If SB1->B1_TAB_IN  <> cTabInt
									SB1->(DbSkip())
									Loop
								EndIf
							EndIf
					
							If cTabEnt <> 'T'
								If SB1->B1_TABELA <> cTabEnt
									SB1->(DbSkip())
									Loop
								EndIf
							EndIf
					
							If cTabEnt <> 'T'
								If SB1->B1_TABELA <> cTabEnt
									SB1->(DbSkip())
									Loop
								EndIf
							EndIf
					
							If cBloq == '2' .And. SB1->B1_MSBLQL == '1'
								SB1->(DbSkip())
								Loop
							EndIf
					
							If nTpCusto == 1
								nCusto := SB1->B1_CUSTD
							ElseIf nTpCusto == 2
								nCusto := SB1->B1_CUSTAB
							Else
								SB9->(DbSetOrder(1))
								If SB9->(Dbseek(xFilial('SB9') + SB1->B1_COD + SB1->B1_LOCPAD + dTos(dDataFech)))
									nCusto := SB9->B9_CM1
								EndIf
							EndIf
					
							nCoefic := POSICIONE('SZD',1,xFilial('SZD') + SB1->B1_ZZCDM,'ZD_MKUPD')
					
							If nCoefic == 0
								nPrcVen := 0
							Else
								nPrcVen := Round(nCusto / nCoefic,2)
							EndIf
										
							If Reclock('SB1',.F.)
								nPrcOld := SB1->B1_PRV1
								SB1->B1_PRV1 := nPrcVen
							
								If nPrcVen > 0
									If nTpCusto <> 2
										nCustoOld := SB1->B1_CUSTAB
										SB1->B1_CUSTAB := nCusto
									EndIf
								EndIF
							
								SHFAT011LOG(SB1->B1_COD,SB1->B1_DESC,nPrcVen,nPrcOld,nCusto,nCustoOld,SB1->B1_GRUPO)
							
								MsUnlock()
							EndIf
						EndIf
						SB1->(DbSkip())
					EndDo
			
				EndIf
			EndIf
		Else
			If aviso("Restore Preço Venda","Confirma Restore do preço de venda?" ,{"SIM","NAO"},3)=1
				
				cAliasCab := GetNextAlias()
				
				BeginSql Alias cAliasCab
					SELECT ZG_PRODUTO
					FROM %TABLE:SZG% SZG
					WHERE
					SZG.ZG_FILIAL  = %xFilial:SZG% AND
					SZG.ZG_PRODUTO BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND
					SZG.%NOTDEL%
					GROUP BY  ZG_PRODUTO
					ORDER BY  ZG_PRODUTO
				EndSql
				
				While !(cAliasCab)->(EoF())
				
					cAliasIte := GetNextAlias()
				
					BeginSql Alias cAliasIte
						SELECT *
						FROM %TABLE:SZG% SZG
						WHERE
						SZG.ZG_FILIAL  = %xFilial:SZG% AND
						SZG.ZG_PRODUTO = %EXP:(cAliasCab)->ZG_PRODUTO% AND
						SZG.ZG_CUSANT <> SZG.ZG_CUSNEW AND
						SZG.%NOTDEL%
						ORDER BY R_E_C_N_O_ DESC
					EndSql
				
					If !(cAliasIte)->(Eof())
						If SB1->(Dbseek(xFilial('SB1') + (cAliasIte)->ZG_PRODUTO))
							If Reclock('SB1',.F.)
								SB1->B1_PRV1   := (cAliasIte)->ZG_PRVANT
								SB1->B1_CUSTAB := (cAliasIte)->ZG_CUSANT
								MsUnlock()
							EndIf
						EndIf
					EndIf
					(cAliasIte)->(DbCloseArea())
					(cAliasCab)->(DbSkip())
				EndDo
				
				(cAliasCab)->(DbCloseArea())
				
			EndIf
		EndIf
	EndIf


Return

/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function SHFAT011LOG(cProduto,cDescricao,nPrcNew,nPrcAnt,nCusto,nCustoOld,cGrupo)
	
	SZG->(DBsetOrder(1))
	If Reclock('SZG',.T.)
		SZG->ZG_PRODUTO := cProduto
		SZG->ZG_DESCRIC := cDescricao
		SZG->ZG_GRUPO   := cGrupo
		SZG->ZG_PRVANT  := nPrcAnt
		SZG->ZG_PRVNEW  := nPrcNew
		SZG->ZG_CUSANT  := nCustoOld
		SZG->ZG_CUSNEW  := nCusto
		SZG->ZG_USERPRO := Alltrim(UPPER(UsrFullName(__cUserID)))
		SZG->ZG_DATA    := dDataBase
		SZG->(MsUnlock())
	EndIf

Return

/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
	Local cPerg		:= "SHFAT011"
	Local lRet		:= .F.

	aParamBox:= {}

	aAdd(@aParamBox,{1,"Produto De?"	       ,Space(TamSx3('B1_COD')[1])   ,"","","SB1",""   , 100,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"Produto Ate?"          ,Space(TamSx3('B1_COD')[1])   ,"","","SB1",""   , 100,.F.})		// MV_PAR02
	aAdd(@aParamBox,{1,"Grupo De   "           ,Space(TamSx3('B1_GRUPO')[1]) ,"","","SBM",""   , 100,.F.})		// MV_PAR02
	aAdd(@aParamBox,{1,"Grupo Ate   "          ,Space(TamSx3('B1_GRUPO')[1]) ,"","","SBM",""   , 100,.F.})		// MV_PAR02
	aAdd(@aParamBox,{2,"Custo?"      ,1      ,aCombo,50,"",.F.}) && MV_PAR06
	aAdd(@aParamBox,{2,"Tabela Int?"      ,1 ,aComboInt,50,"",.F.}) && MV_PAR06
	aAdd(@aParamBox,{2,"Tabela Ext?"      ,1 ,aComboExt,50,"",.F.}) && MV_PAR06
	aAdd(@aParamBox,{2,"Produto Bloq.?"      ,1 ,aComboBlq,50,"",.F.}) && MV_PAR06
	aAdd(@aParamBox,{2,"Execuçao?"       ,1 ,aExecucao,50,"",.F.}) && MV_PAR06

	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

Return(lRet)
