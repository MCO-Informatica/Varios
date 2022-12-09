#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#Include 'FWMVCDEF.ch'

//===========================================================================
// Programa.......: RWOKF01
// Autor..........: Anderson Goncalves
// Data...........: 19/03/21
// Descricao......: Workflow para disparo de email no momento da inclus„o do
//                  produto
// Uso............: Verquimica
//===========================================================================

User Function RWOKF01()

//===========================================================================
//Variaveis da Rotina
//===========================================================================
// Patricia = compras@verquimica.com.br; 
// laboratorio = laboratorio@verquimica.com.br; auxiliarsgi@verquimica.com.br
// Fiscal = assistenteadm@verquimica.com.br; 
Local cDirHttp      := '\workflow\aprovacoes'
Local cAssunto      := "Liberacao do Produto "+SB1->B1_COD
Local cUrlWF 	    := "http://192.168.1.16:8098/wf/"
Local cHtml         := ""
Local cHtmlAction   := "WFHTTPRET.APL" 
Local cUserFis      := Getmv("ES_USRFIS",,"000151")
Local cNome         := UsrFullName(cUserFis)
Local cEmail        := "assistenteadm@verquimica.com.br" //UsrRetMail(cUserFis)
Local lRet          := .T.
Local cMailID       := ""
Local cOptOrigem	:= ""
Local cOptGrupo		:= ""
Local cOptTrib		:= ""
Local cOptCta		:= ""
Local lPri			:= .T.
Local lAchou		:= .F.

Private oProcess    := Nil
Private oHtml       := Nil

//==================================================
// Monta o combobox de origem do produto
//==================================================
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5")+"S0"))
While SX5->(!EOF()) .and. AllTrim(SX5->X5_TABELA) == "S0"

	If lPri
		If AllTrim(SX5->X5_CHAVE) == AllTrim(SB1->B1_ORIGEM) 
			cOptOrigem := '<option value='+AllTrim(SX5->X5_CHAVE)+' selected="selected">'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
			cOptOrigem := '<option value='+AllTrim(SX5->X5_CHAVE)+'>'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
		Endif	
		lPri := .F.
	Else
		If AllTrim(SX5->X5_CHAVE) == AllTrim(SB1->B1_ORIGEM) 
			cOptOrigem += '<option value='+AllTrim(SX5->X5_CHAVE)+' selected="selected">'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
		 	cOptOrigem += '<option value='+AllTrim(SX5->X5_CHAVE)+'>'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
		EndIf
	EndIf

	SX5->(dbSkip())
Enddo

If !lAchou
	cOptOrigem := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)+cOptOrigem
Endif

//==================================================
// Monta o combobox do grupo de tributaÁ„o
//==================================================
lAchou := .F.
lPri := .T.
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5")+"21"))
While SX5->(!EOF()) .and. AllTrim(SX5->X5_TABELA) == "21"

	If lPri
		If AllTrim(SX5->X5_CHAVE) == AllTrim(SB1->B1_GRTRIB) 
			cOptTrib := '<option value='+AllTrim(SX5->X5_CHAVE)+' selected="selected">'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
			cOptTrib := '<option value='+AllTrim(SX5->X5_CHAVE)+'>'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
		Endif	
		lPri := .F.
	Else
		If AllTrim(SX5->X5_CHAVE) == AllTrim(SB1->B1_GRTRIB) 
			cOptTrib += '<option value='+AllTrim(SX5->X5_CHAVE)+' selected="selected">'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
		 	cOptTrib += '<option value='+AllTrim(SX5->X5_CHAVE)+'>'+AllTrim(SX5->X5_CHAVE)+" - "+U_RetAceWeb(AllTrim(SX5->X5_DESCRI))+'</option>'+Chr(13)+Chr(10)
		EndIf
	EndIf

	SX5->(dbSkip())
Enddo

If !lAchou
	cOptTrib := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)+cOptTrib
Endif

