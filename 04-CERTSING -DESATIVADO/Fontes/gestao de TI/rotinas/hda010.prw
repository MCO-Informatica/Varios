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
User Function HDA010()

PRIVATE aRotina := {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
						{ "Visualizar",	"AxVisual",	0, 2	},;
						{ "Incluir",	"AxInclui",	0, 3	},;
						{ "Alterar",	"AxAltera",	0, 4, 2	},;
						{ "Excluir",	"U_HD010Del",	0, 5, 1	};
						 }

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := "Grupo de usu�rios"

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(0,0,0,0,"U07")

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA010    �Autor  �Microsiga           � Data �  08/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD010Del(cAlias, nReg, nOpc)

Local aParam	:= {}

Aadd( aParam, { || AllWaysTrue() } )		// Na entrada antes da tela
Aadd( aParam, { || U_HD010VldDel() } )		// Depois do OK e antes de apagar, retorna .T. ou .F.
Aadd( aParam, { || AllWaysTrue() } )		// Dentro da transacao
Aadd( aParam, { || AllWaysTrue() } )		// Depois da delecao apos a transacao


// AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons,aParam,aAuto,lMaximized)

AxDeleta( cAlias, nReg, nOpc,,,,aParam )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA010    �Autor  �Microsiga           � Data �  08/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD010VldDel()

// Cadastro de usuarios
U08->( DbSetOrder(4) )		// U08_FILIAL+U08_CODGRU
If U08->( MsSeek( xFilial("U08")+U07->U07_CODGRU ) )
	MsgStop("Este grupo possui usus�rios vinculados e n�o poder� ser exclu�do...")
	Return(.F.)
Endif

// Chamados de Help Desk
U02->( DbSetOrder(4) )		// U02_FILIAL+U02_USRGRU+U02_USRCOD
If U02->( MsSeek( xFilial("U02")+U07->U07_CODGRU ) )
	MsgStop("Este grupo est� vinculado a chamados de help desk e n�o poder� ser exclu�do")
	Return(.F.)
Endif

// Prioridade do grupo de usuarios
U13->( DbSetOrder(1) )		// U13_FILIAL+U13_CODGRU+U13_PRIORI
If U13->( MsSeek( xFilial("U13")+U07->U07_CODGRU ) )
	MsgStop("Este grupo est� vinculado a cadastro de prioridades do grupo e n�o poder� ser exclu�do")
	Return(.F.)
Endif

Return(.T.)
