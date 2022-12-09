#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "Fileio.CH"

#DEFINE WFTYPE_INFORMATION 		1
#DEFINE WFTYPE_AUTHORIZATION 	2
#DEFINE EV_RUNTASK 4
#DEFINE EV_FINISH 99

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK10   ºAutor  Opvs(warleson)       º Data ³  11/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função auxliar: Envio de workflow informativo             º±±
±±º          ³  Executa rotina de envio de workflow                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ServiceDesk - Certisign                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTSDK10()
	Local cCodWFTemplate	:= "" //Armazena o codigo do Template de Workflow
	Local aHeaderADF 		:= aClone(aHeader)
	Local aColsADF	 	:= aClone(aCols)
	Local nItem		 	:= if(ascan(acols,{|p| p[ 1 ] == 	ADF->ADF_ITEM } )=0,Len(aCols),ascan(acols,{|p| p[ 1 ] == 	ADF->ADF_ITEM } ))//Len(aCols)
	Local nItmPos		 	:= nItem
	Local cCodADE			:= ''
	Local lValidaConta	:= ''
	Local cPasta			:= ''
	Local lRet				:= .T.
	Local lFromOk			:= .T.
	Local nPosADF			:= Ascan( aHeaderADF, { |x| AllTrim(x[2]) == "ADF_CODSUQ" } )
	//	  nItmPos := if(nItmPos=0,Len(aCols),nItmPos)

	//lRet == .T. Envio de WF pela rotina padrão
	//lRet == .F. Envio de WF PELA rotina personalizada

	// Verifica se eh o item do atendimento com a acao que envia workflow
	If ADF->ADF_CODSUQ == SUQ->UQ_SOLUCAO
		//Força o posicionamento para sempre buscar o template correto.
		If nPosADF > 0
			SUQ->(DbSetOrder(1))
			SUQ->(DbSeek(xFilial("SUQ")+aColsADF[nItmPos,nPosADF]))
		EndIf
	   cCodWFTemplate := SUQ->UQ_WFTEMPL
	EndIf

	If !Empty(cCodWFTemplate)
		// Valida e-mail de origem antes do envio
		lFromOk := u_CTSDKVWF( ADE->ADE_EMAIL2 )
		
		IF !lFromOk
			MsgStop('Atenção, não será enviado o e-mail conforme o parâmetro MV_XSDKNWF.','CTSDK10 |001')
			Return
		Else
			IF ValidaConta(@cPasta)
				//Garantir que esta posicionado no ADE
				If ADE->(!Eof()) .AND. !Empty(ADE->ADE_CODIGO)
					cCodADE := ADE->ADE_CODIGO
				Endif
	
				//Executa rotina de envio de workflow
				oWFTemplate := WFTemplate():New()
				SendWFTemplate(cCodWFTemplate, aHeaderADF, aColsADF, __cUserId, nItem, cPasta,nItmPos)
			EndIf
		EndIF
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SendWFTemplateºAutor³Vendas Clientes   º Data ³  18/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia o Template associado ao atendimento.              	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SendWFTemplate(cCodTemplate, aHeaderADF, aColsADF, cCodUser, nCodItem,cPasta,nItmPos)
	Local oWFTemplate	 := Nil
	Local oWFInfo 	 := Nil
	Local lRet 		 := .F.
	Local nItem 		 := 0  						//Controle do Loop
	Local nOcoPos 	 := 0						//Armazena a posicao do campo Ocorrencia
	Local oItem		 := Nil						//Objeto contendo a linha do item que será enviado no email.
	Local nHeader 	 := 0 						//Controle do Loop no aHeader
	Local lTK510ATTF	 := ExistBlock("TK510ATTF")	//Ponto de Entrada para envio de anexo no workflow
	Local cAnexo 		 := ""						//Retorno do P.E. com o nome do arquivo
	Local aCBoxOption	 := {}						// Pesquisa opcoes do campo no dicionario
	Local cBoxValue	 := ""
	Local aArea 		 := {}
	Local nPosCodSU9	 := 0
	Local lInsertAct	 := .T.
	Local cCodADE		 := ADE->ADE_CODIGO
	Local nPosCodItem	 := 0
	Local nPosCBox	 := 0
	Local c2Find 		 := ""
	Local nCount		 := 0
	Local nCount2		 := 0
	Local cFirstWFCod	 := ""

	Default cCodUser := RetCodUsr()

	Private INCLUI := .F.
	Private ALTERA := .T.

	aArea := { GetArea(), ADE->( GetArea() ), ADF->( GetArea() ), SU9->( GetArea() ), WF7->( GetArea() ) }

	RegToMemory("ADE",.F.)

	oWFTemplate := WFTemplate():New()

	lRet := oWFTemplate:load(cCodTemplate)

	If lRet
		aWFs := oWFTemplate:buildWF(cCodUser, .T.)

		If ValType(aWFs) != "A"
			aWFs:= {aWFs}
		EndIf

		oWFTemplate:setKnowledgeBase("ADE")
		oWFTemplate:setKBName(xFilial("ADE")+cCodADE)

		For nCount := 1 To Len( aWFs )
			oWFInfo := aWFs[nCount]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do cabeçalho do atendimento |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SX3")
			DbSetOrder(1)
			DbSeek("ADE")
			While !EOF() .AND. SX3->X3_ARQUIVO == "ADE"
				If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
					If SX3->X3_CONTEXT == "V"
						If AllTrim(SX3->X3_CAMPO) == "ADE_INCIDE"
							oWFInfo:Header:addField(X3Titulo(), MSMM(ADE->ADE_CODINC,TamSx3("ADE_INCIDE")[1]))
						Else
							oWFInfo:Header:addField(X3Titulo(), CriaVar(SX3->X3_CAMPO,.T.))
						EndIf
					Else
						If Empty(SX3->X3_CBOX)
							oWFInfo:Header:addField(X3Titulo(), Eval(&("{||ADE->"+SX3->X3_CAMPO+"}"),""))
						Else
							aCBoxOption	:= TMKA510CBOX(SX3->X3_CAMPO)
							If Eval(&("{||ADE->"+SX3->X3_CAMPO+"}")) $ "1234567890" .AND. Val(Eval(&("{||ADE->"+SX3->X3_CAMPO+"}"))) <= Len(aCBoxOption)
								c2Find := Eval(&("{||ADE->"+SX3->X3_CAMPO+"}"))
								nPosCBox := AsCan(aCBoxOption,{|x| x[1] == c2Find } )
								If nPosCBox > 0
									cBoxValue  := aCBoxOption[nPosCBox][2]
								Else
									cBoxValue := ""
								EndIf
							Else
								cBoxValue := ""
							EndIf
							oWFInfo:Header:addField(	X3Titulo(), cBoxValue)
						EndIf
					EndIf
				EndIf
				DbSkip()
			End

			For nHeader := 1 To Len(aHeaderADF)
				If AllTrim(aHeaderADF[nHeader,2]) == "ADF_CODSU9"
					nPosCodSU9 := nHeader
				EndIf
				If AllTrim(aHeaderADF[nHeader,2]) == "ADF_ITEM"
					nPosCodItem := nHeader
				EndIf
			Next nHeader

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos items do atendimento 	 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nItem:=1 To nItmPos//Len(aColsADF)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a ocorrência utilizada na linha ³
			//³do atendimento pode ser exibida pelo cliente ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lInsertAct := .T.
				If nPosCodSU9 > 0
					DbSelectArea("SU9")
					DbSetOrder(2)
					If 	SU9->(FieldPos("U9_VISIVEL")) > 0		.AND.;
							!Empty(aColsADF[nItem][nPosCodSU9]) 	.AND.;
							MsSeek( xFilial("SU9") + aColsADF[nItem][nPosCodSU9])

						If SU9->U9_VISIVEL == "2"
							lInsertAct := .F.
						EndIf
					EndIf
				EndIf

				If lInsertAct
					oItem := WFItens():new()
					For nHeader := 1 To Len(aHeaderADF)-2
						oItem:addField(aHeaderADF[nHeader][1], aColsADF[nItem][nHeader])
					Next nHeader
					oWFInfo:addRow(oItem)
				EndIf
			Next nItem
		Next

	// Preenche os dados do(s) workflow(s)
		If Len(aWFs) > 0
			fillFields(@aWFs[1] , cCodUser, @aWFs,@oWFTemplate,cCodADE )
		EndIf

		cFirstWFCod := ""
		For nCount := 1 To Len( aWFs )
			oWFInfo := aWFs[nCount]

		// Adiciona arquivos anexos por ponto de entrada
			If lTK510ATTF
				cAnexo := ExecBlock("TK510ATTF",.F.,.F., {cCodADE, cCodTemplate})
				If ValType(cAnexo)=="C"
					oWFInfo:attachFile(cAnexo)
				ElseIf ValType(cAnexo)=="A"
					For nCount2 := 1 To Len( cAnexo )
						oWFInfo:attachFile(cAnexo[nCount2])
					Next
				EndIf
			EndIf

		// Se for multiaprovação, serão enviados vários workflows, se já foi enviado um, anota o registro de workflow que encabeça a lista de workflows
			If !Empty(cFirstWFCod) .And. AttIsMemberOf( oWFInfo, "CLOTEAPR" )
				oWFInfo:cLoteApr := cFirstWFCod
			EndIf

			ProcessMessage()
			MSAguarde({||Start(oWFInfo,cPasta)},'Aguarde...','Enviando Workflow',.F.)

		// Se for autorização, configura o bloco de código de retorno
			If Val(oWFTemplate:wfType) == WFTYPE_AUTHORIZATION
				oWFInfo:codeBlockWhenReplied:codeBlock := "TK510RETWF('" + cCodADE + "')"
			EndIf
			oWFInfo:save()

		// Se for o primeiro workflow anota o id dele
			If Empty(cFirstWFCod) .And. AttIsMemberOf( oWFInfo, "ID" )
				cFirstWFCod := oWFInfo:id
			EndIf
		Next

	// Se for workflow de autorização, altera o status do chamado para pendente (só se ele não estiver encerrado)
		If Val(oWFTemplate:wfType) == WFTYPE_AUTHORIZATION
			DbSelectArea("ADE")
			DbSetOrder(1)
			If 	MsSeek(xFilial("ADE")+cCodADE).AND.;
					ADE->ADE_STATUS <> "3"

				BEGIN TRANSACTION
					RecLock("ADE", .F.)
					REPLACE ADE->ADE_STATUS WITH "2"
					IF ADE->(FieldPos("ADE_WFASTA")) > 0
						REPLACE ADE->ADE_WFASTA WITH "5"
					EndIf
					MsUnlock()
				END TRANSACTION
			EndIf
		EndIf

	// Grava o código do workflow na linha do chamado e o status dele (quando informativo ou autorização simples é o código do workflow, quando multiautorização é o código do workflow que encabeça os workflows de autorização)
		DbSelectArea("ADF")
		DbSetOrder(1)
		If 	nPosCodItem > 0 .AND.;
				nCodItem	> 0 .AND.;
				ADF->(FieldPos("ADF_CODSKW")) > 0 .AND.;
				MsSeek( xFilial("ADF")+cCodADE+aColsADF[nCodItem][nPosCodItem] )

			BEGIN TRANSACTION
				RecLock("ADF", .F.)
				REPLACE ADF->ADF_CODSKW WITH cFirstWFCod
				If ADF->(FieldPos("ADF_SKWSTA")) > 0 .And. Val(oWFTemplate:wfType) == WFTYPE_AUTHORIZATION
					REPLACE ADF->ADF_SKWSTA WITH "3"
				EndIf
				ADF->(MsUnlock())
			END TRANSACTION
		EndIf

	EndIf

	If FindFunction( "TMKFree" )
		TMKFree( oWFTemplate )
		TMKFree( oWFInfo )
	EndIf

	AEval( aArea, {|xArea| RestArea( xArea ) } )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fillFields   ºAutor  ³Vendas Cliente   º Data ³  19/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza as substriuicoes nos textos a serem enviados.       º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function fillFields(oWF, cCodUser,aWFs,oWFTemplate,cCodADE)
	Local cSubject		:= ""
	Local cBody			:= ""
	Local cHtmlFile		:= ""
	Local cCC			:= ""
	Local cBCC			:= ""
	Local cReplied 		:= ""
	Local cEvalRes		:= ""
	Local nAttSize		:= 0
	Local nPos			:= 0
	Local aDirectory	:= {}
	Local cFileName		:=""
	
	Local oButtonAdd
	Local oButtonClose
	Local oButtonConf
	Local oButtonRem
	Local oListBoxFile
	Local nListBoxFile := 1
	Local oPanelAll
	Local oPanelList
	Local oPanelRight
	Local oPanelTop
	Local oSayTam
	Local oSayTop
	Local nCount
	Static oDlgAttach
	

	Default cCodUser := RetCodUsr()

	nCount := 1

	If aWFs == NIL
		aWFs := { oWF }
	EndIf

	If !Empty(AllTrim(oWFTemplate:htmlFile))
		cHtmlFile := oWFTemplate:htmlFile
	EndIf

