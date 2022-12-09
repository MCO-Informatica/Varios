#INCLUDE "TBICONN.CH" // USADO PARA AGENDAR JOB
#INCLUDE "INKEY.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER CHR(13)+CHR(10)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 	Programa:	LA_SX5
//	Autor:		Alexandre Dalpiaz
//	Data:		23/06/2010
//	Uso:		LaSelva
//	Funcao:		Aviso na entrada
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LA_SX5()
//////////////////////
Public _ENTER 	:= _cEnter  := chr(13) + CHR(10)
Public _cTabula := '	'
Private _lRecRH	:= .F.
                      
If !file('c:\spool')
	MakeDir('c:\spool')
EndIf
             
If GetMv('LS_PDVEXEC') < dDataBase
	U_LAFECCX(.t.)
	PutMv('LS_PDVEXEC',dDataBase)
EndIf

/*
���������������������������������������������������������������������������Ŀ
�Fun�"o    �MyEmpOpenFile � Autor �Wilson de Godoy        � Data �03/01/2001�
���������������������������������������������������������������������������Ĵ
�Descri�"o �Abre Arquivo de Outra Empresa                                     �
���������������������������������������������������������������������������Ĵ
�Parametros�x1 - Alias com o Qual o Arquivo Sera Aberto                      �
�          �x2 - Alias do Arquivo Para Pesquisa e Comparacao                �
�          �x3 - Ordem do Arquivo a Ser Aberto                              �
�          �x4 - .T. Abre e .F. Fecha                                       �
�          �x5 - Empresa                                                    �
�          �x6 - Modo de Acesso (Passar por Referencia)                     �
�����������������������������������������������������������������������������*/

