#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE cMSG1 'Prezado(a), '
#DEFINE cMSG2 ', '+CRLF
#DEFINE cMSG3 'Relacionamos abaixo uma lista de pedido(s) de compra(s) pendente(s) de aprovação(ões).'+CRLF
#DEFINE cMSG4 'Por favor e assim que possível, análise cada pedido clicando no link ao lado e efetue a aprovação ou a rejeição de cada pedido de compra.'
#DEFINE cTITULO_EMAIL 'Aprovação do Pedido de Compras'
#DEFINE aTITULO_TABELA {'Nº PC', 'Fornecedor', 'Vencimento', 'Total', 'Link'} //Corpo do email - tabela
#DEFINE aTYPE_COL {'T', 'T', 'T', 'N', 'A'}
#DEFINE aALIGN_COL {'left', 'left', 'center', 'right', 'center'}

/*/{Protheus.doc} CSFA720
Envia lista de aprovação de pedido de compra para os aprovadores que estão com seu pedido pendente.
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aParam, array, Posição 1 - Código da empresa Posição 2 - Código da Filial

@return nulo
/*/
User Function CSFA720(aParam)
//Local lRetorno 	 := .F. //Retorno da funcao - .T. Carregou tabela, .F. - Não carregou tabela
Local lExeChange := .T. //Executa o change Query
Local cQuery 	 := '' 	//Consulta SQL
Local cUserAnte  := ''  //user anterior
Local cNomeFor   := ''  //Nome do fornecedor
//Local cLink 	 := ''  //Caminho do .html
Local _cUser     := ''  //Pasta do usuario onde fica o .html
Local calias 	 := GetNextalias() 	//alias resevardo para consulta SQL
//Local cCSS 		 := CSFA720CSS() //Codigo do estilo do html
Local nRec 		 := 0   //Numero Total de Registros da consulta SQL
Local nTotal	 := 0.00 //Valor total do pedido de compra
Local aHeader	 := {}  //Dados que irao compor o envio do email
Local aBody		 := {}  //Dados que irao compor a tabela do html
Local aFornec 	 := {}  //Array com dados do Pedido de compras
Local aChaveSCR	 := {}  //Array com chaves para atualizar apos email
Local cMV_MAIL_ENV := 'MV_720EPAR'
Local cEmailCorp := 'sistemascorporativos@certisign.com.br'
Local aLogArq 	 := {}
Local cVencto := ''

Default aParam 	 := {'01', '02'}

//configura parametros se estiver vazio
if Len(aParam) == 0
	aAdd(aParam, '01')
	aAdd(aParam, '02')
endif

//configurar ambiente
rpcSetType(3)
PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO 'COM' TABLES 'SCR', 'SC7', 'SA2', 'SAL', 'SAK', 'CND', 'CNE', 'WF6'

If .NOT. GetMv( cMV_MAIL_ENV, .T. )
	CriarSX6( cMV_MAIL_ENV, 'C', 'EMAIL QUE SERA USADA PARA ENVIO DE EMAIL TESTE. EM PRODUCAO DEIXAR VAZIO CSFA720.prw', cEmailCorp )
Endif
cMV_MAIL_ENV := GetMv( cMV_MAIL_ENV, .F. )

//-----------------------------------------------------------------------
// Buscar todas as alçadas que estão aguardando aprovação, porém somente 
// interessa os registros que não estão pendende de capa de despesa. 
//-----------------------------------------------------------------------
cQuery := "SELECT CR_FILIAL, "
cQuery += "       CR_NUM, "
cQuery += "       CR_TIPO, "
cQuery += "       CR_USER, "
cQuery += "       CR_APROV, "
cQuery += "       CR_NIVEL, "
cQuery += "       CR_STATUS, "
cQuery += "       CR_TOTAL, "
cQuery += "       CR_EMISSAO, " 
cQuery += "       CR_MAIL_ID, "
cQuery += "       CR_DATALIB, "
cQuery += "       C7_APROV, "
cQuery += "       C7_CONAPRO, "
cQuery += "       CR1.R_E_C_N_O_ "
cQuery += "FROM   "+RETSQLNAME("SCR")+" CR1 "

