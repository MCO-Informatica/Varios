#INCLUDE "PROTHEUS.CH"

//���������������������������������������������������������������������Ŀ
//�CONSTRAINTS DE DEFINE UTILIZADAS PELAS FUNCOES DE INTEGRACAO         �
//�����������������������������������������������������������������������
#DEFINE _CIDENT "07"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSEP010  �Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Pontos de entrada no cadastro de produtos - MATA010        ���
���          � para sincronismo com o cadastro de plano de entidades      ���
���          � contabeis (CVO) - Entidade 07: Produtos Comercializados    ���
�������������������������������������������������������������������������͹��
���Uso       � MATA010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������͹��
���Funcoes   � MT010INC - PONTO DE ENTRADA APOS A INCLUSAO DO PRODUTO     ���
���Chamadoras� MT010ALT - PONTO DE ENTRADA APOS A ALTERACAO DO PRODUTO    ���
���          � MTA010E  - PONTO DE ENTRADA APOS A EXCLUSAO  DO PRODUTO    ���
�������������������������������������������������������������������������͹��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION CSEP010(nOpcX)

//�����������������������������������������������������������������������������Ŀ
//�REGRAS PARA INTEGRACAO ENTRE O CADASTRO DE PRODUTOS E A ENTIDADE 07          �
//�																				�
//�		+ A entidade sera criada com 20 posicoes, sendo:						� 
//�																				�
//�			- 1a posicao a 5a posicao : codigo do segmento do produto (B1_XSEG) �
//�			- 6a posicao a 20a posicao: codigo do produto (B1_COD)				�
//�																				�
//�		+ As entidades sinteticas dos grupos terao 5 digitos, 					�
//�		  representando o codigo do segmento (B1_XSEG)							�
//�																				�
//�		+ Os campos Produto Comercial Debito e Produto Comercial Credito, 	    �
//�       do cadastro de produtos ser�o preenchidos automaticamente,			�
//�		  utilizando a regra aqui definida.										�
//�������������������������������������������������������������������������������

//�����������������������������������������������������������������������������Ŀ
//�Variaveis necessarias ao processo vinculadas ao cadastro de produtos         �
//�Para todos os casos, o SB1 estah posicionado na execucao do P.E.				�
//�������������������������������������������������������������������������������
LOCAL cSB1_COD		:= ALLTRIM(SB1->B1_FILIAL)+ALLTRIM(+PADL(SB1->B1_COD,15,"0"))
LOCAL cSB1_DESC		:= ALLTRIM(SB1->B1_DESC)
LOCAL cSB1_CONTA	:= ALLTRIM(SB1->B1_CONTA)
LOCAL cSB1_MSBQL	:= IIF(SB1->(FieldPos("B1_MSBLQL")) > 0, SB1->B1_MSBLQL, "2")
LOCAL cSB1_MSBQD	:= IIF(SB1->(FieldPos("B1_MSBLQD")) > 0, SB1->B1_MSBLQD, CTOD(""))
LOCAL cSB1_XSEG		:= IIF(SB1->(FieldPos("B1_XSEG")) > 0	, ALLTRIM(SB1->B1_XSEG), "999999")
LOCAL cSB1SEGCOM	:= GETMV("MV_CSB1SEG",.F.,"")
LOCAL cCV0_COD		:= ""
LOCAL cCV0_CODSUP	:= ""
LOCAL cCV0_PLAN		:= ""
LOCAL cCV0_DESC		:= ""

//�����������������������������������������������������������������������������Ŀ
//�Abre tabelas acessorias que serao utilizadas no processamento                �
//�������������������������������������������������������������������������������
DbSelectArea("CT1")
DbSetOrder(1)

//�����������������������������������������������������������������������������Ŀ
//�Carrega as variaveis necessarias a identificado do plano da entidade         �
//�������������������������������������������������������������������������������
CSE010CV0P(@cCV0_PLAN, @cCV0_DESC)

