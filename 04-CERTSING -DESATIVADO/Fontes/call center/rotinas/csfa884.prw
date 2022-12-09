//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | OTRS / JIRA               |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| 26/06/2020 | Bruno Nunes   | - Erro ao consultar por CPF, CNPJ, pedido site, pedido GAR quando o atributo     | 1.00   | SIS-555, SIS-530, SIS-376 |
//|            |               | "itemProduto"                                                                    |	       | SIS-70                    |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+

#Include "Protheus.ch"

//-----------------------------------------------------------------------
// Rotina | CSFA884 | Autor | Robson L. E. Gonçalves | Data | 30/07/2018
//-----------------------------------------------------------------------
// Descr. | Rotina para simular a consulta do RightNow fazendo a mesma 
//        | rota de acesso via WebService do Protheus.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-----------------------------------------------------------------------
User Function CSFA884()
	Local aC := FWGetDialogSize(oMainWnd)
	Local aOpcPesq := {}
	
	Local cRJson := ''
	Local cOpcPesq := ''
	Local cPesq := Space(100)
	Local cTempos := ''
	
	Local lRota := .F.
	Local lClock := .F.
	
	Local oBtnP
	Local oBtnL
	Local oBtnS

	Local oDlg
	Local oFont := TFont():New('Consolas',,16,,.F.,,,,,.F.,.F.)
	Local oRJson
	Local oRota
	Local oFWLayer
	Local oTempos
	Local oOpcPesq
	Local oTPanelPar, oTPanelRet
	Local oWinPar, oWinRet
	
	aOpcPesq := {'CPF do Titular',;//.............[1]
	             'CPF do Faturamento',;//.........[2]
	             'CNPJ do Titular',;//............[3]
	             'CNPJ do Faturamento',;//........[4]
	             'Pedido Site',;//................[5]
	             'Pedido GAR',;//.................[6]
	             'CPF do Agente de Registro',;//..[7]
	             'Autenticar',;//.................[8]
	             'Pedido eCommerce'}//............[9]
	
	DEFINE MSDIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
		oFWLayer := FWLayer():New()	
		oFWLayer:Init( oDlg, .F. )
		
		oFWLayer:AddCollumn( "Col01", 100, .T. )
		
		oFWLayer:AddWindow( "Col01", "Win01", "Parâmetros: Protheus consulta Check-Out + GAR findPedidosByCPFCNPJ + GAR Find Dados Pedido + GAR Consulta Certificados + GAR Trilha de Auditoria ou Protheus consulta GAR Cadastro Agente de Registro.", 19, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		oFWLayer:AddWindow( "Col01", "Win02", "Tempo/Resultado da pesquisa." , 81, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		
		oWinPar  := oFWLayer:GetWinPanel('Col01','Win01')
		oWinRet  := oFWLayer:GetWinPanel('Col01','Win02')
		
		oTPanelPar := TPanel():New(0,0,"",oWinPar,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
		oTPanelPar:Align := CONTROL_ALIGN_ALLCLIENT
		
		oTPanelRet := TPanel():New(0,0,"",oWinRet,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
		oTPanelRet:Align := CONTROL_ALIGN_ALLCLIENT
		
		@ 1,003 SAY 'Opção de pesquisa:' SIZE 100,7 PIXEL OF oTPanelPar
		@ 9,003 COMBOBOX oOpcPesq VAR cOpcPesq ITEMS aOpcPesq SIZE 100,15 PIXEL OF oTPanelPar
		
		@ 1,110 SAY 'Informação a ser pesquisada (somente números):' SIZE 150,7 PIXEL OF oTPanelPar
		@ 9,110 MSGET cPesq PICTURE "@!" SIZE 200,12 PIXEL OF oTPanelPar
		
		@ 24,110 CHECKBOX oRota  VAR lRota  PROMPT 'Selecionar rota específica?' SIZE 150,8 PIXEL OF oTPanelPar
		//@ 24,204 CHECKBOX oClock VAR lClock PROMPT 'Análise dos tempos de processamento.' SIZE 150,8 PIXEL OF oTPanelPar
		
		oTempos := TMultiGet():New(1,1,{|u| Iif( PCount()==0,cTempos,cTempos:=u)},oTPanelRet,140,70,oFont,/*lHScroll*/,/*nClrFore*/,/*nClrBack*/,/*oCursor*/,.T.,/*cMg*/,.T.,{||.F. },/*lCenter*/,/*lRight*/,.F.,{|| .T. },/*bChange*/,.T.,.F.)
		oTempos:Align := CONTROL_ALIGN_TOP
		
		oRJson := TMultiGet():New(1,1,{|u| Iif( PCount()==0,cRJson,cRJson:=u)},oTPanelRet,140,33,oFont,/*lHScroll*/,/*nClrFore*/,/*nClrBack*/,/*oCursor*/,.T.,/*cMg*/,.T.,{||.F. },/*lCenter*/,/*lRight*/,.F.,{|| .T. },/*bChange*/,.T.,.F.)
		oRJson:Align := CONTROL_ALIGN_ALLCLIENT

		@ 9,318 	BUTTON oBtnP ;
					PROMPT "&Pesquisar..." ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION  Iif(Validar(cPesq,oOpcPesq),Pesquisar(oOpcPesq,aOpcPesq,cPesq,@cTempos,@cRJson,lRota,lClock),NIL)
					
		@ 9,378 	BUTTON oBtnL ;
					PROMPT "&Limpar" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION  Iif(MsgYesNo("Deseja realmente limpar o resultado?","TOTVS | Certisign"),(cPesq:=Space(100),cTempos:='',cRJson:=''),NIL)
		
		@ 9,438 	BUTTON oBtnS ;
					PROMPT "&Sair" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION  Iif(MsgYesNo("Deseja realmente sair da rotina?","TOTVS | Certisign"),oDlg:End(),NIL)
	ACTIVATE DIALOG oDlg CENTERED
Return

//-----------------------------------------------------------------------
// Rotina | Validar | Autor | Robson L. E. Gonçalves | Data | 30/07/2018
//-----------------------------------------------------------------------
// Descr. | Rotina para validar o dado digitado.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-----------------------------------------------------------------------
Static Function Validar( cPesq, oOpcPesq )
	Local cNum := AllTrim( cPesq )
	Local i := 0
	Local lRet := .T. 
	
	If oOpcPesq:nAt <> 8 // Qualquer opção diferente de autenticar precisa validar.
		If Empty( cPesq )
			MsgAlert('Por favor, informe o dado a pesquisar.', 'TOTVS')
			lRet := .F.
		Else
			IF oOpcPesq:nAt <> 9 //--Pedido Ecommerce possui numeros, sendo assim não critica
				For i := 1 To Len( cNum )
					If .NOT. (SubStr( cNum, i, 1 ) $ '0123456789')
						MsgAlert('Por favor, informe somente números.', 'TOTVS')
						lRet := .F.
						Exit
					Endif
				Next i
			EndIF
		Endif
	Endif
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | Pesquisar | Autor | Robson L. E. Gonçalves | Data | 30/07/18
//-----------------------------------------------------------------------
// Descr. | Rotina para efetuar a pesquisa.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-----------------------------------------------------------------------
Static Function Pesquisar( oOpcPesq, aOpcPesq, cPesq, cTempos, cRJson, lRota, lClock )
	FWMsgRun(,{|| doResearch( oOpcPesq, aOpcPesq, cPesq, @cTempos, @cRJson, lRota, lClock ) },,'Efetuando a pesquisa...')
Return
Static Function doResearch( oOpcPesq, aOpcPesq, cPesq, cTempos, cRJson, lRota, lClock )
	Local aHead := {}
	Local aPar := {}
	Local aResult := {}
	Local aRet := {}
	
	Local cAPI_1 := '', cAPI_2 := '', cAPI_3 := ''
	
	Local cGetResult := ''
	Local cPar := ''
	Local cPass := ''
	Local cResult := ''
	Local cTmpIni := ''
	Local cToken := ''
	Local cURL := ''
	Local cUser := ''
	
	Local i := 0
	
	Local nOpc := 0
	Local nSecond := 0
	
	Local oObj
	
	Private cCadastro := 'Protheus WS-REST'
	
	o884Rest := NIL
	o884Resul1 := NIL
	
	If lClock
		MsgInfo("Foi selecionada a opção 'Análise dos tempos de processamento', este recuros não está implementado.",'Protheus x RightNow')
	Endif
	
	If lRota
		AAdd( aPar,{ 3, "Selecione qual rota quer utilizar", 1, { "Balance ( CRM )", "BackStage ( RN )", "Teste ( IP )", "Novas entregas ( IP )"}, 100, "", .F. } )
		If .NOT. ParamBox( aPar ,"Parâmetros",@aRet )
			MsgAlert('A rotina será abandonada.', 'TOTVS')
			Return
		Endif
		
		If aRet[1]==1
			cURL   := GetMv('MV_884_01',.F.,'https://gestao.certisign.com.br')
			cAPI_1 := GetMv('MV_884_02',.F.,'/crm/rnautenticar/')
			cAPI_2 := GetMv('MV_884_03',.F.,'/crm/rnprotheus/')
			cAPI_3 := GetMv('MV_884_04',.F.,'/crm/rnagente/')
		Elseif aRet[1]==2
			cURL   := GetMv('MV_884_01',.F.,'https://gestao.certisign.com.br')
			cAPI_1 := GetMv('MV_884_02',.F.,'/rn/rnautenticar/')
			cAPI_2 := GetMv('MV_884_03',.F.,'/rn/rnprotheus/')
			cAPI_3 := GetMv('MV_884_04',.F.,'/rn/rnagente/')
		Elseif aRet[1]==3
			cURL   := GetMv('MV_884_IP1',.F.,'192.168.16.129:8028')
			cAPI_1 := GetMv('MV_884_02',.F.,'/rn/rnautenticar/')
			cAPI_2 := GetMv('MV_884_03',.F.,'/rn/rnprotheus/')
			cAPI_3 := GetMv('MV_884_04',.F.,'/rn/rnagente/')
		Elseif aRet[1]==4
			cURL   := GetMv('MV_884_IP2',.F.,'192.168.16.129:8030')
			cAPI_1 := GetMv('MV_884_02',.F.,'/rn/rnautenticar/')
			cAPI_2 := GetMv('MV_884_03',.F.,'/rn/rnprotheus/')
			cAPI_3 := GetMv('MV_884_04',.F.,'/rn/rnagente/')
		Endif
	Else
		cURL   := GetMv('MV_884_01',.F.,'https://gestao.certisign.com.br')
		cAPI_1 := GetMv('MV_884_02',.F.,'/crm/rnautenticar/')
		cAPI_2 := GetMv('MV_884_03',.F.,'/crm/rnprotheus/')
		cAPI_3 := GetMv('MV_884_04',.F.,'/crm/rnagente/')	
	Endif
	
	cUser := enCode64( GetMv('MV_884_05',.F.,'Protheus.RightNow') )
	cPass := enCode64( GetMv('MV_884_06',.F.,'4b#8YPD!F_Qm') )
	
	// Fazer conexão de autenticação para obter o token.
	AAdd( aHead, "Content-Type: application/json" )
	AAdd( aHead, "Accept: application/json" )
	
	aResult := Array( 8 )
	aFill( aResult, '' )
	
	cTmpIni := U_RNGETNOW()
	nSecond := Seconds()
	aResult[ 1 ] := 'Opção de busca. [' + LTrim( Str( oOpcPesq:nAt ) ) + '-' + aOpcPesq[ oOpcPesq:nAt ] + ']'
	aResult[ 2 ] := 'Conectando..... [autenticação: ' + cURL + cAPI_1 + cUser + '/' + cPass + ']'
	
	o884Rest := FWRest():New( cURL )
	o884Rest:setPath( cAPI_1 + cUser + '/' + cPass )
	cTempos := ''
	cRJson := ''
	
	If o884Rest:Get( aHead )
		cGetResult := o884Rest:GetResult()
		
		If cGetResult <> '[ ]'
			If FWJsonDeserialize( cGetResult, @o884Resul1 )
				If ValType( o884Resul1 ) == 'A'
					oObj := AClone( o884Resul1 )
				Else
					oObj := {}
					AAdd( oObj, o884Resul1 )
				Endif
				
				cToken := oObj[1]:token
				
				// Verificar qual a opção foi escolhida.
				nOpc := oOpcPesq:nAt
				
				// 1=CPF do Titular
				// 2=CPF do Faturamento
				// 3=CNPJ do Titular
				// 4=CNPJ do Faturamento
				// 5=Pedido Site
				// 6=Pedido GAR
				// 7=CPF do Agente de Registro
				// 8=Autenticar
				// 9=Pedido eCommerce
				If nOpc == 1
					cPar := cAPI_2 + cToken + '/T' + AllTrim(cPesq)+'/1'
					 
				Elseif nOpc == 2
					cPar := cAPI_2 + cToken + '/F' + AllTrim(cPesq)+'/1'
					
				Elseif nOpc == 3 
					cPar := cAPI_2 + cToken + '/T' + AllTrim(cPesq)+'/1'
					
				Elseif nOpc == 4 
					cPar := cAPI_2 + cToken + '/F' + AllTrim(cPesq)+'/1'
					
				Elseif nOpc == 5
					cPar := cAPI_2 + cToken + '/S' + AllTrim(cPesq)+'/2'
					
				Elseif nOpc == 6
					cPar := cAPI_2 + cToken + '/G' + AllTrim(cPesq)+'/2'

				Elseif nOpc == 7
					cPar := cAPI_3 + cToken + '/' + AllTrim(cPesq)+'/3'
					
				Elseif nOpc == 8
					Finish1( @aResult, cTmpIni, nSecond, 'Token ' + cToken )
				
				Elseif nOpc == 9
					cPar := cAPI_2 + cToken + '/E' + AllTrim(cPesq)+'/2'
				Endif
				
				If nOpc < 10
					Finish1( @aResult, cTmpIni, nSecond, 'Token ' + cToken )
					
					cTmpIni := U_RNGETNOW()
					nSecond := Seconds()
					
					aResult[ 5 ] := ''
					aResult[ 6 ] := 'Conectando..... [consultar: ' + cURL + cPar + ']'
					
					o884Rest:setPath( cPar )
					
					If o884Rest:Get( aHead )
						cGetResult := o884Rest:GetResult()
						If cGetResult <> '[ ]'
							cResult := '[Consulta realizada com sucesso] '
							Finish2( @aResult, cTmpIni, nSecond, cResult )
							cRJson := JsonPretti( cGetResult, 3 )
						Else
							cResult := '[FIZ A CONSULTA, PORÉM RETORNOU VAZIO] ' + CRLF + CRLF+ cGetResult
							Finish2( @aResult, cTmpIni, nSecond, cResult )
						Endif
					Else
						cResult := '[NÃO CONSEGUI FAZER GET NA CONSULTA]' + CRLF + CRLF + o884Rest:GetLastError()
						Finish2( @aResult, cTmpIni, nSecond, cResult )
					Endif
				Endif
			Else
				cResult := '[NÃO CONSEGUI DESERIALIZAR A AUTENTICAÇÃO]' + CRLF + cGetResult
				Finish1( @aResult, cTmpIni, nSecond, cResult )
			Endif
		Else
			cResult := '[FIZ A AUTENTICAÇÃO, PORÉM RETORNOU VAZIO]' + CRLF + cGetResult
			Finish1( @aResult, cTmpIni, nSecond, cResult )
		Endif
	Else
		cResult := '[NÃO CONSEGUI FAZER GET NA AUTENTICAÇÃO]' + CRLF + o884Rest:GetLastError()
		Finish1( @aResult, cTmpIni, nSecond, cResult )
	Endif
	
	For i := 1 To Len( aResult )
		cTempos += aResult[ i ] + CRLF
	Next i 
	
	cCadastro := ''
Return

Static Function Finish1( aResult, cTmpIni, nSecond, cResult )
	Local cTmpFim := U_RNGETNOW()
	Local cTmpDec := cValToChar( Seconds() - nSecond )
	
	aResult[ 3 ] := 'Tempo resposta. [duração ' + cTmpDec + ' | início ' + cTmpIni + ' | fim ' + cTmpFim + ']'
	aResult[ 4 ] := 'Resultado...... [' + cResult + ']'
Return

Static Function Finish2( aResult, cTmpIni, nSecond, cResult )
	Local cTmpFim := U_RNGETNOW()
	Local cTmpDec := cValToChar( Seconds() - nSecond )
	
	aResult[ 7 ] := 'Tempo resposta. [duração ' + cTmpDec + ' | início ' + cTmpIni + ' | fim ' + cTmpFim + ']'
	aResult[ 8 ] := 'Resultado...... ' + cResult + ' '
Return

#DEFINE CHR_HT Chr(9)
#DEFINE CHR_LF Chr(10)

Static Function JsonPretti(cJstr, nTab)
	Local nConta, cBefore, cTab
	Local cLetra := ""
	Local lInString := .F.
	Local cNewJsn := ""
	Local nIdentLev := 0
	Default nTab := -1

	if nTab > 0
		cTab := REPLICATE(" ", nTab)
	else
	    cTab := CHR_HT
	endif
	
	For nConta:= 1 To Len(cJstr)
	
		cBefore := cLetra
		cLetra := SubStr(cJstr, nConta, 1)		
		
		if cLetra == "{" .or. cLetra == "["
			if !lInString
				nIdentLev++
				cNewJsn += cLetra + CRLF + REPLICATE( cTab, nIdentLev)
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == "}" .or. cLetra == "]"
			if !lInString
				nIdentLev--
				cNewJsn += CRLF + REPLICATE(cTab, nIdentLev) + cLetra
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == ","
	   		if !lInString
				cNewJsn += cLetra + CRLF + REPLICATE(cTab, nIdentLev)
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == ":"
	   		if !lInString
				cNewJsn += ": "
			else
				cNewJsn += cLetra
			endif
		elseif cLetra == " " .or. cLetra == CHR_LF .or. cLetra == CHR_HT
			if lInString
				cNewJsn += cLetra
			endif
		elseif cLetra == '"'
	   		if cBefore != "\"
				lInString := !lInString
			endif
			cNewJsn += cLetra
		else
			cNewJsn += cLetra
		endif
	Next
Return cNewJsn