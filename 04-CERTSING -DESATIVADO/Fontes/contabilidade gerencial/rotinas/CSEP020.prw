#INCLUDE "PROTHEUS.CH"
//���������������������������������������������������������������������Ŀ
//�CONSTRAINTS DE DEFINE UTILIZADAS PELAS FUNCOES DE INTEGRACAO         �
//�����������������������������������������������������������������������
#DEFINE _CIDENT   "05"
#DEFINE _CCODSUP  "F00000000"
#DEFINE _CDESCSUP "AG. DE NEGOCIOS: FORNECEDORES"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSEP020  �Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Pontos de entrada no cadastro de fornecedores - MATA020    ���
���          � para sincronismo com o cadastro de plano de entidades      ���
���          � contabeis (CVO) - Entidade 05: Agente de Negocio           ���
�������������������������������������������������������������������������͹��
���Uso       � MATA020 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 05    ���
�������������������������������������������������������������������������͹��
���Funcoes   � M020INC  - PONTO DE ENTRADA APOS A INCLUSAO DO FORNECEDOR  ���
���Chamadoras� M020ALT  - PONTO DE ENTRADA APOS A ALTERACAO DO FORNECEDOR ���
���          � MT020FOPOS-PONTO DE ENTRADA APOS A EXCLUSAO  DO FORNECEDOR ���
�������������������������������������������������������������������������͹��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION CSEP020(nOpcX)

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
LOCAL cSA2_COD		:= ALLTRIM(SA2->A2_COD)
LOCAL cSA2_LOJA	:= ALLTRIM(SA2->A2_LOJA)
LOCAL cSA2_DESC	:= ALLTRIM(SA2->A2_NREDUZ)
LOCAL cSA2_MSBQL	:= IIF(SA2->(FieldPos("A2_MSBLQL")) > 0, SA2->A2_MSBLQL, "2")
LOCAL cSA2_MSBQD	:= IIF(SA2->(FieldPos("A2_MSBLQD")) > 0, SA2->A2_MSBLQD, CTOD(""))
LOCAL cCV0_COD		:= ""
LOCAL cCV0_CODSUP	:= ""
LOCAL cCV0_PLAN	:= ""
LOCAL cCV0_DESC	:= ""

//�����������������������������������������������������������������������������Ŀ
//�Carrega as variaveis necessarias a identificado do plano da entidade         �
//�������������������������������������������������������������������������������
CSE020CV0P(@cCV0_PLAN, @cCV0_DESC)

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
			CSE020Plano(cCV0_PLAN,cCV0_DESC)
			//���������������������������������������������������������������������Ŀ
			//�Efetua a criacao / manutencao da entidade sintetica                  �
			//�����������������������������������������������������������������������
			CSE020Sint(nOpcX,cCV0_PLAN,_CCODSUP,@cCV0_CODSUP)
			//���������������������������������������������������������������������Ŀ
			//�Efetua a criacao / manutencao da entidade analitica                  �
			//�����������������������������������������������������������������������
			CSE020Anlt(nOpcX,cCV0_PLAN,cSA2_COD,cSA2_LOJA,cSA2_DESC,cSA2_MSBQL,cSA2_MSBQD,cCV0_CODSUP,@cCV0_COD)
			//���������������������������������������������������������������������Ŀ
			//�Vincula o cadastro de produtos a entidade analitica criada           �
			//�����������������������������������������������������������������������
			CSE020Updt(nOpcX,cCV0_COD,"SA2")
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
			CSE020Anlt(nOpcX,cCV0_PLAN,cSA2_COD,cSA2_LOJA,nil/*cSA2_DESC*/,nil/*cSA2_MSBQL*/,nil/*cSA2_MSBQD*/,nil/*cCV0_CODSUP*/,nil/*cCV0_COD*/)
			//���������������������������������������������������������������������Ŀ
			//�Encerra transacao                                                    �
			//�����������������������������������������������������������������������
			End Transaction

		CASE nOpcX == 6 // SINCRONIZAR CADASTROS

			IF ApMsgNoYes(	"Deseja realmente executar o sincronismo entre os cadastros "+CRLF+;
							"de fornecedores e o cadastro de orcamentos: agentes de negocios ?","Sincronismo: AGENTES DE NEGOCIOS")
				MsgRun("Sincronizando planos de entidades contabeis...","Sincronismo: AGENTES DE NEGOCIOS",{|| CSE020Sinc()})
			ENDIF
	
	ENDCASE
ELSE
	HELP(" ",1,"CSEP020.01",,	"A entidade contabil '"+_CIDENT+"' nao esta configurada no sistema."+CRLF+;
							  	"Nao sera possivel efetuar a integracao com o cadastro de fornecedores."+CRLF+;
							  	"Favor informar esta ocorrencia a area de sistemas.",4,0)