//==================================================
// Monta o combobox de grupo do produto
//==================================================
lAchou := .F.
lPri := .T.
dbSelectArea("SBM")
SBM->(dbSetOrder(1))
SBM->(dbGoTop())
While SBM->(!EOF())

	If lPri
		If AllTrim(SBM->BM_GRUPO) == AllTrim(SB1->B1_GRUPO) 
			cOptGrupo := '<option value='+AllTrim(SBM->BM_GRUPO)+' selected="selected">'+AllTrim(SBM->BM_GRUPO)+" - "+U_RetAceWeb(AllTrim(SBM->BM_DESC))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
			cOptGrupo := '<option value='+AllTrim(SBM->BM_GRUPO)+'>'+AllTrim(SBM->BM_GRUPO)+" - "+U_RetAceWeb(AllTrim(SBM->BM_DESC))+'</option>'+Chr(13)+Chr(10)
		Endif	
		lPri := .F.
	Else
		If AllTrim(SBM->BM_GRUPO) == AllTrim(SB1->B1_GRUPO) 
			cOptGrupo += '<option value='+AllTrim(SBM->BM_GRUPO)+' selected="selected">'+AllTrim(SBM->BM_GRUPO)+" - "+U_RetAceWeb(AllTrim(SBM->BM_DESC))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
		 	cOptGrupo += '<option value='+AllTrim(SBM->BM_GRUPO)+'>'+AllTrim(SBM->BM_GRUPO)+" - "+U_RetAceWeb(AllTrim(SBM->BM_DESC))+'</option>'+Chr(13)+Chr(10)
		EndIf
	EndIf

	SBM->(dbSkip())
Enddo

If !lAchou
	cOptGrupo := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)+cOptGrupo
Endif

//==================================================
// Monta o combobox de Conta Contabil
//==================================================
lAchou := .F.
lPri := .T.
dbSelectArea("CT1")
CT1->(dbSetOrder(1))
CT1->(dbGoTop())
While CT1->(!EOF())

	If CT1->CT1_CLASSE == "1"
		CT1->(dbSkip())
		Loop
	EndIf

	If lPri
		If AllTrim(CT1->CT1_CONTA) == AllTrim(SB1->B1_CONTA) 
			cOptCta := '<option value='+AllTrim(CT1->CT1_CONTA)+' selected="selected">'+AllTrim(CT1->CT1_CONTA)+" - "+U_RetAceWeb(AllTrim(CT1->CT1_DESC01))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
			cOptCTa := '<option value='+AllTrim(CT1->CT1_CONTA)+'>'+AllTrim(CT1->CT1_CONTA)+" - "+U_RetAceWeb(AllTrim(CT1->CT1_DESC01))+'</option>'+Chr(13)+Chr(10)
		Endif	
		lPri := .F.
	Else
		If AllTrim(CT1->CT1_CONTA) == AllTrim(SB1->B1_CONTA) 
			cOptCta += '<option value='+AllTrim(CT1->CT1_CONTA)+' selected="selected">'+AllTrim(CT1->CT1_CONTA)+" - "+U_RetAceWeb(AllTrim(CT1->CT1_DESC01))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
		 	cOptCta += '<option value='+AllTrim(CT1->CT1_CONTA)+'>'+AllTrim(CT1->CT1_CONTA)+" - "+U_RetAceWeb(AllTrim(CT1->CT1_DESC01))+'</option>'+Chr(13)+Chr(10)
		EndIf
	EndIf

	CT1->(dbSkip())
Enddo

If !lAchou
	cOptCta := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)+cOptCta
Endif

dbSelectArea("SB5")
SB5->(dbSetOrder(1))
SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD ))

//===========================================================================
// Preenchimento do HTML
//===========================================================================
oProcess:= TWFProcess():New( "WF0001", "LibProduto")
oProcess:NewTask("Liberacao de produto - fiscal","\workflow\html\wf_produto_fis.html")
oProcess:cSubject 		:= cAssunto
oProcess:cTo      		:= "000000"
oProcess:UserSiga 		:= "000000"
oProcess:bReturn  		:= 'U_RETWF01A()' 
oProcess:fDesc 			:= cAssunto
oHtml   := oProcess:oHtml  

//===========================================================================
// Monta o cabecalho da solicitacao
//===========================================================================
oHtml:ValByName('codigo',       SB1->B1_COD                                         	)
oHtml:ValByName('descricao',    SB1->B1_DESC                                        	)
oHtml:ValByName('tipo',         SB1->B1_TIPO                                        	)
oHtml:ValByName('ncm',          SB1->B1_POSIPI                                      	)
oHtml:ValByName('armazem',      SB1->B1_LOCPAD                                      	)
oHtml:ValByName('um',           SB1->B1_UM                                          	)
oHtml:ValByName('segun',        SB1->B1_SEGUM                                       	)
oHtml:ValByName('quantbase',    TransForm(SB1->B1_QB,PesqPict("SB1","B1_QB"))       	)
oHtml:ValByName('cClasfis',      SB1->B1_CLASFIS									   	)
oHtml:ValByName('grtrib',       cOptTrib     									    	)

