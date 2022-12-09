#INCLUDE "TMKXFUNC.CH"
#INCLUDE "PROTHEUS.CH"
#include 'parmtype.ch' 
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "APWIZARD.CH"

user function VQCPYTMK(cAlias,nReg,nOpc)
	
Local aArea		:= GetArea()					// Salva a area atual
Local lRet		:= .F.							// Retorno da funcao
Local oWizard									// Objeto do assistente (Wizard)
Local oData										// Objeto com a data
Local dData		:= CTOD("//")					// Data do novo atendimento
Local oDataEntrega								// Objeto com a data da entrega
Local dDataEntrega := CTOD("//")				// Data da entrega
Local oCodCli									// Objeto com o Codigo do novo cliente/Prospect
Local cCodCli	:= CRIAVAR("A1_COD",.F.)		// Variavel com o Codigo do novo cliente/Prospect
Local oCodLoja									// Objeto com o Codigo da Loja do novo cliente/Prospect
Local cCodLoja	:= CRIAVAR("A1_LOJA",.F.)		// Variavel com o Codigo da Loja do  novo cliente/Prospect
Local oMeter									// Objeto com a barra de progressao
Local nMeter	:= 0							// Contador com a barra de progressao
Local oSayRodape								// Objeto Texto do Rodape do Wizard									
Local cSayRodape:= ""							// Conteudo do texto do rodape do Wizard
Local oSDat                                 	// Objeto data do Wizard
Local cSDat		:= ""							// Variavel data do Wizard
Local oSDatEntrega                          	// Objeto data do Wizard
Local cSDatEntrega := ""						// Variavel data do Wizard
Local oMantemDataEntrega						// Objeto Variavel com a opcao de manter ou nao manter a data da entrega do Atendimento de origem 
Local lMantemDataEntrega := .F.					// Mantem a data da entrega do Atendimento de origem
Local oOperad									// Objeto para get do novo operador
Local cOperad	:= CRIAVAR("UA_OPERADO",.F.)	// Descricao do nome do novo operador 
Local oSayOper									// Objeto com say do operador para o Wizard
Local cSayOper	:= ""							// Descricao do operador para o Wizard
Local cDesc		:= CRIAVAR("A1_NOME",.F.)		// Variavel com o Nome da empresa (Cliente ou Prospect)
Local oDesc										// Objeto Variavel com o Nome da empresa (Cliente ou Prospect)
Local cNovaEmp	:= CRIAVAR("A1_NOME",.F.)		// Variavel com o Nome da empresa (Cliente ou Prospect)
Local oNovaEmp									// Objeto Variavel com o Nome da empresa (Cliente ou Prospect)
Local lVldCli	:= .F.							// Valida cliente digitado na copia
Local aCmpCpy   := {}							// Recebe conteudo do ponto de entrada TMKXCPAT
Local lTMKXCPAT := ExistBlock("TMKXCPAT")       // Verifica se o ponto de entrada TMKXCPAT esta em uso.
Local lEditCmps := .T. 							// Possibilita editar os campos da wizard - Utilizada pelo ponto TMKXCPAT

If Type("nFolder") = "U"
	Private nFolder := 2						// Variavel com o folder de Televendas para compatibilizacao com a funcao TMKPO
Endif	

If Type("lProspect") == "U"
	Private lProspect:= .F.
Endif 

If cAlias <> "SUA"
	Return(lRet)
Endif	

DbSelectarea(cAlias)
DbSetorder(1)
DbGoto(nReg)
If Eof()
	Help( " ", 1, "ARQVAZIO" )
	Return(lRet)
Endif
cOperad := SUA->UA_OPERADO 										// Sugere o operador do atendimento posicionado
cSayOper:= Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_NOME")

If SUA->UA_PROSPEC
	cDesc := Posicione("SUS",1,xFilial("SUS")+SUA->UA_CLIENTE+SUA->UA_LOJA,"US_NOME")
Else
	cDesc := Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME")
Endif

