#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "COLORS.CH"

#DEFINE PRODUTO		002
#DEFINE DESCRICAO	003
#DEFINE REFERENCIA	004
#DEFINE UNIDADE		005
#DEFINE CONTAGEM	006
#DEFINE MARCA		007
#DEFINE ENDERECO	008
#DEFINE QTDREAL		009
#DEFINE CONFERIDO	010
#DEFINE ORDEM		011
#DEFINE REG			012
#DEFINE CODBAR		013
#DEFINE PRODESCON	014


//??????????????????????????????????????//
//                        Low Intensity colors
//??????????????????????????????????????//


#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY  CLR_HGRAY


//??????????????????????????????????????//
//                       High Intensity Colors
//??????????????????????????????????????//


#define CLR_GRAY        8421504               // RGB( 128, 128, 128 )
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 )
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 )
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 )
#define CLR_HRED            255               // RGB( 255,   0,   0 )
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 )
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 )
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 )
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description                                                     
{'','Produto','Descri?o','Refer?cia','Unidade','Contagem','Marca','Endere?'}                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author Luiz Alberto V Alves - lalberto@3lsystems.com.br                                              
@since 1/10/2012                                                   
/*/                                                             
//--------------------------------------------------------------
User Function CdBarOp()
Local aArea := GetArea()
Local oBt1
Local oBt2
Private _cIdCracha := Space(06)
Private lSupervisor := .f.
Public lAuto := .f.

Static oDlg            
	
//If Select("SX2") == 0
	lAuto := .t.
	RPCSetType( 3 )	// N? consome licen? de uso
	RpcSetEnv('00','01',,,,GetEnvServer()) //, _aTabs
//Endif                                                                                                                 


If Type("lAcessou") == "U"
	Public lAcessou := .f.
Endif
           
// Tela de Login 

While .t.                      
	_cIdCracha := Space(06)
	If !U_TelaAOpe(.t.,.f.)
		Return .f.
	Endif
	Public nRegSRA := SRA->(Recno())

	IF Empty(_cIdCracha)
		Return .f.
	Endif
	
	If Type("nRegSRA") <> 'U'
		SRA->(dbGoTo(nRegSRA))
	Else
		SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+__cUserID))
		Public nRegSRA := SRA->(Recno())
	Endif        

	U_CDBARCTR()

Enddo
SetKey(119, )

If lAuto
	RESET ENVIRONMENT
Endif
Return

User Function CDBARCTR()
Local aArea := GetArea()
Local lSai	:= .f.

Private oDlgCnf
Private oGetBar
Private cCodBar   := Space(30)
Private oGetRec
Private cCodRec   := Space(10)
Private oBtnSai
Private aSizeAut  := {}
Private aObjects  := {}
Private aInfo     := {}
Private aPosGet   := {}
Private aPosObj   := {}
Private oMsgErro
Private oMsgSuc

//SRA->(dbGoTo(nRegSRA))

// Maximizacao da tela em rela?o a area de trabalho
While !lSai

  	DEFINE MSDIALOG oDlgCnf TITLE "Controle de O.P. - Operador: " + Capital(SRA->RA_NOME) + Iif(lSupervisor,' * Supervisor *','') FROM 0,0 To 400,0600 COLORS 0, 16777215 PIXEL


    @ 020, 020 SAY oSayRec PROMPT "RECURSO" SIZE 250, 030 OF oDlgCnf COLORS CLR_GREEN,CLR_WHITE PIXEL
    @ 040, 020 MSGET oGetRec VAR cCodRec Valid(Empty(cCodRec) .Or. FCodRec(cCodRec)) SIZE 250, 030 OF oDlgCnf COLORS CLR_YELLOW,CLR_BLUE PIXEL
	oSayRec:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)
	oGetRec:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)

    @ 080, 020 SAY oSayBar PROMPT "APONTAMENTO" SIZE 250, 030 OF oDlgCnf COLORS CLR_GREEN,CLR_WHITE PIXEL
    @ 100, 020 MSGET oGetBar VAR cCodBar Valid Iif(FCodBar(@cCodBar,@lSai),Iif(lSai,(Inkey(3),oDlgCnf:End()),.t.),.f.) SIZE 250, 030 OF oDlgCnf COLORS CLR_HGREEN,CLR_BLUE PIXEL
	oSayBar:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)
	oGetBar:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)

	@ 140, 020 SAY oMsgErro PROMPT "" SIZE 250, 030 OF oDlgCnf COLORS CLR_HRED,CLR_WHITE PIXEL
	oMsgErro:oFont := TFont():New('Arial',,22,,.T.,,,,.T.,.F.)

	@ 160, 020 SAY oMsgSuc PROMPT "" SIZE 250, 030 OF oDlgCnf COLORS CLR_GREEN,CLR_WHITE PIXEL
	oMsgSuc:oFont := TFont():New('Arial',,22,,.T.,,,,.T.,.F.)

	@ 180, 200 Button oBtnSair PROMPT "Sair" 			  Size 040, 014 PIXEL OF oDlgCnf Action {||(lSai := .t., oDlgCnf:End())} OF oDlgCnf
	
	oBtnSair:NCLRTEXT		:=	CLR_BLACK
	oGetRec:SetFocus()
	
  	ACTIVATE MSDIALOG oDlgCnf CENTERED
Enddo                                                                
// Finaliza o SmartClient
//Break
Return


Static Function FCodBar(cCodBar,lSai)
Local lOk    := .f.
Local lInicioAponta
Local lFinalAponta  
Local lFinalProd	
Local lExpedicao    
Local cOrdem	:=	Space(06)
Local cItem		:=	Space(02)
Local cSequen	:=	Space(03)
Local cOperacao	:=	Space(02)
Local cRoteiro	:=	Space(02)
Local cProduto	:=	Space(15)
Local nQuant	:=	0
Local nProduz	:=	0
Local nParcial	:=	0

If Empty(cCodBar)
	Return .T.
Endif                 

// Analisando Leitura do Código de Barras

// Primeira Analise - 2 Digitos Finais para Identificar se São Inicio ou Final de Apontamento

lInicioAponta := (Right(AllTrim(cCodBar),2)=='11')		// Inicio Apontamento
lFinalAponta  := (Right(AllTrim(cCodBar),2)=='22')		// Final Apontamento
lFinalOperacao:= (Right(AllTrim(cCodRec),2)=='55')		// Encerra Operacao
lFinalProd	  := (Right(AllTrim(cCodBar),2)=='88')		// Final Producao
//lExpedicao    := (Right(AllTrim(cCodBar),2)=='99')		// APontamento de Expedicao Exige Quantidade Final

If lFinalOperacao
	lFinalAponta := .f.
Endif

// Em Caso de Producao

If lInicioAponta .Or. lFinalAponta .Or. lFinalProd .Or. lFinalOperacao
	cOrdem		:=	Upper(Left(cCodBar,6))
	cItem		:=	SubStr(cCodBar,7,2)
	cSequen		:=	SubStr(cCodBar,9,3)
	cOperacao   :=	SubStr(cCodBar,12,2)
	
	If Empty(cOrdem) .Or. Empty(cItem) .Or. Empty(cSequen) .Or. Empty(cOperacao)
		mErro("Atenção Código de Barras Não Possui Caracteristica Internas Erro(3), Verifique !!!")
		oGetBar:SetFocus()
		Return .f.
	Endif		
Endif

If !lExpedicao .And. !lInicioAponta .And. !lFinalAponta  .And. !lFinalProd .And. !lFinalOperacao
	mErro("Atenção Código de Barras Não Possui Caracteristica Internas Erro(4), Verifique !!!")
	oGetBar:SetFocus()
	Return .f.
Endif

// Irá Efetuar Validacoes Conforme o Tipo de Apontamento
// Baseado no Que Já foi ou Não Lancado na Tabela PWU (Log de Apontamentos)

If !SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cOrdem+cItem+cSequen))
	mErro("Atenção Ordem de Produção " + cOrdem + cItem + " Não Localizada, Verifique !!!")
	oGetBar:SetFocus()
	Return .f.
Endif

If SC2->C2_QUJE >= SC2->C2_QUANT
	mErro("Atenção Ordem de Produção " + cOrdem + cItem + " Já Encerrada, Verifique !!!")
	oGetBar:SetFocus()
	Return .f.
Endif
	
If lSupervisor .And. lInicioAponta

	cQuery := " SELECT * "
	cQuery += " FROM " + RetSqlName("PWU") + " PWU "
	cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
	cQuery += " AND PWU_OP = '" + cOrdem + "' "
	cQuery += " AND PWU_ITEM = '" + cItem + "' "
	cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
	cQuery += " AND PWU_OPERAC = '" + cOperacao + "' "
	cQuery += " AND PWU_RECURS = '" + Left(cCodRec,6) + "' "
	cQuery += " AND PWU_STATUS <> 'C' "
	cQuery += " AND PWU_DTFIM = '' "
	cQuery += " AND D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)

	TCQuery cQuery Alias XQRY0 New
	
	TcSetField("XQRY0", "PWU_DTINI", "D")

	cMsgBox := ''
	While XQRY0->(!Eof())
		cMsgBox += ' Ordem: ' + XQRY0->PWU_OP + ' Operador: ' + XQRY0->PWU_IDOPER + ' - ' + Capital(AllTrim(XQRY0->PWU_NOPERA)) +;
					' de ' + DtoC(XQRY0->PWU_DTINI) + ' as ' + XQRY0->PWU_HRINI + ' Aberto !' +CRLF
			
		XQRY0->(dbSkip(1))
	Enddo
		
	If !Empty(cMsgBox)                                
		If !MsgBox('Abaixo Operações Não Finalizadas neste Recurso/OP:'+CRLF+CRLF+cMsgBox+CRLF+' Deseja Finaliza-las ?',"Operações em Aberto","YESNO")
			XQRY0->(dbCloseArea())
//			Return .f.
		Else
			XQRY0->(dbGoTop())
			While XQRY0->(!Eof())
                // Posiciona-se no Registro da PWU
                   
				LogApon(XQRY0->PWU_ID,;
						XQRY0->PWU_OP,;
						XQRY0->PWU_ITEM,;
						XQRY0->PWU_SEQUEN,;
						XQRY0->PWU_OPERAC,;
						.F.,;
						.T.,;
						.F.,;
						.F.,;
						XQRY0->PWU_IDOPER,;
						XQRY0->PWU_RECURS,;
						XQRY0->PWU_QUANT,;
						0,;
						0,;
						XQRY0->PWU_ROTEIR,;
						XQRY0->PWU_PROD,;
						.F.,;
						'Finaliz.Automatica - Supervisor ' + SRA->RA_MAT + ' - ' + Capital(SRA->RA_NOME))
					XQRY0->(dbSkip(1))
			Enddo
			XQRY0->(dbCloseArea())
			MSuc("SUCESSO * Recurso Localizado Com Sucesso: " + Left(cCodRec,6) + " - " + SH1->H1_DESCRI,3)
			cCodRec:=Space(08)
			cCodBar:=Space(30)
			oGetRec:Refresh()
			oGetBar:Refresh()
			oGetRec:SetFocus()      
			sysRefresh()
			lSai := .f.
			Return .t.
		Endif
	Endif
Endif

lSai := CheckApon(cOrdem,cItem,cSequen,cOperacao,lInicioAponta,lFinalAponta,lFinalProd,lExpedicao,_cIdCracha,Left(cCodRec,6),nQuant,nProduz,nParcial,SC2->C2_ROTEIRO,SC2->C2_PRODUTO,lFinalOperacao)

cCodRec:=Space(08)
cCodBar:=Space(30)
oGetRec:Refresh()
oGetBar:Refresh()
oGetRec:SetFocus()      
sysRefresh()
Return .t.


Static Function CheckApon(cOrdem,cItem,cSequen,cOperacao,lInicioAponta,lFinalAponta,lFinalProd,lExpedicao,_cIdCracha,cRecurso,nQuant,nProduz,nParcial,cRoteiro,cProduto,lFinalOperacao)
Local aArea := GetArea()
Local aOperacoes := {}

cQuery := " SELECT DISTINCT G2_OPERAC "
cQuery += " FROM " + RetSqlName("SG2") + " G2 "
cQuery += " WHERE G2_FILIAL = '" + xFilial("SG2") + "' "
cQuery += " AND G2_PRODUTO = '" + cProduto + "' "
cQuery += " AND G2.D_E_L_E_T_ = '' "
	
cQuery:=ChangeQuery(cQuery)
TCQuery cQuery Alias QRY0 New

While QRY0->(!Eof())
	AAdd(aOperacoes,QRY0->G2_OPERAC)
	
	QRY0->(dbSkip(1))
Enddo

QRY0->(dbCloseArea())

	// Inicio de APontamento
	// A Mesma OP Podera ter Diversos Apontamentos contanto que o Operador Seja Diferente
	// E que o mesmo não possua apontamento em aberto

If lInicioAponta
	cQuery := " SELECT G2_CODIGO "
	cQuery += " FROM " + RetSqlName("SG2") + " G2 "
	cQuery += " WHERE G2_FILIAL = '" + xFilial("SG2") + "' "
	cQuery += " AND G2_CODIGO = '" + cRoteiro + "' "
	cQuery += " AND G2_RECURSO = '" + cRecurso + "' "
	cQuery += " AND G2_PRODUTO = '" + cProduto + "' "
	cQuery += " AND G2_OPERAC = '" + cOperacao + "' "
	cQuery += " AND G2.D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cOperax := QRY0->G2_CODIGO
	
	QRY0->(dbCloseArea())
	
	If Empty(cOperax)	
		mErro("Atenção Não Localizado Cadastro de Operação com os Dados Informados, Verifique !!!")
		Return .f.
	Endif

	cQuery := " SELECT PWU_ID "
	cQuery += " FROM " + RetSqlName("PWU") + " PWU "
	cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
	cQuery += " AND PWU_IDOPER = '" + _cIdCracha + "' "
	cQuery += " AND PWU_OP = '" + cOrdem + "' "
	cQuery += " AND PWU_ITEM = '" + cItem + "' "
	cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
	cQuery += " AND PWU_OPERAC = '" + cOperacao + "' "
	cQuery += " AND PWU_RECURS = '" + cRecurso + "' "
	cQuery += " AND PWU_STATUS <> 'C' "
	cQuery += " AND PWU_ROTEIR = '" + cRoteiro + "' "
	cQuery += " AND PWU_DTFIM = '' "
	cQuery += " AND D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cIdOP	:=	QRY0->PWU_ID
	
	QRY0->(dbCloseArea())
	
	If !Empty(cIdOP)
		mErro("Atenção Existe Apontamento do Mesmo Operador em Aberto para Esta Ordem de Produção " + cOrdem + cItem + ", Verifique !!!")
		Return .f.
	Else
		MSuc("SUCESSO * Inicio de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
	Endif		

	cQuery := " SELECT PWU_ID "
	cQuery += " FROM " + RetSqlName("PWU") + " PWU "
	cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
	cQuery += " AND PWU_IDOPER = '" + _cIdCracha + "' "
	cQuery += " AND PWU_OP = '" + cOrdem + "' "
	cQuery += " AND PWU_ITEM = '" + cItem + "' "
	cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
	cQuery += " AND PWU_OPERAC = '" + cOperacao + "' "
	cQuery += " AND PWU_RECURS = '" + cRecurso + "' "
	cQuery += " AND PWU_ROTEIR = '" + cRoteiro + "' "
	cQuery += " AND PWU_STATUS = 'E' "
	cQuery += " AND D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cIdOP	:=	QRY0->PWU_ID
	
	QRY0->(dbCloseArea())
	
	If !Empty(cIdOP)
		mErro("Atenção Operação Já Encerrada para Esta Ordem de Produção " + cOrdem + cItem + ", Verifique !!!")
		Return .f.
	Endif		

	If cOperacao > '02'	// Se Operacao maior que 01 Impressao, Entao Verifica se as Operacoes Anteriores foram pelo Menos Iniciadas
		lOk := .t.
		For nI := 1 To Len(aOperacoes)                      
			If aOperacoes[nI] < cOperacao
				cQuery := " SELECT PWU_ID "
				cQuery += " FROM " + RetSqlName("PWU") + " PWU "
				cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
				cQuery += " AND PWU_OP = '" + cOrdem + "' "
				cQuery += " AND PWU_ITEM = '" + cItem + "' "
				cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
				cQuery += " AND PWU_OPERAC = '" + aOperacoes[nI] + "' "
				cQuery += " AND PWU_ROTEIR = '" + cRoteiro + "' "
				cQuery += " AND PWU_STATUS NOT IN('R','C') "
				cQuery += " AND D_E_L_E_T_ = '' "
				
				cQuery:=ChangeQuery(cQuery)
				TCQuery cQuery Alias QRY0 New
				
				cIdOP	:=	QRY0->PWU_ID
				
				QRY0->(dbCloseArea())
				
				If Empty(cIdOP)
					lOk := .f.
				Endif
			Endif
		Next
		
		If !lOk
			mErro("Atenção Para Iniciar Uma Operação é Necessário que as Anteriores Sejam Iniciadas Ordem de Produção " + cOrdem + cItem + ", Verifique !!!")
			Return .f.
		Else
			MSuc("SUCESSO * Inicio de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
		Endif		
	Else
		MSuc("SUCESSO * Inicio de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
	Endif

	LogApon(cIdOp,cOrdem,cItem,cSequen,cOperacao,lInicioAponta,lFinalAponta,lFinalProd,lExpedicao,_cIdCracha,cRecurso,nQuant,nProduz,nParcial,cRoteiro,cProduto,lFinalOperacao)

ElseIf lFinalAponta
	// Final de Apontamento
	// Devera Existir Apontamento Inicial desta OP Sem Data de Finalizacao
	// Para o Mesmo Operador, Caso Não Exista então é divergência

	cQuery := " SELECT G2_CODIGO "
	cQuery += " FROM " + RetSqlName("SG2") + " G2 "
	cQuery += " WHERE G2_FILIAL = '" + xFilial("SG2") + "' "
	cQuery += " AND G2_CODIGO = '" + cRoteiro + "' "
	cQuery += " AND G2_RECURSO = '" + cRecurso + "' "
	cQuery += " AND G2_PRODUTO = '" + cProduto + "' "
	cQuery += " AND G2_OPERAC = '" + cOperacao + "' "
	cQuery += " AND G2.D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cOperax := QRY0->G2_CODIGO
	
	QRY0->(dbCloseArea())
	
	If Empty(cOperax)	
		mErro("Atenção Não Localizado Cadastro de Operação com os Dados Informados, Verifique !!!")
		Return .f.
	Endif

	cQuery := " SELECT PWU_ID "
	cQuery += " FROM " + RetSqlName("PWU") + " PWU "
	cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
	cQuery += " AND PWU_IDOPER = '" + _cIdCracha + "' "
	cQuery += " AND PWU_OP = '" + cOrdem + "' "
	cQuery += " AND PWU_ITEM = '" + cItem + "' "
	cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
	cQuery += " AND PWU_OPERAC = '" + cOperacao + "' "
	cQuery += " AND PWU_RECURS = '" + cRecurso + "' "
	cQuery += " AND PWU_ROTEIR = '" + cRoteiro + "' "
	cQuery += " AND PWU_STATUS NOT IN('R','C') "
	cQuery += " AND PWU_DTFIM = '' "
	cQuery += " AND D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cIdOP	:=	QRY0->PWU_ID
	
	QRY0->(dbCloseArea())
	
	If Empty(cIdOP)
		mErro("Atenção Não Existe Apontamento Em Aberto Para Este Operador para Esta Ordem de Produção " + cOrdem + cItem + ", Verifique !!!")
		Return .f.
	Else
		MSuc("SUCESSO * Finalização de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
	Endif		
	
	LogApon(cIdOp,cOrdem,cItem,cSequen,cOperacao,lInicioAponta,lFinalAponta,lFinalProd,lExpedicao,_cIdCracha,cRecurso,nQuant,nProduz,nParcial,cRoteiro,cProduto,lFinalOperacao)
ElseIf lFinalOperacao
	// Encerra Operacao
	// Devera Existir Apontamento Inicial desta OP Sem Data de Finalizacao
	// Para o Mesmo Operador, Caso Não Exista então é divergência

	cQuery := " SELECT G2_CODIGO "
	cQuery += " FROM " + RetSqlName("SG2") + " G2 "
	cQuery += " WHERE G2_FILIAL = '" + xFilial("SG2") + "' "
	cQuery += " AND G2_CODIGO = '" + cRoteiro + "' "
	cQuery += " AND G2_RECURSO = '" + cRecurso + "' "
	cQuery += " AND G2_PRODUTO = '" + cProduto + "' "
	cQuery += " AND G2_OPERAC = '" + cOperacao + "' "
	cQuery += " AND G2.D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cOperax := QRY0->G2_CODIGO
	
	QRY0->(dbCloseArea())
	
	If Empty(cOperax)	
		mErro("Atenção Não Localizado Cadastro de Operação com os Dados Informados, Verifique !!!")
		Return .f.
	Endif

	cQuery := " SELECT PWU_ID "
	cQuery += " FROM " + RetSqlName("PWU") + " PWU "
	cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
	cQuery += " AND PWU_IDOPER = '" + _cIdCracha + "' "
	cQuery += " AND PWU_OP = '" + cOrdem + "' "
	cQuery += " AND PWU_ITEM = '" + cItem + "' "
	cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
	cQuery += " AND PWU_OPERAC = '" + cOperacao + "' "
	cQuery += " AND PWU_RECURS = '" + cRecurso + "' "
	cQuery += " AND PWU_ROTEIR = '" + cRoteiro + "' "
	cQuery += " AND PWU_STATUS NOT IN('R','C') "
//	cQuery += " AND PWU_DTFIM = '' "
	cQuery += " AND D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cIdOP	:=	QRY0->PWU_ID
	
	QRY0->(dbCloseArea())
	
	If Empty(cIdOP)
		mErro("Atenção Não Existe Apontamento Em Aberto Para Este Operador para Esta Ordem de Produção " + cOrdem + cItem + ", Verifique !!!")
		Return .f.
	Else
		MSuc("SUCESSO * Encerramento de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
	Endif		
	
	If cOperacao > '01'	// Se Operacao maior que 01 Impressao, Entao Verifica se as Operacoes Anteriores foram pelo Menos Iniciadas
		lOk := .t.
		For nI := 1 To Len(aOperacoes)                      
			If aOperacoes[nI] < cOperacao
				cQuery := " SELECT PWU_ID "
				cQuery += " FROM " + RetSqlName("PWU") + " PWU "
				cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
				cQuery += " AND PWU_OP = '" + cOrdem + "' "
				cQuery += " AND PWU_ITEM = '" + cItem + "' "
				cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
				cQuery += " AND PWU_OPERAC = '" + aOperacoes[nI] + "' "
				cQuery += " AND PWU_ROTEIR = '" + cRoteiro + "' "
				cQuery += " AND PWU_STATUS = 'E' "
				cQuery += " AND D_E_L_E_T_ = '' "
				
				cQuery:=ChangeQuery(cQuery)
				TCQuery cQuery Alias QRY0 New
				
				xIdOP	:=	QRY0->PWU_ID
				
				QRY0->(dbCloseArea())
				
				If Empty(xIdOP)
					lOk := .f.
				Endif
			Endif
		Next
		
		If !lOk
			mErro("Atenção Para Finalizar Uma Operação é Necessário que as Anteriores Sejam Finalizadas, Ordem de Produção " + cOrdem + cItem + ", Verifique !!!")
			Return .f.
		Else
			MSuc("SUCESSO * Encerramento de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
		Endif		
	Else
		MSuc("SUCESSO * Encerramento de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
	Endif

	LogApon(cIdOp,cOrdem,cItem,cSequen,cOperacao,lInicioAponta,lFinalAponta,lFinalProd,lExpedicao,_cIdCracha,cRecurso,nQuant,nProduz,nParcial,cRoteiro,cProduto,lFinalOperacao)
ElseIf lFinalProd

	// Final Producao

	cQuery := " SELECT DISTINCT G2_CODIGO, G2_PRODUTO, G2_OPERAC, G2_RECURSO, ISNULL(PWU_STATUS,'') PWU_STATUS "
	cQuery += " FROM " + RetSqlName("SG2") + " G2 "
	cQuery += " LEFT JOIN " + RetSqlName("PWU") + " PWU "
	cQuery += " ON PWU_FILIAL = '" + xFilial("PWU") + "' AND PWU_PROD = G2_PRODUTO AND PWU_RECURS = G2_RECURSO AND PWU_OPERAC = G2_OPERAC AND PWU.D_E_L_E_T_ = '' AND PWU.PWU_STATUS NOT IN('C','R') AND PWU.PWU_OP = '" + cOrdem + "' "
	cQuery += " WHERE G2_PRODUTO = '" + cProduto + "' "
	cQuery += " AND G2.D_E_L_E_T_ = '' "
	cQuery += " AND G2_FILIAL = '" + xFilial("SG2") + "' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	lFalha := .f.
	While QRY0->(!Eof())
		If QRY0->PWU_STATUS <> 'E'
			lFalha := .t.
		Endif
		
		QRY0->(dbSkip(1))
	Enddo

	QRY0->(dbCloseArea())

	If lFalha
		mErro("Atenção Todos os Processos de Produção deverão Ser Encerrados Para a Finalização da Produção, Verifique !!!")
		Return .f.
	Endif

	cQuery := " SELECT PWU_ID "
	cQuery += " FROM " + RetSqlName("PWU") + " PWU "
	cQuery += " WHERE PWU_FILIAL = '" + xFilial("PWU") + "' "
	cQuery += " AND PWU_IDOPER = '" + _cIdCracha + "' "
	cQuery += " AND PWU_OP = '" + cOrdem + "' "
	cQuery += " AND PWU_ITEM = '" + cItem + "' "
	cQuery += " AND PWU_SEQUEN = '" + cSequen + "' "
	cQuery += " AND PWU_OPERAC = '" + cOperacao + "' "
	cQuery += " AND PWU_RECURS = '" + cRecurso + "' "
	cQuery += " AND PWU_ROTEIR = '" + cRoteiro + "' "
	cQuery += " AND PWU_STATUS NOT IN('C','R','E') "
	cQuery += " AND D_E_L_E_T_ = '' "
	
	cQuery:=ChangeQuery(cQuery)
	TCQuery cQuery Alias QRY0 New
	
	cIdOP	:=	QRY0->PWU_ID
	
	QRY0->(dbCloseArea())
	
	If !Empty(cIdOP)
		mErro("Atenção Existem Operações Não Encerradas Impossivel Efetuar o Encerramento da Ordem de Produção " + cOrdem + cItem + ", Verifique !!!")
		Return .f.
	Else
		MSuc("SUCESSO * Finalização de Apontamento Para a Ordem de Produção " + cOrdem + cItem,3)
	Endif		
	
	LogApon(cIdOp,cOrdem,cItem,cSequen,cOperacao,lInicioAponta,lFinalAponta,lFinalProd,lExpedicao,_cIdCracha,cRecurso,nQuant,nProduz,nParcial,cRoteiro,cProduto,lFinalOperacao)
Endif
RestArea(aArea)
Return .t.

Static Function LogApon(cIdOp,cOrdem,cItem,cSequen,cOperacao,lInicioAponta,lFinalAponta,lFinalProd,lExpedicao,_cIdCracha,cRecurso,nQuant,nProduz,nParcial,cRoteiro,cProduto,lFinalOperacao,cLog)
Local aArea := GetArea()
Local dData	:=	dDataBase
Local cHora	:=	Left(Time(),5)
Local cPerg1Tit := "Quantidade"
Local cPerg1Pct := "@E 9,999,999.9999"
Local cPerg1Vld := "MV_PAR01>0"
Local cPerg1_F3 := ""
Local cPerg1Whn := ".T."
Local cPerg1Tam := 50
Local cPerg1Obg := .T.
Local lEncerra	:= .F.

Private aPerg   := {}
Private aParam  := {}

DEFAULT cLog	:=	''


SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cOrdem+cItem+cSequen))


mv_par01 := (SC2->C2_QUANT - SC2->C2_QUJE)
xQuant   := (SC2->C2_QUANT - SC2->C2_QUJE)	// Guarda Saldo Original da OP

aAdd(aParam,mv_par01)


aAdd(aPerg	,{	1			,;
				cPerg1Tit	,;
				mv_par01	   ,;
				cPerg1Pct	,;
				cPerg1Vld	,;
				cPerg1_F3	,;
				cPerg1Whn	,;
				cPerg1Tam	,;
				cPerg1Obg	})


SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+cItem))
PWU->(dbSetOrder(1), dbSeek(xFilial("PWU")+cIdOp))

If lInicioAponta
	cIdOp	:=	GetSx8Num("PWU","PWU_ID")
	ConfirmSx8()

	If RecLock("PWU",.t.)   
		PWU->PWU_FILIAL	:=	xFilial("PWU")
		PWU->PWU_ID		:=	cIdOp
		PWU->PWU_DATA	:=	dData
		PWU->PWU_HORA	:=	Left(Time(),5)
		PWU->PWU_OP		:=	cOrdem
		PWU->PWU_ITEM	:=	cItem
		PWU->PWU_SEQUEN	:=	cSequen
		PWU->PWU_OPERAC	:=	cOperacao
		PWU->PWU_ROTEIR	:=	cRoteiro
		PWU->PWU_IDOPER	:=	_cIdCracha
		PWU->PWU_NOPERA	:=	SRA->RA_NOME
		PWU->PWU_RECURS :=  SH1->H1_CODIGO
		PWU->PWU_DTINI	:=	dData
		PWU->PWU_HRINI	:=	Left(Time(),5)
		PWU->PWU_STATUS	:=	'P'    
		PWU->PWU_QUANT	:=	(SC2->C2_QUANT - SC2->C2_QUJE)
		PWU->PWU_CLIENT	:=	SC5->C5_CLIENTE
		PWU->PWU_LOJA	:=	SC5->C5_LOJACLI
		PWU->PWU_PROD	:=	cProduto
		PWU->PWU_PEDIDO	:=	SC5->C5_NUM
		PWU->PWU_ITEMPV	:=	cItem
		PWU->PWU_LOTECT	:=	SC6->C6_LOTECTL
		PWU->PWU_NUMLOT	:=	SC6->C6_NUMLOTE
		PWU->(MsUnlock())
	Endif
ElseIf lFinalAponta
	nDias	:=	Date()-PWU->PWU_DTINI

	If nDias > 0
		nHrInicio := Val(StrTran(PWU->PWU_HRINI,':','.'))      
		nHrAtual  := Val(StrTran(Left(Time(),5),':','.'))      
		nTotHora  := SubHoras(24.0,nHrInicio)
						
						
		nDias--
						
		For nHr := 1 To nDias-1
			nTotHora := SomaHoras(nTotHora,24.00)
		Next
						
		nTotHora := SomaHoras(nTotHora,nHrAtual)
		cDecorrido := StrTran(Str(nTotHora),'.',':')
	Else
		cDecorrido := ELAPTIME(AllTrim(PWU->PWU_HRINI)+':00',Time())
	Endif

	cHrIni := Left(Time(),5)
	cHrSom := '00:03'
	
	If RecLock("PWU",.F.)   
		PWU->PWU_DTFIM	:=	dData
		PWU->PWU_HRFIM	:=	Left(Time(),5)
		PWU->PWU_TEMPO  :=  cDecorrido
		PWU->PWU_DTATE  :=	dDataBase
		PWU->PWU_HRATE	:=	StrTran(StrZero(SomaHoras(cHrIni,cHrSom),5,2),'.',':')
		PWU->PWU_STATUS	:=	'F'    
		PWU->PWU_LOG	:=	cLog
		PWU->(MsUnlock())
	Endif
ElseIf lFinalOperacao	// Encerra Operacao na OP Nâo Permitindo Mais Lançamentos
	nDias	:=	Date()-PWU->PWU_DTINI

	If nDias > 0
		nHrInicio := Val(StrTran(PWU->PWU_HRINI,':','.'))      
		nHrAtual  := Val(StrTran(Left(Time(),5),':','.'))      
		nTotHora  := SubHoras(24.0,nHrInicio)
						
						
		nDias--
						
		For nHr := 1 To nDias-1
			nTotHora := SomaHoras(nTotHora,24.00)
		Next
						
		nTotHora := SomaHoras(nTotHora,nHrAtual)
		cDecorrido := StrTran(Str(nTotHora),'.',':')
	Else
		cDecorrido := ELAPTIME(AllTrim(PWU->PWU_HRINI)+':00',Time())
	Endif

	cHrIni := Left(Time(),5)
	cHrSom := '00:05'

	If RecLock("PWU",.F.)   
		If Empty(PWU->PWU_DTFIM)
			PWU->PWU_DTFIM	:=	dData
			PWU->PWU_HRFIM	:=	cHora
			PWU->PWU_TEMPO  :=  cDecorrido
		Endif
		PWU->PWU_DTATE  :=	dDataBase
		PWU->PWU_HRATE	:=	StrTran(StrZero(SomaHoras(cHrIni,cHrSom),5,2),'.',':')
		PWU->PWU_STATUS	:=	'E'    
		PWU->PWU_LOG	:=	cLog
		PWU->(MsUnlock())
	Endif

	If PWU->(dbSetOrder(2), dbSeek(xFilial("PWU")+cOrdem+cItem+cSequen))
		While PWU->(!Eof()) .And. PWU->PWU_FILIAL == xFilial("PWU") .And. PWU->PWU_OP+PWU->PWU_ITEM+PWU->PWU_SEQUEN == cOrdem+cItem+cSequen
			If PWU->PWU_OPERAC == cOperacao .And. !PWU->PWU_STATUS $ 'C*R'
				If RecLock("PWU",.F.)    
					If Empty(PWU->PWU_DTFIM)
						PWU->PWU_DTFIM	:=	dData
						PWU->PWU_HRFIM	:=	cHora
						PWU->PWU_TEMPO  :=  cDecorrido
					Endif
					PWU->PWU_STATUS	:=	'E'    
					PWU->PWU_LOG	:=	cLog
					PWU->(MsUnlock())
				Endif
			Endif
			PWU->(dbSkip(1))
		Enddo
	Endif		
ElseIf lFinalProd  // Encerra todos os Apontamentos e Efetua o ExecAuto, Antes Abre uma Janela Solicitando ou Não a Quantidade
	If ParamBox(aPerg,"Encerramento Ordem de Produção",@aParam)
		nQuant := MV_PAR01
	Else
		Return
	EndIf
	
	aAponta := {}

	If PWU->(dbSetOrder(2), dbSeek(xFilial("PWU")+PadR(cOrdem,14)+cItem+cSequen))
		Begin Transaction

		While PWU->(!Eof()) .And. PWU->PWU_FILIAL == xFilial("PWU") .And. PWU->PWU_OP+PWU->PWU_ITEM+PWU->PWU_SEQUEN == PadR(cOrdem,14)+cItem+cSequen
			If PWU->PWU_STATUS $ 'C*R'
				PWU->(dbSkip(1));Loop
			Endif
			
			cOperacao 	:= PWU->PWU_OPERAC
			nTot		:= 0
			
			While PWU->(!Eof()) .And. PWU->PWU_FILIAL == xFilial("PWU") .And. PWU->PWU_OP+PWU->PWU_ITEM+PWU->PWU_SEQUEN == PadR(cOrdem,14)+cItem+cSequen .And. ;
										PWU->PWU_OPERAC == cOperacao
				
				If PWU->PWU_STATUS $ 'C*R'
					PWU->(dbSkip(1));Loop
				Endif

				If RecLock("PWU",.f.)
					PWU->PWU_STATUS	:=	'R'
					PWU->PWU_QTDPRD	:=	1
					PWU->PWU_LOG	:=	cLog
					PWU->(MsUnlock())
				Endif       
				
				nTot++
				nRec := PWU->(Recno())
								
				PWU->(dbSkip(1))
			Enddo     
			nTot--
			PWU->(dbGoTo(nRec))
			If RecLock("PWU",.f.)
				PWU->PWU_STATUS	:=	'R'
				PWU->PWU_QTDPRD	:=	nQuant-nTot
				PWU->PWU_LOG	:=	cLog
				PWU->(MsUnlock())
			Endif               
			PWU->(dbSkip(1))
		Enddo
		
		PWU->(dbSetOrder(2), dbSeek(xFilial("PWU")+PadR(cOrdem,14)+cItem+cSequen))
		While PWU->(!Eof()) .And. PWU->PWU_FILIAL == xFilial("PWU") .And. PWU->PWU_OP+PWU->PWU_ITEM+PWU->PWU_SEQUEN == PadR(cOrdem,14)+cItem+cSequen
			SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+AllTrim(PWU->PWU_IDOPER)))
		
			If !PWU->PWU_STATUS $ 'C'
				AAdd(aAponta,{	PWU->PWU_OP+PWU->PWU_ITEM+PWU->PWU_SEQUEN,;
								PWU->PWU_DTINI,;
								PWU->PWU_HRINI,;
								PWU->PWU_DTFIM,;
								PWU->PWU_HRFIM,;
								PWU->PWU_OPERAC,;
								PWU->PWU_QTDPRD,;
								PWU->PWU_PROD,;
								PWU->PWU_OP,;
								Capital(SRA->RA_NOME),;
								PWU->PWU_RECURS})
			Endif
			PWU->(dbSkip(1))
		Enddo
		
		If nQuant < xQuant          
			If MsgNoYes("Efetua o Encerramento da Op com Quantidade Parcial ? ",OemToAnsi('ATENCAO'))
				lEncerra := .T.
			Endif
		Endif

		// Efetua os Lancamentos de Apontamento da Producao

		lOk := .t.
		For nI := 1 To Len(aAponta)                                      
			If !ApontOP(aAponta[nI,9],aAponta[nI,8],aAponta[nI,6],aAponta[nI,2],aAponta[nI,3],aAponta[nI,4],aAponta[nI,5],aAponta[nI,7],cOrdem+cItem+cSequen,aAponta[nI,10],lEncerra,(nI==Len(aAponta)),3,SC2->C2_LOCAL,aAponta[nI,11])
				DisarmTransaction()                 
				lOk := .f.
				Exit
			Endif      
		Next
		
		If lOk
			MsgInfo("Encerramento da Ordem de Produção " + SC2->C2_NUM + SC2->C2_ITEM + " Efetuado Com Sucesso !")
		Else
			MsgStop("Falha no Encerramento da Ordem de Produção " + SC2->C2_NUM + SC2->C2_ITEM + " !")
		Endif
		
		End Transaction	
		
	Endif		
Endif
RestArea(aArea)
Return .t.	

User Function Fim(lSai)
Return .t.




// Dialog Principal


/*
???????????????????????????????????????
???????????????????????????????????????
? ?????????????????????????????????????
??rograma  ?elaSenha ?utor  ?uiz Alberto      ?Data ? 26/06/12   ??
???????????????????????????????????????
??esc.     ?ria tela para digitar senha                                ??
??         ?														  ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/

User Function TelaAOpe(lOk,lEdit)

Local _cSenha 	 := Space(10)
Local cGet3 	 := Space(10)
Local oGet1
Local oGet2
Local oGet3

// Variaveis Private da Funcao
Local oDlg

&& Cria\Valida Parametros
//_CriaSX6()

if lEdit
	DEFINE MSDIALOG oDlg TITLE "Informe Crachá e Senha" FROM 178,181 TO 350,410 PIXEL Style DS_MODALFRAME 
Else
	DEFINE MSDIALOG oDlg TITLE "Informe Crachá" FROM 178,181 TO 285,410 PIXEL Style DS_MODALFRAME 
Endif
oDlg:lEscClose := .F. //N? permite sair ao usuario se precionar o ESC

//	@80,10 MsGet oSen Var cSen Picture "@S40" Valid .T.  PASSWORD Pixel of oDlg
// Cria Componentes Padroes do Sistema
@  001, 002 Say "ID Cracha" Size  030, 008 COLOR CLR_BLACK PIXEL OF oDlg
@  010, 002 MsGet oGet1 Var _cIdCracha Size  084, 009 COLOR CLR_BLACK Picture "@*" PASSWORD PIXEL OF oDlg

if lEdit
	@  025, 002 Say "Senha Atual:" Size 060	, 030 COLOR CLR_BLACK PIXEL OF oDlg
	@  032, 002 MsGet oGet2 Var _cSenha Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  055, 002 Say "Nova Senha:" Size  060, 030 COLOR CLR_BLACK PIXEL OF oDlg
	@  062, 002 MsGet oGet3 Var cGet3 Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  010, 091 Button "OK" Size  023, 012 PIXEL OF oDlg;
	Action(ValidaSenha(_cIdCracha,_cSenha,@lOk,lEdit,cGet3),oDlg:End())
	
	@  032, 091 Button "Cancelar" Size  023, 012 PIXEL OF oDlg;
	Action( lOk:=.F.,Alert("Cancelado pelo administrador!","Aten?o"),oDlg:End())
	
	
Else
	
//	@  025, 002 Say "Senha:" Size  018, 007 COLOR CLR_BLACK PIXEL OF oDlg
//	@  032, 002 MsGet oGet2 Var _cSenha Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  010, 091 Button "OK" Size  023, 012 PIXEL OF oDlg;
	Action(ValidaSenha(_cIdCracha,_cSenha,@lOk,lEdit),oDlg:End())
	
	@  032, 091 Button "Cancelar" Size  023, 012 PIXEL OF oDlg;
	Action( lOk:=.F.,Alert("Cancelado pelo administrador!","Aten?o"),oDlg:End())
	
	
Endif


ACTIVATE MSDIALOG oDlg CENTERED

Return(lOk)

/*
?????????????????????????????????????
 ????????????????????????????????????
?esc      ?Valida senha e Usuario   Luiz Alberto em 26-06-2012        ?
?????????????????????????????????????
?????????????????????????????????????
*/
Static Function ValidaSenha( _cIdCracha, xcSenha,lOk,lEdit ,cGet3)

