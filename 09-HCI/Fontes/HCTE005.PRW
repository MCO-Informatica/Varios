#include "PROTHEUS.CH"
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCTE005   ºAutor  ³HCI                 º Data ³  06/13/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aviso ao representante do Processo comercial em andamento  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function HCTE005(cProcesso,cCliente,cLoja,dFollow,nValor,cObserv,cTipo,cContato,cRefcli,cStatus,cResult,cOrcamento,cNegociador,dAbert)
//  HCTE004(cProcesso,cCliente,cLoja,dData,nVlalfr,cObserv,cTipo,cContato,cRefcli,cStatus,cResult) HCTE004(SZQ->ZQ_NUMERO)
Local dDtVenc    := dDataBase  // Data de Vencimento 
Local nRegSx6	 := SX6->(Recno())
Local aUsrMat    := SUBSTR(cUsuario,7,15)  
Local aUsuarios  := {}
Local cMensag    := ""
Local cTVenc     := DATE()
Local cDesCod    := ""
Local cMsg       := ""
Local cVend      :=""
Local cMail      :=""
Local cDescQI3   := ""
Local nIndQI2    := 0
Local nIndQI3    := 0
Local nIndQI5    := 0
Local cKey       := ""
Local cFiltro    := "" 
Local cFilUsr    := "" // Filial do usuario
Local cMatUsr    := "" // Matricula do usuario
Local aMail      := {} // Corpo do E-mail
Local cEmitente
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿
//³aMail  ==>  aMail[x][1] --> Processo          ³
//³aMail  ==>  aMail[x][2] --> Data              ³
//³            aMail[x][3] --> Cliente           ³
//³            aMail[x][4] --> Valor             ³
//³            aMail[x][5] --> Status            ³ 
//³            aMail[x][6] --> Observacoes       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ù
// Adiciona Informacoes sobre Quais vendas estao sendo atendidas pelo movimento
AADD(aMail,{cProcesso,dFollow,cCliente,cLoja,Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ"),nValor})
If Len(aMail) > 0
		cMensag  := "Processo:"+cProcesso+" Cliente:"+ Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ")+"Valor:" + Transform(nValor,"@E 999,999.99") 
		cTVenc   := "Detalhes do Processo"
	    cDesCod  := "Numero da Venda"
		cVend    := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_VEND")
		cMail    := Posicione("SA3",1,xFilial("SA3")+cVend,"A3_EMAIL")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o Corpo do E-mail no Formato HTML ou Texto.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		
		cMsg := HCEM005(1,aMail,1,cProcesso,cCliente,cLoja,dFollow,nValor,cObserv,cTipo,cContato,cRefcli,cStatus,cResult,cOrcamento,cNegociador,dAbert) 
		cAttach := ""
		aMsg:={{cMensag + Space(3)+DTOC(Date())+"-"+SubStr(TIME(),1,5) , cMsg, cAttach } }
	    AADD(aUsuarios, {SUBSTR(cUsuario,7,15)  , cMail, aMsg} )
//"denilson.nunes@hci.ind.br;eder.cassiano@hci.ind.br;claudio.monteiro@hci.ind.br;marco.antonio@hci.ind.br;claudete.santana@hci.ind.br;douglas.miguel@hci.ind.br;robson.bueno@hci.ind.br"      
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia E-mail para cada usuario  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÙ
If Len(aUsuarios) > 0	
	HCEN005(aUsuarios,,,,SUBSTR(cUsuario,7,15) ,"1")
EndIf



Return( Nil )
 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCCE003   ºAutor  ³Microsiga           º Data ³  06/13/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CORPO DO E-MAIL AVISO DE RESTRICAO DE CREDITO               º±±
±±³          ³ ExpN1 = Numerico definindo o  modulo que esta chamando     ³±±
±±³          ³ ExpA1 = Array contendo os dados do Corpo do E-mail         ³±±
±±³          ³ ExpN2 = Formato do E-mail (1=HTML / 2=Texto)               ³±±
±±³          ³ ExpC1 = Titulo do Cabecalho                                ³±±
±±³          ³ ExpC1 = Sub-Titulo do Corpo do E-mail                      ³±±
±±³          ³ ExpC1 = Descricao do Codigo                                ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


STATIC Function HCEM005(nMod,aMail,nTpMail,cProcesso,cCliente,cLoja,dFollow,nValor,cObserv,cTipo,cContato,cRefcli,cStatus,cResult,cOrcamento,cNegociador,dAbert)
                     //(1   ,aMail,1      ,cMensag , cTVenc,cDesCod ,cOc,cItem,cCod,cDescri,cQtd,cFornece,cLoja,cNreduz,cRI,cCorrida,cAlmox,cStatus) 

// Modulo 1 --> SIGAQNC
// Modulo 2 --> SIGAQDO
// Modulo 3 --> SIGAQAD

Local cMsg    := ""
Local cRoda   := ""
Local cMakCod := ""
Local cTpAud  := ""
Local i       := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se vai usar o formato HTML ou texto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTpMail == 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o Cabecalho de acordo com o modulo que esta chamando.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nMod == 1
		cMsgCab := StrTran(PadR("Pedido/Item/Cliente/Vencimento/Qtd Saldo",55)," ",'&nbsp;') +'</font></P>' //"Vencimento"
    ENDIF		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Apos definicao do Cabecalho, monta o Corpo  do E-mail (HTML)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg+='<html> <head> <title></title> </head>'
	cMsg+='<body>'
	cMsg+='<table border=1 width="657" height="29" cellspacing="1" bordercolorlight="#0099cc" bordercolordark="#0099cc" bordercolor="#0099cc" bgcolor="#0099cc" >'
	cMsg+='	<tr><td width="606" height="1" align="left" bordercolor="#0099cc" bordercolorlight="#0099cc" bordercolordark="#0099cc" bgcolor="#0099cc" >'
	cMsg+='		<p align="center"><font size="3" face="Courier New" color="#FFFFFF"><b> AVISO DE PROCESSO DE VENDA EM ANDAMENTO </b></font></td>'	//
	cMsg+='	</tr>'
	cMsg+='	<tr><td height="26" bordercolor="#0099cc" bordercolorlight="#0099cc" bordercolordark="#0099cc" bgcolor="#FFFFFF" width="606">'
	cMsg+='		<p align="left"><br><br>Prezado Sr.:<br><br> Segue abaixo aviso de Processo Comercial em Andamento...'
	if cTipo="2" 
	  cMsg+='	    <br><br>Tipo de Processo:<b>Levantamento de Precos</b><br>'
    ENDIF
    IF cTipo="1"  	
	  cMsg+='	    <br><br>Tipo de Processo:<b>Compra</b><br>'
	ENDIF
	IF cTipo="3"  	
	  cMsg+='	    <br><br>Tipo de Processo:<b>Projeto</b><br>'
	ENDIF
    IF cTipo <>"1" .AND. cTipo <>"2" .AND. cTipo <>"3"
      cMsg+='	    <br><br>Tipo de Processo:<b>Outros</b><br>'	
	endif
	cMsg+='	    <br><table><tr><td>N. Processo :</td><td>'+cProcesso+'</td></tr>'
	cMsg+='	    <br><tr><td>Dt Abertura :</td><td>'+dtoc(dAbert)+'</td></tr></table>'
	cMsg+='	    <br><table><tr><td>Cliente:</td><td>'+cCliente+'</td></tr>'
	cMsg+='	    <tr><td>Loja:</td><td>'+cLoja+'</td></tr>'
	cMsg+='	    <tr><td>Nome Cliente:</td><td>'+Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ")+'</td></tr>'
	cMsg+='	    <tr><td>Contato:</td><td>'+cContato+'</td></tr>'
	cMsg+='	    <tr><td>Valor:</td><td>'+Transform(nValor,"@E 999,999.99")+'</td></tr>'
	cMsg+='	    <tr><td>Orcamentista:</td><td>'+cOrcamento+'</td></tr>'
	cMsg+='     <tr><td>Negociador:</td><td>'+cNegociador+'</td></tr>'	
    cMsg+='	    <tr><td>Data Follow:</td><td><b>'+dtoc(dFollow)+'</b></td></tr>'
    cMsg+='	    <tr><td>Ref Cliente.:</td><td><b>'+cRefcli+'</b></td></tr>'
    cMsg+='	    <tr><td>Observacoes.:</td><td><b>'+cObserv+'</b></td></tr>'
    IF cStatus="01"
      cMsg+='	<tr><td>    Status....:</td><td><b>Em Elaboracao</b></td></tr>'	 
    ENDIF
    if cStatus="02"
      cMsg+='	<tr><td>    Status....:</td><td><b>Aguardando Precos</b></td></tr>'	      
    ENDIF
    if cStatus="03"
      cMsg+='	<tr><td>    Status....:</td><td><b>Enviado</b></td></tr>'
    ENDIF
    if cStatus="04"
      cMsg+='	<tr><td>    Status....:</td><td><b>Follow_up</b></td></tr>'     
    ENDIF
    if cStatus="05"
      cMsg+='	<tr><td>    Status....:</td><td><b>Encerrado</b></td></tr>'          
    endif
    IF cResult="1"
      cMsg+='	<tr><td>    Resultado.:</td><td><b>Pedido</b></td></tr>'	 
    ENDIF
    if cResult="2"
      cMsg+='	<tr><td>    Resultado.:</td><td><b>Perdemos Por Preco</b></td></tr>'	      
    ENDIF
    if cResult="3"
      cMsg+='	<tr><td>    Resultado.:</td><td><b>Perdemos Por Prazo</b></td></tr>'
    ENDIF
    if cResult="4"
      cMsg+='	<tr><td>    Resultado.:</td><td><b>Perdemos Por Qualidade</b></td></tr>'      
    ENDIF
    If cResult="5"
      cMsg+='	<tr><td>    Resultado.:</td><td><b>Perdemos Por Dem Resp</b></td></tr>'          
    ENDIF
    if cResult="6"
      cMsg+='	<tr><td>    Resultado.:</td><td><b>Perdemos Por Afinidade</b></td></tr>'      
    ENDIF
    if cResult=" "
      cMsg+='	<tr><td>    Resultado.</td><td><b>.</b></td></tr>'      
    endif
    cMsg+='</table></td></tr>'
	cMsg+='</table>'
	cMsg+='<BR>'
	
	// RODAPE DO E-MAIL
    cRoda := "Mensagem Gerada Automaticamente pelo Sistema HCI pelo Usuario: " +SUBSTR(cUsuario,7,15)

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Termina de contar o corpo do E-mail.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg+='</TD></TR></TBODY></TABLE>'
	cMsg+='<BR>'
	cMsg+='<p><FONT size=2><EM>'+cRoda+'</EM></FONT></p>'
	cMsg+='</body></html>'

EndIf

Return (cMsg)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³HCEN001   ³ Autor ³ Aldo Marini Junior    ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que envia e-mail de acordo com array                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QAEnvMail(ExpA1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os dados de envio (To,Subject,Body,      ³±±
±±³          ³         Attachment)                                        ³±±
±±³          ³ ExpC1 = Caracter contendo conta de acesso ao servidor      ³±±
±±³          ³ ExpC2 = Caracter contendo o endereco do servidor           ³±±
±±³          ³ ExpC3 = Caracter contendo senha de acesso ao servidor      ³±±
±±³          ³ ExpC4 = Caracter contendo a conta do Usuario logado        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ lResult = Logico retornando se houve algum erro no envio   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function HCEN005(aUsuarios,cMailConta,cMailServer,cMailSenha,cSendConta,cTipoemail)
Local lResult	:= .F.
Local aRetUser := {}
Local nAtConta
Default cMailConta  := AllTrim(GETMV("MV_RELACNT"))
Default cMailServer := AllTrim(GETMV("MV_RELSERV"))
Default cMailSenha  := AllTrim(GETMV("MV_RELPSW"))
Default cSendConta  := "SIGA"+cModulo
Default cTipoemail	:= "1" //1=Sistemas 2=Usuario

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a conta de email do usuario esta com mais de uma e considera apenas ³
//³ a primeira para conectar e enviar email                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ";" $ cSendConta
	nAtConta := AT(";",cSendConta)
	cSendConta := SubStr(cSendConta,1,nAtConta-1)
Endif

If Len(aUsuarios) == 0
	Return(.F.)
Endif

IF cTipoemail=="2"  //Tipo 2=Usuario
	If cSendConta == ("SIGA"+cModulo) .Or. Empty(AllTrim(cSendConta))
		PswOrder(1)
		PswSeek(__CUSERID)
		aRetUser := PswRet(1)
		If !Empty(aRetUser[1][14])
			cSendConta := AllTrim(aRetUser[1][14])
	    Else                      
	        cSendConta := GetMV("MV_EMCONTA")
	        IF Empty(AllTrim(cSendConta))    
				cSendConta := "SIGA"+cModulo+"@PROTHEUS"
			Endif	
		EndIf
	Endif
Else				//Tipo 1=Sistemas
	cSendConta := GetMV("MV_EMCONTA")
	IF Empty(AllTrim(cSendConta))                
		cSendConta := "SIGA"+cModulo+"@PROTHEUS"
	Endif		
Endif	

If Empty(AllTrim(cMailConta))
   cMailConta :=AllTrim(GETMV("MV_RELACNT"))
Endif

If Empty(AllTrim(cMailServer))
   cMailServer:=AllTrim(GETMV("MV_RELSERV"))
Endif

If Empty(AllTrim(cMailSenha))
   cMailSenha :=AllTrim(GETMV("MV_RELPSW"))
Endif

LjMsgRun(OemToAnsi("Enviando Workflow..."),OemtoAnsi("Aguarde"),{||QARunMail(aUsuarios,cMailConta,cMailServer,cMailSenha,@lResult,cSendConta)})  //"Enviando e-Mail para os Usuarios..." ### "Aguarde"

Return(lResult)