If lTMKXCPAT
	aCmpCpy := ExecBlock("TMKXCPAT",.F.,.F.,{dData,cCodCli,cCodLoja,cOperad,dDataEntrega,lMantemDataEntrega,lEditCmps})
	If ValType(aCmpCpy) == "A"
		dData := IIF(ValType(aCmpCpy[1])=="D",aCmpCpy[1],dData)
		cCodCli := IIF(ValType(aCmpCpy[2])=="C",aCmpCpy[2],cCodCli)
		cCodLoja := IIF(ValType(aCmpCpy[3])=="C",aCmpCpy[3],cCodLoja)
		cOperad := IIF(ValType(aCmpCpy[4])=="C",aCmpCpy[4],cOperad)
		dDataEntrega := IIF(ValType(aCmpCpy[5])=="D",aCmpCpy[5],dDataEntrega)
		lMantemDataEntrega := IIF(ValType(aCmpCpy[6])=="L",aCmpCpy[6],lMantemDataEntrega)
		If Len(aCmpCpy) > 6 //Quantidade antiga de elementos no array do ponto de entrada
			lEditCmps := IIF(ValType(aCmpCpy[7])=="L",aCmpCpy[7],lEditCmps)
		EndIf
		
		Tk271VldOper(@cSayOper,@cOperad,@oSayOper)
		lVldCli := TkxVldCli( cCodCli, @cCodLoja )
		cNovaEmp := TK271VldEmp(cCodCli,cCodLoja)
		cSDat := Tk_DiaSemana( dData,,0)
		cSDatEntrega := Tk_DiaSemana( dDataEntrega,,0)
	EndIf
EndIf