// Só irá pegar o destinatário /se não for multiaprovação
	If (!oWFTemplate:lMultiAprov)	.And. Len(aWFs) == 1
		If !Empty(oWFTemplate:cbTo)
			cEvalRes := NIL
			cEvalRes := Eval(&("{||" + oWFTemplate:cbTo + "}"), "")
			If ValType(cEvalRes)=="C"
				aWFs[1]:cProcessedTo := cEvalRes
			EndIf
		EndIf
	EndIf
	If !Empty(oWFTemplate:cbCC)
		cEvalRes := NIL
		cEvalRes := Eval(&("{||" + oWFTemplate:cbCC + "}"), "")
		If ValType(cEvalRes)=="C"
			cCC := cEvalRes
		EndIf
	EndIf
	If !Empty(oWFTemplate:cbCCO)
		cEvalRes := NIL
		cEvalRes := Eval(&("{||" + oWFTemplate:cbCCO + "}"), "")
		If ValType(cEvalRes)=="C"
			cBCC := cEvalRes
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza as substituicoes no texto a ser enviado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSubject := oWFTemplate:evalCode(oWFTemplate:subject)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Substitui os <Enter> por código Html³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLen := At(Chr(13)+Chr(10), cSubject)
	Do While nLen > 0
		cSubject := SubStr(cSubject, 0, nLen-1) + " " + SubStr(cSubject, nLen+2, Len(cSubject))
		nLen := At(Chr(13)+Chr(10), cSubject)
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza as substituicoes no texto a ser enviado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBody := oWFTemplate:evalCode(oWFTemplate:bodyText)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Substitui os <Enter> por código Html³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLen := At(Chr(13)+Chr(10), cBody)
	Do While nLen > 0
		cBody := SubStr(cBody, 0, nLen-1) + "<BR>" + SubStr(cBody, nLen+2, Len(cBody))
		nLen := At(Chr(13)+Chr(10), cBody)
	End

	conout("[CTSDK10] ANTES PREPARE THREAD"+Alltrim(Str(ThreadId()))+" Hora "+Time())
	For nCount := 1 To Len( aWFs )
		If aWFs[nCount]:wfType==WFTYPE_AUTHORIZATION
			aWFs[nCount]:prepare(cCodUser, 	aWFs[nCount]:cProcessedTo, cSubject, cBody, cHtmlFile, cCC, cBCC, .T.)
		//prepare(cCodUser, 	aWFs[nCount]:cProcessedTo, cSubject, cBody, cHtmlFile, cCC, cBCC, .T.)
		Else
			aWFs[nCount]:prepare(cCodUser, aWFs[nCount]:cProcessedTo, cSubject, cBody, cHtmlFile, cCC, cBCC)
		//prepare(cCodUser, aWFs[nCount]:cProcessedTo, cSubject, cBody, cHtmlFile, cCC, cBCC)
		EndIf
	Next
	conout("[CTSDK10] DEPOIS PREPARE THREAD"+Alltrim(Str(ThreadId()))+" Hora "+Time())
	If oWFTemplate:lAttachFile .AND. !IsBlind()

		DEFINE MSDIALOG oDlgAttach TITLE "Anexar Arquivos ao Workflow" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

		@ 000, 000 MSPANEL oPanelAll SIZE 250, 150 OF oDlgAttach COLORS 0, 16777215 RAISED
		@ 000, 000 MSPANEL oPanelTop SIZE 249, 015 OF oPanelAll COLORS 0, 16777215 RAISED
		@ 002, 002 SAY oSayTop PROMPT "Selecione os arquivos a serem enviados com o workflow" SIZE 196, 010 OF oPanelTop COLORS 0, 16777215 PIXEL
		@ 015, 199 MSPANEL oPanelRight SIZE 050, 119 OF oPanelAll COLORS 0, 16777215 RAISED
		@ 002, 002 BUTTON oButtonAdd PROMPT "&Adicionar" SIZE 046, 011 OF oPanelRight ;
			ACTION TK520JAdicArq(@oListBoxFile, @oSayTam,oWFTemplate) ;
			MESSAGE "Adiciona arquivo ao WorkFlow" PIXEL
		@ 015, 002 BUTTON oButtonRem PROMPT "&Remover" SIZE 046, 011 OF oPanelRight  ;
			ACTION TK520JRemArq(@oListBoxFile, @oSayTam,oWFTemplate) ;
			MESSAGE "Remove arquivo do WorkFlow" PIXEL
		@ 028, 002 BUTTON oButtonBco PROMPT "&Banco" SIZE 046, 011 OF oPanelRight ;
			ACTION CSAddBco( @oListBoxFile, @oSayTam, oWFTemplate, cCodADE ) ;
			MESSAGE "Adiciona arquivos do banco de conhecimento ao WorkFlow" PIXEL
		@ 015, 000 MSPANEL oPanelList SIZE 199, 119 OF oPanelAll COLORS 0, 16777215 RAISED
		@ 000, 000 LISTBOX oListBoxFile FIELDS HEADER "Arquivo","Tamanho" SIZE 198,133 OF oPanelList
		@ 134, 000 MSPANEL oPanel1 SIZE 249, 015 OF oPanelAll COLORS 0, 16777215 RAISED
		@ 004, 001 SAY oSayTam PROMPT "Tamanho Total:" SIZE 106, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
		@ 002, 203 BUTTON oButtonConf PROMPT "&Confirmar" SIZE 046, 011 OF oPanel1 ;
			ACTION IIF(oWFTemplate:TK520JSendFiles(aWFs,oWFTemplate),oDlgAttach:End(),) ;
			MESSAGE "Confirma o envio dos arquivos anexos" PIXEL

		oListBoxFile:SetArray( oWFTemplate:aFilesUp )

		If Len( oWFTemplate:aFilesUp ) = 0
			oListBoxFile:bLine:={|| { "", "", ""} }
		Else
			oListBoxFile:bLine:={||{ oWFTemplate:aFilesUp[oListBoxFile:nAt,1], oWFTemplate:aFilesUp[oListBoxFile:nAt,2], oWFTemplate:aFilesUp[oListBoxFile:nAt,3] }}
		EndIf

		// Don't change the Align Order
		oPanelAll:Align    := CONTROL_ALIGN_ALLCLIENT
		oPanelTop:Align    := CONTROL_ALIGN_TOP
		oPanel1:Align      := CONTROL_ALIGN_BOTTOM
		oPanelRight:Align  := CONTROL_ALIGN_RIGHT
		oPanelList:Align   := CONTROL_ALIGN_ALLCLIENT
		oListBoxFile:Align := CONTROL_ALIGN_ALLCLIENT

		ACTIVATE MSDIALOG oDlgAttach CENTERED
	EndIf
