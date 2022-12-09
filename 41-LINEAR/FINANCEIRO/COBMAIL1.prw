#include "rwmake.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³cobranca   ³Autor  ³Marco A. Montini      ³ Data ³ 05/07/04 ³±±
±±³Adaptacao ³           ³       ³Flavio F Mattos       ³ Data ³ 16/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc.     ³ Manda e-mail de aviso de cobranca para titulos vencidos    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Depto Financeiro                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Function U_PAGODIA(LPREV)
Function U_PAGODIA()

public lenv, NNUMTIT, ntotd, CTXTPREV

//if type("LPREV") == "U"
//	LPREV := .F.
//endif

CTXTPREV := ""
lenv:=.f.
LVAI:=.t.

IF TYPE("cUSUARIO") == "U"
	//	RpcsetEnv("01","01","Administrador","MS05V7","u_pagodia","Oficial",{"SM0","SA1","SE1"})
	RpcsetEnv("01","01","Administrador","stch**2010","u_pagodia","Baseteste",{"SM0","SA1","SE1"})
	lenv := .t.
ENDIF

IF  lenv
	dbselectarea("SX1")
	dbsetorder(1)
	dbseek("PAGTO201",.t.)
	ddiapag  := VAL(X1_CNT01)
	
	dbseek("PAGTO202",.t.)
	ddiapag2 := VAL(X1_CNT01)
	
	dbseek("PAGTO203",.t.)
	ddiapag3 :=VAL(X1_CNT01)
	
	dbseek("PAGTO204",.t.)
	nmulta   :=VAL(X1_CNT01)
	
	dbseek("PAGTO205",.t.)
	njuros   :=VAL(X1_CNT01)
	
	dbseek("PAGTO206",.t.)
	nlimite  := VAL(X1_CNT01)
	codcli   := ""
	emailuni := "XXX"
	ATUBASE  := 1
ELSE
	LVAI	 := PERGUNTE("PAGTOS")
	ddiapag  := MV_PAR01
	ddiapag2 := MV_PAR02
	ddiapag3 := MV_PAR03
	nmulta   := MV_PAR04
	njuros   := MV_PAR05
	nlimite  := MV_PAR06
	codcli   := MV_PAR07 + MV_PAR08
	emailuni := MV_PAR09
	ATUBASE  := MV_PAR10
ENDIF

IF LVAI
	Processa( {|| _fCALCU() },'Calculando Titulos em Atraso ' )
ENDIF
Return


////////////////////////////////////////////////////
// Calcula titulos em aberto                      //
////////////////////////////////////////////////////
Static Function _fCALCU()

amovto   	:= {}
amovto1  	:= {}
amovto2  	:= {}
amovto3  	:= {}
ccliente	:= ""
cportad		:= ""
cagport 	:= ""
cfatura  	:= ""
dvencto  	:= ctod("")
nvalor   	:= ndias := vmulta := vjuros := nsaldo := natr1 := natr2 := natr3 := 0
gg			:=1

DbSelectArea("SE1")
DbSetOrder(7)  //  Data Vencimento+Nome Cliente+Prefixo+Titulo+Parcela
DBGOTOP()

ProcRegua(RecCount())

