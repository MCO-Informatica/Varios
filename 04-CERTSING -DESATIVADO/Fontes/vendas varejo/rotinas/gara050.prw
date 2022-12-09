#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA050   �Autor  �Armando M. Tessaroli� Data �  12/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de manutencao dos dados de validacao gravados pela   ���
���          �rotina GARA030                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GARA050()

Local aCores		:= {	{ "SZ5->Z5_COMISS=='1'",	"BR_VERDE"		},;
							{ "SZ5->Z5_COMISS=='2'",	"BR_AMARELO"	},;
							{ "SZ5->Z5_COMISS=='3'",	"BR_VERMELHO"	},;
							{ "EMPTY(SZ5->Z5_COMISS)",	"BR_PRETO"		};
						 }

PRIVATE aRotina := {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
						{ "Visualizar",	"U_GAR050Visu",	0, 2	},;
						{ "Incluir",	"U_GAR050Incl",	0, 3, 2	},;
						{ "Alterar",	"U_GAR050Alte",	0, 4, 2	},;
						{ "Excluir",	"U_GAR050Dele",	0, 5, 2	},;
						{ "Legenda",	"U_GAR050Lege",	0, 2	};
					}

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := "Manuten��o do apontamento de valida��es"


//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(0,0,0,0,"SZ5",,,,,,aCores)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GAR050Visu�Autor  �Armando M. Tessaroli� Data �  04/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de visualizacao.                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GAR050Visu(cAlias,nReg,nOpc)

	Local aButtons	:=	{} 
	
	//��������������������������������������������������Ŀ
	//� Adicao de botoes - Enchoice Principal            �
	//����������������������������������������������������

	AADD(aButtons,{"SDUSTRUCT",{||U_GAR050REM()},"Proc.Rem."}) // Consulta remuneracao gerada para este processo GAR
     
	AxVisual( cAlias, nReg, nOpc,,,,, aButtons )

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GAR050Alte�Autor  �Armando M. Tessaroli� Data �  04/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de Inclusao.                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GAR050Incl(cAlias,nReg,nOpc)

	AxInclui( cAlias, nReg, nOpc )

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GAR050Alte�Autor  �Armando M. Tessaroli� Data �  04/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de Alteracao.                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GAR050Alte(cAlias,nReg,nOpc)

	Local aParam	:= {}

	Local aButtons	:=	{} 

	If SZ5->Z5_ROTINA <> "GARA050"
		MsgStop("Este registro foi gerado pelo sistema e n�o pode ser alterado.")
		Return(.F.)
	Endif
		
	//��������������������������������������������������Ŀ
	//� Adicao de botoes - Enchoice Principal            �
	//����������������������������������������������������

	AADD(aButtons,{"SDUSTRUCT",{||U_GAR050REM()},"Proc.Rem."}) // Consulta remuneracao gerada para este processo GAR

	Aadd(aParam, {|| .T.} )					// Executa Antes da interface
	Aadd(aParam, {|| .T.} )					// Executa somente para Exclusao
	Aadd(aParam, {|| U_GAR050Grv() } )		// Executa dentro da transacao depois da gravacao
	Aadd(aParam, {|| .T.} )					// Executa fora da transacao depois da gravacao
	
	AxAltera( cAlias, nReg, nOpc,,,,,,,, aButtons, aParam )
	
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GAR050Dele  � Autor � Tatiana Pontes    � Data � 10/07/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Exclusao   									  ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GAR050Dele(cAlias,nReg,nOpc)

	Local aParam	:= {}
	Local aButtons	:= {} 
 	Local cLog		:= ""
	Local cRemPer	:= GetMV("MV_REMMES") // PERIODO DE CALCULO EM ABERTO
	
	If SZ5->Z5_ROTINA <> "GARA050"
		MsgStop("Este registro foi gerado pelo sistema e n�o pode ser exclu�do.")
		Return(.F.)
	Endif

	dbSelectArea("SZ6")
	SZ6->( DbSetOrder(3) )	// Z6_FILIAL + Z6_PEDGAR + Z6_TIPO          
	If SZ6->( MsSeek( xFilial("SZ6")+SZ5->Z5_PEDGAR+SZ5->Z5_TIPO ) )
	 	If SubStr(DtoS(SZ6->Z6_DTEMISS),1,6) < cRemPer
	  		cLog := "N�o � poss�vel excluir este registro." + CRLF
	  		cLog += "Existe movimentos de remunera��o para este registro em que o per�odo de remunera��o encontra-se fechado."
			MsgStop(cLog)
			Return(.F.)
		Endif
	Endif
		
	//��������������������������������������������������Ŀ
	//� Adicao de botoes - Enchoice Principal            �
	//����������������������������������������������������

	AADD(aButtons,{"SDUSTRUCT",{||U_GAR050REM()},"Proc.Rem."}) // Consulta remuneracao gerada para este processo GAR

	Aadd(aParam, {|| .T.} )					// Executa Antes da interface
	Aadd(aParam, {|| .T.} )					// Executa somente para Exclusao
	Aadd(aParam, {|| U_GAR050Grv() } )		// Executa dentro da transacao depois da gravacao
	Aadd(aParam, {|| .T.} )					// Executa fora da transacao depois da gravacao
 		
	AxDeleta( cAlias, nReg, nOpc,,, aButtons, aParam )
	
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA050   �Autor  �Armando M. Tessaroli� Data �  02/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GAR050Lege()

// 1=A Gerar;2=Gerado;3=Pago

BrwLegenda(cCadastro,"Legenda", {	{"BR_VERDE",	"N�o gerou valores de comiss�o"},;
									{"BR_AMARELO",	"Valores de comiss�o gerado"},;
									{"BR_VERMELHO",	"Valores de comiss�o j� pagos"},;
									{"BR_PRETO",	"Campo Z5_COMISS em branco.Conte�do '1'"};
								  };
			)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA050   �Autor  �Microsiga           � Data �  02/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GAR050Grv()

SZ6->( DbSetOrder(1) )		// Z6_FILIAL+Z6_PEDGAR+Z6_CODENT
SZ6->( MsSeek( xFilial("SZ6")+SZ5->Z5_PEDGAR ) )
While	SZ6->( !Eof() ) .AND.;
		SZ6->Z6_FILIAL == xFilial("SZ6") .AND.;
		AllTrim(SZ6->Z6_PEDGAR) == AllTrim(SZ5->Z5_PEDGAR)
	
	SZ6->( RecLock("SZ6",.F.) )
	SZ6->( DbDelete() )
	SZ6->( MsUnLock() )
	
	SZ6->( DbSkip() )
End

Return(.F.)       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GAR050REM  � Autor � Tatiana Pontes 	   � Data � 10/07/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Mostra remuneracao gerada para este processo Gar 		  ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GAR050REM()                       

	dbSelectArea("SZ6")
	SZ6->( DbSetOrder(3) )	// Z6_FILIAL + Z6_PEDGAR + Z6_TIPO          
	If SZ6->( MsSeek( xFilial("SZ6")+SZ5->Z5_PEDGAR+SZ5->Z5_TIPO ) )
		Set Filter to ALLTRIM(SZ5->Z5_PEDGAR) == ALLTRIM(SZ6->Z6_PEDGAR) .AND. SZ5->Z5_TIPO == SZ6->Z6_TIPO
		AxCadastro("SZ6","Lan�amentos de Remunera��o")
		Set Filter to
	Else
		MsgAlert("N�o h� lan�amentos de remunera��o relacionado a este processo GAR.")	
	Endif

Return()
