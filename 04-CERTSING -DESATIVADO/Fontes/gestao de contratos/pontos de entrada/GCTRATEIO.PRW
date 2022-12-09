#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

User Function GCTRateio(oGetDados,aRatGCT,nOpc,aBusca,aAuxRat,lAtuCNZ)
Local oDlgRateio	:= nil
Local oGetRateio	:= nil
//Local oPercRat		:= nil

Local nI			:= 0
Local nCtb			:= 0
Local nLin			:= oGetDados:nAt
Local nPItem		:= 0	

Local nPItPlan		:= 0
Local nPPerc		:= 0
Local nOpcX			:= 0

Local aButtons		:= {}
Local aLocalCols	:= {}
Local aHeadCNZ		:= GCTHeadCNZ()
Local aAlter		:= {"CNZ_PERC","CNZ_CC","CNZ_CONTA","CNZ_ITEMCT","CNZ_CLVL"}
Local aVarCab		:= {}
Local aVarItem		:= {}
Local aRetAutRat	:= {}
Local aCTBEnt	  	:= CTBEntArr()

Local bExecCancel	:= {||oDlgRateio:End()}
Local bFieldOk		:= {|lRet|	lRet := ValRateioDados(oGetRateio:aCols,oGetRateio:nAt,nPPerc,@nPercRat,@nPercaRat,oPercRat,oPercARat),lRet }
Local bLinhaOk		:= {|lRet| 	lRet := ValidLineRat(oGetRateio),lRet}
Local bTudoOk		:= {|lRet|	lRet := ValidTudoRat(oGetRateio,nOpc),lRet}
Local bDelOk		:= {||	SubPercRat(oGetRateio,nPPerc,@nPercRat,@nPercaRat,oPercRat,oPercARat), .t.}

Local cContrato		:= aBusca[1]
Local cRevisao		:= aBusca[2]
Local cPlanMed		:= aBusca[3]
Local cProg      	:= FunName()
Local cAlias    	:= Iif(cProg == "CNTA120" , "CND","CNA")
Local cFilCtr		:= cFilAnt
Local cCampoCR		:= ""
Local cCampoDB		:= ""
Local cCampo        := ""

Local nPosConta		:= 0
Local nPosCC		:= 0
Local nPosItCnt		:= 0
Local nPosClCnt		:= 0
Local nPosEnCR5		:= 0
Local nPosEnDB5		:= 0
Local nPosEnCR6		:= 0
Local nPosEnDB6		:= 0
Local nPosEnCR7		:= 0
Local nPosEnDB7		:= 0
Local nPosEnCR8		:= 0
Local nPosEnDB8		:= 0
Local nPosEnCR9		:= 0
Local nPosEnDB9		:= 0

Local lCNZAutRat	:= ExistBlock("CNZAUTRAT")
Local lAltera		:= .T.
Local lTemCntCC		:= .F.

PRIVATE nPercRat	:= 0
PRIVATE nPercARat	:= 100

Default aAuxRat  	:= {}
Default lAtuCNZ	:= .F. // Atualizar a CNZ mesmo quando nao clicar no botao Rateio e verificar itens novos

aadd(aButtons,{'AUTOM',{|| AdmRatExt(aHeadCNZ,oGetRateio:aCols,{ |x,y,z,w| GCTCarCC(x,y,@z,w) }) },"Rateio",OemToAnsi('Escolha de Rateio Pre-Configurado')}) //"Rateio" // 'Escolha de Rateio Pre-Configurado'

If cProg == "CNTA120"
	cFilCtr := If(nOpc == 3,M->CND_FILCTR,CND->CND_FILCTR)
EndIf

If Len(aRatGCT)==0
	aRatGCT := GetRatInBase(oGetDados,cAlias,,cFilCtr)
Elseif lAtuCNZ
	aRatGCT := GetRatInBase(oGetDados,cAlias,aRatGCT,cFilCtr)
Endif

GetVarRateio(aVarCab,aVarItem)