Return aWFs

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³saveKnowledgeBaseºAutor  ³Vendas CRM   º Data ³  03/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copia o anexo para o diretorio do banco de conhecimento e   º±±
±±º          ³faz as amarracoes do mesmo.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MP10                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function saveKnowledgeBase(cAnexo, cFileName,oWFTemplate)
	Local aArea		:= GetArea()
	Local nPos 		:= RAt(If(IsSrvUnix(), "/", "\"), cFileName)
	Local nPos2		:= 0
	Local cDirDoc		:= MsDocPath()
	Local cAnexoGrv	:= Upper(SubStr( cFileName , nPos+1 ))
	Local nCount		:= 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca por um nome de arquivo nao utilizado, incrementando o arquivo        ³
	//³com um sequencial ao final do nome, exemplo: arquivo(1).txt, arquivo(2).txt³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("ACB")
	DbSetOrder(2) //ACB_FILIAL+ACB_OBJETO

	While DbSeek(xFilial("ACB") + AllTrim(SubStr( cAnexoGrv , nPos+1 )))
		nPos2		:= Rat(".",cAnexoGrv)
		cAnexoGrv	:= SubStr(cAnexoGrv,1,nPos2-1)+"("+cValToChar(nCount)+")"+SubStr(cAnexoGrv,nPos2,Len(cAnexoGrv))
		nCount++
	End

	__CopyFile(cAnexo, cDirDoc + "\" + cAnexoGrv )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inclui registro no banco de conhecimento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("ACB",.T.)
	ACB->ACB_FILIAL := xFilial("ACB")
	ACB->ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
	ACB->ACB_OBJETO	:= Upper(cAnexoGrv)
	ACB->ACB_DESCRI	:= oWFTemplate:KBName
	MsUnLock()

	ConfirmSx8()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inclui amarração entre registro do banco e entidade³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("AC9",.T.)
	AC9->AC9_FILIAL	:= xFilial("AC9")
	AC9->AC9_FILENT	:= xFilial(oWFTemplate:KnowledgeBase)
	AC9->AC9_ENTIDA	:= oWFTemplate:KnowledgeBase
	AC9->AC9_CODENT	:= oWFTemplate:KBName
	AC9->AC9_CODOBJ	:= ACB->ACB_CODOBJ
	MsUnLock()

	RestArea(aArea)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º prepare                ºAutor  ³ Vendas Clientes º Data ³  10/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Preparar o envio do Workflow e a criacao dos objetos utili- º±±
±±º          ³zados no envio do Workflow	                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function prepare(codProtheusUser, emailUser, subject, Body, HtmlFile, cCC, cBCC,lxRet,oWFInfo)
	Local cTableHeader 		:= ""
	Local cTableItens		:= ""
	Local nFields			:= 0
	Local nI				:= 0
	Local cMailId

	aWFs[nCount]:codProtheusUser	:= codProtheusUser
	aWFs[nCount]:emailUser		:= emailUser
	aWFs[nCount]:subject			:= subject
	aWFs[nCount]:Body			:= IIf(!Empty(Body),Body,"")
	aWFs[nCount]:HtmlFile		:= IIf(!Empty(HtmlFile), HtmlFile, "WFW520.htm")
	aWFs[nCount]:cCC				:= cCC
	aWFs[nCount]:cBCC			:= cBCC

	conout("[CTSDK10] ANTES CMAILID THREAD"+Alltrim(Str(ThreadId()))+" Hora "+Time())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Utiliza o componente padrao TWFProcess  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oProcess	:= TWFProcess():New(/*cCodProcess*/,/*cDescrProcess*/)
	Sleep(Randomize( 1 , 3 )*1000)

	cMailId := "S"+Alltrim( StrZero( Randomize( 1 , 100 ), 3 ) )+Alltrim( StrTran( StrZero( Seconds(), 9, 3 ), '.', '' ) )+DtoS( Date() )

	ChkFile( "WFA" )
	WFA->(DbSetOrder(4))
	While WFA->(MsSeek(xFilial("WFA")+"2"+cMailId))
		cMailId := "S"+Alltrim( StrZero( Randomize( 1 , 100 ), 3 ) )+Alltrim( StrTran( StrZero( Seconds(), 9, 3 ), '.', '' ) )+DtoS( Date() )
	EndDo
	conout("[CTSDK10] DEPOIS CMAILID THREAD"+Alltrim(Str(ThreadId()))+" Hora "+Time())

	conout("[CTSDK10] ANTES TWFPROCESS THREAD"+Alltrim(Str(ThreadId()))+" Hora "+Time())
	aWFs[nCount]:oProcess	:= TWFProcess():New('000001','WF Informativo',  cMailId  )
	aWFs[nCount]:oProcess:NewTask("Preparando WorkFlow Informativo", "\workflow\"+aWFs[nCount]:HtmlFile)
	conout("[CTSDK10] DEPOIS TWFPROCESS THREAD"+Alltrim(Str(ThreadId()))+" Hora "+Time())

	aWFs[nCount]:oProcess:cTo		:= aWFs[nCount]:emailUser
	aWFs[nCount]:oProcess:cSubject	:= aWFs[nCount]:subject
	aWFs[nCount]:oProcess:cBody		:= aWFs[nCount]:Body
	aWFs[nCount]:oProcess:cCC 		:= aWFs[nCount]:cCC
	aWFs[nCount]:oProcess:cBCC 		:= aWFs[nCount]:cBCC

	oHtml := aWFs[nCount]:oProcess:oHTML

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche a tabela do HTML com os dados do Header ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nFields := 1 To Len(aWFs[nCount]:Header:Fields)
		cName 	:= aWFs[nCount]:Header:Fields[nFields]:name
		cValue	:= aWFs[nCount]:Header:Fields[nFields]:value
		If ValType(cValue) == "D"
			cValue := DTOC(cValue)
		EndIf
		If ValType(cValue) == "C"
			cTableHeader+= '<tr>'+Chr(13)+Chr(10)
			cTableHeader+= '<td width="25%" class="TituloMenor"><b>'+HTMLEnc(cName)+'</b></td>'+Chr(13)+Chr(10)
			cTableHeader+= '<td width="75%" class="texto" colspan="3">'+HTMLEnc(cValue)+'</td>'+Chr(13)+Chr(10)
			cTableHeader+= '</tr>'+Chr(13)+Chr(10)
		EndIf
	Next nFields

	//Finalizacao do Header do HTML
	cTableHeader+= '<tr>'+Chr(13)+Chr(10)
	cTableHeader+= '<td colspan="4" class="TituloMenor" background="pontilhado.gif">'+Chr(13)+Chr(10)
	cTableHeader+= '<img src="transparente.gif" width="10" height="3"></td>'+Chr(13)+Chr(10)
	cTableHeader+= '</tr>'+Chr(13)+Chr(10)
	cTableHeader+= '<tr>'+Chr(13)+Chr(10)
	cTableHeader+= '<td class="TituloMenor">&nbsp;</td>'+Chr(13)+Chr(10)
	cTableHeader+= '<td class="texto">&nbsp;</td>'+Chr(13)+Chr(10)
	cTableHeader+= '<td class="TituloMenor">&nbsp;</td>'+Chr(13)+Chr(10)
	cTableHeader+= '<td class="texto">&nbsp;</td>'+Chr(13)+Chr(10)
	cTableHeader+= '</tr>'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho com os campos dos itens da tabela			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aWFs[nCount]:Itens) > 0
		cTableItens += '<tr class="TituloMenor">'+Chr(13)+Chr(10)
		For nFields := 1 To Len( aWFs[nCount]:Itens[1]:fields )
			cName := aWFs[nCount]:Itens[1]:fields[nFields]:name
			cTableItens += '<td height="14" class="TituloMenor"><div align="center">'+HTMLEnc(cName)+'</div></td>'+Chr(13)+Chr(10)
		Next nFields
		cTableItens += '</tr>'+Chr(13)+Chr(10)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche a tabela do HTML com os dados dos Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 To Len(aWFs[nCount]:Itens)
		cTableItens += '<tr class="texto">'+Chr(13)+Chr(10)

		For nFields := 1 to Len( aWFs[nCount]:Itens[nI]:fields )
			cValue	:= aWFs[nCount]:Itens[nI]:fields[nFields]:value
			If ValType(cValue) == "D"
				cValue := DTOC(cValue)
			EndIf
			If ValType(cValue) == "C"
				cTableItens += '<td height="14" class="texto"><div align="center">'+HTMLEnc(cValue)+'</div></td>'+Chr(13)+Chr(10)
			EndIf
		Next nFields

		cTableItens += '</tr>'+Chr(13)+Chr(10)
	Next nI

	cTableItens += '<tr>'+Chr(13)+Chr(10)
	cTableItens += '<td colspan="8" class="texto" background="pontilhado.gif" height="1">&nbsp;</td>'+Chr(13)+Chr(10)
	cTableItens += '</tr>'+Chr(13)+Chr(10)

	If oHtml:ExistField(1, "CABEC")
		oHtml:ValByName("CABEC",  aWFs[nCount]:Body	)
	EndIf
	If oHtml:ExistField(1, "HEADER")
		oHtml:ValByName("HEADER", cTableHeader)
	EndIf
	If oHtml:ExistField(1, "ITENS")
		oHtml:ValByName("ITENS",  cTableItens)
	EndIf

	aWFs[nCount]:internalID	:= aWFs[nCount]:oProcess:fProcessID + aWFs[nCount]:oProcess:fTaskID
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º start                  ºAutor  ³ Vendas Clientes º Data ³  10/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia o Workflow ao destinatario. Executado apos a prepara- º±±
±±º          ³cao do envio do Workflow	                            	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function start(oWFInfo,cPasta)
	Local aArea      := GetArea()
	Local cMailID		:= ""
	Local cLastAlias 	:= alias()
	
	//Inicio - Tratamento para altera a conta de envio de workflow informativo -  warleson(Opvs)30/10/2012
	dbSelectArea('WF7')
	WF7->(dbsetorder(1))
	WF7->(dbgotop())
	IF !empty(cPasta)
		WF7->(DbSeek(xFilial('WF7')+Upper(cPasta)))
	Else
		WF7->(DbSeek(xFilial('WF7')+'DEFAULT'))
	Endif
	
	CONOUT( "[CTSDK10]  WFStartProcess, protocolo: " + ADE->ADE_CODIGO + ", WF7_PASTA == " + WF7->WF7_PASTA + " Hora " + Time() )
	oWFInfo:OPROCESS:OWF:CMAILBOX:= WF7->WF7_PASTA  //***

	//Final - Tratamento para altera a conta de envio de workflow informativo -  warleson(Opvs)30/10/2012
	cMailID := WFStartProcess(oWFInfo:oProcess)

	IF !Empty( cLastAlias )
		dbSelectArea( cLastAlias )
	EndIF

	If File("\workflow\copia\"+cMailID)
		Conout("Arquivo HTML copiado com sucesso")
	EndIf
	
	RestArea(aArea)
Return

//*--<  Start - Inicia a execução da tarefa >----------------------------------*
static function WFStartPRocess(oProcess)
	local cID
	local cLastAlias := alias()
	cID := Exec(oProcess)

	if !Empty( cLastAlias )
		dbSelectArea( cLastAlias )
	end
return cID

//*--<  Finish - Registra o fim do processo >-----------------------------------*

//*--<  Exec - Executa a tarefa >----------------------------------------------*

static Function  Exec(oProcess,lDebug,cHTMLCopyTo)

	Local nC, nPos
	Local oMail := TWFMail():New()
	Local cMailBox := oProcess:oWF:cMailBox
	Local oMailBox := oMail:GetMailBox( cMailBox )
	Local cMailID, cHTMLFile, cValFile, cBuffer, cCIDFile
	Local aHeaders, aHttpAddress, aRecNoTimeout := {}

	default lDebug := .f.

	cMailID := lower( oProcess:oWF:NewMailID( oProcess:FProcessID + oProcess:FTaskID ) )
	cHTMLFile := oProcess:oWF:cTempDir + cMailID + ".htm"
	cValFile  := oProcess:oWF:cProcessDir + cMailID + ".val"

	if !( oProcess:lTimeOut ) .and. len( oProcess:bTimeout ) > 0
		aRecNoTimeOut := oProcess:AddTimeOuts( cMailID )
	end

	oProcess:LogEvent( EV_RUNTASK )

	aHeaders := {}
	AAdd( aHeaders, { "X-" + 'WFPROCID', oProcess:FProcessID } )
	AAdd( aHeaders, { "X-" + 'WFTASKID', oProcess:FTaskID } )
	AAdd( aHeaders, { "X-" + 'WFMailID', cMailID } )
	AAdd( aHeaders, { "X-" + 'SigaWF', "2.0" } )
	AAdd( aHeaders, { "X-" + 'WFEncodeMime', AllTrim( Str( oProcess:nEncodeMime ) ) } )
	AAdd( aHeaders, { "X-Priority", oProcess:cPriority } )

	do case
	case oProcess:cPriority == "0"
		AAdd( aHeaders, { "X-MSMail-Priority", "High" } )
	case oProcess:cPriority == "1"
		AAdd( aHeaders, { "X-MSMail-Priority", "Normal" } )
	case oProcess:cPriority == "2"
		AAdd( aHeaders, { "X-MSMail-Priority", "Low" } )
	end

	if oProcess:oHTML <> NIL
		oProcess:oHTML:cVersion := oProcess:cVersion
		oProcess:oHTML:ValByName( 'WFMailID', "WF" + cMailID )
		oProcess:oHTML:ValByName( 'WFRecnoTimeout', asString( aRecNoTimeout, .t. ) )
		oProcess:oHTML:ValByName( 'WFEMPRESA', cEmpAnt )
		oProcess:oHTML:ValByName( 'WFFILIAL', cFilAnt )

		if Len( oProcess:oHTML:aAttCID ) > 0 .and. oProcess:oWF:lAttachImg
			for nC := 1 to Len( oProcess:oHTML:aAttCID )
				if !Empty( cCIDFile := StrTran( oProcess:oHTML:aAttCID[nC,1], "/", "\" ) )
					if File( cCIDFile )
						oProcess:AttachFile( { cCIDFile, "Context-ID: " + oProcess:oHTML:aAttCID[nC,2] } )
					end
				end
			next
		end

		oProcess:oHTML:SaveFile( cHTMLFile )

		if file( cHTMLFile )

			if oProcess:oWF:lHtmlBody
				oProcess:cBody := ""
			else
				oProcess:AttachFile( cHTMLFile )
			end

			if ( cHTMLCopyTo <> nil )
				cHTMLCopyTo := AllTrim( cHTMLCopyTo )
				WFForceDir( cHTMLCopyTo )
				if !( Right( cHTMLCopyTo, 1 ) == "\" )
					cHTMLCopyTo += "\"
				end
				WFSaveFile( Lower( cHTMLCopyTo + cMailID + ".htm" ), WFLoadFile( cHTMLFile ) )
			end

		end

	end

	oProcess:cTo := WFGetAddress( oProcess:cTo := AllTrim( oProcess:cTo ) )
	oProcess:cCC := WFGetAddress( oProcess:cCC := AllTrim( oProcess:cCC ) )
	oProcess:cBCC := WFGetAddress( oProcess:cBCC := AllTrim( oProcess:cBCC ) )

	ChkFile( "WF6" )
	dbSelectArea( "WF6" )

	if ( Len( aHttpAddress := oProcess:ExtHttpAddr() ) > 0 ) .and. ( Select( "SX6" ) > 0 )

		if File( cHTMLFile )
			cBuffer := WFLoadFile( cHTMLFile )

			if ( nPos := At( "MAILTO:", Upper( cBuffer ) ) ) > 0
				cMailToAddress := SubStr( cBuffer, nPos, 7 )

				while Empty( SubStr( cBuffer, nPos +7, 1 ) )
					cMailToAddress += " "
					nPos++
				end

				cBuffer := SubStr( cBuffer, nPos +7 )

				if ( nPos := At( " ", cBuffer ) ) > 0
					cMailToAddress += AllTrim( Left( cBuffer, nPos -1 ) )
					if Right( cMailToAddress,1 ) == '"'
						cMailToAddress := Left( cMailToAddress, Len( cMailToAddress ) -1 )
					end
				end

				if !Empty( cMailToAddress )
					cBuffer := WFLoadFile( cHTMLFile )

					if ( nPos := At( cMailToAddress, cBuffer ) ) > 0

						if WFGetMV( "MV_WFWEBEX", .f. )
							cBuffer := Stuff( cBuffer, nPos, Len( cMailToAddress ), "WFHTTPRET.APW" )
						else
							cBuffer := Stuff( cBuffer, nPos, Len( cMailToAddress ), "WFHTTPRET.APL" )
						end

						for nC := 1 to len( aHttpAddress )
							WFForceDir( oProcess:oWF:cMessengerDir + aHttpAddress[ nC ] )
							WFSaveFile( oProcess:oWF:cMessengerDir + aHttpAddress[ nC ] + "\" + cMailID + ".htm", cBuffer )

							If RecLock( "WF6", .T. )
								WF6_FILIAL := xFilial( "WF6" )
								WF6_DE     := oMailBox:cRemetent
								WF6_PROPRI := Upper( AllTrim( aHttpAddress[ nC ] ) )
								WF6_PARA   := AllTrim( aHttpAddress[ nC ] )
								WF6_GRUPO  := "00001"
								WF6_STATUS := "1"
								WF6_IDENT1 := cMailID
								WF6_DATA   := MsDate()
								WF6_HORA   := Left( Time(),5 )
								WF6_DESCR  := oProcess:cSubject
								WF6_ACAO   := '{|oTsk| WFTaskWF( oTsk, 2, "messenger/emp' + cEmpAnt + "/" + aHttpAddress[ nC ] + "/" + cMailID + '.htm",' +IIF( Empty( oProcess:bReturn ),".F.",".T.") + ')}'
								WF6_PRIORI := oProcess:cPriority
								WF6_DTVENC := oProcess:dNextTOut
								WF6_HRVENC := oProcess:tNextTOut
								MSUnlock("WF6")
							end

						next

					end

				end

			end

			cBuffer := ""
		end

		if !Empty( oProcess:cBody )

			for nC := 1 to len( aHttpAddress )
				cFileName := oProcess:oWF:cMessengerDir + aHttpAddress[ nC ] + "\" + cMailID + ".apm"
				WFSaveFile( cFileName, oProcess:cBody )

				if RecLock( "WF6", .T. )
					WF6_FILIAL := xFilial( "WF6" )
					WF6_DE     := oMailBox:cRemetent
					WF6_PROPRI := Upper( AllTrim( aHttpAddress[ nC ] ) )
					WF6_PARA   := AllTrim( aHttpAddress[ nC ] )
					WF6_GRUPO  := "00002"
					WF6_STATUS := "1"
					WF6_IDENT1 := cMailID
//					WF6_IDENT2 := cIdent2
					WF6_DATA   := MsDate()
					WF6_HORA   := Left( Time(),5 )
					WF6_DESCR  := oProcess:cSubject
					WF6_ACAO   := '{|oTsk| WFTaskMsg( oTsk, 2, "' + StrTran( cFileName, "\", "/" ) + '" ) }'
					WF6_PRIORI := oProcess:cPriority
//					WF6_DTVENC := oProcess:dNextTOut
//					WF6_HRVENC := oProcess:tNextTOut
					MSUnlock("WF6")
				end

			next

		end

	end

	if !Empty( oProcess:cTo + oProcess:cCC + oProcess:cBCC )

		if ( oProcess:cFromName <> nil ) .or. ( oProcess:cFromAddr <> nil )
			oMailBox:cRemetent := if( oProcess:cFromName <> nil, oProcess:cFromName, oMailBox:cRemetent )
			oMailBox:cAddress := if( oProcess:cFromAddr <> nil, oProcess:cFromAddr, oMailBox:cAddress )
		end

		oMailBox:NewMessage( oProcess:cTo, oProcess:cCC, oProcess:cBCC, oProcess:cSubject, ;
			iif ( oProcess:oWF:lHtmlBody, WFLoadFile( cHTMLFile ), oProcess:cBody ), oProcess:aAttFiles, aHeaders,, oProcess:nEncodeMime, cMailID )

		if oProcess:oWF:lHtmlBody
			fErase( cHTMLFile )
		end

		if oProcess:oWF:lSendAuto
			U_WFSendMail( { cEmpAnt, cFilAnt })
		end

	end

	ChkFile( "WFA" )
	DbSelectArea( "WFA" )

	If RecLock("WFA", .T. )
		WFA_FILIAL	:= xFilial( "WFA" )

		if Len( aHttpAddress ) > 0
			WFA_TIPO := "8" // WF_OUTHTTP
		else
			WFA_TIPO := "2"  // WF_OUTBOX
		end

		WFA_IDENT	:= cMailID
//		WFA_ARQEML	:= cEMLFile
		WFA_DATA		:= MSDate()
		WFA_HORA		:= Time()
		WFA_USRSIG	:= oProcess:UserSiga
		MSUnlock("WFA")
	end

//	WFSaveFile( cValFile, AsString( oProcess:SaveObj(),.t. ) )
	oProcess:SaveValFile( cValFile )

	if !( oProcess:lTimeOut ) .and. empty( oProcess:bReturn )
		oProcess:LogEvent( 99, 'Processo finalizado ' )
	end

return cMailID


/******************************************************************************
	WFSendMail
	Rotina especifica para envio de mensagens do workflow
	Parametros:
		aParams: { <cEmpresa>, <cFilial> }
******************************************************************************/
User Function WFSendMail( aParams )
	if aParams <> nil
		U_WFJobSndMail(aParams)
	end
return


/******************************************************************************
	WFJobSndMail
	Complemento da funcao WFSendMail para execucao via job
	Parametros:
		aParams: { <cEmpresa>, <cFilial> }
******************************************************************************/
User Function WFJobSndMail( aParams )
	local oMail := TWFMail():New( aParams )
	local cMailBox := WF7->WF7_PASTA //AllTrim( WFGetMV( "MV_WFMLBOX", "" ) ) //***
	local oMailBox := oMail:GetMailBox( cMailBox )

	ChkFile( "WFA" )
	WFA->( dbSetOrder( 4 ) )
	oMailBox:bAfterSend := "WFAfterSend"
	Send(cMailBox,.F.,oMailBox)
return

static function Send( cMailBox, lForce ,oMailBox)
	local lResult := .f.

	if cMailBox	<> nil
		if valtype( cMailBox ) == "C"
			lResult := SendMail(cMailBox, lForce,oMailBox)
		else
			lResult := SendMail( cMailBox, lForce,oMailBox )
		end
	else
		return lResult
	end

return lResult

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK10   ºAutor  ³Microsiga/Opvs      º Data ³  11/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função auxliar: Envio de workflow informativo             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ServiceDesk - Certisign                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


static Function SendMail( oMailBox, lForce,oMailBox )
	local lResult := .f., lError := .t.
	local hFile
	local cLCKFile, cEMLFile, cMsg, cBody, cWFMFile
	local nC1, nC2, nC3, nPos1, nPos2
	local aFiles, aMessage, aDest, aTo
	local	oLogFile, oOutboxFolder, oSentFolder, oErrorFolder, oError, oSelf := oMailBox
	local bBefore, bAfter, bError, bLastError

	default lForce := .f.

	if oMailBox == nil
		return lResult
	end

	if ( oMailBox:lExists )
		if !( oMailBox:lActive ) .and. !( lForce )
			return lResult
		end
		if oMailBox:bAfterSend <> nil
			bAfter := AllTrim( oMailBox:bAfterSend )
			if at( "(", bAfter ) > 0
				bAfter := left( bAfter, at( "(", bAfter ) -1 )
			end
			if FindFunction( bAfter )
				bAfter := &( "{ |o,a| " + bAfter + "(o,a) }" )
			else
				bAfter := nil
			end
		end
		if oMailBox:bBeforeSend <> nil
			bBefore := AllTrim( oMailBox:bBeforeSend )
			if at( "(", bBefore ) > 0
				bBefore := left( bBefore, at( "(", bBefore ) -1 )
			end
			if FindFunction( bBefore )
				bBefore := &( "{ |o,a| " + bBefore + "(o,a) }" )
			else
				bBefore := nil
			end
		end
		if oMailBox:bErrorSend <> nil
			bError := AllTrim( oMailBox:bErrorSend )
			if at( "(", bError ) > 0
				bError := left( bError, at( "(", bError ) -1 )
			end
			if FindFunction( bError )
				bError := &( "{ |o,a| " + bError + "(o,a) }" )
			else
				bError := nil
			end
		end
		cLCKFile := oMailBox:cRootPath + "\send.lck"
		if File( cLCKFile )
			if FErase( cLCKFile ) == -1
				Return lResult
			end
		end
		if ( hFile := WFCreate( cLCKFile, FC_NORMAL ) ) == -1
			return lResult
		end
		WFClose( hFile )
		if ( hFile := WFOpen( cLCKFile, FO_READWRITE + FO_EXCLUSIVE ) ) == -1
			return lResult
		end
		oSentFolder := oMailBox:GetFolder( "\sent" )
		oOutboxFolder := oMailBox:GetFolder( '\outbox' )
		oErrorFolder := oMailBox:GetFolder( '\outbox' + '\error')
		oErrorFolder:MoveFiles( "*.wfm", oOutboxFolder )
		oError := WFStream()
		oLogFile := WFFileSpec( oMailBox:cRootPath + "\" + oMailBox:cRecipient + ".log" )
		oLogFile:WriteLN( Replicate("*", 80 ) )
		cMsg := FormatStr("VERIFICANDO CAIXA DE SAIDA... [%c]", oMailBox:cRecipient )
		WFConOut( cMsg, oLogFile )
		oMailBox:OMAIL:oSmtpSrv:cName := AllTrim( oMailBox:cSmtpServer )
		oMailBox:OMAIL:oSmtpSrv:nPort := oMailBox:nSmtpPort

		while (lError)
			lError := .f.

			if len( aFiles := oOutboxFolder:GetFiles("*.wfm") ) == 0
				cMsg := "Nada consta."
				WFConOut( cMsg, oLogFile, .f. )
			else

				if oMailBox:OMAIL:InitServer( oMailBox, oLogFile )
					cMsg := "Ha %c nova(s) mensagen(s) a enviar"
					cMsg := FormatStr( cMsg, StrZero( len( aFiles ),4 ) )
					WFConOut( cMsg, oLogFile, .f. )

					if oMailBox:OMAIL:oSmtpSrv:Connect( oLogFile )
						bLastError := ErrorBlock( { |e| oSelf:Error( e, oLogFile ) } )
						for nC1 := 1 to Len( aFiles )
							cMsg := "[#%c|%c]%c"
							cMsg := FormatStr( cMsg, { StrZero( nC1,4 ), left( Time(),5), upper( oOutboxFolder:cRootPath + "\" + aFiles[ nC1,1 ] ) } )
							WFConOut( cMsg, oLogFile, .f., .f. )
							if oOutboxFolder:FileExists(aFiles[ nC1,1 ])
								aTo := {}
								cBody := nil
	//							aMessage := &( oOutboxFolder:LoadFile( aFiles[ nC1,1 ] ) )
								aMessage := oOutboxFolder:LoadFile( aFiles[ nC1,1 ] )
								varinfo("aMessage na function SendMessage -- ", aMessage)
								if ( nPos1 := at( "<wfbodytag>", aMessage ) ) > 0 .and. ( nPos2 := at( "</wfbodytag>", aMessage ) ) > 0
									cBody := substr( aMessage, nPos1 + 11, nPos2 - ( nPos1 + 11 ) )
									aMessage := stuff( aMessage, nPos1, ( nPos2 + 12 ) - nPos1, "" )
								else
									aMessage := strtran( aMessage, "'+chr(10)+'", "" )
									aMessage := strtran( aMessage, "'+chr(13)+'", "" )
									aMessage := strtran( aMessage, "'+chr(34)+'", '"' )
								end
								aMessage := &(aMessage)
								if len( aDest := WFTokenChar( aMessage[ 2 ], ";" ) ) > 0
									AEval( aDest, { |x| AAdd( aTo, x ) } )
								end
								aMessage[ 2 ] := ""
								if len( aDest := WFTokenChar( aMessage[ 3 ], ";" ) ) > 0
									AEval( aDest, { |x| AAdd( aTo, x ) } )
								end
								aMessage[ 3 ] := ""
								if len( aDest := WFTokenChar( aMessage[ 4 ], ";" ) ) > 0
									AEval( aDest, { |x| AAdd( aTo, x ) } )
								end
								aMessage[ 4 ] := ""
								if len( aTo ) > 0
									for nC2 := 1 to len( aTo )
										oMailBox:OMAIL:oSmtpSrv:oMsg := TMailMessage():New()
										oMailBox:OMAIL:oSmtpSrv:oMsg:cFrom := aMessage[ 1 ]
										oMailBox:OMAIL:oSmtpSrv:oMsg:cTo := aTo[ nC2 ]
										oMailBox:OMAIL:oSmtpSrv:oMsg:cCC := ""
										oMailBox:OMAIL:oSmtpSrv:oMsg:cBCC := ""
										oMailBox:OMAIL:oSmtpSrv:oMsg:cSubject := aMessage[ 5 ]
										if lower( aMessage[ 9 ] ) == "text"
											oMailBox:OMAIL:oSmtpSrv:oMsg:MsgBodyType( lower( aMessage[ 9 ] ) )
										end
										oMailBox:OMAIL:oSmtpSrv:oMsg:MsgBodyEncode( aMessage[ 10 ] )
										if cBody == nil
											oMailBox:OMAIL:oSmtpSrv:oMsg:cBody := aMessage[ 6 ]
										else

											cChave:= '<GRUPO>'+ALLTRIM(M->ADE_GRUPO)+  '</GRUPO><ATENDIMENTO>'+ALLTRIM(M->ADE_CODIGO)+ '</ATENDIMENTO><DATETIME>'+DToS(date())+'-'+Time()+'</DATETIME>'
											cChave := '<br><div id="'+cChave+'" style="visibility:hidden; position:relative">&nbsp;</div><br>'

											//cBody:= StrTran (cBody,'<body>',cChave)
											cBody:=cBody+cChave
											oMailBox:OMAIL:oSmtpSrv:oMsg:cBody := cBody

											oMailBox:OMAIL:oSmtpSrv:oMsg:cBody := cBody
										end
										if len( aMessage[ 7 ] ) > 0
											for nC3 := 1 to len( aMessage[ 7 ] )
												if ValType( aMessage[ 7 ][ nC3 ] ) == "A"
													if file( aMessage[ 7 ][ nC3 ][ 1 ] )
														oMailBox:OMAIL:oSmtpSrv:oMsg:AttachFile( aMessage[ 7 ][ nC3 ][ 1 ] )
														oMailBox:OMAIL:oSmtpSrv:oMsg:AddAttHTag( aMessage[ 7 ][ nC3 ][ 2 ] )
													end
												else
													if file( aMessage[ 7 ][ nC3 ] )
														oMailBox:OMAIL:oSmtpSrv:oMsg:AttachFile( aMessage[ 7 ][ nC3 ] )
													end
												end
											next
										end
										if len( aMessage[ 8 ] ) > 0
											for nC3 := 1 to len( aMessage[ 8 ] )
												oMailBox:OMAIL:oSmtpSrv:oMsg:AddCustomHeader( aMessage[ 8 ][ nC3 ][ 1 ], aMessage[ 8 ][ nC3 ][ 2 ] )
											next
										end
										BEGIN SEQUENCE
											if bBefore <> nil
												eval( bBefore, oMailBox:OMAIL:oSmtpSrv:oMsg, aMessage )
											end

											if 	oMailBox:OMAIL:oSmtpSrv:Send( oLogFile,oMailBox)

												if bAfter <> nil
													eval( bAfter, oMailBox:OMAIL:oSmtpSrv:oMsg, aMessage )
												end
											else
												lError := .t.
												cMsg := "Mensagem NAO enviada para o destinatario: " + aTo[ nC2 ]
												WFConOut( cMsg, oLogFile, .f. )
												while oErrorFolder:FileExists( cWFMFile := ChgFileExt( lower( CriaTrab(,.f.) ), ".wfm" ) )
												end
												aMessage[ 2 ] := aTo[ nC2 ]
												if !( cBody == nil )
													aMessage[ 6 ] := "<wfbodytag>" + cBody + "</wfbodytag>"
												end
												oErrorFolder:SaveFile( AsString( aMessage,.t. ), cWFMFile )
												if bError <> nil
													eval( bError, oMailBox:OMAIL:oSmtpSrv:oMsg, aMessage )
												end
											end
										END SEQUENCE
									next
									oOutboxFolder:MoveFiles( aFiles[ nC1,1 ], oSentFolder )
								else
									oOutboxFolder:MoveFiles( aFiles[ nC1,1 ], oErrorFolder )
									cMsg := "Nao foi especificado o(s) endereco(s) do(s) destinatario(s) para o envio."
									WFConOut( cMsg, oLogFile, .f. )
									cMsg := "Mensagem disponivel em: "
									cMsg += oErrorFolder:cRootPath + "\" + aFiles[ nC1,1 ]
									WFConOut( cMsg, oLogFile, .f. )
								end
							end
							if (lError)
								exit
							end
						next
						ErrorBlock( bLastError )
						oMailBox:OMAIL:oSmtpSrv:Disconnect( oLogFile )
					end
				end

				if ( oMailBox:nConnType == 2) .and. ( oMailBox:OMAIL:ODIALUP <> nil ) //WFC_DIALUP
					oMailBox:OMAIL:ODIALUP:Disconnect( oLogFile )
				end

				oMailBox:OMAIL:oServer := nil
			end

		end

		oLogFile:Close()
		FClose( hFile )
	end

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK10   ºAutor  ³Microsiga/Opvs      º Data ³  11/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função auxliar: Envio de workflow informativo             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ServiceDesk - Certisign                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function ValidaConta(cPasta)
	Local cGrupo   := ''
	Local cQuery   := ''
	Local aArea    := GetARea()
	Local lValid   := .F.
	Local _aContas := {}
	Local _aReg    := {'',0}

	If Val( SKY->KY_TPWF ) == 1 // WF informativo
		cGrupo := AllTrim( ADE->ADE_GRUPO )

		// Caso o grupo do atendimento esteja vazio, busca o grupo do operador
		If Empty( cGrupo )
			DbSelectArea("SU7")
			DbSetOrder(4)

			If DbSeek(xFilial("SU7")+__cUserId)
				cGrupo := ALLTRIM(SU7->U7_POSTO) // Grupo de atendimento
			Else
				MsgStop('Atenção, grupo de atendimento não informado no cadastro do operador. O e-Mail não será enviado.','CTSDK10 |002')
			EndIf
		EndIf

		If .NOT. Empty( cGrupo )
			cQuery := "Select ZR_ATIVO,ZR_GRPSDK,ZR_CTAMAIL,ZR_PASTA,R_E_C_N_O_ "+CRLF
			cQuery += "FROM "+RetSqlName("SZR")+" "+CRLF
			cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
			cQuery += "AND ZR_FILIAL = '"+XFILIAL('SZR')+"'"+CRLF
			cQuery += "AND ZR_ATIVO = 'S'"+CRLF
			If !empty(ALLTRIM(ADE->ADE_CONTA))
				cQuery += "AND ZR_CTAMAIL IN('"+ALLTRIM(ADE->ADE_CONTA)+"')"
			Else
				cQuery += "AND ZR_GRPSDK IN('"+cGrupo+"')"
			Endif

			cQuery := ChangeQuery(cQuery)

			IF Select("TRB") > 0
				DbSelectArea("TRB")
				DbCloseArea()
			ENDIF

			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )

			DbSelectArea("TRB")
			TRB->(dbgotop())

			If TRB->(eof()) //Caso a Conta para resposta estaja desabilitada- Então tente enviar com a conta do grupo
				cQuery := "Select ZR_ATIVO,ZR_GRPSDK,ZR_CTAMAIL,ZR_PASTA,R_E_C_N_O_ "+CRLF
				cQuery += "FROM "+RetSqlName("SZR")+" "+CRLF
				cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
				cQuery += "AND ZR_FILIAL = '"+XFILIAL('SZR')+"'"+CRLF
				cQuery += "AND ZR_ATIVO = 'S'"+CRLF
				cQuery += "AND ZR_GRPSDK IN('"+cGrupo+"')"

				cQuery := ChangeQuery(cQuery)

				IF Select("TRB") > 0
					DbSelectArea("TRB")
					DbCloseArea()
				ENDIF

				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T. )

				DbSelectArea("TRB")
				TRB->(dbgotop())
			Endif

			If !TRB->(eof())
				While !(TRB->(eof()))
					aAdd(_aContas,{alltrim(TRB->ZR_CTAMAIL),alltrim(TRB->ZR_PASTA),TRB->(recno())})
					TRB->(DbSkip())
				Enddo

				if len(_aContas)>1 .AND. !ISBLIND()
					_aReg := U_EscolhaConta(_aContas) // [1]Contas [2] Recno
				Else
					_aReg:= _aContas[1]
				Endif

				cPasta := _aReg[2] //TRB->ZR_PASTA
			Else
				cPasta := 'DEFAULT'
			Endif

			If !empty(cPasta)
				dbSelectArea('WF7')
				WF7->(dbsetorder(1))
				WF7->(dbgotop())
				If WF7->(DbSeek(xFilial('WF7')+Upper(cPasta)))
					lValid := .T.
				Else
					RestArea(aARea)
					lValid := .F.
					MsgStop('Atenção, grupo de atendimento: ' + rTrim(Upper(cPasta)) + ', não configurado na tabela WF7. Verifique.','CTSDK10 |003')
				Endif
			Endif
			("TRB" )->(dbCloseArea())
		Endif
	Else
		MsgStop('Atenção, não será enviado e-mail devido ao cadastro do tipo de WorkFlow - KY_TPWF == 1','CTSDK10 |004')
	Endif

Return lValid

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK520JAdicArq ºAutor  ³Vendas CRM      º Data ³  12/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que abre a janela para que sejam selecionados os     º±±
±±º          ³arquivos a serem adicionados ao worflow                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function TK520JAdicArq( oList, oSayTam,oWFTemplate)
	Local lMV_TMKSEAN	:= SuperGetMV("MV_TMKSEAN", .F., 1)
	Local nVisibilidade	:= Nil
	Local cAnexo		:= ""
	Local cDrive		:=""
	Local cFile			:=""
	Local cDir			:=""
	Local cExten		:=""
	Local nArrPos		:= 0
	Local nAttSize		:= 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Controle de segurança de visualização dos diretórios do servidor e remote.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMV_TMKSEAN == 1
		nVisibilidade := Nil													// Exibe todos os diretórios do servidor e do cliente
	ElseIf lMV_TMKSEAN == 2
		nVisibilidade := GETF_ONLYSERVER										// Somente exibe o diretório do servidor
	ElseIf lMV_TMKSEAN == 3
		nVisibilidade := GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE	// Somente exibe o diretório do cliente
	EndIf

	cAnexo := cGetFile(	"Todos os Arquivos (*.*)     | *.* | ",;
		"Selecione um arquivo", 0,;
		,.T.,nVisibilidade, If(nVisibilidade==56, .F., .T.) )

	SplitPath( cAnexo, @cDrive, @cDir, @cFile, @cExten )
	cFileName := cFile+cExten
	If ExistBlock( "TK520JCH" )
		cFileName := ExecBlock( "TK520JCH", .F., .F.,{cFile+cExten} )
	Endif

	If !Empty(cAnexo)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o diretório de destino existe, se não existe cria.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !File( "\workflow\emp" + AllTrim(cEmpAnt) + "\temp" )
			MakeDir( "\workflow\emp" + AllTrim(cEmpAnt) + "\temp" )
		EndIf

		While File( MsDocPath() + "\" +cFileName) .OR. (aScan(oWFTemplate:acFileName,{|cAtFileName| cAtFileName == cFileName}) > 0)
			cFileName := oWFTemplate:changeFile(cFileName)
			If cFileName==""
				Return
			EndIf
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se é possível pegar a posição inicial do nome do arquivo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := RAt(If(IsSrvUnix(), "/", "\"), cAnexo)
		If nPos > 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Avalia se o tamanho do anexo (KB) nao excede o limite estipulado em MV_TKMAXKB³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aDirectory := Directory(cAnexo)

			If (ValType(aDirectory) == "A" .AND. Len(aDirectory) == 1 )
				nAttSize := Round(aDirectory[1][2] / 1024, 0)
				oWFTemplate:nTotalSize := oWFTemplate:nTotalSize + nAttSize
			EndIf

			AADD(oWFTemplate:aFilesUp,{cFileName,cValToChar(nAttSize)})
			AADD(oWFTemplate:acAnexo,cAnexo)
			AADD(oWFTemplate:acFileName,cFileName)

			oList:SetArray( oWFTemplate:aFilesUp )
			oList:bLine:={||{ oWFTemplate:aFilesUp[oList:nAt,1], oWFTemplate:aFilesUp[oList:nAt,2] }}
			oList:Refresh()

			If (oWFTemplate:nTotalSize > oWFTemplate:nMaxAttSize)
				Alert("O tamanho total a ser enviado ultrapassa os" + " " + cValToChar(oWFTemplate:nMaxAttSize) + " kb " + "permitidos" + "." + chr(10) + chr(13) +"Antes de confirmar, remova algum arquivo da lista de anexos ou selecione um arquivo menor.")
			EndIf
			oSayTam:SetText("Tamanho Total:" + " " + cValToChar(oWFTemplate:nTotalSize) + " kb")

		EndIf
	EndIf
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK520JRemArq  ºAutor  ³Vendas CRM      º Data ³  12/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que remove da lista de arquivos anexos o arquivo     º±±
±±º          ³selecionado                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function TK520JRemArq(oList, oSayTam,oWFTemplate)

	If Len(oWFTemplate:aFilesUp) > 0
		oWFTemplate:nTotalSize := oWFTemplate:nTotalSize - Val(oWFTemplate:aFilesUp[oList:nAt][2])
	Else
		oWFTemplate:nTotalSize := 0
	EndIf

	If Len(oWFTemplate:aFilesUp) > 0

		ADEL(oWFTemplate:acFileName,oList:nAt)
		ADEL(oWFTemplate:acAnexo,oList:nAt)
		ADEL(oWFTemplate:aFilesUp,oList:nAt)


		ASIZE(oWFTemplate:acFileName,Len(oWFTemplate:acFileName) - 1)
		ASIZE(oWFTemplate:acAnexo,Len(oWFTemplate:acAnexo) - 1)
		ASIZE(oWFTemplate:aFilesUp, Len(oWFTemplate:aFilesUp) -1)

		oList:SetArray(oWFTemplate:aFilesUp)
		oList:bLine:={||{ oWFTemplate:aFilesUp[oList:nAt,1], oWFTemplate:aFilesUp[oList:nAt,2] }}
		oList:Refresh()

	EndIf

	oSayTam:SetText("Tamanho Total:" + " " + cValToChar(oWFTemplate:nTotalSize) + " kb")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK520JSendFiles  ºAutor  ³Vendas CRM      º Data ³  12/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao envia os arquivos selecionados                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function TK520JSendFiles(aWFs,oWFTemplate)
	Local nCount := 0
	Local nCount2:= 0
	Local lRet	:= .T.
	If (oWFTemplate:nTotalSize <= oWFTemplate:nMaxAttSize)

		For nCount := 1 To Len(oWFTemplate:aFilesUp)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz a cópia do arquivo para o servidor.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			__CopyFile(oWFTemplate:acAnexo[nCount], "\workflow\emp" + AllTrim(cEmpAnt) + "\temp\" + oWFTemplate:acFileName[nCount] )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Anexa o arquivo ao workflow.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nCount2 := 1 To Len( aWFs )
				aWFs[nCount2]:attachFile("\workflow\emp" + AllTrim(cEmpAnt) + "\temp\" + oWFTemplate:acFileName[nCount], .T. )
			Next

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Salva no banco de conhecimento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oWFTemplate:lSaveFile
				saveKnowledgeBase(oWFTemplate:acAnexo[nCount], oWFTemplate:acFileName[nCount],oWFTemplate)
			EndIf
		Next
	Else
		Alert("O tamanho total a ser enviado ultrapassa os"  + " " + cValToChar(oWFTemplate:nMaxAttSize) + " kb " + "permitidos" + "." + chr(10) + chr(13) + "Antes de confirmar, remova algum arquivo da lista de anexos ou selecione um arquivo menor.")
		lRet := .F.
	EndIf
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK10   ºAutor  ³Microsiga/Opvs      º Data ³  11/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função auxliar: Envio de workflow informativo             º±±
±±º          ³  Valida endereço de e-mail                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ServiceDesk - Certisign                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function Valida_email()

	Local cCampo 	:= &(READvAR())
	local aEmail 	:= {}
	Local lValide 	:= .T.
	local nX

	If !empty(cCampo)
		If ValType(cCampo) == "C"
			aEmail := StrTokArr (cCampo,';')
			For nx:=1 to len(aEMail)
				lValide:= Testa_email(alltrim(aEmail[nX]))
				if !(lValide)
					Alert('Email inválido! '+CRLF+alltrim(aEmail[nX]))
					Exit
				Endif
			Next
		EndIf
	Endif

	// Realiza a validacao da conta de destinatario para evitar
	// a informacao da mesma conta do grupo de atendimento se a
	// acao de reabertura usar template de workflow
	If lValide .And. !Empty( cCampo )
		lValide := ValCtaGrupo( cCampo )
	EndIf

Return lValide

*___________________________________________________________________________________________________

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSDK10   ºAutor  ³Microsiga/Opvs      º Data ³  11/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função auxliar: Envio de workflow informativo             º±±
±±º          ³  Valida endereço d ee-mail                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ServiceDesk - Certisign                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function testa_email(cEmail)

	Local aCharEspecial	:={}
	Local nLen			:= len(cEmail)
	Local cParteLocal	:= ''
	Local cDominio    	:= ''
	Local cChave		:= ''
	Local cValidPonto	:= ''
	local nArroba		:= 0
	local nPonto		:= 0
	local lRet			:= .T.
	Local nX

	aCharEspecial		:= {'"',"'",'!','@','#',;
		'$','%','¨','&','*',;
		'(',')','+','=','´',;
		'`','{','[','}',']',;
		'^','~',':',';',',',;
		'<','>','/','\','?',;
		'|',' '}
	if nLen >= 5
		If !('..'$cEmail)
			nArroba:= RAT ('@',cEmail)
			If (nArroba > 1) .and. (nArroba < nLen)
				nPonto:= RAT ('.',cEmail)
				if (nPonto>(nArroba+1)) .and. (nPonto<nLen)
					cParteLocal	:= Substr(cEmail,1,(nArroba-1))
					cDominio	:= Substr(cEmail,(nArroba+1),nLen-nArroba)
					cValidPonto	:= substr(cParteLocal,1,1)+substr(cParteLocal,len(cParteLocal),1)+substr(cDominio,1,1)
					if !('.'$ cValidPonto)
						cChave := (cParteLocal+cDominio)
						For nX:=1 to len(aCharEspecial)
							if (aCharEspecial[nX]$cChave)
								lRet:= .F.
								Exit
							Endif
						Next
					ELse
						lRet:= .F.
					Endif
				Else
					lRet:= .F.
				Endif
			Else
				lRet:= .F.
			Endif
		Else
			lRet:= .F.
		Endif
	Else
		lRet:= .F.
	Endif

return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EscolhaConta ºAutor  ³Opvs(Warleson)   º Data ³  12/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Interface, auxlia a escolher uma conta de e-mail          º±±
±±º          ³  para envio de workflow informativo                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERTISIGN / CERTISIGN                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function EscolhaConta(_aContas)

	local aRet:= _aContas[1]

	DEFINE MSDIALOG _oDlg TITLE "Workflow Informativo" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

	@ 000, 000 MSPANEL _oPanelAll SIZE 250, 150 OF _oDlg COLORS 0, 16777215 RAISED
	@ 000, 000 MSPANEL _oPanelTop SIZE 249, 015 OF _oPanelAll COLORS 0, 16777215 RAISED
	@ 002, 002 SAY _oSayTop PROMPT "Selecione a conta para envio do e-mail" SIZE 196, 010 OF _oPanelTop COLORS 0, 16777215 PIXEL
	@ 015, 000 MSPANEL _oPanelList SIZE 199, 119 OF _oPanelAll COLORS 0, 16777215 RAISED
	@ 000, 000 LISTBOX _oListBox FIELDS HEADER "Conta" SIZE 198,133 OF _oPanelList
	@ 134, 000 MSPANEL _oPanel1 SIZE 249, 015 OF _oPanelAll COLORS 0, 16777215 RAISED
	@ 000, 195 BUTTON _oButtonConf PROMPT "CONFIRMAR" SIZE 050, 012 OF _oPanel1 ACTION {||aREt:=_aContas[_oListBox:NAT],_oDlg:End()} PIXEL

	_oListBox:SetArray(_aContas)

	_oListBox:bLine:={||{ _aContas[_oListBox:nAt,1], _aContas[_oListBox:nAt,2]}}

	// Don't change the Align Order
	_oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
	_oPanelTop:Align := CONTROL_ALIGN_TOP
	_oPanel1:Align := CONTROL_ALIGN_BOTTOM
	_oPanelList:Align := CONTROL_ALIGN_ALLCLIENT
	_oListBox:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG _oDlg CENTERED

Return aRet



/*
------------------------------------------------------------------------------
| Rotina     | CSAddBco   | Autor | Gustavo Prudente     | Data | 03.09.2014 |
|----------------------------------------------------------------------------|
| Descricao  | Adiciona arquivos do banco de conhecimento no workflow        |
|----------------------------------------------------------------------------|
| Parametros | EXPO1 - Objeto do listbox dos arquivos anexos ao workflow     |
|            | EXPO2 - Objeto say da mensagem de limite de tamanho de envio  |
|            | EXPO3 - Objeto do template de workflow                        |
|            | EXPC4 - Codigo do atendimento gravado na tabela ADE           |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function CSAddBco( oListFile, oSayTam, oWFTemplate, cCodADE )

	Local cFilADE := xFilial( "ADE" )
	Local cFilAC9 := xFilial( "AC9" )
	Local cFilACB := xFilial( "ACB" )
	Local cCodAC9 := PadR( cFilADE + cCodADE, TamSX3( "AC9_CODENT" )[ 1 ] )

	ACB->( DbSetOrder( 1 ) )

// Pesquisa registro de banco de conhecimento
	AC9->( DbSetOrder( 2 ) )
	AC9->( DbSeek( cFilAC9 + "ADE" + cFilADE + cCodAC9 ) )

	Do While AC9->( ! EoF() ) .And. ;
			AC9->AC9_FILIAL == cFilAC9 .And. AC9->AC9_ENTIDA == "ADE" .And. ;
			AC9->AC9_FILENT == cFilADE .And. AC9->AC9_CODENT == cCodAC9

	// Pesquisa arquivos anexos ao banco de conhecimento do atendimento
		If ACB->( DbSeek( cFilACB + AC9->AC9_CODOBJ ) )

			cFileName 	:= AllTrim( ACB->ACB_OBJETO )
			cAnexo		:= MsDocPath() + "\" + cFileName

		// Verifica se o diretorio de destino existe, se nao existe cria
			If !File( "\workflow\emp" + AllTrim( cEmpAnt ) + "\temp" )
				MakeDir( "\workflow\emp" + AllTrim( cEmpAnt ) + "\temp" )
			EndIf

		// Caso ja exista nos anexos, solicita alteracao do nome do arquivo
			Do While aScan( oWFTemplate:aCFileName, { |cAtFileName| cAtFileName == cFileName } ) > 0
				cFileName := oWFTemplate:ChangeFile( cFileName )
				If cFileName == ""
					Return .F.
				EndIf
			EndDo

		// Verifica se e possivel pegar a posição inicial do nome do arquivo
			nPos := Rat( If( IsSrvUnix(), "/", "\" ), cAnexo )

			If nPos > 0

			// Avalia se o tamanho do anexo (KB) nao excede o limite estipulado em MV_TKMAXKB
				aDirectory := Directory( cAnexo )

				If ValType( aDirectory ) == "A" .And. Len( aDirectory ) == 1
					nAttSize := Round( aDirectory[ 1, 2 ] / 1024, 0 )
					oWFTemplate:nTotalSize := oWFTemplate:nTotalSize + nAttSize
				EndIf

			// Atualiza vetores para envio dos anexos no workflow
				Aadd( oWFTemplate:aFilesUp, { cFileName, cValToChar( nAttSize ) } )
				Aadd( oWFTemplate:acAnexo, cAnexo )
				Aadd( oWFTemplate:acFileName, cFileName )

				oListFile:SetArray( oWFTemplate:aFilesUp )
				oListFile:bLine := { || { oWFTemplate:aFilesUp[ oListFile:nAt, 1 ], oWFTemplate:aFilesUp[ oListFile:nAt, 2 ] } }
				oListFile:Refresh()

			// Realiza validacao de tamanho de anexo
				If oWFTemplate:nTotalSize > oWFTemplate:nMaxAttSize
					Alert(	"O tamanho total a ser enviado ultrapassa os " + cValToChar( oWFTemplate:nMaxAttSize ) + " kb " + "permitidos" + "." + chr(10) + chr(13) + ;
						"Antes de confirmar, remova algum arquivo da lista de anexos ou selecione um arquivo menor." )
				EndIf

				oSayTam:SetText("Tamanho Total:" + " " + cValToChar( oWFTemplate:nTotalSize ) + " kb")

			EndIf

		EndIf

		AC9->( DbSkip() )

	EndDo

Return .T.



/*
----------------------------------------------------------------------------
| Rotina    | ValCtaGrupo  | Autor | Gustavo Prudente | Data | 24.03.2015  |
|--------------------------------------------------------------------------|
| Descricao | Realiza validacao da conta do destinatario do atendimento    |
|           | para evitar envio de e-mail para a conta do grupo do operador|
|--------------------------------------------------------------------------|
| Parametros| EXPC1 - Campo que informa o endereço de e-mail de destino    |
|--------------------------------------------------------------------------|
| Retorno   | EXPL1 - Retorna se deve permitir informar a conta de e-mail  |
|           | ou se deve impedir a informacao da conta.                    |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function ValCtaGrupo( cCampo )

	Local cCodUser	:= ""
	Local cGrupo	:= ""
	Local cAcao		:= ""
	Local cFilSZR	:= xFilial( "SZR" )
	Local cFilSU7	:= xFilial( "SU7" )
	Local cFilSUQ	:= xFilial( "SUQ" )

	Local aContas	:= {}
	Local aArea		:= GetArea()
	Local nx
	Local lRet		:= .T.

	cCodUser := AllTrim( TkOperador() )
	cCampo   := AllTrim( Upper( cCampo ) )

// Busca as contas do grupo de atendimento do operador
	SU7->( DbSetOrder( 1 ) )
	SU7->( DbSeek( cFilSU7 + cCodUser ) )

	cGrupo := SU7->U7_POSTO

	SZR->( DbSetOrder( 1 ) )
	SZR->( DbSeek( cFilSZR + cGrupo ) )

	Do While SZR->( ! EoF() ) .And. ;
			SZR->ZR_FILIAL == cFilSZR .And. ;
			SZR->ZR_GRPSDK == cGrupo

		AAdd( aContas, { SZR->ZR_CTAMAIL, SZR->ZR_ACASDK2 } )

		SZR->( DbSkip() )

	EndDo

	SUQ->( DbSetOrder( 1 ) )

// Percorre as contas de e-mail cadastradas para o grupo de atendimento
	For nX := 1 To Len( aContas )

		If AllTrim( Upper( aContas[ nX, 1 ] ) ) $ cCampo

		// Acao de reabertura dos atendimentos
			cAcao := aContas[ nX, 2 ]

		// Veririca se a acao de reabertura usa workflow
			If SUQ->( DbSeek( cFilSUQ + cAcao ) )

			// Caso utilize workflow, nao permite a informacao do e-mail do grupo
			// para evitar recusividade de reabertura
				If ! Empty( SUQ->UQ_WFTEMPL )
					Alert( "E-mail informado não pode ser o mesmo e-mail do grupo! " + CRLF + AllTrim( aContas[ nX, 1 ] ) )
					lRet := .F.
					Exit
				EndIf

			EndIf

		EndIf

	Next nX

	RestArea( aArea )

Return lRet