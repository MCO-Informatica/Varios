#include "PROTHEUS.CH"
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCTE001   ºAutor  ³HCI                 º Data ³  06/13/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function HCTE001(nValor,lMotivo1,lMotivo2,lMotivo3,lMotivo4)

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
Local cMailCred := AllTrim(GETMV("ES_CREDITO"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿
//³aMail  ==>  aMail[x][1] --> Cliente           ³
//³            aMail[x][2] --> Loja              ³
//³            aMail[x][3] --> Nome Cliente      ³
//³            aMail[x][4] --> Valor Venda       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ù
 
// adiciona ao aMail os dados para envio do ee-mail
IF M->C5_NOMCLI ="" 
  AADD(aMail,{M->C5_CLIENTE, M->C5_LOJACLI, Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NOME"), DATE(), nValor})
ELSE
  AADD(aMail,{M->C5_CLIENTE, M->C5_LOJACLI, M->C5_NOMCLI, DATE(), nValor})
ENDIF
cEmitente:=Posicione("SA3",1,xFilial("SA3")+M->C5_AGINT,"A3_EMAIL")
cEmitente:=trim(cEmitente)+";"+cMailCred 
If Len(aMail) > 0
		cMensag  := "Solicitacao de Liberacao de Credito (automatica)"
		cTVenc   := "Dados do Cliente Objeto da Consulta"
	    cDesCod  := "Numero da Venda"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o Corpo do E-mail no Formato HTML ou Texto.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		cMsg := HCEM001(1,aMail,1,cMensag,cTVenc,cDesCod,lmotivo1,lmotivo2,lmotivo3,lmotivo4) 
		cAttach := ""
		aMsg:={{cMensag + Space(10)+DTOC(Date())+"-"+SubStr(TIME(),1,5) , cMsg, cAttach } }
		IF LEN(cEmitente)>0 
          AADD(aUsuarios, {SUBSTR(cUsuario,7,15)  , "depto.cadastro@hci.ind.br;deptohci.ctrecebe@hci.ind.br;"+TRIM(cEmitente), aMsg} )
		else
	      AADD(aUsuarios, {SUBSTR(cUsuario,7,15)  , "depto.cadastro@hci.ind.br;deptohci.ctrecebe@hci.ind.br;", aMsg} )
        endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia E-mail para cada usuario  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÙ
If Len(aUsuarios) > 0	
	HCEN001(aUsuarios,,,,SUBSTR(cUsuario,7,15) ,"1")
EndIf



Return( Nil )
 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HCCE001   ºAutor  ³Microsiga           º Data ³  06/13/08   º±±
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


STATIC Function HCEM001(nMod,aMail,nTpMail,cTitCab,cSTitCor,cDesCod,lMotivo1,lMotivo2,lMotivo3,lMotivo4)
// Modulo 1 --> SIGAQNC
// Modulo 2 --> SIGAQDO
// Modulo 3 --> SIGAQAD

Local cMsg    := ""
Local cRoda   := ""
Local cMakCod := ""
Local cTpAud  := ""
Local i       := 0
Local cSativ  :=""
// RODAPE DO E-MAIL
cRoda := "Mensagem Gerada Automaticamente pelo Sistema de Vendas HCI pelo Usuario: " +SUBSTR(cUsuario,7,15)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se vai usar o formato HTML ou texto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTpMail == 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o Cabecalho de acordo com o modulo que esta chamando.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nMod == 1
		cMsgCab := StrTran(PadR("Pedido/Cliente/Loja/Razao Social/Emissao/Valor",55)," ",'&nbsp;') +'</font></P>' //"Vencimento"
    ENDIF		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Apos definicao do Cabecalho, monta o Corpo  do E-mail (HTML)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg+='<html> <head> <title>SIGAFAT</title> </head>'
	cMsg+='<body>'
	cMsg+='<table border=1 width="657" height="29" cellspacing="1" bordercolorlight="#0099cc" bordercolordark="#0099cc" bordercolor="#0099cc" bgcolor="#0099cc" >'
	cMsg+='	<tr><td width="606" height="1" align="left" bordercolor="#0099cc" bordercolorlight="#0099cc" bordercolordark="#0099cc" bgcolor="#0099cc" >'
	cMsg+='		<p align="center"><font size="3" face="Courier New" color="#FFFFFF"><b> MENSAGEM </b></font></td>'	//
	cMsg+='	</tr>'
	cMsg+='	<tr><td height="26" bordercolor="#0099cc" bordercolorlight="#0099cc" bordercolordark="#0099cc" bgcolor="#FFFFFF" width="606">'
	cMsg+='		<p align="left"><br><br>Prezado Srs(as):<br><br> Favor analisar e disponibilizar credito para o cliente abaixo listado...'
	cMsg+='	    <br><br>Desde Ja Agradecemos<br><br>'
	cMsg+='Motivo(s):<br>'
	if lmotivo1=.t.
	  cMsg+='1) Limite Ultrapassado<br>'
	endif
	if lmotivo2=.t.
	  cMsg+='2) Validade de Credito Vencida<br>'
	endif
	if lmotivo3=.t.
	  cMsg+='3) Atraso de Pagamento<br>'
	endif  
	if lmotivo4=.t.
	  cMsg+='4) Pagamento Antecipado<br>'
	endif  
	cMsg+='</td></tr>'
	cMsg+='</table>'
	cMsg+='<BR>'
	cMsg+='<TABLE borderColor=#000080 width=658 border=1>'
	cMsg+='<TBODY>'
	cMsg+='<TR>'
	cMsg+='<TD width=648>'
	cMsg+='<p align="center"><font color="#0000FF"><b>' + cSTitCor + '</b></font></TD></TR>'
	cMsg+='<TR>'
	cMsg+='<TD width=648>'
	cMsg+='<P style="MARGIN: 0px"><font face="Courier New" size="2"> <b>'
	cMsg+= cMsgCab + '<P style="MARGIN: 0px">&nbsp;</P> </b>'
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Varre o array que foi passado para esta funcao e imprime³
	//³os dados de acordo com o modulo que esta chamando       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i:=1 To Len(aMail)
		cMsg+='<P style="MARGIN: 0px"><font face="Courier New" size="2">'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime itens co corpo do e-mail                                 .³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMakCod := M->C5_NUM+"/"+StrTran(TransForm(aMail[1,1],"@R ######"), " ", '&nbsp;') + "/" + aMail[1,2]+'&nbsp;&nbsp;'+aMail[1,3]+'&nbsp;&nbsp;'+DTOC(aMail[1,4])+'&nbsp;&nbsp;'+aMail[1,5]
		cSativ:=Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_SATIV1")
		cMsg+= cMakCod + '&nbsp;&nbsp;<br><br>Ramo de Atividade:'+Posicione("SX5",1,xFilial("SX5")+"T3"+cSativ,"X5_DESCRI")+'<br><br>'
		cMsg+= '&nbsp;&nbsp;<br><br>Cond. Pagto      :'+Posicione("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_ANALIT")+'<br><br>'
	Next i
	
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
static Function HCEN001(aUsuarios,cMailConta,cMailServer,cMailSenha,cSendConta,cTipoemail)
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
