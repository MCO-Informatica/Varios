#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? JobPedOp   ?Autor  ? Luiz Alberto   ? Data ?  Nov/16   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Job Pedidos de Vendas Com OP?s em Atraso
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function JobPedOp()
Local aEmpresa := {{'01','01'}}
Local aTables  := {'SC5','SC6','SB1','SA1','SES','SX5'}
If Select("SX2") == 0
	For nI := 1 To Len(aEmpresa)
		RpcSetType( 3 )
		RpcSetEnv( aEmpresa[nI,1], aEmpresa[nI,2],,,,, aTables, , , , )   
	
		Processa( {|| RunProc() } )			
	
		RpcClearEnv()
	Next
Else
	Processa( {|| RunProc() } )			
Endif
Return
   	 
Static Function RunProc()
Local aArea := GetArea()

ConOut(OemToAnsi("In?cio Job Pedidos OP?s " + Dtoc(date()) +" - " + Time()))
	
// Envia Email Avisando Pedidos Parados sem OP

nDias := 1
dDiaAtu := DataValida(dDataBase,.f.)
While nDias <= 5 // Tira 5 Dias Uteis
	dDiaAtu := DataValida(++dDiaAtu,.t.)
	nDias++
Enddo

cQuery := 	 " SELECT C6_NUM, C6_CLI, C6_LOJA, C6_PRODUTO, C6_ITEM, C6_ENTREG ENTREGA, C6_QTDVEN, C6_OP, C6_NUMOP "
cQuery +=	 " FROM " + RetSqlName("SC6") + " SC6 "
cQuery +=	 " WHERE C6_BLQ <> 'R'  "
cQuery +=	 " 	AND C6_DATFAT = ''  "
cQuery +=	 " 	AND C6_ENTREG <= '" + DtoS(dDiaAtu) + "' "
cQuery +=	 " 	AND D_E_L_E_T_ = ''  "
cQuery +=	 " 	AND C6_XLACRE <> ''  "
//cQuery +=	 " 	AND C6_LIBERAD = 'S'  "
cQuery +=	 " 	AND C6_TES <> '512'  "
cQuery +=	 " 	AND C6_XSTAND <> '1'  "
cQuery +=	 " 	AND C6_NUMOP = '' "
cQuery +=	 " 	AND C6_FILIAL = '" + xFilial("SC6") + "' "
cQuery +=	 "  ORDER BY C6_NUM, C6_ITEM, C6_ENTREG "

TCQUERY cQuery NEW ALIAS "CHK1"
	
TcSetField('CHK1','ENTREGA','D')
lOk := .f.