DO WHILE !EOF() .AND. SE1->E1_VENCREA <= (ddatabase - ddiapag)
	
	IF SE1->E1_SALDO == 0 .or. AllTrim(SE1->E1_TIPO)!="NF"  // Descarta titulos de retencoes
		DBSKIP()
		LOOP
	ENDIF
	IF !EMPTY(codcli)
		IF SE1->E1_CLIENTE + SE1->E1_LOJA != CODCLI
			DBSKIP()
			LOOP
		ENDIF
	ENDIF
	
	natr1		:= natr2 := natr3 := 0
	ccliente	:= SE1->E1_NOMCLI
	cfatura 	:= SE1->E1_NUM + "/" + SE1->E1_PARCELA
	cportad		:= SE1->E1_PORTADOR
	cagport 	:= SE1->E1_AGEDEP
	dvencto  	:= SE1->E1_VENCREA
	nvalor   	:= SE1->E1_SALDO
	ndias    	:= ddatabase - SE1->E1_VENCREA
	vmulta   	:= SE1->E1_SALDO * (nmulta/100)
	vjuros   	:= (SE1->E1_SALDO * (njuros/100)) * ndias
	nsaldo   	:= nvalor + vmulta + vjuros
	ccod     	:= SE1->E1_CLIENTE + SE1->E1_LOJA
	cfilial  	:= SE1->E1_FILIAL
	dt1email 	:= "SE1->E1_AVISO1"
	dt2email 	:= "SE1->E1_AVISO2"
	dt3email 	:= "SE1->E1_AVISO3"
	
	cchave   	:= SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	cemail1  	:= "thiago@stch.com.br" //GETADVFVAL("SA1","A1_EMAIL",XFILIAL("SA1")+cCOD,1,"")
	cemail2  	:= SPACE(50) //GETADVFVAL("SA1","A1_EMAIL2",XFILIAL("SA1")+cCOD,1,"")
	cemail3  	:= SPACE(50) //GETADVFVAL("SA1","A1_EMAIL3",XFILIAL("SA1")+cCOD,1,"")
	
	//cING     	:= GETADVFVAL("SA1","A1_INGLES",XFILIAL("SA1")+cCOD,1,"")
	cING     	:= "N"
	
	IF !EMPTY(emailuni) .and. !empty(codcli)
		cemail1	:= emailuni
		cemail2	:= ""
		cemail3	:= ""
	ENDIF
	
	cTPCOB 		:= "3"
	
	IF  cTPCOB == "1" .AND. !("1"$SE1->E1_PREFIXO) .OR. cTPCOB == "2" .AND. !("FAT"$SE1->E1_PREFIXO)
	ELSE
		IF ddiapag > 0 .and. ndias >= ddiapag .and. IIF(!EMPTY(emailuni),.T.,EMPTY(SE1->E1_AVISO1))
			aadd(amovto1,{ccliente,cfatura,dvencto,nvalor,ndias,vmulta,vjuros,nsaldo,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cing,cportad,cagport,dt1email,dt2email,dt3email})
		ENDIF
		
		IF ddiapag2 > 0 .and. ndias >= ddiapag2 .and.IIF(!EMPTY(emailuni),.T.,EMPTY(SE1->E1_AVISO2))
			aadd(amovto2,{ccliente,cfatura,dvencto,nvalor,ndias,vmulta,vjuros,nsaldo,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cing,cportad,cagport,dt1email,dt2email,dt3email})
		ENDIF
		
		IF ddiapag3 > 0 .and. ndias >= ddiapag3 .and. IIF(!EMPTY(emailuni),.T.,EMPTY(SE1->E1_AVISO3))
			aadd(amovto3,{ccliente,cfatura,dvencto,nvalor,ndias,vmulta,vjuros,nsaldo,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cing,cportad,cagport,dt1email,dt2email,dt3email})
		ENDIF
		
	ENDIF
	
	incproc(ccliente)
	dbskip()
ENDDO

if len(amovto1) + len(amovto2) + len(amovto3) == 0
	msgbox("Nenhum registro foi encontrado. Verifique parametros de cliente e dias de atraso")
endif

//Gera email para primeiro atraso
amovtoc := ASort(amovto1,,,{|x,y|x[3]<y[3]})    // em seguida, ordena por data vencto
amovtob := ASort(amovtoc,,,{|x,y|x[1]<y[1]})    // ordena por cliente
xcli 	:= iif(len(amovtob)>0,amovtob[1,1],"")