IF cCV0_PLAN <> "00" 

	DO CASE
	
		CASE nOpcX == 3 .OR. nOpcX == 4 //INCLUSAO 
	
			IF !Empty(cSB1SEGCOM) .AND. (!EMPTY(cSB1_XSEG) .AND. ALLTRIM(cSB1_XSEG) $ ALLTRIM(cSB1SEGCOM))
				//���������������������������������������������������������������������Ŀ
				//�Inicia transacao para protecao das informacoes                       �
				//�����������������������������������������������������������������������
	    		Begin Transaction
				//���������������������������������������������������������������������Ŀ
				//�Efetua a criacao / manutencao da entidade base do cadastro do plano  �
				//�����������������������������������������������������������������������
				CSE010Plano(cCV0_PLAN,cCV0_DESC)
				//���������������������������������������������������������������������Ŀ
				//�Efetua a criacao / manutencao da entidade sintetica                  �
				//�����������������������������������������������������������������������
				CSE010Sint(nOpcX,cCV0_PLAN,cSB1_XSEG,@cCV0_CODSUP)
				//���������������������������������������������������������������������Ŀ
				//�Efetua a criacao / manutencao da entidade analitica                  �
				//�����������������������������������������������������������������������
				CSE010Anlt(nOpcX,cCV0_PLAN,cSB1_COD,cSB1_DESC,cSB1_MSBQL,cSB1_MSBQD,cSB1_CONTA,cCV0_CODSUP,@cCV0_COD)
				//���������������������������������������������������������������������Ŀ
				//�Vincula o cadastro de produtos a entidade analitica criada           �
				//�����������������������������������������������������������������������
				CSE010Updt(nOpcX,cCV0_COD,"SB1")
				//���������������������������������������������������������������������Ŀ
				//�Encerra transacao                                                    �
				//�����������������������������������������������������������������������
				End Transaction
			ENDIF
			
		CASE nOpcX == 5 // EXCLUSAO

			IF !Empty(cSB1SEGCOM) .AND. (!EMPTY(cSB1_XSEG) .AND. ALLTRIM(cSB1_XSEG) $ ALLTRIM(cSB1SEGCOM))
				//���������������������������������������������������������������������Ŀ
				//�Inicia transacao para protecao das informacoes                       �
				//�����������������������������������������������������������������������
	    		Begin Transaction
				//���������������������������������������������������������������������Ŀ
				//�Efetua a criacao / manutencao da entidade analitica                  �
				//�����������������������������������������������������������������������
				CSE010Anlt(nOpcX,cCV0_PLAN,cSB1_COD,nil/*cSB1_DESC*/,nil/*cSB1_MSBQL*/,nil/*cSB1_MSBQD*/,nil/*cSB1_CONTA*/,nil/*cCV0_CODSUP*/,nil/*cCV0_COD*/)
				//���������������������������������������������������������������������Ŀ
				//�Encerra transacao                                                    �
				//�����������������������������������������������������������������������
				End Transaction
	      ENDIF
	      
		CASE nOpcX == 6 // SINCRONIZAR CADASTROS

			IF ApMsgNoYes(	"Deseja realmente executar o sincronismo entre os cadastros "+CRLF+;
							"de produtos e o cadastro de orcamentos: produtos comercializados ?","Sincronismo: PRODUTOS COMERCIALIZADOS")
				MsgRun("Sincronizando planos de entidades contabeis...","Sincronismo: PRODUTOS COMERCIALIZADOS",{|| CSE010Sinc()})
			ENDIF

	ENDCASE
ELSE
	HELP(" ",1,"CSEP010.01",,	"A entidade contabil '"+_CIDENT+"' nao esta configurada no sistema."+CRLF+;
							  	"Nao sera possivel efetuar a integracao com o cadastro de produtos."+CRLF+;
							  	"Favor informar esta ocorrencia a area de sistemas.",4,0)
ENDIF

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE010Plan�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para verificacao e inclusao da linha base do        ���
���          � do cadastro da entidade.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION CSE010Plano(cCV0_PLAN,cCV0_DESC)

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
		CV0->CV0_PONTE		:= ""
	MsUnlock()		
ENDIF

RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE010Sint�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao da entidade sintetica no cadastro de���
���          � entidades contabeis - CV0: ENTIDADE 07.                    ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE010Sint(nOpcX,cCV0_PLAN,cSB1_XSEG,cCV0_CODSUP)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_COD 	:= PADL(SUBSTR(cSB1_XSEG,2,6),6,"0")
LOCAL cCV0_DESC	:= ""

DbSelectArea("SZ1")
DbSetOrder(1)
IF !Empty(cSB1_XSEG) .AND. DbSeek(xFilial("SZ1")+cSB1_XSEG)
	cCV0_DESC := UPPER(SUBSTR(SZ1->Z1_DESCSEG,1,30))
ELSE
	cCV0_DESC := "SEGMENTO "+cSB1_XSEG
ENDIF

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
				CV0->CV0_ITEM  		:= CSE010CV0I(cCV0_PLAN)
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
���Programa  �CSE010Anlt�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao da entidade analitica no cadastro   ���
���          � de entidades contabeis CV0: ENTIDADE 07.                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE010Anlt(nOpcX,cCV0_PLAN,cSB1_COD,cSB1_DESC,cSB1_MSBQL,cSB1_MSBQD,cSB1_CONTA,cCV0_CODSUP,cCV0_COD)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_DESC	:= UPPER(ALLTRIM(SUBSTR(cSB1_DESC,1,30)))

