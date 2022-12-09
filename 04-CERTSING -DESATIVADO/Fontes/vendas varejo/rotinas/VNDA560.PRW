#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"                                      
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} VNDA560

Funcao criada para controle de etiquetas de rastreamento dos correios de acordo carga para terceiros posicionada  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

User Function VNDA560()
	Private aHeader := {}
	Private aCOLS := {}
	Private cCadastro := 'Etiquetas de Rastreamento'
	Private lA560Mrk := .F.
	
	If A560Vld()
		Processa( {|lEnd| Iif( A560Load(), A560Show(), NIL ) }, cCadastro, 'Processando, aguarde...', .F. )
	EndIf
	
Return

/*/{Protheus.doc} A560Vld

Funcao criada para validar o acesso a rotina de etiquetas de acordo carga de terceiros  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

Static Function A560Vld()
	Local lRet := .T.
	
	If DAK->DAK_FEZNF <> "1" .or. (!Empty(DAK->DAK_BLQCAR) .and. DAK->DAK_BLQCAR <> "2" )  
		MsgStop("Carga deve estar Faturada e desbloqueada para geração de Etiquetas")
		lRet := .F.
	EndIf

Return(lRet)

/*/{Protheus.doc} A560Load

Funcao criada para carregar os dados referente as etiquetas de rastreamento de acordo car  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/

Static Function A560Load()
	Local lRet	:= .T. 
	Local aCPO 	:= {}
	Local cAlias:= ""
	Local cSQL	:= ""
	Local Ni	:= 0
			
	AAdd( aCPO, { 'MARK'		,   '   x'              } )
	AAdd( aCPO, { 'STATUS'		,	'Status'           	} )
	AAdd( aCPO, { 'DAI_PEDIDO'	,	'Protheus'			} )
	AAdd( aCPO, { 'C5_XNPSITE'	,	'Site'				} )
	AAdd( aCPO, { 'PAG_CODRAS'	,	'Rastreamento'		} )
	AAdd( aCPO, { 'PAG_ENTREG'	,	'Posição Entrega'	} )
	AAdd( aCPO, { 'PAG_DESENT'	,	'Descrição'			} )
	AAdd( aCPO, { 'PAG_CODPLP'	,	'PLP'			} )
	
	cAlias := GetNextALias()
	
	cSQL += "SELECT DISTINCT " + CRLF
	cSQL += "       DAI.DAI_PEDIDO, " + CRLF
	cSQL += "       C5.C5_XNPSITE, " + CRLF
	cSQL += "       NVL(PAG.R_E_C_N_O_, 0)   PAGREC," + CRLF 
	cSQL += "       NVL(PAG.PAG_CODTRA, ' ') PAG_CODTRA, " + CRLF
	cSQL += "       NVL(PAG.PAG_CODRAS, ' ') PAG_CODRAS, " + CRLF
	cSQL += "       NVL(PAG.PAG_CODPED, ' ') PAG_CODPED, " + CRLF
	cSQL += "       NVL(PAG.PAG_STATUS, ' ') PAG_STATUS, " + CRLF
	cSQL += "       NVL(PAG.PAG_ENTREG, ' ') PAG_ENTREG, " + CRLF
	cSQL += "       NVL(PAG.PAG_CODPLP, ' ') PAG_CODPLP " + CRLF
	cSQL += "FROM " + RetSqlName('DAI') + " DAI " + CRLF 
	cSQL += "       LEFT OUTER JOIN " + RetSqlName('PAG') + " PAG " + CRLF 
	cSQL += "                    ON PAG.PAG_FILIAL = '" + xFilial('PAG') + "'" + CRLF 
	cSQL += "                       AND DAI.DAI_PEDIDO = PAG.PAG_CODPED " + CRLF
	cSQL += "                       AND PAG.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('SC5') + " C5 " + CRLF
	cSQL += "               ON C5.C5_FILIAL = '" + xFilial('SC5') + "'" + CRLF 
	cSQL += "                  AND DAI.DAI_PEDIDO = C5.C5_NUM " + CRLF
	cSQL += "                  AND C5.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  DAI.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND DAI.DAI_FILIAL = '" + xFilial('DAI') + "'" + CRLF 
	cSQL += "       AND DAI.DAI_COD = '" + DAK->DAK_COD + "'" + CRLF
	cSQL += "ORDER BY DAI_PEDIDO " + CRLF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAlias,.F.,.T.)
	
	If !(cAlias)->(EoF())
		SX3->( dbSetOrder( 2 ) )
		For nI := 1 To Len( aCPO )
			SX3->( dbSeek( aCPO[ nI, 1 ] ) )
			If aCPO[ nI, 1 ] $ 'STATUS|MARK'
				AAdd( aHeader, { aCPO[ nI, 2 ], aCPO[ nI, 1] , '@BMP', 10, 0, '', '', '', '', '' } ) 
			Else
				SX3->( AAdd( aHeader,{ aCPO[ nI, 2 ], RTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL,'AllWaysTrue', X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } ) )
			Endif
		Next nI
	
		While ! (cAlias)->( EOF() )
			PAG->(DbGoTo((cAlias)->PAGREC))
			
			AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			nElem := Len( aCOLS )
		   
			For nI := 1 To Len( aHeader )
				
				If aHeader[ nI, 2 ] == 'MARK'
					aCOLS[ nElem, nI ] := 'LBNO'
				ElseIf aHeader[ nI, 2 ] == 'STATUS'
					If Empty(PAG->PAG_STATUS)
						aCOLS[ nElem, nI ] := 'BR_BRANCO'	
					ElseIf PAG->PAG_STATUS == '1'
						aCOLS[ nElem, nI ] := 'BR_CINZA'
					ElseIf PAG->PAG_STATUS == '2' 
						aCOLS[ nElem, nI ] := 'BR_AZUL'
					ElseIf PAG->PAG_STATUS == '3' .AND. Empty(PAG->PAG_ENTREG)  
						aCOLS[ nElem, nI ] := 'BR_AMARELO'
					ElseIf PAG->PAG_STATUS == '3' .AND. Alltrim(PAG->PAG_ENTREG) = '00'  
						aCOLS[ nElem, nI ] := 'BR_MARROM'
					ElseIf PAG->PAG_STATUS == '3' .AND. Right(PAG->PAG_ENTREG,2) = '01'  
						aCOLS[ nElem, nI ] := 'BR_VERDE'
					ElseIf PAG->PAG_STATUS == '3' .AND. Right(PAG->PAG_ENTREG,2) <> '01'
						aCOLS[ nElem, nI ] := 'BR_VERMELHO'
					EndIf
				ElseIf aHeader[ nI, 2 ] == 'PAG_DESENT'
					aCOLS[ nElem, nI ] := Posicione("SX5",1,xFilial("SX5")+"PG"+PAG->PAG_ENTREG,"X5_DESCRI")	
				Else
					If ValType( (cAlias)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) ) ) == 'C'
						aCOLS[ nElem, nI ] := RTrim( (cAlias)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) ) )
					Else
						aCOLS[ nElem, nI ] := (cALias)->( FieldGet( FieldPos( aHeader[ nI, 2 ] ) ) )
					Endif
				Endif
			Next nI
			aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.
			
			IncProc()
			(cAlias)->( dbSkip() )
		EndDo
	Else
		AAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		nElem := Len( aCOLS )
		aCOLS[ nElem, Len( aHeader ) + 1 ] := .F.	
	EndIf
	
	(cAlias)->( dbCloseArea() )
