#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE 'FWMVCDEF.CH'

&& Atualiza Cadastro de Cliente, Cabeçalho NF Saida.
User Function SHFAT006()
	Local cRegiao := ''
	Local nQtdReg := 0
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "SHFT006"
	Private aComboCli := {'Sim','Não'}
	Private aComboFat := {'Sim','Não'}


	Private aParamBox	:= {}


	aAdd(aSays,"Rotina para integracao gerencial.				")
	aAdd(aSays,"  												")
	aAdd(aSays,"                                            ")
	aAdd(aSays,"Clique no botao OK para continuar.			")

	aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
	aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(),FechaBatch() },"Aguarde... !!!" ) }})
	aAdd(aButtons,{2,.T.,{||  lOk := .F. ,FechaBatch() }})

	FormBatch(FunDesc(),aSays,aButtons)

Return

Static Function Processar
	Local cRegiao  := ''
	Local nQtdReg  := 0
	Local cCliente := ''
	Local cLoja    := ''
	Local cAlias   := GetNextAlias()
	Local cZona    := ''

	SA1->(DbSetOrder(1))
	SA1->(DbGotop())


	If Valtype(MV_PAR03) == 'N'
		MV_PAR03 := '1'
	EndIf

	If MV_PAR03 $ 'Não'
		MV_PAR03 := '2'
	EndIf
	
	If Valtype(MV_PAR04) == 'N'
		MV_PAR04 := '1'
	EndIf

	If MV_PAR04 $ 'Não'
		MV_PAR04 := '2'
	EndIf
	 
	While !SA1->(Eof())
	
		If Empty(SA1->A1_COD_MUN)
			SA1->(DbSkip())
			Loop
		EndIf
	
		cCliente := SA1->A1_COD
		cLoja := SA1->A1_LOJA
		cRegiao := SA1->A1_REGIAO
		
		If MV_PAR03 == '1'
			SZ8->(DbSetOrder(2))
			If SZ8->(DbSeek(xFilial('SZ8') + SA1->(A1_COD_MUN + A1_EST)))
				cRegiao := Alltrim(SZ8->Z8_CODNEW)
			EndIf
		
			If !Empty(cRegiao)
				If Reclock('SA1',.F.)
					SA1->A1_REGIAO := cRegiao
					MsUnlock()
				EndIf
			EndIF
		EndIf
		
		If MV_PAR04 == '1'
			BeginSql Alias cAlias
				%noparser%
				COLUMN F2_EMISSAO AS DATE
				SELECT *
				FROM  %TABLE:SF2% SF2
				WHERE
				SF2.F2_FILIAL  = %xfilial:SF2% AND
				SF2.F2_EMISSAO BETWEEN %EXP:DtoS(MV_PAR01)% AND %EXP:DtoS(MV_PAR02)% AND
				SF2.F2_CLIENTE = %EXP:cCliente% AND
				SF2.F2_LOJA = %EXP:cLoja% AND
				SF2.%NOTDEL%
			EndSql
		
			Count to nQtdReg
			(cAlias)->(dbGoTop())
			ProcRegua(nQtdReg)
		
			SF2->(DbSetORder(1))
			While !(cAlias)->(Eof())
				If SF2->(DbSeek(xFilial('SF2') + (cAlias)->F2_DOC+(cAlias)->F2_SERIE+(cAlias)->F2_CLIENTE+(cAlias)->F2_LOJA))
					If Reclock('SF2',.F.)
						IncProc("Atualizando Registro " + (cAlias)->F2_DOC + '-' + (cAlias)->F2_CLIENTE + '-' + (cAlias)->F2_LOJA )
						SF2->F2_REGIAO := cRegiao
						SF2->F2_ZZZONA := Substring(cRegiao,3,1)
						MsUnlock()
					EndIf
					(cAlias)->(DbSkip())
				EndIf
			EndDo
			SF2->(DbCloseArea())
		EndIf
		(cAlias)->(DbCloseArea())
	
		SA1->(DbSkip())
	EndDo

Return

/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	21/12/12
* Descricao		:	Rotina de integracao gerencial.
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
	Local cPerg		:= "SHFT006"
	Local lRet		:= .F.
	Local aRet 		:= {}

	aParamBox:= {}

	aAdd(@aParamBox,{1,"Data De"	  ,	StoD(""),"","","","", 50,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"Data Ate"	  ,	StoD(""),"","","","", 50,.F.})		// MV_PAR02
	aAdd(@aParamBox,{2,"Atu. Cliente?",1 ,aComboCli,50,"",.F.}) && MV_PAR06
	aAdd(@aParamBox,{2,"Atu. Notas?"  ,1 ,aComboFat,50,"",.F.}) && MV_PAR06

	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	EndIf

Return(lRet)

