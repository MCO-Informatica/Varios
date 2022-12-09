#INCLUDE "PROTHEUS.CH"
//���������������������������������������������������������������������Ŀ
//�CONSTRAINTS DE DEFINE UTILIZADAS PELAS FUNCOES DE INTEGRACAO         �
//�����������������������������������������������������������������������
#DEFINE _CIDENT   "05"
#DEFINE _CCODSUP  "C00000000"
#DEFINE _CDESCSUP "AG. DE NEGOCIOS: CLIENTES"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSEP030  �Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Pontos de entrada no cadastro de clientes - MATA030        ���
���          � para sincronismo com o cadastro de plano de entidades      ���
���          � contabeis (CVO) - Entidade 05: Agente de Negocio           ���
�������������������������������������������������������������������������͹��
���Uso       � MATA030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������͹��
���Funcoes   � M030INC  - PONTO DE ENTRADA APOS A INCLUSAO DO CLIENTE     ���
���Chamadoras� MALTCLI  - PONTO DE ENTRADA APOS A ALTERACAO DO CLIENTE    ���
���          � M030EXC  - PONTO DE ENTRADA APOS A EXCLUSAO  DO CLIENTE    ���
�������������������������������������������������������������������������͹��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION CSEP030(nOpcX)

//�����������������������������������������������������������������������������Ŀ
//�REGRAS PARA INTEGRACAO ENTRE O CADASTRO DE FORNECEDORES E A ENTIDADE 05    	�
//�																				�
//�		+ A entidade sera criada com 09 posicoes, sendo:						�
//�			- 1a posicao	 : "C" OU "F" em fun��o de ser cliente ou fornecedor�
//�			- 2a a 7a posicao: codigo do cliente ou fornecedor					�
//�			- 8a a 9a posicao: codigo da loja do cliente ou fonecedor			�
//�																				�
//�		+ As entidades sinteticas dos grupos ser�o:								�
//�			- C00000000 - AGENTES DE NEGOCIO: CLIENTES							�
//�			- F00000000 - AGENTES DE NEGOCIO: FORNECEDORES						�
//�������������������������������������������������������������������������������

//�����������������������������������������������������������������������������Ŀ
//�Variaveis necessarias ao processo vinculadas ao cadastro de produtos       	�
//�Para todos os casos, o SB1 estah posicionado na execucao do P.E.				�
//�������������������������������������������������������������������������������
LOCAL cSA1_COD		:= ALLTRIM(SA1->A1_COD)
LOCAL cSA1_LOJA	:= ALLTRIM(SA1->A1_LOJA)
LOCAL cSA1_DESC	:= ALLTRIM(SA1->A1_NREDUZ)
LOCAL cSA1_MSBQL	:= IIF(SA1->(FieldPos("A1_MSBLQL")) > 0, SA1->A1_MSBLQL, "2")
LOCAL cSA1_MSBQD	:= IIF(SA1->(FieldPos("A1_MSBLQD")) > 0, SA1->A1_MSBLQD, CTOD(""))
LOCAL cCV0_COD		:= ""
LOCAL cCV0_CODSUP	:= ""
LOCAL cCV0_PLAN	:= ""
LOCAL cCV0_DESC	:= ""

//�����������������������������������������������������������������������������Ŀ
//�Carrega as variaveis necessarias a identificado do plano da entidade         �
//�������������������������������������������������������������������������������
CSE030CV0P(@cCV0_PLAN, @cCV0_DESC)

