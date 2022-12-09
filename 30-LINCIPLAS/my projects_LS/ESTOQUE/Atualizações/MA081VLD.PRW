#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE 'TBICONN.CH'
#INCLUDE "rwmake.ch"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa	: MA081VLD
// Autor	: Alexandre Dalpiaz
// Data		: 18/06/08
// Função	: pe na validacao do TES - envia email com campos alterados ou todos os campos, na inclusao
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ma081vld()
////////////////////////
If Inclui .or. Altera
	Processa({|| GravaTes()})
EndIf

Return(.t.)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaTes()
//////////////////////////

ProcRegua(fCount())

_aCampos := {}
For _nI := 1 to fCount()
	
	IncProc()
	
	_cCampo  := alltrim(tran(FieldGet(_nI),''))
	_cVarMem := 'M->' + FieldName(_nI)
	
	If valtype(&_cVarMem) <>'U'
		_cVarMem := alltrim(tran(&_cVarMem,''))
	EndIf  
	
	/*
	nome campo
	descricao do campo
	pasta do campo
	conteudo original
	conteudo alterado	
	*/

	If altera .and. _cCampo <> _cVarMem

		_aArray := U__x3Campo(FieldName(_nI))
		If _aArray[2] == 1 .and. _aArray[3] == 1
			aAdd(_aCampos, {FieldName(_nI), _aArray[4], _aArray[5] , _cVarMem, _cCampo, _aArray[6]})
		EndIf

	ElseIf inclui 

		_aArray := U__x3Campo(FieldName(_nI))    
		If _aArray[2] == 1 .and. _aArray[3] == 1
			aAdd(_aCampos,{FieldName(_nI), _aArray[4], _aArray[5],  _cVarMem, '-x-', _aArray[6] })
		EndIf

	EndIf

Next
    
If len(_aCampos) == 0
	Return(.t.)
EndIf

aSort(_aCampos,,, {|_x, _y| _x[3] + _x[2] < _y[3] + _y[2] })

cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= UsrRetMail(RetCodUsr())
//MV_RELAUTH
cAssunto  	:= iif(inclui,"Inclusão","Alteração") + " de TES - Código: " + M->F4_CODIGO + " - Empresa: " + cEmpAnt + " - " + alltrim(SM0->M0_NOME) + " / Filial: " + cFilAnt + " - " + alltrim(SM0->M0_FILIAL)
xRecebe     := alltrim(GetMv('LS_MAILTES'))
If __cUserId $ GetMv('LA_PODER')
	//xRecebe     := 'adalpiaz'
	xRecebe     := 'fiscal'
EndIf
cRecebe 	:= ''

_nPosic     := at('/',xRecebe)
Do While _nPosic > 0
	cRecebe += left(xRecebe,_nPosic-1) + '@laselva.com.br;'
	xRecebe := substr(xRecebe,_nPosic+1)
	_nPosic := at('/',xRecebe)
EndDo

If len(xRecebe) > 0
	cRecebe += xRecebe + '@laselva.com.br'
ElseIf right(cRecebe,1) == ';'
	cRecebe := left(len(xRecebe)-1)
EndIf

_cHtml	 	:= cError    := ""

_cHtml += '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana"> ' + cAssunto + ' </h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + _cEnter

_cHtml += '<b><font size="2" face="Verdana">Alterado em: </font></b>'+'<b><font size="2" face="Verdana"> '+Dtoc(DDATABASE)+' às '+Time()+'</font></b>'+ _cEnter
_cHtml += '<b><font size="2" face="Verdana">Usuário: </font></b>'+'<b><font size="2" color="#0000FF" face="Verdana">'+UsrFullName(__cUserId)+'</font></b>'+ _cEnter+_cEnter+_cEnter


_cHtml += '<TABLE WIDTH=100% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
_cHtml += '	<TR VALIGN=TOP>                  '

_cHtml += '		<TD WIDTH=04%>                '
_cHtml += '	   		<P><font size="1" face="Verdana"><b>Campo<B></P></font> '
_cHtml += '		</TD>                        '

_cHtml += '		<TD WIDTH=15%>                '
_cHtml += '	   		<P><font size="1" face="Verdana"><b>Descrição<B></P></font> '
_cHtml += '		</TD>                        '

_cHtml += '		<TD WIDTH=25%>               '
_cHtml += '			<P><font size="1" face="Verdana"><b>Pasta</P></font> '
_cHtml += '		</TD>                        '

If altera
	_cHtml += '		<TD WIDTH=08%>                '
	_cHtml += '	   		<P><font size="1" face="Verdana"><b>Conteúdo Original<B></P></font> '
	_cHtml += '		</TD>                        '
