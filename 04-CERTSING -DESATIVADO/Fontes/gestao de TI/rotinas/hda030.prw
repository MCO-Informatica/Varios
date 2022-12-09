#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  07/27/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HDA030()

PRIVATE aRotina := {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
						{ "Visualizar",	"AxVisual",	0, 2	},;
						{ "Incluir",	"AxInclui",	0, 3	},;
						{ "Alterar",	"AxAltera",	0, 4, 2	},;
						{ "Excluir",	"U_HD030Del",	0, 5, 1	};
						 }

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := "Grupo de atendimento"

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(0,0,0,0,"U09")

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA030    �Autor  �Microsiga           � Data �  08/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD030Del(cAlias, nReg, nOpc)

Local aParam	:= {}

Aadd( aParam, { || AllWaysTrue() } )		// Na entrada antes da tela
Aadd( aParam, { || U_HD030VldDel() } )		// Depois do OK e antes de apagar, retorna .T. ou .F.
Aadd( aParam, { || AllWaysTrue() } )		// Dentro da transacao
Aadd( aParam, { || AllWaysTrue() } )		// Depois da delecao apos a transacao


// AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons,aParam,aAuto,lMaximized)

AxDeleta( cAlias, nReg, nOpc,,,,aParam )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA030    �Autor  �Microsiga           � Data �  08/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD030VldDel()

// Cadastro de usuarios
U10->( DbSetOrder(3) )		// U10_FILIAL+U10_CODGRU
If U10->( MsSeek( xFilial("U10")+U09->U09_CODGRU ) )
	MsgStop("Este grupo possui usus�rios vinculados e n�o poder� ser exclu�do...")
	Return(.F.)
Endif

// Classificacao dos chamados
U11->( DbSetOrder(3) )		// U11_FILIAL+U11_CODGRU
If U11->( MsSeek( xFilial("U11")+U09->U09_CODGRU ) )
	MsgStop("Este grupo possui classifica��o de chamados vinculados e n�o poder� ser exclu�do...")
	Return(.F.)
Endif

// Chamados de Help Desk
U02->( DbSetOrder(7) )		// U02_FILIAL+U02_GRUATD
If U02->( MsSeek( xFilial("U02")+U09->U09_CODGRU ) )
	MsgStop("Este grupo est� vinculado a chamados de help desk e n�o poder� ser exclu�do")
	Return(.F.)
Endif

Return(.T.)