for G:=1 to len(amovtob)
	
	if amovtob[g,1] != xcli  .or. g == len(amovtob)
		if  g	!= len(amovtob)
			g	:= g-1
		endif
		msg2		:= montahtml1(1)
		
		// checa os tres emails do cliente
		cVENDMA		:= lower(alltrim(amovtob[g,12]))
		cass		:= IIF(amovtob[G,15]=="N","Primeiro Aviso de Cobrança", "First Notice")
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,13]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		cVENDMA  := lower(alltrim(amovtob[g,14]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		
		IF !EMPTY(alltrim(amovtob[g,12])+alltrim(amovtob[g,13])+alltrim(amovtob[g,14]))
			IF ATUBASE == 1
				//atualiza SE1
				dbselectarea("SE1")
				dbsetorder(1)
				if dbseek(amovtob[g,11],.t.)
					reclock("SE1",.f.)
					SE1->E1_AVISO1 := dDATABASE
					MsUnlock()
				endif
			ENDIF
		ENDIF
		if	g	!= len(amovtob)
			g	:= g+1
		endif
		xcli 	:= amovtob[g,1]
	endif
	
Next G

//Gera email para segundo atraso
amovtoc := ASort(amovto2,,,{|x,y|x[3]<y[3]})    // ordena por data vencto
amovtob := ASort(amovtoc,,,{|x,y|x[1]<y[1]})    // ordena por cliente
xcli 	:= iif(len(amovtob)>0,amovtob[1,1],"")

for G	:= 1 to len(amovtob)

	if amovtob[g,1] != xcli
		if	g	!= len(amovtob)
			g	:= g-1
		endif
		msg2	:= montahtml1(2)
		// checa os tres emails do cliente
		cVENDMA	:= lower(alltrim(amovtob[g,12]))
		cass 	:= IIF(amovtob[G,15]=="N","Segundo Aviso de de Cobrança Eletronica", "Second Notice")
		
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		cVENDMA  := lower(alltrim(amovtob[g,13]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		cVENDMA  := lower(alltrim(amovtob[g,14]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		IF !EMPTY(alltrim(amovtob[g,12])+alltrim(amovtob[g,13])+alltrim(amovtob[g,14]))
			IF ATUBASE == 1
				//atualiza SE1
				dbselectarea("SE1")
				dbsetorder(1)
				if dbseek(amovtob[g,11],.t.)
					reclock("SE1",.f.)
					SE1->E1_AVISO2 := dDATABASE
					MsUnlock()
				endif
			ENDIF
		ENDIF
		
		if	g	!= len(amovtob)
			g	:= g+1
		endif
		xcli	:= amovtob[g,1]
	endif
Next G

//Gera email para terceiro atraso
amovtoc := ASort(amovto3,,,{|x,y|x[3]<y[3]})    // ordena por data vencto
amovtob := ASort(amovtoc,,,{|x,y|x[1]<y[1]})    // ordena por cliente
xcli	:= iif(len(amovtob)>0,amovtob[1,1],"")
for G	:= 1 to len(amovtob)
	if amovtob[g,1] != xcli
		if	g	!= len(amovtob)
			g	:= g-1
		endif
		msg2	:= montahtml1(3)
		
		// checa os tres emails do cliente
		cVENDMA	:= lower(alltrim(amovtob[g,12]))
		cass 	:= IIF(amovtob[G,15]=="N","Terceiro Aviso de de Cobrança Eletronica", "Third Notice")
		
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		cVENDMA  := lower(alltrim(amovtob[g,13]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		cVENDMA  := lower(alltrim(amovtob[g,14]))
		IF !EMPTY( cVENDMA )
			U_SENDMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,ntotd,amovtob[g,1],.F.)
		ENDIF
		IF !EMPTY(alltrim(amovtob[g,12])+alltrim(amovtob[g,13])+alltrim(amovtob[g,14]))
			IF ATUBASE == 1
				//atualiza SE1
				dbselectarea("SE1")
				dbsetorder(1)
				if dbseek(amovtob[g,11],.t.)
					reclock("SE1",.f.)
					SE1->E1_AVISO3 := dDATABASE
					MsUnlock()
				endif
			ENDIF
		ENDIF
		if g!=len(amovtob)
			g:=g+1
		endif
		xcli := amovtob[g,1]
	endif
Next G


// monta html para n avisos
Static Function montahtml1(naviso)
// 00/00/00.
//      1            2            3             4         5          6          7          8         9        10      11            12           13          14        15        16          17            18            19            20
// ccliente,cfatura,dvencto,nvalor,ndias,vmulta,vjuros,nsaldo,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cing,cportad,cagport,dt1email,dt2email,dt3email
//

XCRLF := CHR(13) + CHR(10)
PRIVATE VVV:=""
VVV:=iif(naviso==1,"st",iif(naviso==3,"th","nd"))
xMSG1 := "<html>" 			        + XCRLF +			        ;
"<head>"			         + XCRLF + ;
"<title>"+alltrim(str(naviso))+  IIF(amovtob[G,15]=="N","o Aviso de Cobrança", VVV + " Notice") + "</title>" + XCRLF + ;
"</head>"			        	+ XCRLF +  ;
"<img src=" + chr(34) + "image001.jpg"  + chr(34) + "><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "</font></p><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '" align="center"><b><font face="Arial" size="5">' + alltrim(str(naviso))+  IIF(amovtob[G,15]=="N","s, Aviso de Cobrança", VVV + " Notice")  + "</font></b></p><br><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="3">' + "Prezado Cliente -  "  +  amovtob[G,1] + "</font></p><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' +"&nbsp;&nbsp;&nbsp;Att.: Departamento de Contas a Pagar." + XCRLF + "<br>" + ;
"&nbsp;&nbsp;&nbsp;Ref.: Duplicata(s) Vencida(s)." + "</font></p><br>" + XCRLF + ;
"<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Conforme informaça(o bancaria a(s) duplicata(s) abaixo relacionada(s) na(o consta(m) como paga(s) na data de seu(s) vencimento(s):" + "</font></p>" + XCRLF


xmsg2:=  SUBTOT1()

//texto portugues

ctxt1:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Agradeceriamos entrar em contato com o departamento abaixo mencionado para verificaça(o e conhecimento do valor dos encargos financeiro a serem pagos e outros esclarecimentos. <br> <br>Atenciosamente, "+ "</font></p><br>" + XCRLF
ctxt2:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Em " + dtoc(amovtob[G,18]) + " , enviamos um e-mail a Vas.Sas. solicitando que nos informasse sobre o pagamento da(s) mesma(s). Até a presente data na(o recebemos nenhuma resposta." +  ;
" Alertamos que o(s) citado(s) titulo(s) foi(foram) negociado(s) com a Instituiça(o Financeira já citada acima, estando sujeito a medidas que o Banco julgar conveniente. <br> <br>Atenciosamente, " + "</font></p><br>" + XCRLF
ctxt3:= "<p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + "Apreciariamos, antes de qualquer decisa(o mais drástica, que Vas.Sas. entrassem em contato conosco para que em conjunto possamos solucionar o problema relativo ao atraso no pagamento da(s) mesma(s). <br> <br>Atenciosamente, " + "</font></p><br>" + XCRLF

//texto ingles
//ctxt3I:= "In case the payments have been made, please send us the swift number in order to get touch with Bank Boston to find out what has happened.<br>If there is anything that depends on us regarding the issue let me know.<br>Thanking you in advance for yor prompt answer I send you my best regards. "
//ctxt4I:= "We are waiting for your payments until " + dtoc(amovtob[G,3]+nlimite)+ ". Otherwise, services will not provide from "  + dtoc(amovtob[G,3]+nlimite+10) + " on."

ctxt := IIF(naviso==1,ctxt1,IIF(naviso==2,ctxt2,IIF(naviso==3,ctxt3,"")))

xmsg3:="<br>"  + XCRLF +	 ;
"</b>"+ ctxt  + XCRLF +;
"</b>Departamento Financeiro -  Cobrança <br> Tel.: 11 5095-9926<br>Fax:  11 5093-0461<br>e-mail: cobranca@lanpro.com.br<br>"

Return(xmsg1+xmsg2+xmsg3)
//      1            2            3             4         5          6          7          8         9        10      11            12           13          14        15        16          17            18            19            20
// ccliente,cfatura,dvencto,nvalor,ndias,vmulta,vjuros,nsaldo,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cing,cportad,cagport,dt1email,dt2email,dt3email
// monta tabela com duplicatas e valores
Static Function SUBTOT1()
xMSG2 := "<table border=" + chr(34) + "0" + chr(34) + "width=" + chr(34) + "600"+ chr(34) +  ">" + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Cliente","Client") + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Filial","Branch ") + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="300" align="center" ><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Duplicata","Invoice")    + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="150" align="center" ><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Banco","Banc") + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="150" align="center" ><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Agencia","Agenc")    + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="96" align="center"><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Vencimento","Due Date")    + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="105" align="center"><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Dias de Atraso","Number Of Days")    + '</td>' + XCRLF + ;
'<td style="background-color: #999999; border-style: solid; border-width: 1" width="105" align="center"><font face="Arial" size="2">' +  iif(amovtob[G,15]=="N", "Valor R$","Amount R$")    + '</td>' + XCRLF + ;
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
	
	/*
	if f == LEN(AMOVTOB)
	ntota  :=  ntota  + amovtob[f,4]
	ntotb  :=  ntotb  + amovtob[f,6]
	ntotc  :=  ntotc  + amovtob[f,7]
	ntotd  :=  ntotd  + amovtob[f,8]
	endif
	*/
	
	//      1            2            3             4         5          6          7          8         9        10      11            12           13          14        15        16          17            18            19            20
	// ccliente,cfatura,dvencto,nvalor,ndias,vmulta,vjuros,nsaldo,ccod,cfilial,cchave,cemail1,cemail2,cemail3,cing,cportad,cagport,dt1email,dt2email,dt3email
	
	ctt:='<tr>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  left(amovtob[F,9],6)  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,10]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="300" align="center"><font face="Arial" size="2">' +  amovtob[F,2]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,16]  + '</td>' + XCRLF + ;
	'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' +  amovtob[F,17]  + '</td>' + XCRLF + ;
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

/////////////////////////////////////////////////////////////////////////////
Function U_LOGENV
axcadastro("SZ4","Log de envio de e-mail de cobranca")
Return

/////////////////////////////////////////////////////////////////////////////
Function U_PARNOT
PERGUNTE("PAGTO2")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a
a;a;ÉÍÍÍÍÍÍÍÍÍÍN'ÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍN'ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍN'ÍÍÍÍÍÍÍÍÍÍÍ
a;a;s,Programa  ?          s,Autor  ?Marco A. Montini    s, Data ?  05/07/04
a;a;s,Adaptacao ?          s,       ?Flavio F Mattos     s, Data ?  09/03/05
a;a;E(ÍÍÍÍÍÍÍÍÍÍR(ÍÍÍÍÍÍÍÍÍÍE;ÍÍÍÍÍÍÍD(ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍE;ÍÍÍÍÍÍD(ÍÍÍÍÍÍÍÍ
a;a;s,Desc.     ? Manda e-mail de aviso de cobranca para titulos vencidos
a;a;s,          ?
a;a;E(ÍÍÍÍÍÍÍÍÍÍR(ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
a;a;s,Uso       ? Depto Financeiro
a;a;C(ÍÍÍÍÍÍÍÍÍÍD(ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a;a
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function U_SENDMAIL(_cDE,_cPARA,_cASSUNTO,_cCORPO,NUMTIT,VALOR,clicli,previa)

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

/*
User Function USRMAIL()        // incluido pelo assistente de conversao do AP5 IDE em 24/06/02
SetPrvt("_DADUSER,_GRUPO,_NOMEUSER,I,")
_EMAIL := ""
_daduser:=_grupo:={}
_nomeuser:=substr(cusuario,7,15)
psworder(2)
if pswseek(_nomeuser,.t.)
_daduser:=pswret(1)
_email := _daduser[1,14]
endif
return(_EMAIL)
*/

