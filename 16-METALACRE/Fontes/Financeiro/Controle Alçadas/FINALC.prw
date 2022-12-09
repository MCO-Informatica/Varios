#Include "RWMAKE.CH"      
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa º FINALC º Autor º Luiz Alberto       º Data º  MAR/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Funcao   º Cria alçadas do financeiro       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      º Personalizacao Metalacre                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FINALC()
Local _aAreaSE2	:= SE2->(GetArea())
Local _aAreaSED	:= SED->(GetArea())
Local _aAreaSA2	:= SA2->(GetArea())
Local cChave	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)	// Chave Busca
Local nTamanho  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]
Local dEmiSC	:= SE2->E2_EMISSAO
Local lEmail	:= GetNewPar("MV_EMALCF",.t.)	// Parametro que identifica se envia ou não email aos aprovadores de alçada financeiro.

// Limpa o Cadastro de Controle de Alçadas Para Regravação Caso Já Exista

If Empty(SE2->E2_BAIXA)	// Apenas Titulos Nao Baixados Poderão Ser Reaprovados
	If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+PadR(cChave,nTamanho)))
		While SCR->(!Eof()) .And. AllTrim(SCR->CR_NUM) == AllTrim(PadR(cChave,nTamanho)) .And. SCR->CR_FILIAL == xFilial("SCR")
			If SCR->CR_TIPO == 'PG'
				If RecLock("SCR",.f.)
					SCR->(dbDelete())
					SCR->(MSUnlock())
				Endif
			Endif
			
			SCR->(dbSkip(1))
		Enddo
	Endif
	
	cEmail := ''
	
	lRegras := .t.
	If lRegras
		nTxMoeda := 1         
		nMoeCom := 1            
		cMoeCom := Str(nMoeCom,1)
		If SM2->(dbSetOrder(1), dbSeek(dEmiSC))
			nTxMoeda := &("SM2->M2_MOEDA"+cMoeCom)
		EndIf
		
		cGrupFin := SE2->E2_XAPROV	// Grupo Financeiro
	
		// Inicia a Montagem do Controle de Alçadas com Base no Grupo de Aprovação
		
		If SAL->(dbSetOrder(2) , dbSeek(xFilial("SAL")+cGrupFin))
			nContador := 0	// Efetua contagem de Aprovadores para que eu Possa Identificar qual Status Sera Gravado
			While SAL->(!Eof()) .And. SAL->AL_COD == cGrupFin
			
				If RecLock("SCR",.t.)
					SCR->CR_FILIAL  := xFilial("SCR")
					SCR->CR_NUM		:= cChave
					SCR->CR_NIVEL	:= SAL->AL_NIVEL
					SCR->CR_USER	:= SAL->AL_USER
					SCR->CR_APROV	:= cGrupFin
					SCR->CR_TIPO	:= 'PG'
					SCR->CR_EMISSAO := SE2->E2_EMISSAO
					SCR->CR_MOEDA	:= nMoeCom
					SCR->CR_TXMOEDA := nTxMoeda
					SCR->CR_STATUS  := '02'
					SCR->CR_TOTAL	:= SE2->E2_VALOR
					SCR->(msUnlock())
				Endif
				
				cEmail += AllTrim(UsrRetMail(SAL->AL_USER))+';'
	
				SAL->(dbSkip(1))
				nContador++	// Efetua contagem de Aprovadores para que eu Possa Identificar qual Status Sera Gravado
			Enddo
			
			// Identificacao do menor nivel de Aprovadores
		
			_cNivel := 'ZZ'
			
		    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+PadR(cChave,TamSX3("CR_NUM")[1])))
				While SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + PadR(cChave,TamSX3("CR_NUM")[1]) .And. SCR->(!Eof())
				
					If SCR->CR_NIVEL < _cNivel	// Se o Nivel for menor então atualiza variavel _cNivel
						_cNivel := SCR->CR_NIVEL
					Endif
		
					SCR->(DbSkip(1))
				Enddo
		    Endif
			
		
			If nContador > 1 // Existem Mais de Um Aprovador para a Solicitação em Questão o Status sera alterado para 01
			    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+PadR(cChave,TamSX3("CR_NUM")[1])))
					While SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + PadR(cChave,TamSX3("CR_NUM")[1]) .And. SCR->(!Eof())
							
						// Se Houver Mais Aprovadores com o Mesmo Nivel e Não Tiverem Liberado a SC Ainda
						// Então Automaticamente já Libera Todos
		
						If SCR->CR_NIVEL <> _cNivel					
							If RecLock("SCR",.f.)
								SCR->CR_STATUS  := "01"
								SCR->(MsUnlock())
							Endif
						Endif
						
						SCR->(DbSkip(1))
					Enddo
			    Endif
			Endif
		Endif
		
		// Envia Email aos Aprovadores.
		
		If lEmail .And. !Empty(cEmail)
			cEmail := Left(AllTrim(cEmail),Len(AllTrim(cEmail))-1)
			EnvMail(cEmail)
		Endif
	
	//	MsgInfo("Regras de Aprovação Geradas com Sucesso para o Titulo - " + SE2->E2_NUM, 'Requer Aprovação')
	Endif
