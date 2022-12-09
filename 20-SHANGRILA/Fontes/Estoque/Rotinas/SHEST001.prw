#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*
* Funcao		:	SHEST001
* Autor			:	João Zabotto
* Data			: 	03/12/2013
* Descricao		:	Rotina para atualizar a data final na estrutura do produto.
* Retorno		: 	Nil
*/

User Function SHEST001(lAuto)
Local aSays   		:= {}
Local aButtons 		:= {}
Local cPerg    		:= "SHEST001"
Local lOk           := .F.
Private cCampo      := ""
Private aParamBox	:= {}
Private aRet      := {}

Default lAuto     := .F.

If !lAuto
	aAdd(aSays," Rotina Responsével por Atualizar Estrutura do produto se o mesmo for estiver bloqueado.	")
	aAdd(aSays,"             																")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Desenvolvido Por João Zabotto - Totvs IP   								")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Clique no botao OK para continuar.											")
	
	aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
	aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(lAuto),FechaBatch() },"Aguarde... !!!" ) }})
	aAdd(aButtons,{2,.T.,{||  lOk := .F. ,FechaBatch() }})
	
	FormBatch(FunDesc(),aSays,aButtons)
Else
	Processar(lAuto)
EndIF

If lOk
	Aviso('Atualização','Atualização Estrutura Efetuado com Sucesso!',{'OK'})
EndIf

Return

Static Function Processar(lAuto)
Local lRet     := .T.
Local cAlias   := GetNextAlias()
Local nCount   := 0
Local dDataVld := cTod('')

If lAuto
	MV_PAR01 := SB1->B1_COD
	MV_PAR02 := SB1->B1_COD
	MV_PAR03 := dDataBase
EndIf

dDataVld   := LastDay(MonthSub( MV_PAR03 , 1 ))

BeginSql Alias cAlias
	SELECT *
	FROM %TABLE:SB1% SB1
	WHERE
	SB1.B1_FILIAL = %xFilial:SB1% AND
	SB1.B1_COD BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND
	SB1.B1_MSBLQL = %EXP:'1'% AND
	SB1.%NOTDEL%
	ORDER BY B1_COD
EndSql

Count to nCount
(cAlias)->(dBGoTop())

ProcRegua(nCount)

SB1->(DbSetOrder(1))
While !(cAlias)->(Eof())
	IF (cAlias)->B1_MSBLQL <> '1'
		(cAlias)->(DbSkip())
		Loop
	EndIf
	IncProc('Atiualizando Estrutura do Produto: ' + (cAlias)->B1_COD )
	
	SG1->(DbSetOrder(1))
	If SG1->(DbSeek(xFilial('SG1') + (cAlias)->B1_COD))
		While !SG1->(Eof()) .And. SG1->G1_COD == (cAlias)->B1_COD
			If SG1->G1_FIM >= dDataVld
				If Reclock('SG1',.F.)
					SG1->G1_FIM := dDataVld
					SG1->(MsUnlock())
				EndIf
			EndIf
			SG1->(DbSkip())
		EndDo
	EndIf
	
	(cAlias)->(DbSkip())
EndDo

(cAlias)->(dBCloseArea())

Return .T.


/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
Local cPerg		:= "SHEST001"
Local lRet		:= .F.

aParamBox:= {}

aAdd(@aParamBox,{1,"Produto De"	       ,Space(TamSx3('B1_COD')[1])   ,"","","SB1",""   , 100,.F.})		// MV_PAR01
aAdd(@aParamBox,{1,"Produto Ate"          ,Space(TamSx3('B1_COD')[1])   ,"","","SB1",""   , 100,.F.})		// MV_PAR02
aAdd(@aParamBox,{1,"Data Final"	,	dDataBase ,"","","","", 50,.F.})		// MV_PAR01

If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
	lRet := .T.
Else
	lRet := .F.
EndIf

Return(lRet)
