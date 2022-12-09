/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CN100GRC   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 19/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de Entrada para tratar as integracoes apos a manuten- ³±± 
±±³          ³cao do cadastro de Gestao de Contratos.				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 
#Include "Protheus.ch"
#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
User Function CN100GRC()
	Local nOpc := 0
	nOpc := ParamIXB[1]
	//----------------------------------------------
	// Função acionada para as rotinas do ISO-27001.
	//----------------------------------------------
	If nOpc==5 .And. FindFunction("U_CSATVMANU")
		U_CSATVMANU(4,"E")
	EndIf
	//--------------------------------------------------------
	// Função acionada para as rotinas do gestão de contrtaos.
	// Programador: Robson Gonçalves.
	//--------------------------------------------------------
	If FindFunction('U_A290GrvCNPJ')
		U_A290GrvCNPJ( nOpc )
	Endif
	//----------------------------------------------
	// Ao gravar o contrato, avisa para informar os usuários
	// da notificação de e-mail.
	//----------------------------------------------
	If nOpc == 3 .And. Empty( CN9->CN9_NOTVEN )
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>Não esqueça de cadastrar o(s) destinatário(s) para receber notificação baseado em cada situação do contrato.'+;
			         '<br><br>Ações relacionadas > Manutenções específicas > Notificação Venctos',;
			         'CN100GRC - E-mails de contratos' )
	EndIf	
Return 