nPPerc   := aScan(aHeadCNZ,{|x| alltrim(x[2]) == "CNZ_PERC"})

nPItem	 := aScan(oGetDados:aHeader,{ |x| alltrim(x[2]) == aVarItem[ITEM] })
nPItPlan := aScan(aRatGCT,{|x| alltrim(x[1]) + alltrim(x[2]) + alltrim(x[3]) + alltrim(x[4]) == alltrim(cContrato) + alltrim(cRevisao) + alltrim(cPlanMed) + alltrim(oGetDados:aCols[nLin,nPItem]) })

If nPItPlan > 0
	For nI := 1 to len(aRatGCT[nPItPlan][5])
		nPercRat += aRatGCT[nPItPlan][5][nI,nPPerc]
	Next nI

	nPercARat -= nPercRat
	aLocalCols := aClone(aRatGCT[nPItPlan][5])
Else
	If lCNZAutRat .And. Len(aRatGCT) > 0
		If Len(aRatGCT[1]) >= 5
			aLocalCols := aClone(aRatGCT[1][5])
		EndIf
	EndIf
Endif

// Ponto de entrada para preenchimento automatico de campos no rateio
If lCNZAutRat
	aRetAutRat := ExecBlock("CNZAUTRAT",.F.,.F.,{aHeadCNZ,aLocalCols,nOpc})
	If ValType(aRetAutRat) == "A"
		aLocalCols := aClone(aRetAutRat)
	EndIf
EndIf

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
If nOpc == 2 .Or. nOpc == 5
	lAltera := .F.
	aAlter	 := {}
Else
	//- Verifica campos do usuario
	SX3->(dbSeek("CNZ"))
	While !SX3->(Eof()) .and. X3_ARQUIVO == "CNZ"
	cCampo := SX3->X3_CAMPO
		If GetSX3Cache(cCampo , "X3_PROPRI" ) == "U" .And. GetSX3Cache( cCampo, "X3_VISUAL" ) != "V"
			Aadd( aAlter, cCampo )
		Endif
		SX3->(dbSkip())
	Enddo

	//- Verifica Entidades adicionais
	SX3->(DbSetOrder(2))
	For nCtb := 1 To Len(aCTBEnt)
		cCampoCR := "CNZ_EC"+aCTBEnt[nCtb]+"CR"
		cCampoDB := "CNZ_EC"+aCTBEnt[nCtb]+"DB"
		If CNZ->(FieldPos(cCampoCR)) > 0
			If SX3->(DbSeek(cCampoCR)) .And. GetSX3Cache( cCampoCR, "X3_VISUAL" ) != "V"
				Aadd(aAlter,cCampoCR)
			EndIf
			If SX3->(DbSeek(cCampoDB)) .And. GetSX3Cache( cCampoCR, "X3_VISUAL" )  != "V"
				Aadd(aAlter,cCampoDB)
			EndIf
		EndIf
	Next nCtb
Endif

MsSeek(cAlias)

If Len(oGetDados:aHeader) > 0	
	nPosConta	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_CONTA"})
	nPosCC		:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_CC"})
	nPosItCnt	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_ITEMCT"})
	nPosClCnt	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_CLVL"})
		
	If Len(aCTBEnt) > 0
		nPosEnCR5	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC05CR"})
		nPosEnDB5	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC05DB"})
		nPosEnCR6	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC06CR"})
		nPosEnDB6	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC06DB"})
		nPosEnCR7	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC07CR"})
		nPosEnDB7	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC07DB"})
		nPosEnCR8	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC08CR"})
		nPosEnDB8	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC08DB"})
		nPosEnCR9	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC09CR"})
		nPosEnDB9	:= Ascan(oGetDados:aHeader,{|x| AllTrim(x[2])=="CNE_EC09DB"})
	EndIf
EndIf

