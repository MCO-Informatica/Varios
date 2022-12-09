#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndSZ6
Static lCopia


User Function SHFAT010()

	Local oBrowse	  := Nil
	Private cCadastro := 'Peso Item x Estado'  &&"Meta de Venda"
	Private bGera     := {|| U_SHFT10RE()}
	Private bGeraMeta := {|| U_SHFAT012() }

	&&AjustaHlp()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZB')
	oBrowse:SetDescription(cCadastro)  &&"Meta de Venda"
	oBrowse:Activate()

Return(.T.)


Static Function ModelDef()

	Local oModel
	Local oStruCab := FWFormStruct(1,'SZB')
	Local oStruGrid := FWFormStruct(1,'SZC')

	Local bActivate     := {|oMdl|SHFT010ACT(oMdl)}
	Local bPosValidacao := {||SHFT010Pos()}
	Local bCommit		:= {|oMdl|SHFT010Cmt(oMdl)}
	Local bCancel   	:= {|oMdl|SHFT010Can(oMdl)}
	Local bLinePost 	:= {||SHFTLinOk()}
	local aTrigger          := {}

	oStruGrid:RemoveField('ZC_CODIGO')
	oStruGrid:RemoveField('ZC_ANO')

	oModel := MPFormModel():New('SHFT010',/*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/)

	oModel:AddFields('SZBCAB',/*cOwner*/,oStruCab,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:AddGrid( 'SZCGRID','SZBCAB',oStruGrid,/*bLinePre*/,bLinePost,/*bPreVal*/,/*bPosVal*/)

	oModel:SetRelation("SZCGRID",{{"ZC_FILIAL",'xFilial("SZC")'},{"ZC_CODIGO","ZB_CODIGO"},{"ZC_ANO","ZB_ANO"}},SZC->(IndexKey(1)))
	oModel:SetPrimaryKey({'ZC_FILIAL','ZC_CODIGO','ZC_SEQUEN'})

	oModel:GetModel( 'SZCGRID' ):SetUniqueLine( { 'ZC_PRODUTO' } )

	oModel:SetActivate(bActivate)
	oModel:SetDescription(cCadastro)

Return(oModel)

Static Function ViewDef()

	Local oView

	Local oModel     := FWLoadModel('SHFAT010')
	Local oStruCab   := FWFormStruct(2,'SZB')
	Local oStruGrid  := FWFormStruct(2,'SZC')
	Local aCabExcel  := SHFT010Cab()  			&& Cria o cabecalho para utilizacao no Microsoft Excel
	Local aUsrBut    := {}     					&& recebe o ponto de entrada
	Local aButtons	 := {}                      && botoes da enchoicebar
	Local nAuxFor    := 0                       && auxiliar do For , contador da Array aUsrBut
	Local oMdlCab    := oModel:GetModel('SZBCAB')
	Local oMdlGrid   := oModel:GetModel('SZCGRID')
	Local aAux       := {}
	Local oCalc1

	oStruGrid:RemoveField('ZC_CODIGO')
	oStruGrid:RemoveField('ZC_ANO')

	oView:= FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('VIEW_CABZB',oStruCab,'SZBCAB')
	oView:AddGrid('VIEW_GRIDZC',oStruGrid,'SZCGRID' )


	oView:AddIncrementField('VIEW_GRIDZC','ZC_SEQUEN')

	oView:CreateHorizontalBox('SUPERIOR',20)
	oView:CreateHorizontalBox('INFERIOR',80)

	REGTOMEMORY("SZB",.T.)
	REGTOMEMORY("SZC",.T.)

	oView:SetOwnerView( 'VIEW_CABZB','SUPERIOR' )
	oView:SetOwnerView( 'VIEW_GRIDZC','INFERIOR' )



Return(oView)


Static Function MenuDef()
	Local aRotina :={}
	Local aUsrBut :={}
	Local nX := 0

	ADD OPTION aRotina TITLE 'Pesqusiar'  ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.SHFAT010'	OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.SHFAT010'	OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.SHFAT010'	OPERATION 5	ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Peso x Uf'		ACTION 'Eval(bGera)'   	    OPERATION 3	ACCESS 0

Return(aRotina)


Static Function SHFT010Act(oMdl)

	Local nOperation := oMdl:GetOperation()
	Local oMdlGrid := oMdl:GetModel('SZCGRID')

	Local nX := 0
	Private oMdlCab	:= oMdl:GetModel('SZBCAB')

	if nOperation == 3
		For nX:= 1 to oMdlGrid:GetQtdLine()
			oMdlGrid:GoLine(nX)
			oMdlGrid:SetValue("ZC_SEQUEN",cValToChar(StrZero(nX,TamSx3("ZC_SEQUEN")[1])),.T.)
		Next nX
		lCopia := .F.
	ElseIf nOperation == 4
		REGTOMEMORY("SZB",.T.)
		REGTOMEMORY("SZC",.T.)
	EndIf

Return(.T.)

Static Function SHFT010CAL( oFW, lPar )
	Local lRet := .T.

	If lPar
		lRet := .T.
	Else
		lRet := .F.
	EndIf
Return lRet


Static Function SHFT010Pos()
	Local lRet := .T.



Return(lRet)

Static Function SHFT010Cmt(oMdl)
	Local nOperation := oMdl:GetOperation()

	If nOperation == 3  .Or. nOperation == 5
		FWModelActive(oMdl)
		FWFormCommit(oMdl)
	Endif

	If nOperation == 4
		FWModelActive(oMdl)
		FWFormCommit(oMdl)
		SHFTGrvDesc(oMdl)
	EndIf

Return(.T.)

Static Function SHFT010Can(oMdl)

	Local nOperation:= oMdl:GetOperation()

	If nOperation == 3
		RollBackSX8()
	EndIf

Return(.T.)


Static Function SHFTGrvDesc(oMdl)


Return Nil

Static Function SHFT010Cab()

	Local aCabec := {}

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZB_CODIGO")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZB_DESCRI")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZB_ANO")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZB_PERCENT")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZB_ZONA")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})

Return(aCabec)

