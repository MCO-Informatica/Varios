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
* Data			: 	21/01/2014
* Descricao		:	
* Retorno		: 	
*/
User Function FT050MNU()
	Local aRet := {}

	aAdd(aRet,{"Rateio","U_SHFAT017()",0,4,6})

Return aRet

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	21/01/2014
* Descricao		:	
* Retorno		: 	
*/
User Function SHFAT017()
	Local cPerg   := 'SHFAT017'
	
	ValidPerg(cPerg)
	If !pergunte(cPerg,.T.)
		Return
	Endif
	
	Processa({|lEnd|Processar()})
Return


/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	21/01/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function Processar()
	Local cAlias :=''
	Local aRetVen   := {}
	Local aRetPer   := {}
	Local aQuery    := {}
	Local aDados    := {}
	Local cDoc      := ''
	Local cDescr    := ''
	Local cRegiao   := ''
	Local cData     := ''
	Local cGrupo    := ''
	Local cTipo     := ''
	Local cProduto  := ''
	Local nQuant    := 0
	Local nValor    := 0
	Local cMoeda    := ''
	Local cSeq		:= ''
	Local nUnit		:= 0
	Local nRat		:= 0
	Local nReg		:= 0
	
	aRetVen := TrataCols(Alltrim(MV_PAR01),';',.F.)
	aRetPer := TrataCols(Alltrim(MV_PAR02),';',.T.)
	
	For nI := 1 to Len(aRetVen)
		aAdd(aDados,{aRetVen[nI],aRetPer[nI]})
	Next
	
	cAlias := GetNextAlias()
	BeginSql Alias cAlias
		SELECT *
		FROM %TABLE:SCT% SCT
		WHERE
		SCT.CT_FILIAL = %xFilial:SCT% AND
		SCT.CT_DATA  BETWEEN %Exp:DTOS(MV_PAR05)% AND %Exp:DTOS(MV_PAR06)% AND
		SCT.CT_REGIAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND
		SCT.%notDel%
		Order By CT_DOC , CT_SEQUEN
	EndSql
	
	Count to nReg
	
	(cAlias)->(DbGotop())
	
	ProcRegua(nReg)
	
	aQuery := GetLastQuery()
	cSeq := Soma1(GetMaxSeq())
	While !(cAlias)->(Eof())
		SCT->(DbSetOrder(3))
		If SCT->(DbSeek(xFilial('SCT') + (cAlias)->CT_DATA + (cAlias)->CT_REGIAO))
			
			cDoc      := SCT->CT_DOC
			cDescr    := SCT->CT_DESCRI
			cRegiao   := SCT->CT_REGIAO
			cData     := SCT->CT_DATA
			cGrupo    := SCT->CT_GRUPO
			cTipo     := SCT->CT_TIPO
			cProduto  := SCT->CT_PRODUTO
			nQuant    := SCT->CT_QUANT
			nValor    := SCT->CT_VALOR
			cMoeda    := SCT->CT_MOEDA
			nUnit     := SCT->CT_VALOR / SCT->CT_QUANT
			
			If Reclock('SCT',.F.)
				SCT->(DbDelete())
				SCT->(MsUnlock())
			EndIF
			
			For nX := 1 to Len(aDados)
				If Reclock('SCT',.T.)
					SCT->CT_FILIAL	:= xFilial('SCT')
					SCT->CT_DOC		:= cDoc
					SCT->CT_SEQUEN	:= cSeq
					SCT->CT_DESCRI	:= cDescr
					SCT->CT_REGIAO	:= cRegiao
					SCT->CT_DATA	:= cData
					SCT->CT_GRUPO	:= cGrupo
					SCT->CT_TIPO	:= cTipo
					SCT->CT_PRODUTO	:= cProduto
					nRat := (nQuant *  aDados[nX,2])/100
					If nRat <= 1 .And. nRat > 0
						nRat := 1
					Else
						nRat := Round(nRat,0)
					EndIf
					SCT->CT_QUANT	:= nRat
					SCT->CT_VALOR	:= nUnit * nRat
					SCT->CT_MOEDA	:= cMoeda
					SCT->CT_VEND	:= aDados[nX,1]
					SCT->(MsUnlock())
					cSeq := Soma1(cSeq)
				EndIf
			Next
		EndIF
		(cAlias)->(DbSkip())
	EndDo
	(cAlias)->(DbCloseArea())

Return

Static Function GetMaxSeq()
	Local cSeq := ''
	Local cAlias := GetNextAlias()
	
	BeginSql Alias cAlias
		SELECT MAX(CT_SEQUEN) CT_SEQUEN
		FROM %TABLE:SCT% SCT
		WHERE
		SCT.CT_FILIAL = %xFilial:SCT% AND
		SCT.CT_DATA  BETWEEN %Exp:DTOS(MV_PAR05)% AND %Exp:DTOS(MV_PAR06)% AND
		SCT.%notDel%
		Order By CT_SEQUEN
	EndSql
		
	If !(cAlias)->(Eof())
		cSeq := Alltrim((cAlias)->CT_SEQUEN)
	EndIf
		
	(cAlias)->(DbCloseArea())
Return cSeq

Static Function TrataCols(cLinha,cSep,lConv)
	Local aRet 		:= {}
	Local nPosSep	:= 0


	nPosSep	:= At(cSep,cLinha)
	While nPosSep <> 0
		AAdd(aRet, If(lConv,Val(SubStr(cLinha,1,nPosSep-1)),SubStr(cLinha,1,nPosSep-1))  )
		cLinha := SubStr(cLinha,nPosSep+1)
		nPosSep	:= At(cSep,cLinha)
	EndDo
	
Return aRet

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	21/01/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	DBSelectArea("SX1") ; DBSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cperg,"01","Vendedores:"		,"","","mv_ch1","C", 99,0,0,"R","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(aRegs,{cperg,"02","Perc. Rateio:"		,"","","mv_ch2","C", 99,0,0,"R","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"03","Regiao De:"		    ,"","","mv_ch3","C", 14,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZ8"})
	AADD(aRegs,{cperg,"04","Regiao Ate:"		,"","","mv_ch4","C", 14,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZ8"})
	AADD(aRegs,{cperg,"05","Data de :"	,"","","mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cperg,"06","Data ate:"	,"","","mv_ch6","D", 8,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])

			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
			

		EndIf
	Next
	DBSelectArea(_sAlias)
Return
