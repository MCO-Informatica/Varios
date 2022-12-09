#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "tbiconn.CH"
#INCLUDE "topconn.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
User Function CT270BUT()
	local aRotRat := {}

	AADD(aRotRat, {"Copia","U_SHCT270",0,6}) //Copia de TES
	
Return aRotRat

/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
User Function SHCT270()
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "SHCT270"
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

	aAdd(@aParamBox,{1,"Rateio De?"	          ,Space(TamSx3('CTQ_RATEIO')[1])    ,"","","CTQ",""   , 100,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"Rateio Ate?"	      ,Space(TamSx3('CTQ_RATEIO')[1])    ,"","","CTQ",""   , 100,.F.})		// MV_PAR01
		
	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

Return(lRet)

/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function Processar()
	Local aRegistro   := {}
	Local nPosicao    := 0
	Local lret        := .F.
	Local cNewRat     := ""
	Local nX          := 0
	Local cAliasC
	Local cAliasB
	Local nReg  := 0
	Local nCount  := 0
	Local cRet    := ''
	Local aDataCabec := {}
	Local aDataItem := {}
	Local aIem       := {}
	
	cAliasC := GetNextAlias()
	BeginSql Alias cAliasC
		%noparser%
		SELECT CTQ_RATEIO,CTQ_DESC,CTQ_TIPO,CTQ_CTPAR,CTQ_CCPAR,CTQ_ITPAR,CTQ_CLPAR,CTQ_CTORI,CTQ_CCORI,CTQ_ITORI,CTQ_CLORI,CTQ_MSBLQL
		FROM %TABLE:CTQ% CTQ
		WHERE
		CTQ.CTQ_RATEIO BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% AND
		CTQ.%NOTDEL%
		GROUP BY CTQ_RATEIO,CTQ_DESC,CTQ_TIPO,CTQ_CTPAR,CTQ_CCPAR,CTQ_ITPAR,CTQ_CLPAR,CTQ_CTORI,CTQ_CCORI,CTQ_ITORI,CTQ_CLORI,CTQ_MSBLQL
		ORDER BY CTQ_RATEIO
	EndSql
	
	While !(cAliasC)->(Eof())
		CTQ->(DbSetOrder(1))
		If CTQ->(DbSeek(xFilial('CTQ') + (cAliasC)->CTQ_RATEIO))
		
			aDataCabec := {}
			aDataItem  := {}
		
			cNewRat:= SH270SEQ((cAliasC)->CTQ_RATEIO)
			
			AADD(aDataCabec,	{"CCTQ_RATEIO"		,cNewRat			  ,NIL})
			AADD(aDataCabec,    {"CCTQ_DESC"	    ,(cAliasC)->CTQ_DESC  ,NIL})
			AADD(aDataCabec,    {"CCTQ_TIPO"	   	,(cAliasC)->CTQ_TIPO  ,NIL})
			AADD(aDataCabec,    {"CCTQ_CTPAR"	    ,(cAliasC)->CTQ_CTPAR  ,NIL})
			AADD(aDataCabec,    {"CCTQ_CCPAR"	    ,(cAliasC)->CTQ_CCPAR  ,NIL})
			AADD(aDataCabec,    {"CCTQ_ITPAR"	    ,(cAliasC)->CTQ_ITPAR  ,NIL})
			AADD(aDataCabec,    {"CCTQ_CLPAR"	    ,(cAliasC)->CTQ_CLPAR  ,NIL})
		
			AADD(aDataCabec,    {"CCTQ_CTORI"	    ,(cAliasC)->CTQ_CTORI  ,NIL})
			AADD(aDataCabec,    {"CCTQ_CCORI"	    ,(cAliasC)->CTQ_CCORI  ,NIL})
			AADD(aDataCabec,    {"CCTQ_ITORI"	    ,(cAliasC)->CTQ_ITORI  ,NIL})
			AADD(aDataCabec,    {"CCTQ_CLORI"	    ,(cAliasC)->CTQ_CLORI  ,NIL})
			AADD(aDataCabec,    {"NCTQ_PERBAS"	    ,100 ,NIL})
			AADD(aDataCabec,    {"CCTQ_MSBLQL"	    ,(cAliasC)->CTQ_MSBLQL ,NIL})
			
			cAliasB := GetNextAlias()
			BeginSql Alias cAliasB
				%noparser%
				SELECT *
				FROM %TABLE:CTQ% CTQ
				WHERE
				CTQ.CTQ_RATEIO = %EXP:(cAliasC)->CTQ_RATEIO% AND
				CTQ.%NOTDEL%
			EndSql
			
			While !(cAliasB)->(Eof())

				aIem := {}

				AADD(aIem,		{"CTQ_FILIAL"	,(cAliasB)->CTQ_FILIAL		,Nil})
				AADD(aIem,		{"CTQ_SEQUEN"	,(cAliasB)->CTQ_SEQUEN		,Nil})
				AADD(aIem,		{"CTQ_CTCPAR"	,(cAliasB)->CTQ_CTCPAR		,Nil})
				AADD(aIem,		{"CTQ_CCCPAR"	,(cAliasB)->CTQ_CCCPAR		,Nil})
				AADD(aIem,		{"CTQ_ITCPAR"	,(cAliasB)->CTQ_ITCPAR		,Nil})
				AADD(aIem,		{"CTQ_CLCPAR"	,(cAliasB)->CTQ_CLCPAR		,Nil})
				AADD(aIem,		{"CTQ_PERCEN"	,(cAliasB)->CTQ_PERCEN		,Nil})
				AADD(aIem,		{"CTQ_ZZKWHR"	,(cAliasB)->CTQ_ZZKWHR		,Nil})
	
				AaDd(aDataItem, aIem)
				
				(cAliasB)->(DbSkip())
			EndDo
			(cAliasB)->(DbCloseArea())
			
			SH270GRV(aDataCabec,aDataItem)
			
		Endif
		(cAliasC)->(DbSkip())
	EndDo
	(cAliasC)->(DbCloseArea())
	
Return lret

Static Function SH270SEQ(cRateio)

	Local cAliasS:= GetNextAlias()
	Local cIn := "% SUBSTR(CTQ_RATEIO,1,2) = '" + SUBSTR(cRateio,1,2) + "' %"
	Local cRet  := ''
	
	BeginSql Alias cAliasS
		%noparser%
		SELECT MAX(CTQ_RATEIO) CTQ_RATEIO
		FROM %TABLE:CTQ% CTQ
		WHERE
		%Exp:cIn% AND
		CTQ.%NOTDEL%
	EndSql
	
	If !(cAliasS)->(Eof())
		cRet := Soma1((cAliasS)->CTQ_RATEIO)
	EndIf
	
	(cAliasS)->(DbCloseArea())
Return cRet

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	24/01/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function SH270GRV(aCabec,aItens)

	Local aArea			:= GetArea()
	Local cRet			:= ""

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	MsExecAuto({|x,y,z|CTBA270(x,y,z)},aCabec,aItens,3)

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		RollBackSx8()
	Else
		
	EndIf
	
Return