cQuery += "INNER JOIN "+RETSQLNAME("SC7")+" SC7 ON SC7.D_E_L_E_T_ = ' ' AND SC7.C7_FILIAL = CR1.CR_FILIAL AND SC7.C7_NUM = CR1.CR_NUM  AND SC7.C7_CONAPRO <> 'L' "

cQuery += "WHERE  CR1.CR_FILIAL BETWEEN '  ' AND 'zz' "
cQuery += "       AND CR1.CR_TIPO = 'PC' "
cQuery += "       AND CR1.CR_STATUS = '02' "
cQuery += "       AND CR1.CR_MAIL_ID <> ' ' "
cQuery += "       AND CR1.D_E_L_E_T_ = ' ' "
cQuery += "       AND NOT EXISTS (SELECT CR2.CR_NUM "
cQuery += "                       FROM   "+RETSQLNAME("SCR")+" CR2 "
cQuery += "                       WHERE  CR2.CR_FILIAL = CR1.CR_FILIAL "
cQuery += "                              AND CR2.CR_NUM = CR1.CR_NUM "
cQuery += "                              AND CR2.CR_TIPO = '#2' "
cQuery += "                              AND CR2.CR_STATUS = '02' "
cQuery += "                              AND CR2.CR_DATALIB = ' ' "
cQuery += "                              AND CR2.D_E_L_E_T_ = ' ') "
cQuery += "ORDER  BY CR_USER, "
cQuery += "          CR_FILIAL, "
cQuery += "          CR_NUM "

//Monta link para acessar workflow de aprovacao
//cLink  := GetNewPar('MV_XLINKWF', 'http://192.168.16.10:1804/wf/')
//cLink  += 'emp'+ cEmpAnt +'/'

SC7->(dbSetOrder(1)) //Posiciona SC7 no indice 1

//Executa consulta SQL
if CSFA720SQL(calias, @nRec, cQuery, lExeChange)
	//Guarda dados em array para gerar os html
	(calias)->(dbGoTop())
	while (calias)->(!EoF())
		
		if .Not. SC7->(dbSeek(alltrim((calias)->(CR_FILIAL+CR_NUM))))
			(calias)->(dbSkip())
			Loop
		endif
		
		if (calias)->CR_USER != cUserAnte
			if len(aHeader) > 0
				CSFA720Env(aHeader, aBody, aTYPE_COL, cTITULO_EMAIL, aTITULO_TABELA, aChaveSCR) //Envia email para os aprovadores
				aAdd(aLogArq, {aHeader, aBody})
				aHeader   := {}
				aBody     := {}
				aChaveSCR := {}
			endif
			aAdd(aHeader, (calias)->CR_USER)         	//codigo do usario aprovador
			aAdd(aHeader, iif(empty(cMV_MAIL_ENV), UsrRetMail( (calias)->CR_USER ) + ',' + cEmailCorp, cMV_MAIL_ENV))	//email do usuario aprovador -- UsrRetMail( (calias)->CR_USER )
			aAdd(aHeader, RTrim( UsrFullName( (calias)->CR_USER )))	//nome do usuario aprovador
			aAdd(aHeader, cMSG1+aHeader[3]+cMSG2+cMSG3+cMSG4) 		//Mensagem titulo
			aAdd(aHeader, (calias)->CR_FILIAL)         	//codigo do usario aprovador
		endif
		
		//Pega o nome do fornecedor
		if SC7->(dbSeek(alltrim((calias)->(CR_FILIAL+CR_NUM))))
			//formula do calculo do total
			nTotal := SC7->(C7_TOTAL+C7_FRETE+C7_DESPESA+C7_VALIPI-C7_VLDESC)  
			cVencto := dtoc(SC7->C7_XVENCTO)
			_cUser := StrTran( StrTran( Alltrim( UsrRetName( SC7->C7_USER ) ), '.', ''), '\', '' )
			//Pega nome do fornecedor
			nPos := aScan(aFornec, {|x| x[1]==SC7->C7_FORNECE .and. x[2]==SC7->C7_LOJA})
			if (nPos > 0)
				cNomeFor := aFornec[nPos, 3]
			else
				aAdd(aFornec, GetAdvFVal( 'SA2', { 'A2_COD', 'A2_LOJA', 'A2_NOME'}, xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA), 1 ))
				cNomeFor := padr(aFornec[len(aFornec), 3], 30)
			end if
		else
			(calias)->(dbSkip())
			Loop
		endif
		
		//Monta array aBody
		aAux := {}
		aAdd(aAux, (calias)->CR_NUM)		        //numero do pedido de compra
		aAdd(aAux, cNomeFor)						//nome do fornecedor
		aAdd(aAux, cVencto)
		aAdd(aAux, transform((calias)->CR_TOTAL, '@E 999,999,999.99')) //total do pedido de compra
		//aAdd(aAux, cLink + _cUser + '/' +(calias)->CR_MAIL_ID+ '.htm' )            //link para o email de aprovacao
		aAdd(aBody, aAux) 							//guarda dados do item do email
		
		cUserAnte := (calias)->CR_USER  			//guarda o ultimo usuario processado
		aAdd(aChaveSCR, (calias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL)) //Adiciona chave da SCR ao array
		CSFA720LOG(aChaveSCR[len(aChaveSCR)], 1, 'Carregou array') //Gera log na SCR
		
		(calias)->(dbSkip())
	end
	aAdd(aLogArq, {aHeader, aBody})
	(calias)->(dbCloseArea())
	
	CSFA720Env(aHeader, aBody, aTYPE_COL, cTITULO_EMAIL, aTITULO_TABELA, aChaveSCR) //Envia email para os aprovadores
	
	GeraArqLog(aLogArq)