IF cCV0_PLAN <> "00"

	DO CASE
	
		CASE nOpcX == 3 .OR. nOpcX == 4 //INCLUSAO 
			//���������������������������������������������������������������������Ŀ
			//�Inicia transacao para protecao das informacoes                       �
			//�����������������������������������������������������������������������
    		Begin Transaction
			//���������������������������������������������������������������������Ŀ
			//�Efetua a criacao / manutencao da entidade base do cadastro do plano  �
			//�����������������������������������������������������������������������
			CSE030Plano(cCV0_PLAN,cCV0_DESC)
			//���������������������������������������������������������������������Ŀ
			//�Efetua a criacao / manutencao da entidade sintetica                  �
			//�����������������������������������������������������������������������
			CSE030Sint(nOpcX,cCV0_PLAN,_CCODSUP,@cCV0_CODSUP)
			//���������������������������������������������������������������������Ŀ
			//�Efetua a criacao / manutencao da entidade analitica                  �
			//�����������������������������������������������������������������������
			CSE030Anlt(nOpcX,cCV0_PLAN,cSA1_COD,cSA1_LOJA,cSA1_DESC,cSA1_MSBQL,cSA1_MSBQD,cCV0_CODSUP,@cCV0_COD)
			//���������������������������������������������������������������������Ŀ
			//�Vincula o cadastro de produtos a entidade analitica criada           �
			//�����������������������������������������������������������������������
			CSE030Updt(nOpcX,cCV0_COD,"SA1")
			//���������������������������������������������������������������������Ŀ
			//�Encerra transacao                                                    �
			//�����������������������������������������������������������������������
			End Transaction

		CASE nOpcX == 5 // EXCLUSAO
			//���������������������������������������������������������������������Ŀ
			//�Inicia transacao para protecao das informacoes                       �
			//�����������������������������������������������������������������������
    		Begin Transaction
			//���������������������������������������������������������������������Ŀ
			//�Efetua a criacao / manutencao da entidade analitica                  �
			//�����������������������������������������������������������������������
			CSE030Anlt(nOpcX,cCV0_PLAN,cSA1_COD,cSA1_LOJA,nil/*cSA1_DESC*/,nil/*cSA1_MSBQL*/,nil/*cSA1_MSBQD*/,nil/*cCV0_CODSUP*/,nil/*cCV0_COD*/)
			//���������������������������������������������������������������������Ŀ
			//�Encerra transacao                                                    �
			//�����������������������������������������������������������������������
			End Transaction
	
		CASE nOpcX == 6 // SINCRONIZAR CADASTROS

			IF ApMsgNoYes(	"Deseja realmente executar o sincronismo entre os cadastros "+CRLF+;
							"de clientes e o cadastro de orcamentos: agentes de negocios ?","Sincronismo: AGENTES DE NEGOCIOS")
				MsgRun("Sincronizando planos de entidades contabeis...","Sincronismo: AGENTES DE NEGOCIOS",{|| CSE030Sinc()})
			ENDIF

	ENDCASE
ELSE
	HELP(" ",1,"CSEP030.01",,	"A entidade contabil '"+_CIDENT+"' nao esta configurada no sistema."+CRLF+;
							  	"Nao sera possivel efetuar a integracao com o cadastro de clientes."+CRLF+;
							  	"Favor informar esta ocorrencia a area de sistemas.",4,0)
ENDIF

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030Plan�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para verificacao e inclusao da linha base do        ���
���          � do cadastro da entidade.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION CSE030Plano(cCV0_PLAN,cCV0_DESC)

LOCAL aArea 		:= GetArea()
LOCAL cCV0_COD		:= SPACE(TAMSX3("CV0_CODIGO")[1])

DbSelectArea("CV0")
DbSetOrder(1) // CV0_FILIAL+CV0_PLANO+CV0_CODIGO
IF !DbSeek(xFilial("CV0")+cCV0_PLAN+cCV0_COD)		
	RecLock("CV0",.T.)
		CV0->CV0_FILIAL		:= xFilial("CV0")
		CV0->CV0_PLANO 		:= cCV0_PLAN
		CV0->CV0_ITEM  		:= "000000"
		CV0->CV0_CODIGO		:= cCV0_COD
		CV0->CV0_DESC  		:= cCV0_DESC
		CV0->CV0_CLASSE		:= "1"
		CV0->CV0_NORMAL		:= "2"
		CV0->CV0_ENTSUP		:= ""
		CV0->CV0_BLOQUE		:= "2"
		CV0->CV0_DTIBLQ		:= CTOD("")
		CV0->CV0_DTFBLQ		:= CTOD("")
		CV0->CV0_DTIEXI		:= CTOD("01/01/"+STR(Year(dDataBase),4))
		CV0->CV0_DTFEXI		:= CTOD("")
		CV0->CV0_CFGLIV		:= ""
		CV0->CV0_LUCPER		:= ""
		CV0->CV0_PONTE			:= ""
	MsUnlock()		
