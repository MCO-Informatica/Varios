#include "rwmake.ch"
#include "ap5mail.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �cobranca   �Autor  �Marco A. Montini      � Data � 05/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Desc.     � Manda e-mail de aviso de cobranca para titulos vencidos 	  ���
���          � e a vencer                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Depto Financeiro                                           ���
��������������������������������������������������������������������������ٱ�
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.     				  ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR     � DATA   � MOTIVO DA ALTERACAO                        ���
�������������������������������������������������������������������������Ĵ��
���Alessandra Costa �08/02/11� Adaptacao as necessidades Spider           ���
���Thiago Queiroz 	�03/07/13� Adaptacao as necessidades Spider           ���
���Thiago Queiroz 	�11/07/13� Correcao de erros                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CobMail()

public lenv, NNUMTIT, ntotd, CTXTPREV

CTXTPREV := ""
//lenv:=.f.


IF TYPE("cUSUARIO") == "U"
	//	RpcsetEnv("01","01","Administrador","MS05V7","u_pagodia","Oficial",{"SM0","SA1","SE1"})
	RpcsetEnv("01","01","Administrador","Dino@2012","u_CobMail","Desenv",{"SM0","SA1","SE1"})
	//lenv := .t.
ENDIF

ddiaant := ddatabase-val(getmv("MV_COBMANT"))
ddiadep	:= ddatabase+val(getmv("MV_COBMDEP"))

MsAguarde({|| U_TitCalc()},"Selecionando Titulos","Aguarde..")

//Processa( {|| U_TitCalc() },"Selecionando Titulos","Aguarde...." )

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function TitCalc()


movant   	:= {}
movVenc  	:= {}
ccliente	:= ""
cportad		:= ""
cagport 	:= ""
cfatura  	:= ""
dvencto  	:= ctod("")
nvalor   	:= ndias := 0


DbSelectArea("SE1")
DbSetOrder(7)  //  Data Vencimento+Nome Cliente+Prefixo+Titulo+Parcela
Set Filter To SE1->E1_VENCREA >= ddiaant .AND. SE1->E1_VENCREA <= ddiadep 
DBGOTOP()

ProcRegua(RecCount())

DO WHILE !EOF() .AND. SE1->E1_VENCREA >= ddiaant .AND. SE1->E1_VENCREA <= ddiadep
	
	IF (SE1->E1_SALDO == 0 .or. AllTrim(SE1->E1_TIPO)!="NF") .or. ALLTRIM(SE1->E1_PREFIXO) != "02"  // Descarta titulos de retencoes
		DBSKIP()
		LOOP
	ENDIF
	
	cfatura 	:= SE1->E1_NUM + "/" + SE1->E1_PARCELA
	//cportad	:= SE1->E1_PORTADOR
	//cagport 	:= SE1->E1_AGEDEP
	cCedente	:= "Spider Capacetes" //SM0->M0_NOME
	cNossoNum	:= SE1->E1_NUMBCO
	dvencto  	:= SE1->E1_VENCREA
	nvalor   	:= SE1->E1_SALDO
	ndias    	:= ddatabase - SE1->E1_VENCREA
	ccod     	:= SE1->E1_CLIENTE + SE1->E1_LOJA
	cfilial  	:= SE1->E1_FILIAL
	ccliente	:= GETADVFVAL("SA1","A1_NOME",XFILIAL("SA1")+cCOD,1,"")	//SE1->E1_NOMCLI
	cCNPJ  		:= GETADVFVAL("SA1","A1_CGC",XFILIAL("SA1")+cCOD,1,"")		//SE1->E1_NOMCLI
	
	cchave   	:= SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	cemail1  	:= GETADVFVAL("SA1","A1_EMAIL",XFILIAL("SA1")+cCOD,1,"")
	cemail2  	:= SPACE(50)//"thigo@stch.com.br" //GETADVFVAL("SA1","A1_EMAIL2",XFILIAL("SA1")+cCOD,1,"")
	cemail3  	:= SPACE(50) //GETADVFVAL("SA1","A1_EMAIL3",XFILIAL("SA1")+cCOD,1,"")
	
	IF (ndias <= 0 .and. -1*(nDias) <= val(getmv("MV_COBMANT"))).and. !EMPTY(cemail1) 
		aadd(movAnt ,{ccliente,cfatura,dvencto,nvalor,ndias,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cNossoNum,cCedente,cCNPJ})
	ENDIF
	
	IF ndias > 0 .and. !EMPTY(cemail1)
		aadd(movVenc ,{ccliente,cfatura,dvencto,nvalor,ndias,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cNossoNum,cCedente,cCNPJ})
	ENDIF
	
	
	incproc(ccliente)
	dbskip()