ENDIF

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE020Plan�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para verificacao e inclusao da linha base do        ���
���          � do cadastro da entidade.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION CSE020Plano(cCV0_PLAN,cCV0_DESC)

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
���Programa  �CSE020Sint�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao da entidade sintetica no cadastro de���
���          � entidades contabeis - CV0: ENTIDADE 05.                    ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE020Sint(nOpcX,cCV0_PLAN,cCV0_COD,cCV0_CODSUP)

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
				CV0->CV0_ITEM  		:= CSE020CV0I(cCV0_PLAN)
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
���Programa  �CSE020Anlt�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao da entidade analitica no cadastro   ���
���          � de entidades contabeis CV0: ENTIDADE 05.                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE020Anlt(nOpcX,cCV0_PLAN,cSA2_COD,cSA2_LOJA,cSA2_DESC,cSA2_MSBQL,cSA2_MSBQD,cCV0_CODSUP,cCV0_COD)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_DESC	:= IIF( nOpcX <> 5, ALLTRIM(SUBSTR(cSA2_DESC,1,30)), "")

//���������������������������������������������������������������������Ŀ
//�Estrutura do codigo da entidade: COD.FORNECEDOR + LOJA FORNECEDOR    �
//�����������������������������������������������������������������������
cCV0_COD 	:= "F"+PADL(cSA2_COD,6,"0")+PADL(cSA2_LOJA,02,"0")

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
				CV0->CV0_BLOQUE		:= cSA2_MSBQL
				CV0->CV0_DTIBLQ		:= cSA2_MSBQD
				CV0->CV0_DTFBLQ		:= CTOD("")
			MsUnlock()
			cCV0_COD := ALLTRIM(CV0->CV0_CODIGO)
		ELSE
			RecLock("CV0",.T.)
				CV0->CV0_FILIAL		:= xFilial("CV0")
				CV0->CV0_PLANO 		:= cCV0_PLAN
				CV0->CV0_ITEM  		:= CSE020CV0I(cCV0_PLAN)
				CV0->CV0_CODIGO		:= cCV0_COD
				CV0->CV0_DESC  		:= cCV0_DESC
				CV0->CV0_CLASSE		:= "2"
				CV0->CV0_NORMAL		:= "2"
				CV0->CV0_ENTSUP		:= cCV0_CODSUP
				CV0->CV0_BLOQUE		:= cSA2_MSBQL
				CV0->CV0_DTIBLQ		:= cSA2_MSBQD
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
			IF CSE020CT2M(cCV0_COD) 
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
���Programa  �CSE020Sinc�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para sincronizar o cadastro de fornecedores com o   ���
���          � plano contabil da entidade 05 - Agente de Negocios         ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENT. 05    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CSE020Sinc()

LOCAL aArea 	:= GetArea()
LOCAL aAreaSA2  := SA2->(GetArea())

DbSelectArea("SA2")
DbSetOrder(1)     
DbSeek(xFilial("SA2"))
WHILE SA2->(!EOF()) .AND. SA2->A2_FILIAL == xFilial("SA2")

	//�����������������������������������������������������������������������Ŀ
	//�PARA CADA REGISTRO POSICIONADO, CHAMA A FUNCAO DE INCLUSAO DE ENTIDADE �
	//�������������������������������������������������������������������������
	U_CSEP020(3)

	SA2->(DbSkip())
END
RestArea(aAreaSA2)
RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE020Forn�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao do vinculo entre o cadastro de for- ���
���          � necedores e a entidade analitica do plano de entidades CV0 ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION CSE020Updt(nOpcX,cCV0_COD,cAliasUpd)

LOCAL cFieldDb	:= "A2_EC"+_CIDENT+"DB"
LOCAL cFieldCr	:= "A2_EC"+_CIDENT+"CR"

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
���Programa  �CSE020CV0P�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o codigo do plano de entidades contabeis para o ID ���
���          � de entidade informado.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE020CV0P(cCV0_PLAN, cCV0_DESC)

LOCAL aArea 	:= GetArea()

DEFAULT cCV0_PLAN	:= "00"
DEFAULT cCV0_DESC := ""

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
���Programa  �CSE020CV0I�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o proximo item para o plano de entidades contabeis ���
���          � informado.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE020CV0I(cCV0_PLAN)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_ITEM	:= "000001"
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
���Programa  �CSE020CT2M�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna se existem movimentos a debito ou a credito para   ���
���          � uma entidade informada.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE020CT2M(cCV0_COD)

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
���Programa  � CSE020BT �Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicao de botoes na MBrowse          ���
�������������������������������������������������������������������������͹��
���Uso       � MATA020 - CADASTRO DE FORNECEDORES                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
USER FUNCTION CSE020BT(aRotPad)

LOCAL aRotina	:= {}
LOCAL lSincCV0	:= GETMV("MV_CSCV0SN",.F.,.F.)
LOCAL cUsrSinc	:= GETMV("MV_CSCV0US",.F.,"000001")

IF lSincCV0 .AND. (EMPTY(cUsrSinc) .OR. __cUserID $ cUsrSinc)

	aAdd(aRotina,{ "Sinc.Cad.Orcamento"	,"U_CSEP020(6)", 0, 0, 0, .F.})
	
ENDIF

RETURN aRotina
*/