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
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡"o    ³MyEmpOpenFile ³ Autor ³Wilson de Godoy        ³ Data ³03/01/2001³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡"o ³Abre Arquivo de Outra Empresa                                     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³x1 - Alias com o Qual o Arquivo Sera Aberto                      ³
³          ³x2 - Alias do Arquivo Para Pesquisa e Comparacao                ³
³          ³x3 - Ordem do Arquivo a Ser Aberto                              ³
³          ³x4 - .T. Abre e .F. Fecha                                       ³
³          ³x5 - Empresa                                                    ³
³          ³x6 - Modo de Acesso (Passar por Referencia)                     ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

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
aAdd(_aCampos,{'M0_ENDENT'	,'Endereço Entrega'  	, ''})
aAdd(_aCampos,{'M0_COMPENT'	,'Compl End Entrega' 	, ''})
aAdd(_aCampos,{'M0_BAIRENT'	,'Bairro Entrega'  		, ''})
aAdd(_aCampos,{'M0_CIDENT'	,'Cidade Entrega'  		, ''})
aAdd(_aCampos,{'M0_ESTENT'	,'Est Ent' 				, ''})
aAdd(_aCampos,{'M0_CEPENT'	,'CEP Ent' 				, '@R 99999-999'})
aAdd(_aCampos,{'M0_TEL'   	,'Fone Ent'				, ''})
aAdd(_aCampos,{'M0_FAX'   	,'FAX Ent' 				, ''})
aAdd(_aCampos,{'M0_ENDCOB'	,'Endereço Cobrança' 	, ''})
aAdd(_aCampos,{'M0_BAIRCOB'	,'Bairro Cobrança' 		, ''})
aAdd(_aCampos,{'M0_CIDCOB'	,'Cidade Cobrança' 		, ''})
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia email para usuarios informando sobre a parada do sistema - Fabiano Pereira 27/11/2007 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Horário de Bloqueio: </font></b>'+ ENTER+ENTER
_nDiaSemana	:=	AllTrim(DiaSemana(REC->DTBLOQINI))
If Upper(_nDiaSemana) <> 'SABADO' .Or. Upper(_nDiaSemana) <> 'DOMINGO'
	_nDiaSemana	:=	AllTrim(DiaSemana(REC->DTBLOQINI)) + "-feira"
Endif

cHtml += '<b><font size="3" color="##FF0000"" face="Verdana"> '+_nDiaSemana+' </font></b>'+ ENTER
cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> Início : &nbsp;&nbsp;&nbsp;&nbsp;'+ DtoC(REC->DTBLOQINI) + ' - ' + REC->HRBLOQINI   +'</font></b>'+ ENTER
cHtml += '<b><font size="2" color="#0000FF" face="Verdana"> Término: '+ DtoC(REC->DTBLOQFIM) + ' - ' + REC->HRBLOQFIM   +'</font></b>'+ ENTER + ENTER + ENTER


cHtml += '</head>'
cHtml += '<body bgcolor = white text=black  >'
cHtml += '<hr width=100% noshade>' + ENTER

cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Prezados colegas, '+ENTER+'Conforme planejado, faremos manutenção no sistema Microsiga para implantar melhorias e corrigir problemas.</font></b>'+ ENTER + ENTER + ENTER
cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Pedimos que não processem rotinas que tendem a ultrapassar o inicio da parada.  Caso seja realmente necessário, informar a TI (Ramal: 2579) para possível replanejamento da parada. </font></b>'+ ENTER
cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Teremos tolerância de 10 min após o horário previsto. Após este prazo, caso o usuário permaneça no sistema, sua conexão será cancelada e o processo que estiver em andamento será interrompido. </font></b>'+ ENTER
cHtml += '<b><font size="3" color="#0000FF" face="Verdana"> Pedimos a cooperação de todos, pois se o início atrasa motivado por poucos usuários, acabamos indo além do previsto e prejudicando TODOS os usuários. </font></b>'+ ENTER+ENTER

cHtml += '<b><font size="2" color="#696969" face="Verdana"> E-mail enviado automaticamente, não responda este e-mail </font></b>'
cHtml += '</html>'

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	
	
	SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY cHtml RESULT lEnviado
	
	If !lEnviado
		cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
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
	cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
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
// retorna array com informaçoes do usuário especificado
// _fOrd 1 = codigo (usuario ou grupo) - default		
//       2 = nome   (usuario ou grupo)			   
//		 3 = senha do usuário
//		 4 = email do usuário               
//
// _fPesq .t. = usuario (default)                  
//		  .f. = grupo 	                        
//
// _fChave string de pesquisa conforme ordem definida em _fOrd (default = usuário atual - __cUserId)
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