ENDIF

RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030Sint�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao da entidade sintetica no cadastro de���
���          � entidades contabeis - CV0: ENTIDADE 05.                    ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE030Sint(nOpcX,cCV0_PLAN,cCV0_COD,cCV0_CODSUP)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_DESC := _CDESCSUP

DO CASE

	CASE nOpcX == 3 .OR. nOpcX == 4 // INCLUSAO OU ALTERACAO
		//���������������������������������������������������������������������Ŀ
		//�Se jah existir a entidade  retorna o codigo; senao cria              �
		//�����������������������������������������������������������������������
		DbSelectArea("CV0")
		DbSetOrder(1) // CV0_FILIAL+CV0_PLANO+CV0_CODIGO
		IF DbSeek(xFilial("CV0")+cCV0_PLAN+cCV0_COD)		
			cCV0_CODSUP := ALLTRIM(CV0->CV0_CODIGO)
		ELSE
			RecLock("CV0",.T.)
				CV0->CV0_FILIAL		:= xFilial("CV0")
				CV0->CV0_PLANO 		:= cCV0_PLAN
				CV0->CV0_ITEM  		:= CSE030CV0I(cCV0_PLAN)
				CV0->CV0_CODIGO		:= cCV0_COD
				CV0->CV0_DESC  		:= cCV0_DESC
				CV0->CV0_CLASSE		:= "1"
				CV0->CV0_NORMAL		:= "2"
				CV0->CV0_ENTSUP		:= ""
				CV0->CV0_BLOQUE		:= "2"
				CV0->CV0_DTIBLQ		:= CTOD("")
				CV0->CV0_DTFBLQ		:= CTOD("")
				CV0->CV0_DTIEXI		:= CTOD("01/01/"+STR(Year(dDataBase),4))
				CV0->CV0_DTFEXI		:= CTOD("")
				CV0->CV0_CFGLIV		:= ""
				CV0->CV0_LUCPER		:= cCV0_COD
				CV0->CV0_PONTE		:= cCV0_COD
			MsUnlock()		
			cCV0_CODSUP := ALLTRIM(CV0->CV0_CODIGO)
		ENDIF
	
	CASE nOpcX == 5 // EXCLUSAO

ENDCASE

RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030Anlt�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao da entidade analitica no cadastro   ���
���          � de entidades contabeis CV0: ENTIDADE 05.                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE030Anlt(nOpcX,cCV0_PLAN,cSA1_COD,cSA1_LOJA,cSA1_DESC,cSA1_MSBQL,cSA1_MSBQD,cCV0_CODSUP,cCV0_COD)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_DESC	:= IIF(nOpcX <> 5, ALLTRIM(SUBSTR(cSA1_DESC,1,30)), "")

//���������������������������������������������������������������������Ŀ
//�Estrutura do codigo da entidade: COD.CLIENTE + LOJA CLIENTE          �
//�����������������������������������������������������������������������
cCV0_COD 	:= "C"+PADL(cSA1_COD,6,"0")+PADL(cSA1_LOJA,02,"0")

