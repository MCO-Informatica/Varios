#include "Ap5Mail.ch"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲uncao    ? RetAgViag  ? Autor ? Pedro Augusto       ? Data ? 24.10.09 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Envia e-mail informativo para o depto de viagem quando hou-潮?  
北?          ? ver passagem e / ou hospedagem                             潮?  
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? Modulo SIGAWF                                              潮?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
User function RetAgViag()
	Local i
	
	chktemplate("CDV")
	
	_cMsg:= "<font face='Arial' color='#0099CC'> Solicita玢o de Viagem - " + LHP->LHP_CODIGO + "<BR>" + ;
	"Local: " + LHP->LHP_LOCAL + Chr(13) + Chr(10) + "<BR></FONT>" + ;
	"<BR>" + ;
	"<font face='Arial' color='#000000'> Colaborador: " + LHP->LHP_NFunc + Chr(13) + Chr(10) + "<BR>" + ;
	"Voo Ida......: " + LHP->LHP_VOOIDA + Chr(13) + Chr(10) + "<BR>" + ;
	"Data Ida.....: " + DTOC(LHP->LHP_SAIDA) + Chr(13) + Chr(10) + "<BR>" + ;
	"Hor醨io Ida..: " + LHP->LHP_HORAID + Chr(13) + Chr(10) + "<BR>" + ;
	"Cia Ida......: " + LHP->LHP_AIRIDA + Chr(13) + Chr(10) + "<BR>" + ;
	"Voo Volta....: " + LHP->LHP_VOOVTA + Chr(13) + Chr(10) + "<BR>" + ;
	"Data Volta...: " + DTOC(LHP->LHP_CHEGAD) + Chr(13) + Chr(10) + "<BR>" + ;
	"Hor醨io Volta: " + LHP->LHP_HORAVT + Chr(13) + Chr(10) + "<BR>" + ;
	"Cia Volta....: " + LHP->LHP_AIRVTA + Chr(13) + Chr(10) + "<BR>" + ;
	"Valor Passagem..........:  R$ " + TRANSFORM((LHP->LHP_VLPASS),'@E 999,999.99' ) + Chr(13) + Chr(10) + "<BR>" + ;
	"Observa玢o da Passagem..: " + LHP->LHP_HPASS + Chr(13) + Chr(10) + "<BR>" + ;
	"Valor Hospedagem........:  R$ " + TRANSFORM((LHP->LHP_VLHOSP),'@E 999,999.99' ) + Chr(13) + Chr(10) + "<BR>" + ;
	"Observa玢o da Hospedagem: " + LHP->LHP_HHOSP + Chr(13) + Chr(10) + "<BR>" + ;
	"Adiantamentos.:  R$ " + TRANSFORM((LHP->LHP_VALORR),'@E 999,999.99' ) + Chr(13) + Chr(10) + "<BR>" + ;
	"_____________________________________________" + Chr(13) + Chr(10) + "</FONT>
	_cSubject := "Informativo: Resposta da Agencia de Viagem."
	
	_cMail	 := GETMV("MV_USVIAGE")
	
	_MailServer := GETMV("MV_WFSMTP")
	_MailS := ""
	For i := 1 to Len(_MailServer)
		If Subst(_MailServer,i,1) <> ":"
			_MailS := _MailS + Subst(_MailServer,i,1)
		Else
			Exit
		Endif
	Next
	conout(_MailS) 
	conout(_cMail)
	conout(_cSubject)
	conout(_cMsg)
	
	connect smtp server _MailS account GETMV("MV_WFACC") password GETMV("MV_WFPASSW") TimeOut 200
	send mail from GETMV("MV_WFMAIL") to _cMail subject _cSubject body _cMsg FORMAT TEXT
	GET MAIL ERROR cErrorMsg
	//T_AEconsole("<------------FIM FUNCAO MAIL FIN --------------->")
	
	Return
	