DEFINE WIZARD oWizard TITLE STR0021 HEADER STR0022 MESSAGE STR0023 TEXT " " ; 
	NEXT {||IIF(!Empty(dData) .AND. !EMPTY(cDesc) .AND.;
			Tk271CpyVal(dData		, cCodCli  			, cCodLoja		, cOperad,;
						dDataEntrega, lMantemDataEntrega);
			.AND. !EMPTY(cSayOper) .AND. lVldCli,.T.,.F.) } FINISH {||.F.} PANEL NOFIRSTPANEL 
	
	oWizard:GETPANEL(1) 

	@ 05,20 SAY STR0024	OF oWizard:GETPANEL(1) PIXEL SIZE 150,9 // "Atendimento selecionado :"
	@ 05,90 SAY SUA->UA_NUM + "-" + cDesc + IIF(SUA->UA_PROSPECT,STR0025,STR0026) OF oWizard:GETPANEL(1) COLOR CLR_RED PIXEL SIZE 200,9 // "(Prospect)" "(Cliente)"
	
	@ 11,20 SAY STR0027  OF oWizard:GETPANEL(1) PIXEL SIZE 150,9 // "Data do novo Atendimento:"
	@ 21,20 MSGET oData VAR dData SIZE 40,10 OF oWizard:GETPANEL(1) VALID(!EMPTY(dData),cSDat := Tk_DiaSemana( dData,,0) ,oSDat:Refresh()) PIXEL When lEditCmps 
	@ 23,65 SAY oSDat Var cSDat OF oWizard:GETPANEL(1) COLOR CLR_RED PIXEL SIZE 210,9 	// Dia da Semana

	@ 41,20 SAY STR0028 OF oWizard:GETPANEL(1) PIXEL SIZE 150,9 // "Cliente/Prospect para o novo atendimento:"
	@ 51,20 MSGET oCodCli  VAR cCodCli  SIZE 40,10 Picture "@!" F3 "CLT" OF oWizard:GETPANEL(1) VALID ( lVldCli := TkxVldCli( cCodCli, @cCodLoja ), oCodLoja:Refresh() ,cNovaEmp := TK271VldEmp(cCodCli,cCodLoja),oNovaEmp:Refresh() ) PIXEL When lEditCmps 
	@ 51,70 MSGET oCodLoja VAR cCodLoja SIZE 5,10 Picture "!!" OF oWizard:GETPANEL(1) VALID ( !EMPTY( cCodLoja ) ) PIXEL When lEditCmps
	@ 53,90 SAY oNovaEmp Var cNovaEmp OF oWizard:GETPANEL(1) COLOR CLR_RED PIXEL SIZE 210,9 	// Nome do Cliente/Prospect
	
	@ 71,20 SAY STR0029 OF OWizard:GETPANEL(1) PIXEL SIZE 210,9 // "Selecione o Operador para o novo Atendimento:"
	@ 81,20 MSGET oOperad VAR cOperad SIZE 10,10 F3 "SU7" OF OWizard:GETPANEL(1) VALID Tk271VldOper(@cSayOper,@cOperad,@oSayOper) PIXEL When lEditCmps    
	@ 83,60 SAY oSayOper Var cSayOper OF oWizard:GETPANEL(1) COLOR CLR_RED PIXEL SIZE 210,9 	// Nome do Operador
	
	@ 101,20 SAY STR0030  OF oWizard:GETPANEL(1) PIXEL SIZE 160,9 // "Data da entrega para todos os itens do novo Atendimento:"
	@ 111,20 MSGET oDataEntrega VAR dDataEntrega SIZE 40,10 OF oWizard:GETPANEL(1) WHEN .T. VALID(!EMPTY(dDataEntrega) .AND. dDataEntrega >= dData,cSDatEntrega := Tk_DiaSemana( dDataEntrega,,0) ,oSDatEntrega:Refresh())PIXEL
	@ 113,65 SAY oSDatEntrega Var cSDatEntrega OF oWizard:GETPANEL(1) COLOR CLR_RED PIXEL SIZE 210,9 	// Dia da Semana
	//@ 126,20 CHECKBOX oMantemDataEntrega VAR lMantemDataEntrega SIZE 160,8 PIXEL OF oWizard:GETPANEL(1) When lEditCmps ON CHANGE ( IIF(lMantemDataEntrega,oDataEntrega:Disable(),oDataEntrega:Enable()) ) PROMPT STR0031 When lEditCmps // "Manter data da entrega do Atendimento de origem"
	
	CREATE PANEL oWizard  HEADER STR0032 MESSAGE STR0033; 
		 BACK {||.T.};
		 NEXT {||.F.};
		 FINISH {||Tk271GrvCpy(	oMeter	,cAlias	,nReg		,dData,;
		 						cOperad	,cCodCli,cCodLoja	,dDataEntrega,;
		 						lMantemDataEntrega)} PANEL 
		 oWizard:GETPANEL(2)

	@ 10,10 TO 70,190 LABEL "" OF oWizard:GETPANEL(2)  PIXEL
	@ 20,20 SAY STR0034 + "  " + DTOC(dData) + "-" + cSDat OF oWizard:GETPANEL(2) PIXEL SIZE 150,9 // "Data do Atendimento: "
	@ 45,20 SAY STR0035 + cCodCli+"/"+cCodLoja OF oWizard:GETPANEL(2) PIXEL SIZE 250,9 // "Codigo do Cliente/Prospect: "
	
	cSayRodape := STR0036 

	@ 80,10 SAY oSay Var cSayRodape OF oWizard:GETPANEL(2) PIXEL SIZE 250,9 
	
 	/*
 	 O "METER" Sera feito com o CONSTRUCTOR da CLASSE porque o TMKDEF.CH tem um DEFINE TOTAL que 
 	 conflita com a PROPRIEDADE TOTAL do objeto METER
 		
 	 [ <oMeter> := ] TMeter():New( 	<nRow>, <nCol>, bSETGET(<nActual>),;
								    <nTotal>, <oWnd>, <nWidth>, <nHeight>, <.update.>, ;
								    <.lPixel.>, <oFont>, <cPrompt>, <.lNoPercentage.>,;
								    <nClrPane>, <nClrText>, <nClrBar>, <nClrBText>, <.lDesign.> )
	*/
		
	oMeter	:= TMeter():New(90	,10 , bSETGET(nMeter),;
							100	,oWizard:GETPANEL(2),10,140,.T.,;
							.T.)
	oMeter:Hide()
	oSay:Hide()

ACTIVATE WIZARD oWizard CENTERED  WHEN {||.T.}

RestArea(aArea)
Return (lRet)


Static Function Tk271VldOper(cSayOper,cOperad,oSayOper)

Local lRet  := .F.   		// Retorno da funcao
Local aArea := GetArea()	// Salva a area atual

If !Empty(cOperad)
	DbSelectArea("SU7")
	DbSetOrder(1)
	If DbSeek(xFilial("SU7")+cOperad)
		cSayOper := SU7->U7_NOME
		If ValType(oSayOper) == "O"
			oSayOper:Refresh()
		EndIf
		lRet:= .T.
	Else
		Help(" ",1,"REGNOIS")
	Endif
