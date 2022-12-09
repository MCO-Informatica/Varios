#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

Static aIndSZ6
Static lCopia

User Function SHFAT014()

Local aSays   		:= {}
Local aButtons 		:= {}
Local cPerg    		:= "SHFAT014"
Private cCampo      := ""
Private aParamBox	:= {}
Private aRet      := {}

aAdd(aSays," Rotina Responsável por efetuar a Efetivação da Meta de Vendas Mes a Mes		")
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
Local cPerg		:= "SHFAT014"
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

Static Function Processar()

Local lRet := .T.
Local aQuery := {}
Local nX := 0
Local lOpc   := .T.
Local aMes   := SHGETPER(MV_PAR01,MV_PAR02)
Local cAliasPrev		:= ''
Local cAliasReg			:= ''
Local cAno   := cValtoChar(Year(MV_PAR01))
Local cSeq   := 0
Local cAlias	:= GetNextAlias()
Local nCount := 0
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.


For nX := 1 To Len(aMes)
	BeginSql Alias cAlias
		%noparser%
		COLUMN ZF_DATA AS DATE
		SELECT *
		FROM %TABLE:SZF% SZF
		WHERE
		SZF.ZF_FILIAL = %xFilial:SZF% AND
		SZF.ZF_DATA BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND
		SZF.ZF_DOC = %EXP:Alltrim(Subs(aMes[nX],1,2) + Subs(aMes[nX],4,4) )% AND
		SZF.%NOTDEL%
		ORDER BY ZF_DATA
	EndSql
	
	aQuery := GETLastQuery()
	
	Count To nCount
	
	(cAlias)->(DbGotop())
	
	ProcRegua(nCount)
	
	SCT->(DbSetOrder(1))
	If SCT->(DbSeek(xFilial('SCT') + Padr(Alltrim((cAlias)->ZF_DOC),TamSx3('CT_DOC')[1]) + (cAlias)->ZF_SEQUEN))
		lOpc := .F.
	Else
		lOpc := .T.
	EndIf
	
	While !(cAlias)->(Eof())
		IncProc('Efetivando Meta Venda Do Mês: ' +  MesExtenso(Month(FirstDate( CTOD("'01/" +  aMes[nX] + "'") ))) + ' do Ano: ' + cAno )
		If Reclock('SCT',lOpc)
			SCT->CT_FILIAL		:= xFilial('SCT')
			SCT->CT_DOC			:= (cAlias)->ZF_DOC
			SCT->CT_SEQUEN		:= (cAlias)->ZF_SEQUEN
			SCT->CT_DESCRI 		:= (cAlias)->ZF_DESCRI
			SCT->CT_REGIAO 		:= (cAlias)->ZF_REGIAO
			SCT->CT_CCUSTO 		:= (cAlias)->ZF_CCUSTO
			SCT->CT_ITEMCC 		:= (cAlias)->ZF_ITEMCC 
			SCT->CT_VEND   		:= (cAlias)->ZF_VEND
			SCT->CT_DATA		:= (cAlias)->ZF_DATA
			SCT->CT_GRUPO  		:= (cAlias)->ZF_GRUPO
			SCT->CT_TIPO   		:= (cAlias)->ZF_TIPO
			SCT->CT_PRODUTO		:= (cAlias)->ZF_PRODUTO
			SCT->CT_QUANT  		:= If((cAlias)->ZF_QUANT == 0,1,(cAlias)->ZF_QUANT)
			SCT->CT_VALOR  		:= (cAlias)->ZF_VALOR
			SCT->CT_MOEDA  		:= (cAlias)->ZF_MOEDA
			MsUnlock()
		EndIf
		(cAlias)->(DbSkip())
	EndDo
	
	(cAlias)->(DbCloseArea())
	
Next

Return lRet


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