IF CHK1->(Eof())
	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	cCabecalho += '<html>
	cCabecalho += '<head>
	cCabecalho += '  <meta content="text/html; charset=ISO-8859-1"
	cCabecalho += ' http-equiv="content-type">
	cCabecalho += '  <title>WorkFlow Metalacre</title>
	cCabecalho += '</head>
	cCabecalho += '<body>
	cCabecalho += '<table
	cCabecalho += ' style="font-family: Helvetica,Arial,sans-serif; width: 100%; text-align: left; margin-left: auto; margin-right: 0px;"
	cCabecalho += ' border="1" cellpadding="2" cellspacing="2">
	cCabecalho += '  <tbody>
	cCabecalho += '    <tr style="font-weight: bold;" align="center">
	cCabecalho += '      <td style="background-color: rgb(255, 255, 255);"
	cCabecalho += ' colspan="1" rowspan="1"><big><big><img
	cCabecalho += ' style="width: 300px; height: 88px;" alt=""
	cCabecalho += ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br>
	cCabecalho += '      </big></big></td>
	cCabecalho += '    </tr>
	cCabecalho += '    <tr style="font-weight: bold;" align="center">
	cCabecalho += '      <td style="background-color: rgb(255, 255, 204);"
	cCabecalho += ' colspan="1" rowspan="1"><big><big>Pedidos
	cCabecalho += 'Sem Abertura de Ordens de Produ&ccedil;&atilde;o</big></big></td>
	cCabecalho += '    </tr>
	cCabecalho += '    <tr align="center">
	cCabecalho += '      <td style="background-color: rgb(102, 255, 255);"
	cCabecalho += ' colspan="1" rowspan="1"><big><big><big>N&atilde;o
	cCabecalho += 'foram localizados Pedidos em Atraso</big></big></big></td>
	
	cRodape    := '        <tr> '
	cRodape    += '       <td style="background-color: rgb(255, 255, 204);" '
	cRodape    += '  colspan="8" rowspan="1"><small><small><span '
	cRodape    += '  style="font-weight: bold;">Data Envio:</span> '
	cRodape    += ' Hora Envio:&nbsp;</small></small></td> '
	cRodape    += '     </tr> '
	cRodape    += '   </tbody> '
	cRodape    += ' </table> '
	cRodape    += ' <br style="font-family: Helvetica,Arial,sans-serif;">  '
	cRodape    += ' </body> '
	cRodape    += ' </html> '
	
	cNomRespo := 'Automatico'//UsrFullName(__cUserId)
	cEmaRespo := 'automatico@metalacre.com.br'//UsrRetMail(__cUserId)
	
	xCabecalho	:= cCabecalho
	xRodape     := cRodape
	xItens      := ''
	
	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
		
	cEmailFinan := GetNewPar("MV_EMAFOP",'mariana.arantes@metalacre.com.br;paulo.junior@metalacre.com.br;lalberto@3lsystems.com.br')
		
	lOk := .T.
