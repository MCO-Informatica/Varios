#INCLUDE "PROTHEUS.CH"
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿎ONSTRAINTS DE DEFINE UTILIZADAS PELAS FUNCOES DE INTEGRACAO         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
#DEFINE _CIDENT   "05"
#DEFINE _CCODSUP  "F00000000"
#DEFINE _CDESCSUP "AG. DE NEGOCIOS: FORNECEDORES"
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  ? CSEP020  튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Pontos de entrada no cadastro de fornecedores - MATA020    볍?
굇?          ? para sincronismo com o cadastro de plano de entidades      볍?
굇?          ? contabeis (CVO) - Entidade 05: Agente de Negocio           볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? MATA020 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 05    볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튔uncoes   ? M020INC  - PONTO DE ENTRADA APOS A INCLUSAO DO FORNECEDOR  볍?
굇튏hamadoras? M020ALT  - PONTO DE ENTRADA APOS A ALTERACAO DO FORNECEDOR 볍?
굇?          ? MT020FOPOS-PONTO DE ENTRADA APOS A EXCLUSAO  DO FORNECEDOR 볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튣etorno   ? Nenhum                                                     볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
USER FUNCTION CSEP020(nOpcX)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿝EGRAS PARA INTEGRACAO ENTRE O CADASTRO DE FORNECEDORES E A ENTIDADE 05    	?
//?																				?
//?		+ A entidade sera criada com 09 posicoes, sendo:						?
//?			- 1a posicao	 : "C" OU "F" em fun豫o de ser cliente ou fornecedor?
//?			- 2a a 7a posicao: codigo do cliente ou fornecedor					?
//?			- 8a a 9a posicao: codigo da loja do cliente ou fonecedor			?
//?																				?
//?		+ As entidades sinteticas dos grupos ser?o:								?
//?			- C00000000 - AGENTES DE NEGOCIO: CLIENTES							?
//?			- F00000000 - AGENTES DE NEGOCIO: FORNECEDORES						?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿣ariaveis necessarias ao processo vinculadas ao cadastro de produtos       	?
//쿛ara todos os casos, o SB1 estah posicionado na execucao do P.E.				?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
LOCAL cSA2_COD		:= ALLTRIM(SA2->A2_COD)
LOCAL cSA2_LOJA	:= ALLTRIM(SA2->A2_LOJA)
LOCAL cSA2_DESC	:= ALLTRIM(SA2->A2_NREDUZ)
LOCAL cSA2_MSBQL	:= IIF(SA2->(FieldPos("A2_MSBLQL")) > 0, SA2->A2_MSBLQL, "2")
LOCAL cSA2_MSBQD	:= IIF(SA2->(FieldPos("A2_MSBLQD")) > 0, SA2->A2_MSBLQD, CTOD(""))
LOCAL cCV0_COD		:= ""
LOCAL cCV0_CODSUP	:= ""
LOCAL cCV0_PLAN	:= ""
LOCAL cCV0_DESC	:= ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿎arrega as variaveis necessarias a identificado do plano da entidade         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
CSE020CV0P(@cCV0_PLAN, @cCV0_DESC)

IF cCV0_PLAN <> "00"

	DO CASE
	
		CASE nOpcX == 3 .OR. nOpcX == 4 //INCLUSAO 
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿔nicia transacao para protecao das informacoes                       ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
    		Begin Transaction
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿐fetua a criacao / manutencao da entidade base do cadastro do plano  ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			CSE020Plano(cCV0_PLAN,cCV0_DESC)
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿐fetua a criacao / manutencao da entidade sintetica                  ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			CSE020Sint(nOpcX,cCV0_PLAN,_CCODSUP,@cCV0_CODSUP)
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿐fetua a criacao / manutencao da entidade analitica                  ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			CSE020Anlt(nOpcX,cCV0_PLAN,cSA2_COD,cSA2_LOJA,cSA2_DESC,cSA2_MSBQL,cSA2_MSBQD,cCV0_CODSUP,@cCV0_COD)
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿣incula o cadastro de produtos a entidade analitica criada           ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			CSE020Updt(nOpcX,cCV0_COD,"SA2")
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿐ncerra transacao                                                    ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			End Transaction

		CASE nOpcX == 5 // EXCLUSAO
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿔nicia transacao para protecao das informacoes                       ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
    		Begin Transaction
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿐fetua a criacao / manutencao da entidade analitica                  ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			CSE020Anlt(nOpcX,cCV0_PLAN,cSA2_COD,cSA2_LOJA,nil/*cSA2_DESC*/,nil/*cSA2_MSBQL*/,nil/*cSA2_MSBQD*/,nil/*cCV0_CODSUP*/,nil/*cCV0_COD*/)
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿐ncerra transacao                                                    ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020Plan튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Funcao para verificacao e inclusao da linha base do        볍?
굇?          ? do cadastro da entidade.                                   볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020Sint튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Funcao para manutencao da entidade sintetica no cadastro de볍?
굇?          ? entidades contabeis - CV0: ENTIDADE 05.                    볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
STATIC FUNCTION CSE020Sint(nOpcX,cCV0_PLAN,cCV0_COD,cCV0_CODSUP)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_DESC := _CDESCSUP

