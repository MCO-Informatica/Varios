 #INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSA041   ºAutor  ³Opvs (David)        º Data ³  02/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para Cadastros Expectativa de Expectativa Mensal de  º±±
±±º          ³Verba                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTSA041(nOpc)

	Local oDlg
	Local aButtons	 := {}
	Local aCampos	 := {}
	Local nI		 := 0
	Local nUsado	 := 0
	Local aSize		 := {}
	Local aObjects	 := {}
	Local aPosObj	 := {}
	Local aInfo		 := {}
	Local aButtons	 := {}
	Local oModelx    := FWModelActive()
	Local oModelxDet := oModelx:GetModel('ADJDETAIL')
	Local aHeaderAnt := aClone(oModelxDet:aHeader)
	Local aColsAnt	 := aClone(oModelxDet:aCols)
	Local lRet       := .T.

	Private cAD1_NROPOR := Space(Len(AD1->AD1_NROPOR))
	Private lFATA300    := (FunName()=='FATA300')
	Private lFATA310    := (FunName()=='FATA310')
	Private oMsGetD 	

	aSize 	:= MsAdvSize()

	AaDd(aObjects, {50,50,.t.,.t.})

	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aPosObj := MsObjSize(aInfo,aObjects)

	If lFATA300
		cAD1_NROPOR := M->AD1_NROPOR
	Elseif lFATA310
		cAD1_NROPOR := M->AD5_NROPOR
	Endif

	cAlias1 	:= "SZE"
	nSavRegSOL	:= SZE->(Recno())
	cSeek		:= xFilial("SZE")+cAD1_NROPOR
	cWhile		:= "SZE->(ZE_FILIAL+ZE_NROPOR)"                                                            	

	dbSelectArea("SZE")
	SZE->( DbSetOrder(1) )		

	FillGetDados(4,cAlias1,SZE->(INDEXORD()),cSeek,{|| &cWhile },{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/)

	DEFINE MSDIALOG oDlg TITLE "Oportunidade x Expectativa Mensal da Verba" FROM 0,0 TO aSize[6], aSize[5] OF oMainWnd PIXEL

		EnchoiceBar(oDlg,{|| lRet := Iif(U_A041TOK(),(CTSA41GRV(oMsGetD),oDlg:End()),.F.) },{|| lRet:=.F., oDlg:End() },,aButtons)

		oMsGetD := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],GD_INSERT+GD_DELETE+GD_UPDATE,"u_CTSA041OK()","u_CTSA041OK()",,,,4096,"AllWaysTrue()",,,oDlg,aHeader,aCols)

	ACTIVATE MSDIALOG oDlg

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSA41GRV ºAutor  ³Opvs (David)        º Data ³  22/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CTSA41GRV(oMsGetD)

Local cLog		:= ""
Local nI		:= 0
Local nPosMes	:= Ascan(oMsGetD:aHeader,{|x| x[2] = "ZE_MES" }) 
Local nPosAno	:= Ascan(oMsGetD:aHeader,{|x| x[2] = "ZE_ANO" }) 
Local nPosVlr	:= Ascan(oMsGetD:aHeader,{|x| x[2] = "ZE_VALOR" }) 

aCols := aClone(oMsGetD:aCols)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Aqui comeca a gravacao dos dados depois de validar se as informacoes estao todas corretas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Begin Transaction
	// Define a ordem para o seek dentro do loop abaixo
	SZE->( DbSetOrder(1) )		
	
	For nI := 1 To Len(aCols)
	
		// Se o registro foi deletado no browser, verifica se acha na base pra deletar tambem
		If aCols[nI][Len(aCols[nI])]
			If SZE->( MsSeek( xFilial("SZE")+cAD1_NROPOR+aCols[nI,nPosMes]+aCols[nI,nPosAno] ) )
				SZE->( RecLock("SZE",.F.) )
					SZE->( DbDelete() )
				SZE->( MsUnLock() )
			Endif
			Loop
		Endif
		
		// Se o registro eh valido no browser e achar na base ele altera, senaum ele inclui
		SZE->( MsSeek( xFilial("SZE")+cAD1_NROPOR+aCols[nI,nPosMes]+aCols[nI,nPosAno] ) )
		SZE->( RecLock( "SZE", SZE->(!Found()) ) )
		
			SZE->ZE_FILIAL	:= xFilial("SZE")
			SZE->ZE_NROPOR	:= cAD1_NROPOR
			SZE->ZE_MES		:= aCols[nI,nPosMes]
			SZE->ZE_ANO		:= aCols[nI,nPosAno]
			SZE->ZE_VALOR	:= aCols[nI,nPosVlr]
	
		SZE->( MsUnLock() )
		
	Next
	