oHtml:ValByName('nome',         SB5->B5_CEME                                        	)
oHtml:ValByName('cOpt',         cOptOrigem		                                      	)
oHtml:ValByName('cGrupo',       cOptGrupo		                                       	)
oHtml:ValByName('fator',        TransForm(SB1->B1_CONV,PesqPict("SB1","B1_CONV"))   	)
oHtml:ValByName('cTpConv',      If(SB1->B1_TIPCONV=="D","Divide","Multiplica")   	    )
oHtml:ValByName('ctaContabil',  cOptCta                                			)
oHtml:ValByName('aliipi',       TransForm(SB1->B1_IPI,PesqPict("SB1","B1_IPI"))     	)
oHtml:ValByName('icmsvq',       TransForm(SB1->B1_VQ_ICMS,PesqPict("SB1","B1_VQ_ICMS"))	)

oHtml:ValByName( "cHtmlAction" 	,	cHtmlAction		) 
oProcess:NewVersion(.T.)
oProcess:nEncodeMime := 0
oProcess:SetHtmlBody(.T.) 
cMailID := oProcess:Start(cDirHttp)+".htm" 
oProcess:free()
cUrlWF += cMailID

//===================================================
// Mensagem a ser enviada
//===================================================
cHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+Chr(13)+Chr(10)
cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">'+Chr(13)+Chr(10)
cHtml += '<head>'+Chr(13)+Chr(10)
cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+Chr(13)+Chr(10)
cHtml += '<title>Untitled Document</title>'+Chr(13)+Chr(10)
cHtml += '<style type="text/css">'+Chr(13)+Chr(10)
cHtml += '<!--'+Chr(13)+Chr(10)
cHtml += '.style1 {'+Chr(13)+Chr(10)
cHtml += '	font-family: Verdana, Arial, Helvetica, sans-serif;'+Chr(13)+Chr(10)
cHtml += '	font-size: 12px;'+Chr(13)+Chr(10)
cHtml += '}'+Chr(13)+Chr(10)
cHtml += '-->'+Chr(13)+Chr(10)
cHtml += '</style>'+Chr(13)+Chr(10)
cHtml += '</head>'+Chr(13)+Chr(10)
cHtml += '<body>'+Chr(13)+Chr(10)
cHtml += '<table width="704" border="0">'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td><img src="http://agmsystem.com.br/img/logo_verquimica.png" width="200" height="99" /></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td><p><span class="style1">Prezado (a) Sr. (a) '+Capital(cNome)+', no link abaixo, contem informa&ccedil;&otilde;es referente a inclus&atilde;o do produto '+AllTrim(SB1->B1_COD)+', pedimos a confer&ecirc;ncia e inser&ccedil;&atilde;o de dados para a libera&ccedil;&atilde;o do mesmo.</span></p>'+Chr(13)+Chr(10)
cHtml += '      <p><span class="style1"><br />'+Chr(13)+Chr(10)
cHtml += '        Atenciosamente</span></p>'+Chr(13)+Chr(10)
cHtml += '      <p class="style1">Clique <a href="'+cUrlWF+'">aqui</a> para abertura do formul&aacute;rio</p>'+Chr(13)+Chr(10)
cHtml += '      <p><span class="style1">        Verquimica - Workflow By Protheus</span><br />'+Chr(13)+Chr(10)
cHtml += '      </p></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td>&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '</table>'+Chr(13)+Chr(10)
cHtml += '</body>'+Chr(13)+Chr(10)
cHtml += '</html>'+Chr(13)+Chr(10)

//==================================================
// Disparo do email
//==================================================
lRet := U_SndEmail(	,;              //Server SMTP
					,;              //Nome da Conta                                      
					,;              // Usuario
					,;              // Senha
					,;              // Porta
					cAssunto,;      // Assunto
					cEmail,;        // Desinatario
					cHtml,;         // Texto em HTML
					{},;            // Anexos
					.F.,;           // Confirmacao de leitura
					.T.,;           // Recebe copia:
					.F.,;           // È JOB?
					"peterson@verquimica.com.br")             // Email de quem receber· a copia  

//=========================================
// Grava a data de cadastro do produto
//=========================================
If SB1->(FieldPos("B1_XDTCAD")) > 0
	RecLock("SB1",.F.)
	SB1->B1_XDTCAD	:= dDataBase
	SB1->(msUnlock())