endif

RESET ENVIRONMENT
Return()

/*/{Protheus.doc} CSFA720Env
Envia email conforme parametros
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aHeader, array, [1] - codigo do usario aprovador; [2] - email do usuario aprovador -- UsrRetMail(); [3] - nome do usuario aprovador; [4] - Mensagem titulo
@param aBody, array, Lista de pedido de compras
@param aTypeCol, array, Tipo de coluna (T - Texto, N - Númerico, A - Link)
@param cTituloEmail, string, Título de email
@param aTabTitulo, array, Mensagem que sera montada no email
@param cCSS, cString, CSS com estilo do email.
@param aChaveSCR, array, Lista de indices de que será usado para gerar log na SCR

@return nulo
/*/
Static Function CSFA720Env(aHeader, aBody, aTypeCol, cTituloEmail, aTabTitulo, aChaveSCR)
	Local nLinha      := 1  //Linha do array
	//Local nColuna     := 1  //Posicao da coluna no array
	//Local aLinha      := {} //Array temporario
	Local cUserAprov  := '' //Usuario aprovador
	Local cEmailAprov := '' //Email do aprovador
	Local cNomeAprov  := '' //Nome do aprovador
	Local cMsgHTML 	  := '' //Mensagem do email
	//Local cClassLin   := '' //Nome da classe que controla linha no html
	
	Local cModWF := ''
	Local oHTML  := NIL
	Local cSaveFile := ''
	Local cMV720HTM := 'MV_720HTM'
	Local cMV610_014 := 'MV_610_014'
	Local cMV_IPSRV  := 'MV_610_IP'
	Local lServerTst := .F.
	Local cAssunto	 := ''
	
	Default cTituloEmail := 'Email enviado pelo Protheus'
	Default aTabTitulo := Array(Len(aBody))
	
	cUserAprov 	:= aHeader[1] //codigo do usario aprovador
	cEmailAprov := aHeader[2] //email do usuario aprovador
	cNomeAprov 	:= aHeader[3] //nome do usuario aprovador
	cMsgHTML 	:= aHeader[4] //Mensagem titulo

	If .NOT. GetMv( cMV720HTM, .T. )
		CriarSX6( cMV720HTM, 'C', 'MODELO HTML UTILIZADO NA NOTIFICAO CSFA720.prw', '\WORKFLOW\EVENTO\CSFA720.HTM' )
	Endif
	
	cMV_IPSRV := GetMv( cMV_IPSRV, .F. )
	
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" )
	
	cMV720HTM := GetMv( cMV720HTM, .F. )
	cMV610_014 := GetMv( cMV610_014, .F. )
		
	cModWF := cMV720HTM
	oHTML := TWFHTML():New( cModWF )

	// Preenche os dados do cabecalho.
	oHTML:ValByName( 'cAprovador', cNomeAprov )

	If oHTML:ExistField( 1, 'cLINK' )
		oHTML:ValByName( 'cLINK', cMV610_014 )
	Endif

	For nLinha := 1 To Len( aBody )
		aAdd( oHTML:ValByName( 'IT.NUM_PC' ) , RTrim( aBody[nLinha,1] ) )
		aAdd( oHTML:ValByName( 'IT.FORNECE') , RTrim( aBody[nLinha,2] ) )
		aAdd( oHTML:ValByName( 'IT.VENCTO' ) , RTrim( aBody[nLinha,3] ) )
		aAdd( oHTML:ValByName( 'IT.TOTAL'  ) , RTrim( aBody[nLinha,4] ) )
	Next nLinha
	
	cSaveFile := CriaTrab( NIL , .F. )
	oHTML:SaveFile( cSaveFile + '.htm' )
	
	Sleep( Randomize( 1, 1500 ) )
	
	cBody := A720LoadFile( cSaveFile + '.htm' )
	
	oHTML:Free()
	oHTML := NIL

	//Rotina de envio de email
	FsSendMail(cEmailAprov, cAssunto + cTituloEmail, cBody)
	
	//Gera log de envio de email
	For nLinha := 1 to len(aChaveSCR)
		CSFA720LOG(aChaveSCR[nLinha], 1, 'Enviou email')
	Next nLinha	