If IsInCallStack('cn130manut') .And. Len(oGetDados:aCols) > 0 .And. (INCLUI .Or. ALTERA) // Verifica se a rotina foi chamada no cadastro de medicoes, se ha itens preenchidos e se é alteração ou inclusão

	If ( nPosConta > 0 			.And. !Empty(oGetDados:aCols[nLin,nPosConta])	);
		.Or. ( nPosCC > 0 		.And. !Empty(oGetDados:aCols[nLin,nPosCC]) 		);
		.Or. ( nPosItCnt > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosItCnt])	);
		.Or. ( nPosClCnt > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosClCnt]) 	);
		.Or. ( nPosEnCR5 > 0    .And. !Empty(oGetDados:aCols[nLin,nPosEnCR5])	);
		.Or. ( nPosEnDB5 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnDB5])	);
		.Or. ( nPosEnCR6 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnCR6])	);
		.Or. ( nPosEnDB6 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnDB6])	);
		.Or. ( nPosEnCR7 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnCR7])	);
		.Or. ( nPosEnDB7 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnDB7])	);
		.Or. ( nPosEnCR8 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnCR8])	);
		.Or. ( nPosEnDB8 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnDB8])	);
		.Or. ( nPosEnCR9 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnCR9])	);
		.Or. ( nPosEnDB9 > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosEnDB9])	)

		lTemCntCC := .T.
	EndIf

	If lTemCntCC // Verifica se ha valores de entidades contábeis preenchidos para utilizar o rateio
		If MsgYesNo("H� valores de entidades cont�beis preenchidos, deseja apagar os valores para utilizar o rateio?") // "Há valores de entidades contábeis preenchidos, deseja apagar os valores para utilizar o rateio?"                                                                                                                                                                                                                                                                                                                                                                                                                  
			lAtuCNZ := .F.
		Else
			lAtuCNZ := .T. // Nao mostra tela de rateio se nao limpar os campos
		EndIf
	EndIf
EndIf

If !lAtuCNZ

	DEFINE MSDIALOG oDlgRateio FROM 100,100 TO 370,600 TITLE "Rateio por Centro de Custo" Of oMainWnd PIXEL //"Rateio por Centro de Custo"

		@ 018,003 SAY RetTitle(aVarCab[CONTRATO])  		OF oDlgRateio PIXEL SIZE 30,09
		@ 018,035 SAY ALLTRIM(M->&(aVarCab[CONTRATO])) 	OF oDlgRateio PIXEL SIZE 50,09

		@ 018,090 SAY "Revisao"								OF oDlgRateio PIXEL SIZE 25,09 //"Revisao"
		@ 018,115 SAY Alltrim(M->&(aVarCab[REVISAO]))		OF oDlgRateio PIXEL SIZE 18,09

		@ 018,138 SAY "Item"  								OF oDlgRateio PIXEL SIZE 18,09 //"Item"
		@ 018,156 SAY oGetDados:aCols[nLin][nPItem]  		OF oDlgRateio PIXEL SIZE 25,09

		oGetRateio 	:= MsNewGetDados():New(030,005,105,245,IIF(lAltera,GD_INSERT+GD_UPDATE+GD_DELETE,0),"AllwaysTrue","AllwaysTrue","+CNZ_ITEM",aAlter,,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlgRateio,aHeadCNZ,aLocalCols)

		oGetRateio:bFieldOk	:= bFieldOk
		oGetRateio:bLinhaOk	:= bLinhaOk
		oGetRateio:bDelOk	:= bDelOk
		oGetRateio:lUpdate := .t.

		@ 110,005 Say OemToAnsi("% Rateada: ") FONT oDlgRateio:oFont OF oDlgRateio PIXEL	 // "% Rateada: "
		@ 110,035 Say oPercRat VAR nPercRat Picture PesqPict("CNZ","CNZ_PERC") FONT oDlgRateio:oFont COLOR CLR_HBLUE OF oDlgRateio PIXEL

		@ 110,184 Say OemToAnsi("% A Ratear: ") FONT oDlgRateio:oFont OF oDlgRateio PIXEL	 // "% A Ratear: "
		@ 110,217 Say oPercARat VAR nPercARat Picture PesqPict("CNZ","CNZ_PERC") FONT oDlgRateio:oFont COLOR CLR_HBLUE OF oDlgRateio PIXEL

	ACTIVATE MSDIALOG oDlgRateio CENTERED ON INIT EnchoiceBar(oDlgRateio,{|| Iif(eval(bTudoOk) .And. (INCLUI .Or. ALTERA), nOpcX := 1,nOpcX := 0), Iif(nOpcX == 1,oDlgRateio:End(),Iif(INCLUI .Or. ALTERA, Nil, oDlgRateio:End()))},bExecCancel,,aButtons)

