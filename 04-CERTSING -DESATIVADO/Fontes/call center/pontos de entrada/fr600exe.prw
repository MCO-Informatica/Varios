#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FR600EXE  ºAutor  ³ERIK DE TARSOº Data ³  24/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exemplo para preenchimento de variaveis e tabelas usando	  º±±
±±º          ³a integracao com o WORD.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FR600EXE()

Local aArea			:= GetArea()						//Armazena area atual
Local hWord 		:= ParamIXB[1]						//Objeto usado para preenchimento

// dados da proposta
Local cProposta		:= Space(TamSX3("CJ_PROPOST")[1])		//Numero da proposta comercial 
Local cDtEmissao	:= Space(TamSX3("CJ_EMISSAO")[1])		//Data de emissao
local cPro			:= Space(TamSX3("AD1_DESCRI")[1])		//produto da proposta

// dados do cliente
Local cCodigo		:= Space(TamSX3("A1_COD")[1])	//Codigo da entidade (cliente ou prospect)
Local cLoja			:= Space(TamSX3("A1_LOJA")[1])	//Loja 
Local cNome 		:= Space(TamSX3("A1_NOME")[1])	//Nome
Local cEndereco		:= Space(TamSX3("A1_END")[1])	//Endereco
Local cBairro		:= Space(TamSX3("A1_BAIRRO")[1])	//Bairro
Local cCidade		:= Space(TamSX3("A1_MUN")[1])  	//Cidade
Local cUF			:= Space(TamSX3("A1_ESTADO")[1])	//Estado (UF)
local cOpor			:= Space(TamSX3("AD1_NROPOR")[1])	//Nro  da oportunidade

// dados do contato
local cNomCont		:= Space(TamSX3("U5_CONTAT")[1])	//Nome
local cTelCont		:= Space(TamSX3("U5_DDD")[1])+Space(TamSX3("U5_FONE")[1])  	//Telefone
local cEmlCont		:= Space(TamSX3("U5_EMAIL")[1])	//Email

// dados do vendedor
local cTelVend		:= Space(TamSX3("A3_TEL")[1])	//Telefone Vendedor
local cCodVen		:= Space(TamSX3("A3_COD")[1])	//Codigo vendedor
local cVenNom		:= Space(TamSX3("A3_NOME")[1])	//Nome vendedor
local cEmlVend		:= Space(TamSX3("A3_EMAIL")[1])	//Email do vendedor
local cCrgVen		:= Space(TamSX3("UM_DESC")[1])	//Descricao do cargo


local cChaveAd9		:= ""

Local nTotProsp		:= 0								//Total da proposta comercial
Local nI			:= 0                               	//Usado no laco do WHILE

Local cAno			:= year(ddatabase)
local lTemTab		:= .F.

cProposta	:= ALLTRIM(ADY->ADY_PROPOS )
cDescEnt	:= Space(30)
cDtEmissao	:= Dtoc(ADY->ADY_DATA)


//POSICIONA NO AD1 PARA BUSCAR O VENDEDOR
dbSelectArea("AD1")
dbSetOrder(1) //AD1_FILIAL+AD1_NROPOR+AD1_REVISA                          
IF	dbSeek(xFilial("AD1")+ADY->ADY_OPORTU+ADY->ADY_REVISA)                                                                                                      
	cPro		:= Alltrim(AD1->AD1_DESCRI)
	cCodVen 	:= ALLTRIM(AD1->AD1_VEND)
	cChaveAd9	:= AD1->AD1_NROPOR+AD1->AD1_REVISA 
	
	//POSICIONA NO VENDEDOR	
	dbSelectArea("SA3")
	dbSetOrder(1) 
	IF	dbSeek(xFilial("SA3")+AD1->AD1_VEND)                                                                                                      		            
		cVenNom 	:= ALLTRIM(A3_NOME)
		cTelVend	:= "("+ALLTRIM(A3_DDDTEL)+") "+SUBSTR(A3_TEL,1,4)+"-"+SUBSTR(A3_TEL,4,4)
		cEmlVend	:= ALLTRIM(A3_EMAIL)
		cOpor		:= ALLTRIM(AD1->AD1_NROPOR)
		//UM_FILIAL+UM_CARGO                                                                                                                                              
		cCrgVen		:= alltrim(POSICIONE("SUM",1,XFILIAL("SUM")+SA3->A3_CARGO,"UM_DESC"))
	ENDIF	                   
		
	//POSICIONA NO AD9 PARA BUSCAR OS DADOS DO CONTATO
	dbSelectArea("AD9")
	dbSetOrder(1) //AD1_FILIAL+AD1_NROPOR+AD1_REVISA                          
	IF	dbSeek(xFilial("AD9")+cChaveAd9)                                                                                                      	
		
		dbSelectArea("SU5")
		dbSetOrder(1)
		IF	dbSeek(xFilial("SU5")+AD9->AD9_CODCON)
			cNomCont 	:= ALLTRIM(U5_CONTAT)
			cTelCont    := "("+ALLTRIM(U5_DDD)+") " + SUBSTR(U5_FONE,1,4)+"-"+SUBSTR(U5_FONE,4,4)
			cEmlCont	:= ALLTRIM(U5_EMAIL)
        ENDIF

	ENDIF
ENDIF

