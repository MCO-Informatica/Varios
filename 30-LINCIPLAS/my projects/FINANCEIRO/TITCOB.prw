#include "rwmake.ch"
#include "ap5mail.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³U_TITCOB   ³Autor  ³Alessandra Costa      ³ Data ³ 07/02/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc.     ³ Envio automatico de email de cobrança para titulos a vencer³±±
±±³          ³ em 5 dias ou menos e títulos atrasados                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Linciplas                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
        

User Function CobMail()

public lenv, NNUMTIT, ntotd, CTXTPREV

CTXTPREV := ""
lenv:=.f.


IF TYPE("cUSUARIO") == "U"
	//	RpcsetEnv("01","01","Administrador","MS05V7","u_pagodia","Oficial",{"SM0","SA1","SE1"})
	RpcsetEnv("01","01","Administrador","stch**2010","u_pagodia","Baseteste",{"SM0","SA1","SE1"})
	lenv := .t.
ENDIF  

ddiaant := ddatabase-(val(getmv("MV_COBMANT"))
ddiadep	:= ddatabase+(val(getmv("MV_COBMDEP"))

Processa( {|| U_TitCalc() },'Selecionando Titulos.. ' )



Return
 


User Function TitCalc()

DbSelectArea("SE1")
DbSetOrder(7)  //  Data Vencimento+Nome Cliente+Prefixo+Titulo+Parcela
DBGOTOP()

ProcRegua(RecCount()) 

DO WHILE !EOF() .AND. SE1->E1_VENCREA <= ddiaant
	
	IF SE1->E1_SALDO == 0 .or. AllTrim(SE1->E1_TIPO)!="NF"  // Descarta titulos de retencoes
		DBSKIP()
		LOOP
  	ENDIF 
  	
  	ccliente	:= SE1->E1_NOMCLI
	cfatura 	:= SE1->E1_NUM + "/" + SE1->E1_PARCELA
	cportad		:= SE1->E1_PORTADOR
	cagport 	:= SE1->E1_AGEDEP
	dvencto  	:= SE1->E1_VENCREA
	nvalor   	:= SE1->E1_SALDO
	ndias    	:= ddatabase - SE1->E1_VENCREA
	ccod     	:= SE1->E1_CLIENTE + SE1->E1_LOJA
	cfilial  	:= SE1->E1_FILIAL
	
	cchave   	:= SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	cemail1  	:= "alessandra@stch.com.br" //GETADVFVAL("SA1","A1_EMAIL",XFILIAL("SA1")+cCOD,1,"")
	cemail2  	:= SPACE(50) //GETADVFVAL("SA1","A1_EMAIL2",XFILIAL("SA1")+cCOD,1,"")
	cemail3  	:= SPACE(50) //GETADVFVAL("SA1","A1_EMAIL3",XFILIAL("SA1")+cCOD,1,"")
	
  	IF ndias >= 0 .and. !EMPTY(cemail1)
			aadd(movAnt ,{ccliente,cfatura,dvencto,nvalor,ndias,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cportad,cagport})
	ENDIF
	
	IF ndias < 0 .and. !EMPTY(cemail1)
			aadd(movVenc ,{ccliente,cfatura,dvencto,nvalor,ndias,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cportad,cagport})
	ENDIF


	incproc(ccliente)
	dbskip()
ENDDO 	


//Gera email para Titulos  Vencer ou vencendo no dia
amovtoc := ASort(movAnt,,,{|x,y|x[3]<y[3]})    // em seguida, ordena por data vencto
amovtob := ASort(amovtoc,,,{|x,y|x[1]<y[1]})    // ordena por cliente
xcli 	:= iif(len(amovtob)>0,amovtob[1,1],"")

for G:=1 to len(amovtob)     
if amovtob[g,1] != xcli  .or. g == len(amovtob)
		if  g	!= len(amovtob)
			g	:= g-1
		endif
		msg2		:= montahtml1(1)
		
		// checa os tres emails do cliente
		cVENDMA		:= lower(alltrim(amovtob[g,9]))
		cass		:= "Lembrete de Vencimento"
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("alessandra@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,10]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("alessandra@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,11]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("alessandra@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
	   	if	g	!= len(amovtob)
			g	:= g+1
		endif
		xcli 	:= amovtob[g,1]
	endif
	
Next G 


//Gera email para Titulos  Vencidos
amovtoc := ASort(movVenc,,,{|x,y|x[3]<y[3]})    // em seguida, ordena por data vencto
amovtob := ASort(amovtoc,,,{|x,y|x[1]<y[1]})    // ordena por cliente
xcli 	:= iif(len(amovtob)>0,amovtob[1,1],"")

for G:=1 to len(amovtob)     
if amovtob[g,1] != xcli  .or. g == len(amovtob)
		if  g	!= len(amovtob)
			g	:= g-1
		endif
		msg2		:= montahtml1(2)
		
		// checa os tres emails do cliente
		cVENDMA		:= lower(alltrim(amovtob[g,9]))
		cass		:= "Aviso de Cobrança"
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("alessandra@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,10]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("alessandra@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,11]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("alessandra@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.) 
		ENDIF
		
	   	if	g	!= len(amovtob)
			g	:= g+1
		endif
		xcli 	:= amovtob[g,1]
	endif
	
Next G    

return     

// monta html para n avisos
Static Function montahtml1(naviso)


XCRLF := CHR(13) + CHR(10)
//PRIVATE VVV:=""
VVV:=iif(naviso==1,"Lembrete de Vencimento","Aviso de Cobrança"))
xMSG1 := "<html>" 			        + XCRLF +			        ;
"<head>"			         + XCRLF + ;
"<title>"+alltrim(str(naviso))+  "</title>" + XCRLF + ;
"</head>"			        	+ XCRLF +  ;
"<img src=" + chr(34) + "image001.jpg"  + chr(34) + "><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "</font></p><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '" align="center"><b><font face="Arial" size="5">' +alltrim(str(naviso))+ "</font></b></p><br><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="3">' + "Prezado Cliente -  "  +  amovtob[G,1] + "</font></p><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' +"&nbsp;&nbsp;&nbsp;Att.: Departamento de Contas a Pagar." + XCRLF + "<br>" + ;
"&nbsp;&nbsp;&nbsp;Ref.: " + IIF(naviso==1,"Duplicata(s) a Vencer.","Duplicata(s) Vencida(s).")+ "</font></p><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Conforme informaça(o bancaria a(s) duplicata(s) abaixo relacionada(s) na(o consta(m) como paga(s) até o momento" + "</font></p>" + XCRLF


xmsg2:=  SUBTOT1()

ctxt1:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "MSG Para titulos que vao vencer <br> <br>Atenciosamente, "+ "</font></p><br>" + XCRLF
ctxt2:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "MSG Para Titulos vencidos <br> <br>Atenciosamente, " + "</font></p><br>" + XCRLF

ctxt := IIF(naviso==1,ctxt1,ctxt2)

xmsg3:="<br>"  + XCRLF +	 ;
"</b>"+ ctxt  + XCRLF +;
"</b>Departamento Financeiro -  Cobrança <br> Tel.: 11 9999-9999<br>Fax:  11 9999-9999<br>e-mail: xxx@xxx.com.br<br>"

Return(xmsg1+xmsg2+xmsg3)


//Monta tabela com valores e duplicatas
Static Function SUBTOT1()
xMSG2 := "<table border=" + chr(34) + "0" + chr(34) + "width=" + chr(34) + "600"+ chr(34) +  ">" + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2">' +  "Cliente" + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2">' +  "Filial" + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="300" align="center" ><font face="Arial" size="2">' +  "Duplicata"  + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="150" align="center" ><font face="Arial" size="2">' +  "Banco" + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="150" align="center" ><font face="Arial" size="2">' +  "Agencia"  + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="96" align="center"><font face="Arial" size="2">' +  "Vencimento"   + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="105" align="center"><font face="Arial" size="2">' +  "Dias de Atraso" + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="105" align="center"><font face="Arial" size="2">' + "Valor R$"  + '</td>' + XCRLF + ;
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
	if amovtob[F,1] != xcli
		loop
	endif
	
	ctt:='<tr>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  left(amovtob[F,6],6)  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,7]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="300" align="center"><font face="Arial" size="2">' +  amovtob[F,2]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,12]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,13]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="96" align="center"><font face="Arial" size="2">' + DTOC(amovtob[F,3]) + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="96" align="center"><font face="Arial" size="2">' + transform(amovtob[F,5],"@E 999") + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="96" align="right"><font face="Arial" size="2">' + transform(amovtob[F,4],"@E 9,999,999.99") + '</td>' + XCRLF + ;
	'</tr>' + XCRLF
	xmsg3 := xmsg3 + ctt
	
	// total natureza
	ntota :=  ntota + amovtob[f,4]
	ntotb :=  ntotb + amovtob[f,6]
	ntotc :=  ntotc + amovtob[f,7]
	ntotd :=  ntotd + amovtob[f,8]
	nnumtit := nnumtit + 1
	
next f

xmsg3:= xmsg3 + '<td style="border-style: solid; border-width: 0" width="96" colspan="7"></td>'  + XCRLF +	 ;
'<td style="border-style: solid; border-width: 2" width="96" align="right"><font face="Arial" size="2"><b>' + transform(ntota,"@E 9,999,999.99") + '</b></td>'  + XCRLF +	 ;
'<tr></table>'  + XCRLF

Return(xmsg2+xmsg3)


User Function SENDMAIL(_cDE,_cPARA,_cASSUNTO,_cCORPO,NUMTIT,VALOR,clicli,previa)

IF !PREVIA
	aFiles := {}
	aFiles := { "\SigaAdv\image001.jpg"}
	CONNECT SMTP SERVER "201.20.1.5" ACCOUNT "supertech" PASSWORD "stch**2010"   // SMTP.EMAIL.COM.BR
	mailauth("supertech","stch**2010")
	lresult := .F.
	SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT ATTACHMENT aFiles[1]   RESULT lresult
	DISCONNECT SMTP SERVER
	
	IF !LRESULT
		CONNECT SMTP SERVER "201.20.1.5" ACCOUNT "supertech" PASSWORD "stch**2010"   // SMTP.EMAIL.COM.BR
		mailauth("supertech","stch**2010")
		lresult := .F.
		SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT ATTACHMENT aFiles[1]   RESULT lresult
		DISCONNECT SMTP SERVER
	ENDIF
	
	//LOG DE ENVIO DE E-MAIL
	dbselectarea("SZ4")
	reclock("SZ4",.t.)
	
	SZ4->Z4_DATA	:= dDATABASE
	SZ4->Z4_HORA	:= LEFT(TIME(),5)
	SZ4->Z4_PARA	:= _cPARA
	SZ4->Z4_ASSUNTO	:= alltrim(clicli) + " " + _cASSUNTO
	SZ4->Z4_NUMTIT	:= NUMTIT
	SZ4->Z4_VALOR	:= round(VALOR,2)
	SZ4->Z4_SUCESSO	:= lresult
	MSUNLOCK()
ELSE
	CTXTPREV += clicli + "   " + _cPARA + "  " + _cASSUNTO + "  " + _cCORPO + "  " + NUMTIT + "  " + TRANSFORM(VALOR,"999,999,999.99")
ENDIF

RETURN( lresult)
