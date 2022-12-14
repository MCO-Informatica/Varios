#include "rwmake.ch"
#include "ap5mail.ch"


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????Ŀ??
???Programa  ?cobranca   ?Autor  ?Marco A. Montini      ? Data ? 05/07/04 ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Desc.     ? Manda e-mail de aviso de vencimento da CTPS				  ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Uso       ? Gest?o de Pessoal                                          ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.     				  ???
?????????????????????????????????????????????????????????????????????????Ĵ??
??? PROGRAMADOR     ? DATA   ? MOTIVO DA ALTERACAO                        ???
?????????????????????????????????????????????????????????????????????????Ĵ??
???Thiago Queiroz   ?06/06/11? Adaptacao as necessidades Linciplas        ???
??????????????????????????????????????????????????????????????????????????ٱ?
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/


User Function CTPSMail()

public lenv, NNUMTIT, ntotd, CTXTPREV

CTXTPREV := ""
//lenv:=.f.


IF TYPE("cUSUARIO") == "U"
	//	RpcsetEnv("01","01","Administrador","MS05V7","u_pagodia","Oficial",{"SM0","SA1","SE1"})
	RpcsetEnv("01","01","Administrador","stch**2010","u_CTPSMAIL","Linciplas",{"SM0","SRA","SRJ"})
	//lenv := .t.
ENDIF

ddiaant := ddatabase-val(getmv("MV_COBMANT"))
ddiadep	:= ddatabase+val(getmv("MV_COBMDEP"))

MsAguarde({|| U_CTPSCalc()},"Selecionando Titulos","Aguarde..")

//Processa( {|| U_CTPSCalc() },"Selecionando Titulos","Aguarde...." )

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function CTPSCalc()

movant   	:= {}
aTodos		:= {}
movVenc  	:= {}
ccliente	:= ""
cportad		:= ""
cagport 	:= ""
cfatura  	:= ""
dvencto  	:= ctod("")
nvalor   	:= ndias := 0


DbSelectArea("SRA")
DbSetOrder(1)  //  Data Vencimento+Nome Cliente+Prefixo+Titulo+Parcela
//Set Filter To SE1->E1_VENCREA >= ddiaant .AND. SE1->E1_VENCREA <= ddiadep .AND. (SE1->E1_CLIENTE ='000040' .or. SE1->E1_CLIENTE ='000037')
DBGOTOP()

ProcRegua(RecCount())

DO WHILE !EOF() //.AND.  // .AND. SE1->E1_VENCREA <= ddiadep
	
	IF ddatabase-SRA->RA_DESCTPS <= 180 .OR. ALLTRIM(DTOS(SRA->RA_DEMISSA)) != ""
		DBSKIP()
		LOOP
	ENDIF
	
	cMatricula 	:= SRA->RA_MAT //SE1->E1_NUM + "/" + SE1->E1_PARCELA
	cCedente	:= SM0->M0_NOME
	cNomeFunc	:= SRA->RA_NOME
	dDtAdmis  	:= SRA->RA_ADMISSA
	dDtUltAtu  	:= SRA->RA_DESCTPS
	ndias    	:= ddatabase-SRA->RA_DESCTPS
	cFuncao    	:= GETADVFVAL("SRJ", "RJ_DESC",XFILIAL("SRJ")+SRA->RA_CODFUNC,1,"")
	cfilial  	:= SRA->RA_FILIAL
	ccliente	:= ""//GETADVFVAL("SA1","A1_NOME",XFILIAL("SA1")+cCOD,1,"")//SE1->E1_NOMCLI
	cCNPJ  		:= ""//GETADVFVAL("SA1","A1_CGC",XFILIAL("SA1")+cCOD,1,"")//SE1->E1_NOMCLI
	
	cchave   	:= SRA->RA_FILIAL+SRA->RA_MAT //SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	cemail1  	:= "thiago@stch.com.br" //GETADVFVAL("SA1","A1_EMAIL",XFILIAL("SA1")+cCOD,1,"")
	cemail2  	:= SPACE(50)//"thigo@stch.com.br" //GETADVFVAL("SA1","A1_EMAIL2",XFILIAL("SA1")+cCOD,1,"")
	cemail3  	:= SPACE(50) //GETADVFVAL("SA1","A1_EMAIL3",XFILIAL("SA1")+cCOD,1,"")
	
	IF ndias >= 180 .and. !EMPTY(cemail1)
		aadd(movAnt ,{cNomeFunc,cMatricula,dDtAdmis,dDtUltAtu,ndias,cFuncao,cfilial,cchave,cemail1,cemail2,cemail3,"",cCedente,""})
	ENDIF
	
	//IF ndias > 0 .and. !EMPTY(cemail1)
	//		aadd(movVenc ,{ccliente,cfatura,dvencto,nvalor,ndias,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cNossoNum,cCedente,cCNPJ})
	//ENDIF
	
	
	incproc(ccliente)
	dbskip()