Return()

/*/{Protheus.doc} CSFA720SQL
Cria uma tabela temporaria de uma instrucao em SQL
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param cAlias, string, Alias da tabela temporária
@param nRec, numeric, Quantidade de registros da tabela temporária
@param cQuery, string, Query SQL
@param lExeChange, boolean, Se .T., executa a função ChangeQuery

@return boolean, Se .T., Conseguiu montar tabela temporária
/*/
Static Function CSFA720SQL(cAlias, nRec, cQuery, lExeChange)
Local lRetorno := .F.
Default lExeChange := .T.

//Monta tabela temporaria conforme query pre formatada
If lExeChange
	cQuery := ChangeQuery(cQuery)
EndIf

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAlias, .F., .T.)

Count To nRec

//Verifica se ha dados na tabela temporaria
If nRec > 0
	lRetorno := .T.
Else
	ConsoleLog('MontaSQL: sql vazio', cQuery, 'CSFA720.PRW')
	(cAlias)->(dbCloseArea())
EndIf

Return(lRetorno)

/*/{Protheus.doc} CSFA720TXT
Faz leitura de arquivo texto
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param cCaminho, string, Caminho do arquivo texto que será lido
@param aLinha, @array, Array que será addicionado linhas do arquivo texto para o array.

@return boolean, Se .T., Conseguiu ler arquivo texto
/*/
Static Function CSFA720TXT(cCaminho, aLinha)
Local lRetorno  := .F.	//Retorno da funcao
Local nHandle   := 0    //Handle de onde com o arquivo texto
Local nLinha    := 0    //Linha do array
Local cLinha    := ''   //Texto da linha do registro

//Verifica se o arquivo texto existe
If File( cCaminho )
	// Abre o arquivo
	nHandle := FT_FUse(cCaminho)
	
	// Se houver erro de abertura abandona processamento
	if nHandle = -1
		return ()
	endif
	
	nTotLinha := FT_FLastRec()
	
	ProcRegua(nTotLinha)
	
	//Posiciona na primeria linha
	FT_FGoTop()
	
	While !FT_FEOF()
		cLinha  := FT_FReadLn() // Retorna a linha corrente
		nLinha++
		
		IncProc("Lendo arquivo texto: " + StrZero(nLinha,6)+"/"+StrZero(nTotLinha,6))
		aAdd(aLinha,	cLinha)
		// Pula para próxima linha
		FT_FSKIP()
		lRetorno  := .T.
	End
	
	// Fecha o Arquivo
	FT_FUSE()
