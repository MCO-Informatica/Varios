#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*
* Funcao		:	SHCTB001
* Autor			:	João Zabotto
* Data			: 	07/02/2014
* Descricao		:	Rotina responsável por gravar o item contábil cliente e fornecedor.
* Retorno		: 	SHCTB002(1)
*/
User Function SHCTB003()
Local aSays   		:= {}
Local aButtons 		:= {}
Local cPerg    		:= "SHCTB003"
Private cCampo      := ""
Private aParamBox	:= {}
Private aRet      := {}

aAdd(aSays," Rotina Responsável por efetuar a Copia do Rateio Off-Line					")
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

Static Function Processar()
Local cAliasCT2 := GetNextAlias()
Local cWhere    := '%'
Local nCount    := 0

cWhere += " SUBSTR(CT2_ORIGEM,1,7) = '610/001' AND CT2_DC <> '4' AND "
If !EmptY(Alltrim(MV_PAR03))
	cWhere += " CT2_HIST LIKE '%" + Alltrim(MV_PAR03) + '/' + Alltrim(MV_PAR04) + "%' AND "
EndIf
cWhere += '%'

BeginSql Alias cAliasCT2
	%noparser%
	SELECT *
	FROM %TABLE:CT2% CT2
	WHERE
	CT2.CT2_FILIAL  = %xFilial:CT2% AND
	CT2.CT2_DATA BETWEEN %EXP:DTOS(MV_PAR01)% AND %EXP:DTOS(MV_PAR02)% AND
	%EXP:cWhere%
	CT2.%NOTDEL%
	ORDER BY CT2_DATA
EndSql

Count to nCount

ProcRegua(nCount)

(cAliasCT2)->(DbGotop())

CT2->(DbSetOrder(1))
CV3->(DbSetOrder(1))
SD2->(DbSetOrder(1))
SF4->(DbSetOrder(1))
While !(cAliasCT2)->(Eof())
	IncProc()
	If CT2->(DbSeek(xFilial('CT2') + (cAliasCT2)->(CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+'01')))
		If CV3->(DbSeek(xFilial('CV3') + (cAliasCT2)->(CT2_DTCV3+CT2_SEQUEN)))
			SD2->(DbGoto(Val(CV3->CV3_RECORI)))
			If SD2->D2_TES <> MV_PAR05
				(cAliasCT2)->(dbSkip())
				Loop
			EndIf
			If SF4->(DbSeek(xFilial('SF4') + SD2->D2_TES))
				If Alltrim(CT2->CT2_CREDIT) <> Alltrim(SF4->F4_ZCTACRD)
					If Reclock('CT2',.F.)
						CT2->CT2_CREDIT := SF4->F4_ZCTACRD
						CT2->(MsUnlock())
						If CT2->(DbSeek(xFilial('CT2') + (cAliasCT2)->(CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+'05')))
							If Reclock('CT2',.F.)
								CT2->CT2_CREDIT := SF4->F4_ZCTACRD
								CT2->(MsUnlock())
							EndIf
						EndIF
					EndIf
				EndIF
			EndIf
		EndIF
	EndIf
	(cAliasCT2)->(dbSkip())
EndDo

(cAliasCT2)->(DbCloseArea())

Return

/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	11/09/2015
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
Local cPerg		:= "SHCTB003"
Local lRet		:= .F.

aParamBox:= {}

aAdd(@aParamBox,{1,"Data De?"	  ,StoD("")                      ,"","","",""   , 50,.F.})		// MV_PAR01
aAdd(@aParamBox,{1,"Data Ate?"    ,StoD("")                      ,"","","",""   , 50,.F.})		// MV_PAR02
aAdd(@aParamBox,{1,"Nota?"	  ,Space(TamSx3('D2_DOC')[1])    ,"","","",""   , 50,.F.})		// MV_PAR01
aAdd(@aParamBox,{1,"Serie?"	  ,Space(TamSx3('D2_SERIE')[1])  ,"","","",""   , 50,.F.})		// MV_PAR01
aAdd(@aParamBox,{1,"Tes?"	      ,Space(TamSx3('D2_SERIE')[1])  ,"","","",""   , 50,.F.})		// MV_PAR01

If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
	lRet := .T.
Else
	lRet := .F.
EndIf

Return(lRet)

