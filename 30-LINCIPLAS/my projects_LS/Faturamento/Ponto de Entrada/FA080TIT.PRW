#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

// Programa: FA080TIT
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: Antes da confirma?ao da baixa de titulos a pagar:
// 			 Verifica se est? bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FA080TIT()
////////////////////////
_lRet := .t.

U_FA080CAN()	// verifica se est? na filial correta (matriz de uma das empresas)

dBaixa := iif(IsInCallStack( "FINA080" ),dBaixa,SE2->E2_BAIXA)
/*
If empty(SE2->E2_HORASPB) .or. SE2->E2_HORASPB == 'LIBER' .or. SE2->E2_TIPO == 'PA'
	If SE2->E2_RATEIO == 'S'
		RecLock('SE2',.f.)
		SE2->E2_EMIS1 := dBaixa
		MsUnLock()
	EndIf
	
	Return(_lRet)
EndIf
*/
         
If dBaixa < SE2->E2_EMIS1 .and. !empty(dBaixa)
	_lRet := .f.
	MsgAlert('Data da baixa (' + dtoc(dBaixa) + ') inferior ? data emiss?o do t?tulo (' + dtoc(SE2->E2_EMIS1) + ')!','ATEN??O!!!')
EndIf

If _lRet .and. SE2->E2_HORASPB == 'BLOCK'
	_cTexto := 'T?tulo aguardando Libera??o para pagamento' + _cEnter + _cEnter
	_cTexto += 'Filial: ' + cFilAnt + _cEnter
	_cTexto += 'Filial Origem: ' + SE2->E2_MSFIL   + _cEnter
	_cTexto += 'Prefixo: ' + SE2->E2_PREFIXO + _cEnter
	_cTexto += 'Numero: ' + SE2->E2_NUM     + _cEnter 
	_cTexto += 'Parcela:' + SE2->E2_PARCELA + _cEnter
	_cTexto += 'Tipo: ' + SE2->E2_TIPO    + _cEnter
	_cTexto += 'Fornecedor: ' + SE2->E2_FORNECE + _cEnter
	_cTexto += 'Loja: ' + SE2->E2_LOJA    + _cEnter
	_cTexto += 'Valor: ' + tran(SE2->E2_VALOR,'@E 999,999,999.99')
	
	MsgAlert(_cTexto,'ATEN??O!!!')
	_lRet := .f.
EndIf
  
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: FA090TIT
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: Antes da confirma?ao da baixa autom?tica de titulos a pagar:
// 			 Verifica se est? bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F090TOK()
////////////////////////

_lRet := U_FA080TIT('Baixa autom?tica')
                                       
If _lRet
	If !(SA6->A6_EMPRESA $ GetMv('MV_EMPGRP'))
		MsgAlert('Verifique Banco/Ag?ncia/Conta' + _cEnter + 'Inv?lido para esta empresa','ATEN??O!!!')
		_lRet := .f.
	EndIf
EndIf       

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: F090TIT
// Autor...: Alexandre Dalpiaz
// Data....: 05/10/10
// Funcao..: Na sele??o do t?tulo para baixa autom?tica de titulos a pagar:
// 			 Verifica se est? bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F090TIT()
////////////////////////

_lRet := .t.

Return(U_FA080TIT('sele??o baixa autom?tica'))

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: FA090TIT
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: Na selec??o de titulos a pagar para inclus?o em border?:
// 			 Verifica se est? bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function f240tit()
////////////////////////
_lRet := .t.

Return(U_FA080TIT('Border? CP'))

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: fa080can
// Autor...: Alexandre Dalpiaz
// Data....: 06/10/10
// Funcao..: Na sele??o dos t?tulos a pagar para compensa??o
// 			 Filtra somente os t?tulos da empresa correspoindente
// Obs.....: SUPERTECH: est? com pau na hora de selecionar a filial para fazer o filtro, existe algum outro ponto que deve mudar a vari?vel cFilAnt para
//           Algum valor padr?o, e isso impede a compensa??o do t?tulo. Thiago Queiroz - 18/11/2015
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F340FLCP()
////////////////////////