Return(lRet)

/*/{Protheus.doc} A560Show

Funcao criada para mostrar pedidos de vendas por carga e amarração de etiquetas de rastreamento dos correios  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560Show()
	
	Local nCol := 0
	Local nRow := 0
	Local nL := 2
	Local nI := 0
	Local __nExec := 0
	
	Local cOK := 'AllWaysTrue'
	
	Local aButton := {}
	
	Local oFont := TFont():New('Courier new',,-16,,.T.)
		
	Private oGride
	Private oDlg
	Private oPanel
	Private oPanel2
	
	// [1] - Título do botão.
	// [2] - Chamada da funcionalidade.
	// [3] - Nº da tecla de atalho.
	AAdd( aButton, { '&Pesquisar F4'        , '{|| GdSeek(oGride,,aHeader,aCOLS,.F.) }' , 115 } )
	AAdd( aButton, { '&Legenda F5'          , '{|| A560Legenda( Len( oGride:aCOLS ) ) }' , 116 } )
	AAdd( aButton, { '&Marcar todos F6'     , '{|| A560MrkAll() }' , 117 } )
	AAdd( aButton, { '&Desmarcar todos F7'  , '{|| A560DesMrk() }' , 118 } )
	AAdd( aButton, { '&Inverter seleção F8' , '{|| A560Invert() }' , 119 } )
	AAdd( aButton, { '&Emitir Etiqueta F9'  , '{|| A560Etiq() }' , 120 } )
	AAdd( aButton, { '&Emitir Danfe F10'  	, '{|| A560Danf() }' , 121 } )
	AAdd( aButton, { '&Gerar PLP F11'  			, '{|| A560PLP() }'  , 122 } )
	AAdd( aButton, { '&Sair F12'            , '{|| Iif( MsgYesNo("Deseja realmente sair da rotina?", cCadastro ), oDlg:End(), NIL ) }' , 123 } )
	
	oMainWnd:ReadClientCoors()
	nCol := oMainWnd:nClientWidth
	nRow := oMainWnd:nClientHeight
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 00,00 TO nRow-34,nCol-8 PIXEL
		oDlg:lMaximized := .T.
		
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,26,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_TOP
		
		For nI := 1 To Len( aButton )			
			SetKey( aButton[ nI, 3 ], &(aButton[nI,2]) )
			TButton():New(3,nL,aButton[nI,1],oPanel,&(aButton[nI,2]),56,9,,,.F.,.T.,.F.,,.F.,,,.F.)
			nL += 60
		Next nI
		
		oPanel2 := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,26,.F.,.T.)
		oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
		
		oGride := MsNewGetDados():New( 012, 002, 120, 265, 0, cOK, cOK, '', {}, 0, Len(aCOLS), '', '', '', oPanel2, aHeader, aCOLS )
		oGride:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGride:oBrowse:bLDblClick := {||  A560MrkOne(), oGride:Refresh() }
		oGride:oBrowse:bHeaderClick := {|| __nExec++,Iif((__nExec%2)<>0,(Iif(lA560Mrk,A560DesMrk(),A560MrkAll()),oGride:Refresh()),NIL)}
	ACTIVATE MSDIALOG oDlg
	
	AEval( aButton, {|p| SetKey( p[ 3 ], NIL ) } )
Return

/*/{Protheus.doc} A560MrkOne

