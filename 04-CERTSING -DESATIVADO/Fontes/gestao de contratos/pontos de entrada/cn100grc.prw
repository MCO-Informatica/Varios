/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    矯N100GRC   � Autor � Marcelo Celi Marques � Data � 19/10/12 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 砅onto de Entrada para tratar as integracoes apos a manuten- 潮� 
北�          砪ao do cadastro de Gestao de Contratos.				      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Certisign                                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/                 
#Include "Protheus.ch"
#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
User Function CN100GRC()
	Local nOpc := 0
	nOpc := ParamIXB[1]
	//----------------------------------------------
	// Fun玢o acionada para as rotinas do ISO-27001.
	//----------------------------------------------
	If nOpc==5 .And. FindFunction("U_CSATVMANU")
		U_CSATVMANU(4,"E")
	EndIf
	//--------------------------------------------------------
	// Fun玢o acionada para as rotinas do gest鉶 de contrtaos.
	// Programador: Robson Gon鏰lves.
	//--------------------------------------------------------
	If FindFunction('U_A290GrvCNPJ')
		U_A290GrvCNPJ( nOpc )
	Endif
	//----------------------------------------------
	// Ao gravar o contrato, avisa para informar os usu醨ios
	// da notifica玢o de e-mail.
	//----------------------------------------------
	If nOpc == 3 .And. Empty( CN9->CN9_NOTVEN )
		MsgAlert(cFONT+'ATEN敲O'+cNOFONT+;
			         '<br><br>N鉶 esque鏰 de cadastrar o(s) destinat醨io(s) para receber notifica玢o baseado em cada situa玢o do contrato.'+;
			         '<br><br>A珲es relacionadas > Manuten珲es espec韋icas > Notifica玢o Venctos',;
			         'CN100GRC - E-mails de contratos' )
	EndIf	
Return 