ENDDO


//Gera email para Titulos  Vencer ou vencendo no dia
amovtoc := ASort(movAnt,,,{|x,y|x[5]<y[5]})    // em seguida, dias em atraso
amovtob := ASort(amovtoc,,,{|x,y|x[2]<y[2]})    //] ordena por FUN??O/CARGO
xcli 	:= iif(len(amovtob)>0,amovtob[1,1],"")

// ----------------------------------------------------------------------------
for G:=1 to len(amovtob)
if g == len(amovtob)
		if  g	!= len(amovtob)
			g	:= g-1
		endif
msg2		:= montahtml2(1)

U_ENVIAEMAIL("claudinei@linciplas.com.br","Atualiza??o da Carteira de Trabalho",msg2,nnumtit,"",aMovtob[g,1],.F.)
U_ENVIAEMAIL("rh@linciplas.com.br","Atualiza??o da Carteira de Trabalho",msg2,nnumtit,"",aMovtob[g,1],.F.)
U_ENVIAEMAIL("thiago@stch.com.br","Atualiza??o da Carteira de Trabalho",msg2,nnumtit,"",aMovtob[g,1],.F.)

if	g	!= len(amovtob)
	g	:= g+1
endif
xcli 	:= amovtob[g,1]
endif

Next G




return

////////////////////////////////////////////////////////////////////////////////////
// monta html para n avisos
Static Function montahtml2(naviso)

XCRLF := CHR(13) + CHR(10)
PRIVATE VVV:=""
VVV:=iif(naviso==1,"Apenas um lembrete...","Aviso ref. Cobran?a em atraso")

// MENSAGEM DO CABE?ALHO
xMSG1 := '<html><head><title>' + alltrim(str(naviso))+ '</title>' + XCRLF +  ;
'<p style= "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0">'+ XCRLF + ;
'<table><tr><td VALIGN="TOP"><img src="logoweb_Linci.jpg"></td><td VALIGN="MIDDLE"><img src="logoweb_Spider.jpg"></td></tr></table></p><br>' + XCRLF + ;
'<p style="line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0"></p><br>' + XCRLF + ;
'<p style="line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0"><font face="Arial" size="3">' + "Bom dia, " + XCRLF + ;
'<p style="line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0"><font face="Arial" size="2">' + "? necess?rio realizar a atualiza??o das carteiras de trabalho dos funcion?rios abaixo:" + '</font></p><br>' + XCRLF

// MENSAGEM AP?S A RELA??O DE CARTEIRAS SEM ATUALIZA??O
xmsg2:=  SUBTOT2(naviso)

ctxt1:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Os Funcion?rios acima est?o a mais de 180 dias (6 meses) sem que suas Carteiras de Trabalho sejam atualizadas e/ou verificadas. "+ "</font></p><br>" + XCRLF
ctxt2:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Os Funcion?rios acima est?o a mais de 180 dias (6 meses) sem que suas Carteiras de Trabalho sejam atualizadas e/ou verificadas. "+ "</font></p><br>" + XCRLF

ctxt := IIF(naviso==1,ctxt1,ctxt2)

