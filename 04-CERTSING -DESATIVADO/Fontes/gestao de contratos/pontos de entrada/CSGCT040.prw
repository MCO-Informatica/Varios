#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "Protheus.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"

#DEFINE DEF_TRAALT "039" //Atualizacao do contrato

//---------------------------------------------------------------------------------
// Rotina | CSGCT040 | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Rotina específica para cadastrar o destinatário para receber  
//        | notificação baseado em cada situação do contrato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSGCT040(nOpcA)
	Local aSay      := {}
	Local aButton   := {}
	Local nOpcao    := 0
	Local lContinua := .F.
	Private cTitulo := 'Notificações eMails - Contratos'
	
	AAdd( aSay, 'Rotina específica para cadastrar o(s) destinatário(s) para receber notificação' )
	AAdd( aSay, 'baseado em cada situação do contrato.')
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 02, .T., { || FechaBatch() } } )
	
	
	If .NOT. Empty( CN9->CN9_REVATU )
			MsgInfo('ATENÇÃO'+CRLF+CRLF+;
			'Posicione no contrato '+CN9->CN9_NUMERO+' com a revisão atual '+CN9->CN9_REVATU+', pois este registro é uma revisão antiga '+CN9->CN9_REVISA+'.',cCadastro)
	Else
		lContinua := IIF( nOpcA == 1, CN240VldUsr(CN9->CN9_NUMERO,DEF_TRAALT), .T. ) 
		IF lContinua
			FormBatch( cTitulo, aSay, aButton )
			
			If nOpcao == 1
				GCT40Proc(nOpcA)
			Endif
		EndIF
	EndIF
Return

//---------------------------------------------------------------------------------
// Rotina | GCT40Proc | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Monta a MsDialog para cadastrar os usuários da notificação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function GCT40Proc(nOpcA)
	Local aaCampos  := {"CODIGO"} //Variável contendo o campo editável no Grid
	Local aaCampos1 := {"TIPO","EMAIL"} //Variável contendo o campo editável no Grid
	Local oMainWnd
	Local oDlg
	Local oTPanel
	Local nOpc := 0
	Local cCadastro := 'Notificações eMails - Contratos'
	Local oBrowse
	Local oFld
	Local aFolder := {}
	Private cCN9NUM  := IIF( nOpcA == 1, CN9->CN9_NUMERO, M->CN9_NUMERO )
	Private cCN9REV  := IIF( nOpcA == 1, CN9->CN9_REVISA, M->CN9_REVISA )
	Private cCN9DESC := IIF( nOpcA == 1, CN9->CN9_DESCRI, M->CN9_DESCRI )
    
	Private oGetDad1
	Private oGetDad2
	Private oGetDad3
	Private oLista          
	Private aHeader  := {}  
	Private aHeader1 := {}  
	Private aColsEx 	:= {}  
	Private aCOLS1 := {}
	Private aCOLS2 := {}
	Private aCOLS3 := {}
	Private aCOLS4 := {}
	Private aCOLS5 := {}
	Private aCOLS6 := {}
	Private aCOLS7 := {}
	Private aCOLS8 := {}
    
	AAdd( aFolder, "Caução"     )
	AAdd( aFolder, "Medição"    )
	AAdd( aFolder, "Planilha"   )
	AAdd( aFolder, "Reajuste"   )
	AAdd( aFolder, "Revisão"    )
	AAdd( aFolder, "Situação"   )
	AAdd( aFolder, "Vencimento" )
	AAdd( aFolder, "Exceção"    )
		
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 400,800 OF oMainWnd PIXEL
	oDlg:lEscClose := .F.
			
	oTPanel := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel:Align := CONTROL_ALIGN_TOP
		
	@ 5,02 SAY "Contrato: " + cCN9NUM + ' - ' + rTrim(cCN9DESC) SIZE 400,10 PIXEL OF oTPanel
	
	oFld := TFolder():New( 5, 5, aFolder, , oDlg,,,,.T.,.F.,215,130, )
	oFld:Align := CONTROL_ALIGN_ALLCLIENT
	
        //chamar a função que cria a estrutura do aHeader
	CriaCabec()
		 
		 //Monta o browser com inclusão, remoção e atualização
	oGetDad1 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "U_GCT40SEEK(1)", "", "AllwaysTrue", oFld:aDialogs[1], aHeader, aCOLS1)
	oGetDad1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
        
	oGetDad2 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "U_GCT40SEEK(2)", "", "AllwaysTrue", oFld:aDialogs[2], aHeader, aCOLS2)
	oGetDad2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
        
	oGetDad3 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "U_GCT40SEEK(3)", "", "AllwaysTrue", oFld:aDialogs[3], aHeader, aCOLS3)
	oGetDad3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
        
	oGetDad4 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "U_GCT40SEEK(4)", "", "AllwaysTrue", oFld:aDialogs[4], aHeader, aCOLS4)
	oGetDad4:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
        
	oGetDad5 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "U_GCT40SEEK(5)", "", "AllwaysTrue", oFld:aDialogs[5], aHeader, aCOLS5)
	oGetDad5:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
        
	oGetDad6 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "U_GCT40SEEK(6)", "", "AllwaysTrue", oFld:aDialogs[6], aHeader, aCOLS6)
	oGetDad6:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	oGetDad7 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "U_GCT40SEEK(7)", "", "AllwaysTrue", oFld:aDialogs[7], aHeader, aCOLS7)
	oGetDad7:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
        
	oGetDad8 := MsNewGetDados():New( 1,1,1,1 , GD_INSERT+GD_DELETE+GD_UPDATE, "U_GCT40VALID()", "AllwaysTrue", "AllwaysTrue", aACampos1,1, 999, "AllwaysTrue", "", "AllwaysTrue", oFld:aDialogs[8], aHeader1, aCOLS8)
	oGetDad8:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
    //Carregar os itens que irão compor o conteudo do grid
	Carregar()

   ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, ;
		{|| Iif( MsgYesNo("Confirma a gravação dos dados?",cCadastro),( nOpc:=1, oDlg:End() ), NIL) }, ;
		{|| oDlg:End() } )
			
	If nOpc == 1
		Processa({|| GCT40Grava(nOpcA) },cCadastro,"Gravando os dados, aguarde...",.F.)
	Endif
   
