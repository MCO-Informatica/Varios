#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

// Programa: FA080TIT
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: Antes da confirmaçao da baixa de titulos a pagar:
// 			 Verifica se está bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FA080TIT()
////////////////////////
_lRet := .t.

U_FA080CAN()	// verifica se está na filial correta (matriz de uma das empresas)

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
	MsgAlert('Data da baixa (' + dtoc(dBaixa) + ') inferior à data emissão do título (' + dtoc(SE2->E2_EMIS1) + ')!','ATENÇÃO!!!')
EndIf

If _lRet .and. SE2->E2_HORASPB == 'BLOCK'
	_cTexto := 'Título aguardando Liberação para pagamento' + _cEnter + _cEnter
	_cTexto += 'Filial: ' + cFilAnt + _cEnter
	_cTexto += 'Filial Origem: ' + SE2->E2_MSFIL   + _cEnter
	_cTexto += 'Prefixo: ' + SE2->E2_PREFIXO + _cEnter
	_cTexto += 'Numero: ' + SE2->E2_NUM     + _cEnter 
	_cTexto += 'Parcela:' + SE2->E2_PARCELA + _cEnter
	_cTexto += 'Tipo: ' + SE2->E2_TIPO    + _cEnter
	_cTexto += 'Fornecedor: ' + SE2->E2_FORNECE + _cEnter
	_cTexto += 'Loja: ' + SE2->E2_LOJA    + _cEnter
	_cTexto += 'Valor: ' + tran(SE2->E2_VALOR,'@E 999,999,999.99')
	
	MsgAlert(_cTexto,'ATENÇÃO!!!')
	_lRet := .f.
EndIf
  
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: FA090TIT
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: Antes da confirmaçao da baixa automática de titulos a pagar:
// 			 Verifica se está bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F090TOK()
////////////////////////

_lRet := U_FA080TIT('Baixa automática')
                                       
If _lRet
	If !(SA6->A6_EMPRESA $ GetMv('MV_EMPGRP'))
		MsgAlert('Verifique Banco/Agência/Conta' + _cEnter + 'Inválido para esta empresa','ATENÇÃO!!!')
		_lRet := .f.
	EndIf
EndIf       

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: F090TIT
// Autor...: Alexandre Dalpiaz
// Data....: 05/10/10
// Funcao..: Na seleção do título para baixa automática de titulos a pagar:
// 			 Verifica se está bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F090TIT()
////////////////////////

_lRet := .t.

Return(U_FA080TIT('seleção baixa automática'))

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: FA090TIT
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: Na selecção de titulos a pagar para inclusão em borderô:
// 			 Verifica se está bloqueado E2_HORASPB = BLOCK
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function f240tit()
////////////////////////
_lRet := .t.

Return(U_FA080TIT('Borderô CP'))

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: fa080can
// Autor...: Alexandre Dalpiaz
// Data....: 06/10/10
// Funcao..: Na seleção dos títulos a pagar para compensação
// 			 Filtra somente os títulos da empresa correspoindente
// Obs.....: SUPERTECH: está com pau na hora de selecionar a filial para fazer o filtro, existe algum outro ponto que deve mudar a variável cFilAnt para
//           Algum valor padrão, e isso impede a compensação do título. Thiago Queiroz - 18/11/2015
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
// Funcao..: após confirmação da compensação CP
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F340NAT() 

U_fa080can('Compensação CP')
Return(.t.)  

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: fa080can
// Autor...: Alexandre Dalpiaz
// Data....: 15/09/10
// Funcao..: na exclusao de baixa manual
// 			 Verifica se existe alguma PA em aberto para o fornecedor
//			 Verifica se as movimentações estão sendo geradas na matriz de cada empresa
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fa080can()
////////////////////////
_lRet := .t.
cFilAnt := right(cNumEmp,2)
If !(cFilAnt $ GetMv('LS_MATRIZ'))
	MsgAlert('Esta rotina deve ser executada em uma filial centralizadora','ATENÇÃO!!!!')
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
_lRet := U_FA080CAN('Cancelamento de borderô CP')
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
cAssunto  	:= "Solicitação para liberação de pagamento"
//cRecebe     := cRecebe	//'adalpiaz@laselva.com.br'	//GetMv('LA_PDVMAIL')

_aSizes := {'10','10','10','10','10','10'}
_aAlign := {'','','','','RIGHT','RIGHT'}
_aLabel := {'Filial','Prefixo','Título','Emissão','Valor','Saldo'}

_cHtml	 	:= ""

_cHtml += '<html>'
_cHtml += '<head>'
_cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Verdana">' + cAssunto + '</h3></font>'
_cHtml += '</head>'
_cHtml += '<body bgcolor = white text=black  >'
_cHtml += '<hr width=100% noshade>' + _cEnter
_cTexto :=  'O fornecedor ' + alltrim(Posicione('SA2',1,xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,'A2_NOME'))
_cTexto += ' possui Títulos de Pagamento Antecipado em aberto, conforme relação abaixo.' + _cEnter

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
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		Conout( "ERRO SMTP EM: " + cAssunto )
	Else
		DISCONNECT SMTP SERVER
		Conout( cAssunto )
	Endif
	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
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