Endif	
RestArea(_aAreaSE2)
RestArea(_aAreaSED)
RestArea(_aAreaSA2)
Return .T.





Static Function EnvMail(cPara)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cAssunto	:= 'Alçada Financeiro '
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local aAnexos		:= {}
Local cEmailTo := cPara						// E-mail de destino
Local cEmailBcc:= ""							// E-mail de copia
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso

// Posiciona no fornecedor do titulo recem criado

SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

	//cEmailTo := GetNewPar("MV_EMALCE",'lalberto@3lsystems.com.br')	// Parametro que identifica se envia ou não email aos aprovadores de alçada financeiro.

	
	mCorpo	:= '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">' 
	mCorpo	+= '<html> '
	mCorpo	+= '<head> '
	mCorpo	+= '  <meta content="text/html; charset=ISO-8859-1" '
	mCorpo	+= ' http-equiv="content-type"> '
	mCorpo	+= '  <title>WorkFlow Metalacre</title> '
	mCorpo	+= '</head> '
	mCorpo	+= '<body> '
	mCorpo	+= '<table '
	mCorpo	+= ' style="font-family: Helvetica,Arial,sans-serif; text-align: left; width: 1151px; height: 323px;" '
	mCorpo	+= ' border="1" cellpadding="2" cellspacing="2"> '
	mCorpo	+= '  <tbody> '
	mCorpo	+= '    <tr style="font-weight: bold;" align="center"> '
	mCorpo	+= '      <td style="background-color: rgb(255, 255, 255);" '
	mCorpo	+= ' colspan="4" rowspan="1"><big><big><img '
	mCorpo	+= ' style="width: 300px; height: 88px;" alt="" '
	mCorpo	+= ' src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
	mCorpo	+= '      </big></big></td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '    <tr style="font-weight: bold;" align="center"> '
	mCorpo	+= '      <td style="background-color: rgb(255, 255, 204);" '
	mCorpo	+= ' colspan="4" rowspan="1"> EMPRESA: ' + SM0->M0_CODIGO + ' - ' + SM0->M0_NOMECOM + '</td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '    <tr style="font-weight: bold;" align="center"> '
	mCorpo	+= '      <td colspan="4" rowspan="1"> '
	mCorpo	+= '      <p class="MsoNormal" style=""><span '
	mCorpo	+= ' style="font-size: 13.5pt; font-family: &quot;Arial&quot;,&quot;sans-serif&quot;; color: black;">Titulos '
	mCorpo	+= 'lan&ccedil;ados manualmente pelo financeiro aguardando '
	mCorpo	+= 'libera&ccedil;&atilde;o para futuro pagamento.</span><o:p></o:p></p> '
	mCorpo	+= '      </td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '    <tr> '
	mCorpo	+= '      <td><small>Fornecedor: (' + SA2->A2_COD+'/'+SA2->A2_LOJA+') - '+Capital(SA2->A2_NOME)+ '</small></td> '
	mCorpo	+= '      <td><small>Contato: ' + SA2->A2_CONTATO + '</small></td> '
	mCorpo	+= '      <td colspan="1" rowspan="1"><small>Fone: ' + SA2->A2_DDD + ' ' + SA2->A2_TEL +  '</small></td> '
	mCorpo	+= '      <td><small>Email: ' + SA2->A2_EMAIL + ' </small></td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '    <tr style="font-weight: bold;" align="center"> '
	mCorpo	+= '      <td style="background-color: rgb(255, 255, 204);" '
	mCorpo	+= ' colspan="4" rowspan="1"><big>Hist&oacute;rico '
	mCorpo	+= 'Financeiro</big></td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '    <tr> '
	mCorpo	+= '      <td '
	mCorpo	+= ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Titulo '
	mCorpo	+= 'No.</td> '
	mCorpo	+= '      <td '
	mCorpo	+= ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Emiss&atilde;o</td>  '
	mCorpo	+= '      <td '
	mCorpo	+= ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: center;">Vencimento</td> '
	mCorpo	+= '      <td '
	mCorpo	+= ' style="font-weight: bold; background-color: rgb(204, 204, 204); text-align: right;">Valor '
	mCorpo	+= 'Titulo</td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '    <tr> '
	mCorpo	+= '      <td>' + M->E2_PREFIXO + ' ' + M->E2_NUM + ' ' + M->E2_PARCELA + '</td> '
	mCorpo	+= '      <td>' + DtoC(M->E2_EMISSAO) + ' </td> '
	mCorpo	+= '      <td>' + DtoC(M->E2_VENCREA) + ' </td> '
	mCorpo	+= '      <td style="text-align: right;">' + TransForm(M->E2_VALOR,'@E 9,999,999,999.99') + ' </td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '    <tr> '
	mCorpo	+= '      <td style="background-color: rgb(255, 255, 204);" '
	mCorpo	+= ' colspan="4" rowspan="1"><small><small><span '
	mCorpo	+= ' style="font-weight: bold;">Data Envio: ' + DtoC(dDataBase) + '</span> '
	mCorpo	+= 'Hora Envio: ' + Time() + '<br> '
	mCorpo	+= '      </small></small> '
	mCorpo	+= '      <div style="text-align: center;"><small '
	mCorpo	+= ' style="font-weight: bold;"><small>Envio '
	mCorpo	+= 'de Email Efetuado Autom&aacute;ticamente por nosso sistema Interno, '
	mCorpo	+= 'favor n&atilde;o responder</small></small></div> '
	mCorpo	+= '      </td> '
	mCorpo	+= '    </tr> '
	mCorpo	+= '  </tbody> '
	mCorpo	+= '</table> '
	mCorpo	+= '<br style="font-family: Helvetica,Arial,sans-serif;"> '
	mCorpo	+= '</body> '
	mCorpo	+= '</html> '

	_cAnexo	:= ''


	For nTenta := 1 To 5
	
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
				SEND MAIL FROM cFrom ;
				TO      	cPara;
				SUBJECT 	cAssunto;
				BODY    	mCorpo;
				RESULT lResult
		
				If !lResult
					//Erro no envio do email
					GET MAIL ERROR cError
						Help(" ",1,'Erro no Envio do Email',,cError+ " " + cPara,4,5)	//Atenção
					Loop
				Endif
		 		nTenta := 10	// Em Caso de Sucesso sai do Loop
		 		Loop
			Else
				GET MAIL ERROR cError
				Help(" ",1,'Autenticação',,cError,4,5)  //"Autenticacao"
				MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') 		 //"Erro de autenticação","Verifique a conta e a senha para envio"
			Endif
				
			DISCONNECT SMTP SERVER
			
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
		Endif
	Next
Return .t.

