#Include "Rwmake.ch"
#include "AP5MAIL.ch"

/*
* Manutencao na Data do Limite do Orçamento
* R.Cavalini Informatica
* Ricardo Cavalini --> 17/07/2004 
*/
User Function Arlborca()

Dbselectarea("SC5")  
DbsetOrder(1)

aRotina:={{"Pesquisar"   ,"AxPesqui"   ,0,1},;
          {"Ajusta Vcto" ,"U_Arsjdta()" ,0,4}}

mBrowse( 6,1,22,75,"SC5",,,,,,,,)

Dbselectarea("SC5")  
DbSetOrder(1)

return


/*
Função de ajuste de data limite. 
*/
User Function Arsjdta()       

_cNum         := SC5->C5_NUM
_cNumCli      := SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" - "+SC5->C5_NOMCLI
_dEmis        := SC5->C5_EMISSAO
_clib         := SC5->C5_VRLIB
_dDtCol       := SC5->C5_VRDTCOL
_cHrCol       := SC5->C5_VRHRCOL
_cColet       := SC5->C5_VRCOLET
_cConh        := SC5->C5_VRCONH

// 2º etapa
_cBanco       := SC5->C5_BANCO
_cTransp      := SC5->C5_TRANSP
_cVolume      := SC5->C5_VOLUME1
_cEspecie     := SC5->C5_ESPECI1
_nPLiq        := SC5->C5_PESOL
_nPBrut       := SC5->C5_PBRUTO
_cNmTra       := Posicione("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_NOME")

IF EMPTY(SC5->C5_V_CONT)
	_cMailTr      := Posicione("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1__EMAILC")
ELSE
	_cMailTr      := Posicione("SU5",1,XFILIAL("SU5")+SC5->C5_V_CONT,"U5_EMAIL"  ) + space(150)
ENDIF

_cCdCont      := Posicione("SUA",8,XFILIAL("SUA")+SC5->C5_NUM,"UA_CODCONT")
_cNmCont      := Posicione("SUA",8,XFILIAL("SUA")+SC5->C5_NUM,"UA_DESCNT" )
_cMailTX      := Posicione("SU5",1,XFILIAL("SU5")+_cCdCont   ,"U5_EMAIL"  ) + space(150)

_cNmDDD       := Posicione("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_DDD")                         
_cNmTel       := Posicione("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_TEL")
_dDtNF        := Posicione("SF2",1,XFILIAL("SF2")+SC5->(C5_NOTA+C5_SERIE),"F2_EMISSAO")
_cusuar       := substr(cusuario,7,15)
_cNSENF       := SC5->C5_SERIE+"/"+SC5->C5_NOTA
_cNmPVC       := SC5->C5_PEDCLI

@ 000,000 To 290,610 Dialog oDlg0 Title "Pedido de Vendas." 
@ 010,005 SAY "Pedido :"
@ 010,040 Get _cNum SIZE 40,10 When .F.
@ 010,085 SAY "Cliente :"
@ 010,125 Get _cNumCli SIZE 150,10 When .F.
@ 025,005 SAY "Serie/NF:"
@ 025,040 Get _cNSENF SIZE 40,10 When .F.
@ 025,085 SAY "Email :"

IF EMPTY(ALLTRIM(_cMailTX)) .OR. ALLTRIM(_cMailTX) == "."
	@ 025,125 Get _cMailTr                           SIZE 150,10
ELSE
	@ 025,125 Get _cMailTX                           SIZE 150,10
ENDIF

@ 045,005 Say "Data Emissao"
@ 045,060 Say "Liberado"
@ 045,130 Say "Dt Coleta"
@ 045,210 Say "Hora Coleta"
@ 055,005 Get _dEmis                             SIZE 40,10 When .F.
@ 055,055 Get _CLIB Picture "@!"                 SIZE 40,10 
@ 055,130 Get _dDtCol                            SIZE 50,10
@ 055,210 Get _cHrCol Picture "99:99:99"         SIZE 30,10

@ 075,005 Say "Coleta:"
@ 075,040 Get _cColet Picture "@!"               SIZE 250,10 

@ 095,005 Say "Transp"
@ 095,040 Get _cTransp f3 'SA4CLT'               				SIZE 030,10 
@ 095,080 Get _cNmTra                            				SIZE 150,10 When .f.    
@ 095,245 Get IIF(EMPTY(_cNmDDD),_cNmTel,_cNmDDD+"-"+_cNmTel)   SIZE 060,10 When .f.    

@ 110,005 Say "P.Liq"
@ 110,030 Get _nPLiq  Picture "@R 9999.9999"         SIZE 30,10

@ 110,085 Say "P.Brut"
@ 110,105 Get _nPBrut Picture "@R 9999.9999"         SIZE 30,10

@ 110,170 Say "Volume"
@ 110,195 Get _cVolume Picture "@E 9999"           SIZE 30,10

@ 110,245 Say "Especie"
@ 110,270 Get _cEspecie                              SIZE 30,10

