#include "rwmake.ch"
#include "protheus.ch"
#include "ap5mail.ch"
/////////////////////////////////////////////////////////////////////
// *************************************************************** //
// PONTO DE ENTRADA LOGO APOS A GRAVACAO DA SOLICITACAO DE COMPRAS //
// *************************************************************** //
/////////////////////////////////////////////////////////////////////
USER FUNCTION MT110GRV()

	PUBLIC cNumSC	:= SC1->C1_NUM
	PUBLIC cNumIt	:= SC1->C1_ITEM
	nCont	:= 1

	//U_WRKFLOW()

	DbSelectArea("SC1")
	DbSetOrder(1)
	DbSeek(xFilial("SC1")+cNumSC+cNumIt)

	While !Eof() .AND. cNumSC == SC1->C1_NUM .AND. cNumIt == "0001"

		IF nCont == 1

			//MSGBOX("TESTE - " + SC1->C1_PRODUTO + " - " + SC1->C1_DESCRI + " - " + str(ncont))
			U_SCCalc(cNumSC, cNumIt)

			nCont++
		ENDIF

		DBSKIP()
	ENDDO

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³cobranca   ³Autor  ³Marco A. Montini      ³ Data ³ 05/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc.     ³ Manda e-mail de aviso de Inclusão de SC					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras			                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.     				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR     ³ DATA   ³ MOTIVO DA ALTERACAO                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Thiago Queiroz   ³10/06/11³ Adaptacao as necessidades Linciplas        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ScCalc(SComp,NProd)

	Local g		:= 0

	public lenv, NNUMTIT, ntotd, CTXTPREV

	movant   	:= {}
	aTodos		:= {}
	movVenc  	:= {}
	ccliente	:= ""
	cportad		:= ""
	cagport 	:= ""
	cfatura  	:= ""
	dvencto  	:= ctod("")
	nvalor   	:= ndias := 0

	DbSelectArea("SC1")
	DbSetOrder(1)
	DbSeek(xFilial("SC1")+SComp+NProd)
	//DBGOTOP()
	ProcRegua(RecCount())

	DO WHILE !EOF()

		IF SCOMP != SC1->C1_NUM
			DBSKIP()
			LOOP
		ENDIF

		cNumSC 		:= SC1->C1_NUM
		cItem		:= SC1->C1_ITEM
		cProduto	:= SC1->C1_PRODUTO
		cDescri  	:= SC1->C1_DESCRI
		cUM 	 	:= SC1->C1_UM
		nQuant    	:= SC1->C1_QUANT
		dDtNec    	:= SC1->C1_DATPRF
		dDtEmis 	:= SC1->C1_EMISSAO
		cCodForn	:= SC1->C1_FORNECE
		cFornecedor	:= GETADVFVAL("SA2", "A2_NREDUZ",XFILIAL("SA2")+SC1->C1_FORNECE+SC1->C1_LOJA,1,"")
		cSolicit	:= SC1->C1_SOLICIT

		cchave   	:= SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM
		cemail1  	:= "thiago@stch.com.br"
		cemail2  	:= SPACE(50)
		cemail3  	:= SPACE(50)

		IF !EMPTY(cemail1)
			aadd(movAnt ,{cNumSC,cItem,cProduto,cDescri,cUM,nQuant,dDtNec,dDtEmis,cCodForn,cFornecedor,cSolicit,cchave,cemail1,cemail2,cemail3})
		ENDIF

		incproc(ccliente)
		dbskip()
	ENDDO


	//Gera email para Titulos  Vencer ou vencendo no dia
	amovtoc := ASort(movAnt,,,{|x,y|x[2]>y[2]})    // em seguida, dias em atraso
	amovtob := ASort(amovtoc,,,{|x,y|x[1]>y[1]})    //] ordena por FUNÇÃO/CARGO
	xcli 	:= iif(len(amovtob)>0,amovtob[1,1],"")

	// ----------------------------------------------------------------------------
	for g := 1 to len(amovtob)
		if g == len(amovtob)
			if  g	!= len(amovtob)
				g	:= g-1
			endif
			msg2		:= montahtml3()
			//U_SCOMPRAEMAIL("danielle@linciplas.com.br","Solicitação de Compra: "+ cNumSc,msg2,nnumtit,"",aMovtob[g,1],.F.)
			//U_SCOMPRAEMAIL("paulo@linciplas.com.br","Solicitação de Compra: "+ cNumSc,msg2,nnumtit,"" ,aMovtob[g,1],.F.)
			//U_SCOMPRAEMAIL("thiago@stch.com.br"    ,"Solicitação de Compra: "+ cNumSc,msg2,nnumtit,"",amovtob[g,1],.F.)
			U_SCOMPRAEMAIL("compras@linearplastico.com.br","Solicitação de Compra: "+ cNumSc,msg2,nnumtit,"" ,aMovtob[g,1],.F.)
			if	g	!= len(amovtob)
				g	:= g+1
			endif
			xcli 	:= amovtob[g,1]
		endif
	Next G

