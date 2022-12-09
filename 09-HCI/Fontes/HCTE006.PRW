#include "PROTHEUS.CH"
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCTE006   ºAutor  ³HCI                 º Data ³  06/13/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow gerado na inclusao da solicitacao de compras      º±±
±±º          ³ HCIRAP                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function HCTE006(cSc,cItsc,cCod,cDescri,cQtd,cTpEst,cEmin,cCmedio,cPPedido,cLtime,cEst,cOrc,cOc,cOs,cEm3,cDe3)

Local dDtVenc    := dDataBase  // Data de Vencimento 
Local nRegSx6	 := SX6->(Recno())
Local aUsrMat    := SUBSTR(cUsuario,7,15)  
Local aUsuarios  := {}
Local cMensag    := ""
Local cTVenc     := DATE()
Local cDesCod    := ""
Local cMsg       := ""
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
Local cMail
cMail    := Posicione("PHC",1,xFilial("PHC")+"HCTE006","PHC_EMAIL")

 
//If Len(aMail) > 0
		cMensag  := "Solicitacao de Compra N.:"+cSc+" Produto:"+trim(cCod)+" - "+trim(cDescri)+ " - Qtd:"+trim(str(cQtd))
		cMail    := Posicione("PHC",1,xFilial("PHC")+"HCTE006","PHC_EMAIL")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o Corpo do E-mail no Formato HTML ou Texto.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		cMsg := HCEM006(1,1,1,cMensag,cSc,cItsc,cCod,cDescri,cQtd,cTpEst,cEmin,cCmedio,cPPedido,cLtime,cEst,cOrc,cOc,cOs,cEm3,cDe3) 
		cAttach := ""
		aMsg:={{cMensag + Space(5)+DTOC(Date())+"-"+SubStr(TIME(),1,5) , cMsg, cAttach } }
	    AADD(aUsuarios, {SUBSTR(cUsuario,7,15)  ,cMail, aMsg} )
//"denilson.nunes@hci.ind.br;eder.cassiano@hci.ind.br;claudio.monteiro@hci.ind.br;marco.antonio@hci.ind.br;claudete.santana@hci.ind.br;douglas.miguel@hci.ind.br;robson.bueno@hci.ind.br"      
//endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia E-mail para cada usuario  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÙ
If Len(aUsuarios) > 0	
	HCEN006(aUsuarios,,,,SUBSTR(cUsuario,7,15) ,"1")
EndIf



Return( Nil )
 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCCE003   ºAutor  ³Microsiga           º Data ³  06/13/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CORPO DO E-MAIL AVISO DE ENTRADA DE ITENS                   º±±
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


STATIC Function HCEM006(ntab1,ntab2,ntab3,cMensag,cSc,cItsc,cCod,cDescri,cQtd,cTpEst,cEmin,cCmedio,cPPedido,cLtime,cEst,cOrc,cOc,cOs,cEm3,cDe3)


Local cMsg    := ""
Local cRoda   := ""
Local cMakCod := ""
Local cTpAud  := ""
Local i       := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se vai usar o formato HTML ou texto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ntab1 == 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o Cabecalho de acordo com o modulo que esta chamando.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ntab2 == 2
		cMsgCab := ""
    ENDIF		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Apos definicao do Cabecalho, monta o Corpo  do E-mail (HTML)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg+='<html> <head> <title>SIGARAP</title> </head>'
	cMsg+='<body>'
	cMsg+='<table border=1 width="657" height="29" cellspacing="1" bordercolorlight="#0099cc" bordercolordark="#0099cc" bordercolor="#0099cc" bgcolor="#0099cc" >'
	cMsg+='	<tr><td width="606" height="1" align="left" bordercolor="#0099cc" bordercolorlight="#0099cc" bordercolordark="#0099cc" bgcolor="#0099cc" >'
	cMsg+='		<p align="center"><font size="3" face="Courier New" color="#FFFFFF"><b> SOLICITACAO DE COMPRAS DE MATERIAIS </b></font></td>'	//
	cMsg+='	</tr>'
	cMsg+='	<tr><td height="26" bordercolor="#0099cc" bordercolorlight="#0099cc" bordercolordark="#0099cc" bgcolor="#FFFFFF" width="606">'
	cMsg+='		<p align="left"><br><br>Prezado Srs(as):<br><br> Segue abaixo detalhes da solicitacao de compras...'
    cMsg+='	    <br><br>SOLICITACAO DE COMPRAS AUTOMATICA<br>'	
	cMsg+='	    <br>    N. Solicitacao.......:'+cSC
	cMsg+='	    <br>    Item SC ...............:'+cItsc
	cMsg+='	    <br>    Codigo  ................:'+cCod
	cMsg+='	    <br>    Descricao .............:'+cDescri
	cMsg+='	    <br>    Tipo de estoque....:'+cTpEst
	cMsg+='	    <br>    QTD COMPRA...:<b>'+STR(cQtd)
	cMsg+='	    <br'
	cMsg+='	    <br>Destalhes da Analise'	
    cMsg+='	</b><br>    Estoque Minimo.............:<b>'+STR(cEmin)
    cMsg+='	</b><br>    Consumo Medio (12)....:<b>'+STR(cCmedio)
    cMsg+='	</b><br>    Lead Time ...................:<b>'+STR(cLtime)	
	cMsg+='	    <br>'
	cMsg+='	    <br>Situacao do Estoque'
	cMsg+='	</b><br>    Estoque ..........................:<b>'+STR(cEst)	
	cMsg+='	</b><br>    Qtd em Orcamento........:<b>'+STR(cOrc)	
	cMsg+='	</b><br>    Qtd Oc..........................:<b>'+STR(cOc)	
	cMsg+='	</b><br>    Qtd Os..........................:<b>'+STR(cOs)	
	cMsg+='	</b><br>    P. de Pedido..................:<b>'+STR(cPPedido)	
	cMsg+='</td></tr>'
	cMsg+='</table>'
	cMsg+='<BR>'

	// RODAPE DO E-MAIL
    cRoda := "Mensagem Gerada Automaticamente Consulta Rapida HCI pelo Usuario: " +SUBSTR(cUsuario,7,15)

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Termina de contar o corpo do E-mail.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

static Function HCEN006(aUsuarios,cMailConta,cMailServer,cMailSenha,cSendConta,cTipoemail)
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
