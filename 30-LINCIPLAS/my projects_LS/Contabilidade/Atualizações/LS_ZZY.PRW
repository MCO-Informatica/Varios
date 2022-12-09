#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"

// Funcao      	fm_zzy
// Autor 		Alexandre Dalpiaz
// Data 		13/12/2007
// Descricao    manutenção de descontabilizacoes
// Uso         	Especifico para laselva
//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_zzy()
//////////////////////

Private cString := "ZZY"

dbSelectArea("ZZY")
dbSetOrder(1)

Private cCadastro := "Descontabilizações"

Private aRotina := {}
aAdd(aRotina, {"Pesquisar"			 , "AxPesqui"		, 0 , 1 })
aAdd(aRotina, {"Visualizar"		 	 , "AxVisual"		, 0 , 2 })
aAdd(aRotina, {"Incluir"			 , "AxInclui"		, 0 , 3 })
aAdd(aRotina, {"Alterar"			 , "AxAltera"		, 0 , 4 })
aAdd(aRotina, {"Excluir"     		 , "AxDeleta"		, 0 , 5 })
aAdd(aRotina, {"Descontabiliza"	 	 , "U_FMZZYDes(1)" 	, 0 , 6 })
//aAdd(aRotina, {"Descont Tudo"	 	 , "U_FMZZYDes(2)" 	, 0 , 7 })
aAdd(aRotina, {"Legenda"     	 	 , "U_ZZYLegenda" 	, 0 , 7 })

aCores := {}
aAdd(aCores, {"ZZY_TPMOV == '1' .and.  empty(ZZY_DTDESC)",'BR_AZUL'})
aAdd(aCores, {"ZZY_TPMOV == '1' .and. !empty(ZZY_DTDESC)",'BR_VERMELHO'})
aAdd(aCores, {"ZZY_TPMOV == '2' .and.  empty(ZZY_DTDESC)",'BR_VERDE'})
aAdd(aCores, {"ZZY_TPMOV == '2' .and. !empty(ZZY_DTDESC)",'BR_PRETO'})
aAdd(aCores, {"ZZY_TPMOV == '3' .and.  empty(ZZY_DTDESC)",'BR_AMARELO'})
aAdd(aCores, {"ZZY_TPMOV == '3' .and. !empty(ZZY_DTDESC)",'BR_CINZA'})

//SetKey(123,{|| FM_PERGUNTE() }) // Seta a tecla F12 para acionamento dos parametros

dbSelectArea('ZZY')
mBrowse( 6,1,22,75,'ZZY',,,,,,aCores)

//Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

RetIndex('ZZY')

Return

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
User Function ZZYLegenda()
///////////////////////////
_aLegenda := {}
aAdd(_aLegenda, {"BR_AZUL" 		, "Entradas - Contabilizado"  })
aAdd(_aLegenda, {"BR_VERMELHO" 	, "Entradas - Descontabilizado"})
aAdd(_aLegenda, {"BR_VERDE" 	, "Saídas - Contabilizado"})
aAdd(_aLegenda, {"BR_PRETO" 	, "Saídas - Descontabilizado"})
BrwLegenda("Descontabilizações","LEGENDA",_aLegenda)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FMZZYDes(_nOpc)
////////////////////////

If _nOpc == 2
	DbSeek(xFilial('ZZY') + space(8), .f.)
EndIf
Do while !eof()
	
	If ZZY->ZZY_TPMOV == '1'
		
		If empty(ZZY->ZZY_DTDESC)
			If U_FM_CMPDESC(1)
				RecLock('ZZY',.f.)
				ZZY->ZZY_DTDESC := date()
				ZZY->ZZY_HRDESC := time()
				MsUnLock()
				Exit
			EndIf
		ElseIf _nOpc == 1
			msgBox('Documento já está descontabilizado!!!!','Descontabilização','INFO')
		EndIf
		
	ElseIf ZZY->ZZY_TPMOV == '2'

		If empty(ZZY->ZZY_DTDESC)
			If U_FM_FATDESC(1)
				RecLock('ZZY',.f.)
				ZZY->ZZY_DTDESC := date()
				ZZY->ZZY_HRDESC := time()
				MsUnLock()
				Exit
			EndIf
		ElseIf _nOpc == 1
			msgBox('Documento já está descontabilizado!!!!','Descontabilização','INFO')
		EndIf

	ElseIf ZZY->ZZY_TPMOV == '3'

		If empty(ZZY->ZZY_DTDESC)
			If U_FM_FINDESC(1)
				RecLock('ZZY',.f.)
				ZZY->ZZY_DTDESC := date()
				ZZY->ZZY_HRDESC := time()
				MsUnLock()
				Exit
			EndIf
		ElseIf _nOpc == 1
			msgBox('Documento já está descontabilizado!!!!','Descontabilização','INFO')
		EndIf
	EndIf
	
	If _nOpc == 2
		DbSeek(xFilial('ZZY') + space(8), .f.)
	EndIf
	
EndDo

If _nOpc == 2
	msgBox('Não há mais documentos para descontabilizar!!!!','Descontabilização','INFO')
Else
	msgBox('Documento descontabilizado!!!!','Descontabilização','INFO')
EndIf	                                  

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FM_MAILZZY(_yfilial,_ytpmov,_ydoc,_yserie,_yval,_ydtdigit,_ydtlanc,_yclifor,_yloja)
///////////////////////////

_cMotivo := space(30)
_nCont := 0
@ 96,42 TO 323,505 DIALOG oDlg1 TITLE "Solicitação de Descontabilização"
@ 030,005 Say 'Motivo:'