Static Function SHFTLinOk()

	Local oMdl		:= FWModelActive()
	Local oMdlCab	:= oMdl:GetModel('SZBCAB')
	Local oMdlGrid	:= oMdl:GetModel('SZCGRID')
	Local nPValor	:= 0
	Local lRet      := .T.
	Local aSaveLines:= FWSaveRows()
	Local nPQuant	:= oMdlGrid:GetValue('ZC_PERCENT') // quantidade

	For nX:= 1 to oMdlGrid:GetQtdLine()
		If !oMdlGrid:IsDeleted()
			oMdlGrid:GoLine(nX)
			nPValor	:= oMdlGrid:GetValue('ZC_PERCENT') // valor
			If nPValor < 100
				Aviso('Percentual Inconsistente','O Total distribuido deve ser igual a 100%',{'OK'})
				lRet := .F.
			EndIf
		EndIf
	Next


	FWRestRows( aSaveLines )

Return(lRet)

User Function SHFT10CAL( )

	Local oModel := FWModelActive()
	Local aArea  := GetArea()
	Local aAreaSB1 := SB1->( GetArea() )
	local nQuant := 0
	Local nValor := 0
	Local nValPmv:= 0
	Local nTotalPmv := 0
	Local nQuantPmv := 0
	Local aRetVen   := {}
	Local aRetVenQ  := {}
	Local aRetDev  	:= {}
	Local cCodBair  := ''
	Local oAux
	Local oStruct
	Local aAux   := {}
	Local nTotal := 0
	Local nMedia := 0
	Local nVlrAnt := oModel:GetErrorMessage()[9]
	Local nVlrNew := oModel:GetErrorMessage()[8]
	Local nValDist:= 0

	Local nQuant := 100 &&oModel:GetValue( 'SZCGRID','ZC_TOTAL') / oModel:GetValue( 'SZCGRID','ZC_QTDANO')

	nTotal += ;
		oModel:GetValue( 'SZCGRID','ZC_PERCSP') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCRJ') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCMG') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCES') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCPR') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCSC') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCRS') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCBA') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCSE') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCAL') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCPE') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCPB') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCRN') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCCE') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCPI') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCMA') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCPA') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCAP') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCAM') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCRR') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCMT') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCMS') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCGO') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCTO') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCDF') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCRO') +;
		oModel:GetValue( 'SZCGRID','ZC_PERCAC') +;
		oModel:GetValue( 'SZCGRID','ZC_PERISP') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIRJ') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIMG') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIES') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIPR') +;
		oModel:GetValue( 'SZCGRID','ZC_PERISC') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIRS') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIBA') +;
		oModel:GetValue( 'SZCGRID','ZC_PERISE') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIAL') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIPE') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIPB') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIRN') +;
		oModel:GetValue( 'SZCGRID','ZC_PERICE') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIPI') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIMA') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIPA') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIAP') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIAM') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIRR') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIMT') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIMS') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIGO') +;
		oModel:GetValue( 'SZCGRID','ZC_PERITO') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIDF') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIRO') +;
		oModel:GetValue( 'SZCGRID','ZC_PERIAC')

	nI := 0
	For nI := 1 To Len(aHeader)
		If Subs(aHeader[nI][2],1,6) $ 'ZC_PERC' .And. !aHeader[nI][2] $ 'ZC_PERCENT|' + ReadVar()
			If oModel:GetValue( 'SZCGRID',aHeader[nI][2])  > 0
				nMedia++
			EndIf
		EndIf
	Next nI

/*
If nVlrNew > nVlrAnt

nValDist := (nVlrNew - nVlrAnt) / nMedia

nI := 0
For nI := 1 To Len(aHeader)
If Subs(aHeader[nI][2],1,6) $ 'ZC_PERC' .And. !aHeader[nI][2] $ 'ZC_PERCENT|' + ReadVar()
If oModel:GetValue( 'SZCGRID',aHeader[nI][2])  > 0
oModel:LoadValue( 'SZCGRID', aHeader[nI][2], 	oModel:GetValue( 'SZCGRID',aHeader[nI][2]) - nValDist)
Else
oModel:LoadValue( 'SZCGRID', aHeader[nI][2], 	0)
EndIf
EndIf
Next nI

ElseIf nVlrNew < nVlrAnt

nValDist := (nVlrAnt - nVlrNew ) / nMedia

nI := 0
For nI := 1 To Len(aHeader)
If Subs(aHeader[nI][2],1,6) $ 'ZC_PERC' .And. !aHeader[nI][2] $ 'ZC_PERCENT|' + ReadVar()
If oModel:GetValue( 'SZCGRID',aHeader[nI][2])  > 0
oModel:LoadValue( 'SZCGRID', aHeader[nI][2], 	oModel:GetValue( 'SZCGRID',aHeader[nI][2]) + nValDist)
Else
oModel:LoadValue( 'SZCGRID', aHeader[nI][2], 	0)
EndIf
EndIf
Next nI

EndIf
*/

	oModel:LoadValue( 'SZCGRID', 'ZC_PERCENT', nTotal)


Return .T.

User Function SHFT10RE()
	Local aSays   		:= {}
	Local aButtons 		:= {}
	Local cPerg    		:= "SHFT10RE"
	Private cCampo      := ""
	Private cCodigo     := STRZERO(Val(U_SH003COD('SZB','ZB_CODIGO')),TamSx3('ZB_CODIGO')[1])
	Private aParamBox	:= {}
	Private aCombo    := {'Capital','Interior'}
	Private aPeriodo  := {'12 Meses','24 Meses','36 Meses'}
	Private aRet      := {}

	aAdd(aSays," Rotina Responsável por efetuar a Geração do Peso do Iem X Estado			")
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