EndIf


If lRet
    msgInfo("Email enviado com sucesso","RWORKF01")
EndIf

Return Nil

//===========================================================================
// Programa.......: RETWF01A
// Autor..........: Anderson Goncalves
// Data...........: 19/03/21
// Descricao......: Workflow para disparo de email no momento da inclus√£o do
//                  produto
// Uso............: Verquimica
//===========================================================================

User Function RETWF01A(oProcess)

//===============================================
// Variaveis da Rotina
//===============================================
Local lAchou		:= .F.
Local lPri			:= .T.
Local cOptCq		:= ""
Local cOptPf		:= ""
Local cOptPc		:= ""
Local cOptEx		:= ""
Local cOptOn		:= ""

Local cDirHttp      := '\workflow\aprovacoes'
Local cAssunto      := "Liberacao do Produto "+SB1->B1_COD
Local cUrlWF 	    := "http://192.168.1.16:8098/wf/"
Local cHtml         := ""
Local cHtmlAction   := "WFHTTPRET.APL" 
Local cUserQua      := Getmv("ES_USRQUA",,"000012")
Local cNome         := UsrFullName(cUserQua)
Local cEmail        := "sgi@verquimica.com.br"

Conout("Processo recebido de retorno!")

//===============================================
// Gravacao dos dados
//===============================================
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+oProcess:oHtml:RetByName("codigo")))

	RecLock("SB1",.F.)
	SB1->B1_TIPO 	:= oProcess:oHtml:ValByName('tipo')
	SB1->B1_POSIPI	:= Replace(oProcess:oHtml:ValByName('ncm'),".","")         
	SB1->B1_LOCPAD	:= oProcess:oHtml:ValByName('armazem')     
	SB1->B1_UM		:= oProcess:oHtml:ValByName('um')          
	SB1->B1_SEGUM	:= oProcess:oHtml:ValByName('segun')       
	SB1->B1_QB		:= Val(Replace(oProcess:oHtml:ValByName('quantbase') ,",","."))
	SB1->B1_CLASFIS	:= oProcess:oHtml:ValByName('cClasfis')     
	SB1->B1_GRTRIB	:= oProcess:oHtml:ValByName('grtrib')      

	SB1->B1_ORIGEM	:= oProcess:oHtml:ValByName('cOpt')      
	SB1->B1_GRUPO	:= oProcess:oHtml:ValByName('cGrupo')       
	SB1->B1_CONV	:= Val(Replace(oProcess:oHtml:ValByName('fator') ,",","."))
	SB1->B1_TIPCONV	:= oProcess:oHtml:ValByName('cTpConv')      
	SB1->B1_CONTA	:= oProcess:oHtml:ValByName('ctaContabil')        
	SB1->B1_IPI		:= Val(Replace(oProcess:oHtml:ValByName('aliipi') ,",","."))
	SB1->B1_VQ_ICMS	:= Val(Replace(oProcess:oHtml:ValByName('icmsvq') ,",","."))
	SB1->(msUnlock())
EndIf

dbSelectArea("SB5")
SB5->(dbSetOrder(1))
If SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
	RecLock("SB5",.F.)
	SB5->B5_CEME	:= oProcess:oHtml:RetByName("nome")
	SB5->(msUnlock())
EndIf

//==================================================
// Monta o combobox da policia Federal
//==================================================
If Empty(SB5->B5_PRODPF)
	cOptPf := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)
	cOptPf += '<option value=S >S - Sim</option>'+Chr(13)+Chr(10)
	cOptPf += '<option value=N >N - Nao</option>'+Chr(13)+Chr(10)
ElseIf SB5->B5_PRODPF == "S"
	cOptPf := '<option value=S selected="selected">S - Sim</option>'+Chr(13)+Chr(10)
	cOptPf += '<option value=N >N - Nao</option>'+Chr(13)+Chr(10)
ElseIf SB5->B5_PRODPF == "N"
	cOptPf := '<option value=S >S - Sim</option>'+Chr(13)+Chr(10)
	cOptPf += '<option value=N selected="selected">N - Nao</option>'+Chr(13)+Chr(10)
EndIf

//==================================================
// Monta o combobox de controle Policia Civil
//==================================================
If Empty(SB5->B5_PRODPC)
	cOptPc := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)
	cOptPc += '<option value=S >S - Sim</option>'+Chr(13)+Chr(10)
	cOptPc += '<option value=N >N - Nao</option>'+Chr(13)+Chr(10)
