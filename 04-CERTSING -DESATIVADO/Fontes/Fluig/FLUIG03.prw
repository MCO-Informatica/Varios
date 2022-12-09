#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE 'TbiConn.ch'

#DEFINE cMSG1 'Prezado(a), '
#DEFINE cMSG2 ', '+CRLF+CRLF
#DEFINE cMSG3 'Relacionamos abaixo uma lista de [xx] documento(s) que não foram treinado(s).'+CRLF
#DEFINE cMSG4 'Solicitamos que acesse a Conecta e efetue a(s) leitura(s).'
#DEFINE cMSG6 'Ao finalizar a leitura de cada documento, pressione o botão confirmar leitura.'  
#DEFINE cTITULO_EMAIL 	'Treinamento(s) Pendente(s).'
#DEFINE aTITULO_TABELA 	{'Treinamento'} //Corpo do email - tabela
#DEFINE aTYPE_COL 		{'T'}
#DEFINE aALIGN_COL 		{'left'}
#DEFINE cNOME_FONTE 	'FLUIG03.PRW'
#DEFINE cDB_ORA 		GetNewPar("MV_FLUIGB","ORACLE/FLUIG_PRD")
#DEFINE cSRV_ORA 		GetNewPar("MV_FLUIGT", "10.130.3.133")
#DEFINE nPORTA      	7890
#DEFINE cLINK_FLUIG 	"https://conecta.certisign.com.br/portal/p/Certisign/TreinamentoPage"

/*/{Protheus.doc} CSFA720
Envia lista de aprovação de pedido de compra para os aprovadores que estão com seu pedido pendente.
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aParam, array, Posição 1 - Código da empresa Posição 2 - Código da Filial

@return nulo
/*/
User Function FLUIG03(aParam)
Local aBody		 	:= {}  	//Dados que irao compor a tabela do html
Local aHeader	 	:= {}  	//Dados que irao compor o envio do email
Local aLogArq 	 	:= {}   //Array com log do que foi feito pela rotina
Local calias 	 	:= GetNextalias() //alias resevardo para consulta SQL
Local cEmailCorp 	:= 'bruno.nunes@totvs.com.br' // email usado para teste
Local cMailCopia 	:= 'jgarcia@certisign.com.br' // email usado para teste
Local cMV_MAIL_ENV 	:= 'MV_FLUIG03' //nome do parametro com o email a ser usado com teste, em ambiente de produção deixar vazio.
Local cMV_MAIL_COP 	:= 'MV_FLUIG3C' //nome do parametro com o email a ser usado com teste, em ambiente de produção deixar vazio.
Local cQuery 	 	:= '' 	//Consulta SQL
Local cUserAnte  	:= ''  	//user anterior
Local lRetorno 	 	:= .F. 	//Retorno da funcao - .T. Carregou tabela, .F. - Não carregou tabela
Local lExeChange 	:= .T. 	//Executa o change Query
Local nRec 		 	:= 0   	//Numero Total de Registros da consulta SQL
Local nContaDoc     := 0

Default aParam 	 	:= {'01', '01'}

//configura parametros se estiver vazio
if Len(aParam) == 0
	aAdd(aParam, '01')
	aAdd(aParam, '01')
endif

//configurar ambiente
rpcSetType(3)
PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO 'FIN' 

//Finaliza a rotina caso não consiga apontar para o banco de dados do fluig
if PreparaBD() < 0
	RESET ENVIRONMENT
	return()
endif
            
//Cria parametro e preenche a variavel com o conteudo dele
If .NOT. GetMv( cMV_MAIL_ENV, .T. )
	CriarSX6( cMV_MAIL_ENV, 'C', 'EMAIL QUE SERA USADA PARA ENVIO DE EMAIL TESTE. EM PRODUCAO DEIXAR VAZIO FLUIG03.prw', cEmailCorp )
Endif
cMV_MAIL_ENV := GetMv( cMV_MAIL_ENV, .F. )

//Email do gestor da qualidade em copia
If .NOT. GetMv( cMV_MAIL_COP, .T. )
	CriarSX6( cMV_MAIL_COP, 'C', 'Email que do gestor, deverá ir uma cópia FLUIG03.prw', cMailCopia )
Endif
cMV_MAIL_COP := GetMv( cMV_MAIL_COP, .F. )

cQuery := " SELECT  "+CRLF
cQuery += " DOCUMENTID "+CRLF
cQuery += " , DS_PRINCIPAL_DOCUMENTO DESCRICAO_DOCUMENTO "+CRLF
cQuery += " , NOME "+CRLF
cQuery += " , EMAIL "+CRLF
cQuery += " FROM DOCUMENT  "+CRLF
cQuery += " WHERE  "+CRLF
cQuery += " DATEEXECUTED is null "+CRLF
cQuery += " ORDER BY "+CRLF
cQuery += " NOME, DESCRICAO_DOCUMENTO "+CRLF

