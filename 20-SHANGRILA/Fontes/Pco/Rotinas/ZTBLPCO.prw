#Include 'Protheus.ch'

/*
* Funcao		:	ZTBLPCO
* Autor			:	João Zabotto
* Data			: 	24/03/2014
* Descricao		:	Executa o compartilhamento das tabelas principais do PCOs
* Retorno		: 	
*/
User Function ZTBLPCO()

	Local   nI     := 0
	Local   cTexto := ""
	Local   cDado  := ""
	Local   aDados := {}
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "AGRPCO04"
	Private cCampo := ""
	Private aParamBox	:= {}

	aAdd(aSays,"Rotina para Compartilhamento das tabelas do módulo planejamento e Controle Orçamentário.	")
	aAdd(aSays,"             ")
	aAdd(aSays,"                                            ")
	aAdd(aSays," Desenvolvido Por João Zabotto - Totvs IP   ")
	aAdd(aSays,"                                            ")
	aAdd(aSays," Clique no botao OK para continuar.			")

	aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
	aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(),FechaBatch() },"Aguarde... !!!" ) }})
	aAdd(aButtons,{2,.T.,{||  lOk := .F. ,FechaBatch() }})

	FormBatch(FunDesc(),aSays,aButtons)


Return

Static Function Processar()
	Local aTabela := {}

	aAdd(aTabela,{'AK1' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AK2' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AK3' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AK4' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AK5' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AK6' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKB' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKC' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKD' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKE' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKF' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKG' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKH' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKI' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKJ' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKK' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKL' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKM' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKN' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKO' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKQ' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKR' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKS' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKT' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKV' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKW' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKX' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AKY' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL1' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL2' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL3' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL4' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL5' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL6' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL7' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL8' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AL9' + MV_PAR01 + '0'})
	aAdd(aTabela,{'ALF' + MV_PAR01 + '0'})
	aAdd(aTabela,{'ALG' + MV_PAR01 + '0'})
	aAdd(aTabela,{'ALH' + MV_PAR01 + '0'})
	aAdd(aTabela,{'ALK' + MV_PAR01 + '0'})
	aAdd(aTabela,{'ALL' + MV_PAR01 + '0'})
	aAdd(aTabela,{'ALM' + MV_PAR01 + '0'})
	aAdd(aTabela,{'AMF' + MV_PAR01 + '0'})
	
	SX2->(DbSetOrder(1))
	
	For nX := 1 to Len(aTabela)
	
		If SX2->(DbSeek(Substring(aTabela[nX,1],1,3)))
			If Reclock('SX2',.F.)
				SX2->X2_ARQUIVO := aTabela[nX,1]
				SX2->X2_MODO    := 'C'
				SX2->X2_MODOUN  := 'C'
				SX2->X2_MODOEMP := 'C'
				MsUnlock()
			EndIf
		EndIf
	Next
	

Return


/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
	Local cPerg		:= "ZTBLPCO"
	Local lRet		:= .F.
	Local aRet 		:= {}
	
	aParamBox:= {}

	aAdd(@aParamBox,{1,"Emp. Origem ?"	,Space(2),"","","ZM0","", 50,.F.})		// MV_PAR03
	aAdd(@aParamBox,{1,"Emp. Destino?"	,Space(2),"","","ZM0","", 50,.F.})		// MV_PAR04

	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	EndIf

Return(lRet)