return

////////////////////////////////////////////////////////////////////////////////////
// monta html para n avisos
Static Function montahtml3()
	Local f := 0

	XCRLF := CHR(13) + CHR(10)
	PRIVATE VVV:=""
	//VVV:=iif(naviso==1,"Apenas um lembrete...","Aviso ref. Cobrança em atraso")

	// MENSAGEM DO CABEÇALHO
	xMSG1 := '<html><head><title>' +"Solicitação de Compra: "+ cNumSc + '</title>' + XCRLF +  ;
		'<p style= "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0"></p><br>' + XCRLF + ;
		'</font></p><br>' + XCRLF

	// MENSAGEM APÓS A RELAÇÃO DE CARTEIRAS SEM ATUALIZAÇÃO
	xmsg2 := '<tr><td height=22 colspan=2 valign=middle><div align=left><span class=style5>Número da Solicitação de Compra:</span>'		+ XCRLF + ;
		'<td colspan=10 valign=middle><span class=style3>'+cNumSC+'</span></td></tr></div></td>' 											+ XCRLF + ;
		'<tr><td height=22 colspan=2 valign=middle><div align=left><span class=style5>Fornecedor:</span>' 									+ XCRLF + ;
		'<td colspan=10 valign=middle><span class=style3>'+cCodForn+cFornecedor+'</span></td></tr></div></td>' 								+ XCRLF + ;
		'<tr><td height=22 colspan=2 valign=middle><div align=left><span class=style5>Solicitante:</span>' 									+ XCRLF + ;
		'<td colspan=10 valign=middle><span class=style3>'+cSolicit+'</span></td></tr></div></td>' 											+ XCRLF

	/////////////////////////////////////////////////////////////
	//////////////////////////////////////////
	//Monta tabela com valores e duplicatas //
	//////////////////////////////////////////
	xMSG2 += "<table border=" + chr(34) + "0" + chr(34) + "width=" + chr(34) + "600"+ chr(34) +  ">" + XCRLF + ;
		'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="200" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Item"				+ '</td>'+ XCRLF + ;
		'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="499" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Produto"			+ '</td>' + XCRLF + ;
		'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="525" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Descrição"		+ '</td>' + XCRLF + ;
		'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="250" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Un. Medida"		+ '</td>' + XCRLF + ;
		'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="225" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Quantidade"		+ '</td>' + XCRLF + ;
		'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="300" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Necessidade"		+ '</td>' + XCRLF + ;
		'<td style="background-color: #236B8E; border-style: solid; border-width: 1" width="300" align="center" ><font face="Arial" size="2" color="#FFFFFF">' + "Emissão"			+ '</td>' + XCRLF + ;
		'<tr>' + XCRLF

	// LOOP DE ITENS RESUMO
	xMSG3 	:= ""
	ctt  	:= ""
	ntota 	:= 0
	ntotb 	:= 0
	ntotc 	:= 0
	ntotd 	:= 0
	nnumtit	:= 0

	FOR f := 1 TO LEN(AMOVTOB)
		//if amovtob[F,1] != xcli
		//	loop
		//endif
		ctt:='<tr>' + XCRLF + ;
			'<td style="border-style: solid; border-width: 1" width="200" align="center"><font face="Arial" size="2">' + amovtob[F,2]			+ '</td>' + XCRLF + ;
			'<td style="border-style: solid; border-width: 1" width="499" align="center"><font face="Arial" size="2">' + amovtob[F,3]			+ '</td>' + XCRLF + ;
			'<td style="border-style: solid; border-width: 1" width="525" align="center"><font face="Arial" size="2">' + amovtob[F,4]			+ '</td>' + XCRLF + ;
			'<td style="border-style: solid; border-width: 1" width="250" align="center"><font face="Arial" size="2">' + amovtob[F,5]			+ '</td>' + XCRLF + ;
			'<td style="border-style: solid; border-width: 1" width="225" align="center"><font face="Arial" size="2">' + transform(amovtob[F,6],"@E 99999.99")		+ '</td>' + XCRLF + ;
			'<td style="border-style: solid; border-width: 1" width="225" align="center"><font face="Arial" size="2">' + DTOC(amovtob[F,7])		+ '</td>' + XCRLF + ;
			'<td style="border-style: solid; border-width: 1" width="225" align="center"><font face="Arial" size="2">' + DTOC(amovtob[F,8])		+ '</td>' + XCRLF + ;
			'</tr>' + XCRLF

		xmsg3 := xmsg3 + ctt
	next f
	// RODAPÉ
	xmsg3+="<tr></table><br>"  + XCRLF +	 ;
		"</b>" + XCRLF +;
		"</b><p style=" + chr(34) + "line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0" + chr(34) + '"><font face="Arial" size="2">' + ;
		"------------------------------ <br> Desenvolvido por Supertech Consulting. <BR><BR><BR> Enviado automaticamente pelo sistema Protheus. <BR> " + "</font></p>" + XCRLF
	//xmsg3:= xmsg3 +   + XCRLF
	cHtml := xmsg1+xmsg2+xmsg3
	/////////////////////////////////////////////////////////////