Funcao criada para marcar e desmarcar coluna individualmente registros da tela para processamento  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560MrkOne()
	Local nI := 0
	Local cMark := ''
	
	If oGride:aCOLS[ oGride:nAt, 1 ] == 'LBOK'
		oGride:aCOLS[ oGride:nAt, 1 ] := 'LBNO'
	Else
		oGride:aCOLS[ oGride:nAt, 1 ] := 'LBOK'
	Endif
Return

/*/{Protheus.doc} A560MrkAll

Funcao criada para marcar coluna de todos os registros da tela para processamento  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560MrkAll()
	Local nI := 0
	lA560Mrk:=!lA560Mrk
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, 2 ] <> "BR_CINZA" .and. oGride:aCOLS[ nI, 2 ] <> "BR_VERMELHO"
			oGride:aCOLS[ nI, 1 ] := 'LBOK'
		EndIf
	Next nI
Return
/*/{Protheus.doc} A560DesMrk

Funcao criada para desmarcar coluna de todos os registros da tela para processamento  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560DesMrk()
	Local nI := 0
	lA560Mrk:=!lA560Mrk
	For nI := 1 To Len( oGride:aCOLS )
		oGride:aCOLS[ nI, 1 ] := 'LBNO'
	Next nI
Return

/*/{Protheus.doc} A560Invert

Funcao criada para inverter a marcação de todos os registros da tela para processamento  

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560Invert()
	Local nI := 0
	For nI := 1 To Len( oGride:aCOLS )
		If oGride:aCOLS[ nI, 2 ] <> "BR_CINZA" .and. oGride:aCOLS[ nI, 2 ] <> "BR_VERMELHO"
			If oGride:aCOLS[ nI, 1 ] == 'LBOK'
				oGride:aCOLS[ nI, 1 ] := 'LBNO'
			Else
				oGride:aCOLS[ nI, 1 ] := 'LBOK'
			Endif
		EndIf
	Next nI	
Return
/*/{Protheus.doc} A560Legenda

