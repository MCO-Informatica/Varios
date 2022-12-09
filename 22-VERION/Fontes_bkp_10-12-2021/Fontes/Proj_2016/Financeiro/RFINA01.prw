#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                  DBM SYSTEM S/C/ LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �RFINA01 �Interface com Contas a Pagar - Arquivo Texto de pagamento a      ���
���            �        �funcion�rios                                                     ���
�����������������������������������������������������������������������������������������͹��
���Projeto/PL  �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Solicitante �05.03.08�Vanderleia                                                       ���
�����������������������������������������������������������������������������������������͹��
���Autor       �06.03.08�Almir Bandina                                                    ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �Nil                                                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
User Function RFINA01()
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da rotina                                                           �
//�������������������������������������������������������������������������������������������
Local aAreaAtu		:= GetArea()
Local aSays     	:= {}
Local aButtons  	:= {}
Local nOpca     	:= 0
Local cPerg			:= PadR( "FINA01", If( AllTrim( cVersao ) == "P10", 10, 6 ) )

Private cCadastro  	:= OemToAnsi( "Interface T�tulos a Pagar - Contabilidade" )
Private cArq		:= ""
Private cNomArq		:= ""
Private lEnd		:= .F.
//�����������������������������������������������������������������������������������������Ŀ
//� Monta a interface inicial com o usu�rio                                                 �
//�������������������������������������������������������������������������������������������
aAdd( aSays, OemToAnsi( "Este programa tem como objetivo efetuar a importa��o dos t�tulos a pagar"	))
aAdd( aSays, OemToAnsi( "de funcion�rios, atrav�s de arquivo do tipo texto e com base em lay-out"	))
aAdd( aSays, OemToAnsi( " pr�-definido fornecido pelo usu�rio."				 						))
aAdd( aSays, OemToAnsi( ""																			))
aAdd( aSays, OemToAnsi( "Clique no bot�o par�metros para selecionar o arquivo texto de interface."	))
aAdd( aButtons, { 5,	.T.	,	{ |o| ( CallPerg( cPerg ), o:oWnd:Refresh() )	} } )
aAdd( aButtons, { 14,	.T.	,	{ |o| ( AbreArq(), o:oWnd:Refresh() )			} } )
aAdd( aButtons, { 1,	.T.	,	{ |o| ( ImpArq( cPerg ),o:oWnd:End() ) 		} } )
aAdd( aButtons, { 2,	.T.	,	{ |o| o:oWnd:End()								} } )
FormBatch( cCadastro, aSays, aButtons )
//�����������������������������������������������������������������������������������������Ŀ
//� Restaura as �reas originais dos arquivos                                                �
//�������������������������������������������������������������������������������������������
RestArea(aAreaAtu)

Return(Nil)