Endif 

RestArea(aArea)
Return(lRet)

Static Function TkxVldCli( cCodCli, cCodLoja )
Local lRet := .T.					// Variavel para retorno da funcao

If Empty( cCodCli )
	lRet := .F.
Endif
If(lRet .And.  !SUS->( DbSeek( xFilial( "SUS" ) + cCodCli + cCodLoja ) ) )
	lProspect := .F.
EndIf
If lRet .And. !lProspect
	SA1->(DbSetOrder( 1 ))
	If !( SA1->( DbSeek( xFilial( "SA1" ) + cCodCli + cCodLoja ) ) )
		If SA1->( DbSeek( xFilial( "SA1" ) + cCodCli ) )
			cCodLoja := SA1->A1_LOJA
		Else
			ExistCpo( "SA1", cCodCli )
			lRet := .F.
		Endif	
	Endif
Endif

If lRet .And. lProspect
	SUS->(DbSetOrder( 1 ))
	If !( SUS->( DbSeek( xFilial( "SUS" ) + cCodCli + cCodLoja ) ) ) 
		If SUS->( DbSeek( xFilial( "SUS" ) + cCodCli ) )
			cCodLoja := SUS->US_LOJA
	    Else
			ExistCpo( "SUS", cCodCli )
			lRet := .F.
		EndIf		
	EndIf	
EndIf    

Return (lRet)

Static Function TK271VldEmp(cCodCli,cCodLoja)
Local cDesc := CRIAVAR("A1_NOME",.F.)

If !Empty(cCodCli) .AND. !Empty(cCodLoja)
	If lProspect
		cDesc := Posicione("SUS",1,xFilial("SUS")+cCodCli+cCodLoja,"US_NOME")
	Else
		cDesc := Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_NOME")
	Endif
Endif

Return(cDesc)


Static Function Tk271CpyVal(dData		, cCodCli  			, cCodLoja		, cOperad,;
					 		dDataEntrega, lMantemDataEntrega)

Local lRet 			:= .T.							// Retorno da funcao
Local lRetPE		:= Nil							// Retorno do ponto de entrada U_TK271COP
Local aAreaPE		:= {}							// Salva a area antes de executar o ponto de entrada
Local lTK271Copia	:= FindFunction("U_TK271COP")	// Ponto de entrada para validar a copia do atendimento

If (dData < dDataBase)
	Help("",1,"DATA_INVAL","Data do Novo Atendimento Inválida","Valor informado na Data de Atendimento inferior a data atual")
	lRet := .F.
Endif

If lRet .AND. lTk271Copia
	
	aAreaPE	:= GetArea()
	
	lRetPE := U_TK271COP(	SUA->UA_NUM	, dData			, cCodCli  			, cCodLoja		,;
							cOperad		, dDataEntrega	, lMantemDataEntrega)
	
	If ValType(lRetPE) == "L"
		lRet := lRetPE
	EndIf            
	
	RestArea(aAreaPE)
	
EndIf

Return(lRet)


Static Function Tk271GrvCpy(oMeter	,cAlias	,nReg		,dData,;
							cOperad	,cCodCli,cCodLoja	,dDataEntrega,;
							lMantemDataEntrega)

Local cNumAte    := CRIAVAR("UA_NUM",.F.)	// Codigo atendimento selecionado
Local cOper		 := ""						// Operacao do atendimento 1- Faturamento, 2- Orcamento, 3- Atendimento
Local cNovoAte   := ""						// Codigo do NOVO atendimento 
Local nCampo     := 0						// Variavel para detectar o conteudo dos campos que serao gravados atraves do FieldPut
Local nRegistros := 0						// Contole de registros gravados
Local aOriSUA    := Array(1,FCount())		// Array com campos para copia do SUA
Local aOriSUB    := Array(1,FCount())		// Array com campos para copia do SUB
Local aOriSL4    := Array(1,FCount())		// Array com campos para copia do SL4
Local lRet		 := .F.						// Retorno da funcao
Local nTotal	 := 0            			// Contador para a barra de progressao
Local nTotAux	 := 0						// Contador auxiliar para o FOR
Local cCampos	 := ""						// Campos que nao podem ser gravados
Local nPosCF	 := 0						// Posicao no array do CFOP
Local cTes		 := ""						// Define a TES que foi utilizada para verificar o CFOP
Local lTK271FCPY := ExistBlock("TK271FCPY")	//P.E. acionado ao fim de cada copia de atendimento
Local lTK271NCPY := ExistBlock("TK271NCPY")	//P.E. uti
Local i			 := 0