//���������������������������������������������������������������������Ŀ
//�Estrutura do codigo da entidade: SEGMENTO + COD. PRODUTO             �
//�����������������������������������������������������������������������
cCV0_COD 	:= cCV0_CODSUP+cSB1_COD

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
				CV0->CV0_BLOQUE		:= cSB1_MSBQL
				CV0->CV0_DTIBLQ		:= cSB1_MSBQD
				CV0->CV0_DTFBLQ		:= CTOD("")

				IF CV0->(FieldPos("CV0_ENT01")) > 0
					CV0->CV0_ENT01  := cSB1_CONTA
				ENDIF

				IF CV0->(FieldPos("CV0_E01DSC")) > 0
					CV0->CV0_E01DSC := GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+cSB1_CONTA,1,"")
				ENDIF

			MsUnlock()
			cCV0_COD := ALLTRIM(CV0->CV0_CODIGO)
		ELSE
			RecLock("CV0",.T.)
				CV0->CV0_FILIAL		:= xFilial("CV0")
				CV0->CV0_PLANO 		:= cCV0_PLAN
				CV0->CV0_ITEM  		:= CSE010CV0I(cCV0_PLAN)
				CV0->CV0_CODIGO		:= cCV0_COD
				CV0->CV0_DESC  		:= cCV0_DESC
				CV0->CV0_CLASSE		:= "2"
				CV0->CV0_NORMAL		:= "2"
				CV0->CV0_ENTSUP		:= cCV0_CODSUP
				CV0->CV0_BLOQUE		:= cSB1_MSBQL
				CV0->CV0_DTIBLQ		:= cSB1_MSBQD
				CV0->CV0_DTFBLQ		:= CTOD("")
				CV0->CV0_DTIEXI		:= CTOD("01/01/"+STR(Year(dDataBase),4))
				CV0->CV0_DTFEXI		:= CTOD("")
				CV0->CV0_CFGLIV		:= ""
				CV0->CV0_LUCPER		:= cCV0_COD
				CV0->CV0_PONTE		:= cCV0_COD

				IF CV0->(FieldPos("CV0_ENT01")) > 0
					CV0->CV0_ENT01  := cSB1_CONTA
				ENDIF

				IF CV0->(FieldPos("CV0_E01DSC")) > 0
					CV0->CV0_E01DSC := GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+cSB1_CONTA,1,"")
				ENDIF

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
			IF CSE010CT2M(cCV0_COD) 
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
���Programa  �CSE010Sinc�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para sincronizar o cadastro de produtos com o plano ���
���          � contabil da entidade 07 - Produtos Comercializados         ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CSE010Sinc()

LOCAL aArea 	:= GetArea()
LOCAL aAreaSB1  := SB1->(GetArea())

DbSelectArea("SB1")
DbSetOrder(1)     
DbGotop()//DbSeek(xFilial("SB1"))
WHILE SB1->(!EOF()) //.AND. SB1->B1_FILIAL == xFilial("SB1")

	//�����������������������������������������������������������������������Ŀ
	//�PARA CADA REGISTRO POSICIONADO, CHAMA A FUNCAO DE INCLUSAO DE ENTIDADE �
	//�������������������������������������������������������������������������
	U_CSEP010(3)

	SB1->(DbSkip())
END
RestArea(aAreaSB1)
RestArea(aArea)
RETURN
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSE010Prod�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para manutencao do vinculo entre o cadastro de pro- ���
���          � dutos e a entidade analitica do cadastro de entidades CV0  ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION CSE010Updt(nOpcX,cCV0_COD,cAliasUpd)

LOCAL cFieldDb	:= "B1_EC"+_CIDENT+"DB"
LOCAL cFieldCr	:= "B1_EC"+_CIDENT+"CR"

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
���Programa  �CSE010CV0P�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o codigo do plano de entidades contabeis para o ID ���
���          � de entidade informado.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE010CV0P(cCV0_PLAN, cCV0_DESC)

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
���Programa  �CSE010CV0I�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o proximo item para o plano de entidades contabeis ���
���          � informado.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE010CV0I(cCV0_PLAN)

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
���Programa  �CSE010CT2M�Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna se existem movimentos a debito ou a credito para   ���
���          � uma entidade informada.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CSE010CT2M(cCV0_COD)

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
���Programa  � CSE010BT �Autor  � TOTVS Protheus     � Data �  02/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicao de botoes na MBrowse          ���
�������������������������������������������������������������������������͹��
���Uso       � MATA010 - CADASTRO DE PRODUTOS                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
USER FUNCTION CSE010BT(aRotPad)

LOCAL aRotina	:= {}
LOCAL lSincCV0	:= GETMV("MV_CSCV0SN",.F.,.F.)
LOCAL cUsrSinc	:= GETMV("MV_CSCV0US",.F.,"000001")

IF lSincCV0 .AND. (EMPTY(cUsrSinc) .OR. __cUserID $ cUsrSinc)

	aAdd(aRotina,{ "Sinc.Cad.Orcamento"	,"U_CSEP010(6)", 0, 0, 0, .F.})

ENDIF

RETURN aRotina
*/