End If
Return(lRetorno)

/*/{Protheus.doc} CSFA720CSS
Monta string com CSS
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@return string, String com CSS
/*/
Static Function CSFA720CSS()
Local cRetorno 	 := '' //Estilo CSS
Local aCSS 		 := {} //Array com linhas do arquivo texto
Local nLinha 	 := 0
if CSFA720TXT('estilo_wf.txt', aCSS)
	for nLinha := 1 to len(aCSS)
		cRetorno += aCSS[nLinha]
	next nLinha
endif
Return(cRetorno)

/*/{Protheus.doc} CSFA720LOG
Cria log na tabela SCR no campo CR_LOG
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param cChave, string, Chave da tabela SCR
@param nOrdem, numeric, Indice da tabela SCR
@param cLog, string, Texto que será incluído na tabela SCR

@return boolean, Se .T., Conseguiu salvar
/*/
Static Function CSFA720LOG(cChave, nOrdem, cLog)
Local lRetorno := .F.
Local cToBreak := CRLF
SCR->(dbSetOrder(nOrdem))
if SCR->(dbSeek(cChave))
	SCR->( RecLock( 'SCR', .F. ) )
	SCR->CR_LOG := AllTrim( SCR->CR_LOG ) + cToBreak + 'DT ' + Dtoc( MsDate() ) + ' HR '+Time() + ' ' + cLog
	SCR->( MsUnlock() )
	lRetorno := .T.
endif
Return(lRetorno)

Static Function GeraArqLog( aLogArq )
	Local nPar1 := ''
	Local nPar2 := ''
	Local aLog  := {}
	Local aHeader := {}
	Local aBody := {}
	Local i 	:= 0
	
	/*
	nPar1 := SubStr( Str( Year(  Date() ), 4, 0 ), 4 ) + StrZero( Month(  Date() ), 2, 0 ) + StrZero( Day(  Date() ), 2, 0 )
	nPar2 := Int( Seconds() )
	cArqIni := 'apcwf' + Str( Val( nPar1 ) + nPar2, 6, 0 ) + '.ini'
	*/
	
	// A  ===> Auditoria
	// PC ===> Pedido de compras
	// WF ===> Workflow
	// Data => AAAA + MM + DD + HHMMSS
	cArqIni := 'apcwf' + Dtos( MsDate() ) + StrTran( Time(), ':', '' ) + '.ini' 
	
	//Gera arquivo de log
	While .T.
		If File( cArqIni )
			Sleep(1000)
			nPar1 := Str( Year( dData ), 4, 0 ) + Month( dData, 2, 0 ) + Day( dData, 2, 0 )
			nPar2 := Int( Seconds() )
			cArqIni := 'apcwfc' + Str( nPar1 + nPar2, 5, 0 ) + '.ini'
		Else
			nHdl := FCreate( cArqIni )
			Exit
		Endif
	End
	
	AAdd( aLog, Replicate( '-', 86 ) )
	AAdd( aLog, '| *** WORKFLOW DE LISTA DE PENDENCIA DE PEDIDO DE COMPRA EM '+Dtoc(Date())+' AS '+Time()+' *** |')
	AAdd( aLog, Replicate( '-', 86 ) )
	AAdd( aLog, 'FILIAL_DOCUMENTO_APROVADOR______________FORNECEDOR______________________EMAIL_ENVIADO______________' )
	//           99     999999    000000-XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXX
	
	/*
	| *** WORKFLOW DE LISTA DE PENDENCIA DE PEDIDO DE COMPRA EM 12/12/12 AS 08:08:08 *** |
	123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	0        1         2         3         4         5         6         7         8         9         10        11
	*/
	
	For i := 1 To Len(aLogArq)
		aHeader := aLogArq[i,1]
		aBody := aLogArq[i,2]
		AEval( aBody, {|e, index| AAdd(aLog, aHeader[5] +'     '+PadR(aBody[index,1], 9)+' '+Upper( PadR(aHeader[3], 22, ' '))+' '+PadR(aBody[index][2], 30) +'  '+aHeader[2]+CRLF ) } )
	Next i
	
	
	AAdd( aLog, Replicate( '-', 86 ) )
	AEval( aLog, {|e| FWrite( nHdl, e + CRLF ) } )
	Sleep(1000)
	FClose( nHdl )