@ 124,015 BmpButton Type 1 Action _ArsDtOk()
@ 124,200 BmpButton Type 2 Action _ArsFech()
Activate Dialog oDlg0 Centered
return

/*
Função de sair da tela de ajuste de data limite.
*/
Static Function _ArsDtOk()

Dbselectarea("SC5")
Reclock("SC5",.F.)
  SC5->C5_VRLIB   := _clib
  SC5->C5_VRDTCOL := _dDtCol
  SC5->C5_VRHRCOL := _cHrCol
  SC5->C5_VRCOLET := _cColet
  SC5->C5_TRANSP  := _cTransp
  SC5->C5_PESOL   := _nPLiq  
  SC5->C5_PBRUTO  := _nPBrut
  SC5->C5_VOLUME1 := _cVolume
  SC5->C5_ESPECI1 := _cEspecie 
MsUnlock("SC5")

// Envio de Email
IF !EMPTY(SC5->C5_NOTA)
	If MSGNOYES("Deseja enviar email para o Cliente?")
	   IF EMPTY(_cMailTr)
	    	_cMailTr:= _cMailTX
	   Endif
	   IF EMPTY(_cMailTr)
    	  MSGALERT("Campo de email esta vazio... Mensagem não enviada !!!") 

			// usuario da coleta
			Dbselectarea("SC5")
			Reclock("SC5",.F.)
			  SC5->C5_USRCLT   := _cusuar 
			MsUnlock("SC5")

	      Close(oDlg0)
		  Return
	   ENDIF

	   // funcao de envio de email
	   MailClt(_cMailTr)

	Endif
	
		// usuario da coleta
		Dbselectarea("SC5")
		Reclock("SC5",.F.)
		  SC5->C5_USRCLT   := _cusuar 
		MsUnlock("SC5")

ENDIF
Close(oDlg0)
Return

// botao para fechar a tela
Static function _ArsFech()
Close(oDlg0)
Return


// funcao de envio de mensagem ao cliente - coleta
Static Function MailClt(_cMailTr)
nOpcao := 0
aArea       := GetArea()
lOk         := .F.		// Variavel que verifica se foi conectado OK
lAutOk      := .F. 
lSendOk     := .F.		// Variavel que verifica se foi enviado OK
cMailConta  := AllTrim(GetNewPar("MV_RELACNT"," "))
cMailServer := AllTrim(GetNewPar("MV_RELSERV"," "))
cMailSenha  := AllTrim(GetNewPar("MV_RELPSW" ," "))
lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cMailConta)) //Usuário para Autenticação no Servidor de Email
cSenhAut    := Alltrim(GetMv("MV_RELAPSW",,cMailSenha)) //Senha para Autenticação no Servidor de Email
nTimeOut    := GetMv("MV_RELTIME",,120)                 //Tempo de Espera antes de abortar a Conexão

cEmailTo    := _cMailTr
cEmailCC    := ""