cCampos:= "UA_NUMSL1/UA_NUMSC5/UA_EMISNF/UA_SERIE/UA_CODOBS/UA_DOC/UA_CANC/UA_CODCANC/UA_CODCONT/UA_DESCNT/UA_TRANSP/UA_CONDPG/UA_PROXLIG/UA_HRPEND/UB_NUMPV"

If lTK271NCPY
	aRetCpos :=	ExecBlock("TK271NCPY",.F.,.F.)
	If ValType(aRetCpos) == "A"
		For i := 1 To Len(aRetCpos)
			cCampos += "/" + aRetCpos[i]
		Next i
	EndIf
EndIf

DbSelectArea( cAlias )
DbSetOrder( 1 )
DbGoto( nReg )
If nReg == Recno()
	// Pega o codigo do atendimento
	cNumAte := SUA->UA_NUM
	cOper	:= SUA->UA_OPER

	// Verifica o total de itens do atendimento
	nTotal	:= Tk271TotCpy( cNumAte )
	oMeter:SetTotal( nTotal )
	nTotal 	:= 0

	nTotAux := FCount()
	For nCampo := 1 To nTotAux
		aOriSUA[1,nCampo] := FieldGet( nCampo )
	Next nCampo
    
	If cOper == "3"	
		lRet := .T.
	Else
		lRet := .F.
	Endif

	DbSelectarea( "SUB" )
	DbSetorder( 1 )
	If DbSeek( xFilial( "SUB" ) + cNumAte )
		aOriSUB := {}

		While !Eof() 							.AND.;
			(xFilial("SUB") == SUB->UB_FILIAL)	.AND.;
			(cNumAte == SUB->UB_NUM)
			
			AAdd( aOriSUB,Array( FCount() ) )
			nTotAux := FCount()

			For nCampo := 1 To nTotAux
				aOriSUB[Len( aOriSUB ),nCampo]	:= FieldGet( nCampo )

				If Alltrim( FieldName( nCampo ) ) == "UB_TES"
					cTes	:= FieldGet( nCampo )
				ElseIf Alltrim( FieldName( nCampo ) ) == "UB_CF"
					nPosCF	:= nCampo
				Endif
			Next nCampo

			aOriSUB[Len( aOriSUB ), nPosCF ]:= TK273Cfo( cCodCli, cCodLoja, cTes )
			SUB->( DbSkip() )
		End

		lRet:= .T.
	Else
		aOriSUB := {}
	Endif
	
	DbSelectarea( "SL4" )
	DbSetorder( 1 )
	If DbSeek( xFilial( "SL4" ) + cNumAte + "SIGATMK " )
		aOriSL4 := {}
		
		While !Eof() 						   .AND. ;
			(SL4->L4_FILIAL == xFilial("SL4")).AND. ;
			(SL4->L4_NUM == cNumAte)		   .AND. ;
			(Alltrim( SL4->L4_ORIGEM ) == "SIGATMK" )
			
			AAdd( aOriSL4,Array( FCount() ) )
			
			nTotAux := FCount()
			For nCampo := 1 To nTotAux
				aOriSL4[Len(aOriSL4),nCampo]:= FieldGet( nCampo )
			Next nCampo
			
			SL4->( DbSkip() )
		End
	Else
		aOriSL4 := {}
	Endif
Endif
	