Return

//--------------------------------------------------------------------------
// Rotina | A610AudTrf  | Autor | Robson Goncalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para auditar os logs de transferência.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------
User Function A720APWF()
Local oDlg
Local oBar
Local oThb
//Local TLbx
Local oPnlArq
Local oPnlMaior
Local oPnlButton
Local bSair := {|| oDlg:End() }
Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
Local oFntBox := TFont():New( "Courier New",,-11)
Local aDADOS := {'Selecione um arquivo para visualizar seu conteúdo...'}
Local nList := 0
Local cArq := ''
Local cExt := "Auditoria WF Pendencia Pedido de Compra| apcwf*.ini"

DEFINE MSDIALOG oDlg TITLE 'Auditoria WF Pendência Pedido de Compra' FROM 0,0 TO 360,800 PIXEL

oPnlArq := TPanel():New(0,0,,oDlg,,,,,,16,16,.F.,.F.)
oPnlArq:Align := CONTROL_ALIGN_TOP

@ 04,003 SAY 'Informe o arquivo' SIZE  65,07 PIXEL OF oPnlArq
@ 03,050 MSGET cArq PICTURE '@!' SIZE 190,07 PIXEL OF oPnlArq
@ 04,228 BUTTON '...'            SIZE  10,08 PIXEL OF oPnlArq ACTION cArq := cGetFile(cExt,'Selecione o arquivo',,'SERVIDOR\system',.T.,1)
@ 03,250 BUTTON 'Abrir'          SIZE  40,10 PIXEL OF oPnlArq ACTION A720OpnF( cArq, @oTLbx, @aDADOS )

oPnlMaior := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
oPnlMaior:Align := CONTROL_ALIGN_ALLCLIENT

oPnlButton := TPanel():New(0,0,,oDlg,,,,,,13,13,.F.,.F.)
oPnlButton:Align := CONTROL_ALIGN_BOTTOM

oBar := TBar():New( oPnlButton, 10, 9, .T.,'BOTTOM')

oThb := THButton():New( 1, 1, '&Sair', oBar, bSair , 20, 12, oFnt )
oThb:Align := CONTROL_ALIGN_RIGHT

oTLbx := TListBox():New(0,0,{|u| Iif(PCount()>0,nList:=u,nList)},{},100,46,,oPnlMaior,,,,.T.,,,oFntBox)
oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
oTLbx:SetArray( aDADOS )
oTLbx:SetFocus()

ACTIVATE MSDIALOG oDlg CENTERED
Return

//--------------------------------------------------------------------------
// Rotina | A610OpnF    | Autor | Robson Goncalves       | Data | 22.01.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para abrir e ler o arquivo de log selecionado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A720OpnF( cArq, oTLbx, aDADOS )
	If File( cArq )
		aDADOS := {}
		FT_FUSE( cArq )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			AAdd( aDADOS, FT_FREADLN() )
			FT_FSKIP()
		End
		FT_FUSE()
		oTLbx:SetArray( aDADOS )
		oTLbx:Refresh()
	Else
		MsgAlert( 'Arquivo informado não localizado, verifique...', 'Auditoria de transf. de alçadas' )
	Endif
Return

Static Function ConsoleLog(cMsg, oVar, cNomeFonte)
Default oVar := Nil
Default cNomeFonte := ''
conOut(cNomeFonte )
conOut(cMsg)
varInfo('oVar', oVar)
Return(Nil)

//--------------------------------------------------------------------------
// Rotina | A720LoadFile | Autor | Rafael Beghini      | Data | 20.04.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para ler o arquivo HTML gerado nesta operação.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A720LoadFile( cFile )
	Local cLine := ''
	FT_FUSE( cFile )
	FT_FGOTOP()
	While .NOT. FT_FEOF()
		cLine += FT_FREADLN()
		FT_FSKIP()
	End
	FT_FUSE()
Return( cLine )

User Function TSTCSFA720()
	U_CSFA720({'01', '02'})
Return
