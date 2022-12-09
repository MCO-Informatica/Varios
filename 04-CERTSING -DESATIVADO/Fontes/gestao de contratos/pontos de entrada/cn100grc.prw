/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CN100GRC   � Autor � Marcelo Celi Marques � Data � 19/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de Entrada para tratar as integracoes apos a manuten- ��� 
���          �cao do cadastro de Gestao de Contratos.				      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                 
#Include "Protheus.ch"
#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
User Function CN100GRC()
	Local nOpc := 0
	nOpc := ParamIXB[1]
	//----------------------------------------------
	// Fun��o acionada para as rotinas do ISO-27001.
	//----------------------------------------------
	If nOpc==5 .And. FindFunction("U_CSATVMANU")
		U_CSATVMANU(4,"E")
	EndIf
	//--------------------------------------------------------
	// Fun��o acionada para as rotinas do gest�o de contrtaos.
	// Programador: Robson Gon�alves.
	//--------------------------------------------------------
	If FindFunction('U_A290GrvCNPJ')
		U_A290GrvCNPJ( nOpc )
	Endif
	//----------------------------------------------
	// Ao gravar o contrato, avisa para informar os usu�rios
	// da notifica��o de e-mail.
	//----------------------------------------------
	If nOpc == 3 .And. Empty( CN9->CN9_NOTVEN )
		MsgAlert(cFONT+'ATEN��O'+cNOFONT+;
			         '<br><br>N�o esque�a de cadastrar o(s) destinat�rio(s) para receber notifica��o baseado em cada situa��o do contrato.'+;
			         '<br><br>A��es relacionadas > Manuten��es espec�ficas > Notifica��o Venctos',;
			         'CN100GRC - E-mails de contratos' )
	EndIf	
Return 