//Executa consulta SQL
if ConsultSQL(calias, @nRec, cQuery, lExeChange)
	//Guarda dados em array para gerar os html
	(calias)->(dbGoTop())
	while (calias)->(!EoF())
		if (calias)->NOME != cUserAnte
			if len(aHeader) > 0                                                                      
				aAdd(aHeader, cValToChar(nContaDoc)) //Número de documentos por funcionário.
				EnvEmail(aHeader, aBody, aTYPE_COL, cTITULO_EMAIL, aTITULO_TABELA) 	//Envia email para os aprovadores
				aAdd(aLogArq, {aHeader, aBody})
				aHeader   := {}
				aBody     := {}
				nContaDoc := 0  
			endif
			aAdd(aHeader, capital( alltrim((calias)->NOME) ) )         						//Nome no Fluig
			aAdd(aHeader, iif(empty(cMV_MAIL_ENV), alltrim((calias)->EMAIL)+', '+cMV_MAIL_COP, cMV_MAIL_ENV+', '+cMV_MAIL_COP))	//email no fluig
			aAdd(aHeader, cMSG1+aHeader[1]+cMSG2+cMSG3+cMSG4) 						//Mensagem titulo
		endif
				
		//Monta array aBody
		aAux := {}
		aAdd(aAux, alltrim((calias)->DESCRICAO_DOCUMENTO))	//numero do pedido de compra
		aAdd(aBody, aAux) 							//guarda dados do item do email
		        
		nContaDoc++
		cUserAnte := (calias)->NOME  				//guarda o ultimo usuario processado
		(calias)->(dbSkip())
	end
	aAdd(aLogArq, {aHeader, aBody})
	(calias)->(dbCloseArea())
	                
	if len(aHeader) > 0
		aAdd(aHeader, cValToChar(nContaDoc)) //Número de documentos por funcionário.
		EnvEmail(aHeader, aBody, aTYPE_COL, cTITULO_EMAIL, aTITULO_TABELA) //Envia email para os aprovadores
	endif
	
	GeraArqLog(aLogArq)
endif

RESET ENVIRONMENT
Return()

/*/{Protheus.doc} EnvEmail
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

@return nulo
/*/
Static Function EnvEmail(aHeader, aBody, aTypeCol, cTituloEmail, aTabTitulo)
Local nLinha      := 1  //Linha do array
Local nColuna     := 1  //Posicao da coluna no array
Local aLinha      := {} //Array temporario
Local chtml 	  := '' //Strinf com html
Local cUserAnte   := '' //Usuario da leitura anterior
Local cUserAprov  := '' //Usuario aprovador
Local cEmailAprov := '' //Email do aprovador
Local cNomeAprov  := '' //Nome do aprovador
Local cMsgHTML 	  := '' //Mensagem do email
Local cClassLin   := '' //Nome da classe que controla linha no html

Default cTituloEmail := 'Email enviado pelo Protheus'
Default aTabTitulo := Array(Len(aBody))

cNomeAprov 	:= aHeader[1] //codigo do usario aprovador
cEmailAprov := aHeader[2] //email do usuario aprovador
cMsgHTML 	:= replace(aHeader[3], '[xx]', aHeader[4]) //Mensagem titulo

//Inicia construcao do html  
chtml += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
chtml += '<html>'
chtml += '	<head>'
chtml += '		<meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />'
chtml += '	</head>'
chtml += '<body>'
chtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630">'
chtml += '		<tr>'
chtml += '			<td align="center">'
chtml += '				<table width="627">'
chtml += '					<tr>'
chtml += '						<td style="align="left">'
chtml += '							<em>'
chtml += '								<font color="#F4811D" face="Arial, Helvetica, sans-serif" size="5">'
chtml += '									<strong>'+cTituloEmail+'</strong>'
chtml += '								</font><br />'
chtml += '								<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Qualidade</font>'
chtml += '							</em>'
chtml += '						</td>'
chtml += '						<td align="left">'
chtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
chtml += '						</td>'
chtml += '					</tr>'  
chtml += '					<tr>'
chtml += '						<td colspan="2" >'
chtml += '							<hr style="border-style: solid; border-width: 10px; color: #F4811D">     '
chtml += '						</td>'
chtml += '					</tr>'
chtml += '				</table>'
chtml += '			</td>'
chtml += '		</tr>'
chtml += '		<tr>'
chtml += '			<td style="padding:15px;">'                          
chtml += '				<p><font color="#333333" face="Arial, Helvetica, sans-serif" size="2">'+cMsgHTML+'</font><br /></p>'
chtml += '			</td>'
chtml += '		</tr>'
chtml += '		<tr>'
chtml += '			<td  align="center" style="padding:15px;">'
chtml += '				<table width="627"  border="0" cellpadding="0" cellspacing="0">'
chtml += '					<thead  >'
chtml += '						<tr>'
for nLinha := 1 to len(aTabTitulo)
	chtml += '<th bgcolor="#F4811D" align="'+aALIGN_COL[nLinha]+'" style="padding-left:5px" ><font color="#ffffff face="Arial, Helvetica, sans-serif" size="2">'+alltrim(aTabTitulo[nLinha])+'</font></th>' //Monta cabecalho da tabela