SetKey( K_CTRL_E, { || U_LA_SM0() } )           
//SetKey( K_CTRL_S, { || U_XX_SEPARA() } )

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function GravaQuery(_cArq,_cQuery)
////////////////////////////////////////
If '/'+ __cUserId + '/' $ GetMv('LA_PODER')
	MemoWrit('c:\spool\queries\' + _cArq, _cQuery)
EndIf
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function CallChgXNU()  // em testes
////////////////////////////////////////
SetKey( K_CTRL_E, { || U_LA_SM0() } )

Return(Paramixb[5])


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LA_SM0()
//////////////////////
                         
_aAlias := GetAlias()
DbSelectArea('SM0')
_aAliasSM0 := GetAlias()

Private _oFont1, _oObj1, _oObj2, _oObj3
SetKey( K_CTRL_E, nil )

If Type('oMainWnd') <> 'U'
	_nAltura 	:= oMainWnd:nClientHeight - 20
	_nLargura 	:= oMainWnd:nClientWidth - 10
Else	
	_nAltura 	:= 800	
	_nLargura 	:= 1400
EndIf

_oFont1   := TFont():New ("Arial Black", 06, 15)

_aCampos := {}
aAdd(_aCampos,{'M0_CODIGO'	,'Empr' 				, ''})
aAdd(_aCampos,{'M0_FILIAL'	,'Fil' 					, ''})
aAdd(_aCampos,{'M0_NOME'	,'Nome Empr' 			, ''})
aAdd(_aCampos,{'M0_FILIAL'	,'Nome Filial' 			, ''})
aAdd(_aCampos,{'M0_CGC'		,'CNPJ' 				, '@R 99.999.999/9999-99'})
aAdd(_aCampos,{'M0_INSC'	,'Inscr Estadual' 		, ''})
aAdd(_aCampos,{'M0_ENDENT'	,'Endere�o Entrega'  	, ''})
aAdd(_aCampos,{'M0_COMPENT'	,'Compl End Entrega' 	, ''})
aAdd(_aCampos,{'M0_BAIRENT'	,'Bairro Entrega'  		, ''})
aAdd(_aCampos,{'M0_CIDENT'	,'Cidade Entrega'  		, ''})
aAdd(_aCampos,{'M0_ESTENT'	,'Est Ent' 				, ''})
aAdd(_aCampos,{'M0_CEPENT'	,'CEP Ent' 				, '@R 99999-999'})
aAdd(_aCampos,{'M0_TEL'   	,'Fone Ent'				, ''})
aAdd(_aCampos,{'M0_FAX'   	,'FAX Ent' 				, ''})
aAdd(_aCampos,{'M0_ENDCOB'	,'Endere�o Cobran�a' 	, ''})
aAdd(_aCampos,{'M0_BAIRCOB'	,'Bairro Cobran�a' 		, ''})
aAdd(_aCampos,{'M0_CIDCOB'	,'Cidade Cobran�a' 		, ''})
aAdd(_aCampos,{'M0_ESTCOB'	,'Est Cob' 				, ''})
aAdd(_aCampos,{'M0_CEPCOB'	,'CEP Cob' 				, '@R 99999-999'})

define MSDialog _oDlg from 0,0 to _nAltura, _nLargura of oMainWnd pixel title "Cadastro de Empresas do Sistema"
@ 10,10 to _nAltura/2-10, _nLargura/2-10 browse "SM0" object _oBrw fields _aCampos 

activate msdialog _oDlg centered
SetKey( K_CTRL_E, { || U_LA_SM0() } )

RestArea(_aAliasSM0)
RestArea(_aAlias)

Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function EmailAviso()
////////////////////////////

//��������������������������������������������������������������������������������������������Ŀ
//�Envia email para usuarios informando sobre a parada do sistema - Fabiano Pereira 27/11/2007 |
//����������������������������������������������������������������������������������������������

If !REC->(eof())
	RecLock('REC',.F.)
	REC->EMAIL := .F.
	MsUnLock()
EndIf

cServer   	:= GETMV("MV_RELSERV")
cAccount  	:= AllTrim(GETMV("MV_RELACNT"))
cPassword 	:= AllTrim(GETMV("MV_RELAPSW"))
cEnvia    	:= 'siga@laselva.com.br'
cAssunto  	:= "Parada Sistema"
cRecebe     := 'adalpiaz@laselva.com.br'

cHtml	 	:= cError    := ""

cHtml := '<html>'
cHtml += '<head></head>'
cHtml += '<h3 align = Left><font color="##FF0000" face="Verdana"> PARADA DE SISTEMA </h3>'

cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Hor�rio de Bloqueio: </font></b>'+ ENTER+ENTER
_nDiaSemana	:=	AllTrim(DiaSemana(REC->DTBLOQINI))
If Upper(_nDiaSemana) <> 'SABADO' .Or. Upper(_nDiaSemana) <> 'DOMINGO'
	_nDiaSemana	:=	AllTrim(DiaSemana(REC->DTBLOQINI)) + "-feira"
Endif

cHtml += '<b><font size="3" color="##FF0000"" face="Verdana"> '+_nDiaSemana+' </font></b>'+ ENTER
cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> In�cio : &nbsp;&nbsp;&nbsp;&nbsp;'+ DtoC(REC->DTBLOQINI) + ' - ' + REC->HRBLOQINI   +'</font></b>'+ ENTER
cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> T�rmino: '+ DtoC(REC->DTBLOQFIM) + ' - ' + REC->HRBLOQFIM   +'</font></b>'+ ENTER + ENTER + ENTER


cHtml += '</head>'
cHtml += '<body bgcolor = white text=black  >'
cHtml += '<hr width=100% noshade>' + ENTER

cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Prezados colegas, '+ENTER+'Conforme planejado, faremos manuten��o no sistema Microsiga para implantar melhorias e corrigir problemas.</font></b>'+ ENTER + ENTER + ENTER
cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Pedimos que n�o processem rotinas que tendem a ultrapassar o inicio da parada.  Caso seja realmente necess�rio, informar a TI (Ramal: 2579) para poss�vel replanejamento da parada. </font></b>'+ ENTER
cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Teremos toler�ncia de 10 min ap�s o hor�rio previsto. Ap�s este prazo, caso o usu�rio permane�a no sistema, sua conex�o ser� cancelada e o processo que estiver em andamento ser� interrompido. </font></b>'+ ENTER
cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Pedimos a coopera��o de todos, pois se o in�cio atrasa motivado por poucos usu�rios, acabamos indo al�m do previsto e prejudicando TODOS os usu�rios. </font></b>'+ ENTER+ENTER

cHtml += '<b><font size="2" color="#696969" face="Verdana"> E-mail enviado automaticamente, n�o responda este e-mail </font></b>'
cHtml += '</html>'

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	
	
	SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY cHtml RESULT lEnviado
	
	If !lEnviado
		cHtml := "A T E N � � O! N�O FOI POSS�VEL CONEX�O NO SERVIDOR DE E-MAIL"
		GET MAIL ERROR cHtml
		Conout( "ERRO SMTP EM: " + cAssunto )
		If !REC->(eof())
			RecLock('REC',.F.)
			REC->EMAIL := .T.
			MsUnLock()
		EndIf
	Else
		DISCONNECT SMTP SERVER
		Conout( cAssunto )
	Endif
	
Else
	
	Conout( "ERRO SMTP EM: " + cAssunto )
	cHtml := "A T E N � � O! N�O FOI POSS�VEL CONEX�O NO SERVIDOR DE E-MAIL"
	MsgAlert(cHtml)
	If !REC->(eof())
		RecLock('REC',.F.)
		REC->EMAIL := .T.
		MsUnLock()
	EndIf
Endif

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _EspNome()
////////////////////////
Return("Laselva")

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _Esp1Nome()
////////////////////////
Return("Configurador")

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// retorna array com informa�oes do usu�rio especificado
// _fOrd 1 = codigo (usuario ou grupo) - default		
//       2 = nome   (usuario ou grupo)			   
//		 3 = senha do usu�rio
//		 4 = email do usu�rio               
//
// _fPesq .t. = usuario (default)                  
//		  .f. = grupo 	                        
//
// _fChave string de pesquisa conforme ordem definida em _fOrd (default = usu�rio atual - __cUserId)
// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fUser(_fOrd, _fPesq, _fChave, _fRet)
//////////////////////////////////////////////////
Local   _aRet
Default _fOrd   := 1
Default _fPesq  := .t.
Default _fChave := __cUserId
Default _fRet   := 1

PswOrder(_fOrd)
PswSeek(_fChave,_fPesq)
_aRet := PswRet(_fret)
Return(_aRet)



//CT5_FILIAL+CT5_LANPAD+CT5_SEQUEN                                                                                                                                                                                                                          