Return

//---------------------------------------------------------------------------------
// Rotina | CriaCabec | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Monta o aHeader
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////
Static Function CriaCabec()
	Local cTit := 'Email - [ Mais de um e-mail separar por ponto e vírgula ( ; ) ]'
	Local cBOX := '1=Caução;2=Medição;3=Planilha;4=Reajuste;5=Revisão;6=Situação;7=Vencimento'
	
	AAdd( aHeader, {"      ","      ","  ",00,0,".F.","","C","","V","","",""})
	AAdd( aHeader, {"Codigo","CODIGO","@!",06,0,"","","C","GCT040","R","","",""})
	AAdd( aHeader, {"Nome"  ,"NOME"  ,"@!",25,0,"","","C",""   ,"R","","",""})
	AAdd( aHeader, {"Email" ,"EMAIL" ,"@!",60,0,"","","C",""   ,"R","","",""})
	
	AAdd( aHeader1, {"      ","      ","  ",00,0,".F.","","C","","V","","",""})
	AAdd( aHeader1, {"Tipo"  ,"TIPO  ","@!",01,0,""   ,"","C","","R",cBOX,"","","","","","SubStr( Bin2Str( '€€€€€€€€€€€€€€ ' ), 1, 1) == 'x'"})
	AAdd( aHeader1, {cTit    ,"EMAIL"  ,"" ,100,0,""   ,"","C","","R","","",""})	
Return

