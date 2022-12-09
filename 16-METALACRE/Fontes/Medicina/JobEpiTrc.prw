#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

#DEFINE TRC_MATR	001	// MATRICULA
#DEFINE TRC_NOME	002	// NOME FUNCIONARIO
#DEFINE TRC_EPI		003	// CODIGO EPI
#DEFINE TRC_EPID	004	// DESCRICAO EPI
#DEFINE TRC_EPIU	005	// UNIDADE MEDIDA
#DEFINE TRC_ENTR	006	// DATA DE ENTREGA
#DEFINE TRC_HORA	007	// HORA DE ENTREGA
#DEFINE TRC_QEPI	008	// QUANTIDADE EPI
#DEFINE TRC_CEPI	009	// TEMPO COM O EPI (DIAS)
#DEFINE TRC_PRAZ	010	// PRAZO EM DIAS
#DEFINE TRC_VCTO	011	// VENCIMENTO REAL EPI

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JobEpiTrc   ºAutor  ³ Luiz Alberto   º Data ³  Mai/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job de EPi´s prontos para Troca
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JobEpiTrc()
Local aEmpresa := {{'01','01'}}


If Select("SX2") <> 0
	Processa( {|| RunProc() } )			
Else
	For nI := 1 To Len(aEmpresa)
		RpcSetType( 3 )
		RpcSetEnv( aEmpresa[nI,1], aEmpresa[nI,2] )
	
		Processa( {|| RunProc() } )			
	
		RpcClearEnv()
	Next
Endif
Return
   	 
Static Function RunProc()
Local aArea := GetArea()

ConOut(OemToAnsi("Início Job Epis Trocas " + Dtoc(date()) +" - " + Time()))
	
cQuery :=" SELECT TNF_CODEPI, TNF_MAT, RA_NOME, TNF_FORNEC, TNF_LOJA, TNF_NUMCAP, TNF_DTENTR, TNF_HRENTR, TNF_QTDENT, TN3_DURABI, TN3_DTVENC " 
cQuery +=" FROM " + RetSqlName("TNF") + " TNF, " + RetSqlName("TN3") + " TN3, " + RetSqlName("SRA") + " RA "
cQuery +=" WHERE TNF.TNF_CODEPI = TN3.TN3_CODEPI  "
cQuery +=" AND TNF.TNF_FILIAL = '" + xFilial("TNF") + "' "
cQuery +=" AND TN3.TN3_FILIAL = '" + xFilial("TN3") + "' "
cQuery +=" AND RA.RA_FILIAL = '" + xFilial("SRA") + "' "
cQuery +=" AND TNF.TNF_FORNEC = TN3.TN3_FORNEC " 
cQuery +=" AND TNF.TNF_LOJA = TN3.TN3_LOJA  "
cQuery +=" AND TNF.D_E_L_E_T_ = '' " 
cQuery +=" AND TN3.D_E_L_E_T_ = ''  "
cQuery +=" AND RA.D_E_L_E_T_ = ''  "
cQuery +=" AND TNF.TNF_DTDEVO = ''  "
cQuery +=" AND TNF.TNF_MAT = RA.RA_MAT " 
cQuery +=" ORDER BY RA.RA_NOME  "


cQuery := ChangeQuery(cQuery) 	// otimiza a query de acordo c/ o banco 	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CHKV",.T.,.T.)

TcSetField('CHKV','TNF_DTENTR','D')
TcSetField('CHKV','TN3_DTVENC','D')

aTrocas	:= {}

dbSelectArea("CHKV")
While CHKV->(!Eof())
	SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+CHKV->TNF_MAT))
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+CHKV->TNF_CODEPI))
		
	If !((CHKV->TNF_DTENTR+CHKV->TN3_DURABI) <= (dDataBase+10))	// Data Entrega nos próximos 10 dias
		CHKV->(dbSkip(1));Loop
	Endif
		
	AAdd(aTrocas,{CHKV->TNF_MAT,;
					CHKV->RA_NOME,;
					CHKV->TNF_CODEPI,;
					SB1->B1_DESC,;
					SB1->B1_UM,;
					DtoC(CHKV->TNF_DTENTR),;
					CHKV->TNF_HRENTR,;
					CHKV->TNF_QTDENT,;
					Str((dDataBase-CHKV->TNF_DTENTR),6),;
					Str(((CHKV->TNF_DTENTR+CHKV->TN3_DURABI)-dDataBase),6),;
					DtoC((CHKV->TNF_DTENTR+CHKV->TN3_DURABI)),;
					DtoS((CHKV->TNF_DTENTR+CHKV->TN3_DURABI))})
	
	CHKV->(dbSkip(1))
Enddo
CHKV->(dbCloseArea())