Else

	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
	cCabecalho += '<html> '
	cCabecalho += '<head> '
	cCabecalho += '  <meta content="text/html; charset=ISO-8859-1" '
	cCabecalho += ' http-equiv="content-type"> '
	cCabecalho += '  <title>WorkFlow Metalacre</title> '
	cCabecalho += '</head> '
	cCabecalho += '<body> '
	cCabecalho += '<table '
	cCabecalho += ' style="font-family: Helvetica,Arial,sans-serif; width: 100%; text-align: left; margin-left: auto; margin-right: 0px;" '
	cCabecalho += ' border="1" cellpadding="2" cellspacing="2"> '
	cCabecalho += '  <tbody> '
	cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
	cCabecalho += '      <td style="background-color: rgb(255, 255, 255);" '
	cCabecalho += ' colspan="8" rowspan="1"><big><big><img '
	cCabecalho += ' style="width: 300px; height: 88px;" alt="" '
	cCabecalho += ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
	cCabecalho += '      </big></big></td> '
	cCabecalho += '    </tr> '
	cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
	cCabecalho += '      <td style="background-color: rgb(255, 255, 204);" '
	cCabecalho += ' colspan="8" rowspan="1"><big><big>Pedidos '
	cCabecalho += 'Sem Abertura de Ordens de Produ&ccedil;&atilde;o</big></big></td> '
	cCabecalho += '    </tr> '
	cCabecalho += '    <tr> '
	cCabecalho += '      <td '
	cCabecalho += ' style="background-color: rgb(204, 204, 204); font-weight: bold;"><small>No. '
	cCabecalho += 'Pedido</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(192, 192, 192);"><small>Cliente</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="background-color: rgb(204, 204, 204); font-weight: bold;"><small>Emiss&atilde;o</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Item</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Produto</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: left;"><small>Descri&ccedil;&atilde;o</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;"><small>Quantidade</small></td> '
	cCabecalho += '      <td '
	cCabecalho += ' style="background-color: rgb(204, 204, 204); text-align: center;"><small><span '
	cCabecalho += ' style="font-weight: bold;">Data Entrega</span></small></td> '
	cCabecalho += '    </tr>  '
	
	cRodape    := '        <tr> '
	cRodape    += '       <td style="background-color: rgb(255, 255, 204);" '
	cRodape    += '  colspan="8" rowspan="1"><small><small><span '
	cRodape    += '  style="font-weight: bold;">Data Envio:</span> '
	cRodape    += ' Hora Envio:&nbsp;</small></small></td> '
	cRodape    += '     </tr> '
	cRodape    += '   </tbody> '
	cRodape    += ' </table> '
	cRodape    += ' <br style="font-family: Helvetica,Arial,sans-serif;">  '
	cRodape    += ' </body> '
	cRodape    += ' </html> '
	
	cNomRespo := 'Automatico'//UsrFullName(__cUserId)
	cEmaRespo := 'automatico@metalacre.com.br'//UsrRetMail(__cUserId)
	
	xCabecalho	:= cCabecalho
	xRodape     := cRodape
	xItens      := ''
	
	xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
	xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
	xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
		
	cEmailFinan := GetNewPar("MV_EMAFOP",'mariana.arantes@metalacre.com.br;paulo.junior@metalacre.com.br;lalberto@3lsystems.com.br')
		
	lOk := .f.
	
	CHK1->(dbGoTop())
	While CHK1->(!Eof())                 
		lOk := .t.
	
		If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+CHK1->C6_NUM))
			CHK1->(dbSkip(1));Loop
		Endif
		If SC5->C5_TIPO <> 'N'
			CHK1->(dbSkip(1));Loop
		Endif
		If !SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			CHK1->(dbSkip(1));Loop
		Endif
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+CHK1->C6_PRODUTO))
		
		xItens  +=  '        <tr> '
		xItens  +=  '          <td>' + CHK1->C6_NUM + '</td> '
		xItens  +=  '          <td>' + '('+SA1->A1_COD+'/'+SA1->A1_LOJA+') '+ Capital(SA1->A1_NOME) + '</td> '
		xItens  +=  '          <td>' + DtoC(SC5->C5_EMISSAO) + '</td> '
		xItens  +=  '          <td style="text-align: center;">'+CHK1->C6_ITEM+'</td> '
		xItens  +=  '          <td style="text-align: center;">'+CHK1->C6_PRODUTO+'</td> '
		xItens  +=  '          <td style="text-align: left;">'+SB1->B1_DESC+'</td> '
		xItens  +=  '          <td style="text-align: center;">'+TransForm(CHK1->C6_QTDVEN,'@E 9,999,999,999.9')+'</td> '
		xItens  +=  '          <td style="text-align: center;">'+DtoC(CHK1->ENTREGA)+'</td> '
		xItens  +=  '        </tr> '
	
		CHK1->(dbSkip(1))	
	Enddo
Endif
If lOk
	WrkAviOps(cNomRespo,cEmailFinan,'Aviso Falta de Op',xCabecalho+xItens+xRodape)
Endif

CHK1->(dbCloseArea())

Break
RestArea(aArea)
Return


Static Function WrkAviOps(cNomRespo,cEmaRespo,cAssunto,mCorpo,lContrato)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= cEmaRespo
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
DEFAULT lContrato := .f.


	//?????????????????????????????????????????????????????????????????????????????Ŀ
	//?Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense?
	//?que somente ela recebeu aquele email, tornando o email mais personalizado.   ?
	//???????????????????????????????????????????????????????????????????????????????
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
	
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)	
		Else
			lRet := .T.	
	    Endif    
		
		If lRet
			If !lContrato
				SEND MAIL FROM cFrom ;
				TO      	cPara;                  
				SUBJECT 	cAssunto;
				BODY    	mCorpo;
				RESULT lResult
			Else
				SEND MAIL FROM cFrom ;
				TO      	cPara;                  
				SUBJECT 	cAssunto;
				BODY    	mCorpo;
				RESULT lResult
			Endif	
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
					Conout('Erro no Envio do Email '+cError+ " " + cPara)	//Aten??o
			Endif
	
		Else
			GET MAIL ERROR cError
			Conout('Autentica??o '+cError)  //"Autenticacao"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Conout('Erro no Envio do Email '+cError)      //Atencao
	Endif
Return .t.