ElseIf SB5->B5_PRODPC == "S"
	cOptPc := '<option value=S selected="selected">S - Sim</option>'+Chr(13)+Chr(10)
	cOptPc += '<option value=N >N - Nao</option>'+Chr(13)+Chr(10)
ElseIf SB5->B5_PRODPC == "N"
	cOptPc := '<option value=S >S - Sim</option>'+Chr(13)+Chr(10)
	cOptPc += '<option value=N selected="selected">N - Nao</option>'+Chr(13)+Chr(10)
EndIf

//==================================================
// Monta o combobox de controle exercito
//==================================================
If Empty(SB5->B5_PRODEX)
	cOptEx := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)
	cOptEx += '<option value=S >S - Sim</option>'+Chr(13)+Chr(10)
	cOptEx += '<option value=N >N - Nao</option>'+Chr(13)+Chr(10)
ElseIf SB5->B5_PRODEX == "S"
	cOptEx := '<option value=S selected="selected">S - Sim</option>'+Chr(13)+Chr(10)
	cOptEx += '<option value=N >N - Nao</option>'+Chr(13)+Chr(10)
ElseIf SB5->B5_PRODEX == "N"
	cOptEx := '<option value=S >S - Sim</option>'+Chr(13)+Chr(10)
	cOptEx += '<option value=N selected="selected">N - Nao</option>'+Chr(13)+Chr(10)
EndIf

//==================================================
// Monta o combobox de Controle de Qualidade
//==================================================
If Empty(SB1->B1_TIPOCQ)
	cOptCq := '<option value="" selected="selected"></option>'+Chr(13)+Chr(10)
	cOptCq += '<option value=S >M - Mateirais</option>'+Chr(13)+Chr(10)
	cOptCq += '<option value=Q >Q - SigaQuality</option>'+Chr(13)+Chr(10)
ElseIf SB1->B1_TIPOCQ == "M"
	cOptCq := '<option value=M selected="selected">M - Materiais</option>'+Chr(13)+Chr(10)
	cOptCq += '<option value=Q >Q - SigaQuality</option>'+Chr(13)+Chr(10)
ElseIf SB1->B1_TIPOCQ == "Q"
	cOptCq := '<option value=M >M - Materiais</option>'+Chr(13)+Chr(10)
	cOptCq += '<option value=Q selected="selected">Q - SigaQuality</option>'+Chr(13)+Chr(10)
EndIf

//================================================
// Monta combo ONU
//================================================
lAchou := .F.
lPri := .T.
dbSelectArea("DY3")
DY3->(dbSetOrder(1))
DY3->(dbGoTop())
While DY3->(!EOF())

	If lPri
		If AllTrim(DY3->DY3_ONU) == AllTrim(SB5->B5_ONU) 
			cOptOn := '<option value='+AllTrim(DY3->DY3_ONU)+' selected="selected">'+AllTrim(DY3->DY3_ONU)+" - "+AllTrim(U_RetAceWeb(Left(DY3->DY3_DESCRI,70)))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
			cOptOn := '<option value='+AllTrim(DY3->DY3_ONU)+'>'+AllTrim(DY3->DY3_ONU)+" - "+AllTrim(U_RetAceWeb(Left(DY3->DY3_DESCRI,70)))+'</option>'+Chr(13)+Chr(10)
		Endif	
		lPri := .F.
	Else
		If AllTrim(DY3->DY3_ONU) == AllTrim(SB5->B5_ONU) 
			cOptOn += '<option value='+AllTrim(DY3->DY3_ONU)+' selected="selected">'+AllTrim(DY3->DY3_ONU)+" - "+AllTrim(U_RetAceWeb(Left(DY3->DY3_DESCRI,70)))+'</option>'+Chr(13)+Chr(10)
			lAchou := .T.
		Else
		 	cOptOn += '<option value='+AllTrim(DY3->DY3_ONU)+'>'+AllTrim(DY3->DY3_ONU)+" - "+AllTrim(U_RetAceWeb(Left(DY3->DY3_DESCRI,70)))+'</option>'+Chr(13)+Chr(10)
		EndIf
	EndIf

	DY3->(dbSkip())
Enddo

If !lAchou
	cOptOn := '<option value= selected="selected"></option>'+Chr(13)+Chr(10)+cOptOn
Endif

Conout("Preparacao do envio de email")

