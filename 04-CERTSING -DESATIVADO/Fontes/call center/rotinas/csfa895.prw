//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao |
//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| 15/04/2020 | Bruno Nunes   | Adicionada a opcao de chamar o servico ativo de renovacao.                       | 1.00   |
//+------------+---------------+----------------------------------------------------------------------------------+--------+
#Include "Protheus.ch"
#Include "FWBrowse.ch"

//-----------------------------------------------------------------------
// Rotina | CSFA895 | Autor | Robson L. E. Gonçalves | Data | 30/07/2018
//-----------------------------------------------------------------------
// Descr. | Rotina para simular a consulta do AENET fazendo a mesma 
//        | rota de acesso via WebService do Protheus.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//-----------------------------------------------------------------------
User Function CSFA895()
	Local aC := FWGetDialogSize(oMainWnd)
	Local aOpcPesq := {}
	
	Local cMGet := ''
	Local cCNPJ := Space(14)
	Local cPedData := Space(10)
	Local cOpcPesq := ''
	Local cTempos := ''
	
	Local lRota := .F.
	
	Local oBtnA, oBtnL, oBtnP, oBtnS
	Local oDlg
	Local oFont := TFont():New('Consolas',,16,,.F.,,,,,.F.,.F.)
	Local oRota
	Local oFWLayer
	Local oMGet
	Local oOpcPesq
	Local oTempos
	Local oTPanelPar, oTPanelRet
	Local oWinPar, oWinRet
	
	private cAPI_1 := ""
	private cAPI_2 := ""
	private cAPI_3 := ""
	private cAPI_4 := ""
	private cAPI_5 := ""
	private cAPI_6 := ""
	
	aOpcPesq := {'Autenticação',;                              //1
				 'Pedidos (CNPJ + Pedido)',;                   //2
				 'Agendamentos de certificados (CNPJ + data)',;//3
				 'Eventos (CNPJ + data)',;                     //4
				 'Ativo para renovacao ',;                     //5
				 'Lista Postos ' }                     		   //6
				
	DEFINE MSDIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
		oFWLayer := FWLayer():New()	
		oFWLayer:Init( oDlg, .F. )
		
		oFWLayer:AddCollumn( "Col01", 100, .T. )
		
		oFWLayer:AddWindow( "Col01", "Win01", "Parâmetros", 19, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		oFWLayer:AddWindow( "Col01", "Win02", "Tempos e resultado da pesquisa." , 81, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		
		oWinPar := oFWLayer:GetWinPanel('Col01','Win01')
		oWinRet := oFWLayer:GetWinPanel('Col01','Win02')
		
		oTPanelPar := TPanel():New(0,0,"",oWinPar,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
		oTPanelPar:Align := CONTROL_ALIGN_ALLCLIENT
		
		oTPanelRet := TPanel():New(0,0,"",oWinRet,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
		oTPanelRet:Align := CONTROL_ALIGN_ALLCLIENT
		
		@ 1,003 SAY 'Opção de consulta:' SIZE 100,7 PIXEL OF oTPanelPar
		@ 9,003 COMBOBOX oOpcPesq VAR cOpcPesq ITEMS aOpcPesq SIZE 140,15 PIXEL OF oTPanelPar
		
		@ 1,150 SAY 'CNPJ da AR (somente números):' SIZE 150,7 PIXEL OF oTPanelPar
		@ 9,150 MSGET cCNPJ PICTURE "@!" SIZE 105,12 PIXEL OF oTPanelPar
		
		@ 24,150 CHECKBOX oRota VAR lRota PROMPT 'Selecionar rota específica?' SIZE 150,8 PIXEL OF oTPanelPar
		
		@ 1,262 SAY 'Pedido site (somente números) ou data (aaaammdd):' SIZE 200,7 PIXEL OF oTPanelPar
		@ 9,262 MSGET cPedData PICTURE "@!" SIZE 105,12 PIXEL OF oTPanelPar

		oTempos := TMultiGet():New(1,1,{|u| Iif( PCount()==0,cTempos,cTempos:=u)},oTPanelRet,140,70,oFont,/*lHScroll*/,/*nClrFore*/,/*nClrBack*/,/*oCursor*/,.T.,/*cMg*/,.T.,{||.F. },/*lCenter*/,/*lRight*/,.F.,{|| .T. },/*bChange*/,.T.,.F.)
		oTempos:Align := CONTROL_ALIGN_TOP

		oMGet := TMultiGet():New(1,1,{|u| Iif( PCount()==0,cMGet,cMGet:=u)},oTPanelRet,140,33,oFont,/*lHScroll*/,/*nClrFore*/,/*nClrBack*/,/*oCursor*/,.T.,/*cMg*/,.T.,{||.F. },/*lCenter*/,/*lRight*/,.F.,{|| .T. },/*bChange*/,.T.,.F.)
		oMGet:Align := CONTROL_ALIGN_ALLCLIENT
		
		@ 9,428 	BUTTON oBtnP ;
					PROMPT "&Pesquisar" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION  Iif(Validar(cCNPJ,cPedData,oOpcPesq),Pesquisar( cCNPJ, cPedData, oOpcPesq, aOpcPesq, @cTempos, @cMGet, lRota, oRota ),NIL)
		
		@ 9,488 	BUTTON oBtnL ;
					PROMPT "&Limpar" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION  Iif(MsgYesNo("Deseja realmente limpar o resultado?","TOTVS | Certisign"),(cCNPJ:=Space(14),cPedData:=Space(10),cTempos:='',cMGet:=''),NIL)
		
		@ 9,548 	BUTTON oBtnA ;
					PROMPT "Status &GAR" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION (StatusGAR())
		
		@ 9,608 	BUTTON oBtnS ;
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
Static Function Validar( cCNPJ, cPedData, oOpcPesq )
	Local cNum := AllTrim( cCNPJ )
	Local i := 0
	Local lRet := .T. 
	
	If oOpcPesq:nAt <> 1
		If Empty( cCNPJ )
			MsgAlert('Por favor, informe o CNPJ para pesquisar.', 'TOTVS')
			lRet := .F.
		Else
			For i := 1 To Len( cNum )
				If .NOT. (SubStr( cNum, i, 1 ) $ '0123456789')
					MsgAlert('Por favor, informe somente números para o CNPJ.', 'TOTVS')
					lRet := .F.
					Exit
				Endif
			Next i
		Endif
		
		If lRet .AND. Empty( cPedData )
			MsgAlert('Por favor, informe o número do pedido ou data de pesquisa.', 'TOTVS')
			lRet := .F.
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
Static Function Pesquisar( cCNPJ, cPedData, oOpcPesq, aOpcPesq, cTempos, cMGet, lRota, oRota )
	FWMsgRun(,{|| doResearch( cCNPJ, cPedData, oOpcPesq, aOpcPesq, @cTempos, @cMGet, lRota, oRota ) },,'Efetuando a pesquisa...')
Return

Static Function doResearch( cCNPJ, cPedData, oOpcPesq, aOpcPesq, cTempos, cMGet, lRota, oRota )
	Local aHead := {}
	Local aOpcRota := {}
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
	
	o895Rest := NIL
	o895Resul1 := NIL
	
	If lRota
		aOpcRota := { "Balance (https + crm)", "Standalone (https + rn)", "Servidor (ip do server)", "Localhost" }
		
		AAdd( aPar,{ 3, "Selecione qual rota quer utilizar", 1, aOpcRota, 100, "", .F. } )
		
		If .NOT. ParamBox( aPar ,"Parâmetros",@aRet )
			MsgAlert('A rotina será abandonada.', 'TOTVS')
			Return
		Endif
		
		If aRet[1]==1
			cURL    := GetMv('MV_895_01',.F.,'https://gestao.certisign.com.br')
			cAPI_1  := GetMv('MV_895_02',.F.,'/aenet/arautenticar/')
			cAPI_2  := GetMv('MV_895_03',.F.,'/aenet/arconsultar/')
			cAPI_3  := GetMv('MV_895_04',.F.,'/aenet/aragendamento/')
			cAPI_4  := GetMv('MV_895_05',.F.,'/aenet/eventonodia/')
			cAPI_5  := GetMv('MV_895_06',.F.,'/aenet/ativorenovacao/')
			cAPI_6  := GetMv('MV_895_07',.F.,'/aenet/listaPostos/')
		Elseif aRet[1]==2
			cURL    := GetMv('MV_895_01',.F.,'https://gestao.certisign.com.br')
			cAPI_1  := GetMv('MV_895_02',.F.,'/rn/arautenticar/')
			cAPI_2  := GetMv('MV_895_03',.F.,'/rn/arconsultar/')
			cAPI_3  := GetMv('MV_895_04',.F.,'/rn/aragendamento/')
			cAPI_4  := GetMv('MV_895_05',.F.,'/rn/eventonodia/')
			cAPI_5  := GetMv('MV_895_06',.F.,'/rn/ativorenovacao/')
			cAPI_6  := GetMv('MV_895_07',.F.,'/rn/listaPostos/')
		Elseif aRet[1]==3
			cURL    := GetMv('MV_895_01',.F.,'192.168.16.129:8028')
			cAPI_1  := GetMv('MV_895_02',.F.,'/rn/arautenticar/')
			cAPI_2  := GetMv('MV_895_03',.F.,'/rn/arconsultar/')
			cAPI_3  := GetMv('MV_895_04',.F.,'/rn/aragendamento/')
			cAPI_4  := GetMv('MV_895_05',.F.,'/rn/eventonodia/')
			cAPI_5  := GetMv('MV_895_06',.F.,'/rn/ativorenovacao/')
			cAPI_6  := GetMv('MV_895_07',.F.,'/rn/listaPostos/')
		Elseif aRet[1]==4
			cURL    := GetMv('MV_895_01',.F.,'http://localhost:8084')
			cAPI_1  := GetMv('MV_895_02',.F.,'/rightnow/arautenticar/')
			cAPI_2  := GetMv('MV_895_03',.F.,'/rightnow/arconsultar/')
			cAPI_3  := GetMv('MV_895_04',.F.,'/rightnow/aragendamento/')
			cAPI_4  := GetMv('MV_895_05',.F.,'/rightnow/eventonodia/')
			cAPI_5  := GetMv('MV_895_06',.F.,'/rightnow/ativorenovacao/')
			cAPI_6  := GetMv('MV_895_07',.F.,'/rightnow/listaPostos/')
		Endif
	Else
		cURL    := GetMv('MV_895_01',.F.,'https://gestao.certisign.com.br')
		cAPI_1  := GetMv('MV_895_02',.F.,'/aenet/arautenticar/')
		cAPI_2  := GetMv('MV_895_03',.F.,'/aenet/arconsultar/')
		cAPI_3  := GetMv('MV_895_04',.F.,'/aenet/aragendamento/')
		cAPI_4  := GetMv('MV_895_05',.F.,'/aenet/eventonodia/')
		cAPI_5  := GetMv('MV_895_06',.F.,'/aenet/ativorenovacao/')
		cAPI_6  := GetMv('MV_895_07',.F.,'/aenet/listaPostos/')
	Endif
	
	cUser   := enCode64('aenet\integracao')
	cPass   := enCode64('q#6PlA&*m@uB4yhm')
	
	// Fazer conexão de autenticação para obter o token.
	AAdd( aHead, "Content-Type: application/json" )
	AAdd( aHead, "Accept: application/json" )
	
	aResult := Array( 8 )
	aFill( aResult, '' )
	
	cTmpIni := U_RNGETNOW()
	nSecond := Seconds()
	aResult[ 1 ] := 'Opção de busca. [' + LTrim( Str( oOpcPesq:nAt ) ) + '-' + aOpcPesq[ oOpcPesq:nAt ] + ']'
	aResult[ 2 ] := 'Conectando..... [autenticação: ' + cURL + cAPI_1 + cUser + '/' + cPass + ']'
	
	o895Rest := FWRest():New( cURL )
	o895Rest:setPath( cAPI_1 + cUser + '/' + cPass )
	cTempos := ''
	cMGet := ''
	
	If o895Rest:Get( aHead )
		cGetResult := o895Rest:GetResult()
		
		If cGetResult <> '[ ]'
			If FWJsonDeserialize( cGetResult, @o895Resul1 )
				If ValType( o895Resul1 ) == 'A'
					oObj := AClone( o895Resul1 )
				Else
					oObj := {}
					AAdd( oObj, o895Resul1 )
				Endif
				
				cToken := oObj[1]:token
				
				// Fazer a conexão com o token + os parâmetros de busca.
				nOpc := oOpcPesq:nAt
				
				// 1=Autenticar
				// 2=Consultar Pedidos
				// 3=Consultar Agendamento de Certificados
				// 4=Consultar Certificado com Algum Evento no Dia.
				// 5=Ativo de renovacao.
				cCNPJ := alltrim( cCNPJ )
				If nOpc == 1
					Finish1( @aResult, cTmpIni, nSecond, 'Token ' + cToken )
				Elseif nOpc == 2
					cPar := cAPI_2 + cToken + '/' + cCNPJ + '/' + cPedData
				Elseif nOpc == 3
				 	cPar := cAPI_3 + cToken + '/' + cCNPJ + '/' + StrTran(cPedData,'/','') //o formato deve ser ddmmaaaa.
				Elseif nOpc == 4
					cPar := cAPI_4 + cToken + '/' + cCNPJ + '/' + alltrim(StrTran(cPedData,'/','')) + "/CRSNT" //o formato deve ser ddmmaaaa.
				Elseif nOpc == 5
					cPar := cAPI_5 + cToken + '/' + cCNPJ + '/' + alltrim(StrTran(cPedData,'/','')) + "/CRSNT" //o formato deve ser ddmmaaaa.
				Elseif nOpc == 6
					cPar := cAPI_6 + cToken + '/' + cCNPJ  
				Endif
				
				If nOpc > 1
					Finish1( @aResult, cTmpIni, nSecond, 'Token ' + cToken )
					
					cTmpIni := U_RNGETNOW()
					nSecond := Seconds()
					
					aResult[ 5 ] := ''
					aResult[ 6 ] := 'Conectando..... [consultar: ' + cURL + RTrim( cPar ) + ']'
					
					o895Rest:setPath( cPar )
					conout( cURL + cPar )
					conout( cPar )
					If o895Rest:Get( aHead )
						cGetResult := o895Rest:GetResult()
						If cGetResult <> '[ ]'
							cResult := '[Consulta realizada com sucesso] '
							Finish2( @aResult, cTmpIni, nSecond, cResult )
							cMGet := JsonPrettify( cGetResult, 3 )
						Else
							cResult := '[FIZ A CONSULTA, PORÉM RETORNOU VAZIO] ' + CRLF + CRLF+ cGetResult
							Finish2( @aResult, cTmpIni, nSecond, cResult )
						Endif
					Else
						cResult := '[NÃO CONSEGUI FAZER GET NA CONSULTA]' + CRLF + CRLF + o895Rest:GetLastError()
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
		cResult := '[NÃO CONSEGUI FAZER GET NA AUTENTICAÇÃO]' + CRLF + o895Rest:GetLastError()
		Finish1( @aResult, cTmpIni, nSecond, cResult )
	Endif

	For i := 1 To Len( aResult )
		cTempos += aResult[ i ] + CRLF
	Next i 
	conout(cResult)
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

User Function STATUGAR()
	FormBatch( 'Listar siglas dos status GAR',;
	{'Rotina para lista as siglas dos status do sistema GAR.','','','','Clique em OK para prosseguir...'},;
	{{ 1, .T., {|| StatusGAR(), FechaBatch()}}, { 22, .T., {|| FechaBatch()}}} )
Return
  
Static Function StatusGAR()
	Local aArray := {}
	Local aFields := {}
	Local aSeek := {}
	
	Local cFile := 'statusgar.ini'
	
	Local oButton
	Local oBrowse
	Local oColumn
	Local oDlg
	
	If File( cFile )
		FT_FUSE( cFile )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cLine := FT_FREADLN()
			p := At( '#', cLine )
			AAdd( aArray, { SubStr( cLine, 1, p-1 ), SubStr( cLine, p+1 ) } )
			FT_FSKIP()
		End
		FT_FUSE()
		
		AAdd( aSeek, { "Sigla" , { {"","C",3,0,"Sigla"} } } )
		
		Aadd( aFields, { "Sigla"    ,"Sigla"    ,"C",03,0,""} )
		Aadd( aFields, { "Descrição","Descrição","C",60,0,""} )
		
		DEFINE MSDIALOG oDlg TITLE 'Siglas dos Status GAR' FROM 0,0 TO 400,800 PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS
			oDlg:lEscClose := .F.
			
			DEFINE FWFORMBROWSE oBrowse ;
			       DATA ARRAY ARRAY aArray ;
			       FILTERFIELDS aFields ;
			       SEEK ORDER aSeek ;
			       AFTER EXECUTE { || MsgAlert("depois") } ;
			       BEFORE EXECUTE { || MsgAlert("antes"), .t. } OF oDlg
			       
				ADD BUTTON oButton ;
				    TITLE "Sair da rotina" ;
				    ACTION { || oDlg:End() } OF oBrowse
				
				ADD COLUMN oColumn ;
				    DATA { || aArray[oBrowse:At(),1] } ;
				    TITLE "Sigla" ;
				    SIZE 03 OF oBrowse
				    
				ADD COLUMN oColumn ;
				    DATA { || aArray[oBrowse:At(),2] } ;
				    TITLE "Descrição" ;
				    SIZE 60 OF oBrowse
			ACTIVATE FWFORMBROWSE oBrowse
			
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		MsgAlert( 'Arquivo de dados [' + cFile + '] não localizado no \system', 'Status GAR' )
	Endif
Return

#DEFINE CHR_HT Chr(9)
#DEFINE CHR_LF Chr(10)

Static Function JsonPrettify(cJstr, nTab)
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