If ADY->ADY_ENTIDA == "1"
	dbSelectArea("SA1")
	dbSetOrder(1)
	IF	dbSeek(xFilial("SA1")+ADY->ADY_CODIGO+ADY->ADY_LOJA)
		cCodigo		:= ALLTRIM(ADY->ADY_CODIGO)
		cLoja		:= ALLTRIM(ADY->ADY_LOJA)
		cNome 		:= ALLTRIM(A1_NOME)
		cEndereco	:= ALLTRIM(A1_END)
		cBairro		:= ALLTRIM(A1_BAIRRO)
		cCidade		:= ALLTRIM(A1_MUN)
		cUF			:= ALLTRIM(A1_EST)
		cDescEnt	:= ALLTRIM(A1_NREDUZ)
	Endif
Else
	dbSelectArea("SUS")
	dbSetOrder(1)
	IF	dbSeek(xFilial("SUS")+ADY->ADY_CODIGO+ADY->ADY_LOJA)
		cCodigo		:= ALLTRIM(ADY->ADY_CODIGO)
		cLoja		:= ALLTRIM(ADY->ADY_LOJA)
		cNome 		:= ALLTRIM(US_NOME)
		cEndereco	:= ALLTRIM(US_END)
		cBairro		:= ALLTRIM(US_BAIRRO)
		cCidade		:= ALLTRIM(US_MUN)
		cUF			:= ALLTRIM(US_EST)
		cDescEnt	:= ALLTRIM(US_NREDUZ)
	Endif
Endif 

cNomeWord	:=	""
cNomeWord	:= cOpor+ " - " +Alltrim(cDescEnt)+ " - " +cProposta

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza variaveis do cabecalho - Variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord,'cProposta'	,cProposta)
OLE_SetDocumentVar(hWord,'cDtEmissao'	,cDtEmissao)
OLE_SetDocumentVar(hWord,'cCodigo'		,cCodigo)
OLE_SetDocumentVar(hWord,'cNome'		,cNome)  			//0
OLE_SetDocumentVar(hWord,'cEndereco'	,cEndereco)
OLE_SetDocumentVar(hWord,'cBairro'		,cBairro)
OLE_SetDocumentVar(hWord,'cCidade'		,cCidade)
OLE_SetDocumentVar(hWord,'cUF'			,cUF)
OLE_SetDocumentVar(hWord,'cCodVen'			,cCodVen)
OLE_SetDocumentVar(hWord,'cVenNom'			,cVenNom)  		//5
OLE_SetDocumentVar(hWord,'cTelVend'			,cTelVend)      //7 e 8
OLE_SetDocumentVar(hWord,'cNomCont'			,cNomCont)      //1
OLE_SetDocumentVar(hWord,'cEmlCont'			,cEmlCont)      //4
OLE_SetDocumentVar(hWord,'cTelCont'			,cTelCont)      //2 e 3
OLE_SetDocumentVar(hWord,'cPro'			,cPro)      //10
OLE_SetDocumentVar(hWord,'cAno'			,cAno)      //xx
OLE_SetDocumentVar(hWord,'cEmlVend'			,cEmlVend)      //9
OLE_SetDocumentVar(hWord,'cOpor'			,cOpor)      //14
OLE_SetDocumentVar(hWord,'cCrgVen'			,cCrgVen)      //06

            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza variaveis do item - Tabela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("ADZ")
DbSetOrder(1) //ADZ_FILIAL+ADZ_PROPOS+ADZ_ITEM
If DbSeek(xFilial("ADZ")+cProposta)

	While ADZ->(!Eof()) .and. xFilial("ADZ")+ cProposta == ADZ->(ADZ_FILIAL+ADZ_PROPOS)
		
		nI++

		OLE_SetDocumentVar(hWord,"cProd1"+Alltrim(str(nI))  ,Alltrim( Posicione("SB1",1,xFilial("SB1")+ADZ->ADZ_PRODUT,"B1_DESC") ) ) //10
		OLE_SetDocumentVar(hWord,"nQuant1"+Alltrim(str(nI)) ,Transform(ADZ->ADZ_QTDVEN,"999,999,999.99"))                             //12
		OLE_SetDocumentVar(hWord,"nValUni1"+Alltrim(str(nI)),Transform(ADZ->ADZ_PRCVEN,"@EZ 999,999,999.99"))                         //11
		OLE_SetDocumentVar(hWord,"nTotal1"+Alltrim(str(nI)) ,Transform(ADZ->ADZ_TOTAL,"@EZ 999,999,999.99"))                          //13
		
		nTotProsp += ADZ->ADZ_TOTAL

		dbSelectArea("ADZ")
		dbSkip()

	Enddo
	
	OLE_SetDocumentVar(hWord,'nTotProsp',Transform(nTotProsp,"@EZ 999,999,999.99"))
	
Endif 

lTemTab	:= IIF (AG3->(FieldPos("AG3_TEMTAB"))<>0,IIF(AG3->AG3_TEMTAB == "1",.T.,.F.),.F.)

If nI > 0 .AND. lTemTab

	OLE_SetDocumentVar(hWord,'nItens_Proposta',alltrim(Str(nI))) //Nome do indicado da tabela no WORD
	OLE_ExecuteMacro(hWord,"Itens_Proposta") // Nome da macro usada para atualizar os itens	

Endif

RestArea(aARea)

Return