next nLinha           
chtml += '					</tr>'      
chtml += '</thead>'

for nLinha := 1 to len(aBody)
	aLinha := aBody[nLinha]
	
	iif (cClassLin == 'bgcolor=#DCDCDC', cClassLin := 'bgcolor=#FFFFFF', cClassLin := 'bgcolor=#DCDCDC')
	
	chtml += '<tr>'
	for nColuna := 1 to len(aLinha)
		if aTypeCol[nColuna] == 'T'
			chtml += '<td '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><font face="Lucida Console, Monaco, monospace" color="#02519B" size="2">'+alltrim(left(aLinha[nColuna],75))+'</font></div></td>' //insere coluna
		elseif aTypeCol[nColuna] == 'N'
			chtml += '<td '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><font face="Lucida Console, Monaco, monospace" color="#02519B" size="2">'+alltrim(aLinha[nColuna])+'</font></div></td>' //insere coluna
		elseif aTypeCol[nColuna] == 'A'
			chtml += '<td '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><font face="Lucida Console, Monaco, monospace" color="#02519B" size="2"><a href="'+alltrim(aLinha[nColuna])+'">Aprovar / Reprovar</a></font></div></td>'  //insere coluna
		endif
	next nColuna
	chtml += '</tr>'
next nLinha
chtml += '				</table>'
chtml += '			</td>'
chtml += '		</tr>'

chtml += '		<tr>'
chtml += '			<td style="padding:15px;" align="center">'                          
chtml += '				<p><font color="#333333" face="Arial, Helvetica, sans-serif" size="4">Para acessa-los <a href="'+cLINK_FLUIG+'">clique aqui</a></font><br /></p>'
chtml += '			</td>'
chtml += '		</tr>'  
chtml += '		<tr>'
chtml += '			<td style="padding:15px;">'                          
chtml += '				<p><font color="#333333" face="Arial, Helvetica, sans-serif" size="2">'+cMSG6+'</font><br /></p>'
chtml += '			</td>'
chtml += '		</tr>'  


chtml += '					<tr>'
chtml += '						<td >'
chtml += '							<hr style="border-style: solid; border-width: 10px; color: #02519B">     </td>'
chtml += '					</tr>'
chtml += '					<tr>'
chtml += '						<td colspan="2" style="padding:5px" width="0">'
chtml += '							<p align="left">'
chtml += '								<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
chtml += '						</td>'
chtml += '					</tr>'
chtml += '					</table>'
chtml += '	</body>'
chtml += '</html>'

//Rotina de envio de email
FsSendMail(cEmailAprov, cTituloEmail, chtml)

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
Static Function ConsultSQL(cAlias, nRec, cQuery, lExeChange)
Local lRetorno := .F.
Default lExeChange := .T.

//Monta tabela temporaria conforme query pre formatada
If lExeChange
	cQuery := ChangeQuery(cQuery)
EndIf

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAlias, .F., .T.)  

//Verifica se ha dados na tabela temporaria
(cAlias)->(dbGoTop())
if (cAlias)->(!Eof())
	lRetorno := .T.
Else
	ConsoleLog('ConsultSQL: sql vazio', cQuery, cNOME_FONTE)
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

Static Function GeraArqLog(aLogArq)
	local nPar1 := ''
	local nPar2 := ''
	local aLog  := {}
	local aHeader := {}
	local aBody := {}
	nPar1 := dtos(Date())
	nPar2 := cValToChar(Int( Seconds() ))
	cArqIni := 'treiwf_' + nPar1 +'_'+nPar2 +'.ini'
	
	//Gera arquivo de log
	While .T.
		If File( cArqIni )
			Sleep(1000)   
			nPar1 := dtos(Date())
			nPar2 := cValToChar(Int( Seconds() ))
			cArqIni := 'treiwf_' + nPar1 +'_'+nPar2 +'.ini'	
		Else
			nHdl := FCreate( cArqIni )
			Exit
		Endif
	End
	
	           //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	 		   //0        1         2         3         4         5         6         7         8         9         10        11
	aAdd( aLog, '+-------------------------------------------------------------------------------------------------------------+' )
	aAdd( aLog, '| WORKFLOW DE LISTA DE PENDENCIA DE TREINAMENTO  '+Dtoc(Date())+' AS '+Time()+'                               |' )
	aAdd( aLog, '|                                                                                                             |' )
	aAdd( aLog, '| NOME_________________TREINAMENTO_________________________________________EMAIL_ENVIADO_____________________ |' )
	for i := 1 to len(aLogArq)
		aHeader := aLogArq[i][1]
		aBody := aLogArq[i][2]
		AEval( aBody, {|e, index| aAdd(aLog, '| '+PadR(aHeader[1], 20, ' ') +' '+PadR(aBody[index][1], 50, ' ')+'  '+Upper( PadR(aHeader[2], 30, ' '))+' |'+CRLF ) } )
	next i
	aAdd( aLog, '+-------------------------------------------------------------------------------------------------------------+' )
	
	aEval( aLog, {|e| FWrite( nHdl, e + CRLF ) } )
	Sleep(1000)
	FClose( nHdl )