Funcao criada para tela com legenda dos registros   

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560Legenda( nRegistros )
	Local aCor := {}
	
	AAdd( aCor, { 'LBNO'        , 'Registro não selecionado' } )
	AAdd( aCor, { 'LBOK'        , 'Registro selecionado' } )
	AAdd( aCor, { ' '       	, '' } )
	AAdd( aCor, { 'BR_BRANCO' 	, 'Pedido sem Cod. de Rastreamento' } )
	AAdd( aCor, { 'BR_CINZA' 	, 'Cód. Rastreamento incluído' } )
	AAdd( aCor, { 'BR_AZUL'     , 'Pedido com Cód. de Rastreamento' } )
	AAdd( aCor, { 'BR_AMARELO'  , 'Pedido com Etiqueta gerada' } )
	AAdd( aCor, { 'BR_MARROM'   , 'Pedido enviado a Transportadora' } )
	AAdd( aCor, { 'BR_VERDE'  	, 'Entrega confirmada pela transportadora' } )
	AAdd( aCor, { 'BR_VERMELHO' , 'Ocorrência na entrega' } )
	AAdd( aCor, { ' '       	, '' } )
	AAdd( aCor, { ''            , LTrim(Str(nRegistros))+' registro(s) localizado(s).' } )
	
	BrwLegenda( cCadastro, 'Legenda dos registros', aCor )	
Return

/*/{Protheus.doc} A560Etiq

Funcao criada chamada da função de criação emissão de etiquetas   

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560Etiq()
	
	FWMsgRun(oPanel, {|oSay| A560Print(oSay) } )
	
Return
/*/{Protheus.doc} A560Print

Funcao criada para imprimir etiqueta em impressora térmica   

@author Totvs SM - David
@since 10/03/2014
@version P11

/*/
Static Function A560Print(oSay)
	Local nI 		:= 0
	Local cUpd		:= ""
	Local nPed		:= ascan(aHeader,{|x| x[2] == "DAI_PEDIDO" })
	Local nSite		:= ascan(aHeader,{|x| x[2] == "C5_XNPSITE" })
	Local nDesc		:= ascan(aHeader,{|x| x[2] == "PAG_DESENT" })
	Local nRast		:= ascan(aHeader,{|x| x[2] == "PAG_CODRAS" })
	Local nPLP		:= ascan(aHeader,{|x| x[2] == "PAG_CODPLP" })
	Local lerr		:= .F.
	Local aImp		:= GetImpWindows(.F.)
	Local aPar		:= {}
	Local bOK 		:= {|| .T. }
	Local aRet		:= {}
	Local cImpEtq	:= "" 
	
	Aadd(aPar,{3,"Impressoras disponíveis"	,1,aImp,100,'.T.',.T.})
		
	If !ParamBox( aPar, 'Selecione uma Impressora', @aRet, bOk,,,,,,,.T.,.T.)
		Return
	Endif
	
	AVISO("Impressão etiqueta", 'Antes de imprimir a etiqueta, é necessário executar a rotina "Gerar PLP"', { 'Ok' }, 1)
	
	cImpEtq	:= aImp[IIF(Valtype(aRet[1])<>"N", Ascan(aImp,aRet[1]), aRet[1])]
	
	For nI:=1 to Len(oGride:aCOLS) 

		SC5->(DbSetOrder(1))
		If oGride:aCOLS[nI,1] == "LBOK" .AND. .NOT. Empty(oGride:aCOLS[nI,nPLP]) .AND. SC5->(DbSeek(xFilial("SC5") + oGride:aCOLS[nI,nPed]))
			
			If Empty(oGride:aCOLS[nI,nRast])
				cUpd := " UPDATE "+RetSqlName("PAG")+" SET PAG_STATUS = '3', PAG_CODPED = '"+oGride:aCOLS[nI,nPed]+"' WHERE PAG_CODTRA = '"+SC5->C5_TRANSP+"' AND PAG_CODPED = ' ' AND ROWNUM = 1 "
				If TcSqlExec(cUpd) < 0
					oGride:aCOLS[nI,nDesc] := TCSQLError()
					lerr	:= .T.
				EndIF
			EndIF
					
			cRast := U_VNDA570(oGride:aCOLS[nI,nPed],cImpEtq)
			If Empty(cRast)
				oGride:aCOLS[nI,nDesc] := "Inconsistencia na impressão de etiqueta"
				lerr	:= .T.
			Else
				oGride:aCOLS[nI,2] 		:= "BR_AZUL"
				oGride:aCOLS[nI,nRast] 	:= cRast
				oGride:aCOLS[nI,nDesc] := "Impressão com sucesso"
				Reclock("SC5",.F.)
					xObs:=SC5->C5_XOBS
					SC5->C5_XOBS	:= "*** Rastreamento "+cRast+" atribuido por "+Alltrim(cUserName)+" em "+DtoC(Date())+"-"+Time()+" ***"+chr(13)+chr(10)+xObs
					SC5->C5_XCODRAS := AllTrim(cRast)
					SC5->C5_XRASTRE := Iif(Empty(SC5->C5_XRASTRE),"",SC5->C5_XRASTRE)
				SC5->(MsUnlock())
				
				//Realiza integração com Checkout de forma síncrona - 27.07.2020
				If !Empty(SC5->C5_XCODRAS) .And. Empty(SC5->C5_XRASTRE) .And. !Empty(SC5->C5_XNPSITE)
					MsAguarde({|| A560Rastre() }, "Integração Checkout","Enviando Código do Rastreio para Checkout", .F.)
				EndIf
								
			EndIf			
		EndIF
	Next Ni
	
	If lerr 
		MsgStop("Foram encontradas inconsistências no processamento. Verifique a descrição das mesmas")
	EndIf
	
Return

/*/{Protheus.doc} A560Danf

