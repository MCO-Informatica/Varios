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
* Descricao		:	Atualiza CDM no produto
* Retorno		: 	Nenhum
*/
User Function SHFAT015()
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "SHFT10RE"
	Private cCampo      := ""
	Private aParamBox	:= {}
	Private aCombo    := {'Standard','Tabela','Médio'}
	Private aComboInt := {'Sim','Não','Todos'}
	Private aComboExt := {'Sim','Não','Todos'}
	Private aComboBlq := {'Sim','Não'}
	Private aPeriodo  := {'12 Meses','24 Meses','36 Meses'}
	Private aRet      := {}

	aAdd(aSays," Rotina Responsével por Atualizar o calor do CDM no cadastro de produto.	")
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
	Local cAlias := GetNextAlias()

	BeginSql Alias cAlias
		SELECT *
		FROM %TABLE:SB1% SB1
		INNER JOIN  %TABLE:SZD% SZD ON B1_ZZCDM = ZD_CODIGO AND SZD.%NOTDEL%
		WHERE
		SB1.B1_FILIAL = %xFilial:SB1% AND
		SB1.B1_ZZCDM BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND
		SB1.%NOTDEL%
		ORDER BY B1_COD
	EndSql

	ProcRegua(0)

	SB1->(DbSetOrder(1))
	While !(cAlias)->(Eof())
		IF SB1->(DbSeek(xFilial('SB1') + (cAlias)->B1_COD))
			IncProc('Atiualizando Mackup Poruduto: ' + (cAlias)->B1_COD )
			If Reclock('SB1',.F.)
				SB1->B1_ZZMKUPD := (cAlias)->ZD_MKUPD
				SB1->B1_ZZMKUPM := (cAlias)->ZD_MKUPM
			EndIF
		EndIf
		(cAlias)->(DbSkip())
	EndDo


	Return


/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
	Local cPerg		:= "SHFAT015"
	Local lRet		:= .F.

	aParamBox:= {}

	aAdd(@aParamBox,{1,"CDM De?"	       ,Space(TamSx3('ZD_CODIGO')[1])   ,"","","",""   , 100,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"CDM Ate?"          ,Space(TamSx3('ZD_CODIGO')[1])   ,"","","",""   , 100,.F.})		// MV_PAR02

	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

	Return(lRet)