EndIf

If nOpcX == 1
	If Len(oGetDados:aCols) > 0 
		If nPosConta > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosConta])
			oGetDados:aCols[nLin,nPosConta] := ""
		EndIf
		If nPosCC > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosCC])
			oGetDados:aCols[nLin,nPosCC] := ""
		EndIf
		If nPosItCnt > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosItCnt])
			oGetDados:aCols[nLin,nPosItCnt] := ""
		EndIf
		If nPosClCnt > 0 	.And. !Empty(oGetDados:aCols[nLin,nPosClCnt])
			oGetDados:aCols[nLin,nPosClCnt] := ""
		EndIf
	
		////////////////////////////////////////////////////////////////////////////////////////
		// Verifica se existe mais entidades contabeis para limpar o campo caso exista rateio //
		////////////////////////////////////////////////////////////////////////////////////////
		If Len(aCTBEnt) > 0
			If nPosEnCR5 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnCR5])
				oGetDados:aCols[nLin,nPosEnCR5] := ""
			EndIf

			If nPosEnDB5 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnDB5])
				oGetDados:aCols[nLin,nPosEnDB5] := ""
			EndIf

			If nPosEnCR6 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnCR6])
				oGetDados:aCols[nLin,nPosEnCR6] := ""
			EndIf

			If nPosEnDB6 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnDB6])
				oGetDados:aCols[nLin,nPosEnDB6] := ""
			EndIf
			
			If nPosEnCR7 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnCR7])
				oGetDados:aCols[nLin,nPosEnCR7] := ""
			EndIf

			If nPosEnDB7 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnDB7])
				oGetDados:aCols[nLin,nPosEnDB7] := ""
			EndIf

			If nPosEnCR8 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnCR8])
				oGetDados:aCols[nLin,nPosEnCR8] := ""
			EndIf

			If nPosEnDB8 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnDB8])
				oGetDados:aCols[nLin,nPosEnDB8] := ""
			EndIf

			If nPosEnCR9 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnCR9])
				oGetDados:aCols[nLin,nPosEnCR9] := ""
			EndIf

			If nPosEnDB9 > 0 .And. !Empty(oGetDados:aCols[nLin,nPosEnDB9])
				oGetDados:aCols[nLin,nPosEnDB9] := ""
			EndIf
		EndIf

	EndIf
	
	/////////////////////
	// Atualiza objeto //
	/////////////////////
	oGetDados:Refresh()
	
	If nPItPlan > 0
		aRatGCT[nPItPlan,5] := aUpdCols(oGetRateio:aCols)
	Else
		aLocalCols := GetDefaultLine(aHeadCNZ)

		//adicionar o item do plano e um aCols vazio
		aAdd(aRatGCT,	{	alltrim(M->&(aVarCab[CONTRATO])),;
							alltrim(M->&(aVarCab[REVISAO])),;
							alltrim(M->&(aVarCab[PLAN_MED])),;
							alltrim(oGetDados:aCols[nLin,nPItem]),;
							aLocalCols})

		aRatGCT[len(aRatGCT),5] := aUpdCols(oGetRateio:aCols)
	EndIf
	aAuxRat := aClone(aRatGCT)
	lAtvRat := .T. // Ativou o rateio
Endif

Return