//==========================================================
// Envia aprovaÁ„o para o segundo aprovador
//==========================================================
//==========================================================
// Preenchimento do HTML
//==========================================================
oProcess:= TWFProcess():New( "WF0001", "LibProduto")
oProcess:NewTask("Liberacao de produto - fiscal","\workflow\html\wf_produto_qua.html")
oProcess:cSubject 		:= cAssunto
oProcess:cTo      		:= "000000"
oProcess:UserSiga 		:= "000000"
oProcess:bReturn  		:= 'U_RETWF01B()' 
oProcess:fDesc 			:= cAssunto
oHtml   := oProcess:oHtml  

//===========================================================================
// Monta o cabecalho da solicitacao
//===========================================================================
oHtml:ValByName('codigo',       SB1->B1_COD                                         	)
oHtml:ValByName('descricao',    SB1->B1_DESC                                        	)
oHtml:ValByName('tipo',         SB1->B1_TIPO                                        	)
oHtml:ValByName('ncm',          SB1->B1_POSIPI                                      	)
oHtml:ValByName('armazem',      SB1->B1_LOCPAD                                      	)
oHtml:ValByName('um',           SB1->B1_UM                                          	)
oHtml:ValByName('segun',        SB1->B1_SEGUM                                       	)
oHtml:ValByName('quantbase',    TransForm(SB1->B1_QB,PesqPict("SB1","B1_QB"))       	)
oHtml:ValByName('cClasfis',     SB1->B1_CLASFIS									    	)
oHtml:ValByName('grtrib',       SB1->B1_GRTRIB 									    	)

oHtml:ValByName('nome',         SB5->B5_CEME                                        	)
oHtml:ValByName('cOpt',         SB1->B1_ORIGEM	                                      	)
oHtml:ValByName('cGrupo',       SB1->B1_GRUPO	                                       	)
oHtml:ValByName('fator',        TransForm(SB1->B1_CONV,PesqPict("SB1","B1_CONV"))   	)
oHtml:ValByName('cTpConv',      If(SB1->B1_TIPCONV=="D","Divide","Multiplica")   	    )
oHtml:ValByName('ctaContabil',  SB1->B1_CONTA                                			)
oHtml:ValByName('aliipi',       TransForm(SB1->B1_IPI,PesqPict("SB1","B1_IPI"))     	)
oHtml:ValByName('icmsvq',       TransForm(SB1->B1_VQ_ICMS,PesqPict("SB1","B1_VQ_ICMS"))	)

oHtml:ValByName('cpfederal',  	cOptPf         		                       				)
oHtml:ValByName('cecercito',  	cOptEx              	                  				)
oHtml:ValByName('cpcivil',  	cOptPc                  	              				)
oHtml:ValByName('ctpcq',  		cOptCq                                					)
oHtml:ValByName('conu',  		cOptOn                                					)
oHtml:ValByName('vq_comp',  	SB1->B1_VQ_COMP                            	 			)
oHtml:ValByName('canp',  		SB5->B5_CODANP                        					)

oHtml:ValByName( "cHtmlAction" 	,	cHtmlAction		) 
oProcess:NewVersion(.T.)
oProcess:nEncodeMime := 0
oProcess:SetHtmlBody(.T.) 
cMailID := oProcess:Start(cDirHttp)+".htm" 
oProcess:free()
cUrlWF += cMailID

//===================================================
// Mensagem a ser enviada
//===================================================
cHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+Chr(13)+Chr(10)
cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">'+Chr(13)+Chr(10)
cHtml += '<head>'+Chr(13)+Chr(10)
cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+Chr(13)+Chr(10)
cHtml += '<title>Untitled Document</title>'+Chr(13)+Chr(10)
cHtml += '<style type="text/css">'+Chr(13)+Chr(10)
cHtml += '<!--'+Chr(13)+Chr(10)
cHtml += '.style1 {'+Chr(13)+Chr(10)
cHtml += '	font-family: Verdana, Arial, Helvetica, sans-serif;'+Chr(13)+Chr(10)
cHtml += '	font-size: 12px;'+Chr(13)+Chr(10)
cHtml += '}'+Chr(13)+Chr(10)
cHtml += '-->'+Chr(13)+Chr(10)
cHtml += '</style>'+Chr(13)+Chr(10)
cHtml += '</head>'+Chr(13)+Chr(10)
cHtml += '<body>'+Chr(13)+Chr(10)
cHtml += '<table width="704" border="0">'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td><img src="http://agmsystem.com.br/img/logo_verquimica.png" width="200" height="99" /></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td><p><span class="style1">Prezado (a) Sr. (a) '+Capital(cNome)+', no link abaixo, contem informa&ccedil;&otilde;es referente a inclus&atilde;o do produto '+AllTrim(SB1->B1_COD)+', pedimos a confer&ecirc;ncia e inser&ccedil;&atilde;o de dados para a libera&ccedil;&atilde;o do mesmo.</span></p>'+Chr(13)+Chr(10)
cHtml += '      <p><span class="style1"><br />'+Chr(13)+Chr(10)
cHtml += '        Atenciosamente</span></p>'+Chr(13)+Chr(10)
cHtml += '      <p class="style1">Clique <a href="'+cUrlWF+'">aqui</a> para abertura do formul&aacute;rio</p>'+Chr(13)+Chr(10)
cHtml += '      <p><span class="style1">        Verquimica - Workflow By Protheus</span><br />'+Chr(13)+Chr(10)
cHtml += '      </p></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td>&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '</table>'+Chr(13)+Chr(10)
cHtml += '</body>'+Chr(13)+Chr(10)
cHtml += '</html>'+Chr(13)+Chr(10)