// Tratamento de envio atraves do correio
__ctrans := GETMV("MV_CORREIO")
IF _cTransp == __ctrans
	
	IF EMPTY(SC5->C5_NOTA)
		cAssunto    := PadR("Coleta - Pedido de vendas "+SC5->C5_NUM,120)
	ELSE
		cAssunto    := PadR("Coleta - Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE,120)
	ENDIF
	
	cMensagem   := " "
	cAttach     := " "
	lAciTM0     := .f.
	
	IF VAL(SUBSTR(Time(),1,2)) <=  12
		cMensagem   := "Bom Dia,  "+_cNmCont
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMCLI
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ELSEIF VAL(SUBSTR(Time(),1,2)) > 12 .OR. VAL(SUBSTR(Time(),1,2)) <= 18
		cMensagem   := "Boa Tarde,  "+_cNmCont
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMCLI
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ELSEIF VAL(SUBSTR(Time(),1,2)) >=  18
		cMensagem   := "Boa Noite,  "+_cNmCont
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMCLI
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ENDIF
	
	IF !EMPTY(_cNmPVC)
		cMensagem   += "Informamos que seu pedido Nr. "+_cNmPVC+" foi postado hoje por sedex."
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Para acompanhar clique neste link http://www.correios.com.br/servicos/rastreamento/rastreamento.cfm e "
		cMensagem   += "digite o código "+SUBSTR(_CCOLET,1,AT(" ",_CCOLET))
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ELSE
		cMensagem   += "Informamos que seu do pedido foi postado hoje por sedex."
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Para acompanhar clique neste link http://www.correios.com.br/servicos/rastreamento/rastreamento.cfm e "
		cMensagem   += "digite o código "+SUBSTR(_CCOLET,1,AT(" ",_CCOLET))
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ENDIF
	
	cMensagem   += "Obrigado pela preferência e confiança, nos colocamos a sua disposição para outros esclarecimentos."
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Atenciosamente,"
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += SM0->M0_NOMECOM
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += SM0->M0_ENDCOB+" - "+SM0->M0_CIDCOB+" - "+SM0->M0_ESTCOB
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "TEL.: "+SUBSTR(SM0->M0_TEL,2,3)+" "+SUBSTR(SM0->M0_TEL,5,8)+" - FAX: "+SUBSTR(SM0->M0_FAX,2,3)+" "+SUBSTR(SM0->M0_FAX,5,8)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += SC5->C5_NOMVEN
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_EMAIL")
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " E_mail gerado automaticamente. Favor não responder. "	

ELSE
	
	IF EMPTY(SC5->C5_NOTA)
		cAssunto    := PadR("Coleta - Pedido de vendas "+SC5->C5_NUM,120)
	ELSE
		cAssunto    := PadR("Coleta - Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE,120)
	ENDIF
	cMensagem   := " "
	cAttach     := " "
	lAciTM0     := .f.
	
	IF VAL(SUBSTR(Time(),1,2)) <=  12
		cMensagem   := "Bom Dia,  "+_cNmCont
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMCLI
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ELSEIF VAL(SUBSTR(Time(),1,2)) > 12 .OR. VAL(SUBSTR(Time(),1,2)) <= 18
		cMensagem   := "Boa Tarde,  "+_cNmCont
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMCLI
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ELSEIF VAL(SUBSTR(Time(),1,2)) >=  18
		cMensagem   := "Boa Noite,  "+_cNmCont
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMCLI
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
	ENDIF

	IF !EMPTY(_CNMPVC)
		cMensagem   += "Informamos que seu pedido nr. "+_CNMPVC+"foi coletado em "+dtoc(_dDtCol)+" as "+_cHrCol+", pela Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE+", emitada em "+dtoc(_dDtNF)+"."
    ELSE
		cMensagem   += "Informamos que seu pedido, foi coletado em "+dtoc(_dDtCol)+" as "+_cHrCol+", pela Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE+", emitada em "+dtoc(_dDtNF)+"."    
	ENDIF
	
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Transportadora :"+_cNmTra+"    Telefone: "+IIF(EMPTY(_cNmDDD),_cNmTel,_cNmDDD+"-"+_cNmTel)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Dados da coleta: "
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Peso Liquido "+Transform(_nPLiq, "@R 9999.9999")
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Peso Bruto "+Transform(_nPBrut, "@R 9999.9999")
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Volume "+Transform(_cVolume, "@R 9999")
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Especie "+_cEspecie
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)

    IF !EMPTY(_cColet)
		cMensagem   += "Observação "
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += _cColet
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
    ENDIF
	cMensagem   += "Obrigado pela preferência e confiança, nos colocamos a sua disposição para outros esclarecimentos."
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Atenciosamente, "
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += SM0->M0_NOMECOM
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += SM0->M0_ENDCOB+" - "+SM0->M0_CIDCOB+" - "+SM0->M0_ESTCOB
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "TEL.: "+SUBSTR(SM0->M0_TEL,2,3)+" "+SUBSTR(SM0->M0_TEL,5,8)+" - FAX: "+SUBSTR(SM0->M0_FAX,2,3)+" "+SUBSTR(SM0->M0_FAX,5,8)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += SC5->C5_NOMVEN
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_EMAIL")
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " E_mail gerado automaticamente. Favor não responder."	
ENDIF


//Verifica se existe o SMTP Server
If 	Empty(cMailServer)
	Help(" ",1,"ATENCAO",,"O Servidor de SMTP nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELSERV).",4,5)
	RestArea(aArea)
	Return
EndIf

//Verifica se existe a CONTA 
If 	Empty(cMailConta)
	Help(" ",1,"ATENCAO",,"A Conta do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELACNT).",4,5)
	RestArea(aArea)
	Return
EndIf

//Verifica se existe a Senha
If 	Empty(cMailSenha) 
	Help(" ",1,"ATENCAO",,"A Senha do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELPSW).",4,5)
	RestArea(aArea)
	Return
EndIf

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nTimeOut RESULT lOk
	If !lAutOk 
		If lSmtpAuth
			lAutOk := MailAuth(cUserAut,cSenhAut)
			If !lAutOk
				Aviso(OemToAnsi("Atencao"),OemToAnsi("Falha na Autenticação do Usuário no Provedor de E-mail - Arlborca"),{"Ok"})
				RestArea(aArea)
				DISCONNECT SMTP SERVER
				// Return ==> COMENTADO
			Endif
		Else
			lAutOk := .T.
		EndIf
	EndIf
	If lOk .and. lAutOk
			SEND MAIL FROM "comercialagricola@verion.com.br";
					TO cEmailTo;
 					CC cEmailcc;					
					SUBJECT Trim(cAssunto);
					BODY cMensagem;  
					RESULT lSendOk 
		If !lSendOk
			Help(" ",1,"ATENCAO",,"Erro no envio de Email",4,5)
		EndIf
	Else
		Help(" ",1,"ATENCAO",,"Erro na conexao com o SMTP Server",4,5)
	EndIf
	DISCONNECT SMTP SERVER
EndIf                   
       
RestArea(aArea)
Return