Local cSenhax_ :='admin' // GetMv("MV_METPSSW")
Local cUserx_  :='administrator' //GetMv("MV_METUSER")
Local _axUser:={}

_cIdCracha := PadR(_cIdCracha,06)

if lEdit .And. !Empty(_cIdCracha)
	_axUser:=Separa( cUserx_,";",.T.)
	
	If !SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+_cIdCracha))	//+xcSenha
		Alert("Cracha Não Localizado!","Atencao")
		lOk:=.F.
		Return lOk				
	Endif
ElseIf !Empty(_cIdCracha)
	IF Alltrim(xcSenha)  == Alltrim(cSenhax_)
		lOk:=.T.
		Return lOk
	Else            
		If !SRA->(dbSetOrder(1), dbSeek(xFilial("SRA")+_cIdCracha))	//+xcSenha
			Alert("Cracha Não Localizado!","Atencao")
			lOk:=.F.
			Return lOk				
		Else
			If !SRA->RA_CODFUNC$'00001'	// Cargo funcionario
				Alert("Atenção Apenas Supervisores Poderão Efetuar Estornos de Apontamentos !","Atencao")
				lOk:=.F.
			Else
				lOk := .t.
			Endif
			If !Empty(SRA->RA_DEMISSA)	// Cargo funcionario
				Alert("Atenção Funcionario Demitido !","Atencao")
				lOk:=.F.
			Else
				lOk := .t.
			Endif
			Return lOk
		Endif
	Endif