DO CASE

	CASE nOpcX == 3 .OR. nOpcX == 4 // INCLUSAO OU ALTERACAO
		//���������������������������������������������������������������������Ŀ
		//�Se jah existir a entidade atualiza e retorna o codigo; senao cria    �
		//�����������������������������������������������������������������������
		DbSelectArea("CV0")
		DbSetOrder(1) // CV0_FILIAL+CV0_PLANO+CV0_CODIGO
		IF DbSeek(xFilial("CV0")+cCV0_PLAN+cCV0_COD)		
			RecLock("CV0",.F.)
				CV0->CV0_DESC  		:= cCV0_DESC			
				CV0->CV0_BLOQUE		:= cSA1_MSBQL
				CV0->CV0_DTIBLQ		:= cSA1_MSBQD
				CV0->CV0_DTFBLQ		:= CTOD("")
			MsUnlock()
			cCV0_COD := ALLTRIM(CV0->CV0_CODIGO)
		ELSE
			RecLock("CV0",.T.)
				CV0->CV0_FILIAL		:= xFilial("CV0")
				CV0->CV0_PLANO 		:= cCV0_PLAN
				CV0->CV0_ITEM  		:= CSE030CV0I(cCV0_PLAN)
				CV0->CV0_CODIGO		:= cCV0_COD
				CV0->CV0_DESC  		:= cCV0_DESC
				CV0->CV0_CLASSE		:= "2"
				CV0->CV0_NORMAL		:= "2"
				CV0->CV0_ENTSUP		:= cCV0_CODSUP
				CV0->CV0_BLOQUE		:= cSA1_MSBQL
				CV0->CV0_DTIBLQ		:= cSA1_MSBQD
				CV0->CV0_DTFBLQ		:= CTOD("")
				CV0->CV0_DTIEXI		:= CTOD("01/01/"+STR(Year(dDataBase),4))
				CV0->CV0_DTFEXI		:= CTOD("")
				CV0->CV0_CFGLIV		:= ""
				CV0->CV0_LUCPER		:= cCV0_COD
				CV0->CV0_PONTE		:= cCV0_COD
			MsUnlock()		
			cCV0_COD := ALLTRIM(CV0->CV0_CODIGO)
		ENDIF

	CASE nOpcX == 5 // EXCLUSAO
		//�����������������������������������������������������������������������Ŀ
		//�Verifica se a entidade esta cadastrada no plano de entidades contabeis �
		//�������������������������������������������������������������������������
		DbSelectArea("CV0")
		DbSetOrder(1) // CV0_FILIAL+CV0_PLANO+CV0_CODIGO
		IF DbSeek(xFilial("CV0")+cCV0_PLAN+cCV0_COD)		
			//�����������������������������������������������������������������������Ŀ
			//�Verifica se a entidade possui movimentos: se sim bloqueia, senao exclui�
			//�������������������������������������������������������������������������
			IF CSE030CT2M(cCV0_COD) 
				RecLock("CV0",.F.)
					CV0->CV0_BLOQUE		:= "1"
					CV0->CV0_DTIBLQ		:= FirstDay(dDataBase)
				MsUnlock()
			ELSE
				RecLock("CV0",.F.)
					DbDelete()
				MsUnlock()
			ENDIF

		ENDIF

ENDCASE

RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030Sinc�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para sincronizar o cadastro de clientes com o plano ���
���          � contabil da entidade 05 - Agente de Negocios               ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CSE030Sinc()

LOCAL aArea 	:= GetArea()
LOCAL aAreaSA1  := SA1->(GetArea())

DbSelectArea("SA1")
DbSetOrder(1)     
DbSeek(xFilial("SA1"))
WHILE SA1->(!EOF()) .AND. SA1->A1_FILIAL == xFilial("SA1")

	//�����������������������������������������������������������������������Ŀ
	//�PARA CADA REGISTRO POSICIONADO, CHAMA A FUNCAO DE INCLUSAO DE ENTIDADE �
	//�������������������������������������������������������������������������
	U_CSEP030(3)

	SA1->(DbSkip())
END
RestArea(aAreaSA1)
RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030Forn�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao do vinculo entre o cadastro de for- ���
���          � necedores e a entidade analitica do plano de entidades CV0 ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION CSE030Updt(nOpcX,cCV0_COD,cAliasUpd)

LOCAL cFieldDb	:= "A1_EC"+_CIDENT+"DB"
LOCAL cFieldCr	:= "A1_EC"+_CIDENT+"CR"

DO CASE

	CASE nOpcX == 3 // INCLUSAO
		RecLock(cAliasUpd,.F.)
			(cAliasUpd)->&(cFieldDb) := cCV0_COD
			(cAliasUpd)->&(cFieldCr) := cCV0_COD
		MsUnlock()              
		
	CASE nOpcX == 4 // ALTERACAO
		RecLock(cAliasUpd,.F.)
			(cAliasUpd)->&(cFieldDb) := cCV0_COD
			(cAliasUpd)->&(cFieldCr) := cCV0_COD
		MsUnlock()
	
	CASE nOpcX == 5 // EXCLUSAO

ENDCASE

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030CV0P�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o codigo do plano de entidades contabeis para o ID ���
���          � de entidade informado.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE030CV0P(cCV0_PLAN, cCV0_DESC)

LOCAL aArea 	:= GetArea()