DO CASE

	CASE nOpcX == 3 .OR. nOpcX == 4 // INCLUSAO OU ALTERACAO
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//쿞e jah existir a entidade  retorna o codigo; senao cria              ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020Anlt튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Funcao para manutencao da entidade analitica no cadastro   볍?
굇?          ? de entidades contabeis CV0: ENTIDADE 05.                   볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
STATIC FUNCTION CSE020Anlt(nOpcX,cCV0_PLAN,cSA2_COD,cSA2_LOJA,cSA2_DESC,cSA2_MSBQL,cSA2_MSBQD,cCV0_CODSUP,cCV0_COD)

LOCAL aArea 	:= GetArea()
LOCAL cCV0_DESC	:= IIF( nOpcX <> 5, ALLTRIM(SUBSTR(cSA2_DESC,1,30)), "")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//쿐strutura do codigo da entidade: COD.FORNECEDOR + LOJA FORNECEDOR    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
cCV0_COD 	:= "F"+PADL(cSA2_COD,6,"0")+PADL(cSA2_LOJA,02,"0")

DO CASE

	CASE nOpcX == 3 .OR. nOpcX == 4 // INCLUSAO OU ALTERACAO
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//쿞e jah existir a entidade atualiza e retorna o codigo; senao cria    ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//쿣erifica se a entidade esta cadastrada no plano de entidades contabeis ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		DbSelectArea("CV0")
		DbSetOrder(1) // CV0_FILIAL+CV0_PLANO+CV0_CODIGO
		IF DbSeek(xFilial("CV0")+cCV0_PLAN+cCV0_COD)		
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//쿣erifica se a entidade possui movimentos: se sim bloqueia, senao exclui?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020Sinc튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Funcao para sincronizar o cadastro de fornecedores com o   볍?
굇?          ? plano contabil da entidade 05 - Agente de Negocios         볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENT. 05    볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
Static Function CSE020Sinc()

LOCAL aArea 	:= GetArea()
LOCAL aAreaSA2  := SA2->(GetArea())

DbSelectArea("SA2")
DbSetOrder(1)     
DbSeek(xFilial("SA2"))
WHILE SA2->(!EOF()) .AND. SA2->A2_FILIAL == xFilial("SA2")

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	//쿛ARA CADA REGISTRO POSICIONADO, CHAMA A FUNCAO DE INCLUSAO DE ENTIDADE ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	U_CSEP020(3)

	SA2->(DbSkip())
END
RestArea(aAreaSA2)
RestArea(aArea)
RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020Forn튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Funcao para manutencao do vinculo entre o cadastro de for- 볍?
굇?          ? necedores e a entidade analitica do plano de entidades CV0 볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020CV0P튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Retorna o codigo do plano de entidades contabeis para o ID 볍?
굇?          ? de entidade informado.                                     볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020CV0I튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Retorna o proximo item para o plano de entidades contabeis 볍?
굇?          ? informado.                                                 볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿎SE020CT2M튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Retorna se existem movimentos a debito ou a credito para   볍?
굇?          ? uma entidade informada.                                    볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? CSEP020 - INTEGRACAO CADASTRO DE FORNECEDORES X ENTIDADE 05볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  ? CSE020BT 튍utor  ? TOTVS Protheus     ? Data ?  02/12/2013 볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Ponto de entrada para adicao de botoes na MBrowse          볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? MATA020 - CADASTRO DE FORNECEDORES                         볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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