U_LS_MATRIZ()
_cRet := "AND E2_MATRIZ = '" + cFilAnt + "'"
Return(_cRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: F340NAT
// Autor...: Alexandre Dalpiaz
// Data....: 06/10/10
// Funcao..: ap?s confirma??o da compensa??o CP
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F340NAT() 

U_fa080can('Compensa??o CP')
Return(.t.)  

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: fa080can
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: na exclusao de baixa manual
// 			 Verifica se existe alguma PA em aberto para o fornecedor
//			 Verifica se as movimenta??es est?o sendo geradas na matriz de cada empresa
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fa080can()
////////////////////////
_lRet := .t.
cFilAnt := right(cNumEmp,2)
If !(cFilAnt $ GetMv('LS_MATRIZ'))
	MsgAlert('Esta rotina deve ser executada em uma filial centralizadora','ATEN??O!!!!')
	_lRet := .f.
EndIf

Return(_lRet)

// Programa: fa080can
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: cancelamento de bordero
// 			 Verifica se existe alguma PA em aberto para o fornecedor
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function f240can()
////////////////////////
_lRet := U_FA080CAN('Cancelamento de border? CP')
If _lRet    
	RecLock('SE2',.F.)
	SE2->E2_IDCNAB := ''
	MsUnLock()
EndIf
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Email()
///////////////////////

Enter       := chr(13)
cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= 'adalpiaz@laselva.com.br'
cAssunto  	:= "Solicita??o para libera??o de pagamento"
//cRecebe     := cRecebe	//'adalpiaz@laselva.com.br'	//GetMv('LA_PDVMAIL')

_aSizes := {'10','10','10','10','10','10'}
_aAlign := {'','','','','RIGHT','RIGHT'}
_aLabel := {'Filial','Prefixo','T?tulo','Emiss?o','Valor','Saldo'}

_cHtml	 	:= ""

_cHtml += '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">' + cAssunto + '</h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + _cEnter
_cTexto :=  'O fornecedor ' + alltrim(Posicione('SA2',1,xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,'A2_NOME'))
_cTexto += ' possui T?tulos de Pagamento Antecipado em aberto, conforme rela??o abaixo.' + _cEnter

_cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> ' + _cTexto+ '</font></b>'+ _cEnter+_cEnter

_cHtml += '<TABLE WIDTH=80% BORDER=1 BORDERCOLOR="#cccccc" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">'
_cHtml += '	<TR VALIGN=TOP>                  '

For _nI := 1 To Len(_aSizes)
	_cHtml += '		<TD WIDTH=' + _aSizes[_nI] + '%>'
	_cHtml += '	   		<P>' + iif(!empty(_aAlign[_nI]),'<h3 align = '+ _aAlign[_nI] + '>','') + '<font size="1" face="Verdana"><b>' + _aLabel[_nI] + '<B></P></font> '
	_cHtml += '		</TD>'
Next

For _nI := 1 To Len(_aTitulos)
	
	_cHtml += '	<TR VALIGN=TOP>'
	
	For _nJ := 1 to len(_aTitulos[_nI])
		_cHtml += '		<TD VALIGN=alin_vertical WIDTH=' + _aSizes[_nJ] + '%>'
		_cHtml += '			<P>' + iif(!empty(_aAlign[_nJ]),'<h3 align = '+ _aAlign[_nJ] + '>','') + '<font size="1" face="Verdana"><b> '+_aTitulos[_nI,_nJ]+'</P></font>'
		_cHtml += '		</TD>'
	Next
Next
_cHtml += '	</TR>'

_cHtml += '</TABLE>'
_cHtml += '<P STYLE="margin-bottom: 0cm"><BR>'


_cHtml += '</P>'


CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	
	
	SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cHtml RESULT lEnviado
	
	If !lEnviado
		cHtml := "A T E N ? ? O! N?O FOI POSS?VEL CONEX?O NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		Conout( "ERRO SMTP EM: " + cAssunto )
	Else
		DISCONNECT SMTP SERVER
		Conout( cAssunto )
	Endif
	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N ? ? O! N?O FOI POSS?VEL CONEX?O NO SERVIDOR DE E-MAIL"
	MsgAlert(cHtml)
Endif

Return




/*
MV_TXCOFIN/MV_PISAPUR/MV_TXPIS/MV_RNDPIS/MV_DBSTPIS/MV_CRDBPIS/MV_DEDBPIS/MV_TPALPIS/MV_MINPIS/MV_RNDCOF/MV_DESZFPC/MV_MINCOF/MV_TPALCOF/MV_TXCOFIN/MV_COFAPUR

MV_CRDBPIS
MV_DBSTPIS
MV_DEDBPIS
MV_DESZFPC
MV_MINCOF
MV_MINPIS
MV_PISAPUR
MV_RNDCOF
MV_RNDPIS
MV_TPALCOF
MV_TPALPIS
MV_TXCOFIN
MV_TXPIS
*/