/**
* Funcao		:	AjustaPerg
* Autor			:	João Zabotto
* Data			: 	31/07/13
* Descricao		:	Cria os parametros da rotina
* Retorno		: 	Nenhum
*/
Static Function AjustaPerg()
	Local cPerg		:= "SHFAT010"
	Local lRet		:= .F.

	aParamBox:= {}

	aAdd(@aParamBox,{1,"Data De?"	        ,StoD("")                      ,"","","",""   , 100,.F.})		// MV_PAR01
	aAdd(@aParamBox,{1,"Data Ate?"          ,StoD("")                      ,"","","",""   , 100,.F.})		// MV_PAR02
	aAdd(@aParamBox,{1,"Descriçao"          ,Space(TamSx3('ZB_DESCRI')[1]) ,"","","",""   , 100,.F.})		// MV_PAR02
	aAdd(@aParamBox,{1,"Ano"	 	        ,Space(TamSx3('ZB_ANO')[1])    ,"","","",""   , 100,.F.})		// MV_PAR03
	aAdd(@aParamBox,{1,"Código Budget"	    ,Space(TamSx3('Z6_CODIGO')[1]) ,"","","SZ5",""   , 100,.F.})		// MV_PAR03
	
	If ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,cPerg,.T.,.T.)
		lRet := .T.
	Else
		lRet := .F.
	EndIf

Return(lRet)