//---------------------------------------------------------------------------------
// Rotina | Carregar | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Carrega os dados para descarregar em cada Folder conforme situação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function Carregar()
	Local nP := 0
	Local nL := 0
	Local nX := 0
	Local aUsr := {}
	Local aGET1 := {}
	Local aGET2 := {}
	Local aGET3 := {}
	Local aGET4 := {}
	Local aGET5 := {}
	Local aGET6 := {}
	Local aGET7 := {}
	Local aGET8 := {}
	Local aDado := {}
	Local cUser  := ''
	Local cDados := ''
	Local cBkp   := ''
	Local cSeek1 := '1='
	Local cSeek2 := '2='
	Local cSeek3 := '3='
	Local cSeek4 := '4='
	Local cSeek5 := '5='
	Local cSeek6 := '6='
	Local cSeek7 := '7='
	Local cSeek8 := 'X='
	
	CN9->( dbSetOrder(1) )
	IF CN9->( dbSeek( xFilial('CN9') + cCN9NUM + cCN9REV ) )
		cDados := CN9->CN9_NOTVEN
		cBkp   := cDados
	
		PswOrder( 1 )
		While cSeek1 $ cDados
			nP := At( cSeek1, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				AAdd( aGET1, { cUser, RTrim( aUsr[ 1, 4 ] ), RTrim( aUsr[ 1, 14 ] ) } )
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		While cSeek2 $ cDados
			nP := At( cSeek2, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				AAdd( aGET2, { cUser, RTrim( aUsr[ 1, 4 ] ), RTrim( aUsr[ 1, 14 ] ) } )
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		While cSeek3 $ cDados
			nP := At( cSeek3, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				AAdd( aGET3, { cUser, RTrim( aUsr[ 1, 4 ] ), RTrim( aUsr[ 1, 14 ] ) } )
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		While cSeek4 $ cDados
			nP := At( cSeek4, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				AAdd( aGET4, { cUser, RTrim( aUsr[ 1, 4 ] ), RTrim( aUsr[ 1, 14 ] ) } )
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		While cSeek5 $ cDados
			nP := At( cSeek5, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				AAdd( aGET5, { cUser, RTrim( aUsr[ 1, 4 ] ), RTrim( aUsr[ 1, 14 ] ) } )
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		While cSeek6 $ cDados
			nP := At( cSeek6, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				AAdd( aGET6, { cUser, RTrim( aUsr[ 1, 4 ] ), RTrim( aUsr[ 1, 14 ] ) } )
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		While cSeek7 $ cDados
			nP := At( cSeek7, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				AAdd( aGET7, { cUser, RTrim( aUsr[ 1, 4 ] ), RTrim( aUsr[ 1, 14 ] ) } )
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		aDado := StrTokArr2( cDados, ';;' )
		For nL := 1 To Len( aDado )
			nP := aScan( aDado, {|X| Left( X, 2 ) == cSeek8 } )
			IF nP > 0
				AAdd( aGET8, { SubStr(aDado[nP],3,1), PadR( SubStr(aDado[nP],4), 150, '' ) } )
				aDel( aDado, nP)
				aSize( aDado, Len(aDado) - 1 )
			EndIF
		Next nL
		
		cDados := cBkp
				
		For nL := 1 To Len ( aGET1 )
			aADD( aCOLS1, {'', aGET1[nL,1], aGET1[nL,2], aGET1[nL,3], .F.} )
		Next nL
		
		For nL := 1 To Len ( aGET2 )
			aADD( aCOLS2, {'', aGET2[nL,1], aGET2[nL,2], aGET2[nL,3], .F.} )
		Next nL
		
		For nL := 1 To Len ( aGET3 )
			aADD( aCOLS3, {'', aGET3[nL,1], aGET3[nL,2], aGET3[nL,3], .F.} )
		Next nL
		
		For nL := 1 To Len ( aGET4 )
			aADD( aCOLS4, {'', aGET4[nL,1], aGET4[nL,2], aGET4[nL,3], .F.} )
		Next nL
		
		For nL := 1 To Len ( aGET5 )
			aADD( aCOLS5, {'', aGET5[nL,1], aGET5[nL,2], aGET5[nL,3], .F.} )
		Next nL
		
		For nL := 1 To Len ( aGET6 )
			aADD( aCOLS6, {'', aGET6[nL,1], aGET6[nL,2], aGET6[nL,3], .F.} )
		Next nL
		
		For nL := 1 To Len ( aGET7 )
			aADD( aCOLS7, {'', aGET7[nL,1], aGET7[nL,2], aGET7[nL,3], .F.} )
		Next nL
		
		For nL := 1 To Len ( aGET8 )
			aADD( aCOLS8, {'', aGET8[nL,1], aGET8[nL,2], .F.} )
		Next nL
	
	EndIF

	IF Empty( aGET1 )
		aADD( aCOLS1, {'',Space(06),'','',.F.} )
	EndIF
	IF Empty( aGET2 )
		aADD( aCOLS2, {'',Space(06),'','',.F.} )
	EndIF
	IF Empty( aGET3 )
		aADD( aCOLS3, {'',Space(06),'','',.F.} )
	EndIF
	IF Empty( aGET4 )
		aADD( aCOLS4, {'',Space(06),'','',.F.} )
	EndIF
	IF Empty( aGET5 )
		aADD( aCOLS5, {'',Space(06),'','',.F.} )
	EndIF
	IF Empty( aGET6 )
		aADD( aCOLS6, {'',Space(06),'','',.F.} )
	EndIF
	IF Empty( aGET7 )
		aADD( aCOLS7, {'',Space(06),'','',.F.} )
	EndIF
	IF Empty( aGET8 )
		aADD( aCOLS8, {'',Space(01),Space(150),.F.} )
	EndIF
	
    //Setar array do aCols do Objeto.
	oGetDad1:SetArray(aCOLS1,.T.)
	oGetDad2:SetArray(aCOLS2,.T.)
	oGetDad3:SetArray(aCOLS3,.T.)
	oGetDad4:SetArray(aCOLS4,.T.)
	oGetDad5:SetArray(aCOLS5,.T.)
	oGetDad6:SetArray(aCOLS6,.T.)
	oGetDad7:SetArray(aCOLS7,.T.)
	oGetDad8:SetArray(aCOLS8,.T.)

    //Atualizo as informações no grid
	oGetDad1:Refresh()
	oGetDad2:Refresh()
	oGetDad3:Refresh()
	oGetDad4:Refresh()
	oGetDad5:Refresh()
	oGetDad6:Refresh()
	oGetDad7:Refresh()
	oGetDad8:Refresh()
Return

//---------------------------------------------------------------------------------
// Rotina | GCT40SEEK | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Verifica o código de usuário preenchido e descarrega Nome e E-mail.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function GCT40SEEK(nGetD)
	Local aUsr  := {}
	Local cUser := CODIGO
	Local cExec := ''
	Local lRet  := .T.
	
	cExec := "{|| aScan( oGetDad" + lTrim( Str(nGetD) ) + ":aCOLS, {|x| x[2] == '" + cUser + "'} ) > 0 }"
	IF Eval(&cExec)
		MsgAlert('Usuário já informado.')
		Return(.F.)
	EndIF
	
	PswOrder( 1 )
	IF PswSeek( cUser, .T. )
		aUsr := PswRet()
		
		IF Empty( aUsr[ 1, 14 ] )
			MsgAlert('Usuário sem e-mail preencido no cadastro, verifique com Sistemas Corporativos.')
			lRet := .F.
		Else
			//-------------------------------
			//Atribui o campo Nome do usuário
			//-------------------------------
			cExec := "{|| oGetDad" + lTrim( Str(nGetD) ) + ":aCOLS[oGetDad" + lTrim( Str(nGetD) )+":nAT,3] := '" + RTrim(aUsr[1,4]) + "'}"
			Eval(&cExec)
			//---------------------------------
			//Atribui o campo E-mail do usuário
			//---------------------------------			
			cExec := "{|| oGetDad" + lTrim( Str(nGetD) ) + ":aCOLS[oGetDad" + lTrim( Str(nGetD) )+":nAT,4] := '" + RTrim(aUsr[1,14]) + "'}"
			Eval(&cExec)
		EndIF
	Else
		MsgAlert('Usuário não localizado.')
		lRet := .F.
	EndIF
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | GCT40VALID | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Valida os dados informados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function GCT40VALID()
	Local lRet   := .T.
	Local nL     := 0
	Local aEmail := StrTokArr2( rTrim(oGetDad8:aCOLS[oGetDad8:nAt,3]), ';' )
	
	IF .NOT. oGetDad8:aCOLS[oGetDad8:nAt,4] .And. ( Empty( oGetDad8:aCOLS[oGetDad8:nAt,2] ) .OR. Empty( oGetDad8:aCOLS[oGetDad8:nAt,3] ) )
		MsgAlert('Atenção, preenchimento obrigatório o tipo da Exceção.')
		lRet := .F.
		Return( lRet )
	EndIF
	
	For nL := 1 To Len( aEmail )
		lRet := IsEmail( aEmail[nL] )
		IF ! lRet 
			MsgAlert('Atenção, e-mail inválido.')
			Exit		
		EndIF
	Next nL
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | GCT40Grava | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Grava os dados no campo CN9_NOTVEN em ordem por Folder
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function GCT40Grava(nOpcA)
	Local cDado1 := ''
	Local cDado2 := ''
	Local cDado3 := ''
	Local cDado4 := ''
	Local cDado5 := ''
	Local cDado6 := ''
	Local cDado7 := ''
	Local cDado8 := ''
	Local cDADOS := ''
	Local nL     := 0
	
	For nL := 1 To Len( oGetDad1:aCOLS )
		IF .NOT. ( oGetDad1:aCOLS[nL,5] ) .And. .NOT. Empty( oGetDad1:aCOLS[nL,2] )
			cDado1 += '1=' + oGetDad1:aCOLS[nL,2] + ';;'
		EndIF
	Next nL
	
	For nL := 1 To Len( oGetDad2:aCOLS )
		IF .NOT. ( oGetDad2:aCOLS[nL,5] ) .And. .NOT. Empty( oGetDad2:aCOLS[nL,2] )
			cDado2 += '2=' + oGetDad2:aCOLS[nL,2] + ';;'
		EndIF
	Next nL
	
	For nL := 1 To Len( oGetDad3:aCOLS )
		IF .NOT. ( oGetDad3:aCOLS[nL,5] ) .And. .NOT. Empty( oGetDad3:aCOLS[nL,2] )
			cDado3 += '3=' + oGetDad3:aCOLS[nL,2] + ';;'
		EndIF
	Next nL
	
	For nL := 1 To Len( oGetDad4:aCOLS )
		IF .NOT. ( oGetDad4:aCOLS[nL,5] ) .And. .NOT. Empty( oGetDad4:aCOLS[nL,2] )
			cDado4 += '4=' + oGetDad4:aCOLS[nL,2] + ';;'
		EndIF
	Next nL
	
	For nL := 1 To Len( oGetDad5:aCOLS )
		IF .NOT. ( oGetDad5:aCOLS[nL,5] ) .And. .NOT. Empty( oGetDad5:aCOLS[nL,2] )
			cDado5 += '5=' + oGetDad5:aCOLS[nL,2] + ';;'
		EndIF
	Next nL
	
	For nL := 1 To Len( oGetDad6:aCOLS )
		IF .NOT. ( oGetDad6:aCOLS[nL,5] ) .And. .NOT. Empty( oGetDad6:aCOLS[nL,2] )
			cDado6 += '6=' + oGetDad6:aCOLS[nL,2] + ';;'
		EndIF
	Next nL
	
	For nL := 1 To Len( oGetDad7:aCOLS )
		IF .NOT. ( oGetDad7:aCOLS[nL,5] ) .And. .NOT. Empty( oGetDad7:aCOLS[nL,2] )
			cDado7 += '7=' + oGetDad7:aCOLS[nL,2] + ';;'
		EndIF
	Next nL
	
	//Orderna o array por Tipo.
	aSort( oGetDad8:aCOLS, , , {|X,Y| X[2] < Y[2] } )
	
	For nL := 1 To Len( oGetDad8:aCOLS )
		IF .NOT. ( oGetDad8:aCOLS[nL,4] ) .And. ( ! Empty(oGetDad8:aCOLS[nL,2]) .And. ! Empty(oGetDad8:aCOLS[nL,3])  )
			cDado8 += 'X=' + oGetDad8:aCOLS[nL,2] + rTrim(oGetDad8:aCOLS[nL,3]) +  ';;'
		EndIF
	Next nL
	
	cDADOS := cDado1 + cDado2 + cDado3 + cDado4 + cDado5 + cDado6 + cDado7 + cDado8
	
	IF nOpcA == 1
		CN9->( dbSetOrder(1) )
		IF CN9->( dbSeek( xFilial('CN9') + cCN9NUM + cCN9REV ) )
			CN9->( RecLock('CN9',.F.) )
			CN9->CN9_NOTVEN := cDADOS
			CN9->( MsUnLock() )
		EndIF
	Else
		M->CN9_NOTVEN := cDADOS
	EndIF
Return

//---------------------------------------------------------------------------------
// Rotina | GCT40USR | Autor | Rafael Beghini                 | Data | 15.07.2016
//---------------------------------------------------------------------------------
// Descr. | Rotina para retornar os usuários conforme parâmetros.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function GCT40USR( cSeek, cTIPO, cCN9FIL, cCN9NUM, cCN9REV )
	Local cRet  := ''
	Local cBkp  := ''
	Local cUser := ''
	Local cDados := ''
	Local nL := 0
	Local aDado := {}
	
	Default cCN9NUM := ' '
	Default cCN9REV := ' '
	
	//Opções de busca
	//1=Caução;2=Medição;3=Planilha;4=Reajuste;5=Revisão;6=Situação;7=Vencimento
	
	CN9->( dbSetOrder(1) )
	IF CN9->( dbSeek( cCN9FIL + cCN9NUM + cCN9REV ) )
		cDados := CN9->CN9_NOTVEN
		cBkp := cDados
		
		PswOrder( 1 )
		While cSeek $ cDados
			nP := At( cSeek, cDados )
			If nP > 0
				cUser := SubStr( cDados, nP + 2, 6 )
				PswSeek( cUser, .T. )
				aUsr := PswRet()
				cRet += RTrim( aUsr[ 1, 14 ] ) + ';'
				cDados := SubStr( cDados, nP + 8 )
			Else
				Exit
			Endif
		End
		cDados := cBkp
		
		aDado := StrTokArr2( cDados, ';;' )
		For nL := 1 To Len( aDado )
			nP := aScan( aDado, {|X| Left( X, 3 ) == cTIPO } )
			IF nP > 0
				cRet += SubStr(aDado[nP],4) + ';'
				aDel( aDado, nP)
				aSize( aDado, Len(aDado) - 1 )
			EndIF
		Next nL
	EndIF	
	
	cRet := rTrim( StrTran( cRet, ';;', ';') )
	cRet := rTrim( StrTran( cRet, CRLF, '') )
Return( cRet )