Funcao criada para emitir danfe de etiquetas selecionadas   

@author Totvs SM - David
@since 25/03/2014
@version P11

/*/
Static Function A560Danf()
	
	FWMsgRun(oPanel, {|oSay| A560PrDf(oSay) } )
	
Return
/*/{Protheus.doc} A560PrDf

Funcao criada para imprimir danfe   

@author Totvs SM - David
@since 25/03/2014
@version P11

/*/
Static Function A560PrDf(oSay)
	Local cIdEnt		:= RetIdEnti()
	Local aIndArq		:= {}
	Local oDanfe
	Local nHRes			:= 0
	Local nVRes			:= 0
	Local nDevice
	Local cFilePrint	:= "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
	Local oSetup
	Local aDevice		:= {}
	Local cSession		:= GetPrinterSession()
	Local nRet 			:= 0
	Local nI 			:= 0
	Local cUpd			:= ""
	Local nPed			:= ascan(aHeader,{|x| x[2] == "DAI_PEDIDO" })
	Local nSite			:= ascan(aHeader,{|x| x[2] == "C5_XNPSITE" })
	Local nDesc			:= ascan(aHeader,{|x| x[2] == "PAG_DESENT" })
	Local nRast			:= ascan(aHeader,{|x| x[2] == "PAG_CODRAS" })
	Local lerr			:= .F.
	
	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6
	
	nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
	nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
	nPrintType      := aScan(aDevice,{|x| x == cDevice })
	
	dbSelectArea("SF2")
	RetIndex("SF2")
	dbClearFilter() 
	
	lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
	
	nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	
	oSetup := FWPrintSetup():New(nFlags, "DANFE")
	
	oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
	oSetup:SetPropert(PD_ORIENTATION , nOrientation)
	oSetup:SetPropert(PD_DESTINATION , nLocal)
	oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
	oSetup:SetPropert(PD_PAPERSIZE   , 2)
	
	If oSetup:Activate() == PD_OK // PD_OK =1
	
		fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
		fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
		fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
		
	    DAI->(DbSetOrder(4))
	    
	    For nI:=1 to Len(oGride:aCOLS)
	    	
			SC5->(DbSetOrder(1))
			SF2->(DbSetOrder(1))
		
			If 	oGride:aCOLS[nI,1] == "LBOK" .AND.;
				SC5->(DbSeek(xFilial("SC5") + oGride:aCOLS[nI,nPed])) .AND.;
				DAI->(DbSeek(xFilial("DAI") + SC5->C5_NUM)) .AND.;
				SF2->(DbSeek(xFilial("SF2") + DAI->DAI_NFISCA + DAI->DAI_SERIE)) 
			
				oDanfe := FWMSPrinter():New(SC5->C5_NUM+"_"+cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)
			    
			    // Configura o objeto de impressão com o que foi configurado na interface.
			    oDanfe:setCopies( val( oSetup:cQtdCopia ) )
	    		
				If oSetup:GetProperty(PD_ORIENTATION) == 1
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Danfe Retrato DANFEII.PRW                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
					u_PrtNfeSef(cIdEnt,,,oDanfe, oSetup, cFilePrint)		
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Danfe Paisagem DANFEIII.PRW                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					u_DANFE_P1(cIdEnt,,,oDanfe, oSetup)
				EndIf
				
				oDanfe := Nil	
			EndIf
			
		Next
		oSetup := Nil
				
	EndIf
Return

//+-------------------------------------------------------------------+
//| Rotina | A560PLP | Autor | Rafael Beghini | Data | 12.03.2018 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para gravar o Status PAG_STATUS = '3' para o JOB
//|        | VNDA580 efetuar a transmissão com os Correios.
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A560PLP()
	FWMsgRun(oPanel, {|oSay| A560GerPLP(oSay) } )	
Return
//+-------------------------------------------------------------------+
//| Rotina | A560GerPLP | Autor | Rafael Beghini | Data | 12.03.2018 
//+-------------------------------------------------------------------+
//| Descr. | Executa
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A560GerPLP(oSay)
	Local cUpd	:= ""
	Local lerr	:= .F.
	Local nI	:= 0
	Local nPed	:= ascan(aHeader,{|x| x[2] == "DAI_PEDIDO" })
	Local nRast	:= ascan(aHeader,{|x| x[2] == "PAG_CODRAS" })
	Local nDesc	:= ascan(aHeader,{|x| x[2] == "PAG_DESENT" })
	
	For nI := 1 to Len(oGride:aCOLS) 
		SC5->(DbSetOrder(1))
		If oGride:aCOLS[nI,1] == "LBOK" .AND. SC5->(DbSeek(xFilial("SC5") + oGride:aCOLS[nI,nPed]))
			
			If Empty(oGride:aCOLS[nI,nRast])
				cUpd := " UPDATE "+RetSqlName("PAG")+" SET PAG_STATUS = '3', PAG_CODPED = '"+oGride:aCOLS[nI,nPed]+"' WHERE PAG_CODTRA = '"+SC5->C5_TRANSP+"' AND PAG_CODPED = ' ' AND ROWNUM = 1 "
				If TcSqlExec(cUpd) < 0
					oGride:aCOLS[nI,nDesc] := TCSQLError()
					lerr	:= .T.
				EndIf
			EndIf
		EndIf
	Next nI
	
	If lerr 
		MsgStop("Foram encontradas inconsistências no processamento. Verifique a descrição das mesmas")
	EndIf
Return
//+-------------------------------------------------------------------+
//| Rotina | A560Rastre | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Integra o código de rastreio ao Checkout em sincronismo  
//|        | com a impressão da etiqueta
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A560Rastre()

	Local cJson 		:= ""
	Local cSvcError 	:= ""
	Local cSoapFCode	:= ""
	Local cSoapFDescr	:= ""
	Local cMSG			:= ""
	Local lOk			:= .F.
	Local lErro			:= .T.
	Local aAreaPAG		:= PAG->(GetArea())
	Local oWsObj		:= Nil
	Local oWsRes		:= Nil
	Local cError		:= ""
	Local cWarning		:= ""
	
	//Instancia objeto para envio de mensagem para o Checkout 
	oWsObj := WSVVHubServiceService():New()
			
	//Monta mensagem Json para envio
	cJson := '{"pedido":'+ Alltrim( SC5->C5_XNPSITE ) + ',"rastreamento":"' + SC5->C5_XCODRAS + '"}'
	
	//Invoca método para envio de mensageria
	lOk := oWsObj:sendMessage( "NOTIFICA-ENTREGA-PEDIDO", cJson )

	//Trata retornos
	cSvcError   := GetWSCError()  //-- Resumo do erro
	cSoapFCode  := GetWSCError(2) //-- Soap Fault Code
	cSoapFDescr := GetWSCError(3) //-- Soap Fault Description

	//Em caso de erro, carrega informações do erro
	If !Empty( cSvcError ) .Or. !Empty( cSoapFCode )
		lOk 	:= .F.
		cMSG	:= cSvcError + ' ' + cSoapFCode + ' ' + cSoapFDescr
	EndIf
			
	//Se o processamento foi bem sucedido
	If lOk
	
		//Transforma o XML de retorno em Objeto
		oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
		
		//Verifica se a resposta contém o retorno de sucesso esperado
		If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
			If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
				
				RecLock("SC5",.F.)
					SC5->C5_XRASTRE := "S"
				SC5->(MsUnlock())
			
				U_GTPutOUT( SC5->C5_XNPSITE,;
							"Q",;
							SC5->C5_XNPSITE,;
							{ "VNDA560", { .T., "M00001", SC5->C5_XNPSITE, "NOTIFICA-ENTREGA-PEDIDO com código de rastreamento enviada ao Hub com sucesso" } },;
							SC5->C5_XNPSITE )
				lErro := .F.
			EndIf
		EndIf
				
	EndIf

	//Se o processamento foi terminado com erro na integração do WebService
	IF lErro					
		U_GTPutOUT( SC5->C5_XNPSITE,"Q",SC5->C5_XNPSITE,{ "VNDA560", { .F., "E00024", SC5->C5_XNPSITE, "Inconsistência: " + cMSG } },SC5->C5_XNPSITE )
	EndIF

	RestArea(aAreaPAG)

Return