//==================================================
// Disparo do email
//==================================================
lRet := U_SndEmail(	,;              //Server SMTP
					,;              //Nome da Conta                                      
					,;              // Usuario
					,;              // Senha
					,;              // Porta
					cAssunto,;      // Assunto
					cEmail,;        // Desinatario
					cHtml,;         // Texto em HTML
					{},;            // Anexos
					.F.,;           // Confirmacao de leitura
					.T.,;           // Recebe copia:
					.F.,;           // √© JOB?
					"peterson@verquimica.com.br")             // Email de quem receber√° a copia    

Conout("Email enviado para "+cEmail)  

Return Nil

//===========================================================================
// Programa.......: RETWF01B
// Autor..........: Anderson Goncalves
// Data...........: 19/03/21
// Descricao......: Workflow para disparo de email no momento da inclus√£o do
//                  produto
// Uso............: Verquimica
//===========================================================================

User Function RETWF01B(oProcess) 

//==================================================
// Variaveis da Rotina
//==================================================
Local cHtml		:= ""
Local cAssunto  := ""
Local cEmail	:= "compras@verquimica.com.br; vera@verquimica.com.br"

//==================================================
// Grava conteudo do retorno
//==================================================
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+oProcess:oHtml:RetByName("codigo")))

	RecLock("SB1",.F.)
	SB1->B1_VQ_COMP := oProcess:oHtml:ValByName('vq_comp')
	SB1->B1_TIPOCQ 	:= oProcess:oHtml:ValByName('ctpcq')
	SB1->B1_MSBLQL	:= "2"
	SB1->(msUnlock())

	dbSelectArea("SB5")
	SB5->(dbSetOrder(1))
	SB5->(dbSeek(xFilial("SB5")+oProcess:oHtml:RetByName("codigo")))
	RecLock("SB5",.F.)
	SB5->B5_PRODPF 	:= oProcess:oHtml:ValByName('cpfederal')
	SB5->B5_PRODEX 	:= oProcess:oHtml:ValByName('cecercito')
	SB5->B5_PRODPC 	:= oProcess:oHtml:ValByName('cpcivil')
	SB5->B5_ONU 	:= oProcess:oHtml:ValByName('conu')
	SB5->B5_CODANP 	:= oProcess:oHtml:ValByName('canp')
	SB5->(msUnlock())

	// Assunto do email
	cAssunto := "Liberacao do Produto "+SB1->B1_COD

	cHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+Chr(13)+Chr(10)
	cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">'+Chr(13)+Chr(10)
	cHtml += '<head>'+Chr(13)+Chr(10)
	cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+Chr(13)+Chr(10)
	cHtml += '<title>Untitled Document</title>v
	cHtml += '<style type="text/css">'+Chr(13)+Chr(10)
	cHtml += '<!--'+Chr(13)+Chr(10)
	cHtml += '.style1 {'+Chr(13)+Chr(10)
	cHtml += '	font-family: Verdana, Arial, Helvetica, sans-serif;'+Chr(13)+Chr(10)
	cHtml += '	font-weight: bold;'+Chr(13)+Chr(10)
	cHtml += '	font-size: 18px;'+Chr(13)+Chr(10)
	cHtml += '}'+Chr(13)+Chr(10)
	cHtml += '.style2 {'+Chr(13)+Chr(10)
	cHtml += '	font-family: Verdana, Arial, Helvetica, sans-serif;'+Chr(13)+Chr(10)
	cHtml += '	font-size: 12px;'+Chr(13)+Chr(10)
	cHtml += '}'+Chr(13)+Chr(10)
	cHtml += '.style13 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; font-weight: bold; }'+Chr(13)+Chr(10)
	cHtml += '.style3 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }'+Chr(13)+Chr(10)
	cHtml += '-->'+Chr(13)+Chr(10)
	cHtml += '</style>'+Chr(13)+Chr(10)
	cHtml += '</head>'+Chr(13)+Chr(10)
	cHtml += '<body>'+Chr(13)+Chr(10)
	cHtml += '<table width="700" border="0">'+Chr(13)+Chr(10)
	cHtml += '<tr>'+Chr(13)+Chr(10)
	cHtml += '	<td colspan="2"><table width="695" border="0">'+Chr(13)+Chr(10)
	cHtml += '	<tr>'+Chr(13)+Chr(10)
	cHtml += '		<td width="232"><div align="center"><img src="http://agmsystem.com.br/img/logo_verquimica.png" width="200" height="99" /></div></td>'+Chr(13)+Chr(10)
	cHtml += '		<td width="453"><div align="center" class="style1">Libera&ccedil;&atilde;o de Produto</div></td>'+Chr(13)+Chr(10)
	cHtml += '	</tr>'+Chr(13)+Chr(10)
	cHtml += '	</table></td>'+Chr(13)+Chr(10)
	cHtml += '</tr>'+Chr(13)+Chr(10)
	cHtml += '<tr>'+Chr(13)+Chr(10)
	cHtml += '	<td colspan="2"><hr /></td>'+Chr(13)+Chr(10)
	cHtml += '</tr>'+Chr(13)+Chr(10)
	cHtml += '<tr>'+Chr(13)+Chr(10)
	cHtml += '	<td colspan="2"><p class="style2">Prezado usu&aacute;rio, informamos que o produto inserido '+AllTrim(SB1->B1_COD)+" - "+AllTrim(SB1->B1_DESC)+', j&aacute; retornou do depto. fiscal e qualidade assim estando desbloqueado para uso.</p>'+Chr(13)+Chr(10)
	cHtml += '	<p class="style2">Obrigado</p></td>'+Chr(13)+Chr(10)
	cHtml += '</tr>'+Chr(13)+Chr(10)
	cHtml += '<tr>'+Chr(13)+Chr(10)
	cHtml += '	<td colspan="2">&nbsp;</td>'+Chr(13)+Chr(10)
	cHtml += '</tr>'+Chr(13)+Chr(10)
	cHtml += '<tr>'+Chr(13)+Chr(10)
	cHtml += '	<td colspan="2" class="style3">Este email &eacute; automatico n &atilde;o necessitando de resposta.</td>'+Chr(13)+Chr(10)
	cHtml += '</tr>'+Chr(13)+Chr(10)
	cHtml += '<tr>'+Chr(13)+Chr(10)
	cHtml += '	<td colspan="2"><hr /></td>'+Chr(13)+Chr(10)
	cHtml += '</tr>'+Chr(13)+Chr(10)
	cHtml += '<tr>'+Chr(13)+Chr(10)
	cHtml += '	<td width="344" class="style13">Verquimica@2021</td>'+Chr(13)+Chr(10)
	cHtml += '	<td width="347"><div align="right"><span class="style13">Workflow By Protheus - Servi&ccedil;o de entraga de mensagens</span></div></td>'+Chr(13)+Chr(10)
	cHtml += '</tr>'+Chr(13)+Chr(10)
	cHtml += '</table>'+Chr(13)+Chr(10)
	cHtml += '</body>'+Chr(13)+Chr(10)
	cHtml += '</html>'+Chr(13)+Chr(10)

	//==================================================
	// Disparo do email
	//==================================================
	lRet := U_SndEmail(	,;              //Server SMTP
						,;              //Nome da Conta                                      
						,;              // Usuario
						,;              // Senha
						,;              // Porta
						cAssunto,;      // Assunto
						cEmail,;        // Desinatario
						cHtml,;         // Texto em HTML
						{},;            // Anexos
						.F.,;           // Confirmacao de leitura
						.T.,;           // Recebe copia:
						.F.,;           // √© JOB?
						"peterson@verquimica.com.br")             // Email de quem receber√° a copia   

Endif

Return Nil
