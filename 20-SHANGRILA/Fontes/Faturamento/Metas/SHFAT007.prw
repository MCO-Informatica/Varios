#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	22/01/2014
* Descricao		:	
* Retorno		: 	
*/
User Function SHFAT007(cCodigo,cAno)
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Private cPerg    		:= "SHREAJUS"
	Private cCampo := ""
	Private aParamBox	:= {}
	Private aCombo    := {'Valor Pmv','Quantidade'}
	Private aRet      := {}

	aAdd(aSays," Rotina Responsével por efetuar o reajuste nos itens do cadastro do Budget	")
	aAdd(aSays,"             																")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Desenvolvido Por João Zabotto - Totvs IP   								")
	aAdd(aSays,"                                            								")
	aAdd(aSays," Clique no botao OK para continuar.											")

	aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
	aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(MV_PAR07,MV_PAR08),FechaBatch() },"Aguarde... !!!" ) }})
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
	Local cPerg		:= "SHREAJUS"
	Local lRet		:= .F.
	Local bValid    := {|| Iif(ApOleClient("MsExcel"),.T.,(MsgInfo("MsExcel não instalado"),)) }

	aParamBox:= {}

	aAdd(@aParamBox,{1,"Produto De"   	,Space(TamSx3('B1_COD')[1])  ,""    ,"","SB1","", 50,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"Produto Ate"    ,Space(TamSx3('B1_COD')[1])  ,""    ,"","SB1","", 50,.F.})		// MV_PAR02
	aAdd(@aParamBox,{1,"Grupo De"	 	,Space(TamSx3('B1_GRUPO')[1]),""    ,"","SBM","", 50,.F.})		// MV_PAR03
	aAdd(@aParamBox,{1,"Grupo Ate"	 	,Space(TamSx3('B1_GRUPO')[1]),""    ,"","SBM","", 50,.F.})		// MV_PAR04
	aAdd(@aParamBox,{2,"Reajusta Por" 	,1      					 ,{"Valor PMV", "Quantidade"},50,""   ,.F.       }) && MV_PAR05
	aAdd(@aParamBox,{1,"Percentual"	    ,TamSx3('B1_PICM')[1]       ,'@! 999.99'    ,"","","", 50,.T.})		// MV_PAR06
	aAdd(@aParamBox,{1,"Codigo BudGet"  ,Space(TamSx3('Z5_CODIGO')[1])      ,''    ,"","SZ5","", 50,.T.})		// MV_PAR07
	aAdd(@aParamBox,{1,"Ano"            ,Space(TamSx3('Z5_ANO')[1] )     ,''    ,"","","", 50,.T.})		// MV_PAR08


	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

	Return(lRet)

Static Function Processar(cCodigo,cAno)
	Local nCount := 0
	Local nValAju:= 0
	Local lRet   := .T.
	Local nValPre := 0

	SZ6->(DbSetOrder(2))
	SZ6->(DbSeek(xFilial('SZ6') + cCodigo + If(Empty(MV_PAR01),'',MV_PAR01) ))

	Count to nCount

	If Empty(aRet)
		lRet := AjustaPerg()
	EndIf

	ProcRegua(0)

	If lRet
		While !SZ6->(Eof()) .And. SZ6->Z6_FILIAL == xFilial('SZ6') .And. SZ6->Z6_PRODUTO >= MV_PAR01 .And. SZ6->Z6_PRODUTO <= MV_PAR02 .And. ;
		SZ6->Z6_CODIGO >= cCodigo .And. SZ6->Z6_CODIGO <= cCodigo  

			IncProc("Processando Reajuste: " + SZ6->Z6_PRODUTO )

			If SZ6->Z6_GRUPO >= MV_PAR03 .And. SZ6->Z6_GRUPO <= MV_PAR04
				If Reclock('SZ6',.F.)
					If Alltrim(cValtoChar(aRet[5])) = '1'
						If MV_PAR06 < 0
							nValAju := SZ6->Z6_VLRPMV - ((SZ6->Z6_VLRPMV * Abs(MV_PAR06)) / 100)
						Else
							nValAju := SZ6->Z6_VLRPMV + ((SZ6->Z6_VLRPMV * MV_PAR06) / 100)
						EndIf
						SZ6->Z6_VLRPMV := nValAju
						SZ6->Z6_VALOR  := nValAju * SZ6->Z6_QUANT
							
					Else
						If MV_PAR06 < 0
							nValAju := Round(SZ6->Z6_QUANT - ((SZ6->Z6_QUANT * Abs(MV_PAR06)) / 100),0)
						Else
							nValAju := Round(SZ6->Z6_QUANT + ((SZ6->Z6_QUANT * MV_PAR06) / 100),0)
						EndIF

						SZ6->Z6_QUANT  := nValAju
						SZ6->Z6_VALOR  := nValAju * SZ6->Z6_VLRPMV
						
					EndIF
					MsUnlock()
				EndIf
			EndIf
			nValPre += SZ6->Z6_VALOR
			SZ6->(DbSkip())
		EndDo
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial('SZ5') + cCodigo))
			If Reclock('SZ5',.F.)
				SZ5->Z5_VLRPRE  := nValPre
				MsUnlock()
			EndIf
		EndIf
	EndIf

	Return


User Function ExempParam()

	Local aPergs := {}
	Local cCodRec := space(08)
	Local aRet := {}
	Local lRet
	aAdd( aPergs ,{1,"Recurso : ",cCodRec,"@!",'.T.',,'.T.',40,.F.})
	aAdd( aPergs ,{2,"Recurso Para",1, {"Projeto", "Tarefa"}, 50,'.T.',.T.})
	aAdd( aPergs ,{3,"Considera Sabado/Domingo",1, {"Sim", "Nao"}, 50,'.T.',.T.})
	aAdd( aPergs ,{4,"Enviar e-mail",.T., "usuario@totvs.com.br", 80,'.T.',.T.})
	aAdd( aPergs ,{5,"Recurso Bloqueado",.T., 90,'.T.',.T.})

	If ParamBox(aPergs ,"Parametros ",aRet)
		Alert("Pressionado OK")
		lRet := .T.
	Else
		Alert("Pressionado Cancel")
		lRet := .F.
	EndIf
	Return lRet