ENDDO


//Gera email para Titulos a Vencer ou vencendo no dia
amovtoc := ASort(movAnt,,,{|x,y|x[3]<y[3]})    	// em seguida, ordena por data vencto
amovtob := ASort(amovtoc,,,{|x,y|x[1]<y[1]})    	// ordena por cliente
xcli 	:= "" //iif(len(amovtob)>0,amovtob[1,1],"")

for G:=1 to len(amovtob)
	if amovtob[g,1] == xcli  //.or. g == len(amovtob)
		G++
		LOOP
	ELSE
		/*
		if  g != len(amovtob)
			g		:= g-1
		endif
		*/
		//IF EMPTY(ALLTRIM(XCLI))
		xcli 		:= amovtob[G,1]
		//ENDIF
		
		msg2		:= montahtml1(1)
		
		// checa os tres emails do cliente
		cVENDMA		:= lower(alltrim(amovtob[g,9]))
		cass		:= "Lembrete de Vencimento"
		
		IF !EMPTY( cVENDMA )
			U_SENDMAIL(cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  	:= lower(alltrim(amovtob[g,10]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL(cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  	:= lower(alltrim(amovtob[g,11]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL(cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		//U_SENDMAIL("cobranca@spidercapacetes.com.br;nikolas@spidercapacetes.com.br",cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		U_SENDMAIL("thiago@stch.com.br",cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		
		/*
		if	g	!= len(amovtob)
			g	:= g+1
		endif
		/*/
		xcli 	:= amovtob[g,1]
	endif
	
Next G


//Gera email para Titulos  Vencidos
amovtoc := ASort(movVenc,,,{|x,y|x[3]<y[3]})    // em seguida, ordena por data vencto
amovtob := ASort(amovtoc,,,{|x,y|x[1]<y[1]})    // ordena por cliente
xcli 	:= "" //iif(len(amovtob)>0,amovtob[1,1],"")

for G:=1 to len(amovtob)
	if amovtob[g,1] == xcli  //.or. g == len(amovtob)
		G++
		LOOP
	ELSE
		/*
		if  g != len(amovtob)
			g		:= g-1
		endif
		*/
		//IF EMPTY(ALLTRIM(XCLI))
		xcli 		:= amovtob[G,1]
		//ENDIF
		
		msg2		:= montahtml1(2)

		// checa os tres emails do cliente
		cVENDMA		:= lower(alltrim(amovtob[g,9]))
		cass		:= "Aviso ref. cobran�a em atraso"
		
		IF !EMPTY( cVENDMA )
			U_SENDMAIL(cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,10]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL(cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,11]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL(cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		U_SENDMAIL("cobranca@spidercapacetes.com.br;nikolas@spidercapacetes.com.br",cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		U_SENDMAIL("thiago@stch.com.br",cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		/*
		if	g	!= len(amovtob)
			g	:= g+1
		endif
		*/
		xcli 	:= amovtob[g,1]
	endif
	
Next G

return

////////////////////////////////////////////////////////////////////////////////////
// monta html para n avisos
Static Function montahtml1(naviso)



XCRLF := CHR(13) + CHR(10)
PRIVATE VVV:=""
VVV:=iif(naviso==1,"Apenas um lembrete...","Aviso ref. Cobran�a em atraso")


xMSG1 := '<html><head><title>' + alltrim(str(naviso))+ '</title>' 																				+ XCRLF + ;
'<p style= "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0">'																+ XCRLF + ;
'<table><tr><td VALIGN="TOP"><img src="logoweb_Linci.jpg"></td><td VALIGN="MIDDLE"><img src="logoweb_Spider.jpg"></td></tr></table></p><br>'	+ XCRLF + ;
'<p style="line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0"></p><br>' 														+ XCRLF + ; 
'<p style="line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0"><font face="Arial" size="3">' + "Prezado "  + '<b>' + /*xCli*/ amovtob[g,1] + '</b><br>'+ TRANSFORM(amovtob[g,14],"@R 99.999.999/9999-99") +'</font></p><br>' + XCRLF +;
'<p style="line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0"><font face="Arial" size="2">' + IIF(naviso==1,"Voce esta recebendo um lembrete de vencimento de duplicatas, conforme detalhamento abaixo:","Nosso sistema constatou que os boletos abaixo est�o em aberto:") + '</font></p><br>' + XCRLF

//
xmsg2:=  SUBTOT1(naviso)

ctxt1:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Caso n�o tenha recebido o boleto, por favor entre em contato urgente. <br>Se o pagamento ja foi realizado, favor desconsiderar essa mensagem. <br> <br>Atenciosamente, "+ "</font></p><br>" + XCRLF
ctxt2:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "No caso de duvidas,ou n�o tenha recebido o boleto, entre em contato com nosso departamento de cobran�a .<br>Evite despesas adicionais com cobran�a via Serasa.<br><br>Caso ja tenha realizado o pagamento, favor desconsiderar essa mensagem.<br><br>Atenciosamente, " + "</font></p><br>" + XCRLF

ctxt := IIF(naviso==1,ctxt1,ctxt2)

xmsg3:="<br>"  																																	+ XCRLF + ;
"</b>"+ ctxt  																																	+ XCRLF + ;
"</b><p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + ;
"Departamento Financeiro -  Cobran�a <br> Tel.: (011) 2304-2541  <br>E-mail: cobranca@spidercapacetes.com.br<br>" + "</font></p>" 				+ XCRLF

Return(xmsg1+xmsg2+xmsg3)

///////////////////////////////////////////////////////////////////////////////////////////
//Monta tabela com valores e duplicatas
Static Function SUBTOT1(naviso)
xMSG2 := "<table border=" + chr(34) + "0" + chr(34) + "width=" + chr(34) + "600"+ chr(34) +  ">" 												+ XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2" color="#FFFFFF">' +  "Cedente" 		+ '</td>'	+ XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="300" align="center" ><font face="Arial" size="2" color="#FFFFFF">' +  "Duplicata"  		+ '</td>' 	+ XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2" color="#FFFFFF">' +  "Nosso Numero" 	+ '</td>' 	+ XCRLF + ; 
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="96" align="center"  ><font face="Arial" size="2" color="#FFFFFF">' +  "Vencimento"   	+ '</td>' 	+ XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="105" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + IIF(naviso==1,"Dias para Vencimento","Dias em atraso")+ '</td>' + XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="105" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Valor R$"  		+ '</td>' 	+ XCRLF + ;
'<tr>' 																																			+ XCRLF

// LOOP DE ITENS RESUMO
xMSG3 	:= ""
ctt  	:= ""
ntota 	:= 0
ntotb 	:= 0
ntotc 	:= 0
ntotd 	:= 0
nnumtit	:= 0
nPosCli	:= aScan(aMovtoB,{ |x| AllTrim(x[1]) == alltrim(amovtob[g,1])} )

//FOR F:=1 TO LEN(AMOVTOB)
FOR F:=nPosCli TO LEN(AMOVTOB)
	if amovtob[F,1] != amovtob[g,1]
		loop
	endif
	
	ctt		:= '<tr>' 																															+ XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' + amovtob[F,13]  	+ '</td>' 	+ XCRLF + ;      //'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,7]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="300" align="center"><font face="Arial" size="2">' + amovtob[F,2]  		+ '</td>' 	+ XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' + amovtob[F,12]  	+ '</td>' 	+ XCRLF + ;  		//'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,13]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="096" align="center"><font face="Arial" size="2">' + DTOC(amovtob[F,3])	+ '</td>' 	+ XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="096" align="center"><font face="Arial" size="2">' + IIF(amovtob[F,5]<0,(transform(-(amovtob[F,5]),"@E 999")),transform(amovtob[F,5],"@E 999")) + '</td>' + XCRLF + ;  //	'<td style="border-style: solid; border-width: 1" width="96" align="center"><font face="Arial" size="2">' + transform(amovtob[F,5],"@E 999") + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="096" align="right" ><font face="Arial" size="2">' + transform(amovtob[F,4],"@E 9,999,999.99") + '</td>' + XCRLF + ;
	'</tr>' 																																	+ XCRLF
	xmsg3 	:= xmsg3 + ctt
	
	// total natureza
	ntota 	:= ntota + amovtob[f,4]
	nnumtit := nnumtit + 1
	
next f

xmsg3:= xmsg3 + '<td style="border-style: solid; border-width: 0" width="96" colspan="5"></td>'  												+ XCRLF + ;
'<td style="border-style: solid; border-width: 2" width="96" align="right"><font face="Arial" size="2"><b>' + transform(ntota,"@E 9,999,999.99") + '</b></td>'  + XCRLF +	 ;
'<tr></table>'  																																+ XCRLF

Return(xmsg2+xmsg3)

//////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SENDMAIL(_cPARA,_cASSUNTO,_cCORPO,NUMTIT,VALOR,clicli,previa)
// 			U_SENDMAIL("alessandra@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntota,amovtob[g,1],.F.)

XCONTA	:= GETMV("MV_RELACNT") // "cobranca@spidercapacetes.com.br"//
XPASS	:= GETMV("MV_RELPSW")  // "COM2589"
_cDE	:= "cobranca@spidercapacetes.com.br"
//_cPara	:= "thiago@stch.com.br;cobranca@spidercapacetes.com.br;comercial@spidercapacetes.com.br"

IF !PREVIA
	aFiles := {}
	//aFiles := {"\System\logoweb_Linci.jpg","\System\logoweb_Spider.jpg"}
	aFiles := {"\System\logoweb_Spider.jpg"}
	CONNECT SMTP SERVER "secure17.0net.com.br" ACCOUNT XCONTA PASSWORD XPASS RESULT lResult   // SMTP.EMAIL.COM.BR
	if GETMV("MV_RELAUTH")
		lAuth := mailauth(XCONTA,XPASS)
	ENDIF
	
	//lresult := .F.
	If lResult
		SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT ATTACHMENT afiles[1] RESULT lresult
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			Help(" ",1,"ATENCAO",,"SEND MAIL" + cError,4,5)
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,"SMTP" + cError,4,5)
	EndIf
	/*DISCONNECT SMTP SERVER
	
	IF !LRESULT
	CONNECT SMTP SERVER "201.20.1.5" ACCOUNT "supertech" PASSWORD "stch**2010"   // SMTP.EMAIL.COM.BR
	mailauth("supertech","stch**2010")
	lresult := .F.
	SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT ATTACHMENT aFiles[1]   RESULT lresult
	DISCONNECT SMTP SERVER
ENDIF */
ELSE
	CTXTPREV += clicli + "   " + _cPARA + "  " + _cASSUNTO + "  " + _cCORPO + "  " + NUMTIT + "  " + TRANSFORM(VALOR,"999,999,999.99")
ENDIF

RETURN(lresult)