/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                  DBM SYSTEM S/C/ LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �CallPerg�Cria o grupo de perguntas se n�o existir                         ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �ExpC1 = Alias do grupo de perguntas                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function CallPerg( cPerg )
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da rotina                                                           �
//�������������������������������������������������������������������������������������������
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aTamSX3	:= {}
Local aHelp		:= {}
//�����������������������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                                    �
//� mv_par01        // Natureza Adiantamento                                                �
//� mv_par02 	    // Natureza Folha                                                       �
//� mv_par03        // Natureza 13o.                                                        �
//� mv_par04 	    // Natureza Pr� Labore                                                  �
//� mv_par05        // C.Contabil Adiantamento                                              �
//� mv_par06 	    // C.Contabil Folha                                                     �
//� mv_par07        // C.Contabil 13o.                                                      �
//� mv_par08 	    // C.Contabil Pro Labore                                                �
//� mv_par09 	    // Tipo Adiantamento                                                    �
//� mv_par10 	    // Tipo Folha                                                           �
//� mv_par11 	    // Tipo 13o.                                                            �
//� mv_par12 	    // Tipo Pr� Labore                                                      �
//� mv_par13 	    // Data de Vencimento                                                   �
//�������������������������������������������������������������������������������������������
//�����������������������������������������������������������������������������������������Ŀ
//� Define os t�tulos e Help das perguntas                                                  �
//�������������������������������������������������������������������������������������������
//				"XXXXXXXXXXWWWWWWWWWWXXXXXXXXXX",	"", "",		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
aAdd(aHelp,{	"Natureza Adiantamento",			"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria��o de t�tulos de adiantamento de   ",	"sal�rio.                                " }, {""}, {""} } )
aAdd(aHelp,{	"Natureza Folha",					"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria��o de t�tulos de pagamento de      ",	"sal�rio.                                " }, {""}, {""} } )
aAdd(aHelp,{	"Natureza 13o.Salario",				"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria��o de t�tulos de 13o. sal�rio.     ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"Natureza Pro-Labore",				"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria��o de t�tulos de pro-labore.       ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil Adiantamento",			"",	"", {	"Informe a conta cont�bil a ser utilizada",	"na cria��o de t�tulos de adiantamento de",	"adiantamento de sal�rio.                " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil Folha",					"",	"", {	"Informe a conta cont�bil a ser utilizada",	"na cria��o de t�tulos de pagamento de   ",	"sal�rio.                                " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil 13o.Salario",			"",	"", {	"Informe a conta cont�bil a ser utilizada",	"na cria��o de t�tulos de 13o. sal�rio.  ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil Pro-Labore",			"",	"", {	"Informe a conta cont�bil a ser utilizada",	"na cria��o de t�tulos de pro-labore.    ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo Adiantamento",				"",	"", {	"Informe o tipo de t�tulos a ser         ",	"utilizado na cria��o de t�tulos de      ",	"adiantamento de sal�rio.                " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo Folha",						"",	"", {	"Informe o tipo de t�tulo a ser          ",	"utilizado na cria��o de t�tulos de      ",	"pagamento de sal�rio.                   " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo 13o. Salario",				"",	"", {	"Informe o tipo de t�tulo a ser          ",	"utilizado na cria��o de t�tulos de      ",	"13o. sal�rio.                           " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo Pro-Labore",					"",	"", {	"Informe o tipo de t�tulo a ser          ",	"utilizado na cria��o de t�tulos de      ",	"pro-labore.                             " }, {""}, {""} } )
aAdd(aHelp,{	"Data de Vencimento",				"",	"", {	"Informe a data de vencimento do t�tulo. ",	"                                        ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo de Importacao",				"",	"", {	"Informe o tipo de importa��o esta sendo ",	"executado.                              ",	"                                        " }, {""}, {""} } )
//�����������������������������������������������������������������������������������������Ŀ
//� Grava as perguntas no arquivo SX1                                                       �
//�������������������������������������������������������������������������������������������
aTamSX3	:= TAMSX3( "ED_CODIGO" )
//		cGrupo	cOrde	cDesPor			cDesSpa			cDesEng			cVar		cTipo		cTamanho	cDecimal	nPreSel	cGSC	cValid	cF3			cGrpSXG	cPyme	cVar01		cDef1Por		cDef1Spa	cDef1Eng	cCnt01	  					cDef2Por	cDef2Spa	cDef2Eng	cDef3Por	cDef3Spa	cDef3Eng	cDef4Por		cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor		aHelpEng		aHelpSpa		cHelp)
PutSx1(	cPerg,	"01",	aHelp[01,1],	aHelp[01,2],	aHelp[01,3],	"mv_ch1",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par01",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[01,4],	aHelp[01,5],	aHelp[01,6],	"" )
PutSx1(	cPerg,	"02",	aHelp[02,1],	aHelp[02,2],	aHelp[02,3],	"mv_ch2",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par02",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[02,4],	aHelp[02,5],	aHelp[02,6],	"" )
PutSx1(	cPerg,	"03",	aHelp[03,1],	aHelp[03,2],	aHelp[03,3],	"mv_ch3",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par03",	"",				"",			"",			"", 						"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[03,4],	aHelp[03,5],	aHelp[03,6],	"" )
PutSx1(	cPerg,	"04",	aHelp[04,1],	aHelp[04,2],	aHelp[04,3],	"mv_ch4",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par04",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[04,4],	aHelp[04,5],	aHelp[04,6],	"" )
aTamSX3	:= TAMSX3( "CT1_CONTA" )
PutSx1(	cPerg,	"05",	aHelp[05,1],	aHelp[05,2],	aHelp[05,3],	"mv_ch5",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par05",	"",				"",			"",			"",		 					"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[05,4],	aHelp[05,5],	aHelp[05,6],	"" )
PutSx1(	cPerg,	"06",	aHelp[07,1],	aHelp[07,2],	aHelp[07,3],	"mv_ch7",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par07",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[07,4],	aHelp[07,5],	aHelp[07,6],	"" )
PutSx1(	cPerg,	"07",	aHelp[06,1],	aHelp[06,2],	aHelp[06,3],	"mv_ch6",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par06",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[06,4],	aHelp[06,5],	aHelp[06,6],	"" )
PutSx1(	cPerg,	"08",	aHelp[08,1],	aHelp[08,2],	aHelp[08,3],	"mv_ch8",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par08",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[08,4],	aHelp[08,5],	aHelp[08,6],	"" )
aTamSX3	:= TAMSX3( "E1_TIPO" )
PutSx1(	cPerg,	"09",	aHelp[09,1],	aHelp[09,2],	aHelp[09,3],	"mv_ch9",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par09",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[09,4],	aHelp[09,5],	aHelp[09,6],	"" )
PutSx1(	cPerg,	"10",	aHelp[10,1],	aHelp[12,2],	aHelp[10,3],	"mv_chA",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par10",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[10,4],	aHelp[10,5],	aHelp[10,6],	"" )
PutSx1(	cPerg,	"11",	aHelp[11,1],	aHelp[11,2],	aHelp[11,3],	"mv_chB",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par11",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[11,4],	aHelp[11,5],	aHelp[11,6],	"" )
PutSx1(	cPerg,	"12",	aHelp[12,1],	aHelp[12,2],	aHelp[12,3],	"mv_chC",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par12",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[12,4],	aHelp[12,5],	aHelp[12,6],	"" )
aTamSX3	:= TAMSX3( "E1_VENCTO" )
PutSx1(	cPerg,	"13",	aHelp[13,1],	aHelp[13,2],	aHelp[13,3],	"mv_chD",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"",			"",		"N",	"mv_par09",	"",				"",			"",			"",							"",			"",			"",	  		"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[13,4],	aHelp[13,5],	aHelp[13,6],	"" )
PutSx1(	cPerg,	"14",	aHelp[14,1],	aHelp[14,2],	aHelp[14,3],	"mv_chE",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"C",	"",		"",			"",		"N",	"mv_par09",	"Adiantamento",	"",			"",			"",							"Folha",	"",			"",	  		"13o.Salario",	"",			"",			"Pro-Lanore",	"",			"",			"",			"",			"",			aHelp[13,4],	aHelp[13,5],	aHelp[13,6],	"" )
//�����������������������������������������������������������������������������������������Ŀ
//� Interface com o usu�rio                                                                 �
//�������������������������������������������������������������������������������������������
Pergunte( cPerg, .T. )
//�����������������������������������������������������������������������������������������Ŀ
//� Salva as �reas originais                                                                �
//�������������������������������������������������������������������������������������������
RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return( Nil )


/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                  DBM SYSTEM S/C/ LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �AbreArq �Faz a interface com o usu�rio para sele��o do arquivo            ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �Nil                                                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function AbreArq()
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da rotina                                                           �
//�������������������������������������������������������������������������������������������
Local cType		:=	"Arquivos TXT|*.TXT|Todos os Arquivos|*.*"
//�����������������������������������������������������������������������������������������Ŀ
//� Interface com usu�rio                                                                   �
//�������������������������������������������������������������������������������������������
cArq := cGetFile(	cType,;
					OemToAnsi( "Selecione o arquivo de interface" ),;
					0,;
					"SERVIDOR\SYSTEM\INTERFACE\",;
					.T.,;
					GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ;
					)

Return( Nil )


/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                  DBM SYSTEM S/C/ LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �ImpArq  �Prepara o processo de importa��o                                 ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �Nil                                                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function ImpArq( cPerg )
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da rotina                                                           �
//�������������������������������������������������������������������������������������������
Local cQry		:= ""
Local lRet		:= .T.

Private lLog	:= .T.
//�����������������������������������������������������������������������������������������Ŀ
//� Limpa espa�os em branco do arquivo                                                      �
//�������������������������������������������������������������������������������������������
cArq	:= AllTrim( cArq )
//�����������������������������������������������������������������������������������������Ŀ
//� Valida se o arquivo existe                                                              �
//�������������������������������������������������������������������������������������������
If lRet .And. Empty( cArq )
	Aviso(	cCadastro,;
			"O Arquivo para importa��o n�o foi selecionado !" + Chr(13) + Chr(10) +;
			"Rotina n�o poder� ser executada.",;
   			{ "&Retorna" },2,;
   			"Arquivo: " + cArq )
   lRet	:= .F.
EndIf
//�����������������������������������������������������������������������������������������Ŀ
//� Valida se o arquivo existe                                                              �
//�������������������������������������������������������������������������������������������
If lRet .And. !File( cArq )
	Aviso(	cCadastro,;
			"O Arquivo para importa��o selecionado n�o foi localizado !" + Chr(13) + Chr(10) +;
			"Rotina n�o poder� ser executada.",;
   			{ "&Retorna" },2,;
   			"Arquivo: " + cArq )
   lRet	:= .F.
EndIf
//�����������������������������������������������������������������������������������������Ŀ
//� Se o arquivo esta correto prepara para processamento                                    �
//�������������������������������������������������������������������������������������������
If lRet
	//�������������������������������������������������������������������������������������Ŀ
	//� Carrega as perguntas                                                                �
	//���������������������������������������������������������������������������������������
	If !( Pergunte( cPerg, .T. ) )
		lRet	:= .F.
	Else
		//���������������������������������������������������������������������������������Ŀ
		//� Obtem o nome do arquivo                                                         �
		//�����������������������������������������������������������������������������������
		cNomArq	:= SubStr( cArq, Rat( "\", cArq ) + 1, Len( cArq ) )
		//���������������������������������������������������������������������������������Ŀ
		//� Valida se a data de vencimento � igual ou posterior a data base                 �
		//�����������������������������������������������������������������������������������
		If mv_par13 < dDataBase
			Aviso(	cCadastro,;
					"A data de vencimento definida no par�metro � menor que a data base do sistema." + Chr(13) + Chr(10) +;
					"Rotina n�o poder� ser executada.",;
					{ "&Retorna" },2,;
					"Data Vencimento: " + DToC( mv_par13 ) )
			lRet	:= .F.
		Else
			//���������������������������������������������������������������������������������Ŀ
			//� Executa a chamada do processamento de im porta��o                               �
			//�����������������������������������������������������������������������������������
			Processa( { |lEnd| Importa( @lLog ) }, "Lendo arquivo texto" )
			//���������������������������������������������������������������������������������Ŀ
			//� Se n�o houve erro no processo fecha o processamento com mensagem                �
			//�����������������������������������������������������������������������������������
			If !lLog
				Aviso(	cCadastro,;
						"Processo de importa��o finalizado com sucesso.",;
						{ "&Continua" },,;
						"Final de Processamento" )
			Else
				lRet	:= .F.
			EndIf
		EndIf
	EndIf
EndIf

Return(lRet)


/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                  DBM SYSTEM S/C/ LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �Importa �Efetua a leitura e importa��o dos dados                          ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �ExpL1 = Vari�vel de controle de log                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function Importa( lLog )
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis da rotina                                                           �
//�������������������������������������������������������������������������������������������
Local aTitulos	:= {}
Local lRet		:= .T.
Local lGrvOk	:= .T.
Local nHdl		:= 0
Local nLinha	:= 0
Local nValor	:= 0
Local cBuffer	:= ""
Local cNome		:= ""
Local cTitulo	:= ""
Local cTipo		:= ""
Local cNat		:= ""
Local cConta	:= ""
Local cHist		:= ""
Local cEOL		:= CHR(13)+CHR(10)
Local cArqLog	:= SubStr( cNomArq, 1, At( ".", cNomArq ) - 1 ) + ".LOG"
Local cArqTmp	:= ""
Local cLog		:= ""
//�����������������������������������������������������������������������������������������Ŀ
//� Grava in�cio do arquivo de log                                                          �
//�������������������������������������������������������������������������������������������
cLog += "PROCESSAMENTO DO ARQUIVO " + cEOL
cLog += AllTrim( cNomArq )	+ cEOL
//GrvLog( cLog )
//�����������������������������������������������������������������������������������������Ŀ
//� ESTRUTURA DO ARQUIVO TEXTO FORNECIDO                                                    �
//� Ag�ncia          - 001 a 004 - (9)  - C�digo da ag�ncia banc�ria                        �
//� Conta            - 005 a 010 - (9)  - N�mero da Conta Corrente                          �
//� Nome Funcion�rio - 011 a 050 - (A)  - Nome do Funcion�rio                               �
//� Valor do T�tulo  - 051 a 060 - (9)2 - Valor do T�tulo                                   �
//�������������������������������������������������������������������������������������������
//�����������������������������������������������������������������������������������������Ŀ
//� Abre o arquivo texto                                                                    �
//�������������������������������������������������������������������������������������������
nHdl 	:= FT_FUSE(cArq)
//�����������������������������������������������������������������������������������������Ŀ
//� Valida se conseguiu abrir o arquivo texto                                               �
//�������������������������������������������������������������������������������������������
If nHdl <> Nil .and. nHdl <= 0
	Aviso(	cCadastro,;
			"N�o foi poss�vel obter a abertura exclusiva do arquivo texto !",;
			{ "&Retorna" },,;
			"Arquivo: " + AllTrim( cArq ) )
	//�������������������������������������������������������������������������������������Ŀ
	//� Fecha o arquivo texto                                                               �
	//���������������������������������������������������������������������������������������
	FT_FUSE()
	lRet	:= .F.
Endif

If lRet
	//���������������������������������������������������������������������������������Ŀ
	//� Define as vari�veis fixas                                                       �
	//�����������������������������������������������������������������������������������
    If mv_par14 == 1
		cTitulo	:= "AD" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par01
		cConta	:= mv_par05
		cTipo	:= mv_par09
		cHist	:= "ADIANTAMENTO SALARIO"
	ElseIf mv_par14 == 2
		cTitulo	:= "FO" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par02
		cConta	:= mv_par06
		cTipo	:= mv_par10
		cHist	:= "PAGAMENTO SALARIO"
	ElseIf mv_par14 == 3
		cTitulo	:= "13" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par03
		cConta	:= mv_par07
		cTipo	:= mv_par11
		cHist	:= "13o. SALARIO"
	ElseIf mv_par14 == 4
		cTitulo	:= "PL" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par04
		cConta	:= mv_par08
		cTipo	:= mv_par12
		cHist	:= "PRO-LABORE"
	Else
		cTitulo	:= "DV" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= PadL( "", TAMSX3( "ED_CODIGO" )[1] )
		cConta	:= PadL( "", TAMSX3( "CT1_CONTA" )[1] )
		cTipo	:= PadR( "NF", TAMSX3( "E2_TIPO" )[1] )
		cHist	:= "OUTROS PAGAMENTOS"
	EndIf
	//���������������������������������������������������������������������������������Ŀ
	//� Verifica se a natureza informada existe                                         �
	//�����������������������������������������������������������������������������������
	If !( SED->( MsSeek( xFilial( "SED" ) + cNat ) ) )
		cLog += "Natureza: "
		cLog += AllTrim( cNat )
		cLog += " n�o localizada no cadastro."
		cLog += cEOL
		//GrvLog( cLog )
		lGrvOk	:= .F.
	EndIf
	//���������������������������������������������������������������������������������Ŀ
	//� Verifica se a natureza informada existe                                         �
	//�����������������������������������������������������������������������������������
	If !( CT1->( MsSeek( xFilial( "CT1" ) + cConta ) ) )
		cLog += "Conta Cont�bil: "
		cLog += AllTrim( cConta )
		cLog += " n�o localizada no cadastro."
		//GrvLog( cLog )
		lGrvOk	:= .F.
	EndIf
	//���������������������������������������������������������������������������������Ŀ
	//� Verifica se a natureza informada existe                                         �
	//�����������������������������������������������������������������������������������
	If !( SX5->( MsSeek( xFilial( "SX5" ) + "05" + cTipo ) ) )
		cLog += "Tipo do T�tulo: "
		cLog += AllTrim( cTipo )
		cLog += " n�o localizado no cadastro."
		cLog += cEOL
		//GrvLog( cLog )
		lGrvOk	:= .F.
	EndIf
	//���������������������������������������������������������������������������������Ŀ
	//� Se n�o tem erro, processa o arquivo                                             �
	//�����������������������������������������������������������������������������������
	If lGrvOk
		//���������������������������������������������������������������������������������Ŀ
		//� Define a quantidade de registros a processar                                    �
		//�����������������������������������������������������������������������������������
		ProcRegua(FT_FLASTREC())
		//���������������������������������������������������������������������������������Ŀ
		//� Posiciona no in�cio do arquivo                                                  �
		//�����������������������������������������������������������������������������������
		FT_FGOTOP()
		//���������������������������������������������������������������������������������Ŀ
		//� Executa a leitura sequencial do arquivo texto                                   �
		//�����������������������������������������������������������������������������������
		While !FT_FEOF() .And. lRet
			//�����������������������������������������������������������������������������Ŀ
			//� Efetua a leitura da linha do arquivo                                        �
			//�������������������������������������������������������������������������������
			cBuffer := FT_FREADLN()
			nLinha	++
		    cNome	:= PadR( Substr( cBuffer, 11, 40 ), TAMSX3( "A2_NOME" )[1] )
		    nValor	:= Round( Val( SubStr( cBuffer, 51, 10 ) ) / 100, 2 )
			//�����������������������������������������������������������������������������Ŀ
			//� Movimenta a regua de processamento                                          �
			//�������������������������������������������������������������������������������
			IncProc("Lendo linha " + AllTrim( Str( nLinha ) ) + " do arquivo." )
			//�����������������������������������������������������������������������������Ŀ
			//� Se valor igual a zero, n�o importa                                          �
			//�������������������������������������������������������������������������������
			If nValor <= 0
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Valor: "
				cLog += AllTrim( Transform(nValor, "@E 999,999,999.99") )
				cLog += " n�o � v�lido."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			//�����������������������������������������������������������������������������Ŀ
			//� Pesquisa se o funcion�rio esta cadastrado como cliente                      �
			//�������������������������������������������������������������������������������
		 	dbSelectArea( "SA2" )
		 	dbSetOrder( 2 )				// FILIAL + NOME + LOJA
		 	If !( MsSeek( xFilial( "SA2" ) + cNome, .F. ) )
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Cliente: "
				cLog += AllTrim( cNome )
				cLog += " n�o localizado no cadastro."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			//�����������������������������������������������������������������������������Ŀ
			//� Valida se existe o centro de custo para o funcion�rio                       �
			//�������������������������������������������������������������������������������
			If Empty( SA2->A2_CCUSTO )
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Centro de Custo n�o informado para o fornecedor: "
				cLog += AllTrim( SA2->A2_COD ) + "/" + AllTrim( SA2->A2_LOJA ) +"."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			If !( ExistCpo( "CTT", SA2->A2_CCUSTO, .F. ) )
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Centro de Custo: "
				cLog += AllTrim( SA2->A2_CCUSTO )
				cLog += "n�o localizado no cadastro."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			//�����������������������������������������������������������������������������Ŀ
			//� Alimenta array com os t�tulos a serem processados                           �
			//�������������������������������������������������������������������������������
			aAdd( aTitulos, {	{ "E2_FILIAL",	xFilial( "SE2" ),		Nil },;		// Filial
								{ "E2_PREFIXO",	"FOL",					Nil },;		// Prefixo
								{ "E2_NUM",		cTitulo,				Nil },;		// N�mero do T�tulo
								{ "E2_PARCELA",	"",						Nil },;		// Parcela
								{ "E2_TIPO",	cTipo,					Nil },;		// Tipo
								{ "E2_NATUREZ",	cNat,					Nil },;		// Natureza
								{ "E2_FORNECE",	SA2->A2_COD,			Nil },;		// Codigo Fornecedor
								{ "E2_LOJA",	SA2->A2_LOJA,			Nil },;		// Loja Fornecedor
								{ "E2_NOMFOR",	SA2->A2_NREDUZ,			Nil },;		// Nome Reduzido
								{ "E2_EMISSAO",	dDataBase,				Nil },;		// Data Emiss�o
								{ "E2_VENCTO",	mv_par13,				Nil },;		// Data de Vencimento
								{ "E2_VENCREA",	DataValida( mv_par13 ),	Nil },;		// Data Vencimento Real
								{ "E2_VALOR",	nValor,					Nil },;		// Valor do T�tulo
								{ "E2_ISS",		0,						Nil },;		// Valor do ISS
								{ "E2_PARCISS",	" ",					Nil },;		// Parcela do ISS
								{ "E2_IRRF",	0,						Nil },;		// Valor do IRRF
								{ "E2_PARCIR",	" ",					Nil },;		// Parcela do IRRF
								{ "E2_EMIS1",	dDataBase,				Nil },;		// Data de Emiss�o Original
								{ "E2_HIST",	cHist,					Nil },;		// Hist�rico
								{ "E2_SALDO",	nValor,					Nil },;		// Saldo do T�tulo
								{ "E2_VENCORI",	mv_par13,				Nil },;		// Vencimento Original
								{ "E2_MOEDA",	1,						Nil },;		// Moeda
								{ "E2_VLCRUZ",	nValor,					Nil },;		// Valor Original
								{ "E2_FLUXO",	"S",					Nil },;		// Fluxo de Caixa
								{ "E2_ORIGEM",	"FINA050",				Nil },;		// Origem Lan�amento
								{ "E2_DESDOBR",	"N",					Nil },;		// Desdobramento de duplicatas
								{ "E2_INSS",	0,						Nil },;		// Valor do INSS
								{ "E2_PARCINS",	" ",					Nil },;		// Parcela do INSS
								{ "E2_MULTNAT", "2",					Nil },;		// Multiplas Naturezas
								{ "E2_DIRF",	"2",					Nil },;		// Controle da Dirf
								{ "E2_CODRET",	" ",					Nil },;		// C�digo de Reten��o Dirf
								{ "E2_CONTAD",	cConta,					Nil },;		// Conta Cont�bil
								{ "E2_CCD",		SA2->A2_CCUSTO,			Nil },;		// Centro de Custo
								{ "E2_LA",		"N",					Nil } ;		// Flag de Contabiliza��o
								} )
			//�����������������������������������������������������������������������������Ŀ
			//� Posiciona na proxima linha                                                  �
			//�������������������������������������������������������������������������������
			FT_FSKIP()
		EndDo
	EndIf
	//���������������������������������������������������������������������������������Ŀ
	//� Fecha o arquivo texto                                                           �
	//�����������������������������������������������������������������������������������
	FT_FUSE()
EndIf
//�����������������������������������������������������������������������������������������Ŀ
//� Grava e mostra o arquivo de log                                                         �
//�������������������������������������������������������������������������������������������
If !lGrvOk
	lLog	:= .T.
	lRet	:= .F.
	//�������������������������������������������������������������������������������������Ŀ
	//� inaliza o arquivo de log                                                            �
	//���������������������������������������������������������������������������������������
	//AutoGrLog(" ")
	//AutoGrLog("*** ERROS NO PROCESSAMENTO - ARQUIVO N�O FOI PROCESSADO ***")
	//AutoGrLog(" ")
	//�������������������������������������������������������������������������������������Ŀ
	//� Copia para tempor�rio o log do arquivo                                              �
	//���������������������������������������������������������������������������������������
	//cArqTmp	:= NomeAutoLog()
	//�������������������������������������������������������������������������������������Ŀ
	//� Delata o arquivo de log                                                             �
	//���������������������������������������������������������������������������������������
	If File( cArqLog )
		FErase( cArqLog )
	EndIf
	nHdlLog	:= fCreate( cArqLog, 0 )

	If nHdlLog < 0
		Aviso( cCadastro,;
		"N�o foi poss�vel criar o arquivo de log.",;
		{ "&Retorna" },,;
		"Arquivo: " + cArqLog )
	Else
		fWrite( nHdlLog, cLog, Len( cLog ) )
		fClose( nHdlLog )
		Aviso(	cCadastro,;
				"Ocorreram diverg�ncias no processo de importa��o." + Chr(13) + Chr(10) +;
				"Verificar arquivo de log no disret�rio \SYSTEM\.",;
				{ "&Continua" },,;
				"Arquivo: " + cArqLog )
	EndIf
	//�������������������������������������������������������������������������������������Ŀ
	//� Copia o arquivo tempor�rio completo para o arquivo de log                           �
	//���������������������������������������������������������������������������������������
	//__CopyFile( cArqTmp, cArqLog )
	//�������������������������������������������������������������������������������������Ŀ
	//� Faz interface com usu�rio para perguntar se mosta ou n�o o log em tela              �
	//���������������������������������������������������������������������������������������
	//If Aviso(	cCadastro,;
	//			"Ocorreram diverg�ncias na leitura do arquivo texto." + Chr(13) + Chr(10) +;
	//			"Deseja verificar as diverg�ncias ?",;
   	//			{ "&Sim", "&N�o" },2,;
	//   			"Diverg�ncia" ) == 1
	//	MostraErro(, cArqLog )
	//EndIf
//�����������������������������������������������������������������������������������������Ŀ
//� Processa a importa��o dos dados                                                         �
//�������������������������������������������������������������������������������������������
Else
	//�������������������������������������������������������������������������������������Ŀ
	//� Processa a MsExecAuto                                                               �
	//���������������������������������������������������������������������������������������
	Processa( { |lEnd| lGrvOk := GrvTit( aTitulos ) }, "Efetuando Grava��o dos Titulos", cCadastro )
	//�������������������������������������������������������������������������������������Ŀ
	//� Se n�o deu erro na MsExecAuto move o arquivo para diret�rio de processados          �
	//���������������������������������������������������������������������������������������
	If lGrvOk
		//���������������������������������������������������������������������������������Ŀ
		//� Monta o path de destino para arquivo processado                                 �
		//�����������������������������������������������������������������������������������
		cArqProc	:= AllTrim( GetSrvProfString( 'StartPath', '' ) )
		cArqProc	+= If( SubStr( cArqProc, Len( cArqProc ), 1 ) $ "\", "", "\") + "INTERFACE\" + cNomArq
		//���������������������������������������������������������������������������������Ŀ
		//� Copia o arquivo lido para o novo destino                                        �
		//�����������������������������������������������������������������������������������
		__CopyFile( cArq, cArqProc )
		//���������������������������������������������������������������������������������Ŀ
		//� Se a c�pia foi bem sucedida deleta o arquivo no diret�rio de recebidos          �
		//�����������������������������������������������������������������������������������
		If !File( cArqProc )
			Aviso(	cCadastro,;
					"N�o foi poss�vel efetuar a c�pia do arquivo para o diret�rio de processados." + Chr(13) + Chr(10) +;
					"O arquivo permanecer� no diret�rio para novo processamento.",;
					{ "&Continua" },2,;
					"Arquivo: " + cArqProc )
		Else
			FErase( cArq )
		EndIf
	EndIf
Endif

Return(lRet)


/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                  DBM SYSTEM S/C/ LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �GrvLog  �Fun��o de grava��o do log de processamento                       ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �ExpC1 = Mensagem a ser gravada                                            ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function GrvLog( cMsg )
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis utilizadas na rotina                                                �
//�������������������������������������������������������������������������������������������
lLog	:= .T.
//�����������������������������������������������������������������������������������������Ŀ
//� Grava a mensagem de log                                                                 �
//�������������������������������������������������������������������������������������������
AutoGrLog( cMsg )

Return(Nil)



/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                                  DBM SYSTEM S/C/ LTDA                                 ���
�����������������������������������������������������������������������������������������͹��
���Programa    �GrvTit  �Fun��o de grava��o dos pedidos de venda                          ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �ExpA1 = array com os titulos a serem gravados                             ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function GrvTit( aTitulos )
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis utilizadas na rotina                                                �
//�������������������������������������������������������������������������������������������
Local lGravaOk 	:= .T.
Local nLoop1	:= 0
//�����������������������������������������������������������������������������������������Ŀ
//� Seta a regua de processamento                                                           �
//�������������������������������������������������������������������������������������������
ProcRegua( Len( aTitulos ) )
//�������������������������������������������������������������������������������������Ŀ
//� Inicia o controle de transacao                                                      �
//���������������������������������������������������������������������������������������
Begin Transaction
	//�����������������������������������������������������������������������������������������Ŀ
	//� Varre todo o array de t�tulos                                                           �
	//�������������������������������������������������������������������������������������������
	For nLoop1	:= 1 To Len( aTitulos )
		//�������������������������������������������������������������������������������������Ŀ
		//� Movimenta a regua de processamento                                                  �
		//���������������������������������������������������������������������������������������
		IncProc( "Processando Fornecedor: " + aTitulos[nLoop1, 09, 02] )
		//�������������������������������������������������������������������������������������Ŀ
		//� Inicializa vari�veis da rotina autom�tica                                           �
		//���������������������������������������������������������������������������������������
		lMsErroAuto	:= .F.
		lMsHelpAuto	:= .F.
		//�������������������������������������������������������������������������������������Ŀ
		//� Executa rotina autom�tica                                                           �
		//���������������������������������������������������������������������������������������
		MsExecAuto( { |x,y,z| FINA050( x, y, z ) }, aTitulos[nLoop1], 3 )
		//�������������������������������������������������������������������������������������Ŀ
		//� Se teve erro avisa usu�rio                                                          �
		//���������������������������������������������������������������������������������������
		If lMsErroAuto
			Aviso(	cCadastro,;
					"Erro na inlcus�o do t�tulo." + Chr(13) + Chr(10) +;
					"Verifique o arquivo de log da rotina de inclus�o de t�tulo.",;
					{ "&Continua" },2,;
					"Erro na Rotina Autom�tica" )
			lGravaOk	:= .F.
		EndIf
		//�������������������������������������������������������������������������������������Ŀ
		//� Inicializa vari�veis da rotina autom�tica                                           �
		//���������������������������������������������������������������������������������������
		lMsErroAuto	:= .F.
		lMsHelpAuto	:= .F.
	Next nLoop1
//�������������������������������������������������������������������������������������Ŀ
//� Finaliza o controle de transa��o                                                    �
//���������������������������������������������������������������������������������������
End Transaction

Return(lGravaOk)
