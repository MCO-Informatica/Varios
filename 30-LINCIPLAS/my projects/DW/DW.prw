#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "ap5mail.ch"

// *--------------------------------------------------*
User Function MANAGER(cli,ana)
// *--------------------------------------------------*

ASZ2 := GETAREA()
CRET := "Aberto"
AHD  := {}


dbselectarea("SZ2")
dbsetorder(2)
DBGOTOP()
DO WHILE !EOF()
	IF !EMPTY(CLI) .AND. SZ2->Z2_CLIENTE != CLI
		DBSKIP()
		LOOP
	ENDIF
	IF !EMPTY(ANA) .AND. SZ2->Z2_TECNICO != ANA
		DBSKIP()
		LOOP
	ENDIF
	POSINI := aScan(aHD, {|x| Upper(Alltrim(x[1])) == SZ2->Z2_NUM })
	IF POSINI == 0
		AADD(AHD,{SZ2->Z2_NUM,SZ2->Z2_SITCHAM,SZ2->Z2_USUARIO, CTOD(SUBS(SZ2->Z2_DEADLIN,7,2)+"/"+SUBS(SZ2->Z2_DEADLIN,5,2)+"/"+SUBS(SZ2->Z2_DEADLIN,3,2)), U_TECNOME(SZ2->Z2_TECNICO),SZ2->Z2_CLIENTE,SZ2->Z2_TECNICO})
	ELSE
		AHD[POSINI][2] := SZ2->Z2_SITCHAM
		AHD[POSINI][3] := SZ2->Z2_USUARIO
		AHD[POSINI][4] := CTOD(SUBS(SZ2->Z2_DEADLIN,7,2)+"/"+SUBS(SZ2->Z2_DEADLIN,5,2)+"/"+SUBS(SZ2->Z2_DEADLIN,3,2))
		AHD[POSINI][5] := U_TECNOME(SZ2->Z2_TECNICO)
		AHD[POSINI][6] := SZ2->Z2_CLIENTE
		AHD[POSINI][7] := SZ2->Z2_TECNICO
	ENDIF
	dbskip()