// RODAP?
xmsg3:="<br>"  + XCRLF +	 ;
"</b>"+ ctxt  + XCRLF +;
"</b><p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + ;
"------------------------------ <br> Desenvolvido por Supertech Consulting. <BR><BR><BR> Enviado automaticamente pelo sistema Protheus. <BR> " + "</font></p>" + XCRLF

Return(xmsg1+xmsg2+xmsg3)

//////////////////////////////////////////
//Monta tabela com valores e duplicatas //
//////////////////////////////////////////
Static Function SUBTOT2(naviso)
xMSG2 := "<table border=" + chr(34) + "0" + chr(34) + "width=" + chr(34) + "600"+ chr(34) +  ">" + XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Matricula"	+ '</td>' + XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="999" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Nome"			+ '</td>' + XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="225" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "DT Admissao"	+ '</td>' + XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="250" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Fun??o"		+ '</td>' + XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="225" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Ult Atualizacao"	+ '</td>' + XCRLF + ;
'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="300" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Dias Sem Atualizar"	+ '</td>' + XCRLF + ;
'<tr>' + XCRLF

// LOOP DE ITENS RESUMO
xMSG3 	:= ""
ctt  	:= ""
ntota 	:= 0
ntotb 	:= 0
ntotc 	:= 0
ntotd 	:= 0
nnumtit	:= 0


FOR F:=1 TO LEN(AMOVTOB)
	//if amovtob[F,1] != xcli
	//	loop
	//endif
	
	ctt:='<tr>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' + amovtob[F,2]			+ '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="999" align="center"><font face="Arial" size="2">' + amovtob[F,1]			+ '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="225" align="center"><font face="Arial" size="2">' + DTOC(amovtob[F,3])		+ '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="250" align="center"><font face="Arial" size="2">'  + amovtob[F,6]			+ '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="225" align="center"><font face="Arial" size="2">' + DTOC(amovtob[F,4])		+ '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-widtadmin h: 1" width="300" align="center"><font face="Arial" size="2">' + transform(amovtob[F,5],"@E 999999")	+ '</td>' + XCRLF + ;
	'</tr>' + XCRLF
	
	xmsg3 := xmsg3 + ctt
	
	// total natureza
	//ntota :=  ntota + amovtob[f,4]
	//nnumtit := nnumtit + 1
	
next f

xmsg3:= xmsg3 + '<tr></table>'  + XCRLF

Return(xmsg2+xmsg3)

//////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ENVIAEMAIL(_cPARA,_cASSUNTO,_cCORPO,NUMTIT,VALOR,clicli,previa)
//U_ENVIAEMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,"",amovtob[g,1],.F.)

XCONTA	:= "comercial01@spidercapacetes.com.br"//GETMV("MV_RELACNT")
XPASS	:= "COME2589"  //GETMV("MV_RELPSW")
_cDE	:= "comercial01@spidercapacetes.com.br"

IF !PREVIA
	aFiles := {}
	aFiles := {"\System\logoweb_Linci.jpg","\System\logoweb_Spider.jpg"}
	CONNECT SMTP SERVER "secure17.0net.com.br" ACCOUNT XCONTA PASSWORD XPASS RESULT lResult   // SMTP.EMAIL.COM.BR
	if GETMV("MV_RELAUTH")
		mailauth(XCONTA,XPASS)
	ENDIF
	
	//lresult := .F.
	If lResult
		SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT ATTACHMENT afiles[1], afiles[2] RESULT lresult
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
	/* DISCONNECT SMTP SERVER
	
	IF !LRESULT
	CONNECT SMTP SERVER "201.20.1.5" ACCOUNT "supertech" PASSWORD "stch**2010"   // SMTP.EMAIL.COM.BR
	mailauth("supertech","stch**2010")
	lresult := .F.
	SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT ATTACHMENT aFiles[1]   RESULT lresult
	DISCONNECT SMTP SERVER
	ENDIF
	*/
ELSE
	CTXTPREV += clicli + "   " + _cPARA + "  " + _cASSUNTO + "  " + _cCORPO + "  " + NUMTIT + "  " + TRANSFORM(VALOR,"999,999,999.99")
ENDIF

RETURN(lresult)