DEFAULT cCV0_PLAN	:= "00"
DEFAULT cCV0_DESC	:= "" 

DbSelectArea("CT0")
DbSetOrder(1) // CT0_FILIAL+CT0_ID
IF DbSeek(xFilial("CT0")+_CIDENT)
	cCV0_PLAN	:= CT0->CT0_ENTIDA	 
	cCV0_DESC	:= CT0->CT0_DESC
ENDIF

RestArea(aArea)
RETURN cCV0_PLAN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030CV0I�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o proximo item para o plano de entidades contabeis ���
���          � informado.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE030CV0I(cCV0_PLAN)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_ITEM	:= "000000"
LOCAL cQuery	:= ""
LOCAL cAliasQry	:= GetNextAlias()

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF

cQuery := "SELECT MAX(CV0_ITEM) AS CV0MAXITEM FROM "+RetSqlName("CV0")+" CV0 "
cQuery += "WHERE "
cQuery += " 		CV0.CV0_FILIAL ='"+xFilial("CV0")+"' "
cQuery += " AND 	CV0.CV0_PLANO  ='"+cCV0_PLAN+"' "
cQuery += " AND CV0.D_E_L_E_T_  =' '"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 

(cAliasQry)->(DbGotop())
IF (cAliasQry)->(!EOF())
	cCV0_ITEM := (cAliasQry)->CV0MAXITEM
ENDIF

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF

RestArea(aArea)
RETURN (SOMA1(cCV0_ITEM))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE030CT2M�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna se existem movimentos a debito ou a credito para   ���
���          � uma entidade informada.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP030 - INTEGRACAO CADASTRO DE CLIENTES X ENTIDADE 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE030CT2M(cCV0_COD)

LOCAL aArea 	:= GetArea()
LOCAL cQuery	:= ""
LOCAL cFieldDb	:= "CT2_EC"+_CIDENT+"DB"
LOCAL cFieldCr	:= "CT2_EC"+_CIDENT+"CR"
LOCAL cAliasQry	:= GetNextAlias()
LOCAL nCountMvt	:= 0

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF

cQuery := "SELECT 'D' AS CT2DC, COUNT(*) AS CT2MOVTOS FROM "+RetSqlName("CT2")+" CT2 "
cQuery += "WHERE "
cQuery += " 		CT2.CT2_FILIAL 	 ='"+xFilial("CT2")+"' "
cQuery += " AND 	CT2."+cFieldDb+" ='"+cCV0_COD+"' "
cQuery += " AND CT2.D_E_L_E_T_  =' ' "
cQuery += " UNION ALL "
cQuery := "SELECT 'C' AS CT2DC, COUNT(*) AS CT2MOVTOS FROM "+RetSqlName("CT2")+" CT2 "
cQuery += "WHERE "
cQuery += " 		CT2.CT2_FILIAL 	 ='"+xFilial("CT2")+"' "
cQuery += " AND 	CT2."+cFieldCr+" ='"+cCV0_COD+"' "
cQuery += " AND CT2.D_E_L_E_T_  =' ' "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 
TCSetField(cAliasQry, "CT2MOVTOS", "N",18,2)

(cAliasQry)->(DbGotop())
WHILE (cAliasQry)->(!EOF())
	nCountMvt += (cAliasQry)->CT2MOVTOS
	(cAliasQry)->(DbSkip())
END

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF

RestArea(aArea)
RETURN (nCountMvt > 0)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSE030BT �Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicao de botoes na MBrowse          ���
�������������������������������������������������������������������������͹��
���Uso       � MATA030 - CADASTRO DE CLIENTES                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
USER FUNCTION CSE030BT(aRotPad)

LOCAL aRotina	:= {}
LOCAL lSincCV0	:= GETMV("MV_CSCV0SN",.F.,.F.)
LOCAL cUsrSinc	:= GETMV("MV_CSCV0US",.F.,"000001")

IF lSincCV0 .AND. (EMPTY(cUsrSinc) .OR. __cUserID $ cUsrSinc)

	aAdd(aRotina,{ "Sinc.Cad.Orcamento"	,"U_CSEP030(6)", 0, 0, 0, .F.})

ENDIF

RETURN aRotina
*/