ENDDO
//aDD := ASort(aHD,,,{|x,y|x[4]<y[4]})
IF LEN(AHD) > 0
	aCC := ASort(aHD,,,{|x,y|x[2]<y[2]})
	XCRLF := CHR(13) + CHR(10)
	cTEXTO := "<HTML><HEAD><TITLE>Relatório Gerencial de Atendimento Help Desk Supertech Consulting - Atualizado em " + dtoc(ddatabase) + " - " + time() + "</TITLE></HEAD>" + xcrlf
	cTEXTO += '<br>'+ xcrlf + ;
	'<TABLE width=600 border=0 cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" cellpadding="2">'+ xcrlf + ;
	'  <TBODY>'+ xcrlf + ;
	'  <TR>'+ xcrlf + ;
	'    <TD '+ xcrlf + ;
	'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #999999" '+ xcrlf + ;
	'    width=50>'+ xcrlf + ;
	'      <DIV align=center><FONT face=TAHOMA size=1>Nr.Chamado</FONT></DIV></TD>'+ xcrlf + ;
	'    <TH '+ xcrlf + ;
	'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #999999" '+ xcrlf + ;
	'    width=150>'+ xcrlf + ;
	'      <DIV align=center><FONT face=TAHOMA size=1>Usuário Solicitante</FONT></DIV></TH>'+ xcrlf + ;
	'    <TH '+ xcrlf + ;
	'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #999999" '+ xcrlf + ;
	'    width=50>'+ xcrlf + ;
	'      <DIV align=center><FONT face=TAHOMA size=1>Previsão Conclusão</FONT></DIV></TH>'+ xcrlf + ;
	'    <TH '+ xcrlf + ;
	'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #999999" '+ xcrlf + ;
	'    width=50>'+ xcrlf + ;
	'      <DIV align=center><FONT face=TAHOMA size=1>Analista Alocado</FONT></DIV></TH>'+ xcrlf + ;
	'    <TH '+ xcrlf + ;
	'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #999999" '+ xcrlf + ;
	'    width=50>'+ xcrlf + ;
	'      <DIV align=center><FONT face=TAHOMA size=1>Situação Chamado</FONT></DIV></TH>'+ xcrlf
	
	cttt := "x"
	nccc := 0
	FOR F:=1 TO LEN(aCC)
		if cttt != aCC[f][2]
			if nccc > 0
				cTEXTO += '<p><FONT face=TAHOMA size=1>Total de Chamados na situação ' + alltrim(cret) + ' : ' + transform(nccc,"@E 999") + '</p>' + XCRLF
			endif
			cttt := aCC[f][2]
			nccc := 0
		endif
		cret := aCC[f][2]
		DO CASE
			CASE CRET == "1"
				CRET := "Aberto"
			CASE CRET == "2"
				CRET := "Aguardando Retorno do Cliente em 4 horas úteis"
			CASE CRET == "3"
				CRET := "Encerrado"
		ENDCASE
		//cTEXTO += '<a href="http://supertech.ddns.com.br:90/Chamados/'+ aCC[f][1] +'.htm">' + aCC[f][1] + '-' + aCC[f][3] + '- Data Limite Conclusão: ' + aCC[f][4] +' - Situação: '+ cret +'</a><br>' + XCRLF
		
		cTEXTO += '<TR>'+ xcrlf + ;
		'    <TD '+ xcrlf + ;
		'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #ffffff" '+ xcrlf + ;
		'    width=50>'+ xcrlf + ;
		'      <DIV align=center><FONT face=TAHOMA size=1></b><a href="http://supertech.ddns.com.br:90/Chamados/'+ aCC[f][1] +'.htm">'+ aCC[f][1] +'</a></FONT></DIV></TD>'+ xcrlf + ;
		'    <TH '+ xcrlf + ;
		'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #ffffff" '+ xcrlf + ;
		'    width=150>'+ xcrlf + ;
		'      <DIV align=left><FONT face=TAHOMA size=1>' + aCC[f][3] +'<BR></FONT></DIV></TH>'+ xcrlf + ;
		'    <TH '+ xcrlf + ;
		'   style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #ffffff" '+ xcrlf + ;
		'    width=50>'+ xcrlf + ;
		'      <DIV align=center><FONT face=TAHOMA size=1>' + DTOC(aCC[f][4]) + '</FONT></DIV></TH>'+ xcrlf + ;
		'    <TH '+ xcrlf + ;
		'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #ffffff" '+ xcrlf + ;
		'    width=50>'+ xcrlf + ;
		'      <DIV align=center><FONT face=TAHOMA size=1>' + aCC[f][5] + '</FONT></DIV></TH>'+ xcrlf + ;
		'    <TH '+ xcrlf + ;
		'    style="BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid; BORDER-BOTTOM: 1px solid; BACKGROUND-COLOR: #ffffff" '+ xcrlf + ;
		'    width=50>'+ xcrlf + ;
		'      <DIV align=center><FONT face=TAHOMA size=1>' + iif(aCC[f][4]<=ddatabase.AND.aCC[f][2]=='1','ATRASADO',cret )  + '</FONT></DIV></TH>'+ xcrlf
		nccc ++
	NEXT F
	if nccc > 0
		cTEXTO += '<p><FONT face=TAHOMA size=1>Total de Chamados na situação ' + alltrim(cret) + ' : ' + transform(nccc,"@E 999") + '</p>' + XCRLF
	endif
	
	cTEXTO += '</HTML>' + XCRLF
	
	CNOME := "MANAGER"
	CMAIL := ""
	IF !EMPTY(CLI)
		CNOME := ALLTRIM(GETADVFVAL("SA1","A1_NREDUZ",XFILIAL("SA1")+CLI,1,""))
		CMAIL := ALLTRIM(GETADVFVAL("SA1","A1_MANAGER",XFILIAL("SA1")+CLI,1,""))
	ENDIF
	IF !EMPTY(ANA)
		CNOME := ALLTRIM(U_TECNOME(ANA))
		CMAIL := ALLTRIM(U_TECMAIL(ANA))
	ENDIF
	_cARQ0    := "\system\HelpDesk\portal1\Chamados\" + CNOME +".htm"
	_nHandle0 := FCreate(_cARQ0)
	FWrite(_nHandle0,ctexto)
	FClose(_nHandle0)
	
	// envio email
	apara    := {}
	cVENDMA  := "thiago@stch.com.br"
	cASSUNTO := ".:: Relação de Chamados Help Desk - " + cnome + " ::."
	
	// ENVIA EMAIL
	XSERV := GETMV("MV_RELSERV")
	XCONTA := "workflow@linciplas.com.br"   //GETMV("MV_RELACNT")
	XPASS := "work2589@" // GETMV("MV_RELPSW")
	XCTA2 := "workflow@linciplas.com.br"   //GETMV("MV_RELACNT")
	
	//apara := {}
	IF !EMPTY(CMAIL)
		aadd(apara,CMAIL)  // enviar para o analista OU CLIENTE
	ENDIF
	aadd(apara,"thiago@stch.com.br")  // coordenador
	//aadd(apara,"marco@stch.com.br")  // monitoramento
	
	//aadd(apara,"helpdesk.supertech@terra.com.br")  // alerta do terra
	
	CONNECT SMTP SERVER XSERV ACCOUNT XCONTA PASSWORD XPASS RESULT lResult
	mailauth(XCTA2,XPASS)
	
	If lResult
		
		FOR i := 1 TO LEN(aPARA)
			if !empty(alltrim(aPARA[i]))
				SEND MAIL FROM XCONTA to  aPARA[i] SUBJECT cASSUNTO BODY ctexto FORMAT TEXT   	RESULT lResult
				If !lResult
					//Erro no envio do email
					GET MAIL ERROR cError
					conout(" Erro envio e-mail " + cError)
				else
					conout("Mensagem enviada para " + alltrim(lower(APARA[i])) + " com sucesso")
				EndIf
			endif
		NEXT i
		DISCONNECT SMTP SERVER
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
	EndIf
	
	
ENDIF
Return