Endif
Return



Static Function MErro(cTxt,nTempo)
DEFAULT cTxt := 'Msg Erros: '
DEFAULT nTempo := 1

oMsgErro:cCaption := Capital(cTxt)
oMsgErro:Refresh()
oMsgSuc:cCaption := ''
oMsgSuc:Refresh()
DlgRefresh(oDlgCnf)

Return .t.


Static Function MSuc(cTxt,nTempo)
DEFAULT cTxt := 'Sucesso: '
DEFAULT nTempo := 1

oMsgSuc:cCaption := Capital(cTxt)
oMsgErro:cCaption := ''
oMsgErro:Refresh()
oMsgSuc:Refresh()
DlgRefresh(oDlgCnf)               

Return .t.

Static Function FCodRec(cCodRec)
Local aArea := GetArea()

If !SH1->(dbSetOrder(1), dbSeek(xFilial("SH1")+Left(cCodRec,6)))
	mErro("Recurso Não Localizado no Cadastro " + Left(cCodRec,6) + ", Verifique !!!")
	Return .f.
Else          


	MSuc("SUCESSO * Recurso Localizado Com Sucesso: " + Left(cCodRec,6) + " - " + SH1->H1_DESCRI,3)
Endif		
Return .t.
	



Static Function ApontOP(cOP,cProd,cOperac,dDtIni,cHrIni,dDtFim,cHrFim,nQtde,cChave,cOperador,lEncerra,lUltima,nOpcao,cLocal,cRecurso)
Local aLinha := {}
Local dDtValid := CTOD("  /  /  ")
Private nRegSH6 := 0

SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+cChave))
SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProd))
SH6->(dbSetOrder(1), dbSeek(xFilial("SH6")+cChave))

nRegSH6 := SH6->(Recno())

dDtValid := dDatabase + SB1->B1_PRVALID
//	{"H6_DTVALID",dDtValid,NIL},;

aLinha := {	{"H6_OP",cChave,NIL},;
	{"H6_PRODUTO",cProd,NIL},;
	{"H6_OPERAC",cOperac,NIL},;
	{"H6_RECURSO",cRecurso,NIL},;
	{"H6_DATAINI",dDtIni,NIL},;
	{"H6_HORAINI",cHrIni,NIL},;
	{"H6_DATAFIN",dDtFim,NIL},;
	{"H6_HORAFIN",cHrFim,NIL},;
	{"H6_QTDPROD",nQtde,NIL},;
	{"H6_OPERADO",cOperador,NIL},;
	{"H6_LOCAL"  ,cLocal,NIL},;
	{"H6_DTAPONT",Date(),NIL} }

lMsErroAuto := .f.

MSExecAuto({|x,y| Mata681(x,y)},aLinha,nOpcao)

If lMsErroAuto
	MostraErro()
	Return .f.
Endif      

If lEncerra .And. lUltima .And. (nOpcao==3)		// Apontamento Parcial Porém Encerra OP
	nOpc := 7 // Encerra ordem de produção
	aMata680 := {}
	aadd(aMata680,{"H6_OP" , SH6->H6_OP ,NIL})
	aadd(aMata680,{"H6_PRODUTO" , SH6->H6_PRODUTO ,NIL})
	aadd(aMata680,{"H6_SEQ" , SH6->H6_SEQ ,NIL})

	lMsErroAuto := .f.
	MsExecAuto({|x,Y|MATA680(aMata680,nOpc)})
	If lMsErroAuto
		MostraErro()
		Return .f.
	Endif      
Endif
Return .t.