@ 030,050 Get _cMotivo

@ 090,050 BMPBUTTON TYPE 01 ACTION ( _nCont := 1, oDlg1:End() )
@ 090,150 BMPBUTTON TYPE 02 ACTION ( _nCont := 2, oDlg1:End() )

Activate Dialog oDlg1 Centered Valid _nCont > 0

If _nCont == 2
	
	_cTexto := 'Solicitação de descontabilização CANCELADA.' + chr(13) + chr(13)
	_cTexto += 'Não será enviado email para o Depto de Contabilidade'
	MsgBox(_cTexto,'ATENÇÃO!!!','INFO')
	
Else
	
	_cTexto := 'Nota fiscal não pode ser excluída pois já foi contabilizada.' + chr(13) + chr(13)
	_cTexto += 'Enviar email para o Depto de Contabilidade solicitando liberação para exclusão da nota?' + chr(13) + chr(13)
	
	If MsgBox(_cTexto,'ATENÇÃO!!!','YESNO')
		_aAlias := GetArea()
		RecLock('ZZY',.t.)
		ZZY->ZZY_FILIAL := xFilial('ZZY')
		ZZY->ZZY_MSFIL  := _yFilial
		ZZY->ZZY_TPMOV  := _ytpmov
		ZZY->ZZY_DOCTO  := _ydoc
		ZZY->ZZY_SERIE  := _yserie
		ZZY->ZZY_VALOR  := _yval
		ZZY->ZZY_DTDIG  := _ydtdigit
		ZZY->ZZY_DTCONT := _ydtlanc
		ZZY->ZZY_CLIFOR := _yCliFor
		ZZY->ZZY_LOJA   := _yLoja
		ZZY->ZZY_DATSOL := date()
		ZZY->ZZY_EMAIL  := Pswret()[1,14]
		ZZY->ZZY_USER   := cUserName
		ZZY->ZZY_MOTIVO := _cMotivo
		MsUnLock()
		RestArea(_aAlias)
		
		_EndLine    := Chr(13) + Chr(10)
		cServer   	:= GETMV("MV_WFSMTP")
		cAccount  	:= AllTrim(GETMV("MV_WFMAIL"))
		cPassword 	:= AllTrim(GETMV("MV_WFPASSW"))
		cEnvia    	:= Pswret()[1,14]
		cAssunto  	:= "Sistema Microsiga / Exclusão de documentos contabilizados "
		cRecebe     := ''
		xRecebe     := alltrim(GetMv('LS_MAILEXC'))
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
		_aTpMov := {}
		aAdd(_aTpMov,{'Fornecedor','Nota Fiscal de Entrada'})
		aAdd(_aTpMov,{'Cliente...','Nota Fiscal de Saída'})
		aAdd(_aTpMov,{'Fornecedor','Contas a pagar'})
		aAdd(_aTpMov,{'Cliente...','Contas a receber'})
		
		cMensagem	:=	'Solicitação de Exclusão de ' + _aTpMov[val(_ytpmov),2] + _EndLine + _EndLine
		cMensagem	+=	'Filial................: ' + _yfilial + ' - ' + SM0->M0_NOME + ' / ' + SM0->M0_FILIAL + _EndLine
		cMensagem	+=	'Documento.............: ' + _ydoc   									+ _EndLine
		cMensagem	+=	'Série/Prefixo.........: ' + _ySERIE 									+ _EndLine
		cMensagem	+=	'Valor.................: ' + tran(_yVAL,'@E 999,999,999.99')		 	+ _EndLine
		cMensagem	+=	_aTpMov[val(_ytpmov),1] + '............: ' + _yclifor+'/'+_yloja 						+ _EndLine
		cMensagem	+=	'Data de Digitação.....: ' + dtoc(_yDTDIGIT) 							+ _EndLine
		cMensagem	+=	'Data da Contabilização: ' + dtoc(_yDTLANC)  							+ _EndLine
		cMensagem	+=	'Data da Solicitação...: ' + dtoc(date()) + ' - ' + time() 				+ _EndLine
		cMensagem	+=	'Usuário...............: ' + UsrFullName(__cUserId)						+ _EndLine
		cMensagem	+=	'Motivo................: ' + _cMotivo                 					+ _EndLine
		cMensagem	+=	'eMail.................: ' + Pswret()[1,14]
		
		MsAguarde( {|| EnviaEmail()},'Enviando email')
		
	EndIf
	
EndIf
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function EnviaEmail()
///////////////////////////

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
If lConectou
	SEND MAIL FROM cEnvia;
	TO cRecebe;
	SUBJECT cAssunto;
	BODY cMensagem;
	RESULT lEnviado
	If !lEnviado
		GET MAIL ERROR cMensagem
		cMensagem := "Email não pode ser enviado" + _EndLine + _EndLine
		cMensagem += 'Copiar mensagem abaixo e enviar email via OUTLOOK ou WebMail' + _EndLine + _EndLine + cMensagem
		Aviso('Solicitação de Descontabilização', cMensagem,{'OK'} , 3 )
	Else
		MsgBox(cMensagem,'Email enviado com sucesso!!!','INFO')
		DISCONNECT SMTP SERVER
	Endif
Else
	cMensagem := "Email não pode ser enviado" + _EndLine + _EndLine + cMensagem
	cMensagem += 'Copiar mensagem abaixo e enviar email via OUTLOOK ou WebMail' + _EndLine + _EndLine + cMensagem
	Aviso('Solicitação de Descontabilização', cMensagem,{'OK'} , 3 )
Endif

Return()


