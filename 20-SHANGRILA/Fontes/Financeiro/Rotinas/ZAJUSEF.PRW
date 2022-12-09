#INCLUDE "PROTHEUS.CH"

/*
* Funcao		:	ZGERSB5
* Autor			:	João Zabotto
* Data			: 	29/04/2015
* Descricao		:	Rotina responsável por gerar as informações
* Retorno		: 	
*/
User Function ZGERSEF()

	
	Local   cTexto := ""
	Local   cDado  := ""
	Local   aDados := {}
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "ZGERSEF"
	Private cCampo := ""
	Private aParamBox	:= {}

	aAdd(aSays,"Rotina para ajustar data da liberação do cheque para contabilização.	")
	aAdd(aSays,"             ")
	aAdd(aSays,"                                            ")
	aAdd(aSays," Desenvolvido Por João Zabotto - Totvs IP   ")
	aAdd(aSays,"                                            ")
	aAdd(aSays," Clique no botao OK para continuar.			")

	aAdd(aButtons,{5,.T.,{|| AjustaPerg() }})
	aAdd(aButtons,{1,.T.,{|| Processa({|lEnd| lOk := Processar(),FechaBatch() },"Aguarde... !!!" ) }})
	aAdd(aButtons,{2,.T.,{||  lOk := .F. ,FechaBatch() }})
	
	FormBatch(FunDesc(),aSays,aButtons)
	
	Aviso('Atualização Data dos Cheques','Processo Finalizado',{'OK'})


Return

/*
* Funcao		:	Processar
* Autor			:	João Zabotto
* Data			: 	29/04/2015
* Descricao		:	Ecexecuta a rotina com os parametros informado
* Retorno		: 	
*/
Static Function Processar()

	Local cAlias		:= GetNextAlias()
	Local aQuery		:= {}
	Local aDados		:= {}
	Local nOpcao		:= 0
	Local cProc         := ''
	Local cRet			:= ''
	Local lRet			:= .T.

	BeginSql Alias cAlias
		%noparser%
		COLUMN E5_DATA AS DATE
		SELECT E5_DATA,SEF.R_E_C_N_O_ SEFRECNO
		FROM %TABLE:SE5% SE5
		INNER JOIN %TABLE:SEF% SEF ON
		SEF.EF_FILIAL = %xFilial:SEF% AND
		SEF.EF_CART = ' ' AND
		SEF.EF_PREFIXO =  SE5.E5_PREFIXO AND
		SEF.EF_TITULO = SE5.E5_NUMERO AND
		SEF.EF_PARCELA = SE5.E5_PARCELA AND
		SEF.EF_TIPO = SE5.E5_TIPO AND
		SEF.EF_BANCO = SE5.E5_BANCO AND
		SEF.EF_AGENCIA = SE5.E5_AGENCIA AND
		SEF.EF_CONTA = SE5.E5_CONTA AND
		SEF.EF_NUM = SE5.E5_NUMCHEQ AND
		SEF.%NOTDEL%
		WHERE
		SE5.E5_DATA <> SEF.EF_DATA AND
		SE5.E5_FILIAL = %xFilial:SE5% AND
		SE5.E5_DATA   BETWEEN  %EXP:MV_PAR01% AND  %EXP:MV_PAR02% AND
		SE5.E5_TIPODOC =  %EXP:'CH'% AND
		SE5.E5_SITUACA <>  %EXP:'C'% AND
		SE5.%NOTDEL%
		ORDER BY SE5.E5_DATA
	EndSql

	aQuery := GETLastQuery()

	BeginTran()
	
		While !(cAlias)->(Eof())
		
			cProc := "UPDATE " + RetSqlName('SEF')
			cProc += " SET EF_ZZDATA = EF_DATA, EF_DATA = '" + DTOS((cAlias)->(E5_DATA)) + "'"
			cProc += " WHERE EF_FILIAL = '" + xFilial('SEF') + "'"
			cProc += " AND R_E_C_N_O_ = " + cValtoChar((cAlias)->(SEFRECNO))
 		
			cRet :=  TcSQLExec(cProc)
			
			If !(cRet==0)
				cRet = TCSQLERROR()
				lRet := .F.
			Else
				lRet := .T.
			EndIf
		
			(cAlias)->(dbSkip())
		EndDo
	 
		(cAlias)->(dbCloseArea())

		If lRet
		EndTran()
	Else
		DisarmTransaction()
	EndIf

Return .T.

/*
* Funcao		:	ZCADSB5
* Autor			:	João Zabotto
* Data			: 	29/04/2015
* Descricao		:	Montagem do ExecAuto
* Retorno		: 	
*/
Static Function ZCADSB5(aDados,nOpcao)
	Local aArea       := GetArea()
	Local lRet              := .F.
	Local cRet              := ''
      
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
            
	MSExecAuto({|x,y| Mata180(x,y)}, aDados,nOpcao)

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		RollBackSx8()
		lRet := .F.
	Else
		lRet := .T.
	EndIf
      
Return lRet


/*
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	29/04/2015
* Descricao		:	Cria as perguntas da rotina
* Retorno		: 	
*/
Static Function AjustaPerg()
	Local cPerg		:= "ZGER001"
	Local lRet		:= .F.
	Local aRet 		:= {}

	aParamBox:= {}

	aAdd(@aParamBox,{1,"Data De"	,	StoD(""),"","","","", 50,.F.})		&& MV_PAR01
	aAdd(@aParamBox,{1,"Data Ate"	,	StoD(""),"","","","", 50,.F.})		&& MV_PAR02

	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	EndIf

Return(lRet)