End Transaction

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSA041OK ºAutor  ³Opvs (David)        º Data ³  23/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTSA041OK

Local nGDLin := oMsGetD:nAt
Local nGDCol := 1
Local lRet 	 := .T.
Local nConta := 0

//Valida campos obrigatorios do MsNewGetDados
For nGDCol:=1 To Len(oMsGetD:aHeader)
	If X3OBRIGAT(oMsGetD:aHeader[nGDCol,2]) .And. Empty(oMsGetD:aCols[nGDLin,nGDCol])
		lRet := .F.
		Help(" ",1,"OBRIGAT2",,AllTrim(SX3->(RetTitle(oMsGetD:aHeader[nGDCol,2]))),3,1)
		nGDCol:=Len(oMsGetD:aHeader)
	EndIf
Next nGDCol

Return(lRet)     

/*******
 *
 * Rotina: A041TOK
 * Autor.: Robson Gonçalves
 * Data..: 08/11/2013
 * Descr.: Validação do tudo OK na MsGetDados.
 *
 ***/
User Function A041TOK()
	Local lRet := .T.
	
	Local nI := 0
	Local nDel := 0
	Local nLoop := 0
	Local nVALOR := 0
	Local nAD1Verba := 0
	Local nZE_MES := 0
	Local nZE_ANO := 0
	Local nZE_VALOR := 0
	
	nLoop := Len(oMsGetD:aCOLS)
	
	nZE_MES   := GdFieldPos('ZE_MES',oMsGetD:aHeader)
	nZE_ANO   := GdFieldPos('ZE_ANO',oMsGetD:aHeader)
	nZE_VALOR := GdFieldPos('ZE_VALOR',oMsGetD:aHeader)
	
	For nI := 1 To nLoop
		If oMsGetD:aCOLS[ nI, Len(oMsGetD:aHeader)+1 ]
			nDel++
		Else
			If (Empty(oMsGetD:aCOLS[ nI, nZE_MES ]) .Or.;
			    Empty(oMsGetD:aCOLS[ nI, nZE_ANO ]) .Or.;
			    Empty(oMsGetD:aCOLS[ nI, nZE_VALOR ]))
			    lRet := .F.
			    nI := nLoop
			    MsgAlert('Atenção! Ao confirmar a gravação é obrigatório o preenchimento de todos os campos, sendo Mês, Ano e Valor.','A041TOK')
			Else
				nVALOR += oMsGetD:aCOLS[ nI, nZE_VALOR ]
			Endif
		Endif
	Next nI
	
	If lRet .And. lFATA310
		If nDel == nLoop
			lRet := .F.
			MsgAlert('Ao confirmar a gravação todos os registros não podem estar apagados e lembrando, é obrigatório o preenchimento de todos os campos, sendo Mês, Ano e Valor.','A041TOK')
		Else
			If ValType(M->AD5_VERBA)=='N'
				nAD1Verba := Posicione('AD1',1,xFilial('AD1')+M->AD5_NROPOR,'AD1_VERBA')
				IF M->AD5_VERBA <> nAD1Verba
					M->AD5_VERBA := nAD1Verba
				EndIF
				If nVALOR > M->AD5_VERBA
					lRet := .F.
					Msgalert('O valor da expectativa mensal de verba não pode ser maior que o valor da verba no apontamento.','A041TOK')
				Endif
				If lRet .And. nVALOR > Posicione('AD1',1,xFilial('AD1')+M->AD5_NROPOR,'AD1_VERBA')
					lRet := .F.
					Msgalert('O valor da expectativa mensal de verba não pode ser maior que o valor da verba na oportunidade.','A041TOK')
				Endif
			Endif
		Endif
	Endif
Return(lRet)