Static Function Processar()
	Local lRet      := .T.
	Local cAlias010 := GetNextAlias()
	Local aRetVen   := {}
	Local aRetVenQ  := {}
	Local aRetDev  	:= {}
	Local aRetDevQ  := {}
	Local nValPmv   := 0
	Local nCount    := 0
	Local nTotRat  := 0
	Local nReg 		:= 0
	local dDataIni  := cTod('01/01/' + Alltrim(MV_PAR04) )
	local dDataFim  := cTod('01/01/' + Alltrim(MV_PAR04) )
	Local aQuery    := {}
	Local nAnos     := DateDiffYear( MV_PAR01 , MV_PAR02 )
	Local nTotal    := 0
	Local nAno := 0
	Local nValor    := 0
	Local nDiv      := 0
	Local nPerc      := 0
	Local nPercSp    := 0
	Local aRetUF     := {}
	Local aMedia     := {}
	Local cNegocio   := ''
	
	Private nPercT := 0

	If Empty(aRet)
		lRet := AjustaPerg()
	EndIf
	If aviso("Geração Peso Por Estado","Confirma Geração Peso Por Estado para o Ano " + MV_PAR04 ,{"SIM","NAO"},3)=1
		If lRet
			BeginSql Alias cAlias010
				SELECT Z6_PRODUTO,B1_DESC,B1_GRUPO,B1_TIPO,SUM(Z6_QTDANT) AS Z6_QTDANT
				FROM %TABLE:SZ6% SZ6
				INNER JOIN %TABLE:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1% AND SZ6.Z6_PRODUTO = SB1.B1_COD AND SB1.%NOTDEL%
				WHERE
				SZ6.Z6_FILIAL = %xfilial:SZ6%
				AND SZ6.Z6_CODIGO = %EXP:MV_PAR05%
				AND SZ6.%NOTDEL%
				GROUP BY  Z6_PRODUTO,B1_DESC,B1_GRUPO,B1_TIPO
				ORDER BY  Z6_PRODUTO
			EndSql

			aQuery := GETLastQuery()

			Count to nReg
			(cAlias010)->(DbGotop())
			If !(cAlias010)->(Eof())
				If Reclock('SZB',.T.)
					SZB->ZB_FILIAL  := xFilial('SZB')
					SZB->ZB_CODIGO  := cCodigo
					SZB->ZB_DESCRI  := MV_PAR03
					SZB->ZB_ANO     := MV_PAR04
					MsUnlock()
				EndIf
			EndIf

			ProcRegua(nReg)

			SZB->(DbSetOrder(1))
			If SZB->(DbSeek(xFilial('SZB') + cCodigo))
				While !(cAlias010)->(Eof())
					nCount++
					IncProc("Processando Peso Estado: " + MV_PAR04 + ' - ' + Alltrim((cAlias010)->Z6_PRODUTO))

					nTotal := (cAlias010)->Z6_QTDANT
					cNegocio        := POSICIONE('SBM',1,xFilial('SBM') + (cAlias010)->B1_GRUPO,'BM_TIPGRU ')
					
					nPercT := 0
					aRetUf :=  U_SHFATQTD((cAlias010)->Z6_PRODUTO,(cAlias010)->B1_GRUPO,MV_PAR01,MV_PAR02,@nTotal,@nAno,cNegocio)


					If Reclock('SZC',.T.)
						SZC->ZC_FILIAL  := xFilial('SZ5')
						SZC->ZC_CODIGO  := cCodigo
						SZC->ZC_ANO     := MV_PAR04
						SZC->ZC_SEQUEN  := StrZero(nCount,3)
						SZC->ZC_PRODUTO := (cAlias010)->Z6_PRODUTO
						SZC->ZC_DESCRI  := (cAlias010)->B1_DESC
						SZC->ZC_GRUPO   := (cAlias010)->B1_GRUPO
						SZC->ZC_TIPO    := (cAlias010)->B1_TIPO
						cNegocio        := POSICIONE('SBM',1,xFilial('SBM') + (cAlias010)->B1_GRUPO,'BM_TIPGRU ')
						SZC->ZC_NEGOCIO := cNegocio

						If Len(aRetUf) <= 0
							AaDd(aMedia,{SZC->ZC_CODIGO,SZC->ZC_ANO,SZC->ZC_PRODUTO,SZC->ZC_GRUPO})
						EndIf
						
						SZC->ZC_PERCSP  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SP'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SP'}) ][6])
						SZC->ZC_PERCRJ  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RJ'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RJ'}) ][6])
						SZC->ZC_PERCMG  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MG'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MG'}) ][6])
						SZC->ZC_PERCES  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'ES'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'ES'}) ][6])
						SZC->ZC_PERCPR  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PR'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PR'}) ][6])
						SZC->ZC_PERCSC  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SC'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SC'}) ][6])
						SZC->ZC_PERCRS  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RS'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RS'}) ][6])
						SZC->ZC_PERCBA  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'BA'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'BA'}) ][6])
						SZC->ZC_PERCSE  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SE'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SE'}) ][6])
						SZC->ZC_PERCAL  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AL'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AL'}) ][6])
						SZC->ZC_PERCPE  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PE'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PE'}) ][6])
						SZC->ZC_PERCPB  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PB'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PB'}) ][6])
						SZC->ZC_PERCRN  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RN'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RN'}) ][6])
						SZC->ZC_PERCCE  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'CE'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'CE'}) ][6])
						SZC->ZC_PERCPI  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PI'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PI'}) ][6])
						SZC->ZC_PERCMA  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MA'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MA'}) ][6])
						SZC->ZC_PERCPA  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PA'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PA'}) ][6])
						SZC->ZC_PERCAP  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AP'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AP'}) ][6])
						SZC->ZC_PERCAM  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AM'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AM'}) ][6])
						SZC->ZC_PERCRR  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RR'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RR'}) ][6])
						SZC->ZC_PERCMT  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MT'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MT'}) ][6])
						SZC->ZC_PERCMS  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MS'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MS'}) ][6])
						SZC->ZC_PERCGO  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'GO'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'GO'}) ][6])
						SZC->ZC_PERCTO  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'TO'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'TO'}) ][6])
						SZC->ZC_PERCDF  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'DF'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'DF'}) ][6])
						SZC->ZC_PERCRO  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RO'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RO'}) ][6])
						SZC->ZC_PERCAC  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AV'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AC'}) ][6])


						SZC->ZC_PERISP  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SP'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SP'}) ][7])
						SZC->ZC_PERIRJ  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RJ'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RJ'}) ][7])
						SZC->ZC_PERIMG  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MG'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MG'}) ][7])
						SZC->ZC_PERIES  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'ES'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'ES'}) ][7])
						SZC->ZC_PERIPR  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PR'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PR'}) ][7])
						SZC->ZC_PERISC  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SC'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SC'}) ][7])
						SZC->ZC_PERIRS  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RS'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RS'}) ][7])
						SZC->ZC_PERIBA  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'BA'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'BA'}) ][7])
						SZC->ZC_PERISE  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SE'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'SE'}) ][7])
						SZC->ZC_PERIAL  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AL'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AL'}) ][7])
						SZC->ZC_PERIPE  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PE'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PE'}) ][7])
						SZC->ZC_PERIPB  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PB'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PB'}) ][7])
						SZC->ZC_PERIRN  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RN'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RN'}) ][7])
						SZC->ZC_PERICE  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'CE'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'CE'}) ][7])
						SZC->ZC_PERIPI  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PI'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PI'}) ][7])
						SZC->ZC_PERIMA  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MA'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MA'}) ][7])
						SZC->ZC_PERIPA  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PA'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'PA'}) ][7])
						SZC->ZC_PERIAP  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AP'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AP'}) ][7])
						SZC->ZC_PERIAM  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AM'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AM'}) ][7])
						SZC->ZC_PERIRR  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RR'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RR'}) ][7])
						SZC->ZC_PERIMT  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MT'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MT'}) ][7])
						SZC->ZC_PERIMS  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MS'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'MS'}) ][7])
						SZC->ZC_PERIGO  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'GO'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'GO'}) ][7])
						SZC->ZC_PERITO  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'TO'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'TO'}) ][7])
						SZC->ZC_PERIDF  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'DF'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'DF'}) ][7])
						SZC->ZC_PERIRO  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RO'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'RO'}) ][7])
						SZC->ZC_PERIAC  := If(Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AC'}) == 0,0,aRetUf[ Ascan(aRetUf,{|x| Alltrim(x[1]) == 'AC'}) ][7])
						SZC->ZC_PERCENT := Round(nPercT,2)
						SZC->ZC_TOTAL   := nTotal
						SZC->ZC_QTDANO  := nAno
						MsUnlock()
					EndIf
					nTotRat += nPerc
					(cAlias010)->(DbSkip())
				EndDo
				If SZB->(DbSeek(xFilial('SZB') + cCodigo))
					If Reclock('SZB',.F.)
						SZB->ZB_PERRAT  := 0
						MsUnlock()
					EndIf
				EndIf
			EndIf
		EndIf
		(cAlias010)->(DbCloseArea())
		
		If Len(aMedia) > 0
			SHGETMED(aMedia)
		EndIf
	EndIf

Return

User Function SHFATQTD(cProduto,cGrupo,dData,dDataAte,nTotal,nAno,cNegocio)
	Local cAlias		:= GetNextAlias()
	Local cAliasDev		:= GetNextAlias()
	Local aQuery        := {}
	Local aQueryDev        := {}
	Local nQuant		:= 0
	Local aArea  := GetArea()
	local aEstado:= {}
	Local nValor  := 0
	Local nValorD := 0
	Local nQtd    := 0
	Local nQtdD   := 0
	Local nX      := 0
	Local nMes := {}
	Local nPercC := 0
	Local nPercI := 0
	Local cZona  := ''
	Local nQtdCap := 0
	Local nQtdInt := 0
	Local nTotCap := 0
	Local nTotInt := 0
	Local nQtdDCap:= 0
	Local nQtdDInt:= 0

	SX5->(DbSetOrder(1))
	SX5->(DbSeeK(xFilial("SX5")+"12",.T.))
	While SX5->(!Eof()) .And. SX5->X5_TABELA == "12"
		If SX5->X5_CHAVE = 'EX'
			SX5->(DbSkip())
			Loop
		EndIf
		&&	Aadd(aEstado,{Alltrim(SX5->X5_CHAVE)})
		SX5->(DbSkip())
	EndDo

	BeginSql Alias cAlias
		SELECT SF2.F2_EST,SD2.D2_COD, SB1.B1_DESC, SB1.B1_GRUPO, SUM(SD2.D2_QUANT) AS D2_QUANT, SUM(SD2.D2_TOTAL) AS D2_TOTAL,
		SUM(CASE WHEN F2_ZZZONA= '1' THEN SD2.D2_QUANT ELSE 0 END) AS QTDCAPITAL,
		SUM(CASE WHEN F2_ZZZONA= '2' THEN SD2.D2_QUANT ELSE 0 END) AS QTDINTERIOR,
		SUM(CASE WHEN F2_ZZZONA= '1' THEN SD2.D2_TOTAL ELSE 0 END) AS TOTCAPITAL,
		SUM(CASE WHEN F2_ZZZONA= '2' THEN SD2.D2_TOTAL ELSE 0 END) AS TOTINTERIOR
		FROM %TABLE:SD2% SD2
		INNER JOIN %TABLE:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD
		INNER JOIN %TABLE:SF4% SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_ESTOQUE = 'S'  AND SF4.F4_DUPLIC = 'S'
		INNER JOIN %TABLE:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D2_DOC = SF2.F2_DOC AND	SD2.D2_SERIE = SF2.F2_SERIE AND SF2.F2_TIPO = 'N'
		INNER JOIN %TABLE:SA3% SA3 ON SF2.F2_VEND1 = SA3.A3_COD
		WHERE
		SD2.D2_FILIAL = %xfilial:SD2%
		AND SF2.F2_FILIAL = %xfilial:SF2%
		AND SF4.F4_FILIAL = %xfilial:SF4%
		AND SA3.A3_FILIAL = %xfilial:SA3%
		AND SB1.B1_FILIAL = %xfilial:SB1%
		AND (SD2.D2_EMISSAO BETWEEN %EXP:DTOS(dData)% AND %EXP:DTOS(dDataAte)%)
		AND (SD2.D2_COD BETWEEN %EXP:cProduto% AND %EXP:cProduto%)
		AND (SB1.B1_GRUPO = %EXP:cGrupo%)
		AND (SF2.F2_EST BETWEEN %EXP:''% AND %EXP:'ZZ'%)
		AND (SF2.F2_VEND1 BETWEEN %EXP:""% AND %EXP:"000699"%)
		AND SF4.F4_ESTOQUE = 'S'
		AND SD2.%NOTDEL%
		AND SB1.%NOTDEL%
		AND SA3.%NOTDEL%
		AND SF2.%NOTDEL%
		AND SF4.%NOTDEL%
		GROUP BY SF2.F2_EST, SD2.D2_COD, SB1.B1_DESC, SB1.B1_GRUPO
		ORDER BY SF2.F2_EST, SD2.D2_COD, SB1.B1_DESC, SB1.B1_GRUPO
	EndSql

	aQuery := GETLastQuery()

	BeginSql Alias cAliasDev
		SELECT SUM(SD1.D1_QUANT) AS D1_QUANT, SUM(SD1.D1_TOTAL - SD1.D1_VALDESC) AS D1_TOTAL,
		SUM(CASE WHEN F2_ZZZONA= '1' THEN SD1.D1_QUANT ELSE 0 END) AS QTDCAPITAL,
		SUM(CASE WHEN F2_ZZZONA= '2' THEN SD1.D1_QUANT ELSE 0 END) AS QTDINTERIOR,
		SUM(CASE WHEN F2_ZZZONA= '1' THEN (SD1.D1_TOTAL - SD1.D1_VALDESC) ELSE 0 END) AS TOTCAPITAL,
		SUM(CASE WHEN F2_ZZZONA= '2' THEN (SD1.D1_TOTAL - SD1.D1_VALDESC) ELSE 0 END) AS TOTINTERIOR
		FROM %TABLE:SD1% SD1
		INNER JOIN %TABLE:SB1% SB1 ON SD1.D1_COD = SB1.B1_COD
		INNER JOIN %TABLE:SF4% SF4 ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.F4_ESTOQUE = 'S'  AND SF4.F4_DUPLIC = 'S'
		INNER JOIN %TABLE:SF1% SF1 ON SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA AND SF1.%NOTDEL%
		INNER JOIN %TABLE:SA1% SA1 ON SA1.A1_COD = SF1.F1_FORNECE AND SA1.A1_LOJA = SF1.F1_LOJA
		INNER JOIN %TABLE:SD2% SD2 ON SD2.D2_FILIAL = %xfilial:SD2% AND SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI  AND SD2.%NOTDEL%
		INNER JOIN %TABLE:SF2% SF2 ON SF2.F2_FILIAL = %xfilial:SF2% AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.%NOTDEL%
		WHERE
		SD1.D1_FILIAL = %xfilial:SD1%
		AND SF4.F4_FILIAL = %xfilial:SF4%
		AND SB1.B1_FILIAL = %xfilial:SB1%
		AND (SD1.D1_DTDIGIT BETWEEN %EXP:DTOS(dData)% AND %EXP:DTOS(dDataAte)%)
		AND (SD1.D1_COD BETWEEN %EXP:cProduto% AND %EXP:cProduto%)
		AND (SB1.B1_GRUPO BETWEEN %EXP:cGrupo% AND %EXP:cGrupo%)
		AND (SF1.F1_EST BETWEEN %EXP:''% AND %EXP:'ZZ'%)
		AND SD1.D1_TIPO = 'D'
		AND SF4.F4_ESTOQUE = 'S'
		AND SD1.%NOTDEL%
		AND SB1.%NOTDEL%
		AND SF4.%NOTDEL%
		GROUP BY SD1.D1_COD
		ORDER BY SD1.D1_COD

	EndSql

	If !(cAliasDev)->(Eof())
		nValorD := 0
		nQtdD   := (cAliasDev)->D1_QUANT
	EndIf

	aQueryDev := GETLastQuery()

	(cAliasDev)->(DbCloseArea())

	While !(cAlias)->(Eof())

		nQtdD  := 0
		nperSp := 0
		nCalc1 := 0
		nCalc2 := 0
		nPercUF:= 0
		nPercC := 0
		nPercI := 0
		nValorD := 0
		nQtdD   := 0
		nQtdDCap:= 0
		nQtdDInt:= 0
			
		nValor := 0
		nQtd   := (cAlias)->D2_QUANT
		
		cZona   := (cAlias)->QTDCAPITAL
		nQtdCap := (cAlias)->QTDCAPITAL
		nQtdInt := (cAlias)->QTDINTERIOR
		nTotCap := (cAlias)->TOTCAPITAL
		nTotInt := (cAlias)->TOTINTERIOR

		If (cAlias)->F2_EST = 'EX'
			(cAlias)->(DbSkip())
			Loop
		EndIf

		Aadd(aEstado,{Alltrim((cAlias)->F2_EST)})

		BeginSql Alias cAliasDev
			SELECT SUM(SD1.D1_QUANT) AS D1_QUANT, SUM(SD1.D1_TOTAL - SD1.D1_VALDESC) AS D1_TOTAL,
			SUM(CASE WHEN F2_ZZZONA= '1' THEN SD1.D1_QUANT ELSE 0 END) AS QTDCAPITAL,
			SUM(CASE WHEN F2_ZZZONA= '2' THEN SD1.D1_QUANT ELSE 0 END) AS QTDINTERIOR,
			SUM(CASE WHEN F2_ZZZONA= '1' THEN (SD1.D1_TOTAL - SD1.D1_VALDESC) ELSE 0 END) AS TOTCAPITAL,
			SUM(CASE WHEN F2_ZZZONA= '2' THEN (SD1.D1_TOTAL - SD1.D1_VALDESC) ELSE 0 END) AS TOTINTERIOR
			FROM %TABLE:SD1% SD1
			INNER JOIN %TABLE:SB1% SB1 ON SD1.D1_COD = SB1.B1_COD
			INNER JOIN %TABLE:SF4% SF4 ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.F4_ESTOQUE = 'S'
			INNER JOIN %TABLE:SF1% SF1 ON SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA AND SF1.%NOTDEL%
			INNER JOIN %TABLE:SA1% SA1 ON SA1.A1_COD = SF1.F1_FORNECE AND SA1.A1_LOJA = SF1.F1_LOJA
			INNER JOIN %TABLE:SD2% SD2 ON SD2.D2_FILIAL = %xfilial:SD2% AND SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI  AND SD2.%NOTDEL%
			INNER JOIN %TABLE:SF2% SF2 ON SF2.F2_FILIAL = %xfilial:SF2% AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.%NOTDEL%
			WHERE
			SD1.D1_FILIAL = %xfilial:SD1%
			AND SF4.F4_FILIAL = %xfilial:SF4%
			AND SB1.B1_FILIAL = %xfilial:SB1%
			AND (SD1.D1_DTDIGIT BETWEEN %EXP:DTOS(dData)% AND %EXP:DTOS(dDataAte)%)
			AND (SD1.D1_COD BETWEEN %EXP:cProduto% AND %EXP:cProduto%)
			AND (SB1.B1_GRUPO BETWEEN %EXP:cGrupo% AND %EXP:cGrupo%)
			AND (SF1.F1_EST BETWEEN %EXP:(cAlias)->F2_EST% AND %EXP:(cAlias)->F2_EST%)
			AND SD1.D1_TIPO = 'D'
			AND SF4.F4_ESTOQUE = 'S'
			AND SD1.%NOTDEL%
			AND SB1.%NOTDEL%
			AND SF4.%NOTDEL%
			AND SA1.%NOTDEL%
			GROUP BY SD1.D1_COD
			ORDER BY SD1.D1_COD

		EndSql

		If !(cAliasDev)->(Eof())
			nValorD := 0
			nQtdD   := (cAliasDev)->D1_QUANT
			nQtdDCap:= (cAliasDev)->QTDCAPITAL
			nQtdDInt:= (cAliasDev)->QTDINTERIOR
		EndIf

		aQueryDev := GETLastQuery()

		(cAliasDev)->(DbCloseArea())

		aMEs := SHGETPER(dData,dDataAte)

		nAno := Len(aMes) / 12
                                            

		&& Capital
		nCalc1 := (nTotal / nAno)
		nCalc2 := (nQtdCap - nQtdDCap)  / nAno
		nPercC := (nCalc2 / nCalc1)*100
		
		&&Interior
		nCalc1 := (nTotal / nAno)
		nCalc2 := (nQtdInt - nQtdDInt)  / nAno
		nPercI := (nCalc2 / nCalc1)*100
		
		
	   /*	If Alltrim((cAlias)->F2_EST) == 'SP'
			nperSp := 60
			nCalc1 := (nTotal / nAno)
			nCalc2 := (nQtd - nQtdD)   / nAno
			nPercUF:= (nCalc2 / nCalc1)*100

			nPercC  := (((nCalc2 * 60) / 100) / nCalc1 ) * 100
			nPercI  := (((nCalc2 * 40) / 100) / nCalc1 ) * 100

		Else
			nCalc1 := (nTotal / nAno)
			nCalc2 := (nQtd - nQtdD)  / nAno
			nPercC := (nCalc2 / nCalc1)*100
			nPercI := 0
		EndIf*/
		
	
		nPercT += nPercC + nPercI

		AADD(aEstado[Len(aEstado)],Round(nValor,2))
		AADD(aEstado[Len(aEstado)],Round(nValorD,2))
		AADD(aEstado[Len(aEstado)],Round(nQtd,2))
		AADD(aEstado[Len(aEstado)],Round(nQtdD,2))
		AADD(aEstado[Len(aEstado)],Round(nPercC,2))
		AADD(aEstado[Len(aEstado)],Round(nPercI,2))
		AADD(aEstado[Len(aEstado)],Round(nCalc1,2))
		AADD(aEstado[Len(aEstado)],Round(nAno  ,2))


		(cAlias)->(DbSkip())
	EndDo
	(cAlias)->(DbCloseArea())
	RestArea(aArea)

Return aEstado

Static Function SHGETZONA(cMunicipio)
	Local cRet := ''
	Local cAliasZ := ''
	Local cIn    := ''
	Local nValor := 0
	Local nQuant := 0
	Local nPercent := 0

	cAliasZ := GetNextAlias()
	BeginSql Alias cAliasZ
		SELECT Z7_CODZONA
		FROM %TABLE:SZ7% SZ7
		INNER JOIN %TABLE:SZ8% SZ8 ON Z8_FILIAL = %xfilial:SZ8% AND Z7_CODIGO = Z8_CODIGO AND SZ8.%NOTDEL%
		WHERE
		SZ7.Z7_FILIAL = %xfilial:SZ7% AND
		SZ8.Z8_CODMUN = %EXP:cMunicipio% AND
		SZ7.%NOTDEL%
		GROUP BY Z7_CODZONA
	EndSql
	
	If !(cAliasZ)->(Eof())
		cRet := (cAliasZ)->Z7_CODZONA
	EndIf

	(cAliasZ)->(DbCloseArea())

Return cRet
 
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
	

Static Function SHGETMED(aMedia)
	Local aRet 	    := {}
	Local cAliasMed

	For nX := 1 To Len(aMedia)
		cAliasMed := GetNextAlias()
		nPercT := 0
		BeginSql Alias cAliasMed
			%noparser%
			SELECT
			AVG(ZC_PERCSP) ZC_PERCSP,
			AVG(ZC_PERCRJ) ZC_PERCRJ,
			AVG(ZC_PERCMG) ZC_PERCMG,
			AVG(ZC_PERCES) ZC_PERCES,
			AVG(ZC_PERCPR) ZC_PERCPR,
			AVG(ZC_PERCSC) ZC_PERCSC,
			AVG(ZC_PERCRS) ZC_PERCRS,
			AVG(ZC_PERCBA) ZC_PERCBA,
			AVG(ZC_PERCSE) ZC_PERCSE,
			AVG(ZC_PERCAL) ZC_PERCAL,
			AVG(ZC_PERCPE) ZC_PERCPE,
			AVG(ZC_PERCPB) ZC_PERCPB,
			AVG(ZC_PERCRN) ZC_PERCRN,
			AVG(ZC_PERCCE) ZC_PERCCE,
			AVG(ZC_PERCPI) ZC_PERCPI,
			AVG(ZC_PERCMA) ZC_PERCMA,
			AVG(ZC_PERCPA) ZC_PERCPA,
			AVG(ZC_PERCAP) ZC_PERCAP,
			AVG(ZC_PERCAM) ZC_PERCAM,
			AVG(ZC_PERCRR) ZC_PERCRR,
			AVG(ZC_PERCMT) ZC_PERCMT,
			AVG(ZC_PERCMS) ZC_PERCMS,
			AVG(ZC_PERCGO) ZC_PERCGO,
			AVG(ZC_PERCTO) ZC_PERCTO,
			AVG(ZC_PERCDF) ZC_PERCDF,
			AVG(ZC_PERCRO) ZC_PERCRO,
			AVG(ZC_PERCAC) ZC_PERCAC,

			AVG(ZC_PERISP) ZC_PERISP,
			AVG(ZC_PERIRJ) ZC_PERIRJ,
			AVG(ZC_PERIMG) ZC_PERIMG,
			AVG(ZC_PERIES) ZC_PERIES,
			AVG(ZC_PERIPR) ZC_PERIPR,
			AVG(ZC_PERISC) ZC_PERISC,
			AVG(ZC_PERIRS) ZC_PERIRS,
			AVG(ZC_PERIBA) ZC_PERIBA,
			AVG(ZC_PERISE) ZC_PERISE,
			AVG(ZC_PERIAL) ZC_PERIAL,
			AVG(ZC_PERIPE) ZC_PERIPE,
			AVG(ZC_PERIPB) ZC_PERIPB,
			AVG(ZC_PERIRN) ZC_PERIRN,
			AVG(ZC_PERICE) ZC_PERICE,
			AVG(ZC_PERIPI) ZC_PERIPI,
			AVG(ZC_PERIMA) ZC_PERIMA,
			AVG(ZC_PERIPA) ZC_PERIPA,
			AVG(ZC_PERIAP) ZC_PERIAP,
			AVG(ZC_PERIAM) ZC_PERIAM,
			AVG(ZC_PERIRR) ZC_PERIRR,
			AVG(ZC_PERIMT) ZC_PERIMT,
			AVG(ZC_PERIMS) ZC_PERIMS,
			AVG(ZC_PERIGO) ZC_PERIGO,
			AVG(ZC_PERITO) ZC_PERITO,
			AVG(ZC_PERIDF) ZC_PERIDF,
			AVG(ZC_PERIRO) ZC_PERIRO,
			AVG(ZC_PERIAC) ZC_PERIAC
			FROM %TABLE:SZC% SZC
			WHERE
			SZC.ZC_CODIGO = %EXP:aMedia[nX,1]% AND
			SZC.ZC_ANO    = %EXP:aMedia[nX,2]% AND
			SZC.ZC_GRUPO  = %EXP:aMedia[nX,4]% AND
			SZC.%NOTDEL%
		EndSql
		
		SZC->(DbSetOrder(1))
		If SZC->(DbSeek(xFilial('SZC') + aMedia[nX,1] + aMedia[nX,2] + aMedia[nX,3]))
			If Reclock('SZC',.F.)
				&& Capital
				SZC->ZC_PERCSP:= (cAliasMed)->ZC_PERCSP
				SZC->ZC_PERCRJ:= (cAliasMed)->ZC_PERCRJ
				SZC->ZC_PERCMG:= (cAliasMed)->ZC_PERCMG
				SZC->ZC_PERCES:= (cAliasMed)->ZC_PERCES
				SZC->ZC_PERCPR:= (cAliasMed)->ZC_PERCPR
				SZC->ZC_PERCSC:= (cAliasMed)->ZC_PERCSC
				SZC->ZC_PERCRS:= (cAliasMed)->ZC_PERCRS
				SZC->ZC_PERCBA:= (cAliasMed)->ZC_PERCBA
				SZC->ZC_PERCSE:= (cAliasMed)->ZC_PERCSE
				SZC->ZC_PERCAL:= (cAliasMed)->ZC_PERCAL
				SZC->ZC_PERCPE:= (cAliasMed)->ZC_PERCPE
				SZC->ZC_PERCPB:= (cAliasMed)->ZC_PERCPB
				SZC->ZC_PERCRN:= (cAliasMed)->ZC_PERCRN
				SZC->ZC_PERCCE:= (cAliasMed)->ZC_PERCCE
				SZC->ZC_PERCPI:= (cAliasMed)->ZC_PERCPI
				SZC->ZC_PERCMA:= (cAliasMed)->ZC_PERCMA
				SZC->ZC_PERCPA:= (cAliasMed)->ZC_PERCPA
				SZC->ZC_PERCAP:= (cAliasMed)->ZC_PERCAP
				SZC->ZC_PERCAM:= (cAliasMed)->ZC_PERCAM
				SZC->ZC_PERCRR:= (cAliasMed)->ZC_PERCRR
				SZC->ZC_PERCMT:= (cAliasMed)->ZC_PERCMT
				SZC->ZC_PERCMS:= (cAliasMed)->ZC_PERCMS
				SZC->ZC_PERCGO:= (cAliasMed)->ZC_PERCGO
				SZC->ZC_PERCTO:= (cAliasMed)->ZC_PERCTO
				SZC->ZC_PERCDF:= (cAliasMed)->ZC_PERCDF
				SZC->ZC_PERCRO:= (cAliasMed)->ZC_PERCRO
				SZC->ZC_PERCAC:= (cAliasMed)->ZC_PERCAC
				
				&& Interior
				SZC->ZC_PERISP:= (cAliasMed)->ZC_PERISP
				SZC->ZC_PERIRJ:= (cAliasMed)->ZC_PERIRJ
				SZC->ZC_PERIMG:= (cAliasMed)->ZC_PERIMG
				SZC->ZC_PERIES:= (cAliasMed)->ZC_PERIES
				SZC->ZC_PERIPR:= (cAliasMed)->ZC_PERIPR
				SZC->ZC_PERISC:= (cAliasMed)->ZC_PERISC
				SZC->ZC_PERIRS:= (cAliasMed)->ZC_PERIRS
				SZC->ZC_PERIBA:= (cAliasMed)->ZC_PERIBA
				SZC->ZC_PERISE:= (cAliasMed)->ZC_PERISE
				SZC->ZC_PERIAL:= (cAliasMed)->ZC_PERIAL
				SZC->ZC_PERIPE:= (cAliasMed)->ZC_PERIPE
				SZC->ZC_PERIPB:= (cAliasMed)->ZC_PERIPB
				SZC->ZC_PERIRN:= (cAliasMed)->ZC_PERIRN
				SZC->ZC_PERICE:= (cAliasMed)->ZC_PERICE
				SZC->ZC_PERIPI:= (cAliasMed)->ZC_PERIPI
				SZC->ZC_PERIMA:= (cAliasMed)->ZC_PERIMA
				SZC->ZC_PERIPA:= (cAliasMed)->ZC_PERIPA
				SZC->ZC_PERIAP:= (cAliasMed)->ZC_PERIAP
				SZC->ZC_PERIAM:= (cAliasMed)->ZC_PERIAM
				SZC->ZC_PERIRR:= (cAliasMed)->ZC_PERIRR
				SZC->ZC_PERIMT:= (cAliasMed)->ZC_PERIMT
				SZC->ZC_PERIMS:= (cAliasMed)->ZC_PERIMS
				SZC->ZC_PERIGO:= (cAliasMed)->ZC_PERIGO
				SZC->ZC_PERITO:= (cAliasMed)->ZC_PERITO
				SZC->ZC_PERIDF:= (cAliasMed)->ZC_PERIDF
				SZC->ZC_PERIRO:= (cAliasMed)->ZC_PERIRO
				SZC->ZC_PERIAC:= (cAliasMed)->ZC_PERIAC
				
				nPercT+= SZC->ZC_PERCSP ;
					+ SZC->ZC_PERCRJ ;
					+ SZC->ZC_PERCMG ;
					+ SZC->ZC_PERCES ;
					+ SZC->ZC_PERCPR ;
					+ SZC->ZC_PERCSC ;
					+ SZC->ZC_PERCRS ;
					+ SZC->ZC_PERCBA ;
					+ SZC->ZC_PERCSE ;
					+ SZC->ZC_PERCAL ;
					+ SZC->ZC_PERCPE ;
					+ SZC->ZC_PERCPB ;
					+ SZC->ZC_PERCRN ;
					+ SZC->ZC_PERCCE ;
					+ SZC->ZC_PERCPI ;
					+ SZC->ZC_PERCMA ;
					+ SZC->ZC_PERCPA ;
					+ SZC->ZC_PERCAP ;
					+ SZC->ZC_PERCAM ;
					+ SZC->ZC_PERCRR ;
					+ SZC->ZC_PERCMT ;
					+ SZC->ZC_PERCMS ;
					+ SZC->ZC_PERCGO ;
					+ SZC->ZC_PERCTO ;
					+ SZC->ZC_PERCDF ;
					+ SZC->ZC_PERCRO ;
					+ SZC->ZC_PERCAC ;
					+ SZC->ZC_PERISP ;
					+ SZC->ZC_PERIRJ ;
					+ SZC->ZC_PERIMG ;
					+ SZC->ZC_PERIES ;
					+ SZC->ZC_PERIPR ;
					+ SZC->ZC_PERISC ;
					+ SZC->ZC_PERIRS ;
					+ SZC->ZC_PERIBA ;
					+ SZC->ZC_PERISE ;
					+ SZC->ZC_PERIAL ;
					+ SZC->ZC_PERIPE ;
					+ SZC->ZC_PERIPB ;
					+ SZC->ZC_PERIRN ;
					+ SZC->ZC_PERICE ;
					+ SZC->ZC_PERIPI ;
					+ SZC->ZC_PERIMA ;
					+ SZC->ZC_PERIPA ;
					+ SZC->ZC_PERIAP ;
					+ SZC->ZC_PERIAM ;
					+ SZC->ZC_PERIRR ;
					+ SZC->ZC_PERIMT ;
					+ SZC->ZC_PERIMS ;
					+ SZC->ZC_PERIGO ;
					+ SZC->ZC_PERITO ;
					+ SZC->ZC_PERIDF ;
					+ SZC->ZC_PERIRO ;
					+ SZC->ZC_PERIAC

				SZC->ZC_PERCENT := Round(nPercT,2)
					
				SZC->(MsUnlock())
			EndIf
		EndIf
		(cAliasMed)->(DbCloseArea())
	Next nX
Return
