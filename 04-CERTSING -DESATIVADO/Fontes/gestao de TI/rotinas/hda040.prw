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
User Function HDA040()

PRIVATE aRotina := {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
						{ "Visualizar",	"AxVisual",	0, 2	},;
						{ "Incluir",	"AxInclui",	0, 3	},;
						{ "Alterar",	"AxAltera",	0, 4, 2	},;
						{ "Excluir",	"U_HD040Del",	0, 5, 1	};
						 }

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := "Analistas / Atendentes de chamados"

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(0,0,0,0,"U10")

Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA040    �Autor  �Microsiga           � Data �  08/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD040Del(cAlias, nReg, nOpc)

Local aParam	:= {}

Aadd( aParam, { || AllWaysTrue() } )		// Na entrada antes da tela
Aadd( aParam, { || U_HD040VldDel() } )		// Depois do OK e antes de apagar, retorna .T. ou .F.
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
User Function HD040VldDel()

U02->( DbSetOrder(6) )		// U02_FILIAL+U02_TECCOD
If U02->( MsSeek( xFilial("U02")+U10->U10_CODUSR ) )
	MsgStop("Este atendente est� vinculado a chamados de help desk e n�o poder� ser exclu�do")
	Return(.F.)
Endif

Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA040    �Autor  �Microsiga           � Data �  07/28/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD40CODSIS(cCampo)

Local cRet		:= ""
Local aPswRet	:= {}
Local cContVar	:= &( ReadVar() )

PswOrder(1)
If PswSeek(cContVar,.T.)
	aPswRet := Aclone( PSWRET(1) )
Endif

PswSeek(__cUserID,.T.)

Do Case
	Case AllTrim(cCampo) == "U10_CODUSR"
		cRet := aPSWRet[1][1]
		
	Case AllTrim(cCampo) == "U10_LOGSIS"
		cRet := aPSWRet[1][2]
		
	Case AllTrim(cCampo) == "U10_NOMUSR"
		cRet := Upper(aPSWRet[1][4])
		
	Case AllTrim(cCampo) == "U10_USRMAI"
		cRet := Lower(aPSWRet[1][14])
	
Endcase

Return(cRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HDA040    �Autor  �Microsiga           � Data �  08/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HD40VldCpo(cCampo)

Local aPswRet	:= {}
Local aPswGru	:= {}

Default cCampo	:= ""

If Empty(cCampo)
	Return(.F.)
Endif

Do Case
	Case AllTrim(cCampo) == "U10_CODSIS"
		PswOrder(1)
		If PswSeek(M->U10_CODSIS,.T.)
			aPswRet := Aclone( PSWRET(1) )
		Endif
		PswSeek(__cUserID,.T.)
		If Len(aPswRet) == 0
			MsgStop("Usu�rio " + M->U10_CODSIS + " n�o cadastrado no configurador...")
			Return(.F.)
		Endif
		
Endcase

Return(.T.)