EndIf

_cHtml += '		<TD WIDTH=25%>               '
_cHtml += '			<P><font size="1" face="Verdana"><b>Conteúdo ' + iif(altera,'Alterado','Incluído') + '</P></font> '
_cHtml += '		</TD>                        '


For nX := 1 To Len(_aCampos)
	_cHtml += '	<TR VALIGN=TOP>                  '
	
	_cHtml += '		<TD VALIGN=alin_vertical WIDTH=04%>                '
	_cHtml += '			<P><font size="1" face="Verdana"><b> '+_aCampos[nX,1]+'</P></font>  '			//	nome campo
	_cHtml += '		</TD>                        '
	
	_cHtml += '		<TD VALIGN=alin_vertical WIDTH=08%>                '
	_cHtml += '			<P><font size="1" face="Verdana"><b> '+_aCampos[nX,2]+'</P></font>  '			//	descricao do campo
	_cHtml += '		</TD>                        '
	
	_cHtml += '		<TD VALIGN=alin_vertical WIDTH=08%>                '
	_cHtml += '			<P><font size="1" face="Verdana"><b> '+_aCampos[nX,3]+'</P></font>  '			//	pasta do campo
	_cHtml += '		</TD>                        '
	
	If altera	
		_cHtml += '		<TD WIDTH=25%>                '
		_cHtml += '	   		<P><font size="1" face="Verdana"><b> '+ _aCampos[nX,5]  +'</P></font>  '	//	conteudo original
		_cHtml += '		</TD>                        '
	EndIf
	_cHtml += '		<TD WIDTH=25%>                '
	_cHtml += '	   		<P><font size="1" face="Verdana"><b> '+ _aCampos[nX,4]  +'</P></font>  '		//	conteudo alterado
	_cHtml += '		</TD>                      '	
	
	_cHtml += '	</TR>                            '
	
Next

_cHtml += '</TABLE>                           '
_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'
_cHtml += '</P>'

/*
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	DISCONNECT SMTP SERVER
Endif
*/ 

// ENVIA EMAIL
XSERV := GETMV("MV_RELSERV")
XCONTA := GETMV("MV_RELACNT")
XPASS := GETMV("MV_RELPSW") 
XCTA2 := XCONTA
lSmtpAuth  := GetMv("MV_RELAUTH",,.F.) 
lAutOk    := .f.   

CONNECT SMTP SERVER XSERV ACCOUNT XCONTA PASSWORD XPASS RESULT lResult
//mailauth(XCTA2,XPASS)

aResul	:= ""

If lResult
       	If !lAutOk
			If ( lSmtpAuth )
				lAutOk := MailAuth(XCTA2,XPASS)
			Else
				lAutOk := .T.
			EndIf
		EndIf
//Endif
//	FOR i := 1 TO LEN(aPARA)
 //		if !empty(alltrim(aPARA[i]))
		   //	SEND MAIL FROM XCONTA to  aPARA[i] SUBJECT cASSUNTO BODY _msg FORMAT TEXT ATTACHMENT RESULT lResult  
			SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cHtml RESULT lResult
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				Help(" ",1,"ATENCAO",,"SEND MAIL" + cError,4,5)
			else
			 	aResul:=aResul+","+alltrim(lower(cRecebe))//msginfo("Mensagem enviada para " + alltrim(lower(APARA[i])) + " com sucesso")
			EndIf
 		endif

 //	NEXT i

	DISCONNECT SMTP SERVER
Return()


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// retorna array:
// _aRet[1]: 0 - não localizado, 1 - usado, 2 - não usado
// _aRet[2]: 0 - não localizado, 1 - com nível, 2 - sem nível
// _aRet[3]: nome do campo
// _aRet[4]: nome da pasta
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _x3Campo(_xCampo)
////////////////////////////////
_aAlias := GetArea()
                          
DbSelectArea('SX3')
DbSetOrder(2)

If DbSeek(_xCampo)
	DbSelectArea('SXA')
	If DbSeek(SX3->X3_ARQUIVO + SX3->X3_FOLDER)
		_cPasta := SXA->XA_DESCRIC
	Else
	    _cPasta := 'Outros'
	EndIf
	
	_nUso := iif(x3uso(SX3->X3_USADO)	 , 1, 2)
	_nNiv := iif(cNivel >= SX3->X3_NIVEL , 1, 2)
	_aRet := {_xCampo, _nUso, _nNiv, x3Titulo(_xCampo), _cPasta, SX3->X3_ORDEM}
Else
	_aRet := {_xCampo, 0,     0,     '- x -',           '- x -', 0 }
EndIf
DbSetOrder(1)
RestArea(_aAlias)

Return(_aRet)