return()

/*/{Protheus.doc} EnvEmail
Rotina para abrir e ler o arquivo de log selecionado.
@type function

@author Robson Goncalves
@since 22/01/2016
@version P11.5

@param aHeader, array, [1] - codigo do usario aprovador; [2] - email do usuario aprovador -- UsrRetMail(); [3] - nome do usuario aprovador; [4] - Mensagem titulo
@param aBody, array, Lista de pedido de compras
@param aTypeCol, array, Tipo de coluna (T - Texto, N - Númerico, A - Link)
@param cTituloEmail, string, Título de email
@param aTabTitulo, array, Mensagem que sera montada no email

@return nulo
/*/
User Function MnFLUIG3()
Local oDlg
Local oBar
Local oThb
Local TLbx
Local oPnlArq
Local oPnlMaior
Local oPnlButton
Local bSair := {|| oDlg:End() }
Local oFnt := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
Local oFntBox := TFont():New( "Courier New",,-11)
Local aDADOS := {'Selecione um arquivo para visualizar seu conteúdo...'}
Local nList := 0
Local cArq := ''
Local cExt := "Auditoria WF Pendencia de Treinamento| treiwf*.ini"

DEFINE MSDIALOG oDlg TITLE 'Auditoria WF Pendência de Treinamento' FROM 0,0 TO 360,800 PIXEL

oPnlArq := TPanel():New(0,0,,oDlg,,,,,,16,16,.F.,.F.)
oPnlArq:Align := CONTROL_ALIGN_TOP

@ 04,003 SAY 'Informe o arquivo' SIZE  65,07 PIXEL OF oPnlArq
@ 03,050 MSGET cArq PICTURE '@!' SIZE 190,07 PIXEL OF oPnlArq
@ 04,228 BUTTON '...'            SIZE  10,08 PIXEL OF oPnlArq ACTION cArq := cGetFile(cExt,'Selecione o arquivo',,'SERVIDOR\system',.T.,1)
@ 03,250 BUTTON 'Abrir'          SIZE  40,10 PIXEL OF oPnlArq ACTION WFpnF( cArq, @oTLbx, @aDADOS )

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

/*/{Protheus.doc} EnvEmail
Rotina para abrir e ler o arquivo de log selecionado.
@type function

@author Robson Goncalves
@since 22/01/2016
@version P11.5

@param aHeader, array, [1] - codigo do usario aprovador; [2] - email do usuario aprovador -- UsrRetMail(); [3] - nome do usuario aprovador; [4] - Mensagem titulo
@param aBody, array, Lista de pedido de compras
@param aTypeCol, array, Tipo de coluna (T - Texto, N - Númerico, A - Link)
@param cTituloEmail, string, Título de email
@param aTabTitulo, array, Mensagem que sera montada no email

@return nulo
/*/
Static Function WFpnF( cArq, oTLbx, aDADOS )
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
		MsgAlert( 'Arquivo informado não localizado, verifique...', 'Auditoria de treinamento' )
	Endif
Return
               
/*/{Protheus.doc} EnvEmail
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

@return nulo
/*/
Static Function ConsoleLog(cMsg, oVar, cNomeFonte)
Default oVar := Nil
Default cNomeFonte := ''
conOut(cNomeFonte )
conOut(cMsg)
varInfo('oVar', oVar)
Return(Nil)


Static Function PreparaBD()
Local nHndOra := 0

//Faço Conexão com o banco do Fluig.
TCConType("TCPIP")
nHndOra := TcLink(cDB_ORA, cSRV_ORA, nPORTA)

If nHndOra < 0
	ConsoleLog("Erro ("+str(nHndOra,4)+") ao conectar com "+cDB_ORA+" em "+cSRV_ORA, nHndOra, cNOME_FONTE)
Endif

Return(nHndOra)