Return(cHtml)


//////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SCOMPRAEMAIL(_cPARA,_cASSUNTO,_cCORPO,NUMTIT,VALOR,clicli,previa)
	//U_SCOMPRAEMAIL("thiago@stch.com.br",cVENDMA,cass,msg2,nnumtit,"",amovtob[g,1],.F.)

	//XCONTA	:= "comercial01@spidercapacetes.com.br"//GETMV("MV_RELACNT")
	//XPASS	:= "com2589"  //GETMV("MV_RELPSW")
	//XPASS	:= "cml2289"  //GETMV("MV_RELPSW")
	//_cDE	:= "comercial01@spidercapacetes.com.br"

	//xConta	:= "workflow@linciplas.com.br"
	//xPass	:= "work2589@"
	//_cDE	:= "workflow@linciplas.com.br"
	_cDE	:= "compras@linearplastico.com.br"

	cServer  := "webmail.linearplastico.com.br"//AllTrim(GetNewPar("MV_RELSERV"," "))
	cAccount := "compras@linearplastico.com.br"//AllTrim(GetNewPar("MV_RELACNT"," "))
	cPassword:= "3X9Vp5N7@h"//AllTrim(GetNewPar("MV_RELPSW" ," "))
	cUserAut := "compras@linearplastico.com.br"//Alltrim(GetMv("MV_RELAUSR",,""))
	cPassAut := "3X9Vp5N7@h"//Alltrim(GetMv("MV_RELAPSW",,""))
	nTimeOut := GetMv("MV_RELTIME",,120)
	lAuth    := GetMv("MV_RELAUTH",,.F.)
	_cDE	 := cUserAut

	IF !PREVIA
		//CONNECT SMTP SERVER "201.20.1.5" ACCOUNT xConta PASSWORD xPass TIMEOUT nTimeOut RESULT lResult
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut RESULT lResult
		if lAuth .and. lResult
			If !mailauth(cUserAut,cPassAut)
				GET MAIL ERROR cError
				DISCONNECT SMTP SERVER RESULT lResult
				Return .F.
			EndIf
		ENDIF

		If lResult
			aFiles := {}
			aFiles := {"\System\logoweb_Linci.jpg","\System\logoweb_Spider.jpg"}
			//SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT ATTACHMENT afiles[1], afiles[2] RESULT lresult
			SEND MAIL FROM _cDE to _cPARA  SUBJECT _cASSUNTO BODY _cCORPO FORMAT TEXT RESULT lresult
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

	ELSE
		CTXTPREV += clicli + "   " + _cPARA + "  " + _cASSUNTO + "  " + _cCORPO + "  " + NUMTIT + "  " + TRANSFORM(VALOR,"999,999,999.99")
	ENDIF

RETURN(lresult)