If lRet
	
	BEGIN TRANSACTION
		
		RecLock("SUA",.T.)
		nTotAux := FCount()
		For nCampo := 1 To nTotAux
			Do Case
				Case ( Field( nCampo ) == "UA_NUM" )
					cNovoAte := TkNumero("SUA","UA_NUM")
					FieldPut( nCampo, cNovoAte )
					ConfirmSx8()

				Case ( Field( nCampo ) == "UA_CLIENTE" )
					FieldPut( nCampo, cCodCli )
					
				Case ( Field( nCampo ) == "UA_LOJA" )
					FieldPut( nCampo, cCodLoja )

				Case ( Field( nCampo ) == "UA_EMISSAO" )
					FieldPut( nCampo, dData )
					
				Case ( Field( nCampo ) == "UA_OPERADO" )
					FieldPut( nCampo, cOperad )
					
				Case ( Field( nCampo ) == "UA_OPER" )
					FieldPut( nCampo, IIF(cOper == "3",cOper,"2") )

				Case ( Field( nCampo ) == "UA_STATUS" )
					FieldPut( nCampo, "ORC" )

				Case ( Field( nCampo ) == "UA_PROSPEC" )
					FieldPut( nCampo, lProspect )

				Case ( Field( nCampo ) == "UA_INICIO" )
					FieldPut( nCampo, Time() )

				Case ( Field( nCampo ) == "UA_FIM" )
					FieldPut( nCampo, Time() )

				Case ( Field( nCampo ) == "UA_DTLIM" )	
					FieldPut( nCampo, dData + TkPosto(cOperad,"U0_VALIDAD") )
				
				Case ( Field( nCampo ) == "UA_TRANSP" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_TRANSP") )

				Case ( Field( nCampo ) == "UA_ENDCOB" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ENDCOB") )

				Case ( Field( nCampo ) == "UA_BAIRROC" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_BAIRROC") )
					
				Case ( Field( nCampo ) == "UA_MUNC" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_MUNC") )
				
				Case ( Field( nCampo ) == "UA_CEPC" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_CEPC") )
				
				Case ( Field( nCampo ) == "UA_ESTC" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ESTC") )
					
				Case ( Field( nCampo ) == "UA_ENDENT" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ENDENT") )
				
				Case ( Field( nCampo ) == "UA_BAIRROE" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_BAIRROE") )  
				
				Case ( Field( nCampo ) == "UA_MUNE" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_MUNE") )
				
				Case ( Field( nCampo ) == "UA_CEPE" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_CEPE") )
				
				Case ( Field( nCampo ) == "UA_ESTE" )
					FieldPut( nCampo, Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoja,"A1_ESTE") )
				
				OtherWise

					If !Field(nCampo) $ cCampos							
						FieldPut( nCampo, aOriSUA[1,nCampo] )
					Endif
			EndCase
		Next nCampo
		
		MsUnLock()
		DbCommit()
		
		If Len( aOriSUB ) > 0 //Se existirem registros no SUB do atendimento de origem
			nTotAux := Len( aOriSUB )
			For nRegistros := 1 To nTotAux
				
				RecLock("SUB",.T.)
				For nCampo := 1 To FCount()
					If ( Field( nCampo ) == "UB_NUM" )
						FieldPut( nCampo, cNovoAte )
					ElseIf ( !lMantemDataEntrega .AND. Field( nCampo ) == "UB_DTENTRE" )
						FieldPut( nCampo, dDataEntrega )						
					Else
						If !Field(nCampo) $ cCampos												
							FieldPut( nCampo, aOriSUB[nRegistros,nCampo] )
						Endif
					EndIf
				Next nCampo
				
				MsUnLock()
				DbCommit()
				
				//Atualiza barra de progressao
				oMeter:Set( nTotal + 1 )
				oMeter:Refresh()
			Next nRegistros
	    Endif
		
		If Len( aOriSL4 ) > 0 //Se existirem registros no SL4 com as parcelas de pagamento de origem

			nTotAux := Len( aOriSL4 )
			For nRegistros := 1 To nTotAux
				
				RecLock("SL4",.T.)
				For nCampo := 1 To FCount()
					If ( Field( nCampo ) == "L4_NUM" )
						FieldPut( nCampo, cNovoAte )
					Else
						FieldPut( nCampo, aOriSL4[nRegistros,nCampo] )
					Endif
				Next nCampo
				
				MsUnLock()
				DbCommit()
				
				//Atualiza barra de progressao
				oMeter:Set( nTotal + 1 )
				oMeter:Refresh()
			Next nRegistros
		Endif
		
	END TRANSACTION

	If lTK271FCPY
		ExecBlock("TK271FCPY", .F., .F., {cNumAte, cNovoAte})
	EndIf

Endif
	
Return ( lRet )