aSort(aTrocas  ,,, { |x,y| y[12] > x[12]} )      

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
cCabecalho += ' colspan="11" rowspan="1"><big><big><img  style="width: 300px; height: 88px;" alt=""  src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"></big></big></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr style="font-weight: bold;" align="center"> '
cCabecalho += '      <td style="background-color: rgb(255, 255, 204);" '
cCabecalho += ' colspan="11" rowspan="1"><big><big>Relat&oacute;rio '
cCabecalho += 'de Funcion&aacute;rios x EPI&acute;s Pr&oacute;ximos '
cCabecalho += 'Vencimento<br> '
cCabecalho += '      <small><small><small>ddatabase '
cCabecalho += '- time()</small></small></small></big></big></td> '
cCabecalho += '    </tr> '
cCabecalho += '    <tr> '
cCabecalho += '      <td '
cCabecalho += ' style="vertical-align: middle; white-space: nowrap; font-weight: bold; background-color: rgb(216, 255, 252); text-align: center;">Matricula</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: left;" '
cCabecalho += ' colspan="1" rowspan="1">Funcion&aacute;rio</td> '
cCabecalho += '      <td '
cCabecalho += ' style="background-color: rgb(204, 255, 255); text-align: center;"><span '
cCabecalho += ' style="font-weight: bold;">C&oacute;d.EPI</span></td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: left;">Descri&ccedil;&atilde;o</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: center;" '
cCabecalho += ' colspan="1" rowspan="1">Un</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: center;">Dt.Entrega</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: center;">Hr.Entrega</td> '
cCabecalho += '      <td '
cCabecalho += ' style="background-color: rgb(204, 255, 255); text-align: right;"><span '
cCabecalho += ' style="font-weight: bold;">Qtde</span></td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: center;">Dia(s) '
cCabecalho += 'Uso</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: center;">Prazo '
cCabecalho += 'Dia(s)</td> '
cCabecalho += '      <td '
cCabecalho += ' style="font-weight: bold; background-color: rgb(216, 255, 252); text-align: center;">Prazo '
cCabecalho += 'Entrega</td> '
cCabecalho += '    </tr> '

cRodape    := '    <tr> '
cRodape	   += '      <td style="background-color: rgb(255, 255, 204);" '
cRodape	   += ' colspan="11" rowspan="1"><small><small><span '
cRodape	   += ' style="font-weight: bold;">Data Envio:</span> '
cRodape	   += 'Hora Envio: Operador:</small></small></td> '
cRodape	   += '    </tr> '
cRodape	   += '  </tbody> '
cRodape	   += '</table> '
cRodape	   += '<br style="font-family: Helvetica,Arial,sans-serif;"> '
cRodape	   += '</body> '
cRodape	   += '</html> '
	
xCabecalho	:= cCabecalho
xRodape     := cRodape
xItens      := ''

cNomRespo := UsrFullName(__cUserId)
cEmaRespo := UsrRetMail(__cUserId)

xCabecalho	:= cCabecalho
xRodape     := cRodape
xItens      := ''

xCabecalho := StrTran(xCabecalho,'ddatabase','<span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
xCabecalho := StrTran(xCabecalho,'time()','<span style="font-weight: bold;">'+Left(Time(),5))+'</span>'
xRodape := StrTran(xRodape,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
xRodape := StrTran(xRodape,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
//xRodape := StrTran(xRodape,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
		
cEmailFinan := GetNewPar("MV_XEMEPI",'anderson.barbosa@metalacre.com.br;lalberto@3lsystems.com.br')
	
For nVenda := 1 To Len(aTrocas)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do cabecalho das NFs                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         	
   		
	xItens     += '    <tr>' 
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_MATR]+'</td>'
	xItens     += '      <td style="text-align: left;">'+	aTrocas[nVenda,TRC_NOME]+'</td>    '
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_EPI]+'</td>'
	xItens     += '      <td style="text-align: left;">'+	aTrocas[nVenda,TRC_EPID]+'</td> '
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_EPIU]+'</td> '
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_ENTR]+'</td> '
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_HORA]+'</td> '
	xItens     += '      <td style="text-align: right;">'+	TransForm(aTrocas[nVenda,TRC_QEPI],'9,999,999')+'</td> '
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_CEPI]+'</td> '
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_PRAZ]+'</td> '
	xItens     += '      <td style="text-align: center;">'+	aTrocas[nVenda,TRC_VCTO]+'</td> '
	xItens     += '    </tr>

Next

If Len(aTrocas) > 0
	WrkAviEpis(cNomRespo,cEmailFinan,'EPI´s Próximos da Troca',xCabecalho+xItens+xRodape)
Endif

RestArea(aArea)
Return


Static Function WrkAviEpis(cNomRespo,cEmaRespo,cAssunto,mCorpo,lContrato)
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

//cPara := 'lalberto@3lsystems.com.br'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
	//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
					Conout('Erro no Envio do Email '+cError+ " " + cPara)	//Atenção
			Endif
	
		Else
			GET MAIL ERROR cError
			Conout('Autenticação '+cError)  //"Autenticacao"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Conout('Erro no Envio do Email '+cError)      //Atencao
	Endif
Return .t.